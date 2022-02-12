-- I'll rewrite this sometime but it works fine for now.
-- I blame Lua for being too imperative.

-- The Algorithm:
-- It's not complicated at all actually, I'm just terrible at explaining it.
--
-- 1) Make a flat list of all ingredients and their ingredients and their ingredients and etc.
-- 2) Make a dictionary mapping all those items to their ingredients.
-- 3) Make an empty list of stages.
-- 4) While the dictionary is not empty:
-- 4.1) Filter the dictionary for all items of which the ingredients are already in the previous stages.
-- 4.2) Take those items and put them into a new stage.
-- 4.3) Remove those items from the dictionary.

local lib = {}

local table = require("__flib__.table")

function table.deep1_containsall(tbl, searches)
	local searches_copy = table.array_copy(searches)
	for _, subtbl in ipairs(tbl) do
		for _, item in ipairs(subtbl) do
			local index = table.find(searches_copy, item)
			if index then
				table.remove(searches_copy, index)
			end
		end
	end
	return #searches_copy == 0
end
function table.keys(tbl)
	local keys = {}
	for key, _ in pairs(tbl) do
		table.append(keys, key)
	end
	return keys
end
function table.append(tbl, value)
	tbl[#tbl + 1] = value
end

function lib.recipe_for(player, item)
	return player.force.recipes[item]
end

function lib.recipe_stages(player, recipe)
	local items = create_ingredients_map(player, recipe)

	local stages = {}

	while table.size(items) > 0 do
		local stage_items = table.filter(items, function (ingredients)
			return table.deep1_containsall(stages, ingredients)
		end)
		local stage_items_keys = table.keys(stage_items)
		if #stage_items_keys > 0 then
			table.append(stages, stage_items_keys)
			for _, item in ipairs(stage_items_keys) do
				items[item] = nil
			end
		end
	end

	return stages
end

function create_ingredients_map(player, recipe)
	local items = {}
	for _, item in ipairs(recipe.ingredients) do
		local item_recipe = lib.recipe_for(player, item.name) or {ingredients={}}
		items[item.type .. ":" .. item.name] = table.map(item_recipe.ingredients, function (ing) return ing.type .. ":" .. ing.name end)
		items = table.shallow_merge{items, create_ingredients_map(player, item_recipe)}
	end
	return items
end

function lib.localised_item_name(item)
	local type = ""
	local name = ""
	local switch = false
	for chr in item:gmatch(".") do
		if chr == ":" then
			switch = true
		else
			if not switch then
				type = type .. chr
			else
				name = name .. chr
			end
		end
	end
	local proto = nil
	if type == "item" then
		proto = game.item_prototypes[name]
	else
		proto = game.fluid_prototypes[name]
	end
	if proto then
		return proto.localised_name
	else
		return name
	end
end

function lib.localised_recipe_products(recipe)
	ls = {""}
	
	for i, product in ipairs(recipe.products) do
		if i > 1 then
			ls[#ls + 1] = ", "
		end

		ls[#ls + 1] = lib.localised_item_name(product.type .. ":" .. product.name)
	end

	return ls
end

return lib
