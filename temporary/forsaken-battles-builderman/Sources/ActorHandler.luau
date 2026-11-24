local module = {}

-- variables
local ReplicatedStorage = game.ReplicatedStorage
local Rigs = game.ServerStorage.Assets.Rigs -- optional location for rigs on the server. safer, but less convenient and less accurate to forsaken.
local ServerBehaviors = game.ServerScriptService.Server.Modules.ActorBehaviors -- where server protected behaviors are stored. (no clue why forsaken doesn't do something like this)

-- dependencies
local Network = require(ReplicatedStorage.Modules.Network)
local Actors = require(ReplicatedStorage.Modules.Actors)
local Util = require(ReplicatedStorage.Modules.Util)
local ServerUtil = require(game.ServerScriptService.Server.Modules.ServerUtil)
local safecall = ServerUtil.SafeCall
local Types = require(game.ReplicatedStorage.GlobalTypes)
local DataHandler = require(ReplicatedStorage.Modules.DataHandler)

local function cleanRig(rig : Model)
	local hum = rig:FindFirstChildOfClass("Humanoid")
	if hum and not hum:FindFirstChildOfClass("Animator") then
		Instance.new("Animator", hum)
	end
	if rig:FindFirstChild("AnimSaves") then
		rig.AnimSaves:Destroy()
	end
end

local function getOrCreateServerParent(assetFolder)
	local serverAssets = game.ServerStorage.Assets
	local parent = assetFolder.Parent
	if not parent then return nil end
	local grandParent = parent.Parent
	if not grandParent then return nil end

	if grandParent.Name == "Assets" then
		local pName = parent.Name
		local folder = serverAssets:FindFirstChild(pName)
		if not folder then
			folder = Instance.new("Folder")
			folder.Name = pName
			folder.Parent = serverAssets
		end
		return folder
	end

	local greatGrandParent = grandParent.Parent
	if greatGrandParent and greatGrandParent.Name == "Skins" then
		local skins = serverAssets:FindFirstChild("Skins")
		if not skins then
			skins = Instance.new("Folder")
			skins.Name = "Skins"
			skins.Parent = serverAssets
		end

		local categoryName = grandParent.Name
		local category = skins:FindFirstChild(categoryName)
		if not category then
			category = Instance.new("Folder")
			category.Name = categoryName
			category.Parent = skins
		end

		local actorName = parent.Name
		local actor = category:FindFirstChild(actorName)
		if not actor then
			actor = Instance.new("Folder")
			actor.Name = actorName
			actor.Parent = category
		end

		return actor
	end
	return nil
end

function module.Start()
	-- ability handling
	Network:SetConnection('UseActorAbility', 'REMOTE_EVENT', function(Player: Player, Name : string, requestFrame)
		-- setup variables
		local Actor : Types.Actor = Actors.CurrentActors[Player]
		if not Actor then return end

		-- Ensure player data is loaded using DataHandler
		local PlayerData = DataHandler:Get(Player)
		if not PlayerData then
			return
		end

		local Config = Actor.Config
		local Behavior = Actor.CustomBehavior or Actor.Behavior
		local Abilities = Behavior.Abilities

		-- checks
		if not (Player.Character and Player.Character.PrimaryPart and Player.Character.PrimaryPart.Anchored == false) then
			return
		end
		if not Actor:CanUseAbility(Name) then
			return
		end

		-- ability info
		local Ability = Abilities[Name]
		local Charges = Ability.CurrentCharges
		
		-- used for achievements
		if Ability.KeybindType ~= "MainAbility" then
			Player.Character:SetAttribute("AbilitiesUsed", (Player.Character:GetAttribute("AbilitiesUsed") or 0)+1)
		end

		-- handle cooldown
		local Time = tonumber(Config and typeof(Config) == "table" and Config.Cooldown or typeof(Ability.Cooldown) == "function" and Ability.Cooldown(Actor, Name) or Ability.Cooldown or Config[`{Name}Cooldown`] or Actor[("%s*Cooldown"):format(Name)]) or 0;
		if workspace:GetAttribute('CooldownsDisabled') then
			Time = 0
		end
		if Time > 0 then
			Actor:SetCooldownOf(Name, Time)
		end
		
		-- update charges
		if Charges then
			if (not workspace:GetAttribute('ChargesDisabled')) and (not Ability.ChargesDisabled) then
				Actor:IncrementCharges(Name, -1);
			end
		end
		
		-- get the callback function for the ability
		local callbackFunction
		if Behavior.Protected then
			-- handle skid protection for abilities
			local protectedBehavior = ServerBehaviors:FindFirstChild(Actor.ActorType) and ServerBehaviors[Actor.ActorType]:FindFirstChild(Actor.ActorName)
			if not protectedBehavior then
				warn(`[ActorHandler] Could not find {Actor.ActorName}'s protected behavior.`)
				return
			end

			local success = safecall(function() protectedBehavior = require(protectedBehavior) end)
			if not success then
				warn(`[ActorHandler] Failed to require {Actor.ActorName}'s protected behavior.`)
				return
			end

			callbackFunction = protectedBehavior.Abilities and protectedBehavior.Abilities[Name]
			if not callbackFunction then
				warn(`[ActorHandler] Could not find ability {Name} in {Actor.ActorName}'s protected behavior.`)
				return
			end
		else
			callbackFunction = Ability.Callback
		end

		-- calls the found callback function and gets the result
		local result
        if Actor.ActorName=="Builderman"and(Name=="Sentry"or Name=="Dispenser")then result=callbackFunction(Actor,requestFrame)
        else result=callbackFunction(Actor)end

		-- sets the cooldown to 0 if the ability returns cancelled
		if type(result) == "table" and result.Cancelled then
			Actor:SetCooldownOf(Name, 0)
			return
		end
		
		-- sends the result to the client
		Network:FireClientConnection(Player, 'UseActorAbility', 'REMOTE_EVENT', Name, result)

		-- handle thanks interaction for survivor requests
		if Player.Character and Player.Character:GetAttribute("Requested_"..Name) then
			local requester = Player.Character:GetAttribute("Requested_"..Name)
			if game.Players:FindFirstChild(requester) then
				Actors:CreateChatInteraction(game.Players[requester].Character, "Thanks/Thanks", Player.Character)
				Player.Character:SetAttribute("cRequested_"..Name, nil)
			end
		end
		
		if Actor.Behavior.OnAbilityUsed then
			Actor.Behavior.OnAbilityUsed(Actor, Name)
		end

		-- play voiceline for the ability
		Actor:PlayVoiceline(Name)
	end)

	-- ensure base folders exist on the server
	for _, folderName in {"Killers", "Survivors", "Skins"} do
		if not game.ServerStorage.Assets:FindFirstChild(folderName) then
			local newFolder = Instance.new("Folder")
			newFolder.Name = folderName
			newFolder.Parent = game.ServerStorage.Assets
		end
	end

	-- create a folder to store all rigs found in replicatedstorage
	local storedFolder = Instance.new("Folder", game.ServerStorage.Assets.Instances)
	storedFolder.Name = "Stored"
	Instance.new("Folder", storedFolder).Name = "Rigs"
	Instance.new("Folder", storedFolder).Name = "Decoys"
	
	-- tosearch array, the code will search through items in this array and attempt to find configs in their children
	local ToSearch = {game.ReplicatedStorage.Assets.Killers, game.ReplicatedStorage.Assets.Survivors}
	for _, actortype in game.ReplicatedStorage.Assets.Skins:GetChildren() do
		for _, actor in actortype:GetChildren() do
			table.insert(ToSearch, actor)
		end
	end
	
	-- go through every config in replicatedstorage.assets
	for _, folder : Folder in ToSearch do
		for _, assetFolder : Folder in folder:GetChildren() do
			if assetFolder:IsA("Folder") and assetFolder:FindFirstChild("Config") and assetFolder.Config:IsA("ModuleScript") then
				-- setup variables
				local config : ModuleScript = assetFolder.Config

				-- first attempts to find a rig in the replicatedstorage folder
				local rig : Model = assetFolder:FindFirstChild("Rig")
				if rig and rig:IsA("Model") then
					-- if successfully found, set the config's rig and continue
					cleanRig(rig)
					require(config).Rig = rig
					rig.Parent = storedFolder.Rigs
				else
					-- get the type of rig to look for
					local rigType = assetFolder.Parent.Name == "Killers" and "Killers" or assetFolder.Parent.Name == "Survivors" and "Survivors" or assetFolder.Parent.Parent.Parent.Name == "Skins" and "Skins"
					if rigType then
						-- identify info about the rig
						local actorType
						local actorName
						local skinName
						if rigType == "Skins" then
							actorType = assetFolder.Parent.Parent.Name
							actorName = assetFolder.Parent.Name
							skinName = assetFolder.Name
						else
							actorType = assetFolder.Parent.Name
							actorName = assetFolder.Name
						end

						-- attempt to find the rig inside serverstorage
						rig = Rigs:FindFirstChild(actorType) and Rigs[actorType]:FindFirstChild(actorName) and Rigs[actorType][actorName]:FindFirstChild(skinName or "Default")
						if not rig then
							warn("[ACTORHANDLER] NO RIG FOUND FOR "..assetFolder:GetFullName())
						else
							cleanRig(rig)

							-- set the config's rig
							safecall(function()
								require(config).Rig = rig
							end)
						end
					end
				end
				
				local requiredConfig = require(config)
				
				if requiredConfig.NotReplicated and requiredConfig.Exclusive then
					assetFolder:AddTag("NotReplicated")

					-- clone the exclusive folder to ServerStorage before modifying the original
					local serverParent = getOrCreateServerParent(assetFolder)
					if serverParent then
						local serverCopy = assetFolder:Clone()
						serverCopy.Parent = serverParent
					end

					for _, moduleName in {"Config", "Behavior"} do
						if not assetFolder:FindFirstChild(moduleName) then continue end

						local newModule = game.ServerStorage.Assets.Instances.TemplateModule:Clone()
						newModule.Parent = assetFolder
						newModule.Name = moduleName
						local ogModule : ModuleScript = assetFolder[moduleName]
						local newRequired = require(newModule)
						local ogRequired = require(ogModule)

						for i, v in table.clone(ogRequired) do
							newRequired[i] = v
							if moduleName == "Config" then
								newRequired.Rig = requiredConfig.Rig
							end
						end

						for _, v in ogModule:GetChildren() do
							v.Parent = newModule
						end

						ogModule:Destroy()
					end
					
					assetFolder.Parent = storedFolder.Decoys
				end
			end
		end
	end
end

return module