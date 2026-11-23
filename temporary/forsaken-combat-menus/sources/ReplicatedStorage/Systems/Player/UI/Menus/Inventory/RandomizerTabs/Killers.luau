local t1 = {}
local DataHandler = require(game.ReplicatedStorage.Modules.DataHandler)
local Util = require(game.ReplicatedStorage.Modules.Util)
local Signal = require(game.ReplicatedStorage.Modules.Misc.Signal)
local u5 = nil
local u6 = false

function t1.CreateTab(p1, p2) -- line: 13
	-- upvalues: u6 (ref), u5 (ref), Signal (copy), DataHandler (copy), Util (copy)
	if u6 then
		return u5
	end

	u6 = true

	local CardTemplate = script.Parent.Parent.Templates.CardTemplate
	local SideContainer = p2.InventoryRoot.SideContainer
	local t2 = {}
	local t3 = {}
	local v13 = Signal.new()
	local _ = game.Players.LocalPlayer
	local v15 = DataHandler:Get()
	local Killers = v15.Purchased.Killers
	local _ = v15.Equipped.Killer
	local DisplayExtraLevel = v15.Settings.Customization.DisplayExtraLevel

	local function createCard(p3, p4) -- line: 34
		-- upvalues: CardTemplate (copy), DataHandler (copy), Util (copy), SideContainer (copy), DisplayExtraLevel (copy), p1 (copy), v13 (copy), t2 (copy), t3 (copy)
		if not p3 then
			return
		end

		local Config = require(p3.Config)

		if not p4 and Config.Exclusive then
			return
		end

		local clone = CardTemplate:Clone()
		local Container = clone.Container

		clone.Name = p3.Name
		clone.LayoutOrder = Config.Price or 1000
		Container.CharacterRender.Image = Config.RenderImage or "rbxassetid://13373279056"
		Container.Title.Text = tostring(Config.DisplayName)
		Container.Price.Text = not p4 and (Config.DisplayPrice ~= false and `${ Config.Price }`) or ""
		Container.Title.TextColor3 = Color3.fromRGB(255, 200, 200)
		Container.CharacterRender.ImageTransparency = p4 ~= nil and 0 or 0.5
		Container.LockImage.Visible = p4 == nil

		local v29 = typeof((DataHandler:ReadPath(`Purchased/Killers/{ p3.Name }`))) ~= "Instance"
		local u30 = Config.Locked and v29

		if u30 then
			Container.LockImage.Visible = true
			Container.CharacterRender.ImageTransparency = 0.5

			local u31 = nil

			u31 = Container.ChildAdded:Connect(function(child) -- line: 60
				-- upvalues: u31 (ref), u30 (ref), Container (copy), Util (copy)
				if child.Name == "Purchased" then
					u31:Disconnect()
					u31 = nil
					u30 = false
					Container.LockImage.Visible = false
					Container.CharacterRender.ImageTransparency = 0
					Util:CreateTooltip()
				end
			end)
		end

		Container.MouseEnter:Connect(function() -- line: 74
			-- upvalues: u30 (ref), Util (copy), Config (copy), Container (copy)
			if u30 then
				Util:CreateTooltip(Config.LockedText)

				return
			end

			game.TweenService:Create(Container, TweenInfo.new(0.25), {
				Size = UDim2.fromScale(1.05, 1.05)
			}):Play()
		end)
		Container.MouseLeave:Connect(function() -- line: 83
			-- upvalues: u30 (ref), Util (copy), Container (copy)
			if u30 then
				Util:CreateTooltip()

				return
			end

			game.TweenService:Create(Container, TweenInfo.new(0.25), {
				Size = UDim2.fromScale(1, 1)
			}):Play()
		end)

		local function __changeLevelDisplay() -- line: 92
			-- upvalues: p4 (ref), SideContainer (copy), DisplayExtraLevel (copy), Config (copy)
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

			local v38, v39, v40 = require(game.ReplicatedStorage.Modules.Util):CalculateLevelFromEXP(p4.Value)
			local v41 = v38 > 100 and `MAX LEVEL{ DisplayExtraLevel.Value and ` (+{ math.floor(v38 - 100) })` or "" }` or if v38 ~= 100 then `{ v39 }/{ v40 } EXP` else "MAX LEVEL"
			local v42 = v38 < 100
			local v43 = v39 / math.max(1, v40)
			local v44 = if v43 ~= 0 then 1 / v43 else 0

			SideContainer.PreviewContainer.EXPBar.Visible = v42
			SideContainer.PreviewContainer.EXPBar.Clipping.Size = UDim2.fromScale(v43, 1)
			SideContainer.PreviewContainer.EXPBar.Clipping.Top.Size = UDim2.fromScale(v44, 1)
			SideContainer.EquipContainer.Equip.ImageColor3 = Color3.fromRGB(255, 0, 0)
			SideContainer.EquipContainer.Equip.Title.Text = "Not your decision."
			SideContainer.PreviewContainer.Title.Text = tostring(Config.DisplayName)
			SideContainer.PreviewContainer.Level.Text = `Level { math.min(v38, 100) }`
			SideContainer.PreviewContainer.EXP.Text = v41
			SideContainer.PreviewContainer.Render.Image = Config.SquareRenderImage or (Config.RenderImage or "rbxassetid://13373279056")
		end
		local function __changeDisplayInfo() -- line: 129
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

		DisplayExtraLevel.Changed:Connect(function() -- line: 154
			-- upvalues: p1 (copy), p3 (copy), __changeLevelDisplay (copy)
			if p1.Inventory.CurrentlySelected ~= p3 then
				return
			end

			__changeLevelDisplay()
		end)
		Container.Interact.MouseButton1Click:Connect(function() -- line: 162
			-- upvalues: u30 (ref), Container (copy), p1 (copy), p3 (copy), p4 (ref), __changeLevelDisplay (copy), __changeDisplayInfo (copy), SideContainer (copy)
			if u30 then
				Container.LockImage.ImageColor3 = Color3.fromRGB(205, 0, 0)
				game.TweenService:Create(Container.LockImage, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
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
		v13:Connect(function(p5) -- line: 188
			-- upvalues: p3 (copy), p4 (ref), __changeLevelDisplay (copy)
			if p3.Name ~= p5.Name then
				return
			end

			p4 = p5
			__changeLevelDisplay()
		end)
		table.insert(t2, clone)
		t3[p3.Name] = Container
	end

	local Killers2 = game.ReplicatedStorage.Assets.Killers

	Killers.ChildAdded:Connect(function(child) -- line: 202
		-- upvalues: t3 (copy), Killers2 (copy), createCard (copy), Killers (copy), v13 (copy)
		local v35 = t3[child.Name]
		local childName = Killers2:FindFirstChild(child.Name)

		if not v35 and childName then
			createCard(childName, Killers:FindFirstChild(childName.Name))

			return
		end

		v35.Price.Text = ""
		v35.Title.TextColor3 = Color3.fromRGB(200, 200, 255)
		v35.CharacterRender.ImageTransparency = 0
		v35.LockImage.Visible = false
		v13:Fire(child)
	end)

	for _, child in pairs(Killers2:GetChildren()) do
		createCard(child, Killers:FindFirstChild(child.Name))
	end

	u5 = t2

	return t2
end

return t1
