
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
local function typeof(value)if type(value)=="table"and value._cf then return "CFrame"end;if type(value)=="table"and value._props then return "Instance"end;return nativeTypeof(value)end
local function signal()
 local entries={}
 return {Connect=function(_,callback)
  local object={Active=true};function object:Disconnect()self.Active=false end
  table.insert(entries,{object,callback});return object
 end,Fire=function(_,...)
  for _,entry in table.clone(entries)do if entry[1].Active then entry[2](...)end end
 end,Count=function()local n=0;for _,entry in entries do if entry[1].Active then n+=1 end end;return n end}
end

fresh()
local now=100
local os={clock=function()return now end}
function workspace:GetServerTimeNow()return now end
local vmt={}
local function v(x,y,z)return setmetatable({X=x,Y=y,Z=z},vmt)end
function vmt.__index(a,key)if key=="Magnitude"then return math.sqrt(a.X*a.X+a.Y*a.Y+a.Z*a.Z)end end
function vmt.__add(a,b)return v(a.X+b.X,a.Y+b.Y,a.Z+b.Z)end
function vmt.__sub(a,b)return v(a.X-b.X,a.Y-b.Y,a.Z-b.Z)end
function vmt.__mul(a,b)return v(a.X*b,a.Y*b,a.Z*b)end
local cfm={}
local function cf(pos)return setmetatable({_cf=true,Position=pos,RightVector=v(1,0,0),UpVector=v(0,1,0),LookVector=v(0,0,-1)},cfm)end
function cfm.__index(a,key)
 if key=="GetComponents"then return function(self)return self.Position.X,self.Position.Y,self.Position.Z,1,0,0,0,1,0,0,0,1 end end
 if key=="Rotation"then local result=cf(v(0,0,0));result.LookVector=a.LookVector;return result end
 if key=="ToObjectSpace"then return function(self,other)return cf(other.Position-self.Position)end end
end
function cfm.__mul(a,b)
 local look=a.LookVector
 local pos=v(-look.Z*b.Position.X-look.X*b.Position.Z,b.Position.Y,look.X*b.Position.X-look.Z*b.Position.Z)
 local result=cf(a.Position+pos);result.LookVector=b.LookVector;return result
end
local Vector3={new=v}
local CFrame={new=function(x,y,z)return cf(type(x)=="table"and x or v(x or 0,y or 0,z or 0))end,lookAt=function(position,target)local result=cf(position);result.LookVector=target-position;return result end}
local RaycastParams={new=function()return {}end};local OverlapParams={new=function()return {}end}
local Enum={RaycastFilterType={Exclude=1},BulkMoveMode={FireCFrameChanged=1}}
function workspace:BulkMoveTo(parts,frames)for i,part in parts do part.CFrame=frames[i];part.Position=frames[i].Position end end
local Color3={new=function()return {}end}
function Methods:AddTag(name)self:SetAttribute("Tag_"..name,true)end
function Methods:IsDescendantOf(parent)local object=self.Parent;while object do if object==parent then return true end;object=object.Parent end;return false end
local cloneBase=Methods.Clone
function Methods:Clone()
 local result=cloneBase(self)
 if self.PrimaryPart then result.PrimaryPart=result:FindFirstChild(self.PrimaryPart.Name,true)end
 return result
end
function Methods:PivotTo(frame)
 self.PivotCalls=(self.PivotCalls or 0)+1
 local delta=frame.Position-self.PrimaryPart.CFrame.Position
 for _,part in self:GetDescendants()do if part:IsA("BasePart")then part.CFrame=CFrame.new(part.CFrame.Position+delta);part.Position=part.CFrame.Position end end
end
local players=child(workspace,"Players");local survivors=child(players,"Survivors");local killers=child(players,"Killers")
local map=child(workspace,"Map");child(map,"Ingame")
local floor=child(map,"Floor","Part");floor.Transparency=0
local blocked=false;local wall=false;local grounded=true
function workspace:Raycast(origin,direction)
 if direction.Y<0 then return grounded and {Position=v(origin.X,0,origin.Z),Normal=v(0,1,0),Instance=floor}or nil end
 return wall and {Instance=floor}or nil
end
function workspace:GetPartBoundsInBox()
 if blocked then local block=child(map,"Block","Part");block.Transparency=0;return {floor,block}end
 return {}
