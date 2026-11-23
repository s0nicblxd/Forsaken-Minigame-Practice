
local now=0;local os={clock=function()return now end}
local warnings={};local warn=function(message)table.insert(warnings,message)end
local function signal()
 local s={handlers={}}
 function s:Connect(fn)table.insert(self.handlers,fn);return {Disconnect=function()end}end
 function s:Fire(...)for _,fn in self.handlers do fn(...)end end
 return s
end
local V={}
V.__index=function(self,key)if key=='Magnitude'then return math.sqrt(self.X^2+self.Y^2+self.Z^2)end;return V[key]end
function V.__add(a,b)return setmetatable({X=a.X+b.X,Y=a.Y+b.Y,Z=a.Z+b.Z},V)end
function V.__sub(a,b)return setmetatable({X=a.X-b.X,Y=a.Y-b.Y,Z=a.Z-b.Z},V)end
local Vector3={new=function(x,y,z)return setmetatable({X=x,Y=y,Z=z},V)end};Vector3.zero=Vector3.new(0,0,0)
local CF={};CF.__index=function(self,key)if key=='Rotation'then return setmetatable({Position=Vector3.zero},CF)end;return CF[key]end
function CF.__mul(a,b)return setmetatable({Position=a.Position+b.Position},CF)end
function CF:ToObjectSpace(other)return setmetatable({Position=other.Position-self.Position},CF)end
local CFrame={new=function(x,y,z)return setmetatable({Position=type(x)=='table'and x or Vector3.new(x or 0,y or 0,z or 0)},CF)end}
local Enum={RaycastFilterType={Include='Include'},HumanoidRigType={R6='R6',R15='R15'}}
local RaycastParams={new=function()return {}end}
local function node(name,class,parent)
 local n={Name=name,ClassName=class,Parent=parent,children={},attrs={}}
 if parent then table.insert(parent.children,n)end
 function n:IsA(kind)return self.ClassName==kind or(kind=='BasePart'and(self.ClassName=='Part'or self.ClassName=='SpawnLocation'))end
 function n:GetChildren()return self.children end
 function n:GetDescendants()local list={};for _,child in self.children do table.insert(list,child);for _,nested in child:GetDescendants()do table.insert(list,nested)end end;return list end
 function n:FindFirstChild(name)for _,child in self.children do if child.Name==name then return child end end end
 function n:FindFirstChildOfClass(class)for _,child in self.children do if child:IsA(class)then return child end end end
 function n:GetAttribute(key)return self.attrs[key]end
 function n:GetPivot()return self.pivot or self.PrimaryPart.CFrame end
 return n
end
local workspace=node('Workspace','Workspace')
local map=node('Map','Folder',workspace);local ingame=node('Ingame','Folder',map);local arena=node('Map','Model',ingame)
local geometry=node('Paintball Arena','Folder',arena);local spawns=node('SpawnPoints','Folder',arena);local lobby=node('Lobby','Folder',ingame)
node('Spawn','Model',lobby);local spawn=node('Spawn','SpawnLocation',lobby)
local pads={}
for _,role in {'Killer','Survivor'}do
 local pad=node(role,'Part',lobby);pad.Position=Vector3.new(0,650,0);pad.Size=Vector3.new(4,1,4);pad.Touched=signal()
 local prompt=node('CombatRolePrompt','ProximityPrompt',pad);prompt.Triggered=signal();pads[role]=pad
 local group=node(role..'s','Folder',spawns)
 for i=1,3 do local marker=node('TeleportZone','Part',group);marker.Position=Vector3.new(i*10,211,0);marker.Size=Vector3.new(6,1,6);marker.CFrame=CFrame.new(marker.Position)end
end
local floor=true;local rays=0
function workspace:Raycast(origin,direction,params)
 rays+=1;assert(params.FilterType=='Include'and params.FilterDescendantsInstances[1]==geometry and params.RespectCanCollide)
 if floor then return {Position=Vector3.new(origin.X,200,origin.Z),Normal=Vector3.new(0,1,0)}end
end
local players=node('Players','Players');players.PlayerAdded=signal();players.PlayerRemoving=signal();players.items={}
function players:GetPlayers()return self.items end
function players:GetPlayerFromCharacter(model)for _,player in self.items do if player.Character==model then return player end end end
local function rig(scale)
 local model=node('Avatar','Model',workspace)
 local root=node('HumanoidRootPart','Part',model);root.Size=Vector3.new(2*scale,2*scale,scale);root.Position=Vector3.new(0,650,0);root.CFrame=CFrame.new(root.Position)
 model.PrimaryPart=root
 local hum=node('Humanoid','Humanoid',model);hum.Health=100;hum.HipHeight=0;hum.RigType='R6'
 local leg=node('Left Leg','Part',model);leg.Size=Vector3.new(scale,2*scale,scale)
 model.pivot=root.CFrame*CFrame.new(0,.5,0)
 return model
