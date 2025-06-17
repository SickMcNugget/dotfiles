return {
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim", "redis", "ARGV" },
			},
			telemetry = { enable = false },
			workspace = { checkThirdParty = false },
		},
	},
}
