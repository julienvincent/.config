local theme = require("modules.theme")
local wezterm = require("wezterm")

local M = {}

local function tab_title(tab_info)
	local title = tab_info.tab_title
	-- if the tab title is explicitly set, take that
	if title and #title > 0 then
		return title
	end
	-- Otherwise, use the title from the active pane
	-- in that tab
	return tab_info.active_pane.title
end

function M.init(config)
	config.use_fancy_tab_bar = false
	config.show_tab_index_in_tab_bar = false
	config.show_new_tab_button_in_tab_bar = false
	config.tab_max_width = 50

	-- These functions are expensive and should not be called in the main event handler as it will
	-- noticeably slow down the UI.
	local workspace = wezterm.mux.get_active_workspace()
	local colors = wezterm.color.get_builtin_schemes()[theme.CURRENT_SCHEME]
	local prev_scheme = theme.CURRENT_SCHEME

	wezterm.on("format-tab-title", function(tab, tabs, _, _, hover, tab_max_width)
		if theme.CURRENT_SCHEME ~= prev_scheme then
			prev_scheme = theme.CURRENT_SCHEME
			colors = wezterm.color.get_builtin_schemes()[theme.CURRENT_SCHEME]
		end

		local tab_bar_bg = colors.background

		local active_tab_bg = "#d79921"
		local active_tab_fg = "#3c3836"

		local inactive_tab_bg = colors.background
		local inactive_tab_fg = colors.foreground

		local title = tab_title(tab)
		title = wezterm.truncate_right(title, tab_max_width)

		local icon = wezterm.nerdfonts.pl_left_hard_divider
		local icon_bg
		local icon_fg = inactive_tab_bg

		local next_tab = tabs[tab.tab_index + 2]
		local next_tab_is_active = next_tab and next_tab.is_active
		local is_last_tab = tab.tab_index + 1 == #tabs
		local is_first_tab = tab.tab_index == 0

		if tab.is_active then
			icon_fg = active_tab_bg
		end

		if is_last_tab then
			icon_bg = tab_bar_bg
		else
			icon_bg = inactive_tab_bg

			if next_tab_is_active then
				icon_bg = tab_bar_bg
				icon_fg = active_tab_bg
				icon = wezterm.nerdfonts.pl_right_hard_divider
			end

			if not tab.is_active and not next_tab_is_active then
				icon = wezterm.nerdfonts.pl_left_soft_divider
				icon = " "
				icon_fg = inactive_tab_fg
			end
		end

		local intensity = "Normal"
		if tab.is_active then
			intensity = "Bold"
		end

		local text_fg = inactive_tab_fg
		local text_bg = inactive_tab_bg
		if tab.is_active then
			text_fg = active_tab_fg
			text_bg = active_tab_bg
		end

		if hover then
			text_fg = active_tab_bg
		end

		local result = {
			{ Attribute = { Intensity = intensity } },
			{ Background = { Color = text_bg } },
			{ Foreground = { Color = text_fg } },
			{ Text = " " .. title .. " " },
			{ Background = { Color = icon_bg } },
			{ Foreground = { Color = icon_fg } },
			{ Text = icon },
		}

		if is_first_tab and workspace ~= "term" then
			if tab.is_active then
				table.insert(result, 1, { Text = wezterm.nerdfonts.pl_right_hard_divider })
			else
				table.insert(result, 1, { Text = " " })
			end

			table.insert(result, 1, { Background = { Color = tab_bar_bg } })
			table.insert(result, 1, { Foreground = { Color = active_tab_bg } })
			return result
		end

		return result
	end)
end

return M
