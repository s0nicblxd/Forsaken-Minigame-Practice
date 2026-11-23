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
local Emotes = ReplicatedStorage.Assets.Emotes
local u11 = nil
local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local s1 = ""

local function onClosed() -- line: 30
	-- upvalues: s1 (ref), u11 (ref)
	s1 = ""
	u11:CloseOverlay()
end
local function createEmoteTemplate(p1, p2, p3) -- line: 35
	-- upvalues: Assets (copy), u11 (ref), IngameCollabs (copy), ReplicatedStorage (copy), Util (copy), TweenService (copy), tweenInfo (copy), Sounds (copy), s1 (ref)
	local p2Name = p3.Purchased.Emotes:FindFirstChild(p2.Name)
	local DisplayName = p1.DisplayName
	local v21 = p1.Price or 0
	local v22 = p1.New or false
	local v23 = p1.LimitedTimeData or nil
	local RenderImage = p1.RenderImage

	if v23 and (not (os.time() >= v23.StartUnix) or not (os.time() <= v23.EndUnix)) then
		return
	end

	local clone = Assets.Template:Clone()
	local Render = clone.Holder.Render

	clone.Name = DisplayName or "Emote"
	clone.Holder.Owned.Visible = p2Name
	clone.Holder:FindFirstChild("Name").Text = DisplayName or "No name provided."
	Render.Image = RenderImage or ""
	clone.Holder.Loading.Visible = true
	u11:ApplyPrice(clone.Holder, p2, p1)
	clone.Holder.New.Visible = v22

	local Updated = clone.Holder:FindFirstChild("Updated")

	if Updated then
		Updated.Visible = not not p1.Updated and (not v22 or false)
	end

	if v22 then
		clone.LayoutOrder = -2000000000 - v21
	elseif p1.Updated then
		clone.LayoutOrder = -1000000000 - v21
	else
		clone.LayoutOrder = v21
	end

	local v28 = IngameCollabs[p1.CollabInfo] or p1.CollabInfo

	if typeof(v28) == "table" then
		local clone2 = ReplicatedStorage.Assets.UI.ShopCardIcon:Clone()

		clone2.Image = v28.Icon or "rbxassetid://9011713759"
		clone2.Parent = clone.Holder.CardIcons
		clone2.MouseEnter:Connect(function() -- line: 81
			-- upvalues: Util (copy), v28 (copy)
			Util:CreateTooltip(v28.Description)
		end)
		clone2.MouseLeave:Connect(function() -- line: 85
			-- upvalues: Util (copy)
			Util:CreateTooltip()
		end)
	end

	local thread = nil

	if v23 then
		thread = task.spawn(function() -- line: 92
			-- upvalues: v23 (copy), clone (copy), Util (copy)
			while true do
				local v45 = v23.EndUnix - os.time()

				if v45 <= 0 then
					break
				end

				clone.Holder.Timer.Visible = true

				local v46 = v45 > 86400
				local v47 = v46 and math.floor(v45 / 86400) or 0
				local v48 = v46 and `{ v47 } Days` or Util:FormatTime(v45, "Clock")

				clone.Holder.Timer.Time:FindFirstChild("Name").Text = v48
				task.wait(1)
			end

			clone:Destroy()
		end)
	end

	if p2Name then
		clone:SetAttribute("Purchased", true)
	end

	task.spawn(function() -- line: 116
		-- upvalues: Render (copy), clone (copy)
		repeat
			if not task.wait(0.1) then
				return
			end
		until Render.IsLoaded

		clone.Holder.Loading.Visible = false
	end)

	local u31 = false
	local u32 = nil
	local u33 = nil

	clone.Holder.MouseEnter:Connect(function() -- line: 130
		-- upvalues: u31 (ref), u33 (ref), u11 (ref), p1 (copy), p2 (copy), clone (copy), u32 (ref), TweenService (copy), tweenInfo (copy), Render (copy), Sounds (copy)
		u31 = true
		u33 = task.spawn(function() -- line: 132
			-- upvalues: u31 (ref), u11 (ref), p1 (copy), p2 (copy), clone (copy), u32 (ref), TweenService (copy), tweenInfo (copy), Render (copy), u33 (ref)
			local elapsed = os.clock()

			repeat
				task.wait(0.1)
			until u31 == false or os.clock() - elapsed >= 1.5

			if os.clock() - elapsed >= 1.5 then
				local v53 = u11:CreateViewport(p1)

				if not v53 then
					warn(`[Shop/{ script }]: Failed to create emote viewport for { p2.Name }.`)

					return
				end

				v53.AnchorPoint = Vector2.new(0, 0)
				v53.Size = UDim2.fromScale(1, 1)
				v53.Position = UDim2.fromScale(0, 0)
				v53.ImageTransparency = 1
				v53.BackgroundColor3 = Color3.fromRGB(39, 39, 39)
				v53.BackgroundTransparency = 0
				v53.Parent = clone.Holder
				u32 = v53
				TweenService:Create(v53, tweenInfo, {
					ImageTransparency = 0
				}):Play()
				TweenService:Create(Render, tweenInfo, {
					ImageTransparency = 1
				}):Play()
			end

			u33 = nil
		end)
		TweenService:Create(clone.Holder, tweenInfo, {
			Size = UDim2.fromScale(0.975, 0.975)
		}):Play()
		Sounds:Play("hover")
	end)
	clone.Holder.MouseLeave:Connect(function() -- line: 187
		-- upvalues: u31 (ref), u33 (ref), u32 (ref), TweenService (copy), tweenInfo (copy), Render (copy), clone (copy), Sounds (copy)
		u31 = false

		if u33 then
			task.cancel(u33)
			u33 = nil
		end

		if u32 then
			TweenService:Create(u32, tweenInfo, {
				ImageTransparency = 1
			}):Play()
			TweenService:Create(Render, tweenInfo, {
				ImageTransparency = 0
			}):Play()
			task.delay(tweenInfo.Time, function() -- line: 212
				-- upvalues: u32 (ref)
				u32:Destroy()
				u32 = nil
			end)
		end

		TweenService:Create(clone.Holder, tweenInfo, {
			Size = UDim2.fromScale(0.9, 0.922)
		}):Play()
		Sounds:Play("hoverEnd")
	end)
	clone.MouseButton1Down:Connect(function() -- line: 229
		-- upvalues: s1 (ref), p2 (copy), u11 (ref)
		if s1 == p2.Name then
			return
		end

		s1 = p2.Name
		u11:OpenOverlay(p2, true)
	end)
	clone.AncestryChanged:Connect(function(_, parent) -- line: 238
		-- upvalues: thread (ref)
		if not parent then
			pcall(task.cancel, thread)
		end
	end)
	u11.OnPurchased:Connect(function(p5) -- line: 244
		-- upvalues: p2 (copy), clone (copy)
		if not p5 then
			return
		end

		if p5.Name ~= p2.Name then
			return
		end

		clone.Holder.Owned.Visible = true
		clone:SetAttribute("Purchased", true)
	end)

	return clone
end

return {
	new = function(p6) -- line: 262
		-- upvalues: DataHandler (copy), u11 (ref), Emotes (copy), createEmoteTemplate (copy)
		local v35 = DataHandler:Get()

		if not v35 then
			warn(`[Shop/{ script }]: No player data.`)

			return
		end

		u11 = p6

		local clone = script.Page:Clone()
		local List = clone.List

		for _, child in Emotes:GetChildren() do
			local ok, result = pcall(require, child)

			if not ok then
				warn(`[Shop/{ script }]: Failed to require emote module { child }.`)
			elseif not result.Exclusive then
				local v42 = createEmoteTemplate(result, child, v35)

				if v42 then
					v42.Parent = List
				end
			end
		end

		p6:CreateSearchbar(clone.Search.TextBox, List)
		p6:CreateUnownedButton(clone.SortUnowned, List)

		return clone
	end,
	OnTabSwitched = function(_) -- line: 300
		-- upvalues: s1 (ref), u11 (ref)
		s1 = ""
		u11:CloseOverlay()
	end,
	OnWindowClosed = function(_) -- line: 304
		-- upvalues: s1 (ref), u11 (ref)
		s1 = ""
		u11:CloseOverlay()
	end
}
