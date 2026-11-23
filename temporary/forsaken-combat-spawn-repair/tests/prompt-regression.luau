
local writes=0
local failAt=nil
local function copy(t)local out={};for k,v in pairs(t)do out[k]=v end;return out end
local Methods={}
local mt={}
function mt.__index(self,k)
 if Methods[k]then return Methods[k] end
 if k=="Parent"then return self._parent end
 local value=self._props[k]
 if value~=nil then return value end
 return self:FindFirstChild(k)
end
function mt.__newindex(self,k,v)
 if k=="Parent"then
  if self._parent then local old=self._parent._children;local i=table.find(old,self);if i then table.remove(old,i)end end
  rawset(self,"_parent",v);if v then table.insert(v._children,self)end
 else
  if k=="Source"then writes+=1;if failAt==writes then error("Injected Source write failure")end end
  self._props[k]=v
 end
end
local Instance={}
function Instance.new(class,parent)
 local self=setmetatable({_props={ClassName=class,Name=class},_children={},_attrs={}},mt)
 if parent then self.Parent=parent end
 return self
end
function Methods:IsA(class)
 return self.ClassName==class or class=="LuaSourceContainer"and(self.ClassName=="Script"or self.ClassName=="ModuleScript"or self.ClassName=="LocalScript")or class=="BasePart"and(self.ClassName=="Part"or self.ClassName=="MeshPart")
end
function Methods:FindFirstChild(name,recursive)
 for _,child in ipairs(self._children)do if child.Name==name then return child end end
 if recursive then for _,child in ipairs(self._children)do local found=child:FindFirstChild(name,true);if found then return found end end end
end
function Methods:FindFirstChildOfClass(class)for _,child in ipairs(self._children)do if child:IsA(class)then return child end end end
function Methods:GetChildren()return table.clone(self._children)end
function Methods:GetDescendants()local out={};for _,child in ipairs(self._children)do table.insert(out,child);for _,desc in ipairs(child:GetDescendants())do table.insert(out,desc)end end;return out end
function Methods:SetAttribute(k,v)self._attrs[k]=v end
function Methods:GetAttribute(k)return self._attrs[k]end
function Methods:Clone()
 local object=Instance.new(self.ClassName);object._props=copy(self._props);object._attrs=copy(self._attrs)
 for _,child in ipairs(self._children)do child:Clone().Parent=object end
 return object
end
function Methods:Destroy()self.Parent=nil;self.Destroyed=true;for _,child in ipairs(self:GetChildren())do child:Destroy()end end
function Methods:GetFullName()return (self.Parent and self.Parent:GetFullName().."."or "")..self.Name end
local game,workspace
local function child(parent,name,class)local o=Instance.new(class or "Folder");o.Name=name;o.Parent=parent;return o end
local function fresh()
 writes=0;failAt=nil
 game=Instance.new("DataModel");workspace=child(game,"Workspace","Workspace")
 local rep=child(game,"ReplicatedStorage");local assets=child(rep,"Assets");local survivors=child(assets,"Survivors")
 local modules=child(rep,"Modules");local statuses=child(modules,"StatusEffects");local misc=child(modules,"Misc")
 for _,name in {"Actors","Util","Statuses","Network","Sounds"}do child(modules,name,"ModuleScript")end
 for _,name in {"Maid","Trove"}do child(misc,name,"ModuleScript")end
 child(game,"ServerStorage")
 function game:GetService(name)
  if name=="RunService"then return {IsStudio=function()return true end,IsRunning=function()return false end}end
  if name=="ChangeHistoryService"then return {SetWaypoint=function()end}end
  return self:FindFirstChild(name)
 end
 return survivors,statuses
end
local function inputs()
 local donor=child(workspace,"HelperbotDonor");local rig=child(donor,"Rig","Model")
 child(rig,"Humanoid","Humanoid");child(rig,"HumanoidRootPart","Part")
 local upd=child(workspace,"HelperbotUPD");local config=child(upd,"Config","ModuleScript");local fx=child(config,"VFX")
 for _,name in {"Pulse","PulseHit","InspireActive"}do child(fx,name,"Attachment")end
 child(config,"Radar","MeshPart");child(config,"ChargeMeter","BillboardGui");child(config,"cl_HelperbotChargeBillboard","ModuleScript")
