_G.cmdInfo = assert(loadfile("data.lua")())
dofile("libs/xml.lua")
dofile("libs/handler.lua")

function parseXML(XML)
	local handler = simpleTreeHandler()
	local parser = xmlParser(handler)
	parser:parse(XML)

	return parser._handler.root
end

local Command = {}
Command.__index = Command


function Command.new(arg)
	local _command = {}
	arg = arg or {}
	setmetatable(_command, Command)

	_command.fn = arg.fn or function() return end
	_command.channelcd = arg.channelcd or 60
	_command.usercd = arg.usercd or 60
	_command.guildcd = arg.guildcd or 0
	_command.restricted = arg.restricted or false
	_command.name = arg.name
	_command.remove = arg.remove or _command.channelcd

	_G.commands[_command.name] = _command

	return _command
end

function Command.init(dir)
	local f = assert(loadfile(dir))
	for k, v in pairs(f()) do
		Command.new(v)
	end
end

function Command:userAuth(message)
	local id = message.author.id
	if self.usercd == 0 then return true end
	if not _G.cd.user[id] then _G.cd.user[id] = 0 return true end

	if _G.cd.user[id] < os.time() then
		return true
	else
		return false
	end
end

function Command:guildAuth(message)
	local id = message.guild.id
	if self.guildcd == 0 then return true end
	if not _G.cd.guild[id] then _G.cd.guild[id] = 0 return true end

	if _G.cd.guild[id] < os.time() then
		return true
	else
		return false
	end
end

function Command:channelAuth(message)
	local id = message.channel.id
	if self.channelcd == 0 then return true end
	if not _G.cd.channel[id] then _G.cd.channel[id] = 0 return true end

	if _G.cd.channel[id] < os.time() then
		return true
	else
		return false
	end
end

function Command:setCd(message)
	_G.cd.user[message.author.id] = os.time() + self.usercd
	_G.cd.guild[message.guild.id] = os.time() + self.guildcd
	_G.cd.channel[message.channel.id] = os.time() + self.channelcd
end

function Command:allAuth(message)
	local hasAuth = false
	if self.restricted then
		hasAuth = message.author.id == "184262286058323968"
	else
		hasAuth = self:userAuth(message) and self:guildAuth(message) and self:channelAuth(message)
	end
	if hasAuth then
		self:setCd(message)
	end
	return hasAuth
end

function Command:tryDelete(sentMsg)
	if self.remove == 0 then return end

	_G.timer.setTimeout(self.remove * 1000, coroutine.wrap(sentMsg.delete), sentMsg)
end


function Command:run(message, override)
	if self:allAuth(message) or override then
		local sentMsg = self.fn(message)
		if sentMsg then
			self:tryDelete(sentMsg)
		end
		return sentMsg
	else
		return nil
	end
end

return Command