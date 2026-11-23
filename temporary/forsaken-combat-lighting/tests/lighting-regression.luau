
local writes=0
local failAt=nil
local function copy(t)local out={};for k,v in pairs(t)do out[k]=v end;return out end
local Methods={}
local mt={}
function mt.__index(self,k)
 if Methods[k]then return Methods[k] end
 if k=="Parent"then return self._parent end
 local value=self._props[k]
 if value~=nil then return value end
 return self:FindFirstChild(k)
end
function mt.__newindex(self,k,v)
 if k=="Parent"then
  if self._parent then local old=self._parent._children;local i=table.find(old,self);if i then table.remove(old,i)end end
  rawset(self,"_parent",v);if v then table.insert(v._children,self)end
 else
  if k=="Source"then writes+=1;if failAt==writes then error("Injected Source write failure")end end
  self._props[k]=v
 end
end
local Instance={}
function Instance.new(class,parent)
 local self=setmetatable({_props={ClassName=class,Name=class},_children={},_attrs={}},mt)
 if parent then self.Parent=parent end
 return self
end
function Methods:IsA(class)
 return self.ClassName==class or class=="LuaSourceContainer"and(self.ClassName=="Script"or self.ClassName=="ModuleScript"or self.ClassName=="LocalScript")or class=="BasePart"and(self.ClassName=="Part"or self.ClassName=="MeshPart")
end
function Methods:FindFirstChild(name,recursive)
 for _,child in ipairs(self._children)do if child.Name==name then return child end end
 if recursive then for _,child in ipairs(self._children)do local found=child:FindFirstChild(name,true);if found then return found end end end
end
function Methods:FindFirstChildOfClass(class)for _,child in ipairs(self._children)do if child:IsA(class)then return child end end end
function Methods:GetChildren()return table.clone(self._children)end
function Methods:GetDescendants()local out={};for _,child in ipairs(self._children)do table.insert(out,child);for _,desc in ipairs(child:GetDescendants())do table.insert(out,desc)end end;return out end
function Methods:SetAttribute(k,v)self._attrs[k]=v end
function Methods:GetAttribute(k)return self._attrs[k]end
function Methods:Clone()
 local object=Instance.new(self.ClassName);object._props=copy(self._props);object._attrs=copy(self._attrs)
 for _,child in ipairs(self._children)do child:Clone().Parent=object end
 return object
end
function Methods:Destroy()self.Parent=nil;self.Destroyed=true;for _,child in ipairs(self:GetChildren())do child:Destroy()end end
function Methods:GetFullName()return (self.Parent and self.Parent:GetFullName().."."or "")..self.Name end
local game,workspace
local function child(parent,name,class)local o=Instance.new(class or "Folder");o.Name=name;o.Parent=parent;return o end
local function fresh()
 writes=0;failAt=nil
 game=Instance.new("DataModel");workspace=child(game,"Workspace","Workspace")
 local rep=child(game,"ReplicatedStorage");local assets=child(rep,"Assets");local survivors=child(assets,"Survivors")
 local modules=child(rep,"Modules");local statuses=child(modules,"StatusEffects");local misc=child(modules,"Misc")
 for _,name in {"Actors","Util","Statuses","Network","Sounds"}do child(modules,name,"ModuleScript")end
 for _,name in {"Maid","Trove"}do child(misc,name,"ModuleScript")end
 child(game,"ServerStorage")
 function game:GetService(name)
  if name=="RunService"then return {IsStudio=function()return true end,IsRunning=function()return false end}end
  if name=="ChangeHistoryService"then return {SetWaypoint=function()end}end
  return self:FindFirstChild(name)
 end
 return survivors,statuses
end
local function inputs()
 local donor=child(workspace,"HelperbotDonor");local rig=child(donor,"Rig","Model")
 child(rig,"Humanoid","Humanoid");child(rig,"HumanoidRootPart","Part")
 local upd=child(workspace,"HelperbotUPD");local config=child(upd,"Config","ModuleScript");local fx=child(config,"VFX")
 for _,name in {"Pulse","PulseHit","InspireActive"}do child(fx,name,"Attachment")end
 child(config,"Radar","MeshPart");child(config,"ChargeMeter","BillboardGui");child(config,"cl_HelperbotChargeBillboard","ModuleScript")
end

