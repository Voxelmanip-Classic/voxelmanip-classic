local storage = minetest.get_mod_storage()

local hypertext_text = [[
<center><big>Welcome to <b>Voxelmanip Classic</b>!</big></center>

<b>-</b>
This is a game that aims to recreate the simple creative freebuild gameplay that existed in Minecraft Classic.
The world is currently 512x512 in size, but may expand in the future. Build something cool and have a great time around here.

<big>Rules</big>
<img name=blank.png width=32 height=1>1. <b>No griefing.</b> We have rollback functionality in place which can revert any griefing instantly, you're just wasting your time.
<img name=blank.png width=32 height=1>2. <b>No tunneling or pillaring.</b> It's unnecessary and makes the map look ugly. You are already given the permission to fly, rather than pillaring up to get somewhere.
<img name=blank.png width=32 height=1>3. <b>Be mindful of others.</b> Both in chat and in-game. Do not needlessly mess with other people's builds or be an ass in the chat.
<img name=blank.png width=32 height=1>4. <b>Staff decisions are final.</b> They may act in any way they see fit to keep the server a pleasant experience for everyone.

Feel ready to start? <action name=security><style color=#00ff00>Click here to answer the verification question.</style></action>
]]

local formspec_text = formspec_wrapper([[
		formspec_version[4]
		size[14,11]
		box[0.25,0.25;13.5,9.5;#00000088]
		hypertext[0.5,0.5;13,9;welcometext;${hypertext_text}]
		button_exit[4.5,9.9;5,0.9;btn_confirm;OK]
	]], { hypertext_text = hypertext_text })

local security_formspec_text = [[
	formspec_version[4]
	size[13,7.65]
	hypertext[0.5,0.75;13,10;lol;In order to be granted interact privileges you need to answer this question.

	What is the square root of
	<mono>floor(pi) * 48 + ( sin(pi) * e )</mono> ?]
	field[0.5,4.5;12,0.8;answer;;]
	${error}
	button[7.5,6;5,0.9;btn_confirm;Submit]
]]

function show_welcome_formspec(playername)
	minetest.show_formspec(playername, 'vmc_server:welcomescreen', formspec_text)
end

function show_security_formspec(playername, wrong)
	local errormsg = ''
	if wrong then
		errormsg = "label[1,6.5;"..red("Wrong answer!").."]"
	end

	minetest.show_formspec(playername, 'vmc_server:welcomescreen',
		formspec_wrapper(security_formspec_text, {
			error = errormsg
		}))
end

function revoke_interact(name)
	local pri = minetest.get_player_privs(name)
	pri["interact"] = nil
	minetest.set_player_privs(name, pri)
end

function verified(name)
	return storage:get_int(name) == 1
end

function success(name)
	-- check for interact ban
	if not no_touch_griefer.check_ban(minetest.get_player_ip(name)) then
		storage:set_int(name, 1)

		local pri = minetest.get_player_privs(name)
		pri["interact"] = true
		minetest.set_player_privs(name, pri)

		minetest.chat_send_player(name, green("You answered the question correctly and have now been granted interact privileges!"))
		minetest.close_formspec(name, "vmc_server:welcomescreen")
	else
		-- ew
		minetest.chat_send_player(name, red("LOL you're still interact banned."))
	end
end

minetest.register_on_joinplayer(function(player, last_login)
	local name = player:get_player_name()
	if not verified(name) then
		revoke_interact(name)
		show_welcome_formspec(name)
	end
end)

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= 'vmc_server:welcomescreen' then return end
	local name = player:get_player_name()

	if fields.welcometext == 'action:security' then
		if not verified(name) then
			show_security_formspec(name)
		else
			minetest.chat_send_player(name, yellow("You're already verified!"))
		end
	elseif fields.answer then
		if tonumber(fields.answer) == 12 then
			success(name)
		else
			show_security_formspec(name, true)
		end
	else
		if not verified(name) then
			minetest.chat_send_player(name, yellow("Use /welcome to reshow the welcome page. You cannot interact until you've answered the verification question."))
		end
	end
end)

minetest.register_chatcommand("welcome", {
	params = "",
	description = "Reshow the welcome screen.",
	func = function(name, param)
		show_welcome_formspec(name)
	end
})

minetest.register_chatcommand("pruneplayers", {
	params = "",
	description = "Prune players who haven't been verified.",
	privs = { server = true },
	func = function(name, param)
		local handler = minetest.get_auth_handler()

		for pname in handler.iterate() do
			if not verified(pname) then
				minetest.chat_send_player(name, yellow(pname.." has not been verified, pruning them..."))
				minetest.remove_player(pname)
				minetest.remove_player_auth(pname)
			end
		end
	end
})
