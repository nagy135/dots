return {
  "neovim/nvim-lspconfig",
  ---@type lspconfig.options
  ---@diagnostic disable-next-line: missing-fields
  opts = {
    inlay_hints = { enabled = false },
    servers = {
      -- tsserver will be automatically installed with mason and loaded with lspconfig
    },
    -- you can do any additional lsp server setup here
    -- return true if you don't want this server to be setup with lspconfig
    ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
    setup = {
      pyright = function(_, opts)
        require("lspconfig").pyright.setup({ server = opts })
        return true
      end,

      -- Specify * to use this function as a fallback for any server
      -- ["*"] = function(server, opts) end,
    },
  },
}
