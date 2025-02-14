return {
  "ibhagwan/fzf-lua",
  opts = function(_, opts)
    local config = require("fzf-lua.config")
    local actions = require("fzf-lua.actions")

    -- Quickfix
    config.defaults.keymap.fzf["ctrl-a"] = "select-all+accept"
  end,
  keys = {
    {
      "<leader>fn",
      function()
        require("fzf-lua").files({ cwd = "%:h" })
      end,
      desc = "Find neighbor files",
    },
  },
}
