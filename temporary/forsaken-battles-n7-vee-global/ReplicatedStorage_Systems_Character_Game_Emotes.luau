local GroupRankTranslations = require(game.ReplicatedStorage.Modules.Schematics.GroupRankTranslations)

game:GetService("MarketplaceService")

local t1 = {}
local DataHandler = require(game.ReplicatedStorage.Modules.DataHandler)
local Sounds = require(game.ReplicatedStorage.Modules.Sounds)
local Network = require(game.ReplicatedStorage.Modules.Network)
local ControlModule = require(game.Players.LocalPlayer:WaitForChild("PlayerScripts").PlayerModule:WaitForChild("ControlModule"))

function t1.__createDeferedEmoteLoadTask(t2: {[any]: any}, s1: string, s2: string) -- line: 20
	-- upvalues: t1 (copy)
	t2:__stopDeferedEmoteLoadTasks()
	t1.__emoteDeferedTask = task.delay(0.175, function() -- line: 22
		-- upvalues: t1 (copy), s1 (copy), s2 (copy)
		t1:ToggleEmoteMenu()
		t1.CurrentEmoteIndex = {
			s1,
			s2
		}

		if s1 and s2 then
			if t1.EmoteIcon then
				t1.EmoteIcon:setLabel("Stop Emote")
			end

			require(game.ReplicatedStorage.Modules.Network):FireServerConnection("PlayEmote", "REMOTE_EVENT", s1, s2)
			t1.__emoteDeferedTask = nil
		end
	end)
end
function t1.__stopDeferedEmoteLoadTasks(_) -- line: 38
	-- upvalues: t1 (copy)
	if t1.__emoteDeferedTask ~= nil then
		task.cancel(t1.__emoteDeferedTask)
		t1.__emoteDeferedTask = nil
		t1.CurrentEmoteIndex = nil
	end
end
function t1.ToggleEmoteMenu(_) -- line: 47
	-- upvalues: t1 (copy)
	if t1.EmoteMenu and t1.EmoteMenu.FrameHolder:FindFirstChild("RadialMenu") then
		t1.EmoteMenu.CurrentlyVisible = not t1.EmoteMenu.CurrentlyVisible

		if t1.EmoteMenu.TogglingThread then
			task.cancel(t1.EmoteMenu.TogglingThread)
		end

		if t1.EmoteMenu.CurrentlyVisible then
			game.TweenService:Create(t1.EmoteMenu.FrameHolder, TweenInfo.new(0.15), {
				Size = UDim2.fromScale(0.5, 0.5)
			}):Play()
			game.TweenService:Create(t1.Blur, TweenInfo.new(0.15), {
				Size = 12
			}):Play()
			t1.EmoteMenu.FrameHolder.Visible = true

			return
		end

		game.TweenService:Create(t1.EmoteMenu.FrameHolder, TweenInfo.new(0.15), {
			Size = UDim2.fromScale()
		}):Play()
		game.TweenService:Create(t1.Blur, TweenInfo.new(0.15), {
			Size = 0
		}):Play()
		t1.EmoteMenu.TogglingThread = task.delay(0.15, function() -- line: 61
			-- upvalues: t1 (copy)
			t1.EmoteMenu.FrameHolder.Visible = false
		end)
	end
