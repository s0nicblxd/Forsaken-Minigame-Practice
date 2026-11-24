
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

local nativeTypeof=typeof
local function typeof(value)if type(value)=="table"and value._props then return "Instance"end;return nativeTypeof(value)end
local function signal()
 local all={}
 return {Connect=function(_,callback)
  local c={Active=true};function c:Disconnect()self.Active=false end
  table.insert(all,{c,callback});return c
 end,Fire=function(_,...)
  for _,pair in table.clone(all)do if pair[1].Active then pair[2](...)end end
 end,Count=function()local n=0;for _,pair in all do if pair[1].Active then n+=1 end end;return n end}
end

fresh()
local now=0;local tasks={}
local task={delay=function(delay,callback)table.insert(tasks,{at=now+delay,callback=callback})end}
local heartbeat=signal()
local runService={Heartbeat=heartbeat}
local rewards={}
local Actors={CurrentActors={},IncrementActorStats=function(_,player,payload)table.insert(rewards,payload)end}
local Statuses={calls={}}
function Statuses:ApplyStatus(rig,name,data)table.insert(self.calls,{rig=rig,name=name,data=data})end
local Util={}
function Util:Heal(hum,amount)hum.Health=math.min(hum.MaxHealth,hum.Health+amount);hum.HealthChanged:Fire(hum.Health)end
function Util:RevealPlayerAuraTo()end
local Sounds={Play=function()end}
local Network={FireClientConnection=function()end}
local Rules=(function()
local Rules={}
function Rules.Penalty(config,additional)
 if additional<=0 then return 1 end
 return 1-math.min(config.HealingPercentDebuffCap,config.HealingPercentDebuffFirstElliot+(additional-1)*config.HealingPercentDebuffPerElliot)/100
end
function Rules.Healing(config,bonus,additional,recipientElliot)
 local multiplier=Rules.Penalty(config,additional)*(recipientElliot and .5 or 1)
 return config.PizzaHealingAmount*multiplier,(config.PizzaHealingProgressively+math.clamp(bonus or 0,0,config.OrderUpBonusMax))*multiplier
end
function Rules.Level(charges)return math.clamp(math.floor(charges or 0),0,3)end
function Rules.Stamina(level)return 1+.05*level,math.max(0,1-.05*level)end
return Rules

end)()
local modules=game.ReplicatedStorage.Modules
modules.Actors=Actors;modules.Statuses=Statuses;modules.Util=Util;modules.Sounds=Sounds;modules.Network=Network
local function require(value)return value end
local script={Parent={Rules=Rules}}
local getService=game.GetService
function game:GetService(name)
 if name=="RunService"then return runService end
 if name=="Players"then return {GetPlayerFromCharacter=function()end}end
 return getService(self,name)
end
local vec={}
local vmt={}
function vmt.__sub(a,b)return setmetatable({n=a.n-b.n},vmt)end
function vmt.__add(a,b)return setmetatable({n=a.n+b.n},vmt)end
function vmt.__mul(a,b)if type(a)=="number"then a,b=b,a end;return setmetatable({n=a.n*b},vmt)end
function vmt.__index(a,key)if key=="Magnitude"then return math.abs(a.n)end end
local function v(n)return setmetatable({n=n},vmt)end
local Vector3={new=function()return v(0)end}
local cmt={__mul=function(a,b)return a end}
local CFrame={new=function()return setmetatable({LookVector=v(1)},cmt)end}
-- The production closures resolve global Vector3/CFrame, so wrap spawn code with these mocks.

