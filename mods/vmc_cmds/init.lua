
include('build')
include('fun')
include('msgblock')

minetest.register_chatcommand('speed', {
	params = "<speed>",
	description = "Change your speed.",
	privs = { fast = true },

	func = function(name, param)
		local speed = tonumber(param) or -1
		if speed >= 0 and speed < 10 then
			minetest.get_player_by_name(name):set_physics_override{ speed = speed }
		end
	end,
})
