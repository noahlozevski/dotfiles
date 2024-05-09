--- settings
vim.opt.background = "dark"


local M = {}

-- keeping this in the after as a big file so i can toggle / modify without having to navigate
M.startCatppuccin = function()
    require("catppuccin").setup({
        flavour = "mocha", -- latte, frappe, macchiato, mocha
        background = {
            -- :h background
            light = "frappe",
            dark = "mocha"
        },
        transparent_background = false,
        show_end_of_buffer = true, -- show the '~' characters after the end of buffers
        term_colors = true,
        dim_inactive = {
            enabled = false,
            shade = "dark",
            percentage = 0.15
        },
        no_italic = false, -- Force no italic
        no_bold = false,   -- Force no bold
        styles = {
            comments = { "italic" },
            conditionals = { "italic" },
            loops = {},
            functions = {},
            keywords = {},
            strings = {},
            variables = {},
            numbers = {},
            booleans = {},
            properties = {},
            types = {},
            operators = {}
        },
        integrations = {
            -- <module> = <boolean>
            harpoon = true,
            telescope = true,
            treesitter = true,
            treesitter_context = true,
            -- barbar = true,
            mason = true,
            neotree = true,
            cmp = true,
            lsp_trouble = true
        }
    })
    vim.cmd.colorscheme("catppuccin")
end

M.startTokyoNight = function()
    require("tokyonight").setup({
        -- your configuration comes here
        -- or leave it empty to use the default settings
        style = "night",        -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
        light_style = "day",    -- The theme is used when the background is set to light
        transparent = false,    -- Enable this to disable setting the background color
        terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
        styles = {
            -- Style to be applied to different syntax groups
            -- Value is any valid attr-list value for `:help nvim_set_hl`
            comments = { italic = true },
            keywords = { italic = true },
            functions = {},
            variables = {},
            -- Background styles. Can be "dark", "transparent" or "normal"
            sidebars = "dark",            -- style for sidebars, see below
            floats = "dark",              -- style for floating windows
        },
        sidebars = { "qf", "help" },      -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
        day_brightness = 0.3,             -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
        hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
        dim_inactive = false,             -- dims inactive windows
        lualine_bold = false,             -- When `true`, section headers in the lualine theme will be bold
    })
    vim.cmd.colorscheme("tokyonight")
end

M.startTokyoNightNight = function()
    M.startTokyoNight()
    vim.cmd.colorscheme("tokyonight-night")
end

M.startTokyoNightStorm = function()
    M.startTokyoNight()
    vim.cmd.colorscheme("tokyonight-storm")
end

M.startTokyoNightDay = function()
    M.startTokyoNight()
    vim.cmd.colorscheme("tokyonight-day")
end

M.startTokyoNightMoon = function()
    M.startTokyoNight()
    vim.cmd.colorscheme("tokyonight-moon")
end

M.startOxocarbon = function()
    vim.cmd.colorscheme("oxocarbon")
end

M.startAurora = function()
    vim.cmd([[ let g:aurora_transparent = 1 ]])
    vim.cmd.colorscheme("aurora")
end

M.startRosePine = function()
    require('rose-pine').setup({
        --- @usage 'auto'|'main'|'moon'|'dawn'
        variant = 'moon',
        --- @usage 'main'|'moon'|'dawn'
        dark_variant = 'moon',

        dim_inactive_windows = false,
        extend_background_behind_borders = true,

        enable = {
            terminal = true,
            legacy_highlights = true, -- Improve compatibility for previous versions of Neovim
            migrations = true,        -- Handle deprecated options automatically
        },

        styles = {
            bold = true,
            italic = true,
            transparency = true,
        },

        -- Change specific vim highlight groups
        -- https://github.com/rose-pine/neovim/wiki/Recipes
        highlight_groups = {
            -- ColorColumn = { bg = 'rose' },
            -- Blend colours against the "base" background
            CursorLine = { bg = 'foam', blend = 10 },
            StatusLine = { fg = "rose", bg = "iris", blend = 10 },
            StatusLineNC = { fg = "subtle", bg = "surface" },
            TelescopeBorder = { fg = "highlight_high", bg = "none" },
            TelescopeNormal = { bg = "none" },
            TelescopePromptNormal = { bg = "base" },
            TelescopeResultsNormal = { fg = "subtle", bg = "none" },
            TelescopeSelection = { fg = "text", bg = "base" },
            TelescopeSelectionCaret = { fg = "rose", bg = "rose" },
        }
    })
    vim.cmd.colorscheme("rose-pine")
end

M.startRosePineMoon = function()
    M.startRosePine()
    vim.cmd.colorscheme("rose-pine-moon")
end

M.startRosePineDawn = function()
    M.startRosePine()
    require('rose-pine').setup({
        dim_nc_background = true,
        disable_background = false,
        disable_float_background = false,
    })
    vim.cmd.colorscheme("rose-pine-dawn")
end

M.startMoonfly = function()
    -- vim.g.moonflyTransparent = true
    vim.cmd.colorscheme("moonfly")
