local api = vim.api

local signature_lines = {
    "/**",
    "*",
    "* @author Viktor Nagy <viktor.nagy@01people.com>",
    "*/"
}

local function split_by_sep(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        table.insert(t, str)
    end
    return t
end

local function get_visual_selection()
    local s_start = vim.fn.getpos("'<")
    local s_end = vim.fn.getpos("'>")
    local n_lines = math.abs(s_end[2] - s_start[2]) + 1
    local lines = vim.api.nvim_buf_get_lines(0, s_start[2] - 1, s_end[2], false)
    lines[1] = string.sub(lines[1], s_start[3], -1)
    if n_lines == 1 then
        lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3] - s_start[3] + 1)
    else
        lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3])
    end
    return table.concat(lines, '\n')
end

_G.record_memory = {
    selected = "";
    selected_len = 0;
    current_line = "";
    col = 0;
    row = 0;
}

_G.copy_with_difference = function(record)

    if record == true then
        record_memory.selected = get_visual_selection()
        if record_memory.selected == "" then
            print("select something!")
            return
        end
        record_memory.selected_len = record_memory.selected:len()
        record_memory.current_line = vim.api.nvim_get_current_line()
        local cursor = vim.api.nvim_win_get_cursor(0)
        record_memory.row = cursor[1]
        record_memory.col = cursor[2]
    elseif record_memory.selected == "" then
        print("first select using copy_with_difference(true)")
    else
        local value = vim.fn.input("Update to: ")
        if value == nil or value == '' then
            return
        end
        local updated_line = string.sub(record_memory.current_line, 1, record_memory.col)
            .. value
            .. string.sub(record_memory.current_line, record_memory.col + record_memory.selected_len + 1, -1)

        api.nvim_buf_set_lines(0, record_memory.row, record_memory.row, false, { updated_line })
    end
end

--   +----------+                                               $
--   | cryptoBE +----- POST /v1/bla --+     +--------+          $
--   +-----+----+                     +-----+ nft BE |          $
--         |     +-------------+            +--------+          $
--         +-----+ payment api |                                $
--               +-------------+                                $
--                                                              $
--                                                              $
--                                                              $
--                                                              $
_G.tabulize = function()
    local tl = '+'
    local tr = '+'
    local bl = '+'
    local br = '+'

    local v = '|'
    local h = '-'

    local s_start = vim.fn.getpos("'<")
    local s_end = vim.fn.getpos("'>")
    local row_start, col_start, row_end, col_end = s_start[2], s_start[3], s_end[2], s_end[3]

    local width = col_end - col_start
    local height = row_end - row_start

    if row_start == row_end then
        -- -
        local previous_lines = api.nvim_buf_get_lines(0, row_start - 1, row_end, false)
        local lines = {
            string.sub(previous_lines[1], 1, col_start - 1)
                .. "+"
                .. string.rep("-", width - 1)
                .. "+"
                .. string.sub(previous_lines[1], col_end + 1) }
        api.nvim_buf_set_lines(0, row_start - 1, row_start, false, lines)
        return
    elseif col_start == col_end then
        -- |
        local previous_lines = api.nvim_buf_get_lines(0, row_start - 1, row_end, false)
        local lines = {
            string.sub(previous_lines[1], 1, col_start - 1)
                .. "+"
                .. string.sub(previous_lines[1], col_end + 1) }
        for i = 1, height - 1 do
            table.insert(lines, string.sub(previous_lines[i + 1], 1, col_start - 1)
            .. "|"
            .. string.sub(previous_lines[i + 1], col_end + 1))
        end
        table.insert(lines, string.sub(previous_lines[height + 1], 1, col_start - 1)
        .. "+"
        .. string.sub(previous_lines[height + 1], col_end + 1))

        api.nvim_buf_set_lines(0, row_start - 1, row_end, false, lines)
        return
    end

    if row_start > row_end then
        local tmp = row_end
        row_end = row_start
        row_start = tmp
    end

    if col_start > col_end then
        local tmp = col_end
        col_end = col_start
        col_start = tmp
    end


    local previous_lines = api.nvim_buf_get_lines(0, row_start - 1, row_end, false)

    local lines = { string.sub(previous_lines[1], 1, col_start - 1) .. tl .. string.rep(h, width - 1) .. tr .. string.sub(previous_lines[1], col_end + 1) }
    for i = 1, height - 1 do
        table.insert(lines,
            string.sub(previous_lines[i + 1], 1, col_start - 1) ..
            v ..
            string.sub(previous_lines[i + 1], col_start + 1, col_end - 1) ..
            v ..
            string.sub(previous_lines[i + 1], col_end + 1)
        )
    end
    table.insert(lines, string.sub(previous_lines[height + 1], 1, col_start - 1) ..
    bl ..
    string.rep(h, width - 1) ..
    br ..
    string.sub(previous_lines[height + 1], col_end + 1)
    )

    api.nvim_buf_set_lines(0, row_start - 1, row_end, false, lines)
end

_G.signature = function()
    local status, Input = pcall(require, "nui.input")
    if (status) then
        local event = require("nui.utils.autocmd").event
        local input = Input({
            position = {
                row = 0,
                col = 0,
            },
            size = {
                width = 40,
                height = 2,
            },
            relative = "cursor",
            border = {
                highlight = "MyHighlightGroup",
                style = "double",
                text = {
                    top = " Description ",
                    top_align = "center",
                },
            },
            win_options = {
                winblend = 10,
                winhighlight = "Normal:Normal",
            },
        }, {
            prompt = "> ",
            default_value = "",
            on_submit = function(value)
                local comment_lines
                if value:len() > 40 then
                    comment_lines = {}

                    local counter = 0
                    local line = ""
                    for _, word in ipairs(split_by_sep(value)) do
                        if counter > 40 then
                            counter = 0
                            table.insert(comment_lines, "* " .. line)
                            line = ""
                        end
                        counter = counter + word:len()
                        line = line .. " " .. word
                    end
                    if counter ~= 0 then
                        table.insert(comment_lines, "* " .. line)
                    end
                else
                    comment_lines = { "* " .. value }
                end
                local cursor_line = api.nvim_win_get_cursor(0)[1] - 1
                api.nvim_buf_set_lines(0, cursor_line, cursor_line, false, signature_lines)
                api.nvim_buf_set_lines(0, cursor_line + 1, cursor_line + 1, false, comment_lines)
                vim.cmd [[ normal 4kA ]]
                api.nvim_command(":Prettier")
            end,
        })

        -- mount/open the component
        input:mount()

        -- unmount component when cursor leaves buffer
        input:on(event.BufLeave, function()
            input:unmount()
        end)
        input:on(event.InsertLeave, function()
            input:unmount()
        end)
    else
        print("Install nui.nvim!")
    end


end
