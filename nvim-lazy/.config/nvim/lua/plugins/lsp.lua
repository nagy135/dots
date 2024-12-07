local wk = require("which-key")
wk.add({
  { "<leader>cl", group = "lsp" },
})

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
          library = {
            -- See the configuration section for more details
            -- Load luvit types when the `vim.uv` word is found
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
    },
    keys = {
      {
        "<leader>cll",
        "<CMD>LspInfo<CR>",
        desc = "Info",
      },
      {
        "<leader>clc",
        "<CMD>LspStop<CR>",
        desc = "Stop (Cancel)",
      },
      {
        "<leader>cls",
        "<CMD>LspStart<CR>",
        desc = "Start",
      },
      {
        "<leader>clr",
        "<CMD>LspRestart<CR>",
        desc = "Restart",
      },
    },
    opts = {
      servers = {
        tsserver = {
          settings = {
            completions = {
              completeFunctionCalls = true,
            },
            inlayHints = {
              -- taken from https://github.com/typescript-language-server/typescript-language-server#workspacedidchangeconfiguration
              includeInlayEnumMemberValueHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayParameterNameHints = "all",
              includeInlayParameterNameHintsWhenArgumentMatchesName = true, -- false
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayVariableTypeHintsWhenTypeMatchesName = true, -- false
            },
          },
        },
      },
    },
  },
}
