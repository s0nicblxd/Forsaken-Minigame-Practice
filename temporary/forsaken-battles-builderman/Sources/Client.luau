local CarryVisuals=require(script.Parent.CarryVisuals)


local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")

game:GetService("Players")

local t1 = {}

require(game.ReplicatedStorage.Modules.AchievementUtil)
require(game.ReplicatedStorage.Modules.Sounds)

local Util = require(game.ReplicatedStorage.Modules.Util)

require(game.ReplicatedStorage.Modules.Hitboxes)
require(game.ReplicatedStorage.Modules.Statuses)

local Network = require(game.ReplicatedStorage.Modules.Network)
local trove = require(game.ReplicatedStorage.Modules.Misc.Trove)
local Spring = require(game.ReplicatedStorage.Modules.Misc.Spring)
local u8 = false
local t2 = {
 carrying="Place your carried building before constructing another.",
	collision = "Building area is obstructed by something. Build somewhere else.",
	tooClose = "Building area is too close to a pre-existing building. Move further away and try again.",
	midair = "Building area is too high above ground. Turn around and try again.",
	facingWall = "You're too close to a wall. Turn around and try again.",
	recentActivity = "That building is active. Wait a moment before replacing it.",
	cooldown = "That building is recharging. Try again in a moment.",
	unknown = "Something went wrong. Try building somewhere else.",
	noBuilding = "Stand near one of your buildings to pick it up!"
}

local function getServerTime() -- line: 37
	return workspace:GetServerTimeNow()
end
local function getBuildingRecentActivityRemaining(p1) -- line: 60
	if not p1 or p1:GetAttribute("Destroyed") then
		return 0
	end

	local LastActiveTime = p1:GetAttribute("LastActiveTime")

	if typeof(LastActiveTime) ~= "number" then
		return 0
	end

	return (math.max(0, 10 - (workspace:GetServerTimeNow() - LastActiveTime)))
end
local function setBuildingAbilityLock(p2, s1: string, s2: string, b1: boolean, _: number?) -- line: 119
	-- upvalues: Util (copy)
	if p2.Player == game.Players.LocalPlayer then
		Util:ToggleLockForAbilityIcon(s1, s2, b1)
	end
end
local function initClientSentryAiming(p3) -- line: 153
	-- upvalues: u8 (ref), trove (copy), Spring (copy), CollectionService (copy), Util (copy), RunService (copy)
	if u8 then
		return
	end

	u8 = true

	local function setupSentry(p4) -- line: 164
		-- upvalues: trove (copy), Spring (copy), CollectionService (copy), p3 (copy), Util (copy), RunService (copy)
		if not p4.Name:find("Sentry") then
			return
		end

		local v106 = trove.new()
		local raycastParams = RaycastParams.new()

		raycastParams.FilterType = Enum.RaycastFilterType.Exclude

		local Torso = p4:WaitForChild("Torso", 10)
		local Head = p4:WaitForChild("Head", 10)

		if not Torso or not Head then
			return
		end

		local Neck = Torso:WaitForChild("Neck", 10)

		if not Neck then
			return
		end

		local NeckC0 = Neck.C0
		local u112 = Spring.new(NeckC0, 0.25)

		v106:Add(task.spawn(function() -- line: 189
			-- upvalues: p4 (copy), CollectionService (copy), raycastParams (copy), p3 (copy), Util (copy), Head (copy), Torso (copy), u112 (ref), NeckC0 (ref)
			while p4.Parent do
				if p4:GetAttribute("Destroyed") or not p4.PrimaryPart then
					task.wait(0.2)

					continue
				end

				if not p4:GetAttribute("Constructed") then
					task.wait(0.2)

					continue
				end

				if p4:GetAttribute("Disabled") and not p4:GetAttribute("Carrying") then
					task.wait(0.2)

					continue
				end

				local t3 = {
					p4,
					workspace.Players.Survivors
				}

				for _, v179 in CollectionService:GetTagged("SurvivorConstruct") do
					table.insert(t3, v179)
				end

				raycastParams.FilterDescendantsInstances = t3

				local v180 = (p4:GetAttribute("BuildingCount") or 1) - 1
				local v181 = p3.Config.SentryDamageRadius / 2
				local v182 = math.clamp(v181 * (1 - v180 * p3.Config.SentryRangeReductionPercentage / 100), p3.Config.SentryMinimumRange, v181)
				local ClosestPlayerFromPosition = Util:GetClosestPlayerFromPosition(p4.PrimaryPart.Position, {
					PlayerSelection = "Killers",
					MaxDistance = v182
				})

				if ClosestPlayerFromPosition and ClosestPlayerFromPosition.PrimaryPart and ClosestPlayerFromPosition.Humanoid.Health > 0 then
					local PrimaryPartPosition = p4.PrimaryPart.Position
					local LookVector = CFrame.lookAt(PrimaryPartPosition, ClosestPlayerFromPosition.PrimaryPart.Position).LookVector
					local raycastResult = workspace:Raycast(PrimaryPartPosition, LookVector * v182, raycastParams)

					if not raycastResult or not raycastResult.Instance:IsDescendantOf(ClosestPlayerFromPosition) then
						task.wait(0.2)

						continue
					end

					local function worldCFrameToC0ObjectSpace(p5, p6) -- line: 231
						local Part1CFrame = p5.Part1.CFrame
						local p5C1 = p5.C1
						local p5C0 = p5.C0
						local v213 = p5C0 * p5C1:Inverse() * Part1CFrame:Inverse() * p6 * p5C1

						return v213 - v213.Position + p5C0.Position
					end

					local cFrame = CFrame.lookAt(Head.Position, ClosestPlayerFromPosition.PrimaryPart.Position, Torso.CFrame.UpVector)
					local Neck2 = Torso.Neck
					local Part1CFrame = Neck2.Part1.CFrame
					local Neck2C1 = Neck2.C1
					local Neck2C0 = Neck2.C0
					local v193 = Neck2C0 * Neck2C1:Inverse() * Part1CFrame:Inverse() * cFrame * Neck2C1

					u112.Target = (v193 - v193.Position + Neck2C0.Position) * CFrame.Angles(-1.5707963267948966, 0, 0)

					if not p4:GetAttribute("Carrying") then
						for _, descendant in pairs(p4:GetDescendants()) do
							if (descendant:IsA("ParticleEmitter") or descendant:IsA("Light")) and descendant.Name == "Shoot" then
								task.spawn(function() -- line: 253
									-- upvalues: descendant (copy)
									descendant.Enabled = true
									task.wait(0.05)
									descendant.Enabled = false
								end)
							end
						end
					end
				else
					u112.Target = NeckC0
				end

				task.wait(0.2)
			end
		end))
		v106:Connect(RunService.RenderStepped, function(n2: number) -- line: 269
			-- upvalues: Neck (copy), u112 (ref)
			if Neck.Parent then
				Neck.C0 = u112:Update(n2)
			end
		end)
		p4.AncestryChanged:Connect(function(_, parent) -- line: 275
			-- upvalues: v106 (copy)
			if not parent then
				v106:Destroy()
			end
		end)
	end

	for _, v31 in CollectionService:GetTagged("SurvivorConstruct") do
		task.spawn(setupSentry, v31)
	end

	CollectionService:GetInstanceAddedSignal("SurvivorConstruct"):Connect(setupSentry)
