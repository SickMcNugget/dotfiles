-- Command for highlighting trailing whitespace with bright red blocks
vim.api.nvim_set_hl(0, "TrailingWhitespace", { bg ="#FF0000", ctermbg="red" })

local enabled=false
vim.api.nvim_create_user_command("TrailingWhitespace", function()
	if not enabled then
		vim.fn.matchadd("TrailingWhitespace", [[\s\+$]])
		enabled=true
	else
		vim.fn.clearmatches()
		enabled=false
	end
end, {})
