-- nnoremap <leader>]r :! curl $(cat /tmp/nvim_curl 2> /dev/null) 2> /dev/null <bar> jq > /tmp/nvim_response.json<CR> :botright split /tmp/nvim_response.json<CR>
-- nnoremap <leader>]e :botright split /tmp/nvim_curl<CR>

-- nnoremap <leader>p oconsole.log();<ESC>hi
-- nnoremap <leader>P Oconsole.log();<ESC>hi
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
-- vim.keymap.set("n", "<leader>r", "<CMD>!npm run start %<CR>", { desc = "npm run start" })

-- " nnoremap <c-k> :! ./run-tests.sh<CR>
-- nnoremap <leader><c-k> :botright split<CR>:term ./run-tests.sh<CR>

-- " nnoremap <c-j> :! npx ts-node %<CR>
