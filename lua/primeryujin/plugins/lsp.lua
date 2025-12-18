-- LSP Servers and opts
local SERVERS = {
	pyright = { filetypes = { "python" } },
	clangd = { filetypes = { "c", "cpp", "objc", "objcpp" } },
	sqls = { filetypes = { "sql" } },
	html = { filetypes = { "html", "htmldjango" } },
	cssls = { filetypes = { "css", "scss" } },
	jsonls = { filetypes = { "json", "jsonc" } },
	yamlls = { filetypes = { "yaml" } },
	marksman = { filetypes = { "markdown" } },
	rust_analyzer = { filetypes = { "rust" } },
	tailwindcss = { filetypes = { "html", "css", "javascript", "typescript", "svelte" } },
	lua_ls = {
		filetypes = { "lua", "luau", "rockspec", "xmake" },
		settings = {
			Lua = {
				runtime = {
					-- Tell the language server which Lua version (LuaJIT for Neovim)
					version = "LuaJIT",
					-- Use package.path so require() resolution works
					path = vim.split(package.path, ";"),
				},
				diagnostics = {
					-- Recognize the `vim` global
					globals = { "vim" },
				},
				workspace = {
					-- Add common runtime folders to the workspace library so the LS knows about builtin types
					library = {
						[vim.fn.expand("$VIMRUNTIME/lua")] = true,
						[vim.fn.expand("$HOME/.config/nvim/lua")] = true,
						[vim.fn.stdpath("config") .. "/lua"] = true,
					},
					checkThirdParty = false, -- avoid prompts
				},
				telemetry = { enable = false }, -- opt out
			},
		},
	},
}

return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
        "stevearc/conform.nvim",
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/nvim-cmp",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
		"j-hui/fidget.nvim",
		"folke/lazydev.nvim",
	},

	config = function()


        require("fidget").setup()

		-- Diagnostics UI
        vim.diagnostic.config({
            -- update_in_insert = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })

        local capabilities = require("cmp_nvim_lsp").default_capabilities()

		-- on_attach callback (runs when LSP attaches to a buffer)
		local on_attach = function(client, bufnr)
			-- disable formatting (using conform.nvim instead)
			client.server_capabilities.documentFormattingProvider = false
			client.server_capabilities.documentRangeFormattingProvider = false

			local function bufmap(mode, lhs, rhs, desc)
				vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
			end

			bufmap("n", "gd", vim.lsp.buf.definition, "Go to definition")
			bufmap("n", "gr", vim.lsp.buf.references, "Go to references")
			bufmap("n", "K", vim.lsp.buf.hover, "Hover docs")
			bufmap("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
			bufmap("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
			bufmap("n", "<leader>e", vim.diagnostic.open_float, "Line diagnostics")
			bufmap("n", "<leader>q", vim.diagnostic.setloclist, "Diagnostics list")

			if client.server_capabilities.signatureHelpProvider then
				bufmap("i", "<C-s>", vim.lsp.buf.signature_help, "Signature help")
			end

			bufmap("n", "<leader>lsr", ":LspRestart<CR>", "Restart LSP")
		end

		-- Register each server with defaults + overrides on_attach
		for name, opts in pairs(SERVERS) do
			opts = vim.tbl_deep_extend("force", {
				on_attach = on_attach,
				capabilities = capabilities,
			}, opts or {})
			vim.lsp.config[name] = opts
		end
	end,
}
