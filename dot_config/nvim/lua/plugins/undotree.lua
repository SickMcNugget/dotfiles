return {
	"mbbill/undotree",
    -- event = { "BufReadPost", "BufNewFile" },
    keys = {
        { "<leader>u", "<cmd>UndotreeToggle<cr>", desc="UndoTree Toggle" },
    },
	config = function()
		vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
	end,
}
