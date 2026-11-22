local now=0;local os={clock=function()return now end};local timers={};local cancelled={}
local task={}
function task.delay(seconds,callback)
 local thread=coroutine.create(callback);table.insert(timers,{at=now+seconds,thread=thread});return thread
end
function task.cancel(thread)cancelled[thread]=true end
function task.defer(callback)return task.delay(0,callback)end
local function advance(seconds)
 local finish=now+seconds
 while true do
  table.sort(timers,function(a,b)return a.at<b.at end)
  if not timers[1] or timers[1].at>finish then break end
  local item=table.remove(timers,1);now=item.at
  if not cancelled[item.thread] then local ok,err=coroutine.resume(item.thread);assert(ok,err)end
 end
 now=finish
end
local function signal()return {Once=function()end,Fire=function()end}end
local function inst(class)
 local o={__instance=true,ClassName=class,Parent={Name='Killers'},attrs={},Destroying=signal()}
 function o:IsA(kind)return kind==class end
 function o:SetAttribute(key,value)self.attrs[key]=value;if self.attributeChanged then self.attributeChanged(key,value)end end
 function o:GetAttribute(key)return self.attrs[key]end
 function o:FindFirstChild(name)return self[name]end
 function o:FindFirstChildOfClass(name)return self[name]end
 return o
