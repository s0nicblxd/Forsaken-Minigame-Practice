local RunService=game:GetService("RunService")
local Players=game:GetService("Players")
local Modules=game.ReplicatedStorage.Modules
local Actors=require(Modules.Actors)
local Statuses=require(Modules.Statuses)
local Util=require(Modules.Util)
local Sounds=require(Modules.Sounds)
local Network=require(Modules.Network)
local Rules=require(script.Parent.Rules)
local GameplayPolish=require(game.ReplicatedStorage.Modules.GameplayPolish)
local Server={}
local function alive(rig)
 local hum=rig and rig:FindFirstChildOfClass("Humanoid")
 return rig and rig.Parent and rig.PrimaryPart and hum and hum.Health>0
end
local function active(a) return not a.HelperDestroyed and alive(a.Rig) end
local function survivors()
 local folder=workspace:FindFirstChild("Players")
 return folder and folder:FindFirstChild("Survivors")
end
local function actorFor(rig)
 local player=Players:GetPlayerFromCharacter(rig)
 if player and Actors.CurrentActors[player] then return Actors.CurrentActors[player] end
 for _,a in pairs(Actors.CurrentActors) do if a.Rig==rig then return a end end
end
local function helpers(a)
 local n,seen=0,{}
 for _,other in pairs(Actors.CurrentActors) do
  if other~=a and other.ActorName=="Helperbot" and alive(other.Rig) and other.Rig.Parent==survivors() and not seen[other.Rig] then seen[other.Rig]=true;n+=1 end
 end
 return n
end
local function emit(a,method,...)
 if a.Player then Network:FireAllClientConnection(a.Player.Name.."PCallAllClients","REMOTE_EVENT",method,...) end
end
local function localEmit(a,method,...)
 if a.Player and a.Player:IsA("Player") then Network:FireClientConnection(a.Player,a.Player.Name.."PCallLocal","REMOTE_EVENT",method,...) end
end
local function sound(a,key,options)
 if not active(a) then return end
 local id=a.Config.Sounds and a.Config.Sounds[key]
 if not id or id=="" then return end
 options=options or {};options.Parent=options.Parent or a.Rig.PrimaryPart;options.Volume=options.Volume or .25
 local ok,result=pcall(Sounds.Play,Sounds,id,options)
 if ok then return result end
end
local function lock(a,name,on)
 a.AbilityDisablers=a.AbilityDisablers or {};a.AbilityDisablers["Helperbot"..name]=on or nil
end
local function clearCast(a)
 local cast=a.HelperCast
 if not cast then return end
 a.HelperCast=nil
 if cast.health then cast.health:Disconnect() end
 if cast.speed then cast.speed:Destroy() end
 lock(a,cast.name,false)
end
local function interrupted(a)
 local rig=a.Rig
 return rig:GetAttribute("Stunned") or rig:GetAttribute("Helpless") or rig:GetAttribute("Ragdolling") or rig:GetAttribute("AbilitiesDisabled") or rig.PrimaryPart.Anchored
end
local function charges(a,n,reward)
 local before=a.HelperCharges or 1
 a.HelperCharges=Rules.Level(n);a.Rig:SetAttribute("PulseCharges",a.HelperCharges)
 localEmit(a,"OnChargeLevelChanged",a.HelperCharges,"Pulse")
 if reward and a.HelperCharges>before and a.Player and a.Player:IsA("Player") then
  Actors:IncrementActorStats(a.Player,{Action="Leveled up Pulse",Money=2,EXP=13,KillerChance=.25})
 end
end
local function stopZone(a)
 local zone=a.HelperZone
 if not zone then return end
 a.HelperZone=nil
 if zone.loop then zone.loop:Destroy() end
 emit(a,"DestroyZoneVisual",zone.id)
 sound(a,"InspireEnd")
end
function Server.Interrupt(a)
 local cast=a.HelperCast
 if cast then
  if cast.name=="Pulse" then
   emit(a,"OnPulseInterrupted");sound(a,"PulseInterrupted")
   if a.SetCooldownOf then a:SetCooldownOf("Pulse",44) end
  end
  clearCast(a)
 end
