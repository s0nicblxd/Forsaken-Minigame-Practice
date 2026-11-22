
local builtinTypeof=typeof
local typeof=function(v)return type(v)=="table"and v.__type or builtinTypeof(v)end
local Vector3={new=function(x,y,z)return {X=x,Y=y,Z=z}end}
local Vector3int16=Vector3
local CF={__mul=function(a,b)return a end}
local CFrame={new=function()return setmetatable({Position=Vector3.new(0,0,0)},CF)end}
local Color3={new=function()return {}end}
local Enum={PartType={Block=true},RaycastFilterType={Exclude=true},HumanoidStateType={Dead=true}}
local OverlapParams={new=function()return {}end}
local task={spawn=function(fn)fn()end,delay=function()end}
local function signal()return {Fire=function()end,Destroy=function()end}end
local actors={CurrentActors={}}
local util={IsAlive=function()return true end,CopyTable=function(_,t)return table.clone(t)end}
local damageRules={ScaleDamage=function(_,damage)return damage end}
local modules={Ragdolls={AddProfile=function()end},Util=util,AchievementUtil={},Actors=actors,Network={},Sounds={},Stats={},Statuses={},DamageRules=damageRules,Misc={Janitor={new=function()return {Add=function()end,Cleanup=function()end}end},Signal={new=signal}}}
local playerService={GetPlayerFromCharacter=function()end}
local run={IsServer=function()return true end,IsStudio=function()return true end,Heartbeat={Wait=function()return 1 end}}
local game={ReplicatedStorage={Modules=modules,CoreLoader={}}}
function game:GetService(name)if name=="ReplicatedStorage"then return self.ReplicatedStorage elseif name=="RunService"then return run elseif name=="Players"then return playerService else return {}end end
local require=function(v)return v end
local function instance(class)
 local x={__type="Instance",ClassName=class,Parent={},attributes={}}
 function x:IsA(name)return self.ClassName==name end
 function x:HasTag()return false end
 function x:GetAttribute(name)return self.attributes[name]end
 function x:SetAttribute(name,value)self.attributes[name]=value end
 function x:FindFirstChild()end
 function x:Destroy()self.Parent=nil end
 return x
end
local Instance={new=instance}
local function character()
 local model=instance("Model");local hum=instance("Humanoid");hum.Health=100;hum.Parent=model
 local root=instance("Part");root.Parent=model;root.Name="Root";root.CFrame=CFrame.new();root.Position=root.CFrame.Position
 model.PrimaryPart=root
 function model:FindFirstChildOfClass(name)if name=="Humanoid"then return hum end end
 return model,hum,root
end
local creator=character()
local victim,hum,body=character()
local workspace={GetAttribute=function()return false end,FindFirstChild=function()return {}end,GetPartsInPart=function()return {body}end}
local Hitboxes=(function()
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
        HitFilter = params.HitFilter,
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
                        -- Optional per-hitbox predicate, before damage and all victim hit reactions.
                        if config.HitFilter and not config.HitFilter(victimChar,hitboxState) then continue end
						local victimPrimaryPart = victimChar and (victimChar:IsA("Model") and victimChar.PrimaryPart)
						local rawDamage = typeof(config.Damage) == "number" and config.Damage or config.Damage(victimChar)
						local resistanceSum = 0
						local resistanceFolder = victimChar and victimChar:FindFirstChild("ResistanceMultipliers")

						for _, resistanceValue in pairs(resistanceFolder and resistanceFolder:GetChildren() or {}) do
							resistanceSum += resistanceValue.Value
						end

						local weakenedDamage = require(game.ReplicatedStorage.Modules.DamageRules).ScaleDamage(creatorChar, rawDamage)
						local finalDamage = weakenedDamage * (1 - math.min(resistanceSum - (creatorChar:GetAttribute("StrengthBuff") or 0), 100) / 100)

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

return Hitboxes

end)()
local reactions=0
actors.CurrentActors[victim]={Rig=victim,Config={},Behavior={OnHit=function()reactions+=1 end}}
local hits,absolute=0,0
local count=0
local function filter()if count>=2 then return false end;count+=1;return true end
for i=1,3 do Hitboxes:CreateHitbox(creator,{Damage=11,HitFilter=filter,CastPoint=false,HitMultiple=true,Connections={HitAbsolute=function()absolute+=1 end,Hit=function()hits+=1 end}})end
assert(hum.Health==78 and hits==2 and reactions==2 and absolute==2 and victim:GetAttribute("TimesHit")==2,"denied impact reached damage or hit reactions")
Hitboxes:CreateHitbox(creator,{Damage=11,CastPoint=false,Connections={Hit=function()hits+=1 end}})
assert(hum.Health==67 and hits==3 and reactions==3,"unfiltered attacks changed behavior")
print("PASS actual shared Hitboxes: third filtered spike rejected before damage, TimesHit, block reactions and callbacks; ordinary hitboxes still damage normally")