local Color3={new=function()return {}end}
local Server=(function()
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
 if rush.scooter then rush.scooter:Destroy()end
 if a.Rig and a.Rig.Parent then a.Rig:SetAttribute("ElliotRushing",nil)end
end
local function scooter(a)
 if a.Config.UsesScooter==false then return end
 local template=a.Config.Instances and a.Config.Instances.CustomScooter
 if not template or not template:IsA("Model")then return end
 local model=template:Clone()
 local handle=model:FindFirstChild("ScooterHandle")or model.PrimaryPart
 local torso=a.Rig:FindFirstChild("Torso")or a.Rig.PrimaryPart
 if not handle or not torso then model:Destroy();return end
 for _,object in model:GetDescendants()do
  if object:IsA("BasePart")then object.Anchored=false;object.CanCollide=false;object.CanTouch=false;object.CanQuery=false;object.Massless=true
  elseif object:IsA("LuaSourceContainer")then object:Destroy()end
 end
 model.PrimaryPart=handle
 model:PivotTo(torso.CFrame)
 local joint=model:FindFirstChild("ScooterJoint",true)
 if joint and joint:IsA("Motor6D")then joint.Part0=torso;joint.Part1=handle
 else joint=Instance.new("Motor6D");joint.Name="ScooterJoint";joint.Part0=torso;joint.Part1=handle;joint.Parent=handle end
 model.Name="ElliotRushScooter";model.Parent=a.Rig
 return model
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
 rush.scooter=scooter(a)
 a:DisableAbilities("ElliotRush",true,a.Config.RushHourAbilityDisabledFor)
 sound(a,"RushHourStart")
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

end)()

local players=child(workspace,"Players");local survivors=child(players,"Survivors");local killers=child(players,"Killers")
local map=child(workspace,"Map");child(map,"Ingame")
local function config()
 return {UsesScooter=false,RushHourRewards={Used={Money=2,EXP=10,KillerChance=0},Escaped={Money=5,EXP=18,KillerChance=0}},OrderUpBonus=2,OrderUpBonusMax=10,HealingPercentDebuffCap=90,HealingPercentDebuffFirstElliot=40,HealingPercentDebuffPerElliot=18,
 PizzaHealingAmount=5,PizzaHealingProgressively=15,PizzaHealingProgressivelyTime=4,PizzaAbilityDisabledFor=2,PizzaThrowTimeToThrow=.5,
 PizzaThrowForce=60,PizzaLifetime=15,PizzaHitboxSize=2,PizzaPingDistance=200,PizzaPingDuration=25,RushHourKillerRange=85,RushHourSpeedDuration=4,RushHourExhaustedDuration=4,RushHourAbilityDisabledFor=.1,Instances={},Sounds={}}
end
local function actor(name,folder,pos)
 local rig=child(folder,name,"Model");local root=child(rig,"HumanoidRootPart","Part");root.Position=v(pos);root.Size=v(2);rig.PrimaryPart=root
 local hum=child(rig,"Humanoid","Humanoid");hum.Health=80;hum.MaxHealth=100;hum.HealthChanged=signal();hum.Died=signal()
 local a={ActorName=name,Rig=rig,Config=config(),Player=Instance.new("Player"),Behavior={Abilities={RushHour={CurrentCharges=3}}}}
 a.Player.Name=name
 function a:IncrementCharges(_,delta,max)self.Behavior.Abilities.RushHour.CurrentCharges=math.clamp(self.Behavior.Abilities.RushHour.CurrentCharges+delta,0,max)end
 function a:DisableAbilities()end
 function a:GetPivot()return CFrame.new()end
 Actors.CurrentActors[a.Player]=a
 return a,hum
