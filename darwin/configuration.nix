{ config, pkgs, lib, ... }:

let
  san-francisco-mono = pkgs.callPackage ./san-francisco-mono.nix {};
  # bottom = pkgs.callPackage ./bottom.nix {};
  #
  # TODO: /Users/kevin/.config/spotify-tui/client.yml
  #
  spotifydConfig.global = {
    username = "awkwardaxolotl";
    use_keyring = true;
    backend = "portaudio";
    volume_controller = "softvol";
    device_name = "Macbook";
    bitrate = 320;
    device_type = "computer";
  };
  spotifydConfigFile = pkgs.writeText "spotifyd.conf" "${lib.generators.toINI {} spotifydConfig}";
  yabai = pkgs.yabai.overrideAttrs (o: rec {
    # WARNING: Hash must be changed as well as version. Otherwise the cache will prevent a real update.
    version = "3.3.10";
    src = builtins.fetchTarball {
      url = "https://github.com/koekeishiya/yabai/releases/download/v${version}/yabai-v${version}.tar.gz";
      sha256 = "025ww9kjpy72in3mbn23pwzf3fvw0r11ijn1h5pjqvsdlak91h9i";
    };

    installPhase = ''
      mkdir -p $out/bin
      mkdir -p $out/share/man/man1/
      cp ./archive/bin/yabai $out/bin/yabai
      cp ./archive/doc/yabai.1 $out/share/man/man1/yabai.1
    '';
  });
  nvim-cmp = pkgs.vimUtils.buildVimPlugin {
    name = "nvim-cmp";
    src = pkgs.fetchFromGitHub {
      owner = "hrsh7th";
      repo = "nvim-cmp";
      rev = "b6b15d5f6e46643462b5e62269e7babdab17331c";
      sha256 = "1hd4af1y2bcb84jcv31xv7p4psgq6skw7llhfrgqkjgrj6wds76k";
    };
    buildPhase = ":";
  };
  nvim-cmp-lsp = pkgs.vimUtils.buildVimPlugin {
    name = "cmp-nvim-lsp";
    src = pkgs.fetchFromGitHub {
      owner = "hrsh7th";
      repo = "cmp-nvim-lsp";
      rev = "f6f471898bc4b45eacd36eef9887847b73130e0e";
      sha256 = "1asr32w5q618pqggq9jwrbqs4kjp3ssbw5pca5wc7j2496vm2lhg";
    };
    buildPhase = ":";
  };
  nvim-lsp-extensions = pkgs.vimUtils.buildVimPlugin {
    name = "lsp_extensions.nvim";
    src = pkgs.fetchFromGitHub {
      owner = "nvim-lua";
      repo = "lsp_extensions.nvim";
      rev = "379a935b797f5f8a386bcbfd3b105da8007a9303";
      sha256 = "05q9i93xvp5p770fpg8wkyngq8ncr6b21fdkh9crcgfi1bp7rhqr";
    };
  };
  nvim-rust-tools = pkgs.vimUtils.buildVimPlugin {
    name = "rust-tools.nvim";
    src = pkgs.fetchFromGitHub {
      owner = "simrat39";
      repo = "rust-tools.nvim";
      rev = "cd5105d76fc124634b53039c02ea253cc06bc9b9";
      sha256 = "1bhjzng02yfnlfr3kvh6lkl5vbpcmcd51kpgg7yjxmlzlga5k2k3";
    };
  };
  nvim-vsnip = pkgs.vimUtils.buildVimPlugin {
    name = "vim-vsnip";
    src = pkgs.fetchFromGitHub {
      owner = "hrsh7th";
      repo = "vim-vsnip";
      rev = "87d144b7451deb3ab55f1a3e3c5124cfab2b02fa";
      sha256 = "17gw992xvxsa6wyirah17xbsdi2gl4lif8ibvbs7dwagnkv01vyb";
    };
  };
  nvim-ayu-theme = pkgs.vimUtils.buildVimPlugin {
    name = "ayu-vim";
    src = pkgs.fetchFromGitHub {
      owner = "ayu-theme";
      repo = "ayu-vim";
      rev = "0745635421688ce777f663d13531996cb4da6514";
      sha256 = "0w7ixhz72g3lr1hkn450k6x8sdgv95pp6pxbykka3s01i506rzmj";
    };
  };
  nvim-lsp-saga = pkgs.vimUtils.buildVimPlugin {
    name = "lspsaga.nvim";
    src = pkgs.fetchFromGitHub {
      owner = "glepnir";
      repo = "lspsaga.nvim";
      rev = "cb0e35d2e594ff7a9c408d2e382945d56336c040";
      sha256 = "0ywhdgh6aqs0xlm8a4d9jhkik254ywagang12r5nyqxawjsmjnib";
    };
  };
  nvim-plenary = pkgs.vimUtils.buildVimPlugin {
    name = "plenary.nvim";
    src = pkgs.fetchFromGitHub {
      owner = "nvim-lua";
      repo = "plenary.nvim";
      rev = "06266e7bf675ba9af887fb6d1661b289fdd9bcf4";
      sha256 = "02c1y9ygzq8fmcgy7l4khpb141v2fww3gbl8vf0ds2f70zgglxs4";
    };
    buildPhase = ":";
  };
  nvim-telescope = pkgs.vimUtils.buildVimPlugin {
    name = "telescope.nvim";
    src = pkgs.fetchFromGitHub {
      owner = "nvim-telescope";
      repo = "telescope.nvim";
      rev = "12a44ededa1fc2426d40886feb4034230759a19a";
      sha256 = "0h2idrbi8ahldvgrlcl6hi5bjm2gwd4raz3k7mc3k34vmfk3r29z";
    };
    buildPhase = ":";
  };
