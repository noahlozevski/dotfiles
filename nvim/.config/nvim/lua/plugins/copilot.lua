return {
    'github/copilot.vim',
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
            'copilot#Accept("<CR>")',
            { silent = true, expr = true })
    end,
    init = function()
        vim.g.copilot_assume_mapped = true

        -- Starts the copilot client
        function start_copilot()
            vim.cmd("Lazy load copilot.vim")
        end
    end
}
