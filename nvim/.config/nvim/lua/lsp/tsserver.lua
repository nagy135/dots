-- sudo npm i typescript-language-server -g

local capabilities = require('cmp_nvim_lsp').default_capabilities()

local navbuddy = require("nvim-navbuddy")

require("lspconfig").tsserver.setup {
    capabilities = capabilities,
	on_attach = function(client, bufnr)
		navbuddy.attach(client, bufnr)
	end
}
