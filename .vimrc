" ██╗   ██╗██╗███╗   ███╗██████╗  ██████╗
" ██║   ██║██║████╗ ████║██╔══██╗██╔════╝
" ██║   ██║██║██╔████╔██║██████╔╝██║
" ╚██╗ ██╔╝██║██║╚██╔╝██║██╔══██╗██║
"  ╚████╔╝ ██║██║ ╚═╝ ██║██║  ██║╚██████╗
"   ╚═══╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝

" Settings {{{
syntax on
filetype indent on
set updatetime=300
set foldmethod=marker
set tabstop=4
set expandtab
set shiftwidth=4
set relativenumber
set sts=4
set ts=4
set autoindent
set path+=**
set mouse=a
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
    set wildoptions=pum
endif
set maxfuncdepth=1000
set undofile
" set undodir=~/.vim/undodir
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
nnoremap ,b   :Tagbar<CR>
" nnoremap <c-s> :source ~/.vimrc<CR>
nnoremap <c-s> :w<CR>
nnoremap <c-c> :e ~/.vimrc<CR>
nnoremap <c-n> :call DeleteFunctionUnderCursor()<CR>
nnoremap <c-h> :nohl<CR>
nnoremap <c-k> :! ./run.sh<CR>
nnoremap <c-p> :GFiles<CR>
nnoremap <c-f> :Files<CR>
nnoremap <c-e> :Buffers<CR>
nnoremap <c-l> :GFiles?<CR>
nnoremap ,html :-1read ~/.vim/snippets/html_template.html<CR>jjjf>a
map <F8> :call AutoScroll()<CR>
nnoremap <F4> :CtrlPClearAllCaches<CR>
nnoremap <F1> :let @+ = expand("%:p")<CR>
vnoremap // y/\V<C-r>=escape(@",'/\')<CR><CR>
nnoremap ;b :.w !bash<CR>
vnoremap ;b :w !bash<CR>
nnoremap ;g :Goyo<CR>
nnoremap n nzz
nnoremap N Nzz
nnoremap <F3> :set spell!<CR>
" nnoremap <C-p> :Clap files<CR>
" nnoremap <C-m> :Ctrlp<CR>
" nnoremap <C-m> :BLines<CR>
nnoremap <c-g> :Rg<CR>
tnoremap <Esc> <C-\><C-n>
nnoremap <F4> :call ZathuraOpen()<CR>
nnoremap <leader>c :HexokinaseToggle<CR>

nnoremap <leader>x :wq<CR>
nnoremap <leader>qq :q!<CR>

" Using lua functions
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>

nnoremap <leader>gg :G<CR>
nnoremap <leader>gs :G<CR>
nnoremap <leader>gp :Git push<CR>
nnoremap <leader>gc :Git commit<CR>
nnoremap <leader>gP :Git pull<CR>
"}}}

