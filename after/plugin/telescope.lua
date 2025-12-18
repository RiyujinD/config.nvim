local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>lf", builtin.find_files, { desc = "Telescope: Find Files" })
vim.keymap.set("n", "<leader>lg", builtin.live_grep, { desc = "Telescope: Live Grep" })
vim.keymap.set("n", "<leader>lb", builtin.buffers, { desc = "Telescope: Buffers" })
vim.keymap.set("n", "<leader>lh", builtin.help_tags, { desc = "Telescope: Help Tags" })
vim.keymap.set("n", "<C-p>", builtin.git_files, {})

-- Prompted grep
vim.keymap.set("n", "<leader>fg", function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") })
end, {})
