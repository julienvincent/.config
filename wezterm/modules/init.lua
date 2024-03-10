local term = require("modules.term-workspace")
local mouse = require("modules.mousebindings")
local keys = require("modules.keybindings")
local tabs = require("modules.tabs")
local panes = require("modules.panes")

local M = {}

function M.init(config)
	keys.init(config)
	mouse.init(config)
	tabs.init(config)
	term.init(config)
	panes.init()
end

return M
