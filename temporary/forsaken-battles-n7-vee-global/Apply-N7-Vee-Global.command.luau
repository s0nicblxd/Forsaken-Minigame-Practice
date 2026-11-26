assert(not game:GetService("RunService"):IsRunning(),"Stop Play mode first.")
local changes={{path=[========[
ReplicatedStorage/Assets/Survivors/007n7/Config]========],edits={{[========[
CloneLifetime = 10,]========],[========[
CloneLifetime = 10,
    CursorCloneLifetime = 5,]========]}}},
{path=[========[
ReplicatedStorage/Assets/Survivors/007n7/Behavior]========],edits={{[========[
local v0 = {};]========],[========[
local GameplayPolish=require(game.ReplicatedStorage.Modules.GameplayPolish)
local v0 = {};]========]},{[========[
v42.AbilitiesDisabled = true;]========],[========[
v42.AbilitiesDisabled = true;
                local lifetime=GameplayPolish.CloneLifetime(v42.Config,(v41[v42.PathfindType]or v41[1]).Type);]========]},{[========[
game.Debris:AddItem(v46, v42.Config.CloneLifetime + 1);]========],[========[
game.Debris:AddItem(v46, lifetime + 1);]========]},{[========[
v46.Parent = workspace.Map.Ingame;]========],[========[
v46.Parent = workspace.Map.Ingame;
                    GameplayPolish.CloneTracker(v42,v46,lifetime);]========]},{[========[
v42.Config.CloneLifetime - 0.2]========],[========[
lifetime - 0.2]========]},{[========[
task.delay(v42.Config.CloneLifetime,]========],[========[
task.delay(lifetime,]========]},{[========[
v70:PivotTo(v88);]========],[========[
local completedFrom=v70.Rig.PrimaryPart.Position;
                            v70:PivotTo(v88);
                            GameplayPolish.TeleportReward(v70,completedFrom);]========]}}},
{path=[========[
ServerStorage/Assets/Survivors/007n7/Config]========],edits={{[========[
CloneLifetime = 10,]========],[========[
CloneLifetime = 10,
    CursorCloneLifetime = 5,]========]}}},
{path=[========[
ServerStorage/Assets/Survivors/007n7/Behavior]========],edits={{[========[
local v0 = {};]========],[========[
local GameplayPolish=require(game.ReplicatedStorage.Modules.GameplayPolish)
local v0 = {};]========]},{[========[
v42.AbilitiesDisabled = true;]========],[========[
v42.AbilitiesDisabled = true;
                local lifetime=GameplayPolish.CloneLifetime(v42.Config,(v41[v42.PathfindType]or v41[1]).Type);]========]},{[========[
game.Debris:AddItem(v46, v42.Config.CloneLifetime + 1);]========],[========[
game.Debris:AddItem(v46, lifetime + 1);]========]},{[========[
v46.Parent = workspace.Map.Ingame;]========],[========[
v46.Parent = workspace.Map.Ingame;
                    GameplayPolish.CloneTracker(v42,v46,lifetime);]========]},{[========[
v42.Config.CloneLifetime - 0.2]========],[========[
lifetime - 0.2]========]},{[========[
task.delay(v42.Config.CloneLifetime,]========],[========[
task.delay(lifetime,]========]},{[========[
v70:PivotTo(v88);]========],[========[
local completedFrom=v70.Rig.PrimaryPart.Position;
                            v70:PivotTo(v88);
                            GameplayPolish.TeleportReward(v70,completedFrom);]========]}}},
{path=[========[
ReplicatedStorage/Assets/Survivors/Veeronica/Config]========],edits={{[========[
Sk8BumpPower = 11.9]========],[========[
Sk8BumpPower = 12]========]},{[========[
"rbxassetid://108528126969003"]========],[========[
"rbxassetid://108528126969003",
        "rbxassetid://105731225723731",
        "rbxassetid://95163568129634"]========]},{[========[
    Expressions = {]========],[========[
    Instances = {
        SkatePointer = script.Parent.Behavior.SkatePointer,
        Tip = script.Parent.Behavior.Tip,
        SprayButton = script.Parent.Behavior.SprayButton,
        WipeButton = script.Parent.Behavior.WipeButton,
        VandalismPreset = script.Vandalism_PRESET,
        VandalismSprayBeam = script.SprayBeam_PRESET,
        VandalismDestroyedUI = script.SprayDestroyedUI,
        VandalismZoneVisual = script.ZonePole,
        BatteryUITemplate = script.BatteryUI_PRESET,
        Sk8UITemplate = script.SkateUI_PRESET,
        S8EffectsTemplate = script.S8VFX,
    },
    Expressions = {]========]}}},
{path=[========[
ReplicatedStorage/Assets/Survivors/Veeronica/Behavior/SprayVisual]========],edits={{[========[
-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local l_RunService_0 = game:GetService("RunService");
local l_ReplicatedStorage_0 = game:GetService("ReplicatedStorage");
local l_TweenService_0 = game:GetService("TweenService");
local v3 = require(l_ReplicatedStorage_0.Modules.Sounds);
local v4 = require(l_ReplicatedStorage_0.Modules.Util);
local _ = require(l_ReplicatedStorage_0.Modules.Network);
local v6 = require(l_ReplicatedStorage_0.Modules.Actors);
local _ = require(l_ReplicatedStorage_0.Modules.Statuses);
local v8 = require(l_ReplicatedStorage_0.Modules.Misc.Maid);
local v9 = {};
local v10 = {};
v10.__index = v10;
local function _(v11) --[[ Line: 34 ]] --[[ Name: __displayWarn ]]
    warn((("[Veeronica/SprayVisual]: %*"):format(v11)));
end;
local function _(v13, v14, v15) --[[ Line: 38 ]] --[[ Name: __changeProperty ]]
    if v13[v14] ~= v15 then
        v13[v14] = v15;
    end;
end;
v10.getObject = function(v17) --[[ Line: 44 ]] --[[ Name: getObject ]]
    -- upvalues: v9 (copy)
    return v9[v17];
end;
v10.new = function(v18, v19) --[[ Line: 48 ]] --[[ Name: new ]]
    -- upvalues: v10 (copy), v8 (copy), v4 (copy), v3 (copy), l_RunService_0 (copy)
    local v20 = setmetatable({}, v10);
    local v21 = v18.Player == game.Players.LocalPlayer;
    v20.Root = v19;
    v20.Owner = v18.Player;
    v20.IsLocal = v21;
    v20.Maid = v8.new();
    v20.Model = v20:Create(v18);
    v20.Range = v18.Config.VandalismRange;
    v20.Width = v18.Config.VandalismWidth;
    v20.LastProgression = v19:GetAttribute("Progression") or 0;
    v20.LastProgressionChange = 0;
    v20.Sounds = {};
    for _, v23 in ipairs({
        "Progression", 
        "Wiping", 
        "Completed", 
        "Destroyed"
    }) do
        local v24 = v18.Config.Sounds[("Spray%*"):format(v23)];
        if v24 then
            v20.Sounds[v23] = if typeof(v24) == "table" then v4:CopyTable(v24) else v24;
        else
            local v25 = ("Failed to cache sound %*!"):format(v23);
            warn((("[Veeronica/SprayVisual]: %*"):format(v25)));
        end;
    end;
    if v21 then
        v20.IndicationBeam = v20:CreateIndicationBeam(v18);
        v20.ProgressBar = v20:CreateProgressBar(v18);
        v20.RangeIndicator = v20:CreateRangeIndicator(v18);
        v20:ToggleBeam(true);
        v20:ToggleInRange(true);
    end;
    local v26 = v3:Play(v20.Sounds.Progression, {
        Looped = true, 
        Parent = v20.Model
    });
    local v27 = v3:Play(v20.Sounds.Wiping, {
        Looped = true, 
        Parent = v20.Model
    });
    v20.Maid:Add(l_RunService_0.PreRender:Connect(function() --[[ Line: 89 ]]
        -- upvalues: v20 (copy), v27 (copy), v26 (copy)
        if os.clock() - v20.LastProgressionChange < 0.05 then
            return;
        else
            local l_v27_0 = v27;
            if l_v27_0.Playing ~= false then
                l_v27_0.Playing = false;
            end;
            l_v27_0 = v26;
            if l_v27_0.Playing ~= false then
                l_v27_0.Playing = false;
            end;
            return;
        end;
    end));
    v20.Maid:Add(v19:GetAttributeChangedSignal("Progression"):Connect(function() --[[ Line: 95 ]]
        -- upvalues: v19 (copy), v20 (copy), v26 (copy), v27 (copy)
        local v29 = v19:GetAttribute("Progression") or 1;
        if v29 - v20.LastProgression > 0 then
            local l_v26_0 = v26;
            if l_v26_0.Playing ~= true then
                l_v26_0.Playing = true;
            end;
            l_v26_0 = v27;
            if l_v26_0.Playing ~= false then
                l_v26_0.Playing = false;
            end;
        elseif v29 - v20.LastProgression < 0 then
            local l_v27_1 = v27;
            if l_v27_1.Playing ~= true then
                l_v27_1.Playing = true;
            end;
            l_v27_1 = v26;
            if l_v27_1.Playing ~= false then
                l_v27_1.Playing = false;
            end;
        end;
        v20:ProgressionChanged(v29);
        v20.LastProgression = v29;
        v20.LastProgressionChange = os.clock();
    end));
    v20.Maid:Add(v19:GetAttributeChangedSignal("Completed"):Connect(function() --[[ Line: 112 ]]
        -- upvalues: v19 (copy), v3 (ref), v20 (copy)
        if v19:GetAttribute("Completed") then
            v3:Play(v20.Sounds.Completed, {
                Parent = v20.Model
            });
            v20:OnCompleted();
            return;
        else
            v20:OnUncompleted();
            return;
        end;
    end));
    v20.Maid:Add(v26);
    v20.Maid:Add(v27);
    v18.SprayVisuals[v19] = v20;
    return v20;
end;
v10.Destroy = function(v32) --[[ Line: 129 ]] --[[ Name: Destroy ]]
    -- upvalues: v3 (copy)
    if v32.Dead then
        return;
    else
        v32.Dead = true;
        local l_v32_Actor_0 = v32:GetActor();
        if l_v32_Actor_0 and l_v32_Actor_0.SprayVisuals then
            l_v32_Actor_0.SprayVisuals[v32.Root] = nil;
        else
            warn("Failed to remove cached SprayVisual!");
        end;
        v3:Play(v32.Sounds.Destroyed, {
            Parent = v32.Model
        });
        task.spawn(v32.ToggleBeam, v32, false);
        task.spawn(v32.OnDestroyed, v32);
        v32.Maid:Destroy();
        table.clear(v32);
        return;
    end;
end;
v10.Create = function(v34, v35) --[[ Line: 152 ]] --[[ Name: Create ]]
    local v36 = if v35 and v35.Player and v35.Player.Name == "ffPrankster" then {
        "rbxassetid://83450503791840"
    } else if math.random(1, 25000) == 1 then v35.Config.VandalismRareSprayImages else v35.Config.VandalismSprayImages;
    local v37 = v35.Config.VandalismPreset:Clone();
    assert(v37 and v37:IsA("BasePart"), "SprayVisual must be a BasePart!");
    v37.ImageBeam.Texture = v36[math.random(#v36)];
    v37.ImageBeam.Width0 = 3;
    v37.ImageBeam.Width1 = 3;
    v37.ImageBeam.Brightness = 0;
    v37.Name = ("%*Spray"):format(v35.Player.Name);
    v37.Parent = workspace.Map.Ingame;
    v37.CFrame = v34.Root:GetPivot() * CFrame.Angles(0, 3.141592653589793, 0);
    v37.Name = "GraffitiCL";
    return v37;
end;
v10.CreateIndicationBeam = function(v38, v39) --[[ Line: 171 ]] --[[ Name: CreateIndicationBeam ]]
    if not v39.Rig or not v39.Rig:FindFirstChild("Torso") then
        warn("[Veeronica/SprayVisual]: Failed to find torso for indication beam!");
        return;
    else
        local v40 = v39.Config.VandalismSprayBeam:Clone();
        v40.Enabled = false;
        v40.Attachment0 = v38.Model.AttachmentMain;
        v40.Attachment1 = v39.Rig.Torso.BodyBackAttachment;
        v40.Parent = v38.Model;
        return v40;
    end;
end;
v10.CreateProgressBar = function(v41, _) --[[ Line: 186 ]] --[[ Name: CreateProgressBar ]]
    local v43 = script.BillboardGui:Clone();
    v43.Parent = v41.Model;
    v43.StudsOffset = Vector3.new(0, 0, 0.05000000074505806, 0);
    return v43;
end;
v10.CreateRangeIndicator = function(v44, _) --[[ Line: 194 ]] --[[ Name: CreateRangeIndicator ]]
    -- upvalues: l_ReplicatedStorage_0 (copy)
    local v46 = l_ReplicatedStorage_0.Assets.Instances.Nothingburger:Clone();
    v46.Size = vector.create(v44.Width, v44.Width, v44.Range);
    v46.Parent = v44.Model;
    v46.CFrame = v44.Root:GetPivot() * CFrame.new(0, 0, v44.Range / 2 + 1);
    v46.Transparency = 1;
    v46.Name = "SprayRangeIndicator";
    return v46;
end;
v10.OnDestroyed = function(v47) --[[ Line: 206 ]] --[[ Name: OnDestroyed ]]
    -- upvalues: l_TweenService_0 (copy)
    local l_Model_0 = v47.Model;
    if l_Model_0 then
        local v49 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
        local l_ImageBeam_0 = l_Model_0.ImageBeam;
        local l_AttachmentBottom_0 = l_Model_0.AttachmentBottom;
        l_TweenService_0:Create(l_ImageBeam_0, v49, {
            Width0 = 0, 
            Width1 = 0, 
            Brightness = -0.5
        }):Play();
        l_TweenService_0:Create(l_AttachmentBottom_0, v49, {
            Position = Vector3.new(0, -2.5, 0, 0), 
            Orientation = Vector3.new(50, 0, 90, 0)
        });
        if v47.RangeIndicator then
            l_TweenService_0:Create(v47.RangeIndicator, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Transparency = 1
            }):Play();
        end;
        v47:ToggleBeam(false);
        game.Debris:AddItem(l_Model_0, 2);
        return;
    else
        warn("what is happpening");
        return;
    end;
end;
v10.ToggleInRange = function(v52, v53) --[[ Line: 229 ]] --[[ Name: ToggleInRange ]]
    v52.RangeIndicator.Color = if v53 then Color3.new(0, 1, 0) else Color3.new(1, 0, 0);
end;
v10.ToggleBeam = function(v54, v55) --[[ Line: 233 ]] --[[ Name: ToggleBeam ]]
    if not v54.IndicationBeam then
        return;
    else
        v54.IndicationBeam.Enabled = v55;
        v54:ToggleBar(v55 and not v54.Completed);
        return;
    end;
end;
v10.ToggleBar = function(v56, v57) --[[ Line: 240 ]] --[[ Name: ToggleBar ]]
    -- upvalues: l_TweenService_0 (copy)
    if not v56.ProgressBar then
        return;
    else
        local v58 = TweenInfo.new(0.35);
        l_TweenService_0:Create(v56.ProgressBar.Background, v58, {
            BackgroundTransparency = v57 and 0.35 or 1
        }):Play();
        l_TweenService_0:Create(v56.ProgressBar.Outline, v58, {
            BackgroundTransparency = v57 and 0.35 or 1
        }):Play();
        l_TweenService_0:Create(v56.ProgressBar.Background.Bar, v58, {
            BackgroundTransparency = v57 and 0.35 or 1
        }):Play();
        return;
    end;
end;
v10.UpdateBeam = function(v59, v60) --[[ Line: 250 ]] --[[ Name: UpdateBeam ]]
    if not v59.IndicationBeam then
        return;
    else
        local _ = v59:GetActor();
        local v62 = {
            IN = Color3.fromRGB(13, 255, 0), 
            INBAD = Color3.fromRGB(255, 204, 0), 
            OUT = Color3.fromRGB(255, 46, 46)
        };
        local v63 = v60 and (if v59.Completed then v62.IN else v62.INBAD) or v62.OUT;
        v59.IndicationBeam.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, v63), 
            ColorSequenceKeypoint.new(1, v63)
        });
        return;
    end;
end;
v10.ProgressionChanged = function(v64, v65) --[[ Line: 265 ]] --[[ Name: ProgressionChanged ]]
    -- upvalues: l_TweenService_0 (copy)
    local l_l_TweenService_0_Value_0 = l_TweenService_0:GetValue(math.clamp(v65 / 100, 0, 1), Enum.EasingStyle.Quad, Enum.EasingDirection.In);
    local l_Model_1 = v64.Model;
    local l_ImageBeam_1 = l_Model_1.ImageBeam;
    local _ = l_Model_1.AttachmentBottom;
    l_TweenService_0:Create(l_ImageBeam_1, TweenInfo.new(0.08), {
        Brightness = l_l_TweenService_0_Value_0 / 2 + 0.5, 
        Width0 = l_l_TweenService_0_Value_0 * 2 + 3, 
        Width1 = l_l_TweenService_0_Value_0 * 2 + 3
    }):Play();
    local v70 = if v64.IsLocal then 0.5 - l_l_TweenService_0_Value_0 * 0.5 else 0.9 - l_l_TweenService_0_Value_0 * 0.2;
    l_ImageBeam_1.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, v70), 
        NumberSequenceKeypoint.new(1, v70)
    });
    if v64 and v64.ProgressBar and v64.ProgressBar:FindFirstChild("Background") then
        l_TweenService_0:Create(v64.ProgressBar.Background.Bar, TweenInfo.new(0.05), {
            Size = UDim2.fromScale(l_l_TweenService_0_Value_0, 1)
        }):Play();
    end;
end;
v10.OnCompleted = function(v71) --[[ Line: 288 ]] --[[ Name: OnCompleted ]]
    -- upvalues: l_TweenService_0 (copy)
    v71.Completed = true;
    if v71.RangeIndicator then
        l_TweenService_0:Create(v71.RangeIndicator, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Transparency = 0.8
        }):Play();
    end;
    v71:ToggleBar(false);
    v71.Model.ImageBeam.LightEmission = 2;
    l_TweenService_0:Create(v71.Model.ImageBeam, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        LightEmission = 0
    }):Play();
end;
v10.OnUncompleted = function(v72) --[[ Line: 300 ]] --[[ Name: OnUncompleted ]]
    -- upvalues: l_TweenService_0 (copy)
    v72.Complete = false;
    v72:ToggleBar(true);
    if v72.RangeIndicator then
        l_TweenService_0:Create(v72.RangeIndicator, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Transparency = 1
        }):Play();
    end;
end;
v10.GetActor = function(v73) --[[ Line: 309 ]] --[[ Name: GetActor ]]
    -- upvalues: v6 (copy)
    return v6.CurrentActors[v73.Owner];
end;
return v10;]========],[========[
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Sounds = require(ReplicatedStorage.Modules.Sounds)
local Util = require(ReplicatedStorage.Modules.Util)

require(ReplicatedStorage.Modules.Network)

local Actors = require(ReplicatedStorage.Modules.Actors)

require(ReplicatedStorage.Modules.Statuses)

local Maid = require(ReplicatedStorage.Modules.Misc.Maid)
local t1 = {}
local t2 = {}

t2.__index = t2

local function __displayWarn(s1: string) -- line: 34
	warn(`[Veeronica/SprayVisual]: { s1 }`)
end
local function __changeProperty(p1, p2, p3) -- line: 38
	if p3 ~= p1[p2] then
		p1[p2] = p3
	end
end

function t2.getObject(p4) -- line: 44
	-- upvalues: t1 (copy)
	return t1[p4]
end
function t2.new(t3: {[any]: any}, p5) -- line: 48
	-- upvalues: t2 (copy), Maid (copy), Util (copy), Sounds (copy), RunService (copy)
	local self = setmetatable({}, t2)
	local v20 = t3.Player == game.Players.LocalPlayer

	self.Root = p5
	self.Owner = t3.Player
	self.IsLocal = v20
	self.Maid = Maid.new()
	self.Model = self:Create(t3)
	self.Range = t3.Config.VandalismRange
	self.Width = t3.Config.VandalismWidth
	self.LastProgression = p5:GetAttribute("Progression") or 0
	self.LastProgressionChange = 0
	self.Sounds = {}

	for _, v in ipairs({
		"Progression",
		"Wiping",
		"Completed",
		"Destroyed"
	}) do
		local v23 = t3.Config.Sounds[`Spray{ v }`]

		if v23 then
			self.Sounds[v] = if typeof(v23) ~= "table" then v23 else Util:CopyTable(v23)
		else
			local v24 = `Failed to cache sound { v }!`

			warn(`[Veeronica/SprayVisual]: { v24 }`)
		end
	end

	if v20 then
		self.IndicationBeam = self:CreateIndicationBeam(t3)
		self.ProgressBar = self:CreateProgressBar(t3)
		self.RangeIndicator = self:CreateRangeIndicator(t3)
		self:ToggleBeam(true)
		self:ToggleInRange(true)
	end

	local v25 = Sounds:Play(self.Sounds.Progression, {
		Looped = true,
		Parent = self.Model
	})
	local v26 = Sounds:Play(self.Sounds.Wiping, {
		Looped = true,
		Parent = self.Model
	})

	self.Maid:Add(RunService.PreRender:Connect(function() -- line: 89
		-- upvalues: self (copy), v26 (copy), v25 (copy)
		if os.clock() - self.LastProgressionChange < 0.05 then
			return
		end

		local v68 = v26

		if v68.Playing ~= false then
			v68.Playing = false
		end

		local v69 = v25

		if v69.Playing ~= false then
			v69.Playing = false
		end
	end))
	self.Maid:Add(p5:GetAttributeChangedSignal("Progression"):Connect(function() -- line: 97
		-- upvalues: p5 (copy), self (copy), v25 (copy), v26 (copy)
		local v70 = p5:GetAttribute("Progression") or 1

		if v70 - self.LastProgression > 0 then
			local v71 = v25

			if v71.Playing ~= true then
				v71.Playing = true
			end

			local v72 = v26

			if v72.Playing ~= false then
				v72.Playing = false
			end
		elseif v70 - self.LastProgression < 0 then
			local v73 = v26

			if v73.Playing ~= true then
				v73.Playing = true
			end

			local v74 = v25

			if v74.Playing ~= false then
				v74.Playing = false
			end
		end

		self:ProgressionChanged(v70)
		self.LastProgression = v70
		self.LastProgressionChange = os.clock()
	end))
	self.Maid:Add(p5:GetAttributeChangedSignal("Completed"):Connect(function() -- line: 114
		-- upvalues: p5 (copy), Sounds (copy), self (copy)
		if p5:GetAttribute("Completed") then
			Sounds:Play(self.Sounds.Completed, {
				Parent = self.Model
			})
			self:OnCompleted()

			return
		end

		self:OnUncompleted()
	end))
	self.Maid:Add(v25)
	self.Maid:Add(v26)
	t3.SprayVisuals[p5] = self

	return self
end
function t2.Destroy(t4: {[any]: any}) -- line: 131
	-- upvalues: Sounds (copy)
	if t4.Dead then
		return
	end

	t4.Dead = true

	local Actor = t4:GetActor()

	if Actor and Actor.SprayVisuals then
		Actor.SprayVisuals[t4.Root] = nil
	else
		warn("Failed to remove cached SprayVisual!")
	end

	Sounds:Play(t4.Sounds.Destroyed, {
		Parent = t4.Model
	})
	task.spawn(t4.ToggleBeam, t4, false)
	task.spawn(t4.OnDestroyed, t4)
	t4.Maid:Destroy()
	table.clear(t4)
end
function t2.Create(t5: {[any]: any}, p6) -- line: 156
	local v31 = if not p6 or (not p6.Player or p6.Player.Name ~= "ffPrankster") then if math.random(1, 25000) ~= 1 then p6.Config.VandalismSprayImages else p6.Config.VandalismRareSprayImages else { "rbxassetid://83450503791840" }
	local clone = p6.Config.Instances.VandalismPreset:Clone()

	assert(clone and clone:IsA("BasePart"), "SprayVisual must be a BasePart!")
	clone.ImageBeam.Texture = v31[math.random(#v31)]
	clone.ImageBeam.Width0 = 3
	clone.ImageBeam.Width1 = 3
	clone.ImageBeam.Brightness = 0
	clone.Name = `{ p6.Player.Name }Spray`
	clone.Parent = workspace.Map.Ingame
	clone.CFrame = t5.Root:GetPivot() * CFrame.Angles(0, 3.141592653589793, 0)
	clone.Name = "GraffitiCL"

	return clone
end
function t2.CreateIndicationBeam(t6: {[any]: any}, p7) -- line: 177
	if not p7.Rig or not p7.Rig:FindFirstChild("Torso") then
		warn("[Veeronica/SprayVisual]: Failed to find torso for indication beam!")

		return
	end

	local clone = p7.Config.Instances.VandalismSprayBeam:Clone()

	clone.Enabled = false
	clone.Attachment0 = t6.Model.AttachmentMain
	clone.Attachment1 = p7.Rig.Torso.BodyBackAttachment
	clone.Parent = t6.Model

	return clone
end
function t2.CreateProgressBar(t7: {[any]: any}, _) -- line: 192
	local clone = script.BillboardGui:Clone()

	clone.Parent = t7.Model
	clone.StudsOffset = Vector3.new(0, 0, 0.05000000074505806)

	return clone
end
function t2.CreateRangeIndicator(t8: {[any]: any}, _) -- line: 200
	-- upvalues: ReplicatedStorage (copy)
	local clone = ReplicatedStorage.Assets.Instances.Nothingburger:Clone()

	clone.Size = vector.create(t8.Width, t8.Width, t8.Range)
	clone.Parent = t8.Model
	clone.CFrame = t8.Root:GetPivot() * CFrame.new(0, 0, t8.Range / 2 + 1)
	clone.Transparency = 1
	clone.Name = "SprayRangeIndicator"

	return clone
end
function t2.OnDestroyed(t9: {[any]: any}) -- line: 211
	-- upvalues: TweenService (copy)
	local Model = t9.Model

	if Model then
		local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		local ImageBeam = Model.ImageBeam
		local AttachmentBottom = Model.AttachmentBottom

		TweenService:Create(ImageBeam, tweenInfo, {
			Width0 = 0,
			Width1 = 0,
			Brightness = -0.5
		}):Play()
		TweenService:Create(AttachmentBottom, tweenInfo, {
			Position = Vector3.new(0, -2.5, 0),
			Orientation = Vector3.new(50, 0, 90)
		})

		if t9.RangeIndicator then
			TweenService:Create(t9.RangeIndicator, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
				Transparency = 1
			}):Play()
		end

		t9:ToggleBeam(false)
		game.Debris:AddItem(Model, 2)

		return
	end

	warn("what is happpening")
end
function t2.ToggleInRange(t10: {[any]: any}, b1: boolean) -- line: 242
	t10.RangeIndicator.Color = if not b1 then Color3.new(1, 0, 0) else Color3.new(0, 1, 0)
end
function t2.ToggleBeam(t11: {[any]: any}, b2: boolean) -- line: 246
	if not t11.IndicationBeam then
		return
	end

	t11.IndicationBeam.Enabled = b2
	t11:ToggleBar(b2 and not t11.Completed)
end
function t2.ToggleBar(t12: {[any]: any}, b3: boolean) -- line: 255
	-- upvalues: TweenService (copy)
	if not t12.ProgressBar then
		return
	end

	local tweenInfo = TweenInfo.new(0.35)

	TweenService:Create(t12.ProgressBar.Background, tweenInfo, {
		BackgroundTransparency = not b3 and 1 or 0.35
	}):Play()
	TweenService:Create(t12.ProgressBar.Outline, tweenInfo, {
		BackgroundTransparency = not b3 and 1 or 0.35
	}):Play()
	TweenService:Create(t12.ProgressBar.Background.Bar, tweenInfo, {
		BackgroundTransparency = not b3 and 1 or 0.35
	}):Play()
end
function t2.UpdateBeam(t13: {[any]: any}, b4: boolean) -- line: 267
	if not t13.IndicationBeam then
		return
	end

	t13:GetActor()

	local t14 = {
		IN = Color3.fromRGB(13, 255, 0),
		INBAD = Color3.fromRGB(255, 204, 0),
		OUT = Color3.fromRGB(255, 46, 46)
	}
	local v57 = b4 and (if not t13.Completed then t14.INBAD else t14.IN) or t14.OUT

	t13.IndicationBeam.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, v57),
		ColorSequenceKeypoint.new(1, v57)
	})
end
function t2.ProgressionChanged(t15: {[any]: any}, n1: number) -- line: 285
	-- upvalues: TweenService (copy)
	local Value = TweenService:GetValue(math.clamp(n1 / 100, 0, 1), Enum.EasingStyle.Quad, Enum.EasingDirection.In)
	local Model = t15.Model
	local ImageBeam = Model.ImageBeam
	local _ = Model.AttachmentBottom

	TweenService:Create(ImageBeam, TweenInfo.new(0.08), {
		Brightness = Value / 2 + 0.5,
		Width0 = Value * 2 + 3,
		Width1 = Value * 2 + 3
	}):Play()

	local v64 = if not t15.IsLocal then 0.9 - Value * 0.2 else 0.5 - Value * 0.5

	ImageBeam.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, v64),
		NumberSequenceKeypoint.new(1, v64)
	})

	if t15 and t15.ProgressBar and t15.ProgressBar:FindFirstChild("Background") then
		TweenService:Create(t15.ProgressBar.Background.Bar, TweenInfo.new(0.05), {
			Size = UDim2.fromScale(Value, 1)
		}):Play()
	end
