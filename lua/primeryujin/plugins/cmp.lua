return {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
		"github/copilot.vim",
	},
	opts = function()
		local cmp = require("cmp")
		local luasnip = require("luasnip")
		local cmp_select = { behavior = cmp.SelectBehavior.Select }

		cmp.setup({
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
				["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
				["<CR>"] = cmp.mapping.confirm({ select = true }),
				["<C-Space>"] = cmp.mapping.complete(),
				["<Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					elseif luasnip.expand_or_jumpable() then
						luasnip.expand_or_jump()
					else
						fallback()
					end
				end, { "i", "s" }),
				["<S-Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					elseif luasnip.jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				end, { "i", "s" }),
			}),
            sources = cmp.config.sources({
                { name = "copilot" },
                { name = 'nvim_lsp' },
                { name = 'luasnip' },
            }, {
                { name = 'buffer' },
            })
        })

		local function setup_cmdline(modes, opts)
			for _, mode in ipairs(modes) do
				cmp.setup.cmdline(mode, opts)
			end
		end

		setup_cmdline(
			{ ":" },
			{ mapping = cmp.mapping.preset.cmdline(), sources = { { name = "path" }, { name = "cmdline" } } }
		)
		setup_cmdline({ "/", "?" }, { mapping = cmp.mapping.preset.cmdline(), sources = { { name = "buffer" } } })

		-- Keymaps to trigger completion manually
		vim.keymap.set("n", "<leader><Space>", function()
			cmp.complete({})
		end, { desc = "Trigger CMP completion in normal mode" })

		vim.keymap.set("x", "<C-Space>", function()
			cmp.complete({})
		end, { desc = "Trigger CMP completion in visual mode" })
	end,
}
