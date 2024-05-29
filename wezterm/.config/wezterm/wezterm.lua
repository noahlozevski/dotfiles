local wezterm = require("wezterm")
local config = wezterm.config_builder()
config.enable_tab_bar = false
config.hyperlink_rules = wezterm.default_hyperlink_rules()

local action = wezterm.action
config.keys = {
    {
        key = 'Enter',
        mods = 'CMD',
        action = action.ToggleFullScreen,
    },
}

config.font_size = 20
config.font = wezterm.font({
    family = 'JetBrains Mono',
    -- weight = 'Bold',
    -- italic = true,
    harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' },
})
config.color_scheme = "rose-pine-moon"
config.background = {
    {
        source = {
            File = '/Users/nlozevsk/dotfiles/backgrounds/eagle-background.png',
        },
        repeat_x = 'NoRepeat',
        repeat_y = 'NoRepeat',
        hsb = { brightness = 0.025 },
    },
}


return config
