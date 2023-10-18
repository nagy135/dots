local wk = require("which-key")
wk.register({
  ["<leader>cl"] = { name = "+lsp" },
})

return {
  {
    "neovim/nvim-lspconfig",
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
            typescript = {
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
            javascript = {
              inlayHints = {
                includeInlayEnumMemberValueHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayVariableTypeHintsWhenTypeMatchesName = true,
              },
            },
          },
        },
      },
    },
  },
}
