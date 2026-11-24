local AnalyticsService = game:GetService("AnalyticsService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Actors = {
	ActorAdded = nil,
	CurrentActors = {}
}

RunService:IsClient()

local v6 = RunService:IsServer()
local v7 = workspace:GetAttribute("ServerType") == "VIP"
local DataHandler = require(ReplicatedStorage.Modules.DataHandler)
local Network = require(ReplicatedStorage.Modules.Network)
local Sounds = require(ReplicatedStorage.Modules.Sounds)
local Util = require(ReplicatedStorage.Modules.Util)
local Ragdolls = require(ReplicatedStorage.Modules.Ragdolls)
local CharacterReplication = require(ReplicatedStorage.Systems.Player.Game.CharacterReplication)
local Signal = require(ReplicatedStorage.Modules.Misc.Signal)
local Janitor = require(ReplicatedStorage.Modules.Misc.Janitor)
local t2 = {
	Killer = "Slasher",
	Survivor = "Noob"
}
local t3 = {
	Idle = "rbxassetid://132063305616391",
	Walk = "rbxassetid://117836414993134",
	Run = "rbxassetid://115242555951354",
	InjuredIdle = "rbxassetid://85187709684165",
	InjuredWalk = "rbxassetid://74821406611654",
	InjuredRun = "rbxassetid://72674527126213",
}

function Actors.__len(p1) -- line: 41
	-- upvalues: Actors (copy)
	local n1 = 0

	for _, v in pairs(Actors.CurrentActors) do
		local v21 = v.Rig and v.Rig:FindFirstChild("Humanoid")

		if p1.ActorName == v.ActorName and v21 and v21.Health > 0 then
			n1 += 1
		end
	end

	return n1
