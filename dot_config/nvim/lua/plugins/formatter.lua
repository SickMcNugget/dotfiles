return {
    "mhartington/formatter.nvim",
    cmd = { "Format" },
    config = function()
	require("formatter").setup({
	    logging = true,
	    log_level = vim.log.levels.WARN,
	    filetype = {
		lua = {
		    require("plugins.formatter.stylua"),
		},
		python = {
		    require("plugins.formatter.black"),
		},
	    },
	})
    end,
}
