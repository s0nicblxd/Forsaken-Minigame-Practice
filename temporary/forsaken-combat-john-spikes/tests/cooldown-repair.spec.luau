
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

local before=[==========[
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
]==========]
local function fixture()
 fresh()
 local targets={}
 for _,service in {"ReplicatedStorage","ServerStorage"} do
  local current=game:FindFirstChild(service)
  for _,name in {"Assets","Killers","JohnDoe","Behavior","CorruptEnergyController"} do current=current:FindFirstChild(name)or child(current,name) end
  local target=child(current,"Server","ModuleScript");target.Source=before;table.insert(targets,target)
 end
 return targets
end
local function repair()
-- Retract confirmation must not restart the client cooldown. Stop Play first.
assert(game:GetService("RunService"):IsStudio() and not game:GetService("RunService"):IsRunning(),"Stop Play first.")
local before=[========[
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
]========]
local after=[========[
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
 if Server.CanRetract(a) then clear(a,false);return {Retract=true,Cooldown=0} end
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
]========]
local function find(path)
 local current=game
 for name in path:gmatch("[^/]+") do current=current and current:FindFirstChild(name) end
 return current
end
local pending={}
for _,service in {"ReplicatedStorage","ServerStorage"} do
 local path=service.."/Assets/Killers/JohnDoe/Behavior/CorruptEnergyController/Server"
 local target=assert(find(path),"Missing Corrupt Energy controller: "..path..". Nothing changed.")
 assert(target:IsA("ModuleScript"),"Unexpected target: "..path..". Nothing changed.")
 if target.Source~=after then
  assert(target.Source==before,"Corrupt Energy Server has other edits: "..path..". Nothing changed; send that module to preserve your edits.")
  table.insert(pending,{target=target,path=path})
 end
end
assert(#after<200000,"Source exceeds Studio's limit. Nothing changed.")
if #pending==0 then print("[Retract cooldown] Already repaired.");return end
local backup=Instance.new("Folder");backup.Name="JohnRetractCooldown_Backup_"..os.date("!%Y%m%d_%H%M%S");backup.Parent=game.ServerStorage
for i,item in ipairs(pending) do local saved=item.target:Clone();saved.Name=tostring(i).."_Server";saved:SetAttribute("OriginalPath",item.path);saved.Parent=backup end
local ok,err=pcall(function()for _,item in ipairs(pending) do item.target.Source=after end end)
if not ok then for _,item in ipairs(pending) do item.target.Source=before end;backup:Destroy();error("[Retract cooldown] Rolled back: "..tostring(err)) end
print("[Retract cooldown] Fixed the confirmation payload in both stores. Backup: "..backup:GetFullName()..". Save and restart Play.")

end
local function restore()
-- Undo only the targeted Retract cooldown repair. Stop Play first.
assert(game:GetService("RunService"):IsStudio() and not game:GetService("RunService"):IsRunning(),"Stop Play first.")
local expected=[========[
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
 if Server.CanRetract(a) then clear(a,false);return {Retract=true,Cooldown=0} end
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
]========]
local backups={}
for _,folder in game.ServerStorage:GetChildren() do if folder.Name:match("^JohnRetractCooldown_Backup_") then table.insert(backups,folder) end end
table.sort(backups,function(a,b)return a.Name>b.Name end)
local backup=assert(backups[1],"No Retract cooldown repair backup found.")
local pending={}
for _,saved in backup:GetChildren() do
 local current=game
 for name in saved:GetAttribute("OriginalPath"):gmatch("[^/]+") do current=current and current:FindFirstChild(name) end
 assert(current and current:IsA("ModuleScript") and current.Source==expected,"Missing or edited Corrupt Energy controller. Nothing restored.")
 table.insert(pending,{target=current,saved=saved})
end
local ok,err=pcall(function()for _,item in ipairs(pending) do item.target.Source=item.saved.Source end end)
if not ok then for _,item in ipairs(pending) do item.target.Source=expected end;error("Restore rolled back: "..tostring(err)) end
backup:Destroy()
print("[Retract cooldown] Restored the previous controller. Save and restart Play.")

end
local targets=fixture();repair()
assert(targets[1].Source==targets[2].Source and targets[1].Source~=before)
local n=#game.ServerStorage:GetChildren();repair();assert(#game.ServerStorage:GetChildren()==n)
restore();assert(targets[1].Source==before and targets[2].Source==before)
targets=fixture();failAt=writes+2
local ok=pcall(repair);assert(not ok and targets[1].Source==before and targets[2].Source==before)
print("PASS targeted cooldown repair: both controllers, repeat apply, restore, write-failure rollback")
