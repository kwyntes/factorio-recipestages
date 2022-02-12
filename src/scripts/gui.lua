local rs_gui = {}

local event = require("__flib__.event")
local gui = require("__flib__.gui")
local lib = require("lib")

function rs_gui.open_gui(player, item)
	local recipe = lib.recipe_for(player, item)
	if not recipe then return end

	if player.gui.screen["rs-stages-window"] then
		player.gui.screen["rs-stages-window"].destroy()
	end

	local stages_window = create_standard_window(player, "rs-stages-window", {"rs-gui.title"})
	stages_window.window.style.size = {400, 0} -- dynamic height

	local lrp = lib.localised_recipe_products(recipe)
	stages_window.content_frame.add{type="label", caption=lrp, style="frame_title"}

	local recipe_stages = lib.recipe_stages(player, recipe)
	for index, stage_items in ipairs(recipe_stages) do
		-- TODO: Make label translatable
		stages_window.content_frame.add{type="label", caption={"rs-gui.stage", index - 1}, style="rs_stage_label"}
		local listbox = stages_window.content_frame.add{type="list-box", ignored_by_interaction=true}
		for _, stage_item in ipairs(stage_items) do
			listbox.add_item(lib.localised_item_name(stage_item))
		end
	end

	stages_window.content_frame.add{type="label", caption={"rs-gui.stage", #recipe_stages}, style="rs_stage_label"}
	local final_listbox = stages_window.content_frame.add{type="list-box", ignored_by_interaction=true}
	final_listbox.add_item(lrp)
end

function create_standard_window(player, name, title)
	local window = player.gui.screen.add{type="frame", name=name, direction="vertical"}

	local titlebar = window.add{type="flow"}
	titlebar.drag_target = window
	gui.build(
		titlebar,
		{
			{type="label", style="frame_title", caption=title, ignored_by_interaction=true},
			{type="empty-widget", style="rs_titlebar_drag_handle", ignored_by_interaction=true},
			{
				type="sprite-button",
				style="frame_action_button",
				sprite="utility/close_white",
				hovered_sprite="utility/close_black",
				clicked_sprite="utility/close_black",
				actions = {
					on_click = "close_window"
				}
			}
		}
	)

	local content_frame = window.add{type="frame", style="inside_shallow_frame_with_padding", direction="vertical"}
	return {
		window=window,
		content_frame=content_frame
	}
end

local actions = {}

function actions.close_window(e)
	e.element.parent.parent.destroy()
end

gui.hook_events(function (e)
	local action = gui.read_action(e)
	if action then
		actions[action](e)
	end
end)

return rs_gui
