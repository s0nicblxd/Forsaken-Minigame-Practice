local t2 = {
	TransparentParts = {},
	GetMousePos = function(_: {[any]: any}, p1, b1: boolean) -- line: 21
		local LocalPlayer = game.Players.LocalPlayer
		local CurrentCamera = workspace.CurrentCamera
		local Mouse = LocalPlayer:GetMouse()
		local Character = LocalPlayer.Character
		local Device = require(game.ReplicatedStorage.Modules.Device)
		local SmoothShiftLock = require(game.ReplicatedStorage.Systems.Player.Game.SmoothShiftLock)

		if Character then
			Character:FindFirstChild("Head")
		end

		local v11 = (CurrentCamera.CFrame.Position - CurrentCamera.Focus.Position).Magnitude < 0.6

		local settings=require(game.ReplicatedStorage.Modules.Util):GetSettingValue("ProjectileShiftlockAiming")
        if settings and (SmoothShiftLock.Enabled or v11) and not b1 then
			if Device:GetPlayerDevice() == "Mobile" then
				return (workspace.CurrentCamera.CFrame * CFrame.new(0, 0, -250)).Position
			end

			local v12 = CurrentCamera:ScreenPointToRay(Mouse.X, Mouse.Y)

			return v12.Origin + v12.Direction * 500
		end

		if p1 then
			local Util = require(game.ReplicatedStorage.Modules.Util)
			local ClosestPlayerFromPosition = Util:GetClosestPlayerFromPosition(Character and (not not Character.PrimaryPart and Character.PrimaryPart.Position) or Vector3.new(), {
				PlayerSelection = "Survivors",
				ReturnTable = true
			})

			for _, v in pairs(ClosestPlayerFromPosition) do
				local Player = v.Player
				local Distance = v.Distance

				if Util:IsOnScreen(Player) and Distance then
					local PrimaryPartPosition = Player.PrimaryPart.Position
					local AssemblyLinearVelocity = Player.PrimaryPart.AssemblyLinearVelocity
					local Magnitude = AssemblyLinearVelocity.Magnitude
					local v22 = typeof(p1) ~= "number" and 50 or p1

					if Magnitude == 0 then
						return PrimaryPartPosition
					end

					return PrimaryPartPosition + AssemblyLinearVelocity * (Distance / v22)
				end
			end

			return (workspace.CurrentCamera.CFrame * CFrame.new(0, 0, -500)).Position
		end

		local function validate(p2) -- line: 72
			local v36 = p2.Parent:FindFirstChild("Humanoid") or p2:GetAttribute("Hitbox")
			local v37 = v36 or (p2.Transparency < 0.75 and p2.CollisionGroup == "Default" or v36)

			if v36 then
				if p2.Parent ~= (game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character.Parent) then
				end
			end

			return v37
		end

		local CFramePosition, v25

		if Device:GetPlayerDevice() == "Console" then
            CFramePosition = workspace.CurrentCamera.CFrame.Position
            v25 = workspace.CurrentCamera.CFrame.LookVector * 500
		else
			local v26 = CurrentCamera:ScreenPointToRay(Mouse.X, Mouse.Y)

			CFramePosition = v26.Origin
			v25 = v26.Direction * 500
		end

		local raycastParams = RaycastParams.new()

		raycastParams.FilterType = Enum.RaycastFilterType.Exclude
		raycastParams.FilterDescendantsInstances = {}
		raycastParams.IgnoreWater = true

		if LocalPlayer.Character then
			raycastParams:AddToFilter(LocalPlayer.Character)
		end

		local raycastResult = nil

		repeat
			if raycastResult then
				raycastParams:AddToFilter(raycastResult.Instance)

				local Magnitude = (CFramePosition - raycastResult.Position).Magnitude
				local v30 = math.max(v25.Magnitude - Magnitude, 0)

				if v30 <= 0 then
					break
				end

				CFramePosition = raycastResult.Position
				v25 = v25.Unit * v30
			end

			raycastResult = workspace:Raycast(CFramePosition + v25.Unit * 8, v25.Unit * (v25.Magnitude - 8), raycastParams)
		until not raycastResult or validate(raycastResult.Instance)

		if raycastResult then
			return raycastResult.Position
		end

		return CFramePosition + v25
	end,
	GetCameraCFrame = function(_) -- line: 127
		return workspace.CurrentCamera.CFrame
	end
}

function t2.Start(_) -- line: 131
	-- upvalues: t2 (copy)
	local function addToRegistry(p5) -- line: 132
		-- upvalues: t2 (copy)
		if p5:IsA("BasePart") and (p5.Transparency >= 0.75 or p5.Parent == workspace.Hitboxes) then
			t2.TransparentParts[p5] = true
		end
	end

	task.spawn(function() -- line: 138
		-- upvalues: t2 (copy), addToRegistry (copy)
		for _, descendant in pairs(workspace:GetDescendants()) do
			if descendant:IsA("BasePart") and (descendant.Transparency >= 0.75 or descendant.Parent == workspace.Hitboxes) then
				t2.TransparentParts[descendant] = true
			end
		end

		workspace.DescendantAdded:Connect(addToRegistry)
		workspace.DescendantRemoving:Connect(function(descendant) -- line: 141
			-- upvalues: t2 (copy)
			if t2.TransparentParts[descendant] then
				t2.TransparentParts[descendant] = nil
			end
		end)
	end)

	local Network = require(game.ReplicatedStorage.Modules.Network)

	Network:SetConnection("GetMousePosition", "REMOTE_FUNCTION", function(...) -- line: 150
		-- upvalues: t2 (copy)
		print(t2:GetMousePos(...))

		return t2:GetMousePos(...)
	end)
	Network:SetConnection("GetCameraCFrame", "REMOTE_FUNCTION", function(...) -- line: 155
		-- upvalues: t2 (copy)
		return t2:GetCameraCFrame(...)
	end)
end

return t2

