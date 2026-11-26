local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Sounds = require(ReplicatedStorage.Modules.Sounds)
local Util = require(ReplicatedStorage.Modules.Util)

require(ReplicatedStorage.Modules.Network)

local Actors = require(ReplicatedStorage.Modules.Actors)

require(ReplicatedStorage.Modules.Statuses)

local Maid = require(ReplicatedStorage.Modules.Misc.Maid)
local t1 = {}
local t2 = {}

t2.__index = t2

local function __displayWarn(s1: string) -- line: 34
	warn(`[Veeronica/SprayVisual]: { s1 }`)
end
local function __changeProperty(p1, p2, p3) -- line: 38
	if p3 ~= p1[p2] then
		p1[p2] = p3
	end
end

function t2.getObject(p4) -- line: 44
	-- upvalues: t1 (copy)
	return t1[p4]
end
function t2.new(t3: {[any]: any}, p5) -- line: 48
	-- upvalues: t2 (copy), Maid (copy), Util (copy), Sounds (copy), RunService (copy)
	local self = setmetatable({}, t2)
	local v20 = t3.Player == game.Players.LocalPlayer

	self.Root = p5
	self.Owner = t3.Player
	self.IsLocal = v20
	self.Maid = Maid.new()
	self.Model = self:Create(t3)
	self.Range = t3.Config.VandalismRange
	self.Width = t3.Config.VandalismWidth
	self.LastProgression = p5:GetAttribute("Progression") or 0
	self.LastProgressionChange = 0
	self.Sounds = {}

	for _, v in ipairs({
		"Progression",
		"Wiping",
		"Completed",
		"Destroyed"
	}) do
		local v23 = t3.Config.Sounds[`Spray{ v }`]

		if v23 then
			self.Sounds[v] = if typeof(v23) ~= "table" then v23 else Util:CopyTable(v23)
		else
			local v24 = `Failed to cache sound { v }!`

			warn(`[Veeronica/SprayVisual]: { v24 }`)
		end
	end

	if v20 then
		self.IndicationBeam = self:CreateIndicationBeam(t3)
		self.ProgressBar = self:CreateProgressBar(t3)
		self.RangeIndicator = self:CreateRangeIndicator(t3)
		self:ToggleBeam(true)
		self:ToggleInRange(true)
	end

	local v25 = Sounds:Play(self.Sounds.Progression, {
		Looped = true,
		Parent = self.Model
	})
	local v26 = Sounds:Play(self.Sounds.Wiping, {
		Looped = true,
		Parent = self.Model
	})

	self.Maid:Add(RunService.PreRender:Connect(function() -- line: 89
		-- upvalues: self (copy), v26 (copy), v25 (copy)
		if os.clock() - self.LastProgressionChange < 0.05 then
			return
		end

		local v68 = v26

		if v68.Playing ~= false then
			v68.Playing = false
		end

		local v69 = v25

		if v69.Playing ~= false then
			v69.Playing = false
		end
	end))
	self.Maid:Add(p5:GetAttributeChangedSignal("Progression"):Connect(function() -- line: 97
		-- upvalues: p5 (copy), self (copy), v25 (copy), v26 (copy)
		local v70 = p5:GetAttribute("Progression") or 1

		if v70 - self.LastProgression > 0 then
			local v71 = v25

			if v71.Playing ~= true then
				v71.Playing = true
			end

			local v72 = v26

			if v72.Playing ~= false then
				v72.Playing = false
			end
		elseif v70 - self.LastProgression < 0 then
			local v73 = v26

			if v73.Playing ~= true then
				v73.Playing = true
			end

			local v74 = v25

			if v74.Playing ~= false then
				v74.Playing = false
			end
		end

		self:ProgressionChanged(v70)
		self.LastProgression = v70
		self.LastProgressionChange = os.clock()
	end))
	self.Maid:Add(p5:GetAttributeChangedSignal("Completed"):Connect(function() -- line: 114
		-- upvalues: p5 (copy), Sounds (copy), self (copy)
		if p5:GetAttribute("Completed") then
			Sounds:Play(self.Sounds.Completed, {
				Parent = self.Model
			})
			self:OnCompleted()

			return
		end

		self:OnUncompleted()
	end))
	self.Maid:Add(v25)
	self.Maid:Add(v26)
	t3.SprayVisuals[p5] = self

	return self
