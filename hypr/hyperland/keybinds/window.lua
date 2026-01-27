hl.bind("SUPER + ALT + equal", hl.dsp.layout("colresize +.2"))
hl.bind("SUPER + ALT + minus", hl.dsp.layout("colresize -.2"))
hl.bind("CTRL + ALT + SUPER + return", hl.dsp.layout("colresize 1"))
hl.bind("SUPER + ALT + return", hl.dsp.layout("fit visible"))

hl.bind("SUPER + ALT + bracketleft", hl.dsp.layout("swapcol l"))
hl.bind("SUPER + ALT + bracketright", hl.dsp.layout("swapcol r"))

hl.bind("CTRL + ALT + SUPER + left", hl.dsp.exec_cmd("hyprctl dispatch movewindow mon:+1"))
hl.bind("CTRL + ALT + SUPER + right", hl.dsp.exec_cmd("hyprctl dispatch movewindow mon:-1"))

hl.bind("SUPER + ALT + CTRL + P", hl.dsp.layout("promote"))

hl.bind("SUPER + left", hl.dsp.layout("move -col"))
hl.bind("SUPER + right", hl.dsp.layout("move +col"))
hl.bind("SUPER + up", hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + down", hl.dsp.focus({ direction = "down" }))

hl.bind("SUPER + SHIFT + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + SHIFT + mouse:273", hl.dsp.window.resize(), { mouse = true })
