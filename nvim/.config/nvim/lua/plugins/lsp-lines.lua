-- default diagnostic config
local config = {
    underline = true,
    virtual_text = true,
    virtual_lines = false,
}
vim.diagnostic.config(config)

vim.keymap.set("", "<leader>dl", function()
    if not config.virtual_lines then
        config.virtual_lines = { only_current_line = true }
    else
        config.virtual_lines = false
    end
    vim.diagnostic.config(config)
end, {
    desc = "Toggle [d]iagnostic virtual [l]ines"
})

vim.keymap.set("", "<leader>dt", function()
    config.virtual_text = not config.virtual_text
    vim.diagnostic.config(config)
end, {
    desc = "Toggle [d]iagnostic virual text [t]ext"
})

vim.keymap.set("", "<leader>du", function()
    config.underline = not config.underline
    vim.diagnostic.config(config)
end, {
    desc = "Toggle [d]iagnostic [u]nderline"
})

-- vim.keymap.set("", "<leader>l", function()
--     if config.virtual_lines then
--         config.virtual_lines = false
--         config.virtual_text = true
--         config.underline = false
--     else
--         config.virtual_lines = true
--         config.virtual_text = true
--         config.underline = true
--     end
--     vim.diagnostic.config(config)
-- end, {
--     desc = "Toggle diagnostic settings"
-- })

return {
    'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
    event = 'VeryLazy',
    config = function()
        require("lsp_lines").setup({
            virtual_lines = false
        })
    end
}
