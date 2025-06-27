-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
    's1n7ax/nvim-window-picker',
  },
  cmd = 'Neotree',
  keys = {
    { '<leader><leader>e', ':Neotree reveal toggle<CR>', desc = 'NeoTree reveal', silent = true },
    { '<leader><leader>E', ':Neotree focus<cr>', desc = 'Neotree focus' },
    { '<leader><leader>gS', ':Neotree git_status float reveal<CR>', desc = '[G]it [S]tatus (Neotree)', silent = true },
    { '<leader><leader>fB', ':Neotree buffers float reveal<CR>', desc = '[F]ind [B]uffers (Neotree)', silent = true },
  },
  opts = {
    filesystem = {
      follow_current_file = {
        enabled = true,
      },
      window = {
        mappings = {
          ['\\'] = 'close_window',
          ['<space>'] = 'none',
          ['s'] = 'split_with_window_picker',
          ['v'] = 'vsplit_with_window_picker',
          ['/'] = 'none',

          ['Y'] = function(state)
            -- NeoTree is based on [NuiTree](https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/tree)
            -- The node is based on [NuiNode](https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/tree#nuitreenode)
            local node = state.tree:get_node()
            local filepath = node:get_id()
            local filename = node.name
            local modify = vim.fn.fnamemodify

            local results = {
              filepath,
              modify(filepath, ':.'),
              modify(filepath, ':~'),
              filename,
              modify(filename, ':r'),
              modify(filename, ':e'),
            }

            vim.ui.select({
              '1. Absolute path: ' .. results[1],
              '2. Path relative to CWD: ' .. results[2],
              '3. Path relative to HOME: ' .. results[3],
              '4. Filename: ' .. results[4],
              '5. Filename without extension: ' .. results[5],
              '6. Extension of the filename: ' .. results[6],
            }, { prompt = 'Choose to copy to clipboard:' }, function(choice)
              local i = tonumber(choice:sub(1, 1))
              local result = results[i]
              vim.fn.setreg('+', result)
              vim.notify('Copied: ' .. result)
            end)
          end,
        },
      },
    },
  },
}
