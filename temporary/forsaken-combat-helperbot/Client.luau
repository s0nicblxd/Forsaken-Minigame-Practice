local ReplicatedStorage=game:GetService("ReplicatedStorage")
local TweenService=game:GetService("TweenService")
local SoundService=game:GetService("SoundService")
local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local Sounds=require(ReplicatedStorage.Modules.Sounds)
local Util=require(ReplicatedStorage.Modules.Util)
local Maid=require(ReplicatedStorage.Modules.Misc.Maid)
local Network=require(ReplicatedStorage.Modules.Network)
local _ = math.random
local _ = table.insert
local _ = table.sort
local _ = task.wait
local spawn = task.spawn
local _ = task.delay
local _ = coroutine.close

TweenInfo.new(1)
Random.new()
TweenInfo.new(0.2)

local LocalPlayer = Players.LocalPlayer
local _ = workspace.CurrentCamera

local function flRandom(p1, p2) -- line: 89
	return p1 + Random.new():NextNumber() * (p2 - p1)
end
local function __displayWarn(_: string) -- line: 96
end
local function __pcallMethod(s2: string, p3, ...) -- line: 119
	local ok, result = pcall(function(...) -- line: 121
		-- upvalues: p3 (copy), s2 (copy)
		if p3.Behavior[s2] then
			return p3.Behavior[s2](p3.Behavior, p3, ...)
		end
	end, ...)

	if not ok then
		warn(`[Unknown]: Failed to call .{ s2 }() due to: { result }, { debug.traceback() }`)

		return
	end

	return result
end
local function __playSound(t1: {[any]: any}, s3: string, t2: {[any]: any}?) -- line: 139
	-- upvalues: Util (copy), Sounds (copy)
	local v36 = Util:CopyTable(t2 or {
		Volume = 0.25,
		PlaybackSpeed = 0.975 + Random.new():NextNumber() * 0.04999999999999993
	})

	v36.Parent = t2 and t2.Parent or t1.Rig.PrimaryPart

	if v36.Volume == nil then
		v36.Volume = 0.25
	end

	return Sounds:Play(t1.Config.Sounds[s3], v36)
end

local t3 = {}

local function playChargeUISound(p4, p5) -- line: 429
	-- upvalues: Sounds (copy), SoundService (copy)
	local v39 = p4.Config.Sounds[p5]

	if not v39 then
		return
	end

	return Sounds:Play(v39, {
		Looped = false,
		Parent = SoundService,
		Volume = p4.Config.Sounds.ChargeUISoundVolume or 0.25
	})
end
local function updateChargeUISound(p6) -- line: 440
	-- upvalues: Sounds (copy), SoundService (copy), TweenService (copy)
	local v41 = next(p6.InspireChargingBars or {}) ~= nil

	if v41 == (p6.InspireChargeSoundActive == true) then
		return
	end

	p6.InspireChargeSoundActive = v41

	local InspireChargeSoundTween = p6.InspireChargeSoundTween

	if InspireChargeSoundTween then
		p6.InspireChargeSoundTween = nil
		InspireChargeSoundTween:Cancel()
		InspireChargeSoundTween:Destroy()
	end

	local InspireChargeSound = p6.InspireChargeSound

	if v41 then
		if InspireChargeSound then
			InspireChargeSound:Destroy()
		end

		local InspireBarCharging = p6.Config.Sounds.InspireBarCharging

		p6.InspireChargeSound = if InspireBarCharging then Sounds:Play(InspireBarCharging, {
			Looped = false,
			Parent = SoundService,
			Volume = p6.Config.Sounds.ChargeUISoundVolume or 0.25
		}) else nil

		return
	end

	if InspireChargeSound and InspireChargeSound.Parent then
		local v45 = p6.Config.Sounds.ChargeUISoundFadeTime or 0.35
		local tween = TweenService:Create(InspireChargeSound, TweenInfo.new(v45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Volume = 0
		})

		p6.InspireChargeSoundTween = tween
		tween.Completed:Once(function(p7) -- line: 461
			-- upvalues: p6 (copy), InspireChargeSound (copy), tween (copy)
			if p7 ~= Enum.PlaybackState.Completed then
				return
			end

			if p6.InspireChargeSound ~= InspireChargeSound or p6.InspireChargeSoundActive then
				return
			end

			p6.InspireChargeSound = nil
			p6.InspireChargeSoundTween = nil
			InspireChargeSound:Destroy()
			tween:Destroy()
		end)
		tween:Play()

		return
	end

	p6.InspireChargeSound = nil
