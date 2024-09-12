local wk = require("which-key")
wk.add({
  { "<leader>n", group = "neorg" },
})
wk.add({
  { "<leader>np", group = "presenter" },
})

return {
  "nvim-neorg/neorg",
  build = ":Neorg sync-parsers",
  dependencies = { "nvim-lua/plenary.nvim" },
  lazy = false,
  config = function()
    require("neorg").setup({
      load = {
        ["core.defaults"] = {}, -- Loads default behaviour

        ["core.integrations.treesitter"] = {},
        ["core.syntax"] = {},
        ["core.presenter"] = {
          config = {
            zen_mode = "zen-mode",
          },
        },
        ["core.queries.native"] = {},
        ["core.ui"] = {},

        ["core.concealer"] = {
          config = {
            icon_preset = "diamond",
          },
        }, -- Adds pretty icons to your documents
        ["core.dirman"] = { -- Manages Neorg workspaces
          config = {
            workspaces = {
              notes = "~/notes",
              wiki = "~/wiki",
            },
            default_workspace = "wiki",
          },
        },
      },
    })
  end,
  keys = {
    -- add a keymap to browse plugin files
    -- stylua: ignore
    {
      "<leader>ni",
      "<cmd>Neorg index<cr>",
      desc = "Index",
    },
    {
      "<leader>nps",
      "<cmd>Neorg presenter start<cr>",
      desc = "Start",
    },
    {
      "<leader>npc",
      "<cmd>Neorg presenter close<cr>",
      desc = "Close",
    },
  },
}
