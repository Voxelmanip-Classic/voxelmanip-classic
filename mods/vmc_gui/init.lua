-- Code related to the GUI

minetest.register_on_joinplayer(function(player)
	player:hud_set_hotbar_itemcount(9)

	player:hud_set_hotbar_image("vmc_gui_hotbar.png")
	player:hud_set_hotbar_selected_image("vmc_gui_hotbar_selected.png")

	local default_blocks = {
		"minecraft:stone",
		"minecraft:cobblestone",
		"minecraft:bricks",
		"minecraft:dirt",
		"minecraft:wood",
		"minecraft:log",
		"minecraft:leaves",
		"minecraft:glass",
		"minecraft:stone_slab"
	}

	local i = 1
	for k, v in ipairs(default_blocks) do
		player:get_inventory():set_stack("main", i, ItemStack(v))
		i = i + 1
	end

	player:set_formspec_prepend([[
		box[-0.3,-0.3;11.35,6.2;#0000ff15]
		style_type[button;border=false;bgimg=vmc_gui_btn.png;bgimg_pressed=vmc_gui_btn_hover.png;bgimg_middle=2,2;font=bold;font_size=+4]
	]])
end)

minetest.register_on_placenode(function(pos, newnode, placer, oldnode, itemstack, pointed_thing)
	return true
end)

--include('blockselect')
include('inventory')