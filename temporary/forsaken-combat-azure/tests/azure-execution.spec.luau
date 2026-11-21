
local now=0
local timers={}
local task={delay=function(delay,fn)table.insert(timers,{at=now+delay,fn=fn})end}
local function advance(dt)
 local untilTime=now+dt
 while true do
  local index,item
  for i,t in ipairs(timers)do if t.at<=untilTime and(not item or t.at<item.at)then index,item=i,t end end
  if not item then break end
  table.remove(timers,index);now=item.at;item.fn()
 end
 now=untilTime
end
local tween={Create=function(_,image,_,values)return {Play=function()for k,v in pairs(values)do image[k]=v end end}end}
local ragdolls={profiles={}}
function ragdolls.AddProfile(victim,profile)table.insert(ragdolls.profiles,{victim=victim,profile=profile})end
local debris={AddItem=function(_,object,delay)task.delay(delay,function()object:Destroy()end)end}
local game={ReplicatedStorage={Modules={Ragdolls=ragdolls}}}
function game:GetService(name)if name=="TweenService"then return tween elseif name=="Debris"then return debris end end
local require=function(m)return m end
local Vector3={new=function(x,y,z)return {x=x,y=y,z=z}end}
local TweenInfo={new=function()return {}end}
local Enum={EasingStyle={Quart=true},EasingDirection={InOut=true,In=true}}
local Execution=(function()
-- Preserve Azure's execution timings; cosmetics must not be required for a kill.
local TweenService=game:GetService("TweenService")
local Debris=game:GetService("Debris")
local Ragdolls=require(game.ReplicatedStorage.Modules.Ragdolls)
local Execution={}
local function exists(victim)
 return victim and victim.Parent~=nil
end
local function finish(victim,profile)
 if not exists(victim) then return end
 -- A despawned/missing root cannot receive a ragdoll impulse, but should not prevent death.
 if victim.PrimaryPart then
  local ok,err=pcall(Ragdolls.AddProfile,victim,profile)
  if not ok then warn("[Azure execution] Optional ragdoll profile failed: "..tostring(err)) end
 end
 local hum=victim:FindFirstChildOfClass("Humanoid")
 if hum then hum.BreakJointsOnDeath=false;hum.Health=0 end
end
local function vignette(actor)
 local template=actor.Config and actor.Config.Instances and actor.Config.Instances.MassInfectionShockwaveVignette
 local gui=actor.Player and actor.Player:FindFirstChildOfClass("PlayerGui")
 if not template or not gui then return end
 local clone=template:Clone()
 local image=clone:FindFirstChildWhichIsA("ImageLabel",true)
 if not image then clone:Destroy();return end
 clone.Name="AZUREQUICKSHINE1";image.ImageTransparency=1;clone.Parent=gui
 Debris:AddItem(clone,4)
 return clone,image
end
local function flash(image,duration)
 if not image or not image.Parent then return end
 image.ImageTransparency=1
 TweenService:Create(image,TweenInfo.new(.1,Enum.EasingStyle.Quart,Enum.EasingDirection.InOut),{ImageTransparency=.9}):Play()
 task.delay(.2,function()
  if image.Parent then TweenService:Create(image,TweenInfo.new(duration,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{ImageTransparency=1}):Play() end
 end)
end
function Execution.Run(actor,victim)
 if not exists(victim) then return end
 if victim.Name~="TwoTime" then
  local root=actor.Rig and actor.Rig.PrimaryPart
  local velocity=root and root.CFrame.LookVector*33 or Vector3.new(0,0,0)
  task.delay(2.783333333333333,function()finish(victim,{Velocity=velocity,KillEffects={Explode=true}})end)
  return
 end
 local gui,image=vignette(actor)
 -- Two Time's new rig may omit or move the legacy dagger. It is only a cosmetic.
 local blade=victim:FindFirstChild("GhostfireBlade",true)
 if blade and blade:IsA("BasePart") then blade.Transparency=0 end
 task.delay(1.3333333333333333,function()
  if exists(victim) then flash(image,.5) elseif gui and gui.Parent then gui:Destroy() end
 end)
 task.delay(2.65,function()
  if not exists(victim) then if gui and gui.Parent then gui:Destroy() end;return end
  flash(image,.75)
  local hum=victim:FindFirstChildOfClass("Humanoid")
  -- Do not revive an already-dead humanoid if another combat event killed it first.
  if hum and hum.Health>0 then hum.Health=.01 end
 end)
 task.delay(3.216666666666667,function()
  finish(victim,{Velocity=Vector3.new(0,0,0)})
 end)
end
return Execution

end)()
local function victim(name,blade)
 local hum={Health=80}
 local rig={Name=name,Parent=true,PrimaryPart={}}
 function rig:FindFirstChild(name,recursive)assert(recursive==true);return blade end
 function rig:FindFirstChildOfClass()return hum end
 return rig,hum
end
-- Exact regression: Two Time has no GhostFire and no effect/GUI assets at all.
local v,h=victim("TwoTime")
Execution.Run({},v)
advance(2.65);assert(h.Health==.01)
advance(.57);assert(h.Health==0 and h.BreakJointsOnDeath==false)
-- Present legacy blade still receives its cosmetic reveal; optional GUI can be nested.
local blade={Transparency=1,IsA=function()return true end}
local image={ImageTransparency=0,Parent=true}
local gui={Parent=true,Destroy=function(self)self.Parent=nil;image.Parent=nil end,FindFirstChildWhichIsA=function()return image end}
local template={Clone=function()return gui end}
local actor={Config={Instances={MassInfectionShockwaveVignette=template}},Player={FindFirstChildOfClass=function()return {}end}}
v,h=victim("TwoTime",blade)
Execution.Run(actor,v);assert(blade.Transparency==0 and image.ImageTransparency==1)
advance(1.334);assert(image.ImageTransparency==.9)
advance(.21);assert(image.ImageTransparency==1)
-- Victim deleted mid-execution: delayed callbacks do not index a missing rig or kill a replacement.
v.Parent=nil;local old=h.Health;advance(3);assert(h.Health==old and gui.Parent==nil)
-- An already-dead victim must not be brought back to .01 health.
v,h=victim("TwoTime");Execution.Run({},v);h.Health=0;advance(2.65);assert(h.Health==0);advance(1)
-- Non-Two Time path retains its timing and explode profile, even when killer root is absent.
v,h=victim("Noob");Execution.Run({},v);advance(2.78);assert(h.Health==80);advance(.01)
assert(h.Health==0 and ragdolls.profiles[#ragdolls.profiles].profile.KillEffects.Explode)
-- Invalid callback arguments are a no-op, not an exception.
Execution.Run({},nil)
print("PASS Azure execution: missing dagger/GUI, optional legacy cosmetics, deleted victim, already-dead victim, original generic timing and explode profile, missing killer root")
