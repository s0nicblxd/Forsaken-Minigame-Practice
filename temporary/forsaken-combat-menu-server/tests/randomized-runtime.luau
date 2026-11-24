
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
local ReplicatedStorage=game.ReplicatedStorage
local callbacks={}
local network={SetConnection=function(_,name,kind,callback)callbacks[name]=callback end}
local dataHandler={}
function dataHandler:Get(player)return player:FindFirstChild("PlayerData")end
function dataHandler:ReadPathFrom(player,path)
 local object=self:Get(player)
 for name in path:gmatch("[^/]+")do object=object and object:FindFirstChild(name)end
 return object
end
local logging={new=function()return {info=function()end,warn=function()end}end}
ensure("ReplicatedStorage/Modules/Schematics/VIPKillersSchematic","ModuleScript")
ensure("ReplicatedStorage/Modules/DataHandler","ModuleScript")
ensure("ReplicatedStorage/Modules/Logging","ModuleScript")
local function require(module)
 if module.Name=="Network"then return network end
 if module.Name=="DataHandler"then return dataHandler end
 if module.Name=="Logging"then return logging end
 return {}
end
local systems=(function()
local module = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Network = require(game.ReplicatedStorage.Modules.Network)
local VIPContent = require(game.ReplicatedStorage.Modules.Schematics.VIPKillersSchematic)
local DataHandler = require(game.ReplicatedStorage.Modules.DataHandler)
local Logging = require(game.ReplicatedStorage.Modules.Logging)

local logger = Logging.new({ Module = "AssetSystems" })

-- literally does what the name says
local function IsAnValidAssetContainer(Asset)
	if ReplicatedStorage.Assets:IsAncestorOf(Asset) then return true end

	local Systems = ReplicatedStorage:FindFirstChild("Systems")
	if Systems then
		local plyrSystem = Systems:FindFirstChild("Player")
		if plyrSystem then
			local UI = plyrSystem:FindFirstChild("UI")
			if UI and UI:IsAncestorOf(Asset) then
				return true
			end
		end
	end

	return false
end

local function GetAssetType(Asset)
	if typeof(Asset) ~= "Instance" then return nil end

	-- randomized skin support (?) - i didn't find where it is located so i made this
	local randomSkin = Asset:GetAttribute("AssetType")
	if randomSkin then return randomSkin end

	-- considers everything inside ui as skins
	local Systems = ReplicatedStorage:FindFirstChild("Systems")
	if Systems then
		local PlayerSys = Systems:FindFirstChild("Player")
		if PlayerSys then
			local UI = PlayerSys:FindFirstChild("UI")
			if UI and UI:IsAncestorOf(Asset) then
				return "Skins"
			end
		end
	end

	-- hello everybody my name is markiplier.. YESSSS
	if Asset.Parent and Asset.Parent.Parent and Asset.Parent.Parent.Parent == ReplicatedStorage.Assets.Skins then return "Skins" end
	if Asset.Parent == ReplicatedStorage.Assets.Killers then return "Killers" end
	if Asset.Parent == ReplicatedStorage.Assets.Survivors then return "Survivors" end
	if Asset.Parent == ReplicatedStorage.Assets.Emotes then return "Emotes" end

	return nil
end

module.Start = function()

	Network:SetConnection("PurchaseContent", "REMOTE_FUNCTION", function(Player : Player, Asset : Instance)
		if not Asset then return {Status="error"} end

		if not Asset:GetAttribute("AssetType") and not IsAnValidAssetContainer(Asset) then 
			return {Status="error"} 
		end

		local AssetType = GetAssetType(Asset)
		if not AssetType then return {Status="error"} end

		local purchasedFolder = DataHandler:ReadPathFrom(Player, "Purchased/" .. AssetType) -- yes i made it use datahandler
		local statsFolder = DataHandler:ReadPathFrom(Player, "Stats")

		if not purchasedFolder then
			logger:warn("PlayerData is missing the purchased folder", { player = Player.Name, assetType = AssetType }) -- lime cookie logger support 1
			return {Status="error"}
		end

		logger:info("Attempting to purchase from category", { player = Player.Name, assetType = AssetType }) -- lime cookie logger support 2

		local config = (Asset:IsA("ModuleScript") and AssetType == "Emotes") and Asset or Asset:FindFirstChild("Config")
		if (not config) or (not config:IsA("ModuleScript")) then return {Status="error"} end
		config = require(config)

		if config.Exclusive then
			Network:FireClientConnection(Player, "SendNotif", "REMOTE_EVENT", "look at this dude 🤡🤡🤡", Color3.new(1, 0.5, 0.5), 5962000)
			return {Status="error"}
		end

		local price : number = config.Price
		if type(price) ~= "number" then return {Status="error"} end

		if not statsFolder then return {Status="error"} end

		local moneyValue : NumberValue = statsFolder:FindFirstChild("Money", true)
		if not moneyValue then return {Status="error"} end

		local balance : number = moneyValue.Value

		if purchasedFolder:FindFirstChild(Asset.Name) then
			return {Status="alreadyBought"}
		end
		if price > balance then
			return {Status="poor"}
		end

		moneyValue.Value -= price
		local newPurchase = Instance.new("IntValue")
		newPurchase.Name = Asset.Name
		newPurchase.Parent = purchasedFolder

		return {Status="success"}
	end)

	Network:SetConnection("EquipState", "REMOTE_EVENT", function(Player : Player, Asset : any, ExtraVal : any, ...)
		if not Asset then return end

        if type(Asset)=="string" and Asset:sub(1,20)=="RandomizedCharacter/" then
            local role=Asset:sub(21)
            if (role~="Killer" and role~="Survivor") or ExtraVal~=true then return end
            local data=Player:FindFirstChild("PlayerData")
            local equipped=data and data:FindFirstChild("Equipped")
            local value=equipped and equipped:FindFirstChild(role)
            local purchased=data and data:FindFirstChild("Purchased")
            local owned=purchased and purchased:FindFirstChild(role.."s")
            if value and owned then
                for _,item in owned:GetChildren()do
                    if not item:GetAttribute("Temp") and ReplicatedStorage.Assets[role.."s"]:FindFirstChild(item.Name)then
                        value.Value="Randomized"
                        break
                    end
                end
            end
            return
        end
		-- emotes thing
		if Asset == "Emotes" then
			local emotesEquipped = DataHandler:ReadPathFrom(Player, "Equipped/Emotes")
			if not emotesEquipped then return end

			local slots = string.split(emotesEquipped.Value, "|")
			if type(ExtraVal) == "number" and ExtraVal >= 1 and ExtraVal <= 8 then
				slots[ExtraVal] = "nil"
				emotesEquipped.Value = table.concat(slots, "|")
			end
			return
		end

		-- 
		if type(Asset) == "string" and string.sub(Asset, 1, 15) == "RandomizedSkin/" then
			local actorName = string.sub(Asset, 16) -- gets the killer or survivor name

			local AssetValue = DataHandler:ReadPathFrom(Player, "Equipped/Skins")
			if not AssetValue then return end

			local Value = AssetValue:FindFirstChild(actorName)
			if not Value then return end

			-- ExtraVal makes the skin be equipped or not
			Value.Value = ExtraVal and "Randomized" or ""
			return
		end

		-- bypass assets if it isn't located there ugh this caused me a headache to do
		if typeof(Asset) == "Instance" and not Asset:GetAttribute("AssetType") and not IsAnValidAssetContainer(Asset) then 
			return 
		end

		local AssetType = GetAssetType(Asset)
		if not AssetType then return end

		local purchasedFolder = DataHandler:ReadPathFrom(Player, "Purchased/" .. AssetType)
		if not purchasedFolder then return end

		local AssetValue = DataHandler:ReadPathFrom(Player, "Equipped/" .. AssetType) 
			or DataHandler:ReadPathFrom(Player, "Equipped/" .. string.sub(AssetType, 1, -2))

		if not AssetValue then
			logger:warn("PlayerData is missing equipped value", { player = Player.Name, assetType = AssetType })
			return
		end

		logger:info("Attempting to equip from category", { player = Player.Name, assetType = AssetType })

		if not purchasedFolder:FindFirstChild(Asset.Name) then
			local notOwned = true
			if Player:GetAttribute("VIP") and workspace:GetAttribute("ServerType") == "VIP" then
				for _, vip in pairs(VIPContent) do
					if vip.Type == AssetType and vip.Name == Asset.Name then
						notOwned = false
						break
					end
				end
			end

			if notOwned then
				Network:FireClientConnection(Player, "SendNotif", "REMOTE_EVENT", `you dont own "{Asset.Name}"`, Color3.new(1, 0.5, 0.5))
				return
			end
		end

		if AssetType == "Skins" then
			local actorName = Asset.Parent and Asset.Parent.Name
			if not actorName then return end
			local Value = AssetValue:FindFirstChild(actorName)
			if not Value then return end
			Value.Value = ExtraVal and Asset.Name or ""

		elseif AssetType == "Emotes" then
			if type(ExtraVal) ~= "number" or ExtraVal < 1 or ExtraVal > 8 then return end
			local slots = string.split(AssetValue.Value, "|")
			slots[ExtraVal] = Asset.Name
			AssetValue.Value = table.concat(slots, "|")

		else
			AssetValue.Value = Asset.Name
		end

	end)

end

-- i am gonna crash out don't make me modify this again (thank you bloodlight for the idea)
Network:SetConnection("GetRig", "REMOTE_FUNCTION", function(Player : Player, charName : string, survivorName : string, skinName : string)
	local ServerStorage = game:GetService("ServerStorage")

	local RigsFolder = ServerStorage:FindFirstChild("Assets") 
		and ServerStorage.Assets:FindFirstChild("Rigs")

	if not RigsFolder then 
		logger:warn("The Rigs folder was NOT found in ServerStorage!")
		return nil 
	end

	local categoryFolder = RigsFolder:FindFirstChild(charName)
	if not categoryFolder then return nil end

	-- searches for the character folder (ex. Shedletsky)
	local characterFolder = categoryFolder:FindFirstChild(survivorName)
	if not characterFolder then return nil end

	-- searches for the skin based on it's name
	local rig = characterFolder:FindFirstChild(skinName)

	-- yeah it also searches for an shorter skin name!
	if not rig then
		local shortSkinName = string.gsub(skinName, survivorName, "")
		rig = characterFolder:FindFirstChild(shortSkinName)
	end

	-- guarantees the rigs a model before it is parented
	if rig and rig:IsA("Model") then
		local rigClone = rig:Clone()
		rigClone.Parent = ReplicatedStorage
		return rigClone
	else
		logger:warn(`Rig for the skin: "{skinName}" was NOT found in {charName}.{survivorName}`)
	end

	return nil
end)

return module
end)()
systems.Start()
local Actors={}
local DataHandler=dataHandler
function Actors.GetEquippedActorInfo(_: {[any]: any}, p18, s10: string, b3: boolean?) -- line: 690
	-- upvalues: DataHandler (copy), ReplicatedStorage (copy)
	local v78 = DataHandler:Get(p18, 0)
	local v79 = v78 and v78:FindFirstChild("Equipped")
	local v80 = v79 and (not not v79:FindFirstChild(s10) and v79[s10].Value) or ""
    if v80=="Randomized" then
        local purchased=v78 and v78:FindFirstChild("Purchased")
        local owned=purchased and purchased:FindFirstChild(s10.."s")
        local catalog=ReplicatedStorage.Assets:FindFirstChild(s10.."s")
        local choices={}
        if owned and catalog then
            for _,item in owned:GetChildren()do
                if not item:GetAttribute("Temp") and catalog:FindFirstChild(item.Name)then table.insert(choices,item.Name)end
            end
        end
        table.sort(choices)
        v80=#choices>0 and choices[b3 and math.random(1,#choices) or 1] or (s10=="Killer" and "Slasher" or "Noob")
    end
	local v81 = v79 and v79:FindFirstChild("Skins")
	local v82 = v81 and (not not v81:FindFirstChild(v80) and v81[v80].Value) or ""

	if v82 == "Randomized" and b3 then
		local v83 = v78 and v78:FindFirstChild("Purchased")
		local v84 = v83 and v83:FindFirstChild("Skins")
		local v85 = ReplicatedStorage.Assets.Skins:FindFirstChild(`{ s10 }s`)
		local v86 = v85 and v85:FindFirstChild(v80)
		local Actors6 = { "" }

		if v84 and v86 then
			for _, child in v86:GetChildren() do
				if v84:FindFirstChild(child.Name) then
					table.insert(Actors6, child.Name)
				end
			end
		end

		return v80, Actors6[math.random(1, #Actors6)]
	end

	return v80, v82
end

local p=child(game,"TestPlayer","Player")
local data=child(p,"PlayerData");local purchased=child(data,"Purchased")
local owned=child(purchased,"Killers");child(purchased,"Skins")
local equipped=child(data,"Equipped");local choice=child(equipped,"Killer","StringValue");choice.Value="JohnDoe"
child(equipped,"Skins")
local catalog=ensure("ReplicatedStorage/Assets/Killers")
child(catalog,"JohnDoe");child(catalog,"Slasher");child(catalog,"NotOwned")
child(owned,"JohnDoe","IntValue");child(owned,"Slasher","IntValue")
child(owned,"NotOwned","IntValue"):SetAttribute("Temp",true)
child(owned,"MissingCatalogEntry","IntValue")
callbacks.EquipState(p,"RandomizedCharacter/Killer",true)
assert(choice.Value=="Randomized")
local seen={}
for i=1,100 do
 local name,skin=Actors:GetEquippedActorInfo(p,"Killer",true)
 assert(name=="JohnDoe"or name=="Slasher")
 assert(skin=="");seen[name]=true
end
assert(seen.JohnDoe and seen.Slasher)
local first=Actors:GetEquippedActorInfo(p,"Killer",false)
assert(first=="JohnDoe","non-spawn display must be stable")
callbacks.EquipState(p,"RandomizedCharacter/Other",true)
callbacks.EquipState(p,"RandomizedCharacter/Killer",false)
assert(choice.Value=="Randomized")
local plain=Actors:GetEquippedActorInfo(p,"Survivor",true)
assert(plain=="")
choice.Value="Slasher"
assert(Actors:GetEquippedActorInfo(p,"Killer",true)=="Slasher")
print("PASS actual EquipState and Actors randomized selection: owned permanent catalog entries only, stable UI display and regular selection unchanged")
