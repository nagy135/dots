return {
  "michaelrommel/nvim-silicon",
  lazy = true,
  cmd = "Silicon",
  main = "nvim-silicon",
  opts = {
    -- Configuration here, or leave empty to use defaults
    line_offset = function(args)
      return args.line1
    end,
  },
  keys = {
    {
      "<leader>cs",
      function()
        require("nvim-silicon").clip()
      end,
      desc = "Screenshot code",
      mode = { "n" },
    },
    {
      "<leader>cs",
      "<cmd>'<,'>Silicon<cr>",
      desc = "Screenshot highlight",
      mode = { "v", "s", "x" },
    },
  },
}
