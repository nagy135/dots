return {
  "nvimtools/none-ls.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "mason.nvim" },
  opts = function()
    local nls = require("null-ls")
    return {
      root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
      sources = {
        nls.builtins.formatting.shfmt,
        -- nls.builtins.diagnostics.eslint_d,
        nls.builtins.diagnostics.flake8,
        nls.builtins.formatting.prettierd,
      },
    }
  end,
}
