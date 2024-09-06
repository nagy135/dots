-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("n", "<leader>k", "<CMD>cp<CR>", { desc = "Quickfix previous" })
vim.keymap.set("n", "<leader>j", "<CMD>cn<CR>", { desc = "Quickfix next" })
vim.keymap.set("n", "<c-j>", "<c-w>j")
vim.keymap.set("n", "<c-k>", "<c-w>k")
vim.keymap.set("n", "<c-l>", "<c-w>l")
vim.keymap.set("n", "<c-h>", "<c-w>h")
vim.keymap.set("n", "<c-c>", "<CMD>cclose<CR>", { desc = "Quickfix close" })
vim.keymap.set("n", ",j", "<CMD>move .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("n", ",k", "<CMD>move .-2<CR>==", { desc = "Move line up" })
vim.keymap.set("n", "<leader><c-h>", "<CMD>nohl<CR>", { desc = "No highlight" })
vim.keymap.set("n", ";", ":")

local wk = require("which-key")
wk.register({
  -- arbitrary pickers (mostly telescope)
  ["<leader>p"] = { name = "+pick" },
})
