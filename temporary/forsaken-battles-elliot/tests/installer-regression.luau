
local writes=0
local failAt=nil
local function copy(t)local out={};for k,v in pairs(t)do out[k]=v end;return out end
local Methods={}
local mt={}
function mt.__index(self,k)
 if Methods[k]then return Methods[k] end
 if k=="Parent"then return self._parent end
 local value=self._props[k]
 if value~=nil then return value end
 return self:FindFirstChild(k)
end
function mt.__newindex(self,k,v)
 if k=="Parent"then
  if self._parent then local old=self._parent._children;local i=table.find(old,self);if i then table.remove(old,i)end end
  rawset(self,"_parent",v);if v then table.insert(v._children,self)end
 else
  if k=="Source"then writes+=1;if failAt==writes then error("Injected Source write failure")end end
  self._props[k]=v
 end
end
local Instance={}
function Instance.new(class,parent)
 local self=setmetatable({_props={ClassName=class,Name=class},_children={},_attrs={}},mt)
 if parent then self.Parent=parent end
 return self
end
function Methods:IsA(class)
 return self.ClassName==class or class=="LuaSourceContainer"and(self.ClassName=="Script"or self.ClassName=="ModuleScript"or self.ClassName=="LocalScript")or class=="BasePart"and(self.ClassName=="Part"or self.ClassName=="MeshPart")
end
function Methods:FindFirstChild(name,recursive)
 for _,child in ipairs(self._children)do if child.Name==name then return child end end
 if recursive then for _,child in ipairs(self._children)do local found=child:FindFirstChild(name,true);if found then return found end end end
end
function Methods:FindFirstChildOfClass(class)for _,child in ipairs(self._children)do if child:IsA(class)then return child end end end
function Methods:GetChildren()return table.clone(self._children)end
function Methods:GetDescendants()local out={};for _,child in ipairs(self._children)do table.insert(out,child);for _,desc in ipairs(child:GetDescendants())do table.insert(out,desc)end end;return out end
function Methods:SetAttribute(k,v)self._attrs[k]=v end
function Methods:GetAttribute(k)return self._attrs[k]end
function Methods:Clone()
 local object=Instance.new(self.ClassName);object._props=copy(self._props);object._attrs=copy(self._attrs)
 for _,child in ipairs(self._children)do child:Clone().Parent=object end
 return object
end
function Methods:Destroy()self.Parent=nil;self.Destroyed=true;for _,child in ipairs(self:GetChildren())do child:Destroy()end end
function Methods:GetFullName()return (self.Parent and self.Parent:GetFullName().."."or "")..self.Name end
local game,workspace
local function child(parent,name,class)local o=Instance.new(class or "Folder");o.Name=name;o.Parent=parent;return o end
local function fresh()
 writes=0;failAt=nil
 game=Instance.new("DataModel");workspace=child(game,"Workspace","Workspace")
 local rep=child(game,"ReplicatedStorage");local assets=child(rep,"Assets");local survivors=child(assets,"Survivors")
 local modules=child(rep,"Modules");local statuses=child(modules,"StatusEffects");local misc=child(modules,"Misc")
 for _,name in {"Actors","Util","Statuses","Network","Sounds"}do child(modules,name,"ModuleScript")end
 for _,name in {"Maid","Trove"}do child(misc,name,"ModuleScript")end
 child(game,"ServerStorage")
 function game:GetService(name)
  if name=="RunService"then return {IsStudio=function()return true end,IsRunning=function()return false end}end
  if name=="ChangeHistoryService"then return {SetWaypoint=function()end}end
  return self:FindFirstChild(name)
 end
 return survivors,statuses
end

local nativeTypeof=typeof
local function typeof(value)if type(value)=="table"and value._props then return "Instance"end;return nativeTypeof(value)end
local function signal()
 local all={}
 return {Connect=function(_,callback)
  local c={Active=true};function c:Disconnect()self.Active=false end
  table.insert(all,{c,callback});return c
 end,Fire=function(_,...)
  for _,pair in table.clone(all)do if pair[1].Active then pair[2](...)end end
 end,Count=function()local n=0;for _,pair in all do if pair[1].Active then n+=1 end end;return n end}
end

