
local animations = {
	-- Standard animations.
	stand     = {x = 0,   y = 79},
	lay       = {x = 162, y = 166},
	walk      = {x = 168, y = 187},
	mine      = {x = 189, y = 198},
	walk_mine = {x = 200, y = 219},
	sit       = {x = 81,  y = 160},
}

local player_anim = {}
local player_sneak = {}

core.hud_replace_builtin('health', {})
core.hud_replace_builtin('breath', {})

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
		texture = "blank.png",
		visible = true,
		sunrise_visible = false
	}

	player:set_moon{ visible = false }

	player:set_stars{ visible = false }

	player:set_sky{
		sky_color = {
			day_sky = "#498af2",
			day_horizon = "#7aa9ff",
		}
	}

	player:set_physics_override{ jump = 1.1, gravity = 1.2 }

	player:set_properties{
		mesh = "character.b3d",
		textures = {"character.png"},
		visual = "mesh",
		visual_size = {x = 1, y = 1},
		collisionbox = {-0.3, 0.0, -0.3, 0.3, 1.7, 0.3},
		stepheight = 0.6,
		eye_height = 1.47,
	}

	player:set_local_animation(
		animations.stand,
		animations.walk,
		animations.mine,
		animations.walk_mine,
		30)

	player:override_day_night_ratio(1)

	local name = player:get_player_name():lower()
	local skin = io.open(minetest.get_modpath("vmc_player").."/textures/character_"..name..".png")
	if skin ~= nil then
		player:set_properties{ textures = {"character_"..name..".png"} }
	end
end)

local function set_animation(player, anim_name, speed)
	local name = player:get_player_name()
	if player_anim[name] == anim_name then return end

	player_anim[name] = anim_name
	player:set_animation(animations[anim_name], speed)
end

minetest.register_globalstep(function()
	for _, player in ipairs(minetest.get_connected_players()) do
		local name = player:get_player_name()
		local controls = player:get_player_control()

		local anim_speed = controls.sneak and 15 or 30
		local anim_name

		if controls.up or controls.down or controls.left or controls.right then
			if player_sneak[name] ~= controls.sneak then
				player_anim[name] = nil
				player_sneak[name] = controls.sneak
			end

			if controls.LMB or controls.RMB then
				anim_name = "walk_mine"
			else
				anim_name = "walk"
			end
		elseif controls.LMB or controls.RMB then
			anim_name = "mine"
		else
			anim_name = "stand"
		end

		set_animation(player, anim_name, anim_speed)
	end
end)
