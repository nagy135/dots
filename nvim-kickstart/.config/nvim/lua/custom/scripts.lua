local ts_utils = require 'nvim-treesitter.ts_utils'

function GetJsonPath()
  local node = ts_utils.get_node_at_cursor()
  if not node then
    print 'No node found!'
    return
  end

  local path = {}
  while node do
    if node:type() == 'pair' then
      local key_node = node:child(0)
      if key_node and key_node:type() == 'string' then
        local key_text = vim.treesitter.get_node_text(key_node, 0)
        table.insert(path, 1, key_text)
      end
    end
    node = node:parent()
  end

  print('JSON Path: ' .. table.concat(path, '.'))
end
vim.keymap.set('n', '<leader><leader>j', GetJsonPath, { desc = 'Get JSON Path' })
