-- Azure optional-animation repair for the already-installed FCT port. Stop playtesting.
local RunService=game:GetService("RunService")
assert(RunService:IsStudio() and not RunService:IsRunning(),"Stop the playtest before applying Azure's port.")
local function fingerprint(source)
 local a,b=5381,0
 for i=1,#source do local byte=string.byte(source,i);a=(a*33+byte)%4294967296;b=(b*65599+byte)%4294967296 end
 return string.format("%d:%08x:%08x",#source,a,b)
end
local plans={
{path=[========[
ReplicatedStorage/Assets/Killers/Azure/Behavior]========],before="165439:fb880f31:a80e010c",previous="165307:78413e99:1bdaceaa",after="164061:3c4ac9dd:c4d70668",source=[========[





local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local Players = game:GetService("Players");
local Debris = game:GetService("Debris");
game:GetService("Lighting");
game:GetService("UserInputService");
local Sounds = require(ReplicatedStorage.Modules.Sounds);
local Actors = require(ReplicatedStorage.Modules.Actors);
local Ragdolls = require(ReplicatedStorage.Modules.Ragdolls);
local Lighting = require(ReplicatedStorage.Modules.Schematics.Lighting);
local Util = require(ReplicatedStorage.Modules.Util);
local Sprinting = require(ReplicatedStorage.Systems.Character.Game.Sprinting);
local Hitboxes = require(ReplicatedStorage.Modules.Hitboxes);
local Maid = require(ReplicatedStorage.Modules.Misc.Maid);
local Statuses = require(ReplicatedStorage.Modules.Statuses);
local Network = require(ReplicatedStorage.Modules.Network);
require(ReplicatedStorage.Modules.AchievementUtil);
local Device = require(ReplicatedStorage.Modules.Device);
local Projectiles = require(ReplicatedStorage.Modules.Projectiles);
local sv_AzureConstruct = require(script.sv_AzureConstruct);
local sv_Golem = require(script.sv_Golem);
local resolveAzureGrabConfig = require(script.GrabConfigDefaults);
local AnimationSupport = require(script.OptionalAnimations);
local spawn = task.spawn;
local delay = task.delay;
local u1 = RunService:IsClient();
local u2 = RunService:IsServer();
local u3 = RunService:IsStudio();
TweenInfo.new(1);
Random.new();
TweenInfo.new(0.2);
local u4;

if u1 then
	u4 = Players.LocalPlayer;
else
	u4 = u1;
end;

local u5 = {
	DivotSize = 3,
	DivotSizeDeviance = 0.25,
	DivotDepth = 0,
	WidthDeviance = 0.12,
	Tweens = true,
	AwayRotation = -45,
	AwayRotationDeviance = 1,
	RandomRotation = 25,
	TimeInterval = 0.01,
	TweenConfig = TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
};

local function changeProp(p6, p7, p8)            
	if p8 ~= p6[p7] then
		p6[p7] = p8;
	end;
end;

local function reconcile(p9, p10)            
	for i, v in pairs(p10) do
		if p9[i] == nil then
			p9[i] = v;
		end;
	end;

	return p9;
end;

local function cWait(p11, p12, ...)            

	local v13 = os.clock();

	while os.clock() - v13 < p11 do
		if p12(...) then
			return true;
		end;

		RunService.PostSimulation:Wait();
	end;

	return p12(...) and true or false;
end;

local function checkForPathInDict(p14, p15)            
	local v16 = string.split(p15, "/");

	for i = 1, #v16 do
		if not p14[v16[i]] then
			return false;
		end;

		p14 = p14[v16[i]];
	end;

	return true;
end;

local function flattenVector(p17)            
	return Vector3.new(p17.X, 0, p17.Z);
end;

local function sv_reward(p18, p19, p20)             

	Actors:IncrementActorStats(p18.Player, {
		Action = p20,
		RewardType = p19 .. "KillerAction"
	});
end;

local function flRandom(p21, p22)             
	return p21 + Random.new():NextNumber() * (p22 - p21);
end;

local function __displayWarn(p23)             
end;

local function __getStunValidator(u24)             

	return function()             

		return (not Util:IsAlive(u24.Rig) or u24.Rig:GetAttribute("Stunned")) and true or false;
	end;
end;

local u25 = {};

local function freezeStamina(u26, p27)             

	local u28 = os.clock();
	u25[u26] = u28;
	Sprinting:SetStaminaFrozen(u26, true);
	task.delay(p27, function()             

		if u25[u26] ~= u28 then
			return;
		end;

		u25[u26] = nil;
		Sprinting:SetStaminaFrozen(u26, false);
	end);
end;

local function beamProjectile(p29, p30, p31, p32)             
	local v33 = p32 ^ 2;
	local v34 = p30 * p32;
	local v35 = 0.5 * p29 * v33 + v34 + p31;
	local v36 = v35 - (p29 * v33 + v34) / 3;
	local v37 = (0.125 * p29 * v33 + 0.5 * v34 + p31 - 0.125 * (p31 + v35)) / 0.375 - v36;
	local magnitude = (v37 - p31).magnitude;
	local magnitude2 = (v36 - v35).magnitude;
	local unit = (p31 - v35).unit;
	local unit2 = (v37 - p31).unit;
	local unit3 = unit2:Cross(unit).unit;
	local unit4 = (v36 - v35).unit;
	local unit5 = unit4:Cross(unit).unit;
	local unit6 = unit3:Cross(unit2).unit;
	local v38 = CFrame.new(p31.x, p31.y, p31.z, unit2.x, unit3.x, unit6.x, unit2.y, unit3.y, unit6.y, unit2.z, unit3.z, unit6.z);
	local v39 = CFrame.new(v35.x, v35.y, v35.z, unit4.x, unit5.x, unit6.x, unit4.y, unit5.y, unit6.y, unit4.z, unit5.z, unit6.z);

	return magnitude, -magnitude2, v38, v39;
end;

local function getTrajectoryPoints(p40, p41, p42, p43)             

	local v44 = p42;
	local v45 = {};

	for i = 0.05, 5, 0.05 do
		local v46 = p40 * 0.5 * i ^ 2 + p41 * i + p42;
		local v47 = vector.create(v46.x, v46.y, v46.z);
		local v48 = v47 - v44;
		local v49 = workspace:Raycast(v44, v48, p43);

		if v49 then
			local v50 = i - 0.05 + (v49.Position - v44).Magnitude / v48.Magnitude * 0.05;
			table.insert(v45, v49.Position);

			return v45, beamProjectile(p40, p41, p42, v50);
		end;

		table.insert(v45, v47);
		v44 = v47;
	end;

	return v45, beamProjectile(p40, p41, p42, 5);
end;

local clientDrawnConstructs = {};

local function __pcallMethod(u51, u52, ...)             
	local success, result = pcall(function(...)             

		if u52.Behavior[u51] then
			return u52.Behavior[u51](u52.Behavior, u52, ...);
		end;
	end, ...);

	if success then
		return result;
	end;

	warn((`[Azure]: Failed to call .{u51}() due to: {result}, {debug.traceback()}`));
end;

local function __playSound(p53, p54, p55)             

	local v56 = Util:CopyTable(p55 or {
		Volume = 0.35,
		PlaybackSpeed = 0.975 + Random.new():NextNumber() * 0.04999999999999993
	});

	if not (p55 and (p55.Parent or p55.Position)) then
		v56.Parent = p53.Rig.PrimaryPart;
	end;

	return Sounds:Play(p53.Config.Sounds[p54], v56);
end;

local u57 = {
	GroundBulb = 3,
	Vine = 3
};

local function getConstructLimit(p58, p59)             

	local v60 = p58.Config.ConstructLimits or (p58.Config.MaxConstructs or p58.Config.TrapLimits);

	if v60 then
		v60 = v60[p59];
	end;

	if typeof(v60) == "number" then
		return v60;
	end;

	local v61 = p58.Config.ConstructConfigs and p58.Config.ConstructConfigs[p59];

	if v61 then
		v61 = v61.Limit or (v61.MaxAmount or v61.MaxCount);
	end;

	return typeof(v61) ~= "number" and (u57[p59] or 3) or v61;
end;

local function __cullConstruct(p62, p63, p64)             
	local v65 = {};

	for _, v in pairs(p62.State.Constructs) do
		if p63 == v.Type then
			table.insert(v65, v);
		end;
	end;

	if p64 <= #v65 then
		table.sort(v65, function(p66, p67)             
			return (p66.CreationIndex or 0) < (p67.CreationIndex or 0);
		end);
		v65[1]:Destroy();
	end;

	table.clear(v65);
end;

local function hasActiveGolem(p68)             
	local v69 = p68.State and p68.State.Golems and next(p68.State.Golems) ~= nil;

	return v69;
end;

local u77 = {
	getTentacles = function(p70, p71)                                 
		return p71.Rig:FindFirstChild("AZURETENTACLESRIG"):FindFirstChild("Tentacles");
	end,

	getGrabbingTentacle = function(p72, p73, p74)                                        
		return p74:FindFirstChild("Top.R");
	end,

	OnStunnedAbsolute = function(p75, p76)                                      

		if p76 and (p76.State and p76.State.ControllingGolem) then
			Statuses:ApplyStatus(p76.Rig, "Slowness", {
				Level = 2,
				Duration = 2.5,
				AppliedFrom = "Azure"
			});
			Statuses:ApplyStatus(p76.Rig, "Helpless", {
				Level = 1,
				Duration = 2.5,
				AppliedFrom = "Azure"
			});
		end;
	end
};

if u2 then
	function u77.sv_IsNearPlantSpawn(_, actor, position)
		local radius = actor.Config.PlantSpawnExclusionRadius or 20

		for _, part in workspace:GetDescendants() do
			if not part:IsA("BasePart") then continue end
			local isSpawn = part:IsA("SpawnLocation")
			local ancestor = part.Parent
			while not isSpawn and ancestor and ancestor ~= workspace do
				isSpawn = ancestor.Name == "SpawnPoints" or ancestor.Name == "BotSpawns"
				ancestor = ancestor.Parent
			end
			if isSpawn and (part.Position - position).Magnitude <= radius then
				return true
			end
		end
		return false
	end;

	function u77.sv_GetBlockingConstruct(p78, p79, p80)             
		local PlacementRadius = p79.Config.PlacementRadius;
		local PlacementYFactor = p79.Config.PlacementYFactor;

		for _, v in pairs(p79.State.Constructs) do
			local v81 = v.Root and v.Root.Position;

			if v81 and ((v81 - p80) * Vector3.new(1, PlacementYFactor, 1)).Magnitude <= PlacementRadius then
				return v;
			end;
		end;

		return nil;
	end;

	function u77.sv_AddOblationProgress(p82, p83, p84)             

		if p83.State and (p83.State.Golems and next(p83.State.Golems) ~= nil) then
			return;
		end;

		local v85 = math.max(0, tonumber(p84) or 0);
		local v86 = p83.State.OblationProgress + v85;
		local v87 = math.floor(v86 / 100);

		if p83.State.Oblation >= p83.Config.Oblation.Max and v87 > 0 then
			p83.State.OblationProgress = 99;

			return;
		end;

		if v87 > 0 then
			__pcallMethod("sv_IncreaseOblation", p83, v87);
		end;

		p83.State.OblationProgress = v86 % 100;
	end;

	function u77.sv_IncreaseOblation(p88, p89, p90)             
		if p89.State and (p89.State.Golems and next(p89.State.Golems) ~= nil) then
			return;
		end;

		p89.State.Oblation = math.clamp(p89.State.Oblation + (p90 or 1), 0, p89.Config.Oblation.Max);
		p89.Rig:SetAttribute("Oblation", p89.State.Oblation);
	end;

	function u77.sv_DecreaseOblation(p91, p92, p93)             
		p92.State.Oblation = math.clamp(p92.State.Oblation - (p93 or 1), 0, p92.Config.Oblation.Max);
		p92.Rig:SetAttribute("Oblation", p92.State.Oblation);
	end;

	function u77.sv_CreateConstruct(p94, u95, p96, p97)             

		local v98 = Util:CopyTable(p97 or {});
		v98.Meta = Util:CopyTable(u95.Config.ConstructConfigs[p96]);
		local u99 = sv_AzureConstruct.new(p96, u95, v98);
		u95.State.ConstructCreationIndex = (u95.State.ConstructCreationIndex or 0) + 1;
		u99.CreationIndex = u95.State.ConstructCreationIndex;
		local UUID = u99.UUID;
		local u100 = Util:CopyTable(p97 or {});
		u100.UUID = u99.UUID;
		u100.Type = p96;
		u100.Root = u99.Root;
		u95:PCallAllClients("CreateConstruct", u100);
		u99:AddCallback("PostNetwork", function(p101, ...)             

			u95:PCallAllClients("ConstructEvent", u100, p101, ...);
		end, "FireAllClients");
		u95.State.Constructs[UUID] = u99;
		u99:AddCallback("OnDestroyed", function()             

			u95:PCallAllClients("DestroyConstruct", u100);
			u95.State.Constructs[UUID] = nil;
		end, "RemoveFromActor");
		u99.Prompt.Triggered:Connect(function(u102)             

			local Character = u102.Character;
			local v103 = not Util:IsAlive(Character) and "You\'re dead." or ((tostring(Character.Parent) ~= "Survivors" and not workspace:GetAttribute("FriendlyFire")) and "You\'re no survivor." or (Character:GetAttribute("AzureQTEActive") and "You\'re busy." or (vector.magnitude(Character.PrimaryPart.Position - u99.Root.Position) > 10 and "Move closer." or (u99.QTEActive and "Someone\'s already working on this." or ((Character.PrimaryPart.Anchored or checkForPathInDict(u99 or {}, "newConstruct/Callbacks/ServerQTEEnd/QTEEndedServer")) and "You can\'t do that right now." or (not u99.QTEEnabled and "It\'s angry." or (not u99:HasLOS(Character) and "You can\'t see it." or nil)))))));

			if v103 then
				Network:FireClientConnection(u102, `{u95.Player.Name}AzureQTEWarning`, "REMOTE_EVENT", v103);

				return;
			end;

			u99.QTETokenIndex = (u99.QTETokenIndex or 0) + 1;
			local QTETokenIndex = u99.QTETokenIndex;
			local u104 = Character:FindFirstChildOfClass("Humanoid");
			local u105 = Maid.new();
			local Health = u104.Health;
			u99:ToggleQTEEnabled("BeingWorkedOn", false);
			Character:SetAttribute("AzureQTEActive", true);
			u99:StartQTE(u102);
			Network:FireClientConnection(u102, `{u95.Player.Name}AzureBeginQTE`, "REMOTE_EVENT", u99.Root);
			u105:Add(Character.AncestryChanged:Connect(function()             

				u99:EndQTE();
			end));
			u105:Add(u104.HealthChanged:Connect(function()             

				if Health > u104.Health then
					u99:EndQTE();
				end;

				Health = u104.Health;
			end));
			u105:Add(Character.PrimaryPart:GetPropertyChangedSignal("Position"):Connect(function()             

				if vector.magnitude(Character.PrimaryPart.Position - u99.Root.Position) > 7.5 then
					u99:EndQTE();
				end;
			end));
			u99:AddCallback("ServerQTEEnd", function()             

				u99:ToggleQTEEnabled("BeingWorkedOn", true);
				Character:SetAttribute("AzureQTEActive", nil);

				if u102 then
					Network:FireClientConnection(u102, `{u95.Player.Name}AzureForceQTEStop`, "REMOTE_EVENT", u99.Root, QTETokenIndex);
				end;

				u105:Destroy();
				u99:RemoveCallback("ServerQTEEnd", "QTEEndedServer");
			end, "QTEEndedServer");
		end);
		u95.Maid:Add(u99);

		return u99;
	end;

	function u77.sv_OnMeleeHit(p106, p107, p108)             
		for _, v in pairs(p107.State.Constructs) do
			if v.Type == "Vine" and p108 == v.AttachedCharacter then
				v:FireConnection("Release", p108);
			end;
		end;
	end;

	function u77.sv_CreateGolemRig(p109, p110, p111)             
		local v112 = p110.Config.Instances.Golem:Clone();

		for _, descendant in ipairs(v112:GetDescendants()) do
			if descendant:IsA("BasePart") then
				descendant.CanCollide = false;
				descendant.Massless = true;
				descendant.RootPriority = -10;
			end;
		end;

		v112:PivotTo(p110:GetPivot());
		v112.Parent = p110.Rig;
		v112.PrimaryPart.RootJoint.Part0 = p110.Rig.PrimaryPart;
		v112.PrimaryPart.RootJoint.Parent = p110.Rig.PrimaryPart;
		v112.PrimaryPart:Destroy();

		return v112;
	end;

	function u77.sv_ToggleAzureVisible(p113, p114, p115)             
		if p115 then
			for _, descendant in ipairs(p114.Rig:GetDescendants()) do
				if (descendant:IsA("BasePart") or descendant:IsA("Decal")) and descendant:GetAttribute("OGTransparency") then
					descendant.Transparency = descendant:GetAttribute("OGTransparency");
				elseif (descendant:IsA("ParticleEmitter") or (descendant:IsA("Beam") or (descendant:IsA("Trail") or descendant:IsA("BillboardGui")))) and descendant:GetAttribute("OGEnabled") then
					descendant.Enabled = descendant:GetAttribute("OGEnabled");
				end;
			end;

			return;
		end;

		for _, descendant in ipairs(p114.Rig:GetDescendants()) do
			if descendant:IsA("BasePart") or descendant:IsA("Decal") then
				descendant:SetAttribute("OGTransparency", descendant.Transparency);
				descendant.Transparency = 1;
			elseif descendant:IsA("ParticleEmitter") or (descendant:IsA("Beam") or (descendant:IsA("Trail") or descendant:IsA("BillboardGui"))) then
				descendant:SetAttribute("OGEnabled", descendant.Enabled);
				descendant.Enabled = false;
			end;
		end;
	end;

	function u77.sv_CreateAzureStatue(p116, p117, p118)             

		local v119 = p117.Config.Instances.KillerFlower:Clone();
		v119:PivotTo(p118);
		v119.Parent = workspace.Map;
		p117:PCallAllClients("AnimateAzureStatue", v119, false);
		local v120 = p117.Rig:Clone();

		for _, descendant in ipairs(v120:GetDescendants()) do
			if descendant:IsA("BasePart") then
				descendant.Massless = true;
				descendant.CanCollide = false;
				descendant.CanQuery = false;
			end;
		end;

		v120.PrimaryPart.Anchored = true;
		v120.Parent = workspace.Map;
		local v121 = AnimationSupport.Load(Util, v120, p117.Config.Animations.GolemStateEnter, false, "GolemStateEnter");
		local u122 = AnimationSupport.Load(Util, v120, p117.Config.Animations.GolemStateIdle, false, "GolemStateIdle");
		v121.Stopped:Once(function()             

			u122:Play();
		end);
		p117.State.FakeAzureStatue = v120;
		v121:Play();

		return v119;
	end;

	function u77.sv_CreateGolemStatue(p123, p124, p125)             
		local v126 = p125:Clone();

		for _, descendant in ipairs(v126:GetDescendants()) do
			if descendant:IsA("BasePart") then
				descendant.Anchored = true;
				descendant.CanCollide = false;
				descendant.CanQuery = false;
				descendant.Material = Enum.Material.Slate;
				descendant.Color = Color3.new(0.2, 0.2, 0.2);
			elseif descendant:IsA("Decal") or (descendant:IsA("SurfaceAppearance") or descendant:IsA("JointInstance")) then
				descendant:Destroy();
			end;
		end;

		p124.Config.Instances.GolemStatue.SurfaceAppearance:Clone().Parent = v126["Cube.001"];
		v126.Parent = workspace.Map.Ingame;

		return v126;
	end;

	function u77.sv_DestroyAzureStatue(p127, u128, p129)             

		Debris:AddItem(p129, 1);
		u128:PCallAllClients("AnimateAzureStatue", p129, true);
		u128.Rig:PivotTo(u128.State.FakeAzureStatue:GetPivot());
		u128.State.FakeAzureStatue:Destroy();
		u128.State.FakeAzureStatue = nil;
		local rig = u128.Rig
		local root = rig.PrimaryPart
		local humanoid = rig:FindFirstChildOfClass("Humanoid")
		if not root or not humanoid then return end
		local key = "AzureReturn_" .. tostring(os.clock())
		local finished, track, stopped, died = false, nil, nil, nil
		local function release()
			if finished then return end
			finished = true
			if stopped then stopped:Disconnect() end
			if died then died:Disconnect() end
			if track then track:Stop(0.1); track:Destroy() end

			Util:RemoveStackableProperty(root, "Anchored", key)
			if root.Parent and not root.Anchored then
				local ok, err = pcall(function()
					if u128.Player and u128.Player.Parent == game:GetService("Players") then
						root:SetNetworkOwner(u128.Player)
					else
						root:SetNetworkOwnershipAuto()
					end
				end)
				if not ok then warn("[Azure return] Physics handoff: " .. tostring(err)) end
			end
		end
		Util:GiveStackableProperty(root, "Anchored", key)

		task.delay(5, release)
		died = humanoid.Died:Connect(release)
		local animator = humanoid:FindFirstChildOfClass("Animator")
		if not animator then release(); return end
		local ok, err = pcall(function()
			track = AnimationSupport.Load(Util, rig, u128.Config.Animations.GolemStateExit, false, "GolemStateExit")
			track.Looped = false
			stopped = track.Stopped:Connect(release)
			track:Play(0, 1, 1.5)
		end)
		if not ok then
			release()
			warn("[Azure return] Exit animation failed: " .. tostring(err))
		end
	end;

	function u77.sv_DestroyGolemStatue(p131, p132, p133)             
		p133:Destroy();
	end;

	local function sv_getGolemTransferCooldown(p134)             
		return p134.Config.Golem.TransferCooldown or (p134.Config.GolemTransferCooldown or 3);
	end;

	local u135 = nil;

	local function sv_clearGolemSpawnLock(p136, p137)             
		if p137 and p137 ~= p136.Cache.GolemSpawnLockToken then
			return;
		end;

		if not p136.State.GolemSpawnLocked then
			return;
		end;

		p136.State.GolemSpawnLocked = nil;
		p136.Cache.GolemSpawnLockToken = nil;
		p136.AbilitiesDisabled = false;
		p136.DisabledAbilities = nil;
		p136:PCallLocal("SetGolemSpawnAbilityLocks", false);
	end;

	local function sv_startGolemSpawnLock(u138, u139, p140, u141)             

		if p140 <= 0 then
			if u141 and u135 then
				u135(u138, u139);
			end;

			return;
		end;

		local u142 = os.clock();
		u138.State.GolemSpawnLocked = true;
		u138.Cache.GolemSpawnLockToken = u142;
		u138:PCallLocal("SetGolemSpawnAbilityLocks", true);
		u138.AbilitiesDisabled = true;
		u138.DisabledAbilities = {
			Slash = true,
			Sow = true,
			Blossom = true,
			Grab = true,
			Unravel = true
		};
		task.delay(p140, function()             

			if not u138.State or u138.State.ControllingGolem ~= u139 then
				return;
			end;

			local v143 = u138;
			local v144 = u142;

			if (not v144 or v144 == v143.Cache.GolemSpawnLockToken) and v143.State.GolemSpawnLocked then
				v143.State.GolemSpawnLocked = nil;
				v143.Cache.GolemSpawnLockToken = nil;
				v143.AbilitiesDisabled = false;
				v143.DisabledAbilities = nil;
				v143:PCallLocal("SetGolemSpawnAbilityLocks", false);
			end;

			if u141 and (u138.State and (u138.State.ControllingGolem == u139 and u135)) then
				u135(u138, u139);
			end;
		end);
	end;

	local function sv_updateGolemLifetimeDisplay(p145, p146)             
		if p146 and (p146.UUID and p146.RemainingLifetime) then
			p145:PCallLocal("UpdateGolemLifetime", p146.UUID, p146.RemainingLifetime);
		end;
	end;

	local function sv_pauseGolemLifetime(p147, p148)             
		if not p148 then
			return;
		end;

		if p148.LifetimeStartedAt then
			local v149 = os.clock() - p148.LifetimeStartedAt;
			p148.RemainingLifetime = math.max((p148.RemainingLifetime or 0) - v149, 0);
			p148.LifetimeStartedAt = nil;
		end;

		p148.LifetimeToken = (p148.LifetimeToken or 0) + 1;

		if p148 and (p148.UUID and p148.RemainingLifetime) then
			p147:PCallLocal("UpdateGolemLifetime", p148.UUID, p148.RemainingLifetime);
		end;
	end;

	u135 = function(u150, u151)                        
		if not u151 then
			return false;
		end;

		local v152 = u151.RemainingLifetime or u151.Lifetime;

		if not v152 or v152 <= 0 then
			u151:Destroy();

			return false;
		end;

		u151.RemainingLifetime = v152;
		u151.LifetimeStartedAt = os.clock();
		u151.LifetimeToken = (u151.LifetimeToken or 0) + 1;
		local LifetimeToken = u151.LifetimeToken;

		if u151 and (u151.UUID and u151.RemainingLifetime) then
			u150:PCallLocal("UpdateGolemLifetime", u151.UUID, u151.RemainingLifetime);
		end;

		task.delay(v152, function()             

			if u151.LifetimeToken ~= LifetimeToken then
				return;
			end;

			if u150.State and (u150.State.Golems and (u150.State.Golems[u151.UUID] == u151 and u151.BeingControlled)) then
				u151.RemainingLifetime = 0;
				u151:Destroy();
			end;
		end);

		return true;
	end;

	function u77.sv_ControlGolem(p153, p154, p155, p156)             

		if p154.State.ControllingGolem then
			return;
		end;

		local v157 = p156 == "Newborn" and true or p156 == "EmpoweredNewborn";
		local v158 = p154.Config.GolemSpawn.Windup or 0;
		local v159;

		if v157 then
			v159 = v158 > 0;
		else
			v159 = v157;
		end;

		if v159 then
			local v160 = p155.RemainingLifetime or p155.Lifetime;

			if not v160 or v160 <= 0 then
				p155:Destroy();

				return;
			end;

			p155.RemainingLifetime = v160;
			p155.LifetimeStartedAt = nil;
			p155.LifetimeToken = (p155.LifetimeToken or 0) + 1;

			if p155 and (p155.UUID and p155.RemainingLifetime) then
				p154:PCallLocal("UpdateGolemLifetime", p155.UUID, p155.RemainingLifetime);
			end;
		elseif not u135(p154, p155) then
			return;
		end;

		if p155.Statue then
			__pcallMethod("sv_DestroyGolemStatue", p154, p155.Statue);
			p155.Statue = nil;
		end;



		Util:GiveInvincible(p154.Rig, "AzureInflorescence_" .. tostring(os.clock()), 5);
		p155.BeingControlled = true;
		Util:GiveStackableAttribute(p154.Rig, "StunnedDisabled", "Golem");
		p154.Config.StatusData = {
			TotalTimeMult = 0.75,
			ExcludeIfAppliedFrom = "Azure"
		};
		local v161 = p154.Rig.PrimaryPart.CFrame * CFrame.new(0, -p154.Rig.PrimaryPart.Size.Y / 2 * 3, 0);
		local v162 = __pcallMethod("sv_CreateAzureStatue", p154, v161);
		p154.State.GolemReturnDummy = {
			Rig = v162,
			CFrame = p154.Rig.PrimaryPart.CFrame
		};

		if v162 then
			p154.Maid:Add(v162);
		end;

		__playSound(p154, "GolemAzureLeave", {
			Position = v161.Position
		});
		local v163 = Util:CopyTable({
			Volume = 0.35,
			PlaybackSpeed = 0.975 + Random.new():NextNumber() * 0.04999999999999993
		});
		v163.Parent = p154.Rig.PrimaryPart;
		Sounds:Play(p154.Config.Sounds.GolemControlled, v163);
		p154.Maid:Add(v162);
		__pcallMethod("sv_ToggleAzureVisible", p154, false);
		local CFrame2 = p154.Rig.PrimaryPart.CFrame;
		p154:PivotTo(p155.CFrame);
		local Empowered = p155.Empowered;
		local v164 = __pcallMethod("sv_CreateGolemRig", p154, p156 == "EmpoweredNewborn");

		if v164 then
			p154.Maid:Add(v164);
		end;

		if Empowered then
			local v165 = Util:CopyTable({
				Volume = 0.35,
				PlaybackSpeed = 0.975 + Random.new():NextNumber() * 0.04999999999999993
			});
			v165.Parent = p154.Rig.PrimaryPart;
			Sounds:Play(p154.Config.Sounds.GolemEnragedSpawn, v165);
			local v166 = __playSound(p154, "GolemEnragedIdle", {
				Looped = true
			});
			game.Debris:AddItem(v166, p154.Config.Golem.EnragedLifetime);
		end;

		p154.State.CurrentGolemRig = v164;
		p154.State.ControllingGolem = p155;
		p154.Rig:SetAttribute("FootstepOverride", "GolemFootsteps");
		Util:CreateSpeedMultiplier(p154.Player, 0, "AzureGolemControl", p156 == "Control" and 0 or p154.Config.GolemSpawn.Windup, true);
		Util:CreateSpeedMultiplier(p154.Player, p154.Config.Golem.WalkspeedMultiplier, "GolemDefaultWalkspeed");
		Util:SetSpeedCap(p154.Rig, "GolemSpeedy", p154.Config.Golem.WalkspeedMultiplier * p154.Config.SprintSpeed + 5);
		local v167 = {
			Slash = p154.Config.Smash.Cooldown,
			Sow = p154.Config.GolemShockwave.Cooldown,
			Blossom = p154.Config.GolemFissure.Cooldown
		};
		p154.Cache.BaseCooldownTicks = {};
		p154.Cache.GolemTimeFlag = os.clock();

		for _, v in ipairs({ "Slash", "Sow", "Blossom" }) do
			p154.Cache.BaseCooldownTicks[v] = p154:IsOnCooldown(v);
			local v168 = p155.Cooldowns[v] or 0;
			local v169 = os.clock() - v168;
			p154:SetCooldownOf(v, (math.max(0, (v167[v] or 3) - v169)));
		end;

		p154:PCallLocal("ControlGolem", p155.UUID, p155.Empowered, p155.RemainingLifetime, not v159, CFrame2);

		if v157 then
			sv_startGolemSpawnLock(p154, p155, v158, v159);
			p154:PlayVoiceline("CreateGolem", {
				Priority = 2
			});
		else
			p154:SetCooldownOf("Unravel", p154.Config.Golem.TransferCooldown or (p154.Config.GolemTransferCooldown or 3));
		end;

		for _, v in pairs(p154.State.RootDistances) do
			v.Origin = p154.Rig.PrimaryPart.Position + Vector3.new(0, -p154.Rig.PrimaryPart.Size.Y / 2 * 3, 0);
		end;
	end;

	function u77.sv_ReleaseGolem(p170, p171, p172)             

		if not p171.State.ControllingGolem or p172 ~= p171.State.ControllingGolem then
			return;
		end;

		p171.Config.StatusData = nil;
		Util:RemoveStackableAttribute(p171.Rig, "StunnedDisabled", "Golem");
		Util:GiveInvincible(p171.Rig, "GolemSwitch_" .. tostring(os.clock()), p171.Config.Golem.InvulnOnSwitch);
		local GolemReturnDummy = p171.State.GolemReturnDummy;

		if not GolemReturnDummy then
			return;
		end;

		p172.CFrame = p171:GetPivot();
		p172.BeingControlled = false;

		if p172 then
			if p172.LifetimeStartedAt then
				local v173 = os.clock() - p172.LifetimeStartedAt;
				p172.RemainingLifetime = math.max((p172.RemainingLifetime or 0) - v173, 0);
				p172.LifetimeStartedAt = nil;
			end;

			p172.LifetimeToken = (p172.LifetimeToken or 0) + 1;

			if p172 and (p172.UUID and p172.RemainingLifetime) then
				p171:PCallLocal("UpdateGolemLifetime", p172.UUID, p172.RemainingLifetime);
			end;
		end;

		Util:SetSpeedCap(p171.Rig, "GolemSpeedy", 223, 0);
		__playSound(p171, "GolemReleased", {
			Position = p172.CFrame.Position
		});
		p171:PlayVoiceline("ReleaseGolem", {
			Priority = 2
		});
		local v174 = __pcallMethod("sv_CreateGolemStatue", p171, p171.State.CurrentGolemRig);
		p171.State.CurrentGolemRig:Destroy();
		p171.State.CurrentGolemRig = nil;
		p172.Statue = v174;
		local CFrame2 = p171.Rig.PrimaryPart.CFrame;
		__pcallMethod("sv_DestroyAzureStatue", p171, GolemReturnDummy.Rig);
		p171.State.GolemReturnDummy = nil;
		p171.State.ControllingGolem = nil;
		p171.Rig:SetAttribute("FootstepOverride", nil);
		Util:CreateSpeedMultiplier(p171.Player, 1, "AzureGolemControl", 0);
		Util:CreateSpeedMultiplier(p171.Player, 1, "GolemDefaultWalkspeed", 0);

		for _, v in ipairs({ "Slash", "Sow", "Blossom" }) do
			local v175 = (p171.Cache.BaseCooldownTicks[v] or 0) - (os.clock() - p171.Cache.GolemTimeFlag);
			p171:SetCooldownOf(v, (math.max(v175, 0)));
			p171.Cache.BaseCooldownTicks[v] = p171:IsOnCooldown(v);
		end;

		p171.Cache.BaseCooldownTicks = nil;
		p171.Cache.GolemTimeFlag = nil;
		p171:PCallLocal("ReleaseGolem", p172.UUID, v174, p172.CFrame, p172.RemainingLifetime, CFrame2);

		if p171.State.GolemSpawnLocked then
			p171.State.GolemSpawnLocked = nil;
			p171.Cache.GolemSpawnLockToken = nil;
			p171.AbilitiesDisabled = false;
			p171.DisabledAbilities = nil;
			p171:PCallLocal("SetGolemSpawnAbilityLocks", false);
		end;

		p171:SetCooldownOf("Unravel", p171.Config.Golem.TransferCooldown or (p171.Config.GolemTransferCooldown or 3));
		__pcallMethod("sv_ToggleAzureVisible", p171, true);
		local v176 = Util:CopyTable({
			Volume = 0.35,
			PlaybackSpeed = 0.975 + Random.new():NextNumber() * 0.04999999999999993
		});
		v176.Parent = p171.Rig.PrimaryPart;
		Sounds:Play(p171.Config.Sounds.GolemAzureReturn, v176);

		for _, v in pairs(p171.State.RootDistances) do
			v.Origin = p171:GetPivot().Position;
		end;
	end;


	function u77.sv_GrabSurvivor(_, actor, victim)
		if actor.State.GrabbingFlag then return end
		local rig, grab = actor.Rig, resolveAzureGrabConfig(actor)
		local function alive(model)
			return model and model:IsDescendantOf(workspace) and model.PrimaryPart
				and model:FindFirstChildOfClass("Humanoid") and Util:IsAlive(model)
		end
		if not alive(rig) or not alive(victim) then
			u77:sv_MissGrab(actor)
			return
		end
		local root, humanoid = rig.PrimaryPart, rig:FindFirstChildOfClass("Humanoid")
		local victimRoot, victimHumanoid = victim.PrimaryPart, victim:FindFirstChildOfClass("Humanoid")
		local victimActor = Util:GetActor(victim)
		local tracks, connections, objects, physics = {}, {}, {}, {}
		local phase, cleaned, detached = "pull", false, false
		local ragdolled = false
		local oldAnchored, oldAutoRotate = root.Anchored, humanoid.AutoRotate
		local oldPlatformStand = victimHumanoid.PlatformStand
		local invincibleKey = "AzureGrab_" .. tostring(os.clock())
		local freeze, victimSpeed, attachment
		local frozen = false
		local invincibleUntil
		local function safe(fn)
			local ok, err = pcall(fn)
			if not ok then warn("[Azure Enstrangle] cleanup: " .. tostring(err)) end
		end
		local function valid()
			return not cleaned and not actor.Destroyed and alive(rig) and alive(victim)
				and rig.PrimaryPart == root and victim.PrimaryPart == victimRoot
				and (phase == "flight" or not rig:GetAttribute("Stunned"))
		end
		local function speedLock(model, name)
			assert(valid(), "Grab cancelled before applying movement lock")
			local folder = model:FindFirstChild("SpeedMultipliers")
			if not folder then
				folder = Instance.new("Folder")
				folder.Name = "SpeedMultipliers"
				folder.Parent = model
			end
			local previous = folder:FindFirstChild(name)
			if previous then previous:Destroy() end
			local value = Instance.new("NumberValue")
			value.Name = name
			value.Value = 0
			value.Parent = folder
			return value
		end
		local function own(object)
			table.insert(objects, object)
			return object
		end
		local function unfreeze()
			if not frozen then return end
			frozen = false
			if freeze then freeze:Destroy(); freeze = nil end
			if root.Parent then
				root.Anchored = oldAnchored
				root.AssemblyLinearVelocity = Vector3.zero
				root.AssemblyAngularVelocity = Vector3.zero


				if not oldAnchored then
					safe(function()
						if actor.Player and actor.Player.Parent == game:GetService("Players") then
							root:SetNetworkOwner(actor.Player)
						else
							root:SetNetworkOwnershipAuto()
						end
					end)
				end
			end
			if humanoid.Parent then humanoid.AutoRotate = oldAutoRotate end
		end
		local function detach()
			if detached then return end
			detached = true
			for _, object in objects do safe(function() object:Destroy() end) end
			for part, props in physics do
				if part.Parent then
					part.Massless = props.Massless
					part.CanCollide = props.CanCollide
				end
			end
			for name, track in tracks do
				if name ~= "GrabThrow" and name ~= "GrabVictimThrow" then
					safe(function() track:Stop(0.05) end)
				end
			end
		end
		local function cleanup()
			if cleaned then return end
			cleaned = true
			for _, connection in connections do connection:Disconnect() end
			safe(detach)
			safe(unfreeze)
			for _, track in tracks do
				safe(function() track:Stop(0); track:Destroy() end)
			end
			if phase ~= "impact" or not invincibleUntil or os.clock() >= invincibleUntil then
				safe(function() Util:RemoveInvincible(rig, invincibleKey) end)
			end
			if victimSpeed then safe(function() victimSpeed:Destroy() end) end
			safe(function() Util:RemoveStackableAttribute(victim, "Airborne", "AzureGrab") end)
			safe(function()
				victim:SetAttribute("AzureGrabbed", nil)
				victim:SetAttribute("IgnoreNoclip", nil)
				if victimHumanoid.Parent and not ragdolled then victimHumanoid.PlatformStand = oldPlatformStand end
				if victimRoot.Parent and not victimRoot.Anchored then victimRoot:SetNetworkOwnershipAuto() end
			end)
			if victimActor then safe(function() victimActor:DisableAbilities("AzureGrabbing", false) end) end
			safe(function() rig:SetAttribute("MoveAnimationOverwrite", nil) end)
			actor.State.GrabbingFlag = nil
			actor.State.ThrowRequest = nil
			actor.State.AzureGrabCleanup = nil
			actor.AbilitiesDisabled = false
			actor.DisabledAbilities = {}
			safe(function() actor:PCallLocal("SetGrabAbilityLocks", false) end)
			safe(function() actor:PCallLocal("SetGrabStaminaRegenReduction", false) end)
			safe(function() actor:PCallLocal("SetGrabSprintDisabled", false) end)
			safe(function() Network:FireClientConnection(actor.Player, "SetTrackingMousePosition", "REMOTE_EVENT", Vector3.new(0, 0, -1)) end)
			safe(function() actor:PCallAllClients("OnHomingStopped") end)
			safe(function() actor:PCallLocal("OnHomingStopped") end)
			safe(function() actor:PCallAllClients("OnThrowEnded", victim) end)
			safe(function() actor:PCallLocal("ResetGrabVisuals") end)
			if ragdolled and phase ~= "impact" and alive(victim) then
				safe(function() Ragdolls.DisableRagdoll(victim) end)
			end
		end
		actor.State.GrabbingFlag = true
		actor.State.ThrowRequest = nil                                                 
		actor.State.AzureGrabCleanup = cleanup

		for _, model in {rig, victim} do
			table.insert(connections, model.Destroying:Connect(cleanup))
			table.insert(connections, model.AncestryChanged:Connect(function()
				if not model:IsDescendantOf(workspace) then cleanup() end
			end))
			local hum = model:FindFirstChildOfClass("Humanoid")
			table.insert(connections, hum.Died:Connect(cleanup))
		end

		local function load(name, model)
			assert(valid(), "Grab cancelled before loading animation")
			local track = AnimationSupport.Load(Util, model, actor.Config.Animations[name], false, name)
			track.Looped = name:match("Idle$") ~= nil or name:match("Walk$") ~= nil
				or name:match("Run$") ~= nil or name == "GrabPullingLoop" or name == "GrabVictimHooked"
			track.Priority = Enum.AnimationPriority.Action
			tracks[name] = track
			return track
		end
		local function waitTrack(track, maxTime, update, marker)
			local began, stopped, reached = os.clock(), false, false
			local stoppedConnection = track.Stopped:Connect(function() stopped = true end)
			table.insert(connections, stoppedConnection)
			local markerConnection
			if marker then
				markerConnection = track:GetMarkerReachedSignal(marker):Connect(function() reached = true end)
				table.insert(connections, markerConnection)
			end
			track:Play(0.025)
			while valid() do
				local elapsed = os.clock() - began
				if update then update(elapsed) end

				local deadline = track.Length > 0 and math.min(track.Length + 0.25, maxTime) or maxTime
				if reached or stopped or elapsed >= deadline then break end
				task.wait()
			end
			stoppedConnection:Disconnect()
			if markerConnection then markerConnection:Disconnect() end
			return valid()
		end
		local function applyImpact(result, velocity, releasedAt)
			if not valid() then return end
			local position, normal = result.Position, result.Normal


			local hitboxFolder = workspace:FindFirstChild("Hitboxes")
			if hitboxFolder then
				local display = Instance.new("Part")
				display.Name = tostring(actor.Player) .. "Hitbox"
				display.Shape = Enum.PartType.Ball
				display.Size = Vector3.new(1, 1, 1) * grab.BlastRadius * 2
				display.CFrame = CFrame.new(position)
				display.Color = Color3.new(0.5, 1, 0.5)
				display.Transparency = 1
				display.Anchored = true
				display.CanCollide = false
				display.CanTouch = false
				display.CanQuery = false
				display.CastShadow = false
				display.Parent = hitboxFolder
				Debris:AddItem(display, 0.36)
			end
			phase = "impact"
			local close = (position - root.Position).Magnitude <= (grab.CloseThrowDistance or 20)
			if close then
				local helpless = Statuses:ApplyStatus(rig, "Helpless", {
					Level = 1, Duration = grab.CloseThrowHelpless or 4
				})

				if helpless then helpless.TimeRequired = grab.CloseThrowHelpless or 4 end
				local slowness = Statuses:ApplyStatus(rig, "Slowness", {Level = 2, Duration = 2})
				if slowness then slowness.TimeRequired = 2 end
			end
			victim:SetAttribute("AzureGrabbed", nil)

			victim:SetAttribute("AzureThrowLandedUntil", os.clock() + (grab.PlantTriggerDuration or 1.5))
			local bounce = (velocity - 2 * velocity:Dot(normal) * normal) / 4
			victim:PivotTo(CFrame.new(position + normal * 2))
			Ragdolls.AddProfile(victim, {Velocity = bounce})
			Ragdolls.EnableRagdoll(victim, grab.RagdollDuration)
			victimRoot.AssemblyLinearVelocity = bounce
			__playSound(actor, "GrabImpact", {RollOffMaxDistance = 300, Position = position})
			actor:PCallAllClients("OnGroundExplode", position, result.Instance)
			local effect = actor.Config.Instances.SlamVFX:Clone()
			effect.Parent = workspace.Terrain
			effect.CFrame = CFrame.new(position, position + normal) * CFrame.Angles(math.pi / 2, 0, 0)
			Debris:AddItem(effect, 4)
			Util:EmitParticles(effect)

			local healthBefore = victimHumanoid.Health + (victimHumanoid:GetAttribute("Overheal") or 0)
			Util:ApplyDamage(victim, grab.Damage)
			local healthAfter = victimHumanoid.Health + (victimHumanoid:GetAttribute("Overheal") or 0)
			if healthBefore > healthAfter then
				__pcallMethod("sv_AddOblationProgress", actor, (healthBefore - healthAfter) * actor.Config.Oblation.BuildPerDamage)
			end
			Actors:IncrementActorStats(actor.Player, {Action = "Threw Survivor", RewardType = "EasyKillerAction"})
			local nearby = workspace.Players.Survivors:GetChildren()
			if workspace:GetAttribute("FriendlyFire") then
				for _, other in workspace.Players.Killers:GetChildren() do table.insert(nearby, other) end
			end
			for _, other in nearby do
				if other == victim or other == rig or not alive(other) then continue end
				local delta = other.PrimaryPart.Position - position
				if delta.Magnitude > grab.BlastRadius then continue end
				local horizontal = Vector3.new(delta.X, 0, delta.Z)
				local direction = horizontal.Magnitude > 0.001 and horizontal.Unit or Vector3.zero
				local knockback = (direction + Vector3.new(0, 0.6, 0)) * grab.KnockbackPower
				other.PrimaryPart.AssemblyLinearVelocity = knockback
				Ragdolls.AddProfile(other, {Velocity = knockback})
				Ragdolls.EnableRagdoll(other, grab.RagdollDuration)
				Actors:IncrementActorStats(actor.Player, {
					Action = tostring(other.Parent) == "Killers" and "Threw Survivor into Killer" or "Threw Survivor into Survivor",
					RewardType = "EasyKillerAction"
				})
			end
		end
		local ok, err = xpcall(function()
			__pcallMethod("sv_OnMeleeHit", actor, victim)
			if not valid() then return end
			actor.AbilitiesDisabled = false
			actor.DisabledAbilities = {Slash = true, Sow = true, Blossom = true, Unravel = true}
			actor:PCallLocal("SetGrabAbilityLocks", true, true)
			actor:PCallLocal("SetGrabStaminaRegenReduction", true)
			actor:PCallLocal("SetGrabSprintDisabled", true)
			victimSpeed = speedLock(victim, "AzureGrab")
			Util:GiveStackableAttribute(victim, "Airborne", "AzureGrab")
			victim:SetAttribute("AzureGrabbed", true)
			victim:SetAttribute("IgnoreNoclip", true)
			victimHumanoid.PlatformStand = true
			if victimActor then victimActor:DisableAbilities("AzureGrabbing", true) end
			for _, part in victim:GetDescendants() do
				if part:IsA("BasePart") then
					physics[part] = {Massless = part.Massless, CanCollide = part.CanCollide}
					part.Massless = true
					part.CanCollide = false
				end
			end
			if not victimRoot.Anchored then victimRoot:SetNetworkOwner(nil) end
			attachment = own(Instance.new("Attachment", root))
			local victimAttachment = own(Instance.new("Attachment", victimRoot))
			local align = own(Instance.new("AlignPosition", victimRoot))
			align.Attachment0, align.Attachment1 = victimAttachment, attachment
			align.Responsiveness, align.RigidityEnabled = 200, true
			local orientation = own(Instance.new("AlignOrientation", victimRoot))
			orientation.Attachment0, orientation.Attachment1 = victimAttachment, attachment
			orientation.Responsiveness, orientation.RigidityEnabled = 200, true
			local initial = victimRoot.Position
			local reelDirection = root.CFrame.LookVector
			local victimRotation = victimRoot.CFrame.Rotation
			local offset = CFrame.new(0, 0, -3)
			attachment.CFrame = root.CFrame:ToObjectSpace(CFrame.new(initial))
			local function pull(elapsed)
				local targetPosition = root.Position + reelDirection * 3
				local alpha = TweenService:GetValue(math.clamp(elapsed / grab.PullTime, 0, 1), Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut)
				local position = initial:Lerp(targetPosition, alpha)
				attachment.CFrame = root.CFrame:ToObjectSpace(CFrame.new(position) * victimRotation)
			end
			__playSound(actor, "Grabbed", {Parent = victimRoot})
			Sounds:Play(actor.Config.Sounds.Grab, {Parent = root, Volume = 0.35})
			actor:PlayVoiceline("GrabHit", {Priority = 2})
			load("GrabVictimHooked", victim):Play(0.025)
			load("GrabPullingLoop", rig):Play(0.025)
			local pullStart = os.clock()
			while valid() and os.clock() - pullStart < grab.PullTime do
				pull(os.clock() - pullStart)
				task.wait()
			end
			if not valid() then return end
			attachment.CFrame = offset
			tracks.GrabVictimHooked:Stop(0.05)
			tracks.GrabPullingLoop:Stop(0.05)
			phase = "success"
			actor:PCallLocal("SetGrabSprintDisabled", true)
			frozen = true
			freeze = speedLock(rig, "AzureGrabSuccess")
			root.AssemblyLinearVelocity = Vector3.zero
			root.AssemblyAngularVelocity = Vector3.zero
			root.Anchored = true
			humanoid.AutoRotate = false
			Util:GiveInvincible(rig, invincibleKey)
			local success = load("GrabShootSuccess", rig)
			load("GrabVictimSuccess", victim):Play(0.025)
			if not waitTrack(success, grab.SuccessAnimationTimeout or 8) then return end
			tracks.GrabShootSuccess:Stop(0.05)
			tracks.GrabVictimSuccess:Stop(0.05)
			unfreeze()
			invincibleUntil = os.clock() + 0.5
			task.delay(0.5, function() safe(function() Util:RemoveInvincible(rig, invincibleKey) end) end)
			phase = "hold"
			actor.DisabledAbilities = {Sow = true, Blossom = true, Unravel = true}
			actor:PCallLocal("SetGrabAbilityLocks", true, false)
			actor:PCallLocal("SetGrabSprintDisabled", false)
			actor:SetCooldownOf("Slash", 0)
			actor:SetCooldownOf("Grab", 0)
			rig:SetAttribute("MoveAnimationOverwrite", "Grab")
			for _, name in {"GrabIdle", "GrabWalk", "GrabRun"} do load(name, rig) end
			for _, name in {"GrabVictimIdle", "GrabVictimWalk", "GrabVictimRun"} do load(name, victim) end
			Network:FireClientConnection(actor.Player, "SetTrackingMousePosition", "REMOTE_EVENT")
			actor:PCallAllClients("OnHomingStart")
			actor:PCallLocal("OnHomingStart")
			actor.State.ThrowRequest = false
			local holdStart, movement = os.clock(), nil
			while valid() and actor.State.ThrowRequest == false and os.clock() - holdStart < grab.HoldMaxDuration do
				local speed = root.AssemblyLinearVelocity.Magnitude
				local nextMovement = speed > 12 and "Run" or speed > 1 and "Walk" or "Idle"
				if nextMovement ~= movement then
					if movement then
						tracks["Grab" .. movement]:Stop(0.1)
						tracks["GrabVictim" .. movement]:Stop(0.1)
					end
					tracks["Grab" .. nextMovement]:Play(0.1)
					tracks["GrabVictim" .. nextMovement]:Play(0.1)
					movement = nextMovement
				end
				task.wait()
			end
			local cancelled = actor.State.ThrowRequest == "Cancel"
			actor.State.ThrowRequest = nil
			actor:PCallAllClients("OnHomingStopped")
			actor:PCallLocal("OnHomingStopped")
			if not valid() then return end
			if cancelled then

				phase = "cancelled"
				detach()
				victimRoot.AssemblyLinearVelocity = Vector3.zero
				victimRoot.AssemblyAngularVelocity = Vector3.zero
				actor:SetCooldownOf("Grab", grab.CooldownCancel or grab.CooldownMiss)
				cleanup()                                                             
				local helpless = Statuses:ApplyStatus(rig, "Helpless", {Level = 1, Duration = 2})
				if helpless then helpless.TimeRequired = 2 end
				return
			end
			phase = "release"
			actor.AbilitiesDisabled = true
			local throwTrack = load("GrabThrow", rig)
			local victimThrow = load("GrabVictimThrow", victim)
			for _, name in {"GrabIdle", "GrabWalk", "GrabRun", "GrabVictimIdle", "GrabVictimWalk", "GrabVictimRun"} do
				tracks[name]:Stop(0.05)
			end
			throwTrack:Play(0.025)
			if not waitTrack(victimThrow, grab.ThrowAnimationTimeout or 8, nil, "Throw") then return end

			if not valid() then return end
			local direction = actor.State.MousePosition
			if typeof(direction) ~= "Vector3" or direction.Magnitude < 0.001
				or direction.Magnitude ~= direction.Magnitude or direction.Magnitude == math.huge then
				direction = root.CFrame.LookVector
			end
			direction = direction.Unit
			Network:FireClientConnection(actor.Player, "SetTrackingMousePosition", "REMOTE_EVENT", direction)
			detach()
			phase = "flight"
			actor:PCallLocal("SetGrabStaminaRegenReduction", false)
			rig:SetAttribute("MoveAnimationOverwrite", nil)
			actor:PCallLocal("SetGrabAbilityLocks", false)
			actor.AbilitiesDisabled = false
			actor.DisabledAbilities = {}
			actor:SetCooldownOf("Grab", grab.CooldownSuccess)
			local releasedAt = os.clock()
			local helpless = Statuses:ApplyStatus(rig, "Helpless", {Level = 1, Duration = grab.ThrowHelpless or 2})
			if helpless then helpless.TimeRequired = grab.ThrowHelpless or 2 end
			Ragdolls.EnableRagdoll(victim)
			ragdolled = true
			victimRoot:SetNetworkOwner(nil)
			local velocity = direction * grab.ThrowVelocity
			victimRoot.AssemblyLinearVelocity = velocity
			Sounds:Play(actor.Config.Sounds.GrabThrow, {Parent = root, Volume = 0.35})
			__playSound(actor, "GrabThrown", {Parent = victimRoot})
			actor:PlayVoiceline("GrabThrow", {Priority = 2})
			local trail = actor.Config.Instances.ThrowTrailVFX:Clone()
			for _, child in trail:GetChildren() do
				child.Parent = victim:FindFirstChild("Torso") or victimRoot
				own(child)
			end
			trail:Destroy()
			actor:PCallAllClients("OnThrown", victim)
			local params = RaycastParams.new()
			params.FilterDescendantsInstances = {workspace.Players}
			params.CollisionGroup = workspace:GetAttribute("FriendlyFire") and "Default" or "Survivors"
			params.RespectCanCollide = true
			local previousPosition = victimRoot.Position
			while valid() and os.clock() - releasedAt < 3 do
				local dt = task.wait()
				if not valid() then return end
				velocity -= Vector3.new(0, workspace.Gravity * grab.GravityCoefficient * dt, 0)
				local displacement = victimRoot.Position - previousPosition
				local result = displacement.Magnitude > 0.001 and workspace:Raycast(previousPosition, displacement, params)
				result = result or workspace:Raycast(victimRoot.Position, velocity * dt * 2, params)
				if not result and os.clock() - releasedAt > 0.2 then
					result = workspace:Raycast(victimRoot.Position, Vector3.new(0, -3.4, 0), params)
				end
				if result then applyImpact(result, velocity, releasedAt); return end
				previousPosition = victimRoot.Position
				victimRoot.AssemblyLinearVelocity = velocity
			end
			if valid() then
				phase = "impact"
				Ragdolls.EnableRagdoll(victim, grab.RagdollDuration)
			end
		end, debug.traceback)
		if phase == "pull" or phase == "success" or phase == "hold" or phase == "release" then
			safe(function() actor:SetCooldownOf("Grab", grab.CooldownMiss) end)
		end

		for _, object in objects do safe(function() object:Destroy() end) end
		cleanup()
		if not ok then warn("[Azure Enstrangle] " .. tostring(err)) end
	end;

	function u77.sv_MissGrab(p255, p256)              

		p256:PCallLocal("SetGrabSprintDisabled", false);
		p256:PCallLocal("SetGrabStaminaRegenReduction", false);
		p256:PCallLocal("SetGrabAbilityLocks", false);
		p256.State.GrabWindingUp = false;
		p256.State.GrabReadyToFire = false;
		p256:SetCooldownOf("Grab", p256.Config.Grab.CooldownMiss);
		Util:CreateSpeedMultiplier(p256.Rig, p256.Config.Grab.MissSlowness, "AzureGrabMissed", p256.Config.Grab.MissSlownessDuration);
		p256.AbilitiesDisabled = false;
		p256.DisabledAbilities = {};
	end;

	function u77.sv_UpdateFlowers(p257, p258, p259, p260)              
		p258:PCallAllClients("UpdateFlowers", p259, p260);
	end;
else
	local function getRandomRotationCF(p261)              
		local Angles = CFrame.Angles;
		local v262 = Random.new():NextNumber(-p261, p261);
		local v263 = math.rad(v262);
		local v264 = Random.new():NextNumber(-p261, p261);
		local v265 = math.rad(v264);
		local v266 = Random.new():NextNumber(-p261, p261);

		return Angles(v263, v265, (math.rad(v266)));
	end;

	local function getRandomScaleVector(p267)              
		local v268 = p267 or 0.25;
		local v269 = Random.new():NextNumber(1 - v268, v268 + 1);
		local v270 = Random.new():NextNumber(1 - v268, v268 + 1);
		local v271 = Random.new();

		return Vector3.new(v269, v270, v271:NextNumber(1 - v268, v268 + 1));
	end;

	local function getAbilityIcon(p272)              

		local v273 = u4 and u4:FindFirstChild("PlayerGui");

		if v273 then
			v273 = v273:FindFirstChild("MainUI");
		end;

		if v273 then
			v273 = v273:FindFirstChild("AbilityContainer");
		end;

		if v273 then
			v273 = v273:FindFirstChild(p272);
		end;

		return v273;
	end;

	local function setAbilityCount(p274, p275, p276, p277)              

		local v278 = u4 and u4:FindFirstChild("PlayerGui");

		if v278 then
			v278 = v278:FindFirstChild("MainUI");
		end;

		if v278 then
			v278 = v278:FindFirstChild("AbilityContainer");
		end;

		if v278 then
			v278 = v278:FindFirstChild(p275);
		end;

		if v278 then
			v278 = v278:FindFirstChild("Charges");
		end;

		if not v278 then
			return;
		end;

		p274.Cache.AbilityCountTextColors = p274.Cache.AbilityCountTextColors or {};

		if not p274.Cache.AbilityCountTextColors[p275] then
			p274.Cache.AbilityCountTextColors[p275] = v278.TextColor3;
		end;

		local v279 = math.min(p276, p277);
		v278.Text = v279 <= 0 and "" or tostring(v279);
		local v280;

		if p277 <= v279 then
			v280 = Color3.fromRGB(255, 70, 70);
		else
			v280 = p274.Cache.AbilityCountTextColors[p275];
		end;

		v278.TextColor3 = v280;
	end;

	local function setAbilityIconVisible(p281, p282, p283)              

		local v284 = u4 and u4:FindFirstChild("PlayerGui");

		if v284 then
			v284 = v284:FindFirstChild("MainUI");
		end;

		if v284 then
			v284 = v284:FindFirstChild("AbilityContainer");
		end;

		if v284 then
			v284 = v284:FindFirstChild(p282);
		end;

		if not v284 then
			return;
		end;

		p281.Cache.HiddenAbilityIconSizes = p281.Cache.HiddenAbilityIconSizes or {};
		local HiddenAbilityIconSizes = p281.Cache.HiddenAbilityIconSizes;

		if p283 then
			if HiddenAbilityIconSizes[p282] then
				v284.Size = HiddenAbilityIconSizes[p282];
				HiddenAbilityIconSizes[p282] = nil;
			end;

			v284.Visible = true;

			return;
		end;

		if not HiddenAbilityIconSizes[p282] then
			HiddenAbilityIconSizes[p282] = v284.Size;
		end;

		v284.Visible = false;
		v284.Size = UDim2.fromScale(0, 0);
	end;

	local function updateConstructCounters(p285)              

		local v286 = p285.State.ConstructCounts or {};
		setAbilityCount(p285, "Sow", v286.GroundBulb or 0, (getConstructLimit(p285, "GroundBulb")));
		setAbilityCount(p285, "Blossom", v286.Vine or 0, (getConstructLimit(p285, "Vine")));
	end;

	local function getGolemLifetimeBarData(p287)              
		local Golems = p287.State.Golems;

		if not Golems then
			return nil;
		end;

		local v288 = p287.State.ControllingGolem or p287.State.SelectedGolem;

		if v288 then
			v288 = Golems[v288];
		end;

		return v288;
	end;

	local function updateGolemLifetimeBar(p289)              
		local Unravel = p289.Behavior.Abilities.Unravel;
		local Golems = p289.State.Golems;
		local v290;

		if Golems then
			v290 = p289.State.ControllingGolem or p289.State.SelectedGolem;

			if v290 then
				v290 = Golems[v290];
			end;
		else
			v290 = nil;
		end;

		if not (v290 and (v290.Lifetime and v290.RemainingLifetime)) then
			Unravel.ChargeDuration = nil;
			Unravel.CurrentRecharge = nil;
			Unravel.RechargeInverted = nil;
			Unravel.RechargePaused = nil;

			return;
		end;

		local v291 = math.clamp(v290.RemainingLifetime, 0, v290.Lifetime);

		if p289.State.ControllingGolem and v290.LifetimeStartedAt then
			local v292 = v291 - (os.clock() - v290.LifetimeStartedAt);
			v291 = math.max(v292, 0);
		end;

		Unravel.ChargeDuration = v290.Lifetime;
		Unravel.CurrentRecharge = math.clamp(v290.Lifetime - v291, 0, v290.Lifetime);
		Unravel.RechargeInverted = true;
		Unravel.RechargePaused = not (p289.State.ControllingGolem and v290.LifetimeStartedAt);
	end;

	function u77.lcl_DenyBuild(p293, p294, p295, message)              

		Util:CreateWarning("AzureBuildNo", message or "Move further away from your other plants.");
		__playSound(p294, "BuildDenied", {
			Parent = workspace
		});
	end;

	function u77.lcl_SetGolemSpawnAbilityLocks(p296, p297, u298)              

		task.defer(function()              

			for _, v in ipairs({ "Slash", "Sow", "Blossom", "Unravel" }) do
				Util:ToggleLockForAbilityIcon(v, "GolemSpawn", u298);
			end;
		end);
	end;

	function u77.lcl_ResetGrabVisuals(_, actor)
		if actor.State then
			actor.State.GrabAimingSequence = nil
			actor.State.GrabAimingBeam = nil
			actor.State.TrackingMousePosition = nil
			actor.State.GrabbedRoot = nil
		end
		actor.LookFlag = nil
		if actor.Cache then
			actor.Cache.AzureFacingToken = nil
			actor.Cache.AzureAimRenderToken = nil
			actor.Cache.AzureHoldRenderToken = nil
		end
		RunService:UnbindFromRenderStep("AzureCameraUpdate")
		RunService:UnbindFromRenderStep("AzureCameraUpdateHoming")
		RunService:UnbindFromRenderStep("MouseTracking")
		local rig = actor.Rig
		local hum = rig and rig:FindFirstChildOfClass("Humanoid")
		if not hum then return end
		rig:SetAttribute("AzureGrabFacing", nil)
		rig:SetAttribute("DirectionalMovementDisabled", nil)
		rig:SetAttribute("MoveAnimationOverwrite", nil)
		local animator = hum:FindFirstChildOfClass("Animator")
		if animator then
			local ids = {}
			for name, id in actor.Config.Animations do
				if name:match("^Grab") and typeof(id) == "string" then ids[id] = true end
			end
			for _, track in animator:GetPlayingAnimationTracks() do
				if track.Animation and ids[track.Animation.AnimationId] then track:Stop(0) end
			end
		end
		if actor.Destroyed or hum.Health <= 0 or not rig:IsDescendantOf(workspace) then return end
		local shiftLock = require(ReplicatedStorage.Systems.Player.Game.SmoothShiftLock)
		hum.AutoRotate = not shiftLock:IsEnabled()
		actor.Moving = nil
		if actor.AnimationType == false or rig:GetAttribute("Ragdolling") then return end
		local prefix = actor.AnimationType or (hum.Health - (hum:GetAttribute("FakeDamage") or 0) <= hum.MaxHealth / 2 and "Injured" or "")
		local root = rig.PrimaryPart
		local moving = root and Vector3.new(root.AssemblyLinearVelocity.X, 0, root.AssemblyLinearVelocity.Z).Magnitude > 0.5
		local name = moving and (Sprinting.IsSprinting and "Run" or "Walk") or "Idle"
		local track = actor.Animations and actor.Animations[prefix .. name]
		if track and not track.IsPlaying then track:Play(0.1) end
	end;

	function u77.lcl_SetGrabSprintDisabled(_, actor, disabled)
		actor.Cache = actor.Cache or {}
		if disabled then
			actor.Cache.AzureGrabResumeSprint = actor.Cache.AzureGrabResumeSprint or Sprinting.IsSprinting
		end
		Network:FireConnection("DisableSprinting", "AzureGrab", disabled)
		if disabled then

			if Sprinting.__speedMultiplier then
				TweenService:Create(Sprinting.__speedMultiplier, TweenInfo.new(0), {Value = 1}):Play()
			end
			if Sprinting.__FOVMultiplier then
				TweenService:Create(Sprinting.__FOVMultiplier, TweenInfo.new(0.1), {Value = 1}):Play()
			end
		end
		if not disabled then
			local resumeMobile = actor.Cache.AzureGrabResumeSprint
			actor.Cache.AzureGrabResumeSprint = nil
			if Sprinting.CanSprint and Sprinting.BindsEnabled then
				if Device:GetPlayerDevice() == "Mobile" then
					if resumeMobile and not Sprinting.IsSprinting and Sprinting.__sprintHandler then
						Sprinting.__sprintHandler("Sprinting", Enum.UserInputState.Begin)
					end
				else
					Sprinting:SyncHeldKey()
				end
			end
		end
	end;

	function u77.lcl_SetGrabAbilityLocks(p299, p300, u301, lockSlash)              

		task.defer(function()              

			for _, v in ipairs({ "Sow", "Blossom", "Unravel" }) do
				Util:ToggleLockForAbilityIcon(v, "AzureGrab", u301);
			end;
			Util:ToggleLockForAbilityIcon("Slash", "AzureGrab", u301 and lockSlash == true);
		end);
	end;

	function u77.lcl_SetGrabStaminaRegenReduction(p302, p303, p304)              

		if p304 then
			if p303.Cache.AzureGrabStaminaGain == nil then
				p303.Cache.AzureGrabStaminaGain = Sprinting.StaminaGain or 20;
			end;

			Sprinting.StaminaGain = p303.Cache.AzureGrabStaminaGain * 0.25;
		elseif p303.Cache.AzureGrabStaminaGain ~= nil then
			Sprinting.StaminaGain = p303.Cache.AzureGrabStaminaGain;
			p303.Cache.AzureGrabStaminaGain = nil;
		end;

		if not p304 then
			p303.Cache.AzureGrabConnected = nil;
		end;
	end;

	function u77.lcl_RegisterSeeker(p305, p306, p307)              

		p306.State.ActiveSeekers = p306.State.ActiveSeekers or {};
		local Part = Instance.new("Part");
		Part.CanCollide = false;
		Part.CanQuery = true;
		Part.CanTouch = true;
		Part.Transparency = u3 and 0.9 or 1;
		Part.Size = Vector3.new(8, 8, 8);
		Part.Anchored = true;
		Part.Name = "SeekerHoverHitbox";
		Part.Parent = workspace.Map.Ingame;
		Part.Shape = Enum.PartType.Ball;
		Part.CFrame = p307.CFrame;
		Part:SetAttribute("UUID", p307.UUID);
		p306.State.ActiveSeekers[p307.UUID] = {
			Selectable = false,
			HoverHitbox = Part
		};
	end;

	function u77.lcl_UnregisterSeeker(p308, p309, p310)              
		p309.State.ActiveSeekers = p309.State.ActiveSeekers or {};
		local v311 = p309.State.ActiveSeekers[p310.UUID];

		if v311 then
			v311.HoverHitbox:Destroy();
			table.clear(v311);
			p309.State.ActiveSeekers[p310.UUID] = nil;
		end;
	end;

	function u77.lcl_CreateGolemStatueHighlight(p312, p313, p314)              
		local Highlight = Instance.new("Highlight");
		Highlight.FillTransparency = 0.9;
		Highlight.OutlineTransparency = 0.7;
		Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop;
		Highlight.FillColor = Color3.new(0.341176, 0.12549, 0.384314);
		Highlight.Parent = p314;

		return Highlight;
	end;

	function u77.lcl_ToggleStatueHighlight(p315, p316, p317, p318)              
		p317.FillTransparency = p318 and 0.1 or 0.9;
		p317.OutlineTransparency = p318 and 0.1 or 0.7;
		local v319;

		if p318 then
			v319 = Color3.new(0.701961, 0, 1);
		else
			v319 = Color3.new(0.341176, 0.12549, 0.384314);
		end;

		p317.FillColor = v319;
	end;

	function u77.lcl_CreateGolem(p320, p321, p322)              

		if not p321.State.Golems then
			return;
		end;

		local Part = Instance.new("Part");
		Part.CanCollide = false;
		Part.CanQuery = true;
		Part.CanTouch = true;
		Part.Transparency = u3 and 0.9 or 1;
		Part.Size = Vector3.new(8, 8, 8);
		Part.Anchored = true;
		Part.Name = "GolemHoverHitbox";
		Part.Parent = workspace.Map.Ingame;
		Part.Shape = Enum.PartType.Ball;
		Part.CFrame = p322.CFrame;
		Part:SetAttribute("UUID", p322.UUID);
		p321.State.Golems[p322.UUID] = {
			Selectable = false,
			HoverHitbox = Part,
			Lifetime = p322.Lifetime,
			RemainingLifetime = p322.RemainingLifetime or p322.Lifetime
		};
		updateGolemLifetimeBar(p321);
		AnimationSupport.Track(p321, "GolemSpawn"):Play();
		Util:ApplyCameraShake(0.25, 4.8);
		p321.Behavior:EnableStomping(p321);
		local MassInfectionShockwaveVignette = p321.Config.Instances.MassInfectionShockwaveVignette;
		local u323;

		if MassInfectionShockwaveVignette then
			u323 = MassInfectionShockwaveVignette:Clone();
		else
			u323 = MassInfectionShockwaveVignette;
		end;

		u323.Name = "AZURELONGSHINE";
		u323.Parent = p321.Player.PlayerGui;
		local u324 = u323:FindFirstChildOfClass("ImageLabel");

		if MassInfectionShockwaveVignette then
			u324.ImageTransparency = 1;
			TweenService:Create(u324, TweenInfo.new(4.8, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
				ImageTransparency = 0.9
			}):Play();
			task.delay(4.8, function()              

				TweenService:Create(u324, TweenInfo.new(1, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut), {
					ImageTransparency = 1
				}):Play();
			end);
			task.delay(5.8, function()              

				u323:Destroy();
			end);
		end;
	end;

	function u77.lcl_UpdateGolemLifetime(p325, p326, p327, p328)              

		local v329 = p326.State.Golems and p326.State.Golems[p327];

		if not v329 then
			return;
		end;

		v329.RemainingLifetime = p328;

		if p327 == p326.State.ControllingGolem then
			v329.LifetimeStartedAt = os.clock();
		else
			v329.LifetimeStartedAt = nil;
		end;

		updateGolemLifetimeBar(p326);
	end;

	function u77.lcl_DestroyGolem(p330, p331, p332)              

		__pcallMethod("lcl_SetGolemSpawnAbilityLocks", p331, false);
		local v333 = p331.State.Golems[p332];

		if not v333 then
			return;
		end;

		if v333.HoverHitbox then
			v333.HoverHitbox:Destroy();
		end;

		if v333.Highlight then
			v333.Highlight:Destroy();
			v333.Highlight = nil;
		end;

		p331.State.Golems[p332] = nil;
		table.clear(v333);

		if not next(p331.State.Golems) then
			p331.Behavior.Abilities.Unravel.ChargeDuration = nil;
			p331.Behavior.Abilities.Unravel.CurrentRecharge = nil;
			p331.Behavior.Abilities.Unravel.RechargeInverted = nil;
			p331.Behavior.Abilities.Unravel.RechargePaused = nil;
		end;

		local MassInfectionShockwaveVignette = p331.Config.Instances.MassInfectionShockwaveVignette;
		local u334;

		if MassInfectionShockwaveVignette then
			u334 = MassInfectionShockwaveVignette:Clone();
		else
			u334 = MassInfectionShockwaveVignette;
		end;

		u334.Name = "AZUREQUICKSHINE";
		u334.Parent = p331.Player.PlayerGui;
		local u335 = u334:FindFirstChildOfClass("ImageLabel");

		if MassInfectionShockwaveVignette then
			u335.ImageTransparency = 1;
			TweenService:Create(u335, TweenInfo.new(0.1, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut), {
				ImageTransparency = 0.9
			}):Play();
			task.delay(0.2, function()              

				TweenService:Create(u335, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut), {
					ImageTransparency = 1
				}):Play();
			end);
			task.delay(1, function()              

				u334:Destroy();
			end);
		end;
	end;

	function u77.lcl_ControlGolem(p336, u337, p338, p339, p340, p341, p342)              

		local v343 = u337.State.Golems[p338];

		if not v343 then
			return;
		end;

		v343.RemainingLifetime = p340 or v343.RemainingLifetime;
		local v344;

		if p341 == false then
			v344 = nil;
		else
			v344 = os.clock();
		end;

		v343.LifetimeStartedAt = v344;
		v343.Statue = nil;

		if v343.Highlight then
			v343.Highlight:Destroy();
			v343.Highlight = nil;
		end;

		if p339 then
			Util:ToggleLockForAbilityIcon("Unravel", "PowerGolem", true);
		else
			u337.Behavior.Abilities.Unravel.Name = "Burrowing";
			u337.Behavior.Abilities.Unravel.Icon = "rbxassetid://118807424032527";
		end;

		u337.Behavior.Abilities.Slash.Name = "Pummeling";
		u337.Behavior.Abilities.Slash.Icon = "rbxassetid://140315649585204";
		u337.Behavior.Abilities.Sow.Name = "Blooming";
		u337.Behavior.Abilities.Sow.Icon = "rbxassetid://137117538410289";
		u337.Behavior.Abilities.Blossom.Name = "Unearthing";
		u337.Behavior.Abilities.Blossom.Icon = "rbxassetid://93057344813136";
		setAbilityIconVisible(u337, "Grab", false);
		Util:ToggleLockForAbilityIcon("Grab", "Golem", true);
		u337.Cache.CachedStaminaData = {
			Stamina = Sprinting.Stamina,
			MaxStamina = Sprinting.MaxStamina
		};
		u337.Cache.LastStamina = Sprinting.Stamina;
		local Stamina = u337.Config.Golem.Stamina;
		local v345 = v343.LastExited or 0;
		local v346 = (v343.LastStamina or 40) + (os.clock() - v345) * u337.Config.Golem.StaminaGainIdle;
		local v347 = math.clamp(v346, 0, Stamina);
		Sprinting.MaxStamina = Stamina;
		Sprinting.Stamina = v347;

		if p342 == nil then
			TweenService:Create(Util:CreateCameraOffset(u337.Rig, Vector3.new(0, 0, 0), "Golem"), TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Value = Vector3.new(0, 4, 0)
			}):Play();
		else
			local u348 = p342.Position + Vector3.new(0, 1.5, 0);
			local u349 = Util:CreateCameraOffset(u337.Rig, Vector3.new(0, 0, 0), "Golem");
			local NumberValue = Instance.new("NumberValue");
			NumberValue.Value = 0;
			TweenService:Create(NumberValue, TweenInfo.new(0.75), {
				Value = 1
			}):Play();
			local u350 = nil;
			u350 = RunService.RenderStepped:Connect(function(p351)              

				local Value = NumberValue.Value;
				u349.Value = (u337.Rig.PrimaryPart.CFrame * CFrame.new(0, 1.5, 0)):PointToObjectSpace(u348):Lerp(Vector3.new(0, 4, 0), NumberValue.Value);

				if Value >= 1 then
					u350:Disconnect();
				end;
			end);
		end;

		local MassInfectionShockwaveVignette = u337.Config.Instances.MassInfectionShockwaveVignette;
		local u352;

		if MassInfectionShockwaveVignette then
			u352 = MassInfectionShockwaveVignette:Clone();
		else
			u352 = MassInfectionShockwaveVignette;
		end;

		u352.Name = "AZUREQUICKSHINE";
		u352.Parent = u337.Player.PlayerGui;
		local u353 = u352:FindFirstChildOfClass("ImageLabel");

		if MassInfectionShockwaveVignette then
			u353.ImageTransparency = 1;
			TweenService:Create(u353, TweenInfo.new(0.1, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut), {
				ImageTransparency = 0.9
			}):Play();
			task.delay(0.2, function()              

				TweenService:Create(u353, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut), {
					ImageTransparency = 1
				}):Play();
			end);
			task.delay(1, function()              

				u352:Destroy();
			end);
		end;

		u337.State.ControllingGolem = p338;
		u337.AnimationType = "Golem";
		updateGolemLifetimeBar(u337);
	end;

	function u77.lcl_ReleaseGolem(p354, u355, p356, p357, p358, p359, p360)              

		local v361 = u355.State.Golems[p356];

		if not v361 then
			return;
		end;

		v361.HoverHitbox.CFrame = p358;
		v361.Statue = p357;
		v361.Highlight = __pcallMethod("lcl_CreateGolemStatueHighlight", u355, p357);
		v361.RemainingLifetime = p359 or v361.RemainingLifetime;
		v361.LifetimeStartedAt = nil;
		v361.LastExited = os.clock();
		v361.LastStamina = Sprinting.Stamina;
		u355.Behavior.Abilities.Unravel.Name = "Inflorescence";
		u355.Behavior.Abilities.Unravel.Icon = "rbxassetid://109425766636886";
		u355.Behavior.Abilities.Slash.Name = "Perforating";
		u355.Behavior.Abilities.Slash.Icon = "rbxassetid://123556520269026";
		u355.Behavior.Abilities.Sow.Name = "Seeker Bulb";
		u355.Behavior.Abilities.Sow.Icon = "rbxassetid://109787679155717";
		u355.Behavior.Abilities.Blossom.Name = "Stigmatize";
		u355.Behavior.Abilities.Blossom.Icon = "rbxassetid://117545955019424";
		local v362 = u355.Cache.CachedStaminaData or {};
		local v363 = v362.MaxStamina or u355.Config.MaxStamina;
		local v364 = math.clamp(v362.Stamina or (u355.Cache.LastStamina or v363), 0, v363);
		Sprinting.MaxStamina = v363;
		Sprinting.Stamina = v364;

		if p360 == nil then
			TweenService:Create(Util:CreateCameraOffset(u355.Rig, Vector3.new(0, 4, 0), "Golem", 0.75), TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
				Value = Vector3.new(0, 0, 0)
			}):Play();
		else
			local u365 = p360.Position + Vector3.new(0, 1.5, 0);
			local u366 = Util:CreateCameraOffset(u355.Rig, Vector3.new(0, 0, 0), "Golem");
			local NumberValue = Instance.new("NumberValue");
			NumberValue.Value = 0;
			TweenService:Create(NumberValue, TweenInfo.new(0.75), {
				Value = 1
			}):Play();
			local u367 = nil;
			u367 = RunService.RenderStepped:Connect(function(p368)              

				local Value = NumberValue.Value;
				u366.Value = (u355.Rig.PrimaryPart.CFrame * CFrame.new(0, 1.5, 0)):PointToObjectSpace(u365 + Vector3.new(0, 4, 0)):Lerp(Vector3.new(0, 0, 0), NumberValue.Value);

				if Value >= 1 then
					u367:Disconnect();
				end;
			end);
		end;

		Util:ToggleLockForAbilityIcon("Grab", "Golem", false);
		setAbilityIconVisible(u355, "Grab", true);
		local v369 = u4 and u4:FindFirstChild("PlayerGui");

		if v369 then
			v369 = v369:FindFirstChild("MainUI");
		end;

		if v369 then
			v369 = v369:FindFirstChild("AbilityContainer");
		end;

		if v369 then
			v369 = v369:FindFirstChild("Grab");
		end;

		if v369 then
			u355.Cache.HiddenAbilityIconSizes = u355.Cache.HiddenAbilityIconSizes or {};
			local HiddenAbilityIconSizes = u355.Cache.HiddenAbilityIconSizes;

			if HiddenAbilityIconSizes.Grab then
				v369.Size = HiddenAbilityIconSizes.Grab;
				HiddenAbilityIconSizes.Grab = nil;
			end;

			v369.Visible = true;
		end;

		u355.State.ControllingGolem = nil;
		u355.AnimationType = nil;
		updateGolemLifetimeBar(u355);
		local MassInfectionShockwaveVignette = u355.Config.Instances.MassInfectionShockwaveVignette;
		local u370;

		if MassInfectionShockwaveVignette then
			u370 = MassInfectionShockwaveVignette:Clone();
		else
			u370 = MassInfectionShockwaveVignette;
		end;

		u370.Name = "AZUREQUICKSHINE";
		u370.Parent = u355.Player.PlayerGui;
		local u371 = u370:FindFirstChildOfClass("ImageLabel");

		if MassInfectionShockwaveVignette then
			u371.ImageTransparency = 1;
			TweenService:Create(u371, TweenInfo.new(0.1, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut), {
				ImageTransparency = 0.9
			}):Play();
			task.delay(0.2, function()              

				TweenService:Create(u371, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut), {
					ImageTransparency = 1
				}):Play();
			end);
			task.delay(1, function()              

				u370:Destroy();
			end);
		end;
	end;

	function u77.lcl_OnHomingStopped(p372, p373)              
		p373.LookFlag = nil;
		p373.Cache.HomingInstances = nil;
	end;

	function u77.lcl_OnHomingStart(p374, u375)              

		local Attachment = Instance.new("Attachment", u375.Rig.PrimaryPart);
		local u376 = u375.Config.Instances.HomingLooker:Clone();
		u376.Attachment0 = Attachment;
		u376.CFrame = u375.Rig.PrimaryPart.CFrame;
		u376.Parent = u375.Rig.PrimaryPart;
		local u377 = Util:CreateFOVMultiplier(u375.Player, 1, "ScopeAzure");
		TweenService:Create(u377, TweenInfo.new(1.2, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
			Value = 0.75
		}):Play();
		u375.LookFlag = true;
		local facingToken = {};
		u375.Cache.AzureFacingToken = facingToken;
		u375.Rig:SetAttribute("AzureGrabFacing", true);
		u375.Rig.Humanoid.AutoRotate = false;
		u375.Rig:SetAttribute("DirectionalMovementDisabled", true);
		task.spawn(function()              

			local u378 = Util:CreateCameraOffset(u375.Rig, Vector3.new(0, 0, 0), "AzureGrabAiming");
			TweenService:Create(u378, TweenInfo.new(0.3), {
				Value = Vector3.new(-2.5, 1, 0)
			}):Play();
			u375.Cache.AzureHoldRenderToken = facingToken;
			RunService:BindToRenderStep("AzureCameraUpdateHoming", Enum.RenderPriority.Camera.Value + 2, function()              
				if u375.Cache.AzureFacingToken ~= facingToken then return end;

				local LookVector = workspace.CurrentCamera.CFrame.LookVector;
				local v379 = Vector3.new(LookVector.X, 0, LookVector.Z);

				if v379.Magnitude < 0.001 or v379 ~= v379 then
					return;
				end;

				u376.CFrame = CFrame.new(u375.Rig.PrimaryPart.Position, u375.Rig.PrimaryPart.Position + v379);
			end);

			while u375.LookFlag and u375.Cache.AzureFacingToken == facingToken and u375.Rig:IsDescendantOf(workspace) do
				RunService.Heartbeat:Wait();
			end;

			if u375.Cache.AzureHoldRenderToken == facingToken then
				RunService:UnbindFromRenderStep("AzureCameraUpdateHoming");
				u375.Cache.AzureHoldRenderToken = nil;
			end;
			if u375.Cache.AzureFacingToken ~= facingToken then
				Attachment:Destroy(); u376:Destroy(); u378:Destroy(); u377:Destroy();
				return;
			end;
			u375.Cache.AzureFacingToken = nil;
			TweenService:Create(u378, TweenInfo.new(0.3), {
				Value = Vector3.new(0, 0, 0)
			}):Play();
			TweenService:Create(u377, TweenInfo.new(0.3), {
				Value = 1
			}):Play();
			task.delay(0.3, function()              

				u378:Destroy();
				u377:Destroy();
			end);
			RunService:UnbindFromRenderStep("AzureCameraUpdateHoming");
			Attachment:Destroy();
			u376:Destroy();
			u375.Rig:SetAttribute("AzureGrabFacing", nil);
			local humanoid = u375.Rig:FindFirstChildOfClass("Humanoid");
			if humanoid then humanoid.AutoRotate = true end;
			u375.Rig:SetAttribute("DirectionalMovementDisabled", nil);
		end);
	end;

	function u77.lcl_InitHomingUI(p380, p381, p382)              

		local v383 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);

		for _, descendant in pairs(p382:GetDescendants()) do
			if descendant:IsA("ImageLabel") then
				local v384 = {
					ImageTransparency = descendant.ImageTransparency
				};
				descendant.ImageTransparency = 1;
				TweenService:Create(descendant, v383, v384):Play();
			elseif descendant:IsA("TextLabel") then
				local v385 = {
					TextTransparency = descendant.TextTransparency,
					TextStrokeTransparency = descendant.TextStrokeTransparency
				};
				descendant.TextTransparency = 1;
				descendant.TextStrokeTransparency = 1;
				TweenService:Create(descendant, v383, v385):Play();
			end;
		end;
	end;

	function u77.lcl_UpdateHomingUI(p386, p387, p388, p389)              
		local v390 = math.clamp(p389, 0, 1);
		local RingFrame = p388.RingFrame;
		local LeftFill = RingFrame.LeftClip.LeftFill;
		local RightFill = RingFrame.RightClip.RightFill;
		local UIGradient = LeftFill.UIGradient;
		local UIGradient2 = RightFill.UIGradient;
		local v391 = v390 * 360;

		if v390 <= 0 then
			LeftFill.Visible = false;
			RightFill.Visible = false;

			return;
		end;

		RightFill.Visible = true;

		if v391 <= 180 then
			LeftFill.Visible = false;
			UIGradient2.Enabled = true;
			UIGradient2.Rotation = v391;

			return;
		end;

		UIGradient2.Enabled = true;
		UIGradient2.Rotation = 180;
		LeftFill.Visible = true;
		UIGradient.Enabled = true;
		UIGradient.Rotation = v391;
	end;

	function u77.lcl_DestroyHomingUI(p392, p393, p394)              

		local v395 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In);

		for _, descendant in pairs(p394:GetDescendants()) do
			if descendant:IsA("ImageLabel") then
				TweenService:Create(descendant, v395, {
					ImageTransparency = 1
				}):Play();
			elseif descendant:IsA("TextLabel") then
				TweenService:Create(descendant, v395, {
					TextTransparency = 1,
					TextStrokeTransparency = 1
				}):Play();
			end;
		end;

		game.Debris:AddItem(p394, 0.6);
	end;

	function u77.lcl_StartMouseTracking(p396, p397)              

		local Attachment = Instance.new("Attachment");
		local Attachment2 = Instance.new("Attachment");
		local v398 = p397.Config.Instances.TrajectoryBeam:Clone();
		local v399 = p397.Config.Instances.TrajectoryTarget:Clone();
		local Grab = resolveAzureGrabConfig(p397);
		local ThrowVelocity = Grab.ThrowVelocity;
		local v400 = workspace.Gravity * Grab.GravityCoefficient;
		local v401 = RaycastParams.new();
		v401.RespectCanCollide = true;
		v401.CollisionGroup = "Killers";
		v401.FilterType = Enum.RaycastFilterType.Exclude;
		v401.FilterDescendantsInstances = workspace.Players:GetDescendants();
		Attachment2.Parent = workspace.Terrain;
		v398.Parent = workspace.Map.Ingame;
		v399.Parent = workspace.Map.Ingame;
		v398.Attachment0 = Attachment;
		v398.Attachment1 = Attachment2;
		local v402 = {};
		local v403 = 0;

		for _, descendant in ipairs(p397.Rig:GetDescendants()) do
			if descendant:IsA("BasePart") then
				table.insert(v402, descendant);
			end;
		end;

		local v404 = 0;

		while p397.State and p397.State.TrackingMousePosition do
			if p397.State.MousePosition then
				local v405 = p397.State.GrabbedRoot or p397.Rig.PrimaryPart;
				if not v405 or not v405.Parent then break end;
				local _, v406, v407, v408, v409 = getTrajectoryPoints(Vector3.new(0, 1, 0) * -v400, (p397.State.MousePosition or Vector3.new(0, 0, 1)).Unit * ThrowVelocity, v405.CFrame.Position, v401);
				local v410 = math.max(0, 0.75 - v404);
				v404 = v404 + math.clamp(v403 * 2, 0, v410);
				Attachment.Parent = v405;
				v398.CurveSize0 = v406;
				v398.CurveSize1 = v407;
				Attachment.CFrame = Attachment.Parent.CFrame:inverse() * v408;
				Attachment2.CFrame = Attachment2.Parent.CFrame:inverse() * v409;
				v399:PivotTo(v409);
				v403 = task.wait();
			else
				task.wait();
			end;
		end;

		spawn(function()              
			for _ = 1, 16 do
				task.wait();
			end;
		end);
		Attachment:Destroy();
		Attachment2:Destroy();
		v398:Destroy();
		v399:Destroy();
	end;

	function u77.cl_UpdateFlowers(p411, u412, p413, p414)              

		local function createOneFlower(p415)              

			local u416 = u412.Config.Instances.InfectionFlower:Clone();
			local v417 = math.random(0, 1);
			local v418 = v417 == 0 and -1 or v417;
			local v419 = p415:FindFirstChild("Torso") or p415:FindFirstChild("UpperTorso");

			if v419 ~= nil then
				local v420 = CFrame.new((math.random() - 0.5) * v419.Size.X, (math.random() - 0.5) * v419.Size.Y, v418 * v419.Size.Z / 2) * CFrame.Angles(v418 == -1 and -1.5707963267948966 or 1.5707963267948966, 0, 0) * CFrame.Angles(0, math.random() * 2 * 3.141592653589793, 0);
				local NumberValue = Instance.new("NumberValue");
				NumberValue.Name = "SizeValue";
				NumberValue:GetPropertyChangedSignal("Value"):Connect(function()              

					u416:ScaleTo((math.max(NumberValue.Value, 0.01)));
				end);
				NumberValue.Value = 0.01;
				NumberValue.Parent = u416;
				local Weld = Instance.new("Weld");
				Weld.C0 = v420;
				Weld.Part0 = v419;
				Weld.Part1 = u416.PrimaryPart;
				Weld.Parent = u416.PrimaryPart;

				for _, descendant in pairs(u416:GetDescendants()) do
					if descendant:IsA("BasePart") and descendant ~= u416.PrimaryPart then
						local Weld2 = Instance.new("Weld");
						Weld2.C0 = u416.PrimaryPart.CFrame:ToObjectSpace(descendant.CFrame);
						Weld2.Part0 = u416.PrimaryPart;
						Weld2.Part1 = descendant;
						Weld2.Parent = descendant;
						descendant.Anchored = false;
					end;
				end;

				u416.PrimaryPart.Anchored = false;
				u416.Parent = p415;
				TweenService:Create(NumberValue, TweenInfo.new(0.5), {
					Value = 0.6
				}):Play();

				return {
					Character = p415,
					FlowerModel = u416,
					FlowerSize = NumberValue,
					FlowerWeld = Weld
				};
			end;
		end;

		local function deleteOneFlower(p421)              

			local v422 = u412.State.FlowersGenerated[p421];

			if v422 == nil then
				return;
			end;

			local u423 = v422.Flowers[1];

			if u423 == nil then
				return;
			end;

			TweenService:Create(u423.FlowerSize, TweenInfo.new(1), {
				Value = 0
			}):Play();
			task.delay(1, function()              

				u423.FlowerModel:Destroy();
			end);
			table.remove(v422.Flowers, 1);
			v422.Count = v422.Count - 1;
		end;

		local function deleteAllFlowers(p424)              

			local v425 = u412.State.FlowersGenerated[p424];

			if v425 == nil then
				return;
			end;

			for _ = #v425.Flowers, 1, -1 do
				deleteOneFlower(p424);
			end;
		end;

		local v426 = u412.State.FlowersGenerated[p413];

		if v426 == nil then
			v426 = {
				Count = 0,
				Flowers = {}
			};
			u412.State.FlowersGenerated[p413] = v426;
		end;

		if p414 ~= v426.Count then
			if p414 < v426.Count then
				for _ = #v426.Flowers, p414 + 1, -1 do
					deleteOneFlower(p413);
				end;
			elseif v426.Count < p414 then
				for _ = 1, p414 - v426.Count do
					local v427 = createOneFlower(p413);
					table.insert(v426.Flowers, v427);
					v426.Count = v426.Count + 1;
				end;
			end;
		end;

		if v426.Count == 0 then
			u412.State.FlowersGenerated[p413] = nil;
		end;
	end;

	function u77.lcl_HighlightCharacterInReachForGrab(p428, p429, p430, p431)              

		p429.State.HighlightedCharacters = p429.State.HighlightedCharacters or {};

		if p429.State.HighlightedCharacters[p430] then
			return;
		end;

		if p430:GetAttribute("Undetectable") == true then
			return;
		end;

		local Highlight = Instance.new("Highlight");
		Highlight.Name = "AzureReachHighlight";
		Highlight.FillTransparency = 1;
		Highlight.FillColor = Color3.fromRGB(255, 0, 251);
		Highlight.OutlineTransparency = 0.5;
		Highlight.OutlineColor = Color3.fromRGB(255, 0, 251);
		Highlight.DepthMode = Enum.HighlightDepthMode.Occluded;
		Highlight.Parent = p430;
		p429.State.HighlightedCharacters[p430] = Highlight;
		local v432 = TweenService:Create(Highlight, TweenInfo.new(0.2), {
			FillTransparency = 0,
			OutlineTransparency = 0
		});
		v432:Play();
		v432.Completed:Connect(function(p433)              

			if p433 == Enum.PlaybackState.Completed then
				TweenService:Create(Highlight, TweenInfo.new(0.4), {
					FillColor = Color3.fromRGB(0, 0, 0)
				}):Play();
				TweenService:Create(Highlight, TweenInfo.new(0.8), {
					FillTransparency = 0.75,
					OutlineTransparency = 0.5
				}):Play();
			end;
		end);
	end;

	function u77.lcl_RemoveHighlightCharacterInReachForGrab(p434, p435, p436, p437)              

		p435.State.HighlightedCharacters = p435.State.HighlightedCharacters or {};
		local u438 = p435.State.HighlightedCharacters[p436];

		if u438 == nil then
			return;
		end;

		TweenService:Create(u438, TweenInfo.new(0.4), {
			FillTransparency = 1,
			OutlineTransparency = 1
		}):Play();
		task.delay(0.4, function()              

			u438:Destroy();
		end);
		p435.State.HighlightedCharacters[p436] = nil;
	end;

	function u77.lcl_StartGrabAiming(p439, u440)              

		local Attachment = Instance.new("Attachment", u440.Rig.PrimaryPart);
		local u441 = u440.Config.Instances.HomingLooker:Clone();
		u441.PrimaryAxisOnly = false;
		u441.Responsiveness = 200;
		u441.Attachment0 = Attachment;
		u441.CFrame = u440.Rig.PrimaryPart.CFrame;
		u441.Parent = u440.Rig.PrimaryPart;
		u440.State.GrabAimingSequence = true;
		local facingToken = {};
		u440.Cache.AzureFacingToken = facingToken;
		u440.Rig:SetAttribute("AzureGrabFacing", true);
		local lastAimSent = -math.huge;
		u440.State.HighlightedCharacters = u440.State.HighlightedCharacters or {};
		local u442 = Util:CreateFOVMultiplier(u440.Player, 1, "AzureScopeGrab");
		TweenService:Create(u442, TweenInfo.new(1, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
			Value = 0.75
		}):Play();
		u440.LookFlag = true;
		u440.Rig.Humanoid.AutoRotate = false;
		task.spawn(function()              

			local u443 = Util:CreateCameraOffset(u440.Rig, Vector3.new(0, 0, 0), "AzureGrabAiming");
			TweenService:Create(u443, TweenInfo.new(0.55, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
				Value = Vector3.new(2.5, 1, 0)
			}):Play();

			for _, child in pairs(workspace.Players.Survivors:GetChildren()) do
				if (u440.Rig.PrimaryPart.Position - child:GetPivot().Position).Magnitude >= u440.Config.Grab.HookRange or child:GetAttribute("Undetectable") then
					__pcallMethod("lcl_RemoveHighlightCharacterInReachForGrab", u440, child, true);
				else
					__pcallMethod("lcl_HighlightCharacterInReachForGrab", u440, child, true);
				end;
			end;
			if workspace:GetAttribute("FriendlyFire") then
				for _, child in pairs(workspace.Players.Killers:GetChildren()) do
					if child == u440.Rig then continue end
					if (u440.Rig.PrimaryPart.Position - child:GetPivot().Position).Magnitude >= u440.Config.Grab.HookRange or child:GetAttribute("Undetectable") then
						__pcallMethod("lcl_RemoveHighlightCharacterInReachForGrab", u440, child, true);
					else
						__pcallMethod("lcl_HighlightCharacterInReachForGrab", u440, child, true);
					end;
				end;
			end

			u440.Cache.AzureAimRenderToken = facingToken;
			RunService:BindToRenderStep("AzureCameraUpdate", Enum.RenderPriority.Camera.Value + 5, function()              
				if u440.Cache.AzureFacingToken ~= facingToken then return end;

				if not (u440.Rig and u440.Rig.PrimaryPart) then
					return;
				end;

				local LookVector = workspace.CurrentCamera.CFrame.LookVector;
				if os.clock() - lastAimSent >= 0.05 then
					lastAimSent = os.clock();
					Network:FireServerConnection(`{u440.Player.Name}AzureUpdateMouse`, "REMOTE_EVENT", LookVector);
				end;
				local v444 = Vector3.new(LookVector.X, 0, LookVector.Z);

				if v444.Magnitude < 0.001 or v444 ~= v444 then
					return;
				end;



				u441.CFrame = CFrame.lookAt(u440.Rig.PrimaryPart.Position, u440.Rig.PrimaryPart.Position + v444);

				for _, child in pairs(workspace.Players.Survivors:GetChildren()) do
					if (u440.Rig.PrimaryPart.Position - child:GetPivot().Position).Magnitude >= u440.Config.Grab.HookRange or child:GetAttribute("Undetectable") then
						__pcallMethod("lcl_RemoveHighlightCharacterInReachForGrab", u440, child);
					else
						__pcallMethod("lcl_HighlightCharacterInReachForGrab", u440, child);
					end;
				end;
				if workspace:GetAttribute("FriendlyFire") then
					for _, child in pairs(workspace.Players.Killers:GetChildren()) do
						if child == u440.Rig then continue end
						if (u440.Rig:GetPivot().Position - child:GetPivot().Position).Magnitude >= u440.Config.Grab.HookRange or child:GetAttribute("Undetectable") then
							__pcallMethod("lcl_RemoveHighlightCharacterInReachForGrab", u440, child);
						else
							__pcallMethod("lcl_HighlightCharacterInReachForGrab", u440, child);
						end;
					end;
				end
			end);

			while u440.State.GrabAimingSequence == true and u440.Cache.AzureFacingToken == facingToken and u440.Rig:IsDescendantOf(workspace) do
				RunService.Heartbeat:Wait();
			end;

			if u440.Cache.AzureAimRenderToken == facingToken then
				RunService:UnbindFromRenderStep("AzureCameraUpdate");
				u440.Cache.AzureAimRenderToken = nil;
			end;
			if u440.Cache.AzureFacingToken ~= facingToken then
				Attachment:Destroy(); u441:Destroy(); u443:Destroy(); u442:Destroy();
				return;
			end;
			u440.Cache.AzureFacingToken = nil;
			for i, _ in pairs(u440.State.HighlightedCharacters) do
				__pcallMethod("lcl_RemoveHighlightCharacterInReachForGrab", u440, i);
			end;

			TweenService:Create(u443, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
				Value = Vector3.new(0, 0, 0)
			}):Play();
			TweenService:Create(u442, TweenInfo.new(0.3), {
				Value = 1
			}):Play();
			task.delay(0.5, function()              

				u443:Destroy();
				u442:Destroy();
			end);
			RunService:UnbindFromRenderStep("AzureCameraUpdate");
			Attachment:Destroy();
			u441:Destroy();
			u440.Rig:SetAttribute("AzureGrabFacing", nil);
			local humanoid = u440.Rig:FindFirstChildOfClass("Humanoid");
			if humanoid then humanoid.AutoRotate = true end;
		end);
	end;

	function u77.lcl_EndGrabAiming(p445, u446)              
		u446.State.GrabAimingSequence = nil;

	end;

	function u77.lcl_StartGrabAimingBeamEffect(p447, u448)              
		u448.State.GrabAimingBeam = true;
		local Attachment = Instance.new("Attachment");
		local Attachment2 = Instance.new("Attachment");
		local u449 = u448.Config.Instances.TrajectoryBeam:Clone();
		local v450 = u448.Config.Instances.TargetParticle and u448.Config.Instances.TargetParticle:Clone();
		local u451 = u448.Config.Instances.TrajectoryTarget:Clone();
		local Grab = resolveAzureGrabConfig(u448);
		local u452 = RaycastParams.new();
		u452.RespectCanCollide = true;
		u452.CollisionGroup = "Killers";
		u452.FilterType = Enum.RaycastFilterType.Exclude;
		u452.FilterDescendantsInstances = workspace.Players:GetDescendants();
		Attachment2.Parent = workspace.Terrain;
		u449.Parent = workspace.Map.Ingame;

		if v450 then
			v450.Parent = Attachment2;
		end;

		u451.Parent = workspace.Map.Ingame;
		u449.Attachment0 = Attachment;
		u449.Attachment1 = Attachment2;
		local BillboardGui = Instance.new("BillboardGui");
		BillboardGui.Name = "HomingScopeBillboard";
		BillboardGui.Adornee = u451;
		BillboardGui.Size = UDim2.new(2, 0, 2, 0);
		BillboardGui.StudsOffset = Vector3.new(0, 0.5, 0);
		BillboardGui.AlwaysOnTop = true;
		BillboardGui.LightInfluence = 0;
		BillboardGui.Parent = u451;
		local v453 = u448.Config.Instances.HomingScopeEffect:Clone();
		v453.BackgroundTransparency = 1;
		v453.Size = UDim2.new(1, 0, 1, 0);
		v453.Parent = BillboardGui;
		task.spawn(function()              

			while u448.State.GrabAimingBeam ~= nil do
				local v454 = u448.State.GrabbedRoot or u448.Rig.PrimaryPart;



				if not v454 or not v454.Parent then
					break;
				end;

				local Position = v454.CFrame.Position;
				local v455 = workspace.CurrentCamera.CFrame.LookVector * Grab.HookRange;
				local v456 = workspace:Raycast(Position, v455, u452);
				local v457;

				if v456 then
					v457 = v456.Position;
				else
					v457 = Position + v455;
				end;

				local Rotation = CFrame.lookAt(v457, Position).Rotation;
				Attachment.Parent = v454;
				Attachment.CFrame = CFrame.new(0, 0, 0);
				Attachment2.CFrame = CFrame.new(v457) * Rotation;
				u451:PivotTo(CFrame.new(v457) * Rotation);
				task.wait();
			end;

			Attachment:Destroy();
			Attachment2:Destroy();
			u449:Destroy();
			u451:Destroy();
		end);
	end;

	function u77.lcl_EndGrabAimingBeamEffect(p458, u459)              
		u459.State.GrabAimingBeam = nil;
	end;

	function u77.lcl_ClearRemoveAllFlowers(p460, p461)              

		local FlowersGenerated = p461.State.FlowersGenerated;

		if FlowersGenerated == nil then
			return;
		end;

		for i, _ in pairs(FlowersGenerated) do
			u77:cl_UpdateFlowers(p461, i, 0);
		end;
	end;

	function u77.cl_ListenForCrackRoots(p462, u463, u464)              

		local CrackVisualiserOptions = u463.Config.CrackVisualiserOptions;
		local u465 = {};
		local u466 = {};
		local u467 = true;

		for i, v in pairs(u5) do
			if CrackVisualiserOptions[i] == nil then
				CrackVisualiserOptions[i] = v;
			end;
		end;

		local function onChildAdded(p468)              

			if u465[p468] then
				return;
			end;

			u465[p468] = true;
			local DivotSize = CrackVisualiserOptions.DivotSize;

			for i = 0, p468.Size.Z, DivotSize / 2 do
				for i2 = -1, 1, 2 do
					local v469 = DivotSize * getRandomScaleVector(CrackVisualiserOptions.DivotSizeDeviance);
					local Part = Instance.new("Part");
					local v470 = p468.Size.X * CrackVisualiserOptions.WidthMultiplier;
					local v471 = v470 * i2 * 0.75 + Random.new():NextNumber(-v470 * CrackVisualiserOptions.WidthDeviance, v470 * CrackVisualiserOptions.WidthDeviance);
					local v472 = CFrame.new(v471, -CrackVisualiserOptions.DivotDepth, -i + p468.Size.Z / 2);
					local AwayRotation = CrackVisualiserOptions.AwayRotation;
					local AwayRotationDeviance = CrackVisualiserOptions.AwayRotationDeviance;
					local fromAxisAngle = CFrame.fromAxisAngle;
					local v473 = p468.CFrame.RightVector * i2;
					local v474 = Random.new():NextNumber(AwayRotation - AwayRotationDeviance, AwayRotation + AwayRotationDeviance);
					local v475 = fromAxisAngle(v473, (math.rad(v474))) * getRandomRotationCF(CrackVisualiserOptions.RandomRotation);

					if CrackVisualiserOptions.Tweens and CrackVisualiserOptions.TweenConfig then
						Part.CFrame = p468.CFrame * v472 * getRandomRotationCF(360) - p468.CFrame.YVector * 3;
						TweenService:Create(Part, CrackVisualiserOptions.TweenConfig, {
							Size = v469,
							CFrame = p468.CFrame * v472 * v475
						}):Play();
					else
						Part.CFrame = p468.CFrame * v472 * v475;
						Part.Size = v469;
					end;

					Part.CanCollide = false;
					Part.CanQuery = false;
					Part.CanTouch = false;
					Part.Material = p468.Material;
					Part.Color = p468.Color;
					Part.Anchored = true;
					Part.Parent = workspace.Map;
					table.insert(u466, Part);

					if CrackVisualiserOptions.TimeInterval > 0 then
						task.wait(CrackVisualiserOptions.TimeInterval);
					end;

					if not u464.Parent then
						break;
					end;
				end;
			end;
		end;

		u464.ChildAdded:Connect(onChildAdded);

		for _, child in u464:GetChildren() do
			onChildAdded(child);
		end;

		task.spawn(function()              

			local v476 = tostring(u464) .. "SpeedMultiplier";

			while true do
				while true do
					if not u467 then
						return;
					end;

					local Character = u4.Character;

					if (tostring(Character.Parent) ~= "Survivors" and not workspace:GetAttribute("FriendlyFire")) or not Util:IsAlive(Character) then
						break;
					end;

					local SpeedMultipliers = Character:FindFirstChild("SpeedMultipliers");

					if SpeedMultipliers then
						local v477 = OverlapParams.new();
						v477.FilterType = Enum.RaycastFilterType.Include;
						v477.FilterDescendantsInstances = { Character.PrimaryPart };
						local v478 = false;

						for i, _ in pairs(u465) do
							if #workspace:GetPartsInPart(i, v477) > 0 then
								v478 = true;
								break;
							end;
						end;

						if v478 then
							if not SpeedMultipliers:FindFirstChild(v476) then
								Util:CreateSpeedMultiplier(Character, u463.Config.GolemFissure.VictimSpeedMult, v476);
							end;
						elseif SpeedMultipliers:FindFirstChild(v476) then
							SpeedMultipliers:FindFirstChild(v476):Destroy();
						end;

						task.wait(0.016666666666666666);

						if not u467 and SpeedMultipliers:FindFirstChild(v476) then
							SpeedMultipliers:FindFirstChild(v476):Destroy();
						end;
					else
						task.wait();
					end;
				end;

				task.wait();
			end;
		end);
		u464.AncestryChanged:Connect(function()              

			u467 = nil;

			for _, v in ipairs(u466) do
				if CrackVisualiserOptions.Tweens and CrackVisualiserOptions.TweenConfig then
					TweenService:Create(v, CrackVisualiserOptions.TweenConfig, {
						Size = Vector3.new(0, 0, 0)
					}):Play();
					Debris:AddItem(v, 3);
				else
					v:Destroy();
				end;
			end;
		end);
	end;

	function u77.cl_OnHomingStart(p479, p480)              

		if p480.Player == u4 then
			return;
		end;

		__playSound(p480, "GrabWarning", {
			RollOffMaxDistance = 100
		});
		local v481 = p480.Config.Instances.EyeGlintVFX:Clone();
		v481.Parent = p480.Rig.Head;
		v481.VFX:Emit(6);
		game.Debris:AddItem(v481, 2);
		local v482 = p480.Config.Instances.HomingSpotlightOthers:Clone();
		local v483 = {
			Angle = v482.Angle,
			Range = v482.Range,
			Color = v482.Color,
			Brightness = v482.Brightness
		};
		v482.Color = Color3.new(1, 1, 1);
		v482.Range = 0;
		v482.Angle = 0;
		v482.Brightness = 1;
		v482.Parent = p480.Rig.PrimaryPart;
		TweenService:Create(v482, TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), v483):Play();
		p480.Cache = p480.Cache or {};
		p480.Cache.HomeInstances = {
			SpotLight = v482
		};
	end;

	function u77.cl_OnHomingStopped(p484, p485)              

		if p485.Player == u4 then
			return;
		end;

		local v486 = p485.Cache and p485.Cache.HomeInstances and p485.Cache.HomeInstances.SpotLight;

		if not v486 then
			return;
		end;

		TweenService:Create(v486, TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Angle = 0,
			Brightness = 0,
			Range = 0
		}):Play();
		game.Debris:AddItem(v486, 0.9);
		table.clear(p485.Cache.HomeInstances);
		p485.Cache.HomeInstances = nil;
	end;

	function u77.cl_UpdateTentacleTrackingPart(p487, u488, u489)              

		u488.State.GrabbedRoot = u489;
		local PreAnimation = RunService.PreAnimation;

		if u488.UpdateTentacleConnection then
			u488.UpdateTentacleConnection:Disconnect();
			u488.UpdateTentacleConnection = nil;
		end;

		if u488.BezierBoneTracker then
			u488.BezierBoneTracker:Destroy();
			u488.BezierBoneTracker = nil;
		end;

		local v490 = __pcallMethod("getTentacles", u488);

		if not v490 and u3 then
			warn("[Azure]: This Azure has no tentacles!");
		end;

		local v491 = __pcallMethod("getGrabbingTentacle", u488, v490);

		if v491 then
			local v492 = v491;

			while v491 do
				if v491:IsA("Bone") then
					v491.Transform = CFrame.identity;
				end;

				v491 = v491:FindFirstChildOfClass("Bone");
			end;

			v491 = v492;
		end;

		if not (u489 and v491) then
			if u3 then
				warn("[Azure]: Failed to get grabbing tentacle!");
			end;

			return;
		end;

		local Torso = u488.Rig:FindFirstChild("Torso");

		if not Torso then
			if u3 then
				warn("[Azure]: Failed to find Torso for tentacle tracking!");
			end;

			return;
		end;

		local CFrame2 = Torso.CFrame;
		local u493 = os.clock();
		local v494 = {};

		repeat
			table.insert(v494, v491);
			v491 = v491:FindFirstChildOfClass("Bone");
		until not v491;

		local u495 = Torso.Position - CFrame2.LookVector * 0.8 + CFrame2.UpVector * 0.4;
		local u496 = Torso.Position + CFrame2.RightVector * 1 * 7 + CFrame2.UpVector * 7 - CFrame2.LookVector * 4;
		local Position = u489.Position;
		u488.BezierBoneTracker = Util:BezierBoneTracking(v490, v494, u495, u496, Position, 1, 1);
		u488.UpdateTentacleConnection = PreAnimation:Connect(function(p497)              

			if not u488.BezierBoneTracker then
				return;
			end;

			local CFrame3 = Torso.CFrame;
			u495 = Torso.Position - CFrame3.LookVector * 0.8 + CFrame3.UpVector * 0.4;
			u496 = Torso.Position + CFrame3.RightVector * 1 * 7 + CFrame3.UpVector * 7 - CFrame3.LookVector * 4;
			Position = u489.CFrame.Position;
			u488.BezierBoneTracker.StartPoint = u495;
			u488.BezierBoneTracker.ControlPoint = u496;
			u488.BezierBoneTracker.EndPoint = Position;
			local BezierBoneTracker = u488.BezierBoneTracker;
			local v498 = (os.clock() - u493) / 0.1;
			BezierBoneTracker.Time = math.clamp(v498, 0.1, 1);
		end);
		u488.Maid:Add(u488.UpdateTentacleConnection);
		u488.Maid:Add(u488.BezierBoneTracker);
	end;

	function u77.cl_OnThrown(p499, u500, u501)              

		local PrimaryPart = u501.PrimaryPart;

		if not PrimaryPart then
			return;
		end;

		local u502 = u500.Config.Instances.ThrowWindVFX:Clone();
		u502.Parent = workspace.Terrain;
		u500.Cache = u500.Cache or {};
		u500.Cache.TrailVFXInstances = u500.Cache.TrailVFXInstances or {};
		u500.Cache.TrailVFXInstances[u501] = u502;
		u500.Maid:Add(u502);
		task.spawn(function()              

			while u502.Parent and Util:IsAlive(u501) do
				local AssemblyLinearVelocity = PrimaryPart.AssemblyLinearVelocity;
				u502.WorldCFrame = CFrame.new(PrimaryPart.Position, PrimaryPart.Position - (AssemblyLinearVelocity.Magnitude <= 0.01 and Vector3.new(0, 1, 0) or AssemblyLinearVelocity));
				task.wait();
			end;

			if u500.Cache.TrailVFXInstances[u501] then
				local v503 = u500.Cache.TrailVFXInstances[u501];
				u500.Cache.TrailVFXInstances[u501] = nil;
				v503:Destroy();
			end;
		end);
	end;

	function u77.cl_OnThrowEnded(p504, p505, p506)              
		if p505.Cache and (p505.Cache.TrailVFXInstances and p505.Cache.TrailVFXInstances[p506]) then
			local v507 = p505.Cache.TrailVFXInstances[p506];
			p505.Cache.TrailVFXInstances[p506] = nil;
			v507:Destroy();
		end;
	end;

	function u77.cl_CreateConstruct(p508, p509, p510)              

		local _ = p509.Player == u4;
		local Type = p510.Type;

		if p510.UUID and clientDrawnConstructs[p510.UUID] then
			return;
		end;
		p510.Owner = p509.Player;
		local v511 = p509.Config.ClientConstructBehavior[Type];

		if not v511 then
			warn((`[{script:GetFullName()}]: No client construct data for type: {Type}`));

			return;
		end;

		local v512 = p509.Config.ConstructConfigs and p509.Config.ConstructConfigs[Type];

		if not v512 then
			warn((`[{script:GetFullName()}]: No server construct data for type: {Type}`));
		end;

		p510.Model = p509.Config.Instances[`{Type}Model`];

		for i, v in pairs(p509.Config.ClientConstructConfigs[Type]) do
			p510[i] = v;
		end;

		p510.Meta = v512 or {};
		v511.Create(p510);
		if p510.UUID then
			clientDrawnConstructs[p510.UUID] = true;

			local root = p510.Root;
			if typeof(root) == "Instance" then
				local uuid, constructType = p510.UUID, p510.Type;
				root.AncestryChanged:Connect(function(_, parent)
					if not parent and clientDrawnConstructs[uuid] then
						__pcallMethod("cl_DestroyConstruct", p509, { UUID = uuid, Type = constructType });
					end;
				end);
			end;
		end;

		if p509.Player == u4 and (p510.Type == "GroundBulb" or p510.Type == "Vine") then
			p509.State.ConstructCounts = p509.State.ConstructCounts or {};
			p509.State.ConstructCounts[p510.Type] = (p509.State.ConstructCounts[p510.Type] or 0) + 1;
			updateConstructCounters(p509);
		end;

		if p510.Type == "Seeker" and p509.Player == u4 then
			v511.CreateLocalUI(p510.UUID);
			__pcallMethod("lcl_RegisterSeeker", p509, p510);
		end;
	end;

	function u77.cl_ConstructEvent(p513, p514, p515, p516, ...)              

		local Type = p515.Type;
		local v517 = p514.Config.ClientConstructBehavior[Type];

		if not v517 then
			warn((`[{script:GetFullName()}]: No client construct data for type: {Type}`));

			return;
		end;

		local v518 = v517[p516];

		if v518 then
			v518(p515.UUID, ...);
		else
			warn((`[{script:GetFullName()}]: No client construct event for {p516}`));
		end;

		local v519 = p514.Player == u4 and (p515.Type == "Seeker" and (p516 == "OnDetectedChanged" and p514.State.ActiveSeekers[p515.UUID]));

		if v519 then
			v519.Selectable = table.pack(...)[1] > 0;
		end;
	end;

	function u77.cl_DestroyConstruct(p520, p521, p522)              

		local Type = p522.Type;
		local v523 = p521.Config.ClientConstructBehavior[Type];

		if not v523 then
			warn((`[{script:GetFullName()}]: No client construct data for type: {Type}`));

			return;
		end;

		v523.Destroy(p522.UUID);
		if p522.UUID then
			clientDrawnConstructs[p522.UUID] = nil;
		end;

		if p521.Player == u4 and (p522.Type == "GroundBulb" or p522.Type == "Vine") then
			p521.State.ConstructCounts = p521.State.ConstructCounts or {};
			p521.State.ConstructCounts[p522.Type] = math.max((p521.State.ConstructCounts[p522.Type] or 1) - 1, 0);
			updateConstructCounters(p521);
		end;

		if p522.Type == "Seeker" and p521.Player == u4 then
			__pcallMethod("lcl_UnregisterSeeker", p521, p522);
		end;
	end;

	function u77.cl_OnGroundExplode(p524, p525, p526, p527, p528)              

		local v529 = p528 or 1;
		local SavedQualityLevel = UserSettings():GetService("UserGameSettings").SavedQualityLevel;
		local v530;

		if SavedQualityLevel == Enum.SavedQualitySetting.Automatic then
			v530 = 2;
		else
			local v531 = tonumber((3 + SavedQualityLevel.Value) / 13);
			v530 = math.floor(v531);
		end;

		for _ = 1, math.random(1, (math.floor((v530 or 0) / 2) + 1) * v529) do
			local Part = Instance.new("Part");
			local v532 = 2 + Random.new():NextNumber() * 1;
			local v533 = 1.5 + Random.new():NextNumber() * 1.5;
			local v534 = 2 + Random.new():NextNumber() * 1;
			Part.Size = Vector3.new(v532, v533, v534) * (v529 / 2 + 0.5);
			Part.CanCollide = false;
			Part.CanQuery = false;
			Part.CanTouch = false;
			Part.Color = p527.Color;
			Part.Material = p527.Material;
			Part.Transparency = p527.Transparency + 0.1;
			Part.CFrame = CFrame.new(p526);
			local v535 = math.random(-45, 45);
			local v536 = math.random(25, 75);
			Part.AssemblyLinearVelocity = Vector3.new(v535, v536, math.random(-45, 45)) * v529;
			local v537 = math.random(-45, 45);
			local v538 = math.random(-45, 45);
			Part.AssemblyAngularVelocity = Vector3.new(v537, v538, math.random(-45, 45)) * v529;
			Part.Parent = workspace;
			delay(1, function()              

				TweenService:Create(Part, TweenInfo.new(0.5), {
					Transparency = 1
				}):Play();
			end);
			game:GetService("Debris"):AddItem(Part, 2);
		end;
	end;

	function u77.cl_StartRoots(p539, p540)              
		p540.State.RootsFromGolem = {};
	end;

	function u77.cl_GREP(p541, p542, p543, p544, p545)              

		local Part = Instance.new("Part");
		Part.CanCollide = false;
		Part.CanQuery = false;
		Part.CanTouch = false;
		Part.AudioCanCollide = false;
		Part.Anchored = true;
		Part.Transparency = 1;
		Part.Size = p544;
		Part.CFrame = p543;
		local v546 = p542.Config.Instances.RootImages:GetChildren();
		local v547 = v546[math.random(1, #v546)]:Clone();
		v547.Transparency = 1;
		v547.Parent = Part;
		Part.Parent = workspace;
		TweenService:Create(v547, TweenInfo.new(0.3), {
			Transparency = 0
		}):Play();
		table.insert(p542.State.RootsFromGolem, p545 == true and 1 or #p542.State.RootsFromGolem + 1, Part);
	end;

	function u77.cl_HideAllRoots(p548, u549)              

		task.spawn(function()              

			local v550 = table.clone(u549.State.RootsFromGolem);
			u549.State.RootsFromGolem = nil;

			for i = #v550, 1, -1 do
				local v551 = v550[i];
				local v552 = v551 and v551:FindFirstChildOfClass("Decal");

				if v552 then
					TweenService:Create(v552, TweenInfo.new(0.3), {
						Transparency = 1
					}):Play();
				end;

				task.wait(0.016666666666666666);
				Debris:AddItem(v551, 1);
			end;
		end);
	end;

	function u77.cl_AnimateAzureStatue(p553, p554, u555, p556)              

		local v557 = p556 == false and 1 or 0;
		local NumberValue = Instance.new("NumberValue");
		NumberValue.Value = p556 == false and 0 or 1;
		NumberValue:GetPropertyChangedSignal("Value"):Connect(function()              

			u555:ScaleTo((math.max(NumberValue.Value, 0.01)));
		end);

		if p556 == true then
			TweenService:Create(NumberValue, TweenInfo.new(1, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
				Value = v557
			}):Play();

			return;
		end;

		TweenService:Create(NumberValue, TweenInfo.new(1, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			Value = v557
		}):Play();
	end;

	function u77.EnableStomping(p558, p559)              

		assert(p558, "must pass killerInfo as argument");
		local LocalPlayer = Players.LocalPlayer;

		if LocalPlayer ~= p559.Player then
			return;
		end;

		for i, v in pairs(p559.Animations) do
			if i:find("GolemWalk") then
				v.KeyframeReached:Connect(function(p560)              

					if p560 == "Footstep" and not LocalPlayer.Character:GetAttribute("FootstepsMuted") then
						Util:ApplyCameraShake(0.1, 0.2);
					end;
				end);
			elseif i:find("GolemRun") then
				v.KeyframeReached:Connect(function(p561)              

					if p561 == "Footstep" and not LocalPlayer.Character:GetAttribute("FootstepsMuted") then
						Util:ApplyCameraShake(0.2, 0.15);
					end;
				end);
			end;
		end;
	end;
end;

u77.Abilities = {
	Slash = {
		LayoutOrder = 1,
		Name = "Perforating",
		Icon = "rbxassetid://123556520269026",
		KeybindType = "MainAbility",
		Cooldown = 1.8,

		Callback = function(u562, p563)                              

			local Slash = u562.Config.Slash;
			("%*AzureCancel"):format(u562.Player.Name);

			if not RunService:IsServer() then
				if RunService:IsClient() then
					local v564 = p563 == nil and {
						IsGolem = false,
						IgnoreHit = false
					} or p563;

					if v564.IgnoreHit == true then
						return;
					end;

					if v564.IsGolem then
						AnimationSupport.Track(u562, "GolemSlash"):Play(nil, 0.8, nil);

						return;
					end;

					AnimationSupport.Track(u562, "Slash"):Play(0.2);
				end;

				return;
			end;

			if u562.State.GrabReadyToFire then
				u562.State.GrabFireRequested = true;

				return {
					IsGolem = false,
					IgnoreHit = true
				};
			end;

			if u562.State.GrabbingFlag == true then
				if u562.State.ThrowRequest == false then
					u562.State.ThrowRequest = true;
				end;

				return {
					IsGolem = false,
					IgnoreHit = true
				};
			end;

			if u562.State.ControllingGolem then
				if u562.State.GolemSpawnLocked then
					return nil;
				end;

				u562.AbilitiesDisabled = true;
				u562.State.ControllingGolem.Cooldowns.Slash = os.clock();
				local Empowered = u562.State.ControllingGolem.Empowered;
				local u565;

				if u562.State.ControllingGolem.Empowered then
					u565 = u562.Config.SmashPower;
				else
					u565 = u562.Config.Smash;
				end;

				local v566 = Util:CopyTable({
					Volume = 0.35,
					PlaybackSpeed = 0.975 + Random.new():NextNumber() * 0.04999999999999993
				});
				v566.Parent = u562.Rig.PrimaryPart;
				Sounds:Play(u562.Config.Sounds[Empowered and "SmashPowerWindup" or "SmashPower"], v566);
				u562:SetCooldownOf("Slash", u565.Cooldown or 2);
				task.delay(u565.Windup + u565.Linger + 0.25, function()              

					u562.AbilitiesDisabled = false;
				end);
				spawn(function()              

					local GolemTimeFlag = u562.Cache.GolemTimeFlag;

					if cWait(u565.Windup, function()              

						return u562.Cache.GolemTimeFlag ~= GolemTimeFlag;
					end) then
						u562.AbilitiesDisabled = false;

						return;
					end;

					local v567 = u562;
					local v568 = Util:CopyTable({
						Volume = 0.35,
						PlaybackSpeed = 0.975 + Random.new():NextNumber() * 0.04999999999999993
					});
					v568.Parent = v567.Rig.PrimaryPart;
					Sounds:Play(v567.Config.Sounds[Empowered and "SmashPower" or "Smash"], v568);
					Hitboxes:CreateMainAbilityHitbox(u562.Player, {
						Size = Vector3.new(8, 4, 10),
						Knockback = 2,
						HitMultiple = true,
						ExecuteOnKill = false,
						CFrameOffset = CFrame.new(0, 0, -3.5),

						Damage = function(p569)                            

							local v570 = Statuses:PlayerHasStatus(p569, "Atropa");
							local v571;

							if v570 then
								v571 = (v570.Level or 1) * u565.DamagePerAtropa;
								v570.Data = v570.Data or {};
								v570.Data.IsHit = true;
								Statuses:RemoveStatus(p569, "Atropa");
							else
								v571 = 0;
							end;

							return u565.Damage + v571;
						end,

						Time = u565.Linger,
						DeathProfile = {
							KillEffects = {
								Split = true
							}
						},
						AbilityType = u77.Abilities.Slash.KeybindType,
						Connections = {
							Hit = function(p572, p573)                         

								Util:CreateSpeedMultiplier(p572, 1.5, "HitSpeedBonus", 1.25);

								if p573 then
									u562:PlayVoiceline("SmashHit", {
										Priority = 2
									});
									local v574 = u562;
									local v575 = Util:CopyTable({
										Volume = 0.35,
										PlaybackSpeed = 0.975 + Random.new():NextNumber() * 0.04999999999999993
									});
									v575.Parent = v574.Rig.PrimaryPart;
									Sounds:Play(v574.Config.Sounds.SmashHit, v575);
								end;

								__pcallMethod("sv_OnMeleeHit", u562, p572);
							end
						}
					});
				end);

				return {
					IsGolem = true,
					IgnoreHit = false
				};
			end;

			u562.AbilitiesDisabled = true;
			local v576 = Util:CopyTable({
				Volume = 0.35,
				PlaybackSpeed = 0.975 + Random.new():NextNumber() * 0.04999999999999993
			});
			v576.Parent = u562.Rig.PrimaryPart;
			Sounds:Play(u562.Config.Sounds.SlashWindup, v576);
			spawn(function()              

				local u577 = u562;

				if cWait(Slash.Windup, function()              

					return (not Util:IsAlive(u577.Rig) or u577.Rig:GetAttribute("Stunned")) and true or false;
				end) then
					u562.AbilitiesDisabled = false;

					return;
				end;

				local v578 = u562;
				local v579 = Util:CopyTable({
					Volume = 0.35,
					PlaybackSpeed = 0.975 + Random.new():NextNumber() * 0.04999999999999993
				});
				v579.Parent = v578.Rig.PrimaryPart;
				Sounds:Play(v578.Config.Sounds.Slash, v579);
				os.clock();
				Hitboxes:CreateMainAbilityHitbox(u562.Player, {
					Size = Vector3.new(4.5, 6, 8.5),
					Knockback = 2,
					HitMultiple = false,
					ExecuteOnKill = true,

					CFrameOffset = function()                                  
						return CFrame.new(0, 0, -2.25);
					end,

					Damage = function(p580)                            

						local v581 = Statuses:PlayerHasStatus(p580, "Atropa");
						local v582;

						if v581 then
							v582 = (v581.Level or 1) * Slash.DamagePerAtropa;
							v581.Data = v581.Data or {};
							v581.Data.IsHit = true;
							__pcallMethod("sv_IncreaseOblation", u562, (math.ceil(v581.Level or 1)));
							Statuses:RemoveStatus(p580, "Atropa");
						else
							v582 = 0;
						end;

						return Slash.Damage + v582;
					end,

					Time = Slash.Linger,
					AbilityType = u77.Abilities.Slash.KeybindType,
					Connections = {
						Hit = function(p583, p584)                         

							Util:CreateSpeedMultiplier(p583, 1.5, "HitSpeedBonus", 1.25);

							if p584 then
								u562:PlayVoiceline("StabHit", {
									Priority = 2
								});
								local v585 = u562;
								local v586 = Util:CopyTable({
									Volume = 0.35,
									PlaybackSpeed = 0.975 + Random.new():NextNumber() * 0.04999999999999993
								});
								v586.Parent = v585.Rig.PrimaryPart;
								Sounds:Play(v585.Config.Sounds.SlashHit, v586);
							end;

							__pcallMethod("sv_OnMeleeHit", u562, p583);
						end
					}
				});
				task.delay(Slash.Endlag, function()              

					u562.AbilitiesDisabled = false;
				end);
			end);
		end
	},
	Grab = {
		LayoutOrder = 4,
		Icon = "rbxassetid://115907381502841",
		KeybindType = "AltAbility3",
		Cooldown = 1,
		Name = "Enstrangle",

		Callback = function(u587, p588)                              

			local Grab = resolveAzureGrabConfig(u587);

			if not u2 then
				return;
			end;

			if u587.State.GrabbingFlag == true then
				if u587.State.ThrowRequest == false then
					u587.State.ThrowRequest = "Cancel";
				end;

				return;
			end;

			if u587.State.GrabWindingUp then
				u587.State.GrabCancelRequested = true;

				return;
			end;

			if u587.State.ControllingGolem then
				return nil;
			end;

			u587.AbilitiesDisabled = false;
			u587.DisabledAbilities = {
				Slash = true,
				Sow = true,
				Blossom = true,
				Unravel = true
			};
			u587.State.GrabWindingUp = true;
			u587.State.GrabCancelRequested = false;
			u587.State.GrabFireRequested = false;
			u587.State.GrabReadyToFire = false;
			u587.State.MousePosition = nil;
			u587.State.LastMouseUpdate = nil;
			u587:PCallLocal("SetGrabSprintDisabled", true);
			u587:PCallLocal("SetGrabStaminaRegenReduction", true);
			u587:PCallLocal("SetGrabAbilityLocks", true, true);

			local function setAzureWindupTransparency(p589)              

				for _, descendant in ipairs(u587.Rig:GetDescendants()) do
					if descendant:IsA("BasePart") or descendant:IsA("Decal") then
						if p589 ~= 0 and descendant:GetAttribute("OGWindupTransparency") == nil then
							descendant:SetAttribute("OGWindupTransparency", descendant.Transparency);
						end;

						if p589 == 0 then
							local v590 = descendant:GetAttribute("OGWindupTransparency");

							if v590 ~= nil then
								descendant.Transparency = v590;
								descendant:SetAttribute("OGWindupTransparency", nil);
							end;
						else
							local v591 = descendant:GetAttribute("OGWindupTransparency") or 0;
							descendant.Transparency = math.max(v591, p589);
						end;
					end;
				end;
			end;

			setAzureWindupTransparency(0.5);
			u587:PCallLocal("StartGrabAiming");
			u587:PCallLocal("StartGrabAimingBeamEffect");
			local v592 = Util:CopyTable({
				Volume = 0.35,
				PlaybackSpeed = 0.975 + Random.new():NextNumber() * 0.04999999999999993
			});
			v592.Parent = u587.Rig.PrimaryPart;
			Sounds:Play(u587.Config.Sounds.SlashWindup, v592);
			local v593 = AnimationSupport.Load(Util, u587.Rig, u587.Config.Animations.GrabWindup, false, "GrabWindup");
			local u594 = AnimationSupport.Load(Util, u587.Rig, u587.Config.Animations.GrabShootFailed, false, "GrabShootFailed");
			local u595 = AnimationSupport.Load(Util, u587.Rig, u587.Config.Animations.GrabShoot, false, "GrabShoot");
			v593:Play();

			local function grabInterrupted()              

				return u587.State.GrabCancelRequested and true or ((not Util:IsAlive(u587.Rig) or u587.Rig:GetAttribute("Stunned")) and true or false);
			end;

			local v596 = os.clock();

			while os.clock() - v596 < Grab.Windup and (not u587.State.GrabCancelRequested and (Util:IsAlive(u587.Rig) and not u587.Rig:GetAttribute("Stunned"))) do
				task.wait();
			end;

			if u587.State.GrabCancelRequested and true or ((not Util:IsAlive(u587.Rig) or u587.Rig:GetAttribute("Stunned")) and true or false) then
				local GrabCancelRequested = u587.State.GrabCancelRequested;
				u587.AbilitiesDisabled = false;
				u587.DisabledAbilities = {};
				u587.State.GrabWindingUp = false;
				setAzureWindupTransparency(0);
				u587:PCallLocal("EndGrabAiming");
				u587:PCallLocal("EndGrabAimingBeamEffect");
				v593:Stop();
				u595:Stop();
				u594:Stop();

				u587:PCallLocal("SetGrabSprintDisabled", false);
				u587:PCallLocal("SetGrabStaminaRegenReduction", false);
				u587:PCallLocal("SetGrabAbilityLocks", false);
				if GrabCancelRequested then
					u587:SetCooldownOf("Grab", Grab.CooldownCancel or Grab.CooldownMiss);

					return;
				end;

				__pcallMethod("sv_MissGrab", u587);

				return;
			end;

			u587.State.GrabReadyToFire = true;
			u587:PCallLocal("SetGrabAbilityLocks", true, false);
			u587.DisabledAbilities = {
				Sow = true,
				Blossom = true,
				Unravel = true
			};
			local v597 = AnimationSupport.Load(Util, u587.Rig, u587.Config.Animations.GrabWindupIdle, false, "GrabWindupIdle");
			v593:Stop();
			v597.Looped = true;
			v597:Play();

			while not u587.State.GrabFireRequested and (not u587.State.GrabCancelRequested and (Util:IsAlive(u587.Rig) and not u587.Rig:GetAttribute("Stunned"))) do
				local root = u587.Rig.PrimaryPart;
				if not root then break end;
				local velocity = root.AssemblyLinearVelocity;
				local moving = Vector3.new(velocity.X, 0, velocity.Z).Magnitude > 0.5;
				v597:AdjustWeight(moving and 0 or 1, 0.1);
				task.wait();
			end;

			v597:Stop();
			u587.State.GrabReadyToFire = false;

			if u587.State.GrabCancelRequested and true or ((not Util:IsAlive(u587.Rig) or u587.Rig:GetAttribute("Stunned")) and true or false) then
				local GrabCancelRequested = u587.State.GrabCancelRequested;
				u587.AbilitiesDisabled = false;
				u587.DisabledAbilities = {};
				u587.State.GrabWindingUp = false;
				setAzureWindupTransparency(0);
				u587:PCallLocal("EndGrabAiming");
				u587:PCallLocal("EndGrabAimingBeamEffect");
				v593:Stop();
				v597:Stop();
				u595:Stop();
				u594:Stop();

				u587:PCallLocal("SetGrabSprintDisabled", false);
				u587:PCallLocal("SetGrabStaminaRegenReduction", false);
				u587:PCallLocal("SetGrabAbilityLocks", false);
				if GrabCancelRequested then
					u587:SetCooldownOf("Grab", Grab.CooldownCancel or Grab.CooldownMiss);

					return;
				end;

				__pcallMethod("sv_MissGrab", u587);

				return;
			end;

			u587.State.GrabWindingUp = false;
			u587.AbilitiesDisabled = true;
			setAzureWindupTransparency(0);
			u587:PCallLocal("EndGrabAiming");
			u587:PCallLocal("EndGrabAimingBeamEffect");
			v593:Stop();
			u595:Play();
			local v598 = Util:CopyTable({
				Volume = 0.35,
				PlaybackSpeed = 0.975 + Random.new():NextNumber() * 0.04999999999999993
			});
			v598.Parent = u587.Rig.PrimaryPart;
			Sounds:Play(u587.Config.Sounds.Slash, v598);
			local v599 = Grab.ProjectileLifetime or Grab.Linger;
			local v600 = Grab.ProjectileHitboxSize or Vector3.new(1.5, 1.5, 4);
			local v601 = Grab.ProjectileStartOffset or 2;
			local v602 = math.max((Grab.ProjectileRange or (Grab.HookRange or 15)) - v601 - v600.Z / 2, 0);
			local v603 = Grab.ProjectileSpeed or v602 / math.max(v599, 0.05);
			local v604 = ReplicatedStorage.Assets.Instances.Nothingburger:Clone();
			local u605 = false;
			local u606 = nil;

			for _, v in ipairs({ v604, table.unpack(v604:GetDescendants()) }) do
				if v:IsA("BasePart") then
					v.Transparency = 1;
					v.CanCollide = false;
					v.CanQuery = false;
					v.CanTouch = false;
				end;
			end;

			local v607 = RaycastParams.new();
			v607.RespectCanCollide = true;
			v607.CollisionGroup = "Killers";
			v607.FilterType = Enum.RaycastFilterType.Exclude;
			v607.FilterDescendantsInstances = { workspace.Players, v604 };
			local aimDirection = u587.State.MousePosition;
			if typeof(aimDirection) ~= "Vector3" or aimDirection.Magnitude < 0.001
				or aimDirection.Magnitude ~= aimDirection.Magnitude or aimDirection.Magnitude == math.huge then
				aimDirection = u587:GetPivot().LookVector;
			end;
			aimDirection = aimDirection.Unit;
			local launchPosition = u587:GetPivot().Position + aimDirection * v601;
			u606 = Projectiles.new({
				Owner = u587.Player,
				Lifetime = v599,
				InitialCFrame = CFrame.lookAt(launchPosition, launchPosition + aimDirection),
				InitialVelocity = aimDirection * v603,
				Model = v604,
				CastParams = v607,
				HitboxConfig = {
					Damage = Grab.HitDamage,
					Knockback = 0,
					HitMultiple = false,
					PredictVelocity = false,
					ExecuteOnKill = false,
					Size = v600,
					Time = v599,
					AbilityType = u77.Abilities.Grab.KeybindType,
					Connections = {
						Hit = function(p608, p609)                         

							if u605 or p608 == u587.Rig then
								return;
							end;

							u605 = true;

							if p609 then
								u587:PlayVoiceline("StabHit", {
									Priority = 2
								});
								local v610 = u587;
								local v611 = Util:CopyTable({
									Volume = 0.35,
									PlaybackSpeed = 0.975 + Random.new():NextNumber() * 0.04999999999999993
								});
								v611.Parent = v610.Rig.PrimaryPart;
								Sounds:Play(v610.Config.Sounds.SlashHit, v611);
							end;

							u594:Destroy();
							u595:Stop();
							u606:Destroy();
							__pcallMethod("sv_GrabSurvivor", u587, p608);
						end
					}
				},
				Callbacks = {
					HitOther = function(p612)                              
						p612:Destroy();
					end,

					Ended = function()                           

						if u605 then
							return;
						end;

						u605 = true;
						u595:Stop();
						u594:Play();
						__pcallMethod("sv_MissGrab", u587);
						u587.AbilitiesDisabled = false;
					end
				}
			});
			u606:Launch();
		end
	},
	Sow = {
		LayoutOrder = 2,
		Name = "Seeker Bulb",
		Icon = "rbxassetid://109787679155717",
		KeybindType = "AltAbility1",
		Cooldown = 12,

		Callback = function(u613, p614)                              

			if u2 then
				local Sow = u613.Config.Sow;

				if not u613.State.ControllingGolem then
					u613:PlayVoiceline("Seeker", {
						Priority = 2
					});
					u613.AbilitiesDisabled = true;
					spawn(function()              

						Util:CreateSpeedMultiplier(u613.Rig, 0.6, "PlacingBuilding", Sow.Windup + Sow.Endlag - 0.1, true);
						local u615 = u613;
						local v616 = cWait(Sow.Windup, function()              

							return (not Util:IsAlive(u615.Rig) or u615.Rig:GetAttribute("Stunned")) and true or false;
						end);
						local v617 = u613;
						local v618 = Util:CopyTable({
							Volume = 0.35,
							PlaybackSpeed = 0.975 + Random.new():NextNumber() * 0.04999999999999993
						});
						v618.Parent = v617.Rig.PrimaryPart;
						Sounds:Play(v617.Config.Sounds.SowWindup, v618);

						if v616 then
							u613.AbilitiesDisabled = false;

							return;
						end;

						__pcallMethod("sv_DecreaseOblation", u613, 0);
						local v619 = u613;
						local v620 = Util:CopyTable({
							Volume = 0.35,
							PlaybackSpeed = 0.975 + Random.new():NextNumber() * 0.04999999999999993
						});
						v620.Parent = v619.Rig.PrimaryPart;
						Sounds:Play(v619.Config.Sounds.Sow, v620);
						local v621 = RaycastParams.new();
						v621.FilterType = Enum.RaycastFilterType.Exclude;
						v621.FilterDescendantsInstances = { workspace.Players };
						v621.CollisionGroup = "Killers";
						v621.RespectCanCollide = true;
						local v622 = u613:GetPivot();
						local Position = v622.Position;
						local LookVector = v622.LookVector;
						local v623 = Vector3.new(LookVector.X, 0, LookVector.Z).Unit * Sow.Range;
						local v624 = workspace:Raycast(Position, v623, v621) or workspace:Raycast(Position + v623, Vector3.new(-0, -20, -0), v621);

						if v624 then
							v622 = CFrame.new(v624.Position, v624.Position + v624.Normal);
						end;

						if __pcallMethod("sv_IsNearPlantSpawn", u613, v622.Position) then
							u613:PCallLocal("DenyBuild", nil, "Move away from spawn to put your traps.");
							u613:SetCooldownOf("Sow", 0);
							u613.AbilitiesDisabled = false;
							return;
						end;

						local v625 = __pcallMethod("sv_GetBlockingConstruct", u613, v622.Position);

						if v625 then
							v625:FireAllClients("DenyBuild");
							u613:PCallLocal("DenyBuild", v625.UUID);
							u613:SetCooldownOf("Sow", 0);
							u613.AbilitiesDisabled = false;
							__pcallMethod("sv_IncreaseOblation", u613, 0);

							return;
						end;

						__cullConstruct(u613, "GroundBulb", (getConstructLimit(u613, "GroundBulb")));
						local v626 = __pcallMethod("sv_CreateConstruct", u613, "GroundBulb", {
							CFrame = v622
						});

						local function createHitVFX(p627)              

							local v628 = u613.Config.Instances.BulbHitVFX:Clone();
							v628.Parent = workspace.Terrain;
							v628.CFrame = p627;
							game.Debris:AddItem(v628, 1);
							Util:EmitParticles(v628);
						end;

						v626:AddCallback("OnSurfaceHit", function(p629)              

							local v630 = CFrame.new(p629.Position);
							local v631 = u613.Config.Instances.BulbHitVFX:Clone();
							v631.Parent = workspace.Terrain;
							v631.CFrame = v630;
							game.Debris:AddItem(v631, 1);
							Util:EmitParticles(v631);
						end, "VFX");
						v626:AddCallback("OnCharacterHit", function(p632)              

							local _ = tostring(p632.Parent) == "Survivors";
							local v633 = p632:GetPivot();
							local v634 = u613.Config.Instances.BulbHitVFX:Clone();
							v634.Parent = workspace.Terrain;
							v634.CFrame = v633;
							game.Debris:AddItem(v634, 1);
							Util:EmitParticles(v634);
						end, "VFX");
						local u635 = u613;
						cWait(Sow.Endlag, function()              

							return (not Util:IsAlive(u635.Rig) or u635.Rig:GetAttribute("Stunned")) and true or false;
						end);
						u613.AbilitiesDisabled = false;
					end);

					return "Plant";
				end;

				if u613.State.GolemSpawnLocked then
					return "Cancel";
				end;

				u613.AbilitiesDisabled = true;
				local GolemTimeFlag = u613.Cache.GolemTimeFlag;
				local GolemShockwave = u613.Config.GolemShockwave;
				u613.State.ControllingGolem.Cooldowns.Sow = os.clock();
				u613:SetCooldownOf("Sow", GolemShockwave.Cooldown);
				spawn(function()              

					u613:PlayVoiceline("ShockwaveGolem", {
						Priority = 2
					});
					local v636 = u613;
					local v637 = Util:CopyTable({
						Volume = 0.35,
						PlaybackSpeed = 0.975 + Random.new():NextNumber() * 0.04999999999999993
					});
					v637.Parent = v636.Rig.PrimaryPart;
					Sounds:Play(v636.Config.Sounds.ShockwaveWindup, v637);
					local v638 = Util:CreateSpeedMultiplier(u613.Player, GolemShockwave.Lunge, "GolemShockwaveLunge");
					TweenService:Create(v638, TweenInfo.new(GolemShockwave.Windup, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						Value = 0.1
					}):Play();

					if cWait(GolemShockwave.Windup, function()              

						return u613.Cache.GolemTimeFlag ~= GolemTimeFlag;
					end) then
						TweenService:Create(v638, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
							Value = 1
						}):Play();
						Debris:AddItem(v638, 0.2);
						u613.AbilitiesDisabled = false;

						return;
					end;

					TweenService:Create(v638, TweenInfo.new(0.9, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
						Value = 1
					}):Play();
					Debris:AddItem(v638, 1);
					Hitboxes:CreateHitbox(u613.Player, {
						Time = 0.05,
						Knockback = false,
						HitMultiple = true,
						ExecuteOnKill = false,
						Size = Vector3.new(1, 1, 1) * GolemShockwave.Radius * 2,
						Shape = Enum.PartType.Ball,

						Damage = function(p639)                            

							local v640 = Util:GetActor(p639);
							local v641;

							if v640 and v640.GetPivot then
								v641 = v640:GetPivot();
							else
								v641 = p639:GetPivot();
							end;

							local v642 = 1 - (u613:GetPivot().Position - v641.Position).Magnitude / GolemShockwave.Radius;
							local v643 = TweenService:GetValue(math.clamp(v642, 0, 1), Enum.EasingStyle.Cubic, Enum.EasingDirection.Out);

							return GolemShockwave.Damage * v643;
						end,

						CFrameOffset = CFrame.new(0, -2, 0),
						DeathProfile = {
							KillEffects = {
								Flatten = true
							}
						},
						Connections = {
							Hit = function(p644)                         

								local v645 = Util:GetActor(p644);
								local v646;

								if v645 and v645.GetPivot then
									v646 = v645:GetPivot();
								else
									v646 = p644:GetPivot();
								end;

								local Unit = (v646.Position - u613:GetPivot().Position).Unit;
								local v647 = (Vector3.new(Unit.X, 0, Unit.Z) + Vector3.new(0, 0.6, 0)) * GolemShockwave.KnockbackPower;

								if tostring(p644.Parent) == "Survivors" then
									Actors:IncrementActorStats(u613.Player, {
										Action = "Hit Survivor with Shockwave",
										RewardType = "EasyKillerAction"
									});
								else
									Actors:IncrementActorStats(u613.Player, {
										Action = "Hit Killer with Shockwave",
										RewardType = "EasyKillerAction"
									});
								end;

								p644.PrimaryPart.AssemblyLinearVelocity = v647;
								Ragdolls.AddProfile(p644, {
									Velocity = v647
								});
								Ragdolls.EnableRagdoll(p644, 0.8);
							end
						}
					});
					local v648 = u613;
					local v649 = Util:CopyTable({
						Volume = 0.35,
						PlaybackSpeed = 0.975 + Random.new():NextNumber() * 0.04999999999999993
					});
					v649.Parent = v648.Rig.PrimaryPart;
					Sounds:Play(v648.Config.Sounds.Shockwave, v649);
					delay(GolemShockwave.Endlag, function()              

						u613.AbilitiesDisabled = false;
					end);
				end);

				return "Golem";
			end;

			if p614 ~= "Golem" then
				if p614 == "Plant" then
					AnimationSupport.Track(u613, "Sow"):Play();
				end;

				return;
			end;

			AnimationSupport.Track(u613, "GolemShockwave"):Play(nil, nil, 1.5);
			local GolemShockwave = u613.Config.GolemShockwave;
			freezeStamina("GolemShockwave", GolemShockwave.Windup + 0.9);
			task.delay(GolemShockwave.Windup, function()              

				Util:ApplyCameraShake(0.2, GolemShockwave.Endlag);
			end);
		end
	},
	Blossom = {
		LayoutOrder = 3,
		Name = "Stigmatize",
		Icon = "rbxassetid://117545955019424",
		KeybindType = "AltAbility2",
		Cooldown = 15,

		Callback = function(u650, p651)                              

			local Blossom = u650.Config.Blossom;

			if u2 then
				if not u650.State.ControllingGolem then
					u650:PlayVoiceline("Stigmatize", {
						Priority = 2
					});
					__pcallMethod("sv_DecreaseOblation", u650, 0);
					u650.AbilitiesDisabled = true;
					local v652 = Util:CopyTable({
						Volume = 0.35,
						PlaybackSpeed = 0.975 + Random.new():NextNumber() * 0.04999999999999993
					});
					v652.Parent = u650.Rig.PrimaryPart;
					Sounds:Play(u650.Config.Sounds.Blossom, v652);
					spawn(function()              

						Util:CreateSpeedMultiplier(u650.Rig, 0.2, "PlacingBuilding", Blossom.Windup + Blossom.Endlag - 0.1, true);
						local u653 = u650;

						if cWait(Blossom.Windup, function()              

							return (not Util:IsAlive(u653.Rig) or u653.Rig:GetAttribute("Stunned")) and true or false;
						end) then
							u650.AbilitiesDisabled = false;

							return;
						end;

						local v654 = RaycastParams.new();
						v654.FilterType = Enum.RaycastFilterType.Exclude;
						v654.FilterDescendantsInstances = { workspace.Players };
						v654.CollisionGroup = "Killers";
						v654.RespectCanCollide = true;
						local Position = u650:GetPivot().Position;
						local v655 = workspace:Raycast(u650:GetPivot().Position, Vector3.new(0, -9, 0), v654);
						local v656;

						if v655 then
							v656 = v655.Position;
						else
							v656 = Position + Vector3.new(-0, -20, -0);
						end;

						local v657 = CFrame.new(v656) * u650:GetPivot().Rotation;
						if __pcallMethod("sv_IsNearPlantSpawn", u650, v657.Position) then
							u650:PCallLocal("DenyBuild", nil, "Move away from spawn to put your traps.");
							u650:SetCooldownOf("Blossom", 0);
							u650.AbilitiesDisabled = false;
							return;
						end;

						local v658 = __pcallMethod("sv_GetBlockingConstruct", u650, v657.Position);

						if v658 then
							u650:PCallLocal("DenyBuild", v658.UUID);
							u650:SetCooldownOf("Blossom", 0);
							u650.AbilitiesDisabled = false;

							return;
						end;

						__cullConstruct(u650, "Vine", (getConstructLimit(u650, "Vine")));
						__pcallMethod("sv_CreateConstruct", u650, "Vine", {
							CFrame = v657
						}):AddCallback("OnCharacterHit", function(p659)              

							if tostring(p659.Parent) == "Survivors" then
								Actors:IncrementActorStats(u650.Player, {
									Action = "Trapped Survivor with Vine",
									RewardType = "RegularKillerAction"
								});
								u650:PlayVoiceline("StigmatizeGrab", {
									Priority = 2
								});
							else
								Actors:IncrementActorStats(u650.Player, {
									Action = "Trapped Killer with Vine",
									RewardType = "RegularKillerAction"
								});
								u650:PlayVoiceline("StigmatizeGrab", {
									Priority = 2
								});
							end;
						end, "Reward");
						delay(Blossom.Endlag, function()              

							u650.AbilitiesDisabled = false;
						end);
					end);

					return "Plant";
				end;

				if u650.State.GolemSpawnLocked then
					return "Cancel";
				end;

				u650.AbilitiesDisabled = true;
				local GolemTimeFlag = u650.Cache.GolemTimeFlag;
				local GolemFissure = u650.Config.GolemFissure;
				u650.State.ControllingGolem.Cooldowns.Blossom = os.clock();
				u650:SetCooldownOf("Blossom", GolemFissure.Cooldown);
				Util:CreateSpeedMultiplier(u650.Rig, 0.01, "Stimpy", GolemFissure.Windup + GolemFissure.Endlag - 0.1, true);
				u650:PlayVoiceline("StompGolem", {
					Priority = 2
				});
				spawn(function()              

					__playSound(u650, "FissureWindup", {
						RollOffMaxDistance = 100
					});

					if cWait(GolemFissure.Windup, function()              

						return u650.Cache.GolemTimeFlag ~= GolemTimeFlag;
					end) then
						u650.AbilitiesDisabled = false;

						return;
					end;

					local u660 = RaycastParams.new();
					u660.FilterType = Enum.RaycastFilterType.Exclude;
					u660.FilterDescendantsInstances = { workspace.Players };
					u660.CollisionGroup = "Killers";
					u660.RespectCanCollide = true;
					local Model = Instance.new("Model", workspace.Map.Ingame);
					Model.Name = "GolemCracks" .. game.HttpService:GenerateGUID(false);
					u650.Maid:Add(Model);
					game.Debris:AddItem(Model, GolemFissure.CrackLifetime);
					u650:PCallAllClients("ListenForCrackRoots", Model);
					local u661 = 0;
					local LookVector = u650:GetPivot().LookVector;
					local u662 = Vector3.new(LookVector.X, 0, LookVector.Z);
					local Position = u650:GetPivot().Position;
					local u663 = Position;
					local u664 = GolemFissure.GroundProbeHeight or 6;
					local u665 = GolemFissure.GroundProbeDepth or 18;
					spawn(function()              

						__playSound(u650, "FissureStomp", {
							RollOffMaxDistance = 250
						});
						local v666 = 0;
						local u667 = {};

						while u661 < GolemFissure.Distance do
							v666 = v666 + 1;
							local v668;

							if u661 <= 0 then
								v668 = Position;
							else
								v668 = u663 + u662 * GolemFissure.StudInterval;
							end;

							local v669 = v668 + Vector3.new(0, u664, 0);
							local v670 = workspace:Raycast(v669, Vector3.new(0, -(u664 + u665), 0), u660);

							if not v670 then
								return;
							end;

							__playSound(u650, "FissureExplosion", {
								Position = v670.Position,
								PlaybackSpeed = 0.9 + Random.new():NextNumber() * 0.20000000000000007
							});
							u650:PCallAllClients("OnGroundExplode", v670.Position, v670.Instance);
							Hitboxes:CreateHitbox(u650.Player, {
								Time = 0.04,
								Knockback = false,
								HitMultiple = true,
								ExecuteOnKill = false,
								Size = Vector3.new(1, 1, 1) * GolemFissure.HitboxSize,
								Shape = Enum.PartType.Ball,

								Damage = function(p671)                            

									if u667[p671] then
										return 0;
									end;

									u667[p671] = true;

									if tostring(p671.Parent) == "Survivors" then
										Actors:IncrementActorStats(u650.Player, {
											Action = "Hit Survivor with Fissure",
											RewardType = "EasyKillerAction"
										});
									else
										Actors:IncrementActorStats(u650.Player, {
											Action = "Hit Killer with Fissure",
											RewardType = "EasyKillerAction"
										});
									end;

									return GolemFissure.Damage;
								end,

								CFrame = CFrame.new(v670.Position),
								CastPoint = v670.Position + Vector3.new(0, 0.5, 0),
								Connections = {
									Hit = function(p672)                         

										local v673 = Util:GetActor(p672);
										local v674;

										if v673 and v673.GetPivot then
											v674 = v673:GetPivot();
										else
											v674 = p672:GetPivot();
										end;

										local Unit = (v674.Position - u650:GetPivot().Position).Unit;
										local v675 = (Vector3.new(Unit.X, 0, Unit.Z) + Vector3.new(0, 0.6, 0)) * GolemFissure.KnockbackPower;
										p672.PrimaryPart.AssemblyLinearVelocity = v675;
										Ragdolls.AddProfile(p672, {
											Velocity = v675
										});
										Ragdolls.EnableRagdoll(p672, 1);
									end
								}
							});

							if u663 then
								local v676 = u663 - v670.Position;
								local Instance2 = v670.Instance;
								os.clock();
								local Part = Instance.new("Part");
								Part.CanCollide = false;
								Part.Anchored = true;
								Part.Transparency = u3 and 0.5 or 1;
								Part.CFrame = CFrame.lookAt(v670.Position + v676 / 2, v670.Position + v676);
								Part.Size = Vector3.new(GolemFissure.CrackWidth, GolemFissure.CrackHeight, v676.Magnitude);
								Part.CollisionGroup = "Killers";
								Part.Name = tostring(v666);
								Part.Color = Instance2.Color;
								Part.Material = Instance2.Material;
								Part.Parent = Model;
							end;

							u661 = u661 + GolemFissure.StudInterval;
							u663 = v670.Position;
							task.wait(GolemFissure.TimeInterval);
						end;
					end);
					delay(GolemFissure.Endlag, function()              

						u650.AbilitiesDisabled = false;
					end);
				end);

				return "Golem";
			end;

			if p651 ~= "Plant" then
				if p651 == "Golem" then
					AnimationSupport.Track(u650, "GolemFissure"):Play(nil, nil, 0.8125);
					local GolemFissure = u650.Config.GolemFissure;
					task.delay(GolemFissure.Windup, function()              

						Util:ApplyCameraShake(0.1, GolemFissure.Endlag);
					end);
				end;

				return;
			end;

			AnimationSupport.Track(u650, "Stigmatize"):Play(0.025, nil, 1.55);
			Util:ToggleSprinting("Blossom", false, Blossom.Windup + Blossom.Endlag);
		end
	},
	Unravel = {
		LayoutOrder = 5,
		Name = "Inflorescence",
		Icon = "rbxassetid://109425766636886",
		KeybindType = "AltAbility4",

		Callback = function(u677, p678)                              

			if not u2 then
				return;
			end;

			if u677.State.GolemSpawnLocked then
				return "Cancel";
			end;

			if u677.State.ControllingGolem then
				if u677.State.ControllingGolem.Empowered then
					return "Cancel";
				end;

				__pcallMethod("sv_ReleaseGolem", u677, u677.State.ControllingGolem);

				return "Release";
			end;

			local _, v679 = next(u677.State.Golems);

			if v679 then
				u677:PlayVoiceline("SwapGolem", {
					Priority = 2
				});
				__pcallMethod("sv_ControlGolem", u677, v679, "Control");

				return;
			end;

			if u677.Config.Oblation.Max > u677.State.Oblation then
				u677:SetCooldownOf("Unravel", 1);

				return "Cancel";
			end;

			Actors:IncrementActorStats(u677.Player, {
				Action = "Summoned a Golem",
				RewardType = "RegularKillerAction"
			});
			local v680 = u677:GetPivot();
			local v681 = u677.Config.Oblation.Max - u677.State.Oblation + 1;
			__pcallMethod("sv_DecreaseOblation", u677, u677.Config.Oblation.Max);
			__playSound(u677, "GolemSpawned", {
				Position = v680.Position
			});
			local v682 = u677.Config.Golem.BaseLifetime + u677.Config.Golem.LifetimePerOblation * v681;
			local u683 = sv_Golem.new(u677, v680, v682);
			local UUID = u683.UUID;
			u683.Lifetime = v682;
			u683.RemainingLifetime = v682;
			u683.LifetimeToken = 0;
			u677:PCallLocal("CreateGolem", {
				UUID = UUID,
				CFrame = v680,
				Lifetime = v682,
				RemainingLifetime = v682
			});
			u677:PCallAllClients("StartRoots");
			u677.Maid:Add(u683);
			u683.Empowered = false;
			u677.State.Golems[UUID] = u683;
			u683:AddCallback("OnDestroyed", function()              

				__pcallMethod("sv_ReleaseGolem", u677, u683);

				if u683.Statue then
					__pcallMethod("sv_DestroyGolemStatue", u677, u683.Statue);
				end;

				u677.State.Golems[UUID] = nil;
				u677:PCallLocal("DestroyGolem", UUID);
				u677:PCallAllClients("HideAllRoots");
			end, "ServerOnDestroyed");
			__pcallMethod("sv_ControlGolem", u677, u683, "Newborn");
		end
	}
};

function u77.Created(p684, u685)
 resolveAzureGrabConfig(u685);
 AnimationSupport.Prepare(u685);

	local Config = u685.Config;
	u685.Maid = Maid.new();
	u685.Meta = {};
	u685.Instances = {};
	u685.State = {};
	u685.State.Oblation = Config.Oblation.Start;
	u685.State.OblationTickFlag = 0;
	u685.State.OblationProgress = 0;
	u685.State.KilledSurvivors = 0;
	u685.State.Constructs = {};
	u685.State.ConstructCreationIndex = 0;
	u685.State.Golems = {};
	u685.State.FlowersGenerated = {};
	u685.NetworkConnections = {};
	u685.ConnectionDictionary = {};
	u685.Rig:SetAttribute("Oblation", u685.State.Oblation);

	if not u2 then
		local v686 = u685.Player == u4;
		local u687 = nil;
		u685.NetworkConnections.PCallAllClients = { `{u685.Player.Name}PCallAllClients`, "REMOTE_EVENT" };
		Network:SetConnection(`{u685.Player.Name}PCallAllClients`, "REMOTE_EVENT", function(p688, ...)              

			__pcallMethod("cl_" .. p688, u685, ...);
		end);


		local function catchUpConstruct(model)
			if not (model and model:IsA("Model")) or model:GetAttribute("ConstructOwner") ~= u685.Player.UserId then
				return;
			end;
			local uuid, constructType = model:GetAttribute("ConstructUUID"), model:GetAttribute("ConstructType");
			local cframe = model:GetAttribute("ConstructCFrame");
			if not (uuid and constructType and typeof(cframe) == "CFrame") or clientDrawnConstructs[uuid] or model:GetAttribute("ConstructDead") then
				return;
			end;
			local data = { UUID = uuid, Type = constructType, Root = model.PrimaryPart, CFrame = cframe };
			__pcallMethod("cl_CreateConstruct", u685, data);
			local level = model:GetAttribute("ConstructPowerLevel");
			if clientDrawnConstructs[uuid] and level then
				__pcallMethod("cl_ConstructEvent", u685, { UUID = uuid, Type = constructType }, "SetPowerLevel", level, model:GetAttribute("ConstructSleepTimer") or 0);
			end;
		end;
		local ingame = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Ingame");
		if ingame then
			task.defer(function()
				for _, child in ingame:GetChildren() do
					catchUpConstruct(child);
				end;
			end);

			local addedConnection = ingame.ChildAdded:Connect(function(child)
				if child:IsA("Model") then
					task.delay(1.5, function()
						if child.Parent then
							catchUpConstruct(child);
						end;
					end);
				end;
			end);
			u685.Rig.Destroying:Once(function()
				addedConnection:Disconnect();
			end);
		end;
		u685.NetworkConnections.BeginQTE = { `{u685.Player.Name}AzureBeginQTE`, "REMOTE_EVENT" };
		Network:SetConnection(`{u685.Player.Name}AzureBeginQTE`, "REMOTE_EVENT", function(u689)              

			local Behavior = require(u685.Config.Instances.ClientQTEModules.Behavior);
			local UI = require(u685.Config.Instances.ClientQTEModules.UI);
			u687 = Behavior.new(UI, u689);
			u687:AddCallback("OnDestroyed", function(p690)              

				u687 = nil;
				Network:FireServerConnection(`{u685.Player.Name}EndAzureQTE`, "REMOTE_EVENT", u689, p690);
			end, "FireServer");
		end);
		u685.NetworkConnections.ServerForceEndQTE = { `{u685.Player.Name}AzureForceQTEStop`, "REMOTE_EVENT" };
		Network:SetConnection(`{u685.Player.Name}AzureForceQTEStop`, "REMOTE_EVENT", function(p691)              

			if u687 and p691 == u687.WorkingOn then
				u687:Destroy();
			end;
		end);
		u685.NetworkConnections.awdangit = { `{u685.Player.Name}AzureQTEWarning`, "REMOTE_EVENT" };
		Network:SetConnection(`{u685.Player.Name}AzureQTEWarning`, "REMOTE_EVENT", function(p692)              

			Util:CreateWarning("son", p692);
		end);

		if v686 then
			u685.State.ActiveSeekers = {};
			u685.State.ConstructCounts = {
				GroundBulb = 0,
				Vine = 0
			};
			u685.NetworkConnections.PCallLocal = { `{u685.Player.Name}PCallLocal`, "REMOTE_EVENT" };
			Network:SetConnection(`{u685.Player.Name}PCallLocal`, "REMOTE_EVENT", function(p693, ...)              

				__pcallMethod("lcl_" .. p693, u685, ...);
			end);
			u685.NetworkConnections.GetHover = { `{u685.Player.Name}AzureGetHover`, "REMOTE_FUNCTION" };
			Network:SetConnection(`{u685.Player.Name}AzureGetHover`, "REMOTE_FUNCTION", function()              

				return u685.State.SelectedGolem and { u685.State.SelectedGolem, "Golem" } or (u685.State.SelectedSeeker and { u685.State.SelectedSeeker, "Seeker" } or nil);
			end);
			local u694 = u4:GetAttribute("Device") or "PC";
			local CurrentCamera = workspace.CurrentCamera;
			local u695 = u4:GetMouse();
			local u696 = u685.Config.Instances.OhMyGodBruh:Clone();
			u696.Parent = u4.PlayerGui.TemporaryUI;
			u685.Maid:Add(u696);

			if Device:GetPlayerDevice() == "Mobile" then
				u696.Position = UDim2.fromScale(0.9, 0.075);
			end;

			u685.Cache.OblationAbilityLocks = u685.Cache.OblationAbilityLocks or {};

			local function setOblationLock(p697, p698)              

				if p698 == u685.Cache.OblationAbilityLocks[p697] then
					return;
				end;

				u685.Cache.OblationAbilityLocks[p697] = p698;
				Util:ToggleLockForAbilityIcon(p697, "Oblation", p698);
			end;

			local u699 = -1;
			local NumberValue = Instance.new("NumberValue");
			NumberValue.Value = 0;
			u685.ConnectionDictionary.LocalTick = RunService.Heartbeat:Connect(function(p700)              

				local v701 = 1 - 0.95 ^ (p700 * 60);
				local v702 = u685.Rig:GetAttribute("Oblation") or 0;
				local Start = u685.Config.Oblation.Start;
				local v703 = math.clamp((v702 - Start) / (u685.Config.Oblation.Max - Start), 0, 1);

				if v702 ~= u699 then
					TweenService:Create(u696.Fill, TweenInfo.new(0.3), {
						Size = UDim2.fromScale(1.5, v703 * 0.9 + 0.35)
					}):Play();
					u699 = v702;
				end;

				if math.abs(v703 - 1) <= 0.001 then
					NumberValue.Value = math.lerp(NumberValue.Value, 90, v701);
				elseif math.abs(v703) <= 0.001 then
					NumberValue.Value = math.lerp(NumberValue.Value, 0, v701);
				end;

				local Spawn = u696.Spawn;
				Spawn.Rotation = Spawn.Rotation + NumberValue.Value * p700;
				local Spawn2 = u696.Spawn;
				Spawn2.Rotation = Spawn2.Rotation % 360;

				if u685.State.ControllingGolem then
					u685.State.LastCameraCFrame = CurrentCamera.CFrame;
					u685.State.LastCameraFocus = CurrentCamera.Focus;
				end;

				local v704;

				if u694 == "PC" then
					v704 = CurrentCamera:ScreenPointToRay(u695.X, u695.Y);
				else
					v704 = Ray.new(CurrentCamera.CFrame.Position, CurrentCamera.CFrame.LookVector);
				end;

				local v705 = Ray.new(v704.Origin, v704.Direction.Unit * 450);
				local v706 = RaycastParams.new();
				v706.CollisionGroup = "Killers";
				v706.FilterDescendantsInstances = {};
				v706.FilterType = Enum.RaycastFilterType.Include;

				if u685.State.ControllingGolem then
					u685.State.SelectedSeeker = nil;
					u685.State.SelectedGolem = nil;
				else
					for _, v in pairs(u685.State.ActiveSeekers) do
						if v.HoverHitbox and (v.HoverHitbox:GetAttribute("UUID") and v.Selectable) then
							v706:AddToFilter(v.HoverHitbox);
						end;
					end;

					local v707 = workspace:Spherecast(v705.Origin, 7, v705.Direction, v706);

					if v707 and v707.Instance then
						local v708 = v707.Instance:GetAttribute("UUID");
						u685.State.SelectedSeeker = v708;
						u685.State.SelectedGolem = nil;
					else
						u685.State.SelectedSeeker = nil;
						u685.State.SelectedGolem = nil;
					end;
				end;

				for i, _ in pairs(u685.State.ActiveSeekers) do
					__pcallMethod("cl_ConstructEvent", u685, {
						Type = "Seeker",
						UUID = i
					}, "UpdateSelectionStatus", i == u685.State.SelectedSeeker);
				end;

				for _, v in pairs(u685.State.Golems) do
					local Highlight = v.Highlight;

					if Highlight and v.Statue then
						__pcallMethod("lcl_ToggleStatueHighlight", u685, Highlight, false);
					end;
				end;

				local v709 = u685.State.ControllingGolem ~= nil;
				local v710 = next(u685.State.Golems) ~= nil;
				u685.Behavior.Abilities.Unravel.Name = v709 and "Burrowing" or (v710 and "Control" or (u685.State.SelectedSeeker and "Create" or "Inflorescence"));
				local v711 = not (v709 or v710) and v702 < 15;

				if v711 == u685.Cache.OblationAbilityLocks.Unravel then
					return;
				end;

				u685.Cache.OblationAbilityLocks.Unravel = v711;
				Util:ToggleLockForAbilityIcon("Unravel", "Oblation", v711);
			end);
			Network:SetConnection("SetTrackingMousePosition", "REMOTE_EVENT", function(p712)              

				u685.State.TrackingMousePosition = not p712 or false;

				if p712 then
					TweenService:Create(Util:CreateFOVMultiplier(u4, 1.2, "AzureAiming", 0.7), TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						Value = 1
					}):Play();
					u685.State.MousePosition = p712;
					RunService:UnbindFromRenderStep("MouseTracking");

					return;
				end;

				spawn(function()              

					__pcallMethod("lcl_StartMouseTracking", u685);
				end);
				RunService:BindToRenderStep("MouseTracking", 1, function()              

					local CFrame2 = workspace.CurrentCamera.CFrame;
					local Unit = CFrame2.LookVector;
					u685.State.MousePosition = Unit;
					Network:FireServerConnection(`{u685.Player.Name}AzureUpdateMouse`, "REMOTE_EVENT", Unit);
				end);
				TweenService:Create(Util:CreateFOVMultiplier(u4, 1, "AzureAiming"), TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					Value = 1.2
				}):Play();
			end);
		end;

		return;
	end;

	task.spawn(function()              















	end);

	function u685.PCallAllClients(p713, p714, ...)              

		Network:FireAllClientConnection(`{u685.Player.Name}PCallAllClients`, "REMOTE_EVENT", p714, ...);
	end;

	function u685.PCallLocal(p715, p716, ...)              

		Network:FireClientConnection(u685.Player, `{u685.Player.Name}PCallLocal`, "REMOTE_EVENT", p716, ...);
	end;

	u685.NetworkConnections.EndAzureQTE = { `{u685.Player.Name}EndAzureQTE`, "REMOTE_EVENT" };
	Network:SetConnection(`{u685.Player.Name}EndAzureQTE`, "REMOTE_EVENT", function(p719, p720, p721)              

		local v722;

		if p719 then
			v722 = p719.Character;
		else
			v722 = p719;
		end;

		if not v722 or (not Util:IsAlive(v722) or (tostring(v722.Parent) ~= "Survivors")) then
			return;
		end;

		local v723 = nil;

		for _, v in pairs(u685.State.Constructs) do
			if p720 == v.Root then
				v723 = v;
				break;
			end;
		end;

		if not v723 or p719 ~= v723.WorkedOnBy then
			return;
		end;

		if Util:GetActor(p719) and p721 then
			Actors:IncrementActorStats(p719, {
				Action = "Disarmed an Azure trap",
				Money = 5,
				EXP = 5,
				RewardType = nil
			});
		end;

		v723:GiveCharacterAtropa(p719.Character, u685.Config.AtropaOnDefuse);
		v723:EndQTE(p721);
	end);
	u685.NetworkConnections.UpdateMouse = { `{u685.Player.Name}AzureUpdateMouse`, "REMOTE_EVENT" };
	Network:SetConnection(`{u685.Player.Name}AzureUpdateMouse`, "REMOTE_EVENT", function(p724, p725)              

		if p724 ~= u685.Player then
			p724:Kick();

			return;
		end;

		if typeof(p725) ~= "Vector3" or p725.X ~= p725.X or p725.Y ~= p725.Y
			or p725.Z ~= p725.Z or p725.Magnitude == math.huge then
			return;
		end;

		local v726 = (p725.Magnitude <= 0.001 or math.isinf(p725.Magnitude)) and Vector3.new(0, 0, 1) or p725;
		u685.State.MousePosition = v726;
		u685.State.LastMouseUpdate = os.clock();
	end);
	u685.NetworkConnections.Grab = { `{u685.Player.Name}AzureRequestGrab`, "REMOTE_FUNCTION" };
	Network:SetConnection(`{u685.Player.Name}AzureRequestGrab`, "REMOTE_FUNCTION", function(p727, u728)              

		if p727 ~= u685.Player then
			return false;
		end;

		if not u685.State.HomingActive then
			return false;
		end;

		if not Hitboxes:LineOfSight(u685.Rig, u728) then
			return false;
		end;

		u685.AbilitiesDisabled = true;
		u685.DisabledAbilities = {};
		spawn(function()              

			u685.State.HomingActive = false;
			__pcallMethod("sv_GrabSurvivor", u685, u728);
		end);

		return true;
	end);
	u685.State.RootDistances = { {
			Distance = 0,
			Origin = nil
		}, {
			Distance = 3.3333333333333335,
			Origin = nil
		}, {
			Distance = 6.666666666666667,
			Origin = nil
		} };
	local u729 = Vector3.new(0, 0, 0);
	u685.Maid:Add(RunService.Heartbeat:Connect(function()              

		local v730 = {};
		local v731 = u685.Rig.PrimaryPart.Position + Vector3.new(0, -u685.Rig.PrimaryPart.Size.Y / 2 * 3, 0);
		local Magnitude = (v731 - u729).Magnitude;

		if Magnitude <= 0.001 then
			return;
		end;

		for _, v in pairs(u685.State.RootDistances) do
			if v.Origin == nil then
				v.Origin = v731;
			end;

			local v732 = v.Distance + Magnitude;

			if v732 >= 10 then
				v730[#v730 + 1] = { v.Origin, v731 };
				v732 = v732 % 10;
				v.Origin = v731;
			end;

			v.Distance = v732;
		end;

		u729 = v731;

		if not u685.State.ControllingGolem then
			return;
		end;

		for _, v in pairs(v730) do
			local v733 = v[1] - v[2];
			u685:PCallAllClients("GREP", CFrame.new(v[2], v[2] + (v733.Magnitude <= 0.001 and Vector3.new(0, 0, 1) or v733.Unit)) * CFrame.new((math.random() - 0.5) / 0.5 * 5 / 4, 0, -5), Vector3.new(5, 0, 10), false);
		end;
	end));
end;

function u77.Destroyed(p734, p735)              

	if p735.Destroyed then
		return;
	end;

	p735.Destroyed = true;
	if u2 and p735.State and p735.State.AzureGrabCleanup then
		p735.State.AzureGrabCleanup();
	end;

	if u1 then
		__pcallMethod("lcl_SetGolemSpawnAbilityLocks", p735, false);
		__pcallMethod("lcl_ResetGrabVisuals", p735);
		__pcallMethod("lcl_SetGrabSprintDisabled", p735, false);
		p735.LookFlag = nil;
		if p735.State then p735.State.GrabAimingSequence = nil end;
		if p735.Rig then p735.Rig:SetAttribute("AzureGrabFacing", nil) end;
		__pcallMethod("lcl_SetGrabAbilityLocks", p735, false);
		__pcallMethod("lcl_SetGrabStaminaRegenReduction", p735, false);
		__pcallMethod("lcl_ClearRemoveAllFlowers", p735);
	end;

	p735.Maid:Destroy();

	for i, v in p735.ConnectionDictionary do
		v:Disconnect();
		p735.NetworkConnections[i] = nil;
	end;

	for i, v in p735.NetworkConnections do
		Network:RemoveConnection(v[1], v[2]);
		p735.NetworkConnections[i] = nil;
	end;

	for _, v in p735.Instances do
		if typeof(v) == "table" then
			for _, v2 in v do
				if v2 and v2.Parent then
					v2:Destroy();
				end;
			end;
		else
			v:Destroy();
		end;
	end;
end;

function u77.OnIntroduction(p736, u737, p738, u739)              

	local KillerCutsceneBackground = workspace.Misc:WaitForChild("KillerCutsceneBackground", 3);
	local CurrentCamera = workspace.CurrentCamera;

	local function __initialize()              

		Lighting:SetCustomLighting(u737.Config.Instances.VictoryLighting);
		Players.LocalPlayer:SetAttribute("FOVMultipliersDisabled", true);
		Util:PlayDummyCutsceneAnimations(u737, u739, "Introduction");

		if not CurrentCamera then
			return;
		end;

		CurrentCamera.FieldOfView = 18;
	end;

	workspace.Misc:WaitForChild(u737.Player.Name .. "CameraRig", 3);
	local v740 = u737.Config.Instances.Spawn:Clone();
	v740.PrimaryPart.Anchored = true;
	v740:PivotTo(KillerCutsceneBackground.PrimaryPart.CFrame);
	v740.Parent = KillerCutsceneBackground;
	game.Debris:AddItem(v740, 15);
	local v741 = AnimationSupport.Load(Util, v740, (u737.Config.Animations.Introduction or {}).SpawnRig, true);
	v741:Play(0);
	local v742 = os.clock();
	v741.TimePosition = os.clock() - v742;
	spawn(__initialize);
	task.delay(u739, function()              

		Players.LocalPlayer:SetAttribute("FOVMultipliersDisabled", nil);
		Lighting:SetAsCurrentLighting();
	end);
	task.wait(1.2666666666666666);
	local MassInfectionShockwaveVignette = u737.Config.Instances.MassInfectionShockwaveVignette;
	local u743;

	if MassInfectionShockwaveVignette then
		u743 = MassInfectionShockwaveVignette:Clone();
	else
		u743 = MassInfectionShockwaveVignette;
	end;

	u743.Name = "AZUREQUICKSHINE";
	u743.Parent = u737.Player.PlayerGui;
	local u744 = u743:FindFirstChildOfClass("ImageLabel");

	if MassInfectionShockwaveVignette then
		u744.ImageTransparency = 1;
		TweenService:Create(u744, TweenInfo.new(0.1, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut), {
			ImageTransparency = 0.8
		}):Play();
		task.delay(0.2, function()              

			TweenService:Create(u744, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut), {
				ImageTransparency = 1
			}):Play();
		end);
		task.delay(1, function()              

			u743:Destroy();
		end);
	end;

	task.wait(1.5333333333333334);
	local MassInfectionShockwaveVignette2 = u737.Config.Instances.MassInfectionShockwaveVignette;
	local u745;

	if MassInfectionShockwaveVignette2 then
		u745 = MassInfectionShockwaveVignette2:Clone();
	else
		u745 = MassInfectionShockwaveVignette2;
	end;

	u745.Name = "AZUREQUICKSHINE";
	u745.Parent = u737.Player.PlayerGui;
	local u746 = u745:FindFirstChildOfClass("ImageLabel");

	if MassInfectionShockwaveVignette2 then
		u746.ImageTransparency = 1;
		TweenService:Create(u746, TweenInfo.new(0.1, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut), {
			ImageTransparency = 0.8
		}):Play();
		task.delay(0.2, function()              

			TweenService:Create(u746, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut), {
				ImageTransparency = 1
			}):Play();
		end);
		task.delay(1, function()              

			u745:Destroy();
		end);
	end;
