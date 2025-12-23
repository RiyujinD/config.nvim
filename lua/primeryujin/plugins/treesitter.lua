return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "master",
		build = ":TSUpdate",
		lazy = false,
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		opts = {
			ensure_installed = {
				"c",
				"cpp",
				"lua",
				"vim",
				"html",
				"vimdoc",
				"query",
				"python",
				"go",
				"rust",
				"javascript",
				"typescript",
				"tsx",
				"css",
				"bash",
				"json",
				"yaml",
				"markdown",
				"markdown_inline",
			},
			auto_install = true,
			indent = {
				enable = true,
			},
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = true,
				-- Disable for performance large file (+100KB)
				disable = function(lang, buf)
					if not buf or buf == 0 then
						return false
					end

					local name = vim.api.nvim_buf_get_name(buf)
					if name == "" then
						return false
					end

					local ok, stats = pcall(vim.loop.fs_stat, name)
					if ok and stats and stats.size > 100 * 1024 then
						vim.notify(
							"File larger than 100KB treesitter disabled for performance",
							vim.log.levels.WARN,
							{ title = "Treesitter" }
						)
						return true
					end

					return false
				end,
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					-- Start a selection at the current cursor node (e.g., a variable, expression, or function).
					init_selection = "<C-space>",
					-- Expand the selection to the parent node
					node_incremental = "<C-space>",
					-- Expand selection to scope
					scope_incremental = "<leader><C-space>",
					-- Shrink selection back down the tree
					node_decremental = "<bs>",
				},
			},
			textobjects = {
				move = {
					enable = true,
					goto_next_start = {
						["]f"] = "@function.outer",
						["]c"] = "@class.outer",
						["]a"] = "@parameter.inner",
					},
					goto_previous_start = {
						["[f"] = "@function.outer",
						["[c"] = "@class.outer",
						["[a"] = "@parameter.inner",
					},
				},
			},
		},
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
		end,
	},
	{
		"Glench/Vim-Jinja2-Syntax",
		ft = { "htmldjango", "jinja", "jinja.html", "html" },
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
		opts = {
			enable = true,
			multiwindow = false, -- Only show context in the current window
			max_lines = 0, -- No limit to context lines
			min_window_height = 0, -- Always show context regardless of window height
			line_numbers = true,
			multiline_threshold = 20,
			trim_scope = "outer",
			mode = "cursor",
			separator = nil,
			zindex = 20,
			on_attach = nil,
		},
		config = function(_, opts)
			require("treesitter-context").setup(opts)

			vim.cmd("highlight! link TreesitterContext ColorColumn")
			vim.cmd("highlight! link TreesitterContextLineNumber ColorColumn")

			vim.keymap.set("n", "<leader>tc", function()
				require("treesitter-context").toggle()
			end, { desc = "Toggle Treesitter Context" })
		end,
	},
	{
		"windwp/nvim-ts-autotag",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		event = "BufReadPost",
		opts = {},
	},
}
