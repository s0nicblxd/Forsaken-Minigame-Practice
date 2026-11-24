local t1 = {}
local DataHandler = require(game.ReplicatedStorage.Modules.DataHandler)
local Gradients = require(game.ReplicatedStorage.Assets.Meta.Gradients)
local ShopSale = require(game.ReplicatedStorage.Modules.CombatMenuCompat.ShopSale)
local TweenService = game:GetService("TweenService")
local t2 = {
	"Dev",
	"BLUU",
	"Halloween",
	"Christmas",
	"ExclusiveText",
	"Exclusive",
	"SpecialText",
	"Special",
	"Uncommon",
	"Epic",
	"Legendary"
}

function t1.SwitchTab(_, p2, p3) -- line: 38
	-- upvalues: t1 (copy)
	if p2 == t1.LastTab and not p3 then
		return
	end

	local Menu = t1.InventoryMenu.Menu
	local InfoContainer = Menu.InventoryRoot.InfoContainer
	local SideContainer = Menu.InventoryRoot.SideContainer
	local InventoryContainer = Menu.InventoryRoot.InventoryContainer
	local Topbar = InventoryContainer.Topbar
	local Searchbar = Topbar.Searchbar

	if t1.InventoryMenu.Menu.Visible and not p3 then
		require(game.ReplicatedStorage.Modules.Sounds):Play("select")
	end

	game.TweenService:Create(SideContainer, TweenInfo.new(0.4), {
		Size = UDim2.fromScale(0, 1)
	}):Play()
	game.TweenService:Create(InfoContainer, TweenInfo.new(0.4), {
		Size = UDim2.fromScale(0, 1)
	}):Play()
	game.TweenService:Create(InventoryContainer, TweenInfo.new(0.4), {
		Size = UDim2.fromScale(0.7, 1)
	}):Play()
	InventoryContainer.Contents.UIPadding.PaddingTop = UDim.new(0, workspace.CurrentCamera.ViewportSize.Y / 40)

	for _, child in pairs(Topbar:GetChildren()) do
		if child:IsA("ImageButton") then
			game.TweenService:Create(child, TweenInfo.new(0.25), {
				ImageColor3 = p2 == child.Name and Color3.new(1, 1, 1) or Color3.new()
			}):Play()
			game.TweenService:Create(child.Title, TweenInfo.new(0.25), {
				TextColor3 = p2 == child.Name and Color3.new() or Color3.new(1, 1, 1)
			}):Play()
		end
	end

	for _, child in pairs(InventoryContainer.Contents:GetChildren()) do
		if child:IsA("GuiObject") or child:IsA("Folder") then
			child.Parent = nil
		end
	end

	local v20 = (workspace:GetAttribute("ForcedServerGamemode") == "Randomizer" and script.RandomizerTabs or script.Tabs):FindFirstChild((tostring(t1.LastTab)))
	local v21 = v20 and require(v20)

	if v21 and v21.Selected then
		v21:Deselected(Menu)
	end

	local v22 = t1.__tabsData[p2]

	if v22 then
		for _, v in pairs(v22) do
			local Container = v:FindFirstChild("Container")
			local v26 = Container and Container:FindFirstChild("Title")

			if v:IsA("GuiObject") then
				v.Visible = not v26 or (Searchbar.TextBox.Text == "" or string.find(v26.Text:lower(), Searchbar.TextBox.Text:lower()))
			end

			v.Parent = InventoryContainer.Contents
		end
	end

	local p2_2 = (workspace:GetAttribute("ForcedServerGamemode") == "Randomizer" and script.RandomizerTabs or script.Tabs):FindFirstChild(p2)
	local v28 = p2_2 and require(p2_2)

	if v28 and v28.Selected then
		v28:Selected(Menu)
	end

	t1.LastTab = p2
end
function t1.SetupFavoriteStar(_: {[any]: any}, p4, b1: boolean, n1: number, p5: ((...any) -> ...any)) -- line: 110
	-- upvalues: TweenService (copy)
	local Sounds = require(game.ReplicatedStorage.Modules.Sounds)
	local Favorite = p4.Container.Favorite
 t1.__favoriteConnections=t1.__favoriteConnections or setmetatable({},{__mode="k"})
 local previous=t1.__favoriteConnections[Favorite]
 if previous then previous:Disconnect()end
	local v37 = math.clamp(n1, -499999999, 499999999)

	local function refresh() -- line: 115
		-- upvalues: Favorite (copy), b1 (ref), p4 (copy), v37 (copy)
		Favorite.Image = not b1 and "rbxassetid://124616983330179" or "rbxassetid://109991111422732"
		p4.LayoutOrder = if not b1 then v37 else v37 - 1000000000
	end

	t1.__favoriteConnections[Favorite]=Favorite.MouseButton1Click:Connect(function() -- line: 120
		-- upvalues: b1 (ref), Favorite (copy), p4 (copy), v37 (copy), TweenService (copy), Sounds (copy), p5 (copy)
		b1 = not b1
		Favorite.Image = not b1 and "rbxassetid://124616983330179" or "rbxassetid://109991111422732"
		p4.LayoutOrder = if not b1 then v37 else v37 - 1000000000

		local v102 = not b1 and 0 or 360
		local v103 = math.abs(v102 - Favorite.Rotation) * 0.5 / 360

		TweenService:Create(Favorite, TweenInfo.new(v103, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			Rotation = v102
		}):Play()

		local v104 = not b1 and "rbxassetid://123918163549718" or "rbxassetid://72021954943640"

		if v104 ~= "" then
			Sounds:Play(v104)
		end

		p5(b1)
	end)
	Favorite.Active = true
	Favorite.Visible = true
	Favorite.Rotation = not b1 and 0 or 360
	Favorite.Image = not b1 and "rbxassetid://124616983330179" or "rbxassetid://109991111422732"
	p4.LayoutOrder = if not b1 then v37 else v37 - 1000000000
