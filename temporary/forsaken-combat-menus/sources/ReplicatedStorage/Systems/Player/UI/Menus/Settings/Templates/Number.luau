local t1 = {}

t1.__index = t1

local function mapValue(p1, p2, p3) -- line: 5
	return (math.clamp(p2 + (p3 - p2) * p1, p2, p3))
end
local function normalizeValue(p4, p5, p6) -- line: 9
	return (math.clamp((p4 - p5) / (p6 - p5), 0, 1))
end
local function snap(p7, p8) -- line: 13
	return p8 == 0 and p7 or math.floor((p7 + p8 / 2) / p8) * p8
end

function t1.CreateSettingUI(_, p10, p11, p12) -- line: 18
	-- upvalues: t1 (copy)
	local Sounds = require(game.ReplicatedStorage.Modules.Sounds)

	if not p10 then
		p10 = Instance.new("NumberValue")
		p10.Name = "SettingValue"
	end

	local v19 = setmetatable({
		SettingValue = p10
	}, t1)

	v19.Instance = p11 or script.Slider:Clone()
	v19.Value = p10.Value

	local DragBar = v19.Instance.DragBar
	local Dragger = DragBar.Dragger
	local Mouse = game.Players.LocalPlayer:GetMouse()
	local MinValue = p10:GetAttribute("MinValue")
	local MaxValue = p10:GetAttribute("MaxValue")
	local Step = p10:GetAttribute("Step")

	v19.__displayValue = Instance.new("NumberValue")
	v19.__displayValue.Name = "__displayValue"
	v19.__displayValue.Value = p10.Value
	v19.__displayValue.Parent = v19.Instance
	v19.__displayValue:GetPropertyChangedSignal("Value"):Connect(function() -- line: 44
		-- upvalues: Dragger (copy), v19 (copy)
		Dragger.Title.Text = string.format("%g", v19.__displayValue.Value)
	end)
	Dragger.Title.Text = string.format("%g", v19.__displayValue.Value)

	local function enableDragging() -- line: 49
		-- upvalues: v19 (copy), Sounds (copy), Mouse (copy), DragBar (copy), MinValue (copy), MaxValue (copy), Step (copy)
		v19.Dragging = true
		Sounds:Play("switch")

		while task.wait() and v19.Dragging do
			local MouseX = Mouse.X
			local AbsoluteSizeX = DragBar.AbsoluteSize.X
			local v36 = (MouseX - DragBar.AbsolutePosition.X) / AbsoluteSizeX
			local v37 = MinValue
			local v38 = MaxValue
			local v39 = math.clamp(v37 + (v38 - v37) * v36, v37, v38)
			local v40 = Step
			local v41 = v40 == 0 and v39 or math.floor((v39 + v40 / 2) / v40) * v40

			if v41 ~= v19.Value then
				Sounds:Play("tick", {
					Volume = 0.025
				})
				v19.Value = v41
				v19:OnUpdate()

				if v19.__updatedEvent then
					v19.__updatedEvent:Fire()
				end
			end
		end
	end
	local function onInputEnded(p13) -- line: 69
		-- upvalues: v19 (copy), Sounds (copy), p10 (ref), p12 (copy)
		if not v19.Dragging then
			return
		end

		if p13.UserInputType == Enum.UserInputType.MouseButton1 or p13.UserInputType == Enum.UserInputType.Touch or p13.UserInputType == Enum.UserInputType.Gamepad1 and p13.KeyCode == Enum.KeyCode.ButtonR2 then
			v19.Dragging = false
			Sounds:Play("switch")

			if p10.Name ~= "SettingValue" and p10.Name ~= "Value" then
				require(game.ReplicatedStorage.Modules.Network):FireServerConnection("UpdateSettings", "REMOTE_EVENT", p10, v19.Value)

				return
			end

			v19:OnUpdate()

			if p12 then
				p12(v19.Value)
			end
		end
	end

	Dragger.MouseButton1Down:Connect(enableDragging)
	game.UserInputService.InputEnded:Connect(onInputEnded)

	return v19
end
function t1.OnUpdate(p14) -- line: 95
	local MinValue = p14.SettingValue:GetAttribute("MinValue")
	local MaxValue = p14.SettingValue:GetAttribute("MaxValue")
	local v31 = math.clamp((p14.Value - MinValue) / (MaxValue - MinValue), 0, 1)
	local Dragger = p14.Instance.DragBar.Dragger
	local v33 = math.clamp(v31, 0, 1)

	game.TweenService:Create(Dragger, TweenInfo.new(0.1), {
		Position = UDim2.fromScale(v33, 0.5)
	}):Play()
	game.TweenService:Create(p14.__displayValue, TweenInfo.new(0.1), {
		Value = p14.Value
	}):Play()
end

return t1