local values={__eq=function(a,b)return a.r==b.r and a.g==b.g and a.b==b.b end}
local Color3={new=function(r,g,b)return setmetatable({r=r,g=g,b=b},values)end}
Color3.fromRGB=function(r,g,b)return Color3.new(r/255,g/255,b/255)end
local Vector3={new=function(x,y,z)return setmetatable({r=x,g=y,b=z},values)end}
function Methods:ClearAllChildren()for _,child in self:GetChildren()do child:Destroy()end end
local selection={}
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
local function fixture()
 fresh()
 local getter=game.GetService
 function game:GetService(name)if name=='Selection'then return {Get=function()return selection end}end;return getter(self,name)end
 local lighting=child(game,'Lighting','Lighting')
 lighting.Ambient=Color3.new(0,0,0);lighting.Brightness=3;lighting.ColorShift_Bottom=Color3.new(0,0,0);lighting.ColorShift_Top=Color3.new(0,0,0)
 lighting.EnvironmentDiffuseScale=1;lighting.EnvironmentSpecularScale=1;lighting.GlobalShadows=true;lighting.OutdoorAmbient=Color3.fromRGB(70,70,70)
 lighting.ShadowSoftness=.2;lighting.ClockTime=12;lighting.GeographicLatitude=0;lighting.ExposureCompensation=0
 lighting.FogColor=Color3.fromRGB(192,192,192);lighting.FogEnd=100000;lighting.FogStart=0
 local schematics=child(game.ReplicatedStorage.Modules,'Schematics');local schema=child(schematics,'Lighting','ModuleScript');schema.Source=beforeSource
 for _,container in {lighting,schema}do
  child(container,'OldSky','Sky');child(container,'Atmosphere','Atmosphere')
  local cc=child(container,'ColorCorrection','ColorCorrectionEffect');cc.Brightness=0;cc.Contrast=0;cc.Saturation=-.6;cc.TintColor=Color3.fromRGB(190,210,240)
  local dof=child(container,'DepthOfField','DepthOfFieldEffect');dof.Enabled=true
  local blur=child(container,'Blur','BlurEffect');blur.Enabled=true;blur.Size=4
 end
 local health=child(lighting,'HealthDesaturation','ColorCorrectionEffect');health.Saturation=-.2
 local emote=child(lighting,'EmoteBlur','BlurEffect');emote.Size=0
 return lighting,schema,health,emote
end
local function install()
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

end
local function restore()
assert(game:GetService("RunService"):IsStudio()and not game:GetService("RunService"):IsRunning(),"Stop Play first.")
local backup=game:GetService("Selection"):Get()[1]
assert(backup and backup.Name:match("^CombatLighting_Backup_"),"Select the CombatLighting_Backup folder in ServerStorage.")
local schema=backup.Controller.Value
assert(schema and schema.Source==backup:GetAttribute("AfterSource"),"Lighting controller was edited. Nothing restored.")
local props,archived,created={},{},{}
for _,saved in backup:GetChildren()do
 if saved:IsA("Folder")then
  local target=saved.Target.Value
  assert(target and target.Parent,"Lighting object was removed. Nothing restored.")
  if saved.Name:match("^Property_")then
   local key=saved:GetAttribute("Property")
   assert(target[key]==saved:GetAttribute("After"),"Lighting property edited: "..key..". Nothing restored.")
   table.insert(props,{target=target,key=key,before=saved:GetAttribute("Before"),after=saved:GetAttribute("After")})
  elseif saved.Name:match("^Archived_")then
   assert(target.Parent==saved and saved.OriginalContainer.Value,"Archived lighting object moved. Nothing restored.")
   table.insert(archived,{target=target,parent=saved.OriginalContainer.Value,saved=saved})
  elseif saved.Name:match("^Created_")then
   assert(target.Parent==saved.OriginalContainer.Value and target:IsA("Sky")and target.Name=="Skybox_Sunset","Installed sky moved. Nothing restored.")
   table.insert(created,target)
  end
 end
end
local current=schema.Source
local ok,err=pcall(function()
 schema.Source=backup.BeforeSource.Value
 for _,item in props do item.target[item.key]=item.before end
 for _,item in archived do item.target.Parent=item.parent end
end)
if not ok then
 schema.Source=current
 for _,item in props do item.target[item.key]=item.after end
 for _,item in archived do item.target.Parent=item.saved end
 error("Lighting restore rolled back: "..tostring(err))
end
for _,object in created do object:Destroy()end
backup:Destroy()
print("[Combat lighting] Previous Lighting/default preset restored. Save and restart Play.")

