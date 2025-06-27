local map = vim.keymap.set -- set alias 'map' instead of verbose vim.keymap.set

map("n", "<Space>", "<Nop>", { silent = true }) -- Unmaps the spacebar leader in normal mode
vim.g.mapleader = " " -- set <leader> to <Space>

map("n", "<leader>pv", vim.cmd.Ex)  -- open netrw

map("n", "<leader>t", "<cmd>ToggleTerm<CR>", { desc = "Toggle terminal" }) -- Space + t maps to ToggleTerminal


map("i", "jk", "<Esc>", { noremap = true })
vim.o.timeoutlen = 300  -- or 200 ms

-- Faster entry into window mode
map("n", "<leader>w", "<C-w>", { noremap = true })


