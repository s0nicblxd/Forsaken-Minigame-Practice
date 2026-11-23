assert(game:GetService("RunService"):IsStudio()and not game:GetService("RunService"):IsRunning(),"Stop Play before porting combat lighting.")
local beforeSource=[========[
local t1 = {
	isInCutscene = false
}
local Network = require(game.ReplicatedStorage.Modules.Network)

t1.Properties = {
	Ambient = Color3.fromRGB(0, 0, 0),
	Brightness = 2,
	ColorShift_Bottom = Color3.fromRGB(0, 0, 0),
	ColorShift_Top = Color3.fromRGB(0, 0, 0),
	EnvironmentDiffuseScale = 1,
	EnvironmentSpecularScale = 1,
	GlobalShadows = true,
	OutdoorAmbient = Color3.fromRGB(70, 70, 70),
	ShadowSoftness = 0.2,
	ClockTime = not workspace:GetAttribute("Testing") and 5.4 or 12,
	GeographicLatitude = 0,
	ExposureCompensation = not workspace:GetAttribute("Testing") and 1.24 or 0,
	FogColor = Color3.fromRGB(192, 192, 192),
	FogEnd = 100000,
	FogStart = 0
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

]========]
local afterSource=[========[
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

]========]
local profile={
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
local skyProfile={
    CelestialBodiesShown = false,
    MoonAngularSize = 0.0,
    MoonTextureId = "rbxasset://sky/moon.jpg",
    SkyboxBk = "rbxassetid://458016711",
    SkyboxDn = "rbxassetid://458016826",
    SkyboxFt = "rbxassetid://458016532",
    SkyboxLf = "rbxassetid://458016655",
    SkyboxRt = "rbxassetid://458016782",
    SkyboxUp = "rbxassetid://458016792",
    SunAngularSize = 20.0,
    SunTextureId = "rbxasset://sky/sun.jpg",
    StarCount = 3000,
    SkyboxOrientation = Vector3.new(0.0,0.0,0.0),
}
local lighting=game:GetService("Lighting")
local schema=game:GetService("ReplicatedStorage").Modules.Schematics.Lighting
assert(schema:IsA("ModuleScript")and(schema.Source==beforeSource or schema.Source==afterSource),"Lighting controller differs from the supplied build. Nothing changed; send its Source for a matching port.")
if schema.Source==afterSource and schema:FindFirstChild("Skybox_Sunset")and lighting:FindFirstChild("Skybox_Sunset")then print("[Combat lighting] Already installed.");return end
local backup=Instance.new("Folder")
local prefix="CombatLighting_Backup_"..os.date("!%Y%m%d_%H%M%S");local index=0
while game.ServerStorage:FindFirstChild(prefix.."_"..index)do index+=1 end
backup.Name=prefix.."_"..index
local function reference(parent,name,value)local object=Instance.new("ObjectValue");object.Name=name;object.Value=value;object.Parent=parent end
reference(backup,"Controller",schema)
local savedSource=Instance.new("StringValue");savedSource.Name="BeforeSource";savedSource.Value=schema.Source;savedSource.Parent=backup
backup:SetAttribute("AfterSource",afterSource)
local props={};local archived={};local created={}
local function property(target,key,value)
 if target[key]~=value then table.insert(props,{target=target,key=key,before=target[key],after=value})end
end
for key,value in profile do property(lighting,key,value)end
for _,container in {lighting,schema}do
 for _,object in container:GetChildren()do
  if object:IsA("Sky")or object:IsA("Atmosphere")then
   table.insert(archived,{target=object,parent=container})
  elseif object:IsA("ColorCorrectionEffect")and object.Name=="ColorCorrection"then
   property(object,"Brightness",0);property(object,"Contrast",0);property(object,"Saturation",0);property(object,"TintColor",Color3.new(1,1,1))
  elseif object:IsA("DepthOfFieldEffect")then
   property(object,"Enabled",false)
  elseif object:IsA("BlurEffect")and object.Name=="Blur"then
   property(object,"Enabled",false);property(object,"Size",0)
  end
 end
end
for i,item in props do
 local saved=Instance.new("Folder");saved.Name="Property_"..i;reference(saved,"Target",item.target)
 saved:SetAttribute("Property",item.key);saved:SetAttribute("Before",item.before);saved:SetAttribute("After",item.after);saved.Parent=backup
end
for i,item in archived do
 local saved=Instance.new("Folder");saved.Name="Archived_"..i;reference(saved,"Target",item.target);reference(saved,"OriginalContainer",item.parent);saved.Parent=backup;item.saved=saved
end
backup.Parent=game.ServerStorage
local ok,err=pcall(function()
 schema.Source=afterSource
 for _,item in props do item.target[item.key]=item.after end
 for _,item in archived do item.target.Parent=item.saved end
 for _,container in {lighting,schema}do
  local sky=Instance.new("Sky");table.insert(created,sky);sky.Name="Skybox_Sunset"
  for key,value in skyProfile do sky[key]=value end
  sky.Parent=container
 end
 for i,sky in created do
  local saved=Instance.new("Folder");saved.Name="Created_"..i;reference(saved,"Target",sky);reference(saved,"OriginalContainer",sky.Parent);saved.Parent=backup
 end
end)
if not ok then
 schema.Source=savedSource.Value
 for _,item in props do item.target[item.key]=item.before end
 for _,item in archived do item.target.Parent=item.parent end
 for _,object in created do object:Destroy()end
 backup:Destroy();error("[Combat lighting] Rolled back: "..tostring(err))
end
pcall(function()game:GetService("ChangeHistoryService"):SetWaypoint("Forsaken Combat sunset lighting")end)
print("[Combat lighting] Sunset sky and saved lighting profile installed in live Lighting and the default preset. Save and start a new playtest. Backup: "..backup:GetFullName())
