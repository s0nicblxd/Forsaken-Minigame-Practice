
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
local rig=child(workspace,"Actor","Model")
local effect={Character=rig,Level=3}
local Exhausted=(function()
local function apply(effect)
 local rig=effect.Character
 if rig and rig.Parent then rig:SetAttribute("ExhaustedLevel",math.clamp(effect.Level or 1,1,3))end
end
return {
 Data={Duration=4,MaxLevel=3,Stackable=false,Description="Decreases stamina regeneration and increases stamina drain by 5% per level."},
 Applied=apply,
 Removed=function(effect)
  if effect.Character then effect.Character:SetAttribute("ExhaustedLevel",nil)end
 end
}

end)()
Exhausted.Applied(effect);assert(rig:GetAttribute("ExhaustedLevel")==3)
for i=1,30 do Exhausted.Applied(effect)end
assert(rig:GetAttribute("ExhaustedLevel")==3)
effect.Level=1;Exhausted.Applied(effect);assert(rig:GetAttribute("ExhaustedLevel")==1)
Exhausted.Removed(effect);assert(rig:GetAttribute("ExhaustedLevel")==nil)
local Character=rig
local dt=1
local t1={StaminaLoss=10,StaminaGain=20}
local function rates()
 return t1.StaminaLoss * (1+.05*(Character:GetAttribute("ExhaustedLevel")or 0)) * dt,
 t1.StaminaGain * math.max(0,1-.05*(Character:GetAttribute("ExhaustedLevel")or 0)) * dt
end
rig:SetAttribute("ExhaustedLevel",3);local loss,gain=rates();assert(loss==11.5 and gain==17)
rig:SetAttribute("ExhaustedLevel",nil);loss,gain=rates();assert(loss==10 and gain==20)
print("PASS Exhausted level refresh/removal and exact 5%-per-level stamina integration without compounding base stats")
