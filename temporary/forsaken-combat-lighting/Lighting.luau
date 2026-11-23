local t1 = {
	isInCutscene = false
}
local Network = require(game.ReplicatedStorage.Modules.Network)

t1.Properties = {
    Ambient = Color3.new(0.6666666865348816,0.6666666865348816,0.6666666865348816),
    Brightness = 0.0,
    ColorShift_Bottom = Color3.new(0.0,0.0,0.0),
    ColorShift_Top = Color3.new(0.0,0.0,0.0),
    EnvironmentDiffuseScale = 1.0,
    EnvironmentSpecularScale = 1.0,
    GlobalShadows = true,
    OutdoorAmbient = Color3.new(0.729411780834198,0.6000000238418579,0.364705890417099),
    ShadowSoftness = 0.0,
    ClockTime = 12,
    GeographicLatitude = 0.0,
    ExposureCompensation = 0.0,
    FogColor = Color3.new(0.7529411911964417,0.7529411911964417,0.7529411911964417),
    FogEnd = 100000.0,
    FogStart = 0.0,
}

function t1.SetAsCurrentLighting(_) -- line: 28
	-- upvalues: t1 (copy), Network (copy)
	if game["Run Service"]:IsServer() then
		return
	end

	t1:SetDefaultLighting()

	local v4 = Network:FireServerConnection("GetCurrentLighting", "REMOTE_FUNCTION")

	if v4 then
		t1:SetCustomLighting(v4)
	end
end
function t1.SetCustomLighting(_: {[any]: any}, p2, _: string) -- line: 43
	-- upvalues: t1 (copy), Network (copy)
	if game["Run Service"]:IsServer() then
		if typeof(p2) == "Instance" and p2:IsA("Folder") then
			p2 = p2:Clone()
			p2.Name = "CurrentReplicatedLighting"
			p2.Parent = game.ReplicatedStorage
		end

		t1.CurrentLighting = p2
		Network:FireAllClientConnection("SetCustomLighting", "REMOTE_EVENT", p2)

		return
	end

	if typeof(p2) == "Instance" and p2:IsA("Folder") then
		game.Lighting:ClearAllChildren()

		local Clouds = workspace.Terrain:FindFirstChildOfClass("Clouds")

		if Clouds then
			Clouds:Destroy()
		end

		for _, child in pairs(p2:GetChildren()) do
			local v11 = child

			if v11:IsA("ModuleScript") then
				local lib = require(v11)

				t1:SetCustomLighting(lib)
			else
				local clone = v11:Clone()

				if clone:IsA("Clouds") then
					clone.Parent = workspace:FindFirstChildOfClass("Terrain")
				else
					clone.Parent = game.Lighting
				end
			end
		end

		return
	end

	for k, v in pairs(p2 or {}) do
		game.Lighting[k] = v
	end
end
function t1.SetDefaultLighting(_) -- line: 90
	-- upvalues: t1 (copy), Network (copy)
	if game["Run Service"]:IsServer() then
		if typeof(t1.CurrentLighting) == "Instance" then
			t1.CurrentLighting:Destroy()
		end

		t1.CurrentLighting = nil
		Network:FireAllClientConnection("SetDefaultLighting", "REMOTE_EVENT")

		return
	end

	t1:SetCustomLighting(t1.Properties)
	game.Lighting:ClearAllChildren()

	for _, child in pairs(script:GetChildren()) do
		child:Clone().Parent = game.Lighting
	end
end
function t1.Start(_) -- line: 115
	-- upvalues: Network (copy), t1 (copy)
	if game["Run Service"]:IsServer() then
		Network:SetConnection("GetCurrentLighting", "REMOTE_FUNCTION", function(p5) -- line: 120
			-- upvalues: t1 (copy)
			if t1.CurrentLighting then
				local clone = t1.CurrentLighting:Clone()

				clone.Parent = p5.PlayerGui
				game.Debris:AddItem(clone, 20)

				return clone
			end
		end)

		return
	end

	if game["Run Service"]:IsClient() then
		Network:SetConnection("SetCustomLighting", "REMOTE_EVENT", function(p6) -- line: 132
			-- upvalues: t1 (copy)
			t1:SetCustomLighting(p6)
		end)
		Network:SetConnection("SetDefaultLighting", "REMOTE_EVENT", function() -- line: 137
			-- upvalues: t1 (copy)
			if t1.isInCutscene then
				return
			end

			t1:SetDefaultLighting()
		end)
		t1:SetDefaultLighting()
	end
end

return t1

