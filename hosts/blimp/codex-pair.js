#!/usr/bin/env node
// codex-pair: print a ChatGPT-mobile pairing code for this machine.
// Asks the running `codex remote-control` process (the codex-rc user unit),
// over the private unix socket it listens on. Needed because `codex remote-control pair`
// only talks to the managed daemon, which the Nix-packaged codex cannot start.
// Built into a `codex-pair` command by remote-control.nix (pkgs.writers.writeJSBin).
const net = require('net'), crypto = require('crypto'), fs = require('fs'), path = require('path');

function candidateSockets() {
  const out = [];
  for (const d of fs.readdirSync('/tmp')) {
    if (!d.startsWith('codex-rc-')) continue;
    const p = path.join('/tmp', d, 'rc.sock');
    try { if (fs.statSync(p).isSocket()) out.push(p); } catch {}
  }
  return out;
}

function wsConnect(sockPath, wsPath) {
  return new Promise((resolve, reject) => {
    const s = net.connect(sockPath);
    const key = crypto.randomBytes(16).toString('base64');
    let buf = Buffer.alloc(0), upgraded = false;
    const handlers = [];
    function send(op, payload) {
      const mask = crypto.randomBytes(4), len = payload.length; let hdr;
      if (len < 126) hdr = Buffer.from([0x80 | op, 0x80 | len]);
      else if (len < 65536) { hdr = Buffer.alloc(4); hdr[0] = 0x80 | op; hdr[1] = 0x80 | 126; hdr.writeUInt16BE(len, 2); }
      else { hdr = Buffer.alloc(10); hdr[0] = 0x80 | op; hdr[1] = 0x80 | 127; hdr.writeBigUInt64BE(BigInt(len), 2); }
      const m = Buffer.alloc(len); for (let i = 0; i < len; i++) m[i] = payload[i] ^ mask[i & 3];
      s.write(Buffer.concat([hdr, mask, m]));
    }
    const ws = { sendText: t => send(1, Buffer.from(t)), onMessage: h => handlers.push(h),
      close: () => { try { send(8, Buffer.alloc(0)); } catch {} s.end(); } };
    s.on('error', reject);
    s.on('connect', () => s.write(`GET ${wsPath} HTTP/1.1\r\nHost: localhost\r\nUpgrade: websocket\r\nConnection: Upgrade\r\nSec-WebSocket-Key: ${key}\r\nSec-WebSocket-Version: 13\r\n\r\n`));
    s.on('data', d => {
      buf = Buffer.concat([buf, d]);
      if (!upgraded) {
        const i = buf.indexOf('\r\n\r\n'); if (i < 0) return;
        const head = buf.subarray(0, i).toString(); buf = buf.subarray(i + 4);
        if (!/^HTTP\/1\.1 101/.test(head)) { s.destroy(); reject(new Error(`${wsPath}: ${head.split('\r\n')[0]}`)); return; }
        upgraded = true; resolve(ws);
      }
      while (buf.length >= 2) {
        const op = buf[0] & 0x0f; let len = buf[1] & 0x7f, off = 2;
        if (len === 126) { if (buf.length < 4) return; len = buf.readUInt16BE(2); off = 4; }
        else if (len === 127) { if (buf.length < 10) return; len = Number(buf.readBigUInt64BE(2)); off = 10; }
        if (buf.length < off + len) return;
        const payload = buf.subarray(off, off + len); buf = buf.subarray(off + len);
        if (op === 1) handlers.forEach(h => h(payload.toString()));
        else if (op === 9) send(0xA, payload);
        else if (op === 8) s.end();
      }
    });
  });
}

(async () => {
  const socks = candidateSockets();
  if (!socks.length) throw new Error('no /tmp/codex-rc-*/rc.sock found. Is the codex-rc user unit running?');
  let ws, lastErr;
  outer: for (const sp of socks) for (const wp of ['/', '/rpc']) {
    try { ws = await wsConnect(sp, wp); break outer; } catch (e) { lastErr = e; }
  }
  if (!ws) throw lastErr;
  let id = 0; const pending = new Map();
  ws.onMessage(t => { let m; try { m = JSON.parse(t); } catch { return; }
    if (m.id !== undefined && pending.has(m.id)) { pending.get(m.id)(m); pending.delete(m.id); } });
  const req = (method, params) => new Promise((res, rej) => {
    const i = ++id;
    pending.set(i, m => m.error ? rej(new Error(`${method}: ${m.error.message}`)) : res(m.result));
    ws.sendText(JSON.stringify({ id: i, method, params }));
    setTimeout(() => { if (pending.has(i)) { pending.delete(i); rej(new Error(`${method}: timeout`)); } }, 30000);
  });
  await req('initialize', { clientInfo: { name: 'codex-pair', title: 'codex-pair', version: '1' }, capabilities: { experimentalApi: true } });
  ws.sendText(JSON.stringify({ method: 'initialized' }));
  const st = await req('remoteControl/status/read', {});
  if (st.status !== 'connected') throw new Error(`remote control on ${st.serverName} is "${st.status}", not connected`);
  const p = await req('remoteControl/pairing/start', { manualCode: true });
  console.log(`Manual pairing code: ${p.manualPairingCode}`);
  console.log(`Expires: ${new Date(p.expiresAt * 1000).toLocaleString()} (${Math.round((p.expiresAt * 1000 - Date.now()) / 60000)} min)`);
  console.log(`Machine: ${st.serverName}   Environment: ${p.environmentId}`);
  console.log('ChatGPT app -> Codex -> add a device -> "Pair manually" -> enter the code.');
  ws.close();
})().catch(e => { console.error('Error:', e.message); process.exitCode = 1; }).finally(() => setTimeout(() => process.exit(), 500));
