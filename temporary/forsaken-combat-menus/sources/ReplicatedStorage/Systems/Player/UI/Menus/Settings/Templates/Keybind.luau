local t1 = {}

t1.__index = t1

function t1.CreateSettingUI(_, p2, p3) -- line: 4
	-- upvalues: t1 (copy)
	local Sounds = require(game.ReplicatedStorage.Modules.Sounds)
	local Device = require(game.ReplicatedStorage.Modules.CombatMenuCompat.Device)

	if not p2 then
		p2 = Instance.new("StringValue")
		p2.Name = "SettingValue"
	end

	local v8 = setmetatable({
		SettingValue = p2
	}, t1)

	v8.Instance = p3 or script.KeybindFrame:Clone()
	v8.IsKeybind = true

	local function clearCurrentConnection() -- line: 18
		-- upvalues: t1 (copy)
		if t1.__currentConnection then
			t1.__currentConnection:Disconnect()
			t1.__currentConnection = nil
		end
	end

	local t2 = {
		"None",
		"Unknown",
		"MouseMovement",
		"Focus",
		"Accelerometer",
		"TextInput"
	}

	v8.Instance.KeybindButton.MouseButton1Click:Connect(function() -- line: 36
		-- upvalues: Sounds (copy), t1 (copy), v8 (copy), t2 (copy), p2 (ref), Device (copy)
		Sounds:Play("click")

		if t1.__currentConnection then
			return
		end

		if v8.__debounce then
			return
		end

		v8.__debounce = true
		task.delay(0.25, function() -- line: 46
			-- upvalues: v8 (copy)
			v8.__debounce = nil
		end)
		task.wait(0.05)
		v8.Instance.KeybindButton.CurrentBind.Title.Text = "..."
		t1.__currentConnection = game.UserInputService.InputEnded:Connect(function(input) -- line: 51
			-- upvalues: t1 (copy), t2 (copy), p2 (ref), Sounds (copy), Device (copy), v8 (copy)
			if t1.__currentConnection then
				local v17 = input.KeyCode == Enum.KeyCode.Unknown and input.UserInputType.Name or input.KeyCode.Name

				if table.find(t2, v17) or input.KeyCode == Enum.KeyCode.Unknown and p2:GetAttribute("KeycodeOnly") then
					Sounds:Play("error")

					return
				end

				if not Device:IsKeybindAllowed(p2.Name, v17) then
					Sounds:Play("error")

					return
				end

				local Initializer = require(game.ReplicatedStorage.Initializer)

				for k, v in pairs(Initializer.PlayerSettings) do
					if v.IsKeybind and v17 == v.Value and k ~= p2.Name then
						Sounds:Play("error")

						return
					end
				end

				require(game.ReplicatedStorage.Modules.Network):FireServerConnection("UpdateSettings", "REMOTE_EVENT", p2, v17)
				Sounds:Play("switch")

				if t1.__currentConnection then
					t1.__currentConnection:Disconnect()
					t1.__currentConnection = nil
				end

				v8.Instance.KeybindButton.CurrentBind.Title.Text = v17
			end
		end)
	end)

	local function isConsoleKeybind() -- line: 87
		-- upvalues: p2 (ref)
		return p2.Name:find("~Console") ~= nil or p2.Name:find("Console$") ~= nil
	end
	local function updateVisibility() -- line: 91
		-- upvalues: Device (copy), p2 (ref), v8 (copy)
		local PlayerDevice = Device:GetPlayerDevice()

		if PlayerDevice == "Console" and (p2.Name:find("~Console") ~= nil or p2.Name:find("Console$") ~= nil) then
			v8.Instance.Visible = true

			return
		end

		if PlayerDevice == "PC" and (p2.Name:find("~Console") == nil and p2.Name:find("Console$") == nil) then
			v8.Instance.Visible = true

			return
		end

		v8.Instance.Visible = false
	end

	local PlayerDevice = Device:GetPlayerDevice()

	if PlayerDevice == "Console" and (p2.Name:find("~Console") ~= nil or p2.Name:find("Console$") ~= nil) then
		v8.Instance.Visible = true
	elseif PlayerDevice == "PC" and (p2.Name:find("~Console") == nil and p2.Name:find("Console$") == nil) then
		v8.Instance.Visible = true
	else
		v8.Instance.Visible = false
	end

	Device.Changed:Connect(updateVisibility)

	return v8
end
function t1.OnUpdate(p4) -- line: 109
	p4.Instance.KeybindButton.CurrentBind.Title.Text = p4.Value
end

return t1
