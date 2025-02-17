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

      # Telescope dependencies
      ripgrep # faster file searching
      fd # faster file finding

      # Clipboard support
      xclip # X11 clipboard support
      wl-clipboard # Wayland clipboard support
    ];

    # Extra Lua configuration
    extraConfig = ''
      lua << EOF
      -- Theme setup (Gruvbox Dark Hard)
      vim.o.termguicolors = true
      vim.o.background = "dark"
      vim.cmd([[colorscheme gruvbox]])
      vim.g.gruvbox_contrast_dark = "hard"

      -- Enable transparency for Gruvbox
      vim.g.gruvbox_transparent_bg = 1

      -- Cursor settings for a "reversed" look
      -- Set cursor shapes to match Helix (block in normal, bar in insert, underline in select)
      vim.opt.guicursor = {
        "n-v-c:block", -- Normal, visual, command-line: block cursor
        "i-ci-ve:ver25", -- Insert, command-line insert, visual-exclude: vertical bar (25% width)
        "r-cr:hor20", -- Replace, command-line replace: horizontal bar (20% height)
        "sm:block", -- Showmatch: block cursor
      }

      -- Additional transparency for UI elements
      vim.api.nvim_set_hl(0, "Normal", { bg = "none" }) -- Main editor background
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" }) -- Floating windows
      vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" }) -- Borders of floating windows
      vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" }) -- Sign column (e.g., diagnostics)
      vim.api.nvim_set_hl(0, "LineNr", { bg = "none" }) -- Line numbers
      vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" }) -- End of buffer (~ symbols)
      vim.api.nvim_set_hl(0, "VertSplit", { bg = "none", fg = "#665c54" }) -- Vertical splits
      vim.api.nvim_set_hl(0, "StatusLine", { bg = "none" }) -- Statusline
      vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "none" }) -- Inactive statusline
      vim.api.nvim_set_hl(0, "TabLine", { bg = "none" }) -- Tabline background
      vim.api.nvim_set_hl(0, "TabLineFill", { bg = "none" }) -- Tabline fill
      vim.api.nvim_set_hl(0, "TabLineSel", { bg = "none" }) -- Selected tab

      -- Set cursor highlight to "reversed" look (high contrast, visible on any background)
      vim.api.nvim_set_hl(0, "Cursor", { fg = "#000000", bg = "#ffffff", reverse = true }) -- Black text on white background, reversed
      vim.api.nvim_set_hl(0, "CursorIM", { fg = "#000000", bg = "#ffffff", reverse = true }) -- Same for IME mode
      vim.api.nvim_set_hl(0, "TermCursor", { fg = "#000000", bg = "#ffffff", reverse = true }) -- Terminal cursor

      -- Ensure cursor is visible even with transparency
      vim.opt.cursorline = true -- Highlight the cursor line for better visibility
      vim.api.nvim_set_hl(0, "CursorLine", { bg = "none", underline = true }) -- Underline cursor line, no background to preserve transparency

      -- Leader key setup
      vim.g.mapleader = " "

      -- Enable line numbers (relative, like Helix)
      vim.o.number = true
      vim.o.relativenumber = true

      -- Enable mouse support
      vim.o.mouse = "a"

      -- Tab and indentation settings
      vim.o.tabstop = 2        -- Number of spaces a tab counts for
      vim.o.shiftwidth = 2     -- Number of spaces for each indentation level
      vim.o.softtabstop = 2    -- Number of spaces for tab in insert mode
      vim.o.expandtab = true   -- Convert tabs to spaces
      vim.o.smartindent = true -- Smart indentation for new lines

      -- Word wrap settings
      vim.o.wrap = true        -- Enable word wrap
      vim.o.linebreak = true   -- Wrap lines at word boundaries
      vim.o.breakindent = true -- Indent wrapped lines to match original indentation
      vim.o.showbreak = "↳ "   -- String to show at the start of wrapped lines

      -- Clipboard setup: 'y' for normal yank, 'Y' for system clipboard
      vim.keymap.set('n', 'Y', '"+y', { noremap = true, silent = true })
      vim.keymap.set('v', 'Y', '"+y', { noremap = true, silent = true })

      -- Statusline with Nerd Icons (lualine)
      require('lualine').setup {
        options = {
          icons_enabled = true,
          theme = 'gruvbox',
          component_separators = { left = '', right = '' },
          section_separators = { left = '', right = '' },
        },
        sections = {
          lualine_a = {'mode'},
          lualine_b = {'branch', 'diff', 'diagnostics'},
          lualine_c = {'filename'},
          lualine_x = {'encoding', 'fileformat', 'filetype'},
          lualine_y = {'progress'},
          lualine_z = {'location'}
        },
      }

      -- LSP setup (diagnostics, inlay hints, signature help, no autocomplete)
      local lspconfig = require('lspconfig')
      local servers = {
        ['nil_ls'] = {}, -- Nix
        ['lua_ls'] = {}, -- Lua
        ['gopls'] = {}, -- Go
        ['pyright'] = {}, -- Python
        ['clangd'] = {}, -- C/C++
        ['svelte'] = {}, -- Svelte
        ['ts_ls'] = {}, -- JS/TS
        ['cssls'] = {}, -- CSS
        ['html'] = {}, -- HTML
        ['zls'] = {}, -- Zig
        ['tailwindcss'] = {}, -- Tailwind CSS
        ['marksman'] = {}, -- Markdown
        ['rust_analyzer'] = {}, -- Rust
        ['astro'] = {}, -- Astro
      }

      -- Common on_attach function for LSP
      local on_attach = function(client, bufnr)
        -- Disable LSP-based autocompletion
        client.server_capabilities.completionProvider = false

        -- Enable inlay hints (if supported by the LSP)
        if client.server_capabilities.inlayHintProvider then
          vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        end

        -- Keybindings for LSP features (mirroring Helix)
        local opts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts) -- goto_definition
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts) -- goto_reference
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts) -- code_action
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts) -- rename_symbol

        -- Signature help
        require('lsp_signature').on_attach({
          bind = true,
          handler_opts = { border = "rounded" },
        }, bufnr)
      end

      -- LSP capabilities
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = false -- Disable autocomplete

      -- Setup LSP servers
      for lsp, config in pairs(servers) do
        lspconfig[lsp].setup(vim.tbl_deep_extend("force", {
          on_attach = on_attach,
          capabilities = capabilities,
          flags = { debounce_text_changes = 150 },
        }, config))
      end

      -- Diagnostics setup (error lens via trouble.nvim)
      require('trouble').setup {}
      vim.keymap.set('n', '<leader>e', '<cmd>Trouble diagnostics toggle<cr>', { desc = 'Toggle Diagnostics' })

      -- Tree-sitter setup (fix for NixOS read-only store)
      require('nvim-treesitter.configs').setup {
        -- Use a writable directory for parser files
        parser_install_dir = vim.fn.stdpath('data') .. '/site',
        ensure_installed = { "nix", "lua", "tmux", "go", "python", "c", "cpp", "svelte", "javascript", "typescript", "astro", "css", "html", "zig", "rust", "markdown" },
        highlight = { enable = true },
        indent = { enable = true },
      }
      -- Ensure Neovim uses the writable parser directory
      vim.opt.runtimepath:append(vim.fn.stdpath('data') .. '/site')

      -- Tab bar setup (barbar.nvim, mirroring Helix keybindings)
      vim.keymap.set('n', '<A-,>', '<cmd>BufferPrevious<cr>', { desc = 'Previous Tab' })
      vim.keymap.set('n', '<A-.>', '<cmd>BufferNext<cr>', { desc = 'Next Tab' })
      vim.keymap.set('n', '<A-w>', '<cmd>BufferClose<cr>', { desc = 'Close Tab' })

      -- Telescope setup
      local telescope = require('telescope')
      telescope.setup {}
      vim.keymap.set('n', '<C-p>', '<cmd>Telescope find_files<cr>', { desc = 'File Picker' }) -- Mirroring Helix
      vim.keymap.set('n', '<leader>b', '<cmd>Telescope buffers<cr>', { desc = 'Buffer Picker' })
      vim.keymap.set('n', '<leader>r', '<cmd>Telescope oldfiles<cr>', { desc = 'Recent Files' })

      -- Dashboard setup
      require('dashboard').setup {
        theme = 'hyper',
        config = {
          header = { -- Customize your header here
            "Welcome to Neovim!",
            "",
          },
          shortcut = {
            { desc = 'Recent Files', group = 'DashboardShortCut', key = 'r', action = 'Telescope oldfiles' },
            { desc = 'Find File', group = 'DashboardShortCut', key = 'f', action = 'Telescope find_files' },
          },
        },
      }

      -- Formatter setup (conform.nvim, mirroring Helix formatters)
      require('conform').setup({
        formatters_by_ft = {
          nix = { "alejandra" },
          rust = { "rustfmt" },
          html = { "deno_fmt" },
          css = { "deno_fmt" },
          javascript = { "deno_fmt" },
          typescript = { "deno_fmt" },
          svelte = { "prettier" },
          astro = { "prettier" },
          json = { "deno_fmt" },
          jsonc = { "deno_fmt" },
          toml = { "taplo" },
          markdown = { "taplo" },
          zig = { "zigfmt" },
          go = { "gofumpt" },
        },
        format_on_save = {
          lsp_fallback = false, -- Use conform.nvim for formatting, not LSP
          timeout_ms = 500,
        },
      })

      -- Keybinding for manual formatting
      vim.keymap.set('n', '<leader>f', function() require('conform').format({ async = true, lsp_fallback = false }) end, { desc = 'Format Document' })

      -- Additional Helix-like settings
      vim.o.showtabline = 2 -- Always show tabline (like Helix's bufferline)
      vim.o.cursorline = true -- Highlight cursor line (like Helix's inline diagnostics)
      vim.o.showmode = false -- Hide mode in command line (lualine shows it)
      vim.o.signcolumn = "yes" -- Always show sign column for diagnostics
      vim.opt.list = true -- Show whitespace characters
      vim.opt.listchars = { tab = '→ ', space = ' ', nbsp = '⍽', eol = '⏎' } -- Whitespace characters

      -- Indent guides
      vim.opt.listchars:append({ lead = '╎' })
      vim.opt.list = true
      EOF
    '';
  };
}
