return {
  'mistweaverco/kulala.nvim',
  keys = {
    { '<leader>Rs', desc = 'Send request' },
    { '<leader>Ra', desc = 'Send all requests' },
    { '<leader>Rb', desc = 'Open scratchpad' },
  },
  ft = { 'http', 'rest' },
  lazy = false,
  opts = {
    global_keymaps = {
      ['Send request'] = { -- sets global mapping
        '<leader>Rs',
        function()
          require('kulala').run()
        end,
        mode = { 'n', 'v' }, -- optional mode, default is n
        desc = 'Send request', -- optional description, otherwise inferred from the key
      },
      ['Send all requests'] = {
        '<leader>Ra',
        function()
          require('kulala').run_all()
        end,
        mode = { 'n', 'v' },
        ft = 'http', -- sets mapping for *.http files only
      },
      ['Replay the last request'] = {
        '<leader>Rr',
        function()
          require('kulala').replay()
        end,
        ft = { 'http', 'rest' }, -- sets mapping for specified file types
      },
    },
    lsp = {
      enable = true,
      filetypes = { 'http', 'rest', 'json', 'yaml', 'bruno' },
      keymaps = false, -- disabled by default, as Kulala relies on default Neovim LSP keymaps
      formatter = {
        split_params = 4, -- split query/form parameters onto multiple lines if number of params exceeds this value
        sort = { -- enable/disable alphabetical sorting
          metadata = true,
          variables = true,
          commands = false,
          json = true,
        },
        quote_json_variables = true, -- add quotes around {{variable}} in JSON bodies
        indent = 2, -- base indentation for scripts
      },
      on_attach = function(client, bufnr)
        -- custom on_attach function
      end,
    },
  },
}
