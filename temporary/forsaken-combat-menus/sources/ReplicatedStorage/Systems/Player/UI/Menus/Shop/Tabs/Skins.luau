require(game.ReplicatedStorage.GlobalTypes)
require(script.Parent.Parent.Types)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local DataHandler = require(game.ReplicatedStorage.Modules.DataHandler)
local Util = require(game.ReplicatedStorage.Modules.Util)
local Sounds = require(game.ReplicatedStorage.Modules.Sounds)
local IngameCollabs = require(game.ReplicatedStorage.Modules.Schematics.IngameCollabs)
local _ = Players.LocalPlayer
local Assets = script.Assets
local Skins = ReplicatedStorage.Assets.Skins
local t1 = {}
local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local u13 = nil
local s1 = ""

local function onClosed() -- line: 31
	-- upvalues: s1 (ref), u13 (ref)
	s1 = ""
	u13:CloseOverlay()
end
local function getSkinConfig(p1) -- line: 36
	if p1:IsA("ModuleScript") then
		return p1
	end

	local Config = p1:FindFirstChild("Config")

	return Config and (not not Config:IsA("ModuleScript") and Config) or nil
end
local function transitionHighlightToState(p2, b1: boolean) -- line: 45
	-- upvalues: t1 (copy), TweenService (copy)
	assert(p2 and p2:IsA("TextButton"), "transitionHighlightToState() There was no highlight to transition.")
	assert(b1 ~= nil, "transitionHighlightToState() There was no state to transition to.")

	local Highlight = p2:FindFirstChild("Highlight")
	local Text = p2:FindFirstChild("Text")

	if not Highlight or not Text then
		warn(`[{ script }]: Failed to transition highlight for: { p2.Name }, missing UI elements.`)

		return
	end

	if t1[p2] then
		return
	end

	t1[p2] = true
	Highlight.Visible = true
	Highlight.ImageColor3 = p2:FindFirstChild("Outline").ImageColor3
	TweenService:Create(Highlight, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
		ImageTransparency = not b1 and 1 or 0
	}):Play()
	TweenService:Create(Text, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
		TextColor3 = b1 and Color3.new(0, 0, 0) or Color3.new(1, 1, 1)
	}):Play()
	task.delay(0.5, function() -- line: 80
		-- upvalues: t1 (copy), p2 (copy), b1 (copy), Highlight (copy)
		t1[p2] = nil

		if not b1 then
			Highlight.Visible = false
		end
	end)
