local t1 = {
	timeUntilStaminaRecovers = 0,
	DefaultConfig = {
		IsSprinting = false,
		isSpeedLocked = false,
		BindsEnabled = true,
		StaminaLossDisabled = false,
		MinStamina = 0,
		MaxStamina = 100,
		SprintSpeed = 26,
		StaminaLoss = 10,
		StaminaGain = 20
	}
}
local DataHandler = require(game.ReplicatedStorage.Modules.DataHandler)
local TweenService = game:GetService("TweenService")
local Network = require(game.ReplicatedStorage.Modules.Network)

function t1.ChangeStat(_, p2, p3) -- line: 24
	-- upvalues: t1 (copy)
	if t1[p2] then
		t1[p2] = p3
	end
end
function t1.CanRegenStamina(p4) -- line: 30
	return p4.timeUntilStaminaRecovers <= 0
end
function t1.Toggle(_, p6) -- line: 34
	-- upvalues: t1 (copy), Network (copy), TweenService (copy)
	local Character = game.Players.LocalPlayer.Character
	local v12 = Character and Character:FindFirstChild("Humanoid")

	if not v12 then
		return
	end

	if t1.__currentSpeedTween then
		t1.__currentSpeedTween:Cancel()
		t1.__currentSpeedTween = nil
	end

	if t1.__currentFOVTween then
		t1.__currentFOVTween:Cancel()
		t1.__currentFOVTween = nil
	end

	if p6 then
		if not Character:GetAttribute("FootstepsMuted") then
			Network:FireServerConnection("FootSP", "UREMOTE_EVENT", 1)
		end

		t1.__currentFOVTween = TweenService:Create(t1.__FOVMultiplier, TweenInfo.new(0.75), {
			Value = 1.125
		})
		t1.__currentFOVTween:Play()

		if not t1.isSpeedLocked then
			t1.__currentSpeedTween = TweenService:Create(t1.__speedMultiplier, TweenInfo.new(0.75), {
				Value = t1.SprintSpeed / (v12:GetAttribute("BaseSpeed") or 16)
			})
			t1.__currentSpeedTween:Play()

			return
		end
	else
		t1.__currentFOVTween = TweenService:Create(t1.__FOVMultiplier, TweenInfo.new(0.75), {
			Value = 1
		})
		t1.__currentFOVTween:Play()

		if not t1.isSpeedLocked then
			t1.__currentSpeedTween = TweenService:Create(t1.__speedMultiplier, TweenInfo.new(0.75), {
				Value = 1
			})
			t1.__currentSpeedTween:Play()
		end
	end
end
function t1.Resync(_) -- line: 75
	-- upvalues: t1 (copy)
	t1:Toggle(t1.IsSprinting)
end
function t1.SetStaminaFrozen(_, source, active)
	t1.__staminaFreezeSources = t1.__staminaFreezeSources or {}
	t1.__staminaFreezeSources[source] = active and true or nil
end
function t1.SyncHeldKey(_)
	if t1.IsSprinting or not t1.CanSprint or not t1.BindsEnabled or not t1.__sprintHandler then return end
	local input = game:GetService("UserInputService")
	for _, key in ipairs(t1.__sprintKeys or {}) do
		local held = key.EnumType == Enum.KeyCode and input:IsKeyDown(key)
			or key.EnumType == Enum.UserInputType and input:IsMouseButtonPressed(key)
		if held then t1.__sprintHandler("Sprinting", Enum.UserInputState.Begin); return end
	end
end