end
local a,hum=actor("Elliot",survivors,0)
Server.Created(nil,a);assert(a.Behavior.Abilities.RushHour.CurrentCharges==1)
local killer=actor("Slasher",killers,20)
a.Behavior.Abilities.RushHour.CurrentCharges=3
local result=Server.RushHour(a)
assert(result.Empowered and result.Level==3 and a.Behavior.Abilities.RushHour.CurrentCharges==0)
assert(Statuses.calls[#Statuses.calls].name=="Speed"and Statuses.calls[#Statuses.calls].data.Duration==4)
local function advance(dt)
 now+=dt
 local queue=tasks;tasks={}
 for _,item in queue do if item.at<=now then item.callback()else table.insert(tasks,item)end end
 heartbeat:Fire(dt)
end
advance(4)
assert(not a.ElliotRush and Statuses.calls[#Statuses.calls].name=="Exhausted"and Statuses.calls[#Statuses.calls].data.Level==3)
assert(#rewards==1 and rewards[1].Money==2 and rewards[1].EXP==10,"activation payout or false escape")
a.Behavior.Abilities.RushHour.CurrentCharges=2
killer.Rig.PrimaryPart.Position=v(20)
Server.RushHour(a)
killer.Rig.PrimaryPart.Position=v(500)
advance(4)
assert(#rewards==3 and rewards[3].Money==5 and rewards[3].EXP==18,"escape payout missing")
local payoutCount=#rewards
advance(4);assert(#rewards==payoutCount,"duplicate escape payout")
a.Behavior.Abilities.RushHour.CurrentCharges=1
killer.Rig.PrimaryPart.Position=v(20)
Server.RushHour(a)
killer.Rig.Humanoid.Health=0
advance(4)
assert(#rewards==payoutCount+1,"dead killer counted as escape")
killer.Rig.Humanoid.Health=80
a.Behavior.Abilities.RushHour.CurrentCharges=0
local calls=#Statuses.calls
assert(Server.RushHour(a).Cancelled and #Statuses.calls==calls)
a.Behavior.Abilities.RushHour.CurrentCharges=2;killer.Rig.PrimaryPart.Position=v(500)
result=Server.RushHour(a);assert(not result.Empowered and result.Level==1 and a.Behavior.Abilities.RushHour.CurrentCharges==2)
advance(4);assert(Statuses.calls[#Statuses.calls].name=="Speed","unempowered rush applied Exhausted")
for i=1,8 do Server.ObjectiveProgressed(nil,a)end;assert(a.HealingBonus==10)
assert(Rules.Penalty(a.Config,0)==1)
assert(math.abs(Rules.Penalty(a.Config,1)-.6)<1e-6)
assert(math.abs(Rules.Penalty(a.Config,2)-.42)<1e-6)
assert(math.abs(Rules.Penalty(a.Config,20)-.1)<1e-6)
local instant,total=Rules.Healing(a.Config,10,1,false);assert(instant==3 and total==15)
local i,t=Rules.Healing(a.Config,10,1,true);assert(i==1.5 and t==7.5)
-- Actual pizza projectile/pickup path: only registered survivors qualify; clone and caster cannot steal it.
local pizza=child(a.Rig,"Pizza","Part");pizza.Position=v(0);pizza.Size=v(1)
function Methods:SetNetworkOwner()end
Server.ThrowPizza(a);advance(.5)
assert(#map.Ingame:GetChildren()==1,"pizza not thrown or caster consumed own pizza")
local clone=child(survivors,"Clone","Model");local cloneHum=child(clone,"Humanoid","Humanoid");cloneHum.Health=1
advance(.1);assert(#map.Ingame:GetChildren()==1,"unregistered clone consumed pizza")
local target,targetHum=actor("Noob",survivors,0);targetHum.Health=50
local charges=a.Behavior.Abilities.RushHour.CurrentCharges
advance(.1)
assert(#map.Ingame:GetChildren()==0 and targetHum.Health==55)
assert(a.Behavior.Abilities.RushHour.CurrentCharges==math.min(3,charges+1))
advance(1);assert(math.abs(targetHum.Health-61.25)<1e-6,"Order Up not included in overtime heal")
local before=targetHum.Health;targetHum.Health-=5;targetHum.HealthChanged:Fire(targetHum.Health)
advance(2);assert(targetHum.Health==before-5,"5 damage failed to cancel overtime")
-- No target: lifetime expiry and no lingering heartbeat listener.
target.Rig.PrimaryPart.Position=v(1000)
Server.ThrowPizza(a);advance(.5);assert(#map.Ingame:GetChildren()==1)
advance(15);assert(#map.Ingame:GetChildren()==0)
Server.Destroyed(nil,a);assert(a.ElliotDestroyed and not a.ElliotRush)
assert(Server.ThrowPizza(a).Cancelled)
local loss,gain=Rules.Stamina(3);assert(loss==1.15 and gain==.85)
print("PASS server Rush Hour charge/empowerment/expiry/exclusions, Order Up and stacking math, actual pizza pickup/healing/5-damage cancellation, clone filtering, expiry/death cleanup and Exhausted values")
