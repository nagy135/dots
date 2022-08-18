require'lualine'.setup {
  options = {
    icons_enabled = true,
    theme = 'gruvbox-baby',
    section_separators = {left = '', right = ''},
    component_separators = {left = '', right = ''},
    disabled_filetypes = {'neo-tree'}
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch'},
    lualine_c = {'filename'},
    lualine_x = {'diagnostics', 'diff', 'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  extensions = {}
}
