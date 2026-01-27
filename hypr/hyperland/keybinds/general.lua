hl.bind("SUPER + CTRL + Q", hl.dsp.exec_cmd("loginctl lock-session"))
hl.bind("SUPER + Q", hl.dsp.window.close())
hl.bind("SUPER + M", hl.dsp.exit())

hl.bind("SUPER + J", hl.dsp.layout("togglesplit"))
hl.bind("SUPER + P", hl.dsp.window.float({ action = "toggle" }))
hl.bind(
  "SUPER + F",
  hl.dsp.window.fullscreen({
    action = "toggle",
  })
)

hl.bind("SUPER + SPACE", hl.dsp.global("lunos:launcher"))
hl.bind("SUPER + SHIFT + grave", hl.dsp.exec_cmd("vox toggle"))

hl.bind("SUPER + A", hl.dsp.send_shortcut({ mods = "CTRL", key = "A", window = "activewindow" }))
hl.bind("SUPER + C", hl.dsp.send_shortcut({ mods = "CTRL", key = "INSERT", window = "activewindow" }))
hl.bind("SUPER + X", hl.dsp.send_shortcut({ mods = "CTRL", key = "X", window = "activewindow" }))
hl.bind("SUPER + Z", hl.dsp.send_shortcut({ mods = "CTRL", key = "Z", window = "activewindow" }))
hl.bind("SUPER + V", hl.dsp.send_shortcut({ mods = "SHIFT", key = "INSERT", window = "activewindow" }))

hl.bind("ALT + SHIFT + 2", hl.dsp.exec_cmd("hyprshot -m window"))
hl.bind("ALT + SHIFT + 3", hl.dsp.exec_cmd("hyprshot -m output"))
hl.bind("ALT + SHIFT + 4", hl.dsp.exec_cmd("hyprshot -m region"))

hl.bind(
  "XF86AudioRaiseVolume",
  hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
  { locked = true, repeating = true }
)
hl.bind(
  "XF86AudioLowerVolume",
  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
  { locked = true, repeating = true }
)
hl.bind(
  "XF86AudioMute",
  hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
  { locked = true, repeating = true }
)
hl.bind(
  "XF86AudioMicMute",
  hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
  { locked = true, repeating = true }
)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
