local api = vim.api

local signature_lines = {
    "/**",
    "*",
    "* @author Viktor Nagy <viktor.nagy@01people.com>",
    "*/"
}

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