end
function Actors.CreateActor(_: {[any]: any}, p2, s1: string, s2: string?, s3: string?) -- line: 52
	-- upvalues: Actors (copy), ReplicatedStorage (copy), v6 (copy), ServerStorage (copy), t2 (copy), Signal (copy), v7 (copy), AnalyticsService (copy), Network (copy), Sounds (copy), CharacterReplication (copy), RunService (copy), Util (copy), Ragdolls (copy)
	if not s2 then
		local v29, v30 = Actors:GetEquippedActorInfo(p2, s1, true)

		s2 = v29
		s3 = v30
	end

	local assetsFolder = ReplicatedStorage.Assets:FindFirstChild(`{s1}s`)
	local actorFolder

	if typeof(s2) == "Instance" and s2:IsA("Folder") then
		actorFolder = s2
	else
		actorFolder = assetsFolder and (assetsFolder:FindFirstChild(s2) or assetsFolder:FindFirstChild(tostring(t2[s1])))
	end

	if actorFolder and p2.Character and p2.Character.PrimaryPart and p2.Character.Humanoid.Health > 0 and not Actors.CurrentActors[p2] then
		local v36 = setmetatable({
			Cache = {},
			Cooldowns = {},
			AbilityDisablers = {}
		}, Actors)

		v36.Player = p2
		v36.Folder = actorFolder
		v36.Signals = {}
		v36.ActorType = s1
		v36.ActorName = s2
		v36.ActorSkin = s3

		if s1 == "Killer" then
			v36.TotalKills = 0
		end

		v36.Signals.AbilityUsed = Signal.new()

		if not v7 then
			if typeof(p2) == "Instance" and p2:IsA("Player") then
				local ok, result = pcall(function() -- line 107
					-- upvalues: AnalyticsService (copy), p2 (copy), s2 (ref), s1 (copy), s3 (ref)
					AnalyticsService:LogCustomEvent(p2, "TrackCreatedCharcter", 1, {
						[Enum.AnalyticsCustomFieldKeys.CustomField01.Name] = `Character - { s2 }`,
						[Enum.AnalyticsCustomFieldKeys.CustomField02.Name] = `Type - { s1 }`,
						[Enum.AnalyticsCustomFieldKeys.CustomField03.Name] = `Skin - { s3 }`
					})
				end)

				if not ok then
					warn(`Failed to log custom event: { result }`)
				end
			end
		end

		Actors:ApplySkinDataToActorInfo(v36)

		function v36.IncrementCharges(_: {[any]: any}, s4: string, n2: number, n3: number) -- line: 129
			-- upvalues: v6 (copy), v36 (copy), Network (copy), p2 (copy)
			if not v6 then
				warn(`attempt to add charges to { tostring(s4) } on client!`)

				return
			end

			local v168 = v36 and (v36.Behavior.Abilities and v36.Behavior.Abilities[s4])

			if not v168 then
				return
			end

			if not v168.CurrentCharges then
				return
			end

			v168.CurrentCharges = math.clamp(v168.CurrentCharges + n2, 0, tonumber(n3) or 1e999)

			local v169 = nil

			if v168.Recharge and v168.CurrentCharges < v168.Charges and not v168.RechargeStartTime then
				v169 = true
				v168.RechargeStartTime = os.clock()
				v168.CurrentRechargeThread = task.delay(v168.Recharge, function() -- line: 147
					-- upvalues: v168 (copy), v36 (copy), s4 (copy)
					v168.CurrentRechargeThread = nil
					v168.RechargeStartTime = nil
					v36:IncrementCharges(s4, 1, v168.Charges)
				end)
			elseif v168.RechargeStartTime and v168.CurrentCharges >= v168.Charges then
				pcall(task.cancel, v168.CurrentRechargeThread)
				v168.CurrentRechargeThread = nil
				v168.RechargeStartTime = nil
				v168.ElapsedRecharge = nil
				v169 = false
			end

			Network:FireClientConnection(p2, "UpdateAbilityCharges", "REMOTE_EVENT", s4, v168.CurrentCharges, v169)
		end
		function v36.AddRecharge(_: {[any]: any}, s5: string, n4: number) -- line: 165
			-- upvalues: v36 (copy), Network (copy), p2 (copy)
			local v173 = v36 and (v36.Behavior.Abilities and v36.Behavior.Abilities[s5])

			if not v173 then
				return
			end

			local Recharge = v173.Recharge
			local RechargeStartTime = v173.RechargeStartTime

			if not Recharge then
				warn(`Attempted to recharge { s5 } which has no recharge time.`)

				return
			end

			if not RechargeStartTime then
				warn(`Attempted to recharge { s5 } which is not currently recharging.`)

				return
			end

			local CurrentCharges = v173.CurrentCharges
			local Charges = v173.Charges
			local v178 = n4 + (v173.RechargeStartTime and os.clock() - v173.RechargeStartTime or 0)
			local v179 = math.floor(v178 / Recharge)

			if Charges <= CurrentCharges + v179 then
				v36:IncrementCharges(s5, Charges, Charges)

				return
			end

			local v180 = v178 % Recharge

			v173.CurrentCharges = math.clamp(v173.CurrentCharges + v179, 0, Charges)

			if v173.CurrentRechargeThread then
				pcall(task.cancel, v173.CurrentRechargeThread)
				v173.CurrentRechargeThread = nil
			end

			v173.RechargeStartTime = os.clock() - v180
			v173.CurrentRechargeThread = task.delay(v173.Recharge - v180, function() -- line: 201
				-- upvalues: v173 (copy), v36 (copy), s5 (copy)
				v173.CurrentRechargeThread = nil
				v173.RechargeStartTime = nil
				v36:IncrementCharges(s5, 1, v173.Charges)
			end)
			Network:FireClientConnection(p2, "UpdateAbilityCharges", "REMOTE_EVENT", s5, v173.CurrentCharges, v180)
		end
		function v36.CanUseAbility(_: {[any]: any}, s6: string) -- line: 211
			-- upvalues: v36 (copy)
			local Player = v36.Player
			local Config = v36.Config
			local v185 = v36 and v36.Behavior
			local v186 = v36 and v36.Cooldowns
			local v187 = v185.Abilities[s6]

			if not Player or (not Config or not v185 or not v186 or not v187) then
				return
			end

			if v186.CANT_ATTACK then
				return
			end

			if v187.CurrentCharges and v187.CurrentCharges <= 0 and not v187.ChargesOptional and not v187.ChargesDisabled and not workspace:GetAttribute("ChargesDisabled") then
				return
			end

			if not workspace:GetAttribute("CooldownsDisabled") then
				if v36.DisabledAbilities and v36.DisabledAbilities[s6] then
					return
				end

				if v36.AbilitiesDisabled then
					return
				end

				if v36:IsOnCooldown(s6) then
					return
				end
			end

			for lockName, locked in pairs(v36.AbilityDisablers) do
				local bypassBlockLock =
					lockName == "GuestReworkBlock"
					and workspace:GetAttribute("CooldownsDisabled")

				if locked and not bypassBlockLock then
					return
				end
			end

			if not Player or not Player.Character then
				return
			end

			if Player.Character:GetAttribute("Ragdolling") then
				return
			end

			if Player.Character:GetAttribute("AbilitiesDisabled") then
				return
			end

			if Player.Character:GetAttribute("UsingAnimations") then
				return
			end

			if Player.Character:FindFirstChildOfClass("Tool") then
				return
			end

			return true
		end
		function v36.CanUseItem(_: {[any]: any}, s7: string) -- line: 241
			-- upvalues: v36 (copy)
			local Player = v36.Player
			local Config = v36.Config
			local v194 = v36 and v36.Behavior
			local v195 = v36 and v36.Cooldowns

			if not Player or (not Config or not v194 or not v195) then
				return
			end

			if v195.CANT_ATTACK then
				return
			end

			if not workspace:GetAttribute("CooldownsDisabled") then
				if v36.DisabledAbilities and v36.DisabledAbilities[s7] then
					return
				end

				if v36.AbilitiesDisabled then
					return
				end
			end

			if v36.AbilityDisablers.ItemsDisabled then
				return
			end

			if not Player or not Player.Character then
				return
			end

			if Player.Character:GetAttribute("Ragdolling") then
				return
			end

			if Player.Character:GetAttribute("AbilitiesDisabled") then
				return
			end

			if Player.Character:GetAttribute("UsingAnimations") then
				return
			end

			return true
		end
		function v36.PlayVoiceline(_, p4, p5) -- line: 264
			-- upvalues: Sounds (copy), v36 (copy)
			Sounds:PlayVoiceline(v36, p4, p5)
		end

		for _, v in pairs(v36.Behavior.Abilities or {}) do
			if v.Charges then
				v.CurrentCharges = v.Charges
			end
		end

		function v36.IsOnCooldown(_, p7) -- line: 276
			-- upvalues: v36 (copy)
			local v201 = v36 and v36.Cooldowns

			if v201[p7] and workspace:GetServerTimeNow() < v201[p7] then
				return v201[p7] - workspace:GetServerTimeNow()
			end

			return false
		end
		function v36.SetCooldownOf(_: {[any]: any}, s8: string, n5: number) -- line: 285
			-- upvalues: v36 (copy), Network (copy), p2 (copy)
			local v205 = v36 and v36.Cooldowns

			if not v36 or (not v36.Behavior.Abilities or not v36.Behavior.Abilities[s8]) then
				return
			end

			if tonumber(n5) and n5 ~= 0 and not workspace:GetAttribute("CooldownsDisabled") then
				local v206 = n5 < 0 and (not not v205[s8] and v205[s8] - workspace:GetServerTimeNow() + n5) or n5

				v205[s8] = workspace:GetServerTimeNow() + v206
			else
				v205[s8] = nil
			end

			Network:FireClientConnection(p2, "UpdateAbilityCooldown", "REMOTE_EVENT", s8, n5)
		end

		local Actors0 = {}

		function v36.DisableAbilities(_: {[any]: any}, s9: string, b1: boolean, n6: number?) -- line: 307
			-- upvalues: v36 (copy), Actors0 (copy)
			v36.AbilityDisablers[s9] = b1

			if n6 then
				if Actors0[s9] then
					pcall(task.cancel, Actors0[s9])
					Actors0[s9] = nil
				end

				Actors0[s9] = task.delay(n6, function() -- line: 315
					-- upvalues: v36 (copy), s9 (copy), b1 (copy)
					v36.AbilityDisablers[s9] = not b1
				end)
			end
		end
		function v36.PivotTo(_: {[any]: any}, cFrame: CFrame) -- line: 321
			-- upvalues: v6 (copy), v36 (copy), CharacterReplication (copy)
			assert(v6, "Do not.")
			v36.Rig:PivotTo(cFrame)
			local v213 = v36.ClientV or v36.Rig.PrimaryPart.AssemblyLinearVelocity

			v36.SerializedCF = CharacterReplication.Serialize(cFrame, v213)
			v36.ClientCF = cFrame
			v36.ClientV = v213
			v36.LastClientCFUpdateTime = os.clock()
			v36.ServerCurrentCF = cFrame
			v36.ServerDesiredCF = cFrame

			if v36.Player and v36.Rig:HasTag("Replicating") then
				local QueryHitbox = v36.Rig:FindFirstChild("QueryHitbox")

				if QueryHitbox then
					QueryHitbox.CollisionConnector.Enabled = false
					QueryHitbox.Anchored = true
					QueryHitbox.CFrame = cFrame
				end
			end
		end
		function v36.GetPivot(_: {[any]: any}, b2: boolean?) -- line: 345
			-- upvalues: v36 (copy), v6 (copy), RunService (copy), p2 (copy)
			local Rig = v36.Rig
			local v218 = Rig and Rig.PrimaryPart

			if not v218 then
				return
			end

			if not workspace:GetAttribute("ExperimentalHitboxes") or not v6 then
				return v218.CFrame
			end

			if v36.LastClientCFUpdateTime and v36.ServerCurrentCF and v36.ClientV and os.clock() - v36.LastClientCFUpdateTime < 0.35 then
				local ServerCurrentCF = v36.ServerCurrentCF
				local ClientV = v36.ClientV

				if b2 then
					local ServerDesiredCF = v36.ServerDesiredCF
					local v222 = math.clamp(os.clock() - v36.LastClientCFUpdateTime, 0, 0.15)

					ServerCurrentCF = ServerDesiredCF + ClientV * (((if not RunService:IsStudio() then math.clamp(p2:GetNetworkPing(), 0, 0.12) / 1.4 + 0.06 else 0)) + v222) / 4
				end

				return ServerCurrentCF
			end

			return v218.CFrame
		end

		Util:PreloadAssets(v36.Config)

		if v36.Behavior.GetRig then
			v36.Rig = v36.Behavior:GetRig(v36)
			v36.RigName = v36.Rig.Name
		else
			v36.Rig = v36.Rig and v36.Rig:Clone() or nil
		end

		if not v36.Rig then
			p2:LoadCharacter()()

			return
		end

		local PrimaryPart = v36.Rig.PrimaryPart

		if PrimaryPart then
			PrimaryPart.Anchored = true
		end

		local Humanoid = v36.Rig:FindFirstChild("Humanoid")

		if not Humanoid then
			Humanoid = Instance.new("Humanoid")
			Humanoid.Parent = v36.Rig
			Instance.new("Animator").Parent = Humanoid
		end

		Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None

		local s2_2 = ReplicatedStorage.Assets.Skins[`{ s1 }s`]:FindFirstChild(s2)
		local v45 = s2_2 and s2_2:FindFirstChild((tostring(s3)))
		local v46 = v45 and require(v45.Config)
		local v47 = p2.Character and p2.Character.PrimaryPart
		local Humanoid2 = v36.Rig.Humanoid

		Humanoid2.JumpHeight = 0
		Humanoid2.JumpPower = 0
		Humanoid2.MaxSlopeAngle = 65
		Humanoid2.BreakJointsOnDeath = false
		Humanoid2.HipHeight = v36.Config.HipHeight or 0
		Humanoid2.WalkSpeed = v36.Config.Speed or 16
		Humanoid2.MaxHealth = v36.Config.Health or 100
		Humanoid2.Health = Humanoid2.MaxHealth
		Humanoid2:SetAttribute("BaseSpeed", Humanoid2.WalkSpeed)
		v36.Rig.Name = actorFolder.Name
		v36.Rig:SetAttribute("Username", p2.Name)
		v36.Rig:SetAttribute("SkinName", (tostring(s3)))
		v36.Rig:SetAttribute("SkinNameDisplay", v46 and v46.DisplayName or "")
		v36.Rig:SetAttribute("ActorDisplayName", (tostring(v36.Config.DisplayName)))

		if workspace:GetAttribute("ExperimentalReplication") then
			v36.Rig:AddTag("Replicating")
		end

		if v47 then
			v36.Rig:SetPrimaryPartCFrame(v47.CFrame)
			task.delay(0.1, function() -- line: 438
				-- upvalues: PrimaryPart (copy)
				PrimaryPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
				PrimaryPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
			end)
		end

		if v36.Config.DirectionalMovementDisabled then
			v36.Rig:SetAttribute("DirectionalMovementDisabled", true)
		end

		if v36.Config.Sounds and v36.Config.Sounds.Ambience then
			Sounds:Play(v36.Config.Sounds.Ambience, {
				Looped = true,
				Parent = v36.Rig.PrimaryPart
			})
		end

		Humanoid2.Died:Once(function() -- line: 452
			-- upvalues: v36 (copy), Sounds (copy), p2 (copy), Ragdolls (copy), Actors (copy)
			local PrimaryPart2 = v36.Rig.PrimaryPart

			if PrimaryPart2 then
				(Sounds:Play("deadJ" .. p2.Name, {
					Parent = PrimaryPart2
				}) or Sounds:Play("dead", {
					Parent = PrimaryPart2
				})):SetAttribute("Bypassable", true)
			end

			Sounds:PlayVoiceline(v36, "Died", {
				Priority = 10
			})

			local KillEffects = v36.Config.KillEffects

			if KillEffects then
				Ragdolls.AddProfile(v36.Rig, {
					KillEffects = KillEffects
				})
			end

			Actors:CleanupActorFromPlayer(p2)
		end)

		local Pants = v36.Rig:FindFirstChildOfClass("Pants")
		local Shirt = v36.Rig:FindFirstChildOfClass("Shirt")
		local ShirtGraphic = v36.Rig:FindFirstChildOfClass("ShirtGraphic")

		if Pants and Pants.PantsTemplate == "" then
			Pants.PantsTemplate = Pants:GetAttribute("ID") or ""
		end

		if Shirt and Shirt.ShirtTemplate == "" then
			Shirt.ShirtTemplate = Shirt:GetAttribute("ID") or ""
		end

		if ShirtGraphic and ShirtGraphic.Graphic then
			ShirtGraphic.Graphic = ShirtGraphic:GetAttribute("ID") or ""
		end



		local u52 = v36.RigName and v36.Config[`Expressions{ v36.RigName }`] or v36.Config.Expressions

		if u52 and not v36.Rig.Head:FindFirstChild("face") then
			local v53 = v36.Rig:FindFirstChild("ExpressionHolder", true) or ReplicatedStorage.Assets.Instances.ExpressionHolder:Clone()

			if not v53.Parent then
				v53.Parent = v36.Rig
				v53.CFrame = v36.Rig.Head.CFrame * CFrame.new(0, 0, -0.005)

				local WeldConstraint = Instance.new("WeldConstraint")

				WeldConstraint.Part0 = v36.Rig.Head
				WeldConstraint.Part1 = v53
				WeldConstraint.Parent = v53
			end

			local v55 = v53:FindFirstChildOfClass("Decal") or Instance.new("Decal")

			if not v55.Parent then
				v55.Parent = v53
			end

			v55.Name = "Expression"

			local thread = nil

			function v36.ChangeExpression(_, p9, p10) -- line: 513
				-- upvalues: u52 (ref), v36 (copy), thread (ref), v55 (copy), Humanoid2 (copy)
				u52 = v36.RigName and v36.Config[`Expressions{ v36.RigName }`] or v36.Config and v36.Config.Expressions

				if not v36.Rig.Parent then
					return
				end

				if not u52 or not u52[p9] then
					return
				end

				if thread then
					task.cancel(thread)
				end

				if p9 == "Default" then
					v55.Texture = Humanoid2.Health <= Humanoid2.MaxHealth / 2 and u52.Injured or u52.Default
				else
					v55.Texture = u52[p9]
				end

				pcall(v36.Behavior.onExpressionChanged, v36.Behavior, v36, p9, p10)

				if p10 then
					thread = task.delay(p10, function() -- line: 532
						-- upvalues: Humanoid2 (copy), u52 (ref), v55 (copy), v36 (copy)
						local v267 = Humanoid2.Health <= Humanoid2.MaxHealth / 2

						if u52 then
							v55.Texture = v267 and u52.Injured or u52.Default
						end

						pcall(v36.Behavior.onExpressionChanged, v36.Behavior, v36, not v267 and "Default" or "Injured", nil)
					end)
				end
			end

			v55.Texture = u52.Default or ""

			local Health = Humanoid2.Health

			Humanoid2.HealthChanged:Connect(function(p11) -- line: 547
				-- upvalues: v36 (copy), thread (ref), Health (ref), u52 (ref), Sounds (copy)
				if p11 <= 0 then
					v36:ChangeExpression("Dead")

					function v36.ChangeExpression() -- line: 553
					end

					if thread then
						pcall(task.cancel, thread)
					end

					thread = nil
				elseif p11 < Health and u52 and u52.Hurt then
					v36:ChangeExpression("Hurt", 0.75)
				elseif p11 > Health + 20 and u52 and u52.Happy then
					v36:ChangeExpression("Happy", 0.75)
				else
					v36:ChangeExpression("Default")
				end

				if Health - p11 >= 15 then
					Sounds:PlayVoiceline(v36, "Injured", {
						Priority = 5
					})
				end

				Health = p11
			end)
		else
			function v36.ChangeExpression(_, _, _) -- line: 578
			end
		end

		for _, child in pairs(workspace.Players:GetChildren()) do
			if child.Name:find(s1) then
				v36.Rig.Parent = child

				break
			end
		end

		task.spawn(function() -- line: 590
			-- upvalues: v36 (copy), Util (copy)
			for k, v in pairs(v36.Config.Animations) do
				if tostring(k):find("Execution") and typeof(v) == "table" then
					v36.Cache[`{ k }Anim`] = Util:LoadAnimationFromID(v36.Rig, v.KillerRig, true)
				end
			end
		end)
		task.spawn(function() -- line: 599
			-- upvalues: v36 (copy), Sounds (copy)
			if v36.Config.Voicelines and v36.Config.Voicelines.Idle then
				while task.wait(math.random(10, 25)) and v36 and v36.Rig and v36.Rig.PrimaryPart do
					if not v36.Rig.PrimaryPart:FindFirstChild("VoicelineSFX") then
						local Humanoid3 = v36.Rig:FindFirstChildOfClass("Humanoid")

						if Humanoid3 and Humanoid3.Health >= Humanoid3.MaxHealth / 2 and v36.Config.Voicelines.IdleInjured then
							Sounds:PlayVoiceline(v36, "IdleInjured", {
								Priority = 0
							})
						else
							Sounds:PlayVoiceline(v36, "Idle", {
								Priority = 0
							})
						end
					end
				end
			end
		end)

		if p2.Character then
			p2.Character:Destroy()
		end

		p2.Character = v36.Rig
		Util:FixCharacter(v36.Rig, `{ s1 }s`)
		Util:AddHitboxes(v36, `{ s1 }s`)

		local v60 = Util:CopyTable(v36)

		v60.Information = nil
		v60.Behavior = nil
		v60.Config = nil
		Network:FireAllClientConnection("ActorCreated", "REMOTE_EVENT", v60)

		for _, v in pairs({
			"Created",
			"CreatedPost"
		}) do
			if v36.Behavior[v] then
				v36.Behavior[v](v36.Behavior, v36)
			end
		end

		local v63 = v36.Config.SprintSpeed or 26
		local BaseSpeed = Humanoid2:GetAttribute("BaseSpeed")

		Util:SetSpeedCap(p2, "Sprinting", v63 / BaseSpeed)
		Actors.CurrentActors[p2] = v36
		Actors.__actorCreated:Fire(v36)

		return v36
	end
