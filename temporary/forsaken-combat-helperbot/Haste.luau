local Cooldowns=require(script.CooldownStatus)
return {Data={Duration=15,MaxLevel=99,Stackable=false,Description="Ability cooldowns recover 10% faster per level. Effectiveness is halved for Support survivors."},Heartbeat=function(effect,dt) Cooldowns.Tick(effect,dt,-1) end}
