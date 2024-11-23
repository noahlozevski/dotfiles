return {
    'zbirenbaum/copilot.lua',
    lazy = true,
    -- enabled = function()
    --     if vim.g.is_work then
    --         return false
    --     else
    --         return true
    --     end
    -- end,
    config = function()
        vim.g.copilot_assume_mapped = true

        vim.api.nvim_set_keymap("i",
            "<C-Space>",
            '<Plug>(copilot-accept-line)',
            { silent = true, expr = true })
    end,
    init = function()
        vim.g.copilot_assume_mapped = true
        vim.g.copilot_enabled = false

        -- Starts the copilot client
        function start_copilot()
            vim.cmd("Lazy load copilot.lua")
            vim.g.copilot_enabled = true
            require('copilot').setup({
                panel = {
                    enabled = true,
                    auto_refresh = false,
                    keymap = {
                        jump_prev = "[[",
                        jump_next = "]]",
                        accept = "<C-y>",
                        -- refresh = "gr",
                        -- open = "<M-CR>"
                    },
                    layout = {
                        position = "bottom", -- | top | left | right
                        ratio = 0.4
                    },
                },
                suggestion = {
                    enabled = true,
                    auto_trigger = true,
                    debounce = 75,
                    keymap = {
                        accept = "<C-y>",
                        accept_word = false,
                        accept_line = false,
                        next = "<M-]>",
                        prev = "<M-[>",
                        dismiss = false
                        -- dismiss = "<C-]>",
                    },
                },
                filetypes = {
                    yaml = false,
                    markdown = false,
                    help = false,
                    gitcommit = false,
                    gitrebase = false,
                    hgcommit = false,
                    svn = false,
                    cvs = false,
                    ["."] = false,
                    ["Config"] = false
                    -- ["*"] = false, disables all other files
                },
                copilot_node_command = 'node', -- Node.js version must be > 18.x
                server_opts_overrides = {},
            })
        end

        vim.api.nvim_create_user_command('CopilotStart', start_copilot, {})

        -- if the the lua file at lozevski.work is callable, then call the start_copilot function
        if vim.g.is_work then
            -- load work config
        else
            -- auto start copilot on insert enter
            vim.api.nvim_create_autocmd("InsertEnter", {
                callback = function()
                    vim.notify("strting copilot")
                    start_copilot()
                end,
                group = vim.api.nvim_create_augroup("start_copilot", { clear = true }),
            })
        end
    end
}