end
function t2.Destroy(t4: {[any]: any}) -- line: 131
	-- upvalues: Sounds (copy)
	if t4.Dead then
		return
	end

	t4.Dead = true

	local Actor = t4:GetActor()

	if Actor and Actor.SprayVisuals then
		Actor.SprayVisuals[t4.Root] = nil
	else
		warn("Failed to remove cached SprayVisual!")
	end

	Sounds:Play(t4.Sounds.Destroyed, {
		Parent = t4.Model
	})
	task.spawn(t4.ToggleBeam, t4, false)
	task.spawn(t4.OnDestroyed, t4)
	t4.Maid:Destroy()
	table.clear(t4)
end
function t2.Create(t5: {[any]: any}, p6) -- line: 156
	local v31 = if not p6 or (not p6.Player or p6.Player.Name ~= "ffPrankster") then if math.random(1, 25000) ~= 1 then p6.Config.VandalismSprayImages else p6.Config.VandalismRareSprayImages else { "rbxassetid://83450503791840" }
	local clone = p6.Config.Instances.VandalismPreset:Clone()

	assert(clone and clone:IsA("BasePart"), "SprayVisual must be a BasePart!")
	clone.ImageBeam.Texture = v31[math.random(#v31)]
	clone.ImageBeam.Width0 = 3
	clone.ImageBeam.Width1 = 3
	clone.ImageBeam.Brightness = 0
	clone.Name = `{ p6.Player.Name }Spray`
	clone.Parent = workspace.Map.Ingame
	clone.CFrame = t5.Root:GetPivot() * CFrame.Angles(0, 3.141592653589793, 0)
	clone.Name = "GraffitiCL"

	return clone
end
function t2.CreateIndicationBeam(t6: {[any]: any}, p7) -- line: 177
	if not p7.Rig or not p7.Rig:FindFirstChild("Torso") then
		warn("[Veeronica/SprayVisual]: Failed to find torso for indication beam!")

		return
	end

	local clone = p7.Config.Instances.VandalismSprayBeam:Clone()

	clone.Enabled = false
	clone.Attachment0 = t6.Model.AttachmentMain
	clone.Attachment1 = p7.Rig.Torso.BodyBackAttachment
	clone.Parent = t6.Model

	return clone
end
function t2.CreateProgressBar(t7: {[any]: any}, _) -- line: 192
	local clone = script.BillboardGui:Clone()

	clone.Parent = t7.Model
	clone.StudsOffset = Vector3.new(0, 0, 0.05000000074505806)

	return clone
end
function t2.CreateRangeIndicator(t8: {[any]: any}, _) -- line: 200
	-- upvalues: ReplicatedStorage (copy)
	local clone = ReplicatedStorage.Assets.Instances.Nothingburger:Clone()

	clone.Size = vector.create(t8.Width, t8.Width, t8.Range)
	clone.Parent = t8.Model
	clone.CFrame = t8.Root:GetPivot() * CFrame.new(0, 0, t8.Range / 2 + 1)
	clone.Transparency = 1
	clone.Name = "SprayRangeIndicator"

	return clone
end
function t2.OnDestroyed(t9: {[any]: any}) -- line: 211
	-- upvalues: TweenService (copy)
	local Model = t9.Model

	if Model then
		local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		local ImageBeam = Model.ImageBeam
		local AttachmentBottom = Model.AttachmentBottom

		TweenService:Create(ImageBeam, tweenInfo, {
			Width0 = 0,
			Width1 = 0,
			Brightness = -0.5
		}):Play()
		TweenService:Create(AttachmentBottom, tweenInfo, {
			Position = Vector3.new(0, -2.5, 0),
			Orientation = Vector3.new(50, 0, 90)
		})

		if t9.RangeIndicator then
			TweenService:Create(t9.RangeIndicator, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
				Transparency = 1
			}):Play()
		end

		t9:ToggleBeam(false)
		game.Debris:AddItem(Model, 2)

		return
	end

	warn("what is happpening")
end
function t2.ToggleInRange(t10: {[any]: any}, b1: boolean) -- line: 242
	t10.RangeIndicator.Color = if not b1 then Color3.new(1, 0, 0) else Color3.new(0, 1, 0)
end
function t2.ToggleBeam(t11: {[any]: any}, b2: boolean) -- line: 246
	if not t11.IndicationBeam then
		return
	end

	t11.IndicationBeam.Enabled = b2
	t11:ToggleBar(b2 and not t11.Completed)
end
function t2.ToggleBar(t12: {[any]: any}, b3: boolean) -- line: 255
	-- upvalues: TweenService (copy)
	if not t12.ProgressBar then
		return
	end

	local tweenInfo = TweenInfo.new(0.35)

	TweenService:Create(t12.ProgressBar.Background, tweenInfo, {
		BackgroundTransparency = not b3 and 1 or 0.35
	}):Play()
	TweenService:Create(t12.ProgressBar.Outline, tweenInfo, {
		BackgroundTransparency = not b3 and 1 or 0.35
	}):Play()
	TweenService:Create(t12.ProgressBar.Background.Bar, tweenInfo, {
		BackgroundTransparency = not b3 and 1 or 0.35
	}):Play()
end
function t2.UpdateBeam(t13: {[any]: any}, b4: boolean) -- line: 267
	if not t13.IndicationBeam then
		return
	end

	t13:GetActor()

	local t14 = {
		IN = Color3.fromRGB(13, 255, 0),
		INBAD = Color3.fromRGB(255, 204, 0),
		OUT = Color3.fromRGB(255, 46, 46)
	}
	local v57 = b4 and (if not t13.Completed then t14.INBAD else t14.IN) or t14.OUT

	t13.IndicationBeam.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, v57),
		ColorSequenceKeypoint.new(1, v57)
	})
