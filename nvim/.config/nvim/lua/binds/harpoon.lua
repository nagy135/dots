vim.keymap.set('n', '<leader>m',
  function() require 'key-menu'.open_window('<leader>m') end,
  {desc='Harpoon'})
vim.keymap.set('n', '<leader>ma', function() require('harpoon.mark').add_file() end, { desc = 'Mark this file' })
vim.keymap.set('n', '<leader>mm', function() require('harpoon.ui').toggle_quick_menu() end, { desc = 'Mark menu' })
vim.keymap.set('n', '<leader>mi', function()
    local index = vim.fn.input("Harpoon: ")
    if index == nil or index == '' then
        return
    end
    require('harpoon.ui').nav_file(tonumber(index))
end, { desc = 'Jump to mark index' })
vim.keymap.set('n', '<A-1>', function() require('harpoon.ui').nav_file(1) end, { desc = 'Mark 1' })
vim.keymap.set('n', '<A-2>', function() require('harpoon.ui').nav_file(2) end, { desc = 'Mark 2' })
vim.keymap.set('n', '<A-3>', function() require('harpoon.ui').nav_file(3) end, { desc = 'Mark 3' })
vim.keymap.set('n', '<A-4>', function() require('harpoon.ui').nav_file(4) end, { desc = 'Mark 4' })
vim.keymap.set('n', '<A-5>', function() require('harpoon.ui').nav_file(5) end, { desc = 'Mark 5' })
vim.keymap.set('n', '<A-6>', function() require('harpoon.ui').nav_file(6) end, { desc = 'Mark 6' })
vim.keymap.set('n', '<A-7>', function() require('harpoon.ui').nav_file(7) end, { desc = 'Mark 7' })
vim.keymap.set('n', '<A-8>', function() require('harpoon.ui').nav_file(8) end, { desc = 'Mark 8' })
vim.keymap.set('n', '<A-9>', function() require('harpoon.ui').nav_file(9) end, { desc = 'Mark 9' })
vim.keymap.set('n', '<A-0>', function() require('harpoon.ui').nav_file(10) end, { desc = 'Mark 10' })
