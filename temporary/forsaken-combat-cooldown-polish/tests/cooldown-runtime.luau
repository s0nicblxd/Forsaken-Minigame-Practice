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
local isServer=true
local now=10
local workspace={GetAttribute=function()return false end,GetServerTimeNow=function()return now end}
local callbacks={}
local LocalPlayer={}
local client={CustomBehavior={Abilities={}},Behavior={Abilities={Pulse={}}},Cooldowns={Pulse={Duration=40,TimePast=10}}}
local clientActors={CurrentActors={[LocalPlayer]=client}}
local Network={SetConnection=function(_,name,_,f)callbacks[name]=f end}
local function register()
 local Actors=clientActors
Network:SetConnection("UpdateAbilityCooldown", "REMOTE_EVENT", function(p21, p22, preserveProgress) -- line: 994
		-- upvalues: Actors (copy), LocalPlayer (copy)
		if workspace:GetAttribute("CooldownsDisabled") then
			return
		end

		local v41 = Actors.CurrentActors[LocalPlayer]

		if not v41 then
			return
		end

		local v42 = v41.CustomBehavior.Abilities or {}
		local v43 = v41.Behavior.Abilities or {}

		if (v42[p21] or v43[p21]) and v41.Cooldowns then
			if p22 < 0 then
				if v41.Cooldowns[p21] then
					local v44 = v41.Cooldowns[p21]

					v44.TimePast = v44.TimePast + math.abs(p22)

					return
				end
            elseif preserveProgress and v41.Cooldowns[p21] then
                local cooldown=v41.Cooldowns[p21]
                cooldown.Duration=math.max(cooldown.Duration,p22)
                cooldown.TimePast=math.max(0,cooldown.Duration-p22)
            else
                v41.Cooldowns[p21] = {TimePast=0,Duration=p22}
            end
		end
	end)
end
register()
local calls=0
function Network:FireClientConnection(player,event,kind,name,remaining,preserve)
 calls+=1;assert(player==LocalPlayer and preserve==true)
 callbacks[event](name,remaining,preserve)
end
local game={ReplicatedStorage={Modules={Actors=Actors,Network=Network},Assets={Survivors={Helperbot={Behavior={Rules=Rules}}}}}}
function game:GetService()return {IsServer=function()return isServer end}end
local require=function(module)return module end
local Status=(function()
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

end)()
local server={Player=LocalPlayer,Rig={FindFirstChildOfClass=function()return {Health=100}end},Config={Class="Sentinel"},Cooldowns={Pulse=40,Inspiration=40},Behavior={Abilities={Pulse={},Inspiration={}}}}
function server:IsOnCooldown(name)local t=self.Cooldowns[name];return t and t>now and t-now or false end
function server:SetCooldownOf()error("must not restart cooldown on status recovery")end
Actors.CurrentActors[LocalPlayer]=server
local effect={Player=LocalPlayer,Level=5,Data={DisabledAbilityNames={"Inspiration"}}}
local last=client.Cooldowns.Pulse.TimePast
for i=1,20 do
 now+=.1;client.Cooldowns.Pulse.TimePast+=.1
 Status.Tick(effect,.1,-1)
 assert(client.Cooldowns.Pulse.Duration==40,"original duration reset")
 assert(client.Cooldowns.Pulse.TimePast>last,"icon recovery jumped backwards")
 last=client.Cooldowns.Pulse.TimePast
end
assert(math.abs(client.Cooldowns.Pulse.TimePast-13)<.00001,"expected 1.5x total recovery")
assert(server.Cooldowns.Inspiration==40,"excluded ability affected")
assert(calls==20)
server.Config.Class="Support";now=10;server.Cooldowns.Pulse=40
Status.Tick(effect,1,-1)
assert(math.abs(server.Cooldowns.Pulse-39.75)<.00001,"support Haste must be halved")
server.Cooldowns.Pulse=40
Status.Tick(effect,1,1)
assert(math.abs(server.Cooldowns.Pulse-40.5)<.00001,"Fatigue incorrectly halved")
server.Cooldowns.Pulse=now+.01
Status.Tick(effect,1,-1)
assert(server.Cooldowns.Pulse==nil and client.Cooldowns.Pulse.TimePast==client.Cooldowns.Pulse.Duration)
isServer=false;server.Cooldowns.Pulse=40;local before=calls
Status.Tick(effect,1,-1);assert(server.Cooldowns.Pulse==40 and calls==before)
callbacks.UpdateAbilityCooldown("Pulse",12)
assert(client.Cooldowns.Pulse.Duration==12 and client.Cooldowns.Pulse.TimePast==0,"ordinary new cooldown no longer resets")
callbacks.UpdateAbilityCooldown("Pulse",-3)
assert(client.Cooldowns.Pulse.TimePast==3,"native delta update changed")
callbacks.UpdateAbilityCooldown("Pulse",15,true)
assert(client.Cooldowns.Pulse.Duration==15 and client.Cooldowns.Pulse.TimePast==0)
print("PASS integrated server/client recovery: continuous fill, 1.5x Haste, half-strength Support, Fatigue, exclusions, expiry and native cooldown reset/delta compatibility")
