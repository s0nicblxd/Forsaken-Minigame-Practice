
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
local players=child(workspace,"Players");local survivors=child(players,"Survivors");local killers=child(players,"Killers")
local viewer={Character=child(survivors,"Owner","Model")}
local getter=game.GetService
function game:GetService(name)if name=="Players"then return {LocalPlayer=viewer}end;return getter(self,name)end
local Color3={fromRGB=function(r,g,b)return `{r},{g},{b}`end}
local Enum={HighlightDepthMode={AlwaysOnTop=1}}
local CarryVisuals=(function()
local Players=game:GetService("Players")
local CarryVisuals={}
function CarryVisuals.Update(building,viewer)
 viewer=viewer or Players.LocalPlayer
 local character=viewer and viewer.Character
 local survivor=character and character.Parent==workspace.Players.Survivors
 local carrying=building:GetAttribute("Carrying")and not building:GetAttribute("Destroyed")
 local outline=building:FindFirstChild("BuildermanCarryOutline")
 local aura=building:FindFirstChild("PlayerAura")
 if not survivor or not carrying then
  if outline then outline:Destroy()end
  if aura then
   local before=aura:GetAttribute("BuilderCarryWasEnabled")
   if before~=nil then aura.Enabled=before;aura:SetAttribute("BuilderCarryWasEnabled",nil)end
  end
  return
 end
 if aura then
  if aura:GetAttribute("BuilderCarryWasEnabled")==nil then aura:SetAttribute("BuilderCarryWasEnabled",aura.Enabled)end
  aura.Enabled=false
 end
 if not outline then
  outline=Instance.new("Highlight");outline.Name="BuildermanCarryOutline";outline.Adornee=building
  outline.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop;outline.FillTransparency=1;outline.OutlineTransparency=0
  outline.OutlineColor=Color3.fromRGB(255,220,50);outline.Parent=building
 end
 outline.Enabled=true
end
return CarryVisuals

end)()
local building=Instance.new("Model");building:SetAttribute("OwnerName","Owner");building:SetAttribute("Carrying",true)
CarryVisuals.Update(building)
assert(building.BuildermanCarryOutline and building.BuildermanCarryOutline.Enabled)
assert(building.BuildermanCarryOutline.OutlineColor=="255,220,50")
CarryVisuals.Update(building);assert(#building:GetChildren()==1,"duplicate carry outlines")
local aura=child(building,"PlayerAura","Highlight");aura.Enabled=true
CarryVisuals.Update(building);assert(not aura.Enabled)
local other={Character=child(survivors,"OtherSurvivor","Model")}
CarryVisuals.Update(building,other);assert(building.BuildermanCarryOutline.Enabled)
local killer={Character=child(killers,"Killer","Model")}
CarryVisuals.Update(building,killer);assert(not building:FindFirstChild("BuildermanCarryOutline")and aura.Enabled)
CarryVisuals.Update(building,viewer);building:SetAttribute("Carrying",false);CarryVisuals.Update(building)
assert(not building:FindFirstChild("BuildermanCarryOutline")and aura.Enabled)
building:SetAttribute("Carrying",true);building:SetAttribute("Destroyed",true);CarryVisuals.Update(building)
assert(not building:FindFirstChild("BuildermanCarryOutline"))
print("PASS carry highlight: owner and other survivors, no killer outline, no ordinary aura dependency, deduplication and drop/destruction restoration")