end
function Server.Pulse(a)
 if not active(a) or a.HelperCast or interrupted(a) then return {Cancelled=true} end
 local cast={name="Pulse",ends=os.clock()+2}
 a.HelperCast=cast;lock(a,"Pulse",true)
 cast.speed=Util:CreateSpeedMultiplier(a.Player or a.Rig,.9,"HelperbotPulseWindup")
 local hum=a.Rig:FindFirstChildOfClass("Humanoid");local previous=hum.Health
 cast.health=hum.HealthChanged:Connect(function(health)
  local damaged=health<previous;previous=health
  if damaged and a.HelperCast==cast then Server.Interrupt(a) end
 end)
 emit(a,"OnPulseWindup");sound(a,"PulseWindup")
end
function Server.Inspiration(a)
 if not active(a) or a.HelperCast or a.HelperZone or interrupted(a) then return {Cancelled=true} end
 a.HelperCast={name="Inspiration",ends=os.clock()+.75}
 lock(a,"Inspiration",true)
 a.HelperCast.speed=Util:CreateSpeedMultiplier(a.Player or a.Rig,.01,"HelperbotInspireWindup")
 sound(a,"InspireWindup")
end
local function applyPulse(a,rig,level,count)
 local other=actorFor(rig)
 local duration=Rules.BuffDuration(level,count,rig~=a.Rig and other and other.ActorName=="Helperbot")
 -- Veeronica does not receive healing, but can receive Resistance.
 if not (other and (other.ActorName=="Veeronica" or other.ActorName=="Vee")) then
  Statuses:ApplyStatus(rig,"Regeneration",{Level=1,Duration=duration,AppliedFrom="HelperbotPulse"})
 end
 Statuses:ApplyStatus(rig,"Resistance",{Level=1,Duration=duration,AppliedFrom="HelperbotPulse"})
 emit(a,"OnPulseHit",rig,true)
 sound(a,"PulseHitPositive",{Parent=rig.PrimaryPart})
end
local function releasePulse(a)
 local level=a.HelperCharges or 1
 local radius=Rules.Radius(level)
 charges(a,0,false)
 emit(a,"OnPulseEmitted",radius,radius);sound(a,"Pulse")
 a.HelperWaves=a.HelperWaves or {}
 table.insert(a.HelperWaves,{origin=a.Rig.PrimaryPart.Position,radius=radius,level=level,elapsed=0,started=os.clock(),hit={},targets=0,helpers=helpers(a)})
 -- Retain the 0.75s recovery and windup slowdown without a stale timer unlocking another cast.
 local cast=a.HelperCast
 if cast.speed then cast.speed:Destroy();cast.speed=nil end
 if cast.health then cast.health:Disconnect();cast.health=nil end
 cast.recovery=true;cast.ends=os.clock()+.75
end
local function startZone(a)
 a.HelperZoneSerial=(a.HelperZoneSerial or 0)+1
 local id=tostring(a.HelperZoneSerial)
 a.HelperZone={id=id,remaining=10,last=os.clock(),elapsed=0,progress={},granted={},inside={}}
 emit(a,"CreateZoneVisual",id,16);sound(a,"Inspire")
 a.HelperZone.loop=sound(a,"InspireLoop",{Looped=true})
 if a.HelperCast.speed then a.HelperCast.speed:Destroy();a.HelperCast.speed=nil end
 a.HelperCast.recovery=true;a.HelperCast.ends=os.clock()+.75
end
local function updateZone(a,dt)
 local z=a.HelperZone
 if not z then return end
 -- Integrate only the portion of the frame within the aura's fixed lifetime.
 local now=os.clock();dt=math.min(math.max(0,now-z.last),z.remaining);z.last=now
 z.remaining-=dt;z.elapsed+=dt
 local folder=survivors();local nowInside={};local haste=Rules.Haste(helpers(a))
 if folder then for _,rig in ipairs(folder:GetChildren()) do
  if alive(rig) and (rig.PrimaryPart.Position-a.Rig.PrimaryPart.Position).Magnitude<=16 then
   nowInside[rig]=true
   -- Refresh every half-second. Self receives Haste too, excluding Inspiration.
   if z.elapsed>=.5 then Statuses:ApplyStatus(rig,"Haste",{Level=haste,Duration=2,DisabledAbilityNames={"Inspiration"},AppliedFrom="HelperbotInspiration"}) end
   if rig~=a.Rig and not z.granted[rig] then
    local progress=Rules.Progress(z.progress[rig] or 0,true,dt);z.progress[rig]=progress
    if not z.inside[rig] then
     emit(a,"InspireMeterUpdate","CharacterEnteredInspire",rig,math.max(0,progress-dt)/5,5-math.max(0,progress-dt),z.id)
     sound(a,"InspirePlayerEntered",{Parent=rig.PrimaryPart})
    end
    if progress>=5 then
     z.granted[rig]=true
     charges(a,(a.HelperCharges or 0)+1,true)
     emit(a,"InspireMeterUpdate","CharacterGaveCharge",rig,z.id)
    end
   end
  end
 end end
 for rig,progress in pairs(z.progress) do
  if not nowInside[rig] and not z.granted[rig] then
   if z.inside[rig] then
    emit(a,"InspireMeterUpdate","CharacterLeftInspire",rig,progress/5,progress/.7,z.id)
    if alive(rig) then sound(a,"InspirePlayerLeft",{Parent=rig.PrimaryPart}) end
   end
   z.progress[rig]=Rules.Progress(progress,false,dt)
   if z.progress[rig]<=0 or not alive(rig) then
    emit(a,"InspireMeterUpdate","CharacterChargeRemoved",rig,z.id)
    z.progress[rig]=nil
   end
  end
 end
 z.inside=nowInside
 if z.elapsed>=.5 then z.elapsed=0 end
 if z.remaining<=0 then stopZone(a) end
