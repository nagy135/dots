local api = vim.api

local lines = {
"/**",
"*",
"*",
"* @author Viktor Nagy <viktor.nagy@01people.com>",
"*/"
}

_G.signature = function()
    local cursor_line = api.nvim_win_get_cursor(0)[1] -1
    api.nvim_buf_set_lines(0, cursor_line, cursor_line, false, lines)
    vim.cmd [[ normal 4kA ]]
end
