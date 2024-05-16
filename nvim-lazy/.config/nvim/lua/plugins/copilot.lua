return {
  "github/copilot.vim",
  config = function()
    vim.g.copilot_enabled = true
    vim.g.copilot_no_tab_map = true
    vim.cmd('imap <silent><script><expr> <C-l> copilot#Accept("")')
    vim.cmd([[
			let g:copilot_filetypes = {
	       \ 'TelescopePrompt': v:false,
	     \ }
			]])
  end,
}
