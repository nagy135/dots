return {
  "mistweaverco/kulala.nvim",
  keys = {
    { "<leader>Rf", "<cmd>lua require('kulala').search()<cr>", desc = "Search" },
    { "<leader>Rr", "<cmd>lua require('kulala').replay()<cr>", desc = "Replay" },
    { "<leader>Ri", "<cmd>lua require('kulala').inspect()<cr>", desc = "Inspect" },
    { "<leader>Rc", "<cmd>lua require('kulala').copy()<cr>", desc = "Copy (curl)" },
    { "<leader>RC", "<cmd>lua require('kulala').copy()<cr>", desc = "Create from curl" },
  },
}
