require("primeryujin")

-- Path for the venv of the python provider pynvim
vim.g.python3_host_prog = vim.fn.expand("~/.config/nvim/venv/bin/python")

vim.filetype.add({
	extension = {
		jinja = "html",
		jinja2 = "html",
	},
})

vim.cmd([[hi Normal guibg=NONE ctermbg=NONE]])
vim.cmd([[hi NormalFloat guibg=NONE ctermbg=NONE]])

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- local function set_telescope_transparency()
-- 	-- make Telescope windows transparent so terminal bg shows through
-- 	vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "none" })
-- 	vim.api.nvim_set_hl(0, "TelescopePromptNormal", { bg = "none" })
-- 	vim.api.nvim_set_hl(0, "TelescopeResultsNormal", { bg = "none" })
-- 	vim.api.nvim_set_hl(0, "TelescopePreviewNormal", { bg = "none" })
-- 	-- use a hex color or a theme group name. Example hex:
-- 	vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = "#7aa2f7", bg = "none" })
-- 	vim.api.nvim_set_hl(0, "TelescopePromptBorder", { fg = "#7aa2f7", bg = "none" })
-- 	vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { fg = "#7aa2f7", bg = "none" })
-- end

-- set_telescope_transparency()
--
-- -- reapply when colorscheme changes (so colorscheme won't overwrite it)
-- vim.api.nvim_create_autocmd("ColorScheme", {
-- 	pattern = "*",
-- 	callback = set_telescope_transparency,
-- })

-- -- also reapply when Telescope buffer opens (ensures highlight after plugin setup)
-- vim.api.nvim_create_autocmd("FileType", {
-- 	pattern = "TelescopePrompt",
-- 	callback = set_telescope_transparency,
-- })
