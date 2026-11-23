local t1 = {}
local DataHandler = require(game.ReplicatedStorage.Modules.DataHandler)

function t1.CreateTab(p1, p2) -- line: 7
	-- upvalues: DataHandler (copy)
	local CardTemplate = script.Parent.Parent.Templates.CardTemplate
	local SideContainer = p2.InventoryRoot.SideContainer
	local t2 = {}
	local _ = game.Players.LocalPlayer
	local v9 = DataHandler:Get()
	local Killers = v9.Purchased.Killers
	local Killer = v9.Equipped.Killer
	local DisplayExtraLevel = v9.Settings.Customization.DisplayExtraLevel

	local function createCard(p3, p4) -- line: 19
		-- upvalues: CardTemplate (copy), DisplayExtraLevel (copy), SideContainer (copy), Killer (copy), p1 (copy), t2 (copy)
		if not p4 then
			return
		end

		if not p3 then
			return
		end

		local Config = require(p3.Config)
		local clone = CardTemplate:Clone()
		local Container = clone.Container

		clone.Name = p3.Name
		clone.LayoutOrder = Config.Price or 1000
		Container.CharacterRender.Image = Config.RenderImage or "rbxassetid://13373279056"
		Container.Title.Text = tostring(Config.DisplayName)
		Container.Title.TextColor3 = Color3.fromRGB(255, 200, 200)
		Container.MouseEnter:Connect(function() -- line: 31
			-- upvalues: Container (copy)
			game.TweenService:Create(Container, TweenInfo.new(0.25), {
				Size = UDim2.fromScale(1.05, 1.05)
			}):Play()
		end)
		Container.MouseLeave:Connect(function() -- line: 35
			-- upvalues: Container (copy)
			game.TweenService:Create(Container, TweenInfo.new(0.25), {
				Size = UDim2.fromScale(1, 1)
			}):Play()
		end)

		local function __changeLevelDisplay() -- line: 39
			-- upvalues: p4 (copy), DisplayExtraLevel (copy), SideContainer (copy), Killer (copy), p3 (copy), Config (copy)
			local v24, v25, v26 = require(game.ReplicatedStorage.Modules.Util):CalculateLevelFromEXP(p4.Value)
			local v27 = v24 > 100 and `MAX LEVEL{ DisplayExtraLevel.Value and ` (+{ math.floor(v24 - 100) })` or "" }` or if v24 ~= 100 then `{ v25 }/{ v26 } EXP` else "MAX LEVEL"
			local v28 = v24 < 100
			local v29 = v25 / v26
			local v30 = if v29 ~= 0 then 1 / v29 else 0

			SideContainer.PreviewContainer.EXPBar.Visible = v28
			SideContainer.PreviewContainer.EXPBar.Clipping.Size = UDim2.fromScale(v29, 1)
			SideContainer.PreviewContainer.EXPBar.Clipping.Top.Size = UDim2.fromScale(v30, 1)
			SideContainer.EquipContainer.Equip.Title.Text = Killer.Value ~= p3.Name and "Equip" or "Equipped"
			SideContainer.PreviewContainer.Title.Text = tostring(Config.DisplayName)
			SideContainer.PreviewContainer.Level.Text = `Level { math.min(v24, 100) }`
			SideContainer.PreviewContainer.EXP.Text = v27
			SideContainer.PreviewContainer.Render.Image = Config.SquareRenderImage or (Config.RenderImage or "rbxassetid://13373279056")
		end

		DisplayExtraLevel.Changed:Connect(__changeLevelDisplay)
		Container.Interact.MouseButton1Click:Connect(function() -- line: 63
			-- upvalues: p1 (copy), p3 (copy), __changeLevelDisplay (copy), SideContainer (copy)
			p1.Inventory.CurrentlySelected = p3
			__changeLevelDisplay()
			SideContainer.Visible = true
			game.TweenService:Create(SideContainer, TweenInfo.new(0.4), {
				Size = UDim2.fromScale(0.3, 1)
			}):Play()
		end)
		table.insert(t2, clone)
	end

	local Killers2 = game.ReplicatedStorage.Assets.Killers

	for _, child in pairs(Killers2:GetChildren()) do
		createCard(child, Killers:FindFirstChild(child.Name))
	end

	Killers.ChildAdded:Connect(function(child) -- line: 80
		-- upvalues: createCard (copy), Killers2 (copy)
		createCard(Killers2:FindFirstChild(child.Name), child)
	end)

	return t2
end

return t1
