local t1 = {}
local DataHandler = require(game.ReplicatedStorage.Modules.DataHandler)
local t2 = {
	Objective = {
		Font = "Bodoni",
		TextColor3 = Color3.new(1, 1, 1),
		Size = UDim2.new(0.8, 0, 0, 32)
	}
}

local function createNotif(p1, p2) -- line: 17
	-- upvalues: t1 (copy)
	for _, child in pairs(p1:GetChildren()) do
		if child.Name == "ProductPurchaseNotif" then
			child:SetAttribute("CurrentPos", (child:GetAttribute("CurrentPos") or child.Position) + UDim2.fromScale(0, (child.Size.Y.Offset + 20) / workspace.CurrentCamera.ViewportSize.Y))
			game.TweenService:Create(child, TweenInfo.new(0.2), {
				Position = child:GetAttribute("CurrentPos")
			}):Play()
		end
	end

	if #t1 + 1 > 3 then
		t1[1]:Destroy()
		table.remove(t1, 1)
	end

	local clone = script.Notif:Clone()

	clone.Name = "ProductPurchaseNotif"
	clone.Text = p2
	clone.Position = UDim2.new(0.5, 0, -clone.Size.X.Scale, -clone.Size.X.Offset)
	if require(game.ReplicatedStorage.Modules.Device):GetPlayerDevice()=="Mobile"then
        clone.Size=UDim2.new(clone.Size.X.Scale*.85,clone.Size.X.Offset,clone.Size.Y.Scale,math.max(18,clone.Size.Y.Offset*.75));clone.TextSize=math.max(12,clone.TextSize*.8)
    end
    clone.Parent = p1
	clone:SetAttribute("CurrentPos", script.Notif.Position)
	game.TweenService:Create(clone, TweenInfo.new(0.2), {
		Position = clone:GetAttribute("CurrentPos")
	}):Play()
	table.insert(t1, clone)
	task.delay(7, function() -- line: 45
		-- upvalues: clone (copy)
		game.TweenService:Create(clone, TweenInfo.new(3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			TextTransparency = 1,
			TextStrokeTransparency = 1
		}):Play()

		for _, descendant in (clone:GetDescendants()) do
			if descendant:IsA("UIStroke") then
				game.TweenService:Create(descendant, TweenInfo.new(3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
					Transparency = 1
				}):Play()
			end
		end

		game.Debris:AddItem(clone, 3)
	end)

	return clone
end
local function __displayNotification(p3, s1: string, p4) -- line: 61
	-- upvalues: DataHandler (copy), createNotif (copy), t2 (copy)
	if p4 == "Objective" and DataHandler:ReadPath("Settings/Customization/EXPCashNotifsDisabled").Value then
		return
	end

	local v14 = createNotif(p3, s1)

	if v14 then
		if typeof(p4) == "string" then
			local v15 = t2[p4]

			for k, v in pairs(v15 or {}) do
				v14[k] = v
			end

			return v14
		end

		if typeof(p4) == "Color3" then
			v14.TextColor3 = p4
		end
	end

	return v14
end

return {
	Start = function(p5) -- line: 90
    if p5.ClientPolishCleanup then p5.ClientPolishCleanup()end
    p5.ClientPolishCleanup=require(game.ReplicatedStorage.Modules.ClientPolish).Start()
		-- upvalues: __displayNotification (copy)
		local ScreenGui = Instance.new("ScreenGui")

		ScreenGui.Name = "Notis"
		ScreenGui.DisplayOrder = 999
		ScreenGui.ResetOnSpawn = false
		ScreenGui.IgnoreGuiInset = false
		ScreenGui.Parent = game.Players.LocalPlayer.PlayerGui
		p5.UI = ScreenGui
		require(game.ReplicatedStorage.Modules.Network):SetConnection("SendNotif", "REMOTE_EVENT", function(p6, p7) -- line: 103
			-- upvalues: __displayNotification (copy), ScreenGui (copy)
			__displayNotification(ScreenGui, p6, p7)
		end)
	end,
	DisplayNotification = function(t3: {[any]: any}, s2: string, p8) -- line: 108
		-- upvalues: __displayNotification (copy)
		return __displayNotification(t3.UI, s2, p8)
	end
}

