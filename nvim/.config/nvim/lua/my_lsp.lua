local nvim_lsp = require'lspconfig'

-- sudo pacman -S npm
-- sudo npm i intelephense -g
nvim_lsp.intelephense.setup{};

-- sudo npm i typescript-language-server -g
nvim_lsp.tsserver.setup {
    on_attach = function(client)
        client.resolved_capabilities.document_formatting = false
        on_attach(client)
    end
}
