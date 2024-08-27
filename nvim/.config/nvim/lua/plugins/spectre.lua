local start_spectre = function()
    local spectre = require('spectre')
    spectre.toggle()
end

vim.keymap.set('n', '<leader>S', start_spectre, {
    desc = "Toggle [S]pectre"
})

return {
    "nvim-pack/nvim-spectre",
    cmd = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        -- vim.keymap.set('n', '<leader>sw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
        --     desc = "Search current word"
        -- })
        -- vim.keymap.set('v', '<leader>sw', '<esc><cmd>lua require("spectre").open_visual()<CR>', {
        --     desc = "Search current word"
        -- })
        -- vim.keymap.set('n', '<leader>sp', '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
        --     desc = "Search on current file"
        -- })
    end,
}