end
local function cl_tweenCarryFOV(p8, b2: boolean) -- line: 678
	-- upvalues: Util (copy)
	if not p8.Rig then
		return
	end

	if p8.CarryFOVTween then
		p8.CarryFOVTween:Cancel()
		p8.CarryFOVTween = nil
	end

	if not p8.CarryFOVMultiplier or not p8.CarryFOVMultiplier.Parent then
		p8.CarryFOVMultiplier = Util:CreateFOVMultiplier(p8.Rig, 1, "BuildermanCarryFOV")
	end

	local v34 = game.TweenService:Create(p8.CarryFOVMultiplier, TweenInfo.new(p8.Config.CarryFOVTweenTime or 2.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
		Value = not b2 and 1 or (p8.Config.CarryFOVMultiplier or 1.1)
	})

	p8.CarryFOVTween = v34
	v34.Completed:Connect(function() -- line: 699
		-- upvalues: p8 (copy), v34 (copy), b2 (copy)
		if p8.CarryFOVTween == v34 then
			p8.CarryFOVTween = nil

			if not b2 then
				if p8.CarryFOVMultiplier and p8.CarryFOVMultiplier.Parent then
					p8.CarryFOVMultiplier:Destroy()
				end

				p8.CarryFOVMultiplier = nil
			end
		end
	end)
	v34:Play()
end
local function cl_dropBuilding(p9) -- line: 714
	-- upvalues: t1 (copy), cl_tweenCarryFOV (copy), Util (copy)
	local Move = t1.Abilities.Move
	local v37 = p9.Behavior and (p9.Behavior.Abilities and p9.Behavior.Abilities.Move)

	if v37 and Move then
		v37.Icon = Move.Icon
		v37.Name = Move.Name
	end

	p9.CarryingBuilding = nil
	cl_tweenCarryFOV(p9, false)
	
	Util:ToggleLockForAbilityIcon("Move", "invalidplacement", false)
end
local function safeAnimation(actor,name,playing)
 local track=actor.Animations and actor.Animations[name]
 if track then pcall(function()if playing then track:Play(.1)else track:Stop(.1)end end)end
