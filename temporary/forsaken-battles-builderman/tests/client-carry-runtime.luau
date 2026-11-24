
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
 end,Count=function()local n=0;for _,entry in entries do if entry[1].Active then n+=1 end end;return n end}
end

fresh()
local t1={}
local warnings={};local locks={};local events={}
local Util={CreateWarning=function(_,id,message)table.insert(warnings,message)end,ToggleLockForAbilityIcon=function(_,name,key,on)locks[key]=on end}
local Network={FireConnection=function(_,name,key,on)table.insert(events,{name,key,on})end}
local t2={tooClose="too close",unknown="unknown"}
local function cl_tweenCarryFOV(actor,on)actor.FOVCarrying=on end
local function constructBuildingOnClient()end
local function safeAnimation(actor,name,on)
 local track=actor.Animations and actor.Animations[name]
 if track then if on then track:Play()else track:Stop()end end
end
local function cl_dropBuilding(p9) -- line: 714
	-- upvalues: t1 (copy), cl_tweenCarryFOV (copy), Util (copy)
	local Move = t1.Abilities.Move
	local v37 = p9.Behavior and (p9.Behavior.Abilities and p9.Behavior.Abilities.Move)

	if v37 and Move then
		v37.Icon = Move.Icon
		v37.Name = Move.Name
	end

	p9.CarryingBuilding = nil
	cl_tweenCarryFOV(p9, false)
	
	Util:ToggleLockForAbilityIcon("Move", "invalidplacement", false)
end
t1.Abilities = {
	Sentry = {
		LayoutOrder = 1,
		KeybindType = "AltAbility1",
		Icon = "rbxassetid://104441527277654",
		CurrentRecharge = 0,
		ChargeDuration = 0,
		RechargeInverted = true,
		Callback = function(p19, p20) -- line: 1129
			-- upvalues: constructBuildingOnClient (copy)
			constructBuildingOnClient(p19, "Sentry", p20)
		end
	},
	Dispenser = {
		LayoutOrder = 2,
		KeybindType = "AltAbility2",
		Icon = "rbxassetid://102952736333903",
		CurrentRecharge = 0,
		ChargeDuration = 0,
		RechargeInverted = true,
		Callback = function(p21, p22) -- line: 1260
			-- upvalues: constructBuildingOnClient (copy)
			constructBuildingOnClient(p21, "Dispenser", p22)
		end
	},
	Move = {
		LayoutOrder = 3,
		KeybindType = "AltAbility3",
		Icon = "rbxassetid://97983142047580",
		Name = "Carry",
		SpecialName = "Place",
		SpecialIcon = "rbxassetid://109402731902696",
		Callback = function(p23, p24) -- line: 1353
			-- upvalues: t2 (copy), Util (copy), t1 (copy), cl_tweenCarryFOV (copy), Network (copy), cl_dropBuilding (copy)
			if typeof(p24) == "string" then
				local v79 = t2[p24] or "Something went wrong. Try building somewhere else."

				Util:CreateWarning("BuildermanWarning", v79, p23.Config.Instances.WarningTemplate)

				return
			end

			if typeof(p24) == "Instance" then
				if p23.CarryableBuildingHighlight then
					p23.CarryableBuildingHighlight.Adornee = nil
				end

				p23.CarryingBuilding = p24

				local Move = t1.Abilities.Move
				local v81 = p23.Behavior and (p23.Behavior.Abilities and p23.Behavior.Abilities.Move)

				if v81 and Move then
					v81.Icon = Move.SpecialIcon
					v81.Name = Move.SpecialName
				end

				cl_tweenCarryFOV(p23, true)
				
				p23.AnimationType = "Pick"
				Network:FireConnection("DisableSprinting", "CarryingBuilding", true)

                safeAnimation(p23,"PickUp",true)

			else
				p23.AnimationType = nil
				Network:FireConnection("DisableSprinting", "CarryingBuilding", false)

                safeAnimation(p23,"PutDown",true)

				cl_dropBuilding(p23)
			end
		end
	}
}


local actor={Rig=Instance.new("Model"),Config={Instances={WarningTemplate={}}},Behavior={Abilities={Move={}}}}
local building=Instance.new("Model")
t1.Abilities.Move.Callback(actor,building)
assert(actor.CarryingBuilding==building and actor.AnimationType=="Pick"and actor.Behavior.Abilities.Move.Name=="Place")
assert(actor.FOVCarrying==true and events[#events][3]==true)
t1.Abilities.Move.Callback(actor,false)
assert(actor.CarryingBuilding==nil and actor.AnimationType==nil and actor.Behavior.Abilities.Move.Name=="Carry")
assert(actor.FOVCarrying==false and events[#events][3]==false)
t1.Abilities.Move.Callback(actor,"tooClose");assert(warnings[#warnings]=="too close")
assert(actor.Animations==nil,"must test absent media")
print("PASS donor Carry/Place callbacks with missing animations: icon/name, FOV, sprint enable/disable, state cleanup and placement warning")