end
local heartbeat=signal()
local RunService={Heartbeat=heartbeat}
local Debris={AddItem=function()end}
local Actors={CurrentActors={},rewards={}}
function Actors:IncrementActorStats(player,data)table.insert(self.rewards,data)end
local Network={events={}}
function Network:FireClientConnection(player,name,kind,...)table.insert(self.events,{name=name,args={...}})end
function Network:FireAllClientConnection(name,kind,...)table.insert(self.events,{name=name,args={...}})end
local Util={}
function Util:CreateSpeedMultiplier(rig,value,name)local number=child(rig,name,"NumberValue");number.Value=value;return number end
function Util:LoadAnimationFromID()return nil end
function Util:RevealPlayerAuraTo()end
function Util:Heal(hum,value)hum.Health=math.min(hum.MaxHealth,hum.Health+value)end
local Statuses={calls={}}
function Statuses:ApplyStatus(rig,name,data)table.insert(self.calls,{rig=rig,name=name,data=data})end
local Sounds={Play=function()end}
local Rules=(function()
local Rules={}
function Rules.ActivityRemaining(last,now)return type(last)=="number"and math.max(0,10-(now-last))or 0 end
function Rules.EffectRadius(config,kind,count)
 local radius=config[kind=="Sentry"and "SentryDamageRadius"or "DispenserHealingRadius"]/2
 if kind=="Sentry"then radius=math.clamp(radius*(1-math.max(0,count-1)*config.SentryRangeReductionPercentage/100),config.SentryMinimumRange,radius)end
 return radius
end
function Rules.SlowLevel(config,builders)return builders>1 and config.SentryStackedSlownessLevel or config.SentrySlownessLevel end
function Rules.Points(kind,value)
 return math.ceil(math.clamp(kind=="Sentry"and value^.5*1.2 or value^.95*.35,0,20))
end
return Rules

end)()
local modules=game.ReplicatedStorage.Modules
modules.Actors=Actors;modules.Network=Network;modules.Util=Util;modules.Statuses=Statuses;modules.Sounds=Sounds
local getter=game.GetService
function game:GetService(name)if name=="RunService"then return RunService elseif name=="Debris"then return Debris end;return getter(self,name)end
local script={Parent={Rules=Rules}}
local function require(value)return value end
local TweenInfo={new=function()return {}end}
Enum.ExplosionType={NoCraters=1}
local TweenService={Create=function(_,object,info,props)return {Play=function()for key,value in props do object[key]=value end end}end}
local serviceGetter=game.GetService
function game:GetService(name)if name=="TweenService"then return TweenService elseif name=="Players"then return {GetPlayers=function()return {}end}end;return serviceGetter(self,name)end
local ss=child(game,"ServerScriptService");local server=child(ss,"Server");local systems=child(server,"Systems");local data=child(systems,"Data")
local tracker=child(data,"CombatStatistics","ModuleScript");function tracker:RecordDamage()end
function Methods:GetPlayingAnimationTracks()return {}end


