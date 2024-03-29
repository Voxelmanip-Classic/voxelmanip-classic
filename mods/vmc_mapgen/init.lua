


minetest.register_node("vmc_mapgen:invisible_bedrock", {
	description = "Invisible Bedrock",
	drawtype = "airlike",
	paramtype = "light",
	pointable = false,
	diggable = false,
	buildable_to = false,
	sunlight_propagates = true,
	groups = { not_in_creative_inventory = 1 }
})

minetest.register_node("vmc_mapgen:solid_water", {
	description = "Solid Water",
	tiles = { terrain(14) },
	use_texture_alpha = "opaque",
	pointable = false,
	diggable = false,
	buildable_to = false,
	groups = { not_in_creative_inventory = 1 }
})

for _,node in ipairs({'invisible_bedrock', 'solid_water'}) do
	minetest.register_alias('mccnt_mapgen:'..node, 'vmc_mapgen:'..node)
end

local data = {}

local nodes = {
	grass = minetest.get_content_id("vmc:grass"),
	dirt = minetest.get_content_id("vmc:dirt"),
	bedrock = minetest.get_content_id("vmc:bedrock"),
	invisible_bedrock = minetest.get_content_id("vmc_mapgen:invisible_bedrock"),
	solid_water = minetest.get_content_id("vmc_mapgen:solid_water"),
}

local width = 256
local depth = 64

minetest.register_on_generated(function(minp, maxp, blockseed)
	local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
	local area = VoxelArea:new{MinEdge = emin, MaxEdge = emax}
	vm:get_data(data)

	local written = false

	for z = minp.z, maxp.z do
	for y = minp.y, maxp.y do
		local posi = area:index(minp.x, y, z)
		for x = minp.x, maxp.x do
			if (x >= -width and x <= width) and (z >= -width and z <= width) then
				if y >= -depth and y <= -1 then
					data[posi] = nodes.dirt
					written = true
				elseif y == 0 then
					data[posi] = nodes.grass
					written = true
				elseif y == -depth -1 then
					data[posi] = nodes.bedrock
					written = true
				end
			elseif y >= -depth -1 and y <= -3 then
				if		(x == -width -1 and (z >= -width -1 and z <= width +1))
					or	(x ==  width +1 and (z >= -width -1 and z <= width +1))
					or	(z == -width -1 and (x >= -width -1 and x <= width +1))
					or	(z ==  width +1 and (x >= -width -1 and x <= width +1))
					or (y == -3 and (x > width +1 or x < -width -1 or z > width +1 or z < -width -1)) then
					data[posi] = nodes.bedrock
					written = true
				end
			elseif y >= 0 and (
						(x == -width -1 and (z >= -width -1 and z <= width +1))
					or	(x ==  width +1 and (z >= -width -1 and z <= width +1))
					or	(z == -width -1 and (x >= -width -1 and x <= width +1))
					or	(z ==  width +1 and (x >= -width -1 and x <= width +1))) then
				data[posi] = nodes.invisible_bedrock
				written = true
			elseif y < 0 and y > -3 then
				data[posi] = nodes.solid_water
				written = true
			end

			posi = posi + 1
		end
	end
	end

	if written then
		vm:set_data(data)
		vm:write_to_map()
	end
end)

local bound = width+1

minetest.register_globalstep(function(dtime)
	for _,player in ipairs(minetest.get_connected_players()) do
		local pos = player:get_pos()

		if (pos.x < -bound or pos.x > bound or pos.z < -bound or pos.z > bound
		or pos.y < -depth-1 or pos.y > 512) and player:get_player_name() ~= 'ROllerozxa' then
			pos.x = math.clamp(pos.x, -bound, bound)
			pos.y = math.clamp(pos.y, -depth-1, 512)
			pos.z = math.clamp(pos.z, -bound, bound)

			player:set_pos(pos)
		end
	end
end)