end

M.startNightfly = function()
    -- vim.g.nightflyTransparent = true
    vim.cmd.colorscheme("nightfly")
end

M.startRESETTTTT = function()
    -- reset to default
    vim.cmd.colorscheme("default")
end

M.startGithubDark = function()
    require('github-theme')
    vim.cmd.colorscheme('github_dark')
end

M.startGithubDimmed = function()
    require('github-theme')
    vim.cmd.colorscheme('github_dark_dimmed')
end

M.startGithubDarkest = function()
    require('github-theme')
    vim.cmd.colorscheme('github_dark_high_contrast')
end

M.startKanagawa = function()
    require('kanagawa').setup({ transparent = true })
    vim.cmd("colorscheme kanagawa-wave")
end

M.startKanagawaAlt = function()
    require('kanagawa').setup({})
    vim.cmd("colorscheme kanagawa-dragon")
end

M.startNeon = function()
    vim.g.neon_style = "default"
    vim.g.neon_italic_keyword = true
    vim.g.neon_italic_function = true
    -- vim.g.neon_transparent = true
    vim.cmd("colorscheme neon")
end

M.startNeonAlt = function()
    vim.g.neon_style = "doom"
    vim.g.neon_italic_keyword = true
    vim.g.neon_italic_function = true
    -- vim.g.neon_transparent = true
    vim.cmd("colorscheme neon")
end

M.startNeonDark = function()
    vim.g.neon_style = "dark"
    vim.g.neon_italic_keyword = true
    vim.g.neon_italic_function = true
    -- vim.g.neon_transparent = true
    vim.cmd("colorscheme neon")
end

--- @type {{string, function}[]}
M.themers = {
    { 'startRosePine',        M.startRosePine, },
    { 'startRosePineMoon',    M.startRosePineMoon, },
    { 'startRosePineDawn',    M.startRosePineDawn, },
    { 'startNeon',            M.startNeon, },
    { 'startNeonAlt',         M.startNeonAlt, },
    { 'startNeonDark',        M.startNeonDark, },
    { 'startKanagawaAlt',     M.startKanagawaAlt, },
    { 'startKanagawa',        M.startKanagawa, },
    { 'startCatppuccin',      M.startCatppuccin, },
    { 'startAurora',          M.startAurora, },
    { 'startMoonfly',         M.startMoonfly, },
    { 'startNightfly',        M.startNightfly, },
    { 'startTokyoNight',      M.startTokyoNight, },
    { 'startTokyoNightNight', M.startTokyoNightNight, },
    { 'startTokyoNightStorm', M.startTokyoNightStorm, },
    { 'startTokyoNightDay',   M.startTokyoNightDay, },
    { 'startTokyoNightMoon',  M.startTokyoNightMoon, },
    { 'startOxocarbon',       M.startOxocarbon, },
    { 'startGithubDarkest',   M.startGithubDarkest, },
    { 'startGithubDark',      M.startGithubDark, },
    { 'startGithubDimmed',    M.startGithubDimmed, },
    { 'startRESETTTTT',       M.startRESETTTTT, },
}

local current = 1;

M.toggle_theme = function()
    current = current + 1
    if current == #M.themers then
        current = 1
    end
    local theme = M.themers[current]
    if theme == nil then
        M.toggle_theme()
        return
    end
    theme[2]()
    M.print_theme(theme[1])
end

---@param index integer
M.set_theme = function(index)
    if index >= #M.themers or index <= 0 then
        return
    end
    local theme = M.themers[current]
    if theme == nil then
        return
    end
    theme[2]()
    M.print_theme(theme[1])
end

M.reverse_toggle_theme = function()
    current = current - 1
    if current == 0 then
        current = #M.themers - 1
    end
    local theme = M.themers[current]
    if theme == nil then
        M.toggle_theme()
        return
    end
    theme[2]()
    M.print_theme(theme[1])
end

---@param theme string
M.print_theme = function(theme)
    -- need to defer the print since it gets cleared by the theme asynchronously
    vim.defer_fn(function() print("lua " .. tostring(theme) .. "()") end, 100)
end

local color = "dark"
M.toggle_light_dark = function()
    if color == "dark" then
        vim.opt.background = "light"
        color = "light"
    elseif color == "light" then
        vim.opt.background = "dark"
        color = "dark"
    end
end

vim.keymap.set(
    "",
    "<leader>tl",
    M.toggle_light_dark,
    { desc = "Toggle light / dark mode", silent = false }
)

vim.keymap.set(
    "",
    "<leader>tt",
    M.toggle_theme,
    { desc = "Cycle themes", silent = false }
)
vim.keymap.set(
    "",
    "<leader>tr",
    M.reverse_toggle_theme,
    { desc = "Reverse cycle themes", silent = false }
)

local function init()
    M.startRosePine()
end

init()
-- we need to call the init twice, theres some race case with applying certain colors with other plugins that might be lazy loaded
vim.defer_fn(init, 100)

-- expose theme module globally
Theme = M

return M
