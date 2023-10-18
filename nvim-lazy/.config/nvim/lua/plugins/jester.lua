local wk = require("which-key")
wk.register({
  ["<leader>j"] = { name = "+jest" },
})

return {
  "David-Kunz/jester",
  opts = {
    path_to_jest_run = 'npx jest', -- used to run tests
  },
  keys = {
    {
      "<leader>jr",
      function()
        require('jester').run()
      end,
      desc = "Run"
    },
    {
      "<leader>jj",
      function()
        require('jester').run()
      end,
      desc = "Run"
    },
    {
      "<leader>jf",
      function()
        require('jester').run_file()
      end,
      desc = "File"
    },
    {
      "<leader>jl",
      function()
        require('jester').run_last()
      end,
      desc = "Last"
    }
  }
}
