return {
    'ruifm/gitlinker.nvim',
    -- cmd = 'LspInfo',
    -- -- TODO: figure out issues with lazy loading
    -- event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
        'nvim-lua/plenary.nvim',
    },
    config = function()
        local actions = require("gitlinker.actions")
        local hosts = require("gitlinker.hosts")

        local callbacks = {
            ["github.com"]              = hosts.get_github_type_url,
            ["gitlab.com"]              = hosts.get_gitlab_type_url,
            ["bitbucket.org"]           = hosts.get_bitbucket_type_url,
        }

        local work_gitlinker = {
            callbacks = {}
        }
        if pcall(require, "work.gitlinker") then
            work_gitlinker = require("work.gitlinker")
        end

        require("gitlinker").setup({
            opts = {
                -- force the use of a specific remote
                remote = nil,
                add_current_line_on_normal_mode = true,
                action_callback = actions.copy_to_clipboard,
                -- print the url after performing the action
                print_url = true,
            },
            callbacks = vim.tbl_deep_extend('force', callbacks, work_gitlinker.callbacks),
            -- default mapping to call url generation with action_callback
            mappings = nil
            -- mappings = "<leader>gy"
        })

        vim.api.nvim_set_keymap('n', '<leader>gY', '<cmd>lua require"gitlinker".get_buf_range_url("n")<cr>',
            { silent = true })
        vim.api.nvim_set_keymap('v', '<leader>gY', '<cmd>lua require"gitlinker".get_buf_range_url("v")<cr>',
            { silent = true })

        vim.api.nvim_set_keymap('n', '<leader>gB',
            '<cmd>lua require"gitlinker".get_buf_range_url("n", { action_callback = require"gitlinker.actions".open_in_browser })<cr>',
            { silent = true })
        vim.api.nvim_set_keymap('v', '<leader>gB',
            '<cmd>lua require"gitlinker".get_buf_range_url("v", { action_callback = require"gitlinker.actions".open_in_browser })<cr>',
            { silent = true })
    end
}
