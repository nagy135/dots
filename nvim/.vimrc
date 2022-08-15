" ██╗   ██╗██╗███╗   ███╗██████╗  ██████╗
" ██║   ██║██║████╗ ████║██╔══██╗██╔════╝
" ██║   ██║██║██╔████╔██║██████╔╝██║
" ╚██╗ ██╔╝██║██║╚██╔╝██║██╔══██╗██║
"  ╚████╔╝ ██║██║ ╚═╝ ██║██║  ██║╚██████╗
"   ╚═══╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝

" SETTINGS {{{

syntax on
filetype indent on
set updatetime=300
set foldmethod=marker
set foldlevel=3
set tabstop=4
set expandtab
set shiftwidth=4
set relativenumber
set sts=4
set ts=4
set autoindent
set path+=**
set mouse=
set wildmenu
set showcmd
set showmatch
set incsearch
set hlsearch
set number
set numberwidth=3
set noshowmode
set listchars=tab:▸\ ,eol:¬
set list
set maxfuncdepth=1000
set undofile
set undodir=~/.vim/undodir
set conceallevel=0
set splitbelow
set splitright
set inccommand=split
set wildoptions=pum
set pumblend=15 "wildmenu transparency (15%)
set termguicolors

set laststatus=3
" set winbar=%=%m\ %f

" space as leader key
let mapleader = " "

"}}}

" MAPPINGS {{{

nnoremap H ^
nnoremap L $
nnoremap <silent> <C-b>              :Neotree reveal toggle<CR>
nnoremap <silent> ;ft                :Neotree reveal toggle<CR>
nnoremap <silent> <leader>e          :Neotree reveal toggle<CR>
nnoremap <silent> <leader><leader>e  :Neotree reveal toggle buffers<CR>
nnoremap <silent> <leader>le         :Neotree reveal toggle right git_status<CR>
nnoremap <silent> <leader><leader>le :Neotree reveal toggle float git_status<CR>
nnoremap <c-s> :source ~/.vimrc<CR>
nnoremap <c-c> :e ~/.vimrc<CR>
nnoremap M :call SurroundFunctionUnderCursor()<CR>
nnoremap <leader><leader>df :call DeleteFunctionUnderCursor()<CR>
nnoremap <c-h> :nohl<CR>
nnoremap <c-l> :GFiles?<CR>
nnoremap ,html :-1read ~/.vim/snippets/html_template.html<CR>jjjf>a
map <F8> :call AutoScroll()<CR>
nnoremap <F4> :CtrlPClearAllCaches<CR>
nnoremap <F1> :let @+ = expand("%:p")<CR>
nnoremap <F2> :let @+ = expand("%:f")<CR>
vnoremap // y/\V<C-r>=escape(@",'/\')<CR><CR>
nnoremap ;g :Goyo<CR>
nnoremap <F3> :set spell!<CR>
tnoremap <Esc> <C-\><C-n>
nnoremap <F4> :call ZathuraOpen()<CR>
inoremap <c-b> <c-o>diw

" highlights all occurances of word under cursor, leaving cursor where found,
" centering screen
nnoremap <c-8> m8*`8zz

nnoremap <leader>dd <cmd>Neotree diagnostics reveal bottom<CR>

nnoremap <leader>uu <cmd>UndotreeToggle<CR>

nnoremap <leader>x :wq<CR>

nnoremap <leader><c-w>v :botright vsplit<CR>
nnoremap <leader><c-w>s :botright split<CR>

nnoremap <leader>X :lua capture_module.create_todo()<CR>
nnoremap <leader>J :lua capture_module.jump_to_file_with_column()<CR>

nnoremap <leader>ps :PresentingStart<CR>

" bangs!
" nnoremap <c-k> :! ./run.sh<CR>
" vnoremap ;b :w !bash<CR>
" nnoremap ;p :!prettier -w %<CR>

" quickfix movement
nnoremap <C-j> :cn<CR>
nnoremap <C-k> :cp<CR>
nnoremap <C-c> :cclose<CR>

" locationlist movement
nnoremap <C-n> <C-y><CR>
nnoremap <C-p> <C-e><CR>

" move tabs
nnoremap <leader><leader>l :tabm+<CR>
nnoremap <leader><leader>h :tabm-<CR>

nnoremap <leader>r :LspRestart<CR>

" zoom
nnoremap <Leader>zz :tabnew %<CR>
nnoremap <Leader>zc :tabclose<CR>

" Zen Mode (goyo)
nnoremap <Leader>zm :ZenMode<CR>

" }}}

" Todo Comments
nnoremap <leader>tt :TodoTelescope<CR>
nnoremap <leader>tq :TodoQuickFix<CR>
nnoremap <leader>tl :TodoLocList<CR>

" Git
nnoremap <leader>gg :Neogit<CR>
nnoremap <leader>gs :G<CR>
nnoremap <leader>gp :Git push<CR>
nnoremap <leader>gc :Git commit<CR>
nnoremap <leader>gb :Git blame<CR>
nnoremap <leader>gP :Git pull<CR>

" Visual select move
vnoremap > >gv
vnoremap < <gv

" Prettier
nnoremap <leader>\ :Prettier<CR>
nnoremap <leader>lp :! yarn pretty-quick<CR>

" Primeagen 5 tips
nnoremap Y y$

nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap J mzJ`z