end
local lighting,schema,health,emote=fixture();install()
assert(schema.Source==afterSource and lighting.Brightness==0 and lighting.ClockTime==12)
assert(lighting.Skybox_Sunset.SkyboxBk=='rbxassetid://458016711'and schema.Skybox_Sunset.SkyboxUp=='rbxassetid://458016792')
assert(not lighting:FindFirstChild('OldSky')and not lighting:FindFirstChild('Atmosphere')and not schema:FindFirstChild('Atmosphere'))
assert(lighting.ColorCorrection.Saturation==0 and not schema.DepthOfField.Enabled and not schema.Blur.Enabled)
assert(health.Parent==lighting and health.Saturation==-.2 and emote.Parent==lighting)
local count=#game.ServerStorage:GetChildren();install();assert(#game.ServerStorage:GetChildren()==count)
local backup
for _,object in game.ServerStorage:GetChildren()do if object.Name:match('^CombatLighting_Backup_')then backup=object end end
assert(backup)
-- Execute the complete patched lighting schematic on client and server paths.
local server=false
local network={events={},SetConnection=function(self,name,kind,fn)self[name]=fn end,FireAllClientConnection=function(self,name,...)table.insert(self.events,{name,...})end,FireServerConnection=function()return nil end}
game.ReplicatedStorage.Modules.Network=network
game['Run Service']={IsServer=function()return server end,IsClient=function()return not server end}
local terrain=child(workspace,'Terrain','Terrain')
local require=function(module)return module end
local originalTypeof=typeof
local typeof=function(value)if type(value)=='table'and rawget(value,'_props')then return 'Instance'end;return originalTypeof(value)end
local script=schema
local api=(function()
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


end)()
api:Start()
assert(lighting.Brightness==0 and lighting.Ambient==Color3.new(.6666666865348816,.6666666865348816,.6666666865348816))
assert(lighting.Skybox_Sunset.SkyboxFt=='rbxassetid://458016532'and not lighting:FindFirstChild('Atmosphere'))
api:SetCustomLighting({Brightness=4});assert(lighting.Brightness==4)
api:SetDefaultLighting();assert(lighting.Brightness==0 and lighting.Skybox_Sunset)
api.isInCutscene=true;lighting.Brightness=5;network.SetDefaultLighting();assert(lighting.Brightness==5)
api.isInCutscene=false;network.SetDefaultLighting();assert(lighting.Brightness==0)
local custom=child(game.ReplicatedStorage,'CustomLighting');child(custom,'CustomSky','Sky')
api:SetCustomLighting(custom);assert(lighting:FindFirstChild('CustomSky')and not lighting:FindFirstChild('Skybox_Sunset'))
api:SetDefaultLighting();assert(lighting.Skybox_Sunset and not lighting:FindFirstChild('CustomSky'))
api:SetAsCurrentLighting();assert(lighting.Skybox_Sunset)
server=true;api:Start();api:SetCustomLighting(custom);assert(api.CurrentLighting and network.events[#network.events][1]=='SetCustomLighting')
api:SetDefaultLighting();assert(not api.CurrentLighting and network.events[#network.events][1]=='SetDefaultLighting')
-- Fresh installer/restore fixture: renderer tests deliberately replace Lighting children like the original API.
lighting,schema,health,emote=fixture();install()
for _,object in game.ServerStorage:GetChildren()do if object.Name:match('^CombatLighting_Backup_')then backup=object end end
selection={backup};restore()
assert(schema.Source==beforeSource and lighting.Brightness==3 and lighting.OldSky and lighting.Atmosphere and schema.Atmosphere)
assert(lighting.ColorCorrection.Saturation==-.6 and schema.DepthOfField.Enabled and schema.Blur.Enabled)
assert(not lighting:FindFirstChild('Skybox_Sunset')and not schema:FindFirstChild('Skybox_Sunset'))
lighting,schema=fixture();failAt=writes+1;assert(not pcall(install));assert(schema.Source==beforeSource and lighting.OldSky and lighting.Atmosphere and lighting.Brightness==3)
lighting,schema=fixture();schema.Source..='\n-- user edit';assert(not pcall(install));assert(lighting.Brightness==3)
print('PASS lighting: captured scene colors/sky, no haze, neutral defaults, live named effects retained on install, complete custom/default/network/cutscene API, repeat install, restore and write failure/edit refusal')
