return {
  "folke/twilight.nvim",
  keys = {
    {
      "<leader>zt",
      function()
        require("twilight").toggle()
      end,
      desc = "Twilight (toggle)",
    },
  },
}
