return {
    {
        {
            'folke/trouble.nvim',
            dependencies = { 'nvim-tree/nvim-web-devicons' },
            opts = {
                position = 'bottom',
                height = 10,
                icons = true,
                mode = 'document_diagnostics',
                fold_open = '',
                fold_closed = '',
                group = true,
                padding = true,
                cycle_results = true,
                action_keys = {
                    -- Add custom key mappings here
                    close = 'q',
                    cancel = '<esc>',
                    refresh = 'r',
                    jump = { '<cr>', '<tab>' },
                    toggle_fold = { 'zA', 'za' },
                },
                indent_lines = true,
                auto_open = false,
                auto_close = false,
                auto_preview = true,
                auto_fold = false,
                use_diagnostic_signs = true,
            },
            keys = {
                { '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>',                        desc = 'Diagnostics (Trouble)' },
                { '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',           desc = 'Buffer Diagnostics (Trouble)' },
                { '<leader>cs', '<cmd>Trouble symbols toggle focus=false<cr>',                desc = 'Symbols (Trouble)' },
                { '<leader>cl', '<cmd>Trouble lsp toggle focus=false win.position=right<cr>', desc = 'LSP Definitions / references / ... (Trouble)' },
                { '<leader>xL', '<cmd>Trouble loclist toggle<cr>',                            desc = 'Location List (Trouble)' },
                { '<leader>xQ', '<cmd>Trouble qflist toggle<cr>',                             desc = 'Quickfix List (Trouble)' },
            },
        },
    }
}
