return {
  "segeljakt/vim-silicon",
  cmd = { "Silicon" },
  keys = {
    {
      "<leader>cs",
      "<cmd>Silicon<cr>",
      desc = "Screenshot code",
      mode = { "n" }
    },
    {
      "<leader>cs",
      "<cmd>'<,'>Silicon<cr>",
      desc = "Screenshot highlight",
      mode = { "v", "s", "x" }
    }
  },
  config = function()
    vim.cmd [[ let g:silicon = {
      \   'theme':              'Visual Studio Dark+',
      \   'font':               'Mononoki Nerd Font',
      \   'background':         '#AAAAFF',
      \   'shadow-color':       '#222222',
      \   'line-pad':                   2,
      \   'pad-horiz':                 80,
      \   'pad-vert':                 100,
      \   'shadow-blur-radius':        30,
      \   'shadow-offset-x':            0,
      \   'shadow-offset-y':            0,
      \   'line-number':           v:true,
      \   'round-corner':          v:true,
      \   'window-controls':       v:true,
      \ } ]]
  end
}
