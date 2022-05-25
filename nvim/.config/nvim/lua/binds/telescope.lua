vim.keymap.set('n', '<leader>f',
  function() require 'key-menu'.open_window('<leader>f') end,
  {desc='Find X'})

vim.keymap.set('n', '<leader>ff', function() require('telescope.builtin').find_files() end, { desc = 'Find Files' })
vim.keymap.set('n', '<c-f>', function() require('telescope.builtin').find_files() end, { desc = 'Find Files' })

vim.keymap.set('n', '<leader>fn', function() require("telescope.builtin").find_files({ cwd = "%:h" }) end, { desc = 'Find Neightbors' })
vim.keymap.set('n', '<leader>fd', function() require("telescope.builtin").find_files { cwd = "~/.config", follow = true, hidden = true } end, { desc = 'Find Config' })

vim.keymap.set('n', '<leader>fg', function() require('telescope.builtin').live_grep() end, { desc = 'Live Grep' })
vim.keymap.set('n', '<c-g>', function() require('telescope.builtin').live_grep() end, { desc = 'Live Grep' })

vim.keymap.set('n', '<leader>fb', function() require('telescope.builtin').buffers(require('telescope.themes').get_ivy({})) end, { desc = 'Find Buffers' })
vim.keymap.set('n', '<c-e>', function() require('telescope.builtin').buffers(require('telescope.themes').get_ivy({})) end, { desc = 'Find Buffers' })

vim.keymap.set('n', '<leader>fs', function() require('telescope.builtin').grep_string() end, { desc = 'Grep String under cursor' })

vim.keymap.set('n', '<leader>fc', function() require('telescope.builtin').command_history() end, { desc = 'Find Command' })

vim.keymap.set('n', '<leader>fo', function() require('telescope.builtin').oldfiles() end, { desc = 'Find Old Files' })

vim.keymap.set('n', '<leader>fl', function() require('telescope.builtin').git_status() end, { desc = 'Find Git changes' })
vim.keymap.set('n', '<leader>fL', function() require('telescope.builtin').git_bcommits() end, { desc = 'Find Buffer Git changes' })

vim.keymap.set('n', '<leader>gd', function() require('telescope.builtin').lsp_definitions() end, { desc = 'Find LSP Definitions' })
vim.keymap.set('n', '<leader>gr', function() require('telescope.builtin').lsp_references() end, { desc = 'Find LSP References' })

vim.keymap.set('n', '<leader>gi', function() require('telescope.builtin').lsp_implementations() end, { desc = 'Find LSP implementations' })
vim.keymap.set('n', '<leader>gD', function() require('telescope.builtin').lsp_type_definitions() end, { desc = 'Find LSP Declarations (type definitions)' })

vim.keymap.set('n', '<leader>fe', function() require('telescope').extensions.file_browser.file_browser() end, { desc = 'File Browser' })

vim.keymap.set('n', '<leader>ld', function() require('telescope.builtin').diagnostics() end, { desc = 'Find Diagnostics' })
vim.keymap.set('n', '<leader>lD', function() require('telescope.builtin').diagnostics({ bufnr = 0 }) end, { desc = 'Find Buffer Diagnostics' })

vim.keymap.set('n', '<leader>fm', function() require('telescope.builtin').man_pages() end, { desc = 'Find Man Page' })

vim.keymap.set('n', '<leader>fz', function() require('telescope.builtin').spell_suggest() end, { desc = 'Spell Suggest' })

vim.keymap.set('n', '<leader>lj', function() require('telescope.builtin').lsp_document_symbols() end, { desc = 'Find Document Symbols' })

vim.keymap.set('n', '<leader>fp', function() require('my_telescope').project_find_file("~/Clones") end, { desc = 'Find project in ~/Clones' })
vim.keymap.set('n', '<leader>fa', function() require('my_telescope').project_find_file("~/Apps") end, { desc = 'Find project in ~/Apps' })

vim.keymap.set('n', '<leader>ss', function() require('my_telescope').currenct_buffer_fuzzy_find() end, { desc = 'Swiper' })

vim.keymap.set('n', '<leader>hh', function() require('my_telescope').help_tags() end, { desc = 'Find Help (vim help)' })
vim.keymap.set('n', '<leader>hf', function() require('my_telescope').commands() end, { desc = 'Find Help functions (vim help)' })
vim.keymap.set('n', '<leader>hm', function() require('my_telescope').keymaps() end, { desc = 'Find Keybind' })
