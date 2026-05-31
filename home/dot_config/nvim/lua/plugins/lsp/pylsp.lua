return {
	settings = {
		pylsp = {
			plugins = {
				pycodestyle = {
					maxLineLength = 90,
					ignore = { "E402", "W503", "E203", "E704" },
				},
			},
		},
	},
}
