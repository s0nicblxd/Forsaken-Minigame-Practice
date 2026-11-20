local now=0
local os={clock=function() return now end}
local pending={}
local task={delay=function(delay,fn)table.insert(pending,{at=now+delay,fn=fn})end}
local function advance(dt)
 local target=now+dt
 while true do
  table.sort(pending,function(a,b)return a.at<b.at end)
  if not pending[1] or pending[1].at>target then break end
  local item=table.remove(pending,1);now=item.at;item.fn()
 end
 now=target
end
local function signal()
 local callbacks={}
 return {Connect=function(_,fn)
  local connection={Connected=true,Disconnect=function(self)self.Connected=false end}
  table.insert(callbacks,{fn=fn,connection=connection});return connection
 end,Fire=function(_,...)for _,item in callbacks do if item.connection.Connected then item.fn(...) end end end}
end
local Vector3={}
local mt={}
function Vector3.new(x,y,z)return setmetatable({X=x,Y=y,Z=z},mt)end
mt.__add=function(a,b)return Vector3.new(a.X+b.X,a.Y+b.Y,a.Z+b.Z)end
mt.__sub=function(a,b)return Vector3.new(a.X-b.X,a.Y-b.Y,a.Z-b.Z)end
mt.__mul=function(a,b)if type(b)=='number' then return Vector3.new(a.X*b,a.Y*b,a.Z*b)end return Vector3.new(a.X*b.X,a.Y*b.Y,a.Z*b.Z)end
mt.__index=function(a,key)
 local mag=math.sqrt(a.X*a.X+a.Y*a.Y+a.Z*a.Z)
 if key=='Magnitude' then return mag end
 if key=='Unit' then return mag>0 and Vector3.new(a.X/mag,a.Y/mag,a.Z/mag) or Vector3.new(0,0,0) end
 if key=='Dot' then return function(_,b)return a.X*b.X+a.Y*b.Y+a.Z*b.Z end end
end
local CFrame={new=function(...)return {...}end}
local Enum={HumanoidStateType={Jumping='Jumping'}}
local TweenInfo={new=function()return {}end}
local Debris={AddItem=function()end}
local TweenService={Create=function(_,object,_,values)return {Play=function()for k,v in values do object[k]=v end end}end}
local heartbeat=signal()
local RunService={Heartbeat=heartbeat}
local Players={GetPlayerFromCharacter=function(_,rig)return rig.player end}
local Network={events={},callbacks={},FireClientConnection=function(self,player,name,_,kind,data)table.insert(self.events,{kind=kind,data=data})end,
 SetConnection=function(self,name,_,callback)self.callbacks[name]=callback end,RemoveConnection=function(self,name)self.callbacks[name]=nil end}
local actors={CurrentActors={}}
local Modules={Actors='Actors'}
local require=function(name)assert(name=='Actors');return actors end
local workspace={FindFirstChild=function()return nil end}
local game={ReplicatedStorage={Modules=Modules}}
local function object()
 return {Parent=true,Destroy=function(self)self.Parent=nil end}
end
local function rig(position,look)
 local attrs={};local speeds={}
 local h={Health=80,MaxHealth=80,HipHeight=2,HealthChanged=signal(),GetStateEnabled=function()return true end,SetStateEnabled=function()end}
 local root={Position=position or Vector3.new(0,0,0),CFrame={LookVector=look or Vector3.new(0,0,-1)},Anchored=false,AssemblyLinearVelocity=Vector3.new(0,0,0)}
 local model={Parent={Name='Killers'},PrimaryPart=root,Humanoid=h,attrs=attrs,speeds=speeds}
 model.Parent=setmetatable(model.Parent,{__tostring=function()return 'Killers'end})
 function model:GetAttribute(key)return attrs[key]end
 function model:SetAttribute(key,value)attrs[key]=value end
 function model:FindFirstChildOfClass(key)if key=='Humanoid' then return h end end
 function model:FindFirstChild(key)
  if key=='Humanoid' then return h end
  if key=='SpeedMultipliers' then return {FindFirstChild=function(_,name)return speeds[name] and speeds[name].Parent and speeds[name] or nil end}end
 end
 function model:HasTag(key)return attrs[key]end
 return model
