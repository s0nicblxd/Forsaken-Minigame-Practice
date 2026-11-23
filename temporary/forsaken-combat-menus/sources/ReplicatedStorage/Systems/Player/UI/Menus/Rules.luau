local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Initializer = require(game.ReplicatedStorage.Initializer)
local Sounds = require(ReplicatedStorage.Modules.Sounds)
local _ = Players.LocalPlayer.PlayerGui
local UpdatelogPresets = ReplicatedStorage.Assets.UI.UpdatelogPresets
local tweenInfo = TweenInfo.new(0.2)
local t1 = {}

function t1.Start(_) -- line: 20
	-- upvalues: t1 (copy), Initializer (copy), ReplicatedStorage (copy), UpdatelogPresets (copy), TweenService (copy), tweenInfo (copy), Sounds (copy)
	t1.RulesMenu = Initializer.PlayerSystems.SidebarHandler:CreateSidebarMenu("Rules", script.RulesScreen)

	local ok, result = pcall(function() -- line: 24
		-- upvalues: ReplicatedStorage (copy)
		return require(ReplicatedStorage.Assets.Rules)
	end)

	if not ok then
		warn(`[{ script }]: Failed to get the rules due to: { result }`)

		return
	end

	local n1 = 1

	for i = 1, #result do
		local v15 = result[i]
		local clone = UpdatelogPresets.Components.Header:Clone()

		clone.Text = v15.Header
		clone.LayoutOrder = n1
		clone.Parent = t1.RulesMenu.Menu.RulesContainer.Contents

		local clone2 = UpdatelogPresets.Components.Seperator:Clone()

		clone2.LayoutOrder = n1 + 1
		clone2.Parent = t1.RulesMenu.Menu.RulesContainer.Contents

		local clone3 = UpdatelogPresets.Components.TextPreset:Clone()

		clone3.Main.Text = v15.Body
		clone3.AutomaticSize = Enum.AutomaticSize.None
		clone3.Size = v15.NoteSize or UDim2.fromScale(0.9, 0.5)
		clone3.LayoutOrder = n1 + 2
		clone3.Parent = t1.RulesMenu.Menu.RulesContainer.Contents
		n1 += 3
	end

	local Exit = t1.RulesMenu.Menu.RulesContainer.Exit

	Exit.MouseEnter:Connect(function() -- line: 60
		-- upvalues: TweenService (copy), Exit (copy), tweenInfo (copy), Sounds (copy)
		TweenService:Create(Exit, tweenInfo, {
			Size = UDim2.fromScale(0.175, 0.175)
		}):Play()
		Sounds:Play("hover")
	end)
	Exit.MouseLeave:Connect(function() -- line: 65
		-- upvalues: TweenService (copy), Exit (copy), tweenInfo (copy), Sounds (copy)
		TweenService:Create(Exit, tweenInfo, {
			Size = UDim2.fromScale(0.15, 0.15)
		}):Play()
		Sounds:Play("hoverEnd")
	end)
	Exit.MouseButton1Click:Connect(function() -- line: 70
		-- upvalues: t1 (copy)
		t1.RulesMenu:ToggleMenu(false)
	end)
end

return t1
