require'lightspeed'.setup({})

-- this disables f/F/t/T functionality
vim.keymap.set('n', 'f', 'f');
vim.keymap.set('n', 'F', 'F');
vim.keymap.set('n', 't', 't');
vim.keymap.set('n', 'T', 'T');
