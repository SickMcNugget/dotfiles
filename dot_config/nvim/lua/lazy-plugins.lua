-- prepare lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local opts = {
	defaults = {
		lazy = true,
	},
	install = {
		colorscheme = { "tokyonight" },
	},
	ui = {
		border = "single",
	},
	diff = {
		-- Options:
		-- git: use git diffs
		-- browser: open diff in GitHub
		-- terminal_git: opens a pseudo terminal (wut) with git diff
		-- diffview.nvim: opens Diffview to show diffs
		cmd = "git",
	},
	checker = {
		enabled = false,
		concurrency = nil,
		notify = false,
		frequency = 3600, --seconds
	},
	change_detection = {
		enabled = true,
		notify = true,
	},
	performance = {
		cache = {
			enabled = true,
		},
		rtp = {
			reset = true,
			disabled_plugins = {
				"gzip",
				-- "matchit",
				-- "matchparen",
				-- "netrwPlugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
				"osc52",
			},
		},
	},
}

local status_ok, lazy = pcall(require, "lazy")
if not status_ok then
	return
end

lazy.setup({
	{
		"tpope/vim-rhubarb",
		cmd = { "Git" },
	},
	{
		"tpope/vim-fugitive",
		cmd = { "Git" },
	},
	{
		"tpope/vim-sleuth",
		event = { "BufReadPost", "BufNewFile", "BufFilePost" },
	},
	{
		"nvim-lualine/lualine.nvim",
		event = { "UIEnter" },
		opts = require("plugins.opts.lualine"),
	},
	{
		"numToStr/Comment.nvim",
		keys = {
			{ "gb", mode = "o" },
			{ "gc", mode = "o" },
			{ "gcc" },
			{ "gbc" },
			{ "gco" },
			{ "gcO" },
			{ "gcA" },
			{ "gc", mode = "x" },
			{ "gb", mode = "x" },
		},
		opts = require("plugins.opts.Comment"),
	},
	{
		"alker0/chezmoi.vim",
		lazy = false,
		init = function()
			vim.g["chezmoi#use_tmp_buffer"] = true
		end,
	},
	{
		require("plugins.undotree"),
		"mbbill/undotree",
		keys = {
			{ "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "UndoTree Toggle" },
		},
		config = function()
			vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPost", "BufNewFile" },
		opts = require("plugins.opts.gitsigns"),
	},
	{
		require("plugins.nvim-cmp"),
	},
	{
		require("plugins.telescope"),
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
	},
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			style = "moon",
		},
	},
	{
		require("plugins.treesitter"),
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		event = { "UIEnter" },
		opts = {
			indent = { char = "┊" },
			scope = { exclude = { language = { "python" } } },
		},
	},
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = {
			{
				require("plugins.neodev"),
			},
			{
				require("plugins.mason"),
			},
			{
				"j-hui/fidget.nvim",
				opts = require("plugins.opts.fidget"),
			},
		},
	},
	{
		"mfussenegger/nvim-dap",
		keys = {
			-- 	Add arguments later by following this link: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/dap/core.lua
			{
				"<F5>",
				function()
					require("dap").continue()
				end,
				desc = "Debug: Start/Continue",
			},
			{
				"<F1>",
				function()
					require("dap").step_into()
				end,
				desc = "Debug: Step Into",
			},
			{
				"<F2>",
				function()
					require("dap").step_over()
				end,
				desc = "Debug: Step Over",
			},
			{
				"<F3>",
				function()
					require("dap").step_out()
				end,
				desc = "Debug: Step Out",
			},
			{
				"<leader>b",
				function()
					require("dap").continue()
				end,
				desc = "Debug: Toggle Breakpoint",
			},
			{
				"<leader>B",
				function()
					require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
				end,
				desc = "Debug: Set Breakpoint",
			},
		},
		dependencies = {
			{
				require("plugins.nvim-dap-ui"),
			},
			{
				require("plugins.mason-nvim-dap"),
			},
		},
	},
	{
		"mhartington/formatter.nvim",
		cmd = { "Format" },
		config = require("plugins.config.formatter"),
	},
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = function() vim.fn["mkdp#util#install"]() end,
	},
}, opts)
