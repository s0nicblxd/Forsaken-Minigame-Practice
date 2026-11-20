-- Azure FCF -> FCTtest2 port. Apply the Guest fix first; stop playtesting.
local RunService=game:GetService("RunService")
assert(RunService:IsStudio() and not RunService:IsRunning(),"Stop the playtest before applying Azure's port.")
local function fingerprint(source)
 local a,b=5381,0
 for i=1,#source do local byte=string.byte(source,i);a=(a*33+byte)%4294967296;b=(b*65599+byte)%4294967296 end
 return string.format("%d:%08x:%08x",#source,a,b)
end
local plans={
{path=[====[
ReplicatedStorage/Assets/Killers/Azure/Behavior]====],before="152916:b00462c2:508367e5",previous="165307:78413e99:1bdaceaa",previous2="165439:fb880f31:a80e010c",after="164061:3c4ac9dd:c4d70668",source=[====[





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

return u77;]====]},
{path=[====[
ReplicatedStorage/Assets/Killers/Azure/Behavior/GrabConfigDefaults]====],before=false,after="1616:4dabca51:2601f86c",source=[====[
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
]====]},
{path=[====[
ReplicatedStorage/Assets/Killers/Azure/Behavior/OptionalAnimations]====],before=false,after="6222:829f59f0:02883aef",source=[====[
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
]====]},
{path=[====[
ReplicatedStorage/Assets/Killers/Azure/Behavior/sv_AzureConstruct]====],before="12634:ecc03edb:e58ee342",after="16757:1057f0f5:cc7737cc",source=[====[
                                                                                       

                                          

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Debris = game:GetService("Debris");
local RunService = game:GetService("RunService");
local HttpService = game:GetService("HttpService");
require(ReplicatedStorage.GlobalTypes);
local Maid = require(ReplicatedStorage.Modules.Misc.Maid);
local Util = require(ReplicatedStorage.Modules.Util);
local Sounds = require(ReplicatedStorage.Modules.Sounds);
local Actors = require(ReplicatedStorage.Modules.Actors);
local Hitboxes = require(ReplicatedStorage.Modules.Hitboxes);
local Statuses = require(ReplicatedStorage.Modules.Statuses);
local Network = require(ReplicatedStorage.Modules.Network);

local function reconcileDict(p1, p2)            
    local v3 = table.clone(p2);

    for i, v in pairs(p1) do
        if v3[i] ~= nil then
            v3[i] = v;
        end;
    end;

    return v3;
end;

local u4 = {
    Subclasses = {}
};
u4.__index = u4;

local function clearBloomingLight(p5, p6)            
                                                   
    for _, child in p5:GetChildren() do
        if child.Name == "BloomingLight" or child.Name == "BloomingLightFading" then
            local v7 = child:FindFirstChildOfClass("PointLight");

            if p6 and v7 then
                child.Name = "BloomingLightFading";
                TweenService:Create(v7, TweenInfo.new(4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Brightness = 0,
                    Range = 0
                }):Play();
                Debris:AddItem(child, 4.05);
            else
                child:Destroy();
            end;
        end;
    end;
end;

local u8 = {
    QTEActive = false,
    QTEEnabled = false
};
local u9 = {
    Slowness = true,
    Bleeding = true,
    Poisoned = true,
    Burning = true
};

for _, child in ipairs(script:GetChildren()) do
    if child:IsA("ModuleScript") then
        local v10 = require(child);
        setmetatable(v10, u4);
        u4.Subclasses[child.Name:gsub("sv_", "")] = v10;
    end;
end;

function u4.new(p11, p12, p13)            
                                                                                                                                               
    local v14 = u4.Subclasses[p11];

    if v14 then
        local v15 = table.clone(p13);

        for i, v in pairs(u8) do
            if v15[i] ~= nil then
                v15[i] = v;
            end;
        end;

        local u16 = setmetatable(v15, v14);
        local Model = Instance.new("Model");
        Model.Name = `{p12.Player.Name}'s {p11}`;
        Model:SetAttribute("Team", "Killers");
        Model:SetAttribute("ExecutionsDisabled", true);
                                                                                                                  
                                                                               
        Model:SetAttribute("ConstructOwner", p12.Player.UserId);
        local v17 = ReplicatedStorage.Assets.Instances.Nothingburger:Clone();
        v17.Name = `{p12.Player.Name}'s {p11}`;
        v17.Size = Vector3.new(2, 2, 2);
        v17.CFrame = p13.CFrame;
        v17.Transparency = 1;
        v17.Color = Color3.new(0.501961, 0, 1);
        v17.Parent = Model;
        v17.CanQuery = true;
        v17.CanTouch = true;
        v17.CanCollide = false;
        Model.PrimaryPart = v17;
        Model:SetAttribute("HitboxPriority", -2);
        local Humanoid = Instance.new("Humanoid");
        Humanoid.Health = 50;
        Humanoid.MaxHealth = 50;
        Humanoid.WalkSpeed = 0;
        Humanoid.Parent = Model;
        Model.Parent = workspace.Map.Ingame;
        local v18 = script.Prompt:Clone();
        v18.Parent = v17;
        v18.ObjectText = p11;
        v18:AddTag("SURVIVOR_ONLY");
        u16.Maid = Maid.new();
        u16.Model = Model;
        u16.Root = v17;
        u16.Prompt = v18;
        u16.Created = os.clock();
        u16.Owner = p12.Player;
        u16.Humanoid = Humanoid;
        u16.Type = p11;
        u16.UUID = HttpService:GenerateGUID(false);
                                                                                                                  
                                                                                                               
        Model:SetAttribute("ConstructUUID", u16.UUID);
        Model:SetAttribute("ConstructType", p11);
        Model:SetAttribute("ConstructCFrame", p13.CFrame);
        u16.WorkedOnBy = nil;
        u16.BloomingTimer = 40;
        u16.WitheringTimer = 0;
        u16.Meta = p13.Meta;
        u16.Callbacks = {};
		u16:Init(p13.Meta or {});
        u16.LastSleep = 0;
        u16.LastAwaken = 0;
        u16.LastSurvivorTick = 0;
        u16:AddToMaid(u16.Root.AncestryChanged:Once(function()             
                                   
            u16:Destroy();
        end));
        u16:AddToMaid(u16.Model.AncestryChanged:Once(function()             
                                   
            u16:Destroy();
        end));
        u16:AddToMaid(u16.Humanoid.HealthChanged:Connect(function()             
                                   
            if u16.Humanoid.Health <= 0 then
                u16:Destroy();
            end;
        end));
        u16:AddToMaid(u16.Owner.AncestryChanged:Once(function()             
                                   
            u16:Destroy();
        end));
        u16:AddToMaid(u16.Prompt);
        u16:SetPowerLevel(3);
        local u19 = os.clock();
        u16:AddToMaid(RunService.Heartbeat:Connect(function(p20)             
                                                                        
            local v21 = os.clock() - u19;

            if v21 > 1 then
                                                                                                            
                for v in pairs(u9) do
                    if Statuses:PlayerHasStatus(u16.Model, v) then
                        u16.Humanoid:TakeDamage(v21 * 5);
                        break;
                    end;
                end;

                u19 = os.clock();
            end;

            if u16.PowerLevel == 3 then
                u16.BloomingTimer = math.clamp(u16.BloomingTimer - p20, 0, u16:GetConfigValueForPowerLevel("BloomingTime"));

                if u16.BloomingTimer <= 0.01 then
                    u16:SetPowerLevel(2);
                end;
            elseif u16.PowerLevel == 1 then
                u16.SleepingTimer = math.clamp(u16.SleepingTimer - p20, 0, u16:GetConfigValueForPowerLevel("SleepingTime"));

                if u16.SleepingTimer <= 0.01 then
                    u16:SetPowerLevel(3);
                    u16.BloomingTimer = u16:GetConfigValueForPowerLevel("BloomingOnAwaken");
                end;
            end;
        end));

        return u16;
    end;

    warn("AzureConstruct: Failed to find subclass for type: " .. tostring(p11));
end;

function u4.IncreaseBloomTimer(p22, p23)             
    local v24 = p23 or p22:GetConfigValueForPowerLevel("BloomingOnActivated");
    p22.BloomingTimer = math.clamp(p22.BloomingTimer + v24, 0, p22:GetConfigValueForPowerLevel("BloomingTime"));
end;

function u4.SetPowerLevel(p25, p26)             
                                                               
    if p25.PowerLevel == p26 then
        return;
    end;

    if p26 < 1 or p26 > 3 then
        warn("Invalid power level (1-3)");

        return;
    end;

    if p26 == 3 then
        for _, child in p25.Root:GetChildren() do
            if child.Name == "BloomingLight" or child.Name == "BloomingLightFading" then
                child:FindFirstChildOfClass("PointLight");
                child:Destroy();
            end;
        end;
    elseif p25.PowerLevel == 3 then
        clearBloomingLight(p25.Root, true);
    end;

    p25.BloomingTimer = 0;
    p25.SleepingTimer = 0;

    if p26 == 3 then
        local Attachment = Instance.new("Attachment", p25.Root);
        Attachment.Name = "BloomingLight";
        Attachment.Position = Vector3.new(0, 1, 0);
        local PointLight = Instance.new("PointLight", Attachment);
        PointLight.Brightness = 0;
        PointLight.Range = 0;
        PointLight.Color = Color3.fromRGB(140, 0, 255);
        PointLight.Shadows = false;
        TweenService:Create(PointLight, TweenInfo.new(4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Brightness = 2.5,
            Range = 7
        }):Play();
        p25.BloomingTimer = p25:GetConfigValueForPowerLevel("BloomingTime", p26);
    elseif p26 == 1 then
        p25.SleepingTimer = p25:GetConfigValueForPowerLevel("SleepingTime", p26);
    end;

    p25:ToggleQTEEnabled("PowerLevel", p26 == 2);
    p25.PowerLevel = p26;
    if p25.Model then
        p25.Model:SetAttribute("ConstructPowerLevel", p26);
        p25.Model:SetAttribute("ConstructSleepTimer", p25.SleepingTimer);
    end;
    p25:FireConnection("OnPowerLevelChanged", p26);
    p25:FireAllClients("SetPowerLevel", p26, p25.SleepingTimer);
end;

function u4.GetConfigValueForPowerLevel(p27, p28, p29)             
    local v30 = p29 or p27.PowerLevel;
    local v31 = p27.Meta[p28];

    if v31 then
        if typeof(v31) == "table" then
            return v31[v30];
        end;

        return v31;
    end;

    warn("Could not get", p28, "for plant");
end;

function u4.GiveCharacterAtropa(p32, p33, p34)             
                                                
    if not p32.Owner then
        warn("atropa failed to give because this plant doesn\'t have a dad");
    end;

    local v35 = Statuses:PlayerHasStatus(p33, "Atropa");

    if not v35 then
        Statuses:ApplyStatus(p33, "Atropa", {
            Duration = 30,
            Level = p34,
            ApplierPlayer = p32.Owner
        });

        return;
    end;

    local v36 = v35.TimeRequired or 30;
    local v37 = v35.TimePast or 0;
    Statuses:ApplyStatus(p33, "Atropa", {
        Stackable = true,
        Duration = v36,
        Level = p34,
        ApplierPlayer = p32.Owner
    });
    local v38 = Statuses:PlayerHasStatus(p33, "Atropa");

    if v38 then
        v38.TimeRequired = v36;
        v38.TimePast = v37;
        v38.Data.Duration = v36;
        local v39 = game.Players:GetPlayerFromCharacter(p33);

        if v39 then
            Network:FireClientConnection(v39, "StatusUpdated", "REMOTE_EVENT", "Atropa", {
                Level = v38.Level,
                Duration = v36,
                TimePast = v37
            });
        end;
    end;
end;

local u40 = os.clock();

function u4.ToggleQTEEnabled(p41, p42, p43)             
                          
    p41.PromptDisablers = p41.PromptDisablers or {};
    p41.PromptDisablers[p42] = not p43 and true or nil;
    local v44 = next(p41.PromptDisablers) and true or false;
    p41.Prompt.Enabled = not v44;
    p41.QTEEnabled = not v44;

    if os.clock() - u40 > 2 then
        u40 = os.clock();
    end;

    if v44 and p41.QTEActive then
        p41:EndQTE();
    end;
end;

function u4.FireAllClients(p45, p46, ...)             
    p45:FireConnection("PostNetwork", p46, ...);
end;

function u4.AddCallback(p47, p48, p49, p50)             
    if not p47.Callbacks[p48] then
        p47.Callbacks[p48] = {};
    end;

    p47.Callbacks[p48][p50] = p49;
end;

function u4.RemoveCallback(p51, p52, p53)             
    if not p51.Callbacks[p52] then
        return;
    end;

    p51.Callbacks[p52][p53] = nil;
end;

function u4.PlaySound(p54, p55, p56)             
                              
    local Sounds2 = p54.Meta.Sounds;

    if not Sounds2 then
        return;
    end;

    if not Sounds2[p55] then
        warn((`[{script:GetFullName()}]: Failed to find sound: {p55}`));

        return;
    end;

    local v57 = p56 or {};

    if not v57.Parent then
        v57.Parent = p54.Root;
    end;

    if not v57.PlaybackSpeed then
        v57.PlaybackSpeed = Random.new():NextNumber(0.95, 1.05);
    end;

    Sounds:Play(Sounds2[p55], v57);
end;

function u4.GetActor(p58)             
                              
    return Actors.CurrentActors[p58.Owner];
end;

function u4.ActivationHighlight(p59, p60)             
                            
    Util:RevealPlayerAuraTo(p59.Owner, p60, 4.5, Color3.new(0.501961, 0, 1));
end;

function u4.HasLOS(p61, p62)             
                                
    return Hitboxes:LineOfSight(p61.Root.CFrame.Position, p62) and true or false;
end;

function u4.GetLoudSurvivorsInRange(u63, actorRig, p64, p65, p66)             
                            
    local v67 = {};

    for _, child in ipairs(workspace.Players.Survivors:GetChildren()) do
        if Util:IsAlive(child) and not (p66 and table.find(p66, child)) and (((child:GetAttribute("AzureThrowLandedUntil") or 0) > os.clock()) or (not child:GetAttribute("Undetectable") and (not p65 or u63:HasLOS(child)))) then
            local Magnitude = (child:GetPivot().Position - u63.Root.CFrame.Position).Magnitude;
            local v68 = (child.PrimaryPart.AssemblyLinearVelocity * Vector3.new(1, 0, 1)).Magnitude - 1;
            local v69 = child:GetAttribute("AbilityLastUsed") or 0;
            local v70 = child:GetAttribute("AzureQTEFailFlag") or 0;

            if ((child:GetAttribute("AzureThrowLandedUntil") or 0) > os.clock() or (child:GetAttribute("BaseSpeed") or 16) <= v68 or (os.clock() - v69 < 1.5 or os.clock() - v70 < 1.5)) and Magnitude <= p64 then
                table.insert(v67, child);
            end;
        end;
    end;
	if workspace:GetAttribute("FriendlyFire") then
		for _, child in ipairs(workspace.Players.Killers:GetChildren()) do
			if child == actorRig then continue end
			if Util:IsAlive(child) and not (p66 and table.find(p66, child)) and (((child:GetAttribute("AzureThrowLandedUntil") or 0) > os.clock()) or (not child:GetAttribute("Undetectable") and (not p65 or u63:HasLOS(child)))) then
				local Magnitude = (child:GetPivot().Position - u63.Root.CFrame.Position).Magnitude;
				local v68 = (child.PrimaryPart.AssemblyLinearVelocity * Vector3.new(1, 0, 1)).Magnitude - 1;
				local v69 = child:GetAttribute("AbilityLastUsed") or 0;
				local v70 = child:GetAttribute("AzureQTEFailFlag") or 0;

				if ((child:GetAttribute("AzureThrowLandedUntil") or 0) > os.clock() or (child:GetAttribute("BaseSpeed") or 16) <= v68 or (os.clock() - v69 < 1.5 or os.clock() - v70 < 1.5)) and Magnitude <= p64 then
					table.insert(v67, child);
				end;
			end;
		end;
	end

    table.sort(v67, function(p71, p72)             
                               
        return (p71:GetPivot().Position - u63.Root.CFrame.Position).Magnitude < (p72:GetPivot().Position - u63.Root.CFrame.Position).Magnitude;
    end);

    return v67;
end;

function u4.FireConnection(p73, p74, ...)             
    for i, v in pairs(p73.Callbacks[p74] or {}) do
        local success, result = pcall(v, ...);

        if not success then
            warn((`[Azure]: Failed to run callback: {p74}, {i}, {result}`));
        end;
    end;
end;

function u4.AddToMaid(p75, p76)             
    p75.Maid:Add(p76);
end;

function u4.StartQTE(p77, p78)             
    if p77.QTEActive then
        return;
    end;

    p77.WorkedOnBy = p78;
    p77.QTEActive = true;
    p77:FireAllClients("QTEBegan", p78);
end;

function u4.EndQTE(p79, p80)             
    warn("end qte called");

    if not p79.QTEActive then
        warn("endQTE() early returned");

        return;
    end;

    local WorkedOnBy = p79.WorkedOnBy;
    p79.QTEActive = false;
    p79.WorkedOnBy = nil;

    if p80 then
        p79:SetPowerLevel(1);
    else
        local Character = WorkedOnBy.Character;

        if Character then
            Character:SetAttribute("AzureQTEFailFlag", os.clock());
        end;

        p79:FireConnection("OnQTEFailed");
    end;

    p79:FireConnection("ServerQTEEnd", WorkedOnBy);
    p79:FireAllClients("QTEEnded");
end;

function u4.Destroy(u81)             
    if u81.Destroyed then
        warn("construct attempted to destroy twice?");

        return;
    end;

    u81.Destroyed = true;
    if u81.Model then
        u81.Model:SetAttribute("ConstructDead", true);                                                 
    end;
    u81:EndQTE();

    if u81.OnDestroyed then
        u81:OnDestroyed();
    end;

    u81:FireConnection("OnDestroyed");
    u81.Maid:Destroy();
    pcall(function()             
                              
        game.Debris:AddItem(u81.Model, 4);
    end);
    table.clear(u81);
    setmetatable(u81, nil);
    u81 = nil;
end;

return u4;]====]},
{path=[====[
ReplicatedStorage/Assets/Killers/Azure/Behavior/sv_AzureConstruct/sv_GroundBulb]====],before="11734:be8a80c4:ab8c4471",after="6639:23ce2eba:febd8b65",source=[====[
-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
game:GetService("TweenService");
game:GetService("Debris");
local RunService = game:GetService("RunService");
require(ReplicatedStorage.GlobalTypes);
require(ReplicatedStorage.Modules.Misc.Signal);
local Projectiles = require(ReplicatedStorage.Modules.Projectiles);
local Util = require(ReplicatedStorage.Modules.Util);
local PredictProjectile = require(ReplicatedStorage.Modules.PredictProjectile);
require(ReplicatedStorage.Modules.Statuses);

local function reconcileDict(p1, p2) -- Line: 14
    local v3 = table.clone(p2);

    for i, v in pairs(p1) do
        if v3[i] ~= nil then
            v3[i] = v;
        end;
    end;

    return v3;
end;

local v4 = {};
v4.__index = v4;

function v4.Init(u5, u6, actorRig) -- Line: 29
    -- upvalues: RunService (copy), Util (copy), PredictProjectile (copy), Projectiles (copy)
    u5:ToggleQTEEnabled("WindupComplete", true);
    local _ = u6.Radius;
    local ProjectileSpeed = u6.ProjectileSpeed;
    local u9 = {
        BypassChecks = true,
        Time = 5,
        Knockback = false,
        HitMultiple = false,
        PredictVelocity = false,
        IsProjectile = true,
        Size = u6.HitboxSize,

        Damage = function() -- Line: 43, Name: Damage
            -- upvalues: u5 (copy)
            return u5:GetConfigValueForPowerLevel("Damage");
        end,

        Shape = Enum.PartType.Ball,
        Connections = {
            Hit = function(p7, p8) -- Line: 50, Name: Hit
                -- upvalues: u5 (copy), u6 (copy)
                u5:GiveCharacterAtropa(p7, u6.AtropaOnHit or 1);
            end
        }
    };
    local u10 = false;
    local u11 = nil;
    local u12 = 0;
    local u13 = 0;
    local u14 = 0;
    local u15 = os.clock();
    local u16 = false;
    u5:AddToMaid((RunService.Heartbeat:Connect(function() -- Line: 63
        -- upvalues: u16 (ref), u5 (copy), u6 (copy), u11 (ref), u10 (ref), u15 (copy), u13 (ref), u14 (ref), u12 (ref), Util (ref), PredictProjectile (ref), ProjectileSpeed (copy), u9 (copy), Projectiles (ref)
        if u16 then
            return;
        end;

        if u5.QTEActive then
            return;
        end;

        if u6.Ammo <= 0 then
            u5:PlaySound("DryFire");
            u16 = true;
            task.wait(0.54);
            u5:Destroy();

            return;
        end;

        if u5.PowerLevel == 1 then
            if u11 then
                u11 = nil;
                u5:FireAllClients("Target");
            end;

            u10 = false;

            return;
        end;

        if os.clock() - u15 < 1 then
            return;
        end;

        if os.clock() - u13 < u5:GetConfigValueForPowerLevel("ShotDebounce") then
            return;
        end;

        if os.clock() - u14 < u5:GetConfigValueForPowerLevel("Windup") then
            return;
        end;

        local v17 = u11;
		local v18 = u5:GetLoudSurvivorsInRange(u5.Owner and u5.Owner.Character, u6.Radius, true);

        if #v18 == 0 then
            if os.clock() - u12 > 1.5 or not Util:IsAlive(u11) then
                u11 = nil;
                u10 = false;
            end;
        else
            u11 = v18[1];
            u12 = os.clock();
        end;

        if v17 ~= u11 then
            u5:FireAllClients("Target", u11);
        end;

        if not u11 then
            u5:ToggleQTEEnabled("Firing", true);

            return;
        end;

        if u10 then
            u5:ToggleQTEEnabled("Firing", false);
            local v19 = u6;
            v19.Ammo = v19.Ammo - 1;
            local v20 = Util:GetActor(u11);
            local v21;

            if v20 and v20.GetPivot then
                v21 = v20:GetPivot();
            else
                v21 = u11.PrimaryPart.CFrame;
            end;

            local v22 = u5.Root.CFrame.Position + u5.Root.CFrame.LookVector;
            local v23 = PredictProjectile:FindLeadShot(v21.Position, u11.PrimaryPart.AssemblyLinearVelocity, ProjectileSpeed, v22, Vector3.new(0, 0, 0), 0);
            local v24 = v22 + (v23 - v22).Unit;
            local v25 = u6.ProjectileModel:Clone();
            local v26 = RaycastParams.new();
            v26.FilterDescendantsInstances = { workspace.Players };
            v26.FilterType = Enum.RaycastFilterType.Exclude;
            local v31 = {
                Lifetime = 5,
                Owner = u5.Owner,
                HitboxConfig = Util:CopyTable(u9),
                InitialCFrame = CFrame.new(v22, v24),
                InitialVelocity = (v23 - v22).Unit * ProjectileSpeed,
                CastParams = v26,
                Callbacks = {
                    HitHuman = function(p27, p28) -- Line: 156, Name: HitHuman
                        -- upvalues: u5 (ref)
                        u5:PlaySound("HitHuman", {
                            Parent = p28.PrimaryPart
                        });
                        u5:FireConnection("OnCharacterHit", p28);
                        p27:Destroy();
                    end,

                    HitOther = function(p29, p30) -- Line: 165, Name: HitOther
                        -- upvalues: u5 (ref)
                        u5:FireConnection("OnSurfaceHit", p30);
                        u5:PlaySound("HitOther", {
                            Position = p30.Position
                        });
                        p29:Destroy();
                    end
                },
                Model = v25
            };
            Projectiles.new(v31):Launch();

            if v25:IsA("BasePart") then
                u5:PlaySound("ProjectileIdle", {
                    Looped = true,
                    Parent = v25
                });
            else
                local v32 = v25:IsA("Model") and (v25.PrimaryPart or v25:FindFirstChildOfClass("BasePart"));

                if v32 then
                    u5:PlaySound("ProjectileIdle", {
                        Looped = true,
                        Parent = v32
                    });
                end;
            end;

            u5:PlaySound("Shot");
            u5:FireAllClients("Shoot", v22, v24);
            u13 = os.clock();
        else
            u5:IncreaseBloomTimer();
            u5:FireAllClients("Warn");
            u5:ActivationHighlight(u11);
            u14 = os.clock();
            u5:PlaySound("Activate");
        end;

        u10 = true;
    end)));
end;

function v4.OnDestroyed(p33) -- Line: 209
    p33:PlaySound("Death");
end;

return v4;]====]},
{path=[====[
ReplicatedStorage/Assets/Killers/Azure/Behavior/sv_AzureConstruct/sv_Vine]====],before="22499:fed69e27:590ad740",after="13437:06a50e8f:27f6cf5c",source=[====[
                                                                                       

                                          

local ReplicatedStorage = game:GetService("ReplicatedStorage");
game:GetService("TweenService");
game:GetService("Debris");
local RunService = game:GetService("RunService");
require(ReplicatedStorage.GlobalTypes);
require(ReplicatedStorage.Modules.Misc.Signal);
local Hitboxes = require(ReplicatedStorage.Modules.Hitboxes);
local Util = require(ReplicatedStorage.Modules.Util);
require(ReplicatedStorage.Modules.PredictProjectile);
local Statuses = require(ReplicatedStorage.Modules.Statuses);

local function reconcileDict(p1, p2)            
    local v3 = table.clone(p2);

    for i, v in pairs(p1) do
        if v3[i] ~= nil then
            v3[i] = v;
        end;
    end;

    return v3;
end;

local v4 = {};
v4.__index = v4;

function v4.Init(u5, u6)            
                                                                                                           
    local _ = u6.Radius;
    local _ = u6.ProjectileSpeed;
    local u7 = false;
    local u8 = 0;
    local u9 = 0;
    local u10 = 0;
    os.clock();
    local u11 = nil;
    local u12 = nil;
    local HitboxLength = u6.HitboxLength;
    local u13 = nil;
    u5:ToggleQTEEnabled("WindupComplete", true);
    u5.IsHolding = false;
    local u14 = nil;

    local function letGo()            
                                                                                                                           
        if not u5.AttachedCharacter then
            return;
        end;

        if u14 then
            u14:Disconnect();
        end;

        u5:ToggleQTEEnabled("IsHolding", true);
        u5:ToggleQTEEnabled("IsAttacking", true);
        u5:PlaySound("Escape");
        u5:FireConnection("OnReleased", u5.AttachedCharacter);
        u5:FireAllClients("OnReleased", u5.AttachedCharacter);
        local StatusesOnRelease = u5.Meta.StatusesOnRelease;

        if StatusesOnRelease and Util:IsAlive(u5.AttachedCharacter) then
            for i, v in pairs(StatusesOnRelease) do
                Statuses:ApplyStatus(u5.AttachedCharacter, i, v);
            end;
        end;

        u5.AttachedCharacter = nil;

        if u11 then
            u11:Destroy();
            u11 = nil;
        end;

        if u12 then
            u12:Destroy();
            u12 = nil;
        end;

        if u13 then
            pcall(task.cancel, u13);
            u13 = nil;
        end;

		u13 = task.delay(u5:GetConfigValueForPowerLevel("EscapeCooldown"), function()            
                                            
            u13 = nil;

            if not (u5 and u5.Owner) then
                return;
            end;

            u5:FireAllClients("OnReady");
            u5:PlaySound("Ready");
        end);
        u9 = os.clock();
        u5.IsHolding = false;
    end;

    u5.AttachedCharacter = nil;
    u5:AddCallback("OnPowerLevelChanged", function()             
                                            
        if u5.PowerLevel < 2 then
            letGo();
            u5:ToggleQTEEnabled("IsAttacking", true);
        end;
    end, "LetGo");
    u5:AddCallback("OnQTEFailed", function()             
                                                             
        if u13 then
            pcall(task.cancel, u13);
            u13 = nil;
        end;

        u5:PlaySound("Ready");
        u5:FireAllClients("OnReady");
        u9 = 0;
        u8 = 0;
    end, "AllowAttack");
    u5:PlaySound("Spawn");
    local u15 = os.clock();
    local v28 = RunService.Heartbeat:Connect(function()             
                                                                                                                                                                                                                                                    
        if u5.QTEActive then
            return;
        end;

        if u7 then
            return;
        end;

        if u5.PowerLevel < 2 then
            return;
        end;

		local v16 = (os.clock() - u8) > u5:GetConfigValueForPowerLevel("MissAttackCooldown")
		

		if (os.clock() - u9) > u5:GetConfigValueForPowerLevel("EscapeCooldown") and ((os.clock() - u15) > u6.PlaceWindup and (v16 and (not u5.IsHolding and u5.PowerLevel > 1))) then
            local u17;

                                                                             
                                                                                          
            u17 = u5:GetLoudSurvivorsInRange(u5.Owner and u5.Owner.Character, u6.Radius, true);

            if u17 then
                u17 = u17[1];
            end;

            if not u17 then
                return;
            end;

            u5:IncreaseBloomTimer();
            u5:ToggleQTEEnabled("IsAttacking", false);

            local function getProjectedCFrame()             
                                                                                          
                local v18 = Util:GetActor(u17);
                local v19;

                if v18 and v18.GetPivot then
                    v19 = v18:GetPivot();
                else
                    v19 = u17.PrimaryPart.CFrame;
                end;

                local Position = v19.Position;

                if not u17:GetAttribute("Ragdolling") then
					Position = Position + u17.PrimaryPart.AssemblyLinearVelocity * Vector3.new(1, 0, 1) * u5:GetConfigValueForPowerLevel("Windup");
                end;

                local v20 = Vector3.new(Position.X, u5.Root.Position.Y, Position.Z) + Vector3.new(0, u6.HitboxHeight / 2, 0);

                return CFrame.lookAt(u5.Root.Position + Vector3.new(0, u6.HitboxHeight / 2, 0), v20) * CFrame.new(0, 0, -HitboxLength / 2);
            end;

            local u21 = getProjectedCFrame();
            local u22 = ReplicatedStorage.Assets.Instances.Nothingburger:Clone();
            u22.Transparency = 0.9;
            u22.Size = Vector3.new(u6.HitboxWidth, u6.HitboxHeight, HitboxLength);
            u22.CFrame = u21;
            u22.Color = Color3.new(0.384314, 0.027451, 1);
            local SelectionBox = Instance.new("SelectionBox");
            SelectionBox.LineThickness = 0.05;
            SelectionBox.Adornee = u22;
            SelectionBox.Parent = u22;
            SelectionBox.Color3 = Color3.new(0.4, 0.025, 1);
            SelectionBox.Transparency = 0.5;
            u22.Parent = workspace.Map.Ingame;
            u8 = os.clock();
            u7 = true;
            local u23 = nil;
            u23 = RunService.Heartbeat:Connect(function()             
                                                                                                   
                if not (u22 and (u22.Parent and (u17 and (u17.Parent and u17.PrimaryPart)))) then
                    if u23 then
                        u23:Disconnect();
                        u23 = nil;
                    end;

                    return;
                end;

                u21 = getProjectedCFrame();
                u22.CFrame = u21;
			end);
			local windup = u5:GetConfigValueForPowerLevel("Windup")
            u5:ActivationHighlight(u17);
            u5:FireConnection("OnAttack", u17);
            u5:FireAllClients("OnAttack", u17, {
                Part = u22,
                Highlight = SelectionBox
			}, windup);
            u5:PlaySound("PrepareAttack");
			task.delay(windup, function()             
                                                                                                                                                                                                                                                     
                if u23 then
                    u23:Disconnect();
                    u23 = nil;
                end;

                if u17 and (u17.Parent and (u17.PrimaryPart and u17:GetAttribute("Ragdolling"))) then
                    u21 = getProjectedCFrame();
                end;

                if u22 then
                    u22:Destroy();
                end;

                if not u5 or (not u5.Owner or u5.IsHolding) then
                    return;
                end;

                u5:PlaySound("Attack");
                local u24 = true;
                Hitboxes:CreateHitbox(u5.Owner, {
                    Time = 0.1,
                    Knockback = false,
                    HitMultiple = false,
                    BypassChecks = true,
                    Size = Vector3.new(u6.HitboxWidth, u6.HitboxHeight, HitboxLength),
                    Damage = u6.Damage,
                    CFrame = u21,
                    CastPoint = u5.Root.Position + Vector3.new(0, 0.5, 0),
                    Connections = {
                        Hit = function(u25)                        
                                                                                                                                           
                            u5:GiveCharacterAtropa(u25, u6.AtropaOnHit or 1);
                            local v26 = Util:GetEntityType(u25);

                            if u5.IsHolding or (not v26 or (not Util:IsAlive(u25) or u25:GetAttribute("AzureGrabbed"))) then
                                return;
                            end;

                            u24 = false;
                            u5:ToggleQTEEnabled("IsHolding", false);
                            u5.AttachedCharacter = u25;
                            u10 = os.clock();
                            u5.IsHolding = true;
                            u12 = Util:CreateSpeedMultiplier(u25, 0.8, "AzureGrabbed", u5:GetConfigValueForPowerLevel("TrapLength"), true);
                            u11 = Instance.new("BodyPosition");
                            u11.Position = u5.Root.Position;
                            u11.MaxForce = Vector3.new(0, 0, 0);
                            u11.P = 0;
                            u11.Parent = u25.PrimaryPart;
                            task.spawn(function()             
                                                                                                     
                                while task.wait() and (u11 and (u11.Parent and Util:IsAlive(u25))) do
                                    local v27 = (u25.PrimaryPart.Position - u5.Root.Position).Magnitude / 2;
                                    u11.P = v27 * 1250;
                                    u11.MaxForce = Vector3.new(1, 1, 1) * v27 * 900;
                                end;

                                letGo();
                            end);
                            Util:GiveStackableAttribute(u25, "Airborne", "AzureGrab", u5:GetConfigValueForPowerLevel("TrapLength"));
                            Util:GiveStackableAttribute(u25, "AzureGrabbed", u5.Owner.Name, u5:GetConfigValueForPowerLevel("TrapLength"));
                            u5:AddToMaid(u11);
                            u5:AddToMaid(u12);
                            u5:PlaySound("Hit", {
                                Parent = u25.PrimaryPart
                            });
                            u5:FireConnection("OnCharacterHit", u25);
                            u5:FireAllClients("OnCharacterHit", u25);
                            local Health = u25.Humanoid.Health;
                            u14 = u25.Humanoid.HealthChanged:Connect(function()             
                                                                                             
                                if u25.Humanoid.Health <= Health - u6.DamageToRelease then
                                    letGo();
                                end;
                            end);
                        end,

                        Ended = function()                          
                                                                                           
                            u7 = false;

                            if u24 then
                                u5:FireConnection("OnMiss");
                                u5:FireAllClients("OnMiss");
                                u5:ToggleQTEEnabled("IsAttacking", true);

                                if u13 then
                                    pcall(task.cancel, u13);
                                    u13 = nil;
                                end;

								u13 = task.delay(math.max(0, u5:GetConfigValueForPowerLevel("MissAttackCooldown") - windup - 0.1), function()             
                                                                    
                                    u13 = nil;

                                    if not (u5 and u5.Owner) then
                                        return;
                                    end;

                                    u5:PlaySound("Ready");
                                    u5:FireAllClients("OnReady");
                                end);
                            end;
                        end
                    }
                });
            end);
        end;

        if os.clock() - u10 >= u5:GetConfigValueForPowerLevel("TrapLength") and u5.IsHolding then
            letGo();
        end;
    end);
    u5:AddCallback("Release", letGo, "EscapeConnection");
    u5:AddToMaid(v28);
end;

function v4.OnDestroyed(p29)             
    p29:PlaySound("Death");
end;

return v4;]====]},
{path=[====[
ReplicatedStorage/Assets/Killers/Azure/Behavior/sv_Golem]====],before="7948:a03f6455:bba4efe8",after="3721:3f75cb9e:68f12481",source=[====[
-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
game:GetService("TweenService");
game:GetService("Debris");
local RunService = game:GetService("RunService");
local HttpService = game:GetService("HttpService");
require(ReplicatedStorage.GlobalTypes);
local Signal = require(ReplicatedStorage.Modules.Misc.Signal);
local Maid = require(ReplicatedStorage.Modules.Misc.Maid);
require(ReplicatedStorage.Modules.Util);
require(ReplicatedStorage.Modules.Sounds);
local Actors = require(ReplicatedStorage.Modules.Actors);
require(ReplicatedStorage.Modules.Hitboxes);

local function reconcileDict(p1, p2) -- Line: 16
    local v3 = table.clone(p2);

    for i, v in pairs(p1) do
        if v3[i] ~= nil then
            v3[i] = v;
        end;
    end;

    return v3;
end;

local u4 = {
    ActiveGolems = {}
};
u4.__index = u4;

function u4.new(p5, p6, p7) -- Line: 33
    -- upvalues: u4 (copy), Maid (copy), HttpService (copy), RunService (copy)
    local u8 = setmetatable({}, u4);
    u8.Created = os.clock();
    u8.CFrame = p6;
    u8.Owner = p5.Player;
    u8.Maid = Maid.new();
    u8.BeingControlled = false;
    u8.TimeRemaining = p7;
    u8.Cooldowns = {
        Slash = 0,
        Sow = 0,
        Blossom = 0
    };
    u8.UUID = HttpService:GenerateGUID(false);
    u8.Connections = {};
    u8.Callbacks = {};
    u8:AddToMaid(RunService.Heartbeat:Connect(function(p9) -- Line: 50
        -- upvalues: u8 (copy)
        if u8.BeingControlled then
            local v10 = u8;
            v10.TimeRemaining = v10.TimeRemaining - p9;
        end;

        if u8.TimeRemaining <= 0 then
            u8:Destroy();
        end;
    end));
    table.insert(u4.ActiveGolems, u8);

    return u8;
end;

function u4.CreateConnection(p11, p12) -- Line: 66
    -- upvalues: Signal (copy)
    local v13 = Signal.new();
    p11.Connections[p12] = v13;
    p11:AddToMaid(v13);

    return v13;
end;

function u4.AddCallback(p14, p15, p16, p17) -- Line: 75
    if not p14.Callbacks[p15] then
        p14.Callbacks[p15] = {};
    end;

    p14.Callbacks[p15][p17] = p16;
end;

function u4.RemoveCallback(p18, p19, p20) -- Line: 83
    if not p18.Callbacks[p19] then
        return;
    end;

    p18.Callbacks[p19][p20] = nil;
end;

function u4.GetActor(p21) -- Line: 91
    -- upvalues: Actors (copy)
    return Actors.CurrentActors[p21.Owner];
end;

function u4.AddToMaid(p22, p23) -- Line: 96
    p22.Maid:Add(p23);
end;

function u4.FireConnection(p24, p25, ...) -- Line: 100
    if p24.Connections[p25] then
        p24.Connections[p25]:Fire(...);
    else
        warn((`[Azure]: Failed to find connection: {p25}`));
    end;

    for i, v in pairs(p24.Callbacks[p25] or {}) do
        local success, result = pcall(v, ...);

        if not success then
            warn((`[Azure]: Failed to run callback: {p25}, {i}, {result}`));
        end;
    end;
end;

function u4.Destroy(u26) -- Line: 116
    -- upvalues: u4 (copy)
    if u26.DestructionFlag then
        warn("what the hell??");

        return;
    end;

    u26.DestructionFlag = true;
    pcall(function() -- Line: 125
        -- upvalues: u26 (ref)
        if u26.OnDestroyed then
            u26:OnDestroyed();
        end;

        u26:FireConnection("OnDestroyed");
    end);
    table.clear(u26.Callbacks or {});
    local v27 = table.find(u4.ActiveGolems, u26);

    if v27 then
        table.remove(u4.ActiveGolems, v27);
    else
        warn("[!Azure]: why is this one not indexed????");
    end;

    u26.Maid:Destroy();
    setmetatable(u26, nil);
    table.clear(u26);
    u26 = nil;
end;

return u4;]====]},
{path=[====[
ReplicatedStorage/Assets/Killers/Azure/Config]====],before="26901:3be9e873:6eeb940a",after="31256:d97bac60:aa50de67",source=[====[

local t1 = {
	LMSEffect = {
		ProcessingModule = "BasicLMS",
		SoundId = "cullstarup2",
		ImageId = function(s1: string)           
			if s1 == "TwoTime" then
				return "rbxassetid://101706612729149"
			end

			return "rbxassetid://111201925591508"
		end,
		PrimaryColor = function(s2: string)            
			if s2 == "TwoTime" then
				return Color3.fromRGB(122, 0, 198)
			end

			return Color3.fromRGB(255, 0, 0)
		end,
		SecondaryColor = Color3.fromRGB(0, 0, 0)
	},
	SpectreSkyEffect = {
		EffectType = function(s3: string, _: string?)            
			if s3 == "TwoTime" then
				return "AzureTwoTimeLMS"
			end
		end
	},
	DisplayName = "Azure",
	Quote = "The beat of my heart has long since stopped thanks to you.",
	RenderImage = "rbxassetid://100519193821443",
	Price = 2000,
	Instances = {
		RootImages = script.RootImages,
		BulbProjectile = script.BulbProjectile,
		GroundBulbModel = script.GroundBulbModel,
		VineModel = script.VineModel,
		ClientQTEModules = {
			Behavior = script.cl_WorkaroundModules.cl_ConstructQTE,
			UI = script.cl_WorkaroundModules.cl_QTEUI
		},
		HomingUITemplate = script.HomingUITemplate,
		Golem = script.MisterBeast,
		GolemSelectionHighlight = script.hl,
		OhMyGodBruh = script.Oblation,
		InfectionFlower = script.InfectionFlower,
		KillerFlower = script.KillerFlower,
		GolemStatue = script.GolemStatue,
		TrajectoryTarget = script.ThrowIndicator.EndPoint,
		TrajectoryBeam = script.ThrowIndicator.Beam,
		TargetParticle = script:FindFirstChild("TargetParticle"),
		MassInfectionShockwaveVignette = script.MainVignette,
		PlantHighlight = script.planthighlight,
		WitherTimeGui = script.TimeGui,
		HomingScopeEffect = script.HomingScope,
		BulbFireVFX = script.VFX.BulbFire,
		SlamVFX = script.VFX.SlamImpact,
		ThrowWindVFX = script.VFX.Wind,
		ThrowTrailVFX = script.VFX.ThrowTrail,
		BulbHitVFX = script.VFX.BulbHit,
		EyeGlintVFX = script.VFX.HomingEye,
		HomingCC = script.Homing.ColorCorrection,
		HomingDOF = script.Homing.DepthOfField,
		HomingSpotlightLocal = script.Homing.HomingSpotlightLocal,
		HomingLooker = script.AlignOrientation,
		HomingSpotlightOthers = script.Homing.HomingSpotlightOthers,
		GhostKnife = script.CutsceneThings.GhostFire,
		Spawn = script.CutsceneThings.SpawnLogo,
		VictoryLighting = script.VictoryLighting,
		AnimController = script.CutsceneThings.AnimationController
	},
	Health = 100,
	Speed = 9.25,
	SprintSpeed = 27.25,
	StaminaLoss = 9.5,
	StaminaGain = 21,
	MaxStamina = 110,
	GolemIcons = {
		Pummeling = "rbxassetid://89466282291815",
		Blooming = "rbxassetid://104124585268095",
		Unearthing = "rbxassetid://135461293091840",
		Burrowing = "rbxassetid://104920945686953"
	},
	AzureIcons = {
		Slash = "rbxassetid://123556520269026",
		Sow = "rbxassetid://109787679155717",
		Blossom = "rbxassetid://117545955019424",
		Grab = "rbxassetid://115907381502841",
		Unravel = "rbxassetid://109425766636886"
	},
	Oblation = {
		Start = 1,
		Max = 15,
		BuildTimeFull = 40,
		BuildPerDamage = 2.5,
		BuildTimeDecreasePerDead = 2,
		BuildPerInjured = 100,
		SpeedDebuff = 0.95,
		SpeedDebuffThreshold = 3,
		StunnedStatuses = {
			Strength = {
				Duration = 10,
				Level = 1
			}
		}
	},
	GolemSpawn = {
		Windup = 4.8
	},
	Golem = {
		BaseLifetime = 45,
		LifetimePerOblation = 0,
		EnragedLifetime = 25,
		WalkspeedMultiplier = 1.037037037037037,
		OOCWalkspeedMultiplier = 1.1,
		EnragedWalkspeedMultiplier = 3.3333333333333335,
		Stamina = 50,
		StaminaGainIdle = 4,
		TransferCooldown = 2.5,
		InvulnOnSwitch = 0.8,
		ChaseThresholds = NumberRange.new(80, 85)
	},
	Smash = {
		Cooldown = 2.4,
		Damage = 26,
		Windup = 0.35,
		Linger = 0.25,
		Endlag = 0,
		DamagePerAtropa = 1
	},
	SmashPower = {
		Damage = 35,
		Windup = 0.7,
		Linger = 0.25,
		Endlag = 0
	},
	GolemShockwave = {
		Cooldown = 7,
		Lunge = 1.3,
		Damage = 35,
		Radius = 17,
		KnockbackPower = 80,
		Windup = 0.7,
		Linger = 0.25,
		Endlag = 0.5
	},
	GolemFissure = {
		Cooldown = 16,
		Distance = 85,
		Windup = 0.8,
		Endlag = 0.8,
		TimeInterval = 0.07,
		StudInterval = 5,
		Damage = 15,
		KnockbackPower = 65,
		HitboxSize = 15,
		CrackHeight = 6,
		CrackWidth = 4,
		CrackKnockbackPower = 70,
		CrackDamage = 10,
		CrackLifetime = 8,
		VictimSpeedMult = 0.3
	},
	Slash = {
		Damage = 22,
		Windup = 0.22,
		Linger = 0.25,
		Endlag = 0.5,
		HoldTime = 0.45,
		ExtensionLimit = 5,
		DamageFalloff = 10,
		DamagePerAtropa = 1
	},
	Grab = {
		Windup = 1,
		Linger = 0.2,
		Endlag = 0.5,
		HookRange = 60,
		HookSpeed = 270,
		PullTime = 0.8,
		HookHitboxSize = 4,
		                                                                                                     
		                                                         
		ProjectileHitboxSize = Vector3.new(5, 5.5, 6),
		MissSlowness = 0.3,
		MissSlownessDuration = 1,
		CooldownCancel = 5,
		CooldownMiss = 25,
		CooldownSuccess = 25,
		KnockbackPower = 100,
		RagdollDuration = 1.2,
		BlastRadius = 20,
		Damage = 5,
		ThrowVelocity = 70,
		GravityCoefficient = 0.425,
		HitDamage = 10,
		CloseThrowDistance = 20,
		ThrowHelpless = 2,
		CloseThrowHelpless = 4,
		PlantTriggerDuration = 1.5,
		SuccessAnimationTimeout = 8,
		ThrowAnimationTimeout = 8,
		HoldMaxDuration = 1.5
	},
	Sow = {
		Windup = 0.86,
		Range = 12,
		Endlag = 0.5
	},
	Blossom = {
		Windup = 0.8,
		Endlag = 0.5
	},
	Unravel = {
		Windup = 0.8,
		Endlag = 0.5
	},
	AtropaOnDefuse = 2,
	PlacementRadius = 18,
	PlacementYFactor = 0.2,
	CrackVisualiserOptions = {
		DivotSize = 3,
		DivotSizeDeviance = 0.25,
		DivotDepth = 0,
		WidthDeviance = 0.12,
		WidthMultiplier = 0.5,
		Tweens = true,
		AwayRotation = -45,
		AwayRotationDeviance = 1,
		RandomRotation = 25,
		TimeInterval = 0.013,
		TweenConfig = TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
	},
	Animations = {
		Idle = "rbxassetid://92919132424278",
		Walk = "rbxassetid://120805025753869",
		Run = "rbxassetid://105801510327298",
		InjuredIdle = "rbxassetid://130212214475523",
		InjuredWalk = "rbxassetid://120805025753869",
		InjuredRun = "rbxassetid://105801510327298",
		GrabWindup = "rbxassetid://102499260904211",
		GrabWindupIdle = "rbxassetid://140069588383388",
		GrabShoot = "rbxassetid://83254528614461",
		GrabPullingLoop = "rbxassetid://80281580027249",
		GrabVictimHooked = "rbxassetid://123574158064862",
		GrabShootFailed = "rbxassetid://84993062039295",
		GrabShootSuccess = "rbxassetid://89545146730216",
		GrabIdle = "rbxassetid://119731980366784",
		GrabWalk = "rbxassetid://73786982077847",
		GrabRun = "rbxassetid://81241266142076",
		GrabThrow = "rbxassetid://113341114154649",
		GrabVictimSuccess = "rbxassetid://103728564252279",
		GrabVictimIdle = "rbxassetid://133322104651075",
		GrabVictimWalk = "rbxassetid://109484361308811",
		GrabVictimRun = "rbxassetid://83915816771671",
		GrabVictimThrow = "rbxassetid://127270614280548",
		GolemStateEnter = "rbxassetid://102926399930976",
		GolemStateIdle = "rbxassetid://74563914886530",
		GolemStateExit = "rbxassetid://75717991800694",
		GolemIdle = "rbxassetid://86695374427132",
		GolemWalk = "rbxassetid://131254280180461",
		GolemRun = "rbxassetid://84708586729159",
		GolemFissure = "rbxassetid://123139589519631",
		GolemShockwave = "rbxassetid://76372125496160",
		GolemSlash = "rbxassetid://127127827342972",
		GolemSpawn = "rbxassetid://106016750602687",
		Execution = {
			KillerRig = "rbxassetid://79845039586897",
			PlayerRig = "rbxassetid://112882309418350",
			PlayerCFrameOffset = CFrame.Angles(0, 3.141592653589793, 0) * CFrame.new(0, 0, 4)
		},
		ExecutionTwoTime = {
			KillerRig = "rbxassetid://128390482455128",
			PlayerRig = "rbxassetid://85668437917455",
			PlayerCFrameOffset = CFrame.Angles(0, 3.141592653589793, 0) * CFrame.new(0, 0, 5.5)
		},
		Stunned = {
			Start = "rbxassetid://97327501441746",
			Loop = "rbxassetid://135587222605953",
			End = "rbxassetid://112260168047198"
		},
		Introduction = {
			KillerRig = "rbxassetid://99862292609985",
			CameraRig = "rbxassetid://70860473278975",
			SpawnRig = "rbxassetid://103946386785266"
		},
		Victory = {
			KillerRig = "rbxassetid://126686628725119",
			CameraRig = "rbxassetid://128485795738012",
			GolemRig = "rbxassetid://136781862662502"
		},
		Slash = "rbxassetid://115126568781000",
		Sow = "rbxassetid://77800906660950",
		Stigmatize = "rbxassetid://93588840734851",
		UnravelEnter = "rbxassetid://77637839017455",
		UnravelExit = "rbxassetid://102144275890241"
	},
	Sounds = {
		BuildDenied = "rbxassetid://77989637472055",
		Footsteps = {
			"rbxassetid://72284708186918",
			"rbxassetid://112935649312256"
		},
		GolemFootsteps = {
			"rbxassetid://134979567761607",
			"rbxassetid://70542661429129"
		},
		TerrorRadiusThemes = {
			[60] = {
				ID = "rbxassetid://85934184350603",
				BPM = 73
			},
			[45] = {
				ID = "rbxassetid://92304650503477",
				BPM = 73
			},
			[20] = {
				ID = "rbxassetid://113078392528411",
				BPM = 73
			},
			[10] = {
				ID = "rbxassetid://120164260890660",
				BPM = 73,
				Chase = true
			}
		},
		Execution = "rbxassetid://131408220686394",
		ExecutionTwoTime = "rbxassetid://129452815754085",
		Stunned = "rbxassetid://112687654323831",
		SlashWindup = "rbxassetid://133709029886490",
		Slash = "rbxassetid://72184219453718",
		SlashExtending = "rbxassetid://138975519009537",
		SlashExtensionEnd = "rbxassetid://110561505052595",
		SlashHit = "rbxassetid://101602364808662",
		VictimInRange = "rbxassetid://131009722180917",
		VictimOutOfRange = "rbxassetid://90166511077825",
		GrabBegin = "rbxassetid://75608547833264",
		GrabEnd = "rbxassetid://97568182472477",
		GrabWarning = "rbxassetid://83670330516008",
		GrabAimStart = "rbxassetid://138804776397042",
		GrabAimStartAlertGlobal = "rbxassetid://90747727146965",
		GrabShoot = "rbxassetid://135352373438497",
		GrabHookTravel = "rbxassetid://88482008304729",
		GrabHookImpact = "rbxassetid://94802858846285",
		GrabPullFinished = "rbxassetid://105424580128403",
		GrabGrab = "rbxassetid://98818188773740",
		GrabGrabbed = "rbxassetid://94356946681953",
		GrabThrow = "rbxassetid://73668380758034",
		GrabThrown = "rbxassetid://132173082718180",
		GrabImpact = "rbxassetid://91288569991875",
		SmashWindup = "rbxassetid://140569956616627",
		Smash = "rbxassetid://130896140725074",
		SmashHit = "rbxassetid://136716407928459",
		SmashPowerWindup = "rbxassetid://129470820563257",
		SmashPower = "rbxassetid://135041815780073",
		SowWindup = "rbxassetid://139606598218899",
		Sow = "rbxassetid://140309071002261",
		SowHit = "rbxassetid://139392561218428",
		SowMiss = "rbxassetid://87757790059469",
		GolemAzureLeave = "rbxassetid://125519981804846",
		GolemEnragedSpawn = "rbxassetid://139918501762915",
		GolemEnragedIdle = "rbxassetid://5347824216",
		GolemAzureReturn = "rbxassetid://107335519060206",
		GolemSpawned = "rbxassetid://138357314597740",
		GolemReleased = "rbxassetid://124714648169341",
		GolemControlled = "rbxassetid://126673577589055",
		ShockwaveWindup = "rbxassetid://89939722286254",
		Shockwave = "rbxassetid://139316396351592",
		FissureWindup = "rbxassetid://82882932068473",
		FissureStomp = "rbxassetid://101167426594884",
		FissureExplosion = { "rbxassetid://75415563975442" },
		Blossom = "rbxassetid://108426763351270",
		Unravel = "rbxassetid://135248718361614"
	},
	VoicelineVolume = 2,
	Voicelines = {
		Introduction = {
			"rbxassetid://116018330831046",
			"rbxassetid://71877522808432",
			"rbxassetid://81078380126586",
			"rbxassetid://92299892895230"
		},
		Idle = {
			"rbxassetid://98627175224202",
			"rbxassetid://76787442186225",
			"rbxassetid://123863218582501",
			"rbxassetid://112022304345867",
			"rbxassetid://130866551037241"
		},
		LastSurvivor = {
			"rbxassetid://70779634858417",
			"rbxassetid://127369468467233"
		},
		LastSurvivorTwoTime = {
			"rbxassetid://72765663321300",
			"rbxassetid://117000746105037",
			"rbxassetid://118285406172391",
			"rbxassetid://71559838340804",
			"rbxassetid://72765663321300",
			"rbxassetid://117000746105037",
			"rbxassetid://118285406172391",
			"rbxassetid://71559838340804"
		},
		Kill = {
			"rbxassetid://127025542819285",
			"rbxassetid://101436377218525",
			"rbxassetid://120463864332612",
			"rbxassetid://72372011645880",
			"rbxassetid://101107267534662"
		},
		KillDusekkar = { "rbxassetid://98100228315470" },
		KillTwoTime = {
			"rbxassetid://112182248771371",
			"rbxassetid://90252773532004",
			"rbxassetid://139639820480491",
			"rbxassetid://73231863612753",
			"rbxassetid://80474358126563",
			"rbxassetid://115237151620575",
			"rbxassetid://127956181235179",
			"rbxassetid://112182248771371",
			"rbxassetid://90252773532004",
			"rbxassetid://139639820480491",
			"rbxassetid://73231863612753",
			"rbxassetid://80474358126563",
			"rbxassetid://115237151620575",
			"rbxassetid://127956181235179"
		},
		Stunned = {
			"rbxassetid://113825289795708",
			"rbxassetid://118343186334090",
			"rbxassetid://119835038613933",
			"rbxassetid://94929622697915"
		},
		Stigmatize = {
			"rbxassetid://124439227472393",
			"rbxassetid://126189791987548",
			"rbxassetid://109451486041365",
			"rbxassetid://90168413523433"
		},
		StigmatizeGrab = { nil },
		Seeker = {
			"rbxassetid://123618521620954",
			"rbxassetid://135280238776797",
			"rbxassetid://120121060127946",
			"rbxassetid://121423937743854",
			"rbxassetid://84618452220020"
		},
		GrabStart = { nil },
		GrabHit = {
			"rbxassetid://84070509309406",
			"rbxassetid://75500293231059",
			"rbxassetid://77869949429863",
			"rbxassetid://139370389365913"
		},
		GrabThrow = {
			"rbxassetid://95722429338342",
			"rbxassetid://134694074281190",
			"rbxassetid://123417098029122",
			"rbxassetid://107486215595594"
		},
		CreateGolem = {
			"rbxassetid://90300635055184",
			"rbxassetid://139481158400680",
			"rbxassetid://105983797506629",
			"rbxassetid://139797359528837",
			"rbxassetid://125318257839335"
		},
		ReleaseGolem = {
			"rbxassetid://129766284498020",
			"rbxassetid://80671677106030",
			"rbxassetid://92613248016766"
		},
		ShockwaveGolem = {
			"rbxassetid://77550935441326",
			"rbxassetid://103396381806114",
			"rbxassetid://120042317455657"
		},
		StompGolem = {
			"rbxassetid://128104645219603",
			"rbxassetid://137223541159517",
			"rbxassetid://116975559482707"
		},
		SwapGolem = { nil },
		Victory = {
			"rbxassetid://101963941195702",
			"rbxassetid://122780841826869",
			"rbxassetid://126683942082293",
			"rbxassetid://80108250538485"
		}
	},
	ClientConstructBehavior = {
		GroundBulb = require(script.cl_ObjectBehavior.cl_GroundBulb),
		Vine = require(script.cl_ObjectBehavior.cl_Vine)
	}
}

t1.ClientConstructConfigs = {
	GroundBulb = {
		HighlightTemplate = t1.Instances.PlantHighlight,
		FireVFX = t1.Instances.BulbFireVFX,
		TimeGui = t1.Instances.WitherTimeGui,
		Animations = {
			ActiveIdle = "rbxassetid://93905269540864",
			Shoot = "rbxassetid://106705357632608",
			SleepIdle = "rbxassetid://118066012409133",
			SpawnIn = "rbxassetid://140713249229718",
			Wakeup = "rbxassetid://96416601010850",
			WitherStartup = "rbxassetid://136572430376599",
			WitherLoop = "rbxassetid://105096338744781",
			WitherWakeup = "rbxassetid://86114117941760"
		}
	},
	Vine = {
		TimeGui = t1.Instances.WitherTimeGui,
		Animations = {
			ActiveIdle = "rbxassetid://93905269540864",
			Shoot = "rbxassetid://106705357632608",
			SleepIdle = "rbxassetid://118066012409133",
			SpawnIn = "rbxassetid://140713249229718",
			Wakeup = "rbxassetid://96416601010850",
			WitherStartup = "rbxassetid://73363782513275",
			WitherLoop = "rbxassetid://117252044135813",
			WitherWakeup = "rbxassetid://131422974466895",
			CooldownLoop = "rbxassetid://117252044135813",
			CooldownEnd = "rbxassetid://131422974466895"
		}
	}
}
t1.ConstructConfigs = {
	GroundBulb = {
		Radius = 30,
		Ammo = 15000,
		HitboxSize = Vector3.new(3, 3, 3),
		ProjectileSpeed = 90,
		BloomingOnActivated = 6,
		BloomingOnAwaken = 40,
		BloomingTime = 40,
		SleepingTime = 30,
		AtropaOnHit = 1,
		Damage = {
			[2] = 4,
			[3] = 4
		},
		ProjectileModel = t1.Instances.BulbProjectile,
		Windup = {
			[2] = 0.6,
			[3] = 0.45
		},
		ShotDebounce = {
			[2] = 0.5,
			[3] = 0.4
		},
		Sounds = {
			Activate = "rbxassetid://71444040108166",
			ShotWarning = "rbxassetid://76878548220965",
			Shot = "rbxassetid://82137138941528",
			DryFire = "rbxassetid://132693556036201",
			HitHuman = "rbxassetid://140209514807090",
			HitOther = "rbxassetid://93823717378227",
			Death = "rbxassetid://93177178635033",
			ProjectileIdle = "rbxassetid://109549055900357",
			DefuseSound = "rbxassetid://87467315104742"
		}
	},
	Vine = {
		Damage = 12,
		Radius = 20,
		PlaceWindup = 1.2,
		HitboxLength = 20,
		HitboxHeight = 6,
		HitboxWidth = 10,
		DamageToRelease = 10,
		BloomingOnActivated = 6,
		BloomingOnAwaken = 40,
		BloomingTime = 40,
		SleepingTime = 30,
		AtropaOnHit = 3,
		Windup = {
			[2] = 0.6,
			[3] = 0.4
		},
		MissAttackCooldown = {
			[2] = 6.5,
			[3] = 4
		},
		EscapeCooldown = {
			[2] = 6.5,
			[3] = 4
		},
		TrapLength = {
			[2] = 5,
			[3] = 5
		},
		Sounds = {
			Spawn = "rbxassetid://78252823473978",
			Activate = "rbxassetid://76878548220965",
			Ready = "rbxassetid://138303423691789",
			PrepareAttack = "rbxassetid://77394486355187",
			Attack = "rbxassetid://116107946837042",
			Hit = "rbxassetid://139821087453742",
			Death = "rbxassetid://93177178635033",
			Escape = "rbxassetid://109180307068479",
			DefuseSound = "rbxassetid://111203656225532"
		},
		StatusesOnRelease = {
			Speed = {
				Level = 2,
				Duration = 1
			}
		}
	}
}
                                                                       
t1.PlantSpawnExclusionRadius = 20
t1.ConstructConfigs.GroundBulb.Damage = {[2] = 2.5, [3] = 2.5}
                                                                         
t1.ConstructConfigs.GroundBulb.ShotDebounce = {[2] = 0.5 / 0.85, [3] = 0.4 / 0.85}
t1.ConstructConfigs.Vine.Damage = 10
t1.ConstructConfigs.Vine.HitboxHeight = 6
t1.ConstructConfigs.Vine.Windup = {[2] = 0.6, [3] = 0.4}
t1.ConstructConfigs.Vine.MissAttackCooldown = {[2] = 6.5, [3] = 4}
t1.ConstructConfigs.Vine.EscapeCooldown = {[2] = 6.5, [3] = 4}
t1.ConstructConfigs.Vine.StatusesOnRelease.Speed.Duration = 1.5
t1.Grab.CooldownMiss = 20
t1.Grab.CooldownSuccess = 20
t1.GolemShockwave.Damage = 30
t1.GolemFissure.Damage = 10
t1.GolemFissure.VictimSpeedMult = 0.5
t1.Golem.InvulnOnSwitch = 1.5

t1.Information = {
	{
		Separator = "GENERAL INFO"
	},
	{
		Header = "AZURE",
		Text = "The remains of a withered spirit controlled by the hands of others. Azure springs new life to shutdown and control the survivors movement. When at their zenith, Azure summons an overwhelming construct to cull any in his path."
	},
	{
		Header = "STATS",
		Text = "Difficulty: ★★★★★\n" .. `Health: { t1.Health }\n` .. `Regular Speed: { t1.Speed }\n` .. `Sprinting Speed: { t1.SprintSpeed }\n` .. `Max Stamina: { t1.MaxStamina }\n` .. `Stamina Loss per sec: { t1.StaminaLoss }\n` .. `Stamina Gain per sec: { t1.StaminaGain }\n` .. "Terror Radius: 75 studs\n"
	},
	{
		Separator = "PASSIVES"
	},
	{
		Header = "ECHOLOCATION",
		Quote = "\"The transient sounds of winds sound softer today.\" -Aspen",
		Text = "<b><font color=\"rgb(238, 23, 255)\">Azure</font></b>'s plants are triggered by sound. If survivors sprint or use an ability near them, they will trigger and attack the survivor.\nSurvivors that trigger plants have their aura revealed to <b><font color=\"rgb(238, 23, 255)\">Azure</font></b> for 3s.\n"
	},
	{
		Header = "ATROPIC",
		Quote = "\"May nature's hands be kinder than the folly of man..\" -Aspen",
		Text = "<b><font color=\"rgb(238, 23, 255)\">Azure</font></b>'s plants apply a unique status effect named <b>Atropa</b>. This status effect is the primary way to gain <b>OBLATION</b>. <b>OBLATION</b> is also gained through dealing damage.\n" .. "<b><font color=\"rgb(238, 23, 255)\">Azure</font></b> gains 1 <b>OBLATION</b> for every stack of <b>Atropa</b> on a survivor when hit with Perforating. If <b>Atropa</b> expires naturally, <b><font color=\"rgb(238, 23, 255)\">Azure</font></b> gains 1 <b>OBLATION</b> for every 2 stacks of <b>Atropa</b>, with a minimum of 1 <b>OBLATION</b> gained.\n" .. `Additionally, Perforating and Pummeling will deal { t1.Slash.DamagePerAtropa } additional damage for every stack of <b>Atropa</b> on a survivor when hit. However, this will also remove all <b>Atropa</b> stacks.\n` .. "<b>Atropa</b> highlights survivors affected by it to <b><font color=\"rgb(238, 23, 255)\">Azure</font></b>, with the highlight growing darker the more stacks they have.\n" .. "Seeker Bulb's inflict 1 stack of <b>Atropa</b> on hit, Stigmatize Vine's inflict 3 stacks of <b>Atropa</b> on hit, and a survivor fully disarming either of them is inflicted with 2 stacks of <b>Atropa</b>.\n" .. "<b>Atropa</b> can not go beyond <b>6</b> stacks, and additional stacks do not refresh the existing status timer.\n" .. "<b><font color=\"rgb(238, 23, 255)\">Azure</font></b> can have a maximum of 15 <b>OBLATION</b>.\n"
	},
	{
		Header = "SENESCENCE",
		Quote = "\"Sometimes I dream of him being plagued by illness. Freed from them.\" -Aspen",
		Text = "<b><font color=\"rgb(238, 23, 255)\">Azure</font></b>'s plants are able to be temporarily disarmed by survivors.\n" .. "However, <b><font color=\"rgb(238, 23, 255)\">Azure</font></b>'s Seeker Bulb's and Stigmatize Vine's begin life <b>Blooming</b>. <b>Blooming</b> plants are glowing, unable to be disarmed, and have certain traits amplified.\n" .. "Seeker Bulb's will fire faster while <b>Blooming</b>, and Stigmatize Vine's have a faster windup and lower attack cooldown while <b>Blooming</b>.\n" .. `If either plant is disarmed, they will enter a withered state and become inactive for { t1.ConstructConfigs.GroundBulb.SleepingTime }s.\n` .. "However, once a plant becomes active again, they will begin <b>Blooming</b> once more.\n" .. `The <b>Blooming</b> state lasts for { t1.ConstructConfigs.GroundBulb.BloomingTime }s.\n`
	},
	{
		Separator = "ABILITIES"
	},
	{
		Image = "rbxassetid://123556520269026",
		Header = "PERFORATING",
		Quote = "\"May your faith remain unshaken, and your strength never yield.\" -Elder Amarah",
		Text = "Cooldown: 1.8s\n" .. `Damage: { t1.Slash.Damage }\n` .. `Windup: { t1.Slash.Windup }\n` .. `Linger: { t1.Slash.Linger }\n` .. "Length: 8.5 studs\n" .. "<b><font color=\"rgb(238, 23, 255)\">Azure</font></b> jabs his tentacles forward.\n" .. "This will additionally trigger any nearby plants on hit.\n"
	},
	{
		Image = "rbxassetid://109787679155717",
		Header = "SEEKER BULB",
		Quote = "\"Certain types of nightshade can be fatal, so be careful...\" -Aspen",
		Text = "Cooldown: 12s \n" .. `<b><font color="rgb(238, 23, 255)">Azure</font></b> will slow down and then after a { t1.Sow.Windup }s windup will jab a tentacle forward, spawning a Seeker Bulb on the hit surface.\n` .. "Upon being triggered, they will begin to fire projectiles at the survivor who activated it, dealing 2.5 damage and applying a stack of <b>Atropa</b> on hit.\n" .. "Seeker Bulbs will stop firing after 1.5s if they lose line of sight of survivors or survivors stop making noise near it.\n" .. "<b><font color=\"rgb(238, 23, 255)\">Azure</font></b> can have up to 3 Seeker Bulbs at once. Using the ability again with 3 Seeker Bulbs placed will replace the oldest one.\n"
	},
	{
		Image = "rbxassetid://117545955019424",
		Header = "STIGMATIZE",
		Quote = "\"Perhaps we could ask if we could handle these overgrowths ourselves?\" -Two Time",
		Text = "Cooldown: 15s \n" .. `<b><font color="rgb(238, 23, 255)">Azure</font></b> will briefly come to a near standstill and then after a { t1.Blossom.Windup }s windup will summon a Vine.\n` .. `Vines have a brief { t1.ConstructConfigs.Vine.PlaceWindup }s arm time after they are finished being summoned.\n` .. "The Vines will always face towards the nearest survivor regardless of distance unless they are <b>Undetectable</b>.\n" .. `Upon being triggered, they will attempt to attack the nearest survivor to trap them. The attack has a { t1.ConstructConfigs.Vine.Windup[2] }s/{ t1.ConstructConfigs.Vine.Windup[3] }s windup when Blooming/not Blooming.\n` .. "If the attack hits a survivor, they will become snared and unable to move more than a small distance away from the Vine before being pulled back in.\n" .. `Survivors are released from the snare after 5s of being trapped or they take more than { t1.ConstructConfigs.Vine.DamageToRelease } damage.\n` .. `Upon being released, survivors gain <b>Speed II</b> for { t1.ConstructConfigs.Vine.StatusesOnRelease.Speed.Duration }s.\n` .. `After releasing a survivor or missing an attack, the Vine will briefly wither and go on a { t1.ConstructConfigs.Vine.MissAttackCooldown[2] }s/{ t1.ConstructConfigs.Vine.MissAttackCooldown[3] }s cooldown when Blooming/not Blooming before being able to be triggered again.\n`
	},
	{
		Image = "rbxassetid://115907381502841",
		Header = "ENSTRANGLE",
		Quote = "\"Holding your hand like this... makes me not want to let go..\" -Two Time",
		Text = `Cooldown: { t1.Grab.CooldownMiss }s\n` .. `<b><font color="rgb(238, 23, 255)">Azure</font></b> becomes unable to sprint and winds up a tentacle for { t1.Grab.Windup }s, after which <b><font color="rgb(238, 23, 255)">Azure</font></b> can press the Perforating ability button to send a tentacle towards the targeted location.\n` .. "<b><font color=\"rgb(238, 23, 255)\">Azure</font></b> is able to cancel the ability by pressing the button again, which will set it on a shortened cooldown.\n" .. "Upon hitting a survivor, they will take 10 damage and <b><font color=\"rgb(238, 23, 255)\">Azure</font></b> will regain the ability to sprint while grabbing them and holding the caught survivor for a bit before throwing them towards the targeted location. <b><font color=\"rgb(238, 23, 255)\">Azure</font></b> can press the Perforating ability button again to throw the held survivor early.\n" .. `The thrown survivor takes { t1.Grab.Damage } damage and is briefly knocked down on impact. Survivors within a { t1.Grab.BlastRadius } stud radius of the impact point are also briefly knocked down.\n` .. "<b><font color=\"rgb(238, 23, 255)\">Azure</font></b> is inflicted with <b>Helpless</b> for 2s upon throwing the survivor. If the survivor is thrown too close to <b><font color=\"rgb(238, 23, 255)\">Azure</font></b>, the duration of the <b>Helpless</b> is increased and <b><font color=\"rgb(238, 23, 255)\">Azure</font></b> will additionally suffer <b>Slowness II</b> for 2s.\n" .. "While using this ability <b><font color=\"rgb(238, 23, 255)\">Azure</font></b> has their Stamina Regeneration reduced by 75%.\n" .. "Thrown survivors will always trigger any nearby plants upon landing.\n"
	},
	{
		Image = "rbxassetid://109425766636886",
		Header = "INFLORESCENCE",
		Quote = "\"Rise, once more, Azurewrath.\"",
		Text = `Once <b><font color="rgb(238, 23, 255)">Azure</font></b> reaches 15 <b>OBLATION</b>, they are able to summon <b><font color="rgb(128, 24, 255)">the Golem</font></b>. Summoning <b><font color="rgb(128, 24, 255)">the Golem</font></b> takes { t1.GolemSpawn.Windup }s.\n` .. "After <b><font color=\"rgb(128, 24, 255)\">the Golem</font></b> has finished summoning, they are able to be freely controlled by <b><font color=\"rgb(238, 23, 255)\">Azure</font></b> by pressing the ability button again. <b><font color=\"rgb(128, 24, 255)\">The Golem</font></b> becomes a statue when not being controlled.\n" .. `<b><font color="rgb(128, 24, 255)">The Golem</font></b> has a maximum lifetime of { t1.Golem.BaseLifetime }s, and the lifetime is paused while not being controlled.\n` .. `Swapping to and from <b><font color="rgb(128, 24, 255)">the Golem</font></b> has a cooldown of { t1.Golem.TransferCooldown }s.\n` .. "<b><font color=\"rgb(238, 23, 255)\">Azure</font></b> is unable to gain <b>OBLATION</b> while <b><font color=\"rgb(128, 24, 255)\">the Golem</font></b> exists.\n"
	},
	{
		Separator = "GOLEM INFO"
	},
	{
		Header = "GOLEM",
		Text = "A nightmareish golem."
	},
	{
		Header = "STATS",
		Text = "Regular Speed: 9\n" .. "Sprinting Speed: 30\n" .. "Max Stamina: 50\n" .. `Stamina Loss per sec: { t1.StaminaLoss }\n` .. `Stamina Gain per sec: { t1.StaminaGain }\n`
	},
	{
		Separator = "PASSIVES"
	},
	{
		Header = "EFFLORESCENT",
		Quote = "\"I will guide you through the twilight, into an eternal hell.\" -???",
		Text = "<b><font color=\"rgb(128, 24, 255)\">The Golem</font></b> gains a 10% movement speed boost while more than 85 studs away from any survivor.\n<b><font color=\"rgb(128, 24, 255)\">The Golem</font></b> reduces all incoming negative status effects by <b>50%</b> and can not be stunned.\nIf <b><font color=\"rgb(128, 24, 255)\">the Golem</font></b> is hit by a stun, it will instead receive 3s of <b>Slowness II</b> and <b>Helpless</b>.\n"
	},
	{
		Separator = "ABILITIES"
	},
	{
		Image = "rbxassetid://89466282291815",
		Header = "PUMMELING",
		Quote = "\"Never again.\" -Azurewrath",
		Text = `Cooldown: { t1.Smash.Cooldown }s\n` .. `Damage: { t1.Smash.Damage }\n` .. `Windup: { t1.Smash.Windup }\n` .. `Linger: { t1.Smash.Linger }\n` .. "Length: 10 studs\n" .. "<b><font color=\"rgb(128, 24, 255)\">The Golem</font></b> swipes its claw forward.\n"
	},
	{
		Image = "rbxassetid://104124585268095",
		Header = "BLOOMING",
		Quote = "\"Let your strengths remain unshaken, and your emotions never falter.\" -???",
		Text = `Cooldown: { t1.GolemShockwave.Cooldown }s \n` .. `After a { t1.GolemShockwave.Windup }s windup, <b><font color="rgb(128, 24, 255)">the Golem</font></b> will slam the ground under it and produce a shockwave that knocks over hit survivors briefly and deals damage based on how close they are to the center of the shockwave, up to { t1.GolemShockwave.Damage } damage.\n`
	},
	{
		Image = "rbxassetid://135461293091840",
		Header = "UNEARTHING",
		Quote = "\"Those guided by the Spawn cannot be tempted by the anger of the beasts that lurk outside of our Family.\" -Elder Amarah",
		Text = `Cooldown: { t1.GolemFissure.Cooldown }s \n` .. `After a { t1.GolemFissure.Windup }s windup, <b><font color="rgb(128, 24, 255)">the Golem</font></b> will stomp the ground and send a shockwave forwards that will knock back hit survivors and deal { t1.GolemFissure.Damage } damage.\n` .. `As the shockwave travels, it will leave behind a fissure in its wake. This fissure slows survivors by <b>50%</b> while they are inside of it. The fissure lasts for { t1.GolemFissure.CrackLifetime }s.\n` .. "Survivors are able to be carried by the shockwave as it travels, but will not take more than one instance of damage.\n"
	},
	{
		Image = "rbxassetid://104920945686953",
		Header = "BURROWING",
		Quote = "\"You chose the Spawn. Never me.\" -Azurewrath",
		Text = "Relinquish control of <b><font color=\"rgb(128, 24, 255)\">the Golem</font></b> and return to <b><font color=\"rgb(238, 23, 255)\">Azure</font></b>.\n"
	},
	{
		Separator = "CREDITS",
		Text = "Creator: MontaigneProgrammer: OutIaw_Nova, devcrutWriter: 4Montaigne, sayso_1230Composer: LexxiemowVoice Actor: LumiNovaVAAnimator: c2o, BruhMoment, sayso_1230Modeller: BakedMesh, trixiibel, BirdieCandles, AlexIsFunnyRenderer: kackleboxKit Concepter: Speedz, Collusiam, Eno, Lexxiemow, SoyS3BASTIAN, voxov_tiredIcon Artist: glubbee"
	}
}

return t1
]====]},
{path=[====[
ReplicatedStorage/Assets/Killers/Azure/Config/cl_ObjectBehavior/cl_GroundBulb]====],before="32876:309b4cbd:3f2ed240",previous="36718:02f31c22:b9d461bb",previous2="36723:3ec60adc:a79fdd17",after="36740:747974d3:287aab64",source=[====[
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
]====]},
{path=[====[
ReplicatedStorage/Assets/Killers/Azure/Config/cl_ObjectBehavior/cl_Vine]====],before="42392:a149b22a:0f6bee39",previous="48530:4b8a008c:1f4d2caf",previous2="48535:5c3f2046:2023f0db",after="48546:c240c124:a1a0b113",source=[====[
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
]====]},
{path=[====[
ReplicatedStorage/Assets/Killers/Azure/Config/cl_WorkaroundModules/cl_ConstructQTE]====],before="18703:62d0ec4e:51f0ba7d",previous="19934:e4936693:d2e8296e",after="19939:a81587ed:1556ffe8",source=[====[
-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- DgN4BnR5cGVvZgV0YWJsZQZpcGFpcnMDTWluA01heA9nZXRIaXRab25lSW5kZXgFcGFpcnMVZ2V0Q29tcGxldGVkWm9uZUNvdW50Ck5leHROdW1iZXILTnVtYmVyUmFuZ2UDbmV3Bmluc2VydARzb3J0D2NyZWF0ZVFURUJvdW5kcwVjbGVhcglkZWVwQ2xlYXIFVmFsdWUJUVRFQm91bmRzDkNvbXBsZXRlZFpvbmVzB0NsaWNrZWQGUGFyZW50CEdldFBpdm90CFBvc2l0aW9uCU1hZ25pdHVkZQdEZXN0cm95EE1hcmtlclNwZWVkQm9vc3QEbWF0aANtYXgLTWFya2VyUGhhc2UDc2luA2NvcxNMYXN0TWFya2VyRGlyZWN0aW9uAlVJD1BsYXlDb3JuZXJTb3VuZAZVcGRhdGUNTW92ZURpcmVjdGlvbgJvcwVjbG9jawZIZWFsdGgMUGxheUhpdFNvdW5kC0FkZFByb2dyZXNzDkZhaWxlZEF0dGVtcHRzEVdhcm5GYWlsZWRBdHRlbXB0EV9fb25CdXR0b25QcmVzc2VkB0tleUNvZGUERW51bQVTcGFjZQ1Vc2VySW5wdXRUeXBlDE1vdXNlQnV0dG9uMQVUb3VjaAR3YXJuCmNvbnNvbGUgZXIIQnV0dG9uUjIJQ2hhcmFjdGVyD0dldFBsYXllckRldmljZQdJc0FsaXZlDHNldG1ldGF0YWJsZQRNYWlkCUNhbGxiYWNrcwhQcm9ncmVzcyFbIUF6dXJlXTogTm8gVUkgb2JqZWN0IHBhc3NlZCBpbiEISHVtYW5vaWQIQXp1cmVRVEUVQ3JlYXRlU3BlZWRNdWx0aXBsaWVyDVJlbmRlclN0ZXBwZWQHQ29ubmVjdAlBZGRUb01haWQYR2V0UHJvcGVydHlDaGFuZ2VkU2lnbmFsD0FuY2VzdHJ5Q2hhbmdlZAlTdGFydFRpY2sCUEMKSW5wdXRCZWdhbi9DbGljayB3aGVuIHRoZSBCYXIgaG92ZXJzIG92ZXIgb25lIG9mIHRoZSBab25lcwZNb2JpbGUtVGFwIHdoZW4gdGhlIEJhciBob3ZlcnMgb3ZlciBvbmUgb2YgdGhlIFpvbmVzMlByZXNzIFIyIHdoZW4gdGhlIEJhciBob3ZlcnMgb3ZlciBvbmUgb2YgdGhlIFpvbmVzDUNy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

-- decompilation:
local t1 = {}

t1.__index = t1

local ReplicatedStorage = game:GetService("ReplicatedStorage")

game:GetService("TweenService")
game:GetService("Debris")

local RunService = game:GetService("RunService")

game:GetService("HttpService")

local UserInputService = game:GetService("UserInputService")

require(ReplicatedStorage.GlobalTypes)
require(ReplicatedStorage.Modules.Misc.Signal)

local Maid = require(ReplicatedStorage.Modules.Misc.Maid)
local Util = require(ReplicatedStorage.Modules.Util)

require(ReplicatedStorage.Modules.Sounds)
require(ReplicatedStorage.Modules.Actors)
require(ReplicatedStorage.Modules.Hitboxes)

local Device = require(ReplicatedStorage.Modules.Device)
local LocalPlayer = game.Players.LocalPlayer
local u9 = nil
local random = Random.new()

local function getHitZoneIndex(p1, p2, p3) -- line: 33
	if typeof(p2) == "table" then
		for i, v in ipairs(p2) do
			if not p3[i] and p1 >= v.Min and p1 <= v.Max then
				return i
			end
		end

		return nil
	end

	if p1 >= p2.Min and p1 <= p2.Max then
		return 1
	end

	return nil
end
local function getCompletedZoneCount(p4) -- line: 50
	local n1 = 0

	for _, v in pairs(p4) do
		if v then
			n1 += 1
		end
	end

	return n1
end
local function createQTEBounds() -- line: 61
	-- upvalues: random (copy)
	for _ = 1, 30 do
		local t2 = {}

		for _ = 1, 3 do
			local v27 = random:NextNumber(0.05, 0.7999999999999999)

			table.insert(t2, NumberRange.new(v27, v27 + 0.15))
		end

		table.sort(t2, function(p5, p6) -- line: 69
			return p5.Min < p6.Min
		end)

		local v28 = true

		for i = 2, #t2 do
			if t2[i].Min - t2[i - 1].Max < 0.09 then
				v28 = false

				break
			end
		end

		if v28 then
			return t2
		end
	end

	return {
		NumberRange.new(0.16, 0.31),
		NumberRange.new(0.46, 0.61),
		NumberRange.new(0.76, 0.91)
	}
end
local function deepClear(p7) -- line: 93
	table.clear(p7)
end

function t1.new(t3: {[any]: any}, p8) -- line: 97
	-- upvalues: LocalPlayer (copy), Device (copy), Util (copy), u9 (ref), t1 (copy), Maid (copy), createQTEBounds (copy), RunService (copy), getHitZoneIndex (copy), UserInputService (copy)
	local Character = LocalPlayer.Character
	local PlayerDevice = Device:GetPlayerDevice()

	if not Util:IsAlive(Character) then
		return
	end

	if u9 then
		u9:Destroy()
	end

	u9 = nil

	local self = setmetatable({}, t1)

	self.Maid = Maid.new()
	self.Callbacks = {}
	self.Progress = 0
	self.QTEBounds = createQTEBounds()
	self.CompletedZones = {}
	self.MarkerPhase = os.clock() * 2.2
	self.MarkerSpeedBoost = 0
	self.LastMarkerDirection = not (math.cos(self.MarkerPhase) >= 0) and -1 or 1
	self.Value = math.sin(self.MarkerPhase) / 2 + 0.5
	self.FailedAttempts = 0

	if t3 then
		self.UI = t3.new(self)
	else
		warn("[!Azure]: No UI object passed in!")
	end

	local Position = Character:GetPivot().Position
	local Humanoid = Character.Humanoid
	local Health = Humanoid.Health
	local v39 = Util:CreateSpeedMultiplier(Character, 0, "AzureQTE")
	local Magnitude = Humanoid.MoveDirection.Magnitude
	local elapsed = os.clock()
	local u42 = false

	self:AddToMaid(RunService.RenderStepped:Connect(function(dt) -- line: 138
		-- upvalues: getHitZoneIndex (copy), self (copy), Character (copy), Position (copy)
		if not getHitZoneIndex(self.Value, self.QTEBounds, self.CompletedZones) then
			self.Clicked = false
		end

		local v68 = Character and (Character.Parent and Character:GetPivot().Position)

		if v68 and (v68 - Position).Magnitude > 1 then
			self:Destroy()
		end

		self.MarkerSpeedBoost = math.max(self.MarkerSpeedBoost - 10 * dt, 0)

		local v69 = self

		v69.MarkerPhase = v69.MarkerPhase + (2.2 + self.MarkerSpeedBoost) * dt
		self.Value = math.sin(self.MarkerPhase) / 2 + 0.5

		local v70 = not (math.cos(self.MarkerPhase) >= 0) and -1 or 1

		if v70 ~= self.LastMarkerDirection then
			self.LastMarkerDirection = v70

			if self.UI and self.UI.PlayCornerSound then
				self.UI:PlayCornerSound()
			end
		end

		if self.UI then
			self.UI:Update()
		end
	end))
	self:AddToMaid(Humanoid:GetPropertyChangedSignal("MoveDirection"):Connect(function() -- line: 164
		-- upvalues: Humanoid (copy), Magnitude (ref), elapsed (copy), u42 (ref), self (copy)
		local Magnitude2 = Humanoid.MoveDirection.Magnitude

		if Magnitude == 0 and (Magnitude2 > 0 and os.clock() >= elapsed + 0.25 and not u42) then
			u42 = true
			self:Destroy()
		end

		Magnitude = Magnitude2
	end))
	self:AddToMaid(Humanoid:GetPropertyChangedSignal("Health"):Connect(function() -- line: 174
		-- upvalues: Humanoid (copy), Health (ref), self (copy)
		if Humanoid.Health < Health then
			self:Destroy()
		end

		Health = Humanoid.Health
	end))
	self:AddToMaid(Character.AncestryChanged:Connect(function() -- line: 182
		-- upvalues: self (copy)
		self:Destroy()
	end))
	self.StartTick = os.clock()
	self.Clicked = false

	local function __onButtonPressed() -- line: 190
		-- upvalues: self (copy), getHitZoneIndex (copy), createQTEBounds (copy)
		if self.Clicked then
			return
		end

		self.Clicked = true

		local v72 = getHitZoneIndex(self.Value, self.QTEBounds, self.CompletedZones)

		if v72 then
			self.CompletedZones[v72] = true
			self.MarkerSpeedBoost = 4
			self.Clicked = false

			if self.UI and self.UI.PlayHitSound then
				self.UI:PlayHitSound()
			end

			local CompletedZones = self.CompletedZones
			local n2 = 0

			for _, v in pairs(CompletedZones) do
				if v then
					n2 += 1
				end
			end

			if n2 >= 3 then
				self.QTEBounds = createQTEBounds()
				table.clear(self.CompletedZones)
				self.MarkerSpeedBoost = 0
				self:AddProgress(33.333333333333336)

				return
			end
		else
			local v77 = self

			v77.FailedAttempts = v77.FailedAttempts + 1
			self.Clicked = false

			if self.FailedAttempts <= 1 then
				if self.UI and self.UI.WarnFailedAttempt then
					self.UI:WarnFailedAttempt()

					return
				end
			else
				self:Destroy()
			end
		end
	end

	local s1

	if PlayerDevice == "PC" then
		s1 = "Click when the Bar hovers over one of the Zones"
		self:AddToMaid((UserInputService.InputBegan:Connect(function(input, gameProcessed) -- line: 226
			-- upvalues: __onButtonPressed (copy)
			if gameProcessed then
				return
			end

			local v80 = input.KeyCode == Enum.KeyCode.Space

			if input.UserInputType == Enum.UserInputType.MouseButton1 or v80 then
				__onButtonPressed()
			end
		end)))
	elseif PlayerDevice == "Mobile" then
		s1 = "Tap when the Bar hovers over one of the Zones"
		self:AddToMaid((UserInputService.InputBegan:Connect(function(input, gameProcessed) -- line: 239
			-- upvalues: __onButtonPressed (copy)
			if gameProcessed then
				return
			end

			if input.UserInputType == Enum.UserInputType.Touch then
				__onButtonPressed()
			end
		end)))
	else
		s1 = "Press R2 when the Bar hovers over one of the Zones"
		self:AddToMaid((UserInputService.InputBegan:Connect(function(input, gameProcessed) -- line: 251
			-- upvalues: __onButtonPressed (copy)
			if gameProcessed then
				warn("console er")

				return
			end

			if input.KeyCode == Enum.KeyCode.ButtonR2 then
				__onButtonPressed()
			end
		end)))
	end

	Util:CreateWarning("AzureQTE", s1)
	self:AddToMaid(v39)
	self.WorkingOn = p8

	local p8Position = p8.Position
	local vector3 = Vector3.new(p8Position.X, Position.Y, p8Position.Z)

	Character:PivotTo(CFrame.new(Position) * CFrame.lookAt(Position, vector3).Rotation)
	u9 = self

	return self
end
function t1.AddProgress(t4: {[any]: any}, n3: number) -- line: 280
	t4.Progress = math.clamp(t4.Progress + n3, 0, 100)

	if t4.Progress >= 99 then
		t4:Destroy(true)
	end
end
function t1.AddToMaid(p9, p10) -- line: 287
	p9.Maid:Add(p10)
end
function t1.AddCallback(t5: {[any]: any}, s2: string, p11: ((...any) -> ...any), s3: string) -- line: 291
	if not t5.Callbacks[s2] then
		t5.Callbacks[s2] = {}
	end

	t5.Callbacks[s2][s3] = p11
end
function t1.RemoveCallback(t6: {[any]: any}, s4: string, s5: string) -- line: 299
	if not t6.Callbacks[s4] then
		return
	end

	t6.Callbacks[s4][s5] = nil
end
function t1.FireCallbacks(p12, p13, ...) -- line: 307
	for k, v in pairs(p12.Callbacks[p13] or {}) do
		local ok, result = pcall(v, ...)

		if not ok then
			warn(`[Azure]: Failed to run callback: { p13 }, { k }, { result }`)
		end
	end
end
function t1.Destroy(p14) -- line: 316
	-- upvalues: u9 (ref)
	warn("qte destroying on client", p14.Progress >= 99)
	p14:FireCallbacks("OnDestroyed", p14.Progress >= 99)

	if p14.UI then
		p14.UI:Destroy()
	end

	if p14.Maid then
		p14.Maid:Destroy()
	end

	setmetatable(p14, nil)
	table.clear(p14.Callbacks or {})
	table.clear(p14)
	u9 = nil
end

return t1
]====]},
{path=[====[
ReplicatedStorage/Assets/Killers/Azure/Config/cl_WorkaroundModules/cl_QTEUI]====],before="14127:03f4b08c:ccb011d9",previous="14692:a25d4973:f95b343c",after="14702:5ec3bde7:6170d1a8",source=[====[
-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- DgNmBlBhcmVudAZWb2x1bWUJUGxheWVyR3VpBFBsYXkMcGxheVFURVNvdW5kBVVEaW0yA25ldwFYBVNjYWxlBk9mZnNldAFZDW11bHRpcGx5VURpbTIGdHlwZW9mBXRhYmxlCWdldFJhbmdlcwpJbWFnZUxhYmVsA0lzQQtJbWFnZUJ1dHRvbgtJbWFnZUNvbG9yMwlHdWlPYmplY3QQQmFja2dyb3VuZENvbG9yMwtnZXRHdWlDb2xvcg9HZXRQbGF5ZXJEZXZpY2UMc2V0bWV0YXRhYmxlBE1haWQKWm9uZUZyYW1lcwZzY3JpcHQDUVRFBUNsb25lC1RlbXBvcmFyeVVJDFBhcmVudE9iamVjdAJVSQRab25lDFpvbmVUZW1wbGF0ZQhQb3NpdGlvbhBPcmlnaW5hbFBvc2l0aW9uF09yaWdpbmFsQmFja2dyb3VuZENvbG9yB1Zpc2libGUJQWRkVG9NYWlkBVZhbHVlCVFURUJvdW5kcw5Db21wbGV0ZWRab25lcwZpcGFpcnMGWm9uZSUqBmZvcm1hdAROYW1lB1ZlY3RvcjILQW5jaG9yUG9pbnQDTWF4A01pbgRtYXRoA21heAlmcm9tU2NhbGUEU2l6ZQdEZXN0cm95BExpbmUGVXBkYXRlCVRleHRMYWJlbAlUd2VlbkluZm8ERW51bQtFYXNpbmdTdHlsZQRRdWFkD0Vhc2luZ0RpcmVjdGlvbgNPdXQGQ3JlYXRlD09uQnV0dG9uUHJlc3NlZBtyYnhhc3NldGlkOi8vNzE0NjUzMjU2ODQxNjQMUGxheUhpdFNvdW5kG3JieGFzc2V0aWQ6Ly84MDMzMzAwNzE1NjEzMQ9QbGF5Q29ybmVyU291bmQbcmJ4YXNzZXRpZDovLzk2NTczMzIyNTU0OTg5CmZyb21PZmZzZXQGQ29sb3IzB2Zyb21SR0IEdGFzawVkZWxheRFXYXJuRmFpbGVkQXR0ZW1wdANBZGQFY2xlYXIHX19pbmRleARnYW1lEVJlcGxpY2F0ZWRTdG9yYWdlCkdldFNlcnZpY2UMVHdlZW5TZXJ2aWNlBkRlYnJpcwpSdW5TZXJ2aWNlC0h0dHBTZXJ2aWNlEFVzZXJJbnB1dFNlcnZpY2UHcmVxdWlyZQtHbG9iYWxUeXBlcwdNb2R1bGVzCVV0aWxpdGllcwZTaWduYWwEVXRpbAlSZW5kZXJpbmcGU291bmRzCEdhbWVwbGF5BkFjdG9ycwhIaXRib3hlcwZEZXZpY2UHUGxheWVycwtMb2NhbFBsYXllcgAPfwcCAgAAABEOAA8A+wIAAFIEAADiBQIA+wYBAE0GBpkDAAAAMAYFJAAAAACQBgEEMAYFSwEAAAC8AgLuBQAAACUCBAEAAAAAggABAAYDAQMCBQIAAQMDAs3MzMzMzOQ/AwQAGgUBGAABAAAAAAAAAAAAAAAAAAACGwAAAAABAA6cAQgCAAAAABikAgIAAAQAgE0EAHkDAAAATQQEhAQAAAAJAwQBTQUAeQMAAABNBQVwBQAAAAkEBQFNBgB4BgAAAE0GBoQEAAAACQUGAU0HAHgGAAAATQcHcAUAAAAJBgcBnwIFAIICAAAHAwYDBwQABACAAwgDCQMKAwsAIAwBGAAAAQAAAAABAAAAAAEAAAAAAQAAAAD8ACEAAAAAAGMDAQAACAAOuywAA1ICAACkAQEAAAAAQJ8BAgLwAQIAAgAAgIIAAgD/AQAAAQAAAFICAADFAQICAQAAAIIBAgADAw0EAAAAQAMOACkPARgAAAAAAAAAAQMAAAAAACoAAAAAAA+3AQQBAAAIAB1vAwAAvAEA/gEAAAAlAQMCAAAAACsBBgBvAwIAvAEA/gEAAAAlAQMCAQAAAA4BBABvAQMATQIAAAMAAACCAQMAbwMEALwBAP4BAAAAJQEDAgIAAAAOAQQAbwEFAE0CAJ8FAAAAggEDAMYBAADGAgAAggEDAAYDEAMRAxIDEwMUAxUAMRYBGAAAAAAAAAAAAAAAAAEAAAADAAAAAAABAAAAAwAAMgAAAAADAAMACQATFIcEBwEEAAAAVvsBAAC8AQEYAAAAACUBAgIAAAAA/wIEAAAAAAD7AwEAnj0CAwMAAACkAQIAAAAQQJ8BAwL7AgIATQIC7wMAAAAlAgECAQAAADACAXYEAAAA/wIAAAAAAAAwAgE+BQAAAKQCBwAAAGBATQICjAgAAAC8AgI6CQAAACUCAgICAAAA+wMDAE0DA5kKAAAATQMDRwsAAAAwAwIkDAAAADAAAT8NAAAAMAIBXA4AAABNAwIjDwAAALwDAzoJAAAAJQMCAgMAAAAwAwF/EAAAAG8GEQC8BAL+EgAAACUEAwIEAAAADgQDAE0DAjsTAAAAZQABAMYDAAAwAwEDFAAAAG8GEQC8BAL+EgAAACUEAwIFAAAADgQDAE0DAp8VAAAAZQABAMYDAAAwAwG8FgAAAE0DAiMPAAAAqQQAADAEA4AXAAAAUgUCALwDARQYAAAAJQMDAQYAAACCAQIAGQMXAxgEAAAQQAMHAxkDGgMbBAAAYEADHAMdAwMDHgMBAx8DIAMhAyIDFAMRAyMDJAMVAyUDJgMnAD0HARgAAAAAAAIAAAAAAAAAAQAAAAAAAAEAAAACAAAAAAAAAAEAAAAAAAACAAEAAQAAAAAAAAABAAAAAAAAAAAAAAABAAAAAAAAAAAAAAABAAAAAAEAAAAAAj4AAAAABwADABAAHgAvADYAQgBThQcSAQAACACVAU0BAD8AAAAATQEB7AEAAABNAwA/AAAAAE0DAzQCAAAAuywDA1IFAwCkBAQAAAAwQJ8EAgLwBAMABQAAgFICAwBlAAUA/wIAAAEAAABSBAMAxQIEAgEAAABNAwA/AAAAAE0DA+QGAAAAKwMCAP8DAAAAAAAApAQIAAAAcEBSBQIAJQQCBAAAAABRBEwATQoAPgkAAACHCQoHKwkgAE0KAH8KAAAAvAoKOgsAAAAlCgICAQAAAFIJCgBvCgwAUgwHALwKCo0NAAAAnwoDAjAKCboOAAAApAoRAABA8IBvCxIAbwwSACUKAwICAAAAMAoJ6BMAAACpCgEAMAoJgBQAAABNCgBcFQAAADAKCSQWAAAATQoAPgkAAABqCQoHTQ0ItBgAAABNDgjYGQAAACYMDQ54CwwXgRILBBcAAABvDBcApAocAABsoIGfCgMChwwDB1YLDAAwCwmAFAAAAKQLHwAAeNCBUgwKAIwNAQAlCwMCAwAAADALCS8gAAAApAsfAAB40IFNDQjYGQAAAE0QCLQYAAAATREI2BkAAAAmDxARPg4PIUMMDQ5vDRIAJQsDAgQAAAAwCwk7IgAAAG4Es/8CAACAHAcCAJUGByNNBwA+CQAAABwEBwCMBQEAqAQQAE0IAD4JAAAAhwcIBg4HCwBNCAA+CQAAAIcHCAa8BwdQJAAAACUHAgEFAAAATQcAPgkAAADGCAAAaggHBosE8P9NBABcFQAAAE0EBOklAAAApAUfAAB40IFSBgEAbwcSACUFAwIGAAAAMAUEOyIAAACCAAEAJgMfAygDKQMNBAAAMEADDgMqAysEAABwQAMaAyIDHQMsAy0DLgMvAwcEAEDwgAIAAAAAAADgPwMwAyYDIAMBAnsUrkfheoQ/AzEDMgMzAzQEAGyggQMGAzUEAHjQgQM2AgAAAAAAAABAAyMCAAAAAAAA8D8DNwM4AFI5ARgpAAAAAQAAANYAAAAAAAABAAMAAAAAJwAAAAAAAAIAAAAAAAEAAAEBAAAAAAAAAQAAAAAAAAEAAAAAAAAAAQAAAQAAAAEAAAMAAAAAAAAAAAAAAAEAAAABAAAAAAAAAAEAAAAAAAAAAAAAAAAAAADyABEAAAAAAAABAAAAAQAAAAAAAAEAAAD9BwAAAAAAAAAAAAAAASoAAAAABwAgACsAOQBbAGsAgQEAkAF/sQMKAQEAAAA/TQEAmgAAAABNAwCaAAAAAE0DAy8BAAAApAQEAAAMIIBNBgN5BgAAAE0GBoQHAAAAWwUGBU0HA3kGAAAATQcHcAgAAABbBgcFTQgDeAkAAABNCAiEBwAAAFsHCAVNCQN4CQAAAE0JCXAIAAAAWwgJBSUEBQIAAAAAUgIEADACAS8BAAAA+wEAAE0DAJoAAAAApAQLAAAMoIBvBQwApAYQAA840MCkBxMAEkTQwCUEBAIBAAAA4gUUAKQGFgAAVCCAbwcXAG8IFwAlBgMCAgAAADAGBS8BAAAAvAEBlhgAAAAlAQUCAwAAALwBAe4ZAAAAJQECAQQAAACCAAEAGgM6AzYDBgMHBAAMIIACAAAAAAAA9D8DCAMJAwoDCwM7BAAMoIACMzMzMzMz0z8DPAM9Az4EDzjQwAM/A0AEEkTQwAUBAQM1BABUIIACmpmZmZmZyT8DQQMEAHJCARhSAAAAAACuAAEAAAAAAQAAAAABAAAAAAEAAAAA/AAAUgABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEhAAAAAAUAHAArADIAOAA8dQYBAgAAAA37AQAAbwMAAOIEBAD7BQEATQUFmQUAAAAwBQQkAQAAALwBAe4GAAAAJQEEAQAAAACCAAEABwNDAwEDAgLNzMzMzMzkPwgCAf////8CAwAAAAMDAwQAd0QBGAAAAAAAAAAAAAAAAF0cAAAAAAEACnUGAQIAAAAN+wEAAG8DAADiBAQA+wUBAE0FBZkFAAAAMAUEJAEAAAC8AQHuBgAAACUBBAEAAAAAggABAAcDRQMBAwICmpmZmZmZ2T8IAgH/////AgMAAAADAwMEAHtGARgAAAAAAAAAAAAAAABhHAAAAAABAArwAQgABAAAACH7AAAATQAAXAAAAAArAAEAggABAPsAAQD7AgAATQICXAAAAACkAwMAAAgQgG8EBACkBQgABxhQwKQGCwAKJFDAJQMEAgAAAADiBA0A+wYCAPsHAwAmBQYHMAUEOwwAAAC8AACWDgAAACUABQIBAAAAvAAA7g8AAAAlAAIBAgAAAIIAAQAQAyADOwMHBAAIEIACuB6F61G4rj8DPAM9Az4EBxhQwAM/A0AECiRQwAMjBQEMA0EDBACfAQABGAAAAAABAwAAAAAAAAAAAAAAAAABAAAAAP8AAAACAAAAAaAAAAAAAwAQABoAHuYBBwADAAAAH/sAAABNAABcAAAAACsAAQCCAAEA+wABAPsCAABNAgJcAAAAAKQDAwAACBCAbwQEAKQFCAAHGFDApAYLAAokUMAlAwQCAAAAAOIEDQD7BQIAMAUEOwwAAAC8AACWDgAAACUABQIBAAAAvAAA7g8AAAAlAAIBAgAAAIIAAQAQAyADOwMHBAAIEIACexSuR+F6tD8DPAM9Az4EBxhQwAM/A0AECiRQwAMjBQEMA0EDBACpAQABGAAAAAABAwAAAAAAAAAAAAAAAAABAAD/AAAAAgAAAAGqAAAAAAMAEAAYABypCRIBAwAAAMIB+wEAAG8DAADiBAQA+wUBAE0FBZkFAAAAMAUEJAEAAAC8AQHuBgAAACUBBAEAAAAATQEAXAcAAAAOAQgATQEAXAcAAABvAwgAvAEB/gkAAAAlAQMCAQAAACsBAQCCAAEATQEAAwoAAAArAQQATQEAXAcAAABNAQE7CwAAAE0CALwMAAAAKwIEAE0CAFwHAAAATQICnw0AAACkAxAAADzggIwECACMBQAAJQMDAgIAAABNBABcBwAAAKQFEwAASBCBjAb/AIwHPACMCDwAJQUEAgMAAAAwBQSfDQAAAPsEAgBNBgBcBwAAAKQHFgAAVECBbwgXAKQJGwAaZIDBpAoeAB1wgMElBwQCBAAAAOIIHwAwAgifDQAAALwEBJYgAAAAJQQFAgUAAAC8BATuBgAAACUEAgEGAAAApAQiAAAAEEJNBQA+IwAAACUEAgQHAAAAUQQ/AA4IPgBNCQiAJAAAAA4JOwBvDSUAvAsI/gkAAAAlCwMCCAAAACsLBgBvDSYAvAsI/gkAAAAlCwMCCQAAAA4LBABvCScATQoIACcAAABlAAwAbw0IALwLCP4JAAAAJQsDAgoAAAAOCwQAbwkNAE0KCJ8NAAAAZQACAMYJAADGCgAADgkeAKQLEwAASBCBjAz/AIwNPACMDjwAJQsEAgsAAABqCwgJ+wsCAFINCACkDhYAAFRAgW8PFwCkEBsAGmSAwaQRHgAdcIDBJQ4EAgwAAAD/DwEAAAAAAGoKDwm8CwuWIAAAACULBQINAAAAvAsL7gYAAAAlCwIBDgAAAG4EwP8CAACA+wQCAE0GAFwHAAAApAcWAABUQIFvCCgApAkbABpkgMGkCh4AHXCAwSUHBAIPAAAA4ggpAEMJAQMwCQg7CwAAALwEBJYgAAAAJQQFAhAAAAC8BATuBgAAACUEAgERAAAApAQsAACsoIJvBSgA2QYAABIAAAASAgIAEgABABIAAwAlBAMBEgAAAKQELAAArKCCbwUtANkGAQASAAAAEgICABIAAQAlBAMBEwAAAIIAAQAuA0cDAQMCAmZmZmZmZuY/CAIB/////wIDAAAAAwMDBAMgAxQDEQMkAyMDJQMVAwYDSAQAPOCAA0kDSgQASBCBAzsDBwQAVECBAgrXo3A9Csc/AzwDPQM+BBpkgMEDPwNABB1wgMEFAQ0DQQMrBAAAEEIDGgMmAxADEgMTApqZmZmZmak/BQELA0sDTAQArKCCAilcj8L1KLw/AgkKf00BGAAAAAAAAAAAAAAAAGYAAAAAAAAAAAAAAQMAAAAAAAABAAAAAAAAAQAAAAAAAgAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAQD/AAAAAgAAAAIAAAAAAAABAAAAogAAAAAAAAAAAAAAAQAAAAMAAAAAAAEAAAADAFgBAAAAAAAAAAEAAAAAAAAAAAAAAAAB/wAAAAIAAAD5AAwAAAAAAAAAAAAAAAABAAD/AAAAAgAAAAIAAAAAAAAAAAAKAAAAAAAAAAAJHAAAAAAUAAoAFAAqADMAQQBIAEwAUgBcAGIAbAB7AIcBAI4BAJIBAKABAKgBAKwBALYBAL8BQwUCAAAIAAhNAgB2AAAAAFIEAQC8AgJfAQAAACUCAwEAAAAAggABAAIDGQNOALQBJwEYAAAAAAAAAAG1AAAAAAEABQZ/AwEBAAAAEk0BAHYAAAAADgEGAE0BAHYAAAAAvAEBUAEAAAAlAQIBAAAAAKQBBAAADCCAUgIAACUBAgEBAAAAxgEAAN4BAADGAAAAggABAAUDGQM3Aw4DTwQADCCAALgBNwEYAAAAAQAAAAAAAwAAAAACAAEBuQAAAAACAAcADKYHDAAAAQoAoQGjAAAA/wAFAAAAAAAwAABuAAAAAKQBAgAAABBAbwMDALwBARYEAAAAnwEDAqQCAgAAABBAbwQFALwCAhYEAAAAnwIDAqQDAgAAABBAbwUGALwDAxYEAAAAnwMDAqQDAgAAABBAbwUHALwDAxYEAAAAnwMDAqQDAgAAABBAbwUIALwDAxYEAAAAnwMDAqQDAgAAABBAbwUJALwDAxYEAAAAnwMDAqQDCwAAAKBATQQBNwwAAACfAwICpAMLAAAAoEBNBAHoDQAAAE0EBLUOAAAATQQEHw8AAACfAwICpAMLAAAAoEBNBAHoDQAAAE0EBLUOAAAATQQEdhAAAACfAwICpAQLAAAAoEBNBQHoDQAAAE0FBbUOAAAATQUFnhEAAACfBAICpAQLAAAAoEBNBQHoDQAAAE0FBW8SAAAATQUFKBMAAACfBAICpAULAAAAoEBNBgHoDQAAAE0GBt0UAAAATQYGwBUAAACfBQICpAULAAAAoEBNBgHoDQAAAE0GBt0UAAAATQYGABYAAACfBQICpAULAAAAoEBNBgHoDQAAAE0GBrUOAAAATQYGdBcAAACfBQICpAECAAAAEEBNAQFQGAAAAE0BATEZAAAAxgYAAMAHGgASAAQAEgABAMAIGwDACRwAwAodAMALHgASAAUAEgAAABIAAwASAAEAMAsA7x8AAADACyAAMAsAJiEAAADACyIAEgACADALAPkjAAAAwAskABIABAASAAEAMAsAvSUAAADACyYAEgAEABIAAQAwCwCQJwAAAMALKAASAAQAEgABABIAAgAwCwDlKQAAAMALKgAwCwAUKwAAANkLCwASAQb/MAsAUCwAAADBBgAAggACAC0DUANRBAAAEEADUgNTA1QDVQNWA1cDWANZBAAAoEADWgNbA1wDXQMZA14DXwNgA2EDYgNjA2QDZQNmBgAGAQYCBgMGBAMHBgUDOQYGA0IGBwNEBggDRgYLA00GDAMnAzcMAAECAwQFBgcICwwNAQABGAAAAAEAAgAAAAAAAQAAAAAAAQAAAAAAAQAAAAAAAQAAAAAAAQAAAAAAAgAAAAABAAAAAAAAAAABAAAAAAAAAAABAAAAAAAAAAABAAAAAAAAAAABAAAAAAAAAAABAAAAAAAAAAABAAAAAAAAAAACAAAAAAABBQAABgkIDAAAAAAAABUAACAAAAAFAAAAAAQAAAAABAAAAAAANQAABAAAAAsAAQAAAAAAfw6jTHcpAxKoMj3fGMcpqytT01RgXZGIHSg=

-- decompilation:
local t1 = {}

t1.__index = t1

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

game:GetService("Debris")
game:GetService("RunService")
game:GetService("HttpService")
game:GetService("UserInputService")
require(ReplicatedStorage.GlobalTypes)
require(ReplicatedStorage.Modules.Misc.Signal)

local Maid = require(ReplicatedStorage.Modules.Misc.Maid)

require(ReplicatedStorage.Modules.Util)

local Sounds = require(ReplicatedStorage.Modules.Sounds)

require(ReplicatedStorage.Modules.Actors)
require(ReplicatedStorage.Modules.Hitboxes)

local Device = require(ReplicatedStorage.Modules.Device)
local LocalPlayer = game.Players.LocalPlayer
local u8 = nil

local function playQTESound(p1, p2) -- line: 26
	-- upvalues: Sounds (copy), LocalPlayer (copy)
	if p1 then
		Sounds:Play(p1, {
			Parent = LocalPlayer.PlayerGui,
			Volume = p2 or 0.65
		})
	end
end
local function multiplyUDim2(p3, p4) -- line: 32
	return UDim2.new(p3.X.Scale * p4, p3.X.Offset * p4, p3.Y.Scale * p4, p3.Y.Offset * p4)
end
local function getRanges(p5) -- line: 41
	if typeof(p5) == "table" then
		return p5
	end

	return { p5 }
end
local function getGuiColor(p6) -- line: 49
	if p6:IsA("ImageLabel") or p6:IsA("ImageButton") then
		return "ImageColor3", p6.ImageColor3
	end

	if p6:IsA("GuiObject") then
		return "BackgroundColor3", p6.BackgroundColor3
	end

	return nil, nil
end

function t1.new(p7) -- line: 61
	-- upvalues: Device (copy), t1 (copy), Maid (copy), LocalPlayer (copy)
	Device:GetPlayerDevice()

	local self = setmetatable({}, t1)

	self.Maid = Maid.new()
	self.ZoneFrames = {}

	local clone = script.QTE:Clone()

	clone.Parent = LocalPlayer.PlayerGui.TemporaryUI
	self.ParentObject = p7
	self.UI = clone
	self.ZoneTemplate = clone.Zone:Clone()
	self.OriginalPosition = if not clone:IsA("GuiObject") then nil else clone.Position
	self.OriginalBackgroundColor = if not clone:IsA("GuiObject") then nil else clone.BackgroundColor3
	clone.Zone.Visible = false
	self:AddToMaid(clone)

	return self
end
function t1.Update(p8) -- line: 82
	local ParentObjectValue = p8.ParentObject.Value
	local QTEBounds = p8.ParentObject.QTEBounds
	local v25 = if typeof(QTEBounds) ~= "table" then { QTEBounds } else QTEBounds
	local v26 = p8.ParentObject.CompletedZones or {}

	for i, v in ipairs(v25) do
		local v29 = p8.ZoneFrames[i]

		if not v29 then
			v29 = p8.ZoneTemplate:Clone()
			v29.Name = `Zone{ i }`
			v29.AnchorPoint = Vector2.new(0.5, 0.5)
			v29.Visible = true
			v29.Parent = p8.UI
			p8.ZoneFrames[i] = v29
		end

		local v30 = math.max(v.Max - v.Min - 0.01, 0.01)

		v29.Visible = not v26[i]
		v29.Size = UDim2.fromScale(v30, 1)
		v29.Position = UDim2.fromScale(v.Min + (v.Max - v.Min) / 2, 0.5)
	end

	for i = #v25 + 1, #p8.ZoneFrames do
		if p8.ZoneFrames[i] then
			p8.ZoneFrames[i]:Destroy()
			p8.ZoneFrames[i] = nil
		end
	end

	p8.UI.Line.Position = UDim2.fromScale(ParentObjectValue, 0.5)
end
function t1.OnButtonPressed(p9) -- line: 114
	-- upvalues: TweenService (copy)
	local TextLabel = p9.TextLabel
	local TextLabelSize = p9.TextLabel.Size

	TextLabel.Size = UDim2.new(TextLabelSize.X.Scale * 1.25, TextLabelSize.X.Offset * 1.25, TextLabelSize.Y.Scale * 1.25, TextLabelSize.Y.Offset * 1.25)
	TweenService:Create(p9.TextLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = UDim2.fromScale(0.2, 0.2)
	}):Play()
end
function t1.PlayHitSound(_) -- line: 119
	-- upvalues: Sounds (copy), LocalPlayer (copy)
	Sounds:Play("rbxassetid://71465325684164", {
		Volume = 0.65,
		Parent = LocalPlayer.PlayerGui
	})
end
function t1.PlayCornerSound(_) -- line: 123
	-- upvalues: Sounds (copy), LocalPlayer (copy)
	Sounds:Play("rbxassetid://80333007156131", {
		Volume = 0.4,
		Parent = LocalPlayer.PlayerGui
	})
end
function t1.WarnFailedAttempt(p12) -- line: 127
	-- upvalues: Sounds (copy), LocalPlayer (copy), TweenService (copy)
	Sounds:Play("rbxassetid://96573322554989", {
		Volume = 0.7,
		Parent = LocalPlayer.PlayerGui
	})

	if not p12.UI or not p12.UI:IsA("GuiObject") then
		return
	end

	local v38 = p12.OriginalPosition or p12.UI.Position
	local v39 = p12.OriginalBackgroundColor or p12.UI.BackgroundColor3
	local uDim2 = UDim2.fromOffset(8, 0)

	p12.UI.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
	TweenService:Create(p12.UI, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		BackgroundColor3 = v39
	}):Play()

	for _, v in ipairs(p12.ZoneFrames) do
		if v and v.Visible then
			local s1, vImageColor3

			if v:IsA("ImageLabel") or v:IsA("ImageButton") then
				s1 = "ImageColor3"
				vImageColor3 = v.ImageColor3
			elseif v:IsA("GuiObject") then
				s1 = "BackgroundColor3"
				vImageColor3 = v.BackgroundColor3
			else
				s1 = nil
				vImageColor3 = nil
			end

			if s1 then
				v[s1] = Color3.fromRGB(255, 60, 60)
				TweenService:Create(v, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					[s1] = vImageColor3
				}):Play()
			end
		end
	end

	TweenService:Create(p12.UI, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Position = v38 + uDim2
	}):Play()
	task.delay(0.05, function() -- line: 159
		-- upvalues: p12 (copy), TweenService (copy), v38 (copy), uDim2 (copy)
		if not p12.UI then
			return
		end

		TweenService:Create(p12.UI, TweenInfo.new(0.06, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Position = v38 - uDim2
		}):Play()
	end)
	task.delay(0.11, function() -- line: 169
		-- upvalues: p12 (copy), TweenService (copy), v38 (copy)
		if not p12.UI then
			return
		end

		TweenService:Create(p12.UI, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Position = v38
		}):Play()
	end)