end
local typeofReal=typeof
local function typeof(x)return type(x)=='table' and x.__instance and 'Instance' or typeofReal(x)end
local function copy(x)local result={};for k,v in x do result[k]=type(v)=='table' and not v.__instance and copy(v) or v end;return result end
local server=true
local heartbeat={Connect=function(_,fn)local c={Connected=true,callback=fn};function c:Disconnect()self.Connected=false end;return c end}
local run={Heartbeat=heartbeat,IsServer=function()return server end,IsClient=function()return not server end}
local actors={CurrentActors={}}
local util={CopyTable=function(_,x)return copy(x)end,IsAlive=function(_,rig)return rig.Parent and rig.Humanoid and rig.Humanoid.Health>0 end}
function util:CreateSpeedMultiplier()return {Parent=true,Value=0}end
local sounds={Play=function()end,PlayVoiceline=function()end}
local network={FireClientConnection=function()end}
local modules={Actors=actors,Util=util,Sounds=sounds,Network=network,Misc={Signal={new=signal}},AchievementUtil={IncrementAchievementProgress=function()end}}
local players={GetPlayerFromCharacter=function(_,rig)return rig.player end}
local rep={Modules=modules}
local game={ReplicatedStorage=rep,Players=players,TweenService={Create=function(_,object,_,values)return {Play=function()for k,v in values do object[k]=v end end}end},Debris={AddItem=function()end}}
function game:GetService(name)if name=='RunService' then return run elseif name=='ReplicatedStorage' then return rep elseif name=='CollectionService' then return {}end end
local require=function(module)return module end
local TweenInfo={new=function()return {}end}
local Rules=(function()
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

end)()
local script={Rules=Rules}
local Stunned=(function()
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
 local actor=actorFor(status)
 -- Capture before Stunned attribute observers cancel the casting ability and clear its override.
 local override=actor and actor.Config and tonumber(actor.Config.StunDuration)
 if actor and actor.Behavior.GetStunOverride then override=actor.Behavior:GetStunOverride(actor) end
 if override and override>0 then status.Data.StunDuration=override end
 Util:GiveStackableAttribute(character,"StunnedDisabled","StunPort")
 character:SetAttribute("Stunned",true)
 if not actor then return end
 actor:DisableAbilities("Stunned",true)
 if actor.Behavior.OnStunned then actor.Behavior:OnStunned(actor,status.Data.StunDuration) end
 require(Modules.Sounds):PlayVoiceline(actor,"Stunned")
 sound(actor,"Stunned")
 override=override or (not actor.Behavior.GetStunOverride and tonumber(actor.Config.StunDuration) or nil)
 if override and override>0 then
  cancelOverride(status)
  status.UnstunThread=task.delay(override,function()
   status.UnstunThread=nil
   if not character.Parent or not character:GetAttribute("Stunned") then return end
   local statuses=require(Modules.Statuses)
   statuses:RemoveStatus(status.Player,"Stunned")
   local handled=actor.Behavior.OnUnstoppableBoost and actor.Behavior:OnUnstoppableBoost(actor)
   if not handled and not statuses:PlayerHasStatus(status.Player,"Speed") then statuses:ApplyStatus(status.Player,"Speed",{Level=1,Duration=3+Rules.CountSentinels(Actors.CurrentActors)}) end
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

end)()
local t1=util;local t28={}
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

modules.StatusEffects={FindFirstChild=function(_,name)if name=='Stunned' then return Stunned end end}
local Statuses=(function()
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
        local incomingDurationScale=1
        if v19 and v19.Behavior and v19.Behavior.GetIncomingStatusDurationMultiplier then
            incomingDurationScale=v19.Behavior:GetIncomingStatusDurationMultiplier(v19,s1,v16 and v16.Data) or 1
            if incomingDurationScale~=1 or v18.JDIncomingScaled then
                t3=Util:CopyTable(t3 or {})
                t3.Duration=(tonumber(t3.Duration) or tonumber(v16 and v16.Data and v16.Data.Duration) or 10)*incomingDurationScale
            end
        end
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
            if incomingDurationScale~=1 or v18.JDIncomingScaled then v18.TimeRequired=tonumber(v18.Data.Duration) or v18.TimeRequired end
            v18.JDIncomingScaled=incomingDurationScale~=1 or nil

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
        v18.JDIncomingScaled=incomingDurationScale~=1 or nil
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


end)()
modules.Statuses=Statuses
local function actor(class,health,parent)
 local rig=inst('Model');rig.Humanoid=inst('Humanoid');rig.Humanoid.Health=health or 100;rig.PrimaryPart=inst('Part');rig.Parent={Name=parent or 'Killers'}
 local a={Rig=rig,Player=rig,Behavior={},Config={Class=class,Sounds={}},locks={Other=true}}
 function a:DisableAbilities(key,value)self.locks[key]=value or nil end
 actors.CurrentActors[rig]=a
 return a
end

assert(Rules.Duration(0,0)==6 and Rules.Duration(1,0)==9 and Rules.Duration(3,4)==17)
local a=actor('Killer');local s1=actor('Sentinel');local s2=actor('Sentinel');local dead=actor('Sentinel',0);local spectator=actor('Sentinel',100,'Spectating')
actors.CurrentActors.Duplicate=s1
assert(Rules.CountSentinels(actors.CurrentActors)==2,'count must exclude dead, spectators and duplicate rig entries')
local status=Statuses:ApplyStatus(a.Rig,'Stunned',{Duration=3,ResonanceDuration=4})
assert(status and status.TimeRequired==3 and status.Data.Duration==3,'Sentinels must not shorten a stun')
assert(a.locks.Stunned and a.locks.Other and a.Rig:GetAttribute('StunnedDisabled'))
assert(Statuses:ApplyStatus(a.Rig,'Stunned',{Duration=3})==nil,'active stun must reject another stun')
Statuses:RemoveStatus(a.Rig,'Stunned')
assert(not a.locks.Stunned and a.locks.Other and a.Rig:GetAttribute('Stunned')==nil)
advance(13.9);assert(a.Rig:GetAttribute('StunnedDisabled'))
advance(.2);assert(a.Rig:GetAttribute('StunnedDisabled')==nil,'immunity must expire after 6+2*3+4/2')
-- Short stuns survive; the old stacking cutoff no longer removes them.
local short=Statuses:ApplyStatus(a.Rig,'Stunned',{Duration=.25})
assert(short and short.TimeRequired==.25)
Statuses:RemoveStatus(a.Rig,'Stunned')
util:GiveStackableAttribute(a.Rig,'StunnedDisabled','OtherAbility')
advance(12.1);assert(a.Rig:GetAttribute('StunnedDisabled'),'stun expiry must retain another ability immunity')
util:RemoveStackableAttribute(a.Rig,'StunnedDisabled','OtherAbility');assert(a.Rig:GetAttribute('StunnedDisabled')==nil)
-- Real helper timer replacement: a stale expiry must not clear a newer source lease.
util:GiveStackableAttribute(a.Rig,'StunnedDisabled','StunPort',6)
advance(2);util:GiveStackableAttribute(a.Rig,'StunnedDisabled','StunPort')
advance(5);assert(a.Rig:GetAttribute('StunnedDisabled'))
util:GiveStackableAttribute(a.Rig,'StunnedDisabled','StunPort',9)
advance(8.9);assert(a.Rig:GetAttribute('StunnedDisabled'));advance(.2);assert(a.Rig:GetAttribute('StunnedDisabled')==nil)
-- Character-specific overrides remain, and manual status removal cancels their deferred reward.
a.Config.StunDuration=2
local ended=0;a.Behavior.OnStunnedEnd=function()ended+=1 end
status=Statuses:ApplyStatus(a.Rig,'Stunned',{Duration=5});assert(status.Data.StunDuration==2)
Statuses:RemoveStatus(a.Rig,'Stunned');advance(2.1);assert(ended==0,'old override timer fired after status removal')
advance(12);status=Statuses:ApplyStatus(a.Rig,'Stunned',{Duration=5});advance(2.1)
assert(ended==1 and not Statuses:PlayerHasStatus(a.Rig,'Stunned'))
local dying=actor('Killer')
Statuses:ApplyStatus(dying.Rig,'Stunned',{Duration=2})
dying.Rig.Humanoid.Health=0;Statuses:RemoveStatus(dying.Rig,'Stunned')
assert(dying.Rig:GetAttribute('StunnedDisabled')==nil,'dead rigs must not retain a new immunity lease')
-- Missing animation tracks do not prevent the local movement lock.
server=false
local localStatus={Player=a.Rig,Character=a.Rig,Data={}}
Stunned.Applied(localStatus);assert(localStatus.SpeedMultiplier)
Stunned.Removed(localStatus);advance(1.1)
print('Real Statuses/Stunned/stackable helpers: unshortened stuns, timing, NPCs, overrides and independent immunity passed')

local Policy=(function()
-- John-specific Unstoppable windows. Never changes other actors' status durations.
local RunService=game:GetService("RunService")
local Actors=require(game.ReplicatedStorage.Modules.Actors)
local Statuses=require(game.ReplicatedStorage.Modules.Statuses)
local Network=require(game.ReplicatedStorage.Modules.Network)
local Controller={}
local legacyNegative={Glitched=true,Glitch=true,GlitchedOld=true,Slowness=true,Bleeding=true,Burning=true,Nausea=true,Blindness=true,Oblivious=true,Poisoned=true,PoisonedThatKillsYou=true,Helpless=true,Weakness=true,Vulnerable=true,Confusion=true,Hemmorhage=true,Hacked=true,Corrupted=true,Hallucination=true,Marked=true,Resonance=true,Atropa=true,Subspaced=true,Fatigue=true,Exhausted=true,Stunned=true,Creatures=true}
local function alive(a)
 local hum=a.Rig and a.Rig:FindFirstChildOfClass("Humanoid")
 return not a.JDUnstoppableDestroyed and a.Rig and a.Rig.Parent and hum and hum.Health>0
end
local function speed(a) return Statuses:PlayerHasStatus(a.Player,"Speed") end
local function sentinelCount()
 local n,seen=0,{}
 for _,actor in pairs(Actors.CurrentActors) do
  local rig=actor.Rig;local hum=rig and rig:FindFirstChildOfClass("Humanoid")
  if actor.Config and actor.Config.Class=="Sentinel" and rig and rig.Parent and rig.Parent.Name~="Spectating" and hum and hum.Health>0 and not seen[rig] then n+=1;seen[rig]=true end
 end
 return n
end
function Controller.BeginCorrupt(a)
 if a.JDUnstoppableDestroyed then return end
 a.JDCorruptCasting=true;a.JDCorruptWindowUntil=nil
end
function Controller.EndCorrupt(a,cancelled)
 a.JDCorruptCasting=nil
 if a.JDUnstoppableDestroyed then a.JDCorruptWindowUntil=nil;return end
 a.JDCorruptWindowUntil=not cancelled and os.clock()+(a.Config.CorruptEnergyUnstoppableLinger or 1.5) or nil
end
function Controller.GetOverride(a)
 if not alive(a) then return end
 local ability
 if a.CurrentAbility=="404Error" and a.Config.StunDuration then ability="404Error"
 elseif a.JDCorruptCasting or os.clock()<(a.JDCorruptWindowUntil or 0) then ability="CorruptEnergy" end
 a.JDUnstoppableTriggerAbility=ability
 if ability then return a.Config.UnstoppableDuration or 2 end
end
function Controller.OnStunned(a,override)
 local ability=a.JDUnstoppableTriggerAbility;a.JDUnstoppableTriggerAbility=nil
 if not override or not ability or not alive(a) then return end
 a.JDUnstoppablePending=true
 local remaining=a:IsOnCooldown(ability)
 local base=a.Config[ability.."Cooldown"]
 if type(remaining)=="number" and type(base)=="number" then a:SetCooldownOf(ability,math.min(remaining,base*.5)) end
end
local function ensureSpeed(a,remaining)
 local current=speed(a)
 if not current then
  Statuses:ApplyStatus(a.Player,"Speed",{Level=1,Duration=remaining,AppliedFrom="JohnDoeUnstoppable"})
 elseif (current.Level or 1)==1 then
  -- Preserve a longer existing Speed I; extend a shorter one without shortening its remainder.
  local oldRemaining=math.max(0,(current.TimeRequired or current.Data.Duration or 0)-(current.TimePast or 0))
  if oldRemaining<remaining then
   current.TimeRequired=(current.TimePast or 0)+remaining;current.Data.Duration=current.TimeRequired
   Network:FireClientConnection(a.Player,"StatusUpdated","REMOTE_EVENT","Speed",{TimePast=current.TimePast or 0,Level=current.Level,Duration=current.TimeRequired})
  end
 end
end
function Controller.Boost(a)
 if not a.JDUnstoppablePending then return false end
 a.JDUnstoppablePending=nil
 if not alive(a) then return true end
 local duration=(a.Config.UnstoppableSpeedBoostDuration or 3)+sentinelCount()
 a.JDUnstoppableProtectionUntil=os.clock()+duration
 ensureSpeed(a,duration)
 return true
end
function Controller.DurationMultiplier(a,name,data)
 if not alive(a) or os.clock()>=(a.JDUnstoppableProtectionUntil or 0) or not speed(a) then return 1 end
 local negative=data and data.IsNegative
 if negative==nil then negative=legacyNegative[name] end
 return negative and (a.Config.UnstoppableNegativeStatusDurationMultiplier or .5) or 1
end
function Controller.Created(a)
 if not RunService:IsServer() then return end
 a.JDUnstoppableDestroyed=false
 a.JDUnstoppableHeartbeat=RunService.Heartbeat:Connect(function()
  local remaining=(a.JDUnstoppableProtectionUntil or 0)-os.clock()
  if remaining>0 and alive(a) then ensureSpeed(a,remaining)
  elseif remaining<=0 then a.JDUnstoppableProtectionUntil=nil end
 end)
end
function Controller.Destroyed(a)
 a.JDUnstoppableDestroyed=true
 if a.JDUnstoppableHeartbeat then a.JDUnstoppableHeartbeat:Disconnect();a.JDUnstoppableHeartbeat=nil end
 a.JDCorruptCasting=nil;a.JDCorruptWindowUntil=nil;a.JDUnstoppableProtectionUntil=nil;a.JDUnstoppablePending=nil;a.JDUnstoppableTriggerAbility=nil
end
return Controller

end)()

server=true
local john=actor('Killer');john.Config.CorruptEnergyCooldown=18;john.Config.UnstoppableDuration=2
john.Config['404ErrorCooldown']=20
john.remaining={CorruptEnergy=17,['404Error']=19}
function john:IsOnCooldown(name)return self.remaining[name]end
function john:SetCooldownOf(name,value)self.remaining[name]=value end
john.Behavior.GetStunOverride=function(_,a)return Policy.GetOverride(a)end
john.Behavior.OnStunned=function(_,a,d)Policy.OnStunned(a,d)end
john.Behavior.OnUnstoppableBoost=function(_,a)return Policy.Boost(a)end
john.Behavior.GetIncomingStatusDurationMultiplier=function(_,a,n,d)return Policy.DurationMultiplier(a,n,d)end
local function effect(negative,duration)return {Data={Duration=duration or 10,MaxLevel=10,IsNegative=negative},Applied=function()end,Removed=function()end}end
local effects={Stunned=Stunned,Speed=effect(false),Slowness=effect(nil),Regeneration=effect(false),FutureDebuff=effect(true),PositiveSlowness=effect(false)}
modules.StatusEffects.FindFirstChild=function(_,name)return effects[name]end
Policy.Created(john)
Policy.BeginCorrupt(john);assert(Policy.GetOverride(john)==2)
Policy.EndCorrupt(john,false);advance(1.49);assert(Policy.GetOverride(john)==2)
advance(.02);assert(Policy.GetOverride(john)==nil,'linger expires at 1.5 seconds')
Policy.BeginCorrupt(john);Policy.EndCorrupt(john,true);assert(Policy.GetOverride(john)==nil)
Policy.BeginCorrupt(john);Policy.EndCorrupt(john,false)
john.CurrentAbility='404Error';john.Config.StunDuration=2
assert(Policy.GetOverride(john)==2 and john.JDUnstoppableTriggerAbility=='404Error')
john.CurrentAbility=nil;john.Config.StunDuration=nil
-- Simulate CE's real attribute callback clearing its override when Stunned appears.
Policy.BeginCorrupt(john);john.CurrentAbility='CorruptEnergy';john.Config.StunDuration=2
john.Rig.attributeChanged=function(key,value)if key=='Stunned' and value then Policy.EndCorrupt(john,true);john.Config.StunDuration=nil;john.CurrentAbility=nil end end
local stun=Statuses:ApplyStatus(john.Rig,'Stunned',{Duration=5})
assert(stun.Data.StunDuration==2 and john.remaining.CorruptEnergy==9,'capture survives cancellation and refunds once')
advance(1.99);assert(Statuses:PlayerHasStatus(john.Rig,'Stunned'))
advance(.02);assert(not Statuses:PlayerHasStatus(john.Rig,'Stunned'))
local sp=Statuses:PlayerHasStatus(john.Rig,'Speed');assert(sp and sp.Level==1 and sp.TimeRequired==5,'3s + two living sentinels')
local params={Duration=8,Level=2};local slow=Statuses:ApplyStatus(john.Rig,'Slowness',params)
assert(slow.TimeRequired==4 and params.Duration==8 and slow.Level==2,'halve duration, preserve input and level')
slow=Statuses:ApplyStatus(john.Rig,'Slowness',{Level=2});assert(slow.TimeRequired==5)
slow=Statuses:ApplyStatus(john.Rig,'Slowness',{Level=2});assert(slow.TimeRequired==5,'refresh must not compound halving')
assert(Statuses:ApplyStatus(john.Rig,'Regeneration',{Duration=8}).TimeRequired==8)
assert(Statuses:ApplyStatus(john.Rig,'FutureDebuff',{Duration=8}).TimeRequired==4)
assert(Policy.DurationMultiplier(john,'Slowness',{IsNegative=false})==1)
assert(Policy.DurationMultiplier(a,'Slowness',{})==1,'other actors remain unchanged')
advance(5.1)
slow=Statuses:ApplyStatus(john.Rig,'Slowness',{Level=2});assert(slow.TimeRequired==10,'refresh after protection restores default full duration')
-- Existing stronger Speed remains; policy supplies Speed I only when it ends.
Statuses:RemoveStatus(john.Rig,'Speed')
local stronger=Statuses:ApplyStatus(john.Rig,'Speed',{Level=3,Duration=1})
john.JDUnstoppablePending=true;assert(Policy.Boost(john));assert(Statuses:PlayerHasStatus(john.Rig,'Speed')==stronger and stronger.Level==3)
Statuses:RemoveStatus(john.Rig,'Speed');advance(1);john.JDUnstoppableHeartbeat.callback()
assert(Statuses:PlayerHasStatus(john.Rig,'Speed').Level==1)
local current=Statuses:PlayerHasStatus(john.Rig,'Speed');current.TimeRequired=20;current.TimePast=0
john.JDUnstoppablePending=true;Policy.Boost(john);assert(current.TimeRequired==20,'longer speed is preserved')
current.TimeRequired=1;current.TimePast=.5;john.JDUnstoppablePending=true;Policy.Boost(john)
assert(current.TimeRequired==5.5,'shorter speed remainder is extended')
john.remaining.CorruptEnergy=1;Policy.BeginCorrupt(john);Policy.GetOverride(john);Policy.OnStunned(john,2)
assert(john.remaining.CorruptEnergy==1,'refund never extends a nearly ready cooldown')
Policy.Destroyed(john);assert(not john.JDUnstoppableHeartbeat and not john.JDCorruptCasting and not john.JDUnstoppablePending)
assert(Policy.DurationMultiplier(john,'Slowness',{})==1 and Policy.GetOverride(john)==nil)
print('PASS John integration: CE cancellation race, linger, 404 priority, cooldown refunds, Speed stacking, one-time debuff scaling and cleanup')
