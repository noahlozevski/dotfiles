return {
    'github/copilot.vim',
    enabled = function()
        if vim.g.is_work then
            return false
        else
            return true
        end
    end,
    config = function()
        vim.api.nvim_set_keymap("i",
            "<C-Space>",
            'copilot#Accept("<CR>")',
            { silent = true, expr = true })
    end
}