end
local function setChargeUICharging(p8, p9, p10) -- line: 475
	-- upvalues: updateChargeUISound (copy)
	p8.InspireChargingBars = p8.InspireChargingBars or {}
	p8.InspireChargingBars[p9] = not not p10 or nil
	updateChargeUISound(p8)
end

function t3.lcl_OnRadarUsed(_, p12) -- line: 481
	-- upvalues: __playSound (copy)
	local Detection = p12.Config.Detection

	__playSound(p12, "Radar", {
		Volume = 0.25,
		RollOffMaxDistance = Detection.Radius,
		RollOffMinDistance = Detection.Radius / 3
	})

	local DetectionRadius = p12.Config.Detection.Radius
	local clone = p12.Config.Instances.RadarEffectPart:Clone()
 clone.CanCollide=false;clone.CanTouch=false;clone.CanQuery=false

	clone.Parent = workspace.Map.Ingame
	clone.Size = Vector3.new(0, 0, 0)
	clone.Position = p12.Rig.PrimaryPart.Position
	clone.Massless = true
	clone.RootPriority = -66
	clone.Parent = workspace.Map.Ingame
	clone.Anchored = true
	clone.CFrame = CFrame.new(p12.Rig.PrimaryPart.Position)
	game.TweenService:Create(clone, TweenInfo.new(0.7, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
		Transparency = 1,
		Size = Vector3.new(1, 1, 1) * DetectionRadius
	}):Play()
	game.Debris:AddItem(clone, 1)

	local v55 = p12.Animations and p12.Animations.Detect

	if v55 then
		pcall(function() v55:Play(0.05) end)
	end
end
function t3.cl_ClearPulseHighlight(_, p14) -- line: 506
	local PulseHighlightEffect = p14.PulseHighlightEffect

	if not PulseHighlightEffect then
		return
	end

	p14.PulseHighlightEffect = nil

	if PulseHighlightEffect.Died then
		PulseHighlightEffect.Died:Disconnect()
	end

	if PulseHighlightEffect.AncestryChanged then
		PulseHighlightEffect.AncestryChanged:Disconnect()
	end

	if PulseHighlightEffect.Tween then
		PulseHighlightEffect.Tween:Cancel()
		PulseHighlightEffect.Tween:Destroy()
	end

	PulseHighlightEffect.Highlight:Destroy()
end
function t3.cl_OnPulseWindup(p15, p16) -- line: 519
	-- upvalues: LocalPlayer (copy), Util (copy)
	p15:cl_ClearPulseHighlight(p16)

	if p16.Player == LocalPlayer then
		return
	end

	local Character = LocalPlayer.Character
	local Rig = p16.Rig

	if not Util:IsAlive(Character) or Character.Parent ~= workspace.Players.Survivors then
		return
	end

	if not Util:IsAlive(Rig) then
		return
	end

	local SonicPulse = p16.Config.SonicPulse
	local Highlight = Instance.new("Highlight")

	Highlight.Name = "HelperbotPulseHighlight"
	Highlight.Adornee = Rig
	Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	Highlight.FillColor = SonicPulse.HighlightColor
	Highlight.OutlineColor = SonicPulse.HighlightColor
	Highlight.FillTransparency = SonicPulse.HighlightWindupFillTransparency
	Highlight.OutlineTransparency = SonicPulse.HighlightWindupOutlineTransparency
	Highlight.Parent = Rig

	local t4 = {
		Highlight = Highlight
	}

	p16.PulseHighlightEffect = t4
	t4.Died = Rig:FindFirstChildOfClass("Humanoid").Died:Connect(function() -- line: 540
		-- upvalues: p15 (copy), p16 (copy)
		p15:cl_ClearPulseHighlight(p16)
	end)
	t4.AncestryChanged = Rig.AncestryChanged:Connect(function() -- line: 543
		-- upvalues: Rig (copy), p15 (copy), p16 (copy)
		if not Rig:IsDescendantOf(workspace) then
			p15:cl_ClearPulseHighlight(p16)
		end
	end)
