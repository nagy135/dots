return {
  'leath-dub/snipe.nvim',
  keys = {
    {
      '<leader>ss',
      function()
        require('snipe').open_buffer_menu()
      end,
      desc = 'Open Snipe buffer menu',
    },
  },
  opts = {
    ui = {
      preselect_current = true,
      position = 'center',
      open_win_override = {
        border = 'rounded',
      },
      text_align = 'file-first',
    },
  },
}
