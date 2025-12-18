return {
	"tpope/vim-fugitive",
	keys = {
		{ "<leader>gs", "<cmd>Git<CR>", desc = "Fugitive: status" },
		{ "gu", "<cmd>diffget //2<CR>", desc = "Diffget left" },
		{ "gh", "<cmd>diffget //3<CR>", desc = "Diffget right" },
	},
}
