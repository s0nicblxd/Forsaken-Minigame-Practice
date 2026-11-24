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
local root=assert(find("ReplicatedStorage/Assets/Survivors/Builderman"),"Builderman missing")
if root:GetAttribute("BuildermanPortVersion")=="1.2.0"then print("[Builderman placement] Already installed.");return end
assert(root:GetAttribute("BuildermanPortVersion")=="1.1.0","Apply the Builderman polish repair first.")
local changes={
{target=assert(root.Behavior:FindFirstChild("Server")),expected=[========[
20661:9a1a7a99:bb5c88d2]========],after=[========[
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
{target=assert(root.Behavior:FindFirstChild("Client")),expected=[========[
32233:59ef4d9d:4b9d8b2a]========],after=[========[
local CarryVisuals=require(script.Parent.CarryVisuals)


local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")

game:GetService("Players")

local t1 = {}

require(game.ReplicatedStorage.Modules.AchievementUtil)
require(game.ReplicatedStorage.Modules.Sounds)

local Util = require(game.ReplicatedStorage.Modules.Util)

require(game.ReplicatedStorage.Modules.Hitboxes)
require(game.ReplicatedStorage.Modules.Statuses)

local Network = require(game.ReplicatedStorage.Modules.Network)
local trove = require(game.ReplicatedStorage.Modules.Misc.Trove)
local Spring = require(game.ReplicatedStorage.Modules.Misc.Spring)
local u8 = false
local t2 = {
 carrying="Place your carried building before constructing another.",
	collision = "Building area is obstructed by something. Build somewhere else.",
	tooClose = "Building area is too close to a pre-existing building. Move further away and try again.",
	midair = "Building area is too high above ground. Turn around and try again.",
	facingWall = "You're too close to a wall. Turn around and try again.",
	recentActivity = "That building is active. Wait a moment before replacing it.",
	cooldown = "That building is recharging. Try again in a moment.",
	unknown = "Something went wrong. Try building somewhere else.",
	noBuilding = "Stand near one of your buildings to pick it up!"
}

local function getServerTime() -- line: 37
	return workspace:GetServerTimeNow()
end
local function getBuildingRecentActivityRemaining(p1) -- line: 60
	if not p1 or p1:GetAttribute("Destroyed") then
		return 0
	end

	local LastActiveTime = p1:GetAttribute("LastActiveTime")

	if typeof(LastActiveTime) ~= "number" then
		return 0
	end

	return (math.max(0, 10 - (workspace:GetServerTimeNow() - LastActiveTime)))
end
local function setBuildingAbilityLock(p2, s1: string, s2: string, b1: boolean, _: number?) -- line: 119
	-- upvalues: Util (copy)
	if p2.Player == game.Players.LocalPlayer then
		Util:ToggleLockForAbilityIcon(s1, s2, b1)
	end
end
local function initClientSentryAiming(p3) -- line: 153
	-- upvalues: u8 (ref), trove (copy), Spring (copy), CollectionService (copy), Util (copy), RunService (copy)
	if u8 then
		return
	end

	u8 = true

	local function setupSentry(p4) -- line: 164
		-- upvalues: trove (copy), Spring (copy), CollectionService (copy), p3 (copy), Util (copy), RunService (copy)
		if not p4.Name:find("Sentry") then
			return
		end

		local v106 = trove.new()
		local raycastParams = RaycastParams.new()

		raycastParams.FilterType = Enum.RaycastFilterType.Exclude

		local Torso = p4:WaitForChild("Torso", 10)
		local Head = p4:WaitForChild("Head", 10)

		if not Torso or not Head then
			return
		end

		local Neck = Torso:WaitForChild("Neck", 10)

		if not Neck then
			return
		end

		local NeckC0 = Neck.C0
		local u112 = Spring.new(NeckC0, 0.25)

		v106:Add(task.spawn(function() -- line: 189
			-- upvalues: p4 (copy), CollectionService (copy), raycastParams (copy), p3 (copy), Util (copy), Head (copy), Torso (copy), u112 (ref), NeckC0 (ref)
			while p4.Parent do
				if p4:GetAttribute("Destroyed") or not p4.PrimaryPart then
					task.wait(0.2)

					continue
				end

				if not p4:GetAttribute("Constructed") then
					task.wait(0.2)

					continue
				end

				if p4:GetAttribute("Disabled") and not p4:GetAttribute("Carrying") then
					task.wait(0.2)

					continue
				end

				local t3 = {
					p4,
					workspace.Players.Survivors
				}

				for _, v179 in CollectionService:GetTagged("SurvivorConstruct") do
					table.insert(t3, v179)
				end

				raycastParams.FilterDescendantsInstances = t3

				local v180 = (p4:GetAttribute("BuildingCount") or 1) - 1
				local v181 = p3.Config.SentryDamageRadius / 2
				local v182 = math.clamp(v181 * (1 - v180 * p3.Config.SentryRangeReductionPercentage / 100), p3.Config.SentryMinimumRange, v181)
				local ClosestPlayerFromPosition = Util:GetClosestPlayerFromPosition(p4.PrimaryPart.Position, {
					PlayerSelection = "Killers",
					MaxDistance = v182
				})

				if ClosestPlayerFromPosition and ClosestPlayerFromPosition.PrimaryPart and ClosestPlayerFromPosition.Humanoid.Health > 0 then
					local PrimaryPartPosition = p4.PrimaryPart.Position
					local LookVector = CFrame.lookAt(PrimaryPartPosition, ClosestPlayerFromPosition.PrimaryPart.Position).LookVector
					local raycastResult = workspace:Raycast(PrimaryPartPosition, LookVector * v182, raycastParams)

					if not raycastResult or not raycastResult.Instance:IsDescendantOf(ClosestPlayerFromPosition) then
						task.wait(0.2)

						continue
					end

					local function worldCFrameToC0ObjectSpace(p5, p6) -- line: 231
						local Part1CFrame = p5.Part1.CFrame
						local p5C1 = p5.C1
						local p5C0 = p5.C0
						local v213 = p5C0 * p5C1:Inverse() * Part1CFrame:Inverse() * p6 * p5C1

						return v213 - v213.Position + p5C0.Position
					end

					local cFrame = CFrame.lookAt(Head.Position, ClosestPlayerFromPosition.PrimaryPart.Position, Torso.CFrame.UpVector)
					local Neck2 = Torso.Neck
					local Part1CFrame = Neck2.Part1.CFrame
					local Neck2C1 = Neck2.C1
					local Neck2C0 = Neck2.C0
					local v193 = Neck2C0 * Neck2C1:Inverse() * Part1CFrame:Inverse() * cFrame * Neck2C1

					u112.Target = (v193 - v193.Position + Neck2C0.Position) * CFrame.Angles(-1.5707963267948966, 0, 0)

					if not p4:GetAttribute("Carrying") then
						for _, descendant in pairs(p4:GetDescendants()) do
							if (descendant:IsA("ParticleEmitter") or descendant:IsA("Light")) and descendant.Name == "Shoot" then
								task.spawn(function() -- line: 253
									-- upvalues: descendant (copy)
									descendant.Enabled = true
									task.wait(0.05)
									descendant.Enabled = false
								end)
							end
						end
					end
				else
					u112.Target = NeckC0
				end

				task.wait(0.2)
			end
		end))
		v106:Connect(RunService.RenderStepped, function(n2: number) -- line: 269
			-- upvalues: Neck (copy), u112 (ref)
			if Neck.Parent then
				Neck.C0 = u112:Update(n2)
			end
		end)
		p4.AncestryChanged:Connect(function(_, parent) -- line: 275
			-- upvalues: v106 (copy)
			if not parent then
				v106:Destroy()
			end
		end)
	end

	for _, v31 in CollectionService:GetTagged("SurvivorConstruct") do
		task.spawn(setupSentry, v31)
	end

	CollectionService:GetInstanceAddedSignal("SurvivorConstruct"):Connect(setupSentry)
end
local function cl_tweenCarryFOV(p8, b2: boolean) -- line: 678
	-- upvalues: Util (copy)
	if not p8.Rig then
		return
	end

	if p8.CarryFOVTween then
		p8.CarryFOVTween:Cancel()
		p8.CarryFOVTween = nil
	end

	if not p8.CarryFOVMultiplier or not p8.CarryFOVMultiplier.Parent then
		p8.CarryFOVMultiplier = Util:CreateFOVMultiplier(p8.Rig, 1, "BuildermanCarryFOV")
	end

	local v34 = game.TweenService:Create(p8.CarryFOVMultiplier, TweenInfo.new(p8.Config.CarryFOVTweenTime or 2.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
		Value = not b2 and 1 or (p8.Config.CarryFOVMultiplier or 1.1)
	})

	p8.CarryFOVTween = v34
	v34.Completed:Connect(function() -- line: 699
		-- upvalues: p8 (copy), v34 (copy), b2 (copy)
		if p8.CarryFOVTween == v34 then
			p8.CarryFOVTween = nil

			if not b2 then
				if p8.CarryFOVMultiplier and p8.CarryFOVMultiplier.Parent then
					p8.CarryFOVMultiplier:Destroy()
				end

				p8.CarryFOVMultiplier = nil
			end
		end
	end)
	v34:Play()
end
local function cl_dropBuilding(p9) -- line: 714
	-- upvalues: t1 (copy), cl_tweenCarryFOV (copy), Util (copy)
	local Move = t1.Abilities.Move
	local v37 = p9.Behavior and (p9.Behavior.Abilities and p9.Behavior.Abilities.Move)

	if v37 and Move then
		v37.Icon = Move.Icon
		v37.Name = Move.Name
	end

	p9.CarryingBuilding = nil
	cl_tweenCarryFOV(p9, false)
	
	Util:ToggleLockForAbilityIcon("Move", "invalidplacement", false)
end
local function safeAnimation(actor,name,playing)
 local track=actor.Animations and actor.Animations[name]
 if track then pcall(function()if playing then track:Play(.1)else track:Stop(.1)end end)end
end
local function releaseInputFreeze(actor)
 actor.BuilderInputPending=nil
 if actor.BuilderInputFreeze then actor.BuilderInputFreeze:Destroy();actor.BuilderInputFreeze=nil end
end
function t1.BeforeAbilityRequest(actor,kind)
 if kind~="Sentry"and kind~="Dispenser"then return nil end
 local rig=actor.Rig
 local root=rig and rig.PrimaryPart
 local hum=rig and rig:FindFirstChildOfClass("Humanoid")
 if not root or not hum or hum.Health<=0 or root.Anchored or actor.BuilderInputPending or actor.BuilderConstructionVisual or rig:GetAttribute("BuildermanCarrying")or rig:GetAttribute("Ragdolling")or rig:GetAttribute("Stunned")then return false end
 local cooldown=actor.Cooldowns and actor.Cooldowns[kind]
 if cooldown and cooldown.Duration>cooldown.TimePast then return false end
 local building=actor.Buildings and actor.Buildings[kind]
 if building and getBuildingRecentActivityRemaining(building)>0 then return false end
 local frame=root.CFrame
 local token={}
 actor.BuilderInputPending=token
 actor.BuilderInputFreeze=Util:CreateSpeedMultiplier(rig,0,"BuildermanInputFreeze")
 local velocity=root.AssemblyLinearVelocity
 root.AssemblyLinearVelocity=Vector3.new(0,velocity.Y,0)
 hum:Move(Vector3.new(0,0,0))
 task.delay(1.5,function()
  if actor.BuilderInputPending==token and not actor.BuilderConstructionVisual then releaseInputFreeze(actor)end
 end)
 return frame
end
local function constructBuildingOnClient(actor,kind,response)
 if type(response)=="table"and response.Cancelled then
  releaseInputFreeze(actor)
  Util:CreateWarning("BuildermanWarning",t2[response.Reason]or t2.unknown,actor.Config.Instances.WarningTemplate)
  return
 end
 local duration=type(response)=="table"and response.Duration or actor.Config[kind.."ConstructionDuration"]
 local progress=Util:CreateProgressBar("Building "..kind,duration)
 local token={}
 actor.BuilderConstructionVisual=token
 safeAnimation(actor,"ConstructStart",true)
 task.delay(.75,function()
  if actor.BuilderConstructionVisual==token then safeAnimation(actor,"ConstructStart",false);safeAnimation(actor,"ConstructLoop",true)end
 end)
 local deadline=os.clock()+duration+1
 task.spawn(function()
  while actor.Rig.Parent and os.clock()<deadline and actor.BuilderConstructionVisual==token do
   if actor.Rig:FindFirstChild("Result")then break end
   task.wait(.05)
  end
  progress:Destroy()
  releaseInputFreeze(actor)
  if actor.BuilderConstructionVisual==token then
   actor.BuilderConstructionVisual=nil
   safeAnimation(actor,"ConstructStart",false);safeAnimation(actor,"ConstructLoop",false)
   if actor.Rig.Parent then safeAnimation(actor,"ConstructEnd",true)end
  end
 end)
end
local function cl_setBuildingPlacedText(p13, s3: string, b3: boolean) -- line: 1020
	if p13.Player ~= game.Players.LocalPlayer then
		return
	end

	local AbilityContainer = p13.Player.PlayerGui.MainUI:FindFirstChild("AbilityContainer")
	local v50 = AbilityContainer and AbilityContainer:FindFirstChild(s3)

	if not v50 then
		return
	end

	v50.Charges.Text = not b3 and "" or "PLACED"
end
local function cl_watchBuildingActivityLock(p14, p15, s4: string) -- line: 1029
	-- upvalues: Util (copy)
	p14.BuildingActivityLockTokens = p14.BuildingActivityLockTokens or {}

	local t4 = {}

	p14.BuildingActivityLockTokens[s4] = t4

	local t5 = {}

	local function cleanup() -- line: 1036
		-- upvalues: t5 (copy)
		for _, v in pairs(t5) do
			v:Disconnect()
		end

		table.clear(t5)
	end
	local function refresh() -- line: 1043
		-- upvalues: p14 (copy), s4 (copy), t4 (copy), t5 (copy), p15 (copy), Util (copy), refresh (copy)
		if p14.BuildingActivityLockTokens[s4] ~= t4 then
			for _, v in pairs(t5) do
				v:Disconnect()
			end

			table.clear(t5)

			return
		end

		local v117 = p15
		local n3

		if not v117 or v117:GetAttribute("Destroyed") then
			n3 = 0
		else
			local LastActiveTime = v117:GetAttribute("LastActiveTime")

			n3 = if typeof(LastActiveTime) == "number" then math.max(0, 10 - (workspace:GetServerTimeNow() - LastActiveTime)) else 0
		end

		local v120 = n3 > 0
		local v121 = p14
		local v122 = s4

		if v121.Player == game.Players.LocalPlayer then
			Util:ToggleLockForAbilityIcon(v122, "recentactivity", v120)
		end

		if v120 then
			task.delay(n3 + 0.05, refresh)
		end
	end

	table.insert(t5, p15:GetAttributeChangedSignal("LastActiveTime"):Connect(refresh))
	table.insert(t5, p15:GetAttributeChangedSignal("Destroyed"):Connect(refresh))
	table.insert(t5, p15.AncestryChanged:Connect(function(_, parent) -- line: 1060
		-- upvalues: p14 (copy), s4 (copy), t4 (copy), Util (copy), t5 (copy)
		if parent then
			return
		end

		if p14.BuildingActivityLockTokens[s4] == t4 then
			p14.BuildingActivityLockTokens[s4] = nil

			local v125 = p14
			local v126 = s4

			if v125.Player == game.Players.LocalPlayer then
				Util:ToggleLockForAbilityIcon(v126, "recentactivity", false)
			end

			local v127 = p14
			local v128 = s4

			if v127.Player == game.Players.LocalPlayer then
				local AbilityContainer = v127.Player.PlayerGui.MainUI:FindFirstChild("AbilityContainer")
				local v130 = AbilityContainer and AbilityContainer:FindFirstChild(v128)

				if v130 then
					v130.Charges.Text = ""
				end
			end
		end

		for _, v in pairs(t5) do
			v:Disconnect()
		end

		table.clear(t5)
	end))

	if t4 ~= p14.BuildingActivityLockTokens[s4] then
		for _, v in pairs(t5) do
			v:Disconnect()
		end

		table.clear(t5)

		return
	end

	local n4

	if not p15 or p15:GetAttribute("Destroyed") then
		n4 = 0
	else
		local LastActiveTime = p15:GetAttribute("LastActiveTime")

		n4 = if typeof(LastActiveTime) == "number" then math.max(0, 10 - (workspace:GetServerTimeNow() - LastActiveTime)) else 0
	end

	local v62 = n4 > 0

	if p14.Player == game.Players.LocalPlayer then
		Util:ToggleLockForAbilityIcon(s4, "recentactivity", v62)
	end

	if v62 then
		task.delay(n4 + 0.05, refresh)
	end
end
local function cl_updateBuildingActivityBars(p17) -- line: 1077
	local v64 = p17.Behavior and p17.Behavior.Abilities

	if not v64 then
		return
	end

	for _, v in ipairs({
		"Sentry",
		"Dispenser"
	}) do
		local v67 = v64[v]

		if v67 then
			local v68 = p17.Buildings and p17.Buildings[v]
			local n5

			if not v68 or v68:GetAttribute("Destroyed") then
				n5 = 0
			else
				local LastActiveTime = v68:GetAttribute("LastActiveTime")

				n5 = if typeof(LastActiveTime) == "number" then math.max(0, 10 - (workspace:GetServerTimeNow() - LastActiveTime)) else 0
			end

			if n5 > 0 then
				v67.CurrentRecharge = 10 - n5
				v67.ChargeDuration = 10
			else
				v67.CurrentRecharge = 0
				v67.ChargeDuration = 0
			end
		end
	end
end
local function updateBuildingCarryVisual(building)
 CarryVisuals.Update(building)
end

t1.Abilities = {
	Sentry = {
		LayoutOrder = 1,
		KeybindType = "AltAbility1",
		Icon = "rbxassetid://104441527277654",
		CurrentRecharge = 0,
		ChargeDuration = 0,
		RechargeInverted = true,
		Callback = function(p19, p20) -- line: 1129
			-- upvalues: constructBuildingOnClient (copy)
			constructBuildingOnClient(p19, "Sentry", p20)
		end
	},
	Dispenser = {
		LayoutOrder = 2,
		KeybindType = "AltAbility2",
		Icon = "rbxassetid://102952736333903",
		CurrentRecharge = 0,
		ChargeDuration = 0,
		RechargeInverted = true,
		Callback = function(p21, p22) -- line: 1260
			-- upvalues: constructBuildingOnClient (copy)
			constructBuildingOnClient(p21, "Dispenser", p22)
		end
	},
	Move = {
		LayoutOrder = 3,
		KeybindType = "AltAbility3",
		Icon = "rbxassetid://97983142047580",
		Name = "Carry",
		SpecialName = "Place",
		SpecialIcon = "rbxassetid://109402731902696",
		Callback = function(p23, p24) -- line: 1353
			-- upvalues: t2 (copy), Util (copy), t1 (copy), cl_tweenCarryFOV (copy), Network (copy), cl_dropBuilding (copy)
			if typeof(p24) == "string" then
				local v79 = t2[p24] or "Something went wrong. Try building somewhere else."

				Util:CreateWarning("BuildermanWarning", v79, p23.Config.Instances.WarningTemplate)

				return
			end

			if typeof(p24) == "Instance" then
				if p23.CarryableBuildingHighlight then
					p23.CarryableBuildingHighlight.Adornee = nil
				end

				p23.CarryingBuilding = p24

				local Move = t1.Abilities.Move
				local v81 = p23.Behavior and (p23.Behavior.Abilities and p23.Behavior.Abilities.Move)

				if v81 and Move then
					v81.Icon = Move.SpecialIcon
					v81.Name = Move.SpecialName
				end

				cl_tweenCarryFOV(p23, true)
				
				p23.AnimationType = "Pick"
				Network:FireConnection("DisableSprinting", "CarryingBuilding", true)

                safeAnimation(p23,"PickUp",true)

			else
				p23.AnimationType = nil
				Network:FireConnection("DisableSprinting", "CarryingBuilding", false)

                safeAnimation(p23,"PutDown",true)

				cl_dropBuilding(p23)
			end
		end
	}
}

function t1.Created(_, p26) -- line: 1527
	-- upvalues: trove (copy), updateBuildingCarryVisual (copy), Network (copy), Util (copy), cl_dropBuilding (copy), initClientSentryAiming (copy), cl_watchBuildingActivityLock (copy), RunService (copy), cl_updateBuildingActivityBars (copy), cl_tweenCarryFOV (copy)
	p26.CarryingBuilding = nil
	p26.CarryableBuilding = nil

	if p26.Rig then
		p26.Rig:SetAttribute("IsBuilderman", true)
	end

	if p26.Rig == game.Players.LocalPlayer.Character then
		p26.RadiusStorages = {}
		p26.CarryableBuildingHighlight = Instance.new("SelectionBox")
		p26.CarryableBuildingHighlight.Color3 = Color3.fromRGB(255, 220, 50)
		p26.CarryableBuildingHighlight.LineThickness = 0.05
		p26.CarryableBuildingHighlight.SurfaceTransparency = 0.8
		p26.CarryableBuildingHighlight.Parent = script

		local function createRadiusStorage(p27, p28) -- line: 1590
			-- upvalues: p26 (copy)
			local Model = Instance.new("Model")

			Model.Parent = workspace.Map.Ingame
			Model.Name = p27
			p26.RadiusStorages[p27] = Model

			local Highlight = Instance.new("Highlight")

			Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
			Highlight.FillTransparency = 0.875
			Highlight.OutlineTransparency = 0.6
			Highlight.FillColor = p28
			Highlight.Parent = Model
		end

		local color3 = Color3.fromRGB(70, 155, 255)
		local Model = Instance.new("Model")

		Model.Parent = workspace.Map.Ingame
		Model.Name = "PlacementRange"
		p26.RadiusStorages.PlacementRange = Model

		local Highlight = Instance.new("Highlight")

		Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
		Highlight.FillTransparency = 0.875
		Highlight.OutlineTransparency = 0.6
		Highlight.FillColor = color3
		Highlight.Parent = Model

		local color3_2 = Color3.fromRGB(255, 80, 80)
		local Model2 = Instance.new("Model")

		Model2.Parent = workspace.Map.Ingame
		Model2.Name = "BuildermanSentryEffectRange"
		p26.RadiusStorages.BuildermanSentryEffectRange = Model2

		local Highlight2 = Instance.new("Highlight")

		Highlight2.DepthMode = Enum.HighlightDepthMode.Occluded
		Highlight2.FillTransparency = 0.875
		Highlight2.OutlineTransparency = 0.6
		Highlight2.FillColor = color3_2
		Highlight2.Parent = Model2

		local color3_3 = Color3.fromRGB(80, 255, 80)
		local Model3 = Instance.new("Model")

		Model3.Parent = workspace.Map.Ingame
		Model3.Name = "BuildermanDispenserEffectRange"
		p26.RadiusStorages.BuildermanDispenserEffectRange = Model3

		local Highlight3 = Instance.new("Highlight")

		Highlight3.DepthMode = Enum.HighlightDepthMode.Occluded
		Highlight3.FillTransparency = 0.875
		Highlight3.OutlineTransparency = 0.6
		Highlight3.FillColor = color3_3
		Highlight3.Parent = Model3

		local function createRadius(p29, p30) -- line: 1608
			-- upvalues: p26 (copy)
			local v139 = p26.RadiusStorages[p29]

			if not v139 then
				return
			end

			if not p30 then
				return
			end

			local Part = Instance.new("Part")

			Part.CanCollide = false
            Part.CanQuery=false;Part.CanTouch=false
			Part.Anchored = true
			Part.Transparency = 1
			Part.Position = Vector3.new(0, -100, 0)
			Part.Orientation = Vector3.new(0, 0, 90)
			Part.Size = Vector3.new(0.25, p30, p30)
			Part.Material = Enum.Material.Glass
			Part.Shape = Enum.PartType.Cylinder
			Part.Parent = v139

			return Part
		end

		p26.BuildingVisualTroves = p26.BuildingVisualTroves or {}
		p26.Connection = workspace.Map.Ingame.ChildAdded:Connect(function(child) -- line: 1626
			-- upvalues: p26 (copy), trove (copy), updateBuildingCarryVisual (copy), createRadius (copy)
			if child.Name:find("Builderman") then
				local Humanoid = child:WaitForChild("Humanoid", 10)

				if not Humanoid then
					return
				end

				local Root = child:WaitForChild("Root", 10)

				if not Root then
					return
				end

				child:SetAttribute("ClientCarryWatcherSet", true)

				if p26.BuildingVisualTroves[child] then
					p26.BuildingVisualTroves[child]:Destroy()
				end

				local v144 = trove.new()

				p26.BuildingVisualTroves[child] = v144
				task.spawn(function() -- line: 1641
					-- upvalues: child (copy), updateBuildingCarryVisual (copy)
					updateBuildingCarryVisual(child)
                    if child:WaitForChild("PlayerAura", 10) then
						updateBuildingCarryVisual(child)
					end
				end)

				local t6 = {
					BuildermanSentryPlacementRange = p26.Config.SentryPlacementRadius,
					BuildermanSentryEffectRange = p26.Config.SentryDamageRadius,
					BuildermanDispenserPlacementRange = p26.Config.DispenserPlacementRadius,
					BuildermanDispenserEffectRange = p26.Config.DispenserHealingRadius
				}
				local v146 = `{ child.Name }PlacementRange`
				local v147 = `{ child.Name }EffectRange`
				local v148 = createRadius("PlacementRange", t6[v146])
				local v149 = createRadius(v147, t6[v147])

				if v148 then
					v144:Add(v148)
				end

				if v149 then
					v144:Add(v149)
				end

				local function syncRadiusPositions() -- line: 1662
					-- upvalues: v148 (copy), Root (copy), v149 (copy)
					if v148 then
						v148.Position = Root.Position - Vector3.new(0, Root.Size.Y / 2 + 0.075, 0)
					end

					if v149 then
						v149.Position = Root.Position - Vector3.new(0, Root.Size.Y / 2, 0)
					end
				end

				syncRadiusPositions()
				v144:Connect(Root:GetPropertyChangedSignal("Position"), syncRadiusPositions)
                v144:Connect(child:GetAttributeChangedSignal("Destroyed"),function()
                    if child:GetAttribute("Destroyed")then
                        v144:Destroy()
                        if p26.BuildingVisualTroves then p26.BuildingVisualTroves[child]=nil end
                    end
                end)

				v144:Connect(child:GetAttributeChangedSignal("EffectRadiusSize"), function() -- line: 1668
					-- upvalues: child (copy), v149 (copy)
					if child:GetAttribute("Destroyed") or child:GetAttribute("Carrying") then
						return
					end

					local EffectRadiusSize = child:GetAttribute("EffectRadiusSize")

					if v149 then
						game.TweenService:Create(v149, TweenInfo.new(1), {
							Size = Vector3.new(0.25, EffectRadiusSize * 2, EffectRadiusSize * 2)
						}):Play()
					end
				end)
				v144:Connect(child:GetAttributeChangedSignal("Carrying"), function() -- line: 1677
					-- upvalues: child (copy), updateBuildingCarryVisual (copy), v148 (copy), v149 (copy), Root (copy), t6 (copy), v147 (copy), v146 (copy)
					if child:GetAttribute("Destroyed") then
						return
					end

					updateBuildingCarryVisual(child)

					if child:GetAttribute("Carrying") then
						if v148 then
							game.TweenService:Create(v148, TweenInfo.new(0.5), {
								Size = Vector3.new(0, 0, 0)
							}):Play()
						end

						if v149 then
							game.TweenService:Create(v149, TweenInfo.new(0.5), {
								Size = Vector3.new(0, 0, 0)
							}):Play()

							return
						end
					else
						if v148 then
							v148.Position = Root.Position - Vector3.new(0, Root.Size.Y / 2 + 0.075, 0)
						end

						if v149 then
							v149.Position = Root.Position - Vector3.new(0, Root.Size.Y / 2, 0)
						end

						local v200 = child:GetAttribute("EffectRadiusSize") or t6[v147]
						local v201 = t6[v146]
						local tweenInfo = TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

						if v149 then
							game.TweenService:Create(v149, tweenInfo, {
								Size = Vector3.new(0.25, v200 * 2, v200 * 2)
							}):Play()
						end

						if v148 then
							game.TweenService:Create(v148, tweenInfo, {
								Size = Vector3.new(0.25, v201, v201)
							}):Play()
						end
					end
				end)
				v144:Connect(Humanoid.HealthChanged, function(p31) -- line: 1694
					-- upvalues: v144 (copy), p26 (copy), child (copy)
					if p31 <= 0 then
						v144:Destroy()

						if p26.BuildingVisualTroves then
							p26.BuildingVisualTroves[child] = nil
						end
					end
				end)
				v144:Connect(child.AncestryChanged, function(_, p33) -- line: 1703
					-- upvalues: v144 (copy), p26 (copy), child (copy)
					if not p33 then
						v144:Destroy()

						if p26.BuildingVisualTroves then
							p26.BuildingVisualTroves[child] = nil
						end
					end
				end)
			end
		end)
		Network:SetConnection(`{ p26.Player.Name }UpdateClosestBuilding`, "REMOTE_EVENT", function(p34) -- line: 1714
			-- upvalues: p26 (copy), Util (copy)
			if p26.CarryableBuildingHighlight then
				p26.CarryableBuildingHighlight.Adornee = p34
			end

			Util:ToggleLockForAbilityIcon("Move", "nobuildinglmao", not p34)
		end)
		Network:SetConnection(`{ p26.Player.Name }ForceDropBuilding`, "REMOTE_EVENT", function() -- line: 1721
			-- upvalues: p26 (copy), Network (copy), cl_dropBuilding (copy), Util (copy)
			p26.AnimationType = nil
			Network:FireConnection("DisableSprinting", "CarryingBuilding", false)
			cl_dropBuilding(p26)
			Util:ToggleLockForAbilityIcon("Move", "nobuildinglmao", false)
			task.defer(function() -- line: 1726
				-- upvalues: Util (copy)
				Util:ToggleLockForAbilityIcon("Move", "nobuildinglmao", true)
			end)
		end)
	end

	initClientSentryAiming(p26)
	p26.Buildings = {}
	p26.CarryVisualTroves = p26.CarryVisualTroves or {}
    local function refreshCarryOutlines()
        for _,building in workspace.Map.Ingame:GetChildren()do
            if building.Name=="BuildermanSentry"or building.Name=="BuildermanDispenser"then updateBuildingCarryVisual(building)end
        end
    end
    task.defer(refreshCarryOutlines)
    p26.BuilderViewerConnection=game.Players.LocalPlayer.CharacterAdded:Connect(function()task.defer(refreshCarryOutlines)end)

	p26.CarryVisualConnection = workspace.Map.Ingame.ChildAdded:Connect(function(child) -- line: 1737
		-- upvalues: p26 (copy), trove (copy), updateBuildingCarryVisual (copy)
		if child.Name:find("Builderman") then
			if child:GetAttribute("ClientCarryWatcherSet") then
				return
			end

			child:SetAttribute("ClientCarryWatcherSet", true)

			if p26.CarryVisualTroves[child] then
				p26.CarryVisualTroves[child]:Destroy()
			end

			local v153 = trove.new()

			p26.CarryVisualTroves[child] = v153
			task.spawn(function() -- line: 1748
				-- upvalues: child (copy), updateBuildingCarryVisual (copy)
				updateBuildingCarryVisual(child)
                    if child:WaitForChild("PlayerAura", 10) then
					updateBuildingCarryVisual(child)
				end
			end)
			v153:Connect(child:GetAttributeChangedSignal("Carrying"), function() -- line: 1755
				-- upvalues: child (copy), updateBuildingCarryVisual (copy)
				if child:GetAttribute("Destroyed") then
					return
				end

				updateBuildingCarryVisual(child)
			end)
			v153:Connect(child.AncestryChanged, function(_, p36) -- line: 1760
				-- upvalues: v153 (copy), p26 (copy), child (copy)
				if not p36 then
					v153:Destroy()

					if p26.CarryVisualTroves then
						p26.CarryVisualTroves[child] = nil
					end
				end
			end)
		end
	end)
	Network:SetConnection(`{ p26.Player.Name }ReplicateBuildingAsync`, "REMOTE_EVENT", function(p37, s5: string) -- line: 1774
		-- upvalues: p26 (copy), cl_watchBuildingActivityLock (copy)
		if p26.Player ~= game.Players.LocalPlayer then
			return
		end

		p26.Buildings[s5] = p37
		cl_watchBuildingActivityLock(p26, p37, s5)

		local v156 = p26
		local v157 = p37.Parent ~= nil and not p37:GetAttribute("Destroyed")

		if v156.Player ~= game.Players.LocalPlayer then
			return
		end

		local AbilityContainer = v156.Player.PlayerGui.MainUI:FindFirstChild("AbilityContainer")
		local v159 = AbilityContainer and AbilityContainer:FindFirstChild(s5)

		if not v159 then
			return
		end

		v159.Charges.Text = not v157 and "" or "PLACED"
	end)
    Network:SetConnection(p26.Player.Name.."ConstructionRejected","REMOTE_EVENT",function(reason)
        if p26.Player==game.Players.LocalPlayer then releaseInputFreeze(p26);Util:CreateWarning("BuildermanWarning",t2[reason]or t2.unknown,p26.Config.Instances.WarningTemplate)end
    end)
	Network:SetConnection(`{ p26.Player.Name }UpdateCanPlace`, "REMOTE_EVENT", function(b4: boolean) -- line: 1783
		-- upvalues: Util (copy)
		Util:ToggleLockForAbilityIcon("Move", "invalidplacement", not b4)
	end)
	Network:SetConnection(`{ p26.Player.Name }UpdateBuildingAbilityLock`, "REMOTE_EVENT", function(s6: string, s7: string, b5: boolean) -- line: 1790
		-- upvalues: Util (copy)
		Util:ToggleLockForAbilityIcon(s6, s7, b5)
	end)
	Network:SetConnection(`{ p26.Player.Name }ReplicateDestroyedBuildingAsync`, "REMOTE_EVENT", function(s8: string) -- line: 1798
		-- upvalues: p26 (copy), Util (copy)
		if p26.Player ~= game.Players.LocalPlayer then
			return
		end

		p26.Buildings[s8] = nil

		if p26.BuildingActivityLockTokens then
			p26.BuildingActivityLockTokens[s8] = nil
		end

		Util:ToggleLockForAbilityIcon(s8, "recentactivity", false)

		local v165 = p26.Behavior and (p26.Behavior.Abilities and p26.Behavior.Abilities[s8])

		if v165 then
			v165.CurrentRecharge = 0
			v165.ChargeDuration = 0
		end

		local v166 = p26

		if v166.Player ~= game.Players.LocalPlayer then
			return
		end

		local AbilityContainer = v166.Player.PlayerGui.MainUI:FindFirstChild("AbilityContainer")
		local v168 = AbilityContainer and AbilityContainer:FindFirstChild(s8)

		if not v168 then
			return
		end

		v168.Charges.Text = ""
	end)
	p26.BuildingActivityBarConnection = RunService.RenderStepped:Connect(function() -- line: 1817
		-- upvalues: p26 (copy), cl_updateBuildingActivityBars (copy)
		if not p26.Rig or not p26.Rig.Parent then
			if p26.BuildingActivityBarConnection then
				p26.BuildingActivityBarConnection:Disconnect()
				p26.BuildingActivityBarConnection = nil
			end

			return
		end

		cl_updateBuildingActivityBars(p26)
	end)
	p26.Rig.AncestryChanged:Connect(function(_, parent) -- line: 1829
		-- upvalues: p26 (copy), cl_tweenCarryFOV (copy), Network (copy)
		if parent then
			return
		end

		if p26.CarryVisualConnection then
			p26.CarryVisualConnection:Disconnect()
			p26.CarryVisualConnection = nil
		end

		for _, v in pairs(p26.CarryVisualTroves or {}) do
			v:Destroy()
		end

		p26.CarryVisualTroves = nil

		if p26.Player == game.Players.LocalPlayer then
			cl_tweenCarryFOV(p26, false)

			if p26.Connection then
				p26.Connection:Disconnect()
			end

			if p26.BuildingActivityBarConnection then
				p26.BuildingActivityBarConnection:Disconnect()
				p26.BuildingActivityBarConnection = nil
			end

			for _, v in pairs(p26.BuildingVisualTroves or {}) do
				v:Destroy()
			end

			p26.BuildingVisualTroves = nil

			for _, v in pairs(p26.RadiusStorages or {}) do
				v:Destroy()
			end

			if p26.CarryableBuildingHighlight then
				p26.CarryableBuildingHighlight:Destroy()
				p26.CarryableBuildingHighlight = nil
			end

			Network:RemoveConnection(`{ p26.Player.Name }UpdateClosestBuilding`, "REMOTE_EVENT")
			Network:RemoveConnection(`{ p26.Player.Name }ForceDropBuilding`, "REMOTE_EVENT")
			Network:RemoveConnection(`{ p26.Player.Name }UpdateCanPlace`, "REMOTE_EVENT")
			Network:RemoveConnection(`{ p26.Player.Name }UpdateBuildingAbilityLock`, "REMOTE_EVENT")
		end

		p26.Buildings = {}
		Network:RemoveConnection(`{ p26.Player.Name }ReplicateBuildingAsync`, "REMOTE_EVENT")
	end)
end
function t1.Destroyed(_, p40) -- line: 1873
	-- upvalues: cl_tweenCarryFOV (copy), Network (copy)
	p40.BuilderConstructionVisual=nil
 releaseInputFreeze(p40)
 if p40.BuilderViewerConnection then p40.BuilderViewerConnection:Disconnect();p40.BuilderViewerConnection=nil end
	if p40.CarryVisualConnection then
		p40.CarryVisualConnection:Disconnect()
		p40.CarryVisualConnection = nil
	end

	for _, v in pairs(p40.CarryVisualTroves or {}) do
		v:Destroy()
	end

	p40.CarryVisualTroves = nil

	if p40.Player == game.Players.LocalPlayer then
		cl_tweenCarryFOV(p40, false)

		if p40.Connection then
			p40.Connection:Disconnect()
			p40.Connection = nil
		end

		if p40.BuildingActivityBarConnection then
			p40.BuildingActivityBarConnection:Disconnect()
			p40.BuildingActivityBarConnection = nil
		end

		for _, v in pairs(p40.BuildingVisualTroves or {}) do
			v:Destroy()
		end

		p40.BuildingVisualTroves = nil

		for _, v in pairs(p40.RadiusStorages or {}) do
			v:Destroy()
		end

		if p40.CarryableBuildingHighlight then
			p40.CarryableBuildingHighlight:Destroy()
			p40.CarryableBuildingHighlight = nil
		end

		Network:RemoveConnection(p40.Player.Name.."ConstructionRejected","REMOTE_EVENT")
		Network:FireConnection("DisableSprinting","CarryingBuilding",false)
		Network:RemoveConnection(`{ p40.Player.Name }UpdateClosestBuilding`, "REMOTE_EVENT")
		Network:RemoveConnection(`{ p40.Player.Name }ForceDropBuilding`, "REMOTE_EVENT")
		Network:RemoveConnection(`{ p40.Player.Name }UpdateCanPlace`, "REMOTE_EVENT")
		Network:RemoveConnection(`{ p40.Player.Name }UpdateBuildingAbilityLock`, "REMOTE_EVENT")
		Network:RemoveConnection(`{ p40.Player.Name }ReplicateBuildingAsync`, "REMOTE_EVENT")
		Network:RemoveConnection(`{ p40.Player.Name }ReplicateDestroyedBuildingAsync`, "REMOTE_EVENT")
	end
end

function t1.Use(actor,kind,response)
 local ability=t1.Abilities[kind]
 if ability then return ability.Callback(actor,response)end
end
return t1
]========]},
}
for _,change in changes do change.before=change.target.Source;assert(fingerprint(change.before)==change.expected,"Current Builderman module differs: "..change.target:GetFullName()..". Nothing changed; send its Source for a matching repair.")end
local shared={
{path=[========[
ReplicatedStorage/Systems/Player/Networks/ActorNetwork]========],options={
{expected=[========[
34012:0d03b83d:cf842ce4]========],after=[========[
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

                    local haste=Statuses:PlayerHasStatus(LocalPlayer,"Haste")
                    local accelerated=v167~=nil and haste~=nil and haste~=false
                        and not table.find(haste.Data and haste.Data.DisabledAbilityNames or {},k)
                    local label=k3 and k3:FindFirstChild("CooldownTime")
                    if label then
                        local base=label:GetAttribute("BaseTextColor")
                        if not base then base=label.TextColor3;label:SetAttribute("BaseTextColor",base)end
                        label.TextColor3=accelerated and Color3.fromRGB(0,255,0)or base
                    end
					if v167 then
						local Duration = v167.Duration
						local TimePast = v167.TimePast
						local v184 = Duration>0 and math.clamp(TimePast / Duration, 0, 1)or 1
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

				local function useAbility()
                    local frame
                    if p6.ActorName=="Builderman"and (k=="Sentry"or k=="Dispenser")then
                        local prepare=p6.Behavior and p6.Behavior.BeforeAbilityRequest
                        if prepare then
                            frame=prepare(p6,k)
                            if frame==false then return end
                        end
                    end
                    Network:FireServerConnection("UseActorAbility","REMOTE_EVENT",k,frame)
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
							useAbility()

							return
						end
					elseif not v100 and not v103 then
						useAbility()
					end
				end)

				if not v104 then
					clone3.MouseButton1Down:Connect(function() -- line: 754
						-- upvalues: p6 (copy), k (copy), v100 (copy), v103 (copy), Network (copy)
						p6.HeldAbilities[k] = true

						if v100 or v103 then
							useAbility()
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
								useAbility()

								return
							end
						else
							p6.HeldAbilities[k] = true
							useAbility()
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
	Network:SetConnection("UpdateAbilityCooldown", "REMOTE_EVENT", function(p21, p22, preserveProgress) -- line: 994
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
            elseif preserveProgress and v41.Cooldowns[p21] then
                local cooldown=v41.Cooldowns[p21]
                cooldown.Duration=math.max(cooldown.Duration,p22)
                cooldown.TimePast=math.max(0,cooldown.Duration-p22)
            else
                v41.Cooldowns[p21] = {TimePast=0,Duration=p22}
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

]========]},
{expected=[========[
33064:4c326576:82949327]========],after=[========[
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

				local function useAbility()
                    local frame
                    if p6.ActorName=="Builderman"and (k=="Sentry"or k=="Dispenser")then
                        local prepare=p6.Behavior and p6.Behavior.BeforeAbilityRequest
                        if prepare then
                            frame=prepare(p6,k)
                            if frame==false then return end
                        end
                    end
                    Network:FireServerConnection("UseActorAbility","REMOTE_EVENT",k,frame)
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
							useAbility()

							return
						end
					elseif not v100 and not v103 then
						useAbility()
					end
				end)

				if not v104 then
					clone3.MouseButton1Down:Connect(function() -- line: 754
						-- upvalues: p6 (copy), k (copy), v100 (copy), v103 (copy), Network (copy)
						p6.HeldAbilities[k] = true

						if v100 or v103 then
							useAbility()
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
								useAbility()

								return
							end
						else
							p6.HeldAbilities[k] = true
							useAbility()
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

]========]},
}},
{path=[========[
ServerScriptService/Server/Systems/Core/ActorHandler]========],options={
{expected=[========[
9835:ec470be8:f9ad0321]========],after=[========[
local module = {}

-- variables
local ReplicatedStorage = game.ReplicatedStorage
local Rigs = game.ServerStorage.Assets.Rigs -- optional location for rigs on the server. safer, but less convenient and less accurate to forsaken.
local ServerBehaviors = game.ServerScriptService.Server.Modules.ActorBehaviors -- where server protected behaviors are stored. (no clue why forsaken doesn't do something like this)

-- dependencies
local Network = require(ReplicatedStorage.Modules.Network)
local Actors = require(ReplicatedStorage.Modules.Actors)
local Util = require(ReplicatedStorage.Modules.Util)
local ServerUtil = require(game.ServerScriptService.Server.Modules.ServerUtil)
local safecall = ServerUtil.SafeCall
local Types = require(game.ReplicatedStorage.GlobalTypes)
local DataHandler = require(ReplicatedStorage.Modules.DataHandler)

local function cleanRig(rig : Model)
	local hum = rig:FindFirstChildOfClass("Humanoid")
	if hum and not hum:FindFirstChildOfClass("Animator") then
		Instance.new("Animator", hum)
	end
	if rig:FindFirstChild("AnimSaves") then
		rig.AnimSaves:Destroy()
	end
end

local function getOrCreateServerParent(assetFolder)
	local serverAssets = game.ServerStorage.Assets
	local parent = assetFolder.Parent
	if not parent then return nil end
	local grandParent = parent.Parent
	if not grandParent then return nil end

	if grandParent.Name == "Assets" then
		local pName = parent.Name
		local folder = serverAssets:FindFirstChild(pName)
		if not folder then
			folder = Instance.new("Folder")
			folder.Name = pName
			folder.Parent = serverAssets
		end
		return folder
	end

	local greatGrandParent = grandParent.Parent
	if greatGrandParent and greatGrandParent.Name == "Skins" then
		local skins = serverAssets:FindFirstChild("Skins")
		if not skins then
			skins = Instance.new("Folder")
			skins.Name = "Skins"
			skins.Parent = serverAssets
		end

		local categoryName = grandParent.Name
		local category = skins:FindFirstChild(categoryName)
		if not category then
			category = Instance.new("Folder")
			category.Name = categoryName
			category.Parent = skins
		end

		local actorName = parent.Name
		local actor = category:FindFirstChild(actorName)
		if not actor then
			actor = Instance.new("Folder")
			actor.Name = actorName
			actor.Parent = category
		end

		return actor
	end
	return nil
end

function module.Start()
	-- ability handling
	Network:SetConnection('UseActorAbility', 'REMOTE_EVENT', function(Player: Player, Name : string, requestFrame)
		-- setup variables
		local Actor : Types.Actor = Actors.CurrentActors[Player]
		if not Actor then return end

		-- Ensure player data is loaded using DataHandler
		local PlayerData = DataHandler:Get(Player)
		if not PlayerData then
			return
		end

		local Config = Actor.Config
		local Behavior = Actor.CustomBehavior or Actor.Behavior
		local Abilities = Behavior.Abilities

		-- checks
		if not (Player.Character and Player.Character.PrimaryPart and Player.Character.PrimaryPart.Anchored == false) then
			return
		end
		if not Actor:CanUseAbility(Name) then
			return
		end

		-- ability info
		local Ability = Abilities[Name]
		local Charges = Ability.CurrentCharges
		
		-- used for achievements
		if Ability.KeybindType ~= "MainAbility" then
			Player.Character:SetAttribute("AbilitiesUsed", (Player.Character:GetAttribute("AbilitiesUsed") or 0)+1)
		end

		-- handle cooldown
		local Time = tonumber(Config and typeof(Config) == "table" and Config.Cooldown or typeof(Ability.Cooldown) == "function" and Ability.Cooldown(Actor, Name) or Ability.Cooldown or Config[`{Name}Cooldown`] or Actor[("%s*Cooldown"):format(Name)]) or 0;
		if workspace:GetAttribute('CooldownsDisabled') then
			Time = 0
		end
		if Time > 0 then
			Actor:SetCooldownOf(Name, Time)
		end
		
		-- update charges
		if Charges then
			if (not workspace:GetAttribute('ChargesDisabled')) and (not Ability.ChargesDisabled) then
				Actor:IncrementCharges(Name, -1);
			end
		end
		
		-- get the callback function for the ability
		local callbackFunction
		if Behavior.Protected then
			-- handle skid protection for abilities
			local protectedBehavior = ServerBehaviors:FindFirstChild(Actor.ActorType) and ServerBehaviors[Actor.ActorType]:FindFirstChild(Actor.ActorName)
			if not protectedBehavior then
				warn(`[ActorHandler] Could not find {Actor.ActorName}'s protected behavior.`)
				return
			end

			local success = safecall(function() protectedBehavior = require(protectedBehavior) end)
			if not success then
				warn(`[ActorHandler] Failed to require {Actor.ActorName}'s protected behavior.`)
				return
			end

			callbackFunction = protectedBehavior.Abilities and protectedBehavior.Abilities[Name]
			if not callbackFunction then
				warn(`[ActorHandler] Could not find ability {Name} in {Actor.ActorName}'s protected behavior.`)
				return
			end
		else
			callbackFunction = Ability.Callback
		end

		-- calls the found callback function and gets the result
		local result
        if Actor.ActorName=="Builderman"and(Name=="Sentry"or Name=="Dispenser")then result=callbackFunction(Actor,requestFrame)
        else result=callbackFunction(Actor)end

		-- sets the cooldown to 0 if the ability returns cancelled
		if type(result) == "table" and result.Cancelled then
			Actor:SetCooldownOf(Name, 0)
			return
		end
		
		-- sends the result to the client
		Network:FireClientConnection(Player, 'UseActorAbility', 'REMOTE_EVENT', Name, result)

		-- handle thanks interaction for survivor requests
		if Player.Character and Player.Character:GetAttribute("Requested_"..Name) then
			local requester = Player.Character:GetAttribute("Requested_"..Name)
			if game.Players:FindFirstChild(requester) then
				Actors:CreateChatInteraction(game.Players[requester].Character, "Thanks/Thanks", Player.Character)
				Player.Character:SetAttribute("cRequested_"..Name, nil)
			end
		end
		
		if Actor.Behavior.OnAbilityUsed then
			Actor.Behavior.OnAbilityUsed(Actor, Name)
		end

		-- play voiceline for the ability
		Actor:PlayVoiceline(Name)
	end)

	-- ensure base folders exist on the server
	for _, folderName in {"Killers", "Survivors", "Skins"} do
		if not game.ServerStorage.Assets:FindFirstChild(folderName) then
			local newFolder = Instance.new("Folder")
			newFolder.Name = folderName
			newFolder.Parent = game.ServerStorage.Assets
		end
	end

	-- create a folder to store all rigs found in replicatedstorage
	local storedFolder = Instance.new("Folder", game.ServerStorage.Assets.Instances)
	storedFolder.Name = "Stored"
	Instance.new("Folder", storedFolder).Name = "Rigs"
	Instance.new("Folder", storedFolder).Name = "Decoys"
	
	-- tosearch array, the code will search through items in this array and attempt to find configs in their children
	local ToSearch = {game.ReplicatedStorage.Assets.Killers, game.ReplicatedStorage.Assets.Survivors}
	for _, actortype in game.ReplicatedStorage.Assets.Skins:GetChildren() do
		for _, actor in actortype:GetChildren() do
			table.insert(ToSearch, actor)
		end
	end
	
	-- go through every config in replicatedstorage.assets
	for _, folder : Folder in ToSearch do
		for _, assetFolder : Folder in folder:GetChildren() do
			if assetFolder:IsA("Folder") and assetFolder:FindFirstChild("Config") and assetFolder.Config:IsA("ModuleScript") then
				-- setup variables
				local config : ModuleScript = assetFolder.Config

				-- first attempts to find a rig in the replicatedstorage folder
				local rig : Model = assetFolder:FindFirstChild("Rig")
				if rig and rig:IsA("Model") then
					-- if successfully found, set the config's rig and continue
					cleanRig(rig)
					require(config).Rig = rig
					rig.Parent = storedFolder.Rigs
				else
					-- get the type of rig to look for
					local rigType = assetFolder.Parent.Name == "Killers" and "Killers" or assetFolder.Parent.Name == "Survivors" and "Survivors" or assetFolder.Parent.Parent.Parent.Name == "Skins" and "Skins"
					if rigType then
						-- identify info about the rig
						local actorType
						local actorName
						local skinName
						if rigType == "Skins" then
							actorType = assetFolder.Parent.Parent.Name
							actorName = assetFolder.Parent.Name
							skinName = assetFolder.Name
						else
							actorType = assetFolder.Parent.Name
							actorName = assetFolder.Name
						end

						-- attempt to find the rig inside serverstorage
						rig = Rigs:FindFirstChild(actorType) and Rigs[actorType]:FindFirstChild(actorName) and Rigs[actorType][actorName]:FindFirstChild(skinName or "Default")
						if not rig then
							warn("[ACTORHANDLER] NO RIG FOUND FOR "..assetFolder:GetFullName())
						else
							cleanRig(rig)

							-- set the config's rig
							safecall(function()
								require(config).Rig = rig
							end)
						end
					end
				end
				
				local requiredConfig = require(config)
				
				if requiredConfig.NotReplicated and requiredConfig.Exclusive then
					assetFolder:AddTag("NotReplicated")

					-- clone the exclusive folder to ServerStorage before modifying the original
					local serverParent = getOrCreateServerParent(assetFolder)
					if serverParent then
						local serverCopy = assetFolder:Clone()
						serverCopy.Parent = serverParent
					end

					for _, moduleName in {"Config", "Behavior"} do
						if not assetFolder:FindFirstChild(moduleName) then continue end

						local newModule = game.ServerStorage.Assets.Instances.TemplateModule:Clone()
						newModule.Parent = assetFolder
						newModule.Name = moduleName
						local ogModule : ModuleScript = assetFolder[moduleName]
						local newRequired = require(newModule)
						local ogRequired = require(ogModule)

						for i, v in table.clone(ogRequired) do
							newRequired[i] = v
							if moduleName == "Config" then
								newRequired.Rig = requiredConfig.Rig
							end
						end

						for _, v in ogModule:GetChildren() do
							v.Parent = newModule
						end

						ogModule:Destroy()
					end
					
					assetFolder.Parent = storedFolder.Decoys
				end
			end
		end
	end
end

return module]========]},
}},
}
for _,plan in shared do
 local target=assert(find(plan.path),"Missing module: "..plan.path)
 local current=target.Source;local replacement
 for _,option in plan.options do if fingerprint(current)==option.expected then replacement=option.after;break end end
 assert(replacement,"Current Source differs: "..plan.path..". Nothing changed; send this module for a matching repair.")
 table.insert(changes,{target=target,before=current,after=replacement})
end
local backup=Instance.new("Folder");local base="BuildermanPlacement_Backup_"..os.date("!%Y%m%d_%H%M%S");backup.Name=base
local index=0;while game.ServerStorage:FindFirstChild(backup.Name)do index+=1;backup.Name=base.."_"..index end
ref(backup,"Root",root);backup:SetAttribute("OldVersion",root:GetAttribute("BuildermanPortVersion"))
for i,change in changes do
 local record=Instance.new("Folder");record.Name="Source_"..i;ref(record,"Target",change.target)
 local before=Instance.new("StringValue");before.Name="Before";before.Value=change.before;before.Parent=record
 record:SetAttribute("Installed",fingerprint(change.after));record.Parent=backup
end
backup.Parent=game.ServerStorage
local ok,err=pcall(function()
 for _,change in changes do change.target.Source=change.after end
 root:SetAttribute("BuildermanPortVersion","1.2.0")
end)
if not ok then
 for _,change in changes do if change.target.Source~=change.before then change.target.Source=change.before end end
 backup:Destroy();error("[Builderman placement] Rolled back: "..tostring(err))
end
print("[Builderman placement] Installed resting-height placement and immediate input freeze with validated click-time facing. Save and restart Play. Backup: "..backup.Name)
