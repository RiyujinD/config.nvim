return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim", -- required core library
		"nvim-telescope/telescope-fzf-native.nvim", -- optional C sorter for speed
	},
	build = "make", -- compiles the native C extension
	config = function(_, opts)
		-- Load FZF extension if installed

		opts.defaults = opts.defaults or {}
		opts.defaults.file_ignore_patterns = opts.defaults.file_ignore_patterns or {}
		opts.defaults.winblend = 15

		local telescope = require("telescope")
		pcall(telescope.load_extension, "fzf")
	end,
}