end
function t2.OnCompleted(t16: {[any]: any}) -- line: 315
	-- upvalues: TweenService (copy)
	t16.Completed = true

	if t16.RangeIndicator then
		TweenService:Create(t16.RangeIndicator, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Transparency = 0.8
		}):Play()
	end

	t16:ToggleBar(false)
	t16.Model.ImageBeam.LightEmission = 2
	TweenService:Create(t16.Model.ImageBeam, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		LightEmission = 0
	}):Play()
end
function t2.OnUncompleted(t17: {[any]: any}) -- line: 335
	-- upvalues: TweenService (copy)
	t17.Complete = false
	t17:ToggleBar(true)

	if t17.RangeIndicator then
		TweenService:Create(t17.RangeIndicator, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			Transparency = 1
		}):Play()
	end
end
function t2.GetActor(t18: {[any]: any}) -- line: 348
	-- upvalues: Actors (copy)
	return Actors.CurrentActors[t18.Owner]
end

return t2
]========]}}},
{path=[========[
ServerStorage/Assets/Survivors/Veeronica/Config]========],edits={{[========[
Sk8BumpPower = 11.9]========],[========[
Sk8BumpPower = 12]========]},{[========[
"rbxassetid://108528126969003"]========],[========[
"rbxassetid://108528126969003",
        "rbxassetid://105731225723731",
        "rbxassetid://95163568129634"]========]},{[========[
    Expressions = {]========],[========[
    Instances = {
        SkatePointer = script.Parent.Behavior.SkatePointer,
        Tip = script.Parent.Behavior.Tip,
        SprayButton = script.Parent.Behavior.SprayButton,
        WipeButton = script.Parent.Behavior.WipeButton,
        VandalismPreset = script.Vandalism_PRESET,
        VandalismSprayBeam = script.SprayBeam_PRESET,
        VandalismDestroyedUI = script.SprayDestroyedUI,
        VandalismZoneVisual = script.ZonePole,
        BatteryUITemplate = script.BatteryUI_PRESET,
        Sk8UITemplate = script.SkateUI_PRESET,
        S8EffectsTemplate = script.S8VFX,
    },
    Expressions = {]========]}}},
{path=[========[
ServerStorage/Assets/Survivors/Veeronica/Behavior/SprayVisual]========],edits={{[========[
-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local l_RunService_0 = game:GetService("RunService");
local l_ReplicatedStorage_0 = game:GetService("ReplicatedStorage");
local l_TweenService_0 = game:GetService("TweenService");
local v3 = require(l_ReplicatedStorage_0.Modules.Sounds);
local v4 = require(l_ReplicatedStorage_0.Modules.Util);
local _ = require(l_ReplicatedStorage_0.Modules.Network);
local v6 = require(l_ReplicatedStorage_0.Modules.Actors);
local _ = require(l_ReplicatedStorage_0.Modules.Statuses);
local v8 = require(l_ReplicatedStorage_0.Modules.Misc.Maid);
local v9 = {};
local v10 = {};
v10.__index = v10;
local function _(v11) --[[ Line: 34 ]] --[[ Name: __displayWarn ]]
    warn((("[Veeronica/SprayVisual]: %*"):format(v11)));
end;
local function _(v13, v14, v15) --[[ Line: 38 ]] --[[ Name: __changeProperty ]]
    if v13[v14] ~= v15 then
        v13[v14] = v15;
    end;
end;
v10.getObject = function(v17) --[[ Line: 44 ]] --[[ Name: getObject ]]
    -- upvalues: v9 (copy)
    return v9[v17];
end;
v10.new = function(v18, v19) --[[ Line: 48 ]] --[[ Name: new ]]
    -- upvalues: v10 (copy), v8 (copy), v4 (copy), v3 (copy), l_RunService_0 (copy)
    local v20 = setmetatable({}, v10);
    local v21 = v18.Player == game.Players.LocalPlayer;
    v20.Root = v19;
    v20.Owner = v18.Player;
    v20.IsLocal = v21;
    v20.Maid = v8.new();
    v20.Model = v20:Create(v18);
    v20.Range = v18.Config.VandalismRange;
    v20.Width = v18.Config.VandalismWidth;
    v20.LastProgression = v19:GetAttribute("Progression") or 0;
    v20.LastProgressionChange = 0;
    v20.Sounds = {};
    for _, v23 in ipairs({
        "Progression", 
        "Wiping", 
        "Completed", 
        "Destroyed"
    }) do
        local v24 = v18.Config.Sounds[("Spray%*"):format(v23)];
        if v24 then
            v20.Sounds[v23] = if typeof(v24) == "table" then v4:CopyTable(v24) else v24;
        else
            local v25 = ("Failed to cache sound %*!"):format(v23);
            warn((("[Veeronica/SprayVisual]: %*"):format(v25)));
        end;
    end;
    if v21 then
        v20.IndicationBeam = v20:CreateIndicationBeam(v18);
        v20.ProgressBar = v20:CreateProgressBar(v18);
        v20.RangeIndicator = v20:CreateRangeIndicator(v18);
        v20:ToggleBeam(true);
        v20:ToggleInRange(true);
    end;
    local v26 = v3:Play(v20.Sounds.Progression, {
        Looped = true, 
        Parent = v20.Model
    });
    local v27 = v3:Play(v20.Sounds.Wiping, {
        Looped = true, 
        Parent = v20.Model
    });
    v20.Maid:Add(l_RunService_0.PreRender:Connect(function() --[[ Line: 89 ]]
        -- upvalues: v20 (copy), v27 (copy), v26 (copy)
        if os.clock() - v20.LastProgressionChange < 0.05 then
            return;
        else
            local l_v27_0 = v27;
            if l_v27_0.Playing ~= false then
                l_v27_0.Playing = false;
            end;
            l_v27_0 = v26;
            if l_v27_0.Playing ~= false then
                l_v27_0.Playing = false;
            end;
            return;
        end;
    end));
    v20.Maid:Add(v19:GetAttributeChangedSignal("Progression"):Connect(function() --[[ Line: 95 ]]
        -- upvalues: v19 (copy), v20 (copy), v26 (copy), v27 (copy)
        local v29 = v19:GetAttribute("Progression") or 1;
        if v29 - v20.LastProgression > 0 then
            local l_v26_0 = v26;
            if l_v26_0.Playing ~= true then
                l_v26_0.Playing = true;
            end;
            l_v26_0 = v27;
            if l_v26_0.Playing ~= false then
                l_v26_0.Playing = false;
            end;
        elseif v29 - v20.LastProgression < 0 then
            local l_v27_1 = v27;
            if l_v27_1.Playing ~= true then
                l_v27_1.Playing = true;
            end;
            l_v27_1 = v26;
            if l_v27_1.Playing ~= false then
                l_v27_1.Playing = false;
            end;
        end;
        v20:ProgressionChanged(v29);
        v20.LastProgression = v29;
        v20.LastProgressionChange = os.clock();
    end));
    v20.Maid:Add(v19:GetAttributeChangedSignal("Completed"):Connect(function() --[[ Line: 112 ]]
        -- upvalues: v19 (copy), v3 (ref), v20 (copy)
        if v19:GetAttribute("Completed") then
            v3:Play(v20.Sounds.Completed, {
                Parent = v20.Model
            });
            v20:OnCompleted();
            return;
        else
            v20:OnUncompleted();
            return;
        end;
    end));
    v20.Maid:Add(v26);
    v20.Maid:Add(v27);
    v18.SprayVisuals[v19] = v20;
    return v20;
end;
v10.Destroy = function(v32) --[[ Line: 129 ]] --[[ Name: Destroy ]]
    -- upvalues: v3 (copy)
    if v32.Dead then
        return;
    else
        v32.Dead = true;
        local l_v32_Actor_0 = v32:GetActor();
        if l_v32_Actor_0 and l_v32_Actor_0.SprayVisuals then
            l_v32_Actor_0.SprayVisuals[v32.Root] = nil;
        else
            warn("Failed to remove cached SprayVisual!");
        end;
        v3:Play(v32.Sounds.Destroyed, {
            Parent = v32.Model
        });
        task.spawn(v32.ToggleBeam, v32, false);
        task.spawn(v32.OnDestroyed, v32);
        v32.Maid:Destroy();
        table.clear(v32);
        return;
    end;
end;
v10.Create = function(v34, v35) --[[ Line: 152 ]] --[[ Name: Create ]]
    local v36 = if v35 and v35.Player and v35.Player.Name == "ffPrankster" then {
        "rbxassetid://83450503791840"
    } else if math.random(1, 25000) == 1 then v35.Config.VandalismRareSprayImages else v35.Config.VandalismSprayImages;
    local v37 = v35.Config.VandalismPreset:Clone();
    assert(v37 and v37:IsA("BasePart"), "SprayVisual must be a BasePart!");
    v37.ImageBeam.Texture = v36[math.random(#v36)];
    v37.ImageBeam.Width0 = 3;
    v37.ImageBeam.Width1 = 3;
    v37.ImageBeam.Brightness = 0;
    v37.Name = ("%*Spray"):format(v35.Player.Name);
    v37.Parent = workspace.Map.Ingame;
    v37.CFrame = v34.Root:GetPivot() * CFrame.Angles(0, 3.141592653589793, 0);
    v37.Name = "GraffitiCL";
    return v37;
end;
v10.CreateIndicationBeam = function(v38, v39) --[[ Line: 171 ]] --[[ Name: CreateIndicationBeam ]]
    if not v39.Rig or not v39.Rig:FindFirstChild("Torso") then
        warn("[Veeronica/SprayVisual]: Failed to find torso for indication beam!");
        return;
    else
        local v40 = v39.Config.VandalismSprayBeam:Clone();
        v40.Enabled = false;
        v40.Attachment0 = v38.Model.AttachmentMain;
        v40.Attachment1 = v39.Rig.Torso.BodyBackAttachment;
        v40.Parent = v38.Model;
        return v40;
    end;
end;
v10.CreateProgressBar = function(v41, _) --[[ Line: 186 ]] --[[ Name: CreateProgressBar ]]
    local v43 = script.BillboardGui:Clone();
    v43.Parent = v41.Model;
    v43.StudsOffset = Vector3.new(0, 0, 0.05000000074505806, 0);
    return v43;
end;
v10.CreateRangeIndicator = function(v44, _) --[[ Line: 194 ]] --[[ Name: CreateRangeIndicator ]]
    -- upvalues: l_ReplicatedStorage_0 (copy)
    local v46 = l_ReplicatedStorage_0.Assets.Instances.Nothingburger:Clone();
    v46.Size = vector.create(v44.Width, v44.Width, v44.Range);
    v46.Parent = v44.Model;
    v46.CFrame = v44.Root:GetPivot() * CFrame.new(0, 0, v44.Range / 2 + 1);
    v46.Transparency = 1;
    v46.Name = "SprayRangeIndicator";
    return v46;
end;
v10.OnDestroyed = function(v47) --[[ Line: 206 ]] --[[ Name: OnDestroyed ]]
    -- upvalues: l_TweenService_0 (copy)
    local l_Model_0 = v47.Model;
    if l_Model_0 then
        local v49 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
        local l_ImageBeam_0 = l_Model_0.ImageBeam;
        local l_AttachmentBottom_0 = l_Model_0.AttachmentBottom;
        l_TweenService_0:Create(l_ImageBeam_0, v49, {
            Width0 = 0, 
            Width1 = 0, 
            Brightness = -0.5
        }):Play();
        l_TweenService_0:Create(l_AttachmentBottom_0, v49, {
            Position = Vector3.new(0, -2.5, 0, 0), 
            Orientation = Vector3.new(50, 0, 90, 0)
        });
        if v47.RangeIndicator then
            l_TweenService_0:Create(v47.RangeIndicator, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Transparency = 1
            }):Play();
        end;
        v47:ToggleBeam(false);
        game.Debris:AddItem(l_Model_0, 2);
        return;
    else
        warn("what is happpening");
        return;
    end;
end;
v10.ToggleInRange = function(v52, v53) --[[ Line: 229 ]] --[[ Name: ToggleInRange ]]
    v52.RangeIndicator.Color = if v53 then Color3.new(0, 1, 0) else Color3.new(1, 0, 0);
end;
v10.ToggleBeam = function(v54, v55) --[[ Line: 233 ]] --[[ Name: ToggleBeam ]]
    if not v54.IndicationBeam then
        return;
    else
        v54.IndicationBeam.Enabled = v55;
        v54:ToggleBar(v55 and not v54.Completed);
        return;
    end;
end;
v10.ToggleBar = function(v56, v57) --[[ Line: 240 ]] --[[ Name: ToggleBar ]]
    -- upvalues: l_TweenService_0 (copy)
    if not v56.ProgressBar then
        return;
    else
        local v58 = TweenInfo.new(0.35);
        l_TweenService_0:Create(v56.ProgressBar.Background, v58, {
            BackgroundTransparency = v57 and 0.35 or 1
        }):Play();
        l_TweenService_0:Create(v56.ProgressBar.Outline, v58, {
            BackgroundTransparency = v57 and 0.35 or 1
        }):Play();
        l_TweenService_0:Create(v56.ProgressBar.Background.Bar, v58, {
            BackgroundTransparency = v57 and 0.35 or 1
        }):Play();
        return;
    end;
end;
v10.UpdateBeam = function(v59, v60) --[[ Line: 250 ]] --[[ Name: UpdateBeam ]]
    if not v59.IndicationBeam then
        return;
    else
        local _ = v59:GetActor();
        local v62 = {
            IN = Color3.fromRGB(13, 255, 0), 
            INBAD = Color3.fromRGB(255, 204, 0), 
            OUT = Color3.fromRGB(255, 46, 46)
        };
        local v63 = v60 and (if v59.Completed then v62.IN else v62.INBAD) or v62.OUT;
        v59.IndicationBeam.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, v63), 
            ColorSequenceKeypoint.new(1, v63)
        });
        return;
    end;
end;
v10.ProgressionChanged = function(v64, v65) --[[ Line: 265 ]] --[[ Name: ProgressionChanged ]]
    -- upvalues: l_TweenService_0 (copy)
    local l_l_TweenService_0_Value_0 = l_TweenService_0:GetValue(math.clamp(v65 / 100, 0, 1), Enum.EasingStyle.Quad, Enum.EasingDirection.In);
    local l_Model_1 = v64.Model;
    local l_ImageBeam_1 = l_Model_1.ImageBeam;
    local _ = l_Model_1.AttachmentBottom;
    l_TweenService_0:Create(l_ImageBeam_1, TweenInfo.new(0.08), {
        Brightness = l_l_TweenService_0_Value_0 / 2 + 0.5, 
        Width0 = l_l_TweenService_0_Value_0 * 2 + 3, 
        Width1 = l_l_TweenService_0_Value_0 * 2 + 3
    }):Play();
    local v70 = if v64.IsLocal then 0.5 - l_l_TweenService_0_Value_0 * 0.5 else 0.9 - l_l_TweenService_0_Value_0 * 0.2;
    l_ImageBeam_1.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, v70), 
        NumberSequenceKeypoint.new(1, v70)
    });
    if v64 and v64.ProgressBar and v64.ProgressBar:FindFirstChild("Background") then
        l_TweenService_0:Create(v64.ProgressBar.Background.Bar, TweenInfo.new(0.05), {
            Size = UDim2.fromScale(l_l_TweenService_0_Value_0, 1)
        }):Play();
    end;
end;
v10.OnCompleted = function(v71) --[[ Line: 288 ]] --[[ Name: OnCompleted ]]
    -- upvalues: l_TweenService_0 (copy)
    v71.Completed = true;
    if v71.RangeIndicator then
        l_TweenService_0:Create(v71.RangeIndicator, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Transparency = 0.8
        }):Play();
    end;
    v71:ToggleBar(false);
    v71.Model.ImageBeam.LightEmission = 2;
    l_TweenService_0:Create(v71.Model.ImageBeam, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        LightEmission = 0
    }):Play();