end
local function step(a,dt)
 if not active(a) then Server.Destroyed(nil,a);return end
 local cast=a.HelperCast
 if cast then
  if not cast.recovery and interrupted(a) then Server.Interrupt(a)
  elseif os.clock()>=cast.ends then
   if cast.recovery then clearCast(a)
   elseif cast.name=="Pulse" then releasePulse(a)
   else startZone(a) end
  end
 end
 for i=#a.HelperWaves,1,-1 do
  local wave=a.HelperWaves[i];wave.elapsed=os.clock()-wave.started
  local reach=math.min(wave.radius,wave.elapsed*wave.radius)
  local folder=survivors()
  if folder then for _,rig in ipairs(folder:GetChildren()) do
   if alive(rig) and not wave.hit[rig] and (rig.PrimaryPart.Position-wave.origin).Magnitude<=reach then
    wave.hit[rig]=true;applyPulse(a,rig,wave.level,wave.helpers)
    if rig~=a.Rig and actorFor(rig)then wave.targets+=1 end
   end
  end end
  if wave.elapsed>=1 then
   local money,xp=GameplayPolish.PulseReward(wave.targets)
   if money>0 then Actors:IncrementActorStats(a.Player,{Action="Pulse hit "..tostring(math.min(wave.targets,3))..(wave.targets>=3 and "+ Survivors"or " Survivor(s)"),Money=money,EXP=xp})end
   table.remove(a.HelperWaves,i)
  end
 end
 updateZone(a,dt)
 a.HelperRadarElapsed+=dt
 if a.HelperRadarElapsed>=12 then a.HelperRadarElapsed%=12;emit(a,"RadarScan") end
end
function Server.Created(_,a)
 a.HelperDestroyed=false;a.HelperConnections={};a.HelperWaves={};a.HelperRadarElapsed=0
 charges(a,1,false)
 -- FCT increments this server-owned counter for non-primary ability use. Watch actual changes rather than guessing from cooldown changes/Haste.
 local watched={}
 local function watch(rig)
  if watched[rig] or rig==a.Rig then return end
  watched[rig]=true
  table.insert(a.HelperConnections,rig:GetAttributeChangedSignal("AbilitiesUsed"):Connect(function()
   if active(a) and alive(rig) and rig.Parent==survivors() then localEmit(a,"ShowSurvivorAura",rig) end
  end))
 end
 local folder=survivors()
 if folder then for _,rig in ipairs(folder:GetChildren()) do watch(rig) end;table.insert(a.HelperConnections,folder.ChildAdded:Connect(watch)) end
 table.insert(a.HelperConnections,RunService.Heartbeat:Connect(function(dt) step(a,dt) end))
 table.insert(a.HelperConnections,a.Rig:FindFirstChildOfClass("Humanoid").Died:Connect(function() Server.Destroyed(nil,a) end))
end
function Server.Destroyed(_,a)
 if a.HelperDestroyed then return end
 a.HelperDestroyed=true
 clearCast(a);stopZone(a)
 for _,connection in ipairs(a.HelperConnections or {}) do connection:Disconnect() end
 a.HelperConnections={};a.HelperWaves={}
 emit(a,"PortCleanup")
end
function Server.OnHelpless(_,a) Server.Interrupt(a) end
Server.OnStunned=Server.OnHelpless
return Server
