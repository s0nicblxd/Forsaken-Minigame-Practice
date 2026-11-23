local t1 = {}

t1.__index = t1

function t1.CreateSettingUI(_, p2, p3, p4) -- line: 5
	-- upvalues: t1 (copy)
	local Sounds = require(game.ReplicatedStorage.Modules.Sounds)

	if not p2 then
		p2 = Instance.new("StringValue")
		p2.Name = "SettingValue"
	end

	local v8 = setmetatable({
		SettingValue = p2
	}, t1)

	v8.Value = p2.Value
	v8.Instance = p3 or script.Textbox:Clone()
	v8.Instance.TextboxBackground.Textbox.Focused:Connect(function() -- line: 21
		-- upvalues: Sounds (copy)
		Sounds:Play("click")
	end)
	v8.Instance.TextboxBackground.Textbox.FocusLost:Connect(function() -- line: 25
		-- upvalues: p2 (ref), v8 (copy), p4 (copy), Sounds (copy)
		if p2.Name ~= "SettingValue" and p2.Name ~= "Value" then
			require(game.ReplicatedStorage.Modules.Network):FireServerConnection("UpdateSettings", "REMOTE_EVENT", p2, v8.Instance.TextboxBackground.Textbox.Text)
		else
			v8.Value = v8.Instance.TextboxBackground.Textbox.Text
			v8:OnUpdate()

			if p4 then
				p4(v8.Value)
			end
		end

		Sounds:Play("click")
	end)

	return v8
end
function t1.OnUpdate(p5) -- line: 40
	p5.Instance.TextboxBackground.Textbox.Text = p5.Value or ""
end

return t1
