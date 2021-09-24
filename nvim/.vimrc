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
nnoremap ,b   :Tagbar<CR>
nnoremap <c-s> :source ~/.vimrc<CR>
" nnoremap <c-s> :w<CR>
nnoremap <c-c> :e ~/.vimrc<CR>
nnoremap <c-n> :call DeleteFunctionUnderCursor()<CR>
nnoremap <c-h> :nohl<CR>
nnoremap <c-k> :! ./run.sh<CR>
nnoremap <c-l> :GFiles?<CR>
nnoremap ,html :-1read ~/.vim/snippets/html_template.html<CR>jjjf>a
map <F8> :call AutoScroll()<CR>
nnoremap <F4> :CtrlPClearAllCaches<CR>
nnoremap <F1> :let @+ = expand("%:p")<CR>
vnoremap // y/\V<C-r>=escape(@",'/\')<CR><CR>
nnoremap ;b :.w !bash<CR>
vnoremap ;b :w !bash<CR>
nnoremap ;g :Goyo<CR>
nnoremap <F3> :set spell!<CR>
tnoremap <Esc> <C-\><C-n>
nnoremap <F4> :call ZathuraOpen()<CR>

nnoremap <leader>x :wq<CR>
nnoremap <leader>qq :q!<CR>

" quickfix movement
nnoremap <C-j> :cn<CR>
nnoremap <C-k> :cp<CR>

" locationlist movement
nnoremap <C-n> :lnext<CR>
nnoremap <C-p> :lprev<CR>

" move tabs
nnoremap <leader><leader>l :tabm+<CR>
nnoremap <leader><leader>h :tabm-<CR>

" Telescope {{{

" general {{{
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <c-f> <cmd>lua require('telescope.builtin').find_files()<cr>
" neighbors
nnoremap <leader>fn <cmd>lua require("telescope.builtin").find_files({cwd = "%:h"})<cr>

nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <c-g> <cmd>lua require('telescope.builtin').live_grep()<cr>

nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <c-e> <cmd>lua require('telescope.builtin').buffers()<cr>

nnoremap <leader>fs <cmd>lua require('telescope.builtin').grep_string()<cr>

nnoremap <leader>fc <cmd>lua require('telescope.builtin').command_history()<cr>

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
nnoremap <leader>hb <cmd>lua require('telescope.builtin').keymaps()<cr>
nnoremap <leader>hm <cmd>lua require('telescope.builtin').keymaps()<cr>
" }}}
"
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
nnoremap <leader>gg :G<CR>
nnoremap <leader>gs :G<CR>
nnoremap <leader>gp :Git push<CR>
nnoremap <leader>gc :Git commit<CR>
nnoremap <leader>gb :Git blame<CR>
nnoremap <leader>gP :Git pull<CR>

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

vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
inoremap <C-j> <esc>:m .+1<CR>==
inoremap <C-k> <esc>:m .-2<CR>==
nnoremap <leader>j :m .+1<CR>==
nnoremap <leader>k :m .-2<CR>==

