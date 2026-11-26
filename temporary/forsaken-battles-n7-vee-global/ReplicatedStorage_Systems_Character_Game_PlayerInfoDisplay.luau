local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local DataHandler = require(game.ReplicatedStorage.Modules.DataHandler)
local trove = require(game.ReplicatedStorage.Modules.Misc.Trove)
local Spring = require(game.ReplicatedStorage.Modules.Misc.Spring)

require(game.ReplicatedStorage.Modules.Misc.Thread)
require(game.ReplicatedStorage.Modules.Statuses)

local GameplayPolish=require(game.ReplicatedStorage.Modules.GameplayPolish)
local t1 = {}

function t1.Show(_) -- line: 23
	-- upvalues: t1 (copy)
	if t1.UI and t1.UI.Parent then
		t1.UI.Visible = true
	end
end

local t2 = {
	Side = {
		FillDirectionMaxCells = 1,
		NamesVisible = true,
		CellPadding = UDim2.new(0, 0, 0.15, 0),
		CellSize = UDim2.new(0.1, 0, 0.49, 0)
	},
	Stacked = {
		FillDirectionMaxCells = 2,
		NamesVisible = true,
		CellPadding = UDim2.new(0.375, 0, 0.15, 0),
		CellSize = UDim2.new(0.125, 0, 0.54, 0)
	},
	Icons = {
		FillDirectionMaxCells = 4,
		NamesVisible = false,
		CellPadding = UDim2.new(0.01, 0, 0.25, 0),
		CellSize = UDim2.new(0.2, 0, 1, 0)
	}
}

