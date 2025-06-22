return {
	"mfussenegger/nvim-dap",
	tag = "0.10.0",
	dependencies = {
		{
			"rcarriga/nvim-dap-ui",
			tag = "v4.0.0",
			dependencies = {
				"nvim-neotest/nvim-nio",
			},
			keys = {
				{
					"<leader>du",
					function()
						require("dapui").toggle({})
					end,
					desc = "Debug: Toggle UI",
				},
			},
			-- For more information, see |:help nvim-dap-ui|
			opts = {
				icons = {
					collapsed = "",
					current_frame = "",
					expanded = "",
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
						terminate = "",
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
			end,
		},
		{
			"jay-babu/mason-nvim-dap.nvim",
			version = "2.*",
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
					end,
				},
			},
		},
	},
	keys = {
		-- 	add arguments later by following this link: https://github.com/lazyvim/lazyvim/blob/main/lua/lazyvim/plugins/extras/dap/core.lua
		{
			"<leader>dc",
			function()
				require("dap").continue()
			end,
			desc = "Debug: Start/Continue",
		},
		{
			"<leader>dt",
			function()
				require("dap").terminate()
			end,
			desc = "Debug: Terminate",
		},
		{
			"<leader>dp",
			function()
				local dap = require("dap")
				dap.listeners.on_config["add_args"] = function(config)
					local copy = vim.deepcopy(config)
					local args = vim.fn.input("Args: ")
					if vim.fn.empty(args) == 1 then
						return config
					end

					copy.args = require("dap.utils").splitstr(args)
					return copy
				end
				dap.continue()
				dap.listeners.on_config["add_args"] = nil
			end,
			desc = "Debug: Start With Parameters",
		},
		{
			"<leader>di",
			function()
				require("dap").step_into()
			end,
			desc = "Debug: Step Into",
		},
		{
			"<leader>dn",
			function()
				require("dap").step_over()
			end,
			desc = "Debug: Step Over",
		},
		{
			"<leader>do",
			function()
				require("dap").step_out()
			end,
			desc = "Debug: Step Out",
		},
		{
			"<leader>b",
			function()
				require("dap").toggle_breakpoint()
			end,
			desc = "Debug: Toggle Breakpoint",
		},
		{
			"<leader>B",
			function()
				require("dap").set_breakpoint(vim.fn.input("BP condition: "))
			end,
			desc = "Debug: Set Breakpoint",
		},
	},
}
