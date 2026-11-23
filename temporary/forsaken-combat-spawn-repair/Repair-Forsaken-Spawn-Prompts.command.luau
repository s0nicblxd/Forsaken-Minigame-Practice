assert(game:GetService("RunService"):IsStudio()and not game:GetService("RunService"):IsRunning(),"Stop Play before updating spawn prompts.")
local beforeSource=[========[
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
local afterSource=[========[
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
  local prompt=assert(pad:FindFirstChild("ProximityPrompt"),"Role prompt missing")
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
local rep=game:GetService("ReplicatedStorage")
local themes=rep:FindFirstChild("Assets")and rep.Assets:FindFirstChild("UI")and rep.Assets.UI:FindFirstChild("PromptThemes")
assert(themes and themes:FindFirstChild("Styled"),"Forsaken Styled prompt asset is missing. Nothing changed.")
local runtime=game:GetService("ServerScriptService"):FindFirstChild("CombatSpawnPads")
local controller=runtime and runtime:FindFirstChild("Controller")
assert(controller and controller:IsA("ModuleScript")and(controller.Source==beforeSource or controller.Source==afterSource),"Spawn controller differs from the supported repair. Nothing changed; send the current source.")
local ingame=workspace:FindFirstChild("Map")and workspace.Map:FindFirstChild("Ingame")
local lobby=ingame and ingame:FindFirstChild("Lobby")
assert(lobby,"Repaired combat lobby missing. Run the spawn hierarchy repair first.")
local entries={}
local changed=controller.Source~=afterSource
for _,role in {"Killer","Survivor"}do
 local pad=assert(lobby:FindFirstChild(role),"Role pad missing")
 local native=pad:FindFirstChild("ProximityPrompt")
 local extra=pad:FindFirstChild("CombatRolePrompt")
 assert(native and native:IsA("ProximityPrompt")and(not extra or extra:IsA("ProximityPrompt")),"Original Forsaken prompt missing or invalid. Nothing changed.")
 if extra or native.Style~=Enum.ProximityPromptStyle.Custom or native.KeyboardKeyCode~=Enum.KeyCode.F or native:GetAttribute("Theme")~="Styled"or native.ActionText~="Interact"or native.ObjectText~=""or not native.Enabled then changed=true end
 table.insert(entries,{pad=pad,native=native,extra=extra,role=role})
end
if not changed then print("[Combat prompts] Original Forsaken F Interact prompts already connected.");return end
local backup=Instance.new("Folder")
local prefix="CombatPrompts_Backup_"..os.date("!%Y%m%d_%H%M%S");local index=0
while game.ServerStorage:FindFirstChild(prefix.."_"..index)do index+=1 end
backup.Name=prefix.."_"..index
local savedController=controller:Clone();savedController.Name="BeforeController";savedController.Parent=backup
local function reference(parent,name,value)local object=Instance.new("ObjectValue");object.Name=name;object.Value=value;object.Parent=parent end
reference(backup,"Controller",controller)
backup:SetAttribute("AfterControllerSource",afterSource)
for _,entry in entries do
 local saved=Instance.new("Folder");saved.Name=entry.role;saved.Parent=backup
 reference(saved,"Native",entry.native);reference(saved,"Pad",entry.pad)
 local snapshot=entry.native:Clone();snapshot.Name="BeforePrompt";snapshot.Parent=saved
 if entry.extra then reference(saved,"Extra",entry.extra)end
 entry.saved=saved
end
backup.Parent=game.ServerStorage
local keys={"Style","KeyboardKeyCode","ActionText","ObjectText","HoldDuration","MaxActivationDistance","RequiresLineOfSight","Enabled"}
local ok,err=pcall(function()
 controller.Source=afterSource
 for _,entry in entries do
  local prompt=entry.native
  prompt.Style=Enum.ProximityPromptStyle.Custom;prompt.KeyboardKeyCode=Enum.KeyCode.F
  prompt.ActionText="Interact";prompt.ObjectText="";prompt.HoldDuration=0
  prompt.MaxActivationDistance=8;prompt.RequiresLineOfSight=false;prompt.Enabled=true;prompt:SetAttribute("Theme","Styled")
  if entry.extra then entry.extra.Parent=entry.saved end
 end
end)
if not ok then
 controller.Source=savedController.Source
 for _,entry in entries do
  for _,key in keys do entry.native[key]=entry.saved.BeforePrompt[key]end
  entry.native:SetAttribute("Theme",entry.saved.BeforePrompt:GetAttribute("Theme"))
  if entry.extra then entry.extra.Parent=entry.pad end
 end
 backup:Destroy();error("[Combat prompts] Rolled back: "..tostring(err))
end
print("[Combat prompts] Original Forsaken F Interact prompts now spawn you; Roblox popup removed and touch spawning retained. Save and start a NEW playtest. Backup: "..backup:GetFullName())
