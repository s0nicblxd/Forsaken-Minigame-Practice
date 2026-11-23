assert(game:GetService("RunService"):IsStudio()and not game:GetService("RunService"):IsRunning(),"Stop Play before disabling cutscenes.")
local function find(path)
 local current=game
 for part in path:gmatch("[^/]+")do current=current and current:FindFirstChild(part)end
 return current
end
local function fingerprint(source)
 local a,b=5381,0
 for i=1,#source do local byte=source:byte(i);a=(a*33+byte)%4294967296;b=(b*65599+byte)%4294967296 end
 return string.format("%d:%08x:%08x",#source,a,b)
end
local plans={
{path=[========[
ReplicatedStorage/Modules/Actors]========],source=[========[
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

]========],before="33203:eaaa323b:83ede834",after="33124:3effcbb1:076c8cbc"},
{path=[========[
ReplicatedStorage/Systems/Player/Networks/ActorNetwork]========],source=[========[
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

					if v167 then
						local Duration = v167.Duration
						local TimePast = v167.TimePast
						local v184 = math.clamp(TimePast / Duration, 0, 1)
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
	Network:SetConnection("UpdateAbilityCooldown", "REMOTE_EVENT", function(p21, p22) -- line: 994
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
			else
				v41.Cooldowns[p21] = {
					TimePast = 0,
					Duration = p22
				}
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

]========],before="37516:f3cc8c92:21adc1e7",after="33064:4c326576:82949327"},
{path=[========[
ReplicatedStorage/Systems/Player/Networks/RoundNetwork]========],source=[========[
local t1 = {}

function t1.Start(_) -- line: 4
	-- upvalues: t1 (copy)
	local Util = require(game.ReplicatedStorage.Modules.Util)
	local Lighting = require(game.ReplicatedStorage.Modules.Schematics.Lighting)
	local Network = require(game.ReplicatedStorage.Modules.Network)
	local Gamemodes = game.ReplicatedStorage.Modules.Gamemodes
	local LocalPlayer = game.Players.LocalPlayer
	local CurrentCamera = workspace.CurrentCamera

	Network:SetConnection("PreHandleGamemode", "REMOTE_EVENT", function()end)
	Network:SetConnection("HandleGamemode", "REMOTE_EVENT", function(p2, ...) -- line: 21
		-- upvalues: Gamemodes (copy), t1 (copy)
		if p2 == "Init" then
			local v11, v12 = unpack({ ... })

			t1.CurrentSession = require(Gamemodes[v11]).Init(v12)

			return
		end

		if t1.CurrentSession then
			if p2 == "Destroy" then
				t1.CurrentSession:Destroy(...)
				t1.CurrentSession = nil

				return
			end
		else
			warn(`[{ script }]: Couldn't do anything with the information ({ tostring(p2) }) passed to client!`)
		end
	end)
	Network:SetConnection("ReplicateMapCreation", "REMOTE_EVENT", function(p3) -- line: 40
		if not p3 or not p3.Parent then return end
		local lib = require(p3)
		local t2 = {
			Map = p3.Parent,
			Config = lib
		}

		if lib.ClientCreated then
			local ok, result = pcall(function() -- line: 50
				-- upvalues: lib (copy), t2 (copy)
				return lib.ClientCreated(t2)
			end)

			if not ok then
				warn(`[{ script }/ReplicateMapCreation]: There was an issue with calling .ClientCreated() on { p3.Parent.Name } due to: { result }`)
			end
		end
	end)
	Network:SetConnection("LastSurvivor", "REMOTE_EVENT", function(_) -- line: 61
		-- upvalues: Util (copy), LocalPlayer (copy)
		Util:ToggleResetButton(false)

		local v19 = require(game.ReplicatedStorage.Modules.Actors).CurrentActors[LocalPlayer]

		if not v19 then
			return
		end

		if v19.Behavior and v19.Behavior.LastManStanding and v19.Rig and v19.Rig.Parent then
			task.spawn(v19.Behavior.LastManStanding, v19.Behavior, v19, v19.EmotionalLMS)
		end
	end)
	Network:SetConnection("PlayWinnerCutscene", "REMOTE_EVENT", function()end)
end

return t1
]========],before="15346:b907a665:4ad44740",after="2130:1a2a4abb:5370cfc2"},
}
local pending={}
for _,plan in plans do
 local module=find(plan.path)
 assert(module and module:IsA("ModuleScript"),"Missing expected ModuleScript: "..plan.path..". Nothing changed.")
 assert(#plan.source<200000 and fingerprint(plan.source)==plan.after,"Incomplete source. Nothing changed.")
 local hash=fingerprint(module.Source)
 assert(hash==plan.before or hash==plan.after,"Module differs from the supplied FCT build: "..plan.path..". Nothing changed; send its current Source.")
 if hash~=plan.after then table.insert(pending,{module=module,before=module.Source,plan=plan})end
end
if #pending==0 then print("[No cutscenes] Already installed.");return end
local backup=Instance.new("Folder")
local prefix="NoCutscenes_Backup_"..os.date("!%Y%m%d_%H%M%S");local index=0
while game.ServerStorage:FindFirstChild(prefix.."_"..index)do index+=1 end
backup.Name=prefix.."_"..index
for i,item in pending do
 local saved=item.module:Clone();saved.Name=i.."_"..item.module.Name;saved:SetAttribute("OriginalPath",item.plan.path);saved:SetAttribute("AfterFingerprint",item.plan.after);saved.Parent=backup
end
backup.Parent=game.ServerStorage
local ok,err=pcall(function()for _,item in pending do item.module.Source=item.plan.source end end)
if not ok then for _,item in pending do item.module.Source=item.before end;backup:Destroy();error("[No cutscenes] Rolled back: "..tostring(err))end
print("[No cutscenes] Spawn introductions, killer title cards and victory cinematics disabled. Save and start a NEW playtest. Backup: "..backup:GetFullName())
