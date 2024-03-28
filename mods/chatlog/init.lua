
local outdir = minetest.get_worldpath() .. "/chatlog"

core.mkdir(outdir)

core.register_on_chat_message(function(name, msg)
	local file = string.format("%s/%s.txt", outdir, os.date("%Y-%m-%d"))
	local f = io.open(file, "a")

	f:write(string.format("[%s] %s: %s\n", os.date("%H:%M:%S"), name, msg))

	f:close()
end)