end
local function constructBuildingOnClient(actor,kind,response)
 if type(response)=="table"and response.Cancelled then
  Util:CreateWarning("BuildermanWarning",t2[response.Reason]or t2.unknown,actor.Config.Instances.WarningTemplate)
  return
 end
 local duration=type(response)=="table"and response.Duration or actor.Config[kind.."ConstructionDuration"]
 local progress=Util:CreateProgressBar("Building "..kind,duration)
 local token={}
 actor.BuilderConstructionVisual=token
 safeAnimation(actor,"ConstructStart",true)
 task.delay(.75,function()
  if actor.BuilderConstructionVisual==token then safeAnimation(actor,"ConstructStart",false);safeAnimation(actor,"ConstructLoop",true)end
 end)
 local deadline=os.clock()+duration+1
 task.spawn(function()
  while actor.Rig.Parent and os.clock()<deadline and actor.BuilderConstructionVisual==token do
   if actor.Rig:FindFirstChild("Result")then break end
   task.wait(.05)
  end
  progress:Destroy()
  if actor.BuilderConstructionVisual==token then
   actor.BuilderConstructionVisual=nil
   safeAnimation(actor,"ConstructStart",false);safeAnimation(actor,"ConstructLoop",false)
   if actor.Rig.Parent then safeAnimation(actor,"ConstructEnd",true)end
  end
 end)
end
local function cl_setBuildingPlacedText(p13, s3: string, b3: boolean) -- line: 1020
	if p13.Player ~= game.Players.LocalPlayer then
		return
	end

	local AbilityContainer = p13.Player.PlayerGui.MainUI:FindFirstChild("AbilityContainer")
	local v50 = AbilityContainer and AbilityContainer:FindFirstChild(s3)

	if not v50 then
		return
	end

	v50.Charges.Text = not b3 and "" or "PLACED"
end
local function cl_watchBuildingActivityLock(p14, p15, s4: string) -- line: 1029
	-- upvalues: Util (copy)
	p14.BuildingActivityLockTokens = p14.BuildingActivityLockTokens or {}

	local t4 = {}

	p14.BuildingActivityLockTokens[s4] = t4

	local t5 = {}

	local function cleanup() -- line: 1036
		-- upvalues: t5 (copy)
		for _, v in pairs(t5) do
			v:Disconnect()
		end

		table.clear(t5)
	end
	local function refresh() -- line: 1043
		-- upvalues: p14 (copy), s4 (copy), t4 (copy), t5 (copy), p15 (copy), Util (copy), refresh (copy)
		if p14.BuildingActivityLockTokens[s4] ~= t4 then
			for _, v in pairs(t5) do
				v:Disconnect()
			end

			table.clear(t5)

			return
		end

		local v117 = p15
		local n3

		if not v117 or v117:GetAttribute("Destroyed") then
			n3 = 0
		else
			local LastActiveTime = v117:GetAttribute("LastActiveTime")

			n3 = if typeof(LastActiveTime) == "number" then math.max(0, 10 - (workspace:GetServerTimeNow() - LastActiveTime)) else 0
		end

		local v120 = n3 > 0
		local v121 = p14
		local v122 = s4

		if v121.Player == game.Players.LocalPlayer then
			Util:ToggleLockForAbilityIcon(v122, "recentactivity", v120)
		end

		if v120 then
			task.delay(n3 + 0.05, refresh)
		end
	end

	table.insert(t5, p15:GetAttributeChangedSignal("LastActiveTime"):Connect(refresh))
	table.insert(t5, p15:GetAttributeChangedSignal("Destroyed"):Connect(refresh))
	table.insert(t5, p15.AncestryChanged:Connect(function(_, parent) -- line: 1060
		-- upvalues: p14 (copy), s4 (copy), t4 (copy), Util (copy), t5 (copy)
		if parent then
			return
		end

		if p14.BuildingActivityLockTokens[s4] == t4 then
			p14.BuildingActivityLockTokens[s4] = nil

			local v125 = p14
			local v126 = s4

			if v125.Player == game.Players.LocalPlayer then
				Util:ToggleLockForAbilityIcon(v126, "recentactivity", false)
			end

			local v127 = p14
			local v128 = s4

			if v127.Player == game.Players.LocalPlayer then
				local AbilityContainer = v127.Player.PlayerGui.MainUI:FindFirstChild("AbilityContainer")
				local v130 = AbilityContainer and AbilityContainer:FindFirstChild(v128)

				if v130 then
					v130.Charges.Text = ""
				end
			end
		end

		for _, v in pairs(t5) do
			v:Disconnect()
		end

		table.clear(t5)
	end))

	if t4 ~= p14.BuildingActivityLockTokens[s4] then
		for _, v in pairs(t5) do
			v:Disconnect()
		end

		table.clear(t5)

		return
	end

	local n4

	if not p15 or p15:GetAttribute("Destroyed") then
		n4 = 0
	else
		local LastActiveTime = p15:GetAttribute("LastActiveTime")

		n4 = if typeof(LastActiveTime) == "number" then math.max(0, 10 - (workspace:GetServerTimeNow() - LastActiveTime)) else 0
	end

	local v62 = n4 > 0

	if p14.Player == game.Players.LocalPlayer then
		Util:ToggleLockForAbilityIcon(s4, "recentactivity", v62)
	end

	if v62 then
		task.delay(n4 + 0.05, refresh)
	end
