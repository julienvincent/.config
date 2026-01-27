hl.bind("SUPER + SHIFT + P", hl.dsp.exec_cmd("1password --quick-access"))

hl.window_rule({
  name = "onepassword-quick-access",
  match = {
    class = "^(.*1password.*)$",
    initial_title = "1Password",
  },
  float = true,
  center = true,
  size = "40% 40%",
  stay_focused = true,
})

hl.window_rule({
  name = "numr-override",
  match = {
    class = "^(local\\.tui\\.numr).*$",
  },
  size = "30% 40%",
})

hl.bind("SUPER + SHIFT + C", hl.dsp.exec_cmd("focus-tui numr"))

hl.window_rule({
  name = "standard-tuis",
  match = {
    class = "^(local\\.tui).*$",
  },
  float = true,
  center = true,
  size = "70% 75%",
  stay_focused = true,
})

hl.bind("SUPER + SHIFT + K", hl.dsp.exec_cmd("focus-tui btm"))
hl.bind("SUPER + SHIFT + B", hl.dsp.exec_cmd("focus-tui bluetui"))
hl.bind("SUPER + SHIFT + A", hl.dsp.exec_cmd("focus-tui wiremix"))
hl.bind("SUPER + SHIFT + L", hl.dsp.exec_cmd("focus-tui yazi"))
