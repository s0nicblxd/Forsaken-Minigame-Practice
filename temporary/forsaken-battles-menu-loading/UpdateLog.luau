local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local _ = LocalPlayer.PlayerGui
local DataHandler = require(ReplicatedStorage.Modules.DataHandler)
local Network = require(ReplicatedStorage.Modules.Network)
local Sounds = require(ReplicatedStorage.Modules.Sounds)
local Util = require(ReplicatedStorage.Modules.Util)
local DiscordMarkdown = require(script.DiscordMarkdown)
local UpdatelogPresets = ReplicatedStorage.Assets.UI.UpdatelogPresets
local Changelogs = ReplicatedStorage.Assets.Changelogs
local __createComponent = nil
local t4 = {
	TextTemplate = function(t1: {[any]: any}, p1) -- line: 26
		p1.Text = t1.Content
	end,
	ImageTemplate = function(t2: {[any]: any}, p2) -- line: 30
		p2.Image = t2.Content
		p2.Subtitle.Text = t2.Text
	end,
	ItemsTemplate = function(t3: {[any]: any}, p3) -- line: 35
		-- upvalues: __createComponent (ref)
		for i, v in ipairs(t3.Content) do
			local v35 = __createComponent(v, p3)

			if v35 then
				v35.LayoutOrder = i
				v35.Parent = p3
			end
		end
	end
}
local LatestLog = Changelogs:GetAttribute("LatestLog")
local TextTitle = nil
local t5 = {}
local latestOrder = math.huge
local latestKey = nil

local function __toYYMMDD(p4) -- line: 53
	local v37, v38, v39 = p4:match("(%d+)-(%d+)-(%d+)")

	return string.format("%02d%02d%02d", tonumber(v39), tonumber(v37), (tonumber(v38)))
end
local function __generateLegacyLayout(t6: {[any]: any}, p5) -- line: 58
	-- upvalues: UpdatelogPresets (copy)
	local n1 = 0

	for i = 1, #t6.Notes do
		local v44 = t6.Notes[i]
		local clone = UpdatelogPresets.Components.Header:Clone()

		clone.Text = v44.Header
		clone.LayoutOrder = n1
		clone.Parent = p5

		local clone2 = UpdatelogPresets.Components.Seperator:Clone()

		clone2.LayoutOrder = n1 + 1
		clone2.Parent = p5

		local clone3 = UpdatelogPresets.Components.TextPreset:Clone()

		clone3.Main.Text = v44.Body
		clone3.Size = v44.NoteSize or UDim2.fromScale(0.9, 0.25)
		clone3.LayoutOrder = n1 + 2
		clone3.Parent = p5
		n1 += 3
	end
end

function __createComponent(t7: {[any]: any}, p6) -- line: 82
	-- upvalues: t4 (copy)
	local t7Type = script.Presets.Components:FindFirstChild(t7.Type)

	if not t7Type then
		warn(`[{ script }]: Invalid component type: { t7.Type }`)

		return nil
	end

	local clone = t7Type:Clone()
	local v52 = t4[t7.Type]

	if v52 then
		local ok, result = pcall(v52, t7, clone)

		if not ok then
			warn(`[{ script }]: Failed to run callback for component: { t7.Type }, { debug.traceback(result) }`)
		end
	end

	for k, v in next, t7.Style or {} do
		clone[k] = v
	end

	clone.Parent = p6

	return clone
end

local function __generateLayout(t8: {[any]: any}, p7) -- line: 107
	-- upvalues: __createComponent (ref)
	local clone = script.Presets.UpdateDisplayTemplate:Clone()
	local n2 = 0

	local function __increment() -- line: 111
		-- upvalues: n2 (ref)
		n2 += 1
	end

	for _, v in ipairs(t8) do
		local clone4 = script.Presets.Components.SubheaderTemplate:Clone()

		clone4.Header.Text = v.Header
		clone4.LayoutOrder = n2
		clone4.Parent = clone
		n2 += 1

		for _, v2 in ipairs(v.Content) do
			local v67 = __createComponent(v2, clone)

			if v67 then
				v67.LayoutOrder = n2
				n2 += 1
			end
		end
	end

	clone.Parent = p7
