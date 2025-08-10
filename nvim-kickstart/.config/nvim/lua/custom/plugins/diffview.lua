local diffview_open = false
return {
  'sindrets/diffview.nvim',
  keys = {
    {
      '<leader>df',
      function()
        if diffview_open then
          require('diffview').close()
          diffview_open = false
        else
          require('diffview').file_history()
          diffview_open = true
        end
      end,
    },
    {
      '<leader>dt',
      function()
        if diffview_open then
          require('diffview').close()
          diffview_open = false
        else
          require('diffview').open {}
          diffview_open = true
        end
      end,
      desc = 'Toggle Diff View',
    },
  },
}
