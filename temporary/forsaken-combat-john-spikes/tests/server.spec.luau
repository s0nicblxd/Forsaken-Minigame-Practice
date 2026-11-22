
local time=0
local os={clock=function()return time end}
local function signal()
 local s={listeners={}}
 function s:Connect(fn)local c={Connected=true};function c:Disconnect()self.Connected=false end;table.insert(s.listeners,{fn=fn,c=c});return c end
 function s:Fire(...)for _,x in ipairs(table.clone(s.listeners)) do if x.c.Connected then x.fn(...)end end end
 return s
end
local heartbeat=signal()
local V={};V.__index=V
function V.__add(a,b)return setmetatable({X=a.X+b.X,Y=a.Y+b.Y,Z=a.Z+b.Z},V)end
function V.__sub(a,b)return setmetatable({X=a.X-b.X,Y=a.Y-b.Y,Z=a.Z-b.Z},V)end
local Vector3={new=function(x,y,z)return setmetatable({X=x,Y=y,Z=z},V)end}
local CF={};CF.__index=CF
function CF.__mul(a,b)return setmetatable({Position=a.Position+b.Position},CF)end
function CF.__add(a,b)return setmetatable({Position=a.Position+b},CF)end
function CF.__sub(a,b)return setmetatable({Position=a.Position-b},CF)end
local CFrame={new=function(x,y,z)return setmetatable({Position=type(x)=="table"and x or Vector3.new(x,y,z)},CF)end,Angles=function()return setmetatable({Position=Vector3.new(0,0,0)},CF)end}
local Instance={new=function()
 local p={}
 function p:Destroy()self.Parent=nil;self.destroyed=true end
 return p
end}
local RaycastParams={new=function()return {}end}
local Enum={RaycastFilterType={Exclude=true},EasingStyle={Linear=true,Quad=true},EasingDirection={In=true}}
local TweenInfo={new=function()return {}end}
local tweens={Create=function(_,object,_,values)return {Play=function()for k,v in pairs(values)do object[k]=v end end,Cancel=function()end}end}
local pendingDebris={}
local debris={AddItem=function(_,object,seconds)table.insert(pendingDebris,{object=object,at=time+seconds})end}
local worldFolder={Name="Survivors"}
local workspace={Players={},Map={Ingame={}},Raycast=function(_,point,direction)return {Position=Vector3.new(point.X,0,point.Z)}end}
local boxes={items={}}
function boxes:CreateHitbox(_,config)
 local b={config=config};function b:Cancel()self.cancelled=true end;table.insert(self.items,b);return b
end
local network={events={}}
function network:FireAllClientConnection(name,_,data)table.insert(self.events,{name=name,data=data})end
local util={}
function util:CreateSpeedMultiplier(_,value) local v={Value=value};function v:Destroy()self.destroyed=true end;return v end
function util:RevealPlayerAuraTo()end
local sounds={Play=function()end}
local statuses={ApplyStatus=function()end}
local actors={IncrementActorStats=function()end}
local modules={Hitboxes=boxes,Network=network,Util=util,Sounds=sounds,Statuses=statuses,Actors=actors,AchievementUtil={IncrementAchievementProgress=function()end}}
local game={ReplicatedStorage={Modules=modules}}
function game:GetService(name)
 if name=="RunService"then return {Heartbeat=heartbeat} elseif name=="TweenService"then return tweens elseif name=="Debris"then return debris end