end;

function u77.OnVictory(p747, p748, u749, u750, u751)              

	if p748 ~= "Start" then
		if p748 == "End" then
			Players.LocalPlayer:SetAttribute("FOVMultipliersDisabled", nil);
			Lighting:SetAsCurrentLighting();
			local AzureStabCC = u4.PlayerGui:FindFirstChild("AzureStabCC");

			if AzureStabCC then
				AzureStabCC:Destroy();
			end;

			local AzureStabCC2 = u4.PlayerGui:FindFirstChild("AzureStabCC2");

			if AzureStabCC2 then
				AzureStabCC2:Destroy();
			end;
		end;

		return;
	end;

	Players.LocalPlayer:SetAttribute("FOVMultipliersDisabled", true);
	local CurrentCamera = workspace.CurrentCamera;
	CurrentCamera.FieldOfView = 40;
	Lighting:SetCustomLighting(u749.Config.Instances.VictoryLighting);
	task.spawn(function()              

		local v752 = os.clock();
		local KillerCutsceneBackground = workspace.Misc:WaitForChild("KillerCutsceneBackground", 5);
		local v753 = u749.Config.Instances.GhostKnife:Clone();
		v753.Parent = u750.PrimaryPart;
		v753.GhostWeld.Part0 = u750["Right Arm"];
		game.Debris:AddItem(v753, 15);
		local v754 = u749.Config.Instances.Golem:Clone();
		u749.Config.Instances.AnimController:Clone().Parent = v754;
		v754.PrimaryPart.Anchored = true;
		v754:PivotTo(KillerCutsceneBackground.PrimaryPart.CFrame);
		v754.Parent = KillerCutsceneBackground;
		v754:PivotTo(v754:GetPivot() * CFrame.new(0, -3, 0) * CFrame.Angles(0, 0, 0));
		game.Debris:AddItem(v754, 15);
		local v755 = AnimationSupport.Load(Util, v754, "rbxassetid://117770287268670", true);
		v755:Play(0);
		v755.TimePosition = os.clock() - v752;
		TweenService:Create(CurrentCamera, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
			FieldOfView = 55
		}):Play();
		task.wait(4.25);
		local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect", game.Lighting);
		ColorCorrectionEffect.Name = "AzureStabCC";
		ColorCorrectionEffect.Contrast = 0;
		ColorCorrectionEffect.Brightness = 0;
		ColorCorrectionEffect.Saturation = 0;
		ColorCorrectionEffect.TintColor = Color3.new(1, 1, 1);
		TweenService:Create(ColorCorrectionEffect, TweenInfo.new(2.5833333333333335, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
			Brightness = 0,
			Contrast = 1,
			Saturation = 4,
			TintColor = Color3.new(0.72549, 0, 0.92549)
		}):Play();
		game.Debris:AddItem(ColorCorrectionEffect, u751);
		TweenService:Create(CurrentCamera, TweenInfo.new(2.5833333333333335, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
			FieldOfView = 65
		}):Play();
		task.wait(2.5833333333333335);
		local ColorCorrectionEffect2 = Instance.new("ColorCorrectionEffect", game.Lighting);
		ColorCorrectionEffect2.Name = "AzureStabCC2";
		ColorCorrectionEffect2.Contrast = 0;
		ColorCorrectionEffect2.Brightness = 0;
		ColorCorrectionEffect2.TintColor = Color3.new(1, 1, 1);
		game.Debris:AddItem(ColorCorrectionEffect2, u751);
		TweenService:Create(ColorCorrectionEffect2, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
			Brightness = -2,
			Contrast = 1,
			Saturation = 3,
			TintColor = Color3.new(0, 0, 0)
		}):Play();
	end);
