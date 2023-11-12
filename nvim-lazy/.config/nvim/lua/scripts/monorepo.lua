local M = {}

local pickers = require("telescope.pickers")
local builtin = require("telescope.builtin")
local finders = require("telescope.finders")
local actions = require("telescope.actions")
local conf = require("telescope.config").values
local action_state = require("telescope.actions.state")

local tmpfile = "/tmp/lua_nvim_monorepo_folders_file.txt"

M.searching_root = nil

local function get_project_roots()
  local files = {}
  local locations = "./libs" .. " " .. "./apps"
  os.execute("gfind " .. locations .. ' -mindepth 1 -maxdepth 1 -type d -printf "%p\n" > ' .. tmpfile)
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

M.set_root = function()
  local folders = get_project_roots()
  print("folders", vim.inspect(folders))
  pickers
    .new({}, {
      prompt_title = "Select browsing root (lib or app)",
      finder = finders.new_table(folders),
      attach_mappings = function(prompt_bufnr, _)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          if selection.value ~= nil then
            M.searching_root = selection.value
          end
          print("Root set! " .. M.searching_root)
        end)
        return true
      end,
      sorter = conf.generic_sorter({}),
    })
    :find()
end

M.find_in_root = function()
  if M.searching_root == nil then
    print("NO ROOT SET")
    return
  end

  builtin.find_files({
    prompt_title = "Find file in root",
    cwd = M.searching_root,
    follow = true,
    hidden = true,
  })
end

local wk = require("which-key")
wk.register({
  ["<leader>m"] = { name = "+monorepo" },
  ["<leader>mr"] = { M.set_root, "Set Root" },
  ["<leader>mf"] = { M.find_in_root, "Find in root" },
})

return M