end
local Statuses={applied={},removed={}}
function Statuses:ApplyStatus(target,name,data)table.insert(self.applied,{target=target,name=name,data=data})end
function Statuses:RemoveStatus(target,name)table.insert(self.removed,name)end
function Statuses:PlayerHasStatus()return nil end
function Statuses:RemoveStatuses()end
local Util={}
function Util:CreateSpeedMultiplier(rig,value,key)
 local item=object();item.Value=value;rig.speeds[key]=item;return item
end
function Util:ApplyVelocity(root,value)local v=object();v.LineVelocity=value;return v end
function Util:ApplyDamage(victim,damage)victim.Humanoid.Health-=damage end
function Util:GiveInvincible(rig,_,duration)rig.invincibility=duration end
function Util:GetDistanceFromGround()return 3 end
local Visuals={Build=function()return {GetChildren=function()return {}end,Destroy=function()end}end}
local Hitboxes={}
function Hitboxes:CreateHitbox(_,settings)
 self.last=settings;self.count=(self.count or 0)+1
 local hitbox={Cancel=function(self)self.cancelled=true end};self.state=hitbox;return hitbox
end
-- Pure kit math, shared by server, indicator, and regression tests.
local Rules = {}
function Rules.Oblation(config, backstab, crouched)
 return (backstab and config.BloodFromBack or config.BloodFromFront) * (crouched and config.CrouchOblationMultiplier or 1)
end
function Rules.Stun(config, crouched, elapsed)
 if not crouched then return 2 end
 return config.DaggerCrouchMinStunTime + (config.DaggerBackstabStatusTime-config.DaggerCrouchMinStunTime)*math.clamp(elapsed/config.DaggerCrouchStunChargeTime,0,1)
end
function Rules.CrouchCooldown(config, elapsed)
 return math.clamp(config.CrouchCooldown-elapsed,config.CrouchMinCooldown,config.CrouchCooldown)
end
function Rules.MissDuration(config, distance)
 if distance==math.huge then return 0 end
 local excess=math.max(0,distance-(config.DaggerMissSlownessSafeDistance or 30))
 return math.clamp(excess/config.DaggerMissSlownessDistanceInterval*config.DaggerMissSlownessDurationMultiplier,0,config.DaggerMissSlownessMaxDuration)
end
function Rules.Pray(config, blood, missingHealth, elapsed)
 local requirement=config.BloodRequiredForRespawn
 local spent=math.min(math.max(blood,0),requirement*elapsed/config.PrayFullConversionTime,math.max(missingHealth,0)*requirement/config.PrayHealthPerFullOblation)
 return spent,spent/requirement*config.PrayHealthPerFullOblation
end
function Rules.LMS(config,blood)
 local fraction=math.clamp(blood/config.BloodRequiredForRespawn,0,1)
 return config.Health+(config.LastSurvivorMaxHealth-config.Health)*fraction,config.LastSurvivorHealthBonus*fraction,6*fraction
end
function Rules.Backstab(attackerPosition, attackerLook, victimPosition, victimLook, config)
 local offset=victimPosition-attackerPosition
 offset=Vector3.new(offset.X,0,offset.Z)
 local facing=Vector3.new(victimLook.X,0,victimLook.Z)
 local aim=Vector3.new(attackerLook.X,0,attackerLook.Z)
 if offset.Magnitude<.001 or facing.Magnitude<.001 or aim.Magnitude<.001 then return false end
 return offset.Unit:Dot(facing.Unit)>math.cos(math.rad(config.DaggerBackstabThreshold)) and aim.Unit:Dot(facing.Unit)>math.cos(math.rad(config.DaggerLookDirectionAngle))
end

