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