end
function t3.cl_FlashPulseHighlight(t5: {[any]: any}, p17, color3: Color3?) -- line: 550
	-- upvalues: TweenService (copy)
	if not p17.PulseHighlightEffect then
		t5:cl_OnPulseWindup(p17)
	end

	local PulseHighlightEffect = p17.PulseHighlightEffect

	if not PulseHighlightEffect then
		return
	end

	if PulseHighlightEffect.Tween then
		PulseHighlightEffect.Tween:Cancel()
		PulseHighlightEffect.Tween:Destroy()
	end

	local Highlight = PulseHighlightEffect.Highlight

	if color3 then
		Highlight.FillColor = color3
		Highlight.OutlineColor = color3
	end

	Highlight.FillTransparency = 0
	Highlight.OutlineTransparency = 0

	local tween = TweenService:Create(Highlight, TweenInfo.new(p17.Config.SonicPulse.HighlightReleaseFadeTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		FillTransparency = 1,
		OutlineTransparency = 1
	})

	PulseHighlightEffect.Tween = tween
	tween.Completed:Once(function(p18) -- line: 572
		-- upvalues: p17 (copy), PulseHighlightEffect (copy), t5 (copy)
		if p18 == Enum.PlaybackState.Completed and p17.PulseHighlightEffect == PulseHighlightEffect then
			t5:cl_ClearPulseHighlight(p17)
		end
	end)
	tween:Play()
end
function t3.cl_OnPulseInterrupted(p19, p20) -- line: 580
	-- upvalues: LocalPlayer (copy)
	if p20.Player == LocalPlayer then
		if p20.Animations and p20.Animations.Pulse then pcall(function() p20.Animations.Pulse:Stop(0.05) end) end

		return
	end

	p19:cl_FlashPulseHighlight(p20, Color3.fromRGB(255, 0, 0))
end
function t3.cl_OnPulseEmitted(t6: {[any]: any}, p21, n1: number, n2: number) -- line: 588
	-- upvalues: spawn (copy), Util (copy)
	t6:cl_FlashPulseHighlight(p21)

	local clone = p21.Config.Instances.RadarEffectPart:Clone()

	clone.Size = Vector3.new(0, 0, 0)
	clone.Position = p21.Rig.PrimaryPart.Position
 clone.Anchored=true;clone.CanCollide=false;clone.CanTouch=false;clone.CanQuery=false
	clone.Transparency = 0.6
	clone.Color = Color3.new(0.5, 0.5, 1)
	clone.Material = Enum.Material.Neon
	clone.Parent = workspace.Map.Ingame

	game.TweenService:Create(clone, TweenInfo.new(n1 / n2, Enum.EasingStyle.Linear), {
		Transparency = 1,
		Size = Vector3.new(1, 1, 1) * n1 * 2
	}):Play()
	game.Debris:AddItem(clone, 2)
