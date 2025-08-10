return {
  {
    'sainnhe/gruvbox-material',
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'gruvbox-material'
    end,
  },
  {
    'rebelot/kanagawa.nvim',
  },
  { 'catppuccin/nvim', name = 'catppuccin', priority = 1000 },
  { 'shaunsingh/nord.nvim' },
  {
    'vague2k/vague.nvim',
    -- lazy = false, -- make sure we load this during startup if it is your main colorscheme
    -- priority = 1000, -- make sure to load this before all the other plugins
    -- config = function()
    --   require('vague').setup {
    --     -- optional configuration here
    --   }
    --   vim.cmd 'colorscheme vague'
    -- end,
  },
}
