return {
	"folke/lazydev.nvim",
	ft = "lua",
	opts = {
		library = {
			-- conditional luv types
			{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			-- Dap ui type checking
			"nvim-dap-ui",
		},

		-- Only enable when there's no .luarc.json in project root
		enabled = function(root_dir)
			return not vim.loop.fs_stat(root_dir .. "/.luarc.json")
		end,
	},
}
