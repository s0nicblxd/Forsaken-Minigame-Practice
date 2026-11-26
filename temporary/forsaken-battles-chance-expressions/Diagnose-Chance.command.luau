local RunService=game:GetService("RunService")
assert(RunService:IsRunning()and RunService:IsServer(),"Start Play, spawn as Chance, and run this in the SERVER Command Bar.")
local Actors=require(game.ReplicatedStorage.Modules.Actors)
local ContentProvider=game:GetService("ContentProvider")
local found=false
for _,actor in Actors.CurrentActors do
 if actor.ActorName=="Chance"and actor.Rig then
  found=true
  print("[Chance expressions] Rig:",actor.Rig:GetFullName(),"Skin:",actor.SkinName,"RigName:",actor.RigName)
  local config=actor.Config or {}
  local expressions=(actor.RigName and config["Expressions"..actor.RigName])or config.Expressions
  print("[Chance expressions] Expression table:",typeof(expressions),"ChangeExpression:",typeof(actor.ChangeExpression))
  local head=actor.Rig:FindFirstChild("Head")
  local face=head and head:FindFirstChild("face")
  if face then warn("[Chance expressions] BLOCKER: Head.face exists; this actor system skips expression setup when that object exists.",face.ClassName)end
  local holder=actor.Rig:FindFirstChild("ExpressionHolder",true)
  print("[Chance expressions] Holder:",holder and holder:GetFullName(),"Transparency:",holder and holder.Transparency)
  local decal=holder and holder:FindFirstChildOfClass("Decal")
  print("[Chance expressions] Decal:",decal and decal:GetFullName(),"Texture:",decal and decal.Texture,"Transparency:",decal and decal.Transparency,"Face:",decal and decal.Face)
  if type(expressions)=="table"then
   for name,id in expressions do
    print("[Chance expressions] Config",name,tostring(id))
    if type(id)=="string"and id~=""then
     local ok,err=pcall(function()
      ContentProvider:PreloadAsync({id},function(asset,status)
       print("[Chance expressions] Image fetch:",name,asset,tostring(status))
      end)
     end)
     if not ok then warn("[Chance expressions] Image fetch error:",name,tostring(err))end
    end
   end
  else warn("[Chance expressions] BLOCKER: no expression table on this actor's merged Config.")end
 end
end
if not found then warn("[Chance expressions] No spawned Chance found. Spawn as Chance and run again.")end
print("[Chance expressions] Diagnostic complete; nothing changed.")
