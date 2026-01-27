hl.window_rule({
  name = "quaketerm",
  match = {
    workspace = "special:quaketerm",
  },
  border_color = "rgb(d65d0e)",
  border_size = 4,
})

hl.workspace_rule({
  workspace = "special:quaketerm",
  on_created_empty = "ghostty +new-window",
})

hl.bind("CTRL + grave", hl.dsp.workspace.toggle_special("quaketerm"))
