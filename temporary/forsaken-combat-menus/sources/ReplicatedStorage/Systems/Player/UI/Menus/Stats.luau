local t1 = {}
local DataHandler = require(game.ReplicatedStorage.Modules.DataHandler)

function t1.Start(_) -- line: 5
	-- upvalues: DataHandler (copy), t1 (copy)
	local _ = game.Players.LocalPlayer
	local Stats = DataHandler:Get():WaitForChild("Stats")

	t1.StatsMenu = require(game.ReplicatedStorage.Initializer).PlayerSystems.SidebarHandler:CreateSidebarMenu("Stats", script.StatsScreen)

	local Contents = t1.StatsMenu.Menu.StatsContainer.Contents
	local Templates = script.Templates

	local function createStatUI(p2, p3) -- line: 24
		-- upvalues: Templates (copy), Contents (copy), createStatUI (copy)
		if not p3 then
			p3 = 0
		end

		local LayoutOrder = p2:GetAttribute("LayoutOrder")

		if not LayoutOrder then
			return
		end

		local DisplayTitle = p2:GetAttribute("DisplayTitle")

		if not DisplayTitle then
			return
		end

		local PostDisplayTitle = p2:GetAttribute("PostDisplayTitle")

		if p2:IsA("Folder") then
			local clone = Templates.Seperator:Clone()

			clone.Name = p2.Name
			clone.LayoutOrder = LayoutOrder * 100 + p3
			clone.Title.Text = DisplayTitle
			clone.Parent = Contents

			for _, child in pairs(p2:GetChildren()) do
				createStatUI(child, LayoutOrder * 100)
			end

			return
		end

		if p2:IsA("NumberValue") then
			local clone = Templates.Title:Clone()

			clone.Name = p2.Name
			clone.LayoutOrder = LayoutOrder + p3
			clone.Parent = Contents

			local function setText() -- line: 51
				-- upvalues: PostDisplayTitle (copy), clone (copy), DisplayTitle (copy), p2 (copy)
				if PostDisplayTitle == "Time" then
					local Util = require(game.ReplicatedStorage.Modules.Util)

					clone.Text = `{ DisplayTitle }: { Util:FormatTime(p2.Value, "String") }`
				else
					clone.Text = `{ DisplayTitle }: { p2.Value }{ PostDisplayTitle or "" }`
				end

				if p2:GetAttribute("HideIfZero") then
					clone.Visible = p2.Value ~= 0
				end
			end

			p2:GetPropertyChangedSignal("Value"):Connect(setText)
			setText()
		end
	end

	for _, child in pairs(Stats:GetChildren()) do
		createStatUI(child)
	end
end

return t1
