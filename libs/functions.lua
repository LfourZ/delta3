function lastOnline(s)
	local f, l = s:match("(%d+)/(%d+)")
	if not f or not l then
		return lastOnline(os.date("%d/%m"))
	end
	return {d=f,m=l}
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
