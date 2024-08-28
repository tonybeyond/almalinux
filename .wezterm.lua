local wezterm = require 'wezterm'

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

-- Set PowerShell as the default program
config.default_prog = {"powershell.exe", "-NoLogo"}

-- Launch Menu configuration
config.launch_menu = {
    {
        label = "PowerShell",
        args = {"powershell.exe", "-NoLogo"},
    },
    {
        label = "Command Prompt",
        args = {"cmd.exe"},
    },
    {
        label = "WSL",
        args = {"wsl.exe", "--cd", "~"},
    },
    {
        label = "Git Bash",
        args = {"C:\\Program Files\\Git\\bin\\bash.exe", "-l"},
    },
}

-- Key bindings
config.keys = {
    {
        key = 'l',
        mods = 'ALT',
        action = wezterm.action.ShowLauncher,
    },
}

-- Mouse bindings for right-click paste on Windows
config.mouse_bindings = {
    {
        event = { Down = { streak = 1, button = "Right" } },
        mods = "NONE",
        action = wezterm.action.PasteFrom("Clipboard"),
    },
}

return config
