-- FCF rig + current UPD presentation; authoritative mechanics reconstructed for FCT.
local RunService=game:GetService("RunService")
local Impl=require(RunService:IsServer() and script.Server or script.Client)
local Behavior={}
for name,method in pairs(Impl) do Behavior[name]=method end
Behavior.Abilities={}
for name,info in pairs({Pulse={1,"127410699461731",44},Inspiration={2,"126611529586683",46}}) do
 Behavior.Abilities[name]={LayoutOrder=info[1],Icon="rbxassetid://"..info[2],KeybindType="AltAbility"..info[1],Cooldown=info[3],Callback=function(actor)
  return Impl[name](actor)
 end}
end
return Behavior
