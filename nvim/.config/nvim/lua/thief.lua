local M = {}

local pickers = require "telescope.pickers"
local builtin = require "telescope.builtin"
local finders = require "telescope.finders"
local actions = require "telescope.actions"
local conf = require("telescope.config").values
local action_state = require "telescope.actions.state"


M.thief_root = nil
M.project_root = "~/365" -- default place to look for project roots to copy from

local tmpfile = '/tmp/lua_nvim_thief_file.txt'

local function get_project_roots(mask)
    print("mask",vim.inspect(mask))
    local files = {}
    os.execute('gfind ' .. mask .. ' -mindepth 1 -maxdepth 1 -type d -printf "%P\n" > ' .. tmpfile)
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

local function get_directories(root)
    local files = {}
    os.execute('gfind ' .. root .. ' -type d -printf "%P\n" > ' .. tmpfile)
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
        M.thief_root .. '/' .. relative_path .. ' => ' .. vim.fn.getcwd() .. '/' .. relative_path)
    os.execute('mkdir -p $(dirname ' .. vim.fn.getcwd() .. '/' .. relative_path .. ')')
    os.execute('cp ' ..
        M.thief_root .. '/' .. relative_path .. ' ' .. vim.fn.getcwd() .. '/' .. relative_path)
end

local function copy_directory_to_new_root(relative_path)
    print('copying dir: ' ..
        M.thief_root .. '/' .. relative_path .. ' => ' .. vim.fn.getcwd() .. '/' .. relative_path)
    os.execute('mkdir -p $(dirname ' .. vim.fn.getcwd() .. '/' .. relative_path .. ')')
    os.execute('cp -r ' ..
        M.thief_root .. '/' .. relative_path .. ' ' .. vim.fn.getcwd() .. '/' .. relative_path)
end

M.steal_file = function()
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
        cwd = M.thief_root,
        follow = true,
        hidden = true
    }
end

M.steal_directory = function(optional_root)
        if M.thief_root == nil then
            print('NO ROOT SET')
            return
        end

        local dirs = get_directories(M.thief_root)

        pickers.new({}, {
            prompt_title = "Select directory to steal",
            finder = finders.new_table(dirs),
            attach_mappings = function(prompt_bufnr, _)
                actions.select_default:replace(function()
                    actions.close(prompt_bufnr)
                    local selection = action_state.get_selected_entry()
                    if selection.value ~= nil then
                        copy_directory_to_new_root(selection.value)
                    end
                end)
                return true
            end,
            sorter = conf.generic_sorter({}),
        }):find()
end

M.set_root = function(optional_root)
    if optional_root ~= nil then
        M.thief_root = optional_root
    else
        local folders = get_project_roots(M.project_root)
        pickers.new({}, {
            prompt_title = "Select root for stealing",
            finder = finders.new_table(folders),
            attach_mappings = function(prompt_bufnr, _)
                actions.select_default:replace(function()
                    actions.close(prompt_bufnr)
                    local selection = action_state.get_selected_entry()
                    if selection.value ~= nil then
                        M.thief_root = M.project_root .. '/' .. selection.value
                    end
                    print('Root set!')
                end)
                return true
            end,
            sorter = conf.generic_sorter({}),
        }):find()
    end
end


vim.keymap.set('n', '<leader>s',
    function() require 'key-menu'.open_window('<leader>s') end,
    { desc = 'Thief' })

vim.keymap.set('n', '<leader>sr', M.set_root, { desc = 'Steal Root' }) -- Steal Root
vim.keymap.set('n', '<leader>st', M.steal_file, { desc = 'STeal' }) -- STeal
vim.keymap.set('n', '<leader><leader>st', M.steal_directory, { desc = 'STeal directory' }) -- STeal directory

vim.api.nvim_create_user_command(
    'StealRoot',
    function(opts)
        M.set_root(opts.args)
    end,
    { nargs = 1 }
)

return M
