--[[				Getip
			Minetest Mod from Lejo
	Use it to get always the last ip of a player, if he isn't online.
]]

getip = {}

local ips = {}
local input = io.open(minetest.get_worldpath() .. "/ips", "r")
if input then
	ips = minetest.deserialize(input:read("*l"))
	io.close(input)
end

--Add the Privileg.
minetest.register_privilege("ip", "Player can get ip's from other players")

--Add the Functions
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

function getip.get_ip_string(name)
	return "Ip : " .. getip.get_ip(name)
end

local save_ips = getip.save_ips
local set_ip = getip.set_ip
local get_ip = getip.get_ip
local exist = getip.exist

--create new data for a player if it doesn't exist.
minetest.register_on_joinplayer(function(player)
	local name = player:get_player_name()
	local players_ip = minetest.get_player_ip(name)
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
	set_ip(name, players_ip)	
end)

--Creat the Command /getip.
minetest.register_chatcommand("getip", {
	params = "<player>",
	description = "Show other ips.",
	privs = {ip=true},
	func = function(name, player)
		if not minetest.get_player_by_name(player) then
			local players_ip = minetest.get_player_ip(name)
			minetest.chat_send_player(name, "The Player is not online")
			minetest.chat_send_player(name, "His last ip was: \""..players_ip.."\".")
		else	
			minetest.chat_send_player(name, "The IP is \""..minetest.get_player_ip(player).."\".")
		end
	end,
})
