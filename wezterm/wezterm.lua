local wez = require("wezterm")

local modules = require("modules")

local config = wez.config_builder()

config.check_for_updates = false
config.window_close_confirmation = "AlwaysPrompt"

config.enable_kitty_graphics = true

config.color_scheme = "GruvboxDark"
config.font = wez.font("MonoLisa", {
	weight = "Medium",
})
config.font_size = 13
config.line_height = 1.1

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
config.colors["cursor_border"] = "#928374"
config.colors["split"] = "#928374"

config.underline_thickness = "1.2pt"
config.underline_position = "150%"

config.selection_word_boundary = " \t\n{}[]()\"'`*:"

config.inactive_pane_hsb = {
	saturation = 0.5,
	brightness = 0.6,
}

config.term = "wezterm"

return config
