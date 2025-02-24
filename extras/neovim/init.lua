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

-- Theme Setup
vim.cmd([[colorscheme gruvbox-material]])
vim.api.nvim_set_hl(0, "Normal", { bg = "#1d2021" })

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

-- Leader Key
vim.g.mapleader = " "

-- Transparency for UI Elements
for _, group in ipairs({
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
vim.opt.listchars = { tab = "→ ", space = " ", nbsp = "⍽", eol = "⏎" }
vim.api.nvim_set_hl(0, "SpecialKey", { fg = "#a89984", bg = "#1d2021" })

-- Define Diagnostic Signs with Nerd Font Icons
vim.fn.sign_define(
	"DiagnosticSignError",
	{ text = "", texthl = "DiagnosticSignError", numhl = "DiagnosticSignError" }
)
vim.fn.sign_define("DiagnosticSignWarn", { text = "", texthl = "DiagnosticSignWarn", numhl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo", { text = "", texthl = "DiagnosticSignInfo", numhl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = "󰌵", texthl = "DiagnosticSignHint", numhl = "DiagnosticSignHint" })

-- Define Diagnostic Highlights
vim.api.nvim_set_hl(0, "DiagnosticSignError", { fg = "#fb4934", bg = "#1d2021" })
vim.api.nvim_set_hl(0, "DiagnosticSignWarn", { fg = "#fe8019", bg = "#1d2021" })
vim.api.nvim_set_hl(0, "DiagnosticSignInfo", { fg = "#83a598", bg = "#1d2021" })
vim.api.nvim_set_hl(0, "DiagnosticSignHint", { fg = "#8ec07c", bg = "#1d2021" })

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

local function lsp_progress()
	local clients = vim.lsp.get_clients()
	local progress = ""
	for _, client in ipairs(clients) do
		if client.messages and client.messages.progress then
			progress = progress .. client.name .. " "
		end
	end
	return progress == "" and "No LSP" or "LSP: " .. progress
end

local config = {
	options = {
		component_separators = "",
		section_separators = { left = "", right = "" },
		theme = "gruvbox-material",
		disabled_filetypes = { "dashboard", "NvimTree" },
		globalstatus = true,
	},
	sections = {
		lualine_a = {
			{
				"mode",
				separator = { left = "" },
				right_padding = 2,
				icon = "",
			},
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
			{ lsp_progress, color = { fg = "#8ec07c" }, cond = conditions.hide_in_width },
			{ "encoding", cond = conditions.hide_in_width },
			{ "fileformat", icons_enabled = true, icon = "", cond = conditions.hide_in_width },
			{ "filetype", cond = conditions.hide_in_width },
		},
		lualine_y = {
			{ "progress", separator = "", padding = { left = 1, right = 1 }, cond = conditions.hide_in_width },
		},
		lualine_z = {
			{
				"location",
				separator = { right = "" },
				left_padding = 2,
				cond = conditions.hide_in_width,
			},
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
}

require("lualine").setup(config)

-- LSP Configuration with Enhanced Capabilities
local lspconfig = require("lspconfig")

-- Map LSP servers to their filetypes
local lsp_filetypes = {
	["nil_ls"] = { "nix" },
	["lua_ls"] = { "lua" },
	["gopls"] = { "go" },
	["pyright"] = { "python" },
	["clangd"] = { "c", "cpp" },
	["svelte"] = { "svelte" },
	["ts_ls"] = { "javascript", "typescript" },
	["cssls"] = { "css" },
	["html"] = { "html" },
	["zls"] = { "zig" },
	["tailwindcss"] = { "css", "html", "javascript", "typescript", "svelte" },
	["marksman"] = { "markdown" },
	["rust_analyzer"] = { "rust" },
	["astro"] = { "astro" },
}

local on_attach = function(client, bufnr)
	if client.server_capabilities.inlayHintProvider then
		vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
	end

	local opts = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
	vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
	vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

	require("lsp_signature").on_attach({ bind = true, handler_opts = { border = "rounded" } }, bufnr)
end

local capabilities = require("cmp_nvim_lsp").default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- Setup LSP servers
for lsp, filetypes in pairs(lsp_filetypes) do
	lspconfig[lsp].setup({
		on_attach = on_attach,
		capabilities = capabilities,
		flags = { debounce_text_changes = 150 },
		filetypes = filetypes, -- Explicitly specify supported filetypes
	})
end

-- Autocommand to manage LSP attachment
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*",
	callback = function()
		local bufnr = vim.api.nvim_get_current_buf()
		local filetype = vim.bo[bufnr].filetype

		-- Detach all LSP clients first
		for _, client in ipairs(vim.lsp.get_clients()) do
			if vim.lsp.buf_is_attached(bufnr, client.id) then
				vim.lsp.buf_detach_client(bufnr, client.id)
			end
		end

		-- Attach only the appropriate LSP client(s) based on filetype
		for lsp, supported_filetypes in pairs(lsp_filetypes) do
			if vim.tbl_contains(supported_filetypes, filetype) then
				local client = vim.lsp.get_client_by_id(vim.lsp.start_client(lspconfig[lsp].default_config))
				if client then
					vim.lsp.buf_attach_client(bufnr, client.id)
				end
			end
		end
	end,
})

-- Autocompletion with nvim-cmp
local cmp = require("cmp")
cmp.setup({
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "buffer" },
		{ name = "path" },
	}),
	formatting = {
		format = function(entry, vim_item)
			vim_item.menu = ({
				nvim_lsp = "[LSP]",
				luasnip = "[Snippet]",
				buffer = "[Buffer]",
				path = "[Path]",
			})[entry.source.name]
			return vim_item
		end,
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
	},
	highlight = { enable = true },
	indent = { enable = true },
})
vim.opt.runtimepath:append(vim.fn.stdpath("data") .. "/site")

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
			{ desc = "Find File", group = "DashboardShortCut", key = "f", action = "Telescope find_files" },
		},
		mru = { enable = true, limit = 10, label = "Recent Files", cwd_only = false },
		footer = {},
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
	format_on_save = { lsp_fallback = false, timeout_ms = 500 },
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