end
local function player(name)
 local p=node(name,'Player',players);p.Character=rig(1);p.attrs.Loaded=true;table.insert(players.items,p);return p
end
local a,b=player('One'),player('Two')
local actors={CurrentActors={}};local calls=0;local reenter;local failCreate=false
function actors:CreateActor(p,role,...)
 calls+=1;assert(select('#',...)==0,'native equipped-character selection must be used')
 if reenter then reenter()end
 if failCreate then error('character module error')end
 local model=rig(role=='Killer'and 1.25 or 1);p.Character=model
 local actor={Rig=model,Player=p,ActorType=role}
 function actor:PivotTo(cf)
  self.lastPivot=cf;self.Rig.pivot=cf;local root=self.Rig.PrimaryPart
  root.CFrame=cf*CFrame.new(0,-.5,0);root.Position=root.CFrame.Position
 end
 self.CurrentActors[p]=actor;return actor
end
local rep={Modules={Actors=actors}}
local game={GetService=function(_,name)if name=='Players'then return players elseif name=='ReplicatedStorage'then return rep end end}
local require=function(module)return module end
local Controller=(function()
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

end)()
Controller.Start();Controller.Start()
assert(a.RespawnLocation==spawn and b.RespawnLocation==spawn and #pads.Killer.Touched.handlers==1)
reenter=function()assert(not Controller.TrySpawn(a,'Survivor',pads.Survivor),'busy lock must span role pads')end
pads.Killer.Touched:Fire(a.Character.PrimaryPart)
reenter=nil
assert(calls==1 and actors.CurrentActors[a].ActorType=='Killer')
local killer=actors.CurrentActors[a]
assert(math.abs(killer.Rig.PrimaryPart.Position.Y-203.9)<.0001,'scaled rig ground clearance')
assert(killer.ClientV==Vector3.zero and killer.Rig.PrimaryPart.AssemblyLinearVelocity==Vector3.zero)
now=3;pads.Survivor:FindFirstChild('CombatRolePrompt').Triggered:Fire(a);assert(calls==1,'active actors cannot health-reset or role switch')
pads.Survivor:FindFirstChild('CombatRolePrompt').Triggered:Fire(b)
assert(calls==2 and actors.CurrentActors[b].ActorType=='Survivor'and math.abs(b.Character.PrimaryPart.Position.Y-203.15)<.0001)
local c=player('Three');players.PlayerAdded:Fire(c);assert(c.RespawnLocation==spawn)
c.Character.PrimaryPart.Position=Vector3.new(100,650,0);assert(not Controller.TrySpawn(c,'Killer',pads.Killer)and calls==2)
c.Character.PrimaryPart.Position=Vector3.new(0,650,0);c.attrs.Loaded=false;assert(not Controller.TrySpawn(c,'Killer',pads.Killer));c.attrs.Loaded=true
floor=false;local rayBefore=rays
assert(not Controller.TrySpawn(c,'Killer',pads.Killer)and calls==2 and rays==rayBefore+3,'missing floor refuses creation after trying all markers')
assert(not Controller.busy[c]and #warnings==1)
floor=true;assert(not Controller.TrySpawn(c,'Killer',pads.Killer),'failure cooldown prevents touch spam')
now+=3;failCreate=true;assert(not Controller.TrySpawn(c,'Killer',pads.Killer)and not Controller.busy[c])
failCreate=false;now+=3;assert(Controller.TrySpawn(c,'Killer',pads.Killer))
players.PlayerRemoving:Fire(c);assert(not Controller.busy[c]and not Controller.cooldowns[c])
local d=player('Four');d.Character:FindFirstChildOfClass('Humanoid').Health=0
assert(not Controller.TrySpawn(d,'Survivor',pads.Survivor))
assert(not Controller.TrySpawn(b,'Invalid',pads.Killer))
print('PASS spawn runtime: native equipped roles, touch/prompt, duplicate Spawn name, scaled/normal rig clearance, replication pivot, cross-role debounce, alive/loaded/distance checks, active-actor refusal, missing-floor and module-error recovery')