in
{
  imports = [ <home-manager/nix-darwin> ];

  nixpkgs.config.allowUnfree = true;
  nix.package = pkgs.nix;

  # Fix root channel path errors
  #
  # https://github.com/LnL7/nix-darwin/issues/145#issuecomment-751423168
  #
  nix.nixPath = pkgs.lib.mkForce [{
    darwin-config = builtins.concatStringsSep ":" [
      "$HOME/.config/nixpkgs/darwin/configuration.nix"
      "$HOME/.nix-defexpr/channels"
    ];
  }];

  # Install and show in ~/Applications
  environment.systemPackages = with pkgs; [
    vscode
    libiconv
    alacritty
  ];

  environment.variables = {
    EDITOR = "nvim";
  };

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

  # Required afterwards:
  #
  #     sudo chown root:wheel /etc/static/sudoers.d/yabai
  #
  environment.etc.yabai = {
    target = "sudoers.d/yabai";
    text = "kevin ALL = (root) NOPASSWD: ${yabai}/bin/yabai --load-sa
    ";
  };

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.fish = {
    enable = true;
    useBabelfish = true;
    babelfishPackage = pkgs.babelfish;
  };

  system.defaults.dock.orientation = "left";
  system.defaults.dock.static-only = true;
  system.defaults.dock.autohide = true;
  system.defaults.dock.show-process-indicators = false;
  system.defaults.dock.tilesize = 56;
  system.defaults.dock.mru-spaces = false;
  system.defaults.dock.show-recents = false;

  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = true;

  system.defaults.trackpad.Clicking = true;

  users.nix.configureBuildUsers = true;

  # Disable startup sound. No Nix setting yet
  #
  #    sudo nvram StartupMute=%01
  #

  launchd.user.agents.bill-tunnel = {
    command = "ssh bill-tunnel";
    serviceConfig.KeepAlive = true;
    serviceConfig.ProcessType = "Background";
  };

  # launchd.user.agents.spotifyd = {
  #   command = "${pkgs.spotifyd} --no-daemon --config-path ${spotifydConfigFile}";
  #   serviceConfig.KeepAlive = true;
  #   serviceConfig.ProcessType = "Background";
  # };

  # Required afterwards:
  # $ chsh -s /run/current-system/sw/bin/fish
  environment.shells = [ pkgs.fish ];
  home-manager.useUserPackages = true;
  home-manager.users.kevin = { pkgs, ... }: {
    home.packages = with pkgs; [
      bat
      # bottom
      exa
      fd
      ffmpeg
      fswatch
      fzf
      git
      git-lfs
      hexyl
      mosh
      netcat
      ripgrep
      screen
      spotify-tui
      # spotifyd
      starship
      telnet
      tmux
      # websocat
      # weechat
    ];
    nixpkgs.config.allowUnfree = true;

    programs.neovim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [
        nvim-lspconfig
        nvim-lsp-extensions
        nvim-lsp-saga
        nvim-cmp
        nvim-cmp-lsp
        nvim-rust-tools
        nvim-vsnip
	nvim-ayu-theme
	nvim-plenary
	nvim-telescope
      ];
      extraPackages = with pkgs; [
        rust-analyzer
      ];
      extraConfig = "
set termguicolors
let ayucolor=\"mirage\"
colorscheme ayu

set completeopt=menuone,noinsert,noselect
set shortmess+=c
set mouse=a

lua <<EOF

-- nvim_lsp object
local nvim_lsp = require'lspconfig'

local opts = {
    tools = {
        autoSetHints = true,
        hover_with_actions = true,
        inlay_hints = {
            show_parameter_hints = true,
            parameter_hints_prefix = \"\",
            other_hints_prefix = \"\",
        },
    },

    -- all the opts to send to nvim-lspconfig
    -- these override the defaults set by rust-tools.nvim
    -- see https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#rust_analyzer
    server = {
        -- on_attach is a callback called when the language server attachs to the buffer
        -- on_attach = on_attach,
        settings = {
            -- to enable rust-analyzer settings visit:
            -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
            [\"rust-analyzer\"] = {}
        }
    },
}

require('rust-tools').setup(opts)
EOF

lua <<EOF
require'lspconfig'.tsserver.setup{}
EOF

lua <<EOF
local cmp = require'cmp'
cmp.setup({
  snippet = {
    expand = function(args)
        vim.fn[\"vsnip#anonymous\"](args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    -- Add tab support
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    })
  },

  -- Installed sources
  sources = {
    { name = 'nvim_lsp' },
  },
})
EOF

lua <<EOF
local saga = require 'lspsaga'
saga.init_lsp_saga()
EOF

set signcolumn=yes
set updatetime=300
autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()

nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>";
    };

    programs.vscode = {
      enable = true;
      userSettings = {
        terminal.integrated.rendererType = "dom";
        C_Cpp.updateChannel = "Insiders";
        update.mode = "none";
        window = {
          autoDetectColorScheme = true;
          zoomLevel = -1;
        };
        workbench = {
          editor.enablePreview = false;
          activityBar.visible = false;
          colorTheme = "Mayukai Semantic Mirage";
          preferredLightColorTheme = "Min Light";
          preferredDarkColorTheme = "Mayukai Semantic Mirage";
          iconTheme = "material-icon-theme";
        };
        editor = {
          fontFamily = "SF Mono, monospace";
          fontSize = 14;
          formatOnSave = true;
          minimap.enabled = false;
          renderWhitespace = "boundary";
          tabSize = 2;
        };
      };
      extensions = (with pkgs.vscode-extensions; [
        matklad.rust-analyzer
        ms-vscode-remote.remote-ssh
        vscodevim.vim
      ]) ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "mayukaithemevsc";
          publisher = "GulajavaMinistudio";
          version = "2.0.5";
          sha256 = "17fldjnhxgccllv9yxw32w2zrykiixfcprlhapmz3hwj6wyz3qkv";
        }
        {
          name = "min-theme";
          publisher = "miguelsolorio";
          version = "1.4.7";
          sha256 = "00whlmvx4k6qvfyqdmhyx7wvmhj180fh0yb8q4fgdr9bjiawhlyb";
        }
        {
          name = "nix";
          publisher = "bbenoist";
          version = "1.0.1";
          sha256 = "0zd0n9f5z1f0ckzfjr38xw2zzmcxg1gjrava7yahg5cvdcw6l35b";
        }
        {
          name = "nix-env-selector";
          publisher = "arrterian";
          version = "1.0.7";
          sha256 = "1n5ilw1k29km9b0yzfd32m8gvwa2xhh6156d4dys6l8sbfpp2cv9";
        }
        {
          name = "prettier-vscode";
          publisher = "esbenp";
          version = "6.3.1";
          sha256 = "0h7wc4pffyq1i8vpj4a5az02g2x04y7y1chilmcfmzg2w42xpby7";
        }
        {
          name = "vscode-eslint";
          publisher = "dbaeumer";
          version = "2.1.19";
          sha256 = "113w2iis4zi4z3sqc3vd2apyrh52hbh2gvmxjr5yvjpmrsksclbd";
        }
        {
          name = "material-icon-theme";
          publisher = "pkief";
          version = "4.6.0";
          sha256 = "1m9mis59j9xnf1zvh67p5rhayaa9qxjiw9iw847nyl9vsy73w8ya";
        }
      ];
    };

    programs.home-manager.enable = true;

    # TODO: Use `programs.starship` integration
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
    programs.tmux = {
      enable = true;
      keyMode = "vi";
      historyLimit = 50000;
    };
    programs.direnv = {
      enable = true;
      enableFishIntegration = true;
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
    package = yabai;
    #
    # Broken in MacOS 11. Custom config used instead.
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
    extraConfig = "
      sudo yabai --load-sa
      yabai -m signal --add event=dock_did_restart action=\"sudo yabai --load-sa\"
    ";
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

      # Toggle picture-in-picture
      alt - y : yabai -m window --toggle topmost
      
      # Close window
      shift + cmd + alt - l : yabai -m window --close

      # Terminal
      alt - space : open --new -a ~/Applications/Alacritty.app
    ";
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
