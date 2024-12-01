return {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
        vim.opt.list = true
        -- vim.opt.listchars:append "space:⋅"
        -- vim.opt.listchars:append "eol:↴"

        -- local highlight = {
        --     "CursorColumn",
        --     "Whitespace",
        -- }
        require("ibl").setup {}
    end
}