end
local function createSkinTemplate(p3, p4, p5, p6) -- line: 88
	-- upvalues: IngameCollabs (copy), ReplicatedStorage (copy), Util (copy), u13 (ref), TweenService (copy), tweenInfo (copy), Sounds (copy), s1 (ref)
	local p4Name = p6.Purchased.Skins:FindFirstChild(p4.Name)
	local DisplayName = p3.DisplayName
	local v31 = p3.Price or 0
	local v32 = p3.New or false
	local v33 = p3.LimitedTimeData or nil
	local RenderImage = p3.RenderImage

	if v33 and (not (os.time() >= v33.StartUnix) or not (os.time() <= v33.EndUnix)) then
		return
	end

	local clone = p5:Clone()
	local Render = clone.Holder.Render

	clone.Name = DisplayName or (p4.Name or "Skin")
	clone.Holder.Owned.Visible = p4Name

	local Name = clone.Holder:FindFirstChild("Name")

	Name.Text = DisplayName or "No name provided."
	Name.TextColor3 = p4.Parent.Parent.Name == "Killers" and Color3.fromRGB(255, 200, 200) or Color3.fromRGB(200, 200, 255)
	Render.Image = RenderImage or ""

	local Loading = clone:FindFirstChild("Loading")

	if Loading then
		Loading.Visible = true
	end

	local v39 = IngameCollabs[p3.CollabInfo] or p3.CollabInfo

	if typeof(v39) == "table" then
		local clone2 = ReplicatedStorage.Assets.UI.ShopCardIcon:Clone()

		clone2.Image = v39.Icon or "rbxassetid://9011713759"
		clone2.Parent = clone.Holder.CardIcons
		clone2.MouseEnter:Connect(function() -- line: 124
			-- upvalues: Util (copy), v39 (copy)
			Util:CreateTooltip(v39.Description)
		end)
		clone2.MouseLeave:Connect(function() -- line: 128
			-- upvalues: Util (copy)
			Util:CreateTooltip()
		end)
	end

	u13:ApplyPrice(clone.Holder, p4, p3)
	clone.Holder.New.Visible = v32

	local Updated = clone.Holder:FindFirstChild("Updated")

	if Updated then
		Updated.Visible = not not p3.Updated and (not v32 or false)
	end

	if v32 then
		clone.LayoutOrder = -2000000000 - v31
	elseif p3.Updated then
		clone.LayoutOrder = -1000000000 - v31
	else
		clone.LayoutOrder = v31
	end

	local thread = nil

	if v33 then
		thread = task.spawn(function() -- line: 152
			-- upvalues: v33 (copy), clone (copy), Util (copy)
			while true do
				local v59 = v33.EndUnix - os.time()

				if v59 <= 0 then
					break
				end

				clone.Holder.Timer.Visible = true

				local v60 = v59 > 86400
				local v61 = v60 and math.floor(v59 / 86400) or 0
				local v62 = v60 and `{ v61 } Days` or Util:FormatTime(v59, "Clock")

				clone.Holder.Timer.Time:FindFirstChild("Name").Text = v62
				task.wait(1)
			end

			clone:Destroy()
		end)
	end

	if p4Name then
		clone:SetAttribute("Purchased", true)
	end

	if Loading then
		task.spawn(function() -- line: 177
			-- upvalues: Render (copy), Loading (copy)
			repeat
				if not task.wait(0.1) then
					return
				end
			until Render.IsLoaded

			Loading.Visible = false
		end)
	end

	local u43 = false
	local u44 = nil
	local u45 = nil

	clone.Holder.MouseEnter:Connect(function() -- line: 192
		-- upvalues: u43 (ref), TweenService (copy), clone (copy), tweenInfo (copy), Sounds (copy)
		u43 = true
		TweenService:Create(clone.Holder, tweenInfo, {
			Size = UDim2.fromScale(0.975, 0.975)
		}):Play()
		Sounds:Play("hover")
	end)
	clone.Holder.MouseLeave:Connect(function() -- line: 206
		-- upvalues: u43 (ref), u45 (ref), u44 (ref), TweenService (copy), tweenInfo (copy), Render (copy), clone (copy), Sounds (copy)
		u43 = false

		if u45 then
			task.cancel(u45)
			u45 = nil
		end

		if u44 then
			TweenService:Create(u44, tweenInfo, {
				ImageTransparency = 1
			}):Play()
			TweenService:Create(Render, tweenInfo, {
				ImageTransparency = 0
			}):Play()
			task.delay(tweenInfo.Time, function() -- line: 231
				-- upvalues: u44 (ref)
				if u44 then
					u44:Destroy()
					u44 = nil
				end
			end)
		end

		TweenService:Create(clone.Holder, tweenInfo, {
			Size = UDim2.fromScale(0.9, 0.922)
		}):Play()
		Sounds:Play("hoverEnd")
	end)
	clone.MouseButton1Down:Connect(function() -- line: 250
		-- upvalues: s1 (ref), p4 (copy), u13 (ref)
		if s1 == p4:GetFullName() then
			return
		end

		s1 = p4:GetFullName()
		u13:OpenOverlay(p4, false)
	end)
	clone.AncestryChanged:Connect(function(_, parent) -- line: 259
		-- upvalues: thread (ref)
		if not parent then
			pcall(task.cancel, thread)
		end
	end)
	u13.OnPurchased:Connect(function(p8) -- line: 265
		-- upvalues: p4 (copy), clone (copy)
		local v66 = p4

		if v66:IsA("ModuleScript") then
		else
			local Config = v66:FindFirstChild("Config")

			v66 = Config and (not not Config:IsA("ModuleScript") and Config) or nil
		end

		if p8 ~= v66 then
			return
		end

		clone:SetAttribute("Purchased", true)

		local Holder = clone:FindFirstChild("Holder")

		if not Holder then
			return
		end

		Holder.Owned.Visible = true
	end)

	return clone
end