local originalNew=Instance.new
function Instance.new(class,parent)local result=originalNew(class,parent);result.Destroying=signal();result.Died=signal();return result end
local queue={}
local task={delay=function(delay,callback)table.insert(queue,{delay=delay,callback=callback})end}
local Support=(function()
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
assert(Support.CloneLifetime({CloneLifetime=10,CursorCloneLifetime=5},"cursor")==5)
assert(Support.CloneLifetime({CloneLifetime=10},"aimless")==10)
assert(Support.CloneLifetime({CloneLifetime=10},"cursor")==5)
assert(Support.SurvivorXP(30,true)==60 and Support.SurvivorXP(30,false)==30)
assert(Support.Remaining(105,100)==5 and Support.Remaining(99,100)==0 and Support.Remaining(nil,100)==0)
assert(Support.RecoveryFraction(5)==1 and Support.RecoveryFraction(1.5)==.5)
local rig=child(survivors,"n7","Model")
local actor={Rig=rig,Player={}}
local killer=child(killers,"Killer","Model");killer.PrimaryPart=child(killer,"Root","Part");killer.PrimaryPart.Position=v(0,0,-30)
local hum=child(killer,"Humanoid","Humanoid");hum.Health=100
Support.TeleportReward(actor,v(0,0,0))
local reward=Actors.rewards[#Actors.rewards]
assert(reward.Money==3 and reward.EXP==30 and reward.Action=="Escaped from a Killer with c00lgui")
killer.PrimaryPart.Position=v(0,0,-31);Support.TeleportReward(actor,v(0,0,0))
assert(Actors.rewards[#Actors.rewards].Action=="Teleported with c00lgui")
local clone=child(map,"Clone","Model");local cloneHum=child(clone,"Humanoid","Humanoid")
Support.CloneTracker(actor,clone,5);assert(rig:GetAttribute("N7CloneEndsAt")==now+5)
cloneHum.Died:Fire();assert(not rig:GetAttribute("N7CloneEndsAt"))
local clone2=child(map,"Clone2","Model");child(clone2,"Humanoid","Humanoid")
Support.CloneTracker(actor,clone,5);now+=.1;Support.CloneTracker(actor,clone2,10)
cloneHum.Died:Fire();assert(rig:GetAttribute("N7CloneEndsAt")==now+10,"old clone cleared newest tracker")
print("PASS n7 clone lifetimes, tracking cleanup/generation, one reward per completion, 30-stud boundary and role XP/recovery calculations")

local player=Instance.new("Player");local data=child(player,"PlayerData");local root=child(data,"Purchased")
local surv=child(root,"Survivors");local kill=child(root,"Killers")
local exp=child(surv,"n7","NumberValue");exp.Value=0
local killerExp=child(kill,"Slasher","NumberValue");killerExp.Value=0
local account=child(game.ServerScriptService.Server,"Miscellaneous");local account2=child(account,"Account");account2.TrackPlayerFriendBoost={GetPlayerBoost=function()return 0 end}
function Actors.GiveEXP(_: {[any]: any}, p23, p24, n8: number) -- line: 842
	local PlayerData = p23:FindFirstChild("PlayerData")

	if not PlayerData then
		return false
	end

	local TrackPlayerFriendBoost = require(game.ServerScriptService.Server.Miscellaneous.Account.TrackPlayerFriendBoost)
	local v134 = p23:GetAttribute("EXPMultiplier") or 1
	local EXPBoostTime = PlayerData:FindFirstChild("EXPBoostTime", true)

	if EXPBoostTime and EXPBoostTime.Value > 0 then
		v134 += 0.25
	end

	local PlayerBoost = TrackPlayerFriendBoost:GetPlayerBoost(p23)

	if PlayerBoost then
		v134 += PlayerBoost
	end

	if tonumber(n8) then
		local isSurvivor=p24 and p24.Parent and p24.Parent.Name=="Survivors"
        n8 *= v134 * (isSurvivor and 2 or 1)
	end

	local num = tonumber(string.format("%.2f", n8))

	if p24 then
		p24.Value = p24.Value + tonumber(num)
	end

	return num
end

assert(Actors:GiveEXP(player,exp,30)==60 and exp.Value==60)
assert(Actors:GiveEXP(player,killerExp,30)==30 and killerExp.Value==30)
player:SetAttribute("EXPMultiplier",2)
assert(Actors:GiveEXP(player,exp,30)==120,"boost interaction wrong")
print("PASS actual shared GiveEXP: survivor 2x, killer unchanged, boost multiplication retained")

local invincible={}
function Util:GiveInvincible(character,key)invincible[key]=true end
function Util:RemoveInvincible(character,key)invincible[key]=nil end
function Util:GiveStackableAttribute(character,name,key,duration)character:SetAttribute(name,true)end
function Util:RemoveStackableAttribute(character,name,key)character:SetAttribute(name,nil)end
local Rules={CountSentinels=function()return 1 end,Duration=function()return 5 end}
script={Rules=Rules}
RunService.IsServer=function()return true end;RunService.IsClient=function()return false end
local Stunned=(function()
-- FCT lifecycle + UPD immunity timing. Existing combat damage behavior is preserved.
local RunService=game:GetService("RunService")
local Modules=game.ReplicatedStorage.Modules
local Actors=require(Modules.Actors)
local Util=require(Modules.Util)
local Rules=require(script.Rules)
local Stunned={Data={Duration=6,MaxLevel=1,IsNegative=true,Stackable=false,TimeStackable=false,Hidden=false}}
local function actorFor(status)
 return Actors.CurrentActors[status.Player] or Actors.CurrentActors[status.Character]
end
local function sound(actor,name)
 local id=actor and actor.Config and actor.Config.Sounds and actor.Config.Sounds[name]
 if id and actor.Rig and actor.Rig.PrimaryPart then require(Modules.Sounds):Play(id,{Parent=actor.Rig.PrimaryPart}) end
end
local function cancelOverride(status)
 local thread=status.UnstunThread;status.UnstunThread=nil
 if thread and thread~=coroutine.running() then pcall(task.cancel,thread) end
end
function Stunned.Applied(status)
 if RunService:IsClient() then
  local actor=actorFor(status)
  local animation=actor and actor.Animations and actor.Animations.Stunned
  local behavior=actor and actor.Behavior
  if behavior then
   local callback=status.Data.StunDuration and type(animation)=="table" and animation.Cancel and behavior.OnStunnedEnd or behavior.OnStunned
   if callback then callback(behavior,actor,status.Data.StunDuration) end
  end
  if animation then
   if typeof(animation)=="table" then
    if status.Data.StunDuration and animation.Cancel then animation.Cancel:Play(0)
    else
     if animation.Start then animation.Start:Play(0) end
     if animation.Loop then animation.Loop:Play(0) end
     status.StunnedAnims=animation
    end
   else animation:Play(0) end
  end
  if not status.SpeedMultiplier then status.SpeedMultiplier=Util:CreateSpeedMultiplier(status.Player,0,"Stunned") end
  return
 end
 local character=status.Character
 if character.Parent and character.Parent.Name=="Killers"then
  local serial=(character:GetAttribute("FBStunSerial")or 0)+1
  character:SetAttribute("FBStunSerial",serial)
  Util:GiveInvincible(character,"FBStunned")
 end
 local actor=actorFor(status)
 -- Capture before Stunned attribute observers cancel the casting ability and clear its override.
 local override=actor and actor.Config and tonumber(actor.Config.StunDuration)
 if actor and actor.Behavior.GetStunOverride then override=actor.Behavior:GetStunOverride(actor) end
 if override and override>0 then status.Data.StunDuration=override end
 Util:GiveStackableAttribute(character,"StunnedDisabled","StunPort")
 character:SetAttribute("Stunned",true)
 if not actor then return end
 actor:DisableAbilities("Stunned",true)
 if actor.Behavior.OnStunned then actor.Behavior:OnStunned(actor,status.Data.StunDuration) end
 require(Modules.Sounds):PlayVoiceline(actor,"Stunned")
 sound(actor,"Stunned")
 override=override or (not actor.Behavior.GetStunOverride and tonumber(actor.Config.StunDuration) or nil)
 if override and override>0 then
  cancelOverride(status)
  status.UnstunThread=task.delay(override,function()
   status.UnstunThread=nil
   if not character.Parent or not character:GetAttribute("Stunned") then return end
   local statuses=require(Modules.Statuses)
   statuses:RemoveStatus(status.Player,"Stunned")
   local handled=actor.Behavior.OnUnstoppableBoost and actor.Behavior:OnUnstoppableBoost(actor)
   if not handled and not statuses:PlayerHasStatus(status.Player,"Speed") then statuses:ApplyStatus(status.Player,"Speed",{Level=1,Duration=3+Rules.CountSentinels(Actors.CurrentActors)}) end
   sound(actor,"StunEnded")
   if actor.Behavior.OnStunnedEnd then actor.Behavior:OnStunnedEnd(actor) end
  end)
  status.Data.StunDuration=override
 end
end
function Stunned.Removed(status)
 cancelOverride(status)
 if status.SpeedMultiplier then
  local multiplier=status.SpeedMultiplier;status.SpeedMultiplier=nil
  task.delay(status.StunnedAnims and status.StunnedAnims.End and .6 or .25,function()
   if multiplier.Parent then
    game.TweenService:Create(multiplier,TweenInfo.new(.75),{Value=1}):Play()
    game.Debris:AddItem(multiplier,.75)
   end
  end)
 end
 if status.StunnedAnims then
  for _,name in {"Start","Loop"} do if status.StunnedAnims[name] then status.StunnedAnims[name]:Stop() end end
  if status.StunnedAnims.End then status.StunnedAnims.End:Play() end
  status.StunnedAnims=nil
 end
 if RunService:IsServer() then
  local character=status.Character
  character:SetAttribute("Stunned",nil)
  if character.Parent and character.Parent.Name=="Killers"then
   local serial=character:GetAttribute("FBStunSerial")
   task.delay(1,function()
    if character.Parent and not character:GetAttribute("Stunned")and character:GetAttribute("FBStunSerial")==serial then Util:RemoveInvincible(character,"FBStunned")end
   end)
  end
  local duration=Rules.Duration(Rules.CountSentinels(Actors.CurrentActors),status.Data.ResonanceDuration)
  -- Replacing this named source cancels the old timer; unrelated immunity sources survive expiry.
  local humanoid=character:FindFirstChildOfClass("Humanoid")
  if character.Parent and humanoid and humanoid.Health>0 then Util:GiveStackableAttribute(character,"StunnedDisabled","StunPort",duration)
  else Util:RemoveStackableAttribute(character,"StunnedDisabled","StunPort") end
  local actor=actorFor(status)
  if actor then actor:DisableAbilities("Stunned",false) end
 end
end
function Stunned.Heartbeat() end
return Stunned

end)()
local character=child(killers,"StunnedKiller","Model");local humanoid=child(character,"Humanoid","Humanoid");humanoid.Health=100
local status={Character=character,Player={},Data={}}
Stunned.Applied(status);assert(invincible.FBStunned)
Stunned.Removed(status);local oldTimer=queue[#queue].callback;assert(invincible.FBStunned and queue[#queue].delay==1)
Stunned.Applied(status);oldTimer();assert(invincible.FBStunned,"old linger timer removed new stun protection")
Stunned.Removed(status);queue[#queue].callback();assert(not invincible.FBStunned and character:GetAttribute("StunnedDisabled"),"damage protection followed immunity timer")
print("PASS actual stun callbacks: full stun protection, 1s linger, overlapping stuns and separate stun immunity")
