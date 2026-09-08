local netrw_ft_fix = vim.api.nvim_create_augroup("NetrwFileTypeFix", { clear = true })

vim.api.nvim_create_autocmd({ "BufWinEnter", "BufEnter" }, {
	group = netrw_ft_fix,
	pattern = "*",
	callback = function(args)
		local ft = vim.bo[args.buf].filetype

		if (ft == "" or ft == "netrw") and vim.bo[args.buf].buftype == "" then
			local name = vim.api.nvim_buf_get_name(args.buf)
			if name ~= "" then
				local detected = vim.filetype.match({ filename = name })
				if detected then
					vim.bo[args.buf].filetype = detected
				end
			end
		end
	end

})
