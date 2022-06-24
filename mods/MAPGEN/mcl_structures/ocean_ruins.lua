local modname = minetest.get_current_modname()
local S = minetest.get_translator(modname)
local modpath = minetest.get_modpath(modname)
local cold_oceans = {
	"RoofedForest_ocean",
	"BirchForestM_ocean",
	"BirchForest_ocean",
	"IcePlains_deep_ocean",
	"ExtremeHillsM_deep_ocean",
	"SunflowerPlains_ocean",
	"MegaSpruceTaiga_deep_ocean",
	"ExtremeHillsM_ocean",
	"SunflowerPlains_deep_ocean",
	"BirchForest_deep_ocean",
	"IcePlainsSpikes_ocean",
	"StoneBeach_ocean",
	"ColdTaiga_deep_ocean",
	"Forest_deep_ocean",
	"FlowerForest_deep_ocean",
	"MegaTaiga_ocean",
	"StoneBeach_deep_ocean",
	"IcePlainsSpikes_deep_ocean",
	"ColdTaiga_ocean",
	"ExtremeHills+_deep_ocean",
	"ExtremeHills_ocean",
	"Forest_ocean",
	"MegaTaiga_deep_ocean",
	"MegaSpruceTaiga_ocean",
	"ExtremeHills+_ocean",
	"RoofedForest_deep_ocean",
	"IcePlains_ocean",
	"FlowerForest_ocean",
	"ExtremeHills_deep_ocean",
	"Taiga_ocean",
	"BirchForestM_deep_ocean",
	"Taiga_deep_ocean",
}
local function ruins_placement_callback(pos, def, pr)
	local hl = def.sidelen / 2
	local p1 = vector.offset(pos,-hl,-hl,-hl)
	local p2 = vector.offset(pos,hl,hl,hl)
	local chests = minetest.find_nodes_in_area(p1, p2, "mcl_chests:chest_small")
	for c=1, #chests do
		local lootitems = mcl_loot.get_multi_loot({
		{
			stacks_min = 2,
			stacks_max = 4,
			items = {
				{ itemstring = "mcl_core:coal_lump", weight = 25, amount_min = 1, amount_max=4 },
				{ itemstring = "mcl_farming:wheat_item", weight = 25, amount_min = 2, amount_max=3 },
				{ itemstring = "mcl_core:gold_nugget", weight = 25, amount_min = 1, amount_max=3 },
				--{ itemstring = "mcl_maps:treasure_map", weight = 20, }, --FIXME Treasure map

				{ itemstring = "mcl_books:book", weight = 10, func = function(stack, pr)
					mcl_enchanting.enchant_uniform_randomly(stack, {"soul_speed"}, pr)
				end },
				{ itemstring = "mcl_fishing:fishing_rod_enchanted", weight = 20, func = function(stack, pr)
					mcl_enchanting.enchant_uniform_randomly(stack, {"soul_speed"}, pr)
				end  },
				{ itemstring = "mcl_core:emerald", weight = 15, amount_min = 1, amount_max = 1 },
				{ itemstring = "mcl_armor:chestplate_leather", weight = 15, amount_min = 1, amount_max = 1 },
				{ itemstring = "mcl_core:apple_gold", weight = 20, },
				{ itemstring = "mcl_armor:helmet_gold", weight = 15, amount_min = 1, amount_max = 1 },
				{ itemstring = "mcl_core:gold_ingot", weight = 15, amount_min = 2, amount_max = 7 },
				{ itemstring = "mcl_core:iron_ingot", weight = 15, amount_min = 1, amount_max = 5 },
				{ itemstring = "mcl_core:apple_gold_enchanted", weight = 2, },
			}
		}}, pr)
		mcl_structures.init_node_construct(chests[c])
		local meta = minetest.get_meta(chests[c])
		local inv = meta:get_inventory()
		mcl_loot.fill_inventory(inv, "main", lootitems, pr)
	end
end

mcl_structures.register_structure("cold_ocean_ruins",{
	place_on = {"group:sand","mcl_core:gravel","mcl_core:dirt","mcl_core:clay","group:material_stone"},
	spawn_by = {"mcl_core:water_source"},
	num_spawn_by = 2,
	noise_params = {
		offset = 0,
		scale = 0.0000812,
		spread = {x = 250, y = 250, z = 250},
		seed = 146315,
		octaves = 3,
		persist = -0.2,
		flags = "absvalue",
	},
	flags = "place_center_x, place_center_z, force_placement",
	solid_ground = true,
	make_foundation = true,
	y_offset = 0,
	y_min = mcl_vars.mg_overworld_min,
	y_max = 1,
	biomes = cold_oceans,
	chunk_probability = 64,
	sidelen = 4,
	filenames = {
		modpath.."/schematics/mcl_structures_ocean_ruins_cold_1.mts",
		modpath.."/schematics/mcl_structures_ocean_ruins_cold_2.mts",
		modpath.."/schematics/mcl_structures_ocean_ruins_cold_3.mts",
	},
	after_place = ruins_placement_callback
})
