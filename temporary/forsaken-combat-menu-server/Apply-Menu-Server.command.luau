local function find(path)
 local object=game
 for part in path:gmatch("[^/]+")do object=object and object:FindFirstChild(part)end
 return object
end
local function fingerprint(source)
 local a,b=5381,0
 for i=1,#source do local v=source:byte(i);a=(a*33+v)%4294967296;b=(b*65599+v)%4294967296 end
 return string.format("%d:%08x:%08x",#source,a,b)
end
assert(game:GetService("RunService"):IsStudio()and not game:GetService("RunService"):IsRunning(),"Stop Play first.")
local storage=game:GetService("ServerStorage")
local backendPath="ServerScriptService/Server/Systems/Shopping/CombatMenuBackend"
local existing=find(backendPath)
if existing then assert(existing:GetAttribute("Version")=="1.0.0","Unknown CombatMenuBackend. Nothing changed.");print("[Menu backend] Already installed.");return end
local changes={
{path=[========[
ReplicatedStorage/Systems/Player/UI/Menus/Inventory]========],expected=[========[
36183:f020c552:0823004b]========],after=[========[
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
]========]},
{path=[========[
ReplicatedStorage/Systems/Player/UI/Menus/Inventory/Tabs/Killers]========],expected=[========[
9422:0230cf4a:1542cba5]========],after=[========[
local t1 = {}
local DataHandler = require(game.ReplicatedStorage.Modules.DataHandler)
local Util = require(game.ReplicatedStorage.Modules.Util)
local Signal = require(game.ReplicatedStorage.Modules.Misc.Signal)
local Network = require(game.ReplicatedStorage.Modules.Network)
local u6 = nil
local u7 = false

function t1.CreateTab(p1, p2) -- line: 14
	-- upvalues: u7 (ref), u6 (ref), Signal (copy), DataHandler (copy), Network (copy), Util (copy)
	if u7 then
		return u6
	end

	u7 = true

	local CardTemplate = script.Parent.Parent.Templates.CardTemplate
	local SideContainer = p2.InventoryRoot.SideContainer
	local t2 = {}
	local t3 = {}
	local v14 = Signal.new()
	local _ = game.Players.LocalPlayer
	local v16 = DataHandler:Get()
	local Killers = v16.Purchased.Killers
	local Killer = v16.Equipped.Killer
	local DisplayExtraLevel = v16.Settings.Customization.DisplayExtraLevel
	
	local Killers2 = v16:WaitForChild("Favorites"):WaitForChild("Killers")
	local CardOrder = p1.Inventory:GetCardOrder(game.ReplicatedStorage.Assets.Killers:GetChildren())
	local clone = CardTemplate:Clone()
	local Container = clone.Container

	clone.Name = "Randomized"
	clone:SetAttribute("EquipSlot", "Killer")
	clone.LayoutOrder = -2147483648
	Container.CharacterRender.Image = "rbxassetid://87788475665792"
	Container.CharacterRender.BackgroundTransparency = 0
	Container.CharacterRender.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	Container.CharacterRender.ImageColor3 = Color3.fromRGB(255, 255, 255)
	Container.Title.Text = "Randomized"
	table.insert(t2, clone)
	t3.Randomized = clone
	Container.MouseEnter:Connect(function() -- line: 50
		-- upvalues: Container (copy)
		game.TweenService:Create(Container, TweenInfo.new(0.25), {
			Size = UDim2.fromScale(1.05, 1.05)
		}):Play()
	end)
	Container.MouseLeave:Connect(function() -- line: 54
		-- upvalues: Container (copy)
		game.TweenService:Create(Container, TweenInfo.new(0.25), {
			Size = UDim2.fromScale(1, 1)
		}):Play()
	end)
	Container.Interact.MouseButton1Click:Connect(function() -- line: 58
		-- upvalues: Container (copy), Network (copy)
		if Container.Equipped.ImageTransparency <= 0.5 then
			return
		end

		Network:FireServerConnection("EquipState", "REMOTE_EVENT", "RandomizedCharacter/Killer", true)
	end)

	local function createCard(p3, p4) -- line: 65
		-- upvalues: CardTemplate (copy), CardOrder (copy), DataHandler (copy), Util (copy), SideContainer (copy), DisplayExtraLevel (copy), Killer (copy), p1 (copy), Killers2 (copy), Network (copy), v14 (copy), t2 (copy), t3 (copy)
		if not p3 then
			return
		end

		local Config = require(p3.Config)

		if not p4 and Config.Exclusive then
			return
		end

		local clone2 = CardTemplate:Clone()
		local Container2 = clone2.Container

		clone2.Name = p3.Name
		clone2.LayoutOrder = CardOrder(p3)
		Container2.CharacterRender.Image = Config.RenderImage or "rbxassetid://13373279056"
		Container2.Title.Text = tostring(Config.DisplayName)
		Container2.Price.Text = not p4 and (Config.DisplayPrice ~= false and `${ Config.Price }`) or ""
		Container2.Title.TextColor3 = Color3.fromRGB(255, 200, 200)
		Container2.CharacterRender.ImageTransparency = p4 ~= nil and 0 or 0.5
		Container2.LockImage.Visible = p4 == nil

		local v34 = typeof((DataHandler:ReadPath(`Purchased/Killers/{ p3.Name }`))) ~= "Instance"
		local u35 = Config.Locked and v34

		if u35 then
			Container2.LockImage.Visible = true
			Container2.CharacterRender.ImageTransparency = 0.5

			local u36 = nil

			u36 = Container2.ChildAdded:Connect(function(child) -- line: 91
				-- upvalues: u36 (ref), u35 (ref), Container2 (copy), Util (copy)
				if child.Name == "Purchased" then
					u36:Disconnect()
					u36 = nil
					u35 = false
					Container2.LockImage.Visible = false
					Container2.CharacterRender.ImageTransparency = 0
					Util:CreateTooltip()
				end
			end)
		end

		Container2.MouseEnter:Connect(function() -- line: 105
			-- upvalues: u35 (ref), Util (copy), Config (copy), Container2 (copy)
			if u35 then
				Util:CreateTooltip(Config.LockedText)

				return
			end

			game.TweenService:Create(Container2, TweenInfo.new(0.25), {
				Size = UDim2.fromScale(1.05, 1.05)
			}):Play()
		end)
		Container2.MouseLeave:Connect(function() -- line: 114
			-- upvalues: u35 (ref), Util (copy), Container2 (copy)
			if u35 then
				Util:CreateTooltip()

				return
			end

			game.TweenService:Create(Container2, TweenInfo.new(0.25), {
				Size = UDim2.fromScale(1, 1)
			}):Play()
		end)

		local function __changeLevelDisplay() -- line: 123
			-- upvalues: p4 (ref), SideContainer (copy), DisplayExtraLevel (copy), Killer (copy), p3 (copy), Config (copy)
			if not p4 then
				return
			end

			SideContainer.PreviewContainer.Quote.Visible = false
			SideContainer.PreviewContainer.Credits.Visible = false
			SideContainer.EquipContainer.Purchase.Visible = false
			SideContainer.EquipContainer.Price.Visible = false
			SideContainer.PreviewContainer.Level.Visible = true
			SideContainer.PreviewContainer.EXPBar.Visible = true
			SideContainer.PreviewContainer.EXP.Visible = true
			SideContainer.EquipContainer.Equip.Visible = true

			local v44, v45, v46 = require(game.ReplicatedStorage.Modules.Util):CalculateLevelFromEXP(p4.Value)
			local v47 = v44 > 100 and `MAX LEVEL{ DisplayExtraLevel.Value and ` (+{ math.floor(v44 - 100) })` or "" }` or if v44 ~= 100 then `{ v45 }/{ v46 } EXP` else "MAX LEVEL"
			local v48 = v44 < 100
			local v49 = v45 / math.max(1, v46)
			local v50 = if v49 ~= 0 then 1 / v49 else 0

			SideContainer.PreviewContainer.EXPBar.Visible = v48
			SideContainer.PreviewContainer.EXPBar.Clipping.Size = UDim2.fromScale(v49, 1)
			SideContainer.PreviewContainer.EXPBar.Clipping.Top.Size = UDim2.fromScale(v50, 1)
			SideContainer.EquipContainer.Equip.Title.Text = Killer.Value ~= p3.Name and "Equip" or "Equipped"
			SideContainer.PreviewContainer.Title.Text = tostring(Config.DisplayName)
			SideContainer.PreviewContainer.Level.Text = `Level { math.min(v44, 100) }`
			SideContainer.PreviewContainer.EXP.Text = v47
			SideContainer.PreviewContainer.Render.Image = Config.SquareRenderImage or (Config.RenderImage or "rbxassetid://13373279056")
		end
		local function __changeDisplayInfo() -- line: 159
			-- upvalues: SideContainer (copy), Config (copy)
			SideContainer.PreviewContainer.Quote.Visible = true
			SideContainer.PreviewContainer.Credits.Visible = true
			SideContainer.PreviewContainer.Level.Visible = false
			SideContainer.PreviewContainer.EXPBar.Visible = false
			SideContainer.PreviewContainer.EXP.Visible = false
			SideContainer.EquipContainer.Equip.Visible = false
			SideContainer.PreviewContainer.Title.Text = tostring(Config.DisplayName)
			SideContainer.PreviewContainer.Quote.Text = tostring(Config.Quote)
			SideContainer.PreviewContainer.Credits.Text = tostring(Config.Credits)
			SideContainer.PreviewContainer.Render.Image = Config.SquareRenderImage or (Config.RenderImage or "rbxassetid://13373279056")

			if Config.DisplayPrice == false then
				SideContainer.EquipContainer.Price.Visible = false
			else
				SideContainer.EquipContainer.Price.Visible = true
				SideContainer.EquipContainer.Purchase.Visible = true
				SideContainer.EquipContainer.Price.Text = `${ Config.Price }`
			end

			SideContainer.Visible = true
		end

		DisplayExtraLevel.Changed:Connect(function() -- line: 184
			-- upvalues: p1 (copy), p3 (copy), __changeLevelDisplay (copy)
			if p1.Inventory.CurrentlySelected ~= p3 then
				return
			end

			__changeLevelDisplay()
		end)
		Container2.Interact.MouseButton1Click:Connect(function() -- line: 192
			-- upvalues: u35 (ref), Container2 (copy), p1 (copy), p3 (copy), p4 (ref), __changeLevelDisplay (copy), __changeDisplayInfo (copy), SideContainer (copy)
			if u35 then
				Container2.LockImage.ImageColor3 = Color3.fromRGB(205, 0, 0)
				game.TweenService:Create(Container2.LockImage, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
					ImageColor3 = Color3.fromRGB(255, 255, 255)
				}):Play()

				return
			end

			p1.Inventory.CurrentlySelected = p3

			if p4 then
				__changeLevelDisplay()
			else
				__changeDisplayInfo()
			end

			SideContainer.EquipContainer.Buttons.Visible = true
			SideContainer.Visible = true
			game.TweenService:Create(SideContainer, TweenInfo.new(0.4), {
				Size = UDim2.fromScale(0.3, 1)
			}):Play()
		end)

		local function setupFavoriteStar() -- line: 218
			-- upvalues: p4 (ref), Killers2 (copy), p3 (copy), p1 (copy), clone2 (copy), CardOrder (copy), Network (copy)
			if not p4 or p4:GetAttribute("Temp") then
				return
			end

			local v51 = Killers2:FindFirstChild(p3.Name) ~= nil

			p1.Inventory:SetupFavoriteStar(clone2, v51, CardOrder(p3), function(p5) -- line: 224
				-- upvalues: Network (copy), p3 (copy)
				Network:FireServerConnection("FavoriteCharacter", "REMOTE_EVENT", "Killers", p3.Name, p5)
			end)
		end


		v14:Connect(function(p6) -- line: 229
			-- upvalues: p3 (copy), p4 (ref), __changeLevelDisplay (copy), setupFavoriteStar (copy)
			if p3.Name ~= p6.Name then
				return
			end

			local v53 = p4 ~= nil

			p4 = p6
			__changeLevelDisplay()

			if not v53 then
				setupFavoriteStar()
			end
		end)
		table.insert(t2, clone2)
		t3[p3.Name] = Container2
		setupFavoriteStar()
	end

	local Killers3 = game.ReplicatedStorage.Assets.Killers

	Killers.ChildAdded:Connect(function(child) -- line: 248
		-- upvalues: t3 (copy), Killers3 (copy), createCard (copy), Killers (copy), v14 (copy)
		local v41 = t3[child.Name]
		local childName = Killers3:FindFirstChild(child.Name)

		if not v41 and childName then
			createCard(childName, Killers:FindFirstChild(childName.Name))

			return
		end

		v41.Price.Text = ""
		v41.Title.TextColor3 = Color3.fromRGB(200, 200, 255)
		v41.CharacterRender.ImageTransparency = 0
		v41.LockImage.Visible = false
		v14:Fire(child)
	end)

	for _, child in pairs(Killers3:GetChildren()) do
		createCard(child, Killers:FindFirstChild(child.Name))
	end

	u6 = t2

	return t2
end

return t1
]========]},
{path=[========[
ReplicatedStorage/Systems/Player/UI/Menus/Inventory/Tabs/Survivors]========],expected=[========[
9464:bd5798db:c2cb7c80]========],after=[========[
local t1 = {}
local DataHandler = require(game.ReplicatedStorage.Modules.DataHandler)
local Util = require(game.ReplicatedStorage.Modules.Util)
local Signal = require(game.ReplicatedStorage.Modules.Misc.Signal)
local Network = require(game.ReplicatedStorage.Modules.Network)
local u6 = nil
local u7 = false

function t1.CreateTab(p1, p2) -- line: 14
	-- upvalues: u7 (ref), u6 (ref), Signal (copy), DataHandler (copy), Network (copy), Util (copy)
	if u7 then
		return u6
	end

	u7 = true

	local CardTemplate = script.Parent.Parent.Templates.CardTemplate
	local SideContainer = p2.InventoryRoot.SideContainer
	local t2 = {}
	local t3 = {}
	local v14 = Signal.new()
	local _ = game.Players.LocalPlayer
	local v16 = DataHandler:Get()
	local Survivors = v16.Purchased.Survivors
	local Survivor = v16.Equipped.Survivor
	local DisplayExtraLevel = v16.Settings.Customization.DisplayExtraLevel
	
	local Survivors2 = v16:WaitForChild("Favorites"):WaitForChild("Survivors")
	local CardOrder = p1.Inventory:GetCardOrder(game.ReplicatedStorage.Assets.Survivors:GetChildren())
	local clone = CardTemplate:Clone()
	local Container = clone.Container

	clone.Name = "Randomized"
	clone:SetAttribute("EquipSlot", "Survivor")
	clone.LayoutOrder = -2147483648
	Container.CharacterRender.Image = "rbxassetid://71383130474277"
	Container.CharacterRender.BackgroundTransparency = 0
	Container.CharacterRender.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	Container.CharacterRender.ImageColor3 = Color3.fromRGB(255, 255, 255)
	Container.Title.Text = "Randomized"
	table.insert(t2, clone)
	t3.Randomized = clone
	Container.MouseEnter:Connect(function() -- line: 50
		-- upvalues: Container (copy)
		game.TweenService:Create(Container, TweenInfo.new(0.25), {
			Size = UDim2.fromScale(1.05, 1.05)
		}):Play()
	end)
	Container.MouseLeave:Connect(function() -- line: 54
		-- upvalues: Container (copy)
		game.TweenService:Create(Container, TweenInfo.new(0.25), {
			Size = UDim2.fromScale(1, 1)
		}):Play()
	end)
	Container.Interact.MouseButton1Click:Connect(function() -- line: 58
		-- upvalues: Container (copy), Network (copy)
		if Container.Equipped.ImageTransparency <= 0.5 then
			return
		end

		Network:FireServerConnection("EquipState", "REMOTE_EVENT", "RandomizedCharacter/Survivor", true)
	end)

	local function createCard(p3, p4) -- line: 65
		-- upvalues: CardTemplate (copy), CardOrder (copy), DataHandler (copy), Util (copy), SideContainer (copy), DisplayExtraLevel (copy), Survivor (copy), p1 (copy), Survivors2 (copy), Network (copy), v14 (copy), t2 (copy), t3 (copy)
		if not p3 then
			return
		end

		local Config = require(p3.Config)

		if not p4 and Config.Exclusive then
			return
		end

		local clone2 = CardTemplate:Clone()
		local Container2 = clone2.Container

		clone2.Name = p3.Name
		clone2.LayoutOrder = CardOrder(p3)
		Container2.CharacterRender.Image = Config.RenderImage or "rbxassetid://13373279056"
		Container2.Title.Text = tostring(Config.DisplayName)
		Container2.Price.Text = not p4 and (Config.DisplayPrice ~= false and `${ Config.Price }`) or ""
		Container2.Title.TextColor3 = Color3.fromRGB(200, 200, 255)
		Container2.CharacterRender.ImageTransparency = p4 ~= nil and 0 or 0.5
		Container2.LockImage.Visible = p4 == nil

		local v34 = typeof((DataHandler:ReadPath(`Purchased/Survivors/{ p3.Name }`))) ~= "Instance"
		local u35 = Config.Locked and v34

		if u35 then
			Container2.LockImage.Visible = true
			Container2.CharacterRender.ImageTransparency = 0.5

			local u36 = nil

			u36 = Container2.ChildAdded:Connect(function(child) -- line: 91
				-- upvalues: u36 (ref), u35 (ref), Container2 (copy), Util (copy)
				if child.Name == "Purchased" then
					u36:Disconnect()
					u36 = nil
					u35 = false
					Container2.LockImage.Visible = false
					Container2.CharacterRender.ImageTransparency = 0
					Util:CreateTooltip()
				end
			end)
		end

		Container2.MouseEnter:Connect(function() -- line: 105
			-- upvalues: u35 (ref), Util (copy), Config (copy), Container2 (copy)
			if u35 then
				Util:CreateTooltip(Config.LockedText)

				return
			end

			game.TweenService:Create(Container2, TweenInfo.new(0.25), {
				Size = UDim2.fromScale(1.05, 1.05)
			}):Play()
		end)
		Container2.MouseLeave:Connect(function() -- line: 114
			-- upvalues: u35 (ref), Util (copy), Container2 (copy)
			if u35 then
				Util:CreateTooltip()

				return
			end

			game.TweenService:Create(Container2, TweenInfo.new(0.25), {
				Size = UDim2.fromScale(1, 1)
			}):Play()
		end)

		local function __changeLevelDisplay() -- line: 123
			-- upvalues: p4 (ref), SideContainer (copy), DisplayExtraLevel (copy), Survivor (copy), p3 (copy), Config (copy)
			if not p4 then
				return
			end

			SideContainer.PreviewContainer.Quote.Visible = false
			SideContainer.PreviewContainer.Credits.Visible = false
			SideContainer.EquipContainer.Purchase.Visible = false
			SideContainer.EquipContainer.Price.Visible = false
			SideContainer.PreviewContainer.Level.Visible = true
			SideContainer.PreviewContainer.EXPBar.Visible = true
			SideContainer.PreviewContainer.EXP.Visible = true
			SideContainer.EquipContainer.Equip.Visible = true

			local v44, v45, v46 = require(game.ReplicatedStorage.Modules.Util):CalculateLevelFromEXP(p4.Value)
			local v47 = v44 > 100 and `MAX LEVEL{ DisplayExtraLevel.Value and ` (+{ math.floor(v44 - 100) })` or "" }` or if v44 ~= 100 then `{ v45 }/{ v46 } EXP` else "MAX LEVEL"
			local v48 = v44 < 100
			local v49 = v45 / math.max(1, v46)
			local v50 = if v49 ~= 0 then 1 / v49 else 0

			SideContainer.PreviewContainer.EXPBar.Visible = v48
			SideContainer.PreviewContainer.EXPBar.Clipping.Size = UDim2.fromScale(v49, 1)
			SideContainer.PreviewContainer.EXPBar.Clipping.Top.Size = UDim2.fromScale(v50, 1)
			SideContainer.EquipContainer.Equip.Title.Text = Survivor.Value ~= p3.Name and "Equip" or "Equipped"
			SideContainer.PreviewContainer.Title.Text = tostring(Config.DisplayName)
			SideContainer.PreviewContainer.Level.Text = `Level { math.min(v44, 100) }`
			SideContainer.PreviewContainer.EXP.Text = v47
			SideContainer.PreviewContainer.Render.Image = Config.SquareRenderImage or (Config.RenderImage or "rbxassetid://13373279056")
		end
		local function __changeDisplayInfo() -- line: 159
			-- upvalues: SideContainer (copy), Config (copy)
			SideContainer.PreviewContainer.Quote.Visible = true
			SideContainer.PreviewContainer.Credits.Visible = true
			SideContainer.PreviewContainer.Level.Visible = false
			SideContainer.PreviewContainer.EXPBar.Visible = false
			SideContainer.PreviewContainer.EXP.Visible = false
			SideContainer.EquipContainer.Equip.Visible = false
			SideContainer.PreviewContainer.Title.Text = tostring(Config.DisplayName)
			SideContainer.PreviewContainer.Quote.Text = tostring(Config.Quote)
			SideContainer.PreviewContainer.Credits.Text = tostring(Config.Credits)
			SideContainer.PreviewContainer.Render.Image = Config.SquareRenderImage or (Config.RenderImage or "rbxassetid://13373279056")

			if Config.DisplayPrice == false then
				SideContainer.EquipContainer.Price.Visible = false
			else
				SideContainer.EquipContainer.Price.Visible = true
				SideContainer.EquipContainer.Purchase.Visible = true
				SideContainer.EquipContainer.Price.Text = `${ Config.Price }`
			end

			SideContainer.Visible = true
		end

		DisplayExtraLevel.Changed:Connect(function() -- line: 184
			-- upvalues: p1 (copy), p3 (copy), __changeLevelDisplay (copy)
			if p1.Inventory.CurrentlySelected ~= p3 then
				return
			end

			__changeLevelDisplay()
		end)
		Container2.Interact.MouseButton1Click:Connect(function() -- line: 192
			-- upvalues: u35 (ref), Container2 (copy), p1 (copy), p3 (copy), p4 (ref), __changeLevelDisplay (copy), __changeDisplayInfo (copy), SideContainer (copy)
			if u35 then
				Container2.LockImage.ImageColor3 = Color3.fromRGB(205, 0, 0)
				game.TweenService:Create(Container2.LockImage, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
					ImageColor3 = Color3.fromRGB(255, 255, 255)
				}):Play()

				return
			end

			p1.Inventory.CurrentlySelected = p3

			if p4 then
				__changeLevelDisplay()
			else
				__changeDisplayInfo()
			end

			SideContainer.EquipContainer.Buttons.Visible = true
			SideContainer.Visible = true
			game.TweenService:Create(SideContainer, TweenInfo.new(0.4), {
				Size = UDim2.fromScale(0.3, 1)
			}):Play()
		end)

		local function setupFavoriteStar() -- line: 218
			-- upvalues: p4 (ref), Survivors2 (copy), p3 (copy), p1 (copy), clone2 (copy), CardOrder (copy), Network (copy)
			if not p4 or p4:GetAttribute("Temp") then
				return
			end

			local v51 = Survivors2:FindFirstChild(p3.Name) ~= nil

			p1.Inventory:SetupFavoriteStar(clone2, v51, CardOrder(p3), function(p5) -- line: 224
				-- upvalues: Network (copy), p3 (copy)
				Network:FireServerConnection("FavoriteCharacter", "REMOTE_EVENT", "Survivors", p3.Name, p5)
			end)
		end


		v14:Connect(function(p6) -- line: 229
			-- upvalues: p3 (copy), p4 (ref), __changeLevelDisplay (copy), setupFavoriteStar (copy)
			if p3.Name ~= p6.Name then
				return
			end

			local v53 = p4 ~= nil

			p4 = p6
			__changeLevelDisplay()

			if not v53 then
				setupFavoriteStar()
			end
		end)
		table.insert(t2, clone2)
		t3[p3.Name] = Container2
		setupFavoriteStar()
	end

	local Survivors3 = game.ReplicatedStorage.Assets.Survivors

	Survivors.ChildAdded:Connect(function(child) -- line: 248
		-- upvalues: t3 (copy), Survivors3 (copy), createCard (copy), Survivors (copy), v14 (copy)
		local v41 = t3[child.Name]
		local childName = Survivors3:FindFirstChild(child.Name)

		if not v41 and childName then
			createCard(childName, Survivors:FindFirstChild(childName.Name))

			return
		end

		v41.Price.Text = ""
		v41.Title.TextColor3 = Color3.fromRGB(200, 200, 255)
		v41.CharacterRender.ImageTransparency = 0
		v41.LockImage.Visible = false
		v14:Fire(child)
	end)

	for _, child in pairs(Survivors3:GetChildren()) do
		createCard(child, Survivors:FindFirstChild(child.Name))
	end

	u6 = t2

	return t2
end

return t1
]========]},
{path=[========[
ServerScriptService/Server/Systems/Data/PlayerData]========],expected=[========[
8112:7c85534d:049f96d2]========],after=[========[
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

return module]========]},
{path=[========[
ReplicatedStorage/Systems/Player/UI/Menus/Shop/Classes/RigBuilder]========],expected=[========[
8455:5b6718af:e9b193de]========],after=[========[
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Util = require(game.ReplicatedStorage.Modules.Util)

return {
	ResolveSkin = function(p1) -- line: 9
		-- upvalues: ReplicatedStorage (copy)
		local v4 = p1:IsA("ModuleScript") and p1.Parent or p1

		if not v4 then
			return nil
		end

		local Parent = v4.Parent
		local v6 = Parent and Parent.Parent

		if not Parent or not v6 then
			return nil
		end

		local v7 = v6.Name:gsub("s$", "")
		local v8 = ReplicatedStorage.Assets:FindFirstChild(v7 .. "s")

		return {
			ActorFolder = v8 and v8:FindFirstChild(Parent.Name),
			SkinFolder = v4,
			ActorName = Parent.Name,
			SkinName = v4.Name
		}
	end,
	GetMergedBehavior = function(p2) -- line: 33
		-- upvalues: Util (copy)
		local v10 = p2.ActorFolder and p2.ActorFolder:FindFirstChild("Behavior")
		local v11 = v10 and Util:CopyTable(require(v10)) or {}
		local Behavior = p2.SkinFolder:FindFirstChild("Behavior")
		local v13 = Behavior and require(Behavior)

		if v13 then
			v11 = Util:MergeTables(v11, v13)
		end

		return v11
	end,
	ApplyLifeAppearance = function(p3, p4) -- line: 47
		for _, descendant in p3:GetDescendants() do
			if (descendant:IsA("BasePart") or descendant:IsA("Decal")) and descendant.Name ~= "Expression" and descendant.Name ~= "CollisionHitbox" and descendant.Name ~= "QueryHitbox" then
				descendant.Transparency = 1
			end
		end

		local clone = p4:Clone()

		for _, descendant in clone:GetDescendants() do
			if descendant:IsA("BasePart") then
				descendant.CollisionGroup = "Survivors"
				descendant.CanCollide = false
				descendant.CanTouch = false
				descendant.CanQuery = false
				descendant.Massless = true
			end
		end

		for _, child in clone:GetChildren() do
			local childName = p3:FindFirstChild(child.Name)

			if childName then
				if child:IsA("Humanoid") then
					child.EvaluateStateMachine = false
				elseif childName:IsA("BasePart") and child:IsA("BasePart") then
					child.Anchored = false
					child.CanCollide = false
					child.CFrame = childName.CFrame

					local WeldConstraint = Instance.new("WeldConstraint")

					WeldConstraint.Part0 = childName
					WeldConstraint.Part1 = child
					WeldConstraint.Parent = child
				end
			end
		end

		clone.Parent = p3

		return clone
	end,
	GetRig = function(p5, p6, p7) -- line: 97
		if p7 and p7.GetRig then
			local t1 = {
				Folder = p5.ActorFolder,
				SkinFolder = p5.SkinFolder,
				ActorName = p5.ActorName,
				ActorSkin = p5.SkinName,
				Config = p6,
				Behavior = p7
			}
			local ok, result = pcall(p7.GetRig, p7, t1)

			if ok and result and typeof(result) == "Instance" and result:IsA("Model") then
				if result.Parent then
					result = result:Clone()
				end

				return result, nil
			end
		end

		local clone = nil
		local Rig = p5.SkinFolder:FindFirstChild("Rig")

		if Rig and Rig:IsA("Model") then
			clone = Rig:Clone()
		elseif p5.ActorFolder and not p5.SkinFolder:FindFirstChild("Config") then
			local Rig2 = p5.ActorFolder:FindFirstChild("Rig")

			if Rig2 and Rig2:IsA("Model") then
				clone = Rig2:Clone()
			end
		end

        if not clone and p5.SkinFolder and p5.ActorFolder then
            local Network=require(ReplicatedStorage.Modules.Network)
            local ok,result=pcall(function()
                return Network:FireServerConnection("RequestPreviewRig","REMOTE_FUNCTION",p5.SkinFolder,p5.ActorFolder)
            end)
            if ok and typeof(result)=="Instance" and result:IsA("Model") then
                local expected=result:GetAttribute("PreviewDescendants") or 0
                local deadline=os.clock()+5
                while result.Parent and #result:GetDescendants()<expected and os.clock()<deadline do task.wait()end
                if result.Parent and #result:GetDescendants()>=expected then clone=result:Clone()end
                result:Destroy()
            end
        end
        if not clone and p5.ActorFolder then
            local base=p5.ActorFolder:FindFirstChild("Rig")
            if base and base:IsA("Model")then clone=base:Clone()end
        end
		if clone and p6.LifeAppearances and p6.LifeAppearances[1] then
			local v34 = p6.LifeAppearances[1]

			if v34:IsA("Folder") then
				v34 = v34:GetChildren()[1]
			end

			if v34 and v34:IsA("Model") then
				return clone, v34
			end
		end

		return clone, nil
	end,
	GetMergedConfig = function(p8) -- line: 142
		-- upvalues: Util (copy)
		local v36 = p8.ActorFolder and p8.ActorFolder:FindFirstChild("Config")
		local v37 = v36 and Util:CopyTable(require(v36)) or {}
		local Config = p8.SkinFolder:FindFirstChild("Config")
		local v39 = Config and require(Config)

		if v39 then
			v37 = Util:MergeTables(v37, v39, {
				"DisplayName",
				"TextInteractions"
			})
		end

		return v37
	end,
	SanitizeRig = function(p9) -- line: 156
		for _, descendant in p9:GetDescendants() do
			if descendant:IsA("BaseScript") then
				descendant:Destroy()
			end
		end

		local Pants = p9:FindFirstChildOfClass("Pants")

		if Pants and Pants.PantsTemplate == "" then
			Pants.PantsTemplate = Pants:GetAttribute("ID") or ""
		end

		local Shirt = p9:FindFirstChildOfClass("Shirt")

		if Shirt and Shirt.ShirtTemplate == "" then
			Shirt.ShirtTemplate = Shirt:GetAttribute("ID") or ""
		end

		local ShirtGraphic = p9:FindFirstChildOfClass("ShirtGraphic")

		if ShirtGraphic then
			ShirtGraphic.Graphic = ShirtGraphic:GetAttribute("ID") or ShirtGraphic.Graphic
		end
	end,
	ApplyExpression = function(p10, p11) -- line: 179
		-- upvalues: ReplicatedStorage (copy)
		local v48 = p11[`Expressions{ p10.Name }`] or p11.Expressions

		if not v48 then
			return
		end

		local Head = p10:FindFirstChild("Head")

		if not Head or Head:FindFirstChild("face") then
			return
		end

		local ExpressionHolder = p10:FindFirstChild("ExpressionHolder", true)

		if not ExpressionHolder then
			ExpressionHolder = ReplicatedStorage.Assets.Instances.ExpressionHolder:Clone()
			ExpressionHolder.Parent = p10
			ExpressionHolder.CFrame = Head.CFrame * CFrame.new(0, 0, -0.005)

			local WeldConstraint = Instance.new("WeldConstraint")

			WeldConstraint.Part0 = Head
			WeldConstraint.Part1 = ExpressionHolder
			WeldConstraint.Parent = ExpressionHolder
		end

		local v52 = ExpressionHolder:FindFirstChildOfClass("Decal") or Instance.new("Decal")

		v52.Name = "Expression"
		v52.Parent = ExpressionHolder
		v52.Texture = v48.Default or ""
	end,
	PlayIdleAnimation = function(p12, p13) -- line: 209
		-- upvalues: Util (copy)
		local Humanoid = p12:FindFirstChildOfClass("Humanoid")

		if not Humanoid then
			Humanoid = Instance.new("Humanoid")
			Humanoid.Parent = p12
		end;

		(Humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator")).Parent = Humanoid

		local v56 = p13.Animations and p13.Animations.Idle or "rbxassetid://130854198026585"

		if not v56 then
			return nil
		end

		local v57 = Util:LoadAnimationFromID(p12, v56)

		if v57 then
			v57.Looped = true
			v57.Priority = Enum.AnimationPriority.Idle
			v57:Play(0)
		end

		return v57
	end,
	GetVisibleBoundingBox = function(p14) -- line: 234
		local v59 = p14:FindFirstChild("HumanoidRootPart") or p14.PrimaryPart
		local Position

		if v59 then
			Position = v59.Position
		else
			local vector3 = Vector3.new(0, 0, 0)
			local n1 = 0

			for _, descendant in p14:GetDescendants() do
				if descendant:IsA("BasePart") and descendant.Transparency < 1 and not descendant:GetAttribute("Hitbox") then
					vector3 += descendant.Position
					n1 += 1
				end
			end

			Position = n1 > 0 and vector3 / n1 or Vector3.new(0, 0, 0)
		end

		local t2 = {}

		for _, descendant in p14:GetDescendants() do
			if descendant:IsA("BasePart") and not (descendant.Transparency >= 1) and not descendant:GetAttribute("Hitbox") then
				local Magnitude = (descendant.Position - Position).Magnitude

				table.insert(t2, {
					part = descendant,
					distance = Magnitude
				})
			end
		end

		if #t2 == 0 then
			return p14:GetBoundingBox()
		end

		table.sort(t2, function(p15, p16) -- line: 265
			return p15.distance < p16.distance
		end)

		local n2 = 1e999

		for i = 2, #t2 do
			local distance = t2[i - 1].distance
			local v72 = t2[i].distance - distance

			if distance >= 8 and v72 > distance * 1.5 then
				n2 = distance

				break
			end
		end

		if n2 == 1e999 then
			n2 = math.max(t2[math.ceil(#t2 / 2)].distance * 3, 8)
		end

		local v73 = math.min(n2, 20)
		local n3 = 1e999
		local n4 = 1e999
		local n5 = 1e999
		local n6 = -1e999
		local n7 = -1e999
		local n8 = -1e999
		local v80 = false

		for _, v82 in t2 do
			if not (v73 < v82.distance) then
				local part = v82.part
				local partCFrame = part.CFrame
				local partSize = part.Size

				for i = -1, 1, 2 do
					for j = -1, 1, 2 do
						for k = -1, 1, 2 do
							local v89 = partCFrame * Vector3.new(i * partSize.X / 2, j * partSize.Y / 2, k * partSize.Z / 2)

							if n3 > v89.X then
								n3 = v89.X
							end

							if n4 > v89.Y then
								n4 = v89.Y
							end

							if n5 > v89.Z then
								n5 = v89.Z
							end

							if n6 < v89.X then
								n6 = v89.X
							end

							if n7 < v89.Y then
								n7 = v89.Y
							end

							if n8 < v89.Z then
								n8 = v89.Z
							end
						end
					end
				end

				v80 = true
			end
		end

		if not v80 then
			return p14:GetBoundingBox()
		end

		local vector3 = Vector3.new((n3 + n6) / 2, (n4 + n7) / 2, (n5 + n8) / 2)
		local vector3_2 = Vector3.new(n6 - n3, n7 - n4, n8 - n5)

		return CFrame.new(vector3), vector3_2
	end
}

]========]},
{path=[========[
ServerScriptService/Server/Systems/Shopping/AssetSystems]========],expected=[========[
8231:017a4fe0:22f278fd]========],after=[========[
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

return module]========]},
{path=[========[
ReplicatedStorage/Modules/Actors]========],expected=[========[
33124:3effcbb1:076c8cbc]========],after=[========[
local AnalyticsService = game:GetService("AnalyticsService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Actors = {
	ActorAdded = nil,
	CurrentActors = {}
}

RunService:IsClient()

local v6 = RunService:IsServer()
local v7 = workspace:GetAttribute("ServerType") == "VIP"
local DataHandler = require(ReplicatedStorage.Modules.DataHandler)
local Network = require(ReplicatedStorage.Modules.Network)
local Sounds = require(ReplicatedStorage.Modules.Sounds)
local Util = require(ReplicatedStorage.Modules.Util)
local Ragdolls = require(ReplicatedStorage.Modules.Ragdolls)
local CharacterReplication = require(ReplicatedStorage.Systems.Player.Game.CharacterReplication)
local Signal = require(ReplicatedStorage.Modules.Misc.Signal)
local Janitor = require(ReplicatedStorage.Modules.Misc.Janitor)
local t2 = {
	Killer = "Slasher",
	Survivor = "Noob"
}
local t3 = {
	Idle = "rbxassetid://132063305616391",
	Walk = "rbxassetid://117836414993134",
	Run = "rbxassetid://115242555951354",
	InjuredIdle = "rbxassetid://85187709684165",
	InjuredWalk = "rbxassetid://74821406611654",
	InjuredRun = "rbxassetid://72674527126213",
}

function Actors.__len(p1) -- line: 41
	-- upvalues: Actors (copy)
	local n1 = 0

	for _, v in pairs(Actors.CurrentActors) do
		local v21 = v.Rig and v.Rig:FindFirstChild("Humanoid")

		if p1.ActorName == v.ActorName and v21 and v21.Health > 0 then
			n1 += 1
		end
	end

	return n1
end
function Actors.CreateActor(_: {[any]: any}, p2, s1: string, s2: string?, s3: string?) -- line: 52
	-- upvalues: Actors (copy), ReplicatedStorage (copy), v6 (copy), ServerStorage (copy), t2 (copy), Signal (copy), v7 (copy), AnalyticsService (copy), Network (copy), Sounds (copy), CharacterReplication (copy), RunService (copy), Util (copy), Ragdolls (copy)
	if not s2 then
		local v29, v30 = Actors:GetEquippedActorInfo(p2, s1, true)

		s2 = v29
		s3 = v30
	end

	local assetsFolder = ReplicatedStorage.Assets:FindFirstChild(`{s1}s`)
	local actorFolder

	if typeof(s2) == "Instance" and s2:IsA("Folder") then
		actorFolder = s2
	else
		actorFolder = assetsFolder and (assetsFolder:FindFirstChild(s2) or assetsFolder:FindFirstChild(tostring(t2[s1])))
	end

	if actorFolder and p2.Character and p2.Character.PrimaryPart and p2.Character.Humanoid.Health > 0 and not Actors.CurrentActors[p2] then
		local v36 = setmetatable({
			Cache = {},
			Cooldowns = {},
			AbilityDisablers = {}
		}, Actors)

		v36.Player = p2
		v36.Folder = actorFolder
		v36.Signals = {}
		v36.ActorType = s1
		v36.ActorName = s2
		v36.ActorSkin = s3

		if s1 == "Killer" then
			v36.TotalKills = 0
		end

		v36.Signals.AbilityUsed = Signal.new()

		if not v7 then
			if typeof(p2) == "Instance" and p2:IsA("Player") then
				local ok, result = pcall(function() -- line 107
					-- upvalues: AnalyticsService (copy), p2 (copy), s2 (ref), s1 (copy), s3 (ref)
					AnalyticsService:LogCustomEvent(p2, "TrackCreatedCharcter", 1, {
						[Enum.AnalyticsCustomFieldKeys.CustomField01.Name] = `Character - { s2 }`,
						[Enum.AnalyticsCustomFieldKeys.CustomField02.Name] = `Type - { s1 }`,
						[Enum.AnalyticsCustomFieldKeys.CustomField03.Name] = `Skin - { s3 }`
					})
				end)

				if not ok then
					warn(`Failed to log custom event: { result }`)
				end
			end
		end

		Actors:ApplySkinDataToActorInfo(v36)

		function v36.IncrementCharges(_: {[any]: any}, s4: string, n2: number, n3: number) -- line: 129
			-- upvalues: v6 (copy), v36 (copy), Network (copy), p2 (copy)
			if not v6 then
				warn(`attempt to add charges to { tostring(s4) } on client!`)

				return
			end

			local v168 = v36 and (v36.Behavior.Abilities and v36.Behavior.Abilities[s4])

			if not v168 then
				return
			end

			if not v168.CurrentCharges then
				return
			end

			v168.CurrentCharges = math.clamp(v168.CurrentCharges + n2, 0, tonumber(n3) or 1e999)

			local v169 = nil

			if v168.Recharge and v168.CurrentCharges < v168.Charges and not v168.RechargeStartTime then
				v169 = true
				v168.RechargeStartTime = os.clock()
				v168.CurrentRechargeThread = task.delay(v168.Recharge, function() -- line: 147
					-- upvalues: v168 (copy), v36 (copy), s4 (copy)
					v168.CurrentRechargeThread = nil
					v168.RechargeStartTime = nil
					v36:IncrementCharges(s4, 1, v168.Charges)
				end)
			elseif v168.RechargeStartTime and v168.CurrentCharges >= v168.Charges then
				pcall(task.cancel, v168.CurrentRechargeThread)
				v168.CurrentRechargeThread = nil
				v168.RechargeStartTime = nil
				v168.ElapsedRecharge = nil
				v169 = false
			end

			Network:FireClientConnection(p2, "UpdateAbilityCharges", "REMOTE_EVENT", s4, v168.CurrentCharges, v169)
		end
		function v36.AddRecharge(_: {[any]: any}, s5: string, n4: number) -- line: 165
			-- upvalues: v36 (copy), Network (copy), p2 (copy)
			local v173 = v36 and (v36.Behavior.Abilities and v36.Behavior.Abilities[s5])

			if not v173 then
				return
			end

			local Recharge = v173.Recharge
			local RechargeStartTime = v173.RechargeStartTime

			if not Recharge then
				warn(`Attempted to recharge { s5 } which has no recharge time.`)

				return
			end

			if not RechargeStartTime then
				warn(`Attempted to recharge { s5 } which is not currently recharging.`)

				return
			end

			local CurrentCharges = v173.CurrentCharges
			local Charges = v173.Charges
			local v178 = n4 + (v173.RechargeStartTime and os.clock() - v173.RechargeStartTime or 0)
			local v179 = math.floor(v178 / Recharge)

			if Charges <= CurrentCharges + v179 then
				v36:IncrementCharges(s5, Charges, Charges)

				return
			end

			local v180 = v178 % Recharge

			v173.CurrentCharges = math.clamp(v173.CurrentCharges + v179, 0, Charges)

			if v173.CurrentRechargeThread then
				pcall(task.cancel, v173.CurrentRechargeThread)
				v173.CurrentRechargeThread = nil
			end

			v173.RechargeStartTime = os.clock() - v180
			v173.CurrentRechargeThread = task.delay(v173.Recharge - v180, function() -- line: 201
				-- upvalues: v173 (copy), v36 (copy), s5 (copy)
				v173.CurrentRechargeThread = nil
				v173.RechargeStartTime = nil
				v36:IncrementCharges(s5, 1, v173.Charges)
			end)
			Network:FireClientConnection(p2, "UpdateAbilityCharges", "REMOTE_EVENT", s5, v173.CurrentCharges, v180)
		end
		function v36.CanUseAbility(_: {[any]: any}, s6: string) -- line: 211
			-- upvalues: v36 (copy)
			local Player = v36.Player
			local Config = v36.Config
			local v185 = v36 and v36.Behavior
			local v186 = v36 and v36.Cooldowns
			local v187 = v185.Abilities[s6]

			if not Player or (not Config or not v185 or not v186 or not v187) then
				return
			end

			if v186.CANT_ATTACK then
				return
			end

			if v187.CurrentCharges and v187.CurrentCharges <= 0 and not v187.ChargesOptional and not v187.ChargesDisabled and not workspace:GetAttribute("ChargesDisabled") then
				return
			end

			if not workspace:GetAttribute("CooldownsDisabled") then
				if v36.DisabledAbilities and v36.DisabledAbilities[s6] then
					return
				end

				if v36.AbilitiesDisabled then
					return
				end

				if v36:IsOnCooldown(s6) then
					return
				end
			end

			for lockName, locked in pairs(v36.AbilityDisablers) do
				local bypassBlockLock =
					lockName == "GuestReworkBlock"
					and workspace:GetAttribute("CooldownsDisabled")

				if locked and not bypassBlockLock then
					return
				end
			end

			if not Player or not Player.Character then
				return
			end

			if Player.Character:GetAttribute("Ragdolling") then
				return
			end

			if Player.Character:GetAttribute("AbilitiesDisabled") then
				return
			end

			if Player.Character:GetAttribute("UsingAnimations") then
				return
			end

			if Player.Character:FindFirstChildOfClass("Tool") then
				return
			end

			return true
		end
		function v36.CanUseItem(_: {[any]: any}, s7: string) -- line: 241
			-- upvalues: v36 (copy)
			local Player = v36.Player
			local Config = v36.Config
			local v194 = v36 and v36.Behavior
			local v195 = v36 and v36.Cooldowns

			if not Player or (not Config or not v194 or not v195) then
				return
			end

			if v195.CANT_ATTACK then
				return
			end

			if not workspace:GetAttribute("CooldownsDisabled") then
				if v36.DisabledAbilities and v36.DisabledAbilities[s7] then
					return
				end

				if v36.AbilitiesDisabled then
					return
				end
			end

			if v36.AbilityDisablers.ItemsDisabled then
				return
			end

			if not Player or not Player.Character then
				return
			end

			if Player.Character:GetAttribute("Ragdolling") then
				return
			end

			if Player.Character:GetAttribute("AbilitiesDisabled") then
				return
			end

			if Player.Character:GetAttribute("UsingAnimations") then
				return
			end

			return true
		end
		function v36.PlayVoiceline(_, p4, p5) -- line: 264
			-- upvalues: Sounds (copy), v36 (copy)
			Sounds:PlayVoiceline(v36, p4, p5)
		end

		for _, v in pairs(v36.Behavior.Abilities or {}) do
			if v.Charges then
				v.CurrentCharges = v.Charges
			end
		end

		function v36.IsOnCooldown(_, p7) -- line: 276
			-- upvalues: v36 (copy)
			local v201 = v36 and v36.Cooldowns

			if v201[p7] and workspace:GetServerTimeNow() < v201[p7] then
				return v201[p7] - workspace:GetServerTimeNow()
			end

			return false
		end
		function v36.SetCooldownOf(_: {[any]: any}, s8: string, n5: number) -- line: 285
			-- upvalues: v36 (copy), Network (copy), p2 (copy)
			local v205 = v36 and v36.Cooldowns

			if not v36 or (not v36.Behavior.Abilities or not v36.Behavior.Abilities[s8]) then
				return
			end

			if tonumber(n5) and n5 ~= 0 and not workspace:GetAttribute("CooldownsDisabled") then
				local v206 = n5 < 0 and (not not v205[s8] and v205[s8] - workspace:GetServerTimeNow() + n5) or n5

				v205[s8] = workspace:GetServerTimeNow() + v206
			else
				v205[s8] = nil
			end

			Network:FireClientConnection(p2, "UpdateAbilityCooldown", "REMOTE_EVENT", s8, n5)
		end

		local Actors0 = {}

		function v36.DisableAbilities(_: {[any]: any}, s9: string, b1: boolean, n6: number?) -- line: 307
			-- upvalues: v36 (copy), Actors0 (copy)
			v36.AbilityDisablers[s9] = b1

			if n6 then
				if Actors0[s9] then
					pcall(task.cancel, Actors0[s9])
					Actors0[s9] = nil
				end

				Actors0[s9] = task.delay(n6, function() -- line: 315
					-- upvalues: v36 (copy), s9 (copy), b1 (copy)
					v36.AbilityDisablers[s9] = not b1
				end)
			end
		end
		function v36.PivotTo(_: {[any]: any}, cFrame: CFrame) -- line: 321
			-- upvalues: v6 (copy), v36 (copy), CharacterReplication (copy)
			assert(v6, "Do not.")
			v36.Rig:PivotTo(cFrame)
			local v213 = v36.ClientV or v36.Rig.PrimaryPart.AssemblyLinearVelocity

			v36.SerializedCF = CharacterReplication.Serialize(cFrame, v213)
			v36.ClientCF = cFrame
			v36.ClientV = v213
			v36.LastClientCFUpdateTime = os.clock()
			v36.ServerCurrentCF = cFrame
			v36.ServerDesiredCF = cFrame

			if v36.Player and v36.Rig:HasTag("Replicating") then
				local QueryHitbox = v36.Rig:FindFirstChild("QueryHitbox")

				if QueryHitbox then
					QueryHitbox.CollisionConnector.Enabled = false
					QueryHitbox.Anchored = true
					QueryHitbox.CFrame = cFrame
				end
			end
		end
		function v36.GetPivot(_: {[any]: any}, b2: boolean?) -- line: 345
			-- upvalues: v36 (copy), v6 (copy), RunService (copy), p2 (copy)
			local Rig = v36.Rig
			local v218 = Rig and Rig.PrimaryPart

			if not v218 then
				return
			end

			if not workspace:GetAttribute("ExperimentalHitboxes") or not v6 then
				return v218.CFrame
			end

			if v36.LastClientCFUpdateTime and v36.ServerCurrentCF and v36.ClientV and os.clock() - v36.LastClientCFUpdateTime < 0.35 then
				local ServerCurrentCF = v36.ServerCurrentCF
				local ClientV = v36.ClientV

				if b2 then
					local ServerDesiredCF = v36.ServerDesiredCF
					local v222 = math.clamp(os.clock() - v36.LastClientCFUpdateTime, 0, 0.15)

					ServerCurrentCF = ServerDesiredCF + ClientV * (((if not RunService:IsStudio() then math.clamp(p2:GetNetworkPing(), 0, 0.12) / 1.4 + 0.06 else 0)) + v222) / 4
				end

				return ServerCurrentCF
			end

			return v218.CFrame
		end

		Util:PreloadAssets(v36.Config)

		if v36.Behavior.GetRig then
			v36.Rig = v36.Behavior:GetRig(v36)
			v36.RigName = v36.Rig.Name
		else
			v36.Rig = v36.Rig and v36.Rig:Clone() or nil
		end

		if not v36.Rig then
			p2:LoadCharacter()()

			return
		end

		local PrimaryPart = v36.Rig.PrimaryPart

		if PrimaryPart then
			PrimaryPart.Anchored = true
		end

		local Humanoid = v36.Rig:FindFirstChild("Humanoid")

		if not Humanoid then
			Humanoid = Instance.new("Humanoid")
			Humanoid.Parent = v36.Rig
			Instance.new("Animator").Parent = Humanoid
		end

		Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None

		local s2_2 = ReplicatedStorage.Assets.Skins[`{ s1 }s`]:FindFirstChild(s2)
		local v45 = s2_2 and s2_2:FindFirstChild((tostring(s3)))
		local v46 = v45 and require(v45.Config)
		local v47 = p2.Character and p2.Character.PrimaryPart
		local Humanoid2 = v36.Rig.Humanoid

		Humanoid2.JumpHeight = 0
		Humanoid2.JumpPower = 0
		Humanoid2.MaxSlopeAngle = 65
		Humanoid2.BreakJointsOnDeath = false
		Humanoid2.HipHeight = v36.Config.HipHeight or 0
		Humanoid2.WalkSpeed = v36.Config.Speed or 16
		Humanoid2.MaxHealth = v36.Config.Health or 100
		Humanoid2.Health = Humanoid2.MaxHealth
		Humanoid2:SetAttribute("BaseSpeed", Humanoid2.WalkSpeed)
		v36.Rig.Name = actorFolder.Name
		v36.Rig:SetAttribute("Username", p2.Name)
		v36.Rig:SetAttribute("SkinName", (tostring(s3)))
		v36.Rig:SetAttribute("SkinNameDisplay", v46 and v46.DisplayName or "")
		v36.Rig:SetAttribute("ActorDisplayName", (tostring(v36.Config.DisplayName)))

		if workspace:GetAttribute("ExperimentalReplication") then
			v36.Rig:AddTag("Replicating")
		end

		if v47 then
			v36.Rig:SetPrimaryPartCFrame(v47.CFrame)
			task.delay(0.1, function() -- line: 438
				-- upvalues: PrimaryPart (copy)
				PrimaryPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
				PrimaryPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
			end)
		end

		if v36.Config.DirectionalMovementDisabled then
			v36.Rig:SetAttribute("DirectionalMovementDisabled", true)
		end

		if v36.Config.Sounds and v36.Config.Sounds.Ambience then
			Sounds:Play(v36.Config.Sounds.Ambience, {
				Looped = true,
				Parent = v36.Rig.PrimaryPart
			})
		end

		Humanoid2.Died:Once(function() -- line: 452
			-- upvalues: v36 (copy), Sounds (copy), p2 (copy), Ragdolls (copy), Actors (copy)
			local PrimaryPart2 = v36.Rig.PrimaryPart

			if PrimaryPart2 then
				(Sounds:Play("deadJ" .. p2.Name, {
					Parent = PrimaryPart2
				}) or Sounds:Play("dead", {
					Parent = PrimaryPart2
				})):SetAttribute("Bypassable", true)
			end

			Sounds:PlayVoiceline(v36, "Died", {
				Priority = 10
			})

			local KillEffects = v36.Config.KillEffects

			if KillEffects then
				Ragdolls.AddProfile(v36.Rig, {
					KillEffects = KillEffects
				})
			end

			Actors:CleanupActorFromPlayer(p2)
		end)

		local Pants = v36.Rig:FindFirstChildOfClass("Pants")
		local Shirt = v36.Rig:FindFirstChildOfClass("Shirt")
		local ShirtGraphic = v36.Rig:FindFirstChildOfClass("ShirtGraphic")

		if Pants and Pants.PantsTemplate == "" then
			Pants.PantsTemplate = Pants:GetAttribute("ID") or ""
		end

		if Shirt and Shirt.ShirtTemplate == "" then
			Shirt.ShirtTemplate = Shirt:GetAttribute("ID") or ""
		end

		if ShirtGraphic and ShirtGraphic.Graphic then
			ShirtGraphic.Graphic = ShirtGraphic:GetAttribute("ID") or ""
		end



		local u52 = v36.RigName and v36.Config[`Expressions{ v36.RigName }`] or v36.Config.Expressions

		if u52 and not v36.Rig.Head:FindFirstChild("face") then
			local v53 = v36.Rig:FindFirstChild("ExpressionHolder", true) or ReplicatedStorage.Assets.Instances.ExpressionHolder:Clone()

			if not v53.Parent then
				v53.Parent = v36.Rig
				v53.CFrame = v36.Rig.Head.CFrame * CFrame.new(0, 0, -0.005)

				local WeldConstraint = Instance.new("WeldConstraint")

				WeldConstraint.Part0 = v36.Rig.Head
				WeldConstraint.Part1 = v53
				WeldConstraint.Parent = v53
			end

			local v55 = v53:FindFirstChildOfClass("Decal") or Instance.new("Decal")

			if not v55.Parent then
				v55.Parent = v53
			end

			v55.Name = "Expression"

			local thread = nil

			function v36.ChangeExpression(_, p9, p10) -- line: 513
				-- upvalues: u52 (ref), v36 (copy), thread (ref), v55 (copy), Humanoid2 (copy)
				u52 = v36.RigName and v36.Config[`Expressions{ v36.RigName }`] or v36.Config and v36.Config.Expressions

				if not v36.Rig.Parent then
					return
				end

				if not u52 or not u52[p9] then
					return
				end

				if thread then
					task.cancel(thread)
				end

				if p9 == "Default" then
					v55.Texture = Humanoid2.Health <= Humanoid2.MaxHealth / 2 and u52.Injured or u52.Default
				else
					v55.Texture = u52[p9]
				end

				pcall(v36.Behavior.onExpressionChanged, v36.Behavior, v36, p9, p10)

				if p10 then
					thread = task.delay(p10, function() -- line: 532
						-- upvalues: Humanoid2 (copy), u52 (ref), v55 (copy), v36 (copy)
						local v267 = Humanoid2.Health <= Humanoid2.MaxHealth / 2

						if u52 then
							v55.Texture = v267 and u52.Injured or u52.Default
						end

						pcall(v36.Behavior.onExpressionChanged, v36.Behavior, v36, not v267 and "Default" or "Injured", nil)
					end)
				end
			end

			v55.Texture = u52.Default or ""

			local Health = Humanoid2.Health

			Humanoid2.HealthChanged:Connect(function(p11) -- line: 547
				-- upvalues: v36 (copy), thread (ref), Health (ref), u52 (ref), Sounds (copy)
				if p11 <= 0 then
					v36:ChangeExpression("Dead")

					function v36.ChangeExpression() -- line: 553
					end

					if thread then
						pcall(task.cancel, thread)
					end

					thread = nil
				elseif p11 < Health and u52 and u52.Hurt then
					v36:ChangeExpression("Hurt", 0.75)
				elseif p11 > Health + 20 and u52 and u52.Happy then
					v36:ChangeExpression("Happy", 0.75)
				else
					v36:ChangeExpression("Default")
				end

				if Health - p11 >= 15 then
					Sounds:PlayVoiceline(v36, "Injured", {
						Priority = 5
					})
				end

				Health = p11
			end)
		else
			function v36.ChangeExpression(_, _, _) -- line: 578
			end
		end

		for _, child in pairs(workspace.Players:GetChildren()) do
			if child.Name:find(s1) then
				v36.Rig.Parent = child

				break
			end
		end

		task.spawn(function() -- line: 590
			-- upvalues: v36 (copy), Util (copy)
			for k, v in pairs(v36.Config.Animations) do
				if tostring(k):find("Execution") and typeof(v) == "table" then
					v36.Cache[`{ k }Anim`] = Util:LoadAnimationFromID(v36.Rig, v.KillerRig, true)
				end
			end
		end)
		task.spawn(function() -- line: 599
			-- upvalues: v36 (copy), Sounds (copy)
			if v36.Config.Voicelines and v36.Config.Voicelines.Idle then
				while task.wait(math.random(10, 25)) and v36 and v36.Rig and v36.Rig.PrimaryPart do
					if not v36.Rig.PrimaryPart:FindFirstChild("VoicelineSFX") then
						local Humanoid3 = v36.Rig:FindFirstChildOfClass("Humanoid")

						if Humanoid3 and Humanoid3.Health >= Humanoid3.MaxHealth / 2 and v36.Config.Voicelines.IdleInjured then
							Sounds:PlayVoiceline(v36, "IdleInjured", {
								Priority = 0
							})
						else
							Sounds:PlayVoiceline(v36, "Idle", {
								Priority = 0
							})
						end
					end
				end
			end
		end)

		if p2.Character then
			p2.Character:Destroy()
		end

		p2.Character = v36.Rig
		Util:FixCharacter(v36.Rig, `{ s1 }s`)
		Util:AddHitboxes(v36, `{ s1 }s`)

		local v60 = Util:CopyTable(v36)

		v60.Information = nil
		v60.Behavior = nil
		v60.Config = nil
		Network:FireAllClientConnection("ActorCreated", "REMOTE_EVENT", v60)

		for _, v in pairs({
			"Created",
			"CreatedPost"
		}) do
			if v36.Behavior[v] then
				v36.Behavior[v](v36.Behavior, v36)
			end
		end

		local v63 = v36.Config.SprintSpeed or 26
		local BaseSpeed = Humanoid2:GetAttribute("BaseSpeed")

		Util:SetSpeedCap(p2, "Sprinting", v63 / BaseSpeed)
		Actors.CurrentActors[p2] = v36
		Actors.__actorCreated:Fire(v36)

		return v36
	end
end
function Actors.GetActorFromPlayer(_: {[any]: any}, p15) -- line: 653
	-- upvalues: Actors (copy)
	return Actors.CurrentActors[p15]
end
function Actors.CleanupActorFromPlayer(_, p17) -- line: 657
	-- upvalues: Actors (copy), Network (copy)
	local v69 = Actors.CurrentActors[p17]

	if v69 then
		if v69.Behavior and v69.Behavior.Destroyed then
			v69.Behavior:Destroyed(v69)
		end

		for v70, v71 in v69.Signals do
			if v71 and typeof(v71) == "table" and v71.Destroy then
				local ok, result = pcall(function() -- line: 667
					-- upvalues: v71 (copy)
					v71:Destroy()
				end)

				if not ok then
					warn(`[{ script }]: Failed to destroy signal { v70 }: { result }`)
				end
			end
		end

		Network:FireAllClientConnection("ActorDestroyed", "REMOTE_EVENT", p17)
		Actors.__actorDestroyed:Fire(v69)
		if v69._janitor then v69._janitor:Destroy() end

		if p17.Character then
			p17.Character:RemoveTag("Replicating")
		end

		Actors.CurrentActors[p17] = nil
	end
end
function Actors.GetEquippedActorInfo(_: {[any]: any}, p18, s10: string, b3: boolean?) -- line: 690
	-- upvalues: DataHandler (copy), ReplicatedStorage (copy)
	local v78 = DataHandler:Get(p18, 0)
	local v79 = v78 and v78:FindFirstChild("Equipped")
	local v80 = v79 and (not not v79:FindFirstChild(s10) and v79[s10].Value) or ""
    if v80=="Randomized" then
        local purchased=v78 and v78:FindFirstChild("Purchased")
        local owned=purchased and purchased:FindFirstChild(s10.."s")
        local catalog=ReplicatedStorage.Assets:FindFirstChild(s10.."s")
        local choices={}
        if owned and catalog then
            for _,item in owned:GetChildren()do
                if not item:GetAttribute("Temp") and catalog:FindFirstChild(item.Name)then table.insert(choices,item.Name)end
            end
        end
        table.sort(choices)
        v80=#choices>0 and choices[b3 and math.random(1,#choices) or 1] or (s10=="Killer" and "Slasher" or "Noob")
    end
	local v81 = v79 and v79:FindFirstChild("Skins")
	local v82 = v81 and (not not v81:FindFirstChild(v80) and v81[v80].Value) or ""

	if v82 == "Randomized" and b3 then
		local v83 = v78 and v78:FindFirstChild("Purchased")
		local v84 = v83 and v83:FindFirstChild("Skins")
		local v85 = ReplicatedStorage.Assets.Skins:FindFirstChild(`{ s10 }s`)
		local v86 = v85 and v85:FindFirstChild(v80)
		local Actors6 = { "" }

		if v84 and v86 then
			for _, child in v86:GetChildren() do
				if v84:FindFirstChild(child.Name) then
					table.insert(Actors6, child.Name)
				end
			end
		end

		return v80, Actors6[math.random(1, #Actors6)]
	end

	return v80, v82
end
function Actors.GetAmountOfLivingActorsOfClass(_: {[any]: any}, s11: string) -- line: 720
	-- upvalues: Actors (copy)
	local n7 = 0

	for _, v in pairs(Actors.CurrentActors) do
		if v.Config and s11 == v.Config.Class then
			n7 += 1
		end
	end

	return n7
end
function Actors.ApplySkinDataToActorInfo(_, p20) -- line: 730
	-- upvalues: Util (copy), t3 (copy), ReplicatedStorage (copy)
	local v97 = game["Run Service"]:IsServer()
	local folder = p20.Folder
	local actorType = p20.ActorType
	local actorName = p20.ActorName
	local actorSkin = p20.ActorSkin
	local behaviorModule = folder and folder:FindFirstChild("Behavior")
	local configModule = folder and folder:FindFirstChild("Config")

	if not behaviorModule or not configModule then
		warn(`[{script}]: Missing behavior or config module for actor {tostring(actorName)}`)
		return
	end

	p20.Behavior = Util:CopyTable(require(behaviorModule))
	p20.Config = Util:CopyTable(require(configModule))

	if v97 then
		p20.Rig = p20.Config.Rig
	end

	for k, v in pairs(t3) do
		if not p20.Config.Animations[k] then
			p20.Config.Animations[k] = v
		end
	end

	local skinRoot = ReplicatedStorage.Assets.Skins:FindFirstChild(tostring(actorType) .. "s")
	local actorSkinFolder = skinRoot and skinRoot:FindFirstChild(actorName)
	local skinFolder = actorSkin and actorSkinFolder and actorSkinFolder:FindFirstChild(actorSkin)

	p20.SkinFolder = skinFolder

	if skinFolder then
		local skinConfig = skinFolder:FindFirstChild("Config") and require(skinFolder.Config)
		local skinBehavior = skinFolder:FindFirstChild("Behavior") and require(skinFolder.Behavior)
		local skinRig = v97 and skinConfig and skinConfig.Rig

		p20.Config = Util:MergeTables(p20.Config, skinConfig, {
			"DisplayName",
			"TextInteractions"
		})
		p20.Behavior = Util:MergeTables(p20.Behavior, skinBehavior)
		p20.SkinFolder = skinFolder

		if skinRig then
			p20.Rig = skinRig
		end

		return skinFolder
	end
end
function Actors.CreateChatInteraction(_: {[any]: any}, p21, s12: string, p22) -- line: 792
	-- upvalues: Actors (copy), Sounds (copy), Util (copy)
	if typeof(p21) == "Instance" then
		p21 = Actors.CurrentActors[p21] or Actors.CurrentActors[game.Players:GetPlayerFromCharacter(p21)]
	end

	if typeof(p22) == "Instance" then
		p22 = Actors.CurrentActors[p22] or Actors.CurrentActors[game.Players:GetPlayerFromCharacter(p22)]
	end

	if not p21 then
		return
	end

	local TextInteractions = p21.Config.TextInteractions

	if not TextInteractions then
		return
	end

	local parts = string.split(s12, "/")

	for _, v in pairs(parts) do
		TextInteractions = TextInteractions[`{ p22 and tostring(p22.ActorSkin):gsub(p22.ActorName, "") or "" }{ v }`] or (TextInteractions[v] or TextInteractions.Regular)

		if not TextInteractions then
			return
		end
	end

	local v127 = TextInteractions[math.random(#TextInteractions)]

	if v127 then
		if typeof(v127) == "table" and v127.Sound and v127.Text then
			Sounds:Play(v127.Sound, {
				Parent = p21.Rig.PrimaryPart
			})
			Util:DisplayBubble(p21.Rig, v127.Text)

			return
		end

		if typeof(v127) == "table" then
			task.spawn(function() -- line: 818
				-- upvalues: v127 (copy), p21 (ref), p22 (ref), Util (copy)
				for _, v in pairs(v127) do
					local Rig = nil
					local parts2 = string.split(v, " ")

					if parts2[1]:find(":") then
						if parts2[1]:find(p21.ActorName) then
							Rig = p21.Rig
						elseif p22 and parts2[1]:find(p22.ActorName) then
							Rig = p22.Rig
						end

						table.remove(parts2, 1)
					end

					Util:DisplayBubble(Rig, table.concat(parts2, " "))
					task.wait((math.clamp(#parts2 / 2 + v:len(), 1, 4)))
				end
			end)
		else
			Util:DisplayBubble(p21.Rig, v127)
		end
	end
end
function Actors.GiveEXP(_: {[any]: any}, p23, p24, n8: number) -- line: 842
	local PlayerData = p23:FindFirstChild("PlayerData")

	if not PlayerData then
		return false
	end

	local TrackPlayerFriendBoost = require(game.ServerScriptService.Server.Miscellaneous.Account.TrackPlayerFriendBoost)
	local v134 = p23:GetAttribute("EXPMultiplier") or 1
	local EXPBoostTime = PlayerData:FindFirstChild("EXPBoostTime", true)

	if EXPBoostTime and EXPBoostTime.Value > 0 then
		v134 += 0.25
	end

	local PlayerBoost = TrackPlayerFriendBoost:GetPlayerBoost(p23)

	if PlayerBoost then
		v134 += PlayerBoost
	end

	if tonumber(n8) then
		n8 *= v134
	end

	local num = tonumber(string.format("%.2f", n8))

	if p24 then
		p24.Value = p24.Value + tonumber(num)
	end

	return num
end
function Actors.IncrementActorStats(_: {[any]: any}, p25, t21: {[any]: any}) -- line: 870
	-- upvalues: RunService (copy), DataHandler (copy), Actors (copy), Util (copy), Network (copy)
	assert(RunService:IsServer(), "cannot increment actor stats on the client.")

	if workspace:GetAttribute("ServerType") == "VIP" then
		return
	end

	if typeof(p25) ~= "Instance" and not p25:IsA("Player") then
		return
	end

	local v141 = ({
		Support = {
			Money = 8,
			EXP = 12,
			KillerChance = 0.5
		},
		Offensive = {
			Money = 5,
			EXP = 15,
			KillerChance = 0.75
		},
		Survivalist = {
			Money = 3,
			EXP = 12,
			KillerChance = 0.25
		},
		VeryDifficultKillerAction = {
			Money = 20,
			EXP = 60
		},
		DifficultKillerAction = {
			Money = 12,
			EXP = 36
		},
		RegularKillerAction = {
			Money = 8,
			EXP = 24
		},
		EasyKillerAction = {
			Money = 4,
			EXP = 12
		}
	})[t21.RewardType]

	if v141 then
		t21.Money = t21.Money or tonumber(v141.Money)
		t21.EXP = t21.EXP or tonumber(v141.EXP)
		t21.KillerChance = t21.KillerChance or tonumber(v141.KillerChance)
	end

	local ok, result = pcall(function() -- line: 922
		-- upvalues: t21 (copy), DataHandler (copy), p25 (copy), Actors (copy), Util (copy), Network (copy)
		local v239 = nil

		if t21.EXP then
			local v240 = DataHandler:Get(p25, 0)

			if not v240 then
				warn(`[Actors:IncrementActorStats]: Missing PlayerData for { p25 }`)

				return
			end

			local ForceActorName = t21.ForceActorName

			if ForceActorName then
				local v242 = v240 and v240:FindFirstChild("Purchased")

				if v242 then
					local Killers = v242:FindFirstChild("Killers")
					local Survivors = v242:FindFirstChild("Survivors")
					local v245 = Killers and Killers:FindFirstChild(ForceActorName) or Survivors and Survivors:FindFirstChild(ForceActorName)

					if v245 then
						v239 = Actors:GiveEXP(p25, v245, t21.EXP)
					else
						warn("AFHIUHAHUWEHFAUWIFIHAHUIFAWIUW")
					end
				end
			else
				local v246 = Actors.CurrentActors[p25]
				local v247 = v246 and v246.Folder
				local v248 = v247 and v247.Name

				if v247 then
					local v249 = v240 and v240:FindFirstChild("Purchased")
					local v250 = v249 and v249:FindFirstChild(`{ tostring(v246 and v246.ActorType) }s`)

					if v250 then
						v239 = Actors:GiveEXP(p25, v250:FindFirstChild(v248), t21.EXP)
					else
						warn("GRSGGASSFDGEGAFEHSVF ESAT")
					end
				end
			end
		end

		Util:AddToPlayerStat(p25, "Money", t21.Money)
		Util:AddToPlayerStat(p25, "KillerChance", t21.KillerChance)

		if typeof(t21.Action) == "string" then
			local str = tostring(t21.Action)
			local v252 = if not t21.Money then nil else `${ tostring(t21.Money) }`
			local v253 = if not v239 then nil else `{ tostring(v239) } EXP`
			local v254 = if not t21.KillerChance or t21.KillerChance == 0 then nil else `{ tostring(t21.KillerChance) } Malice`
			local t22 = {}

			for _, v in ipairs({
				v252,
				v253,
				v254
			}) do
				if v then
					table.insert(t22, (tostring(v)))
				end
			end

			local v258 = table.concat(t22, " & ")

			Network:FireClientConnection(p25, "SendNotif", "REMOTE_EVENT", `+ { v258 }: { str }`, "Objective")
		end
	end)

	if not ok then
		warn(`[Actors:IncrementActorStats]: Failed to increment stats for { p25 } due to: { result }`)
	end
end
function Actors.CreateCutsceneActor(_, p27, p28) -- line: 990
	-- upvalues: ReplicatedStorage (copy), Util (copy)
	local v147 = p27.Config.Animations[p28]

	if not v147 then
		return
	end

	local clone = p27.Rig:Clone()

	clone:RemoveTag("Replicating")

	for _, child in ipairs(clone:GetChildren()) do
		if child:GetAttribute("Hitbox") then
			child:Destroy()
		end
	end

	local clone2 = (p27.SkinFolder and p27.SkinFolder:FindFirstChild(`{ p28 }CameraRig`) or (p27.Folder:FindFirstChild(`{ p28 }CameraRig`) or (p27.SkinFolder and p27.SkinFolder:FindFirstChild("CameraRig") or (p27.Folder:FindFirstChild("CameraRig") or ReplicatedStorage.Assets.Instances.CameraRig)))):Clone()

	game.Debris:AddItem(clone, 30)
	game.Debris:AddItem(clone2, 30)
	clone:WaitForChild("HumanoidRootPart").Anchored = true
	clone2:WaitForChild(clone2:GetAttribute("RootName") or "HumanoidRootPart").Anchored = true
	clone:SetPrimaryPartCFrame(CFrame.new(0, 10000, 0))
	clone2:SetPrimaryPartCFrame(CFrame.new(0, 10000, 0))
	clone.Name = p27.Player.Name .. "ActorRig"
	clone2.Name = p27.Player.Name .. "CameraRig"
	clone.Parent = workspace.Misc
	clone2.Parent = workspace.Misc

	local t23 = {}

	for _, v in pairs({
		"KillerRig",
		"CameraRig"
	}) do
		local v155 = v147[v]
		local v156 = v147[`{ v }Loop`]

		if v155 then
			t23[v] = Util:LoadAnimationFromID(v:find("Killer") and clone or clone2, v155, true)
		end

		if v156 then
			t23[`{ v }Loop`] = Util:LoadAnimationFromID(v:find("Killer") and clone or clone2, v156, true)
		end
	end

	task.spawn(function() -- line: 1052
		-- upvalues: clone2 (copy)
		local CurrentCamera = workspace.CurrentCamera
		local v260 = clone2:GetAttribute("CameraName") or "CameraPart"
		local v261 = clone2:FindFirstChild(v260)

		while clone2.Parent do
			if v261 then
				CurrentCamera.CameraType = Enum.CameraType.Scriptable
				CurrentCamera.CFrame = v261.CFrame
			end

			task.wait()
		end

		local LocalPlayer = game.Players.LocalPlayer
		local v263 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")

		if v263 then
			CurrentCamera.CameraSubject = v263
		end

		CurrentCamera.CameraType = Enum.CameraType.Custom
	end)

	if p28 == "Victory" then
		t23.KillerRig.Stopped:Connect(function() -- line: 1075
			-- upvalues: t23 (copy)
			t23.KillerRig:Play()
			t23.KillerRig.TimePosition = t23.KillerRig.Length
			t23.KillerRig:AdjustSpeed(0)
		end)
	end

	task.delay(t23.CameraRig.Length - 0.1, function() -- line: 1083
		-- upvalues: t23 (copy)
		for k, v in pairs(t23) do
			if not k:find("Loop") then
				if t23[`{ k }Loop`] then
					t23[`{ k }Loop`]:Play(0)
					v:Stop()
				else
					v:AdjustSpeed(0)
				end
			end
		end
	end)

	for _, v in pairs(t23) do
		v:Play(0)
	end

	return clone, clone2, t23
end
function Actors.Start(_) -- line: 1103
	-- upvalues: v6 (copy), Actors (copy), Network (copy)
	if v6 then
		local CharacterReplication2 = require(game.ServerScriptService.Server.Miscellaneous.Replication.CharacterReplication)

		game.Players.PlayerRemoving:Connect(function(player) -- line: 1108
			-- upvalues: Actors (copy)
			Actors:CleanupActorFromPlayer(player)
		end)
		Network:SetConnection("UpdCF", "UREMOTE_EVENT", CharacterReplication2.Received)
	end

	local t24 = {
		__actorCreated = "ActorAdded",
		__actorDestroyed = "ActorRemoved"
	}

	for k, v in pairs(t24) do
		Actors[k] = Instance.new("BindableEvent")
		Actors[k].Name = k
		Actors[k].Parent = script
		Actors[v] = Actors[k].Event
	end
end

return Actors

]========]},
}
for _,change in changes do
 change.object=assert(find(change.path),"Missing module: "..change.path..". Nothing changed.")
 assert(fingerprint(change.object.Source)==change.expected,"Current Source differs: "..change.path..". Nothing changed; send the current module for a matching installer.")
end
local parent=assert(find("ServerScriptService/Server/Systems/Shopping"))
local template=assert(find("ServerScriptService/Server/Systems/Data/PlayerData/Template"))
local oldFavorites=template:FindFirstChild("Favorites")
assert(not oldFavorites or oldFavorites:IsA("Folder"),"Favorites template has an incompatible type. Nothing changed.")
local favorites=oldFavorites and oldFavorites:Clone()or Instance.new("Folder")
favorites.Name="Favorites"
local function folder(parent,name)
 local object=parent:FindFirstChild(name)
 assert(not object or object:IsA("Folder"),"Invalid Favorites folder: "..name)
 if not object then object=Instance.new("Folder");object.Name=name;object.Parent=parent end
 return object
end
folder(favorites,"Killers");folder(favorites,"Survivors")
local skins=folder(favorites,"Skins")
for _,role in {"Killers","Survivors"}do
 local catalog=assert(find("ReplicatedStorage/Assets/Skins/"..role))
 for _,actor in catalog:GetChildren()do folder(skins,actor.Name)end
end
local backend=Instance.new("ModuleScript");backend.Name="CombatMenuBackend";backend:SetAttribute("Version","1.0.0")
backend.Source=[========[
local Backend = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Debris = game:GetService("Debris")
local Network = require(ReplicatedStorage.Modules.Network)
local buckets = {}
local previews = {}

local function allowed(player, key, capacity, period)
 local now = os.clock()
 local state = buckets[player]
 if not state then state = {}; buckets[player] = state end
 local bucket = state[key]
 if not bucket then bucket = {tokens=capacity, time=now}; state[key] = bucket end
 bucket.tokens = math.min(capacity, bucket.tokens + (now-bucket.time)*capacity/period)
 bucket.time = now
 if bucket.tokens < 1 then return false end
 bucket.tokens -= 1
 return true
end
local function validName(name)
 return type(name)=="string" and #name>0 and #name<=200 and not name:find("/",1,true)
end
local function owned(data, category, name)
 local purchased = data and data:FindFirstChild("Purchased")
 local folder = purchased and purchased:FindFirstChild(category)
 local item = folder and folder:FindFirstChild(name)
 return item and not item:GetAttribute("Temp")
end
local function marker(folder, name, enabled)
 local old = folder:FindFirstChild(name)
 if enabled then
  if not old then local value=Instance.new("BoolValue");value.Name=name;value.Value=true;value.Parent=folder end
 elseif old then old:Destroy() end
end
local function favoriteCharacter(player, role, name, enabled)
 if (role~="Killers" and role~="Survivors") or not validName(name) or type(enabled)~="boolean" then return end
 if not allowed(player,"Favorites",30,5) then return end
 local data=player:FindFirstChild("PlayerData")
 local catalog=ReplicatedStorage.Assets:FindFirstChild(role)
 if not catalog or not catalog:FindFirstChild(name) or not owned(data,role,name) then return end
 local favorites=data:FindFirstChild("Favorites")
 local folder=favorites and favorites:FindFirstChild(role)
 if folder then marker(folder,name,enabled) end
end
local function favoriteSkin(player, actor, name, enabled)
 if not validName(actor) or not validName(name) or type(enabled)~="boolean" then return end
 if not allowed(player,"Favorites",30,5) then return end
 local data=player:FindFirstChild("PlayerData")
 if not owned(data,"Skins",name) then return end
 local valid=false
 for _,role in {"Killers","Survivors"} do
  local group=ReplicatedStorage.Assets.Skins:FindFirstChild(role)
  local folder=group and group:FindFirstChild(actor)
  if folder and folder:FindFirstChild(name) then valid=true;break end
 end
 if not valid then return end
 local favorites=data:FindFirstChild("Favorites")
 local skins=favorites and favorites:FindFirstChild("Skins")
 local folder=skins and skins:FindFirstChild(actor)
 if folder then marker(folder,name,enabled) end
end
local function requestPreview(player, skin, actor)
 if typeof(skin)~="Instance" or typeof(actor)~="Instance" then return nil end
 local role=actor.Parent
 if not role or (role.Name~="Killers" and role.Name~="Survivors") or role.Parent~=ReplicatedStorage.Assets then return nil end
 local skinRole=ReplicatedStorage.Assets.Skins:FindFirstChild(role.Name)
 local actorSkins=skinRole and skinRole:FindFirstChild(actor.Name)
 if not actorSkins or skin.Parent~=actorSkins or not skin:FindFirstChild("Config") then return nil end
 if not player:FindFirstChild("PlayerData") or not allowed(player,"Preview",8,10) then return nil end
 local model=skin:FindFirstChild("Rig")
 if not model or not model:IsA("Model") then
  local assets=game.ServerStorage:FindFirstChild("Assets")
  local rigs=assets and assets:FindFirstChild("Rigs")
  local category=rigs and rigs:FindFirstChild(role.Name)
  local character=category and category:FindFirstChild(actor.Name)
  model=character and (character:FindFirstChild(skin.Name) or character:FindFirstChild((skin.Name:gsub(actor.Name,""))))
 end
 if not model or not model:IsA("Model") then model=actor:FindFirstChild("Rig") end
 if not model or not model:IsA("Model") then return nil end
 local gui=player:FindFirstChildOfClass("PlayerGui")
 if not gui then return nil end
 local clone=model:Clone()
 for _,object in clone:GetDescendants() do
  if object:IsA("LuaSourceContainer") or object:IsA("ProximityPrompt") or object:IsA("ClickDetector") or object:IsA("Sound") then
   object:Destroy()
  elseif object:IsA("BasePart") then
   object.CanCollide=false;object.CanTouch=false;object.CanQuery=false
  end
 end
 clone:SetAttribute("PreviewDescendants",#clone:GetDescendants())
 local previous=previews[player]
 if previous then previous:Destroy() end
 previews[player]=clone
 clone.Name="CombatMenuPreview"
 clone.Parent=gui
 Debris:AddItem(clone,30)
 return clone
end
function Backend.Start()
 Network:SetConnection("FavoriteCharacter","REMOTE_EVENT",favoriteCharacter)
 Network:SetConnection("FavoriteSkin","REMOTE_EVENT",favoriteSkin)
 Network:SetConnection("RequestPreviewRig","REMOTE_FUNCTION",requestPreview)
 Players.PlayerRemoving:Connect(function(player)
  buckets[player]=nil
  if previews[player] then previews[player]:Destroy();previews[player]=nil end
 end)
end
return Backend
]========]
local backup=Instance.new("Folder");backup.Name="CombatMenuServer_Backup_"..os.date("!%Y%m%d_%H%M%S")
local suffix=0;local base=backup.Name
while storage:FindFirstChild(backup.Name)do suffix+=1;backup.Name=base.."_"..suffix end
local function ref(parent,name,value)local object=Instance.new("ObjectValue");object.Name=name;object.Value=value;object.Parent=parent end
for i,change in changes do
 local record=Instance.new("Folder");record.Name="Source_"..i
 local before=Instance.new("StringValue");before.Name="Before";before.Value=change.object.Source;before.Parent=record
 record:SetAttribute("Installed",fingerprint(change.after));ref(record,"Target",change.object)
 record.Parent=backup
 change.before=before.Value
end
ref(backup,"Template",template);ref(backup,"Backend",backend);ref(backup,"Favorites",favorites)
if oldFavorites then ref(backup,"OldFavorites",oldFavorites)end
backup.Parent=storage
local ok,err=pcall(function()
 for _,change in changes do change.object.Source=change.after end
 if oldFavorites then oldFavorites.Parent=backup end
 favorites.Parent=template
 backend.Parent=parent
end)
if not ok then
 for _,change in changes do if change.object.Source~=change.before then change.object.Source=change.before end end
 favorites:Destroy();backend:Destroy()
 if oldFavorites then oldFavorites.Parent=template end
 backup:Destroy();error("[Menu backend] Rolled back: "..tostring(err))
end
print("[Menu backend] Installed favorites, preview requests and randomized characters. Save, then start a fresh playtest. Backup: "..backup.Name)
