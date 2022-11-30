return require('packer').startup(function(use)
    -- packer {{{
    use 'wbthomason/packer.nvim'
    -- }}}
    -- personal {{{
    use { 'nagy135/typebreak.nvim',
        config = function()
            vim.keymap.set('n', '<leader>tb', require('typebreak').start, { desc = 'Typebreak'})
        end
    }
    use 'nagy135/capture-nvim'
    use { 'nat-418/boole.nvim',
        config = function()
            require('boole').setup({
                mappings = {
                    increment = '<C-a>',
                    decrement = '<C-x>'
                },
            })
        end
    }
    -- }}}
    -- themes {{{
    use 'folke/tokyonight.nvim'
    use 'olimorris/onedarkpro.nvim'
    use 'sainnhe/gruvbox-material'
    use({
        'luisiacc/gruvbox-baby',
        config = function()
            local colors = require('gruvbox-baby.colors').config()

            --     background: string = "#282828",
            --     background_dark: string = "#1d2021",
            --     background_light: string = "#32302f",
            --     blue_gray: string = "#458588",
            --     bright_yellow: string = "#fabd2f",
            --     clean_green: string = "#8ec07c",
            --     comment: string = "#665c54",
            --     dark: string = "#202020",
            --     dark0: string = "#0d0e0f",
            --     dark_gray: string = "#83a598",
            --     diff: table,
            --     error_red: string = "#cc241d",
            --     foreground: string = "#ebdbb2",
            --     forest_green: string = "#689d6a",
            --     gray: string = "#DEDEDE",
            --     light_blue: string = "#7fa2ac",
            --     magenta: string = "#b16286",
            --     medium_gray: string = "#504945",
            --     milk: string = "#E7D7AD",
            --     none: string = "NONE",
            --     orange: string = "#d65d0e",
            --     pink: string = "#D4879C",
            --     red: string = "#fb4934",
            --     soft_green: string = "#98971a",
            --     soft_yellow: string = "#eebd35",

            vim.g.gruvbox_baby_highlights = { Visual = { bg = colors.medium_gray } }
            vim.g.gruvbox_baby_highlights = {
                TabLineSel = {
                    bg = colors.forest_green,
                    fg = colors.background_dark
                },
                TabLine = {
                    fg = colors.soft_yellow
                },
                Title = {
                    fg = colors.milk
                }
            }
            vim.g.gruvbox_baby_background_color = "dark"
        end
    })
    use 'joshdick/onedark.vim'
    -- }}}
    -- key-menu {{{
    use 'linty-org/key-menu.nvim'
    -- }}}
    -- telescope {{{
    use {
        'nvim-telescope/telescope.nvim',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }
    use 'nvim-telescope/telescope-fzy-native.nvim'
    -- }}}
    -- nvim-treesitter {{{
    use 'nvim-treesitter/nvim-treesitter'
    -- }}}
    -- lsp-config {{{
    use 'neovim/nvim-lspconfig'
    -- }}}
    -- noice {{{
    use({
        "folke/noice.nvim",
        event = "VimEnter",
        config = function()
            require("noice").setup()
        end,
        requires = {
            -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
            "MunifTanjim/nui.nvim",
            -- "rcarriga/nvim-notify",
        }
    })
    -- }}}
    -- NeoZoom {{{
    use 'nyngwang/NeoZoom.lua'
    -- }}}
    -- jsonpath {{{
    use({ 'phelipetls/jsonpath.nvim', requires = { 'nvim-treesitter/nvim-treesitter' } })
    -- }}}
    -- LspSaga {{{
    use({
        "glepnir/lspsaga.nvim",
        branch = "main",
    })
    -- }}}
    -- Neog {{{
    use({
        "nvim-neorg/neorg",
        -- tag = "*",
        requires = { "nvim-treesitter/nvim-treesitter", "nvim-lua/plenary.nvim" }
    })
    --     requires = { "nvim-treesitter/nvim-treesitter", "nvim-lua/plenary.nvim" }
    -- })
    -- }}}
    -- incline {{{
    use 'b0o/incline.nvim'
    -- }}}
    -- color-picker {{{
    use "ziontee113/color-picker.nvim"
    -- }}}
    -- nvim-colorizer {{{
    use 'norcalli/nvim-colorizer.lua'
    -- }}}
    -- presenting {{{
    use 'sotte/presenting.vim'
    -- }}}
    -- rest-nvim {{{
    use({
        "NTBBloodbath/rest.nvim",
        requires = { "nvim-lua/plenary.nvim" },
    })
    -- }}}
    -- nvim-window-picker {{{
    use 's1n7ax/nvim-window-picker'
    -- }}}
    -- telescope-ui-select {{{
    use 'nvim-telescope/telescope-ui-select.nvim'
    -- }}}
    -- lightspeed {{{
    use 'ggandor/lightspeed.nvim'
    -- }}}
    -- neo-tree {{{
    use({
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v2.x",
        requires = {
            "nvim-lua/plenary.nvim",
            "kyazdani42/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
        }
    })
    -- }}}
    -- neo-tree-diagnostics {{{
    use {
        "mrbjarksen/neo-tree-diagnostics.nvim",
        requires = "nvim-neo-tree/neo-tree.nvim",
    }
    -- }}}
    -- prettier {{{
    use({
        'MunifTanjim/prettier.nvim',
        requires = {
            'jose-elias-alvarez/null-ls.nvim',
            'neovim/nvim-lspconfig'
        }
    })
    -- }}}
    -- null-ls {{{
    use 'jose-elias-alvarez/null-ls.nvim'
    -- }}}
    -- telescope-file-browser {{{
    use "nvim-telescope/telescope-file-browser.nvim"
    -- }}}
    -- lub-vimdocs {{{
    use 'nanotee/luv-vimdocs'
    -- }}}
    -- nvim-luaref {{{
    use 'milisims/nvim-luaref'
    -- }}}
    -- neogit {{{
    use { 'TimUntersberger/neogit', requires = 'nvim-lua/plenary.nvim' }
    -- }}}
    -- diffview {{{
    use { 'sindrets/diffview.nvim', requires = 'nvim-lua/plenary.nvim' }
    -- }}}
    -- harpoon {{{
    use { 'ThePrimeagen/harpoon', requires = 'nvim-lua/plenary.nvim' }
    -- }}}
    -- nvim-cmp {{{
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/nvim-cmp'
    -- }}}
    -- luasnip {{{
    use 'L3MON4D3/LuaSnip'
    use 'saadparwaiz1/cmp_luasnip'
    -- }}}
    -- fidget {{{
    use 'j-hui/fidget.nvim'
    -- }}}
    -- nui {{{
    use 'MunifTanjim/nui.nvim'
    -- }}}
    -- mason {{{
    use 'williamboman/mason.nvim'
    use 'williamboman/mason-lspconfig.nvim'
    -- }}}
    -- refactoring {{{
    use 'ThePrimeagen/refactoring.nvim'
    -- }}}
    -- lsp-kind {{{
    use 'onsails/lspkind-nvim'
    -- }}}
    -- lua-dev {{{
    use "folke/lua-dev.nvim"
    -- }}}
    -- impatient {{{
    use 'lewis6991/impatient.nvim'
    -- }}}
    -- gitsigns {{{
    use 'lewis6991/gitsigns.nvim'
    -- }}}
    -- hop {{{
    use 'phaazon/hop.nvim'
    -- }}}
    -- todo-comments {{{
    use {
        "folke/todo-comments.nvim",
        requires = "nvim-lua/plenary.nvim",
    }
    -- }}}
    -- popup {{{
    use { 'nvim-lua/popup.nvim', requires = 'nvim-lua/plenary.nvim' }
    -- }}}
    -- cheatsheet {{{
    use {
        'sudormrfbin/cheatsheet.nvim',

        requires = {
            { 'nvim-telescope/telescope.nvim' },
            { 'nvim-lua/popup.nvim' },
            { 'nvim-lua/plenary.nvim' },
        }
    }
    -- }}}
    -- devicons {{{
    use 'kyazdani42/nvim-web-devicons'
    -- }}}
    -- lualine {{{
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }
    -- }}}
    -- indent-blackline {{{
    use "lukas-reineke/indent-blankline.nvim"
    -- }}}
    -- firenvim {{{
    use {
        'glacambre/firenvim',
        run = function() vim.fn['firenvim#install'](0) end
    }
    -- }}}
    -- undotree {{{
    use 'mbbill/undotree'
    -- }}}
    -- zig.vim {{{
    use 'ziglang/zig.vim'
    -- }}}
    -- wiki.vim {{{
    use 'lervag/wiki.vim'
    -- }}}
    -- vim-laravel {{{
    use 'noahfrederick/vim-laravel'
    -- }}}
    -- rust.vim {{{
    use 'rust-lang/rust.vim'
    -- }}}
    -- nvim-surround {{{
    use 'kylechui/nvim-surround'
    -- }}}
    -- Comment.nvim {{{
    use 'numToStr/Comment.nvim'
    -- }}}
    -- vim-eunuch {{{
    use 'tpope/vim-eunuch'
    -- }}}
    -- tagbar {{{
    use 'majutsushi/tagbar'
    -- }}}
    -- vim-markdown {{{
    use 'tpope/vim-markdown'
    -- }}}
    -- vim-abolish {{{
    use 'tpope/vim-abolish'
    -- }}}
    -- emmet-vim {{{
    use 'mattn/emmet-vim'
    -- }}}
    -- alpha-nvim {{{
    use 'goolord/alpha-nvim'
    -- }}}
    -- vim-blade {{{
    use 'jwalton512/vim-blade'
    -- }}}
    -- vim-repeat {{{
    use 'tpope/vim-repeat'
    -- }}}
    -- typescript-vim {{{
    use 'leafgarland/typescript-vim'
    -- }}}
    -- zen-mode.nvim {{{
    use 'folke/zen-mode.nvim'
    -- }}}
    -- yats.vim {{{
    use 'HerringtonDarkholme/yats.vim'
    -- }}}
    -- vim-jsx-improve {{{
    use 'neoclide/vim-jsx-improve'
    -- }}}
    -- vim-jsx-pretty {{{
    use 'MaxMEllon/vim-jsx-pretty'
    -- }}}
    -- nvcode-color-schemes.vim {{{
    use 'christianchiarulli/nvcode-color-schemes.vim'
    -- }}}
    -- nim.vim {{{
    use 'zah/nim.vim'
    -- }}}
end)
