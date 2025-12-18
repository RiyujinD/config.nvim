return {
	"mason-org/mason-lspconfig.nvim",
	lazy = false,
	dependencies = {
		{ "mason-org/mason.nvim" },
		{ "neovim/nvim-lspconfig" },
	},
	opts = {
		ensure_installed = {
			-- LSP servers
			"lua_ls",
			"ts_ls",
			"tailwindcss",
			"yamlls",
			"clangd",
			"pyright",
			"sqls",
			"html",
			"cssls",
			"jsonls",
			"rust_analyzer",
			"marksman",
		},
		automatic_installation = true,
	},
}
