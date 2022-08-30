require'lightspeed'.setup({})

-- this disables f/F/t/T functionality
vim.keymap.set('n', 'f', 'f');
vim.keymap.set('n', 'F', 'F');
vim.keymap.set('n', 't', 't');
vim.keymap.set('n', 'T', 'T');
vim.keymap.set('v', 'f', 'f');
vim.keymap.set('v', 'F', 'F');
vim.keymap.set('v', 't', 't');
vim.keymap.set('v', 'T', 'T');
