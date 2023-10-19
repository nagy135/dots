local telescope_actions = require("telescope.actions")
return {
  "nvim-telescope/telescope.nvim",
  -- change some options
  dependencies = {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
    config = function()
      require("telescope").load_extension("fzf")
    end,
  },
  opts = {
    defaults = {
      mappings = {
        i = {
          ["<C-j>"] = telescope_actions.move_selection_next,
          ["<C-k>"] = telescope_actions.move_selection_previous,
          ["<C-s>"] = telescope_actions.select_horizontal,
          ["<C-v>"] = telescope_actions.select_vertical,
          ["<C-q>"] = require("telescope.actions").send_selected_to_qflist + require("telescope.actions").open_qflist,
          ["<C-a>"] = require("telescope.actions").send_to_qflist + require("telescope.actions").open_qflist,
          ["<c-x>"] = "delete_buffer",
          -- ["<c-a>"] = require("trouble.providers.telescope").open_with_trouble,
          -- ["<c-q>"] = require("trouble.providers.telescope").open_selected_with_trouble,
        },
      },
    },
  },
  keys = {
    {
      "<leader>fn",
      function()
        require("telescope.builtin").find_files({ cwd = "%:h" })
      end,
      desc = "Find Neightbors",
    },
  },
}
