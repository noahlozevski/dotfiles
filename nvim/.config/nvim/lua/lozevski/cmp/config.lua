-- only configure cmp plugins here (dont make dependencies on lsp)
-- require('lsp-zero.cmp').extend()

-- helper for luasnip
local has_words_before = function()
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local cmp = require('cmp')
local luasnip = require('luasnip')
require('luasnip.loaders.from_vscode').lazy_load()

local compare = require('cmp.config.compare')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local function border(hl_name)
    return {
        { "╭", hl_name },
        { "─", hl_name },
        { "╮", hl_name },
        { "│", hl_name },
        { "╯", hl_name },
        { "─", hl_name },
        { "╰", hl_name },
        { "│", hl_name },
    }
end

local fuzzy_buffer_conf = {
    name = 'fuzzy_buffer',
    keyword_length = 4,
    priority_weight = 1,
    option = {
        max_matches = 2,
        -- pull from all loaded buffers
        get_bufnrs = function()
            local bufs = {}
            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                local buftype = vim.api.nvim_buf_get_option(buf, 'buftype')
                if buftype ~= 'nofile' and buftype ~= 'prompt' then
                    bufs[#bufs + 1] = buf
                end
            end
            return bufs
        end
    }
}

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
        { name = 'cmp_git',    priority_weight = 1000 },
        { name = 'async_path', priority_weight = 100 },
        { name = "rg",         priority_weight = 1 },
        fuzzy_buffer_conf,
    })
})

cmp.setup.cmdline({ '?', '/' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'nvim_lsp_document_symbol', priority_weight = 1000 },
    }, {
        { name = "rg",           priority_weight = 1 },
        { name = 'fuzzy_buffer', priority_weight = 1, option = { max_matches = 5, }, }
    })
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
            { name = 'cmdline',         priority_weight = 1000 },
            { name = 'async_path',      priority_weight = 100 },
            -- { name = 'zsh', },
            { name = "cmdline_history", priority_weight = 100 },
            { name = "rg",              priority_weight = 1 },
        },
        {
            fuzzy_buffer_conf
        })
})

local opts = {
    experimental = {
        ghost_text = false,
    },
    formatting = {
        fields = { "abbr", "kind", "menu" },
        format = function(entry, vim_item)
            local kind = require("lspkind").cmp_format({
                mode = "symbol_text",
                maxwidth = 40,
                ellipsis_char = '..',
                preset = 'default',
                -- show_labelDetails = true,
            })(entry, vim_item)

            local strings = vim.split(kind.kind, "%s", { trimempty = true })
            kind.kind = " " .. (strings[1] or "") .. " "
            local menu = ({
                buffer = "Buffer",
                fuzzy_buffer = "Buffer",
                nvim_lsp = "LSP",
                -- vsnip = "VSnip",
                nvim_lua = "Lua",
            })[entry.source.name] or strings[2] or ""

            -- Display which LSP servers this item came from.
            local lspserver_name = nil
            pcall(function()
                lspserver_name = entry.source.source.client.name
                -- vim_item.menu = lspserver_name
            end)
            if lspserver_name == nil then
                lspserver_name = menu
            end

            kind.menu = "(" .. (lspserver_name) .. ")"
            return vim_item
        end,
    },
    snippet = {
        -- -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    window = {
        completion = cmp.config.window.bordered({
            winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None",
            -- col_offset = -3,
            side_padding = 0,
            scrollbar = true,
        }),
        documentation = cmp.config.window.bordered({
            border = border "CmpDocBorder",
            winhighlight = "Normal:CmpDoc",
        }),
    },
    sorting = {
        priority_weight = 2,
        comparators = {
            cmp.config.compare.score,
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            function(entry1, entry2)
                local kind_priority = {
                    nvim_lsp = 1,
                    luasnip = 2,
                    buffer = 1000,
                    fuzzy_buffer = 1000,
                    path = 4,
                    cmdline = 5,
                    rg = 6,
                }
                local kind1 = kind_priority[entry1.source.name] or 100
                local kind2 = kind_priority[entry2.source.name] or 100
                return kind1 < kind2
            end,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
        },
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        ['<C-y>'] = cmp.mapping(function(fallback)
            if cmp.visible() and cmp.get_active_entry() then
                cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
            elseif vim.g.copilot_enabled and require("copilot.suggestion").is_visible() then
                require("copilot.suggestion").accept()
            elseif luasnip.expand_or_locally_jumpable() then
                luasnip.expand_or_jump()
            else
                cmp.confirm({ select = false })
                -- fallback()
            end
        end, { "i", "s" }),
        -- manually trigger the completion window
        ["<C-Space>"] = cmp.mapping.complete(),
        ['<C-b>'] = cmp.mapping.scroll_docs(4),
        ['<C-f>'] = cmp.mapping.scroll_docs(-4),
        -- close the suggestion menu
        ['<C-e>'] = cmp.mapping.abort(),
        -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        ['<CR>'] = cmp.mapping.confirm({ select = false }),
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() and cmp.get_active_entry() then
                cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
            elseif vim.g.copilot_enabled and require("copilot.suggestion").is_visible() then
                require("copilot.suggestion").accept()
            elseif luasnip.expand_or_locally_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp',                priority_weight = 1000 },
        { name = 'nvim_lua',                priority_weight = 1000 },
        { name = 'nvim_lsp_signature_help', priority_weight = 500 },
        { name = 'path',                    priority_weight = 100 },
        { name = "rg",                      priority_weight = 100, keyword_length = 4, },
        { name = 'luasnip',                 priority_weight = 50 },
        fuzzy_buffer_conf,
    })
}


cmp.setup(opts)
cmp.setup.cmdline(opts)
cmp.setup.buffer(opts)
