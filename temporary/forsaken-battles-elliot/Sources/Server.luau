local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local Modules=game.ReplicatedStorage.Modules
local Actors=require(Modules.Actors)
local Statuses=require(Modules.Statuses)
local Util=require(Modules.Util)
local Sounds=require(Modules.Sounds)
local Network=require(Modules.Network)
local Rules=require(script.Parent.Rules)
local Server={}
local function alive(rig)
 local hum=rig and rig:FindFirstChildOfClass("Humanoid")
 return rig and rig.Parent and rig.PrimaryPart and hum and hum.Health>0
end
local function active(a)return not a.ElliotDestroyed and alive(a.Rig)end
local function actorFor(rig)
 for _,a in Actors.CurrentActors do if a.Rig==rig then return a end end
end
local function team(rig,name)return rig and rig.Parent==workspace.Players:FindFirstChild(name)end
local function sound(a,key,parent)
 local id=a.Config.Sounds and a.Config.Sounds[key]
 if id and id~=""then pcall(Sounds.Play,Sounds,id,{Parent=parent or a.Rig.PrimaryPart})end
end
local function invoke(a,name,...)
 local method=a.Behavior[name]
 if method then pcall(method,a.Behavior,a,...)end
end
local function nearest(a)
 local best,distance=nil,a.Config.RushHourKillerRange
 for _,other in Actors.CurrentActors do
  if team(other.Rig,"Killers")and alive(other.Rig)then
   local d=(other.Rig.PrimaryPart.Position-a.Rig.PrimaryPart.Position).Magnitude
   if d<=distance then best=other;distance=d end
  end
 end
 return best
end
local function charges(a,level)
 local ability=a.Behavior.Abilities.RushHour
 local n=Rules.Level(level)
 if a.IncrementCharges then a:IncrementCharges("RushHour",n-(ability.CurrentCharges or 0),3)else ability.CurrentCharges=n end
 a.Rig:SetAttribute("ElliotRushCharges",n)
end
local function releaseRush(a)
 local rush=a.ElliotRush
 if not rush then return end
 a.ElliotRush=nil
 if rush.mountConnection then rush.mountConnection:Disconnect()end
 if rush.scooter then rush.scooter:Destroy()end
 if a.Rig and a.Rig.Parent then a.Rig:SetAttribute("ElliotRushing",nil)end
