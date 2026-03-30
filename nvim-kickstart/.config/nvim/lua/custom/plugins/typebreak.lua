return {
  'nagy135/typebreak.nvim',
  config = function()
    vim.keymap.set('n', '<leader><leader>tb', function()
      require('typebreak').start(true)
    end, { desc = 'Typebreak' })
  end,
}
