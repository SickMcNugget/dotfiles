-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
return {
	"nvim-telescope/telescope.nvim",
	event = "VimEnter",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
			cond = function()
				return vim.fn.executable("make") == 1
			end,
		},
		{ "nvim-telescope/telescope-ui-select.nvim" },
	},
	config = function()
		local telescope = require("telescope")
		local themes = require("telescope.themes")
		local builtin = require("telescope.builtin")
		local utils = require("telescope.utils")
		telescope.setup({
			extensions = {
				["ui-select"] = {
					themes.get_dropdown(),
				},
			},
		})

		-- Enable telescope fzf native, if installed
		pcall(telescope.load_extension, "fzf")
		pcall(telescope.load_extension, "ui-select")

		vim.keymap.set("n", "<leader>/", function()
			builtin.current_buffer_fuzzy_find(themes.get_dropdown({
				winblend = 10,
				previewer = false,
			}))
		end, { desc = "[/] Fuzzily search in current buffer" })
		vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Search existing buffers" })
		vim.keymap.set("n", "<leader>sg", builtin.git_files, { desc = "[S]earch [G]it Files" })
		vim.keymap.set("n", "<leader>sf", function()
			builtin.find_files({ cwd = utils.buffer_dir(), hidden = true, no_ignore = true })
		end, { desc = "[S]earch [F]iles" })
		vim.keymap.set("n", "<leader>sn", function()
			builtin.find_files({ cwd = vim.fn.stdpath("config"), hidden = true, no_ignore = true })
		end, { desc = "[S]earch [N]eovim files" })
		if vim.fn.executable("chezmoi") == 1 then
			local ret = vim.system({ "chezmoi", "source-path" }, { text = true }):wait()
			local chezmoi_dir = string.gsub(ret.stdout, "\n", "")
			vim.keymap.set("n", "<leader>sc", function()
				builtin.find_files({ cwd = chezmoi_dir, hidden = true })
			end, { desc = "[S]earch [C]hezmoi files" })
		end
		vim.keymap.set("n", "<leader>sm", builtin.man_pages, { desc = "[S]earch [M]anpages" })
		vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
		vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
		vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
		vim.keymap.set("n", "<leader>s/", function()
			builtin.live_grep({ cwd = utils.buffer_dir() })
		end, { desc = "[s/] Search with grep " })
		vim.keymap.set("n", "<leader>.", builtin.oldfiles, { desc = "[.] Search recent files" })
	end,
}