end;
v10.OnUncompleted = function(v72) --[[ Line: 300 ]] --[[ Name: OnUncompleted ]]
    -- upvalues: l_TweenService_0 (copy)
    v72.Complete = false;
    v72:ToggleBar(true);
    if v72.RangeIndicator then
        l_TweenService_0:Create(v72.RangeIndicator, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Transparency = 1
        }):Play();
    end;
end;
v10.GetActor = function(v73) --[[ Line: 309 ]] --[[ Name: GetActor ]]
    -- upvalues: v6 (copy)
    return v6.CurrentActors[v73.Owner];
end;
return v10;]========],[========[
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Sounds = require(ReplicatedStorage.Modules.Sounds)
local Util = require(ReplicatedStorage.Modules.Util)

require(ReplicatedStorage.Modules.Network)

local Actors = require(ReplicatedStorage.Modules.Actors)

require(ReplicatedStorage.Modules.Statuses)

local Maid = require(ReplicatedStorage.Modules.Misc.Maid)
local t1 = {}
local t2 = {}

t2.__index = t2

local function __displayWarn(s1: string) -- line: 34
	warn(`[Veeronica/SprayVisual]: { s1 }`)
end
local function __changeProperty(p1, p2, p3) -- line: 38
	if p3 ~= p1[p2] then
		p1[p2] = p3
	end
end

function t2.getObject(p4) -- line: 44
	-- upvalues: t1 (copy)
	return t1[p4]
end
function t2.new(t3: {[any]: any}, p5) -- line: 48
	-- upvalues: t2 (copy), Maid (copy), Util (copy), Sounds (copy), RunService (copy)
	local self = setmetatable({}, t2)
	local v20 = t3.Player == game.Players.LocalPlayer

	self.Root = p5
	self.Owner = t3.Player
	self.IsLocal = v20
	self.Maid = Maid.new()
	self.Model = self:Create(t3)
	self.Range = t3.Config.VandalismRange
	self.Width = t3.Config.VandalismWidth
	self.LastProgression = p5:GetAttribute("Progression") or 0
	self.LastProgressionChange = 0
	self.Sounds = {}

	for _, v in ipairs({
		"Progression",
		"Wiping",
		"Completed",
		"Destroyed"
	}) do
		local v23 = t3.Config.Sounds[`Spray{ v }`]

		if v23 then
			self.Sounds[v] = if typeof(v23) ~= "table" then v23 else Util:CopyTable(v23)
		else
			local v24 = `Failed to cache sound { v }!`

			warn(`[Veeronica/SprayVisual]: { v24 }`)
		end
	end

	if v20 then
		self.IndicationBeam = self:CreateIndicationBeam(t3)
		self.ProgressBar = self:CreateProgressBar(t3)
		self.RangeIndicator = self:CreateRangeIndicator(t3)
		self:ToggleBeam(true)
		self:ToggleInRange(true)
	end

	local v25 = Sounds:Play(self.Sounds.Progression, {
		Looped = true,
		Parent = self.Model
	})
	local v26 = Sounds:Play(self.Sounds.Wiping, {
		Looped = true,
		Parent = self.Model
	})

	self.Maid:Add(RunService.PreRender:Connect(function() -- line: 89
		-- upvalues: self (copy), v26 (copy), v25 (copy)
		if os.clock() - self.LastProgressionChange < 0.05 then
			return
		end

		local v68 = v26

		if v68.Playing ~= false then
			v68.Playing = false
		end

		local v69 = v25

		if v69.Playing ~= false then
			v69.Playing = false
		end
	end))
	self.Maid:Add(p5:GetAttributeChangedSignal("Progression"):Connect(function() -- line: 97
		-- upvalues: p5 (copy), self (copy), v25 (copy), v26 (copy)
		local v70 = p5:GetAttribute("Progression") or 1

		if v70 - self.LastProgression > 0 then
			local v71 = v25

			if v71.Playing ~= true then
				v71.Playing = true
			end

			local v72 = v26

			if v72.Playing ~= false then
				v72.Playing = false
			end
		elseif v70 - self.LastProgression < 0 then
			local v73 = v26

			if v73.Playing ~= true then
				v73.Playing = true
			end

			local v74 = v25

			if v74.Playing ~= false then
				v74.Playing = false
			end
		end

		self:ProgressionChanged(v70)
		self.LastProgression = v70
		self.LastProgressionChange = os.clock()
	end))
	self.Maid:Add(p5:GetAttributeChangedSignal("Completed"):Connect(function() -- line: 114
		-- upvalues: p5 (copy), Sounds (copy), self (copy)
		if p5:GetAttribute("Completed") then
			Sounds:Play(self.Sounds.Completed, {
				Parent = self.Model
			})
			self:OnCompleted()

			return
		end

		self:OnUncompleted()
	end))
	self.Maid:Add(v25)
	self.Maid:Add(v26)
	t3.SprayVisuals[p5] = self

	return self
end
function t2.Destroy(t4: {[any]: any}) -- line: 131
	-- upvalues: Sounds (copy)
	if t4.Dead then
		return
	end

	t4.Dead = true

	local Actor = t4:GetActor()

	if Actor and Actor.SprayVisuals then
		Actor.SprayVisuals[t4.Root] = nil
	else
		warn("Failed to remove cached SprayVisual!")
	end

	Sounds:Play(t4.Sounds.Destroyed, {
		Parent = t4.Model
	})
	task.spawn(t4.ToggleBeam, t4, false)
	task.spawn(t4.OnDestroyed, t4)
	t4.Maid:Destroy()
	table.clear(t4)
end
function t2.Create(t5: {[any]: any}, p6) -- line: 156
	local v31 = if not p6 or (not p6.Player or p6.Player.Name ~= "ffPrankster") then if math.random(1, 25000) ~= 1 then p6.Config.VandalismSprayImages else p6.Config.VandalismRareSprayImages else { "rbxassetid://83450503791840" }
	local clone = p6.Config.Instances.VandalismPreset:Clone()

	assert(clone and clone:IsA("BasePart"), "SprayVisual must be a BasePart!")
	clone.ImageBeam.Texture = v31[math.random(#v31)]
	clone.ImageBeam.Width0 = 3
	clone.ImageBeam.Width1 = 3
	clone.ImageBeam.Brightness = 0
	clone.Name = `{ p6.Player.Name }Spray`
	clone.Parent = workspace.Map.Ingame
	clone.CFrame = t5.Root:GetPivot() * CFrame.Angles(0, 3.141592653589793, 0)
	clone.Name = "GraffitiCL"

	return clone
end
function t2.CreateIndicationBeam(t6: {[any]: any}, p7) -- line: 177
	if not p7.Rig or not p7.Rig:FindFirstChild("Torso") then
		warn("[Veeronica/SprayVisual]: Failed to find torso for indication beam!")

		return
	end

	local clone = p7.Config.Instances.VandalismSprayBeam:Clone()

	clone.Enabled = false
	clone.Attachment0 = t6.Model.AttachmentMain
	clone.Attachment1 = p7.Rig.Torso.BodyBackAttachment
	clone.Parent = t6.Model

	return clone
end
function t2.CreateProgressBar(t7: {[any]: any}, _) -- line: 192
	local clone = script.BillboardGui:Clone()

	clone.Parent = t7.Model
	clone.StudsOffset = Vector3.new(0, 0, 0.05000000074505806)

	return clone
end
function t2.CreateRangeIndicator(t8: {[any]: any}, _) -- line: 200
	-- upvalues: ReplicatedStorage (copy)
	local clone = ReplicatedStorage.Assets.Instances.Nothingburger:Clone()

	clone.Size = vector.create(t8.Width, t8.Width, t8.Range)
	clone.Parent = t8.Model
	clone.CFrame = t8.Root:GetPivot() * CFrame.new(0, 0, t8.Range / 2 + 1)
	clone.Transparency = 1
	clone.Name = "SprayRangeIndicator"

	return clone
end
function t2.OnDestroyed(t9: {[any]: any}) -- line: 211
	-- upvalues: TweenService (copy)
	local Model = t9.Model

	if Model then
		local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		local ImageBeam = Model.ImageBeam
		local AttachmentBottom = Model.AttachmentBottom

		TweenService:Create(ImageBeam, tweenInfo, {
			Width0 = 0,
			Width1 = 0,
			Brightness = -0.5
		}):Play()
		TweenService:Create(AttachmentBottom, tweenInfo, {
			Position = Vector3.new(0, -2.5, 0),
			Orientation = Vector3.new(50, 0, 90)
		})

		if t9.RangeIndicator then
			TweenService:Create(t9.RangeIndicator, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
				Transparency = 1
			}):Play()
		end

		t9:ToggleBeam(false)
		game.Debris:AddItem(Model, 2)

		return
	end

	warn("what is happpening")
end
function t2.ToggleInRange(t10: {[any]: any}, b1: boolean) -- line: 242
	t10.RangeIndicator.Color = if not b1 then Color3.new(1, 0, 0) else Color3.new(0, 1, 0)
end
function t2.ToggleBeam(t11: {[any]: any}, b2: boolean) -- line: 246
	if not t11.IndicationBeam then
		return
	end

	t11.IndicationBeam.Enabled = b2
	t11:ToggleBar(b2 and not t11.Completed)
end
function t2.ToggleBar(t12: {[any]: any}, b3: boolean) -- line: 255
	-- upvalues: TweenService (copy)
	if not t12.ProgressBar then
		return
	end

	local tweenInfo = TweenInfo.new(0.35)

	TweenService:Create(t12.ProgressBar.Background, tweenInfo, {
		BackgroundTransparency = not b3 and 1 or 0.35
	}):Play()
	TweenService:Create(t12.ProgressBar.Outline, tweenInfo, {
		BackgroundTransparency = not b3 and 1 or 0.35
	}):Play()
	TweenService:Create(t12.ProgressBar.Background.Bar, tweenInfo, {
		BackgroundTransparency = not b3 and 1 or 0.35
	}):Play()
end
function t2.UpdateBeam(t13: {[any]: any}, b4: boolean) -- line: 267
	if not t13.IndicationBeam then
		return
	end

	t13:GetActor()

	local t14 = {
		IN = Color3.fromRGB(13, 255, 0),
		INBAD = Color3.fromRGB(255, 204, 0),
		OUT = Color3.fromRGB(255, 46, 46)
	}
	local v57 = b4 and (if not t13.Completed then t14.INBAD else t14.IN) or t14.OUT

	t13.IndicationBeam.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, v57),
		ColorSequenceKeypoint.new(1, v57)
	})
