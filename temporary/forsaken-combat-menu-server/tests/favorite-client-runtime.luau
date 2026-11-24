
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
local t1={}
local function require(_)return {Play=function()end}end
local TweenInfo={new=function()return {}end}
local Enum={EasingStyle={Back=1},EasingDirection={Out=1}}
local TweenService={Create=function()return {Play=function()end}end}
local function signal()
 local callbacks={}
 return {Connect=function(_,f)
  local connection={active=true}
  function connection:Disconnect()self.active=false end
  table.insert(callbacks,{connection,f});return connection
 end,Fire=function()
  for _,entry in callbacks do if entry[1].active then entry[2]()end end
 end}
end
function t1.SetupFavoriteStar(_: {[any]: any}, p4, b1: boolean, n1: number, p5: ((...any) -> ...any)) -- line: 110
	-- upvalues: TweenService (copy)
	local Sounds = require(game.ReplicatedStorage.Modules.Sounds)
	local Favorite = p4.Container.Favorite
 t1.__favoriteConnections=t1.__favoriteConnections or setmetatable({},{__mode="k"})
 local previous=t1.__favoriteConnections[Favorite]
 if previous then previous:Disconnect()end
	local v37 = math.clamp(n1, -499999999, 499999999)

	local function refresh() -- line: 115
		-- upvalues: Favorite (copy), b1 (ref), p4 (copy), v37 (copy)
		Favorite.Image = not b1 and "rbxassetid://124616983330179" or "rbxassetid://109991111422732"
		p4.LayoutOrder = if not b1 then v37 else v37 - 1000000000
	end

	t1.__favoriteConnections[Favorite]=Favorite.MouseButton1Click:Connect(function() -- line: 120
		-- upvalues: b1 (ref), Favorite (copy), p4 (copy), v37 (copy), TweenService (copy), Sounds (copy), p5 (copy)
		b1 = not b1
		Favorite.Image = not b1 and "rbxassetid://124616983330179" or "rbxassetid://109991111422732"
		p4.LayoutOrder = if not b1 then v37 else v37 - 1000000000

		local v102 = not b1 and 0 or 360
		local v103 = math.abs(v102 - Favorite.Rotation) * 0.5 / 360

		TweenService:Create(Favorite, TweenInfo.new(v103, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			Rotation = v102
		}):Play()

		local v104 = not b1 and "rbxassetid://123918163549718" or "rbxassetid://72021954943640"

		if v104 ~= "" then
			Sounds:Play(v104)
		end

		p5(b1)
	end)
	Favorite.Active = true
	Favorite.Visible = true
	Favorite.Rotation = not b1 and 0 or 360
	Favorite.Image = not b1 and "rbxassetid://124616983330179" or "rbxassetid://109991111422732"
	p4.LayoutOrder = if not b1 then v37 else v37 - 1000000000
end

local card=Instance.new("Frame");local container=child(card,"Container","Frame");local favorite=child(container,"Favorite","ImageButton")
favorite.MouseButton1Click=signal();favorite.Active=false;favorite.Visible=false;favorite.Rotation=0
local sent={}
t1:SetupFavoriteStar(card,false,25,function(value)table.insert(sent,value)end)
assert(favorite.Visible and favorite.Active and card.LayoutOrder==25)
favorite.MouseButton1Click:Fire()
assert(sent[1]==true and card.LayoutOrder==25-1000000000)
favorite.MouseButton1Click:Fire()
assert(sent[2]==false and card.LayoutOrder==25)
t1:SetupFavoriteStar(card,true,25,function(value)table.insert(sent,value)end)
favorite.MouseButton1Click:Fire()
assert(#sent==3 and sent[3]==false,"duplicate favorite callback")
assert(card.LayoutOrder==25)
print("PASS actual favorite star: imported hidden control enabled, toggle/sort order and repeated setup listener cleanup")