end
function t2.ProgressionChanged(t15: {[any]: any}, n1: number) -- line: 285
	-- upvalues: TweenService (copy)
	local Value = TweenService:GetValue(math.clamp(n1 / 100, 0, 1), Enum.EasingStyle.Quad, Enum.EasingDirection.In)
	local Model = t15.Model
	local ImageBeam = Model.ImageBeam
	local _ = Model.AttachmentBottom

	TweenService:Create(ImageBeam, TweenInfo.new(0.08), {
		Brightness = Value / 2 + 0.5,
		Width0 = Value * 2 + 3,
		Width1 = Value * 2 + 3
	}):Play()

	local v64 = if not t15.IsLocal then 0.9 - Value * 0.2 else 0.5 - Value * 0.5

	ImageBeam.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, v64),
		NumberSequenceKeypoint.new(1, v64)
	})

	if t15 and t15.ProgressBar and t15.ProgressBar:FindFirstChild("Background") then
		TweenService:Create(t15.ProgressBar.Background.Bar, TweenInfo.new(0.05), {
			Size = UDim2.fromScale(Value, 1)
		}):Play()
	end
end
function t2.OnCompleted(t16: {[any]: any}) -- line: 315
	-- upvalues: TweenService (copy)
	t16.Completed = true

	if t16.RangeIndicator then
		TweenService:Create(t16.RangeIndicator, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Transparency = 0.8
		}):Play()
	end

	t16:ToggleBar(false)
	t16.Model.ImageBeam.LightEmission = 2
	TweenService:Create(t16.Model.ImageBeam, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		LightEmission = 0
	}):Play()
end
function t2.OnUncompleted(t17: {[any]: any}) -- line: 335
	-- upvalues: TweenService (copy)
	t17.Complete = false
	t17:ToggleBar(true)

	if t17.RangeIndicator then
		TweenService:Create(t17.RangeIndicator, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			Transparency = 1
		}):Play()
	end
end
function t2.GetActor(t18: {[any]: any}) -- line: 348
	-- upvalues: Actors (copy)
	return Actors.CurrentActors[t18.Owner]
end

return t2
