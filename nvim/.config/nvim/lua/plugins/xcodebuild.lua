return {
    "wojciech-kulik/xcodebuild.nvim",
    build = "make install",
    dependencies = {
        "nvim-telescope/telescope.nvim",
        "MunifTanjim/nui.nvim",
        "stevearc/oil.nvim",           -- (optional) to manage project files
    },
    config = function()
        require("xcodebuild").setup({
            -- put some options here or leave it empty to use default settings
        })
    end,
}
