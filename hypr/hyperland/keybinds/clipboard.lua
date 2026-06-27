-- Work around Hyprland send_shortcut sometimes leaving synthetic key state stuck/repeating.
-- https://github.com/hyprwm/Hyprland/discussions/14099
local function send_shortcut(opts)
  return function()
    hl.dispatch(hl.dsp.send_key_state({
      mods = opts.mods,
      key = opts.key,
      state = "down",
      window = "activewindow",
    }))

    hl.timer(function()
      hl.dispatch(hl.dsp.send_key_state({
        mods = opts.mods,
        key = opts.key,
        state = "up",
        window = "activewindow",
      }))
    end, {
      timeout = 50,
      type = "oneshot",
    })
  end
end

hl.bind("SUPER + C", send_shortcut({ mods = "CTRL", key = "INSERT" }))
hl.bind("SUPER + X", send_shortcut({ mods = "CTRL", key = "X" }))
hl.bind("SUPER + V", send_shortcut({ mods = "SHIFT", key = "INSERT" }))

hl.bind("SUPER + A", send_shortcut({ mods = "CTRL", key = "A" }))
hl.bind("SUPER + Z", send_shortcut({ mods = "CTRL", key = "Z" }))
hl.bind("SUPER + SHIFT + Z", send_shortcut({ mods = "CTRL + SHIFT", key = "Z" }))