end
local function __switchPage(p8, t9: {[any]: any}) -- line: 139
	-- upvalues: DiscordMarkdown (copy), __generateLegacyLayout (copy), __generateLayout (copy)
	assert(typeof(t9) == "table", "meta is not a table!")
 if not t9.Markdown and t9.Notes and t9.Notes[1]and t9.Notes[1].Body then t9.IsLegacy=true end

	for _, v in next, p8.Holder.List:GetChildren() do
		if v:IsA("Frame") or v:IsA("TextLabel") then
			v:Destroy()
		end
	end

	local clone = script.Presets.Loading:Clone()

	clone.Parent = p8.Holder

	local clone5 = script.Presets.Components.HeaderTemplate:Clone()

	clone5.Background.Image = t9.TitleMeta.Image.Backdrop or t9.TitleMeta.Image.Large or t9.TitleMeta.Image.Title or ""
	clone5.Header.Text = t9.TitleMeta.Text.Title or "N/A"
	clone5.Description.Text = t9.TitleMeta.Text.Description or (t9.TitleMeta.Text.Date or "None Provided")
	clone5.LayoutOrder = -10
	clone5.Parent = p8.Holder.List

	if t9.Markdown then
		DiscordMarkdown.Render(t9.Markdown, p8.Holder.List)
	elseif t9.IsLegacy then
		__generateLegacyLayout(t9, p8.Holder.List)
	else
		__generateLayout(t9.Notes, p8.Holder.List)
	end

	clone:Destroy()
end

local t10 = {
	Menu = nil
}
local u25 = nil
local u26 = nil

function t10.OnTransitionState(b1: boolean) -- line: 175
	-- upvalues: t10 (copy), u26 (ref), u25 (ref), Lighting (copy), Util (copy), LocalPlayer (copy), TweenService (copy), Debris (copy)
	local Menu = t10.UpdateLogMenu.Menu

	if b1 then
		if u26 then
			u26:Destroy()
			u26 = nil
		end

		if u25 then
			u25:Destroy()
			u25 = nil
		end

		Menu.Position = UDim2.fromScale(0.5, 0.55)
		Menu.Size = UDim2.fromScale(1, 1.15)
		Menu.Visible = true

		local BlurEffect = Instance.new("BlurEffect")

		BlurEffect.Name = "ShopBlur"
		BlurEffect.Size = 0
		BlurEffect.Parent = Lighting
		u26 = BlurEffect
		u25 = Util:CreateFOVMultiplier(LocalPlayer, 1, "ShopZoom")
		TweenService:Create(BlurEffect, TweenInfo.new(0.225, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = 12
		}):Play()
		TweenService:Create(u25, TweenInfo.new(0.225, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Value = 0.85
		}):Play()
		TweenService:Create(Menu, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Position = UDim2.fromScale(0.5, 0.5)
		}):Play()

		return
	end

	Menu.Visible = false

	local v77 = u25
	local v78 = u26

	if u25 then
		TweenService:Create(u25, TweenInfo.new(0.225, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Value = 1
		}):Play()
	end

	if v78 then
		TweenService:Create(v78, TweenInfo.new(0.225, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = 0
		}):Play()
	end

	if v78 then
		Debris:AddItem(v78, 0.225)
	end

	if v77 then
		Debris:AddItem(v77, 0.225)
	end
