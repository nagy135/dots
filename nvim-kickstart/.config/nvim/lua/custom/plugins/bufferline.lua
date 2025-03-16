return {
  'akinsho/bufferline.nvim',
  version = '*',
  dependencies = 'nvim-tree/nvim-web-devicons',
  lazy = false,
  config = function()
    require('bufferline').setup()
  end,
  keys = {
    { 'H', '<CMD>bprev<CR>', '[B]uffer [P]revious' },
    { 'L', '<CMD>bnext<CR>', '[B]uffer [N]ext' },
  },
}
