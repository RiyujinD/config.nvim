return {
	"stevearc/conform.nvim",
	event = { "BufReadPost", "BufNewFile" },
	dependencies = {
		"mason-org/mason.nvim",
	},
	opts = function()
		return {
			formatters_by_ft = {
				c = { "clang-format" },
				cpp = { "clang-format" },
				lua = { "stylua" },
				python = { "black" },
				go = { "gofmt" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				html = { "prettier" },
				css = { "prettier" },
				json = { "prettier" },
				yaml = { "prettier" },
				markdown = { "prettier" },
				rust = { "rustfmt" },
				sql = { "sqlfluff" },
				htmldjango = { "djlint" },
				jinja = { "djlint" },
				sh = { "shfmt" },
			},

			formatters = {
				["clang-format"] = {
					prepend_args = {
						"-style=file",
						"-fallback-style={BasedOnStyle: LLVM, IndentWidth: 4}",
					},
				},
			},

			format_on_save = {
				timeout_ms = 500,
				lsp_format = "fallback",
			},
		}
	end,

	keys = {
		{
			"<leader>f",
			function()
				require("conform").format({ bufnr = 0 })
			end,
			desc = "Format current buffer",
		},
	},
}
