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
      require("supermaven-nvim").setup({
        color = {
          suggestion_color = "#DBDBDB",
          cterm = 244,
        },
      })
    end,
    keys = {
      {
        "<leader>ct",
        function()
          local api = require("supermaven-nvim.api")
          api.toggle()
          local is_running = api.is_running()
          vim.notify("SuperMaven " .. (not is_running and "disabled" or "enabled"), not is_running and "warn" or "info")
        end,
        desc = "Toggle SuperMaven",
      },
    },
  },
  -- {
  --   "L3MON4D3/LuaSnip",
  --   keys = {
  --     { "<tab>", false, mode = { "i", "s" } },
  --     { "<s-tab>", false, mode = { "i", "s" } },
  --   },
  -- },
  -- {
  --   "hrsh7th/nvim-cmp",
  --   keys = {
  --     { "<tab>", false, mode = { "i", "s" } },
  --     { "<s-tab>", false, mode = { "i", "s" } },
  --   },
  -- },
}
