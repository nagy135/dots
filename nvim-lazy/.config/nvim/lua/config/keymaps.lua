-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set('n', 'c-k', '<CMD>cp<CR>', { desc = "Quickfix previous" })
vim.keymap.set('n', 'c-j', '<CMD>cn<CR>', { desc = "Quickfix next" })
vim.keymap.set('n', 'c-c', '<CMD>cc<CR>', { desc = "Quickfix close" })
vim.keymap.set('n', ',j', '<CMD>move .+1<CR>==', { desc = "Move line down" })
vim.keymap.set('n', ',k', '<CMD>move .-2<CR>==', { desc = "Move line up" })

local wk = require("which-key")
wk.register({
  -- arbitrary pickers (mostly telescope)
  ["<leader>p"] = { name = "+pick" },
})
