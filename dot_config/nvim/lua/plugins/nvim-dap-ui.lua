return {
	"rcarriga/nvim-dap-ui",
	dependencies = {
		"nvim-neotest/nvim-nio"
	},
	keys = {
		{ "<leader>du", function() require("dapui").toggle({}) end, desc = "Debug: Toggle UI" },
	},
	-- Dap UI setup
	-- For more information, see |:help nvim-dap-ui|
	opts = {
		icons = {
			collapsed = "",
			current_frame = "",
			expanded = ""
		},
		controls = {
			icons = {
				disconnect = "",
				pause = "",
				play = "",
				run_last = "",
				step_back = "",
				step_into = "",
				step_out = "",
				step_over = "",
				terminate = ""
			},
		},
	},
	config = function(_, opts)
		local dap = require("dap")
		local dapui = require("dapui")
		dapui.setup(opts)

		dap.listeners.after.event_initialized["dapui_config"] = dapui.open
		dap.listeners.before.event_terminated["dapui_config"] = dapui.close
		dap.listeners.before.event_exited["dapui_config"] = dapui.close
	end
}