local config={Price=500,Health=80,Speed=12,DaggerCooldown=30,DaggerWindup=0.3,DaggerDamage=10,DaggerBackstabDamage=20,DaggerLungeForce=110,DaggerUncrouchedLungeForce=50,DaggerBackstabThreshold=70,DaggerLookDirectionAngle=70,DaggerStatusTime=1,DaggerBackstabStatusTime=3.5,DaggerCrouchMinStunTime=2,DaggerCrouchStunChargeTime=1,DaggerLifestealFromFront=0,DaggerLifestealFromBack=0,DaggerCrouchEndlag=0.225,DaggerCrouchEndlagTweenTime=0.15,DaggerCrouchMoverEndlag=0.4,DaggerCrouchSprintLockTime=1,DaggerUncrouchedSprintLockTime=1,DaggerMissSlownessDistanceInterval=10,DaggerMissSlownessDurationMultiplier=1,DaggerMissSlownessMaxDuration=8,DaggerMissSlownessLevel=2,PrayRange=10,PrayHighlightDuration=4,PrayHealthPerFullOblation=66.66666666666667,PrayFullConversionTime=10,PrayInterruptDamage=5,PrayInterruptCooldown=6,DaggerResLevel=1,DaggerResDuration=0.7,BloodReqIncreasePerTwoTime=1,CrouchCooldown=30,CrouchMinCooldown=15,CrouchDuration=15,CrouchSpeed=10,CrouchRunSpeed=23,CrouchInvisibilityLevel=3,CrouchUndetectableLevel=1,CrouchSpeedCloseTime=1,CrouchStabAmplifyTime=4,CrouchRevealTime=2,CrouchSpeedBoostMax=1.5,CrouchSpeedBoostTime=4,CrouchSpeedBoostDot=0.2,CrouchSpeedBoostDistance=105,CrouchTeammateRevealDistance=100,CrouchTeammateRevealFadeTime=1.25,CrouchOblationMultiplier=1.25,CrouchSlownessDebuffMax=150,Lives=2,BloodRequiredForRespawn=8,BloodFromFront=1.6,BloodFromBack=3.2,RespawnLocationDistance=10,NextLifeHealthDivisor=1.6,InvincibilityDuration=2,LastSurvivorMaxHealth=110,LastSurvivorHealthBonus=50,DaggerHitboxOffset=7,DaggerMissSlownessSafeDistance=30,DaggerHitTime=.25,DaggerCrouchHitTime=.415,SprintSpeed=26,MaxStamina=100,StaminaLoss=10,StaminaGain=20,TwoTimeRoundHooks=false,DaggerHitboxSize=Vector3.new(4,6,5.5)}
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


local function near(actual,expected,label)assert(math.abs(actual-expected)<.0001,(label or '')..': '..tostring(actual)..' != '..expected)end
local function actor()
 local a={Rig=rig(),Config=table.clone(config),Player={Name='Tester',UserId=12,Parent=true},AbilityDisablers={},Blood=0,LivesUsed=1,TTAttackToken=0,TTConnections={}}
 function a:SetCooldownOf(name,value)self.cooldowns=self.cooldowns or {};self.cooldowns[name]=value end
 function a:IncrementCharges(_,delta,max)self.charges=math.clamp((self.charges or 0)+delta,0,max or math.huge)end
 function a:PivotTo(cf)self.teleported=cf end
 a.Behavior={Abilities={Ritual={}},AddRig=function(_,_,life)a.appearance=life end}
 return a
