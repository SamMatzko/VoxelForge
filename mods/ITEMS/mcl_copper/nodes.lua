local S = minetest.get_translator("mcl_copper")

minetest.register_node("mcl_copper:stone_with_copper", {
	description = S("Copper Ore"),
	_doc_items_longdesc = S("Some copper contained in stone, it is pretty common and can be found below sea level."),
	tiles = {"default_stone.png^mcl_copper_ore.png"},
	is_ground_content = true,
	groups = {pickaxey = 3, building_block = 1, material_stone = 1, blast_furnace_smeltable=1},
	drop = "mcl_copper:raw_copper",
	sounds = mcl_sounds.node_sound_stone_defaults(),
	_mcl_blast_resistance = 3,
	_mcl_hardness = 3,
	_mcl_silk_touch_drop = true,
	_mcl_fortune_drop = mcl_core.fortune_drop_ore,

})

minetest.register_node("mcl_copper:block_raw", {
	description = S("Block of Raw Copper"),
	_doc_items_longdesc = S("A block used for compact raw copper storage."),
	tiles = {"mcl_copper_block_raw.png"},
	is_ground_content = false,
	groups = {pickaxey = 2, building_block = 1, blast_furnace_smeltable = 1 },
	sounds = mcl_sounds.node_sound_metal_defaults(),
	_mcl_blast_resistance = 6,
	_mcl_hardness = 5,
})

minetest.register_node("mcl_copper:block", {
	description = S("Block of Copper"),
	_doc_items_longdesc = S("A block of copper is mostly a decorative block."),
	tiles = {"mcl_copper_block.png"},
	is_ground_content = false,
	groups = {pickaxey = 2, building_block = 1},
	sounds = mcl_sounds.node_sound_metal_defaults(),
	_mcl_blast_resistance = 6,
	_mcl_hardness = 3,
})

minetest.register_node("mcl_copper:block_exposed", {
	description = S("Exposed Copper"),
	_doc_items_longdesc = S("Exposed copper is a decorative block."),
	tiles = {"mcl_copper_exposed.png"},
	is_ground_content = false,
	groups = {pickaxey = 2, building_block = 1},
	sounds = mcl_sounds.node_sound_metal_defaults(),
	_mcl_blast_resistance = 6,
	_mcl_hardness = 5,
})

minetest.register_node("mcl_copper:block_weathered", {
	description = S("Weathered Copper"),
	_doc_items_longdesc = S("Weathered copper is a decorative block."),
	tiles = {"mcl_copper_weathered.png"},
	is_ground_content = false,
	groups = {pickaxey = 2, building_block = 1},
	sounds = mcl_sounds.node_sound_metal_defaults(),
	_mcl_blast_resistance = 6,
	_mcl_hardness = 5,
})

minetest.register_node("mcl_copper:block_oxidized", {
	description = S("Oxidized Copper"),
	_doc_items_longdesc = S("Oxidized copper is a decorative block."),
	tiles = {"mcl_copper_oxidized.png"},
	is_ground_content = false,
	groups = {pickaxey = 2, building_block = 1},
	sounds = mcl_sounds.node_sound_metal_defaults(),
	_mcl_blast_resistance = 6,
	_mcl_hardness = 5,
})

minetest.register_node("mcl_copper:block_cut", {
	description = S("Cut Copper"),
	_doc_items_longdesc = S("Cut copper is a decorative block."),
	tiles = {"mcl_copper_block_cut.png"},
	is_ground_content = false,
	groups = {pickaxey = 2, building_block = 1},
	sounds = mcl_sounds.node_sound_metal_defaults(),
	_mcl_blast_resistance = 6,
	_mcl_hardness = 5,
})

minetest.register_node("mcl_copper:block_exposed_cut", {
	description = S("Exposed Cut Copper"),
	_doc_items_longdesc = S("Exposed cut copper is a decorative block."),
	tiles = {"mcl_copper_exposed_cut.png"},
	is_ground_content = false,
	groups = {pickaxey = 2, building_block = 1},
	sounds = mcl_sounds.node_sound_metal_defaults(),
	_mcl_blast_resistance = 6,
	_mcl_hardness = 5,
})

