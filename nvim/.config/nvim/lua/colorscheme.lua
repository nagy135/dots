local colors = require('gruvbox-baby.colors').config()

--     background: string = "#282828",
--     background_dark: string = "#1d2021",
--     background_light: string = "#32302f",
--     blue_gray: string = "#458588",
--     bright_yellow: string = "#fabd2f",
--     clean_green: string = "#8ec07c",
--     comment: string = "#665c54",
--     dark: string = "#202020",
--     dark0: string = "#0d0e0f",
--     dark_gray: string = "#83a598",
--     diff: table,
--     error_red: string = "#cc241d",
--     foreground: string = "#ebdbb2",
--     forest_green: string = "#689d6a",
--     gray: string = "#DEDEDE",
--     light_blue: string = "#7fa2ac",
--     magenta: string = "#b16286",
--     medium_gray: string = "#504945",
--     milk: string = "#E7D7AD",
--     none: string = "NONE",
--     orange: string = "#d65d0e",
--     pink: string = "#D4879C",
--     red: string = "#fb4934",
--     soft_green: string = "#98971a",
--     soft_yellow: string = "#eebd35",

vim.g.gruvbox_baby_highlights = { Visual = { bg = colors.medium_gray } }
vim.g.gruvbox_baby_highlights = {
    TabLineSel = {
        bg = colors.forest_green,
        fg = colors.background_dark
    },
    TabLine = {
        fg = colors.soft_yellow
    },
    Title = {
        fg = colors.milk
    }
}
vim.g.gruvbox_baby_background_color = "dark"

vim.cmd [[colorscheme gruvbox-baby]]
