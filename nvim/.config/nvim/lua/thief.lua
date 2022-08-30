local M = {}

local pickers = require "telescope.pickers"
local builtin = require "telescope.builtin"
local finders = require "telescope.finders"
local actions = require "telescope.actions"
local conf = require("telescope.config").values
local action_state = require "telescope.actions.state"


M.thief_root = nil
M.project_root = "~/Apps"

local function get_files(mask)
    local files = {}
    local tmpfile = '/tmp/lua_nvim_thief_file.txt'
    os.execute('find ' .. mask .. ' -maxdepth 2 -type d -printf "%P\n" > ' .. tmpfile)
    local f = io.open(tmpfile)
    if not f then return files end
    local k = 1
    for line in f:lines() do
        files[k] = line
        k = k + 1
    end
    f:close()
    return files
end

local function copy_file_to_new_root(relative_path)
    print('copying: ' ..
        M.project_root ..
        '/' .. M.thief_root .. '/' .. relative_path .. ' => ' .. vim.fn.getcwd() .. '/' .. relative_path)
    os.execute('mkdir -p $(dirname ' .. vim.fn.getcwd() .. '/' .. relative_path .. ')')
    os.execute('cp ' ..
        M.project_root .. '/' .. M.thief_root .. '/' .. relative_path .. ' ' .. vim.fn.getcwd() .. '/' .. relative_path)
end

M.start_stealing = function()
    if M.thief_root == nil then
        print('NO ROOT SET')
        return
    end

    builtin.find_files {
        attach_mappings = function(prompt_bufnr, _)
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                if selection.value ~= nil then
                    copy_file_to_new_root(selection.value)
                end
            end)
            return true
        end,
        prompt_title = "Steal File",
        cwd = M.project_root .. '/' .. M.thief_root,
        follow = true, hidden = true
    }
end


M.set_root = function()
    local folders = get_files(M.project_root)
    pickers.new({}, {
        prompt_title = "Select root for stealing",
        finder = finders.new_table(folders),
        attach_mappings = function(prompt_bufnr, _)
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                if selection.value ~= nil then
                    M.thief_root = selection.value
                end
                print('Root set!')
            end)
            return true
        end,
        sorter = conf.generic_sorter({}),
    }):find()
end


vim.keymap.set('n', '<leader>s',
    function() require 'key-menu'.open_window('<leader>s') end,
    { desc = 'Thief' })

vim.keymap.set('n', '<leader>sr', M.set_root, { desc = 'Steal Root' }) -- Steal Root
vim.keymap.set('n', '<leader>st', M.start_stealing, { desc = 'STeal' }) -- STeal

return M
