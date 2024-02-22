local tabs = require("modules.tabs")
local keys = require("modules.keybindings")

local M = {}

function M.init(config)
	tabs.init(config)
	keys.init(config)
end

return M
