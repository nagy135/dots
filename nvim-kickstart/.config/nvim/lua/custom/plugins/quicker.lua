return {
  'stevearc/quicker.nvim',
  ft = 'qf',
  ---@module "quicker"
  ---@type quicker.SetupOptions
  opts = {},
  dependencies = { 'romainl/vim-qf' },
  config = function(_, opts)
    require('quicker').setup(opts)

    -- only set up binds in quickfix buffers
    local function set_qf_maps(buf)
      vim.keymap.set('n', '>', function()
        require('quicker').expand { before = 2, after = 2, add_to_existing = true }
      end, { buffer = buf, desc = 'Expand quickfix context' })

      vim.keymap.set('n', '<', function()
        require('quicker').collapse()
      end, { buffer = buf, desc = 'Collapse quickfix context' })
    end

    if vim.bo.filetype == 'qf' then
      set_qf_maps(vim.api.nvim_get_current_buf())
    end

    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'qf',
      callback = function(args)
        set_qf_maps(args.buf)
      end,
    })
  end,
}
