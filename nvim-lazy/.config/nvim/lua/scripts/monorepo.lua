local M = {}

local builtin = require("telescope.builtin")

local MONOREPO_ROOTS = { "apps/", "libs/" }

local find_monorepo_root = function()
  local current_path = vim.fn.expand("%")
  local cwd_root = vim.fn.getcwd()
  for _, root in ipairs(MONOREPO_ROOTS) do
    if current_path:find("^" .. root) ~= nil then
      local matched_app = current_path:match(root .. "([^/]*)/.*")
      cwd_root = root .. matched_app
    end
  end
  return cwd_root
end

M.find_in_monorepo = function()
  local cwd_root = find_monorepo_root()
  builtin.find_files({
    prompt_title = "Find file in (" .. cwd_root .. ")",
    cwd = cwd_root,
    follow = true,
    hidden = true,
  })
end

M.grep_in_monorepo = function()
  local cwd_root = find_monorepo_root()
  builtin.live_grep({
    prompt_title = "Find file in (" .. cwd_root .. ")",
    cwd = cwd_root,
    follow = true,
  })
end

local wk = require("which-key")
wk.register({
  ["<leader>m"] = { name = "+monorepo" },
  ["<leader>mf"] = { M.find_in_monorepo, "Find in monorepo" },
  ["<leader>m/"] = { M.grep_in_monorepo, "Grep in monorepo" },
})

return M
