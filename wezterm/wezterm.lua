local wezterm = require("wezterm")

local modules = require("modules")

local config = wezterm.config_builder()

config.check_for_updates = false

config.color_scheme = "GruvboxDark"
config.font = wezterm.font("MonoLisa", {
	weight = "Medium",
})
config.font_size = 13
config.line_height = 1.2

config.freetype_load_target = "Normal"

config.window_padding = {
	left = 10,
	right = 10,
	top = 0,
	bottom = 0,
}

config.cursor_thickness = "1.5pt"

modules.init(config)

config.colors["cursor_bg"] = "#928374"

config.inactive_pane_hsb = {
  saturation = .5,
  brightness = 0.6,
}

return config