end
local function cl_updateBuildingActivityBars(p17) -- line: 1077
	local v64 = p17.Behavior and p17.Behavior.Abilities

	if not v64 then
		return
	end

	for _, v in ipairs({
		"Sentry",
		"Dispenser"
	}) do
		local v67 = v64[v]

		if v67 then
			local v68 = p17.Buildings and p17.Buildings[v]
			local n5

			if not v68 or v68:GetAttribute("Destroyed") then
				n5 = 0
			else
				local LastActiveTime = v68:GetAttribute("LastActiveTime")

				n5 = if typeof(LastActiveTime) == "number" then math.max(0, 10 - (workspace:GetServerTimeNow() - LastActiveTime)) else 0
			end

			if n5 > 0 then
				v67.CurrentRecharge = 10 - n5
				v67.ChargeDuration = 10
			else
				v67.CurrentRecharge = 0
				v67.ChargeDuration = 0
			end
		end
	end
end
local function updateBuildingCarryVisual(building)
 CarryVisuals.Update(building)
end

t1.Abilities = {
	Sentry = {
		LayoutOrder = 1,
		KeybindType = "AltAbility1",
		Icon = "rbxassetid://104441527277654",
		CurrentRecharge = 0,
		ChargeDuration = 0,
		RechargeInverted = true,
		Callback = function(p19, p20) -- line: 1129
			-- upvalues: constructBuildingOnClient (copy)
			constructBuildingOnClient(p19, "Sentry", p20)
		end
	},
	Dispenser = {
		LayoutOrder = 2,
		KeybindType = "AltAbility2",
		Icon = "rbxassetid://102952736333903",
		CurrentRecharge = 0,
		ChargeDuration = 0,
		RechargeInverted = true,
		Callback = function(p21, p22) -- line: 1260
			-- upvalues: constructBuildingOnClient (copy)
			constructBuildingOnClient(p21, "Dispenser", p22)
		end
	},
	Move = {
		LayoutOrder = 3,
		KeybindType = "AltAbility3",
		Icon = "rbxassetid://97983142047580",
		Name = "Carry",
		SpecialName = "Place",
		SpecialIcon = "rbxassetid://109402731902696",
		Callback = function(p23, p24) -- line: 1353
			-- upvalues: t2 (copy), Util (copy), t1 (copy), cl_tweenCarryFOV (copy), Network (copy), cl_dropBuilding (copy)
			if typeof(p24) == "string" then
				local v79 = t2[p24] or "Something went wrong. Try building somewhere else."

				Util:CreateWarning("BuildermanWarning", v79, p23.Config.Instances.WarningTemplate)

				return
			end

			if typeof(p24) == "Instance" then
				if p23.CarryableBuildingHighlight then
					p23.CarryableBuildingHighlight.Adornee = nil
				end

				p23.CarryingBuilding = p24

				local Move = t1.Abilities.Move
				local v81 = p23.Behavior and (p23.Behavior.Abilities and p23.Behavior.Abilities.Move)

				if v81 and Move then
					v81.Icon = Move.SpecialIcon
					v81.Name = Move.SpecialName
				end

				cl_tweenCarryFOV(p23, true)
				
				p23.AnimationType = "Pick"
				Network:FireConnection("DisableSprinting", "CarryingBuilding", true)

                safeAnimation(p23,"PickUp",true)

			else
				p23.AnimationType = nil
				Network:FireConnection("DisableSprinting", "CarryingBuilding", false)

                safeAnimation(p23,"PutDown",true)

				cl_dropBuilding(p23)
			end
		end
	}
}

