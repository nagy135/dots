vim.cmd [[ source ~/.vimrc ]]

require('plugins')

-- 
require('my_telescope')
require('my_indent-blackline')
require('my_todo-comments')
require('my_Comment')
require('my_nvim-colorizer')
-- require('my_nvim-highlight-colors')
require('my_lualine')
require('my_alpha-nvim')
-- require('my_nvim-tree')
require('my_nvim-treesitter')
require('my_gitsigns')
require('my_nvim-cmp')
require('my_refactoring')
require('my_capture')
require('my_luasnip')
require('my_fidget')
require('my_diffview')
require('my_neogit')
require('my_neotree')
require('my_nvim-window-selector')
require('my_color-picker')
require('my_incline')
require('my_nvim-surround')
require('binds')
require('my_lightspeed')
require('thief')
-- require('my_neorg')
require('my_lspsaga')
require('my_neozoom')

require('scripts')
require('autocommands')

require('lsp')

vim.cmd [[colorscheme gruvbox-material]]
