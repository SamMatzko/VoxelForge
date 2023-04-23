-- Made for MineClone 2 by Michieal.
-- Texture made by Michieal; The model borrows the top from NathanS21's (Nathan Salapat) Lectern model; The rest of the
-- lectern model was created by Michieal.
-- Creation date: 01/07/2023 (07JAN2023)
-- License for Code: GPL3
-- License for Media: CC-BY-SA 4
-- Copyright (C) 2023, Michieal. See: License.txt.

local S = minetest.get_translator(minetest.get_current_modname())

minetest.register_node("mcl_lectern:lectern", {
	description = S("Lectern"),
	_tt_help = S("Lecterns not only look good, but are job site blocks for Librarians."),
	_doc_items_longdesc = S("Lecterns not only look good, but are job site blocks for Librarians."),
	_doc_items_usagehelp = S("Place the Lectern on a solid node for best results. May attract villagers, so it's best to place outside of where you call 'home'."),
	sounds = mcl_sounds.node_sound_wood_defaults(),
	paramtype = "light",
	use_texture_alpha = minetest.features.use_texture_alpha_string_modes and "opaque" or false,
	paramtype2 = "facedir",
	drawtype = "mesh",
	mesh = "mcl_lectern_lectern.obj",
	tiles = {"mcl_lectern_lectern.png", },
	groups = {handy = 1, axey = 1, flammable = 2, fire_encouragement = 5, fire_flammability = 5, solid = 1},
	sunlight_propagates = true,
	walkable = true,
	is_ground_content = false,
	node_placement_prediction = "",
	_mcl_blast_resistance = 3,
	_mcl_hardness = 2,
	selection_box = {
		type = "fixed",
		fixed = {
			--   L,    T,    Ba,    R,    Bo,    F.
			{-0.32, 0.46, -0.32, 0.32, 0.175, 0.32},
			{-0.18, 0.175, -0.055, 0.18, -0.37, 0.21},
			{-0.32, -0.37, -0.32, 0.32, -0.5, 0.32},
		}
	},
	collision_box = {
		type = "fixed",
		fixed = {
			--   L,    T,    Ba,    R,    Bo,    F.
			{-0.32, 0.46, -0.32, 0.32, 0.175, 0.32},
			{-0.18, 0.175, -0.055, 0.18, -0.37, 0.21},
			{-0.32, -0.37, -0.32, 0.32, -0.5, 0.32},
		}
	},

	on_place = function(itemstack, placer, pointed_thing)
		-- Use pointed node's on_rightclick function first, if present
		local node = minetest.get_node(pointed_thing.under)
		if placer and not placer:get_player_control().sneak then
			if minetest.registered_nodes[node.name] and minetest.registered_nodes[node.name].on_rightclick then
				return minetest.registered_nodes[node.name].on_rightclick(pointed_thing.under, node, placer, itemstack) or itemstack
			end
		end

		if minetest.is_protected(pointed_thing.above, placer:get_player_name()) then
			minetest.record_protection_violation(pointed_thing.above, pname)
			return
		end

		if minetest.dir_to_wallmounted(vector.subtract(pointed_thing.under,  pointed_thing.above)) == 1 then
			local _, success = minetest.item_place_node(itemstack, placer, pointed_thing, minetest.dir_to_facedir(vector.direction(placer:get_pos(),pointed_thing.above)))
			if not success then
				return
			end
			if not minetest.is_creative_enabled(placer:get_player_name()) then
				itemstack:take_item()
			end
		end
		return itemstack
	end,
})

mcl_wip.register_wip_item("mcl_lectern:lectern")

-- April Fools setup
local date = os.date("*t")
if (date.month == 4 and date.day == 1) then
	minetest.override_item("mcl_lectern:lectern", {waving = 2})
end

minetest.register_craft({
	output = "mcl_lectern:lectern",
	recipe = {
		{"group:slab", "group:slab", "group:slab"},
		{"", "mcl_books:bookshelf", ""},
		{"", "group:slab", ""},
	}
})