end
function t2.ProgressionChanged(t15: {[any]: any}, n1: number) -- line: 285
	-- upvalues: TweenService (copy)
	local Value = TweenService:GetValue(math.clamp(n1 / 100, 0, 1), Enum.EasingStyle.Quad, Enum.EasingDirection.In)
	local Model = t15.Model
	local ImageBeam = Model.ImageBeam
	local _ = Model.AttachmentBottom

	TweenService:Create(ImageBeam, TweenInfo.new(0.08), {
		Brightness = Value / 2 + 0.5,
		Width0 = Value * 2 + 3,
		Width1 = Value * 2 + 3
	}):Play()

	local v64 = if not t15.IsLocal then 0.9 - Value * 0.2 else 0.5 - Value * 0.5

	ImageBeam.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, v64),
		NumberSequenceKeypoint.new(1, v64)
	})

	if t15 and t15.ProgressBar and t15.ProgressBar:FindFirstChild("Background") then
		TweenService:Create(t15.ProgressBar.Background.Bar, TweenInfo.new(0.05), {
			Size = UDim2.fromScale(Value, 1)
		}):Play()
	end
end
function t2.OnCompleted(t16: {[any]: any}) -- line: 315
	-- upvalues: TweenService (copy)
	t16.Completed = true

	if t16.RangeIndicator then
		TweenService:Create(t16.RangeIndicator, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Transparency = 0.8
		}):Play()
	end

	t16:ToggleBar(false)
	t16.Model.ImageBeam.LightEmission = 2
	TweenService:Create(t16.Model.ImageBeam, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		LightEmission = 0
	}):Play()
