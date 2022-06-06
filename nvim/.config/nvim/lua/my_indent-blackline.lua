local OPTIONS = {
    INDENT_GUIDES = 1,
    VSCODE_YELLOW_LINE = 2,
    BASIC = 3 -- uses default plugin options
}
-- EDIT HERE
local mode = OPTIONS.INDENT_GUIDES;
-- EDIT HERE

local opts = {}
if mode == OPTIONS.INDENT_GUIDES then
    vim.cmd [[highlight IndentBlanklineIndent1 guibg=#3a3a3a gui=nocombine]]
    vim.cmd [[highlight IndentBlanklineIndent2 guibg=#2f2f2f gui=nocombine]]
    opts = {
        char = "",
        char_highlight_list = {
            "IndentBlanklineIndent1",
            "IndentBlanklineIndent2",
        },
        space_char_highlight_list = {
            "IndentBlanklineIndent1",
            "IndentBlanklineIndent2",
        },
        show_trailing_blankline_indent = false,
    }
elseif mode == OPTIONS.VSCODE_YELLOW_LINE then
    vim.cmd [[highlight IndentBlanklineContextChar guifg=#f9dc2b gui=nocombine]]
    opts = {
        show_current_context = true,
        show_current_context_start = true,
        char = "┆",
        buftype_exclude = { "terminal" }
    }
end
require("indent_blankline").setup(opts)
