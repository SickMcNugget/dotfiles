return {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = "williamboman/mason.nvim",
    cmd = { "DapInstall", "DapUninstall" },
    opts = {
	ensure_installed = {
	    "python@1.6.7",
	},
	automatic_installation = true,
	handlers = {
	    function(config)
		require("mason-nvim-dap").default_setup(config)
	    end
	},
    },
}
