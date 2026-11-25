local module = {}

local Janitor = require(game.ReplicatedStorage.Modules.Misc.Janitor) -- expect to see this ALOT on the engine
local Network = require(game.ReplicatedStorage.Modules.Network)
local Actors = require(game.ReplicatedStorage.Modules.Actors)
local ChatCommands = require(script.ChatCommands)
local GlobalConfig = require(game.ServerStorage.GlobalConfig)
local ManualRanks = GlobalConfig.ManualRanks
local CustomTitles = GlobalConfig.CustomTitles
local Data = require(game.ServerScriptService.Server.Systems.Data.PlayerData)
local Leaderstats = require(game.ServerScriptService.Server.Systems.Data.LeaderStats)
local ProductHandler = require(game.ServerScriptService.Server.Systems.Shopping.ProductHandler)
local AchievementUtil = require(game.ReplicatedStorage.Modules.AchievementUtil)
local Anticheat = require(game.ServerScriptService.Server.Systems.Core.Anticheat)
local Util = require(game.ReplicatedStorage.Modules.Util)
local FacialUnification = require(game.ReplicatedStorage.Modules.Misc.FacialUnification)

local PlayerJanitors = {}

module.Start = function()
	task.spawn(function()
		for _, plr in ipairs(game.Players:GetPlayers()) do
			task.spawn(module.InitPlayer, plr)
		end
		game.Players.PlayerAdded:Connect(module.InitPlayer)
		game.Players.PlayerRemoving:Connect(module.RemovePlayer)
	end)
end

module.InitCharacter = function(playerJanitor, Character : Model, Player : Player)
	local charJanitor = Janitor.new()
	playerJanitor:Add(charJanitor, "Destroy", "CharacterJanitor")

	if Character.Parent == game.Workspace then
		Character.Parent = workspace.Players.Spectating
		Character.PrimaryPart = Character.HumanoidRootPart
		for _, part in ipairs(Character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CollisionGroup = "Players"
			end
		end
		Character.Humanoid:SetAttribute("BaseSpeed", 16)
		FacialUnification:ConvertAnimatedHead(Character.Humanoid)
	else
		Character.Archivable = true
	end

	for _, instance in ipairs(script.CharacterEssentials:GetChildren()) do
		if not Character:FindFirstChild(instance.Name) then
			instance:Clone().Parent = Character
		end
	end

	local hrp = Character.PrimaryPart
	if hrp then
		charJanitor:Add(hrp.AncestryChanged:Connect(function()
			if hrp.Parent ~= nil then return end

			charJanitor:Remove("VoidKill")
			task.wait(game.Players.RespawnTime + 1)

			if Character.Parent and Player.Parent then
				Player:LoadCharacterAsync()
			end
		end), "Disconnect", "VoidKill")
	end
end

module.InitPlayer = function(Player : Player)
	local janitor = Janitor.new()
	PlayerJanitors[Player] = janitor

	local Rank = (game["Run Service"]:IsStudio() and Player.UserId < 0) and 999 or (game.CreatorType == Enum.CreatorType.Group and Player:GetRoleInGroupAsync(game.CreatorId) or ManualRanks[Player.UserId] or 0)
	if (not game["Run Service"]:IsStudio() and (not GlobalConfig.FreeTesting) and (Rank or 0) < 10) then
		Player:SetAttribute("NotAllowed", true)
		Player:Kick(GlobalConfig.NotAllowedKickMsg)
		return
	end

	Player:SetAttribute("Rank", Rank)
	Data:LoadData(Player)
	Leaderstats:AddStats(Player)
	ProductHandler:ActivatePasses(Player)

	if GlobalConfig.FreeVIP then
		Player:SetAttribute("VIP", true)
	end

	janitor:Add(Player.CharacterAdded:Connect(function(Character)
		module.InitCharacter(janitor, Character, Player)
	end), "Disconnect")

	if Player.Character then
		module.InitCharacter(janitor, Player.Character, Player)
	end

	if Rank and Rank >= 2 then
		local closestRank = 0
		local closestRankName = CustomTitles[Player.UserId] or game.CreatorType == Enum.CreatorType.Group and GlobalConfig.PreferCustomRankNames == false and Player:GetRoleInGroupAsync(game.CreatorId)
		if not closestRankName then
			for name, number in pairs(require(game.ServerScriptService.Server.Modules.RankNames)) do
				if number <= Rank and math.abs(number - Rank) < math.abs(closestRank - Rank) then
					closestRank = number
					closestRankName = name
				end
			end
		end
		Player:SetAttribute("RankTitle", closestRankName)
	end

	janitor:Add(Player.Chatted:Connect(function(msg)
		if game["Run Service"]:IsStudio() or (Player:GetAttribute("Rank") or 0) >= 100 then
			local args = string.split(msg, " ")
			local cmdName = args[1]
			if type(ChatCommands[cmdName]) == "function" then
				table.remove(args, 1)
				ChatCommands[cmdName](Player, table.unpack(args))
			end
		end
	end), "Disconnect")

	janitor:Add(task.spawn(function()
		while true do
			task.wait(1)
			if Player.Parent and Player:FindFirstChild("PlayerData") then
				Player.PlayerData.Stats.General.TimePlayed.Value += 1
			end
		end
	end), true)

	Anticheat.new(Player)
	janitor:Add(function()
		Anticheat:CleanupFromPlayer(Player)
	end, true)

	local playerData = Player:WaitForChild("PlayerData", 60)
	if not playerData then return end

	local purchased = playerData:WaitForChild("Purchased", 10)
	local equippedSkins = playerData:WaitForChild("Equipped"):WaitForChild("Skins")

	if purchased and equippedSkins then
		local function allocateSkin(val)
			if not equippedSkins:FindFirstChild(val.Name) then
				local skinVal = Instance.new("StringValue")
				skinVal.Name = val.Name
				skinVal.Parent = equippedSkins
			end
		end

		for _, val in ipairs(Util:MergeTables(purchased.Killers:GetChildren(), purchased.Survivors:GetChildren())) do
			allocateSkin(val)
		end

		janitor:Add(purchased.Killers.ChildAdded:Connect(allocateSkin), "Disconnect")
		janitor:Add(purchased.Survivors.ChildAdded:Connect(allocateSkin), "Disconnect")
	end
end

module.RemovePlayer = function(Player)
 require(game.ServerScriptService.Server.Systems.Data.CombatStatistics):FlushPlayer(Player)
	task.spawn(function()
		Data:SaveData(Player)
	end)

	local currentSessionModule = game.ServerScriptService.Server.Systems.Core:FindFirstChild("RoundManager")
	if currentSessionModule then
		local currentSession = require(currentSessionModule).CurrentSession
		if currentSession then
			local actor = Actors.CurrentActors[Player]
			if actor then
				local rig = actor.Rig
				local attackerName = rig:GetAttribute("RecentAttacker")

				if attackerName and rig:GetAttribute("RecentAttackerTime") and (os.clock() - rig:GetAttribute("RecentAttackerTime") <= 10) then
					local attacker = game.Players:FindFirstChild(attackerName)
					if attacker then
						Actors:IncrementActorStats(attacker, {
							Action = "Survivor ragequit mid-chase",
							Money = 15,
							EXP = 45
						})
						currentSession.TimePast -= currentSession.Gamemode.TimeAddedOnKill or 35
						AchievementUtil:IncrementAchievementProgress(attacker, "MakePlayerRagequit")
					end
				end
			end
		end
	end

	if PlayerJanitors[Player] then
		PlayerJanitors[Player]:Destroy()
		PlayerJanitors[Player] = nil
	end
end

return module