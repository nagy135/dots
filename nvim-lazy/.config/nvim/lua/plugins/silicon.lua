return {
  "michaelrommel/nvim-silicon",
  lazy = true,
  cmd = "Silicon",
  main = "nvim-silicon",
  opts = {
    -- Configuration here, or leave empty to use defaults
    theme = "Visual Studio Dark+",
    line_offset = function(args)
      return args.line1
    end,
  },
  keys = {
    {
      "<leader>C",
      function()
        require("nvim-silicon").clip()
      end,
      desc = "Screenshot code",
      mode = { "n", "v", "s", "x" },
    },
  },
}
