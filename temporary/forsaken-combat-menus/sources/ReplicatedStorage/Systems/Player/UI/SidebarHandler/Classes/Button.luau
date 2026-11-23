local TweenService = game:GetService("TweenService")

game:GetService("ReplicatedStorage")

local Sounds = require(game.ReplicatedStorage.Modules.Sounds)
local Signal = require(game.ReplicatedStorage.Modules.Misc.Signal)
local tweenInfo = TweenInfo.new(0.25)
local t1 = {
	Middle = {
		Enter = UDim2.fromScale(0.985, 0.25),
		Exit = UDim2.fromScale(0.95, 0.22)
	},
	Bottom = {
		Enter = UDim2.fromScale(0.645, 0.18),
		Exit = UDim2.fromScale(0.606, 0.149)
	}
}
local t2 = {
	BG = {
		Active = {
			ImageColor3 = Color3.fromRGB(198, 198, 198)
		},
		Inactive = {
			ImageColor3 = Color3.fromRGB(8, 8, 8)
		}
	},
	GrungeMain = {
		Active = {
			ImageColor3 = Color3.fromRGB(0, 0, 0)
		},
		Inactive = {
			ImageColor3 = Color3.fromRGB(80, 80, 80)
		}
	},
	Grunge = {
		Active = {
			ImageColor3 = Color3.fromRGB(255, 255, 255)
		},
		Inactive = {
			ImageColor3 = Color3.fromRGB(0, 0, 0)
		}
	},
	Highlight = {
		Active = {
			ImageColor3 = Color3.fromRGB(0, 0, 0)
		},
		Inactive = {
			ImageColor3 = Color3.fromRGB(255, 255, 255)
		}
	},
	Icon = {
		Active = {
			ImageColor3 = Color3.fromRGB(0, 0, 0)
		},
		Inactive = {
			ImageColor3 = Color3.fromRGB(255, 255, 255)
		}
	},
	Line = {
		Active = {
			ImageColor3 = Color3.fromRGB(0, 0, 0)
		},
		Inactive = {
			ImageColor3 = Color3.fromRGB(255, 255, 255)
		}
	}
}
local t3 = {}

t3.__index = t3

function t3.new(p1, s1: string) -- line: 51
	-- upvalues: t3 (copy), Signal (copy), TweenService (copy), tweenInfo (copy), t1 (copy), Sounds (copy)
	assert(p1 and p1:IsA("Frame"), "Button.new() requires a button frame.")
	assert(not p1:GetAttribute("__ButtonInitialized"), `Button.new() was already called on '{ p1.Name }'`)
	p1:SetAttribute("__ButtonInitialized", true)

	local self = setmetatable({}, t3)

	self.Instance = p1
	self.onClick = Signal.new()
	self.Instance.MouseEnter:Connect(function() -- line: 60
		-- upvalues: TweenService (copy), self (copy), tweenInfo (copy), t1 (copy), s1 (copy), Sounds (copy)
		TweenService:Create(self.Instance, tweenInfo, {
			Size = t1[s1].Enter
		}):Play()
		Sounds:Play("hover")
	end)
	self.Instance.MouseLeave:Connect(function() -- line: 72
		-- upvalues: TweenService (copy), self (copy), tweenInfo (copy), t1 (copy), s1 (copy), Sounds (copy)
		TweenService:Create(self.Instance, tweenInfo, {
			Size = t1[s1].Exit
		}):Play()
		Sounds:Play("hoverEnd")
	end)

	return self
end
function t3.RegisterMenu(t4: {[any]: any}, t5: {[any]: any}) -- line: 87
	assert(t5 and (typeof(t5) == "table" and t5.ToggleMenu), "Button:RegisterMenu() requires a menu table with a ToggleMenu function.")
	assert(t4.Menu == nil, `Button '{ t4.Instance.Name }' already has a menu registered.`)
	t4.Menu = t5
	t4.Instance.Button.MouseButton1Click:Connect(function() -- line: 92
		-- upvalues: t4 (copy)
		t4.onClick:Fire()
		t4.Menu:ToggleMenu()
	end)
end
function t3.SetAppearanceState(t6: {[any]: any}, b1: boolean) -- line: 98
	-- upvalues: TweenService (copy), tweenInfo (copy), t2 (copy)
	assert(b1 ~= nil and typeof(b1) == "boolean", "Button:SetAppearanceState() requires a boolean state.")

	local Text = t6.Instance.Button:FindFirstChild("Text")

	for _, v17 in Text and Text:GetChildren() or {} do
		if v17:IsA("TextLabel") then
			TweenService:Create(v17, tweenInfo, {
				TextColor3 = b1 and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
			}):Play()
		elseif v17:IsA("ImageLabel") then
			TweenService:Create(v17, tweenInfo, {
				ImageColor3 = b1 and Color3.fromRGB(224, 224, 224) or Color3.fromRGB(0, 0, 0)
			}):Play()
		end
	end

	local v18 = not b1 and "Inactive" or "Active"

	for v19, v20 in t2 do
		local v21 = t6.Instance.Button:FindFirstChild(v19)

		if v21 then
			TweenService:Create(v21, tweenInfo, v20[v18]):Play()
		end
	end
end

return t3
