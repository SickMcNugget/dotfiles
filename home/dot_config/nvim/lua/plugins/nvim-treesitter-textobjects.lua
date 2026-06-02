return {
	"nvim-treesitter/nvim-treesitter-textobjects",
	branch = "main",
	init = function()
		-- Disable entire built-in ftplugin mappings to avoid conflicts.
		-- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
		vim.g.no_plugin_maps = true
	end,
	config = function()
		require("nvim-treesitter-textobjects").setup({
			select = {
				lookahead = true,
				include_surrounding_whitespace = false,
			},
			move = {
				set_jumps = true,
			},
		})

		local function map_select(keymap, object)
			vim.keymap.set({ "x", "o" }, keymap, function()
				require("nvim-treesitter-textobjects.select").select_textobject(object, "textobjects")
			end)
		end

		map_select("ac", "@class.outer")
		map_select("ic", "@class.inner")
		map_select("af", "@function.outer")
		map_select("if", "@function.inner")
		map_select("aa", "@parameter.outer")
		map_select("ia", "@parameter.inner")

		-- types:
		--	1. goto_next_start
		--	2. goto_next_end
		--	3. goto_previous_start
		--	4. goto_previous_end
		local function map_move(keymap, object, type)
			local modes = { "n", "x", "o" }
			local move = require("nvim-treesitter-textobjects.move")

			local move_type = nil
			local type_repr = nil
			if type == 1 then
				move_type = move.goto_next_start
				type_repr = "start of next "
			elseif type == 2 then
				move_type = move.goto_next_end
				type_repr = "end of next "
			elseif type == 3 then
				move_type = move.goto_previous_start
				type_repr = "start of previous "
			elseif type == 4 then
				move_type = move.goto_previous_end
				type_repr = "end of previous "
			else
				return
			end

			vim.keymap.set(modes, keymap, function()
				move_type(object, "textobjects")
			end, { desc = "[" .. keymap .. "] Jump to " .. type_repr .. object })
		end

		map_move("]f", "@function.outer", 1)
		map_move("]c", "@class.outer", 1)
		map_move("]a", "@parameter.inner", 1)

		map_move("]F", "@function.outer", 2)
		map_move("]C", "@class.outer", 2)
		map_move("]A", "@parameter.inner", 2)

		map_move("[f", "@function.outer", 3)
		map_move("[c", "@class.outer", 3)
		map_move("[a", "@parameter.inner", 3)

		map_move("[F", "@function.outer", 4)
		map_move("[C", "@class.outer", 4)
		map_move("[A", "@parameter.inner", 4)
	end
}
