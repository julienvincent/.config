hl.bind("SUPER + SHIFT + P", hl.dsp.exec_cmd("1password --quick-access"))

hl.window_rule({
  name = "onepassword-quick-access",
  match = {
    class = "^(.*1password.*)$",
    initial_title = "1Password",
  },
  float = true,
  center = true,
  size = { "(monitor_w*0.4)", "(monitor_h*0.5)" },
  stay_focused = true,
})

hl.window_rule({
  name = "numr-override",
  match = {
    class = "^(local\\.tui\\.numr).*$",
  },
  size = { "(monitor_w*0.3)", "(monitor_h*0.5)" },
})

hl.bind("SUPER + SHIFT + C", hl.dsp.exec_cmd("focus-tui numr"))

hl.window_rule({
  name = "standard-tuis",
  match = {
    class = "^(local\\.tui).*$",
  },
  float = true,
  center = true,
  size = { "(monitor_w*0.7)", "(monitor_h*0.75)" },
  stay_focused = true,
})

hl.bind("SUPER + SHIFT + K", hl.dsp.exec_cmd("focus-tui btm"))
hl.bind("SUPER + SHIFT + B", hl.dsp.exec_cmd("focus-tui bluetui"))
hl.bind("SUPER + SHIFT + A", hl.dsp.exec_cmd("focus-tui wiremix"))
hl.bind("SUPER + SHIFT + L", hl.dsp.exec_cmd("focus-tui yazi"))
