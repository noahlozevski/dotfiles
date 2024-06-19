local wezterm = require("wezterm")
local config = wezterm.config_builder()
config.hyperlink_rules = wezterm.default_hyperlink_rules()

config.enable_tab_bar = false
wezterm.on("toggle-tabbar", function(window, _)
    local overrides = window:get_config_overrides() or {}
    if overrides.enable_tab_bar == false then
        wezterm.log_info("tab bar shown")
        overrides.enable_tab_bar = true
    else
        wezterm.log_info("tab bar hidden")
        overrides.enable_tab_bar = false
    end
    window:set_config_overrides(overrides)
end)

local action = wezterm.action
config.keys = {
    {
        key = 'Enter',
        mods = 'CMD',
        action = action.ToggleFullScreen,
    },
    {
        key = 'e',
        mods = 'CMD|SHIFT',
        action = action.EmitEvent("toggle-tabbar"),
    }
}

config.font_size = 20
config.font = wezterm.font({
    family = 'JetBrains Mono',
    -- weight = 'Bold',
    -- italic = true,
    harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' },
})
config.color_scheme = "rose-pine-moon"
local brightnessInverse = 25
config.background = {
    {
        source = {
            File = wezterm.home_dir .. '/dotfiles/backgrounds/waifu.png',
        },
        repeat_x = 'NoRepeat',
        repeat_y = 'NoRepeat',
        hsb = { brightness = 1 / brightnessInverse },
    },
}


return config
