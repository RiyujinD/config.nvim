PY_MARKERS = {
	"requirements.txt",
	"pyproject.toml",
	"Pipfile",
	"setup.py",
	".git",
	"main.py",
	"app.py",
}

local function find_root_path()
	local path = vim.fn.expand("%:p:h")
	if path == "" then
		path = vim.fn.getcwd()
	end

	-- Looking for the markers in folder and parents folders
	local root_found = vim.fs.find(PY_MARKERS, { upward = true, path = path })[1]
	if not root_found then
		return nil
	end
	return vim.fs.dirname(root_found)
end

local function find_venv(root)
	local env = vim.env.VIRTUAL_ENV or ""
	if env ~= "" and vim.fn.executable(env .. "/bin/python") == 1 then
		return env .. "/bin/python"
	end
	if root and vim.fn.executable(root .. "/venv/bin/python") == 1 then
		return root .. "/venv/bin/python"
	end
	if root and vim.fn.executable(root .. "/.venv/bin/python") == 1 then
		return root .. "/.venv/bin/python"
	end
	return nil
end

vim.api.nvim_create_augroup("DapGroup", { clear = true })

local function navigate(args)
	local buffer = args.buf

	local wid = nil
	local win_ids = vim.api.nvim_list_wins() -- Get all window IDs
	for _, win_id in ipairs(win_ids) do
		local win_bufnr = vim.api.nvim_win_get_buf(win_id)
		if win_bufnr == buffer then
			wid = win_id
		end
	end

	if wid == nil then
		return
	end

	vim.schedule(function()
		if vim.api.nvim_win_is_valid(wid) then
			vim.api.nvim_set_current_win(wid)
		end
	end)
end

local function create_nav_options(name)
	return {
		group = "DapGroup",
		pattern = string.format("*%s*", name),
		callback = navigate,
	}
end

local dap_venv_warned_roots = {}

