local t1 = {}
local DataHandler = require(game.ReplicatedStorage.Modules.DataHandler)

function t1.CreateTab(_, _) -- line: 5
	-- upvalues: DataHandler (copy), t1 (copy)
	local Sounds = require(game.ReplicatedStorage.Modules.Sounds)
	local Templates = script.Parent.Parent.Templates
	local LocalPlayer = game.Players.LocalPlayer
	local v8 = DataHandler:Get()
	local Emotes = v8.Purchased.Emotes
	local Emotes2 = v8.Equipped.Emotes
	local ExtraEmotes = v8.Equipped.ExtraEmotes
	local ExtraEmotes2 = LocalPlayer:GetAttribute("ExtraEmotes")
	local u13 = false
	local connection = nil
	local clone = Templates.EmoteMenuHolder:Clone()

	t1.EmoteWheel = clone

	local u16 = false

	local function makeEmoteEquipList(p3, p4) -- line: 27
		-- upvalues: u16 (ref), t1 (copy), Templates (copy), Emotes (copy)
		if u16 then
			return
		end

		u16 = true
		task.delay(0.5, function() -- line: 30
			-- upvalues: u16 (ref)
			u16 = false
		end)

		if t1.EquipMenu then
			game.TweenService:Create(t1.EquipMenu, TweenInfo.new(0.2), {
				Size = UDim2.fromScale(0, 0)
			}):Play()
			game.Debris:AddItem(t1.EquipMenu, 0.2)
		end

		local clone2 = Templates.EmoteEquipMenu:Clone()

		clone2.Size = UDim2.fromScale(0,0)
		clone2.Parent = p3.Parent
		clone2.Position = p3.Position
		clone2.ZIndex = 4
		t1.EquipMenu = clone2
		game.TweenService:Create(clone2, TweenInfo.new(0.2), {
			Size = UDim2.fromScale(0.56, 0.41)
		}):Play()

		for _, v in pairs({
			clone2.Cancel,
			clone2.Unequip
		}) do
			v.MouseButton1Click:Connect(function() -- line: 49
				-- upvalues: clone2 (copy), t1 (copy), v (copy), p4 (copy), p3 (copy)
				if clone2 == t1.EquipMenu then
					t1.EquipMenu = nil
					game.TweenService:Create(clone2, TweenInfo.new(0.2), {
						Size = UDim2.fromScale(0, 0)
					}):Play()
					game.Debris:AddItem(clone2, 0.2)

					if v.Name == "Unequip" then
						require(game.ReplicatedStorage.Modules.Network):FireServerConnection("EquipState", "REMOTE_EVENT", "Emotes", (p4.Name ~= "ExtraEmotes" and 0 or 8) + tonumber(p3.Name))
					end
				end
			end)
		end

		clone2.Searchbar.TextBox:GetPropertyChangedSignal("Text"):Connect(function() -- line: 66
			-- upvalues: clone2 (copy)
			for _, child in pairs(clone2.EmoteList:GetChildren()) do
				if child:IsA("GuiObject") then
					child.Visible = clone2.Searchbar.TextBox.Text == "" or child.Name:lower():find(clone2.Searchbar.TextBox.Text:lower())
				end
			end
		end)

		for _, child in pairs(Emotes:GetChildren()) do
			local childName = game.ReplicatedStorage.Assets.Emotes:FindFirstChild(child.Name)
			local v38 = childName and require(childName)

			if v38 then
				local clone3 = Templates.EmoteHolder:Clone()

				clone3.Name = v38.DisplayName or childName.Name
				clone3.Title.Text = clone3.Name
				clone3.Button.Icon.Image = v38.RenderImage or ""
				clone3.Parent = clone2.EmoteList
				clone3.Button.MouseButton1Click:Connect(function() -- line: 85
					-- upvalues: clone2 (copy), t1 (copy), childName (copy), p4 (copy), p3 (copy)
					if clone2 == t1.EquipMenu then
						t1.EquipMenu = nil
						game.TweenService:Create(clone2, TweenInfo.new(0.2), {
							Size = UDim2.fromScale(0, 0)
						}):Play()
						game.Debris:AddItem(clone2, 0.2)
						require(game.ReplicatedStorage.Modules.Network):FireServerConnection("EquipState", "REMOTE_EVENT", childName, (p4.Name ~= "ExtraEmotes" and 0 or 8) + tonumber(p3.Name))
					end
				end)
				clone3.ZIndex = 4
				clone3.Title.ZIndex = 7
				clone3.Button.ZIndex = 5
				clone3.Button.Icon.ZIndex = 6
			end
		end
	end
	local function updateExtraEmoteUI() -- line: 105
		-- upvalues: ExtraEmotes2 (ref), LocalPlayer (copy), clone (copy), connection (ref), Sounds (copy), u13 (ref)
		ExtraEmotes2 = LocalPlayer:GetAttribute("ExtraEmotes") == true
		clone.ExtraSwitch.Visible = ExtraEmotes2
		clone.ExtraSwitch.Interactable = ExtraEmotes2
		clone.EmoteType.Position = ExtraEmotes2 and UDim2.fromScale(0.5, 0.413) or UDim2.fromScale(0.5, 0.5)

		if ExtraEmotes2 then
			connection = clone.ExtraSwitch.MouseButton1Click:Connect(function() -- line: 113
				-- upvalues: Sounds (copy), u13 (ref), clone (copy)
				Sounds:Play("switch")
				u13 = not u13
				clone.Emotes.Visible = not u13
				clone.ExtraEmotes.Visible = u13
			end)

			return
		end

		if connection then
			connection:Disconnect()
			connection = nil
		end
	end

	for _, v in ipairs({
		clone.Emotes,
		clone.ExtraEmotes
	}) do
		for _, child in ipairs(v:GetChildren()) do
			child.MouseButton1Click:Connect(function() -- line: 131
				-- upvalues: makeEmoteEquipList (copy), child (copy), v (copy)
				makeEmoteEquipList(child, v)
			end)
		end
	end

	local function setEquippedEmotes() -- line: 138
		-- upvalues: ExtraEmotes (copy), Emotes2 (copy), clone (copy)
		for _, v in ipairs({
			"Emotes",
			"ExtraEmotes"
		}) do
			local v42 = v == "ExtraEmotes" and ExtraEmotes or Emotes2
			local parts = string.split(v42.Value, "|")

			for k, v2 in pairs(parts) do
				local k2 = clone[v]:FindFirstChild(k)

				if k2 then
					local v2_2 = game.ReplicatedStorage.Assets.Emotes:FindFirstChild(v2)
					local v48 = v2_2 and require(v2_2)

					k2.Asset.Image = v48 and v48.RenderImage or ""
					k2.Title.Text = v48 and v48.DisplayName or ""
				end
			end
		end
	end
	local function onEquippedEmoteChanged() -- line: 154
		-- upvalues: setEquippedEmotes (copy)
		require(game.ReplicatedStorage.Systems.Character.Game.Emotes):BuildMenu()
		setEquippedEmotes()
	end

	setEquippedEmotes()
	Emotes2:GetPropertyChangedSignal("Value"):Connect(onEquippedEmoteChanged)
	ExtraEmotes:GetPropertyChangedSignal("Value"):Connect(onEquippedEmoteChanged)
	updateExtraEmoteUI()
	LocalPlayer:GetAttributeChangedSignal("ExtraEmotes"):Connect(updateExtraEmoteUI)

	return {}
end
function t1.Selected(_, p6) -- line: 173
	-- upvalues: t1 (copy)
	local InventoryContainer = p6.InventoryRoot.InventoryContainer

	if not t1.EmoteWheel.Parent then
		t1.EmoteWheel.Parent = InventoryContainer
	end
end
function t1.Deselected(_, _) -- line: 180
	-- upvalues: t1 (copy)
	t1.EmoteWheel.Parent = nil

	if t1.EquipMenu then
		t1.EquipMenu:Destroy()
		t1.EquipMenu = nil
	end
end

return t1
