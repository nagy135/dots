local M = {}

local builtin = require("telescope.builtin")

M.pick_wiki = function()
  builtin.find_files({
    prompt_title = "Find wiki",
    cwd = "~/wiki",
    follow = true,
    hidden = true,
  })
end

local wk = require("which-key")
wk.add({
  { "<leader>fw", M.pick_wiki, desc = "Find neorg-wiki" },
})

return M
