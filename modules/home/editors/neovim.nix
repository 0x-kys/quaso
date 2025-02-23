{pkgs, ...}: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    plugins = with pkgs.vimPlugins; [
      # Theme
      gruvbox-community

      # Statusline with Nerd Icons
      lualine-nvim
      nvim-web-devicons

      # LSP and Diagnostics
      nvim-lspconfig
      trouble-nvim # For error lens and diagnostics

      # Tree-sitter
      nvim-treesitter.withAllGrammars

      # Telescope for file and buffer pickers
      telescope-nvim
      plenary-nvim # Dependency for Telescope

      # Dashboard
      dashboard-nvim

      # Tab bar management
      barbar-nvim

      nvim-lint # linting
      conform-nvim # formatting
      lsp_signature-nvim # signature help
      nvim-navic # breadcrumbs

      indent-blankline-nvim # indent blankline
      mini-nvim # mini icons

      # WakaTime Plugin
      vim-wakatime
    ];

    # Extra packages to make LSP, formatters, and other tools work
    extraPackages = with pkgs; [
      # LSP Servers
      nil # Nix
      lua-language-server # Lua
      gopls # Go
      pyright # Python
      clang-tools # C/C++
      svelte-language-server # Svelte
      nodePackages.typescript-language-server # JS/TS
      nodePackages.vscode-langservers-extracted # CSS/HTML
      zig # Zig
      tailwindcss-language-server # Tailwind CSS
      marksman # Markdown
      rust-analyzer # Rust
      astro-language-server # Astro

      # Formatters
      alejandra # Nix
      rustfmt # Rust
      deno # JS/TS/HTML/CSS
      nodePackages.prettier # Svelte/Astro
      taplo # TOML
      gofumpt # Go
      stylua # Lua

      # Telescope dependencies
      ripgrep # faster file searching
      fd # faster file finding

      # Clipboard support
      xclip # X11 clipboard support
      wl-clipboard # Wayland clipboard support

      # WakaTime CLI
      wakatime
    ];

    # Extra Lua configuration
    extraConfig = let
      neovimLuaConfig = builtins.readFile ../../../extras/neovim/init.lua;
    in ''
      lua << EOF
      ${neovimLuaConfig}
      EOF
    '';
  };
}
