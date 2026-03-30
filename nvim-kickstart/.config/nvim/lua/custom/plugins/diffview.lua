local diffview_open = false
return {
  'sindrets/diffview.nvim',
  keys = {
    {
      '<leader>gdf',
      function()
        if diffview_open then
          require('diffview').close()
          diffview_open = false
        else
          vim.cmd 'DiffviewFileHistory %'
          diffview_open = true
        end
      end,
      desc = 'File History',
    },
    {
      '<leader>gdt',
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
