
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
 local entries={}
 return {Connect=function(_,callback)
  local object={Active=true};function object:Disconnect()self.Active=false end
  table.insert(entries,{object,callback});return object
 end,Fire=function(_,...)
  for _,entry in table.clone(entries)do if entry[1].Active then entry[2](...)end end
 end}
end
function Methods:WaitForChild(name)return self:FindFirstChild(name)end

fresh()
local now=0;local os={clock=function()return now end}
local task={spawn=function(callback)callback()end}
local players=child(game,"Players","Players");players.PlayerAdded=signal()
function players:GetPlayers()return self:GetChildren()end
local heartbeat=signal();local RunService={IsServer=function()return true end,Heartbeat=heartbeat}
local added=signal();local removed=signal()
local Actors={CurrentActors={},ActorAdded=added,ActorRemoved=removed}
local Schema=(function()
return {
 {"General","GENERAL",{{"TimePlayed","Time Played",true},{"InGameTime","In-Game Time",true},{"TotalKills","Total Kills"},{"TotalDeaths","Total Deaths"}}},
 {"SurvivorStats","SURVIVOR STATS",{{"SurvivorKills","Survivor Kills"},{"SurvivorDeaths","Survivor Deaths"},{"BestSurvivorTime","Best Survivor Time",true},{"BestSurvivorKillstreak","Best Survivor Killstreak"}}},
 {"KillerStats","KILLER STATS",{{"KillerKills","Killer Kills"},{"KillerDeaths","Killer Deaths"},{"BestKillerTime","Best Killer Time",true},{"BestKillerKillstreak","Best Killer Killstreak"}}},
 {"Currency","CURRENCY",{{"Money","Money"},{"NetWorth","Net Worth"}}}
}

end)()
local script={Schema=Schema}
local function require(module)return module end
game.ReplicatedStorage.Modules.Actors=Actors
local get=game.GetService
function game:GetService(name)if name=="RunService"then return RunService end;return get(self,name)end
local closing
function game:BindToClose(callback)closing=callback end
local ff=signal();local setAttr=Methods.SetAttribute
function workspace:GetAttributeChangedSignal(name)assert(name=="FriendlyFire");return ff end
function Methods:SetAttribute(name,value)local before=self:GetAttribute(name);setAttr(self,name,value);if self==workspace and name=="FriendlyFire"and before~=value then ff:Fire()end end
local Stats=(function()
local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local Actors=require(game.ReplicatedStorage.Modules.Actors)
local Schema=require(script.Schema)
local Stats={}
local sessions={}
local rigs=setmetatable({},{__mode="k"})
local damage=setmetatable({},{__mode="k"})
local nextSession=0
local function folder(parent,name)
 local object=parent:FindFirstChild(name)
 if not object then object=Instance.new("Folder");object.Name=name;object.Parent=parent end
 return object
end
function Stats:EnsureData(data)
 local root=folder(data,"Stats")
 for index,section in Schema do
  local group=folder(root,section[1]);group:SetAttribute("DisplayTitle",section[2]);group:SetAttribute("LayoutOrder",index)
  for order,field in section[3]do
   local value=group:FindFirstChild(field[1])
   if not value then value=Instance.new("NumberValue");value.Name=field[1];value.Value=0;value.Parent=group end
   value:SetAttribute("CombatStat",true);value:SetAttribute("DisplayTitle",field[2]);value:SetAttribute("LayoutOrder",order)
   if field[3]then value:SetAttribute("PostDisplayTitle","Time")end
  end
 end
 return root
end
local function dataFor(player)
 local data=player and player:FindFirstChild("PlayerData")
 return data and Stats:EnsureData(data)
end
local function add(root,section,name,delta)
 local value=root[section][name];value.Value+=delta
end
local function best(root,section,name,value)
 local stat=root[section][name];stat.Value=math.max(stat.Value,value)
end
local function account(state)
 if state.ended then return end
 local now=state.stoppedAt or os.clock();local elapsed=math.max(0,now-state.accounted)
 local root=dataFor(state.player)
 if root then
  add(root,"General","InGameTime",elapsed)
  best(root,state.role.."Stats","Best"..state.role.."Time",math.max(0,now-state.started))
 end
 state.accounted=now
end
local function death(state)
 if state.dead or state.ended then return end
 state.dead=true;state.stoppedAt=os.clock()
 account(state)
 local root=dataFor(state.player)
 if root then add(root,"General","TotalDeaths",1);add(root,state.role.."Stats",state.role.."Deaths",1)end
 local hit=damage[state.rig]
 if not hit or os.clock()-hit.time>10 then
  local name=state.rig:GetAttribute("RecentAttacker")
  local stamp=state.rig:GetAttribute("RecentAttackerTime")
  local player=type(name)=="string"and Players:FindFirstChild(name)
  local source=player and sessions[player]
  if source and type(stamp)=="number"and os.clock()-stamp<=10 then hit={state=source,time=stamp}end
 end
 if hit and os.clock()-hit.time<=10 then
  local killer=hit.state
  if killer.player~=state.player and killer.player.Parent==Players then
   local killerData=dataFor(killer.player)
   if killerData then
    add(killerData,"General","TotalKills",1)
    add(killerData,killer.role.."Stats",killer.role.."Kills",1)
    if sessions[killer.player]==killer and not killer.dead and not killer.ended then
     killer.streak+=1
     best(killerData,killer.role.."Stats","Best"..killer.role.."Killstreak",killer.streak)
    end
   end
  end
 end
 damage[state.rig]=nil
end
local function finish(state)
 if state.ended then return end
 if state.hum.Health<=0 then death(state)end
 account(state);state.ended=true
 for _,connection in state.connections do connection:Disconnect()end
 if sessions[state.player]==state then sessions[state.player]=nil end
end
function Stats:Observe(actor)
 local player=actor.Player
 if typeof(player)~="Instance"or not player:IsA("Player")then return end
 local rig=actor.Rig;local hum=rig and rig:FindFirstChildOfClass("Humanoid")
 local role=actor.ActorType
 if role~="Survivor"and role~="Killer"then return end
 if not hum or not rig.Parent or hum.Health<=0 then return end
 local old=sessions[player]
 if old and old.rig==rig then return end
 if old then finish(old)end
 nextSession+=1
 local now=os.clock()
 local state={player=player,rig=rig,hum=hum,role=role,started=now,accounted=now,streak=0,connections={},id=nextSession}
 sessions[player]=state;rigs[rig]=state
 rig:SetAttribute("CombatSessionId",nextSession)
 dataFor(player)
 table.insert(state.connections,hum.HealthChanged:Connect(function(value)if value<=0 then death(state)end end))
 table.insert(state.connections,hum.Died:Connect(function()death(state)end))
end
function Stats:RecordDamage(creator,creatorRig,victimRig)
 local victim=rigs[victimRig]
 if not victim or victim.ended then return end
 local attacker=rigs[creatorRig]
 if attacker and attacker.player==creator and creator~=victim.player then damage[victimRig]={state=attacker,time=os.clock()}
 else damage[victimRig]=nil end
end
function Stats:FlushPlayer(player)
 local state=sessions[player]
 if state then finish(state)end
end
function Stats.Start()
 if not RunService:IsServer()then return end
 local function forceFriendlyFire()if workspace:GetAttribute("FriendlyFire")~=true then workspace:SetAttribute("FriendlyFire",true)end end
 forceFriendlyFire();workspace:GetAttributeChangedSignal("FriendlyFire"):Connect(forceFriendlyFire)
 Actors.ActorAdded:Connect(function(actor)Stats:Observe(actor)end)
 Actors.ActorRemoved:Connect(function(actor)
  local state=sessions[actor.Player]
  if state and state.rig==actor.Rig then finish(state)end
 end)
 for _,actor in Actors.CurrentActors do Stats:Observe(actor)end
 local function loaded(player)
  task.spawn(function()
   local data=player:WaitForChild("PlayerData",60)
   if data and player.Parent==Players then Stats:EnsureData(data)end
  end)
 end
 Players.PlayerAdded:Connect(loaded)
 for _,player in Players:GetPlayers()do loaded(player)end
 local elapsed=0
 RunService.Heartbeat:Connect(function(dt)
  elapsed+=dt;if elapsed<1 then return end;elapsed=0
  for _,state in sessions do
   if state.hum.Health<=0 then death(state)else account(state)end
  end
 end)
 game:BindToClose(function()for player in sessions do Stats:FlushPlayer(player)end end)
end
return Stats

end)()
local function player(name)
 local p=child(players,name,"Player");local data=child(p,"PlayerData")
 local root=Stats:EnsureData(data);root.General.TimePlayed.Value=37
 local legacy=child(root.SurvivorStats,"SurvivorWins","NumberValue");legacy.Value=9
 local rbx=child(root.Currency,"RbxSpent","NumberValue");rbx.Value=300
 return p,root
