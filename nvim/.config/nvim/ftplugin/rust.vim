nnoremap <c-j> :!cargo run<CR>
nnoremap <c-k> :!cargo test<CR>
nnoremap <leader>;p oprintln!();<ESC>hi
nnoremap <leader>;P Oprintln!();<ESC>hi
nnoremap <leader>;;p yiwoprintln!("{}", );<ESC>hPF{Pa <ESC>
nnoremap <leader>;;P yiwOprintln!("{}", );<ESC>hPF{Pa <ESC>
nnoremap <leader>;;;p yiwoprintln!("{:?}", );<ESC>hPF{Pa <ESC>
nnoremap <leader>;;;P yiwOprintln!("{:?}", );<ESC>hPF{Pa <ESC>
" nnoremap <leader>r :botright split<CR>:term cargo run<CR>
" nnoremap <leader>t :botright split<CR>:term cargo test<CR>
nnoremap <c-j> :w !cargo run<CR>:w<CR>
