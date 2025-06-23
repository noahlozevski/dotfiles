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
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
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
  }

}
