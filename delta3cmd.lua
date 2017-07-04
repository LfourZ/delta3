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
				sstr=sstr.."`".._G.cData.id[tonumber(v.id)]..": "..v.act.."/"..v.max.."` [Click to join](steam://connect/"..v.addr..":"..v.port..")\n"
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
			tryDelete(message)
			return message:reply({embed={
				title="Serverlist",
				color="16711680",
				description=sstr,
			}})
		end,
		usercd = 10,
		guildcd = 0,
		channelcd = 0,
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
			tryDelete(message)
			return message:reply({embed={
				color="16711680",
				description="["..name.."]("..url..")",
				author={
					name=message.author.name,
					icon_url=message.author.avatarUrl
				}
			}})
		end,
		usercd = 10,
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
					if not v.restricted or v.hidden then
						msg = msg.._G.prefix..v.name..string.rep(" ", 10-#v.name).."┃  ".._G.prefix..v.usage.."\n"
					end
				end
				msg = msg.."```"
			end
			tryDelete(message)
			return message:reply(msg)
		end,
		usercd = 10,
		guildcd = 0,
		channelcd = 0,
		restricted = false,
		name = "help",
		remove = 10,
		usage = "help [command]",
		usageLong =
[[If a command isn't specified, shows list of all commands.
If a command is specified, shows detailed description of command.]]
	},
	{
		fn = function(message)
			tryDelete(message)
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
			tryDelete(message)
			return message:reply(msg)
		end,
		usercd = 120,
		guildcd = 0,
		channelcd = 0,
		restricted = false,
		name = "suggest",
		remove = 20,
		usage = "suggest <suggestion>",
		usageLong =
[[You can use this command to suggest a feature, or report a bug.]],
	},
	{
		fn = function(message)
			local _, server = string.match(message.content, "(%S+) (.*)")
			local data = ""
			local s = {}
			local admins = _G.https.request({host="skufs.net",path="/admins"}, function (res)
				res:on("data", function (chunk)
					data = data..chunk
				end)
				res:on("end", function()
					local root = _G.htmlparser.parse(data)
					local l1 = root:select(".staff_column")
					for _, e1 in ipairs(l1) do
						local server = e1:select("h2")[1]:getcontent()
						s[server] = s[server] or {}
						local l2 = e1:select("li")
						for _, e2 in ipairs(l2) do
							local onlineStatus = e2:select("div")[1]
							s[server][e2:select("a")[1]:getcontent()] = {
								online = getOnline(onlineStatus.classes),
								lastOnline = lastOnline(onlineStatus:getcontent()),
								id = e2:select("a")[1].attributes.href:match("(%d+)"),
								role = "admin",
							}
						end
					end
					data = ""
					local moderators = _G.https.request({host="skufs.net",path="/moderators"}, function (res)
						res:on("data", function (chunk)
							data = data..chunk
						end)
						res:on("end", function()
							local root = _G.htmlparser.parse(data)
							local l1 = root:select(".staff_column")
							for _, e1 in ipairs(l1) do
								local server = e1:select("h2")[1]:getcontent()
								s[server] = s[server] or {}
								local l2 = e1:select("li")
								for _, e2 in ipairs(l2) do
									local onlineStatus = e2:select("div")[1]
									s[server][e2:select("a")[1]:getcontent()] = {
										online = getOnline(onlineStatus.classes),
										lastOnline = lastOnline(onlineStatus:getcontent()),
										id = e2:select("a")[1].attributes.href:match("(%d+)"),
										role = "moderator",
									}
								end
							end
							local msg = ""
							local title = ""
							if not server then
								title = "Online staff"
								for k, v in pairs(s) do
									msg = msg.."__**"..k.."**__\n"
									local anyOnline = false
									for i, j in pairs(v) do
										if j.online then
											msg = msg.."["..getEmoji(true, j.role)..i.."](http://steamcommunity.com/profiles/"..j.id..")".."\n"
											anyOnline = true
										end
									end
									if not anyOnline then
										msg = msg.."No staff online\n"
									end
								end
							else
								server = server:lower()
								if _G.cData.servernames[server] ~= nil then
									local serverTitle = _G.cData.servernames[server]
									title = serverTitle.." staff:"
									local offlineStaff = ""
									local onlineStaff = ""
									local offlineEmoji = ":red_circle:"
									local onlineEmoji = ":large_blue_circle:"
									for k, v in pairs(s[serverTitle]) do
										local online = ""
										if v.online then
											onlineStaff = onlineStaff..getEmoji(v.online, v.role).."["..k.."](http://steamcommunity.com/profiles/"..v.id..")\n"
										else
											offlineStaff = offlineStaff..getEmoji(v.online, v.role).."["..k.."](http://steamcommunity.com/profiles/"..v.id..") "..v.lastOnline.d.."/"..v.lastOnline.m.."\n"
										end
									end
									msg = msg..onlineStaff..offlineStaff
								else
									title = "Unknown server '"..server.."'"
								end
							end
							return coroutine.wrap(message.reply)(message,
							{embed={
								title=title,
								color="16711680",
								description=msg,
							}})
						end)
					end)
					moderators:done()
				end)
			end)
			admins:done()
		end,
		usercd = 10,
		guildcd = 0,
		channelcd = 0,
		restricted = false,
		name = "staff",
		remove = 10,
		usage = "staff [server]",
		usageLong =
[[Lists online staff on the servers.
If server is specified, lists all staff on server (including offline staff).]],
	},
	{
		fn = function(message)
			local msg = ""
			for k, v in pairs(_G.cData.sname) do
				msg = msg.."["..v.."](steam://connect/"..k..")\n"
			end
			tryDelete(message)
			return message:reply(
			{embed={
				title = "Click to join!",
				description = msg,
			}})
		end,
		udercd = 20,
		guildcd = 0,
		channelcd = 0,
		restricted = false,
		name = "join",
		remove = 20,
		usage = "join",
		usageLong =
[[Sends list of links to join the servers.]],
	},
	{
		fn = function(message)
			if message.channel.id ~= "330449896408875019" then return end
			local _, send = message.content:match("(%S+) (.*)")
			local msg
			if not send then
				print("something went wrong!")
				return
			elseif #send > 255 then
				msg = "`Message cannot be longer than 255 characters.`"
			else
				send = send:gsub("%s", "_")
				local res, data = http.request("GET", "http://api.program-o.com/v2/chatbot/?bot_id=6&say="..send.."&convo_id="..message.author.id.."&format=json")
				p(data)
				data = _G.json.decode(data)
				msg = (message.member.nickname or message.author.name).." > "..data.botsay:sub(1,1)..data.botsay:sub(2):lower()
			end
			return message:reply(msg)
		end,
		usercd = 5,
		guildcd = 0,
		channelcd = 0,
		restricted = false,
		hidden = true,
		name = "cb",
		remove = 0,
		usage = "chatbot <message>",
		usageLong =
[[It's a chatbot, it doens't need explaining, come on. This command is probably temporary.]]
	},
	{
		fn = function(message)
			local _, type, opt = message.content:match("(%S+) (%S+) (.*)")
			local options = {}
			for w in opt:gmatch("([^;]+)") do
				table.insert(options, w)
			end
			
		end,
		name = "callvote",
		usercd = 0,
		guildcd = 0,
		channelcd = 0,
		remove = 0,
		restricted = true,
		hidden = true,
		usage = "",
		usageLong = "",
	}
}
