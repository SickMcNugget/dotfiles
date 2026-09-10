local function find_pyproject()
	return vim.fs.find("pyproject.toml", {
		upward = true,
		path = vim.api.nvim_buf_get_name(0),
	})[1]
end

local function pyproject_uses_hatchling(path)
	if not path then
		return false
	end

	for line in io.lines(path) do
		if line:match('requires%s*=%s*%["hatchling"%]') then
			return true
		end
	end
	return false
end

local function select_compiler()
	if vim.bo.filetype ~= "python" then
		return
	end

	local pyproject = find_pyproject()

	if pyproject_uses_hatchling(pyproject) then
		vim.cmd.compiler("hatch")
	end
end

vim.api.nvim_create_autocmd("BufEnter", {
	callback = select_compiler,
})
