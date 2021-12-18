nnoremap <leader>p oconsole.log();<ESC>hi
nnoremap <leader>P Oconsole.log();<ESC>hi
nnoremap <leader>;p yiwoconsole.log("", );<ESC>hPF"P<ESC>
nnoremap <leader>;P yiwOconsole.log("", );<ESC>hPF"P<ESC>
nnoremap <leader>;;p yiwoconsole.log("================\n", "", , "\n================");<ESC>F,PF"Pa: <ESC>
nnoremap <leader>;;P yiwOconsole.log("================\n", "", , "\n================");<ESC>F,PF"Pa: <ESC>

nnoremap <c-j> :! npx ts-node %<CR>
