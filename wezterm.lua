local wezterm = require("wezterm")

local config = {}
if wezterm.config_builder then
        config = wezterm.config_builder()
end

-- Color scheme
config.color_scheme = "Catppuccin Mocha"

-- Font configuration
config.font = wezterm.font("Hack Nerd Font", { weight = "Medium", stretch = "Normal", style = "Normal" })
config.font_size = 13.0

-- Window configuration
config.window_background_opacity = 0.98
config.window_padding = {
        left = 2,
        right = 2,
        top = 2,
        bottom = 2,
}
-- Tab Bar
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true

-- Launch Menu configuration
config.launch_menu = {
        {
                label = "Bash",
                args = { "bash", "-l" },
        },
        {
                label = "B-Top",
                args = { "/opt/homebrew/bin/btop" },
        },
}

-- Key bindings
config.keys = {
        {
                key = "l",
                mods = "ALT",
                action = wezterm.action.ShowLauncher,
        },
}

-- Mouse bindings for two-finger click paste on macOS
config.mouse_bindings = {
        -- Paste with two-finger click (which is treated as a right click on macOS)
        {
                event = { Down = { streak = 1, button = "Right" } },
                mods = "NONE",
                action = wezterm.action.PasteFrom("Clipboard"),
        },
}

return config
