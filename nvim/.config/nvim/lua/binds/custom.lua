require('scripts')

vim.keymap.set('n', ';c', function() signature() end, { desc = 'Function signature' })
vim.keymap.set('n', ';l', function() debug_log() end, { desc = 'Debug log' })
vim.keymap.set('n', ';L', function() debug_log(true) end, { desc = 'Debug log (UP)' })
