return {
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
		usage = "servers",
		usageLong =
[[Lists all servers as well as their player status, and a direct link to join.]],
	},
	{
		fn = function(message)
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
				description="["..name.."]("..url..")",
				author={
					name=message.author.name,
					icon_url=message.author.avatarUrl
				}
			}})
		end,
		usercd = 15,
		guildcd = 0,
		channelcd = 0,
		restricted = false,
		name = "shorten",
		remove = 0,
		usage = "shorten <url> [shortened name]",
		usageLong =
[[Creates a shortened link to the specified url.]],
	},
	{
		fn = function(message)
			local cmd, help = string.match(message.content, "(%S+) (%S+)")
			local msg = ""
			if help then
				if not commands[help] then
					msg = "`No command '"..help.."'`"
				else
					msg = "```Usage: ".._G.prefix..commands[help].usage.."\n"..commands[help].usageLong.."```"
				end
			else
				msg = "```Use ".._G.prefix.."help <command> to get more info about a specific command\nCommand       Usage    <required>     [optional]\n━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n"
				for k, v in pairs(commands) do
					if not v.restricted then
						msg = msg.._G.prefix..v.name..string.rep(" ", 10-#v.name).."┃  ".._G.prefix..v.usage.."\n"
					end
				end
				msg = msg.."```"
			end
			if not message.channel.isPrivate then
				message:delete()
			end
			return message:reply(msg)
		end,
		usercd = 20,
		guildcd = 0,
		channelcd = 20,
		restricted = false,
		name = "help",
		remove = 20,
		usage = "help [command]",
		usageLong =
[[If a command isn't specified, shows list of all commands.
If a command is specified, shows detailed description of command.]]
	},
	-- {
	-- 	fn = function(message)
	-- 		for k, v in pairs(_G.cmdInfo.tackrs) do
	-- 			local res, data = _G.http.request("GET", "https://apps.runescape.com/runemetrics/profile/profile?user="..v.."&activities=0")
	-- 			data = json.decode(data)
	-- 			newstats = _G.cmdInfo.parsers(data)
	-- 			local file = io.open("data/rs/"..v..".json", "W+")
	-- 			io.input(file)--NOT DONE AT ALL
	-- 		end
	-- 	end,
	-- 	name = "updaters",
	-- 	restricted = true,
	-- },
	{
		fn = function(message)
			if not message.channel.isPrivate then
				message:delete()
			end
			return message:reply("http://steamcommunity.com/groups/skufs")
		end,
		usercd = 20,
		guildcd = 0,
		channelcd = 20,
		restricted = false,
		name = "group",
		remove = 20,
		usage = "group",
		usageLong =
[[Dislpays link to the SKUFS steam group.]]
	},
	{
		fn = function(message)
			local _, suggestion = string.match(message.content, "(%S+) (.*)")
			local msg = ""
			local suggestionFull = ""
			if not suggestion then
				msg = "TODO"
			else
				suggestionFull = "```"..message.author.id.." ("..message.author.name..") said in "..message.guild.id.." ("..
				message.guild.name.."): "..suggestion.."```"
				msg = "`Your suggestion has been submitted`"
			end
			if suggestionFull then
				_G.client:getUser("184262286058323968"):sendMessage(suggestionFull)
			end
			if not message.channel.isPrivate then
				message:delete()
			end
			return message:reply(msg)
		end,
		usercd = 120,
		guildcd = 0,
		channelcd = 20,
		restricted = false,
		name = "suggest",
		remove = 20,
		usage = "suggest <suggestion>",
		usageLong =
[[You can use this command to suggest a feature, or report a bug.]],
	}
}