end;

function u77.OnInflictedDamage(p756, p757, p758)              

	__pcallMethod("sv_AddOblationProgress", p756, p758 * p756.Config.Oblation.BuildPerDamage);
end;

function u77.OnKill(p759, p760, p761)              
	if p760.Parent == workspace.Players.Survivors or workspace:GetAttribute("FriendlyFire") then
		local State = p759.State;
		State.KilledSurvivors = State.KilledSurvivors + 1;
	end;
end;

function u77.OnExecution(p762, p763, u764)              

	if not p763.Rig then
		return;
	end;

	if u764.Name ~= "TwoTime" then
		local u765 = p763.Rig.PrimaryPart.CFrame.LookVector * 33;
		delay(2.783333333333333, function()              

			Ragdolls.AddProfile(u764, {
				Velocity = u765,
				KillEffects = {
					Explode = true
				}
			});
			local v766 = u764:FindFirstChildOfClass("Humanoid");

			if v766 then
				v766.BreakJointsOnDeath = false;
				v766.Health = 0;
			end;
		end);

		return;
	end;

	local MassInfectionShockwaveVignette = p763.Config.Instances.MassInfectionShockwaveVignette;
	local u767;

	if MassInfectionShockwaveVignette then
		u767 = MassInfectionShockwaveVignette:Clone();
	else
		u767 = MassInfectionShockwaveVignette;
	end;

	u767.Name = "AZUREQUICKSHINE1";
	u767.Parent = p763.Player.PlayerGui;
	local u768 = u767:FindFirstChildOfClass("ImageLabel");
	u768.ImageTransparency = 1;
	u764:FindFirstChild("GhostFire"):FindFirstChild("GhostfireBlade").Transparency = 0;
	delay(1.3333333333333333, function()              

		if MassInfectionShockwaveVignette then
			TweenService:Create(u768, TweenInfo.new(0.1, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut), {
				ImageTransparency = 0.9
			}):Play();
			task.delay(0.2, function()              

				TweenService:Create(u768, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
					ImageTransparency = 1
				}):Play();
			end);
		end;
	end);
	delay(2.65, function()              

		if MassInfectionShockwaveVignette then
			u768.ImageTransparency = 1;
			TweenService:Create(u768, TweenInfo.new(0.1, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut), {
				ImageTransparency = 0.9
			}):Play();
			task.delay(0.2, function()              

				TweenService:Create(u768, TweenInfo.new(0.75, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
					ImageTransparency = 1
				}):Play();
			end);
			task.delay(1, function()              

				u767:Destroy();
			end);
		end;

		local v769 = u764:FindFirstChildOfClass("Humanoid");

		if v769 then
			v769.Health = 0.01;
		end;
	end);
	delay(3.216666666666667, function()              

		Ragdolls.AddProfile(u764, {
			Velocity = Vector3.new(0, 0, 0)
		});
		local v770 = u764:FindFirstChildOfClass("Humanoid");

		if v770 then
			v770.BreakJointsOnDeath = false;
			v770.Health = 0;
		end;
	end);
