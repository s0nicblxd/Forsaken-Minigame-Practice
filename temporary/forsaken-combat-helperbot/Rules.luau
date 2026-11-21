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
