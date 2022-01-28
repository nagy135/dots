-- sudo npm i typescript-language-server -g

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

require'lspconfig'.tsserver.setup{
    capabilities = capabilities
}
