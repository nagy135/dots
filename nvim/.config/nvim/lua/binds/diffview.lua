vim.keymap.set('n', '<leader>dwo', function() vim.cmd [[:DiffviewOpen]] end, { desc = 'Diffview Open' })
vim.keymap.set('n', '<leader>dwc', function() vim.cmd [[:DiffviewClose]] end, { desc = 'Diffview Close' })
vim.keymap.set('n', '<leader>dh', function() vim.cmd [[:DiffviewFileHistory %]] end, { desc = 'Diffview file history current file' })
