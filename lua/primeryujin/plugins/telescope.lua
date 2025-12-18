return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim", -- required core library
		"nvim-telescope/telescope-fzf-native.nvim", -- optional C sorter for speed
	},
	build = "make", -- compiles the native C extension
	config = function()
		-- Load FZF extension if installed
		local telescope = require("telescope")
		pcall(telescope.load_extension, "fzf")
	end,
}
