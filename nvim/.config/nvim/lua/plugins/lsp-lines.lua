local virtual_text_config = {
    prefix = '●',
    format = function(diagnostic)
        -- Enhanced formatting for ESLint and other sources
        if diagnostic.source == 'eslint' then
            local message = diagnostic.message
            -- Extract rule name if it's in brackets at the end
            local rule = message:match '%[(.+)%]$'
            -- Remove the rule from the message if found
            message = rule and message:gsub('%[.+%]$', '') or message
            return string.format('ESLint%s: %s', rule and string.format('[%s]', rule) or '', message)
        elseif diagnostic.source == 'typescript-tools' then
            return string.format('TS: %s', diagnostic.message)
        end
        return diagnostic.message
    end,
}

local config = {
    underline = true,
    virtual_text = virtual_text_config,
    virtual_lines = false,
    update_in_insert = false,
    severity_sort = true,

    float = {
        source = true,
        border = 'rounded',
        header = '',
        prefix = function(diagnostic, i, total)
            local icons = {
                [vim.diagnostic.severity.ERROR] = '✘',
                [vim.diagnostic.severity.WARN] = '▲',
                [vim.diagnostic.severity.INFO] = 'ℹ',
                [vim.diagnostic.severity.HINT] = '⚑',
            }
            local severities = {
                [vim.diagnostic.severity.ERROR] = 'Error',
                [vim.diagnostic.severity.WARN] = 'Warn',
                [vim.diagnostic.severity.INFO] = 'Info',
                [vim.diagnostic.severity.HINT] = 'Hint',
            }
            -- Return both the prefix string and its highlight group
            return string.format('%s %d/%d ', icons[diagnostic.severity] or '●', i, total),
                'DiagnosticSign' .. (severities[diagnostic.severity] or 'Info')
        end,
    },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = '✘',
            [vim.diagnostic.severity.WARN] = '▲',
            [vim.diagnostic.severity.INFO] = 'ℹ',
            [vim.diagnostic.severity.HINT] = '⚑',
        },
    },

}
vim.diagnostic.config(config)

local function toggle_virtual_text()
    if config.virtual_text then
        config.virtual_text = false
    else
        config.virtual_text = virtual_text_config
    end
end


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
    toggle_virtual_text()
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

-- local signs = { Error = '✘', Warn = '▲', Hint = '⚑', Info = 'ℹ' }
-- for type, icon in pairs(signs) do
--     local hl = 'DiagnosticSign' .. type
--     vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
-- end

return {
    'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
    event = 'VeryLazy',
    config = function()
        require("lsp_lines").setup({
            virtual_lines = false
        })
    end
}
