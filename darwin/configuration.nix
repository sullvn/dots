{ config, pkgs, lib, ... }:

let
  san-francisco-mono = pkgs.callPackage ./san-francisco-mono.nix {};
  yabai = pkgs.yabai.overrideAttrs (o: rec {
    # WARNING: Hash must be changed as well as version. Otherwise the cache will prevent a real update.
    version = "5.0.2";
    src = builtins.fetchTarball {
      url = "https://github.com/koekeishiya/yabai/releases/download/v${version}/yabai-v${version}.tar.gz";
      sha256 = "13q8awbmp2vb1f9iycbvlfd5c2fmk5786cwm40bv6zwi4w8bplgy";
    };
    phases = ["unpackPhase" "installPhase"];
    installPhase = ''
      mkdir -p $out/bin
      mkdir -p $out/share/man/man1/
      cp ./bin/yabai $out/bin/yabai
      cp ./doc/yabai.1 $out/share/man/man1/yabai.1
    '';
  });
in
{
  imports = [ <home-manager/nix-darwin> ];

  nix = {
    package = pkgs.nix;
    configureBuildUsers = true;

    # Fix root channel path errors
    #
    # https://github.com/LnL7/nix-darwin/issues/145#issuecomment-751423168
    #
    nixPath = pkgs.lib.mkForce [{
      darwin-config = builtins.concatStringsSep ":" [
        "$HOME/.config/nixpkgs/darwin/configuration.nix"
        "$HOME/.nix-defexpr/channels"
      ];
    }];
  };
  nixpkgs.config.allowUnfree = true;

  environment = {
    # Required afterwards:
    # $ chsh -s /run/current-system/sw/bin/fish
    shells = [ pkgs.fish ];

    variables = {
      EDITOR = "hx";
    };

    systemPackages = with pkgs; [
      libiconv
      alacritty
    ];

    # Required afterwards:
    #
    #     sudo chown root:wheel /etc/static/sudoers.d/yabai
    #
    # environment.etc.yabai = {
    #   target = "sudoers.d/yabai";
    #   text = "kevin ALL = (root) NOPASSWD: ${yabai}/bin/yabai --load-sa
    #   ";
    # };
    etc.yabai = {
      target = "sudoers.d/yabai";
      text = "kevin ALL = (root) NOPASSWD: /usr/local/bin/yabai --load-sa
      ";
    };

    # Use a custom configuration.nix location.
    # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
    darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";
  };

  fonts = {
    fontDir.enable = true;
    fonts = [
      san-francisco-mono
    ];
  };

  networking = {
    hostName = "sullvn";
    knownNetworkServices = [
      "Wi-Fi"
      "Bluetooth PAN"
      "Thunderbolt Bridge"
    ];

    # CloudFlare
    dns = [
      "1.1.1.1"
      "1.0.0.1"
      "2606:4700:4700::1111"
      "2606:4700:4700::1001"
    ];
  };

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.fish = {
    enable = true;
    useBabelfish = true;
    babelfishPackage = pkgs.babelfish;
  };

  system = {
    defaults = {
      dock = {
        autohide = true;
        mru-spaces = false;
        orientation = "left";
        show-process-indicators = false;
        show-recents = false;
        static-only = true;
        tilesize = 56;
      };
      trackpad.Clicking = true;
    };
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
    };

    # Disable startup sound. No Nix setting yet
    #
    #    sudo nvram StartupMute=%01
    #
  };


  home-manager.useUserPackages = true;
  home-manager.users.kevin = { pkgs, ... }: {
    programs.home-manager.enable = true;
    home.stateVersion = "22.05";
    nixpkgs.config.allowUnfree = true;

    home.packages = with pkgs; [
      bat
      exa
      fd
      ffmpeg
      fzf
      git
      git-lfs
      hexyl
      mosh
      netcat
      nmap
      pastel
      ripgrep
      rnix-lsp
      up
    ];

    home.file.".hushlogin".text = "";

    programs.helix = {
      enable = true;
      settings = {
        theme = "catppuccin_macchiato";
        editor = {
          auto-save = true;
          bufferline = "multiple";
          cursorline = true;
          indent-guides.render = true;
          cursor-shape.insert = "bar";
        };
      };
    };

    programs.starship = {
      enable = true;
      enableFishIntegration = true;
      settings = {
        gcloud.disabled = true;
        nix_shell.disabled = true;
        nodejs.disabled = true;
        package.disabled = true;
        rust.disabled = true;
        git_branch.symbol = "";
      };
    };

    programs.fish = {
      enable = true;
      functions.fish_greeting = "";
      shellAliases = {
        ls = "exa";
      };
      shellInit = ''
        fish_vi_key_bindings

        #
        # NOTE: Not clear where these came from?
        #
        set -g fish_color_autosuggestion '555'  'brblack'
        set -g fish_color_cancel -r
        set -g fish_color_command --bold
        set -g fish_color_comment red
        set -g fish_color_cwd green
        set -g fish_color_cwd_root red
        set -g fish_color_end brmagenta
        set -g fish_color_error brred
        set -g fish_color_escape 'bryellow'  '--bold'
        set -g fish_color_history_current --bold
        set -g fish_color_host normal
        set -g fish_color_match --background=brblue
        set -g fish_color_normal normal
        set -g fish_color_operator bryellow
        set -g fish_color_param cyan
        set -g fish_color_quote yellow
        set -g fish_color_redirection brblue
        set -g fish_color_search_match 'bryellow'  '--background=brblack'
        set -g fish_color_selection 'white'  '--bold'  '--background=brblack'
        set -g fish_color_user brgreen
        set -g fish_color_valid_path --underline
      '';
    };

    programs.git = {
      enable = true;
      userName = "Kevin Sullivan";
      userEmail = "kevin@sull.vn";
    };

    programs.tmux = {
      enable = true;
      keyMode = "vi";
      historyLimit = 50000;
      escapeTime = 0;

      #
      # Default terminal
      #
      # Needs to be derivative "screen"
      # or "tmux", but we've had issues
      # with "screen".
      #
      # See Tmux man page and [this Gist][0].
      #
      # MacOS includes an old terminfo
      # database, so you'll need to add
      # `tmux-256color` [terminfo manually][1].
      #
      # [0]: https://gist.github.com/andersevenrud/015e61af2fd264371032763d4ed965b6
      # [1]: https://gist.github.com/nicm/ea9cf3c93f22e0246ec858122d9abea1
      #
      terminal = "tmux-256color";
      extraConfig = ''
        set-option -g mouse on
        set-option -ag terminal-overrides ",$TERM:RGB"
      '';
    };

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    programs.alacritty = {
      enable = true;
      settings = {
        window = {
          padding.x   = 8;
          padding.y   = 8;
          decorations = "none";
          title       = "Terminal";
        };
        font = {
          size               = 14;
          normal.family      = "SF Mono";
          bold.style         = "Semibold";
          italic.style       = "Italic";
          bold_italic.style  = "Semibold Italic";
        };
        # Colors - Eqie6
        colors = {
          primary = {
            background = "#211111";
            foreground = "#cccccc";
          };
          normal = {
            black   = "#222222";
            red     = "#e84f4f";
            green   = "#b7ce42";
            yellow  = "#fea63c";
            blue    = "#66a9b9";
            magenta = "#b7416e";
            cyan    = "#6d878d";
            white   = "#cccccc";
          };
          bright = {
            black   = "#666666";
            red     = "#d23d3d";
            green   = "#bde077";
            yellow  = "#ffe863";
            blue    = "#aaccbb";
            magenta = "#e16a98";
            cyan    = "#42717b";
            white   = "#ffffff";
          };
        };
        draw_bold_text_with_bright_colors = false;
        mouse.hide_when_typing = true;
        # env.TERM = "xterm-256color";
      };
    };
  };

  # System integrity needs to be disabled
  services.yabai = {
    enable = true;
    package = yabai;
    #
    # Broken in MacOS 11
    #
    # enableScriptingAddition = true;
    #
    config = {
      layout         = "bsp";
      top_padding    = 5;
      bottom_padding = 5;
      left_padding   = 5;
      right_padding  = 5;
      window_gap     = 5;
    };
  };

  services.skhd = {
    enable = true;
    skhdConfig = "
      # Focus window left/right/down/right
      alt - k : yabai -m window --focus north
      alt - l : yabai -m window --focus east
      alt - j : yabai -m window --focus south
      alt - h : yabai -m window --focus west
      
      # Move window left/right/up/down
      shift + alt - k : yabai -m window --swap north
      shift + alt - l : yabai -m window --swap east
      shift + alt - j : yabai -m window --swap south
      shift + alt - h : yabai -m window --swap west
      
      # Focus prev/next space
      alt - u : yabai -m space --focus prev
      alt - i : yabai -m space --focus next
      
      # Move space next/prev
      shift + alt - u : yabai -m space --move prev
      shift + alt - i : yabai -m space --move next
      
      # Move window next/prev space
      shift + alt - n : yabai -m window --space prev
      shift + alt - m : yabai -m window --space next
      
      # Create/delete space
      cmd + alt - o : yabai -m space --create
      shift + cmd + alt - o : yabai -m space --destroy

      # Focus display next/prev
      alt - e : yabai -m display --focus prev
      alt - r : yabai -m display --focus next
      
      # Toggle native fullscreen
      alt - f : yabai -m window --toggle native-fullscreen
      
      # Toggle float
      alt - t : yabai -m window --toggle float
      
      # Toggle sticky
      alt - s : yabai -m window --toggle sticky
      
      # Toggle picture-in-picture
      alt - p : yabai -m window --toggle pip

      # Toggle picture-in-picture
      alt - y : yabai -m window --toggle topmost
      
      # Close window
      shift + cmd + alt - l : yabai -m window --close

      # Terminal
      alt - space : open --new ~/Applications/Home\\ Manager\\ Apps/Alacritty.app
    ";
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
