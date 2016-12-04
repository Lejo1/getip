getip = {}

local input = io.open(minetest.get_worldpath() .. "/ips", "r")
if input then
	ips = minetest.deserialize(input:read("*l"))
	io.close(input)

--Add the Privileg.
minetest.register_privilege("ip", "Player can get ip's from other players")

--Creat the Command /getip.
minetest.register_chatcommand("getip", {
	params = "<player>",
	description = "Show other ips.",
	privs = {ip=true},
	func = function(name, player)
		if not minetest.get_player_by_name(player) then
			minetest.chat_send_player(name, "The Player is not online")
		else	
			minetest.chat_send_player(name, "The IP is \""..minetest.get_player_ip(player).."\".")
		end
	end,
})

function getip.save_ips()
	local output = io.open(minetest.get_worldpath() .. "/ips", "w")
	output:write(minetest.serialize(ips))
	io.close(output)
end

function getip.set_ip(player, ip)
	ips[player].ip = ip
	end
	geti.save_ips()
end
	
	
minetest.register_on_join_player(function(player)
	
