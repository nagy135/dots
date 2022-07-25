vim.keymap.set('n', '<leader>c',
  function() require 'key-menu'.open_window('<leader>c') end,
  {desc='Color highlight'})

vim.keymap.set('n', '<leader>ce', '<cmd>HighlightColorsOn<CR>', { desc = 'Color highlight ENABLE' })
vim.keymap.set('n', '<leader>cd', '<cmd>HighlightColorsOff<CR>', { desc = 'Color highlight DISABLE' })
