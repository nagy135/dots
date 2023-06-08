local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
 if not vim.loop.fs_stat(lazypath) then
   vim.fn.system({
     "git",
     "clone",
     "--filter=blob:none",
     "--single-branch",
     "https://github.com/folke/lazy.nvim.git",
     lazypath,
   })
 end
 vim.opt.runtimepath:prepend(lazypath)

require("lazy").setup({
    "folke/which-key.nvim",
    { "folke/neoconf.nvim", cmd = "Neoconf" },
    "folke/neodev.nvim",
    "nvim-lua/plenary.nvim",

    -- colorschemes {{{
    'sainnhe/gruvbox-material',
    'folke/tokyonight.nvim',
    'olimorris/onedarkpro.nvim',
    'sainnhe/gruvbox-material',
    'rebelot/kanagawa.nvim',
    'joshdick/onedark.vim',
    'arturgoms/moonbow.nvim',
  -- }}}

    -- personal {{{
    { 'nagy135/typebreak.nvim',
        config = function()
            vim.keymap.set('n', '<leader>tb', require('typebreak').start, { desc = 'Typebreak' })
        end
    },
    'nagy135/capture-nvim',
    -- }}}

    -- portal {{{
    {
        "cbochs/portal.nvim",
        -- Optional dependencies
        dependencies = {
            "cbochs/grapple.nvim",
            "ThePrimeagen/harpoon",
        },
        config = function()
            vim.keymap.set("n", "<leader>o", "<cmd>Portal jumplist backward<cr>")
            vim.keymap.set("n", "<leader>i", "<cmd>Portal jumplist forward<cr>")
        end
    },
    -- }}}

    -- treesj {{{
    {
      'Wansmer/treesj',
      cmd = { 'TSJToggle', 'TSJJoin', 'TSJSplit' },
      lazy = false,
      config = function()
          local tsj = require('treesj')
          tsj.setup()
          vim.keymap.set("n", "<leader>tj", tsj.toggle, { desc = "Toggle Treesitter Join" })
      end
    },
    -- }}}

    -- ultimate-autopair {{{
    -- {
    --     'altermo/ultimate-autopair.nvim',
    --     event={'InsertEnter','CmdlineEnter'},
    --     config=function ()
    --         require('ultimate-autopair').setup({
    --             --Config goes here
    --         })
    --     end,
    -- },
    -- }}}

    -- local-highlight {{{
    -- {
    --     'tzachar/local-highlight.nvim',
    --     config = function()
    --         require('local-highlight').setup({
    --             file_types = {'python', 'cpp'},
    --             hlgroup = 'Search',
    --             cw_hlgroup = nil,
    --         })
    --     end
    -- },
    -- }}}

    -- autoclose {{{
    { 
        "m4xshen/autoclose.nvim",
        config = function()
            --require("autoclose").setup({})
        end
    },
    -- }}}

    -- twilight {{{
    { 
        "folke/twilight.nvim",
        config = function()
            require("twilight").setup{}
            vim.keymap.set('n', '<leader>tw', ':Twilight<CR>', { desc = 'Twilight toggle'})
        end
    },
    -- }}}

    -- boole {{{
    { 'nat-418/boole.nvim',
        config = function()
            require('boole').setup({
                mappings = {
                    increment = '<C-a>',
                    decrement = '<C-x>'
                },
            })
        end
    },
    -- }}}

    -- keymenu {{{
    'linty-org/key-menu.nvim',
    -- }}}

    -- telescope {{{
    {
        'nvim-telescope/telescope.nvim',
        requires = { { 'nvim-lua/plenary.nvim' } }
    },
     'nvim-telescope/telescope-fzy-native.nvim',
    -- }}}

    -- nvim-treesitter {{{
     'nvim-treesitter/nvim-treesitter',
    -- }}}
    
    -- lsp-config {{{
     'neovim/nvim-lspconfig',
    -- }}}

    -- NeoZoom {{{
    'nyngwang/NeoZoom.lua',
    -- }}}

    -- jsonpath {{{
    { 'phelipetls/jsonpath.nvim', requires = { 'nvim-treesitter/nvim-treesitter' } },
    -- }}}

    -- LspSaga {{{
    {
        'glepnir/lspsaga.nvim',
        event = 'BufRead',
    },
    -- incline {{{
    'b0o/incline.nvim',
    -- }}}

    -- color-picker {{{
    "ziontee113/color-picker.nvim",
    -- }}}

    -- nvim-colorizer {{{
    'norcalli/nvim-colorizer.lua',
    -- }}}

    -- presenting {{{
    'sotte/presenting.vim',
    -- }}}

    -- rest-nvim {{{
    {
        "rest-nvim/rest.nvim",
        requires = { "nvim-lua/plenary.nvim" },
    },
    -- }}}

    -- nvim-window-picker {{{
    's1n7ax/nvim-window-picker',
    -- }}}

    -- telescope-ui-select {{{
    'nvim-telescope/telescope-ui-select.nvim',
    -- }}}

    -- lightspeed {{{
    'ggandor/lightspeed.nvim',
    -- }}}

    -- neo-tree {{{
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v2.x",
        requires = {
            "nvim-lua/plenary.nvim",
            "kyazdani42/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
        }
    },
    -- }}}

    -- neo-tree-diagnostics {{{
    {
        "mrbjarksen/neo-tree-diagnostics.nvim",
        requires = "nvim-neo-tree/neo-tree.nvim",
    },
    -- }}}

    -- prettier {{{
    {
        'MunifTanjim/prettier.nvim',
        requires = {
            'jose-elias-alvarez/null-ls.nvim',
            'neovim/nvim-lspconfig'
        }
    },
    -- }}}

    -- null-ls {{{
    'jose-elias-alvarez/null-ls.nvim',
    -- }}}

    -- telescope-file-browser {{{
    "nvim-telescope/telescope-file-browser.nvim",
    -- }}}

    -- lub-vimdocs {{{
    'nanotee/luv-vimdocs',
    -- }}}

    -- nvim-luaref {{{
    'milisims/nvim-luaref',
    -- }}}

    -- neogit {{{
    { 'TimUntersberger/neogit', requires = 'nvim-lua/plenary.nvim' },
    -- }}}

    -- diffview {{{
    { 'sindrets/diffview.nvim', requires = 'nvim-lua/plenary.nvim' },
    -- }}}

    -- harpoon {{{
    { 'ThePrimeagen/harpoon', requires = 'nvim-lua/plenary.nvim' },
    -- }}}

    -- nvim-cmp {{{
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/nvim-cmp',
    -- }}}

    -- luasnip {{{
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',
    -- }}}

    -- fidget {{{
    'j-hui/fidget.nvim',
    -- }}}

    -- nui {{{
    'MunifTanjim/nui.nvim',
    -- }}}

    -- mason {{{
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    -- }}}

    -- refactoring {{{
    'ThePrimeagen/refactoring.nvim',
    -- }}}

    -- lsp-kind {{{
    'onsails/lspkind-nvim',
    -- }}}

    -- lua-dev {{{
    "folke/lua-dev.nvim",
    -- }}}

    -- gitsigns {{{
    'lewis6991/gitsigns.nvim',
    -- }}}

    -- hop {{{
    'phaazon/hop.nvim',
    -- }}}

    -- todo-comments {{{
    {
        "folke/todo-comments.nvim",
        requires = "nvim-lua/plenary.nvim",
    },
    -- }}}

    -- popup {{{
    { 'nvim-lua/popup.nvim', requires = 'nvim-lua/plenary.nvim' },
    -- }}}

    -- cheatsheet {{{
    {
        'sudormrfbin/cheatsheet.nvim',

        requires = {
            { 'nvim-telescope/telescope.nvim' },
            { 'nvim-lua/popup.nvim' },
            { 'nvim-lua/plenary.nvim' },
        }
    },
    -- }}}

    -- devicons {{{
    'kyazdani42/nvim-web-devicons',
    -- }}}

    -- lualine {{{
    {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    },
    -- }}}

    -- indent-blackline {{{
    "lukas-reineke/indent-blankline.nvim",
    -- }}}

    -- firenvim {{{
    {
        'glacambre/firenvim',
        run = function() vim.fn['firenvim#install'](0) end
    },
    -- }}}

    -- undotree {{{
    'mbbill/undotree',
    -- }}}

    -- zig.vim {{{
    'ziglang/zig.vim',
    -- }}}

    -- wiki.vim {{{
    {
        'lervag/wiki.vim',
        config = function()
            vim.cmd [[set rtp+=/opt/homebrew/opt/fzf]]
        end
    },
    -- }}}

    -- vim-laravel {{{
    'noahfrederick/vim-laravel',
    -- }}}

    -- rust.vim {{{
    'rust-lang/rust.vim',
    -- }}}

    -- nvim-surround {{{
    'kylechui/nvim-surround',
    -- }}}

    -- Comment.nvim {{{
    'numToStr/Comment.nvim',
    -- }}}

    -- vim-eunuch {{{
    'tpope/vim-eunuch',
    -- }}}

    -- tagbar {{{
    'majutsushi/tagbar',
    -- }}}

    -- vim-markdown {{{
    'tpope/vim-markdown',
    -- }}}

    -- vim-abolish {{{
    'tpope/vim-abolish',
    -- }}}

    -- emmet-vim {{{
    'mattn/emmet-vim',
    -- }}}

    -- alpha-nvim {{{
    'goolord/alpha-nvim',
    -- }}}

    -- vim-blade {{{
    'jwalton512/vim-blade',
    -- }}}

    -- vim-repeat {{{
    'tpope/vim-repeat',
    -- }}}

    -- typescript-vim {{{
    'leafgarland/typescript-vim',
    -- }}}

    -- zen-mode.nvim {{{
    'folke/zen-mode.nvim',
    -- }}}

    -- yats.vim {{{
    'HerringtonDarkholme/yats.vim',
    -- }}}

    -- vim-jsx-improve {{{
    'neoclide/vim-jsx-improve',
    -- }}}

    -- vim-jsx-pretty {{{
    'MaxMEllon/vim-jsx-pretty',
    -- }}}

    -- nvcode-color-schemes.vim {{{
    'christianchiarulli/nvcode-color-schemes.vim',
    -- }}}

    -- nim.vim {{{
    'zah/nim.vim',
    -- }}}

    -- nvim-navbuddy {{{
    {
        "SmiteshP/nvim-navbuddy",
        dependencies = {
            "neovim/nvim-lspconfig",
            "SmiteshP/nvim-navic",
            "MunifTanjim/nui.nvim"
        },
        keys = {
          { "<leader>gn", "<cmd>Navbuddy<cr>", desc = "Navbuddy" },
        },
    },
    {
        "Bryley/neoai.nvim",
        dependencies = {
            "MunifTanjim/nui.nvim",
        },
        cmd = {
            "NeoAI",
            "NeoAIOpen",
            "NeoAIClose",
            "NeoAIToggle",
            "NeoAIContext",
            "NeoAIContextOpen",
            "NeoAIContextClose",
            "NeoAIInject",
            "NeoAIInjectCode",
            "NeoAIInjectContext",
            "NeoAIInjectContextCode",
        },
        keys = {
            { "<leader><leader>n",  '<cmd>NeoAI<CR>', desc = "NeoAI" },
        },
        config = function()
            require("neoai").setup({
                -- Options go here
            })
        end,
    }
    -- }}}
})