return {
	new = function(p9) -- line: 286
		-- upvalues: DataHandler (copy), u13 (ref), Skins (copy), ReplicatedStorage (copy), TweenService (copy), createSkinTemplate (copy), Assets (copy), tweenInfo (copy), Sounds (copy), t1 (copy), transitionHighlightToState (copy)
		local v47 = DataHandler:Get()

		if not v47 then
			warn(`[Shop/{ script }]: No player data.`)

			return
		end

		u13 = p9

		local clone = script.Page:Clone()
		local UIPageLayout = clone.Page:FindFirstChildOfClass("UIPageLayout")

		local function markListTemplates(p10) -- line: 298
			for _, child in p10:GetChildren() do
				if child:IsA("GuiButton") and (child.Name == "Template" or child.Name == "OwnedTemplate") then
					child:SetAttribute("ShopTemplate", true)
					child.Visible = false
				end
			end
		end
		local function clearGeneratedButtons(p11) -- line: 307
			for _, child in p11:GetChildren() do
				if child:IsA("GuiButton") and not child:GetAttribute("ShopTemplate") then
					child:Destroy()
				end
			end
		end
		local function createSkinPage(s2: string) -- line: 315
			-- upvalues: Skins (copy), ReplicatedStorage (copy), clone (copy), markListTemplates (copy), clearGeneratedButtons (copy), TweenService (copy), createSkinTemplate (copy), v47 (copy), Assets (copy), tweenInfo (copy), Sounds (copy), p9 (copy)
			local s2_2 = Skins:FindFirstChild(s2)

			if not s2_2 then
				warn(`[Shop/{ script }]: No skin category for { s2 }.`)

				return
			end

			local s2_3 = ReplicatedStorage.Assets:FindFirstChild(s2)

			if not s2_3 then
				warn(`[Shop/{ script }]: No character folder for { s2 }.`)

				return
			end

			local s2_4 = clone.Page:FindFirstChild(s2)

			if not s2_4 then
				warn(`[Shop/{ script }]: No page found for { s2 }.`)

				return
			end

			local Template = s2_4.List:FindFirstChild("Template")

			if not Template then
				warn(`[Shop/{ script }]: No skin template found for { s2 }.`)

				return
			end

			local clone3 = Template:Clone()

			markListTemplates(s2_4.List)
			clearGeneratedButtons(s2_4.List)
			clearGeneratedButtons(s2_4.Characters)

			local u81 = nil
			local u82 = nil

			local function setCharacterButtonState(p12, b2: boolean) -- line: 347
				-- upvalues: u82 (ref), TweenService (copy)
				if not p12 then
					return
				end

				if u82 then
					u82:Cancel()
					u82 = nil
				end

				local Highlight = p12.Holder:FindFirstChild("Highlight")

				if Highlight then
					Highlight.ImageTransparency = not b2 and 0 or 1

					if b2 == true then
						u82 = TweenService:Create(Highlight, TweenInfo.new(0.65, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
							ImageTransparency = 0
						}):Play()
					end

					Highlight.Visible = b2
				end
			end
			local function populateSkins(p13) -- line: 375
				-- upvalues: clearGeneratedButtons (copy), s2_4 (copy), createSkinTemplate (copy), clone3 (ref), v47 (copy)
				clearGeneratedButtons(s2_4.List)

				for _, child in p13:GetChildren() do
					local v111

					if child:IsA("ModuleScript") then
						v111 = child
					else
						local Config = child:FindFirstChild("Config")

						v111 = Config and (not not Config:IsA("ModuleScript") and Config) or nil
					end

					if v111 then
						local ok, result = pcall(require, v111)

						if not ok then
							warn(`[Shop/{ script }]: Failed to require skin config for { child }: { result }.`)
						elseif not result.Exclusive then
							local v115 = createSkinTemplate(result, child, clone3, v47)

							if v115 then
								v115.Parent = s2_4.List
							end
						end
					end
				end
			end

			local v85 = nil

			for _, child in s2_2:GetChildren() do
				if not child:IsA("Folder") then
					warn(`[Shop/{ script }]: There is no folder?`)
				else
					local childName = s2_3:FindFirstChild(child.Name)

					if not childName then
						warn(`[Shop/{ script }]: No character folder for { child }.`)
					else
						local Config = childName:FindFirstChild("Config")

						if not Config then
							warn(`[Shop/{ script }]: No character config for { child }.`)
						else
							local ok, result = pcall(require, Config)

							if not ok then
								warn(`[Shop/{ script }]: Failed to require character config for { child }: { result }.`)
							elseif not result.Exclusive then
								local clone4 = Assets.CharacterButton_PRESET:Clone()

								clone4.Name = child.Name
								clone4.Holder:FindFirstChild("Name").Text = result.DisplayName or child.Name
								clone4.Holder.Render.Image = result.RenderImage or ""
								clone4.Parent = s2_4.Characters

								local v93 = false

								for _, child2 in child:GetChildren() do
									local v96

									if child2:IsA("ModuleScript") then
										v96 = child2
									else
										local Config2 = child2:FindFirstChild("Config")

										v96 = Config2 and (not not Config2:IsA("ModuleScript") and Config2) or nil
									end

									if v96 then
										local ok2, result2 = pcall(require, v96)

										if not ok2 then
											warn(`[Shop/{ script }]: Failed to require skin config for { child2 }: { result2 }.`)
										else
											local LimitedTimeData = result2.LimitedTimeData

											if not LimitedTimeData or os.time() >= LimitedTimeData.StartUnix and os.time() <= LimitedTimeData.EndUnix then
												if result2.New and not result2.Exclusive then
													clone4.New.Visible = true
												end

												if result2.Updated and not result2.Exclusive then
													v93 = true
												end
											end
										end
									end
								end

								local Updated = clone4:FindFirstChild("Updated")

								if Updated then
									Updated.Visible = v93 and not clone4.New.Visible
								end

								clone4.MouseEnter:Connect(function() -- line: 473
									-- upvalues: TweenService (copy), clone4 (copy), tweenInfo (copy), Sounds (copy)
									TweenService:Create(clone4.Holder, tweenInfo, {
										Size = UDim2.fromScale(0.825, 0.91)
									}):Play()
									Sounds:Play("hover")
								end)
								clone4.MouseLeave:Connect(function() -- line: 484
									-- upvalues: TweenService (copy), clone4 (copy), tweenInfo (copy), Sounds (copy)
									TweenService:Create(clone4.Holder, tweenInfo, {
										Size = UDim2.fromScale(0.777, 0.86)
									}):Play()
									Sounds:Play("hoverEnd")
								end)
								clone4.MouseButton1Down:Connect(function() -- line: 495
									-- upvalues: u81 (ref), clone4 (copy), u82 (ref), setCharacterButtonState (copy), populateSkins (copy), child (copy), Sounds (copy)
									if u81 == clone4 then
										return
									end

									local v116 = u81

									if v116 then
										if u82 then
											u82:Cancel()
											u82 = nil
										end

										local Highlight = v116.Holder:FindFirstChild("Highlight")

										if Highlight then
											Highlight.ImageTransparency = 0
											Highlight.Visible = false
										end
									end

									u81 = clone4
									setCharacterButtonState(u81, true)
									populateSkins(child)
									Sounds:Play("click")
								end)
								v85 = v85 or child
								u81 = u81 or clone4
							end
						end
					end
				end
			end

			setCharacterButtonState(u81, true)

			if v85 then
				populateSkins(v85)
			end

			p9:CreateSearchbar(s2_4.Search.TextBox, s2_4.List)
			p9:CreateUnownedButton(s2_4.SortUnowned, s2_4.List)
		end

		createSkinPage("Killers")
		createSkinPage("Survivors")

		local u53 = nil

		local function switchCategory(s3: string) -- line: 524
			-- upvalues: clone (copy), u53 (ref), t1 (copy), transitionHighlightToState (copy), UIPageLayout (copy)
			local s3_2 = clone.Page:FindFirstChild(s3)
			local s3_3 = clone.TabButtons:FindFirstChild(s3)

			if not s3_2 or not s3_3 then
				return
			end

			if s3_3 == u53 then
				return
			end

			if u53 then
				if t1[u53] then
					return
				end

				transitionHighlightToState(u53, false)
			end

			transitionHighlightToState(s3_3, true)

			if UIPageLayout then
				UIPageLayout:JumpTo(s3_2)
			end

			u53 = s3_3
		end

		for _, child in clone.TabButtons:GetChildren() do
			if child:IsA("TextButton") then
				child.MouseEnter:Connect(function() -- line: 557
					-- upvalues: TweenService (copy), child (copy), Sounds (copy)
					TweenService:Create(child, TweenInfo.new(0.25), {
						Size = UDim2.fromScale(0.5, 0.65)
					}):Play()
					Sounds:Play("hover")
				end)
				child.MouseLeave:Connect(function() -- line: 569
					-- upvalues: TweenService (copy), child (copy), Sounds (copy)
					TweenService:Create(child, TweenInfo.new(0.25), {
						Size = UDim2.fromScale(0.454, 0.603)
					}):Play()
					Sounds:Play("hoverEnd")
				end)
				child.MouseButton1Down:Connect(function() -- line: 581
					-- upvalues: switchCategory (copy), child (copy), Sounds (copy)
					switchCategory(child.Name)
					Sounds:Play("click")
				end)
			end
		end

		switchCategory("Survivors")

		return clone
	end,
	OnTabSwitched = function(_) -- line: 592
		-- upvalues: s1 (ref), u13 (ref)
		s1 = ""
		u13:CloseOverlay()
	end,
	OnWindowClosed = function(_) -- line: 596
		-- upvalues: s1 (ref), u13 (ref)
		s1 = ""
		u13:CloseOverlay()
	end
}
