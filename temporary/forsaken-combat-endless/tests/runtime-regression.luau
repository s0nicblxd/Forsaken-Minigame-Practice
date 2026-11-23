
local function signal()
 local s={listeners={}}
 function s:Connect(fn)table.insert(self.listeners,fn);return {Disconnect=function()end}end
 function s:Fire(...)for _,fn in self.listeners do fn(...)end end
 return s
end
local function node(children)
 local n=children or {};n.attrs={};n.signals={}
 function n:FindFirstChild(name)return self[name]end
 function n:WaitForChild(name)return assert(self[name],name)end
 function n:GetAttribute(name)return self.attrs[name]end
 function n:GetAttributeChangedSignal(name)self.signals[name]=self.signals[name]or signal();return self.signals[name]end
 function n:GetPropertyChangedSignal(name)return self:GetAttributeChangedSignal('prop_'..name)end
 function n:SetAttribute(name,value)local old=self.attrs[name];self.attrs[name]=value;if old~=value then self:GetAttributeChangedSignal(name):Fire()end end
 return n
end
local Color3={fromRGB=function(r,g,b)return {r,g,b}end}
local TweenInfo={new=function()return {}end}
local task={spawn=function()end,delay=function()end}
local require=function(module)return module end

do

 local heartbeat=signal()
 local timer=node({Value='Waiting',attrs={}})
 local rep=node({RoundTimer=timer,ServerFPS={Value=60},Modules={},Assets={Sounds={OST={['30seconds']={IsLoaded=true,TimeLength=30}}}}})
 local workspace=node({Themes=node(),Map={Ingame=node({Map={}})}})
 local Workspace=workspace
 local sounds={PlayTheme=function()error('low-time music fired')end}
 local actors={CurrentActors={},IncrementActorStats=function()error('unexpected round payout')end}
 local actorReads=0
 local serverUtil={SafeCall=pcall,GetActorsOfType=function()actorReads+=1;return {}end}
 local mapVoting={StartVote=function()error('unexpected standard round vote')end}
 rep.Modules={Actors=actors,Sounds=sounds,Util={},Maps={},Network={},Stats={},MapVoting=mapVoting,AchievementUtil={}}
 local core=node({EventHandlerServer={}})
 local storage={GlobalConfig={},AeternusConfig={},Assets={Maps={}}}
 local playerGui=node({MainUI=node({Enabled=true})})
 local game={ReplicatedStorage=rep,ServerStorage=storage,ServerScriptService={Server={Modules={ServerUtil=serverUtil},Systems={Core=core}}},Players={LocalPlayer={PlayerGui=playerGui},PlayerRemoving=signal(),GetPlayers=function()return {}end}}
 game['Run Service']={Heartbeat=heartbeat}
 local tweenCalls=0
 local tweenService={Create=function()tweenCalls+=1;return {Play=function()end,Cancel=function()end}end}
 function game:GetService(name)if name=='ReplicatedStorage'then return rep elseif name=='TweenService'then return tweenService end end
 local policyScript=node({Parent={Parent=core}})
 local function policy()
  local script=policyScript
  return (function()
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Endless={}
function Endless.Enabled()
 return script:GetAttribute("Enabled")~=false
end
function Endless.Step(manager,delta)
 local timer=ReplicatedStorage:FindFirstChild("RoundTimer")
 if not Endless.Enabled()then
  if timer and timer:GetAttribute("EndlessCombat")then timer:SetAttribute("EndlessCombat",nil)end
  return false
 end
 manager.EndlessCombatElapsed=(manager.EndlessCombatElapsed or 0)+math.max(0,delta)
 local session=manager.CurrentSession
 if session and not manager.RoundInitiating and not manager.RoundEnding then
  session.ActualTimePast=(session.ActualTimePast or 0)+math.max(0,delta)
 end
 if timer then
  timer:SetAttribute("EndlessCombat",true)
  local mapRotation=script.Parent.Parent:FindFirstChild("MapRotation")
  if not mapRotation then
   timer.Value="Battle Till' Death!"
   timer:SetAttribute("TimeLeft",5999)
  end
 end
 return true
end
return Endless

  end)()
 end
 local Endless=policy()
 local script={EndlessCombat=Endless,Configuration={LobbyIntermissionTime=50,TimerTexts={InsufficientPlayers='Waiting'}}}
 local Manager=(function()
local EndlessCombat=require(script.EndlessCombat)
local RoundManager = {
	IntermissionTimePast = 0, -- timepast but for intermission (bcuz currentsession is nil during intermission)
	RoundTime = 0, -- subtracted from currentsession's timepast
	DoHeartbeat = true, -- used to toggle the heartbeat loop
	RoundEnding = false, -- debounce
	RoundInitiating = false, -- debounce
	GamemodeThingy = 1, -- explained later on
}

local Actors = require(game.ReplicatedStorage.Modules.Actors)
local Sounds = require(game.ReplicatedStorage.Modules.Sounds)
local Util = require(game.ReplicatedStorage.Modules.Util)
local ServerUtil = require(game.ServerScriptService.Server.Modules.ServerUtil)
local safeCall = ServerUtil.SafeCall
local Maps = require(game.ReplicatedStorage.Modules.Maps)
local Network = require(game.ReplicatedStorage.Modules.Network)
local Configuration = require(script.Configuration)
local StatsModule = require(game.ReplicatedStorage.Modules.Stats)
local MapVoting = require(game.ReplicatedStorage.Modules.MapVoting)
local AchievementUtil = require(game.ReplicatedStorage.Modules.AchievementUtil)
local Types = require(game.ReplicatedStorage.GlobalTypes)
local EventHandler = require(game.ServerScriptService.Server.Systems.Core.EventHandlerServer)

local FPSValue
local GlobalConfig = require(game.ServerStorage.GlobalConfig)
local lowTimeThreshold = 31
local lowTimeSound = game.ReplicatedStorage.Assets.Sounds.OST["30seconds"]
local Themes = workspace:WaitForChild("Themes")
local MapsFolder = game.ServerStorage.Assets.Maps

-- adjust lowTimeThreshold based on the length of the audio
task.spawn(function()
	local startingTime = os.time()
	-- wait until the sound is loaded, because otherwise timelength is 0
	repeat task.wait() until (lowTimeSound.IsLoaded and lowTimeSound.TimeLength > 0) or os.time()-startingTime > 15
	if lowTimeSound.IsLoaded and lowTimeSound.TimeLength > 0 then
		lowTimeThreshold = lowTimeSound.TimeLength
	end
end)

-- returns a random gamemode
function RoundManager:RandomGamemode()
	if workspace:GetAttribute("ForcedGamemode") then return workspace:GetAttribute("ForcedGamemode") end
	if (not GlobalConfig.GamemodeSelection) or RoundManager.GamemodeThingy < 3 then return "Standard" end

	local available = {}
	for _, gamemode in ipairs(game.ReplicatedStorage.Modules.Gamemodes:GetChildren()) do
		if gamemode.Name == "Standard" then continue end
		if gamemode:IsA("ModuleScript") then
			local success, config = safeCall(require, gamemode)
			if success and type(config) == "table" then
				if config.Enabled ~= false and config.Exclusive ~= true and #GetEligiblePlayers() >= (config.PlayerRequirement or 0) then
					table.insert(available, gamemode.Name)
				end
			end
		end
	end
	if #available == 0 then
		warn("[RoundManager] No available gamemodes found.")
		return "Standard"
	end
	return available[math.random(1, #available)]
end

-- gets all players who can be placed into a round
function GetEligiblePlayers()
	local currentPlrs = {}
	for _, plr in ipairs(game.Players:GetPlayers()) do
		local plrSettings = plr:FindFirstChild("PlayerData") and plr.PlayerData:FindFirstChild("Settings")
		if plr:GetAttribute("Loaded") and plrSettings and (not plrSettings:FindFirstChild("AFK", true) or not plrSettings:FindFirstChild("AFK", true).Value) then
			table.insert(currentPlrs, plr)
		end
	end
	return currentPlrs
end

-- plays a winner cutscene for the winner
RoundManager.WinnerCutscene = function(_, winner, winnerActors)
	return safeCall(function()
		winnerActors = winnerActors or ServerUtil:GetActorsOfType(winner)
		if winner == "Killers" then
			local wonKiller = winnerActors[1]
			if wonKiller and wonKiller.Rig and wonKiller.Rig.Parent then
				local killerBG : Model = game.ServerStorage.Assets.Instances.KillerBackgrounds.Victory:FindFirstChild(wonKiller.ActorName) and (wonKiller.SkinFolder and game.ServerStorage.Assets.Instances.KillerBackgrounds.Victory[wonKiller.ActorName]:FindFirstChild(wonKiller.SkinFolder.Name) or game.ServerStorage.Assets.Instances.KillerBackgrounds.Victory[wonKiller.ActorName]:FindFirstChild("Default"))
				if killerBG then
					killerBG = killerBG:Clone()
					killerBG.Parent = workspace.Misc
					killerBG.Name = "KillerCutsceneBackground"
					killerBG:PivotTo(CFrame.new(0, 10000, 0))
					game:GetService("Debris"):AddItem(killerBG, 25)
				end
				Network:FireAllClientConnection("PlayWinnerCutscene", "REMOTE_EVENT", winner, winnerActors)
				return true
			end
		else
			local compressedActors = {}
			for _, actor in winnerActors do
				table.insert(compressedActors, {Rig = actor.Rig, Username = actor.Username})
			end
			Network:FireAllClientConnection("PlayWinnerCutscene", "REMOTE_EVENT", winner, compressedActors)
		end
	end)
end

-- starts a round
RoundManager.InitRound = function()
	if EndlessCombat.Enabled()then return end
	-- debounce just in case
	if RoundManager.RoundInitiating then
		return
	else
		RoundManager.RoundInitiating = true
	end
	
	local votedMap = MapVoting:GetMostVotedMapName()
	votedMap = votedMap == "N/A" and "random" or votedMap
	
	local votedConfig = MapsFolder:FindFirstChild(votedMap) and MapsFolder[votedMap]:FindFirstChild("Config") and require(MapsFolder[votedMap].Config)
	if votedConfig and type(votedConfig.Variants) == "table" then
		local variants = {}
		for variant in votedConfig.Variants do
			table.insert(variants, variant)
		end
		if #variants > 0 then
			votedMap = `{votedMap}/{variants[math.random(1, #variants)]}`
		end
	end
	
	MapVoting:Destroy()
	
	local roundTimer = game.ReplicatedStorage.RoundTimer
	roundTimer.Value = Configuration.TimerTexts.Loading
	RoundManager.DoHeartbeat = false

	if (not workspace:GetAttribute("NoTimer")) and (#GetEligiblePlayers() > 1) then
		Network:FireAllClientConnection("PreHandleGamemode", "REMOTE_EVENT", "Init")
	end

	local ChosenGamemode = RoundManager:RandomGamemode()
	-- one special gamemode every 3 rounds. you can change this
	if RoundManager.GamemodeThingy >= 3 then
		RoundManager.GamemodeThingy = 1
	else
		RoundManager.GamemodeThingy += 1
	end
	workspace:SetAttribute("ForcedGamemode", nil)
	local modeModule = require(game.ReplicatedStorage.Modules.Gamemodes[ChosenGamemode])
	
	-- define new currentsession
	RoundManager.CurrentSession = {
		TimePast = 0, -- self explanatory
		ActualTimePast = 0, -- goes up alongside timepast, except it doesnt ever get subtracted. used for 60 second rewards
		Gamemode = nil, -- for the autocomplete
		Players = {},
		WinningDisabled = false -- i honestly dont like this, but the real forsaken does it so
	}
	
	-- set up playerinfo for all eligible players
	for _, plr in pairs(GetEligiblePlayers()) do
		local plrStats = plr:FindFirstChild("PlayerData") and plr.PlayerData:FindFirstChild("Stats")
		table.insert(RoundManager.CurrentSession.Players, {
			Instance = plr,
			KillerChance = plrStats and plrStats:FindFirstChild("KillerChance", true),
			Character = plr.Character,
			isPlayerKillable = false, -- i could not tell you what on earth this does, but the real forsaken has it
			State = "Alive",
			Connections = {},
		})
	end
	
	-- additional values for currentsession
	RoundManager.CurrentSession.WinningDisabled = #RoundManager.CurrentSession.Players < 2 and not workspace:GetAttribute("Testing")
	RoundManager.CurrentSession.Gamemode = modeModule.Init(RoundManager.CurrentSession)
	RoundManager.RoundTime = (RoundManager.CurrentSession.Gamemode and RoundManager.CurrentSession.Gamemode.RoundTime) or 240 -- subtracted from timepast to calculate time displayed on the timer
	
	-- allows for easier customization through gamemodes
	for i, v in pairs(RoundManager.CurrentSession) do
		RoundManager.CurrentSession[i] = modeModule[i] or RoundManager.CurrentSession[i]
	end
	Network:FireAllClientConnection("HandleGamemode", "REMOTE_EVENT", "Init", ChosenGamemode, RoundManager.CurrentSession)
	
	-- gamemode notification thingy, you can remove this if you want. done on the server because i refrain from modifying client side code
	if GlobalConfig.GamemodeSelection then
		task.spawn(function()
			for _, plr in pairs(game.Players:GetPlayers()) do
				local newNotif = game.ServerStorage.Assets.UI.GamemodeNotif:Clone()
				local newGui = Instance.new("ScreenGui")
				newGui.Name = "GamemodeNotifGui"
				newGui.DisplayOrder = 10
				newGui.ResetOnSpawn = false
				newGui.IgnoreGuiInset = true
				local ogSize = newNotif.Size
				local ogThickness = newNotif.UIStroke.Thickness
				pcall(function()
					newNotif.Title.Text = RoundManager.CurrentSession.Gamemode.Name
					newNotif.Description.Text = (plr.Character and plr.Character.Parent and RoundManager.CurrentSession.Gamemode.Descriptions[plr.Character.Parent.Name]) or RoundManager.CurrentSession.Gamemode.Descriptions["Survivors"]
				end)
				newNotif.Parent = newGui
				newGui.Parent = plr.PlayerGui
			end
		end)
	end

	for _, plrInfo in pairs(RoundManager.CurrentSession.Players) do
		task.spawn(function()
			local rig : Model = plrInfo.Character
			local plr : Player = plrInfo.Instance
			local actor = Actors.CurrentActors[plr]
			if not (rig and plr and actor) then return end
			local actorType = actor.ActorType
			--if actorType == "Killer" and workspace:GetAttribute("ServerType") ~= "VIP" and ((not RoundManager.CurrentSession.Gamemode) or RoundManager.CurrentSession.Gamemode.AddMalice ~= false) then
			--	local killerChance = plrInfo.KillerChance
			--	if killerChance and killerChance:IsA("NumberValue") then
			--		killerChance.Value = 1
			--	end
			--end
			
			plrInfo.Team = actorType.."s"
			
			if rig and rig:FindFirstChildOfClass("Humanoid") then
				local deathConnection = rig:FindFirstChildOfClass("Humanoid").Died:Connect(function()
					plrInfo.State = "Dead"
					
					if plr and actorType == "Survivor" then
						plrInfo.DeathTime = RoundManager.CurrentSession.ActualTimePast
					end
					
					if workspace:GetAttribute("ServerType") ~= "VIP" then
						local losses : NumberValue = plr and plr:FindFirstChild("PlayerData") and plr.PlayerData:FindFirstChild(actorType.."Losses", true)
						if losses then
							losses.Value+=1
						end
					end
					
					if plrInfo.DeathTime and plrInfo.DeathTime <= 20 then
						AchievementUtil:IncrementAchievementProgress(plrInfo.Instance, "BadAtTheGame", 1)	
					end
					
					if RoundManager.CurrentSession and RoundManager.CurrentMap then
						AchievementUtil:IncrementAchievementProgress(plrInfo.Instance, "RespawningElsewhere", RoundManager.CurrentMap.MapFolder.Name)
					end
				end)
				table.insert(plrInfo.Connections, deathConnection)
			else
				return
			end
		end)
	end
	
	-- no twotime respawn for onebounce
	if RoundManager.CurrentSession.Gamemode and RoundManager.CurrentSession.Gamemode.DisableOnLMS then
		Instance.new("Model", workspace.Players.Survivors).Name = "ImASurvivorTrust"
	end
	
	-- just incase
	task.wait(0.1)

	if RoundManager.CurrentSession and not RoundManager.CurrentMap then
		RoundManager.CurrentMap = Maps:CreateMap(votedMap or "Random")
	end
	RoundManager.DoHeartbeat = true
	RoundManager.RoundInitiating = false
end

-- ends a round
RoundManager.EndRound = function()
	if EndlessCombat.Enabled()then return end
	-- debounce just in case
	if RoundManager.RoundEnding then
		return
	else
		RoundManager.RoundEnding = true
	end
	RoundManager.DoHeartbeat = false
	
	-- determines winner based on amount of actors
	local survivorActors = ServerUtil:GetActorsOfType("Survivors", true)
	local killerActors = ServerUtil:GetActorsOfType("Killers", true)
	local winner = (#survivorActors > 0 or #killerActors < 1) and "Survivors" or "Killers"
	local winnerActors = winner == "Survivors" and survivorActors or killerActors
	
	EventHandler:CallMethod("RoundEnded", winner, survivorActors, killerActors)
	
	local totalSurvivorCount = 0
	local lastSurvivor
	for _, plrInfo in RoundManager.CurrentSession.Players do
		if plrInfo.Team == "Survivors" then
			totalSurvivorCount += 1
			lastSurvivor = plrInfo.Instance
		end
	end
	
	-- sets every actor's username because roundnetwork uses it
	for _, actor in pairs(winnerActors) do
		if actor.Player then
			actor.Username = actor.Player.Name
		end
	end

	-- cleanup
	for _, theme in pairs(Themes:GetChildren()) do
		if theme:IsA("Sound") and (theme.Name == "LastSurvivor" or theme.Name == "30seconds") then
			theme:Destroy()
		end
	end
	workspace.Misc:ClearAllChildren()
	if RoundManager.CurrentMap and RoundManager.CurrentMap.Map then
		RoundManager.CurrentMap.Map:Destroy()
	end
	
	StatsModule:CreateStatsFolder()
	
	Network:FireConnection("RoundEnded", "BINDABLE_EVENT")
	Network:FireAllClientConnection("RoundEnded", "REMOTE_EVENT")
	if RoundManager.CurrentSession.Gamemode then
		safeCall(RoundManager.CurrentSession.Gamemode.Destroy, RoundManager.CurrentSession.Gamemode)
	end
	Network:FireAllClientConnection("HandleGamemode", "REMOTE_EVENT", "Destroy")

	-- winner cutscene
	if not RoundManager.CurrentSession.WinningDisabled then
		task.spawn(function()
			RoundManager:WinnerCutscene(winner, winnerActors)
		end)
	end

	task.spawn(function()
		if winnerActors[1] and typeof(winnerActors[1].Player) == "Instance" and winnerActors[1].Player:IsA("Player") then
			game.AnalyticsService:LogCustomEvent(winnerActors[1].Player, winner.."Wins", 1)
		end
	end)


	for _, actor in pairs(Actors.CurrentActors) do
		task.spawn(function()
			if not actor.Player then return end
			if not actor.Player:FindFirstChild("PlayerData") then return end
			
			if (not actor.Rig) or (not actor.Rig:FindFirstChildOfClass("Humanoid")) or actor.Rig:FindFirstChildOfClass("Humanoid").Health <= 0 then
				return
			end
			
			if workspace:GetAttribute("ServerType") ~= "VIP" then
				-- adds a win or loss value to the player's playerdata
				local value : NumberValue = actor.Player:FindFirstChild("PlayerData") and actor.Player.PlayerData:FindFirstChild(actor.ActorType.."s"==winner and string.sub(winner, 1, string.len(winner)-1).."Wins" or actor.ActorType.."Losses", true)
				if value then
					value.Value += 1
				end
			end
			
			if winner == actor.ActorType.."s" and actor.Rig:FindFirstChildOfClass("Humanoid").Health < actor.Rig:FindFirstChildOfClass("Humanoid").MaxHealth/10 then
				AchievementUtil:IncrementAchievementProgress(actor.Player, "BarelyAlive", 1)
			end
			
			if winner == "Killers" and actor.ActorType == "Killer" and #RoundManager.CurrentSession.Players == game.Players.MaxPlayers then
				AchievementUtil:IncrementAchievementProgress(actor.Player, "ServerWiped", 1)
			end
			
			if winner == "Survivors" and actor.ActorType == "Survivor" and #RoundManager.CurrentSession.Players == game.Players.MaxPlayers and #survivorActors == totalSurvivorCount then
				AchievementUtil:IncrementAchievementProgress(actor.Player, "TeamEffort", 1)
			end
			
			if winner == "Survivors" and actor.ActorType == "Survivor" and not actor.Rig:GetAttribute("RecentAttacker") then
				AchievementUtil:IncrementAchievementProgress(actor.Player, "NoHit", 1)
			end
			
			if winner == actor.ActorType.."s" and not actor.Rig:GetAttribute("AbilitiesUsed") then
				if actor.ActorType == "Survivor" then
					AchievementUtil:IncrementAchievementProgress(actor.Player, "NoAbilities", 1)
				elseif actor.ActorType == "Killer" then
					AchievementUtil:IncrementAchievementProgress(actor.Player, "NoAbilitiesHardMode", 1)
				end
			end
			
			if actor.ActorType == "Survivor" and winner == "Survivors" then
				AchievementUtil:IncrementAchievementProgress(actor.Player, "TrueSurvivalist", RoundManager.CurrentMap.MapFolder.Name)
			end
			
			-- rewards players
			local reward
			if actor.ActorType == "Survivor" and winner == "Survivors" then
				reward = table.clone(Configuration.SurvivorWinReward)
			elseif actor.ActorType == "Killer" then
				reward = winner == "Killers" and table.clone(Configuration.KillerWinReward) or table.clone(Configuration.KillerLostReward)
			end
			if not reward then return end
			Actors:IncrementActorStats(actor.Player, reward)
		end)
		
		-- player cleanup
		local player = actor.Player
		safeCall(function() Actors:CleanupActorFromPlayer(actor.Player) end)
		task.delay(1.5, function()
			player:LoadCharacter()
		end)
	end
	
	workspace.Map.Ingame:ClearAllChildren()
	
	if #winnerActors == 1 and winner == "Survivors" then
		AchievementUtil:IncrementAchievementProgress(winnerActors[1].Player, "LastSurvivorWin", 1)			
	end

	if RoundManager.CurrentSession.LastSurvivorAlive and winner == "Killers" then
		AchievementUtil:IncrementAchievementProgress(RoundManager.CurrentSession.LastSurvivorAlive, "LastSurvivorDied", 1)
	end
	
	-- cleanup NPCs
	task.delay(1, function()
		for _, survivor in pairs(workspace.Players.Survivors:GetChildren()) do
			if not game.Players:GetPlayerFromCharacter(survivor) then
				survivor:Destroy()
			end
		end
	end)
	
	-- rewards survived for 60 seconds
	for _, player in pairs(RoundManager.CurrentSession.Players) do
		if player.Instance and player.Instance.Parent and player.DeathTime and player.DeathTime >= 60 then
			Actors:IncrementActorStats(player.Instance, table.clone(Configuration.SixtySecondReward))
		end
	end

	-- cleanup connections
	for _, plrInfo in pairs(RoundManager.CurrentSession.Players) do
		for _, conn in pairs(plrInfo.Connections) do
			conn:Disconnect()
		end
	end
	
	RoundManager.CurrentSession = nil
	RoundManager.CurrentMap = nil
	RoundManager.RoundTime = 0
	RoundManager.IntermissionTimePast = 0
	ServerUtil:LoadPosters()
	
	task.wait(1.5)
	RoundManager.DoHeartbeat = true
	RoundManager.RoundEnding = false

end

-- activates last man standing
RoundManager.LMS = function()
	if EndlessCombat.Enabled()then return end
	RoundManager.CurrentSession.LastSurvivorAlive = true
	RoundManager.DoHeartbeat = false
	local Killers : {Types.Actor} = ServerUtil:GetActorsOfType("Killers", true)
	local LastKiller = Killers[1]
	local LastSurvivor : Types.Actor = ServerUtil:GetActorsOfType("Survivors", true)[1]
	RoundManager.CurrentSession.LastSurvivorAlive = LastSurvivor.Player
	local LMS = {
		ThemeID = game.ReplicatedStorage.Assets.Sounds.OST.eternalFight.SoundId,
		ThemeProperties = {
			Volume = 1,
		},
		RoundTime = 72,
	}

	local emotional = false
	
	local specialTheme = (RoundManager.CurrentSession.Gamemode and RoundManager.CurrentSession.Gamemode.LMSTheme) or (RoundManager.CurrentMap and RoundManager.CurrentMap.Config and RoundManager.CurrentMap.Config.LastManStandingData)
	if LastKiller and LastSurvivor and LastKiller.Config and LastKiller.Config.LastManStandingEmotionalData and LastKiller.Config.Relations and not (RoundManager.CurrentSession.Gamemode and RoundManager.CurrentSession.Gamemode.DisableEmotionalThemes) then
		
		local Relations = table.clone(LastKiller.Config.Relations)
		local DefaultFolder = LastKiller.Folder
		if typeof(DefaultFolder) == "Instance" and DefaultFolder:IsA("Folder") then
			local defaultConfig = DefaultFolder:FindFirstChild("Config")
			if defaultConfig then
				defaultConfig = require(defaultConfig)
				if defaultConfig.Relations then
					for _, relation in pairs(defaultConfig.Relations) do
						if not table.find(Relations, relation) then
							table.insert(Relations, relation)
						end
					end
				end
			end
		end
		
		for _, Name in ipairs(Relations) do
			if (LastSurvivor.SkinFolder and LastSurvivor.SkinFolder.Name == Name) or LastSurvivor.ActorName == Name then
				specialTheme = LastKiller.Config.LastManStandingEmotionalData[Name]
				emotional = true
				break
			end
		end
		
		if (not specialTheme) and emotional then
			specialTheme = LastKiller.Config.LastManStandingEmotionalData
		end
	end

	if (not specialTheme) and (not (RoundManager.CurrentSession.Gamemode and RoundManager.CurrentSession.Gamemode.DisableEmotionalThemes)) then
		specialTheme = (LastKiller.Config and LastKiller.Config.LastManStandingData) or (LastSurvivor.Config and LastSurvivor.Config.LastManStandingData) or nil
	end
	
	LMS = specialTheme or LMS
	LMS.ThemeProperties = LMS.ThemeProperties or {}
	LMS.ThemeProperties.Priority = 10

	RoundManager.CurrentSession.TimePast = 0
	RoundManager.RoundTime = LMS.RoundTime
	local theme = Sounds:PlayTheme(LMS.ThemeID, LMS.ThemeProperties)
	theme.Name = "LastSurvivor"
	
	if workspace:FindFirstChild("Ragdolls") then
		for _, v in workspace.Players.Survivors:GetChildren() do
			if v ~= LastSurvivor.Rig then
				v.Parent = workspace.Ragdolls			
			end
		end
	end
	
	safeCall(function()
		for _, killer in pairs(Killers) do
			Util:RevealPlayerAuraTo(killer.Rig, LastSurvivor.Rig, RoundManager.CurrentSession.Gamemode and RoundManager.CurrentSession.Gamemode.LMSRevealTime or 8)
			Util:RevealPlayerAuraTo(LastSurvivor.Rig, killer.Rig, RoundManager.CurrentSession.Gamemode and RoundManager.CurrentSession.Gamemode.LMSRevealTime or 8)
			
			local voiceline = "LastSurvivor"
			if emotional then
				voiceline = "LastSurvivorEmotional"
			end
			if killer.Config and killer.Config.Voicelines then
				if type(LastSurvivor.ActorName) == "string" and killer.Config.Voicelines["LastSurvivor"..LastSurvivor.ActorName] then
					voiceline = "LastSurvivor"..LastSurvivor.ActorName
				end
				if type(LastSurvivor.ActorSkin) == "string" and killer.Config.Voicelines["LastSurvivor"..LastSurvivor.ActorSkin] then
					voiceline = "LastSurvivor"..LastSurvivor.ActorSkin
				end
			end
			
			killer:PlayVoiceline(voiceline)
			
			if not RoundManager.CurrentSession.Gamemode.DisableOnLMS then
				if killer.Behavior and killer.Behavior.LastManStanding then
					killer.Behavior:LastManStanding(killer, LastSurvivor)
				end
				if LastSurvivor.Behavior and LastSurvivor.Behavior.LastManStanding then
					LastSurvivor.Behavior:LastManStanding(LastSurvivor, killer)
				end
			end
		end
	end)
	
	Network:FireAllClientConnection("LastSurvivor", "REMOTE_EVENT")
	
	if specialTheme then
		if LastKiller.Config and LastKiller.Config.ELMSLighting then
			require(game.ReplicatedStorage.Modules.Schematics.Lighting):SetCustomLighting(LastKiller.Config.ELMSLighting)
		end
	else
		if LastKiller.Config and LastKiller.Config.LMSLighting then
			require(game.ReplicatedStorage.Modules.Schematics.Lighting):SetCustomLighting(LastKiller.Config.LMSLighting)
		end
	end
	
	RoundManager.DoHeartbeat = true
end

RoundManager.Start = function()
	EndlessCombat.Step(RoundManager,0)
	FPSValue = --[[workspace:GetAttribute("Testing") and]] game.ReplicatedStorage:WaitForChild("ServerFPS")
	game["Run Service"].Heartbeat:Connect(function(delta)
		--if workspace:GetAttribute("Testing") then
			FPSValue.Value = math.floor(1 / delta)
		--end

		if EndlessCombat.Step(RoundManager,delta)then return end
		if not RoundManager.DoHeartbeat then return end

		local RoundTimer = game.ReplicatedStorage.RoundTimer

		if RoundManager.CurrentSession and (not RoundManager.RoundInitiating) and RoundManager.CurrentMap and workspace.Map.Ingame:FindFirstChild("Map") then
			-- DURING ROUND
			if workspace:GetAttribute("NoTimer") then
				RoundTimer:SetAttribute("TimeLeft", 5999)
				RoundTimer.Value = Configuration.TimerTexts.TimerDisabled
				return
			end
			
			local Survivors = ServerUtil:GetActorsOfType("Survivors", true)
			local Killers = ServerUtil:GetActorsOfType("Killers", true)

			if RoundManager.CurrentSession.TimePast >= RoundManager.RoundTime or #Survivors <= 0 or #Killers <= 0 then
				task.delay(0.25, RoundManager.EndRound, #Survivors, #Killers)
			elseif (not RoundManager.CurrentSession.LastSurvivorAlive) and #Survivors == 1 and #Killers > 0 then
				RoundManager:LMS()
			end

			if not RoundManager.CurrentSession then return end

			RoundTimer.Value = Configuration.TimerTexts.DuringRound
			
			local TimerSpeed = 1
			if workspace:GetAttribute("BloodHuntActive") and not RoundManager.CurrentSession.LastSurvivorAlive then
				TimerSpeed /= 2
			end
			
			RoundManager.CurrentSession.TimePast += delta*TimerSpeed
			RoundManager.CurrentSession.ActualTimePast += delta
			RoundTimer:SetAttribute("TimeLeft", RoundManager.RoundTime - RoundManager.CurrentSession.TimePast)
			
			if RoundManager.RoundTime - RoundManager.CurrentSession.TimePast < lowTimeThreshold then
				if not Themes:FindFirstChild("30seconds") then
					Sounds:PlayTheme("30seconds"):SetAttribute("DeloadOnDeath", true)
				end
			elseif Themes:FindFirstChild("30seconds") then
				Sounds:StopTheme("30seconds")
			end
		else
			-- DURING INTERMISSION
			if RoundManager.IntermissionTimePast >= Configuration.LobbyIntermissionTime then
				RoundManager.IntermissionTimePast = 0
				RoundManager.InitRound()
				return
			end

			if workspace:GetAttribute("NoTimer") then return end

			if #GetEligiblePlayers() <= 1 then
				RoundManager.IntermissionTimePast = 0
				RoundTimer.Value = Configuration.TimerTexts.InsufficientPlayers
				RoundTimer:SetAttribute("TimeLeft", 0)
				return
			end
			
			if (RoundManager.IntermissionTimePast >= Configuration.LobbyIntermissionTime - MapVoting.VoteDuration) and (not MapVoting.CurrentVote) then
				MapVoting:StartVote()
			end

			RoundTimer.Value = Configuration.TimerTexts.Lobby
			RoundManager.IntermissionTimePast += delta
			RoundTimer:SetAttribute("TimeLeft", Configuration.LobbyIntermissionTime - RoundManager.IntermissionTimePast)
		end
	end)
	
	game.Players.PlayerRemoving:Connect(function(leavingPlr)
		if RoundManager.CurrentSession and RoundManager.CurrentSession.Players then
			for i, plrInfo in pairs(RoundManager.CurrentSession.Players) do
				if plrInfo.Instance == leavingPlr then
					for _, conn in pairs(plrInfo.Connections) do
						conn:Disconnect()
					end
					table.remove(RoundManager.CurrentSession.Players, i)
				end
			end
		end
	end)
	
end

-- adds timeAmount to the round timer
function RoundManager:AddTime(timeAmount : number, timeMultiplier : number)
	if EndlessCombat.Enabled()then return end
	if not RoundManager.CurrentSession then
		return
	end
	if not RoundManager.CurrentSession.TimePast then
		return
	end
	local timeAdded = timeAmount or (RoundManager.CurrentSession.Gamemode and RoundManager.CurrentSession.Gamemode.TimeAddedOnKill) or 35
	timeAdded *= timeMultiplier or 1
	RoundManager.CurrentSession.TimePast -= timeAdded
end

task.delay(5, function()
	ServerUtil:LoadPosters()
end)

return RoundManager
 end)()
 Manager.Start()
 assert(timer:GetAttribute('EndlessCombat')and timer.Value=="Battle Till' Death!"and timer:GetAttribute('TimeLeft')==5999)
 local session={ActualTimePast=8,TimePast=100000,Players={}}
 Manager.CurrentSession=session;Manager.RoundTime=10;Manager.CurrentMap={};Manager.DoHeartbeat=false
 heartbeat:Fire(5)
 assert(Manager.EndlessCombatElapsed==5 and session.ActualTimePast==13 and session.TimePast==100000)
 assert(actorReads==0,'empty roles must not trigger a round ending or LMS')
 Manager.DoHeartbeat=true;Manager.RoundsDisabled=false
 heartbeat:Fire(100000)
 assert(session.ActualTimePast==100013 and session.TimePast==100000 and not Manager.RoundEnding)
 Manager.InitRound();Manager.EndRound();Manager.LMS();Manager:AddTime(35)
 assert(not Manager.RoundInitiating and not Manager.RoundEnding and not session.LastSurvivorAlive and session.TimePast==100000)
 Manager.RoundInitiating=true;heartbeat:Fire(1);assert(session.ActualTimePast==100013);Manager.RoundInitiating=false
 local elapsed=Manager.EndlessCombatElapsed;Endless.Step(Manager,-4);assert(Manager.EndlessCombatElapsed==elapsed)
 -- An independent FCF map clock owns its own values and keeps them.
 core.MapRotation={};timer.Value='NEXT MAP';timer:SetAttribute('TimeLeft',20)
 heartbeat:Fire(1);assert(timer.Value=='NEXT MAP'and timer:GetAttribute('TimeLeft')==20 and timer:GetAttribute('EndlessCombat'))
 -- Real HUD module, including late-join initialization and replicated-attribute updates.
 local main={Title={Text=''},Time={Text=''}}
 local clone={Main=main,Enabled=true};local hudScript={RoundTimer={Clone=function()return clone end}}
 rep.Modules.Network={SetConnection=function(self,key,kind,callback)self[key]=callback end}
 rep.Modules.Misc={Signal={new=signal}}
 local HUD=(function()
  local script=hudScript
  return (function()
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Network = require(ReplicatedStorage.Modules.Network)
local Signal = require(ReplicatedStorage.Modules.Misc.Signal)
local delay = task.delay
local tweenInfo = TweenInfo.new(0.5)
local color3 = Color3.fromRGB(141, 0, 0)
local color3_2 = Color3.fromRGB(255, 255, 255)
local t1 = {
	["Ingame timer disabled"] = "TIMER_DISABLED",
	["Round ends in:"] = "ROUND_ENDS_IN",
	["Round begins in:"] = "ROUND_BEGINS_IN",
	["Waiting for more players."] = "WAITING_FOR_PLAYERS"
}

return {
	onRoundTimerUpdated = Signal.new(),
	Start = function(p1) -- line: 31
		-- upvalues: t1 (copy), Network (copy), TweenService (copy), tweenInfo (copy), color3 (copy), delay (copy), color3_2 (copy)
		local LocalPlayer = game.Players.LocalPlayer
		local clone = script.RoundTimer:Clone()
		local Main = clone.Main

		clone.Parent = LocalPlayer.PlayerGui

		local RoundTimer = game.ReplicatedStorage:WaitForChild("RoundTimer")

		local function updateTime() -- line: 43
			-- upvalues: Main (copy), RoundTimer (copy), p1 (copy), t1 (copy)
			local Time = Main.Time
			local MainTitle = Main.Title
			local RoundTimerValue = RoundTimer.Value

			if RoundTimer:GetAttribute("EndlessCombat")then
                MainTitle.TextColor3=Color3.fromRGB(255,255,255)
                Time.TextColor3=Color3.fromRGB(255,255,255)
                MainTitle.Text="Battle Till' Death!"
                Time.Text="Fight"
                p1.onRoundTimerUpdated:Fire("ENDLESS_COMBAT",5999)
                return
            end
			if workspace:GetAttribute("BloodHuntActive") then
				MainTitle.TextColor3 = Color3.fromRGB(255, 0, 0)
				Time.TextColor3 = Color3.fromRGB(255, 0, 0)
				MainTitle.Text = "RUN"
				Time.Text = "HI:DE"

				return
			end

			MainTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
			Time.TextColor3 = Color3.fromRGB(255, 255, 255)

			local v22 = RoundTimer:GetAttribute("TimeLeft") or 0
			local v23 = string.format("%i:%02i", v22 / 60, v22 % 60)

			MainTitle.Text = RoundTimerValue and RoundTimerValue or ""
			Time.Text = v23
			p1.onRoundTimerUpdated:Fire(t1[RoundTimerValue] or RoundTimerValue, v22)
		end

		updateTime()
		RoundTimer:GetPropertyChangedSignal("Value"):Connect(updateTime)
		RoundTimer:GetAttributeChangedSignal("TimeLeft"):Connect(updateTime)
		RoundTimer:GetAttributeChangedSignal("EndlessCombat"):Connect(updateTime)
		workspace:GetAttributeChangedSignal("BloodHuntActive"):Connect(updateTime)

		local u16 = nil
		local u17 = nil

		Network:SetConnection("EnlargeRoundTimerAsync", "REMOTE_EVENT", function(n1: number)
            if RoundTimer:GetAttribute("EndlessCombat")then return end -- line: 77
			-- upvalues: u16 (ref), u17 (ref), TweenService (copy), Main (copy), tweenInfo (copy), color3 (copy), delay (copy), color3_2 (copy)
			if u16 then
				u16:Cancel()
				pcall(coroutine.close, u17)
				u16 = nil
			end

			u16 = TweenService:Create(Main.Time, tweenInfo, {
				TextColor3 = color3
			})
			u16:Play()
			u17 = delay(n1, function() -- line: 86
				-- upvalues: u16 (ref), TweenService (copy), Main (copy), tweenInfo (copy), color3_2 (copy)
				u16 = TweenService:Create(Main.Time, tweenInfo, {
					TextColor3 = color3_2
				})
				u16:Play()
			end)
		end)

		local MainUI = LocalPlayer.PlayerGui:WaitForChild("MainUI")

		MainUI:GetPropertyChangedSignal("Enabled"):Connect(function() -- line: 93
			-- upvalues: clone (copy), MainUI (copy)
			clone.Enabled = MainUI.Enabled
		end)
	end
}


  end)()
 end)()
 HUD:Start()
 assert(main.Title.Text=="Battle Till' Death!"and main.Time.Text=='Fight')
 workspace:SetAttribute('BloodHuntActive',true);assert(main.Time.Text=='Fight')
 rep.Modules.Network.EnlargeRoundTimerAsync(2);assert(tweenCalls==0)
 timer.Value='NEXT MAP';timer:SetAttribute('TimeLeft',1);assert(main.Time.Text=='Fight'and main.Title.Text=="Battle Till' Death!")
 policyScript:SetAttribute('Enabled',false);assert(not Endless.Step(Manager,0))
 assert(not timer:GetAttribute('EndlessCombat')and main.Title.Text=='RUN'and main.Time.Text=='HI:DE')
 workspace:SetAttribute('BloodHuntActive',false);timer:SetAttribute('TimeLeft',61)
 assert(main.Title.Text=='NEXT MAP'and main.Time.Text=='1:01','disabled policy retains ordinary HUD formatting')
 policyScript:SetAttribute('Enabled',true);Endless.Step(Manager,0)
 assert(main.Time.Text=='Fight'and main.Title.Text=="Battle Till' Death!")
 print('PASS FCT runtime: full manager/HUD, elapsed clock, frozen countdown, explicit guards, lone/empty teams, late join, independent map timer and mode fallback')
end

do

 local heartbeat=signal()
 local timer=node({Value='Waiting',attrs={}})
 local rep=node({RoundTimer=timer,ServerFPS={Value=60},Modules={},Assets={Sounds={OST={['30seconds']={IsLoaded=true,TimeLength=30}}}}})
 local workspace=node({Themes=node(),Map={Ingame=node({Map={}})}})
 local Workspace=workspace
 local sounds={PlayTheme=function()error('low-time music fired')end}
 local actors={CurrentActors={},IncrementActorStats=function()error('unexpected round payout')end}
 local actorReads=0
 local serverUtil={SafeCall=pcall,GetActorsOfType=function()actorReads+=1;return {}end}
 local mapVoting={StartVote=function()error('unexpected standard round vote')end}
 rep.Modules={Actors=actors,Sounds=sounds,Util={},Maps={},Network={},Stats={},MapVoting=mapVoting,AchievementUtil={}}
 local core=node({EventHandlerServer={}})
 local storage={GlobalConfig={},AeternusConfig={},Assets={Maps={}}}
 local playerGui=node({MainUI=node({Enabled=true})})
 local game={ReplicatedStorage=rep,ServerStorage=storage,ServerScriptService={Server={Modules={ServerUtil=serverUtil},Systems={Core=core}}},Players={LocalPlayer={PlayerGui=playerGui},PlayerRemoving=signal(),GetPlayers=function()return {}end}}
 game['Run Service']={Heartbeat=heartbeat}
 local tweenCalls=0
 local tweenService={Create=function()tweenCalls+=1;return {Play=function()end,Cancel=function()end}end}
 function game:GetService(name)if name=='ReplicatedStorage'then return rep elseif name=='TweenService'then return tweenService end end
 local policyScript=node({Parent={Parent=core}})
 local function policy()
  local script=policyScript
  return (function()
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Endless={}
function Endless.Enabled()
 return script:GetAttribute("Enabled")~=false
end
function Endless.Step(manager,delta)
 local timer=ReplicatedStorage:FindFirstChild("RoundTimer")
 if not Endless.Enabled()then
  if timer and timer:GetAttribute("EndlessCombat")then timer:SetAttribute("EndlessCombat",nil)end
  return false
 end
 manager.EndlessCombatElapsed=(manager.EndlessCombatElapsed or 0)+math.max(0,delta)
 local session=manager.CurrentSession
 if session and not manager.RoundInitiating and not manager.RoundEnding then
  session.ActualTimePast=(session.ActualTimePast or 0)+math.max(0,delta)
 end
 if timer then
  timer:SetAttribute("EndlessCombat",true)
  local mapRotation=script.Parent.Parent:FindFirstChild("MapRotation")
  if not mapRotation then
   timer.Value="Battle Till' Death!"
   timer:SetAttribute("TimeLeft",5999)
  end
 end
 return true
end
return Endless

  end)()
 end
 local Endless=policy()
 local script={EndlessCombat=Endless,Configuration={LobbyIntermissionTime=50,TimerTexts={InsufficientPlayers='Waiting'}}}
 local Manager=(function()
local EndlessCombat=require(script.EndlessCombat)
local RoundManager = {
	IntermissionTimePast = 0, -- timepast but for intermission (bcuz currentsession is nil during intermission)
	RoundTime = 0, -- subtracted from currentsession's timepast
	DoHeartbeat = true, -- used to toggle the heartbeat loop
	RoundEnding = false, -- debounce
	RoundInitiating = false, -- debounce
	-- battleground mode: no rounds at all. MapRotation owns the timer (time until the next map) and the map vote
	RoundsDisabled = true,
	GamemodeThingy = 1, -- explained later on
}

local Actors = require(game.ReplicatedStorage.Modules.Actors)
local Sounds = require(game.ReplicatedStorage.Modules.Sounds)
local Util = require(game.ReplicatedStorage.Modules.Util)
local ServerUtil = require(game.ServerScriptService.Server.Modules.ServerUtil)
local safeCall = ServerUtil.SafeCall
local Maps = require(game.ReplicatedStorage.Modules.Maps)
local Network = require(game.ReplicatedStorage.Modules.Network)
local Configuration = require(script.Configuration)
local StatsModule = require(game.ReplicatedStorage.Modules.Stats)
local MapVoting = require(game.ReplicatedStorage.Modules.MapVoting)
local AchievementUtil = require(game.ReplicatedStorage.Modules.AchievementUtil)
local Types = require(game.ReplicatedStorage.GlobalTypes)
local EventHandler = require(game.ServerScriptService.Server.Systems.Core.EventHandlerServer)

local FPSValue
local GlobalConfig = require(game.ServerStorage.AeternusConfig)
local lowTimeThreshold = 31
local lowTimeSound = game.ReplicatedStorage.Assets.Sounds.OST["30seconds"]
local Themes = Workspace:WaitForChild("Themes", 5)
local MapsFolder = game.ServerStorage.Assets.Maps

-- adjust lowTimeThreshold based on the length of the audio
task.spawn(function()
	local startingTime = os.time()
	-- wait until the sound is loaded, because otherwise timelength is 0
	repeat task.wait() until (lowTimeSound.IsLoaded and lowTimeSound.TimeLength > 0) or os.time()-startingTime > 15
	if lowTimeSound.IsLoaded and lowTimeSound.TimeLength > 0 then
		lowTimeThreshold = lowTimeSound.TimeLength
	end
end)

-- returns a random gamemode
function RoundManager:RandomGamemode()
	if workspace:GetAttribute("ForcedGamemode") then return workspace:GetAttribute("ForcedGamemode") end
	if (not GlobalConfig.GamemodeSelection) or RoundManager.GamemodeThingy < 3 then return "Standard" end

	local available = {}
	for _, gamemode in ipairs(game.ReplicatedStorage.Modules.Gamemodes:GetChildren()) do
		if gamemode.Name == "Standard" then continue end
		if gamemode:IsA("ModuleScript") then
			local success, config = safeCall(require, gamemode)
			if success and type(config) == "table" then
				if config.Enabled ~= false and config.Exclusive ~= true and #GetEligiblePlayers() >= (config.PlayerRequirement or 0) then
					table.insert(available, gamemode.Name)
				end
			end
		end
	end
	if #available == 0 then
		warn("[RoundManager] No available gamemodes found.")
		return "Standard"
	end
	return available[math.random(1, #available)]
end

-- gets all players who can be placed into a round
function GetEligiblePlayers()
	local currentPlrs = {}
	for _, plr in ipairs(game.Players:GetPlayers()) do
		local plrSettings = plr:FindFirstChild("PlayerData") and plr.PlayerData:FindFirstChild("Settings")
		if plr:GetAttribute("Loaded") and plrSettings and (not plrSettings:FindFirstChild("AFK", true) or not plrSettings:FindFirstChild("AFK", true).Value) then
			table.insert(currentPlrs, plr)
		end
	end
	return currentPlrs
end

-- plays a winner cutscene for the winner
RoundManager.WinnerCutscene = function(_, winner, winnerActors)
	return safeCall(function()
		winnerActors = winnerActors or ServerUtil:GetActorsOfType(winner)
		if winner == "Killers" then
			local wonKiller = winnerActors[1]
			if wonKiller and wonKiller.Rig and wonKiller.Rig.Parent then
				local killerBG : Model = game.ServerStorage.Assets.Instances.KillerBackgrounds.Victory:FindFirstChild(wonKiller.ActorName) and (wonKiller.SkinFolder and game.ServerStorage.Assets.Instances.KillerBackgrounds.Victory[wonKiller.ActorName]:FindFirstChild(wonKiller.SkinFolder.Name) or game.ServerStorage.Assets.Instances.KillerBackgrounds.Victory[wonKiller.ActorName]:FindFirstChild("Default"))
				if killerBG then
					killerBG = killerBG:Clone()
					killerBG.Parent = workspace.Misc
					killerBG.Name = "KillerCutsceneBackground"
					killerBG:PivotTo(CFrame.new(0, 10000, 0))
					game:GetService("Debris"):AddItem(killerBG, 25)
				end
				Network:FireAllClientConnection("PlayWinnerCutscene", "REMOTE_EVENT", winner, winnerActors)
				return true
			end
		else
			local compressedActors = {}
			for _, actor in winnerActors do
				table.insert(compressedActors, {Rig = actor.Rig, Username = actor.Username})
			end
			Network:FireAllClientConnection("PlayWinnerCutscene", "REMOTE_EVENT", winner, compressedActors)
		end
	end)
end

-- starts a round
RoundManager.InitRound = function()
	if EndlessCombat.Enabled()then return end
	if RoundManager.RoundsDisabled then
		return
	end
	-- debounce just in case
	if RoundManager.RoundInitiating then
		return
	else
		RoundManager.RoundInitiating = true
	end
	
	local votedMap = MapVoting:GetMostVotedMapName()
	votedMap = votedMap == "N/A" and "random" or votedMap
	
	local votedConfig = MapsFolder:FindFirstChild(votedMap) and MapsFolder[votedMap]:FindFirstChild("Config") and require(MapsFolder[votedMap].Config)
	if votedConfig and type(votedConfig.Variants) == "table" then
		local variants = {}
		for variant in votedConfig.Variants do
			table.insert(variants, variant)
		end
		if #variants > 0 then
			votedMap = `{votedMap}/{variants[math.random(1, #variants)]}`
		end
	end
	
	MapVoting:Destroy()
	
	local roundTimer = game.ReplicatedStorage.RoundTimer
	roundTimer.Value = Configuration.TimerTexts.Loading
	RoundManager.DoHeartbeat = false

	if (not workspace:GetAttribute("NoTimer")) and (#GetEligiblePlayers() > 1) then
		Network:FireAllClientConnection("PreHandleGamemode", "REMOTE_EVENT", "Init")
	end

	local ChosenGamemode = RoundManager:RandomGamemode()
	-- one special gamemode every 3 rounds. you can change this
	if RoundManager.GamemodeThingy >= 3 then
		RoundManager.GamemodeThingy = 1
	else
		RoundManager.GamemodeThingy += 1
	end
	workspace:SetAttribute("ForcedGamemode", nil)
	local modeModule = require(game.ReplicatedStorage.Modules.Gamemodes[ChosenGamemode])
	
	-- define new currentsession
	RoundManager.CurrentSession = {
		TimePast = 0, -- self explanatory
		ActualTimePast = 0, -- goes up alongside timepast, except it doesnt ever get subtracted. used for 60 second rewards
		Gamemode = nil, -- for the autocomplete
		Players = {},
		WinningDisabled = false -- i honestly dont like this, but the real forsaken does it so
	}
	
	-- set up playerinfo for all eligible players
	for _, plr in pairs(GetEligiblePlayers()) do
		local plrStats = plr:FindFirstChild("PlayerData") and plr.PlayerData:FindFirstChild("Stats")
		table.insert(RoundManager.CurrentSession.Players, {
			Instance = plr,
			KillerChance = plrStats and plrStats:FindFirstChild("KillerChance", true),
			Character = plr.Character,
			isPlayerKillable = false, -- i could not tell you what on earth this does, but the real forsaken has it
			State = "Alive",
			Connections = {},
		})
	end
	
	-- additional values for currentsession
	RoundManager.CurrentSession.WinningDisabled = #RoundManager.CurrentSession.Players < 2 and not workspace:GetAttribute("Testing")
	RoundManager.CurrentSession.Gamemode = modeModule.Init(RoundManager.CurrentSession)
	RoundManager.RoundTime = (RoundManager.CurrentSession.Gamemode and RoundManager.CurrentSession.Gamemode.RoundTime) or 240 -- subtracted from timepast to calculate time displayed on the timer
	
	-- allows for easier customization through gamemodes
	for i, v in pairs(RoundManager.CurrentSession) do
		RoundManager.CurrentSession[i] = modeModule[i] or RoundManager.CurrentSession[i]
	end
	Network:FireAllClientConnection("HandleGamemode", "REMOTE_EVENT", "Init", ChosenGamemode, RoundManager.CurrentSession)
	
	-- gamemode notification thingy, you can remove this if you want. done on the server because i refrain from modifying client side code
	if GlobalConfig.GamemodeSelection then
		task.spawn(function()
			for _, plr in pairs(game.Players:GetPlayers()) do
				local newNotif = game.ServerStorage.Assets.UI.GamemodeNotif:Clone()
				local newGui = Instance.new("ScreenGui")
				newGui.Name = "GamemodeNotifGui"
				newGui.DisplayOrder = 10
				newGui.ResetOnSpawn = false
				newGui.IgnoreGuiInset = true
				local ogSize = newNotif.Size
				local ogThickness = newNotif.UIStroke.Thickness
				pcall(function()
					newNotif.Title.Text = RoundManager.CurrentSession.Gamemode.Name
					newNotif.Description.Text = (plr.Character and plr.Character.Parent and RoundManager.CurrentSession.Gamemode.Descriptions[plr.Character.Parent.Name]) or RoundManager.CurrentSession.Gamemode.Descriptions["Survivors"]
				end)
				newNotif.Parent = newGui
				newGui.Parent = plr.PlayerGui
			end
		end)
	end

	for _, plrInfo in pairs(RoundManager.CurrentSession.Players) do
		task.spawn(function()
			local rig : Model = plrInfo.Character
			local plr : Player = plrInfo.Instance
			local actor = Actors.CurrentActors[plr]
			if not (rig and plr and actor) then return end
			local actorType = actor.ActorType
			--if actorType == "Killer" and workspace:GetAttribute("ServerType") ~= "VIP" and ((not RoundManager.CurrentSession.Gamemode) or RoundManager.CurrentSession.Gamemode.AddMalice ~= false) then
			--	local killerChance = plrInfo.KillerChance
			--	if killerChance and killerChance:IsA("NumberValue") then
			--		killerChance.Value = 1
			--	end
			--end
			
			plrInfo.Team = actorType.."s"
			
			if rig and rig:FindFirstChildOfClass("Humanoid") then
				local deathConnection = rig:FindFirstChildOfClass("Humanoid").Died:Connect(function()
					plrInfo.State = "Dead"
					
					if plr and actorType == "Survivor" then
						plrInfo.DeathTime = RoundManager.CurrentSession.ActualTimePast
					end
					
					local losses : NumberValue = plr and plr:FindFirstChild("PlayerData") and plr.PlayerData:FindFirstChild(actorType.."Losses", true)
					if losses then
						losses.Value+=1
					end
					
					if plrInfo.DeathTime and plrInfo.DeathTime <= 20 then
						AchievementUtil:IncrementAchievementProgress(plrInfo.Instance, "BadAtTheGame", 1)	
					end
					
					if RoundManager.CurrentSession and RoundManager.CurrentMap then
						AchievementUtil:IncrementAchievementProgress(plrInfo.Instance, "RespawningElsewhere", RoundManager.CurrentMap.MapFolder.Name)
					end
				end)
				table.insert(plrInfo.Connections, deathConnection)
			else
				return
			end
		end)
	end
	
	-- no twotime respawn for onebounce
	if RoundManager.CurrentSession.Gamemode and RoundManager.CurrentSession.Gamemode.DisableOnLMS then
		Instance.new("Model", workspace.Players.Survivors).Name = "ImASurvivorTrust"
	end
	
	-- just incase
	task.wait(0.25)

	if RoundManager.CurrentSession and not RoundManager.CurrentMap then
		RoundManager.CurrentMap = Maps:CreateMap(votedMap or "Random")
	end

	RoundManager.DoHeartbeat = true
	RoundManager.RoundInitiating = false
end

-- ends a round
RoundManager.EndRound = function()
	if EndlessCombat.Enabled()then return end
	-- debounce just in case
	if RoundManager.RoundEnding then
		return
	else
		RoundManager.RoundEnding = true
	end
	RoundManager.DoHeartbeat = false
	
	-- determines winner based on amount of actors
	local survivorActors = ServerUtil:GetActorsOfType("Survivors", true)
	local killerActors = ServerUtil:GetActorsOfType("Killers", true)
	local winner = (#survivorActors > 0 or #killerActors < 1) and "Survivors" or "Killers"
	local winnerActors = winner == "Survivors" and survivorActors or killerActors
	
	EventHandler:CallMethod("RoundEnded", winner, survivorActors, killerActors)
	
	local totalSurvivorCount = 0
	local lastSurvivor
	for _, plrInfo in RoundManager.CurrentSession.Players do
		if plrInfo.Team == "Survivors" then
			totalSurvivorCount += 1
			lastSurvivor = plrInfo.Instance
		end
	end
	
	-- sets every actor's username because roundnetwork uses it
	for _, actor in pairs(winnerActors) do
		if actor.Player then
			actor.Username = actor.Player.Name
		end
	end

	-- cleanup
	for _, theme in pairs(Themes:GetChildren()) do
		if theme:IsA("Sound") and (theme.Name == "LastSurvivor" or theme.Name == "30seconds") then
			theme:Destroy()
		end
	end
	workspace.Misc:ClearAllChildren()
	if RoundManager.CurrentMap and RoundManager.CurrentMap.Map then
		RoundManager.CurrentMap.Map:Destroy()
	end
	
	StatsModule:CreateStatsFolder()
	
	workspace.Map.Ingame:ClearAllChildren()
	Network:FireConnection("RoundEnded", "BINDABLE_EVENT")
	Network:FireAllClientConnection("RoundEnded", "REMOTE_EVENT")
	if RoundManager.CurrentSession.Gamemode then
		safeCall(RoundManager.CurrentSession.Gamemode.Destroy, RoundManager.CurrentSession.Gamemode)
	end
	Network:FireAllClientConnection("HandleGamemode", "REMOTE_EVENT", "Destroy")

	-- winner cutscene
	if not RoundManager.CurrentSession.WinningDisabled then
		task.spawn(function()
			RoundManager:WinnerCutscene(winner, winnerActors)
		end)
	end

	safeCall(function()
		game.AnalyticsService:LogCustomEvent(winnerActors[1].Player, winner.."Wins", 1)
	end)


	for _, actor in pairs(Actors.CurrentActors) do
		task.spawn(function()
			if not actor.Player then return end
			if not actor.Player:FindFirstChild("PlayerData") then return end
			
			if (not actor.Rig) or (not actor.Rig:FindFirstChildOfClass("Humanoid")) or actor.Rig:FindFirstChildOfClass("Humanoid").Health <= 0 then
				return
			end
			
			-- adds a win or loss value to the player's playerdata
			local value : NumberValue = actor.Player:FindFirstChild("PlayerData") and actor.Player.PlayerData:FindFirstChild(actor.ActorType.."s"==winner and string.sub(winner, 1, string.len(winner)-1).."Wins" or actor.ActorType.."Losses", true)
			if value then
				value.Value += 1
			end
			
			if winner == actor.ActorType.."s" and actor.Rig:FindFirstChildOfClass("Humanoid").Health < actor.Rig:FindFirstChildOfClass("Humanoid").MaxHealth/10 then
				AchievementUtil:IncrementAchievementProgress(actor.Player, "BarelyAlive", 1)
			end
			
			if winner == "Killers" and actor.ActorType == "Killer" and #RoundManager.CurrentSession.Players == game.Players.MaxPlayers then
				AchievementUtil:IncrementAchievementProgress(actor.Player, "ServerWiped", 1)
			end
			
			if winner == "Survivors" and actor.ActorType == "Survivor" and #RoundManager.CurrentSession.Players == game.Players.MaxPlayers and #survivorActors == totalSurvivorCount then
				AchievementUtil:IncrementAchievementProgress(actor.Player, "TeamEffort", 1)
			end
			
			if winner == "Survivors" and actor.ActorType == "Survivor" and not actor.Rig:GetAttribute("RecentAttacker") then
				AchievementUtil:IncrementAchievementProgress(actor.Player, "NoHit", 1)
			end
			
			if winner == actor.ActorType.."s" and not actor.Rig:GetAttribute("AbilitiesUsed") then
				if actor.ActorType == "Survivor" then
					AchievementUtil:IncrementAchievementProgress(actor.Player, "NoAbilities", 1)
				elseif actor.ActorType == "Killer" then
					AchievementUtil:IncrementAchievementProgress(actor.Player, "NoAbilitiesHardMode", 1)
				end
			end
			
			if actor.ActorType == "Survivor" and winner == "Survivors" then
				AchievementUtil:IncrementAchievementProgress(actor.Player, "TrueSurvivalist", RoundManager.CurrentMap.MapFolder.Name)
			end
			
			-- rewards players
			local reward
			if actor.ActorType == "Survivor" and winner == "Survivors" then
				reward = table.clone(Configuration.SurvivorWinReward)
			elseif actor.ActorType == "Killer" then
				reward = winner == "Killers" and table.clone(Configuration.KillerWinReward) or table.clone(Configuration.KillerLostReward)
			end
			if not reward then return end
			Actors:IncrementActorStats(actor.Player, reward)
		end)
		
		-- player cleanup
		local player = actor.Player
		safeCall(function() Actors:CleanupActorFromPlayer(actor.Player) end)
		task.delay(1.5, function()
			player:LoadCharacter()
		end)
	end
	
	if #winnerActors == 1 and winner == "Survivors" then
		AchievementUtil:IncrementAchievementProgress(winnerActors[1].Player, "LastSurvivorWin", 1)			
	end

	if RoundManager.CurrentSession.LastSurvivorAlive and winner == "Killers" then
		AchievementUtil:IncrementAchievementProgress(RoundManager.CurrentSession.LastSurvivorAlive, "LastSurvivorDied", 1)
	end
	
	-- cleanup NPCs
	task.delay(1, function()
		for _, survivor in pairs(workspace.Players.Survivors:GetChildren()) do
			if not game.Players:GetPlayerFromCharacter(survivor) then
				survivor:Destroy()
			end
		end
	end)
	
	-- rewards survived for 60 seconds
	for _, player in pairs(RoundManager.CurrentSession.Players) do
		if player.Instance and player.Instance.Parent and player.DeathTime and player.DeathTime >= 60 then
			Actors:IncrementActorStats(player.Instance, table.clone(Configuration.SixtySecondReward))
		end
	end

	-- cleanup connections
	for _, plrInfo in pairs(RoundManager.CurrentSession.Players) do
		for _, conn in pairs(plrInfo.Connections) do
			conn:Disconnect()
		end
	end
	
	RoundManager.CurrentSession = nil
	RoundManager.CurrentMap = nil
	RoundManager.RoundTime = 0
	RoundManager.IntermissionTimePast = 0
	ServerUtil:LoadPosters()
	
	task.wait(1.5)
	RoundManager.DoHeartbeat = true
	RoundManager.RoundEnding = false

end

-- activates last man standing
RoundManager.LMS = function()
	if EndlessCombat.Enabled()then return end
	RoundManager.CurrentSession.LastSurvivorAlive = true
	RoundManager.DoHeartbeat = false
	local Killers : {Types.Actor} = ServerUtil:GetActorsOfType("Killers", true)
	local LastKiller = Killers[1]
	local LastSurvivor = ServerUtil:GetActorsOfType("Survivors", true)[1]
	RoundManager.CurrentSession.LastSurvivorAlive = LastSurvivor.Player
	local LMS = {
		ThemeID = game.ReplicatedStorage.Assets.Sounds.OST.eternalFight.SoundId,
		ThemeProperties = {
			Volume = 1,
		},
		RoundTime = 72,
	}

	local emotional = false
	
	local specialTheme = (RoundManager.CurrentSession.Gamemode and RoundManager.CurrentSession.Gamemode.LMSTheme) or (RoundManager.CurrentMap and RoundManager.CurrentMap.Config and RoundManager.CurrentMap.Config.LastManStandingData)
	if LastKiller and LastSurvivor and LastKiller.Config and LastKiller.Config.LastManStandingEmotionalData and LastKiller.Config.Relations and not (RoundManager.CurrentSession.Gamemode and RoundManager.CurrentSession.Gamemode.DisableEmotionalThemes) then
		
		local Relations = table.clone(LastKiller.Config.Relations)
		local DefaultFolder = LastKiller.Folder
		if typeof(DefaultFolder) == "Instance" and DefaultFolder:IsA("Folder") then
			local defaultConfig = DefaultFolder:FindFirstChild("Config")
			if defaultConfig then
				defaultConfig = require(defaultConfig)
				if defaultConfig.Relations then
					for _, relation in pairs(defaultConfig.Relations) do
						if not table.find(Relations, relation) then
							table.insert(Relations, relation)
						end
					end
				end
			end
		end
		
		for _, Name in ipairs(Relations) do
			if (LastSurvivor.SkinFolder and LastSurvivor.SkinFolder.Name == Name) or LastSurvivor.ActorName == Name then
				specialTheme = LastKiller.Config.LastManStandingEmotionalData[Name]
				emotional = true
				break
			end
		end
		
		if (not specialTheme) and emotional then
			specialTheme = LastKiller.Config.LastManStandingEmotionalData
		end
	end

	if (not specialTheme) and (not (RoundManager.CurrentSession.Gamemode and RoundManager.CurrentSession.Gamemode.DisableEmotionalThemes)) then
		specialTheme = (LastKiller.Config and LastKiller.Config.LastManStandingData) or (LastSurvivor.Config and LastSurvivor.Config.LastManStandingData) or nil
	end
	
	LMS = specialTheme or LMS
	LMS.ThemeProperties = LMS.ThemeProperties or {}
	LMS.ThemeProperties.Priority = 10

	RoundManager.CurrentSession.TimePast = 0
	RoundManager.RoundTime = LMS.RoundTime
	local theme = Sounds:PlayTheme(LMS.ThemeID, LMS.ThemeProperties)
	theme.Name = "LastSurvivor"
	
	safeCall(function()
		for _, killer in pairs(Killers) do
			Util:RevealPlayerAuraTo(killer.Rig, LastSurvivor.Rig, RoundManager.CurrentSession.Gamemode and RoundManager.CurrentSession.Gamemode.LMSRevealTime or 8)
			Util:RevealPlayerAuraTo(LastSurvivor.Rig, killer.Rig, RoundManager.CurrentSession.Gamemode and RoundManager.CurrentSession.Gamemode.LMSRevealTime or 8)
			
			killer:PlayVoiceline((emotional and "LastSurvivorEmotional") or "LastSurvivor")
			
			if killer.Behavior and killer.Behavior.LastManStanding then
				killer.Behavior:LastManStanding(killer, LastSurvivor)
			end
			if LastSurvivor.Behavior and LastSurvivor.Behavior.LastManStanding then
				LastSurvivor.Behavior:LastManStanding(LastSurvivor, killer)
			end
		end
	end)
	
	Network:FireAllClientConnection("LastSurvivor", "REMOTE_EVENT")
	
	if specialTheme then
		if LastKiller.Config and LastKiller.Config.ELMSLighting then
			require(game.ReplicatedStorage.Modules.Schematics.Lighting):SetCustomLighting(LastKiller.Config.ELMSLighting)
		end
	else
		if LastKiller.Config and LastKiller.Config.LMSLighting then
			require(game.ReplicatedStorage.Modules.Schematics.Lighting):SetCustomLighting(LastKiller.Config.LMSLighting)
		end
	end
	
	RoundManager.DoHeartbeat = true
end

RoundManager.Start = function()
	EndlessCombat.Step(RoundManager,0)
	FPSValue = --[[workspace:GetAttribute("Testing") and]] game.ReplicatedStorage:WaitForChild("ServerFPS")
	game["Run Service"].Heartbeat:Connect(function(delta)
		--if workspace:GetAttribute("Testing") then
			FPSValue.Value = math.floor(1 / delta)
		--end

		if EndlessCombat.Step(RoundManager,delta)then return end
		if not RoundManager.DoHeartbeat then return end
		if RoundManager.RoundsDisabled then return end

		local RoundTimer = game.ReplicatedStorage.RoundTimer

		if RoundManager.CurrentSession and (not RoundManager.RoundInitiating) and RoundManager.CurrentMap and workspace.Map.Ingame:FindFirstChild("Map") then
			-- DURING ROUND
			if true then
				RoundTimer:SetAttribute("TimeLeft", 5999)
				RoundTimer.Value = Configuration.TimerTexts.TimerDisabled
				return
			end
			
			local Survivors = ServerUtil:GetActorsOfType("Survivors", true)
			local Killers = ServerUtil:GetActorsOfType("Killers", true)

			if RoundManager.CurrentSession.TimePast >= RoundManager.RoundTime or #Survivors <= 0 or #Killers <= 0 then
				task.delay(0.25, RoundManager.EndRound, #Survivors, #Killers)
			elseif (not RoundManager.CurrentSession.LastSurvivorAlive) and #Survivors == 1 and #Killers > 0 then
				RoundManager:LMS()
			end

			if not RoundManager.CurrentSession then return end

			RoundTimer.Value = Configuration.TimerTexts.DuringRound
			
			local TimerSpeed = 1
			if workspace:GetAttribute("BloodHuntActive") and not RoundManager.CurrentSession.LastSurvivorAlive then
				TimerSpeed /= 2
			end
			
			RoundManager.CurrentSession.TimePast += delta*TimerSpeed
			RoundManager.CurrentSession.ActualTimePast += delta
			RoundTimer:SetAttribute("TimeLeft", RoundManager.RoundTime - RoundManager.CurrentSession.TimePast)
			
			if RoundManager.RoundTime - RoundManager.CurrentSession.TimePast < lowTimeThreshold then
				if not Themes:FindFirstChild("30seconds") then
					Sounds:PlayTheme("30seconds"):SetAttribute("DeloadOnDeath", true)
				end
			elseif Themes:FindFirstChild("30seconds") then
				Sounds:StopTheme("30seconds")
			end
		else
			-- DURING INTERMISSION
			if RoundManager.IntermissionTimePast >= Configuration.LobbyIntermissionTime then
				RoundManager.IntermissionTimePast = 0
				RoundManager.InitRound()
				return
			end

			if workspace:GetAttribute("NoTimer") then return end

			if #GetEligiblePlayers() <= 1 then
				RoundManager.IntermissionTimePast = 0
				RoundTimer.Value = Configuration.TimerTexts.InsufficientPlayers
				RoundTimer:SetAttribute("TimeLeft", 0)
				return
			end
			
			if (RoundManager.IntermissionTimePast >= Configuration.LobbyIntermissionTime - MapVoting.VoteDuration) and (not MapVoting.CurrentVote) then
				MapVoting:StartVote()
			end

			RoundTimer.Value = Configuration.TimerTexts.Lobby
			RoundManager.IntermissionTimePast += delta
			RoundTimer:SetAttribute("TimeLeft", Configuration.LobbyIntermissionTime - RoundManager.IntermissionTimePast)
		end
	end)
	
	game.Players.PlayerRemoving:Connect(function(leavingPlr)
		if RoundManager.CurrentSession and RoundManager.CurrentSession.Players then
			for i, plrInfo in pairs(RoundManager.CurrentSession.Players) do
				if plrInfo.Instance == leavingPlr then
					for _, conn in pairs(plrInfo.Connections) do
						conn:Disconnect()
					end
					table.remove(RoundManager.CurrentSession.Players, i)
				end
			end
		end
	end)
	
end

-- adds timeAmount to the round timer
function RoundManager:AddTime(timeAmount : number, timeMultiplier : number)
	if EndlessCombat.Enabled()then return end
	if not RoundManager.CurrentSession then
		return
	end
	if not RoundManager.CurrentSession.TimePast then
		return
	end
	local timeAdded = timeAmount or (RoundManager.CurrentSession.Gamemode and RoundManager.CurrentSession.Gamemode.TimeAddedOnKill) or 35
	timeAdded *= timeMultiplier or 1
	RoundManager.CurrentSession.TimePast -= timeAdded
end

task.delay(5, function()
	ServerUtil:LoadPosters()
end)

return RoundManager
 end)()
 Manager.Start()
 assert(timer:GetAttribute('EndlessCombat')and timer.Value=="Battle Till' Death!"and timer:GetAttribute('TimeLeft')==5999)
 local session={ActualTimePast=8,TimePast=100000,Players={}}
 Manager.CurrentSession=session;Manager.RoundTime=10;Manager.CurrentMap={};Manager.DoHeartbeat=false
 heartbeat:Fire(5)
 assert(Manager.EndlessCombatElapsed==5 and session.ActualTimePast==13 and session.TimePast==100000)
 assert(actorReads==0,'empty roles must not trigger a round ending or LMS')
 Manager.DoHeartbeat=true;Manager.RoundsDisabled=false
 heartbeat:Fire(100000)
 assert(session.ActualTimePast==100013 and session.TimePast==100000 and not Manager.RoundEnding)
 Manager.InitRound();Manager.EndRound();Manager.LMS();Manager:AddTime(35)
 assert(not Manager.RoundInitiating and not Manager.RoundEnding and not session.LastSurvivorAlive and session.TimePast==100000)
 Manager.RoundInitiating=true;heartbeat:Fire(1);assert(session.ActualTimePast==100013);Manager.RoundInitiating=false
 local elapsed=Manager.EndlessCombatElapsed;Endless.Step(Manager,-4);assert(Manager.EndlessCombatElapsed==elapsed)
 -- An independent FCF map clock owns its own values and keeps them.
 core.MapRotation={};timer.Value='NEXT MAP';timer:SetAttribute('TimeLeft',20)
 heartbeat:Fire(1);assert(timer.Value=='NEXT MAP'and timer:GetAttribute('TimeLeft')==20 and timer:GetAttribute('EndlessCombat'))
 -- Real HUD module, including late-join initialization and replicated-attribute updates.
 local main={Title={Text=''},Time={Text=''}}
 local clone={Main=main,Enabled=true};local hudScript={RoundTimer={Clone=function()return clone end}}
 rep.Modules.Network={SetConnection=function(self,key,kind,callback)self[key]=callback end}
 rep.Modules.Misc={Signal={new=signal}}
 local HUD=(function()
  local script=hudScript
  return (function()
-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local l_ReplicatedStorage_0 = game:GetService("ReplicatedStorage");
local l_TweenService_0 = game:GetService("TweenService");
local v2 = require(l_ReplicatedStorage_0.Modules.Network);
local l_delay_0 = task.delay;
local v4 = TweenInfo.new(0.5);
local v5 = Color3.fromRGB(141, 0, 0);
local v6 = Color3.fromRGB(255, 255, 255);
return {
    Start = function(_) --[[ Line: 17 ]] --[[ Name: Start ]]
        -- upvalues: v2 (copy), l_TweenService_0 (copy), v4 (copy), v5 (copy), l_delay_0 (copy), v6 (copy)
        local l_LocalPlayer_0 = game.Players.LocalPlayer;
        local v9 = script.RoundTimer:Clone();
        local l_Main_0 = v9.Main;
        v9.Parent = l_LocalPlayer_0.PlayerGui;
        local l_RoundTimer_0 = game.ReplicatedStorage:WaitForChild("RoundTimer");
        local function v17() --[[ Line: 29 ]] --[[ Name: updateTime ]]
            -- upvalues: l_Main_0 (copy), l_RoundTimer_0 (copy)
            local l_Time_0 = l_Main_0.Time;
            local l_Title_0 = l_Main_0.Title;
            local l_Value_0 = l_RoundTimer_0.Value;
            if l_RoundTimer_0:GetAttribute("EndlessCombat")then
                l_Title_0.TextColor3=Color3.fromRGB(255,255,255)
                l_Time_0.TextColor3=Color3.fromRGB(255,255,255)
                l_Title_0.Text="Battle Till' Death!"
                l_Time_0.Text="Fight"
                return
            end
            if workspace:GetAttribute("BloodHuntActive") then
                l_Title_0.TextColor3 = Color3.fromRGB(255, 0, 0);
                l_Time_0.TextColor3 = Color3.fromRGB(255, 0, 0);
                l_Title_0.Text = "RUN";
                l_Time_0.Text = "HI:DE";
                return;
            else
                l_Title_0.TextColor3 = Color3.fromRGB(255, 255, 255);
                l_Time_0.TextColor3 = Color3.fromRGB(255, 255, 255);
                local v15 = l_RoundTimer_0:GetAttribute("TimeLeft") or 0;
                local v16 = string.format("%i:%02i", v15 / 60, v15 % 60);
                l_Title_0.Text = l_Value_0 and l_Value_0 or "";
                l_Time_0.Text = v16;
                return;
            end;
        end;
        v17();
        l_RoundTimer_0:GetPropertyChangedSignal("Value"):Connect(v17);
        l_RoundTimer_0:GetAttributeChangedSignal("TimeLeft"):Connect(v17);
        l_RoundTimer_0:GetAttributeChangedSignal("EndlessCombat"):Connect(v17);
        workspace:GetAttributeChangedSignal("BloodHuntActive"):Connect(v17);
        local v18 = nil;
		local v19 = nil;
		v2:SetConnection("EnlargeRoundTimerAsync", "REMOTE_EVENT", function(v20)
            if l_RoundTimer_0:GetAttribute("EndlessCombat")then return end --[[ Line: 61 ]]
            -- upvalues: v18 (ref), v19 (ref), l_TweenService_0 (ref), l_Main_0 (copy), v4 (ref), v5 (ref), l_delay_0 (ref), v6 (ref)
            if v18 then
                v18:Cancel();
                pcall(coroutine.close, v19);
                v18 = nil;
            end;
            v18 = l_TweenService_0:Create(l_Main_0.Time, v4, {
                TextColor3 = v5
            });
            v18:Play();
            v19 = l_delay_0(v20, function() --[[ Line: 70 ]]
                -- upvalues: v18 (ref), l_TweenService_0 (ref), l_Main_0 (ref), v4 (ref), v6 (ref)
                v18 = l_TweenService_0:Create(l_Main_0.Time, v4, {
                    TextColor3 = v6
                });
                v18:Play();
            end);
        end);
        local l_MainUI_0 = l_LocalPlayer_0.PlayerGui:WaitForChild("MainUI");
        l_MainUI_0:GetPropertyChangedSignal("Enabled"):Connect(function() --[[ Line: 77 ]]
            -- upvalues: v9 (copy), l_MainUI_0 (copy)
            v9.Enabled = l_MainUI_0.Enabled;
        end);
    end
};
  end)()
 end)()
 HUD:Start()
 assert(main.Title.Text=="Battle Till' Death!"and main.Time.Text=='Fight')
 workspace:SetAttribute('BloodHuntActive',true);assert(main.Time.Text=='Fight')
 rep.Modules.Network.EnlargeRoundTimerAsync(2);assert(tweenCalls==0)
 timer.Value='NEXT MAP';timer:SetAttribute('TimeLeft',1);assert(main.Time.Text=='Fight'and main.Title.Text=="Battle Till' Death!")
 policyScript:SetAttribute('Enabled',false);assert(not Endless.Step(Manager,0))
 assert(not timer:GetAttribute('EndlessCombat')and main.Title.Text=='RUN'and main.Time.Text=='HI:DE')
 workspace:SetAttribute('BloodHuntActive',false);timer:SetAttribute('TimeLeft',61)
 assert(main.Title.Text=='NEXT MAP'and main.Time.Text=='1:01','disabled policy retains ordinary HUD formatting')
 policyScript:SetAttribute('Enabled',true);Endless.Step(Manager,0)
 assert(main.Time.Text=='Fight'and main.Title.Text=="Battle Till' Death!")
 print('PASS FCF runtime: full manager/HUD, elapsed clock, frozen countdown, explicit guards, lone/empty teams, late join, independent map timer and mode fallback')
end
