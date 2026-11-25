
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
 if key=="Rotation"then return cf(v(0,0,0))end
 if key=="ToObjectSpace"then return function(self,other)return cf(other.Position-self.Position)end end
end
function cfm.__mul(a,b)return cf(a.Position+b.Position)end
local Vector3={new=v}
local CFrame={new=function(x,y,z)return cf(type(x)=="table"and x or v(x or 0,y or 0,z or 0))end,lookAt=function(position)return cf(position)end}
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


RunService.RenderStepped=signal()
local Grounding=(function()
local RunService=game:GetService("RunService")
local Grounding={}
Grounding.__index=Grounding
local function snap(building,frame)
 local root=building.PrimaryPart
 if not root then return end
 local hum=building:FindFirstChildOfClass("Humanoid")
 local animator=hum and hum:FindFirstChildOfClass("Animator")
 if animator then for _,track in animator:GetPlayingAnimationTracks()do track:Stop(0)end end
 for _,joint in building:GetDescendants()do if joint:IsA("Motor6D")then joint.Transform=CFrame.new()end end
 local parts,frames={root},{frame}
 for _,part in building:GetDescendants()do
  if part:IsA("BasePart")and part~=root then
   local relative=part:GetAttribute("BuilderRestLocalCF")
   if typeof(relative)=="CFrame"then table.insert(parts,part);table.insert(frames,frame*relative)end
  end
 end
 workspace:BulkMoveTo(parts,frames,Enum.BulkMoveMode.FireCFrameChanged)
end
function Grounding.new()
 return setmetatable({connections={}},Grounding)
end
function Grounding:Place(building,frame,untilTime)
 if typeof(building)~="Instance"or not building:IsA("Model")or typeof(frame)~="CFrame"or type(untilTime)~="number"then return end
 if self.connections[building]then self.connections[building]:Disconnect()end
 snap(building,frame)
 self.connections[building]=RunService.RenderStepped:Connect(function()
  if not building.Parent or building:GetAttribute("Destroyed")or workspace:GetServerTimeNow()>=untilTime then
   local connection=self.connections[building];self.connections[building]=nil
   if connection then connection:Disconnect()end
   return
  end
  snap(building,frame)
 end)
end
function Grounding:Destroy()
 for _,connection in self.connections do connection:Disconnect()end
 self.connections={}
end
return Grounding

end)()
local model=child(workspace,"TestBuilding","Model")
local root=child(model,"Root","Part");root.CFrame=CFrame.new(0,1,0);model.PrimaryPart=root
local body=child(model,"Body","Part");body.CFrame=CFrame.new(0,8,0);body:SetAttribute("BuilderRestLocalCF",CFrame.new(0,2,0))
local grounding=Grounding.new()
grounding:Place(model,CFrame.new(0,1,0),now+1)
assert(body.Position.Y==3,"client did not immediately ground body")
body.CFrame=CFrame.new(0,10,0);RunService.RenderStepped:Fire()
assert(body.Position.Y==3,"late carry animation was not corrected")
now+=1.01;RunService.RenderStepped:Fire()
assert(not next(grounding.connections),"grounding exceeded placement deadline")
grounding:Place(model,CFrame.new(0,1,0),now+1);grounding:Destroy()
assert(RunService.RenderStepped:Count()==0,"grounding leaked render connection")
print("PASS client grounding: immediate restore, late pose correction, deadline and cleanup")
