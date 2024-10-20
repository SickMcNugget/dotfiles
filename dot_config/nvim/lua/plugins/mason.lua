return {
	"williamboman/mason.nvim",
	cmd = { "Mason" },
	dependencies = "williamboman/mason-lspconfig.nvim",
	config = function()
		local mason = require("mason")
		local mason_lspconfig = require("mason-lspconfig")
		local lspconfig = require("lspconfig")

		local auto_install = {
			"pylsp",
			"lua_ls",
		}

		mason.setup({
			ui = {
				check_outdated_packages_on_open = false,
				border = "none",
			},
		})

		mason_lspconfig.setup({
			ensure_installed = auto_install,
		})

		mason_lspconfig.setup_handlers({
			function(server_name)
				local opts = {
					on_attach = require("plugins.lsp.handlers").on_attach,
					capabilities = require("plugins.lsp.handlers").capabilities,
				}

				local require_ok, server = pcall(require, "plugins.lsp.settings." .. server_name)
				if require_ok then
					opts = vim.tbl_deep_extend("force", server, opts)
				end

				lspconfig[server_name].setup(opts)
			end,
		})
	end,
}
