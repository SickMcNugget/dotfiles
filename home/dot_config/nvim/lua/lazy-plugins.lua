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

local lazy_opts = {
	defaults = {
		lazy = true,
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
		reset_packpath = true,
		rtp = {
			reset = true,
			disabled_plugins = {
				"gzip",
				-- "matchit",
				-- "matchparen",
				-- "netrwPlugin",
				"tarPlugin",
				"tohtml",
				"zipPlugin",
				"tutor",
				"osc52",
			},
		},
	},
	-- profiling = {
	-- 	loader = true,
	-- 	require = true,
	-- },
	rocks = {
		enabled = false,
	},
}

local status_ok, lazy = pcall(require, "lazy")
if not status_ok then
	return
end

lazy.setup({
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd([[colorscheme tokyonight-moon]])
		end,
	},
	{
		"tpope/vim-sleuth",
		event = { "BufReadPost", "BufNewFile", "BufFilePost" },
	},
	{
		require("plugins.lualine"),
	},
	{
		require("plugins.Comment"),
	},
	{
		"alker0/chezmoi.vim",
		lazy = false,
		init = function()
			vim.g["chezmoi#use_tmp_buffer"] = true
		end,
	},
	{
		require("plugins.gitsigns"),
	},
	-- {
	-- 	require("plugins.nvim-cmp"),
	-- },
	{
		require("plugins.telescope"),
	},
	{
		require("plugins.which-key"),
	},
	{
		require("plugins.nvim-treesitter"),
	},
	{
		require("plugins.nvim-treesitter-textobjects"),
	},
	{
		"kylechui/nvim-surround",
		version = "^3.0.0", -- use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		opts = {},
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		version = "^3.0.0",
		event = { "uienter" },
		opts = {
			indent = { char = "┊" },
			scope = { exclude = { language = { "python" } } },
		},
	},
	{
		-- replacement for neodev
		require("plugins.lazydev"),
	},
	{
		-- Contains mason.nvim, mason-lspconfig.nvim, fidget.nvim, too.
		-- blink is configured elsewhere but listed as a dependency here.
		require("plugins.nvim-lspconfig"),
	},
	{
		-- Contains LuaSnip and friendly-snippets setup, too.
		require("plugins.blink"),
	},
	{
		-- Contains mason-nvim-dap.nvim and nvim-dap-ui, nvim-nio
		-- mason.nvim is configured elsewhere, but is listed as a dependency here.
		require("plugins.nvim-dap"),
	},
	{
		"stevearc/conform.nvim",
		tag = "v9.0.0",
		event = "VeryLazy",
		opts = {
			format_on_save = function(_)
				if vim.g.disable_autoformat then
					return
				end
				return {
					timeout_ms = 500,
					lsp_format = "fallback",
				}
			end,
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "black" },
			},
		},
		config = function(_, opts)
			require("conform").setup(opts)

			vim.api.nvim_create_user_command("FormatDisable", function(_)
				vim.g.disable_autoformat = true
			end, {
				desc = "Disable autoformat-on-save",
			})
			vim.api.nvim_create_user_command("FormatEnable", function(_)
				vim.g.disable_autoformat = false
			end, {
				desc = "Enable autoformat-on-save",
			})
		end,
	},
	{
		"OXY2DEV/markview.nvim",
		lazy = false,
		opts = {
			markdown = {
				headings = {
					heading_1 = { sign = "" },
					heading_2 = { sign = "" },
				},
				code_blocks = {
					sign = false,
				},
			},
			typst = {
				enable = false,
			},
			latex = {
				enable = false,
			},
			preview = {
				icon_provider = "internal",
			},
		},
		ft = { "markdown" },
	},
	{
		"lambdalisue/suda.vim",
		lazy = false,
		-- event = "VeryLazy",
		init = function()
			vim.g["suda_smart_edit"] = 1
		end,
	},
	-- {
	-- 	"windwp/nvim-autopairs",
	-- 	event = "InsertEnter",
	-- 	config = true,
	-- },
}, lazy_opts)
