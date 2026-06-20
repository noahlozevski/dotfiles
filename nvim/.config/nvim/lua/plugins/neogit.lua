return {
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = {
      "DiffviewOpen",
      "DiffviewFileHistory",
      "DiffviewClose",
      "DiffviewToggleFiles",
      "DiffviewFocusFiles",
      "DiffviewRefresh",
    },
    keys = {
      -- { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Git diff view" },
      -- { "<leader>gD", "<cmd>DiffviewOpen HEAD~1..HEAD<cr>", desc = "Git diff last commit" },
      -- { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "Git file history" },
      -- { "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "Git repo history" },
      -- { "<leader>gq", "<cmd>DiffviewClose<cr>", desc = "Close diff view" },
    },
    opts = {},
  },
}
