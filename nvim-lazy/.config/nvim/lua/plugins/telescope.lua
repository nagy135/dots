local telescope_actions = require("telescope.actions")

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local sorters = require("telescope.sorters")
local make_entry = require("telescope.make_entry")
local conf = require("telescope.config").values

local ripgrep = function(opts)
  opts = opts or {}
  opts.cwd = opts.cwd or vim.uv.cwd()
  local finder = finders.new_async_job({
    command_generator = function(prompt)
      if not prompt or prompt == "" then
        return nil
      end

      local pieces = vim.split(prompt, "  ")
      local args = { "rg" }
      if pieces[1] then
        table.insert(args, "-e")
        table.insert(args, pieces[1])
      end

      if pieces[2] then
        table.insert(args, "-g")
        table.insert(args, pieces[2])
      end
      table.insert(args, "--color=never")
      table.insert(args, "--no-heading")
      table.insert(args, "--with-filename")
      table.insert(args, "--line-number")
      table.insert(args, "--column")
      table.insert(args, "--smart-case")
      return args
    end,
    entry_makers = make_entry.gen_from_vimgrep(opts),
    cwd = opts.cwd,
  })
  pickers
    .new(opts, {
      debounce = 100,
      prompt_title = "ripgrep",
      finder = finder,
      previewer = conf.grep_previewer(opts),
      sorter = sorters.empty(),
    })
    :find()
end

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
    {
      "<leader>f.",
      function()
        require("telescope.builtin").find_files({ cwd = "%:h" })
      end,
      desc = "Find file in subtree",
    },
    {
      "<leader>f/",
      ripgrep,
      desc = "Ripgrep",
    },
  },
}
