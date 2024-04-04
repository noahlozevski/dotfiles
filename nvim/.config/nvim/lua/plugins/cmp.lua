return {
    'hrsh7th/nvim-cmp',
    -- event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
        { 'neovim/nvim-lspconfig' },
        { 'hrsh7th/cmp-buffer' },
        { 'hrsh7th/cmp-path' },
        { 'hrsh7th/cmp-cmdline' },
        { 'FelipeLema/cmp-async-path' },
        { 'dmitmel/cmp-cmdline-history' }, -- https://github.com/lukas-reineke/cmp-rg
        { "lukas-reineke/cmp-rg" },        -- ripgrep source for cmp, completes any text in workspace
        { 'hrsh7th/cmp-nvim-lua' },

        -- { 'hrsh7th/vim-vsnip' },       -- required for auto complete snips
        -- { 'hrsh7th/vim-vsnip-integ' }, -- required for auto compelete snips
        {
            'tzachar/cmp-fuzzy-buffer',
            dependencies = { 'hrsh7th/nvim-cmp', 'tzachar/fuzzy.nvim' }
        },
        -- {
        --     'tzachar/cmp-fuzzy-path',
        --     dependencies = { 'hrsh7th/nvim-cmp', 'tzachar/fuzzy.nvim' }
        -- },
        {
            "petertriho/cmp-git",
            dependencies = "nvim-lua/plenary.nvim"
        },
        -- for icons in completion menu
        { 'onsails/lspkind.nvim', },

        -- snippets
        { "rafamadriz/friendly-snippets" },
        {
            "L3MON4D3/LuaSnip",
            -- follow latest release.
            version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
            -- install jsregexp (optional!).
            build = "make install_jsregexp",
            dependencies = { "rafamadriz/friendly-snippets" },
        },
        { 'saadparwaiz1/cmp_luasnip' },

    },
    config = function()
        -- load custom cmp config
        require('lozevski.cmp')
    end
}
