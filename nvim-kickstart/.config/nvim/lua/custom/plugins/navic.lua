return {
  'SmiteshP/nvim-navic',
  dependencies = { 'neovim/nvim-lspconfig' },
  config = function()
    local navic = require 'nvim-navic'

    vim.lsp.config('tsgo', {
      on_attach = function(client, bufnr)
        navic.attach(client, bufnr)
      end,
    })

    vim.lsp.config('alejandra', {
      on_attach = function(client, bufnr)
        navic.attach(client, bufnr)
      end,
    })

    vim.lsp.enable 'tsgo'

    -- Command to display navic location in notification
    vim.api.nvim_create_user_command('NavicNotify', function()
      if navic.is_available() then
        local location = navic.get_location()
        if location ~= '' then
          vim.notify(location, vim.log.levels.INFO, { title = 'Navic Location' })
        else
          vim.notify('No location available', vim.log.levels.WARN, { title = 'Navic Location' })
        end
      else
        vim.notify('Navic is not available', vim.log.levels.WARN, { title = 'Navic Location' })
      end
    end, {})

    -- Keymap to show breadcrumbs
    vim.keymap.set('n', '<leader>cb', '<CMD>NavicNotify<CR>', { desc = '[C]ode [B]readcrumbs' })
  end,
}