end
function Actors.GetActorFromPlayer(_: {[any]: any}, p15) -- line: 653
	-- upvalues: Actors (copy)
	return Actors.CurrentActors[p15]
end
function Actors.CleanupActorFromPlayer(_, p17) -- line: 657
	-- upvalues: Actors (copy), Network (copy)
	local v69 = Actors.CurrentActors[p17]

	if v69 then
		if v69.Behavior and v69.Behavior.Destroyed then
			v69.Behavior:Destroyed(v69)
		end

		for v70, v71 in v69.Signals do
			if v71 and typeof(v71) == "table" and v71.Destroy then
				local ok, result = pcall(function() -- line: 667
					-- upvalues: v71 (copy)
					v71:Destroy()
				end)

				if not ok then
					warn(`[{ script }]: Failed to destroy signal { v70 }: { result }`)
				end
			end
		end

		Network:FireAllClientConnection("ActorDestroyed", "REMOTE_EVENT", p17)
		Actors.__actorDestroyed:Fire(v69)
		if v69._janitor then v69._janitor:Destroy() end

		if p17.Character then
			p17.Character:RemoveTag("Replicating")
		end

		Actors.CurrentActors[p17] = nil
	end
end
function Actors.GetEquippedActorInfo(_: {[any]: any}, p18, s10: string, b3: boolean?) -- line: 690
	-- upvalues: DataHandler (copy), ReplicatedStorage (copy)
	local v78 = DataHandler:Get(p18, 0)
	local v79 = v78 and v78:FindFirstChild("Equipped")
	local v80 = v79 and (not not v79:FindFirstChild(s10) and v79[s10].Value) or ""
    if v80=="Randomized" then
        local purchased=v78 and v78:FindFirstChild("Purchased")
        local owned=purchased and purchased:FindFirstChild(s10.."s")
        local catalog=ReplicatedStorage.Assets:FindFirstChild(s10.."s")
        local choices={}
        if owned and catalog then
            for _,item in owned:GetChildren()do
                if not item:GetAttribute("Temp") and catalog:FindFirstChild(item.Name)then table.insert(choices,item.Name)end
            end
        end
        table.sort(choices)
        v80=#choices>0 and choices[b3 and math.random(1,#choices) or 1] or (s10=="Killer" and "Slasher" or "Noob")
    end
	local v81 = v79 and v79:FindFirstChild("Skins")
	local v82 = v81 and (not not v81:FindFirstChild(v80) and v81[v80].Value) or ""

	if v82 == "Randomized" and b3 then
		local v83 = v78 and v78:FindFirstChild("Purchased")
		local v84 = v83 and v83:FindFirstChild("Skins")
		local v85 = ReplicatedStorage.Assets.Skins:FindFirstChild(`{ s10 }s`)
		local v86 = v85 and v85:FindFirstChild(v80)
		local Actors6 = { "" }

		if v84 and v86 then
			for _, child in v86:GetChildren() do
				if v84:FindFirstChild(child.Name) then
					table.insert(Actors6, child.Name)
				end
			end
		end

		return v80, Actors6[math.random(1, #Actors6)]
	end

	return v80, v82
end
function Actors.GetAmountOfLivingActorsOfClass(_: {[any]: any}, s11: string) -- line: 720
	-- upvalues: Actors (copy)
	local n7 = 0

	for _, v in pairs(Actors.CurrentActors) do
		if v.Config and s11 == v.Config.Class then
			n7 += 1
		end
	end

	return n7
end
function Actors.ApplySkinDataToActorInfo(_, p20) -- line: 730
	-- upvalues: Util (copy), t3 (copy), ReplicatedStorage (copy)
	local v97 = game["Run Service"]:IsServer()
	local folder = p20.Folder
	local actorType = p20.ActorType
	local actorName = p20.ActorName
	local actorSkin = p20.ActorSkin
	local behaviorModule = folder and folder:FindFirstChild("Behavior")
	local configModule = folder and folder:FindFirstChild("Config")

	if not behaviorModule or not configModule then
		warn(`[{script}]: Missing behavior or config module for actor {tostring(actorName)}`)
		return
	end

	p20.Behavior = Util:CopyTable(require(behaviorModule))
	p20.Config = Util:CopyTable(require(configModule))

	if v97 then
		p20.Rig = p20.Config.Rig
	end

	for k, v in pairs(t3) do
		if not p20.Config.Animations[k] then
			p20.Config.Animations[k] = v
		end
	end

	local skinRoot = ReplicatedStorage.Assets.Skins:FindFirstChild(tostring(actorType) .. "s")
	local actorSkinFolder = skinRoot and skinRoot:FindFirstChild(actorName)
	local skinFolder = actorSkin and actorSkinFolder and actorSkinFolder:FindFirstChild(actorSkin)

	p20.SkinFolder = skinFolder

	if skinFolder then
		local skinConfig = skinFolder:FindFirstChild("Config") and require(skinFolder.Config)
		local skinBehavior = skinFolder:FindFirstChild("Behavior") and require(skinFolder.Behavior)
		local skinRig = v97 and skinConfig and skinConfig.Rig

		p20.Config = Util:MergeTables(p20.Config, skinConfig, {
			"DisplayName",
			"TextInteractions"
		})
		p20.Behavior = Util:MergeTables(p20.Behavior, skinBehavior)
		p20.SkinFolder = skinFolder

		if skinRig then
			p20.Rig = skinRig
		end

		return skinFolder
	end
end
function Actors.CreateChatInteraction(_: {[any]: any}, p21, s12: string, p22) -- line: 792
	-- upvalues: Actors (copy), Sounds (copy), Util (copy)
	if typeof(p21) == "Instance" then
		p21 = Actors.CurrentActors[p21] or Actors.CurrentActors[game.Players:GetPlayerFromCharacter(p21)]
	end

	if typeof(p22) == "Instance" then
		p22 = Actors.CurrentActors[p22] or Actors.CurrentActors[game.Players:GetPlayerFromCharacter(p22)]
	end

	if not p21 then
		return
	end

	local TextInteractions = p21.Config.TextInteractions

	if not TextInteractions then
		return
	end

	local parts = string.split(s12, "/")

	for _, v in pairs(parts) do
		TextInteractions = TextInteractions[`{ p22 and tostring(p22.ActorSkin):gsub(p22.ActorName, "") or "" }{ v }`] or (TextInteractions[v] or TextInteractions.Regular)

		if not TextInteractions then
			return
		end
	end

	local v127 = TextInteractions[math.random(#TextInteractions)]

	if v127 then
		if typeof(v127) == "table" and v127.Sound and v127.Text then
			Sounds:Play(v127.Sound, {
				Parent = p21.Rig.PrimaryPart
			})
			Util:DisplayBubble(p21.Rig, v127.Text)

			return
		end

		if typeof(v127) == "table" then
			task.spawn(function() -- line: 818
				-- upvalues: v127 (copy), p21 (ref), p22 (ref), Util (copy)
				for _, v in pairs(v127) do
					local Rig = nil
					local parts2 = string.split(v, " ")

					if parts2[1]:find(":") then
						if parts2[1]:find(p21.ActorName) then
							Rig = p21.Rig
						elseif p22 and parts2[1]:find(p22.ActorName) then
							Rig = p22.Rig
						end

						table.remove(parts2, 1)
					end

					Util:DisplayBubble(Rig, table.concat(parts2, " "))
					task.wait((math.clamp(#parts2 / 2 + v:len(), 1, 4)))
				end
			end)
		else
			Util:DisplayBubble(p21.Rig, v127)
		end
	end
end
function Actors.GiveEXP(_: {[any]: any}, p23, p24, n8: number) -- line: 842
	local PlayerData = p23:FindFirstChild("PlayerData")

	if not PlayerData then
		return false
	end

	local TrackPlayerFriendBoost = require(game.ServerScriptService.Server.Miscellaneous.Account.TrackPlayerFriendBoost)
	local v134 = p23:GetAttribute("EXPMultiplier") or 1
	local EXPBoostTime = PlayerData:FindFirstChild("EXPBoostTime", true)

	if EXPBoostTime and EXPBoostTime.Value > 0 then
		v134 += 0.25
	end

	local PlayerBoost = TrackPlayerFriendBoost:GetPlayerBoost(p23)

	if PlayerBoost then
		v134 += PlayerBoost
	end

	if tonumber(n8) then
		n8 *= v134
	end

	local num = tonumber(string.format("%.2f", n8))

	if p24 then
		p24.Value = p24.Value + tonumber(num)
	end

	return num
end
function Actors.IncrementActorStats(_: {[any]: any}, p25, t21: {[any]: any}) -- line: 870
	-- upvalues: RunService (copy), DataHandler (copy), Actors (copy), Util (copy), Network (copy)
	assert(RunService:IsServer(), "cannot increment actor stats on the client.")

	if workspace:GetAttribute("ServerType") == "VIP" then
		return
	end

	if typeof(p25) ~= "Instance" and not p25:IsA("Player") then
		return
	end

	local v141 = ({
		Support = {
			Money = 8,
			EXP = 12,
			KillerChance = 0.5
		},
		Offensive = {
			Money = 5,
			EXP = 15,
			KillerChance = 0.75
		},
		Survivalist = {
			Money = 3,
			EXP = 12,
			KillerChance = 0.25
		},
		VeryDifficultKillerAction = {
			Money = 20,
			EXP = 60
		},
		DifficultKillerAction = {
			Money = 12,
			EXP = 36
		},
		RegularKillerAction = {
			Money = 8,
			EXP = 24
		},
		EasyKillerAction = {
			Money = 4,
			EXP = 12
		}
	})[t21.RewardType]

	if v141 then
		t21.Money = t21.Money or tonumber(v141.Money)
		t21.EXP = t21.EXP or tonumber(v141.EXP)
		t21.KillerChance = t21.KillerChance or tonumber(v141.KillerChance)
	end

	local ok, result = pcall(function() -- line: 922
		-- upvalues: t21 (copy), DataHandler (copy), p25 (copy), Actors (copy), Util (copy), Network (copy)
		local v239 = nil

		if t21.EXP then
			local v240 = DataHandler:Get(p25, 0)

			if not v240 then
				warn(`[Actors:IncrementActorStats]: Missing PlayerData for { p25 }`)

				return
			end

			local ForceActorName = t21.ForceActorName

			if ForceActorName then
				local v242 = v240 and v240:FindFirstChild("Purchased")

				if v242 then
					local Killers = v242:FindFirstChild("Killers")
					local Survivors = v242:FindFirstChild("Survivors")
					local v245 = Killers and Killers:FindFirstChild(ForceActorName) or Survivors and Survivors:FindFirstChild(ForceActorName)

					if v245 then
						v239 = Actors:GiveEXP(p25, v245, t21.EXP)
					else
						warn("AFHIUHAHUWEHFAUWIFIHAHUIFAWIUW")
					end
				end
			else
				local v246 = Actors.CurrentActors[p25]
				local v247 = v246 and v246.Folder
				local v248 = v247 and v247.Name

				if v247 then
					local v249 = v240 and v240:FindFirstChild("Purchased")
					local v250 = v249 and v249:FindFirstChild(`{ tostring(v246 and v246.ActorType) }s`)

					if v250 then
						v239 = Actors:GiveEXP(p25, v250:FindFirstChild(v248), t21.EXP)
					else
						warn("GRSGGASSFDGEGAFEHSVF ESAT")
					end
				end
			end
		end

		Util:AddToPlayerStat(p25, "Money", t21.Money)
		Util:AddToPlayerStat(p25, "KillerChance", t21.KillerChance)

		if typeof(t21.Action) == "string" then
			local str = tostring(t21.Action)
			local v252 = if not t21.Money then nil else `${ tostring(t21.Money) }`
			local v253 = if not v239 then nil else `{ tostring(v239) } EXP`
			local v254 = if not t21.KillerChance or t21.KillerChance == 0 then nil else `{ tostring(t21.KillerChance) } Malice`
			local t22 = {}

			for _, v in ipairs({
				v252,
				v253,
				v254
			}) do
				if v then
					table.insert(t22, (tostring(v)))
				end
			end

			local v258 = table.concat(t22, " & ")

			Network:FireClientConnection(p25, "SendNotif", "REMOTE_EVENT", `+ { v258 }: { str }`, "Objective")
		end
	end)

	if not ok then
		warn(`[Actors:IncrementActorStats]: Failed to increment stats for { p25 } due to: { result }`)
	end
end
function Actors.CreateCutsceneActor(_, p27, p28) -- line: 990
	-- upvalues: ReplicatedStorage (copy), Util (copy)
	local v147 = p27.Config.Animations[p28]

	if not v147 then
		return
	end

	local clone = p27.Rig:Clone()

	clone:RemoveTag("Replicating")

	for _, child in ipairs(clone:GetChildren()) do
		if child:GetAttribute("Hitbox") then
			child:Destroy()
		end
	end

	local clone2 = (p27.SkinFolder and p27.SkinFolder:FindFirstChild(`{ p28 }CameraRig`) or (p27.Folder:FindFirstChild(`{ p28 }CameraRig`) or (p27.SkinFolder and p27.SkinFolder:FindFirstChild("CameraRig") or (p27.Folder:FindFirstChild("CameraRig") or ReplicatedStorage.Assets.Instances.CameraRig)))):Clone()

	game.Debris:AddItem(clone, 30)
	game.Debris:AddItem(clone2, 30)
	clone:WaitForChild("HumanoidRootPart").Anchored = true
	clone2:WaitForChild(clone2:GetAttribute("RootName") or "HumanoidRootPart").Anchored = true
	clone:SetPrimaryPartCFrame(CFrame.new(0, 10000, 0))
	clone2:SetPrimaryPartCFrame(CFrame.new(0, 10000, 0))
	clone.Name = p27.Player.Name .. "ActorRig"
	clone2.Name = p27.Player.Name .. "CameraRig"
	clone.Parent = workspace.Misc
	clone2.Parent = workspace.Misc

	local t23 = {}

	for _, v in pairs({
		"KillerRig",
		"CameraRig"
	}) do
		local v155 = v147[v]
		local v156 = v147[`{ v }Loop`]

		if v155 then
			t23[v] = Util:LoadAnimationFromID(v:find("Killer") and clone or clone2, v155, true)
		end

		if v156 then
			t23[`{ v }Loop`] = Util:LoadAnimationFromID(v:find("Killer") and clone or clone2, v156, true)
		end
	end

	task.spawn(function() -- line: 1052
		-- upvalues: clone2 (copy)
		local CurrentCamera = workspace.CurrentCamera
		local v260 = clone2:GetAttribute("CameraName") or "CameraPart"
		local v261 = clone2:FindFirstChild(v260)

		while clone2.Parent do
			if v261 then
				CurrentCamera.CameraType = Enum.CameraType.Scriptable
				CurrentCamera.CFrame = v261.CFrame
			end

			task.wait()
		end

		local LocalPlayer = game.Players.LocalPlayer
		local v263 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")

		if v263 then
			CurrentCamera.CameraSubject = v263
		end

		CurrentCamera.CameraType = Enum.CameraType.Custom
	end)

	if p28 == "Victory" then
		t23.KillerRig.Stopped:Connect(function() -- line: 1075
			-- upvalues: t23 (copy)
			t23.KillerRig:Play()
			t23.KillerRig.TimePosition = t23.KillerRig.Length
			t23.KillerRig:AdjustSpeed(0)
		end)
	end

	task.delay(t23.CameraRig.Length - 0.1, function() -- line: 1083
		-- upvalues: t23 (copy)
		for k, v in pairs(t23) do
			if not k:find("Loop") then
				if t23[`{ k }Loop`] then
					t23[`{ k }Loop`]:Play(0)
					v:Stop()
				else
					v:AdjustSpeed(0)
				end
			end
		end
	end)

	for _, v in pairs(t23) do
		v:Play(0)
	end

	return clone, clone2, t23
end
function Actors.Start(_) -- line: 1103
	-- upvalues: v6 (copy), Actors (copy), Network (copy)
	if v6 then
		local CharacterReplication2 = require(game.ServerScriptService.Server.Miscellaneous.Replication.CharacterReplication)

		game.Players.PlayerRemoving:Connect(function(player) -- line: 1108
			-- upvalues: Actors (copy)
			Actors:CleanupActorFromPlayer(player)
		end)
		Network:SetConnection("UpdCF", "UREMOTE_EVENT", CharacterReplication2.Received)
	end

	local t24 = {
		__actorCreated = "ActorAdded",
		__actorDestroyed = "ActorRemoved"
	}

	for k, v in pairs(t24) do
		Actors[k] = Instance.new("BindableEvent")
		Actors[k].Name = k
		Actors[k].Parent = script
		Actors[v] = Actors[k].Event
	end
end

return Actors

