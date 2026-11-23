local t1 = {}

t1.__index = t1

function t1.CreateSettingUI(_, p2, p3) -- line: 4
	-- upvalues: t1 (copy)
	if not p2 then
		p2 = Instance.new("BoolValue")
		p2.Name = "SettingValue"
	end

	local v6 = setmetatable({
		SettingValue = p2
	}, t1)

	v6.isDebounce = false
	v6.Instance = p3 or script.Checkbox:Clone()
	v6.Instance.CheckboxButton.MouseButton1Click:Connect(function() -- line: 14
		-- upvalues: v6 (copy), p2 (ref)
		if v6.isDebounce then
			return
		end

		v6.isDebounce = true
		task.delay(0.25, function() -- line: 17
			-- upvalues: v6 (copy)
			v6.isDebounce = false
		end)
		require(game.ReplicatedStorage.Modules.Sounds):Play("switch")
		require(game.ReplicatedStorage.Modules.Network):FireServerConnection("UpdateSettings", "REMOTE_EVENT", p2, not p2.Value)
	end)

	return v6
end
function t1.OnUpdate(p4) -- line: 29
	p4.Value = p4.SettingValue.Value
	p4.Instance.CheckboxButton.Checked.Visible = p4.Value
end

return t1
