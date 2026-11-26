local t1 = {}

t1.__index = t1

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ContextActionService = game:GetService("ContextActionService")
local UserInputService = game:GetService("UserInputService")
local DataHandler = require(game.ReplicatedStorage.Modules.DataHandler)
local Maid = require(script:WaitForChild("Maid"))
local Spring = require(script:WaitForChild("Spring"))
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local CurrentCamera = workspace.CurrentCamera
local t2 = {
	SMOOTH_CHARACTER_ROTATION = true,
	CHARACTER_ROTATION_SPEED = 7.5,
	TRANSITION_SPRING_DAMPER = 0.75,
	CAMERA_TRANSITION_IN_SPEED = 15,
	CAMERA_TRANSITION_OUT_SPEED = 25,
	LOCKED_CAMERA_OFFSET = Vector3.new(1.75, 0.5, 0),
	LOCKED_MOUSE_ICON = "rbxasset://textures/MouseLockedCursor.png"
}

function t1.Start(p1) -- line: 52
	-- upvalues: Maid (copy), Spring (copy), t2 (copy), LocalPlayer (copy)
	p1._runtimeMaid = Maid.new()
	p1._shiftlockMaid = Maid.new()
	p1._cameraOffsetSpring = Spring.new((Vector3.new(0, 0, 0)))
	p1._cameraOffsetSpring.Damper = t2.TRANSITION_SPRING_DAMPER
	p1.Enabled = false
	p1.ShiftlockBinded = false
	p1:Enable()
	LocalPlayer.CharacterAdded:Connect(function() -- line: 67
		-- upvalues: p1 (copy)
		if p1.MobileButton then
			p1.MobileButton.Size = script.ShiftLockButton.Size
			p1.MobileButton.Position = script.ShiftLockButton.Position
			p1.MobileButton.AnchorPoint = script.ShiftLockButton.AnchorPoint
		end
	end)
end
function t1.BindKeybinds(p2) -- line: 76
	-- upvalues: ContextActionService (copy), DataHandler (copy), LocalPlayer (copy)
	ContextActionService:UnbindAction("ShiftLockSwitchAction")

	local t3 = {}
	local Keybinds = DataHandler:Get():WaitForChild("Settings"):WaitForChild("Keybinds")

	for _, v in pairs({
		Keybinds:WaitForChild("ShiftLock").Value,
		Keybinds:WaitForChild("ShiftLock~Console").Value
	}) do
		for _, v2 in pairs(Enum.KeyCode:GetEnumItems()) do
			if v == v2.Name then
				table.insert(t3, v2)

				break
			end
		end

		for _, v3 in pairs(Enum.UserInputType:GetEnumItems()) do
			if v == v3.Name then
				table.insert(t3, v3)

				break
			end
		end
	end

	ContextActionService:BindActionAtPriority("ShiftLockSwitchAction", function(actionName, inputState, inputObject) -- line: 95
		-- upvalues: p2 (copy)
		return p2:_doShiftLockSwitch(actionName, inputState, inputObject)
	end, false, Enum.ContextActionPriority.Medium.Value, unpack(t3))

	if not p2.MobileButton then
		local clone = script.ShiftLockButton:Clone()

		clone.Parent = LocalPlayer.PlayerGui:WaitForChild("MainUI")
		p2.MobileButton = clone
		clone.MouseButton1Down:Connect(function() -- line: 107
			-- upvalues: clone (copy), p2 (copy)
			clone.ImageColor3 = Color3.new(0.75, 0.75, 0.75)
			p2:_doShiftLockSwitch(nil, Enum.UserInputState.Begin)
		end)
		clone.MouseButton1Up:Connect(function() -- line: 112
			-- upvalues: clone (copy)
			clone.ImageColor3 = Color3.new(1, 1, 1)
		end)

		local Device = require(game.ReplicatedStorage.Modules.Device)

		local function toggleButton() -- line: 118
			-- upvalues: Device (copy), clone (copy)
			clone.Visible = Device:GetPlayerDevice() == "Mobile"
		end

		clone.Visible = Device:GetPlayerDevice() == "Mobile"
		Device.Changed:Connect(toggleButton)
	end
end
function t1.Enable(p3) -- line: 130
	-- upvalues: LocalPlayer (copy), t1 (copy), RunService (copy), CurrentCamera (copy), UserInputService (copy)
	p3:_refreshCharacterVariables()
	p3._runtimeMaid:GiveTask(LocalPlayer.CharacterAdded:Connect(function() -- line: 132
		-- upvalues: p3 (copy)
		p3:_refreshCharacterVariables()
	end))
	t1:BindKeybinds()
	p3._runtimeMaid:GiveTask(RunService.RenderStepped:Connect(function() -- line: 140
		-- upvalues: p3 (copy), CurrentCamera (copy), UserInputService (copy)
		if not p3.Character:GetAttribute("CustomRig") and p3.Head.LocalTransparencyModifier > 0.6 then
			return
		end

		if CurrentCamera.CameraType ~= Enum.CameraType.Custom then
			return
		end

		local CoordinateFrame = CurrentCamera.CoordinateFrame

		if (p3.Head.Position - CoordinateFrame.p).magnitude > 1 then
			CurrentCamera.CFrame = CurrentCamera.CFrame * CFrame.new(p3._cameraOffsetSpring.Position)

			if p3.Enabled and UserInputService.MouseBehavior ~= Enum.MouseBehavior.LockCenter then
				p3:_updateMouseState()
			end
		end
	end))
