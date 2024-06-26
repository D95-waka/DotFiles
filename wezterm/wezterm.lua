local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- functions
local function scheme_for_appearance(appearance)
	if appearance:find "Dark" then
		return "Catppuccin Macchiato"
	else
		return "Catppuccin Latte"
	end
end

-- Behevior
config.bidi_enabled = true
config.bidi_direction = 'LeftToRight'

-- Appearance
config.color_scheme = scheme_for_appearance(wezterm.gui.get_appearance())
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
config.font = wezterm.font_with_fallback {
	'monospace',
	'Liberation Mono'
}
config.use_fancy_tab_bar = false

-- Keybindings
config.leader = { key = 'a', mods = 'CTRL|SHIFT', timeout_milliseconds = 1000 }
config.mouse_bindings = {
  {
    event = { Down = { streak = 1, button = { WheelUp = 1 } } },
    action = wezterm.action.ScrollByLine(-1)
  },
  {
    event = { Down = { streak = 1, button = { WheelDown = 1 } } },
    action = wezterm.action.ScrollByLine(1)
  }
}

return config
