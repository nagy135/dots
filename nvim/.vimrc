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
" set cursorline
" set cursorcolumn
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
if has('nvim')
    set inccommand=split
    set wildoptions=pum
    set pumblend=15 "wildmenu transparency (15%)
    set termguicolors
endif

" space as leader key
let mapleader = " "

"}}}

" MAPPINGS {{{

nnoremap H ^
nnoremap L $
nnoremap <C-b> :NvimTreeToggle<CR>
nnoremap ;ft   :NvimTreeFindFile<CR>
nnoremap <leader>e   :NvimTreeFindFile<CR>
nnoremap <c-s> :source ~/.vimrc<CR>
nnoremap <c-c> :e ~/.vimrc<CR>
nnoremap M :call SurroundFunctionUnderCursor()<CR>
nnoremap <leader>m :call DeleteFunctionUnderCursor()<CR>
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

nnoremap <leader>dd <cmd>TroubleToggle<CR>

nnoremap <leader>uu <cmd>UndotreeToggle<CR>
nnoremap <leader>ut <cmd>UndotreeToggle<CR>

nnoremap <leader>x :wq<CR>
nnoremap <leader>qq :q!<CR>

nnoremap <leader><c-w>v :botright vsplit<CR>
nnoremap <leader><c-w>s :botright split<CR>

" bangs!
nnoremap <c-k> :! ./run.sh<CR>
vnoremap ;b :w !bash<CR>
nnoremap ;p :!prettier -w %<CR>

" quickfix movement
nnoremap <C-j> :cn<CR>
nnoremap <C-k> :cp<CR>
nnoremap <C-c> :cclose<CR>

" locationlist movement
nnoremap <C-n> :lnext<CR>
nnoremap <C-p> :lprev<CR>

" move tabs
nnoremap <leader><leader>l :tabm+<CR>
nnoremap <leader><leader>h :tabm-<CR>

nnoremap <leader>r :LspRestart<CR>

" Telescope {{{

" general {{{
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <c-f> <cmd>lua require('telescope.builtin').find_files()<cr>
" neighbors
nnoremap <leader>fn <cmd>lua require("telescope.builtin").find_files({cwd = "%:h"})<cr>

nnoremap <leader>fd <cmd>lua require("telescope.builtin").find_files{ cwd = "~/.config", follow = true, hidden = true }<CR>

nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <c-g> <cmd>lua require('telescope.builtin').live_grep()<cr>

nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_ivy({}))<cr>
nnoremap <c-e> <cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_ivy({}))<cr>

nnoremap <leader>fs <cmd>lua require('telescope.builtin').grep_string()<cr>

nnoremap <leader>fc <cmd>lua require('telescope.builtin').command_history()<cr>

nnoremap <leader>fo <cmd>lua require('telescope.builtin').oldfiles()<cr>

nnoremap <leader>fl <cmd>lua require('telescope.builtin').git_status()<cr>
nnoremap <leader>fL <cmd>lua require('telescope.builtin').git_commits()<cr>

nnoremap <leader>gd <cmd>lua require('telescope.builtin').lsp_definitions()<cr>
nnoremap <leader>gr <cmd>lua require('telescope.builtin').lsp_references()<cr>

nnoremap <leader>gi <cmd>lua require('telescope.builtin').lsp_implementations()<cr>
nnoremap <leader>cA <cmd>lua require("telescope.builtin").lsp_code_actions(require('telescope.themes').get_cursor({}))<cr>
nnoremap <leader>gD <cmd>lua require('telescope.builtin').lsp_type_definitions()<cr>

nnoremap <leader>fe <cmd>lua require('telescope').extensions.file_browser.file_browser()<cr>

" My telescope
nnoremap <leader>fp <cmd>lua require('my_telescope').project_find_file("~/Clones")<cr>
nnoremap <leader>fa <cmd>lua require('my_telescope').project_find_file("~/Apps")<cr>

" }}}

" swiper
nnoremap <leader>ss <cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<cr>
nnoremap <leader>sl <cmd>HopLineStart<cr>
nnoremap <leader>sw <cmd>HopWord<cr>
nnoremap <leader>s1 <cmd>HopChar1<cr>
nnoremap <leader>s2 <cmd>HopChar2<cr>

" helps {{{
nnoremap <leader>hh <cmd>lua require('telescope.builtin').help_tags()<cr>
nnoremap <leader>hf <cmd>lua require('telescope.builtin').commands()<cr>
nnoremap <leader>hm <cmd>lua require('telescope.builtin').keymaps()<cr>
" }}}
"
" }}}

" Harpoon {{{

