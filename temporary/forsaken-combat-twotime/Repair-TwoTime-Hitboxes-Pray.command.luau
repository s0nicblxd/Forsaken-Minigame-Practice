-- Two Time -> FCTtest2, kit media excluded. Stop Play before running in Studio's Command Bar.
assert(game:GetService("RunService"):IsStudio() and not game:GetService("RunService"):IsRunning(),"Stop the playtest first.")
local function fingerprint(source)
 local a,b=5381,0
 for i=1,#source do local byte=string.byte(source,i);a=(a*33+byte)%4294967296;b=(b*65599+byte)%4294967296 end
 return string.format("%d:%08x:%08x",#source,a,b)
end
local function find(path)
 local current=game
 for name in path:gmatch("[^/]+") do current=current and current:FindFirstChild(name) end
 return current
end
-- Require the already-tested FCT Guest/Hitboxes compatibility fix. Do not replace shared combat code.
local hitboxes=assert(find("ReplicatedStorage/Modules/Hitboxes"),"Missing FCT Hitboxes module.")
assert(hitboxes.Source:find("DamageOverride",1,true) and hitboxes.Source:find('hitResponse == "Ignored"',1,true),"Apply the FCT Guest compatibility fix before this port. Nothing changed.")
local plans={
{path=[====[
ReplicatedStorage/Assets/Survivors/TwoTime/Behavior/Server]====],before="20810:c613c66e:f0dfb625",after="21058:1dfac0b0:ba740893",source=[====[
-- FCT APIs and FCT visual templates; newest UPD balance. No animation or sound calls.
local RunService=game:GetService("RunService")
local Players=game:GetService("Players")
local Debris=game:GetService("Debris")
local TweenService=game:GetService("TweenService")
local Modules=game.ReplicatedStorage.Modules
local Util=require(Modules.Util)
local Statuses=require(Modules.Statuses)
local Hitboxes=require(Modules.Hitboxes)
local Network=require(Modules.Network)
local Rules=require(script.Parent.Rules)
local Visuals=require(script.Parent.Visuals)
local Server={}
local function alive(a)
 return not a.TTDestroyed and a.Rig and a.Rig.Parent and a.Rig.PrimaryPart and a.Rig:FindFirstChildOfClass("Humanoid") and a.Rig.Humanoid.Health>0
end
local function send(a,kind,data)
 if a.Player and a.Player.Parent then Network:FireClientConnection(a.Player,"TwoTimePortState","REMOTE_EVENT",kind,data) end
end
local function lock(a,key,on)
 a.AbilityDisablers=a.AbilityDisablers or {}
 a.AbilityDisablers["TwoTimePort"..key]=on or nil
end
local function blocked(a)
 local rig=a.Rig
 return rig:GetAttribute("Stunned") or rig:GetAttribute("Helpless") or rig:GetAttribute("Ragdolling") or rig:GetAttribute("AbilitiesDisabled") or rig.PrimaryPart.Anchored
end
local function removeSpeed(a,key)
 local folder=a.Rig and a.Rig:FindFirstChild("SpeedMultipliers")
 local value=folder and folder:FindFirstChild(key)
 if value then value:Destroy() end
end
local function knife(a,on)
 for part,transparency in pairs(a.DaggerParts or {}) do
  if part.Parent then part.Transparency=on and transparency or 1 end
 end
 -- Invisibility's own watcher can now affect the visible blade along with the rest of the rig.
end
local function stopPrayVFX(a)
 local visuals=a.TTPrayVFX;a.TTPrayVFX=nil
 for _,object in visuals or {} do
  for _,item in object:GetDescendants() do
   if item:IsA("ParticleEmitter") then
    item.Enabled=false
    if item.Name=="Spawn" and (object.Name=="Floor" or object.Name=="StartFloor") then item:Clear() end
   elseif item:IsA("Light") then TweenService:Create(item,TweenInfo.new(.2),{Brightness=0}):Play() end
  end
  if object:IsA("Beam") then TweenService:Create(object,TweenInfo.new(.2),{Width1=0}):Play() end
  Debris:AddItem(object,4)
 end
end
local function startPrayVFX(a)
 stopPrayVFX(a)
 local folder=Visuals.Build("Pray")
 a.TTPrayVFX=folder:GetChildren()
 for _,object in a.TTPrayVFX do object.Parent=a.Rig.PrimaryPart end
 folder:Destroy()
 for _,object in a.TTPrayVFX do
  for _,item in object:GetDescendants() do
   if item:IsA("ParticleEmitter") then
    -- Keep the startup Spawn glyph alive for the entire hold, alongside the looping lights.
    if item.Name=="Spawn" and object.Name=="StartFloor" then item.Enabled=true;item.Rate=math.max(item.Rate,2) end
    if item:GetAttribute("EmitCount") then item:Emit(item:GetAttribute("EmitCount")) end
   end
  end
 end
end
local function nearest(a)
 local best,distance=nil,math.huge
 local players=workspace:FindFirstChild("Players")
 local killers=players and players:FindFirstChild("Killers")
 if killers then for _,rig in killers:GetChildren() do
  local humanoid=rig:FindFirstChildOfClass("Humanoid")
  if rig~=a.Rig and rig.PrimaryPart and humanoid and humanoid.Health>0 and not rig:GetAttribute("TwoTimeIgnoreTarget") then
   local range=(rig.PrimaryPart.Position-a.Rig.PrimaryPart.Position).Magnitude
   if range<distance then best,distance=rig,range end
  end
 end end
 return best,distance
end
local function updateBlood(a,value)
 a.Blood=math.clamp(value,0,a.Config.BloodRequiredForRespawn)
 a.Rig:SetAttribute("TwoTimeOblation",a.Blood)
 send(a,"Blood",a.Blood)
 local floor=a.RespawnLocation and a.RespawnLocation:FindFirstChild("EnabledFloor")
 if floor then
  local light=floor:FindFirstChild("Transparent")
  if light and light:IsA("Light") then light.Brightness=2+8*a.Blood/a.Config.BloodRequiredForRespawn end
  local shader=floor:FindFirstChild("FullShader")
  if shader and shader:IsA("ParticleEmitter") then shader.Enabled=a.Blood>=a.Config.BloodRequiredForRespawn end
 end
end
function Server.StopPray(a,interrupted)
 if not a.TTPraying then return end
 a.TTPraying=nil
 stopPrayVFX(a)
 a.Rig:SetAttribute("TwoTimePraying",nil)
 lock(a,"Pray",false);removeSpeed(a,"TwoTimePray")
 if a.TTJump then a.Rig.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping,a.TTJump.Enabled);a.TTJump=nil end
 if interrupted then a:SetCooldownOf("Pray",a.Config.PrayInterruptCooldown);send(a,"Warning","Your prayer was interrupted.") end
 send(a,"Pray",false)
end
function Server.StopCrouch(a,manual)
 if not a.TTCrouchStart then return end
 local elapsed=os.clock()-a.TTCrouchStart
 a.TTCrouchStart=nil;a.TTRamp=0
 a.Rig:SetAttribute("Crouching",nil)
 a.Rig:SetAttribute("FootstepsMuted",a.TTPreviousFootstepsMuted)
 a.TTPreviousFootstepsMuted=nil
 a.Rig:SetAttribute("TwoTimeCrouchBonus",nil)
 a:SetCooldownOf("Crouch",Rules.CrouchCooldown(a.Config,elapsed))
 Statuses:RemoveStatus(a.Player,"Invisibility");Statuses:RemoveStatus(a.Player,"Undetectable")
 removeSpeed(a,"TwoTimeCrouching");removeSpeed(a,"CrouchBonusTT")
 knife(a,false)
 if manual and alive(a) then
  local _,distance=nearest(a)
  if distance<=30 then Statuses:ApplyStatus(a.Player,"Speed",{Level=2,Duration=a.Config.CrouchSpeedCloseTime}) end
 end
end
local function cancelAttack(a)
 a.TTAttackToken=(a.TTAttackToken or 0)+1
 if a.TTHitbox then a.TTHitbox:Cancel();a.TTHitbox=nil end
 if a.TTVelocity then a.TTVelocity:Destroy();a.TTVelocity=nil end
 lock(a,"Dagger",false);removeSpeed(a,"TwoTimeStab");knife(a,false)
end
function Server.Dagger(a)
 if not alive(a) or blocked(a) or a.TTPraying or a.TTRitualCasting or a.TTAttacking then return {Cancelled=true} end
 a.TTAttacking=true
 local crouched=a.TTCrouchStart~=nil
 local charge=crouched and os.clock()-a.TTCrouchStart or 0
 Server.StopCrouch(a,false)
 cancelAttack(a)
 local token=a.TTAttackToken
 lock(a,"Dagger",true);knife(a,true)
 Util:CreateSpeedMultiplier(a.Rig,.1,"TwoTimeStab")
 local hit=false
 local function current() return alive(a) and a.TTAttackToken==token and not blocked(a) end
 task.delay(a.Config.DaggerWindup,function()
  if not current() then cancelAttack(a);a.TTAttacking=nil;return end
  local duration=crouched and a.Config.DaggerCrouchHitTime or a.Config.DaggerHitTime
  local velocity=Util:ApplyVelocity(a.Rig.PrimaryPart,crouched and a.Config.DaggerLungeForce or a.Config.DaggerUncrouchedLungeForce)
  a.TTVelocity=velocity
  TweenService:Create(velocity,TweenInfo.new(crouched and a.Config.DaggerCrouchMoverEndlag or .2),{LineVelocity=velocity.LineVelocity/3}):Play()
  Debris:AddItem(velocity,crouched and a.Config.DaggerCrouchMoverEndlag or .2)
  a.TTHitbox=Hitboxes:CreateHitbox(a.Player,{
   Size=a.Config.DaggerHitboxSize,CFrameOffset=CFrame.new(0,0,-a.Config.DaggerHitboxOffset),
   Damage=0,Time=duration,Knockback=0,HitMultiple=false,FriendlyFire=true,
   Connections={Hit=function(victim)
    if hit or not current() then return end
    local root=victim.PrimaryPart;local humanoid=victim:FindFirstChildOfClass("Humanoid")
    if not root or not humanoid or humanoid.Health<=0 or victim:GetAttribute("Invincible") then return end
    hit=true
    -- Raw root transforms, never actor:GetPivot() prediction/extrapolation.
    local ours=a.Rig.PrimaryPart
    local back=Rules.Backstab(ours.Position,ours.CFrame.LookVector,root.Position,root.CFrame.LookVector,a.Config)
    local immune=victim:GetAttribute("StunnedDisabled") or victim:GetAttribute("Stunned") or Statuses:PlayerHasStatus(victim,"Stunned")
    local targetActor=require(Modules.Actors).CurrentActors[Players:GetPlayerFromCharacter(victim)] or require(Modules.Actors).CurrentActors[victim]
    local exclusions=targetActor and targetActor.Config and targetActor.Config.StatusData and targetActor.Config.StatusData.ExcludeApplying
    immune=immune or exclusions and table.find(exclusions,"Stunned")
    Util:ApplyDamage(victim,back and a.Config.DaggerBackstabDamage or a.Config.DaggerDamage,nil,a.Rig)
    if not immune then
     if back then Statuses:ApplyStatus(victim,"Stunned",{Duration=Rules.Stun(a.Config,crouched,charge)})
     else
      Statuses:ApplyStatus(victim,"Slowness",{Level=2,Duration=a.Config.DaggerStatusTime})
      Statuses:ApplyStatus(victim,"Helpless",{Level=1,Duration=a.Config.DaggerStatusTime,TimeStackable=false})
     end
     local team=tostring(victim.Parent)
     local summon=victim:HasTag("SurvivorConstruct") or victim:HasTag("KillerConstruct") or victim:GetAttribute("IsMinion") or victim:GetAttribute("Summon")
     if not summon and (team=="Killers" or team=="Survivors") and a.LivesUsed==1 then updateBlood(a,a.Blood+Rules.Oblation(a.Config,back,crouched)) end
    end
    if a.TTVelocity then a.TTVelocity:Destroy();a.TTVelocity=nil end
   end}
  })
  task.delay(duration,function()
   if a.TTAttackToken~=token then return end
   a.TTHitbox=nil
   if crouched and not hit and alive(a) then
    local _,distance=nearest(a)
    local penalty=Rules.MissDuration(a.Config,distance)
    if penalty>0 then Statuses:ApplyStatus(a.Player,"Slowness",{Level=a.Config.DaggerMissSlownessLevel,Duration=penalty}) end
   end
  end)
 end)
 Statuses:ApplyStatus(a.Player,"Resistance",{Level=a.Config.DaggerResLevel,Duration=a.Config.DaggerResDuration})
 local total=a.Config.DaggerWindup+(crouched and a.Config.DaggerCrouchHitTime+a.Config.DaggerCrouchEndlag+a.Config.DaggerCrouchEndlagTweenTime or  .7)
 task.delay(total,function()
  if a.TTAttackToken==token then cancelAttack(a);a.TTAttacking=nil end
 end)
 return {Crouched=crouched,Duration=total}
end
function Server.Crouch(a)
 if not alive(a) or blocked(a) or a.TTPraying or a.TTRitualCasting or a.TTAttacking then return {Cancelled=true} end
 if a.TTCrouchStart then Server.StopCrouch(a,true);return end
 a.TTCrouchStart=os.clock();a.TTRamp=0
 a.TTPreviousFootstepsMuted=a.Rig:GetAttribute("FootstepsMuted")
 a.Rig:SetAttribute("FootstepsMuted",true)
 a.Rig:SetAttribute("Crouching",true)
 a:SetCooldownOf("Crouch",1)
 knife(a,true)
 Statuses:ApplyStatus(a.Player,"Invisibility",{Level=a.Config.CrouchInvisibilityLevel,Duration=a.Config.CrouchDuration})
 Statuses:ApplyStatus(a.Player,"Undetectable",{Level=a.Config.CrouchUndetectableLevel,Duration=a.Config.CrouchDuration})
 return {Started=true}
end
function Server.Pray(a)
 if not alive(a) or blocked(a) or a.TTAttacking or a.TTRitualCasting then return {Cancelled=true} end
 if a.TTPraying then Server.StopPray(a,false);return end
 local ritual=a.RespawnLocation
 if not ritual or not ritual.Parent or a.LivesUsed~=1 then send(a,"Warning","You must place your Ritual before praying.");return {Cancelled=true} end
 if (ritual.Position-a.Rig.PrimaryPart.Position).Magnitude>a.Config.PrayRange then return {Locate=ritual.Position,Warning="Return to your Ritual to pray."} end
 if a.Blood<=0 then send(a,"Warning","You need Oblation to pray.");return {Cancelled=true} end
 if a.Rig.Humanoid.Health>=a.Rig.Humanoid.MaxHealth then send(a,"Warning","You are already at full health.");return {Cancelled=true} end
 Server.StopCrouch(a,false)
 a.TTPraying=true;a.TTPrayStart=os.clock();a.TTPrayLease=os.clock()
 a.TTPrayDamage=0
 a.Rig:SetAttribute("TwoTimePraying",true)
 lock(a,"Pray",true)
 Util:CreateSpeedMultiplier(a.Rig,0,"TwoTimePray")
 a.TTJump={Enabled=a.Rig.Humanoid:GetStateEnabled(Enum.HumanoidStateType.Jumping)}
 a.Rig.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping,false)
 startPrayVFX(a)
 return {Started=true}
end
local function effect(a,name,parent)
 local template=a.Config.VFX and a.Config.VFX:FindFirstChild(name)
 if not template then return end
 local clone=template:Clone();clone.Parent=parent
 for _,object in clone:GetDescendants() do
  if object:IsA("Sound") then object:Destroy()
  elseif object:IsA("ParticleEmitter") then object:Emit(object:GetAttribute("EmitCount") or 8) end
 end
 Debris:AddItem(clone,3)
end
function Server.Ritual(a)
 local function invalid()
  a:IncrementCharges("Ritual",1,1)
  return {Cancelled=true}
 end
 if not alive(a) or blocked(a) or a.TTAttacking or a.TTPraying or a.TTRitualCasting or a.RespawnLocation or a.LivesUsed~=1 then return invalid() end
 local params=RaycastParams.new();params.FilterType=Enum.RaycastFilterType.Exclude
 local players=workspace:FindFirstChild("Players")
 params.FilterDescendantsInstances=players and {players} or {a.Rig}
 local root=a.Rig.PrimaryPart
 local forward=workspace:Raycast(root.Position,root.CFrame.LookVector*2.648,params)
 local distance=forward and math.max(0,forward.Distance-1) or 2.648
 local ground=workspace:Raycast(root.Position+root.CFrame.LookVector*distance,Vector3.new(0,-12,0),params)
 if not ground or ground.Normal.Y<.65 then return invalid() end
 local ingame=workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Ingame") or workspace
 for _,part in ingame:GetDescendants() do
  if part:IsA("BasePart") and (part.Name:find("RespawnLocation") or part.Name:find("Builderman")) and (part.Position-ground.Position).Magnitude<a.Config.RespawnLocationDistance then return invalid() end
 end
 a.TTRitualCasting=true;a.TTRitualToken=(a.TTRitualToken or 0)+1
 local token=a.TTRitualToken
 lock(a,"Ritual",true);Server.StopCrouch(a,false);knife(a,true)
 Util:CreateSpeedMultiplier(a.Rig,0,"TwoTimeRitual")
 local startPosition=root.Position
 task.delay(1.5,function()
  if not alive(a) or not a.TTRitualCasting or a.TTRitualToken~=token or blocked(a) or (root.Position-startPosition).Magnitude>4 then return end
  local spawn=a.Config.RespawnLocation:Clone()
  spawn.Name=a.Player.Name.."RespawnLocation";spawn.Anchored=true;spawn.CanCollide=false
  spawn.CFrame=CFrame.lookAt(ground.Position-Vector3.new(0,.1,0),ground.Position-Vector3.new(0,.1,0)+root.CFrame.LookVector*Vector3.new(1,0,1))
  for _,item in spawn:GetDescendants() do if item:IsA("Sound") then item:Destroy() end end
  spawn.Parent=ingame;a.RespawnLocation=spawn
  effect(a,"Ritual",spawn)
  local floor=a.Config.VFX and a.Config.VFX:FindFirstChild("EnabledFloor")
  if floor then local clone=floor:Clone();clone.Parent=spawn;for _,v in clone:GetDescendants() do if v:IsA("Sound") then v:Destroy() end end end
  updateBlood(a,a.Blood)
 end)
 task.delay(3.5,function()
  if a.TTDestroyed or a.TTRitualToken~=token then return end
  a.TTRitualCasting=nil;lock(a,"Ritual",false);removeSpeed(a,"TwoTimeRitual");knife(a,false)
  if not a.RespawnLocation then a:IncrementCharges("Ritual",1,1);a:SetCooldownOf("Ritual",0) end
 end)
 return {Started=true,Duration=3.5}
end
function Server.Interrupt(a)
 Server.StopCrouch(a,false);Server.StopPray(a,true)
 if a.TTAttacking then cancelAttack(a);a.TTAttacking=nil end
 if a.TTRitualCasting then
  a.TTRitualToken=(a.TTRitualToken or 0)+1
  a.TTRitualCasting=nil;lock(a,"Ritual",false);removeSpeed(a,"TwoTimeRitual");knife(a,false)
  if not a.RespawnLocation then a:IncrementCharges("Ritual",1,1);a:SetCooldownOf("Ritual",0) end
 end
end
function Server.OnHit(a,hitbox,damage,lms)
 if not alive(a) then return end
 damage=math.max(0,tonumber(damage) or 0)
 if a.TTPraying then
  a.TTPrayDamage=(a.TTPrayDamage or 0)+damage
  if a.TTPrayDamage>=a.Config.PrayInterruptDamage then Server.StopPray(a,true) end
 end
 if damage>0 then a.TTRamp=0;a.TTRampResetUntil=os.clock()+.15;a.Rig:SetAttribute("TwoTimeCrouchBonus",1) end
 if a.LivesUsed~=1 or a.TTReviving then return end
 if not lms and (damage<a.Rig.Humanoid.Health or a.Blood<a.Config.BloodRequiredForRespawn or not a.RespawnLocation or not a.RespawnLocation.Parent) then return end
 a.TTReviving=true
 if hitbox then hitbox.TimePast=9999 end -- FCT Util/Hitboxes cancel the lethal hit before applying it.
 cancelAttack(a);a.TTAttacking=nil;Server.StopPray(a,false);Server.StopCrouch(a,false)
 a.TTRitualCasting=nil;a.TTRitualToken=(a.TTRitualToken or 0)+1
 lock(a,"Ritual",false);removeSpeed(a,"TwoTimeRitual")
 local blood=a.Blood
 a.LivesUsed=2;a.Rig:SetAttribute("IsSecondLife",true)
 Statuses:RemoveStatuses(a.Player,true)
 local h=a.Rig.Humanoid
 if lms then
  local maxHealth,healing=Rules.LMS(a.Config,blood)
  h.MaxHealth=maxHealth;h.Health=math.min(maxHealth,h.Health+healing)
 else h.MaxHealth=a.Config.Health/a.Config.NextLifeHealthDivisor;h.Health=h.MaxHealth end
 Util:GiveInvincible(a.Rig,"TTRevive",a.Config.InvincibilityDuration)
 -- AddRig uses FCT's already-owned appearance templates and public expression decals.
 a.Behavior:AddRig(a,2)
 knife(a,false)
 local ritual=a.RespawnLocation
 if not lms and ritual and ritual.Parent then
  local height=(Util:GetDistanceFromGround(a.Rig) or 3)
  a:PivotTo(ritual.CFrame+Vector3.new(0,height,0))
  effect(a,"Respawned",ritual)
 else effect(a,"Respawned",a.Rig.PrimaryPart) end
 if ritual then Debris:AddItem(ritual,2);a.RespawnLocation=nil end
 local ritualAbility=a.Behavior.Abilities.Ritual
 if ritualAbility then a:IncrementCharges("Ritual",0,0) end
 updateBlood(a,0);send(a,"Revive",true)
 local _,_,speedTime=Rules.LMS(a.Config,blood)
 if not lms or speedTime>0 then Statuses:ApplyStatus(a.Player,"Speed",{Level=2,Duration=lms and speedTime or 6,Instant=true}) end
 if not lms then Statuses:ApplyStatus(a.Player,"Vulnerable",{Level=5,Duration=12,BypassInvincibility=true}) end
 -- Explicit opt-in for a round-based host; continuous combat has no timer or automatic LMS.
 if a.Config.TwoTimeRoundHooks then
  a.TimeAddMultiplier=25/40
  local round=game.ServerScriptService:FindFirstChild("RoundManager",true)
  if round and not lms then require(round):AddTime(nil,15/40) end
 end
 a.TTReviving=nil
 return "Ignored"
end
function Server.Created(a)
 a.TTConnections={};a.LivesUsed=1;a.Blood=0;a.TTAttackToken=0
 a.Behavior:AddRig(a,1)
 local dagger=a.Config.DaggerTemplate:Clone()
 for _,item in dagger:GetDescendants() do if item:IsA("Sound") then item:Destroy() end end
 local motor=dagger:FindFirstChildOfClass("Motor6D")
 if motor then motor.Part0=a.Rig.PrimaryPart;dagger.Parent=a.Rig else dagger:Destroy() end
 a.DaggerParts={}
 if dagger.Parent then for _,part in dagger:GetDescendants() do
  if part:IsA("BasePart") or part:IsA("Decal") then a.DaggerParts[part]=part.Transparency;part.Transparency=1 end
  if part:IsA("BasePart") then part.CanCollide=false;part.CanTouch=false;part.Massless=true end
 end end
 local remote="TwoTimePortHold_"..a.Player.UserId
 Network:SetConnection(remote,"REMOTE_EVENT",function(player,holding)
  if player~=a.Player or not a.TTPraying then return end
  if holding==true then a.TTPrayLease=os.clock() else Server.StopPray(a,false) end
 end)
 a.TTHoldRemote=remote
 table.insert(a.TTConnections,a.Rig.Humanoid.HealthChanged:Connect(function(health)
  if a.TTLastHP and health<a.TTLastHP then a.TTRamp=0;a.TTRampResetUntil=os.clock()+.15 end
  a.TTLastHP=health
 end))
 table.insert(a.TTConnections,RunService.Heartbeat:Connect(function(dt)
  if not alive(a) then Server.Destroyed(a);return end
  if blocked(a) then
   Server.Interrupt(a)
  end
  if a.TTCrouchStart then
   local elapsed=os.clock()-a.TTCrouchStart
   if elapsed>=a.Config.CrouchDuration then Server.StopCrouch(a,false)
   else
    local target,distance=nearest(a);local h=a.Rig.Humanoid;local root=a.Rig.PrimaryPart
    local direction=target and target.PrimaryPart.Position-root.Position
    local motion=root.AssemblyLinearVelocity*Vector3.new(1,0,1)
    local running=motion.Magnitude>a.Config.CrouchSpeed+1
    if running and direction and direction.Magnitude>.001 and distance<=a.Config.CrouchSpeedBoostDistance and motion.Unit:Dot(direction.Unit)>a.Config.CrouchSpeedBoostDot and os.clock()>=(a.TTRampResetUntil or 0) then a.TTRamp=math.min(a.Config.CrouchSpeedBoostTime,a.TTRamp+dt) else a.TTRamp=0 end
    a.Rig:SetAttribute("TwoTimeCrouchBonus",1+(a.Config.CrouchSpeedBoostMax-1)*a.TTRamp/a.Config.CrouchSpeedBoostTime)
   end
  end
  if a.TTPraying then
   local ritual=a.RespawnLocation
   if os.clock()-a.TTPrayLease>1.25 or os.clock()-a.TTPrayStart>30 or not ritual or not ritual.Parent or (ritual.Position-a.Rig.PrimaryPart.Position).Magnitude>a.Config.PrayRange then Server.StopPray(a,false)
   else
    local h=a.Rig.Humanoid
    local spent,healed=Rules.Pray(a.Config,a.Blood,h.MaxHealth-h.Health,math.min(dt,.25))
    if spent>0 then updateBlood(a,a.Blood-spent);h.Health=math.min(h.MaxHealth,h.Health+healed) end
    if a.Blood<=.00001 or h.Health>=h.MaxHealth then Server.StopPray(a,false) end
   end
  end
 end))
 if a.Config.TwoTimeRoundHooks then
  local survivors=workspace.Players.Survivors
  table.insert(a.TTConnections,survivors.ChildRemoved:Connect(function()
   if alive(a) and #survivors:GetChildren()==1 then Server.OnHit(a,nil,0,true) end
  end))
 end
 updateBlood(a,0)
end
function Server.Destroyed(a)
 if a.TTDestroyed then return end
 Server.StopPray(a,false);Server.StopCrouch(a,false);cancelAttack(a)
 a.TTDestroyed=true
 lock(a,"Ritual",false);removeSpeed(a,"TwoTimeRitual")
 for _,connection in a.TTConnections or {} do connection:Disconnect() end
 if a.TTHoldRemote then Network:RemoveConnection(a.TTHoldRemote,"REMOTE_EVENT") end
 if a.RespawnLocation then a.RespawnLocation:Destroy();a.RespawnLocation=nil end
end
return Server
]====]},
{path=[====[
ReplicatedStorage/Assets/Survivors/TwoTime/Config]====],before="14227:c58653c9:e7f29712",after="14230:47aec50a:a06c72a7",source=[====[

local t1 = {
	DisplayName = "Two Time",
	Quote = "\"Shadows die twice.\"",
	Class = "Sentinel",
	RenderImage = "rbxassetid://107234615040462",
	Price = 500,
	Exclusive = false,
	LMSEffect = {
		ProcessingModule = "BasicLMS",
		SoundId = "heartbeat",
		ImageId = function(s1: string) -- line: 14
			if s1 == "Azure" then
				return "rbxassetid://114627570317346"
			end

			return "rbxassetid://103025892289003"
		end,
		PrimaryColor = function(s2: string) -- line: 20
			if s2 == "Azure" then
				return Color3.fromRGB(115, 0, 255)
			end

			return Color3.fromRGB(255, 0, 0)
		end,
		SecondaryColor = Color3.fromRGB(0, 0, 0)
	},
	Health = 80,
	Speed = 12,
	DaggerCooldown = 30,
	DaggerWindup = 0.3,
	DaggerDamage = 10,
	DaggerBackstabDamage = 20,
	DaggerLungeForce = 110,
	DaggerUncrouchedLungeForce = 50,
	DaggerBackstabThreshold = 70,
	DaggerLookDirectionAngle = 70,
	DaggerStatusTime = 1,
	DaggerBackstabStatusTime = 3.5,
	DaggerCrouchMinStunTime = 2,
	DaggerCrouchStunChargeTime = 1,
	DaggerLifestealFromFront = 0,
	DaggerLifestealFromBack = 0,
	DaggerCrouchEndlag = 0.225,
	DaggerCrouchEndlagTweenTime = 0.15,
	DaggerCrouchMoverEndlag = 0.4,
	DaggerCrouchSprintLockTime = 1,
	DaggerUncrouchedSprintLockTime = 1,
	DaggerMissSlownessDistanceInterval = 10,
	DaggerMissSlownessDurationMultiplier = 1,
	DaggerMissSlownessMaxDuration = 8,
	DaggerMissSlownessLevel = 2,
	PrayRange = 10,
	PrayHoldTime = NumberRange.new(0.15, 30),
	PrayHighlightDuration = 4,
	PrayHighlightImage = "rbxassetid://100508591140926",
	PrayHealthPerFullOblation = 66.66666666666667,
	PrayFullConversionTime = 10,
	PrayInterruptDamage = 5,
	PrayInterruptCooldown = 6,
	DaggerResLevel = 1,
	DaggerResDuration = 0.7,
	BloodReqIncreasePerTwoTime = 1,
	CrouchCooldown = 30,
	CrouchMinCooldown = 15,
	CrouchDuration = 15,
	CrouchSpeed = 10,
	CrouchRunSpeed = 23,
	CrouchInvisibilityLevel = 3,
	CrouchUndetectableLevel = 1,
	CrouchSpeedCloseTime = 1,
	CrouchStabAmplifyTime = 4,
	CrouchRevealTime = 2,
	CrouchSpeedBoostMax = 1.5,
	CrouchSpeedBoostTime = 4,
	CrouchSpeedBoostDot = 0.2,
	CrouchSpeedBoostDistance = 105,
	CrouchTeammateRevealDistance = 100,
	CrouchTeammateRevealFadeTime = 1.25,
	CrouchOblationMultiplier = 1.25,
	CrouchDistances = {
		CLOSE = {
			0,
			30
		},
		DEBUFF_SLOWNESS = {
			75,
			-1
		},
		DEBUFF_HIGHLIGHT = {
			125,
			-1
		}
	},
	CrouchSlownessDebuffMax = 150,
	Lives = 2,
	BloodRequiredForRespawn = 8,
	BloodFromFront = 1.6,
	BloodFromBack = 3.2,
	RespawnLocationDistance = 10,
	NextLifeHealthDivisor = 1.6,
	InvincibilityDuration = 2,
	LastSurvivorMaxHealth = 110,
	LastSurvivorHealthBonus = 50,
	RespawnLocation = script.Spawn,
 HealthBar = script.Sidebar,
 AudioReplication = script.AudioReplication,
 VFX = script.TwoTimeVFX,
 LifeAppearances = {[1]=script.Life1,[2]=script.Life2},
 DaggerTemplate = script.GhostFire,
	Animations = {},
 Sounds = {},
	ExpressionsTable = {
		[1] = {
			Happy = "rbxassetid://82471736046966",
			Default = "rbxassetid://111259025475261",
			Hurt = "rbxassetid://124079311211417",
			Injured = "rbxassetid://82982231751339",
			Dead = "rbxassetid://74288576584860",
			Drinking = "rbxassetid://135845534213100"
		},
		[2] = {
			Happy = "rbxassetid://105016806376431",
			Default = "rbxassetid://80110682472998",
			Hurt = "rbxassetid://91658006415418",
			Injured = "rbxassetid://135831503096288",
			Dead = "rbxassetid://86722867217862",
			Drinking = "rbxassetid://116753879639619"
		}
	}
}

t1.Expressions = t1.ExpressionsTable[1]
t1.TextInteractions = {
	Requests = {
		ElliotPizza = {
			"Hey, hey. Pizza, pizza please.",
			"Pizza’s something I haven’t tried much, mind if I get a slice?",
			"I must ask for a pizza.",
			"Do you have pizza? I could use one!",
			"May I have a pizza slice?",
			"I really want a pizza! May I have one?"
		},
		BuildermanSentry = {
			"Your turrets may be of use over here.",
			"A sentry here should be put to use. Place it here.",
			"Place your sentry over here. It will help against the foes.",
			"Put down a sentry here.",
			"Your sentry will be of use over here."
		},
		BuildermanDispenser = {
			"I’m in need of a dispenser in my position.",
			"I require a dispenser to be placed here.",
			"Dispenser here, please.",
			"Put down one of your dispensers here.",
			"Your dispenser is needed here."
		},
		DusekkarProtection = {
			"Divine pumpkin, I humbly request your divine ability.",
			"Divine pumpkin, I implore you to cast your ability onto me.",
			"Divine pumpkin, I ask of thee to be blessed.",
			"Divine pumpkin, blessed be thy heart should you cast a spell unto me.",
			"Divine pumpkin, I ask for thy divine intervention."
		},
		HemmorhageAsk = {
			"By the Spawn's grace... I ... I must ask for your aid...",
			"My wounds.. are severe, I fear. Please, aid me, and the Spawn will smile at thy.",
			"I beg, I plead.. I ask for your aid as my body drains with every second...",
			"May you be blessed by the Spawn should you lend me your aid..",
			"Lend me your aid, and the Spawn shall guide you forward..."
		},
		HelperPulse = {
			"Your mechanisms are of most utmost importance right now, no time to waste..",
			"Keep a steady pace, machine... You mustn't waste a minute in tending to the group.",
			"Let your energy shine in those who need it most...",
			"Perhaps you may use your energy on the ones who may need it?",
			"We are in need of your energy, mechanism, and we must get it, fast.."
		},
		HelperInspire = {
			"Make haste, for our group seem to have grown exhausted..",
			"Let your mechanisms beam on the group, and may their beings feel ever so blessed by the Spawn while you do so.",
			"Shall we huddle closer together so your energy is conserved when you activate it?",
			"You've a keen eye for the others, do you not? You must see that they have grown tired.. You simply must help.",
			"We need your assistance on the matter, do you still have the energy to do so?"
		}
	},
	Thanks = {
		Regular = {
			"Much appreciated.",
			"Very thankful for your service.",
			"May good fortune come your way for your generosity.",
			"The Spawn would be pleased with your acts of kindness.",
			"I thank you for your service.",
			"Oh give thanks to the Spawn, for he is good; for their steadfast love endures forever."
		},
		DusekkarProtection = {
			{
				"TwoTime: The Spawn would be pleased with your acts of kindness!",
				"Dusekkar: ...",
				"Dusekkar: Eugh..."
			},
			{
				"TwoTime: Oh give thanks to the Spawn, for he is good; for their steadfast love endures forever.",
				"Dusekkar: ...",
				"Dusekkar: Ugh..."
			}
		}
	}
}

local v2 = math.floor(t1.BloodFromFront / t1.BloodRequiredForRespawn * 100)
local v3 = math.floor(t1.BloodFromBack / t1.BloodRequiredForRespawn * 100)

t1.Information = {
	{
		Separator = "GENERAL INFO"
	},
	{
		Header = "TWO TIME",
		Text = "A fragile cultist that holds a terrible secret. Bearing nothing other than a sleek dagger and manic smile, they're able to earn a second life through risk and sacrifice.\n"
	},
	{
		Header = "STATS",
		Text = "Difficulty: ★★★★☆\n" .. `Health: { t1.Health or 100 }\n` .. `Regular Speed: { t1.Speed or 12 }\n` .. `Sprinting Speed: { t1.SprintSpeed or 26 }\n` .. `Max Stamina: { t1.MaxStamina or 100 }\n` .. `Stamina Loss per sec: { t1.StaminaLoss or 10 }\n` .. `Stamina Gain per sec: { t1.StaminaGain or 20 }\n`
	},
	{
		Separator = "PASSIVES"
	},
	{
		Header = "OBLATION",
		Quote = "\"You both shall set out on the grand step to rebirth.\" - ██████",
		Text = "<font color=\"#6c6e78\">Two Time</font> has a bar on the right side of the screen that, when filled, grants them a second life.\n" .. "The only way to fill this bar is by dealing damage to the Killer.\n\n" .. `Landing a stab to the front will fill { v2 }% of the bar.\n` .. `Landing a stab to the back will fill { v3 }% of the bar.\n` .. "Crouched Lunge Stabs increases the <b>OBLATION</b> gain by 25%.\n\n" .. "<font color=\"#6c6e78\">Two Time</font> will enter their second life upon taking lethal damage or being the last alive Survivor.\n" .. "In their second life, they only have 50 maximum health.\n" .. "Upon activation:\n\n" .. " * Stamina is restored by 40%\n" .. " * All status effects are removed\n" .. ` * <font color="#6c6e78">Two Time</font> is made invincible for { t1.InvincibilityDuration } seconds \n` .. " * <b>Speed II</b> is applied for 6 seconds\n" .. " * <b>Vulnerable V</b> is applied for 12 seconds\n"
	},
	{
		Separator = "ABILITIES"
	},
	{
		Header = "SACRIFICIAL DAGGER",
		Image = "rbxassetid://129077533212750",
		Quote = "\"Lookie, █████—they gave us this cool knife!\" - Two Time",
		Text = `Cooldown: { t1.DaggerCooldown }s\n` .. `After a { t1.DaggerWindup }s windup, <font color="#6c6e78">Two Time</font> stabs forward and gains <b>Resistance { t1.DaggerResLevel }</b> for { t1.DaggerResDuration } seconds.\n\n` .. `Landing a stab to the front will do { t1.DaggerDamage } damage and inflict <b>Slowness II</b> and <b>Helpless I</b> for { t1.DaggerStatusTime }s.\n\n` .. `Landing a stab to the back will instead do { t1.DaggerBackstabDamage } damage and stun the Killer for 2s.\n\n` .. `Using this ability while <b>crouched</b> quickly lunges you forward with a stab that has increased endlag but grants 25% more <b>OBLATION</b> progress. A crouched backstab's stun scales linearly from { t1.DaggerCrouchMinStunTime }s to { t1.DaggerBackstabStatusTime }s after { t1.DaggerCrouchStunChargeTime }s of crouching. The charge is measured when the stab begins.\n\n` .. `Missing a <b>crouched stab</b> will inflict <font color="#6c6e78">Two Time</font> with Slowness II for up to { t1.DaggerMissSlownessMaxDuration }s depending on their distance from the Killer after it ends.\n\n` .. "Landing a stab on a summon or a stun immune Killer does not grant any <b>OBLATION</b> progress.\n"
	},
	{
		Header = "CROUCH",
		Image = "rbxassetid://77707049887484",
		Quote = "\"Quiet, Two Time! They're not supposed to see us in here, hehe!\" - █████",
		Text = `Cooldown: { t1.CrouchCooldown }s\n` .. "<font color=\"#6c6e78\">Two Time</font> crouches down to silence their footsteps and become stealthier.\n\n" .. `<font color="#6c6e78">Two Time</font> remains <b>crouched</b> for at most { t1.CrouchDuration } seconds, but can uncrouch whenever they need to.\n` .. `Crouching applies <b>Undetectable I</b> and <b>Invisibility III</b> for at most { t1.CrouchDuration } seconds.\n\n` .. `While <b>crouched</b>, <font color="#6c6e78">Two Time</font>'s aura is revealed to teammates within { t1.CrouchTeammateRevealDistance } studs.\n\n` .. `While <b>crouched</b>, <font color="#6c6e78">Two Time</font> will gradually gain speed while running towards the Killer, with this speed boost capping out at { math.round((t1.CrouchSpeedBoostMax - 1) * 100) }% after { t1.CrouchSpeedBoostTime }s of running. This speed boost is immediately lost if <font color="#6c6e78">Two Time</font> exits Crouch, takes damage, or stops running towards the Killer.\n\n` .. "Uncrouching manually will forcibly remove these statuses and if <font color=\"#6c6e78\">Two Time</font> is within 30 studs of the Killer, will additionally grant <font color=\"#6c6e78\">Two Time</font> <b>Speed II</b> for 1s.\n"
	},
	{
		Header = "PRAY",
		Image = "rbxassetid://83582849559932",
		Quote = "\"May Spawn bless us today!\" - ██████",
		Text = "<font color=\"#6c6e78\">Two Time</font> will kneel near their <b>RITUAL</b> and begin praying while this ability is held.\n" .. "Letting go of the ability will stop <b>PRAYING</b>.\n\n" .. "While <b>PRAYING</b>, <font color=\"#6c6e78\">Two Time</font> will rapidly exchange <b>OBLATION</b> progress for HP.\n" .. `<font color="#6c6e78">Two Time</font> will gain 1 HP for every { 100 / t1.PrayHealthPerFullOblation }% <b>OBLATION</b> progress spent, restoring up to approximately { string.format("%.2f", t1.PrayHealthPerFullOblation) } HP from a full bar, without exceeding their maximum health.\n\n` .. "If <font color=\"#6c6e78\">Two Time</font> is not near their <b>RITUAL</b> when attempting to use this ability, the location of their <b>RITUAL</b> will be revealed to them for 4s.\n\n" .. "<font color=\"#6c6e78\">Two Time</font> is unable to use this ability if they do not have a <b>RITUAL</b>.\n"
	},
	{
		Header = "RITUAL",
		Image = "rbxassetid://95580729656404",
		Quote = "\"Spawn will be eternally pleased at our devotion!\" - ██████",
		Text = "<font color=\"#6c6e78\">Two Time</font> inscribes a respawn location on the ground.\n" .. "Dying with a full <b>OBLATION</b> bar will instantly teleport <font color=\"#6c6e78\">Two Time</font> to this point.\n\n" .. "<b>This ability can only be used once per round.</b>\n\n" .. "If <font color=\"#6c6e78\">Two Time</font> becomes the last survivor alive and has not already entered their second life, <b>RITUAL</b> will automatically trigger regardless of whether <b>OBLATION</b> was full or not.\n" .. `If this happens, <font color="#6c6e78">Two Time</font> will have their maximum health increased up to { t1.LastSurvivorMaxHealth }, be healed for up to { t1.LastSurvivorHealthBonus } HP, and will not be afflicted with <b>Vulnerable V</b>.` .. "Additionally, they will not teleport to their Ritual, and any buffs they receive will be decreased depending on how much <b>OBLATION</b> they are missing.\n"
	},
	{
		Separator = "CREDITS",
		Text = "Writer: 4Montaigne, sayso_1230Programmer: voxov_tired, ffPranksterDesigner: astertudeAnimator: sayso_1230Renderer: doc"
	}
}

-- Port choices where the export lacks authoritative server code:
-- Restore the first working port: original size, offset and shared hitbox prediction path.
-- Miss penalty grows outside the 30-stud close range; no penalty without a killer.
t1.DaggerHitboxSize=Vector3.new(4,6,5.5)
t1.DaggerHitboxOffset=7
t1.DaggerMissSlownessSafeDistance=30
t1.WarningTemplate=script:FindFirstChild("Warning")
t1.DaggerHitTime=.25
t1.DaggerCrouchHitTime=.415
t1.PraySensitiveButton=true
-- Custom, server-validated hold lease; omit PrayHoldTime to avoid the old generic charge protocol.
t1.PrayHoldTime=nil
t1.TwoTimeRoundHooks=false
t1.SprintSpeed=26
t1.MaxStamina=100
t1.StaminaLoss=10
t1.StaminaGain=20
t1.TwoTimePortVersion="1.0.2"
return t1
]====]},
{path=[====[
ServerStorage/Assets/Survivors/TwoTime/Behavior/Server]====],before="20810:c613c66e:f0dfb625",after="21058:1dfac0b0:ba740893",source=[====[
-- FCT APIs and FCT visual templates; newest UPD balance. No animation or sound calls.
local RunService=game:GetService("RunService")
local Players=game:GetService("Players")
local Debris=game:GetService("Debris")
local TweenService=game:GetService("TweenService")
local Modules=game.ReplicatedStorage.Modules
local Util=require(Modules.Util)
local Statuses=require(Modules.Statuses)
local Hitboxes=require(Modules.Hitboxes)
local Network=require(Modules.Network)
local Rules=require(script.Parent.Rules)
local Visuals=require(script.Parent.Visuals)
local Server={}
local function alive(a)
 return not a.TTDestroyed and a.Rig and a.Rig.Parent and a.Rig.PrimaryPart and a.Rig:FindFirstChildOfClass("Humanoid") and a.Rig.Humanoid.Health>0
end
local function send(a,kind,data)
 if a.Player and a.Player.Parent then Network:FireClientConnection(a.Player,"TwoTimePortState","REMOTE_EVENT",kind,data) end
end
local function lock(a,key,on)
 a.AbilityDisablers=a.AbilityDisablers or {}
 a.AbilityDisablers["TwoTimePort"..key]=on or nil
end
local function blocked(a)
 local rig=a.Rig
 return rig:GetAttribute("Stunned") or rig:GetAttribute("Helpless") or rig:GetAttribute("Ragdolling") or rig:GetAttribute("AbilitiesDisabled") or rig.PrimaryPart.Anchored
end
local function removeSpeed(a,key)
 local folder=a.Rig and a.Rig:FindFirstChild("SpeedMultipliers")
 local value=folder and folder:FindFirstChild(key)
 if value then value:Destroy() end
end
local function knife(a,on)
 for part,transparency in pairs(a.DaggerParts or {}) do
  if part.Parent then part.Transparency=on and transparency or 1 end
 end
 -- Invisibility's own watcher can now affect the visible blade along with the rest of the rig.
end
local function stopPrayVFX(a)
 local visuals=a.TTPrayVFX;a.TTPrayVFX=nil
 for _,object in visuals or {} do
  for _,item in object:GetDescendants() do
   if item:IsA("ParticleEmitter") then
    item.Enabled=false
    if item.Name=="Spawn" and (object.Name=="Floor" or object.Name=="StartFloor") then item:Clear() end
   elseif item:IsA("Light") then TweenService:Create(item,TweenInfo.new(.2),{Brightness=0}):Play() end
  end
  if object:IsA("Beam") then TweenService:Create(object,TweenInfo.new(.2),{Width1=0}):Play() end
  Debris:AddItem(object,4)
 end
end
local function startPrayVFX(a)
 stopPrayVFX(a)
 local folder=Visuals.Build("Pray")
 a.TTPrayVFX=folder:GetChildren()
 for _,object in a.TTPrayVFX do object.Parent=a.Rig.PrimaryPart end
 folder:Destroy()
 for _,object in a.TTPrayVFX do
  for _,item in object:GetDescendants() do
   if item:IsA("ParticleEmitter") then
    -- Keep the startup Spawn glyph alive for the entire hold, alongside the looping lights.
    if item.Name=="Spawn" and object.Name=="StartFloor" then item.Enabled=true;item.Rate=math.max(item.Rate,2) end
    if item:GetAttribute("EmitCount") then item:Emit(item:GetAttribute("EmitCount")) end
   end
  end
 end
end
local function nearest(a)
 local best,distance=nil,math.huge
 local players=workspace:FindFirstChild("Players")
 local killers=players and players:FindFirstChild("Killers")
 if killers then for _,rig in killers:GetChildren() do
  local humanoid=rig:FindFirstChildOfClass("Humanoid")
  if rig~=a.Rig and rig.PrimaryPart and humanoid and humanoid.Health>0 and not rig:GetAttribute("TwoTimeIgnoreTarget") then
   local range=(rig.PrimaryPart.Position-a.Rig.PrimaryPart.Position).Magnitude
   if range<distance then best,distance=rig,range end
  end
 end end
 return best,distance
end
local function updateBlood(a,value)
 a.Blood=math.clamp(value,0,a.Config.BloodRequiredForRespawn)
 a.Rig:SetAttribute("TwoTimeOblation",a.Blood)
 send(a,"Blood",a.Blood)
 local floor=a.RespawnLocation and a.RespawnLocation:FindFirstChild("EnabledFloor")
 if floor then
  local light=floor:FindFirstChild("Transparent")
  if light and light:IsA("Light") then light.Brightness=2+8*a.Blood/a.Config.BloodRequiredForRespawn end
  local shader=floor:FindFirstChild("FullShader")
  if shader and shader:IsA("ParticleEmitter") then shader.Enabled=a.Blood>=a.Config.BloodRequiredForRespawn end
 end
end
function Server.StopPray(a,interrupted)
 if not a.TTPraying then return end
 a.TTPraying=nil
 stopPrayVFX(a)
 a.Rig:SetAttribute("TwoTimePraying",nil)
 lock(a,"Pray",false);removeSpeed(a,"TwoTimePray")
 if a.TTJump then a.Rig.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping,a.TTJump.Enabled);a.TTJump=nil end
 if interrupted then a:SetCooldownOf("Pray",a.Config.PrayInterruptCooldown);send(a,"Warning","Your prayer was interrupted.") end
 send(a,"Pray",false)
end
function Server.StopCrouch(a,manual)
 if not a.TTCrouchStart then return end
 local elapsed=os.clock()-a.TTCrouchStart
 a.TTCrouchStart=nil;a.TTRamp=0
 a.Rig:SetAttribute("Crouching",nil)
 a.Rig:SetAttribute("FootstepsMuted",a.TTPreviousFootstepsMuted)
 a.TTPreviousFootstepsMuted=nil
 a.Rig:SetAttribute("TwoTimeCrouchBonus",nil)
 a:SetCooldownOf("Crouch",Rules.CrouchCooldown(a.Config,elapsed))
 Statuses:RemoveStatus(a.Player,"Invisibility");Statuses:RemoveStatus(a.Player,"Undetectable")
 removeSpeed(a,"TwoTimeCrouching");removeSpeed(a,"CrouchBonusTT")
 knife(a,false)
 if manual and alive(a) then
  local _,distance=nearest(a)
  if distance<=30 then Statuses:ApplyStatus(a.Player,"Speed",{Level=2,Duration=a.Config.CrouchSpeedCloseTime}) end
 end
end
local function cancelAttack(a)
 a.TTAttackToken=(a.TTAttackToken or 0)+1
 if a.TTHitbox then a.TTHitbox:Cancel();a.TTHitbox=nil end
 if a.TTVelocity then a.TTVelocity:Destroy();a.TTVelocity=nil end
 lock(a,"Dagger",false);removeSpeed(a,"TwoTimeStab");knife(a,false)
end
function Server.Dagger(a)
 if not alive(a) or blocked(a) or a.TTPraying or a.TTRitualCasting or a.TTAttacking then return {Cancelled=true} end
 a.TTAttacking=true
 local crouched=a.TTCrouchStart~=nil
 local charge=crouched and os.clock()-a.TTCrouchStart or 0
 Server.StopCrouch(a,false)
 cancelAttack(a)
 local token=a.TTAttackToken
 lock(a,"Dagger",true);knife(a,true)
 Util:CreateSpeedMultiplier(a.Rig,.1,"TwoTimeStab")
 local hit=false
 local function current() return alive(a) and a.TTAttackToken==token and not blocked(a) end
 task.delay(a.Config.DaggerWindup,function()
  if not current() then cancelAttack(a);a.TTAttacking=nil;return end
  local duration=crouched and a.Config.DaggerCrouchHitTime or a.Config.DaggerHitTime
  local velocity=Util:ApplyVelocity(a.Rig.PrimaryPart,crouched and a.Config.DaggerLungeForce or a.Config.DaggerUncrouchedLungeForce)
  a.TTVelocity=velocity
  TweenService:Create(velocity,TweenInfo.new(crouched and a.Config.DaggerCrouchMoverEndlag or .2),{LineVelocity=velocity.LineVelocity/3}):Play()
  Debris:AddItem(velocity,crouched and a.Config.DaggerCrouchMoverEndlag or .2)
  a.TTHitbox=Hitboxes:CreateHitbox(a.Player,{
   Size=a.Config.DaggerHitboxSize,CFrameOffset=CFrame.new(0,0,-a.Config.DaggerHitboxOffset),
   Damage=0,Time=duration,Knockback=0,HitMultiple=false,FriendlyFire=true,
   Connections={Hit=function(victim)
    if hit or not current() then return end
    local root=victim.PrimaryPart;local humanoid=victim:FindFirstChildOfClass("Humanoid")
    if not root or not humanoid or humanoid.Health<=0 or victim:GetAttribute("Invincible") then return end
    hit=true
    -- Raw root transforms, never actor:GetPivot() prediction/extrapolation.
    local ours=a.Rig.PrimaryPart
    local back=Rules.Backstab(ours.Position,ours.CFrame.LookVector,root.Position,root.CFrame.LookVector,a.Config)
    local immune=victim:GetAttribute("StunnedDisabled") or victim:GetAttribute("Stunned") or Statuses:PlayerHasStatus(victim,"Stunned")
    local targetActor=require(Modules.Actors).CurrentActors[Players:GetPlayerFromCharacter(victim)] or require(Modules.Actors).CurrentActors[victim]
    local exclusions=targetActor and targetActor.Config and targetActor.Config.StatusData and targetActor.Config.StatusData.ExcludeApplying
    immune=immune or exclusions and table.find(exclusions,"Stunned")
    Util:ApplyDamage(victim,back and a.Config.DaggerBackstabDamage or a.Config.DaggerDamage,nil,a.Rig)
    if not immune then
     if back then Statuses:ApplyStatus(victim,"Stunned",{Duration=Rules.Stun(a.Config,crouched,charge)})
     else
      Statuses:ApplyStatus(victim,"Slowness",{Level=2,Duration=a.Config.DaggerStatusTime})
      Statuses:ApplyStatus(victim,"Helpless",{Level=1,Duration=a.Config.DaggerStatusTime,TimeStackable=false})
     end
     local team=tostring(victim.Parent)
     local summon=victim:HasTag("SurvivorConstruct") or victim:HasTag("KillerConstruct") or victim:GetAttribute("IsMinion") or victim:GetAttribute("Summon")
     if not summon and (team=="Killers" or team=="Survivors") and a.LivesUsed==1 then updateBlood(a,a.Blood+Rules.Oblation(a.Config,back,crouched)) end
    end
    if a.TTVelocity then a.TTVelocity:Destroy();a.TTVelocity=nil end
   end}
  })
  task.delay(duration,function()
   if a.TTAttackToken~=token then return end
   a.TTHitbox=nil
   if crouched and not hit and alive(a) then
    local _,distance=nearest(a)
    local penalty=Rules.MissDuration(a.Config,distance)
    if penalty>0 then Statuses:ApplyStatus(a.Player,"Slowness",{Level=a.Config.DaggerMissSlownessLevel,Duration=penalty}) end
   end
  end)
 end)
 Statuses:ApplyStatus(a.Player,"Resistance",{Level=a.Config.DaggerResLevel,Duration=a.Config.DaggerResDuration})
 local total=a.Config.DaggerWindup+(crouched and a.Config.DaggerCrouchHitTime+a.Config.DaggerCrouchEndlag+a.Config.DaggerCrouchEndlagTweenTime or  .7)
 task.delay(total,function()
  if a.TTAttackToken==token then cancelAttack(a);a.TTAttacking=nil end
 end)
 return {Crouched=crouched,Duration=total}
end
function Server.Crouch(a)
 if not alive(a) or blocked(a) or a.TTPraying or a.TTRitualCasting or a.TTAttacking then return {Cancelled=true} end
 if a.TTCrouchStart then Server.StopCrouch(a,true);return end
 a.TTCrouchStart=os.clock();a.TTRamp=0
 a.TTPreviousFootstepsMuted=a.Rig:GetAttribute("FootstepsMuted")
 a.Rig:SetAttribute("FootstepsMuted",true)
 a.Rig:SetAttribute("Crouching",true)
 a:SetCooldownOf("Crouch",1)
 knife(a,true)
 Statuses:ApplyStatus(a.Player,"Invisibility",{Level=a.Config.CrouchInvisibilityLevel,Duration=a.Config.CrouchDuration})
 Statuses:ApplyStatus(a.Player,"Undetectable",{Level=a.Config.CrouchUndetectableLevel,Duration=a.Config.CrouchDuration})
 return {Started=true}
end
function Server.Pray(a)
 if not alive(a) or blocked(a) or a.TTAttacking or a.TTRitualCasting then return {Cancelled=true} end
 if a.TTPraying then Server.StopPray(a,false);return end
 local ritual=a.RespawnLocation
 if not ritual or not ritual.Parent or a.LivesUsed~=1 then send(a,"Warning","You must place your Ritual before praying.");return {Cancelled=true} end
 if (ritual.Position-a.Rig.PrimaryPart.Position).Magnitude>a.Config.PrayRange then return {Locate=ritual.Position,Warning="Return to your Ritual to pray."} end
 if a.Blood<=0 then send(a,"Warning","You need Oblation to pray.");return {Cancelled=true} end
 if a.Rig.Humanoid.Health>=a.Rig.Humanoid.MaxHealth then send(a,"Warning","You are already at full health.");return {Cancelled=true} end
 Server.StopCrouch(a,false)
 a.TTPraying=true;a.TTPrayStart=os.clock();a.TTPrayLease=os.clock()
 a.TTPrayDamage=0
 a.Rig:SetAttribute("TwoTimePraying",true)
 lock(a,"Pray",true)
 Util:CreateSpeedMultiplier(a.Rig,0,"TwoTimePray")
 a.TTJump={Enabled=a.Rig.Humanoid:GetStateEnabled(Enum.HumanoidStateType.Jumping)}
 a.Rig.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping,false)
 startPrayVFX(a)
 return {Started=true}
end
local function effect(a,name,parent)
 local template=a.Config.VFX and a.Config.VFX:FindFirstChild(name)
 if not template then return end
 local clone=template:Clone();clone.Parent=parent
 for _,object in clone:GetDescendants() do
  if object:IsA("Sound") then object:Destroy()
  elseif object:IsA("ParticleEmitter") then object:Emit(object:GetAttribute("EmitCount") or 8) end
 end
 Debris:AddItem(clone,3)
end
function Server.Ritual(a)
 local function invalid()
  a:IncrementCharges("Ritual",1,1)
  return {Cancelled=true}
 end
 if not alive(a) or blocked(a) or a.TTAttacking or a.TTPraying or a.TTRitualCasting or a.RespawnLocation or a.LivesUsed~=1 then return invalid() end
 local params=RaycastParams.new();params.FilterType=Enum.RaycastFilterType.Exclude
 local players=workspace:FindFirstChild("Players")
 params.FilterDescendantsInstances=players and {players} or {a.Rig}
 local root=a.Rig.PrimaryPart
 local forward=workspace:Raycast(root.Position,root.CFrame.LookVector*2.648,params)
 local distance=forward and math.max(0,forward.Distance-1) or 2.648
 local ground=workspace:Raycast(root.Position+root.CFrame.LookVector*distance,Vector3.new(0,-12,0),params)
 if not ground or ground.Normal.Y<.65 then return invalid() end
 local ingame=workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Ingame") or workspace
 for _,part in ingame:GetDescendants() do
  if part:IsA("BasePart") and (part.Name:find("RespawnLocation") or part.Name:find("Builderman")) and (part.Position-ground.Position).Magnitude<a.Config.RespawnLocationDistance then return invalid() end
 end
 a.TTRitualCasting=true;a.TTRitualToken=(a.TTRitualToken or 0)+1
 local token=a.TTRitualToken
 lock(a,"Ritual",true);Server.StopCrouch(a,false);knife(a,true)
 Util:CreateSpeedMultiplier(a.Rig,0,"TwoTimeRitual")
 local startPosition=root.Position
 task.delay(1.5,function()
  if not alive(a) or not a.TTRitualCasting or a.TTRitualToken~=token or blocked(a) or (root.Position-startPosition).Magnitude>4 then return end
  local spawn=a.Config.RespawnLocation:Clone()
  spawn.Name=a.Player.Name.."RespawnLocation";spawn.Anchored=true;spawn.CanCollide=false
  spawn.CFrame=CFrame.lookAt(ground.Position-Vector3.new(0,.1,0),ground.Position-Vector3.new(0,.1,0)+root.CFrame.LookVector*Vector3.new(1,0,1))
  for _,item in spawn:GetDescendants() do if item:IsA("Sound") then item:Destroy() end end
  spawn.Parent=ingame;a.RespawnLocation=spawn
  effect(a,"Ritual",spawn)
  local floor=a.Config.VFX and a.Config.VFX:FindFirstChild("EnabledFloor")
  if floor then local clone=floor:Clone();clone.Parent=spawn;for _,v in clone:GetDescendants() do if v:IsA("Sound") then v:Destroy() end end end
  updateBlood(a,a.Blood)
 end)
 task.delay(3.5,function()
  if a.TTDestroyed or a.TTRitualToken~=token then return end
  a.TTRitualCasting=nil;lock(a,"Ritual",false);removeSpeed(a,"TwoTimeRitual");knife(a,false)
  if not a.RespawnLocation then a:IncrementCharges("Ritual",1,1);a:SetCooldownOf("Ritual",0) end
 end)
 return {Started=true,Duration=3.5}
end
function Server.Interrupt(a)
 Server.StopCrouch(a,false);Server.StopPray(a,true)
 if a.TTAttacking then cancelAttack(a);a.TTAttacking=nil end
 if a.TTRitualCasting then
  a.TTRitualToken=(a.TTRitualToken or 0)+1
  a.TTRitualCasting=nil;lock(a,"Ritual",false);removeSpeed(a,"TwoTimeRitual");knife(a,false)
  if not a.RespawnLocation then a:IncrementCharges("Ritual",1,1);a:SetCooldownOf("Ritual",0) end
 end
end
function Server.OnHit(a,hitbox,damage,lms)
 if not alive(a) then return end
 damage=math.max(0,tonumber(damage) or 0)
 if a.TTPraying then
  a.TTPrayDamage=(a.TTPrayDamage or 0)+damage
  if a.TTPrayDamage>=a.Config.PrayInterruptDamage then Server.StopPray(a,true) end
 end
 if damage>0 then a.TTRamp=0;a.TTRampResetUntil=os.clock()+.15;a.Rig:SetAttribute("TwoTimeCrouchBonus",1) end
 if a.LivesUsed~=1 or a.TTReviving then return end
 if not lms and (damage<a.Rig.Humanoid.Health or a.Blood<a.Config.BloodRequiredForRespawn or not a.RespawnLocation or not a.RespawnLocation.Parent) then return end
 a.TTReviving=true
 if hitbox then hitbox.TimePast=9999 end -- FCT Util/Hitboxes cancel the lethal hit before applying it.
 cancelAttack(a);a.TTAttacking=nil;Server.StopPray(a,false);Server.StopCrouch(a,false)
 a.TTRitualCasting=nil;a.TTRitualToken=(a.TTRitualToken or 0)+1
 lock(a,"Ritual",false);removeSpeed(a,"TwoTimeRitual")
 local blood=a.Blood
 a.LivesUsed=2;a.Rig:SetAttribute("IsSecondLife",true)
 Statuses:RemoveStatuses(a.Player,true)
 local h=a.Rig.Humanoid
 if lms then
  local maxHealth,healing=Rules.LMS(a.Config,blood)
  h.MaxHealth=maxHealth;h.Health=math.min(maxHealth,h.Health+healing)
 else h.MaxHealth=a.Config.Health/a.Config.NextLifeHealthDivisor;h.Health=h.MaxHealth end
 Util:GiveInvincible(a.Rig,"TTRevive",a.Config.InvincibilityDuration)
 -- AddRig uses FCT's already-owned appearance templates and public expression decals.
 a.Behavior:AddRig(a,2)
 knife(a,false)
 local ritual=a.RespawnLocation
 if not lms and ritual and ritual.Parent then
  local height=(Util:GetDistanceFromGround(a.Rig) or 3)
  a:PivotTo(ritual.CFrame+Vector3.new(0,height,0))
  effect(a,"Respawned",ritual)
 else effect(a,"Respawned",a.Rig.PrimaryPart) end
 if ritual then Debris:AddItem(ritual,2);a.RespawnLocation=nil end
 local ritualAbility=a.Behavior.Abilities.Ritual
 if ritualAbility then a:IncrementCharges("Ritual",0,0) end
 updateBlood(a,0);send(a,"Revive",true)
 local _,_,speedTime=Rules.LMS(a.Config,blood)
 if not lms or speedTime>0 then Statuses:ApplyStatus(a.Player,"Speed",{Level=2,Duration=lms and speedTime or 6,Instant=true}) end
 if not lms then Statuses:ApplyStatus(a.Player,"Vulnerable",{Level=5,Duration=12,BypassInvincibility=true}) end
 -- Explicit opt-in for a round-based host; continuous combat has no timer or automatic LMS.
 if a.Config.TwoTimeRoundHooks then
  a.TimeAddMultiplier=25/40
  local round=game.ServerScriptService:FindFirstChild("RoundManager",true)
  if round and not lms then require(round):AddTime(nil,15/40) end
 end
 a.TTReviving=nil
 return "Ignored"
end
function Server.Created(a)
 a.TTConnections={};a.LivesUsed=1;a.Blood=0;a.TTAttackToken=0
 a.Behavior:AddRig(a,1)
 local dagger=a.Config.DaggerTemplate:Clone()
 for _,item in dagger:GetDescendants() do if item:IsA("Sound") then item:Destroy() end end
 local motor=dagger:FindFirstChildOfClass("Motor6D")
 if motor then motor.Part0=a.Rig.PrimaryPart;dagger.Parent=a.Rig else dagger:Destroy() end
 a.DaggerParts={}
 if dagger.Parent then for _,part in dagger:GetDescendants() do
  if part:IsA("BasePart") or part:IsA("Decal") then a.DaggerParts[part]=part.Transparency;part.Transparency=1 end
  if part:IsA("BasePart") then part.CanCollide=false;part.CanTouch=false;part.Massless=true end
 end end
 local remote="TwoTimePortHold_"..a.Player.UserId
 Network:SetConnection(remote,"REMOTE_EVENT",function(player,holding)
  if player~=a.Player or not a.TTPraying then return end
  if holding==true then a.TTPrayLease=os.clock() else Server.StopPray(a,false) end
 end)
 a.TTHoldRemote=remote
 table.insert(a.TTConnections,a.Rig.Humanoid.HealthChanged:Connect(function(health)
  if a.TTLastHP and health<a.TTLastHP then a.TTRamp=0;a.TTRampResetUntil=os.clock()+.15 end
  a.TTLastHP=health
 end))
 table.insert(a.TTConnections,RunService.Heartbeat:Connect(function(dt)
  if not alive(a) then Server.Destroyed(a);return end
  if blocked(a) then
   Server.Interrupt(a)
  end
  if a.TTCrouchStart then
   local elapsed=os.clock()-a.TTCrouchStart
   if elapsed>=a.Config.CrouchDuration then Server.StopCrouch(a,false)
   else
    local target,distance=nearest(a);local h=a.Rig.Humanoid;local root=a.Rig.PrimaryPart
    local direction=target and target.PrimaryPart.Position-root.Position
    local motion=root.AssemblyLinearVelocity*Vector3.new(1,0,1)
    local running=motion.Magnitude>a.Config.CrouchSpeed+1
    if running and direction and direction.Magnitude>.001 and distance<=a.Config.CrouchSpeedBoostDistance and motion.Unit:Dot(direction.Unit)>a.Config.CrouchSpeedBoostDot and os.clock()>=(a.TTRampResetUntil or 0) then a.TTRamp=math.min(a.Config.CrouchSpeedBoostTime,a.TTRamp+dt) else a.TTRamp=0 end
    a.Rig:SetAttribute("TwoTimeCrouchBonus",1+(a.Config.CrouchSpeedBoostMax-1)*a.TTRamp/a.Config.CrouchSpeedBoostTime)
   end
  end
  if a.TTPraying then
   local ritual=a.RespawnLocation
   if os.clock()-a.TTPrayLease>1.25 or os.clock()-a.TTPrayStart>30 or not ritual or not ritual.Parent or (ritual.Position-a.Rig.PrimaryPart.Position).Magnitude>a.Config.PrayRange then Server.StopPray(a,false)
   else
    local h=a.Rig.Humanoid
    local spent,healed=Rules.Pray(a.Config,a.Blood,h.MaxHealth-h.Health,math.min(dt,.25))
    if spent>0 then updateBlood(a,a.Blood-spent);h.Health=math.min(h.MaxHealth,h.Health+healed) end
    if a.Blood<=.00001 or h.Health>=h.MaxHealth then Server.StopPray(a,false) end
   end
  end
 end))
 if a.Config.TwoTimeRoundHooks then
  local survivors=workspace.Players.Survivors
  table.insert(a.TTConnections,survivors.ChildRemoved:Connect(function()
   if alive(a) and #survivors:GetChildren()==1 then Server.OnHit(a,nil,0,true) end
  end))
 end
 updateBlood(a,0)
end
function Server.Destroyed(a)
 if a.TTDestroyed then return end
 Server.StopPray(a,false);Server.StopCrouch(a,false);cancelAttack(a)
 a.TTDestroyed=true
 lock(a,"Ritual",false);removeSpeed(a,"TwoTimeRitual")
 for _,connection in a.TTConnections or {} do connection:Disconnect() end
 if a.TTHoldRemote then Network:RemoveConnection(a.TTHoldRemote,"REMOTE_EVENT") end
 if a.RespawnLocation then a.RespawnLocation:Destroy();a.RespawnLocation=nil end
end
return Server
]====]},
{path=[====[
ServerStorage/Assets/Survivors/TwoTime/Config]====],before="14227:c58653c9:e7f29712",after="14230:47aec50a:a06c72a7",source=[====[

local t1 = {
	DisplayName = "Two Time",
	Quote = "\"Shadows die twice.\"",
	Class = "Sentinel",
	RenderImage = "rbxassetid://107234615040462",
	Price = 500,
	Exclusive = false,
	LMSEffect = {
		ProcessingModule = "BasicLMS",
		SoundId = "heartbeat",
		ImageId = function(s1: string) -- line: 14
			if s1 == "Azure" then
				return "rbxassetid://114627570317346"
			end

			return "rbxassetid://103025892289003"
		end,
		PrimaryColor = function(s2: string) -- line: 20
			if s2 == "Azure" then
				return Color3.fromRGB(115, 0, 255)
			end

			return Color3.fromRGB(255, 0, 0)
		end,
		SecondaryColor = Color3.fromRGB(0, 0, 0)
	},
	Health = 80,
	Speed = 12,
	DaggerCooldown = 30,
	DaggerWindup = 0.3,
	DaggerDamage = 10,
	DaggerBackstabDamage = 20,
	DaggerLungeForce = 110,
	DaggerUncrouchedLungeForce = 50,
	DaggerBackstabThreshold = 70,
	DaggerLookDirectionAngle = 70,
	DaggerStatusTime = 1,
	DaggerBackstabStatusTime = 3.5,
	DaggerCrouchMinStunTime = 2,
	DaggerCrouchStunChargeTime = 1,
	DaggerLifestealFromFront = 0,
	DaggerLifestealFromBack = 0,
	DaggerCrouchEndlag = 0.225,
	DaggerCrouchEndlagTweenTime = 0.15,
	DaggerCrouchMoverEndlag = 0.4,
	DaggerCrouchSprintLockTime = 1,
	DaggerUncrouchedSprintLockTime = 1,
	DaggerMissSlownessDistanceInterval = 10,
	DaggerMissSlownessDurationMultiplier = 1,
	DaggerMissSlownessMaxDuration = 8,
	DaggerMissSlownessLevel = 2,
	PrayRange = 10,
	PrayHoldTime = NumberRange.new(0.15, 30),
	PrayHighlightDuration = 4,
	PrayHighlightImage = "rbxassetid://100508591140926",
	PrayHealthPerFullOblation = 66.66666666666667,
	PrayFullConversionTime = 10,
	PrayInterruptDamage = 5,
	PrayInterruptCooldown = 6,
	DaggerResLevel = 1,
	DaggerResDuration = 0.7,
	BloodReqIncreasePerTwoTime = 1,
	CrouchCooldown = 30,
	CrouchMinCooldown = 15,
	CrouchDuration = 15,
	CrouchSpeed = 10,
	CrouchRunSpeed = 23,
	CrouchInvisibilityLevel = 3,
	CrouchUndetectableLevel = 1,
	CrouchSpeedCloseTime = 1,
	CrouchStabAmplifyTime = 4,
	CrouchRevealTime = 2,
	CrouchSpeedBoostMax = 1.5,
	CrouchSpeedBoostTime = 4,
	CrouchSpeedBoostDot = 0.2,
	CrouchSpeedBoostDistance = 105,
	CrouchTeammateRevealDistance = 100,
	CrouchTeammateRevealFadeTime = 1.25,
	CrouchOblationMultiplier = 1.25,
	CrouchDistances = {
		CLOSE = {
			0,
			30
		},
		DEBUFF_SLOWNESS = {
			75,
			-1
		},
		DEBUFF_HIGHLIGHT = {
			125,
			-1
		}
	},
	CrouchSlownessDebuffMax = 150,
	Lives = 2,
	BloodRequiredForRespawn = 8,
	BloodFromFront = 1.6,
	BloodFromBack = 3.2,
	RespawnLocationDistance = 10,
	NextLifeHealthDivisor = 1.6,
	InvincibilityDuration = 2,
	LastSurvivorMaxHealth = 110,
	LastSurvivorHealthBonus = 50,
	RespawnLocation = script.Spawn,
 HealthBar = script.Sidebar,
 AudioReplication = script.AudioReplication,
 VFX = script.TwoTimeVFX,
 LifeAppearances = {[1]=script.Life1,[2]=script.Life2},
 DaggerTemplate = script.GhostFire,
	Animations = {},
 Sounds = {},
	ExpressionsTable = {
		[1] = {
			Happy = "rbxassetid://82471736046966",
			Default = "rbxassetid://111259025475261",
			Hurt = "rbxassetid://124079311211417",
			Injured = "rbxassetid://82982231751339",
			Dead = "rbxassetid://74288576584860",
			Drinking = "rbxassetid://135845534213100"
		},
		[2] = {
			Happy = "rbxassetid://105016806376431",
			Default = "rbxassetid://80110682472998",
			Hurt = "rbxassetid://91658006415418",
			Injured = "rbxassetid://135831503096288",
			Dead = "rbxassetid://86722867217862",
			Drinking = "rbxassetid://116753879639619"
		}
	}
}

t1.Expressions = t1.ExpressionsTable[1]
t1.TextInteractions = {
	Requests = {
		ElliotPizza = {
			"Hey, hey. Pizza, pizza please.",
			"Pizza’s something I haven’t tried much, mind if I get a slice?",
			"I must ask for a pizza.",
			"Do you have pizza? I could use one!",
			"May I have a pizza slice?",
			"I really want a pizza! May I have one?"
		},
		BuildermanSentry = {
			"Your turrets may be of use over here.",
			"A sentry here should be put to use. Place it here.",
			"Place your sentry over here. It will help against the foes.",
			"Put down a sentry here.",
			"Your sentry will be of use over here."
		},
		BuildermanDispenser = {
			"I’m in need of a dispenser in my position.",
			"I require a dispenser to be placed here.",
			"Dispenser here, please.",
			"Put down one of your dispensers here.",
			"Your dispenser is needed here."
		},
		DusekkarProtection = {
			"Divine pumpkin, I humbly request your divine ability.",
			"Divine pumpkin, I implore you to cast your ability onto me.",
			"Divine pumpkin, I ask of thee to be blessed.",
			"Divine pumpkin, blessed be thy heart should you cast a spell unto me.",
			"Divine pumpkin, I ask for thy divine intervention."
		},
		HemmorhageAsk = {
			"By the Spawn's grace... I ... I must ask for your aid...",
			"My wounds.. are severe, I fear. Please, aid me, and the Spawn will smile at thy.",
			"I beg, I plead.. I ask for your aid as my body drains with every second...",
			"May you be blessed by the Spawn should you lend me your aid..",
			"Lend me your aid, and the Spawn shall guide you forward..."
		},
		HelperPulse = {
			"Your mechanisms are of most utmost importance right now, no time to waste..",
			"Keep a steady pace, machine... You mustn't waste a minute in tending to the group.",
			"Let your energy shine in those who need it most...",
			"Perhaps you may use your energy on the ones who may need it?",
			"We are in need of your energy, mechanism, and we must get it, fast.."
		},
		HelperInspire = {
			"Make haste, for our group seem to have grown exhausted..",
			"Let your mechanisms beam on the group, and may their beings feel ever so blessed by the Spawn while you do so.",
			"Shall we huddle closer together so your energy is conserved when you activate it?",
			"You've a keen eye for the others, do you not? You must see that they have grown tired.. You simply must help.",
			"We need your assistance on the matter, do you still have the energy to do so?"
		}
	},
	Thanks = {
		Regular = {
			"Much appreciated.",
			"Very thankful for your service.",
			"May good fortune come your way for your generosity.",
			"The Spawn would be pleased with your acts of kindness.",
			"I thank you for your service.",
			"Oh give thanks to the Spawn, for he is good; for their steadfast love endures forever."
		},
		DusekkarProtection = {
			{
				"TwoTime: The Spawn would be pleased with your acts of kindness!",
				"Dusekkar: ...",
				"Dusekkar: Eugh..."
			},
			{
				"TwoTime: Oh give thanks to the Spawn, for he is good; for their steadfast love endures forever.",
				"Dusekkar: ...",
				"Dusekkar: Ugh..."
			}
		}
	}
}

local v2 = math.floor(t1.BloodFromFront / t1.BloodRequiredForRespawn * 100)
local v3 = math.floor(t1.BloodFromBack / t1.BloodRequiredForRespawn * 100)

t1.Information = {
	{
		Separator = "GENERAL INFO"
	},
	{
		Header = "TWO TIME",
		Text = "A fragile cultist that holds a terrible secret. Bearing nothing other than a sleek dagger and manic smile, they're able to earn a second life through risk and sacrifice.\n"
	},
	{
		Header = "STATS",
		Text = "Difficulty: ★★★★☆\n" .. `Health: { t1.Health or 100 }\n` .. `Regular Speed: { t1.Speed or 12 }\n` .. `Sprinting Speed: { t1.SprintSpeed or 26 }\n` .. `Max Stamina: { t1.MaxStamina or 100 }\n` .. `Stamina Loss per sec: { t1.StaminaLoss or 10 }\n` .. `Stamina Gain per sec: { t1.StaminaGain or 20 }\n`
	},
	{
		Separator = "PASSIVES"
	},
	{
		Header = "OBLATION",
		Quote = "\"You both shall set out on the grand step to rebirth.\" - ██████",
		Text = "<font color=\"#6c6e78\">Two Time</font> has a bar on the right side of the screen that, when filled, grants them a second life.\n" .. "The only way to fill this bar is by dealing damage to the Killer.\n\n" .. `Landing a stab to the front will fill { v2 }% of the bar.\n` .. `Landing a stab to the back will fill { v3 }% of the bar.\n` .. "Crouched Lunge Stabs increases the <b>OBLATION</b> gain by 25%.\n\n" .. "<font color=\"#6c6e78\">Two Time</font> will enter their second life upon taking lethal damage or being the last alive Survivor.\n" .. "In their second life, they only have 50 maximum health.\n" .. "Upon activation:\n\n" .. " * Stamina is restored by 40%\n" .. " * All status effects are removed\n" .. ` * <font color="#6c6e78">Two Time</font> is made invincible for { t1.InvincibilityDuration } seconds \n` .. " * <b>Speed II</b> is applied for 6 seconds\n" .. " * <b>Vulnerable V</b> is applied for 12 seconds\n"
	},
	{
		Separator = "ABILITIES"
	},
	{
		Header = "SACRIFICIAL DAGGER",
		Image = "rbxassetid://129077533212750",
		Quote = "\"Lookie, █████—they gave us this cool knife!\" - Two Time",
		Text = `Cooldown: { t1.DaggerCooldown }s\n` .. `After a { t1.DaggerWindup }s windup, <font color="#6c6e78">Two Time</font> stabs forward and gains <b>Resistance { t1.DaggerResLevel }</b> for { t1.DaggerResDuration } seconds.\n\n` .. `Landing a stab to the front will do { t1.DaggerDamage } damage and inflict <b>Slowness II</b> and <b>Helpless I</b> for { t1.DaggerStatusTime }s.\n\n` .. `Landing a stab to the back will instead do { t1.DaggerBackstabDamage } damage and stun the Killer for 2s.\n\n` .. `Using this ability while <b>crouched</b> quickly lunges you forward with a stab that has increased endlag but grants 25% more <b>OBLATION</b> progress. A crouched backstab's stun scales linearly from { t1.DaggerCrouchMinStunTime }s to { t1.DaggerBackstabStatusTime }s after { t1.DaggerCrouchStunChargeTime }s of crouching. The charge is measured when the stab begins.\n\n` .. `Missing a <b>crouched stab</b> will inflict <font color="#6c6e78">Two Time</font> with Slowness II for up to { t1.DaggerMissSlownessMaxDuration }s depending on their distance from the Killer after it ends.\n\n` .. "Landing a stab on a summon or a stun immune Killer does not grant any <b>OBLATION</b> progress.\n"
	},
	{
		Header = "CROUCH",
		Image = "rbxassetid://77707049887484",
		Quote = "\"Quiet, Two Time! They're not supposed to see us in here, hehe!\" - █████",
		Text = `Cooldown: { t1.CrouchCooldown }s\n` .. "<font color=\"#6c6e78\">Two Time</font> crouches down to silence their footsteps and become stealthier.\n\n" .. `<font color="#6c6e78">Two Time</font> remains <b>crouched</b> for at most { t1.CrouchDuration } seconds, but can uncrouch whenever they need to.\n` .. `Crouching applies <b>Undetectable I</b> and <b>Invisibility III</b> for at most { t1.CrouchDuration } seconds.\n\n` .. `While <b>crouched</b>, <font color="#6c6e78">Two Time</font>'s aura is revealed to teammates within { t1.CrouchTeammateRevealDistance } studs.\n\n` .. `While <b>crouched</b>, <font color="#6c6e78">Two Time</font> will gradually gain speed while running towards the Killer, with this speed boost capping out at { math.round((t1.CrouchSpeedBoostMax - 1) * 100) }% after { t1.CrouchSpeedBoostTime }s of running. This speed boost is immediately lost if <font color="#6c6e78">Two Time</font> exits Crouch, takes damage, or stops running towards the Killer.\n\n` .. "Uncrouching manually will forcibly remove these statuses and if <font color=\"#6c6e78\">Two Time</font> is within 30 studs of the Killer, will additionally grant <font color=\"#6c6e78\">Two Time</font> <b>Speed II</b> for 1s.\n"
	},
	{
		Header = "PRAY",
		Image = "rbxassetid://83582849559932",
		Quote = "\"May Spawn bless us today!\" - ██████",
		Text = "<font color=\"#6c6e78\">Two Time</font> will kneel near their <b>RITUAL</b> and begin praying while this ability is held.\n" .. "Letting go of the ability will stop <b>PRAYING</b>.\n\n" .. "While <b>PRAYING</b>, <font color=\"#6c6e78\">Two Time</font> will rapidly exchange <b>OBLATION</b> progress for HP.\n" .. `<font color="#6c6e78">Two Time</font> will gain 1 HP for every { 100 / t1.PrayHealthPerFullOblation }% <b>OBLATION</b> progress spent, restoring up to approximately { string.format("%.2f", t1.PrayHealthPerFullOblation) } HP from a full bar, without exceeding their maximum health.\n\n` .. "If <font color=\"#6c6e78\">Two Time</font> is not near their <b>RITUAL</b> when attempting to use this ability, the location of their <b>RITUAL</b> will be revealed to them for 4s.\n\n" .. "<font color=\"#6c6e78\">Two Time</font> is unable to use this ability if they do not have a <b>RITUAL</b>.\n"
	},
	{
		Header = "RITUAL",
		Image = "rbxassetid://95580729656404",
		Quote = "\"Spawn will be eternally pleased at our devotion!\" - ██████",
		Text = "<font color=\"#6c6e78\">Two Time</font> inscribes a respawn location on the ground.\n" .. "Dying with a full <b>OBLATION</b> bar will instantly teleport <font color=\"#6c6e78\">Two Time</font> to this point.\n\n" .. "<b>This ability can only be used once per round.</b>\n\n" .. "If <font color=\"#6c6e78\">Two Time</font> becomes the last survivor alive and has not already entered their second life, <b>RITUAL</b> will automatically trigger regardless of whether <b>OBLATION</b> was full or not.\n" .. `If this happens, <font color="#6c6e78">Two Time</font> will have their maximum health increased up to { t1.LastSurvivorMaxHealth }, be healed for up to { t1.LastSurvivorHealthBonus } HP, and will not be afflicted with <b>Vulnerable V</b>.` .. "Additionally, they will not teleport to their Ritual, and any buffs they receive will be decreased depending on how much <b>OBLATION</b> they are missing.\n"
	},
	{
		Separator = "CREDITS",
		Text = "Writer: 4Montaigne, sayso_1230Programmer: voxov_tired, ffPranksterDesigner: astertudeAnimator: sayso_1230Renderer: doc"
	}
}

-- Port choices where the export lacks authoritative server code:
-- Restore the first working port: original size, offset and shared hitbox prediction path.
-- Miss penalty grows outside the 30-stud close range; no penalty without a killer.
t1.DaggerHitboxSize=Vector3.new(4,6,5.5)
t1.DaggerHitboxOffset=7
t1.DaggerMissSlownessSafeDistance=30
t1.WarningTemplate=script:FindFirstChild("Warning")
t1.DaggerHitTime=.25
t1.DaggerCrouchHitTime=.415
t1.PraySensitiveButton=true
-- Custom, server-validated hold lease; omit PrayHoldTime to avoid the old generic charge protocol.
t1.PrayHoldTime=nil
t1.TwoTimeRoundHooks=false
t1.SprintSpeed=26
t1.MaxStamina=100
t1.StaminaLoss=10
t1.StaminaGain=20
t1.TwoTimePortVersion="1.0.2"
return t1
]====]}
}
local pending={}
for _,plan in plans do
 assert(#plan.source<200000,"Source exceeds Studio's limit: "..plan.path..". Nothing changed.")
 assert(fingerprint(plan.source)==plan.after,"Incomplete installer text. Copy the entire Raw file again.")
 local target=find(plan.path)
 if target then
  assert(target:IsA("ModuleScript"),"Expected ModuleScript at "..plan.path..". Nothing changed.")
  local current=fingerprint(target.Source)
  if current~=plan.after then
   assert((plan.before and current==plan.before) or (plan.previous and current==plan.previous) or (plan.previous2 and current==plan.previous2),"Unexpected edited source at "..plan.path..". Nothing changed; keep your edits and send that module for reconciliation.")
   table.insert(pending,{target=target,plan=plan,before=target.Source})
  end
 else
  assert(plan.before==false,"Missing FCT module at "..plan.path..". Nothing changed.")
  local parentPath=plan.path:match("^(.*)/[^/]+$")
  assert(find(parentPath),"Missing parent at "..parentPath..". Nothing changed.")
  table.insert(pending,{plan=plan})
 end
end
if #pending==0 then print("[Two Time FCT Port] Already applied.");return end
local backup=Instance.new("Folder")
backup.Name="TwoTimeFCTPort_Backup_"..os.date("!%Y%m%d_%H%M%S")
backup.Parent=game:GetService("ServerStorage")
for i,item in pending do
 local saved=item.target and item.target:Clone() or Instance.new("Folder")
 saved.Name=string.format("%02d_%s",i,item.plan.path:match("[^/]+$"))
 saved:SetAttribute("OriginalPath",item.plan.path)
 saved:SetAttribute("WasCreated",item.target==nil)
 saved:SetAttribute("InstalledFingerprint",item.plan.after)
 saved.Parent=backup
end
local ok,err=pcall(function()
 for _,item in pending do
  if not item.target then
   item.target=Instance.new("ModuleScript")
   item.target.Name=item.plan.path:match("[^/]+$")
   item.target.Parent=find(item.plan.path:match("^(.*)/[^/]+$"))
  end
  item.target.Source=item.plan.source
 end
end)
if not ok then
 for i=#pending,1,-1 do
  local item=pending[i]
  if item.before then item.target.Source=item.before elseif item.target then item.target:Destroy() end
 end
 backup:Destroy()
 error("[Two Time FCT Port] Rolled back after write failure: "..tostring(err))
end
pcall(function()game:GetService("ChangeHistoryService"):SetWaypoint("Two Time FCT Port")end)
print("[Two Time FCT Port] Applied "..#pending.." modules. Backup: "..backup:GetFullName()..". Save and start a fresh playtest. Kit animations and sounds are disabled.")
