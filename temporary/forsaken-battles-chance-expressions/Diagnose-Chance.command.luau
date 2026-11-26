local RunService=game:GetService("RunService")
print("[Chance expressions] Context:","Running",RunService:IsRunning(),"Server",RunService:IsServer(),"Client",RunService:IsClient())
assert(RunService:IsRunning()and RunService:IsServer(),"Run during Play in the SERVER Command Bar; see the context values above.")
local Actors=require(game.ReplicatedStorage.Modules.Actors)
local Players=game:GetService("Players")
local ContentProvider=game:GetService("ContentProvider")
local seen={}
local function inspect(rig,config,label)
 if not rig or seen[rig]then return end
 seen[rig]=true
 print("[Chance expressions] Inspect:",label,rig:GetFullName(),"ActorDisplayName:",rig:GetAttribute("ActorDisplayName"),"SkinName:",rig:GetAttribute("SkinName"))
 local head=rig:FindFirstChild("Head")
 local face=head and head:FindFirstChild("face")
 if face then warn("[Chance expressions] Head.face exists: native expression setup skips rigs with this object.",face.ClassName)end
 local holder=rig:FindFirstChild("ExpressionHolder",true)
 print("[Chance expressions] Holder:",holder and holder:GetFullName(),"Transparency:",holder and holder:IsA("BasePart")and holder.Transparency)
 local decal=holder and holder:FindFirstChildOfClass("Decal")
 print("[Chance expressions] Decal:",decal and decal:GetFullName(),"Texture:",decal and decal.Texture,"Transparency:",decal and decal.Transparency,"Face:",decal and decal.Face)
 if head then
  for _,child in head:GetChildren()do
   if child:IsA("Decal")then print("[Chance expressions] Head decal:",child.Name,child.Texture,child.Transparency,child.Face)end
  end
 end
 if type(config)=="table"then
  for name,id in config do
   print("[Chance expressions] Config:",name,tostring(id))
   if type(id)=="string"and id~=""then
    local ok,err=pcall(function()
     ContentProvider:PreloadAsync({id},function(asset,status)print("[Chance expressions] Image fetch:",name,asset,tostring(status))end)
    end)
    if not ok then warn("[Chance expressions] Image fetch error:",name,tostring(err))end
   end
  end
 else warn("[Chance expressions] No resolved expression table for this rig.")end
end
local count=0
for key,actor in Actors.CurrentActors or {}do
 count+=1
 print("[Chance expressions] Actor registry:",tostring(key),"Entry type:",typeof(actor))
 if type(actor)=="table"then
  print("[Chance expressions] Identity:",actor.ActorName,"DisplayName:",actor.Config and actor.Config.DisplayName,"Skin:",actor.ActorSkin,"RigName:",actor.RigName,"ChangeExpression:",typeof(actor.ChangeExpression))
  local config=actor.Config or {}
  local expressions=(actor.RigName and config["Expressions"..actor.RigName])or config.Expressions
  inspect(actor.Rig,expressions,"registered actor")
 end
end
print("[Chance expressions] Registered actor count:",count)
for _,player in Players:GetPlayers()do
 print("[Chance expressions] Player:",player.Name,"Character:",player.Character and player.Character:GetFullName())
 inspect(player.Character,nil,"player Character without registry match")
end
local folders=workspace:FindFirstChild("Players")
if folders then
 for _,rig in folders:GetDescendants()do
  if rig:IsA("Model")and rig:FindFirstChildOfClass("Humanoid")then inspect(rig,nil,"world actor without registry match")end
 end
end
print("[Chance expressions] Diagnostic complete; nothing changed. Send the lines starting with [Chance expressions].")