local sourceData={
{path=[========[
ReplicatedStorage/Systems/Character/Game/Sprinting]========],source=[========[
local t1 = {
	timeUntilStaminaRecovers = 0,
	DefaultConfig = {
		IsSprinting = false,
		isSpeedLocked = false,
		BindsEnabled = true,
		StaminaLossDisabled = false,
		MinStamina = 0,
		MaxStamina = 100,
		SprintSpeed = 26,
		StaminaLoss = 10,
		StaminaGain = 20
	}
}
local DataHandler = require(game.ReplicatedStorage.Modules.DataHandler)
local TweenService = game:GetService("TweenService")
local Network = require(game.ReplicatedStorage.Modules.Network)

function t1.ChangeStat(_, p2, p3) -- line: 24
	-- upvalues: t1 (copy)
	if t1[p2] then
		t1[p2] = p3
	end
end
function t1.CanRegenStamina(p4) -- line: 30
	return p4.timeUntilStaminaRecovers <= 0
end
function t1.Toggle(_, p6) -- line: 34
	-- upvalues: t1 (copy), Network (copy), TweenService (copy)
	local Character = game.Players.LocalPlayer.Character
	local v12 = Character and Character:FindFirstChild("Humanoid")

	if not v12 then
		return
	end

	if t1.__currentSpeedTween then
		t1.__currentSpeedTween:Cancel()
		t1.__currentSpeedTween = nil
	end

	if t1.__currentFOVTween then
		t1.__currentFOVTween:Cancel()
		t1.__currentFOVTween = nil
	end

	if p6 then
		if not Character:GetAttribute("FootstepsMuted") then
			Network:FireServerConnection("FootSP", "UREMOTE_EVENT", 1)
		end

		t1.__currentFOVTween = TweenService:Create(t1.__FOVMultiplier, TweenInfo.new(0.75), {
			Value = 1.125
		})
		t1.__currentFOVTween:Play()

		if not t1.isSpeedLocked then
			t1.__currentSpeedTween = TweenService:Create(t1.__speedMultiplier, TweenInfo.new(0.75), {
				Value = t1.SprintSpeed / (v12:GetAttribute("BaseSpeed") or 16)
			})
			t1.__currentSpeedTween:Play()

			return
		end
	else
		t1.__currentFOVTween = TweenService:Create(t1.__FOVMultiplier, TweenInfo.new(0.75), {
			Value = 1
		})
		t1.__currentFOVTween:Play()

		if not t1.isSpeedLocked then
			t1.__currentSpeedTween = TweenService:Create(t1.__speedMultiplier, TweenInfo.new(0.75), {
				Value = 1
			})
			t1.__currentSpeedTween:Play()
		end
	end
end
function t1.Resync(_) -- line: 75
	-- upvalues: t1 (copy)
	t1:Toggle(t1.IsSprinting)
end
function t1.SetStaminaFrozen(_, source, active)
	t1.__staminaFreezeSources = t1.__staminaFreezeSources or {}
	t1.__staminaFreezeSources[source] = active and true or nil
end
function t1.SyncHeldKey(_)
	if t1.IsSprinting or not t1.CanSprint or not t1.BindsEnabled or not t1.__sprintHandler then return end
	local input = game:GetService("UserInputService")
	for _, key in ipairs(t1.__sprintKeys or {}) do
		local held = key.EnumType == Enum.KeyCode and input:IsKeyDown(key)
			or key.EnumType == Enum.UserInputType and input:IsMouseButtonPressed(key)
		if held then t1.__sprintHandler("Sprinting", Enum.UserInputState.Begin); return end
	end
end

function t1.Init(_) -- line: 80
	-- upvalues: t1 (copy), DataHandler (copy), Network (copy)
	local LocalPlayer = game.Players.LocalPlayer
	local Character = LocalPlayer.Character

	Character:WaitForChild("Humanoid")

	for k, v in pairs(t1.DefaultConfig) do
		t1[k] = v
	end

	t1.StaminaCap = nil
	t1.StaminaLossDisabled = false
	t1.__staminaFreezeSources = {}
	t1.DefaultsSet = true
	t1.__sprintedEvent = Instance.new("BindableEvent")
	t1.__staminaChangedEvent = Instance.new("BindableEvent")
	t1.__speedMultiplier = Instance.new("NumberValue")
	t1.__speedMultiplier.Value = 1
	t1.__speedMultiplier.Name = "Sprinting"
	t1.__speedMultiplier.Parent = Character:WaitForChild("SpeedMultipliers", 10)
	t1.__FOVMultiplier = Instance.new("NumberValue")
	t1.__FOVMultiplier.Value = 1
	t1.__FOVMultiplier.Name = "Sprinting"
	t1.__FOVMultiplier.Parent = Character:WaitForChild("FOVMultipliers", 10)
	t1.CanSprint = true
	t1.SprintToggled = t1.__sprintedEvent.Event
	t1.StaminaChanged = t1.__staminaChangedEvent.Event
	t1.Stamina = t1.MaxStamina
	t1.SprintToggled:Connect(function(p9) -- line: 115
		-- upvalues: t1 (copy)
		t1:Toggle(p9)
	end)
	t1.timeUntilStaminaRecovers = 0

	local function sprint(_, p11) -- line: 121
		-- upvalues: t1 (copy)
		if not t1.CanSprint or not t1.BindsEnabled then
			return
		end

		if require(game.ReplicatedStorage.Modules.Device):GetPlayerDevice() == "Mobile" then
			if p11 ~= Enum.UserInputState.Begin then
				return
			end

			p11 = t1.IsSprinting and Enum.UserInputState.End or Enum.UserInputState.Begin
		end

		if p11 == Enum.UserInputState.Begin and t1.Stamina > t1.MinStamina and not t1.IsSprinting then
			t1.IsSprinting = true
			t1.__sprintedEvent:Fire(true)

			return
		end

		if t1.IsSprinting then
			t1.IsSprinting = false
			t1.__sprintedEvent:Fire(false)

			if t1.timeUntilStaminaRecovers > 0.1 then
				t1.timeUntilStaminaRecovers = math.clamp(t1.timeUntilStaminaRecovers + 0.1, 0, 3)

				return
			end

			t1.timeUntilStaminaRecovers = 0.1
		end
	end

	task.spawn(function() -- line: 152
		-- upvalues: Character (copy), t1 (copy)
		while true do
			local dt = game["Run Service"].Heartbeat:Wait()

			if not Character.Parent then
				break
			end

			if not Character.PrimaryPart then
				return
			end

			if next(t1.__staminaFreezeSources or {}) then continue end

			if t1.IsSprinting and t1.Stamina > t1.MinStamina and Character.PrimaryPart.Velocity.Magnitude > 0.4 and t1.CanSprint and not t1.StaminaLossDisabled and Character.Parent.Name ~= "Spectating" then
				t1.timeUntilStaminaRecovers = math.clamp(t1.timeUntilStaminaRecovers + dt * 0.05, 0.2, 3)
				t1.Stamina = math.clamp(t1.Stamina - t1.StaminaLoss * dt, t1.MinStamina, t1.StaminaCap or t1.MaxStamina)
				t1.__staminaChangedEvent:Fire(t1.Stamina)

				if t1.Stamina <= t1.MinStamina then
					t1.IsSprinting = false
					t1.__sprintedEvent:Fire(false)
					t1.timeUntilStaminaRecovers = 2
					Character:SetAttribute("StaminaPenaltyActive", true)
				end

				continue
			end

			if not t1.StaminaLossDisabled and t1.IsSprinting and (not (Character.PrimaryPart.Velocity.Magnitude <= 0.4) or not (t1.Stamina < t1.MaxStamina) and (not t1.StaminaCap or not (t1.Stamina > t1.StaminaCap))) then
				continue
			end

			t1.timeUntilStaminaRecovers = math.clamp(t1.timeUntilStaminaRecovers - dt, 0, 3)

			if Character:GetAttribute("StaminaPenaltyActive") then
				if not (t1.timeUntilStaminaRecovers <= 0) then
					continue
				end

				Character:SetAttribute("StaminaPenaltyActive", nil)
			end

			if t1.timeUntilStaminaRecovers <= 0 and not Character:GetAttribute("AbilityStaminaOverride") then
				t1.Stamina = math.clamp(t1.Stamina + t1.StaminaGain * dt, t1.MinStamina, t1.StaminaCap or t1.MaxStamina)
				t1.__staminaChangedEvent:Fire(t1.Stamina)
			end
		end
	end)

	local t2 = {}
	local v21 = DataHandler:ReadPath("Settings/Keybinds")

	for _, v in pairs({
		v21.Sprinting.Value,
		v21["Sprinting~Console"].Value
	}) do
		for _, v2 in pairs(Enum.KeyCode:GetEnumItems()) do
			if v == v2.Name then
				table.insert(t2, v2)

				break
			end
		end

		for _, v3 in pairs(Enum.UserInputType:GetEnumItems()) do
			if v == v3.Name then
				table.insert(t2, v3)

				break
			end
		end
	end

	t1.__sprintHandler = sprint
	t1.__sprintKeys = t2
	game.ContextActionService:BindActionAtPriority("Sprinting", sprint, false, 10000, unpack(t2))

	if not t1.MobileButton then
		local clone = script.SprintingButton:Clone()

		clone.Parent = LocalPlayer.PlayerGui:WaitForChild("MainUI")

		local Device = require(game.ReplicatedStorage.Modules.Device)

		local function toggleButton() -- line: 236
			-- upvalues: Device (copy), clone (copy)
			clone.Visible = Device:GetPlayerDevice() == "Mobile"
		end

		clone.Visible = Device:GetPlayerDevice() == "Mobile"
		Device.Changed:Connect(toggleButton)
		t1.MobileButton = clone
	end

	if tostring(LocalPlayer.Character.Parent) == "Spectating" and t1.MobileButton then
		t1.MobileButton.AnchorPoint = Vector2.new(0, 0)
		t1.MobileButton.Position = UDim2.new(1, -250, 1, -135)
		t1.MobileButton.Size = UDim2.fromOffset(83, 83)
	end

	if t1.CurrentButtonConnection1 then
		t1.CurrentButtonConnection1:Disconnect()
	end

	t1.CurrentButtonConnection1 = t1.MobileButton.MouseButton1Down:Connect(function() -- line: 256
		-- upvalues: t1 (copy), sprint (copy)
		t1.MobileButton.ImageColor3 = Color3.new(0.75, 0.75, 0.75)
		sprint("Sprinting", Enum.UserInputState.Begin)
	end)

	if t1.CurrentButtonConnection2 then
		t1.CurrentButtonConnection2:Disconnect()
	end

	t1.CurrentButtonConnection2 = t1.MobileButton.MouseButton1Up:Connect(function() -- line: 262
		-- upvalues: t1 (copy), sprint (copy)
		t1.MobileButton.ImageColor3 = Color3.new(1, 1, 1)
		sprint("Sprinting", Enum.UserInputState.End)
	end)

	local t3 = {}

	local function toggleSprintingDisabled(p12, p13) -- line: 270
		-- upvalues: t3 (copy), t1 (copy)
		t3[p12] = p13

		local v40 = true

		for _, v in pairs(t3) do
			if v == true then
				v40 = false

				break
			end
		end

		t1.CanSprint = v40

		if not v40 and t1.IsSprinting then
			t1.IsSprinting = false
			t1.__sprintedEvent:Fire(false)
		end
	end

	Network:SetConnection("DisableSprinting", "BINDABLE_EVENT", toggleSprintingDisabled)
	Network:SetConnection("DisableSprintingSV", "REMOTE_EVENT", toggleSprintingDisabled)
	Network:SetConnection("GrantStamina", "REMOTE_EVENT", function(p14) -- line: 295
		-- upvalues: t1 (copy)
		t1.Stamina = math.min(t1.Stamina + p14, t1.MaxStamina)
	end)
	t1.Character = Character
end
function t1.Destroy(_) -- line: 304
	-- upvalues: Network (copy), t1 (copy)
	t1.__staminaFreezeSources = {}
	t1.__sprintHandler = nil
	t1.__sprintKeys = nil
	Network:RemoveConnection("DisableSprinting", "BINDABLE_EVENT")
	Network:RemoveConnection("DisableSprintingSV", "REMOTE_EVENT")
	Network:RemoveConnection("GrantStamina", "REMOTE_EVENT")
	t1.__sprintedEvent:Destroy()
	t1.__staminaChangedEvent:Destroy()
	t1.__speedMultiplier:Destroy()
	t1.__FOVMultiplier:Destroy()
end

return t1

]========]},
{path=[========[
ReplicatedStorage/Systems/Character/Game/PlayerInfoDisplay]========],source=[========[
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local DataHandler = require(game.ReplicatedStorage.Modules.DataHandler)
local trove = require(game.ReplicatedStorage.Modules.Misc.Trove)
local Spring = require(game.ReplicatedStorage.Modules.Misc.Spring)

require(game.ReplicatedStorage.Modules.Misc.Thread)
require(game.ReplicatedStorage.Modules.Statuses)

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

	local Stamina = clone.Bars.Stamina
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
	-- upvalues: t1 (copy)
	if t1.UI then
		t1.UI:Destroy()
	end
end

return t1

]========]}}
local configSource=[========[
-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local v0 = {
    DisplayName = "Elliot", 
    Quote = "\"Pizza pizza!\"", 
    Credits = "", 
    Class = "Support", 
	RenderImage = "rbxassetid://107512662597581", 
    Price = 0, 
    Requests = {
        ElliotPizza = {
            Order = 1, 
            AbilityName = "ThrowPizza", 
            RequestTitle = "Request Pizza", 
            NotificationTitle = "PLAYERNAME wants a pizza!"
        }
    }, 
    Health = 80, 
    Speed = 12, 
    InjuredSurvivorAuraDuration = 12, 
    InjuredSurvivorDamageMinimum = 1, 
    ThrowPizzaCooldown = 45, 
    PizzaThrowForce = 60, 
    PizzaHealingAmount = 5, 
    PizzaHealingProgressively = 20, 
    PizzaHealingProgressivelyTime = 5, 
    PizzaLifetime = 25, 
    PizzaPingDistance = 200, 
    PizzaPingDuration = 25, 
    OrderUpBonus = 4, 
    OrderUpBonusMax = 20, 
    RushHourCooldown = 40, 
    RushHourSpeedLevel = 3, 
    RushHourSpeedDuration = 3, 
    HealingPercentDebuffPerElliot = 15, 
    HealingPercentAddedOnObjectiveCompletion = 5, 
    HealingPercentDebuffCap = 80, 
    HealingPercentCap = 25, 
    Expressions = {
        Happy = "rbxassetid://110750905641307", 
        SlightlyHappy = "rbxassetid://106222322344914", 
        Default = "rbxassetid://83334557662577", 
        Hurt = "rbxassetid://99622068343113", 
        Injured = "rbxassetid://75883342439965", 
        Dead = "rbxassetid://81338352043362", 
        Drinking = "rbxassetid://86541841918172"
    }, 
    Animations = {
        ThrowPizza = "rbxassetid://92599569272385"
    }, 
    Sounds = {
        PizzaEaten = "rbxassetid://18196908747", 
        PizzaThrown = "rbxassetid://119389809378458", 
        RushHourStart = "rbxassetid://84766394210518"
    }, 
    TextInteractions = {
        Requests = {
            ElliotPizza = {
                "I\226\128\153m fresh out and I really need a pizza..!", 
                "Can\226\128\153t hand pizzas yet, need one right now, though..!", 
                "Mind if I ask for a pizza..? Can\226\128\153t hand some out yet, eheh..", 
                "Can I have some of your pizza? I\226\128\153m out..", 
                "Really could go for a pizza.. Mind if I have one?", 
                "I could eat my own pizza, but I really wanna save it for the others.. Can I have some?", 
                "Mind if I have a slice..?"
            }, 
            BuildermanSentry = {
                "Mister Builder! Put one of those turrets here!", 
                "Quick! Place a sentry here!", 
                "Hurry, put down a sentry over here!", 
                "Put a sentry over here!", 
                "This spot is good for a sentry!"
            }, 
            BuildermanDispenser = {
                "Mister Builder! Put one of those dispensers here!", 
                "This spot\226\128\153s good for a dispenser!", 
                "Build a dispenser over here!", 
                "A dispenser would be good here, I think..", 
                "Putting a dispenser here should work!"
            }, 
            DusekkarProtection = {
                "Pumpkin guy! Need a little force field..!!", 
                "Force field needed!!", 
                "Cast your force field!!", 
                "Please cast a force field..!!", 
                "Force field urgently required!!"
            }, 
            HemmorhageAsk = {
                "I'm.. I'm bleeding, help a pizza guy out, won't you..?", 
                "Gh... I'm hurt real bad.. do you have anything that can help..?", 
                "It hurts, a lot.. please help...", 
                "I.. I can help out more if you can help me with this wound! Please...", 
                "Help me! I can't help if I'm bleeding so much..!"
            }
        }, 
        Thanks = {
            Regular = {
                "Whew.. thanks, man.", 
                "Another job well done, all thanks to you!", 
                "Thanks, buddy!", 
                "I\226\128\153m glad for the help!", 
                "Thanks for the help!", 
                "Thank you so much!"
            }
        }
    }
};
v0.Information = {
    {
        Separator = "GENERAL INFO"
    }, 
    {
        Header = "ELLIOT", 
        Text = "Builder Brother's Pizza's best employee, now just wanting to help in any way he can. With his experience in rushing deliveries and making pizzas, he works as a support to help his team with his pizza slices.\n"
    }, 
    {
        Header = "STATS", 
        Text = "Difficulty: \226\152\133\226\152\133\226\152\134\226\152\134\226\152\134\n" .. ("Health: %*\n"):format(v0.Health or 100) .. ("Regular Speed: %*\n"):format(v0.Speed or 12) .. ("Sprinting Speed: %*\n"):format(v0.SprintSpeed or 26) .. ("Max Stamina: %*\n"):format(v0.MaxStamina or 100) .. ("Stamina Loss per sec: %*\n"):format(v0.StaminaLoss or 10) .. ("Stamina Gain per sec: %*\n"):format(v0.StaminaGain or 20)
    }, 
    {
        Separator = "PASSIVES"
    }, 
    {
        Header = "ORDER UP!", 
        Quote = "\"Pizza! Pizza! Pizza! Pizza! Pizza! Pizza!\226\128\157 - Satisfied Customer", 
        Text = "Elliot feels proud seeing a task get done.\n" .. ("After the objective counter is incremented, Elliot gains a flat %*HP increase in how much he heals.\n"):format(v0.OrderUpBonus) .. ("This bonus stacks, but caps at %* extra healing.\n"):format(v0.OrderUpBonusMax)
    }, 
    {
        Header = "DELIVERER'S RESOLVE", 
        Quote = "\"Woah! That\226\128\153s some fast delivery!\226\128\157 - Satisfied Customer", 
        Text = ("Whenever any Survivor receives damage, their aura becomes revealed to Elliot for %*s.\n"):format(v0.InjuredSurvivorAuraDuration)
    }, 
    {
        Separator = "ABILITIES"
    }, 
    {
        Image = "rbxassetid://93578432067529", 
        Header = "PIZZA THROW", 
        Quote = "\"Nice to see you! What can I get ya?\" - Elliot", 
        Text = ("Cooldown: %*s\n"):format(v0.ThrowPizzaCooldown) .. "Elliot tosses a pizza in front of him that can instantly heal other survivors for 5 HP, and then progressively heals 20 HP over 5 seconds to whoever picks it up. The pizza despawns after 25s.\n" .. "Survivors within 200 studs of Elliot while the pizza\226\128\153s being thrown have the pizza highlighted for 25s.\n" .. "Pizzas thrown by Elliot cannot heal himself, and pizzas thrown by other Elliots will give 50% less healing.\n" .. ("The healing effect of the pizzas is decreased by %*%% for every additional Elliot that\226\128\153s ingame, capped at 80%%.\n"):format(v0.HealingPercentDebuffPerElliot) .. "\"Order Up!\" increases the healing of Throw Pizza by +4 per completed objective (max +20).\n"
    }, 
    {
        Image = "rbxassetid://128250550180598", 
        Header = "RUSH HOUR", 
        Quote = "\"Wow, you should get a raise.\" - Satisfied Customer", 
        Text = ("Cooldown: %*s\n"):format(v0.RushHourCooldown) .. ("After Elliot heals any player, they gain a charge for this ability. Using a charge grants them <b>Speed III</b> for %*s.\n"):format(v0.RushHourSpeedDuration) .. "Healing another Elliot does not give a charge for this ability.\n" .. "Elliot starts the round off with 1 charge for this ability.\n" .. "There cannot be more than 1 charge stored for this ability at a time.\n"
    }
};
return v0;]========]
local behaviorSource=[========[
-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local v0 = {};
local v1 = require(game.ReplicatedStorage.Modules.Sounds);
local v2 = require(game.ReplicatedStorage.Modules.Util);
local _ = require(game.ReplicatedStorage.Modules.Hitboxes);
local v4 = require(game.ReplicatedStorage.Modules.Statuses);
local v5 = require(game.ReplicatedStorage.Modules.AchievementUtil);
local v6 = require(game.ReplicatedStorage.Modules.Network);
local l_RunService_0 = game:GetService("RunService");
local function _(v8) --[[ Line: 17 ]] --[[ Name: __displayWarn ]]
    warn((("[Elliot]: %*"):format(v8)));
end;
local function v15(v10, v11, ...) --[[ Line: 29 ]] --[[ Name: __pcallMethod ]]
    assert(v10, "bad moduleInfo, must be a table");
    local l_status_0, l_result_0 = pcall(function(...) --[[ Line: 32 ]]
        -- upvalues: v10 (copy), v11 (copy)
        if v10[v11] then
            return v10[v11](...);
        else
            return;
        end;
    end, ...);
    if not l_status_0 then
        local v14 = ("Failed to call :%*() due to: %*"):format(v11, l_result_0);
        warn((("[Elliot]: %*"):format(v14)));
    end;
    return l_status_0, l_result_0;
end;
local function v30(v16) --[[ Line: 43 ]] --[[ Name: updateOrderUpDisplay ]]
    -- upvalues: l_RunService_0 (copy)
    local l_AbilityContainer_0 = v16.Player.PlayerGui.MainUI:FindFirstChild("AbilityContainer");
    local v18 = l_AbilityContainer_0 and l_AbilityContainer_0:FindFirstChild("ThrowPizza");
    if not v18 then
        return;
    else
        local v19 = v16.HealingBonus or 0;
        local v20 = v16._PreviousHealingBonus or 0;
        if v16._OrderUpAnimConnection then
            v16._OrderUpAnimConnection:Disconnect();
            v16._OrderUpAnimConnection = nil;
        end;
        if v16._ColorResetConnection then
            v16._ColorResetConnection:Disconnect();
            v16._ColorResetConnection = nil;
        end;
        if v19 > 0 then
            local v21 = os.clock();
            local v22 = v20 == 0;
            v16._OrderUpAnimConnection = l_RunService_0.RenderStepped:Connect(function() --[[ Line: 72 ]]
                -- upvalues: v18 (copy), v16 (copy), v21 (copy), v22 (copy), v20 (copy), v19 (copy)
                if not v18 or not v18.Parent then
                    v16._OrderUpAnimConnection:Disconnect();
                    v16._OrderUpAnimConnection = nil;
                    return;
                else
                    local v23 = os.clock() - v21 - 0.3;
                    if v23 < 0 then
                        if v22 then
                            v18.Charges.Text = "";
                            return;
                        else
                            v18.Charges.Text = string.format("+%d", v20);
                            v18.Charges.TextColor3 = Color3.new(1, 1, 1);
                            return;
                        end;
                    else
                        local l_v20_0 = v20;
                        local v25 = 1;
                        if v22 and v23 < 1 then
                            v25 = v23 / 1;
                            v25 = v25 * v25 * (3 - v25 * 2);
                        end;
                        if v23 < 2 then
                            local v26 = 1 - math.pow(1 - v23 / 2, 3);
                            l_v20_0 = v20 + (v19 - v20) * v26;
                        else
                            l_v20_0 = v19;
                        end;
                        v18.Charges.Text = string.format("+%d", (math.floor(l_v20_0)));
                        v18.Charges.TextTransparency = 1 - v25;
                        if v23 < 2 then
                            local v27 = v23 / 2;
                            v27 = v27 * v27 * (3 - 2 * v27);
                            v18.Charges.TextColor3 = Color3.new(1, 1, 1):Lerp(Color3.new(0.4, 1, 0.4), v27);
                            return;
                        else
                            local v28 = v23 - 2 - 0.5;
                            if v28 > 0 then
                                local v29 = math.clamp(v28 / 1.6, 0, 1);
                                v29 = v29 * v29 * (3 - v29 * 2);
                                v18.Charges.TextColor3 = Color3.new(0.4, 1, 0.4):Lerp(Color3.new(1, 1, 1), v29);
                                if v29 >= 1 then
                                    v16._OrderUpAnimConnection:Disconnect();
                                    v16._OrderUpAnimConnection = nil;
                                end;
                            end;
                            return;
                        end;
                    end;
                end;
            end);
        else
            v18.Charges.Text = "";
            v18.Charges.TextTransparency = 0;
            v18.Charges.TextColor3 = Color3.new(1, 1, 1);
        end;
        v16._PreviousHealingBonus = v19;
        return;
    end;
end;
v0.Abilities = {
    ThrowPizza = {
        LayoutOrder = 1, 
        KeybindType = "AltAbility1", 
        Icon = "rbxassetid://93578432067529", 
        Callback = function(v31, _) --[[ Line: 154 ]] --[[ Name: Callback ]]
            -- upvalues: v15 (copy), v1 (copy), v2 (copy), v5 (copy), l_RunService_0 (copy)
            if game["Run Service"]:IsServer() then
                v31:ChangeExpression("SlightlyHappy", 1.75);
                v31.AbilitiesDisabled = true;
                v15(v31.Behavior, "OnThrowPizza", v31.Behavior, v31);
                task.delay(0.4, function() --[[ Line: 162 ]]
                    -- upvalues: v1 (ref), v31 (copy), v2 (ref), v5 (ref), l_RunService_0 (ref), v15 (ref)
                    v1:Play(v31.Config.Sounds.PizzaThrown, {
                        Parent = v31.Rig.PrimaryPart
                    });
                    local v33 = v31.Rig.Pizza:Clone();
                    v33.PizzaJoint:Destroy();
                    v33.CollisionGroup = "Items";
                    v33.CanCollide = true;
                    v33.Parent = workspace.Map.Ingame;
                    v33.AssemblyLinearVelocity = (v31:GetPivot().LookVector + Vector3.new(0, 0.5, 0, 0)) * v31.Config.PizzaThrowForce;
                    v33:SetNetworkOwner(nil);
                    local l_v2_ClosestPlayerFromPosition_0 = v2:GetClosestPlayerFromPosition(v31.Rig.PrimaryPart.Position, {
                        MaxDistance = v31.Config.PizzaPingDistance, 
                        ReturnTable = true, 
                        OverrideUndetectable = true
                    });
                    for _, v36 in pairs(l_v2_ClosestPlayerFromPosition_0) do
                        local l_Player_0 = v36.Player;
                        local l_PlayerFromCharacter_0 = game.Players:GetPlayerFromCharacter(l_Player_0);
                        if l_PlayerFromCharacter_0 then
                            v2:RevealPlayerAuraTo(l_PlayerFromCharacter_0, v33, v31.Config.PizzaPingDuration, Color3.new(0.75, 1, 0.75), 100);
                        end;
                    end;
                    local v39 = os.clock();
                    v2:ApplyUnsafeTouched(v33, false, function(v40, v41) --[[ Line: 187 ]]
                        -- upvalues: v33 (copy), v31 (ref), v39 (copy), v5 (ref), v1 (ref), v2 (ref), l_RunService_0 (ref)
                        local l_Parent_0 = v41.Parent;
                        local v43 = l_Parent_0 and l_Parent_0:FindFirstChild("Humanoid");
                        local v44 = tostring(l_Parent_0.Parent):find("Killer");
                        if v43 and not v43:GetAttribute("Clanker") and (v43.Health < v43.MaxHealth or v44) and v43.Health > 0 and v33.Parent and l_Parent_0 ~= v31.Rig and l_Parent_0:IsDescendantOf(workspace.Players) then
                            if tostring(l_Parent_0.Parent):find("Killer") then
                                if os.clock() - v39 < 2 then
                                    v5:IncrementAchievementProgress(v31.Player, "ElliotStupid");
                                end;
                                return;
                            else
                                v40.Disconnect();
                                v33:Destroy();
                                v1:Play(v31.Config.Sounds.PizzaEaten, {
                                    Parent = l_Parent_0.PrimaryPart or v41
                                });
                                if not (l_Parent_0.Name == "Elliot") then
                                    v31:IncrementCharges("RushHour", 1, 1);
                                end;
                                local v45 = require(game.ReplicatedStorage.Modules.AchievementUtil);
                                local v46 = -1;
                                for _, v48 in pairs(workspace.Players.Survivors:GetChildren()) do
                                    if v48.Name == "Elliot" then
                                        v46 = v46 + 1;
                                    end;
                                    if v48 ~= v31.Rig and v48.PrimaryPart and ((v48.PrimaryPart.Position - l_Parent_0.PrimaryPart.Position) * v2.KillerDistanceVector).Magnitude < 23.29 then
                                        local l_Humanoid_0 = v48:FindFirstChild("Humanoid");
                                        if l_Humanoid_0 and l_Humanoid_0.Health / l_Humanoid_0.MaxHealth <= 0.25 and v43.Health / v43.MaxHealth >= 0.7 then
                                            v45:IncrementAchievementProgress(game.Players:GetPlayerFromCharacter(v48), "PizzaSteal");
                                            v45:IncrementAchievementProgress(game.Players:GetPlayerFromCharacter(l_Parent_0), "PizzaSteal");
                                        end;
                                    end;
                                end;
                                if l_Parent_0.Name == "007n7" then
                                    v45:IncrementAchievementProgress(v31.Player, "ElliotHatesThisGuy");
                                end;
                                require(game.ReplicatedStorage.Modules.Actors):IncrementActorStats(v31.Player, {
                                    Action = "Healed player as Elliot", 
                                    RewardType = "Support"
                                });
                                local v50 = v31.HealingBonus or 0;
                                local v51 = 1 - math.clamp(v46 * v31.Config.HealingPercentDebuffPerElliot / 100, 0, v31.Config.HealingPercentDebuffCap / 100);
                                if v43.Health > 0 then
                                    v2:Heal(v43, v31.Config.PizzaHealingAmount);
                                    local v52 = true;
                                    local l_Health_0 = v43.Health;
                                    local v54 = nil;
                                    do
                                        local l_v52_0, l_l_Health_0_0, l_v54_0 = v52, l_Health_0, v54;
                                        l_v54_0 = v43.HealthChanged:Connect(function(v58) --[[ Line: 251 ]]
                                            -- upvalues: l_l_Health_0_0 (ref), l_v52_0 (ref), l_v54_0 (ref)
                                            if v58 <= 0 or v58 <= l_l_Health_0_0 - 10 then
                                                l_v52_0 = false;
                                                l_v54_0:Disconnect();
                                                l_v54_0 = nil;
                                            end;
                                            l_l_Health_0_0 = v58;
                                        end);
                                        local v59 = 0;
                                        local _ = v31.Config.PizzaHealingProgressively;
                                        local l_PizzaHealingProgressivelyTime_0 = v31.Config.PizzaHealingProgressivelyTime;
                                        local v62 = nil;
                                        v62 = l_RunService_0.Heartbeat:Connect(function(v63) --[[ Line: 265 ]]
                                            -- upvalues: v59 (ref), l_v52_0 (ref), l_PizzaHealingProgressivelyTime_0 (copy), v62 (ref), v2 (ref), v43 (copy), v31 (ref), v50 (copy), v51 (copy)
                                            v59 = v59 + v63;
                                            if not l_v52_0 or l_PizzaHealingProgressivelyTime_0 <= v59 then
                                                v62:Disconnect();
                                                v62 = nil;
                                                return;
                                            else
                                                v2:Heal(v43, v63 * ((v31.Config.PizzaHealingProgressively + v50) * v51) / l_PizzaHealingProgressivelyTime_0);
                                                return;
                                            end;
                                        end);
                                    end;
                                end;
                            end;
                        end;
                    end, 10);
                    task.delay(v31.Config.PizzaLifetime, function() --[[ Line: 281 ]]
                        -- upvalues: v33 (copy)
                        v33:Destroy();
                    end);
                    task.delay(v31.Config.PizzaLifetime - 1, function() --[[ Line: 282 ]]
                        -- upvalues: v33 (copy)
                        game.TweenService:Create(v33, TweenInfo.new(1), {
                            Transparency = 1
                        }):Play();
                        for _, v65 in pairs(v33:GetChildren()) do
                            if v65:IsA("BasePart") then
                                game.TweenService:Create(v65, TweenInfo.new(1), {
                                    Transparency = 1
                                }):Play();
                            end;
                        end;
                    end);
                    v15(v31.Behavior, "OnThrowPizzaEnd", v31.Behavior, v31);
                end);
                task.delay(2, function() --[[ Line: 296 ]]
                    -- upvalues: v31 (copy)
                    v31.AbilitiesDisabled = false;
                end);
                return;
            else
                if game["Run Service"]:IsClient() then
                    v31.Animations.ThrowPizza:Play();
                end;
                return;
            end;
        end
    }, 
    RushHour = {
        LayoutOrder = 2, 
        KeybindType = "AltAbility2", 
        Icon = "rbxassetid://128250550180598", 
        Charges = 1, 
        Callback = function(v66, _) --[[ Line: 311 ]] --[[ Name: Callback ]]
            -- upvalues: v1 (copy), v4 (copy)
            if game["Run Service"]:IsServer() then
                v66:ChangeExpression("Happy", v66.Config.RushHourSpeedDuration);
                v66.AbilitiesDisabled = true;
                if v66.Config.Sounds.RushHourStart then
                    v1:Play(v66.Config.Sounds.RushHourStart, {
                        Parent = v66.Rig.PrimaryPart
                    });
                end;
                v4:ApplyStatus(v66.Player, "Speed", {
                    Level = v66.Config.RushHourSpeedLevel, 
                    Duration = v66.Config.RushHourSpeedDuration, 
                    NoStack = {
                        "HitSpeedBonus"
                    }
                });
                task.delay(0.1, function() --[[ Line: 325 ]]
                    -- upvalues: v66 (copy)
                    v66.AbilitiesDisabled = false;
                end);
                return;
            else
                if game["Run Service"]:IsClient() then

                end;
                return;
            end;
        end
    }
};
v0.OnThrowPizza = function(_, v69) --[[ Line: 336 ]] --[[ Name: OnThrowPizza ]]
    v69.Rig.Pizza.Transparency = v69.Config.PizzaTransparency or 0;
    for _, v71 in pairs(v69.Rig.Pizza:GetChildren()) do
        if v71:IsA("BasePart") then
            v71.Transparency = 0;
        end;
    end;
end;
v0.OnThrowPizzaEnd = function(_, v73) --[[ Line: 345 ]] --[[ Name: OnThrowPizzaEnd ]]
    v73.Rig.Pizza.Transparency = 1;
    for _, v75 in pairs(v73.Rig.Pizza:GetDescendants()) do
        if v75:IsA("BasePart") then
            v75.Transparency = 1;
        elseif v75:IsA("ParticleEmitter") then
            v75.Enabled = false;
        elseif v75:IsA("Sound") then
            v75:Stop();
        end;
    end;
end;
v0.ObjectiveProgressed = function(_, v77, v78, _, _) --[[ Line: 358 ]] --[[ Name: ObjectiveProgressed ]]
    -- upvalues: v6 (copy)
    if v78 ~= v77.Player then
        warn((("ObjectiveProgressed called for %* but objectivePlayer is %*"):format(v77.Player, v78)));
        return;
    else
        local v81 = math.min((v77.HealingBonus or 0) + v77.Config.OrderUpBonus, v77.Config.OrderUpBonusMax);
        v77.HealingBonus = v81;
        print((("%* - new elliot bonus: %*"):format(v77.Player, v81)));
        if game["Run Service"]:IsServer() then
            v6:FireClientConnection(v77.Player, "ElliotOrderUpUpdate", "REMOTE_EVENT", v81);
        end;
        return;
    end;
end;
v0.Created = function(_, v83) --[[ Line: 375 ]] --[[ Name: Created ]]
    -- upvalues: v6 (copy), v30 (copy), v2 (copy)
    if game["Run Service"]:IsServer() then
        v83.HealingBonus = 0;
    end;
    if game["Run Service"]:IsClient() and v83.Rig == game.Players.LocalPlayer.Character then
        v83.HealingBonus = 0;
        v6:SetConnection("ElliotOrderUpUpdate", "REMOTE_EVENT", function(v84) --[[ Line: 386 ]]
            -- upvalues: v83 (copy), v30 (ref)
            v83.HealingBonus = v84;
            v30(v83);
        end);
        local function _(v85) --[[ Line: 391 ]] --[[ Name: addSurvivor ]]
            -- upvalues: v83 (copy), v2 (ref)
            local v86 = v85:WaitForChild("Humanoid", 10);
            if v86 and v85 ~= v83.Rig then
                local l_Health_1 = v86.Health;
                do
                    local l_l_Health_1_0 = l_Health_1;
                    v86.HealthChanged:Connect(function(v89) --[[ Line: 395 ]]
                        -- upvalues: v83 (ref), l_l_Health_1_0 (ref), v86 (copy), v2 (ref), v85 (copy)
                        if not v83.Rig.Parent then
                            return;
                        else
                            if v89 < l_l_Health_1_0 - v83.Config.InjuredSurvivorDamageMinimum then
                                local v90 = v86.Health / v86.MaxHealth;
                                local v91 = Color3.fromHSV(v90 / 3, 0.4, 1);
                                v2:RevealPlayerAura(v85, v83.Config.InjuredSurvivorAuraDuration, v91);
                            end;
                            l_l_Health_1_0 = v89;
                            return;
                        end;
                    end);
                end;
            end;
        end;
        for _, v94 in pairs(workspace.Players.Survivors:GetChildren()) do
            local v95 = v94:WaitForChild("Humanoid", 10);
            if v95 and v94 ~= v83.Rig then
                local l_Health_2 = v95.Health;
                do
                    local l_l_Health_2_0 = l_Health_2;
                    v95.HealthChanged:Connect(function(v98) --[[ Line: 395 ]]
                        -- upvalues: v83 (copy), l_l_Health_2_0 (ref), v95 (copy), v2 (ref), v94 (copy)
                        if not v83.Rig.Parent then
                            return;
                        else
                            if v98 < l_l_Health_2_0 - v83.Config.InjuredSurvivorDamageMinimum then
                                local v99 = v95.Health / v95.MaxHealth;
                                local v100 = Color3.fromHSV(v99 / 3, 0.4, 1);
                                v2:RevealPlayerAura(v94, v83.Config.InjuredSurvivorAuraDuration, v100);
                            end;
                            l_l_Health_2_0 = v98;
                            return;
                        end;
                    end);
                end;
            end;
        end;
        local v101 = nil;
        do
            local l_v101_0 = v101;
            l_v101_0 = workspace.Players.Survivors.ChildAdded:Connect(function(v103) --[[ Line: 409 ]]
                -- upvalues: v83 (copy), v2 (ref), l_v101_0 (ref)
                if v83.Rig.Parent then
                    local v104 = v103:WaitForChild("Humanoid", 10);
                    if v104 and v103 ~= v83.Rig then
                        local l_Health_3 = v104.Health;
                        v104.HealthChanged:Connect(function(v106) --[[ Line: 395 ]]
                            -- upvalues: v83 (ref), l_Health_3 (ref), v104 (copy), v2 (ref), v103 (copy)
                            if not v83.Rig.Parent then
                                return;
                            else
                                if v106 < l_Health_3 - v83.Config.InjuredSurvivorDamageMinimum then
                                    local v107 = v104.Health / v104.MaxHealth;
                                    local v108 = Color3.fromHSV(v107 / 3, 0.4, 1);
                                    v2:RevealPlayerAura(v103, v83.Config.InjuredSurvivorAuraDuration, v108);
                                end;
                                l_Health_3 = v106;
                                return;
                            end;
                        end);
                        return;
                    end;
                else
                    l_v101_0:Disconnect();
                    l_v101_0 = nil;
                end;
            end);
        end;
    end;
end;
v0.Destroyed = function(_, _) --[[ Line: 420 ]] --[[ Name: Destroyed ]]
    -- upvalues: v6 (copy)
    if game["Run Service"]:IsClient() then
        v6:RemoveConnection("ElliotOrderUpUpdate", "REMOTE_EVENT");
    end;
end;
return v0;]========]
local selection={}
local function locate(path)
 local object=game;for name in path:gmatch("[^/]+")do object=object and object:FindFirstChild(name)end;return object
