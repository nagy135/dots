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
}
