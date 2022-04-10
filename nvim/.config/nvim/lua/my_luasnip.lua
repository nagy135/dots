local function prequire(...)
local status, lib = pcall(require, ...)
if (status) then return lib end
    return nil
end

local ls = prequire('luasnip')

local tt = function(str)
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
        return tt "<C-n>"
    elseif ls and ls.expand_or_jumpable() then
        return tt("<Plug>luasnip-expand-or-jump")
    elseif check_back_space() then
        return tt "<Tab>"
    else
        return vim.fn['compe#complete']()
    end
    return ""
end
_G.s_tab_complete = function()
    if vim.fn.pumvisible() == 1 then
        return tt "<C-p>"
    elseif ls and ls.jumpable(-1) then
        return tt("<Plug>luasnip-jump-prev")
    else
        return tt "<S-Tab>"
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
vim.api.nvim_set_keymap("i", "<C-l>", "<Plug>luasnip-next-choice", {})
vim.api.nvim_set_keymap("s", "<C-l>", "<Plug>luasnip-next-choice", {})

local fmt = require('luasnip.extras.fmt').fmt
local s = ls.s
local i = ls.insert_node
local c = ls.choice_node
local t = ls.text_node
local rep = require('luasnip.extras').rep

local ts_js = {
    s('func', fmt("/**\n* {}\n*\n* @author Viktor Nagy<viktor.nagy@01people.com>\n*/\n{}const {} = {}({}){} => {{\n  {}\n}};", {
        i(6),
        c(1, {t "", t "export "}),
        i(2),
        c(3, {t "", t "async "}),
        i(4),
        i(5),
        i(0),
    })),
    s('log', fmt("console.log('{}',{});", {
        rep(1),
        i(1)
    })),
    s('for', fmt("for (const {} {} {}){{\n  {}\n}}", {
        i(1),
        c(2, {t "of", t "in"}),
        i(3),
        i(0)
    })),
}

ls.add_snippets("javascript", ts_js)
ls.add_snippets("typescript", ts_js)
ls.add_snippets("typescriptreact", ts_js)
ls.add_snippets("javascriptreact", ts_js)
