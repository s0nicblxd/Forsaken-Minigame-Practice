require(game.ReplicatedStorage.GlobalTypes)

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataHandler = require(game.ReplicatedStorage.Modules.DataHandler)
local Sounds = require(game.ReplicatedStorage.Modules.Sounds)
local Signal = require(game.ReplicatedStorage.Modules.Misc.Signal)
local EventHandlerClient = require(game.ReplicatedStorage.Modules.EventHandlerClient)

require(game.ReplicatedStorage.Modules.CombatMenuCompat.Device)

local CurrencyDisplay = require(script.Classes.CurrencyDisplay)
local Button = require(script.Classes.Button)
local LocalPlayer = Players.LocalPlayer
local tweenInfo = TweenInfo.new(0.25)
local _ = ReplicatedStorage.Assets.Sounds.SFX.Menu
local t1 = {}

t1.__index = t1

function t1.new(s1: string, p1) -- line: 26
	-- upvalues: t1 (copy), Signal (copy), LocalPlayer (copy)
	local self = setmetatable({}, t1)

	self.Menu = p1:Clone()
	self.Toggled = Signal.new()
	self.Button = nil
	self.MenuName = s1
	self.Menu.Visible = false
	self.Menu.Size = UDim2.fromScale(0,0)
	self.Menu.Parent = LocalPlayer.PlayerGui.MainUI

	for _, descendant in self.Menu:GetDescendants() do
		if descendant:IsA("ScrollingFrame") then
			descendant:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 40
				-- upvalues: descendant (copy)
				descendant.ScrollBarThickness = descendant.AbsoluteSize.X / 44
			end)
		end
	end

	return self
end
function t1.ToggleMenu(t2: {[any]: any}, b1: boolean) -- line: 48
	-- upvalues: Sounds (copy), TweenService (copy), tweenInfo (copy)
	local _sidebar = t2._sidebar

	if _sidebar.TogglingMenus then
		return
	end

	if _sidebar.MenusHidden and t2.SidebarButton then
		return
	end

	if b1 and t2.Menu.Visible then
		return
	end

	_sidebar.TogglingMenus = true

	local MenuVisible = t2.Menu.Visible
	local v26 = nil

	Sounds:Play("select")

	for _, v28 in _sidebar.SidebarMenus do
		if v28.Menu ~= t2.Menu or MenuVisible then
			if v28.Menu ~= t2.Menu and v28.Menu.Visible then
				v26 = v28
			end

			if v28.Menu.Visible then
				v28.Toggled:Fire(false)

				local MenuName = script.Parent.Menus:FindFirstChild(v28.MenuName)
				local ok, result = pcall(require, MenuName)

				if ok and result and result.OnTransitionState then
					result.OnTransitionState(false)
				else
					TweenService:Create(v28.Menu, tweenInfo, {
						Size = UDim2.new(1, -20, 0, 0)
					}):Play()
					task.delay(0.25, function() -- line: 87
						-- upvalues: v28 (copy)
						v28.Menu.Visible = false
					end)
				end

				if v28.Button then
					v28.Button:SetAppearanceState(false)
				end
			end
		end
	end

	task.delay(0.3 + (not v26 and 0 or 0.125), function() -- line: 97
		-- upvalues: _sidebar (copy)
		_sidebar.TogglingMenus = nil
	end)

	if v26 then
		task.wait(0.125)

		if _sidebar.MenusHidden then
			_sidebar.TogglingMenus = nil

			return
		end
	end

	if not MenuVisible then
		t2.Toggled:Fire(true)

		local t2MenuName = script.Parent.Menus:FindFirstChild(t2.MenuName)
		local ok, result = pcall(require, t2MenuName)

		if ok and result and result.OnTransitionState then
			result.OnTransitionState(true)
		else
			t2.Menu.Visible = true
			TweenService:Create(t2.Menu, tweenInfo, {
				Size = UDim2.new(1, -20, 1, -20)
			}):Play()
		end

		if t2.Button then
			t2.Button:SetAppearanceState(true)
		end
	end
end

local t3 = {
	SidebarMenus = {},
	SidebarButtons = {},
	PendingSidebarMenus = {},
	onTransitionState = Signal.new(),
	onMenuSwitched = Signal.new(),
	CashDisplay = script.CashDisplay,
	Sidebar = script.Sidebar
}

