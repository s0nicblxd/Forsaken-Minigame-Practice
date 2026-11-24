
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
local function inputs()
 local donor=child(workspace,"HelperbotDonor");local rig=child(donor,"Rig","Model")
 child(rig,"Humanoid","Humanoid");child(rig,"HumanoidRootPart","Part")
 local upd=child(workspace,"HelperbotUPD");local config=child(upd,"Config","ModuleScript");local fx=child(config,"VFX")
 for _,name in {"Pulse","PulseHit","InspireActive"}do child(fx,name,"Attachment")end
 child(config,"Radar","MeshPart");child(config,"ChargeMeter","BillboardGui");child(config,"cl_HelperbotChargeBillboard","ModuleScript")
end

local nativeTypeof=typeof
local function typeof(value)if type(value)=="table"and value._props then return "Instance"end;return nativeTypeof(value)end
local oldIsA=Methods.IsA
function Methods:IsA(class)
 if class=="ValueBase"then return table.find({"StringValue","IntValue","NumberValue","BoolValue"},self.ClassName)~=nil end
 return oldIsA(self,class)
end
local function locate(path)
 local object=game;for name in path:gmatch("[^/]+")do object=object and object:FindFirstChild(name)end;return object
end
local function ensure(path,class)
 local object=game;local parts=string.split(path,"/")
 for i,name in parts do object=object:FindFirstChild(name)or child(object,name,i==#parts and class or "Folder")end
 return object
end

fresh()
local ValueMap={boolean="BoolValue",string="StringValue",number="NumberValue"}
local logger={warn=function()error("unexpected conversion warning")end}
local function GetValueBaseFromValue(val)
	if typeof(val) == "string" and #string.split(val, "NumVal") == 2 and tonumber(string.split(val, "NumVal")[1]) then
		return "NumberValue"
	elseif ValueMap[typeof(val)] then
		return ValueMap[typeof(val)]
	else
		return "StringValue", true
	end
end

local function GetTableFromFolder(Folder: Folder)
	local result = {}

	for _, v in ipairs(Folder:GetChildren()) do
		if v:IsA("Folder") then
			result[v.Name] = GetTableFromFolder(v)
		elseif v:IsA("ValueBase") then
			if v:IsA("NumberValue") or v:IsA("IntValue") then
				result[v.Name] = tostring(v.Value).."NumVal"
			else
				result[v.Name] = v.Value
			end
		end
	end

	return result
end



local function ApplyDataToFolder(Data, Folder)
	for valueName, value in pairs(Data) do
		local matching = Folder:FindFirstChild(valueName)

		if matching then
			if typeof(value) == "table" and matching:IsA("Folder") then
				ApplyDataToFolder(value, matching)

			elseif typeof(value) == "string" and (matching:IsA("NumberValue") or matching:IsA("IntValue")) and value:find("NumVal") then
				matching.Value = tonumber(string.split(value, "NumVal")[1]) or 0

			elseif typeof(value) ~= "table" and matching:IsA("ValueBase") then
				if matching:IsA("IntValue") or matching:IsA("NumberValue") then
					local convertedNumber = tonumber(value)
					if convertedNumber then
						matching.Value = convertedNumber
					else
						logger:warn(`[PlayerData] ERROR: Tried to set NumberValue '{matching:GetFullName()}' with non-numeric value: '{value}' on the object {matching:GetFullName()}`)
					end
				elseif matching:IsA("StringValue") then
					matching.Value = tostring(value)
				elseif matching:IsA("BoolValue") then
					matching.Value = (value == true or value == "true")
				else
					matching.Value = value
				end
			end
		elseif typeof(value)=="table" then
            local nested=Instance.new("Folder")
            nested.Name=valueName
            ApplyDataToFolder(value,nested)
            nested.Parent=Folder
		else
			local valueBase, unknownType = GetValueBaseFromValue(value)
			local finalValue = value

			if type(finalValue) == "string" and (valueBase == "NumberValue" or valueBase == "IntValue") then
				if finalValue:find("NumVal") then
					finalValue = tonumber(string.split(finalValue, "NumVal")[1]) or 0
				else
					finalValue = tonumber(finalValue) or 0
				end
			end

			if unknownType then
				logger:warn(`[PLAYERDATA] Value type '{typeof(value)}' does not have a recognised ValueBase. Defaulting to StringValue.`)
				finalValue = tostring(finalValue)
			end

			local newValue = Instance.new(valueBase)
			newValue.Name = valueName
			newValue.Value = finalValue
			newValue.Parent = Folder
		end
	end
end


local original=Instance.new("Folder")
local favorites=child(original,"Favorites")
local killers=child(favorites,"Killers");child(favorites,"Survivors")
local marker=child(killers,"JohnDoe","BoolValue");marker.Value=true
local skins=child(child(favorites,"Skins"),"JohnDoe")
local value=child(skins,"CoolJohn","BoolValue");value.Value=true
local saved=GetTableFromFolder(original)
local freshProfile=Instance.new("Folder")
ApplyDataToFolder(saved,freshProfile)
assert(freshProfile.Favorites:IsA("Folder"))
assert(freshProfile.Favorites.Killers.JohnDoe.Value==true)
assert(freshProfile.Favorites.Skins.JohnDoe.CoolJohn.Value==true)
local savedAgain=GetTableFromFolder(freshProfile)
assert(savedAgain.Favorites.Skins.JohnDoe.CoolJohn==true)
local template=Instance.new("Folder");local fav=child(template,"Favorites");child(fav,"Killers");child(fav,"Survivors");child(fav,"Skins")
ApplyDataToFolder(saved,template)
assert(template.Favorites.Skins.JohnDoe.CoolJohn.Value==true)
print("PASS actual native save/load/save with nested favorites and old profile reconciliation")