end
function t3.cl_OnPulseHit(_: {[any]: any}, _, _: boolean) -- line: 612
end
function t3.cl_CreateZoneVisual(_: {[any]: any}, p23, s4: string, p24) -- line: 616
	-- upvalues: TweenService (copy)
	local clone = p23.Config.Instances.RadarEffectPart:Clone()
 clone.CanCollide=false;clone.CanTouch=false;clone.CanQuery=false

	clone.CFrame = p23.Rig.PrimaryPart.CFrame
	clone.Transparency = 0.75
	clone.Anchored = false
	clone.Color = Color3.new(0.5, 0.5, 1)
	clone.Massless = true
	clone.RootPriority = -66
	clone.Name = "HelperbotInspireZoneVis" .. s4

	local Weld = Instance.new("Weld")

	Weld.Part0 = p23.Rig.PrimaryPart
	Weld.Part1 = clone
	Weld.Parent = clone
	clone.Parent = workspace.Map
	TweenService:Create(clone, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Transparency = 0.75,
		Size = Vector3.new(1, 1, 1) * p24 * 2
	}):Play()

	local t9 = {}

	function t9.Destroy(_) -- line: 637
		-- upvalues: t9 (copy), Weld (copy), clone (copy), TweenService (copy), p23 (copy), s4 (copy)
		if t9.Destroyed then
			return
		end

		t9.Destroyed = true

		if Weld and Weld.Parent then
			Weld:Destroy()
		end

		if clone and clone.Parent then
			clone.Anchored = true
			TweenService:Create(clone, TweenInfo.new(0.65, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
				Size = Vector3.new(0, 0, 0),
				Transparency = 0.75
			}):Play()
			game.Debris:AddItem(clone, .7)
		end

		p23.State.ActiveZones[s4] = nil
	end

	p23.State.ActiveZones[s4] = t9
	p23.Maid:Add(t9)
end
function t3.cl_DestroyZoneVisual(_, p27, p28) -- line: 655
	-- upvalues: __pcallMethod (copy)
	__pcallMethod("lcl_InspireChargeUIEnded", p27, p28)

	local v93 = p27.State.ActiveZones[p28]

	if not v93 or not v93.Destroy then
		return
	end

	v93:Destroy()
end
function t3.cl_OnZoneEntered(_, _) -- line: 662
end
function t3.cl_OnZoneLeft(_, _) -- line: 666
end
function t3.lcl_OnChargeLevelChanged(_: {[any]: any}, p33, n3: number, s5: string) -- line: 670
	-- upvalues: TweenService (copy)
	p33.State.ChargeLevel = n3

	local v102 = p33.Behavior and p33.Behavior.Abilities
	local v103 = v102 and v102[s5]

	if not v103 then
		("%* does not exist in Helperbot's moveset"):format(s5)

		return
	end

	local v104 = v103 and v103.UIElement

	if not v104 or not v104.Parent or not v104:FindFirstChild("Charges") then
		return
	end

	v104.Charges.TextColor3 = n3 == 0 and Color3.new(1, 0, 0) or Color3.new(1, 0.882353, 0.203922)
	TweenService:Create(v104.Charges, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		TextColor3 = Color3.new(1, 1, 1)
	}):Play()
	v104.Charges.Text = `Lv. { n3 }`
	v104.Charges.Visible = true
end
function t3.cl_InspireMeterUpdate(_, p35, p36, p37, ...) -- line: 690
	-- upvalues: LocalPlayer (copy), __pcallMethod (copy)
	if p37 ~= LocalPlayer.Character then
		return
	end

	if p36 ~= "CharacterEnteredInspire" and p36 ~= "CharacterLeftInspire" and p36 ~= "CharacterGaveCharge" and p36 ~= "CharacterChargeRemoved" then
		return
	end

	__pcallMethod("lcl_" .. p36, p35, p37, ...)
end
function t3.lcl_CharacterEnteredInspire(_, p39, p40, p41, p42, p43) -- line: 697
	-- upvalues: Util (copy), updateChargeUISound (copy), Sounds (copy), SoundService (copy)
	if not p40 or not Util:IsAlive(p40) then
		return
	end

	p39.ActiveChargeUI = p39.ActiveChargeUI or {}

	local u115 = p39.ActiveChargeUI[p43]

	if not u115 then
		u115 = {}
		p39.ActiveChargeUI[p43] = u115
	end

	local Class_InspirationBillboard = p39.Config.Instances.Class_InspirationBillboard

	if not Class_InspirationBillboard then
		return
	end

	local lib = require(Class_InspirationBillboard)
	local u118 = u115[p40]

	if not u118 then
		u118 = lib.new(p39.Config.Instances.ChargeMeter, p40, p39.Config.ClassConfigs.InspirationBillboard, function() -- line: 715
			-- upvalues: u115 (ref), p40 (copy), u118 (ref), p39 (copy), updateChargeUISound (copy)
			if u115[p40] == u118 then
				u115[p40] = nil
			end

			local v175 = p39
			local v176 = u118

			v175.InspireChargingBars = v175.InspireChargingBars or {}
			v175.InspireChargingBars[v176] = nil
			updateChargeUISound(v175)
		end)
		u115[p40] = u118

		local InspireBarAppear = p39.Config.Sounds.InspireBarAppear

		if InspireBarAppear then
			Sounds:Play(InspireBarAppear, {
				Looped = false,
				Parent = SoundService,
				Volume = p39.Config.Sounds.ChargeUISoundVolume or 0.25
			})
		end
	end

	u118:TweenFill(p42, 1, p41)

	local v120 = u118

	p39.InspireChargingBars = p39.InspireChargingBars or {}
	p39.InspireChargingBars[v120] = true
	updateChargeUISound(p39)
