local function switch_workspace(workspace_id)
  return function()
    hl.dispatch(hl.dsp.focus({ workspace = tostring(workspace_id) }))

    local workspace = hl.get_active_special_workspace()
    if workspace then
      hl.dispatch(hl.dsp.workspace.toggle_special(workspace.name:gsub("^special:", "")))
    end
  end
end

for i = 1, 10 do
  local key = i % 10

  hl.bind("SUPER + " .. key, switch_workspace(i))
  hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ workspace = tostring(i) }))
end

hl.bind("SUPER + ALT + CTRL + comma", hl.dsp.focus({ workspace = "e-1" }))
hl.bind("SUPER + ALT + CTRL + period", hl.dsp.focus({ workspace = "e+1" }))

hl.bind("CTRL + ALT + left", hl.dsp.workspace.move({ monitor = "l" }))
hl.bind("CTRL + ALT + right", hl.dsp.workspace.move({ monitor = "r" }))
