" ██╗   ██╗██╗███╗   ███╗██████╗  ██████╗
" ██║   ██║██║████╗ ████║██╔══██╗██╔════╝
" ██║   ██║██║██╔████╔██║██████╔╝██║
" ╚██╗ ██╔╝██║██║╚██╔╝██║██╔══██╗██║
"  ╚████╔╝ ██║██║ ╚═╝ ██║██║  ██║╚██████╗
"   ╚═══╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝

" Settings {{{
syntax on
filetype indent on
set foldmethod=marker
set tabstop=4
set expandtab
set shiftwidth=4
set relativenumber
set sts=4
set ts=4
set autoindent
set path+=**
" set cursorline
" set cursorcolumn
set wildmenu
set showcmd
set showmatch
set incsearch
set hlsearch
set number
set numberwidth=3
set lazyredraw
set noshowmode
set listchars=tab:▸\ ,eol:¬
set list
if has('nvim')
    set inccommand=split
endif
set maxfuncdepth=1000
set undofile
set undodir=~/.vim/undodir
set conceallevel=0
set splitbelow
set splitright
"}}}

"Mappings {{{
nnoremap H ^
nnoremap L $
nnoremap <C-b> :NERDTreeToggle<CR>
nnoremap ;ft   :NERDTreeFind<CR>
" nnoremap <c-s> :source ~/.vimrc<CR>
nnoremap <c-s> :w<CR>
nnoremap <c-n> :call DeleteFunctionUnderCursor()<CR>
nnoremap <c-h> :nohl<CR>
nnoremap <c-k> :ColorToggle<CR>
nnoremap <c-f> :silent !ctags %<CR>:Tagbar<CR>
nnoremap <c-l> :.-1read ~/.vim/snippets/loremipsum<CR>
nnoremap ,html :-1read ~/.vim/snippets/html_template.html<CR>jjjf>a
map <F8> :call AutoScroll()<CR>
nnoremap <F4> :CtrlPClearAllCaches<CR>
nnoremap <F1> :let @+ = expand("%:p")<CR>
vnoremap // y/\V<C-r>=escape(@",'/\')<CR><CR>
nnoremap ;b :.w !bash<CR>
vnoremap ;b :w !bash<CR>
nnoremap n nzz
nnoremap N Nzz
nnoremap <F3> :set spell!<CR>
nnoremap <C-p> :Files<CR>
" nnoremap <C-m> :BLines<CR>
nnoremap <c-g> :Rg<CR>
tnoremap <Esc> <C-\><C-n>
nnoremap <F4> :call ZathuraOpen()<CR>
"}}}

