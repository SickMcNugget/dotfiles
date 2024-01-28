return {
	-- NOTE: Yes, you can install new plugins here!
	"mfussenegger/nvim-dap",
	-- event = { "BufReadPost", "BufNewFile" },
	keys = {
		-- 	Add arguments later by following this link: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/dap/core.lua
		{ "<F5>", function() require("dap").continue() end, desc="Debug: Start/Continue" },
		{ "<F1>", function() require("dap").step_into() end, desc="Debug: Step Into" },
		{ "<F2>", function() require("dap").step_over() end, desc="Debug: Step Over" },
		{ "<F3>", function() require("dap").step_out() end, desc="Debug: Step Out" },
		{ "<leader>b", function() require("dap").continue() end, desc="Debug: Toggle Breakpoint" },
		{ "<leader>B", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc="Debug: Set Breakpoint" },
	},
	-- NOTE: And you can specify dependencies as well
	dependencies = {
		-- Creates a beautiful debugger U
		{
			"rcarriga/nvim-dap-ui",
			keys = {
				{ "<F7>", function() require("dapui").toggle({}) end, desc = "Debug: Toggle UI" },
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
		},

		-- Installs the debug adapters for you
		{
			"jay-babu/mason-nvim-dap.nvim",
			dependencies = "williamboman/mason.nvim",
			cmd = { "DapInstall", "DapUninstall" },
			opts = {
				ensure_installed = {
					"python@1.6.7",
				},
				automatic_installation = true,
				handlers = {
				function(config)
						require("mason-nvim-dap").default_setup(config)
					end
				},
			},
		},
	},
}
