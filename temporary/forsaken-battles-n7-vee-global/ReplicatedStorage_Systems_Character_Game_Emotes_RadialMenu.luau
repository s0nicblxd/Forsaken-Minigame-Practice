local _ = script.Parent.Parent
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CONSTANTS = require(script.CONSTANTS)
local TAU = CONSTANTS.TAU
local EX_OFFSET = CONSTANTS.EX_OFFSET
local t1 = {
	[Enum.KeyCode.ButtonA] = true
}
local t2 = {
	[Enum.UserInputType.MouseButton1] = true,
	[Enum.UserInputType.MouseMovement] = true,
	[Enum.UserInputType.Touch] = true
}
local t3 = {
	[Enum.UserInputType.Gamepad1] = true,
	[Enum.UserInputType.Gamepad2] = true,
	[Enum.UserInputType.Gamepad3] = true,
	[Enum.UserInputType.Gamepad4] = true,
	[Enum.UserInputType.Gamepad5] = true,
	[Enum.UserInputType.Gamepad6] = true,
	[Enum.UserInputType.Gamepad7] = true,
	[Enum.UserInputType.Gamepad8] = true
}
local CreateRadial = require(script.CreateRadial)
local t4 = {}

t4.__index = t4
t4.__type = "RadialMenu"

function t4.__tostring(_) -- line: 99
	-- upvalues: t4 (copy)
	return t4.__type
end
function t4.new(p2, p3, p4) -- line: 105
	-- upvalues: t4 (copy), CreateRadial (copy)
	local self = setmetatable({}, t4)

	self._Maid = require(script.Maid).new()
	self._ClickedBind = Instance.new("BindableEvent")
	self._HoverBind = Instance.new("BindableEvent")
	self._LastHoverIndex = nil
	self.Frame = CreateRadial(p2, p3, p4)
	self.Rotation = p4
	self.SubN = p2
	self.Enabled = true
	self.DeadZoneIn = 0
	self.DeadZoneOut = 1e999
	self.Clicked = self._ClickedBind.Event
	self.Hover = self._HoverBind.Event
	init(self)
	self:SetDialProps({
		ImageColor3 = Color3.new(0, 0, 0)
	})
	self:SetRadialProps({
		ImageTransparency = 0.7,
		ImageColor3 = Color3.new(0, 0, 0)
	})

	return self
end

local function shortestDist(p5, p6) -- line: 137
	-- upvalues: TAU (copy)
	local v20 = (p6 - p5) % TAU
	local v21 = 3.141592653589793 - math.abs(math.abs(v20) - 3.141592653589793)

	if (v20 + TAU) % TAU < 3.141592653589793 then
		return v21
	end

	return -v21
end

function init(p7) -- line: 147
	-- upvalues: UserInputService (copy), t2 (copy), t3 (copy), t1 (copy), RunService (copy), EX_OFFSET (copy), TAU (copy)
	local _ = p7.SubN
	local RadialDial = p7.Frame.RadialDial
	local MouseMovement = Enum.UserInputType.MouseMovement

	p7._Maid:Mark(p7._ClickedBind)
	p7._Maid:Mark(p7._HoverBind)
	p7._Maid:Mark(UserInputService.LastInputTypeChanged:Connect(function(p8) -- line: 156
		-- upvalues: t2 (copy), t3 (copy), MouseMovement (ref)
		if t2[p8] or t3[p8] then
			MouseMovement = p8
		end
	end))

	local n1 = 0
    p7._Maid:Mark(UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch or(input.KeyCode==Enum.KeyCode.Thumbstick2 and input.Position.Magnitude>=.2)then p7._DPadAngle=nil end
    end))

	p7._Maid:Mark(UserInputService.InputBegan:Connect(function(input) -- line: 164
		-- upvalues: p7 (copy), t3 (copy), t1 (copy), n1 (ref)
		if not p7.Enabled or not p7:IsVisible()then return end
        local directions={[Enum.KeyCode.DPadRight]=1,[Enum.KeyCode.DPadDown]=1,[Enum.KeyCode.DPadLeft]=-1,[Enum.KeyCode.DPadUp]=-1}
        if directions[input.KeyCode]then
            n1=(n1+directions[input.KeyCode]*TAU/p7.SubN)%TAU
            p7._DPadAngle=n1;return
        end

		if t3[input.UserInputType] then
			if not t1[input.KeyCode] then
				return
			end

			p7._ClickedBind:Fire(p7:PickIndex(n1))
		end

		local Theta = p7:GetTheta(input.UserInputType)

		if Theta then
			p7._ClickedBind:Fire(p7:PickIndex(Theta))
		end
	end))
	p7._Maid:Mark(RunService.RenderStepped:Connect(function(_) -- line: 184
		-- upvalues: p7 (copy), MouseMovement (ref), n1 (ref), EX_OFFSET (copy), TAU (copy), RadialDial (copy)
		if not p7.Enabled then
			return
		end

		local Theta = p7._DPadAngle or p7:GetTheta(MouseMovement)

		if Theta and p7:IsVisible() then
			n1 = Theta

			local v65 = math.rad(p7.Frame.Rotation)
			local v66 = math.deg(Theta - p7.Rotation + v65 + EX_OFFSET + 2 * TAU) % 360 / (360 / p7.SubN) + 0.5

			RadialDial.Rotation = math.deg((p7:GetRotation(v66)))

			local v67 = p7:PickIndex(Theta)

			if v67 ~= p7._LastHoverIndex then
				p7._HoverBind:Fire(p7._LastHoverIndex, v67)
				p7._LastHoverIndex = v67
			end
		end
	end))
