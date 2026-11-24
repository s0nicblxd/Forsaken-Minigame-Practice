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
