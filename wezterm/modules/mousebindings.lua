local wezterm = require("wezterm")

local M = {}

function M.init(config)
	local action = wezterm.action
	config.mouse_bindings = {
		{
			event = { Up = { streak = 1, button = "Left" } },
			mods = "NONE",
			action = action({ ExtendSelectionToMouseCursor = "Cell" }),
		},

		{
			event = { Up = { streak = 2, button = "Left" } },
			mods = "NONE",
			action = "Nop",
		},

		{
			event = { Up = { streak = 1, button = "Left" } },
			mods = "CMD",
			action = "OpenLinkAtMouseCursor",
		},
	}
end

return M
