local t1={}
local warnings={}
local reason
local t2={collision="blocked",unknown="unknown"}
local PlacementPreview={Check=function()return reason end}
local delayed={}
local task={delay=function(time,callback)table.insert(delayed,callback)end,spawn=function(callback)callback()end,wait=function()error("unexpected unbounded wait")end}
local Vector3={new=function(x,y,z)return {X=x,Y=y,Z=z}end}
local multiplier
local Util={CreateSpeedMultiplier=function(_,rig,value,name)
 multiplier={Value=value,Name=name,Destroy=function(self)self.Destroyed=true end};return multiplier
end,CreateProgressBar=function()return {Destroy=function()end}end,CreateWarning=function(_,id,text)table.insert(warnings,text)end}
local function getBuildingRecentActivityRemaining()return 0 end
local function safeAnimation()end
local hum={Health=90,Move=function(self,direction)self.LastMove=direction end}
local frame={Name="click-time pose"}
local root={CFrame=frame,Anchored=false,AssemblyLinearVelocity=Vector3.new(12,2,-10)}
local rig={PrimaryPart=root,Parent=true,GetAttribute=function()return nil end,FindFirstChildOfClass=function()return hum end,FindFirstChild=function()return {}end}
local actor={Rig=rig,Config={SentryConstructionDuration=6,DispenserConstructionDuration=6,Instances={}}}
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
 local reason=PlacementPreview.Check(actor,kind,frame)
 if reason then
  Util:CreateWarning("BuildermanWarning",t2[reason]or t2.unknown,actor.Config.Instances.WarningTemplate)
  return false
 end
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

local snapshot=t1.BeforeAbilityRequest(actor,"Sentry")
assert(snapshot==frame and actor.BuilderInputFreeze.Value==0 and actor.BuilderInputPending)
assert(root.AssemblyLinearVelocity.X==0 and root.AssemblyLinearVelocity.Z==0 and root.AssemblyLinearVelocity.Y==2)
assert(hum.LastMove.X==0 and hum.LastMove.Z==0)
assert(t1.BeforeAbilityRequest(actor,"Dispenser")==false,"duplicate cast allowed during pending request")
for _,callback in delayed do callback()end
assert(not actor.BuilderInputFreeze and not actor.BuilderInputPending and multiplier.Destroyed,"ignored request left movement frozen")
actor.Cooldowns={Sentry={Duration=35,TimePast=1}}
assert(t1.BeforeAbilityRequest(actor,"Sentry")==false and not actor.BuilderInputFreeze)
assert(t1.BeforeAbilityRequest(actor,"Move")==nil)
actor.Cooldowns=nil;delayed={}
assert(t1.BeforeAbilityRequest(actor,"Dispenser")==frame)
constructBuildingOnClient(actor,"Dispenser",{Duration=6})
assert(not actor.BuilderInputFreeze and not actor.BuilderInputPending,"successful construction did not release predicted freeze")
print("PASS click-time input freeze: immediate zero multiplier/horizontal stop, captured pose, repeat/cooldown guards, unrelated-slot pass-through, ignored-request timeout and completion cleanup")

reason="collision"
root.AssemblyLinearVelocity=Vector3.new(8,0,3);hum.LastMove=nil
assert(t1.BeforeAbilityRequest(actor,"Sentry")==false)
assert(not actor.BuilderInputFreeze and not actor.BuilderInputPending)
assert(root.AssemblyLinearVelocity.X==8 and root.AssemblyLinearVelocity.Z==3 and hum.LastMove==nil,"invalid placement stopped movement")
assert(warnings[#warnings]=="blocked")
print("PASS invalid placement: warning only, no input freeze, no horizontal velocity change and no movement command; valid/timeout behavior retained")
