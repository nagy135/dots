vim.keymap.set('n', '<leader>]r', function() require('rest-nvim').run() end, { desc = 'Rest Nvim (run)' })
vim.keymap.set('n', '<leader>]]', function() require('rest-nvim').last() end, { desc = 'Rest Nvim (repeat last)' })
