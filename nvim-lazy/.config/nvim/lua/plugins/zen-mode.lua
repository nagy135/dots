return {
  "folke/zen-mode.nvim",
  opts = {
    window = {
      width = 0.6,
    },
  },
  keys = {
    {
      "<leader><leader>z",
      function()
        require("zen-mode").toggle()
      end,
      desc = "Zen Mode",
    },
  },
}
