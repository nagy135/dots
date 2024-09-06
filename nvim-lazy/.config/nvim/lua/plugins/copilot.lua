-- return {
--   "github/copilot.vim",
--   config = function()
--     vim.g.copilot_enabled = true
--     vim.g.copilot_no_tab_map = true
--     vim.cmd('imap <silent><script><expr> <C-l> copilot#Accept("")')
--     vim.cmd([[
-- 			let g:copilot_filetypes = {
-- 	       \ 'TelescopePrompt': v:false,
-- 	     \ }
-- 			]])
--   end,
-- }
return {
  {
    "supermaven-inc/supermaven-nvim",
    config = function()
      require("supermaven-nvim").setup({})
    end,
  },
  {
    "L3MON4D3/LuaSnip",
    keys = {
      { "<tab>", false, mode = { "i", "s" } },
      { "<s-tab>", false, mode = { "i", "s" } },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    keys = {
      { "<tab>", false, mode = { "i", "s" } },
      { "<s-tab>", false, mode = { "i", "s" } },
    },
  },
}
