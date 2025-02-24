-- General Settings
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.have_nerd_font = true

vim.opt.number = true    -- enable line numbers
vim.opt.mouse = "a"      -- enable mouse support

vim.opt.showmode = false -- do not show the mode (already in the statusline)

-- sync clipboard between OS and Neovim
--
-- schedule the setting after `UiEnter` 'cause it can increase startup time
vim.schedule(function()
  vim.opt.clipboard = "unnamedplus"
end)

vim.opt.breakindent = true -- break indent
vim.opt.undofile = true    -- save undo history

-- case-insensitive searching unless \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.signcolumn = "yes" -- keep signcolumn on by default
vim.opt.updatetime = 250   -- decrease update time

-- split behavior
vim.opt.splitright = true
vim.opt.splitbelow = true

-- display whitespace certain characters
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

vim.opt.inccommand = "split" -- preview substitutions love, as you type!
vim.opt.cursorline = ture    -- show which line your cursor is on
vim.opt.scrolloff = 10       -- minimal number of screen lines to keep above and below the cursor

-- Theme Setup
vim.cmd([[colorscheme gruvbox-material]])
vim.api.nvim_set_hl(0, "Normal", { bg = "#1b1b1b" })

-- Cursor Settings
vim.opt.guicursor = {
  "n-v-c:block",
  "i-ci-ve:ver25",
  "r-cr:hor20",
  "sm:block",
}
vim.api.nvim_set_hl(0, "Cursor", { fg = "#000000", bg = "#ffffff", reverse = true })
vim.api.nvim_set_hl(0, "CursorIM", { fg = "#000000", bg = "#ffffff", reverse = true })
vim.api.nvim_set_hl(0, "TermCursor", { fg = "#000000", bg = "#ffffff", reverse = true })
vim.api.nvim_set_hl(0, "CursorLine", { bg = "none", underline = true })

