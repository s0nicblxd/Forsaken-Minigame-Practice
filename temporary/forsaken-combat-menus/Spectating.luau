local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Sounds = require(ReplicatedStorage.Modules.Sounds)

require(ReplicatedStorage.Initializer)

local Network = require(ReplicatedStorage.Modules.Network)
local SidebarHandler = require(ReplicatedStorage.Systems.Player.UI.SidebarHandler)
local Device = require(ReplicatedStorage.Modules.Device)
local tweenInfo = TweenInfo.new(0.25)
local _ = ReplicatedStorage.Assets.Sounds.SFX.Menu
local t1 = {
	CurrentIndx = 1,
	CurrentHumanoid = nil,
	Spectating = false,
	Connections = {
		HealthConnection = nil,
		DeathConnection = nil
	}
}

local function changeProp(p1, p2, p3) -- line: 38
	if p3 ~= p1[p2] then
		p1[p2] = p3
	end
end

function t1.Toggle(_, p5) -- line: 44
	-- upvalues: SidebarHandler (copy), t1 (copy), RunService (copy)
	workspace:FindFirstChild("Ragdolls")

	local LocalPlayer = game.Players.LocalPlayer
	local Character = LocalPlayer.Character
	local v20 = Character and Character:FindFirstChild("Humanoid")
	local _ = SidebarHandler.Sidebar.Middle.Spectate

	if not v20 then
		return
	end

	if LocalPlayer.Character.Parent ~= workspace.Players.Spectating then
		p5 = false
	end

	if not p5 then
		for v22, v23 in t1.Connections do
			pcall(function() -- line: 61
				-- upvalues: v23 (copy), RunService (copy), v22 (copy)
				v23:Disconnect()

				if RunService:IsStudio() then
					warn(`[{ script:GetFullName() }]: Removed event: { v22 } from Spectating.`)
				end
			end)
			t1.Connections[v22] = nil
		end
	end

	t1.UI.Visible = p5
	workspace.CurrentCamera.CameraSubject = v20

	local Spectate = SidebarHandler.SidebarButtons.Spectate

	if Spectate then
		Spectate:SetAppearanceState(p5)
	end

	t1.Spectating = p5
