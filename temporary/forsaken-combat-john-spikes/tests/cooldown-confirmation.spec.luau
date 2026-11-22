local workspace={GetAttribute=function()return false end}
local function confirm(actor,payload,abilityCooldown)
 local v47=actor
 local p23="CorruptEnergy"
 local p24=payload
 local v51={Cooldown=function()return abilityCooldown end}
 local v53=false
local num = tonumber(p24 and (typeof(p24) == "table" and p24.Cooldown) or (typeof(v51.Cooldown) == "function" and v51.Cooldown(v47, p23) or (v51.Cooldown or v47.Config[`{ p23 }Cooldown`])))

		if typeof(p24) == "table" and p24.Cancelled then
			num = 0
		end

		if p24 == "Cancelled" then
			num = 0
		end

		if v53 then
			num = 0
		end

		if num and num > 0 and ((not v47.Cooldowns[p23] or not (v47.Cooldowns[p23].TimePast <= 0.025)) and not workspace:GetAttribute("CooldownsDisabled")) then
			v47.Cooldowns[p23] = {
				TimePast = 0,
				Duration = num
			}
		end

end
local function serverRequest(Actor,Ability)
 local Config={CorruptEnergyCooldown=18}
 local Name="CorruptEnergy"
local Time = tonumber(Config and typeof(Config) == "table" and Config.Cooldown or typeof(Ability.Cooldown) == "function" and Ability.Cooldown(Actor, Name) or Ability.Cooldown or Config[`{Name}Cooldown`] or Actor[("%s*Cooldown"):format(Name)]) or 0;
		if workspace:GetAttribute('CooldownsDisabled') then
			Time = 0
		end
		if Time > 0 then
			Actor:SetCooldownOf(Name, Time)
		end
		
end
local timer={Duration=18,TimePast=7.5}
local actor={Cooldowns={CorruptEnergy=timer},Config={CorruptEnergyCooldown=18}}
-- Reproduce the bug after the replicated retract state is already false.
confirm(actor,{Retract=true},18)
assert(actor.Cooldowns.CorruptEnergy.TimePast==0 and actor.Cooldowns.CorruptEnergy.Duration==18)
-- Explicit zero bypasses the fallback in either replication ordering and retains the original timer object.
for _,cooldown in ipairs({0,18})do
 actor.Cooldowns.CorruptEnergy=timer
 confirm(actor,{Retract=true,Cooldown=0},cooldown)
 assert(actor.Cooldowns.CorruptEnergy==timer and timer.TimePast==7.5)
end
actor.Cooldowns.CorruptEnergy=nil
confirm(actor,{Retract=true,Cooldown=0},18)
assert(actor.Cooldowns.CorruptEnergy==nil,'an expired cooldown was recreated')
-- Actual server dispatcher does not write a new cooldown on Retract.
local expiry=1234
local count=0
local serverActor={SetCooldownOf=function(_,_,duration)count+=1;expiry=duration end}
serverRequest(serverActor,{Cooldown=function()return 0 end})
assert(count==0 and expiry==1234)
serverRequest(serverActor,{Cooldown=function()return 18 end})
assert(count==1 and expiry==18,'normal casts stopped starting their cooldown')
print("PASS real client/server dispatchers: reproduced stale-state reset; explicit zero preserves partial/expired timer in both packet orderings; server retract does not reset expiry")
