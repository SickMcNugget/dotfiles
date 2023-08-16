return {
	"christoomey/vim-tmux-navigator",
	config = function()
		vim.keymap.set("n", "<C-h>", vim.cmd.TmuxNavigateLeft)
		vim.keymap.set("n", "<C-j>", vim.cmd.TmuxNavigateUp)
		vim.keymap.set("n", "<C-k>", vim.cmd.TmuxNavigateDown)
		vim.keymap.set("n", "<C-l>", vim.cmd.TmuxNavigateRight)
	end,
}
