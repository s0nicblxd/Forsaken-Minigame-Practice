assert(game:GetService("RunService"):IsStudio()and not game:GetService("RunService"):IsRunning(),"Stop Play before repairing combat spawns.")
local controllerSource=[========[
local Players=game:GetService("Players")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Actors=require(ReplicatedStorage.Modules.Actors)
local Controller={busy={},cooldowns={},connections={}}
local function live(character)
 local humanoid=character and character:FindFirstChildOfClass("Humanoid")
 return character and character.Parent and character.PrimaryPart and humanoid and humanoid.Health>0
end
local function findPlayer(hit)
 local model=hit
 while model and model~=workspace do
  if model:IsA("Model")then
   local player=Players:GetPlayerFromCharacter(model)
   if player then return player end
  end
  model=model.Parent
 end
end
function Controller.Layout()
 local map=workspace:FindFirstChild("Map")
 local ingame=map and map:FindFirstChild("Ingame")
 local arena=ingame and ingame:FindFirstChild("Map")
 local lobby=ingame and ingame:FindFirstChild("Lobby")
 local spawns=arena and arena:FindFirstChild("SpawnPoints")
 local geometry=arena and arena:FindFirstChild("Paintball Arena")
 return arena,lobby,spawns,geometry
end
function Controller.Destination(role)
 local _,_,spawns,geometry=Controller.Layout()
 local group=spawns and spawns:FindFirstChild(role.."s")
 if not group or not geometry then return nil,"arena spawn folders are missing" end
 local candidates={}
 for _,marker in group:GetChildren()do if marker:IsA("BasePart")then table.insert(candidates,marker)end end
 while #candidates>0 do
  local marker=table.remove(candidates,math.random(#candidates))
  local params=RaycastParams.new()
  params.FilterType=Enum.RaycastFilterType.Include
  params.FilterDescendantsInstances={geometry}
  params.RespectCanCollide=true
  local origin=marker.Position+Vector3.new(0,math.max(2,marker.Size.Y*.5+.1),0)
  local hit=workspace:Raycast(origin,Vector3.new(0,-512,0),params)
  if hit and hit.Normal.Y>.5 then return {position=hit.Position,rotation=marker.CFrame.Rotation,marker=marker}end
 end
 return nil,"no role marker has a walkable arena floor beneath it"
end
function Controller.Pivot(actor,destination)
 local rig=actor.Rig
 assert(live(rig),"character disappeared while spawning")
 local root=rig.PrimaryPart
 local humanoid=rig:FindFirstChildOfClass("Humanoid")
 local leg=rig:FindFirstChild("Left Leg")or rig:FindFirstChild("Right Leg")
 local height=humanoid.HipHeight+root.Size.Y*.5
 if humanoid.RigType==Enum.HumanoidRigType.R6 and leg then
  if leg:IsA("BasePart")then height+=leg.Size.Y elseif leg:IsA("Model")then height+=leg:GetExtentsSize().Y end
 end
 local rootFrame=CFrame.new(destination.position+Vector3.new(0,height+.15,0))*destination.rotation
 local pivot=rootFrame*root.CFrame:ToObjectSpace(rig:GetPivot())
 for _,part in rig:GetDescendants()do
  if part:IsA("BasePart")then part.AssemblyLinearVelocity=Vector3.zero;part.AssemblyAngularVelocity=Vector3.zero end
 end
 actor.ClientV=Vector3.zero
 actor:PivotTo(pivot)
end
function Controller.TrySpawn(player,role,pad)
 if role~="Killer"and role~="Survivor"then return false end
 if player.Parent~=Players or player:GetAttribute("Loaded")~=true then return false end
 if Controller.busy[player]or os.clock()<(Controller.cooldowns[player]or 0)then return false end
 local character=player.Character
 if not live(character)or Actors.CurrentActors[player]then return false end
 if (character.PrimaryPart.Position-pad.Position).Magnitude>math.max(12,pad.Size.Magnitude*.5+6)then return false end
 Controller.busy[player]=true
 local ok,result=xpcall(function()
  local destination,why=Controller.Destination(role)
  assert(destination,why)
  local actor=Actors:CreateActor(player,role)
  assert(actor and actor.Rig and player.Parent==Players and player.Character==actor.Rig,"native character creation failed or player left")
  Controller.Pivot(actor,destination)
  return true
 end,debug.traceback)
 Controller.busy[player]=nil
 Controller.cooldowns[player]=player.Parent==Players and os.clock()+2 or nil
 if not ok then warn("[Combat spawn pads] "..tostring(result));return false end
 return result
end
function Controller.Start()
 if Controller.started then return end
 local _,lobby=Controller.Layout()
 assert(lobby,"Combat lobby missing; run the matching spawn repair installer")
 local spawn=lobby:FindFirstChildOfClass("SpawnLocation")
 assert(spawn and spawn:IsA("SpawnLocation"),"Combat lobby SpawnLocation missing")
 for _,role in {"Killer","Survivor"}do
  local pad=assert(lobby:FindFirstChild(role),"Role pad missing: "..role)
  table.insert(Controller.connections,pad.Touched:Connect(function(hit)
   local player=findPlayer(hit)
   if player then Controller.TrySpawn(player,role,pad)end
  end))
  local prompt=assert(pad:FindFirstChild("CombatRolePrompt"),"Role prompt missing")
  table.insert(Controller.connections,prompt.Triggered:Connect(function(player)Controller.TrySpawn(player,role,pad)end))
 end
 local function added(player)player.RespawnLocation=spawn end
 table.insert(Controller.connections,Players.PlayerAdded:Connect(added))
 table.insert(Controller.connections,Players.PlayerRemoving:Connect(function(player)Controller.busy[player]=nil;Controller.cooldowns[player]=nil end))
 for _,player in Players:GetPlayers()do added(player)end
 Controller.started=true
 print("[Combat spawn pads] Equipped Killer/Survivor pads ready.")
end
return Controller
]========]
local driverSource=[========[
require(script.Controller).Start()
]========]
local oldPadSource=[========[
-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [FilteringEnabled] Server Scripts are IMPOSSIBLE to save]========]
local sss=game:GetService("ServerScriptService")
local existing=sss:FindFirstChild("CombatSpawnPads")
if existing then
 assert(existing:IsA("Script")and existing.Source==driverSource and existing:FindFirstChild("Controller")and existing.Controller.Source==controllerSource,"Existing CombatSpawnPads differs. Nothing changed.")
 print("[Combat spawn repair] Already installed.");return
end
local map=assert(workspace:FindFirstChild("Map"),"Workspace.Map missing")
local ingame=assert(map:FindFirstChild("Ingame"),"Workspace.Map.Ingame missing")
local wrapper=ingame:FindFirstChild("MapImport")
local imported=wrapper and wrapper:FindFirstChild("Ingame")
local arena=ingame:FindFirstChild("Map")or(imported and imported:FindFirstChild("Map"))
local lobby=ingame:FindFirstChild("Lobby")or(imported and imported:FindFirstChild("Lobby"))
local spawns=arena and arena:FindFirstChild("SpawnPoints")or ingame:FindFirstChild("SpawnPoints")or(imported and imported:FindFirstChild("SpawnPoints"))
assert(arena and arena:IsA("Model")and arena:FindFirstChild("Paintball Arena"),"Expected imported Paintball Arena model. Nothing changed.")
assert(lobby and spawns,"Imported lobby or spawn markers missing. Nothing changed.")
for name,object in {Map=arena,Lobby=lobby}do assert(not ingame:FindFirstChild(name)or ingame:FindFirstChild(name)==object,"Conflicting Ingame."..name..". Nothing changed.")end
assert(not arena:FindFirstChild("SpawnPoints")or arena.SpawnPoints==spawns,"Conflicting arena spawn markers. Nothing changed.")
local lobbySpawn=assert(lobby:FindFirstChildOfClass("SpawnLocation"),"Imported lobby Spawn missing")
assert(lobbySpawn:IsA("SpawnLocation"),"Select the direct lobby SpawnLocation, not its decorative Spawn model. Nothing changed.")
local pads={}
for _,role in {"Killer","Survivor"}do
 local pad=assert(lobby:FindFirstChild(role),"Missing role pad: "..role)
 assert(pad:IsA("BasePart")and not pad:FindFirstChild("CombatRolePrompt"),"Unexpected role pad/prompt. Nothing changed.")
 local old=pad:FindFirstChild("Become"..role)
 assert(old and old:IsA("Script")and old.Source==oldPadSource,"Role pad script has local edits. Nothing changed; send its source to preserve them.")
 local markers=spawns:FindFirstChild(role.."s");local count=0
 if markers then for _,marker in markers:GetChildren()do if marker:IsA("BasePart")then count+=1 end end end
 assert(count>0,"No spawn markers for "..role..". Nothing changed.")
 table.insert(pads,{role=role,pad=pad,old=old,markers=markers})
end
local rep=game:GetService("ReplicatedStorage")
assert(rep:FindFirstChild("Modules")and rep.Modules:FindFirstChild("Actors"),"Actors module missing. Nothing changed.")
local moves={}
local properties={}
local created={}
local function move(target,parent)if target.Parent~=parent then table.insert(moves,{target=target,before=target.Parent,after=parent})end end
local function property(target,name,value)if target[name]~=value then table.insert(properties,{target=target,key=name,before=target[name],after=value})end end
move(arena,ingame);move(lobby,ingame);move(spawns,arena)
for _,entry in pads do
 property(entry.pad,"CanTouch",true)
 property(entry.old,"Disabled",true)
 for _,marker in entry.markers:GetChildren()do
  if marker:IsA("BasePart")then
   property(marker,"Anchored",true);property(marker,"CanCollide",false);property(marker,"CanTouch",false);property(marker,"CanQuery",false)
  end
 end
end
for _,object in workspace:GetDescendants()do if object:IsA("SpawnLocation")then property(object,"Enabled",object==lobbySpawn)end end
property(lobbySpawn,"Neutral",true)
local backup=Instance.new("Folder")
local prefix="CombatSpawns_Backup_"..os.date("!%Y%m%d_%H%M%S");local index=0
while game.ServerStorage:FindFirstChild(prefix.."_"..index)do index+=1 end
backup.Name=prefix.."_"..index
local function reference(parent,name,value)local object=Instance.new("ObjectValue");object.Name=name;object.Value=value;object.Parent=parent end
for i,item in moves do
 local saved=Instance.new("Folder");saved.Name="Move_"..i;reference(saved,"Target",item.target);reference(saved,"Before",item.before);reference(saved,"After",item.after);saved.Parent=backup
end
for i,item in properties do
 local saved=Instance.new("Folder");saved.Name="Property_"..i;reference(saved,"Target",item.target);saved:SetAttribute("Property",item.key);saved:SetAttribute("Before",item.before);saved:SetAttribute("After",item.after);saved.Parent=backup
end
backup.Parent=game.ServerStorage
local ok,err=pcall(function()
 for _,item in moves do item.target.Parent=item.after end
 for _,item in properties do item.target[item.key]=item.after end
 for _,entry in pads do
  local prompt=Instance.new("ProximityPrompt");table.insert(created,prompt)
  prompt.Name="CombatRolePrompt";prompt.ActionText="Play as "..entry.role;prompt.ObjectText="Equipped "..entry.role
  prompt.HoldDuration=.15;prompt.MaxActivationDistance=8;prompt.RequiresLineOfSight=false;prompt.Parent=entry.pad
 end
 local runtime=Instance.new("Script");table.insert(created,runtime);runtime.Name="CombatSpawnPads";runtime.Disabled=true
 runtime.Source=driverSource
 local module=Instance.new("ModuleScript");module.Name="Controller";module.Parent=runtime;module.Source=controllerSource
 runtime.Parent=sss;runtime.Disabled=false
 for i,object in created do
  local saved=Instance.new("Folder");saved.Name="Created_"..i;reference(saved,"Target",object);saved:SetAttribute("ClassName",object.ClassName);saved:SetAttribute("ObjectName",object.Name)
  if object:IsA("Script")then saved:SetAttribute("DriverSource",driverSource);saved:SetAttribute("ControllerSource",controllerSource)end
  saved.Parent=backup
 end
end)
if not ok then
 for i=#created,1,-1 do created[i]:Destroy()end
 for i=#properties,1,-1 do local item=properties[i];item.target[item.key]=item.before end
 for i=#moves,1,-1 do local item=moves[i];item.target.Parent=item.before end
 backup:Destroy();error("[Combat spawn repair] Rolled back: "..tostring(err))
end
pcall(function()game:GetService("ChangeHistoryService"):SetWaypoint("Repair combat role pads and spawn hierarchy")end)
print("[Combat spawn repair] Installed. Save and start a new playtest; touch a role pad or use its prompt. Backup: "..backup:GetFullName())
