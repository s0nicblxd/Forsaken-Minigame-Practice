-- i genuinaly cannot believe i even managed to improve this

local module = {Loaded = false}

local DataStore = game:GetService("DataStoreService"):GetDataStore("Aeternus")
local ServerUtil = require(game.ServerScriptService.Server.Modules.ServerUtil)
local FastData = require(game.ReplicatedStorage.CoreLoader.FastData)
local HTTP = game:GetService("HttpService")
local Logging = require(game.ReplicatedStorage.Modules.Logging) -- lymes cookie logging support again again again

local logger = Logging.new({ Module = "PlayerData" })

local safecall = ServerUtil.SafeCall
local ValueMap = {
	["boolean"] = "BoolValue",
	["string"]  = "StringValue",
	["BrickColor"] = "BrickColorValue",
	["Color3"]  = "Color3Value",
	["CFrame"]  = "CFrameValue",
	["Ray"]     = "RayValue",
	["Vector3"] = "Vector3Value",
	["number"] = "NumberValue",
}

local function formatBytes(bytes)
	local units = {"B", "KB", "MB", "GB", "TB", "PB"}
	local size = bytes
	local unitIndex = 1

	while size >= 1024 and unitIndex < #units do
		size = size / 1024
		unitIndex = unitIndex + 1
	end

	if unitIndex == 1 then
		return string.format("%d %s", size, units[unitIndex])
	else
		return string.format("%.2f %s", size, units[unitIndex])
	end
end

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

local DefaultEquipped = GetTableFromFolder(script.Template.Equipped)

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

module.Start = function()
	game:BindToClose(function()
		task.wait(game:GetService("RunService"):IsStudio() and 2.5 or 7)
	end)
end

module.LoadData = function(_, Player: Player)
	if not module.Loaded then
		local skinsFolder = script.Template.Equipped.Skins
		for _, v in game.ReplicatedStorage.Assets.Skins.Survivors:GetChildren() do
			if not skinsFolder:FindFirstChild(v.Name) then
				Instance.new("StringValue", skinsFolder).Name = v.Name
			end
		end
		for _, v in game.ReplicatedStorage.Assets.Skins.Killers:GetChildren() do
			if not skinsFolder:FindFirstChild(v.Name) then
				Instance.new("StringValue", skinsFolder).Name = v.Name
			end
		end
		module.Loaded = true
	end

	local success, Data = safecall(function()
		return DataStore:GetAsync("Data_"..Player.UserId)
	end)

	local PlayerData = script.Template:Clone()
	PlayerData.Name = "PlayerData"
	PlayerData.Parent = game.ServerStorage.Assets.Miscellaneous.TemporaryData

	if success and Data then
		if game:GetService("RunService"):IsStudio() then
			print(Data)
			print(`\n\n[PLAYERDATA] Loading {Player.Name}'s data\nSize: {formatBytes(HTTP:JSONEncode(Data):len())}`)
		end

		if not Data["Achievements"] then 
			logger:warn(`[PLAYERDATA] Loading data failed for {Player.Name}: Corrupted or missing core fields.`)
			PlayerData.Parent = Player
			return
		end

		safecall(ApplyDataToFolder, Data, PlayerData)
		PlayerData.Parent = Player
	else
		if not success then logger:warn(`[PLAYERDATA] Fetch failed for {Player.Name}`) end
		PlayerData.Parent = Player
	end
end

module.SaveData = function(_, Player: Player)
	local originalFolder = Player:FindFirstChild("PlayerData")
	if not originalFolder then 
		logger:warn(`[PLAYERDATA] Saving error: PlayerData not found for player {Player.Name}`) 
		return 
	end

	local userID = Player.UserId
	local pData = originalFolder:Clone()
	pData.Parent = game.ServerStorage.Assets.Miscellaneous.TemporaryData

	safecall(function()
		for _, equipped in pairs(pData.Equipped:GetChildren()) do
			if equipped:IsA("StringValue") and (equipped.Name == "Killer" or equipped.Name == "Survivor") then
				local purchasedFolder = pData.Purchased:FindFirstChild(equipped.Name.."s")
				if purchasedFolder and equipped.Value~="Randomized" and not purchasedFolder:FindFirstChild(equipped.Value) then
					equipped.Value = DefaultEquipped[equipped.Name]
				end
			elseif equipped:IsA("Folder") and equipped.Name == "Skins" then
				for _, skin in pairs(equipped:GetChildren()) do
					if skin:IsA("StringValue") and skin.Value~="Randomized" and not pData.Purchased.Skins:FindFirstChild(skin.Value) then
						skin.Value = ""
					end
				end
			end
		end
	end)

	local ToSave = GetTableFromFolder(pData)
	local succeeded = false
	local attempts = 0
	local errorMsg
    
	while attempts < 3 and not succeeded do
		task.wait()
		local success, _, errormessage = safecall(function()
			if game:GetService("RunService"):IsStudio() then
				print(ToSave)
				print(`\n\n[PLAYERDATA] Saving {Player.Name}'s data\nSize: {formatBytes(HTTP:JSONEncode(ToSave):len())}`)
			end
			DataStore:UpdateAsync("Data_"..userID, function()
				return ToSave
			end)
		end)

		attempts += 1
		if success then
			succeeded = true
		else
			errorMsg = errormessage
		end
	end

	if (not succeeded) and game.ServerStorage.WebhookLinks:FindFirstChild("Debug") then
		task.spawn(function()
			local messageData = {
				content = "@everyone", 
				embeds = {{
					title = "PlayerData Error!", 
					type = "rich", 
					color = 15220543, 
					author = { name = "Aeternus" }, 
					footer = { text = (`Username: {Player.Name} | User ID: {userID}`) }, 
					fields = {
						{ name = "Error Message:", value = tostring(errorMsg), inline = false }, 
						{ name = "Join Server:", value = `[Server Link](https://www.roblox.com/games/start?launchData=%7B%22giftTarget%22%3A%22roblox%22%7D&placeId={game.PlaceId}&jobId={game.JobId})`, inline = false }
					}
				}}
			}
			local hookAttempts = 0
			while hookAttempts < 3 do
				local hookSuccess = pcall(function()
					local encoded = game.HttpService:JSONEncode(messageData)
					game.HttpService:PostAsync(game.ServerStorage.WebhookLinks.Debug.Value, encoded)
				end)
				if hookSuccess then break end
				task.wait(1)
				hookAttempts += 1
			end
		end)
	end
    
	pData:Destroy()
	FastData.DeepWipe(ToSave)
end

return module