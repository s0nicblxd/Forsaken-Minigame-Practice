-- Server-authoritative recovery corrections preserve client cooldown progress.
local RunService=game:GetService("RunService")
local Actors=require(game.ReplicatedStorage.Modules.Actors)
local Rules=require(game.ReplicatedStorage.Assets.Survivors.Helperbot.Behavior.Rules)
local Network=require(game.ReplicatedStorage.Modules.Network)
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
   if type(remaining)=="number" and remaining>0 then
    local adjusted=math.max(0,remaining+delta)
    actor.Cooldowns[name]=adjusted>0 and workspace:GetServerTimeNow()+adjusted or nil
    if actor.Player then
     Network:FireClientConnection(actor.Player,"UpdateAbilityCooldown","REMOTE_EVENT",name,adjusted,true)
    end
   end
  end
 end
end
return Status
