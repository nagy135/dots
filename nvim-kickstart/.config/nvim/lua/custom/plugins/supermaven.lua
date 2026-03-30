return {
  'supermaven-inc/supermaven-nvim',
  lazy = false,
  config = function()
    require('supermaven-nvim').setup {
      color = {
        suggestion_color = '#DBDBDB',
        cterm = 244,
      },
    }
  end,
  keys = {
    {
      '<leader>csr',
      '<CMD>SupermavenRestart<CR>',
      desc = 'Restart SuperMaven',
    },
    {
      '<leader>cst',
      function()
        local api = require 'supermaven-nvim.api'
        api.toggle()

        local is_running = api.is_running()
        vim.notify('SuperMaven ' .. (is_running and 'on' or 'off'), vim.log.levels.INFO)
      end,
      desc = 'Toggle SuperMaven',
    },
  },
}
