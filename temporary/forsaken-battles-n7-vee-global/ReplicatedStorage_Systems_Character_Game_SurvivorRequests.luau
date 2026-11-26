local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local DataHandler = require(game.ReplicatedStorage.Modules.DataHandler)

require(ReplicatedStorage.GlobalTypes)

local Util = require(ReplicatedStorage.Modules.Util)
local Actors = require(ReplicatedStorage.Modules.Actors)
local Network = require(ReplicatedStorage.Modules.Network)
local CharacterHovering = require(ReplicatedStorage.Modules.Misc.CharacterHovering)
local LocalPlayer = Players.LocalPlayer
local t1 = {
	Connections = {}
}

local function hasTruthy(t2: {[any]: any}) -- line: 25
	if not t2 then
		return false
	end

	for _, v in pairs(t2) do
		if v then
			return true
		end
	end

	return false
end
local function getActorInfo(p1) -- line: 38
	-- upvalues: Players (copy), Actors (copy)
	local player = Players:GetPlayerFromCharacter(p1)
	local v17 = Actors.CurrentActors[player]

	if v17 then
		return v17
	end
end

function t1.Start(_) -- line: 48
	-- upvalues: LocalPlayer (copy), t1 (copy), Network (copy), Actors (copy), Players (copy), ReplicatedStorage (copy), Util (copy), CharacterHovering (copy)
	local Character = LocalPlayer.Character

	if not t1.Initialized then
		t1.Initialized = true
		Network:SetConnection("SurvivorRequested", "REMOTE_EVENT", function(p3, s1: string) -- line: 54
			-- upvalues: Actors (copy), LocalPlayer (copy)
			local v47 = Actors.CurrentActors[LocalPlayer]
			local v48 = Actors.CurrentActors[p3]
			local v49 = nil

			if v48 and (v48.Config.Requesting and v48.Config.Requesting[s1]) then
				v49 = v48.Config.Requesting[s1]
			elseif v47 and v47.Config.Requests and v47.Config.Requests[s1] then
				v49 = v47.Config.Requests[s1]
			end

			local Character2 = p3.Character
			local v51 = Character2 and Character2.PrimaryPart

			if v49 and v51 then
				local clone = script.RequestUI:Clone()

				clone.Title.Text = v49.NotificationTitle:gsub("PLAYERNAME", Character2.Name)
				clone.Adornee = v51
				clone.Parent = LocalPlayer.PlayerGui:FindFirstChild("TemporaryUI")

				local Highlight = Instance.new("Highlight")

				Highlight.Parent = LocalPlayer.PlayerGui:FindFirstChild("TemporaryUI")
				Highlight.Adornee = Character2
				Highlight.FillColor = Color3.new(0.5, 1, 0.5)
				Highlight.OutlineColor = Color3.new(0.5, 1, 0.5)

				local t3 = {
					[clone.Title] = {
						TextTransparency = 0,
						TextStrokeTransparency = 0.5
					},
					[Highlight] = {
						FillTransparency = 0.9,
						OutlineTransparency = 0.5
					}
				}

				for k, v in pairs(t3) do
					for k2, v2 in pairs(v) do
						k[k2] = 1
						game.TweenService:Create(k, TweenInfo.new(0.2), {
							[k2] = v2
						}):Play()
					end
				end

				task.delay(6, function() -- line: 94
					-- upvalues: t3 (copy)
					for k, v in pairs(t3) do
						game.Debris:AddItem(k, 0.2)

						for k3, _ in pairs(v) do
							game.TweenService:Create(k, TweenInfo.new(0.2), {
								[k3] = 1
							}):Play()
						end
					end
				end)
			end
		end)
	end

	local function toggleRequestFunctionality() -- line: 108
		-- upvalues: t1 (copy), Character (copy), Players (copy), Actors (copy), Network (copy), ReplicatedStorage (copy), LocalPlayer (copy), Util (copy), CharacterHovering (copy)
		if t1.Connections then
			for _, v in pairs(t1.Connections) do
				v:Disconnect()
			end

			table.clear(t1.Connections)
		end

		local CharacterParent = Character.Parent

		if Character and CharacterParent and CharacterParent ~= workspace.Players.Spectating then
			local clone = nil

			local function survivorClicked(p4) -- line: 122
				-- upvalues: Players (copy), Actors (copy), clone (ref), Character (copy), Network (copy), ReplicatedStorage (copy), LocalPlayer (copy), Util (copy)
				local player = Players:GetPlayerFromCharacter(p4)
				local v72 = Actors.CurrentActors[player] or nil

				if v72 and not clone then
					local v73 = Character
					local player2 = Players:GetPlayerFromCharacter(v73)
					local v75 = Actors.CurrentActors[player2] or nil
					local v76 = v72.Config.Requests or {}
					local v77 = v75 and v75.Config.Requesting or {}
					local n1 = 0
					local v79 = nil

					for k, _ in pairs(v76) do
						n1 += 1
						v79 = k
					end

					for k, _ in pairs(v77) do
						n1 += 1
						v79 = k
					end

					if n1 == 0 then
						return
					end

					if n1 <= 1 and v79 then
						local v84 = Network:FireServerConnection("SurvivorRequest", "REMOTE_FUNCTION", p4, v79)

						if typeof(v84) == "string" then
							require(ReplicatedStorage.Modules.Util):CreateWarning("SurvivorRequestWarning", v84)
						end

						return
					end

					clone = script.RequestPrompt:Clone()
					clone.Parent = LocalPlayer.PlayerGui:FindFirstChild("TemporaryUI")
					clone.Background.ImageTransparency = 1
					game.TweenService:Create(clone.Background, TweenInfo.new(0.3), {
						ImageTransparency = 0
					}):Play()

					local v85 = Util:MergeTables(v77, v76)

					v85.Cancel = {
						AbilityName = "N/A",
						NotificationTitle = "...",
						Order = 999
					}

					local u86 = false

					for k, v in pairs(v85) do
						local clone2 = script.Choice:Clone()

						clone2.Name = k
						clone2.Text = v.RequestTitle or k:gsub("(%l)(%u)", "%1 %2")
						clone2.LayoutOrder = tonumber(v.Order) or 1
						clone2.Parent = clone.Choices
						clone2.TextTransparency = 1
						game.TweenService:Create(clone2, TweenInfo.new(0.15), {
							TextTransparency = 0
						}):Play()
						clone2.Activated:Connect(function() -- line: 178
							-- upvalues: u86 (ref), clone (ref), clone2 (copy), k (copy), Network (copy), p4 (copy), Util (copy)
							if not u86 then
								u86 = true

								for _, child in pairs(clone.Choices:GetChildren()) do
									if child:IsA("TextButton") then
										game.TweenService:Create(child, TweenInfo.new(0.15), {
											TextTransparency = 1,
											Size = UDim2.new(clone2.Size.X.Scale, clone2.Size.X.Offset, 0, 0)
										}):Play()
									end
								end

								game.TweenService:Create(clone.Background, TweenInfo.new(0.15), {
									ImageTransparency = 1
								}):Play()
								game.Debris:AddItem(clone, 0.15)
								clone = nil

								if k ~= "Cancel" then
									local v97 = Network:FireServerConnection("SurvivorRequest", "REMOTE_FUNCTION", p4, k)

									if typeof(v97) == "string" then
										Util:CreateWarning("SurvivorRequestWarning", v97)
									end
								end
							end
						end)
					end

					local Mouse = LocalPlayer:GetMouse()

					clone.Position = UDim2.fromOffset(Mouse.X, Mouse.Y + clone.AbsoluteSize.Y / 2)

					for _, child in pairs(clone.Choices:GetChildren()) do
						if child:IsA("GuiObject") then
							local childSize = child.Size

							child.Size = UDim2.new(child.Size.X.Scale, child.Size.X.Offset, 0, 0)
							game.TweenService:Create(child, TweenInfo.new(0.15), {
								Size = childSize
							}):Play()
						end
					end
				end
			end

			t1.Connections.SurvivorClicked = CharacterHovering.Clicked:Connect(survivorClicked)
			t1.Connections.SurvivorAdded = Actors.ActorAdded:Connect(function(p5) -- line: 217
				-- upvalues: t1 (copy)
				t1:UpdateSurvivor(p5)
			end)

			for _, child in pairs(CharacterParent:GetChildren()) do
				t1:UpdateSurvivor(child)
			end
		end
	end

	toggleRequestFunctionality()
	Character:GetPropertyChangedSignal("Parent"):Connect(toggleRequestFunctionality)
