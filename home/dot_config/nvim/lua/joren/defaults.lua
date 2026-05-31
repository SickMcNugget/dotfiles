-- [[ Setting options ]]
-- See `:h vim.o`, `:h vim.wo`, `:h vim.g`, `h vim.filetype`

-- Disable highlighting on search (except the current word)
vim.o.hlsearch = false
vim.wo.number = true
vim.wo.relativenumber = true
-- Enable mouse for all modes
vim.o.mouse = "a"
-- retain indentation on wrapped lines
vim.o.breakindent = true
-- Saves up to vim.o.undolevel (1000 by default) entries in a file.
-- This allows undo to be saved even after quitting nvim.
vim.o.undofile = true
-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true
-- Keep signcolumn on by default
vim.wo.signcolumn = "yes"
-- Leave an 8 line buffer at the top and bottom of the screen
-- Remember that zz exists to center the screen!
vim.o.scrolloff = 8
-- Decrease swapfile write and keybind input delays
vim.o.updatetime = 250
vim.o.timeoutlen = 300
-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect,fuzzy"
-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true
-- Set indentations to fallback to 4 character width. sts and sw are auto-set:
--	softtabstop <- shiftwidth <- tabstop = 4
--	Regardless, vim-sleuth should auto-set better values for each buffer.
vim.o.tabstop = 4
vim.o.softtabstop = -1
vim.o.shiftwidth = 0
vim.o.smartindent = true
--  Note that this resulted in massive slowdown for startup (~250ms)
--  Learn to use registers (y"+)
-- vim.o.clipboard = "unnamedplus"
-- custom filetypes
vim.filetype.add({
	extension = {
		slint = "slint",
	},
	filename = {
		['.bash_functions'] = 'bash'
	},
})
-- See `:help vim.hl.on_yank()`
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.hl.on_yank({ timeout = 75 })
	end,
	group = highlight_group,
	pattern = "*",
})
-- I'm not sure these are useful, so I've disabled them for startup time
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
-- The sauce
vim.g.mapleader = " "
vim.g.maplocalleader = " "
