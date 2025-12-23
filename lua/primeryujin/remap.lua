vim.g.mapleader = " "

-- Back to Explorer tree
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Moved selected text up and down with correct relative indentation
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- auto center cursor to windows during 'scrolling'
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Mark the cursor place to keep it the same when using 'J' to join lines
vim.keymap.set("n", "J", "mzJ`z")

-- Keep seach term in center of window
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Paste without remplacing the registery
vim.keymap.set("x", "<leader>p", [["_dP]])
-- Delete to void registery
vim.keymap.set({ "n", "v" }, "<leader>d", '"_d')

-- Yank to the clipboard registery
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])
vim.keymap.set("i", "<C-c>", "<Esc>")

-- Navigation centering
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- Fzf directories and look and start new tmux session
vim.keymap.set("n", "<C-f>", "<cmd>!tmux neww tmux-sessionizer<CR>")
-- Alt is the modifier.
-- Still need make a cmd for -s 0 i.e:flask run and start session in correct dir
vim.keymap.set("n", "<M-h>", "<cmd>silent !tmux neww tmux-sessionizer -s 0<CR>")
vim.keymap.set("n", "<M-t>", "<cmd>silent !tmux neww tmux-sessionizer -s 1<CR>")
vim.keymap.set("n", "<M-n>", "<cmd>silent !tmux neww tmux-sessionizer -s 2<CR>")
vim.keymap.set("n", "<M-s>", "<cmd>silent !tmux neww tmux-sessionizer -s 3<CR>")

-- Subtitute word
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Make exe of the file
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- Reindent paragraphe keeping cursor in same place
vim.keymap.set("n", "=ap", "ma=ap'a")

-- Vertical split
vim.keymap.set("n", "<leader>v", vim.cmd.vsplit)

-- Horizontal split
vim.keymap.set("n", "<leader>h", vim.cmd.split)

-- Resizing split width
vim.keymap.set("n", "<leader>=", ":vertical resize +5<CR>")
vim.keymap.set("n", "<leader>-", ":vertical resize -5<CR>")

-- Resizing split height
vim.keymap.set("n", "<leader><Up>", ":resize +3<CR>")
vim.keymap.set("n", "<leader><Down>", ":resize -3<CR>")