end

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
local Enum={ProximityPromptStyle={Custom='Custom',Default='Default'},KeyCode={F='F',E='E'}}
local selection={}
local function fixture()
 fresh()
 local getter=game.GetService
 function game:GetService(name)if name=='Selection'then return {Get=function()return selection end}end;return getter(self,name)end
 local ui=child(game.ReplicatedStorage.Assets,'UI');local themes=child(ui,'PromptThemes');child(themes,'Styled','BillboardGui')
 local sss=child(game,'ServerScriptService');local driver=child(sss,'CombatSpawnPads','Script');driver.Source='require(script.Controller).Start()'
 local module=child(driver,'Controller','ModuleScript');module.Source=beforeSource
 local map=child(workspace,'Map');local ingame=child(map,'Ingame');local lobby=child(ingame,'Lobby')
 for _,role in {'Killer','Survivor'}do
  local pad=child(lobby,role,'Part')
  local native=child(pad,'ProximityPrompt','ProximityPrompt')
  native.Style='Custom';native.KeyboardKeyCode='F';native.ActionText='Interact';native.ObjectText='';native.HoldDuration=.1;native.MaxActivationDistance=10;native.RequiresLineOfSight=true;native.Enabled=true;native:SetAttribute('Theme','Styled')
  local extra=child(pad,'CombatRolePrompt','ProximityPrompt');extra.Style='Default';extra.ActionText='Play as '..role
 end
 return module,lobby
end
local function repair()
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

end
local function restore()
assert(game:GetService("RunService"):IsStudio()and not game:GetService("RunService"):IsRunning(),"Stop Play first.")
local backup=game:GetService("Selection"):Get()[1]
assert(backup and backup.Name:match("^CombatPrompts_Backup_"),"Select the CombatPrompts_Backup folder in ServerStorage.")
local controller=backup:FindFirstChild("Controller")and backup.Controller.Value
assert(controller and controller.Source==backup:GetAttribute("AfterControllerSource"),"Controller was edited; nothing restored.")
local entries={}
for _,role in {"Killer","Survivor"}do
 local saved=assert(backup:FindFirstChild(role),"Prompt backup missing")
 local native=saved.Native.Value;local pad=saved.Pad.Value
 assert(native and pad and native.Parent==pad,"Native prompt was moved/removed. Nothing restored.")
 local extra=saved:FindFirstChild("Extra")and saved.Extra.Value
 assert(not extra or extra.Parent==saved,"Archived extra prompt was moved. Nothing restored.")
 table.insert(entries,{saved=saved,native=native,pad=pad,extra=extra})
end
local keys={"Style","KeyboardKeyCode","ActionText","ObjectText","HoldDuration","MaxActivationDistance","RequiresLineOfSight","Enabled"}
local currentSource=controller.Source
local snapshots={}
for _,entry in entries do table.insert(snapshots,entry.native:Clone())end
local ok,err=pcall(function()
 controller.Source=backup.BeforeController.Source
 for _,entry in entries do
  for _,key in keys do entry.native[key]=entry.saved.BeforePrompt[key]end
  entry.native:SetAttribute("Theme",entry.saved.BeforePrompt:GetAttribute("Theme"))
  if entry.extra then entry.extra.Parent=entry.pad end
 end
end)
if not ok then
 controller.Source=currentSource
 for i,entry in entries do
  for _,key in keys do entry.native[key]=snapshots[i][key]end
  entry.native:SetAttribute("Theme",snapshots[i]:GetAttribute("Theme"))
  if entry.extra then entry.extra.Parent=entry.saved end
 end
 for _,snapshot in snapshots do snapshot:Destroy()end
 error("Prompt restore rolled back: "..tostring(err))
end
for _,snapshot in snapshots do snapshot:Destroy()end
backup:Destroy()
print("[Combat prompts] Previous prompt/controller settings restored. Save and restart Play.")

end
local module,lobby=fixture();repair()
assert(module.Source==afterSource)
for _,pad in lobby:GetChildren()do
 local native=pad.ProximityPrompt
 assert(native.Style=='Custom'and native.KeyboardKeyCode=='F'and native.ActionText=='Interact'and native.ObjectText==''and native:GetAttribute('Theme')=='Styled')
 assert(native.HoldDuration==0 and native.MaxActivationDistance==8 and native.Enabled and not native.RequiresLineOfSight)
 assert(not pad:FindFirstChild('CombatRolePrompt'),'default Roblox popup must leave Workspace')
 assert(#pad:GetChildren()==1,'no duplicate replacement prompt created')
end
local count=#game.ServerStorage:GetChildren();repair();assert(#game.ServerStorage:GetChildren()==count)
local backup
for _,object in game.ServerStorage:GetChildren()do if object.Name:match('^CombatPrompts_Backup_')then backup=object end end
assert(backup);selection={backup};restore();assert(module.Source==beforeSource)
for _,pad in lobby:GetChildren()do assert(pad.CombatRolePrompt.Style=='Default'and pad.ProximityPrompt.HoldDuration==.1 and pad.ProximityPrompt.MaxActivationDistance==10 and pad.ProximityPrompt.RequiresLineOfSight)end
module,lobby=fixture();failAt=writes+1;assert(not pcall(repair));assert(module.Source==beforeSource and lobby.Killer.CombatRolePrompt)
module,lobby=fixture();module.Source..='\n-- changed';assert(not pcall(repair));assert(lobby.Killer.CombatRolePrompt)
print('PASS original Forsaken prompt reuse: Styled theme/F key, default popup archived, no duplicate UI, idempotence, restore and Source failure/edit refusal')
