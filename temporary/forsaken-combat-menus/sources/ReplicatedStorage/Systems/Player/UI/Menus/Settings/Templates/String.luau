local t1 = {}

t1.__index = t1

local n1 = 10

function t1.CreateSettingUI(_, p2, p3, p4) -- line: 5
	-- upvalues: t1 (copy), n1 (ref)
	local Sounds = require(game.ReplicatedStorage.Modules.Sounds)

	if not p2 then
		p2 = Instance.new("StringValue")
		p2.Name = "SettingValue"
	end

	local v9 = setmetatable({
		SettingValue = p2
	}, t1)

	v9.Value = p2.Value
	v9.Instance = p3 or script.Dropdown:Clone()
	v9.DropdownVisible = false
	v9.Instance.DropdownFrame.Options:FindFirstChildOfClass("UIListLayout").SortOrder = Enum.SortOrder.LayoutOrder
	v9.Instance.DropdownFrame.MouseButton1Click:Connect(function() -- line: 21
		-- upvalues: Sounds (copy), v9 (copy), n1 (ref), p2 (ref), p4 (copy)
		Sounds:Play("click")
		v9.DropdownVisible = not v9.DropdownVisible
		v9.Instance.DropdownFrame.DropdownArrow.Rotation = not v9.DropdownVisible and 0 or 180
		v9.Instance.DropdownFrame.Options.Visible = v9.DropdownVisible
		n1 += 1
		v9.Instance.ZIndex = n1

		for _, child in pairs(v9.Instance.DropdownFrame.Options:GetChildren()) do
			if child:IsA("GuiObject") then
				child:Destroy()
			end
		end

		local v13 = p2:GetAttribute("Options") and string.split(p2:GetAttribute("Options"), "|")

		for k, v in pairs(v13 or {}) do
			local clone = script.DropdownOption:Clone()

			clone.Name = v
			clone.LayoutOrder = k
			clone.Title.Text = clone.Name
			clone.Parent = v9.Instance.DropdownFrame.Options
			clone.MouseButton1Click:Connect(function() -- line: 46
				-- upvalues: p2 (ref), v (copy), v9 (copy), p4 (copy), Sounds (copy)
				if p2.Name ~= "SettingValue" and p2.Name ~= "Value" then
					require(game.ReplicatedStorage.Modules.Network):FireServerConnection("UpdateSettings", "REMOTE_EVENT", p2, v)
				else
					v9.Value = v
					v9:OnUpdate()

					if p4 then
						p4(v9.Value)
					end
				end

				Sounds:Play("switch")
			end)
		end
	end)

	return v9
end
function t1.OnUpdate(p5) -- line: 63
	p5.Instance.DropdownFrame.ChosenValue.Title.Text = p5.Value
	p5.Instance.DropdownFrame.Options.Visible = false
	p5.Instance.DropdownFrame.DropdownArrow.Rotation = 0
	p5.DropdownVisible = false
end

return t1
