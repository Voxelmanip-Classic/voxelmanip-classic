
local next_id = 66
local function register(name, def)
	def.order = next_id

	vmc.register_block(name, def)
	next_id = next_id + 1
end

register('tall_grass', {
	description = 'Tall Grass',
	inventory_image = terrain2(0),
	waving = 1,
	buildable_to = true,
	sound = 'grass',
})

register('seizureblock', {
	description = 'Strobe Light',
	light_source = minetest.LIGHT_MAX-1,
	drawtype = "normal",
	tiles = {{
		name = "seizure_block.png",
		animation = {
			type = "vertical_frames",
			aspect_w = 1,
			aspect_h = 8,
			length = 2,
		}
	}}
})

register('rainbow_wool', {
	description = 'Rainbow Wool',
	drawtype = "normal",
	tiles = {{
		name = "rainbow_block.png",
		animation = {
			type = "vertical_frames",
			aspect_w = 16,
			aspect_h = 16,
			length = 2,
		}
	}}
})

-- CPE rejects
register('mountain_grass', {
	description = "Mountain Grass",
	tiles = {
		terrain(31),
		terrain(3),
		terrain(47),
	},
	sound = 'grass',
})
register('cobweb', {
	description = 'Cobweb',
	inventory_image = terrain2(1),
	sound = 'cloth',
	liquid_viscosity = 14,
	liquidtype = "none",
	walkable = false,
})
register('clay', {
	description = 'Clay',
	tiles = terrain(85),
	sound = 'dirt',
})

register('cyan_flower', {
	description = 'Cyan Flower',
	inventory_image = terrain2(2),
	sound = 'grass',
})

register('diamond_ore', {
	description = "Diamond Ore",
	tiles = terrain2(3),
	sound = 'stone',
})
register('diamond_block', {
	description = "Block of Diamond",
	tiles = {
		terrain2(16),
		terrain2(48),
		terrain2(32)},
	sound = 'metal',
})

register('ruby_block', {
	description = "Ruby Block",
	tiles = {
		terrain2(17),
		terrain2(49),
		terrain2(33)},
	sound = 'metal',
})

register('birch_log', {
	description = "Birch Log",
	tiles = {
		terrain2(19),
		terrain2(19),
		terrain2(18)},
	sound = 'wood',
})
register('birch_planks', {
	description = "Birch Planks",
	tiles = terrain2(20),
	sound = 'wood',
})

register('spruce_log', {
	description = "Spruce Log",
	tiles = {
		terrain2(35),
		terrain2(35),
		terrain2(34)},
	sound = 'wood',
})
register('spruce_planks', {
	description = "Spruce Planks",
	tiles = terrain2(36),
	sound = 'wood',
})

register('glowstone', {
	description = "Glowstone",
	tiles = terrain2(4),
	light_source = minetest.LIGHT_MAX-1,
	sound = 'glass',
})

register('nether_reactor', {
	description = "Nether Reactor",
	tiles = terrain2(5),
	sound = 'glass',
})

register('chair', {
	description = "Chair",
	tiles = terrain(4),
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.25, -0.125, -0.25, 0.25, 0, 0.25},
			{-0.25, -0.5, -0.25, -0.125, -0.125, -0.125},
			{-0.25, -0.5, 0.125, -0.125, -0.125, 0.25},
			{0.125, -0.5, 0.125, 0.25, -0.125, 0.25},
			{0.125, -0.5, -0.25, 0.25, -0.125, -0.125},
			{-0.25, 0, 0.125, 0.25, 0.5, 0.25},
		}
	},
	sound = 'wood',
})

register('table', {
	description = "Table",
	tiles = terrain(4),
	drawtype = "nodebox",
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.25, -0.125, -0.25, 0.25, 0, 0.25},
			{-0.25, -0.5, -0.25, -0.125, -0.125, -0.125},
			{-0.25, -0.5, 0.125, -0.125, -0.125, 0.25},
			{0.125, -0.5, 0.125, 0.25, -0.125, 0.25},
			{0.125, -0.5, -0.25, 0.25, -0.125, -0.125}
		}
	},
	sound = 'wood',
})

register('granite', {
	description = "Granite",
	tiles = terrain2(6),
	sound = 'stone',
})
register('polished_granite', {
	description = "Polished Granite",
	tiles = terrain2(22),
	sound = 'stone',
})

register('diorite', {
	description = "Diorite",
	tiles = terrain2(7),
	sound = 'stone',
})
register('polished_diorite', {
	description = "Polished Diorite",
	tiles = terrain2(23),
	sound = 'stone',
})

register('andesite', {
	description = "Andesite",
	tiles = terrain2(8),
	sound = 'stone',
})
register('polished_andesite', {
	description = "Polished Andesite",
	tiles = terrain2(24),
	sound = 'stone',
})

register('stone_brick_cracked', {
	description = "Cracked Stone Brick",
	tiles = terrain2(21),
	sound = 'stone',
})

register('stone_brick_mossy', {
	description = "Mossy Stone Brick",
	tiles = terrain2(37),
	sound = 'stone',
})

register('stone_brick_chiseled', {
	description = "Chiseled Stone Brick",
	tiles = terrain2(38),
	sound = 'stone',
})

register("very_black_wool", {
	description = "Very Black Wool",
	tiles = terrain2(64),
	sound = 'cloth',
})

register("mese_block", {
	description = "Mese Block",
	tiles = terrain2(9),
	sound = 'stone',
})
