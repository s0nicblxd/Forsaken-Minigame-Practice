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