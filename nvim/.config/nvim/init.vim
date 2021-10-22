source ~/.vimrc

lua << EOF

require('my_telescope')
require('my_diffview')
require('my_indent-blackline')
require('my_todo-comments')
require('my_Comment')
require('my_nvim-colorizer')
require('my_lualine')
require('my_alpha-nvim')
require('my_nvim-tree')
require('my_nvim-treesitter')

require('lsp')

EOF