end
function t2.OnUncompleted(t17: {[any]: any}) -- line: 335
	-- upvalues: TweenService (copy)
	t17.Complete = false
	t17:ToggleBar(true)

	if t17.RangeIndicator then
		TweenService:Create(t17.RangeIndicator, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			Transparency = 1
		}):Play()
	end
end
function t2.GetActor(t18: {[any]: any}) -- line: 348
	-- upvalues: Actors (copy)
	return Actors.CurrentActors[t18.Owner]
end

return t2
]========]}}},
{path=[========[
ReplicatedStorage/Modules/Actors]========],edits={{[========[
n8 *= v134]========],[========[
local isSurvivor=p24 and p24.Parent and p24.Parent.Name=="Survivors"
        n8 *= v134 * (isSurvivor and 2 or 1)]========]}}},
{path=[========[
ReplicatedStorage/Modules/StatusEffects/Stunned]========],edits={{[========[
local character=status.Character
 local actor=actorFor(status)]========],[========[
local character=status.Character
 if character.Parent and character.Parent.Name=="Killers"then
  local serial=(character:GetAttribute("FBStunSerial")or 0)+1
  character:SetAttribute("FBStunSerial",serial)
  Util:GiveInvincible(character,"FBStunned")
 end
 local actor=actorFor(status)]========]},{[========[
character:SetAttribute("Stunned",nil)]========],[========[
character:SetAttribute("Stunned",nil)
  if character.Parent and character.Parent.Name=="Killers"then
   local serial=character:GetAttribute("FBStunSerial")
   task.delay(1,function()
    if character.Parent and not character:GetAttribute("Stunned")and character:GetAttribute("FBStunSerial")==serial then Util:RemoveInvincible(character,"FBStunned")end
   end)
  end]========]}}},
{path=[========[
ReplicatedStorage/Modules/StatusEffects/Invisibility]========],edits={{[========[
local t1 = {]========],[========[
local ParticleCloak=require(game.ReplicatedStorage.Modules.ParticleCloak)
local t1 = {]========]},{[========[
		return
	end

	if not game["Run Service"]:IsClient() then]========],[========[
        ParticleCloak.Start(p7)
		return
	end

	if not game["Run Service"]:IsClient() then]========]},{[========[
function t1.Removed(p8) -- line: 95]========],[========[
function t1.Removed(p8) -- line: 95
    ParticleCloak.Stop(p8)]========]}}},
{path=[========[
ReplicatedStorage/Systems/Character/Game/PlayerInfoDisplay]========],edits={{[========[
local t1 = {}]========],[========[
local GameplayPolish=require(game.ReplicatedStorage.Modules.GameplayPolish)
local t1 = {}]========]},{[========[
local Stamina = clone.Bars.Stamina]========],[========[
t1.GameplayPolishCleanup=GameplayPolish.AttachHUD(Character,clone,clone2,script,Sprinting)
	local Stamina = clone.Bars.Stamina]========]},{[========[
function t1.Destroy(_) -- line: 591]========],[========[
function t1.Destroy(_) -- line: 591
    if t1.GameplayPolishCleanup then t1.GameplayPolishCleanup();t1.GameplayPolishCleanup=nil end]========]}}},
{path=[========[
ReplicatedStorage/Systems/Player/UI/Menus/Settings]========],edits={{[========[
local v22 = p2:GetAttribute("DeviceRestriction") or p2.Parent:GetAttribute("DeviceRestriction")]========],[========[
local v22 = p2:GetAttribute("DeviceRestriction") or p2.Parent:GetAttribute("DeviceRestriction")
        if (not v22 or v22=="")and p2.Parent.Name=="Keybinds"then
            v22=p2.Name:match("Console$")and "Console"or "PC"
        end]========]}}},
{path=[========[
ReplicatedStorage/Systems/Player/UI/Menus/Settings/Templates/Keybind]========],edits={{[========[
v8.Instance.KeybindButton.MouseButton1Click:Connect]========],[========[
v8.Instance.KeybindButton.Activated:Connect]========]},{[========[
if table.find(t2, v17) or input.KeyCode == Enum.KeyCode.Unknown and p2:GetAttribute("KeycodeOnly") then]========],[========[
if input.KeyCode==Enum.KeyCode.Escape or input.KeyCode==Enum.KeyCode.ButtonStart then
                    clearCurrentConnection();v8.Instance.KeybindButton.CurrentBind.Title.Text=p2.Value;return
                end
                if table.find(t2, v17) or input.KeyCode == Enum.KeyCode.Unknown and p2:GetAttribute("KeycodeOnly") then]========]},{[========[
if v.IsKeybind and v17 == v.Value and k ~= p2.Name then]========],[========[
if v.IsKeybind and v17 == v.Value and k ~= p2.Name and (k:match("Console$")~=nil)==(p2.Name:match("Console$")~=nil)then]========]}}},
{path=[========[
ReplicatedStorage/Assets/Killers/c00lkidd/Behavior]========],edits={{[========[
l_Position_0 = if v19.Player:GetAttribute("Device") == "Mobile" then v3:GetPlayerMousePosition(v19.Player, true) else v3:GetPlayerMousePosition(v19.Player);]========],[========[
l_Position_0 = v3:GetPlayerMousePosition(v19.Player);]========]}}},
{path=[========[
ServerStorage/Assets/Killers/c00lkidd/Behavior]========],edits={{[========[
l_Position_0 = if v19.Player:GetAttribute("Device") == "Mobile" then v3:GetPlayerMousePosition(v19.Player, true) else v3:GetPlayerMousePosition(v19.Player);]========],[========[
l_Position_0 = v3:GetPlayerMousePosition(v19.Player);]========]}}},
{path=[========[
ReplicatedStorage/Systems/Character/Game/SurvivorRequests]========],edits={{[========[
clone2.MouseButton1Click:Connect]========],[========[
clone2.Activated:Connect]========]}}},
{path=[========[
ReplicatedStorage/Systems/Player/Miscellaneous/GetPlayerMousePosition]========],edits={{[========[
if (SmoothShiftLock.Enabled or v11) and not b1 then]========],[========[
local settings=require(game.ReplicatedStorage.Modules.Util):GetSettingValue("ProjectileShiftlockAiming")
        if settings and (SmoothShiftLock.Enabled or v11) and not b1 then]========]},{[========[
if Device:GetPlayerDevice() == "Mobile" then
			CFramePosition = workspace.CurrentCamera.CFrame.Position
			v25 = workspace.CurrentCamera.CFrame.LookVector * 500]========],[========[
if Device:GetPlayerDevice() == "Console" then
            CFramePosition = workspace.CurrentCamera.CFrame.Position
            v25 = workspace.CurrentCamera.CFrame.LookVector * 500]========]}}},
{path=[========[
ReplicatedStorage/Systems/Player/Miscellaneous/NotificationDisplay]========],edits={{[========[
clone.Parent = p1]========],[========[
if require(game.ReplicatedStorage.Modules.Device):GetPlayerDevice()=="Mobile"then
        clone.Size=UDim2.new(clone.Size.X.Scale*.85,clone.Size.X.Offset,clone.Size.Y.Scale,math.max(18,clone.Size.Y.Offset*.75));clone.TextSize=math.max(12,clone.TextSize*.8)
    end
    clone.Parent = p1]========]},{[========[
Start = function(p5) -- line: 90]========],[========[
Start = function(p5) -- line: 90
    if p5.ClientPolishCleanup then p5.ClientPolishCleanup()end
    p5.ClientPolishCleanup=require(game.ReplicatedStorage.Modules.ClientPolish).Start()]========]}}},
{path=[========[
ReplicatedStorage/Systems/Player/Game/SmoothShiftLock]========],edits={{[========[
p4._runtimeMaid:DoCleaning()]========],[========[
p4.Enabled=false
    UserInputService.MouseBehavior=Enum.MouseBehavior.Default
    Mouse.Icon=""
    if p4.Humanoid and p4.Humanoid.Parent then p4.Humanoid.AutoRotate=true end
    p4._runtimeMaid:DoCleaning()]========]},{[========[
if t4.Enabled then
		t4._shiftlockMaid:GiveTask]========],[========[
if t4.Enabled then
        t4._shiftlockMaid:DoCleaning()
		t4._shiftlockMaid:GiveTask]========]}}},
{path=[========[
ReplicatedStorage/Modules/Misc/CharacterHovering]========],edits={{[========[
	t1.Connections.ClickConnection = game.UserInputService.InputBegan:Connect(function(input, gameProcessed) -- line: 129
		-- upvalues: t1 (copy)
		if gameProcessed then
			return
		end

		local t3 = {
			[Enum.UserInputType.MouseButton1] = true,
			[Enum.UserInputType.Touch] = true,
			[Enum.KeyCode.ButtonA] = true
		}

		if (t3[input.UserInputType] or t3[input.KeyCode]) and t1.HoveredCharacter then
			t1.__clickedEvent:Fire(t1.HoveredCharacter)
		end
	end)
]========],[========[
    local pending={}
    t1.Connections.ClickConnection = game.UserInputService.InputBegan:Connect(function(input,processed)
        if processed or not t1.HoveredCharacter then return end
        if input.KeyCode==Enum.KeyCode.ButtonA then
            if game:GetService("GuiService").SelectedObject then return end
            t1.__clickedEvent:Fire(t1.HoveredCharacter);return
        end
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            pending[input]={target=t1.HoveredCharacter,position=input.Position,at=os.clock(),camera=workspace.CurrentCamera and workspace.CurrentCamera.CFrame}
        end
    end)
    t1.Connections.ClickRelease = game.UserInputService.InputEnded:Connect(function(input,processed)
        local entry=pending[input];pending[input]=nil
        if not entry or processed or os.clock()-entry.at>.6 or(input.Position-entry.position).Magnitude>12 then return end
        local camera=workspace.CurrentCamera
        if camera and entry.camera and camera.CFrame.LookVector:Dot(entry.camera.LookVector)<.999 then return end
        if entry.target.Parent then t1.__clickedEvent:Fire(entry.target)end
    end)
]========]}}},
{path=[========[
ReplicatedStorage/Systems/Character/Game/Emotes]========],edits={{[========[
if table.find(t9, input.KeyCode.Name) or table.find(t9, input.UserInputType.Name) then
			t1:ToggleEmoteMenu()]========],[========[
if table.find(t9, input.KeyCode.Name) or table.find(t9, input.UserInputType.Name) then
            if t1.CurrentEmoteIndex and t1.CurrentEmoteIndex[1]then
                Network:FireServerConnection("StopEmote","REMOTE_EVENT",t1.CurrentEmoteIndex[1],t1.CurrentEmoteIndex[2])
            else t1:ToggleEmoteMenu()end]========]}}},
{path=[========[
ReplicatedStorage/Systems/Character/Game/Emotes/RadialMenu]========],edits={{[========[
if not p7.Enabled then
			return
		end

		if t3[input.UserInputType] then]========],[========[
if not p7.Enabled or not p7:IsVisible()then return end
        local directions={[Enum.KeyCode.DPadRight]=1,[Enum.KeyCode.DPadDown]=1,[Enum.KeyCode.DPadLeft]=-1,[Enum.KeyCode.DPadUp]=-1}
        if directions[input.KeyCode]then
            n1=(n1+directions[input.KeyCode]*TAU/p7.SubN)%TAU
            p7._DPadAngle=n1;return
        end

		if t3[input.UserInputType] then]========]},{[========[
local Theta = p7:GetTheta(MouseMovement)]========],[========[
local Theta = p7._DPadAngle or p7:GetTheta(MouseMovement)]========]},{[========[
v40 = GamepadState[Enum.KeyCode.Thumbstick2].Position * Vector3.new(1, -1, 1)]========],[========[
local stick=GamepadState[Enum.KeyCode.Thumbstick2]
        if not stick or stick.Position.Magnitude<.2 then return end
        v40 = stick.Position * Vector3.new(1, -1, 1)]========]},{[========[
local n1 = 0]========],[========[
local n1 = 0
    p7._Maid:Mark(UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch or(input.KeyCode==Enum.KeyCode.Thumbstick2 and input.Position.Magnitude>=.2)then p7._DPadAngle=nil end
    end))]========]}}},
{path=[========[
ReplicatedStorage/Assets/Survivors/Helperbot/Behavior/Server]========],edits={{[========[
local Server={}]========],[========[
local GameplayPolish=require(game.ReplicatedStorage.Modules.GameplayPolish)
local Server={}]========]},{[========[
hit={},helpers=helpers(a)]========],[========[
hit={},targets=0,helpers=helpers(a)]========]},{[========[
wave.hit[rig]=true;applyPulse(a,rig,wave.level,wave.helpers)]========],[========[
wave.hit[rig]=true;applyPulse(a,rig,wave.level,wave.helpers)
    if rig~=a.Rig and actorFor(rig)then wave.targets+=1 end]========]},{[========[
if wave.elapsed>=1 then table.remove(a.HelperWaves,i) end]========],[========[
if wave.elapsed>=1 then
   local money,xp=GameplayPolish.PulseReward(wave.targets)
   if money>0 then Actors:IncrementActorStats(a.Player,{Action="Pulse hit "..tostring(math.min(wave.targets,3))..(wave.targets>=3 and "+ Survivors"or " Survivor(s)"),Money=money,EXP=xp})end
   table.remove(a.HelperWaves,i)
  end]========]}}}}
