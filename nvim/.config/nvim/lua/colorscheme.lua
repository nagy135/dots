local colors = require('gruvbox-baby.colors').config()
vim.g.gruvbox_baby_highlights = {Visual = {bg = colors.medium_gray}}
vim.g.gruvbox_baby_highlights = {Tabs = {fg = colors.medium_gray}}
vim.g.gruvbox_baby_background_color = "dark"

vim.cmd[[colorscheme gruvbox-baby]]