" AutoCommands {{{
" autocmd CursorHold * silent call CocActionAsync('highlight')
autocmd! FileType fzf tnoremap <buffer> <esc> <c-c>
"MatLab
autocmd FileType matlab nnoremap gcc mlI%<space><esc>`lll
"LaTeX
autocmd FileType tex nnoremap <c-j> :w !pdflatex % &> /dev/null<CR>
"Rust
autocmd FileType rust nnoremap <c-j> :w<CR>:!cargo run<CR>
autocmd FileType rust nnoremap ;p oprintln!();<ESC>hi
autocmd FileType rust nnoremap ;P Oprintln!();<ESC>hi
autocmd FileType rust nnoremap ;;p yiwoprintln!("{}", );<ESC>hPF{Pa <ESC>
autocmd FileType rust nnoremap ;;P yiwOprintln!("{}", );<ESC>hPF{Pa <ESC>
autocmd FileType rust nnoremap <leader>r :botright split<CR>:term cargo run<CR>
autocmd FileType rust nnoremap <leader>t :botright split<CR>:term cargo test<CR>
autocmd FileType rust nnoremap <c-j> :w !cargo run<CR>:w<CR>
autocmd FileType rust nnoremap <leader><leader>t :CocCommand rust-analyzer.toggleInlayHints<CR>
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
"PHP
autocmd FileType php nnoremap <leader>e :w !perl<CR>
autocmd FileType php nnoremap <leader>r :botright split<CR>:term curl $(cat /tmp/nvim_curl 2> /dev/null) -o /tmp/nvim_response &> /dev/null && nvim /tmp/nvim_response<CR><CR>
autocmd FileType php nnoremap <leader>e :botright split<CR>:e /tmp/nvim_curl<CR>

autocmd FileType javascript nmap ;p oconsole.log(<ESC>lmiA;<ESC>`ii
autocmd FileType javascript nmap ;P Oconsole.log(<ESC>lmiA;<ESC>`ii
autocmd FileType javascript nnoremap ;;p yiwoconsole.log("", );<ESC>hPF"P<ESC>
autocmd FileType javascript nnoremap ;;P yiwOconsole.log("", );<ESC>hPF"P<ESC>

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
" colorscheme jellybeans
" colorscheme onedark
" }}}

let g:markdown_folding = 1

" Plugin setup {{{
if !exists('g:jellybeans_overrides')
    let g:jellybeans_overrides = {
    \    'background': { 'guibg': '123123' },
    \}
endif


let g:rustfmt_autosave = 1

let g:indent_guides_enable_on_vim_startup = 1
" let g:molokai_original = 1

" let g:airline_theme='jellybeans'

let g:lightline = {
      \ 'colorscheme': 'onedark',
      \ }

let g:indentLine_char = '|'

let g:vim_json_syntax_conceal = 0

let g:goyo_width = 131
let g:goyo_height = 102

let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit' }
let g:fzf_buffers_jump = 1

" {{{ fzf floating setup
" Using floating windows of Neovim to start fzf
if has('nvim')
  function! FloatingFZF(width, height, border_highlight)
    function! s:create_float(hl, opts)
      let buf = nvim_create_buf(v:false, v:true)
      let opts = extend({'relative': 'editor', 'style': 'minimal'}, a:opts)
      let win = nvim_open_win(buf, v:true, opts)
      call setwinvar(win, '&winhighlight', 'NormalFloat:'.a:hl)
      call setwinvar(win, '&colorcolumn', '')
      return buf
    endfunction

    " Size and position
    let width = float2nr(&columns * a:width)
    let height = float2nr(&lines * a:height)
    let row = float2nr((&lines - height) / 2)
    let col = float2nr((&columns - width) / 2)

    " Border
    let top = '┌' . repeat('─', width - 2) . '┐'
    let mid = '│' . repeat(' ', width - 2) . '│'
    let bot = '└' . repeat('─', width - 2) . '┘'
    let border = [top] + repeat([mid], height - 2) + [bot]

    " Draw frame
    let s:frame = s:create_float(a:border_highlight, {'row': row, 'col': col, 'width': width, 'height': height})
    call nvim_buf_set_lines(s:frame, 0, -1, v:true, border)

    " Draw viewport
    call s:create_float('Normal', {'row': row + 1, 'col': col + 2, 'width': width - 4, 'height': height - 2})
    autocmd BufWipeout <buffer> execute 'bwipeout' s:frame
  endfunction

  let g:fzf_layout = { 'window': 'call FloatingFZF(0.9, 0.6, "Comment")' }
endif
if has('nvim') && !exists('g:fzf_layout')
  autocmd! FileType fzf
  autocmd  FileType fzf set laststatus=0 noshowmode noruler
    \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
endif
" }}}

" Opens pdf with zathura
function! ZathuraOpen()
    let path = expand('%:p')
    let arr = split( path, '\.')
    let pdf = arr[0] . '.pdf'
    execute "silent !zathura " . pdf . " &"
endfunc
"}}}

" Powerline settings {{{
" air-line
let g:airline_powerline_fonts = 1

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" unicode symbols
let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace = 'Ξ'

" airline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ' '
" }}}

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

" COC setup {{{

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
" inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
"                               \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> gt :call CocAction('doHover')<CR>

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)


function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" }}}

" Plug {{{
call plug#begin('~/.vim/plugged')

    Plug 'RRethy/vim-hexokinase', { 'do': 'make hexokinase' }
    Plug 'joshdick/onedark.vim'
    Plug 'noahfrederick/vim-laravel'
    Plug 'airblade/vim-gitgutter'
    Plug 'rust-lang/rust.vim'
    Plug 'vimwiki/vimwiki'
    " Plug 'vim-airline/vim-airline'
    Plug 'nathanaelkane/vim-indent-guides'
    Plug 'scrooloose/nerdtree'
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-fugitive'
    Plug 'tpope/vim-commentary'
    Plug 'tpope/vim-eunuch'
    Plug 'majutsushi/tagbar'
    Plug 'tpope/vim-markdown'
    " Plug 'chrisbra/Colorizer'
    Plug 'ap/vim-css-color'
    Plug 'mattn/emmet-vim'
    Plug 'rstacruz/vim-closer'
    " Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    " Plug 'junegunn/fzf.vim'
    Plug 'nvim-lua/popup.nvim'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-telescope/telescope.nvim'
    Plug 'nvim-telescope/telescope-fzy-native.nvim'
    Plug 'LandonSchropp/vim-stamp'
    " Plug 'vim-airline/vim-airline-themes'
    Plug 'itchyny/lightline.vim'
    Plug 'mhinz/vim-startify'
    Plug 'jwalton512/vim-blade'
    Plug 'tpope/vim-repeat'
    " Plug 'ycm-core/YouCompleteMe'
    Plug 'junegunn/goyo.vim'
    if has('nvim')
        " Plug 'neovim/nvim-lsp'
        " Plug 'liuchengxu/vim-clap'
        Plug 'neoclide/coc.nvim', {'branch': 'release', 'for': ['python', 'rust', 'lisp', 'php', 'lua']}
        Plug 'sindrets/diffview.nvim'
        Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }
    endif
    Plug 'HerringtonDarkholme/yats.vim'
    " Plug 'neoclide/coc.nvim', {'branch': 'release'}
    " Plug 'neoclide/coc-tsserver'
    Plug 'neoclide/vim-jsx-improve'
    Plug 'MaxMEllon/vim-jsx-pretty'
    Plug 'christianchiarulli/nvcode-color-schemes.vim'

    Plug 'nagy135/capture-nvim'
    " Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    " Plug 'nvim-treesitter/playground'

    Plug 'kkoomen/vim-doge', { 'do': { -> doge#install() } }
    call plug#end()

    "}}}

    let g:project_root_todo = 0
    let g:todo_file_location = ""

    " {{{ Treesitter
    " lua <<EOF
    " require "nvim-treesitter.configs".setup {
    " "  playground = {
    " "    enable = true,
    " "    disable = {},
    " "    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
    " "    persist_queries = false -- Whether the query persists across vim sessions
    " "  }
    " "}
    " EOF
    " "
    " "
    " lua <<EOF
    " require'nvim-treesitter.configs'.setup {
    " "  highlight = {
    " "    enable = true,
    " "    custom_captures = {
    " "      -- Highlight the @foo.bar capture group with the "Identifier" highlight group.
    " "      ["foo.bar"] = "Identifier",
    " "    },
    " "  },
    " "}
    " EOF
    " "
    " lua <<EOF
    " require'nvim-treesitter.configs'.setup {
    " "  incremental_selection = {
    " "    enable = true,
    " "    keymaps = {
    " "      init_selection = "is",
    " "      node_incremental = "o",
    " "      scope_incremental = "grc",
    " "      node_decremental = "O",
    " "    },
    " "  },
    " "}
    " EOF
    " "
    " lua <<EOF
    " require'nvim-treesitter.configs'.setup {
    " "  indent = {
    " "    enable = true
    " "  }
    " "}
    " EOF
    " }}}

    colorscheme nvcode