minetest.register_node("mcl_copper:block_weathered_cut", {
	description = S("Weathered Cut Copper"),
	_doc_items_longdesc = S("Weathered cut copper is a decorative block."),
	tiles = {"mcl_copper_weathered_cut.png"},
	is_ground_content = false,
	groups = {pickaxey = 2, building_block = 1},
	sounds = mcl_sounds.node_sound_metal_defaults(),
	_mcl_blast_resistance = 6,
	_mcl_hardness = 5,
})

minetest.register_node("mcl_copper:block_oxidized_cut", {
	description = S("Oxidized Cut Copper"),
	_doc_items_longdesc = S("Oxidized cut copper is a decorative block."),
	tiles = {"mcl_copper_oxidized_cut.png"},
	is_ground_content = false,
	groups = {pickaxey = 2, building_block = 1},
	sounds = mcl_sounds.node_sound_metal_defaults(),
	_mcl_blast_resistance = 6,
	_mcl_hardness = 5,
})

mcl_stairs.register_slab("copper_cut", "mcl_copper:block_cut",
	{pickaxey = 2},
	{"mcl_copper_block_cut.png", "mcl_copper_block_cut.png", "mcl_copper_block_cut.png"},
	S("Cut Copper Slab"),
	nil, nil, nil,
	S("Cut Copper Double Slab"))

mcl_stairs.register_slab("copper_exposed_cut", "mcl_copper:block_exposed_cut",
	{pickaxey = 2},
	{"mcl_copper_exposed_cut.png", "mcl_copper_exposed_cut.png", "mcl_copper_exposed_cut.png"},
	S("Exposed Cut Copper Slab"),
	nil, nil, nil,
	S("Exposed Cut Copper Double Slab"))

mcl_stairs.register_slab("copper_weathered_cut", "mcl_copper:block_weathered_cut",
	{pickaxey = 2},
	{"mcl_copper_weathered_cut.png", "mcl_copper_weathered_cut.png", "mcl_copper_weathered_cut.png"},
	S("Weathered Cut Copper Slab"),
	nil, nil, nil,
	S("Weathered Cut Copper Double Slab"))

mcl_stairs.register_slab("copper_oxidized_cut", "mcl_copper:block_oxidized_cut",
	{pickaxey = 2},
	{"mcl_copper_oxidized_cut.png", "mcl_copper_oxidized_cut.png", "mcl_copper_oxidized_cut.png"},
	S("Oxidized Cut Copper Slab"),
	nil, nil, nil,
	S("Oxidized Cut Copper Double Slab"))

mcl_stairs.register_stair("copper_cut", "mcl_copper:block_cut",
	{pickaxey = 2},
	{"mcl_copper_block_cut.png", "mcl_copper_block_cut.png", "mcl_copper_block_cut.png", "mcl_copper_block_cut.png", "mcl_copper_block_cut.png", "mcl_copper_block_cut.png"},
	S("Cut Copper Stairs"),
	nil, 6, nil,
	"woodlike")


mcl_stairs.register_stair("copper_exposed_cut", "mcl_copper:block_exposed_cut",
	{pickaxey = 2},
	{"mcl_copper_exposed_cut.png", "mcl_copper_exposed_cut.png", "mcl_copper_exposed_cut.png", "mcl_copper_exposed_cut.png", "mcl_copper_exposed_cut.png", "mcl_copper_exposed_cut.png"},
	S("Exposed Cut Copper Stairs"),
	nil, 6, nil,
	"woodlike")

mcl_stairs.register_stair("copper_weathered_cut", "mcl_copper:block_weathered_cut",
	{pickaxey = 2},
	{"mcl_copper_weathered_cut.png", "mcl_copper_weathered_cut.png", "mcl_copper_weathered_cut.png", "mcl_copper_weathered_cut.png", "mcl_copper_weathered_cut.png", "mcl_copper_weathered_cut.png"},
	S("Weathered Cut Copper Stairs"),
	nil, 6, nil,
	"woodlike")

mcl_stairs.register_stair("copper_oxidized_cut", "mcl_copper:block_oxidized_cut",
	{pickaxey = 2},
	{"mcl_copper_oxidized_cut.png", "mcl_copper_oxidized_cut.png", "mcl_copper_oxidized_cut.png", "mcl_copper_oxidized_cut.png", "mcl_copper_oxidized_cut.png", "mcl_copper_oxidized_cut.png"},
	S("Oxidized Cut Copper Stairs"),
	nil, 6, nil,
	"woodlike")