" AutoCommands {{{
"MatLab
autocmd FileType matlab nnoremap gcc mlI%<space><esc>`lll
"LaTeX
autocmd FileType tex nnoremap <c-j> :w !pdflatex % &> /dev/null<CR>
"Python
autocmd FileType python nnoremap <c-j> :w !python<CR>:w<CR>
autocmd FileType python nnoremap ;p oprint()<ESC>i
autocmd FileType python nnoremap ;P Oprint()<ESC>i
autocmd FileType python nnoremap ;;p yiwoprint('', )<ESC>PF'P^
autocmd FileType python nnoremap ;;P yiwOprint('', )<ESC>PF'P^
"Go
autocmd FileType go nnoremap <c-j> :w !go build<CR>:w<CR>
autocmd FileType go nnoremap ;p ofmt.Println()<ESC>i
autocmd FileType go nnoremap ;P Ofmt.Println()<ESC>i
autocmd FileType go nnoremap ;;p yiwofmt.Println("", )<ESC>PF"P^
autocmd FileType go nnoremap ;;P yiwOfmt.Println("", )<ESC>PF"P^
"Rust
autocmd FileType rust nnoremap <c-j> :w !cargo run<CR>:w<CR>
"SH
autocmd FileType sh nnoremap <c-j> :w !bash<CR>:w<CR>
autocmd FileType sh nnoremap ;;p yiwoecho ""<ESC>PA $<ESC>p
autocmd FileType sh nnoremap ;;P yiwOecho ""<ESC>PA $<ESC>p
autocmd FileType sh nnoremap ;p oecho <ESC>a
autocmd FileType sh nnoremap ;P Oecho <ESC>a
"C++
autocmd FileType cpp nnoremap <c-j> :make!<CR>
autocmd FileType c nnoremap <c-j> :make!<CR>
autocmd FileType cpp nnoremap <c-l> :!choose_main<CR>
"Perl
autocmd FileType perl nnoremap <c-j> :w !perl<CR>

autocmd FileType typescript nmap ;cl oconsole.log(<ESC>lmiA;<ESC>`ii
autocmd FileType javascript nmap ;cl oconsole.log(<ESC>lmiA;<ESC>`ii
autocmd FileType typescript nmap ;cL Oconsole.log(<ESC>lmiA;<ESC>`ii
autocmd FileType javascript nmap ;cL Oconsole.log(<ESC>lmiA;<ESC>`ii

augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
augroup END
"}}}

" Color schemes {{{
" colorscheme molokai
" colorscheme luna-term
colorscheme jellybeans
" }}}

" Plugin setup {{{
if !exists('g:jellybeans_overrides')
    let g:jellybeans_overrides = {
    \    'background': { 'guibg': '123123' },
    \}
endif

let g:indent_guides_enable_on_vim_startup = 1
" let g:molokai_original = 1

let g:airline_theme='jellybeans'

let g:indentLine_char = '|'

let g:vim_json_syntax_conceal = 0

let g:goyo_width = 131
let g:goyo_height = 102

let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit' }
let g:fzf_buffers_jump = 1

" Opens pdf with zathura
function! ZathuraOpen()
    let path = expand('%:p')
    let arr = split( path, '\.')
    let pdf = arr[0] . '.pdf'
    execute "silent !zathura " . pdf . " &"
endfunc
"}}}

" Functions {{{
" Deletes function call and its brackets when hovered over function name
function! DeleteFunctionUnderCursor()
    let line = getline('.')
    set iskeyword+=.
    normal! diwxml
    set iskeyword-=.
    let i = 1
    let c = 1
    while i <= strlen(line)
        let char = getline('.')[col('.') - 1]
        if (char == '(')
            let c += 1
        elseif (char == ')')
            let c -= 1
        endif
        if (c == 0)
            let most_inner = 1
            let u = col('.')
            let u -= 1
            while (u > 2)
                let char_inner = getline('.')[u-1]
                if (char_inner == ')')
                    let most_inner = 0
                    break
                endif
                if (char_inner == '(')
                    let most_inner = 1
                    break
                endif
                let u -= 1
            endwhile

            if (most_inner == 0)
                normal dT)x`l
            else
                normal x`l
            endif
            break
        endif
        normal! l
        let i += 1
    endwhile
endfunc

function! Check_letter()
    normal! h
    if getline(".")[col(".")-1] == '('
        echom "som dnu"
    endif
endfunc

function! AutoScroll()
    " let l:line_count = str2nr(line('$'))
    " set maxfuncdepth = l:line_count
    call AutoScrollRecurse()
endfunction

function! AutoScrollRecurse()
    normal! j
    redraw
    sleep 600m
    call AutoScrollRecurse()
endfunction

"}}}

" Plug {{{
call plug#begin('~/.vim/plugged')
    Plug 'vim-airline/vim-airline'
    Plug 'nathanaelkane/vim-indent-guides'
    Plug 'scrooloose/nerdtree'
    Plug 'ervandew/supertab'
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-commentary'
    Plug 'tpope/vim-eunuch'
    Plug 'majutsushi/tagbar'
    Plug 'raviqqe/vim-nonblank'
    Plug 'chrisbra/Colorizer'
    Plug 'mattn/emmet-vim'
    Plug 'rstacruz/vim-closer'
    " Plug 'kien/ctrlp.vim'
    Plug 'junegunn/fzf.vim'
    Plug 'LandonSchropp/vim-stamp'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'mhinz/vim-startify'
    " Plug 'ycm-core/YouCompleteMe'
    " Plug 'junegunn/goyo.vim'
    " Plug 'neoclide/coc.nvim', {'tag': '*', 'do': { -> coc#util#install()}}
call plug#end()
"}}}

" Coc.nvim setup {{{
"
  " Coc.nvim

" let g:coc_global_extensions = [ 'coc-emoji', 'coc-eslint', 'coc-prettier', 'coc-tsserver', 'coc-tslint', 'coc-tslint-plugin', 'coc-css', 'coc-json', 'coc-pyls', 'coc-yaml' ]

" " Better display for messages
" set cmdheight=2
" " Smaller updatetime for CursorHold & CursorHoldI
" set updatetime=300
" " don't give |ins-completion-menu| messages.
" set shortmess+=c
" " always show signcolumns
" set signcolumn=yes

" " Use `lp` and `ln` for navigate diagnostics
" nmap <silent> <leader>lp <Plug>(coc-diagnostic-prev)
" nmap <silent> <leader>ln <Plug>(coc-diagnostic-next)

" " Remap keys for gotos
" nmap <silent> <leader>ld <Plug>(coc-definition)
" nmap <silent> <leader>lt <Plug>(coc-type-definition)
" nmap <silent> <leader>li <Plug>(coc-implementation)
" nmap <silent> <leader>lf <Plug>(coc-references)

" " Remap for rename current word
" nmap <leader>lr <Plug>(coc-rename)

" " Use K for show documentation in preview window
" nnoremap <silent> K :call <SID>show_documentation()<CR>

" function! s:show_documentation()
"   if &filetype == 'vim'
"     execute 'h '.expand('<cword>')
"   else
"     call CocAction('doHover')
"   endif
" endfunction

" " Highlight symbol under cursor on CursorHold
" autocmd CursorHold * silent call CocActionAsync('highlight')
"}}}
