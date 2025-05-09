return {
  'fei6409/log-highlight.nvim',
  config = function()
    require('log-highlight').setup {
      -- The file extensions.
      extension = {
        'log',
        'txt',
        'local',
      },

      -- -- The file names or the full file paths.
      -- filename = {
      --   'messages',
      -- },

      -- The file path glob patterns, e.g. `.*%.lg`, `/var/log/.*`.
      -- Note: `%.` is to match a literal dot (`.`) in a pattern in Lua, but most
      -- of the time `.` and `%.` here make no observable difference.
      pattern = {
        '/var/log/.*',
        -- 'messages%..*',
      },

    }
  end,
}
