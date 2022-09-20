vim.keymap.set('n', '<leader>c',
  function() require 'key-menu'.open_window('<leader>c') end,
  {desc='Color highlight'})

vim.keymap.set('n', '<leader>ct', '<cmd>ColorizerToggle<CR>', { desc = 'Colorizer toggle' })
