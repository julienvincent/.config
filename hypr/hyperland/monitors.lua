hl.config({
  debug = {
    disable_scale_checks = true,
    disable_logs = false,
    enable_stdout_logs = true
  },
})

hl.monitor({
  output = "eDP-1",
  mode = "3456x2234@120",
  position = "0x0",
  scale = "1.5",
})

hl.monitor({
  output = "desc:LG Electronics LG ULTRAGEAR+ 310NTBK5K805",
  mode = "3840x2160@144",
  position = "2304x0",
  scale = "1.5",
})

hl.monitor({
  output = "desc:Acer Technologies XV272U 0x0182360E",
  mode = "preferred",
  position = "4864x0",
  scale = "1",
})
