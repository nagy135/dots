local function prequire(...)
local status, lib = pcall(require, ...)
if (status) then return lib end
    return nil
end

local ls = prequire('luasnip')

local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        return true
    else
        return false
    end
end

_G.tab_complete = function()
    if vim.fn.pumvisible() == 1 then
        return t "<C-n>"
    elseif ls and ls.expand_or_jumpable() then
        return t("<Plug>luasnip-expand-or-jump")
    elseif check_back_space() then
        return t "<Tab>"
    else
        return vim.fn['compe#complete']()
    end
    return ""
end
_G.s_tab_complete = function()
    if vim.fn.pumvisible() == 1 then
        return t "<C-p>"
    elseif ls and ls.jumpable(-1) then
        return t("<Plug>luasnip-jump-prev")
    else
        return t "<S-Tab>"
    end
    return ""
end

vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<C-k>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<C-k>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<C-j>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<C-j>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<C-E>", "<Plug>luasnip-next-choice", {})
vim.api.nvim_set_keymap("s", "<C-E>", "<Plug>luasnip-next-choice", {})

local fmt = require('luasnip.extras.fmt').fmt
local s = ls.s
local i = ls.insert_node
local rep = require('luasnip.extras').rep

local ts_js = {
    s('func', fmt("const {} = ({}) => {{\n  {}\n}};", {
        i(1),
        i(2),
        i(0),
    })),
    s('log', fmt("console.log('{}',{})", {
        rep(1),
        i(1)
    })),
    -- ls.parser.parse_snippet('func', "const $1 = ($2) => {\n  $0\n};")
    -- ls.parser.parse_snippet('log', "console.log($1)")
}

ls.snippets = {
    javascript = ts_js,
    typescript = ts_js,
}
