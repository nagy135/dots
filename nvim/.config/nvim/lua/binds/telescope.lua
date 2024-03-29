local M = {}
local actions = require('telescope.actions');
local utils = require("../utils");

M.mappings = {
    i = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-s>"] = actions.select_horizontal,
        ["<C-v>"] = actions.select_vertical,
        ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
        ["<C-a>"] = actions.send_to_qflist + actions.open_qflist,
    },
    n = {
        ["<C-j>"] = actions.results_scrolling_down,
        ["<C-k>"] = actions.results_scrolling_up,
    }
}

vim.keymap.set('n', '<leader>f',
    function() require 'key-menu'.open_window('<leader>f') end,
    { desc = 'Find X' })


utils.alias_binds({
    "<leader>ff",
    "<c-f>"
},
    function()
        require('telescope.builtin').find_files()
    end,
    { desc = 'Find Files' }
)

--
vim.keymap.set('n', '<leader>fn', function() require("telescope.builtin").find_files({ cwd = "%:h" }) end,
    { desc = 'Find Neightbors' })
--
vim.keymap.set('n', '<leader>fd',
    function() require("telescope.builtin").find_files { cwd = "~/.config", follow = true, hidden = true } end,
    { desc = 'Find Config' })
--
utils.alias_binds({
    "<leader>fg",
    "<c-g>"
},
    function()
        require('telescope.builtin').live_grep()
    end,
    { desc = 'Live Grep' }
)
--
utils.alias_binds({
    "<leader>fb",
    "<leader>b",
    "<c-e>"
},
    function()
        require('telescope.builtin').buffers(require('telescope.themes').get_ivy({}))
    end,
    { desc = 'Find Buffers' }
)
--
vim.keymap.set('n', '<leader>fs', function() require('telescope.builtin').grep_string() end,
    { desc = 'Grep String under cursor' })
--
vim.keymap.set('n', '<leader>fc', function() require('telescope.builtin').command_history() end,
    { desc = 'Find Command' })
--
vim.keymap.set('n', '<leader>fo', function() require('telescope.builtin').oldfiles() end, { desc = 'Find Old Files' })
--
vim.keymap.set('n', '<leader>fl', function() require('telescope.builtin').git_status() end, { desc = 'Find Git changes' })
--
vim.keymap.set('n', '<leader>fL', function() require('telescope.builtin').git_bcommits() end,
    { desc = 'Find Buffer Git changes' })
--
vim.keymap.set('n', '<leader>gd', function() require('telescope.builtin').lsp_definitions() end,
    { desc = 'Find LSP Definitions' })

vim.keymap.set('n', '<leader>gs', function() require('telescope.builtin').lsp_document_symbols() end,
    { desc = 'Find LSP Symbols (current buffer)' })
--
vim.keymap.set('n', '<leader>gr', function() require('telescope.builtin').lsp_references() end,
    { desc = 'Find LSP References' })
--
vim.keymap.set('n', '<leader>gi', function() require('telescope.builtin').lsp_implementations() end,
    { desc = 'Find LSP implementations' })
--
vim.keymap.set('n', '<leader>gD', function() require('telescope.builtin').lsp_type_definitions() end,
    { desc = 'Find LSP Declarations (type definitions)' })
--
vim.keymap.set('n', '<leader>fe', function() require('telescope').extensions.file_browser.file_browser() end,
    { desc = 'File Browser' })

--
vim.keymap.set('n', '<leader>ld', function() require('telescope.builtin').diagnostics() end,
    { desc = 'Find Diagnostics' })
--
vim.keymap.set('n', '<leader>lD', function() require('telescope.builtin').diagnostics({ bufnr = 0 }) end,
    { desc = 'Find Buffer Diagnostics' })
--
vim.keymap.set('n', '<leader>fm', function() require('telescope.builtin').man_pages() end, { desc = 'Find Man Page' })
--
vim.keymap.set('n', '<leader>fz', function() require('telescope.builtin').spell_suggest() end, { desc = 'Spell Suggest' })
--
vim.keymap.set('n', '<leader>lj', function() require('telescope.builtin').lsp_document_symbols() end,
    { desc = 'Find Document Symbols' })
--
vim.keymap.set('n', '<leader>lJ', function() require('telescope.builtin').lsp_workspace_symbols() end,
    { desc = 'Find Workspace Symbols' })
--
vim.keymap.set('n', '<leader>fp', function() require('telescope.builtin').project_find_file("~/Clones") end,
    { desc = 'Find project in ~/Clones' })
--
vim.keymap.set('n', '<leader>fa', function() require('telescope.builtin').project_find_file("~/Apps") end,
    { desc = 'Find project in ~/Apps' })
--
vim.keymap.set('n', '<leader>ss', function() require('telescope.builtin').current_buffer_fuzzy_find() end,
    { desc = 'Swiper' })
--
vim.keymap.set('n', '<leader>hh', function() require('telescope.builtin').help_tags() end,
    { desc = 'Find Help (vim help)' })
--
vim.keymap.set('n', '<leader>hf', function() require('telescope.builtin').commands() end,
    { desc = 'Find Help functions (vim help)' })
--
vim.keymap.set('n', '<leader>hm', function() require('telescope.builtin').keymaps() end, { desc = 'Find Keybind' })

return M
