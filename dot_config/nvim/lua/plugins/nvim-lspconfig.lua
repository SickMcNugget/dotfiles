-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.

return {
	"neovim/nvim-lspconfig",
	tag = "v2.3.0",
	event = { "BufReadPost", "BufNewFile" },
	dependencies = {
		{ "mason-org/mason.nvim", tag = "v2.0.0", opts = {}, cmd = "Mason" },
		"mason-org/mason-lspconfig.nvim",
		tag = "v2.0.0",
		{ "j-hui/fidget.nvim",    tag = "v1.6.1", opts = {} },
		"saghen/blink.cmp",
	},
	config = function()
		local mason = require("mason")
		local mason_lspconfig = require("mason-lspconfig")

		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(event)
				local map = function(keys, func, desc, mode)
					mode = mode or "n"
					vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
				end

				map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
				map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
				map("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
				map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
				map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
				map("gm", vim.lsp.buf.implementation, "[G]oto I[m]plementation")
				map("gt", vim.lsp.buf.type_definition, "[G]oto [T]ype Definition")
				map("K", vim.lsp.buf.hover, "Hover Documentation")
				map("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")
			end,
		})

		vim.diagnostic.config({
			severity_sort = true,
			float = { border = "none", source = "if_many" },
			underline = { severity = vim.diagnostic.severity.ERROR },
			signs = {},
			virtual_text = {
				source = "if_many",
				spacing = 2,
				format = function(diagnostic)
					local diagnostic_message = {
						[vim.diagnostic.severity.ERROR] = diagnostic.message,
						[vim.diagnostic.severity.WARN] = diagnostic.message,
						[vim.diagnostic.severity.INFO] = diagnostic.message,
						[vim.diagnostic.severity.HINT] = diagnostic.message,
					}
					return diagnostic_message[diagnostic.severity]
				end,
			},
		})

		-- includes builtin LSP capabilities with no overrides (currently)
		-- Support for custom configuration in the vim.fn.stdpath("config") .. /lua/plugins/lsp/ directory
		local servers = {
			rust_analyzer = {},
			clangd = {},
			lua_ls = {},
			pylsp = {},
		}

		for server, _ in pairs(servers) do
			local ok, config = pcall(require, "plugins.lsp." .. server)
			if ok and not vim.tbl_isempty(config) then
				vim.lsp.config(server, config)
			end
		end

		-- If I want tool install support, add https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim

		-- Our UI for installing/managing DAPs, LSPs, formatters, linters
		mason.setup({
			ui = {
				check_outdated_packages_on_open = false,
				border = "single",
			},
		})

		-- Our automated LSP install/enable tool
		mason_lspconfig.setup({
			ensure_installed = servers,
			automatic_enable = true,
		})

		-- Might want to manually enable extra servers below in the future
		-- if not vim.tbl_isempty(servers.others) then
		-- 	vim.lsp.enable(vim.tbl_keys(servers.other))
		-- end
	end,
}
