local codeiumEnabled = true;

return {
  'Exafunction/codeium.vim',
  event = 'BufEnter',
  config = function()
    vim.keymap.set('i', '<C-l>', function() return vim.fn['codeium#Accept']() end, { expr = true })
    vim.keymap.set('i', '<c-j>', function() return vim.fn['codeium#CycleCompletions'](1) end, { expr = true })
    -- vim.keymap.set('i', '<c-k>', function() return vim.fn['codeium#CycleCompletions'](-1) end, { expr = true })
    vim.keymap.set('i', '<c-h>', function() return vim.fn['codeium#Clear']() end, { expr = true })
    vim.keymap.set('n', '<leader>ct',
      function()
        codeiumEnabled = not codeiumEnabled
        vim.notify('Codeium ' .. (codeiumEnabled and 'Enabled' or 'Disabled'))
        if codeiumEnabled == false then
          return '<cmd>CodeiumDisable<CR>'
        else
          return '<cmd>CodeiumEnable<CR>'
        end
      end,
      { desc = "Codeium toggle", expr = true })
  end
}
