-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.foldmethod = "marker"

vim.cmd([[ cnoreabbrev W w ]])
vim.cmd([[ cnoreabbrev Q q ]])

vim.cmd([[ cnoreabbrev Wq wq ]])
vim.cmd([[ cnoreabbrev wQ wq ]])

vim.cmd([[ cnoreabbrev wQa wqa ]])
vim.cmd([[ cnoreabbrev Wqa wqa ]])
vim.cmd([[ cnoreabbrev wqA wqa ]])
vim.cmd([[ cnoreabbrev WQa wqa ]])
vim.cmd([[ cnoreabbrev wQA wqa ]])
vim.cmd([[ cnoreabbrev WQA wqa ]])
