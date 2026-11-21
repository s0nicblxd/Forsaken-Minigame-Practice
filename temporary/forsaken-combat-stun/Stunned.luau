-- FCT lifecycle + UPD immunity timing. Existing combat damage behavior is preserved.
local RunService=game:GetService("RunService")
local Modules=game.ReplicatedStorage.Modules
local Actors=require(Modules.Actors)
local Util=require(Modules.Util)
local Rules=require(script.Rules)
local Stunned={Data={Duration=6,MaxLevel=1,IsNegative=true,Stackable=false,TimeStackable=false,Hidden=false}}
local function actorFor(status)
 return Actors.CurrentActors[status.Player] or Actors.CurrentActors[status.Character]
end
local function sound(actor,name)
 local id=actor and actor.Config and actor.Config.Sounds and actor.Config.Sounds[name]
 if id and actor.Rig and actor.Rig.PrimaryPart then require(Modules.Sounds):Play(id,{Parent=actor.Rig.PrimaryPart}) end
end
local function cancelOverride(status)
 local thread=status.UnstunThread;status.UnstunThread=nil
 if thread and thread~=coroutine.running() then pcall(task.cancel,thread) end
end
function Stunned.Applied(status)
 if RunService:IsClient() then
  local actor=actorFor(status)
  local animation=actor and actor.Animations and actor.Animations.Stunned
  local behavior=actor and actor.Behavior
  if behavior then
   local callback=status.Data.StunDuration and type(animation)=="table" and animation.Cancel and behavior.OnStunnedEnd or behavior.OnStunned
   if callback then callback(behavior,actor,status.Data.StunDuration) end
  end
  if animation then
   if typeof(animation)=="table" then
    if status.Data.StunDuration and animation.Cancel then animation.Cancel:Play(0)
    else
     if animation.Start then animation.Start:Play(0) end
     if animation.Loop then animation.Loop:Play(0) end
     status.StunnedAnims=animation
    end
   else animation:Play(0) end
  end
  if not status.SpeedMultiplier then status.SpeedMultiplier=Util:CreateSpeedMultiplier(status.Player,0,"Stunned") end
  return
 end
 local character=status.Character
 Util:GiveStackableAttribute(character,"StunnedDisabled","StunPort")
 character:SetAttribute("Stunned",true)
 local actor=actorFor(status)
 if not actor then return end
 actor:DisableAbilities("Stunned",true)
 if actor.Behavior.OnStunned then actor.Behavior:OnStunned(actor,status.Data.StunDuration) end
 require(Modules.Sounds):PlayVoiceline(actor,"Stunned")
 sound(actor,"Stunned")
 local override=tonumber(actor.Config.StunDuration)
 if override and override>0 then
  cancelOverride(status)
  status.UnstunThread=task.delay(override,function()
   status.UnstunThread=nil
   if not character.Parent or not character:GetAttribute("Stunned") then return end
   local statuses=require(Modules.Statuses)
   statuses:RemoveStatus(status.Player,"Stunned")
   if not statuses:PlayerHasStatus(status.Player,"Speed") then statuses:ApplyStatus(status.Player,"Speed",{Level=1,Duration=3+Rules.CountSentinels(Actors.CurrentActors)}) end
   sound(actor,"StunEnded")
   if actor.Behavior.OnStunnedEnd then actor.Behavior:OnStunnedEnd(actor) end
  end)
  status.Data.StunDuration=override
 end
end
function Stunned.Removed(status)
 cancelOverride(status)
 if status.SpeedMultiplier then
  local multiplier=status.SpeedMultiplier;status.SpeedMultiplier=nil
  task.delay(status.StunnedAnims and status.StunnedAnims.End and .6 or .25,function()
   if multiplier.Parent then
    game.TweenService:Create(multiplier,TweenInfo.new(.75),{Value=1}):Play()
    game.Debris:AddItem(multiplier,.75)
   end
  end)
 end
 if status.StunnedAnims then
  for _,name in {"Start","Loop"} do if status.StunnedAnims[name] then status.StunnedAnims[name]:Stop() end end
  if status.StunnedAnims.End then status.StunnedAnims.End:Play() end
  status.StunnedAnims=nil
 end
 if RunService:IsServer() then
  local character=status.Character
  character:SetAttribute("Stunned",nil)
  local duration=Rules.Duration(Rules.CountSentinels(Actors.CurrentActors),status.Data.ResonanceDuration)
  -- Replacing this named source cancels the old timer; unrelated immunity sources survive expiry.
  local humanoid=character:FindFirstChildOfClass("Humanoid")
  if character.Parent and humanoid and humanoid.Health>0 then Util:GiveStackableAttribute(character,"StunnedDisabled","StunPort",duration)
  else Util:RemoveStackableAttribute(character,"StunnedDisabled","StunPort") end
  local actor=actorFor(status)
  if actor then actor:DisableAbilities("Stunned",false) end
 end
end
function Stunned.Heartbeat() end
return Stunned