end
function t1.Disable(p4) -- line: 159
	-- upvalues: ContextActionService (copy)
	p4.Enabled=false
    UserInputService.MouseBehavior=Enum.MouseBehavior.Default
    Mouse.Icon=""
    if p4.Humanoid and p4.Humanoid.Parent then p4.Humanoid.AutoRotate=true end
    p4._runtimeMaid:DoCleaning()
	p4._shiftlockMaid:DoCleaning()
	ContextActionService:UnbindAction("ShiftLockSwitchAction")
end
function t1._refreshCharacterVariables(p5) -- line: 168
	-- upvalues: LocalPlayer (copy)
	p5.Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	p5.RootPart = p5.Character:WaitForChild("HumanoidRootPart")
	p5.Humanoid = p5.Character:WaitForChild("Humanoid")

	local Head = p5.Character:WaitForChild("Head")

	p5.Head = Head:IsA("Model") and Head.PrimaryPart or Head
end
function t1._doShiftLockSwitch(p6, _, p8) -- line: 179
	if p8 == Enum.UserInputState.Begin then
		p6:ToggleShiftLock()

		return Enum.ContextActionResult.Sink
	end

	return Enum.ContextActionResult.Pass
end
function t1._updateMouseState(p9) -- line: 189
	-- upvalues: UserInputService (copy)
	UserInputService.MouseBehavior = p9.Enabled and Enum.MouseBehavior.LockCenter or Enum.MouseBehavior.Default
end
function t1._updateMouseIcon(p10) -- line: 194
	-- upvalues: Mouse (copy), t2 (copy)
	Mouse.Icon = p10.Enabled and t2.LOCKED_MOUSE_ICON or ""
end
function t1._transitionLockOffset(p11) -- line: 199
	-- upvalues: t2 (copy)
	if p11.Enabled then
		p11._cameraOffsetSpring.Speed = t2.CAMERA_TRANSITION_IN_SPEED
		p11._cameraOffsetSpring.Target = t2.LOCKED_CAMERA_OFFSET

		return
	end

	p11._cameraOffsetSpring.Speed = t2.CAMERA_TRANSITION_OUT_SPEED
	p11._cameraOffsetSpring.Target = Vector3.new(0, 0, 0)
end
function t1.IsEnabled(p12) -- line: 210
	return p12.Enabled
end
function t1.ToggleShiftLock(t4: {[any]: any}, b1: boolean?) -- line: 215
	-- upvalues: RunService (copy), t2 (copy), CurrentCamera (copy)
	if b1 ~= nil then
		t4.Enabled = b1
	else
		t4.Enabled = not t4.Enabled
	end

	t4:_updateMouseState()
	t4:_updateMouseIcon()
	t4:_transitionLockOffset()

	if t4.Enabled then
        t4._shiftlockMaid:DoCleaning()
		t4._shiftlockMaid:GiveTask(RunService.RenderStepped:Connect(function(dt: number) -- line: 226
			-- upvalues: t4 (copy), t2 (copy), CurrentCamera (copy)
			if t4.Humanoid and t4.RootPart then
				t4.Humanoid.AutoRotate = not t4.Enabled
			end

			if t4.Humanoid.Sit then
				return
			end

			if t4.RootPart.Anchored then
				return
			end

			if t4.Character:GetAttribute("Ragdolling") then
				return
			end

			if t4.Character:GetAttribute("DisableShiftLockMovement") then
				return
			end

			if t2.SMOOTH_CHARACTER_ROTATION then
				local _, v45, _ = CurrentCamera.CFrame:ToOrientation()

				t4.RootPart.CFrame = t4.RootPart.CFrame:Lerp(CFrame.new(t4.RootPart.Position) * CFrame.Angles(0, v45, 0), (math.clamp(dt * 5 * t2.CHARACTER_ROTATION_SPEED, 0, 1)))

				return
			end

			local _, v48, _ = CurrentCamera.CFrame:ToOrientation()

			t4.RootPart.CFrame = CFrame.new(t4.RootPart.Position) * CFrame.Angles(0, v48, 0)
		end))

		return
	end

	t4.Humanoid.AutoRotate = true
	t4._shiftlockMaid:DoCleaning()
end

return t1

