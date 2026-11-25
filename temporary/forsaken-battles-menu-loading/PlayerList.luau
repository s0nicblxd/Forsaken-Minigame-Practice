local t1 = {
	_players = {},
	DisplayedStats = {
		"Money",
		"Kills"
	},
	ListEnabled = true
}
local SocialService = game:GetService("SocialService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

game:GetService("TextChatService")

local v6 = RunService:IsStudio()
local clamp = math.clamp
local LocalPlayer = Players.LocalPlayer

require(game.ReplicatedStorage.Modules.Actors)

local DataHandler = require(game.ReplicatedStorage.Modules.DataHandler)
local Util = require(game.ReplicatedStorage.Modules.Util)
local Sounds = require(game.ReplicatedStorage.Modules.Sounds)
local Network = require(game.ReplicatedStorage.Modules.Network)
local t2 = {
	Kills = "Kills",
	RbxSpent = "R$ Spent"
}
local t3 = {
	PC = "rbxassetid://135066638879377",
	Mobile = "rbxassetid://89227325753198",
	Console = "rbxassetid://118447973769044",
	Unknown = "rbxassetid://94182197303121",
	NoChat = "rbxassetid://8509669675"
}

local function getPath(p1, s1: string, n1: number?) -- line: 51
	assert(typeof(p1) == "Instance")
	assert(typeof(s1) == "string")

	if s1 == "" then
		return p1
	end

	for _, v23 in (string.split(s1, "/")) do
		if typeof(n1) ~= "number" then
			p1 = p1:FindFirstChild(v23)

			if p1 ~= nil then
				continue
			end

			return
		end

		p1 = p1:WaitForChild(v23, n1)

		if p1 == nil then
			return
		end
	end

	return p1
end

function t1.GetPlayerListUI(p2) -- line: 76
	if not p2.PlayerList then
		repeat
			task.wait()
		until p2.PlayerList
	end

	return p2.PlayerList
end

local thread = nil
local u17 = true

function t1.TogglePlayerList(_, p4, p5) -- line: 85
	-- upvalues: t1 (copy), Sounds (copy), thread (ref), u17 (ref)
	if p5 then
		t1.ListEnabled = p4
	elseif not t1.ListEnabled then
		return
	end

	if not p5 then
		Sounds:Play("switch")
	end

	local PlayerListUI = t1:GetPlayerListUI()

	if thread then
		task.cancel(thread)
	end

	if p4 then
		u17 = true
		PlayerListUI.Close.Text = ">"
		PlayerListUI.Close.Visible = true
		PlayerListUI.Contents.Visible = true
		PlayerListUI.Background.Visible = true
		PlayerListUI.FriendBoost.Visible = true
		game.TweenService:Create(PlayerListUI, TweenInfo.new(0.15), {
			AnchorPoint = script.PlayerListHolder.AnchorPoint,
			Position = script.PlayerListHolder.Position
		}):Play()

		return
	end

	u17 = false
	PlayerListUI.Close.Text = "<"
	game.TweenService:Create(PlayerListUI, TweenInfo.new(0.15), {
		AnchorPoint = Vector2.new(),
		Position = UDim2.new(1, 0, 0, script.PlayerListHolder.Position.Y.Offset)
	}):Play()
	thread = task.delay(0.15, function() -- line: 116
		-- upvalues: p5 (copy), PlayerListUI (copy)
		if p5 then
			PlayerListUI.Close.Visible = false
		end

		PlayerListUI.Contents.Visible = false
		PlayerListUI.Background.Visible = false
		PlayerListUI.FriendBoost.Visible = false
	end)
end

local t4 = {}

function t1.ShowPlayerStats(t5: {[any]: any}, p6) -- line: 127
	-- upvalues: t4 (copy), Sounds (copy), t1 (copy), t3 (copy), DataHandler (copy), Util (copy), LocalPlayer (copy)
	for _, v in pairs(t4) do
		v:Disconnect()
	end

	table.clear(t4)

	if t5.__currentlyDisplayedStats and t5.__currentlyDisplayedStats.Parent then
		if tostring(t5.__currentlyDisplayedStats) == tostring(p6) then
			game.TweenService:Create(t5.__currentlyDisplayedStats, TweenInfo.new(0.15), {
				Size = UDim2.fromScale()
			}):Play()
			game.Debris:AddItem(t5.__currentlyDisplayedStats, 0.15)
			t5.__currentlyDisplayedStats = nil

			return
		end

		t5.__currentlyDisplayedStats:Destroy()
	end

	local clone = script.PlayerStats:Clone()

	clone.Name = tostring(p6)
	clone.Close.MouseEnter:Connect(function() -- line: 150
		-- upvalues: Sounds (copy)
		Sounds:Play("hover")
	end)
	clone.Close.MouseLeave:Connect(function() -- line: 151
		-- upvalues: Sounds (copy)
		Sounds:Play("hoverEnd")
	end)
	clone.Close.MouseButton1Click:Connect(function() -- line: 152
		-- upvalues: Sounds (copy), t1 (copy), p6 (copy)
		Sounds:Play("select")
		t1:ShowPlayerStats(p6)
	end)

	local v34 = `@{ p6.Name }`
	local v35 = p6.DisplayName ~= p6.Name and (p6.DisplayName ~= "" and p6.DisplayName)

	clone.BasicInfo.PlayerName.Text = v35 or v34
	clone.BasicInfo.PlayerUsername.Text = v34
	clone.BasicInfo.PlayerUsername.Visible = v35
	task.spawn(function() -- line: 164
		-- upvalues: p6 (copy), clone (copy)
		local UserId = p6.UserId
		local UserThumbnailAsync = game.Players:GetUserThumbnailAsync(UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)

		clone.PlayerIconHolder.Player.Image = UserThumbnailAsync
	end)

	local function updatePlayerDevice() -- line: 171
		-- upvalues: t3 (copy), p6 (copy), clone (copy)
		local v93 = t3[p6:GetAttribute("Device")] or t3.Unknown

		clone.PlayerIconHolder.Device.Image = v93
	end

	local v37 = t3[p6:GetAttribute("Device")] or t3.Unknown

	clone.PlayerIconHolder.Device.Image = v37
	table.insert(t4, p6:GetAttributeChangedSignal("Device"):Connect(updatePlayerDevice))

	local v38 = DataHandler:Get(p6)
	local v39 = v38 and v38:FindFirstChild("Stats")
	local v40 = v38 and v38:FindFirstChild("Equipped")

	if v39 and v40 then
		local General = v39:FindFirstChild("General")
		local v42 = General and General:FindFirstChild("TimePlayed")

		if v42 then
			local function updateTimePlayed() -- line: 256
				-- upvalues: Util (copy), p6 (copy), clone (copy), v42 (copy)
				local SettingValue = Util:GetSettingValue("HidePlaytime", p6)

				clone.TimePlayed.Text = `Time Played: { (if not SettingValue then Util:FormatTime(v42.Value, "Clock") else "<font color=\"rgb(125,125,125)\"><i>(Hidden)</i></font>") }`
			end

			local SettingValue = Util:GetSettingValue("HidePlaytime", p6)

			clone.TimePlayed.Text = `Time Played: { (if not SettingValue then Util:FormatTime(v42.Value, "Clock") else "<font color=\"rgb(125,125,125)\"><i>(Hidden)</i></font>") }`
			table.insert(t4, v42:GetPropertyChangedSignal("Value"):Connect(updateTimePlayed))
		end

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

			if v40 then
				local t6 = {}

				local function setEquippedIcon() -- line: 292
					-- upvalues: p6 (copy), v (copy), t6 (ref), clone (copy), Util (copy)
					local v95, v96 = require(game.ReplicatedStorage.Modules.Actors):GetEquippedActorInfo(p6, v)
					local v97 = game.ReplicatedStorage.Assets:FindFirstChild(`{ v }s`):FindFirstChild(v95)
					local v98 = v97 and (v97:FindFirstChild("Config") and require(v97.Config))
					local v99 = game.ReplicatedStorage.Assets.Skins:FindFirstChild(`{ v }s`):FindFirstChild(v95)
					local v100 = v99 and v99:FindFirstChild(v96)
					local v101 = v100 and (v100:FindFirstChild("Config") and require(v100.Config))

					if v98 then
						for _, v2 in pairs(t6) do
							v2:Disconnect()
						end

						table.clear(t6)

						local v3 = clone.BasicInfo.EquippedCharacters:FindFirstChild(v)
						local u105 = `Equipped { v }: <i>{ v98.DisplayName or tostring(v97) }</i>`

						if v101 then
							u105 = `{ u105 }\nEquipped Skin: <i>{ v101.DisplayName or tostring(v100) }</i>`
						end

						v3.Image = v101 and v101.RenderImage or (v98.RenderImage or "rbxassetid://13373279056")
						t6 = {
							v3.MouseEnter:Connect(function() -- line: 316
								-- upvalues: Util (copy), u105 (ref)
								Util:CreateTooltip(u105)
							end),
							v3.MouseLeave:Connect(function() -- line: 317
								-- upvalues: Util (copy)
								Util:CreateTooltip()
							end)
						}
					end
				end

				local v4 = v40:FindFirstChild(v)
				local v5 = v40.Skins:FindFirstChild(v)

				setEquippedIcon()

				if v4 then
					table.insert(t4, v4:GetPropertyChangedSignal("Value"):Connect(setEquippedIcon))
				end

				if v5 then
					table.insert(t4, v5:GetPropertyChangedSignal("Value"):Connect(setEquippedIcon))
				end
			end
		end
	end

	if not t5.__currentlyDisplayedStats then
		clone.Size = UDim2.new()
		game.TweenService:Create(clone, TweenInfo.new(0.15), {
			Size = script.PlayerStats.Size
		}):Play()
	end

	clone.Parent = LocalPlayer.PlayerGui.TemporaryUI
	t5.__currentlyDisplayedStats = clone
	clone.AncestryChanged:Connect(function(_, parent) -- line: 345
		-- upvalues: Util (copy), t4 (copy)
		if not parent then
			Util:CreateTooltip()

			for _, v in pairs(t4) do
				v:Disconnect()
			end

			table.clear(t4)
		end
	end)
end
function t1.CreatePlayerInList(_: {[any]: any}, p8) -- line: 356
	-- upvalues: t1 (copy), Util (copy), Network (copy), v6 (copy)
	if not p8 then
		return
	end

	local PlayerListUI = t1:GetPlayerListUI()
	local v59 = PlayerListUI.Contents.Players:FindFirstChild((tostring(p8)))

	if v59 then
		v59:Destroy()
	end

	local clone = script.PlayerInfoContainer:Clone()

	clone.Name = tostring(p8)

	local p8Name = p8.Name
	local v62 = p8.DisplayName ~= p8.Name and (p8.DisplayName ~= "" and p8.DisplayName)

	local baseName = v62 or p8Name
	clone.PlayerInfo.Username.Text = baseName
	clone.PlayerInfo.Username.RichText = true

	local function updateAFKStatus()
		local afkValue = Util:GetSettingValue("AFK", p8)
		local isAFK = afkValue == true or (typeof(afkValue) == "number" and afkValue > 0)
		clone.PlayerInfo.Username.Text = isAFK and `{baseName} <font color="#B82500">[AFK]</font>` or baseName
	end

	task.spawn(function()
		local playerData = DataHandler:Get(p8)
		if not playerData then return end
		local settings = playerData:FindFirstChild("Settings")
		if not settings then return end
		local afkSetting = settings:FindFirstChild("AFK", true)
		if afkSetting then
			afkSetting:GetPropertyChangedSignal("Value"):Connect(updateAFKStatus)
		end
		updateAFKStatus()
	end)

	clone.ShowStats.MouseButton1Click:Connect(function() -- line: 375
		-- upvalues: t1 (copy), p8 (copy)
		t1:ShowPlayerStats(p8)
	end)

	if t1.DisplayedStats and t1.DisplayedStats[1] then
		local leaderstats = p8:WaitForChild("leaderstats", 30)

		if not leaderstats or not p8.Parent then
			return
		end

		for _, child in pairs(leaderstats:GetChildren()) do
			local clone2 = clone.PlayerInfo.Username:Clone()

			clone2.Name = child and child.Name
			clone2.Size = UDim2.fromScale(0.3, 1)
			clone2.LayoutOrder = table.find(t1.DisplayedStats, child.Name)
			clone2.TextXAlignment = Enum.TextXAlignment.Center
			clone2.Parent = clone.PlayerInfo

			local function updateStat() -- line: 396
				-- upvalues: child (copy), clone2 (copy), Util (copy)
				local v110 = child and child.Value or "?"

				if tonumber(v110) then
					clone2.TextColor3 = v110 > 0 and Color3.new(1, 1, 1) or Color3.new(1, 0, 0)
					v110 = Util:ConvertToAbbreviation(v110)
				end

				if child.Name == "Money" then
					v110 = `${ v110 }`
				end

				clone2.Text = tostring(v110)
			end

			updateStat()

			if child then
				child:GetPropertyChangedSignal("Value"):Connect(updateStat)
			end
		end
	end

	local v68 = Network:FireServerConnection("ReturnCanChat", "REMOTE_FUNCTION", p8)

	if v6 or not v68 then
		clone.NoChat.Visible = true
		clone.NoChat.MouseEnter:Connect(function() -- line: 422
			-- upvalues: Util (copy)
			Util:CreateTooltip("You cannot communicate with this player.")
		end)
		clone.NoChat.MouseLeave:Connect(function() -- line: 425
			-- upvalues: Util (copy)
			Util:CreateTooltip()
		end)
	end

	clone.Parent = PlayerListUI.Contents.Players
	t1:__UpdateListSize()
end
function t1.RemovePlayerFromList(_: {[any]: any}, p9) -- line: 437
	-- upvalues: t1 (copy)
	local v71 = t1:GetPlayerListUI().Contents.Players:FindFirstChild((tostring(p9)))

	if v71 then
		v71:Destroy()
	end

	t1:__UpdateListSize()
end
function t1.__UpdateListSize(_) -- line: 450
	-- upvalues: t1 (copy)
	local PlayerListUI = t1:GetPlayerListUI()
	local UIListLayout = PlayerListUI.Contents.Players.UIListLayout
	local v75 = UIListLayout.AbsoluteContentSize.Y + UIListLayout.Padding.Offset

	PlayerListUI.Background.Size = UDim2.fromScale(1, (math.clamp(0.05 + 30 / PlayerListUI.AbsoluteSize.Y + v75 / PlayerListUI.AbsoluteSize.Y, 0, 1)))
	PlayerListUI.FriendBoost.Position = UDim2.fromScale(0, (math.clamp(0.05 + 30 / PlayerListUI.AbsoluteSize.Y + v75 / PlayerListUI.AbsoluteSize.Y, 0, 1)))
end
function t1.Start(p11) -- line: 460
	-- upvalues: LocalPlayer (copy), t1 (copy), t2 (copy), SocialService (copy), clamp (copy), Util (copy), u17 (ref), Sounds (copy)
	if game["Run Service"]:IsServer() then
		return
	end

	local clone = script.PlayerListHolder:Clone()
	local Contents = clone.Contents

	clone.Parent = LocalPlayer.PlayerGui:WaitForChild("MainUI")
	Contents:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 521
		-- upvalues: t1 (copy)
		t1:__UpdateListSize()
	end)

	for k, v in pairs(t1.DisplayedStats) do
		local clone3 = Contents.InfoTypes.Players:Clone()

		clone3.Name = v
		clone3.Text = t2[v] or v:gsub("(%l)(%u)", "%1 %2")
		clone3.Size = UDim2.fromScale(0.3, 1)
		clone3.LayoutOrder = k + 1
		clone3.TextXAlignment = Enum.TextXAlignment.Center
		clone3.Parent = Contents.InfoTypes
	end

	local _ = {
		JOINING = true,
		LEAVING = false
	}
	local ExperienceInviteOptions = Instance.new("ExperienceInviteOptions")

	ExperienceInviteOptions.PromptMessage = `Invite Friends, get { 10 }% more EXP per friend! (caps at { 20 }%).`

	local function __canSendInvite(p12) -- line: 547
		-- upvalues: SocialService (copy)
		local ok, result = pcall(function() -- line: 548
			-- upvalues: SocialService (copy), p12 (copy)
			return SocialService:CanSendGameInviteAsync(p12)
		end)

		return ok and result
	end

	local Button = clone.FriendBoost.Button

	Button.MouseButton1Down:Connect(function() -- line: 556
		-- upvalues: LocalPlayer (copy), SocialService (copy), ExperienceInviteOptions (copy)
		local v114 = LocalPlayer
		local ok, result = pcall(function() -- line: 548
			-- upvalues: SocialService (copy), v114 (copy)
			return SocialService:CanSendGameInviteAsync(v114)
		end)

		if ok and result then
			SocialService:PromptGameInvite(LocalPlayer, ExperienceInviteOptions)
		end
	end)

	local n2 = 0

	local function __setBoostDisplay(p13, b1: boolean) -- line: 564
		-- upvalues: LocalPlayer (copy), n2 (ref), clamp (copy), Button (copy)
		local ok, result = pcall(function() -- line: 566
			-- upvalues: LocalPlayer (copy), p13 (copy)
			return LocalPlayer:IsFriendsWith(p13.UserId)
		end)

		if ok and result then
			n2 = clamp(n2 + 10 * (not b1 and -1 or 1), 0, 20)
		end

		local v121 = `Invite Friends (+{ n2 }% EXP)`

		if v121 ~= Button.Text then
			Button.Text = v121
		end
	end

	Util.OnPlayerAdded(function(p14) -- line: 587
		-- upvalues: LocalPlayer (copy), n2 (ref), clamp (copy), Button (copy), t1 (copy)
		if p14 ~= LocalPlayer then
			local ok, result = pcall(function() -- line: 566
				-- upvalues: LocalPlayer (copy), p14 (copy)
				return LocalPlayer:IsFriendsWith(p14.UserId)
			end)

			if ok and result then
				n2 = clamp(n2 + 10, 0, 20)
			end

			local v125 = `Invite Friends (+{ n2 }% EXP)`

			if v125 ~= Button.Text then
				Button.Text = v125
			end
		end

		t1:CreatePlayerInList(p14)
	end)
	game.Players.PlayerRemoving:Connect(function(player) -- line: 596
		-- upvalues: LocalPlayer (copy), n2 (ref), clamp (copy), Button (copy), t1 (copy)
		if player ~= LocalPlayer then
			local ok, result = pcall(function() -- line: 566
				-- upvalues: LocalPlayer (copy), player (copy)
				return LocalPlayer:IsFriendsWith(player.UserId)
			end)

			if ok and result then
				n2 = clamp(n2 + -10, 0, 20)
			end

			local v129 = `Invite Friends (+{ n2 }% EXP)`

			if v129 ~= Button.Text then
				Button.Text = v129
			end
		end

		t1:RemovePlayerFromList(player)
	end)
	clone.Close.MouseButton1Click:Connect(function() -- line: 604
		-- upvalues: t1 (copy), u17 (ref)
		t1:TogglePlayerList(not u17)
	end)
	game.UserInputService.InputBegan:Connect(function(input, gameProcessed) -- line: 608
		-- upvalues: t1 (copy), u17 (ref)
		if gameProcessed then
			return
		end

		if input.KeyCode == Enum.KeyCode.Tab then
			t1:TogglePlayerList(not u17)
		end
	end)

	local function addSFX(p15) -- line: 616
		-- upvalues: Sounds (copy)
		if p15:IsA("ImageButton") or p15:IsA("TextButton") then
			p15.MouseEnter:Connect(function() -- line: 618
				-- upvalues: Sounds (copy)
				Sounds:Play("hover")
			end)
			p15.MouseLeave:Connect(function() -- line: 619
				-- upvalues: Sounds (copy)
				Sounds:Play("hoverEnd")
			end)
			p15.MouseButton1Click:Connect(function() -- line: 620
				-- upvalues: Sounds (copy)
				Sounds:Play("select")
			end)
		end
	end

	for _, descendant in pairs(clone:GetDescendants()) do
		addSFX(descendant)
	end

	clone.DescendantAdded:Connect(addSFX)
	p11.PlayerList = clone
	game.StarterGui:SetCoreGuiEnabled("PlayerList", false)
end

return t1

