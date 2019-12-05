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
set wildoptions=pum
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

let mapleader = " "

"Mappings {{{
nnoremap H ^
nnoremap L $
nnoremap <C-b> :NERDTreeToggle<CR>
nnoremap ;ft   :NERDTreeFind<CR>
" nnoremap <c-s> :source ~/.vimrc<CR>
nnoremap <c-s> :w<CR>
nnoremap <c-c> :e ~/.vimrc<CR>
nnoremap <c-n> :call DeleteFunctionUnderCursor()<CR>
nnoremap <c-h> :nohl<CR>
nnoremap <c-k> :ColorToggle<CR>
nnoremap <c-f> :Tagbar<CR>
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
nnoremap <C-p> :Ctrlp<CR>
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
"Rust
autocmd FileType rust nnoremap <c-j> :w<CR>:!cargo run<CR>
autocmd FileType rust nnoremap ;p oprintln!()<ESC>i
autocmd FileType rust nnoremap ;P Oprintln!()<ESC>i
autocmd FileType rust nnoremap ;;p yiwoprintln!("", )<ESC>PF"P^
autocmd FileType rust nnoremap ;;P yiwOprintln!("", )<ESC>PF"P^
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

let g:xml_syntax_folding=1
au FileType xml setlocal foldmethod=syntax

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

let g:markdown_folding = 1


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

" Relative django jumps {{{
let g:last_relative_dir = ''
nnoremap \1 :call RelatedFile ("models.py")<cr>
nnoremap \2 :call RelatedFile ("views.py")<cr>
nnoremap \3 :call RelatedFile ("urls.py")<cr>
nnoremap \4 :call RelatedFile ("admin.py")<cr>
nnoremap \5 :call RelatedFile ("tests.py")<cr>
nnoremap \6 :call RelatedFile ( "templates/" )<cr>
nnoremap \7 :call RelatedFile ( "templatetags/" )<cr>
nnoremap \8 :call RelatedFile ( "management/" )<cr>
nnoremap \0 :e settings.py<cr>
nnoremap \9 :e urls.py<cr>

fun! RelatedFile(file)
    if filereadable(expand("%:h"). '/models.py') || isdirectory(expand("%:h") . "/templatetags/")
        exec "edit %:h/" . a:file
        let g:last_relative_dir = expand("%:h") . '/'
        return ''
    endif
    if g:last_relative_dir != ''
        exec "edit " . g:last_relative_dir . a:file
        return ''
    endif
    echo "Cant determine where relative file is : " . a:file
    return ''
endfun

fun SetAppDir()
    if filereadable(expand("%:h"). '/models.py') || isdirectory(expand("%:h") . "/templatetags/")
        let g:last_relative_dir = expand("%:h") . '/'
        return ''
    endif
endfun
autocmd BufEnter *.py call SetAppDir()
" }}}

" Plug {{{
call plug#begin('~/.vim/plugged')
    Plug 'rust-lang/rust.vim'
    Plug 'vimwiki/vimwiki'
    Plug 'vim-airline/vim-airline'
    Plug 'nathanaelkane/vim-indent-guides'
    Plug 'scrooloose/nerdtree'
    Plug 'ervandew/supertab'
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-commentary'
    Plug 'tpope/vim-eunuch'
    Plug 'majutsushi/tagbar'
    Plug 'raviqqe/vim-nonblank'
    Plug 'tpope/vim-markdown'
    Plug 'chrisbra/Colorizer'
    Plug 'mattn/emmet-vim'
    Plug 'rstacruz/vim-closer'
    Plug 'kien/ctrlp.vim'
    " Plug 'junegunn/fzf.vim'
    Plug 'LandonSchropp/vim-stamp'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'mhinz/vim-startify'
    " Plug 'ycm-core/YouCompleteMe'
    Plug 'junegunn/goyo.vim'
    if has('nvim')
        " Plug 'neovim/nvim-lsp'
    endif
call plug#end()
"}}}

" let g:LanguageClient_serverCommands = {
"     \ 'sh': ['bash-language-server', 'start']
"     \ }

" let settings = {
"           \   "pyls" : {
"           \     "enable" : v:true,
"           \     "trace" : { "server" : "verbose", },
"           \     "commandPath" : "",
"           \     "configurationSources" : [ "pycodestyle" ],
"           \     "plugins" : {
"           \       "jedi_completion" : { "enabled" : v:true, },
"           \       "jedi_hover" : { "enabled" : v:true, },
"           \       "jedi_references" : { "enabled" : v:true, },
"           \       "jedi_signature_help" : { "enabled" : v:true, },
"           \       "jedi_symbols" : {
"           \         "enabled" : v:true,
"           \         "all_scopes" : v:true,
"           \       },
"           \       "mccabe" : {
"           \         "enabled" : v:true,
"           \         "threshold" : 15,
"           \       },
"           \       "preload" : { "enabled" : v:true, },
"           \       "pycodestyle" : { "enabled" : v:true, },
"           \       "pydocstyle" : {
"           \         "enabled" : v:false,
"           \         "match" : "(?!test_).*\\.py",
"           \         "matchDir" : "[^\\.].*",
"           \       },
"           \       "pyflakes" : { "enabled" : v:true, },
"           \       "rope_completion" : { "enabled" : v:true, },
"           \       "yapf" : { "enabled" : v:true, },
"           \     }}}
" call nvim_lsp#setup("pyls", settings)
" call nvim_lsp#setup("bashls", {})

" disable preview window
set completeopt-=preview

" use omni completion provided by lsp
set omnifunc=lsp#omnifunc

let g:ctrlp_match_window = 'min:4,max:999'
