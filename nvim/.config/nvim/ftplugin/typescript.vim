" nnoremap <leader>]r :! curl $(cat /tmp/nvim_curl 2> /dev/null) 2> /dev/null <bar> jq > /tmp/nvim_response.json<CR> :botright split /tmp/nvim_response.json<CR>
" nnoremap <leader>]e :botright split /tmp/nvim_curl<CR>

nnoremap <leader>p oconsole.log();<ESC>hi
nnoremap <leader>P Oconsole.log();<ESC>hi
nnoremap <leader>;p yiwoconsole.log("", );<ESC>hPF"P<ESC>
nnoremap <leader>;P yiwOconsole.log("", );<ESC>hPF"P<ESC>
nnoremap <leader>;;p yiwoconsole.log("================\n", "", , "\n================");<ESC>F,PF"Pa: <ESC>
nnoremap <leader>;;P yiwOconsole.log("================\n", "", , "\n================");<ESC>F,PF"Pa: <ESC>

" nnoremap <c-k> :! ./run-tests.sh<CR>
nnoremap <leader><c-k> :botright split<CR>:term ./run-tests.sh<CR>

" nnoremap <c-j> :! npx ts-node %<CR>