-- Define Diagnostic Signs with Nerd Font Icons
vim.fn.sign_define(
  "DiagnosticSignError",
  { text = "", texthl = "DiagnosticSignError", numhl = "DiagnosticSignError" }
)
vim.fn.sign_define("DiagnosticSignWarn", { text = "", texthl = "DiagnosticSignWarn", numhl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo", { text = "", texthl = "DiagnosticSignInfo", numhl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = "󰌵", texthl = "DiagnosticSignHint", numhl = "DiagnosticSignHint" })

-- Enhanced Lualine (Evil Lualine Style)
local conditions = {
  buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
  end,
  hide_in_width = function()
    return vim.fn.winwidth(0) > 80
  end,
  check_git_workspace = function()
    local filepath = vim.fn.expand("%:p:h")
    local gitdir = vim.fn.finddir(".git", filepath .. ";")
    return gitdir and #gitdir > 0 and #gitdir < #filepath
  end,
}

require("lualine").setup({
  options = {
    component_separators = "",
    section_separators = { left = "", right = "" },
    theme = "gruvbox-material",
    disabled_filetypes = { "dashboard", "NvimTree" },
    globalstatus = true,
  },
  sections = {
    lualine_a = {
      { "mode", separator = { left = "" }, right_padding = 2, icon = "" },
    },
    lualine_b = {
      {
        "filename",
        file_status = true,
        newfile_status = true,
        path = 1,
        symbols = { modified = "●", readonly = "", unnamed = "[No Name]", newfile = "✧" },
        cond = conditions.buffer_not_empty,
      },
      { "branch", icon = "", color = { fg = "#fabd2f" }, cond = conditions.hide_in_width },
    },
    lualine_c = {
      {
        "diagnostics",
        sources = { "nvim_lsp" },
        symbols = { error = " ", warn = " ", info = " ", hint = "󰌵 " },
        diagnostics_color = {
          error = { fg = "#fb4934" },
          warn = { fg = "#fe8019" },
          info = { fg = "#83a598" },
          hint = { fg = "#8ec07c" },
        },
        cond = conditions.hide_in_width,
      },
      {
        "diff",
        symbols = { added = " ", modified = " ", removed = " " },
        diff_color = {
          added = { fg = "#b8bb26" },
          modified = { fg = "#fabd2f" },
          removed = { fg = "#fb4934" },
        },
        source = function()
          local gitsigns = vim.b.gitsigns_status_dict
          if gitsigns then
            return { added = gitsigns.added, modified = gitsigns.changed, removed = gitsigns.removed }
          end
        end,
        cond = conditions.hide_in_width and conditions.check_git_workspace,
      },
    },
    lualine_x = {
      { "encoding", cond = conditions.hide_in_width },
      { "fileformat", icons_enabled = true, icon = "", cond = conditions.hide_in_width },
      { "filetype", cond = conditions.hide_in_width },
    },
    lualine_y = {
      { "progress", separator = "", padding = { left = 1, right = 1 }, cond = conditions.hide_in_width },
    },
    lualine_z = {
      { "location", separator = { right = "" }, left_padding = 2, cond = conditions.hide_in_width },
    },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { { "filename", cond = conditions.buffer_not_empty } },
    lualine_x = { "location" },
    lualine_y = {},
    lualine_z = {},
  },
})

-- Tree-sitter Configuration
require("nvim-treesitter.configs").setup({
  parser_install_dir = vim.fn.stdpath("data") .. "/site",
  ensure_installed = {
    "nix",
    "lua",
    "tmux",
    "go",
    "python",
    "c",
    "cpp",
    "svelte",
    "javascript",
    "typescript",
    "astro",
    "css",
    "html",
    "zig",
    "rust",
    "markdown",
    "toml",
  },
  highlight = { enable = true },
  indent = { enable = true },
})
vim.opt.runtimepath:append(vim.fn.stdpath("data") .. "/site")

-- nvim-lspconfig
local lspconfig = require("lspconfig")
local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()

-- LSP servers
local servers = {
  "nil_ls", -- nil
  "lua_ls", -- lua-language-server
  "gopls",
  "pyright",
  "clangd",      -- clang-tools
  "svelte",      -- svelte-language-server
  "ts_ls",       -- typescript-language-server
  "eslint",      -- vscode-langservers-extracted
  "zls",         -- zig
  "tailwindcss", -- tailwindcss-language-server
  "marksman",
  "rust_analyzer",
  "astro", -- astro-language-server
}

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup({
    capabilities = lsp_capabilities,
  })
end

-- LSP Keymaps
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("redacted-neex-lsp-attach", { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc)
      vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
    end

    map("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
    map("gr", vim.lsp.buf.references, "[G]oto [R]eferences")
    map("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
    map("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
    map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
    map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
    map("K", vim.lsp.buf.hover, "Hover Documentation")
    map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

    -- Highlight references under cursor
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client.server_capabilities.documentHighlightProvider then
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = event.buf,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd("CursorMoved", {
        buffer = event.buf,
        callback = vim.lsp.buf.clear_references,
      })
    end
  end,
})

-- nvim-cmp and cmp_luasnip
local cmp = require("cmp")
local luasnip = require("luasnip")

require("luasnip.loaders.from_vscode").lazy_load() -- load snippet support

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer" },
    { name = "path" },
  },
})

-- mini.nvim
require("mini.ai").setup({ n_lines = 500 })
require("mini.surround").setup()

-- conform.nvim (for autoformatting)
require("conform").setup({
  formatters_by_ft = {
    nix = { "alejandra" },
    rust = { "rustfmt" },
    html = { "deno_html" },
    css = { "deno_css" },
    javascript = { "deno_js" },
    typescript = { "deno_ts" },
    svelte = { "prettier_svelte" },
    astro = { "prettier_astro" },
    jsx = { "deno_jsx" },
    tsx = { "deno_tsx" },
    json = { "deno_json" },
    jsonc = { "deno_jsonc" },
    toml = { "deno_toml" },
    markdown = { "taplo" },
    zig = { "zls" },
    go = { "gofumpt" },
  },
  formatters = {
    alejandra = {
      command = "alejandra",
    },
    rustfmt = {
      command = "rustfmt",
    },
    deno_html = {
      command = "deno",
      args = { "fmt", "-", "--ext", "html" },
    },
    deno_css = {
      command = "deno",
      args = { "fmt", "-", "--ext", "css" },
    },
    deno_js = {
      command = "deno",
      args = { "fmt", "-", "--ext", "js" },
    },
    deno_ts = {
      command = "deno",
      args = { "fmt", "-", "--ext", "ts" },
    },
    prettier_svelte = {
      command = "prettier",
      args = { "--plugin", "prettier-plugin-svelte", "--parser", "svelte" },
    },
    prettier_astro = {
      command = "prettier",
      args = { "--plugin", "prettier-plugin-astro", "--parser", "astro" },
    },
    deno_jsx = {
      command = "deno",
      args = { "fmt", "-", "--ext", "jsx" },
    },
    deno_tsx = {
      command = "deno",
      args = { "fmt", "-", "--ext", "tsx" },
    },
    deno_json = {
      command = "deno",
      args = { "fmt", "-", "--ext", "json" },
    },
    deno_jsonc = {
      command = "deno",
      args = { "fmt", "-", "--ext", "jsonc" },
    },
    deno_toml = {
      command = "deno",
      args = { "fmt", "-", "--ext", "" },
    },
    taplo = {
      command = "taplo",
      args = { "format", "-" },
    },
    zls = {
      command = "zls",
      args = { "--format" },
    },
    gofumpt = {
      command = "gofumpt",
    },
  },
  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
  },
})

