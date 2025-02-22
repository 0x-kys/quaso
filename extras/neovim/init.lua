-- General Settings
vim.o.termguicolors = true
vim.o.background = "dark"
vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = "a"
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.wrap = true
vim.o.linebreak = true
vim.o.breakindent = true
vim.o.showbreak = "↳ "
vim.o.showtabline = 2
vim.o.cursorline = true
vim.o.showmode = false
vim.o.signcolumn = "yes"
vim.o.ignorecase = true
vim.o.smartcase = true

-- Theme and Transparency
vim.cmd([[colorscheme gruvbox]])
vim.g.gruvbox_contrast_dark = "hard"
vim.g.gruvbox_transparent_bg = 1

-- Cursor Settings
vim.opt.guicursor = {
	"n-v-c:block", -- Normal, visual, command-line: block cursor
	"i-ci-ve:ver25", -- Insert, command-line insert, visual-exclude: vertical bar
	"r-cr:hor20", -- Replace, command-line replace: horizontal bar
	"sm:block", -- Showmatch: block cursor
}
vim.api.nvim_set_hl(0, "Cursor", { fg = "#000000", bg = "#ffffff", reverse = true })
vim.api.nvim_set_hl(0, "CursorIM", { fg = "#000000", bg = "#ffffff", reverse = true })
vim.api.nvim_set_hl(0, "TermCursor", { fg = "#000000", bg = "#ffffff", reverse = true })
vim.opt.cursorline = true
vim.api.nvim_set_hl(0, "CursorLine", { bg = "none", underline = true })

-- Leader Key
vim.g.mapleader = " "

-- Transparency for UI Elements
for _, group in ipairs({
	"Normal",
	"NormalFloat",
	"FloatBorder",
	"SignColumn",
	"LineNr",
	"EndOfBuffer",
	"VertSplit",
	"StatusLine",
	"StatusLineNC",
	"TabLine",
	"TabLineFill",
	"TabLineSel",
}) do
	vim.api.nvim_set_hl(0, group, { bg = "none" })
end
vim.api.nvim_set_hl(0, "VertSplit", { bg = "none", fg = "#665c54" })

-- Additional Config
vim.opt.list = true
vim.opt.listchars = { tab = "→ ", space = " ", nbsp = "⍽", eol = "⏎", lead = "╎" }

-- Plugins Configuration

-- Lualine (Statusline)
require("lualine").setup({
	options = {
		icons_enabled = true,
		theme = "gruvbox",
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch", "diff", "diagnostics" },
		lualine_c = { "filename" },
		lualine_x = { "encoding", "fileformat", "filetype" },
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
})

-- LSP Configuration
local lspconfig = require("lspconfig")
local servers = {
	["nil_ls"] = {}, -- Nix
	["lua_ls"] = {}, -- Lua
	["gopls"] = {}, -- Go
	["pyright"] = {}, -- Python
	["clangd"] = {}, -- C/C++
	["svelte"] = {}, -- Svelte
	["ts_ls"] = {}, -- JS/TS
	["cssls"] = {}, -- CSS
	["html"] = {}, -- HTML
	["zls"] = {}, -- Zig
	["tailwindcss"] = {}, -- Tailwind CSS
	["marksman"] = {}, -- Markdown
	["rust_analyzer"] = {}, -- Rust
	["astro"] = {}, -- Astro
}

local on_attach = function(client, bufnr)
	client.server_capabilities.completionProvider = false
	if client.server_capabilities.inlayHintProvider then
		vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
	end

	local opts = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
	vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
	vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

	require("lsp_signature").on_attach({
		bind = true,
		handler_opts = { border = "rounded" },
	}, bufnr)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = false

for lsp, config in pairs(servers) do
	lspconfig[lsp].setup(vim.tbl_deep_extend("force", {
		on_attach = on_attach,
		capabilities = capabilities,
		flags = { debounce_text_changes = 150 },
	}, config))
end

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
	},
	highlight = { enable = true },
	indent = { enable = true },
})
vim.opt.runtimepath:append(vim.fn.stdpath("data") .. "/site")

-- Dashboard
math.randomseed(os.time()) -- Seed random generator for variety

local function get_fortune_quote()
	-- Call fortune with -s for short quotes (default max 160 chars) and -n to set a specific length
	local max_length = 80
	local fortune_cmd = string.format("fortune -s -n %d", max_length)

	-- Execute the command and capture output
	local quote = vim.fn.system(fortune_cmd)

	-- Clean up the output: remove trailing newlines and ensure it’s a single line
	quote = quote:gsub("\n$", ""):gsub("\n.*", "") -- Keep only the first line

	-- Fallback if fortune fails or isn’t installed
	if quote == "" or vim.v.shell_error ~= 0 then
		return "Code is poetry, when it works."
	end

	-- Ensure the quote fits within max_length (truncate if needed)
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
			"", -- Empty line for spacing
			get_fortune_quote(),
			"", -- Empty line after the quote
		},
		shortcut = {
			{ desc = "Recent Files", group = "DashboardShortCut", key = "r", action = "Telescope oldfiles" },
			{ desc = "Find File", group = "DashboardShortCut", key = "f", action = "Telescope find_files" },
		},
		footer = {}, -- Override default footer to remove number of loaded plugins
	},
})

-- Conform (Formatter)
require("conform").setup({
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
		lua = { "stylua" },
	},
	format_on_save = {
		lsp_fallback = false,
		timeout_ms = 500,
	},
})

-- Keybindings

-- Clear search highlight
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { silent = true })

-- Format document
vim.keymap.set("n", "<leader>f", function()
	require("conform").format({ async = true, lsp_fallback = false })
end, { desc = "Format Document" })

-- Clipboard
vim.keymap.set("n", "Y", '"+y', { noremap = true, silent = true })
vim.keymap.set("v", "Y", '"+y', { noremap = true, silent = true })

-- Tab Navigation
vim.keymap.set("n", "<A-,>", "<cmd>BufferPrevious<cr>", { desc = "Previous Tab" })
vim.keymap.set("n", "<A-.>", "<cmd>BufferNext<cr>", { desc = "Next Tab" })
vim.keymap.set("n", "<A-w>", "<cmd>BufferClose<cr>", { desc = "Close Tab" })

-- Telescope Setup
local telescope = require("telescope")
telescope.setup({
	pickers = {
		find_files = { theme = "dropdown", previewer = true },
		buffers = { theme = "ivy", previewer = true },
		live_grep = { theme = "ivy", previewer = false },
		oldfiles = { theme = "dropdown", previewer = false },
	},
})
vim.keymap.set("n", "<leader>sf", "<cmd>Telescope find_files<cr>", { desc = "File Picker" })
vim.keymap.set("n", "<leader>sw", "<cmd>Telescope live_grep<cr>", { desc = "Live Grep" })
vim.keymap.set("n", "<leader>sb", "<cmd>Telescope buffers<cr>", { desc = "Buffer Picker" })
vim.keymap.set("n", "<leader>sr", "<cmd>Telescope oldfiles<cr>", { desc = "Recent Files" })

-- Diagnostics
require("trouble").setup({})
vim.keymap.set("n", "<leader>d", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Toggle Diagnostics" })
