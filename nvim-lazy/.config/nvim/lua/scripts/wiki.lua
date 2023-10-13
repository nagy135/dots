local M = {}

local pickers = require "telescope.pickers"
local builtin = require "telescope.builtin"
local finders = require "telescope.finders"
local actions = require "telescope.actions"
local conf = require("telescope.config").values
local action_state = require "telescope.actions.state"


M.pick_wiki = function()
  builtin.find_files {
    prompt_title = "Pick wiki",
    cwd = "~/wiki",
    follow = true,
    hidden = true
  }
end


local wk = require("which-key")
wk.register({
  ["<leader>nw"] = { M.pick_wiki, "Pick neorg-wiki" },
})

return M