return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"nvim-telescope/telescope-fzf-native.nvim",
			"theHamsta/nvim-dap-virtual-text",
			"mfussenegger/nvim-dap-python",
			"mason-org/mason.nvim",
			"nvim-neotest/nvim-nio",
			"rcarriga/nvim-dap-ui",
		},
		lazy = false,
		config = function()
			local dap = require("dap")
			local dap_python = require("dap-python")

			dap.set_log_level("DEBUG")

			vim.keymap.set("n", "<F1>", dap.continue)
			vim.keymap.set("n", "<F2>", dap.step_into)
			vim.keymap.set("n", "<F3>", dap.step_over)
			vim.keymap.set("n", "<F4>", dap.step_out)
			vim.keymap.set("n", "<F8>", dap.restart)
			vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint)
			vim.keymap.set("n", "<leader>B", function()
				dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end)
			vim.keymap.set("n", "<leader>dg", dap.run_to_cursor)

			-- Python
			local mason_debugpy = vim.fn.expand("~/.local/share/nvim/mason/packages/debugpy/venv/bin/python")
			if vim.fn.executable(mason_debugpy) ~= 1 then
				vim.notify(
					"Mason debugpy not found at: " .. mason_debugpy .. "\nAdapter will try system python.",
					vim.log.levels.WARN
				)
			end
			local adapter_cmd = (vim.fn.executable(mason_debugpy) == 1) and mason_debugpy
				or (vim.fn.exepath("python3") ~= "" and vim.fn.exepath("python3") or vim.fn.exepath("python"))

			dap_python.setup(adapter_cmd)

			dap.adapters.python = {
				type = "executable",
				command = adapter_cmd,
				args = { "-Xfrozen_modules=off", "-m", "debugpy.adapter" },
			}

			local root_path = find_root_path() or vim.fn.expand("%:p:h")

			-- Flask app
			table.insert(dap.configurations.python, 1, {
				type = "python",
				request = "launch",
				name = "Launch Debugger on python FLask file",
				module = "flask",
				args = { "run", "--host", "127.0.0.1", "--port", "5000", "--no-debugger", "--no-reload" },
				cwd = root_path,
				pythonPath = function()
					local root = find_root_path() or vim.fn.getcwd()
					local venv = find_venv(root)
					if venv and venv ~= "" then
						return venv
					end

					if root and not dap_venv_warned_roots[root] then
						vim.notify(
							"No project venv found for "
								.. root
								.. ". Falling back to system python. "
								.. "Create a venv or set VIRTUAL_ENV for correct dependencies.",
							vim.log.levels.WARN,
							{ title = "DAP" }
						)
						dap_venv_warned_roots[root] = true
					end

					local sys = vim.fn.exepath("python3")
					if sys and sys ~= "" then
						return sys
					end
					return vim.fn.exepath("python") or "python"
				end,
				env = { FLASK_ENV = "development", FLASK_APP = "app.py", PYDEVD_DISABLE_FILE_VALIDATION = "1" },
				jinja = true,
				stopOnEntry = false,
				subProcess = false,
			})

			dap.configurations.c = dap.configurations.c or {}
			dap.configurations.cpp = dap.configurations.cpp or dap.configurations.c

			dap.adapters.codelldb = {
				type = "executable",
				command = "codelldb",
				name = "lldb",
				-- detached = false, -- uncomment on Windows if required
			}

			dap.adapters["local-lua"] = {
				type = "executable",
				command = "node",
				args = { vim.fn.stdpath("data") .. "/mason/share/local-lua-debugger-vscode/extension/debugAdapter.js" },
				enrich_config = function(config, on_config)
					if not config["extensionPath"] then
						local c = vim.deepcopy(config)
						c.extensionPath = vim.fn.stdpath("data") .. "/mason/share/local-lua-debugger-vscode/"
						on_config(c)
					else
						on_config(config)
					end
				end,
			}
			dap.configurations.lua = {
				{
					type = "local-lua",
					request = "launch",
					name = "Launch debug Lua file",
					program = {
						lua = "luajit",
						file = "${file}",
					},
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
				},
			}

			local js_debug_path = vim.fn.stdpath("data")
				.. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js"

			dap.configurations.javascript = dap.configurations.javascript or {}

			dap.adapters["pwa-node"] = {
				type = "server",
				host = "127.0.0.1",
				port = "${port}",
				executable = {
					command = "node",
					args = { js_debug_path, "${port}" },
				},
			}

			table.insert(dap.configurations.javascript, 1, {
				name = "Launch file (node)",
				type = "pwa-node",
				request = "launch",
				program = "${file}",
				cwd = vim.fn.getcwd(),
				runtimeExecutable = "node",
				console = "integratedTerminal",
				sourceMaps = true,
				internalConsoleOptions = "neverOpen",
			})

			-- JavaScript: attach to running Node on a port
			-- table.insert(dap.configurations.javascript, 1, {
			-- 	name = "Attach to process (localhost:9229)",
			-- 	type = "pwa-node",
			-- 	request = "attach",
			-- 	processId = require("dap.utils").pick_process,
			-- 	cwd = vim.fn.getcwd(),
			-- })
			--
			-- TypeScript: launch using ts-node

			dap.configurations.typescript = dap.configurations.typescript or {}

			table.insert(dap.configurations.typescript, 1, {
				name = "Launch TS (ts-node)",
				type = "pwa-node",
				request = "launch",
				runtimeExecutable = "node",
				runtimeArgs = { "-r", "ts-node/register", "-r", "source-map-support/register" },
				args = { "${file}" },
				cwd = vim.fn.getcwd(),
				sourceMaps = true,
				console = "integratedTerminal",
				internalConsoleOptions = "neverOpen",
			})

			-- TypeScript
			-- table.insert(dap.configurations.typescript, 1, {
			-- 	name = "Launch compiled (dist) JS",
			-- 	type = "pwa-node",
			-- 	request = "launch",
			-- 	program = "${workspaceFolder}/dist/index.js",
			-- 	cwd = vim.fn.getcwd(),
			-- 	sourceMaps = true,
			-- 	outFiles = { "${workspaceFolder}/dist/**/*.js" },
			-- 	console = "integratedTerminal",
			-- })
		end,
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "mfussenegger/nvim-dap" },
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")
			local function layout(name)
				return {
					elements = {
						{ id = name },
					},
					enter = true,
					size = 40,
					position = "right",
				}
			end
			local name_to_layout = {
				repl = { layout = layout("repl"), index = 0 },
				stacks = { layout = layout("stacks"), index = 0 },
				scopes = { layout = layout("scopes"), index = 0 },
				console = { layout = layout("console"), index = 0 },
				watches = { layout = layout("watches"), index = 0 },
				breakpoints = { layout = layout("breakpoints"), index = 0 },
			}
			local layouts = {}

			for name, config in pairs(name_to_layout) do
				table.insert(layouts, config.layout)
				name_to_layout[name].index = #layouts
			end

			local function toggle_debug_ui(name)
				dapui.close()
				local layout_config = name_to_layout[name]

				if layout_config == nil then
					error(string.format("bad name: %s", name))
				end

				local uis = vim.api.nvim_list_uis()[1]
				if uis ~= nil then
					layout_config.size = uis.width
				end

				pcall(dapui.toggle, layout_config.index)
			end

			vim.keymap.set("n", "<leader>de", function()
				dapui.eval(nil, { enter = true })
			end)
			vim.keymap.set("n", "<leader>dr", function()
				toggle_debug_ui("repl")
			end, { desc = "Debug: toggle repl ui" })
			vim.keymap.set("n", "<leader>ds", function()
				toggle_debug_ui("stacks")
			end, { desc = "Debug: toggle stacks ui" })
			vim.keymap.set("n", "<leader>dw", function()
				toggle_debug_ui("watches")
			end, { desc = "Debug: toggle watches ui" })
			vim.keymap.set("n", "<leader>db", function()
				toggle_debug_ui("breakpoints")
			end, { desc = "Debug: toggle breakpoints ui" })
			vim.keymap.set("n", "<leader>dS", function()
				toggle_debug_ui("scopes")
			end, { desc = "Debug: toggle scopes ui" })
			vim.keymap.set("n", "<leader>dc", function()
				toggle_debug_ui("console")
			end, { desc = "Debug: toggle console ui" })

			vim.keymap.set("n", "<leader>dt", function()
				dapui.toggle()
			end, { desc = "Toggle DAP UI" })

			vim.api.nvim_create_autocmd("BufEnter", {
				group = "DapGroup",
				pattern = "*dap-repl*",
				callback = function()
					vim.wo.wrap = true
				end,
			})

			vim.api.nvim_create_autocmd("BufWinEnter", create_nav_options("dap-repl"))
			vim.api.nvim_create_autocmd("BufWinEnter", create_nav_options("DAP Watches"))

			dapui.setup({
				layouts = layouts,
				enter = true,
			})

			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end

			dap.listeners.after.event_output.dapui_config = function(_, body)
				if body.category == "console" then
					dapui.eval(body.output) -- Sends stdout/stderr to Console
				end
			end
		end,
	},

	{
		"jay-babu/mason-nvim-dap.nvim",
		lazy = true,
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"mfussenegger/nvim-dap",
			"williamboman/mason.nvim",
		},
		opts = {
			ensure_installed = {
				"js-debug-adapter", -- JS/TS
				"debugpy", -- Python
				"codelldb", -- C / C++
				"local-lua-debugger-vscode", -- Lua
			},
			automatic_setup = false,
			handlers = {},
		},
		config = function(_, opts)
			require("mason").setup()
			require("mason-nvim-dap").setup(opts)
		end,
	},
}