end
local Rules=(function()
local Rules={}
function Rules.ReserveHit(cast,target,cap)
 if not cast.active then return false end
 local hits=cast.hits[target] or 0
 if hits>=cap then return false end
 cast.hits[target]=hits+1
 return true
end
function Rules.SpawnAt(index,interval) return 2+index*interval end
return Rules

end)()
local script={Parent={Rules=Rules}}
local require=function(m)return m end
local Server=(function()
local RunService=game:GetService("RunService")
local TweenService=game:GetService("TweenService")
local Debris=game:GetService("Debris")
local Modules=game.ReplicatedStorage.Modules
local Hitboxes=require(Modules.Hitboxes)
local Network=require(Modules.Network)
local Util=require(Modules.Util)
local Sounds=require(Modules.Sounds)
local Statuses=require(Modules.Statuses)
local Actors=require(Modules.Actors)
local Rules=require(script.Parent.Rules)
local Server={}
local function alive(a)
 local hum=a.Rig and a.Rig:FindFirstChildOfClass("Humanoid")
 return not a.JDCEDestroyed and a.Rig and a.Rig.Parent and a.Rig.PrimaryPart and hum and hum.Health>0
end
local function blocked(a)
 local r=a.Rig
 return r:GetAttribute("Stunned") or r:GetAttribute("Helpless") or r:GetAttribute("Ragdolling") or r:GetAttribute("AbilitiesDisabled") or r.PrimaryPart.Anchored
end
local function broadcast(a,kind,data)
 Network:FireAllClientConnection(a.Player.Name..kind,"REMOTE_EVENT",data)
end
local function sound(a,name,parent)
 local id=a.Config.Sounds and a.Config.Sounds[name]
 if id and parent then pcall(Sounds.Play,Sounds,id,{Parent=parent,Volume=.4}) end
end
function Server.CanRetract(a)
 local c=a.JDCECast
 return c and c.active and not c.casting and c.live>0 or false
end
local function refresh(a)
 if a.Rig and a.Rig.Parent then a.Rig:SetAttribute("JDCanRetract",Server.CanRetract(a)) end
end
local function release(a,c)
 if not c.casting then return end
 c.casting=false
 if c.slow then c.slow:Destroy();c.slow=nil end
 a.AbilityDisablers.JohnCorruptEnergy=nil
 if a.CurrentAbility=="CorruptEnergy" then a.CurrentAbility=nil;a.Config.StunDuration=c.previousStunDuration end
 refresh(a)
end
local function removeSpike(a,c,s,immediate)
 if not s.live then return end
 s.live=false;c.live-=1
 if s.hitbox and s.hitbox.Cancel then s.hitbox:Cancel() end
 if s.rise then s.rise:Cancel() end
 local index=table.find(a.CurrentSpikes,s.part)
 if index then table.remove(a.CurrentSpikes,index) end
 broadcast(a,"DesummonSpike",s.id)
 if s.part.Parent then
  s.part.CanCollide=false;s.part.CanTouch=false
  if immediate then s.part:Destroy()
  else
   TweenService:Create(s.part,TweenInfo.new(1,Enum.EasingStyle.Quad,Enum.EasingDirection.In),{CFrame=s.part.CFrame-Vector3.new(0,a.Config.SpikeHitboxSize.Y*2,0)}):Play()
   Debris:AddItem(s.part,1.05)
  end
 end
 refresh(a)
end
local function clear(a,immediate)
 local c=a.JDCECast
 if not c then return end
 c.active=false;release(a,c)
 for _,s in ipairs(c.spikes) do removeSpike(a,c,s,immediate) end
 a.JDCECast=nil;refresh(a)
end
local function reward(a,target)
 local hum=target:FindFirstChildOfClass("Humanoid")
 if not hum then return end
 if hum.Health>0 then
  Util:CreateSpeedMultiplier(target,1.5,"HitSpeedBonus",1.25)
  Statuses:ApplyStatus(a.Rig,"Speed",{Level=1,Duration=7})
  Util:RevealPlayerAuraTo(a.Player,target,2.5)
 end
 if target.Parent and target.Parent.Name=="Survivors" then
  Actors:IncrementActorStats(a.Player,{Action=hum.Health<=0 and "Killed a Survivor with Corrupt Energy" or "Damaged a Survivor with Corrupt Energy",RewardType=hum.Health<=0 and "DifficultKillerAction" or "EasyKillerAction"})
 end
 if hum.Health<=0 then
  local achievement=require(Modules.AchievementUtil)
  achievement:IncrementAchievementProgress(a.Player,"JohnDoeSpikes")
 end
end
local function spawnSpike(a,c,index,now)
 if not c.active or c.interrupted or not alive(a) then return end
 local params=RaycastParams.new();params.FilterType=Enum.RaycastFilterType.Exclude;params.FilterDescendantsInstances={workspace.Players}
 local point=(a:GetPivot()*CFrame.new(0,0,-a.Config.DistanceBetweenSpikes*index)).Position
 local hit=workspace:Raycast(point,Vector3.new(0,-100,0),params) or workspace:Raycast(point,Vector3.new(0,100,0),params)
 if not hit then return end
 local size=a.Config.SpikeHitboxSize
 local rotation=math.random(0,360)
 local data={Position=hit.Position,Rotation=rotation,SpikeUUID=tostring(c.serial)..":"..index}
 local part=Instance.new("Part");part.Name="SpikeCollision";part.Size=size;part.Transparency=1
 part.Anchored=true;part.CanTouch=false;part.CanCollide=true;part.CustomPhysicalProperties=a.Config.SpikeProperties
 local from=CFrame.new(hit.Position)*CFrame.Angles(0,math.rad(rotation),math.pi/2)-Vector3.new(0,size.Y,0)
 part.CFrame=from;part.Parent=workspace.Map.Ingame
 local s={part=part,id=data.SpikeUUID,live=true,expires=now+a.Config.SpikeLifetime}
 table.insert(c.spikes,s);table.insert(a.CurrentSpikes,part);c.live+=1
 s.rise=TweenService:Create(part,TweenInfo.new(.1,Enum.EasingStyle.Linear),{CFrame=from+Vector3.new(0,size.Y*2,0)})
 s.rise:Play();broadcast(a,"SpawnSpike",data)
 s.hitbox=Hitboxes:CreateHitbox(a.Player,{
  AbilityType="CorruptEnergy",IsProjectile=false,Size=size,CFrame=function()return part.CFrame end,
  Damage=a.Config.CorruptEnergyDamage,Time=.15,Knockback=5,HitMultiple=true,PredictVelocity=false,CastPoint=false,
  -- Reject before damage, block reactions, knockback, or hit callbacks. Reservation is atomic across spikes.
  HitFilter=function(target)
   return s.live and alive(a) and Rules.ReserveHit(c,target,a.Config.SpikeHitCap)
  end,
  Connections={Hit=function(target,first)
   reward(a,target)
   if first then sound(a,"Hit",a.Rig.PrimaryPart) end
  end}
 })
 refresh(a)
end
local function step(a)
 if not alive(a) then Server.Destroyed(a);return end
 local c=a.JDCECast
 if not c then return end
 local now=os.clock()
 if c.casting then
  if blocked(a) then c.interrupted=true;release(a,c)
  else
   while c.next<=a.Config.SpikeAmount and now-c.started>=Rules.SpawnAt(c.next,a.Config.DelayBetweenSpikeSummons) do
    local index=c.next;c.next+=1;spawnSpike(a,c,index,now)
   end
   if now-c.started>=math.max(3.5,Rules.SpawnAt(a.Config.SpikeAmount,a.Config.DelayBetweenSpikeSummons)+.1) then release(a,c) end
  end
 end
 for _,s in ipairs(c.spikes) do if s.live and (not s.part.Parent or now>=s.expires) then removeSpike(a,c,s,not s.part.Parent) end end
 if not c.casting and c.live==0 then c.active=false;a.JDCECast=nil;refresh(a) end
end
function Server.Cast(a)
 if not alive(a) or blocked(a) then return {Cancelled=true} end
 if Server.CanRetract(a) then clear(a,false);return {Retract=true} end
 if a.JDCECast and a.JDCECast.casting then return {Cancelled=true} end
 clear(a,true)
 a.JDCESerial=(a.JDCESerial or 0)+1
 local c={serial=a.JDCESerial,active=true,casting=true,started=os.clock(),next=1,live=0,spikes={},hits={},previousStunDuration=a.Config.StunDuration}
 a.JDCECast=c;a.AbilityDisablers=a.AbilityDisablers or {};a.AbilityDisablers.JohnCorruptEnergy=true
 a.CurrentAbility="CorruptEnergy";a.Config.StunDuration=a.Config.UnstoppableDuration
 c.slow=Util:CreateSpeedMultiplier(a.Player,.001,"JohnCorruptEnergyCast")
 sound(a,"CorruptEnergy",a.Rig.PrimaryPart);refresh(a)
 return {Retract=false}
end
function Server.Created(a)
 a.JDCEDestroyed=false;a.JDCEConnections={};a.CurrentSpikes=a.CurrentSpikes or {}
 local original=a.CanUseAbility;a.JDCEOriginalCanUse=original
 local function canUse(self,name)
  if name~="CorruptEnergy" or not Server.CanRetract(a) then return original(self,name) end
  -- Keep every ordinary lock/check; bypass only this actor's existing CE cooldown for Retract.
  local cooldown=a.Cooldowns.CorruptEnergy;a.Cooldowns.CorruptEnergy=nil
  local ok,result=pcall(original,self,name)
  a.Cooldowns.CorruptEnergy=cooldown
  if not ok then error(result) end
  return result
 end
 a.CanUseAbility=canUse;a.JDCECanUseWrapper=canUse
 table.insert(a.JDCEConnections,RunService.Heartbeat:Connect(function()step(a)end))
 table.insert(a.JDCEConnections,a.Rig:GetAttributeChangedSignal("Stunned"):Connect(function()
  if a.Rig:GetAttribute("Stunned") and a.JDCECast and a.JDCECast.casting then a.JDCECast.interrupted=true;release(a,a.JDCECast) end
 end))
 table.insert(a.JDCEConnections,a.Rig:FindFirstChildOfClass("Humanoid").Died:Connect(function()Server.Destroyed(a)end))
 refresh(a)
end
function Server.Destroyed(a)
 if a.JDCEDestroyed then return end
 a.JDCEDestroyed=true;clear(a,true)
 for _,connection in ipairs(a.JDCEConnections or {}) do connection:Disconnect() end
 a.JDCEConnections={}
 if a.CanUseAbility==a.JDCECanUseWrapper then a.CanUseAbility=a.JDCEOriginalCanUse end
end
return Server

end)()
local function actor()
 local died=signal();local hum={Health=100,Died=died}
 local signals={};local rig={Parent=true,PrimaryPart={Anchored=false,Position=Vector3.new(0,3,0)},attrs={}}
 function rig:FindFirstChildOfClass()return hum end
 function rig:GetAttribute(name)return self.attrs[name]end
 function rig:GetAttributeChangedSignal(name)signals[name]=signals[name]or signal();return signals[name]end
 function rig:SetAttribute(name,value)local old=self.attrs[name];self.attrs[name]=value;if old~=value and signals[name]then signals[name]:Fire()end end
 local a={Rig=rig,Player={Name="John"},CurrentSpikes={},AbilityDisablers={},Cooldowns={CorruptEnergy=18},Config={Sounds={},CorruptEnergyDamage=11,SpikeAmount=31,DelayBetweenSpikeSummons=.045,SpikeLifetime=14,SpikeHitCap=2,DistanceBetweenSpikes=4,SpikeHitboxSize=Vector3.new(11,5,5),UnstoppableDuration=2}}
 function a:GetPivot()return CFrame.new(0,3,0)end
 function a:CanUseAbility(name)
  if self.Cooldowns[name]or self.Rig:GetAttribute("Stunned")then return false end
  for _,v in pairs(self.AbilityDisablers)do if v then return false end end
  return true
 end
 Server.Created(a)
 return a,hum
