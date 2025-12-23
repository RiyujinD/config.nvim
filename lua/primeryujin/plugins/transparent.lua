return {
	"tribela/transparent.nvim",
	lazy = false,
	priority = 10000,
	event = "VimEnter",
	config = true,
	opts = {
		auto = true,
		excludes = {
			"LineNr", -- Line numbers
			"CursorLineNr", -- Current line number
			"SignColumn", -- Column for signs (diagnostics, etc.)
			"FoldColumn", -- Folding column
			"StatusLine", -- Status line
			"VertSplit", -- Vertical split borders
			"PmenuSel", -- Selected item in popup menu
			"FloatBorder", -- Borders of floating windows
			"WinSeparator", -- Window separator lines
		},
	},
}
