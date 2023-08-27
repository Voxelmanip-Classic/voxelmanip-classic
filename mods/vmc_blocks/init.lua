
minetest.register_item(":", {
	type = "none",
	wield_image = "blank.png",
	wield_scale = {x = 0.5, y = 1, z = 4},
	range = 10,
	tool_capabilities = {
		max_drop_level = 3,
		groupcaps = {
			instantly = {times = {[3] = 0}, uses = 0, maxlevel = 256}
		}
	},
	on_place = function(itemstack, placer, pointed_thing)
		local pointed_node = minetest.get_node(pointed_thing.under)
		return pointed_node
	end
})


include('classic')
include('cpe')
include('moreblocks')

include('abm')
