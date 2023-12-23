vmc_signs = {}

local SIGN_WIDTH = 115

local LINE_LENGTH = 18
local NUMBER_OF_LINES = 5

local LINE_HEIGHT = 14
local CHAR_WIDTH = 5

local DEFAULT_COLOR = "#000000"

--Signs data / meta
local function normalize_rotation(rot) return math.floor(0.5 + rot / 15) * 15 end

local function get_signdata(pos)
	local node = minetest.get_node(pos)
	local def = minetest.registered_nodes[node.name]
	if not def or minetest.get_item_group(node.name,"sign") < 1 then return end
	local meta = minetest.get_meta(pos)
	local text = meta:get_string("text")
	local color = meta:get_string("color")

	local yaw, spos
	local typ = "standing"
	if def.paramtype2  == "wallmounted" then
		typ = "wall"
		local dir = minetest.wallmounted_to_dir(node.param2)
		spos = vector.add(vector.offset(pos,0,-0.25,0),dir * 0.41 )
		yaw = minetest.dir_to_yaw(dir)
	else
		yaw = math.rad(((node.param2 * 1.5 ) + 1 ) % 360)
		local dir = minetest.yaw_to_dir(yaw)
		spos = vector.add(vector.offset(pos,0,0.08,0),dir * -0.05)
	end
	if color == "" then color = DEFAULT_COLOR end
	return {
		text = text,
		color = color,
		yaw = yaw,
		node = node,
		typ = typ,
		text_pos = spos,
	}
end

local function set_signmeta(pos,def)
	local meta = minetest.get_meta(pos)
	if def.text then meta:set_string("text",def.text) end
	if def.color then meta:set_string("color",def.color) end
end

-- Text/texture
local charmap = include("characters")

local function string_to_line_array(str)
	local linechar_table = {}
	local current = 1
	local linechar = 1
	linechar_table[current] = ""
	for char in str:gmatch(".") do
		if char == "\n" then
			current = current + 1
			linechar_table[current] = ""
			linechar = 1
		else
			linechar_table[current] = linechar_table[current] .. char
			linechar = linechar + 1
		end
	end
	return linechar_table
end

local sign_tpl = {
	paramtype = "light",
	description = "Sign",
	use_texture_alpha = "opaque",
	sunlight_propagates = true,
	walkable = false,
	paramtype2 = "degrotate",
	drawtype = "mesh",
	mesh = "vmc_signs_sign.obj",
	inventory_image = "default_sign_greyscale.png",
	selection_box = { type = "fixed", fixed = { -0.2, -0.5, -0.2, 0.2, 0.2, 0.2 } },
	tiles = { "vmc_signs_sign_greyscale.png" },
	groups = { sign = 1, dig_immediate = 3 },
	stack_max = 1,
	drop = "",
	node_placement_prediction = "",

	on_place = function(itemstack, placer, pointed_thing)
		if pointed_thing.type ~= "node" then
			return itemstack
		end

		local under = pointed_thing.under
		local node = minetest.get_node(under)
		local def = minetest.registered_nodes[node.name]
		if not def then return itemstack end

		local above = pointed_thing.above
		local dir = {x = under.x - above.x, y = under.y - above.y, z = under.z - above.z}
		local wdir = minetest.dir_to_wallmounted(dir)

		local itemstring = itemstack:get_name()
		local placestack = ItemStack(itemstack)
		local def = itemstack:get_definition()

		local pos
		-- place on wall
		if wdir ~= 0 and wdir ~= 1 then
			placestack:set_name("vmc:wall_sign_"..def._mcl_sign_wood)
			itemstack, pos = minetest.item_place(placestack, placer, pointed_thing, wdir)
		elseif wdir == 1 then -- standing, not ceiling
			placestack:set_name("vmc:standing_sign_"..def._mcl_sign_wood)
			local rot = normalize_rotation(placer:get_look_horizontal() * 180 / math.pi / 1.5)
			itemstack, pos = minetest.item_place(placestack, placer, pointed_thing,  rot) -- param2 value is degrees / 1.5
		else
			return itemstack
		end
		vmc_signs.show_formspec(placer, pos)
		itemstack:set_name(itemstring)
		return itemstack
	end,

	on_destruct = function(pos)
		vmc_signs.get_text_entity(pos, true)
	end
}

local sign_wall = table.copy(sign_tpl)
sign_wall.mesh = "vmc_signs_signonwallmount.obj"
sign_wall.paramtype2 = "wallmounted"
sign_wall.selection_box = { type = "wallmounted", wall_side = { -0.5, -7 / 28, -0.5, -23 / 56, 7 / 28, 0.5 }}
sign_wall.groups.not_in_creative_inventory = 1


function vmc_signs.create_lines(text)
	local line_num = 1
	local text_table = {}
	for _, line in ipairs(string_to_line_array(text)) do
		if line_num > NUMBER_OF_LINES then
			break
		end
		table.insert(text_table, line)
		line_num = line_num + 1
	end
	return text_table
end

