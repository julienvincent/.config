hl.window_rule({
  name = "dolphin-float",
  match = {
    class = "org.kde.dolphin",
  },
  float = true,
})

hl.window_rule({
  name = "dolphin-size",
  match = {
    class = "org.kde.dolphin",
  },
  size = "40% 40%",
})
