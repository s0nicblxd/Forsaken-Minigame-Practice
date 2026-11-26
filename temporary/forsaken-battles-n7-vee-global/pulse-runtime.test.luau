
local time=0
local os={clock=function() return time end}
local function signal()
 local s={listeners={}}
 function s:Connect(fn) local c={Connected=true};function c:Disconnect()self.Connected=false end;table.insert(self.listeners,{fn=fn,c=c});return c end
 function s:Fire(...) for _,l in ipairs(self.listeners) do if l.c.Connected then l.fn(...) end end end
 return s
end
local function pos(x)
 return setmetatable({x=x},{__sub=function(a,b)return {Magnitude=math.abs(a.x-b.x)}end})
end
local folder={Name="Survivors",children={},ChildAdded=signal()}
function folder:GetChildren()return self.children end
local otherFolder={Name="Killers"}
local heartbeat=signal()
local actors={CurrentActors={},rewards={}}
function actors:IncrementActorStats(player,data)table.insert(self.rewards,data) end
local players={}
function players:GetPlayerFromCharacter(rig)return rig.player end
local effects={}
local statuses={ApplyStatus=function(_,rig,name,data)table.insert(effects,{rig=rig,name=name,data=data}) end}
local network={events={}}
function network:FireAllClientConnection(name,kind,method,...)table.insert(self.events,{method=method,args={...}})end
function network:FireClientConnection(player,name,kind,method,...)table.insert(self.events,{method=method,args={...},player=player})end
local util={}
function util:CreateSpeedMultiplier(_,value,name) local m={Value=value,Name=name};function m:Destroy()self.destroyed=true end;return m end
local sounds={Play=function()return {Destroy=function()end}end}
local modules={Actors=actors,Statuses=statuses,Util=util,Sounds=sounds,Network=network}
local workspace={FindFirstChild=function(_,name)if name=="Players" then return {FindFirstChild=function(_,name)if name=="Survivors"then return folder end end}end end}
local game={ReplicatedStorage={Modules=modules}}
function game:GetService(name)if name=="RunService"then return {Heartbeat=heartbeat,IsServer=function()return true end} elseif name=="Players"then return players end end
local Rules=(function()
-- Corrected Helperbot moveset. Pure rules shared by the server and regression tests.
local Rules={}
function Rules.Level(charges) return math.clamp(math.floor(tonumber(charges) or 0),0,3) end
function Rules.Radius(charges) return ({30,33,36,39})[Rules.Level(charges)+1] end
function Rules.BuffDuration(charges,additionalHelpers,otherHelper)
 local duration=math.max(3,4+Rules.Level(charges)-1.5*math.max(0,additionalHelpers))
 return duration*(otherHelper and .5 or 1)
end
function Rules.Haste(additionalHelpers) return math.max(1,5-math.max(0,additionalHelpers)) end
function Rules.CooldownDelta(dt,level,support) return dt*.1*level*(support and .5 or 1) end
function Rules.Progress(progress,inside,dt) return math.clamp(progress+(inside and dt or -dt*.7),0,5) end
return Rules

end)()
local script={Parent={Rules=Rules}}
local require=function(m)return m end
modules.GameplayPolish=(function()
local RunService=game:GetService("RunService")
local Support={}
function Support.CloneLifetime(config,mode)
 return mode=="cursor"and(config.CursorCloneLifetime or config.CloneLifetime*.5)or config.CloneLifetime
end
function Support.PulseReward(hits)
 local tier=math.clamp(math.floor(hits or 0),0,3)
 return tier*2,tier*13
end
function Support.SurvivorXP(amount,isSurvivor)return amount*(isSurvivor and 2 or 1)end
function Support.Remaining(endsAt,now)return type(endsAt)=="number"and math.max(0,endsAt-now)or 0 end
function Support.RecoveryFraction(remaining)return math.clamp(remaining/3,0,1)end
function Support.TeleportReward(actor,oldPosition)
 local close=false
 local players=workspace:FindFirstChild("Players")
 local killers=players and players:FindFirstChild("Killers")
 if killers then
  for _,rig in killers:GetChildren()do
   local hum=rig:FindFirstChildOfClass("Humanoid")
   if hum and hum.Health>0 and rig.PrimaryPart and(rig.PrimaryPart.Position-oldPosition).Magnitude<=30 then close=true;break end
  end
 end
 require(game.ReplicatedStorage.Modules.Actors):IncrementActorStats(actor.Player,{Action=close and "Escaped from a Killer with c00lgui"or "Teleported with c00lgui",Money=3,EXP=30})
end
function Support.CloneTracker(actor,clone,duration)
 local rig=actor.Rig
 local deadline=workspace:GetServerTimeNow()+duration
 rig:SetAttribute("N7CloneEndsAt",deadline)
 local done=false
 local connections={}
 local function clear()
  if done then return end
  done=true
  for _,connection in connections do connection:Disconnect()end
  if rig.Parent and rig:GetAttribute("N7CloneEndsAt")==deadline then rig:SetAttribute("N7CloneEndsAt",nil)end
 end
 local hum=clone:FindFirstChildOfClass("Humanoid")
 if hum then table.insert(connections,hum.Died:Connect(clear))end
 table.insert(connections,clone.Destroying:Connect(clear))
 table.insert(connections,rig.Destroying:Connect(clear))
 task.delay(duration,clear)
end
function Support.AttachHUD(character,ui,center,scriptRoot,sprinting)
 local connections={}
 local owned={center}
 local stamina=ui.Bars.Stamina
 local drain=stamina:FindFirstChild("Drain")
 local centralTemplate=scriptRoot:FindFirstChild("Drain")
 local central=centralTemplate and centralTemplate:Clone()
 if central then central.Name="StaminaRecoveryDrain";central.ZIndex=10000;central.Parent=center.Parent;table.insert(owned,central)end
 local label=Instance.new("TextLabel")
 label.Name="StaminaRecoveryTime";label.BackgroundTransparency=1;label.TextColor3=Color3.fromRGB(255,210,120);label.TextStrokeTransparency=.3
 label.Font=Enum.Font.GothamMedium;label.TextSize=12;label.Size=UDim2.new(1,0,0,16);label.Position=UDim2.new(0,0,1,3);label.Parent=center;table.insert(owned,label)
 local cloneLabel=nil
 local alive=true
 local elapsed=0
 local function cleanup()
  if not alive then return end
  alive=false
  for _,connection in connections do connection:Disconnect()end
  for _,object in owned do object:Destroy()end
  if cloneLabel then cloneLabel:Destroy();cloneLabel=nil end
 end
 table.insert(connections,RunService.RenderStepped:Connect(function(dt)
  if not character.Parent or not ui.Parent then cleanup();return end
  elapsed+=dt;if elapsed<.05 then return end;elapsed=0
  local remaining=math.max(0,sprinting.timeUntilStaminaRecovers or 0)
  local visible=remaining>0 and ui.Visible and sprinting.Stamina<(sprinting.StaminaCap or sprinting.MaxStamina)
  if drain then
   drain.Visible=visible
   local fill=drain:FindFirstChild("Fill")
   if fill then fill.Size=UDim2.fromScale(Support.RecoveryFraction(remaining),1)end
  end
  label.Visible=visible and center.Visible
  label.Text=string.format("Regen %.1fs",remaining)
  if central then
   central.Visible=label.Visible
   central.AnchorPoint=center.AnchorPoint
   central.Position=center.Position+UDim2.fromOffset(0,center.AbsoluteSize.Y*.6)
   central.Size=UDim2.fromOffset(math.max(30,center.AbsoluteSize.X)*Support.RecoveryFraction(remaining),3)
  end
  local deadline=character:GetAttribute("N7CloneEndsAt")
  local left=Support.Remaining(deadline,workspace:GetServerTimeNow())
  local player=game.Players.LocalPlayer
  local temporary=player.PlayerGui:FindFirstChild("TemporaryUI")
  local abilities=temporary and temporary:FindFirstChild("AbilityContainer")
  local button=abilities and abilities:FindFirstChild("Clone")
  if left>0 and button then
   if not cloneLabel or cloneLabel.Parent~=button then
    if cloneLabel then cloneLabel:Destroy()end
    cloneLabel=Instance.new("TextLabel");cloneLabel.Name="CloneDurationTracker";cloneLabel.BackgroundColor3=Color3.new(0,0,0);cloneLabel.BackgroundTransparency=.25
    cloneLabel.TextColor3=Color3.new(1,1,1);cloneLabel.Font=Enum.Font.GothamBold;cloneLabel.TextSize=13
    cloneLabel.AnchorPoint=Vector2.new(.5,1);cloneLabel.Position=UDim2.fromScale(.5,-.05);cloneLabel.Size=UDim2.new(1,0,0,18);cloneLabel.Parent=button
   end
   cloneLabel.Visible=true;cloneLabel.Text=string.format("%.1fs",left)
  elseif cloneLabel then cloneLabel.Visible=false end
 end))
 table.insert(connections,character.Destroying:Connect(cleanup))
 table.insert(connections,ui.Destroying:Connect(cleanup))
 return cleanup
end
return Support

end)()
local Server=(function()
local RunService=game:GetService("RunService")
local Players=game:GetService("Players")
local Modules=game.ReplicatedStorage.Modules
local Actors=require(Modules.Actors)
local Statuses=require(Modules.Statuses)
local Util=require(Modules.Util)
local Sounds=require(Modules.Sounds)
local Network=require(Modules.Network)
local Rules=require(script.Parent.Rules)
local GameplayPolish=require(game.ReplicatedStorage.Modules.GameplayPolish)
local Server={}
local function alive(rig)
 local hum=rig and rig:FindFirstChildOfClass("Humanoid")
 return rig and rig.Parent and rig.PrimaryPart and hum and hum.Health>0
end
local function active(a) return not a.HelperDestroyed and alive(a.Rig) end
local function survivors()
 local folder=workspace:FindFirstChild("Players")
 return folder and folder:FindFirstChild("Survivors")
end
local function actorFor(rig)
 local player=Players:GetPlayerFromCharacter(rig)
 if player and Actors.CurrentActors[player] then return Actors.CurrentActors[player] end
 for _,a in pairs(Actors.CurrentActors) do if a.Rig==rig then return a end end
end
local function helpers(a)
 local n,seen=0,{}
 for _,other in pairs(Actors.CurrentActors) do
  if other~=a and other.ActorName=="Helperbot" and alive(other.Rig) and other.Rig.Parent==survivors() and not seen[other.Rig] then seen[other.Rig]=true;n+=1 end
 end
 return n
end
local function emit(a,method,...)
 if a.Player then Network:FireAllClientConnection(a.Player.Name.."PCallAllClients","REMOTE_EVENT",method,...) end
end
local function localEmit(a,method,...)
 if a.Player and a.Player:IsA("Player") then Network:FireClientConnection(a.Player,a.Player.Name.."PCallLocal","REMOTE_EVENT",method,...) end
end
local function sound(a,key,options)
 if not active(a) then return end
 local id=a.Config.Sounds and a.Config.Sounds[key]
 if not id or id=="" then return end
 options=options or {};options.Parent=options.Parent or a.Rig.PrimaryPart;options.Volume=options.Volume or .25
 local ok,result=pcall(Sounds.Play,Sounds,id,options)
 if ok then return result end
end
local function lock(a,name,on)
 a.AbilityDisablers=a.AbilityDisablers or {};a.AbilityDisablers["Helperbot"..name]=on or nil
end
local function clearCast(a)
 local cast=a.HelperCast
 if not cast then return end
 a.HelperCast=nil
 if cast.health then cast.health:Disconnect() end
 if cast.speed then cast.speed:Destroy() end
 lock(a,cast.name,false)
end
local function interrupted(a)
 local rig=a.Rig
 return rig:GetAttribute("Stunned") or rig:GetAttribute("Helpless") or rig:GetAttribute("Ragdolling") or rig:GetAttribute("AbilitiesDisabled") or rig.PrimaryPart.Anchored
end
local function charges(a,n,reward)
 local before=a.HelperCharges or 1
 a.HelperCharges=Rules.Level(n);a.Rig:SetAttribute("PulseCharges",a.HelperCharges)
 localEmit(a,"OnChargeLevelChanged",a.HelperCharges,"Pulse")
 if reward and a.HelperCharges>before and a.Player and a.Player:IsA("Player") then
  Actors:IncrementActorStats(a.Player,{Action="Leveled up Pulse",Money=2,EXP=13,KillerChance=.25})
 end
end
local function stopZone(a)
 local zone=a.HelperZone
 if not zone then return end
 a.HelperZone=nil
 if zone.loop then zone.loop:Destroy() end
 emit(a,"DestroyZoneVisual",zone.id)
 sound(a,"InspireEnd")
end
function Server.Interrupt(a)
 local cast=a.HelperCast
 if cast then
  if cast.name=="Pulse" then
   emit(a,"OnPulseInterrupted");sound(a,"PulseInterrupted")
   if a.SetCooldownOf then a:SetCooldownOf("Pulse",44) end
  end
  clearCast(a)
 end
end
function Server.Pulse(a)
 if not active(a) or a.HelperCast or interrupted(a) then return {Cancelled=true} end
 local cast={name="Pulse",ends=os.clock()+2}
 a.HelperCast=cast;lock(a,"Pulse",true)
 cast.speed=Util:CreateSpeedMultiplier(a.Player or a.Rig,.9,"HelperbotPulseWindup")
 local hum=a.Rig:FindFirstChildOfClass("Humanoid");local previous=hum.Health
 cast.health=hum.HealthChanged:Connect(function(health)
  local damaged=health<previous;previous=health
  if damaged and a.HelperCast==cast then Server.Interrupt(a) end
 end)
 emit(a,"OnPulseWindup");sound(a,"PulseWindup")
end
function Server.Inspiration(a)
 if not active(a) or a.HelperCast or a.HelperZone or interrupted(a) then return {Cancelled=true} end
 a.HelperCast={name="Inspiration",ends=os.clock()+.75}
 lock(a,"Inspiration",true)
 a.HelperCast.speed=Util:CreateSpeedMultiplier(a.Player or a.Rig,.01,"HelperbotInspireWindup")
 sound(a,"InspireWindup")
end
local function applyPulse(a,rig,level,count)
 local other=actorFor(rig)
 local duration=Rules.BuffDuration(level,count,rig~=a.Rig and other and other.ActorName=="Helperbot")
 -- Veeronica does not receive healing, but can receive Resistance.
 if not (other and (other.ActorName=="Veeronica" or other.ActorName=="Vee")) then
  Statuses:ApplyStatus(rig,"Regeneration",{Level=1,Duration=duration,AppliedFrom="HelperbotPulse"})
 end
 Statuses:ApplyStatus(rig,"Resistance",{Level=1,Duration=duration,AppliedFrom="HelperbotPulse"})
 emit(a,"OnPulseHit",rig,true)
 sound(a,"PulseHitPositive",{Parent=rig.PrimaryPart})
end
local function releasePulse(a)
 local level=a.HelperCharges or 1
 local radius=Rules.Radius(level)
 charges(a,0,false)
 emit(a,"OnPulseEmitted",radius,radius);sound(a,"Pulse")
 a.HelperWaves=a.HelperWaves or {}
 table.insert(a.HelperWaves,{origin=a.Rig.PrimaryPart.Position,radius=radius,level=level,elapsed=0,started=os.clock(),hit={},targets=0,helpers=helpers(a)})
 -- Retain the 0.75s recovery and windup slowdown without a stale timer unlocking another cast.
 local cast=a.HelperCast
 if cast.speed then cast.speed:Destroy();cast.speed=nil end
 if cast.health then cast.health:Disconnect();cast.health=nil end
 cast.recovery=true;cast.ends=os.clock()+.75
end
local function startZone(a)
 a.HelperZoneSerial=(a.HelperZoneSerial or 0)+1
 local id=tostring(a.HelperZoneSerial)
 a.HelperZone={id=id,remaining=10,last=os.clock(),elapsed=0,progress={},granted={},inside={}}
 emit(a,"CreateZoneVisual",id,16);sound(a,"Inspire")
 a.HelperZone.loop=sound(a,"InspireLoop",{Looped=true})
 if a.HelperCast.speed then a.HelperCast.speed:Destroy();a.HelperCast.speed=nil end
 a.HelperCast.recovery=true;a.HelperCast.ends=os.clock()+.75
end
local function updateZone(a,dt)
 local z=a.HelperZone
 if not z then return end
 -- Integrate only the portion of the frame within the aura's fixed lifetime.
 local now=os.clock();dt=math.min(math.max(0,now-z.last),z.remaining);z.last=now
 z.remaining-=dt;z.elapsed+=dt
 local folder=survivors();local nowInside={};local haste=Rules.Haste(helpers(a))
 if folder then for _,rig in ipairs(folder:GetChildren()) do
  if alive(rig) and (rig.PrimaryPart.Position-a.Rig.PrimaryPart.Position).Magnitude<=16 then
   nowInside[rig]=true
   -- Refresh every half-second. Self receives Haste too, excluding Inspiration.
   if z.elapsed>=.5 then Statuses:ApplyStatus(rig,"Haste",{Level=haste,Duration=2,DisabledAbilityNames={"Inspiration"},AppliedFrom="HelperbotInspiration"}) end
   if rig~=a.Rig and not z.granted[rig] then
    local progress=Rules.Progress(z.progress[rig] or 0,true,dt);z.progress[rig]=progress
    if not z.inside[rig] then
     emit(a,"InspireMeterUpdate","CharacterEnteredInspire",rig,math.max(0,progress-dt)/5,5-math.max(0,progress-dt),z.id)
     sound(a,"InspirePlayerEntered",{Parent=rig.PrimaryPart})
    end
    if progress>=5 then
     z.granted[rig]=true
     charges(a,(a.HelperCharges or 0)+1,true)
     emit(a,"InspireMeterUpdate","CharacterGaveCharge",rig,z.id)
    end
   end
  end
 end end
 for rig,progress in pairs(z.progress) do
  if not nowInside[rig] and not z.granted[rig] then
   if z.inside[rig] then
    emit(a,"InspireMeterUpdate","CharacterLeftInspire",rig,progress/5,progress/.7,z.id)
    if alive(rig) then sound(a,"InspirePlayerLeft",{Parent=rig.PrimaryPart}) end
   end
   z.progress[rig]=Rules.Progress(progress,false,dt)
   if z.progress[rig]<=0 or not alive(rig) then
    emit(a,"InspireMeterUpdate","CharacterChargeRemoved",rig,z.id)
    z.progress[rig]=nil
   end
  end
 end
 z.inside=nowInside
 if z.elapsed>=.5 then z.elapsed=0 end
 if z.remaining<=0 then stopZone(a) end
end
local function step(a,dt)
 if not active(a) then Server.Destroyed(nil,a);return end
 local cast=a.HelperCast
 if cast then
  if not cast.recovery and interrupted(a) then Server.Interrupt(a)
  elseif os.clock()>=cast.ends then
   if cast.recovery then clearCast(a)
   elseif cast.name=="Pulse" then releasePulse(a)
   else startZone(a) end
  end
 end
 for i=#a.HelperWaves,1,-1 do
  local wave=a.HelperWaves[i];wave.elapsed=os.clock()-wave.started
  local reach=math.min(wave.radius,wave.elapsed*wave.radius)
  local folder=survivors()
  if folder then for _,rig in ipairs(folder:GetChildren()) do
   if alive(rig) and not wave.hit[rig] and (rig.PrimaryPart.Position-wave.origin).Magnitude<=reach then
    wave.hit[rig]=true;applyPulse(a,rig,wave.level,wave.helpers)
    if rig~=a.Rig and actorFor(rig)then wave.targets+=1 end
   end
  end end
  if wave.elapsed>=1 then
   local money,xp=GameplayPolish.PulseReward(wave.targets)
   if money>0 then Actors:IncrementActorStats(a.Player,{Action="Pulse hit "..tostring(math.min(wave.targets,3))..(wave.targets>=3 and "+ Survivors"or " Survivor(s)"),Money=money,EXP=xp})end
   table.remove(a.HelperWaves,i)
  end
 end
 updateZone(a,dt)
 a.HelperRadarElapsed+=dt
 if a.HelperRadarElapsed>=12 then a.HelperRadarElapsed%=12;emit(a,"RadarScan") end
end
function Server.Created(_,a)
 a.HelperDestroyed=false;a.HelperConnections={};a.HelperWaves={};a.HelperRadarElapsed=0
 charges(a,1,false)
 -- FCT increments this server-owned counter for non-primary ability use. Watch actual changes rather than guessing from cooldown changes/Haste.
 local watched={}
 local function watch(rig)
  if watched[rig] or rig==a.Rig then return end
  watched[rig]=true
  table.insert(a.HelperConnections,rig:GetAttributeChangedSignal("AbilitiesUsed"):Connect(function()
   if active(a) and alive(rig) and rig.Parent==survivors() then localEmit(a,"ShowSurvivorAura",rig) end
  end))
 end
 local folder=survivors()
 if folder then for _,rig in ipairs(folder:GetChildren()) do watch(rig) end;table.insert(a.HelperConnections,folder.ChildAdded:Connect(watch)) end
 table.insert(a.HelperConnections,RunService.Heartbeat:Connect(function(dt) step(a,dt) end))
 table.insert(a.HelperConnections,a.Rig:FindFirstChildOfClass("Humanoid").Died:Connect(function() Server.Destroyed(nil,a) end))
end
function Server.Destroyed(_,a)
 if a.HelperDestroyed then return end
 a.HelperDestroyed=true
 clearCast(a);stopZone(a)
 for _,connection in ipairs(a.HelperConnections or {}) do connection:Disconnect() end
 a.HelperConnections={};a.HelperWaves={}
 emit(a,"PortCleanup")
end
function Server.OnHelpless(_,a) Server.Interrupt(a) end
Server.OnStunned=Server.OnHelpless
return Server

end)()
local function character(name,x,actorName,class)
 local hum={Health=80,MaxHealth=80,HealthChanged=signal(),Died=signal()}
 local rig={Name=name,Parent=folder,PrimaryPart={Position=pos(x)},attributes={},signals={}}
 function rig:FindFirstChildOfClass(c)if c=="Humanoid"then return hum end end
 function rig:GetAttribute(k)return self.attributes[k]end
 function rig:SetAttribute(k,v) self.attributes[k]=v;if self.signals[k] then self.signals[k]:Fire()end end
 function rig:GetAttributeChangedSignal(k)self.signals[k]=self.signals[k]or signal();return self.signals[k]end
 local player={Name=name,Character=rig,Parent=players,IsA=function(_,c)return c=="Player"end};rig.player=player
 local a={Rig=rig,Player=player,ActorName=actorName or "Noob",Config={Class=class or "Survivalist",Sounds={}},Behavior={Abilities={}},cooldowns={},AbilityDisablers={Other=true}}
 function a:SetCooldownOf(k,n)self.cooldowns[k]=n end
 actors.CurrentActors[player]=a
 table.insert(folder.children,rig);folder.ChildAdded:Fire(rig)
 return a,hum
