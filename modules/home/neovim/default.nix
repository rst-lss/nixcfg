{pkgs, ...}: let
  nvim-lint-github = pkgs.vimPlugins.nvim-lint.overrideAttrs (old: {
    src = pkgs.fetchFromGitHub {
      owner = "mfussenegger";
      repo = "nvim-lint";
      rev = "8b06eeec3c674744b993caecd73343df108c052d";
      hash = "sha256-aDMmKNQSwo+evuHJtub85rX1eQGVSIhx2gvmWhlM/vA=";
    };
  });
in {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    initLua = ''
      vim.g.mapleader = ' '
      vim.g.maplocalleader = ' '

      ${builtins.readFile ./lua/options.lua}
      ${builtins.readFile ./lua/keymaps.lua}
      ${builtins.readFile ./lua/autocmds.lua}
    '';

    plugins = with pkgs.vimPlugins; [
      # colorscheme
      {
        plugin = gruvbox-nvim;
        type = "lua";
        config = builtins.readFile ./lua/colorscheme.lua;
      }

      # treesitter
      {
        plugin = nvim-treesitter.withPlugins (p: [
          p.bash
          p.c
          p.diff
          p.html
          p.lua
          p.luadoc
          p.markdown
          p.markdown_inline
          p.query
          p.vim
          p.vimdoc
          p.python
          p.nix
        ]);
        type = "lua";
        config = builtins.readFile ./lua/treesitter.lua;
      }

      # detects indentation (tabs vs spaces, width) per file.
      vim-sleuth

      # mini
      {
        plugin = mini-nvim;
        type = "lua";
        config = builtins.readFile ./lua/mini.lua;
      }

      # telescope
      plenary-nvim
      telescope-fzf-native-nvim
      telescope-ui-select-nvim
      nvim-web-devicons
      {
        plugin = telescope-nvim;
        type = "lua";
        config = builtins.readFile ./lua/telescope.lua;
      }

      # cmp
      {
        plugin = lazydev-nvim;
        type = "lua";
        config = builtins.readFile ./lua/lazydev.lua;
      }
      luasnip
      cmp_luasnip
      friendly-snippets
      cmp-path
      cmp-nvim-lsp
      {
        plugin = nvim-cmp;
        type = "lua";
        config = builtins.readFile ./lua/cmp.lua;
      }
      {
        plugin = nvim-autopairs;
        type = "lua";
        config = builtins.readFile ./lua/autopairs.lua;
      }

      # conform/lint
      {
        plugin = conform-nvim;
        type = "lua";
        config = builtins.readFile ./lua/conform.lua;
      }
      {
        plugin = nvim-lint-github;
        type = "lua";
        config = builtins.readFile ./lua/lint.lua;
      }

      # git
      {
        plugin = gitsigns-nvim;
        type = "lua";
        config = builtins.readFile ./lua/gitsigns.lua;
      }

      # LSP
      fidget-nvim
      {
        plugin = nvim-lspconfig;
        type = "lua";
        config = builtins.readFile ./lua/lsp.lua;
      }

      # LSP breadcrumbs
      {
        plugin = nvim-navic;
        type = "lua";
        config = builtins.readFile ./lua/navic.lua;
      }
    ];

    extraPackages = with pkgs; [
      # LS
      clang-tools # clangd + clang-format
      basedpyright
      ruff
      typescript-language-server
      lua-language-server
      taplo
      bash-language-server
      nixd

      # formatter/linter
      stylua
      prettier
      prettierd
      eslint_d
      cpplint
      markdownlint-cli
      shfmt
      shellcheck
      statix
      alejandra

      # tools
      ripgrep
    ];
  };
}
