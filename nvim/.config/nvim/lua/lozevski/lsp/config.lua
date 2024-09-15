local lsp = require('lsp-zero').preset({})

lsp.ensure_installed({
  -- add more servers / languages
  'tsserver',
  -- 'eslint',
  'rust_analyzer',
  'lua_ls',
  'clangd',
  'efm',
  'tailwindcss',
})

lsp.nvim_workspace()

-- local cmp = require('cmp')
-- local cmp_select = { behavior = cmp.SelectBehavior.Select }
-- local cmp_mappings = lsp.defaults.cmp_mappings({
--     ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
--     ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
--     ['<C-y>'] = cmp.mapping.confirm({ select = true }),
--     -- ["<C-Space>"] = cmp.mapping.complete(),
-- })

-- cmp_mappings['<Tab>'] = nil
-- cmp_mappings['<S-Tab>'] = nil

-- lsp.setup_nvim_cmp({
--     mapping = cmp_mappings
-- })

lsp.set_preferences({
  suggest_lsp_servers = true,
  sign_icons = {
    error = '✘',
    warn = '▲',
    hint = '⚑',
    info = '»'
  }
})

-- -- These languages will be formatted on save + will be loaded on start
-- local allowed_format_servers = {
--     -- 'tsserver',
--     -- 'eslint',
--     'clangd',
--     'rust_analyzer',
--     'lua_ls',
--     -- 'null-ls',
--     -- 'html',
--     -- 'css'
--     -- 'prettier',
-- }
-- local function allow_format(servers)
--     return function(client) return vim.tbl_contains(servers, client.name) end
-- end

local function on_attach(client, bufnr)
  lsp.default_keymaps({ buffer = bufnr })
end

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = args.buf, desc = "LSP: Hover" })
    vim.keymap.set('i', '<C-h>', vim.lsp.buf.signature_help, { buffer = args.buf, desc = "LSP: Signature help" })
    vim.keymap.set('n', 'gC', vim.lsp.buf.declaration, { buffer = args.buf, desc = "LSP: Go to declaration" })
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = args.buf, desc = "LSP: Go to definition" })
    vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, { buffer = args.buf, desc = "LSP: Go to type definition" })
    vim.keymap.set('n', 'gI', vim.lsp.buf.implementation, { buffer = args.buf, desc = "LSP: Go to implementation" })
    vim.keymap.set('n', 'dr', vim.lsp.buf.references, { buffer = args.buf, desc = "LSP: Find references" })
    vim.keymap.set('n', 'dn', vim.lsp.buf.rename, { buffer = args.buf, desc = "LSP: Rename" })
    vim.keymap.set('n', '<leader>da', vim.lsp.buf.code_action, { buffer = args.buf, desc = "LSP: Code action" })

    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { buffer = args.buf, desc = "LSP: Next diagnostic" })
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { buffer = args.buf, desc = "LSP: Previous diagnostic" })
    vim.keymap.set('n', '<leader>do', vim.diagnostic.open_float,
      { buffer = args.buf, desc = "LSP: Open diagnostic float" })

    vim.api.nvim_create_user_command('Dllist', vim.diagnostic.setloclist, {})
    vim.api.nvim_create_user_command('Dclist', vim.diagnostic.setqflist, {})
  end,
})
lsp.on_attach = on_attach

vim.diagnostic.config({
  -- virtual_text = {
  --     source = 'if_many',
  --     prefix = '●',
  -- },
  virtual_text = true,
  severity_sort = true,
})

-- Set up lspconfig for each server
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local lspconfig = require('lspconfig')
-- local configured_servers = {
--     -- 'tsserver',
--     -- 'eslint',
--     'clangd',
--     'rust_analyzer',
--     'lua_ls',
--     'kotlin_language_server',
--     -- 'shfmt',
--     -- 'null-ls',
-- }

-- for i, server in ipairs(configured_servers) do
--     -- lspconfig[server].setup {
--     --     on_attach = on_attach,
--     --     capabilities = capabilities
--     -- }
-- end