function t1.Start(_) -- line: 53
	-- upvalues: DataHandler (copy), t1 (copy), trove (copy), Spring (copy), RunService (copy), TweenService (copy), t2 (copy)
	local LocalPlayer = game.Players.LocalPlayer

	LocalPlayer:GetMouse()

	local Character = LocalPlayer.Character
	local Humanoid = Character:WaitForChild("Humanoid")
	local TemporaryUI = LocalPlayer.PlayerGui:WaitForChild("TemporaryUI")
	local v15 = DataHandler:ReadPath("Settings")
	local TweenService2 = game:GetService("TweenService")
	local Sprinting = require(game.ReplicatedStorage.Systems.Character.Game.Sprinting)
	local Util = require(game.ReplicatedStorage.Modules.Util)
	local clone = script.PlayerInfo:Clone()
	local PlayerIcon = clone.PlayerIcon

	clone.Visible = false
	clone.Parent = TemporaryUI
	t1.UI = clone

	local clone2 = script.CenterStaminaCounter:Clone()

	clone2.Visible = false
	clone2.ZIndex = 9999
	clone2.Parent = TemporaryUI

	local v22 = trove.new()
	local v23 = Spring.new(0.025, 0.05)
	local u24 = false

	local function __uninitializeCenterStaminaCounter() -- line: 81
		-- upvalues: u24 (ref), v22 (copy), RunService (copy)
		if not u24 then
			return
		end

		u24 = false
		v22:Clean()
		RunService:UnbindFromRenderStep("SpringCenterStaminaCounter")
	end
	local function __initializeCenterStaminaCounter() -- line: 92
		-- upvalues: u24 (ref), v23 (copy), RunService (copy), clone2 (copy), Character (copy), TweenService (copy), v22 (copy), v15 (copy)
		if u24 then
			return
		end

		u24 = true

		local function __bindToRenderStepMove() -- line: 99
			-- upvalues: v23 (copy), RunService (copy), clone2 (copy)
			local v119 = v23:Update(RunService.Heartbeat:Wait())

			clone2.Size = UDim2.fromScale(v119, v119)
		end
		local function __onGlitch() -- line: 104
			-- upvalues: Character (copy), TweenService (copy), clone2 (copy)
			if Character:GetAttribute("Glitching") then
				TweenService:Create(clone2, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
					TextTransparency = 1
				}):Play()

				return
			end

			TweenService:Create(clone2, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
				TextTransparency = 0
			}):Play()
		end
		local function __initializeConnections() -- line: 124
			-- upvalues: v22 (copy), Character (copy), __onGlitch (copy), RunService (copy), __bindToRenderStepMove (copy)
			v22:Connect(Character:GetAttributeChangedSignal("Glitching"), __onGlitch)
			RunService:BindToRenderStep("SpringCenterStaminaCounter", Enum.RenderPriority.Camera.Value, __bindToRenderStepMove)
		end

		clone2.Position = UDim2.fromScale(0.5, 0.525)
		v22:Connect(Character:GetAttributeChangedSignal("Glitching"), __onGlitch)
		RunService:BindToRenderStep("SpringCenterStaminaCounter", Enum.RenderPriority.Camera.Value, __bindToRenderStepMove)

		local CenterStaminaCounter = v15.Customization:FindFirstChild("CenterStaminaCounter")

		if CenterStaminaCounter then
			clone2.Visible = CenterStaminaCounter.Value
			v22:Connect(CenterStaminaCounter:GetPropertyChangedSignal("Value"), function() -- line: 135
				-- upvalues: clone2 (copy), CenterStaminaCounter (copy), v22 (copy), u24 (ref), RunService (copy), Character (copy), __onGlitch (copy), __bindToRenderStepMove (copy)
				clone2.Visible = CenterStaminaCounter.Value

				if v22 and not CenterStaminaCounter.Value then
					if not u24 then
						return
					end

					u24 = false
					v22:Clean()
					RunService:UnbindFromRenderStep("SpringCenterStaminaCounter")

					return
				end

				v22:Connect(Character:GetAttributeChangedSignal("Glitching"), __onGlitch)
				RunService:BindToRenderStep("SpringCenterStaminaCounter", Enum.RenderPriority.Camera.Value, __bindToRenderStepMove)
			end)
		end
	end

	task.spawn(function() -- line: 148
		-- upvalues: LocalPlayer (copy), PlayerIcon (copy)
		local UserId = LocalPlayer.UserId

		PlayerIcon.Image = game.Players:GetUserThumbnailAsync(UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
	end)

	t1.GameplayPolishCleanup=GameplayPolish.AttachHUD(Character,clone,clone2,script,Sprinting)
	local Stamina = clone.Bars.Stamina
 local ExhaustedBaseColor=Stamina.Bar.Clipping.Top.ImageColor3
	local Health = clone.Bars.Health

	local function updateBar(p3, p4, p5, p6) -- line: 159
		-- upvalues: TweenService2 (copy), Character (copy)
		if not p3.Parent then
			return
		end

		local v65 = math.clamp(p4 / p5, 0, 1)
		local v66 = if v65 ~= 0 then 1 / v65 else 0

		if p6 then
			p3.Bar.Clipping.Size = UDim2.fromScale(v65, 1)
			p3.Bar.Clipping.Top.Size = UDim2.fromScale(v66, 1)
		else
			TweenService2:Create(p3.Bar.Clipping, TweenInfo.new(1), {
				Size = UDim2.fromScale(v65, 1)
			}):Play()
			TweenService2:Create(p3.Bar.Clipping.Top, TweenInfo.new(1), {
				Size = UDim2.fromScale(v66, 1)
			}):Play()
		end

		if not Character:GetAttribute("CustomHealthDisplay") or p3.Name ~= "Health" then
			p3.Amount.Text = `{ math.round(p4) }/{ math.round(p5) }`
		end
	end

	local Icon = Stamina.Icon
	local UIGradient = Icon.UIGradient
	local UIGradientColor = UIGradient.Color
	local u33 = false
	local color3 = Color3.fromRGB(255, 67, 67)
	local color3_2 = Color3.fromRGB(127, 107, 107)
	local Amount = Stamina.Amount
	local AmountTextColor3 = Amount.TextColor3
	local Health2 = Humanoid.Health
	local Icon2 = Health.Icon
	local v40 = game.TweenService:Create(Icon2, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Position = Icon2.Position,
		Size = Icon2.Size,
		Rotation = Icon2.Rotation
	})

	local function addDamageEffect(p7) -- line: 203
		-- upvalues: Humanoid (copy), Health2 (ref), Util (copy), Icon2 (copy), v40 (copy)
		if not p7 then
			p7 = 0
		end

		local v68 = Humanoid:GetAttribute("FakeDamage") or 0
		local v69 = Humanoid.MaxHealth + p7
		local v70 = math.clamp(Humanoid.Health + p7 - v68, 0, v69)

		if v70 < Health2 then
			local v71 = Health2 - v70

			if p7 == 0 or v71 >= 0.2 then
				local v72 = math.clamp(v71 / (v69 / 2), 0.1, 1)
				local v73 = math.clamp(v71 / (v69 / 2), 0.1, 0.75)
				local v74 = math.clamp(1 - v72 / 2, 0, 1)

				Util:ApplyCameraShake(v72, v73)
				Icon2.Rotation = math.random(-25, 25) * v72
				Icon2.Size = UDim2.fromScale(Icon2.Size.X.Scale * v74, Icon2.Size.Y.Scale * v74)
				v40:Play()
			end
		end

		Health2 = v70
	end
	local function updateHealthBar() -- line: 226
		-- upvalues: Humanoid (copy), updateBar (copy), Health (copy), addDamageEffect (copy)
		local v75 = Humanoid:GetAttribute("FakeDamage") or 0
		local v76 = if not (Humanoid.Health <= 0) then math.clamp(Humanoid.Health - v75, 1, Humanoid.MaxHealth) else 0

		updateBar(Health, v76, Humanoid.MaxHealth)
		addDamageEffect()
	end

	local u43 = nil

	local function updateStaminaBar() -- line: 235
		-- upvalues: Sprinting (copy), Stamina (copy), Character (copy), clone2 (copy), u43 (ref), v23 (copy), u33 (ref), UIGradient (copy), color3_2 (copy), Icon (copy), Amount (copy), AmountTextColor3 (copy), RunService (copy), color3 (copy), UIGradientColor (copy)
        Stamina.Bar.Clipping.Top.ImageColor3=(Character:GetAttribute("ExhaustedLevel")or 0)>0 and Color3.fromRGB(255,76,79)or ExhaustedBaseColor
		local Stamina2 = Sprinting.Stamina
		local v78 = if not (Stamina2 <= 0) then math.clamp(Stamina2, Sprinting.MinStamina + 1, Sprinting.MaxStamina) else Sprinting.MinStamina
		local v79 = Stamina
		local MaxStamina = Sprinting.MaxStamina

		if v79.Parent then
			local v81 = math.clamp(v78 / MaxStamina, 0, 1)
			local v82 = if v81 ~= 0 then 1 / v81 else 0

			v79.Bar.Clipping.Size = UDim2.fromScale(v81, 1)
			v79.Bar.Clipping.Top.Size = UDim2.fromScale(v82, 1)

			if not Character:GetAttribute("CustomHealthDisplay") or v79.Name ~= "Health" then
				v79.Amount.Text = `{ math.round(v78) }/{ math.round(MaxStamina) }`
			end
		end

		local v83 = math.round(Sprinting.Stamina)
		local str = tostring(v83)

		if clone2 and str ~= u43 then
			if not (v83 > (tonumber(u43) or 0)) and v83 > 50 and v83 % 3 ~= 1 then
				return
			end

			u43 = str
			clone2.Text = str
			v23.Current = 0.03375
			v23.Target = 0.025

			local v85 = Sprinting.Stamina / Sprinting.MaxStamina

			clone2.TextColor3 = Color3.fromHSV(v85 / 3, 0.6, 1)
		end

		if Sprinting.Stamina <= Sprinting.MinStamina then
			if not u33 then
				require(game.ReplicatedStorage.Modules.Sounds):Play("staminaEmpty")
				u33 = os.clock()
				UIGradient.Color = ColorSequence.new(color3_2)
				UIGradient.Rotation = 90

				local clone3 = Icon:Clone()

				clone3.Position = UDim2.fromScale(0.5, 0.5)
				clone3.AnchorPoint = Vector2.new(0.5, 0.5)
				clone3.ImageTransparency = 0.3
				clone3.Size = UDim2.fromScale(1, 1)
				clone3.Parent = Icon
				game.Debris:AddItem(clone3, 0.75)
				task.spawn(function() -- line: 280
					-- upvalues: Amount (copy), AmountTextColor3 (copy)
					for i = 1, 6 do
						Amount.TextColor3 = if i % 2 ~= 1 then AmountTextColor3 else Color3.new(1, 0.2, 0.2)
						task.wait(0.08)
					end
				end)
				game.TweenService:Create(clone3, TweenInfo.new(0.75, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					ImageTransparency = 1,
					Size = UDim2.fromScale(1.5, 1.5)
				}):Play()
				RunService:BindToRenderStep("StaminaOutSequence", 1, function() -- line: 290
					-- upvalues: Stamina (copy), RunService (copy), u33 (ref), color3 (copy), color3_2 (copy), UIGradient (copy)
					if not Stamina or not Stamina.Parent then
						RunService:UnbindFromRenderStep("StaminaOutSequence")

						return
					end

					local v121 = math.clamp(os.clock() - u33, 0, 2) / 2

					UIGradient.Color = if not (v121 > 0.995) then ColorSequence.new({
						ColorSequenceKeypoint.new(0, color3_2),
						ColorSequenceKeypoint.new(v121 * 0.85 + 0.001, color3_2),
						ColorSequenceKeypoint.new(v121 * 0.85 + 0.002, color3),
						ColorSequenceKeypoint.new(1, color3)
					}) else ColorSequence.new(color3)
				end)

				return
			end
		elseif u33 then
			u33 = false
			RunService:UnbindFromRenderStep("StaminaOutSequence")
			UIGradient.Rotation = 90
			UIGradient.Color = UIGradientColor
		end
	end
	local function updateHardDamage() -- line: 324
		-- upvalues: Humanoid (copy), TweenService2 (copy), Health (copy)
		local v87 = Humanoid:GetAttribute("HardDamage") or 0

		if v87 > 0 then
			TweenService2:Create(Health.HardDamage.Clipping.Top, TweenInfo.new(1), {
				ImageTransparency = 0.3,
				Size = UDim2.fromScale(v87 / Humanoid.MaxHealth, 1)
			}):Play()

			return
		end

		TweenService2:Create(Health.HardDamage.Clipping.Top, TweenInfo.new(1), {
			ImageTransparency = 1,
			Size = UDim2.fromScale(0, 1)
		}):Play()
	end
	local function updateOverheal() -- line: 334
		-- upvalues: Humanoid (copy), Health (copy), addDamageEffect (copy), TweenService2 (copy), Health2 (ref)
		local num = tonumber(Humanoid:GetAttribute("Overheal"))

		if num and num <= 0 then
			num = nil
		end

		if num then
			Health.Overheal.Text = num and `+ { math.round(num) }` or ""
			addDamageEffect(num)

			if not Health.Overheal.Visible then
				Health.Overheal.Visible = true
				TweenService2:Create(Health.Icon, TweenInfo.new(0.2), {
					ImageColor3 = Color3.fromRGB(155, 155, 255)
				}):Play()
				TweenService2:Create(Health.Amount, TweenInfo.new(0.2), {
					TextColor3 = Color3.fromRGB(155, 155, 255)
				}):Play()
				TweenService2:Create(Health.Bar, TweenInfo.new(0.2), {
					ImageColor3 = Color3.fromRGB(63, 63, 145)
				}):Play()
				TweenService2:Create(Health.Bar.Clipping.Top, TweenInfo.new(0.2), {
					ImageColor3 = Color3.fromRGB(155, 155, 255)
				}):Play()

				return
			end
		elseif not num and Health.Overheal.Visible then
			Health.Overheal.Visible = false
			TweenService2:Create(Health.Icon, TweenInfo.new(0.2), {
				ImageColor3 = script.PlayerInfo.Bars.Health.Icon.ImageColor3
			}):Play()
			TweenService2:Create(Health.Amount, TweenInfo.new(0.2), {
				TextColor3 = script.PlayerInfo.Bars.Health.Amount.TextColor3
			}):Play()
			TweenService2:Create(Health.Bar, TweenInfo.new(0.2), {
				ImageColor3 = script.PlayerInfo.Bars.Health.Bar.ImageColor3
			}):Play()
			TweenService2:Create(Health.Bar.Clipping.Top, TweenInfo.new(0.2), {
				ImageColor3 = script.PlayerInfo.Bars.Health.Bar.Clipping.Top.ImageColor3
			}):Play()
			task.delay(0.1, function() -- line: 353
				-- upvalues: Health2 (ref), Humanoid (copy)
				Health2 = Humanoid.Health
			end)
		end
	end

	Sprinting.StaminaChanged:Connect(updateStaminaBar)
 Character:GetAttributeChangedSignal("ExhaustedLevel"):Connect(updateStaminaBar)
	Humanoid:GetPropertyChangedSignal("Health"):Connect(updateHealthBar)
	Humanoid:GetPropertyChangedSignal("MaxHealth"):Connect(updateHealthBar)
	Humanoid:GetAttributeChangedSignal("FakeDamage"):Connect(updateHealthBar)
	Humanoid:GetAttributeChangedSignal("HardDamage"):Connect(updateHardDamage)
	Humanoid:GetAttributeChangedSignal("Overheal"):Connect(updateOverheal)

	local v47 = t2[v15.Customization.SurvivorInfoDisplayType.Value] or t2.Side

	for k, v in pairs(v47) do
		if k ~= "NamesVisible" then
			clone.CurrentSurvivors.UIGridLayout[k] = v
		else
			clone.CurrentSurvivors:SetAttribute("NamesVisible", v)
		end
	end

	local u50 = nil

	local function addSurvivor(p8) -- line: 381
		-- upvalues: clone (copy), u50 (ref), Character (copy), LocalPlayer (copy), Util (copy)
		if not p8:IsA("Model") then
			return
		end

		if not p8:FindFirstChild("Humanoid") then
			return
		end

		if not clone.Parent then
			u50:Disconnect()
			u50 = nil

			return
		end

		if not clone:FindFirstChild("CurrentSurvivors") then
			return
		end

		local player = game.Players:GetPlayerFromCharacter(p8)
		local v91 = player and player.Name
		local clone4 = script.SurvivorFrame:Clone()

		clone4.Name = p8.Name
		clone4.SurvivorName.Text = p8.Name
		clone4.Username.Text = p8:GetAttribute("Username") or ""
		clone4.Parent = clone.CurrentSurvivors

		if not clone.CurrentSurvivors:GetAttribute("NamesVisible") then
			clone4.SurvivorName.Visible = false
			clone4.Username.Visible = false
		end

		if p8 == Character then
			clone4.Username.Text = `{ LocalPlayer.Name } (You)`
			clone4.SurvivorName.TextColor3 = Color3.new(1, 1, 0.75)
			clone4.Outline.ImageColor3 = Color3.new(1, 1, 0.25)
			clone4.Health.Visible = false
		end

		local p8Name = game.ReplicatedStorage.Assets.Survivors:FindFirstChild(p8.Name)
		local v94 = p8Name and require(p8Name.Config)

		if v94 and v94.RenderImage then
			clone4.SurvivorName.Text = v94.DisplayName or clone4.SurvivorName.Text
			clone4.Icon.Image = v94.RenderImage
		end

		local p8Name2 = game.ReplicatedStorage.Assets.Skins.Survivors:FindFirstChild(p8.Name)
		local v96 = p8Name2 and p8Name2:FindFirstChild((tostring(p8:GetAttribute("SkinName"))))
		local v97 = v96 and require(v96.Config)

		if v97 and v97.RenderImage then
			clone4.Icon.Image = v97.RenderImage
		end

		local u98 = nil
		local u99 = nil
		local u100 = nil
		local u101 = false

		local function kill() -- line: 433
			-- upvalues: u101 (ref), clone4 (copy), v91 (copy), u98 (ref), u99 (ref), u100 (ref)
			if not u101 and clone4.Parent then
				u101 = true

				if v91 and not game.Players:FindFirstChild(v91) then
					clone4.Health.Text = "LOST"
					clone4.Health.Position = UDim2.fromScale(0.469, 0.735)
					clone4.Health.TextColor3 = Color3.new(0.5, 0.5, 0.5)
					clone4.Outline.ImageColor3 = Color3.new(0.439216, 0.439216, 0.439216)
					clone4.Icon.ImageColor3 = Color3.new(0.2, 0.2, 0.2)
					clone4.Username.TextColor3 = Color3.new(0.2, 0.2, 0.2)
					clone4.SurvivorName.TextColor3 = Color3.new(0.760784, 0.760784, 0.760784)
				else
					clone4.Health.Text = "DEAD"
					clone4.Health.Position = UDim2.fromScale(0.465, 0.735)
					clone4.Outline.ImageColor3 = Color3.new(0.75, 0, 0)
					clone4.Icon.ImageColor3 = Color3.new(1, 0, 0)
					clone4.Username.TextColor3 = Color3.new(1, 0, 0)
					clone4.SurvivorName.TextColor3 = Color3.new(1, 0.5, 0)
				end

				if u98 then
					u98:Disconnect()
				end

				u98 = nil

				if u99 then
					u99:Disconnect()
				end

				u99 = nil

				if u100 then
					u100:Disconnect()
				end

				u100 = nil
			end
		end

		local Humanoid2 = p8:WaitForChild("Humanoid", 5)

		if Humanoid2 then
			local function updateHP() -- line: 474
				-- upvalues: Humanoid2 (copy), kill (copy), clone4 (copy), p8 (copy), Util (copy)
				if not Humanoid2 or not Humanoid2.Parent then
					return kill()
				end

				local Health3 = clone4:FindFirstChild("Health")

				if Health3 then
					local v123 = Humanoid2.Health / Humanoid2.MaxHealth
					local color3_3 = Color3.fromHSV(v123 / 3, 0.4, 1)
					local num = tonumber(Humanoid2:GetAttribute("Overheal"))

					if num and num <= 0 then
						num = nil
					else
						v123 += (num or 0) / Humanoid2.MaxHealth
					end

					local ShatterpointHP = p8:GetAttribute("ShatterpointHP")

					if ShatterpointHP and ShatterpointHP <= 0 then
						ShatterpointHP = nil
					else
						v123 += (ShatterpointHP or 0) / Humanoid2.MaxHealth
					end

					if Util:GetSettingValue("NametagHealthType", game.Players.LocalPlayer) == "Percentage" then
						Health3.Text = `{ math.ceil(v123 * 100) }%`
					else
						Health3.Text = `{ math.ceil(Humanoid2.Health + (num or 0) + (ShatterpointHP or 0)) }HP`
					end

					if num then
						Health3.TextColor3 = Color3.fromRGB(155, 155, 255)
					elseif ShatterpointHP then
						Health3.TextColor3 = Color3.fromRGB(221, 49, 172)
					else
						Health3.TextColor3 = color3_3
					end

					if Humanoid2.Health <= 0 then
						kill()
					end
				end
			end

			updateHP()
			u98 = Humanoid2:GetPropertyChangedSignal("Health"):Connect(updateHP)
			u99 = Humanoid2:GetAttributeChangedSignal("Overheal"):Connect(updateHP)
			u100 = p8:GetAttributeChangedSignal("ShatterpointHP"):Connect(updateHP)
		end

		p8.AncestryChanged:Connect(function(_, parent) -- line: 525
			-- upvalues: kill (copy)
			if not parent then
				kill()
			end
		end)

		local Humanoid3 = p8:WaitForChild("Humanoid", 15)

		if Humanoid3 then
			Humanoid3.Died:Once(kill)
		end
	end

	u50 = workspace.Players.Survivors.ChildAdded:Connect(addSurvivor)

	for _, child in workspace.Players.Survivors:GetChildren() do
		addSurvivor(child)
	end

	local function toggleInfo(p10) -- line: 540
		-- upvalues: LocalPlayer (copy), Character (copy), __initializeCenterStaminaCounter (copy), clone (copy), Util (copy), u24 (ref), v22 (copy), RunService (copy), v15 (copy)
		local Initializer = require(game.ReplicatedStorage.Initializer)
		local SidebarHandler = Initializer.PlayerSystems.SidebarHandler
		local PlayerList = Initializer.Modules.PlayerList
		local ServerList = Initializer.PlayerSystems.ServerList
		local Quests = Initializer.PlayerSystems.Quests
		local lib = { SetHideState = function() end }
		local EventBar = LocalPlayer.PlayerGui.MainUI:FindFirstChild("EventBar")

		if (p10 or Character.Parent) ~= workspace.Players.Spectating then
			__initializeCenterStaminaCounter()
			clone.Visible = true
			EventBar.Visible = false
			Util:CreateTooltip()
			if ServerList and ServerList.__resetAllState then ServerList:__resetAllState()end
			Quests:SetHideState(true)
			lib:SetHideState(true)
			SidebarHandler:ToggleSidebarButtons(false)
			PlayerList:TogglePlayerList(false, true)
		else
			if u24 then
				u24 = false
				v22:Clean()
				RunService:UnbindFromRenderStep("SpringCenterStaminaCounter")
			end

			clone.Visible = false
			EventBar.Visible = true
			if ServerList and ServerList.__reinstateState then ServerList:__reinstateState()end
			Quests:SetHideState(false)
			lib:SetHideState(false)
			SidebarHandler:ToggleSidebarButtons(true)
			PlayerList:TogglePlayerList(true, true)
		end

		local SurvivorInfoEnabled = v15.Customization.SurvivorInfoEnabled

		clone.CurrentSurvivors.Visible = SurvivorInfoEnabled.Value
	end

	toggleInfo()
	Character.AncestryChanged:Connect(function(_, parent) -- line: 578
		-- upvalues: toggleInfo (copy)
		toggleInfo(parent)
	end)
	task.spawn(function() -- line: 583
		-- upvalues: Humanoid (copy), updateBar (copy), Health (copy), addDamageEffect (copy), updateStaminaBar (copy)
		local v117 = Humanoid:GetAttribute("FakeDamage") or 0
		local v118 = if not (Humanoid.Health <= 0) then math.clamp(Humanoid.Health - v117, 1, Humanoid.MaxHealth) else 0

		updateBar(Health, v118, Humanoid.MaxHealth)
		addDamageEffect()
		updateStaminaBar()
	end)
end
function t1.Destroy(_) -- line: 591
    if t1.GameplayPolishCleanup then t1.GameplayPolishCleanup();t1.GameplayPolishCleanup=nil end
	-- upvalues: t1 (copy)
	if t1.UI then
		t1.UI:Destroy()
	end
end

return t1

