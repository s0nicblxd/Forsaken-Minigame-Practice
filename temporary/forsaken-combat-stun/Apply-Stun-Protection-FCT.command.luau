-- New stun stacking and immunity visuals for FCT + existing Guest/Azure/Two Time patches.
assert(game:GetService("RunService"):IsStudio() and not game:GetService("RunService"):IsRunning(),"Stop Play before applying stun protection.")
local function find(path)
 local current=game
 for part in path:gmatch("[^/]+") do current=current and current:FindFirstChild(part) end
 return current
end
local function fingerprint(source)
 local a,b=5381,0
 for i=1,#source do local byte=string.byte(source,i);a=(a*33+byte)%4294967296;b=(b*65599+byte)%4294967296 end
 return string.format("%d:%08x:%08x",#source,a,b)
end
local plans={
{path=[====[
ReplicatedStorage/Modules/StatusEffects/Stunned]====],before="4260:f8bf9701:6ec1c6d4",after="4368:96e7e0ab:a9c0801c",source=[====[
-- FCT lifecycle + UPD immunity timing. Existing combat damage behavior is preserved.
local RunService=game:GetService("RunService")
local Modules=game.ReplicatedStorage.Modules
local Actors=require(Modules.Actors)
local Util=require(Modules.Util)
local Rules=require(script.Rules)
local Stunned={Data={Duration=6,MaxLevel=1,IsNegative=true,Stackable=false,TimeStackable=false,Hidden=false}}
local function actorFor(status)
 return Actors.CurrentActors[status.Player] or Actors.CurrentActors[status.Character]
end
local function sound(actor,name)
 local id=actor and actor.Config and actor.Config.Sounds and actor.Config.Sounds[name]
 if id and actor.Rig and actor.Rig.PrimaryPart then require(Modules.Sounds):Play(id,{Parent=actor.Rig.PrimaryPart}) end
end
local function cancelOverride(status)
 local thread=status.UnstunThread;status.UnstunThread=nil
 if thread and thread~=coroutine.running() then pcall(task.cancel,thread) end
end
function Stunned.Applied(status)
 if RunService:IsClient() then
  local actor=actorFor(status)
  local animation=actor and actor.Animations and actor.Animations.Stunned
  local behavior=actor and actor.Behavior
  if behavior then
   local callback=status.Data.StunDuration and type(animation)=="table" and animation.Cancel and behavior.OnStunnedEnd or behavior.OnStunned
   if callback then callback(behavior,actor,status.Data.StunDuration) end
  end
  if animation then
   if typeof(animation)=="table" then
    if status.Data.StunDuration and animation.Cancel then animation.Cancel:Play(0)
    else
     if animation.Start then animation.Start:Play(0) end
     if animation.Loop then animation.Loop:Play(0) end
     status.StunnedAnims=animation
    end
   else animation:Play(0) end
  end
  if not status.SpeedMultiplier then status.SpeedMultiplier=Util:CreateSpeedMultiplier(status.Player,0,"Stunned") end
  return
 end
 local character=status.Character
 Util:GiveStackableAttribute(character,"StunnedDisabled","StunPort")
 character:SetAttribute("Stunned",true)
 local actor=actorFor(status)
 if not actor then return end
 actor:DisableAbilities("Stunned",true)
 if actor.Behavior.OnStunned then actor.Behavior:OnStunned(actor,status.Data.StunDuration) end
 require(Modules.Sounds):PlayVoiceline(actor,"Stunned")
 sound(actor,"Stunned")
 local override=tonumber(actor.Config.StunDuration)
 if override and override>0 then
  cancelOverride(status)
  status.UnstunThread=task.delay(override,function()
   status.UnstunThread=nil
   if not character.Parent or not character:GetAttribute("Stunned") then return end
   local statuses=require(Modules.Statuses)
   statuses:RemoveStatus(status.Player,"Stunned")
   if not statuses:PlayerHasStatus(status.Player,"Speed") then statuses:ApplyStatus(status.Player,"Speed",{Level=1,Duration=3+Rules.CountSentinels(Actors.CurrentActors)}) end
   sound(actor,"StunEnded")
   if actor.Behavior.OnStunnedEnd then actor.Behavior:OnStunnedEnd(actor) end
  end)
  status.Data.StunDuration=override
 end
end
function Stunned.Removed(status)
 cancelOverride(status)
 if status.SpeedMultiplier then
  local multiplier=status.SpeedMultiplier;status.SpeedMultiplier=nil
  task.delay(status.StunnedAnims and status.StunnedAnims.End and .6 or .25,function()
   if multiplier.Parent then
    game.TweenService:Create(multiplier,TweenInfo.new(.75),{Value=1}):Play()
    game.Debris:AddItem(multiplier,.75)
   end
  end)
 end
 if status.StunnedAnims then
  for _,name in {"Start","Loop"} do if status.StunnedAnims[name] then status.StunnedAnims[name]:Stop() end end
  if status.StunnedAnims.End then status.StunnedAnims.End:Play() end
  status.StunnedAnims=nil
 end
 if RunService:IsServer() then
  local character=status.Character
  character:SetAttribute("Stunned",nil)
  local duration=Rules.Duration(Rules.CountSentinels(Actors.CurrentActors),status.Data.ResonanceDuration)
  -- Replacing this named source cancels the old timer; unrelated immunity sources survive expiry.
  local humanoid=character:FindFirstChildOfClass("Humanoid")
  if character.Parent and humanoid and humanoid.Health>0 then Util:GiveStackableAttribute(character,"StunnedDisabled","StunPort",duration)
  else Util:RemoveStackableAttribute(character,"StunnedDisabled","StunPort") end
  local actor=actorFor(status)
  if actor then actor:DisableAbilities("Stunned",false) end
 end
end
function Stunned.Heartbeat() end
return Stunned
]====]},
{path=[====[
ReplicatedStorage/Modules/StatusEffects/Stunned/Rules]====],before=false,after="639:8632274a:3d2c183d",source=[====[
-- UPD post-stun protection; count living rigs once even when registered under multiple keys.
local Rules={}
function Rules.CountSentinels(actors)
 local count,seen=0,{}
 for _,actor in pairs(actors) do
  local rig=actor.Rig
  local humanoid=rig and rig:FindFirstChildOfClass("Humanoid")
  if actor.Config and actor.Config.Class=="Sentinel" and rig and rig.Parent and rig.Parent.Name~="Spectating" and humanoid and humanoid.Health>0 and not seen[rig] then
   seen[rig]=true;count+=1
  end
 end
 return count
end
function Rules.Duration(count,resonance)
 return 6+3*math.max(0,count)+math.max(0,tonumber(resonance) or 0)/2
end
return Rules
]====]},
{path=[====[
ReplicatedStorage/Modules/Statuses]====],before="12260:6d556870:78f3c8e3",after="11813:edbe6e36:fe6f5039",source=[====[
local t1 = {
	CurrentStatuses = {},
	StatusCounts = {}
}
local ReplicatedStorage = game:GetService("ReplicatedStorage")

game:GetService("CollectionService")

local RunService = game:GetService("RunService")
local Network = require(game.ReplicatedStorage.Modules.Network)
local Sounds = require(game.ReplicatedStorage.Modules.Sounds)
local Util = require(game.ReplicatedStorage.Modules.Util)
local Signal = require(game.ReplicatedStorage.Modules.Misc.Signal)
local StatusEffects = game.ReplicatedStorage.Modules.StatusEffects

local function statusClient(target, ...)
	if typeof(target) == "Instance" and target:IsA("Player") then
		Network:FireClientConnection(target, ...)
	end
end

function t1.ApplyStatus(_: {[any]: any}, p1, s1: string, t3: {[any]: any}) -- line: 18
	-- upvalues: RunService (copy), t1 (copy), StatusEffects (copy), Util (copy), ReplicatedStorage (copy), Sounds (copy), Network (copy)
	assert(RunService:IsServer(), "Can only apply statuses on server.")

	if typeof(p1) ~= "Instance" then return end
	t3 = t3 or {}
	local v13 = p1:IsA("Model") and (game.Players:GetPlayerFromCharacter(p1) or p1) or p1
	local v14 = v13:IsA("Model") and v13 or v13:IsA("Player") and v13.Character
	if not v14 or not v14.Parent then return end

	t1.CurrentStatuses[v13] = t1.CurrentStatuses[v13] or {}

	local v15 = StatusEffects:FindFirstChild(tostring(s1), true)
	local v16 = v15 and require(v15)
	local v17 = t1.CurrentStatuses[v13][s1] ~= nil
	local v18 = t1.CurrentStatuses[v13][s1] or v16 and Util:CopyTable(v16)

	if v18 and v14 then
		local v19 = require(ReplicatedStorage.Modules.Actors).CurrentActors[v13]
		local v20 = v19 and v19.Config.StatusData

		if v20 and v20.ExcludeApplying and table.find(v20.ExcludeApplying, s1) then
			return
		end

		if v19 and v19.Behavior and v19.Behavior[`On{ s1 }Absolute`] then
			v19.Behavior[`On{ s1 }Absolute`](v19.Behavior, v19)
		end

		if v18.Level and t3 and t3.Level and t3.Level < v18.Level and not t3.Stackable then
			return
		end

		if v14:GetAttribute(`{ s1 }Disabled`) then
			return
		end

		for k, v in pairs(t3 or {}) do
			v18.Data[k] = v
		end

		if v19 then
			Sounds:PlayVoiceline(v19, `{ s1 }Status`, {
				Priority = 5
			})
		end


		if v17 then
			if v18.Data.TimeStackable == false then
				return
			end

			if t3.TimeStackable == false then
				return
			end

			v18.TimePast = 0

			if v18.Data.Stackable then
				v18.Level = math.clamp(v18.Level + (t3 and t3.Level or 1), 1, v18.Data.MaxLevel or 99)
			elseif v18.Data.Level and v18.Data.Level > v18.Level then
				v18.Level = v18.Data.Level
			end

			if v18.Applied then
				v18:Applied()
			end

			statusClient(v13, "StatusUpdated", "REMOTE_EVENT", s1, {
				TimePast = 0,
				Level = v18.Level,
				Duration = v18.Data.Duration or v18.TimeRequired
			})

			if v19 and v19.Behavior and v19.Behavior[`On{ s1 }`] then
				v19.Behavior[`On{ s1 }`](v19.Behavior, v19)
			end

			return v18
		end

		v18.Player = v13
		v18.Character = v14
		v18.Level = v18.Data.Level or 1
		v18.AppliedFrom = t3.AppliedFrom or "None"
		v18.TimeRequired = tonumber(v18.Data.Duration) or 10
		v18.TimePast = 0

		local function __updateStatusData(t4: {[any]: any}) -- line: 128
			-- upvalues: v18 (copy), v19 (copy)
			if not t4 then
				return
			end

			if (t4.ExcludeIfAppliedFrom or "") == v18.AppliedFrom then
				return
			end

			local v62 = t4.TotalTimeMult or 0

			if v62 > 0 and v19 and v19.Hunting then
				v62 = if not v19.Hunting then v62 else 0.5
			end

			if v62 > 0 then
				local v63 = v18

				v63.TimeRequired = v63.TimeRequired * v62

				local Data = v18.Data

				Data.Duration = Data.Duration * v62
			end
		end

		if v20 and (v20.ExcludeIfAppliedFrom or "") ~= v18.AppliedFrom then
			local v27 = v20.TotalTimeMult or 0

			if v27 > 0 and v19 and v19.Hunting then
				v27 = if not v19.Hunting then v27 else 0.5
			end

			if v27 > 0 then
				v18.TimeRequired = v18.TimeRequired * v27

				local Data = v18.Data

				Data.Duration = Data.Duration * v27
			end
		end

		local PrimaryPart = v14.PrimaryPart

		if PrimaryPart and PrimaryPart.Parent then
			local v30 = Sounds:Play(v18.Data.SFX, {
				Looped = true,
				RollOffMinDistance = 16,
				RollOffMaxDistance = 48,
				Parent = PrimaryPart
			})

			if v30 then
				v30.Name = `{ s1 }StatusSFX`
				game.Debris:AddItem(v30, 30)
			end
		end

		t1.CurrentStatuses[v13][s1] = v18
		t1.StatusCounts[v13] = (t1.StatusCounts[v13] or 0) + 1
		if v18.Applied then v18:Applied() end
		if not t1.CurrentStatuses[v13] or t1.CurrentStatuses[v13][s1] ~= v18 then return end
		statusClient(v13, "StatusApplied", "REMOTE_EVENT", s1, v18, v18.Data)

		if v19 and v19.Behavior and v19.Behavior[`On{ s1 }`] then
			v19.Behavior[`On{ s1 }`](v19.Behavior, v19)
		end

		if t1:GetStatusCount(v13) >= 4 then
			require(ReplicatedStorage.Modules.AchievementUtil):IncrementAchievementProgress(v13, "LotsaStatuses")
		end

		t1.StatusApplied:Fire(v13, s1, v18, v17)

		return v18
	end
end
function t1.RemoveStatus(_, p3, p4) -- line: 186
	-- upvalues: t1 (copy), Network (copy), ReplicatedStorage (copy)
	if p3 and p3:IsA("Model") then
		p3 = game.Players:GetPlayerFromCharacter(p3) or p3
	end

	local v34 = t1.CurrentStatuses[p3] and t1.CurrentStatuses[p3][p4]

	if v34 then
		t1.CurrentStatuses[p3][p4] = nil
		t1.StatusCounts[p3] = math.max((t1.StatusCounts[p3] or 1) - 1, 0)
		if v34.Removed then
			v34:Removed()
		end

		statusClient(p3, "StatusRemoved", "REMOTE_EVENT", p4)

		local v35 = p3:IsA("Player") and p3.Character or p3
		local v36 = v35 and v35:FindFirstChild(`{ p4 }StatusSFX`, true)

		if v36 then
			game.Debris:AddItem(v36, 0.25)
			game.TweenService:Create(v36, TweenInfo.new(0.25), {
				Volume = 0
			}):Play()
		end

		local v37 = require(ReplicatedStorage.Modules.Actors).CurrentActors[p3]

		if v37 and v37.Behavior and v37.Behavior[`{ p4 }Ended`] then
			v37.Behavior[`{ p4 }Ended`](v37.Behavior, v37)
		end

	end

	if t1.CurrentStatuses[p3] and next(t1.CurrentStatuses[p3]) == nil then
		table.clear(t1.CurrentStatuses[p3])
		t1.CurrentStatuses[p3] = nil
		t1.StatusCounts[p3] = nil
	end
end
function t1.RemoveStatuses(_, p6, _) -- line: 230
	-- upvalues: t1 (copy)
	if p6 and p6:IsA("Model") then
		p6 = game.Players:GetPlayerFromCharacter(p6) or p6
	end

	for k, _ in pairs(t1.CurrentStatuses[p6] or {}) do
		t1:RemoveStatus(p6, k)
	end

	t1.CurrentStatuses[p6] = nil
	t1.StatusCounts[p6] = nil
end
function t1.GetStatusCount(_, p9) -- line: 246
	-- upvalues: t1 (copy)
	return t1.StatusCounts[p9] or -1
end
function t1.PlayerHasStatus(_, p11, p12) -- line: 250
	-- upvalues: t1 (copy)
	if typeof(p11) ~= "Instance" then return nil end
	local v48 = p11:IsA("Model") and (game.Players:GetPlayerFromCharacter(p11) or p11) or p11

	return t1.CurrentStatuses[v48] and t1.CurrentStatuses[v48][p12]
end
function t1.Start(_) -- line: 255
	-- upvalues: RunService (copy), Util (copy), t1 (copy), StatusEffects (copy), Network (copy)
	if RunService:IsServer() then
		Util.OnCharacterAdded(function(_, p15) -- line: 259
			-- upvalues: t1 (copy)
			t1:RemoveStatuses(p15)
		end)
		game.Players.PlayerRemoving:Connect(function(player) -- line: 264
			-- upvalues: t1 (copy)
			t1:RemoveStatuses(player)
		end)
		RunService.Heartbeat:Connect(function(dt: number) -- line: 268
			-- upvalues: t1 (copy)
			for v69, v70 in t1.CurrentStatuses do
				for v71, v72 in v70 do
					v72.TimePast = v72.TimePast + dt

					if not v69.Parent or not v72.Character.Parent or v72.TimePast >= v72.TimeRequired then
						t1:RemoveStatus(v69, v71)
					elseif v72.Heartbeat then
						v72:Heartbeat(dt)
					end
				end
			end
		end)
	elseif RunService:IsClient() then
		local LocalPlayer = game.Players.LocalPlayer
		local clone = script.StatusContainer:Clone()

		clone.Parent = LocalPlayer.PlayerGui.MainUI
		t1.CurrentStatuses[LocalPlayer] = {}

		local v52 = t1.CurrentStatuses[LocalPlayer]

		local function onStatusApplied(s2: string, t5: {[any]: any}, t6: {[any]: any}) -- line: 298
			-- upvalues: v52 (copy), LocalPlayer (copy), StatusEffects (copy), Util (copy), clone (copy), t1 (copy)
			local Level = t5.Level
			local Duration = t6.Duration
			local Icon = t6.Icon
			local Hidden = t6.Hidden

			if v52[s2] then
				local v80 = v52[s2]

				v80.TimePast = 0
				v80.TimeRequired = Duration
				v80.Level = Level
				v80.CurrentTimeDisplay = 123456789

				if v80.Info.Applied then
					v80.Info:Applied()
				end
			else
				local t7 = {
					TimePast = 0,
					TimeRequired = Duration,
					Level = Level,
					Player = LocalPlayer,
					Character = LocalPlayer.Character,
					Data = t6
				}
				local s2_2 = StatusEffects:FindFirstChild(s2, true)
				local v83 = Util:CopyTable(require(s2_2))

				v83.__index = v83
				t7.Info = setmetatable(t7, v83)

				if t7.Info.Applied then
					t7.Info:Applied()
				end

				t7.UI = script.StatusDisplay:Clone()
				t7.UI.Name = s2
				t7.UI.Timer.Text = Util:FormatTime(math.round(t7.TimeRequired - t7.TimePast), "Clock")
				t7.UI.Title.Text = `{ s2 } { Util:IntToRoman(t7.Level) }`
				t7.UI.IconHolder.Icon.Image = Icon or ""
				t7.UI.Visible = not Hidden
				t7.UI.Parent = clone
				v52[s2] = t7
			end

			t1.StatusApplied:FireDeferred(LocalPlayer, s2, t6, false)
		end
		local function onStatusUpdated(s3: string, t8: {[any]: any}) -- line: 345
			-- upvalues: v52 (copy), Util (copy), t1 (copy), LocalPlayer (copy)
			local v86 = v52[s3]

			if not v86 or not v86.UI then
				return
			end

			v86.TimePast = t8.TimePast or 0
			v86.TimeRequired = t8.Duration or v86.TimeRequired
			v86.Level = t8.Level or v86.Level
			v86.CurrentTimeDisplay = 123456789
			v86.UI.Timer.Text = Util:FormatTime(v86.CurrentTimeDisplay, "Clock")
			v86.UI.Title.Text = `{ s3 } { Util:IntToRoman(v86.Level) }`

			if v86.Info.Applied then
				v86.Info:Applied()
			end

			t1.StatusApplied:FireDeferred(LocalPlayer, s3, t8, true)
		end
		local function onStatusRemoved(s4: string) -- line: 368
			-- upvalues: v52 (copy)
			local v88 = v52[s4]

			if v88 then
				if v88.Info.Removed then
					v88.Info:Removed()
				end

				v88.UI:Destroy()
				v52[s4] = nil
			end
		end
		local function update(n1: number) -- line: 378
			-- upvalues: v52 (copy), Util (copy)
			for k, v in pairs(v52) do
				v.TimePast = v.TimePast + n1

				if v.Info.Heartbeat then
					v.Info:Heartbeat(n1)
				end

				local v92 = math.ceil(v.TimeRequired - v.TimePast)

				if v92 ~= v.CurrentTimeDisplay then
					v.CurrentTimeDisplay = v92
					task.defer(function() -- line: 388
						-- upvalues: v (copy), Util (copy), k (copy)
						if not v.UI or not v.UI.Parent then
							return
						end

						v.UI.Timer.Text = Util:FormatTime(v.CurrentTimeDisplay, "Clock")
						v.UI.Title.Text = `{ k } { Util:IntToRoman(v.Level) }`
					end)
				end

				if v.TimePast >= v.TimeRequired then
					if v.Info.Removed then
						v.Info:Removed()
					end

					if v.UI and v.UI.Parent then
						v.UI:Destroy()
					end

					v52[k] = nil
				end
			end
		end
		local function reset() -- line: 410
			-- upvalues: v52 (copy)
			for k, _ in pairs(v52) do
				local v95 = v52[k]

				if v95 then
					if v95.Info.Removed then
						v95.Info:Removed()
					end

					v95.UI:Destroy()
					v52[k] = nil
				end
			end
		end

		Network:SetConnection("StatusApplied", "REMOTE_EVENT", onStatusApplied)
		Network:SetConnection("StatusUpdated", "REMOTE_EVENT", onStatusUpdated)
		Network:SetConnection("StatusRemoved", "REMOTE_EVENT", onStatusRemoved)
		RunService.Heartbeat:Connect(update)
		LocalPlayer.CharacterAdded:Connect(reset)
	end

	for _, descendant in ipairs(StatusEffects:GetDescendants()) do
		if descendant:IsA("ModuleScript") and not descendant:HasTag("CannotInit") then
			local lib = require(descendant)

			if lib.Init then
				lib:Init()
			end
		end
	end
end

t1.StatusApplied = Signal.new()

return t1

]====]},
{path=[====[
ReplicatedStorage/Systems/Player/Networks/ActorNetwork]====],before="37477:0fa69603:3f1a6b86",after="37516:f3cc8c92:21adc1e7",source=[====[
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
 require(script.StunIndicator).Start()
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

]====]},
{path=[====[
ReplicatedStorage/Systems/Player/Networks/ActorNetwork/StunIndicator]====],before=false,after="5161:d463c947:ba59412e",source=[====[
-- UPD orbit/appearance timings; works for player actors and registered training bots.
local RunService=game:GetService("RunService")
local TweenService=game:GetService("TweenService")
local Debris=game:GetService("Debris")
local Indicator={}
local sounds={Start="rbxassetid://107766213132983",Loop="rbxassetid://112344506440657",End="rbxassetid://117830806605625"}
local function play(root,id,volume,looped)
 local sound=Instance.new("Sound");sound.SoundId=id;sound.Volume=volume;sound.RollOffMinDistance=10;sound.RollOffMaxDistance=80;sound.Looped=looped or false;sound.Parent=root;sound:Play()
 if not looped then Debris:AddItem(sound,15) end
 return sound
end
function Indicator.Attach(rig)
 if not rig or not rig.PrimaryPart then return function()end end
 local root=rig.PrimaryPart
 local humanoid=rig:FindFirstChildOfClass("Humanoid")
 local template=game.ReplicatedStorage.Assets.Instances:FindFirstChild("StunProtectionVFX")
 if not template then return function()end end
 local connections={};local holder,loop,render
 local generation=0;local destroyed=false
 local function cleanup(withSound)
  generation+=1
  if loop then loop:Destroy();loop=nil end
  if render then render:Disconnect();render=nil end
  local old=holder;holder=nil
  if old then
   if withSound and root.Parent then play(root,sounds.End,.4) end
   for _,part in old:GetChildren() do TweenService:Create(part,TweenInfo.new(.25,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Transparency=1}):Play() end
   Debris:AddItem(old,.25)
  end
 end
 local function destroy()
  if destroyed then return end
  destroyed=true
  for _,connection in connections do connection:Disconnect() end
  cleanup(false)
 end
 local function update()
  local enabled=not destroyed and rig.Parent and root.Parent and humanoid and humanoid.Health>0 and rig:GetAttribute("StunnedDisabled") and rig:GetAttribute("StunnedImmunityHidden")==nil
  if not enabled then cleanup(true);return end
  if holder then return end
  generation+=1;local token=generation
  holder=Instance.new("Folder");holder.Name=rig.Name.."StunProtectionVFX"
  holder.Parent=workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Ingame") or workspace
  local folder=holder;local parts,echoes={},{}
  loop=play(root,sounds.Loop,.3,true)
  local function position(index)
   local center=root.Position+Vector3.new(0,1.15,0)
   local angle=time()*.25*math.pi*2+(index-1)*math.pi*2/3
   local point=center+Vector3.new(math.cos(angle)*4,0,math.sin(angle)*4)
   return CFrame.lookAt(point,point+(point-center).Unit)*CFrame.Angles(0,0,time()*.1*math.pi*2)
  end
  for i=1,3 do task.delay((i-1)*.35,function()
   if destroyed or token~=generation or holder~=folder or not folder.Parent or not root.Parent then return end
   play(root,sounds.Start,.45)
   local part=template:Clone();part.Anchored=true;part.CanCollide=false;part.CanQuery=false;part.CanTouch=false;part.CFrame=position(i);part.Parent=folder;parts[i]=part
   local echo=part:Clone();echo.Name="Visuals";echo.Parent=folder;echoes[i]=echo
   TweenService:Create(echo,TweenInfo.new(.75,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{Transparency=1,Size=echo.Size*1.5}):Play();Debris:AddItem(echo,.75)
  end)end
  render=RunService.RenderStepped:Connect(function()
   if destroyed or not rig.Parent or not root.Parent or humanoid.Health<=0 then cleanup(false);return end
   for i,part in parts do if part.Parent then part.CFrame=position(i) end end
   for i,part in echoes do if part.Parent then part.CFrame=position(i) end end
  end)
 end
 table.insert(connections,rig:GetAttributeChangedSignal("StunnedDisabled"):Connect(update))
 table.insert(connections,rig:GetAttributeChangedSignal("StunnedImmunityHidden"):Connect(update))
 table.insert(connections,rig.AncestryChanged:Connect(function()if not rig:IsDescendantOf(workspace)then destroy()end end))
 if humanoid then table.insert(connections,humanoid.Died:Connect(destroy)) end
 update()
 return destroy
end
local started=false
function Indicator.Start()
 if started then return end
 started=true
 local teams=workspace:WaitForChild("Players")
 local active,pending,watched={},{},{}
 local function remove(rig)
  pending[rig]=nil
  if active[rig] then active[rig]();active[rig]=nil end
 end
 local function add(rig)
  if not rig:IsA("Model") or active[rig] or pending[rig] then return end
  local token={};pending[rig]=token
  local attempts=0
  local function ready()
   if pending[rig]~=token then return end
   if not rig.Parent or rig.Parent.Parent~=teams then remove(rig);return end
   if rig.PrimaryPart and rig:FindFirstChildOfClass("Humanoid") then
    pending[rig]=nil;active[rig]=Indicator.Attach(rig);return
   end
   attempts+=1
   if attempts<100 then task.delay(.1,ready) else pending[rig]=nil end
  end
  ready()
 end
 local function team(folder)
  if watched[folder] or (folder.Name~="Killers" and folder.Name~="Survivors") then return end
  watched[folder]=true
  folder.ChildAdded:Connect(add);folder.ChildRemoved:Connect(remove)
  for _,rig in folder:GetChildren() do add(rig) end
 end
 teams.ChildAdded:Connect(team)
 for _,folder in teams:GetChildren() do team(folder) end
end
return Indicator
]====]}
}
local pending={}
for _,plan in plans do
 assert(#plan.source<200000 and fingerprint(plan.source)==plan.after,"Incomplete installer source: "..plan.path..". Nothing changed.")
 local target=find(plan.path)
 if target then
  assert(target:IsA("ModuleScript"),"Expected ModuleScript at "..plan.path..". Nothing changed.")
  if fingerprint(target.Source)~=plan.after then
   assert(plan.before and fingerprint(target.Source)==plan.before,"Edited or older source at "..plan.path..". Nothing changed; this patch expects the current Guest/Azure compatibility fixes.")
   table.insert(pending,{target=target,before=target.Source,plan=plan})
  end
 else
  assert(plan.before==false and find(plan.path:match("^(.*)/[^/]+$")),"Missing expected parent/module: "..plan.path..". Nothing changed.")
  table.insert(pending,{plan=plan})
 end
end
local assetPath="ReplicatedStorage/Assets/Instances/StunProtectionVFX"
local assetParent=assert(find("ReplicatedStorage/Assets/Instances"),"Missing FCT Instances folder. Nothing changed.")
local oldAsset=find(assetPath)
if #pending==0 and oldAsset and oldAsset:GetAttribute("StunPortVersion")=="1.0.2" then print("[Stun Protection Port] Already applied.");return end
local template
local candidate=oldAsset or workspace:FindFirstChild("StunProtectionVFX",true)
if candidate and candidate:IsA("MeshPart") and candidate.MeshId:match("%d+")=="76640378318129" then template=candidate:Clone() end
if not template then
 local ok,result=pcall(function()
  return game:GetService("AssetService"):CreateMeshPartAsync(Content.fromUri("rbxassetid://76640378318129"),{CollisionFidelity=Enum.CollisionFidelity.Box,RenderFidelity=Enum.RenderFidelity.Automatic})
 end)
 if not ok then
  ok,result=pcall(function()return game:GetService("InsertService"):CreateMeshPartAsync("rbxassetid://76640378318129",Enum.CollisionFidelity.Box,Enum.RenderFidelity.Automatic)end)
 end
 assert(ok and typeof(result)=="Instance" and result:IsA("MeshPart"),"Mesh could not load. Import StunProtectionVFX.rbxmx into ReplicatedStorage.Assets.Instances, then run again. Nothing changed. "..tostring(result))
 template=result
end
-- TexturePack is a protected serialized property. An imported .rbxmx retains it through cloning.
local hasImportedAppearance=template:FindFirstChildOfClass("SurfaceAppearance")~=nil
local ok,err=pcall(function()
 template.Name="StunProtectionVFX";template.Color=Color3.fromRGB(163,162,165);template.Size=Vector3.new(3.20400953,3.20400953,.604846478)
 template.Anchored=true;template.CanCollide=false;template.CanQuery=false;template.CanTouch=false;template.Transparency=0
 template:SetAttribute("StunPortVersion","1.0.2")
 template:SetAttribute("StunMaterialRepairVersion","1.0.2")
 template:SetAttribute("EmissiveMaskAsset","rbxassetid://88194642418565")
 template:SetAttribute("OriginalTexturePack","rbxassetid://74597329653279")
 template:SetAttribute("PackedMaterialImported",false)
 template:SetAttribute("SourceTemplateImported",hasImportedAppearance)
 template:SetAttribute("MaterialCompiledFromMaps",true)
 template.TextureID="rbxassetid://128651191436151"
 local failed={}
 game:GetService("ContentProvider"):PreloadAsync({"rbxassetid://128651191436151","rbxassetid://88194642418565"},function(id,status)
  if status~=Enum.AssetFetchStatus.Success then table.insert(failed,tostring(id).." ("..tostring(status)..")") end
 end)
 assert(#failed==0,"Required material image could not load: "..table.concat(failed,", "))
 local appearance=game:GetService("AssetService"):CreateSurfaceAppearanceAsync({
  ColorMap=Content.fromUri("rbxassetid://128651191436151"),
  EmissiveMask=Content.fromUri("rbxassetid://88194642418565")
 })
 assert(appearance and appearance:IsA("SurfaceAppearance"),"Roblox did not return a compiled SurfaceAppearance.")
 appearance.Name="SurfaceAppearance";appearance.AlphaMode=Enum.AlphaMode.Transparency
 appearance.EmissiveTint=Color3.fromRGB(0,79,255);appearance.EmissiveStrength=6.28;appearance.Color=Color3.new(1,1,1)
 for _,old in template:GetChildren() do if old:IsA("SurfaceAppearance") then old:Destroy() end end
 appearance.Parent=template
end)
if not ok then template:Destroy();error("Could not prepare the visual template. Nothing changed: "..tostring(err))end
local backup=Instance.new("Folder");backup.Name="StunProtectionPort_Backup_"..os.date("!%Y%m%d_%H%M%S");backup.Parent=game.ServerStorage
for i,item in pending do
 local saved=item.target and item.target:Clone() or Instance.new("Folder")
 saved.Name=string.format("%02d_%s",i,item.plan.path:match("[^/]+$"));saved:SetAttribute("OriginalPath",item.plan.path)
 saved:SetAttribute("WasCreated",not item.target);saved:SetAttribute("InstalledFingerprint",item.plan.after);saved.Parent=backup
end
local savedAsset=oldAsset and oldAsset:Clone() or Instance.new("Folder")
savedAsset.Name="VisualTemplate";savedAsset:SetAttribute("OriginalPath",assetPath);savedAsset:SetAttribute("WasCreated",not oldAsset);savedAsset:SetAttribute("IsVisualTemplate",true);savedAsset.Parent=backup
ok,err=pcall(function()
 for _,item in pending do
  if not item.target then
   item.target=Instance.new("ModuleScript");item.target.Name=item.plan.path:match("[^/]+$");item.target.Parent=find(item.plan.path:match("^(.*)/[^/]+$"))
  end
  item.target.Source=item.plan.source
 end
 if oldAsset then oldAsset.Parent=nil end
 template.Parent=assetParent
end)
if not ok then
 for i=#pending,1,-1 do local item=pending[i];if item.before then item.target.Source=item.before elseif item.target then item.target:Destroy() end end
 template:Destroy();if oldAsset then oldAsset.Parent=assetParent end;backup:Destroy()
 error("[Stun Protection Port] Rolled back after write failure: "..tostring(err))
end
if oldAsset then oldAsset:Destroy()end
pcall(function()game:GetService("ChangeHistoryService"):SetWaypoint("Stun Protection Port")end)
print("[Stun Protection Port] Rendered material compiled from uploaded colour map + original emissive mask.")
print("[Stun Protection Port] Applied "..#pending.." modules and visual template. Backup: "..backup:GetFullName()..". Save, then start a fresh playtest.")
