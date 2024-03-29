local actions = require('telescope.actions')
-- Global remapping
------------------------------
local telescope = require('telescope');

telescope.setup {
    defaults = {
        file_ignore_patterns = {
            "node_modules"
        },
        mappings = require('binds.telescope').mappings,
        vimgrep_arguments = {
            'rg',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case',

            '--glob', '!.git/*',
            '--glob', '!_ide_helper*.php',
            '--glob', '!public/packages/**',
            '--glob', '!vendor/**',
            '--glob', '!node_modules/**',
            '--glob', '!tags',
        },
        prompt_prefix = "> ",
        selection_caret = "> ",
        entry_prefix = "  ",
        initial_mode = "insert",
        selection_strategy = "reset",
        sorting_strategy = "descending",
        layout_strategy = "horizontal",
        layout_config = {
            horizontal = {
                mirror = false,
            },
            vertical = {
                mirror = false,
            },
        },
        file_sorter = require 'telescope.sorters'.get_fuzzy_file,
        generic_sorter = require 'telescope.sorters'.get_generic_fuzzy_sorter,
        winblend = 0,
        border = {},
        borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
        color_devicons = true,
        use_less = true,
        path_display = {},
        set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
        file_previewer = require 'telescope.previewers'.vim_buffer_cat.new,
        grep_previewer = require 'telescope.previewers'.vim_buffer_vimgrep.new,
        qflist_previewer = require 'telescope.previewers'.vim_buffer_qflist.new,

        -- Developer configurations: Not meant for general override
        buffer_previewer_maker = require 'telescope.previewers'.buffer_previewer_maker
    },
    extensions = {
        fzy_native = {
            override_generic_sorter = false,
            override_file_sorter = true,
        },
        file_browser = {
            theme = "ivy",
            layout_config = {
                height = 50,
            },
            mappings = {
                ["i"] = {
                    -- your custom insert mode mappings
                },
                ["n"] = {
                    -- your custom normal mode mappings
                },
            },
        },
        ["ui-select"] = {
            require("telescope.themes").get_dropdown {
                -- even more opts
            }

            -- pseudo code / specification for writing custom displays, like the one
            -- for "codeactions"
            -- specific_opts = {
            --   [kind] = {
            --     make_indexed = function(items) -> indexed_items, width,
            --     make_displayer = function(widths) -> displayer
            --     make_display = function(displayer) -> function(e)
            --     make_ordinal = function(e) -> string
            --   },
            --   -- for example to disable the custom builtin "codeactions" display
            --      do the following
            --   codeactions = false,
            -- }
        }
    }
}
telescope.load_extension('fzy_native')
telescope.load_extension('file_browser')
telescope.load_extension('ui-select')

local M = {}

function M.project_find_file(folder)
    local pickers = require "telescope.pickers"
    local finders = require "telescope.finders"
    local conf = require("telescope.config").values
    local action_state = require "telescope.actions.state"

    local projects = function(opts)
        local openPop = assert(io.popen('ls ' .. folder, 'r'))
        local output = openPop:read('*all')
        openPop:close()

        local lines = {}
        for s in output:gmatch("[^\r\n]+") do
            table.insert(lines, s)
        end

        opts = opts or {}
        pickers.new(opts, {
            prompt_title = "Projects",
            finder = finders.new_table {
                results = lines
            },
            sorter = conf.generic_sorter(opts),
            attach_mappings = function(prompt_bufnr)
                actions.select_default:replace(function()
                    actions._close(prompt_bufnr, true)

                    local selection = action_state.get_selected_entry()

                    require("telescope.builtin").find_files { cwd = folder .. '/' .. selection[1], follow = true }
                end)
                return true
            end,
        }):find()
    end

    -- to execute the function
    projects(require("telescope.themes").get_ivy {})
end

return M
