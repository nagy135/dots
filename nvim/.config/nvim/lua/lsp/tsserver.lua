-- sudo npm i typescript-language-server -g

local capabilities = require('cmp_nvim_lsp').default_capabilities()

require'lspconfig'.tsserver.setup{
    capabilities = capabilities
}