local function filter(arr, fn)
  if type(arr) ~= "table" then
    return arr
  end

  local filtered = {}
  for k, v in pairs(arr) do
    if fn(v, k, arr) then
      table.insert(filtered, v)
    end
  end

  return filtered
end

local function filterReactDTS(value)
  return string.match(value.targetUri, '%.d.ts') == nil
end

--- warning: dont override this unless necessary to debug
local default_handlers = vim.lsp.handlers
-- local times = 0
-- for handler, fallback in pairs(vim.lsp.handlers) do
--     default_handlers[handler] = function(err, result, method, ...)
--         times = times + 1
--         if times < 100 then
--             print(handler)
--             print(vim.inspect(result))
--         end
--
--         fallback(err, result, method, ...)
--
--         -- vim.lsp.handlers[handler] = function(err, result, method, ...)
--         -- vim.notify('hello')
--         -- vim.notify(vim.inspect(result))
--         -- vim.lsp.handlers[handler](err, result, method, ...)
--     end
-- end

-- sql brings in some whacky commands
-- this disables this
-- search for sql.vim in :scriptnames
vim.g.omni_sql_no_default_maps = false

require("mason").setup()
require("mason-lspconfig").setup_handlers {
  -- The first entry (without a key) will be the default handler
  -- and will be called for each installed server that doesn't have
  -- a dedicated handler.
  -- default handler (optional)
  function(server_name)
    require("lspconfig")[server_name].setup {
      on_attach = on_attach,
      capabilities = capabilities,
      -- handlers = default_handlers
    }
  end,
  -- Next, you can provide a dedicated handler for specific servers.
  -- For example, a handler override for the `rust_analyzer`:
  ["clangd"] = function()
    lspconfig.clangd.setup {
      on_attach = on_attach,
      capabilities = capabilities,
      cmd = {
        "clangd",
        "--offset-encoding=utf-16",
      },
      -- handlers = default_handlers
    }
  end,
  ["jdtls"] = function()
    lspconfig.jdtls.setup {
      autostart = false,
      -- handlers = default_handlers
    }
    -- pass on configing this plugin, this is triggered when opening java files
  end,
  ["tsserver"] = function()
    -- for handler, v in pairs(vim.lsp.handlers) do
    --     vim.notify(handler)
    --     vim.lsp.handlers[handler] = function(err, result, method, ...)
    --         vim.notify('hello')
    --         vim.notify(vim.inspect(result))
    --         vim.lsp.handlers[handler](err, result, method, ...)
    --     end
    -- end

    lspconfig.tsserver.setup {
      on_attach = on_attach,
      capabilities = capabilities,
      filetypes = { 'javascript', 'javascriptreact', 'javascript.jsx', 'typescript', 'typescriptreact',
        'typescript.tsx' },
      handlers = {
        -- ['textDocument/declaration'] = function(err, result, method, ...)
        -- end,
        ['textDocument/declaration'] = function(err, result, method, ...)
          vim.lsp.handlers['workspaceSymbol/resolve'](err, result, method, ...)
          if vim.tbl_islist(result) and #result > 1 then
            local filtered_result = filter(result, filterReactDTS)
            return vim.lsp.handlers['textDocument/definition'](err, filtered_result, method, ...)
          end
        end,
        ['textDocument/definition'] = function(err, result, method, ...)
          if vim.tbl_islist(result) and #result > 1 then
            local filtered_result = filter(result, filterReactDTS)
            return vim.lsp.handlers['textDocument/definition'](err, filtered_result, method, ...)
          end
          vim.lsp.handlers['textDocument/definition'](err, result, method, ...)
        end

        -- handlers = default_handlers
      }
    }
  end,
  -- ["eslint"] = function()
  --   lspconfig.eslint.setup {
  --     on_attach = on_attach,
  --     capabilities = capabilities,
  --     filetypes = { 'javascript', 'javascriptreact', 'javascript.jsx', 'typescript', 'typescriptreact',
  --       'typescript.tsx' },
  --     -- handlers = default_handlers
  --   }
  -- end,
  -- zig config
  ["zls"] = function()
    local auto_format_on_save = false
    -- this is brought in by the vim-zig plugin dependency from the zig lsp
    vim.g.zig_fmt_autosave = auto_format_on_save

    local zig_config = {
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        enable_autofix = auto_format_on_save,
        enable_build_on_save = false
      }
    }

    -- overrides for zvm
    local zvm_dir = vim.env.HOME .. '/.zvm'
    if vim.fn.isdirectory(zvm_dir) then
      zig_config = vim.tbl_deep_extend('force', zig_config, {
        cmd = {
          -- join the home path with /.zvm
          zvm_dir .. '/bin/zls'
        },
        settings = {
          zig_lib_path = zvm_dir .. '/master/lib',
          zig_exe_path = zvm_dir .. '/bin/zig',
          -- build_runner_path = '/Users/noahlozevski/Library/Caches/zls/build_runner_0.12.0.zig',
          -- global_cache_path = '/Users/noahlozevski/Library/Caches/zls',
          -- build_runner_global_cache_path = '/Users/noahlozevski/.cache/zig',
        }
      })
    end

    lspconfig.zls.setup(zig_config)
  end,
  ["lua_ls"] = function()
    -- Fixes the undefined vim global annoyance
    lspconfig.lua_ls.setup {
      settings = {
        Lua = {
          diagnostics = {
            -- Get the language server to recognize the `vim` global
            globals = {
              'vim',
              'augroup',
              'require'
            },
          },
          telemetry = {
            enable = false,
          },
        },
      },
      -- handlers = default_handlers
    }
  end,
  ["efm"] = function()
    -- local eslint = require('efmls-configs.linters.eslint_d')
    -- choose prettier_d if it is runnable / accessible
    local prettier
    if vim.fn.executable('prettierd') == 1 then
      prettier = require('efmls-configs.formatters.prettier_d')
    else
      prettier = require('efmls-configs.formatters.prettier')
    end

    local eslint
    if vim.fn.executable('eslint_d') == 1 then
      eslint = require('efmls-configs.formatters.eslint_d')
    else
      eslint = require('efmls-configs.formatters.eslint')
    end

    -- EFM formatting language specs
    local languages = require('efmls-configs.defaults').languages()

    -- default to using the other eslint server
    local servers = { prettier, eslint }

    languages = vim.tbl_extend('force', languages, {
      typescript = servers,
      ["typescript.jsx"] = servers,
      typescriptreact = servers,
      javascript = servers,
      ["javascript.jsx"] = servers,
      javascriptreact = servers,
      json = servers,
      markdown = servers,
      html = servers,
    })

    -- need to remove the stupid defaults efm adds on top of prettier that conflict with the settings defined in repo-specific prettier configs
    -- personal neovim settings should not be mixed with lsp settings
    local function remove_lsp_format_defaults(format_cmd)
      -- efmls will pass any of these LSP formatting options from the neovim config here:
      -- https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#formattingOptions
      -- add more properties as these become defined / cause problems
      local strs = {
        "tabSize",
        -- "insertSpaces",
        -- "trimTrailingWhitespace",
        -- "insertFinalNewLine",
        -- "trimFinalNewlines"
      }

      local result = format_cmd
      for _, prop in ipairs(strs) do
        if string.find(result, prop) then
          result = string.gsub(result, "${[%S]-" .. prop .. "[%S]-}", "")
        end
      end
      return result
    end

    for lang, lang_config in pairs(languages) do
      for _, fmt_config in pairs(lang_config) do
        local before = fmt_config["formatCommand"]
        if before ~= nil then
          local updated_cmd = remove_lsp_format_defaults(before)
          -- if updated_cmd ~= before then
          --     vim.print("Lang: " .. lang .. "Changed command before: " .. before)
          --     vim.print("after: " .. updated_cmd)
          --     vim.print("--")
          -- end
          if updated_cmd ~= nil and updated_cmd ~= "" then
            fmt_config["formatCommand"] = updated_cmd
          end
        end
      end
    end

    -- manual lsp config must come after mason-lspconfig
    -- EFM for eslint / prettier / formatting stuff
    lspconfig.efm.setup {
      filetypes = vim.tbl_keys(languages),
      init_options = {
        documentFormatting = true,
        documentRangeFormatting = true,
      },
      settings = {
        rootMarkers = { ".git/" },
        languages = languages
      },
      -- handlers = default_handlers
    }
  end,
}