end
local function advance(dt)
 time+=dt;heartbeat:Fire()
 for i=#pendingDebris,1,-1 do local d=pendingDebris[i];if time>=d.at then d.object:Destroy();table.remove(pendingDebris,i)end end
end
local function castAll(a)
 Server.Cast(a);advance(2)
 for i=1,32 do advance(.04501)end
 advance(.2)
end
local a,hum=actor()
Server.Cast(a);assert(a.AbilityDisablers.JohnCorruptEnergy and a.Config.StunDuration==2)
advance(1.99);assert(#a.CurrentSpikes==0)
advance(.06);assert(#a.CurrentSpikes==1)
for i=1,31 do advance(.04501)end
advance(.2)
assert(#a.CurrentSpikes==31 and #boxes.items==31 and Server.CanRetract(a))
assert(a.Config.StunDuration==nil and a.CurrentAbility==nil and not a.AbilityDisablers.JohnCorruptEnergy)
-- Cap is per cast/target, checked before damage or hit reactions, not global invincibility.
local victimHum={Health=100}
local victim={Parent=worldFolder,FindFirstChildOfClass=function()return victimHum end}
local reactions=0
for i=1,3 do
 local box=boxes.items[i]
 if box.config.HitFilter(victim) then reactions+=1;victimHum.Health-=box.config.Damage;box.config.Connections.Hit(victim,true)end
end
assert(victimHum.Health==78 and reactions==2)
-- Cooldown bypass retains every other lock, and restores the original expiry even on errors.
assert(a:CanUseAbility("CorruptEnergy") and a.Cooldowns.CorruptEnergy==18)
a.AbilityDisablers.Other=true;assert(not a:CanUseAbility("CorruptEnergy"));a.AbilityDisablers.Other=nil
a.Rig:SetAttribute("Stunned",true);assert(not a:CanUseAbility("CorruptEnergy"));a.Rig:SetAttribute("Stunned",nil)
local cast=a.JDCECast;local result=Server.Cast(a)
assert(result.Retract and not Server.CanRetract(a) and #a.CurrentSpikes==0 and a.Cooldowns.CorruptEnergy==18)
for _,box in ipairs(boxes.items)do assert(box.cancelled)end
advance(20);assert(#a.CurrentSpikes==0,"old summons returned after retraction")
-- A new cast gets its own counter and unique IDs.
castAll(a)
assert(a.JDCECast.serial~=cast.serial and a.JDCECast.hits[victim]==nil)
local first=boxes.items[32];assert(first.config.HitFilter(victim))
-- Natural expiry removes all colliders and Retract eligibility.
advance(15);assert(#a.CurrentSpikes==0 and not Server.CanRetract(a))
-- Stun cancels pending summons but leaves raised spikes until manual/natural retraction.
Server.Cast(a);advance(2.05);local count=#a.CurrentSpikes
assert(count==1)
a.Rig:SetAttribute("Stunned",true);advance(4)
assert(#a.CurrentSpikes==count and not a.JDCECast.casting)
a.Rig:SetAttribute("Stunned",nil);Server.Cast(a);assert(#a.CurrentSpikes==0)
-- Death during windup cancels all future work and restores actor methods.
local original=a.JDCEOriginalCanUse
Server.Cast(a);hum.Health=0;hum.Died:Fire();advance(5)
assert(a.JDCEDestroyed and a.CanUseAbility==original and #a.CurrentSpikes==0 and not a.JDCECast)
-- Missed raycasts do not create orphaned casts or a fake Retract state.
a,hum=actor();workspace.Raycast=function()return nil end;castAll(a)
assert(not Server.CanRetract(a)and not a.JDCECast and #a.CurrentSpikes==0)
Server.Destroyed(a)
print("PASS Corrupt Energy: 31 timed spikes, 11 damage, atomic 2-hit cap, cooldown-preserving retract/locks, unique casts, expiry, stun, death, raycast misses, method cleanup")