end;

return u77;]========]},
{path=[========[
ReplicatedStorage/Assets/Killers/Azure/Behavior/GrabConfigDefaults]========],before=false,after="1616:4dabca51:2601f86c",source=[========[
local defaults = {
 Windup = 1, Linger = 0.2, Endlag = 0.5,
 HookRange = 60, HookSpeed = 270, PullTime = 0.8, HookHitboxSize = 4,
 ProjectileHitboxSize = Vector3.new(5, 5.5, 6),
 MissSlowness = 0.3, MissSlownessDuration = 1,
 CooldownCancel = 5, CooldownMiss = 20, CooldownSuccess = 20,
 KnockbackPower = 100, RagdollDuration = 1.2, BlastRadius = 20,
 Damage = 5, ThrowVelocity = 70, GravityCoefficient = 0.425,
 HitDamage = 10, CloseThrowDistance = 20,
 ThrowHelpless = 2, CloseThrowHelpless = 4, PlantTriggerDuration = 1.5,
 SuccessAnimationTimeout = 8, ThrowAnimationTimeout = 8, HoldMaxDuration = 1.5,
}
local positive = {
 HookRange = true, HookSpeed = true, PullTime = true, HookHitboxSize = true,
 SuccessAnimationTimeout = true, ThrowAnimationTimeout = true,
}
local function finite(value)
 return type(value) == "number" and value == value and value > -math.huge and value < math.huge
end
return function(actor)
 assert(type(actor) == "table" and type(actor.Config) == "table", "Azure actor Config is missing")
 local existing = actor.Config.Grab
 local grab = {}
 if type(existing) == "table" then
  for key, value in pairs(existing) do grab[key] = value end
 end
 for key, fallback in pairs(defaults) do
  local value = grab[key]
  if type(fallback) == "number" then
   if not finite(value) or value < 0 or positive[key] and value <= 0 then grab[key] = fallback end
  elseif typeof(value) ~= "Vector3" or not finite(value.X) or not finite(value.Y) or not finite(value.Z)
   or value.X <= 0 or value.Y <= 0 or value.Z <= 0 then
   grab[key] = fallback
  end
 end
 actor.Config.Grab = grab
 return grab
end
]========]},
{path=[========[
ReplicatedStorage/Assets/Killers/Azure/Behavior/OptionalAnimations]========],before=false,after="6222:829f59f0:02883aef",source=[========[
local Support = {}
local durations = {GrabWindup=1, GrabShoot=.2, GrabShootFailed=.5, GrabShootSuccess=.45,
 GrabVictimSuccess=.45, GrabThrow=.3, GrabVictimThrow=.3, GolemStateEnter=1, GolemStateExit=1,
 GolemSpawn=4.8, WitherStartup=.4, Despawn=.4}
local function signal()
 local listeners = {}
 local event = {}
 function event:Connect(callback)
  local connection = {Connected=true}
  function connection:Disconnect() self.Connected=false; listeners[self]=nil end
  listeners[connection]=callback
  return connection
 end
 function event:Once(callback)
  local connection
  connection=self:Connect(function(...) connection:Disconnect();callback(...) end)
  return connection
 end
 function event:Wait()
  local thread=coroutine.running()
  self:Once(function(...) task.spawn(thread, ...) end)
  return coroutine.yield()
 end
 function event:Fire(...)
  local pending={}
  for connection,callback in pairs(listeners) do pending[connection]=callback end
  for connection,callback in pairs(pending) do if connection.Connected then task.spawn(callback, ...) end end
 end
 function event:Destroy() for connection in pairs(listeners) do connection:Disconnect() end end
 return event
end
local function read(track,key)
 if not track then return nil end
 local ok,value=pcall(function()return track[key]end)
 return ok and value or nil
end
local function invoke(track,key,...)
 if not track then return end
 local args=table.pack(...)
 pcall(function()track[key](track,table.unpack(args,1,args.n))end)
end
local function wrap(real,name)
 if type(real)=="table" and real.AzureOptionalTrack then return real end
 local state={AzureOptionalTrack=true,Name=name or "Optional",Looped=read(real,"Looped") or false,
  IsPlaying=false,Speed=1,TimePosition=0,WeightCurrent=1,WeightTarget=1}
 if not real and name and (name:match("Idle$") or name:match("Walk$") or name:match("Run$") or name:match("Loop$") or name=="GrabVictimHooked") then state.Looped=true end
 local fallback=durations[name] or .35
 local generation,destroyed=0,false
 local stopped,ended,keyframes=signal(),signal(),signal()
 local markers,connections={},{}
 local methods,proxy={},nil
 local function finish(stopReal)
  if not state.IsPlaying then return end
  state.IsPlaying=false;generation+=1
  if stopReal then invoke(real,"Stop",0) end
  stopped:Fire();ended:Fire()
 end
 if real then
  for _,key in {"Stopped","Ended"} do
   local event=read(real,key)
   if event then table.insert(connections,event:Connect(function()finish(false)end)) end
  end
 end
 function methods:Play(fade,weight,speed)
  if destroyed then return end
  generation+=1
  local token=generation
  state.IsPlaying=true;state.Speed=speed or state.Speed;state.TimePosition=0
  invoke(real,"Play",fade,weight,speed)
  local began=os.clock()
  local function poll()
   if destroyed or generation~=token or not state.IsPlaying or state.Looped then return end
   local length=read(real,"Length") or 0
   local elapsed=os.clock()-began
   -- Failed/denied assets remain length zero. Never wait for Util's 25-second preload timeout.
   local duration=length>0 and length or fallback
   if elapsed>=math.min(duration/math.max(.01,math.abs(state.Speed))+.05,30) then finish(true)
   else task.delay(.05,poll) end
  end
  if not state.Looped then task.delay(.05,poll) end
 end
 function methods:Stop(fade) invoke(real,"Stop",fade);finish(false) end
 function methods:AdjustSpeed(speed) state.Speed=speed;invoke(real,"AdjustSpeed",speed) end
 function methods:AdjustWeight(weight,fade) state.WeightCurrent=weight;state.WeightTarget=weight;invoke(real,"AdjustWeight",weight,fade) end
 function methods:GetMarkerReachedSignal(marker)
  if real then local ok,event=pcall(function()return real:GetMarkerReachedSignal(marker)end);if ok and event then return event end end
  if not markers[marker] then markers[marker]=signal() end
  return markers[marker]
 end
 function methods:Destroy()
  if destroyed then return end
  destroyed=true;generation+=1;self:Stop(0)
  for _,connection in connections do connection:Disconnect() end
  stopped:Destroy();ended:Destroy();keyframes:Destroy()
  for _,event in pairs(markers) do event:Destroy() end
  invoke(real,"Destroy")
 end
 proxy=setmetatable({}, {
  __index=function(_,key)
   if methods[key] then return methods[key] end
   if key=="Stopped" then return stopped elseif key=="Ended" then return ended elseif key=="KeyframeReached" then return read(real,key) or keyframes end
   if key=="Length" then local length=read(real,"Length");return length and length>0 and length or fallback end
   if state[key]~=nil then return state[key] end
   return read(real,key)
  end,
  __newindex=function(_,key,value)
   state[key]=value
   if real then pcall(function()real[key]=value end) end
  end,
 })
 return proxy
end
function Support.LoadAnimator(animator,id,name)
 local real
 if animator and type(id)=="string" and id~="" and id~="rbxassetid://0" then
  local animation
  local ok,value=pcall(function()
   animation=Instance.new("Animation");animation.AnimationId=id
   return animator:LoadAnimation(animation)
  end)
  if animation then animation:Destroy() end
  if ok then real=value end
 end
 return wrap(real,name)
end
function Support.Load(_,rig,id,_,name)
 local animator=rig and rig:FindFirstChildWhichIsA("Animator",true)
 if not animator and rig then
  local controller=rig:FindFirstChildOfClass("Humanoid") or rig:FindFirstChildOfClass("AnimationController")
  if controller then animator=Instance.new("Animator");animator.Parent=controller end
 end
 return Support.LoadAnimator(animator,id,name)
end
function Support.Prepare(actor)
 if type(actor.Config.Animations)~="table" then actor.Config.Animations={} end
 if type(actor.Animations)~="table" then actor.Animations={} end
end
function Support.Track(actor,name)
 Support.Prepare(actor)
 local current=actor.Animations[name]
 local track
 if current then track=wrap(current,name)
 else track=Support.Load(nil,actor.Rig,actor.Config.Animations[name],false,name) end
 actor.Animations[name]=track
 return track
end
function Support.Table(tracks)
 return setmetatable(tracks or {},{__index=function(self,name)
  local track=wrap(nil,name);rawset(self,name,track);return track
 end})
end
return Support
]========]},
{path=[========[
ReplicatedStorage/Assets/Killers/Azure/Config/cl_ObjectBehavior/cl_GroundBulb]========],before="36723:3ec60adc:a79fdd17",previous="36718:02f31c22:b9d461bb",after="36740:747974d3:287aab64",source=[========[
-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- DgOpAQ9nZXRBY3RpdmVPYmplY3QJSXNQbGF5aW5nBFN0b3ANc3RvcEFuaW1hdGlvbg5HZXREZXNjZW5kYW50cwtCbG9vbWluZ1ZGWAxHZXRBdHRyaWJ1dGUPUGFydGljbGVFbWl0dGVyA0lzQQRCZWFtBVRyYWlsB0VuYWJsZWQKUG9pbnRMaWdodAlTcG90TGlnaHQMU3VyZmFjZUxpZ2h0DnNldEJsb29taW5nVkZYFVdpdGhlclRpbWVyQ29ubmVjdGlvbgpEaXNjb25uZWN0DldpdGhlclRpbWVyR3VpB0Rlc3Ryb3kQY2xlYXJXaXRoZXJUaW1lcgZ0eXBlb2YGbnVtYmVyBE1ldGEMU2xlZXBpbmdUaW1lBXRhYmxlE2dldFNsZWVwaW5nRHVyYXRpb24EVGltZQ5GaW5kRmlyc3RDaGlsZAdEaXNwbGF5CVRleHRMYWJlbA9nZXRUaW1lckRpc3BsYXkGUGFyZW50Am9zBWNsb2NrBG1hdGgDbWF4AyUqcwtSb3VuZE51bWJlcgZmb3JtYXQEVGV4dAVNb2RlbAtQcmltYXJ5UGFydA9UaW1lR3VpVGVtcGxhdGUFQ2xvbmUMQmlsbGJvYXJkR3VpB0Fkb3JuZWUVU3R1ZHNPZmZzZXRXb3JsZFNwYWNlCUhlYXJ0YmVhdAdDb25uZWN0EHN0YXJ0V2l0aGVyVGltZXIFT3duZXILTG9jYWxQbGF5ZXIISW5zdGFuY2UDbmV3CUhpZ2hsaWdodBdBenVyZVRyYXBPd25lckhpZ2hsaWdodAROYW1lBEVudW0SSGlnaGxpZ2h0RGVwdGhNb2RlC0Fsd2F5c09uVG9wCURlcHRoTW9kZQZDb2xvcjMHZnJvbVJHQglGaWxsQ29sb3IMT3V0bGluZUNvbG9yEEZpbGxUcmFuc3BhcmVuY3kTT3V0bGluZVRyYW5zcGFyZW5jeRFhZGRPd25lckhpZ2hsaWdodBJSb2xsT2ZmTWF4RGlzdGFuY2USUm9sbE9mZk1pbkRpc3RhbmNlBlZvbHVtZQNtaW4LRWFzaW5nU3R5bGUFQ3ViaWMPRWFzaW5nRGlyZWN0aW9uA091dAhHZXRWYWx1ZQdTY2FsZVRvCEFuY2hvcmVkBkNGcmFtZQZBbmdsZXMHUGl2b3RUbwl3b3Jrc3BhY2UDTWFwBkluZ2FtZQhHZXRQaXZvdBxyYnhhc3NldGlkOi8vMTA0NzkyNzY5MDIxNTkyBkxvb3BlZARQbGF5B0NoYW5nZWQLUm9sbE9mZk1vZGUOSW52ZXJzZVRhcGVyZWQDQWRkDVJlbmRlclN0ZXBwZWQTQW5pbWF0aW9uQ29udHJvbGxlcghBbmltYXRvcgVwYWlycwpBbmltYXRpb25zCUFuaW1hdGlvbgtBbmltYXRpb25JZA1Mb2FkQW5pbWF0aW9uCldpdGhlckxvb3AHRmlyZVZGWA9GaXJlVkZYVGVtcGxhdGUETWFpZAZUYXJnZXQHSXNBd2FrZQdUaW1lR3VpC0RlZnVzZVNvdW5kBlNvdW5kcwxXYXJuaW5nU291bmQHSXNMb2NhbBFIaWdobGlnaHRUZW1wbGF0ZQ5Mb2NhbEhpZ2hsaWdodAdTcGF3bkluCVNsZWVwSWRsZQRVVUlEBkNyZWF0ZQtXaXRoZXJUb2tlbgpJc1dpdGhlcmVkCkFjdGl2ZUlkbGUGV2FrZXVwBVNob290DFdpdGhlcldha2V1cA1XaXRoZXJTdGFydHVwB1N0b3BwZWQGV2l0aGVyDVNldFBvd2VyTGV2ZWwHU3BvdHRlZARnYW1lBkRlYnJpcwdBZGRJdGVtCVR3ZWVuSW5mbwRXYXJuAVIFY2xhbXABRwFCBWFsdGVyBFF1YWQEdGFzawR3YWl0C1dhcm5pbmdGbGFnCFBvc2l0aW9uC09HQ29sb3JGbGFnBXNwYXduCFFURUJlZ2FuCURlbnlCdWlsZAdUZXJyYWluBmxvb2tBdA1FbWl0UGFydGljbGVzBFNpbmUCSW4HRGVzcGF3bgVwY2FsbAVjbGVhcgxUd2VlblNlcnZpY2UKR2V0U2VydmljZRFSZXBsaWNhdGVkU3RvcmFnZQpSdW5TZXJ2aWNlB1BsYXllcnMHcmVxdWlyZQdNb2R1bGVzCEdhbWVwbGF5EVByZWRpY3RQcm9qZWN0aWxlCVV0aWxpdGllcwRVdGlsCVJlbmRlcmluZwFRAj8AHCgDAQEAAAYDAAAFAQMD+wIAAIcBAgCCAQIAAAAXAQEYAAAAGAAAAAAATQMBAAAIBgMAAAUBhwkOAAcATQEAnAAAAAAOAQQAvAEA+gEAAAAlAQIBAAAAAIIAAQACAwIDAwAbBAEYAAAAAAEAAAACHAAAAAABAAYH2QIK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

-- decompilation:
local t1 = {}
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

game:GetService("Debris")
require(ReplicatedStorage.Modules.PredictProjectile)

local Util = require(ReplicatedStorage.Modules.Util)
local AnimationSupport = require(ReplicatedStorage.Assets.Killers.Azure.Behavior.OptionalAnimations)
local Maid = require(ReplicatedStorage.Modules.Misc.Maid)
local Sounds = require(ReplicatedStorage.Modules.Sounds)
local t2 = {}

local function getActiveObject(s1: string) -- line: 23
	-- upvalues: t2 (copy)
	return t2[s1]
end
local function stopAnimation(p1) -- line: 27
	if p1 and p1.IsPlaying then
		p1:Stop()
	end
end
local function setBloomingVFX(p2, b1: boolean) -- line: 33
	for _, descendant in p2:GetDescendants() do
		if descendant:GetAttribute("BloomingVFX") == true then
			if descendant:IsA("ParticleEmitter") or descendant:IsA("Beam") or descendant:IsA("Trail") then
				descendant.Enabled = b1
			elseif descendant:IsA("PointLight") or descendant:IsA("SpotLight") or descendant:IsA("SurfaceLight") then
				descendant.Enabled = b1
			end
		end
	end
end
local function clearWitherTimer(p3) -- line: 47
	if p3.WitherTimerConnection then
		p3.WitherTimerConnection:Disconnect()
		p3.WitherTimerConnection = nil
	end

	if p3.WitherTimerGui then
		p3.WitherTimerGui:Destroy()
		p3.WitherTimerGui = nil
	end
end
local function getSleepingDuration(p4, n1: number?) -- line: 59
	if typeof(n1) == "number" then
		return n1
	end

	local v27 = p4.Meta and p4.Meta.SleepingTime

	if typeof(v27) == "number" then
		return v27
	end

	if typeof(v27) == "table" then
		return v27[1] or (v27[2] or (v27[3] or 0))
	end

	return 0
end
local function getTimerDisplay(p5) -- line: 74
	local Time = p5:FindFirstChild("Time")

	if not Time then
		return nil
	end

	local Display = Time:FindFirstChild("Display")

	if Display and Display:IsA("TextLabel") then
		return Display
	end

	return nil
end
local function startWitherTimer(p6, n2: number?) -- line: 88
	-- upvalues: Util (copy), RunService (copy)
	local Model = p6.Model

	if not Model or (not Model.PrimaryPart or not p6.TimeGuiTemplate) then
		return
	end

	if p6.WitherTimerConnection then
		p6.WitherTimerConnection:Disconnect()
		p6.WitherTimerConnection = nil
	end

	if p6.WitherTimerGui then
		p6.WitherTimerGui:Destroy()
		p6.WitherTimerGui = nil
	end

	if typeof(n2) == "number" then
	else
		local v34 = p6.Meta and p6.Meta.SleepingTime

		n2 = if typeof(v34) ~= "number" then typeof(v34) ~= "table" and 0 or (v34[1] or (v34[2] or (v34[3] or 0))) else v34
	end

	local v35 = n2

	if v35 <= 0 then
		return
	end

	local clone = p6.TimeGuiTemplate:Clone()

	clone.Parent = Model.PrimaryPart

	if clone:IsA("BillboardGui") then
		clone.Adornee = Model.PrimaryPart
		clone.StudsOffsetWorldSpace = Vector3.new(0, -0.44999998807907104, 0)
	end

	local Time = clone:FindFirstChild("Time")
	local v38

	if not Time then
		v38 = nil
	else
		local Display = Time:FindFirstChild("Display")

		v38 = if not Display or not Display:IsA("TextLabel") then nil else Display
	end

	local v40 = v38

	if v40 then
		v40.Text = `{ Util:RoundNumber(v35, 1) }s`
	end

	p6.WitherTimerGui = clone

	local elapsed = os.clock()

	p6.WitherTimerConnection = RunService.Heartbeat:Connect(function() -- line: 116
		-- upvalues: clone (copy), p6 (copy), v35 (copy), elapsed (copy), v40 (copy), Util (copy)
		if not clone or not clone.Parent then
			local v107 = p6

			if v107.WitherTimerConnection then
				v107.WitherTimerConnection:Disconnect()
				v107.WitherTimerConnection = nil
			end

			if v107.WitherTimerGui then
				v107.WitherTimerGui:Destroy()
				v107.WitherTimerGui = nil
			end

			return
		end

		local v108 = math.max(v35 - (os.clock() - elapsed), 0)

		if v40 then
			v40.Text = `{ Util:RoundNumber(v108, 1) }s`
		end

		if v108 <= 0 then
			local v109 = p6

			if v109.WitherTimerConnection then
				v109.WitherTimerConnection:Disconnect()
				v109.WitherTimerConnection = nil
			end

			if v109.WitherTimerGui then
				v109.WitherTimerGui:Destroy()
				v109.WitherTimerGui = nil
			end
		end
	end)
end
local function addOwnerHighlight(t3: {[any]: any}, p7) -- line: 133
	-- upvalues: Players (copy)
	if t3.Owner ~= Players.LocalPlayer then
		return
	end

	local Highlight = Instance.new("Highlight")

	Highlight.Name = "AzureTrapOwnerHighlight"
	Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	Highlight.FillColor = Color3.fromRGB(58, 32, 80)
	Highlight.OutlineColor = Color3.fromRGB(187, 98, 255)
	Highlight.FillTransparency = 0.45
	Highlight.OutlineTransparency = 0
	Highlight.Parent = p7

	return Highlight
end

function t1.Create(t4: {[any]: any}) -- line: 150
	-- upvalues: Maid (copy), setBloomingVFX (copy), Sounds (copy), RunService (copy), TweenService (copy), Players (copy), addOwnerHighlight (copy), t2 (copy)
	local t5 = {}
	local clone = t4.Model:Clone()
	local v48 = Maid.new()

	clone.PrimaryPart.Anchored = true
	clone:ScaleTo(0.01)
	clone:PivotTo(t4.CFrame * CFrame.Angles(-1.5707963267948966, 0, 0))
	clone.Parent = workspace.Map.Ingame
	setBloomingVFX(clone, true)
	clone:GetPivot()

	local v49 = Sounds:Play("rbxassetid://104792769021592", {
		Looped = true,
		Parent = clone.PrimaryPart
	})

	v49.Changed:Connect(function(property: string) -- line: 168
		-- upvalues: v49 (copy)
		if property == "RollOffMaxDistance" then
			v49[property] = 90

			return
		end

		if property == "RollOffMinDistance" then
			v49[property] = 10

			return
		end

		if property == "Volume" then
			v49[property] = 0.7
		end
	end)
	v49.RollOffMaxDistance = 90
	v49.RollOffMinDistance = 10
	v49.RollOffMode = Enum.RollOffMode.InverseTapered
	v49.Volume = 0.7
	v48:Add(v49)

	local elapsed = os.clock()
	local u51 = nil

	u51 = RunService.RenderStepped:Connect(function() -- line: 187
		-- upvalues: elapsed (copy), u51 (ref), TweenService (copy), clone (copy)
		local v111 = os.clock() - elapsed

		if v111 > 0.4 and u51 then
			u51:Disconnect()
			u51 = nil
		end

		local Value = TweenService:GetValue(math.min(v111 / 0.4, 1), Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)

		clone:ScaleTo(Value * 1.25)
	end)

	local t6 = {}
	local Animator = clone.AnimationController.Animator

	for k, v in pairs(t4.Animations or {}) do
		t6[k] = AnimationSupport.LoadAnimator(Animator, v, k)
		v48:Add(t6[k])
	end

	if t6.WitherLoop then
		t6.WitherLoop.Looped = true
	end

	t5.FireVFXTemplate = t4.FireVFX
	t5.Maid = v48
	t5.Model = clone
	t5.Target = nil
	t5.IsAwake = false
	t5.Animations = AnimationSupport.Table(t6)
	t5.Meta = t4.Meta
	t5.TimeGuiTemplate = t4.TimeGui
	t5.WarningSound = t4.DefuseSound or t4.Meta.Sounds and t4.Meta.Sounds.DefuseSound
	t5.Owner = t4.Owner
	t5.IsLocal = Players.LocalPlayer == t4.Owner
	t5.HighlightTemplate = t4.HighlightTemplate
	t5.LocalHighlight = addOwnerHighlight(t4, clone, v48)
	t5.Animations.SpawnIn:Play()
	t5.Animations.SleepIdle:Play()
	t2[t4.UUID] = t5
end
function t1.Wither(s2: string) -- line: 235
	-- upvalues: t2 (copy)
	local v58 = t2[s2]

	if not v58 then
		return
	end

	if v58.IsWithered then
		return
	end

	v58.IsWithered = true
	v58.IsAwake = false
	v58.Target = nil

	local ActiveIdle = v58.Animations.ActiveIdle

	if ActiveIdle and ActiveIdle.IsPlaying then
		ActiveIdle:Stop()
	end

	local SleepIdle = v58.Animations.SleepIdle

	if SleepIdle and SleepIdle.IsPlaying then
		SleepIdle:Stop()
	end

	local Wakeup = v58.Animations.Wakeup

	if Wakeup and Wakeup.IsPlaying then
		Wakeup:Stop()
	end

	local Shoot = v58.Animations.Shoot

	if Shoot and Shoot.IsPlaying then
		Shoot:Stop()
	end

	local WitherWakeup = v58.Animations.WitherWakeup

	if WitherWakeup and WitherWakeup.IsPlaying then
		WitherWakeup:Stop()
	end

	local WitherStartup = v58.Animations.WitherStartup
	local WitherLoop = v58.Animations.WitherLoop

	if WitherStartup then
		WitherStartup:Play()

		if WitherLoop then
			local elapsed = os.clock()

			v58.WitherToken = elapsed

			local u67 = nil

			u67 = WitherStartup.Stopped:Connect(function() -- line: 258
				-- upvalues: u67 (ref), t2 (copy), s2 (copy), v58 (copy), elapsed (copy), WitherLoop (copy)
				if u67 then
					u67:Disconnect()
					u67 = nil
				end

				if t2[s2] == v58 and v58.WitherToken == elapsed then
					WitherLoop:Play()
				end
			end)
			v58.Maid:Add(u67)

			return
		end
	elseif WitherLoop then
		WitherLoop:Play()
	end
end
function t1.SetPowerLevel(s3: string, n3: number, n4: number?) -- line: 274
	-- upvalues: t2 (copy), setBloomingVFX (copy), t1 (copy), startWitherTimer (copy)
	local v71 = t2[s3]

	if not v71 then
		return
	end

	setBloomingVFX(v71.Model, n3 == 3)

	if n3 == 1 then
		t1.Wither(s3)
		startWitherTimer(v71, n4)

		return
	end

	if v71.WitherTimerConnection then
		v71.WitherTimerConnection:Disconnect()
		v71.WitherTimerConnection = nil
	end

	if v71.WitherTimerGui then
		v71.WitherTimerGui:Destroy()
		v71.WitherTimerGui = nil
	end

	if not v71.IsWithered then
		return
	end

	v71.IsWithered = false
	v71.WitherToken = nil

	local WitherStartup = v71.Animations.WitherStartup

	if WitherStartup and WitherStartup.IsPlaying then
		WitherStartup:Stop()
	end

	local WitherLoop = v71.Animations.WitherLoop

	if WitherLoop and WitherLoop.IsPlaying then
		WitherLoop:Stop()
	end

	local ActiveIdle = v71.Animations.ActiveIdle

	if ActiveIdle and ActiveIdle.IsPlaying then
		ActiveIdle:Stop()
	end

	local SleepIdle = v71.Animations.SleepIdle

	if SleepIdle and SleepIdle.IsPlaying then
		SleepIdle:Stop()
	end

	if v71.Animations.WitherWakeup then
		v71.Animations.WitherWakeup:Play()
	else
		v71.Animations.Wakeup:Play()
	end

	if v71.Target then
		v71.Animations.ActiveIdle:Play()

		return
	end

	v71.Animations.SleepIdle:Play()
end
function t1.Warn(s4: string) -- line: 312
	-- upvalues: t2 (copy), TweenService (copy)
	local v77 = t2[s4]

	if not v77 then
		return
	end

	if v77.Animations.Spotted then
		v77.Animations.Spotted:Play()
	end

	local clone = v77.HighlightTemplate:Clone()

	clone.Parent = v77.Model
	game.Debris:AddItem(clone, 0.4)
	TweenService:Create(clone, TweenInfo.new(0.4), {
		FillTransparency = 1,
		OutlineTransparency = 1
	}):Play()
end
function t1.QTEBegan(s5: string, _) -- line: 327
	-- upvalues: t2 (copy), Sounds (copy), TweenService (copy)
	local v81 = t2[s5]

	if not v81 then
		return
	end

	if v81.IsLocal then
		if v81.WarningSound then
			Sounds:Play(v81.WarningSound, {
				Volume = 1.1,
				RollOffMaxDistance = 10000,
				Position = v81.Model:GetPivot().Position
			})
		end

		if v81.LocalHighlight and not v81.WarningFlag then
			v81.WarningFlag = true
			v81.OGColorFlag = v81.OGColorFlag or v81.LocalHighlight.FillColor

			local function alter(color3: Color3) -- line: 340
				return Color3.new(math.clamp(color3.R * 1.9, 0, 1), math.clamp(color3.G * 1.9, 0, 1), (math.clamp(color3.B * 1.9, 0, 1)))
			end

			local OGColorFlag = v81.OGColorFlag
			local color3 = Color3.new(math.clamp(OGColorFlag.R * 1.9, 0, 1), math.clamp(OGColorFlag.G * 1.9, 0, 1), (math.clamp(OGColorFlag.B * 1.9, 0, 1)))

			task.spawn(function() -- line: 345
				-- upvalues: v81 (copy), color3 (copy), TweenService (copy), OGColorFlag (copy)
				for _ = 1, 2 do
					v81.LocalHighlight.FillColor = color3
					TweenService:Create(v81.LocalHighlight, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						FillColor = OGColorFlag
					}):Play()
					task.wait(0.6)

					if not v81.LocalHighlight then
						return
					end
				end

				v81.WarningFlag = nil
			end)
		end
	end
end
function t1.DenyBuild(s6: string) -- line: 359
	-- upvalues: t2 (copy), TweenService (copy)
	local v86 = t2[s6]

	if not v86 then
		return
	end

	if v86.LocalHighlight and not v86.WarningFlag then
		v86.WarningFlag = true
		v86.OGColorFlag = v86.OGColorFlag or v86.LocalHighlight.FillColor

		local function alter(color3: Color3) -- line: 367
			return Color3.new(math.clamp(color3.R * 1.9, 0, 1), math.clamp(color3.G * 1.9, 0, 1), (math.clamp(color3.B * 1.9, 0, 1)))
		end

		local OGColorFlag = v86.OGColorFlag
		local color3 = Color3.new(math.clamp(OGColorFlag.R * 1.9, 0, 1), math.clamp(OGColorFlag.G * 1.9, 0, 1), (math.clamp(OGColorFlag.B * 1.9, 0, 1)))

		task.spawn(function() -- line: 372
			-- upvalues: v86 (copy), color3 (copy), TweenService (copy), OGColorFlag (copy)
			v86.LocalHighlight.FillColor = color3
			TweenService:Create(v86.LocalHighlight, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				FillColor = OGColorFlag
			}):Play()
			task.wait(0.6)

			if not v86.LocalHighlight then
				return
			end

			v86.WarningFlag = nil
		end)
	end
end
function t1.Target(s7: string, p9) -- line: 383
	-- upvalues: t2 (copy)
	local v92 = t2[s7]

	if not v92 then
		return
	end

	local v93 = not not p9

	if v93 == v92.IsAwake then
		return
	end

	v92.IsAwake = v93

	if v93 then
		if v92.IsWithered then
			v92.IsWithered = false
			v92.WitherToken = nil

			if v92.WitherTimerConnection then
				v92.WitherTimerConnection:Disconnect()
				v92.WitherTimerConnection = nil
			end

			if v92.WitherTimerGui then
				v92.WitherTimerGui:Destroy()
				v92.WitherTimerGui = nil
			end

			local WitherStartup = v92.Animations.WitherStartup

			if WitherStartup and WitherStartup.IsPlaying then
				WitherStartup:Stop()
			end

			local WitherLoop = v92.Animations.WitherLoop

			if WitherLoop and WitherLoop.IsPlaying then
				WitherLoop:Stop()
			end

			if v92.Animations.WitherWakeup then
				v92.Animations.WitherWakeup:Play()
			else
				v92.Animations.Wakeup:Play()
			end
		else
			v92.Animations.Wakeup:Play()
		end

		local SleepIdle = v92.Animations.SleepIdle

		if SleepIdle and SleepIdle.IsPlaying then
			SleepIdle:Stop()
		end

		v92.Animations.ActiveIdle:Play()
	else
		local ActiveIdle = v92.Animations.ActiveIdle

		if ActiveIdle and ActiveIdle.IsPlaying then
			ActiveIdle:Stop()
		end

		if not v92.IsWithered then
			v92.Animations.SleepIdle:Play()
		end
	end

	v92.Target = p9
end
function t1.Shoot(s8: string, vector3: Vector3, vector3_2: Vector3) -- line: 421
	-- upvalues: t2 (copy), Util (copy)
	local v101 = t2[s8]

	if not v101 then
		return
	end

	local FireVFXTemplate = v101.FireVFXTemplate

	if FireVFXTemplate then
		local clone = FireVFXTemplate:Clone()

		clone.Parent = workspace.Terrain
		clone.CFrame = CFrame.lookAt(vector3, vector3 + vector3_2)
		game.Debris:AddItem(clone, 2)
		Util:EmitParticles(clone)
	end

	v101.Animations.Shoot:Play()
end
function t1.Destroy(s9: string) -- line: 439
	-- upvalues: t2 (copy), RunService (copy), TweenService (copy)
	local v105 = t2[s9]

	if not v105 then
		return
	end

	local Model = v105.Model

	if v105.WitherTimerConnection then
		v105.WitherTimerConnection:Disconnect()
		v105.WitherTimerConnection = nil
	end

	if v105.WitherTimerGui then
		v105.WitherTimerGui:Destroy()
		v105.WitherTimerGui = nil
	end

	if v105.Animations.Despawn then
		v105.Animations.Despawn:Play()
	end

	pcall(function() -- line: 449
		-- upvalues: RunService (copy), TweenService (copy), Model (copy)
		local elapsed = os.clock()
		local u117 = nil

		u117 = RunService.RenderStepped:Connect(function() -- line: 452
			-- upvalues: elapsed (copy), u117 (ref), TweenService (copy), Model (copy)
			local v118 = os.clock() - elapsed

			if v118 >= 0.4 then
				if u117 then
					u117:Disconnect()
					u117 = nil
				end

				return
			end

			local Value = TweenService:GetValue(math.min(v118 / 0.4, 1), Enum.EasingStyle.Sine, Enum.EasingDirection.In)

			Model:ScaleTo(math.max(1 - Value, 0.01) * 1.25)
		end)
		game.Debris:AddItem(Model, 0.5)
	end)

	if v105.Maid then
		v105.Maid:Destroy()
	end

	table.clear(v105)
	t2[s9] = nil
end

return t1
]========]},
{path=[========[
ReplicatedStorage/Assets/Killers/Azure/Config/cl_ObjectBehavior/cl_Vine]========],before="48535:5c3f2046:2023f0db",previous="48530:4b8a008c:1f4d2caf",after="48546:c240c124:a1a0b113",source=[========[
-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- DgPTAQ9nZXRBY3RpdmVPYmplY3QJSXNQbGF5aW5nBFN0b3ANc3RvcEFuaW1hdGlvbg5HZXREZXNjZW5kYW50cwtCbG9vbWluZ1ZGWAxHZXRBdHRyaWJ1dGUPUGFydGljbGVFbWl0dGVyA0lzQQRCZWFtBVRyYWlsB0VuYWJsZWQKUG9pbnRMaWdodAlTcG90TGlnaHQMU3VyZmFjZUxpZ2h0DnNldEJsb29taW5nVkZYFVdpdGhlclRpbWVyQ29ubmVjdGlvbgpEaXNjb25uZWN0DldpdGhlclRpbWVyR3VpB0Rlc3Ryb3kQY2xlYXJXaXRoZXJUaW1lcgpBbmltYXRpb25zDENvb2xkb3duTG9vcAZMb29wZWQEUGxheQhjb29sZG93bgZ0eXBlb2YGbnVtYmVyBE1ldGEMU2xlZXBpbmdUaW1lBXRhYmxlE2dldFNsZWVwaW5nRHVyYXRpb24EVGltZQ5GaW5kRmlyc3RDaGlsZAdEaXNwbGF5CVRleHRMYWJlbA9nZXRUaW1lckRpc3BsYXkGUGFyZW50Am9zBWNsb2NrBG1hdGgDbWF4AyUqcwtSb3VuZE51bWJlcgZmb3JtYXQEVGV4dAVNb2RlbAtQcmltYXJ5UGFydA9UaW1lR3VpVGVtcGxhdGUFQ2xvbmUMQmlsbGJvYXJkR3VpB0Fkb3JuZWUVU3R1ZHNPZmZzZXRXb3JsZFNwYWNlCUhlYXJ0YmVhdAdDb25uZWN0EHN0YXJ0V2l0aGVyVGltZXIFT3duZXILTG9jYWxQbGF5ZXIISW5zdGFuY2UDbmV3CUhpZ2hsaWdodBdBenVyZVRyYXBPd25lckhpZ2hsaWdodAROYW1lBEVudW0SSGlnaGxpZ2h0RGVwdGhNb2RlC0Fsd2F5c09uVG9wCURlcHRoTW9kZQZDb2xvcjMHZnJvbVJHQglGaWxsQ29sb3IMT3V0bGluZUNvbG9yEEZpbGxUcmFuc3BhcmVuY3kTT3V0bGluZVRyYW5zcGFyZW5jeRFhZGRPd25lckhpZ2hsaWdodBJSb2xsT2ZmTWF4RGlzdGFuY2USUm9sbE9mZk1pbkRpc3RhbmNlBlZvbHVtZRdUcmFja2luZ0NoYXJhY3RlckFjdGl2ZQZpcGFpcnMJd29ya3NwYWNlB1BsYXllcnMJU3Vydml2b3JzC0dldENoaWxkcmVuB0lzQWxpdmUMVW5kZXRlY3RhYmxlCFBvc2l0aW9uBkNGcmFtZQlNYWduaXR1ZGUIRmFjZVJvb3QOQmV6aWVyRW5kcG9pbnQBWAFZAVoHVmVjdG9yMwZBbmdsZXMDZXhwBExlcnAHUGl2b3RUbwhFbmRQb2ludApTdGFydFBvaW50DENvbnRyb2xQb2ludAVBbHBoYQpJc1dpdGhlcmVkCkxvb2tWZWN0b3IDRG90BWNsYW1wBGFjb3MNRmFjZVR1cm5TcGVlZANtaW4LRWFzaW5nU3R5bGUFQ3ViaWMPRWFzaW5nRGlyZWN0aW9uA091dAhHZXRWYWx1ZQdTY2FsZVRvCEFuY2hvcmVkA01hcAZJbmdhbWUOTG9jYWxIaWdobGlnaHQccmJ4YXNzZXRpZDovLzEwNDc5Mjc2OTAyMTU5MgdDaGFuZ2VkA0FkZAhSb290UGFydARCb25lFUZpbmRGaXJzdENoaWxkT2ZDbGFzcwZpbnNlcnQIR2V0UGl2b3QTQW5pbWF0aW9uQ29udHJvbGxlcghBbmltYXRvcgVwYWlycwlBbmltYXRpb24LQW5pbWF0aW9uSWQNTG9hZEFuaW1hdGlvbgpXaXRoZXJMb29wBE1haWQHSXNMb2NhbAdJc0F3YWtlB1RpbWVHdWkLRGVmdXNlU291bmQGU291bmRzDFdhcm5pbmdTb3VuZAdTcGF3bkluBElkbGUSQmV6aWVyQm9uZVRyYWNraW5nDVJlbmRlclN0ZXBwZWQEVVVJRAZDcmVhdGULV2l0aGVyVG9rZW4GV2FrZXVwBEdyYWIIR3JhYklkbGUFTGV0R28MV2l0aGVyV2FrZXVwDVdpdGhlclN0YXJ0dXAHU3RvcHBlZAZXaXRoZXINU2V0UG93ZXJMZXZlbARIZWFkDk9uQ2hhcmFjdGVySGl0Ck9uUmVsZWFzZWQEUGFydAR0YXNrBHdhaXQNTGluZVRoaWNrbmVzcwRnYW1lDFR3ZWVuU2VydmljZQlUd2VlbkluZm8EUXVhZAJJbgxFcGlsZXBzeU1vZGUPR2V0U2V0dGluZ1ZhbHVlBXNwYXduBWRlbGF5CE9uQXR0YWNrC0Nvb2xkb3duRW5kB09uUmVhZHkGT25NaXNzAVIBRwFCBWFsdGVyC1dhcm5pbmdGbGFnC09HQ29sb3JGbGFnCURlbnlC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

-- decompilation:
local t1 = {}
local t2 = {
	Wakeup = "rbxassetid://139720883651202",
	Die = "rbxassetid://118195533623397",
	Grab = "rbxassetid://87758029542301",
	LetGo = "rbxassetid://136119703850698",
	Idle = "rbxassetid://98311198007192",
	SpawnIn = "rbxassetid://86350197579971",
	GrabIdle = "rbxassetid://96227619760024"
}
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

game:GetService("Debris")
require(ReplicatedStorage.Modules.PredictProjectile)

local Util = require(ReplicatedStorage.Modules.Util)
local AnimationSupport = require(ReplicatedStorage.Assets.Killers.Azure.Behavior.OptionalAnimations)
local Maid = require(ReplicatedStorage.Modules.Misc.Maid)
local Sounds = require(ReplicatedStorage.Modules.Sounds)
local t3 = {}

local function getActiveObject(s1: string) -- line: 34
	-- upvalues: t3 (copy)
	return t3[s1]
end
local function stopAnimation(p1) -- line: 38
	if p1 and p1.IsPlaying then
		p1:Stop()
	end
end
local function setBloomingVFX(p2, b1: boolean) -- line: 44
	for _, descendant in p2:GetDescendants() do
		if descendant:GetAttribute("BloomingVFX") == true then
			if descendant:IsA("ParticleEmitter") or descendant:IsA("Beam") or descendant:IsA("Trail") then
				descendant.Enabled = b1
			elseif descendant:IsA("PointLight") or descendant:IsA("SpotLight") or descendant:IsA("SurfaceLight") then
				descendant.Enabled = b1
			end
		end
	end
end
local function clearWitherTimer(p3) -- line: 58
	if p3.WitherTimerConnection then
		p3.WitherTimerConnection:Disconnect()
		p3.WitherTimerConnection = nil
	end

	if p3.WitherTimerGui then
		p3.WitherTimerGui:Destroy()
		p3.WitherTimerGui = nil
	end
end
local function cooldown(p4) -- line: 70
	p4.Animations.CooldownLoop.Looped = true
	p4.Animations.CooldownLoop:Play(0.5, 0.9)
end
local function getSleepingDuration(p5, n1: number?) -- line: 75
	if typeof(n1) == "number" then
		return n1
	end

	local v30 = p5.Meta and p5.Meta.SleepingTime

	if typeof(v30) == "number" then
		return v30
	end

	if typeof(v30) == "table" then
		return v30[1] or (v30[2] or (v30[3] or 0))
	end

	return 0
end
local function getTimerDisplay(p6) -- line: 90
	local Time = p6:FindFirstChild("Time")

	if not Time then
		return nil
	end

	local Display = Time:FindFirstChild("Display")

	if Display and Display:IsA("TextLabel") then
		return Display
	end

	return nil
end
local function startWitherTimer(p7, n2: number?) -- line: 104
	-- upvalues: Util (copy), RunService (copy)
	local Model = p7.Model

	if not Model or (not Model.PrimaryPart or not p7.TimeGuiTemplate) then
		return
	end

	if p7.WitherTimerConnection then
		p7.WitherTimerConnection:Disconnect()
		p7.WitherTimerConnection = nil
	end

	if p7.WitherTimerGui then
		p7.WitherTimerGui:Destroy()
		p7.WitherTimerGui = nil
	end

	if typeof(n2) == "number" then
	else
		local v37 = p7.Meta and p7.Meta.SleepingTime

		n2 = if typeof(v37) ~= "number" then typeof(v37) ~= "table" and 0 or (v37[1] or (v37[2] or (v37[3] or 0))) else v37
	end

	local v38 = n2

	if v38 <= 0 then
		return
	end

	local clone = p7.TimeGuiTemplate:Clone()

	clone.Parent = Model.PrimaryPart

	if clone:IsA("BillboardGui") then
		clone.Adornee = Model.PrimaryPart
		clone.StudsOffsetWorldSpace = Vector3.new(0, 5, 0)
	end

	local Time = clone:FindFirstChild("Time")
	local v41

	if not Time then
		v41 = nil
	else
		local Display = Time:FindFirstChild("Display")

		v41 = if not Display or not Display:IsA("TextLabel") then nil else Display
	end

	local v43 = v41

	if v43 then
		v43.Text = `{ Util:RoundNumber(v38, 1) }s`
	end

	p7.WitherTimerGui = clone

	local elapsed = os.clock()

	p7.WitherTimerConnection = RunService.Heartbeat:Connect(function() -- line: 132
		-- upvalues: clone (copy), p7 (copy), v38 (copy), elapsed (copy), v43 (copy), Util (copy)
		if not clone or not clone.Parent then
			local v126 = p7

			if v126.WitherTimerConnection then
				v126.WitherTimerConnection:Disconnect()
				v126.WitherTimerConnection = nil
			end

			if v126.WitherTimerGui then
				v126.WitherTimerGui:Destroy()
				v126.WitherTimerGui = nil
			end

			return
		end

		local v127 = math.max(v38 - (os.clock() - elapsed), 0)

		if v43 then
			v43.Text = `{ Util:RoundNumber(v127, 1) }s`
		end

		if v127 <= 0 then
			local v128 = p7

			if v128.WitherTimerConnection then
				v128.WitherTimerConnection:Disconnect()
				v128.WitherTimerConnection = nil
			end

			if v128.WitherTimerGui then
				v128.WitherTimerGui:Destroy()
				v128.WitherTimerGui = nil
			end
		end
	end)
end
local function addOwnerHighlight(t4: {[any]: any}, p8, _) -- line: 149
	-- upvalues: Players (copy)
	if t4.Owner ~= Players.LocalPlayer then
		return
	end

	local Highlight = Instance.new("Highlight")

	Highlight.Name = "AzureTrapOwnerHighlight"
	Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	Highlight.FillColor = Color3.fromRGB(58, 32, 80)
	Highlight.OutlineColor = Color3.fromRGB(187, 98, 255)
	Highlight.FillTransparency = 0.45
	Highlight.OutlineTransparency = 0
	Highlight.Parent = p8

	return Highlight
end

function t1.Create(t5: {[any]: any}, actor) -- line: 166
	-- upvalues: Maid (copy), setBloomingVFX (copy), addOwnerHighlight (copy), Sounds (copy), t2 (copy), Players (copy), Util (copy), RunService (copy), TweenService (copy), t3 (copy)
	local t6 = {}
	local clone = t5.Model:Clone()
	local v52 = Maid.new()

	clone.PrimaryPart.Anchored = true
	clone:ScaleTo(0.01)
	clone:PivotTo(t5.CFrame)
	clone.Parent = workspace.Map.Ingame
	setBloomingVFX(clone, true)
	t6.LocalHighlight = addOwnerHighlight(t5, clone)

	local v53 = Sounds:Play("rbxassetid://104792769021592", {
		Looped = true,
		Parent = clone.PrimaryPart
	})

	v53.Changed:Connect(function(property: string) -- line: 184
		-- upvalues: v53 (copy)
		if property == "RollOffMaxDistance" then
			v53[property] = 90

			return
		end

		if property == "RollOffMinDistance" then
			v53[property] = 10

			return
		end

		if property == "Volume" then
			v53[property] = 0.7
		end
	end)
	v53.RollOffMaxDistance = 90
	v53.RollOffMinDistance = 10
	v53.Volume = 0.7
	v52:Add(v53)

	local t7 = {}
	local Bone = clone.RootPart.Bone

	for _ = 1, 8 do
		Bone = Bone:FindFirstChildOfClass("Bone")
		table.insert(t7, Bone)
	end

	clone:GetPivot()

	local t8 = {}
	local Animator = clone.AnimationController.Animator
	local t9 = {}

	for k, v in pairs(t2) do
		t9[k] = v
	end

	for k, v in pairs(t5.Animations or {}) do
		t9[k] = v
	end

	for k, v in pairs(t9) do
		t8[k] = AnimationSupport.LoadAnimator(Animator, v, k)
		v52:Add(t8[k])
	end

	if t8.WitherLoop then
		t8.WitherLoop.Looped = true
	end

	t6.Maid = v52
	t6.Model = clone
	t6.IsLocal = Players.LocalPlayer == t5.Owner
	t6.BezierEndpoint = nil
	t6.IsAwake = false
	t6.Animations = AnimationSupport.Table(t8)
	t6.Meta = t5.Meta
	t6.TimeGuiTemplate = t5.TimeGui
	t6.WarningSound = t5.DefuseSound or t5.Meta.Sounds and t5.Meta.Sounds.DefuseSound
	t6.FaceRoot = nil
	t6.Animations.SpawnIn:Play()
	t6.Animations.Idle:Play()

	local v67 = Util:BezierBoneTracking(clone.PrimaryPart, t7, clone.PrimaryPart.CFrame.Position + Vector3.new(0, 4, 0), clone.PrimaryPart.CFrame.Position, clone.PrimaryPart.CFrame.Position, 0, 1)
	local elapsed = os.clock()
	local n3 = 0
	local connection = RunService.RenderStepped:Connect(function(dt: number) -- line: 248
		-- upvalues: t6 (copy), n3 (ref), Util (copy), t5 (copy), clone (copy), v67 (copy), elapsed (copy), TweenService (copy)
		if not t6.TrackingCharacterActive and os.clock() - n3 > 0.25 then
			n3 = os.clock()

			local v131 = nil
			local n4 = 1e999

			for _, child in ipairs(workspace.Players.Survivors:GetChildren()) do
				if Util:IsAlive(child) and not child:GetAttribute("Undetectable") then
					local PrimaryPart = child.PrimaryPart

					if PrimaryPart then
						local Magnitude = (PrimaryPart.Position - t5.CFrame.Position).Magnitude

						if Magnitude < n4 then
							n4 = Magnitude
							v131 = PrimaryPart
						end
					end
				end
			end
			
			if workspace:GetAttribute("FriendlyFire") then
				
				for _, child in ipairs(workspace.Players.Killers:GetChildren()) do
					if t5.Owner and child == t5.Owner.Character then continue end
				if Util:IsAlive(child) and not child:GetAttribute("Undetectable") then
					local PrimaryPart = child.PrimaryPart

					if PrimaryPart then
						local Magnitude = (PrimaryPart.Position - t5.CFrame.Position).Magnitude

						if Magnitude < n4 then
							n4 = Magnitude
							v131 = PrimaryPart
						end
					end
				end
			end
			end
			
			

			t6.FaceRoot = v131
		end

		if t6.BezierEndpoint then
			local BezierEndpointPosition = t6.BezierEndpoint.Position
			local vector3 = Vector3.new(BezierEndpointPosition.X, clone.PrimaryPart.Position.Y, BezierEndpointPosition.Z)

			if (vector3 - clone.PrimaryPart.Position).Magnitude > 1.5 then
				local v139 = CFrame.new(clone.PrimaryPart.Position, vector3) * CFrame.Angles(0, 3.141592653589793, 0)

				clone:PivotTo(clone.PrimaryPart.CFrame:Lerp(v139, 1 - math.exp(dt * -15)))
			end

			v67.EndPoint = t6.BezierEndpoint.Position
			v67.StartPoint = clone.PrimaryPart.CFrame.Position + Vector3.new(0, 4, 0)

			local v140 = t6.BezierEndpoint.Position - clone.PrimaryPart.Position

			v67.ControlPoint = clone.PrimaryPart.Position + v140 * 0.2 + Vector3.new(0, 8, 0)
			v67.Alpha = 1
		elseif not t6.IsWithered then
			v67.Alpha = 0

			if t6.FaceRoot then
				local vector3 = Vector3.new(t6.FaceRoot.Position.X, clone.PrimaryPart.Position.Y, t6.FaceRoot.Position.Z)
				local v142 = CFrame.new(clone.PrimaryPart.Position, vector3) * CFrame.Angles(0, 3.141592653589793, 0)
				local v143 = math.clamp(math.acos((math.clamp(clone.PrimaryPart.CFrame.LookVector:Dot(v142.LookVector), -1, 1))) * 10, 1.5, 12)

				t6.FaceTurnSpeed = t6.FaceTurnSpeed or 0

				local v144 = not (v143 > t6.FaceTurnSpeed) and 6 or 10
				local v145 = t6

				v145.FaceTurnSpeed = v145.FaceTurnSpeed + (v143 - t6.FaceTurnSpeed) * (1 - math.exp(-v144 * dt))

				local v146 = clone.PrimaryPart.CFrame:Lerp(v142, 1 - math.exp(-t6.FaceTurnSpeed * dt))

				clone:PivotTo(v146)
			end
		end

		local v147 = os.clock() - elapsed

		if v147 <= 1.4 then
			local Value = TweenService:GetValue(math.min(v147 / 1.3, 1), Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)

			clone:ScaleTo(Value * 3.12)
		end
	end)

	v52:Add(v67)
	v52:Add(connection)
	t3[t5.UUID] = t6
end
function t1.Wither(s2: string) -- line: 325
	-- upvalues: t3 (copy)
	local v72 = t3[s2]

	if not v72 then
		return
	end

	if v72.IsWithered then
		return
	end

	v72.IsWithered = true
	v72.BezierEndpoint = nil
	v72.TrackingCharacterActive = nil

	local Idle = v72.Animations.Idle

	if Idle and Idle.IsPlaying then
		Idle:Stop()
	end

	local Wakeup = v72.Animations.Wakeup

	if Wakeup and Wakeup.IsPlaying then
		Wakeup:Stop()
	end

	local Grab = v72.Animations.Grab

	if Grab and Grab.IsPlaying then
		Grab:Stop()
	end

	local GrabIdle = v72.Animations.GrabIdle

	if GrabIdle and GrabIdle.IsPlaying then
		GrabIdle:Stop()
	end

	local LetGo = v72.Animations.LetGo

	if LetGo and LetGo.IsPlaying then
		LetGo:Stop()
	end

	local WitherWakeup = v72.Animations.WitherWakeup

	if WitherWakeup and WitherWakeup.IsPlaying then
		WitherWakeup:Stop()
	end

	local WitherStartup = v72.Animations.WitherStartup
	local WitherLoop = v72.Animations.WitherLoop

	if WitherStartup then
		WitherStartup:Play()

		if WitherLoop then
			local elapsed = os.clock()

			v72.WitherToken = elapsed

			local u82 = nil

			u82 = WitherStartup.Stopped:Connect(function() -- line: 349
				-- upvalues: u82 (ref), t3 (copy), s2 (copy), v72 (copy), elapsed (copy), WitherLoop (copy)
				if u82 then
					u82:Disconnect()
					u82 = nil
				end

				if t3[s2] == v72 and v72.WitherToken == elapsed then
					WitherLoop:Play()
				end
			end)
			v72.Maid:Add(u82)

			return
		end
	elseif WitherLoop then
		WitherLoop:Play()
	end
end
function t1.SetPowerLevel(s3: string, n5: number, n6: number?) -- line: 365
	-- upvalues: t3 (copy), setBloomingVFX (copy), t1 (copy), startWitherTimer (copy)
	local v86 = t3[s3]

	if not v86 then
		return
	end

	setBloomingVFX(v86.Model, n5 == 3)

	if n5 == 1 then
		t1.Wither(s3)
		startWitherTimer(v86, n6)

		return
	end

	if v86.WitherTimerConnection then
		v86.WitherTimerConnection:Disconnect()
		v86.WitherTimerConnection = nil
	end

	if v86.WitherTimerGui then
		v86.WitherTimerGui:Destroy()
		v86.WitherTimerGui = nil
	end

	if not v86.IsWithered then
		return
	end

	v86.IsWithered = false
	v86.WitherToken = nil

	local WitherStartup = v86.Animations.WitherStartup

	if WitherStartup and WitherStartup.IsPlaying then
		WitherStartup:Stop()
	end

	local WitherLoop = v86.Animations.WitherLoop

	if WitherLoop and WitherLoop.IsPlaying then
		WitherLoop:Stop()
	end

	local Idle = v86.Animations.Idle

	if Idle and Idle.IsPlaying then
		Idle:Stop()
	end

	local GrabIdle = v86.Animations.GrabIdle

	if GrabIdle and GrabIdle.IsPlaying then
		GrabIdle:Stop()
	end

	if v86.Animations.WitherWakeup then
		v86.Animations.WitherWakeup:Play()
	else
		v86.Animations.Wakeup:Play()
	end

	v86.Animations.Idle:Play()
end
function t1.OnCharacterHit(s4: string, p10) -- line: 399
	-- upvalues: t3 (copy)
	local v93 = t3[s4]

	if not v93 then
		return
	end

	v93.IsWithered = false
	v93.WitherToken = nil

	if v93.WitherTimerConnection then
		v93.WitherTimerConnection:Disconnect()
		v93.WitherTimerConnection = nil
	end

	if v93.WitherTimerGui then
		v93.WitherTimerGui:Destroy()
		v93.WitherTimerGui = nil
	end

	local WitherStartup = v93.Animations.WitherStartup

	if WitherStartup and WitherStartup.IsPlaying then
		WitherStartup:Stop()
	end

	local WitherLoop = v93.Animations.WitherLoop

	if WitherLoop and WitherLoop.IsPlaying then
		WitherLoop:Stop()
	end

	v93.Animations.Idle:Stop()
	v93.Animations.GrabIdle:Play(0.05, 0.65, nil)
	v93.BezierEndpoint = p10:FindFirstChild("Head") or p10.PrimaryPart
end
function t1.OnReleased(s5: string, _) -- line: 413
	-- upvalues: t3 (copy)
	local v98 = t3[s5]

	if not v98 then
		return
	end

	if not v98.IsWithered then
		v98.Animations.Idle:Play()
	end

	v98.Animations.LetGo:Play()
	v98.Animations.GrabIdle:Stop(nil, 0.8, nil)
	v98.Animations.CooldownLoop.Looped = true
	v98.Animations.CooldownLoop:Play(0.5, 0.9)
	v98.BezierEndpoint = nil
end
function t1.OnAttack(s6: string, p12, t10: {[any]: any}, n7: number) -- line: 427
	-- upvalues: t3 (copy), Util (copy)
	local v103 = t3[s6]

	if not v103 then
		return
	end

	local Highlight = t10.Highlight

	Highlight.LineThickness = Highlight.LineThickness * 2
	game.TweenService:Create(t10.Highlight, TweenInfo.new(n7, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
		LineThickness = 0.001
	}):Play()

	if not Util:GetSettingValue("EpilepsyMode") then
		task.spawn(function() -- line: 436
			-- upvalues: t10 (copy)
			while t10.Part and t10.Part.Parent do
				t10.Highlight.Color3 = if t10.Highlight.Color3 ~= Color3.new(0.4, 0.025, 1) then Color3.new(0.4, 0.025, 1) else Color3.new(1, 0, 0.564706)
				task.wait(0.035)
			end
		end)
	end

	delay(n7 - 0.6, function() -- line: 444
		-- upvalues: v103 (copy)
		if v103.Model then
			if v103.IsWithered then
				v103.IsWithered = false
				v103.WitherToken = nil

				local v149 = v103

				if v149.WitherTimerConnection then
					v149.WitherTimerConnection:Disconnect()
					v149.WitherTimerConnection = nil
				end

				if v149.WitherTimerGui then
					v149.WitherTimerGui:Destroy()
					v149.WitherTimerGui = nil
				end

				local WitherStartup = v103.Animations.WitherStartup

				if WitherStartup and WitherStartup.IsPlaying then
					WitherStartup:Stop()
				end

				local WitherLoop = v103.Animations.WitherLoop

				if WitherLoop and WitherLoop.IsPlaying then
					WitherLoop:Stop()
				end

				if v103.Animations.WitherWakeup then
					v103.Animations.WitherWakeup:Play()
				else
					v103.Animations.Wakeup:Play()
				end
			else
				v103.Animations.Wakeup:Play()
			end

			task.wait(0.33)

			if not v103.Model then
				return
			end

			v103.Animations.Grab:Play(nil, 0.9, nil)
		end
	end)
	v103.TrackingCharacterActive = true
	v103.FaceRoot = p12.PrimaryPart
end
function t1.OnReady(s7: string, _: {[any]: any}, _: number) -- line: 475
	-- upvalues: t3 (copy)
	local v108 = t3[s7]

	if not v108 then
		return
	end

	v108.Animations.CooldownEnd:Play()
	v108.Animations.CooldownLoop:Stop()
end
function t1.OnMiss(s8: string, _: {[any]: any}, _: number) -- line: 483
	-- upvalues: t3 (copy)
	local v112 = t3[s8]

	if not v112 then
		return
	end

	v112.TrackingCharacterActive = nil
	v112.Animations.CooldownLoop.Looped = true
	v112.Animations.CooldownLoop:Play(0.5, 0.9)
end
function t1.DenyBuild(s9: string) -- line: 491
	-- upvalues: t3 (copy), TweenService (copy)
	local v114 = t3[s9]

	if not v114 then
		return
	end

	if v114.LocalHighlight and not v114.WarningFlag then
		v114.WarningFlag = true
		v114.OGColorFlag = v114.OGColorFlag or v114.LocalHighlight.FillColor

		local function alter(color3: Color3) -- line: 499
			return Color3.new(math.clamp(color3.R * 1.9, 0, 1), math.clamp(color3.G * 1.9, 0, 1), (math.clamp(color3.B * 1.9, 0, 1)))
		end

		local OGColorFlag = v114.OGColorFlag
		local color3 = Color3.new(math.clamp(OGColorFlag.R * 1.9, 0, 1), math.clamp(OGColorFlag.G * 1.9, 0, 1), (math.clamp(OGColorFlag.B * 1.9, 0, 1)))

		task.spawn(function() -- line: 504
			-- upvalues: v114 (copy), color3 (copy), TweenService (copy), OGColorFlag (copy)
			v114.LocalHighlight.FillColor = color3
			TweenService:Create(v114.LocalHighlight, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				FillColor = OGColorFlag
			}):Play()
			task.wait(0.6)

			if not v114.LocalHighlight then
				return
			end

			v114.WarningFlag = nil
		end)
	end
end
function t1.QTEBegan(s10: string, _) -- line: 515
	-- upvalues: t3 (copy), Sounds (copy), TweenService (copy)
	local v120 = t3[s10]

	if not v120 then
		return
	end

	warn("qte sequence activeated")

	if v120.IsLocal then
		warn("qte sequence playing 2")

		if v120.WarningSound then
			Sounds:Play(v120.WarningSound, {
				Volume = 1.1,
				RollOffMaxDistance = 10000,
				Position = v120.Model:GetPivot().Position
			})
		end

		if v120.LocalHighlight and not v120.WarningFlag then
			v120.WarningFlag = true
			v120.OGColorFlag = v120.OGColorFlag or v120.LocalHighlight.FillColor

			local function alter(color3: Color3) -- line: 529
				return Color3.new(math.clamp(color3.R * 1.9, 0, 1), math.clamp(color3.G * 1.9, 0, 1), (math.clamp(color3.B * 1.9, 0, 1)))
			end

			local OGColorFlag = v120.OGColorFlag
			local color3 = Color3.new(math.clamp(OGColorFlag.R * 1.9, 0, 1), math.clamp(OGColorFlag.G * 1.9, 0, 1), (math.clamp(OGColorFlag.B * 1.9, 0, 1)))

			task.spawn(function() -- line: 534
				-- upvalues: v120 (copy), color3 (copy), TweenService (copy), OGColorFlag (copy)
				for _ = 1, 2 do
					v120.LocalHighlight.FillColor = color3
					TweenService:Create(v120.LocalHighlight, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						FillColor = OGColorFlag
					}):Play()
					task.wait(0.6)

					if not v120.LocalHighlight then
						return
					end
				end

				v120.WarningFlag = nil
			end)
		end
	end
end
function t1.Destroy(s11: string) -- line: 548
	-- upvalues: t3 (copy), RunService (copy), TweenService (copy)
	local v125 = t3[s11]

	if not v125 then
		return
	end

	if v125.WitherTimerConnection then
		v125.WitherTimerConnection:Disconnect()
		v125.WitherTimerConnection = nil
	end

	if v125.WitherTimerGui then
		v125.WitherTimerGui:Destroy()
		v125.WitherTimerGui = nil
	end

	pcall(function() -- line: 553
		-- upvalues: v125 (copy), RunService (copy), TweenService (copy)
		v125.Animations.Die:Play()

		local elapsed = os.clock()
		local Model = v125.Model
		local u157 = nil

		u157 = RunService.RenderStepped:Connect(function() -- line: 558
			-- upvalues: elapsed (copy), u157 (ref), TweenService (copy), Model (copy)
			local v158 = os.clock() - elapsed

			if v158 >= 0.8 then
				if u157 then
					u157:Disconnect()
					u157 = nil
				end

				return
			end

			local Value = TweenService:GetValue(math.min(v158 / 0.7, 1), Enum.EasingStyle.Quart, Enum.EasingDirection.In)

			Model:ScaleTo((math.max((1 - Value) * 3.12, 0.01)))
		end)
		game.Debris:AddItem(Model, 0.9)
	end)

	if v125.Maid then
		v125.Maid:Destroy()
	end

	table.clear(v125)
	t3[s11] = nil
end

return t1
]========]},
{path=[========[
ReplicatedStorage/Systems/Player/Networks/ActorNetwork]========],before="36927:f121c34f:588ea04a",after="37477:0fa69603:3f1a6b86",source=[========[
require(game.ReplicatedStorage.GlobalTypes)

local t1 = {
	Connections = {},
	KillerIntros = {}
}
local TweenService = game:GetService("TweenService")

game:GetService("Debris")

local LocalPlayer = game.Players.LocalPlayer
local Network = require(game.ReplicatedStorage.Modules.Network)
local Actors = require(game.ReplicatedStorage.Modules.Actors)
local Util = require(game.ReplicatedStorage.Modules.Util)
local Sprinting = require(game.ReplicatedStorage.Systems.Character.Game.Sprinting)
local Statuses = require(game.ReplicatedStorage.Modules.Statuses)
local CharacterReplication = require(game.ReplicatedStorage.Systems.Player.Game.CharacterReplication)
local F6 = Enum.KeyCode.F6

local function changeProp(p1, p2, p3) -- line: 28
	if p3 ~= p1[p2] then
		p1[p2] = p3
	end
end

function t1.Start(_) -- line: 34
	-- upvalues: Network (copy), Actors (copy), Util (copy), t1 (copy), LocalPlayer (copy), Sprinting (copy), TweenService (copy), Statuses (copy), F6 (copy), CharacterReplication (copy)
	Network:SetConnection("ActorDestroyed", "REMOTE_EVENT", function(p5) -- line: 38
		-- upvalues: Actors (copy)
		local v20 = Actors.CurrentActors[p5]

		if v20 then
			for _, v in pairs({
				"Destroyed",
				"DestroyedPost"
			}) do
				if v20.CustomBehavior and v20.CustomBehavior[v] then
					v20.CustomBehavior[v](v20.CustomBehavior, v20)
				elseif v20.Behavior[v] then
					v20.Behavior[v](v20.Behavior, v20)
				end
			end

			task.spawn(function() -- line: 53
				-- upvalues: v20 (copy)
				if v20.ActorType:find("Killer") then
					local ChaseThemes = require(game.ReplicatedStorage.Systems.Character.Game.ChaseThemes)

					require(game.ReplicatedStorage.Systems.Character.Game.ChaseThemesKiller)
					ChaseThemes:KillerRemoved(v20)
				end
			end)
			Actors.__actorDestroyed:Fire(v20)
		end

		Actors.CurrentActors[p5] = nil
	end)
	Network:SetConnection("ActorCreated", "REMOTE_EVENT", function(p6) -- line: 72
		-- upvalues: Actors (copy), Util (copy), t1 (copy), LocalPlayer (copy), Network (copy), Sprinting (copy), TweenService (copy), Statuses (copy), F6 (copy), CharacterReplication (copy)
		local v24 = Actors:ApplySkinDataToActorInfo(p6)

		p6.CustomBehavior = v24 and (not not v24:FindFirstChild("Behavior") and require(v24.Behavior)) or {}
		Actors.CurrentActors[p6.Player] = p6
		Util:PreloadAssets(p6.Config)
		task.spawn(function() -- line: 84
			-- upvalues: p6 (copy)
			if p6.ActorType:find("Killer") then
				local ChaseThemes = require(game.ReplicatedStorage.Systems.Character.Game.ChaseThemes)
				local ChaseThemesKiller = require(game.ReplicatedStorage.Systems.Character.Game.ChaseThemesKiller)

				ChaseThemes:KillerAdded(p6)
				ChaseThemesKiller:KillerAdded(p6)
			end
		end)
		task.spawn(function() -- line: 94
			-- upvalues: p6 (copy), t1 (copy), Util (copy), Actors (copy), LocalPlayer (copy)
			for _, v in pairs({
				"Created",
				"CreatedPost"
			}) do
				if p6.CustomBehavior and p6.CustomBehavior[v] then
					p6.CustomBehavior[v](p6.CustomBehavior, p6)
				elseif p6.Behavior[v] then
					p6.Behavior[v](p6.Behavior, p6)
				end
			end

			if not p6.ActorType:find("Killer") then
				return
			end

			if p6.Config.IntroductionsDisabled then
				return
			end

			local Introduction = (p6.Config.Animations or {}).Introduction

			if #t1.KillerIntros >= 16 then
				table.clear(t1.KillerIntros)
			end

			table.insert(t1.KillerIntros, {
				PlayerName = tostring(p6.Player),
				KillerName = tostring(p6.Config.DisplayName or p6.ActorName)
			})

			if #t1.KillerIntros <= 1 then
				task.delay(7.5, function() -- line: 120
					-- upvalues: t1 (copy)
					table.clear(t1.KillerIntros)
				end)
			end

			local Initializer = require(game.ReplicatedStorage.Initializer)

			if p6.ActorName == "Azure" and p6.Config.AzureAnimationsOptional ~= false or #t1.KillerIntros > 1 or (Initializer.PlayerSettings and Initializer.PlayerSettings.SkipIntros and Initializer.PlayerSettings.SkipIntros.Value or not Introduction or not Introduction.KillerRig or not Introduction.CameraRig) then
				task.wait(0.5)
				Util:FadeOut({
					Time = 0.75
				})
				Util:CreateDisplayUI(t1.KillerIntros)

				return
			end

			if #t1.KillerIntros <= 1 then
				local n1 = 0

				if not p6.Rig.Parent or not p6.Rig:FindFirstChild("HumanoidRootPart") then
					repeat
						print(`waiting until { tostring(p6.Rig) } is ready to be accessed`)
						n1 += task.wait()
					until n1 >= 10 or p6.Rig.Parent and p6.Rig:FindFirstChild("HumanoidRootPart")
				end

				if n1 >= 10 then
					return
				end

				task.wait(0.1)

				local v67, v68, v69 = Actors:CreateCutsceneActor(p6, "Introduction")
				local v70 = p6.Config.ForcedIntroTime or v69.CameraRig.Length
				local Lighting = require(game.ReplicatedStorage.Modules.Schematics.Lighting)

				task.spawn(function() -- line: 150
					-- upvalues: Lighting (copy)
					local KillerCutsceneBackground = workspace.Misc:WaitForChild("KillerCutsceneBackground", 5)
					local v127 = KillerCutsceneBackground and KillerCutsceneBackground:WaitForChild("Lighting", 5)

					if v127 then
						Lighting.isInCutscene = true
						Lighting:SetCustomLighting(v127)
					end
				end)

				local clone = nil

				task.spawn(function() -- line: 160
					-- upvalues: clone (ref)
					local KillerCutsceneBackground = workspace.Misc:WaitForChild("KillerCutsceneBackground", 5)
					local v129 = KillerCutsceneBackground and KillerCutsceneBackground:WaitForChild("Materials", 5)

					if v129 then
						clone = v129:Clone()
						clone.Parent = game:GetService("MaterialService")
					end
				end)
				task.spawn(function() -- line: 170
					-- upvalues: p6 (copy)
					local Sounds = require(game.ReplicatedStorage.Modules.Sounds)

					Sounds:Play(p6.Config.Sounds.Introduction)
					Sounds:PlayVoiceline(p6, "Introduction", {
						Priority = 10,
						Parent = workspace:FindFirstChild("Sounds") or workspace.Misc
					})
				end)
				task.spawn(function() -- line: 177
					-- upvalues: p6 (copy), v69 (copy), v67 (copy), v70 (copy), t1 (copy)
					if not p6.Cache then
						p6.Cache = {}
					end

					p6.Cache.IntroductionKillerTrack = v69.KillerRig
					p6.Cache.IntroductionCameraTrack = v69.CameraRig

					if p6.CustomBehavior.OnIntroduction then
						p6.CustomBehavior:OnIntroduction(p6, v67, v70, t1.KillerIntros)

						return
					end

					if p6.Behavior.OnIntroduction then
						p6.Behavior:OnIntroduction(p6, v67, v70, t1.KillerIntros)
					end
				end)
				Util:FadeOut({
					Time = 0.35
				})
				LocalPlayer.PlayerGui.MainUI.Enabled = false
				LocalPlayer.PlayerGui.TemporaryUI.Enabled = false
				task.delay(0.75, function() -- line: 197
					-- upvalues: Util (copy), t1 (copy)
					Util:CreateDisplayUI(t1.KillerIntros)
				end)
				task.delay(v70 - 0.5, function() -- line: 202
					-- upvalues: Util (copy)
					Util:FadeIn({
						TweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
					})
				end)
				task.delay(v70, function() -- line: 207
					-- upvalues: v68 (copy), v67 (copy), Lighting (copy), clone (ref)
					workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
					v68:Destroy()
					v67:Destroy()
					Lighting.isInCutscene = false
					Lighting:SetAsCurrentLighting()

					if clone then
						clone:Destroy()
					end
				end)
				task.delay(v70 + 0.25, function() -- line: 220
					-- upvalues: LocalPlayer (copy), Util (copy)
					LocalPlayer.PlayerGui.MainUI.Enabled = true
					LocalPlayer.PlayerGui.TemporaryUI.Enabled = true
					Util:FadeOut({
						Time = 0.75
					})
				end)
			end
		end)
		task.spawn(function() -- line: 229
			-- upvalues: p6 (copy), LocalPlayer (copy), t1 (copy), Util (copy), Network (copy), Sprinting (copy), TweenService (copy), Statuses (copy), F6 (copy), Actors (copy), CharacterReplication (copy)
			if p6.Player ~= LocalPlayer then
				return
			end

			t1:Destroy()
			p6.Animations = {}
            local azureAnimations = p6.ActorName == "Azure" and require(game.ReplicatedStorage.Assets.Killers.Azure.Behavior.OptionalAnimations)
            local function loadMovementAnimation(id, name)
                if azureAnimations then return azureAnimations.Load(Util, p6.Rig, id, false, name) end
                return Util:LoadAnimationFromID(p6.Rig, id)
            end

			for k, v in pairs(p6.Config.Animations or {}) do
				if typeof(v) == "string" then
					p6.Animations[k] = loadMovementAnimation(v, k)
				elseif typeof(v) == "table" then
					for k2, v2 in pairs(v) do
						if typeof(v2) == "string" then
							if not p6.Animations[k] then
								p6.Animations[k] = {}
							end

							p6.Animations[k][k2] = loadMovementAnimation(v2, k2)
						end
					end
				end
			end

            if azureAnimations then p6.Animations = azureAnimations.Table(p6.Animations) end

			local t2 = {}

			local function stopAnims(p7) -- line: 252
				-- upvalues: t2 (copy)
				for _, v in pairs(t2) do
					v:Stop(p7)
				end

				table.clear(t2)
			end

			p6.Animations.Idle.Priority = Enum.AnimationPriority.Core
			p6.Animations.Walk.Priority = Enum.AnimationPriority.Core
			p6.Animations.Run.Priority = Enum.AnimationPriority.Core
			p6.Animations.Idle:Play(0)
			p6.Animations.Idle.Looped = true
			table.insert(t2, p6.Animations.Idle)

			local Footsteps = p6.Config.Sounds.Footsteps
			local u80 = false
			local n2 = 0
			local elapsed = os.clock()

			for k, v in pairs(p6.Animations) do
				if k:find("Walk") or k:find("Run") then
					v.KeyframeReached:Connect(function(keyframe) -- line: 274
						-- upvalues: LocalPlayer (copy), elapsed (ref), u80 (ref), Footsteps (copy), n2 (ref), Network (copy)
						if keyframe == "Footstep" and (LocalPlayer.Character.Humanoid.FloorMaterial ~= Enum.Material.Air and LocalPlayer.Character.Humanoid.FloorMaterial ~= Enum.Material.Neon and LocalPlayer.Character.PrimaryPart.Velocity.Magnitude > 3 and not LocalPlayer.Character.PrimaryPart.Anchored and not LocalPlayer.Character:GetAttribute("FootstepsMuted")) then
							if os.clock() - elapsed < 0.05 then
								return
							end

							if u80 then
								u80 = false

								return
							end

							if Footsteps then
								n2 = (n2 + 1) % #Footsteps
							end

							Network:FireServerConnection("FootSP", "UREMOTE_EVENT", Footsteps and n2)
							elapsed = os.clock()
						end
					end)
				end
			end

			LocalPlayer.Character:GetAttributeChangedSignal("Ragdolling"):Connect(function() -- line: 297
				-- upvalues: LocalPlayer (copy), stopAnims (copy), p6 (copy), t2 (copy)
				if LocalPlayer.Character:GetAttribute("Ragdolling") then
					stopAnims(0.1)

					return
				end

				local Humanoid = LocalPlayer.Character.Humanoid
				local v136 = Humanoid.Health - (Humanoid:GetAttribute("FakeDamage") or 0)
				local v137 = p6.AnimationType or (not (v136 <= Humanoid.MaxHealth / 2) and "" or "Injured")
				local v138 = p6.Animations[`{ v137 }Idle`]

				if v138 then
					v138:Play(0.1)
					table.insert(t2, v138)
				end
			end)

			local u85 = false
			local s1 = ""

			local function updateMovementAnims(p8) -- line: 316
				-- upvalues: LocalPlayer (copy), p6 (copy), s1 (ref), stopAnims (copy), u80 (ref), Sprinting (copy), u85 (ref), t2 (copy)
				if LocalPlayer.Character:GetAttribute("Ragdolling") then
					return
				end

				if p6 and p6.AnimationType == false then
					if s1 then
						stopAnims(0.15)
					end

					s1 = nil

					return
				end

				local Humanoid = LocalPlayer.Character.Humanoid
				local v141 = Humanoid.Health - (Humanoid:GetAttribute("FakeDamage") or 0)
				local v142 = p6.AnimationType or (not (v141 <= Humanoid.MaxHealth / 2) and "" or "Injured")
				local v143 = p6.Animations[`{ v142 }Idle`]
				local v144 = p6.Animations[`{ v142 }Walk`]
				local v145 = p6.Animations[`{ v142 }Run`]
				local v146 = p6.MovementAnimSpeed or p6.Config.MovementAnimSpeed

				if v146 then
					v144:AdjustSpeed(v146)
					v145:AdjustSpeed(v146)
				else
					v144:AdjustSpeed(p8 / (tonumber(p6.Config.Speed) and tonumber(p6.Config.Speed) / 1.2 or 10))
					v145:AdjustSpeed(p8 / (tonumber(p6.Config.SprintSpeed) or 28))
				end

				if p8 > 0.03 and (v142 ~= s1 or not p6.Moving) then
					u80 = true
					p6.Moving = true

					if Sprinting.IsSprinting then
						stopAnims(0.15)
						v145:Play(0.15)
						u85 = true
						table.insert(t2, v145)
					else
						stopAnims(0.15)
						v144:Play(0.15)
						u85 = false
						table.insert(t2, v144)
					end
				elseif p8 < 0.03 then
					p6.Moving = nil
					u85 = false
					stopAnims(0.1)
					v143:Play(0.1)
					table.insert(t2, v143)
				end

				s1 = v142
			end

			LocalPlayer.Character.Humanoid.StateChanged:Connect(function(_, newState) -- line: 377
				-- upvalues: updateMovementAnims (copy)
				if newState == Enum.HumanoidStateType.Landed then
					updateMovementAnims(0)
				end
			end)
			LocalPlayer.Character.Humanoid.Running:Connect(updateMovementAnims)

			local function updateIdleAnim() -- line: 384
				-- upvalues: LocalPlayer (copy), p6 (copy), stopAnims (copy), t2 (copy), s1 (ref)
				if LocalPlayer.Character:GetAttribute("Ragdolling") then
					return
				end

				if p6.Moving then
					return
				end

				if p6 and p6.AnimationType == false then
					return
				end

				local Humanoid = LocalPlayer.Character.Humanoid
				local v150 = Humanoid.Health - (Humanoid:GetAttribute("FakeDamage") or 0)
				local v151 = p6.AnimationType or (not (v150 <= Humanoid.MaxHealth / 2) and "" or "Injured")
				local v152 = p6.Animations[`{ v151 }Idle`]

				if v152 and v152.IsPlaying then
					return
				end

				stopAnims(0.1)

				if v152 then
					v152:Play(0.1)
					table.insert(t2, v152)
				end

				s1 = v151
			end

			LocalPlayer.Character.Humanoid.HealthChanged:Connect(function() -- line: 414
				-- upvalues: p6 (copy), LocalPlayer (copy), updateMovementAnims (copy), updateIdleAnim (copy)
				if p6.Moving then
					local Character = LocalPlayer.Character
					local v154 = Character and Character.PrimaryPart

					if not v154 or not Character:HasTag("Replicating") then
						return
					end

					updateMovementAnims(v154.AssemblyLinearVelocity.Magnitude)

					return
				end

				updateIdleAnim()
			end)
			task.spawn(function() -- line: 429
				-- upvalues: Sprinting (copy), p6 (copy), LocalPlayer (copy), t1 (copy), Util (copy), TweenService (copy), u85 (ref), u80 (ref), stopAnims (copy), t2 (copy)
				local n3 = 0

				if Sprinting.Character ~= p6.Rig or not Sprinting.DefaultsSet then
					repeat
						n3 += game["Run Service"].Heartbeat:Wait()
					until Sprinting.Character == p6.Rig and Sprinting.DefaultsSet or n3 >= 10
				end

				Sprinting.SprintSpeed = p6.Config.SprintSpeed or Sprinting.SprintSpeed
				Sprinting.StaminaLoss = p6.Config.StaminaLoss or Sprinting.StaminaLoss
				Sprinting.StaminaGain = p6.Config.StaminaGain or Sprinting.StaminaGain
				Sprinting.MaxStamina = p6.Config.MaxStamina or Sprinting.MaxStamina
				Sprinting.MinStamina = p6.Config.MinStamina or Sprinting.MinStamina
				Sprinting.Stamina = Sprinting.MaxStamina
				Sprinting.__staminaChangedEvent:Fire(Sprinting.MaxStamina)

				if Sprinting.MaxStamina ~= Sprinting.MaxStamina or Sprinting.Stamina ~= Sprinting.Stamina then
					task.spawn(function() -- line: 449
						-- upvalues: LocalPlayer (copy)
						LocalPlayer:Kick("\n\nForsakenCheatKiller 000:\nStamina exceeds max possible cap\n")
					end)

					while true do
					end
				end

				local function canReachPosition(p10, p11, p12) -- line: 456
					tick()

					local v231 = game:GetService("PathfindingService"):CreatePath({
						AgentCanJump = false,
						WaypointSpacing = 1e999
					})

					v231:ComputeAsync(p10, p11)

					if v231.Status ~= Enum.PathStatus.Success then
						return nil
					end

					local Waypoints = v231:GetWaypoints()
					local n4 = 0

					for i = 2, #Waypoints do
						n4 += (Waypoints[i].Position - Waypoints[i - 1].Position).Magnitude
					end

					return n4 < p12
				end

				local v157 = p6.Rig and p6.Rig.PrimaryPart

				if p6.ActorType:find("Killer") and v157 then
					local n5 = 0
					local u159 = nil

					t1.Connections.StaminaDrainConnection = game["Run Service"].RenderStepped:Connect(function(dt) -- line: 499
						-- upvalues: n5 (ref), Util (copy), v157 (copy), Sprinting (copy), u159 (ref), TweenService (copy), p6 (copy)
						n5 += dt

						if n5 >= 0.1 then
							n5 = 0

							local ClosestPlayerFromPosition = Util:GetClosestPlayerFromPosition(v157.Position, {
								MaxDistance = 85,
								PlayerSelection = "Survivors",
								OverrideUndetectable = true,
								VerticalMultiplier = 3
							})
							local v237 = ClosestPlayerFromPosition and ClosestPlayerFromPosition.PrimaryPart

							if v237 and Sprinting.StaminaLossDisabled then
								Sprinting.StaminaLossDisabled = false

								if u159 then
									TweenService:Create(u159, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
										Value = 1
									}):Play()
									task.delay(1, function() -- line: 516
										-- upvalues: Sprinting (copy), u159 (ref)
										if Sprinting.StaminaLossDisabled then
											return
										end

										if u159 and u159.Parent then
											u159:Destroy()
											u159 = nil
										end
									end)

									return
								end
							elseif not v237 and not Sprinting.StaminaLossDisabled then
								Sprinting.StaminaLossDisabled = true

								if u159 then
									u159:Destroy()
									u159 = nil
								end

								u159 = Util:CreateSpeedMultiplier(p6.Player, 1.1, "KillerPassiveBoost")
							end
						end
					end)
				end

				t1.Connections.SprintingConnection = Sprinting.SprintToggled:Connect(function(p13) -- line: 543
					-- upvalues: Util (copy), p6 (copy), u85 (ref), u80 (ref), LocalPlayer (copy), stopAnims (copy), t2 (copy)
					if not Util:IsAlive(p6 and p6.Rig) then
						return
					end

					if p6.Moving and p13 ~= u85 then
						u80 = true

						local Humanoid = LocalPlayer.Character.Humanoid
						local v240 = p6.AnimationType or (not (Humanoid.Health - (Humanoid:GetAttribute("FakeDamage") or 0) <= LocalPlayer.Character.Humanoid.MaxHealth / 2) and "" or "Injured")
						local v241 = p6.Animations[`{ v240 }Walk`]
						local v242 = p6.Animations[`{ v240 }Run`]

						stopAnims(0.3)

						if p13 then
							u85 = true
							v242:Play(0.3)
							table.insert(t2, v242)

							return
						end

						u85 = false
						v241:Play(0.3)
						table.insert(t2, v241)
					end
				end)

				local SprintingButton = LocalPlayer.PlayerGui.MainUI:FindFirstChild("SprintingButton")
				local ShiftLockButton = LocalPlayer.PlayerGui.MainUI:FindFirstChild("ShiftLockButton")

				if SprintingButton and SprintingButton.Visible then
					SprintingButton.AnchorPoint = Vector2.new(0, 0)
					SprintingButton.Size = UDim2.fromOffset(125, 125)
					SprintingButton.Position = UDim2.new(1, -160, 1, -170)
					ShiftLockButton.Position = UDim2.new(1, -135, 1, -4)

					local AbilityContainer = LocalPlayer.PlayerGui.MainUI:WaitForChild("AbilityContainer")

					AbilityContainer.AnchorPoint = SprintingButton.AnchorPoint
					AbilityContainer.Position = SprintingButton.Position
					AbilityContainer.Size = SprintingButton.Size + UDim2.fromScale(0.075, 0.075)
					Instance.new("UIAspectRatioConstraint").Parent = AbilityContainer
				end
			end)

			local clone = game.ReplicatedStorage.Systems.Player.UI.CustomBackpack.Backpack:Clone()

			clone.Name = "AbilityContainer"
			clone.Parent = LocalPlayer.PlayerGui.MainUI
			t1.AbilityHotbar = clone

			local v90 = p6.Behavior.Abilities or {}

			for k, v in pairs(p6.CustomBehavior.Abilities or {}) do
				v90[k] = v
			end

			p6.Cooldowns = {}
			t1.Connections.CooldownConnection = game["Run Service"].RenderStepped:Connect(function(dt) -- line: 600
				-- upvalues: Statuses (copy), LocalPlayer (copy), v90 (copy), p6 (copy), clone (copy)
				local v164 = Statuses:PlayerHasStatus(LocalPlayer, "Hacked") and true

				for k, _ in pairs(v90) do
					local v167 = p6.Cooldowns[k]
					local v168 = v90[k] or {}
					local k3 = clone:FindFirstChild(k)
					local v170 = v168.CurrentCharges and v168.CurrentCharges > 0
					local v171 = v170 and v168.NameCharged or (v168.Name or k:gsub("(%l)(%u)", "%1 %2"))
					local v172 = v170 and v168.IconCharged or (v168.Icon or "rbxassetid://10724129940")
					local FlavorText = v168.FlavorText
					local v174 = v168.ChargeDuration and v168.CurrentRecharge or v168.Charges and (v168.CurrentCharges and (v168.Recharge and v168.CurrentCharges < v168.Charges))
					local v175 = v164 and v168.KeybindType ~= "MainAbility"

					if v172 ~= k3.Image then
						k3.Image = v172
					end

					local Top = k3.Clipping.Top

					if v172 ~= Top.Image then
						Top.Image = v172
					end

					local AbilityName = k3.AbilityName

					if v171 ~= AbilityName.Text then
						AbilityName.Text = v171
					end

					local FlavorText2 = k3.FlavorText
					local v179 = not not FlavorText

					if v179 ~= FlavorText2.Visible then
						FlavorText2.Visible = v179
					end

					local FlavorText3 = k3.FlavorText
					local v181 = FlavorText or ""

					if v181 ~= FlavorText3.Text then
						FlavorText3.Text = v181
					end

					if v167 then
						local Duration = v167.Duration
						local TimePast = v167.TimePast
						local v184 = math.clamp(TimePast / Duration, 0, 1)
						local v185 = Duration - TimePast

						if v184 >= 1 and not v174 then
							p6.Cooldowns[k] = nil
						end

						local v186 = if v184 ~= 0 then 1 / v184 else 0

						if k3 and not v168.Disabled then
							local Clipping = k3.Clipping
							local uDim2 = UDim2.fromScale(1, v184)

							if uDim2 ~= Clipping.Size then
								Clipping.Size = uDim2
							end

							local Top2 = k3.Clipping.Top
							local uDim2_2 = UDim2.fromScale(1, v186)

							if uDim2_2 ~= Top2.Size then
								Top2.Size = uDim2_2
							end

							local CooldownTime = k3.CooldownTime
							local v192 = if not (v184 >= 1) then `{ v185 < 10 and string.format("%.1f", Duration - TimePast) or math.round(v185) }` else ""

							if v192 ~= CooldownTime.Text then
								CooldownTime.Text = v192
							end
						end

						if not v175 then
							v167.TimePast = v167.TimePast + dt
						end
					end

					if v174 then
						if v168.ChargeDuration and v168.CurrentRecharge then
							if v168.CurrentRecharge < v168.ChargeDuration and v174 then
								local v193 = v168.RechargeInverted and 1 - v168.CurrentRecharge / v168.ChargeDuration or v168.CurrentRecharge / v168.ChargeDuration
								local Fill = k3.Charges.Recharge.Fill
								local uDim2 = UDim2.fromScale(v193, 1)

								if uDim2 ~= Fill.Size then
									Fill.Size = uDim2
								end

								local Recharge = k3.Charges.Recharge

								if Recharge.Visible ~= true then
									Recharge.Visible = true
								end

								local FillColor = v168.FillColor

								if FillColor then
									local Fill2 = k3.Charges.Recharge.Fill

									if FillColor ~= Fill2.BackgroundColor3 then
										Fill2.BackgroundColor3 = FillColor
									end
								end

								if not v175 then
									v168.CurrentRecharge = v168.CurrentRecharge + dt
								end
							else
								local Recharge = k3.Charges.Recharge

								if Recharge.Visible ~= false then
									Recharge.Visible = false
								end
							end
						else
							local Recharge = k3.Charges.Recharge

							if Recharge.Visible ~= false then
								Recharge.Visible = false
							end
						end
					else
						local Recharge = k3.Charges.Recharge

						if Recharge.Visible ~= false then
							Recharge.Visible = false
						end
					end
				end
			end)

			if game.PlaceId == 92145853615773 then
				t1.Connections.DisableUIConnection = game.UserInputService.InputBegan:Connect(function(input, gameProcessed: boolean) -- line: 682
					-- upvalues: F6 (copy), LocalPlayer (copy)
					if gameProcessed or input.KeyCode ~= F6 then
						return
					end

					for _, child in (LocalPlayer.PlayerGui:GetChildren()) do
						if child:IsA("ScreenGui") then
							child.Enabled = not child.Enabled
						end
					end
				end)
			end

			local clone2 = nil
			local Device = require(game.ReplicatedStorage.Modules.Device)

			if Device:GetPlayerDevice() == "Mobile" then
				local UIListLayout = clone:FindFirstChild("UIListLayout")

				if UIListLayout then
					UIListLayout:Destroy()
				end

				clone2 = script.ButtonPath:Clone()
				clone2.Parent = clone
			end

			p6.HeldAbilities = {}

			local Initializer = require(game.ReplicatedStorage.Initializer)
			local Config = p6.Config

			for k, v in pairs(v90 or {}) do
				local v100 = Config and Config[`{ k }HoldTime`]
				local v101 = game.Players.LocalPlayer:GetAttribute("Device") or "PC"
				local v102 = if not v.DeviceToButtonType then v.ButtonType or "Default" else v.DeviceToButtonType[v101] or "Default"
				local v103 = Config and Config[`{ k }SensitiveButton`] or (v.Sensitive or v102 == "Sensitive")
				local v104 = Config and Config[`{ k }ToggleButton`] or (v.Toggle or v102 == "Toggle")
				local vName = v.Name

				local function useAbility() -- line: 728
					-- upvalues: Network (copy), k (copy)
					Network:FireServerConnection("UseActorAbility", "REMOTE_EVENT", k)
				end

				local clone3 = game.ReplicatedStorage.Assets.UI.AbilityIcon:Clone()

				clone3.Clipping.Top.Image = v.Icon or "rbxassetid://114519105023135"
				clone3.Image = v.Icon or "rbxassetid://114519105023135"
				clone3.LayoutOrder = v.LayoutOrder
				clone3.AbilityName.Text = vName or k:gsub("(%l)(%u)", "%1 %2")
				clone3.Name = k
				clone3.Parent = clone
				clone3.MouseButton1Click:Connect(function() -- line: 741
					-- upvalues: v104 (copy), p6 (copy), k (copy), Network (copy), v100 (copy), v103 (copy)
					if v104 then
						p6.HeldAbilities[k] = not p6.HeldAbilities[k]

						if p6.HeldAbilities[k] then
							Network:FireServerConnection("UseActorAbility", "REMOTE_EVENT", k)

							return
						end
					elseif not v100 and not v103 then
						Network:FireServerConnection("UseActorAbility", "REMOTE_EVENT", k)
					end
				end)

				if not v104 then
					clone3.MouseButton1Down:Connect(function() -- line: 754
						-- upvalues: p6 (copy), k (copy), v100 (copy), v103 (copy), Network (copy)
						p6.HeldAbilities[k] = true

						if v100 or v103 then
							Network:FireServerConnection("UseActorAbility", "REMOTE_EVENT", k)
						end
					end)
					clone3.MouseButton1Up:Connect(function() -- line: 760
						-- upvalues: p6 (copy), k (copy)
						p6.HeldAbilities[k] = nil
					end)
				end

				if v.Charges then
					local v108 = v.Charges > 0
					local v109 = v108 and v.NameCharged or (v.Name or k:gsub("(%l)(%u)", "%1 %2"))
					local v110 = v108 and v.IconCharged or v.Icon

					clone3.Image = v110
					clone3.Clipping.Top.Image = v110
					clone3.AbilityName.Text = v109
					clone3.Charges.Text = tostring(v.Charges)

					if v.Charges <= 0 and not v.ChargesOptional and not v.ChargesDisabled then
						Util:ToggleLockForAbilityIcon(k, "NoCharges", true)
					end
				end

				if clone2 then
					clone3.KeybindName.Visible = false
					clone3.AnchorPoint = Vector2.new(0.5, 0.5)
					clone3.Size = UDim2.fromScale(0.45, 0.45)
				end

				local Backpack = LocalPlayer.PlayerGui.MainUI:FindFirstChild("Backpack")

				if Backpack and not clone2 then
					Backpack.Position = UDim2.new(1, -20, 0.9, -55)
				end

				local t3 = {}
				local KeybindType = v.KeybindType

				if KeybindType then
					for _, v3 in pairs({
						Initializer.PlayerSettings[KeybindType],
						Initializer.PlayerSettings[`{ KeybindType }~Console`]
					}) do
						table.insert(t3, v3.Value)
					end
				end

				local t4 = {
					{
						"MouseButton1",
						"LMB"
					},
					{
						"MouseButton2",
						"RMB"
					},
					{
						"MouseButton3",
						"MMB"
					},
					{
						"Button",
						"",
						true
					}
				}

				local function updateKeybindTexts() -- line: 813
					-- upvalues: KeybindType (copy), clone3 (copy), v (copy), v101 (copy), Device (copy), Initializer (copy), t4 (copy)
					if not KeybindType or KeybindType == "Passive" then
						clone3.KeybindName.Text = "[PASSIVE]"

						return
					end

					local v206 = v.FlavorText or v.DeviceToFlavorText and v.DeviceToFlavorText[v101]
					local v207 = Device:GetPlayerDevice() == "PC" and Initializer.PlayerSettings[KeybindType] or Device:GetPlayerDevice() == "Console" and Initializer.PlayerSettings[`{ KeybindType }~Console`]

					if not v207 then
						clone3.KeybindName.Text = v206 or ""

						return
					end

					local str = tostring(v207.Value)

					for _, v4 in pairs(t4) do
						local v211 = v4[1]
						local v212 = v4[2]

						if not v4[3] or Device:GetPlayerDevice() == "Console" then
							str = str:gsub(v211, v212)
						end
					end

					clone3.KeybindName.Text = str:gsub("(%l)(%u)", "%1 %2")
					clone3.FlavorText.Text = v206 or ""
				end

				updateKeybindTexts()
				t1.Connections[`{ k }KeybindUpdatedConnection`] = Device.Changed:Connect(updateKeybindTexts)

				local Emotes = require(game.ReplicatedStorage.Systems.Character.Game.Emotes)

				local function inputProcessedChecks(p14) -- line: 839
					-- upvalues: Emotes (copy)
					return Emotes.EmoteMenu.CurrentlyVisible and p14.UserInputType == Enum.UserInputType.MouseButton1
				end

				local v120 = Device:GetPlayerDevice() == "Console" and v104

				t1.Connections[`{ k }InputConnection`] = game.UserInputService.InputBegan:Connect(function(input, gameProcessed) -- line: 846
					-- upvalues: t3 (copy), Emotes (copy), v120 (copy), p6 (copy), k (copy), Network (copy)
					if gameProcessed then
						return
					end

					if (table.find(t3, input.KeyCode.Name) or table.find(t3, input.UserInputType.Name)) and (not Emotes.EmoteMenu.CurrentlyVisible or input.UserInputType ~= Enum.UserInputType.MouseButton1) then
						if v120 then
							p6.HeldAbilities[k] = not p6.HeldAbilities[k]

							if p6.HeldAbilities[k] then
								Network:FireServerConnection("UseActorAbility", "REMOTE_EVENT", k)

								return
							end
						else
							p6.HeldAbilities[k] = true
							Network:FireServerConnection("UseActorAbility", "REMOTE_EVENT", k)
						end
					end
				end)
				t1.Connections[`{ k }InputConnectionEnd`] = game.UserInputService.InputEnded:Connect(function(input, gameProcessed) -- line: 864
					-- upvalues: v120 (copy), t3 (copy), p6 (copy), k (copy)
					if gameProcessed or v120 then
						return
					end

					if table.find(t3, input.KeyCode.Name) or table.find(t3, input.UserInputType.Name) then
						p6.HeldAbilities[k] = nil
					end
				end)
			end

			local function onCameraViewportChanged() -- line: 872
			end

			task.delay(0.25, function() -- line: 877
				-- upvalues: clone2 (ref), clone (copy)
				while clone2 and clone2.Parent and clone.Parent do
					clone2.Thickness = clone2.Thickness ~= 2 and 2 or 1

					local _ = #clone2:GetControlPoints()
					local t5 = {}

					for _, child in clone:GetChildren() do
						if child:IsA("GuiObject") then
							table.insert(t5, child)
						end
					end

					table.sort(t5, function(p15, p16) -- line: 891
						return p15.LayoutOrder < p16.LayoutOrder
					end)

					for k, v in pairs(t5) do
						local v224 = k / (#t5 + 1)

						v.Position = clone2:GetPositionOnCurveArcLength(v224)
					end

					task.wait(1)
				end
			end)

			local n6 = 0.016666666666666666
			local Character = LocalPlayer.Character

			table.insert(t1.Connections, game["Run Service"].Heartbeat:Connect(function(dt) -- line: 905
				-- upvalues: Actors (copy), LocalPlayer (copy), Util (copy), Character (copy), n6 (ref), Network (copy), CharacterReplication (copy)
				if not workspace:GetAttribute("ExperimentalHitboxes") then
					return
				end

				local v226 = Actors.CurrentActors[LocalPlayer]

				if not v226 then
					return
				end

				if not v226 or not Util:IsAlive(Character) then
					return
				end

				n6 += dt

				if n6 < 0.016666666666666666 then
					return
				end

				n6 = 0

				local AssemblyLinearVelocity = Character.PrimaryPart.AssemblyLinearVelocity

				Network:FireServerConnection("UpdateCharacterPosition", "UREMOTE_EVENT", CharacterReplication.Serialize(Character.PrimaryPart.CFrame, AssemblyLinearVelocity))
			end))

			for _, v in pairs({
				"ActorCreated",
				"ActorCreatedPost"
			}) do
				if p6.CustomBehavior and p6.CustomBehavior[v] then
					p6.CustomBehavior[v](p6.CustomBehavior, p6)
				elseif p6.Behavior[v] then
					p6.Behavior[v](p6.Behavior, p6)
				end
			end
		end)
		task.defer(Util.FixCharacter, Util, p6.Rig, p6.ActorType .. "s")
		Actors.__actorCreated:Fire(p6)
	end)
	Network:SetConnection("UpdateAbilityCharges", "REMOTE_EVENT", function(p17, p18, p19) -- line: 942
		-- upvalues: Actors (copy), LocalPlayer (copy), t1 (copy), Util (copy)
		local v28 = Actors.CurrentActors[LocalPlayer]

		if not v28 then
			return
		end

		local v29 = v28.CustomBehavior.Abilities or {}
		local v30 = v28.Behavior.Abilities or {}
		local v31 = v29[p17] or v30[p17]
		local v32 = t1.AbilityHotbar and t1.AbilityHotbar:FindFirstChild(p17)
		local v33 = v28 and (v28.Cooldowns and v28.Cooldowns[p17])

		if not v31 then
			warn(`[{ tostring(script) }]: Ability { v31 } doesn't exist`)

			return
		end

		if v31 and v32 then
			v31.CurrentCharges = p18

			if v31.Recharge and p19 then
				v31.ChargeDuration = v31.Recharge
				v31.CurrentRecharge = typeof(p19) ~= "number" and 0 or p19
			end

			if p18 <= 0 and not v31.ChargesOptional and not v31.ChargesDisabled then
				v31.Disabled = true
				v32.Clipping.Size = UDim2.fromScale(1, 0)
				v32.Clipping.Top.Size = UDim2.fromScale(1, 0)
				v32.Charges.Text = tostring(p18)
				v32.CooldownTime.Text = ""
				Util:ToggleLockForAbilityIcon(p17, "NoCharges", true)

				return
			end

			v31.Disabled = false
			v32.Clipping.Size = v33 and v32.Clipping.Size or UDim2.fromScale(1, 1)
			v32.Clipping.Top.Size = v33 and v32.Clipping.Top.Size or UDim2.fromScale(1, 1)
			v32.Charges.Text = tostring(p18)
			v32.CooldownTime.Text = ""
			Util:ToggleLockForAbilityIcon(p17, "NoCharges", false)
		end
	end)
	Network:SetConnection("OnExecutionClientAsync", "REMOTE_EVENT", function(p20) -- line: 982
		-- upvalues: Actors (copy), LocalPlayer (copy)
		local v35 = Actors.CurrentActors[LocalPlayer]

		if not v35 then
			return
		end

		local v36 = v35.CustomBehavior.OnExecutionClient or nil
		local v37 = v35.Behavior.OnExecutionClient or nil
		local v38 = v36 or v37

		if v38 then
			pcall(v38, v35.Behavior, v35, p20)
		end
	end)
	Network:SetConnection("UpdateAbilityCooldown", "REMOTE_EVENT", function(p21, p22) -- line: 994
		-- upvalues: Actors (copy), LocalPlayer (copy)
		if workspace:GetAttribute("CooldownsDisabled") then
			return
		end

		local v41 = Actors.CurrentActors[LocalPlayer]

		if not v41 then
			return
		end

		local v42 = v41.CustomBehavior.Abilities or {}
		local v43 = v41.Behavior.Abilities or {}

		if (v42[p21] or v43[p21]) and v41.Cooldowns then
			if p22 < 0 then
				if v41.Cooldowns[p21] then
					local v44 = v41.Cooldowns[p21]

					v44.TimePast = v44.TimePast + math.abs(p22)

					return
				end
			else
				v41.Cooldowns[p21] = {
					TimePast = 0,
					Duration = p22
				}
			end
		end
	end)
	Network:SetConnection("UseActorAbility", "REMOTE_EVENT", function(p23, p24) -- line: 1016
		-- upvalues: Actors (copy), LocalPlayer (copy), Network (copy)
		local v47 = Actors.CurrentActors[LocalPlayer]

		if not v47 then
			return
		end

		local v48 = v47.CustomBehavior.Abilities or {}
		local Config = v47.Config
		local v50 = v47.Behavior.Abilities or {}
		local v51 = v48[p23] or v50[p23]
		local v52 = Config and Config[`{ p23 }HoldTime`]
		local v53 = not not v52 and (typeof(p24) ~= "table" or typeof(p24) == "table" and (not p24.ChargeTime or false))
		local num = tonumber(p24 and (typeof(p24) == "table" and p24.Cooldown) or (typeof(v51.Cooldown) == "function" and v51.Cooldown(v47, p23) or (v51.Cooldown or v47.Config[`{ p23 }Cooldown`])))

		if typeof(p24) == "table" and p24.Cancelled then
			num = 0
		end

		if p24 == "Cancelled" then
			num = 0
		end

		if v53 then
			num = 0
		end

		if num and num > 0 and ((not v47.Cooldowns[p23] or not (v47.Cooldowns[p23].TimePast <= 0.025)) and not workspace:GetAttribute("CooldownsDisabled")) then
			v47.Cooldowns[p23] = {
				TimePast = 0,
				Duration = num
			}
		end

		v51.Callback(v47, p24)

		if v47.Behavior.OnAbilityUsed then
			local ok, result = pcall(function() -- line: 1059
				-- upvalues: v47 (copy), p23 (copy)
				v47.Behavior.OnAbilityUsed(v47, p23)
			end)

			if not ok then
				warn(`[{ script.Name }]: Failed to call method 'OnAbilityUsed' due to: { result }`)
			end
		end

		if v53 then
			local timestamp = tick()

			while (v47.HeldAbilities[p23] or tick() - timestamp < v52.Min) and LocalPlayer.Character and LocalPlayer.Character:GetAttribute(`Charging{ p23 }`) do
				game["Run Service"].Heartbeat:Wait()
			end

			if LocalPlayer.Character and LocalPlayer.Character:GetAttribute(`Charging{ p23 }`) then
				Network:FireServerConnection("UseActorAbility", "REMOTE_EVENT", p23)
			end
		end
	end)
	LocalPlayer.CharacterAdded:Connect(function(character) -- line: 1084
		-- upvalues: t1 (copy)
		if character.Parent == workspace or character.Parent == workspace.Players.Spectating then
			t1:Destroy()
		end
	end)
end
function t1.Destroy(_) -- line: 1092
	-- upvalues: t1 (copy)
	if t1.AbilityHotbar then
		t1.AbilityHotbar:Destroy()
	end

	for _, v in pairs(t1.Connections) do
		v:Disconnect()
	end

	table.clear(t1.Connections)
end

return t1

]========]}
}

