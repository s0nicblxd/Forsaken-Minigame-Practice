
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
function Methods:PivotTo(cf)self.Pivot=cf end
local template=Instance.new("Model")
local handle=child(template,"ScooterHandle","Part");handle.Transparency=1
local body=child(template,"Scooter","MeshPart");body.Transparency=1;body.LocalTransparencyModifier=1
local joint=child(template,"ScooterJoint","Motor6D");joint.C0="donor offset";joint.C1="donor inverse offset"
local rig=child(workspace,"Elliot","Model");local torso=child(rig,"Torso","Part");torso.CFrame="torso frame"
local actor={Rig=rig,Config={UsesScooter=true,Instances={CustomScooter=template}}}
local function scooter(a)
 if a.Config.UsesScooter==false then return end
 local template=a.Config.Instances and a.Config.Instances.CustomScooter
 if not template or not template:IsA("Model")then return end
 local model=template:Clone()
 local handle=model:FindFirstChild("ScooterHandle")or model.PrimaryPart
 local torso=a.Rig:FindFirstChild("Torso")or a.Rig.PrimaryPart
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
 model.Name="ElliotRushScooter";model.Parent=a.Rig
 return model
end

local model=scooter(actor)
assert(model and model.Parent==rig and model.Name=="ElliotRushScooter")
assert(model.Scooter.Transparency==0 and model.Scooter.LocalTransparencyModifier==0,"donor mesh still hidden")
assert(model.ScooterHandle.Transparency==1,"invisible handle exposed")
assert(model.ScooterJoint.Part0==torso and model.ScooterJoint.Part1==model.ScooterHandle)
assert(model.ScooterJoint.C0=="donor offset"and model.ScooterJoint.C1=="donor inverse offset")
assert(not model.Scooter.Anchored and not model.Scooter.CanCollide and model.Scooter.Massless)
assert(template.Scooter.Transparency==1,"template modified")
assert(actor.Animations==nil,"test must not supply animations")
print("PASS actual scooter creation: hidden donor mesh becomes visible without animations, handle remains hidden, authored offsets and attachment retained")
