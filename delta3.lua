_G.commands = {}
_G.cd = {
	guild = {},
	channel = {},
	user = {},
}
_G.other = {
	cachenotify = {}
}
_G.timer = require("timer")
_G.http = require("coro-http")
_G.json = require("libs/dkjson")
_G.prefix = "!"
local discordia = require("discordia")
_G.client = discordia.Client()
local token = require("../token")
Command = require("classes/Command")
Command.init("delta3cmd.lua")


_G.client:on("ready", function()
	p(string.format("Logged in as %s", _G.client.user.username))
	_G.client:setGameName(_G.prefix.."help")
	-- _G.timer.setInterval(5000, function()
	-- 	coroutine.wrap(function()
	-- 		print("test")
	-- 	end)()
	-- end)
end)

_G.client:on("messageCreate", function(message)
	if message.author == _G.client.user then return end
	local cmd, arg = string.match(message.content, "(%S+) (.*)")
	cmd = cmd or message.content
	if not cmd:sub(1,1) == _G.prefix then return end
	cmd = cmd:sub(2)
	if _G.commands[cmd] then
		_G.commands[cmd]:run(message, false)
	end
end)

_G.client:run(_G.SKUFS_TOKEN)