-- Keymap for manual formatting
vim.keymap.set("n", "<leader>f", function()
  require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "[F]ormat buffer" })

-- conform.nvim

-- Dashboard
math.randomseed(os.time())
local function get_fortune_quote()
  local max_length = 80
  local fortune_cmd = string.format("fortune -s -n %d", max_length)
  local quote = vim.fn.system(fortune_cmd)
  quote = quote:gsub("\n$", ""):gsub("\n.*", "")
  if quote == "" or vim.v.shell_error ~= 0 then
    return "Code is poetry, when it works."
  end
  if #quote > max_length then
    quote = quote:sub(1, max_length - 3) .. "..."
  end
  return quote
end

require("dashboard").setup({
  theme = "hyper",
  config = {
    header = {
      "⠀⠀⠀⠀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
      "⠀⠀⠀⢠⠀⠉⠒⠤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
      "⠀⠀⠀⢸⢳⡀⠀⠀⠀⠁⠒⠀⠀⠤⠄⣀⣀⣀⡀⠀⠠⣄",
      "⠀⠀⠀⢸⠁⢳⣴⠂⢀⣀⠀⣀⠀⠀⠀⠈⠑⠀⠀⠀⢀⡎",
      "⠀⠀⠀⢸⣤⡼⠁⢰⠁⠸⡇⢀⠇⠀⢔⠉⣷⠢⣠⣶⣿⠁",
      "⠀⠀⠀⣸⣿⠁⠀⠈⠁⠀⠉⠁⠐⣻⣫⠒⠯⡠⠛⣿⠃⠀",
      "⠀⠀⢰⣿⣿⣤⣤⡤⠤⣖⡂⠉⠉⠀⠈⢓⣄⠀⠈⡃⠀⠀",
      "⠀⠀⠀⢻⣧⣿⡋⣒⠂⠒⠁⡀⠀⢀⠈⠩⣀⣱⣼⠀⠀⠀",
      "⠀⠀⠀⠀⣯⣵⣙⢦⣀⠀⠀⠈⠉⠉⠀⠀⣐⣼⡿⠀⠀⠀",
      "⠀⠀⠀⠀⠻⣿⣋⣙⣛⣿⣶⣀⣲⣶⣾⣿⣿⡯⠀⠀⠀⠀",
      "⠀⠀⠀⠀⠀⠀⣹⢿⡞⠛⣿⣿⢿⡟⢻⠛⠋⠁⠀⠀⠀⠀",
      "⢠⣀⠀⠀⠀⢠⣿⣿⣴⣪⣁⣸⠉⢣⣸⠀⠀⠀⠀⠀⠀⠀",
      "⠈⠒⠈⠩⠭⠿⢏⡙⠛⠛⠛⠛⠛⠛⢻⠀⠀⠀⠀⠀⠀⠀",
      "⠀⠀⠀⠀⠀⠀⠘⣇⡸⠀⠒⠒⠲⡀⡎⠀⠀⠀⠀⠀⠀⠀",
      "⠀⠀⠀⠀⠀⠀⠀⠈⠁⠀⠀⠀⠀⠉⠀⠀⠀⠀⠀⠀⠀⠀",
      "",
      get_fortune_quote(),
      "",
      "",
    },
    packages = { enable = false },
    shortcut = {
      { desc = "Recent Files", group = "DashboardShortCut", key = "r", action = "Telescope oldfiles" },
      { desc = "Find File",    group = "DashboardShortCut", key = "f", action = "Telescope find_files" },
    },
    mru = { enable = true, limit = 10, label = "Recent Files", cwd_only = false },
    footer = {},
  },
})

