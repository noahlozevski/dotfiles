vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = 'Toggle [U]ndotree' })
-- vim.g.undotree_WindowLayout = 2
vim.g.undotree_SplitWidth = 40
vim.g.undotree_SetFocusWhenToggle = 1

return {
    'mbbill/undotree',
    cmd = 'UndotreeToggle',
}
