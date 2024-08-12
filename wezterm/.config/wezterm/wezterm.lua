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


local brightnessInverse = 25

local background_blur = 1
local blur_states = {
    { background_blur = 15 },
    { background_blur = 5 },
    { background_blur = 0 },
    { background_blur = 25 },
}

local opacity_state = 1
local opacity_states = {
    { opacity = 0.70 },
    { opacity = 0.80 },
    { opacity = 0.95 },
    { opacity = 0.60 },
}

local function get_background()
    local base_config = {
        {
            source = {
                File = wezterm.home_dir .. '/dotfiles/backgrounds/waifu.png',
            },
            repeat_x = 'NoRepeat',
            repeat_y = 'NoRepeat',
            hsb = { brightness = 1 / brightnessInverse },
            opacity = opacity_states[opacity_state].opacity
        },
    }
    return base_config
end

local function refresh(window)
    local overrides = window:get_config_overrides() or {}
    overrides.background = get_background()
    overrides.macos_window_background_blur = blur_states[background_blur].background_blur
    window:set_config_overrides(overrides)
end

wezterm.on("toggle-opacity", function(window, _)
    opacity_state = opacity_state + 1
    if opacity_state > #opacity_states then
        opacity_state = 1
    end
    refresh(window)
end)

wezterm.on("toggle-blur", function(window, _)
    background_blur = background_blur + 1
    if background_blur > #blur_states then
        background_blur = 1
    end
    refresh(window)
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
config.macos_window_background_blur = blur_states[background_blur].background_blur
config.window_decorations = "RESIZE"
config.background = get_background()

config.font_size = 20
config.font = wezterm.font({
    family = 'JetBrains Mono',
    -- weight = 'Bold',
    -- italic = true,
    harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' },
})
config.color_scheme = "rose-pine-moon"


return config