-- GitSigns Highlights
vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = "#b8bb26", bg = "#1d2021" })
vim.api.nvim_set_hl(0, "GitSignsChange", { fg = "#fabd2f", bg = "#1d2021" })
vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = "#fb4934", bg = "#1d2021" })
vim.api.nvim_set_hl(0, "GitSignsTopdelete", { fg = "#fb4934", bg = "#1d2021" })
vim.api.nvim_set_hl(0, "GitSignsChangedelete", { fg = "#fabd2f", bg = "#1d2021" })
vim.api.nvim_set_hl(0, "GitSignsAddNr", { fg = "#b8bb26" })
vim.api.nvim_set_hl(0, "GitSignsChangeNr", { fg = "#fabd2f" })
vim.api.nvim_set_hl(0, "GitSignsDeleteNr", { fg = "#fb4934" })
vim.api.nvim_set_hl(0, "GitSignsTopdeleteNr", { fg = "#fb4934" })
vim.api.nvim_set_hl(0, "GitSignsChangedeleteNr", { fg = "#fabd2f" })

require("gitsigns").setup({
  signs = {
    add = { text = "+" },
    change = { text = "~" },
    delete = { text = "_" },
    topdelete = { text = "‾" },
    changedelete = { text = "~" },
  },
  signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
  numhl = false,     -- Toggle with `:Gitsigns toggle_numhl`
  linehl = false,    -- Toggle with `:Gitsigns toggle_linehl`
  word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
  watch_gitdir = {
    follow_files = true,
  },
  auto_attach = true,
  attach_to_untracked = false,
  current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
    delay = 1000,
    ignore_whitespace = false,
    virt_text_priority = 100,
  },
  current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil,  -- Use default
  max_file_length = 40000, -- Disable if file is longer than this (in lines)
  preview_config = {
    -- Options passed to nvim_open_win
    border = "single",
    style = "minimal",
    relative = "cursor",
    row = 0,
    col = 1,
  },
  on_attach = function(bufnr)
    local gitsigns = require("gitsigns")

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map("n", "]c", function()
      if vim.wo.diff then
        vim.cmd.normal({ "]c", bang = true })
      else
        gitsigns.nav_hunk("next")
      end
    end, { desc = "Jump to next git change" })

    map("n", "[c", function()
      if vim.wo.diff then
        vim.cmd.normal({ "[c", bang = true })
      else
        gitsigns.nav_hunk("prev")
      end
    end, { desc = "Jump to previous git change" })

    -- Actions
    map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "Git [H]unk [S]tage" })
    map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "Git [H]unk [R]eset" })
    map("v", "<leader>hs", function()
      gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end, { desc = "Git [H]unk [S]tage (visual)" })
    map("v", "<leader>hr", function()
      gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end, { desc = "Git [H]unk [R]eset (visual)" })
    map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "Git [H]unk [S]tage buffer" })
    map("n", "<leader>hu", gitsigns.undo_stage_hunk, { desc = "Git [H]unk [U]ndo stage" })
    map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "Git [H]unk [R]eset buffer" })
    map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "Git [H]unk [P]review" })
    map("n", "<leader>hb", function()
      gitsigns.blame_line({ full = true })
    end, { desc = "Git [H]unk [B]lame line" })
    map("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "[T]oggle git [B]lame" })
    map("n", "<leader>hd", gitsigns.diffthis, { desc = "Git [H]unk [D]iff this" })
    map("n", "<leader>hD", function()
      gitsigns.diffthis("~")
    end, { desc = "Git [H]unk [D]iff this (~)" })
    map("n", "<leader>td", gitsigns.toggle_deleted, { desc = "[T]oggle git [D]eleted" })

    -- Text object
    map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select git hunk" })
  end,
})

