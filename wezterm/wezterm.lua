local wez = require("wezterm")

local modules = require("modules")

local config = wez.config_builder()

config.check_for_updates = false
config.window_close_confirmation = "AlwaysPrompt"

config.enable_kitty_graphics = true
config.enable_wayland = true

config.mux_enable_ssh_agent = false

-- local onep_auth =
--     string.format('%s/.1password/agent.sock', wez.home_dir)
--   -- Glob is being used here as an indirect way to check to see if
--   -- the socket exists or not. If it didn't, the length of the result
--   -- would be 0
--   if #wez.glob(onep_auth) == 1 then
--     config.default_ssh_auth_sock = onep_auth
--   end

config.font = wez.font("MonoLisa", {
  weight = "Medium",
})
config.font_size = 11
config.line_height = 1.1

config.freetype_load_target = "Normal"

config.window_padding = {
  left = 10,
  right = 10,
  top = 10,
  bottom = 0,
}

config.cursor_thickness = "1.5pt"

config.colors = {
  cursor_bg = "#928374",
  cursor_border = "#928374",
  split = "#928374",
}

modules.init(config)

config.underline_thickness = "1.2pt"
config.underline_position = "150%"

config.selection_word_boundary = " \t\n{}[]()\"'`*:"

config.inactive_pane_hsb = {
  saturation = 0.5,
  brightness = 0.6,
}

config.term = "wezterm"

config.window_decorations = "NONE"

config.window_frame = {
  border_top_height = "10",
}

config.max_fps = 120

return config