function vmc_signs.generate_line(s, ypos)
	local i = 1
	local parsed = {}
	local width = 0
	local chars = 0
	local printed_char_width = CHAR_WIDTH +1
	while chars < LINE_LENGTH and i <= #s do
		local file
		-- Get and render character
		if charmap[s:sub(i, i)] then
			file = charmap[s:sub(i, i)]
			i = i + 1
		elseif i < #s and charmap[s:sub(i, i + 1)] then
			file = charmap[s:sub(i, i + 1)]
			i = i + 2
		else
			-- Use replacement character:
			file = "_rc"
			i = i + 1
		end
		if file then
			width = width + printed_char_width
			table.insert(parsed, file)
			chars = chars + 1
		end
	end
	width = width - 1
	local tex = {}
	local xpos = math.floor((SIGN_WIDTH - width) / 2)

	for j = 1, #parsed do
		tex[#tex+1] = ":"..xpos..","..ypos.."="..parsed[j]..".png"
		xpos = xpos + printed_char_width
	end
	return table.concat(tex)
end

function vmc_signs.generate_texture(data)
	local lines = vmc_signs.create_lines(data.text or "")
	local tex = {"[combine:", SIGN_WIDTH, "x", SIGN_WIDTH}
	local ypos = 0
	local letter_color = data.color or DEFAULT_COLOR

	for i = 1, #lines do
		tex[#tex+1] = vmc_signs.generate_line(lines[i], ypos)
		ypos = ypos + LINE_HEIGHT
	end

	tex[#tex+1] = "^[multiply:"..letter_color

	return table.concat(tex)
end

function vmc_signs.show_formspec(player, pos)
	if not pos then return end

	local fs = [[
		formspec_version[6]
		size[6.5,4.75]
		style_type[textarea;font=mono]
		textarea[0.25,0.25;6,2;text;;]
		label[0.25,2.5;Max sign text limit:
18 columns, 4 rows]
		button_exit[0.25,3.5;6,1;submit;Save]
	]]

	minetest.show_formspec(
		player:get_player_name(),
		"vmc_signs:set_text_"..pos.x.."_"..pos.y.."_"..pos.z,
		fs
	)
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname:find("vmc_signs:set_text_") ~= 1 then return end

	local x, y, z = formname:match("vmc_signs:set_text_(.-)_(.-)_(.*)")
	local pos = vector.new(tonumber(x), tonumber(y), tonumber(z))
	if not pos or not pos.x or not pos.y or not pos.z then
		return
	end

	set_signmeta(pos, { text = fields.text })
	vmc_signs.update_sign(pos)
end)

--Text entity handling
function vmc_signs.get_text_entity(pos, force_remove)
	local objects = minetest.get_objects_inside_radius(pos, 0.5)
	local text_entity
	for _, v in pairs(objects) do
		local ent = v:get_luaentity()
		if ent and ent.name == "vmc_signs:text" then
			if force_remove ~= nil and force_remove == true then
				v:remove()
			else
				text_entity = v
				break
			end
		end
	end
	return text_entity
end

function vmc_signs.update_sign(pos)
	local data = get_signdata(pos)

	local text_entity = vmc_signs.get_text_entity(pos)
	if text_entity and not data then
		text_entity:remove()
		return false
	elseif not data then
		return false
	elseif not text_entity then
		text_entity = minetest.add_entity(data.text_pos, "vmc_signs:text")
		if not text_entity or not text_entity:get_pos() then return end
	end

	text_entity:set_properties{ textures = { vmc_signs.generate_texture(data) } }
	text_entity:set_yaw(data.yaw)
	text_entity:set_armor_groups{ immortal = 1 }
	return true
end

minetest.register_lbm{
	nodenames = {"group:sign"},
	name = "vmc_signs:restore_entities",
	label = "Restore sign text",
	run_at_every_load = true,
	action = function(pos, node)
		vmc_signs.update_sign(pos)
	end
}

minetest.register_entity("vmc_signs:text", {
	initial_properties = {
		pointable = false,
		visual = "upright_sprite",
		textures = {},
		physical = false,
		collide_with_objects = false,
	},
	on_activate = function(self, staticdata)
		local pos = self.object:get_pos()
		vmc_signs.update_sign(pos)
	end,
})

function vmc_signs.register_sign(name,color)
	local standing_def = table.copy(sign_tpl)
	local wall_def = table.copy(sign_wall)

	standing_def.tiles = { "vmc_signs_sign_greyscale.png".."^[multiply:"..color }
	wall_def.tiles = standing_def.tiles

	standing_def.inventory_image = "default_sign_greyscale.png".."^[multiply:"..color
	wall_def.inventory_image = standing_def.inventory_image

	standing_def._mcl_sign_wood = name
	wall_def._mcl_sign_wood = name

	minetest.register_node(":vmc:standing_sign_"..name, standing_def)
	minetest.register_node(":vmc:wall_sign_"..name, wall_def)
end

vmc_signs.register_sign("wood", "#d8b281")
