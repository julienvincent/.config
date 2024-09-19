local wezterm = require("wezterm")
local panes = require("modules.panes")

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
      mods = "CMD",
      key = "b",
      action = wezterm.action_callback(panes.balance_panes("y")),
    },

    {
      mods = "CMD",
      key = "w",
      action = action.CloseCurrentPane({ confirm = false }),
    },
    {
      mods = "CMD",
      key = "t",
      action = action.SpawnCommandInNewTab({
        cwd = wezterm.home_dir,
      }),
    },

    {
      mods = "OPT|SHIFT",
      key = "LeftArrow",
      action = action.MoveTabRelative(-1),
    },
    {
      mods = "OPT|SHIFT",
      key = "RightArrow",
      action = action.MoveTabRelative(1),
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
