-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	dependencies = {
		"nvim-treesitter/nvim-treesitter-textobjects",
	},
	tag = "v0.10.0",
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter.configs").setup({
			-- Add languages to be installed here that you want installed for treesitter
			ensure_installed = { "bash", "c", "cpp", "lua", "python", "vimdoc", "vim" },

			-- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
			auto_install = false,

			highlight = { enable = true, additional_vim_regex_highlighting = false },
			indent = { enable = true },
			incremental_selection = { enable = false },
			textobjects = {
				select = {
					enable = true,
					lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
					keymaps = {
						-- You can use the capture groups defined in textobjects.scm
						["aa"] = "@parameter.outer",
						["ia"] = "@parameter.inner",
						["af"] = "@function.outer",
						["if"] = "@function.inner",
						["ac"] = "@class.outer",
						["ic"] = "@class.inner",
					},
				},
				move = {
					enable = true,
					set_jumps = true, -- whether to set jumps in the jumplist
					goto_next_start = {
						[";f"] = "@function.outer",
						[";c"] = "@class.outer",
						[";a"] = "@parameter.outer",
					},
					goto_previous_start = {
						[";F"] = "@function.outer",
						[";C"] = "@class.outer",
						[";A"] = "@parameter.outer",
					},
				},
				swap = {
					enable = true,
					swap_next = {
						["<leader>a"] = "@parameter.inner",
					},
					swap_previous = {
						["<leader>A"] = "@parameter.inner",
					},
				},
			},
		})
	end,
}
