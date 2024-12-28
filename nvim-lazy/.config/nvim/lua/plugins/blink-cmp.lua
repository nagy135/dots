return {
  "saghen/blink.cmp",
  dependencies = { "supermaven-nvim", "saghen/blink.compat" },
  opts = {
    keymap = {
      preset = "default",
      ["<C-p>"] = { "select_prev", "fallback" },
      ["<C-n>"] = { "select_next", "fallback" },
      ["<C-e>"] = { "hide" },
      ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
      ["<C-u>"] = { "scroll_documentation_up", "fallback" },
      ["<C-d>"] = { "scroll_documentation_down", "fallback" },
    },
    providers = {
      buffer = {
        enabled = false,
      },
    },
  },
}
