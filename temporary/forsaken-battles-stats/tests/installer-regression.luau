
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

local nativeTypeof=typeof
local function typeof(value)if type(value)=="table"and value._props then return "Instance"end;return nativeTypeof(value)end
local function signal()
 local entries={}
 return {Connect=function(_,callback)
  local object={Active=true};function object:Disconnect()self.Active=false end
  table.insert(entries,{object,callback});return object
 end,Fire=function(_,...)
  for _,entry in table.clone(entries)do if entry[1].Active then entry[2](...)end end
 end}
end
function Methods:WaitForChild(name)return self:FindFirstChild(name)end

local sourceData={
{path=[========[
ReplicatedStorage/Assets/Survivors/Builderman/Behavior/Server]========],source=[========[
local RunService=game:GetService("RunService")
local Debris=game:GetService("Debris")
local Modules=game.ReplicatedStorage.Modules
local Actors=require(Modules.Actors)
local Util=require(Modules.Util)
local Statuses=require(Modules.Statuses)
local Sounds=require(Modules.Sounds)
local Network=require(Modules.Network)
local Rules=require(script.Parent.Rules)
local Server={}
local buildings={}
local function clock()return workspace:GetServerTimeNow()end
local function alive(rig)
 local hum=rig and rig:FindFirstChildOfClass("Humanoid")
 return rig and rig.Parent and rig.PrimaryPart and hum and hum.Health>0
end
local function active(a)return not a.BuilderDestroyed and alive(a.Rig)end
local function emit(a,name,...)
 if a.Player and a.Player:IsA("Player")then Network:FireClientConnection(a.Player,a.Player.Name..name,"REMOTE_EVENT",...)end
end
local function broadcast(a,name,...)
 if a.Player then Network:FireAllClientConnection(a.Player.Name..name,"REMOTE_EVENT",...)end
end
local function sound(a,key,part,loop)
 local id=a.Config.Sounds and a.Config.Sounds[key]
 if not id or id==""then return end
 local ok,result=pcall(Sounds.Play,Sounds,id,{Parent=part,Looped=loop or false})
 if ok then return result end
end
local function track(a,state,name)
 local id=a.Config[state.kind.."Animations"]and a.Config[state.kind.."Animations"][name]
 if not id then return end
 local ok,result=pcall(Util.LoadAnimationFromID,Util,state.model,id)
 if ok and result then pcall(function()result.Looped=name=="Idle"or name=="CarryIdle"or name=="CarryWalk";result:Play(.1)end);return result end
end
local function stopTrack(value)if value then pcall(function()value:Stop(.1)end)end end
local function killerDamage(rig)
 local stamp=rig:GetAttribute("RecentAttackerTime")
 if type(stamp)~="number"or math.abs(os.clock()-stamp)>.25 then return false end
 local name=rig:GetAttribute("RecentAttacker")
 for _,actor in Actors.CurrentActors do
  if actor.Rig and actor.Rig.Parent==workspace.Players.Killers and (tostring(actor.Player)==name or actor.Rig.Name==name)then return true end
 end
 return false
end
local function count(kind)
 local n=0
 for _,state in buildings do if state.kind==kind and state.phase=="active"and state.model.Parent then n+=1 end end
 return n
end
local function builders()
 local n=0
 for _,a in Actors.CurrentActors do if a.ActorName=="Builderman"and a.Rig.Parent==workspace.Players.Survivors and alive(a.Rig)then n+=1 end end
 return n
end
local function setState(state,phase)
 state.phase=phase
 local m=state.model
 m:SetAttribute("Carrying",phase=="carry")
 m:SetAttribute("Constructed",phase=="active"or phase=="carry")
 m:SetAttribute("Disabled",phase~="active")
 for _,object in m:GetDescendants()do
  if object:IsA("BasePart")then object.Anchored=phase~="carry"and object==m.PrimaryPart;object.Massless=phase=="carry"or object:GetAttribute("BuilderOriginalMassless")==true;object.CanCollide=phase=="active"and object:GetAttribute("BuilderOriginalCollide")==true
  elseif object:IsA("ParticleEmitter")or object:IsA("Light")then object.Enabled=phase=="active"and object.Name~="Shoot"end
 end
end
local function tools(a,show)
 for _,object in a.Rig:GetChildren()do if object:IsA("BasePart")and(object.Name:find("Hammer")or object.Name:find("Wrench"))then object.Transparency=show and 0 or 1 end end
end
local function result(a,value)
 local old=a.Rig:FindFirstChild("Result");if old then old:Destroy()end
 local object=Instance.new("StringValue");object.Name="Result";object.Value=value;object.Parent=a.Rig;Debris:AddItem(object,2)
end
local function unlockCast(a)
 if a.BuilderCastSpeed then a.BuilderCastSpeed:Destroy();a.BuilderCastSpeed=nil end
 a:DisableAbilities("BuildermanConstruct",false)
 a.Rig:SetAttribute("PlacementRadius",nil)
 tools(a,false)
 if active(a)and a.ChangeExpression then a:ChangeExpression("Default")end
end
local function unlockPickup(a)
 a.BuilderPickupUntil=nil
 if a.BuilderPickupSpeed then a.BuilderPickupSpeed:Destroy();a.BuilderPickupSpeed=nil end
 a:DisableAbilities("BuildermanPickup",false)
end
local function clearCarry(a)
 unlockPickup(a)
 local carried=a.CarryingBuilding
 if carried and carried.weld then carried.weld:Destroy();carried.weld=nil end
 a.CarryingBuilding=nil
 if a.BuilderCarrySpeed then a.BuilderCarrySpeed:Destroy();a.BuilderCarrySpeed=nil end
 if a.Rig then a.Rig:SetAttribute("BuildermanCarrying",nil)end
 emit(a,"ForceDropBuilding")
 if a.Player and a.Player:IsA("Player")then Network:FireClientConnection(a.Player,"DisableSprintingSV","REMOTE_EVENT","CarryingBuilding",false)end
end
local function unlockPlacement(a,state)
 if state and a.BuilderPlacing~=state then return end
 a.BuilderPlacing=nil
 if a.BuilderPlaceSpeed then a.BuilderPlaceSpeed:Destroy();a.BuilderPlaceSpeed=nil end
 a:DisableAbilities("BuildermanPlacement",false)
 if a.Player and a.Player:IsA("Player")then Network:FireClientConnection(a.Player,"DisableSprintingSV","REMOTE_EVENT","BuildermanPlacement",false)end
end
local function reveal(a,state)
 if state.revealed then return end
 state.revealed=true
 for part,transparency in state.transparencies do
  if part.Parent then part.Transparency=transparency;part.CanQuery=true end
 end
 stopTrack(state.animation);state.animation=track(a,state,"Construction")
end
local function destroy(a,state,killer)
 if not state or state.phase=="destroyed"then return end
 if a.BuilderCast==state then a.BuilderCast=nil;unlockCast(a);result(a,"failed")end
 if a.BuilderPlacing==state then unlockPlacement(a,state)end
 if a.CarryingBuilding==state then clearCarry(a)end
 setState(state,"destroyed")
 state.model:SetAttribute("Destroyed",true)
 if state.health then state.health:Disconnect()end
 stopTrack(state.animation)
 if state.loop then state.loop:Destroy();state.loop=nil end
 buildings[state.model]=nil
 if a.Buildings[state.kind]==state then a.Buildings[state.kind]=nil end
 a.DisabledAbilities[state.kind]=nil
 emit(a,"UpdateBuildingAbilityLock",state.kind,"recentactivity",false)
 broadcast(a,"ReplicateDestroyedBuildingAsync",state.kind)
 if killer and active(a)then
  a:SetCooldownOf(state.kind,a.Config[state.kind.."DestroyedCooldown"])
  if a.Player and a.Player:IsA("Player")then
   Actors:IncrementActorStats(a.Player,{Action=state.kind.." was destroyed",RewardType="Survivalist"})
   local value=state.model:GetAttribute(state.kind=="Sentry"and "DamageDealt"or "TotalHealed")or 0
   local points=Rules.Points(state.kind,value)
   if points>0 then Actors:IncrementActorStats(a.Player,{Action=state.kind.." contribution",Money=points,EXP=math.ceil(points*.5)})end
  end
 end
 sound(a,state.kind.."Destroyed",state.model.PrimaryPart)
 for _,part in state.model:GetDescendants()do if part:IsA("BasePart")then part.CanCollide=false;part.CanQuery=false;part.Transparency=1 end end
 Debris:AddItem(state.model,2)
end
local function requestedFacing(a,frame)
 local root=a.Rig.PrimaryPart
 if typeof(frame)~="CFrame"then return root.CFrame end
 for _,value in {frame:GetComponents()}do if value~=value or math.abs(value)==math.huge then return root.CFrame end end
 if (frame.Position-root.Position).Magnitude>6 then return root.CFrame end
 local look=Vector3.new(frame.LookVector.X,0,frame.LookVector.Z)
 if look.Magnitude<.01 then return root.CFrame end
 return CFrame.lookAt(frame.Position,frame.Position+look)
end
local function placement(a,kind,ignore,frame)
 local root=a.Rig.PrimaryPart
 local facing=frame or root.CFrame
 local target=facing*CFrame.new(0,0,-a.Config[kind.."PositionOffset"])
 local params=RaycastParams.new();params.FilterType=Enum.RaycastFilterType.Exclude;params.RespectCanCollide=true
 params.FilterDescendantsInstances={workspace.Players,ignore or a.Rig}
 local floor=workspace:Raycast(target.Position+Vector3.new(0,1,0),Vector3.new(0,-6,0),params)
 if not floor or floor.Normal.Y<.65 then return nil,"midair"end
 if floor.Instance.Name=="Conveyor"then return nil,"collision"end
 if workspace:Raycast(facing.Position,target.Position-facing.Position,params)then return nil,"facingWall"end
 for _,state in buildings do
  if state.model~=ignore and state.phase~="destroyed"and state.phase~="carry"and state.model.Parent then
   local radius=a.Config[state.kind.."PlacementRadius"]/2
   if(target.Position-state.model.PrimaryPart.Position).Magnitude<=radius then return nil,"tooClose"end
  end
 end
 local overlap=OverlapParams.new();overlap.FilterType=Enum.RaycastFilterType.Exclude;overlap.RespectCanCollide=true
 overlap.FilterDescendantsInstances={workspace.Players,ignore or a.Rig}
 for _,part in workspace:GetPartBoundsInBox(CFrame.new(target.Position.X,floor.Position.Y+1.75,target.Position.Z),Vector3.new(2.5,2.5,2.5),overlap)do
  if part~=floor.Instance and(part.Transparency<.9 or part.Name=="UnplacableArea")then return nil,"collision"end
 end
 return CFrame.new(target.Position.X,floor.Position.Y,target.Position.Z)*target.Rotation
end
local function groundPivot(model,cf,cachedLift)
 local root=model.PrimaryPart
 local lowest=math.huge
 if cachedLift then model:PivotTo(cf*CFrame.new(0,cachedLift,0));return cachedLift end
 for _,part in model:GetDescendants()do
  if part:IsA("BasePart")and part.Transparency<1 then
   local rel=root.CFrame:ToObjectSpace(part.CFrame)
   local half=part.Size*.5
   local extent=math.abs(rel.RightVector.Y)*half.X+math.abs(rel.UpVector.Y)*half.Y+math.abs(rel.LookVector.Y)*half.Z
   lowest=math.min(lowest,rel.Position.Y-extent)
  end
 end
 if lowest==math.huge then lowest=-root.Size.Y*.5 end
 local lift=-lowest+.03
 model:PivotTo(cf*CFrame.new(0,lift,0))
 return lift
end
local function ready(a,state)
 if state.phase=="destroyed"or not active(a)then return end
 reveal(a,state)
 if a.BuilderPlacing==state then unlockPlacement(a,state)end
 if a.BuilderCast==state then a.BuilderCast=nil;unlockCast(a);result(a,"success")end
 if state.loop then state.loop:Destroy();state.loop=nil end
 stopTrack(state.animation)
 if state.placedCF then groundPivot(state.model,state.placedCF,state.groundLift)end
 setState(state,"active");state.activeAt=clock()
 state.animation=track(a,state,"Idle")
 state.loop=sound(a,state.kind.."Idle",state.model.PrimaryPart,true)
end
local function construct(a,kind,frame)
 if not active(a)or a.BuilderCast or a.BuilderPlacing or a.CarryingBuilding then return {Cancelled=true,Reason="carrying"}end
 local old=a.Buildings[kind]
 if old and Rules.ActivityRemaining(old.model:GetAttribute("LastActiveTime"),clock())>0 then return {Cancelled=true,Reason="recentActivity"}end
 if a:IsOnCooldown(kind)then return {Cancelled=true,Reason="cooldown"}end
 local cf,reason=placement(a,kind,old and old.model,requestedFacing(a,frame))
 if not cf then return {Cancelled=true,Reason=reason}end
 if old then destroy(a,old,false)end
 local model=(a.Config[kind.."Template"]or a.Config.Instances[kind.."Template"]):Clone()
 local hum=model:FindFirstChildOfClass("Humanoid")
 model.PrimaryPart=model:FindFirstChild("Root")or model.PrimaryPart
 if not hum or not model.PrimaryPart then model:Destroy();return {Cancelled=true,Reason="unknown"}end
 if not hum:FindFirstChildOfClass("Animator")then Instance.new("Animator",hum)end
 hum.MaxHealth=a.Config[kind.."Health"];hum.Health=hum.MaxHealth;hum.BreakJointsOnDeath=false;hum.EvaluateStateMachine=false
 model.Name="Builderman"..kind
 model:SetAttribute("OwnerName",tostring(a.Player));model:SetAttribute("Team","Survivors");model:SetAttribute("HitboxPriority",0)
 model:AddTag("SurvivorConstruct")
 for _,part in model:GetDescendants()do
  if part:IsA("BasePart")then part:SetAttribute("BuilderOriginalCollide",part.CanCollide);part:SetAttribute("BuilderOriginalMassless",part.Massless);part.CanQuery=true end
 end
 local groundLift=groundPivot(model,cf)
 local state={groundLift=groundLift,placedCF=cf,model=model,kind=kind,phase="building",completeAt=clock()+a.Config[kind.."ConstructionDuration"],revealAt=clock()+a.Config.ConstructionWindup,transparencies={}}
 a.Buildings[kind]=state;buildings[model]=state;a.BuilderCast=state
 setState(state,"building")
 for _,part in model:GetDescendants()do
  if part:IsA("BasePart")then state.transparencies[part]=part.Transparency;part.Transparency=1;part.CanQuery=false end
 end
 model.Parent=workspace.Map.Ingame
 local previousHealth=hum.Health
 state.health=hum.HealthChanged:Connect(function(value)
  local hurt=value<previousHealth;previousHealth=value
  if value<=0 or hurt and state.phase=="building"then destroy(a,state,killerDamage(model))end
 end)
 local oldResult=a.Rig:FindFirstChild("Result");if oldResult then oldResult:Destroy()end
 a:DisableAbilities("BuildermanConstruct",true)
 a.BuilderCastSpeed=Util:CreateSpeedMultiplier(a.Rig,0,"BuildermanConstruction")
 a.Rig:SetAttribute("PlacementRadius",a.Config[kind.."PlacementRadius"])
 tools(a,true)
 if a.ChangeExpression then a:ChangeExpression("Concentrating")end
 state.loop=sound(a,kind.."Building",model.PrimaryPart,true)
 broadcast(a,"ReplicateBuildingAsync",model,kind)
 for _,other in Actors.CurrentActors do
  if other.Player and other.Player:IsA("Player")and alive(other.Rig)and other.Rig.Parent==workspace.Players.Survivors then
   pcall(Util.RevealPlayerAuraTo,Util,other.Player,model,a.Config[kind.."PingDuration"],Color3.new(.75,1,.75))
  end
 end
 return {Duration=a.Config[kind.."ConstructionDuration"]}
end
local function closest(a)
 local best,range=nil,a.Config.CarryRange
 for _,state in a.Buildings do
  if state.phase=="active"and state.model.Parent then
   local distance=(state.model.PrimaryPart.Position-a.Rig.PrimaryPart.Position).Magnitude
   if distance<=range then best=state;range=distance end
  end
 end
 return best
end
local function move(a)
 if not active(a)or a.BuilderCast or a.BuilderPlacing then return "noBuilding"end
 if a.MoveReadyAt and clock()<a.MoveReadyAt then return "cooldown"end
 local state=a.CarryingBuilding
 if state then
  local cf,reason=placement(a,state.kind,state.model)
  if not cf then return reason end
  clearCarry(a)
  stopTrack(state.animation)
  groundPivot(state.model,cf,state.groundLift)
  state.placedCF=cf
  setState(state,"placing");state.completeAt=clock()+a.Config.CarryPlacementDuration
  a.BuilderPlacing=state
  a.BuilderPlaceSpeed=Util:CreateSpeedMultiplier(a.Rig,0,"BuildermanPlacement")
  a:DisableAbilities("BuildermanPlacement",true)
  if a.Player and a.Player:IsA("Player")then Network:FireClientConnection(a.Player,"DisableSprintingSV","REMOTE_EVENT","BuildermanPlacement",true)end
  stopTrack(state.animation);state.animation=track(a,state,"PutDown")
  sound(a,state.kind.."Putdown",state.model.PrimaryPart)
  a.MoveReadyAt=clock()+a.Config.CarryPlacementDuration
  a:SetCooldownOf("Move",a.Config.CarryPlacementDuration)
  return false
 end
 state=closest(a)
 if not state then return "noBuilding"end
 a.CarryingBuilding=state
 setState(state,"carry")
 if state.loop then state.loop:Destroy();state.loop=nil end
 stopTrack(state.animation);state.animation=track(a,state,"PickUp");state.carryAnimReady=clock()+a.Config[state.kind.."PickupDebounce"];state.walking=nil
 a.BuilderCarrySpeed=Util:CreateSpeedMultiplier(a.Rig,a.Config.CarryWalkspeed,"CarryingBuilding")
 a.Rig:SetAttribute("BuildermanCarrying",true)
 if a.Player and a.Player:IsA("Player")then Network:FireClientConnection(a.Player,"DisableSprintingSV","REMOTE_EVENT","CarryingBuilding",true)end
 state.model:PivotTo(a.Rig.PrimaryPart.CFrame*a.Config[state.kind.."PickupOffset"])
 local weld=Instance.new("Weld");weld.Name="BuildermanCarryMount";weld.Part0=a.Rig.PrimaryPart;weld.Part1=state.model.PrimaryPart
 weld.C0=a.Config[state.kind.."PickupOffset"];weld.C1=CFrame.new();weld.Parent=state.model.PrimaryPart
 state.weld=weld
 a.MoveReadyAt=clock()+a.Config[state.kind.."PickupDebounce"]
 a.BuilderPickupUntil=a.MoveReadyAt
 a.BuilderPickupSpeed=Util:CreateSpeedMultiplier(a.Rig,0,"BuildermanPickup")
 a:DisableAbilities("BuildermanPickup",true)
 a:SetCooldownOf("Move",a.Config[state.kind.."PickupDebounce"])
 sound(a,state.kind.."Pickup",state.model.PrimaryPart)
 return state.model
end
local function lineOfSight(state,target)
 local params=RaycastParams.new();params.FilterType=Enum.RaycastFilterType.Exclude
 local excluded={workspace.Players.Survivors}
 for _,entry in buildings do table.insert(excluded,entry.model)end
 params.FilterDescendantsInstances=excluded
 local origin=state.model.PrimaryPart.Position
 local hit=workspace:Raycast(origin,target.PrimaryPart.Position-origin,params)
 return not hit or hit.Instance:IsDescendantOf(target)
end
local function tickBuilding(a,state,dt)
 if state.phase=="destroyed"then return end
 if not state.model.Parent then destroy(a,state,false);return end
 if state.phase=="building"or state.phase=="placing"then
  if clock()>=state.completeAt then ready(a,state)end
  return
 end
 if state.phase=="carry"then
  if clock()>=(state.carryAnimReady or 0)then
   local walking=a.Rig.PrimaryPart.AssemblyLinearVelocity.Magnitude>1
   if state.walking~=walking then
    state.walking=walking;stopTrack(state.animation);state.animation=track(a,state,walking and "CarryWalk"or "CarryIdle")
   end
  end
  return
 end
 dt=math.min(dt,math.max(0,clock()-(state.activeAt or clock())))
 if dt<=0 then return end
 local n=count(state.kind)
 state.model:SetAttribute("BuildingCount",n)
 local radius=Rules.EffectRadius(a.Config,state.kind,n)
 state.model:SetAttribute("EffectRadiusSize",radius)
 if state.kind=="Sentry"then
  local nearest,distance=nil,radius
  for _,other in Actors.CurrentActors do
   if alive(other.Rig)and other.Rig.Parent==workspace.Players.Killers then
    local d=(other.Rig.PrimaryPart.Position-state.model.PrimaryPart.Position).Magnitude
    if d<=distance and lineOfSight(state,other.Rig)then nearest=other;distance=d end
   end
  end
  if nearest then
   local hum=nearest.Rig:FindFirstChildOfClass("Humanoid")
   local damage=math.min(hum.Health,a.Config.SentryDamagePerSec*dt)
   hum.Health-=damage
   if damage>0 then
    state.model:SetAttribute("DamageDealt",(state.model:GetAttribute("DamageDealt")or 0)+damage)
    state.model:SetAttribute("LastActiveTime",clock())
    Statuses:ApplyStatus(nearest.Rig,"Slowness",{Level=Rules.SlowLevel(a.Config,builders()),Duration=a.Config.SentrySlownessDuration})
    if not state.nextShotSound or clock()>=state.nextShotSound then sound(a,"SentryShoot",state.model.PrimaryPart);state.nextShotSound=clock()+.2 end
   end
  end
 else
  for _,other in Actors.CurrentActors do
   if alive(other.Rig)and other.Rig.Parent==workspace.Players.Survivors and(other.Rig.PrimaryPart.Position-state.model.PrimaryPart.Position).Magnitude<=radius then
    local hum=other.Rig:FindFirstChildOfClass("Humanoid")
    if hum.Health<hum.MaxHealth and not hum:GetAttribute("Clanker")then
     local before=hum.Health;Util:Heal(hum,a.Config.DispenserHealingPerSec*dt)
     local healed=math.max(0,hum.Health-before)
     if healed>0 then state.model:SetAttribute("TotalHealed",(state.model:GetAttribute("TotalHealed")or 0)+healed);state.model:SetAttribute("LastActiveTime",clock())end
    end
   end
  end
 end
end
function Server.Created(_,a)
 a.BuilderDestroyed=false;a.Buildings={};a.DisabledAbilities=a.DisabledAbilities or {};a.BuilderConnections={}
 a.Rig:SetAttribute("IsBuilderman",true)
 local hum=a.Rig:FindFirstChildOfClass("Humanoid");local health=hum.Health
 table.insert(a.BuilderConnections,hum.HealthChanged:Connect(function(value)
  local damage=health-value;health=value
  if a.BuilderCast and damage>0 then destroy(a,a.BuilderCast,false)end
  if a.CarryingBuilding and damage>=a.Config.CarryDamageThreshold then destroy(a,a.CarryingBuilding,killerDamage(a.Rig))end
  if value<=0 then Server.Destroyed(nil,a)end
 end))
 local accumulator=0
 table.insert(a.BuilderConnections,RunService.Heartbeat:Connect(function(dt)
  if not active(a)then Server.Destroyed(nil,a);return end
  if a.BuilderPickupUntil and clock()>=a.BuilderPickupUntil then unlockPickup(a)end
  for _,state in table.clone(a.Buildings)do
   if state.phase=="building"and not state.revealed and clock()>=state.revealAt then reveal(a,state)end
   if (state.phase=="building"or state.phase=="placing")and clock()>=state.completeAt then ready(a,state)end
  end
  accumulator+=dt;if accumulator<.1 then return end
  local elapsed=accumulator;accumulator=0
  for _,state in table.clone(a.Buildings)do tickBuilding(a,state,elapsed)end
  for _,kind in {"Sentry","Dispenser"}do
   local state=a.Buildings[kind]
   local locked=state and Rules.ActivityRemaining(state.model:GetAttribute("LastActiveTime"),clock())>0 or false
   if a.DisabledAbilities[kind]~=locked then a.DisabledAbilities[kind]=locked;emit(a,"UpdateBuildingAbilityLock",kind,"recentactivity",locked)end
  end
  local selected=a.CarryingBuilding or closest(a)
  if a.BuilderClosest~=selected then a.BuilderClosest=selected;emit(a,"UpdateClosestBuilding",selected and selected.model or nil)end
  if a.CarryingBuilding then local canPlace=placement(a,a.CarryingBuilding.kind,a.CarryingBuilding.model)~=nil;emit(a,"UpdateCanPlace",canPlace)end
 end))
end
function Server.Use(a,kind,frame)
 if kind=="Move"then return move(a)end
 local response=construct(a,kind,frame)
 if response and response.Cancelled then emit(a,"ConstructionRejected",response.Reason)end
 return response
end
function Server.Destroyed(_,a)
 if a.BuilderDestroyed then return end
 a.BuilderDestroyed=true
 for _,connection in a.BuilderConnections or {}do connection:Disconnect()end
 for _,state in table.clone(a.Buildings or {})do destroy(a,state,false)end
 clearCarry(a);unlockCast(a);unlockPlacement(a)
 a.DisabledAbilities.Sentry=nil;a.DisabledAbilities.Dispenser=nil
end
return Server
]========]},
{path=[========[
ReplicatedStorage/Assets/Survivors/Elliot/Behavior/Server]========],source=[========[
local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local Modules=game.ReplicatedStorage.Modules
local Actors=require(Modules.Actors)
local Statuses=require(Modules.Statuses)
local Util=require(Modules.Util)
local Sounds=require(Modules.Sounds)
local Network=require(Modules.Network)
local Rules=require(script.Parent.Rules)
local Server={}
local function alive(rig)
 local hum=rig and rig:FindFirstChildOfClass("Humanoid")
 return rig and rig.Parent and rig.PrimaryPart and hum and hum.Health>0
end
local function active(a)return not a.ElliotDestroyed and alive(a.Rig)end
local function actorFor(rig)
 for _,a in Actors.CurrentActors do if a.Rig==rig then return a end end
end
local function team(rig,name)return rig and rig.Parent==workspace.Players:FindFirstChild(name)end
local function sound(a,key,parent)
 local id=a.Config.Sounds and a.Config.Sounds[key]
 if id and id~=""then pcall(Sounds.Play,Sounds,id,{Parent=parent or a.Rig.PrimaryPart})end
end
local function invoke(a,name,...)
 local method=a.Behavior[name]
 if method then pcall(method,a.Behavior,a,...)end
end
local function nearest(a)
 local best,distance=nil,a.Config.RushHourKillerRange
 for _,other in Actors.CurrentActors do
  if team(other.Rig,"Killers")and alive(other.Rig)then
   local d=(other.Rig.PrimaryPart.Position-a.Rig.PrimaryPart.Position).Magnitude
   if d<=distance then best=other;distance=d end
  end
 end
 return best
end
local function charges(a,level)
 local ability=a.Behavior.Abilities.RushHour
 local n=Rules.Level(level)
 if a.IncrementCharges then a:IncrementCharges("RushHour",n-(ability.CurrentCharges or 0),3)else ability.CurrentCharges=n end
 a.Rig:SetAttribute("ElliotRushCharges",n)
end
local function releaseRush(a)
 local rush=a.ElliotRush
 if not rush then return end
 a.ElliotRush=nil
 if rush.mountConnection then rush.mountConnection:Disconnect()end
 if rush.scooter then rush.scooter:Destroy()end
 if a.Rig and a.Rig.Parent then a.Rig:SetAttribute("ElliotRushing",nil)end
end
local function scooter(a)
 if a.Config.UsesScooter==false then return end
 local template=a.Config.Instances and a.Config.Instances.CustomScooter
 if not template or not template:IsA("Model")then return end
 local model=template:Clone()
 local handle=model:FindFirstChild("ScooterHandle")or model.PrimaryPart
 local torso=a.Rig:FindFirstChild("HumanoidRootPart")or a.Rig.PrimaryPart
 if not handle or not torso then model:Destroy();return end
 for _,object in model:GetDescendants()do
  if object:IsA("BasePart")then
   object.Anchored=false;object.CanCollide=false;object.CanTouch=false;object.CanQuery=false;object.Massless=true
   if object~=handle and (object.Name=="Scooter"or object:IsA("MeshPart"))then
    object.Transparency=0;object.LocalTransparencyModifier=0
   end
  elseif object:IsA("LuaSourceContainer")then object:Destroy()end
 end
 model.PrimaryPart=handle
 model:PivotTo(torso.CFrame)
 local oldJoint=model:FindFirstChild("ScooterJoint",true)
 if oldJoint then oldJoint:Destroy()end
 local joint=Instance.new("Weld")
 joint.Name="ElliotScooterMount";joint.Part0=torso;joint.Part1=handle;joint.Parent=handle
 joint.C1=CFrame.new()
 local base=a.Config.RushHourScooterOffset or CFrame.new()
 local geometry={}
 for _,part in model:GetDescendants()do
  if part:IsA("BasePart")and part~=handle and part.Transparency<1 then
   table.insert(geometry,{relative=handle.CFrame:ToObjectSpace(part.CFrame),half=part.Size*.5})
  end
 end
 if not a.Config.RushHourScooterOffset and #geometry>0 then
  local minimum=Vector3.new(math.huge,math.huge,math.huge)
  local maximum=Vector3.new(-math.huge,-math.huge,-math.huge)
  for _,shape in geometry do
   for x=-1,1,2 do for y=-1,1,2 do for z=-1,1,2 do
    local point=shape.relative:PointToWorldSpace(Vector3.new(x*shape.half.X,y*shape.half.Y,z*shape.half.Z))
    minimum=Vector3.new(math.min(minimum.X,point.X),math.min(minimum.Y,point.Y),math.min(minimum.Z,point.Z))
    maximum=Vector3.new(math.max(maximum.X,point.X),math.max(maximum.Y,point.Y),math.max(maximum.Z,point.Z))
   end end end
  end
  base=CFrame.new(-(minimum.X+maximum.X)*.5,0,-(minimum.Z+maximum.Z)*.5)
 end
 local params=RaycastParams.new()
 params.FilterType=Enum.RaycastFilterType.Include
 params.FilterDescendantsInstances={workspace.Map}
 params.IgnoreWater=true
 model.Name="ElliotRushScooter";model:SetAttribute("ElliotMountVersion","RigidCentered");model.Parent=a.Rig
 local connection
 local function updateMount()
  if not model.Parent or not torso.Parent then
   if connection then connection:Disconnect()end
   return
  end
  local mount=torso.CFrame*base
  local bottom=math.huge
  for _,shape in geometry do
   local cf=mount*shape.relative
   local half=shape.half
   local extent=math.abs(cf.RightVector.Y)*half.X+math.abs(cf.UpVector.Y)*half.Y+math.abs(cf.LookVector.Y)*half.Z
   bottom=math.min(bottom,cf.Position.Y-extent)
  end
  local floor=workspace:Raycast(torso.Position+Vector3.new(0,2,0),Vector3.new(0,-8,0),params)
  local lift=0
  if floor and bottom<math.huge then lift=math.max(0,floor.Position.Y+.06-bottom)end
  local localLift=torso.CFrame:VectorToObjectSpace(Vector3.new(0,lift,0))
  joint.C0=CFrame.new(localLift)*base
 end
 updateMount()
 connection=RunService.Heartbeat:Connect(updateMount)
 return model,connection
end
local function reward(a,kind)
 if not a.Player or not a.Player:IsA("Player")then return end
 -- FB payouts supplied by the user; rewards are granted by the server.
 local settings=a.Config.RushHourRewards and a.Config.RushHourRewards[kind]
 a.Rig:SetAttribute("ElliotRush"..kind,(a.Rig:GetAttribute("ElliotRush"..kind)or 0)+1)
 if settings then
  local payload=table.clone(settings)
  payload.Action=kind=="Used"and "Used Rush Hour"or "Successfully Escaped the Killer with Rush Hour"
  Actors:IncrementActorStats(a.Player,payload)
 end
end
function Server.Created(_,a)
 a.ElliotDestroyed=false;a.HealingBonus=0;a.ElliotPizzas={};a.ElliotConnections={}
 charges(a,1)
 table.insert(a.ElliotConnections,a.Rig:FindFirstChildOfClass("Humanoid").Died:Connect(function()Server.Destroyed(nil,a)end))
end
function Server.ObjectiveProgressed(_,a)
 if not active(a)then return end
 a.HealingBonus=math.min((a.HealingBonus or 0)+a.Config.OrderUpBonus,a.Config.OrderUpBonusMax)
 if a.Player then Network:FireClientConnection(a.Player,"ElliotOrderUpUpdate","REMOTE_EVENT",a.HealingBonus)end
end
function Server.OnThrowPizza(_,a)
 local pizza=a.Rig:FindFirstChild("Pizza")
 if pizza and pizza:IsA("BasePart")then pizza.Transparency=a.Config.PizzaTransparency or 0 end
end
function Server.OnThrowPizzaEnd(_,a)
 local pizza=a.Rig and a.Rig:FindFirstChild("Pizza")
 if pizza and pizza:IsA("BasePart")then pizza.Transparency=1 end
end
local function healPizza(a,target,additional)
 local rig=target.Rig
 local hum=rig:FindFirstChildOfClass("Humanoid")
 local instant,total=Rules.Healing(a.Config,a.HealingBonus,additional,target.ActorName=="Elliot")
 local before=hum.Health
 Util:Heal(hum,instant)
 local credited=false
 local function credit()
  if credited then return end
  credited=true
  if active(a)and target.ActorName~="Elliot"then charges(a,(a.Behavior.Abilities.RushHour.CurrentCharges or 0)+1)end
  if a.Player and a.Player:IsA("Player")then Actors:IncrementActorStats(a.Player,{Action="Healed player as Elliot",RewardType="Support"})end
 end
 if hum.Health>before then credit()end
 local elapsed=0
 local health=hum.Health
 local cancelled=false
 local healthConnection,heartbeat
 local function stop()
  if healthConnection then healthConnection:Disconnect();healthConnection=nil end
  if heartbeat then heartbeat:Disconnect();heartbeat=nil end
 end
 healthConnection=hum.HealthChanged:Connect(function(value)
  if value<=0 or health-value>=5 then cancelled=true;stop()end
  health=value
 end)
 heartbeat=RunService.Heartbeat:Connect(function(dt)
  if cancelled or not rig.Parent or hum.Health<=0 then stop();return end
  local step=math.min(dt,a.Config.PizzaHealingProgressivelyTime-elapsed)
  elapsed+=step
  local previous=hum.Health
  Util:Heal(hum,total*step/a.Config.PizzaHealingProgressivelyTime)
  if hum.Health>previous then credit()end
  if elapsed>=a.Config.PizzaHealingProgressivelyTime then stop()end
 end)
end
local function spawnPizza(a)
 if not active(a)then return end
 local source=a.Config.Instances and a.Config.Instances.CustomPizza or a.Rig:FindFirstChild("Pizza")
 if not source or not source:IsA("BasePart")then warn("[Elliot] Missing pizza part");return end
 local pizza=source:Clone();pizza.Name="ElliotPizza"
 for _,object in pizza:GetDescendants()do
  if object:IsA("JointInstance")or object:IsA("WeldConstraint")or object:IsA("LuaSourceContainer")then object:Destroy()end
 end
 pizza.Anchored=false;pizza.CanCollide=true;pizza.CanTouch=true;pizza.Massless=false;pizza.Transparency=0
 pizza.CFrame=a:GetPivot()*CFrame.new(0,0,-2)
 pizza.Parent=workspace.Map.Ingame
 pcall(function()pizza.CollisionGroup="Items";pizza:SetNetworkOwner(nil)end)
 pizza.AssemblyLinearVelocity=(a:GetPivot().LookVector+Vector3.new(0,.5,0))*a.Config.PizzaThrowForce
 sound(a,"PizzaThrown")
 if a.Config.PizzaParticles then local particles=a.Config.PizzaParticles:Clone();particles.Enabled=true;particles.Parent=pizza end
 local gui=a.Config.PizzaTimeGui and a.Config.PizzaTimeGui:Clone()
 if gui then gui.Adornee=pizza;gui.Parent=pizza end
 for _,other in Actors.CurrentActors do
  if other.Player and other.Player:IsA("Player")and team(other.Rig,"Survivors")and alive(other.Rig)and(other.Rig.PrimaryPart.Position-a.Rig.PrimaryPart.Position).Magnitude<=a.Config.PizzaPingDistance then
   pcall(Util.RevealPlayerAuraTo,Util,other.Player,pizza,a.Config.PizzaPingDuration,Color3.new(.75,1,.75),100)
  end
 end
 local state={part=pizza,elapsed=0,consumed=false};a.ElliotPizzas[state]=true
 local function cleanup()
  if state.connection then state.connection:Disconnect();state.connection=nil end
  a.ElliotPizzas[state]=nil
  pizza:Destroy()
 end
 state.connection=RunService.Heartbeat:Connect(function(dt)
  if not pizza.Parent then cleanup();return end
  state.elapsed+=dt
  if state.elapsed>=a.Config.PizzaLifetime then cleanup();return end
  if gui then
   local text=gui:FindFirstChild("Display",true)
   if text then text.Text=tostring(math.ceil(a.Config.PizzaLifetime-state.elapsed))end
  end
  for _,target in Actors.CurrentActors do
   local rig=target.Rig
   if rig~=a.Rig and team(rig,"Survivors")and alive(rig)then
    local hum=rig:FindFirstChildOfClass("Humanoid")
    if not hum:GetAttribute("Clanker")and hum.Health<hum.MaxHealth then
     local close=false
     for _,part in rig:GetChildren()do
      if part:IsA("BasePart")and(part.Position-pizza.Position).Magnitude<=(a.Config.PizzaHitboxSize or 2)+part.Size.Magnitude*.25 then close=true;break end
     end
     if close and not state.consumed then
      state.consumed=true
      local additional=0
      for _,other in Actors.CurrentActors do
       if other~=a and other.ActorName=="Elliot"and team(other.Rig,"Survivors")and alive(other.Rig)then additional+=1 end
      end
      sound(a,"PizzaEaten",rig.PrimaryPart)
      cleanup();healPizza(a,target,additional);return
     end
    end
   end
  end
 end)
end
function Server.ThrowPizza(a)
 if not active(a)then return {Cancelled=true}end
 a:DisableAbilities("ElliotPizza",true,a.Config.PizzaAbilityDisabledFor)
 invoke(a,"OnThrowPizza")
 task.delay(a.Config.PizzaThrowTimeToThrow,function()
  if active(a)then spawnPizza(a)end
  invoke(a,"OnThrowPizzaEnd")
 end)
 return {}
end
function Server.RushHour(a)
 if not active(a)or a.ElliotRush then return {Cancelled=true}end
 local level=Rules.Level(a.Behavior.Abilities.RushHour.CurrentCharges)
 if level==0 and workspace:GetAttribute("ChargesDisabled")then level=1 end
 if level==0 then return {Cancelled=true}end
 local killer=nearest(a)
 local empowered=killer~=nil
 if empowered and not workspace:GetAttribute("ChargesDisabled")then charges(a,0)end
 local rush={level=empowered and level or 1,empowered=empowered}
 a.ElliotRush=rush;a.Rig:SetAttribute("ElliotRushing",true)
 rush.scooter,rush.mountConnection=scooter(a)
 a:DisableAbilities("ElliotRush",true,a.Config.RushHourAbilityDisabledFor)
 sound(a,"RushHourStart")
 if a.ChangeExpression then a:ChangeExpression("Happy",a.Config.RushHourSpeedDuration)end
 Statuses:ApplyStatus(a.Rig,"Speed",{Level=rush.level,Duration=a.Config.RushHourSpeedDuration,NoStack={"HitSpeedBonus"}})
 reward(a,"Used")
 task.delay(a.Config.RushHourSpeedDuration,function()
  if a.ElliotRush~=rush then return end
  releaseRush(a)
  if active(a)and empowered then
   Statuses:ApplyStatus(a.Rig,"Exhausted",{Level=level,Duration=a.Config.RushHourExhaustedDuration})
   if alive(killer.Rig)and team(killer.Rig,"Killers")and not nearest(a)then reward(a,"Escaped")end
  end
 end)
 return {Level=rush.level,Empowered=empowered,Duration=a.Config.RushHourSpeedDuration}
end
function Server.Destroyed(_,a)
 if a.ElliotDestroyed then return end
 a.ElliotDestroyed=true
 releaseRush(a)
 for _,connection in a.ElliotConnections or {}do connection:Disconnect()end
 for state in a.ElliotPizzas or {}do if state.connection then state.connection:Disconnect()end;if state.part then state.part:Destroy()end end
 a.ElliotPizzas={}
end
return Server
]========]},
{path=[========[
ReplicatedStorage/Modules/Hitboxes]========],source=[========[
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
]========]},
{path=[========[
ServerScriptService/Server/Systems/Core/PlayerManager]========],source=[========[
local module = {}

local Janitor = require(game.ReplicatedStorage.Modules.Misc.Janitor) -- expect to see this ALOT on the engine
local Network = require(game.ReplicatedStorage.Modules.Network)
local Actors = require(game.ReplicatedStorage.Modules.Actors)
local ChatCommands = require(script.ChatCommands)
local GlobalConfig = require(game.ServerStorage.GlobalConfig)
local ManualRanks = GlobalConfig.ManualRanks
local CustomTitles = GlobalConfig.CustomTitles
local Data = require(game.ServerScriptService.Server.Systems.Data.PlayerData)
local Leaderstats = require(game.ServerScriptService.Server.Systems.Data.LeaderStats)
local ProductHandler = require(game.ServerScriptService.Server.Systems.Shopping.ProductHandler)
local AchievementUtil = require(game.ReplicatedStorage.Modules.AchievementUtil)
local Anticheat = require(game.ServerScriptService.Server.Systems.Core.Anticheat)
local Util = require(game.ReplicatedStorage.Modules.Util)
local FacialUnification = require(game.ReplicatedStorage.Modules.Misc.FacialUnification)

local PlayerJanitors = {}

module.Start = function()
	task.spawn(function()
		for _, plr in ipairs(game.Players:GetPlayers()) do
			task.spawn(module.InitPlayer, plr)
		end
		game.Players.PlayerAdded:Connect(module.InitPlayer)
		game.Players.PlayerRemoving:Connect(module.RemovePlayer)
	end)
end

module.InitCharacter = function(playerJanitor, Character : Model, Player : Player)
	local charJanitor = Janitor.new()
	playerJanitor:Add(charJanitor, "Destroy", "CharacterJanitor")

	if Character.Parent == game.Workspace then
		Character.Parent = workspace.Players.Spectating
		Character.PrimaryPart = Character.HumanoidRootPart
		for _, part in ipairs(Character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CollisionGroup = "Players"
			end
		end
		Character.Humanoid:SetAttribute("BaseSpeed", 16)
		FacialUnification:ConvertAnimatedHead(Character.Humanoid)
	else
		Character.Archivable = true
	end

	for _, instance in ipairs(script.CharacterEssentials:GetChildren()) do
		if not Character:FindFirstChild(instance.Name) then
			instance:Clone().Parent = Character
		end
	end

	local hrp = Character.PrimaryPart
	if hrp then
		charJanitor:Add(hrp.AncestryChanged:Connect(function()
			if hrp.Parent ~= nil then return end

			charJanitor:Remove("VoidKill")
			task.wait(game.Players.RespawnTime + 1)

			if Character.Parent and Player.Parent then
				Player:LoadCharacterAsync()
			end
		end), "Disconnect", "VoidKill")
	end
end

module.InitPlayer = function(Player : Player)
	local janitor = Janitor.new()
	PlayerJanitors[Player] = janitor

	local Rank = (game["Run Service"]:IsStudio() and Player.UserId < 0) and 999 or (game.CreatorType == Enum.CreatorType.Group and Player:GetRoleInGroupAsync(game.CreatorId) or ManualRanks[Player.UserId] or 0)
	if (not game["Run Service"]:IsStudio() and (not GlobalConfig.FreeTesting) and (Rank or 0) < 10) then
		Player:SetAttribute("NotAllowed", true)
		Player:Kick(GlobalConfig.NotAllowedKickMsg)
		return
	end

	Player:SetAttribute("Rank", Rank)
	Data:LoadData(Player)
	Leaderstats:AddStats(Player)
	ProductHandler:ActivatePasses(Player)

	if GlobalConfig.FreeVIP then
		Player:SetAttribute("VIP", true)
	end

	janitor:Add(Player.CharacterAdded:Connect(function(Character)
		module.InitCharacter(janitor, Character, Player)
	end), "Disconnect")

	if Player.Character then
		module.InitCharacter(janitor, Player.Character, Player)
	end

	if Rank and Rank >= 2 then
		local closestRank = 0
		local closestRankName = CustomTitles[Player.UserId] or game.CreatorType == Enum.CreatorType.Group and GlobalConfig.PreferCustomRankNames == false and Player:GetRoleInGroupAsync(game.CreatorId)
		if not closestRankName then
			for name, number in pairs(require(game.ServerScriptService.Server.Modules.RankNames)) do
				if number <= Rank and math.abs(number - Rank) < math.abs(closestRank - Rank) then
					closestRank = number
					closestRankName = name
				end
			end
		end
		Player:SetAttribute("RankTitle", closestRankName)
	end

	janitor:Add(Player.Chatted:Connect(function(msg)
		if game["Run Service"]:IsStudio() or (Player:GetAttribute("Rank") or 0) >= 100 then
			local args = string.split(msg, " ")
			local cmdName = args[1]
			if type(ChatCommands[cmdName]) == "function" then
				table.remove(args, 1)
				ChatCommands[cmdName](Player, table.unpack(args))
			end
		end
	end), "Disconnect")

	janitor:Add(task.spawn(function()
		while true do
			task.wait(1)
			if Player.Parent and Player:FindFirstChild("PlayerData") then
				Player.PlayerData.Stats.General.TimePlayed.Value += 1
			end
		end
	end), true)

	Anticheat.new(Player)
	janitor:Add(function()
		Anticheat:CleanupFromPlayer(Player)
	end, true)

	local playerData = Player:WaitForChild("PlayerData", 60)
	if not playerData then return end

	local purchased = playerData:WaitForChild("Purchased", 10)
	local equippedSkins = playerData:WaitForChild("Equipped"):WaitForChild("Skins")

	if purchased and equippedSkins then
		local function allocateSkin(val)
			if not equippedSkins:FindFirstChild(val.Name) then
				local skinVal = Instance.new("StringValue")
				skinVal.Name = val.Name
				skinVal.Parent = equippedSkins
			end
		end

		for _, val in ipairs(Util:MergeTables(purchased.Killers:GetChildren(), purchased.Survivors:GetChildren())) do
			allocateSkin(val)
		end

		janitor:Add(purchased.Killers.ChildAdded:Connect(allocateSkin), "Disconnect")
		janitor:Add(purchased.Survivors.ChildAdded:Connect(allocateSkin), "Disconnect")
	end
end

module.RemovePlayer = function(Player)
	task.spawn(function()
		Data:SaveData(Player)
	end)

	local currentSessionModule = game.ServerScriptService.Server.Systems.Core:FindFirstChild("RoundManager")
	if currentSessionModule then
		local currentSession = require(currentSessionModule).CurrentSession
		if currentSession then
			local actor = Actors.CurrentActors[Player]
			if actor then
				local rig = actor.Rig
				local attackerName = rig:GetAttribute("RecentAttacker")

				if attackerName and rig:GetAttribute("RecentAttackerTime") and (os.clock() - rig:GetAttribute("RecentAttackerTime") <= 10) then
					local attacker = game.Players:FindFirstChild(attackerName)
					if attacker then
						Actors:IncrementActorStats(attacker, {
							Action = "Survivor ragequit mid-chase",
							Money = 15,
							EXP = 45
						})
						currentSession.TimePast -= currentSession.Gamemode.TimeAddedOnKill or 35
						AchievementUtil:IncrementAchievementProgress(attacker, "MakePlayerRagequit")
					end
				end
			end
		end
	end

	if PlayerJanitors[Player] then
		PlayerJanitors[Player]:Destroy()
		PlayerJanitors[Player] = nil
	end
end

return module]========]},
{path=[========[
ReplicatedStorage/Modules/PlayerList]========],source=[========[
local t1 = {
	_players = {},
	DisplayedStats = {
		"Money",
		"KillerChance"
	},
	ListEnabled = true
}
local SocialService = game:GetService("SocialService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

game:GetService("TextChatService")

local v6 = RunService:IsStudio()
local clamp = math.clamp
local LocalPlayer = Players.LocalPlayer

require(game.ReplicatedStorage.Modules.Actors)

local DataHandler = require(game.ReplicatedStorage.Modules.DataHandler)
local Util = require(game.ReplicatedStorage.Modules.Util)
local Sounds = require(game.ReplicatedStorage.Modules.Sounds)
local Network = require(game.ReplicatedStorage.Modules.Network)
local t2 = {
	KillerChance = "Malice",
	RbxSpent = "R$ Spent"
}
local t3 = {
	PC = "rbxassetid://135066638879377",
	Mobile = "rbxassetid://89227325753198",
	Console = "rbxassetid://118447973769044",
	Unknown = "rbxassetid://94182197303121",
	NoChat = "rbxassetid://8509669675"
}

local function getPath(p1, s1: string, n1: number?) -- line: 51
	assert(typeof(p1) == "Instance")
	assert(typeof(s1) == "string")

	if s1 == "" then
		return p1
	end

	for _, v23 in (string.split(s1, "/")) do
		if typeof(n1) ~= "number" then
			p1 = p1:FindFirstChild(v23)

			if p1 ~= nil then
				continue
			end

			return
		end

		p1 = p1:WaitForChild(v23, n1)

		if p1 == nil then
			return
		end
	end

	return p1
end

function t1.GetPlayerListUI(p2) -- line: 76
	if not p2.PlayerList then
		repeat
			task.wait()
		until p2.PlayerList
	end

	return p2.PlayerList
end

local thread = nil
local u17 = true

function t1.TogglePlayerList(_, p4, p5) -- line: 85
	-- upvalues: t1 (copy), Sounds (copy), thread (ref), u17 (ref)
	if p5 then
		t1.ListEnabled = p4
	elseif not t1.ListEnabled then
		return
	end

	if not p5 then
		Sounds:Play("switch")
	end

	local PlayerListUI = t1:GetPlayerListUI()

	if thread then
		task.cancel(thread)
	end

	if p4 then
		u17 = true
		PlayerListUI.Close.Text = ">"
		PlayerListUI.Close.Visible = true
		PlayerListUI.Contents.Visible = true
		PlayerListUI.Background.Visible = true
		PlayerListUI.FriendBoost.Visible = true
		game.TweenService:Create(PlayerListUI, TweenInfo.new(0.15), {
			AnchorPoint = script.PlayerListHolder.AnchorPoint,
			Position = script.PlayerListHolder.Position
		}):Play()

		return
	end

	u17 = false
	PlayerListUI.Close.Text = "<"
	game.TweenService:Create(PlayerListUI, TweenInfo.new(0.15), {
		AnchorPoint = Vector2.new(),
		Position = UDim2.new(1, 0, 0, script.PlayerListHolder.Position.Y.Offset)
	}):Play()
	thread = task.delay(0.15, function() -- line: 116
		-- upvalues: p5 (copy), PlayerListUI (copy)
		if p5 then
			PlayerListUI.Close.Visible = false
		end

		PlayerListUI.Contents.Visible = false
		PlayerListUI.Background.Visible = false
		PlayerListUI.FriendBoost.Visible = false
	end)
end

local t4 = {}

function t1.ShowPlayerStats(t5: {[any]: any}, p6) -- line: 127
	-- upvalues: t4 (copy), Sounds (copy), t1 (copy), t3 (copy), DataHandler (copy), Util (copy), LocalPlayer (copy)
	for _, v in pairs(t4) do
		v:Disconnect()
	end

	table.clear(t4)

	if t5.__currentlyDisplayedStats and t5.__currentlyDisplayedStats.Parent then
		if tostring(t5.__currentlyDisplayedStats) == tostring(p6) then
			game.TweenService:Create(t5.__currentlyDisplayedStats, TweenInfo.new(0.15), {
				Size = UDim2.fromScale()
			}):Play()
			game.Debris:AddItem(t5.__currentlyDisplayedStats, 0.15)
			t5.__currentlyDisplayedStats = nil

			return
		end

		t5.__currentlyDisplayedStats:Destroy()
	end

	local clone = script.PlayerStats:Clone()

	clone.Name = tostring(p6)
	clone.Close.MouseEnter:Connect(function() -- line: 150
		-- upvalues: Sounds (copy)
		Sounds:Play("hover")
	end)
	clone.Close.MouseLeave:Connect(function() -- line: 151
		-- upvalues: Sounds (copy)
		Sounds:Play("hoverEnd")
	end)
	clone.Close.MouseButton1Click:Connect(function() -- line: 152
		-- upvalues: Sounds (copy), t1 (copy), p6 (copy)
		Sounds:Play("select")
		t1:ShowPlayerStats(p6)
	end)

	local v34 = `@{ p6.Name }`
	local v35 = p6.DisplayName ~= p6.Name and (p6.DisplayName ~= "" and p6.DisplayName)

	clone.BasicInfo.PlayerName.Text = v35 or v34
	clone.BasicInfo.PlayerUsername.Text = v34
	clone.BasicInfo.PlayerUsername.Visible = v35
	task.spawn(function() -- line: 164
		-- upvalues: p6 (copy), clone (copy)
		local UserId = p6.UserId
		local UserThumbnailAsync = game.Players:GetUserThumbnailAsync(UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)

		clone.PlayerIconHolder.Player.Image = UserThumbnailAsync
	end)

	local function updatePlayerDevice() -- line: 171
		-- upvalues: t3 (copy), p6 (copy), clone (copy)
		local v93 = t3[p6:GetAttribute("Device")] or t3.Unknown

		clone.PlayerIconHolder.Device.Image = v93
	end

	local v37 = t3[p6:GetAttribute("Device")] or t3.Unknown

	clone.PlayerIconHolder.Device.Image = v37
	table.insert(t4, p6:GetAttributeChangedSignal("Device"):Connect(updatePlayerDevice))

	local v38 = DataHandler:Get(p6)
	local v39 = v38 and v38:FindFirstChild("Stats")
	local v40 = v38 and v38:FindFirstChild("Equipped")

	if v39 and v40 then
		local General = v39:FindFirstChild("General")
		local v42 = General and General:FindFirstChild("TimePlayed")

		if v42 then
			local function updateTimePlayed() -- line: 256
				-- upvalues: Util (copy), p6 (copy), clone (copy), v42 (copy)
				local SettingValue = Util:GetSettingValue("HidePlaytime", p6)

				clone.TimePlayed.Text = `Time Played: { (if not SettingValue then Util:FormatTime(v42.Value, "Clock") else "<font color=\"rgb(125,125,125)\"><i>(Hidden)</i></font>") }`
			end

			local SettingValue = Util:GetSettingValue("HidePlaytime", p6)

			clone.TimePlayed.Text = `Time Played: { (if not SettingValue then Util:FormatTime(v42.Value, "Clock") else "<font color=\"rgb(125,125,125)\"><i>(Hidden)</i></font>") }`
			table.insert(t4, v42:GetPropertyChangedSignal("Value"):Connect(updateTimePlayed))
		end

		for _, v in pairs({
			"Killer",
			"Survivor"
		}) do
			local v47 = v39 and v39:FindFirstChild(`{ v }Stats`)
			local v48 = v47 and v47:FindFirstChild(`{ v }Wins`)

			if v48 then
				local SettingValue = Util:GetSettingValue(`Hide{ v }Wins`, p6)
				local v50 = clone.WinInfo:FindFirstChild(`{ v }Wins`)

				v50.MouseEnter:Connect(function() -- line: 275
					-- upvalues: Util (copy), v (copy), SettingValue (copy)
					Util:CreateTooltip(`{ v } Wins{ not SettingValue and "" or " <font color=\"rgb(125,125,125)\"><i>(Hidden)</i></font>" }`)
				end)
				v50.MouseLeave:Connect(function() -- line: 276
					-- upvalues: Util (copy)
					Util:CreateTooltip()
				end)

				local function setScore() -- line: 279
					-- upvalues: v50 (copy), SettingValue (copy), v48 (copy)
					v50.Wins.Text = if not SettingValue then v48.Value else "<font color=\"rgb(125,125,125)\"><i>(Hidden)</i></font>"
				end

				v50.Wins.Text = if not SettingValue then v48.Value else "<font color=\"rgb(125,125,125)\"><i>(Hidden)</i></font>"
				table.insert(t4, v48:GetPropertyChangedSignal("Value"):Connect(setScore))
			end

			if v40 then
				local t6 = {}

				local function setEquippedIcon() -- line: 292
					-- upvalues: p6 (copy), v (copy), t6 (ref), clone (copy), Util (copy)
					local v95, v96 = require(game.ReplicatedStorage.Modules.Actors):GetEquippedActorInfo(p6, v)
					local v97 = game.ReplicatedStorage.Assets:FindFirstChild(`{ v }s`):FindFirstChild(v95)
					local v98 = v97 and (v97:FindFirstChild("Config") and require(v97.Config))
					local v99 = game.ReplicatedStorage.Assets.Skins:FindFirstChild(`{ v }s`):FindFirstChild(v95)
					local v100 = v99 and v99:FindFirstChild(v96)
					local v101 = v100 and (v100:FindFirstChild("Config") and require(v100.Config))

					if v98 then
						for _, v2 in pairs(t6) do
							v2:Disconnect()
						end

						table.clear(t6)

						local v3 = clone.BasicInfo.EquippedCharacters:FindFirstChild(v)
						local u105 = `Equipped { v }: <i>{ v98.DisplayName or tostring(v97) }</i>`

						if v101 then
							u105 = `{ u105 }\nEquipped Skin: <i>{ v101.DisplayName or tostring(v100) }</i>`
						end

						v3.Image = v101 and v101.RenderImage or (v98.RenderImage or "rbxassetid://13373279056")
						t6 = {
							v3.MouseEnter:Connect(function() -- line: 316
								-- upvalues: Util (copy), u105 (ref)
								Util:CreateTooltip(u105)
							end),
							v3.MouseLeave:Connect(function() -- line: 317
								-- upvalues: Util (copy)
								Util:CreateTooltip()
							end)
						}
					end
				end

				local v4 = v40:FindFirstChild(v)
				local v5 = v40.Skins:FindFirstChild(v)

				setEquippedIcon()

				if v4 then
					table.insert(t4, v4:GetPropertyChangedSignal("Value"):Connect(setEquippedIcon))
				end

				if v5 then
					table.insert(t4, v5:GetPropertyChangedSignal("Value"):Connect(setEquippedIcon))
				end
			end
		end
	end

	if not t5.__currentlyDisplayedStats then
		clone.Size = UDim2.new()
		game.TweenService:Create(clone, TweenInfo.new(0.15), {
			Size = script.PlayerStats.Size
		}):Play()
	end

	clone.Parent = LocalPlayer.PlayerGui.TemporaryUI
	t5.__currentlyDisplayedStats = clone
	clone.AncestryChanged:Connect(function(_, parent) -- line: 345
		-- upvalues: Util (copy), t4 (copy)
		if not parent then
			Util:CreateTooltip()

			for _, v in pairs(t4) do
				v:Disconnect()
			end

			table.clear(t4)
		end
	end)
end
function t1.CreatePlayerInList(_: {[any]: any}, p8) -- line: 356
	-- upvalues: t1 (copy), Util (copy), Network (copy), v6 (copy)
	if not p8 then
		return
	end

	local PlayerListUI = t1:GetPlayerListUI()
	local v59 = PlayerListUI.Contents.Players:FindFirstChild((tostring(p8)))

	if v59 then
		v59:Destroy()
	end

	local clone = script.PlayerInfoContainer:Clone()

	clone.Name = tostring(p8)

	local p8Name = p8.Name
	local v62 = p8.DisplayName ~= p8.Name and (p8.DisplayName ~= "" and p8.DisplayName)

	local baseName = v62 or p8Name
	clone.PlayerInfo.Username.Text = baseName
	clone.PlayerInfo.Username.RichText = true

	local function updateAFKStatus()
		local afkValue = Util:GetSettingValue("AFK", p8)
		local isAFK = afkValue == true or (typeof(afkValue) == "number" and afkValue > 0)
		clone.PlayerInfo.Username.Text = isAFK and `{baseName} <font color="#B82500">[AFK]</font>` or baseName
	end

	task.spawn(function()
		local playerData = DataHandler:Get(p8)
		if not playerData then return end
		local settings = playerData:FindFirstChild("Settings")
		if not settings then return end
		local afkSetting = settings:FindFirstChild("AFK", true)
		if afkSetting then
			afkSetting:GetPropertyChangedSignal("Value"):Connect(updateAFKStatus)
		end
		updateAFKStatus()
	end)

	clone.ShowStats.MouseButton1Click:Connect(function() -- line: 375
		-- upvalues: t1 (copy), p8 (copy)
		t1:ShowPlayerStats(p8)
	end)

	if t1.DisplayedStats and t1.DisplayedStats[1] then
		local leaderstats = p8:WaitForChild("leaderstats", 30)

		if not leaderstats or not p8.Parent then
			return
		end

		for _, child in pairs(leaderstats:GetChildren()) do
			local clone2 = clone.PlayerInfo.Username:Clone()

			clone2.Name = child and child.Name
			clone2.Size = UDim2.fromScale(0.3, 1)
			clone2.LayoutOrder = table.find(t1.DisplayedStats, child.Name)
			clone2.TextXAlignment = Enum.TextXAlignment.Center
			clone2.Parent = clone.PlayerInfo

			local function updateStat() -- line: 396
				-- upvalues: child (copy), clone2 (copy), Util (copy)
				local v110 = child and child.Value or "?"

				if tonumber(v110) then
					clone2.TextColor3 = v110 > 0 and Color3.new(1, 1, 1) or Color3.new(1, 0, 0)
					v110 = Util:ConvertToAbbreviation(v110)
				end

				if v110.Name == "Money" then
					v110 = `${ v110 }`
				end

				clone2.Text = tostring(v110)
			end

			updateStat()

			if child then
				child:GetPropertyChangedSignal("Value"):Connect(updateStat)
			end
		end
	end

	local v68 = Network:FireServerConnection("ReturnCanChat", "REMOTE_FUNCTION", p8)

	if v6 or not v68 then
		clone.NoChat.Visible = true
		clone.NoChat.MouseEnter:Connect(function() -- line: 422
			-- upvalues: Util (copy)
			Util:CreateTooltip("You cannot communicate with this player.")
		end)
		clone.NoChat.MouseLeave:Connect(function() -- line: 425
			-- upvalues: Util (copy)
			Util:CreateTooltip()
		end)
	end

	clone.Parent = PlayerListUI.Contents.Players
	t1:__UpdateListSize()
end
function t1.RemovePlayerFromList(_: {[any]: any}, p9) -- line: 437
	-- upvalues: t1 (copy)
	local v71 = t1:GetPlayerListUI().Contents.Players:FindFirstChild((tostring(p9)))

	if v71 then
		v71:Destroy()
	end

	t1:__UpdateListSize()
end
function t1.__UpdateListSize(_) -- line: 450
	-- upvalues: t1 (copy)
	local PlayerListUI = t1:GetPlayerListUI()
	local UIListLayout = PlayerListUI.Contents.Players.UIListLayout
	local v75 = UIListLayout.AbsoluteContentSize.Y + UIListLayout.Padding.Offset

	PlayerListUI.Background.Size = UDim2.fromScale(1, (math.clamp(0.05 + 30 / PlayerListUI.AbsoluteSize.Y + v75 / PlayerListUI.AbsoluteSize.Y, 0, 1)))
	PlayerListUI.FriendBoost.Position = UDim2.fromScale(0, (math.clamp(0.05 + 30 / PlayerListUI.AbsoluteSize.Y + v75 / PlayerListUI.AbsoluteSize.Y, 0, 1)))
end
function t1.Start(p11) -- line: 460
	-- upvalues: LocalPlayer (copy), t1 (copy), t2 (copy), SocialService (copy), clamp (copy), Util (copy), u17 (ref), Sounds (copy)
	if game["Run Service"]:IsServer() then
		return
	end

	local clone = script.PlayerListHolder:Clone()
	local Contents = clone.Contents

	clone.Parent = LocalPlayer.PlayerGui:WaitForChild("MainUI")
	Contents:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 521
		-- upvalues: t1 (copy)
		t1:__UpdateListSize()
	end)

	for k, v in pairs(t1.DisplayedStats) do
		local clone3 = Contents.InfoTypes.Players:Clone()

		clone3.Name = v
		clone3.Text = t2[v] or v:gsub("(%l)(%u)", "%1 %2")
		clone3.Size = UDim2.fromScale(0.3, 1)
		clone3.LayoutOrder = k + 1
		clone3.TextXAlignment = Enum.TextXAlignment.Center
		clone3.Parent = Contents.InfoTypes
	end

	local _ = {
		JOINING = true,
		LEAVING = false
	}
	local ExperienceInviteOptions = Instance.new("ExperienceInviteOptions")

	ExperienceInviteOptions.PromptMessage = `Invite Friends, get { 10 }% more EXP per friend! (caps at { 20 }%).`

	local function __canSendInvite(p12) -- line: 547
		-- upvalues: SocialService (copy)
		local ok, result = pcall(function() -- line: 548
			-- upvalues: SocialService (copy), p12 (copy)
			return SocialService:CanSendGameInviteAsync(p12)
		end)

		return ok and result
	end

	local Button = clone.FriendBoost.Button

	Button.MouseButton1Down:Connect(function() -- line: 556
		-- upvalues: LocalPlayer (copy), SocialService (copy), ExperienceInviteOptions (copy)
		local v114 = LocalPlayer
		local ok, result = pcall(function() -- line: 548
			-- upvalues: SocialService (copy), v114 (copy)
			return SocialService:CanSendGameInviteAsync(v114)
		end)

		if ok and result then
			SocialService:PromptGameInvite(LocalPlayer, ExperienceInviteOptions)
		end
	end)

	local n2 = 0

	local function __setBoostDisplay(p13, b1: boolean) -- line: 564
		-- upvalues: LocalPlayer (copy), n2 (ref), clamp (copy), Button (copy)
		local ok, result = pcall(function() -- line: 566
			-- upvalues: LocalPlayer (copy), p13 (copy)
			return LocalPlayer:IsFriendsWith(p13.UserId)
		end)

		if ok and result then
			n2 = clamp(n2 + 10 * (not b1 and -1 or 1), 0, 20)
		end

		local v121 = `Invite Friends (+{ n2 }% EXP)`

		if v121 ~= Button.Text then
			Button.Text = v121
		end
	end

	Util.OnPlayerAdded(function(p14) -- line: 587
		-- upvalues: LocalPlayer (copy), n2 (ref), clamp (copy), Button (copy), t1 (copy)
		if p14 ~= LocalPlayer then
			local ok, result = pcall(function() -- line: 566
				-- upvalues: LocalPlayer (copy), p14 (copy)
				return LocalPlayer:IsFriendsWith(p14.UserId)
			end)

			if ok and result then
				n2 = clamp(n2 + 10, 0, 20)
			end

			local v125 = `Invite Friends (+{ n2 }% EXP)`

			if v125 ~= Button.Text then
				Button.Text = v125
			end
		end

		t1:CreatePlayerInList(p14)
	end)
	game.Players.PlayerRemoving:Connect(function(player) -- line: 596
		-- upvalues: LocalPlayer (copy), n2 (ref), clamp (copy), Button (copy), t1 (copy)
		if player ~= LocalPlayer then
			local ok, result = pcall(function() -- line: 566
				-- upvalues: LocalPlayer (copy), player (copy)
				return LocalPlayer:IsFriendsWith(player.UserId)
			end)

			if ok and result then
				n2 = clamp(n2 + -10, 0, 20)
			end

			local v129 = `Invite Friends (+{ n2 }% EXP)`

			if v129 ~= Button.Text then
				Button.Text = v129
			end
		end

		t1:RemovePlayerFromList(player)
	end)
	clone.Close.MouseButton1Click:Connect(function() -- line: 604
		-- upvalues: t1 (copy), u17 (ref)
		t1:TogglePlayerList(not u17)
	end)
	game.UserInputService.InputBegan:Connect(function(input, gameProcessed) -- line: 608
		-- upvalues: t1 (copy), u17 (ref)
		if gameProcessed then
			return
		end

		if input.KeyCode == Enum.KeyCode.Tab then
			t1:TogglePlayerList(not u17)
		end
	end)

	local function addSFX(p15) -- line: 616
		-- upvalues: Sounds (copy)
		if p15:IsA("ImageButton") or p15:IsA("TextButton") then
			p15.MouseEnter:Connect(function() -- line: 618
				-- upvalues: Sounds (copy)
				Sounds:Play("hover")
			end)
			p15.MouseLeave:Connect(function() -- line: 619
				-- upvalues: Sounds (copy)
				Sounds:Play("hoverEnd")
			end)
			p15.MouseButton1Click:Connect(function() -- line: 620
				-- upvalues: Sounds (copy)
				Sounds:Play("select")
			end)
		end
	end

	for _, descendant in pairs(clone:GetDescendants()) do
		addSFX(descendant)
	end

	clone.DescendantAdded:Connect(addSFX)
	p11.PlayerList = clone
	game.StarterGui:SetCoreGuiEnabled("PlayerList", false)
end

return t1

]========]},
{path=[========[
ReplicatedStorage/Systems/Player/UI/Menus/Stats]========],source=[========[
local t1 = {}
local DataHandler = require(game.ReplicatedStorage.Modules.DataHandler)

function t1.Start(_) -- line: 5
	-- upvalues: DataHandler (copy), t1 (copy)
	local _ = game.Players.LocalPlayer
	local Stats = DataHandler:Get():WaitForChild("Stats")

	t1.StatsMenu = require(game.ReplicatedStorage.Initializer).PlayerSystems.SidebarHandler:CreateSidebarMenu("Stats", script.StatsScreen)

	local Contents = t1.StatsMenu.Menu.StatsContainer.Contents
	local Templates = script.Templates

	local function createStatUI(p2, p3) -- line: 24
		-- upvalues: Templates (copy), Contents (copy), createStatUI (copy)
		if not p3 then
			p3 = 0
		end

		local LayoutOrder = p2:GetAttribute("LayoutOrder")

		if not LayoutOrder then
			return
		end

		local DisplayTitle = p2:GetAttribute("DisplayTitle")

		if not DisplayTitle then
			return
		end

		local PostDisplayTitle = p2:GetAttribute("PostDisplayTitle")

		if p2:IsA("Folder") then
			local clone = Templates.Seperator:Clone()

			clone.Name = p2.Name
			clone.LayoutOrder = LayoutOrder * 100 + p3
			clone.Title.Text = DisplayTitle
			clone.Parent = Contents

			for _, child in pairs(p2:GetChildren()) do
				createStatUI(child, LayoutOrder * 100)
			end

			return
		end

		if p2:IsA("NumberValue") then
			local clone = Templates.Title:Clone()

			clone.Name = p2.Name
			clone.LayoutOrder = LayoutOrder + p3
			clone.Parent = Contents

			local function setText() -- line: 51
				-- upvalues: PostDisplayTitle (copy), clone (copy), DisplayTitle (copy), p2 (copy)
				if PostDisplayTitle == "Time" then
					local Util = require(game.ReplicatedStorage.Modules.Util)

					clone.Text = `{ DisplayTitle }: { Util:FormatTime(p2.Value, "String") }`
				else
					clone.Text = `{ DisplayTitle }: { p2.Value }{ PostDisplayTitle or "" }`
				end

				if p2:GetAttribute("HideIfZero") then
					clone.Visible = p2.Value ~= 0
				end
			end

			p2:GetPropertyChangedSignal("Value"):Connect(setText)
			setText()
		end
	end

	for _, child in pairs(Stats:GetChildren()) do
		createStatUI(child)
	end
end

return t1
]========]},
{path=[========[
ServerScriptService/Server/Modules/Commands/ToggleFriendlyFire]========],source=[========[
-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

return {
	LayoutOrder = 95,
	RequiredRank = "HeadModerator",
	Executable = true,
	Parameters = {},
	Title = "Enable Friendly Fire",
	ResetOnExecution = false,
	DisplayedAttribute = "FriendlyFire",
	AllowedInVIP = true,
    Executed = function(_, _) --[[ Line: 9 ]] --[[ Name: Executed ]]
        local l_workspace_Attribute_0 = workspace:GetAttribute("FriendlyFire");
        workspace:SetAttribute("FriendlyFire", not l_workspace_Attribute_0);
	end,
};]========]}
}
local selection={}
local originalStats
local function locate(path)local object=game;for name in path:gmatch("[^/]+")do object=object and object:FindFirstChild(name)end;return object end
local function ensure(path,class)
 local object=game;local parts=string.split(path,"/")
 for i,name in parts do object=object:FindFirstChild(name)or child(object,name,i==#parts and class or "Folder")end
 return object
end
local function fixture()
 fresh();selection={}
 local get=game.GetService
 function game:GetService(name)if name=="Selection"then return {Get=function()return selection end}end;return get(self,name)end
 for _,item in sourceData do ensure(item.path,"ModuleScript").Source=item.source end
 originalStats=ensure("ServerScriptService/Server/Systems/Data/PlayerData/Template/Stats")
 local general=child(originalStats,"General");child(general,"TimePlayed","NumberValue").Value=37
 local surv=child(originalStats,"SurvivorStats");child(surv,"SurvivorWins","NumberValue").Value=9
 child(originalStats,"KillerStats")
 local currency=child(originalStats,"Currency");child(currency,"Money","NumberValue").Value=500;child(currency,"RbxSpent","NumberValue").Value=300
 workspace:SetAttribute("FriendlyFire",false)
end
local function install()
assert(game:GetService("RunService"):IsStudio()and not game:GetService("RunService"):IsRunning(),"Stop Play first.")
local function find(path)
 local object=game
 for name in path:gmatch("[^/]+")do object=object and object:FindFirstChild(name)end
 return object
end
local function fingerprint(s)
 local a,b=5381,0
 for i=1,#s do local v=s:byte(i);a=(a*33+v)%4294967296;b=(b*65599+v)%4294967296 end
 return string.format("%d:%08x:%08x",#s,a,b)
end
local function ref(parent,name,value)local object=Instance.new("ObjectValue");object.Name=name;object.Value=value;object.Parent=parent end
local parent=assert(find("ServerScriptService/Server/Systems/Data"))
if parent:FindFirstChild("CombatStatistics")then
 assert(parent.CombatStatistics:GetAttribute("Version")=="1.0.0","Unknown CombatStatistics module. Nothing changed.")
 print("[FB stats] Already installed.");return
end
local changes={
{path=[========[
ReplicatedStorage/Assets/Survivors/Builderman/Behavior/Server]========],expected=[========[
21571:eeae1a80:5a71d021]========],after=[========[
local RunService=game:GetService("RunService")
local Debris=game:GetService("Debris")
local Modules=game.ReplicatedStorage.Modules
local Actors=require(Modules.Actors)
local Util=require(Modules.Util)
local Statuses=require(Modules.Statuses)
local Sounds=require(Modules.Sounds)
local Network=require(Modules.Network)
local TweenService=game:GetService("TweenService")
local Rules=require(script.Parent.Rules)
local Server={}
local buildings={}
local function clock()return workspace:GetServerTimeNow()end
local function alive(rig)
 local hum=rig and rig:FindFirstChildOfClass("Humanoid")
 return rig and rig.Parent and rig.PrimaryPart and hum and hum.Health>0
end
local function active(a)return not a.BuilderDestroyed and alive(a.Rig)end
local function emit(a,name,...)
 if a.Player and a.Player:IsA("Player")then Network:FireClientConnection(a.Player,a.Player.Name..name,"REMOTE_EVENT",...)end
end
local function broadcast(a,name,...)
 if a.Player then Network:FireAllClientConnection(a.Player.Name..name,"REMOTE_EVENT",...)end
end
local function sound(a,key,part,loop)
 local id=a.Config.Sounds and a.Config.Sounds[key]
 if not id or id==""then return end
 local ok,result=pcall(Sounds.Play,Sounds,id,{Parent=part,Looped=loop or false})
 if ok then return result end
end
local function track(a,state,name)
 local id=a.Config[state.kind.."Animations"]and a.Config[state.kind.."Animations"][name]
 if not id then return end
 local ok,result=pcall(Util.LoadAnimationFromID,Util,state.model,id)
 if ok and result then pcall(function()result.Looped=name=="Idle"or name=="CarryIdle"or name=="CarryWalk";result:Play(.1)end);return result end
end
local function stopTrack(value)if value then pcall(function()value:Stop(.1)end)end end
local function killerDamage(rig)
 local stamp=rig:GetAttribute("RecentAttackerTime")
 if type(stamp)~="number"or math.abs(os.clock()-stamp)>.25 then return false end
 local name=rig:GetAttribute("RecentAttacker")
 for _,actor in Actors.CurrentActors do
  if actor.Rig and actor.Rig.Parent==workspace.Players.Killers and (tostring(actor.Player)==name or actor.Rig.Name==name)then return true end
 end
 return false
end
local function count(kind)
 local n=0
 for _,state in buildings do if state.kind==kind and state.phase=="active"and state.model.Parent then n+=1 end end
 return n
end
local function builders()
 local n=0
 for _,a in Actors.CurrentActors do if a.ActorName=="Builderman"and a.Rig.Parent==workspace.Players.Survivors and alive(a.Rig)then n+=1 end end
 return n
end
local function setState(state,phase)
 state.phase=phase
 local m=state.model
 m:SetAttribute("Carrying",phase=="carry")
 m:SetAttribute("Constructed",phase=="active"or phase=="carry")
 m:SetAttribute("Disabled",phase~="active")
 for _,object in m:GetDescendants()do
  if object:IsA("BasePart")then object.Anchored=phase~="carry"and object==m.PrimaryPart;object.Massless=phase=="carry"or object:GetAttribute("BuilderOriginalMassless")==true;object.CanCollide=phase=="active"and object:GetAttribute("BuilderOriginalCollide")==true
  elseif object:IsA("ParticleEmitter")or object:IsA("Light")then object.Enabled=phase=="active"and object.Name~="Shoot"end
 end
end
local function tools(a,show)
 for _,object in a.Rig:GetChildren()do if object:IsA("BasePart")and(object.Name:find("Hammer")or object.Name:find("Wrench"))then object.Transparency=show and 0 or 1 end end
end
local function result(a,value)
 local old=a.Rig:FindFirstChild("Result");if old then old:Destroy()end
 local object=Instance.new("StringValue");object.Name="Result";object.Value=value;object.Parent=a.Rig;Debris:AddItem(object,2)
end
local function unlockCast(a)
 if a.BuilderCastSpeed then a.BuilderCastSpeed:Destroy();a.BuilderCastSpeed=nil end
 a:DisableAbilities("BuildermanConstruct",false)
 a.Rig:SetAttribute("PlacementRadius",nil)
 tools(a,false)
 if active(a)and a.ChangeExpression then a:ChangeExpression("Default")end
end
local function unlockPickup(a)
 a.BuilderPickupUntil=nil
 if a.BuilderPickupSpeed then a.BuilderPickupSpeed:Destroy();a.BuilderPickupSpeed=nil end
 a:DisableAbilities("BuildermanPickup",false)
end
local function clearCarry(a)
 unlockPickup(a)
 local carried=a.CarryingBuilding
 if carried and carried.weld then carried.weld:Destroy();carried.weld=nil end
 a.CarryingBuilding=nil
 if a.BuilderCarrySpeed then a.BuilderCarrySpeed:Destroy();a.BuilderCarrySpeed=nil end
 if a.Rig then a.Rig:SetAttribute("BuildermanCarrying",nil)end
 emit(a,"ForceDropBuilding")
 if a.Player and a.Player:IsA("Player")then Network:FireClientConnection(a.Player,"DisableSprintingSV","REMOTE_EVENT","CarryingBuilding",false)end
end
local function unlockPlacement(a,state)
 if state and a.BuilderPlacing~=state then return end
 a.BuilderPlacing=nil
 if a.BuilderPlaceSpeed then a.BuilderPlaceSpeed:Destroy();a.BuilderPlaceSpeed=nil end
 a:DisableAbilities("BuildermanPlacement",false)
 if a.Player and a.Player:IsA("Player")then Network:FireClientConnection(a.Player,"DisableSprintingSV","REMOTE_EVENT","BuildermanPlacement",false)end
end
local function reveal(a,state)
 if state.revealed then return end
 state.revealed=true
 for part,transparency in state.transparencies do
  if part.Parent then part.Transparency=transparency;part.CanQuery=true end
 end
 stopTrack(state.animation);state.animation=track(a,state,"Construction")
end
local function restPose(state)
 stopTrack(state.animation);state.animation=nil
 local hum=state.model:FindFirstChildOfClass("Humanoid")
 local animator=hum and hum:FindFirstChildOfClass("Animator")
 if animator then for _,animation in animator:GetPlayingAnimationTracks()do animation:Stop(0)end end
 for joint,pose in state.restJoints or {}do
  if joint.Parent then joint.C0=pose.C0;joint.C1=pose.C1;joint.Transform=CFrame.new()end
 end
end
local function explodeBuilding(state)
 local model=state.model
 local root=model.PrimaryPart
 if not root then model:Destroy();return end
 local position=root.Position
 for _,object in model:GetDescendants()do
  if object:IsA("JointInstance")or object:IsA("WeldConstraint")then object:Destroy()end
 end
 local explosion=Instance.new("Explosion")
 explosion.Position=position;explosion.BlastRadius=8;explosion.BlastPressure=0
 explosion.DestroyJointRadiusPercent=0;explosion.ExplosionType=Enum.ExplosionType.NoCraters
 explosion.Parent=workspace;Debris:AddItem(explosion,2)
 for _,part in model:GetDescendants()do
  if part:IsA("BasePart")then
   part.Anchored=false;part.CanCollide=false;part.CanTouch=false;part.CanQuery=false
   if part.Transparency<1 then
    part.AssemblyLinearVelocity=Vector3.new(math.random(-8,8),math.random(8,13),math.random(-8,8))
    local fire=Instance.new("Fire");fire.Heat=1;fire.Size=math.min(5,part.Size.Magnitude);fire.Parent=part
    TweenService:Create(part,TweenInfo.new(1.5),{Transparency=1}):Play()
   end
  end
 end
end
local function destroy(a,state,killer)
 if not state or state.phase=="destroyed"then return end
 if a.BuilderCast==state then a.BuilderCast=nil;unlockCast(a);result(a,"failed")end
 if a.BuilderPlacing==state then unlockPlacement(a,state)end
 if a.CarryingBuilding==state then clearCarry(a)end
 setState(state,"destroyed")
 state.model:SetAttribute("Destroyed",true)
 if state.health then state.health:Disconnect()end
 stopTrack(state.animation)
 if state.loop then state.loop:Destroy();state.loop=nil end
 buildings[state.model]=nil
 if a.Buildings[state.kind]==state then a.Buildings[state.kind]=nil end
 a.DisabledAbilities[state.kind]=nil
 emit(a,"UpdateBuildingAbilityLock",state.kind,"recentactivity",false)
 broadcast(a,"ReplicateDestroyedBuildingAsync",state.kind)
 if killer and active(a)then
  a:SetCooldownOf(state.kind,a.Config[state.kind.."DestroyedCooldown"])
  if a.Player and a.Player:IsA("Player")then
   Actors:IncrementActorStats(a.Player,{Action=state.kind.." was destroyed",RewardType="Survivalist"})
   local value=state.model:GetAttribute(state.kind=="Sentry"and "DamageDealt"or "TotalHealed")or 0
   local points=Rules.Points(state.kind,value)
   if points>0 then Actors:IncrementActorStats(a.Player,{Action=state.kind.." contribution",Money=points,EXP=math.ceil(points*.5)})end
  end
 end
 sound(a,state.kind.."Destroyed",state.model.PrimaryPart)
 explodeBuilding(state)
 Debris:AddItem(state.model,2)
end
local function requestedFacing(a,frame)
 local root=a.Rig.PrimaryPart
 if typeof(frame)~="CFrame"then return root.CFrame end
 for _,value in {frame:GetComponents()}do if value~=value or math.abs(value)==math.huge then return root.CFrame end end
 if (frame.Position-root.Position).Magnitude>6 then return root.CFrame end
 local look=Vector3.new(frame.LookVector.X,0,frame.LookVector.Z)
 if look.Magnitude<.01 then return root.CFrame end
 return CFrame.lookAt(frame.Position,frame.Position+look)
end
local function placement(a,kind,ignore,frame)
 local root=a.Rig.PrimaryPart
 local facing=frame or root.CFrame
 local target=facing*CFrame.new(0,0,-a.Config[kind.."PositionOffset"])
 local params=RaycastParams.new();params.FilterType=Enum.RaycastFilterType.Exclude;params.RespectCanCollide=true
 params.FilterDescendantsInstances={workspace.Players,ignore or a.Rig}
 local floor=workspace:Raycast(target.Position+Vector3.new(0,1,0),Vector3.new(0,-6,0),params)
 if not floor or floor.Normal.Y<.65 then return nil,"midair"end
 if floor.Instance.Name=="Conveyor"then return nil,"collision"end
 if workspace:Raycast(facing.Position,target.Position-facing.Position,params)then return nil,"facingWall"end
 for _,state in buildings do
  if state.model~=ignore and state.phase~="destroyed"and state.phase~="carry"and state.model.Parent then
   local radius=a.Config[state.kind.."PlacementRadius"]/2
   if(target.Position-state.model.PrimaryPart.Position).Magnitude<=radius then return nil,"tooClose"end
  end
 end
 local overlap=OverlapParams.new();overlap.FilterType=Enum.RaycastFilterType.Exclude;overlap.RespectCanCollide=true
 overlap.FilterDescendantsInstances={workspace.Players,ignore or a.Rig}
 for _,part in workspace:GetPartBoundsInBox(CFrame.new(target.Position.X,floor.Position.Y+1.75,target.Position.Z),Vector3.new(2.5,2.5,2.5),overlap)do
  if part~=floor.Instance and(part.Transparency<.9 or part.Name=="UnplacableArea")then return nil,"collision"end
 end
 return CFrame.new(target.Position.X,floor.Position.Y,target.Position.Z)*target.Rotation
end
local function groundPivot(model,cf,cachedLift)
 local root=model.PrimaryPart
 local lowest=math.huge
 if cachedLift then model:PivotTo(cf*CFrame.new(0,cachedLift,0));return cachedLift end
 for _,part in model:GetDescendants()do
  if part:IsA("BasePart")and part.Transparency<1 then
   local rel=root.CFrame:ToObjectSpace(part.CFrame)
   local half=part.Size*.5
   local extent=math.abs(rel.RightVector.Y)*half.X+math.abs(rel.UpVector.Y)*half.Y+math.abs(rel.LookVector.Y)*half.Z
   lowest=math.min(lowest,rel.Position.Y-extent)
  end
 end
 if lowest==math.huge then lowest=-root.Size.Y*.5 end
 local lift=-lowest+.03
 model:PivotTo(cf*CFrame.new(0,lift,0))
 return lift
end
local function ready(a,state)
 if state.phase=="destroyed"or not active(a)then return end
 reveal(a,state)
 if a.BuilderPlacing==state then unlockPlacement(a,state)end
 if a.BuilderCast==state then a.BuilderCast=nil;unlockCast(a);result(a,"success")end
 if state.loop then state.loop:Destroy();state.loop=nil end
 stopTrack(state.animation)
 if state.placedCF then groundPivot(state.model,state.placedCF,state.groundLift)end
 setState(state,"active");state.activeAt=clock()
 state.animation=track(a,state,"Idle")
 state.loop=sound(a,state.kind.."Idle",state.model.PrimaryPart,true)
end
local function construct(a,kind,frame)
 if not active(a)or a.BuilderCast or a.BuilderPlacing or a.CarryingBuilding then return {Cancelled=true,Reason="carrying"}end
 local old=a.Buildings[kind]
 if old and Rules.ActivityRemaining(old.model:GetAttribute("LastActiveTime"),clock())>0 then return {Cancelled=true,Reason="recentActivity"}end
 if a:IsOnCooldown(kind)then return {Cancelled=true,Reason="cooldown"}end
 local cf,reason=placement(a,kind,old and old.model,requestedFacing(a,frame))
 if not cf then return {Cancelled=true,Reason=reason}end
 if old then destroy(a,old,false)end
 local model=(a.Config[kind.."Template"]or a.Config.Instances[kind.."Template"]):Clone()
 local hum=model:FindFirstChildOfClass("Humanoid")
 model.PrimaryPart=model:FindFirstChild("Root")or model.PrimaryPart
 if not hum or not model.PrimaryPart then model:Destroy();return {Cancelled=true,Reason="unknown"}end
 if not hum:FindFirstChildOfClass("Animator")then Instance.new("Animator",hum)end
 hum.MaxHealth=a.Config[kind.."Health"];hum.Health=hum.MaxHealth;hum.BreakJointsOnDeath=false;hum.EvaluateStateMachine=false
 model.Name="Builderman"..kind
 model:SetAttribute("OwnerName",tostring(a.Player));model:SetAttribute("Team","Survivors");model:SetAttribute("HitboxPriority",0)
 model:AddTag("SurvivorConstruct")
 for _,part in model:GetDescendants()do
  if part:IsA("BasePart")then part:SetAttribute("BuilderOriginalCollide",part.CanCollide);part:SetAttribute("BuilderOriginalMassless",part.Massless);part.CanQuery=true end
 end
 local groundLift=groundPivot(model,cf)
 local state={restJoints={},groundLift=groundLift,placedCF=cf,model=model,kind=kind,phase="building",completeAt=clock()+a.Config[kind.."ConstructionDuration"],revealAt=clock()+a.Config.ConstructionWindup,transparencies={}}
 for _,joint in model:GetDescendants()do if joint:IsA("Motor6D")then state.restJoints[joint]={C0=joint.C0,C1=joint.C1}end end
 a.Buildings[kind]=state;buildings[model]=state;a.BuilderCast=state
 setState(state,"building")
 for _,part in model:GetDescendants()do
  if part:IsA("BasePart")then state.transparencies[part]=part.Transparency;part.Transparency=1;part.CanQuery=false end
 end
 model.Parent=workspace.Map.Ingame
 local previousHealth=hum.Health
 state.health=hum.HealthChanged:Connect(function(value)
  local hurt=value<previousHealth;previousHealth=value
  if value<=0 or hurt and state.phase=="building"then destroy(a,state,killerDamage(model))end
 end)
 local oldResult=a.Rig:FindFirstChild("Result");if oldResult then oldResult:Destroy()end
 a:DisableAbilities("BuildermanConstruct",true)
 a.BuilderCastSpeed=Util:CreateSpeedMultiplier(a.Rig,0,"BuildermanConstruction")
 a.Rig:SetAttribute("PlacementRadius",a.Config[kind.."PlacementRadius"])
 tools(a,true)
 if a.ChangeExpression then a:ChangeExpression("Concentrating")end
 state.loop=sound(a,kind.."Building",model.PrimaryPart,true)
 broadcast(a,"ReplicateBuildingAsync",model,kind)
 for _,other in Actors.CurrentActors do
  if other.Player and other.Player:IsA("Player")and alive(other.Rig)and other.Rig.Parent==workspace.Players.Survivors then
   pcall(Util.RevealPlayerAuraTo,Util,other.Player,model,a.Config[kind.."PingDuration"],Color3.new(.75,1,.75))
  end
 end
 return {Duration=a.Config[kind.."ConstructionDuration"]}
end
local function closest(a)
 local best,range=nil,a.Config.CarryRange
 for _,state in a.Buildings do
  if state.phase=="active"and state.model.Parent then
   local distance=(state.model.PrimaryPart.Position-a.Rig.PrimaryPart.Position).Magnitude
   if distance<=range then best=state;range=distance end
  end
 end
 return best
end
local function move(a)
 if not active(a)or a.BuilderCast or a.BuilderPlacing then return "noBuilding"end
 if a.MoveReadyAt and clock()<a.MoveReadyAt then return "cooldown"end
 local state=a.CarryingBuilding
 if state then
  local cf,reason=placement(a,state.kind,state.model)
  if not cf then return reason end
  clearCarry(a)
  restPose(state)
  groundPivot(state.model,cf,state.groundLift)
  state.placedCF=cf
  setState(state,"placing");state.completeAt=clock()+a.Config.CarryPlacementDuration
  a.BuilderPlacing=state
  a.BuilderPlaceSpeed=Util:CreateSpeedMultiplier(a.Rig,0,"BuildermanPlacement")
  a:DisableAbilities("BuildermanPlacement",true)
  if a.Player and a.Player:IsA("Player")then Network:FireClientConnection(a.Player,"DisableSprintingSV","REMOTE_EVENT","BuildermanPlacement",true)end
  -- The character performs PutDown; the world machine stays in its grounded resting pose.
  sound(a,state.kind.."Putdown",state.model.PrimaryPart)
  a.MoveReadyAt=clock()+a.Config.CarryPlacementDuration
  a:SetCooldownOf("Move",a.Config.CarryPlacementDuration)
  return false
 end
 state=closest(a)
 if not state then return "noBuilding"end
 a.CarryingBuilding=state
 setState(state,"carry")
 if state.loop then state.loop:Destroy();state.loop=nil end
 stopTrack(state.animation);state.animation=track(a,state,"PickUp");state.carryAnimReady=clock()+a.Config[state.kind.."PickupDebounce"];state.walking=nil
 a.BuilderCarrySpeed=Util:CreateSpeedMultiplier(a.Rig,a.Config.CarryWalkspeed,"CarryingBuilding")
 a.Rig:SetAttribute("BuildermanCarrying",true)
 if a.Player and a.Player:IsA("Player")then Network:FireClientConnection(a.Player,"DisableSprintingSV","REMOTE_EVENT","CarryingBuilding",true)end
 state.model:PivotTo(a.Rig.PrimaryPart.CFrame*a.Config[state.kind.."PickupOffset"])
 local weld=Instance.new("Weld");weld.Name="BuildermanCarryMount";weld.Part0=a.Rig.PrimaryPart;weld.Part1=state.model.PrimaryPart
 weld.C0=a.Config[state.kind.."PickupOffset"];weld.C1=CFrame.new();weld.Parent=state.model.PrimaryPart
 state.weld=weld
 a.MoveReadyAt=clock()+a.Config[state.kind.."PickupDebounce"]
 a.BuilderPickupUntil=a.MoveReadyAt
 a.BuilderPickupSpeed=Util:CreateSpeedMultiplier(a.Rig,0,"BuildermanPickup")
 a:DisableAbilities("BuildermanPickup",true)
 a:SetCooldownOf("Move",a.Config[state.kind.."PickupDebounce"])
 sound(a,state.kind.."Pickup",state.model.PrimaryPart)
 return state.model
end
local function lineOfSight(state,target)
 local params=RaycastParams.new();params.FilterType=Enum.RaycastFilterType.Exclude
 local excluded={workspace.Players.Survivors}
 for _,entry in buildings do table.insert(excluded,entry.model)end
 params.FilterDescendantsInstances=excluded
 local origin=state.model.PrimaryPart.Position
 local hit=workspace:Raycast(origin,target.PrimaryPart.Position-origin,params)
 return not hit or hit.Instance:IsDescendantOf(target)
end
local function tickBuilding(a,state,dt)
 if state.phase=="destroyed"then return end
 if not state.model.Parent then destroy(a,state,false);return end
 if state.phase=="building"or state.phase=="placing"then
  if clock()>=state.completeAt then ready(a,state)end
  return
 end
 if state.phase=="carry"then
  if clock()>=(state.carryAnimReady or 0)then
   local walking=a.Rig.PrimaryPart.AssemblyLinearVelocity.Magnitude>1
   if state.walking~=walking then
    state.walking=walking;stopTrack(state.animation);state.animation=track(a,state,walking and "CarryWalk"or "CarryIdle")
   end
  end
  return
 end
 dt=math.min(dt,math.max(0,clock()-(state.activeAt or clock())))
 if dt<=0 then return end
 local n=count(state.kind)
 state.model:SetAttribute("BuildingCount",n)
 local radius=Rules.EffectRadius(a.Config,state.kind,n)
 state.model:SetAttribute("EffectRadiusSize",radius)
 if state.kind=="Sentry"then
  local nearest,distance=nil,radius
  for _,other in Actors.CurrentActors do
   if alive(other.Rig)and other.Rig.Parent==workspace.Players.Killers then
    local d=(other.Rig.PrimaryPart.Position-state.model.PrimaryPart.Position).Magnitude
    if d<=distance and lineOfSight(state,other.Rig)then nearest=other;distance=d end
   end
  end
  if nearest then
   local hum=nearest.Rig:FindFirstChildOfClass("Humanoid")
   local damage=math.min(hum.Health,a.Config.SentryDamagePerSec*dt)
   if damage>0 then require(game.ServerScriptService.Server.Systems.Data.CombatStatistics):RecordDamage(a.Player,a.Rig,nearest.Rig)end
   hum.Health-=damage
   if damage>0 then
    state.model:SetAttribute("DamageDealt",(state.model:GetAttribute("DamageDealt")or 0)+damage)
    state.model:SetAttribute("LastActiveTime",clock())
    Statuses:ApplyStatus(nearest.Rig,"Slowness",{Level=Rules.SlowLevel(a.Config,builders()),Duration=a.Config.SentrySlownessDuration})
    if not state.nextShotSound or clock()>=state.nextShotSound then sound(a,"SentryShoot",state.model.PrimaryPart);state.nextShotSound=clock()+.2 end
   end
  end
 else
  for _,other in Actors.CurrentActors do
   if alive(other.Rig)and other.Rig.Parent==workspace.Players.Survivors and(other.Rig.PrimaryPart.Position-state.model.PrimaryPart.Position).Magnitude<=radius then
    local hum=other.Rig:FindFirstChildOfClass("Humanoid")
    if hum.Health<hum.MaxHealth and not hum:GetAttribute("Clanker")then
     local before=hum.Health;Util:Heal(hum,a.Config.DispenserHealingPerSec*dt)
     local healed=math.max(0,hum.Health-before)
     if healed>0 then state.model:SetAttribute("TotalHealed",(state.model:GetAttribute("TotalHealed")or 0)+healed);state.model:SetAttribute("LastActiveTime",clock())end
    end
   end
  end
 end
end
function Server.Created(_,a)
 a.BuilderDestroyed=false;a.Buildings={};a.DisabledAbilities=a.DisabledAbilities or {};a.BuilderConnections={}
 a.Rig:SetAttribute("IsBuilderman",true)
 local hum=a.Rig:FindFirstChildOfClass("Humanoid");local health=hum.Health
 table.insert(a.BuilderConnections,hum.HealthChanged:Connect(function(value)
  local damage=health-value;health=value
  if a.BuilderCast and damage>0 then destroy(a,a.BuilderCast,false)end
  if a.CarryingBuilding and damage>=a.Config.CarryDamageThreshold then destroy(a,a.CarryingBuilding,killerDamage(a.Rig))end
  if value<=0 then Server.Destroyed(nil,a)end
 end))
 local accumulator=0
 table.insert(a.BuilderConnections,RunService.Heartbeat:Connect(function(dt)
  if not active(a)then Server.Destroyed(nil,a);return end
  if a.BuilderPickupUntil and clock()>=a.BuilderPickupUntil then unlockPickup(a)end
  for _,state in table.clone(a.Buildings)do
   if state.phase=="building"and not state.revealed and clock()>=state.revealAt then reveal(a,state)end
   if (state.phase=="building"or state.phase=="placing")and clock()>=state.completeAt then ready(a,state)end
  end
  accumulator+=dt;if accumulator<.1 then return end
  local elapsed=accumulator;accumulator=0
  for _,state in table.clone(a.Buildings)do tickBuilding(a,state,elapsed)end
  for _,kind in {"Sentry","Dispenser"}do
   local state=a.Buildings[kind]
   local locked=state and Rules.ActivityRemaining(state.model:GetAttribute("LastActiveTime"),clock())>0 or false
   if a.DisabledAbilities[kind]~=locked then a.DisabledAbilities[kind]=locked;emit(a,"UpdateBuildingAbilityLock",kind,"recentactivity",locked)end
  end
  local selected=a.CarryingBuilding or closest(a)
  if a.BuilderClosest~=selected then a.BuilderClosest=selected;emit(a,"UpdateClosestBuilding",selected and selected.model or nil)end
  if a.CarryingBuilding then local canPlace=placement(a,a.CarryingBuilding.kind,a.CarryingBuilding.model)~=nil;emit(a,"UpdateCanPlace",canPlace)end
 end))
end
function Server.Use(a,kind,frame)
 if kind=="Move"then return move(a)end
 local response=construct(a,kind,frame)
 if response and response.Cancelled then emit(a,"ConstructionRejected",response.Reason)end
 return response
end
function Server.Destroyed(_,a)
 if a.BuilderDestroyed then return end
 a.BuilderDestroyed=true
 for _,connection in a.BuilderConnections or {}do connection:Disconnect()end
 for _,state in table.clone(a.Buildings or {})do destroy(a,state,false)end
 clearCarry(a);unlockCast(a);unlockPlacement(a)
 a.DisabledAbilities.Sentry=nil;a.DisabledAbilities.Dispenser=nil
end
return Server
]========]},
{path=[========[
ReplicatedStorage/Assets/Survivors/Elliot/Behavior/Server]========],expected=[========[
13236:be9e77bc:77163f1d]========],after=[========[
local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local Modules=game.ReplicatedStorage.Modules
local Actors=require(Modules.Actors)
local Statuses=require(Modules.Statuses)
local Util=require(Modules.Util)
local Sounds=require(Modules.Sounds)
local Network=require(Modules.Network)
local Rules=require(script.Parent.Rules)
local Server={}
local function alive(rig)
 local hum=rig and rig:FindFirstChildOfClass("Humanoid")
 return rig and rig.Parent and rig.PrimaryPart and hum and hum.Health>0
end
local function active(a)return not a.ElliotDestroyed and alive(a.Rig)end
local function actorFor(rig)
 for _,a in Actors.CurrentActors do if a.Rig==rig then return a end end
end
local function team(rig,name)return rig and rig.Parent==workspace.Players:FindFirstChild(name)end
local function sound(a,key,parent)
 local id=a.Config.Sounds and a.Config.Sounds[key]
 if id and id~=""then pcall(Sounds.Play,Sounds,id,{Parent=parent or a.Rig.PrimaryPart})end
end
local function invoke(a,name,...)
 local method=a.Behavior[name]
 if method then pcall(method,a.Behavior,a,...)end
end
local function nearest(a)
 local best,distance=nil,a.Config.RushHourKillerRange
 for _,other in Actors.CurrentActors do
  if team(other.Rig,"Killers")and alive(other.Rig)then
   local d=(other.Rig.PrimaryPart.Position-a.Rig.PrimaryPart.Position).Magnitude
   if d<=distance then best=other;distance=d end
  end
 end
 return best
end
local function charges(a,level)
 local ability=a.Behavior.Abilities.RushHour
 local n=Rules.Level(level)
 if a.IncrementCharges then a:IncrementCharges("RushHour",n-(ability.CurrentCharges or 0),3)else ability.CurrentCharges=n end
 a.Rig:SetAttribute("ElliotRushCharges",n)
end
local function releaseRush(a)
 local rush=a.ElliotRush
 if not rush then return end
 a.ElliotRush=nil
 if rush.mountConnection then rush.mountConnection:Disconnect()end
 if rush.scooter then rush.scooter:Destroy()end
 if a.Rig and a.Rig.Parent then a.Rig:SetAttribute("ElliotRushing",nil)end
end
local function scooter(a)
 if a.Config.UsesScooter==false then return end
 local template=a.Config.Instances and a.Config.Instances.CustomScooter
 if not template or not template:IsA("Model")then return end
 local model=template:Clone()
 local handle=model:FindFirstChild("ScooterHandle")or model.PrimaryPart
 local torso=a.Rig:FindFirstChild("HumanoidRootPart")or a.Rig.PrimaryPart
 if not handle or not torso then model:Destroy();return end
 for _,object in model:GetDescendants()do
  if object:IsA("BasePart")then
   object.Anchored=false;object.CanCollide=false;object.CanTouch=false;object.CanQuery=false;object.Massless=true
   if object~=handle and (object.Name=="Scooter"or object:IsA("MeshPart"))then
    object.Transparency=0;object.LocalTransparencyModifier=0
   end
  elseif object:IsA("LuaSourceContainer")then object:Destroy()end
 end
 model.PrimaryPart=handle
 model:PivotTo(torso.CFrame)
 local oldJoint=model:FindFirstChild("ScooterJoint",true)
 if oldJoint then oldJoint:Destroy()end
 local joint=Instance.new("Weld")
 joint.Name="ElliotScooterMount";joint.Part0=torso;joint.Part1=handle;joint.Parent=handle
 joint.C1=CFrame.new()
 local base=a.Config.RushHourScooterOffset or CFrame.new()
 local geometry={}
 for _,part in model:GetDescendants()do
  if part:IsA("BasePart")and part~=handle and part.Transparency<1 then
   table.insert(geometry,{relative=handle.CFrame:ToObjectSpace(part.CFrame),half=part.Size*.5})
  end
 end
 if not a.Config.RushHourScooterOffset and #geometry>0 then
  local minimum=Vector3.new(math.huge,math.huge,math.huge)
  local maximum=Vector3.new(-math.huge,-math.huge,-math.huge)
  for _,shape in geometry do
   for x=-1,1,2 do for y=-1,1,2 do for z=-1,1,2 do
    local point=shape.relative:PointToWorldSpace(Vector3.new(x*shape.half.X,y*shape.half.Y,z*shape.half.Z))
    minimum=Vector3.new(math.min(minimum.X,point.X),math.min(minimum.Y,point.Y),math.min(minimum.Z,point.Z))
    maximum=Vector3.new(math.max(maximum.X,point.X),math.max(maximum.Y,point.Y),math.max(maximum.Z,point.Z))
   end end end
  end
  base=CFrame.new(-(minimum.X+maximum.X)*.5,0,-(minimum.Z+maximum.Z)*.5)
 end
 local params=RaycastParams.new()
 params.FilterType=Enum.RaycastFilterType.Include
 params.FilterDescendantsInstances={workspace.Map}
 params.IgnoreWater=true
 model.Name="ElliotRushScooter";model:SetAttribute("ElliotMountVersion","RigidCentered");model.Parent=a.Rig
 local connection
 local function updateMount()
  if not model.Parent or not torso.Parent then
   if connection then connection:Disconnect()end
   return
  end
  local mount=torso.CFrame*base
  local bottom=math.huge
  for _,shape in geometry do
   local cf=mount*shape.relative
   local half=shape.half
   local extent=math.abs(cf.RightVector.Y)*half.X+math.abs(cf.UpVector.Y)*half.Y+math.abs(cf.LookVector.Y)*half.Z
   bottom=math.min(bottom,cf.Position.Y-extent)
  end
  local floor=workspace:Raycast(torso.Position+Vector3.new(0,2,0),Vector3.new(0,-8,0),params)
  local lift=0
  if floor and bottom<math.huge then lift=math.max(0,floor.Position.Y+.06-bottom)end
  local localLift=torso.CFrame:VectorToObjectSpace(Vector3.new(0,lift,0))
  joint.C0=CFrame.new(localLift)*base
 end
 updateMount()
 connection=RunService.Heartbeat:Connect(updateMount)
 return model,connection
end
local function reward(a,kind)
 if not a.Player or not a.Player:IsA("Player")then return end
 -- FB payouts supplied by the user; rewards are granted by the server.
 local settings=a.Config.RushHourRewards and a.Config.RushHourRewards[kind]
 a.Rig:SetAttribute("ElliotRush"..kind,(a.Rig:GetAttribute("ElliotRush"..kind)or 0)+1)
 if settings then
  local payload=table.clone(settings)
  payload.Action=kind=="Used"and "Used Rush Hour"or "Successfully Escaped the Killer with Rush Hour"
  Actors:IncrementActorStats(a.Player,payload)
 end
end
function Server.Created(_,a)
 a.ElliotDestroyed=false;a.HealingBonus=0;a.ElliotPizzas={};a.ElliotConnections={}
 charges(a,1)
 table.insert(a.ElliotConnections,a.Rig:FindFirstChildOfClass("Humanoid").Died:Connect(function()Server.Destroyed(nil,a)end))
end
function Server.ObjectiveProgressed(_,a)
 if not active(a)then return end
 a.HealingBonus=math.min((a.HealingBonus or 0)+a.Config.OrderUpBonus,a.Config.OrderUpBonusMax)
 if a.Player then Network:FireClientConnection(a.Player,"ElliotOrderUpUpdate","REMOTE_EVENT",a.HealingBonus)end
end
function Server.OnThrowPizza(_,a)
 local pizza=a.Rig:FindFirstChild("Pizza")
 if pizza and pizza:IsA("BasePart")then pizza.Transparency=a.Config.PizzaTransparency or 0 end
end
function Server.OnThrowPizzaEnd(_,a)
 local pizza=a.Rig and a.Rig:FindFirstChild("Pizza")
 if pizza and pizza:IsA("BasePart")then pizza.Transparency=1 end
end
local function healPizza(a,target,additional)
 local rig=target.Rig
 local hum=rig:FindFirstChildOfClass("Humanoid")
 local instant,total=Rules.Healing(a.Config,a.HealingBonus,additional,target.ActorName=="Elliot")
 local before=hum.Health
 Util:Heal(hum,instant)
 local credited=false
 local function credit()
  if credited then return end
  credited=true
  if active(a)and target.ActorName~="Elliot"then charges(a,(a.Behavior.Abilities.RushHour.CurrentCharges or 0)+1)end
  if a.Player and a.Player:IsA("Player")then Actors:IncrementActorStats(a.Player,{Action="Healed player as Elliot",RewardType="Support"})end
 end
 if hum.Health>before then credit()end
 local elapsed=0
 local health=hum.Health
 local cancelled=false
 local healthConnection,heartbeat
 local function stop()
  if healthConnection then healthConnection:Disconnect();healthConnection=nil end
  if heartbeat then heartbeat:Disconnect();heartbeat=nil end
 end
 healthConnection=hum.HealthChanged:Connect(function(value)
  if value<=0 or health-value>=5 then cancelled=true;stop()end
  health=value
 end)
 heartbeat=RunService.Heartbeat:Connect(function(dt)
  if cancelled or not rig.Parent or hum.Health<=0 then stop();return end
  local step=math.min(dt,a.Config.PizzaHealingProgressivelyTime-elapsed)
  elapsed+=step
  local previous=hum.Health
  Util:Heal(hum,total*step/a.Config.PizzaHealingProgressivelyTime)
  if hum.Health>previous then credit()end
  if elapsed>=a.Config.PizzaHealingProgressivelyTime then stop()end
 end)
end
local function spawnPizza(a)
 if not active(a)then return end
 local source=a.Config.Instances and a.Config.Instances.CustomPizza or a.Rig:FindFirstChild("Pizza")
 if not source or not source:IsA("BasePart")then warn("[Elliot] Missing pizza part");return end
 local pizza=source:Clone();pizza.Name="ElliotPizza"
 for _,object in pizza:GetDescendants()do
  if object:IsA("JointInstance")or object:IsA("WeldConstraint")or object:IsA("LuaSourceContainer")then object:Destroy()end
 end
 pizza.Anchored=false;pizza.CanCollide=true;pizza.CanTouch=true;pizza.Massless=false;pizza.Transparency=0
 pizza.CFrame=a:GetPivot()*CFrame.new(0,0,-2)
 pizza.Parent=workspace.Map.Ingame
 pcall(function()pizza.CollisionGroup="Items";pizza:SetNetworkOwner(nil)end)
 pizza.AssemblyLinearVelocity=(a:GetPivot().LookVector+Vector3.new(0,.5,0))*a.Config.PizzaThrowForce
 sound(a,"PizzaThrown")
 if a.Config.PizzaParticles then local particles=a.Config.PizzaParticles:Clone();particles.Enabled=true;particles.Parent=pizza end
 local gui=a.Config.PizzaTimeGui and a.Config.PizzaTimeGui:Clone()
 if gui then gui.Adornee=pizza;gui.Parent=pizza end
 for _,other in Actors.CurrentActors do
  if other.Player and other.Player:IsA("Player")and team(other.Rig,"Survivors")and alive(other.Rig)and(other.Rig.PrimaryPart.Position-a.Rig.PrimaryPart.Position).Magnitude<=a.Config.PizzaPingDistance then
   pcall(Util.RevealPlayerAuraTo,Util,other.Player,pizza,a.Config.PizzaPingDuration,Color3.new(.75,1,.75),100)
  end
 end
 local state={part=pizza,elapsed=0,consumed=false};a.ElliotPizzas[state]=true
 local function cleanup()
  if state.connection then state.connection:Disconnect();state.connection=nil end
  a.ElliotPizzas[state]=nil
  pizza:Destroy()
 end
 state.connection=RunService.Heartbeat:Connect(function(dt)
  if not pizza.Parent then cleanup();return end
  state.elapsed+=dt
  if state.elapsed>=a.Config.PizzaLifetime then cleanup();return end
  if gui then
   local text=gui:FindFirstChild("Display",true)
   if text then text.Text=string.format("%.1fs",math.max(0,a.Config.PizzaLifetime-state.elapsed))end
  end
  for _,target in Actors.CurrentActors do
   local rig=target.Rig
   if rig~=a.Rig and team(rig,"Survivors")and alive(rig)then
    local hum=rig:FindFirstChildOfClass("Humanoid")
    if not hum:GetAttribute("Clanker")and hum.Health<hum.MaxHealth then
     local close=false
     for _,part in rig:GetChildren()do
      if part:IsA("BasePart")and(part.Position-pizza.Position).Magnitude<=(a.Config.PizzaHitboxSize or 2)+part.Size.Magnitude*.25 then close=true;break end
     end
     if close and not state.consumed then
      state.consumed=true
      local additional=0
      for _,other in Actors.CurrentActors do
       if other~=a and other.ActorName=="Elliot"and team(other.Rig,"Survivors")and alive(other.Rig)then additional+=1 end
      end
      sound(a,"PizzaEaten",rig.PrimaryPart)
      cleanup();healPizza(a,target,additional);return
     end
    end
   end
  end
 end)
end
function Server.ThrowPizza(a)
 if not active(a)then return {Cancelled=true}end
 a:DisableAbilities("ElliotPizza",true,a.Config.PizzaAbilityDisabledFor)
 invoke(a,"OnThrowPizza")
 task.delay(a.Config.PizzaThrowTimeToThrow,function()
  if active(a)then spawnPizza(a)end
  invoke(a,"OnThrowPizzaEnd")
 end)
 return {}
end
function Server.RushHour(a)
 if not active(a)or a.ElliotRush then return {Cancelled=true}end
 local level=Rules.Level(a.Behavior.Abilities.RushHour.CurrentCharges)
 if level==0 and workspace:GetAttribute("ChargesDisabled")then level=1 end
 if level==0 then return {Cancelled=true}end
 local killer=nearest(a)
 local empowered=killer~=nil
 if empowered and not workspace:GetAttribute("ChargesDisabled")then charges(a,0)end
 local rush={level=empowered and level or 1,empowered=empowered}
 a.ElliotRush=rush;a.Rig:SetAttribute("ElliotRushing",true)
 rush.scooter,rush.mountConnection=scooter(a)
 a:DisableAbilities("ElliotRush",true,a.Config.RushHourAbilityDisabledFor)
 sound(a,"RushHourStart")
 if a.ChangeExpression then a:ChangeExpression("Happy",a.Config.RushHourSpeedDuration)end
 Statuses:ApplyStatus(a.Rig,"Speed",{Level=rush.level,Duration=a.Config.RushHourSpeedDuration,NoStack={"HitSpeedBonus"}})
 reward(a,"Used")
 task.delay(a.Config.RushHourSpeedDuration,function()
  if a.ElliotRush~=rush then return end
  releaseRush(a)
  if active(a)and empowered then
   Statuses:ApplyStatus(a.Rig,"Exhausted",{Level=level,Duration=a.Config.RushHourExhaustedDuration})
   if alive(killer.Rig)and team(killer.Rig,"Killers")and not nearest(a)then reward(a,"Escaped")end
  end
 end)
 return {Level=rush.level,Empowered=empowered,Duration=a.Config.RushHourSpeedDuration}
end
function Server.Destroyed(_,a)
 if a.ElliotDestroyed then return end
 a.ElliotDestroyed=true
 releaseRush(a)
 for _,connection in a.ElliotConnections or {}do connection:Disconnect()end
 for state in a.ElliotPizzas or {}do if state.connection then state.connection:Disconnect()end;if state.part then state.part:Destroy()end end
 a.ElliotPizzas={}
end
return Server
]========]},
{path=[========[
ReplicatedStorage/Modules/Hitboxes]========],expected=[========[
27086:389d8f7c:44479c89]========],after=[========[
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

							require(game.ServerScriptService.Server.Systems.Data.CombatStatistics):RecordDamage(creator,creatorChar,victimChar)
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

						if finalDeductibleDamage>0 then require(game.ServerScriptService.Server.Systems.Data.CombatStatistics):RecordDamage(creator,creatorChar,victimChar)end
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
]========]},
{path=[========[
ServerScriptService/Server/Systems/Core/PlayerManager]========],expected=[========[
6642:6e066fe4:defd6dc9]========],after=[========[
local module = {}

local Janitor = require(game.ReplicatedStorage.Modules.Misc.Janitor) -- expect to see this ALOT on the engine
local Network = require(game.ReplicatedStorage.Modules.Network)
local Actors = require(game.ReplicatedStorage.Modules.Actors)
local ChatCommands = require(script.ChatCommands)
local GlobalConfig = require(game.ServerStorage.GlobalConfig)
local ManualRanks = GlobalConfig.ManualRanks
local CustomTitles = GlobalConfig.CustomTitles
local Data = require(game.ServerScriptService.Server.Systems.Data.PlayerData)
local Leaderstats = require(game.ServerScriptService.Server.Systems.Data.LeaderStats)
local ProductHandler = require(game.ServerScriptService.Server.Systems.Shopping.ProductHandler)
local AchievementUtil = require(game.ReplicatedStorage.Modules.AchievementUtil)
local Anticheat = require(game.ServerScriptService.Server.Systems.Core.Anticheat)
local Util = require(game.ReplicatedStorage.Modules.Util)
local FacialUnification = require(game.ReplicatedStorage.Modules.Misc.FacialUnification)

local PlayerJanitors = {}

module.Start = function()
	task.spawn(function()
		for _, plr in ipairs(game.Players:GetPlayers()) do
			task.spawn(module.InitPlayer, plr)
		end
		game.Players.PlayerAdded:Connect(module.InitPlayer)
		game.Players.PlayerRemoving:Connect(module.RemovePlayer)
	end)
end

module.InitCharacter = function(playerJanitor, Character : Model, Player : Player)
	local charJanitor = Janitor.new()
	playerJanitor:Add(charJanitor, "Destroy", "CharacterJanitor")

	if Character.Parent == game.Workspace then
		Character.Parent = workspace.Players.Spectating
		Character.PrimaryPart = Character.HumanoidRootPart
		for _, part in ipairs(Character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CollisionGroup = "Players"
			end
		end
		Character.Humanoid:SetAttribute("BaseSpeed", 16)
		FacialUnification:ConvertAnimatedHead(Character.Humanoid)
	else
		Character.Archivable = true
	end

	for _, instance in ipairs(script.CharacterEssentials:GetChildren()) do
		if not Character:FindFirstChild(instance.Name) then
			instance:Clone().Parent = Character
		end
	end

	local hrp = Character.PrimaryPart
	if hrp then
		charJanitor:Add(hrp.AncestryChanged:Connect(function()
			if hrp.Parent ~= nil then return end

			charJanitor:Remove("VoidKill")
			task.wait(game.Players.RespawnTime + 1)

			if Character.Parent and Player.Parent then
				Player:LoadCharacterAsync()
			end
		end), "Disconnect", "VoidKill")
	end
end

module.InitPlayer = function(Player : Player)
	local janitor = Janitor.new()
	PlayerJanitors[Player] = janitor

	local Rank = (game["Run Service"]:IsStudio() and Player.UserId < 0) and 999 or (game.CreatorType == Enum.CreatorType.Group and Player:GetRoleInGroupAsync(game.CreatorId) or ManualRanks[Player.UserId] or 0)
	if (not game["Run Service"]:IsStudio() and (not GlobalConfig.FreeTesting) and (Rank or 0) < 10) then
		Player:SetAttribute("NotAllowed", true)
		Player:Kick(GlobalConfig.NotAllowedKickMsg)
		return
	end

	Player:SetAttribute("Rank", Rank)
	Data:LoadData(Player)
	Leaderstats:AddStats(Player)
	ProductHandler:ActivatePasses(Player)

	if GlobalConfig.FreeVIP then
		Player:SetAttribute("VIP", true)
	end

	janitor:Add(Player.CharacterAdded:Connect(function(Character)
		module.InitCharacter(janitor, Character, Player)
	end), "Disconnect")

	if Player.Character then
		module.InitCharacter(janitor, Player.Character, Player)
	end

	if Rank and Rank >= 2 then
		local closestRank = 0
		local closestRankName = CustomTitles[Player.UserId] or game.CreatorType == Enum.CreatorType.Group and GlobalConfig.PreferCustomRankNames == false and Player:GetRoleInGroupAsync(game.CreatorId)
		if not closestRankName then
			for name, number in pairs(require(game.ServerScriptService.Server.Modules.RankNames)) do
				if number <= Rank and math.abs(number - Rank) < math.abs(closestRank - Rank) then
					closestRank = number
					closestRankName = name
				end
			end
		end
		Player:SetAttribute("RankTitle", closestRankName)
	end

	janitor:Add(Player.Chatted:Connect(function(msg)
		if game["Run Service"]:IsStudio() or (Player:GetAttribute("Rank") or 0) >= 100 then
			local args = string.split(msg, " ")
			local cmdName = args[1]
			if type(ChatCommands[cmdName]) == "function" then
				table.remove(args, 1)
				ChatCommands[cmdName](Player, table.unpack(args))
			end
		end
	end), "Disconnect")

	janitor:Add(task.spawn(function()
		while true do
			task.wait(1)
			if Player.Parent and Player:FindFirstChild("PlayerData") then
				Player.PlayerData.Stats.General.TimePlayed.Value += 1
			end
		end
	end), true)

	Anticheat.new(Player)
	janitor:Add(function()
		Anticheat:CleanupFromPlayer(Player)
	end, true)

	local playerData = Player:WaitForChild("PlayerData", 60)
	if not playerData then return end

	local purchased = playerData:WaitForChild("Purchased", 10)
	local equippedSkins = playerData:WaitForChild("Equipped"):WaitForChild("Skins")

	if purchased and equippedSkins then
		local function allocateSkin(val)
			if not equippedSkins:FindFirstChild(val.Name) then
				local skinVal = Instance.new("StringValue")
				skinVal.Name = val.Name
				skinVal.Parent = equippedSkins
			end
		end

		for _, val in ipairs(Util:MergeTables(purchased.Killers:GetChildren(), purchased.Survivors:GetChildren())) do
			allocateSkin(val)
		end

		janitor:Add(purchased.Killers.ChildAdded:Connect(allocateSkin), "Disconnect")
		janitor:Add(purchased.Survivors.ChildAdded:Connect(allocateSkin), "Disconnect")
	end
end

module.RemovePlayer = function(Player)
 require(game.ServerScriptService.Server.Systems.Data.CombatStatistics):FlushPlayer(Player)
	task.spawn(function()
		Data:SaveData(Player)
	end)

	local currentSessionModule = game.ServerScriptService.Server.Systems.Core:FindFirstChild("RoundManager")
	if currentSessionModule then
		local currentSession = require(currentSessionModule).CurrentSession
		if currentSession then
			local actor = Actors.CurrentActors[Player]
			if actor then
				local rig = actor.Rig
				local attackerName = rig:GetAttribute("RecentAttacker")

				if attackerName and rig:GetAttribute("RecentAttackerTime") and (os.clock() - rig:GetAttribute("RecentAttackerTime") <= 10) then
					local attacker = game.Players:FindFirstChild(attackerName)
					if attacker then
						Actors:IncrementActorStats(attacker, {
							Action = "Survivor ragequit mid-chase",
							Money = 15,
							EXP = 45
						})
						currentSession.TimePast -= currentSession.Gamemode.TimeAddedOnKill or 35
						AchievementUtil:IncrementAchievementProgress(attacker, "MakePlayerRagequit")
					end
				end
			end
		end
	end

	if PlayerJanitors[Player] then
		PlayerJanitors[Player]:Destroy()
		PlayerJanitors[Player] = nil
	end
end

return module]========]},
{path=[========[
ReplicatedStorage/Modules/PlayerList]========],expected=[========[
17658:be992f24:27922bd9]========],after=[========[
local t1 = {
	_players = {},
	DisplayedStats = {
		"Money",
		"KillerChance"
	},
	ListEnabled = true
}
local SocialService = game:GetService("SocialService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

game:GetService("TextChatService")

local v6 = RunService:IsStudio()
local clamp = math.clamp
local LocalPlayer = Players.LocalPlayer

require(game.ReplicatedStorage.Modules.Actors)

local DataHandler = require(game.ReplicatedStorage.Modules.DataHandler)
local Util = require(game.ReplicatedStorage.Modules.Util)
local Sounds = require(game.ReplicatedStorage.Modules.Sounds)
local Network = require(game.ReplicatedStorage.Modules.Network)
local t2 = {
	KillerChance = "Malice",
	RbxSpent = "R$ Spent"
}
local t3 = {
	PC = "rbxassetid://135066638879377",
	Mobile = "rbxassetid://89227325753198",
	Console = "rbxassetid://118447973769044",
	Unknown = "rbxassetid://94182197303121",
	NoChat = "rbxassetid://8509669675"
}

local function getPath(p1, s1: string, n1: number?) -- line: 51
	assert(typeof(p1) == "Instance")
	assert(typeof(s1) == "string")

	if s1 == "" then
		return p1
	end

	for _, v23 in (string.split(s1, "/")) do
		if typeof(n1) ~= "number" then
			p1 = p1:FindFirstChild(v23)

			if p1 ~= nil then
				continue
			end

			return
		end

		p1 = p1:WaitForChild(v23, n1)

		if p1 == nil then
			return
		end
	end

	return p1
end

function t1.GetPlayerListUI(p2) -- line: 76
	if not p2.PlayerList then
		repeat
			task.wait()
		until p2.PlayerList
	end

	return p2.PlayerList
end

local thread = nil
local u17 = true

function t1.TogglePlayerList(_, p4, p5) -- line: 85
	-- upvalues: t1 (copy), Sounds (copy), thread (ref), u17 (ref)
	if p5 then
		t1.ListEnabled = p4
	elseif not t1.ListEnabled then
		return
	end

	if not p5 then
		Sounds:Play("switch")
	end

	local PlayerListUI = t1:GetPlayerListUI()

	if thread then
		task.cancel(thread)
	end

	if p4 then
		u17 = true
		PlayerListUI.Close.Text = ">"
		PlayerListUI.Close.Visible = true
		PlayerListUI.Contents.Visible = true
		PlayerListUI.Background.Visible = true
		PlayerListUI.FriendBoost.Visible = true
		game.TweenService:Create(PlayerListUI, TweenInfo.new(0.15), {
			AnchorPoint = script.PlayerListHolder.AnchorPoint,
			Position = script.PlayerListHolder.Position
		}):Play()

		return
	end

	u17 = false
	PlayerListUI.Close.Text = "<"
	game.TweenService:Create(PlayerListUI, TweenInfo.new(0.15), {
		AnchorPoint = Vector2.new(),
		Position = UDim2.new(1, 0, 0, script.PlayerListHolder.Position.Y.Offset)
	}):Play()
	thread = task.delay(0.15, function() -- line: 116
		-- upvalues: p5 (copy), PlayerListUI (copy)
		if p5 then
			PlayerListUI.Close.Visible = false
		end

		PlayerListUI.Contents.Visible = false
		PlayerListUI.Background.Visible = false
		PlayerListUI.FriendBoost.Visible = false
	end)
end

local t4 = {}

function t1.ShowPlayerStats(t5: {[any]: any}, p6) -- line: 127
	-- upvalues: t4 (copy), Sounds (copy), t1 (copy), t3 (copy), DataHandler (copy), Util (copy), LocalPlayer (copy)
	for _, v in pairs(t4) do
		v:Disconnect()
	end

	table.clear(t4)

	if t5.__currentlyDisplayedStats and t5.__currentlyDisplayedStats.Parent then
		if tostring(t5.__currentlyDisplayedStats) == tostring(p6) then
			game.TweenService:Create(t5.__currentlyDisplayedStats, TweenInfo.new(0.15), {
				Size = UDim2.fromScale()
			}):Play()
			game.Debris:AddItem(t5.__currentlyDisplayedStats, 0.15)
			t5.__currentlyDisplayedStats = nil

			return
		end

		t5.__currentlyDisplayedStats:Destroy()
	end

	local clone = script.PlayerStats:Clone()

	clone.Name = tostring(p6)
	clone.Close.MouseEnter:Connect(function() -- line: 150
		-- upvalues: Sounds (copy)
		Sounds:Play("hover")
	end)
	clone.Close.MouseLeave:Connect(function() -- line: 151
		-- upvalues: Sounds (copy)
		Sounds:Play("hoverEnd")
	end)
	clone.Close.MouseButton1Click:Connect(function() -- line: 152
		-- upvalues: Sounds (copy), t1 (copy), p6 (copy)
		Sounds:Play("select")
		t1:ShowPlayerStats(p6)
	end)

	local v34 = `@{ p6.Name }`
	local v35 = p6.DisplayName ~= p6.Name and (p6.DisplayName ~= "" and p6.DisplayName)

	clone.BasicInfo.PlayerName.Text = v35 or v34
	clone.BasicInfo.PlayerUsername.Text = v34
	clone.BasicInfo.PlayerUsername.Visible = v35
	task.spawn(function() -- line: 164
		-- upvalues: p6 (copy), clone (copy)
		local UserId = p6.UserId
		local UserThumbnailAsync = game.Players:GetUserThumbnailAsync(UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)

		clone.PlayerIconHolder.Player.Image = UserThumbnailAsync
	end)

	local function updatePlayerDevice() -- line: 171
		-- upvalues: t3 (copy), p6 (copy), clone (copy)
		local v93 = t3[p6:GetAttribute("Device")] or t3.Unknown

		clone.PlayerIconHolder.Device.Image = v93
	end

	local v37 = t3[p6:GetAttribute("Device")] or t3.Unknown

	clone.PlayerIconHolder.Device.Image = v37
	table.insert(t4, p6:GetAttributeChangedSignal("Device"):Connect(updatePlayerDevice))

	local v38 = DataHandler:Get(p6)
	local v39 = v38 and v38:FindFirstChild("Stats")
	local v40 = v38 and v38:FindFirstChild("Equipped")

	if v39 and v40 then
		local General = v39:FindFirstChild("General")
		local v42 = General and General:FindFirstChild("TimePlayed")

		if v42 then
			local function updateTimePlayed() -- line: 256
				-- upvalues: Util (copy), p6 (copy), clone (copy), v42 (copy)
				local SettingValue = Util:GetSettingValue("HidePlaytime", p6)

				clone.TimePlayed.Text = `Time Played: { (if not SettingValue then Util:FormatTime(v42.Value, "Clock") else "<font color=\"rgb(125,125,125)\"><i>(Hidden)</i></font>") }`
			end

			local SettingValue = Util:GetSettingValue("HidePlaytime", p6)

			clone.TimePlayed.Text = `Time Played: { (if not SettingValue then Util:FormatTime(v42.Value, "Clock") else "<font color=\"rgb(125,125,125)\"><i>(Hidden)</i></font>") }`
			table.insert(t4, v42:GetPropertyChangedSignal("Value"):Connect(updateTimePlayed))
		end

		for _, v in pairs({
			"Killer",
			"Survivor"
		}) do
			local v47 = v39 and v39:FindFirstChild(`{ v }Stats`)
			local v48 = v47 and v47:FindFirstChild(`{ v }Kills`)

			if v48 then
				local SettingValue = Util:GetSettingValue(`Hide{ v }Wins`, p6)
				local v50 = clone.WinInfo:FindFirstChild(`{ v }Wins`)

				v50.MouseEnter:Connect(function() -- line: 275
					-- upvalues: Util (copy), v (copy), SettingValue (copy)
					Util:CreateTooltip(`{ v } Kills{ not SettingValue and "" or " <font color=\"rgb(125,125,125)\"><i>(Hidden)</i></font>" }`)
				end)
				v50.MouseLeave:Connect(function() -- line: 276
					-- upvalues: Util (copy)
					Util:CreateTooltip()
				end)

				local function setScore() -- line: 279
					-- upvalues: v50 (copy), SettingValue (copy), v48 (copy)
					v50.Wins.Text = if not SettingValue then v48.Value else "<font color=\"rgb(125,125,125)\"><i>(Hidden)</i></font>"
				end

				v50.Wins.Text = if not SettingValue then v48.Value else "<font color=\"rgb(125,125,125)\"><i>(Hidden)</i></font>"
				table.insert(t4, v48:GetPropertyChangedSignal("Value"):Connect(setScore))
			end

			if v40 then
				local t6 = {}

				local function setEquippedIcon() -- line: 292
					-- upvalues: p6 (copy), v (copy), t6 (ref), clone (copy), Util (copy)
					local v95, v96 = require(game.ReplicatedStorage.Modules.Actors):GetEquippedActorInfo(p6, v)
					local v97 = game.ReplicatedStorage.Assets:FindFirstChild(`{ v }s`):FindFirstChild(v95)
					local v98 = v97 and (v97:FindFirstChild("Config") and require(v97.Config))
					local v99 = game.ReplicatedStorage.Assets.Skins:FindFirstChild(`{ v }s`):FindFirstChild(v95)
					local v100 = v99 and v99:FindFirstChild(v96)
					local v101 = v100 and (v100:FindFirstChild("Config") and require(v100.Config))

					if v98 then
						for _, v2 in pairs(t6) do
							v2:Disconnect()
						end

						table.clear(t6)

						local v3 = clone.BasicInfo.EquippedCharacters:FindFirstChild(v)
						local u105 = `Equipped { v }: <i>{ v98.DisplayName or tostring(v97) }</i>`

						if v101 then
							u105 = `{ u105 }\nEquipped Skin: <i>{ v101.DisplayName or tostring(v100) }</i>`
						end

						v3.Image = v101 and v101.RenderImage or (v98.RenderImage or "rbxassetid://13373279056")
						t6 = {
							v3.MouseEnter:Connect(function() -- line: 316
								-- upvalues: Util (copy), u105 (ref)
								Util:CreateTooltip(u105)
							end),
							v3.MouseLeave:Connect(function() -- line: 317
								-- upvalues: Util (copy)
								Util:CreateTooltip()
							end)
						}
					end
				end

				local v4 = v40:FindFirstChild(v)
				local v5 = v40.Skins:FindFirstChild(v)

				setEquippedIcon()

				if v4 then
					table.insert(t4, v4:GetPropertyChangedSignal("Value"):Connect(setEquippedIcon))
				end

				if v5 then
					table.insert(t4, v5:GetPropertyChangedSignal("Value"):Connect(setEquippedIcon))
				end
			end
		end
	end

	if not t5.__currentlyDisplayedStats then
		clone.Size = UDim2.new()
		game.TweenService:Create(clone, TweenInfo.new(0.15), {
			Size = script.PlayerStats.Size
		}):Play()
	end

	clone.Parent = LocalPlayer.PlayerGui.TemporaryUI
	t5.__currentlyDisplayedStats = clone
	clone.AncestryChanged:Connect(function(_, parent) -- line: 345
		-- upvalues: Util (copy), t4 (copy)
		if not parent then
			Util:CreateTooltip()

			for _, v in pairs(t4) do
				v:Disconnect()
			end

			table.clear(t4)
		end
	end)
end
function t1.CreatePlayerInList(_: {[any]: any}, p8) -- line: 356
	-- upvalues: t1 (copy), Util (copy), Network (copy), v6 (copy)
	if not p8 then
		return
	end

	local PlayerListUI = t1:GetPlayerListUI()
	local v59 = PlayerListUI.Contents.Players:FindFirstChild((tostring(p8)))

	if v59 then
		v59:Destroy()
	end

	local clone = script.PlayerInfoContainer:Clone()

	clone.Name = tostring(p8)

	local p8Name = p8.Name
	local v62 = p8.DisplayName ~= p8.Name and (p8.DisplayName ~= "" and p8.DisplayName)

	local baseName = v62 or p8Name
	clone.PlayerInfo.Username.Text = baseName
	clone.PlayerInfo.Username.RichText = true

	local function updateAFKStatus()
		local afkValue = Util:GetSettingValue("AFK", p8)
		local isAFK = afkValue == true or (typeof(afkValue) == "number" and afkValue > 0)
		clone.PlayerInfo.Username.Text = isAFK and `{baseName} <font color="#B82500">[AFK]</font>` or baseName
	end

	task.spawn(function()
		local playerData = DataHandler:Get(p8)
		if not playerData then return end
		local settings = playerData:FindFirstChild("Settings")
		if not settings then return end
		local afkSetting = settings:FindFirstChild("AFK", true)
		if afkSetting then
			afkSetting:GetPropertyChangedSignal("Value"):Connect(updateAFKStatus)
		end
		updateAFKStatus()
	end)

	clone.ShowStats.MouseButton1Click:Connect(function() -- line: 375
		-- upvalues: t1 (copy), p8 (copy)
		t1:ShowPlayerStats(p8)
	end)

	if t1.DisplayedStats and t1.DisplayedStats[1] then
		local leaderstats = p8:WaitForChild("leaderstats", 30)

		if not leaderstats or not p8.Parent then
			return
		end

		for _, child in pairs(leaderstats:GetChildren()) do
			local clone2 = clone.PlayerInfo.Username:Clone()

			clone2.Name = child and child.Name
			clone2.Size = UDim2.fromScale(0.3, 1)
			clone2.LayoutOrder = table.find(t1.DisplayedStats, child.Name)
			clone2.TextXAlignment = Enum.TextXAlignment.Center
			clone2.Parent = clone.PlayerInfo

			local function updateStat() -- line: 396
				-- upvalues: child (copy), clone2 (copy), Util (copy)
				local v110 = child and child.Value or "?"

				if tonumber(v110) then
					clone2.TextColor3 = v110 > 0 and Color3.new(1, 1, 1) or Color3.new(1, 0, 0)
					v110 = Util:ConvertToAbbreviation(v110)
				end

				if v110.Name == "Money" then
					v110 = `${ v110 }`
				end

				clone2.Text = tostring(v110)
			end

			updateStat()

			if child then
				child:GetPropertyChangedSignal("Value"):Connect(updateStat)
			end
		end
	end

	local v68 = Network:FireServerConnection("ReturnCanChat", "REMOTE_FUNCTION", p8)

	if v6 or not v68 then
		clone.NoChat.Visible = true
		clone.NoChat.MouseEnter:Connect(function() -- line: 422
			-- upvalues: Util (copy)
			Util:CreateTooltip("You cannot communicate with this player.")
		end)
		clone.NoChat.MouseLeave:Connect(function() -- line: 425
			-- upvalues: Util (copy)
			Util:CreateTooltip()
		end)
	end

	clone.Parent = PlayerListUI.Contents.Players
	t1:__UpdateListSize()
end
function t1.RemovePlayerFromList(_: {[any]: any}, p9) -- line: 437
	-- upvalues: t1 (copy)
	local v71 = t1:GetPlayerListUI().Contents.Players:FindFirstChild((tostring(p9)))

	if v71 then
		v71:Destroy()
	end

	t1:__UpdateListSize()
end
function t1.__UpdateListSize(_) -- line: 450
	-- upvalues: t1 (copy)
	local PlayerListUI = t1:GetPlayerListUI()
	local UIListLayout = PlayerListUI.Contents.Players.UIListLayout
	local v75 = UIListLayout.AbsoluteContentSize.Y + UIListLayout.Padding.Offset

	PlayerListUI.Background.Size = UDim2.fromScale(1, (math.clamp(0.05 + 30 / PlayerListUI.AbsoluteSize.Y + v75 / PlayerListUI.AbsoluteSize.Y, 0, 1)))
	PlayerListUI.FriendBoost.Position = UDim2.fromScale(0, (math.clamp(0.05 + 30 / PlayerListUI.AbsoluteSize.Y + v75 / PlayerListUI.AbsoluteSize.Y, 0, 1)))
end
function t1.Start(p11) -- line: 460
	-- upvalues: LocalPlayer (copy), t1 (copy), t2 (copy), SocialService (copy), clamp (copy), Util (copy), u17 (ref), Sounds (copy)
	if game["Run Service"]:IsServer() then
		return
	end

	local clone = script.PlayerListHolder:Clone()
	local Contents = clone.Contents

	clone.Parent = LocalPlayer.PlayerGui:WaitForChild("MainUI")
	Contents:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 521
		-- upvalues: t1 (copy)
		t1:__UpdateListSize()
	end)

	for k, v in pairs(t1.DisplayedStats) do
		local clone3 = Contents.InfoTypes.Players:Clone()

		clone3.Name = v
		clone3.Text = t2[v] or v:gsub("(%l)(%u)", "%1 %2")
		clone3.Size = UDim2.fromScale(0.3, 1)
		clone3.LayoutOrder = k + 1
		clone3.TextXAlignment = Enum.TextXAlignment.Center
		clone3.Parent = Contents.InfoTypes
	end

	local _ = {
		JOINING = true,
		LEAVING = false
	}
	local ExperienceInviteOptions = Instance.new("ExperienceInviteOptions")

	ExperienceInviteOptions.PromptMessage = `Invite Friends, get { 10 }% more EXP per friend! (caps at { 20 }%).`

	local function __canSendInvite(p12) -- line: 547
		-- upvalues: SocialService (copy)
		local ok, result = pcall(function() -- line: 548
			-- upvalues: SocialService (copy), p12 (copy)
			return SocialService:CanSendGameInviteAsync(p12)
		end)

		return ok and result
	end

	local Button = clone.FriendBoost.Button

	Button.MouseButton1Down:Connect(function() -- line: 556
		-- upvalues: LocalPlayer (copy), SocialService (copy), ExperienceInviteOptions (copy)
		local v114 = LocalPlayer
		local ok, result = pcall(function() -- line: 548
			-- upvalues: SocialService (copy), v114 (copy)
			return SocialService:CanSendGameInviteAsync(v114)
		end)

		if ok and result then
			SocialService:PromptGameInvite(LocalPlayer, ExperienceInviteOptions)
		end
	end)

	local n2 = 0

	local function __setBoostDisplay(p13, b1: boolean) -- line: 564
		-- upvalues: LocalPlayer (copy), n2 (ref), clamp (copy), Button (copy)
		local ok, result = pcall(function() -- line: 566
			-- upvalues: LocalPlayer (copy), p13 (copy)
			return LocalPlayer:IsFriendsWith(p13.UserId)
		end)

		if ok and result then
			n2 = clamp(n2 + 10 * (not b1 and -1 or 1), 0, 20)
		end

		local v121 = `Invite Friends (+{ n2 }% EXP)`

		if v121 ~= Button.Text then
			Button.Text = v121
		end
	end

	Util.OnPlayerAdded(function(p14) -- line: 587
		-- upvalues: LocalPlayer (copy), n2 (ref), clamp (copy), Button (copy), t1 (copy)
		if p14 ~= LocalPlayer then
			local ok, result = pcall(function() -- line: 566
				-- upvalues: LocalPlayer (copy), p14 (copy)
				return LocalPlayer:IsFriendsWith(p14.UserId)
			end)

			if ok and result then
				n2 = clamp(n2 + 10, 0, 20)
			end

			local v125 = `Invite Friends (+{ n2 }% EXP)`

			if v125 ~= Button.Text then
				Button.Text = v125
			end
		end

		t1:CreatePlayerInList(p14)
	end)
	game.Players.PlayerRemoving:Connect(function(player) -- line: 596
		-- upvalues: LocalPlayer (copy), n2 (ref), clamp (copy), Button (copy), t1 (copy)
		if player ~= LocalPlayer then
			local ok, result = pcall(function() -- line: 566
				-- upvalues: LocalPlayer (copy), player (copy)
				return LocalPlayer:IsFriendsWith(player.UserId)
			end)

			if ok and result then
				n2 = clamp(n2 + -10, 0, 20)
			end

			local v129 = `Invite Friends (+{ n2 }% EXP)`

			if v129 ~= Button.Text then
				Button.Text = v129
			end
		end

		t1:RemovePlayerFromList(player)
	end)
	clone.Close.MouseButton1Click:Connect(function() -- line: 604
		-- upvalues: t1 (copy), u17 (ref)
		t1:TogglePlayerList(not u17)
	end)
	game.UserInputService.InputBegan:Connect(function(input, gameProcessed) -- line: 608
		-- upvalues: t1 (copy), u17 (ref)
		if gameProcessed then
			return
		end

		if input.KeyCode == Enum.KeyCode.Tab then
			t1:TogglePlayerList(not u17)
		end
	end)

	local function addSFX(p15) -- line: 616
		-- upvalues: Sounds (copy)
		if p15:IsA("ImageButton") or p15:IsA("TextButton") then
			p15.MouseEnter:Connect(function() -- line: 618
				-- upvalues: Sounds (copy)
				Sounds:Play("hover")
			end)
			p15.MouseLeave:Connect(function() -- line: 619
				-- upvalues: Sounds (copy)
				Sounds:Play("hoverEnd")
			end)
			p15.MouseButton1Click:Connect(function() -- line: 620
				-- upvalues: Sounds (copy)
				Sounds:Play("select")
			end)
		end
	end

	for _, descendant in pairs(clone:GetDescendants()) do
		addSFX(descendant)
	end

	clone.DescendantAdded:Connect(addSFX)
	p11.PlayerList = clone
	game.StarterGui:SetCoreGuiEnabled("PlayerList", false)
end

return t1

]========]},
{path=[========[
ReplicatedStorage/Systems/Player/UI/Menus/Stats]========],expected=[========[
2056:3bca5dbc:2b14a495]========],after=[========[
local Menu={}
local DataHandler=require(game.ReplicatedStorage.Modules.DataHandler)
local Util=require(game.ReplicatedStorage.Modules.Util)
function Menu.Start()
 local stats=DataHandler:Get():WaitForChild("Stats")
 Menu.StatsMenu=require(game.ReplicatedStorage.Initializer).PlayerSystems.SidebarHandler:CreateSidebarMenu("Stats",script.StatsScreen)
 local contents=Menu.StatsMenu.Menu.StatsContainer.Contents
 for _,group in stats:GetChildren()do
  if group:IsA("Folder")then
   local rows={}
   local header=script.Templates.Seperator:Clone();header.Name=group.Name
   header.LayoutOrder=(group:GetAttribute("LayoutOrder")or 99)*100
   local title=group:GetAttribute("DisplayTitle")or group.Name
   header.Title.Text=title.." [-]";header.Parent=contents
   local button=Instance.new("TextButton");button.Name="Collapse";button.Size=UDim2.fromScale(1,1);button.BackgroundTransparency=1;button.Text="";button.Parent=header
   local collapsed=false
   button.Activated:Connect(function()
    collapsed=not collapsed;header.Title.Text=title..(collapsed and " [+]"or " [-]")
    for _,row in rows do row.Visible=not collapsed end
   end)
   for _,value in group:GetChildren()do
    if value:IsA("NumberValue")and value:GetAttribute("CombatStat")then
     local row=script.Templates.Title:Clone();row.Name=value.Name
     row.LayoutOrder=header.LayoutOrder+(value:GetAttribute("LayoutOrder")or 99);row.Parent=contents
     table.insert(rows,row)
     local function update()
      local label=value:GetAttribute("DisplayTitle")or value.Name
      local number=value.Value
      local text=value:GetAttribute("PostDisplayTitle")=="Time"and Util:FormatTime(math.floor(number),"String")or tostring(number)
      row.Text=label..": "..text
     end
     value:GetPropertyChangedSignal("Value"):Connect(update);update()
    end
   end
  end
 end
end
return Menu
]========]},
{path=[========[
ServerScriptService/Server/Modules/Commands/ToggleFriendlyFire]========],expected=[========[
542:8cff1276:d6727265]========],after=[========[
-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

return {
	LayoutOrder = 95,
	RequiredRank = "HeadModerator",
	Executable = false,
	Parameters = {},
	Title = "Friendly Fire (Always On)",
	ResetOnExecution = false,
	DisplayedAttribute = "FriendlyFire",
	AllowedInVIP = true,
    Executed = function(_, _) --[[ Line: 9 ]] --[[ Name: Executed ]]
        local l_workspace_Attribute_0 = workspace:GetAttribute("FriendlyFire");
        workspace:SetAttribute("FriendlyFire", true);
	end,
};]========]},
}
for _,change in changes do
 change.target=assert(find(change.path),"Missing module: "..change.path)
 change.before=change.target.Source
 assert(fingerprint(change.before)==change.expected,"Current Source differs: "..change.path..". Nothing changed; send this module for a matching installer.")
end
local template=assert(find("ServerScriptService/Server/Systems/Data/PlayerData/Template"))
local originalStats=assert(template:FindFirstChild("Stats"),"Stats template missing")
local prepared=originalStats:Clone()
local schema=(function()
return {
 {"General","GENERAL",{{"TimePlayed","Time Played",true},{"InGameTime","In-Game Time",true},{"TotalKills","Total Kills"},{"TotalDeaths","Total Deaths"}}},
 {"SurvivorStats","SURVIVOR STATS",{{"SurvivorKills","Survivor Kills"},{"SurvivorDeaths","Survivor Deaths"},{"BestSurvivorTime","Best Survivor Time",true},{"BestSurvivorKillstreak","Best Survivor Killstreak"}}},
 {"KillerStats","KILLER STATS",{{"KillerKills","Killer Kills"},{"KillerDeaths","Killer Deaths"},{"BestKillerTime","Best Killer Time",true},{"BestKillerKillstreak","Best Killer Killstreak"}}},
 {"Currency","CURRENCY",{{"Money","Money"},{"NetWorth","Net Worth"}}}
}

end)()
for index,section in schema do
 local group=prepared:FindFirstChild(section[1])
 if not group then group=Instance.new("Folder");group.Name=section[1];group.Parent=prepared end
 group:SetAttribute("DisplayTitle",section[2]);group:SetAttribute("LayoutOrder",index)
 for order,field in section[3]do
  local value=group:FindFirstChild(field[1])
  if not value then value=Instance.new("NumberValue");value.Name=field[1];value.Value=0;value.Parent=group end
  value:SetAttribute("CombatStat",true);value:SetAttribute("DisplayTitle",field[2]);value:SetAttribute("LayoutOrder",order)
  if field[3]then value:SetAttribute("PostDisplayTitle","Time")end
 end
end
local module=Instance.new("ModuleScript");module.Name="CombatStatistics";module:SetAttribute("Version","1.0.0")
module.Source=[========[
local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local Actors=require(game.ReplicatedStorage.Modules.Actors)
local Schema=require(script.Schema)
local Stats={}
local sessions={}
local rigs=setmetatable({},{__mode="k"})
local damage=setmetatable({},{__mode="k"})
local nextSession=0
local function folder(parent,name)
 local object=parent:FindFirstChild(name)
 if not object then object=Instance.new("Folder");object.Name=name;object.Parent=parent end
 return object
end
function Stats:EnsureData(data)
 local root=folder(data,"Stats")
 for index,section in Schema do
  local group=folder(root,section[1]);group:SetAttribute("DisplayTitle",section[2]);group:SetAttribute("LayoutOrder",index)
  for order,field in section[3]do
   local value=group:FindFirstChild(field[1])
   if not value then value=Instance.new("NumberValue");value.Name=field[1];value.Value=0;value.Parent=group end
   value:SetAttribute("CombatStat",true);value:SetAttribute("DisplayTitle",field[2]);value:SetAttribute("LayoutOrder",order)
   if field[3]then value:SetAttribute("PostDisplayTitle","Time")end
  end
 end
 return root
end
local function dataFor(player)
 local data=player and player:FindFirstChild("PlayerData")
 return data and Stats:EnsureData(data)
end
local function add(root,section,name,delta)
 local value=root[section][name];value.Value+=delta
end
local function best(root,section,name,value)
 local stat=root[section][name];stat.Value=math.max(stat.Value,value)
end
local function account(state)
 if state.ended then return end
 local now=state.stoppedAt or os.clock();local elapsed=math.max(0,now-state.accounted)
 local root=dataFor(state.player)
 if root then
  add(root,"General","InGameTime",elapsed)
  best(root,state.role.."Stats","Best"..state.role.."Time",math.max(0,now-state.started))
 end
 state.accounted=now
end
local function death(state)
 if state.dead or state.ended then return end
 state.dead=true;state.stoppedAt=os.clock()
 account(state)
 local root=dataFor(state.player)
 if root then add(root,"General","TotalDeaths",1);add(root,state.role.."Stats",state.role.."Deaths",1)end
 local hit=damage[state.rig]
 if not hit or os.clock()-hit.time>10 then
  local name=state.rig:GetAttribute("RecentAttacker")
  local stamp=state.rig:GetAttribute("RecentAttackerTime")
  local player=type(name)=="string"and Players:FindFirstChild(name)
  local source=player and sessions[player]
  if source and type(stamp)=="number"and os.clock()-stamp<=10 then hit={state=source,time=stamp}end
 end
 if hit and os.clock()-hit.time<=10 then
  local killer=hit.state
  if killer.player~=state.player and killer.player.Parent==Players then
   local killerData=dataFor(killer.player)
   if killerData then
    add(killerData,"General","TotalKills",1)
    add(killerData,killer.role.."Stats",killer.role.."Kills",1)
    if sessions[killer.player]==killer and not killer.dead and not killer.ended then
     killer.streak+=1
     best(killerData,killer.role.."Stats","Best"..killer.role.."Killstreak",killer.streak)
    end
   end
  end
 end
 damage[state.rig]=nil
end
local function finish(state)
 if state.ended then return end
 if state.hum.Health<=0 then death(state)end
 account(state);state.ended=true
 for _,connection in state.connections do connection:Disconnect()end
 if sessions[state.player]==state then sessions[state.player]=nil end
end
function Stats:Observe(actor)
 local player=actor.Player
 if typeof(player)~="Instance"or not player:IsA("Player")then return end
 local rig=actor.Rig;local hum=rig and rig:FindFirstChildOfClass("Humanoid")
 local role=actor.ActorType
 if role~="Survivor"and role~="Killer"then return end
 if not hum or not rig.Parent or hum.Health<=0 then return end
 local old=sessions[player]
 if old and old.rig==rig then return end
 if old then finish(old)end
 nextSession+=1
 local now=os.clock()
 local state={player=player,rig=rig,hum=hum,role=role,started=now,accounted=now,streak=0,connections={},id=nextSession}
 sessions[player]=state;rigs[rig]=state
 rig:SetAttribute("CombatSessionId",nextSession)
 dataFor(player)
 table.insert(state.connections,hum.HealthChanged:Connect(function(value)if value<=0 then death(state)end end))
 table.insert(state.connections,hum.Died:Connect(function()death(state)end))
end
function Stats:RecordDamage(creator,creatorRig,victimRig)
 local victim=rigs[victimRig]
 if not victim or victim.ended then return end
 local attacker=rigs[creatorRig]
 if attacker and attacker.player==creator and creator~=victim.player then damage[victimRig]={state=attacker,time=os.clock()}
 else damage[victimRig]=nil end
end
function Stats:FlushPlayer(player)
 local state=sessions[player]
 if state then finish(state)end
end
function Stats.Start()
 if not RunService:IsServer()then return end
 local function forceFriendlyFire()if workspace:GetAttribute("FriendlyFire")~=true then workspace:SetAttribute("FriendlyFire",true)end end
 forceFriendlyFire();workspace:GetAttributeChangedSignal("FriendlyFire"):Connect(forceFriendlyFire)
 Actors.ActorAdded:Connect(function(actor)Stats:Observe(actor)end)
 Actors.ActorRemoved:Connect(function(actor)
  local state=sessions[actor.Player]
  if state and state.rig==actor.Rig then finish(state)end
 end)
 for _,actor in Actors.CurrentActors do Stats:Observe(actor)end
 local function loaded(player)
  task.spawn(function()
   local data=player:WaitForChild("PlayerData",60)
   if data and player.Parent==Players then Stats:EnsureData(data)end
  end)
 end
 Players.PlayerAdded:Connect(loaded)
 for _,player in Players:GetPlayers()do loaded(player)end
 local elapsed=0
 RunService.Heartbeat:Connect(function(dt)
  elapsed+=dt;if elapsed<1 then return end;elapsed=0
  for _,state in sessions do
   if state.hum.Health<=0 then death(state)else account(state)end
  end
 end)
 game:BindToClose(function()for player in sessions do Stats:FlushPlayer(player)end end)
end
return Stats
]========]
local schemaModule=Instance.new("ModuleScript");schemaModule.Name="Schema";schemaModule.Source=[========[
return {
 {"General","GENERAL",{{"TimePlayed","Time Played",true},{"InGameTime","In-Game Time",true},{"TotalKills","Total Kills"},{"TotalDeaths","Total Deaths"}}},
 {"SurvivorStats","SURVIVOR STATS",{{"SurvivorKills","Survivor Kills"},{"SurvivorDeaths","Survivor Deaths"},{"BestSurvivorTime","Best Survivor Time",true},{"BestSurvivorKillstreak","Best Survivor Killstreak"}}},
 {"KillerStats","KILLER STATS",{{"KillerKills","Killer Kills"},{"KillerDeaths","Killer Deaths"},{"BestKillerTime","Best Killer Time",true},{"BestKillerKillstreak","Best Killer Killstreak"}}},
 {"Currency","CURRENCY",{{"Money","Money"},{"NetWorth","Net Worth"}}}
}
]========];schemaModule.Parent=module
local backup=Instance.new("Folder");local base="FBStats_Backup_"..os.date("!%Y%m%d_%H%M%S");backup.Name=base
local index=0;while game.ServerStorage:FindFirstChild(backup.Name)do index+=1;backup.Name=base.."_"..index end
ref(backup,"Backend",module);ref(backup,"Template",template);ref(backup,"OriginalStats",originalStats);ref(backup,"InstalledStats",prepared)
backup:SetAttribute("OldFriendlyFire",workspace:GetAttribute("FriendlyFire"));backup:SetAttribute("HadFriendlyFire",workspace:GetAttribute("FriendlyFire")~=nil)
backup:SetAttribute("BackendSource",fingerprint(module.Source));backup:SetAttribute("SchemaSource",fingerprint(schemaModule.Source))
for i,change in changes do
 local record=Instance.new("Folder");record.Name="Source_"..i;ref(record,"Target",change.target)
 local before=Instance.new("StringValue");before.Name="Before";before.Value=change.before;before.Parent=record
 record:SetAttribute("Installed",fingerprint(change.after));record.Parent=backup
end
backup.Parent=game.ServerStorage
local ok,err=pcall(function()
 for _,change in changes do change.target.Source=change.after end
 originalStats.Parent=backup;prepared.Parent=template;module.Parent=parent
 workspace:SetAttribute("FriendlyFire",true)
end)
if not ok then
 for _,change in changes do if change.target.Source~=change.before then change.target.Source=change.before end end
 module:Destroy();prepared:Destroy();originalStats.Parent=template
 workspace:SetAttribute("FriendlyFire",backup:GetAttribute("OldFriendlyFire"));backup:Destroy()
 error("[FB stats] Rolled back: "..tostring(err))
end
print("[FB stats] Installed combat stats, role-kill player card, forced Friendly Fire, building placement/destruction fixes and decimal pizza timer. Save and restart Play. Backup: "..backup.Name)

end
local function restore()
assert(game:GetService("RunService"):IsStudio()and not game:GetService("RunService"):IsRunning(),"Stop Play first.")
local function find(path)
 local object=game
 for name in path:gmatch("[^/]+")do object=object and object:FindFirstChild(name)end
 return object
end
local function fingerprint(s)
 local a,b=5381,0
 for i=1,#s do local v=s:byte(i);a=(a*33+v)%4294967296;b=(b*65599+v)%4294967296 end
 return string.format("%d:%08x:%08x",#s,a,b)
end
local function ref(parent,name,value)local object=Instance.new("ObjectValue");object.Name=name;object.Value=value;object.Parent=parent end
local selected=game:GetService("Selection"):Get();local backup
if #selected==1 and selected[1].Name:match("^FBStats_Backup_")then backup=selected[1]end
assert(backup,"Select the FBStats_Backup folder first.")
local backend=assert(backup.Backend.Value)
assert(fingerprint(backend.Source)==backup:GetAttribute("BackendSource")and fingerprint(backend.Schema.Source)==backup:GetAttribute("SchemaSource"),"Stats backend edited since install. Nothing changed.")
local changes={}
for _,record in backup:GetChildren()do
 if record.Name:match("^Source_")then
  local target=assert(record.Target.Value)
  assert(fingerprint(target.Source)==record:GetAttribute("Installed"),"Module edited since install: "..target:GetFullName()..". Nothing changed.")
  table.insert(changes,{target=target,before=record.Before.Value,installed=target.Source})
 end
end
local ok,err=pcall(function()for _,change in changes do change.target.Source=change.before end end)
if not ok then
 for _,change in changes do if change.target.Source~=change.installed then change.target.Source=change.installed end end
 error("Restore rolled back: "..tostring(err))
end
backend:Destroy();backup.InstalledStats.Value:Destroy();backup.OriginalStats.Value.Parent=backup.Template.Value
workspace:SetAttribute("FriendlyFire",backup:GetAttribute("OldFriendlyFire"));backup:Destroy()
print("[FB stats] Restored previous modules, template and Friendly Fire default. Save and restart Play.")

end
fixture();install()
local template=locate("ServerScriptService/Server/Systems/Data/PlayerData/Template")
assert(template.Stats~=originalStats and template.Stats.General.InGameTime and template.Stats.KillerStats.KillerKills and template.Stats.SurvivorStats.SurvivorDeaths)
assert(template.Stats.General.TimePlayed.Value==37 and template.Stats.Currency.Money.Value==500 and template.Stats.Currency.RbxSpent.Value==300)
assert(not template.Stats.Currency.RbxSpent:GetAttribute("CombatStat"))
assert(locate("ServerScriptService/Server/Systems/Data/CombatStatistics/Schema"))
assert(workspace:GetAttribute("FriendlyFire")==true)
local count=#game.ServerStorage:GetChildren();install();assert(#game.ServerStorage:GetChildren()==count)
for _,item in game.ServerStorage:GetChildren()do if item.Name:match("^FBStats_Backup_")then selection={item}end end
restore()
assert(template.Stats==originalStats and workspace:GetAttribute("FriendlyFire")==false)
for _,item in sourceData do assert(locate(item.path).Source==item.source)end
assert(not locate("ServerScriptService/Server/Systems/Data/CombatStatistics"))
for fail=1,9 do
 fixture();failAt=writes+fail;assert(not pcall(install));failAt=nil
 assert(locate("ServerScriptService/Server/Systems/Data/PlayerData/Template/Stats")==originalStats)
 for _,item in sourceData do assert(locate(item.path).Source==item.source)end
 assert(not locate("ServerScriptService/Server/Systems/Data/CombatStatistics"))
 assert(workspace:GetAttribute("FriendlyFire")==false)
end
fixture();locate(sourceData[1].path).Source..=" local edit";assert(not pcall(install))
print("PASS combined installer: stat template/native values preserved, backend/schema creation, forced FF, repeat install, exact restore, all Source-write failures and edit refusal")
