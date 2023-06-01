return {
  'vimwiki/vimwiki',
  config = function()
    vim.g.vimwiki_list = {
      {
        path = '~/wiki',
        syntax = 'markdown',
        ext = '.md',
      }
    }
  end
}