end
local function scooter(a)
 if a.Config.UsesScooter==false then return end
 local template=a.Config.Instances and a.Config.Instances.CustomScooter
 if not template or not template:IsA("Model")then return end
 local model=template:Clone()
 local handle=model:FindFirstChild("ScooterHandle")or model.PrimaryPart
 local torso=a.Rig:FindFirstChild("HumanoidRootPart")or a.Rig.PrimaryPart
 if not handle or not torso then model:Destroy();return end
 for _,object in model:GetDescendants()do
  if object:IsA("BasePart")then
   object.Anchored=false;object.CanCollide=false;object.CanTouch=false;object.CanQuery=false;object.Massless=true
   if object~=handle and (object.Name=="Scooter"or object:IsA("MeshPart"))then
    object.Transparency=0;object.LocalTransparencyModifier=0
   end
  elseif object:IsA("LuaSourceContainer")then object:Destroy()end
 end
 model.PrimaryPart=handle
 model:PivotTo(torso.CFrame)
 local oldJoint=model:FindFirstChild("ScooterJoint",true)
 if oldJoint then oldJoint:Destroy()end
 local joint=Instance.new("Weld")
 joint.Name="ElliotScooterMount";joint.Part0=torso;joint.Part1=handle;joint.Parent=handle
 joint.C1=CFrame.new()
 local base=a.Config.RushHourScooterOffset or CFrame.new()
 local geometry={}
 for _,part in model:GetDescendants()do
  if part:IsA("BasePart")and part~=handle and part.Transparency<1 then
   table.insert(geometry,{relative=handle.CFrame:ToObjectSpace(part.CFrame),half=part.Size*.5})
  end
 end
 if not a.Config.RushHourScooterOffset and #geometry>0 then
  local minimum=Vector3.new(math.huge,math.huge,math.huge)
  local maximum=Vector3.new(-math.huge,-math.huge,-math.huge)
  for _,shape in geometry do
   for x=-1,1,2 do for y=-1,1,2 do for z=-1,1,2 do
    local point=shape.relative:PointToWorldSpace(Vector3.new(x*shape.half.X,y*shape.half.Y,z*shape.half.Z))
    minimum=Vector3.new(math.min(minimum.X,point.X),math.min(minimum.Y,point.Y),math.min(minimum.Z,point.Z))
    maximum=Vector3.new(math.max(maximum.X,point.X),math.max(maximum.Y,point.Y),math.max(maximum.Z,point.Z))
   end end end
  end
  base=CFrame.new(-(minimum.X+maximum.X)*.5,0,-(minimum.Z+maximum.Z)*.5)
 end
 local params=RaycastParams.new()
 params.FilterType=Enum.RaycastFilterType.Include
 params.FilterDescendantsInstances={workspace.Map}
 params.IgnoreWater=true
 model.Name="ElliotRushScooter";model:SetAttribute("ElliotMountVersion","RigidCentered");model.Parent=a.Rig
 local connection
 local function updateMount()
  if not model.Parent or not torso.Parent then
   if connection then connection:Disconnect()end
   return
  end
  local mount=torso.CFrame*base
  local bottom=math.huge
  for _,shape in geometry do
   local cf=mount*shape.relative
   local half=shape.half
   local extent=math.abs(cf.RightVector.Y)*half.X+math.abs(cf.UpVector.Y)*half.Y+math.abs(cf.LookVector.Y)*half.Z
   bottom=math.min(bottom,cf.Position.Y-extent)
  end
  local floor=workspace:Raycast(torso.Position+Vector3.new(0,2,0),Vector3.new(0,-8,0),params)
  local lift=0
  if floor and bottom<math.huge then lift=math.max(0,floor.Position.Y+.06-bottom)end
  local localLift=torso.CFrame:VectorToObjectSpace(Vector3.new(0,lift,0))
  joint.C0=CFrame.new(localLift)*base
 end
 updateMount()
 connection=RunService.Heartbeat:Connect(updateMount)
 return model,connection
end
local function reward(a,kind)
 if not a.Player or not a.Player:IsA("Player")then return end
 -- FB payouts supplied by the user; rewards are granted by the server.
 local settings=a.Config.RushHourRewards and a.Config.RushHourRewards[kind]
 a.Rig:SetAttribute("ElliotRush"..kind,(a.Rig:GetAttribute("ElliotRush"..kind)or 0)+1)
 if settings then
  local payload=table.clone(settings)
  payload.Action=kind=="Used"and "Used Rush Hour"or "Successfully Escaped the Killer with Rush Hour"
  Actors:IncrementActorStats(a.Player,payload)
 end
end
function Server.Created(_,a)
 a.ElliotDestroyed=false;a.HealingBonus=0;a.ElliotPizzas={};a.ElliotConnections={}
 charges(a,1)
 table.insert(a.ElliotConnections,a.Rig:FindFirstChildOfClass("Humanoid").Died:Connect(function()Server.Destroyed(nil,a)end))
end
function Server.ObjectiveProgressed(_,a)
 if not active(a)then return end
 a.HealingBonus=math.min((a.HealingBonus or 0)+a.Config.OrderUpBonus,a.Config.OrderUpBonusMax)
 if a.Player then Network:FireClientConnection(a.Player,"ElliotOrderUpUpdate","REMOTE_EVENT",a.HealingBonus)end
end
function Server.OnThrowPizza(_,a)
 local pizza=a.Rig:FindFirstChild("Pizza")
 if pizza and pizza:IsA("BasePart")then pizza.Transparency=a.Config.PizzaTransparency or 0 end
