local M = {}

function M.init()
	local last_known_terminal_window_id
	local function get_last_known_terminal_window()
		if not last_known_terminal_window_id then
			return
		end
		return hs.window.get(last_known_terminal_window_id)
	end

	local function spawn_terminal_window(app)
		local cmd = "/opt/homebrew/bin/wezterm"
		local args = { "cli", "spawn", "--new-window", "--domain", "term" }
		local task = hs.task.new(cmd, nil, args)

		local previous_windows = app:allWindows()

		task:start()
		task:waitUntilExit()

		local windows = app:allWindows()
		while #windows < (#previous_windows + 1) do
			windows = app:allWindows()
		end

		local new_window
		for _, window in pairs(windows) do
			local exists = false
			for _, previous_window in pairs(previous_windows) do
				if previous_window:id() == window:id() then
					exists = true
				end
			end
			if not exists then
				new_window = window
			end
		end

		last_known_terminal_window_id = new_window:id()
		return new_window
	end

	local function find_front_window(screen_id)
		local windows = hs.window.orderedWindows()
		for _, window in pairs(windows) do
			if window:screen():id() == screen_id then
				return window
			end
		end
	end

	local last_focused_window_id
	local last_front_most_window_id
	hs.hotkey.bind({ "Ctrl" }, "`", function()
		local wez = hs.application.find("Wezterm")
		if not wez then
			return
		end

		local terminal_window = get_last_known_terminal_window()

		local focused_window = hs.window.focusedWindow()
		if terminal_window and terminal_window:id() == focused_window:id() then
			local last_focused_window = hs.window.get(last_focused_window_id)
			if last_focused_window then
				last_focused_window:focus()
			end
			local last_front_window = hs.window.get(last_front_most_window_id)
			if last_front_window then
				last_front_window:raise()
			end
			-- terminal_window:minimize()
			return
		end

		local target_screen = hs.mouse.getCurrentScreen()
		last_focused_window_id = focused_window:id()
		last_front_most_window_id = find_front_window(target_screen:id()):id()

		if not terminal_window then
			terminal_window = spawn_terminal_window(wez)
		end

		terminal_window:moveToScreen(target_screen)
		terminal_window:maximize(0)
		terminal_window:focus()
	end)

	local function reload_config(files)
		local do_reload = false
		for _, file in pairs(files) do
			if file:sub(-4) == ".lua" then
				do_reload = true
			end
		end
		if do_reload then
			hs.reload()
		end
	end

	hs.pathwatcher.new(os.getenv("HOME") .. "/.config/hammerspoon/", reload_config):start()
end

return M
