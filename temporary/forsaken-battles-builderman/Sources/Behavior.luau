local RunService=game:GetService("RunService")
local Impl=require(RunService:IsServer()and script.Server or script.Client)
local Behavior={}
for name,method in Impl do Behavior[name]=method end
local icons={Sentry="104441527277654",Dispenser="102952736333903",Move="97983142047580"}
Behavior.Abilities={}
for order,kind in {"Sentry","Dispenser","Move"}do
 local ability={LayoutOrder=order,KeybindType="AltAbility"..order,Icon="rbxassetid://"..icons[kind],Callback=function(actor,result)return Impl.Use(actor,kind,result)end}
 if kind=="Move"then ability.Name="Carry";ability.SpecialName="Place";ability.SpecialIcon="rbxassetid://109402731902696"
 else ability.CurrentRecharge=0;ability.ChargeDuration=0;ability.RechargeInverted=true end
 Behavior.Abilities[kind]=ability
end
return Behavior
