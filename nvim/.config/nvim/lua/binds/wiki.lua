vim.keymap.set('n', '<leader>wp', function()
    require("telescope.builtin").find_files { 
        prompt_title = "WikiFzfPages",
        cwd = "~/wiki",
    }
end, { desc = 'WikiFzfPages' })
