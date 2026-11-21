local Cooldowns=require(script.Parent.Haste.CooldownStatus)
return {Data={Duration=15,MaxLevel=99,Stackable=false,Description="Slows ability cooldown recovery by 10% per level."},Heartbeat=function(effect,dt) Cooldowns.Tick(effect,dt,1) end}
