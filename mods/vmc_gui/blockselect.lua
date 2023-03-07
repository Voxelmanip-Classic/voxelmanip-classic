local inv_blockselect = minetest.create_detached_inventory("blockselect", {
	allow_move = function(inv, from_list, from_index, to_list, to_index, count, player)
		return 0
	end,
	allow_put = function(inv, listname, index, stack, player)
		return 0
	end,
	allow_take = function(inv, listname, index, stack, player)
		return -1
	end,
	on_take = function(inv, listname, index, stack, player)
	end
})

minetest.register_on_mods_loaded(function()
	inv_blockselect:set_size("main", 42)

	default_blocks = {
		"vmc:stone",
		"vmc:cobblestone",
		"vmc:bricks",
		"vmc:dirt",
		"vmc:wood",
		"vmc:log",
		"vmc:leaves",
		"vmc:glass",
		"vmc:stone_slab",
		"vmc:mossy_cobblestone",
		"vmc:sapling",
		"vmc:yellow_flower",
		"vmc:red_flower",
		"vmc:brown_mushroom",
		"vmc:red_mushroom",
		"vmc:sand",
		"vmc:gravel",
		"vmc:sponge",
		"vmc:red_wool",
		"vmc:orange_wool",
		"vmc:yellow_wool",
		"vmc:lime_wool",
		"vmc:green_wool",
		"vmc:teal_wool",
		"vmc:aqua_wool",
		"vmc:cyan_wool",
		"vmc:blue_wool",
		"vmc:indigo_wool",
		"vmc:violet_wool",
		"vmc:magenta_wool",
		"vmc:pink_wool",
		"vmc:black_wool",
		"vmc:gray_wool",
		"vmc:white_wool",
		"vmc:coal_ore",
		"vmc:iron_ore",
		"vmc:gold_ore",
		"vmc:iron_block",
		"vmc:gold_block",
		"vmc:bookshelf",
		"vmc:tnt",
		"vmc:obsidian",
	}

	i = 1
	for k, v in ipairs(default_blocks) do
		inv_blockselect:set_stack("main", i, ItemStack(v))
		i = i + 1
	end
end)

minetest.register_on_joinplayer(function(player)
	player:set_inventory_formspec([[
		formspec_version[4]
		size[17,10.5]
		position[0.5,0.45]
		label[7.5,0.7;Select block]
		listcolors[#ffffff00;#ffffff80]
		style_type[list;spacing=0.45,0.5;size=1.25,1.25]
		list[detached:blockselect;main;1,1.6;9,5;]
	]])
end)

