local Actors={CurrentActors={}}
local Rules=(function()
-- Corrected Helperbot moveset. Pure rules shared by the server and regression tests.
local Rules={}
function Rules.Level(charges) return math.clamp(math.floor(tonumber(charges) or 0),0,3) end
function Rules.Radius(charges) return ({30,33,36,39})[Rules.Level(charges)+1] end
function Rules.BuffDuration(charges,additionalHelpers,otherHelper)
 local duration=math.max(3,4+Rules.Level(charges)-1.5*math.max(0,additionalHelpers))
 return duration*(otherHelper and .5 or 1)
end
function Rules.Haste(additionalHelpers) return math.max(1,5-math.max(0,additionalHelpers)) end
function Rules.CooldownDelta(dt,level,support) return dt*.1*level*(support and .5 or 1) end
function Rules.Progress(progress,inside,dt) return math.clamp(progress+(inside and dt or -dt*.7),0,5) end
return Rules

end)()
local modules={Actors=Actors}
local isServer=true
local game={ReplicatedStorage={Modules=modules,Assets={Survivors={Helperbot={Behavior={Rules=Rules}}}}}}
function game:GetService()return {IsServer=function()return isServer end}end
local require=function(m)return m end
local Status=(function()
-- Server-only cooldown recovery adjustment; clients receive FCT's ordinary cooldown updates.
local RunService=game:GetService("RunService")
local Actors=require(game.ReplicatedStorage.Modules.Actors)
local Rules=require(game.ReplicatedStorage.Assets.Survivors.Helperbot.Behavior.Rules)
local Status={}
function Status.Tick(effect,dt,direction)
 if not RunService:IsServer() then return end
 local actor=Actors.CurrentActors[effect.Player]
 if not actor then for _,candidate in pairs(Actors.CurrentActors) do if candidate.Rig==effect.Character then actor=candidate;break end end end
 if not actor or not actor.Cooldowns or not actor.SetCooldownOf then return end
 local hum=actor.Rig and actor.Rig:FindFirstChildOfClass("Humanoid")
 if not hum or hum.Health<=0 then return end
 effect.HelperAccumulator=(effect.HelperAccumulator or 0)+dt
 if effect.HelperAccumulator<.1 then return end
 local elapsed=effect.HelperAccumulator;effect.HelperAccumulator=0
 local delta=Rules.CooldownDelta(elapsed,math.max(1,effect.Level or 1),direction<0 and actor.Config and actor.Config.Class=="Support")*direction
 for name,ability in pairs(actor.Behavior and actor.Behavior.Abilities or {}) do
  if (direction<0 or ability.KeybindType~="MainAbility") and not table.find(effect.Data.DisabledAbilityNames or {},name) then
   local remaining=actor:IsOnCooldown(name)
   if type(remaining)=="number" and remaining>0 then actor:SetCooldownOf(name,math.max(0,remaining+delta)) end
  end
 end
end
return Status

end)()
local function actor(support)
 local a={Player={},Rig={FindFirstChildOfClass=function()return {Health=80}end},Config={Class=support and "Support" or "Sentinel"},Cooldowns={},Behavior={Abilities={Pulse={KeybindType="AltAbility1"},Inspiration={KeybindType="AltAbility2"},M1={KeybindType="MainAbility"}}},remaining={Pulse=10,Inspiration=10,M1=10}}
 function a:IsOnCooldown(name)return self.remaining[name]end
 function a:SetCooldownOf(name,v)self.remaining[name]=v end
 Actors.CurrentActors[a.Player]=a
 return a
end
local a=actor(false)
local effect={Player=a.Player,Character=a.Rig,Level=5,Data={DisabledAbilityNames={"Inspiration"}}}
Status.Tick(effect,1,-1)
assert(a.remaining.Pulse==9.5 and a.remaining.Inspiration==10 and a.remaining.M1==9.5)
local b=actor(true);effect={Player=b.Player,Character=b.Rig,Level=5,Data={DisabledAbilityNames={"Inspiration"}}}
Status.Tick(effect,1,-1)
assert(b.remaining.Pulse==9.75 and b.remaining.Inspiration==10)
effect.Level=4;Status.Tick(effect,1,1);assert(math.abs(b.remaining.Pulse-10.15)<.00001,"Fatigue was incorrectly halved for support")
b.remaining.Pulse=.1;effect.Level=5;Status.Tick(effect,1,-1);assert(b.remaining.Pulse==0)
isServer=false;b.remaining.Pulse=10;Status.Tick(effect,1,-1);assert(b.remaining.Pulse==10)
print("PASS Haste/Fatigue: 50% acceleration, 25% support acceleration, exclusion, Fatigue primary attack exclusion, fatigue, zero clamp, client authority")
