settlements = {}
settlements.modpath = minetest.get_modpath(minetest.get_current_modname())

local new_villages = minetest.settings:get_bool("mcl_villages_new", true)
local village_chance = tonumber(minetest.settings:get("mcl_villages_village_chance")) or 75

dofile(settlements.modpath.."/const.lua")
dofile(settlements.modpath.."/utils.lua")
dofile(settlements.modpath.."/foundation.lua")
dofile(settlements.modpath.."/buildings.lua")
dofile(settlements.modpath.."/paths.lua")
--dofile(settlements.modpath.."/convert_lua_mts.lua")

if new_villages then
	dofile(settlements.modpath .. "/api.lua")
end

--
-- load settlements on server
--
settlements.grundstellungen()

local S = minetest.get_translator(minetest.get_current_modname())

local villagegen={}
--
-- register block for npc spawn
--
minetest.register_node("mcl_villages:stonebrickcarved", {
	description = S("Chiseled Stone Village Bricks"),
	_doc_items_longdesc = doc.sub.items.temp.build,
	tiles = {"mcl_core_stonebrick_carved.png"},
	drop = "mcl_core:stonebrickcarved",
	groups = {pickaxey=1, stone=1, stonebrick=1, building_block=1, material_stone=1},
	sounds = mcl_sounds.node_sound_stone_defaults(),
	is_ground_content = false,
	_mcl_blast_resistance = 6,
	_mcl_hardness = 1.5,
})

minetest.register_node("mcl_villages:structblock", {drawtype="airlike",groups = {not_in_creative_inventory=1},})



--[[ Enable for testing, but use MineClone2's own spawn code if/when merging.
--
-- register inhabitants
--
if minetest.get_modpath("mobs_mc") then
  mcl_mobs:register_spawn("mobs_mc:villager", --name
    {"mcl_core:stonebrickcarved"}, --nodes
    15, --max_light
    0, --min_light
    20, --chance
    7, --active_object_count
    31000, --max_height
    nil) --day_toggle
end
--]]

