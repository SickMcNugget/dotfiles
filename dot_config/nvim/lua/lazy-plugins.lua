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
		colorscheme = { "onedark", "habamax" },
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
		notify = false,
	},
	performance = {
		rtp = {
			reset = false,
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

lazy.setup("plugins", opts)
