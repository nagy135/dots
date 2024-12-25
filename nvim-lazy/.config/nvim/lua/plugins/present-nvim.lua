return {
  "tjdevries/present.nvim",
  config = function()
    require("present").setup({
      executors = {
        python = require("present").create_system_executor("python"),
        javascript = require("present").create_system_executor("node"),
      },
    })
  end,
  keys = {
    {
      "<leader>P",
      function()
        require("present").start_presentation()
      end,
      desc = "Start Presentation",
    },
  },
}