end
function t3.lcl_CharacterLeftInspire(_, p45, p46, p47, p48, p49) -- line: 729
	-- upvalues: updateChargeUISound (copy)
	local v127 = p45.ActiveChargeUI and p45.ActiveChargeUI[p49]
	local v128 = v127 and v127[p46]

	if not v128 then
		return
	end

	p45.InspireChargingBars = p45.InspireChargingBars or {}
	p45.InspireChargingBars[v128] = nil
	updateChargeUISound(p45)
	v128:TweenFill(p48, 0, p47)
end
function t3.lcl_CharacterGaveCharge(_, p51, p52, p53) -- line: 740
	-- upvalues: updateChargeUISound (copy), Sounds (copy), SoundService (copy)
	local v133 = p51.ActiveChargeUI and p51.ActiveChargeUI[p53]
	local v134 = v133 and v133[p52]

	if not v134 then
		return
	end

	local v135 = p51.InspireChargingBars and p51.InspireChargingBars[v134]

	p51.InspireChargingBars = p51.InspireChargingBars or {}
	p51.InspireChargingBars[v134] = nil
	updateChargeUISound(p51)

	if v135 then
		local InspireBarDone = p51.Config.Sounds.InspireBarDone

		if InspireBarDone then
			Sounds:Play(InspireBarDone, {
				Looped = false,
				Parent = SoundService,
				Volume = p51.Config.Sounds.ChargeUISoundVolume or 0.25
			})
		end
	end

	v134:DisplaySuccess()
end
function t3.lcl_CharacterChargeRemoved(_, p55, p56, p57) -- line: 755
	-- upvalues: updateChargeUISound (copy)
	local v141 = p55.ActiveChargeUI and p55.ActiveChargeUI[p57]
	local v142 = v141 and v141[p56]

	if v142 then
		p55.InspireChargingBars = p55.InspireChargingBars or {}
		p55.InspireChargingBars[v142] = nil
		updateChargeUISound(p55)
		v142:Destroy()
	end
end
function t3.lcl_InspireChargeUIEnded(_, p59, p60) -- line: 764
	-- upvalues: updateChargeUISound (copy)
	local v146 = p59.ActiveChargeUI and p59.ActiveChargeUI[p60]

	if not v146 then
		return
	end

	p59.ActiveChargeUI[p60] = nil

	for _, v in pairs(v146) do
		p59.InspireChargingBars = p59.InspireChargingBars or {}
		p59.InspireChargingBars[v] = nil
		updateChargeUISound(p59)
		v:Destroy()
	end
end
function t3.lcl_StopChargeUISound(_, p62) -- line: 774
	-- upvalues: updateChargeUISound (copy)
	if p62.InspireChargingBars then
		table.clear(p62.InspireChargingBars)
	end

	updateChargeUISound(p62)
end

