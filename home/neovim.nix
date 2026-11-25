{ pkgs, ... }:
{
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    vimdiffAlias = true;
    luaLoader.enable = true;

    nixpkgs.useGlobalPackages = true;

    colorschemes.catppuccin = {
      enable = true;
      settings = {
        transparent_background = true;
        integrations = {
          cmp = true;
          mini.enabled = true;
          treesitter = true;
        };
      };
    };

    extraConfigLua = ''
      vim.opt.foldlevel = 99;
      vim.opt.showmatch = true;
      vim.opt.ignorecase = true;
      vim.opt.hlsearch = true;
      vim.opt.incsearch = true;
      vim.opt.tabstop = 2;
      vim.opt.softtabstop = 2;
      vim.opt.expandtab = true;
      vim.opt.smarttab = true;
      vim.opt.shiftwidth = 0;
      vim.opt.shiftround = true;
      vim.opt.autoindent = true;
      vim.opt.smartindent = true;
      vim.opt.number = true;
      vim.opt.mouse = "a";
      vim.opt.cursorline = true;
      vim.opt.ttyfast = true;

      vim.opt.listchars = {
        tab = '» ',
        extends = '›',
        precedes = '‹',
        nbsp = '·',
        trail = '·',
      };
    '';

    plugins.lsp = {
      enable = true;
      inlayHints = true;

      servers = {
        astro.enable = true;
        ts_ls.enable = true;
        rust_analyzer = {
          enable = true;
          package = null;
          installCargo = false;
          installRustc = false;
          settings = {
            check.command = "clippy";
            cargo.targetDir = true;
            # Noisy with code for multiple build targets
            diagnostics.disabled = [ "inactive_code" ];
          };
        };
        svelte.enable = true;
      };
    };

    plugins.cmp = {
      enable = true;
      autoEnableSources = true;
      settings.sources = [
        { name = "nvim_lsp"; }
      ];
    };

    plugins.treesitter = {
      enable = true;
      folding.enable = true;
      settings = {
        highlight.enable = true;
        indent.enable = true;
      };
      grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        astro
        bash
        css
        fish
        html
        http
        javascript
        json
        markdown
        markdown_inline
        nix
        rust
        svelte
        typescript
      ];
    };

    plugins.telescope = {
      enable = true;
      keymaps = {
        "<leader>ff" = {
          action = "find_files";
          options = {
            desc = "Telescope find files";
          };
        };
        "<leader>fg" = {
          action = "live_grep";
          options = {
            desc = "Telescope live grep";
          };
        };
        "<leader>fd" = {
          action = "diagnostics";
          options = {
            desc = "Telescope diagnostics";
          };
        };
        "<leader>fr" = {
          action = "lsp_references";
          options = {
            desc = "Telescope LSP references";
          };
        };
        "<leader>fi" = {
          action = "lsp_implementations";
          options = {
            desc = "Telescope implementations";
          };
        };
      };
      settings = {
        defaults = {
          layout_strategy = "flex";
          layout_config = {
            height = 0.95;
            width = 0.95;
            flex = {
              flip_columns = 130;
            };
          };
        };
      };
    };

    plugins.nvim-tree = {
      enable = true;
      openOnSetup = true;
    };

    plugins.mini = {
      enable = true;
      mockDevIcons = true;
      modules.icons = {
        style = "ascii";
      };
    };

    plugins.lualine = {
      enable = true;
    };

    plugins.codecompanion = {
      enable = true;
      settings.strategies = {
        agent.adapter = "anthropic";
        chat.adapter = "anthropic";
        inline.adapter = "anthropic";
      };
    };
  };
}