t3.__index = t3

local function constructEventUI()end
local function registerSidebarMenuButton(s2: string, p2) -- line: 157
	-- upvalues: t3 (copy)
	local v40 = t3.SidebarButtons[s2]

	if not v40 then
		t3.PendingSidebarMenus[s2] = p2

		return false
	end

	v40.onClick:Connect(function() -- line: 164
		-- upvalues: t3 (copy), s2 (copy)
		t3.onMenuSwitched:Fire(s2)
	end)

	local ok, result = pcall(function() -- line: 168
		-- upvalues: v40 (copy), p2 (copy)
		v40:RegisterMenu(p2)
	end)

	if not ok then
		warn(`[{ script }]: Failed to register sidebar menu '{ s2 }' to its button: { result }`)

		return false
	end

	p2.Button = v40
	t3.PendingSidebarMenus[s2] = nil

	return true
end

function t3.CreateSidebarMenu(t5: {[any]: any}, s3: string, p3) -- line: 181
	-- upvalues: t1 (copy), t3 (copy), registerSidebarMenuButton (copy)
	local v46 = t1.new(s3, p3)

	v46._sidebar = t5
	v46.SidebarButton = t3.Sidebar:FindFirstChild(s3, true)
	t3.SidebarMenus[s3] = v46
	registerSidebarMenuButton(s3, v46)

	return v46
end
function t3.ToggleButtons(_: {[any]: any}, b2: boolean) -- line: 192
	-- upvalues: t3 (copy), TweenService (copy), tweenInfo (copy)
	t3.onTransitionState:Fire(b2)

	for _, v50 in t3.SidebarMenus do
		local MenuName = script.Parent.Menus:FindFirstChild(v50.MenuName)
		local _, result = pcall(require, MenuName)

		if result and result.OnTransitionState then
			result.OnTransitionState(false)
		else
			TweenService:Create(v50.Menu, tweenInfo, {
				Size = UDim2.new(1, -20, 0, 0)
			}):Play()
			task.delay(0.25, function() -- line: 206
				-- upvalues: v50 (copy)
				v50.Menu.Visible = false
			end)
		end

		if v50.Button then
			v50.Button:SetAppearanceState(false)
		end

		task.delay(0.25, function() -- line: 215
			-- upvalues: v50 (copy)
			v50.Menu.Visible = false
		end)
	end
end
function t3.ToggleSidebarButtons(_: {[any]: any}, b3: boolean) -- line: 221
	-- upvalues: t3 (copy)
	t3.MenusHidden = not b3
	t3.Sidebar.Visible = b3

	if b3 then
		return
	end

	t3:ToggleButtons(b3)
end
function t3.Start(_) -- line: 232
	-- upvalues: DataHandler (copy), LocalPlayer (copy), t3 (copy), EventHandlerClient (copy), constructEventUI (copy), Button (copy), registerSidebarMenuButton (copy)
	if not DataHandler:Get() then
		warn(`[{ script }]: No player data found, returning...`)

		return
	end

	local MainUI = LocalPlayer.PlayerGui:WaitForChild("MainUI")

	t3.Sidebar.Parent = MainUI
	t3.CashDisplay.Parent = MainUI

	local Sidebar = t3.Sidebar
	local _ = {
		Sidebar.Middle.Shop,
		Sidebar.Middle.Inventory,
		Sidebar.Middle.Achievements,
		Sidebar.Middle.Spectate,
		Sidebar.Middle.Stats,
		Sidebar.Bottom.Settings,
		Sidebar.Bottom.Rules
	}
	local Info = EventHandlerClient:GetInfo()

	if Info then
		constructEventUI(Info)
	else
		EventHandlerClient.onEventInfoGiven:Connect(constructEventUI)
	end

	for _, child in t3.Sidebar:GetChildren() do
		for _, child2 in child:GetChildren() do
			if child2:IsA("Frame") then
				t3.SidebarButtons[child2.Name] = Button.new(child2, child.Name)

				local v65 = t3.PendingSidebarMenus[child2.Name]

				if v65 then
					registerSidebarMenuButton(child2.Name, v65)
				end
			end
		end
	end

	for v66, _ in t3.PendingSidebarMenus do
		if t3.SidebarButtons[v66] then
		end
	end
end

return t3
