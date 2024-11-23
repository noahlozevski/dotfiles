return {
    'hrsh7th/nvim-cmp',
    -- event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
        { 'neovim/nvim-lspconfig' },
        {
            'j-hui/fidget.nvim',
            opts = {
                notification = {
                    window = {
                        winblend = 0, -- Background color opacity in the notification window
                    },
                },
                integration = {
                    ["nvim-tree"] = {
                        enable = true,
                    },
                    ["xcodebuild-nvim"] = {
                        enable = true,
                    },
                },

                logger = {
                    level = vim.log.levels.WARN, -- Minimum logging level
                    max_size = 10000,            -- Maximum log file size, in KB
                    float_precision = 0.01,      -- Limit the number of decimals displayed for floats
                    path = string.format("%s/fidget.nvim.log", vim.fn.stdpath("cache")),
                },
            }
        },
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