inoremap , ,<c-g>u
inoremap . .<c-g>u
inoremap ! !<c-g>u
inoremap ? ?<c-g>u

nnoremap <expr> k (v:count > 5 ? "m'" . v:count : "") . 'k'
nnoremap <expr> j (v:count > 5 ? "m'" . v:count : "") . 'j'

vnoremap <leader>j :m '>+1<CR>gv=gv
vnoremap <leader>k :m '<-2<CR>gv=gv
" inoremap <C-j> <esc>:m .+1<CR>==
" inoremap <C-k> <esc>:m .-2<CR>==
" nnoremap <leader>j :m .+1<CR>==
" nnoremap <leader>k :m .-2<CR>==

" wiki extra binds
nnoremap <leader>wp :WikiFzfPages<CR>

" Comment above function or class with author
" nnoremap ;c O/**<CR><CR><CR>@author Viktor Nagy <viktor.nagy@01people.com><CR>/<ESC>kkka<SPACE>
vnoremap ;yy :lua copy_with_difference(true)<CR>
nnoremap ;p :lua copy_with_difference(false)<CR>
vnoremap ;tt :lua tabulize()<CR>


" ABBREV {{{
cnoreabbrev W w
cnoreabbrev Q q
cnoreabbrev WQ wq
cnoreabbrev Wq wq
"}}}

"}}}

" AUTOCOMMANDS {{{
autocmd BufNewFile,BufRead *.wiki set filetype=markdown

" Highlight git merge conflict markers with red background
au VimEnter,WinEnter * if !exists('w:_vsc_conflict_marker_match') |
        \   let w:_vsc_conflict_marker_match = matchadd('ErrorMsg', '^\(<\|=\||\|>\)\{7\}\([^=].\+\)\?$') |
        \ endif
au VimEnter,WinEnter * if !exists('w:_empty_lines_highlight') |
        \   let w:_empty_lines_highlight = matchadd('WarningMsg', '^\s*$') |
        \ endif


autocmd FileType javascript setlocal ts=2 sts=2 sw=2
autocmd FileType typescript setlocal ts=2 sts=2 sw=2
autocmd FileType typescriptreact setlocal ts=2 sts=2 sw=2

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

