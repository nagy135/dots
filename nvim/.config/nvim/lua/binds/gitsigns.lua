local M = {}

M.set = function(gs, bufnr)
    vim.keymap.set('n', '<leader>h',
        function() require 'key-menu'.open_window('<leader>h') end,
        { desc = 'Gitsigns' })
    local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
    end

    local next_hunk = function()
        if vim.wo.diff then return ']h' end
        vim.schedule(function() gs.next_hunk() end)
        return '<Ignore>'
    end

    local prev_hunk = function()
        if vim.wo.diff then return '[h' end
        vim.schedule(function() gs.prev_hunk() end)
        return '<Ignore>'
    end

    -- Navigation
    map('n', ']h', next_hunk, { expr = true })
    map('n', '<M-n>', next_hunk, { expr = true })

    map('n', '[h', prev_hunk, { expr = true })
    map('n', '<M-p>', prev_hunk, { expr = true })

    -- Actions
    map({ 'n', 'v' }, '<leader>hs', ':Gitsigns stage_hunk<CR>', { desc = 'Stage hunk' })
    map({ 'n', 'v' }, '<leader>hr', ':Gitsigns reset_hunk<CR>', { desc = 'Reset hunk' })
    map('n', '<leader>hS', gs.stage_buffer, { desc = 'Stage buffer' })
    map('n', '<leader>hu', gs.undo_stage_hunk, { desc = '' })
    map('n', '<leader>hR', gs.reset_buffer, { desc = 'Reset buffer' })
    map('n', '<leader>hp', gs.preview_hunk, { desc = 'Preview hunk' })
    map('n', '<leader>hb', function() gs.blame_line { full = true } end, { desc = 'Blame line' })
    -- map('n', '<leader>tb', gs.toggle_current_line_blame, { desc = '' })
    map('n', '<leader>hd', gs.diffthis, { desc = 'Diff this' })
    map('n', '<leader>hD', function() gs.diffthis('~') end, { desc = 'Diff this (~)' })
    map('n', '<leader>td', gs.toggle_deleted, { desc = 'Toggle deleted' })

    -- Text object
    map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'Select hunk' })
end

return M
