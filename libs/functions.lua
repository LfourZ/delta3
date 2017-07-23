function lastOnline(s)
	local f, l = s:match("(%d+)/(%d+)")
	if not f or not l then
		return lastOnline(os.date("%d/%m"))
	end
	return {d = f, m = l}
end

function getOnline(t)
	for k, v in pairs(t) do
		if v == "red" then
			return false
		elseif v == "green" then
			return true
		end
	end
end

function tryDelete(message)
	if not message.channel.isPrivate then
		message:delete()
	end
end

function getEmoji(online, role)
	if role == "admin" then
		if online then return "<:aon:328625304849481748>"
		else return "<:aoff:328625292149260308>" end
	elseif role == "moderator" then
		if online then return "<:mon:328625335371300865>"
		else return "<:moff:328625321727229954>" end
	end
end

function report(msg)
	_G.client:getUser("184262286058323968"):sendMessage(msg)
end
