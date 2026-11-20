
return {
	Data = {
		Duration = 10,
		MaxLevel = 10,
		Stackable = false,
		IsNegative = true,
		Description = "Makes you more susceptible to damage.\nEvery level of this status makes you receive 20% more damage."
	},
	Applied = function(p1) -- line: 12
		if game["Run Service"]:IsServer() and p1.Character then
			local num = tonumber(p1.Level * 20)

			if num then
				require(game.ReplicatedStorage.Modules.Util):CreateResistanceMultiplier(p1.Character, -num, "VulnerableStatus", p1.Data.Duration)
			end
		end
	end,
	Removed = function(p2) -- line: 22
		if game["Run Service"]:IsServer() and p2.Character then
			require(game.ReplicatedStorage.Modules.Util):CreateResistanceMultiplier(p2.Character, 1, "VulnerableStatus", 0)
		end
	end
}
