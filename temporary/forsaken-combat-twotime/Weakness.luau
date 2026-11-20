
return {
	Data = {
		Duration = 10,
		MaxLevel = 10,
		Stackable = false,
		IsNegative = true,
		Description = "Makes you deal less damage.\nEvery level of this status makes you deal 10% less damage."
	},
	Applied = function(p1) -- line: 12
		if game["Run Service"]:IsServer() and p1.Character then
			local num = tonumber(p1.Level * 10)

			if num then
				p1.Character:SetAttribute("WeaknessNerf", num)
			end
		end
	end,
	Removed = function(p2) -- line: 21
		if game["Run Service"]:IsServer() and p2.Character then
			p2.Character:SetAttribute("WeaknessNerf", nil)
		end
	end
}