function t1.Created(_, p26) -- line: 1527
	-- upvalues: trove (copy), updateBuildingCarryVisual (copy), Network (copy), Util (copy), cl_dropBuilding (copy), initClientSentryAiming (copy), cl_watchBuildingActivityLock (copy), RunService (copy), cl_updateBuildingActivityBars (copy), cl_tweenCarryFOV (copy)
	p26.CarryingBuilding = nil
	p26.CarryableBuilding = nil

	if p26.Rig then
		p26.Rig:SetAttribute("IsBuilderman", true)
	end

	if p26.Rig == game.Players.LocalPlayer.Character then
		p26.RadiusStorages = {}
		p26.CarryableBuildingHighlight = Instance.new("SelectionBox")
		p26.CarryableBuildingHighlight.Color3 = Color3.fromRGB(255, 220, 50)
		p26.CarryableBuildingHighlight.LineThickness = 0.05
		p26.CarryableBuildingHighlight.SurfaceTransparency = 0.8
		p26.CarryableBuildingHighlight.Parent = script

		local function createRadiusStorage(p27, p28) -- line: 1590
			-- upvalues: p26 (copy)
			local Model = Instance.new("Model")

			Model.Parent = workspace.Map.Ingame
			Model.Name = p27
			p26.RadiusStorages[p27] = Model

			local Highlight = Instance.new("Highlight")

			Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
			Highlight.FillTransparency = 0.875
			Highlight.OutlineTransparency = 0.6
			Highlight.FillColor = p28
			Highlight.Parent = Model
		end

		local color3 = Color3.fromRGB(70, 155, 255)
		local Model = Instance.new("Model")

		Model.Parent = workspace.Map.Ingame
		Model.Name = "PlacementRange"
		p26.RadiusStorages.PlacementRange = Model

		local Highlight = Instance.new("Highlight")

		Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
		Highlight.FillTransparency = 0.875
		Highlight.OutlineTransparency = 0.6
		Highlight.FillColor = color3
		Highlight.Parent = Model

		local color3_2 = Color3.fromRGB(255, 80, 80)
		local Model2 = Instance.new("Model")

		Model2.Parent = workspace.Map.Ingame
		Model2.Name = "BuildermanSentryEffectRange"
		p26.RadiusStorages.BuildermanSentryEffectRange = Model2

		local Highlight2 = Instance.new("Highlight")

		Highlight2.DepthMode = Enum.HighlightDepthMode.Occluded
		Highlight2.FillTransparency = 0.875
		Highlight2.OutlineTransparency = 0.6
		Highlight2.FillColor = color3_2
		Highlight2.Parent = Model2

		local color3_3 = Color3.fromRGB(80, 255, 80)
		local Model3 = Instance.new("Model")

		Model3.Parent = workspace.Map.Ingame
		Model3.Name = "BuildermanDispenserEffectRange"
		p26.RadiusStorages.BuildermanDispenserEffectRange = Model3

		local Highlight3 = Instance.new("Highlight")

		Highlight3.DepthMode = Enum.HighlightDepthMode.Occluded
		Highlight3.FillTransparency = 0.875
		Highlight3.OutlineTransparency = 0.6
		Highlight3.FillColor = color3_3
		Highlight3.Parent = Model3

		local function createRadius(p29, p30) -- line: 1608
			-- upvalues: p26 (copy)
			local v139 = p26.RadiusStorages[p29]

			if not v139 then
				return
			end

			if not p30 then
				return
			end

			local Part = Instance.new("Part")

			Part.CanCollide = false
            Part.CanQuery=false;Part.CanTouch=false
			Part.Anchored = true
			Part.Transparency = 1
			Part.Position = Vector3.new(0, -100, 0)
			Part.Orientation = Vector3.new(0, 0, 90)
			Part.Size = Vector3.new(0.25, p30, p30)
			Part.Material = Enum.Material.Glass
			Part.Shape = Enum.PartType.Cylinder
			Part.Parent = v139

			return Part
		end

		p26.BuildingVisualTroves = p26.BuildingVisualTroves or {}
		p26.Connection = workspace.Map.Ingame.ChildAdded:Connect(function(child) -- line: 1626
			-- upvalues: p26 (copy), trove (copy), updateBuildingCarryVisual (copy), createRadius (copy)
			if child.Name:find("Builderman") then
				local Humanoid = child:WaitForChild("Humanoid", 10)

				if not Humanoid then
					return
				end

				local Root = child:WaitForChild("Root", 10)

				if not Root then
					return
				end

				child:SetAttribute("ClientCarryWatcherSet", true)

				if p26.BuildingVisualTroves[child] then
					p26.BuildingVisualTroves[child]:Destroy()
				end

				local v144 = trove.new()

				p26.BuildingVisualTroves[child] = v144
				task.spawn(function() -- line: 1641
					-- upvalues: child (copy), updateBuildingCarryVisual (copy)
					updateBuildingCarryVisual(child)
                    if child:WaitForChild("PlayerAura", 10) then
						updateBuildingCarryVisual(child)
					end
				end)

				local t6 = {
					BuildermanSentryPlacementRange = p26.Config.SentryPlacementRadius,
					BuildermanSentryEffectRange = p26.Config.SentryDamageRadius,
					BuildermanDispenserPlacementRange = p26.Config.DispenserPlacementRadius,
					BuildermanDispenserEffectRange = p26.Config.DispenserHealingRadius
				}
				local v146 = `{ child.Name }PlacementRange`
				local v147 = `{ child.Name }EffectRange`
				local v148 = createRadius("PlacementRange", t6[v146])
				local v149 = createRadius(v147, t6[v147])

				if v148 then
					v144:Add(v148)
				end

				if v149 then
					v144:Add(v149)
				end

				local function syncRadiusPositions() -- line: 1662
					-- upvalues: v148 (copy), Root (copy), v149 (copy)
					if v148 then
						v148.Position = Root.Position - Vector3.new(0, Root.Size.Y / 2 + 0.075, 0)
					end

					if v149 then
						v149.Position = Root.Position - Vector3.new(0, Root.Size.Y / 2, 0)
					end
				end

				syncRadiusPositions()
				v144:Connect(Root:GetPropertyChangedSignal("Position"), syncRadiusPositions)
                v144:Connect(child:GetAttributeChangedSignal("Destroyed"),function()
                    if child:GetAttribute("Destroyed")then
                        v144:Destroy()
                        if p26.BuildingVisualTroves then p26.BuildingVisualTroves[child]=nil end
                    end
                end)

				v144:Connect(child:GetAttributeChangedSignal("EffectRadiusSize"), function() -- line: 1668
					-- upvalues: child (copy), v149 (copy)
					if child:GetAttribute("Destroyed") or child:GetAttribute("Carrying") then
						return
					end

					local EffectRadiusSize = child:GetAttribute("EffectRadiusSize")

					if v149 then
						game.TweenService:Create(v149, TweenInfo.new(1), {
							Size = Vector3.new(0.25, EffectRadiusSize * 2, EffectRadiusSize * 2)
						}):Play()
					end
				end)
				v144:Connect(child:GetAttributeChangedSignal("Carrying"), function() -- line: 1677
					-- upvalues: child (copy), updateBuildingCarryVisual (copy), v148 (copy), v149 (copy), Root (copy), t6 (copy), v147 (copy), v146 (copy)
					if child:GetAttribute("Destroyed") then
						return
					end

					updateBuildingCarryVisual(child)

					if child:GetAttribute("Carrying") then
						if v148 then
							game.TweenService:Create(v148, TweenInfo.new(0.5), {
								Size = Vector3.new(0, 0, 0)
							}):Play()
						end

						if v149 then
							game.TweenService:Create(v149, TweenInfo.new(0.5), {
								Size = Vector3.new(0, 0, 0)
							}):Play()

							return
						end
					else
						if v148 then
							v148.Position = Root.Position - Vector3.new(0, Root.Size.Y / 2 + 0.075, 0)
						end

						if v149 then
							v149.Position = Root.Position - Vector3.new(0, Root.Size.Y / 2, 0)
						end

						local v200 = child:GetAttribute("EffectRadiusSize") or t6[v147]
						local v201 = t6[v146]
						local tweenInfo = TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

						if v149 then
							game.TweenService:Create(v149, tweenInfo, {
								Size = Vector3.new(0.25, v200 * 2, v200 * 2)
							}):Play()
						end

						if v148 then
							game.TweenService:Create(v148, tweenInfo, {
								Size = Vector3.new(0.25, v201, v201)
							}):Play()
						end
					end
				end)
				v144:Connect(Humanoid.HealthChanged, function(p31) -- line: 1694
					-- upvalues: v144 (copy), p26 (copy), child (copy)
					if p31 <= 0 then
						v144:Destroy()

						if p26.BuildingVisualTroves then
							p26.BuildingVisualTroves[child] = nil
						end
					end
				end)
				v144:Connect(child.AncestryChanged, function(_, p33) -- line: 1703
					-- upvalues: v144 (copy), p26 (copy), child (copy)
					if not p33 then
						v144:Destroy()

						if p26.BuildingVisualTroves then
							p26.BuildingVisualTroves[child] = nil
						end
					end
				end)
			end
		end)
		Network:SetConnection(`{ p26.Player.Name }UpdateClosestBuilding`, "REMOTE_EVENT", function(p34) -- line: 1714
			-- upvalues: p26 (copy), Util (copy)
			if p26.CarryableBuildingHighlight then
				p26.CarryableBuildingHighlight.Adornee = p34
			end

			Util:ToggleLockForAbilityIcon("Move", "nobuildinglmao", not p34)
		end)
		Network:SetConnection(`{ p26.Player.Name }ForceDropBuilding`, "REMOTE_EVENT", function() -- line: 1721
			-- upvalues: p26 (copy), Network (copy), cl_dropBuilding (copy), Util (copy)
			p26.AnimationType = nil
			Network:FireConnection("DisableSprinting", "CarryingBuilding", false)
			cl_dropBuilding(p26)
			Util:ToggleLockForAbilityIcon("Move", "nobuildinglmao", false)
			task.defer(function() -- line: 1726
				-- upvalues: Util (copy)
				Util:ToggleLockForAbilityIcon("Move", "nobuildinglmao", true)
			end)
		end)
	end

	initClientSentryAiming(p26)
	p26.Buildings = {}
	p26.CarryVisualTroves = p26.CarryVisualTroves or {}
    local function refreshCarryOutlines()
        for _,building in workspace.Map.Ingame:GetChildren()do
            if building.Name=="BuildermanSentry"or building.Name=="BuildermanDispenser"then updateBuildingCarryVisual(building)end
        end
    end
    task.defer(refreshCarryOutlines)
    p26.BuilderViewerConnection=game.Players.LocalPlayer.CharacterAdded:Connect(function()task.defer(refreshCarryOutlines)end)

	p26.CarryVisualConnection = workspace.Map.Ingame.ChildAdded:Connect(function(child) -- line: 1737
		-- upvalues: p26 (copy), trove (copy), updateBuildingCarryVisual (copy)
		if child.Name:find("Builderman") then
			if child:GetAttribute("ClientCarryWatcherSet") then
				return
			end

			child:SetAttribute("ClientCarryWatcherSet", true)

			if p26.CarryVisualTroves[child] then
				p26.CarryVisualTroves[child]:Destroy()
			end

			local v153 = trove.new()

			p26.CarryVisualTroves[child] = v153
			task.spawn(function() -- line: 1748
				-- upvalues: child (copy), updateBuildingCarryVisual (copy)
				updateBuildingCarryVisual(child)
                    if child:WaitForChild("PlayerAura", 10) then
					updateBuildingCarryVisual(child)
				end
			end)
			v153:Connect(child:GetAttributeChangedSignal("Carrying"), function() -- line: 1755
				-- upvalues: child (copy), updateBuildingCarryVisual (copy)
				if child:GetAttribute("Destroyed") then
					return
				end

				updateBuildingCarryVisual(child)
			end)
			v153:Connect(child.AncestryChanged, function(_, p36) -- line: 1760
				-- upvalues: v153 (copy), p26 (copy), child (copy)
				if not p36 then
					v153:Destroy()

					if p26.CarryVisualTroves then
						p26.CarryVisualTroves[child] = nil
					end
				end
			end)
		end
	end)
	Network:SetConnection(`{ p26.Player.Name }ReplicateBuildingAsync`, "REMOTE_EVENT", function(p37, s5: string) -- line: 1774
		-- upvalues: p26 (copy), cl_watchBuildingActivityLock (copy)
		if p26.Player ~= game.Players.LocalPlayer then
			return
		end

		p26.Buildings[s5] = p37
		cl_watchBuildingActivityLock(p26, p37, s5)

		local v156 = p26
		local v157 = p37.Parent ~= nil and not p37:GetAttribute("Destroyed")

		if v156.Player ~= game.Players.LocalPlayer then
			return
		end

		local AbilityContainer = v156.Player.PlayerGui.MainUI:FindFirstChild("AbilityContainer")
		local v159 = AbilityContainer and AbilityContainer:FindFirstChild(s5)

		if not v159 then
			return
		end

		v159.Charges.Text = not v157 and "" or "PLACED"
	end)
    Network:SetConnection(p26.Player.Name.."ConstructionRejected","REMOTE_EVENT",function(reason)
        if p26.Player==game.Players.LocalPlayer then Util:CreateWarning("BuildermanWarning",t2[reason]or t2.unknown,p26.Config.Instances.WarningTemplate)end
    end)
	Network:SetConnection(`{ p26.Player.Name }UpdateCanPlace`, "REMOTE_EVENT", function(b4: boolean) -- line: 1783
		-- upvalues: Util (copy)
		Util:ToggleLockForAbilityIcon("Move", "invalidplacement", not b4)
	end)
	Network:SetConnection(`{ p26.Player.Name }UpdateBuildingAbilityLock`, "REMOTE_EVENT", function(s6: string, s7: string, b5: boolean) -- line: 1790
		-- upvalues: Util (copy)
		Util:ToggleLockForAbilityIcon(s6, s7, b5)
	end)
	Network:SetConnection(`{ p26.Player.Name }ReplicateDestroyedBuildingAsync`, "REMOTE_EVENT", function(s8: string) -- line: 1798
		-- upvalues: p26 (copy), Util (copy)
		if p26.Player ~= game.Players.LocalPlayer then
			return
		end

		p26.Buildings[s8] = nil

		if p26.BuildingActivityLockTokens then
			p26.BuildingActivityLockTokens[s8] = nil
		end

		Util:ToggleLockForAbilityIcon(s8, "recentactivity", false)

		local v165 = p26.Behavior and (p26.Behavior.Abilities and p26.Behavior.Abilities[s8])

		if v165 then
			v165.CurrentRecharge = 0
			v165.ChargeDuration = 0
		end

		local v166 = p26

		if v166.Player ~= game.Players.LocalPlayer then
			return
		end

		local AbilityContainer = v166.Player.PlayerGui.MainUI:FindFirstChild("AbilityContainer")
		local v168 = AbilityContainer and AbilityContainer:FindFirstChild(s8)

		if not v168 then
			return
		end

		v168.Charges.Text = ""
	end)
	p26.BuildingActivityBarConnection = RunService.RenderStepped:Connect(function() -- line: 1817
		-- upvalues: p26 (copy), cl_updateBuildingActivityBars (copy)
		if not p26.Rig or not p26.Rig.Parent then
			if p26.BuildingActivityBarConnection then
				p26.BuildingActivityBarConnection:Disconnect()
				p26.BuildingActivityBarConnection = nil
			end

			return
		end

		cl_updateBuildingActivityBars(p26)
	end)
	p26.Rig.AncestryChanged:Connect(function(_, parent) -- line: 1829
		-- upvalues: p26 (copy), cl_tweenCarryFOV (copy), Network (copy)
		if parent then
			return
		end

		if p26.CarryVisualConnection then
			p26.CarryVisualConnection:Disconnect()
			p26.CarryVisualConnection = nil
		end

		for _, v in pairs(p26.CarryVisualTroves or {}) do
			v:Destroy()
		end

		p26.CarryVisualTroves = nil

		if p26.Player == game.Players.LocalPlayer then
			cl_tweenCarryFOV(p26, false)

			if p26.Connection then
				p26.Connection:Disconnect()
			end

			if p26.BuildingActivityBarConnection then
				p26.BuildingActivityBarConnection:Disconnect()
				p26.BuildingActivityBarConnection = nil
			end

			for _, v in pairs(p26.BuildingVisualTroves or {}) do
				v:Destroy()
			end

			p26.BuildingVisualTroves = nil

			for _, v in pairs(p26.RadiusStorages or {}) do
				v:Destroy()
			end

			if p26.CarryableBuildingHighlight then
				p26.CarryableBuildingHighlight:Destroy()
				p26.CarryableBuildingHighlight = nil
			end

			Network:RemoveConnection(`{ p26.Player.Name }UpdateClosestBuilding`, "REMOTE_EVENT")
			Network:RemoveConnection(`{ p26.Player.Name }ForceDropBuilding`, "REMOTE_EVENT")
			Network:RemoveConnection(`{ p26.Player.Name }UpdateCanPlace`, "REMOTE_EVENT")
			Network:RemoveConnection(`{ p26.Player.Name }UpdateBuildingAbilityLock`, "REMOTE_EVENT")
		end

		p26.Buildings = {}
		Network:RemoveConnection(`{ p26.Player.Name }ReplicateBuildingAsync`, "REMOTE_EVENT")
	end)