end
function t4.SetRadialProps(p10, p11) -- line: 210
	for _, v in next, p10.Frame.Radial:GetChildren() do
		for k, v2 in next, p11 do
			v[k] = v2
		end
	end
end
function t4.SetDialProps(p12, p13) -- line: 218
	local RadialDial = p12.Frame.RadialDial

	for k, v in next, p13 do
		RadialDial[k] = v
	end
end
function t4.GetTheta(p14, p15) -- line: 225
	-- upvalues: t2 (copy), UserInputService (copy), t3 (copy)
	local v40 = nil

	if t2[p15] then
		local Frame = p14.Frame
		local v42 = Frame.AbsoluteSize.y / 2
		local v43 = Frame.AbsolutePosition + Frame.AbsoluteSize / 2

		v40 = (UserInputService:GetMouseLocation() + Vector2.new(0, -36) - v43) / v42
	elseif t3[p15] then
		local GamepadState = UserInputService:GetGamepadState(p15)

		for _, v in next, GamepadState do
			GamepadState[v.KeyCode] = v
		end

		local stick=GamepadState[Enum.KeyCode.Thumbstick2]
        if not stick or stick.Position.Magnitude<.2 then return end
        v40 = stick.Position * Vector3.new(1, -1, 1)
	end

	if v40 then
		local Magnitude = v40.Magnitude

		if Magnitude >= p14.DeadZoneIn and Magnitude <= p14.DeadZoneOut then
			return (math.atan2(v40.y, -v40.x))
		end
	end
end
function t4.PickIndex(p16, p17) -- line: 250
	-- upvalues: EX_OFFSET (copy), TAU (copy)
	local v50 = math.rad(p16.Frame.Rotation)

	return math.floor(math.deg(p17 - p16.Rotation + v50 + EX_OFFSET + 2 * TAU) % 360 / (360 / p16.SubN)) + 1
end
function t4.GetRotation(p18, p19) -- line: 257
	-- upvalues: TAU (copy)
	return -TAU * ((p19 - 1) / p18.SubN)
end
function t4.GetRadial(p20, p21) -- line: 261
	return p20.Frame.Radial[p21]
end
function t4.GetAttachment(p22, p23) -- line: 265
	return p22.Frame.Attach[p23]
end
function t4.IsVisible(p24) -- line: 269
	local Frame = p24.Frame

	repeat
		if not Frame or not Frame:IsA("GuiObject") or not Frame.Visible then
			return false
		end

		Frame = Frame.Parent
	until Frame and Frame:IsA("ScreenGui") and Frame.Enabled

	return true
end
function t4.Destroy(p25) -- line: 280
	if p25._Maid then
		p25._Maid:Sweep()
	end

	if p25.Frame then
		p25.Frame:Destroy()
	end

	p25.Clicked = nil
	p25.Hover = nil
	p25.Frame = nil
end

return t4

