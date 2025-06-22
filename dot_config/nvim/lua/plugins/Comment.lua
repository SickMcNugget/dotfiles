return {
	"numToStr/Comment.nvim",
	-- Use :h map-table to determine what 'modes' do
	keys = {
		{ "gb", mode = "o" },
		{ "gc", mode = "o" },
		{ "gcc" },
		{ "gc", mode = "x" },
		{ "gb", mode = "x" },
	},
	config = function()
		local comment = require("Comment")
		local api = require("Comment.api")
		local ft = require("Comment.ft")
		comment.setup({
			padding = true,
			sticky = true,
			ignore = nil,
			mappings = false,
			pre_hook = nil,
			post_hook = nil,
		})
		ft.slint = { "//%s", "/*%s*/" }

		-- Normal mode (no motion) mapping
		-- for a [count] linewise comment, do [count]gcj, instead of [count]gcc
		vim.keymap.set(
			"n",
			"gcc",
			api.call("toggle.linewise.current", "g@$"),
			{ expr = true, desc = "Toggle linewise comment" }
		)

		-- motion mappings
		vim.keymap.set(
			"n",
			"gc",
			api.call("toggle.linewise", "g@"),
			{ expr = true, desc = "Toggle linewise comment (motion)" }
		)

		vim.keymap.set(
			"n",
			"gb",
			api.call("toggle.blockwise", "g@"),
			{ expr = true, desc = "Toggle blockwise comment (motion)" }
		)

		-- Visual mode mappings
		local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
		vim.keymap.set("x", "gc", function()
			vim.api.nvim_feedkeys(esc, "nx", false)
			api.toggle.linewise(vim.fn.visualmode())
		end, { desc = "Visual Mode: Toggle linewise comment" })
		vim.keymap.set("x", "gb", function()
			vim.api.nvim_feedkeys(esc, "nx", false)
			api.toggle.linewise(vim.fn.visualmode())
		end, { desc = "Visual Mode: Toggle linewise comment" })
	end,
}