end
function t1.GetCardOrder(_: {[any]: any}, t5: {[any]: any}) -- line: 143
	local t6 = {}

	for _, v43 in t5 do
		local ok, result = pcall(require, v43:FindFirstChild("Config"))
		local v46 = if not ok or typeof(result) ~= "table" then {} else result

		table.insert(t6, {
			Folder = v43,
			Price = tonumber(v46.Price) or 1000,
			DisplayName = string.lower((tostring(v46.DisplayName or v43.Name))),
			Name = v43.Name
		})
	end

	table.sort(t6, function(p6, p7) -- line: 158
		if p6.Price ~= p7.Price then
			return p6.Price < p7.Price
		end

		if p6.DisplayName ~= p7.DisplayName then
			return p6.DisplayName < p7.DisplayName
		end

		return p6.Name < p7.Name
	end)

	local t7 = {}

	for v48, v49 in t6 do
		t7[v49.Folder] = v48
	end

	return function(p8) -- line: 173
		-- upvalues: t7 (copy), t6 (copy)
		return t7[p8] or #t6 + 1
	end
end
function t1.Start(_) -- line: 178
	-- upvalues: DataHandler (copy), t1 (copy), ShopSale (copy), Gradients (copy), t2 (copy)
	local EventHandlerClient = require(game.ReplicatedStorage.Modules.EventHandlerClient)
	local Info = EventHandlerClient:GetInfo()

	if not Info then
		EventHandlerClient.onEventInfoGiven:Wait()
		Info = EventHandlerClient:GetInfo()
	end

	local LocalPlayer = game.Players.LocalPlayer
	local v54 = DataHandler:ReadPath("Equipped")
	local v55 = DataHandler:ReadPath("Purchased")
	local Initializer = require(game.ReplicatedStorage.Initializer)
	local Network = require(game.ReplicatedStorage.Modules.Network)
	local Sounds = require(game.ReplicatedStorage.Modules.Sounds)
	local TextService = game:GetService("TextService")
	local UserInputService = game:GetService("UserInputService")

	t1.InventoryMenu = Initializer.PlayerSystems.SidebarHandler:CreateSidebarMenu("Inventory", script.InventoryScreen)

	local Menu = t1.InventoryMenu.Menu
	local SideContainer = Menu.InventoryRoot.SideContainer
	local InfoContainer = Menu.InventoryRoot.InfoContainer
	local SkinsContainer = Menu.InventoryRoot.SkinsContainer
	local InventoryContainer = Menu.InventoryRoot.InventoryContainer
	local EquipContainer = SideContainer.EquipContainer
	local Topbar = InventoryContainer.Topbar
	local Searchbar = Topbar.Searchbar

	local function updateCanvasSize(p10) -- line: 209
		p10.CanvasSize = UDim2.fromScale(1, 0)

		if p10.AbsoluteCanvasSize.Y > p10.AbsoluteWindowSize.Y then
			p10.CanvasSize = UDim2.new(1, 0, 0, p10.AbsoluteCanvasSize.Y * 1.05)
		end
	end

	InventoryContainer.Contents.ChildAdded:Connect(function() -- line: 218
		-- upvalues: InventoryContainer (copy)
		local Contents = InventoryContainer.Contents

		Contents.CanvasSize = UDim2.fromScale(1, 0)

		if Contents.AbsoluteCanvasSize.Y > Contents.AbsoluteWindowSize.Y then
			Contents.CanvasSize = UDim2.new(1, 0, 0, Contents.AbsoluteCanvasSize.Y * 1.05)
		end
	end)
	InventoryContainer.Contents.ChildRemoved:Connect(function() -- line: 219
		-- upvalues: InventoryContainer (copy)
		local Contents = InventoryContainer.Contents

		Contents.CanvasSize = UDim2.fromScale(1, 0)

		if Contents.AbsoluteCanvasSize.Y > Contents.AbsoluteWindowSize.Y then
			Contents.CanvasSize = UDim2.new(1, 0, 0, Contents.AbsoluteCanvasSize.Y * 1.05)
		end
	end)
	InventoryContainer:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 220
		-- upvalues: InventoryContainer (copy)
		local Contents = InventoryContainer.Contents

		Contents.CanvasSize = UDim2.fromScale(1, 0)

		if Contents.AbsoluteCanvasSize.Y > Contents.AbsoluteWindowSize.Y then
			Contents.CanvasSize = UDim2.new(1, 0, 0, Contents.AbsoluteCanvasSize.Y * 1.05)
		end
	end)
	SkinsContainer.Contents.ChildAdded:Connect(function() -- line: 221
		-- upvalues: SkinsContainer (copy)
		local Contents = SkinsContainer.Contents

		Contents.CanvasSize = UDim2.fromScale(1, 0)

		if Contents.AbsoluteCanvasSize.Y > Contents.AbsoluteWindowSize.Y then
			Contents.CanvasSize = UDim2.new(1, 0, 0, Contents.AbsoluteCanvasSize.Y * 1.05)
		end
	end)
	SkinsContainer.Contents.ChildRemoved:Connect(function() -- line: 222
		-- upvalues: SkinsContainer (copy)
		local Contents = SkinsContainer.Contents

		Contents.CanvasSize = UDim2.fromScale(1, 0)

		if Contents.AbsoluteCanvasSize.Y > Contents.AbsoluteWindowSize.Y then
			Contents.CanvasSize = UDim2.new(1, 0, 0, Contents.AbsoluteCanvasSize.Y * 1.05)
		end
	end)
	SideContainer.Size = UDim2.fromScale(0, 1)
	SideContainer.Visible = false
	t1.InventoryMenu.Toggled:Connect(function(_) -- line: 231
		-- upvalues: t1 (copy), EquipContainer (copy), SideContainer (copy), InfoContainer (copy), SkinsContainer (copy), InventoryContainer (copy)
		t1:SwitchTab(t1.LastTab or "Killers", true)
		game.TweenService:Create(EquipContainer.Buttons.ViewSkins.Inverted, TweenInfo.new(0.25), {
			ImageTransparency = 1
		}):Play()
		game.TweenService:Create(EquipContainer.Buttons.ViewInfo.Inverted, TweenInfo.new(0.25), {
			ImageTransparency = 1
		}):Play()
		game.TweenService:Create(SideContainer, TweenInfo.new(0.4), {
			Size = UDim2.fromScale(0, 1)
		}):Play()
		game.TweenService:Create(InfoContainer, TweenInfo.new(0.4), {
			Size = UDim2.fromScale(0, 1)
		}):Play()
		game.TweenService:Create(SkinsContainer, TweenInfo.new(0.4), {
			Size = UDim2.fromScale(0, 1)
		}):Play()
		game.TweenService:Create(InventoryContainer, TweenInfo.new(0.4), {
			Size = UDim2.fromScale(0.7, 1)
		}):Play()
		task.delay(0.25, function() -- line: 239
			-- upvalues: InventoryContainer (copy)
			InventoryContainer.Visible = true
		end)
	end)

	local function giveDevKillers() -- line: 245
		-- upvalues: LocalPlayer (copy), DataHandler (copy)
		if workspace:GetAttribute("ServerType") == "VIP" and LocalPlayer:GetAttribute("VIP") then
			local v115 = DataHandler:Get(LocalPlayer, 1)

			if not v115 then
				return
			end

			for _, v in ipairs(require(game.ReplicatedStorage.Modules.Schematics.VIPKillersSchematic)) do
				if v.Type and v.Name then
					local vType = v115.Purchased:FindFirstChild(v.Type)
					local vType2 = game.ReplicatedStorage.Assets:FindFirstChild(v.Type)

					if not vType2 or not vType then
						warn(`[{ script }]: Could not find folder for item type { v.Type } in { (if vType2 then `{ LocalPlayer.Name }'s PlayerData` else "Assets") }`)
					elseif not vType2:FindFirstChild(v.Name, true) then
						warn(`[{ script }]: Could not find folder for item { v.Name }`)
					elseif not vType:FindFirstChild(v.Name) then
						local NumberValue = Instance.new("NumberValue")

						NumberValue:SetAttribute("Temp", true)
						NumberValue.Name = v.Name
						NumberValue.Parent = vType
					end
				end
			end
		end
	end
	local function addUIThingies(p12) -- line: 278
		-- upvalues: Sounds (copy)
		if (p12:IsA("TextButton") or p12:IsA("ImageButton")) and not p12:GetAttribute("SFXImplemented") then
			p12:SetAttribute("SFXImplemented", true)
			p12.MouseEnter:Connect(function() -- line: 282
				-- upvalues: Sounds (copy)
				Sounds:Play("hover")
			end)
			p12.MouseLeave:Connect(function() -- line: 286
				-- upvalues: Sounds (copy)
				Sounds:Play("hoverEnd")
			end)

			if p12.Parent.Name ~= "Topbar" then
				p12.MouseButton1Click:Connect(function() -- line: 291
					-- upvalues: Sounds (copy)
					Sounds:Play("select")
				end)
			end
		end
	end

	for _, descendant in pairs(Menu:GetDescendants()) do
		addUIThingies(descendant)
	end

	Menu.DescendantAdded:Connect(addUIThingies)

	local Util = require(game.ReplicatedStorage.Modules.Util)

	Util:CreateMoneyDisplay(InventoryContainer.Money)

	local u75 = nil
	local v76 = DataHandler:ReadPath("Equipped")

	for _, v78 in {
		"Survivor",
		"Killer"
	} do
		v76[v78].Changed:Connect(function(property: string) -- line: 308
			-- upvalues: u75 (ref)
			if property ~= u75 then
				u75 = nil
			end
		end)
	end

	local v79 = workspace:GetAttribute("ForcedServerGamemode") == "Randomizer"

	EquipContainer.Equip.MouseButton1Click:Connect(function() -- line: 315
		-- upvalues: v79 (copy), t1 (copy), u75 (ref), Network (copy)
		if v79 then
			return
		end

		if not t1.CurrentlySelected or u75 == t1.CurrentlySelected.Name then
			return
		end

		u75 = t1.CurrentlySelected.Name
		Network:FireServerConnection("EquipState", "REMOTE_EVENT", t1.CurrentlySelected, true)
	end)

	local function promptPurchaseConfirmation(p13) -- line: 328
		-- upvalues: t1 (copy), Menu (copy), Info (ref), ShopSale (copy), v55 (copy), Network (copy)
		local v124 = p13 and p13:FindFirstChild("Config") or t1.CurrentlySelected and (t1.CurrentlySelected:FindFirstChild("Config") or t1.CurrentlySelected:IsA("ModuleScript") and t1.CurrentlySelected)
		local v125 = v124 and require(v124)

		if v125 and not Menu:FindFirstChild("ConfirmPurchase") then
			local v126 = Info[`{ v125.CurrencyType }_Server`]
			local FinalPrice = ShopSale.GetAssetPrice(p13 or t1.CurrentlySelected, v125, workspace:GetServerTimeNow()).FinalPrice
			local clone = script.Templates.ConfirmPurchase:Clone()

			clone.Size = UDim2.fromScale(0.3, 0)

			local function updateTitleText() -- line: 337
				-- upvalues: v126 (copy), FinalPrice (ref), clone (copy), v125 (copy)
				local v200 = v126 and `{ tostring(FinalPrice) } { v126.CurrencyName }` or if not (FinalPrice <= 0) then `{ tostring(FinalPrice) }$` else "FREE"

				clone.Title.Text = `Are you sure you would like to purchase <b><font color="rgb(255,255,255)">{ tostring(v125.DisplayName) }</font></b> for <b><font color="rgb(255,255,255)">{ v200 }</font></b>?`
			end

			local v130 = v126 and `{ tostring(FinalPrice) } { v126.CurrencyName }` or if not (FinalPrice <= 0) then `{ tostring(FinalPrice) }$` else "FREE"

			clone.Title.Text = `Are you sure you would like to purchase <b><font color="rgb(255,255,255)">{ tostring(v125.DisplayName) }</font></b> for <b><font color="rgb(255,255,255)">{ v130 }</font></b>?`
			clone.Parent = Menu
			game.TweenService:Create(clone, TweenInfo.new(0.3), {
				Size = UDim2.fromScale(0.3, 0.3)
			}):Play()

			if p13 and not v55.Killers:FindFirstChild((tostring(t1.CurrentlySelected))) and not v55.Survivors:FindFirstChild((tostring(t1.CurrentlySelected))) then
				clone.Disclaimer.Text = "DISCLAIMER:\nYou don't own this character yet.\nWhatever you're trying to do right now is dumb."
			elseif v125.DisclaimerText then
				clone.Disclaimer.Text = `DISCLAIMER:\n{ tostring(v125.DisclaimerText) }`
			end

			local u131 = false
			local u132 = false
			local YesTitle = clone.Buttons.Yes.Title
			local v134 = p13 or t1.CurrentlySelected

			clone.Buttons.Yes.MouseButton1Click:Connect(function() -- line: 358
				-- upvalues: u131 (ref), YesTitle (copy), Network (copy), v134 (copy), FinalPrice (ref), u132 (ref), clone (copy), v126 (copy), v125 (copy)
				if not u131 then
					u131 = true
					YesTitle.Text = "..."

					local v201 = Network:FireServerConnection("PurchaseContent", "REMOTE_FUNCTION", v134, FinalPrice)

					if v201.Status == "success" then
						YesTitle.Text = "Bought!"
						task.wait(0.5)

						if not u132 then
							u132 = true
							game.TweenService:Create(clone, TweenInfo.new(0.3), {
								Size = UDim2.fromScale(0.3, 0)
							}):Play()
							game.Debris:AddItem(clone, 0.3)
						end

						return
					end

					if v201.Status == "poor" then
						YesTitle.Text = "Insufficient funds!"
					elseif v201.Status == "alreadyBought" then
						YesTitle.Text = "Already owned! (You were not charged)"
					elseif v201.Status == "rateLimited" then
						YesTitle.Text = "Ratelimited! (You were not charged)"
					elseif v201.Status == "failed" then
						YesTitle.Text = "Something went wrong... (You were not charged)"
					elseif v201.Status == "priceChanged" then
						YesTitle.Text = "Price changed! (You were not charged)"
						FinalPrice = v201.Price

						local v202 = v126 and `{ tostring(FinalPrice) } { v126.CurrencyName }` or if not (FinalPrice <= 0) then `{ tostring(FinalPrice) }$` else "FREE"

						clone.Title.Text = `Are you sure you would like to purchase <b><font color="rgb(255,255,255)">{ tostring(v125.DisplayName) }</font></b> for <b><font color="rgb(255,255,255)">{ v202 }</font></b>?`
					end

					task.delay(0.5, function() -- line: 392
						-- upvalues: u131 (ref), YesTitle (copy)
						u131 = false
						YesTitle.Text = "Yes"
					end)
				end
			end)
			clone.Buttons.No.MouseButton1Click:Connect(function() -- line: 400
				-- upvalues: u132 (ref), clone (copy)
				if not u132 then
					u132 = true
					game.TweenService:Create(clone, TweenInfo.new(0.3), {
						Size = UDim2.fromScale(0.3, 0)
					}):Play()
					game.Debris:AddItem(clone, 0.3)
				end
			end)
		end
	end

	EquipContainer.Purchase.MouseButton1Click:Connect(promptPurchaseConfirmation)

	local function updateEquips(p14) -- line: 413
		-- upvalues: InventoryContainer (copy), SkinsContainer (copy), v54 (copy), t1 (copy)
		for _, v in pairs({
			InventoryContainer.Contents,
			SkinsContainer.Contents
		}) do
			for _, child in pairs(v:GetChildren()) do
				if child:IsA("GuiObject") and not child:GetAttribute("IgnoreEquipUpdate") then
					local v140 = false

					for _, descendant in pairs(v54:GetDescendants()) do
						if not descendant:IsA("ValueBase") or descendant.Value ~= child.Name then
							continue
						end

						local v143 = t1.CurrentlySelected and t1.CurrentlySelected.Name or "NONE"

						if (descendant.Parent.Name ~= "Skins" or v143 == descendant.Name) and descendant.Parent.Name == "Skins" == (v == SkinsContainer.Contents) then
							local EquipSlot = child:GetAttribute("EquipSlot")

							if EquipSlot and EquipSlot ~= descendant.Name then
								continue
							end

							v140 = true

							break
						end
					end

					if v140 and child.Container.Equipped.ImageTransparency ~= 0 then
						if p14 then
							child.Container.Equipped.ImageTransparency = 0
						else
							game.TweenService:Create(child.Container.Equipped, TweenInfo.new(0.125), {
								ImageTransparency = 0
							}):Play()
						end
					elseif not v140 and child.Container.Equipped.ImageTransparency ~= 1 then
						game.TweenService:Create(child.Container.Equipped, TweenInfo.new(0.125), {
							ImageTransparency = 1
						}):Play()
					end
				end
			end
		end
	end

	local u82 = nil

	local function loadActorInfo(p15) -- line: 458
		-- upvalues: u82 (ref), InfoContainer (copy), Menu (copy), LocalPlayer (copy), UserInputService (copy), TextService (copy), Util (copy)
		if p15 ~= u82 then
			u82 = p15

			local Templates = script.Templates
			local t8 = {}

			for _, child in pairs(InfoContainer.Contents:GetChildren()) do
				if child:IsA("GuiObject") then
					child:Destroy()
				end
			end

			for k, v in pairs(p15 or {}) do
				local Frame = Instance.new("Frame")

				Frame.Name = "Content"
				Frame.BackgroundTransparency = 1
				Frame.Size = UDim2.fromScale(1, 0)
				Frame.AutomaticSize = Enum.AutomaticSize.Y
				Frame.LayoutOrder = k
				Frame.Parent = InfoContainer.Contents

				local UIListLayout = Instance.new("UIListLayout")

				UIListLayout.Padding = UDim.new(0, 10)
				UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
				UIListLayout.Parent = Frame

				local _ = workspace.CurrentCamera.ViewportSize.Y

				for k2, v2 in pairs(v) do
					if k2 == "Separator" then
						local clone = Templates.Seperator:Clone()

						clone.Title.Text = tostring(v2)
						clone.Parent = Frame
					elseif k2 == "Header" then
						local clone = Templates.Header:Clone()

						clone.Text = tostring(v2)
						clone.Parent = Frame
					elseif k2 == "Quote" then
						local clone = Templates.Quote:Clone()

						clone.Text = tostring(v2)
						clone.Parent = Frame
					elseif k2 == "Text" then
						local clone = Templates.TextContainer:Clone()

						clone.Title.MaxVisibleGraphemes = 0
						clone.Title.Text = tostring(v2)
						clone.Image.Image = tostring(v.Image)
						clone.Image.Visible = v.Image
						clone.Parent = Frame
						table.insert(t8, clone.Title)
						game.TweenService:Create(clone.Title, TweenInfo.new(5, Enum.EasingStyle.Quint), {
							MaxVisibleGraphemes = #clone.Title.Text + 10
						}):Play()
					end
				end
			end

			task.spawn(function() -- line: 526
				-- upvalues: p15 (copy), u82 (ref), Menu (copy), InfoContainer (copy), LocalPlayer (copy), UserInputService (copy), t8 (copy), TextService (copy), Util (copy)
				local t9 = {}

				local function addStatus(p16) -- line: 529
					-- upvalues: addStatus (copy), t9 (copy)
					if p16:IsA("Folder") then
						for _, child in pairs(p16:GetChildren()) do
							addStatus(child)
						end

						return
					end

					if p16:IsA("ModuleScript") then
						local lib = require(p16)

						t9[p16.Name] = lib.Data.Description or "???"
					end
				end

				addStatus(game.ReplicatedStorage.Modules.Schematics.StatusEffects)

				local v205 = nil
				local g241 = nil

				while task.wait() and p15 and u82 == p15 do
					if Menu.Visible and InfoContainer.Size.X.Scale >= 0.5 and LocalPlayer.Character and tostring(LocalPlayer.Character.Parent) == "Spectating" then
						local v206 = UserInputService:GetMouseLocation() - game.GuiService:GetGuiInset()
						local v207 = false

						for _, v in pairs(t8) do
							if v207 then
								break
							end

							local AbsolutePosition = v.AbsolutePosition
							local AbsoluteSize = v.AbsoluteSize

							if v206.X >= AbsolutePosition.X and v206.X <= AbsolutePosition.X + AbsoluteSize.X and v206.Y >= AbsolutePosition.Y and v206.Y <= AbsolutePosition.Y + AbsoluteSize.Y then
								local v212 = v.Text:gsub("<.->", "")
								local vFont = v.Font
								local vTextSize = v.TextSize
								local AbsoluteSizeX = AbsoluteSize.X
								local parts = v212:split("\n")
								local t10 = {}

								for _, v3 in ipairs(parts) do
									local parts2 = v3:split(" ")
									local t11 = {}
									local n2 = 0

									for _, v4 in ipairs(parts2) do
										local TextSize = TextService:GetTextSize(v4, vTextSize, vFont, Vector2.new(AbsoluteSizeX, 1e999))
										local X = TextService:GetTextSize(" ", vTextSize, vFont, Vector2.new(AbsoluteSizeX, 1e999)).X

										if AbsoluteSizeX < n2 + TextSize.X then
											table.insert(t10, t11)
											t11 = {}
											n2 = 0
										end

										table.insert(t11, v4)
										n2 = n2 + TextSize.X + X
									end

									if #t11 > 0 then
										table.insert(t10, t11)
									end
								end

								local Y = TextService:GetTextSize("Test", vTextSize, vFont, Vector2.new(AbsoluteSizeX, 1e999)).Y
								local n3 = 0

								for _, v5 in ipairs(t10) do
									if v207 then
										break
									end

									local v231 = AbsolutePosition.Y + n3
									local v232 = v231 + Y

									if v231 <= v206.Y and v232 >= v206.Y then
										local n4 = 0

										for _, v6 in ipairs(v5) do
											local TextSize = TextService:GetTextSize(v6, vTextSize, vFont, Vector2.new(AbsoluteSizeX, 1e999))
											local v237 = AbsolutePosition.X + n4
											local v238 = v237 + TextSize.X

											if v237 <= v206.X and v238 >= v206.X then
												local _ = game.ReplicatedStorage.Modules.Schematics.StatusEffects
												local v240 = t9[v6]

												if not v240 then
													g241 = true
												end

												if not g241 then
													v207 = true
													v205 = Util:CreateTooltip(v240)
													g241 = true
												end
											end

											if g241 then
												break
											end

											if g241 then
												break
											end

											local X = TextService:GetTextSize(" ", vTextSize, vFont, Vector2.new(AbsoluteSizeX, 1e999)).X

											n4 = n4 + TextSize.X + X
										end

										if not g241 then
											if not g241 then
												break
											end
										end
									end

									if g241 then
										break
									end

									if g241 then
										break
									end

									n3 += Y
								end
							end

							g241 = false
						end

						if not v207 then
							v205 = Util:CreateTooltip()
						end
					elseif v205 then
						v205 = Util:CreateTooltip()
					end
				end
			end)
		end
	end
	local function loadActorSkins(p17) -- line: 651
		-- upvalues: SkinsContainer (copy), t1 (copy), Network (copy), updateEquips (copy), DataHandler (copy), Gradients (copy), t2 (copy), Util (copy), Sounds (copy)
		if p17 then
			for _, child in pairs(SkinsContainer.Contents:GetChildren()) do
				if child:IsA("GuiObject") then
					child:Destroy()
				end
			end

			local v164 = t1.CurrentlySelected and t1.CurrentlySelected:FindFirstChild("Config")
			local v165 = v164 and require(v164)

			SkinsContainer.TitleDisplay.Title.Text = `{ v165.DisplayName or tostring(p17.Name) } Skins`

			local clone = script.Templates.CardTemplate:Clone()
			local Container = clone.Container

			clone.Name = "Randomized"
			clone.LayoutOrder = -2147483648
			clone.Parent = SkinsContainer.Contents

			local v168 = p17.Parent.Name ~= "Killers" and "rbxassetid://71383130474277" or "rbxassetid://87788475665792"

			Container.CharacterRender.Image = v168
			Container.CharacterRender.BackgroundTransparency = 0
			Container.CharacterRender.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
			Container.CharacterRender.ImageColor3 = Color3.fromRGB(255, 255, 255)
			Container.Title.Text = "Randomized"
			Container.MouseEnter:Connect(function() -- line: 678
				-- upvalues: Container (copy)
				game.TweenService:Create(Container, TweenInfo.new(0.25), {
					Size = UDim2.fromScale(1.05, 1.05)
				}):Play()
			end)
			Container.MouseLeave:Connect(function() -- line: 682
				-- upvalues: Container (copy)
				game.TweenService:Create(Container, TweenInfo.new(0.25), {
					Size = UDim2.fromScale(1, 1)
				}):Play()
			end)
			Container.Interact.MouseButton1Click:Connect(function() -- line: 686
				-- upvalues: Network (copy), p17 (copy), Container (copy)
				Network:FireServerConnection("EquipState", "REMOTE_EVENT", `RandomizedSkin/{ p17.Name }`, Container.Equipped.ImageTransparency > 0.5)
			end)
			updateEquips(true)

			local p17Name = DataHandler:ReadPath("Favorites/Skins"):FindFirstChild(p17.Name)
			local t12 = {}
			local Skins = DataHandler:ReadPath("Purchased").Skins

			for _, child in p17:GetChildren() do
				if Skins:FindFirstChild(child.Name, true) then
					table.insert(t12, child)
				end
			end

			local CardOrder = t1:GetCardOrder(t12)

			for _, child in pairs(p17:GetChildren()) do
				if DataHandler:ReadPath("Purchased").Skins:FindFirstChild(child.Name, true) then
					local Config = require(child.Config)
					local clone2 = script.Templates.CardTemplate:Clone()
					local Container2 = clone2.Container

					clone2.Name = child.Name

					local v180 = CardOrder(child)

					clone2.Parent = SkinsContainer.Contents
					Container2.CharacterRender.Image = Config.RenderImage or "rbxassetid://13373279056"
					Container2.Title.Text = tostring(Config.DisplayName)

					local Rarity = Config.Rarity

					if Rarity then
						local ok, result = pcall(Gradients[Rarity], Container2)

						if not ok then
							warn(`[{ script:GetFullName() }]: Failed to apply gradient for skin: { child.Name }/{ Rarity }, got: { result }`)
						end
					else
						for _, v185 in t2 do
							local v186 = Gradients[v185]

							if Config[v185] and v186 then
								local ok, result = pcall(Gradients[v185], Container2)

								if ok then
									break
								end

								warn(`[{ script:GetFullName() }]: Failed to apply gradient for skin: { child.Name }/{ v185 }, got: { result }`)
							end
						end
					end

					local v189 = require(game.ReplicatedStorage.Modules.Schematics.IngameCollabs)[Config.CollabInfo] or Config.CollabInfo

					if typeof(v189) == "table" then
						local clone3 = game.ReplicatedStorage.Assets.UI.ShopCardIcon:Clone()

						clone3.Image = v189.Icon or "rbxassetid://9011713759"
						clone3.Parent = Container2.CardIcons
						clone3.MouseEnter:Connect(function() -- line: 751
							-- upvalues: Util (copy), v189 (copy)
							Util:CreateTooltip(v189.Description)
						end)
						clone3.MouseLeave:Connect(function() -- line: 756
							-- upvalues: Util (copy)
							Util:CreateTooltip()
						end)
					end

					local ParentName = p17.Parent.Name

					if ParentName == "Survivors" then
						Container2.Title.TextColor3 = Color3.fromRGB(200, 200, 255)
					elseif ParentName == "Killers" then
						Container2.Title.TextColor3 = Color3.fromRGB(255, 200, 200)
					end

					Container2.MouseEnter:Connect(function() -- line: 771
						-- upvalues: Container2 (copy)
						game.TweenService:Create(Container2, TweenInfo.new(0.25), {
							Size = UDim2.fromScale(1.05, 1.05)
						}):Play()
					end)
					Container2.MouseLeave:Connect(function() -- line: 775
						-- upvalues: Container2 (copy)
						game.TweenService:Create(Container2, TweenInfo.new(0.25), {
							Size = UDim2.fromScale(1, 1)
						}):Play()
					end)
					Container2.Interact.MouseButton1Click:Connect(function() -- line: 779
						-- upvalues: Sounds (copy), Container2 (copy), Network (copy), child (copy)
						Sounds:Play(not (Container2.Equipped.ImageTransparency > 0.5) and "rbxassetid://102724453594558" or "rbxassetid://94806415814248")
						Network:FireServerConnection("EquipState", "REMOTE_EVENT", child, Container2.Equipped.ImageTransparency > 0.5)
					end)

					local v192 = p17Name ~= nil and p17Name:FindFirstChild(child.Name) ~= nil

					t1:SetupFavoriteStar(clone2, v192, v180, function(p18) -- line: 785
						-- upvalues: Network (copy), p17 (copy), child (copy)
						Network:FireServerConnection("FavoriteSkin", "REMOTE_EVENT", p17.Name, child.Name, p18)
					end)
					updateEquips(true)
				end
			end
		end
	end

	local thread = nil
	local u86 = false

	EquipContainer.Buttons.ViewInfo.MouseButton1Click:Connect(function() -- line: 799
		-- upvalues: u86 (ref), t1 (copy), loadActorInfo (copy), thread (ref), InfoContainer (copy), EquipContainer (copy), SkinsContainer (copy), InventoryContainer (copy)
		if u86 then
			return
		end

		u86 = true

		local v193 = t1.CurrentlySelected and t1.CurrentlySelected:FindFirstChild("Config")
		local v194 = v193 and require(v193)

		if not v194 or not v194.Information then
			u86 = false

			return
		end

		loadActorInfo(v194.Information)

		if thread then
			task.cancel(thread)
		end

		if InfoContainer.Size.X.Scale >= 0.35 then
			game.TweenService:Create(EquipContainer.Buttons.ViewSkins.Inverted, TweenInfo.new(0.25), {
				ImageTransparency = 1
			}):Play()
			game.TweenService:Create(EquipContainer.Buttons.ViewInfo.Inverted, TweenInfo.new(0.25), {
				ImageTransparency = 1
			}):Play()
			game.TweenService:Create(SkinsContainer, TweenInfo.new(0.25), {
				Size = UDim2.fromScale(0, 1)
			}):Play()
			game.TweenService:Create(InfoContainer, TweenInfo.new(0.25), {
				Size = UDim2.fromScale(0, 1)
			}):Play()
			game.TweenService:Create(InventoryContainer, TweenInfo.new(0.25), {
				Size = UDim2.fromScale(0.7, 1)
			}):Play()
			thread = task.delay(0.25, function() -- line: 819
				-- upvalues: SkinsContainer (copy), InfoContainer (copy)
				SkinsContainer.Visible = false
				InfoContainer.Visible = false
			end)
			task.delay(0.175, function() -- line: 820
				-- upvalues: u86 (ref)
				u86 = false
			end)
			InventoryContainer.Visible = true

			return
		end

		game.TweenService:Create(EquipContainer.Buttons.ViewSkins.Inverted, TweenInfo.new(0.25), {
			ImageTransparency = 1
		}):Play()
		game.TweenService:Create(EquipContainer.Buttons.ViewInfo.Inverted, TweenInfo.new(0.25), {
			ImageTransparency = 0
		}):Play()
		game.TweenService:Create(SkinsContainer, TweenInfo.new(0.25), {
			Size = UDim2.fromScale(0, 1)
		}):Play()
		game.TweenService:Create(InfoContainer, TweenInfo.new(0.25), {
			Size = UDim2.fromScale(0.7, 1)
		}):Play()
		game.TweenService:Create(InventoryContainer, TweenInfo.new(0.25), {
			Size = UDim2.fromScale(0, 1)
		}):Play()
		thread = task.delay(0.25, function() -- line: 828
			-- upvalues: SkinsContainer (copy), InventoryContainer (copy)
			SkinsContainer.Visible = false
			InventoryContainer.Visible = false
		end)
		task.delay(0.175, function() -- line: 829
			-- upvalues: u86 (ref)
			u86 = false
		end)
		InfoContainer.Visible = true
	end)

	local u87 = nil
	local Searchbar2 = SkinsContainer.Topbar.Searchbar

	EquipContainer.Buttons.ViewSkins.MouseButton1Click:Connect(function() -- line: 838
		-- upvalues: u86 (ref), t1 (copy), u87 (ref), Searchbar2 (copy), SkinsContainer (copy), loadActorSkins (copy), thread (ref), EquipContainer (copy), InfoContainer (copy), InventoryContainer (copy)
		if u86 then
			return
		end

		u86 = true

		if not t1.CurrentlySelected then
			return
		end

		local v195 = game.ReplicatedStorage.Assets.Skins:FindFirstChild((tostring(t1.CurrentlySelected.Parent)))
		local v196 = v195 and v195:FindFirstChild((tostring(t1.CurrentlySelected)))

		if not v196 then
			u86 = false

			return
		end

		if u87 then
			u87:Disconnect()
			u87 = nil
		end

		u87 = Searchbar2.TextBox:GetPropertyChangedSignal("Text"):Connect(function() -- line: 855
			-- upvalues: SkinsContainer (copy), Searchbar2 (copy)
			for _, child in pairs(SkinsContainer.Contents:GetChildren()) do
				if child:IsA("Frame") then
					local ContainerTitle = child.Container.Title

					pcall(function() -- line: 859
						-- upvalues: child (copy), Searchbar2 (copy), ContainerTitle (copy)
						child.Visible = Searchbar2.TextBox.Text == "" or string.find(ContainerTitle.Text:lower(), Searchbar2.TextBox.Text:lower())
					end)
				end
			end
		end)
		loadActorSkins(v196)

		if thread then
			task.cancel(thread)
		end

		if SkinsContainer.Size.X.Scale >= 0.35 then
			game.TweenService:Create(EquipContainer.Buttons.ViewSkins.Inverted, TweenInfo.new(0.25), {
				ImageTransparency = 1
			}):Play()
			game.TweenService:Create(EquipContainer.Buttons.ViewInfo.Inverted, TweenInfo.new(0.25), {
				ImageTransparency = 1
			}):Play()
			game.TweenService:Create(SkinsContainer, TweenInfo.new(0.25), {
				Size = UDim2.fromScale(0, 1)
			}):Play()
			game.TweenService:Create(InfoContainer, TweenInfo.new(0.25), {
				Size = UDim2.fromScale(0, 1)
			}):Play()
			game.TweenService:Create(InventoryContainer, TweenInfo.new(0.25), {
				Size = UDim2.fromScale(0.7, 1)
			}):Play()
			thread = task.delay(0.25, function() -- line: 875
				-- upvalues: InfoContainer (copy), SkinsContainer (copy)
				InfoContainer.Visible = false
				SkinsContainer.Visible = false
			end)
			task.delay(0.175, function() -- line: 876
				-- upvalues: u86 (ref)
				u86 = false
			end)
			InventoryContainer.Visible = true

			return
		end

		game.TweenService:Create(EquipContainer.Buttons.ViewSkins.Inverted, TweenInfo.new(0.25), {
			ImageTransparency = 0
		}):Play()
		game.TweenService:Create(EquipContainer.Buttons.ViewInfo.Inverted, TweenInfo.new(0.25), {
			ImageTransparency = 1
		}):Play()
		game.TweenService:Create(SkinsContainer, TweenInfo.new(0.25), {
			Size = UDim2.fromScale(0.7, 1)
		}):Play()
		game.TweenService:Create(InfoContainer, TweenInfo.new(0.25), {
			Size = UDim2.fromScale(0, 1)
		}):Play()
		game.TweenService:Create(InventoryContainer, TweenInfo.new(0.25), {
			Size = UDim2.fromScale(0, 1)
		}):Play()
		thread = task.delay(0.25, function() -- line: 884
			-- upvalues: InfoContainer (copy), InventoryContainer (copy)
			InfoContainer.Visible = false
			InventoryContainer.Visible = false
		end)
		task.delay(0.175, function() -- line: 885
			-- upvalues: u86 (ref)
			u86 = false
		end)
		SkinsContainer.Visible = true
	end)

	for _, child in pairs(EquipContainer.Buttons:GetChildren()) do
		local Description = child:GetAttribute("Description")

		if Description then
			child.Title.TextTransparency = 0
			child.Title.Text = Description
		end
	end

	t1.__tabsData = {}

	local v92 = workspace:GetAttribute("ForcedServerGamemode") == "Randomizer" and script.RandomizerTabs or script.Tabs

	for _, child in pairs(v92:GetChildren()) do
		local lib = require(child)

		lib.Inventory = t1

		local v96 = lib:CreateTab(Menu)

		t1.__tabsData[child.Name] = v96
	end

	t1:SwitchTab("Killers")
	updateEquips()

	local v97 = workspace:GetAttribute("ForcedServerGamemode") == "Randomizer"

	for _, descendant in pairs(v54:GetDescendants()) do
		if descendant:IsA("ValueBase") then
			descendant:GetPropertyChangedSignal("Value"):Connect(function() -- line: 919
				-- upvalues: SideContainer (copy), v97 (copy), updateEquips (copy)
				SideContainer.EquipContainer.Equip.Title.Text = not v97 and "Equipped" or "Not your decision."
				updateEquips()
			end)
		end
	end

	for _, child in pairs(Topbar:GetChildren()) do
		if child:IsA("ImageButton") then
			child.MouseButton1Click:Connect(function() -- line: 929
				-- upvalues: t1 (copy), child (copy), updateEquips (copy)
				t1:SwitchTab(child.Name)
				updateEquips(true)
			end)
		end
	end

	Searchbar.TextBox:GetPropertyChangedSignal("Text"):Connect(function() -- line: 937
		-- upvalues: InventoryContainer (copy), Searchbar (copy)
		for _, child in pairs(InventoryContainer.Contents:GetChildren()) do
			if child:IsA("Frame") then
				local ContainerTitle = child.Container.Title

				child.Visible = Searchbar.TextBox.Text == "" or string.find(ContainerTitle.Text:lower(), Searchbar.TextBox.Text:lower())
			end
		end
	end)
	workspace:GetAttributeChangedSignal("ServerType"):Connect(giveDevKillers)
	LocalPlayer:GetAttributeChangedSignal("VIP"):Connect(giveDevKillers)
	giveDevKillers()
end

return t1
