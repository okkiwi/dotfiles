vim.g.mapleader = " "
vim.g.maplocalleader = " "

--------------- LAZY BOOTSTRAP ---------------

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

--------------- LAZY PLUGINS ---------------

require("lazy").setup({
	-- gruvbox
	{ "ellisonleao/gruvbox.nvim", priority = 1000, config = true, opts = ... },

	-- fzf
	{ "ibhagwan/fzf-lua" },

	-- utils
	{ "windwp/nvim-autopairs", event = "InsertEnter", config = true },
	{ "tpope/vim-sleuth" },
	{ "sbdchd/neoformat" },
	{ "folke/ts-comments.nvim", opts = {}, event = "VeryLazy" },

	-- lsp & treesitter
	{ "neovim/nvim-lspconfig" },
	{ "nvim-treesitter/nvim-treesitter" },

	-- autocomplete
	{ "hrsh7th/cmp-nvim-lsp" },
	{ "hrsh7th/cmp-buffer" },
	{ "hrsh7th/cmp-path" },
	{ "hrsh7th/cmp-cmdline" },
	{ "hrsh7th/nvim-cmp" },
})

--------------- PLUGINS CONFIGS ---------------

-- gruvbox
vim.o.background = "dark"
vim.cmd([[colorscheme gruvbox]])

-- fzf
require("fzf-lua").setup({
	winopts = { height = 0.95, width = 0.95 },
	keymap = {
		builtin = { ["<C-d>"] = "preview-down", ["<C-u>"] = "preview-up" },
		fzf = { ["ctrl-d"] = "preview-down", ["ctrl-u"] = "preview-up" },
	},
})

-- treesitter
require("nvim-treesitter.configs").setup({
	auto_install = true,
	highlight = { enable = true, additional_vim_regex_highlighting = false },
})

-- cmp
local cmp = require("cmp")
cmp.setup({
	mapping = cmp.mapping.preset.insert({
		["<C-j>"] = cmp.mapping.select_next_item(),
		["<C-k>"] = cmp.mapping.select_prev_item(),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "path" },
	}, { { name = "buffer" } }),
})

cmp.setup.cmdline({ "/", "?" }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = { { name = "buffer" } },
})

cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
	matching = { disallow_symbol_nonprefix_matching = false },
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- lsp
require("lspconfig")["clangd"].setup({ capabilities = capabilities })
require("lspconfig")["cssls"].setup({ capabilities = capabilities })
require("lspconfig")["html"].setup({ capabilities = capabilities })
require("lspconfig")["ts_ls"].setup({ capabilities = capabilities })

--------------- KEYS ---------------

-- fzf
vim.keymap.set("n", "<leader>p", require("fzf-lua").files)
vim.keymap.set("n", "<leader>g", require("fzf-lua").git_status)
vim.keymap.set("n", "<leader>f", require("fzf-lua").live_grep)
vim.keymap.set("n", "<leader>h", require("fzf-lua").git_bcommits)

-- lsp
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, noremap = true, silent = true })
vim.keymap.set("n", "<leader>k", vim.diagnostic.open_float, { buffer = bufnr, noremap = true, silent = true })

-- neoformat
vim.keymap.set("n", "<leader>i", ":Neoformat<cr>")

-- netrw
vim.keymap.set("n", "-", ":Ex<cr>")

--------------- SETS ---------------

vim.o.swapfile = false
vim.o.backup = false
vim.o.updatetime = 300
vim.o.signcolumn = "yes"
vim.o.number = true
vim.o.relativenumber = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.wrap = false
vim.o.mouse = ""
vim.o.expandtab = true
vim.o.clipboard = "unnamedplus"
vim.g.netrw_banner = false
