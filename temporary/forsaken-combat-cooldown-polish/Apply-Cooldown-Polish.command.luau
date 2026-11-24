assert(game:GetService("RunService"):IsStudio()and not game:GetService("RunService"):IsRunning(),"Stop Play first.")
local function find(path)
 local object=game
 for part in path:gmatch("[^/]+")do object=object and object:FindFirstChild(part)end
 return object
end
local function fingerprint(source)
 local a,b=5381,0
 for i=1,#source do local v=source:byte(i);a=(a*33+v)%4294967296;b=(b*65599+v)%4294967296 end
 return string.format("%d:%08x:%08x",#source,a,b)
end
local changes={
{path=[========[
ReplicatedStorage/Modules/StatusEffects/Haste/CooldownStatus]========],allowed={[========[
1489:04e88fc4:be5c891b]========]},after=[========[
-- Server-authoritative recovery corrections preserve client cooldown progress.
local RunService=game:GetService("RunService")
local Actors=require(game.ReplicatedStorage.Modules.Actors)
local Rules=require(game.ReplicatedStorage.Assets.Survivors.Helperbot.Behavior.Rules)
local Network=require(game.ReplicatedStorage.Modules.Network)
local Status={}
function Status.Tick(effect,dt,direction)
 if not RunService:IsServer() then return end
 local actor=Actors.CurrentActors[effect.Player]
 if not actor then for _,candidate in pairs(Actors.CurrentActors) do if candidate.Rig==effect.Character then actor=candidate;break end end end
 if not actor or not actor.Cooldowns or not actor.SetCooldownOf then return end
 local hum=actor.Rig and actor.Rig:FindFirstChildOfClass("Humanoid")
 if not hum or hum.Health<=0 then return end
 effect.HelperAccumulator=(effect.HelperAccumulator or 0)+dt
 if effect.HelperAccumulator<.1 then return end
 local elapsed=effect.HelperAccumulator;effect.HelperAccumulator=0
 local delta=Rules.CooldownDelta(elapsed,math.max(1,effect.Level or 1),direction<0 and actor.Config and actor.Config.Class=="Support")*direction
 for name,ability in pairs(actor.Behavior and actor.Behavior.Abilities or {}) do
  if (direction<0 or ability.KeybindType~="MainAbility") and not table.find(effect.Data.DisabledAbilityNames or {},name) then
   local remaining=actor:IsOnCooldown(name)
   if type(remaining)=="number" and remaining>0 then
    local adjusted=math.max(0,remaining+delta)
    actor.Cooldowns[name]=adjusted>0 and workspace:GetServerTimeNow()+adjusted or nil
    if actor.Player then
     Network:FireClientConnection(actor.Player,"UpdateAbilityCooldown","REMOTE_EVENT",name,adjusted,true)
    end
   end
  end
 end
end
return Status
]========]},
{path=[========[
ReplicatedStorage/Systems/Player/Networks/ActorNetwork]========],allowed={[========[
33064:4c326576:82949327]========],[========[
37516:f3cc8c92:21adc1e7]========]},after=[========[
require(game.ReplicatedStorage.GlobalTypes)

local t1 = {
	Connections = {},
	KillerIntros = {}
}
local TweenService = game:GetService("TweenService")

game:GetService("Debris")

local LocalPlayer = game.Players.LocalPlayer
local Network = require(game.ReplicatedStorage.Modules.Network)
local Actors = require(game.ReplicatedStorage.Modules.Actors)
local Util = require(game.ReplicatedStorage.Modules.Util)
local Sprinting = require(game.ReplicatedStorage.Systems.Character.Game.Sprinting)
local Statuses = require(game.ReplicatedStorage.Modules.Statuses)
local CharacterReplication = require(game.ReplicatedStorage.Systems.Player.Game.CharacterReplication)
local F6 = Enum.KeyCode.F6

local function changeProp(p1, p2, p3) -- line: 28
	if p3 ~= p1[p2] then
		p1[p2] = p3
	end
end

function t1.Start(_) -- line: 34
 require(script.StunIndicator).Start()
	-- upvalues: Network (copy), Actors (copy), Util (copy), t1 (copy), LocalPlayer (copy), Sprinting (copy), TweenService (copy), Statuses (copy), F6 (copy), CharacterReplication (copy)
	Network:SetConnection("ActorDestroyed", "REMOTE_EVENT", function(p5) -- line: 38
		-- upvalues: Actors (copy)
		local v20 = Actors.CurrentActors[p5]

		if v20 then
			for _, v in pairs({
				"Destroyed",
				"DestroyedPost"
			}) do
				if v20.CustomBehavior and v20.CustomBehavior[v] then
					v20.CustomBehavior[v](v20.CustomBehavior, v20)
				elseif v20.Behavior[v] then
					v20.Behavior[v](v20.Behavior, v20)
				end
			end

			task.spawn(function() -- line: 53
				-- upvalues: v20 (copy)
				if v20.ActorType:find("Killer") then
					local ChaseThemes = require(game.ReplicatedStorage.Systems.Character.Game.ChaseThemes)

					require(game.ReplicatedStorage.Systems.Character.Game.ChaseThemesKiller)
					ChaseThemes:KillerRemoved(v20)
				end
			end)
			Actors.__actorDestroyed:Fire(v20)
		end

		Actors.CurrentActors[p5] = nil
	end)
	Network:SetConnection("ActorCreated", "REMOTE_EVENT", function(p6) -- line: 72
		-- upvalues: Actors (copy), Util (copy), t1 (copy), LocalPlayer (copy), Network (copy), Sprinting (copy), TweenService (copy), Statuses (copy), F6 (copy), CharacterReplication (copy)
		local v24 = Actors:ApplySkinDataToActorInfo(p6)

		p6.CustomBehavior = v24 and (not not v24:FindFirstChild("Behavior") and require(v24.Behavior)) or {}
		Actors.CurrentActors[p6.Player] = p6
		Util:PreloadAssets(p6.Config)
		task.spawn(function() -- line: 84
			-- upvalues: p6 (copy)
			if p6.ActorType:find("Killer") then
				local ChaseThemes = require(game.ReplicatedStorage.Systems.Character.Game.ChaseThemes)
				local ChaseThemesKiller = require(game.ReplicatedStorage.Systems.Character.Game.ChaseThemesKiller)

				ChaseThemes:KillerAdded(p6)
				ChaseThemesKiller:KillerAdded(p6)
			end
		end)
		task.spawn(function() -- line: 94
			-- upvalues: p6 (copy), t1 (copy), Util (copy), Actors (copy), LocalPlayer (copy)
			for _, v in pairs({
				"Created",
				"CreatedPost"
			}) do
				if p6.CustomBehavior and p6.CustomBehavior[v] then
					p6.CustomBehavior[v](p6.CustomBehavior, p6)
				elseif p6.Behavior[v] then
					p6.Behavior[v](p6.Behavior, p6)
				end
			end


		end)
		task.spawn(function() -- line: 229
			-- upvalues: p6 (copy), LocalPlayer (copy), t1 (copy), Util (copy), Network (copy), Sprinting (copy), TweenService (copy), Statuses (copy), F6 (copy), Actors (copy), CharacterReplication (copy)
			if p6.Player ~= LocalPlayer then
				return
			end

			t1:Destroy()
			p6.Animations = {}
            local azureAnimations = p6.ActorName == "Azure" and require(game.ReplicatedStorage.Assets.Killers.Azure.Behavior.OptionalAnimations)
            local function loadMovementAnimation(id, name)
                if azureAnimations then return azureAnimations.Load(Util, p6.Rig, id, false, name) end
                return Util:LoadAnimationFromID(p6.Rig, id)
            end

			for k, v in pairs(p6.Config.Animations or {}) do
				if typeof(v) == "string" then
					p6.Animations[k] = loadMovementAnimation(v, k)
				elseif typeof(v) == "table" then
					for k2, v2 in pairs(v) do
						if typeof(v2) == "string" then
							if not p6.Animations[k] then
								p6.Animations[k] = {}
							end

							p6.Animations[k][k2] = loadMovementAnimation(v2, k2)
						end
					end
				end
			end

            if azureAnimations then p6.Animations = azureAnimations.Table(p6.Animations) end

			local t2 = {}

			local function stopAnims(p7) -- line: 252
				-- upvalues: t2 (copy)
				for _, v in pairs(t2) do
					v:Stop(p7)
				end

				table.clear(t2)
			end

			p6.Animations.Idle.Priority = Enum.AnimationPriority.Core
			p6.Animations.Walk.Priority = Enum.AnimationPriority.Core
			p6.Animations.Run.Priority = Enum.AnimationPriority.Core
			p6.Animations.Idle:Play(0)
			p6.Animations.Idle.Looped = true
			table.insert(t2, p6.Animations.Idle)

			local Footsteps = p6.Config.Sounds.Footsteps
			local u80 = false
			local n2 = 0
			local elapsed = os.clock()

			for k, v in pairs(p6.Animations) do
				if k:find("Walk") or k:find("Run") then
					v.KeyframeReached:Connect(function(keyframe) -- line: 274
						-- upvalues: LocalPlayer (copy), elapsed (ref), u80 (ref), Footsteps (copy), n2 (ref), Network (copy)
						if keyframe == "Footstep" and (LocalPlayer.Character.Humanoid.FloorMaterial ~= Enum.Material.Air and LocalPlayer.Character.Humanoid.FloorMaterial ~= Enum.Material.Neon and LocalPlayer.Character.PrimaryPart.Velocity.Magnitude > 3 and not LocalPlayer.Character.PrimaryPart.Anchored and not LocalPlayer.Character:GetAttribute("FootstepsMuted")) then
							if os.clock() - elapsed < 0.05 then
								return
							end

							if u80 then
								u80 = false

								return
							end

							if Footsteps then
								n2 = (n2 + 1) % #Footsteps
							end

							Network:FireServerConnection("FootSP", "UREMOTE_EVENT", Footsteps and n2)
							elapsed = os.clock()
						end
					end)
				end
			end

			LocalPlayer.Character:GetAttributeChangedSignal("Ragdolling"):Connect(function() -- line: 297
				-- upvalues: LocalPlayer (copy), stopAnims (copy), p6 (copy), t2 (copy)
				if LocalPlayer.Character:GetAttribute("Ragdolling") then
					stopAnims(0.1)

					return
				end

				local Humanoid = LocalPlayer.Character.Humanoid
				local v136 = Humanoid.Health - (Humanoid:GetAttribute("FakeDamage") or 0)
				local v137 = p6.AnimationType or (not (v136 <= Humanoid.MaxHealth / 2) and "" or "Injured")
				local v138 = p6.Animations[`{ v137 }Idle`]

				if v138 then
					v138:Play(0.1)
					table.insert(t2, v138)
				end
			end)

			local u85 = false
			local s1 = ""

			local function updateMovementAnims(p8) -- line: 316
				-- upvalues: LocalPlayer (copy), p6 (copy), s1 (ref), stopAnims (copy), u80 (ref), Sprinting (copy), u85 (ref), t2 (copy)
				if LocalPlayer.Character:GetAttribute("Ragdolling") then
					return
				end

				if p6 and p6.AnimationType == false then
					if s1 then
						stopAnims(0.15)
					end

					s1 = nil

					return
				end

				local Humanoid = LocalPlayer.Character.Humanoid
				local v141 = Humanoid.Health - (Humanoid:GetAttribute("FakeDamage") or 0)
				local v142 = p6.AnimationType or (not (v141 <= Humanoid.MaxHealth / 2) and "" or "Injured")
				local v143 = p6.Animations[`{ v142 }Idle`]
				local v144 = p6.Animations[`{ v142 }Walk`]
				local v145 = p6.Animations[`{ v142 }Run`]
				local v146 = p6.MovementAnimSpeed or p6.Config.MovementAnimSpeed

				if v146 then
					v144:AdjustSpeed(v146)
					v145:AdjustSpeed(v146)
				else
					v144:AdjustSpeed(p8 / (tonumber(p6.Config.Speed) and tonumber(p6.Config.Speed) / 1.2 or 10))
					v145:AdjustSpeed(p8 / (tonumber(p6.Config.SprintSpeed) or 28))
				end

				if p8 > 0.03 and (v142 ~= s1 or not p6.Moving) then
					u80 = true
					p6.Moving = true

					if Sprinting.IsSprinting then
						stopAnims(0.15)
						v145:Play(0.15)
						u85 = true
						table.insert(t2, v145)
					else
						stopAnims(0.15)
						v144:Play(0.15)
						u85 = false
						table.insert(t2, v144)
					end
				elseif p8 < 0.03 then
					p6.Moving = nil
					u85 = false
					stopAnims(0.1)
					v143:Play(0.1)
					table.insert(t2, v143)
				end

				s1 = v142
			end

			LocalPlayer.Character.Humanoid.StateChanged:Connect(function(_, newState) -- line: 377
				-- upvalues: updateMovementAnims (copy)
				if newState == Enum.HumanoidStateType.Landed then
					updateMovementAnims(0)
				end
			end)
			LocalPlayer.Character.Humanoid.Running:Connect(updateMovementAnims)

			local function updateIdleAnim() -- line: 384
				-- upvalues: LocalPlayer (copy), p6 (copy), stopAnims (copy), t2 (copy), s1 (ref)
				if LocalPlayer.Character:GetAttribute("Ragdolling") then
					return
				end

				if p6.Moving then
					return
				end

				if p6 and p6.AnimationType == false then
					return
				end

				local Humanoid = LocalPlayer.Character.Humanoid
				local v150 = Humanoid.Health - (Humanoid:GetAttribute("FakeDamage") or 0)
				local v151 = p6.AnimationType or (not (v150 <= Humanoid.MaxHealth / 2) and "" or "Injured")
				local v152 = p6.Animations[`{ v151 }Idle`]

				if v152 and v152.IsPlaying then
					return
				end

				stopAnims(0.1)

				if v152 then
					v152:Play(0.1)
					table.insert(t2, v152)
				end

				s1 = v151
			end

			LocalPlayer.Character.Humanoid.HealthChanged:Connect(function() -- line: 414
				-- upvalues: p6 (copy), LocalPlayer (copy), updateMovementAnims (copy), updateIdleAnim (copy)
				if p6.Moving then
					local Character = LocalPlayer.Character
					local v154 = Character and Character.PrimaryPart

					if not v154 or not Character:HasTag("Replicating") then
						return
					end

					updateMovementAnims(v154.AssemblyLinearVelocity.Magnitude)

					return
				end

				updateIdleAnim()
			end)
			task.spawn(function() -- line: 429
				-- upvalues: Sprinting (copy), p6 (copy), LocalPlayer (copy), t1 (copy), Util (copy), TweenService (copy), u85 (ref), u80 (ref), stopAnims (copy), t2 (copy)
				local n3 = 0

				if Sprinting.Character ~= p6.Rig or not Sprinting.DefaultsSet then
					repeat
						n3 += game["Run Service"].Heartbeat:Wait()
					until Sprinting.Character == p6.Rig and Sprinting.DefaultsSet or n3 >= 10
				end

				Sprinting.SprintSpeed = p6.Config.SprintSpeed or Sprinting.SprintSpeed
				Sprinting.StaminaLoss = p6.Config.StaminaLoss or Sprinting.StaminaLoss
				Sprinting.StaminaGain = p6.Config.StaminaGain or Sprinting.StaminaGain
				Sprinting.MaxStamina = p6.Config.MaxStamina or Sprinting.MaxStamina
				Sprinting.MinStamina = p6.Config.MinStamina or Sprinting.MinStamina
				Sprinting.Stamina = Sprinting.MaxStamina
				Sprinting.__staminaChangedEvent:Fire(Sprinting.MaxStamina)

				if Sprinting.MaxStamina ~= Sprinting.MaxStamina or Sprinting.Stamina ~= Sprinting.Stamina then
					task.spawn(function() -- line: 449
						-- upvalues: LocalPlayer (copy)
						LocalPlayer:Kick("\n\nForsakenCheatKiller 000:\nStamina exceeds max possible cap\n")
					end)

					while true do
					end
				end

				local function canReachPosition(p10, p11, p12) -- line: 456
					tick()

					local v231 = game:GetService("PathfindingService"):CreatePath({
						AgentCanJump = false,
						WaypointSpacing = 1e999
					})

					v231:ComputeAsync(p10, p11)

					if v231.Status ~= Enum.PathStatus.Success then
						return nil
					end

					local Waypoints = v231:GetWaypoints()
					local n4 = 0

					for i = 2, #Waypoints do
						n4 += (Waypoints[i].Position - Waypoints[i - 1].Position).Magnitude
					end

					return n4 < p12
				end

				local v157 = p6.Rig and p6.Rig.PrimaryPart

				if p6.ActorType:find("Killer") and v157 then
					local n5 = 0
					local u159 = nil

					t1.Connections.StaminaDrainConnection = game["Run Service"].RenderStepped:Connect(function(dt) -- line: 499
						-- upvalues: n5 (ref), Util (copy), v157 (copy), Sprinting (copy), u159 (ref), TweenService (copy), p6 (copy)
						n5 += dt

						if n5 >= 0.1 then
							n5 = 0

							local ClosestPlayerFromPosition = Util:GetClosestPlayerFromPosition(v157.Position, {
								MaxDistance = 85,
								PlayerSelection = "Survivors",
								OverrideUndetectable = true,
								VerticalMultiplier = 3
							})
							local v237 = ClosestPlayerFromPosition and ClosestPlayerFromPosition.PrimaryPart

							if v237 and Sprinting.StaminaLossDisabled then
								Sprinting.StaminaLossDisabled = false

								if u159 then
									TweenService:Create(u159, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
										Value = 1
									}):Play()
									task.delay(1, function() -- line: 516
										-- upvalues: Sprinting (copy), u159 (ref)
										if Sprinting.StaminaLossDisabled then
											return
										end

										if u159 and u159.Parent then
											u159:Destroy()
											u159 = nil
										end
									end)

									return
								end
							elseif not v237 and not Sprinting.StaminaLossDisabled then
								Sprinting.StaminaLossDisabled = true

								if u159 then
									u159:Destroy()
									u159 = nil
								end

								u159 = Util:CreateSpeedMultiplier(p6.Player, 1.1, "KillerPassiveBoost")
							end
						end
					end)
				end

				t1.Connections.SprintingConnection = Sprinting.SprintToggled:Connect(function(p13) -- line: 543
					-- upvalues: Util (copy), p6 (copy), u85 (ref), u80 (ref), LocalPlayer (copy), stopAnims (copy), t2 (copy)
					if not Util:IsAlive(p6 and p6.Rig) then
						return
					end

					if p6.Moving and p13 ~= u85 then
						u80 = true

						local Humanoid = LocalPlayer.Character.Humanoid
						local v240 = p6.AnimationType or (not (Humanoid.Health - (Humanoid:GetAttribute("FakeDamage") or 0) <= LocalPlayer.Character.Humanoid.MaxHealth / 2) and "" or "Injured")
						local v241 = p6.Animations[`{ v240 }Walk`]
						local v242 = p6.Animations[`{ v240 }Run`]

						stopAnims(0.3)

						if p13 then
							u85 = true
							v242:Play(0.3)
							table.insert(t2, v242)

							return
						end

						u85 = false
						v241:Play(0.3)
						table.insert(t2, v241)
					end
				end)

				local SprintingButton = LocalPlayer.PlayerGui.MainUI:FindFirstChild("SprintingButton")
				local ShiftLockButton = LocalPlayer.PlayerGui.MainUI:FindFirstChild("ShiftLockButton")

				if SprintingButton and SprintingButton.Visible then
					SprintingButton.AnchorPoint = Vector2.new(0, 0)
					SprintingButton.Size = UDim2.fromOffset(125, 125)
					SprintingButton.Position = UDim2.new(1, -160, 1, -170)
					ShiftLockButton.Position = UDim2.new(1, -135, 1, -4)

					local AbilityContainer = LocalPlayer.PlayerGui.MainUI:WaitForChild("AbilityContainer")

					AbilityContainer.AnchorPoint = SprintingButton.AnchorPoint
					AbilityContainer.Position = SprintingButton.Position
					AbilityContainer.Size = SprintingButton.Size + UDim2.fromScale(0.075, 0.075)
					Instance.new("UIAspectRatioConstraint").Parent = AbilityContainer
				end
			end)

			local clone = game.ReplicatedStorage.Systems.Player.UI.CustomBackpack.Backpack:Clone()

			clone.Name = "AbilityContainer"
			clone.Parent = LocalPlayer.PlayerGui.MainUI
			t1.AbilityHotbar = clone

			local v90 = p6.Behavior.Abilities or {}

			for k, v in pairs(p6.CustomBehavior.Abilities or {}) do
				v90[k] = v
			end

			p6.Cooldowns = {}
			t1.Connections.CooldownConnection = game["Run Service"].RenderStepped:Connect(function(dt) -- line: 600
				-- upvalues: Statuses (copy), LocalPlayer (copy), v90 (copy), p6 (copy), clone (copy)
				local v164 = Statuses:PlayerHasStatus(LocalPlayer, "Hacked") and true

				for k, _ in pairs(v90) do
					local v167 = p6.Cooldowns[k]
					local v168 = v90[k] or {}
					local k3 = clone:FindFirstChild(k)
					local v170 = v168.CurrentCharges and v168.CurrentCharges > 0
					local v171 = v170 and v168.NameCharged or (v168.Name or k:gsub("(%l)(%u)", "%1 %2"))
					local v172 = v170 and v168.IconCharged or (v168.Icon or "rbxassetid://10724129940")
					local FlavorText = v168.FlavorText
					local v174 = v168.ChargeDuration and v168.CurrentRecharge or v168.Charges and (v168.CurrentCharges and (v168.Recharge and v168.CurrentCharges < v168.Charges))
					local v175 = v164 and v168.KeybindType ~= "MainAbility"

					if v172 ~= k3.Image then
						k3.Image = v172
					end

					local Top = k3.Clipping.Top

					if v172 ~= Top.Image then
						Top.Image = v172
					end

					local AbilityName = k3.AbilityName

					if v171 ~= AbilityName.Text then
						AbilityName.Text = v171
					end

					local FlavorText2 = k3.FlavorText
					local v179 = not not FlavorText

					if v179 ~= FlavorText2.Visible then
						FlavorText2.Visible = v179
					end

					local FlavorText3 = k3.FlavorText
					local v181 = FlavorText or ""

					if v181 ~= FlavorText3.Text then
						FlavorText3.Text = v181
					end

                    local haste=Statuses:PlayerHasStatus(LocalPlayer,"Haste")
                    local accelerated=v167~=nil and haste~=nil and haste~=false
                        and not table.find(haste.Data and haste.Data.DisabledAbilityNames or {},k)
                    local label=k3 and k3:FindFirstChild("CooldownTime")
                    if label then
                        local base=label:GetAttribute("BaseTextColor")
                        if not base then base=label.TextColor3;label:SetAttribute("BaseTextColor",base)end
                        label.TextColor3=accelerated and Color3.fromRGB(0,255,0)or base
                    end
					if v167 then
						local Duration = v167.Duration
						local TimePast = v167.TimePast
						local v184 = Duration>0 and math.clamp(TimePast / Duration, 0, 1)or 1
						local v185 = Duration - TimePast

						if v184 >= 1 and not v174 then
							p6.Cooldowns[k] = nil
						end

						local v186 = if v184 ~= 0 then 1 / v184 else 0

						if k3 and not v168.Disabled then
							local Clipping = k3.Clipping
							local uDim2 = UDim2.fromScale(1, v184)

							if uDim2 ~= Clipping.Size then
								Clipping.Size = uDim2
							end

							local Top2 = k3.Clipping.Top
							local uDim2_2 = UDim2.fromScale(1, v186)

							if uDim2_2 ~= Top2.Size then
								Top2.Size = uDim2_2
							end

							local CooldownTime = k3.CooldownTime
							local v192 = if not (v184 >= 1) then `{ v185 < 10 and string.format("%.1f", Duration - TimePast) or math.round(v185) }` else ""

							if v192 ~= CooldownTime.Text then
								CooldownTime.Text = v192
							end
						end

						if not v175 then
							v167.TimePast = v167.TimePast + dt
						end
					end

					if v174 then
						if v168.ChargeDuration and v168.CurrentRecharge then
							if v168.CurrentRecharge < v168.ChargeDuration and v174 then
								local v193 = v168.RechargeInverted and 1 - v168.CurrentRecharge / v168.ChargeDuration or v168.CurrentRecharge / v168.ChargeDuration
								local Fill = k3.Charges.Recharge.Fill
								local uDim2 = UDim2.fromScale(v193, 1)

								if uDim2 ~= Fill.Size then
									Fill.Size = uDim2
								end

								local Recharge = k3.Charges.Recharge

								if Recharge.Visible ~= true then
									Recharge.Visible = true
								end

								local FillColor = v168.FillColor

								if FillColor then
									local Fill2 = k3.Charges.Recharge.Fill

									if FillColor ~= Fill2.BackgroundColor3 then
										Fill2.BackgroundColor3 = FillColor
									end
								end

								if not v175 then
									v168.CurrentRecharge = v168.CurrentRecharge + dt
								end
							else
								local Recharge = k3.Charges.Recharge

								if Recharge.Visible ~= false then
									Recharge.Visible = false
								end
							end
						else
							local Recharge = k3.Charges.Recharge

							if Recharge.Visible ~= false then
								Recharge.Visible = false
							end
						end
					else
						local Recharge = k3.Charges.Recharge

						if Recharge.Visible ~= false then
							Recharge.Visible = false
						end
					end
				end
			end)

			if game.PlaceId == 92145853615773 then
				t1.Connections.DisableUIConnection = game.UserInputService.InputBegan:Connect(function(input, gameProcessed: boolean) -- line: 682
					-- upvalues: F6 (copy), LocalPlayer (copy)
					if gameProcessed or input.KeyCode ~= F6 then
						return
					end

					for _, child in (LocalPlayer.PlayerGui:GetChildren()) do
						if child:IsA("ScreenGui") then
							child.Enabled = not child.Enabled
						end
					end
				end)
			end

			local clone2 = nil
			local Device = require(game.ReplicatedStorage.Modules.Device)

			if Device:GetPlayerDevice() == "Mobile" then
				local UIListLayout = clone:FindFirstChild("UIListLayout")

				if UIListLayout then
					UIListLayout:Destroy()
				end

				clone2 = script.ButtonPath:Clone()
				clone2.Parent = clone
			end

			p6.HeldAbilities = {}

			local Initializer = require(game.ReplicatedStorage.Initializer)
			local Config = p6.Config

			for k, v in pairs(v90 or {}) do
				local v100 = Config and Config[`{ k }HoldTime`]
				local v101 = game.Players.LocalPlayer:GetAttribute("Device") or "PC"
				local v102 = if not v.DeviceToButtonType then v.ButtonType or "Default" else v.DeviceToButtonType[v101] or "Default"
				local v103 = Config and Config[`{ k }SensitiveButton`] or (v.Sensitive or v102 == "Sensitive")
				local v104 = Config and Config[`{ k }ToggleButton`] or (v.Toggle or v102 == "Toggle")
				local vName = v.Name

				local function useAbility() -- line: 728
					-- upvalues: Network (copy), k (copy)
					Network:FireServerConnection("UseActorAbility", "REMOTE_EVENT", k)
				end

				local clone3 = game.ReplicatedStorage.Assets.UI.AbilityIcon:Clone()

				clone3.Clipping.Top.Image = v.Icon or "rbxassetid://114519105023135"
				clone3.Image = v.Icon or "rbxassetid://114519105023135"
				clone3.LayoutOrder = v.LayoutOrder
				clone3.AbilityName.Text = vName or k:gsub("(%l)(%u)", "%1 %2")
				clone3.Name = k
				clone3.Parent = clone
				clone3.MouseButton1Click:Connect(function() -- line: 741
					-- upvalues: v104 (copy), p6 (copy), k (copy), Network (copy), v100 (copy), v103 (copy)
					if v104 then
						p6.HeldAbilities[k] = not p6.HeldAbilities[k]

						if p6.HeldAbilities[k] then
							Network:FireServerConnection("UseActorAbility", "REMOTE_EVENT", k)

							return
						end
					elseif not v100 and not v103 then
						Network:FireServerConnection("UseActorAbility", "REMOTE_EVENT", k)
					end
				end)

				if not v104 then
					clone3.MouseButton1Down:Connect(function() -- line: 754
						-- upvalues: p6 (copy), k (copy), v100 (copy), v103 (copy), Network (copy)
						p6.HeldAbilities[k] = true

						if v100 or v103 then
							Network:FireServerConnection("UseActorAbility", "REMOTE_EVENT", k)
						end
					end)
					clone3.MouseButton1Up:Connect(function() -- line: 760
						-- upvalues: p6 (copy), k (copy)
						p6.HeldAbilities[k] = nil
					end)
				end

				if v.Charges then
					local v108 = v.Charges > 0
					local v109 = v108 and v.NameCharged or (v.Name or k:gsub("(%l)(%u)", "%1 %2"))
					local v110 = v108 and v.IconCharged or v.Icon

					clone3.Image = v110
					clone3.Clipping.Top.Image = v110
					clone3.AbilityName.Text = v109
					clone3.Charges.Text = tostring(v.Charges)

					if v.Charges <= 0 and not v.ChargesOptional and not v.ChargesDisabled then
						Util:ToggleLockForAbilityIcon(k, "NoCharges", true)
					end
				end

				if clone2 then
					clone3.KeybindName.Visible = false
					clone3.AnchorPoint = Vector2.new(0.5, 0.5)
					clone3.Size = UDim2.fromScale(0.45, 0.45)
				end

				local Backpack = LocalPlayer.PlayerGui.MainUI:FindFirstChild("Backpack")

				if Backpack and not clone2 then
					Backpack.Position = UDim2.new(1, -20, 0.9, -55)
				end

				local t3 = {}
				local KeybindType = v.KeybindType

				if KeybindType then
					for _, v3 in pairs({
						Initializer.PlayerSettings[KeybindType],
						Initializer.PlayerSettings[`{ KeybindType }~Console`]
					}) do
						table.insert(t3, v3.Value)
					end
				end

				local t4 = {
					{
						"MouseButton1",
						"LMB"
					},
					{
						"MouseButton2",
						"RMB"
					},
					{
						"MouseButton3",
						"MMB"
					},
					{
						"Button",
						"",
						true
					}
				}

				local function updateKeybindTexts() -- line: 813
					-- upvalues: KeybindType (copy), clone3 (copy), v (copy), v101 (copy), Device (copy), Initializer (copy), t4 (copy)
					if not KeybindType or KeybindType == "Passive" then
						clone3.KeybindName.Text = "[PASSIVE]"

						return
					end

					local v206 = v.FlavorText or v.DeviceToFlavorText and v.DeviceToFlavorText[v101]
					local v207 = Device:GetPlayerDevice() == "PC" and Initializer.PlayerSettings[KeybindType] or Device:GetPlayerDevice() == "Console" and Initializer.PlayerSettings[`{ KeybindType }~Console`]

					if not v207 then
						clone3.KeybindName.Text = v206 or ""

						return
					end

					local str = tostring(v207.Value)

					for _, v4 in pairs(t4) do
						local v211 = v4[1]
						local v212 = v4[2]

						if not v4[3] or Device:GetPlayerDevice() == "Console" then
							str = str:gsub(v211, v212)
						end
					end

					clone3.KeybindName.Text = str:gsub("(%l)(%u)", "%1 %2")
					clone3.FlavorText.Text = v206 or ""
				end

				updateKeybindTexts()
				t1.Connections[`{ k }KeybindUpdatedConnection`] = Device.Changed:Connect(updateKeybindTexts)

				local Emotes = require(game.ReplicatedStorage.Systems.Character.Game.Emotes)

				local function inputProcessedChecks(p14) -- line: 839
					-- upvalues: Emotes (copy)
					return Emotes.EmoteMenu.CurrentlyVisible and p14.UserInputType == Enum.UserInputType.MouseButton1
				end

				local v120 = Device:GetPlayerDevice() == "Console" and v104

				t1.Connections[`{ k }InputConnection`] = game.UserInputService.InputBegan:Connect(function(input, gameProcessed) -- line: 846
					-- upvalues: t3 (copy), Emotes (copy), v120 (copy), p6 (copy), k (copy), Network (copy)
					if gameProcessed then
						return
					end

					if (table.find(t3, input.KeyCode.Name) or table.find(t3, input.UserInputType.Name)) and (not Emotes.EmoteMenu.CurrentlyVisible or input.UserInputType ~= Enum.UserInputType.MouseButton1) then
						if v120 then
							p6.HeldAbilities[k] = not p6.HeldAbilities[k]

							if p6.HeldAbilities[k] then
								Network:FireServerConnection("UseActorAbility", "REMOTE_EVENT", k)

								return
							end
						else
							p6.HeldAbilities[k] = true
							Network:FireServerConnection("UseActorAbility", "REMOTE_EVENT", k)
						end
					end
				end)
				t1.Connections[`{ k }InputConnectionEnd`] = game.UserInputService.InputEnded:Connect(function(input, gameProcessed) -- line: 864
					-- upvalues: v120 (copy), t3 (copy), p6 (copy), k (copy)
					if gameProcessed or v120 then
						return
					end

					if table.find(t3, input.KeyCode.Name) or table.find(t3, input.UserInputType.Name) then
						p6.HeldAbilities[k] = nil
					end
				end)
			end

			local function onCameraViewportChanged() -- line: 872
			end

			task.delay(0.25, function() -- line: 877
				-- upvalues: clone2 (ref), clone (copy)
				while clone2 and clone2.Parent and clone.Parent do
					clone2.Thickness = clone2.Thickness ~= 2 and 2 or 1

					local _ = #clone2:GetControlPoints()
					local t5 = {}

					for _, child in clone:GetChildren() do
						if child:IsA("GuiObject") then
							table.insert(t5, child)
						end
					end

					table.sort(t5, function(p15, p16) -- line: 891
						return p15.LayoutOrder < p16.LayoutOrder
					end)

					for k, v in pairs(t5) do
						local v224 = k / (#t5 + 1)

						v.Position = clone2:GetPositionOnCurveArcLength(v224)
					end

					task.wait(1)
				end
			end)

			local n6 = 0.016666666666666666
			local Character = LocalPlayer.Character

			table.insert(t1.Connections, game["Run Service"].Heartbeat:Connect(function(dt) -- line: 905
				-- upvalues: Actors (copy), LocalPlayer (copy), Util (copy), Character (copy), n6 (ref), Network (copy), CharacterReplication (copy)
				if not workspace:GetAttribute("ExperimentalHitboxes") then
					return
				end

				local v226 = Actors.CurrentActors[LocalPlayer]

				if not v226 then
					return
				end

				if not v226 or not Util:IsAlive(Character) then
					return
				end

				n6 += dt

				if n6 < 0.016666666666666666 then
					return
				end

				n6 = 0

				local AssemblyLinearVelocity = Character.PrimaryPart.AssemblyLinearVelocity

				Network:FireServerConnection("UpdateCharacterPosition", "UREMOTE_EVENT", CharacterReplication.Serialize(Character.PrimaryPart.CFrame, AssemblyLinearVelocity))
			end))

			for _, v in pairs({
				"ActorCreated",
				"ActorCreatedPost"
			}) do
				if p6.CustomBehavior and p6.CustomBehavior[v] then
					p6.CustomBehavior[v](p6.CustomBehavior, p6)
				elseif p6.Behavior[v] then
					p6.Behavior[v](p6.Behavior, p6)
				end
			end
		end)
		task.defer(Util.FixCharacter, Util, p6.Rig, p6.ActorType .. "s")
		Actors.__actorCreated:Fire(p6)
	end)
	Network:SetConnection("UpdateAbilityCharges", "REMOTE_EVENT", function(p17, p18, p19) -- line: 942
		-- upvalues: Actors (copy), LocalPlayer (copy), t1 (copy), Util (copy)
		local v28 = Actors.CurrentActors[LocalPlayer]

		if not v28 then
			return
		end

		local v29 = v28.CustomBehavior.Abilities or {}
		local v30 = v28.Behavior.Abilities or {}
		local v31 = v29[p17] or v30[p17]
		local v32 = t1.AbilityHotbar and t1.AbilityHotbar:FindFirstChild(p17)
		local v33 = v28 and (v28.Cooldowns and v28.Cooldowns[p17])

		if not v31 then
			warn(`[{ tostring(script) }]: Ability { v31 } doesn't exist`)

			return
		end

		if v31 and v32 then
			v31.CurrentCharges = p18

			if v31.Recharge and p19 then
				v31.ChargeDuration = v31.Recharge
				v31.CurrentRecharge = typeof(p19) ~= "number" and 0 or p19
			end

			if p18 <= 0 and not v31.ChargesOptional and not v31.ChargesDisabled then
				v31.Disabled = true
				v32.Clipping.Size = UDim2.fromScale(1, 0)
				v32.Clipping.Top.Size = UDim2.fromScale(1, 0)
				v32.Charges.Text = tostring(p18)
				v32.CooldownTime.Text = ""
				Util:ToggleLockForAbilityIcon(p17, "NoCharges", true)

				return
			end

			v31.Disabled = false
			v32.Clipping.Size = v33 and v32.Clipping.Size or UDim2.fromScale(1, 1)
			v32.Clipping.Top.Size = v33 and v32.Clipping.Top.Size or UDim2.fromScale(1, 1)
			v32.Charges.Text = tostring(p18)
			v32.CooldownTime.Text = ""
			Util:ToggleLockForAbilityIcon(p17, "NoCharges", false)
		end
	end)
	Network:SetConnection("OnExecutionClientAsync", "REMOTE_EVENT", function(p20) -- line: 982
		-- upvalues: Actors (copy), LocalPlayer (copy)
		local v35 = Actors.CurrentActors[LocalPlayer]

		if not v35 then
			return
		end

		local v36 = v35.CustomBehavior.OnExecutionClient or nil
		local v37 = v35.Behavior.OnExecutionClient or nil
		local v38 = v36 or v37

		if v38 then
			pcall(v38, v35.Behavior, v35, p20)
		end
	end)
	Network:SetConnection("UpdateAbilityCooldown", "REMOTE_EVENT", function(p21, p22, preserveProgress) -- line: 994
		-- upvalues: Actors (copy), LocalPlayer (copy)
		if workspace:GetAttribute("CooldownsDisabled") then
			return
		end

		local v41 = Actors.CurrentActors[LocalPlayer]

		if not v41 then
			return
		end

		local v42 = v41.CustomBehavior.Abilities or {}
		local v43 = v41.Behavior.Abilities or {}

		if (v42[p21] or v43[p21]) and v41.Cooldowns then
			if p22 < 0 then
				if v41.Cooldowns[p21] then
					local v44 = v41.Cooldowns[p21]

					v44.TimePast = v44.TimePast + math.abs(p22)

					return
				end
            elseif preserveProgress and v41.Cooldowns[p21] then
                local cooldown=v41.Cooldowns[p21]
                cooldown.Duration=math.max(cooldown.Duration,p22)
                cooldown.TimePast=math.max(0,cooldown.Duration-p22)
            else
                v41.Cooldowns[p21] = {TimePast=0,Duration=p22}
            end
		end
	end)
	Network:SetConnection("UseActorAbility", "REMOTE_EVENT", function(p23, p24) -- line: 1016
		-- upvalues: Actors (copy), LocalPlayer (copy), Network (copy)
		local v47 = Actors.CurrentActors[LocalPlayer]

		if not v47 then
			return
		end

		local v48 = v47.CustomBehavior.Abilities or {}
		local Config = v47.Config
		local v50 = v47.Behavior.Abilities or {}
		local v51 = v48[p23] or v50[p23]
		local v52 = Config and Config[`{ p23 }HoldTime`]
		local v53 = not not v52 and (typeof(p24) ~= "table" or typeof(p24) == "table" and (not p24.ChargeTime or false))
		local num = tonumber(p24 and (typeof(p24) == "table" and p24.Cooldown) or (typeof(v51.Cooldown) == "function" and v51.Cooldown(v47, p23) or (v51.Cooldown or v47.Config[`{ p23 }Cooldown`])))

		if typeof(p24) == "table" and p24.Cancelled then
			num = 0
		end

		if p24 == "Cancelled" then
			num = 0
		end

		if v53 then
			num = 0
		end

		if num and num > 0 and ((not v47.Cooldowns[p23] or not (v47.Cooldowns[p23].TimePast <= 0.025)) and not workspace:GetAttribute("CooldownsDisabled")) then
			v47.Cooldowns[p23] = {
				TimePast = 0,
				Duration = num
			}
		end

		v51.Callback(v47, p24)

		if v47.Behavior.OnAbilityUsed then
			local ok, result = pcall(function() -- line: 1059
				-- upvalues: v47 (copy), p23 (copy)
				v47.Behavior.OnAbilityUsed(v47, p23)
			end)

			if not ok then
				warn(`[{ script.Name }]: Failed to call method 'OnAbilityUsed' due to: { result }`)
			end
		end

		if v53 then
			local timestamp = tick()

			while (v47.HeldAbilities[p23] or tick() - timestamp < v52.Min) and LocalPlayer.Character and LocalPlayer.Character:GetAttribute(`Charging{ p23 }`) do
				game["Run Service"].Heartbeat:Wait()
			end

			if LocalPlayer.Character and LocalPlayer.Character:GetAttribute(`Charging{ p23 }`) then
				Network:FireServerConnection("UseActorAbility", "REMOTE_EVENT", p23)
			end
		end
	end)
	LocalPlayer.CharacterAdded:Connect(function(character) -- line: 1084
		-- upvalues: t1 (copy)
		if character.Parent == workspace or character.Parent == workspace.Players.Spectating then
			t1:Destroy()
		end
	end)
end
function t1.Destroy(_) -- line: 1092
	-- upvalues: t1 (copy)
	if t1.AbilityHotbar then
		t1.AbilityHotbar:Destroy()
	end

	for _, v in pairs(t1.Connections) do
		v:Disconnect()
	end

	table.clear(t1.Connections)
end

return t1

]========]},
{path=[========[
ReplicatedStorage/Systems/Player/Miscellaneous/TabbedOutScare]========],allowed={[========[
5441:02201662:44a74115]========]},after=[========[
game:GetService("LocalizationService")

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Util = require(game.ReplicatedStorage.Modules.Util)
local Network = require(game.ReplicatedStorage.Modules.Network)
local t1 = {}
local t2 = {
	"you aren't alone here.",
	"do you call this your home?",
	"i decide when you can leave.",
	"don’t test my patience.",
	"i want to see your face.",
	"come back and play.",
	"you wouldn't dare defy me.",
	"don't turn around.",
	"the air is heavier out there, isn't it?",
	"i've been waiting for you.",
	"is this where it ends?",
	"do you hear that?",
	"i never left.",
	"if you leave, you won’t make it far.",
	"can you feel me watching?",
	"why did you lock the door?",
	"you brought this upon yourself.",
	"there's nowhere to hide.",
	"don't make me find you.",
	"leaving is not an option.",
	"you belong to me now.",
	"who else knows you're here?",
	"it's colder now, isn't it?",
	"you can't escape me."
}
local t3 = {
	Survivors = {
		"move.",
		"they're suffering because of you.",
		"your cowardice will cost lives.",
		"scared stiff as usual.",
		"don't be meek.",
		"vile submission.",
		"you're not that scared.",
		"given up already?",
		"they cry your name, yet nobody comes.",
		"i can feel you falling apart.",
		"it will come for you.",
		"fight. back.",
		"you won't be missed.",
		"nobody will mourn you."
	},
	Killers = {
		"you disgust me.",
		"i brought you here for a purpose.",
		"kill.",
		"play your role.",
		"i don't appreciate your morality.",
		"they won't remember you.",
		"don't have the guts?",
		"you're worthless.",
		"waste of purpose.",
		"they'll die either way.",
		"entertain me.",
		"i can see you."
	}
}

function t1.Start(_) -- line: 71
	-- upvalues: Util (copy), RunService (copy), UserInputService (copy), t3 (copy), t2 (copy), Network (copy)
	local u9 = false
	local n1 = 0
	local n2 = 0
	local n3 = 0
	local n4 = 0
	local n5 = 0
	local LocalPlayer = game.Players.LocalPlayer

	Util:GetLocalTranslator()

	local MainUI = LocalPlayer.PlayerGui:WaitForChild("MainUI")
	local clone = script.InsaneVignette:Clone()
	local clone2 = script.Warning:Clone()
	clone2.TextColor3 = Color3.fromRGB(255, 0, 0)

	clone.Parent = MainUI
	clone2.Parent = MainUI

	local function applyExponentialCurve(p2, p3) -- line: 99
		return p2 ^ (1 / (1 - p3 + 1E-05))
	end

	local n6 = 0

	local function randomCase(p4) -- line: 115
		local t4 = {}

		for i = 1, #p4 do
			local v30 = p4:sub(i, i)

			if math.random(0, 1) == 1 then
				table.insert(t4, v30:upper())
			else
				table.insert(t4, v30:lower())
			end
		end

		return table.concat(t4)
	end

	local t5 = {}

	RunService.RenderStepped:Connect(function(dt) -- line: 130
		-- upvalues: Util (copy), LocalPlayer (copy), UserInputService (copy), n5 (ref), n4 (ref), n1 (ref), u9 (ref), n2 (ref), clone (copy), t5 (copy), n6 (ref), t3 (copy), t2 (copy), clone2 (copy), Network (copy), n3 (ref), randomCase (copy)
		local SettingValue = Util:GetSettingValue("EpilepsyMode", game.Players.LocalPlayer)
		local Character = LocalPlayer.Character
		local v34 = Character and (not not Character.Parent and Character.Parent.Name) or ""

		if #UserInputService:GetKeysPressed() == 0 and (os.clock() - n5 > 1 and Util:IsAlive(Character)) and (v34 == "Killers" or v34 == "Survivors") then
			n4 += dt / 90
		else
			n4 -= dt / 0.125
		end

		n4 = math.clamp(n4, -0.05555555555555555, 1)

		local v35 = n1

		if not u9 and v35 <= 0 and n4 <= 0 then
			return
		end

		local v36 = u9 and dt / 120 or -dt / 0.125

		n1 = math.clamp(n1 + v36, 0, 1)

		if u9 then
			n2 += dt
		end

		local v37 = math.max(n4, n1) ^ 6.6662222518498755
		local v38 = v37 * 2

		clone.Position = UDim2.fromScale(0.5, 0.5) + UDim2.fromScale(math.random(-v38, v38) / 1000, math.random(-v38 * 2.5, v38 * 2.5) / 1000)
		clone.ImageTransparency = 1 - v37

		if not t5.TimeSinceMessageChange then
			t5.TimeSinceMessageChange = os.clock()
		end

		local s1

		if os.clock() >= t5.TimeSinceMessageChange + 2 then
			t5.TimeSinceMessageChange = os.clock()

			if n2 >= 300 and not t5.ScreamingForHelp then
				t5.TimeSinceMessageChange = os.clock() + 2
				t5.ScreamingForHelp = true
				s1 = "APieceForThePuzzle Awaits You"
			else
				n6 += 1

				local v40 = if not (n1 <= 0.01) or not t3[v34] then t2 else t3[v34]

				s1 = v40[n6 % #v40 + 1]
			end
		else
			s1 = clone2.Text
		end

		if n4 >= 0.999 and os.clock() - 0 > 7 then
			Network:FireServerConnection("AFKInsanity", "REMOTE_EVENT")
		end

		if s1 == "APieceForThePuzzle Awaits You" or SettingValue and os.clock() - n3 < 0.9 then
		else
			n3 = os.clock()
			s1 = randomCase((tostring(s1)))
		end

		clone2.Position = UDim2.fromScale(0.5, 0.5) + UDim2.fromScale(math.random(-v38, v38) / 1000, math.random(-v38 * 2.5, v38 * 2.5) / 1000)
		clone2.Text = s1
		clone2.TextTransparency = 1 - v37
		clone2.TextStrokeTransparency = 1 - v37 / 2
	end)
	UserInputService.WindowFocused:Connect(function() -- line: 199
		-- upvalues: u9 (ref), n2 (ref), t5 (copy)
		u9 = false
		n2 = 0
		t5.ScreamingForHelp = false
	end)
	UserInputService.WindowFocusReleased:Connect(function() -- line: 206
		-- upvalues: u9 (ref)
		u9 = true
	end)

	for _, v in ipairs({
		"TouchPan",
		"InputChanged",
		"InputBegan",
		"InputEnded",
		"TouchMoved",
		"TouchStarted",
		"TouchEnded"
	}) do
		UserInputService[v]:Connect(function() -- line: 213
			-- upvalues: n5 (ref)
			n5 = os.clock()
		end)
	end
end

return t1

]========]},
}
local installed=0
for _,change in changes do
 change.target=assert(find(change.path),"Missing module: "..change.path..". Nothing changed.")
 change.before=change.target.Source
 if change.before==change.after then installed+=1
 else assert(table.find(change.allowed,fingerprint(change.before)),"Current Source differs: "..change.path..". Nothing changed; send this module for a matching repair.")end
end
if installed==#changes then print("[Cooldown polish] Already installed.");return end
assert(installed==0,"Partially installed repair. Nothing changed; restore the previous repair before trying again.")
local backup=Instance.new("Folder");local base="CooldownPolish_Backup_"..os.date("!%Y%m%d_%H%M%S");backup.Name=base
local i=0;while game.ServerStorage:FindFirstChild(backup.Name)do i+=1;backup.Name=base.."_"..i end
for i,change in changes do
 local record=Instance.new("Folder");record.Name="Source_"..i
 local target=Instance.new("ObjectValue");target.Name="Target";target.Value=change.target;target.Parent=record
 local before=Instance.new("StringValue");before.Name="Before";before.Value=change.before;before.Parent=record
 record:SetAttribute("Installed",fingerprint(change.after));record.Parent=backup
end
backup.Parent=game.ServerStorage
local ok,err=pcall(function()for _,change in changes do change.target.Source=change.after end end)
if not ok then
 for _,change in changes do if change.target.Source~=change.before then change.target.Source=change.before end end
 backup:Destroy();error("[Cooldown polish] Rolled back: "..tostring(err))
end
print("[Cooldown polish] Installed continuous recovery updates, green Haste countdowns, and red idle/tabbed-out warnings. Save and restart Play. Backup: "..backup.Name)
