hl.gesture({
  fingers = 3,
  direction = "horizontal",
  action = "workspace",
})

hl.config({
  input = {
    kb_layout = "us",
    kb_variant = "",
    kb_model = "",
    kb_options = "",
    kb_rules = "",
    repeat_delay = 400,
    repeat_rate = 30,
    follow_mouse = 0,
    sensitivity = 0,
    touchpad = {
      natural_scroll = true,
      clickfinger_behavior = true,
      scroll_factor = 0.5,
      tap_to_click = false,
    },
  },
})

hl.device({
  name = "apple-mtp-keyboard",
  kb_options = "caps:escape",
})