function! SurroundFunctionUnderCursor()
    let line = getline('.')
    set iskeyword+=.
    normal! ml
    set iskeyword-=.
    let i = 1
    let c = 0
    let start = 0
    while i <= strlen(line)
        let char = getline('.')[col('.') - 1]
        if (char == '(')
            let start = 1
            let c += 1
        elseif (char == ')')
            let c -= 1
        endif
        if (start == 1)
            if (c == 0)
                normal! a)
                normal! `l
                break
            endif
        endif
        normal! l
        let i += 1
    endwhile
    normal i(
    startinsert
endfunc

" Scrolling for tabs {{{
function! AutoScroll()
    call AutoScrollRecurse()
endfunction

function! AutoScrollRecurse()
    normal! j
    redraw
    sleep 600m
    call AutoScrollRecurse()
endfunction
"}}}

" Opens pdf with zathura
function! ZathuraOpen()
    let path = expand('%:p')
    let arr = split( path, '\.')
    let pdf = arr[0] . '.pdf'
    execute "silent !zathura " . pdf . " &"
endfunc

"}}}

" PLUG {{{
call plug#begin('~/.vim/plugged')
    Plug 'mbbill/undotree'
    Plug 'sainnhe/gruvbox-material'
    Plug 'luisiacc/gruvbox-baby'
    Plug 'ziglang/zig.vim'
    Plug 'lervag/wiki.vim'
    Plug 'joshdick/onedark.vim'
    Plug 'noahfrederick/vim-laravel'
    Plug 'rust-lang/rust.vim'
    Plug 'kylechui/nvim-surround'
    " Plug 'tpope/vim-fugitive'
    Plug 'numToStr/Comment.nvim'
    Plug 'tpope/vim-eunuch'
    Plug 'majutsushi/tagbar'
    Plug 'tpope/vim-markdown'
    Plug 'tpope/vim-abolish'
    Plug 'mattn/emmet-vim'
    " Plug 'rstacruz/vim-closer'
    " Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    " Plug 'junegunn/fzf.vim'

    " Plug 'LandonSchropp/vim-stamp'
    " Plug 'vim-airline/vim-airline-themes'
    " Plug 'itchyny/lightline.vim'
    " Plug 'vim-airline/vim-airline'
    " Plug 'mhinz/vim-startify'
    Plug 'goolord/alpha-nvim'
    Plug 'jwalton512/vim-blade'
    Plug 'tpope/vim-repeat'
    Plug 'leafgarland/typescript-vim' " fixes typescript highlight issues
    Plug 'folke/zen-mode.nvim'
    Plug 'HerringtonDarkholme/yats.vim'
    Plug 'neoclide/vim-jsx-improve'
    Plug 'MaxMEllon/vim-jsx-pretty'
    Plug 'christianchiarulli/nvcode-color-schemes.vim'
    " Plug 'hrsh7th/vim-vsnip'
    " Plug 'hrsh7th/vim-vsnip-integ'
    Plug 'zah/nim.vim'

    if has('nvim')
        " Plug 'neovim/nvim-lsp'
        Plug 'nvim-lualine/lualine.nvim'
        Plug 'kyazdani42/nvim-web-devicons'
        Plug 'lukas-reineke/indent-blankline.nvim'
        Plug 'sudormrfbin/cheatsheet.nvim'
        Plug 'nvim-lua/popup.nvim'
        Plug 'nvim-lua/plenary.nvim'
        Plug 'nvim-telescope/telescope.nvim'
        Plug 'nvim-telescope/telescope-fzy-native.nvim'
        Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }
        Plug 'nagy135/capture-nvim'
        Plug 'neovim/nvim-lspconfig'
        Plug 'folke/todo-comments.nvim'
        Plug 'kyazdani42/nvim-tree.lua'
        Plug 'phaazon/hop.nvim'
        Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
        Plug 'olimorris/onedarkpro.nvim'
        Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
        Plug 'lewis6991/gitsigns.nvim'
        Plug 'hrsh7th/cmp-nvim-lsp'
        Plug 'hrsh7th/cmp-buffer'
        Plug 'hrsh7th/cmp-path'
        Plug 'hrsh7th/nvim-cmp'
        Plug 'onsails/lspkind-nvim'
        Plug 'folke/lua-dev.nvim'
        Plug 'ThePrimeagen/harpoon'
        Plug 'ThePrimeagen/refactoring.nvim'
        Plug 'lewis6991/impatient.nvim'
        Plug 'nagy135/typebreak.nvim'
        Plug 'MunifTanjim/nui.nvim'
        Plug 'mrbjarksen/neo-tree-diagnostics.nvim'
        Plug 'L3MON4D3/LuaSnip'
        Plug 'saadparwaiz1/cmp_luasnip'
        Plug 'j-hui/fidget.nvim'
        Plug 'sindrets/diffview.nvim'
        Plug 'TimUntersberger/neogit'
        Plug 'nanotee/luv-vimdocs'
        Plug 'milisims/nvim-luaref'
        Plug 'nvim-telescope/telescope-file-browser.nvim'
        Plug 'williamboman/nvim-lsp-installer'
        Plug 'jose-elias-alvarez/null-ls.nvim'
        Plug 'MunifTanjim/prettier.nvim'
        Plug 'nvim-neo-tree/neo-tree.nvim'
        Plug 'ggandor/lightspeed.nvim'
        Plug 'nvim-telescope/telescope-ui-select.nvim'
        Plug 's1n7ax/nvim-window-picker'
        Plug 'NTBBloodbath/rest.nvim'
        Plug 'sotte/presenting.vim'
        Plug 'linty-org/key-menu.nvim'
        Plug 'mfussenegger/nvim-dap'
        Plug 'ziontee113/color-picker.nvim'
        Plug 'b0o/incline.nvim'
        Plug 'p00f/nvim-ts-rainbow'
    endif
call plug#end()

"}}}

" CONFIGURATION {{{

let g:markdown_folding = 0

let g:xml_syntax_folding=1

let g:wiki_root = '~/wiki'

let g:rustfmt_autosave = 1

let g:vim_json_syntax_conceal = 0

let g:goyo_width = 131
let g:goyo_height = 102

let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit' }
let g:fzf_buffers_jump = 1

let g:project_root_todo = 0
let g:todo_file_location = ""

let g:presenting_font_large = "ansiishadow"
let g:presenting_font_small = "standard"
