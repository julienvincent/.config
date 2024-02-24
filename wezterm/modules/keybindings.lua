local wezterm = require("wezterm")

local M = {}

function M.init(config)
	local action = wezterm.action
	config.keys = {
		{
			mods = "CMD",
			key = "d",
			action = action.SplitHorizontal({
				cwd = wezterm.home_dir,
			}),
		},
		{
			mods = "CMD|SHIFT",
			key = "d",
			action = action.SplitVertical({
				cwd = wezterm.home_dir,
			}),
		},
		{
			mods = "CMD|SHIFT",
			key = "Enter",
			action = action.TogglePaneZoomState,
		},

		{
			key = "w",
			mods = "CMD",
			action = action.CloseCurrentPane({ confirm = false }),
		},

		{
			key = "LeftArrow",
			mods = "CMD|ALT",
			action = action.ActivatePaneDirection("Left"),
		},
		{
			key = "RightArrow",
			mods = "CMD|ALT",
			action = action.ActivatePaneDirection("Right"),
		},
		{
			key = "UpArrow",
			mods = "CMD|ALT",
			action = action.ActivatePaneDirection("Up"),
		},
		{
			key = "DownArrow",
			mods = "CMD|ALT",
			action = action.ActivatePaneDirection("Down"),
		},

		{
			mods = "CMD|SHIFT",
			key = "LeftArrow",
			action = action.ActivateTabRelative(-1),
		},
		{
			mods = "CMD|SHIFT",
			key = "RightArrow",
			action = action.ActivateTabRelative(1),
		},
	}
end

return M
