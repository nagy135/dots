return {
  "folke/zen-mode.nvim",
  opts = {
    window = {
      width = 0.6,
    },
    plugins = {
      twilight = {
        enabled = false,
      },
    },
  },
  keys = {
    {
      "<leader>zz",
      function()
        require("zen-mode").toggle()
      end,
      desc = "Zen Mode (toggle)",
    },
    {
      "<leader>zm",
      function()
        require("zen-mode").toggle()
      end,
      desc = "Zen Mode (toggle)",
    },
  },
}
