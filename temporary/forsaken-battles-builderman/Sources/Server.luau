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
