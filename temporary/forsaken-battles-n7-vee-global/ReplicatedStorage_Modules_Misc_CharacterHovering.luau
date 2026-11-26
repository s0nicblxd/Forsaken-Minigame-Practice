local t1 = {
	HighlightTweenTime = 0.125,
	HoverRange = 30,
	HoveredCharacter = nil,
	Hovered = nil,
	HoverEnded = nil,
	Clicked = nil,
	HoverData = {},
	HoverableCharacters = {},
	Connections = {}
}

function t1.AddHoverableCharacter(_, p2) -- line: 18
	-- upvalues: t1 (copy)
	if p2 and p2 ~= game.Players.LocalPlayer.Character then
		t1.HoverableCharacters[p2] = true
	end
end
function t1.RemoveHoverableCharacter(_, p4) -- line: 24
	-- upvalues: t1 (copy)
	if p4 and p4 ~= game.Players.LocalPlayer.Character then
		t1.HoverableCharacters[p4] = nil
	end
end
function t1.ToggleHoverHighlight(_, p6, p7, p8) -- line: 30
	-- upvalues: t1 (copy)
	if not t1.HoverData[p6] then
		t1.HoverData[p6] = {
			Highlight = nil,
			Hovers = {}
		}
	end

	t1.HoverData[p6].Hovers[p7] = p8 or nil

	local n1 = 0

	for _, v in pairs(t1.HoverData[p6].Hovers) do
		if v then
			n1 += 1
		end
	end

	if n1 > 0 and not t1.HoverData[p6].Highlight then
		local Highlight = Instance.new("Highlight")

		Highlight.Name = "CharacterHoverHighlight"
		Highlight.OutlineTransparency = 1
		Highlight.FillTransparency = 1
		Highlight.FillColor = Color3.new(1, 1, 1)
		Highlight.Parent = p6
		Highlight.Adornee = p6
		game.TweenService:Create(Highlight, TweenInfo.new(t1.HighlightTweenTime), {
			OutlineTransparency = 0.5,
			FillTransparency = 0.9
		}):Play()
		t1.HoverData[p6].Highlight = Highlight
		t1.__hoveredEvent:Fire(p6)

		return
	end

	if n1 <= 0 and t1.HoverData[p6].Highlight then
		local Highlight = t1.HoverData[p6].Highlight

		Highlight.Name = "Disappearing"
		game.TweenService:Create(Highlight, TweenInfo.new(t1.HighlightTweenTime), {
			FillTransparency = 1,
			OutlineTransparency = 1
		}):Play()
		game.Debris:AddItem(Highlight, t1.HighlightTweenTime)
		t1.HoverData[p6] = nil
		t1.__hoverEndedEvent:Fire(p6)
	end
end
function t1.Init(_) -- line: 81
	-- upvalues: t1 (copy)
	if game["Run Service"]:IsServer() then
		return
	end

	local t2 = {
		Hovered = "__hovered",
		HoverEnded = "__hoverEnded",
		Clicked = "__clicked"
	}

	for k, v in pairs(t2) do
		local v19 = v .. "Event"

		t1[v19] = Instance.new("BindableEvent")
		t1[v19].Name = v
		t1[v19].Parent = script
		t1[k] = t1[v19].Event
	end
end
function t1.Start(_) -- line: 102
	-- upvalues: t1 (copy)
	if game["Run Service"]:IsServer() then
		return
	end

	local LocalPlayer = game.Players.LocalPlayer
	local Mouse = LocalPlayer:GetMouse()
	local u23 = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	local Parent = u23.Parent
	local u25 = u23 and u23.PrimaryPart or u23:WaitForChild("HumanoidRootPart", 5)

	LocalPlayer.CharacterAdded:Connect(function(character) -- line: 115
		-- upvalues: u23 (ref), Parent (ref), u25 (ref), t1 (copy)
		u23 = character
		Parent = character.Parent
		u25 = u23 and u23.PrimaryPart or u23:WaitForChild("HumanoidRootPart", 5)

		for _, v in pairs(t1.HoverData) do
			if v.Highlight then
				v.Highlight:Destroy()
			end
		end

		t1.HoverData = {}
		t1.HoverableCharacters = {}
	end)
    local pending={}
    t1.Connections.ClickConnection = game.UserInputService.InputBegan:Connect(function(input,processed)
        if processed or not t1.HoveredCharacter then return end
        if input.KeyCode==Enum.KeyCode.ButtonA then
            if game:GetService("GuiService").SelectedObject then return end
            t1.__clickedEvent:Fire(t1.HoveredCharacter);return
        end
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            pending[input]={target=t1.HoveredCharacter,position=input.Position,at=os.clock(),camera=workspace.CurrentCamera and workspace.CurrentCamera.CFrame}
        end
    end)
    t1.Connections.ClickRelease = game.UserInputService.InputEnded:Connect(function(input,processed)
        local entry=pending[input];pending[input]=nil
        if not entry or processed or os.clock()-entry.at>.6 or(input.Position-entry.position).Magnitude>12 then return end
        local camera=workspace.CurrentCamera
        if camera and entry.camera and camera.CFrame.LookVector:Dot(entry.camera.LookVector)<.999 then return end
        if entry.target.Parent then t1.__clickedEvent:Fire(entry.target)end
    end)
	t1.Connections.HoverConnection = game["Run Service"].RenderStepped:Connect(function() -- line: 144
		-- upvalues: Mouse (copy), t1 (copy), u25 (ref)
		local MouseTarget = Mouse.Target
		local v33 = MouseTarget and MouseTarget.Parent

		if v33 ~= t1.HoveredCharacter then
			if t1.HoveredCharacter then
				t1:ToggleHoverHighlight(t1.HoveredCharacter, "DefaultHover", false)
				t1.HoveredCharacter = nil
			end

			local v34 = Mouse.Hit and Mouse.Hit.Position - (u25 and u25.Position or Vector3.new(0, 0, 0))
			local v35 = v34 and v34.Magnitude or 9999

			if v33 ~= t1.HoveredCharacter and t1.HoverableCharacters[v33] and v35 <= t1.HoverRange then
				t1:ToggleHoverHighlight(v33, "DefaultHover", true)
				t1.HoveredCharacter = v33
			end
		end
	end)
end

return t1

