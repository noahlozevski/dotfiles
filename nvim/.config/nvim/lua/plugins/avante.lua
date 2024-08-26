return {
    "yetone/avante.nvim",
    event = "VeryLazy",
    build = "make",
    cond = function()
        return vim.env.ANTHROPIC_API_KEY ~= nil
    end,
    config = function()
        -- Default splitting will cause your main splits to jump when opening an edgebar.
        -- To prevent this, set `splitkeep` to either `screen` or `topline`.
        vim.opt.splitkeep = "screen"

        require('avante').setup({
            ---@alias Provider "openai" | "claude" | "azure"  | "copilot" | [string]
            provider = "claude",
            claude = {
                endpoint = "https://api.anthropic.com",
                model = "claude-3-5-sonnet-20240620",
                temperature = 0,
                max_tokens = 4096,
            },
            mappings = {
                -- ask = "<leader>aa",
                -- edit = "<leader>ae",
                -- refresh = "<leader>ar",
                --- @class AvanteConflictMappings
                diff = {
                    ours = "co",
                    theirs = "ct",
                    none = "c0",
                    both = "cb",
                    next = "]x",
                    prev = "[x",
                },
                jump = {
                    next = "]]",
                    prev = "[[",
                },
            },
            hints = { enabled = true },
            windows = {
                wrap = true,          -- similar to vim.o.wrap
                width = 30,           -- default % based on available width
                sidebar_header = {
                    align = "center", -- left, center, right for title
                    rounded = true,
                },
            },
            highlights = {
                ---@type AvanteConflictHighlights
                diff = {
                    current = "DiffText",
                    incoming = "DiffAdd",
                },
            },
            --- @class AvanteConflictUserConfig
            diff = {
                debug = false,
                autojump = true,
                ---@type string | fun(): any
                list_opener = "copen",
            },
        })
    end,
    dependencies = {
        "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
        "stevearc/dressing.nvim",
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        --- The below is optional, make sure to setup it properly if you have lazy=true
        {
            'MeanderingProgrammer/render-markdown.nvim',
            opts = {
                file_types = { "markdown", "Avante" },
            },
            ft = { "markdown", "Avante" },
        },
    },
}
