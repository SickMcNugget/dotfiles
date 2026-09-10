if vim.b.current_compiler then
	return
end
vim.b.current_compiler = "hatch"

vim.opt_local.makeprg = "hatch"

-- Remember that rules are executed in-order!
-- Generally all this means is that the most specific rules should be placed
-- at the top of the list, and the catch-alls should be at the bottom.
vim.opt_local.errorformat = {
	-- Most important rule - error location
	"%C %#--> %f:%l:%c",
	-- Ignore code block lines
	"%C%.%#|%.%#",
	-- Empty line means end match
	"%Z",
	-- Capture help
	"%C%m",
	-- Least important rule - Start matching on any message.
	"%E%m"
}
