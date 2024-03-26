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
				"zipPlugin",
				"tutor",
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
		"tpope/vim-fugitive",
		event = "VeryLazy",
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
		"mbbill/undotree",
		keys = {
			{ "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "UndoTree Toggle" },
		},
		config = function()
			vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
		end,
		opts = {},
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
		opts = {},
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
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		opts = {},
		-- config = function()
		-- 	require("nvim-surround").setup({
		-- 		-- Configuration here, or leave empty to use defaults
		-- 	})
		-- end,
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
					require("dap").toggle_breakpoint()
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
		opts = {},
	},
	{
		"stevearc/conform.nvim",
		event = "VeryLazy",
		opts = {
			format_on_save = {
				timeout_ms = 500,
				lsp_fallback = true,
			},
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "black" },
			},
		},
	},
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
		-- init function below provided by a lovely GitHub user @anuramat
		-- https://github.com/iamcco/markdown-preview.nvim/issues/585#issuecomment-1724859362
		init = function()
			local function load_then_exec(cmd)
				return function()
					vim.cmd.delcommand(cmd)
					require("lazy").load({ plugins = { "markdown-preview.nvim" } })
					vim.api.nvim_exec_autocmds("BufEnter", {}) -- commands appear only after BufEnter
					vim.cmd(cmd)
				end
			end
			for _, cmd in pairs({ "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle" }) do
				vim.api.nvim_create_user_command(cmd, load_then_exec(cmd), {})
			end
		end,
	},
	{
		"lervag/vimtex",
		lazy = false,
		init = function()
			vim.g.vimtex_view_method = "zathura"
			vim.g.vimtex_compiler_method = "latexmk"
		end,
	},
	{
		"kkoomen/vim-doge",
		lazy = false,
		build = function()
			vim.fn["doge#install"]()
		end,
		init = function()
			vim.g["doge_doc_standard_python"] = "numpy"
		end,
		config = function()
			vim.keymap.set("n", "<Leader>d", "<Plug>(doge-generate)")
		end,
	},
	{
		"lambdalisue/suda.vim",
		lazy = false,
		-- event = "VeryLazy",
		init = function()
			vim.g["suda_smart_edit"] = 1
		end
	},
}, opts)