-- GitSigns Configuration
require("gitsigns").setup({
	signs = {
		add = { text = "+" },
		change = { text = "~" },
		delete = { text = "-" },
		topdelete = { text = "‾" },
		changedelete = { text = "~" },
	},
	numhl = true,
	linehl = false,
	watch_gitdir = { interval = 1000, follow_files = true },
	attach_to_untracked = true,
	current_line_blame = false,
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
		diagnostics = {
			[vim.diagnostic.severity.ERROR] = { enabled = true, icon = " " },
			[vim.diagnostic.severity.WARN] = { enabled = true, icon = " " },
			[vim.diagnostic.severity.INFO] = { enabled = true, icon = " " },
			[vim.diagnostic.severity.HINT] = { enabled = true, icon = "󰌵 " },
		},
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

-- Which-Key Configuration
require("which-key").setup({
	plugins = {
		marks = true,
		registers = true,
		spelling = { enabled = true, suggestions = 20 },
		presets = {
			operators = true,
			motions = true,
			text_objects = true,
			windows = true,
			nav = true,
			z = true,
			g = true,
		},
	},
	win = {
		border = "rounded",
		position = "bottom",
		margin = { 1, 0, 1, 0 },
		padding = { 2, 2, 2, 2 },
	},
	layout = { align = "center" },
})

require("which-key").add({
	{ "<A-,>", "<cmd>BufferPrevious<cr>", desc = "Previous Tab", mode = "n" },
	{ "<A-.>", "<cmd>BufferNext<cr>", desc = "Next Tab", mode = "n" },
	{ "<A-w>", "<cmd>BufferClose<cr>", desc = "Close Tab", mode = "n" },
	{ "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", desc = "Code Action", mode = "n" },
	{ "<leader>d", "<cmd>Trouble diagnostics toggle<cr>", desc = "Toggle Diagnostics", mode = "n" },
	{
		"<leader>f",
		"<cmd>lua require('conform').format({ async = true, lsp_fallback = false })<cr>",
		desc = "Format Document",
		mode = "n",
	},
	{ "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>", desc = "Rename", mode = "n" },
	{ "<leader>s", group = "Search" },
	{ "<leader>sb", "<cmd>Telescope buffers<cr>", desc = "Buffers", mode = "n" },
	{ "<leader>sf", "<cmd>Telescope find_files<cr>", desc = "Find File", mode = "n" },
	{ "<leader>sr", "<cmd>Telescope oldfiles<cr>", desc = "Recent Files", mode = "n" },
	{ "<leader>sw", "<cmd>Telescope live_grep<cr>", desc = "Live Grep", mode = "n" },
})

-- Keybindings
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { silent = true })
vim.keymap.set("n", "Y", '"+y', { noremap = true, silent = true })
vim.keymap.set("v", "Y", '"+y', { noremap = true, silent = true })

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

-- Diagnostics
require("trouble").setup({})