end
function t1.GetPlayerEmotes(_) -- line: 68
	-- upvalues: DataHandler (copy), GroupRankTranslations (copy)
	local Util = require(game.ReplicatedStorage.Modules.Util)
	local LocalPlayer = game.Players.LocalPlayer
	local v15 = DataHandler:Get()
	local parts = string.split(v15.Equipped.Emotes.Value, "|")
	local parts2 = string.split(v15.Equipped.ExtraEmotes.Value, "|")

	local function getLengthOfDict(p4) -- line: 76
		local n1 = 0

		for _, _ in pairs(p4) do
			n1 += 1
		end

		return n1
	end

	local t3 = {
		Animations = {},
		AnimationsExtra = {},
		Voicelines = {}
	}
	local ok, result = pcall(function() -- line: 91
		-- upvalues: LocalPlayer (copy)
		return LocalPlayer:GetRankInGroup(33548380)
	end)
	local v22 = ok and result or 0

	if not LocalPlayer.Character:GetAttribute("CustomRig") and (LocalPlayer.Character.Parent ~= workspace.Players.Killers or workspace:GetAttribute("ServerType") == "VIP" or v22 >= GroupRankTranslations.Tester) then
		local Emotes = game.ReplicatedStorage.Assets.Emotes

		for _, v in pairs(parts) do
			local v2 = Emotes:FindFirstChild(v)
			local v27 = v2 and Util:CopyTable(require(v2))

			if v27 and (v27.AssetID or v27.AssetIDs) then
				v27.RealAssetName = v2.Name
				table.insert(t3.Animations, v27)
			else
				table.insert(t3.Animations, "nil")
			end
		end

		if LocalPlayer:GetAttribute("ExtraEmotes") then
			for _, v in pairs(parts2) do
				local v3 = Emotes:FindFirstChild(v)
				local v31 = v3 and Util:CopyTable(require(v3))

				if v31 and (v31.AssetID or v31.AssetIDs) then
					v31.RealAssetName = v3.Name
					table.insert(t3.AnimationsExtra, v31)
				else
					table.insert(t3.AnimationsExtra, "nil")
				end
			end
		end
	end

	if LocalPlayer.Character.Parent ~= workspace.Players.Spectating then
		local timestamp = os.clock()
		local Actors = require(game.ReplicatedStorage.Modules.Actors)

		if not Actors.CurrentActors[LocalPlayer] then
			repeat
				task.wait()
			until Actors.CurrentActors[LocalPlayer] or os.clock() >= timestamp + 5
		end

		if Actors.CurrentActors[LocalPlayer] then
			local Emotes = Actors.CurrentActors[LocalPlayer].Config.Emotes

			if Emotes then
				for k, v in pairs(Emotes) do
					for k2, v4 in pairs(v) do
						if t3[k] then
							v4.RealAssetName = k2
							table.insert(t3[k], v4)
						else
							warn(debug.traceback(`emote type of { k } doesn't exist`))
						end
					end
				end
			end
		end
	end

	local Animations = t3.Animations
	local n2 = 0

	for _, _ in pairs(Animations) do
		n2 += 1
	end

	local v47

	if not (n2 > 0) then
		local AnimationsExtra = t3.AnimationsExtra
		local n3 = 0

		for _, _ in pairs(AnimationsExtra) do
			n3 += 1
		end

		if not (n3 > 0) then
			v47 = false

			local Voicelines = t3.Voicelines
			local n4 = 0

			for _, _ in pairs(Voicelines) do
				n4 += 1
			end

			if not (n4 > 0) then
				return v47
			end
		end
	end

	v47 = t3

	return v47
