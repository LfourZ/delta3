return {
	-- {
	-- 	fn = function(message)
	-- 		return message:reply("test")
	-- 	end,
	-- 	usercd = 30,
	-- 	guildcd = 0,
	-- 	channelcd = 30,
	-- 	restricted = true,
	-- 	name = "test",
	-- 	remove = 10,
	-- }
	{
		fn = function(message)
			local res, data = _G.http.request("GET", "http://stats.skufs.net/api/serverlist/country/se")
			handler = simpleTreeHandler()
			parser = xmlParser(handler)
			parser:parse(data)
			data = parser._handler.root.gameME
			local sstr = ""
			local surfMap = ""
			for k, v in pairs(data.serverlist.server) do
				sstr=sstr.."`".._G.cmdInfo.id[tonumber(v.id)]..": "..v.act.."/"..v.max.."` [Click to join](steam://connect/"..v.addr..":"..v.port..")\n"
				if v.id == "3" then
					surfMap = v.map
				end
			end
			if surfMap then
				sstr = sstr.."Surf map: `"..surfMap.."`"
				if surfMap:sub(1,5) == "surf_" then
					surfMap = surfMap:sub(6)
				end
				--_G.client:setGameName(surfMap) --Only source of game name change, will be outdated frequently
			end
			if not message.channel.isPrivate then
				message:delete()
			end
			return message:reply({embed={
				title="Serverlist",
				color="16711680",
				description=sstr,
			}})
		end,
		usercd = 0,
		guildcd = 0,
		channelcd = 20,
		restricted = false,
		name = "servers",
		remove = 20,
	},
	{
		fn = function(message)
		if not message.author.id == "184262286058323968" then return end
		local _, url = string.match(message.content, "(%S+) (%S+)")
		local _, _, name = string.match(message.content, "(%S+) (%S+) (.*)")
		if not url then return end
		if url:sub(1,4) ~= "http" or #url < 4 then
			url = "http://"..url
		end
		name = name or "Shortened link"
		if not message.channel.isPrivate then
			message:delete()
		end
		return message:reply({embed={
			color="16711680",
			description="["..name.."]("..url..")"
		}})
	end,
	usercd = 15,
	guildcd = 0,
	channelcd = 0,
	restricted = false,
	name = "shorten",
	remove = 0,
	}
}
