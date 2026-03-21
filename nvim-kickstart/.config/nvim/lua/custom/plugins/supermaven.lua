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
      '<CMD>SupermavenToggle<CR>',
      desc = 'Toggle SuperMaven',
    },
    -- {
    --   '<leader>ct',
    --   function()
    --     local api = require 'supermaven-nvim.api'
    --     local is_running = api.is_running()
    --     api.toggle()
    --     vim.notify('SuperMaven ' .. (is_running and 'disabled' or 'enabled'), is_running and 'warn' or 'info')
    --   end,
    --   desc = 'Toggle SuperMaven',
    -- },
  },
}
