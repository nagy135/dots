return {
  {
    'nvim-mini/mini.nvim',
    version = '*',
    lazy = false,
    config = function()
      require('mini.diff').setup()
    end,
    keys = {
      {
        '<leader>gdd',
        function()
          if _G.MiniDiff == nil then
            require('mini.diff').setup()
          end

          local diff = require 'mini.diff'
          if not diff.get_buf_data(0) then
            diff.enable(0)
          end
          diff.toggle_overlay(0)
        end,
        desc = 'Mini.Diff toggle overlay',
      },
    },
  },
}
