{
  programs.tmux = {
    enable = true;
    mouse = true;
    focusEvents = true;
    escapeTime = 0;
    historyLimit = 50000;
    keyMode = "vi";
    terminal = "tmux-256color";

    extraConfig = ''
      set-option -ag terminal-overrides ",$TERM:RGB"
      set -as terminal-overrides ',*:Smulx=\E[4::%p1%dm'
      set -as terminal-overrides ',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'
      # let inner programs (euporie, kitty graphics) send escape sequences
      # straight to the outer terminal
      set -g allow-passthrough on
      # forward extended key encodings (CSI-u/kitty protocol) so inner apps
      # can distinguish e.g. Shift+Enter from Enter; tmux only uses the
      # encoding for terminals declared to support it (extkeys), and
      # xterm* matches Ghostty's xterm-ghostty
      set -s extended-keys on
      set -as terminal-features 'xterm*:extkeys'
    '';
  };
}
