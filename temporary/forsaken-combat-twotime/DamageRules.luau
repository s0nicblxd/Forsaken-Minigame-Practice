-- Both damage routes call this once, before victim resistance is applied.
local DamageRules={}
function DamageRules.ScaleDamage(source,damage)
 if not source then return damage end
 if source:IsA("Player") then source=source.Character end
 if not source then return damage end
 local reduction=tonumber(source:GetAttribute("WeaknessNerf")) or 0
 return damage*math.clamp(1-reduction/100,0,1)
end
return DamageRules
