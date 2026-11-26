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
function t1.ApplyDamage(_: {[any]: any}, p26, n4: number, n5: number?, damageSource: Instance?) -- line: 391
	-- upvalues: t1 (copy)
	local AchievementUtil = require(game.ReplicatedStorage.Modules.AchievementUtil)
	local Actors = require(game.ReplicatedStorage.Modules.Actors)
	local Humanoid = p26:FindFirstChild("Humanoid")
	local num = tonumber(n4)
	if num and damageSource then num = require(game.ReplicatedStorage.Modules.DamageRules).ScaleDamage(damageSource, num) end

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
			KillerChance = 1
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
    if s23 == "KillerChance" then return end
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

