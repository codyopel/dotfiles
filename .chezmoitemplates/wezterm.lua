local wezterm = require 'wezterm'
local config = {}
config.default_prog = { 'elvish' }
config.enable_scroll_bar = true
config.font = wezterm.font 'NotoSansM Nerd Font Mono'
config.keys = {
    {
        key = 'r',
        mods = 'CMD|SHIFT',
        action = wezterm.action.ReloadConfiguration,
    },
    {
      key = 'w',
        mods = 'CMD|SHIFT',
        action = wezterm.action.CloseCurrentTab { confirm = false },
    },
}
config.skip_close_confirmation_for_processes_named = {
    'bash',
    'cmd.exe',
    'elvish',
    'elvish.exe',
    'powershell.exe',
    'pwsh.exe',
    'sh',
    'tmux',
    'zsh',
}
config.window_close_confirmation = 'NeverPrompt'
return config
