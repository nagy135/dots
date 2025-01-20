local M = {}

local pickers = require("telescope.pickers")
local builtin = require("telescope.builtin")
local finders = require("telescope.finders")
local actions = require("telescope.actions")
local conf = require("telescope.config").values
local action_state = require("telescope.actions.state")

M.thief_root = nil
M.project_root = "~/Code" -- default place to look for project roots to copy from
M.target_dir = nil

local tmpfile = "/tmp/lua_nvim_thief_file.txt"

local function get_project_roots(mask)
  print("mask", vim.inspect(mask))
  local files = {}
  os.execute("gfind " .. mask .. ' -mindepth 1 -maxdepth 2 -type d -printf "%P\n" > ' .. tmpfile)
  local f = io.open(tmpfile)
  if not f then
    return files
  end
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
  os.execute("gfind " .. root .. ' -type d -printf "%P\n" > ' .. tmpfile)
  local f = io.open(tmpfile)
  if not f then
    return files
  end
  local k = 1
  for line in f:lines() do
    files[k] = line
    k = k + 1
  end
  f:close()
  return files
end

local function copy_file_to_new_root(relative_path)
  print(
    "copying: "
      .. M.thief_root
      .. "/"
      .. relative_path
      .. " => "
      .. (M.target_dir or vim.fn.getcwd())
      .. "/"
      .. relative_path
  )
  os.execute("mkdir -p $(dirname " .. (M.target_dir or vim.fn.getcwd()) .. "/" .. relative_path .. ")")
  os.execute(
    "cp " .. M.thief_root .. "/" .. relative_path .. " " .. (M.target_dir or vim.fn.getcwd()) .. "/" .. relative_path
  )
end

local function copy_directory_to_new_root(relative_path)
  print(
    "copying dir: "
      .. M.thief_root
      .. "/"
      .. relative_path
      .. " => "
      .. (M.target_dir or vim.fn.getcwd())
      .. "/"
      .. relative_path
  )
  os.execute("mkdir -p $(dirname " .. (M.target_dir or vim.fn.getcwd()) .. "/" .. relative_path .. ")")
  os.execute(
    "cp -r " .. M.thief_root .. "/" .. relative_path .. " " .. (M.target_dir or vim.fn.getcwd()) .. "/" .. relative_path
  )
end

M.steal_file = function()
  if M.thief_root == nil then
    print("NO ROOT SET")
    return
  end

  builtin.find_files({
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
    hidden = true,
  })
end

M.steal_directory = function(optional_root)
  if M.thief_root == nil then
    print("NO ROOT SET")
    return
  end

  local dirs = get_directories(M.thief_root)

  pickers
    .new({}, {
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
    })
    :find()
end

M.set_root = function(optional_root)
  if optional_root ~= nil then
    M.thief_root = optional_root
  else
    local folders = get_project_roots(M.project_root)
    pickers
      .new({}, {
        prompt_title = "Select root for stealing",
        finder = finders.new_table(folders),
        attach_mappings = function(prompt_bufnr, _)
          actions.select_default:replace(function()
            actions.close(prompt_bufnr)
            local selection = action_state.get_selected_entry()
            if selection.value ~= nil then
              M.thief_root = M.project_root .. "/" .. selection.value
            end
            print("Root set!")
          end)
          return true
        end,
        sorter = conf.generic_sorter({}),
      })
      :find()
  end
end

local wk = require("which-key")
wk.add({
  { "<leader><leader>", group = "extra" },
  { "<leader><leader>t", group = "thief" },
})

vim.keymap.set("n", "<leader><leader>tr", M.set_root, { desc = "Thief Root" })
vim.keymap.set("n", "<leader><leader>ts", M.steal_file, { desc = "Thief Steal" })
vim.keymap.set("n", "<leader><leader>td", M.steal_directory, { desc = "Thief Directory" })

vim.api.nvim_create_user_command("ThiefStealRoot", function(opts)
  M.set_root(opts.args)
end, { nargs = 1 })
vim.api.nvim_create_user_command("ThiefFromTo", function(opts)
  local from, to = opts.args:match("(.-)%" .. " " .. "(.+)")
  if from == nil or to == nil then
    print("Usage: ThiefFromTo <from> <to>")
    return
  end
  M.thief_root = from
  M.target_dir = to
  print("SET!")
  print(from .. " => " .. to)
end, { nargs = 1, complete = "file" })

return M
