local cmp = require'cmp'

local lspkind = require "lspkind"
lspkind.init()

cmp.setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        end,
    },
    mapping = {
        -- ['<C-p>'] = cmp.mapping.scroll_docs(-4),
        -- ['<C-n>'] = cmp.mapping.scroll_docs(4),
        -- ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-Space>'] = cmp.mapping.close(),
        ["<c-y>"] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
        },

    },
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = "path" },
        { name = "luasnip" },
        { name = "buffer", keyword_length = 4 },
    }),
    formatting = {
        format = lspkind.cmp_format {
            with_text = true,
            menu = {
                buffer = "[buf]",
                nvim_lsp = "[LSP]",
                nvim_lua = "[api]",
                path = "[path]",
                luasnip = "[snip]",
            },
        },
    },

    experimental = {
        native_menu = false,
        ghost_text = true,
    },
})
