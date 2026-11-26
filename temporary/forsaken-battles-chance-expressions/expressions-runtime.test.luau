
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
Enum.NormalId={Front=1}
local queue={}
local task={delay=function(_,callback)local item={callback=callback};table.insert(queue,item);return item end,cancel=function(item)item.cancelled=true end}
local Repair=(function()
local Repair={}
local function asset(id)
 if type(id)=="number"then return "rbxassetid://"..tostring(id)end
 if type(id)=="string"and id~=""then
  if id:match("^%d+$")then return "rbxassetid://"..id end
  return id
 end
end
function Repair.Attach(actor)
 if actor.ChanceExpressionCleanup then actor.ChanceExpressionCleanup()end
 local rig=actor.Rig
 local head=rig and rig:FindFirstChild("Head")
 local hum=rig and rig:FindFirstChildOfClass("Humanoid")
 local function expressions()
  local config=actor.Config or {}
  return(actor.RigName and config["Expressions"..actor.RigName])or config.Expressions
 end
 local values=expressions()
 if not head or not hum or type(values)~="table"or not asset(values.Default)then
  warn("[Chance expressions] Cannot attach: missing Head, Humanoid, or Config.Expressions.Default")
  return
 end
 local holder=rig:FindFirstChild("ExpressionHolder",true)
 if holder and not holder:IsA("BasePart")then warn("[Chance expressions] ExpressionHolder must be a BasePart");return end
 if not holder then
  local instances=game.ReplicatedStorage.Assets:FindFirstChild("Instances")
  local template=instances and instances:FindFirstChild("ExpressionHolder")
  if template and template:IsA("BasePart")then holder=template:Clone()
  else
   holder=Instance.new("Part");holder.Size=head.Size;holder.Transparency=1
  end
  holder.Name="ExpressionHolder"
  holder.Anchored=false;holder.CanCollide=false;holder.CanTouch=false;holder.CanQuery=false;holder.Massless=true
  holder.CFrame=head.CFrame*CFrame.new(0,0,-.005)
  local weld=Instance.new("WeldConstraint");weld.Part0=head;weld.Part1=holder;weld.Parent=holder
  holder.Parent=rig
 end
 local decal=holder:FindFirstChildOfClass("Decal")or Instance.new("Decal")
 decal.Name="Expression";decal.Transparency=0;decal.Face=Enum.NormalId.Front;decal.Color3=Color3.new(1,1,1);decal.Parent=holder
 local hidden={}
 for _,child in head:GetChildren()do
  if child:IsA("Decal")and child.Face==Enum.NormalId.Front then hidden[child]=child.Transparency;child.Transparency=1 end
 end
 local previous=actor.ChangeExpression
 local serial=0
 local active=true
 local timer=nil
 local function cancelTimer()
  if timer then pcall(task.cancel,timer);timer=nil end
 end
 local function draw(name,duration)
  if not active or not rig.Parent then return end
  local config=expressions()
  if type(config)~="table"then return end
  if hum.Health<=0 then name="Dead"end
  if name=="Default"then name=hum.Health<=hum.MaxHealth/2 and config.Injured and "Injured"or "Default"end
  local texture=asset(config[name])or(name=="Dead"and asset(config.Default))
  if not texture then return end
  serial+=1;cancelTimer()
  decal.Texture=texture
  if actor.Behavior and type(actor.Behavior.onExpressionChanged)=="function"then
   pcall(actor.Behavior.onExpressionChanged,actor.Behavior,actor,name,duration)
  end
  if type(duration)=="number"and duration>0 and hum.Health>0 then
   local current=serial
   timer=task.delay(duration,function()
    timer=nil
    if active and current==serial then actor:ChangeExpression("Default")end
   end)
  end
 end
 local function change(_,name,duration)draw(name,duration)end
 actor.ChangeExpression=change
 local health=hum.Health
 local connection=hum.HealthChanged:Connect(function(value)
  if value<=0 then draw("Dead")
  elseif value<health then draw("Hurt",.75)
  elseif value>health+20 then draw("Happy",.75)
  else draw("Default")end
  health=value
 end)
 local destroying
 local cleanup
 cleanup=function()
  if not active then return end
  active=false;serial+=1;cancelTimer();connection:Disconnect()
  if destroying then destroying:Disconnect()end
  if actor.ChangeExpression==change then actor.ChangeExpression=previous end
  for face,transparency in hidden do if face.Parent then face.Transparency=transparency end end
  actor.ChanceExpressionCleanup=nil
 end
 destroying=rig.Destroying:Connect(cleanup)
 actor.ChanceExpressionCleanup=cleanup
 draw("Default")
end
return Repair

end)()
local rig=child(workspace,"Chance","Model")
local head=child(rig,"Head","Part");head.Size=Vector3.new(2,1,1);head.CFrame=CFrame.new()
local hum=child(rig,"Humanoid","Humanoid");hum.Health=80;hum.MaxHealth=80;hum.HealthChanged=signal()
local front=child(head,"face","Decal");front.Face=Enum.NormalId.Front;front.Transparency=0
local original=function()end
local actor={Rig=rig,Config={Expressions={Default="101",Injured="102",Happy="103",Sad="104",Gambling="105",Hurt="106",Dead="107"}},ChangeExpression=original}
Repair.Attach(actor)
local holder=rig.ExpressionHolder;local decal=holder.Expression
assert(decal.Texture=="rbxassetid://101"and front.Transparency==1,"missing holder/default not repaired")
actor:ChangeExpression("Happy",1)
local old=queue[#queue]
actor:ChangeExpression("Sad",1)
assert(old.cancelled and decal.Texture=="rbxassetid://104","old timer not cancelled")
queue[#queue].callback();assert(decal.Texture=="rbxassetid://101","timed expression not restored")
hum.Health=30;hum.HealthChanged:Fire(30);assert(decal.Texture=="rbxassetid://106")
queue[#queue].callback();assert(decal.Texture=="rbxassetid://102","injured default not selected")
hum.Health=0;hum.HealthChanged:Fire(0);assert(decal.Texture=="rbxassetid://107")
actor:ChangeExpression("Happy");assert(decal.Texture=="rbxassetid://107","dead expression overwritten")
actor.ChanceExpressionCleanup();assert(hum.HealthChanged:Count()==0 and actor.ChangeExpression==original and front.Transparency==0)
hum.Health=80
Repair.Attach(actor);assert(rig.ExpressionHolder==holder,"duplicate holder created")
rig.Destroying:Fire();assert(not actor.ChanceExpressionCleanup and hum.HealthChanged:Count()==0)
assert(actor.Config.Expressions.Default=="101","custom Config mutated")
print("PASS Chance expressions: missing holder, custom IDs, timed expression replacement, injury/death, existing holder reuse and cleanup")
