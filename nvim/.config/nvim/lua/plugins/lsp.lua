return {
  "mason-org/mason-lspconfig.nvim",
  -- TODO: figure out issues with lazy loading
  -- the lsp needs to load before cmp to keep everything working right
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    { 'hrsh7th/cmp-nvim-lsp' }, -- Required
    { "mason-org/mason.nvim", },
    { "neovim/nvim-lspconfig", },
    { 'lukas-reineke/lsp-format.nvim' }, -- Required for async format on save
    { 'hrsh7th/cmp-nvim-lsp-signature-help' },
    { 'hrsh7th/cmp-nvim-lsp-document-symbol' },
    {
      'creativenull/efmls-configs-nvim',
      version = 'v1.x.x', -- version is optional, but recommended
      dependencies = { 'neovim/nvim-lspconfig' },
    }
  },
  config = function()
    -- load lsp config
    require('lozevski.lsp')
  end
}