local helpers={{name=[========[
GameplayPolish]========],source=[========[
local RunService=game:GetService("RunService")
local Support={}
function Support.CloneLifetime(config,mode)
 return mode=="cursor"and(config.CursorCloneLifetime or config.CloneLifetime*.5)or config.CloneLifetime
end
function Support.PulseReward(hits)
 local tier=math.clamp(math.floor(hits or 0),0,3)
 return tier*2,tier*13
end
function Support.SurvivorXP(amount,isSurvivor)return amount*(isSurvivor and 2 or 1)end
function Support.Remaining(endsAt,now)return type(endsAt)=="number"and math.max(0,endsAt-now)or 0 end
function Support.RecoveryFraction(remaining)return math.clamp(remaining/3,0,1)end
function Support.TeleportReward(actor,oldPosition)
 local close=false
 local players=workspace:FindFirstChild("Players")
 local killers=players and players:FindFirstChild("Killers")
 if killers then
  for _,rig in killers:GetChildren()do
   local hum=rig:FindFirstChildOfClass("Humanoid")
   if hum and hum.Health>0 and rig.PrimaryPart and(rig.PrimaryPart.Position-oldPosition).Magnitude<=30 then close=true;break end
  end
 end
 require(game.ReplicatedStorage.Modules.Actors):IncrementActorStats(actor.Player,{Action=close and "Escaped from a Killer with c00lgui"or "Teleported with c00lgui",Money=3,EXP=30})
end
function Support.CloneTracker(actor,clone,duration)
 local rig=actor.Rig
 local deadline=workspace:GetServerTimeNow()+duration
 rig:SetAttribute("N7CloneEndsAt",deadline)
 local done=false
 local connections={}
 local function clear()
  if done then return end
  done=true
  for _,connection in connections do connection:Disconnect()end
  if rig.Parent and rig:GetAttribute("N7CloneEndsAt")==deadline then rig:SetAttribute("N7CloneEndsAt",nil)end
 end
 local hum=clone:FindFirstChildOfClass("Humanoid")
 if hum then table.insert(connections,hum.Died:Connect(clear))end
 table.insert(connections,clone.Destroying:Connect(clear))
 table.insert(connections,rig.Destroying:Connect(clear))
 task.delay(duration,clear)
end
function Support.AttachHUD(character,ui,center,scriptRoot,sprinting)
 local connections={}
 local owned={center}
 local stamina=ui.Bars.Stamina
 local drain=stamina:FindFirstChild("Drain")
 local centralTemplate=scriptRoot:FindFirstChild("Drain")
 local central=centralTemplate and centralTemplate:Clone()
 if central then central.Name="StaminaRecoveryDrain";central.ZIndex=10000;central.Parent=center.Parent;table.insert(owned,central)end
 local label=Instance.new("TextLabel")
 label.Name="StaminaRecoveryTime";label.BackgroundTransparency=1;label.TextColor3=Color3.fromRGB(255,210,120);label.TextStrokeTransparency=.3
 label.Font=Enum.Font.GothamMedium;label.TextSize=12;label.Size=UDim2.new(1,0,0,16);label.Position=UDim2.new(0,0,1,3);label.Parent=center;table.insert(owned,label)
 local cloneLabel=nil
 local alive=true
 local elapsed=0
 local function cleanup()
  if not alive then return end
  alive=false
  for _,connection in connections do connection:Disconnect()end
  for _,object in owned do object:Destroy()end
  if cloneLabel then cloneLabel:Destroy();cloneLabel=nil end
 end
 table.insert(connections,RunService.RenderStepped:Connect(function(dt)
  if not character.Parent or not ui.Parent then cleanup();return end
  elapsed+=dt;if elapsed<.05 then return end;elapsed=0
  local remaining=math.max(0,sprinting.timeUntilStaminaRecovers or 0)
  local visible=remaining>0 and ui.Visible and sprinting.Stamina<(sprinting.StaminaCap or sprinting.MaxStamina)
  if drain then
   drain.Visible=visible
   local fill=drain:FindFirstChild("Fill")
   if fill then fill.Size=UDim2.fromScale(Support.RecoveryFraction(remaining),1)end
  end
  label.Visible=visible and center.Visible
  label.Text=string.format("Regen %.1fs",remaining)
  if central then
   central.Visible=label.Visible
   central.AnchorPoint=center.AnchorPoint
   central.Position=center.Position+UDim2.fromOffset(0,center.AbsoluteSize.Y*.6)
   central.Size=UDim2.fromOffset(math.max(30,center.AbsoluteSize.X)*Support.RecoveryFraction(remaining),3)
  end
  local deadline=character:GetAttribute("N7CloneEndsAt")
  local left=Support.Remaining(deadline,workspace:GetServerTimeNow())
  local player=game.Players.LocalPlayer
  local temporary=player.PlayerGui:FindFirstChild("TemporaryUI")
  local abilities=temporary and temporary:FindFirstChild("AbilityContainer")
  local button=abilities and abilities:FindFirstChild("Clone")
  if left>0 and button then
   if not cloneLabel or cloneLabel.Parent~=button then
    if cloneLabel then cloneLabel:Destroy()end
    cloneLabel=Instance.new("TextLabel");cloneLabel.Name="CloneDurationTracker";cloneLabel.BackgroundColor3=Color3.new(0,0,0);cloneLabel.BackgroundTransparency=.25
    cloneLabel.TextColor3=Color3.new(1,1,1);cloneLabel.Font=Enum.Font.GothamBold;cloneLabel.TextSize=13
    cloneLabel.AnchorPoint=Vector2.new(.5,1);cloneLabel.Position=UDim2.fromScale(.5,-.05);cloneLabel.Size=UDim2.new(1,0,0,18);cloneLabel.Parent=button
   end
   cloneLabel.Visible=true;cloneLabel.Text=string.format("%.1fs",left)
  elseif cloneLabel then cloneLabel.Visible=false end
 end))
 table.insert(connections,character.Destroying:Connect(cleanup))
 table.insert(connections,ui.Destroying:Connect(cleanup))
 return cleanup
end
return Support
]========]},{name=[========[
ParticleCloak]========],source=[========[
local Cloak={}
function Cloak.Start(effect)
 if effect.ParticleCloak then return end
 local rig=effect.Character
 if not rig then return end
 local records={}
 local connections={}
 local active=true
 local function hide(object)
  if not object:IsA("ParticleEmitter")or records[object]then return end
  local record={Enabled=object.Enabled,Transparency=object.Transparency}
  records[object]=record
  local writing=false
  local function enforce()
   if not active or writing or not object.Parent then return end
   writing=true;object.Enabled=false;object.Transparency=NumberSequence.new(1);writing=false
  end
  table.insert(connections,object:GetPropertyChangedSignal("Enabled"):Connect(function()
   if not writing then record.Enabled=object.Enabled;enforce()end
  end))
  table.insert(connections,object:GetPropertyChangedSignal("Transparency"):Connect(function()
   if not writing then record.Transparency=object.Transparency;enforce()end
  end))
  enforce()
  object:Clear()
 end
 for _,object in rig:GetDescendants()do hide(object)end
 table.insert(connections,rig.DescendantAdded:Connect(hide))
 local function stop()
  if not active then return end
  active=false
  for _,connection in connections do connection:Disconnect()end
  for object,record in records do
   if object.Parent then object.Enabled=record.Enabled;object.Transparency=record.Transparency end
  end
  effect.ParticleCloak=nil
 end
 table.insert(connections,rig.Destroying:Connect(stop))
 effect.ParticleCloak=stop
end
function Cloak.Stop(effect)if effect.ParticleCloak then effect.ParticleCloak()end end
return Cloak
]========]},{name=[========[
ClientPolish]========],source=[========[
local RunService=game:GetService("RunService")
local Client={}
local activeCleanup=nil
local starting=false
local function noop()end
function Client.Start()
 if not RunService:IsClient()then return noop end
 if activeCleanup then return activeCleanup end
 if starting then return noop end
 local Players=game:GetService("Players")
 local UIS=game:GetService("UserInputService")
 local GuiService=game:GetService("GuiService")
 local player=Players.LocalPlayer
 if not player then return noop end
 starting=true
 local playerGui=player:WaitForChild("PlayerGui")
 local connections={}
 local guarded=setmetatable({},{__mode="k"})
 local restoreCamera=nil
 local function release()
  if restoreCamera then restoreCamera();restoreCamera=nil end
 end
 local function guard(object)
  if object:IsA("ScrollingFrame")then object.Active=true;object.ScrollingEnabled=true end
  if not object:IsA("ViewportFrame")or guarded[object]then return end
  guarded[object]=true
  object.Active=true
  local connection=object.InputBegan:Connect(function(input)
   if input.UserInputType~=Enum.UserInputType.Touch and input.UserInputType~=Enum.UserInputType.MouseButton1 then return end
   release()
   local camera=workspace.CurrentCamera
   if not camera then return end
   local original=camera.CameraType
   camera.CameraType=Enum.CameraType.Scriptable
   local ending,destroying
   local done=false
   restoreCamera=function()
    if done then return end;done=true
    if ending then ending:Disconnect()end;if destroying then destroying:Disconnect()end
    if workspace.CurrentCamera==camera and camera.CameraType==Enum.CameraType.Scriptable then camera.CameraType=original end
   end
   ending=UIS.InputEnded:Connect(function(ended)
    if ended==input or ended.UserInputType==Enum.UserInputType.MouseButton1 then release()end
   end)
   destroying=object.Destroying:Connect(release)
  end)
  table.insert(connections,connection)
 end
 for _,object in playerGui:GetDescendants()do guard(object)end
 table.insert(connections,playerGui.DescendantAdded:Connect(guard))
 table.insert(connections,GuiService:GetPropertyChangedSignal("SelectedObject"):Connect(function()
  local selected=GuiService.SelectedObject
  if not selected or not selected:IsA("GuiObject")then return end
  local scrolling=selected:FindFirstAncestorWhichIsA("ScrollingFrame")
  if not scrolling then return end
  local offset=selected.AbsolutePosition.Y-scrolling.AbsolutePosition.Y
  local bottom=offset+selected.AbsoluteSize.Y
  local height=scrolling.AbsoluteWindowSize.Y
  local change=offset<0 and offset or(bottom>height and bottom-height or 0)
  if change~=0 then scrolling.CanvasPosition=Vector2.new(scrolling.CanvasPosition.X,math.clamp(scrolling.CanvasPosition.Y+change,0,math.max(0,scrolling.AbsoluteCanvasSize.Y-height)))end
 end))
 local menus={Shop=true,Inventory=true,Settings=true,Stats=true,UpdateLog=true,Rules=true,Achievements=true}
 local function inMenu(object)
  local menu=false
  while object and object~=playerGui do
   if object:IsA("GuiObject")and not object.Visible then return false end
   if object:IsA("ScreenGui")and not object.Enabled then return false end
   if menus[object.Name]then menu=true end
   object=object.Parent
  end
  return menu
 end
 pcall(function()GuiService.AutoSelectGuiEnabled=true;GuiService.GuiNavigationEnabled=true end)
 table.insert(connections,UIS.InputBegan:Connect(function(input,processed)
  if processed or UIS:GetFocusedTextBox()then return end
  local key=input.KeyCode
  if key~=Enum.KeyCode.DPadUp and key~=Enum.KeyCode.DPadDown and key~=Enum.KeyCode.DPadLeft and key~=Enum.KeyCode.DPadRight then return end
  if GuiService.SelectedObject and inMenu(GuiService.SelectedObject)then return end
  for _,object in playerGui:GetDescendants()do
   if object:IsA("GuiButton")and object.Active and object.Visible and inMenu(object)then
    object.Selectable=true;GuiService.SelectedObject=object;break
   end
  end
 end))
 table.insert(connections,UIS.WindowFocusReleased:Connect(release))
 table.insert(connections,player.CharacterRemoving:Connect(release))
 local alive=true
 activeCleanup=function()
  if not alive then return end
  alive=false
  activeCleanup=nil
  release()
  for _,connection in connections do connection:Disconnect()end
 end
 starting=false
 return activeCleanup
end
function Client.Destroy()
 if activeCleanup then activeCleanup()end
end
return Client
]========]}}
local function find(path)
 local object=game
 for name in path:gmatch("[^/]+")do object=object:FindFirstChild(name);assert(object,"Missing "..path)end
 return object
