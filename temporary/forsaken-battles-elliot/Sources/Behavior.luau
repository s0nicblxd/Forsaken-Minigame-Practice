local RunService=game:GetService("RunService")
local Impl=require(RunService:IsServer()and script.Server or script.Client)
local Behavior={}
for name,method in Impl do Behavior[name]=method end
Behavior.Abilities={
 ThrowPizza={LayoutOrder=1,KeybindType="AltAbility1",Icon="rbxassetid://93578432067529",Callback=function(actor)return Impl.ThrowPizza(actor)end},
 RushHour={LayoutOrder=2,KeybindType="AltAbility2",Icon="rbxassetid://128250550180598",Charges=3,ChargesDisabled=true,Callback=function(actor,result)return Impl.RushHour(actor,result)end}
}
return Behavior
