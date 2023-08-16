return {
	"mhartington/formatter.nvim",
	config = function()
		require("formatter").setup({
			logging = true,
			log_level = vim.log.levels.WARN,
			filetype = {
				lua = {
					-- require("formatter.filetypes.lua").stylua,
					require("plugins.formatter.settings.stylua"),
				},
				python = {
					-- require("formatter.filetypes.python").black,
					require("plugins.formatter.settings.black"),
				},
			},
		})
	end,
}
