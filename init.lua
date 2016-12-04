getip = {}

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
