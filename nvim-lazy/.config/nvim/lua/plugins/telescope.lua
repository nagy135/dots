local telescope_actions = require("telescope.actions")
return {
  "nvim-telescope/telescope.nvim",
  -- change some options
  opts = {
    defaults = {
      mappings = {
        i = {
          ["<C-j>"] = telescope_actions.move_selection_next,
          ["<C-k>"] = telescope_actions.move_selection_previous,
          -- ["<C-q>"] = require("telescope.actions").send_selected_to_qflist + require("telescope.actions").open_qflist,
          -- ["<C-a>"] = require("telescope.actions").send_to_qflist + require("telescope.actions").open_qflist,
          -- ["<c-a>"] = require("trouble.providers.telescope").open_with_trouble,
          -- ["<c-q>"] = require("trouble.providers.telescope").open_selected_with_trouble,
        },
      },
    },
  },
}
