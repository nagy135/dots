nnoremap <c-j> :w<CR>:!cargo run<CR>
nnoremap ;p oprintln!();<ESC>hi
nnoremap ;P Oprintln!();<ESC>hi
nnoremap ;;p yiwoprintln!("{}", );<ESC>hPF{Pa <ESC>
nnoremap ;;P yiwOprintln!("{}", );<ESC>hPF{Pa <ESC>
nnoremap <leader>r :botright split<CR>:term cargo run<CR>
nnoremap <leader>t :botright split<CR>:term cargo test<CR>
nnoremap <c-j> :w !cargo run<CR>:w<CR>
nnoremap <leader><leader>t :CocCommand rust-analyzer.toggleInlayHints<CR>
