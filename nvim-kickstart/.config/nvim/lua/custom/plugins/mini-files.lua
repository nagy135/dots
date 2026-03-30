return {
  {
    'nvim-mini/mini.nvim',
    version = '*',
    config = function()
      require('mini.files').setup {
        options = {
          use_as_default_explorer = false,
        },
      }
    end,
    keys = {
      {
        '<leader>fm',
        function()
          require('mini.files').open(vim.api.nvim_buf_get_name(0), true)
        end,
        { desc = '[F]ile [M]ini-explorer' },
      },
    },
  },
}
