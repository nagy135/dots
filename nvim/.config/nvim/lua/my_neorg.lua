local bindBase = '<leader>gt'

vim.keymap.set('n', bindBase,
    function() require 'key-menu'.open_window(bindBase) end,
    { desc = 'Neorg tasks' })

require('neorg').setup {
    load = {
        ["core.defaults"] = {},
        ["core.keybinds"] = {
            config = {
                default_keybinds = false,
                hook = function()
                    vim.keymap.set('n', bindBase .. 'd',
                        ':Neorg keybind norg core.norg.qol.todo_items.todo.task_done<CR>', { desc = 'Done' })
                    vim.keymap.set('n', bindBase .. 'h',
                        ':Neorg keybind norg core.norg.qol.todo_items.todo.task_on_hold<CR>', { desc = 'On Hold' })
                    vim.keymap.set('n', bindBase .. 'c',
                        ':Neorg keybind norg core.norg.qol.todo_items.todo.task_cancelled<CR>', { desc = 'Cancelled' })
                    vim.keymap.set('n', bindBase .. 'r',
                        ':Neorg keybind norg core.norg.qol.todo_items.todo.task_recurring<CR>', { desc = 'Recurring' })
                    vim.keymap.set('n', bindBase .. 'i',
                        ':Neorg keybind norg core.norg.qol.todo_items.todo.task_important<CR>', { desc = 'Important' })
                    vim.keymap.set('n', bindBase .. 'u',
                        ':Neorg keybind norg core.norg.qol.todo_items.todo.task_undone<CR>', { desc = 'Undone' })
                    vim.keymap.set('n', bindBase .. 'p',
                        ':Neorg keybind norg core.norg.qol.todo_items.todo.task_pending<CR>', { desc = 'Pending' })
                end,
            }
        }
    }
}
