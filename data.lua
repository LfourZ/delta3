return {
	servers = {
		surf = "178.63.73.69:27017",
		s = "178.63.73.69:27017",
		bigcity = "178.63.73.69:27015",
		bc = "178.63.73.69:27015",
		pokemon = "178.63.73.69:27016",
		pm = "178.63.73.69:27016",
		mariokart = "178.63.73.69:27018",
		mk = "178.63.73.69:27018",
	},
	servernames = {
		surf = "Surf",
		s = "Surf",
		bigcity = "Bigcity",
		["big city"] = "Bigcity",
		bc = "Bigcity",
		pokemon = "Pokemon Trade",
		["poke mon"] = "Pokemon Trade",
		pm = "Pokemon Trade",
		mariokart = "Mariokart",
		mk = "Mariokart",
		["mario kart"] = "Mariokart",
	},
	sname = {
		["178.63.73.69:27015"] = "BigCity",
		["178.63.73.69:27016"] = "Pokémon",
		["178.63.73.69:27017"] = "Surf",
		["178.63.73.69:27018"] = "MarioKart",
	},
	id = {
		"BigCity---",
		"Pokémon---",
		"Surf------",
		"MarioKart-"
	},
	keys = {
		hearthstone = "Oss9o7BGrYmsh7URaJtspSfJgIlcp1wlH6kjsnqHZTQSFoyK29",
	},
	trackrs = {
		"L-4",
		"Pesky%20Prince",
	},
	skills = {
		"attack",
		"defence",
		"strength",
		"constitution",
		"ranged",
		"prayer",
		"magic",
		"cooking",
		"woodcutting",
		"fletching",
		"fishing",
		"firemaking",
		"crafting",
		"smithing",
		"mining",
		"herblore",
		"agility",
		"thieving",
		"slayer",
		"farming",
		"runecrafting",
		"hunter",
		"construction",
		"summoning",
		"dungeoneering",
		"divination",
		"invention",
	},
	parsers = function(data)
		local player = data
		player.skillvalues = nil
		player.stats = {}
		for k, v in pairs(data.skillvalues) do
			player.stats[_G.cmdInfo.skills[v.id+1]] = v
		end
		return player
	end,
}
