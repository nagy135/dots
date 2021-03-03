local actions = require('telescope.actions')
-- Global remapping
------------------------------
require('telescope').setup{
    defaults = {
        file_ignore_patterns = {
            "public/*"
        },
        mappings = {
            i = {
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
            },
        },
    }
}