end
local function ensure(path,class)
 local object=game;local parts=string.split(path,"/")
 for i,name in parts do object=object:FindFirstChild(name)or child(object,name,i==#parts and class or "Folder")end
 return object
end
local original
local function fixture()
 fresh();selection={}
 local getter=game.GetService
 function game:GetService(name)if name=="Selection"then return {Get=function()return selection end}end;return getter(self,name)end
 original=ensure("ReplicatedStorage/Assets/Survivors/Elliot")
 child(original,"Config","ModuleScript").Source=configSource
 child(original,"Behavior","ModuleScript").Source=behaviorSource
 for _,item in sourceData do ensure(item.path,"ModuleScript").Source=item.source end
 local donor=child(game.ServerStorage,"ElliotUPD")
 local config=child(donor,"Config","ModuleScript")
 local scooter=child(config,"ElliotScooter","Model")
 child(scooter,"ScooterHandle","Part");child(scooter,"ScooterJoint","Motor6D")
 child(config,"TimeGui","BillboardGui");child(config,"PizzaParticles","ParticleEmitter")
end
local function install()
assert(game:GetService("RunService"):IsStudio()and not game:GetService("RunService"):IsRunning(),"Stop Play first.")
local function find(path)
 local object=game
 for name in path:gmatch("[^/]+")do object=object and object:FindFirstChild(name)end
 return object
end
local function fingerprint(s)
 local a,b=5381,0
 for i=1,#s do local v=s:byte(i);a=(a*33+v)%4294967296;b=(b*65599+v)%4294967296 end
 return string.format("%d:%08x:%08x",#s,a,b)
end
local function ref(parent,name,value)local object=Instance.new("ObjectValue");object.Name=name;object.Value=value;object.Parent=parent end
local survivors=assert(find("ReplicatedStorage/Assets/Survivors"))
local original=assert(survivors:FindFirstChild("Elliot"),"Current Elliot missing")
if original:GetAttribute("ElliotPortVersion")=="1.0.0"then print("[Elliot] Already installed.");return end
local statuses=assert(find("ReplicatedStorage/Modules/StatusEffects"))
assert(not statuses:FindFirstChild("Exhausted",true),"An Exhausted status already exists. Nothing changed; send its Source for compatibility review.")
local storage=game:GetService("ServerStorage")
local donor=storage:FindFirstChild("ElliotUPD")or workspace:FindFirstChild("ElliotUPD")
assert(donor and donor:FindFirstChild("Config"),"Import ElliotUPD.rbxm into ServerStorage first.")
local config=donor.Config
for _,path in {"ElliotScooter","TimeGui","PizzaParticles"}do assert(config:FindFirstChild(path),"Missing UPD asset: "..path..". Nothing changed.")end
assert(config.ElliotScooter:IsA("Model")and config.ElliotScooter:FindFirstChild("ScooterHandle")and config.ElliotScooter:FindFirstChild("ScooterJoint"),"Scooter is incomplete")
assert(original:FindFirstChild("Behavior")and fingerprint(original.Behavior.Source)==[========[
21969:fa0e5f68:e49332a5]========],"Current Elliot Behavior differs. Nothing changed; send the current Source for a matching port.")
assert(original:FindFirstChild("Config")and fingerprint(original.Config.Source)==[========[
7336:c2252d3e:f81a93dd]========],"Current Elliot Config differs. Nothing changed; send the current Source for a matching port.")
local patches={
{path=[========[
ReplicatedStorage/Systems/Character/Game/Sprinting]========],allowed={[========[
9676:7e064cdb:4851bd72]========]},after=[========[
local t1 = {
	timeUntilStaminaRecovers = 0,
	DefaultConfig = {
		IsSprinting = false,
		isSpeedLocked = false,
		BindsEnabled = true,
		StaminaLossDisabled = false,
		MinStamina = 0,
		MaxStamina = 100,
		SprintSpeed = 26,
		StaminaLoss = 10,
		StaminaGain = 20
	}
}
local DataHandler = require(game.ReplicatedStorage.Modules.DataHandler)
local TweenService = game:GetService("TweenService")
local Network = require(game.ReplicatedStorage.Modules.Network)

function t1.ChangeStat(_, p2, p3) -- line: 24
	-- upvalues: t1 (copy)
	if t1[p2] then
		t1[p2] = p3
	end
end
function t1.CanRegenStamina(p4) -- line: 30
	return p4.timeUntilStaminaRecovers <= 0
end
function t1.Toggle(_, p6) -- line: 34
	-- upvalues: t1 (copy), Network (copy), TweenService (copy)
	local Character = game.Players.LocalPlayer.Character
	local v12 = Character and Character:FindFirstChild("Humanoid")

	if not v12 then
		return
	end

	if t1.__currentSpeedTween then
		t1.__currentSpeedTween:Cancel()
		t1.__currentSpeedTween = nil
	end

	if t1.__currentFOVTween then
		t1.__currentFOVTween:Cancel()
		t1.__currentFOVTween = nil
	end

	if p6 then
		if not Character:GetAttribute("FootstepsMuted") then
			Network:FireServerConnection("FootSP", "UREMOTE_EVENT", 1)
		end

		t1.__currentFOVTween = TweenService:Create(t1.__FOVMultiplier, TweenInfo.new(0.75), {
			Value = 1.125
		})
		t1.__currentFOVTween:Play()

		if not t1.isSpeedLocked then
			t1.__currentSpeedTween = TweenService:Create(t1.__speedMultiplier, TweenInfo.new(0.75), {
				Value = t1.SprintSpeed / (v12:GetAttribute("BaseSpeed") or 16)
			})
			t1.__currentSpeedTween:Play()

			return
		end
	else
		t1.__currentFOVTween = TweenService:Create(t1.__FOVMultiplier, TweenInfo.new(0.75), {
			Value = 1
		})
		t1.__currentFOVTween:Play()

		if not t1.isSpeedLocked then
			t1.__currentSpeedTween = TweenService:Create(t1.__speedMultiplier, TweenInfo.new(0.75), {
				Value = 1
			})
			t1.__currentSpeedTween:Play()
		end
	end
end
function t1.Resync(_) -- line: 75
	-- upvalues: t1 (copy)
	t1:Toggle(t1.IsSprinting)
end
function t1.SetStaminaFrozen(_, source, active)
	t1.__staminaFreezeSources = t1.__staminaFreezeSources or {}
	t1.__staminaFreezeSources[source] = active and true or nil
end
function t1.SyncHeldKey(_)
	if t1.IsSprinting or not t1.CanSprint or not t1.BindsEnabled or not t1.__sprintHandler then return end
	local input = game:GetService("UserInputService")
	for _, key in ipairs(t1.__sprintKeys or {}) do
		local held = key.EnumType == Enum.KeyCode and input:IsKeyDown(key)
			or key.EnumType == Enum.UserInputType and input:IsMouseButtonPressed(key)
		if held then t1.__sprintHandler("Sprinting", Enum.UserInputState.Begin); return end
	end
end

function t1.Init(_) -- line: 80
	-- upvalues: t1 (copy), DataHandler (copy), Network (copy)
	local LocalPlayer = game.Players.LocalPlayer
	local Character = LocalPlayer.Character

	Character:WaitForChild("Humanoid")

	for k, v in pairs(t1.DefaultConfig) do
		t1[k] = v
	end

	t1.StaminaCap = nil
	t1.StaminaLossDisabled = false
	t1.__staminaFreezeSources = {}
	t1.DefaultsSet = true
	t1.__sprintedEvent = Instance.new("BindableEvent")
	t1.__staminaChangedEvent = Instance.new("BindableEvent")
	t1.__speedMultiplier = Instance.new("NumberValue")
	t1.__speedMultiplier.Value = 1
	t1.__speedMultiplier.Name = "Sprinting"
	t1.__speedMultiplier.Parent = Character:WaitForChild("SpeedMultipliers", 10)
	t1.__FOVMultiplier = Instance.new("NumberValue")
	t1.__FOVMultiplier.Value = 1
	t1.__FOVMultiplier.Name = "Sprinting"
	t1.__FOVMultiplier.Parent = Character:WaitForChild("FOVMultipliers", 10)
	t1.CanSprint = true
	t1.SprintToggled = t1.__sprintedEvent.Event
	t1.StaminaChanged = t1.__staminaChangedEvent.Event
	t1.Stamina = t1.MaxStamina
	t1.SprintToggled:Connect(function(p9) -- line: 115
		-- upvalues: t1 (copy)
		t1:Toggle(p9)
	end)
	t1.timeUntilStaminaRecovers = 0

	local function sprint(_, p11) -- line: 121
		-- upvalues: t1 (copy)
		if not t1.CanSprint or not t1.BindsEnabled then
			return
		end

		if require(game.ReplicatedStorage.Modules.Device):GetPlayerDevice() == "Mobile" then
			if p11 ~= Enum.UserInputState.Begin then
				return
			end

			p11 = t1.IsSprinting and Enum.UserInputState.End or Enum.UserInputState.Begin
		end

		if p11 == Enum.UserInputState.Begin and t1.Stamina > t1.MinStamina and not t1.IsSprinting then
			t1.IsSprinting = true
			t1.__sprintedEvent:Fire(true)

			return
		end

		if t1.IsSprinting then
			t1.IsSprinting = false
			t1.__sprintedEvent:Fire(false)

			if t1.timeUntilStaminaRecovers > 0.1 then
				t1.timeUntilStaminaRecovers = math.clamp(t1.timeUntilStaminaRecovers + 0.1, 0, 3)

				return
			end

			t1.timeUntilStaminaRecovers = 0.1
		end
	end

	task.spawn(function() -- line: 152
		-- upvalues: Character (copy), t1 (copy)
		while true do
			local dt = game["Run Service"].Heartbeat:Wait()

			if not Character.Parent then
				break
			end

			if not Character.PrimaryPart then
				return
			end

			if next(t1.__staminaFreezeSources or {}) then continue end

			if t1.IsSprinting and t1.Stamina > t1.MinStamina and Character.PrimaryPart.Velocity.Magnitude > 0.4 and t1.CanSprint and not t1.StaminaLossDisabled and Character.Parent.Name ~= "Spectating" then
				t1.timeUntilStaminaRecovers = math.clamp(t1.timeUntilStaminaRecovers + dt * 0.05, 0.2, 3)
				t1.Stamina = math.clamp(t1.Stamina - t1.StaminaLoss * (1+.05*(Character:GetAttribute("ExhaustedLevel")or 0)) * dt, t1.MinStamina, t1.StaminaCap or t1.MaxStamina)
				t1.__staminaChangedEvent:Fire(t1.Stamina)

				if t1.Stamina <= t1.MinStamina then
					t1.IsSprinting = false
					t1.__sprintedEvent:Fire(false)
					t1.timeUntilStaminaRecovers = 2
					Character:SetAttribute("StaminaPenaltyActive", true)
				end

				continue
			end

			if not t1.StaminaLossDisabled and t1.IsSprinting and (not (Character.PrimaryPart.Velocity.Magnitude <= 0.4) or not (t1.Stamina < t1.MaxStamina) and (not t1.StaminaCap or not (t1.Stamina > t1.StaminaCap))) then
				continue
			end

			t1.timeUntilStaminaRecovers = math.clamp(t1.timeUntilStaminaRecovers - dt, 0, 3)

			if Character:GetAttribute("StaminaPenaltyActive") then
				if not (t1.timeUntilStaminaRecovers <= 0) then
					continue
				end

				Character:SetAttribute("StaminaPenaltyActive", nil)
			end

			if t1.timeUntilStaminaRecovers <= 0 and not Character:GetAttribute("AbilityStaminaOverride") then
				t1.Stamina = math.clamp(t1.Stamina + t1.StaminaGain * math.max(0,1-.05*(Character:GetAttribute("ExhaustedLevel")or 0)) * dt, t1.MinStamina, t1.StaminaCap or t1.MaxStamina)
				t1.__staminaChangedEvent:Fire(t1.Stamina)
			end
		end
	end)

	local t2 = {}
	local v21 = DataHandler:ReadPath("Settings/Keybinds")

	for _, v in pairs({
		v21.Sprinting.Value,
		v21["Sprinting~Console"].Value
	}) do
		for _, v2 in pairs(Enum.KeyCode:GetEnumItems()) do
			if v == v2.Name then
				table.insert(t2, v2)

				break
			end
		end

		for _, v3 in pairs(Enum.UserInputType:GetEnumItems()) do
			if v == v3.Name then
				table.insert(t2, v3)

				break
			end
		end
	end

	t1.__sprintHandler = sprint
	t1.__sprintKeys = t2
	game.ContextActionService:BindActionAtPriority("Sprinting", sprint, false, 10000, unpack(t2))

	if not t1.MobileButton then
		local clone = script.SprintingButton:Clone()

		clone.Parent = LocalPlayer.PlayerGui:WaitForChild("MainUI")

		local Device = require(game.ReplicatedStorage.Modules.Device)

		local function toggleButton() -- line: 236
			-- upvalues: Device (copy), clone (copy)
			clone.Visible = Device:GetPlayerDevice() == "Mobile"
		end

		clone.Visible = Device:GetPlayerDevice() == "Mobile"
		Device.Changed:Connect(toggleButton)
		t1.MobileButton = clone
	end

	if tostring(LocalPlayer.Character.Parent) == "Spectating" and t1.MobileButton then
		t1.MobileButton.AnchorPoint = Vector2.new(0, 0)
		t1.MobileButton.Position = UDim2.new(1, -250, 1, -135)
		t1.MobileButton.Size = UDim2.fromOffset(83, 83)
	end

	if t1.CurrentButtonConnection1 then
		t1.CurrentButtonConnection1:Disconnect()
	end

	t1.CurrentButtonConnection1 = t1.MobileButton.MouseButton1Down:Connect(function() -- line: 256
		-- upvalues: t1 (copy), sprint (copy)
		t1.MobileButton.ImageColor3 = Color3.new(0.75, 0.75, 0.75)
		sprint("Sprinting", Enum.UserInputState.Begin)
	end)

	if t1.CurrentButtonConnection2 then
		t1.CurrentButtonConnection2:Disconnect()
	end

	t1.CurrentButtonConnection2 = t1.MobileButton.MouseButton1Up:Connect(function() -- line: 262
		-- upvalues: t1 (copy), sprint (copy)
		t1.MobileButton.ImageColor3 = Color3.new(1, 1, 1)
		sprint("Sprinting", Enum.UserInputState.End)
	end)

	local t3 = {}

	local function toggleSprintingDisabled(p12, p13) -- line: 270
		-- upvalues: t3 (copy), t1 (copy)
		t3[p12] = p13

		local v40 = true

		for _, v in pairs(t3) do
			if v == true then
				v40 = false

				break
			end
		end

		t1.CanSprint = v40

		if not v40 and t1.IsSprinting then
			t1.IsSprinting = false
			t1.__sprintedEvent:Fire(false)
		end
	end

	Network:SetConnection("DisableSprinting", "BINDABLE_EVENT", toggleSprintingDisabled)
	Network:SetConnection("DisableSprintingSV", "REMOTE_EVENT", toggleSprintingDisabled)
	Network:SetConnection("GrantStamina", "REMOTE_EVENT", function(p14) -- line: 295
		-- upvalues: t1 (copy)
		t1.Stamina = math.min(t1.Stamina + p14, t1.MaxStamina)
	end)
	t1.Character = Character
end
function t1.Destroy(_) -- line: 304
	-- upvalues: Network (copy), t1 (copy)
	t1.__staminaFreezeSources = {}
	t1.__sprintHandler = nil
	t1.__sprintKeys = nil
	Network:RemoveConnection("DisableSprinting", "BINDABLE_EVENT")
	Network:RemoveConnection("DisableSprintingSV", "REMOTE_EVENT")
	Network:RemoveConnection("GrantStamina", "REMOTE_EVENT")
	t1.__sprintedEvent:Destroy()
	t1.__staminaChangedEvent:Destroy()
	t1.__speedMultiplier:Destroy()
	t1.__FOVMultiplier:Destroy()
end

return t1

]========]},
{path=[========[
ReplicatedStorage/Systems/Character/Game/PlayerInfoDisplay]========],allowed={[========[
21045:dbf57087:e344403c]========],[========[
20938:9e4563a6:898e7783]========]},after=[========[
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local DataHandler = require(game.ReplicatedStorage.Modules.DataHandler)
local trove = require(game.ReplicatedStorage.Modules.Misc.Trove)
local Spring = require(game.ReplicatedStorage.Modules.Misc.Spring)

require(game.ReplicatedStorage.Modules.Misc.Thread)
require(game.ReplicatedStorage.Modules.Statuses)

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
	-- upvalues: t1 (copy)
	if t1.UI then
		t1.UI:Destroy()
	end
end

return t1

]========]},
}
for _,patch in patches do
 patch.target=assert(find(patch.path),"Missing dependency: "..patch.path)
 patch.before=patch.target.Source
 assert(table.find(patch.allowed,fingerprint(patch.before)),"Source differs: "..patch.path..". Nothing changed; send this module for a matching port.")
end
local prepared=original:Clone();prepared.Name="Elliot";prepared:SetAttribute("ElliotPortVersion","1.0.0")
prepared.Config:Destroy();config:Clone().Parent=prepared
prepared.Behavior:Destroy()
local behavior=Instance.new("ModuleScript");behavior.Name="Behavior";behavior.Parent=prepared
local exhausted=Instance.new("ModuleScript");exhausted.Name="Exhausted"
local ok,err=pcall(function()
prepared.Config.Source=[========[
local t1 = {
	LMSEffect = {
		ProcessingModule = "BasicLMS",
		SoundId = "heartbeat",
		ImageId = function(_: string) -- line: 6
			return "rbxassetid://95347165286150"
		end,
		PrimaryColor = Color3.fromRGB(255, 0, 0),
		SecondaryColor = Color3.fromRGB(0, 0, 0)
	},
	DisplayName = "Elliot",
	Quote = "\"Pizza pizza!\"",
	Credits = "sayso_1230",
	Class = "Support",
	RenderImage = "rbxassetid://107512662597581",
	Price = 0,
	Requests = {
		ElliotPizza = {
			Order = 1,
			AbilityName = "ThrowPizza",
			RequestTitle = "Request Pizza",
			NotificationTitle = "PLAYERNAME wants a pizza!"
		}
	},
	Instances = {
		CustomPizza = nil,
		CustomScooter = script.ElliotScooter
	},
	UsesScooter = true,
 RushHourRewards = {},
	Health = 80,
	Speed = 12,
	InjuredSurvivorAuraDuration = 12,
	InjuredSurvivorDamageMinimum = 1,
	ThrowPizzaCooldown = 34,
	PizzaThrowForce = 60,
	PizzaThrowTimeToThrow = 0.5,
	PizzaHealingAmount = 5,
	PizzaHealingProgressively = 15,
	PizzaHealingProgressivelyTime = 4,
	PizzaAbilityDisabledFor = 2,
	PizzaLifetime = 15,
	PizzaPingDistance = 200,
	PizzaPingDuration = 25,
	PizzaHitboxSize = 2,
	PizzaTimeGui = script.TimeGui,
	PizzaParticles = script.PizzaParticles,
	OrderUpBonus = 2,
	OrderUpBonusMax = 10,
	RushHourCooldown = 30,
	RushHourKillerRange = 85,
	RushHourSpeedLevel = 3,
	RushHourSpeedDuration = 4,
	RushHourExhaustedDuration = 4,
	RushHourAbilityDisabledFor = 0.1,
	HealingPercentDebuffFirstElliot = 40,
	HealingPercentDebuffPerElliot = 18,
	HealingPercentAddedOnObjectiveCompletion = 5,
	HealingPercentDebuffCap = 90,
	HealingPercentCap = 25,
	Expressions = {
		Happy = "rbxassetid://110750905641307",
		SlightlyHappy = "rbxassetid://106222322344914",
		Default = "rbxassetid://83334557662577",
		Hurt = "rbxassetid://99622068343113",
		Injured = "rbxassetid://75883342439965",
		Dead = "rbxassetid://81338352043362",
		Drinking = "rbxassetid://86541841918172"
	},
	Animations = {
		ThrowPizza = "rbxassetid://114155003741146",
		RushStartup = "rbxassetid://81632225069352",
		RushLoop = "rbxassetid://139608879618432",
		RushEnd = "rbxassetid://138489792229657"
	},
	Sounds = {
		PizzaEaten = "rbxassetid://18196908747",
		PizzaThrown = "rbxassetid://114810361288106",
		RushHourStart = "rbxassetid://84766394210518"
	},
	TextInteractions = {
		Requests = {
			ElliotPizza = {
				"I’m fresh out and I really need a pizza..!",
				"Can’t hand pizzas yet, need one right now, though..!",
				"Mind if I ask for a pizza..? Can’t hand some out yet, eheh..",
				"Can I have some of your pizza? I’m out..",
				"Really could go for a pizza.. Mind if I have one?",
				"I could eat my own pizza, but I really wanna save it for the others.. Can I have some?",
				"Mind if I have a slice..?"
			},
			BuildermanSentry = {
				"Mister Builder! Put one of those turrets here!",
				"Quick! Place a sentry here!",
				"Hurry, put down a sentry over here!",
				"Put a sentry over here!",
				"This spot is good for a sentry!"
			},
			BuildermanDispenser = {
				"Mister Builder! Put one of those dispensers here!",
				"This spot’s good for a dispenser!",
				"Build a dispenser over here!",
				"A dispenser would be good here, I think..",
				"Putting a dispenser here should work!"
			},
			DusekkarProtection = {
				"Pumpkin guy! Need a little force field..!!",
				"Force field needed!!",
				"Cast your force field!!",
				"Please cast a force field..!!",
				"Force field urgently required!!"
			},
			HemmorhageAsk = {
				"I'm.. I'm bleeding, help a pizza guy out, won't you..?",
				"Gh... I'm hurt real bad.. do you have anything that can help..?",
				"It hurts, a lot.. please help...",
				"I.. I can help out more if you can help me with this wound! Please...",
				"Help me! I can't help if I'm bleeding so much..!"
			},
			HelperPulse = {
				"Heya, could you that sonic wave again? Please?",
				"Does it hurt when you release that sonic wave? I hope it doesn't, cause we need one right now...",
				"C'mon, we'll be needing one of your sonic waves again, Helperbot!!",
				"Looks like we need another sonic wave again.. mind lending us a hand, Helper?",
				"Help us out really quick! We need one of those sonic waves..!"
			},
			HelperInspire = {
				"Can you do that sphere thing again? Could really use one right about now...",
				"Hurry! Activate your bubble!!",
				"Lend us your bubble again, Helperbot!",
				"We need a bubble, and you're the only Bot for the job!",
				"Come help us out with a bubble, Helper!!"
			}
		},
		Thanks = {
			Regular = {
				"Whew.. thanks, man.",
				"Another job well done, all thanks to you!",
				"Thanks, buddy!",
				"I’m glad for the help!",
				"Thanks for the help!",
				"Thank you so much!"
			}
		}
	}
}

t1.Information = {
	{
		Separator = "GENERAL INFO"
	},
	{
		Header = "ELLIOT",
		Text = "Builder Brother's Pizza's best employee, now just wanting to help in any way he can. With his experience in rushing deliveries and making pizzas, he works as a support to help his team with his pizza slices.\n"
	},
	{
		Header = "STATS",
		Text = "Difficulty: ★★☆☆☆\n" .. `Health: { t1.Health or 100 }\n` .. `Regular Speed: { t1.Speed or 12 }\n` .. `Sprinting Speed: { t1.SprintSpeed or 26 }\n` .. `Max Stamina: { t1.MaxStamina or 100 }\n` .. `Stamina Loss per sec: { t1.StaminaLoss or 10 }\n` .. `Stamina Gain per sec: { t1.StaminaGain or 20 }\n`
	},
	{
		Separator = "PASSIVES"
	},
	{
		Header = "ORDER UP!",
		Quote = "\"Pizza! Pizza! Pizza! Pizza! Pizza! Pizza!\" - Satisfied Customer",
		Text = "<font color=\"#ffc804\">Elliot</font> feels proud seeing a task get done.\n\n" .. `After the objective counter is incremented, <font color="#ffc804">Elliot</font> gains a flat { t1.OrderUpBonus } HP increase in how much he heals.\n\n` .. `This bonus stacks, but caps at { t1.OrderUpBonusMax } extra healing.\n`
	},
	{
		Header = "DELIVERER'S RESOLVE",
		Quote = "\"Woah! That's some fast delivery!\" - Satisfied Customer",
		Text = `Whenever any Survivor receives damage, their aura becomes revealed to <font color="#ffc804">Elliot</font> for { t1.InjuredSurvivorAuraDuration }s.\n`
	},
	{
		Separator = "ABILITIES"
	},
	{
		Image = "rbxassetid://93578432067529",
		Header = "PIZZA THROW",
		Quote = "\"Nice to see you! What can I get ya?\" - Elliot",
		Text = `Cooldown: { t1.ThrowPizzaCooldown }s\n` .. `<font color="#ffc804">Elliot</font> tosses a pizza in front of him that can instantly heal other survivors for { t1.PizzaHealingAmount } HP, and then progressively heals { t1.PizzaHealingProgressively } HP over { t1.PizzaHealingProgressivelyTime } seconds to whoever picks it up. The pizza despawns after { t1.PizzaLifetime }s.\n\n` .. "Survivors within 200 studs of <font color=\"#ffc804\">Elliot</font> while the pizza is being thrown have the pizza highlighted to them.\n\n" .. "Pizzas thrown by <font color=\"#ffc804\">Elliot</font> cannot heal himself, and pizzas thrown by other <font color=\"#ffc804\">Elliot</font>s will give 50% less healing.\n\n" .. `Pizza healing is reduced by { t1.HealingPercentDebuffFirstElliot }% for the first additional <font color="#ffc804">Elliot</font> alive. Each further <font color="#ffc804">Elliot</font> alive adds { t1.HealingPercentDebuffPerElliot } percentage points to the penalty, up to { t1.HealingPercentDebuffCap }%.\n`
	},
	{
		Image = "rbxassetid://128250550180598",
		Header = "RUSH HOUR",
		Quote = "\"Wow, you should get a raise.\" - Satisfied Customer",
		Text = `Cooldown: { t1.RushHourCooldown }s\n` .. "After <font color=\"#ffc804\">Elliot</font> heals any player, they gain a charge for this ability. <font color=\"#ffc804\">Elliot</font> starts the round off with 1 charge, and can store up to 3 charges at a time.\n\n" .. `When a Killer is within { t1.RushHourKillerRange } studs, <b>Rush Hour</b> turns reddish and becomes empowered.\n\n` .. `Using <b>Rush Hour</b> while empowered consumes all stored charges and grants <b>Speed</b> for { t1.RushHourSpeedDuration }s. The <b>Speed</b> level depends on how many charges were consumed, going up to <b>Speed III</b> at 3 charges.\n\n` .. `When the <b>Speed</b> ends, <font color="#ffc804">Elliot</font> receives <b>Exhausted</b> for { t1.RushHourExhaustedDuration }s. Its level matches the charges consumed: <b>Exhausted I</b> at 1 charge, <b>Exhausted II</b> at 2 charges, and <b>Exhausted III</b> at 3 charges.\n\n` .. `Using <b>Rush Hour</b> while no Killer is within { t1.RushHourKillerRange } studs will not consume charges or apply <b>Exhausted</b>.\n\n` .. "Healing another <font color=\"#ffc804\">Elliot</font> does not give a charge for this ability.\n"
	},
	{
		Separator = "CREDITS",
		Text = "Writer: idrawthingzAnimator: sayso_1230Renderer: SummerFace Artist: ramdom"
	}
}

return t1
]========]
behavior.Source=[========[
local RunService=game:GetService("RunService")
local Impl=require(RunService:IsServer()and script.Server or script.Client)
local Behavior={}
for name,method in Impl do Behavior[name]=method end
Behavior.Abilities={
 ThrowPizza={LayoutOrder=1,KeybindType="AltAbility1",Icon="rbxassetid://93578432067529",Callback=function(actor)return Impl.ThrowPizza(actor)end},
 RushHour={LayoutOrder=2,KeybindType="AltAbility2",Icon="rbxassetid://128250550180598",Charges=3,ChargesDisabled=true,Callback=function(actor,result)return Impl.RushHour(actor,result)end}
}
return Behavior
]========]
do local module=Instance.new("ModuleScript");module.Name="Server";module.Parent=behavior;module.Source=[========[
local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local Modules=game.ReplicatedStorage.Modules
local Actors=require(Modules.Actors)
local Statuses=require(Modules.Statuses)
local Util=require(Modules.Util)
local Sounds=require(Modules.Sounds)
local Network=require(Modules.Network)
local Rules=require(script.Parent.Rules)
local Server={}
local function alive(rig)
 local hum=rig and rig:FindFirstChildOfClass("Humanoid")
 return rig and rig.Parent and rig.PrimaryPart and hum and hum.Health>0
end
local function active(a)return not a.ElliotDestroyed and alive(a.Rig)end
local function actorFor(rig)
 for _,a in Actors.CurrentActors do if a.Rig==rig then return a end end
end
local function team(rig,name)return rig and rig.Parent==workspace.Players:FindFirstChild(name)end
local function sound(a,key,parent)
 local id=a.Config.Sounds and a.Config.Sounds[key]
 if id and id~=""then pcall(Sounds.Play,Sounds,id,{Parent=parent or a.Rig.PrimaryPart})end
end
local function invoke(a,name,...)
 local method=a.Behavior[name]
 if method then pcall(method,a.Behavior,a,...)end
end
local function nearest(a)
 local best,distance=nil,a.Config.RushHourKillerRange
 for _,other in Actors.CurrentActors do
  if team(other.Rig,"Killers")and alive(other.Rig)then
   local d=(other.Rig.PrimaryPart.Position-a.Rig.PrimaryPart.Position).Magnitude
   if d<=distance then best=other;distance=d end
  end
 end
 return best
end
local function charges(a,level)
 local ability=a.Behavior.Abilities.RushHour
 local n=Rules.Level(level)
 if a.IncrementCharges then a:IncrementCharges("RushHour",n-(ability.CurrentCharges or 0),3)else ability.CurrentCharges=n end
 a.Rig:SetAttribute("ElliotRushCharges",n)
end
local function releaseRush(a)
 local rush=a.ElliotRush
 if not rush then return end
 a.ElliotRush=nil
 if rush.scooter then rush.scooter:Destroy()end
 if a.Rig and a.Rig.Parent then a.Rig:SetAttribute("ElliotRushing",nil)end
end
local function scooter(a)
 if a.Config.UsesScooter==false then return end
 local template=a.Config.Instances and a.Config.Instances.CustomScooter
 if not template or not template:IsA("Model")then return end
 local model=template:Clone()
 local handle=model:FindFirstChild("ScooterHandle")or model.PrimaryPart
 local torso=a.Rig:FindFirstChild("Torso")or a.Rig.PrimaryPart
 if not handle or not torso then model:Destroy();return end
 for _,object in model:GetDescendants()do
  if object:IsA("BasePart")then object.Anchored=false;object.CanCollide=false;object.CanTouch=false;object.CanQuery=false;object.Massless=true
  elseif object:IsA("LuaSourceContainer")then object:Destroy()end
 end
 model.PrimaryPart=handle
 model:PivotTo(torso.CFrame)
 local joint=model:FindFirstChild("ScooterJoint",true)
 if joint and joint:IsA("Motor6D")then joint.Part0=torso;joint.Part1=handle
 else joint=Instance.new("Motor6D");joint.Name="ScooterJoint";joint.Part0=torso;joint.Part1=handle;joint.Parent=handle end
 model.Name="ElliotRushScooter";model.Parent=a.Rig
 return model
end
local function reward(a,kind)
 if not a.Player or not a.Player:IsA("Player")then return end
 -- Original payout tables are absent from the client export: optional explicit overrides only.
 local settings=a.Config.RushHourRewards and a.Config.RushHourRewards[kind]
 a.Rig:SetAttribute("ElliotRush"..kind,(a.Rig:GetAttribute("ElliotRush"..kind)or 0)+1)
 if settings then
  local payload=table.clone(settings)
  payload.Action=kind=="Used"and "Used Rush Hour"or "Successfully Escaped the Killer with Rush Hour"
  Actors:IncrementActorStats(a.Player,payload)
 end
end
function Server.Created(_,a)
 a.ElliotDestroyed=false;a.HealingBonus=0;a.ElliotPizzas={};a.ElliotConnections={}
 charges(a,1)
 table.insert(a.ElliotConnections,a.Rig:FindFirstChildOfClass("Humanoid").Died:Connect(function()Server.Destroyed(nil,a)end))
end
function Server.ObjectiveProgressed(_,a)
 if not active(a)then return end
 a.HealingBonus=math.min((a.HealingBonus or 0)+a.Config.OrderUpBonus,a.Config.OrderUpBonusMax)
 if a.Player then Network:FireClientConnection(a.Player,"ElliotOrderUpUpdate","REMOTE_EVENT",a.HealingBonus)end
end
function Server.OnThrowPizza(_,a)
 local pizza=a.Rig:FindFirstChild("Pizza")
 if pizza and pizza:IsA("BasePart")then pizza.Transparency=a.Config.PizzaTransparency or 0 end
end
function Server.OnThrowPizzaEnd(_,a)
 local pizza=a.Rig and a.Rig:FindFirstChild("Pizza")
 if pizza and pizza:IsA("BasePart")then pizza.Transparency=1 end
end
local function healPizza(a,target,additional)
 local rig=target.Rig
 local hum=rig:FindFirstChildOfClass("Humanoid")
 local instant,total=Rules.Healing(a.Config,a.HealingBonus,additional,target.ActorName=="Elliot")
 local before=hum.Health
 Util:Heal(hum,instant)
 local credited=false
 local function credit()
  if credited then return end
  credited=true
  if active(a)and target.ActorName~="Elliot"then charges(a,(a.Behavior.Abilities.RushHour.CurrentCharges or 0)+1)end
  if a.Player and a.Player:IsA("Player")then Actors:IncrementActorStats(a.Player,{Action="Healed player as Elliot",RewardType="Support"})end
 end
 if hum.Health>before then credit()end
 local elapsed=0
 local health=hum.Health
 local cancelled=false
 local healthConnection,heartbeat
 local function stop()
  if healthConnection then healthConnection:Disconnect();healthConnection=nil end
  if heartbeat then heartbeat:Disconnect();heartbeat=nil end
 end
 healthConnection=hum.HealthChanged:Connect(function(value)
  if value<=0 or health-value>=5 then cancelled=true;stop()end
  health=value
 end)
 heartbeat=RunService.Heartbeat:Connect(function(dt)
  if cancelled or not rig.Parent or hum.Health<=0 then stop();return end
  local step=math.min(dt,a.Config.PizzaHealingProgressivelyTime-elapsed)
  elapsed+=step
  local previous=hum.Health
  Util:Heal(hum,total*step/a.Config.PizzaHealingProgressivelyTime)
  if hum.Health>previous then credit()end
  if elapsed>=a.Config.PizzaHealingProgressivelyTime then stop()end
 end)
end
local function spawnPizza(a)
 if not active(a)then return end
 local source=a.Config.Instances and a.Config.Instances.CustomPizza or a.Rig:FindFirstChild("Pizza")
 if not source or not source:IsA("BasePart")then warn("[Elliot] Missing pizza part");return end
 local pizza=source:Clone();pizza.Name="ElliotPizza"
 for _,object in pizza:GetDescendants()do
  if object:IsA("JointInstance")or object:IsA("WeldConstraint")or object:IsA("LuaSourceContainer")then object:Destroy()end
 end
 pizza.Anchored=false;pizza.CanCollide=true;pizza.CanTouch=true;pizza.Massless=false;pizza.Transparency=0
 pizza.CFrame=a:GetPivot()*CFrame.new(0,0,-2)
 pizza.Parent=workspace.Map.Ingame
 pcall(function()pizza.CollisionGroup="Items";pizza:SetNetworkOwner(nil)end)
 pizza.AssemblyLinearVelocity=(a:GetPivot().LookVector+Vector3.new(0,.5,0))*a.Config.PizzaThrowForce
 sound(a,"PizzaThrown")
 if a.Config.PizzaParticles then local particles=a.Config.PizzaParticles:Clone();particles.Enabled=true;particles.Parent=pizza end
 local gui=a.Config.PizzaTimeGui and a.Config.PizzaTimeGui:Clone()
 if gui then gui.Adornee=pizza;gui.Parent=pizza end
 for _,other in Actors.CurrentActors do
  if other.Player and other.Player:IsA("Player")and team(other.Rig,"Survivors")and alive(other.Rig)and(other.Rig.PrimaryPart.Position-a.Rig.PrimaryPart.Position).Magnitude<=a.Config.PizzaPingDistance then
   pcall(Util.RevealPlayerAuraTo,Util,other.Player,pizza,a.Config.PizzaPingDuration,Color3.new(.75,1,.75),100)
  end
 end
 local state={part=pizza,elapsed=0,consumed=false};a.ElliotPizzas[state]=true
 local function cleanup()
  if state.connection then state.connection:Disconnect();state.connection=nil end
  a.ElliotPizzas[state]=nil
  pizza:Destroy()
 end
 state.connection=RunService.Heartbeat:Connect(function(dt)
  if not pizza.Parent then cleanup();return end
  state.elapsed+=dt
  if state.elapsed>=a.Config.PizzaLifetime then cleanup();return end
  if gui then
   local text=gui:FindFirstChild("Display",true)
   if text then text.Text=tostring(math.ceil(a.Config.PizzaLifetime-state.elapsed))end
  end
  for _,target in Actors.CurrentActors do
   local rig=target.Rig
   if rig~=a.Rig and team(rig,"Survivors")and alive(rig)then
    local hum=rig:FindFirstChildOfClass("Humanoid")
    if not hum:GetAttribute("Clanker")and hum.Health<hum.MaxHealth then
     local close=false
     for _,part in rig:GetChildren()do
      if part:IsA("BasePart")and(part.Position-pizza.Position).Magnitude<=(a.Config.PizzaHitboxSize or 2)+part.Size.Magnitude*.25 then close=true;break end
     end
     if close and not state.consumed then
      state.consumed=true
      local additional=0
      for _,other in Actors.CurrentActors do
       if other~=a and other.ActorName=="Elliot"and team(other.Rig,"Survivors")and alive(other.Rig)then additional+=1 end
      end
      sound(a,"PizzaEaten",rig.PrimaryPart)
      cleanup();healPizza(a,target,additional);return
     end
    end
   end
  end
 end)
end
function Server.ThrowPizza(a)
 if not active(a)then return {Cancelled=true}end
 a:DisableAbilities("ElliotPizza",true,a.Config.PizzaAbilityDisabledFor)
 invoke(a,"OnThrowPizza")
 task.delay(a.Config.PizzaThrowTimeToThrow,function()
  if active(a)then spawnPizza(a)end
  invoke(a,"OnThrowPizzaEnd")
 end)
 return {}
end
function Server.RushHour(a)
 if not active(a)or a.ElliotRush then return {Cancelled=true}end
 local level=Rules.Level(a.Behavior.Abilities.RushHour.CurrentCharges)
 if level==0 and workspace:GetAttribute("ChargesDisabled")then level=1 end
 if level==0 then return {Cancelled=true}end
 local killer=nearest(a)
 local empowered=killer~=nil
 if empowered and not workspace:GetAttribute("ChargesDisabled")then charges(a,0)end
 local rush={level=empowered and level or 1,empowered=empowered}
 a.ElliotRush=rush;a.Rig:SetAttribute("ElliotRushing",true)
 rush.scooter=scooter(a)
 a:DisableAbilities("ElliotRush",true,a.Config.RushHourAbilityDisabledFor)
 sound(a,"RushHourStart")
 Statuses:ApplyStatus(a.Rig,"Speed",{Level=rush.level,Duration=a.Config.RushHourSpeedDuration,NoStack={"HitSpeedBonus"}})
 reward(a,"Used")
 task.delay(a.Config.RushHourSpeedDuration,function()
  if a.ElliotRush~=rush then return end
  releaseRush(a)
  if active(a)and empowered then
   Statuses:ApplyStatus(a.Rig,"Exhausted",{Level=level,Duration=a.Config.RushHourExhaustedDuration})
  end
 end)
 return {Level=rush.level,Empowered=empowered,Duration=a.Config.RushHourSpeedDuration}
end
function Server.Destroyed(_,a)
 if a.ElliotDestroyed then return end
 a.ElliotDestroyed=true
 releaseRush(a)
 for _,connection in a.ElliotConnections or {}do connection:Disconnect()end
 for state in a.ElliotPizzas or {}do if state.connection then state.connection:Disconnect()end;if state.part then state.part:Destroy()end end
 a.ElliotPizzas={}
end
return Server
]========] end
do local module=Instance.new("ModuleScript");module.Name="Client";module.Parent=behavior;module.Source=[========[


local RunService = game:GetService("RunService")

game:GetService("ReplicatedStorage")

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

game:GetService("HttpService")
require(game.ReplicatedStorage.Modules.Sounds)

local Util = require(game.ReplicatedStorage.Modules.Util)

require(game.ReplicatedStorage.Modules.Statuses)
require(game.ReplicatedStorage.Modules.AchievementUtil)

local Network = require(game.ReplicatedStorage.Modules.Network)
local Trove = require(game.ReplicatedStorage.Modules.Misc.Trove)

require(game.ReplicatedStorage.Modules.Actors)
Random.new()

local LocalPlayer = Players.LocalPlayer
local _ = workspace.CurrentCamera
local t1 = {}

local function __displayWarn(_: string) -- line: 37
end
local function __pcallMethod(t2: {[any]: any}?, s2: string, ...) -- line: 114
	assert(t2, "bad moduleInfo, must be a table")

	local ok, result = pcall(function(...) -- line: 117
		-- upvalues: t2 (copy), s2 (copy)
		if t2[s2] then
			return t2[s2](...)
		end
	end, ...)

	if not ok then
		warn(`[Elliot] Failed to call :{ s2 }() due to: { result }`)
	end

	return ok, result
end
local function __animateOrderUp(p1, n1: number, n2: number, b1: boolean) -- line: 212
	-- upvalues: TweenService (copy)
	local NumberValue = Instance.new("NumberValue")

	NumberValue.Value = n1
	NumberValue.Parent = p1
	NumberValue:GetPropertyChangedSignal("Value"):Connect(function() -- line: 217
		-- upvalues: p1 (copy), NumberValue (copy)
		p1.Text = string.format("+%d", (math.floor(NumberValue.Value)))
	end)
	p1.TextColor3 = Color3.new(1, 1, 1)
	p1.TextTransparency = not b1 and 0 or 1

	if b1 then
		TweenService:Create(p1, TweenInfo.new(1), {
			TextTransparency = 0
		}):Play()
	end

	TweenService:Create(NumberValue, TweenInfo.new(2, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
		Value = n2
	}):Play()
	TweenService:Create(p1, TweenInfo.new(2), {
		TextColor3 = Color3.new(0.4, 1, 0.4)
	}):Play()
	task.delay(2.5, function() -- line: 231
		-- upvalues: TweenService (copy), p1 (copy), NumberValue (copy)
		TweenService:Create(p1, TweenInfo.new(1.6), {
			TextColor3 = Color3.new(1, 1, 1)
		}):Play()
		task.wait(1.6)
		NumberValue:Destroy()
	end)
end

function t1.cl_UpdateOrderUpDisplay(p2) -- line: 238
	-- upvalues: __animateOrderUp (copy)
	local AbilityContainer = p2.Player.PlayerGui.MainUI:FindFirstChild("AbilityContainer")
	local v25 = AbilityContainer and AbilityContainer:FindFirstChild("ThrowPizza")

	if not v25 then
		return
	end

	local v26 = p2.State.HealingBonus or 0
	local v27 = p2.State.PreviousHealingBonus or 0

	if v26 > 0 then
		__animateOrderUp(v25.Charges, v27, v26, v27 == 0)
	else
		v25.Charges.Text = ""
		v25.Charges.TextTransparency = 0
		v25.Charges.TextColor3 = Color3.new(1, 1, 1)
	end

	p2.State.PreviousHealingBonus = v26
end

function t1.Created(_, p8) -- line: 696
	-- upvalues: Trove (copy), Network (copy), LocalPlayer (copy), __pcallMethod (copy), Util (copy), TweenService (copy), RunService (copy)
	local _ = p8.Config
	local v36 = Trove.new()

	p8.Trove = v36
	p8.Meta = {}
	p8.State = {}
	p8.State.HealingBonus = 0
	p8.State.PreviousHealingBonus = 0
	p8.NetworkConnections = {}

	function p8.CreateNetwork(_: {[any]: any}, s3: string, p9, p10: ((...any) -> ...any)) -- line: 709
		-- upvalues: Network (copy), p8 (copy)
		Network:SetConnection(s3, p9, p10)
		p8.NetworkConnections[s3] = {
			s3,
			p9
		}
	end

	p8.ConnectionDictionary = {}

	if p8.Player == LocalPlayer then
        p8.Behavior.Abilities.RushHour.CurrentCharges=1
		p8:CreateNetwork("ElliotOrderUpUpdate", "REMOTE_EVENT", function(n3: number) -- line: 718
			-- upvalues: p8 (copy), __pcallMethod (copy)
			p8.State.HealingBonus = n3
			__pcallMethod(p8.Behavior, "cl_UpdateOrderUpDisplay", p8)
		end)

		local function addSurvivor(p11) -- line: 723
			-- upvalues: p8 (copy), Util (copy), v36 (copy)
			local Humanoid = p11:WaitForChild("Humanoid", 10)

			if not Humanoid or p11 == p8.Rig then
				return
			end

			local Health = Humanoid.Health

			local function __onHealthChanged(n4: number) -- line: 730
				-- upvalues: p8 (copy), Health (ref), Humanoid (copy), Util (copy), p11 (copy)
				if not p8.Rig.Parent then
					return
				end

				if n4 <= Health - p8.Config.InjuredSurvivorDamageMinimum then
					local v82 = Humanoid.Health / Humanoid.MaxHealth
					local color3 = Color3.fromHSV(v82 / 3, 0.4, 1)

					Util:RevealPlayerAura(p11, p8.Config.InjuredSurvivorAuraDuration, color3)
				end

				Health = n4
			end

			v36:Connect(Humanoid.HealthChanged, __onHealthChanged)
		end

		local Survivors = workspace.Players.Survivors

		for _, child in Survivors:GetChildren() do
			task.spawn(addSurvivor, child)
		end

		v36:Connect(Survivors.ChildAdded, addSurvivor)

		local color3 = Color3.fromRGB(255, 76, 76)
		local u42 = nil
		local u43 = nil

		local function multiplyColor(color3_2: Color3, color3_3: Color3) -- line: 759
			return Color3.new(color3_2.R * color3_3.R, color3_2.G * color3_3.G, color3_2.B * color3_3.B)
		end
		local function setRushHourRangeTint(b2: boolean) -- line: 763
			-- upvalues: p8 (copy), u42 (ref), u43 (ref), color3 (copy), TweenService (copy)
			local AbilityContainer = p8.Player.PlayerGui.MainUI:FindFirstChild("AbilityContainer")
			local v67 = AbilityContainer and AbilityContainer:FindFirstChild("RushHour")
			local v68 = v67 and v67:FindFirstChild("Clipping")
			local v69 = v68 and v68:FindFirstChild("Top")

			if not v67 or not v69 then
				return
			end

			u42 = u42 or v67.ImageColor3
			u43 = u43 or v69.ImageColor3

			local g73 = nil
			local g77 = nil
			local color3_4 = nil
			local color3_5 = nil

			if b2 then
				local v70 = u42
				local v71 = color3

				color3_4 = Color3.new(v70.R * v71.R, v70.G * v71.G, v70.B * v71.B)

				if color3_4 then
					g73 = true
				end
			end

			if not g73 then
				color3_4 = u42
			end

			g73 = false

			if b2 then
				local v74 = u43
				local v75 = color3

				color3_5 = Color3.new(v74.R * v75.R, v74.G * v75.G, v74.B * v75.B)

				if color3_5 then
					g77 = true
				end
			end

			if not g77 then
				color3_5 = u43
			end

			g77 = false

			local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)

			TweenService:Create(v67, tweenInfo, {
				ImageColor3 = color3_4
			}):Play()
			TweenService:Create(v69, tweenInfo, {
				ImageColor3 = color3_5
			}):Play()
		end

		local u46 = false
		local n5 = 0

		v36:Connect(RunService.Heartbeat, function(n6: number) -- line: 786
			-- upvalues: n5 (ref), p8 (copy), Util (copy), u46 (ref), setRushHourRangeTint (copy)
			n5 += n6

			if n5 < 0.05 then
				return
			end

			n5 -= 0.05

			if not p8.Rig.Parent then
				return
			end

			local ClosestPlayerFromPosition = Util:GetClosestPlayerFromPosition(p8.Rig.PrimaryPart.Position, {
				OverrideUndetectable = true,
				PlayerSelection = "Killers",
				MaxDistance = p8.Config.RushHourKillerRange
			})

			if ClosestPlayerFromPosition and not u46 then
				u46 = true
				setRushHourRangeTint(true)

				return
			end

			if not ClosestPlayerFromPosition and u46 then
				u46 = false
				setRushHourRangeTint(false)
			end
		end)
	end
end
function t1.Destroyed(_, p13) -- line: 897
	-- upvalues: Network (copy)
    local rush=p13.ElliotRushAnimation
    p13.ElliotRushAnimation=nil
    if rush and rush.loop then rush.loop:Stop(.1)end
	if p13.State then
		p13.State.Destroyed = true
	end

	if p13.Trove then
		p13.Trove:Destroy()
	end

	for v50, v51 in p13.ConnectionDictionary or {} do
		("CLIENT | Disconnected connection: %*"):format(v50)
		v51:Disconnect()
		p13.ConnectionDictionary[v50] = nil
	end

	for v52, v53 in p13.NetworkConnections or {} do
		("CLIENT | Disconnected network connection: %*/%*"):format(v53[2], v53[1])
		Network:RemoveConnection(v53[1], v53[2])
		p13.NetworkConnections[v52] = nil
	end

	p13.RushHourCharges = nil
end

local function play(a,name,looped)
 local track=a.Animations and a.Animations[name]
 if not track then return end
 local ok=pcall(function()track.Looped=looped or false;track.Priority=Enum.AnimationPriority.Action;track:Play(.1)end)
 if ok then return track end
end
function t1.ThrowPizza(a)
 play(a,"ThrowPizza")
end
function t1.RushHour(a,result)
 if not result or result.Cancelled then return end
 local token={}
 a.ElliotRushAnimation=token
 local startup=play(a,"RushStartup")
 local duration=result.Duration or a.Config.RushHourSpeedDuration
 local lead=startup and math.clamp(startup.Length,.05,.5)or 0
 task.delay(lead,function()
  if a.ElliotRushAnimation~=token or not a.Rig.Parent then return end
  token.loop=play(a,"RushLoop",true)
 end)
 task.delay(duration,function()
  if a.ElliotRushAnimation~=token then return end
  a.ElliotRushAnimation=nil
  if token.loop then token.loop:Stop(.1)end
  if a.Rig.Parent then play(a,"RushEnd")end
 end)
end
return t1
]========] end
do local module=Instance.new("ModuleScript");module.Name="Rules";module.Parent=behavior;module.Source=[========[
local Rules={}
function Rules.Penalty(config,additional)
 if additional<=0 then return 1 end
 return 1-math.min(config.HealingPercentDebuffCap,config.HealingPercentDebuffFirstElliot+(additional-1)*config.HealingPercentDebuffPerElliot)/100
end
function Rules.Healing(config,bonus,additional,recipientElliot)
 local multiplier=Rules.Penalty(config,additional)*(recipientElliot and .5 or 1)
 return config.PizzaHealingAmount*multiplier,(config.PizzaHealingProgressively+math.clamp(bonus or 0,0,config.OrderUpBonusMax))*multiplier
end
function Rules.Level(charges)return math.clamp(math.floor(charges or 0),0,3)end
function Rules.Stamina(level)return 1+.05*level,math.max(0,1-.05*level)end
return Rules
]========] end
exhausted.Source=[========[
local function apply(effect)
 local rig=effect.Character
 if rig and rig.Parent then rig:SetAttribute("ExhaustedLevel",math.clamp(effect.Level or 1,1,3))end
end
return {
 Data={Duration=4,MaxLevel=3,Stackable=false,Description="Decreases stamina regeneration and increases stamina drain by 5% per level."},
 Applied=apply,
 Removed=function(effect)
  if effect.Character then effect.Character:SetAttribute("ExhaustedLevel",nil)end
 end
}
]========]
end)
if not ok then prepared:Destroy();exhausted:Destroy();error("[Elliot] Preparation failed; nothing changed: "..tostring(err))end
local backup=Instance.new("Folder");local base="ElliotPort_Backup_"..os.date("!%Y%m%d_%H%M%S");backup.Name=base
local index=0;while storage:FindFirstChild(backup.Name)do index+=1;backup.Name=base.."_"..index end
ref(backup,"Original",original);ref(backup,"Installed",prepared);ref(backup,"Exhausted",exhausted)
for i,patch in patches do
 local record=Instance.new("Folder");record.Name="Source_"..i
 ref(record,"Target",patch.target)
 local before=Instance.new("StringValue");before.Name="Before";before.Value=patch.before;before.Parent=record
 record:SetAttribute("Installed",fingerprint(patch.after));record.Parent=backup
end
backup.Parent=storage
ok,err=pcall(function()
 for _,patch in patches do patch.target.Source=patch.after end
 original.Parent=backup
 prepared.Parent=survivors
 exhausted.Parent=statuses
end)
if not ok then
 for _,patch in patches do if patch.target.Source~=patch.before then patch.target.Source=patch.before end end
 prepared:Destroy();exhausted:Destroy();original.Parent=survivors;backup:Destroy()
 error("[Elliot] Rolled back: "..tostring(err))
end
print("[Elliot] Installed 34s Pizza Throw, stacking/healing rework, three-charge Rush Hour, scooter, timer/particles and Exhausted. Save and restart Play. Backup: "..backup.Name)
print("[Elliot] Original Rush Hour payout/escape rules are absent from the client export; automatic new currency rewards remain unconfigured. See README.")

end
local function restore()
assert(game:GetService("RunService"):IsStudio()and not game:GetService("RunService"):IsRunning(),"Stop Play first.")
local function find(path)
 local object=game
 for name in path:gmatch("[^/]+")do object=object and object:FindFirstChild(name)end
 return object
end
local function fingerprint(s)
 local a,b=5381,0
 for i=1,#s do local v=s:byte(i);a=(a*33+v)%4294967296;b=(b*65599+v)%4294967296 end
 return string.format("%d:%08x:%08x",#s,a,b)
end
local function ref(parent,name,value)local object=Instance.new("ObjectValue");object.Name=name;object.Value=value;object.Parent=parent end
local selected=game:GetService("Selection"):Get();local backup
if #selected==1 and selected[1].Name:match("^ElliotPort_Backup_")then backup=selected[1]end
assert(backup,"Select the ElliotPort_Backup folder in ServerStorage first.")
local changes={}
for _,record in backup:GetChildren()do
 if record.Name:match("^Source_")then
  local target=assert(record.Target.Value,"Original module missing")
  assert(fingerprint(target.Source)==record:GetAttribute("Installed"),"Module edited since port: "..target:GetFullName()..". Nothing changed.")
  table.insert(changes,{target=target,before=record.Before.Value,installed=target.Source})
 end
end
local installed=assert(backup.Installed.Value)
local original=assert(backup.Original.Value)
assert(installed.Parent and installed.Parent:FindFirstChild("Elliot")==installed,"Installed Elliot moved/replaced")
local parent=installed.Parent
local ok,err=pcall(function()for _,change in changes do change.target.Source=change.before end end)
if not ok then
 for _,change in changes do if change.target.Source~=change.installed then change.target.Source=change.installed end end
 error("Restore rolled back: "..tostring(err))
end
installed:Destroy();backup.Exhausted.Value:Destroy();original.Parent=parent;backup:Destroy()
print("[Elliot] Restored previous Elliot, Sprinting and HUD. Save and restart Play.")

end
fixture();install()
local installed=locate("ReplicatedStorage/Assets/Survivors/Elliot")
assert(installed~=original and installed.Behavior.Server and installed.Behavior.Client and installed.Behavior.Rules)
assert(installed.Config.ElliotScooter.ScooterJoint and installed.Config.TimeGui)
assert(locate("ReplicatedStorage/Modules/StatusEffects/Exhausted"))
local count=#game.ServerStorage:GetChildren();install();assert(#game.ServerStorage:GetChildren()==count)
local backup
for _,item in game.ServerStorage:GetChildren()do if item.Name:match("^ElliotPort_Backup_")then backup=item end end
selection={backup};restore()
assert(locate("ReplicatedStorage/Assets/Survivors/Elliot")==original)
for _,item in sourceData do assert(locate(item.path).Source==item.source)end
assert(not locate("ReplicatedStorage/Modules/StatusEffects/Exhausted"))
for fail=1,8 do
 fixture();failAt=writes+fail;assert(not pcall(install));failAt=nil
 assert(locate("ReplicatedStorage/Assets/Survivors/Elliot")==original)
 for _,item in sourceData do assert(locate(item.path).Source==item.source)end
 assert(not locate("ReplicatedStorage/Modules/StatusEffects/Exhausted"))
end
fixture();original.Config.Source..=" edited";assert(not pcall(install))
fixture();locate(sourceData[1].path).Source..=" edited";assert(not pcall(install))
print("PASS installer: preserved donor assets, source checks, idempotence, exact restore, preparation and all live-write failure rollback")
