local wezterm = require("wezterm")

local function get_appearance()
  if wezterm.gui then
    return wezterm.gui.get_appearance()
  end
  return "Dark"
end

local function scheme_for_appearance(appearance)
  if appearance:find("Dark") then
    return "GruvboxDark"
  else
    return "GruvboxLight"
  end
end

local M = {
  CURRENT_SCHEME = scheme_for_appearance(get_appearance()),
}

function M.init(config)
  config.color_scheme = M.CURRENT_SCHEME

  wezterm.on("window-config-reloaded", function(window, _pane)
    local overrides = window:get_config_overrides() or {}
    local appearance = window:get_appearance()
    local scheme = scheme_for_appearance(appearance)

    if overrides.color_scheme ~= scheme then
      M.CURRENT_SCHEME = scheme

      local colors = wezterm.color.get_builtin_schemes()[scheme]

      overrides.color_scheme = scheme
      overrides.colors = {
        tab_bar = {
          background = colors.background,
        },
      }

      window:set_config_overrides(overrides)
    end
  end)
end

return M