-- require("lspconfig").clangd.setup {
--     on_attach = on_attach,
--     capabilities = capabilities,
--     cmd = {
--         "clangd",
--         "--offset-encoding=utf-16",
--     },
-- }



-- lspconfig.tsserver.setup {
--     on_attach = on_attach,
--     capabilities = capabilities,
--     filetypes = { 'javascript', 'javascriptreact', 'javascript.jsx', 'typescript', 'typescriptreact', 'typescript.tsx' },
--     handlers = {
--         ['textDocument/definition'] = function(err, result, method, ...)
--             if vim.tbl_islist(result) and #result > 1 then
--                 local filtered_result = filter(result, filterReactDTS)
--                 return vim.lsp.handlers['textDocument/definition'](err, filtered_result, method, ...)
--             end
--
--             vim.lsp.handlers['textDocument/definition'](err, result, method, ...)
--         end
--
--     }
-- }

-- lspconfig.eslint.setup {
--     on_attach = on_attach,
--     capabilities = capabilities,
--     filetypes = { 'javascript', 'javascriptreact', 'javascript.jsx', 'typescript', 'typescriptreact', 'typescript.tsx' },
-- }
-- -- Fixes the undefined vim global annoyance
-- lspconfig.lua_ls.setup {
--     settings = {
--         Lua = {
--             diagnostics = {
--                 -- Get the language server to recognize the `vim` global
--                 globals = {
--                     'vim',
--                     'augroup',
--                     'require'
--                 },
--             },
--             telemetry = {
--                 enable = false,
--             },
--         },
--     },
-- }