function t3.Created(_, p66) -- line: 1061
	-- upvalues: Maid (copy), LocalPlayer (copy), Network (copy), __pcallMethod (copy)
	local _ = p66.Config

	p66.Maid = Maid.new()
	p66.Meta = {}
	p66.Instances = {}
	p66.State = {}
	p66.State.ActiveZones = {}
	p66.State.ChargeLevels = {
		Pulse = 0
	}
	p66.NetworkConnections = {}
	p66.ConnectionDictionary = {}

	local v158 = p66.Player == LocalPlayer

	p66.NetworkConnections.PCallAllClients = {
		`{ p66.Player.Name }PCallAllClients`,
		"REMOTE_EVENT"
	}
	Network:SetConnection(`{ p66.Player.Name }PCallAllClients`, "REMOTE_EVENT", function(p67, ...) -- line: 1187
		-- upvalues: __pcallMethod (copy), p66 (copy)
		if not p66.HelperClientDestroyed then __pcallMethod("cl_" .. p67, p66, ...) end
	end)

	if v158 then
		p66.NetworkConnections.PCallLocal = {
			`{ p66.Player.Name }PCallLocal`,
			"REMOTE_EVENT"
		}
		Network:SetConnection(`{ p66.Player.Name }PCallLocal`, "REMOTE_EVENT", function(p68, ...) -- line: 1193
			-- upvalues: __pcallMethod (copy), p66 (copy)
			if not p66.HelperClientDestroyed then __pcallMethod("lcl_" .. p68, p66, ...) end
		end)
		task.spawn(function() -- line: 1198
			-- upvalues: p66 (copy), __pcallMethod (copy)
			local v179 = p66.Behavior.Abilities and p66.Behavior.Abilities.Pulse
			local elapsed = os.clock()

			while (not v179 or not v179.UIElement or not v179.UIElement.Parent) and os.clock() - elapsed < 10 do
				task.wait(0.1)
			end

			__pcallMethod("lcl_OnChargeLevelChanged", p66, p66.Rig:GetAttribute("PulseCharges") or 1, "Pulse")
		end)
	end
end
function t3.Destroyed(_, p70) -- line: 1210
	-- upvalues: t3 (copy), Network (copy)
	t3:cl_ClearPulseHighlight(p70)

	if p70.ActiveChargeUI then
		for k in pairs(p70.ActiveChargeUI) do
			t3:lcl_InspireChargeUIEnded(p70, k)
		end
	end

	t3:lcl_StopChargeUISound(p70)

	for v162, v163 in p70.ConnectionDictionary do
		("CLIENT | Disconnected connection: %*"):format(v163)
		v163:Disconnect()
		p70.ConnectionDictionary[v162] = nil
	end

	local ok, result = pcall(p70.Maid.Destroy, p70.Maid)

	if not ok then
		("CLIENT | Maid cleanup errored: %*"):format(result)
	end

	for v166, v167 in p70.NetworkConnections do
		("CLIENT | Disconnected network connection: %*/%*"):format(v167[2], v167[1])
		Network:RemoveConnection(v167[1], v167[2])
		p70.NetworkConnections[v166] = nil
	end

	for _, v169 in p70.Instances do
		if typeof(v169) == "table" then
			for _, v171 in v169 do
				if v171 and v171.Parent then
					("CLIENT | Removed instance reference: %*"):format(v171)
					v171:Destroy()
				end
			end
		else
			v169:Destroy()
		end
	end
end


local originalCreated=t3.Created
local originalDestroyed=t3.Destroyed
function t3.Created(self,a)
 a.HelperClientDestroyed=false
 originalCreated(self,a)
 a.Maid:Add(a.Rig:GetAttributeChangedSignal("PulseCharges"):Connect(function()
  if a.Player==Players.LocalPlayer then t3:lcl_OnChargeLevelChanged(a,a.Rig:GetAttribute("PulseCharges") or 0,"Pulse") end
 end))
end
function t3.Destroyed(self,a)
 if a.HelperClientDestroyed then return end
 a.HelperClientDestroyed=true
 for _,zone in pairs(a.State and a.State.ActiveZones or {}) do zone:Destroy() end
 originalDestroyed(self,a)
end
function t3.cl_PortCleanup(self,a) t3.Destroyed(self,a) end
local function animate(a,name)
 local track=a.Animations and a.Animations[name]
 if track then pcall(function() track:Play(.05) end) end
