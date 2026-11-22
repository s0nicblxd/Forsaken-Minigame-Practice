-- John-specific Unstoppable windows. Never changes other actors' status durations.
local RunService=game:GetService("RunService")
local Actors=require(game.ReplicatedStorage.Modules.Actors)
local Statuses=require(game.ReplicatedStorage.Modules.Statuses)
local Network=require(game.ReplicatedStorage.Modules.Network)
local Controller={}
local legacyNegative={Glitched=true,Glitch=true,GlitchedOld=true,Slowness=true,Bleeding=true,Burning=true,Nausea=true,Blindness=true,Oblivious=true,Poisoned=true,PoisonedThatKillsYou=true,Helpless=true,Weakness=true,Vulnerable=true,Confusion=true,Hemmorhage=true,Hacked=true,Corrupted=true,Hallucination=true,Marked=true,Resonance=true,Atropa=true,Subspaced=true,Fatigue=true,Exhausted=true,Stunned=true,Creatures=true}
local function alive(a)
 local hum=a.Rig and a.Rig:FindFirstChildOfClass("Humanoid")
 return not a.JDUnstoppableDestroyed and a.Rig and a.Rig.Parent and hum and hum.Health>0
end
local function speed(a) return Statuses:PlayerHasStatus(a.Player,"Speed") end
local function sentinelCount()
 local n,seen=0,{}
 for _,actor in pairs(Actors.CurrentActors) do
  local rig=actor.Rig;local hum=rig and rig:FindFirstChildOfClass("Humanoid")
  if actor.Config and actor.Config.Class=="Sentinel" and rig and rig.Parent and rig.Parent.Name~="Spectating" and hum and hum.Health>0 and not seen[rig] then n+=1;seen[rig]=true end
 end
 return n
end
function Controller.BeginCorrupt(a)
 if a.JDUnstoppableDestroyed then return end
 a.JDCorruptCasting=true;a.JDCorruptWindowUntil=nil
end
function Controller.EndCorrupt(a,cancelled)
 a.JDCorruptCasting=nil
 if a.JDUnstoppableDestroyed then a.JDCorruptWindowUntil=nil;return end
 a.JDCorruptWindowUntil=not cancelled and os.clock()+(a.Config.CorruptEnergyUnstoppableLinger or 1.5) or nil
end
function Controller.GetOverride(a)
 if not alive(a) then return end
 local ability
 if a.CurrentAbility=="404Error" and a.Config.StunDuration then ability="404Error"
 elseif a.JDCorruptCasting or os.clock()<(a.JDCorruptWindowUntil or 0) then ability="CorruptEnergy" end
 a.JDUnstoppableTriggerAbility=ability
 if ability then return a.Config.UnstoppableDuration or 2 end
end
function Controller.OnStunned(a,override)
 local ability=a.JDUnstoppableTriggerAbility;a.JDUnstoppableTriggerAbility=nil
 if not override or not ability or not alive(a) then return end
 a.JDUnstoppablePending=true
 local remaining=a:IsOnCooldown(ability)
 local base=a.Config[ability.."Cooldown"]
 if type(remaining)=="number" and type(base)=="number" then a:SetCooldownOf(ability,math.min(remaining,base*.5)) end
end
local function ensureSpeed(a,remaining)
 local current=speed(a)
 if not current then
  Statuses:ApplyStatus(a.Player,"Speed",{Level=1,Duration=remaining,AppliedFrom="JohnDoeUnstoppable"})
 elseif (current.Level or 1)==1 then
  -- Preserve a longer existing Speed I; extend a shorter one without shortening its remainder.
  local oldRemaining=math.max(0,(current.TimeRequired or current.Data.Duration or 0)-(current.TimePast or 0))
  if oldRemaining<remaining then
   current.TimeRequired=(current.TimePast or 0)+remaining;current.Data.Duration=current.TimeRequired
   Network:FireClientConnection(a.Player,"StatusUpdated","REMOTE_EVENT","Speed",{TimePast=current.TimePast or 0,Level=current.Level,Duration=current.TimeRequired})
  end
 end
end
function Controller.Boost(a)
 if not a.JDUnstoppablePending then return false end
 a.JDUnstoppablePending=nil
 if not alive(a) then return true end
 local duration=(a.Config.UnstoppableSpeedBoostDuration or 3)+sentinelCount()
 a.JDUnstoppableProtectionUntil=os.clock()+duration
 ensureSpeed(a,duration)
 return true
end
function Controller.DurationMultiplier(a,name,data)
 if not alive(a) or os.clock()>=(a.JDUnstoppableProtectionUntil or 0) or not speed(a) then return 1 end
 local negative=data and data.IsNegative
 if negative==nil then negative=legacyNegative[name] end
 return negative and (a.Config.UnstoppableNegativeStatusDurationMultiplier or .5) or 1
end
function Controller.Created(a)
 if not RunService:IsServer() then return end
 a.JDUnstoppableDestroyed=false
 a.JDUnstoppableHeartbeat=RunService.Heartbeat:Connect(function()
  local remaining=(a.JDUnstoppableProtectionUntil or 0)-os.clock()
  if remaining>0 and alive(a) then ensureSpeed(a,remaining)
  elseif remaining<=0 then a.JDUnstoppableProtectionUntil=nil end
 end)
end
function Controller.Destroyed(a)
 a.JDUnstoppableDestroyed=true
 if a.JDUnstoppableHeartbeat then a.JDUnstoppableHeartbeat:Disconnect();a.JDUnstoppableHeartbeat=nil end
 a.JDCorruptCasting=nil;a.JDCorruptWindowUntil=nil;a.JDUnstoppableProtectionUntil=nil;a.JDUnstoppablePending=nil;a.JDUnstoppableTriggerAbility=nil
end
return Controller
