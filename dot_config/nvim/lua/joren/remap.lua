-- [[ Basic Keymaps ]]
-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "Enter netrw (file browser)" })
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set("n", "[d", function()
	vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Go to previous diagnostic message" })
vim.keymap.set("n", "]d", function()
	vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Go to next diagnostic message" })
-- vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
-- vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-- Kill command mode with fire
vim.keymap.set({ "n" }, "q:", "<Nop>")
vim.keymap.set({ "n" }, "q/", "<Nop>")
vim.keymap.set({ "n" }, "q?", "<Nop>")
vim.keymap.set({ "c" }, "<C-f>", "<Nop>")

-- Add semicolon at the end of line (visual and normal mode)
local semicolon_regex = "%s*;+%s*$"
vim.keymap.set("n", "<leader>;", function()
	local line = vim.api.nvim_get_current_line()
	if line:len() == 0 then
		return
	end

	if line:match(semicolon_regex) then
		local newline = line:gsub(semicolon_regex, "")
		vim.api.nvim_set_current_line(newline)
	else
		vim.api.nvim_set_current_line(line .. ";")
	end
end, { desc = "Toggle semicolon for line" })

vim.keymap.set("x", "<leader>;", function()
	local start_line = vim.fn.line("v")
	local end_line = vim.fn.line(".")
	if start_line > end_line then
		start_line, end_line = end_line, start_line
	end

	local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)

	local missing_semicolon = false
	for _, line in ipairs(lines) do
		if line:len() == 0 then
			goto continue
		end
		if not line:match(semicolon_regex) then
			missing_semicolon = true
			break
		end
		::continue::
	end

	for i, line in ipairs(lines) do
		if line:len() == 0 then
			goto continue
		end

		if missing_semicolon then
			if not line:match(semicolon_regex) then
				lines[i] = line .. ";"
			end
		else
			lines[i] = line:gsub(semicolon_regex, "")
		end
		::continue::
	end

	vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, lines)
end, { desc = "Uniformly toggle semicolons for selection lines" })
