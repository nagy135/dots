nnoremap <leader>r :! lua % <CR>

nnoremap <leader>;p yiwoprint("<ESC>pa",)<ESC>F,p
nnoremap <leader>;P yiwOprint("<ESC>pa",)<ESC>F,p
nnoremap <leader>;;p yiwoprint("<ESC>pa",vim.inspect())<ESC>F(p
nnoremap <leader>;;P yiwOprint("<ESC>pa",vim.inspect())<ESC>F(p
