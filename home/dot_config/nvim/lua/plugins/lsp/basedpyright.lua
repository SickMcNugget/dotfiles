return {
	settings = {
		basedpyright = {
			analysis = {
				diagnosticSeverityOverrides = {
					reportUnannotatedClassAttribute = "none",
					reportPossiblyUnboundVariable = "warning",
					reportArgumentType = "none",
					reportExplicitAny = "none",
					reportPrivateUsage = "none",
					reportMissingTypeArgument = "none",
					reportUnknownParameterType = "none",
				}
			},
		},
	},
}
