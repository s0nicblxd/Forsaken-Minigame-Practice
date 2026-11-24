local Impl={Use=function(actor,kind,result)return {actor,kind,result}end,Created=function()end}
local script={Server=Impl,Client=Impl}
local game={GetService=function()return {IsServer=function()return true end}end}
local function require(value)return value end
local Behavior=(function()
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

end)()
assert(Behavior.Abilities.Move.Name=="Carry"and Behavior.Abilities.Move.SpecialName=="Place")
for i,name in {"Sentry","Dispenser","Move"}do
 local result=Behavior.Abilities[name].Callback("actor","response")
 assert(result[1]=="actor"and result[2]==name and result[3]=="response","ability closure routed to wrong building")
 assert(Behavior.Abilities[name].KeybindType=="AltAbility"..i)
 assert(Behavior.Abilities[name].Charges==nil)
end
print("PASS shared abilities: distinct callback routing, third-slot Carry/Place and no native charge consumption")