end
local modules=game.ReplicatedStorage.Modules
for _,helper in helpers do
 helper.existing=modules:FindFirstChild(helper.name)
 assert(not helper.existing or(helper.existing:IsA("ModuleScript")and helper.existing.Source==helper.source),"Different "..helper.name.." helper exists. Nothing changed.")
end
local planned={}
for _,change in changes do
 change.object=find(change.path);change.before=change.object.Source
 local source=change.before
 for _,edit in change.edits do
  if not source:find(edit[2],1,true)then
   local first,last=source:find(edit[1],1,true)
   assert(first and not source:find(edit[1],last+1,true),"Unsupported or ambiguous Source: "..change.path..". Nothing changed; send its current Source.")
   source=source:sub(1,first-1)..edit[2]..source:sub(last+1)
  end
 end
 change.after=source
 if source~=change.before then table.insert(planned,change)end
end
local display=find("ReplicatedStorage/Systems/Character/Game/PlayerInfoDisplay")
local installed=display:GetAttribute("FBGameplayHUD2026")
local pack=workspace:FindFirstChild("GameplayHUDUPD")or game.ReplicatedStorage:FindFirstChild("GameplayHUDUPD")
local templates={"PlayerInfo","CenterStaminaCounter","SurvivorFrame","Drain"}
if not installed then
 assert(pack,"Import GameplayHUDUPD.rbxm into Workspace first. Nothing changed.")
 for _,name in templates do assert(pack:FindFirstChild(name)and pack[name]:IsA("GuiObject"),"HUD import is missing "..name..". Nothing changed.")end
