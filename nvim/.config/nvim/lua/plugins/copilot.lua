return {
  'zbirenbaum/copilot.lua',
  lazy = true,
  config = function()
    vim.g.copilot_assume_mapped = true
    vim.api.nvim_set_keymap("i", "<C-Space>", '<Plug>(copilot-accept-line)', { silent = true, expr = true })
  end,
  init = function()
    vim.g.copilot_assume_mapped = true
    vim.g.copilot_enabled = false

    local function start_copilot()
      vim.cmd("Lazy load copilot.lua")
      vim.g.copilot_enabled = true
      require('copilot').setup({
        panel = {
          enabled = true,
          auto_refresh = false,
          keymap = {
            jump_prev = "[[",
            jump_next = "]]",
            accept = "<C-y>",
          },
          layout = {
            position = "bottom",
            ratio = 0.4,
          },
        },
        suggestion = {
          enabled = true,
          auto_trigger = true,
          debounce = 75,
          keymap = {
            accept = "<C-y>",
            accept_word = false,
            accept_line = false,
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = false,
          },
        },
        filetypes = {
          yaml = false,
          markdown = false,
          help = false,
          gitcommit = false,
          gitrebase = false,
          hgcommit = false,
          svn = false,
          cvs = false,
          ["."] = false,
          ["Config"] = false,
        },
        copilot_node_command = 'node', -- Node.js version must be > 18.x
        server_opts_overrides = {},
      })
    end

    local allowedWorkspaces = {
      "DoubleSecret2",
      "am2",
      "am3",
      "vision-mono-repo",
      "dotfiles"
    }
    local currentWorkspace = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
    local autoStart = false

    if not vim.g.is_work then
      autoStart = true
    else
      for _, ws in ipairs(allowedWorkspaces) do
        if currentWorkspace == ws then
          autoStart = true
          break
        end
      end
    end

    if autoStart then
      vim.api.nvim_create_autocmd("InsertEnter", {
        callback = function()
          vim.notify("starting copilot")
          start_copilot()
        end,
        group = vim.api.nvim_create_augroup("start_copilot", { clear = true }),
      })
    else
      vim.api.nvim_create_user_command('CopilotStart', start_copilot, {})
    end
  end
}