end
function t1.Start(_) -- line: 83
	-- upvalues: RunService (copy), t1 (copy), Network (copy), Device (copy), Sounds (copy), TweenService (copy), tweenInfo (copy), UserInputService (copy), SidebarHandler (copy)
	if RunService:IsClient() then
		local LocalPlayer = game.Players.LocalPlayer

		t1.UI = script.Spectate:Clone()
		t1.UI.Visible = false
		t1.UI.Parent = LocalPlayer.PlayerGui:WaitForChild("MainUI")

		local function fuckOff() -- line: 92
			-- upvalues: Network (copy)
			Network:FireServerConnection("UpdateHeartbeatAsync", "REMOTE_EVENT", 53643)
		end
		local function playerAdded(p7) -- line: 96
			-- upvalues: Network (copy)
			local t2 = {
				"Name",
				"DisplayName",
				"UserId"
			}

			p7.Changed:Connect(function(property) -- line: 99
				-- upvalues: t2 (copy), Network (copy)
				if table.find(t2, property) then
					Network:FireServerConnection("UpdateHeartbeatAsync", "REMOTE_EVENT", 53643)
				end
			end)
		end
		local function adjustSpectatorIndex(n1: number) -- line: 107
			-- upvalues: LocalPlayer (copy), t1 (copy), adjustSpectatorIndex (copy)
			if LocalPlayer.Character.Parent ~= workspace.Players.Spectating then
				return
			end

			local v41 = t1

			v41.CurrentIndx = v41.CurrentIndx + n1

			local t3 = {}

			local function addToSpectatorTable(p8) -- line: 116
				-- upvalues: t3 (copy)
				local Humanoid = p8:FindFirstChild("Humanoid")

				if Humanoid and (Humanoid.Parent and Humanoid.Health > 0) then
					table.insert(t3, p8)
				end
			end
			local function updateHealth(p9) -- line: 123
				-- upvalues: t1 (copy)
				if not p9 then
					return
				end

				local v79 = p9.Health / p9.MaxHealth

				t1.UI.Health.Text = `{ math.round(v79 * 100) }%`
				t1.UI.Health.TextColor3 = Color3.fromHSV(v79 / 3, 1, 1)
			end
			local function setHealthConnection(p10) -- line: 131
				-- upvalues: t1 (copy), adjustSpectatorIndex (copy)
				pcall(function() -- line: 133
					-- upvalues: t1 (copy)
					t1.Connections.HealthConnection:Disconnect()
				end)
				pcall(function() -- line: 134
					-- upvalues: t1 (copy)
					t1.Connections.DeathConnection:Disconnect()
				end)
				pcall(function() -- line: 135
					-- upvalues: t1 (copy)
					t1.Connections.GoneConnection:Disconnect()
				end)

				local _ = p10.Parent

				if p10.Health > 0 then
					t1.Connections.DeathConnection = p10.Died:Once(function() -- line: 140
						-- upvalues: t1 (copy), p10 (copy), adjustSpectatorIndex (copy)
						task.delay(3, function() -- line: 141
							-- upvalues: t1 (copy), p10 (copy), adjustSpectatorIndex (copy)
							if t1.CurrentHumanoid == p10 and t1.UI.Visible then
								adjustSpectatorIndex(1)
							end
						end)
					end)
					t1.Connections.GoneConnection = p10.AncestryChanged:Once(function(_, _) -- line: 147
						-- upvalues: adjustSpectatorIndex (copy)
						adjustSpectatorIndex(1)
					end)
				end

				t1.Connections.HealthConnection = p10:GetPropertyChangedSignal("Health"):Connect(function() -- line: 152
					-- upvalues: p10 (copy), t1 (copy)
					local v84 = p10

					if not v84 then
						return
					end

					local v85 = v84.Health / v84.MaxHealth

					t1.UI.Health.Text = `{ math.round(v85 * 100) }%`
					t1.UI.Health.TextColor3 = Color3.fromHSV(v85 / 3, 1, 1)
				end)
			end

			for _, child in pairs(workspace.Players.Killers:GetChildren()) do
				local Humanoid = child:FindFirstChild("Humanoid")

				if Humanoid and Humanoid.Parent and Humanoid.Health > 0 then
					table.insert(t3, child)
				end
			end

			for _, child in pairs(workspace.Players.Survivors:GetChildren()) do
				local Humanoid = child:FindFirstChild("Humanoid")

				if Humanoid and Humanoid.Parent and Humanoid.Health > 0 then
					table.insert(t3, child)
				end
			end

			local v52 = t3[t1.CurrentIndx % #t3 + 1]
			local v53 = v52 and v52:FindFirstChild("Humanoid")

			if v53 then
				t1.CurrentHumanoid = v53

				local v54 = v52:GetAttribute("Username") or v52.Name
				local v55 = v52:GetAttribute("ActorDisplayName") or v52.Name
				local SkinNameDisplay = v52:GetAttribute("SkinNameDisplay")
				local v57 = `{ v55 } { SkinNameDisplay ~= nil and (SkinNameDisplay ~= "" and `({ SkinNameDisplay })`) or "" }`

				t1.UI.Username.Text = v54
				t1.UI.ActorName.Text = v57

				if t1.UI.Visible then
					workspace.CurrentCamera.CameraSubject = v53
				end

				if v53 then
					local v58 = v53.Health / v53.MaxHealth

					t1.UI.Health.Text = `{ math.round(v58 * 100) }%`
					t1.UI.Health.TextColor3 = Color3.fromHSV(v58 / 3, 1, 1)
				end

				setHealthConnection(v53)
			end
		end

		local PlayerDevice = Device:GetPlayerDevice()
		local t4 = {}
		local t5 = {
			Console = {
				[Enum.KeyCode.DPadLeft] = -1,
				[Enum.KeyCode.DPadRight] = 1
			},
			PC = {
				[Enum.KeyCode.Q] = -1,
				[Enum.KeyCode.E] = 1
			}
		}

		local function __checkBind(p13) -- line: 208
			-- upvalues: t4 (copy), PlayerDevice (ref)
			local v60 = t4[p13.Name]

			if v60 then
				v60.Visible = false
				t4[p13.Name] = nil
			end

			local v61 = p13:FindFirstChild(`{ PlayerDevice }Keybind`)

			if v61 then
				t4[p13.Name] = v61
				v61.Visible = true
			end
		end

		for v34, v35 in {
			t1.UI.Next,
			t1.UI.Back
		} do
			local v36 = t4[v35.Name]

			if v36 then
				v36.Visible = false
				t4[v35.Name] = nil
			end

			local v37 = v35:FindFirstChild(`{ PlayerDevice }Keybind`)

			if v37 then
				t4[v35.Name] = v37
				v37.Visible = true
			end

			Device.Changed:Connect(function(property: string) -- line: 224
				-- upvalues: PlayerDevice (ref), v35 (copy), t4 (copy)
				PlayerDevice = property

				local v63 = v35
				local v64 = t4[v63.Name]

				if v64 then
					v64.Visible = false
					t4[v63.Name] = nil
				end

				local v65 = v63:FindFirstChild(`{ PlayerDevice }Keybind`)

				if v65 then
					t4[v63.Name] = v65
					v65.Visible = true
				end
			end)
			v35.MouseButton1Click:Connect(function() -- line: 229
				-- upvalues: Sounds (copy), adjustSpectatorIndex (copy), v34 (copy)
				Sounds:Play("rbxassetid://112519459573278")
				adjustSpectatorIndex(v34 ~= 1 and -1 or 1)
			end)
			v35.MouseEnter:Connect(function() -- line: 234
				-- upvalues: Sounds (copy), TweenService (copy), v35 (copy), tweenInfo (copy)
				Sounds:Play("tick")
				TweenService:Create(v35, tweenInfo, {
					Size = UDim2.fromScale(0.25, 1.05)
				}):Play()
			end)
			v35.MouseLeave:Connect(function() -- line: 239
				-- upvalues: Sounds (copy), TweenService (copy), v35 (copy), tweenInfo (copy)
				Sounds:Play("tick")
				TweenService:Create(v35, tweenInfo, {
					Size = UDim2.fromScale(0.2, 1)
				}):Play()
			end)
		end

		UserInputService.InputBegan:Connect(function(input, gameProcessed: boolean) -- line: 245
			-- upvalues: t1 (copy), t5 (copy), PlayerDevice (ref), Sounds (copy), adjustSpectatorIndex (copy)
			if gameProcessed then
				return
			end

			if not t1.Spectating then
				return
			end

			local v68 = t5[PlayerDevice]
			local v69 = v68 and v68[input.KeyCode]

			if v69 then
				Sounds:Play("rbxassetid://112519459573278")
				adjustSpectatorIndex(v69)
			end
		end)
		SidebarHandler.Sidebar.Middle.Spectate.Button.MouseButton1Click:Connect(function() -- line: 267
			-- upvalues: SidebarHandler (copy), Sounds (copy), t1 (copy), adjustSpectatorIndex (copy)
			if SidebarHandler.MenusHidden then
				return
			end

			Sounds:Play("select")
			t1:Toggle(not t1.Spectating)

			if not t1.Spectating == false then
				adjustSpectatorIndex(0)
			end
		end)
		t1.UI.Username.Changed:Connect(function(property) -- line: 280
			-- upvalues: t1 (copy), Network (copy)
			if property ~= "Text" then
				return
			end

			local UsernameText = t1.UI.Username.Text
			local v72 = t1.CurrentHumanoid and t1.CurrentHumanoid.Parent
			local v73 = v72 and v72:GetAttribute("Username")
			local v74 = v72 and game.Players:GetPlayerFromCharacter(v72)

			if not v72 then
				return
			end

			if v74 and v73 then
				if v73 ~= UsernameText then
					Network:FireServerConnection("UpdateHeartbeatAsync", "REMOTE_EVENT", 53643)

					return
				end
			elseif v74 and not v73 then
				Network:FireServerConnection("UpdateHeartbeatAsync", "REMOTE_EVENT", 53643)
			end
		end)
		game.Players.PlayerAdded:Connect(playerAdded)
	end
end

return t1

