return {
	"folke/lazydev.nvim",
	ft = "lua",
	tag = "v1.9.0",
	opts = {
		library = {
			{ path = "${3rd}/lub/library", words = { "vim%.uv" } },
			vim.fn.stdpath("config") .. "/lua/plugins",
		},
	},
}
