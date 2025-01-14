-- return {
--   "saghen/blink.cmp",
--   dependencies = { "supermaven-nvim", "saghen/blink.compat" },
--   opts = {
--     keymap = {
--       preset = "default",
--       ["<C-p>"] = { "select_prev", "fallback" },
--       ["<C-n>"] = { "select_next", "fallback" },
--       ["<C-e>"] = { "hide" },
--       ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
--       ["<C-u>"] = { "scroll_documentation_up", "fallback" },
--       ["<C-d>"] = { "scroll_documentation_down", "fallback" },
--     },
--     providers = {
--       buffer = {
--         enabled = false,
--       },
--     },
--   },
-- }
return {
  "saghen/blink.cmp",
  dependencies = "rafamadriz/friendly-snippets",
  opts = {
    keymap = { preset = "default" },

    appearance = {
      -- Sets the fallback highlight groups to nvim-cmp's highlight groups
      -- Useful for when your theme doesn't support blink.cmp
      -- Will be removed in a future release
      -- use_nvim_cmp_as_default = true,
      -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = "mono",
    },

    -- Default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, due to `opts_extend`
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },
  },
  opts_extend = { "sources.default" },
}