end
local settings=find("ServerScriptService/Server/Systems/Data/PlayerData/Template/Settings/Game")
local setting=settings:FindFirstChild("ProjectileShiftlockAiming")
assert(not setting or setting:IsA("BoolValue"),"ProjectileShiftlockAiming must be a BoolValue. Nothing changed.")
local allHelpers=true
for _,helper in helpers do allHelpers=allHelpers and helper.existing~=nil end
if #planned==0 and installed and setting and allHelpers then print("n7, Vee and global/client updates already installed.");return end
local backup=Instance.new("Folder");backup.Name="N7VeeGlobalBackup_"..os.time()
for i,change in planned do
 local saved=Instance.new("StringValue");saved.Name=tostring(i);saved.Value=change.before;saved.Parent=backup
 local target=Instance.new("ObjectValue");target.Name="Target";target.Value=change.object;target.Parent=saved
end
local assetBackup=Instance.new("Folder");assetBackup.Name="Assets";assetBackup.Parent=backup
local additions=Instance.new("Folder");additions.Name="Additions";additions.Parent=backup
local priorAttribute=Instance.new("BoolValue");priorAttribute.Name="HadHUD";priorAttribute.Value=installed==true;priorAttribute.Parent=backup
backup.Parent=game.ServerStorage
local created={}
local moved={}
local function mark(object)
 table.insert(created,object)
 local target=Instance.new("ObjectValue");target.Name=tostring(#created);target.Value=object;target.Parent=additions
end
local ok,err=pcall(function()
 for _,helper in helpers do
  if not helper.existing then local module=Instance.new("ModuleScript");mark(module);module.Name=helper.name;module.Source=helper.source;module.Parent=modules end
 end
 if not installed then
  for _,name in templates do
   local original=display:FindFirstChild(name)
   if original then table.insert(moved,{object=original,parent=display});original.Parent=assetBackup end
   local fresh=pack[name]:Clone();mark(fresh);fresh.Name=name;fresh.Parent=display
  end
  display:SetAttribute("FBGameplayHUD2026",true)
 end
 if not setting then
  local value=Instance.new("BoolValue");mark(value);value.Name="ProjectileShiftlockAiming";value.Value=false
  value:SetAttribute("DisplayTitle","Use Shiftlock for Projectile Aiming")
  value:SetAttribute("DisplayDescription","Use the camera reticle while shiftlocked instead of cursor aiming.")
  value:SetAttribute("LayoutOrder",90);value.Parent=settings
 end
 for _,change in planned do change.object.Source=change.after end
end)
if not ok then
 for _,change in planned do pcall(function()change.object.Source=change.before end)end
 for _,object in created do object:Destroy()end
 for _,item in moved do item.object.Parent=item.parent end
 display:SetAttribute("FBGameplayHUD2026",installed)
 error("Update failed; originals restored: "..tostring(err))
end
print("n7, Vee, UPD HUD, survivor XP x2 and global/client updates installed. Exhausted remains 5%. Save and restart Play. Backup: "..backup:GetFullName())
