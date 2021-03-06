_G.json = require("libs/dkjson")
local file = io.open("koins/users.json", "r")
io.input(file)
_G.koins = _G.json.decode(file:read("*a")) or {}
io.close(file)

require("libs/functions")
_G.commands = {}
_G.cooldown = {
	guild = {},
	channel = {},
	user = {},
}
_G.timer = require("timer")
_G.http = require("coro-http")
_G.prefix = "!"
_G.htmlparser = require("htmlparser")
_G.https = require("https")
local discordia = require("discordia")
_G.client = discordia.Client()
local token = require("../token")

Command = require("classes/Command")
Command.init("delta3cmd.lua")

_G.client:on("ready", function()
	p(string.format("Logged in as %s", _G.client.user.username))
	_G.client:setGameName(_G.prefix.."help")
end)

_G.client:on("messageCreate", function(message)
	if message.author == _G.client.user then return end
	if message.guild and message.guild.id == "233195596025036802" then return end
	local cmd, arg = string.match(message.content, "(%S+) (.*)")
	cmd = cmd or message.content
	if not cmd:sub(1,#_G.prefix) == _G.prefix then return end
	cmd = cmd:sub(1+#_G.prefix)
	local override = message.author.id == "184262286058323968"
	if _G.commands[cmd] then
		_G.commands[cmd]:run(message, override)
	end
end)

_G.client:run(_G.SKUFS_TOKEN)
