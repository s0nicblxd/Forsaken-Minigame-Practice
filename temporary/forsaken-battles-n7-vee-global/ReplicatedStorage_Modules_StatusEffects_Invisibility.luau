local ParticleCloak=require(game.ReplicatedStorage.Modules.ParticleCloak)
local t1 = {
	Data = {
		Duration = 10,
		MaxLevel = 5,
		Stackable = false,
		Description = "Makes you translucent.\nEvery level of this status makes you 25% more transparent, capping at 92.5% transparency."
	}
}
local t2 = {
	[1] = 0.25,
	[2] = 0.5,
	[3] = 0.75,
	[4] = 0.915,
	[5] = 0.99,
	[6] = 1
}

local function grayscaleFactor(p1) -- line: 22
	local v7 = (p1.R + p1.G + p1.B) / 3

	return 1 - (math.abs(p1.R - v7) + math.abs(p1.G - v7) + math.abs(p1.B - v7)) / 3
end
local function brighten(p2, p3) -- line: 27
	return Color3.new(math.clamp(p2.R + p3, 0, 1), math.clamp(p2.G + p3, 0, 1), (math.clamp(p2.B + p3, 0, 1)))
end
local function changeProp(p4, p5, p6) -- line: 35
	if p6 ~= p4[p5] then
		p4[p5] = p6
	end
end

function t1.Applied(p7) -- line: 39
	-- upvalues: t2 (copy)
	if game["Run Service"]:IsServer() then
		if not p7.InstanceData then
			p7.InstanceData = {}

			for _, descendant in pairs(p7.Character:GetDescendants()) do
				local v16 = descendant:IsA("BasePart")
				local v17 = descendant:IsA("Decal")
				local v18 = descendant:IsA("ParticleEmitter")

				if v16 or v17 then
					p7.InstanceData[descendant] = {
						CastShadow = v16 and descendant.CastShadow or nil,
						Transparency = descendant.Transparency
					}
				elseif v18 then
					p7.InstanceData[descendant] = {
						Transparency = descendant.Transparency
					}
				end
			end
		end

		for _, descendant in pairs(p7.Character:GetDescendants()) do
			local v21 = descendant:IsA("BasePart")
			local v22 = descendant:IsA("Decal")
			local v23 = descendant:IsA("ParticleEmitter")

			if v21 or v22 then
				local v24 = if not v21 then v22 and "Color3" else "Color"

				if descendant.Transparency < 1 and v24 and descendant[v24] then
					if v21 then
						descendant.CastShadow = false
					end

					if descendant:FindFirstAncestorOfClass("Accessory") then
					else
						local v25 = descendant[v24]
						local v26 = (v25.R + v25.G + v25.B) / 3
						local _ = 1 - (math.abs(v25.R - v26) + math.abs(v25.G - v26) + math.abs(v25.B - v26)) / 3
					end

					local v28 = math.clamp(t2[p7.Level] or t2[5], 0, 1)

					if v28 ~= descendant.Transparency then
						descendant.Transparency = v28
					end
				end
			elseif v23 then
				local v29 = t2[p7.Level] or t2[5]
				local numberSequence = NumberSequence.new((math.clamp(v29, 0, 1)))

				if numberSequence ~= descendant.Transparency then
					descendant.Transparency = numberSequence
				end
			end
		end

        ParticleCloak.Start(p7)
		return
	end

	if not game["Run Service"]:IsClient() then
	end
end
function t1.Removed(p8) -- line: 95
    ParticleCloak.Stop(p8)
	if game["Run Service"]:IsServer() and p8.InstanceData then
		for k, v in pairs(p8.InstanceData) do
			for k2, v2 in pairs(v) do
				k[k2] = v2
			end
		end

		p8.TransparentInstances = nil
	end
end

return t1