end
function t3.Pulse(a) animate(a,"Pulse") end
function t3.Inspiration(a) animate(a,"Inspire") end
local function survivorClient()
 local rig=Players.LocalPlayer.Character
 return rig and rig.Parent and rig.Parent.Name=="Survivors"
end
local function highlight(a,object,color,duration)
 if not object or not object.Parent then return end
 local h=Instance.new("Highlight");h.Name="HelperbotRadarHighlight";h.Adornee=object
 h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop;h.FillColor=color;h.OutlineColor=color
 h.FillTransparency=.6;h.OutlineTransparency=.1;h.Parent=object
 a.Maid:Add(h);game:GetService("Debris"):AddItem(h,duration or 3)
end
local function position(object)
 if object:IsA("Model") then return object:GetPivot().Position end
 if object:IsA("BasePart") then return object.Position end
 if object:IsA("Tool") then local handle=object:FindFirstChild("Handle");return handle and handle.Position end
end
function t3.cl_RadarScan(self,a)
 if not survivorClient() or not a.Rig.PrimaryPart then return end
 self:lcl_OnRadarUsed(a)
 local ingame=workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Ingame")
 if not ingame then return end
 local cfg=a.Config.Detection
 for _,object in ipairs(ingame:GetDescendants()) do
  local generator=object:IsA("Model") and object.Name=="Generator"
  local item=object:IsA("Tool") or object.Parent.Name=="Items" and (object:IsA("Model") or object:IsA("BasePart"))
  if generator or item then
   local progress=object:FindFirstChild("Progress")
   if not (generator and progress and progress:IsA("NumberValue") and progress.Value>=100) then
    local point=position(object)
    if point and (point-a.Rig.PrimaryPart.Position).Magnitude<=cfg.Radius then highlight(a,object,generator and cfg.GeneratorHighlightColor or cfg.ItemHighlightColor,3) end
   end
  end
 end
end
function t3.lcl_ShowSurvivorAura(_,a,rig)
 if a.Player~=Players.LocalPlayer or not survivorClient() then return end
 local hum=rig and rig:FindFirstChildOfClass("Humanoid")
 if hum and hum.Health>0 then highlight(a,rig,Color3.new(1,0,0):Lerp(Color3.new(0,1,0),math.clamp(hum.Health/hum.MaxHealth,0,1)),3) end
end
function t3.cl_OnPulseHit(_,a,rig)
 if not rig or not rig.PrimaryPart then return end
 local attachment=a.Config.Instances.VFXPulseHit:Clone();attachment.Parent=rig.PrimaryPart
 for _,effect in ipairs(attachment:GetChildren()) do if effect:IsA("ParticleEmitter") then effect:Emit(effect:GetAttribute("EmitCount") or 8) end end
 game:GetService("Debris"):AddItem(attachment,3)
end
local originalPulse=t3.cl_OnPulseEmitted
function t3.cl_OnPulseEmitted(self,a,radius,speed)
 originalPulse(self,a,radius,speed)
 local attachment=a.Config.Instances.VFXPulse:Clone();attachment.Parent=a.Rig.PrimaryPart
 for _,effect in ipairs(attachment:GetChildren()) do if effect:IsA("ParticleEmitter") then effect:Emit(effect:GetAttribute("EmitCount") or 8) end end
 game:GetService("Debris"):AddItem(attachment,3)
end
local originalZone=t3.cl_CreateZoneVisual
function t3.cl_CreateZoneVisual(self,a,id,radius)
 originalZone(self,a,id,radius)
 local zone=a.State.ActiveZones[id]
 if not zone then return end
 local attachment=a.Config.Instances.VFXInspireActive:Clone();attachment.Parent=a.Rig.PrimaryPart
 for _,effect in ipairs(attachment:GetChildren()) do if effect:IsA("ParticleEmitter") then effect.Enabled=true end end
 local destroy=zone.Destroy
 function zone.Destroy(object)
  if attachment.Parent then
   for _,effect in ipairs(attachment:GetChildren()) do if effect:IsA("ParticleEmitter") then effect.Enabled=false end end
   game:GetService("Debris"):AddItem(attachment,3)
  end
  destroy(object)
 end
end
return t3
