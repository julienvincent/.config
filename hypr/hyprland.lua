-- Fallback in-case config breaks during boot and I need to get a terminal up and running
hl.bind("CTRL + ALT + SUPER + T", hl.dsp.exec_cmd("ghostty +new-window"))

hl.on("hyprland.start", function()
  hl.exec_cmd("uwsm-app -- wl-paste --watch cliphist store")
end)

require("hyperland.compat")
require("hyperland.monitors")
require("hyperland.ui")
require("hyperland.input")

require("hyperland.keybinds")
require("hyperland.rules")
