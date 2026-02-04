-- Helper that only runs a command if it’s defined:
local function safe_cmd(cmd)
  -- vim.fn.exists(':'..name) returns 2 if a user Ex command exists
  if vim.fn.exists(':' .. cmd) == 2 then
    vim.cmd(cmd)
  end
end

return {
  {
    'dstein64/vim-startuptime',
    cmd = 'StartupTime',
    init = function()
      vim.g.startuptime_tries = 10
    end
  },
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
      { "tsakirist/telescope-lazy.nvim" },
    }
  },

  {
    "iamcco/markdown-preview.nvim",
    ft = "markdown",
    -- :MarkdownPreview
    -- build = "cd app && yarn install",
    build = ":call mkdp#util#install()",
  },


  { 'ThePrimeagen/vim-be-good',   cmd = "VimBeGood", },
  'nvim-lua/plenary.nvim',

  -- Themes
  { 'rose-pine/neovim',           name = 'rose-pine' },
  { "bluz71/vim-nightfly-colors", name = "nightfly" },
  { "bluz71/vim-moonfly-colors",  name = "moonfly" },
  'folke/tokyonight.nvim',
  'ray-x/aurora',
  'rafamadriz/neon',
  { "catppuccin/nvim",             name = "catppuccin" },
  'nyoom-engineering/oxocarbon.nvim',
  { 'projekt0n/github-nvim-theme', },
  { 'rebelot/kanagawa.nvim' },

  { 'airblade/vim-gitgutter',      dependencies = { 'tpope/vim-fugitive' } },
  {
    -- Autoformat
    'stevearc/conform.nvim',
    lazy = false,
    keys = {
      {
        '<leader>f',
        function()
          vim.notify('Formatting buffer...', vim.log.levels.INFO)
          require('conform').format { async = true, lsp_fallback = true }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_after_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        -- run the command LspEslintFixAll to fix linting issues (if it is available)
        safe_cmd('LspEslintFixAll')
        return {
          timeout_ms = 500,
          lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
        }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        -- Conform can also run multiple formatters sequentially
        -- python = { "isort", "black" },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        ["typescript.jsx"] = { "prettierd", "prettier", stop_after_first = true },
        typescriptreact = { "prettierd", "prettier", stop_after_first = true },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        ["javascript.jsx"] = { "prettierd", "prettier", stop_after_first = true },
        javascriptreact = { "prettierd", "prettier", stop_after_first = true },
        json = { "prettierd", "prettier", stop_after_first = true },
        markdown = { "prettierd", "prettier", stop_after_first = true },
        html = { "prettierd", "prettier", stop_after_first = true },
      },
    },
  },
  {
    'supermaven-inc/supermaven-nvim',
    config = function()
      require("supermaven-nvim").setup({
        keymaps = {
          accept_suggestion = "<Tab>",
          clear_suggestion = "<C-]>",
          accept_word = "<C-j>",
        },
        -- ignore_filetypes = { cpp = true }, -- or { "cpp", }
        -- color = {
        --   suggestion_color = "#ffffff",
        --   cterm = 244,
        -- },
        log_level = "info",                -- set to "off" to disable logging completely
        disable_inline_completion = false, -- disables inline completion for use with cmp
        disable_keymaps = false,           -- disables built in keymaps for more manual control
        -- condition to check for stopping supermaven, `true` means to stop supermaven when the condition is true.
        condition = function()
          if os.getenv("SUPERMAVEN_DISABLED") == "1" or vim.fn.expand("%:t") == "nlozevsk" then
            return true
          end
          return false
        end
      })
    end,
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.icons' },        -- if you use standalone mini plugins
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  }
}
