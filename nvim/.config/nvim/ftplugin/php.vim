nnoremap <leader>r :botright split<CR>:term curl $(cat /tmp/nvim_curl 2> /dev/null) -o /tmp/nvim_response &> /dev/null && nvim /tmp/nvim_response<CR><CR>
nnoremap <leader>e :botright split<CR>:e /tmp/nvim_curl<CR>
nnoremap <leader>;p yiwodd("", );<ESC>hPF"PF$x
nnoremap <leader>;P yiwOdd("", );<ESC>hPF"PF$x
nnoremap <leader>;;p yiwodd("", );<ESC>hPF"PF$x
nnoremap <leader>;;P yiwOdd("", );<ESC>hPF"PF$x
