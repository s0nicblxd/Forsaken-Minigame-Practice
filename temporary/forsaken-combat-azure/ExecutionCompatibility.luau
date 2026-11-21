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
