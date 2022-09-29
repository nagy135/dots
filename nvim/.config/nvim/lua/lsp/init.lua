-- Servers:
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md

require("mason").setup()
require("mason-lspconfig").setup()

-- SERVER BLOCKS
require("lsp.tsserver")
require("lsp.lua-language-server")
require("lsp.pyright")
require("lsp.sqlls")

require("lsp.intelephense")
require("lsp.cssls")
require("lsp.tailwindcss")
require("lsp.gopls")
require("lsp.bashls")
-- require("lsp.rls")
-- require("lsp.rust_analyzer")
require("lsp.nimls")
require("lsp.dockerls")
require("lsp.htmlls")
-- require("lsp.jsonls")
require("lsp.yamlls")
require("lsp.rnix-lsp")

-- require("lsp.my_nvim-lsp-installer")
-- require("lsp.pylsp")

local opts = { noremap=true, silent=true }
local map  = vim.api.nvim_set_keymap;

map('n','<leader>D'  ,'<cmd>lua vim.lsp.buf.declaration()<CR>'                               ,opts)
map('n','gD'         ,'<cmd>lua vim.lsp.buf.type_definition()<CR>'                           ,opts)
map('n','gd'         ,'<cmd>lua vim.lsp.buf.definition()<CR>'                                ,opts)
map('n','K'          ,'<cmd>lua vim.lsp.buf.hover()<CR>'                                     ,opts)
map('n','gi'         ,'<cmd>lua vim.lsp.buf.implementation()<CR>'                            ,opts)
map('n','gK'         ,'<cmd>lua vim.lsp.buf.signature_help()<CR>'                            ,opts)
map('n','<leader>wa' ,'<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>'                      ,opts)
map('n','<leader>wr' ,'<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>'                   ,opts)
map('n','<leader>wl' ,'<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>',opts)
map('n','<leader>rn' ,'<cmd>lua vim.lsp.buf.rename()<CR>'                                    ,opts)
map('n','<leader>ca' ,'<cmd>lua vim.lsp.buf.code_action()<CR>'                               ,opts)
map('n','gr'         ,'<cmd>lua vim.lsp.buf.references()<CR>'                                ,opts)
map('n','<leader>gld','<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>'              ,opts)
map('n','[d'         ,'<cmd>lua vim.diagnostic.goto_prev()<CR>'                              ,opts)
map('n',']d'         ,'<cmd>lua vim.diagnostic.goto_next()<CR>'                              ,opts)
map('n','<leader>q'  ,'<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>'                        ,opts)
map('n','<leader>lf' ,'<cmd>lua vim.lsp.buf.format({ async = true })<CR>'                    ,opts)
map('x','<leader>lf' ,'<cmd>lua vim.lsp.buf.range_formatting()<CR>'                          ,opts)
map('n','<leader>df' ,'<cmd>lua vim.diagnostic.open_float()<CR>'                             ,opts)
