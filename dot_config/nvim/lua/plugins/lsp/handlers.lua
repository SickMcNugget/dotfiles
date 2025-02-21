local ret = {}

local cmp_nvim_lsp = require("cmp_nvim_lsp")

local capabilities = vim.lsp.protocol.make_client_capabilities()
ret.capabilities = cmp_nvim_lsp.default_capabilities(capabilities)

local function lsp_keymaps(bufnr)
	local function keymap(keys, func, desc)
		if desc then
			desc = "LSP: " .. desc
		end

		vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
	end

	keymap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
	keymap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

	keymap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
	keymap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
	keymap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
	keymap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
	-- keymap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
	-- keymap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

	-- See `:help K` for why this keymap
	keymap("K", vim.lsp.buf.hover, "Hover Documentation")
	keymap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")
end

-- local function formatting(bufnr)
--   vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
--     vim.lsp.buf.format()
--   end, { desc = 'Format current buffer with LSP' })
-- end

ret.on_attach = function(_, bufnr)
	lsp_keymaps(bufnr)
	-- formatting(bufnr)
end

return ret