" wiki extra binds
nnoremap <leader>wp :WikiFzfPages<CR>

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
    Plug 'sainnhe/gruvbox-material'
    Plug 'ziglang/zig.vim'
    Plug 'lervag/wiki.vim'
    Plug 'joshdick/onedark.vim'
    Plug 'noahfrederick/vim-laravel'
    Plug 'airblade/vim-gitgutter'
    Plug 'rust-lang/rust.vim'
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-fugitive'
    Plug 'terrortylor/nvim-comment'
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
    Plug 'junegunn/goyo.vim'
    Plug 'HerringtonDarkholme/yats.vim'
    Plug 'neoclide/vim-jsx-improve'
    Plug 'MaxMEllon/vim-jsx-pretty'
    Plug 'christianchiarulli/nvcode-color-schemes.vim'
    Plug 'kkoomen/vim-doge', { 'do': { -> doge#install() } }

    if has('nvim')
        " Plug 'neovim/nvim-lsp'
        Plug 'hoob3rt/lualine.nvim'
        Plug 'kyazdani42/nvim-web-devicons'
        Plug 'lukas-reineke/indent-blankline.nvim'
        Plug 'sudormrfbin/cheatsheet.nvim'
        Plug 'nvim-lua/popup.nvim'
        Plug 'nvim-lua/plenary.nvim'
        Plug 'nvim-telescope/telescope.nvim'
        Plug 'nvim-telescope/telescope-fzy-native.nvim'
        Plug 'sindrets/diffview.nvim'
        Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }
        Plug 'nagy135/capture-nvim'
        Plug 'neovim/nvim-lspconfig'
        Plug 'hrsh7th/nvim-compe'
        Plug 'folke/todo-comments.nvim'
        Plug 'norcalli/nvim-colorizer.lua'
        Plug 'kyazdani42/nvim-tree.lua'
        Plug 'phaazon/hop.nvim'
        Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
        " Plug 'nvim-treesitter/playground'
    endif
call plug#end()

"}}}

" CONFIGURATION {{{

" nvim-tree {{{
let g:nvim_tree_side = 'right' "left by default
let g:nvim_tree_width = 40 "30 by default, can be width_in_columns or 'width_in_percent%'
let g:nvim_tree_ignore = [ '.git', 'node_modules', '.cache' ] "empty by default
let g:nvim_tree_gitignore = 1 "0 by default
let g:nvim_tree_auto_open = 1 "0 by default, opens the tree when typing `vim $DIR` or `vim`
let g:nvim_tree_auto_close = 1 "0 by default, closes the tree when it's the last window
let g:nvim_tree_auto_ignore_ft = [ 'startify', 'dashboard' ] "empty by default, don't auto open tree on specific filetypes.
let g:nvim_tree_quit_on_open = 0 "0 by default, closes the tree when you open a file
let g:nvim_tree_follow = 1 "0 by default, this option allows the cursor to be updated when entering a buffer
let g:nvim_tree_follow_update_path = 1 "0 by default, will update the path of the current dir if the file is not inside the tree.
let g:nvim_tree_indent_markers = 1 "0 by default, this option shows indent markers when folders are open
let g:nvim_tree_hide_dotfiles = 1 "0 by default, this option hides files and folders starting with a dot `.`
let g:nvim_tree_git_hl = 1 "0 by default, will enable file highlight for git attributes (can be used without the icons).
let g:nvim_tree_highlight_opened_files = 1 "0 by default, will enable folder and file icon highlight for opened files/directories.
let g:nvim_tree_root_folder_modifier = ':~' "This is the default. See :help filename-modifiers for more options
let g:nvim_tree_tab_open = 1 "0 by default, will open the tree when entering a new tab and the tree was previously open
let g:nvim_tree_auto_resize = 0 "1 by default, will resize the tree to its saved width when opening a file
let g:nvim_tree_disable_netrw = 0 "1 by default, disables netrw
let g:nvim_tree_hijack_netrw = 0 "1 by default, prevents netrw from automatically opening when opening directories (but lets you keep its other utilities)
let g:nvim_tree_add_trailing = 1 "0 by default, append a trailing slash to folder names
let g:nvim_tree_group_empty = 1 " 0 by default, compact folders that only contain a single folder into one node in the file tree
let g:nvim_tree_lsp_diagnostics = 1 "0 by default, will show lsp diagnostics in the signcolumn. See :help nvim_tree_lsp_diagnostics
let g:nvim_tree_disable_window_picker = 1 "0 by default, will disable the window picker.
let g:nvim_tree_hijack_cursor = 0 "1 by default, when moving cursor in the tree, will position the cursor at the start of the file on the current line
let g:nvim_tree_icon_padding = ' ' "one space by default, used for rendering the space between the icon and the filename. Use with caution, it could break rendering if you set an empty string depending on your font.
let g:nvim_tree_symlink_arrow = ' >> ' " defaults to ' ➛ '. used as a separator between symlinks' source and target.
let g:nvim_tree_update_cwd = 1 "0 by default, will update the tree cwd when changing nvim's directory (DirChanged event). Behaves strangely with autochdir set.
let g:nvim_tree_respect_buf_cwd = 1 "0 by default, will change cwd of nvim-tree to that of new buffer's when opening nvim-tree.
let g:nvim_tree_refresh_wait = 500 "1000 by default, control how often the tree can be refr
" }}}

let g:markdown_folding = 0

if !exists('g:jellybeans_overrides')
    let g:jellybeans_overrides = {
    \    'background': { 'guibg': '123123' },
    \}
endif

let g:xml_syntax_folding=1

let g:wiki_root = '~/wiki'

let g:rustfmt_autosave = 1

let g:lightline = {
      \ 'colorscheme': 'onedark',
      \ }

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
" }}}

" LSP {{{
" LSP config (the mappings used in the default file don't quite work right)
nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gD <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> gr <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> gi <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> K <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gK <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> g[ <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
nnoremap <silent> g] <cmd>lua vim.lsp.diagnostic.goto_next()<CR>
" }}}

" Colorscheme
colorscheme gruvbox-material
"}}}
