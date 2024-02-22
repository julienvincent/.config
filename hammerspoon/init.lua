hs.hotkey.bind({ "Ctrl" }, "`", function()
	wez = hs.application.find("Wezterm")
	if wez then
		if wez:isFrontmost() then
			wez:hide()
		else
			wez_window = wez:mainWindow()

			local target_screen = hs.mouse.getCurrentScreen()

			if wez_window:screen():id() == target_screen:id() then
				print("just focusing")
				wez_window:focus()
			else
				print("moving and focusing")
				local target_space = hs.spaces.activeSpaceOnScreen(target_screen)
				hs.spaces.moveWindowToSpace(wez_window, target_space)

				wez_window:maximize(0)
				wez_window:focus()
			end
		end
	end
end)
