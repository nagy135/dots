source ~/.vimrc

lua << EOF

require('my_telescope')
require('my_diffview')
require('my_indent-blackline')
require('my_todo-comments')
require('my_nvim-comment')
require('my_nvim-colorizer')
require('my_lualine')

require('lsp')

EOF
