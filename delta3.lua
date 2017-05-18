_G.commands = {}
_G.cd = {
	guild = {},
	channel = {},
	user = {},
}
_G.timer = require("timer")
_G.http = require("coro-http")
_G.prefix = "!"
Command = require("classes/Command")
Command.init("delta3cmd.lua")
local discordia = require("discordia")
local client = discordia.Client()
local token = require("../token")


client:on("ready", function()
	p(string.format("Logged in as %s", client.user.username))
end)

client:on("messageCreate", function(message)
	if message.author == client.user then return end
	local cmd, arg = string.match(message.content, "(%S+) (.*)")
	cmd = cmd or message.content
	if not cmd:sub(1,1) == _G.prefix then return end
	cmd = cmd:sub(2)
	if _G.commands[cmd] then
		_G.commands[cmd]:run(message, false)
	end
end)

client:run(_G.SKUFS_TOKEN)