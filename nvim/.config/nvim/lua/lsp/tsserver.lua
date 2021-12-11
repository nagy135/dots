local nvim_lsp = require'lspconfig'

-- sudo npm i typescript-language-server -g

-- local map = function(type, key, value)
    -- vim.api.nvim_buf_set_keymap(0,type,key,value,{noremap = true, silent = true});
-- end

local on_attach = function()
	-- require'completion'.on_attach(client)
	-- require'diagnostic'.on_attach(client)

	-- map('n','gD','<cmd>lua vim.lsp.buf.declaration()<CR>')
	-- map('n','gd','<cmd>lua vim.lsp.buf.definition()<CR>')
	-- map('n','K','<cmd>lua vim.lsp.buf.hover()<CR>')
	-- map('n','gr','<cmd>lua vim.lsp.buf.references()<CR>')
	-- map('n','gs','<cmd>lua vim.lsp.buf.signature_help()<CR>')
	-- map('n','gi','<cmd>lua vim.lsp.buf.implementation()<CR>')
	-- map('n','<leader>gw','<cmd>lua vim.lsp.buf.document_symbol()<CR>')
	-- map('n','<leader>gW','<cmd>lua vim.lsp.buf.workspace_symbol()<CR>')
	-- map('n','<leader>ca','<cmd>lua vim.lsp.buf.code_action()<CR>')
	-- map('n','<leader>ar','<cmd>lua vim.lsp.buf.rename()<CR>')
	-- map('n','<leader>=', '<cmd>lua vim.lsp.buf.formatting()<CR>')
end
nvim_lsp.tsserver.setup {
    on_attach = function(client)
        client.resolved_capabilities.document_formatting = false
        on_attach()
    end
}
