{ config, pkgs, ... }:

let
  san-francisco-mono = pkgs.callPackage ./san-francisco-mono.nix { };
  vscode-with-extensions = pkgs.vscode-with-extensions.override {
    vscodeExtensions = (with pkgs.vscode-extensions; [
      ms-vscode-remote.remote-ssh
    ]) ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [{
      name = "mayukaithemevsc";
      publisher = "GulajavaMinistudio";
      version = "1.5.1";
      sha256 = "13pagsv3dnfp8bmnbwaz1vf7lq345lx9956vznkacbdjrnsbngnh";
    }];
  };
in
{
  imports = [ <home-manager/nix-darwin> ];

  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [];

  fonts.enableFontDir = true;
  fonts.fonts = [
    san-francisco-mono
  ];

  networking.hostName = "sullvn";
  # CloudFlare
  networking.dns = [
    "1.1.1.1"
    "1.0.0.1"
    "2606:4700:4700::1111"
    "2606:4700:4700::1001"
  ];
  networking.knownNetworkServices = [
    "Wi-Fi"
    "Bluetooth PAN"
    "Thunderbolt Bridge"
  ];

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  # services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.fish.enable = true;

  system.defaults.dock.orientation = "left";
  system.defaults.dock.static-only = true;
  system.defaults.dock.autohide = true;
  system.defaults.dock.show-process-indicators = false;
  system.defaults.dock.tilesize = 64;

  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = true;


  # Required afterwards:
  # $ chsh -s /run/current-system/sw/bin/fish
  environment.shells = [ pkgs.fish ];
  home-manager.useUserPackages = true;
  home-manager.users.kevin = { pkgs, ... }: {
    home.packages = (with pkgs; [
      tmux
      git
      neovim
      starship
    ]) ++ [
      vscode-with-extensions
    ];
    nixpkgs.config.allowUnfree = true;

    programs.home-manager.enable = true;
    programs.fish = {
      enable = true;
      promptInit = "starship init fish | source";
      functions.fish_greeting = "";
      shellInit = "
        fish_vi_key_bindings

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
      ";
    };
    programs.git = {
      enable = true;
      userName = "Kevin Sullivan";
      userEmail = "kevin@sull.vn";
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
	  size               = 10;
	  normal.family      = "SF Mono";
	  bold.style         = "Semibold";
	  italic.style       = "Italic";
	  bold_italic.style  = "Semibold Italic";
	  use_thin_strokes   = false;
	};
	colors = {
          primary = {
            background = "0x282a36";
            foreground = "0xe2e4e5";
	  };
          cursor = {
            text   = "0x282a36";
            cursor = "0xe2e4e5";
	  };
          normal = {
            black   = "0x282a36";
            red     = "0xff5c57";
            green   = "0x5af78e";
            yellow  = "0xf3f99d";
            blue    = "0x57c7ff";
            magenta = "0xff6ac1";
            cyan    = "0x9aedfe";
            white   = "0xe2e4e5";
	  };
          bright = {
            black   = "0x78787e";
            red     = "0xff9f43";
            green   = "0x34353e";
            yellow  = "0x43454f";
            blue    = "0xa5a5a9";
            magenta = "0xeff0eb";
            cyan    = "0xb2643c";
            white   = "0xf1f1f0"; 
	  };
	};
	draw_bold_text_with_bright_colors = false;
	mouse.hide_when_typing = true;
      };
    };
  };

  # System integrity needs to be disabled
  services.yabai = {
    enable = true;
    package = pkgs.yabai;
    enableScriptingAddition = true;
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
      
      # Toggle native fullscreen
      alt - f : yabai -m window --toggle native-fullscreen
      
      # Toggle float
      alt - t : yabai -m window --toggle float
      
      # Toggle sticky
      alt - s : yabai -m window --toggle sticky
      
      # Toggle picture-in-picture
      alt - p : yabai -m window --toggle pip
      
      # Close window
      shift + cmd + alt - l : yabai -m window --close

      # Terminal
      alt - space : alacritty
    ";
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
