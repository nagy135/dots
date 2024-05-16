local telescope_actions = require("telescope.actions")
return {
  "nvim-telescope/telescope.nvim",
  -- change some options
  dependencies = {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
    config = function()
      require("telescope").load_extension("fzf")
      require("telescope").load_extension("file_browser")
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
          ["<C-t>"] = telescope_actions.select_tab,
          ["<C-q>"] = require("telescope.actions").send_selected_to_qflist + require("telescope.actions").open_qflist,
          ["<C-a>"] = require("telescope.actions").send_to_qflist + require("telescope.actions").open_qflist,
          ["<c-x>"] = "delete_buffer",
          -- ["<c-a>"] = require("trouble.providers.telescope").open_with_trouble,
          -- ["<c-q>"] = require("trouble.providers.telescope").open_selected_with_trouble,
        },
        n = {
          ["<C-s>"] = telescope_actions.select_horizontal,
          ["<C-t>"] = telescope_actions.select_tab,
          ["<c-x>"] = "delete_buffer",
        },
      },
    },
    extensions = {
      file_browser = {
        mappings = {
          i = {
            ["<C-m>"] = function(prompt_bufnr)
              local entry = require("telescope.actions.state").get_selected_entry()
              local path = entry.path -- path of the currently selected entry
              -- do whatever you want to do when you hit `<C-m>` (for example)
            end,
          },
        },
      },
    },
  },
  keys = {
    {
      "<leader>fn",
      function()
        require("telescope").extensions.file_browser.file_browser({ cwd = "%:h" })
      end,
      desc = "Find Neightbors",
    },
  },
}
