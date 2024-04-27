local wezterm = require 'wezterm'
config = wezterm.config_builder()

-- Behevior
config.bidi_enabled = true
config.bidi_direction = 'LeftToRight'

-- Appearance
config.color_scheme = 'Catppuccin Macchiato'
config.hide_tab_bar_if_only_one_tab = true
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0
}
config.inactive_pane_hsb = {
  saturation = 0.9,
  brightness = 0.8
}
config.window_background_opacity = 0.7
config.font = wezterm.font_with_fallback{
	'monospace',
	'Liberation Mono'
}
config.use_fancy_tab_bar = false

-- Keybindings
config.leader = { key = 'a', mods = 'CTRL|SHIFT', timeout_milliseconds = 1000 }

return config
