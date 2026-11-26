local RunService=game:GetService("RunService")
local Actors=require(game.ReplicatedStorage.Modules.Actors)
local Support={}
function Support.Count(actor)
 local count=0
 for _,other in Actors.CurrentActors do
  local hum=other.Rig and other.Rig:FindFirstChildOfClass("Humanoid")
  if other.ActorName==actor.ActorName and hum and hum.Health>0 then count+=1 end
 end
 return math.max(1,count)
end
function Support.Duration(base,penalty,count)return math.max(0,base-math.max(0,count-1)*penalty)end
local function params(actor,mine)
 local p=RaycastParams.new();p.FilterType=Enum.RaycastFilterType.Exclude;p.RespectCanCollide=true
 local excluded={actor.Rig,mine}
 local players=workspace:FindFirstChild("Players");if players then table.insert(excluded,players)end
 p.FilterDescendantsInstances=excluded
 return p
end
function Support.VisibleKiller(actor,mine,util)
 if not mine.Parent or not mine.PrimaryPart then return nil end
 local origin=mine.PrimaryPart.Position
 local candidates=util:GetClosestPlayerFromPosition(origin,{PlayerSelection="Killers",ReturnTable=true,MaxDistance=actor.Config.SubspaceRange})
 local p=params(actor,mine)
 for _,entry in candidates or {}do
  local rig=entry.Player
  local root=rig and rig.PrimaryPart
  if root and not workspace:Raycast(origin,root.Position-origin,p)then return entry end
 end
end
function Support.Stop(actor)
 local state=actor.TaphPortState
 if not state or state.stopped then return end
 state.stopped=true
 for _,connection in state.connections do connection:Disconnect()end
 state.connections={}
 for model,remove in state.wires do
  if model.Parent then remove();if model.Parent then model:Destroy()end end
 end
 state.wires={}
 for model,record in state.mines do
  if model.Parent then
   model:SetAttribute("TaphForceExplosion",true)
   if record.explode then record.explode()else record.hum.Health=.125 end
  end
 end
end
function Support.Bind(actor)
 if actor.TaphPortState then return actor.TaphPortState end
 local state={mines={},wires={},connections={},stopped=false};actor.TaphPortState=state
 local hum=actor.Rig:FindFirstChildOfClass("Humanoid")
 if hum then table.insert(state.connections,hum.HealthChanged:Connect(function(value)if value<=0 then Support.Stop(actor)end end))end
 table.insert(state.connections,actor.Rig.Destroying:Connect(function()Support.Stop(actor)end))
 return state
end
function Support.Wire(actor,model,remove)
 local state=Support.Bind(actor);state.wires[model]=remove
 model.Destroying:Connect(function()state.wires[model]=nil end)
 if state.stopped then remove();if model.Parent then model:Destroy()end end
end
function Support.Mine(actor,mine,hum)
 local state=Support.Bind(actor)
 state.mines[mine]={hum=hum}
 mine.Destroying:Connect(function()state.mines[mine]=nil end)
 local root=mine.PrimaryPart
 local p=params(actor,mine)
 local initial=actor.Rig.PrimaryPart.Position
 local _,size=mine:GetBoundingBox()
 local radius=math.clamp(math.min(size.X,size.Y,size.Z)*.5,.15,1)
 local function sweep(origin,direction)
  if direction.Magnitude<.001 then return nil end
  return workspace:Spherecast(origin,radius,direction,p)
 end
 local hit=sweep(initial,root.Position-initial)
 if hit then
  local delta=root.Position-initial
  local safe=initial+delta.Unit*math.max(0,hit.Distance-.05)
  mine:PivotTo(mine:GetPivot()+safe-root.Position)
  root.AssemblyLinearVelocity=Vector3.zero
 end
 local last=root.Position
 local flight
 flight=RunService.Heartbeat:Connect(function()
  if not mine.Parent or not mine.PrimaryPart then flight:Disconnect();return end
  local current=root.Position
  local result=sweep(last,current-last)
  if result then
   local direction=current-last
   local safe=last+direction.Unit*math.max(0,result.Distance-.05)
   mine:PivotTo(mine:GetPivot()+safe-current)
   root.AssemblyLinearVelocity=Vector3.zero
  end
  last=root.Position
 end)
 mine.Destroying:Connect(function()flight:Disconnect()end)
 if state.stopped then mine:SetAttribute("TaphForceExplosion",true);hum.Health=.125 end
end
function Support.Schedule(actor,mine,delaySeconds,callback)
 local state=Support.Bind(actor)
 local record=state.mines[mine]
 if not record then record={};state.mines[mine]=record end
 if record.explode then return end
 local fired=false
 local function run()
  if fired then return end
  fired=true
  if mine.Parent then callback()end
 end
 record.explode=run
 if state.stopped or mine:GetAttribute("TaphForceExplosion")then run()else task.delay(delaySeconds,run)end
end
return Support