local function get_store_kit_lsp_path()
  local isMac = vim.loop.os_uname().sysname == "Darwin"
  if isMac then
    local sourceKitPath = vim.fn.system("xcrun --find sourcekit-lsp")
    if sourceKitPath then
      return sourceKitPath:gsub("%s+", "")
    end
  end
  return "sourcekit-lsp"
end



-- swift lsp setup, needs to be seperate from mason since sourcekit isnt supported there
local swift_lsp = vim.api.nvim_create_augroup("swift_lsp", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "swift" },
  callback = function()
    local root_dir = vim.fs.dirname(vim.fs.find({
      "Package.swift",
      ".git"
    }, { upward = true })[1])
    local sourceKitPath = get_store_kit_lsp_path()
    local client = vim.lsp.start({
      name = "sourcekit-lsp",
      cmd = { sourceKitPath },
      root_dir = root_dir,
    })
    vim.lsp.buf_attach_client(0, client)
  end,
  group = swift_lsp,
})


pcall(require, 'work.lsp')

lsp.setup()

---gets the lsp of a given server name attached to the current buffer
---@param server_name string
---@returns lsp
function get_lsp(server_name)
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.buf_get_clients(bufnr)

  for client_id, client in pairs(clients) do
    if client.name == server_name then
      local params = vim.lsp.util.make_position_params()
      vim.lsp.buf_request(bufnr, 'textDocument/definition', params, function(err, result, ctx, config)
        -- if result and vim.tbl_islist(result) and #result > 0 then
        --   vim.lsp.util.jump_to_location(result[1], client.offset_encoding)
        -- elseif result then
        --   vim.lsp.util.jump_to_location(result, client.offset_encoding)
        -- end
      end, client_id)
      return       -- Stop after finding the first matching client
    end
  end
end

return {
  on_attach = on_attach
}
