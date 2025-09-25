return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  build = "make",
  cond = function()
    return vim.env.ANTHROPIC_API_KEY ~= nil or vim.env.OPENAI_API_KEY ~= nil
  end,
  config = function()
    -- Default splitting will cause your main splits to jump when opening an edgebar.
    -- To prevent this, set `splitkeep` to either `screen` or `topline`.
    vim.opt.splitkeep = "screen"

    require('avante').setup({
      ---@alias Provider "openai" | "claude" | "azure"  | "copilot" | [string]
      -- provider = "openai",
      provider = "claude",
      providers = {
        -- openai = {
        --   model = "gpt-5",
        --   timeout = 30000,     -- Timeout in milliseconds, increase this for reasoning models
        --   context_window = 128000, -- Number of tokens to send to the model for context
        --   extra_request_body = {
        --     temperature = 0.75,
        --     max_completion_tokens = 16384, -- Increase this to include reasoning tokens (for reasoning models)
        --     reasoning_effort = "medium", -- low|medium|high, only used for reasoning models
        --   },
        -- }
        claude = {
          endpoint = "https://api.anthropic.com",
          model = "claude-sonnet-4-20250514",
          timeout = 30000, -- Timeout in milliseconds
          extra_request_body = {
            temperature = 0.75,
            max_tokens = 20480,
          },
        },
      },
      prompt_logger = {
        enabled = false,
      },
      mappings = {
        ask = "<leader>aa",
        edit = "<leader>ae",
        refresh = "<leader>ar",
        --- @class AvanteConflictMappings
        diff = {
          ours = "co",
          theirs = "ct",
          all_theirs = "ca",
          both = "cb",
          cursor = "cc",
          next = "]x",
          prev = "[x",
        },
        suggestion = {
          accept = "<M-l>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
        jump = {
          next = "]]",
          prev = "[[",
        },
        submit = {
          normal = "<CR>",
          insert = "<C-s>",
        },
        cancel = {
          normal = { "<C-c>", "<Esc>", "q" },
          insert = { "<C-c>" },
        },
        sidebar = {
          apply_all = "A",
          apply_cursor = "a",
          retry_user_request = "r",
          edit_user_request = "e",
          switch_windows = "<Tab>",
          reverse_switch_windows = "<S-Tab>",
          remove_file = "d",
          add_file = "@",
          close = { "<Esc>", "q" },
          close_from_input = nil, -- e.g., { normal = "<Esc>", insert = "<C-d>" }
        },
      },
      hints = { enabled = false },
      windows = {
        ---@type "right" | "left" | "top" | "bottom"
        position = "right", -- the position of the sidebar
        wrap = true,        -- similar to vim.o.wrap
        width = 50,         -- default % based on available width
        sidebar_header = {
          enabled = false,  -- true, false to enable/disable the header
          align = "center", -- left, center, right for title
          rounded = false,
        },
        spinner = {
          editing = { "⡀", "⠄", "⠂", "⠁", "⠈", "⠐", "⠠", "⢀", "⣀", "⢄", "⢂", "⢁", "⢈", "⢐", "⢠", "⣠", "⢤", "⢢", "⢡", "⢨", "⢰", "⣰", "⢴", "⢲", "⢱", "⢸", "⣸", "⢼", "⢺", "⢹", "⣹", "⢽", "⢻", "⣻", "⢿", "⣿" },
          generating = { "·", "✢", "✳", "∗", "✻", "✽" }, -- Spinner characters for the 'generating' state
          thinking = { "🤯", "🙄" }, -- Spinner characters for the 'thinking' state
        },
        input = {
          prefix = "> ",
          height = 8, -- Height of the input window in vertical layout
        },
        edit = {
          border = "rounded",
          start_insert = true, -- Start insert mode when opening the edit window
        },
        ask = {
          floating = false,    -- Open the 'AvanteAsk' prompt in a floating window
          start_insert = true, -- Start insert mode when opening the ask window
          border = "rounded",
          ---@type "ours" | "theirs"
          focus_on_apply = "ours", -- which diff to focus after applying
        },
      },
      highlights = {
        ---@type AvanteConflictHighlights
        diff = {
          current = "DiffText",
          incoming = "DiffAdd",
        },
      },
      suggestion = {
        debounce = 600,
        throttle = 600,
      },
      --- @class AvanteConflictUserConfig
      diff = {
        debug = false,
        autojump = true,
        ---@type string | fun(): any
        list_opener = "copen",
      },
    })
  end,
  dependencies = {
    "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    --- The below is optional, make sure to setup it properly if you have lazy=true
    -- {
    --   'MeanderingProgrammer/render-markdown.nvim',
    --   opts = {
    --     file_types = { "markdown", "Avante" },
    --   },
    --   ft = { "markdown", "Avante" },
    -- },
  },
}