end
function t1.BuildMenu(p5) -- line: 150
	-- upvalues: t1 (copy), Sounds (copy)
	local RadialMenu = require(script.RadialMenu)
	local LocalPlayer = game.Players.LocalPlayer
	local v55 = LocalPlayer:GetAttribute("ExtraEmotes") == true
	local TemporaryUI = LocalPlayer.PlayerGui:WaitForChild("TemporaryUI", 15)

	if not TemporaryUI then
		return
	end

	local PlayerEmotes = t1:GetPlayerEmotes()

	if not PlayerEmotes then
		return
	end

	local EmoteMenuHolder = TemporaryUI:FindFirstChild("EmoteMenuHolder")

	while EmoteMenuHolder do
		EmoteMenuHolder.Name = "byebye"
		EmoteMenuHolder:Destroy()
		EmoteMenuHolder = TemporaryUI:FindFirstChild("EmoteMenuHolder")
	end

	local clone = script.EmoteMenuHolder:Clone()

	clone.Visible = false
	clone.Size = UDim2.fromScale(0, 0)
	clone.Parent = TemporaryUI

	local t4 = {}

	for _, v in pairs({
		clone.Last,
		clone.Next
	}) do
		v.MouseEnter:Connect(function() -- line: 179
			-- upvalues: Sounds (copy), t4 (copy), v (copy)
			Sounds:Play("hover")
			t4[v.Name] = true
		end)
		v.MouseLeave:Connect(function() -- line: 183
			-- upvalues: Sounds (copy), t4 (copy), v (copy)
			Sounds:Play("hoverEnd")
			t4[v.Name] = nil
		end)
	end

	local function isOnButton() -- line: 190
		-- upvalues: clone (copy), t4 (copy)
		for _, v in pairs({
			clone.Last,
			clone.Next
		}) do
			if v == game.GuiService.SelectedObject then
				return true
			end
		end

		return t4.Last or t4.Next
	end

	local n5 = 0
	local t5 = {}
	local t6 = {
		Animations = 1,
		AnimationsExtra = 2,
		Voicelines = 3
	}
	local t7 = {
		AnimationsExtra = "Emotes 2",
		Animations = not v55 and "Emotes" or "Emotes 1"
	}
	local n6 = 1

	for k, v in pairs({
		clone.Last,
		clone.Next
	}) do
		v.MouseButton1Click:Connect(function() -- line: 217
			-- upvalues: Sounds (copy), n6 (ref), k (copy), n5 (ref), t6 (copy), t5 (copy), clone (copy), t7 (copy)
			Sounds:Play("switch")
			n6 += k ~= 1 and 1 or -1

			local v92 = n6 % n5 + 1

			for k3, v5 in pairs(t6) do
				if t5[k3] then
					if v92 == v5 then
						clone.EmoteType.Text = t7[k3] or k3
						t5[k3].Frame.Visible = true
					else
						t5[k3].Frame.Visible = false
					end
				end
			end
		end)
	end

	for k, v in pairs(PlayerEmotes) do
		if not (#v <= 0) then
			local v73 = RadialMenu.new(#v, 0.5, 0)

			v73.Frame.Name = "RadialMenu"
			v73.Frame.Visible = false
			v73.Frame.Parent = clone
			v73.FrameHolder = clone
			t5[k] = v73
			v73:SetDialProps({
				ImageTransparency = 0,
				ImageColor3 = Color3.new(1, 1, 1)
			})

			for k4, v6 in pairs(v) do
				if v6.RenderImage then
					local clone2 = script.Templates.RenderHolder:Clone()

					clone2.Asset.Image = v6.RenderImage
					clone2.Parent = v73:GetAttachment(k4)
				elseif v6.DisplayName then
					local clone3 = script.Templates.TitleHolder:Clone()

					clone3.Text = v6.DisplayName
					clone3.Parent = v73:GetAttachment(k4)
				end
			end

			v73.Clicked:Connect(function(p6) -- line: 268
				-- upvalues: v73 (copy), clone (copy), t1 (copy), isOnButton (copy), Sounds (copy), v (copy), p5 (copy), k (copy)
				if v73.Frame.Visible and (clone.Size.X.Scale >= 0.4 and t1.EmoteMenu.CurrentlyVisible and not isOnButton()) then
					Sounds:Play("select")

					local v96 = v[p6].RealAssetName or v[p6].DisplayName

					p5:__createDeferedEmoteLoadTask(k, v96)
				end
			end)
			v73.Hover:Connect(function(p7, p8) -- line: 277
				-- upvalues: v (copy), v73 (copy), clone (copy), Sounds (copy)
				local _ = v[p7]
				local v100 = v[p8]

				if v73.Frame.Visible and (clone.Size.X.Scale >= 0.4 and v100) then
					Sounds:Play("hover")

					local v101 = not v100.RenderImage and (not not v100.DisplayName and v100.Description) or (v100.DisplayName or "")

					if v101 ~= "" then
						clone.EmoteDescription.Title.Text = v101

						if clone.EmoteDescription.ImageTransparency >= 0.5 then
							game.TweenService:Create(clone.EmoteDescription, TweenInfo.new(0.1), {
								ImageTransparency = 0
							}):Play()
							game.TweenService:Create(clone.EmoteDescription.Title, TweenInfo.new(0.1), {
								TextTransparency = 0
							}):Play()

							return
						end
					elseif clone.EmoteDescription.ImageTransparency <= 0.5 then
						game.TweenService:Create(clone.EmoteDescription, TweenInfo.new(0.1), {
							ImageTransparency = 1
						}):Play()
						game.TweenService:Create(clone.EmoteDescription.Title, TweenInfo.new(0.1), {
							TextTransparency = 1
						}):Play()

						return
					end
				else
					local v102 = if not v100 or v100.RenderImage then nil else v100.Description or v100.DisplayName

					clone.EmoteDescription.Title.Text = tostring(v102)
					clone.EmoteDescription.ImageTransparency = not v102 and 1 or 0
					clone.EmoteDescription.Title.TextTransparency = not v102 and 1 or 0
				end
			end)
			clone.AncestryChanged:Connect(function(_, parent) -- line: 304
				-- upvalues: v73 (copy)
				if not parent then
					v73:Destroy()
				end
			end)
		end
	end

	for i, v in ipairs({
		"Animations",
		"AnimationsExtra",
		"Voicelines"
	}) do
		if t5[v] then
			clone.EmoteType.Text = t7[v] or v
			t5[v].Frame.Visible = true
			n6 = i - 1

			break
		end
	end

	for _, _ in pairs(t5) do
		n5 += 1
	end

	if n5 <= 1 then
		clone.Last.Visible = false
		clone.Next.Visible = false
	end

	t1.EmoteMenu = {
		FrameHolder = clone,
		RadialDials = t5
	}
end
function t1.Start(p10) -- line: 340
	-- upvalues: t1 (copy), Network (copy), DataHandler (copy), ControlModule (copy)
	t1.__emoteDeferedTask = nil
	Network:SetConnection("SetEmoteProximityStateAsync", "UREMOTE_EVENT", function(p11, b1: boolean) -- line: 343
		if p11 and typeof(p11) == "Instance" then
			p11.Enabled = b1
		end
	end)
	Network:SetConnection("ReplicateEmoteData", "REMOTE_EVENT", function(b2: boolean, s3: string, t8: {[any]: any}) -- line: 349
		local s3_2 = game.ReplicatedStorage.Assets.Emotes:FindFirstChild(s3)
		local ok, result = pcall(function() -- line: 351
			-- upvalues: s3_2 (copy)
			return s3_2 and require(s3_2)
		end)

		if not ok or not result then
			warn(`[{ script } :: Network :: ReplicateEmoteData]: Failed to get emote module: { s3 }`)

			return
		end

		if t8 then
			local Humanoid = t8.Character:FindFirstChildOfClass("Humanoid")
			local v114 = Humanoid and Humanoid:FindFirstChild("Animator")

			if v114 then
				for _, v116 in (v114:GetPlayingAnimationTracks()) do
					if v116.Animation.AnimationId == result.AssetID then
						t8.Emote = v116

						break
					end
				end
			end
		end

		local ok2, result2 = pcall(function() -- line: 373
			-- upvalues: result (copy), b2 (copy), t8 (copy)
			local v129 = result[not b2 and "Destroyed" or "Created"]

			if v129 then
				return v129(t8)
			end
		end)

		if not ok2 then
			warn(`[{ script } :: Network :: ReplicateEmoteData]: Failed to call .{ not b2 and "Destroyed" or "Created" }() on emote module: { s3 } due to: { result2 }`)
		end
	end)

	if not t1.Blur then
		t1.Blur = Instance.new("BlurEffect")
		t1.Blur.Name = "EmoteBlur"
		t1.Blur.Size = 0
		t1.Blur.Parent = game.Lighting
	end

	game.TweenService:Create(t1.Blur, TweenInfo.new(0.3), {
		Size = 0
	}):Play()

	if t1.KeybindConnection then
		t1.KeybindConnection:Disconnect()
		t1.KeybindConnection = nil
	end

	local Device = require(game.ReplicatedStorage.Modules.Device)

	local function setupEmoteButton() -- line: 403
		-- upvalues: t1 (copy), Device (copy), p10 (copy)
		if t1.EmoteIcon then
			t1.EmoteIcon:Destroy()
		end

		if Device:GetPlayerDevice() == "Mobile" then
			t1.EmoteIcon = require(game.ReplicatedStorage.Modules.Icon).new()
			t1.EmoteIcon:setOrder(10)
			t1.EmoteIcon:oneClick(true)
			t1.EmoteIcon:setLabel("Emote")
			t1.EmoteIcon:bindEvent("deselected", function() -- line: 414
				-- upvalues: t1 (copy), p10 (copy)
				local Character = t1.Character
				local Humanoid = Character:FindFirstChild("Humanoid")

				p10:__stopDeferedEmoteLoadTasks()

				if Character:GetAttribute("UsingAnimations") and Humanoid then
					if t1.CurrentEmoteIndex then
						require(game.ReplicatedStorage.Modules.Network):FireServerConnection("StopEmote", "REMOTE_EVENT", t1.CurrentEmoteIndex[1], t1.CurrentEmoteIndex[2])
						t1.EmoteIcon:setLabel("Emote")
						t1.CurrentEmoteIndex = nil

						return
					end
				else
					t1:ToggleEmoteMenu()
				end
			end)
		end
	end

	t1.DeviceConnection = Device.Changed:Connect(setupEmoteButton)
	setupEmoteButton()
	t1:BuildMenu()

	if not t1.EmoteMenu then
		return
	end

	t1.KeybindConnection = game.UserInputService.InputBegan:Connect(function(input, gameProcessed) -- line: 440
		-- upvalues: DataHandler (copy), t1 (copy)
		if workspace:GetAttribute("GamepadDisabled") then
			return
		end

		if gameProcessed then
			return
		end

		local _ = game.Players.LocalPlayer
		local Keybinds = DataHandler:Get().Settings.Keybinds
		local t9 = {
			Keybinds.Emote.Value,
			Keybinds["Emote~Console"].Value
		}

		if table.find(t9, input.KeyCode.Name) or table.find(t9, input.UserInputType.Name) then
            if t1.CurrentEmoteIndex and t1.CurrentEmoteIndex[1]then
                Network:FireServerConnection("StopEmote","REMOTE_EVENT",t1.CurrentEmoteIndex[1],t1.CurrentEmoteIndex[2])
            else t1:ToggleEmoteMenu()end
		end
	end)
	Network:SetConnection("EmoteAutoWalk", "REMOTE_EVENT", function(p12) -- line: 457
		-- upvalues: ControlModule (copy)
		if p12 then
			local Character = game.Players.LocalPlayer.Character
			local v126 = Character and Character:WaitForChild("Humanoid", 1)
			local v127 = Character and Character:FindFirstChild("HumanoidRootPart")
			local u128 = v127 and (v127.CFrame.LookVector * Vector3.new(1, 0, 1)).Unit

			if v126 then
				game["Run Service"]:BindToRenderStep("EmoteAutoWalk", Enum.RenderPriority.Character.Value + 1, function(_) -- line: 469
					-- upvalues: v127 (copy), v126 (copy), ControlModule (copy), u128 (ref)
					if not v127 or (not v126 or v126:GetState() == Enum.HumanoidStateType.Dead) then
						game["Run Service"]:UnbindFromRenderStep("EmoteAutoWalk")
					end

					local v133 = workspace.CurrentCamera.CFrame:VectorToWorldSpace(ControlModule:GetMoveVector())

					if (v133 - u128).Magnitude > 0 and v133 ~= Vector3.new(0, 0, 0) then
						u128 = Vector3.new(v133.X, 0, v133.Z).Unit
					end

					v126:Move(u128)
				end)
			end

			return
		end

		game["Run Service"]:UnbindFromRenderStep("EmoteAutoWalk")
	end)
	t1.Character = game.Players.LocalPlayer.Character
	t1.EmoteMenu.CurrentlyVisible = false
end
function t1.Destroy(_) -- line: 497
	-- upvalues: t1 (copy)
	if t1.DeviceConnection then
		t1.DeviceConnection:Disconnect()
	end
end

return t1