end
near(Rules.Oblation(config,false,false),1.6)
near(Rules.Oblation(config,true,true),4)
near(Rules.Stun(config,false,10),2)
near(Rules.Stun(config,true,0),2)
near(Rules.Stun(config,true,.5),2.75)
near(Rules.Stun(config,true,1),3.5)
near(Rules.Stun(config,true,15),3.5)
near(Rules.CrouchCooldown(config,0),30)
near(Rules.CrouchCooldown(config,15),15)
near(Rules.CrouchCooldown(config,50),15)
near(Rules.MissDuration(config,20),0)
near(Rules.MissDuration(config,50),2)
near(Rules.MissDuration(config,110),8)
near(Rules.MissDuration(config,math.huge),0)
local spent,healing=Rules.Pray(config,8,80,10)
near(spent,8);near(healing,66.66666666666667)
spent,healing=Rules.Pray(config,8,1,10);near(healing,1);near(spent,.12)
local hp,heal,speed=Rules.LMS(config,4);near(hp,95);near(heal,25);near(speed,3)
-- Actual transforms: behind and facing the same way works; front or facing away does not.
assert(Rules.Backstab(Vector3.new(0,0,2),Vector3.new(0,0,-1),Vector3.new(0,0,0),Vector3.new(0,0,-1),config))
assert(not Rules.Backstab(Vector3.new(0,0,-2),Vector3.new(0,0,1),Vector3.new(0,0,0),Vector3.new(0,0,-1),config))
-- Server Dagger: windup, standing backstab, no healing, no lifesteal, bounded meter.
local a=actor();a.Rig.Humanoid.Health=40
local result=Server.Dagger(a);assert(result and not result.Crouched)
advance(.299);assert(Hitboxes.last==nil)
advance(.002);assert(Hitboxes.last)
assert(Hitboxes.last.PredictVelocity==nil and Hitboxes.last.CFrame==nil and Hitboxes.last.CFrameOffset)
near(config.DaggerHitboxOffset,7)
near(config.DaggerHitboxSize.Z,5.5)
local victim=rig(Vector3.new(0,0,-2));victim.Humanoid.Health=100
Hitboxes.last.Connections.Hit(victim)
near(victim.Humanoid.Health,80);near(a.Blood,3.2);near(a.Rig.Humanoid.Health,40)
local found=false
for _,s in Statuses.applied do if s.target==victim and s.name=='Stunned' then near(s.data.Duration,2);found=true end end
assert(found)
advance(2);assert(not a.TTAttacking and not a.AbilityDisablers.TwoTimePortDagger)
-- Crouched backstab captures charge at activation; interruption cancels stale windup.
a=actor();Server.Crouch(a);advance(.5)
result=Server.Dagger(a);assert(result.Crouched)
advance(.301);victim=rig(Vector3.new(0,0,-2));victim.Humanoid.Health=100
Hitboxes.last.Connections.Hit(victim);near(a.Blood,4)
near(Statuses.applied[#Statuses.applied].data.Duration,2.75)
advance(2)
a=actor();Server.Dagger(a);local count=Hitboxes.count
Server.Interrupt(a);advance(1);near(Hitboxes.count,count)
assert(not a.AbilityDisablers.TwoTimePortDagger)
-- Immunity and summons: damage is allowed, meter is not.
a=actor();Server.Dagger(a);advance(.301)
victim=rig(Vector3.new(0,0,-2));victim.attrs.StunnedDisabled=true
Hitboxes.last.Connections.Hit(victim);near(a.Blood,0)
advance(2)
a=actor();Server.Dagger(a);advance(.301)
victim=rig(Vector3.new(0,0,-2));victim.attrs.IsMinion=true
Hitboxes.last.Connections.Hit(victim);near(a.Blood,0)
advance(2)
-- Miss endlag and penalty release both locks even with no animation callbacks.
a=actor();Server.Crouch(a);advance(1);Server.Dagger(a);advance(2)
assert(not a.TTAttacking and not a.AbilityDisablers.TwoTimePortDagger)
assert(not a.AbilityDisablers.TwoTimePortDagger) -- No killer means no miss penalty.
-- Pray consumes a full meter, locks movement, refuses full-health and out-of-range healing.
a=actor();a.Blood=8;a.Rig.Humanoid.Health=30
local ritual={Parent=true,Position=Vector3.new(0,0,0),FindFirstChild=function()return nil end,Destroy=function(self)self.Parent=nil end,CFrame=Vector3.new(0,0,0)}
a.RespawnLocation=ritual
assert(Server.Pray(a).Started);assert(a.AbilityDisablers.TwoTimePortPray)
Server.StopPray(a,false);assert(not a.AbilityDisablers.TwoTimePortPray)
a.Rig.Humanoid.Health=80;assert(Server.Pray(a).Cancelled)
a.Rig.Humanoid.Health=30;ritual.Position=Vector3.new(11,0,0);assert(Server.Pray(a).Locate);near(a.Blood,8)
ritual.Position=Vector3.new(0,0,0);Server.Pray(a)
Server.OnHit(a,{},5,false);assert(not a.TTPraying);near(a.cooldowns.Pray,6)
-- Lethal damage revives even if this is the only survivor, exactly once.
a=actor();a.Blood=8;a.RespawnLocation=ritual;a.Rig.Humanoid.Health=10
local hit={TimePast=0};assert(Server.OnHit(a,hit,20,false)=='Ignored')
near(hit.TimePast,9999);near(a.Rig.Humanoid.Health,50);near(a.Rig.Humanoid.MaxHealth,50)
assert(a.teleported and a.appearance==2);near(a.Blood,0);near(a.Rig.invincibility,2)
local vulnerable=false
for _,s in Statuses.applied do if s.target==a.Player and s.name=='Vulnerable' then vulnerable=true;near(s.data.Level,5);near(s.data.Duration,12)end end
assert(vulnerable)
hit={TimePast=0};assert(Server.OnHit(a,hit,100,false)==nil);near(hit.TimePast,0)
-- A full bar without a placed Ritual cannot prevent death.
a=actor();a.Blood=8;hit={TimePast=0};assert(Server.OnHit(a,hit,100,false)==nil);near(hit.TimePast,0)
-- Explicit LMS hook has proportional health, no teleport and no Vulnerable.
a=actor();a.Blood=4;a.Rig.Humanoid.Health=40
local statusStart=#Statuses.applied
Server.OnHit(a,{},0,true);near(a.Rig.Humanoid.MaxHealth,95);near(a.Rig.Humanoid.Health,65);assert(not a.teleported)
for i=statusStart+1,#Statuses.applied do assert(Statuses.applied[i].name~='Vulnerable')end
-- Crouch cleanup preserves somebody else's ability lock and previous footstep state.
a=actor();a.AbilityDisablers.Stunned=true;a.Rig.attrs.FootstepsMuted='existing'
Server.Crouch(a);advance(2);Server.StopCrouch(a,false)
assert(a.AbilityDisablers.Stunned);assert(a.Rig.attrs.FootstepsMuted=='existing');near(a.cooldowns.Crouch,28)
-- Heartbeat integration: actual held-input lease, healing, approach ramp and cleanup.
local function spawned()
 local a=actor()
 a.Config.DaggerTemplate={Clone=function()
  local clone=object()
  function clone:FindFirstChildOfClass()return {}end
  function clone:GetDescendants()return {}end
  return clone
 end}
 Server.Created(a)
 return a
end
local function tickActor(dt)
 advance(dt);heartbeat:Fire(dt)
end
a=spawned();a.Blood=8;a.Rig.Humanoid.Health=1
ritual.Parent=true;ritual.Position=Vector3.new(0,0,0);a.RespawnLocation=ritual
assert(Server.Pray(a).Started)
local remote=Network.callbacks['TwoTimePortHold_12']
remote({UserId=999},false);assert(a.TTPraying,'other players cannot release our held action')
for _=1,40 do remote(a.Player,true);tickActor(.25)end
near(a.Blood,0);near(a.Rig.Humanoid.Health,67.66666666666667)
assert(not a.TTPraying and not a.AbilityDisablers.TwoTimePortPray)
a.Blood=8;a.Rig.Humanoid.Health=1;Server.Pray(a)
tickActor(1.3);assert(not a.TTPraying,'lost input/focus must release without trusting the client')
Server.Destroyed(a);assert(Network.callbacks['TwoTimePortHold_12']==nil)
a=spawned();a.Blood=8;a.Rig.Humanoid.Health=79;ritual.Parent=true;a.RespawnLocation=ritual
Server.Pray(a);remote=Network.callbacks['TwoTimePortHold_12'];remote(a.Player,true);tickActor(.25)
near(a.Rig.Humanoid.Health,80);near(a.Blood,7.88);assert(not a.TTPraying)
Server.Destroyed(a)
local target=rig(Vector3.new(0,0,-30))
local killers={GetChildren=function()return {target}end}
workspace.FindFirstChild=function(_,key)
 if key=='Players' then return {FindFirstChild=function(_,name)if name=='Killers' then return killers end end}end
end
a=spawned();Server.Crouch(a)
a.Rig.PrimaryPart.AssemblyLinearVelocity=Vector3.new(0,0,-23)
for _=1,16 do tickActor(.25)end
near(a.Rig.attrs.TwoTimeCrouchBonus,1.5)
a.Rig.PrimaryPart.AssemblyLinearVelocity=Vector3.new(23,0,0);tickActor(.1)
near(a.Rig.attrs.TwoTimeCrouchBonus,1)
a.Rig.PrimaryPart.AssemblyLinearVelocity=Vector3.new(0,0,-23);tickActor(.5)
assert(a.Rig.attrs.TwoTimeCrouchBonus>1)
a.Rig.attrs.Stunned=true;tickActor(.1)
assert(not a.TTCrouchStart and a.Rig.attrs.TwoTimeCrouchBonus==nil)
a.Rig.attrs.Stunned=nil;Server.Destroyed(a)
print('Two Time rules + server callbacks + heartbeat/hold integration passed')
