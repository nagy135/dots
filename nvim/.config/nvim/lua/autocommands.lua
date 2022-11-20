vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
  pattern = {"dockerfile.*", "Dockerfile.*"},
  callback = function() vim.cmd [[set ft=dockerfile]] end,
})
