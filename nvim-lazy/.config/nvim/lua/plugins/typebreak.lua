return {
  "nagy135/typebreak.nvim",
  requires = "nvim-lua/plenary.nvim",
  config = function()
    vim.keymap.set("n", "<leader>tb", require("typebreak").start, { desc = "Typebreak" })
  end,
}