local function findPath(path)
 local current=game
 for name in path:gmatch("[^/]+")do current=current and current:FindFirstChild(name)end
 return current
end
local pending={}
for _,plan in ipairs(plans)do
 assert(#plan.source < 200000, "Source exceeds Studio limit: "..plan.path..". Nothing changed.")
 local target=findPath(plan.path)
 if target then
  assert(target:IsA("ModuleScript"),"Expected ModuleScript: "..plan.path..". Nothing changed.")
  local source=target.Source
  if fingerprint(source)~=plan.after then
   assert(plan.before and (fingerprint(source)==plan.before or plan.previous and fingerprint(source)==plan.previous or plan.previous2 and fingerprint(source)==plan.previous2),"Azure source differs from the supported port: "..plan.path..". Nothing changed. Send this script if it was edited.")
   table.insert(pending,{target=target,plan=plan,before=source})
  end
 else
  assert(plan.before==false,"Missing target: "..plan.path..". Nothing changed.")
  table.insert(pending,{plan=plan})
 end
 assert(fingerprint(plan.source)==plan.after,"Corrupted installer text. Copy the entire Raw file again.")
end
if #pending==0 then print("[Azure optional animations] Already applied; nothing changed.");return end
local backup=Instance.new("Folder")
backup.Name="AzureOptionalAnimations_Backup_"..os.date("!%Y%m%d_%H%M%S")
backup.Parent=game:GetService("ServerStorage")
for i,item in ipairs(pending)do
 local saved=item.target and item.target:Clone() or Instance.new("Folder")
 saved.Name=string.format("%02d_%s",i,item.plan.path:match("[^/]+$"))
 saved:SetAttribute("OriginalPath",item.plan.path)
 saved:SetAttribute("WasCreated",item.target==nil)
 saved.Parent=backup
end
local function parentFor(path)
 local current=game
 local parts=string.split(path,"/")
 for i=1,#parts-1 do
  local child=current:FindFirstChild(parts[i])
  if not child then child=Instance.new("Folder");child.Name=parts[i];child.Parent=current end
  current=child
 end
 return current,parts[#parts]
end
local ok,err=pcall(function()
 for _,item in ipairs(pending)do
  if not item.target then
   local parent,name=parentFor(item.plan.path)
   item.target=Instance.new("ModuleScript");item.target.Name=name;item.target.Parent=parent
  end
  item.target.Source=item.plan.source
 end
end)
if not ok then
 for _,item in ipairs(pending)do
  if item.before then item.target.Source=item.before elseif item.target then item.target:Destroy()end
 end
 error("[Azure optional animations] Rolled back after write failure: "..tostring(err))
end
pcall(function()game:GetService("ChangeHistoryService"):SetWaypoint("Azure FCT Port")end)
print(string.format("[Azure optional animations] Applied %d scripts. Backups: %s. Save, then start a fresh playtest.",#pending,backup:GetFullName()))
