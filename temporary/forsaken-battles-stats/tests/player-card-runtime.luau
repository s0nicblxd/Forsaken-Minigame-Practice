
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
 local entries={}
 return {Connect=function(_,callback)
  local object={Active=true};function object:Disconnect()self.Active=false end
  table.insert(entries,{object,callback});return object
 end,Fire=function(_,...)
  for _,entry in table.clone(entries)do if entry[1].Active then entry[2](...)end end
 end}
end
function Methods:WaitForChild(name)return self:FindFirstChild(name)end

fresh()
function Methods:GetPropertyChangedSignal(name)self.Signals=self.Signals or {};self.Signals[name]=self.Signals[name]or signal();return self.Signals[name]end
local v39=Instance.new("Folder")
for _,role in {"Survivor","Killer"}do
 local group=child(v39,role.."Stats")
 child(group,role.."Kills","NumberValue").Value=role=="Survivor"and 3 or 7
 child(group,role.."Wins","NumberValue").Value=999
end
local clone=Instance.new("Frame");local icons=child(clone,"WinInfo","Frame")
for _,role in {"Survivor","Killer"}do
 local box=child(icons,role.."Wins","Frame");box.MouseEnter=signal();box.MouseLeave=signal();child(box,"Wins","TextLabel")
end
local tooltip
local Util={GetSettingValue=function()return false end,CreateTooltip=function(_,text)tooltip=text end}
local p6={}
local t4={}
		for _, v in pairs({
			"Killer",
			"Survivor"
		}) do
			local v47 = v39 and v39:FindFirstChild(`{ v }Stats`)
			local v48 = v47 and v47:FindFirstChild(`{ v }Kills`)

			if v48 then
				local SettingValue = Util:GetSettingValue(`Hide{ v }Wins`, p6)
				local v50 = clone.WinInfo:FindFirstChild(`{ v }Wins`)

				v50.MouseEnter:Connect(function() -- line: 275
					-- upvalues: Util (copy), v (copy), SettingValue (copy)
					Util:CreateTooltip(`{ v } Kills{ not SettingValue and "" or " <font color=\"rgb(125,125,125)\"><i>(Hidden)</i></font>" }`)
				end)
				v50.MouseLeave:Connect(function() -- line: 276
					-- upvalues: Util (copy)
					Util:CreateTooltip()
				end)

				local function setScore() -- line: 279
					-- upvalues: v50 (copy), SettingValue (copy), v48 (copy)
					v50.Wins.Text = if not SettingValue then v48.Value else "<font color=\"rgb(125,125,125)\"><i>(Hidden)</i></font>"
				end

				v50.Wins.Text = if not SettingValue then v48.Value else "<font color=\"rgb(125,125,125)\"><i>(Hidden)</i></font>"
				table.insert(t4, v48:GetPropertyChangedSignal("Value"):Connect(setScore))
			end

end
assert(clone.WinInfo.SurvivorWins.Wins.Text==3 and clone.WinInfo.KillerWins.Wins.Text==7)
clone.WinInfo.SurvivorWins.MouseEnter:Fire();assert(tooltip=="Survivor Kills")
print("PASS actual player-card bindings: Survivor/Killer kill values and tooltip, rather than old win counters")
