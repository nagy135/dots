source ~/.vimrc

lua << EOF

require('impatient')

require('my_telescope')
require('my_indent-blackline')
require('my_todo-comments')
require('my_Comment')
require('my_nvim-colorizer')
require('my_lualine')
require('my_alpha-nvim')
require('my_nvim-tree')
require('my_nvim-treesitter')
require('my_gitsigns')
require('my_nvim-cmp')
require('my_refactoring')
require('my_capture')
require('my_luasnip')
require('my_fidget')
require('my_diffview')
require('my_neogit')

require('lsp')

EOF
