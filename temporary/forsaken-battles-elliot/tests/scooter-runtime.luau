
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
local vector={};local vm={__index=vector}
local function v(x,y,z)return setmetatable({X=x,Y=y,Z=z},vm)end
function vm.__add(a,b)return v(a.X+b.X,a.Y+b.Y,a.Z+b.Z)end
function vm.__sub(a,b)return v(a.X-b.X,a.Y-b.Y,a.Z-b.Z)end
function vm.__mul(a,b)return v(a.X*b,a.Y*b,a.Z*b)end
local cf={};local cm={__index=cf}
local function frame(pos)return setmetatable({Position=pos,RightVector=v(1,0,0),UpVector=v(0,1,0),LookVector=v(0,0,-1)},cm)end
function cm.__mul(a,b)return frame(a.Position+b.Position)end
function cf:ToObjectSpace(other)return frame(other.Position-self.Position)end
function cf:VectorToObjectSpace(value)return value end
local CFrame={new=function(x,y,z)return frame(type(x)=="table"and x or v(x or 0,y or 0,z or 0))end}
local Vector3={new=v}
local RaycastParams={new=function()return {}end}
local Enum={RaycastFilterType={Include=1}}
local heartbeat=signal();local RunService={Heartbeat=heartbeat}
local map=child(workspace,"Map")
local floorHeight=0
local hit=true
function workspace:Raycast(origin,direction,params)
 assert(params.FilterDescendantsInstances[1]==map and params.FilterType==1)
 assert(direction.Y==-8)
 return hit and {Position=v(0,floorHeight,0)}or nil
end
function Methods:PivotTo(value)self.Pivot=value end
local template=Instance.new("Model")
local handle=child(template,"ScooterHandle","Part");handle.Transparency=1;handle.CFrame=CFrame.new()
local body=child(template,"Scooter","MeshPart");body.Transparency=1;body.LocalTransparencyModifier=1;body.CFrame=CFrame.new(0,-1.25,0);body.Size=v(2,3.6,4)
local joint=child(template,"ScooterJoint","Motor6D");joint.C0="old offset";joint.C1="preserved inverse"
local rig=child(workspace,"Elliot","Model");local root=child(rig,"HumanoidRootPart","Part");root.Position=v(0,3,0);root.CFrame=frame(root.Position);rig.PrimaryPart=root
local torso=child(rig,"Torso","Part");torso.CFrame=CFrame.new(0,-500,0)
local actor={Rig=rig,Config={UsesScooter=true,Instances={CustomScooter=template}}}
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
 local joint=model:FindFirstChild("ScooterJoint",true)
 if joint and joint:IsA("Motor6D")then joint.Part0=torso;joint.Part1=handle
 else joint=Instance.new("Motor6D");joint.Name="ScooterJoint";joint.Part0=torso;joint.Part1=handle;joint.Parent=handle end
 local base=a.Config.RushHourScooterOffset or CFrame.new()
 local geometry={}
 for _,part in model:GetDescendants()do
  if part:IsA("BasePart")and part~=handle and part.Transparency<1 then
   table.insert(geometry,{relative=handle.CFrame:ToObjectSpace(part.CFrame),half=part.Size*.5})
  end
 end
 local params=RaycastParams.new()
 params.FilterType=Enum.RaycastFilterType.Include
 params.FilterDescendantsInstances={workspace.Map}
 params.IgnoreWater=true
 model.Name="ElliotRushScooter";model.Parent=a.Rig
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

local model,connection=scooter(actor)
assert(model and model.Parent==rig)
assert(model.Scooter.Transparency==0 and model.Scooter.LocalTransparencyModifier==0)
assert(model.ScooterHandle.Transparency==1)
assert(model.ScooterJoint.Part0==root and model.ScooterJoint.Part1==model.ScooterHandle,"must not follow animated torso")
assert(model.ScooterJoint.C1=="preserved inverse")
assert(math.abs(model.ScooterJoint.C0.Position.Y-.11)<1e-6,"wrong ground clearance")
for i=1,30 do heartbeat:Fire()end
assert(math.abs(model.ScooterJoint.C0.Position.Y-.11)<1e-6,"clearance accumulated each frame")
floorHeight=.5;heartbeat:Fire()
assert(math.abs(model.ScooterJoint.C0.Position.Y-.61)<1e-6,"floor rise not handled")
hit=false;root.Position=v(0,8,0);root.CFrame=frame(root.Position);heartbeat:Fire()
assert(model.ScooterJoint.C0.Position.Y==0,"airborne mount retained stale floor lift")
assert(template.Scooter.Transparency==1 and not model.Scooter.CanCollide and model.Scooter.Massless)
assert(actor.Animations==nil)
actor.ElliotRush={scooter=model,mountConnection=connection}
releaseRush(actor)
assert(heartbeat:Count()==0 and not model.Parent and actor.ElliotRush==nil)
print("PASS root-mounted scooter: ground clearance, raised floor, stable repeated updates, airborne reset, visible body/hidden handle, no animations required and release cleanup")