end
local function advance(dt)
 time+=dt;heartbeat:Fire(dt)
end
local function findEffect(rig,name)
 for i=#effects,1,-1 do if effects[i].rig==rig and effects[i].name==name then return effects[i].data end end
end

local function scenario(count)
 folder.children={};actors.CurrentActors={};actors.rewards={}
 local a,hum=character("Caster",0,"Helperbot","Support");Server.Created(nil,a)
 for i=1,count do character("Target"..i,5+i,i==count and "Helperbot"or "Noob")end
 Server.Pulse(a);advance(2);advance(.5)
 assert(#actors.rewards==0,"paid before wave completed")
 advance(.5)
 if count==0 then assert(#actors.rewards==0,"caster counted itself")
 else
  assert(#actors.rewards==1,"reward was not once per wave")
  assert(actors.rewards[1].Money==math.min(count,3)*2 and actors.rewards[1].EXP==math.min(count,3)*13,"wrong capped tier or excluded other Helperbot")
 end
 local rewards=#actors.rewards;advance(2);assert(#actors.rewards==rewards,"wave paid twice")
 Server.Destroyed(nil,a)
end
for _,count in {0,1,2,3,5}do scenario(count)end
folder.children={};actors.CurrentActors={};actors.rewards={}
local a,hum=character("Interrupted",0,"Helperbot","Support");Server.Created(nil,a)
character("Target",5,"Noob")
Server.Pulse(a);hum.Health-=10;hum.HealthChanged:Fire(hum.Health);advance(4)
assert(#actors.rewards==0,"interrupted Pulse paid hit reward")
print("PASS actual Helperbot Pulse: caster excluded, other Helperbots included, 0/1/2/3+/5 targets, cap, duplicate hits, one award per wave and interrupted cast")
