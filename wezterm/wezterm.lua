-- Pull in the wezterm API
local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.color_scheme = "GruvboxDark"
config.font = wezterm.font("MonoLisa", {
	weight = "Medium",
})
config.font_size = 13
config.line_height = 1.2

config.freetype_load_target = "Normal"

config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

config.use_fancy_tab_bar = false
config.show_tab_index_in_tab_bar = false
config.show_new_tab_button_in_tab_bar = false

function tab_title(tab_info)
	local title = tab_info.tab_title
	-- if the tab title is explicitly set, take that
	if title and #title > 0 then
		return title
	end
	-- Otherwise, use the title from the active pane
	-- in that tab
	return tab_info.active_pane.title
end

config.tab_max_width = 32

local tab_bar_bg = "#282828"

local active_tab_bg = "#d79921"
local active_tab_fg = "#282828"

local inactive_tab_bg = "#928374"
local inactive_tab_fg = "#ebdbb2"

config.colors = {
	tab_bar = {
		background = tab_bar_bg,
		active_tab = {
			bg_color = active_tab_bg,
			fg_color = active_tab_fg,
		},
		inactive_tab = {
			bg_color = inactive_tab_bg,
			fg_color = inactive_tab_fg,
		},
	},
}

wezterm.on("format-tab-title", function(tab, tabs, _panes, _config, _hover, _max_width)
	local title = tab_title(tab)
	title = wezterm.truncate_right(title, config.tab_max_width - 4)

	local icon = wezterm.nerdfonts.pl_left_hard_divider
	local icon_bg
	local icon_fg = inactive_tab_bg

	local next_tab = tabs[tab.tab_index + 2]
	local next_tab_is_active = next_tab and next_tab.is_active
	local is_last_tab = tab.tab_index + 1 == #tabs

	if tab.is_active then
		icon_fg = active_tab_bg
	end

	if is_last_tab then
		icon_bg = tab_bar_bg
	else
		icon_bg = inactive_tab_bg

		if next_tab_is_active then
			icon_bg = active_tab_bg
		end

		if not tab.is_active and not next_tab_is_active then
			icon = wezterm.nerdfonts.pl_left_soft_divider
			icon_fg = inactive_tab_fg
		end
	end

	return {
		{ Text = " " .. title .. " " },
		{ Background = { Color = icon_bg } },
		{ Foreground = { Color = icon_fg } },
		{ Text = icon },
	}
end)

config.window_padding = {
	left = 10,
	right = 10,
	top = 0,
	bottom = 0,
}

local act = wezterm.action
config.keys = {
	{
		mods = "CMD",
		key = "d",
		action = wezterm.action.SplitHorizontal,
	},
	{
		mods = "CMD|SHIFT",
		key = "d",
		action = wezterm.action.SplitVertical,
	},
	{
		key = "w",
		mods = "CMD",
		action = wezterm.action.CloseCurrentPane({ confirm = true }),
	},
	{
		mods = "CMD|SHIFT",
		key = "Enter",
		action = wezterm.action.TogglePaneZoomState,
	},

	{
		key = "LeftArrow",
		mods = "CMD|ALT",
		action = act.ActivatePaneDirection("Left"),
	},
	{
		key = "RightArrow",
		mods = "CMD|ALT",
		action = act.ActivatePaneDirection("Right"),
	},
	{
		key = "UpArrow",
		mods = "CMD|ALT",
		action = act.ActivatePaneDirection("Up"),
	},
	{
		key = "DownArrow",
		mods = "CMD|ALT",
		action = act.ActivatePaneDirection("Down"),
	},
}

-- and finally, return the configuration to wezterm
return config
