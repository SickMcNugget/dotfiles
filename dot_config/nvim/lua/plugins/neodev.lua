return {
    "folke/neodev.nvim",
--  event = "LspAttach",
    config = function()
	require("neodev").setup({
	    library = {
		enabled = true,
		runtime = true,
		types = true,
		plugins = true,
	    },
	    setup_jsonls = true,
	    lspconfig = false,
	    pathStrict = true,
	})
    end,
}