-- Todo Comments Configuration
require("todo-comments").setup({
  signs = true,
  sign_priority = 8,
  keywords = {
    FIX = { icon = "🔧", color = "error" },
    TODO = { icon = "📌", color = "info" },
    HACK = { icon = "⚒️", color = "warning" },
    WARN = { icon = "⚠️", color = "warning" },
    PERF = { icon = "🚀", color = "info" },
    NOTE = { icon = "📝", color = "hint" },
  },
})

-- Indent-Blankline Configuration
local highlight = { "CursorColumn", "Whitespace" }
require("ibl").setup({
  indent = { highlight = highlight, char = "" },
  whitespace = { highlight = highlight, remove_blankline_trail = false },
  scope = { enabled = false },
  exclude = { filetypes = { "dashboard" } },
})

-- Barbar (Bufferline) Configuration
require("barbar").setup({
  animation = true,
  auto_hide = false,
  tabpages = true,
  clickable = true,
  icons = {
    buffer_index = false,
    buffer_number = false,
    button = "",
    filetype = { enabled = true },
    modified = { button = "●" },
    pinned = { button = "📌" },
  },
  highlight_alternate = false,
  highlight_inactive_file_icons = false,
  highlight_visible = true,
  maximum_padding = 1,
  minimum_padding = 1,
  maximum_length = 30,
  semantic_letters = true,
  sidebar_filetypes = {
    NvimTree = true,
    ["neo-tree"] = true,
  },
})

---
-- [[ Keybindings ]]
---

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { silent = true })

vim.keymap.set("n", "Y", '"+y', { noremap = true, silent = true })
vim.keymap.set("v", "Y", '"+y', { noremap = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Exit terminal mode in the builtin terminal
--
-- NOTE: This won't work in all terminal emulators/tmux/etc.
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Disable arrow keys in normal mode
-- vim.keymap.set("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')

-- Move between windows
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Telescope keymaps (Adapted from Kickstart.nvim)
-- Telescope Setup
require("telescope").setup({
  pickers = {
    find_files = { theme = "dropdown", previewer = true },
    buffers = { theme = "ivy", previewer = true },
    live_grep = { theme = "ivy", previewer = false },
    oldfiles = { theme = "dropdown", previewer = false },
    diagnostics = { theme = "ivy", previwer = true },
    builtin = { theme = "ivy", previwer = true },
    keymaps = { theme = "ivy", previwer = true },
    help_tags = { them = "ivy", previwer = true },
  },
})

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })

-- Slightly advanced Telescope for buffer fuzzy find
vim.keymap.set("n", "<leader>s/", function()
  builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
    winblend = 10,
    previewer = false,
  }))
end, { desc = "[S]earch [/] in current buffer" })

-- search files, including hidden ones
vim.keymap.set("n", "<leader>ff", function()
  builtin.find_files({ hidden = true })
end, { desc = "[F]ind [F]iles (including hidden)" })

---
-- [[ Autocommands ]]
---

-- highlight when yanking (copying) text
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("redacted-neex-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- [[ modeline ]]
-- vim: ts=2 sts=2 sw=2 et
