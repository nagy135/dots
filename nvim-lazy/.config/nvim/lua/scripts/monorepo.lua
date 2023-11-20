local M = {}

local builtin = require("telescope.builtin")

local MONOREPO_ROOTS = { "apps/", "libs/" }

M.find_in_monorepo = function()
  local current_path = vim.fn.expand("%")
  local cwd_root = vim.fn.getcwd()
  for _, root in ipairs(MONOREPO_ROOTS) do
    if current_path:find("^" .. root) ~= nil then
      local matched_app = current_path:match(root .. "([^/]*)/.*")
      cwd_root = root .. matched_app
    end
  end
  builtin.find_files({
    prompt_title = "Find file in (" .. cwd_root .. ")",
    cwd = cwd_root,
    follow = true,
    hidden = true,
  })
end

local wk = require("which-key")
wk.register({
  ["<leader>m"] = { name = "+monorepo" },
  ["<leader>mf"] = { M.find_in_monorepo, "Find in monorepo root" },
})

return M