nnoremap <leader>ma :lua require('harpoon.mark').add_file()<CR>
nnoremap <leader>mm :lua require('harpoon.ui').toggle_quick_menu()<CR>
lua << EOF
-- jumps to specified index in Harpoon window
function harpoonIndexJump()
    local index = vim.fn.input("Harpoon: ")
    if index == nil or index == '' then
        return
    end
    require('harpoon.ui').nav_file(tonumber(index))
end
EOF
nnoremap <leader>mi :lua DeleteFunctionUnderCursor()<CR>
nnoremap <leader>mi :lua harpoonIndexJump()<CR>
nnoremap <A-1> :lua require('harpoon.ui').nav_file(1)<CR>
nnoremap <A-2> :lua require('harpoon.ui').nav_file(2)<CR>
nnoremap <A-3> :lua require('harpoon.ui').nav_file(3)<CR>
nnoremap <A-4> :lua require('harpoon.ui').nav_file(4)<CR>
nnoremap <A-5> :lua require('harpoon.ui').nav_file(5)<CR>
nnoremap <A-6> :lua require('harpoon.ui').nav_file(6)<CR>
nnoremap <A-7> :lua require('harpoon.ui').nav_file(7)<CR>
nnoremap <A-8> :lua require('harpoon.ui').nav_file(8)<CR>
nnoremap <A-9> :lua require('harpoon.ui').nav_file(9)<CR>
nnoremap <A-0> :lua require('harpoon.ui').nav_file(10)<CR>
" }}}
" Todo Comments
nnoremap <leader>tt :TodoTelescope<CR>
nnoremap <leader>tq :TodoQuickFix<CR>
nnoremap <leader>tl :TodoLocList<CR>

" nvim-colorizer.lua binds
nnoremap <leader>cc :ColorizerToggle<CR>
" nnoremap <leader>ca :ColorizerAttachToBuffer<CR>
" nnoremap <leader>cd :ColorizerDetachFromBuffer<CR>

" Git
nnoremap <leader>gg :Neogit<CR>
nnoremap <leader>gs :G<CR>
nnoremap <leader>gp :Git push<CR>
nnoremap <leader>gc :Git commit<CR>
nnoremap <leader>gb :Git blame<CR>
nnoremap <leader>gP :Git pull<CR>

" Diffview
nnoremap <leader>dw :DiffviewOpen<CR>

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
nnoremap ;c O/**<CR><CR><CR>@author Viktor Nagy <viktor.nagy@01people.com><CR>/<ESC>kkka<SPACE>


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
    Plug 'ziglang/zig.vim'
    Plug 'lervag/wiki.vim'
    Plug 'joshdick/onedark.vim'
    Plug 'noahfrederick/vim-laravel'
    Plug 'rust-lang/rust.vim'
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-fugitive'
    Plug 'numToStr/Comment.nvim'
    Plug 'tpope/vim-eunuch'
    Plug 'majutsushi/tagbar'
    Plug 'tpope/vim-markdown'
    Plug 'tpope/vim-abolish'
    Plug 'mattn/emmet-vim'
    Plug 'rstacruz/vim-closer'
    " Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    " Plug 'junegunn/fzf.vim'

    Plug 'LandonSchropp/vim-stamp'
    " Plug 'vim-airline/vim-airline-themes'
    " Plug 'itchyny/lightline.vim'
    " Plug 'vim-airline/vim-airline'
    " Plug 'mhinz/vim-startify'
    Plug 'goolord/alpha-nvim'
    Plug 'jwalton512/vim-blade'
    Plug 'tpope/vim-repeat'
    Plug 'leafgarland/typescript-vim' " fixes typescript highlight issues
    Plug 'junegunn/goyo.vim'
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
        Plug 'hrsh7th/nvim-compe'
        Plug 'folke/todo-comments.nvim'
        Plug 'norcalli/nvim-colorizer.lua'
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
        Plug 'folke/trouble.nvim'
        Plug 'ThePrimeagen/harpoon'
        Plug 'ThePrimeagen/refactoring.nvim'
        Plug 'lewis6991/impatient.nvim'
        Plug 'nagy135/typebreak.nvim'
        Plug 'MunifTanjim/nui.nvim'
        Plug 'p00f/nvim-ts-rainbow'
        Plug 'L3MON4D3/LuaSnip'
        Plug 'saadparwaiz1/cmp_luasnip'
        Plug 'j-hui/fidget.nvim'
        Plug 'sindrets/diffview.nvim'
        Plug 'TimUntersberger/neogit'
        Plug 'nanotee/luv-vimdocs'
        Plug 'milisims/nvim-luaref'
        Plug 'nvim-telescope/telescope-file-browser.nvim'
        " Plug 'nvim-treesitter/playground'
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

" Colorscheme
colorscheme gruvbox-material
"}}}