end
function t10.Start(_) -- line: 251
	-- upvalues: ReplicatedStorage (copy), t10 (copy), DataHandler (copy), LatestLog (copy), TweenService (copy), Sounds (copy), Network (copy), Changelogs (copy), TextTitle (ref), __switchPage (copy), t5 (copy)
	task.spawn(function() -- line: 252
		-- upvalues: ReplicatedStorage (copy), t10 (copy), DataHandler (copy), LatestLog (copy), TweenService (copy), Sounds (copy), Network (copy), Changelogs (copy), TextTitle (ref), __switchPage (copy), t5 (copy)
		t10.UpdateLogMenu = require(ReplicatedStorage.Initializer).PlayerSystems.SidebarHandler:CreateSidebarMenu("UpdateLog", script.UpdateScreen)


		local Menu = t10.UpdateLogMenu.Menu
		local Close = Menu.Holder.Close

		Close.MouseEnter:Connect(function() -- line: 264
			-- upvalues: TweenService (copy), Close (copy), Sounds (copy)
			TweenService:Create(Close, TweenInfo.new(0.25), {
				Size = UDim2.fromScale(0.105, 0.105)
			}):Play()
			Sounds:Play("hover")
		end)
		Close.MouseLeave:Connect(function() -- line: 276
			-- upvalues: TweenService (copy), Close (copy), Sounds (copy)
			TweenService:Create(Close, TweenInfo.new(0.25), {
				Size = UDim2.fromScale(0.074, 0.095)
			}):Play()
			Sounds:Play("hoverEnd")
		end)
		Close.MouseButton1Down:Connect(function() -- line: 288
			-- upvalues: t10 (copy), Network (copy), Sounds (copy)
			t10.UpdateLogMenu:ToggleMenu(false)
			Network:FireServerConnection("UpdateLogToLatest", "REMOTE_EVENT")
			Sounds:Play("click")
		end)

		for _, v in next, Changelogs:GetChildren() do
			local ok, result = pcall(function() -- line: 295
				-- upvalues: v (copy)
				return require(v)
			end)

			if not ok then
				warn(`Failed to load changelog { v.Name }: { result }`)
			else
				local clone = script.Presets.UpdateTemplate:Clone()

				clone.Name = result.TitleMeta.Text.Title
				clone.UpdateName.Text = result.TitleMeta.Text.Title or "N/A"
				clone.Description.Text = result.TitleMeta.Text.Description or (result.TitleMeta.Text.Date or "None Provided")
				clone.Render.Image = result.TitleMeta.Image.Backdrop or result.TitleMeta.Image.Small or result.TitleMeta.Image.Title or ""

				local v87, v88, v89 = result.TitleMeta.Text.Date:match("(%d+)-(%d+)-(%d+)")

				clone.LayoutOrder = -string.format("%02d%02d%02d", tonumber(v89), tonumber(v87), (tonumber(v88)))
				clone.Parent = Menu.List.Updates
                if clone.LayoutOrder < latestOrder or (clone.LayoutOrder == latestOrder and (not latestKey or v.Name > latestKey)) then
                    latestOrder = clone.LayoutOrder
                    latestKey = v.Name
                end
				clone.MouseEnter:Connect(function() -- line: 312
					-- upvalues: Sounds (copy)
					Sounds:Play("hover")
				end)
				clone.MouseLeave:Connect(function() -- line: 316
					-- upvalues: Sounds (copy)
					Sounds:Play("hoverEnd")
				end)
				clone.MouseButton1Down:Connect(function() -- line: 320
					-- upvalues: TextTitle (ref), result (copy), __switchPage (copy), Menu (copy), Sounds (copy)
					if TextTitle == result.TitleMeta.Text.Title then
						return
					end

					__switchPage(Menu, result)
                    TextTitle = result.TitleMeta.Text.Title
					Sounds:Play("click")
				end)
				t5[v.Name] = result
			end
		end

		LatestLog = Changelogs:GetAttribute("LatestLog")
        if not t5[LatestLog] then LatestLog = latestKey end
        if t5[LatestLog] then
            __switchPage(Menu, t5[LatestLog])
            TextTitle = t5[LatestLog].TitleMeta.Text.Title
        end
        if t5[LatestLog]and DataHandler:Get().Misc.LastSeenLog.Value ~= LatestLog then t10.UpdateLogMenu:ToggleMenu(true)end
	end)
end

return t10
