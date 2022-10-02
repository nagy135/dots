local prefix = '<leader><leader>s'

vim.keymap.set('n', prefix, require('symbols-outline').toggle_outline , { desc = 'Symbols outline (toggle)' })
