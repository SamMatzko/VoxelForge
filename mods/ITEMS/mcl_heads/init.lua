local S = minetest.get_translator("mcl_heads")

local mod_doc = minetest.get_modpath("doc")

-- Heads system

local function addhead(name, texture, desc, longdesc, rangemob, rangefactor)
	local on_rotate
	if minetest.get_modpath("screwdriver") then
		on_rotate = screwdriver.rotate_simple
	end

	minetest.register_node("mcl_heads:"..name, {
		description = desc,
		_doc_items_longdesc = longdesc,
		drawtype = "nodebox",
		is_ground_content = false,
		node_box = {
			type = "fixed",
			fixed = {
				{ -0.25, -0.5, -0.25, 0.25, 0.0, 0.25, },
			},
		},
		groups = {handy=1, armor_head=1,non_combat_armor=1, head=1, deco_block=1, dig_by_piston=1},
		-- The head textures are based off the textures of an actual mob.
		tiles = {
			-- Note: bottom texture is overlaid over top texture to get rid of possible transparency.
			-- This is required for skeleton skull and wither skeleton skull.
			"[combine:16x16:-4,4="..texture, -- top
			"([combine:16x16:-4,4="..texture..")^([combine:16x16:-12,4="..texture..")", -- bottom
			"[combine:16x16:-12,0="..texture, -- left
			"[combine:16x16:4,0="..texture, -- right
			"[combine:16x16:-20,0="..texture, -- back
			"[combine:16x16:-4,0="..texture, -- front
		},
		paramtype = "light",
		stack_max = 64,
		paramtype2 = "facedir",
		sunlight_propagates = true,
		walkable = true,
		selection_box = {
			type = "fixed",
			fixed = { -0.25, -0.5, -0.25, 0.25, 0.0, 0.25, },
		},
		sounds = mcl_sounds.node_sound_defaults({
			footstep = {name="default_hard_footstep", gain=0.3}
		}),
		on_rotate = on_rotate,
		_mcl_blast_resistance = 5,
		_mcl_hardness = 1,
		_mcl_armor_mob_range_factor = rangefactor,
		_mcl_armor_mob_range_mob = rangemob,

	})

	minetest.register_node("mcl_heads:"..name.."_wall", {
		_doc_items_create_entry = false,
		drawtype = "nodebox",
		is_ground_content = false,
		node_box = {
			type = "wallmounted",
			wall_bottom = { -0.25, -0.5, -0.25, 0.25, 0.0, 0.25, },
			wall_top = { -0.25, 0.0, -0.25, 0.25, 0.5, 0.25, },
			wall_side = { -0.5, -0.25, -0.25, 0.0, 0.25, 0.25, },
		},
		groups = {handy=1, head=1, deco_block=1, dig_by_piston=1, not_in_creative_inventory=1},
		-- The head textures are based off the textures of an actual mob.
		tiles = {
			{ name = "[combine:16x16:-4,-4="..texture, align_style = "world" }, -- front
			{ name = "[combine:16x16:-20,-4="..texture, align_style = "world" }, -- back
			{ name = "[combine:16x16:-8,-4="..texture, align_style = "world" }, -- left
			{ name = "[combine:16x16:0,-4="..texture, align_style = "world" }, -- right
			{ name = "([combine:16x16:-4,0="..texture..")^[transformR180", align_style = "node" }, -- top
			{ name = "([combine:16x16:-4,8="..texture..")^([combine:16x16:-12,8="..texture..")", align_style = "node" }, -- bottom
		},
		paramtype = "light",
		stack_max = 64,
		paramtype2 = "wallmounted",
		sunlight_propagates = true,
		walkable = true,
		sounds = mcl_sounds.node_sound_defaults({
			footstep = {name="default_hard_footstep", gain=0.3}
		}),
		drop = "mcl_heads:"..name,
		on_rotate = on_rotate,
		_mcl_blast_resistance = 5,
		_mcl_hardness = 1,
	})

	if mod_doc then
		doc.add_entry_alias("nodes", "mcl_heads:" .. name, "nodes", "mcl_heads:" .. name .. "_wall")
	end
end

-- Add heads
addhead("zombie", "mcl_heads_zombie_node.png", S("Zombie Head"), S("A zombie head is a small decorative block which resembles the head of a zombie. It can also be worn as a helmet, which reduces the detection range of zombies by 50%."), "mobs_mc:zombie", 0.5)
addhead("creeper", "mcl_heads_creeper_node.png", S("Creeper Head"), S("A creeper head is a small decorative block which resembles the head of a creeper. It can also be worn as a helmet, which reduces the detection range of creepers by 50%."), "mobs_mc:creeper", 0.5)
-- Original Minecraft name: “Head”
addhead("steve", "mcl_heads_steve_node.png", S("Human Head"), S("A human head is a small decorative block which resembles the head of a human (i.e. a player character). It can also be worn as a helmet for fun, but does not offer any protection."))
addhead("skeleton", "mcl_heads_skeleton_node.png", S("Skeleton Skull"), S("A skeleton skull is a small decorative block which resembles the skull of a skeleton. It can also be worn as a helmet, which reduces the detection range of skeletons by 50%."), "mobs_mc:skeleton", 0.5)
addhead("wither_skeleton", "mcl_heads_wither_skeleton_node.png", S("Wither Skeleton Skull"), S("A wither skeleton skull is a small decorative block which resembles the skull of a wither skeleton. It can also be worn as a helmet for fun, but does not offer any protection."))
