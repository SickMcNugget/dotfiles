return {
	"alker0/chezmoi.vim",
	lazy = true,
    ft = "tmpl",
	init = function()
		vim.g["chezmoi#use_tmp_buffer"] = true
	end,
}
