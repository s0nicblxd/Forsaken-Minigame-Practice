local Rules={}
function Rules.Penalty(config,additional)
 if additional<=0 then return 1 end
 return 1-math.min(config.HealingPercentDebuffCap,config.HealingPercentDebuffFirstElliot+(additional-1)*config.HealingPercentDebuffPerElliot)/100
end
function Rules.Healing(config,bonus,additional,recipientElliot)
 local multiplier=Rules.Penalty(config,additional)*(recipientElliot and .5 or 1)
 return config.PizzaHealingAmount*multiplier,(config.PizzaHealingProgressively+math.clamp(bonus or 0,0,config.OrderUpBonusMax))*multiplier
end
function Rules.Level(charges)return math.clamp(math.floor(charges or 0),0,3)end
function Rules.Stamina(level)return 1+.05*level,math.max(0,1-.05*level)end
return Rules