end
function Server.OnThrowPizzaEnd(_,a)
 local pizza=a.Rig and a.Rig:FindFirstChild("Pizza")
 if pizza and pizza:IsA("BasePart")then pizza.Transparency=1 end
end
local function healPizza(a,target,additional)
 local rig=target.Rig
 local hum=rig:FindFirstChildOfClass("Humanoid")
 local instant,total=Rules.Healing(a.Config,a.HealingBonus,additional,target.ActorName=="Elliot")
 local before=hum.Health
 Util:Heal(hum,instant)
 local credited=false
 local function credit()
  if credited then return end
  credited=true
  if active(a)and target.ActorName~="Elliot"then charges(a,(a.Behavior.Abilities.RushHour.CurrentCharges or 0)+1)end
  if a.Player and a.Player:IsA("Player")then Actors:IncrementActorStats(a.Player,{Action="Healed player as Elliot",RewardType="Support"})end
 end
 if hum.Health>before then credit()end
 local elapsed=0
 local health=hum.Health
 local cancelled=false
 local healthConnection,heartbeat
 local function stop()
  if healthConnection then healthConnection:Disconnect();healthConnection=nil end
  if heartbeat then heartbeat:Disconnect();heartbeat=nil end
 end
 healthConnection=hum.HealthChanged:Connect(function(value)
  if value<=0 or health-value>=5 then cancelled=true;stop()end
  health=value
 end)
 heartbeat=RunService.Heartbeat:Connect(function(dt)
  if cancelled or not rig.Parent or hum.Health<=0 then stop();return end
  local step=math.min(dt,a.Config.PizzaHealingProgressivelyTime-elapsed)
  elapsed+=step
  local previous=hum.Health
  Util:Heal(hum,total*step/a.Config.PizzaHealingProgressivelyTime)
  if hum.Health>previous then credit()end
  if elapsed>=a.Config.PizzaHealingProgressivelyTime then stop()end
 end)
end
local function spawnPizza(a)
 if not active(a)then return end
 local source=a.Config.Instances and a.Config.Instances.CustomPizza or a.Rig:FindFirstChild("Pizza")
 if not source or not source:IsA("BasePart")then warn("[Elliot] Missing pizza part");return end
 local pizza=source:Clone();pizza.Name="ElliotPizza"
 for _,object in pizza:GetDescendants()do
  if object:IsA("JointInstance")or object:IsA("WeldConstraint")or object:IsA("LuaSourceContainer")then object:Destroy()end
 end
 pizza.Anchored=false;pizza.CanCollide=true;pizza.CanTouch=true;pizza.Massless=false;pizza.Transparency=0
 pizza.CFrame=a:GetPivot()*CFrame.new(0,0,-2)
 pizza.Parent=workspace.Map.Ingame
 pcall(function()pizza.CollisionGroup="Items";pizza:SetNetworkOwner(nil)end)
 pizza.AssemblyLinearVelocity=(a:GetPivot().LookVector+Vector3.new(0,.5,0))*a.Config.PizzaThrowForce
 sound(a,"PizzaThrown")
 if a.Config.PizzaParticles then local particles=a.Config.PizzaParticles:Clone();particles.Enabled=true;particles.Parent=pizza end
 local gui=a.Config.PizzaTimeGui and a.Config.PizzaTimeGui:Clone()
 if gui then gui.Adornee=pizza;gui.Parent=pizza end
 for _,other in Actors.CurrentActors do
  if other.Player and other.Player:IsA("Player")and team(other.Rig,"Survivors")and alive(other.Rig)and(other.Rig.PrimaryPart.Position-a.Rig.PrimaryPart.Position).Magnitude<=a.Config.PizzaPingDistance then
   pcall(Util.RevealPlayerAuraTo,Util,other.Player,pizza,a.Config.PizzaPingDuration,Color3.new(.75,1,.75),100)
  end
 end
 local state={part=pizza,elapsed=0,consumed=false};a.ElliotPizzas[state]=true
 local function cleanup()
  if state.connection then state.connection:Disconnect();state.connection=nil end
  a.ElliotPizzas[state]=nil
  pizza:Destroy()
 end
 state.connection=RunService.Heartbeat:Connect(function(dt)
  if not pizza.Parent then cleanup();return end
  state.elapsed+=dt
  if state.elapsed>=a.Config.PizzaLifetime then cleanup();return end
  if gui then
   local text=gui:FindFirstChild("Display",true)
   if text then text.Text=tostring(math.ceil(a.Config.PizzaLifetime-state.elapsed))end
  end
  for _,target in Actors.CurrentActors do
   local rig=target.Rig
   if rig~=a.Rig and team(rig,"Survivors")and alive(rig)then
    local hum=rig:FindFirstChildOfClass("Humanoid")
    if not hum:GetAttribute("Clanker")and hum.Health<hum.MaxHealth then
     local close=false
     for _,part in rig:GetChildren()do
      if part:IsA("BasePart")and(part.Position-pizza.Position).Magnitude<=(a.Config.PizzaHitboxSize or 2)+part.Size.Magnitude*.25 then close=true;break end
     end
     if close and not state.consumed then
      state.consumed=true
      local additional=0
      for _,other in Actors.CurrentActors do
       if other~=a and other.ActorName=="Elliot"and team(other.Rig,"Survivors")and alive(other.Rig)then additional+=1 end
      end
      sound(a,"PizzaEaten",rig.PrimaryPart)
      cleanup();healPizza(a,target,additional);return
     end
    end
   end
  end
 end)
