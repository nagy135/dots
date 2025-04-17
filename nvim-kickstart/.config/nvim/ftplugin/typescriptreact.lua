vim.keymap.set('n', '<leader>;p', 'yiwoconsole.log("", );<ESC>hPF"P<ESC>', { desc = 'variable' })
vim.keymap.set('n', '<leader>;P', 'yiwOconsole.log("", );<ESC>hPF"P<ESC>', { desc = 'variable (above)' })
vim.keymap.set('n', '<leader>;;p', 'yiwoconsole.log("================\\n", "", , "\\n================");<ESC>F,PF"Pa: <ESC>', { desc = 'variable with lines' })
vim.keymap.set(
  'n',
  '<leader>;;P',
  'yiwOconsole.log("================\\n", "", , "\\n================");<ESC>F,PF"Pa: <ESC>',
  { desc = 'variable with lines (above)' }
)

vim.keymap.set(
  'n',
  '<leader>;;j',
  'yiwoconsole.log("================\\n", "", , "\\n================");<ESC>F,PF"Pa: <ESC>f,laJSON.stringify(<ESC>f,i, null, 2)<ESC>',
  { desc = 'JSON.stringify variable with lines' }
)
vim.keymap.set(
  'n',
  '<leader>;;J',
  'yiwOconsole.log("================\\n", "", , "\\n================");<ESC>F,PF"Pa: <ESC>f,laJSON.stringify(<ESC>f,i, null, 2)<ESC>',
  { desc = 'JSON.stringify variable with lines (above)' }
)
