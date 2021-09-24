" autocmd! FileType fzf tnoremap <buffer> <esc> <c-c>
tnoremap <buffer> <esc> <c-c>

if has('nvim') && !exists('g:fzf_layout')
  set laststatus=0 noshowmode noruler
  autocmd BufLeave <buffer> set laststatus=2 showmode ruler
endif