end
local a,ad=player("Alice");local b,bd=player("Bob")
local function actor(p,role)
 local rig=Instance.new("Model");rig.Parent=workspace
 local hum=child(rig,"Humanoid","Humanoid");hum.Health=100;hum.Died=signal();hum.HealthChanged=signal()
 local actor={Player=p,Rig=rig,ActorType=role}
 Actors.CurrentActors[p]=actor;added:Fire(actor)
 return actor,hum
end
local function step(dt)now+=dt;heartbeat:Fire(dt)end
local function die(actor,hum,attacker)
 if attacker then Stats:RecordDamage(attacker.Player,attacker.Rig,actor.Rig)end
 hum.Health=0
 removed:Fire(actor) -- native cleanup may precede our Died listener
 hum.HealthChanged:Fire(0);hum.Died:Fire()
 Actors.CurrentActors[actor.Player]=nil
end
Stats.Start()
assert(workspace:GetAttribute("FriendlyFire")==true)
workspace:SetAttribute("FriendlyFire",false);assert(workspace:GetAttribute("FriendlyFire")==true)
local as,ah=actor(a,"Survivor");local bs,bh=actor(b,"Survivor")
step(10)
assert(ad.General.InGameTime.Value==10 and ad.General.TimePlayed.Value==37)
die(bs,bh,as)
assert(ad.General.TotalKills.Value==1 and ad.SurvivorStats.SurvivorKills.Value==1 and ad.SurvivorStats.BestSurvivorKillstreak.Value==1)
assert(bd.General.TotalDeaths.Value==1 and bd.SurvivorStats.SurvivorDeaths.Value==1)
local bk,bkh=actor(b,"Killer");step(2);die(as,ah,bk)
assert(ad.General.TotalDeaths.Value==1 and ad.SurvivorStats.SurvivorDeaths.Value==1)
assert(bd.KillerStats.KillerKills.Value==1 and bd.General.TotalKills.Value==1)
assert(ad.SurvivorStats.BestSurvivorTime.Value==12)
local ak,akh=actor(a,"Killer");step(3)
removed:Fire(ak);Actors.CurrentActors[a]=nil
assert(ad.KillerStats.KillerDeaths.Value==0 and ad.KillerStats.BestKillerTime.Value==3,"role switch counted as death or lost best time")
local again,againHum=actor(a,"Killer");step(1);die(again,againHum,nil)
assert(ad.General.TotalDeaths.Value==2 and ad.KillerStats.KillerDeaths.Value==1,"environmental death not counted")
local a2,a2h=actor(a,"Survivor")
for i=1,2 do
 local victim,vh=actor(b,"Killer");die(victim,vh,a2)
end
assert(ad.SurvivorStats.BestSurvivorKillstreak.Value==2 and ad.SurvivorStats.SurvivorKills.Value==3)
local before=ad.General.InGameTime.Value;step(.4);Stats:FlushPlayer(a)
assert(math.abs(ad.General.InGameTime.Value-before-.4)<1e-6,"leave flush dropped fractional active time")
local ended=ad.General.InGameTime.Value;step(20);assert(ad.General.InGameTime.Value==ended,"lobby/ended session accrued time")
assert(ad.SurvivorStats.SurvivorWins.Value==9 and ad.Currency.RbxSpent.Value==300,"legacy data was rewritten")
assert(not ad.SurvivorStats.SurvivorWins:GetAttribute("CombatStat")and not ad.Currency.RbxSpent:GetAttribute("CombatStat"))
closing()
print("PASS actual saved combat counters: friendly-fire kills, all-cause deaths, native cleanup/Died deduplication, role totals, best time/streak, role switches, fractional leave flush, lobby exclusion, legacy preservation and forced Friendly Fire")
