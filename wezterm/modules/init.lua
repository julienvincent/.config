local term = require("modules.term-workspace")
local mouse = require("modules.mousebindings")
local keys = require("modules.keybindings")
local panes = require("modules.panes")
local theme = require("modules.theme")
local tabs = require("modules.tabs")

local M = {}

function M.init(config)
  keys.init(config)
  mouse.init(config)
  tabs.init(config)
  term.init(config)
  theme.init(config)
  panes.init()
end

return M