--
-- on map generation, try to build a settlement
--
local function build_a_settlement(minp, maxp, blockseed)
	local pr = PseudoRandom(blockseed)

	if not new_villages then
		-- fill settlement_info with buildings and their data
		local settlement_info = settlements.create_site_plan(maxp, minp, pr)
		if not settlement_info then
			return
		end

		-- evaluate settlement_info and prepair terrain
		settlements.terraform(settlement_info, pr)

		-- evaluate settlement_info and build paths between buildings
		settlements.paths(settlement_info)

		-- evaluate settlement_info and place schematics
		settlements.place_schematics(settlement_info, pr)
	else
		--minetest.log("Starting village for " .. minetest.pos_to_string(minp))
		local settlement_info = settlements.create_site_plan_new(minp, maxp, pr)

		if not settlement_info then
			--minetest.log("Aborting village for " .. minetest.pos_to_string(minp))
			return
		end

		settlements.terraform_new(settlement_info, pr)
		settlements.place_schematics_new(settlement_info, pr, blockseed)
		--settlements.dump_path_ends()
		-- TODO when run here minetest.find_path regularly fails :(
		--settlements.paths_new(blockseed)
		--minetest.log("Completed village for " .. minetest.pos_to_string(minp))
	end
end

local function ecb_village(blockpos, action, calls_remaining, param)
	if calls_remaining >= 1 then return end
	local minp, maxp, blockseed = param.minp, param.maxp, param.blockseed
	build_a_settlement(minp, maxp, blockseed)
end

-- Disable natural generation in singlenode.
local mg_name = minetest.get_mapgen_setting("mg_name")
if mg_name ~= "singlenode" then
	mcl_mapgen_core.register_generator("villages", nil, function(minp, maxp, blockseed)
		if maxp.y < 0 then return end

		if new_villages then
			if village_chance == 0 then
				return
			end
			local pr = PseudoRandom(blockseed)
			if pr:next(1, village_chance) == 1 then
				--minetest.log(string.format( "Potential village site between %s and %s", minetest.pos_to_string(minp), minetest.pos_to_string(maxp)))
				local big_minp = vector.offset(minp, -16, -16, -16)
				local big_maxp = vector.offset(maxp, 16, 16, 16)
				minetest.emerge_area(
					vector.copy(big_minp),
					vector.copy(big_maxp),
					ecb_village,
					{ minp = vector.copy(minp), maxp = vector.copy(maxp), blockseed = blockseed }
				)
			end

			return
		end

		-- randomly try to build settlements
		if blockseed % 77 ~= 17 then return end
		--minetest.log("Rng good. Generate attempt")

		-- needed for manual and automated settlement building
		-- don't build settlements on (too) uneven terrain
		local n=minetest.get_node_or_nil(minp)
		if n and n.name == "mcl_villages:structblock" then return end
		--minetest.log("No existing village attempt here")

		if villagegen[minetest.pos_to_string(minp)] ~= nil then return end

		--minetest.log("Not in village gen. Put down placeholder: " .. minetest.pos_to_string(minp) .. " || " .. minetest.pos_to_string(maxp))
		minetest.set_node(minp,{name="mcl_villages:structblock"})

		local height_difference = settlements.evaluate_heightmap()
		if not height_difference or height_difference > settlements.max_height_difference then
			minetest.log("action", "Do not spawn village here as heightmap not good")
			return
		end
		--minetest.log("Build me a village: " .. minetest.pos_to_string(minp) .. " || " .. minetest.pos_to_string(maxp))
		villagegen[minetest.pos_to_string(minp)]={minp=vector.new(minp), maxp=vector.new(maxp), blockseed=blockseed}
	end)
end

minetest.register_lbm({
	name = "mcl_villages:structblock",
	run_at_every_load = true,
	nodenames = {"mcl_villages:structblock"},
	action = function(pos, node)
		minetest.set_node(pos, {name = "air"})
		if not villagegen[minetest.pos_to_string(pos)] then return end
		local minp=villagegen[minetest.pos_to_string(pos)].minp
		local maxp=villagegen[minetest.pos_to_string(pos)].maxp
		minetest.emerge_area(minp, maxp, ecb_village, villagegen[minetest.pos_to_string(minp)])
		villagegen[minetest.pos_to_string(minp)]=nil
	end
})
-- manually place villages
if minetest.is_creative_enabled("") then
	minetest.register_craftitem("mcl_villages:tool", {
		description = S("mcl_villages build tool"),
		inventory_image = "default_tool_woodshovel.png",
		-- build ssettlement
		on_place = function(itemstack, placer, pointed_thing)
			if not pointed_thing.under then return end
			local minp = vector.subtract(	pointed_thing.under, settlements.half_map_chunk_size)
		        local maxp = vector.add(	pointed_thing.under, settlements.half_map_chunk_size)
			build_a_settlement(minp, maxp, math.random(0,32767))
		end
	})
	mcl_wip.register_experimental_item("mcl_villages:tool")
end

minetest.register_on_mods_loaded(function()
	local olfunc = minetest.registered_chatcommands["spawnstruct"].func
	minetest.registered_chatcommands["spawnstruct"].func = function(pn,p)
		if p == "village" then
			local pl = minetest.get_player_by_name(pn)
			local pos = vector.offset(pl:get_pos(),0,-1,0)
			local minp = vector.subtract(pos, settlements.half_map_chunk_size)
			local maxp = vector.add(pos, settlements.half_map_chunk_size)
			build_a_settlement(minp, maxp, math.random(0,32767))
		else
			return olfunc(pn,p)
		end
	end
	minetest.registered_chatcommands["spawnstruct"].params = minetest.registered_chatcommands["spawnstruct"].params .. "|village"
end)

if new_villages then
	-- This is a light source so that lamps don't get placed near it
	minetest.register_node("mcl_villages:building_block", {
		drawtype = "airlike",
		groups = { not_in_creative_inventory = 1 },
		light_source = 14,
		-- Somethinsg don't work reliably when done in the map building
		-- so we use a timer to run them later when they work more reliably
		-- e.g. spawning mobs, running minetest.find_path
		on_timer = function(pos, elapsed)
			local meta = minetest.get_meta(pos)
			local minp = minetest.string_to_pos(meta:get_string("minp"))
			local maxp = minetest.string_to_pos(meta:get_string("maxp"))
			local node_type = meta:get_string("node_type")
			local blockseed = meta:get_string("blockseed")
			local has_beds = meta:get_int("has_beds") > 0 and true or false
			local has_jobs = meta:get_int("has_jobs") > 0 and true or false
			local is_belltower = meta:get_int("is_belltower") > 0 and true or false
			minetest.get_node_timer(pos):stop()
			minetest.set_node(pos, { name = node_type })
			settlements.post_process_building(minp, maxp, blockseed, has_beds, has_jobs, is_belltower)
			return false
		end,
	})

	minetest.register_node("mcl_villages:path_endpoint", {
		description = S("Mark the node as a good place for paths to connect to"),
		is_ground_content = false,
		tiles = { "wool_white.png" },
		wield_image = "wool_white.png",
		wield_scale = { x = 1, y = 1, z = 0.5 },
		groups = { handy = 1, supported_node = 1, deco_block = 1 },
		sounds = mcl_sounds.node_sound_wool_defaults(),
		paramtype = "light",
		sunlight_propagates = true,
		stack_max = 64,
		drawtype = "nodebox",
		walkable = true,
		node_box = {
			type = "fixed",
			fixed = {
				{ -8 / 16, -8 / 16, -8 / 16, 8 / 16, -7 / 16, 8 / 16 },
			},
		},
		_mcl_hardness = 0.1,
		_mcl_blast_resistance = 0.1,
	})

	local schem_path = settlements.modpath .. "/schematics/"

	settlements.register_bell({ name = "belltower", mts = schem_path .. "new_villages/belltower.mts", yadjust = 1 })

	settlements.register_well({
		name = "well",
		mts = schem_path .. "new_villages/well.mts",
		yadjust = -1,
	})

	for i = 1, 6 do
		settlements.register_lamp({
			name = "lamp",
			mts = schem_path .. "new_villages/lamp_" .. i .. ".mts",
			yadjust = 1,
		})
	end

	settlements.register_building({
		name = "house_big",
		mts = schem_path .. "new_villages/house_4_bed.mts",
		min_jobs = 6,
		max_jobs = 99,
		yadjust = 1,
	})

	settlements.register_building({
		name = "house_large",
		mts = schem_path .. "new_villages/house_3_bed.mts",
		min_jobs = 4,
		max_jobs = 99,
		yadjust = 1,
	})

	settlements.register_building({
		name = "house_medium",
		mts = schem_path .. "new_villages/house_2_bed.mts",
		min_jobs = 2,
		max_jobs = 99,
		yadjust = 1,
	})

	settlements.register_building({
		name = "house_small",
		mts = schem_path .. "new_villages/house_1_bed.mts",
		min_jobs = 1,
		max_jobs = 99,
		yadjust = 1,
	})

	settlements.register_building({
		name = "blacksmith",
		mts = schem_path .. "new_villages/blacksmith.mts",
		num_others = 8,
		yadjust = 1,
	})

	settlements.register_building({
		name = "butcher",
		mts = schem_path .. "new_villages/butcher.mts",
		num_others = 8,
		yadjust = 1,
	})

	settlements.register_building({
		name = "farm",
		mts = schem_path .. "new_villages/farm.mts",
		num_others = 3,
	})

	settlements.register_building({
		name = "fish_farm",
		mts = schem_path .. "new_villages/fishery.mts",
		num_others = 8,
		yadjust = -2,
	})

	settlements.register_building({
		name = "fletcher",
		mts = schem_path .. "new_villages/fletcher.mts",
		num_others = 8,
		yadjust = 1,
	})

	settlements.register_building({
		name = "library",
		mts = schem_path .. "new_villages/library.mts",
		num_others = 15,
		yadjust = 1,
	})

	settlements.register_building({
		name = "map_shop",
		mts = schem_path .. "new_villages/cartographer.mts",
		num_others = 15,
		yadjust = 1,
	})

	settlements.register_building({
		name = "mason",
		mts = schem_path .. "new_villages/mason.mts",
		num_others = 8,
		yadjust = 1,
	})

	settlements.register_building({
		name = "mill",
		mts = schem_path .. "new_villages/mill.mts",
		num_others = 8,
		yadjust = 1,
	})

	settlements.register_building({
		name = "tannery",
		mts = schem_path .. "new_villages/leather_worker.mts",
		num_others = 8,
		yadjust = 1,
	})

	settlements.register_building({
		name = "tool_smith",
		mts = schem_path .. "new_villages/toolsmith.mts",
		num_others = 8,
		yadjust = 1,
	})

	settlements.register_building({
		name = "weapon_smith",
		mts = schem_path .. "new_villages/weaponsmith.mts",
		num_others = 8,
		yadjust = 1,
	})

	settlements.register_building({
		name = "chapel",
		mts = schem_path .. "new_villages/chapel.mts",
		num_others = 8,
		min_jobs = 1,
		max_jobs = 9,
		yadjust = 1,
	})

	settlements.register_building({
		name = "church",
		mts = schem_path .. "new_villages/church.mts",
		num_others = 20,
		min_jobs = 10,
		max_jobs = 99,
		yadjust = 1,
	})
end
