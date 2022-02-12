local event = require("__flib__.event")
local rs_gui = require("scripts.gui")

event.register("rs-open", function (e)
	if not e.selected_prototype then return end

	local player = game.get_player(e.player_index)
	local item = e.selected_prototype.name
	rs_gui.open_gui(player, item)
end)
