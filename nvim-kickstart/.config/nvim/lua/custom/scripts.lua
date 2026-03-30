local ts_utils = require 'nvim-treesitter.ts_utils'

local function get_dotfiles_root()
  local config_path = vim.uv.fs_realpath(vim.fn.stdpath 'config') or vim.fn.stdpath 'config'
  return vim.fs.dirname(vim.fs.dirname(vim.fs.dirname(config_path)))
end

local function get_wiki_root()
  local dotfiles_root = get_dotfiles_root()
  local candidates = {
    vim.fn.expand '~/wiki',
    dotfiles_root .. '/wiki/wiki',
    vim.fn.expand '~/vimwiki',
    dotfiles_root .. '/wiki/vimwiki',
  }

  for _, wiki_root in ipairs(candidates) do
    if vim.fn.isdirectory(wiki_root) == 1 then
      if vim.uv.fs_stat(wiki_root .. '/index.norg') or vim.uv.fs_stat(wiki_root .. '/index.wiki') then
        return wiki_root
      end
    end
  end

  for _, wiki_root in ipairs(candidates) do
    if vim.fn.isdirectory(wiki_root) == 1 then
      return wiki_root
    end
  end

  return vim.fn.expand '~/wiki'
end

local function open_wiki_index()
  local wiki_root = get_wiki_root()
  local candidates = {
    wiki_root .. '/index.norg',
    wiki_root .. '/index.wiki',
    wiki_root .. '/README.md',
  }

  for _, path in ipairs(candidates) do
    if vim.uv.fs_stat(path) then
      vim.cmd.edit(vim.fn.fnameescape(path))
      return
    end
  end

  vim.notify('No wiki index file found in ' .. wiki_root, vim.log.levels.WARN)
end

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

vim.keymap.set('n', '<leader>ww', function()
  require('telescope.builtin').find_files {
    prompt_title = 'Wiki Files',
    cwd = get_wiki_root(),
    follow = true,
    hidden = true,
  }
end, { desc = '[W]iki files' })

vim.keymap.set('n', '<leader>wg', function()
  require('telescope.builtin').live_grep {
    prompt_title = 'Wiki Grep',
    search_dirs = { get_wiki_root() },
  }
end, { desc = '[W]iki grep' })

vim.keymap.set('n', '<leader>wr', function()
  require('telescope.builtin').grep_string {
    prompt_title = 'Wiki word',
    search = vim.fn.expand '<cword>',
    search_dirs = { get_wiki_root() },
  }
end, { desc = '[W]iki grep word' })

vim.keymap.set('n', '<leader>wi', open_wiki_index, { desc = '[W]iki index' })
