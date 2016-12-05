getip = {}

local ips = {}
local input = io.open(minetest.get_worldpath() .. "/ips", "r")
if input then
	ips = minetest.deserialize(input:read("*l"))
	io.close(input)
end

--Add the Privileg.
minetest.register_privilege("ip", "Player can get ip's from other players")

function getip.save_ips()
	local output = io.open(minetest.get_worldpath() .. "/ips", "w")
	output:write(minetest.serialize(ips))
	io.close(output)
end

function getip.set_ip(player, ip)
	ips[player].ip = ip
	getip.save_ips()
end

function getip.get_ip(player)
	return ips[player].ip
end

function getip.exist(player)
	return ips[player] ~= nil
end

local save_ips = getip.save_ips
local set_ip = getip.set_ip
local get_ip = getip.get_ip
local exist = getip.exist

minetest.register_on_joinplayer(function(player)
	local name = player:get_player_name()
	if not exist(name) then
		local input = io.open(minetest.get_worldpath() .. "/getip_" .. name .. ".txt")
		if input then
			local n = input:read("*n")
			io.close(input)
			ips[name] = {ip = n}
			os.remove(minetest.get_worldpath() .. "/getip_" .. name .. ".txt")
			save_ips()
		else
			ips[name] = {ip = INITIAL_IP}
		end
	end
	local players_ip = minetest.get_player_ip(name)
	set_ip(name, players_ip)
		
end)

minetest.register_on_joinplayer(function(player)
	local name = player:get_player_name()
	local players_ip = minetest.get_player_ip(name)
	getip.set_ip(name, players_ip)
end)

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