end
function t1.UpdateSurvivor(_, p7) -- line: 231
	-- upvalues: LocalPlayer (copy), Players (copy), Actors (copy), DataHandler (copy), CharacterHovering (copy)
	local Character = LocalPlayer.Character
	local player = Players:GetPlayerFromCharacter(Character)
	local v25 = Actors.CurrentActors[player] or nil
	local g33 = nil
	local g34 = nil
	local v30 = nil
	local g35 = nil
	local g40 = nil
	local v37 = nil

	if typeof(p7) == "table" then
	else
		local player3 = Players:GetPlayerFromCharacter(p7)

		p7 = Actors.CurrentActors[player3] or nil
	end

	local Customization = DataHandler:Get():WaitForChild("Settings"):WaitForChild("Customization")
	local v28 = Customization:FindFirstChild("NametagsEnabled") and Customization.NametagsEnabled.Value

	if not v25 then
		return
	end

	if not p7 then
		return
	end

	if p7 then
		local Requests = p7.Config.Requests

		if not Requests then
			v30 = false
		else
			for _, v in pairs(Requests) do
				if v then
					v30 = true
					g33 = true
				end

				if g33 then
					break
				end
			end

			if not g33 then
				v30 = false
			end
		end

		g33 = false

		repeat
			if g34 or v30 then
				g34 = false

				if p7.Rig.Parent == LocalPlayer.Character.Parent then
					CharacterHovering:AddHoverableCharacter(p7.Rig)

					return
				end

				g35 = true
			end

			if g35 then
				break
			end

			local Requesting = v25.Config.Requesting

			if not Requesting then
				v37 = false
			else
				for _, v in pairs(Requesting) do
					if v then
						v37 = true
						g40 = true
					end

					if g40 then
						break
					end
				end

				if not g40 then
					v37 = false
				end
			end

			g40 = false

			if v37 then
				g34 = true
			end
		until not g34
	end

	g35 = false

	if p7.Rig.Parent ~= LocalPlayer.Character.Parent or not v28 then
		CharacterHovering:RemoveHoverableCharacter(p7.Rig)

		return
	end
end
function t1.UpdateAll(_) -- line: 252
	-- upvalues: LocalPlayer (copy), t1 (copy)
	local v42 = LocalPlayer.Character and LocalPlayer.Character.Parent

	if not v42 then
		return
	end

	for _, child in pairs(v42:GetChildren()) do
		t1:UpdateSurvivor(child)
	end
end

return t1

