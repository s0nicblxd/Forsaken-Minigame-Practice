require(game.ReplicatedStorage.GlobalTypes)
game:GetService("ReplicatedStorage")

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

game:GetService("Players")

local Initializer = require(game.ReplicatedStorage.Initializer)
local DataHandler = require(game.ReplicatedStorage.Modules.DataHandler)
local Util = require(game.ReplicatedStorage.Modules.Util)
local Sounds = require(game.ReplicatedStorage.Modules.Sounds)
local Preset = script.Preset
local tweenInfo = TweenInfo.new(0.25)
local clamp = math.clamp
local floor = math.floor
local t1 = {}

t1.__index = t1

local function defaultClickedCallback() -- line: 27
	-- upvalues: Initializer (copy), Sounds (copy)
	local Shop = Initializer.PlayerSystems.Shop

	Initializer.PlayerSystems.SidebarHandler.SidebarMenus.Shop:ToggleMenu(true)
	Sounds:Play("click")
	Shop:SwitchTab("Skins")
end

function t1.new(s1: string, s2: string, b1: boolean, p1: ((...any) -> ...any)?) -- line: 35
	-- upvalues: DataHandler (copy), t1 (copy), defaultClickedCallback (copy), Preset (copy), TweenService (copy), tweenInfo (copy), Sounds (copy), Util (copy), RunService (copy), clamp (copy), floor (copy)
	assert(typeof(s1) == "string", "CurrencyDisplay.new() requires a currencyName.")
	assert(typeof(s2) == "string", "CurrencyDisplay.new() requires a currencyIcon.")

	local v18 = DataHandler:ReadPath(b1 and `EventCurrency/{ s1 }` or `Stats/Currency/{ s1 }`)

	if not v18 then
		error(`[{ script }]: Could not find currency value for { s1 }.`)
	end

	local self = setmetatable({}, t1)

	self.CurrencyName = s1
	self.CurrencyIcon = s2
	self.IsEventCurrency = b1
	self.onClickedCallback = p1 or defaultClickedCallback

	local clone = Preset:Clone()
 clone.Plus.Visible=false
 clone.Plus.Active=false

	clone.Name = s1
	clone.Icon.Image = s2
	self.Instance = clone
	clone.Plus.MouseEnter:Connect(function() -- line: 60
		-- upvalues: TweenService (copy), clone (copy), tweenInfo (copy), Sounds (copy)
		TweenService:Create(clone.Plus, tweenInfo, {
			Size = UDim2.fromScale(0.292, 1.064)
		}):Play()
		Sounds:Play("hover")
	end)
	clone.Plus.MouseLeave:Connect(function() -- line: 72
		-- upvalues: TweenService (copy), clone (copy), tweenInfo (copy), Sounds (copy)
		TweenService:Create(clone.Plus, tweenInfo, {
			Size = UDim2.fromScale(0.219, 0.798)
		}):Play()
		Sounds:Play("hoverEnd")
	end)
	clone.Plus.MouseButton1Down:Connect(self.onClickedCallback)

	local u21 = nil

	local function __onValueChanged(n1: number, b2: boolean) -- line: 87
		-- upvalues: u21 (ref), clone (copy), Util (copy), RunService (copy), clamp (copy), TweenService (copy), floor (copy)
		if u21 then
			u21:Disconnect()
			u21 = nil
		end

		if b2 then
			clone.Amount.Text = Util:ToCommas(n1)

			return
		end

		local v26 = clone.Amount.Text:gsub(",", "")
		local n2 = 0
		local v28 = tonumber(v26) or 0

		u21 = RunService.Heartbeat:Connect(function(dt: number) -- line: 101
			-- upvalues: clone (copy), u21 (ref), n2 (ref), clamp (copy), TweenService (copy), v28 (copy), n1 (copy), Util (copy), floor (copy)
			if not clone or not clone.Parent then
				u21:Disconnect()

				return
			end

			n2 += dt

			local v30 = clamp(n2 / 1.5, 0, 1)
			local Value = TweenService:GetValue(v30, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
			local v32 = v28 + (n1 - v28) * Value

			clone.Amount.Text = Util:ToCommas((floor(v32)))

			if v30 >= 1 then
				u21:Disconnect()
				u21 = nil
			end
		end)
	end

	local Value = v18.Value

	if u21 then
		u21:Disconnect()
		u21 = nil
	end

	clone.Amount.Text = Util:ToCommas(Value)
	v18.Changed:Connect(__onValueChanged)

	return self
end

return t1