end
function Server.ThrowPizza(a)
 if not active(a)then return {Cancelled=true}end
 a:DisableAbilities("ElliotPizza",true,a.Config.PizzaAbilityDisabledFor)
 invoke(a,"OnThrowPizza")
 task.delay(a.Config.PizzaThrowTimeToThrow,function()
  if active(a)then spawnPizza(a)end
  invoke(a,"OnThrowPizzaEnd")
 end)
 return {}
end
function Server.RushHour(a)
 if not active(a)or a.ElliotRush then return {Cancelled=true}end
 local level=Rules.Level(a.Behavior.Abilities.RushHour.CurrentCharges)
 if level==0 and workspace:GetAttribute("ChargesDisabled")then level=1 end
 if level==0 then return {Cancelled=true}end
 local killer=nearest(a)
 local empowered=killer~=nil
 if empowered and not workspace:GetAttribute("ChargesDisabled")then charges(a,0)end
 local rush={level=empowered and level or 1,empowered=empowered}
 a.ElliotRush=rush;a.Rig:SetAttribute("ElliotRushing",true)
 rush.scooter,rush.mountConnection=scooter(a)
 a:DisableAbilities("ElliotRush",true,a.Config.RushHourAbilityDisabledFor)
 sound(a,"RushHourStart")
 if a.ChangeExpression then a:ChangeExpression("Happy",a.Config.RushHourSpeedDuration)end
 Statuses:ApplyStatus(a.Rig,"Speed",{Level=rush.level,Duration=a.Config.RushHourSpeedDuration,NoStack={"HitSpeedBonus"}})
 reward(a,"Used")
 task.delay(a.Config.RushHourSpeedDuration,function()
  if a.ElliotRush~=rush then return end
  releaseRush(a)
  if active(a)and empowered then
   Statuses:ApplyStatus(a.Rig,"Exhausted",{Level=level,Duration=a.Config.RushHourExhaustedDuration})
   if alive(killer.Rig)and team(killer.Rig,"Killers")and not nearest(a)then reward(a,"Escaped")end
  end
 end)
 return {Level=rush.level,Empowered=empowered,Duration=a.Config.RushHourSpeedDuration}
end
function Server.Destroyed(_,a)
 if a.ElliotDestroyed then return end
 a.ElliotDestroyed=true
 releaseRush(a)
 for _,connection in a.ElliotConnections or {}do connection:Disconnect()end
 for state in a.ElliotPizzas or {}do if state.connection then state.connection:Disconnect()end;if state.part then state.part:Destroy()end end
 a.ElliotPizzas={}
end
return Server
