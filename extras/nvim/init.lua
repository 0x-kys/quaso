
-- Theme setup (Gruvbox Dark Hard)
      vim.o.termguicolors = true
      vim.o.background = "dark"
      vim.cmd([[colorscheme gruvbox]])
      vim.g.gruvbox_contrast_dark = "hard"

      -- Leader key setup
      vim.g.mapleader = " "

      -- Statusline with Nerd Icons (lualine)
      require('lualine').setup {
        options = {
          icons_enabled = true,
          theme = 'gruvbox',
          component_separators = { left = '', right = '' },
          section_separators = { left = '', right = '' },
        },
      }

      -- LSP setup (diagnostics and error lens, no autocomplete)
      local lspconfig = require('lspconfig')
      local servers = {
        'nil_ls', -- Nix
        'lua_ls', -- Lua
        'gopls', -- Go
        'pyright', -- Python
        'clangd', -- C/C++
        'svelte', -- Svelte
        'tsserver', -- JS/TS
        'cssls', -- CSS
        'html', -- HTML
        'zls', -- Zig
      }

      for _, lsp in ipairs(servers) do
        lspconfig[lsp].setup {
          capabilities = {
            textDocument = {
              completion = { completionItem = { snippetSupport = false } }, -- Disable autocomplete
            },
          },
          on_attach = function(client, bufnr)
            -- Disable LSP-based autocompletion
            client.server_capabilities.completionProvider = false
          end,
        }
      end

      -- Diagnostics setup (error lens via trouble.nvim)
      require('trouble').setup {}
      vim.keymap.set('n', '<leader>e', '<cmd>Trouble diagnostics toggle<cr>', { desc = 'Toggle Diagnostics' })

      -- Tree-sitter setup
      require('nvim-treesitter.configs').setup {
        ensure_installed = { "nix", "lua", "tmux", "go", "python", "c", "cpp", "svelte", "javascript", "typescript", "astro", "css", "html", "zig", "elixir" },
        highlight = { enable = true },
        indent = { enable = true },
      }

      -- Tab bar setup (barbar.nvim)
      vim.keymap.set('n', '<A-,>', '<cmd>BufferPrevious<cr>', { desc = 'Previous Tab' })
      vim.keymap.set('n', '<A-.>', '<cmd>BufferNext<cr>', { desc = 'Next Tab' })
      vim.keymap.set('n', '<A-w>', '<cmd>BufferClose<cr>', { desc = 'Close Tab' })

      -- Telescope setup
      local telescope = require('telescope')
      telescope.setup {}
      vim.keymap.set('n', '<leader>p', '<cmd>Telescope find_files<cr>', { desc = 'File Picker' })
      vim.keymap.set('n', '<leader>b', '<cmd>Telescope buffers<cr>', { desc = 'Buffer Picker' })

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
            { desc = 'Projects', group = 'DashboardShortCut', key = 'p', action = 'Telescope projects' },
          },
        },
      }