end
function t1.AddToMaid(p13, p14) -- line: 180
	p13.Maid:Add(p14)
end
function t1.Destroy(p15) -- line: 184
	-- upvalues: u8 (ref)
	if p15.Maid then
		p15.Maid:Destroy()
	end

	table.clear(p15)
	u8 = nil
end

return t1
]====]},
{path=[====[
ReplicatedStorage/Modules/Hitboxes]====],before="26387:62b198d2:75340e91",after="26712:88af87d8:f19ddb2f",source=[====[
-- So, I've been trying to improve the engine recently and I just though: WHY NOT JUST RECODE EVERYTHING?????????????????
-- also improving my comments!
-- skiddy katamari will say this is trash because her engine needs to be better than anything

-- // services:
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local AnalyticsService = game:GetService("AnalyticsService")
local isStudio = RunService:IsStudio()
local isServer = RunService:IsServer()

-- // modules:
local Ragdolls = require(ReplicatedStorage.Modules.Ragdolls)
local Util = require(ReplicatedStorage.Modules.Util)
local AchievementUtil = require(ReplicatedStorage.Modules.AchievementUtil)
local Actors = require(ReplicatedStorage.Modules.Actors)
local Network = require(ReplicatedStorage.Modules.Network)
local Sounds = require(ReplicatedStorage.Modules.Sounds)
local Stats = require(ReplicatedStorage.Modules.Stats)
local Statuses = require(ReplicatedStorage.Modules.Statuses)

-- // new modules (these were originally not on forsaken neither on aeternus)
local Janitor = require(ReplicatedStorage.Modules.Misc.Janitor) -- expect to see this alot (maid will still be here to keep compatibility)
local CoreLoader = require(ReplicatedStorage.CoreLoader)
local Signal = require(ReplicatedStorage.Modules.Misc.Signal) -- why doesn't forsaken use this module

local Hitboxes = {}


-- new function to prevent wall clipping (aka. hitting someone if they are behind an wall)
local function PreventWallClip(pOrigin, pTargetPos, pExcludeChar)
	local diff = pTargetPos - pOrigin
	local dist = diff.Magnitude
	if dist > 10 then
		pTargetPos = pOrigin + diff.Unit * 10
		dist = 10
	end
	if dist < 0.1 then
		return pTargetPos
	end

	local rayParams = RaycastParams.new()
	rayParams.FilterType = Enum.RaycastFilterType.Exclude
	rayParams.FilterDescendantsInstances = { workspace.Players, pExcludeChar, workspace:FindFirstChild("Hitboxes") }

	local raycastResult = workspace:Raycast(pOrigin, diff, rayParams)
	if not raycastResult then
		return pTargetPos
	end

	local safeDist = math.max(raycastResult.Distance - 0.5, 0)
	return pOrigin + diff.Unit * safeDist
end


local function GetDictionaryLength(dict)
	local count = 0
	for _, _ in pairs(dict) do
		count += 1
	end
	return count
end


function Hitboxes.LineOfSight(_, origin, targetChar)
	local player = Players:GetPlayerFromCharacter(targetChar)

	if player then
		local _ = Actors.CurrentActors[player]
	end

	targetChar:FindFirstChild("Humanoid")

	local hasReplicating = targetChar:FindFirstChild("QueryHitbox") and (player and targetChar:HasTag("Replicating"))
	local raycastParams = RaycastParams.new()

	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.FilterDescendantsInstances = if not typeof(origin == "Vector3") then {
		workspace.Players,
		targetChar,
		origin
	} else {
			workspace.Players,
			targetChar
		}
	raycastParams.CollisionGroup = tostring(typeof(origin) ~= "Vector3" and (not not origin.PrimaryPart and origin.PrimaryPart.CollisionGroup) or "Killers")

	local function partCanBlock(hitPart)
		local isHitbox = hitPart:GetAttribute("Hitbox") or (hitPart.CanCollide or hitPart.Transparency < 1)
		local hitHumanoid = hitPart.Parent:FindFirstChild("Humanoid")

		if isHitbox and not hitHumanoid then
			return true
		end

		raycastParams:AddToFilter(hitPart)

		if hitHumanoid then
			raycastParams:AddToFilter(hitHumanoid.Parent)
		end

		return false
	end

	if typeof(origin) == "Vector3" then
	else
		local originPlayer = Players:GetPlayerFromCharacter(origin)
		local originActor = originPlayer and Actors.CurrentActors[originPlayer]

		origin = originActor and originActor:GetPivot(false).Position or origin.PrimaryPart.Position
	end

	for _, child in ipairs(targetChar:GetChildren()) do
		if not child:IsA("BasePart") or not child.CanQuery or child:GetAttribute("Hitbox") then
			continue
		end

		local objectSpace = targetChar.PrimaryPart.CFrame:ToObjectSpace(child.CFrame)
		local targetPos = hasReplicating and targetChar.QueryHitbox.CFrame:ToWorldSpace(objectSpace).Position or child.Position
		local attempts = 0
		local raycastResult

		repeat
			raycastResult = workspace:Raycast(origin, targetPos - origin, raycastParams)
			attempts += 1
		until not raycastResult or partCanBlock(raycastResult.Instance) or attempts > 15

		if not raycastResult and attempts <= 15 then
			return true
		end
	end

	return false
end


local function guestHitClient(target, ...)
	if typeof(target) == "Instance" and target:IsA("Player") then
		Network:FireClientConnection(target, ...)
	end
end
local function guestIsPlayer(target)
	return typeof(target) == "Instance" and target:IsA("Player")
end
local function guestCharacter(subject)
	if typeof(subject) == "Instance" then
		if subject:IsA("Player") then return subject.Character end
		if subject:IsA("Model") then return subject end
	elseif typeof(subject) == "table" then
		return subject.Rig or subject.Character
	end
end
local function guestActor(subject, rig)
	local player = rig and Players:GetPlayerFromCharacter(rig)
	local actor = subject and Actors.CurrentActors[subject] or player and Actors.CurrentActors[player] or rig and Actors.CurrentActors[rig]
	if actor and actor.Rig == rig then return actor end
	for _, candidate in pairs(Actors.CurrentActors) do
		if candidate.Rig == rig then return candidate end
	end
end

function Hitboxes.CreateHitbox(_, creator, hitboxParams)
	local creatorChar = guestCharacter(creator)

	if not creatorChar or not creatorChar.PrimaryPart then
		return
	end

	local params = hitboxParams or {}
	local config = {
		Size = params.Size or Vector3.new(4, 7, 4),
		CFrameOffset = params.CFrameOffset or CFrame.new(0, 0, 0),
		CFrame = params.CFrame or nil,
		CastPoint = if params.CastPoint ~= nil then params.CastPoint else nil,
		Damage = params.Damage or 15,
		AbilityType = params.AbilityType or nil,
		Time = params.Time or 0.125,
		Knockback = params.Knockback or 0,
		HitMultiple = params.HitMultiple or false,
		PredictVelocity = params.PredictVelocity == nil or params.PredictVelocity,
		ExecuteOnKill = params.ExecuteOnKill or false,
		FriendlyFire = params.FriendlyFire or false,
		Team = params.Team,
		Target = params.Target,
		OnlyHitPlayers = params.OnlyHitPlayers or false,
		RagdollOnHit = params.RagdollOnHit or false,
		Hide = params.Hide or false,
		DeathProfile = params.DeathProfile or {},
		Shape = params.Shape or Enum.PartType.Block,
		ExcludeChars = params.ExcludeChars or {},
		Connections = params.Connections or {}
	}
	local overlapParams = OverlapParams.new()

	overlapParams.FilterType = Enum.RaycastFilterType.Exclude
	overlapParams.FilterDescendantsInstances = { creatorChar }

	local hitboxState = {
		TimePast = 0,
		HumanoidsDamaged = {},
		InvincibleProcs = {},
		Creator = creator,
		AbilityType = config.AbilityType,
		Damage = config.Damage,
		IsProjectile = if params.IsProjectile ~= nil then params.IsProjectile else config.CFrame ~= nil,

		OnHit = Signal.new(),
		OnEnded = Signal.new()
	}

	local hitboxJanitor = Janitor.new()
	hitboxJanitor:Add(hitboxState.OnHit, "Destroy")
	hitboxJanitor:Add(hitboxState.OnEnded, "Destroy")

	local function runCallback(callbackName, ...)
		if config.Connections[callbackName] then
			config.Connections[callbackName](...)
		end
	end

	function hitboxState.Cancel(_)
		hitboxState.Cancelled = true
		hitboxJanitor:Cleanup()
	end

	task.spawn(function()
		local creatorActor = guestActor(creator, creatorChar)

		while creatorChar.Parent and creatorChar.PrimaryPart and hitboxState.TimePast < config.Time and not hitboxState.Cancelled do
			local humanoidsDamaged = hitboxState.HumanoidsDamaged
			local hitCount = 0

			for _, _ in pairs(humanoidsDamaged) do
				hitCount += 1
			end

			if hitCount > 0 and not config.HitMultiple or creatorChar:GetAttribute("Stunned") or not Util:IsAlive(creatorChar) and not hitboxState.IsProjectile then
				break
			end

			local pivotCF = creatorActor and creatorActor:GetPivot(not not config.PredictVelocity) or creatorChar.PrimaryPart.CFrame
			local hitboxPart = Instance.new("Part")

			hitboxPart.Name = tostring(creator) .. "Hitbox"
			hitboxPart.Transparency = 1
			hitboxPart.CanCollide = false
			hitboxPart.CanTouch = false
			hitboxPart.CanQuery = false
			hitboxPart.CastShadow = false
			hitboxPart.Anchored = true
			hitboxPart.Shape = config.Shape
			hitboxPart.Size = typeof(config.Size) == "function" and config.Size() or config.Size
			hitboxPart.CFrame = typeof(config.CFrame) == "function" and config.CFrame() or (config.CFrame or pivotCF * if typeof(config.CFrameOffset) ~= "function" then config.CFrameOffset else config.CFrameOffset())
			hitboxPart.Parent = workspace:FindFirstChild("Hitboxes")
			hitboxState.Instance = hitboxPart

			task.delay(0.36, function()
				if hitboxPart and hitboxPart.Parent then hitboxPart:Destroy() end
			end)

			if config.Hide then
				hitboxPart:SetAttribute("Hidden", true)
			end

			if config.PredictVelocity then
				if typeof(creator) ~= "Instance" or not creator:IsA("Player") then
				end
			end

			local partsFound = workspace:GetPartsInPart(hitboxPart, overlapParams)

			table.sort(partsFound, function(partA, partB)
				local parentA = partA.Parent
				local parentB = partB.Parent
				local priorityA = parentA:GetAttribute("HitboxPriority") or 1
				local priorityB = parentB:GetAttribute("HitboxPriority") or 1

				if priorityA == priorityB then
					priorityA = (creatorChar.PrimaryPart.Position - partB.Position).Magnitude
					priorityB = (creatorChar.PrimaryPart.Position - partA.Position).Magnitude
				end

				return priorityB < priorityA
			end)

			local targetsHit = {}

			for _, hitPart in ipairs(partsFound) do
				local victimHumanoid = hitPart.Parent:FindFirstChildOfClass("Humanoid")

				if victimHumanoid and not (victimHumanoid.Health <= 0) and (not victimHumanoid.Parent:HasTag("Replicating") or not Players:GetPlayerFromCharacter(victimHumanoid.Parent) or hitPart.Name == "QueryHitbox") and ((not victimHumanoid.Parent:HasTag("SurvivorConstruct") or not config.OnlyHitPlayers) and not hitboxState.HumanoidsDamaged[victimHumanoid]) and (not config.Team or tostring(hitPart.Parent.Parent) == config.Team or tostring(hitPart.Parent:GetAttribute("Team")) == config.Team) and ((workspace:GetAttribute("FriendlyFire") or config.FriendlyFire or config.Team and config.Team == tostring(creatorChar.Parent) or tostring(hitPart.Parent:GetAttribute("Team")) ~= tostring(creatorChar.Parent) and tostring(hitPart.Parent.Parent) ~= tostring(creatorChar.Parent)) and (not config.Target or config.Target == victimHumanoid.Parent)) then
					local castOrigin = if not config.CastPoint then if config.CFrame then hitboxPart.CFrame.Position else creatorChar else if typeof(config.CastPoint) ~= "function" then config.CastPoint else config.CastPoint()

							if (config.CastPoint == false or Hitboxes:LineOfSight(castOrigin, victimHumanoid.Parent)) and not table.find(config.ExcludeChars, victimHumanoid.Parent) and not table.find(config.ExcludeChars, victimHumanoid) then
								if victimHumanoid.Parent:GetAttribute("Invincible") then
									if not hitboxState.InvincibleProcs[victimHumanoid] then
										local victimPrimaryPart = victimHumanoid.Parent.PrimaryPart
										local invincibleFX = victimPrimaryPart and victimPrimaryPart:FindFirstChild("InvincibleFX")

										if invincibleFX and invincibleFX:FindFirstChild("Deflect") then
											Sounds:Play("invincibleDeflect", {
												Parent = victimPrimaryPart
											})
											invincibleFX.Deflect:Emit(1)
										end
									end

									hitboxState.InvincibleProcs[victimHumanoid] = true
								else
									local hitPriority = victimHumanoid.Parent:GetAttribute("HitboxPriority") or 1

									hitboxState.HumanoidsDamaged[victimHumanoid] = true
									table.insert(targetsHit, victimHumanoid)

									if not config.HitMultiple and hitPriority >= 0 then
										break
									end
								end
							end
						end
					end

					hitboxPart.Color = #targetsHit > 0 and Color3.new(0.5, 1, 0.5) or Color3.new(1, 0.25, 0.25)

					for i, victimHumanoid in ipairs(targetsHit) do
						local victimChar = victimHumanoid.Parent
						local victimPrimaryPart = victimChar and (victimChar:IsA("Model") and victimChar.PrimaryPart)
						local rawDamage = typeof(config.Damage) == "number" and config.Damage or config.Damage(victimChar)
						local resistanceSum = 0
						local resistanceFolder = victimChar and victimChar:FindFirstChild("ResistanceMultipliers")

						for _, resistanceValue in pairs(resistanceFolder and resistanceFolder:GetChildren() or {}) do
							resistanceSum += resistanceValue.Value
						end

						local finalDamage = rawDamage * (1 - math.min(resistanceSum - (creatorChar:GetAttribute("StrengthBuff") or 0), 100) / 100)

						if not victimPrimaryPart then
							continue
						end

						victimChar:SetAttribute("TimesHit", (victimChar:GetAttribute("TimesHit") or 0) + 1)
						runCallback("HitAbsolute", victimChar, i == 1)

						local victimPlayer = Players:GetPlayerFromCharacter(victimChar)
						local victimActor = guestActor(victimPlayer, victimChar)

						if victimActor and victimActor.Behavior and victimActor.Behavior.OnHit then
							local hitResponse = victimActor.Behavior:OnHit(
								victimActor,
								hitboxState,
								finalDamage
							)

							if hitResponse == "Ignored" then
								continue
							end

							if typeof(hitResponse) == "table"
								and typeof(hitResponse.DamageOverride) == "number" then

								finalDamage = math.max(0, hitResponse.DamageOverride)
							end

							if hitboxState.TimePast > config.Time then
								break
							end
						end

						local knockbackVal = not (typeof(config.Knockback) ~= "number" and typeof(config.Knockback) ~= "Vector3") and config.Knockback or config.Knockback(victimChar)
						local isKbVector = typeof(knockbackVal) == "Vector3"
						local kbDir = isKbVector and knockbackVal or hitboxPart.CFrame.LookVector

						if isKbVector or knockbackVal > 0 then
							local kbForce = (typeof(knockbackVal) == "Vector3" and knockbackVal or kbDir * knockbackVal) * 10

							if victimPlayer then
								guestHitClient(victimPlayer, "KB", "REMOTE_EVENT", Util:SerializeVector(kbForce))
							else
								victimPrimaryPart.AssemblyLinearVelocity = kbForce + victimPrimaryPart.AssemblyLinearVelocity / 2
							end
						end

						local deathProfile = Util:CopyTable(config.DeathProfile)

						if not deathProfile.Velocity then
							if isKbVector then
								deathProfile = {
									Velocity = kbDir * 10
								}
							elseif knockbackVal > 0 then
								deathProfile = {
									Velocity = kbDir * knockbackVal * 10
								}
							end
						end

						Ragdolls.AddProfile(victimChar, deathProfile)

						local damageDealt = finalDamage
						local overhealVal = victimHumanoid:GetAttribute("Overheal") or 0
						local shatterpointHP = victimChar:GetAttribute("ShatterpointHP") or 0
						local _ = victimHumanoid.Health + overhealVal + shatterpointHP
						local isVictimAlive = victimHumanoid.Health > 0
						local remainingOverheal = math.max(0, overhealVal - finalDamage)

						if remainingOverheal < (victimHumanoid:GetAttribute("OverhealDecayMin") or 0) then
							victimHumanoid:SetAttribute("OverhealDecayMin", remainingOverheal > 0 and remainingOverheal or nil)
						end

						local damageToApply = finalDamage - overhealVal

						if damageToApply > 0 and shatterpointHP > 0 then
							local shatterDamage = damageToApply * (victimChar:GetAttribute("ShatterpointResistance") or 1)

							if shatterDamage > 0 then
								local victimBehaviorActor = guestActor(victimPlayer, victimChar)

								if victimBehaviorActor and victimBehaviorActor.Behavior and victimBehaviorActor.Behavior.sv_DamageCrystalHP then
									victimBehaviorActor.Behavior:sv_DamageCrystalHP(victimBehaviorActor, shatterDamage)
								else
									victimChar:SetAttribute("ShatterpointHP", (math.max(0, shatterpointHP - shatterDamage)))
								end

								local shatterRemainder = shatterDamage - shatterpointHP

								damageDealt = shatterDamage + overhealVal
								damageToApply = not (shatterRemainder > 0) and 0 or shatterRemainder
							end
						end

						local finalDeductibleDamage = math.max(0, damageToApply)
						local victimPosInt16 = Vector3int16.new(victimPrimaryPart.Position.X, victimPrimaryPart.Position.Y, victimPrimaryPart.Position.Z)
						local isKilled = victimHumanoid.Health - finalDeductibleDamage <= 0
						local creatorBehaviorActor = guestActor(creator, creatorChar)

						if creatorBehaviorActor then
							local _, _ = pcall(function()
								return creatorBehaviorActor.Behavior.OnInflictedDamage(creatorBehaviorActor, victimChar, (math.min(victimHumanoid.Health, damageDealt)))
							end)
						end

						if isVictimAlive and isKilled then
							local protectionPlayerName = victimChar:GetAttribute("DusekkarProtected")
							local protectionPlayer = protectionPlayerName and Players:FindFirstChild(protectionPlayerName)

							if protectionPlayer then
								local protectorChar = protectionPlayer.Character

								print(`dusekkar moment ({ victimChar } protected by { protectionPlayer })`)
								Actors:IncrementActorStats(protectionPlayer, {
									Action = "Prevented the death of a Survivor",
									Money = 10,
									EXP = 30
								})
								victimChar:SetAttribute("DusekkarProtected", nil)
								protectorChar:SetAttribute("Protecting", nil)
								AchievementUtil:IncrementAchievementProgress(protectionPlayer, "DusekkarUbercharge")

								return
							end

							if tostring(victimChar.Parent) == "Survivors" then
								if guestIsPlayer(creator) then
									Stats:UpdatePlayerStat(creator, "Kills", "Add", 1)
								end

								if creatorBehaviorActor then
									creatorBehaviorActor.TotalKills =
										(creatorBehaviorActor.TotalKills or 0) + 1

									local ok, result = pcall(function()
										AnalyticsService:LogCustomEvent(creator, "TotalKills", 1, {
											[Enum.AnalyticsCustomFieldKeys.CustomField01.Name] = `Character - { creatorBehaviorActor.ActorName }`
										})
									end)

									if not ok then
										warn(`[AnalyticsService]: Failed to log custom event: TotalKills due to: { result }`)
									end
								end
							end

							local creatorVoicelines = creatorBehaviorActor and creatorBehaviorActor.Config.Voicelines

							if creatorVoicelines and not victimChar:GetAttribute("ExecutionsDisabled") then
								local killType = "Kill"

								if isServer then
									local RoundManager = require(game.ServerScriptService.Server.Systems.Core.RoundManager)

									if RoundManager and RoundManager.CurrentSession and RoundManager.CurrentSession.LastSurvivorAlive then
										killType = "LastKill"
									end
								end

								for _, actionName in ipairs({
									killType,
									"Kill"
									}) do
									if creatorVoicelines[`{ actionName }{ tostring(victimChar:GetAttribute("SkinName")) }`] then
										Sounds:PlayVoiceline(creatorBehaviorActor, `Kill{ tostring(victimChar:GetAttribute("SkinName")) }`)

										break
									end

									if creatorVoicelines[`{ actionName }{ victimChar.Name }`] then
										Sounds:PlayVoiceline(creatorBehaviorActor, `Kill{ victimChar.Name }`)

										break
									end

									if creatorVoicelines[`{ actionName }`] then
										Sounds:PlayVoiceline(creatorBehaviorActor, "Kill")

										break
									end
								end
							end

							local RoundManager = game.ServerScriptService.Server.Systems.Core.RoundManager
							local lib = require(RoundManager)

							if tostring(victimChar.Parent) == "Survivors" and (lib.CurrentSession and lib.CurrentSession.TimePast or isStudio or workspace:GetAttribute("Testing")) then
								lib:AddTime(nil, victimActor and victimActor.TimeAddMultiplier or 1, true)

								if creatorBehaviorActor and creatorBehaviorActor.Behavior and creatorBehaviorActor.Behavior.OnKill then
									local ok, result = pcall(function()
										return creatorBehaviorActor.Behavior.OnKill(creatorBehaviorActor, victimChar)
									end)

									if not ok then
										warn(`[{ script }/CreateHitbox]: Failed to call .OnKill() due to: { result }`)
									end
								end

								require(game.ServerScriptService.Server.Systems.Core.EventHandlerServer):CallMethod("OnPlayerKilled", creator, victimPlayer)
								if guestIsPlayer(creator) then
									Actors:IncrementActorStats(creator, {
										Action = "Killed a Survivor", Money = 15, EXP = 45
									})
								end
							end

							if config.ExecuteOnKill and guestIsPlayer(creator) and creatorBehaviorActor and not victimChar:GetAttribute("ExecutionsDisabled") and not (creatorBehaviorActor.AbilityDisablers or {}).Execution then
								local skinName = victimChar:GetAttribute("SkinName")
								local executionAnimName = nil

								if not creatorBehaviorActor then
									warn("Hitboxes: Non-Actor attempted to Execute!")
								else
									executionAnimName = if not skinName or (skinName == "" or not creatorBehaviorActor.Config.Animations[`Execution{ skinName }`]) then not creatorBehaviorActor.Config.Animations[`Execution{ victimChar.Name }`] and "Execution" or `Execution{ victimChar.Name }` else `Execution{ skinName }`
								end

								local executionAnimConfig = creatorBehaviorActor and creatorBehaviorActor.Config.Animations[executionAnimName]

								if executionAnimConfig and executionAnimConfig.KillerRig and executionAnimConfig.PlayerRig then
									task.spawn(function()
										Statuses:RemoveStatuses(victimChar, true)
										Util:GiveStackableAttribute(victimChar, "BeingExecuted", `{ creatorBehaviorActor.Player.Name }Execution`, 10)

										local killerTrack = creatorBehaviorActor.Cache[`{ executionAnimName }Anim`]

										if not killerTrack then
											killerTrack = Util:LoadAnimationFromID(creatorBehaviorActor.Rig, executionAnimConfig.KillerRig, false)
											creatorBehaviorActor.Cache[`{ executionAnimName }Anim`] = killerTrack
										end

										local killerPrimaryPart = creatorBehaviorActor.Rig.PrimaryPart
										local victimTrack = Util:LoadAnimationFromID(victimChar, executionAnimConfig.PlayerRig, false)
										local isExecutionFinished = false
										local stateConn = nil

										stateConn = victimHumanoid.StateChanged:Connect(function(_, newState)
											if newState == Enum.HumanoidStateType.Dead then
												isExecutionFinished = true

												if stateConn then
													stateConn:Disconnect()
													hitboxJanitor:Remove("Execution_" .. victimHumanoid.Name)
												end

												guestHitClient(creator, "Hit", "UREMOTE_EVENT", damageDealt, victimPosInt16, nil, true)
											end
										end)

										hitboxJanitor:Add(stateConn, "Disconnect", "Execution_" .. victimHumanoid.Name)

										Util:GiveInvincible(creatorChar, "Executing")
										Util:SetUpCutscene(creatorBehaviorActor.Rig, victimChar, executionAnimConfig.PlayerCFrameOffset, "Execution")
										task.delay(killerTrack.Length + 1.5, function()
											Util:RemoveInvincible(creatorChar, "Executing")
										end)
										creatorBehaviorActor:DisableAbilities("Execution", true)
										task.delay(killerTrack.Length, function()
											if stateConn then
												stateConn:Disconnect()
												hitboxJanitor:Remove("Execution_" .. victimHumanoid.Name)
											end

											if not isExecutionFinished then
												isExecutionFinished = true
												guestHitClient(creator, "Hit", "UREMOTE_EVENT", damageDealt, victimPosInt16, nil, true)
											end

											creatorBehaviorActor:DisableAbilities("Execution", false)
											Util:ToggleAnchored(creatorBehaviorActor.Rig, "Execution", false)
											Util:ToggleAnchored(victimChar, "Execution", false)
											Util:RemoveStackableAttribute(victimChar, "NoItems", "Execution")
											victimHumanoid.Health = 0
											victimHumanoid:ChangeState(Enum.HumanoidStateType.Dead)
										end)
										killerTrack:Play(0)
										victimTrack:Play(0)

										local executionSound = creatorBehaviorActor.Config.Sounds[executionAnimName]

										Sounds:Play(executionSound, {
											Parent = killerPrimaryPart
										})

										if creatorBehaviorActor.Behavior.OnExecution then
											creatorBehaviorActor.Behavior:OnExecution(creatorBehaviorActor, victimChar, {
												victimInfo = victimActor,
												Tracks = {
													Killer = killerTrack,
													Victim = victimTrack
												}
											})
										end

										if creatorBehaviorActor.Behavior.OnExecutionClient then
											guestHitClient(creatorBehaviorActor.Player, "OnExecutionClientAsync", "REMOTE_EVENT", victimChar)
										end
									end)

									return
								end
							end
						end

						if config.RagdollOnHit then
							local ragdollTime = typeof(config.RagdollOnHit) == "number" and config.RagdollOnHit or 2

							Ragdolls.EnableRagdoll(victimChar, ragdollTime)
						end

						victimChar:SetAttribute("RecentAttacker", (tostring(creator)))
						victimChar:SetAttribute("RecentAttackerTime", os.clock())

						if victimHumanoid:GetAttribute("Overheal") then
							victimHumanoid:SetAttribute("Overheal", remainingOverheal > 0 and remainingOverheal or nil)
						end

						victimHumanoid.Health = victimHumanoid.Health - finalDeductibleDamage

						if victimHumanoid.Health <= 0 then
							victimHumanoid:SetAttribute("Overheal", nil)
							victimHumanoid:ChangeState(Enum.HumanoidStateType.Dead)
						end

						runCallback("Hit", victimChar, i == 1)
						hitboxState.OnHit:Fire(victimChar, i == 1)

						guestHitClient(creator, "Hit", "UREMOTE_EVENT", damageDealt, victimPosInt16, nil, victimHumanoid.Health <= 0)
					end

					local stateRef = hitboxState

					stateRef.TimePast = stateRef.TimePast + RunService.Heartbeat:Wait()
				end

				runCallback("Ended")
				hitboxState.OnEnded:Fire()
			end)

	task.delay(config.Time + 1, function()
		hitboxJanitor:Cleanup()
	end)

	return hitboxState
end


function Hitboxes.Start(_)
	if isServer then
		local Folder = Instance.new("Folder")

		Folder.Name = "Hitboxes"
		Folder.Parent = workspace
	end
end


function Hitboxes.CreateMainAbilityHitbox(self, creator, options)
	local params = table.clone(options or {})
	if params.AbilityType == nil then params.AbilityType = "MainAbility" end
	if params.IsProjectile == nil then params.IsProjectile = false end
	return self:CreateHitbox(creator, params)
end

return Hitboxes]====]},
{path=[====[
ReplicatedStorage/Modules/StatusEffects/KillerExclusive/Atropa]====],before=false,after="2252:2da53db9:b1cec3c8",source=[====[
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Util = require(ReplicatedStorage.Modules.Util)
local status = {
    Data = {
        Duration = 30,
        MaxLevel = 6,
        Stackable = true,
        Hidden = false,
        Description = "Azure's plants mark you. Perforating consumes Atropa for bonus damage and Oblation."
    }
}
local function ownerActor(effect)
    local owner = effect.Data and effect.Data.ApplierPlayer
    return owner and Util:GetActor(owner)
end
local function flowers(effect, amount)
    local actor = ownerActor(effect)
    if actor and actor.Behavior and actor.Behavior.sv_UpdateFlowers then
        actor.Behavior:sv_UpdateFlowers(actor, effect.Character, amount)
    end
end
function status.Applied(effect)
    if not RunService:IsServer() then return end
    effect.Level = math.clamp(tonumber(effect.Level) or 1, 1, 6)
    flowers(effect, effect.Level)
    local owner = effect.Data.ApplierPlayer
    local remaining = math.max(.05, (effect.TimeRequired or effect.Data.Duration or 30) - (effect.TimePast or 0))
    if typeof(owner) == "Instance" and owner:IsA("Player") and effect.Character and effect.Character.Parent then
        local level = effect.Level
        Util:RevealPlayerAuraTo(owner, effect.Character, remaining, Color3.fromHSV(.8, level / 6 * .7 + .3, 1 - level / 6 * .5))
    end
end
function status.Removed(effect)
    if not RunService:IsServer() then return end
    flowers(effect, 0)
    local actor = ownerActor(effect)
    local expired = (effect.TimePast or 0) >= (effect.TimeRequired or effect.Data.Duration or 30)
    -- Dispel, consumption, death, reset, and disconnect are not natural expiry.
    if expired and not effect.Data.IsHit and Util:IsAlive(effect.Character)
        and actor and actor.Behavior and actor.Behavior.sv_IncreaseOblation then
        local amount = math.max(1, math.floor(math.clamp(effect.Level or 1, 1, 6) / 2))
        actor.Behavior:sv_IncreaseOblation(actor, amount)
    end
    local owner = effect.Data.ApplierPlayer
    if typeof(owner) == "Instance" and owner:IsA("Player") and effect.Character then
        Util:RemovePlayerAuraFrom(effect.Character, owner)
    end
end
return status
]====]},
{path=[====[
ReplicatedStorage/Modules/Util]====],before="71800:3ad0b7c6:7c0d141b",after="71923:caa514d6:c376730b",source=[====[
local t1 = {}
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local LocalizationService = game:GetService("LocalizationService")
local DataHandler = require(game.ReplicatedStorage.Modules.DataHandler)
local Janitor = require(game.ReplicatedStorage.Modules.Misc.Janitor) -- maid sucks
local v11 = RunService:IsClient()
local v12 = RunService:IsServer()
local Initializer = require(game.ReplicatedStorage.Initializer)
local Network = require(game.ReplicatedStorage.Modules.Network)
local Sounds = require(game.ReplicatedStorage.Modules.Sounds)
local spawn = task.spawn
local floor = math.floor
local sqrt = math.sqrt
local t2 = {
	Head = true,
	Torso = true,
	["Left Arm"] = true,
	["Left Leg"] = true,
	["Right Arm"] = true,
	["Right Leg"] = true
}

PhysicalProperties.new(0.01, 0, 0, 0, 0)

local physicalProperties = PhysicalProperties.new(0.7, 0.15, 0, 2, 2)

t1.KillerDistanceVector = Vector3.new(1, 4, 1)

function t1.RecursiveDestroy(_: {[any]: any}, t4: {[any]: any}) -- line: 43
	-- upvalues: t1 (copy)
	for _, v in pairs(t4) do
		if typeof(v) == "table" then
			t1:RecursiveDestroy(v)
		elseif typeof(v) == "Instance" then
			v:Destroy()
		end
	end
end
function t1.Lerp(_, p2, p3, p4) -- line: 53
	return p2 + (p3 - p2) * p4
end
function t1.SerializeVector(_: {[any]: any}, vector3: Vector3) -- line: 57
	local buf = buffer.create(12)
	local t6 = {
		vector3.X,
		vector3.Y,
		vector3.Z
	}

	for i, v in ipairs(t6) do
		buffer.writef32(buf, 4 * (i - 1), v)
	end

	return buf
end
function t1.DeserializeVector(_: {[any]: any}, p5: buffer) -- line: 70
	local function get(p6) -- line: 71
		-- upvalues: p5 (copy)
		return (buffer.readf32(p5, 4 * (p6 - 1)))
	end

	return (vector.create(buffer.readf32(p5, 0), buffer.readf32(p5, 4), (buffer.readf32(p5, 8))))
end
function t1.GetLocalTranslator(_) -- line: 78
	-- upvalues: Players (copy), LocalizationService (copy)
	local LocalPlayer = Players.LocalPlayer

	if not LocalPlayer then
		warn(`[{ script:GetFullName() }]: No local player found, returning...`)

		return
	end

	local ok, result = pcall(function() -- line: 85
		-- upvalues: LocalizationService (copy), LocalPlayer (copy)
		return LocalizationService:GetTranslatorForPlayer(LocalPlayer)
	end)

	if not ok then
		warn(`[{ script:GetFullName() }]: Failed to get translator for player: { LocalPlayer }, got: { result }`)

		return
	end

	return result
end
function t1.AddHitboxes(_: {[any]: any}, p8, s1: string) -- line: 97
	-- upvalues: physicalProperties (copy)
	local v55 = typeof(p8) == "table" and p8.Config or {}
	local v56 = typeof(p8) == "table" and p8.Rig or p8
	local t9 = {}

	assert(v56 and v56:IsA("Model"), "character must be a model")

	for _, v in ipairs({
		"CollisionHitbox",
		"QueryHitbox"
	}) do
		while v56:FindFirstChild(v) do
			v56[v]:Destroy()
		end
	end

	local clone = (((if not v55 then nil else (if not v55.Instances then v55.CollisionHitbox else v55.Instances.CollisionHitbox))) or game.ReplicatedStorage.Assets.Instances.CollisionHitbox):Clone()
	local v61 = clone:GetAttribute("CFrameOffset") or CFrame.new(0, 0.5, 0)

	clone.CFrame = v56.PrimaryPart.CFrame * v61
	clone.Name = "CollisionHitbox"

	local clone2 = (((if not v55 then nil else (if not v55.Instances then v55.QueryHitbox else v55.Instances.QueryHitbox))) or game.ReplicatedStorage.Assets.Instances.QueryHitbox):Clone()
	local v63 = clone:GetAttribute("CFrameOffset") or CFrame.new(0, -0.25, 0)

	clone2.CFrame = v56.PrimaryPart.CFrame * v63
	clone2.Name = "QueryHitbox"
	clone2.CanQuery = true
	clone2:SetAttribute("CFOffset", v63)

	local v64 = v56:HasTag("Replicating") and game.Players:GetPlayerFromCharacter(v56)

	for _, v in pairs({
		clone,
		clone2
	}) do
		local v67 = v == clone2 and v64
		local WeldConstraint = Instance.new("WeldConstraint")

		WeldConstraint.Enabled = not v67
		WeldConstraint.Name = "CollisionConnector"
		WeldConstraint.Parent = v
		WeldConstraint.Part1 = v
		WeldConstraint.Part0 = v56.PrimaryPart
		v.CollisionGroup = s1
		v.CustomPhysicalProperties = physicalProperties
		v.Anchored = v67
		v.Parent = v56
		t9[v.Name] = v
	end

	return t9
end
function t1.FixCharacter(_: {[any]: any}, p9, s2: string) -- line: 149
	-- upvalues: t2 (copy), physicalProperties (copy)
	local v72 = s2 or "Survivors"
	local t11 = {}

	for _, descendant in ipairs(p9:GetDescendants()) do
		if not descendant:GetAttribute("Hitbox") and descendant:IsA("BasePart") and descendant.CollisionGroup ~= "Ragdolls" then
			local v76 = (t2[descendant.Name] or p9:GetAttribute("CustomRig")) and p9 == descendant.Parent

			if v76 then
				table.insert(t11, descendant)
			end

			descendant.Anchored = false
			descendant.Massless = not v76 and descendant ~= p9.PrimaryPart

			if descendant ~= p9.PrimaryPart then
				descendant.CanCollide = false
				descendant.CanQuery = v76 or false
				descendant.CanTouch = v76 or false
				descendant.CollisionGroup = "None"

				if p9 ~= descendant.Parent then
					descendant.RootPriority = -2
				end
			else
				descendant.CanCollide = true
				descendant.CanQuery = true
				descendant.CanTouch = true
				descendant.CustomPhysicalProperties = physicalProperties
				descendant.CollisionGroup = v72
			end
		end
	end

	local v77 = 3.5 / #t11

	for _, v in ipairs(t11) do
		v.CustomPhysicalProperties = PhysicalProperties.new(v77, physicalProperties.Friction, physicalProperties.Elasticity, physicalProperties.FrictionWeight, physicalProperties.ElasticityWeight)
	end
end
function t1.GetEntityType(_: {[any]: any}, p10) -- line: 201
	local EntityType = p10:GetAttribute("EntityType")

	if EntityType then
		return EntityType == "Humanoid", EntityType
	end

	if p10:IsDescendantOf(workspace.Players) or p10:HasTag("SimulateSurvivor") then
		return true, "Humanoid"
	end

	if p10:GetAttribute("OwnerName") then
		return false, "Building"
	end

	return false, "Entity"
end
function t1.SnapToAxis(_: {[any]: any}, vector3: Vector3) -- line: 218
	local v85 = math.abs(vector3.X)
	local v86 = math.abs(vector3.Y)
	local v87 = math.abs(vector3.Z)

	if v86 < v85 and v87 < v85 then
		return (Vector3.new(math.sign(vector3.X), 0, 0))
	end

	if v85 < v86 and v87 < v86 then
		return (Vector3.new(0, math.sign(vector3.Y), 0))
	end

	return (Vector3.new(0, 0, (math.sign(vector3.Z))))
end
function t1.IsPlayerKiller(_: {[any]: any}, p11) -- line: 232
	local Character = p11.Character

	return Character and (Character.Parent and Character.Parent.Name == "Killers")
end
function t1.GetDistanceFromGround(_: {[any]: any}, p12) -- line: 237
	local Humanoid = p12:FindFirstChildOfClass("Humanoid")
	local v94 = p12 and p12.PrimaryPart
	local v95 = Humanoid and Humanoid.HipHeight or 2

	local function absVector(p13, p14, p15) -- line: 243
		return (Vector3.new(math.abs(p13), math.abs(p14), (math.abs(p15))))
	end

	for _, v98 in {
		p12:FindFirstChild("Left Leg"),
		p12:FindFirstChild("Right Leg")
	} do
		if v98:IsA("Model") then
			v95 = math.max(v98:GetExtentsSize().Y, v95)
		elseif v98:IsA("BasePart") then
			local v99 = v98.CFrame:VectorToWorldSpace(v98.Size)
			local Z = v99.Z
			local Y = v99.Y
			local X = v99.X
			local vector3 = Vector3.new(math.abs(Z), math.abs(Y), (math.abs(X)))
			local v104 = v98.CFrame:VectorToObjectSpace(vector3)
			local X2 = v104.X
			local Y2 = v104.Y
			local Z2 = v104.Z

			v95 = math.max(Vector3.new(math.abs(X2), math.abs(Y2), (math.abs(Z2))).Y, v95)
		end
	end

	if v94 then
		v95 += v94.Size.Y / 2
	end

	return (math.clamp(v95, 2, 10))
end
function t1.IsAlive(_, p17) -- line: 268
	return p17 and (typeof(p17) == "Instance" and (p17.Parent and (p17.PrimaryPart and (p17:FindFirstChild("Humanoid") and p17.Humanoid.Health > 0))))
end
function t1.EmitParticlesFromAttachment(_: {[any]: any}, p18) -- line: 273
	for _, child in pairs(p18:GetChildren()) do
		if child:IsA("ParticleEmitter") then
			child:Emit(child:GetAttribute("EmitCount") or 1)
		end
	end
end
function t1.RemoveInstancesFromTableOfInstances(_: {[any]: any}, t18: {[any]: any}, t19: {[any]: any}) -- line: 281
	for k, v in pairs(t18) do
		if t19[v.Name] or t19[v.ClassName] then
			table.remove(t18, k)
		end
	end

	return t18
end
function t1.DoFOVBop(_: {[any]: any}, p19, n1: number, n2: number, p20) -- line: 291
	-- upvalues: t1 (copy), HttpService (copy), TweenService (copy)
	local v124 = t1:CreateFOVMultiplier(p19, n1, HttpService:GenerateGUID(false))
	local tween = TweenService:Create(v124, p20, {
		Value = n2
	})

	tween:Play()
	tween.Completed:Once(function(_) -- line: 297
		-- upvalues: v124 (copy)
		v124:Destroy()
	end)
end
function t1.LoadAnimationFromID(_: {[any]: any}, p22, s3: string, b1: boolean) -- line: 303
	if not p22 then
		warn(debug.traceback("no rig found while loading animation from ID!"))

		return
	end

	if not s3 then
		warn(debug.traceback("no ID found while loading animation onto rig!"))

		return
	end

	if typeof(s3) ~= "string" then
		return
	end

	if s3 == "rbxassetid://0" then
		warn(`[Util :: LoadAnimationFromID]: Invalid ID { s3 } for rig { p22.Name }!`)

		return
	end

	local Animator = p22:FindFirstChild("Animator", true)

	while not Animator do
		task.wait()
		Animator = p22:FindFirstChild("Animator", true)
	end

	local s3_2 = p22:FindFirstChild(s3)

	if s3_2 then
		return Animator:LoadAnimation(s3_2)
	end

	local Animation = Instance.new("Animation")

	Animation.Name = s3
	Animation.AnimationId = s3
	Animation.Parent = p22

	local track = Animator:LoadAnimation(Animation)
	local n3 = 0

	if b1 and track.Length <= 0 then
		repeat
			n3 += task.wait()
		until track.Length > 0 or n3 >= 25
	end

	return track
end
function t1.PlayDummyCutsceneAnimations(_: {[any]: any}, p23, p24, s4: string) -- line: 341
	-- upvalues: t1 (copy)
	local KillerCutsceneBackground = workspace.Misc:WaitForChild("KillerCutsceneBackground", 5)
	local t23 = {}

	if KillerCutsceneBackground then
		local Dummies = KillerCutsceneBackground:FindFirstChild("Dummies")

		if not Dummies then
			return
		end

		for _, child in ipairs(Dummies:GetChildren()) do
			if p23.Config.Animations[s4][child.Name .. "Rig"] then
				local v144 = t1:LoadAnimationFromID(child, p23.Config.Animations[s4][child.Name .. "Rig"])

				v144.Looped = false
				v144:Play()
				v144.Stopped:Once(function() -- line: 354
					-- upvalues: child (copy), v144 (copy)
					for _, child2 in ipairs(child:GetChildren()) do
						if child2:IsA("BasePart") then
							child2.Anchored = true
						end
					end

					v144:Play()
					v144.TimePosition = v144.Length
					v144:AdjustSpeed(0)
				end)
				game.Debris:AddItem(v144, p24 + 3)
				t23[child] = v144
			end
		end
	end

	return t23
end
function t1.GetRandomFriendLocal(_) -- line: 374
	-- upvalues: Players (copy)
	assert(game:GetService("RunService"):IsClient(), "GetRandomFriendLocal() can only be called on the client context!")

	local ok, result = pcall(function() -- line: 377
		-- upvalues: Players (copy)
		return Players:GetFriendsAsync(Players.LocalPlayer.UserId)
	end)

	if not ok then
		warn(`[{ script.Name }:GetFirstFriendLocal()]: Failed to get friends list for local player: { result }`)

		return nil
	end

	local CurrentPage = result:GetCurrentPage()

	return CurrentPage and CurrentPage[math.random(#CurrentPage)]
end
function t1.ApplyDamage(_: {[any]: any}, p26, n4: number, n5: number?) -- line: 391
	-- upvalues: t1 (copy)
	local AchievementUtil = require(game.ReplicatedStorage.Modules.AchievementUtil)
	local Actors = require(game.ReplicatedStorage.Modules.Actors)
	local Humanoid = p26:FindFirstChild("Humanoid")
	local num = tonumber(n4)

	if not num or (not Humanoid or not (Humanoid.Health > 0)) then
		return
	end

	if p26:GetAttribute("Invincible") then
		return
	end

	local ResistanceMultipliers = p26:FindFirstChild("ResistanceMultipliers")
	local n6 = 0

	for _, v in pairs(ResistanceMultipliers and ResistanceMultipliers:GetChildren() or {}) do
		n6 += v.Value
	end

	local v161 = num * (1 - math.min(n6, 100) / 100)
	local v162 = Actors.CurrentActors[game.Players:GetPlayerFromCharacter(p26)]

	if v162 and v162.Behavior and v162.Behavior.OnHit then
		local t25 = {
			TimePast = 0
		}

		v162.Behavior:OnHit(v162, t25, v161)

		if t25.TimePast ~= 0 then
			return
		end
	end

	local v164 = Humanoid:GetAttribute("Overheal") or 0
	local v165 = p26:GetAttribute("ShatterpointHP") or 0
	local _ = Humanoid.Health + v164 + v165
	local v167 = if Humanoid.Health > 0 then p26:GetAttribute("DusekkarProtected") and game.Players:FindFirstChild(p26:GetAttribute("DusekkarProtected")) else p26:GetAttribute("DusekkarProtected") and game.Players:FindFirstChild(p26:GetAttribute("DusekkarProtected"))
	local v168 = math.max(0, v164 - v161)

	if v168 < (Humanoid:GetAttribute("OverhealDecayMin") or 0) then
		Humanoid:SetAttribute("OverhealDecayMin", v168 > 0 and v168 or nil)
	end

	local v169 = v161 - v164

	if v169 > 0 and v165 > 0 then
		local v170 = v169 * (p26:GetAttribute("ShatterpointResistance") or 1)

		if v170 > 0 then
			local Actor = t1:GetActor(p26)

			if Actor and Actor.Behavior and Actor.Behavior.sv_DamageCrystalHP then
				Actor.Behavior:sv_DamageCrystalHP(Actor, v170)
			else
				p26:SetAttribute("ShatterpointHP", (math.max(0, v165 - v170)))
			end

			local v172 = v170 - v165

			v169 = not (v172 > 0) and 0 or v172
		end
	end

	local v173 = math.clamp(v169, 0, Humanoid.Health - (n5 or 0))

	if Humanoid.Health - v173 <= 0 and v167 then
		local Character = v167.Character

		Actors:IncrementActorStats(v167, {
			Action = "Prevented the death of a Survivor",
			Money = 10,
			EXP = 30,
			KillerChance = 0.5
		})
		p26:SetAttribute("DusekkarProtected", nil)
		Character:SetAttribute("Protecting", nil)
		AchievementUtil:IncrementAchievementProgress(v167, "DusekkarUbercharge")

		return
	end

	if Humanoid:GetAttribute("Overheal") then
		Humanoid:SetAttribute("Overheal", v168 > 0 and v168 or nil)
	end

	Humanoid.Health = Humanoid.Health - v173

	if Humanoid.Health <= 0 then
		Humanoid:SetAttribute("Overheal", nil)
		Humanoid:ChangeState(Enum.HumanoidStateType.Dead)
	end

	if Humanoid.Health <= 0 and tostring(p26.Parent) == "Survivors" then
		local RoundManager = game.ServerScriptService.Server.Systems.Core.RoundManager
		local lib = require(RoundManager)

		require(RoundManager.Configuration)

		if lib.CurrentSession and lib.CurrentSession.TimePast then
			local CurrentSession = lib.CurrentSession

			CurrentSession.TimePast = CurrentSession.TimePast - (tonumber(lib.CurrentSession.Gamemode and lib.CurrentSession.Gamemode.TimeAddedOnKill) or 20)
		end

		local str = tostring(p26:GetAttribute("RecentAttacker"))
		local v179 = tonumber(p26:GetAttribute("RecentAttackerTime")) or 0
		local str2 = game.Players:FindFirstChild(str)

		if str2 and v179 + 12.5 >= os.clock() then
			require(game.ReplicatedStorage.Modules.Stats):UpdatePlayerStat(str2, "Kills", "Add", 1)

			local Actor = t1:GetActor(str2)

			if Actor and Actor.Behavior and Actor.Behavior.OnKill then
				local ok, result = pcall(function() -- line: 514
					-- upvalues: Actor (copy), p26 (copy)
					return Actor.Behavior.OnKill(Actor, p26)
				end)

				if not ok then
					warn(`[{ script }/CreateHitbox]: Failed to call .OnKill() due to: { result }`)
				end
			end

			Actors:IncrementActorStats(str2, {
				Action = "Killed a Survivor through damage over time",
				Money = 15,
				EXP = 45
			})
		end
	end
end
function t1.Heal(_: {[any]: any}, p27, n7: number, _) -- line: 540
	local v188 = p27:GetAttribute("HardDamage") or 0

	if p27.Health > p27.MaxHealth - v188 then
		return false
	end

	p27.Health = math.clamp(p27.Health + n7, 0, p27.MaxHealth - v188)

	return true
end

t1.SpeedCaps = {}

function t1.SetSpeedCap(_: {[any]: any}, p29, s5: string, n8: number?, n9: number?) -- line: 553
	-- upvalues: t1 (copy)
	if game["Run Service"]:IsClient() then
		return
	end

	if not s5 then
		return
	end

	local v194 = p29 and (p29:IsA("Model") and p29 or p29.Character)

	if not v194 then
		return
	end

	if n8 then
		if not t1.SpeedCaps[v194] then
			t1.SpeedCaps[v194] = {}
		end

		t1.SpeedCaps[v194][s5] = {
			Value = n8,
			ID = math.random(0, 1000000)
		}

		return
	end

	if t1.SpeedCaps[v194] then
		if tonumber(n9) then
			local ID = t1.SpeedCaps[v194].ID

			task.delay(n9, function() -- line: 572
				-- upvalues: t1 (copy), v194 (copy), ID (copy), s5 (copy)
				if t1.SpeedCaps[v194] and t1.SpeedCaps[v194].ID == ID then
					t1.SpeedCaps[v194][s5] = nil
				end
			end)

			return
		end

		t1.SpeedCaps[v194][s5] = nil
	end
end

local t28 = {}
local t29 = {}

function t1.GiveStackableAttribute(_: {[any]: any}, p30, s6: string, s7: string, n10: number?) -- line: 589
	-- upvalues: t1 (copy), t28 (copy)
	if not p30 then
		return
	end

	if typeof(p30) == "Model" and (not p30 or not t1:IsAlive(p30)) then
		return
	end

	local v201 = s7 or "Default"
	local v202 = t28[p30]

	if not v202 then
		v202 = {}
		t28[p30] = v202
		p30.Destroying:Once(function() -- line: 601
			-- upvalues: t28 (copy), p30 (copy)
			table.clear(t28[p30] or {})
			t28[p30] = nil
		end)
	end

	local u203 = v202[s6]

	if not u203 then
		u203 = {}
		v202[s6] = u203
	end

	local v204 = not p30:GetAttribute(s6) and 0 or (typeof(p30:GetAttribute(s6)) ~= "number" and 1 or p30:GetAttribute(s6))
	local v205 = u203[v201]

	if v205 then
		if typeof(v205) == "thread" then
			pcall(task.cancel, v205)
		end

		v204 -= 1
	end

	u203[v201] = nil
	p30:SetAttribute(s6, v204 + 1)

	if n10 then
		u203[v201] = task.delay(n10, function() -- line: 633
			-- upvalues: t1 (copy), p30 (copy), t28 (copy), u203 (ref), v201 (copy), s6 (copy)
			if not t1:IsAlive(p30) then
				return
			end

			if not t28[p30] then
				return
			end

			u203[v201] = nil

			if not next(u203) then
				p30:SetAttribute(s6, nil)

				return
			end

			local v650 = not p30:GetAttribute(s6) and 0 or (typeof(p30:GetAttribute(s6)) ~= "number" and 1 or p30:GetAttribute(s6))

			p30:SetAttribute(s6, v650 - 1)
		end)
	else
		u203[v201] = true
	end
end
function t1.RemoveStackableAttribute(_: {[any]: any}, p31, s8: string, s9: string?) -- line: 651
	-- upvalues: t1 (copy), t28 (copy)
	if not p31 then
		return
	end

	if typeof(p31) == "Model" and (not p31 or not t1:IsAlive(p31)) then
		return
	end

	local v210 = t28[p31]

	if not v210 then
		return
	end

	local v211 = v210[s8]

	if not v211 then
		return
	end

	if not s9 then
		for k, v in pairs(v211) do
			if typeof(v) == "thread" then
				pcall(task.cancel, v)
			end

			v211[k] = nil
		end

		table.clear(v211 or {})
		p31:SetAttribute(s8, nil)

		return
	end

	local v214 = v211[s9]

	if not v214 then
		return
	end

	if typeof(v214) == "thread" then
		pcall(task.cancel, v214)
	end

	v211[s9] = nil

	if not next(v211) then
		p31:SetAttribute(s8, nil)

		return
	end

	p31:SetAttribute(s8, (not p31:GetAttribute(s8) and 0 or (typeof(p31:GetAttribute(s8)) ~= "number" and 1 or p31:GetAttribute(s8))) - 1)
end
function t1.GiveStackableProperty(_: {[any]: any}, p32, s10: string, s11: string) -- line: 695
	-- upvalues: t29 (copy)
	local v219 = s11 or "Default"
	local v220 = t29[p32]

	if not v220 then
		v220 = {}
		t29[p32] = v220
		p32.Destroying:Once(function() -- line: 704
			-- upvalues: t29 (copy), p32 (copy)
			table.clear(t29[p32] or {})
			t29[p32] = nil
		end)
	end

	local v221 = v220[s10]

	if not v221 then
		v221 = {}
		v220[s10] = v221
	end

	p32[s10] = true
	v221[v219] = true
end
function t1.RemoveStackableProperty(_: {[any]: any}, p33, s12: string, s13: string?) -- line: 723
	-- upvalues: t29 (copy)
	if not p33 then
		warn("no instance")

		return
	end

	local v226 = t29[p33]

	if not v226 then
		warn(`[{ script }]: property cache was never created for character { p33 } (caller: { debug.info(2, "s") }:{ debug.info(2, "l") })`)

		return
	end

	local v227 = v226[s12]

	if not v227 then
		warn(`[{ script }]: '{ s12 }' property cache was never created for { p33 } (caller: { debug.info(2, "s") }:{ debug.info(2, "l") })`)

		return
	end

	if not s13 then
		for k, _ in pairs(v227) do
			v227[k] = nil
		end

		table.clear(v227 or {})
		p33[s12] = false

		return
	end

	if not v227[s13] then
		warn(s12, "not applied with reason", s13)

		return
	end

	v227[s13] = nil

	if not next(v227) then
		p33[s12] = false

		return
	end

	warn("reasons for property", s12, "still present, not removing", v227)
end
function t1.GiveInvincible(_: {[any]: any}, p34, s14: string, n11: number?) -- line: 774
	-- upvalues: t1 (copy)
	if typeof(p34) ~= "Instance" then
		warn("Attempted to make a non-instance invincible")

		return
	end

	local v234 = p34:IsA("Model") and p34.PrimaryPart

	if v234 and not v234:FindFirstChild("InvincibleFX") then
		game.ReplicatedStorage.Assets.UI.InvincibleVFX.InvincibleFX:Clone().Parent = v234
	end

	t1:GiveStackableAttribute(p34, "Invincible", s14)

	if n11 then
		task.delay(n11, function() -- line: 790
			-- upvalues: t1 (copy), p34 (copy), s14 (copy)
			t1:RemoveInvincible(p34, s14)
		end)
	end
end
function t1.RemoveInvincible(_: {[any]: any}, p35, s15: string) -- line: 796
	-- upvalues: t1 (copy)
	if typeof(p35) ~= "Instance" then
		warn("Attempted to make a non-instance not invincible")

		return
	end

	t1:RemoveStackableAttribute(p35, "Invincible", s15)

	if not p35:GetAttribute("Invincible") then
		local v238 = p35:IsA("Model") and p35.PrimaryPart

		if v238 then
			local InvincibleFX = v238:FindFirstChild("InvincibleFX")

			if InvincibleFX then
				InvincibleFX.Name = "Destroying"
				InvincibleFX.Main.Enabled = false
				game.Debris:AddItem(InvincibleFX, 0.6)
			end
		end
	end
end
function t1.ToggleAnchored(_: {[any]: any}, p36, s16: string?, b2: boolean) -- line: 818
	-- upvalues: t1 (copy)
	local v244 = p36 and (p36:IsA("Model") and p36.PrimaryPart)

	if not v244 then
		return
	end

	if b2 then
		t1:GiveStackableProperty(v244, "Anchored", s16)

		return
	end

	t1:RemoveStackableProperty(v244, "Anchored", s16)
end
function t1.CreateValueMultiplier(_: {[any]: any}, p37, s17: string, n12: number, s18: string, n13: number?, b3: boolean?) -- line: 831
	-- upvalues: TweenService (copy), Debris (copy)
	local v252 = p37 and (p37:IsA("Model") and p37 or p37.Character)
	local v253 = v252 and v252:FindFirstChild(`{ s17 }Multipliers`)
	local v254 = v253 and v253:FindFirstChild((tostring(s18)))
	local NumberValue = Instance.new("NumberValue")

	NumberValue.Value = n12 or 1
	NumberValue.Name = s18 or `{ s17 }Multiplier`
	NumberValue:SetAttribute("Tick", os.clock())
	NumberValue:SetAttribute("Duration", n13)
	NumberValue.Parent = v253

	if n13 then
		if b3 then
			task.delay(n13 - 0.3, function() -- line: 841
				-- upvalues: TweenService (copy), NumberValue (copy)
				TweenService:Create(NumberValue, TweenInfo.new(0.3), {
					Value = 1
				}):Play()
			end)
		end

		Debris:AddItem(NumberValue, n13)
	end

	if v254 then
		v254:Destroy()
	end

	return NumberValue
end
function t1.CreateSpeedMultiplier(_: {[any]: any}, p38, n14: number, s19: string, n15: number?, b4: boolean?) -- line: 855
	-- upvalues: t1 (copy)
	return t1:CreateValueMultiplier(p38, "Speed", n14, s19, n15, b4)
end
function t1.CreateFOVMultiplier(_: {[any]: any}, p39, n16: number, s20: string, n17: number, b5: boolean) -- line: 860
	-- upvalues: t1 (copy)
	return t1:CreateValueMultiplier(p39, "FOV", n16, s20, n17, b5)
end
function t1.CreateResistanceMultiplier(_: {[any]: any}, p40, n18: number, s21: string, n19: number, b6: boolean) -- line: 865
	-- upvalues: t1 (copy)
	return t1:CreateValueMultiplier(p40, "Resistance", n18, s21, n19, b6)
end
function t1.GetSettingValue(_, p42, p43) -- line: 870
	-- upvalues: v11 (copy), DataHandler (copy)
	if v11 then
		local v277 = if not p43 then DataHandler:ReadPath("Settings"):FindFirstChild(p42, true) else DataHandler:ReadPathFrom(p43, "Settings"):FindFirstChild(p42, true)

		return v277 and v277.Value or nil
	end

	local p42_2 = DataHandler:ReadPathFrom(p43, "Settings"):FindFirstChild(p42, true)

	return p42_2 and p42_2.Value or nil
end
function t1.ApplyOverheal(_: {[any]: any}, p44, n20: number, b7: boolean?) -- line: 886
	local v283 = p44 and (p44:IsA("Model") and p44 or p44.Character)
	local v284 = v283 and v283:FindFirstChild("Humanoid")

	if not v284 then
		return
	end

	if not tonumber(n20) then
		return
	end

	if n20 <= 0 then
		v284:SetAttribute("Overheal", nil)
		v284:SetAttribute("DrainingID", nil)

		return
	end

	if b7 then
		v284:SetAttribute("Overheal", (v284:GetAttribute("Overheal") or 0) + n20)
	else
		v284:SetAttribute("Overheal", n20)
	end

	if b7 then
		local v285 = math.random(-10000000, 10000000)

		v284:SetAttribute("DrainingID", v285)
		task.spawn(function() -- line: 912
			-- upvalues: v284 (copy), v285 (copy)
			while v284.Parent and v284.Health > 0 and v285 == v284:GetAttribute("DrainingID") do
				local v651 = v284:GetAttribute("OverhealDecayMin") or 0
				local elapsed = task.wait()
				local Overheal = v284:GetAttribute("Overheal")

				if not Overheal then
					break
				end

				local v654 = math.clamp(Overheal - 2 * elapsed, v651, 1e999)

				if v654 <= v651 then
					v284:SetAttribute("Overheal", v651 > 0 and v651 or nil)

					break
				end

				v284:SetAttribute("Overheal", v654)
			end

			if v285 == v284:GetAttribute("DrainingID") then
				local v655 = v284:GetAttribute("OverhealDecayMin") or 0

				v284:SetAttribute("Overheal", v655 > 0 and v655 or nil)
				v284:SetAttribute("DrainingID", nil)
			end
		end)
	end
end
function t1.GetPlayerMousePosition(_: {[any]: any}, p45, ...) -- line: 942
	-- upvalues: v12 (copy), Network (copy), v11 (copy)
	if v12 then
		return (Network:FireClientConnection(p45, "GetMousePosition", "REMOTE_FUNCTION", ...))
	end

	if v11 then
		return require(game.ReplicatedStorage.Systems.Player.Miscellaneous.GetPlayerMousePosition):GetMousePos(...)
	end
end
function t1.GetPlayerCameraCFrame(_: {[any]: any}, p46, ...) -- line: 953
	-- upvalues: v12 (copy), Network (copy), v11 (copy)
	if v12 then
		return (Network:FireClientConnection(p46, "GetCameraCFrame", "REMOTE_FUNCTION", ...))
	end

	if v11 then
		return require(game.ReplicatedStorage.Systems.Player.Miscellaneous.GetPlayerMousePosition):GetCameraCFrame(...)
	end
end
function t1.GetActor(_: {[any]: any}, p47) -- line: 963
	if typeof(p47) ~= "Instance" then return nil end
	local actors = require(game.ReplicatedStorage.Modules.Actors).CurrentActors
	local rig = p47:IsA("Model") and p47 or p47:IsA("Player") and p47.Character
	if not rig then return nil end
	local key = p47:IsA("Model") and (game.Players:GetPlayerFromCharacter(p47) or p47) or p47
	local actor = actors[key]
	if actor then return actor end
	for _, candidate in pairs(actors) do
		if candidate.Rig == rig then return candidate end
	end
end
function t1.SetUpCutscene(_: {[any]: any}, p48, p49, cFrame: CFrame?, s22: string) -- line: 973
	-- upvalues: t1 (copy)
	local v297 = t1:GetActor(p48) or p48
	local v298 = t1:GetActor(p49) or p49
	local v299 = s22 or "Cutscene"
	local PrimaryPart = p49.PrimaryPart
	local PrimaryPart2 = p48.PrimaryPart
	local v302 = typeof(v297) == "table" and v297:GetPivot().Position or PrimaryPart2.Position
	local v303 = typeof(v298) == "table" and v298:GetPivot().Position or PrimaryPart.Position
	local cFrame2 = CFrame.new(v302, (Vector3.new(v303.X, v302.Y, v303.Z)))

	if cFrame2 ~= cFrame2 then
		cFrame2 = PrimaryPart2.CFrame
	end

	v297:PivotTo(cFrame2)
	v298:PivotTo(PrimaryPart2.CFrame * (cFrame or CFrame.new()))
	p48.PrimaryPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
	p49.PrimaryPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
	t1:ToggleAnchored(p48, v299, true)
	t1:ToggleAnchored(p49, v299, true)
	t1:GiveStackableAttribute(p49, "NoItems", v299, 7)
end
function t1.RagdollLaunch(_: {[any]: any}, p50, p51, vector3: Vector3, n21: number) -- line: 1001
	local raycastParams = RaycastParams.new()

	raycastParams.FilterDescendantsInstances = workspace.Players:GetDescendants()
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude

	local v311 = p50.Rig.PrimaryPart.Size.X / 2
	local v312 = typeof(p50) == "table" and p50:GetPivot().Position or p50.PrimaryPart.Position
	local Magnitude = vector3.Magnitude
	local v314 = Magnitude / 10
	local raycastResult = workspace:Raycast(p51.PrimaryPart.Position, vector3.Unit * v314, raycastParams)
	local v316 = raycastResult and raycastResult.Distance or v314
	local v317 = vector3 * game.TweenService:GetValue(v316 / v314, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

	p51:SetPrimaryPartCFrame(CFrame.new(v312 + vector3.Unit * v311))
	p51.PrimaryPart.AssemblyLinearVelocity = v317

	local Ragdolls = require(game.ReplicatedStorage.Modules.Ragdolls)

	Ragdolls.AddProfile(p51, {
		Velocity = v317
	})
	Ragdolls.EnableRagdoll(p51, n21 or math.clamp(Magnitude / 80, 0.5, 5))
end
function t1.SelectRandomKillers(_: {[any]: any}, t48: {[any]: any}, p52) -- line: 1027
	-- upvalues: t1 (copy)
	local t49 = {}
	local t50 = {}

	for _, v in pairs(t48) do
		local v326 = v.Instance and v.Instance:FindFirstChild("PlayerData")
		local v327 = v326 and v326:FindFirstChild("Stats")
		local v328 = v327 and v327:FindFirstChild("KillerChance", true)

		if v328 then
			v.KillerChance = v328
			table.insert(t50, v)
		end
	end

	local v331 = workspace:GetAttribute("ServerType") == "VIP"

	if v331 then
		t1:ShuffleTable(t50)
	else
		table.sort(t50, function(p53, p54) -- line: 1054
			return p53.KillerChance.Value > p54.KillerChance.Value
		end)
	end

	local v332 = math.clamp(#t48 - 1, not workspace:GetAttribute("ForcedKiller") and 0 or 1, 1e999)

	if v332 >= 1 then
		for _ = 1, math.clamp(p52, 1, v332) do
			local v334 = nil
			local v335 = nil
			local ForcedKiller = workspace:GetAttribute("ForcedKiller")

			workspace:SetAttribute("ForcedKiller", nil)

			if ForcedKiller then
				for k, v in pairs(t50) do
					if ForcedKiller == tostring(v.Instance) then
						v334 = v
						v335 = k
					end
				end
			end

			if not v334 then
				v334 = t50[1]
				v335 = 1
			end

			if v334 and v335 then
				if not v331 then
					v334.KillerChance.Value = 1
				end

				table.insert(t49, v334)
				table.remove(t50, v335)
			end
		end
	end

	if not v331 then
		for _, v in pairs(t50) do
			t1:AddToPlayerStat(v.Instance, "KillerChance", 1)
		end
	end

	return t49, t50
end
function t1.PreloadAssets(_: {[any]: any}, t52: {[any]: any}, p55: ((...any) -> ...any)?) -- line: 1129
	-- upvalues: v11 (copy)
	task.spawn(function() -- line: 1133
		-- upvalues: v11 (copy), t52 (copy), p55 (copy)
		local t53 = {}

		local function fetchAssets(p56) -- line: 1135
			-- upvalues: fetchAssets (copy), v11 (copy), t53 (ref)
			for k, v in pairs(p56) do
				if typeof(v) == "table" then
					fetchAssets(v)
				elseif typeof(v) == "string" and v:find("rbxassetid://") then
					if k == "Sounds" and v11 then
						local Sound = Instance.new("Sound")

						Sound.Parent = workspace:FindFirstChild("Sounds")
						Sound.SoundId = v
						Sound.Volume = 0
						Sound:Play()
						game.Debris:AddItem(Sound, 1)
					end

					table.insert(t53, v)
				end
			end
		end

		fetchAssets(t52)
		game.ContentProvider:PreloadAsync(t53, p55)
		table.clear(t53)
		t53 = nil
	end)
end
function t1.ToggleLockForAbilityIcon(_, p58, p59, p60) -- line: 1161
	local AbilityContainer = game.Players.LocalPlayer.PlayerGui.MainUI:FindFirstChild("AbilityContainer")
	local v349 = AbilityContainer and AbilityContainer:FindFirstChild((tostring(p58)))

	if not v349 then
		return
	end

	local function setAbilityIconTitleTransparencies(p61) -- line: 1169
		-- upvalues: v349 (copy)
		local Clipping = v349:FindFirstChild("Clipping")
		local CooldownTime = v349:FindFirstChild("CooldownTime")

		if Clipping then
			Clipping.Visible = p61
		end

		if CooldownTime then
			CooldownTime.Visible = p61
		end
	end

	if p60 and not v349:FindFirstChild(p59) then
		local clone = script.AbilityLock:Clone()

		clone.Name = p59
		clone.Parent = v349

		local Clipping = v349:FindFirstChild("Clipping")
		local CooldownTime = v349:FindFirstChild("CooldownTime")

		if Clipping then
			Clipping.Visible = false
		end

		if CooldownTime then
			CooldownTime.Visible = false

			return
		end
	elseif not p60 then
		local Clipping = v349:FindFirstChild("Clipping")
		local CooldownTime = v349:FindFirstChild("CooldownTime")

		if Clipping then
			Clipping.Visible = true
		end

		if CooldownTime then
			CooldownTime.Visible = true
		end

		local p59_2 = v349:FindFirstChild(p59)

		if p59_2 then
			p59_2:Destroy()
		end
	end
end
function t1.ToggleLocksForAbilityIcons(_, p63, p64) -- line: 1196
	-- upvalues: t1 (copy)
	local AbilityContainer = game.Players.LocalPlayer.PlayerGui.MainUI:FindFirstChild("AbilityContainer")
	local v361 = AbilityContainer and AbilityContainer:GetChildren() or {}

	for _, v in pairs(v361) do
		if v:IsA("GuiObject") then
			t1:ToggleLockForAbilityIcon(v.Name, p63, p64)
		end
	end
end

local ScreenGui = nil

function t1.CreateDisplayUI(_: {[any]: any}, t55: {[any]: any}) -- line: 1210
	-- upvalues: ScreenGui (ref), TweenService (copy), Debris (copy)
	if not ScreenGui then
		ScreenGui = Instance.new("ScreenGui")
		ScreenGui.Name = "KillerIntroUI"
		ScreenGui.DisplayOrder = 10
		ScreenGui.ResetOnSpawn = false
		ScreenGui.Parent = game.Players.LocalPlayer.PlayerGui
	end

	local t56 = {}
	local KillerDisplays = game.ReplicatedStorage.Assets.UI.KillerDisplays
	local clone = KillerDisplays.KillerDisplayBackground:Clone()

	clone.Parent = ScreenGui
	clone.ImageTransparency = 1
	clone.Title.TextTransparency = 1
	clone.Title.Text = not (#t55 > 1) and "This round's killer is..." or "This round's killers are..."
	TweenService:Create(clone, TweenInfo.new(0.2), {
		ImageTransparency = 0
	}):Play()
	TweenService:Create(clone.Title, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {
		TextTransparency = 0
	}):Play()
	table.insert(t56, clone)
	table.insert(t56, clone.Title)
	task.delay(0.65, function() -- line: 1233
		-- upvalues: t55 (copy), KillerDisplays (copy), clone (copy), TweenService (copy), t56 (copy)
		for k, v in pairs(t55) do
			local clone3 = KillerDisplays.Display:Clone()

			clone3.Parent = clone.Displays
			clone3.LayoutOrder = k
			clone3.KillerName.Text = v.KillerName
			clone3.PlayerName.Text = `({ v.PlayerName })`
			clone3.KillerName.TextTransparency = 1
			clone3.PlayerName.TextTransparency = 1
			TweenService:Create(clone3.KillerName, TweenInfo.new(0.2), {
				TextTransparency = 0
			}):Play()
			TweenService:Create(clone3.PlayerName, TweenInfo.new(0.2), {
				TextTransparency = 0.6
			}):Play()
			table.insert(t56, clone3.KillerName)
			table.insert(t56, clone3.PlayerName)

			if k ~= #t55 then
				local clone4 = KillerDisplays.Separator:Clone()

				clone4.Parent = clone.Displays
				clone4.LayoutOrder = k
				clone4.TextTransparency = 1
				TweenService:Create(clone4, TweenInfo.new(0.2), {
					TextTransparency = 0
				}):Play()
				table.insert(t56, clone4)
			end
		end
	end)
	task.delay(5, function() -- line: 1259
		-- upvalues: t56 (copy), Debris (copy), TweenService (copy)
		for _, v in pairs(t56) do
			Debris:AddItem(v, 0.5)

			if v:IsA("TextLabel") then
				TweenService:Create(v, TweenInfo.new(0.5), {
					TextTransparency = 1
				}):Play()
			elseif v:IsA("ImageLabel") then
				TweenService:Create(v, TweenInfo.new(0.5), {
					ImageTransparency = 1
				}):Play()
			end
		end
	end)
end

local u24 = nil

function t1.CreateTooltip(_, p66) -- line: 1274
	-- upvalues: u24 (ref), Sounds (copy), UserInputService (copy)
	local LocalPlayer = game.Players.LocalPlayer

	if u24 and (u24.Title.Text ~= tostring(p66) or not u24.Parent) then
		if u24.Parent then
			game.TweenService:Create(u24.Title, TweenInfo.new(0.15), {
				TextSize = 0,
				TextTransparency = 1
			}):Play()
			game.TweenService:Create(u24.Background, TweenInfo.new(0.15), {
				ImageTransparency = 1,
				Size = UDim2.fromScale()
			}):Play()
			game.Debris:AddItem(u24, 0.15)
			Sounds:Play("hoverEnd")
		end

		u24 = nil
	elseif not u24 and p66 then
		local v372 = UserInputService:GetMouseLocation() - game.GuiService:GetGuiInset()

		u24 = script.Tooltip:Clone()
		u24.Title.Text = p66
		u24.Title.Position = UDim2.fromOffset(v372.X, v372.Y + -28)
		u24.Background.Position = UDim2.fromOffset(v372.X, v372.Y + -28 - u24.Title.AbsoluteSize.Y / 2)
		u24.Background.Size = UDim2.fromOffset(u24.Title.AbsoluteSize.X + 64, u24.Title.AbsoluteSize.Y + 50)
		u24.Parent = LocalPlayer.PlayerGui:FindFirstChild("MainUI")
		Sounds:Play("hover")
		task.spawn(function() -- line: 1297
			-- upvalues: u24 (ref), UserInputService (copy)
			while u24 and u24.Parent do
				local v669 = UserInputService:GetMouseLocation() - game.GuiService:GetGuiInset()

				u24.Title.Position = UDim2.fromOffset(v669.X, v669.Y + -28)
				u24.Background.Position = UDim2.fromOffset(v669.X, v669.Y + -28 - u24.Title.AbsoluteSize.Y / 2)
				u24.Background.Size = UDim2.fromOffset(u24.Title.AbsoluteSize.X + 64, u24.Title.AbsoluteSize.Y + 50)
				task.wait()
			end
		end)
	end

	return u24
end
function t1.AddToPlayerStat(_: {[any]: any}, p67, s23: string, n22: number, b8: boolean?) -- line: 1311
	-- upvalues: DataHandler (copy), t1 (copy)
	if workspace:GetAttribute("ServerType") == "VIP" and b8 ~= true then
		return
	end

	local v378 = typeof(p67) == "Instance" and DataHandler:Get(p67, 1)
	local v379 = v378 and v378.Stats:FindFirstChild(tostring(s23), true)

	if v379 and v379:IsA("NumberValue") then
		if s23 == "KillerChance" and not b8 and v378.Settings.Game.MaliceDisabled.Value then
			return
		end

		if s23 == "Money" or s23 == "KillerChance" or s23 == "EXPBoostTime" then
			if typeof(p67) == "Instance" and p67:IsA("Player") then
				game.AnalyticsService:LogEconomyEvent(p67, Enum.AnalyticsEconomyFlowType.Source, s23, tonumber(n22) or 0, v379.Value + (tonumber(n22) or 0), Enum.AnalyticsEconomyTransactionType.Gameplay.Name)
			end
		end
		
		v379.Value = v379.Value + (tonumber(n22) or 0)

		if s23 == "Money" then
			t1:AddToPlayerStat(p67, "NetWorth", n22)
		end
	end
end
function t1.CopyTable(_: {[any]: any}, p68, t59: {[any]: any}?) -- line: 1356
	-- upvalues: t1 (copy)
	if typeof(p68) ~= "table" then
		return p68
	end

	local v383 = t59 or {}
	local v384 = v383[p68]

	if v384 then
		return v384
	end

	local t60 = {}

	v383[p68] = t60

	for k, v in next, p68 do
		t60[k] = t1:CopyTable(v, v383)
	end

	return t60
end
function t1.JoinTables(_, ...) -- line: 1379
	local t61 = {}

	for _, v in ipairs(table.pack(...)) do
		for _, v2 in pairs(v) do
			table.insert(t61, v2)
		end
	end

	return t61
end
function t1.MergeTables(_: {[any]: any}, t63: {[any]: any}, t64: {[any]: any}, t65: {[any]: any}) -- line: 1392
	-- upvalues: t1 (copy)
	if not t64 then
		return t63
	end

	local t66 = {
		Voicelines = true,
		Emotes = true,
		TerrorRadiusThemes = true
	}
	local t67 = {}

	for k, v in pairs(t63 or {}) do
		if typeof(v) == "table" and typeof(t64[k]) == "table" then
			t67[k] = t1:MergeTables(v, t64[k], t65)
		else
			t67[k] = v
		end
	end

	for k, v in pairs(t64 or {}) do
		if typeof(v) == "table" and typeof(t63[k]) == "table" and not t66[k] then
			t67[k] = t1:MergeTables(t63[k], v, t65)
		elseif not table.find(t65 or {}, k) then
			t67[k] = v
		end
	end

	return t67
end
function t1.ShuffleTable(_: {[any]: any}, t69: {[any]: any}) -- line: 1425
	for i = #t69, 1, -1 do
		local v407 = math.random(i)
		local v408 = t69[i]

		t69[i] = t69[v407]
		t69[v407] = v408
	end

	return t69
end
function t1.ToCommas(_: {[any]: any}, n23: number) -- line: 1437
	return tostring(n23):reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
end
function t1.ConvertToAbbreviation(_, p71) -- line: 1447
	local function formatNumber(p72) -- line: 1448
		if p72 % 1 == 0 then
			return string.format("%.0f", p72)
		end

		if p72 * 10 % 1 == 0 then
			return string.format("%.1f", p72)
		end

		return string.format("%.2f", p72)
	end

	if p71 >= 1000000000000000 then
		return formatNumber(p71 / 1000000000000000) .. "Q+"
	end

	if p71 >= 1000000000000 then
		return formatNumber(p71 / 1000000000000) .. "T+"
	end

	if p71 >= 1000000000 then
		return formatNumber(p71 / 1000000000) .. "B+"
	end

	if p71 >= 1000000 then
		return formatNumber(p71 / 1000000) .. "M+"
	end

	if p71 >= 1000 then
		return formatNumber(p71 / 1000) .. "K+"
	end

	return formatNumber(p71)
end
function t1.CalculateLevelFromEXP(_: {[any]: any}, n24: number) -- line: 1474
	-- upvalues: sqrt (copy), floor (copy)
	local v416 = floor((sqrt(n24 * 20 + 11225) + -95) / 10)

	if v416 == 1 then
		return v416, n24, 100
	end

	return v416, n24 - (v416 * 5 * v416 + v416 * 95 - 110), v416 * 10 + 100
end
function t1.FormatTime(_: {[any]: any}, n25: number, s24: string) -- line: 1490
	-- upvalues: Initializer (copy)
	if not n25 then
		Initializer.Debug("can't format time due to seconds being nil!")

		return ""
	end

	if not s24 then
		Initializer.Debug("can't format time due to formatType being nil!")

		return ""
	end

	local v420 = math.floor(n25 / 86400)
	local v421 = math.floor(n25 % 86400 / 3600)
	local v422 = math.floor(n25 % 3600 / 60)
	local v423 = math.floor(n25 % 60)
	local s25 = ""

	if s24 == "Clock" then
		if v420 > 0 then
			return (string.format("%d:%02d:%02d:%02d", v420, v421, v422, v423))
		end

		if v421 > 0 then
			return (string.format("%02d:%02d:%02d", v421, v422, v423))
		end

		return (string.format("%02d:%02d", v422, v423))
	end

	if s24 == "String" then
		if v420 > 0 then
			s25 = `{ s25 }{ v420 }{ v420 ~= 1 and " days" or " day" }`
		end

		if v421 > 0 then
			if s25 ~= "" then
				s25 = `{ s25 }{ not (v420 > 0 and v422 > 0) and not (v423 > 0) and " and " or ", " }`
			end

			s25 = `{ s25 }{ v421 }{ v421 ~= 1 and " hours" or " hour" }`
		end

		if v422 > 0 then
			if s25 ~= "" then
				s25 = `{ s25 }{ (not (v420 > 0) and not (v421 > 0) or not (v423 > 0)) and " and " or ", " }`
			end

			s25 = `{ s25 }{ v422 }{ v422 ~= 1 and " minutes" or " minute" }`
		end

		if v423 > 0 then
			if s25 ~= "" then
				s25 = `{ s25 }{ not (v420 > 0) and (not (v421 > 0) and not (v422 > 0)) and "" or " and " }`
			end

			s25 = `{ s25 }{ v423 }{ v423 ~= 1 and " seconds" or " second" }`
		end
	end

	return s25
end
function t1.IntToRoman(_: {[any]: any}, n26: number) -- line: 1541
	if not tonumber(n26) then
		return "IDK"
	end

	local v427 = math.round((tonumber(n26)))
	local s26 = ""

	for _, v in pairs({
		{
			1000,
			"M"
		},
		{
			900,
			"CM"
		},
		{
			500,
			"D"
		},
		{
			400,
			"CD"
		},
		{
			100,
			"C"
		},
		{
			90,
			"XC"
		},
		{
			50,
			"L"
		},
		{
			40,
			"XL"
		},
		{
			10,
			"X"
		},
		{
			9,
			"IX"
		},
		{
			5,
			"V"
		},
		{
			4,
			"IV"
		},
		{
			1,
			"I"
		}
	}) do
		while v427 >= v[1] do
			s26 ..= v[2]
			v427 -= v[1]
		end
	end

	return s26
end
function t1.ApplyCameraShake(_: {[any]: any}, n27: number, n28: number) -- line: 1574
	-- upvalues: DataHandler (copy)
	local _ = game.Players.LocalPlayer

	if not DataHandler:Get().Settings.Customization.ScreenShakeEnabled.Value then
		return
	end

	local timestamp = os.clock()
	local u436 = nil

	u436 = game:GetService("RunService").RenderStepped:Connect(function() -- line: 1584
		-- upvalues: timestamp (copy), n28 (copy), n27 (copy), u436 (ref)
		local v671 = math.clamp((os.clock() - timestamp) / n28, 0, 1)
		local v672 = n27 * (1 - v671)
		local vector3 = Vector3.new((math.random() - 0.5) * 2 * v672, (math.random() - 0.5) * 2 * v672, (math.random() - 0.5) * 2 * v672)
		local CurrentCamera = workspace.CurrentCamera

		CurrentCamera.CFrame = CurrentCamera.CFrame * CFrame.new(vector3)

		if v671 >= 1 then
			u436:Disconnect()
			u436 = nil

			return
		end
	end)
end
function t1.ApplyCameraShakeTo(_: {[any]: any}, p73, n29: number, n30: number) -- line: 1612
	-- upvalues: v12 (copy), Network (copy)
	if not v12 then
		return
	end

	Network:FireClientConnection(p73, "ShakeCamera", "REMOTE_EVENT", n29, n30)
end
function t1.RemoveCyclicReferences(_, p75, p76) -- line: 1617
	-- upvalues: t1 (copy)
	local v444 = p76 or {}
	local t76 = {}

	for k in pairs(p75) do
		if not table.find(v444, p75[k]) then
			if typeof(p75[k]) ~= "table" then
				t76[k] = p75[k]
			else
				table.insert(v444, p75[k])
				t76[k] = p75[k]

				local v447 = t1:RemoveCyclicReferences(p75[k], v444)

				for k2 in pairs(t76[k]) do
					if not v447[k2] then
						t76[k][k2] = nil
					end
				end
			end
		end
	end

	return t76
end
function t1.IsOnScreen(_: {[any]: any}, p77, b9: boolean) -- line: 1641
	-- upvalues: t2 (copy)
	if typeof(p77) ~= "Instance" then
		return
	end

	os.clock()

	local Character = game.Players.LocalPlayer.Character
	local v453 = false
	local GetPlayerMousePosition = require(game.ReplicatedStorage.Systems.Player.Miscellaneous.GetPlayerMousePosition)
	local t78 = {}

	table.insert(t78, p77)
	table.insert(t78, Character)
	table.insert(t78, workspace.CurrentCamera)

	for k, _ in pairs(GetPlayerMousePosition.TransparentParts) do
		table.insert(t78, k)
	end

	local function checkForVisibility(p78) -- line: 1662
		-- upvalues: t78 (copy)
		local _, v677 = workspace.CurrentCamera:WorldToViewportPoint(p78.Position)

		if v677 and #workspace.CurrentCamera:GetPartsObscuringTarget({
			workspace.CurrentCamera.CFrame.Position,
			p78.Position
		}, t78) == 0 then
			return true
		end
	end

	if p77:IsA("Model") then
		local Humanoid = p77:FindFirstChild("Humanoid")

		for _, child in pairs(p77:GetChildren()) do
			if child:IsA("BasePart") and (Humanoid and (p77 == child.Parent and t2[child.Name]) or child.Transparency ~= 1 or b9) then
				v453 = checkForVisibility(child)

				if v453 then
					return v453
				end
			end
		end

		return v453
	end

	if p77:IsA("BasePart") and (p77.Transparency ~= 1 or b9) then
		v453 = checkForVisibility(p77)
	end

	return v453
end
function t1.CreateProgressBar(_: {[any]: any}, s27: string, n31: number) -- line: 1693
	local u465 = s27 or "Performing Action"
	local u466 = tonumber(n31) or 5
	local LocalPlayer = game.Players.LocalPlayer
	local clone = game.ReplicatedStorage.Assets.UI.ProgressBar:Clone()

	clone.Title.Text = `{ u465 }.`
	clone.Parent = LocalPlayer.PlayerGui:FindFirstChild("TemporaryUI")
	game.Debris:AddItem(clone, u466)
	task.spawn(function() -- line: 1703
		-- upvalues: clone (copy), u466 (ref), u465 (ref)
		local n32 = 0
		local n33 = 0
		local n34 = 0

		while clone.Parent do
			local v681 = n32 / u466
			local v682 = if v681 ~= 0 then 1 / v681 else 0

			clone.Bar.Clipping.Size = UDim2.fromScale(v681, 1)
			clone.Bar.Clipping.Top.Size = UDim2.fromScale(v682, 1)

			if n33 >= 0.3 then
				n33 = 0
				n34 += 1
				clone.Title.Text = `{ u465 }{ string.rep(".", n34 % 3 + 1) }`
			end

			local dt = game["Run Service"].Heartbeat:Wait()

			n32 = math.clamp(n32 + dt, 0, u466)
			n33 += dt
		end
	end)

	return clone
end

local ScreenGui2 = nil
local Frame = nil

function t1.FadeIn(_: {[any]: any}, t81: {[any]: any}) -- line: 1736
	-- upvalues: Frame (ref), Initializer (copy), ScreenGui2 (ref), TweenService (copy)
	if not t81 then
		t81 = {}
	end

	if Frame and Frame.Parent then
		Initializer.Debug("FadeIn cancelled b/c there's already a fade that exists!")

		return
	end

	if not ScreenGui2 then
		ScreenGui2 = Instance.new("ScreenGui")
		ScreenGui2.Name = "FadeUI"
		ScreenGui2.IgnoreGuiInset = true
		ScreenGui2.ResetOnSpawn = false
		ScreenGui2.DisplayOrder = 10
		ScreenGui2.Parent = Initializer.Player.PlayerGui
	end

	Frame = Instance.new("Frame")
	Frame.Name = "Fade"
	Frame.BackgroundTransparency = t81.StartTransparency or 1
	Frame.BackgroundColor3 = t81.Color or Color3.new()
	Frame.Size = UDim2.fromScale(1, 1)
	Frame.Parent = ScreenGui2

	if t81.InstantTween then
		Frame.BackgroundTransparency = t81.EndTransparency or 0

		return
	end

	local tween = TweenService:Create(Frame, t81.TweenInfo or TweenInfo.new(t81.Time or 0.325, Enum.EasingStyle.Linear), {
		BackgroundTransparency = t81.EndTransparency or 0
	})

	tween:Play()

	if t81.Yield then
		tween.Completed:Wait()
	end
end
function t1.FadeOut(_: {[any]: any}, t83: {[any]: any}) -- line: 1774
	-- upvalues: Frame (ref), Initializer (copy), ScreenGui2 (ref), TweenService (copy), Debris (copy)
	if not t83 then
		t83 = {}
	end

	if not Frame then
		Initializer.Debug("FadeOut cancelled b/c there's no fade that exists!")

		return
	end

	if not ScreenGui2 then
		Initializer.Debug("FadeOut called before ever calling FadeIn!")

		return
	end

	local tween = TweenService:Create(Frame, t83.TweenInfo or TweenInfo.new(t83.Time or 0.325, Enum.EasingStyle.Linear), {
		BackgroundTransparency = t83.Transparency or 1
	})

	tween:Play()
	Debris:AddItem(Frame, tween.TweenInfo.Time)

	if t83.Yield then
		tween.Completed:Wait()
	end

	Frame = nil
end
function t1.CreateWarning(_: {[any]: any}, s28: string, s29: string, p79) -- line: 1796
	local LocalPlayer = game.Players.LocalPlayer
	local s28_2 = LocalPlayer.PlayerGui.TemporaryUI:FindFirstChild(s28)

	if s28_2 then
		s28_2:Destroy()
	end

	local clone = (p79 or game.ReplicatedStorage.Assets.UI.Warning):Clone()

	clone.Name = s28
	clone.Title.Text = tostring(s29)
	clone.Parent = LocalPlayer.PlayerGui.TemporaryUI
	task.delay(3, function() -- line: 1809
		-- upvalues: clone (copy)
		if clone.Parent then
			if clone:GetAttribute("InstantDeletion") then
				clone:Destroy()

				return
			end

			game.Debris:AddItem(clone, 1)
			game.TweenService:Create(clone, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
				BackgroundTransparency = 1
			}):Play()
			game.TweenService:Create(clone.Title, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
				TextTransparency = 1,
				TextStrokeTransparency = 1,
				BackgroundTransparency = 1
			}):Play()
		end
	end)
end
function t1.DisplayBubble(_: {[any]: any}, p80, s30: string) -- line: 1823
	-- upvalues: Network (copy)
	if not p80 then
		return
	end

	if game["Run Service"]:IsServer() then
		Network:FireAllClientConnection("DisplayBubble", "REMOTE_EVENT", p80, s30)

		return
	end

	game.TextChatService:DisplayBubble(p80, s30)
end
function t1.ToggleControls(_: {[any]: any}, b10: boolean) -- line: 1833
	-- upvalues: Initializer (copy)
	local Controls = require(Initializer.Player.PlayerScripts:WaitForChild("PlayerModule")):GetControls()

	if not b10 then
		Controls:Disable()

		return
	end

	Controls:Enable()
end
function t1.ToggleResetButton(_, p82) -- line: 1845
	task.spawn(function() -- line: 1846
		-- upvalues: p82 (copy)
		game:GetService("StarterGui"):SetCore("ResetButtonCallback", p82)
	end)
end
function t1.ToggleSprinting(_, p84, p85, p86) -- line: 1853
	-- upvalues: Network (copy)
	Network:FireConnection("DisableSprinting", p84, not p85)

	if p86 then
		task.delay(p86, function() -- line: 1856
			-- upvalues: Network (copy), p84 (copy), p85 (copy)
			Network:FireConnection("DisableSprinting", p84, p85)
		end)
	end
end
function t1.CreateMoneyDisplay(_, p88) -- line: 1863
	-- upvalues: t1 (copy), DataHandler (copy), Sounds (copy), Initializer (copy)
	local NumberValue = Instance.new("NumberValue")

	NumberValue:GetPropertyChangedSignal("Value"):Connect(function() -- line: 1866
		-- upvalues: NumberValue (copy), t1 (copy), p88 (copy)
		local v684 = math.round(NumberValue.Value)
		local v685 = t1:ToCommas(v684)

		p88.CurrentBalance.Text = `{ v685 }$ `
	end)

	local Money = DataHandler:Get():WaitForChild("Stats"):FindFirstChild("Money", true)

	Money:GetPropertyChangedSignal("Value"):Connect(function() -- line: 1875
		-- upvalues: NumberValue (copy), Money (copy), p88 (copy)
		game.TweenService:Create(NumberValue, TweenInfo.new(1), {
			Value = Money.Value
		}):Play()
		p88.CurrentBalance.TextSize = p88.CurrentBalance.AbsoluteSize.Y
	end)
	NumberValue.Value = Money.Value
	p88.CurrentBalance.Text = `{ t1:ToCommas((math.round(NumberValue.Value))) }$ `
	p88.CurrentBalance.TextSize = p88.CurrentBalance.AbsoluteSize.Y
	p88.BuyMore.MouseEnter:Connect(function() -- line: 1886
		-- upvalues: Sounds (copy)
		Sounds:Play("hover")
	end)
	p88.BuyMore.MouseLeave:Connect(function() -- line: 1887
		-- upvalues: Sounds (copy)
		Sounds:Play("hoverEnd")
	end)
	p88.BuyMore.MouseButton1Click:Connect(function() -- line: 1888
		-- upvalues: Initializer (copy)
		local Shop = Initializer.PlayerSystems.Shop

		Initializer.PlayerSystems.SidebarHandler.SidebarMenus.Shop:ToggleMenu(true)
		Shop:SwitchTab("Robux")
	end)
end
function t1.ApplyVelocity(_: {[any]: any}, p89, n35: number, b11: boolean, n36: number?) -- line: 1897
	-- upvalues: Players (copy), Maid (copy), RunService (copy)
	if p89 and p89:IsA("Model") then
		p89 = p89.PrimaryPart
	end

	if not p89 then
		return nil
	end

	local AssemblyMass = p89.AssemblyMass

	for _, descendant in (p89.Parent:GetDescendants()) do
		if descendant:IsA("BasePart") and not descendant.Massless and descendant ~= p89 then
			AssemblyMass += descendant.AssemblyMass
		end
	end

	local Actors = require(game.ReplicatedStorage.Modules.Actors)
	local player = Players:GetPlayerFromCharacter(p89.Parent)
	local v509 = player and Actors.CurrentActors[player]
	local u510 = v509 and (not not v509.GetPivot and v509:GetPivot()) or p89.CFrame
	local LinearVelocity = Instance.new("LinearVelocity")

	LinearVelocity.MaxForce = AssemblyMass * 350
	LinearVelocity.RelativeTo = Enum.ActuatorRelativeTo.World
	LinearVelocity.VelocityConstraintMode = Enum.VelocityConstraintMode.Line
	LinearVelocity.LineDirection = Vector3.new(u510.LookVector.X, 0, u510.LookVector.Z)
	LinearVelocity.LineVelocity = n35 or 0
	LinearVelocity.Attachment0 = p89:FindFirstChild("RootAttachment") or p89:FindFirstChildOfClass("Attachment")
	LinearVelocity.Parent = p89

	local v512 = Janitor.new()

	if b11 then
		task.spawn(function() -- line: 1924
			-- upvalues: v512 (copy), RunService (copy), LinearVelocity (copy), p89 (ref), u510 (ref), v509 (copy), n36 (copy)
			v512:Add(RunService.Heartbeat:Connect(function(_: number) -- line: 1925
				-- upvalues: LinearVelocity (copy), p89 (ref), v512 (copy), u510 (ref), v509 (copy), n36 (copy)
				if not LinearVelocity.Active or not p89.Parent then
					v512:Destroy()
				end

				u510 = v509 and (not not v509.GetPivot and v509:GetPivot()) or p89.CFrame
				LinearVelocity.LineDirection = LinearVelocity.LineDirection:Lerp(Vector3.new(u510.LookVector.X, 0, u510.LookVector.Z), n36 or 0)
			end))
		end)
	end

	return LinearVelocity, v512
end

local tweenInfo = TweenInfo.new(0.25)
local t88 = {}
local t89 = {}

function t1.RevealPlayerAura(_: {[any]: any}, p90, n38: number, color3: Color3, n39: number?, t91: {[any]: any}) -- line: 1944
	-- upvalues: t1 (copy), t88 (copy), DataHandler (copy), Network (copy), Debris (copy), TweenService (copy), tweenInfo (copy), t89 (copy)
	local v519 = n39 or -1
	local v520 = nil
	if typeof(p90) == "Instance" then
		v520 = (p90:IsA("Player") and p90.Character or p90)
	end
	local v521 = v520 and game.Players:GetPlayerFromCharacter(v520)
	local LocalPlayer = game.Players.LocalPlayer
	local Character = LocalPlayer.Character

	if v520 and Character and (not v520:GetAttribute("Undetectable") or tostring(v520.Parent) == tostring(Character.Parent) or #t1:GetAliveSurvivorCharacters() <= 1) then
		local t92 = {
			Killers = Color3.new(1, 0, 0),
			Survivors = Color3.new(1, 0.75, 0),
			Spectating = Color3.new(1, 1, 1)
		}
		local v525 = v520:FindFirstChild("PlayerAura") or t88[v520]

		if v525 then
			return
		end

		local v526 = color3 or (t92[tostring(v520.Parent)] or (t92[tostring(v520)] or t92.Spectating))
		local AltHighlightsValue = DataHandler:Get().Settings.Game.AltHighlights.Value

		if v521 then
			Network:FireServerConnection("RevealedAura", "REMOTE_EVENT", v521, n38)
		end

		local clone

		if AltHighlightsValue then
			if v520:IsA("Model") and not v520.PrimaryPart then
				return
			end

			clone = game.ReplicatedStorage.Assets.UI.Highlight:Clone()
			clone.Name = "PlayerAura"
			clone.Adornee = v520:FindFirstChild("Head") or (v520:IsA("Model") and v520.PrimaryPart or v520)
			clone.Container.ImageColor3 = v526
			clone.Parent = LocalPlayer.PlayerGui.TemporaryUI
			t88[v520] = clone

			local ViewportFrame = clone.Container.ViewportFrame
			local v530 = if not v520:IsA("Model") then ViewportFrame.PartCenter.CFrame else ViewportFrame.ModelCenter.CFrame
			local Archivable = v520.Archivable

			v520.Archivable = true

			local clone5 = v520:Clone()

			v520.Archivable = Archivable

			if not clone5 then
				warn("i don't even know how this happens dude")

				return
			end

			if v520:IsA("Model") then
				clone5:SetPrimaryPartCFrame(v530)
			else
				clone5.CFrame = v530
			end

			clone5.Parent = ViewportFrame

			local t93 = {
				ViewportFrame,
				ViewportFrame.Parent
			}

			Debris:AddItem(clone, tonumber(n38) or 10)

			if not v525 then
				for _, v in pairs(t93) do
					TweenService:Create(v, TweenInfo.new(1), {
						ImageTransparency = 0
					}):Play()
				end
			else
				for _, v in pairs(t93) do
					v.ImageTransparency = 0
				end
			end

			if n38 ~= "inf" then
				local v538 = tonumber(n38) or 10

				task.delay(v538 - 1, function() -- line: 2044
					-- upvalues: clone (ref), t88 (copy), v520 (copy), t93 (copy), TweenService (copy)
					if not clone or not clone.Parent then
						return
					end

					clone.Name = "goodbai"

					if t88[v520] == clone then
						t88[v520] = nil
					end

					for _, v in pairs(t93) do
						TweenService:Create(v, TweenInfo.new(1), {
							ImageTransparency = 1
						}):Play()
					end
				end)
			end

			local v539 = clone.Adornee and (clone.Adornee:IsA("Model") and clone.Adornee.PrimaryPart or clone.Adornee:IsA("BasePart") and clone.Adornee)

			if v539 and v519 > 0 then
				if v519 < (v539.Position - Character.PrimaryPart.Position).Magnitude then
					for _, v in pairs(t93) do
						v.ImageTransparency = 1
					end
				end

				local v542 = nil

				while task.wait(0.5) and clone and clone.Parent do
					local v543 = v519 < (v539.Position - Character.PrimaryPart.Position).Magnitude

					if v542 ~= v543 then
						v542 = v543

						for _, v in pairs(t93) do
							game.TweenService:Create(v, tweenInfo, {
								ImageTransparency = not v543 and 0 or 1
							}):Play()
						end
					end
				end
			end
		else
			local t94 = {}

			if v525 and t89[v525] then
				t94 = t1:CopyTable(t89[v525])
				table.clear(t89[v525])
				t89[v525] = nil
			end

			for _, child in ipairs(v520:GetChildren()) do
				if child:IsA("Highlight") and child.Name ~= "PlayerAura" then
					child.Parent = nil
					table.insert(t94, child)
				end
			end

			clone = Instance.new("Highlight")
			clone.Name = "PlayerAura"
			clone.FillColor = v526
			clone.OutlineColor = v526
			clone.Parent = v520

			for v549, v550 in t91 or {} do
				clone[v549] = v550
			end

			if n38 ~= "inf" then
				local num = tonumber(n38)

				Debris:AddItem(clone, num or 10)
			end

			t89[clone] = t94

			local connection = v520.ChildAdded:Connect(function(child) -- line: 2122
				-- upvalues: clone (ref), t94 (ref)
				if not clone or not clone.Parent then
					return
				end

				if child.ClassName == "Highlight" and child.Name ~= "PlayerAura" then
					table.insert(t94, child)
				end
			end)

			if not v525 then
				local FillTransparency = clone.FillTransparency
				local OutlineTransparency = clone.OutlineTransparency

				clone.FillTransparency = 1
				clone.OutlineTransparency = 1
				TweenService:Create(clone, TweenInfo.new(1), {
					FillTransparency = FillTransparency,
					OutlineTransparency = OutlineTransparency
				}):Play()
			end

			if n38 ~= "inf" then
				local v555 = tonumber(n38) or 10

				task.delay(v555 - 1, function() -- line: 2143
					-- upvalues: connection (copy), clone (ref), v520 (copy), t94 (ref), t89 (copy), TweenService (copy)
					connection:Disconnect()

					if clone and clone.Parent then
						if v520 and v520.Parent then
							for _, v in pairs(t94) do
								if (v or v.Parent) and v.Name == "PlayerAura" then
									v.Parent = v520
								end
							end
						else
							for _, v in pairs(t94) do
								v:Destroy()
							end
						end

						table.clear(t94)
						t89[clone] = nil
						clone.Name = "goodbai"
						TweenService:Create(clone, TweenInfo.new(1), {
							FillTransparency = 1,
							OutlineTransparency = 1
						}):Play()
					end
				end)
			end

			local v556 = clone.Parent and (clone.Parent:IsA("Model") and clone.Parent.PrimaryPart or clone.Parent:IsA("BasePart") and clone.Parent)

			if v556 and v519 > 0 then
				if v519 < (v556.Position - Character.PrimaryPart.Position).Magnitude then
					clone.FillTransparency = 1
					clone.OutlineTransparency = 1
				end

				local v557 = nil

				while task.wait(0.5) and clone and clone.Parent do
					local v558 = v519 < (v556.Position - Character.PrimaryPart.Position).Magnitude

					if v557 ~= v558 then
						v557 = v558
						game.TweenService:Create(clone, tweenInfo, {
							FillTransparency = not v558 and 0.5 or 1,
							OutlineTransparency = not v558 and 0 or 1
						}):Play()
					end
				end
			end
		end
	end
end
function t1.BezierBoneTracking(_: {[any]: any}, rootPart, bones: {any}, startPoint: Vector3, controlPoint: Vector3, endPoint: Vector3, initialAlpha: number?, duration: number?)
	local self = {}
	self.StartPoint = startPoint
	self.ControlPoint = controlPoint
	self.EndPoint = endPoint
	self.Alpha = initialAlpha or 0
	self.Time = initialAlpha or 0
	self.Duration = duration or 1
	self._destroyed = false

	local numBones = #bones

	local function bezierPoint(t: number, p0: Vector3, p1: Vector3, p2: Vector3)
		local a = p0:Lerp(p1, t)
		local b = p1:Lerp(p2, t)
		return a:Lerp(b, t)
	end

	self._connection = RunService.Heartbeat:Connect(function()
		if self._destroyed then
			return
		end

		local alpha = self.Alpha or self.Time or 0
		if alpha <= 0 or numBones == 0 then
			return
		end

		for i, bone in ipairs(bones) do
			if bone and bone.Parent then
				local t = (i / numBones) * alpha
				local worldPos = bezierPoint(t, self.StartPoint, self.ControlPoint, self.EndPoint)

				local parent = bone.Parent
				local parentCFrame = (parent:IsA("Bone") and parent.TransformedWorldCFrame) or parent.CFrame
				local localCFrame = parentCFrame:ToObjectSpace(CFrame.new(worldPos))

				bone.Transform = localCFrame
			end
		end
	end)

	function self.Destroy(s)
		s._destroyed = true
		if s._connection then
			s._connection:Disconnect()
			s._connection = nil
		end
	end

	return self
end
function t1.CreateCameraOffset(_: {[any]: any}, rig, offset: Vector3, tag: string?, weight: number?)
	local value = Instance.new("Vector3Value")
	value.Name = "CameraOffset_" .. tostring(tag or "Untagged")
	value.Value = offset or Vector3.new()

	local camFolder = workspace:FindFirstChild("CameraOffsets")
	if not camFolder then
		camFolder = Instance.new("Folder")
		camFolder.Name = "CameraOffsets"
		camFolder.Parent = workspace
	end
	value.Parent = camFolder

	return value
end
function t1.ApplyUnsafeTouched(_: {[any]: any}, p91, b12: boolean?, p92: ((...any) -> ...any), n40: number) -- line: 2194
	assert(typeof(p91) == "Instance", "Bad instance, must be BasePart.")
	assert(type(p92) == "function", "Bad callback, must be function.")

	local _ = b12 or false
	local u565 = n40 or p91.Size.Magnitude * 2
	local u566 = nil
	local t96 = {
		Disconnect = function() -- line: 2203
			-- upvalues: u566 (ref)
			if u566 then
				u566:Disconnect()
				u566 = nil
			end
		end
	}

	p91.CanTouch = true
	u566 = p91.Touched:Connect(function(part) -- line: 2212
		-- upvalues: p91 (copy), u565 (ref), p92 (copy), t96 (copy)
		if (part.Position - p91.Position).Magnitude > u565 then
			return
		end

		p92(t96, part)
	end)

	return t96
end
function t1.GetAliveSurvivorCharacters(_) -- line: 2227
	-- upvalues: t1 (copy)
	local t97 = {}

	for _, child in workspace.Players.Survivors:GetChildren() do
		if t1:IsAlive(child) then
			table.insert(t97, child)
		end
	end

	return t97
end
function t1.ApplyOnTouched(_: {[any]: any}, p94, b13: boolean?, p95: ((...any) -> ...any)) -- line: 2242
	assert(typeof(p94) == "Instance", "Bad instance, must be BasePart.")
	assert(type(p95) == "function", "Bad callback, must be function.")

	local u576 = b13 or false
	local connection = nil

	connection = p94.Touched:Connect(function(part) -- line: 2248
		-- upvalues: p94 (copy), connection (ref), p95 (copy), u576 (ref)
		if not p94 or not p94.Parent then
			connection:Disconnect()

			return
		end

		p95(connection, part)

		if u576 and connection then
			connection:Disconnect()
		end
	end)

	return connection
end
function t1.RevealPlayerAuraTo(_: {[any]: any}, p96, p97, n41: number, color3: Color3?, n42: number?) -- line: 2298
	-- upvalues: Network (copy)
	if p96 and p96:IsA("Model") then
		p96 = game.Players:GetPlayerFromCharacter(p96)
	end

	Network:FireClientConnection(p96, "RevealPlayerAura", "REMOTE_EVENT", p97, n41, color3, n42)
end
function t1.RemovePlayerAuraFrom(_: {[any]: any}, p98, p99) -- line: 2309
	-- upvalues: v12 (copy), Network (copy), v11 (copy), t89 (copy), Debris (copy), TweenService (copy), t88 (copy)
	if not p98 then
		return
	end

	if v12 then
		if p99 then
			Network:FireClientConnection(p99, "RemovePlayerAura", "REMOTE_EVENT", p98)

			return
		end

		Network:FireAllClientConnection("RemovePlayerAura", "REMOTE_EVENT", p98)

		return
	end

	if v11 then
		local v587 = p98:IsA("Player") and p98.Character or p98
		local Character = game.Players.LocalPlayer.Character

		if v587 then
			local PlayerAura = v587:FindFirstChild("PlayerAura")

			if PlayerAura and tostring(Character.Parent) ~= tostring(v587.Parent) then
				local t101 = {}

				if t89[PlayerAura] then
					if v587 and v587.Parent then
						for _, v in pairs(t101) do
							if v or v.Parent then
								v.Parent = v587
							end
						end
					else
						for _, v in pairs(t101) do
							v:Destroy()
						end
					end

					table.clear(t89[PlayerAura])
					t89[PlayerAura] = nil
				end

				PlayerAura.Name = "goodbai"
				Debris:AddItem(PlayerAura, 1)
				TweenService:Create(PlayerAura, TweenInfo.new(1), {
					FillTransparency = 1,
					OutlineTransparency = 1
				}):Play()

				return
			end

			if t88[v587] then
				t88[v587]:Destroy()
				t88[v587] = nil
			end
		end
	end
end
function t1.GetClosestPlayerFromPosition(_: {[any]: any}, vector3: Vector3, t103: {[any]: any}) -- line: 2358
	-- upvalues: t1 (copy)
	local v598 = t103 or {}

	v598.MaxDistance = v598.MaxDistance or 9999
	v598.PlayerSelection = v598.PlayerSelection or "Survivors"
	v598.VerticalMultiplier = v598.VerticalMultiplier or 1

	local v599 = v598.IncludedSelection or {}

	for _, child in pairs(workspace.Players:GetChildren()) do
		if (v598.PlayerSelection == "All" or child.Name == v598.PlayerSelection) and child.Name ~= "Spectating" then
			for _, child3 in pairs(child:GetChildren()) do
				if not child3:GetAttribute("Undetectable") or v598.OverrideUndetectable or #t1:GetAliveSurvivorCharacters() <= 1 then
					table.insert(v599, child3)
				end
			end
		end
	end

	local t104 = {}

	for _, v in pairs(v599) do
		if t1:IsAlive(v) then
			local Actor = t1:GetActor(v)
			local Magnitude = (((Actor and (not not Actor.GetPivot and Actor:GetPivot()) or v.PrimaryPart.CFrame).Position - vector3) * Vector3.new(1, v598.VerticalMultiplier, 1)).Magnitude

			if Magnitude and not (Magnitude > (tonumber(v598.MaxDistance) or 999)) then
				table.insert(t104, {
					Player = v,
					Distance = Magnitude
				})
			end
		end
	end

	table.sort(t104, function(p100, p101) -- line: 2390
		return p100.Distance < p101.Distance
	end)

	if v598.ReturnTable then
		return t104
	end

	local v609 = t104[1]

	if v609 then
		return v609.Player, v609.Distance
	end
end
function t1.GetPlayerRootLookVector(_: {[any]: any}, p102) -- line: 2404
	-- upvalues: v11 (copy), Network (copy)
	if v11 or not p102 then
		return
	end

	os.clock()

	local t106 = {}
	local v613 = Network:FireClientConnection(p102, "GetLocalPosData", "REMOTE_FUNCTION")

	if v613 then
		v613:gsub("[%d%.%-e]+", function(p103) -- line: 2412
			-- upvalues: t106 (copy)
			table.insert(t106, (tonumber(p103)))
		end)
		v613 = Vector3.new(t106[4], t106[5], t106[6])
	end

	return v613 or p102.Character and (p102.Character.PrimaryPart and p102.Character.PrimaryPart.CFrame.LookVector)
end
function t1.OnPlayingStateChanged(p104: ((...any) -> ...any)) -- line: 2422
	local LocalPlayer = game.Players.LocalPlayer
	local v616 = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

	task.spawn(p104, (tostring(v616.Parent)))
	v616:GetPropertyChangedSignal("Parent"):Connect(function() -- line: 2426
		-- upvalues: p104 (copy), v616 (copy)
		p104((tostring(v616.Parent)))
	end)
end

local t107 = {}

function t1.OnPlayerAdded(p105: ((...any) -> ...any)) -- line: 2433
	-- upvalues: Players (copy), spawn (copy), t107 (copy)
	for _, player in (Players:GetPlayers()) do
		spawn(p105, player)
	end

	table.insert(t107, p105)
end

Players.PlayerAdded:Connect(function(player) -- line: 2441
	-- upvalues: t107 (copy), spawn (copy)
	for _, v622 in t107 do
		spawn(v622, player)
	end
end)

function t1.OnCharacterAdded(p106: ((...any) -> ...any)) -- line: 2447
	-- upvalues: t1 (copy)
	t1.OnPlayerAdded(function(p107) -- line: 2448
		-- upvalues: p106 (copy)
		if p107.Character then
			p106(p107.Character, p107)
		end

		p107.CharacterAdded:Connect(function() -- line: 2452
			-- upvalues: p106 (copy), p107 (copy)
			p106(p107.Character, p107)
		end)
	end)
end
function t1.ValueBaseToTable(_: {[any]: any}, p108) -- line: 2458
	local t109 = {}

	local function recurse(p109, p110) -- line: 2461
		-- upvalues: recurse (copy)
		for _, child in pairs(p109:GetChildren()) do
			local childName = child.Name

			if child:IsA("Folder") then
				p110[childName] = {}
				recurse(child, p110[childName])
			else
				p110[childName] = child.Value
			end
		end
	end

	recurse(p108, t109)

	return t109
end
function t1.ValueTableToBase(_: {[any]: any}, t111: {[any]: any}, p111, b14: boolean?) -- line: 2477
	local t112 = {
		number = "IntValue",
		boolean = "BoolValue",
		string = "StringValue"
	}
	local n43 = 0

	local function recurse(p112, p113) -- line: 2486
		-- upvalues: recurse (copy), t112 (copy), b14 (copy), n43 (ref)
		local t113 = {}

		for _, child in (p113:GetChildren()) do
			t113[child.Name] = child
		end

		for k, v in pairs(p112) do
			if k == "NonInstanced" then
				continue
			end

			if typeof(v) == "table" then
				local v712 = t113[k]

				if not v712 then
					v712 = Instance.new("Folder")
					v712.Name = k
					v712.Parent = p113
				end

				recurse(v, v712)

				continue
			end

			local v713 = t113[k]

			if not v713 then
				local v714 = t112[typeof(v)]

				if not v714 then
					warn(`[Util:ValueTableToBase | LOG]: { v714 } is not a valid datatype for { v }`)

					continue
				end

				v713 = Instance.new(v714)
				v713.Name = k
			end

			v713.Value = v
			v713.Parent = p113

			if b14 then
				n43 += 1

				if n43 >= 3 then
					n43 = 0
					task.wait()
				end
			end
		end
	end

	recurse(t111, p111)
end
function t1.EmitParticles(_, p115) -- line: 2534
	if typeof(p115) == "Instance" then
		p115 = p115:GetDescendants()
	end

	for _, v in ipairs(p115) do
		if v:IsA("ParticleEmitter") then
			local EmitCount = v:GetAttribute("EmitCount")
			local EmitDelay = v:GetAttribute("EmitDelay")
			local v641 = v:GetAttribute("EmitDuration") or (v:GetAttribute("Toggle") or not EmitCount)

			local function f() -- line: 2544
				-- upvalues: v641 (copy), v (copy), EmitCount (copy)
				if v641 then
					v.Enabled = true

					if typeof(v641) == "number" then
						task.delay(v641, function() -- line: 2549
							-- upvalues: v (copy)
							if v then
								v.Enabled = false
							end
						end)

						return
					end
				else
					v:Emit(EmitCount)
				end
			end

			if EmitDelay then
				task.delay(EmitDelay, f)
			else
				f()
			end
		end
	end
end

function t1.RoundNumber(_, value, places)
 local scale = 10 ^ (places or 0)
 return math.round(value * scale) / scale
end

return table.freeze(t1)

]====]},
{path=[====[
ReplicatedStorage/Systems/Character/Game/Sprinting]====],before="8804:37a62743:c9a3db64",after="9676:7e064cdb:4851bd72",source=[====[
local t1 = {
	timeUntilStaminaRecovers = 0,
	DefaultConfig = {
		IsSprinting = false,
		isSpeedLocked = false,
		BindsEnabled = true,
		StaminaLossDisabled = false,
		MinStamina = 0,
		MaxStamina = 100,
		SprintSpeed = 26,
		StaminaLoss = 10,
		StaminaGain = 20
	}
}
local DataHandler = require(game.ReplicatedStorage.Modules.DataHandler)
local TweenService = game:GetService("TweenService")
local Network = require(game.ReplicatedStorage.Modules.Network)

function t1.ChangeStat(_, p2, p3) -- line: 24
	-- upvalues: t1 (copy)
	if t1[p2] then
		t1[p2] = p3
	end
end
function t1.CanRegenStamina(p4) -- line: 30
	return p4.timeUntilStaminaRecovers <= 0
end
function t1.Toggle(_, p6) -- line: 34
	-- upvalues: t1 (copy), Network (copy), TweenService (copy)
	local Character = game.Players.LocalPlayer.Character
	local v12 = Character and Character:FindFirstChild("Humanoid")

	if not v12 then
		return
	end

	if t1.__currentSpeedTween then
		t1.__currentSpeedTween:Cancel()
		t1.__currentSpeedTween = nil
	end

	if t1.__currentFOVTween then
		t1.__currentFOVTween:Cancel()
		t1.__currentFOVTween = nil
	end

	if p6 then
		if not Character:GetAttribute("FootstepsMuted") then
			Network:FireServerConnection("FootSP", "UREMOTE_EVENT", 1)
		end

		t1.__currentFOVTween = TweenService:Create(t1.__FOVMultiplier, TweenInfo.new(0.75), {
			Value = 1.125
		})
		t1.__currentFOVTween:Play()

		if not t1.isSpeedLocked then
			t1.__currentSpeedTween = TweenService:Create(t1.__speedMultiplier, TweenInfo.new(0.75), {
				Value = t1.SprintSpeed / (v12:GetAttribute("BaseSpeed") or 16)
			})
			t1.__currentSpeedTween:Play()

			return
		end
	else
		t1.__currentFOVTween = TweenService:Create(t1.__FOVMultiplier, TweenInfo.new(0.75), {
			Value = 1
		})
		t1.__currentFOVTween:Play()

		if not t1.isSpeedLocked then
			t1.__currentSpeedTween = TweenService:Create(t1.__speedMultiplier, TweenInfo.new(0.75), {
				Value = 1
			})
			t1.__currentSpeedTween:Play()
		end
	end
end
function t1.Resync(_) -- line: 75
	-- upvalues: t1 (copy)
	t1:Toggle(t1.IsSprinting)
end
function t1.SetStaminaFrozen(_, source, active)
	t1.__staminaFreezeSources = t1.__staminaFreezeSources or {}
	t1.__staminaFreezeSources[source] = active and true or nil
end
function t1.SyncHeldKey(_)
	if t1.IsSprinting or not t1.CanSprint or not t1.BindsEnabled or not t1.__sprintHandler then return end
	local input = game:GetService("UserInputService")
	for _, key in ipairs(t1.__sprintKeys or {}) do
		local held = key.EnumType == Enum.KeyCode and input:IsKeyDown(key)
			or key.EnumType == Enum.UserInputType and input:IsMouseButtonPressed(key)
		if held then t1.__sprintHandler("Sprinting", Enum.UserInputState.Begin); return end
	end
end

function t1.Init(_) -- line: 80
	-- upvalues: t1 (copy), DataHandler (copy), Network (copy)
	local LocalPlayer = game.Players.LocalPlayer
	local Character = LocalPlayer.Character

	Character:WaitForChild("Humanoid")

	for k, v in pairs(t1.DefaultConfig) do
		t1[k] = v
	end

	t1.StaminaCap = nil
	t1.StaminaLossDisabled = false
	t1.__staminaFreezeSources = {}
	t1.DefaultsSet = true
	t1.__sprintedEvent = Instance.new("BindableEvent")
	t1.__staminaChangedEvent = Instance.new("BindableEvent")
	t1.__speedMultiplier = Instance.new("NumberValue")
	t1.__speedMultiplier.Value = 1
	t1.__speedMultiplier.Name = "Sprinting"
	t1.__speedMultiplier.Parent = Character:WaitForChild("SpeedMultipliers", 10)
	t1.__FOVMultiplier = Instance.new("NumberValue")
	t1.__FOVMultiplier.Value = 1
	t1.__FOVMultiplier.Name = "Sprinting"
	t1.__FOVMultiplier.Parent = Character:WaitForChild("FOVMultipliers", 10)
	t1.CanSprint = true
	t1.SprintToggled = t1.__sprintedEvent.Event
	t1.StaminaChanged = t1.__staminaChangedEvent.Event
	t1.Stamina = t1.MaxStamina
	t1.SprintToggled:Connect(function(p9) -- line: 115
		-- upvalues: t1 (copy)
		t1:Toggle(p9)
	end)
	t1.timeUntilStaminaRecovers = 0

	local function sprint(_, p11) -- line: 121
		-- upvalues: t1 (copy)
		if not t1.CanSprint or not t1.BindsEnabled then
			return
		end

		if require(game.ReplicatedStorage.Modules.Device):GetPlayerDevice() == "Mobile" then
			if p11 ~= Enum.UserInputState.Begin then
				return
			end

			p11 = t1.IsSprinting and Enum.UserInputState.End or Enum.UserInputState.Begin
		end

		if p11 == Enum.UserInputState.Begin and t1.Stamina > t1.MinStamina and not t1.IsSprinting then
			t1.IsSprinting = true
			t1.__sprintedEvent:Fire(true)

			return
		end

		if t1.IsSprinting then
			t1.IsSprinting = false
			t1.__sprintedEvent:Fire(false)

			if t1.timeUntilStaminaRecovers > 0.1 then
				t1.timeUntilStaminaRecovers = math.clamp(t1.timeUntilStaminaRecovers + 0.1, 0, 3)

				return
			end

			t1.timeUntilStaminaRecovers = 0.1
		end
	end

	task.spawn(function() -- line: 152
		-- upvalues: Character (copy), t1 (copy)
		while true do
			local dt = game["Run Service"].Heartbeat:Wait()

			if not Character.Parent then
				break
			end

			if not Character.PrimaryPart then
				return
			end

			if next(t1.__staminaFreezeSources or {}) then continue end

			if t1.IsSprinting and t1.Stamina > t1.MinStamina and Character.PrimaryPart.Velocity.Magnitude > 0.4 and t1.CanSprint and not t1.StaminaLossDisabled and Character.Parent.Name ~= "Spectating" then
				t1.timeUntilStaminaRecovers = math.clamp(t1.timeUntilStaminaRecovers + dt * 0.05, 0.2, 3)
				t1.Stamina = math.clamp(t1.Stamina - t1.StaminaLoss * dt, t1.MinStamina, t1.StaminaCap or t1.MaxStamina)
				t1.__staminaChangedEvent:Fire(t1.Stamina)

				if t1.Stamina <= t1.MinStamina then
					t1.IsSprinting = false
					t1.__sprintedEvent:Fire(false)
					t1.timeUntilStaminaRecovers = 2
					Character:SetAttribute("StaminaPenaltyActive", true)
				end

				continue
			end

			if not t1.StaminaLossDisabled and t1.IsSprinting and (not (Character.PrimaryPart.Velocity.Magnitude <= 0.4) or not (t1.Stamina < t1.MaxStamina) and (not t1.StaminaCap or not (t1.Stamina > t1.StaminaCap))) then
				continue
			end

			t1.timeUntilStaminaRecovers = math.clamp(t1.timeUntilStaminaRecovers - dt, 0, 3)

			if Character:GetAttribute("StaminaPenaltyActive") then
				if not (t1.timeUntilStaminaRecovers <= 0) then
					continue
				end

				Character:SetAttribute("StaminaPenaltyActive", nil)
			end

			if t1.timeUntilStaminaRecovers <= 0 and not Character:GetAttribute("AbilityStaminaOverride") then
				t1.Stamina = math.clamp(t1.Stamina + t1.StaminaGain * dt, t1.MinStamina, t1.StaminaCap or t1.MaxStamina)
				t1.__staminaChangedEvent:Fire(t1.Stamina)
			end
		end
	end)

	local t2 = {}
	local v21 = DataHandler:ReadPath("Settings/Keybinds")

	for _, v in pairs({
		v21.Sprinting.Value,
		v21["Sprinting~Console"].Value
	}) do
		for _, v2 in pairs(Enum.KeyCode:GetEnumItems()) do
			if v == v2.Name then
				table.insert(t2, v2)

				break
			end
		end

		for _, v3 in pairs(Enum.UserInputType:GetEnumItems()) do
			if v == v3.Name then
				table.insert(t2, v3)

				break
			end
		end
	end

	t1.__sprintHandler = sprint
	t1.__sprintKeys = t2
	game.ContextActionService:BindActionAtPriority("Sprinting", sprint, false, 10000, unpack(t2))

	if not t1.MobileButton then
		local clone = script.SprintingButton:Clone()

		clone.Parent = LocalPlayer.PlayerGui:WaitForChild("MainUI")

		local Device = require(game.ReplicatedStorage.Modules.Device)

		local function toggleButton() -- line: 236
			-- upvalues: Device (copy), clone (copy)
			clone.Visible = Device:GetPlayerDevice() == "Mobile"
		end

		clone.Visible = Device:GetPlayerDevice() == "Mobile"
		Device.Changed:Connect(toggleButton)
		t1.MobileButton = clone
	end

	if tostring(LocalPlayer.Character.Parent) == "Spectating" and t1.MobileButton then
		t1.MobileButton.AnchorPoint = Vector2.new(0, 0)
		t1.MobileButton.Position = UDim2.new(1, -250, 1, -135)
		t1.MobileButton.Size = UDim2.fromOffset(83, 83)
	end

	if t1.CurrentButtonConnection1 then
		t1.CurrentButtonConnection1:Disconnect()
	end

	t1.CurrentButtonConnection1 = t1.MobileButton.MouseButton1Down:Connect(function() -- line: 256
		-- upvalues: t1 (copy), sprint (copy)
		t1.MobileButton.ImageColor3 = Color3.new(0.75, 0.75, 0.75)
		sprint("Sprinting", Enum.UserInputState.Begin)
	end)

	if t1.CurrentButtonConnection2 then
		t1.CurrentButtonConnection2:Disconnect()
	end

	t1.CurrentButtonConnection2 = t1.MobileButton.MouseButton1Up:Connect(function() -- line: 262
		-- upvalues: t1 (copy), sprint (copy)
		t1.MobileButton.ImageColor3 = Color3.new(1, 1, 1)
		sprint("Sprinting", Enum.UserInputState.End)
	end)

	local t3 = {}

	local function toggleSprintingDisabled(p12, p13) -- line: 270
		-- upvalues: t3 (copy), t1 (copy)
		t3[p12] = p13

		local v40 = true

		for _, v in pairs(t3) do
			if v == true then
				v40 = false

				break
			end
		end

		t1.CanSprint = v40

		if not v40 and t1.IsSprinting then
			t1.IsSprinting = false
			t1.__sprintedEvent:Fire(false)
		end
	end

	Network:SetConnection("DisableSprinting", "BINDABLE_EVENT", toggleSprintingDisabled)
	Network:SetConnection("DisableSprintingSV", "REMOTE_EVENT", toggleSprintingDisabled)
	Network:SetConnection("GrantStamina", "REMOTE_EVENT", function(p14) -- line: 295
		-- upvalues: t1 (copy)
		t1.Stamina = math.min(t1.Stamina + p14, t1.MaxStamina)
	end)
	t1.Character = Character
end
function t1.Destroy(_) -- line: 304
	-- upvalues: Network (copy), t1 (copy)
	t1.__staminaFreezeSources = {}
	t1.__sprintHandler = nil
	t1.__sprintKeys = nil
	Network:RemoveConnection("DisableSprinting", "BINDABLE_EVENT")
	Network:RemoveConnection("DisableSprintingSV", "REMOTE_EVENT")
	Network:RemoveConnection("GrantStamina", "REMOTE_EVENT")
	t1.__sprintedEvent:Destroy()
	t1.__staminaChangedEvent:Destroy()
	t1.__speedMultiplier:Destroy()
	t1.__FOVMultiplier:Destroy()
end

return t1

]====]},
{path=[====[
ReplicatedStorage/Systems/Player/Networks/ActorNetwork]====],before="36927:f121c34f:588ea04a",previous2="36927:f121c34f:588ea04a",after="37477:0fa69603:3f1a6b86",source=[====[
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

]====]}
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
   assert(plan.before and (fingerprint(source)==plan.before or plan.previous and fingerprint(source)==plan.previous or plan.previous2 and fingerprint(source)==plan.previous2),"Source does not match FCTtest2 + Guest fix: "..plan.path..". Nothing changed. Apply Guest's fix first, or send this script if it was edited.")
   table.insert(pending,{target=target,plan=plan,before=source})
  end
 else
  assert(plan.before==false,"Missing target: "..plan.path..". Nothing changed.")
  table.insert(pending,{plan=plan})
 end
 assert(fingerprint(plan.source)==plan.after,"Corrupted installer text. Copy the entire Raw file again.")
end
if #pending==0 then print("[Azure FCT Port] Already applied; nothing changed.");return end
local backup=Instance.new("Folder")
backup.Name="AzureFCTPort_Backup_"..os.date("!%Y%m%d_%H%M%S")
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
 error("[Azure FCT Port] Rolled back after write failure: "..tostring(err))
end
pcall(function()game:GetService("ChangeHistoryService"):SetWaypoint("Azure FCT Port")end)
print(string.format("[Azure FCT Port] Applied %d scripts. Backups: %s. Save, then start a fresh playtest.",#pending,backup:GetFullName()))
