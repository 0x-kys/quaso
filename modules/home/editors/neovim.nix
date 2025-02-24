{pkgs, ...}: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    plugins = with pkgs.vimPlugins; [
      # Theme
      gruvbox-material

      vim-sleuth
      gitsigns-nvim
      todo-comments-nvim
      indent-blankline-nvim

      # Statusline with Nerd Icons
      lualine-nvim
      nvim-web-devicons

      # LSP and Diagnostics
      nvim-lspconfig
      trouble-nvim
      lsp_signature-nvim

      # Autocompletion and Snippets
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      luasnip
      cmp_luasnip

      # Tree-sitter
      nvim-treesitter.withAllGrammars

      # Telescope
      telescope-nvim
      plenary-nvim

      # Dashboard
      dashboard-nvim

      # Tab bar management
      barbar-nvim

      # Additional Utilities
      nvim-lint
      conform-nvim
      nvim-navic
      mini-nvim
      which-key-nvim # Added Which-Key

      # WakaTime Plugin
      vim-wakatime
    ];

    extraPackages = with pkgs; [
      # LSP Servers
      nil
      lua-language-server
      gopls
      pyright
      clang-tools
      svelte-language-server
      nodePackages.typescript-language-server
      nodePackages.vscode-langservers-extracted
      zig
      tailwindcss-language-server
      marksman
      rust-analyzer
      astro-language-server

      # Formatters
      alejandra
      rustfmt
      deno
      nodePackages.prettier
      taplo
      gofumpt
      stylua

      # Telescope dependencies
      ripgrep
      fd

      # Clipboard support
      xclip
      wl-clipboard

      # WakaTime CLI
      wakatime
    ];

    extraConfig = let
      neovimLuaConfig = builtins.readFile ../../../extras/neovim/init.lua;
    in ''
      lua << EOF
      ${neovimLuaConfig}
      EOF
    '';
  };
}