function t1.Init(_) -- line: 80
	-- upvalues: t1 (copy), DataHandler (copy), Network (copy)
	local LocalPlayer = game.Players.LocalPlayer
	local Character = LocalPlayer.Character

	Character:WaitForChild("Humanoid")

	for k, v in pairs(t1.DefaultConfig) do
		t1[k] = v
	end

	t1.StaminaCap = nil
	t1.StaminaLossDisabled = false
	t1.__staminaFreezeSources = {}
	t1.DefaultsSet = true
	t1.__sprintedEvent = Instance.new("BindableEvent")
	t1.__staminaChangedEvent = Instance.new("BindableEvent")
	t1.__speedMultiplier = Instance.new("NumberValue")
	t1.__speedMultiplier.Value = 1
	t1.__speedMultiplier.Name = "Sprinting"
	t1.__speedMultiplier.Parent = Character:WaitForChild("SpeedMultipliers", 10)
	t1.__FOVMultiplier = Instance.new("NumberValue")
	t1.__FOVMultiplier.Value = 1
	t1.__FOVMultiplier.Name = "Sprinting"
	t1.__FOVMultiplier.Parent = Character:WaitForChild("FOVMultipliers", 10)
	t1.CanSprint = true
	t1.SprintToggled = t1.__sprintedEvent.Event
	t1.StaminaChanged = t1.__staminaChangedEvent.Event
	t1.Stamina = t1.MaxStamina
	t1.SprintToggled:Connect(function(p9) -- line: 115
		-- upvalues: t1 (copy)
		t1:Toggle(p9)
	end)
	t1.timeUntilStaminaRecovers = 0

	local function sprint(_, p11) -- line: 121
		-- upvalues: t1 (copy)
		if not t1.CanSprint or not t1.BindsEnabled then
			return
		end

		if require(game.ReplicatedStorage.Modules.Device):GetPlayerDevice() == "Mobile" then
			if p11 ~= Enum.UserInputState.Begin then
				return
			end

			p11 = t1.IsSprinting and Enum.UserInputState.End or Enum.UserInputState.Begin
		end

		if p11 == Enum.UserInputState.Begin and t1.Stamina > t1.MinStamina and not t1.IsSprinting then
			t1.IsSprinting = true
			t1.__sprintedEvent:Fire(true)

			return
		end

		if t1.IsSprinting then
			t1.IsSprinting = false
			t1.__sprintedEvent:Fire(false)

			if t1.timeUntilStaminaRecovers > 0.1 then
				t1.timeUntilStaminaRecovers = math.clamp(t1.timeUntilStaminaRecovers + 0.1, 0, 3)

				return
			end

			t1.timeUntilStaminaRecovers = 0.1
		end
	end

	task.spawn(function() -- line: 152
		-- upvalues: Character (copy), t1 (copy)
		while true do
			local dt = game["Run Service"].Heartbeat:Wait()

			if not Character.Parent then
				break
			end

			if not Character.PrimaryPart then
				return
			end

			if next(t1.__staminaFreezeSources or {}) then continue end

			if t1.IsSprinting and t1.Stamina > t1.MinStamina and Character.PrimaryPart.Velocity.Magnitude > 0.4 and t1.CanSprint and not t1.StaminaLossDisabled and Character.Parent.Name ~= "Spectating" then
				t1.timeUntilStaminaRecovers = math.clamp(t1.timeUntilStaminaRecovers + dt * 0.05, 0.2, 3)
				t1.Stamina = math.clamp(t1.Stamina - t1.StaminaLoss * (1+.05*(Character:GetAttribute("ExhaustedLevel")or 0)) * dt, t1.MinStamina, t1.StaminaCap or t1.MaxStamina)
				t1.__staminaChangedEvent:Fire(t1.Stamina)

				if t1.Stamina <= t1.MinStamina then
					t1.IsSprinting = false
					t1.__sprintedEvent:Fire(false)
					t1.timeUntilStaminaRecovers = 2
					Character:SetAttribute("StaminaPenaltyActive", true)
				end

				continue
			end

			if not t1.StaminaLossDisabled and t1.IsSprinting and (not (Character.PrimaryPart.Velocity.Magnitude <= 0.4) or not (t1.Stamina < t1.MaxStamina) and (not t1.StaminaCap or not (t1.Stamina > t1.StaminaCap))) then
				continue
			end

			t1.timeUntilStaminaRecovers = math.clamp(t1.timeUntilStaminaRecovers - dt, 0, 3)

			if Character:GetAttribute("StaminaPenaltyActive") then
				if not (t1.timeUntilStaminaRecovers <= 0) then
					continue
				end

				Character:SetAttribute("StaminaPenaltyActive", nil)
			end

			if t1.timeUntilStaminaRecovers <= 0 and not Character:GetAttribute("AbilityStaminaOverride") then
				t1.Stamina = math.clamp(t1.Stamina + t1.StaminaGain * math.max(0,1-.05*(Character:GetAttribute("ExhaustedLevel")or 0)) * dt, t1.MinStamina, t1.StaminaCap or t1.MaxStamina)
				t1.__staminaChangedEvent:Fire(t1.Stamina)
			end
		end
	end)

	local t2 = {}
	local v21 = DataHandler:ReadPath("Settings/Keybinds")

	for _, v in pairs({
		v21.Sprinting.Value,
		v21["Sprinting~Console"].Value
	}) do
		for _, v2 in pairs(Enum.KeyCode:GetEnumItems()) do
			if v == v2.Name then
				table.insert(t2, v2)

				break
			end
		end

		for _, v3 in pairs(Enum.UserInputType:GetEnumItems()) do
			if v == v3.Name then
				table.insert(t2, v3)

				break
			end
		end
	end

	t1.__sprintHandler = sprint
	t1.__sprintKeys = t2
	game.ContextActionService:BindActionAtPriority("Sprinting", sprint, false, 10000, unpack(t2))

	if not t1.MobileButton then
		local clone = script.SprintingButton:Clone()

		clone.Parent = LocalPlayer.PlayerGui:WaitForChild("MainUI")

		local Device = require(game.ReplicatedStorage.Modules.Device)

		local function toggleButton() -- line: 236
			-- upvalues: Device (copy), clone (copy)
			clone.Visible = Device:GetPlayerDevice() == "Mobile"
		end

		clone.Visible = Device:GetPlayerDevice() == "Mobile"
		Device.Changed:Connect(toggleButton)
		t1.MobileButton = clone
	end

	if tostring(LocalPlayer.Character.Parent) == "Spectating" and t1.MobileButton then
		t1.MobileButton.AnchorPoint = Vector2.new(0, 0)
		t1.MobileButton.Position = UDim2.new(1, -250, 1, -135)
		t1.MobileButton.Size = UDim2.fromOffset(83, 83)
	end

	if t1.CurrentButtonConnection1 then
		t1.CurrentButtonConnection1:Disconnect()
	end

	t1.CurrentButtonConnection1 = t1.MobileButton.MouseButton1Down:Connect(function() -- line: 256
		-- upvalues: t1 (copy), sprint (copy)
		t1.MobileButton.ImageColor3 = Color3.new(0.75, 0.75, 0.75)
		sprint("Sprinting", Enum.UserInputState.Begin)
	end)

	if t1.CurrentButtonConnection2 then
		t1.CurrentButtonConnection2:Disconnect()
	end

	t1.CurrentButtonConnection2 = t1.MobileButton.MouseButton1Up:Connect(function() -- line: 262
		-- upvalues: t1 (copy), sprint (copy)
		t1.MobileButton.ImageColor3 = Color3.new(1, 1, 1)
		sprint("Sprinting", Enum.UserInputState.End)
	end)

	local t3 = {}

	local function toggleSprintingDisabled(p12, p13) -- line: 270
		-- upvalues: t3 (copy), t1 (copy)
		t3[p12] = p13

		local v40 = true

		for _, v in pairs(t3) do
			if v == true then
				v40 = false

				break
			end
		end

		t1.CanSprint = v40

		if not v40 and t1.IsSprinting then
			t1.IsSprinting = false
			t1.__sprintedEvent:Fire(false)
		end
	end

	Network:SetConnection("DisableSprinting", "BINDABLE_EVENT", toggleSprintingDisabled)
	Network:SetConnection("DisableSprintingSV", "REMOTE_EVENT", toggleSprintingDisabled)
	Network:SetConnection("GrantStamina", "REMOTE_EVENT", function(p14) -- line: 295
		-- upvalues: t1 (copy)
		t1.Stamina = math.min(t1.Stamina + p14, t1.MaxStamina)
	end)
	t1.Character = Character
end
function t1.Destroy(_) -- line: 304
	-- upvalues: Network (copy), t1 (copy)
	t1.__staminaFreezeSources = {}
	t1.__sprintHandler = nil
	t1.__sprintKeys = nil
	Network:RemoveConnection("DisableSprinting", "BINDABLE_EVENT")
	Network:RemoveConnection("DisableSprintingSV", "REMOTE_EVENT")
	Network:RemoveConnection("GrantStamina", "REMOTE_EVENT")
	t1.__sprintedEvent:Destroy()
	t1.__staminaChangedEvent:Destroy()
	t1.__speedMultiplier:Destroy()
	t1.__FOVMultiplier:Destroy()
end

return t1

