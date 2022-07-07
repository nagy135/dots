local M = {}

-- Sets the same bind for multiple key combinations
--
-- @binds table of binds
-- @callback argument of vim.keymap.set
-- @opts options passed further
M.alias_binds = function(binds, callback, opts)
    for _, bind in pairs(binds) do
        vim.keymap.set('n', bind, callback, opts)
    end
end

return M
