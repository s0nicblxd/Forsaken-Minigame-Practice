
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
function Instance.new(class,parent)local object=originalNew(class,parent);object.Destroying=signal();return object end
RunService.RenderStepped=signal()
local dmt={}
local function ud(xs,xo,ys,yo)return setmetatable({X={Scale=xs,Offset=xo},Y={Scale=ys,Offset=yo}},dmt)end
function dmt.__add(a,b)return ud(a.X.Scale+b.X.Scale,a.X.Offset+b.X.Offset,a.Y.Scale+b.Y.Scale,a.Y.Offset+b.Y.Offset)end
local UDim2={new=ud,fromScale=function(x,y)return ud(x,0,y,0)end,fromOffset=function(x,y)return ud(0,x,0,y)end}
local Vector2={new=function(x,y)return {X=x,Y=y}end}
Enum.Font={GothamMedium=1,GothamBold=2}
Color3.fromRGB=function()return {}end
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
game.Players=child(game,"Players");local player=child(game.Players,"LocalPlayer","Player");game.Players.LocalPlayer=player
local playerGui=child(player,"PlayerGui");local temporary=child(playerGui,"TemporaryUI")
local abilities=child(temporary,"AbilityContainer","Frame");local button=child(abilities,"Clone","Frame")
local character=child(survivors,"n7","Model")
local ui=child(temporary,"PlayerInfo","Frame");ui.Visible=true
local bars=child(ui,"Bars","Frame");local stamina=child(bars,"Stamina","Frame");local drain=child(stamina,"Drain","ImageLabel");local fill=child(drain,"Fill","ImageLabel")
local center=child(temporary,"CenterStaminaCounter","TextLabel");center.Visible=true;center.Position=UDim2.fromScale(.5,.5);center.AbsoluteSize={X=50,Y=25};center.AnchorPoint=Vector2.new(.5,.5)
local root=Instance.new("ModuleScript");child(root,"Drain","ImageLabel")
local sprinting={timeUntilStaminaRecovers=1.5,Stamina=50,MaxStamina=100}
character:SetAttribute("N7CloneEndsAt",now+5)
local cleanup=Support.AttachHUD(character,ui,center,root,sprinting)
RunService.RenderStepped:Fire(.1)
assert(drain.Visible and fill.Size.X.Scale==.5)
assert(center.StaminaRecoveryTime.Visible and center.StaminaRecoveryTime.Text=="Regen 1.5s")
assert(button.CloneDurationTracker.Text=="5.0s"and button.CloneDurationTracker.Visible)
center.Visible=false;RunService.RenderStepped:Fire(.1);assert(not center.StaminaRecoveryTime.Visible)
sprinting.timeUntilStaminaRecovers=0;character:SetAttribute("N7CloneEndsAt",nil);RunService.RenderStepped:Fire(.1)
assert(not drain.Visible and not button.CloneDurationTracker.Visible)
cleanup();cleanup();assert(RunService.RenderStepped:Count()==0 and not button:FindFirstChild("CloneDurationTracker")and not center.Parent)
print("PASS actual HUD helper: main and center recovery indicators, live clone timer, visibility, completion and cleanup")
