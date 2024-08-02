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

local background_blur = 15
wezterm.on("toggle-blur", function(window, _)
    local overrides = window:get_config_overrides() or {}
    if overrides.macos_window_background_blur == 0 then
        overrides.macos_window_background_blur = background_blur
    else
        overrides.macos_window_background_blur = 0
    end
    window:set_config_overrides(overrides)
end)


local brightnessInverse = 25
local get_background = function(state)
    return {
        {
            source = {
                File = wezterm.home_dir .. '/dotfiles/backgrounds/waifu.png',
            },
            repeat_x = 'NoRepeat',
            repeat_y = 'NoRepeat',
            hsb = { brightness = 1 / brightnessInverse },
            opacity = state and 0.95 or 0.80,
        },
    }
end

local opacity_state = false
wezterm.on("toggle-opacity", function(window, _)
    local overrides = window:get_config_overrides() or {}
    if opacity_state == true then
        opacity_state = false
        overrides.background = get_background(opacity_state)
    else
        opacity_state = true
        overrides.background = get_background(opacity_state)
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
    },
    {
        key = 'b',
        mods = 'CMD|SHIFT',
        action = action.EmitEvent("toggle-blur"),
    },
    {
        key = 'o',
        mods = 'CMD|SHIFT',
        action = action.EmitEvent("toggle-opacity"),
    },
    {
        key = 'd',
        mods = 'CMD',
        action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
    },
    {
        key = 'd',
        mods = 'CMD|SHIFT',
        action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
    },
}

config.window_background_opacity = 0.95
config.macos_window_background_blur = background_blur
config.window_decorations = "RESIZE"
config.background = get_background(opacity_state)

config.font_size = 20
config.font = wezterm.font({
    family = 'JetBrains Mono',
    -- weight = 'Bold',
    -- italic = true,
    harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' },
})
config.color_scheme = "rose-pine-moon"


return config
