include('blocks')

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

minetest.register_on_newplayer(function(player)
	local playername = player:get_player_name()
	local pri = minetest.get_player_privs(playername)
	pri["fly"] = true
	pri["fast"] = true
	minetest.set_player_privs(playername, pri)
end)

minetest.register_on_joinplayer(function(player)
	player:set_lighting{
		shadows = { intensity = 0.33 }
	}

	player:set_sun{
		visible = false,
		sunrise_visible = false
	}

	player:set_moon{ visible = false }

	player:set_stars{ visible = false }

	player:set_sky{
		sky_color = {
			day_sky = "#6baaff",
			day_horizon = "#8ab9ff",
		}
	}

	player:set_physics_override{ jump = 1.1, gravity = 1.2 }
end)

core.hud_replace_builtin('health', {})
core.hud_replace_builtin('breath', {})
