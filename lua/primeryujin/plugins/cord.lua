return {
	"vyfor/cord.nvim",
	build = ":Cord update",
	lazy = false,
	priority = 900,
	opts = {
        display = {
            theme = "catppuccin",
            flavor = "dark",
            swap_icons = true,
        },
        variables = true,
        text = {
            default = "Using Neovim",
            workspace = "Primeryujin workspace",
            editing = "Editing ${filename}",
            file_browser = "Browsing files in ${tooltip}",
        },
		advanced = {
			discord = {
				pipe_paths = { "/tmp/discord-ipc-0" },
			},
		},
	},
}
