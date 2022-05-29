require('scripts')

vim.keymap.set('n', '<leader>;',
    function() require 'key-menu'.open_window('<leader>;') end,
    { desc = 'Custom scripts' })

vim.keymap.set('n', '<leader>;c', function() signature() end, { desc = 'Function signature' })
vim.keymap.set('n', '<leader>;l', function() debug_log() end, { desc = 'Debug log' })
vim.keymap.set('n', '<leader>;L', function() debug_log(true) end, { desc = 'Debug log (UP)' })