end
function t1.Destroyed(_, p40) -- line: 1873
	-- upvalues: cl_tweenCarryFOV (copy), Network (copy)
	p40.BuilderConstructionVisual=nil
 if p40.BuilderViewerConnection then p40.BuilderViewerConnection:Disconnect();p40.BuilderViewerConnection=nil end
	if p40.CarryVisualConnection then
		p40.CarryVisualConnection:Disconnect()
		p40.CarryVisualConnection = nil
	end

	for _, v in pairs(p40.CarryVisualTroves or {}) do
		v:Destroy()
	end

	p40.CarryVisualTroves = nil

	if p40.Player == game.Players.LocalPlayer then
		cl_tweenCarryFOV(p40, false)

		if p40.Connection then
			p40.Connection:Disconnect()
			p40.Connection = nil
		end

		if p40.BuildingActivityBarConnection then
			p40.BuildingActivityBarConnection:Disconnect()
			p40.BuildingActivityBarConnection = nil
		end

		for _, v in pairs(p40.BuildingVisualTroves or {}) do
			v:Destroy()
		end

		p40.BuildingVisualTroves = nil

		for _, v in pairs(p40.RadiusStorages or {}) do
			v:Destroy()
		end

		if p40.CarryableBuildingHighlight then
			p40.CarryableBuildingHighlight:Destroy()
			p40.CarryableBuildingHighlight = nil
		end

		Network:RemoveConnection(p40.Player.Name.."ConstructionRejected","REMOTE_EVENT")
		Network:FireConnection("DisableSprinting","CarryingBuilding",false)
		Network:RemoveConnection(`{ p40.Player.Name }UpdateClosestBuilding`, "REMOTE_EVENT")
		Network:RemoveConnection(`{ p40.Player.Name }ForceDropBuilding`, "REMOTE_EVENT")
		Network:RemoveConnection(`{ p40.Player.Name }UpdateCanPlace`, "REMOTE_EVENT")
		Network:RemoveConnection(`{ p40.Player.Name }UpdateBuildingAbilityLock`, "REMOTE_EVENT")
		Network:RemoveConnection(`{ p40.Player.Name }ReplicateBuildingAsync`, "REMOTE_EVENT")
		Network:RemoveConnection(`{ p40.Player.Name }ReplicateDestroyedBuildingAsync`, "REMOTE_EVENT")
	end
end

function t1.Use(actor,kind,response)
 local ability=t1.Abilities[kind]
 if ability then return ability.Callback(actor,response)end
end
return t1
