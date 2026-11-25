{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

let
  llm-agents = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};

  # Pairing helper for the codex-rc unit; see codex-pair.js for why this exists.
  codex-pair = pkgs.writers.writeJSBin "codex-pair" { } (builtins.readFile ./codex-pair.js);
in
{
  home.packages = [
    llm-agents.codex
    llm-agents.pi
    codex-pair
  ];

  systemd.user.services.claude-rc = {
    Unit = {
      Description = "Claude Code Remote Control bridge";
      After = [ "ssh-agent.service" ];
      Wants = [ "ssh-agent.service" ];
      # leave a live bridge alone during nixos-rebuild switch
      X-SwitchMethod = "keep-old";
    };

    Service = {
      Type = "exec";
      WorkingDirectory = "${config.home.homeDirectory}/sull.vn";
      ExecStart = "${config.programs.direnv.package}/bin/direnv exec ${config.home.homeDirectory}/sull.vn ${lib.getExe llm-agents.claude-code} rc --spawn=worktree";
      Environment = [
        "SSH_AUTH_SOCK=%t/ssh-agent"
        "NO_COLOR=1"
      ];
      Restart = "always";
      RestartSec = 10;
    };

    Install.WantedBy = [ "default.target" ];
  };

  systemd.user.services.codex-rc = {
    Unit = {
      Description = "Codex Remote Control bridge";
      After = [ "ssh-agent.service" ];
      Wants = [ "ssh-agent.service" ];
      X-SwitchMethod = "keep-old";
      StartLimitIntervalSec = 300;
      StartLimitBurst = 5;
    };

    Service = {
      Type = "exec";
      WorkingDirectory = "${config.home.homeDirectory}/sull.vn";
      ExecStart = "${config.programs.direnv.package}/bin/direnv exec ${config.home.homeDirectory}/sull.vn ${lib.getExe llm-agents.codex} remote-control";
      Environment = [
        "SSH_AUTH_SOCK=%t/ssh-agent"
        "NO_COLOR=1"
      ];
      KillSignal = "SIGINT";
      Restart = "always";
      RestartSec = 10;
    };

    Install.WantedBy = [ "default.target" ];
  };
}
