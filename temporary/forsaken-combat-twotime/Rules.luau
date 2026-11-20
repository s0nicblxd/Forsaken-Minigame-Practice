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
return Rules
