
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
local function typeof(value)if type(value)=="table"and value._cf then return "CFrame"end;if type(value)=="table"and value._props then return "Instance"end;return nativeTypeof(value)end
local function signal()
 local entries={}
 return {Connect=function(_,callback)
  local object={Active=true};function object:Disconnect()self.Active=false end
  table.insert(entries,{object,callback});return object
 end,Fire=function(_,...)
  for _,entry in table.clone(entries)do if entry[1].Active then entry[2](...)end end
 end,Count=function()local n=0;for _,entry in entries do if entry[1].Active then n+=1 end end;return n end}
end

local function setup()
 fresh()
 local getter=game.GetService
 function game:GetService(name)if name=="RunService"then return {IsRunning=function()return false end}end;return getter(self,name)end
do local object=game
object=object:FindFirstChild([========[
ReplicatedStorage]========])or child(object,[========[
ReplicatedStorage]========],[========[
ModuleScript]========])
object=object:FindFirstChild([========[
Systems]========])or child(object,[========[
Systems]========],[========[
ModuleScript]========])
object=object:FindFirstChild([========[
Player]========])or child(object,[========[
Player]========],[========[
ModuleScript]========])
object=object:FindFirstChild([========[
UI]========])or child(object,[========[
UI]========],[========[
ModuleScript]========])
object=object:FindFirstChild([========[
Menus]========])or child(object,[========[
Menus]========],[========[
ModuleScript]========])
object=object:FindFirstChild([========[
Shop]========])or child(object,[========[
Shop]========],[========[
ModuleScript]========])
object.Source=[========[
require(game.ReplicatedStorage.GlobalTypes)

local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Debris = game:GetService("Debris")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")
local MarketplaceService = game:GetService("MarketplaceService")
local UserInputService = game:GetService("UserInputService")
local Util = require(game.ReplicatedStorage.Modules.Util)
local CurrencyDisplay = require(script.Parent.Parent.SidebarHandler.Classes.CurrencyDisplay)
local Sounds = require(game.ReplicatedStorage.Modules.Sounds)
local Network = require(game.ReplicatedStorage.Modules.Network)
local DataHandler = require(game.ReplicatedStorage.Modules.DataHandler)
local Trove = require(game.ReplicatedStorage.Modules.Misc.Trove)
local Signal = require(game.ReplicatedStorage.Modules.Misc.Signal)
local Device = require(game.ReplicatedStorage.Modules.CombatMenuCompat.Device)
local RigBuilder = require(script.Classes.RigBuilder)
local ShopSale = require(game.ReplicatedStorage.Modules.CombatMenuCompat.ShopSale)
local LocalPlayer = Players.LocalPlayer
local t1 = {}
local NotFound = script.Assets.NotFound
local EmoteViewport = script.Assets.EmoteViewport
local ConfirmUI = script.Assets.ConfirmUI
local t2 = {
	success = "Bought!",
	poor = "Insufficient funds!",
	alreadyBought = "Already owned! (You were not charged)",
	ratelimited = "Ratelimited! (You were not charged)",
	failed = "Something went wrong... (You were not charged)",
	priceChanged = "Price changed! (You were not charged)"
}
local t3={}

local function setupViewportRig() -- line: 55
	-- upvalues: Players (copy), LocalPlayer (copy)
	local EmoteViewport2 = script.Assets.EmoteViewport

	EmoteViewport2.Parent = workspace.CurrentCamera

	local clone = EmoteViewport2.WorldModel.Rig:Clone()

	EmoteViewport2.WorldModel.Rig:Destroy()
	clone.Parent = EmoteViewport2.WorldModel

	local v44 = clone and clone:FindFirstChildOfClass("Humanoid")
	local ok, result = pcall(Players.GetHumanoidDescriptionFromUserIdAsync, Players, LocalPlayer.UserId)

	if ok and (result and v44) then
		local ok2, result2 = pcall(function() -- line: 67
			-- upvalues: v44 (copy), result (copy)
			v44:ApplyDescriptionAsync(result, Enum.AssetTypeVerification.ClientOnly)
		end)

		if not ok2 then
			warn(`[Shop/{ script }]: Failed to apply description to emote rig. Response: { result2 }`)

			return
		end
	else
		warn(`[Shop/{ script }]: No local player description. Response: { result }`)
	end
end
local function transitionHighlightToState(p1, b1: boolean) -- line: 79
	-- upvalues: t1 (copy), TweenService (copy)
	assert(p1 and p1:IsA("TextButton"), "transitionHighlightToState() There was no highlight to transition.")
	assert(b1 ~= nil, "transitionHighlightToState() There was no state to transition to.")

	local Highlight = p1:FindFirstChild("Highlight")
	local Text = p1:FindFirstChild("Text")

	if not Highlight or not Text then
		warn(`[{ script }]: Failed to transition highlight for: { p1.Name }, missing UI elements.`)

		return
	end

	if t1[p1] then
		return
	end

	t1[p1] = true
	Highlight.Visible = true
	TweenService:Create(Highlight, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
		ImageTransparency = not b1 and 1 or 0
	}):Play()
	TweenService:Create(Text, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
		TextColor3 = b1 and Color3.new(0, 0, 0) or Color3.new(1, 1, 1)
	}):Play()
	task.delay(0.5, function() -- line: 113
		-- upvalues: t1 (copy), p1 (copy), b1 (copy), Highlight (copy)
		t1[p1] = nil

		if not b1 then
			Highlight.Visible = false
		end
	end)
end
local function requireShopAsset(p2) -- line: 121
	if p2:IsA("ModuleScript") then
		return pcall(require, p2)
	end

	local Config = p2:FindFirstChild("Config")

	if Config and Config:IsA("ModuleScript") then
		return pcall(require, Config)
	end

	return false, `No Config ModuleScript found for { p2:GetFullName() }`
end
local function getSkinRigSource(p3) -- line: 134
	local v56 = p3:IsA("ModuleScript") and p3.Parent or p3

	if not v56 then
		return nil
	end

	local Rig = v56:FindFirstChild("Rig")

	if Rig and Rig:IsA("Model") then
		return Rig
	end

	return nil
end
local function transitionToFrame(p4, p5, b2: boolean) -- line: 149
	-- upvalues: TweenService (copy)
	assert(p5 and p5:IsA("Frame"), "transitionToFrame() There was no frame to transition to.")
	assert(b2 ~= nil, "transitionToFrame() There was no direction to transition to.")

	if p4 == nil then
		p5.Position = UDim2.fromScale(0, 0)

		return
	end

	p5.Position = b2 and UDim2.fromScale(-1, 0) or UDim2.fromScale(1, 0)
	p5.Visible = true
	TweenService:Create(p4, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
		Position = UDim2.fromScale(not b2 and -1 or 1, 0)
	}):Play()
	TweenService:Create(p5, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
		Position = UDim2.fromScale(0, 0)
	}):Play()
	task.delay(0.5, function() -- line: 178
		-- upvalues: p4 (copy)
		p4.Visible = false
	end)
end

local t4 = {}
local t9 = {
	FormatPrice = function(_: {[any]: any}, n1: number) -- line: 187
		-- upvalues: Util (copy)
		assert(typeof(n1) == "number", "ShopUtils:FormatPrice() requires a number.")

		if n1 <= 0 then
			return "FREE"
		end

		return `${ Util:ToCommas(n1) }`
	end,
	CreateSearchbar = function(_: {[any]: any}, p6, p7) -- line: 193
		assert(p6 and p6:IsA("TextBox"), "ShopUtils:CreateSearchbar() requires a TextBox.")
		assert(p7 and p7:IsA("GuiObject"), "ShopUtils:CreateSearchbar() requires a Frame.")
		p6:GetPropertyChangedSignal("Text"):Connect(function() -- line: 197
			-- upvalues: p7 (copy), p6 (copy)
			for _, child in (p7:GetChildren()) do
				if child:IsA("GuiObject") and not child:GetAttribute("ShopTemplate") and (not child:GetAttribute("Purchased") or not p7:GetAttribute("ToggledUnowned")) then
					child.Visible = p6.Text == "" or child.Name:lower():find(p6.Text:lower())
				end
			end
		end)
	end,
	SetPurchaseUIState = function(t7: {[any]: any}, b3: boolean) -- line: 212
		-- upvalues: Trove (copy), RunService (copy), TweenService (copy), LocalPlayer (copy)
		if b3 then
			if t7.__trove then
				t7.__trove:Destroy()
			end

			local v68 = Trove.new()

			t7.__trove = v68

			local clone = script.Assets.TransitionGui:Clone()

			clone.Purchase.BackgroundTransparency = 1
			clone.Purchase.Icon.ImageTransparency = 1
			v68:Add(clone)

			local Icon = clone.Purchase.Icon
			local n2 = -1
			local n3 = 0
			local n4 = 0
			local u74 = false

			v68:Connect(RunService.Heartbeat, function(n5: number) -- line: 236
				-- upvalues: n2 (ref), n3 (ref), n4 (ref), u74 (ref), TweenService (copy), Icon (copy)
				n2 += n5 * 1.5
				n3 += n2 * n5

				if n3 > 0.5 then
					n3 = 0.5
					n2 = -1
					n4 += 1

					if n4 % 2 == 0 then
						u74 = not u74
						TweenService:Create(Icon, TweenInfo.new(2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
							Rotation = Icon.Rotation + (not u74 and -360 or 360)
						}):Play()
					end
				end

				Icon.Position = UDim2.fromScale(0.5, n3)
			end)
			clone.Parent = LocalPlayer.PlayerGui
			TweenService:Create(clone.Purchase, TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
				BackgroundTransparency = 0.35
			}):Play()
			TweenService:Create(Icon, TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
				ImageTransparency = 0
			}):Play()

			return
		end

		if t7.__trove then
			t7.__trove:Destroy()
			t7.__trove = nil
		end
	end,
	CreateUnownedButton = function(_: {[any]: any}, p8, p9) -- line: 285
		-- upvalues: Sounds (copy)
		assert(p8 and p8:IsA("TextButton"), "ShopUtils:CreateUnownedButton() requires a TextButton.")
		assert(p9 and p9:IsA("GuiObject"), "ShopUtils:CreateUnownedButton() requires a Frame.")
		p8.MouseEnter:Connect(function() -- line: 289
			-- upvalues: Sounds (copy)
			Sounds:Play("hover")
		end)
		p8.MouseLeave:Connect(function() -- line: 293
			-- upvalues: Sounds (copy)
			Sounds:Play("hoverEnd")
		end)
		p9:SetAttribute("ToggledUnowned", false)
		p8.MouseButton1Down:Connect(function() -- line: 298
			-- upvalues: Sounds (copy), p9 (copy), p8 (copy)
			Sounds:Play("click")

			local v225 = not p9:GetAttribute("ToggledUnowned")

			p9:SetAttribute("ToggledUnowned", v225)

			for _, child in p9:GetChildren() do
				if child:IsA("GuiObject") and not child:GetAttribute("ShopTemplate") and child:GetAttribute("Purchased") then
					child.Visible = not v225
				end
			end

			p8.Icon.ImageTransparency = not v225 and 0 or 0.5
		end)
	end
}
local u34 = false
local u35 = nil

function t9.CreateConfirmationUI(t10: {[any]: any}, p10) -- line: 318
	-- upvalues: u34 (ref), t9 (copy), DataHandler (copy), ConfirmUI (copy), u35 (ref), t4 (copy), ShopSale (copy), TweenService (copy), Sounds (copy), Network (copy), t2 (copy), requireShopAsset (copy), t3 (copy), MarketplaceService (copy), LocalPlayer (copy)
	if u34 then
		return
	end

	t9:ClearConfirmationUI()

	local ok, result = pcall(require, p10)

	if not ok then
		warn(`[{ script }]: Failed to require asset logic: { p10 }.`)

		return
	end

	local v82 = DataHandler:Get()

	if not v82 then
		warn(`[{ script }]: PlayerData does not exist.`)

		return
	end

	u34 = true

	local v83 = t10.__currentlySelected:FindFirstAncestor("Skins") and t10.__currentlySelected.Parent or t10.__currentlySelected

	if not v83 then
		u34 = false

		return
	end

	local clone = ConfirmUI:Clone()

	u35 = clone
	clone.Size = UDim2.fromScale(0.6, 0.6)

	local Menu = t4.ShopMenu.Menu
	local FinalPrice = ShopSale.GetAssetPrice(v83, result, workspace:GetServerTimeNow()).FinalPrice

	local function updateConfirmText() -- line: 352
		-- upvalues: t9 (copy), FinalPrice (ref), clone (copy), result (copy)
		local v228 = t9:FormatPrice(FinalPrice)

		clone:FindFirstChild("Text").Text = `Are you sure you would like to purchase <b><font color="rgb(255,255,255)">{ tostring(result.DisplayName) }</font></b> for <b><font color="rgb(255,255,255)">{ v228 }</font></b>?`
	end

	local v88 = t9:FormatPrice(FinalPrice)

	clone:FindFirstChild("Text").Text = `Are you sure you would like to purchase <b><font color="rgb(255,255,255)">{ tostring(result.DisplayName) }</font></b> for <b><font color="rgb(255,255,255)">{ v88 }</font></b>?`
	clone.Parent = Menu.Holder
	clone.Visible = true
	clone.Position = UDim2.fromScale(0.5, 0.525)
	TweenService:Create(clone, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Position = UDim2.fromScale(0.5, 0.5)
	}):Play()
	clone.Purchase.MouseButton1Down:Connect(function() -- line: 369
		-- upvalues: Sounds (copy), clone (copy), u34 (ref), Network (copy), v83 (copy), FinalPrice (ref), t2 (copy), t9 (copy), t10 (copy), result (copy), requireShopAsset (copy), v82 (copy), t3 (copy), MarketplaceService (copy), LocalPlayer (copy)
		Sounds:Play("click")

		local Text = clone.Purchase:FindFirstChild("Text")

		if not Text then
			u34 = false

			return
		end

		Text.Text = "..."

		local v230 = Network:FireServerConnection("PurchaseContent", "REMOTE_FUNCTION", v83, FinalPrice)

		if t2[v230.Status] then
			if t2[v230.Status] == "Insufficient funds!" and math.random(1, 1000) == 1 then
				Text.Text = "Poor"
			else
				Text.Text = t2[v230.Status]
			end
		end

		if v230.Status == "success" then
			t9.OnPurchased:Fire(t10.__currentlySelected)
		elseif v230.Status == "priceChanged" then
			FinalPrice = v230.Price

			local v231 = t9:FormatPrice(FinalPrice)

			clone:FindFirstChild("Text").Text = `Are you sure you would like to purchase <b><font color="rgb(255,255,255)">{ tostring(result.DisplayName) }</font></b> for <b><font color="rgb(255,255,255)">{ v231 }</font></b>?`

		end

		task.wait(0.5)
		Text.Text = "BUY"
		u34 = false
	end)
	clone.Purchase.MouseEnter:Connect(function() -- line: 428
		-- upvalues: Sounds (copy)
		Sounds:Play("hover")
	end)
	clone.Purchase.MouseLeave:Connect(function() -- line: 432
		-- upvalues: Sounds (copy)
		Sounds:Play("hoverEnd")
	end)
	clone.Cancel.MouseButton1Down:Connect(function() -- line: 436
		-- upvalues: clone (copy), u34 (ref), Sounds (copy)
		clone:Destroy()
		u34 = false
		Sounds:Play("click")
	end)
	clone.Cancel.MouseEnter:Connect(function() -- line: 442
		-- upvalues: Sounds (copy)
		Sounds:Play("hover")
	end)
	clone.Purchase.MouseLeave:Connect(function() -- line: 446
		-- upvalues: Sounds (copy)
		Sounds:Play("hoverEnd")
	end)
	clone.AncestryChanged:Connect(function(_, parent) -- line: 450
		-- upvalues: u34 (ref), t9 (copy)
		if not parent then
			u34 = false
			t9:ClearConfirmationUI()
		end
	end)

	return clone
end
function t9.ClearConfirmationUI(_) -- line: 460
	-- upvalues: u35 (ref)
	if u35 ~= nil then
		u35:Destroy()
	end

	u35 = nil
end
function t9.CreateViewport(_: {[any]: any}, p13, b4: boolean, b5: boolean) -- line: 467
	-- upvalues: EmoteViewport (copy), Players (copy), ReplicatedStorage (copy), Util (copy), SoundService (copy), Sounds (copy), Trove (copy), RunService (copy), UserInputService (copy), TweenService (copy), Debris (copy)
	local clone = EmoteViewport:Clone()
	local Rig = clone.WorldModel.Rig
	local Humanoid = Rig:FindFirstChildOfClass("Humanoid")

	if not Humanoid or not Humanoid:FindFirstChildOfClass("Animator") then
		warn(`[Shop/{ script }]: No animator found for emote { p13.DisplayName }.`)

		return
	end

	local AssetID = p13.AssetID

	if typeof(AssetID) == "table" then
		if p13.isDuoAnim then
			AssetID = AssetID[1]
		elseif not AssetID.Start or not AssetID.Loop then
			local v98 = Players.LocalPlayer.Character and Players.LocalPlayer.Character.Name
			local v99 = v98 and ReplicatedStorage.Assets.Survivors:FindFirstChild(v98)
			local v100 = v99 and (v99:FindFirstChild("Config") and require(v99.Config).Class)

			AssetID = if not v100 or not p13.AssetID[v100] then if not p13.AssetID.Survivalist then AssetID[math.random(#AssetID)] else p13.AssetID.Survivalist else p13.AssetID[v100]
		else
			AssetID = AssetID.Loop
		end
	end

	local v101 = Util:LoadAnimationFromID(Rig, AssetID)

	if v101 then
		v101.Looped = true
		v101:Play(0)
		v101.Priority = Enum.AnimationPriority.Action
	end

	local t12 = {
		Player = Players.LocalPlayer,
		Character = clone.WorldModel.Rig,
		Emote = v101
	}

	if p13.CreatedServer then
		local ok, result = pcall(p13.CreatedServer, t12)

		if not ok then
			warn(`[Shop/{ script }]: Failed to run CreatedServer for emote { p13.DisplayName }: { result }`)
		end
	end

	if p13.CreatedClient then
		local ok, result = pcall(p13.CreatedClient, t12)

		if not ok then
			warn(`[Shop/{ script }]: Failed to run CreatedClient for emote { p13.DisplayName }: { result }`)
		end
	end

	local u107 = nil

	if b4 then
		local v108 = p13.SFXProperties or {}

		v108.SoundGroup = SoundService.Emotes

		local v109 = typeof(p13.SFX) == "table" and p13.SFX.Loop

		if v109 then
			v108.Looped = true
		end

		u107 = Sounds:Play(v109 or p13.SFX, v108)

		if u107 then
			u107.PlaybackRegionsEnabled = true
			u107:GetPropertyChangedSignal("TimeLength"):Connect(function() -- line: 536
				-- upvalues: u107 (ref)
				local v240 = u107.TimeLength or 0

				u107.LoopRegion = NumberRange.new(0, (math.clamp(v240 - 0.05, 0.1, 60000)))
			end)
			u107.LoopRegion = NumberRange.new(0, (math.clamp(u107.TimeLength - 0.05, 0.1, 60000)))
		end
	end

	local u110 = Trove.new()

	if b5 then
		local Camera = Instance.new("Camera")

		Camera.Parent = clone
		clone.CurrentCamera = Camera

		local Arrows = clone.WorldModel:FindFirstChild("Arrows")

		Arrows.Transparency = 0.5

		local n6 = -90
		local n7 = 0
		local u115 = false
		local vector2 = nil

		local function updateCamera() -- line: 569
			-- upvalues: Camera (copy), Rig (copy), n6 (ref)
			if not Camera or (not Rig or not Rig.PrimaryPart) then
				return
			end

			local Position = Rig:GetPivot().Position
			local v242 = math.rad(n6)
			local v243 = Vector3.new(math.sin(v242) * 0.9659258262890683, 0.25881904510252074, math.cos(v242) * 0.9659258262890683) * 6

			Camera.CFrame = CFrame.lookAt(Position + v243, Position)
		end

		updateCamera()

		local n8 = 0
		local n9 = 0
		local zero = Vector2.zero
		local zero2 = Vector2.zero

		u110:Connect(RunService.RenderStepped, function(n10: number) -- line: 594
			-- upvalues: n8 (ref), u115 (ref), n6 (ref), n7 (ref), Rig (copy), Camera (copy), n9 (ref), Arrows (copy), zero2 (ref), zero (ref), updateCamera (copy)
			n8 += n10
			n8 %= 6.283185307179586

			if not u115 then
				n6 += n7 * n10
				n7 *= math.exp(n10 * -3)

				if math.abs(n7) < 0.1 then
					n7 = 0
				end

				local v245 = Rig:GetPivot().Position + Vector3.new(0, -2.5, 0)
				local CFramePosition = Camera.CFrame.Position
				local vector3 = Vector3.new(CFramePosition.X, v245.Y, CFramePosition.Z)

				n9 += n10 * 0.5235987755982988
				n9 %= 360
				Arrows.CFrame = CFrame.lookAt(v245, vector3) * CFrame.Angles(0, n9, 0)
			end

			if u115 == true then
				local v248 = -(zero2.X * 0.3 * n10 * workspace.CurrentCamera.ViewportSize.X) * 0.6

				n6 += v248
				n7 = v248 * 60
			end

			local v249 = -(zero.X * 0.3 * n10 * workspace.CurrentCamera.ViewportSize.X) * 0.6

			n6 += v249
			n7 = v249 * 60

			local v250 = u115 or zero.Magnitude > 0.1

			if v250 and Arrows.Transparency ~= 1 then
				Arrows.Transparency = 1
			elseif not v250 and Arrows.Transparency ~= 0.5 then
				Arrows.Transparency = 0.5
			end

			updateCamera()
		end)

		local function __onMobilePCInput(p14, _: boolean) -- line: 642
			-- upvalues: clone (copy), u115 (ref), vector2 (ref), n7 (ref), zero2 (ref), zero (ref)
			if p14.Position.Z ~= 0 then
				return
			end

			local p14Position = p14.Position
			local AbsolutePosition = clone.AbsolutePosition
			local AbsoluteSize = clone.AbsoluteSize
			local v256 = p14Position.X >= AbsolutePosition.X and p14Position.X <= AbsolutePosition.X + AbsoluteSize.X
			local v257 = p14Position.Y >= AbsolutePosition.Y and p14Position.Y <= AbsolutePosition.Y + AbsoluteSize.Y

			if not v256 or not v257 then
				return
			end

			u115 = true
			vector2 = Vector2.new(p14Position.X, p14Position.Y)
			n7 = 0
			zero2 = Vector2.zero
			zero = Vector2.zero
		end

		u110:Connect(UserInputService.InputBegan, function(p15, b7: boolean) -- line: 663
			-- upvalues: Players (copy), __onMobilePCInput (copy)
			local v260 = false

			if p15.UserInputType == Enum.UserInputType.Gamepad1 then
				if p15.KeyCode == Enum.KeyCode.ButtonR2 then
					v260 = true
				elseif p15.KeyCode == Enum.KeyCode.ButtonA then
					local Mouse = Players.LocalPlayer:GetMouse()

					__onMobilePCInput({
						Position = Vector3.new(Mouse.X, Mouse.Y, 0)
					}, true)

					return
				end
			end

			if v260 or p15.UserInputType == Enum.UserInputType.MouseButton1 or p15.UserInputType == Enum.UserInputType.Touch then
				__onMobilePCInput(p15, b7)
			end
		end)

		local t13 = {
			Enum.UserInputType.MouseMovement,
			Enum.UserInputType.Touch,
			Enum.UserInputType.Gamepad1
		}

		u110:Connect(UserInputService.InputChanged, function(p16, _: boolean) -- line: 686
			-- upvalues: u115 (ref), vector2 (ref), t13 (copy), zero2 (ref), n6 (ref), n7 (ref)
			if not u115 or not vector2 then
				return
			end

			if table.find(t13, p16.UserInputType) == nil then
				return
			end

			local zero3 = Vector2.zero
			local _ = Vector2.zero

			if p16.UserInputType == Enum.UserInputType.Gamepad1 then
				if p16.KeyCode ~= Enum.KeyCode.Thumbstick1 and p16.KeyCode ~= Enum.KeyCode.Thumbstick2 then
					return
				end

				if p16.KeyCode == Enum.KeyCode.Thumbstick1 then
					zero2 = Vector2.new(p16.Position.X, p16.Position.Y)

					return
				end
			else
				zero3 = Vector2.new(p16.Position.X, p16.Position.Y)
			end

			local v266 = zero3 - vector2

			vector2 = zero3

			local v267 = -v266.X * 0.6

			n6 += v267
			n7 = v267 * 60
		end)
		u110:Connect(UserInputService.InputChanged, function(p17, _: boolean) -- line: 721
			-- upvalues: zero (ref)
			if p17.KeyCode == Enum.KeyCode.Thumbstick2 then
				local vector2_2 = Vector2.new(p17.Position.X, p17.Position.Y)

				if vector2_2.Magnitude <= 0.1 then
					vector2_2 = Vector2.zero
				end

				zero = vector2_2

				return
			end
		end)
		u110:Connect(UserInputService.InputEnded, function(p18) -- line: 733
			-- upvalues: u115 (ref), vector2 (ref), zero2 (ref), zero (ref)
			if (p18.UserInputType ~= Enum.UserInputType.Gamepad1 or p18.KeyCode ~= Enum.KeyCode.ButtonR2 and p18.KeyCode ~= Enum.KeyCode.ButtonA) and (p18.UserInputType ~= Enum.UserInputType.MouseButton1 and p18.UserInputType ~= Enum.UserInputType.Touch) then
				return
			end

			u115 = false
			vector2 = nil
			zero2 = Vector2.zero
			zero = Vector2.zero
		end)
	end

	clone.AncestryChanged:Connect(function(_, parent) -- line: 750
		-- upvalues: u110 (ref), p13 (copy), t12 (copy), u107 (ref), TweenService (copy), Debris (copy)
		if parent then
			return
		end

		if u110 then
			u110:Clean()
			u110 = nil
		end

		if p13.DestroyedServer then
			local ok, result = pcall(p13.DestroyedServer, t12)

			if not ok then
				warn(`[Shop/{ script }]: Failed to run DestroyedServer for emote { p13.DisplayName }: { result }`)
			end
		end

		if p13.DestroyedClient then
			local ok, result = pcall(p13.DestroyedClient, t12)

			if not ok then
				warn(`[Shop/{ script }]: Failed to run DestroyedClient for emote { p13.DisplayName }: { result }`)
			end
		end

		if not u107 then
			return
		end

		TweenService:Create(u107, TweenInfo.new(0.1), {
			Volume = 0
		}):Play()
		Debris:AddItem(u107, 0.1)
	end)

	return clone
end
function t9.CreateSkinViewport(_: {[any]: any}, p20, b10: boolean) -- line: 792
	-- upvalues: RigBuilder (copy), Trove (copy), RunService (copy), UserInputService (copy), Players (copy)
	assert(typeof(p20) == "Instance", "ShopUtils:CreateSkinViewport() requires a skin folder.")

	local v127 = RigBuilder.ResolveSkin(p20)

	if not v127 or not v127.ActorFolder then
		warn(`[{ script }]: Could not resolve actor for { p20:GetFullName() }`)

		return
	end

	local v128 = RigBuilder.GetMergedConfig(v127)
	local v129 = RigBuilder.GetMergedBehavior(v127)
	local v130, v131 = RigBuilder.GetRig(v127, v128, v129)

	if not v130 then
		warn(`[{ script }]: No rig found for { p20:GetFullName() }`)

		return
	end

	RigBuilder.SanitizeRig(v130)
	RigBuilder.ApplyExpression(v130, v128)

	if v131 then
		RigBuilder.ApplyLifeAppearance(v130, v131)
	end

	if v127.ActorName == "Veeronica" then
		v130.Skateboard.Transparency = 1
		v130.Spray.Transparency = 1
	end

	local ViewportFrame = Instance.new("ViewportFrame")

	ViewportFrame.BackgroundTransparency = 1
	ViewportFrame.ImageTransparency = 0
	ViewportFrame.Ambient = Color3.fromRGB(200, 200, 200)
	ViewportFrame.LightColor = Color3.fromRGB(140, 140, 140)
	ViewportFrame.LightDirection = Vector3.new(-1, -1, -1)

	local WorldModel = Instance.new("WorldModel")

	WorldModel.WorldPivot = CFrame.new(0, 2.5, 0) * CFrame.Angles(0, 0.8726646259971648, 0)
	WorldModel.Parent = ViewportFrame
	v130:PivotTo(CFrame.new(-1.5, 3, 0) * CFrame.Angles(0, 1.1344640137963142, 0))
	v130.Parent = WorldModel

	local Camera = Instance.new("Camera")

	Camera.FieldOfView = 35
	Camera.Parent = ViewportFrame
	ViewportFrame.CurrentCamera = Camera

	local v135, v136 = RigBuilder.GetVisibleBoundingBox(v130)
	local v137 = math.max(math.max(v136.X, v136.Y, v136.Z) * 1.75, 6)
	local v138 = v135.Position + Vector3.new(0, v136.Y * 0.05, 0)
	local vector3 = Vector3.new(0, v136.Y * 0.12, v137)

	Camera.CFrame = CFrame.lookAt(v138 + vector3, v138)

	local v140 = Trove.new()

	if b10 then
		local Camera2 = Instance.new("Camera")

		Camera2.Parent = ViewportFrame
		ViewportFrame.CurrentCamera = Camera2

		local n11 = -90
		local n12 = 0
		local u144 = false
		local vector2 = nil

		local function updateCamera() -- line: 869
			-- upvalues: Camera2 (copy), v130 (copy), n11 (ref)
			if not Camera2 or (not v130 or not v130.PrimaryPart) then
				return
			end

			local Position = v130:GetPivot().Position
			local v279 = math.rad(n11)
			local v280 = Vector3.new(math.sin(v279) * 0.9659258262890683, 0.25881904510252074, math.cos(v279) * 0.9659258262890683) * 6

			Camera2.CFrame = CFrame.lookAt(Position + v280, Position)
		end

		updateCamera()

		local n13 = 0
		local zero = Vector2.zero
		local zero4 = Vector2.zero

		v140:Connect(RunService.RenderStepped, function(n14: number) -- line: 894
			-- upvalues: n13 (ref), u144 (ref), zero4 (ref), n11 (ref), n12 (ref), zero (ref), updateCamera (copy)
			n13 += n14
			n13 %= 6.283185307179586

			if u144 == true then
				local v282 = -(zero4.X * 0.3 * n14 * workspace.CurrentCamera.ViewportSize.X) * 0.6

				n11 += v282
				n12 = v282 * 60
			end

			local v283 = -(zero.X * 0.3 * n14 * workspace.CurrentCamera.ViewportSize.X) * 0.6

			n11 += v283
			n12 = v283 * 60
			updateCamera()
		end)

		local function __onMobilePCInput(p21, _: boolean) -- line: 917
			-- upvalues: ViewportFrame (copy), u144 (ref), vector2 (ref), n12 (ref), zero4 (ref), zero (ref)
			if p21.Position.Z ~= 0 then
				return
			end

			local p21Position = p21.Position
			local AbsolutePosition = ViewportFrame.AbsolutePosition
			local AbsoluteSize = ViewportFrame.AbsoluteSize
			local v289 = p21Position.X >= AbsolutePosition.X and p21Position.X <= AbsolutePosition.X + AbsoluteSize.X
			local v290 = p21Position.Y >= AbsolutePosition.Y and p21Position.Y <= AbsolutePosition.Y + AbsoluteSize.Y

			if not v289 or not v290 then
				return
			end

			u144 = true
			vector2 = Vector2.new(p21Position.X, p21Position.Y)
			n12 = 0
			zero4 = Vector2.zero
			zero = Vector2.zero
		end

		v140:Connect(UserInputService.InputBegan, function(p22, b12: boolean) -- line: 938
			-- upvalues: Players (copy), __onMobilePCInput (copy)
			local v293 = false

			if p22.UserInputType == Enum.UserInputType.Gamepad1 then
				if p22.KeyCode == Enum.KeyCode.ButtonR2 then
					v293 = true
				elseif p22.KeyCode == Enum.KeyCode.ButtonA then
					local Mouse = Players.LocalPlayer:GetMouse()

					__onMobilePCInput({
						Position = Vector3.new(Mouse.X, Mouse.Y, 0)
					}, true)

					return
				end
			end

			if v293 or p22.UserInputType == Enum.UserInputType.MouseButton1 or p22.UserInputType == Enum.UserInputType.Touch then
				__onMobilePCInput(p22, b12)
			end
		end)

		local t15 = {
			Enum.UserInputType.MouseMovement,
			Enum.UserInputType.Touch,
			Enum.UserInputType.Gamepad1
		}

		v140:Connect(UserInputService.InputChanged, function(p23, _: boolean) -- line: 961
			-- upvalues: u144 (ref), vector2 (ref), t15 (copy), zero4 (ref), n11 (ref), n12 (ref)
			if not u144 or not vector2 then
				return
			end

			if table.find(t15, p23.UserInputType) == nil then
				return
			end

			local zero5 = Vector2.zero
			local _ = Vector2.zero

			if p23.UserInputType == Enum.UserInputType.Gamepad1 then
				if p23.KeyCode ~= Enum.KeyCode.Thumbstick1 and p23.KeyCode ~= Enum.KeyCode.Thumbstick2 then
					return
				end

				if p23.KeyCode == Enum.KeyCode.Thumbstick1 then
					zero4 = Vector2.new(p23.Position.X, p23.Position.Y)

					return
				end
			else
				zero5 = Vector2.new(p23.Position.X, p23.Position.Y)
			end

			local v299 = zero5 - vector2

			vector2 = zero5

			local v300 = -v299.X * 0.6

			n11 += v300
			n12 = v300 * 60
		end)
		v140:Connect(UserInputService.InputChanged, function(p24, _: boolean) -- line: 996
			-- upvalues: zero (ref)
			if p24.KeyCode == Enum.KeyCode.Thumbstick2 then
				local vector2_3 = Vector2.new(p24.Position.X, p24.Position.Y)

				if vector2_3.Magnitude <= 0.1 then
					vector2_3 = Vector2.zero
				end

				zero = vector2_3

				return
			end
		end)
		v140:Connect(UserInputService.InputEnded, function(p25) -- line: 1008
			-- upvalues: u144 (ref), vector2 (ref), zero4 (ref), zero (ref)
			if (p25.UserInputType ~= Enum.UserInputType.Gamepad1 or p25.KeyCode ~= Enum.KeyCode.ButtonR2 and p25.KeyCode ~= Enum.KeyCode.ButtonA) and (p25.UserInputType ~= Enum.UserInputType.MouseButton1 and p25.UserInputType ~= Enum.UserInputType.Touch) then
				return
			end

			u144 = false
			vector2 = nil
			zero4 = Vector2.zero
			zero = Vector2.zero
		end)
	end

	local connection = nil

	connection = ViewportFrame.AncestryChanged:Connect(function(_, parent) -- line: 1026
		-- upvalues: ViewportFrame (copy), connection (ref), RigBuilder (copy), v130 (copy), v128 (copy)
		if parent and ViewportFrame:IsDescendantOf(game) then
			connection:Disconnect()
			RigBuilder.PlayIdleAnimation(v130, v128)
		end
	end)
	ViewportFrame.Destroying:Connect(function() -- line: 1033
		-- upvalues: v140 (copy), connection (ref)
		v140:Clean()

		if connection.Connected then
			connection:Disconnect()
		end
	end)

	return ViewportFrame
end
function t9.CloseOverlay(p27) -- line: 1043
	-- upvalues: t4 (copy), Device (copy), TweenService (copy), t9 (copy)
	assert(t4.ShopMenu, "ShopUtils:CloseOverlay() Shop menu does not exist, did you forget to setup the Shop module?")

	local Menu = t4.ShopMenu.Menu

	assert(Menu, "ShopUtils:OpenOverlay() Shop menu does not exist, did you forget to setup the Shop module?")

	local Overlay = Menu.Holder.Overlay
	local ViewportFrame = Overlay.Preview.BG:FindFirstChildOfClass("ViewportFrame")

	if ViewportFrame then
		ViewportFrame:Destroy()
	end

	p27.__overlaySelection = nil

	if Device:GetPlayerDevice() == "Mobile" then
		TweenService:Create(Menu.Holder, TweenInfo.new(0.5), {
			Position = UDim2.new(0.5, 0, 0.5, 0)
		}):Play()
	end

	t9:ClearConfirmationUI()
	Overlay.Visible = false
	p27.__isOverlayOpen = false
end
function t9.SetupOverlay(t16: {[any]: any}, p28, b15: boolean) -- line: 1066
	-- upvalues: t4 (copy), requireShopAsset (copy), Device (copy), TweenService (copy), t9 (copy)
	assert(typeof(p28) == "Instance" and (p28:IsA("ModuleScript") or p28:IsA("Folder")), "ShopUtils:OpenOverlay() requires assetLogic.")

	local u160 = p28:IsA("Folder") and p28:FindFirstChild("Config") or p28
	local Menu = t4.ShopMenu.Menu

	assert(Menu, "ShopUtils:OpenOverlay() Shop menu does not exist, did you forget to setup the Shop module?")

	local v162, v163 = requireShopAsset(u160)

	if not v162 then
		warn(`ShopUtils:OpenOverlay() Failed to require assetLogic: { u160 }. { v163 }`)

		return
	end

	if Device:GetPlayerDevice() == "Mobile" then
		TweenService:Create(Menu.Holder, TweenInfo.new(0.5), {
			Position = UDim2.new(0.45, 0, 0.5, 0)
		}):Play()
	end

	local Overlay = Menu.Holder.Overlay

	Overlay.Preview.Description.Text = v163.Description or "No description provided."
	Overlay.Preview.Credit.Text = v163.Credits or ""
	Overlay.Preview:FindFirstChild("Name").Text = v163.DisplayName or "No name provided."
	t16:ApplyPrice(Overlay.Preview, u160, v163)
	t9:ClearConfirmationUI()

	local ViewportFrame = Overlay.Preview.BG:FindFirstChildOfClass("ViewportFrame")

	if ViewportFrame then
		ViewportFrame:Destroy()
	end

	t16.__overlaySelection = nil

	if b15 then
		local v166 = t16:CreateViewport(v163, true, true)

		if not v166 then
			warn(`[{ script }]: Failed to create viewport for emote { v163.DisplayName }.`)

			return
		end

		Overlay.Preview.BG.Render.Visible = false
		v166.AnchorPoint = Vector2.new(0.5, 0.5)
		v166.Size = UDim2.fromScale(1, 0.965)
		v166.Position = UDim2.fromScale(0.485, 0.5)
		v166.Parent = Overlay.Preview.BG
	else
		Overlay.Preview.BG.Render.Visible = true
		Overlay.Preview.BG.Render.Image = v163.RenderImage or ""

		local t17 = {}

		t16.__overlaySelection = t17
		task.spawn(function() -- line: 1115
			-- upvalues: t16 (copy), u160 (ref), t17 (copy), Overlay (copy)
			local v307 = t16:CreateSkinViewport(u160, true)

			if not v307 then
				return
			end

			if t16.__overlaySelection ~= t17 then
				v307:Destroy()

				return
			end

			Overlay.Preview.BG.Render.Visible = false
			v307.AnchorPoint = Vector2.new(0.5, 0.5)
			v307.Size = UDim2.fromScale(1, 0.965)
			v307.Position = UDim2.fromScale(0.485, 0.5)
			v307.Parent = Overlay.Preview.BG
		end)
	end

	t16.__currentlySelected = u160
end

t9.__purchaseSignal = Signal.new()
t9.OnPurchased = t9.__purchaseSignal

function t9.OpenOverlay(t18: {[any]: any}, p29, b16: boolean) -- line: 1141
	-- upvalues: t4 (copy), TweenService (copy), Trove (copy), Sounds (copy), t9 (copy)
	if t18.__isOverlayOpen then
		t18:SetupOverlay(p29, b16)

		return
	end

	assert(typeof(p29) == "Instance" and (p29:IsA("ModuleScript") or p29:IsA("Folder")), "ShopUtils:OpenOverlay() requires assetLogic.")

	local Menu = t4.ShopMenu.Menu

	assert(Menu, "ShopUtils:OpenOverlay() Shop menu does not exist, did you forget to setup the Shop module?")
	t18.__isOverlayOpen = true

	local Overlay = Menu.Holder.Overlay

	Overlay.Position = UDim2.fromScale(1.2, 0.55)
	t18:SetupOverlay(p29, b16)
	Overlay.Visible = true
	TweenService:Create(Overlay, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Position = UDim2.fromScale(1.2, 0.5)
	}):Play()

	if t18.__buyTrove then
		t18.__buyTrove:Destroy()
	end

	t18.__buyTrove = Trove.new()
	t18.__buyTrove:Connect(Overlay.Preview.Buy.MouseEnter, function() -- line: 1173
		-- upvalues: TweenService (copy), Overlay (copy), Sounds (copy)
		TweenService:Create(Overlay.Preview.Buy, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.fromScale(0.625, 0.2)
		}):Play()
		Sounds:Play("hover")
	end)
	t18.__buyTrove:Connect(Overlay.Preview.Buy.MouseLeave, function() -- line: 1184
		-- upvalues: TweenService (copy), Overlay (copy), Sounds (copy)
		TweenService:Create(Overlay.Preview.Buy, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.fromScale(0.579, 0.083)
		}):Play()
		Sounds:Play("hoverEnd")
	end)
	t18.__buyTrove:Connect(Overlay.Preview.Buy.MouseButton1Down, function() -- line: 1195
		-- upvalues: Sounds (copy), t9 (copy), t18 (copy)
		Sounds:Play("click")
		t9:CreateConfirmationUI(t18.__currentlySelected)
	end)
end

local self = setmetatable({}, {
	__mode = "k"
})
local u37 = nil

local function scheduleSaleRefresh() -- line: 1205
	-- upvalues: u37 (ref), ShopSale (copy), self (copy), t9 (copy), scheduleSaleRefresh (copy)
	if u37 then
		return
	end

	local ServerTimeNow = workspace:GetServerTimeNow()
	local v174 = ShopSale.GetNextChangeTime(ServerTimeNow)

	if not v174 then
		return
	end

	u37 = task.delay(v174 - ServerTimeNow + 0.1, function() -- line: 1216
		-- upvalues: u37 (ref), self (copy), t9 (copy), scheduleSaleRefresh (copy)
		u37 = nil

		for v308, v309 in self do
			if v308.Parent then
				t9:ApplyPrice(v308, v309.asset, v309.config)
			else
				self[v308] = nil
			end
		end

		scheduleSaleRefresh()
	end)
end

function t9.ApplyPrice(t19: {[any]: any}, p30, p31, p32) -- line: 1231
	-- upvalues: ShopSale (copy), self (copy), scheduleSaleRefresh (copy)
	if p31:IsA("ModuleScript") and (p31.Name == "Config" and p31.Parent) then
		p31 = p31.Parent
	end

	local v179 = ShopSale.GetAssetPrice(p31, p32, workspace:GetServerTimeNow())
	local IsDiscounted = v179.IsDiscounted
	local Price = p30:FindFirstChild("Price")

	if Price then
		Price.Text = t19:FormatPrice(v179.FinalPrice)

		local DiscountGradient = Price:FindFirstChild("DiscountGradient")

		if DiscountGradient then
			DiscountGradient.Enabled = IsDiscounted
		end
	end

	local OldPrice = p30:FindFirstChild("OldPrice")

	if OldPrice then
		OldPrice.Visible = IsDiscounted
		OldPrice.Text = IsDiscounted and t19:FormatPrice(v179.OriginalPrice) or ""
	end

	local DiscountTag = p30:FindFirstChild("DiscountTag")

	if DiscountTag then
		DiscountTag.Visible = IsDiscounted
	end

	self[p30] = {
		asset = p31,
		config = p32
	}
	scheduleSaleRefresh()
end

local u39 = nil
local u40 = nil

function t4.OnTransitionState(b17: boolean) -- line: 1266
	-- upvalues: t4 (copy), u40 (ref), u39 (ref), Lighting (copy), Util (copy), LocalPlayer (copy), TweenService (copy), Debris (copy)
	local ShopMenu = t4.ShopMenu

	if b17 then
		if u40 then
			u40:Destroy()
			u40 = nil
		end

		if u39 then
			u39:Destroy()
			u39 = nil
		end

		ShopMenu.Menu.Position = UDim2.fromScale(0.5, 0.55)
		ShopMenu.Menu.Size = UDim2.fromScale(1, 1)
		ShopMenu.Menu.Visible = true

		local BlurEffect = Instance.new("BlurEffect")

		BlurEffect.Name = "ShopBlur"
		BlurEffect.Size = 0
		BlurEffect.Parent = Lighting
		u40 = BlurEffect
		u39 = Util:CreateFOVMultiplier(LocalPlayer, 1, "ShopZoom")
		TweenService:Create(BlurEffect, TweenInfo.new(0.225, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = 12
		}):Play()
		TweenService:Create(u39, TweenInfo.new(0.225, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Value = 0.85
		}):Play()
		TweenService:Create(ShopMenu.Menu, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Position = UDim2.fromScale(0.5, 0.5)
		}):Play()
	else
		ShopMenu.Menu.Visible = false

		local v188 = u39
		local v189 = u40

		if u39 then
			TweenService:Create(u39, TweenInfo.new(0.225, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Value = 1
			}):Play()
		end

		if v189 then
			TweenService:Create(v189, TweenInfo.new(0.225, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Size = 0
			}):Play()
		end

		if v189 then
			Debris:AddItem(v189, 0.225)
		end

		if v188 then
			Debris:AddItem(v188, 0.225)
		end
	end

	local v190 = `OnWindow{ not b17 and "Closed" or "Opened" }`
	local v191 = t4.TabLogic[t4.LastTab or ""]

	if v191 and v191[v190] then
		local ok, result = pcall(v191[v190], v191)

		if not ok then
			warn(`[{ script }]: Failed to run { v190 }() for tab: { t4.LastTab }, got: { result }`)
		end
	end
end
function t4.SwitchTab(_: {[any]: any}, s1: string) -- line: 1351
 if s1=="Robux"or s1=="Featured"then s1="Skins"end
	-- upvalues: t4 (copy), t1 (copy), transitionHighlightToState (copy), transitionToFrame (copy)
	if s1 == t4.LastTab then
		return
	end

	local Menu = t4.ShopMenu.Menu
	local TabButtons = Menu.Holder.TabButtons
	local v198 = t4.LastTab and TabButtons:FindFirstChild(t4.LastTab)
	local s1_2 = TabButtons:FindFirstChild(s1)

	if not s1_2 then
		warn(`[{ script }]: No tab found for: { s1 }`)

		return
	end

	if v198 then
		if t1[v198] then
			return
		end

		transitionHighlightToState(v198, false)
	end

	local s1_3 = Menu.Holder.Page:FindFirstChild(s1)
	local v201 = t4.LastTab and Menu.Holder.Page:FindFirstChild(t4.LastTab)
	local v202 = (v198 and v198.LayoutOrder or 0) > s1_2.LayoutOrder

	transitionToFrame(v201, s1_3, v202)
	transitionHighlightToState(s1_2, true)

	local v203 = t4.TabLogic[t4.LastTab]

	if v203 and v203.OnTabSwitched then
		local ok, result = pcall(v203.OnTabSwitched, v203)

		if not ok then
			warn(`[{ script }]: Failed to run OnTabSwitched() for tab: { t4.LastTab }, got: { result }`)
		end
	end

	local v206 = t4.TabLogic[s1]

	if v206 and v206.OnTabOpened then
		local ok, result = pcall(v206.OnTabOpened, v206)

		if not ok then
			warn(`[{ script }]: Failed to run OnTabOpened() for tab: { t4.LastTab }, got: { result }`)
		end
	end

	t4.LastTab = s1
end

local u41 = false

function t4.Start(_) -- line: 1401
	-- upvalues: u41 (ref), t4 (copy), CurrencyDisplay (copy), TweenService (copy), Sounds (copy), NotFound (copy), t9 (copy), setupViewportRig (copy)
	if u41 then
		return
	end

	u41 = true

	local EventHandlerClient = require(game.ReplicatedStorage.Modules.EventHandlerClient)

	if not EventHandlerClient:GetInfo() then
		EventHandlerClient.onEventInfoGiven:Wait()
		EventHandlerClient:GetInfo()
	end

	t4.ShopMenu = require(game.ReplicatedStorage.Initializer).PlayerSystems.SidebarHandler:CreateSidebarMenu("Shop", script.Shop)
	t4.Tabs = {}
	t4.TabLogic = {}

	local Menu = t4.ShopMenu.Menu

	os.clock()
	CurrencyDisplay.new("Money", "rbxassetid://132413181315189", false).Instance.Parent = Menu.Holder.Currency

	local Close = Menu.Holder.Close

	Close.MouseEnter:Connect(function() -- line: 1438
		-- upvalues: TweenService (copy), Close (copy), Sounds (copy)
		TweenService:Create(Close, TweenInfo.new(0.25), {
			Size = UDim2.fromScale(0.105, 0.105)
		}):Play()
		Sounds:Play("hover")
	end)
	Close.MouseLeave:Connect(function() -- line: 1450
		-- upvalues: TweenService (copy), Close (copy), Sounds (copy)
		TweenService:Create(Close, TweenInfo.new(0.25), {
			Size = UDim2.fromScale(0.071, 0.092)
		}):Play()
		Sounds:Play("hoverEnd")
	end)
	Close.MouseButton1Down:Connect(function() -- line: 1462
		-- upvalues: t4 (copy), Sounds (copy)
		t4.ShopMenu:ToggleMenu(false)
		Sounds:Play("click")
	end)
	Menu.Holder.Page:ClearAllChildren()

	local function isTabRejected(b18: boolean, s2: string, p34, s3: string?) -- line: 1470
		-- upvalues: NotFound (copy), Menu (copy), t4 (copy)
		if b18 then
			return nil
		end

		warn(`[{ script }]: Tab '{ s2 }' rejected during '{ s3 or "unknown" }' stage.`)

		if p34 then
			warn(`[{ script }]: Response: { p34 }`)
		end

		local clone = NotFound:Clone()

		clone.Name = s2
		clone.Parent = Menu.Holder.Page
		clone.Position = UDim2.fromScale(1, 0)
		t4.Tabs[s2] = clone

		return clone
	end

	for _, child in Menu.Holder.TabButtons:GetChildren() do
		if child:IsA("TextButton") then
            child.Size=UDim2.fromScale(0.475,0.732)
			child.MouseEnter:Connect(function() -- line: 1496
				-- upvalues: TweenService (copy), child (copy), Sounds (copy)
				TweenService:Create(child, TweenInfo.new(0.25), {
					Size = UDim2.fromScale(0.5, 0.75)
				}):Play()
				Sounds:Play("hover")
			end)
			child.MouseLeave:Connect(function() -- line: 1508
				-- upvalues: TweenService (copy), child (copy), Sounds (copy)
				TweenService:Create(child, TweenInfo.new(0.25), {
					Size = UDim2.fromScale(0.475, 0.732)
				}):Play()
				Sounds:Play("hoverEnd")
			end)
			child.MouseButton1Down:Connect(function() -- line: 1520
				-- upvalues: t4 (copy), child (copy), Sounds (copy)
				t4:SwitchTab(child.Name)
				Sounds:Play("click")
			end)

			local childName = child.Name
			local childName2 = script.Tabs:FindFirstChild(childName)

			if not isTabRejected(childName2 ~= nil, childName, "no ModuleScript found", "lookup") then
				local ok, result = xpcall(function() -- line: 1531
					-- upvalues: childName2 (copy)
					return require(childName2)
				end, debug.traceback)

				if not isTabRejected(ok, childName, result, "require") then
					local ok3, result3 = xpcall(function() -- line: 1536
						-- upvalues: result (copy), t9 (copy)
						return result.new(t9)
					end, debug.traceback)

					if not isTabRejected(ok3, childName, result3, "new()") then
						result3.Name = childName
						result3.Parent = Menu.Holder.Page
						result3.Position = UDim2.fromScale(1, 0)
						t4.TabLogic[childName] = result
						t4.Tabs[childName] = result3
					end
				end
			end
		end
	end

	setupViewportRig()
	t9.OnPurchased:Connect(function() -- line: 1551
		-- upvalues: t9 (copy)
		t9:ClearConfirmationUI()
	end)
	t4:SwitchTab("Skins")
end

return t4
]========]
end
do local object=game
object=object:FindFirstChild([========[
ReplicatedStorage]========])or child(object,[========[
ReplicatedStorage]========],[========[
ModuleScript]========])
object=object:FindFirstChild([========[
Systems]========])or child(object,[========[
Systems]========],[========[
ModuleScript]========])
object=object:FindFirstChild([========[
Player]========])or child(object,[========[
Player]========],[========[
ModuleScript]========])
object=object:FindFirstChild([========[
UI]========])or child(object,[========[
UI]========],[========[
ModuleScript]========])
object=object:FindFirstChild([========[
Menus]========])or child(object,[========[
Menus]========],[========[
ModuleScript]========])
object=object:FindFirstChild([========[
UpdateLog]========])or child(object,[========[
UpdateLog]========],[========[
ModuleScript]========])
object.Source=[========[
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local _ = LocalPlayer.PlayerGui
local DataHandler = require(ReplicatedStorage.Modules.DataHandler)
local Network = require(ReplicatedStorage.Modules.Network)
local Sounds = require(ReplicatedStorage.Modules.Sounds)
local Util = require(ReplicatedStorage.Modules.Util)
local DiscordMarkdown = require(script.DiscordMarkdown)
local UpdatelogPresets = ReplicatedStorage.Assets.UI.UpdatelogPresets
local Changelogs = ReplicatedStorage.Assets.Changelogs
local __createComponent = nil
local t4 = {
	TextTemplate = function(t1: {[any]: any}, p1) -- line: 26
		p1.Text = t1.Content
	end,
	ImageTemplate = function(t2: {[any]: any}, p2) -- line: 30
		p2.Image = t2.Content
		p2.Subtitle.Text = t2.Text
	end,
	ItemsTemplate = function(t3: {[any]: any}, p3) -- line: 35
		-- upvalues: __createComponent (ref)
		for i, v in ipairs(t3.Content) do
			local v35 = __createComponent(v, p3)

			if v35 then
				v35.LayoutOrder = i
				v35.Parent = p3
			end
		end
	end
}
local LatestLog = Changelogs:GetAttribute("LatestLog")
local TextTitle = nil
local t5 = {}

local function __toYYMMDD(p4) -- line: 53
	local v37, v38, v39 = p4:match("(%d+)-(%d+)-(%d+)")

	return string.format("%02d%02d%02d", tonumber(v39), tonumber(v37), (tonumber(v38)))
end
local function __generateLegacyLayout(t6: {[any]: any}, p5) -- line: 58
	-- upvalues: UpdatelogPresets (copy)
	local n1 = 0

	for i = 1, #t6.Notes do
		local v44 = t6.Notes[i]
		local clone = UpdatelogPresets.Components.Header:Clone()

		clone.Text = v44.Header
		clone.LayoutOrder = n1
		clone.Parent = p5

		local clone2 = UpdatelogPresets.Components.Seperator:Clone()

		clone2.LayoutOrder = n1 + 1
		clone2.Parent = p5

		local clone3 = UpdatelogPresets.Components.TextPreset:Clone()

		clone3.Main.Text = v44.Body
		clone3.Size = v44.NoteSize or UDim2.fromScale(0.9, 0.25)
		clone3.LayoutOrder = n1 + 2
		clone3.Parent = p5
		n1 += 3
	end
end

function __createComponent(t7: {[any]: any}, p6) -- line: 82
	-- upvalues: t4 (copy)
	local t7Type = script.Presets.Components:FindFirstChild(t7.Type)

	if not t7Type then
		warn(`[{ script }]: Invalid component type: { t7.Type }`)

		return nil
	end

	local clone = t7Type:Clone()
	local v52 = t4[t7.Type]

	if v52 then
		local ok, result = pcall(v52, t7, clone)

		if not ok then
			warn(`[{ script }]: Failed to run callback for component: { t7.Type }, { debug.traceback(result) }`)
		end
	end

	for k, v in next, t7.Style or {} do
		clone[k] = v
	end

	clone.Parent = p6

	return clone
end

local function __generateLayout(t8: {[any]: any}, p7) -- line: 107
	-- upvalues: __createComponent (ref)
	local clone = script.Presets.UpdateDisplayTemplate:Clone()
	local n2 = 0

	local function __increment() -- line: 111
		-- upvalues: n2 (ref)
		n2 += 1
	end

	for _, v in ipairs(t8) do
		local clone4 = script.Presets.Components.SubheaderTemplate:Clone()

		clone4.Header.Text = v.Header
		clone4.LayoutOrder = n2
		clone4.Parent = clone
		n2 += 1

		for _, v2 in ipairs(v.Content) do
			local v67 = __createComponent(v2, clone)

			if v67 then
				v67.LayoutOrder = n2
				n2 += 1
			end
		end
	end

	clone.Parent = p7
end
local function __switchPage(p8, t9: {[any]: any}) -- line: 139
	-- upvalues: DiscordMarkdown (copy), __generateLegacyLayout (copy), __generateLayout (copy)
	assert(typeof(t9) == "table", "meta is not a table!")
 if not t9.Markdown and t9.Notes and t9.Notes[1]and t9.Notes[1].Body then t9.IsLegacy=true end

	for _, v in next, p8.Holder.List:GetChildren() do
		if v:IsA("Frame") or v:IsA("TextLabel") then
			v:Destroy()
		end
	end

	local clone = script.Presets.Loading:Clone()

	clone.Parent = p8.Holder

	local clone5 = script.Presets.Components.HeaderTemplate:Clone()

	clone5.Background.Image = t9.TitleMeta.Image.Backdrop or t9.TitleMeta.Image.Large or t9.TitleMeta.Image.Title or ""
	clone5.Header.Text = t9.TitleMeta.Text.Title or "N/A"
	clone5.Description.Text = t9.TitleMeta.Text.Description or (t9.TitleMeta.Text.Date or "None Provided")
	clone5.LayoutOrder = -10
	clone5.Parent = p8.Holder.List

	if t9.Markdown then
		DiscordMarkdown.Render(t9.Markdown, p8.Holder.List)
	elseif t9.IsLegacy then
		__generateLegacyLayout(t9, p8.Holder.List)
	else
		__generateLayout(t9.Notes, p8.Holder.List)
	end

	clone:Destroy()
end

local t10 = {
	Menu = nil
}
local u25 = nil
local u26 = nil

function t10.OnTransitionState(b1: boolean) -- line: 175
	-- upvalues: t10 (copy), u26 (ref), u25 (ref), Lighting (copy), Util (copy), LocalPlayer (copy), TweenService (copy), Debris (copy)
	local Menu = t10.UpdateLogMenu.Menu

	if b1 then
		if u26 then
			u26:Destroy()
			u26 = nil
		end

		if u25 then
			u25:Destroy()
			u25 = nil
		end

		Menu.Position = UDim2.fromScale(0.5, 0.55)
		Menu.Size = UDim2.fromScale(1, 1.15)
		Menu.Visible = true

		local BlurEffect = Instance.new("BlurEffect")

		BlurEffect.Name = "ShopBlur"
		BlurEffect.Size = 0
		BlurEffect.Parent = Lighting
		u26 = BlurEffect
		u25 = Util:CreateFOVMultiplier(LocalPlayer, 1, "ShopZoom")
		TweenService:Create(BlurEffect, TweenInfo.new(0.225, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = 12
		}):Play()
		TweenService:Create(u25, TweenInfo.new(0.225, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Value = 0.85
		}):Play()
		TweenService:Create(Menu, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Position = UDim2.fromScale(0.5, 0.5)
		}):Play()

		return
	end

	Menu.Visible = false

	local v77 = u25
	local v78 = u26

	if u25 then
		TweenService:Create(u25, TweenInfo.new(0.225, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Value = 1
		}):Play()
	end

	if v78 then
		TweenService:Create(v78, TweenInfo.new(0.225, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = 0
		}):Play()
	end

	if v78 then
		Debris:AddItem(v78, 0.225)
	end

	if v77 then
		Debris:AddItem(v77, 0.225)
	end
end
function t10.Start(_) -- line: 251
	-- upvalues: ReplicatedStorage (copy), t10 (copy), DataHandler (copy), LatestLog (copy), TweenService (copy), Sounds (copy), Network (copy), Changelogs (copy), TextTitle (ref), __switchPage (copy), t5 (copy)
	task.spawn(function() -- line: 252
		-- upvalues: ReplicatedStorage (copy), t10 (copy), DataHandler (copy), LatestLog (copy), TweenService (copy), Sounds (copy), Network (copy), Changelogs (copy), TextTitle (ref), __switchPage (copy), t5 (copy)
		t10.UpdateLogMenu = require(ReplicatedStorage.Initializer).PlayerSystems.SidebarHandler:CreateSidebarMenu("UpdateLog", script.UpdateScreen)


		local Menu = t10.UpdateLogMenu.Menu
		local Close = Menu.Holder.Close

		Close.MouseEnter:Connect(function() -- line: 264
			-- upvalues: TweenService (copy), Close (copy), Sounds (copy)
			TweenService:Create(Close, TweenInfo.new(0.25), {
				Size = UDim2.fromScale(0.105, 0.105)
			}):Play()
			Sounds:Play("hover")
		end)
		Close.MouseLeave:Connect(function() -- line: 276
			-- upvalues: TweenService (copy), Close (copy), Sounds (copy)
			TweenService:Create(Close, TweenInfo.new(0.25), {
				Size = UDim2.fromScale(0.074, 0.095)
			}):Play()
			Sounds:Play("hoverEnd")
		end)
		Close.MouseButton1Down:Connect(function() -- line: 288
			-- upvalues: t10 (copy), Network (copy), Sounds (copy)
			t10.UpdateLogMenu:ToggleMenu(false)
			Network:FireServerConnection("UpdateLogToLatest", "REMOTE_EVENT")
			Sounds:Play("click")
		end)

		for _, v in next, Changelogs:GetChildren() do
			local ok, result = pcall(function() -- line: 295
				-- upvalues: v (copy)
				return require(v)
			end)

			if not ok then
				warn(`Failed to load changelog { v.Name }: { result }`)
			else
				local clone = script.Presets.UpdateTemplate:Clone()

				clone.Name = result.TitleMeta.Text.Title
				clone.UpdateName.Text = result.TitleMeta.Text.Title or "N/A"
				clone.Description.Text = result.TitleMeta.Text.Description or (result.TitleMeta.Text.Date or "None Provided")
				clone.Render.Image = result.TitleMeta.Image.Backdrop or result.TitleMeta.Image.Small or result.TitleMeta.Image.Title or ""

				local v87, v88, v89 = result.TitleMeta.Text.Date:match("(%d+)-(%d+)-(%d+)")

				clone.LayoutOrder = -string.format("%02d%02d%02d", tonumber(v89), tonumber(v87), (tonumber(v88)))
				clone.Parent = Menu.List.Updates
				clone.MouseEnter:Connect(function() -- line: 312
					-- upvalues: Sounds (copy)
					Sounds:Play("hover")
				end)
				clone.MouseLeave:Connect(function() -- line: 316
					-- upvalues: Sounds (copy)
					Sounds:Play("hoverEnd")
				end)
				clone.MouseButton1Down:Connect(function() -- line: 320
					-- upvalues: TextTitle (ref), result (copy), __switchPage (copy), Menu (copy), Sounds (copy)
					if TextTitle == result.TitleMeta.Text.Title then
						return
					end

					TextTitle = result.TitleMeta.Text.Title
					__switchPage(Menu, result)
					Sounds:Play("click")
				end)
				t5[v.Name] = result
			end
		end

		if t5[LatestLog]then __switchPage(Menu, t5[LatestLog])end
        if t5[LatestLog]and DataHandler:Get().Misc.LastSeenLog.Value ~= LatestLog then t10.UpdateLogMenu:ToggleMenu(true)end
	end)
end

return t10
]========]
end
do local object=game
object=object:FindFirstChild([========[
ReplicatedStorage]========])or child(object,[========[
ReplicatedStorage]========],[========[
ModuleScript]========])
object=object:FindFirstChild([========[
Modules]========])or child(object,[========[
Modules]========],[========[
ModuleScript]========])
object=object:FindFirstChild([========[
PlayerList]========])or child(object,[========[
PlayerList]========],[========[
ModuleScript]========])
object.Source=[========[
local t1 = {
	_players = {},
	DisplayedStats = {
		"Money",
		"KillerChance"
	},
	ListEnabled = true
}
local SocialService = game:GetService("SocialService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

game:GetService("TextChatService")

local v6 = RunService:IsStudio()
local clamp = math.clamp
local LocalPlayer = Players.LocalPlayer

require(game.ReplicatedStorage.Modules.Actors)

local DataHandler = require(game.ReplicatedStorage.Modules.DataHandler)
local Util = require(game.ReplicatedStorage.Modules.Util)
local Sounds = require(game.ReplicatedStorage.Modules.Sounds)
local Network = require(game.ReplicatedStorage.Modules.Network)
local t2 = {
	KillerChance = "Malice",
	RbxSpent = "R$ Spent"
}
local t3 = {
	PC = "rbxassetid://135066638879377",
	Mobile = "rbxassetid://89227325753198",
	Console = "rbxassetid://118447973769044",
	Unknown = "rbxassetid://94182197303121",
	NoChat = "rbxassetid://8509669675"
}

local function getPath(p1, s1: string, n1: number?) -- line: 51
	assert(typeof(p1) == "Instance")
	assert(typeof(s1) == "string")

	if s1 == "" then
		return p1
	end

	for _, v23 in (string.split(s1, "/")) do
		if typeof(n1) ~= "number" then
			p1 = p1:FindFirstChild(v23)

			if p1 ~= nil then
				continue
			end

			return
		end

		p1 = p1:WaitForChild(v23, n1)

		if p1 == nil then
			return
		end
	end

	return p1
end

function t1.GetPlayerListUI(p2) -- line: 76
	if not p2.PlayerList then
		repeat
			task.wait()
		until p2.PlayerList
	end

	return p2.PlayerList
end

local thread = nil
local u17 = true

function t1.TogglePlayerList(_, p4, p5) -- line: 85
	-- upvalues: t1 (copy), Sounds (copy), thread (ref), u17 (ref)
	if p5 then
		t1.ListEnabled = p4
	elseif not t1.ListEnabled then
		return
	end

	if not p5 then
		Sounds:Play("switch")
	end

	local PlayerListUI = t1:GetPlayerListUI()

	if thread then
		task.cancel(thread)
	end

	if p4 then
		u17 = true
		PlayerListUI.Close.Text = ">"
		PlayerListUI.Close.Visible = true
		PlayerListUI.Contents.Visible = true
		PlayerListUI.Background.Visible = true
		PlayerListUI.FriendBoost.Visible = true
		game.TweenService:Create(PlayerListUI, TweenInfo.new(0.15), {
			AnchorPoint = script.PlayerListHolder.AnchorPoint,
			Position = script.PlayerListHolder.Position
		}):Play()

		return
	end

	u17 = false
	PlayerListUI.Close.Text = "<"
	game.TweenService:Create(PlayerListUI, TweenInfo.new(0.15), {
		AnchorPoint = Vector2.new(),
		Position = UDim2.new(1, 0, 0, script.PlayerListHolder.Position.Y.Offset)
	}):Play()
	thread = task.delay(0.15, function() -- line: 116
		-- upvalues: p5 (copy), PlayerListUI (copy)
		if p5 then
			PlayerListUI.Close.Visible = false
		end

		PlayerListUI.Contents.Visible = false
		PlayerListUI.Background.Visible = false
		PlayerListUI.FriendBoost.Visible = false
	end)
end

local t4 = {}

function t1.ShowPlayerStats(t5: {[any]: any}, p6) -- line: 127
	-- upvalues: t4 (copy), Sounds (copy), t1 (copy), t3 (copy), DataHandler (copy), Util (copy), LocalPlayer (copy)
	for _, v in pairs(t4) do
		v:Disconnect()
	end

	table.clear(t4)

	if t5.__currentlyDisplayedStats and t5.__currentlyDisplayedStats.Parent then
		if tostring(t5.__currentlyDisplayedStats) == tostring(p6) then
			game.TweenService:Create(t5.__currentlyDisplayedStats, TweenInfo.new(0.15), {
				Size = UDim2.fromScale()
			}):Play()
			game.Debris:AddItem(t5.__currentlyDisplayedStats, 0.15)
			t5.__currentlyDisplayedStats = nil

			return
		end

		t5.__currentlyDisplayedStats:Destroy()
	end

	local clone = script.PlayerStats:Clone()

	clone.Name = tostring(p6)
	clone.Close.MouseEnter:Connect(function() -- line: 150
		-- upvalues: Sounds (copy)
		Sounds:Play("hover")
	end)
	clone.Close.MouseLeave:Connect(function() -- line: 151
		-- upvalues: Sounds (copy)
		Sounds:Play("hoverEnd")
	end)
	clone.Close.MouseButton1Click:Connect(function() -- line: 152
		-- upvalues: Sounds (copy), t1 (copy), p6 (copy)
		Sounds:Play("select")
		t1:ShowPlayerStats(p6)
	end)

	local v34 = `@{ p6.Name }`
	local v35 = p6.DisplayName ~= p6.Name and (p6.DisplayName ~= "" and p6.DisplayName)

	clone.BasicInfo.PlayerName.Text = v35 or v34
	clone.BasicInfo.PlayerUsername.Text = v34
	clone.BasicInfo.PlayerUsername.Visible = v35
	task.spawn(function() -- line: 164
		-- upvalues: p6 (copy), clone (copy)
		local UserId = p6.UserId
		local UserThumbnailAsync = game.Players:GetUserThumbnailAsync(UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)

		clone.PlayerIconHolder.Player.Image = UserThumbnailAsync
	end)

	local function updatePlayerDevice() -- line: 171
		-- upvalues: t3 (copy), p6 (copy), clone (copy)
		local v93 = t3[p6:GetAttribute("Device")] or t3.Unknown

		clone.PlayerIconHolder.Device.Image = v93
	end

	local v37 = t3[p6:GetAttribute("Device")] or t3.Unknown

	clone.PlayerIconHolder.Device.Image = v37
	table.insert(t4, p6:GetAttributeChangedSignal("Device"):Connect(updatePlayerDevice))

	local v38 = DataHandler:Get(p6)
	local v39 = v38 and v38:FindFirstChild("Stats")
	local v40 = v38 and v38:FindFirstChild("Equipped")

	if v39 and v40 then
		local General = v39:FindFirstChild("General")
		local v42 = General and General:FindFirstChild("TimePlayed")

		if v42 then
			local function updateTimePlayed() -- line: 256
				-- upvalues: Util (copy), p6 (copy), clone (copy), v42 (copy)
				local SettingValue = Util:GetSettingValue("HidePlaytime", p6)

				clone.TimePlayed.Text = `Time Played: { (if not SettingValue then Util:FormatTime(v42.Value, "Clock") else "<font color=\"rgb(125,125,125)\"><i>(Hidden)</i></font>") }`
			end

			local SettingValue = Util:GetSettingValue("HidePlaytime", p6)

			clone.TimePlayed.Text = `Time Played: { (if not SettingValue then Util:FormatTime(v42.Value, "Clock") else "<font color=\"rgb(125,125,125)\"><i>(Hidden)</i></font>") }`
			table.insert(t4, v42:GetPropertyChangedSignal("Value"):Connect(updateTimePlayed))
		end

		for _, v in pairs({
			"Killer",
			"Survivor"
		}) do
			local v47 = v39 and v39:FindFirstChild(`{ v }Stats`)
			local v48 = v47 and v47:FindFirstChild(`{ v }Kills`)

			if v48 then
				local SettingValue = Util:GetSettingValue(`Hide{ v }Wins`, p6)
				local v50 = clone.WinInfo:FindFirstChild(`{ v }Wins`)

				v50.MouseEnter:Connect(function() -- line: 275
					-- upvalues: Util (copy), v (copy), SettingValue (copy)
					Util:CreateTooltip(`{ v } Kills{ not SettingValue and "" or " <font color=\"rgb(125,125,125)\"><i>(Hidden)</i></font>" }`)
				end)
				v50.MouseLeave:Connect(function() -- line: 276
					-- upvalues: Util (copy)
					Util:CreateTooltip()
				end)

				local function setScore() -- line: 279
					-- upvalues: v50 (copy), SettingValue (copy), v48 (copy)
					v50.Wins.Text = if not SettingValue then v48.Value else "<font color=\"rgb(125,125,125)\"><i>(Hidden)</i></font>"
				end

				v50.Wins.Text = if not SettingValue then v48.Value else "<font color=\"rgb(125,125,125)\"><i>(Hidden)</i></font>"
				table.insert(t4, v48:GetPropertyChangedSignal("Value"):Connect(setScore))
			end

			if v40 then
				local t6 = {}

				local function setEquippedIcon() -- line: 292
					-- upvalues: p6 (copy), v (copy), t6 (ref), clone (copy), Util (copy)
					local v95, v96 = require(game.ReplicatedStorage.Modules.Actors):GetEquippedActorInfo(p6, v)
					local v97 = game.ReplicatedStorage.Assets:FindFirstChild(`{ v }s`):FindFirstChild(v95)
					local v98 = v97 and (v97:FindFirstChild("Config") and require(v97.Config))
					local v99 = game.ReplicatedStorage.Assets.Skins:FindFirstChild(`{ v }s`):FindFirstChild(v95)
					local v100 = v99 and v99:FindFirstChild(v96)
					local v101 = v100 and (v100:FindFirstChild("Config") and require(v100.Config))

					if v98 then
						for _, v2 in pairs(t6) do
							v2:Disconnect()
						end

						table.clear(t6)

						local v3 = clone.BasicInfo.EquippedCharacters:FindFirstChild(v)
						local u105 = `Equipped { v }: <i>{ v98.DisplayName or tostring(v97) }</i>`

						if v101 then
							u105 = `{ u105 }\nEquipped Skin: <i>{ v101.DisplayName or tostring(v100) }</i>`
						end

						v3.Image = v101 and v101.RenderImage or (v98.RenderImage or "rbxassetid://13373279056")
						t6 = {
							v3.MouseEnter:Connect(function() -- line: 316
								-- upvalues: Util (copy), u105 (ref)
								Util:CreateTooltip(u105)
							end),
							v3.MouseLeave:Connect(function() -- line: 317
								-- upvalues: Util (copy)
								Util:CreateTooltip()
							end)
						}
					end
				end

				local v4 = v40:FindFirstChild(v)
				local v5 = v40.Skins:FindFirstChild(v)

				setEquippedIcon()

				if v4 then
					table.insert(t4, v4:GetPropertyChangedSignal("Value"):Connect(setEquippedIcon))
				end

				if v5 then
					table.insert(t4, v5:GetPropertyChangedSignal("Value"):Connect(setEquippedIcon))
				end
			end
		end
	end

	if not t5.__currentlyDisplayedStats then
		clone.Size = UDim2.new()
		game.TweenService:Create(clone, TweenInfo.new(0.15), {
			Size = script.PlayerStats.Size
		}):Play()
	end

	clone.Parent = LocalPlayer.PlayerGui.TemporaryUI
	t5.__currentlyDisplayedStats = clone
	clone.AncestryChanged:Connect(function(_, parent) -- line: 345
		-- upvalues: Util (copy), t4 (copy)
		if not parent then
			Util:CreateTooltip()

			for _, v in pairs(t4) do
				v:Disconnect()
			end

			table.clear(t4)
		end
	end)
end
function t1.CreatePlayerInList(_: {[any]: any}, p8) -- line: 356
	-- upvalues: t1 (copy), Util (copy), Network (copy), v6 (copy)
	if not p8 then
		return
	end

	local PlayerListUI = t1:GetPlayerListUI()
	local v59 = PlayerListUI.Contents.Players:FindFirstChild((tostring(p8)))

	if v59 then
		v59:Destroy()
	end

	local clone = script.PlayerInfoContainer:Clone()

	clone.Name = tostring(p8)

	local p8Name = p8.Name
	local v62 = p8.DisplayName ~= p8.Name and (p8.DisplayName ~= "" and p8.DisplayName)

	local baseName = v62 or p8Name
	clone.PlayerInfo.Username.Text = baseName
	clone.PlayerInfo.Username.RichText = true

	local function updateAFKStatus()
		local afkValue = Util:GetSettingValue("AFK", p8)
		local isAFK = afkValue == true or (typeof(afkValue) == "number" and afkValue > 0)
		clone.PlayerInfo.Username.Text = isAFK and `{baseName} <font color="#B82500">[AFK]</font>` or baseName
	end

	task.spawn(function()
		local playerData = DataHandler:Get(p8)
		if not playerData then return end
		local settings = playerData:FindFirstChild("Settings")
		if not settings then return end
		local afkSetting = settings:FindFirstChild("AFK", true)
		if afkSetting then
			afkSetting:GetPropertyChangedSignal("Value"):Connect(updateAFKStatus)
		end
		updateAFKStatus()
	end)

	clone.ShowStats.MouseButton1Click:Connect(function() -- line: 375
		-- upvalues: t1 (copy), p8 (copy)
		t1:ShowPlayerStats(p8)
	end)

	if t1.DisplayedStats and t1.DisplayedStats[1] then
		local leaderstats = p8:WaitForChild("leaderstats", 30)

		if not leaderstats or not p8.Parent then
			return
		end

		for _, child in pairs(leaderstats:GetChildren()) do
			local clone2 = clone.PlayerInfo.Username:Clone()

			clone2.Name = child and child.Name
			clone2.Size = UDim2.fromScale(0.3, 1)
			clone2.LayoutOrder = table.find(t1.DisplayedStats, child.Name)
			clone2.TextXAlignment = Enum.TextXAlignment.Center
			clone2.Parent = clone.PlayerInfo

			local function updateStat() -- line: 396
				-- upvalues: child (copy), clone2 (copy), Util (copy)
				local v110 = child and child.Value or "?"

				if tonumber(v110) then
					clone2.TextColor3 = v110 > 0 and Color3.new(1, 1, 1) or Color3.new(1, 0, 0)
					v110 = Util:ConvertToAbbreviation(v110)
				end

				if v110.Name == "Money" then
					v110 = `${ v110 }`
				end

				clone2.Text = tostring(v110)
			end

			updateStat()

			if child then
				child:GetPropertyChangedSignal("Value"):Connect(updateStat)
			end
		end
	end

	local v68 = Network:FireServerConnection("ReturnCanChat", "REMOTE_FUNCTION", p8)

	if v6 or not v68 then
		clone.NoChat.Visible = true
		clone.NoChat.MouseEnter:Connect(function() -- line: 422
			-- upvalues: Util (copy)
			Util:CreateTooltip("You cannot communicate with this player.")
		end)
		clone.NoChat.MouseLeave:Connect(function() -- line: 425
			-- upvalues: Util (copy)
			Util:CreateTooltip()
		end)
	end

	clone.Parent = PlayerListUI.Contents.Players
	t1:__UpdateListSize()
end
function t1.RemovePlayerFromList(_: {[any]: any}, p9) -- line: 437
	-- upvalues: t1 (copy)
	local v71 = t1:GetPlayerListUI().Contents.Players:FindFirstChild((tostring(p9)))

	if v71 then
		v71:Destroy()
	end

	t1:__UpdateListSize()
end
function t1.__UpdateListSize(_) -- line: 450
	-- upvalues: t1 (copy)
	local PlayerListUI = t1:GetPlayerListUI()
	local UIListLayout = PlayerListUI.Contents.Players.UIListLayout
	local v75 = UIListLayout.AbsoluteContentSize.Y + UIListLayout.Padding.Offset

	PlayerListUI.Background.Size = UDim2.fromScale(1, (math.clamp(0.05 + 30 / PlayerListUI.AbsoluteSize.Y + v75 / PlayerListUI.AbsoluteSize.Y, 0, 1)))
	PlayerListUI.FriendBoost.Position = UDim2.fromScale(0, (math.clamp(0.05 + 30 / PlayerListUI.AbsoluteSize.Y + v75 / PlayerListUI.AbsoluteSize.Y, 0, 1)))
end
function t1.Start(p11) -- line: 460
	-- upvalues: LocalPlayer (copy), t1 (copy), t2 (copy), SocialService (copy), clamp (copy), Util (copy), u17 (ref), Sounds (copy)
	if game["Run Service"]:IsServer() then
		return
	end

	local clone = script.PlayerListHolder:Clone()
	local Contents = clone.Contents

	clone.Parent = LocalPlayer.PlayerGui:WaitForChild("MainUI")
	Contents:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 521
		-- upvalues: t1 (copy)
		t1:__UpdateListSize()
	end)

	for k, v in pairs(t1.DisplayedStats) do
		local clone3 = Contents.InfoTypes.Players:Clone()

		clone3.Name = v
		clone3.Text = t2[v] or v:gsub("(%l)(%u)", "%1 %2")
		clone3.Size = UDim2.fromScale(0.3, 1)
		clone3.LayoutOrder = k + 1
		clone3.TextXAlignment = Enum.TextXAlignment.Center
		clone3.Parent = Contents.InfoTypes
	end

	local _ = {
		JOINING = true,
		LEAVING = false
	}
	local ExperienceInviteOptions = Instance.new("ExperienceInviteOptions")

	ExperienceInviteOptions.PromptMessage = `Invite Friends, get { 10 }% more EXP per friend! (caps at { 20 }%).`

	local function __canSendInvite(p12) -- line: 547
		-- upvalues: SocialService (copy)
		local ok, result = pcall(function() -- line: 548
			-- upvalues: SocialService (copy), p12 (copy)
			return SocialService:CanSendGameInviteAsync(p12)
		end)

		return ok and result
	end

	local Button = clone.FriendBoost.Button

	Button.MouseButton1Down:Connect(function() -- line: 556
		-- upvalues: LocalPlayer (copy), SocialService (copy), ExperienceInviteOptions (copy)
		local v114 = LocalPlayer
		local ok, result = pcall(function() -- line: 548
			-- upvalues: SocialService (copy), v114 (copy)
			return SocialService:CanSendGameInviteAsync(v114)
		end)

		if ok and result then
			SocialService:PromptGameInvite(LocalPlayer, ExperienceInviteOptions)
		end
	end)

	local n2 = 0

	local function __setBoostDisplay(p13, b1: boolean) -- line: 564
		-- upvalues: LocalPlayer (copy), n2 (ref), clamp (copy), Button (copy)
		local ok, result = pcall(function() -- line: 566
			-- upvalues: LocalPlayer (copy), p13 (copy)
			return LocalPlayer:IsFriendsWith(p13.UserId)
		end)

		if ok and result then
			n2 = clamp(n2 + 10 * (not b1 and -1 or 1), 0, 20)
		end

		local v121 = `Invite Friends (+{ n2 }% EXP)`

		if v121 ~= Button.Text then
			Button.Text = v121
		end
	end

	Util.OnPlayerAdded(function(p14) -- line: 587
		-- upvalues: LocalPlayer (copy), n2 (ref), clamp (copy), Button (copy), t1 (copy)
		if p14 ~= LocalPlayer then
			local ok, result = pcall(function() -- line: 566
				-- upvalues: LocalPlayer (copy), p14 (copy)
				return LocalPlayer:IsFriendsWith(p14.UserId)
			end)

			if ok and result then
				n2 = clamp(n2 + 10, 0, 20)
			end

			local v125 = `Invite Friends (+{ n2 }% EXP)`

			if v125 ~= Button.Text then
				Button.Text = v125
			end
		end

		t1:CreatePlayerInList(p14)
	end)
	game.Players.PlayerRemoving:Connect(function(player) -- line: 596
		-- upvalues: LocalPlayer (copy), n2 (ref), clamp (copy), Button (copy), t1 (copy)
		if player ~= LocalPlayer then
			local ok, result = pcall(function() -- line: 566
				-- upvalues: LocalPlayer (copy), player (copy)
				return LocalPlayer:IsFriendsWith(player.UserId)
			end)

			if ok and result then
				n2 = clamp(n2 + -10, 0, 20)
			end

			local v129 = `Invite Friends (+{ n2 }% EXP)`

			if v129 ~= Button.Text then
				Button.Text = v129
			end
		end

		t1:RemovePlayerFromList(player)
	end)
	clone.Close.MouseButton1Click:Connect(function() -- line: 604
		-- upvalues: t1 (copy), u17 (ref)
		t1:TogglePlayerList(not u17)
	end)
	game.UserInputService.InputBegan:Connect(function(input, gameProcessed) -- line: 608
		-- upvalues: t1 (copy), u17 (ref)
		if gameProcessed then
			return
		end

		if input.KeyCode == Enum.KeyCode.Tab then
			t1:TogglePlayerList(not u17)
		end
	end)

	local function addSFX(p15) -- line: 616
		-- upvalues: Sounds (copy)
		if p15:IsA("ImageButton") or p15:IsA("TextButton") then
			p15.MouseEnter:Connect(function() -- line: 618
				-- upvalues: Sounds (copy)
				Sounds:Play("hover")
			end)
			p15.MouseLeave:Connect(function() -- line: 619
				-- upvalues: Sounds (copy)
				Sounds:Play("hoverEnd")
			end)
			p15.MouseButton1Click:Connect(function() -- line: 620
				-- upvalues: Sounds (copy)
				Sounds:Play("select")
			end)
		end
	end

	for _, descendant in pairs(clone:GetDescendants()) do
		addSFX(descendant)
	end

	clone.DescendantAdded:Connect(addSFX)
	p11.PlayerList = clone
	game.StarterGui:SetCoreGuiEnabled("PlayerList", false)
end

return t1

]========]
end
do local object=game
object=object:FindFirstChild([========[
ServerScriptService]========])or child(object,[========[
ServerScriptService]========],[========[
ModuleScript]========])
object=object:FindFirstChild([========[
Server]========])or child(object,[========[
Server]========],[========[
ModuleScript]========])
object=object:FindFirstChild([========[
Systems]========])or child(object,[========[
Systems]========],[========[
ModuleScript]========])
object=object:FindFirstChild([========[
Data]========])or child(object,[========[
Data]========],[========[
ModuleScript]========])
object=object:FindFirstChild([========[
LeaderStats]========])or child(object,[========[
LeaderStats]========],[========[
ModuleScript]========])
object.Source=[========[
local module = {}

module.AddStats = function(_, Player : Player)
	task.spawn(function()
		local newStats = script.Template:Clone()
		newStats.Parent = Player
		newStats.Name = "leaderstats"
		
		Player:WaitForChild("PlayerData")
		local plrData : Folder = Player.PlayerData
		plrData:WaitForChild("Stats")
		local statsFolder : Folder = plrData.Stats
		local moneyVal = statsFolder:FindFirstChild("Money", true)
		local kChanceVal = statsFolder:FindFirstChild("KillerChance", true)
		
		newStats.Money.Value = moneyVal.Value
		newStats.KillerChance.Value = kChanceVal.Value
		
		moneyVal:GetPropertyChangedSignal("Value"):Connect(function()
			newStats.Money.Value = moneyVal.Value
		end)
		kChanceVal:GetPropertyChangedSignal("Value"):Connect(function()
			newStats.KillerChance.Value = kChanceVal.Value
		end)
	end)
end

return module]========]
end
end
local function install()
assert(not game:GetService("RunService"):IsRunning(),"Stop Play mode first.")
local changes={{path=[========[
ReplicatedStorage/Systems/Player/UI/Menus/Shop]========],before=[========[
require(game.ReplicatedStorage.GlobalTypes)

local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Debris = game:GetService("Debris")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")
local MarketplaceService = game:GetService("MarketplaceService")
local UserInputService = game:GetService("UserInputService")
local Util = require(game.ReplicatedStorage.Modules.Util)
local CurrencyDisplay = require(script.Parent.Parent.SidebarHandler.Classes.CurrencyDisplay)
local Sounds = require(game.ReplicatedStorage.Modules.Sounds)
local Network = require(game.ReplicatedStorage.Modules.Network)
local DataHandler = require(game.ReplicatedStorage.Modules.DataHandler)
local Trove = require(game.ReplicatedStorage.Modules.Misc.Trove)
local Signal = require(game.ReplicatedStorage.Modules.Misc.Signal)
local Device = require(game.ReplicatedStorage.Modules.CombatMenuCompat.Device)
local RigBuilder = require(script.Classes.RigBuilder)
local ShopSale = require(game.ReplicatedStorage.Modules.CombatMenuCompat.ShopSale)
local LocalPlayer = Players.LocalPlayer
local t1 = {}
local NotFound = script.Assets.NotFound
local EmoteViewport = script.Assets.EmoteViewport
local ConfirmUI = script.Assets.ConfirmUI
local t2 = {
	success = "Bought!",
	poor = "Insufficient funds!",
	alreadyBought = "Already owned! (You were not charged)",
	ratelimited = "Ratelimited! (You were not charged)",
	failed = "Something went wrong... (You were not charged)",
	priceChanged = "Price changed! (You were not charged)"
}
local t3={}

local function setupViewportRig() -- line: 55
	-- upvalues: Players (copy), LocalPlayer (copy)
	local EmoteViewport2 = script.Assets.EmoteViewport

	EmoteViewport2.Parent = workspace.CurrentCamera

	local clone = EmoteViewport2.WorldModel.Rig:Clone()

	EmoteViewport2.WorldModel.Rig:Destroy()
	clone.Parent = EmoteViewport2.WorldModel

	local v44 = clone and clone:FindFirstChildOfClass("Humanoid")
	local ok, result = pcall(Players.GetHumanoidDescriptionFromUserIdAsync, Players, LocalPlayer.UserId)

	if ok and (result and v44) then
		local ok2, result2 = pcall(function() -- line: 67
			-- upvalues: v44 (copy), result (copy)
			v44:ApplyDescriptionAsync(result, Enum.AssetTypeVerification.ClientOnly)
		end)

		if not ok2 then
			warn(`[Shop/{ script }]: Failed to apply description to emote rig. Response: { result2 }`)

			return
		end
	else
		warn(`[Shop/{ script }]: No local player description. Response: { result }`)
	end
end
local function transitionHighlightToState(p1, b1: boolean) -- line: 79
	-- upvalues: t1 (copy), TweenService (copy)
	assert(p1 and p1:IsA("TextButton"), "transitionHighlightToState() There was no highlight to transition.")
	assert(b1 ~= nil, "transitionHighlightToState() There was no state to transition to.")

	local Highlight = p1:FindFirstChild("Highlight")
	local Text = p1:FindFirstChild("Text")

	if not Highlight or not Text then
		warn(`[{ script }]: Failed to transition highlight for: { p1.Name }, missing UI elements.`)

		return
	end

	if t1[p1] then
		return
	end

	t1[p1] = true
	Highlight.Visible = true
	TweenService:Create(Highlight, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
		ImageTransparency = not b1 and 1 or 0
	}):Play()
	TweenService:Create(Text, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
		TextColor3 = b1 and Color3.new(0, 0, 0) or Color3.new(1, 1, 1)
	}):Play()
	task.delay(0.5, function() -- line: 113
		-- upvalues: t1 (copy), p1 (copy), b1 (copy), Highlight (copy)
		t1[p1] = nil

		if not b1 then
			Highlight.Visible = false
		end
	end)
end
local function requireShopAsset(p2) -- line: 121
	if p2:IsA("ModuleScript") then
		return pcall(require, p2)
	end

	local Config = p2:FindFirstChild("Config")

	if Config and Config:IsA("ModuleScript") then
		return pcall(require, Config)
	end

	return false, `No Config ModuleScript found for { p2:GetFullName() }`
end
local function getSkinRigSource(p3) -- line: 134
	local v56 = p3:IsA("ModuleScript") and p3.Parent or p3

	if not v56 then
		return nil
	end

	local Rig = v56:FindFirstChild("Rig")

	if Rig and Rig:IsA("Model") then
		return Rig
	end

	return nil
end
local function transitionToFrame(p4, p5, b2: boolean) -- line: 149
	-- upvalues: TweenService (copy)
	assert(p5 and p5:IsA("Frame"), "transitionToFrame() There was no frame to transition to.")
	assert(b2 ~= nil, "transitionToFrame() There was no direction to transition to.")

	if p4 == nil then
		p5.Position = UDim2.fromScale(0, 0)

		return
	end

	p5.Position = b2 and UDim2.fromScale(-1, 0) or UDim2.fromScale(1, 0)
	p5.Visible = true
	TweenService:Create(p4, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
		Position = UDim2.fromScale(not b2 and -1 or 1, 0)
	}):Play()
	TweenService:Create(p5, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
		Position = UDim2.fromScale(0, 0)
	}):Play()
	task.delay(0.5, function() -- line: 178
		-- upvalues: p4 (copy)
		p4.Visible = false
	end)
end

local t4 = {}
local t9 = {
	FormatPrice = function(_: {[any]: any}, n1: number) -- line: 187
		-- upvalues: Util (copy)
		assert(typeof(n1) == "number", "ShopUtils:FormatPrice() requires a number.")

		if n1 <= 0 then
			return "FREE"
		end

		return `${ Util:ToCommas(n1) }`
	end,
	CreateSearchbar = function(_: {[any]: any}, p6, p7) -- line: 193
		assert(p6 and p6:IsA("TextBox"), "ShopUtils:CreateSearchbar() requires a TextBox.")
		assert(p7 and p7:IsA("GuiObject"), "ShopUtils:CreateSearchbar() requires a Frame.")
		p6:GetPropertyChangedSignal("Text"):Connect(function() -- line: 197
			-- upvalues: p7 (copy), p6 (copy)
			for _, child in (p7:GetChildren()) do
				if child:IsA("GuiObject") and not child:GetAttribute("ShopTemplate") and (not child:GetAttribute("Purchased") or not p7:GetAttribute("ToggledUnowned")) then
					child.Visible = p6.Text == "" or child.Name:lower():find(p6.Text:lower())
				end
			end
		end)
	end,
	SetPurchaseUIState = function(t7: {[any]: any}, b3: boolean) -- line: 212
		-- upvalues: Trove (copy), RunService (copy), TweenService (copy), LocalPlayer (copy)
		if b3 then
			if t7.__trove then
				t7.__trove:Destroy()
			end

			local v68 = Trove.new()

			t7.__trove = v68

			local clone = script.Assets.TransitionGui:Clone()

			clone.Purchase.BackgroundTransparency = 1
			clone.Purchase.Icon.ImageTransparency = 1
			v68:Add(clone)

			local Icon = clone.Purchase.Icon
			local n2 = -1
			local n3 = 0
			local n4 = 0
			local u74 = false

			v68:Connect(RunService.Heartbeat, function(n5: number) -- line: 236
				-- upvalues: n2 (ref), n3 (ref), n4 (ref), u74 (ref), TweenService (copy), Icon (copy)
				n2 += n5 * 1.5
				n3 += n2 * n5

				if n3 > 0.5 then
					n3 = 0.5
					n2 = -1
					n4 += 1

					if n4 % 2 == 0 then
						u74 = not u74
						TweenService:Create(Icon, TweenInfo.new(2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
							Rotation = Icon.Rotation + (not u74 and -360 or 360)
						}):Play()
					end
				end

				Icon.Position = UDim2.fromScale(0.5, n3)
			end)
			clone.Parent = LocalPlayer.PlayerGui
			TweenService:Create(clone.Purchase, TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
				BackgroundTransparency = 0.35
			}):Play()
			TweenService:Create(Icon, TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
				ImageTransparency = 0
			}):Play()

			return
		end

		if t7.__trove then
			t7.__trove:Destroy()
			t7.__trove = nil
		end
	end,
	CreateUnownedButton = function(_: {[any]: any}, p8, p9) -- line: 285
		-- upvalues: Sounds (copy)
		assert(p8 and p8:IsA("TextButton"), "ShopUtils:CreateUnownedButton() requires a TextButton.")
		assert(p9 and p9:IsA("GuiObject"), "ShopUtils:CreateUnownedButton() requires a Frame.")
		p8.MouseEnter:Connect(function() -- line: 289
			-- upvalues: Sounds (copy)
			Sounds:Play("hover")
		end)
		p8.MouseLeave:Connect(function() -- line: 293
			-- upvalues: Sounds (copy)
			Sounds:Play("hoverEnd")
		end)
		p9:SetAttribute("ToggledUnowned", false)
		p8.MouseButton1Down:Connect(function() -- line: 298
			-- upvalues: Sounds (copy), p9 (copy), p8 (copy)
			Sounds:Play("click")

			local v225 = not p9:GetAttribute("ToggledUnowned")

			p9:SetAttribute("ToggledUnowned", v225)

			for _, child in p9:GetChildren() do
				if child:IsA("GuiObject") and not child:GetAttribute("ShopTemplate") and child:GetAttribute("Purchased") then
					child.Visible = not v225
				end
			end

			p8.Icon.ImageTransparency = not v225 and 0 or 0.5
		end)
	end
}
local u34 = false
local u35 = nil

function t9.CreateConfirmationUI(t10: {[any]: any}, p10) -- line: 318
	-- upvalues: u34 (ref), t9 (copy), DataHandler (copy), ConfirmUI (copy), u35 (ref), t4 (copy), ShopSale (copy), TweenService (copy), Sounds (copy), Network (copy), t2 (copy), requireShopAsset (copy), t3 (copy), MarketplaceService (copy), LocalPlayer (copy)
	if u34 then
		return
	end

	t9:ClearConfirmationUI()

	local ok, result = pcall(require, p10)

	if not ok then
		warn(`[{ script }]: Failed to require asset logic: { p10 }.`)

		return
	end

	local v82 = DataHandler:Get()

	if not v82 then
		warn(`[{ script }]: PlayerData does not exist.`)

		return
	end

	u34 = true

	local v83 = t10.__currentlySelected:FindFirstAncestor("Skins") and t10.__currentlySelected.Parent or t10.__currentlySelected

	if not v83 then
		u34 = false

		return
	end

	local clone = ConfirmUI:Clone()

	u35 = clone
	clone.Size = UDim2.fromScale(0.6, 0.6)

	local Menu = t4.ShopMenu.Menu
	local FinalPrice = ShopSale.GetAssetPrice(v83, result, workspace:GetServerTimeNow()).FinalPrice

	local function updateConfirmText() -- line: 352
		-- upvalues: t9 (copy), FinalPrice (ref), clone (copy), result (copy)
		local v228 = t9:FormatPrice(FinalPrice)

		clone:FindFirstChild("Text").Text = `Are you sure you would like to purchase <b><font color="rgb(255,255,255)">{ tostring(result.DisplayName) }</font></b> for <b><font color="rgb(255,255,255)">{ v228 }</font></b>?`
	end

	local v88 = t9:FormatPrice(FinalPrice)

	clone:FindFirstChild("Text").Text = `Are you sure you would like to purchase <b><font color="rgb(255,255,255)">{ tostring(result.DisplayName) }</font></b> for <b><font color="rgb(255,255,255)">{ v88 }</font></b>?`
	clone.Parent = Menu.Holder
	clone.Visible = true
	clone.Position = UDim2.fromScale(0.5, 0.525)
	TweenService:Create(clone, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Position = UDim2.fromScale(0.5, 0.5)
	}):Play()
	clone.Purchase.MouseButton1Down:Connect(function() -- line: 369
		-- upvalues: Sounds (copy), clone (copy), u34 (ref), Network (copy), v83 (copy), FinalPrice (ref), t2 (copy), t9 (copy), t10 (copy), result (copy), requireShopAsset (copy), v82 (copy), t3 (copy), MarketplaceService (copy), LocalPlayer (copy)
		Sounds:Play("click")

		local Text = clone.Purchase:FindFirstChild("Text")

		if not Text then
			u34 = false

			return
		end

		Text.Text = "..."

		local v230 = Network:FireServerConnection("PurchaseContent", "REMOTE_FUNCTION", v83, FinalPrice)

		if t2[v230.Status] then
			if t2[v230.Status] == "Insufficient funds!" and math.random(1, 1000) == 1 then
				Text.Text = "Poor"
			else
				Text.Text = t2[v230.Status]
			end
		end

		if v230.Status == "success" then
			t9.OnPurchased:Fire(t10.__currentlySelected)
		elseif v230.Status == "priceChanged" then
			FinalPrice = v230.Price

			local v231 = t9:FormatPrice(FinalPrice)

			clone:FindFirstChild("Text").Text = `Are you sure you would like to purchase <b><font color="rgb(255,255,255)">{ tostring(result.DisplayName) }</font></b> for <b><font color="rgb(255,255,255)">{ v231 }</font></b>?`

		end

		task.wait(0.5)
		Text.Text = "BUY"
		u34 = false
	end)
	clone.Purchase.MouseEnter:Connect(function() -- line: 428
		-- upvalues: Sounds (copy)
		Sounds:Play("hover")
	end)
	clone.Purchase.MouseLeave:Connect(function() -- line: 432
		-- upvalues: Sounds (copy)
		Sounds:Play("hoverEnd")
	end)
	clone.Cancel.MouseButton1Down:Connect(function() -- line: 436
		-- upvalues: clone (copy), u34 (ref), Sounds (copy)
		clone:Destroy()
		u34 = false
		Sounds:Play("click")
	end)
	clone.Cancel.MouseEnter:Connect(function() -- line: 442
		-- upvalues: Sounds (copy)
		Sounds:Play("hover")
	end)
	clone.Purchase.MouseLeave:Connect(function() -- line: 446
		-- upvalues: Sounds (copy)
		Sounds:Play("hoverEnd")
	end)
	clone.AncestryChanged:Connect(function(_, parent) -- line: 450
		-- upvalues: u34 (ref), t9 (copy)
		if not parent then
			u34 = false
			t9:ClearConfirmationUI()
		end
	end)

	return clone
end
function t9.ClearConfirmationUI(_) -- line: 460
	-- upvalues: u35 (ref)
	if u35 ~= nil then
		u35:Destroy()
	end

	u35 = nil
end
function t9.CreateViewport(_: {[any]: any}, p13, b4: boolean, b5: boolean) -- line: 467
	-- upvalues: EmoteViewport (copy), Players (copy), ReplicatedStorage (copy), Util (copy), SoundService (copy), Sounds (copy), Trove (copy), RunService (copy), UserInputService (copy), TweenService (copy), Debris (copy)
	local clone = EmoteViewport:Clone()
	local Rig = clone.WorldModel.Rig
	local Humanoid = Rig:FindFirstChildOfClass("Humanoid")

	if not Humanoid or not Humanoid:FindFirstChildOfClass("Animator") then
		warn(`[Shop/{ script }]: No animator found for emote { p13.DisplayName }.`)

		return
	end

	local AssetID = p13.AssetID

	if typeof(AssetID) == "table" then
		if p13.isDuoAnim then
			AssetID = AssetID[1]
		elseif not AssetID.Start or not AssetID.Loop then
			local v98 = Players.LocalPlayer.Character and Players.LocalPlayer.Character.Name
			local v99 = v98 and ReplicatedStorage.Assets.Survivors:FindFirstChild(v98)
			local v100 = v99 and (v99:FindFirstChild("Config") and require(v99.Config).Class)

			AssetID = if not v100 or not p13.AssetID[v100] then if not p13.AssetID.Survivalist then AssetID[math.random(#AssetID)] else p13.AssetID.Survivalist else p13.AssetID[v100]
		else
			AssetID = AssetID.Loop
		end
	end

	local v101 = Util:LoadAnimationFromID(Rig, AssetID)

	if v101 then
		v101.Looped = true
		v101:Play(0)
		v101.Priority = Enum.AnimationPriority.Action
	end

	local t12 = {
		Player = Players.LocalPlayer,
		Character = clone.WorldModel.Rig,
		Emote = v101
	}

	if p13.CreatedServer then
		local ok, result = pcall(p13.CreatedServer, t12)

		if not ok then
			warn(`[Shop/{ script }]: Failed to run CreatedServer for emote { p13.DisplayName }: { result }`)
		end
	end

	if p13.CreatedClient then
		local ok, result = pcall(p13.CreatedClient, t12)

		if not ok then
			warn(`[Shop/{ script }]: Failed to run CreatedClient for emote { p13.DisplayName }: { result }`)
		end
	end

	local u107 = nil

	if b4 then
		local v108 = p13.SFXProperties or {}

		v108.SoundGroup = SoundService.Emotes

		local v109 = typeof(p13.SFX) == "table" and p13.SFX.Loop

		if v109 then
			v108.Looped = true
		end

		u107 = Sounds:Play(v109 or p13.SFX, v108)

		if u107 then
			u107.PlaybackRegionsEnabled = true
			u107:GetPropertyChangedSignal("TimeLength"):Connect(function() -- line: 536
				-- upvalues: u107 (ref)
				local v240 = u107.TimeLength or 0

				u107.LoopRegion = NumberRange.new(0, (math.clamp(v240 - 0.05, 0.1, 60000)))
			end)
			u107.LoopRegion = NumberRange.new(0, (math.clamp(u107.TimeLength - 0.05, 0.1, 60000)))
		end
	end

	local u110 = Trove.new()

	if b5 then
		local Camera = Instance.new("Camera")

		Camera.Parent = clone
		clone.CurrentCamera = Camera

		local Arrows = clone.WorldModel:FindFirstChild("Arrows")

		Arrows.Transparency = 0.5

		local n6 = -90
		local n7 = 0
		local u115 = false
		local vector2 = nil

		local function updateCamera() -- line: 569
			-- upvalues: Camera (copy), Rig (copy), n6 (ref)
			if not Camera or (not Rig or not Rig.PrimaryPart) then
				return
			end

			local Position = Rig:GetPivot().Position
			local v242 = math.rad(n6)
			local v243 = Vector3.new(math.sin(v242) * 0.9659258262890683, 0.25881904510252074, math.cos(v242) * 0.9659258262890683) * 6

			Camera.CFrame = CFrame.lookAt(Position + v243, Position)
		end

		updateCamera()

		local n8 = 0
		local n9 = 0
		local zero = Vector2.zero
		local zero2 = Vector2.zero

		u110:Connect(RunService.RenderStepped, function(n10: number) -- line: 594
			-- upvalues: n8 (ref), u115 (ref), n6 (ref), n7 (ref), Rig (copy), Camera (copy), n9 (ref), Arrows (copy), zero2 (ref), zero (ref), updateCamera (copy)
			n8 += n10
			n8 %= 6.283185307179586

			if not u115 then
				n6 += n7 * n10
				n7 *= math.exp(n10 * -3)

				if math.abs(n7) < 0.1 then
					n7 = 0
				end

				local v245 = Rig:GetPivot().Position + Vector3.new(0, -2.5, 0)
				local CFramePosition = Camera.CFrame.Position
				local vector3 = Vector3.new(CFramePosition.X, v245.Y, CFramePosition.Z)

				n9 += n10 * 0.5235987755982988
				n9 %= 360
				Arrows.CFrame = CFrame.lookAt(v245, vector3) * CFrame.Angles(0, n9, 0)
			end

			if u115 == true then
				local v248 = -(zero2.X * 0.3 * n10 * workspace.CurrentCamera.ViewportSize.X) * 0.6

				n6 += v248
				n7 = v248 * 60
			end

			local v249 = -(zero.X * 0.3 * n10 * workspace.CurrentCamera.ViewportSize.X) * 0.6

			n6 += v249
			n7 = v249 * 60

			local v250 = u115 or zero.Magnitude > 0.1

			if v250 and Arrows.Transparency ~= 1 then
				Arrows.Transparency = 1
			elseif not v250 and Arrows.Transparency ~= 0.5 then
				Arrows.Transparency = 0.5
			end

			updateCamera()
		end)

		local function __onMobilePCInput(p14, _: boolean) -- line: 642
			-- upvalues: clone (copy), u115 (ref), vector2 (ref), n7 (ref), zero2 (ref), zero (ref)
			if p14.Position.Z ~= 0 then
				return
			end

			local p14Position = p14.Position
			local AbsolutePosition = clone.AbsolutePosition
			local AbsoluteSize = clone.AbsoluteSize
			local v256 = p14Position.X >= AbsolutePosition.X and p14Position.X <= AbsolutePosition.X + AbsoluteSize.X
			local v257 = p14Position.Y >= AbsolutePosition.Y and p14Position.Y <= AbsolutePosition.Y + AbsoluteSize.Y

			if not v256 or not v257 then
				return
			end

			u115 = true
			vector2 = Vector2.new(p14Position.X, p14Position.Y)
			n7 = 0
			zero2 = Vector2.zero
			zero = Vector2.zero
		end

		u110:Connect(UserInputService.InputBegan, function(p15, b7: boolean) -- line: 663
			-- upvalues: Players (copy), __onMobilePCInput (copy)
			local v260 = false

			if p15.UserInputType == Enum.UserInputType.Gamepad1 then
				if p15.KeyCode == Enum.KeyCode.ButtonR2 then
					v260 = true
				elseif p15.KeyCode == Enum.KeyCode.ButtonA then
					local Mouse = Players.LocalPlayer:GetMouse()

					__onMobilePCInput({
						Position = Vector3.new(Mouse.X, Mouse.Y, 0)
					}, true)

					return
				end
			end

			if v260 or p15.UserInputType == Enum.UserInputType.MouseButton1 or p15.UserInputType == Enum.UserInputType.Touch then
				__onMobilePCInput(p15, b7)
			end
		end)

		local t13 = {
			Enum.UserInputType.MouseMovement,
			Enum.UserInputType.Touch,
			Enum.UserInputType.Gamepad1
		}

		u110:Connect(UserInputService.InputChanged, function(p16, _: boolean) -- line: 686
			-- upvalues: u115 (ref), vector2 (ref), t13 (copy), zero2 (ref), n6 (ref), n7 (ref)
			if not u115 or not vector2 then
				return
			end

			if table.find(t13, p16.UserInputType) == nil then
				return
			end

			local zero3 = Vector2.zero
			local _ = Vector2.zero

			if p16.UserInputType == Enum.UserInputType.Gamepad1 then
				if p16.KeyCode ~= Enum.KeyCode.Thumbstick1 and p16.KeyCode ~= Enum.KeyCode.Thumbstick2 then
					return
				end

				if p16.KeyCode == Enum.KeyCode.Thumbstick1 then
					zero2 = Vector2.new(p16.Position.X, p16.Position.Y)

					return
				end
			else
				zero3 = Vector2.new(p16.Position.X, p16.Position.Y)
			end

			local v266 = zero3 - vector2

			vector2 = zero3

			local v267 = -v266.X * 0.6

			n6 += v267
			n7 = v267 * 60
		end)
		u110:Connect(UserInputService.InputChanged, function(p17, _: boolean) -- line: 721
			-- upvalues: zero (ref)
			if p17.KeyCode == Enum.KeyCode.Thumbstick2 then
				local vector2_2 = Vector2.new(p17.Position.X, p17.Position.Y)

				if vector2_2.Magnitude <= 0.1 then
					vector2_2 = Vector2.zero
				end

				zero = vector2_2

				return
			end
		end)
		u110:Connect(UserInputService.InputEnded, function(p18) -- line: 733
			-- upvalues: u115 (ref), vector2 (ref), zero2 (ref), zero (ref)
			if (p18.UserInputType ~= Enum.UserInputType.Gamepad1 or p18.KeyCode ~= Enum.KeyCode.ButtonR2 and p18.KeyCode ~= Enum.KeyCode.ButtonA) and (p18.UserInputType ~= Enum.UserInputType.MouseButton1 and p18.UserInputType ~= Enum.UserInputType.Touch) then
				return
			end

			u115 = false
			vector2 = nil
			zero2 = Vector2.zero
			zero = Vector2.zero
		end)
	end

	clone.AncestryChanged:Connect(function(_, parent) -- line: 750
		-- upvalues: u110 (ref), p13 (copy), t12 (copy), u107 (ref), TweenService (copy), Debris (copy)
		if parent then
			return
		end

		if u110 then
			u110:Clean()
			u110 = nil
		end

		if p13.DestroyedServer then
			local ok, result = pcall(p13.DestroyedServer, t12)

			if not ok then
				warn(`[Shop/{ script }]: Failed to run DestroyedServer for emote { p13.DisplayName }: { result }`)
			end
		end

		if p13.DestroyedClient then
			local ok, result = pcall(p13.DestroyedClient, t12)

			if not ok then
				warn(`[Shop/{ script }]: Failed to run DestroyedClient for emote { p13.DisplayName }: { result }`)
			end
		end

		if not u107 then
			return
		end

		TweenService:Create(u107, TweenInfo.new(0.1), {
			Volume = 0
		}):Play()
		Debris:AddItem(u107, 0.1)
	end)

	return clone
end
function t9.CreateSkinViewport(_: {[any]: any}, p20, b10: boolean) -- line: 792
	-- upvalues: RigBuilder (copy), Trove (copy), RunService (copy), UserInputService (copy), Players (copy)
	assert(typeof(p20) == "Instance", "ShopUtils:CreateSkinViewport() requires a skin folder.")

	local v127 = RigBuilder.ResolveSkin(p20)

	if not v127 or not v127.ActorFolder then
		warn(`[{ script }]: Could not resolve actor for { p20:GetFullName() }`)

		return
	end

	local v128 = RigBuilder.GetMergedConfig(v127)
	local v129 = RigBuilder.GetMergedBehavior(v127)
	local v130, v131 = RigBuilder.GetRig(v127, v128, v129)

	if not v130 then
		warn(`[{ script }]: No rig found for { p20:GetFullName() }`)

		return
	end

	RigBuilder.SanitizeRig(v130)
	RigBuilder.ApplyExpression(v130, v128)

	if v131 then
		RigBuilder.ApplyLifeAppearance(v130, v131)
	end

	if v127.ActorName == "Veeronica" then
		v130.Skateboard.Transparency = 1
		v130.Spray.Transparency = 1
	end

	local ViewportFrame = Instance.new("ViewportFrame")

	ViewportFrame.BackgroundTransparency = 1
	ViewportFrame.ImageTransparency = 0
	ViewportFrame.Ambient = Color3.fromRGB(200, 200, 200)
	ViewportFrame.LightColor = Color3.fromRGB(140, 140, 140)
	ViewportFrame.LightDirection = Vector3.new(-1, -1, -1)

	local WorldModel = Instance.new("WorldModel")

	WorldModel.WorldPivot = CFrame.new(0, 2.5, 0) * CFrame.Angles(0, 0.8726646259971648, 0)
	WorldModel.Parent = ViewportFrame
	v130:PivotTo(CFrame.new(-1.5, 3, 0) * CFrame.Angles(0, 1.1344640137963142, 0))
	v130.Parent = WorldModel

	local Camera = Instance.new("Camera")

	Camera.FieldOfView = 35
	Camera.Parent = ViewportFrame
	ViewportFrame.CurrentCamera = Camera

	local v135, v136 = RigBuilder.GetVisibleBoundingBox(v130)
	local v137 = math.max(math.max(v136.X, v136.Y, v136.Z) * 1.75, 6)
	local v138 = v135.Position + Vector3.new(0, v136.Y * 0.05, 0)
	local vector3 = Vector3.new(0, v136.Y * 0.12, v137)

	Camera.CFrame = CFrame.lookAt(v138 + vector3, v138)

	local v140 = Trove.new()

	if b10 then
		local Camera2 = Instance.new("Camera")

		Camera2.Parent = ViewportFrame
		ViewportFrame.CurrentCamera = Camera2

		local n11 = -90
		local n12 = 0
		local u144 = false
		local vector2 = nil

		local function updateCamera() -- line: 869
			-- upvalues: Camera2 (copy), v130 (copy), n11 (ref)
			if not Camera2 or (not v130 or not v130.PrimaryPart) then
				return
			end

			local Position = v130:GetPivot().Position
			local v279 = math.rad(n11)
			local v280 = Vector3.new(math.sin(v279) * 0.9659258262890683, 0.25881904510252074, math.cos(v279) * 0.9659258262890683) * 6

			Camera2.CFrame = CFrame.lookAt(Position + v280, Position)
		end

		updateCamera()

		local n13 = 0
		local zero = Vector2.zero
		local zero4 = Vector2.zero

		v140:Connect(RunService.RenderStepped, function(n14: number) -- line: 894
			-- upvalues: n13 (ref), u144 (ref), zero4 (ref), n11 (ref), n12 (ref), zero (ref), updateCamera (copy)
			n13 += n14
			n13 %= 6.283185307179586

			if u144 == true then
				local v282 = -(zero4.X * 0.3 * n14 * workspace.CurrentCamera.ViewportSize.X) * 0.6

				n11 += v282
				n12 = v282 * 60
			end

			local v283 = -(zero.X * 0.3 * n14 * workspace.CurrentCamera.ViewportSize.X) * 0.6

			n11 += v283
			n12 = v283 * 60
			updateCamera()
		end)

		local function __onMobilePCInput(p21, _: boolean) -- line: 917
			-- upvalues: ViewportFrame (copy), u144 (ref), vector2 (ref), n12 (ref), zero4 (ref), zero (ref)
			if p21.Position.Z ~= 0 then
				return
			end

			local p21Position = p21.Position
			local AbsolutePosition = ViewportFrame.AbsolutePosition
			local AbsoluteSize = ViewportFrame.AbsoluteSize
			local v289 = p21Position.X >= AbsolutePosition.X and p21Position.X <= AbsolutePosition.X + AbsoluteSize.X
			local v290 = p21Position.Y >= AbsolutePosition.Y and p21Position.Y <= AbsolutePosition.Y + AbsoluteSize.Y

			if not v289 or not v290 then
				return
			end

			u144 = true
			vector2 = Vector2.new(p21Position.X, p21Position.Y)
			n12 = 0
			zero4 = Vector2.zero
			zero = Vector2.zero
		end

		v140:Connect(UserInputService.InputBegan, function(p22, b12: boolean) -- line: 938
			-- upvalues: Players (copy), __onMobilePCInput (copy)
			local v293 = false

			if p22.UserInputType == Enum.UserInputType.Gamepad1 then
				if p22.KeyCode == Enum.KeyCode.ButtonR2 then
					v293 = true
				elseif p22.KeyCode == Enum.KeyCode.ButtonA then
					local Mouse = Players.LocalPlayer:GetMouse()

					__onMobilePCInput({
						Position = Vector3.new(Mouse.X, Mouse.Y, 0)
					}, true)

					return
				end
			end

			if v293 or p22.UserInputType == Enum.UserInputType.MouseButton1 or p22.UserInputType == Enum.UserInputType.Touch then
				__onMobilePCInput(p22, b12)
			end
		end)

		local t15 = {
			Enum.UserInputType.MouseMovement,
			Enum.UserInputType.Touch,
			Enum.UserInputType.Gamepad1
		}

		v140:Connect(UserInputService.InputChanged, function(p23, _: boolean) -- line: 961
			-- upvalues: u144 (ref), vector2 (ref), t15 (copy), zero4 (ref), n11 (ref), n12 (ref)
			if not u144 or not vector2 then
				return
			end

			if table.find(t15, p23.UserInputType) == nil then
				return
			end

			local zero5 = Vector2.zero
			local _ = Vector2.zero

			if p23.UserInputType == Enum.UserInputType.Gamepad1 then
				if p23.KeyCode ~= Enum.KeyCode.Thumbstick1 and p23.KeyCode ~= Enum.KeyCode.Thumbstick2 then
					return
				end

				if p23.KeyCode == Enum.KeyCode.Thumbstick1 then
					zero4 = Vector2.new(p23.Position.X, p23.Position.Y)

					return
				end
			else
				zero5 = Vector2.new(p23.Position.X, p23.Position.Y)
			end

			local v299 = zero5 - vector2

			vector2 = zero5

			local v300 = -v299.X * 0.6

			n11 += v300
			n12 = v300 * 60
		end)
		v140:Connect(UserInputService.InputChanged, function(p24, _: boolean) -- line: 996
			-- upvalues: zero (ref)
			if p24.KeyCode == Enum.KeyCode.Thumbstick2 then
				local vector2_3 = Vector2.new(p24.Position.X, p24.Position.Y)

				if vector2_3.Magnitude <= 0.1 then
					vector2_3 = Vector2.zero
				end

				zero = vector2_3

				return
			end
		end)
		v140:Connect(UserInputService.InputEnded, function(p25) -- line: 1008
			-- upvalues: u144 (ref), vector2 (ref), zero4 (ref), zero (ref)
			if (p25.UserInputType ~= Enum.UserInputType.Gamepad1 or p25.KeyCode ~= Enum.KeyCode.ButtonR2 and p25.KeyCode ~= Enum.KeyCode.ButtonA) and (p25.UserInputType ~= Enum.UserInputType.MouseButton1 and p25.UserInputType ~= Enum.UserInputType.Touch) then
				return
			end

			u144 = false
			vector2 = nil
			zero4 = Vector2.zero
			zero = Vector2.zero
		end)
	end

	local connection = nil

	connection = ViewportFrame.AncestryChanged:Connect(function(_, parent) -- line: 1026
		-- upvalues: ViewportFrame (copy), connection (ref), RigBuilder (copy), v130 (copy), v128 (copy)
		if parent and ViewportFrame:IsDescendantOf(game) then
			connection:Disconnect()
			RigBuilder.PlayIdleAnimation(v130, v128)
		end
	end)
	ViewportFrame.Destroying:Connect(function() -- line: 1033
		-- upvalues: v140 (copy), connection (ref)
		v140:Clean()

		if connection.Connected then
			connection:Disconnect()
		end
	end)

	return ViewportFrame
end
function t9.CloseOverlay(p27) -- line: 1043
	-- upvalues: t4 (copy), Device (copy), TweenService (copy), t9 (copy)
	assert(t4.ShopMenu, "ShopUtils:CloseOverlay() Shop menu does not exist, did you forget to setup the Shop module?")

	local Menu = t4.ShopMenu.Menu

	assert(Menu, "ShopUtils:OpenOverlay() Shop menu does not exist, did you forget to setup the Shop module?")

	local Overlay = Menu.Holder.Overlay
	local ViewportFrame = Overlay.Preview.BG:FindFirstChildOfClass("ViewportFrame")

	if ViewportFrame then
		ViewportFrame:Destroy()
	end

	p27.__overlaySelection = nil

	if Device:GetPlayerDevice() == "Mobile" then
		TweenService:Create(Menu.Holder, TweenInfo.new(0.5), {
			Position = UDim2.new(0.5, 0, 0.5, 0)
		}):Play()
	end

	t9:ClearConfirmationUI()
	Overlay.Visible = false
	p27.__isOverlayOpen = false
end
function t9.SetupOverlay(t16: {[any]: any}, p28, b15: boolean) -- line: 1066
	-- upvalues: t4 (copy), requireShopAsset (copy), Device (copy), TweenService (copy), t9 (copy)
	assert(typeof(p28) == "Instance" and (p28:IsA("ModuleScript") or p28:IsA("Folder")), "ShopUtils:OpenOverlay() requires assetLogic.")

	local u160 = p28:IsA("Folder") and p28:FindFirstChild("Config") or p28
	local Menu = t4.ShopMenu.Menu

	assert(Menu, "ShopUtils:OpenOverlay() Shop menu does not exist, did you forget to setup the Shop module?")

	local v162, v163 = requireShopAsset(u160)

	if not v162 then
		warn(`ShopUtils:OpenOverlay() Failed to require assetLogic: { u160 }. { v163 }`)

		return
	end

	if Device:GetPlayerDevice() == "Mobile" then
		TweenService:Create(Menu.Holder, TweenInfo.new(0.5), {
			Position = UDim2.new(0.45, 0, 0.5, 0)
		}):Play()
	end

	local Overlay = Menu.Holder.Overlay

	Overlay.Preview.Description.Text = v163.Description or "No description provided."
	Overlay.Preview.Credit.Text = v163.Credits or ""
	Overlay.Preview:FindFirstChild("Name").Text = v163.DisplayName or "No name provided."
	t16:ApplyPrice(Overlay.Preview, u160, v163)
	t9:ClearConfirmationUI()

	local ViewportFrame = Overlay.Preview.BG:FindFirstChildOfClass("ViewportFrame")

	if ViewportFrame then
		ViewportFrame:Destroy()
	end

	t16.__overlaySelection = nil

	if b15 then
		local v166 = t16:CreateViewport(v163, true, true)

		if not v166 then
			warn(`[{ script }]: Failed to create viewport for emote { v163.DisplayName }.`)

			return
		end

		Overlay.Preview.BG.Render.Visible = false
		v166.AnchorPoint = Vector2.new(0.5, 0.5)
		v166.Size = UDim2.fromScale(1, 0.965)
		v166.Position = UDim2.fromScale(0.485, 0.5)
		v166.Parent = Overlay.Preview.BG
	else
		Overlay.Preview.BG.Render.Visible = true
		Overlay.Preview.BG.Render.Image = v163.RenderImage or ""

		local t17 = {}

		t16.__overlaySelection = t17
		task.spawn(function() -- line: 1115
			-- upvalues: t16 (copy), u160 (ref), t17 (copy), Overlay (copy)
			local v307 = t16:CreateSkinViewport(u160, true)

			if not v307 then
				return
			end

			if t16.__overlaySelection ~= t17 then
				v307:Destroy()

				return
			end

			Overlay.Preview.BG.Render.Visible = false
			v307.AnchorPoint = Vector2.new(0.5, 0.5)
			v307.Size = UDim2.fromScale(1, 0.965)
			v307.Position = UDim2.fromScale(0.485, 0.5)
			v307.Parent = Overlay.Preview.BG
		end)
	end

	t16.__currentlySelected = u160
end

t9.__purchaseSignal = Signal.new()
t9.OnPurchased = t9.__purchaseSignal

function t9.OpenOverlay(t18: {[any]: any}, p29, b16: boolean) -- line: 1141
	-- upvalues: t4 (copy), TweenService (copy), Trove (copy), Sounds (copy), t9 (copy)
	if t18.__isOverlayOpen then
		t18:SetupOverlay(p29, b16)

		return
	end

	assert(typeof(p29) == "Instance" and (p29:IsA("ModuleScript") or p29:IsA("Folder")), "ShopUtils:OpenOverlay() requires assetLogic.")

	local Menu = t4.ShopMenu.Menu

	assert(Menu, "ShopUtils:OpenOverlay() Shop menu does not exist, did you forget to setup the Shop module?")
	t18.__isOverlayOpen = true

	local Overlay = Menu.Holder.Overlay

	Overlay.Position = UDim2.fromScale(1.2, 0.55)
	t18:SetupOverlay(p29, b16)
	Overlay.Visible = true
	TweenService:Create(Overlay, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Position = UDim2.fromScale(1.2, 0.5)
	}):Play()

	if t18.__buyTrove then
		t18.__buyTrove:Destroy()
	end

	t18.__buyTrove = Trove.new()
	t18.__buyTrove:Connect(Overlay.Preview.Buy.MouseEnter, function() -- line: 1173
		-- upvalues: TweenService (copy), Overlay (copy), Sounds (copy)
		TweenService:Create(Overlay.Preview.Buy, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.fromScale(0.625, 0.2)
		}):Play()
		Sounds:Play("hover")
	end)
	t18.__buyTrove:Connect(Overlay.Preview.Buy.MouseLeave, function() -- line: 1184
		-- upvalues: TweenService (copy), Overlay (copy), Sounds (copy)
		TweenService:Create(Overlay.Preview.Buy, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.fromScale(0.579, 0.083)
		}):Play()
		Sounds:Play("hoverEnd")
	end)
	t18.__buyTrove:Connect(Overlay.Preview.Buy.MouseButton1Down, function() -- line: 1195
		-- upvalues: Sounds (copy), t9 (copy), t18 (copy)
		Sounds:Play("click")
		t9:CreateConfirmationUI(t18.__currentlySelected)
	end)
end

local self = setmetatable({}, {
	__mode = "k"
})
local u37 = nil

local function scheduleSaleRefresh() -- line: 1205
	-- upvalues: u37 (ref), ShopSale (copy), self (copy), t9 (copy), scheduleSaleRefresh (copy)
	if u37 then
		return
	end

	local ServerTimeNow = workspace:GetServerTimeNow()
	local v174 = ShopSale.GetNextChangeTime(ServerTimeNow)

	if not v174 then
		return
	end

	u37 = task.delay(v174 - ServerTimeNow + 0.1, function() -- line: 1216
		-- upvalues: u37 (ref), self (copy), t9 (copy), scheduleSaleRefresh (copy)
		u37 = nil

		for v308, v309 in self do
			if v308.Parent then
				t9:ApplyPrice(v308, v309.asset, v309.config)
			else
				self[v308] = nil
			end
		end

		scheduleSaleRefresh()
	end)
end

function t9.ApplyPrice(t19: {[any]: any}, p30, p31, p32) -- line: 1231
	-- upvalues: ShopSale (copy), self (copy), scheduleSaleRefresh (copy)
	if p31:IsA("ModuleScript") and (p31.Name == "Config" and p31.Parent) then
		p31 = p31.Parent
	end

	local v179 = ShopSale.GetAssetPrice(p31, p32, workspace:GetServerTimeNow())
	local IsDiscounted = v179.IsDiscounted
	local Price = p30:FindFirstChild("Price")

	if Price then
		Price.Text = t19:FormatPrice(v179.FinalPrice)

		local DiscountGradient = Price:FindFirstChild("DiscountGradient")

		if DiscountGradient then
			DiscountGradient.Enabled = IsDiscounted
		end
	end

	local OldPrice = p30:FindFirstChild("OldPrice")

	if OldPrice then
		OldPrice.Visible = IsDiscounted
		OldPrice.Text = IsDiscounted and t19:FormatPrice(v179.OriginalPrice) or ""
	end

	local DiscountTag = p30:FindFirstChild("DiscountTag")

	if DiscountTag then
		DiscountTag.Visible = IsDiscounted
	end

	self[p30] = {
		asset = p31,
		config = p32
	}
	scheduleSaleRefresh()
end

local u39 = nil
local u40 = nil

function t4.OnTransitionState(b17: boolean) -- line: 1266
	-- upvalues: t4 (copy), u40 (ref), u39 (ref), Lighting (copy), Util (copy), LocalPlayer (copy), TweenService (copy), Debris (copy)
	local ShopMenu = t4.ShopMenu

	if b17 then
		if u40 then
			u40:Destroy()
			u40 = nil
		end

		if u39 then
			u39:Destroy()
			u39 = nil
		end

		ShopMenu.Menu.Position = UDim2.fromScale(0.5, 0.55)
		ShopMenu.Menu.Size = UDim2.fromScale(1, 1)
		ShopMenu.Menu.Visible = true

		local BlurEffect = Instance.new("BlurEffect")

		BlurEffect.Name = "ShopBlur"
		BlurEffect.Size = 0
		BlurEffect.Parent = Lighting
		u40 = BlurEffect
		u39 = Util:CreateFOVMultiplier(LocalPlayer, 1, "ShopZoom")
		TweenService:Create(BlurEffect, TweenInfo.new(0.225, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = 12
		}):Play()
		TweenService:Create(u39, TweenInfo.new(0.225, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Value = 0.85
		}):Play()
		TweenService:Create(ShopMenu.Menu, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Position = UDim2.fromScale(0.5, 0.5)
		}):Play()
	else
		ShopMenu.Menu.Visible = false

		local v188 = u39
		local v189 = u40

		if u39 then
			TweenService:Create(u39, TweenInfo.new(0.225, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Value = 1
			}):Play()
		end

		if v189 then
			TweenService:Create(v189, TweenInfo.new(0.225, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Size = 0
			}):Play()
		end

		if v189 then
			Debris:AddItem(v189, 0.225)
		end

		if v188 then
			Debris:AddItem(v188, 0.225)
		end
	end

	local v190 = `OnWindow{ not b17 and "Closed" or "Opened" }`
	local v191 = t4.TabLogic[t4.LastTab or ""]

	if v191 and v191[v190] then
		local ok, result = pcall(v191[v190], v191)

		if not ok then
			warn(`[{ script }]: Failed to run { v190 }() for tab: { t4.LastTab }, got: { result }`)
		end
	end
end
function t4.SwitchTab(_: {[any]: any}, s1: string) -- line: 1351
 if s1=="Robux"or s1=="Featured"then s1="Skins"end
	-- upvalues: t4 (copy), t1 (copy), transitionHighlightToState (copy), transitionToFrame (copy)
	if s1 == t4.LastTab then
		return
	end

	local Menu = t4.ShopMenu.Menu
	local TabButtons = Menu.Holder.TabButtons
	local v198 = t4.LastTab and TabButtons:FindFirstChild(t4.LastTab)
	local s1_2 = TabButtons:FindFirstChild(s1)

	if not s1_2 then
		warn(`[{ script }]: No tab found for: { s1 }`)

		return
	end

	if v198 then
		if t1[v198] then
			return
		end

		transitionHighlightToState(v198, false)
	end

	local s1_3 = Menu.Holder.Page:FindFirstChild(s1)
	local v201 = t4.LastTab and Menu.Holder.Page:FindFirstChild(t4.LastTab)
	local v202 = (v198 and v198.LayoutOrder or 0) > s1_2.LayoutOrder

	transitionToFrame(v201, s1_3, v202)
	transitionHighlightToState(s1_2, true)

	local v203 = t4.TabLogic[t4.LastTab]

	if v203 and v203.OnTabSwitched then
		local ok, result = pcall(v203.OnTabSwitched, v203)

		if not ok then
			warn(`[{ script }]: Failed to run OnTabSwitched() for tab: { t4.LastTab }, got: { result }`)
		end
	end

	local v206 = t4.TabLogic[s1]

	if v206 and v206.OnTabOpened then
		local ok, result = pcall(v206.OnTabOpened, v206)

		if not ok then
			warn(`[{ script }]: Failed to run OnTabOpened() for tab: { t4.LastTab }, got: { result }`)
		end
	end

	t4.LastTab = s1
end

local u41 = false

function t4.Start(_) -- line: 1401
	-- upvalues: u41 (ref), t4 (copy), CurrencyDisplay (copy), TweenService (copy), Sounds (copy), NotFound (copy), t9 (copy), setupViewportRig (copy)
	if u41 then
		return
	end

	u41 = true

	local EventHandlerClient = require(game.ReplicatedStorage.Modules.EventHandlerClient)

	if not EventHandlerClient:GetInfo() then
		EventHandlerClient.onEventInfoGiven:Wait()
		EventHandlerClient:GetInfo()
	end

	t4.ShopMenu = require(game.ReplicatedStorage.Initializer).PlayerSystems.SidebarHandler:CreateSidebarMenu("Shop", script.Shop)
	t4.Tabs = {}
	t4.TabLogic = {}

	local Menu = t4.ShopMenu.Menu

	os.clock()
	CurrencyDisplay.new("Money", "rbxassetid://132413181315189", false).Instance.Parent = Menu.Holder.Currency

	local Close = Menu.Holder.Close

	Close.MouseEnter:Connect(function() -- line: 1438
		-- upvalues: TweenService (copy), Close (copy), Sounds (copy)
		TweenService:Create(Close, TweenInfo.new(0.25), {
			Size = UDim2.fromScale(0.105, 0.105)
		}):Play()
		Sounds:Play("hover")
	end)
	Close.MouseLeave:Connect(function() -- line: 1450
		-- upvalues: TweenService (copy), Close (copy), Sounds (copy)
		TweenService:Create(Close, TweenInfo.new(0.25), {
			Size = UDim2.fromScale(0.071, 0.092)
		}):Play()
		Sounds:Play("hoverEnd")
	end)
	Close.MouseButton1Down:Connect(function() -- line: 1462
		-- upvalues: t4 (copy), Sounds (copy)
		t4.ShopMenu:ToggleMenu(false)
		Sounds:Play("click")
	end)
	Menu.Holder.Page:ClearAllChildren()

	local function isTabRejected(b18: boolean, s2: string, p34, s3: string?) -- line: 1470
		-- upvalues: NotFound (copy), Menu (copy), t4 (copy)
		if b18 then
			return nil
		end

		warn(`[{ script }]: Tab '{ s2 }' rejected during '{ s3 or "unknown" }' stage.`)

		if p34 then
			warn(`[{ script }]: Response: { p34 }`)
		end

		local clone = NotFound:Clone()

		clone.Name = s2
		clone.Parent = Menu.Holder.Page
		clone.Position = UDim2.fromScale(1, 0)
		t4.Tabs[s2] = clone

		return clone
	end

	for _, child in Menu.Holder.TabButtons:GetChildren() do
		if child:IsA("TextButton") then
            child.Size=UDim2.fromScale(0.475,0.732)
			child.MouseEnter:Connect(function() -- line: 1496
				-- upvalues: TweenService (copy), child (copy), Sounds (copy)
				TweenService:Create(child, TweenInfo.new(0.25), {
					Size = UDim2.fromScale(0.5, 0.75)
				}):Play()
				Sounds:Play("hover")
			end)
			child.MouseLeave:Connect(function() -- line: 1508
				-- upvalues: TweenService (copy), child (copy), Sounds (copy)
				TweenService:Create(child, TweenInfo.new(0.25), {
					Size = UDim2.fromScale(0.475, 0.732)
				}):Play()
				Sounds:Play("hoverEnd")
			end)
			child.MouseButton1Down:Connect(function() -- line: 1520
				-- upvalues: t4 (copy), child (copy), Sounds (copy)
				t4:SwitchTab(child.Name)
				Sounds:Play("click")
			end)

			local childName = child.Name
			local childName2 = script.Tabs:FindFirstChild(childName)

			if not isTabRejected(childName2 ~= nil, childName, "no ModuleScript found", "lookup") then
				local ok, result = xpcall(function() -- line: 1531
					-- upvalues: childName2 (copy)
					return require(childName2)
				end, debug.traceback)

				if not isTabRejected(ok, childName, result, "require") then
					local ok3, result3 = xpcall(function() -- line: 1536
						-- upvalues: result (copy), t9 (copy)
						return result.new(t9)
					end, debug.traceback)

					if not isTabRejected(ok3, childName, result3, "new()") then
						result3.Name = childName
						result3.Parent = Menu.Holder.Page
						result3.Position = UDim2.fromScale(1, 0)
						t4.TabLogic[childName] = result
						t4.Tabs[childName] = result3
					end
				end
			end
		end
	end

	setupViewportRig()
	t9.OnPurchased:Connect(function() -- line: 1551
		-- upvalues: t9 (copy)
		t9:ClearConfirmationUI()
	end)
	t4:SwitchTab("Skins")
end

return t4
]========],after=[========[
require(game.ReplicatedStorage.GlobalTypes)

local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Debris = game:GetService("Debris")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")
local MarketplaceService = game:GetService("MarketplaceService")
local UserInputService = game:GetService("UserInputService")
local Util = require(game.ReplicatedStorage.Modules.Util)
local CurrencyDisplay = require(script.Parent.Parent.SidebarHandler.Classes.CurrencyDisplay)
local Sounds = require(game.ReplicatedStorage.Modules.Sounds)
local Network = require(game.ReplicatedStorage.Modules.Network)
local DataHandler = require(game.ReplicatedStorage.Modules.DataHandler)
local Trove = require(game.ReplicatedStorage.Modules.Misc.Trove)
local Signal = require(game.ReplicatedStorage.Modules.Misc.Signal)
local Device = require(game.ReplicatedStorage.Modules.CombatMenuCompat.Device)
local RigBuilder = require(script.Classes.RigBuilder)
local ShopSale = require(game.ReplicatedStorage.Modules.CombatMenuCompat.ShopSale)
local LocalPlayer = Players.LocalPlayer
local t1 = {}
local NotFound = script.Assets.NotFound
local EmoteViewport = script.Assets.EmoteViewport
local ConfirmUI = script.Assets.ConfirmUI
local t2 = {
	success = "Bought!",
	poor = "Insufficient funds!",
	alreadyBought = "Already owned! (You were not charged)",
	ratelimited = "Ratelimited! (You were not charged)",
	failed = "Something went wrong... (You were not charged)",
	priceChanged = "Price changed! (You were not charged)"
}
local t3={}

local function setupViewportRig() -- line: 55
	-- upvalues: Players (copy), LocalPlayer (copy)
	local EmoteViewport2 = script.Assets.EmoteViewport

	EmoteViewport2.Parent = workspace.CurrentCamera

	local clone = EmoteViewport2.WorldModel.Rig:Clone()

	EmoteViewport2.WorldModel.Rig:Destroy()
	clone.Parent = EmoteViewport2.WorldModel

	local v44 = clone and clone:FindFirstChildOfClass("Humanoid")
	local ok, result = pcall(Players.GetHumanoidDescriptionFromUserIdAsync, Players, LocalPlayer.UserId)

	if ok and (result and v44) then
		local ok2, result2 = pcall(function() -- line: 67
			-- upvalues: v44 (copy), result (copy)
			v44:ApplyDescriptionAsync(result, Enum.AssetTypeVerification.ClientOnly)
		end)

		if not ok2 then
			warn(`[Shop/{ script }]: Failed to apply description to emote rig. Response: { result2 }`)

			return
		end
	else
		warn(`[Shop/{ script }]: No local player description. Response: { result }`)
	end
end
local function transitionHighlightToState(p1, b1: boolean) -- line: 79
	-- upvalues: t1 (copy), TweenService (copy)
	assert(p1 and p1:IsA("TextButton"), "transitionHighlightToState() There was no highlight to transition.")
	assert(b1 ~= nil, "transitionHighlightToState() There was no state to transition to.")

	local Highlight = p1:FindFirstChild("Highlight")
	local Text = p1:FindFirstChild("Text")

	if not Highlight or not Text then
		warn(`[{ script }]: Failed to transition highlight for: { p1.Name }, missing UI elements.`)

		return
	end

	if t1[p1] then
		return
	end

	t1[p1] = true
	Highlight.Visible = true
	TweenService:Create(Highlight, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
		ImageTransparency = not b1 and 1 or 0
	}):Play()
	TweenService:Create(Text, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
		TextColor3 = b1 and Color3.new(0, 0, 0) or Color3.new(1, 1, 1)
	}):Play()
	task.delay(0.5, function() -- line: 113
		-- upvalues: t1 (copy), p1 (copy), b1 (copy), Highlight (copy)
		t1[p1] = nil

		if not b1 then
			Highlight.Visible = false
		end
	end)
end
local function requireShopAsset(p2) -- line: 121
	if p2:IsA("ModuleScript") then
		return pcall(require, p2)
	end

	local Config = p2:FindFirstChild("Config")

	if Config and Config:IsA("ModuleScript") then
		return pcall(require, Config)
	end

	return false, `No Config ModuleScript found for { p2:GetFullName() }`
end
local function getSkinRigSource(p3) -- line: 134
	local v56 = p3:IsA("ModuleScript") and p3.Parent or p3

	if not v56 then
		return nil
	end

	local Rig = v56:FindFirstChild("Rig")

	if Rig and Rig:IsA("Model") then
		return Rig
	end

	return nil
end
local function transitionToFrame(p4, p5, b2: boolean) -- line: 149
	-- upvalues: TweenService (copy)
	assert(p5 and p5:IsA("Frame"), "transitionToFrame() There was no frame to transition to.")
	assert(b2 ~= nil, "transitionToFrame() There was no direction to transition to.")

	if p4 == nil then
        p5.Visible = true
		p5.Position = UDim2.fromScale(0, 0)

		return
	end

	p5.Position = b2 and UDim2.fromScale(-1, 0) or UDim2.fromScale(1, 0)
	p5.Visible = true
	TweenService:Create(p4, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
		Position = UDim2.fromScale(not b2 and -1 or 1, 0)
	}):Play()
	TweenService:Create(p5, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
		Position = UDim2.fromScale(0, 0)
	}):Play()
	task.delay(0.5, function() -- line: 178
		-- upvalues: p4 (copy)
		p4.Visible = false
	end)
end

local t4 = {}
local t9 = {
	FormatPrice = function(_: {[any]: any}, n1: number) -- line: 187
		-- upvalues: Util (copy)
		assert(typeof(n1) == "number", "ShopUtils:FormatPrice() requires a number.")

		if n1 <= 0 then
			return "FREE"
		end

		return `${ Util:ToCommas(n1) }`
	end,
	CreateSearchbar = function(_: {[any]: any}, p6, p7) -- line: 193
		assert(p6 and p6:IsA("TextBox"), "ShopUtils:CreateSearchbar() requires a TextBox.")
		assert(p7 and p7:IsA("GuiObject"), "ShopUtils:CreateSearchbar() requires a Frame.")
		p6:GetPropertyChangedSignal("Text"):Connect(function() -- line: 197
			-- upvalues: p7 (copy), p6 (copy)
			for _, child in (p7:GetChildren()) do
				if child:IsA("GuiObject") and not child:GetAttribute("ShopTemplate") and (not child:GetAttribute("Purchased") or not p7:GetAttribute("ToggledUnowned")) then
					child.Visible = p6.Text == "" or child.Name:lower():find(p6.Text:lower())
				end
			end
		end)
	end,
	SetPurchaseUIState = function(t7: {[any]: any}, b3: boolean) -- line: 212
		-- upvalues: Trove (copy), RunService (copy), TweenService (copy), LocalPlayer (copy)
		if b3 then
			if t7.__trove then
				t7.__trove:Destroy()
			end

			local v68 = Trove.new()

			t7.__trove = v68

			local clone = script.Assets.TransitionGui:Clone()

			clone.Purchase.BackgroundTransparency = 1
			clone.Purchase.Icon.ImageTransparency = 1
			v68:Add(clone)

			local Icon = clone.Purchase.Icon
			local n2 = -1
			local n3 = 0
			local n4 = 0
			local u74 = false

			v68:Connect(RunService.Heartbeat, function(n5: number) -- line: 236
				-- upvalues: n2 (ref), n3 (ref), n4 (ref), u74 (ref), TweenService (copy), Icon (copy)
				n2 += n5 * 1.5
				n3 += n2 * n5

				if n3 > 0.5 then
					n3 = 0.5
					n2 = -1
					n4 += 1

					if n4 % 2 == 0 then
						u74 = not u74
						TweenService:Create(Icon, TweenInfo.new(2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
							Rotation = Icon.Rotation + (not u74 and -360 or 360)
						}):Play()
					end
				end

				Icon.Position = UDim2.fromScale(0.5, n3)
			end)
			clone.Parent = LocalPlayer.PlayerGui
			TweenService:Create(clone.Purchase, TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
				BackgroundTransparency = 0.35
			}):Play()
			TweenService:Create(Icon, TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
				ImageTransparency = 0
			}):Play()

			return
		end

		if t7.__trove then
			t7.__trove:Destroy()
			t7.__trove = nil
		end
	end,
	CreateUnownedButton = function(_: {[any]: any}, p8, p9) -- line: 285
		-- upvalues: Sounds (copy)
		assert(p8 and p8:IsA("TextButton"), "ShopUtils:CreateUnownedButton() requires a TextButton.")
		assert(p9 and p9:IsA("GuiObject"), "ShopUtils:CreateUnownedButton() requires a Frame.")
		p8.MouseEnter:Connect(function() -- line: 289
			-- upvalues: Sounds (copy)
			Sounds:Play("hover")
		end)
		p8.MouseLeave:Connect(function() -- line: 293
			-- upvalues: Sounds (copy)
			Sounds:Play("hoverEnd")
		end)
		p9:SetAttribute("ToggledUnowned", false)
		p8.MouseButton1Down:Connect(function() -- line: 298
			-- upvalues: Sounds (copy), p9 (copy), p8 (copy)
			Sounds:Play("click")

			local v225 = not p9:GetAttribute("ToggledUnowned")

			p9:SetAttribute("ToggledUnowned", v225)

			for _, child in p9:GetChildren() do
				if child:IsA("GuiObject") and not child:GetAttribute("ShopTemplate") and child:GetAttribute("Purchased") then
					child.Visible = not v225
				end
			end

			p8.Icon.ImageTransparency = not v225 and 0 or 0.5
		end)
	end
}
local u34 = false
local u35 = nil

function t9.CreateConfirmationUI(t10: {[any]: any}, p10) -- line: 318
	-- upvalues: u34 (ref), t9 (copy), DataHandler (copy), ConfirmUI (copy), u35 (ref), t4 (copy), ShopSale (copy), TweenService (copy), Sounds (copy), Network (copy), t2 (copy), requireShopAsset (copy), t3 (copy), MarketplaceService (copy), LocalPlayer (copy)
	if u34 then
		return
	end

	t9:ClearConfirmationUI()

	local ok, result = pcall(require, p10)

	if not ok then
		warn(`[{ script }]: Failed to require asset logic: { p10 }.`)

		return
	end

	local v82 = DataHandler:Get()

	if not v82 then
		warn(`[{ script }]: PlayerData does not exist.`)

		return
	end

	u34 = true

	local v83 = t10.__currentlySelected:FindFirstAncestor("Skins") and t10.__currentlySelected.Parent or t10.__currentlySelected

	if not v83 then
		u34 = false

		return
	end

	local clone = ConfirmUI:Clone()

	u35 = clone
	clone.Size = UDim2.fromScale(0.6, 0.6)

	local Menu = t4.ShopMenu.Menu
	local FinalPrice = ShopSale.GetAssetPrice(v83, result, workspace:GetServerTimeNow()).FinalPrice

	local function updateConfirmText() -- line: 352
		-- upvalues: t9 (copy), FinalPrice (ref), clone (copy), result (copy)
		local v228 = t9:FormatPrice(FinalPrice)

		clone:FindFirstChild("Text").Text = `Are you sure you would like to purchase <b><font color="rgb(255,255,255)">{ tostring(result.DisplayName) }</font></b> for <b><font color="rgb(255,255,255)">{ v228 }</font></b>?`
	end

	local v88 = t9:FormatPrice(FinalPrice)

	clone:FindFirstChild("Text").Text = `Are you sure you would like to purchase <b><font color="rgb(255,255,255)">{ tostring(result.DisplayName) }</font></b> for <b><font color="rgb(255,255,255)">{ v88 }</font></b>?`
	clone.Parent = Menu.Holder
	clone.Visible = true
	clone.Position = UDim2.fromScale(0.5, 0.525)
	TweenService:Create(clone, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Position = UDim2.fromScale(0.5, 0.5)
	}):Play()
	clone.Purchase.MouseButton1Down:Connect(function() -- line: 369
		-- upvalues: Sounds (copy), clone (copy), u34 (ref), Network (copy), v83 (copy), FinalPrice (ref), t2 (copy), t9 (copy), t10 (copy), result (copy), requireShopAsset (copy), v82 (copy), t3 (copy), MarketplaceService (copy), LocalPlayer (copy)
		Sounds:Play("click")

		local Text = clone.Purchase:FindFirstChild("Text")

		if not Text then
			u34 = false

			return
		end

		Text.Text = "..."

		local v230 = Network:FireServerConnection("PurchaseContent", "REMOTE_FUNCTION", v83, FinalPrice)

		if t2[v230.Status] then
			if t2[v230.Status] == "Insufficient funds!" and math.random(1, 1000) == 1 then
				Text.Text = "Poor"
			else
				Text.Text = t2[v230.Status]
			end
		end

		if v230.Status == "success" then
			t9.OnPurchased:Fire(t10.__currentlySelected)
		elseif v230.Status == "priceChanged" then
			FinalPrice = v230.Price

			local v231 = t9:FormatPrice(FinalPrice)

			clone:FindFirstChild("Text").Text = `Are you sure you would like to purchase <b><font color="rgb(255,255,255)">{ tostring(result.DisplayName) }</font></b> for <b><font color="rgb(255,255,255)">{ v231 }</font></b>?`

		end

		task.wait(0.5)
		Text.Text = "BUY"
		u34 = false
	end)
	clone.Purchase.MouseEnter:Connect(function() -- line: 428
		-- upvalues: Sounds (copy)
		Sounds:Play("hover")
	end)
	clone.Purchase.MouseLeave:Connect(function() -- line: 432
		-- upvalues: Sounds (copy)
		Sounds:Play("hoverEnd")
	end)
	clone.Cancel.MouseButton1Down:Connect(function() -- line: 436
		-- upvalues: clone (copy), u34 (ref), Sounds (copy)
		clone:Destroy()
		u34 = false
		Sounds:Play("click")
	end)
	clone.Cancel.MouseEnter:Connect(function() -- line: 442
		-- upvalues: Sounds (copy)
		Sounds:Play("hover")
	end)
	clone.Purchase.MouseLeave:Connect(function() -- line: 446
		-- upvalues: Sounds (copy)
		Sounds:Play("hoverEnd")
	end)
	clone.AncestryChanged:Connect(function(_, parent) -- line: 450
		-- upvalues: u34 (ref), t9 (copy)
		if not parent then
			u34 = false
			t9:ClearConfirmationUI()
		end
	end)

	return clone
end
function t9.ClearConfirmationUI(_) -- line: 460
	-- upvalues: u35 (ref)
	if u35 ~= nil then
		u35:Destroy()
	end

	u35 = nil
end
function t9.CreateViewport(_: {[any]: any}, p13, b4: boolean, b5: boolean) -- line: 467
	-- upvalues: EmoteViewport (copy), Players (copy), ReplicatedStorage (copy), Util (copy), SoundService (copy), Sounds (copy), Trove (copy), RunService (copy), UserInputService (copy), TweenService (copy), Debris (copy)
	local clone = EmoteViewport:Clone()
	local Rig = clone.WorldModel.Rig
	local Humanoid = Rig:FindFirstChildOfClass("Humanoid")

	if not Humanoid or not Humanoid:FindFirstChildOfClass("Animator") then
		warn(`[Shop/{ script }]: No animator found for emote { p13.DisplayName }.`)

		return
	end

	local AssetID = p13.AssetID

	if typeof(AssetID) == "table" then
		if p13.isDuoAnim then
			AssetID = AssetID[1]
		elseif not AssetID.Start or not AssetID.Loop then
			local v98 = Players.LocalPlayer.Character and Players.LocalPlayer.Character.Name
			local v99 = v98 and ReplicatedStorage.Assets.Survivors:FindFirstChild(v98)
			local v100 = v99 and (v99:FindFirstChild("Config") and require(v99.Config).Class)

			AssetID = if not v100 or not p13.AssetID[v100] then if not p13.AssetID.Survivalist then AssetID[math.random(#AssetID)] else p13.AssetID.Survivalist else p13.AssetID[v100]
		else
			AssetID = AssetID.Loop
		end
	end

	local v101 = Util:LoadAnimationFromID(Rig, AssetID)

	if v101 then
		v101.Looped = true
		v101:Play(0)
		v101.Priority = Enum.AnimationPriority.Action
	end

	local t12 = {
		Player = Players.LocalPlayer,
		Character = clone.WorldModel.Rig,
		Emote = v101
	}

	if p13.CreatedServer then
		local ok, result = pcall(p13.CreatedServer, t12)

		if not ok then
			warn(`[Shop/{ script }]: Failed to run CreatedServer for emote { p13.DisplayName }: { result }`)
		end
	end

	if p13.CreatedClient then
		local ok, result = pcall(p13.CreatedClient, t12)

		if not ok then
			warn(`[Shop/{ script }]: Failed to run CreatedClient for emote { p13.DisplayName }: { result }`)
		end
	end

	local u107 = nil

	if b4 then
		local v108 = p13.SFXProperties or {}

		v108.SoundGroup = SoundService.Emotes

		local v109 = typeof(p13.SFX) == "table" and p13.SFX.Loop

		if v109 then
			v108.Looped = true
		end

		u107 = Sounds:Play(v109 or p13.SFX, v108)

		if u107 then
			u107.PlaybackRegionsEnabled = true
			u107:GetPropertyChangedSignal("TimeLength"):Connect(function() -- line: 536
				-- upvalues: u107 (ref)
				local v240 = u107.TimeLength or 0

				u107.LoopRegion = NumberRange.new(0, (math.clamp(v240 - 0.05, 0.1, 60000)))
			end)
			u107.LoopRegion = NumberRange.new(0, (math.clamp(u107.TimeLength - 0.05, 0.1, 60000)))
		end
	end

	local u110 = Trove.new()

	if b5 then
		local Camera = Instance.new("Camera")

		Camera.Parent = clone
		clone.CurrentCamera = Camera

		local Arrows = clone.WorldModel:FindFirstChild("Arrows")

		Arrows.Transparency = 0.5

		local n6 = -90
		local n7 = 0
		local u115 = false
		local vector2 = nil

		local function updateCamera() -- line: 569
			-- upvalues: Camera (copy), Rig (copy), n6 (ref)
			if not Camera or (not Rig or not Rig.PrimaryPart) then
				return
			end

			local Position = Rig:GetPivot().Position
			local v242 = math.rad(n6)
			local v243 = Vector3.new(math.sin(v242) * 0.9659258262890683, 0.25881904510252074, math.cos(v242) * 0.9659258262890683) * 6

			Camera.CFrame = CFrame.lookAt(Position + v243, Position)
		end

		updateCamera()

		local n8 = 0
		local n9 = 0
		local zero = Vector2.zero
		local zero2 = Vector2.zero

		u110:Connect(RunService.RenderStepped, function(n10: number) -- line: 594
			-- upvalues: n8 (ref), u115 (ref), n6 (ref), n7 (ref), Rig (copy), Camera (copy), n9 (ref), Arrows (copy), zero2 (ref), zero (ref), updateCamera (copy)
			n8 += n10
			n8 %= 6.283185307179586

			if not u115 then
				n6 += n7 * n10
				n7 *= math.exp(n10 * -3)

				if math.abs(n7) < 0.1 then
					n7 = 0
				end

				local v245 = Rig:GetPivot().Position + Vector3.new(0, -2.5, 0)
				local CFramePosition = Camera.CFrame.Position
				local vector3 = Vector3.new(CFramePosition.X, v245.Y, CFramePosition.Z)

				n9 += n10 * 0.5235987755982988
				n9 %= 360
				Arrows.CFrame = CFrame.lookAt(v245, vector3) * CFrame.Angles(0, n9, 0)
			end

			if u115 == true then
				local v248 = -(zero2.X * 0.3 * n10 * workspace.CurrentCamera.ViewportSize.X) * 0.6

				n6 += v248
				n7 = v248 * 60
			end

			local v249 = -(zero.X * 0.3 * n10 * workspace.CurrentCamera.ViewportSize.X) * 0.6

			n6 += v249
			n7 = v249 * 60

			local v250 = u115 or zero.Magnitude > 0.1

			if v250 and Arrows.Transparency ~= 1 then
				Arrows.Transparency = 1
			elseif not v250 and Arrows.Transparency ~= 0.5 then
				Arrows.Transparency = 0.5
			end

			updateCamera()
		end)

		local function __onMobilePCInput(p14, _: boolean) -- line: 642
			-- upvalues: clone (copy), u115 (ref), vector2 (ref), n7 (ref), zero2 (ref), zero (ref)
			if p14.Position.Z ~= 0 then
				return
			end

			local p14Position = p14.Position
			local AbsolutePosition = clone.AbsolutePosition
			local AbsoluteSize = clone.AbsoluteSize
			local v256 = p14Position.X >= AbsolutePosition.X and p14Position.X <= AbsolutePosition.X + AbsoluteSize.X
			local v257 = p14Position.Y >= AbsolutePosition.Y and p14Position.Y <= AbsolutePosition.Y + AbsoluteSize.Y

			if not v256 or not v257 then
				return
			end

			u115 = true
			vector2 = Vector2.new(p14Position.X, p14Position.Y)
			n7 = 0
			zero2 = Vector2.zero
			zero = Vector2.zero
		end

		u110:Connect(UserInputService.InputBegan, function(p15, b7: boolean) -- line: 663
			-- upvalues: Players (copy), __onMobilePCInput (copy)
			local v260 = false

			if p15.UserInputType == Enum.UserInputType.Gamepad1 then
				if p15.KeyCode == Enum.KeyCode.ButtonR2 then
					v260 = true
				elseif p15.KeyCode == Enum.KeyCode.ButtonA then
					local Mouse = Players.LocalPlayer:GetMouse()

					__onMobilePCInput({
						Position = Vector3.new(Mouse.X, Mouse.Y, 0)
					}, true)

					return
				end
			end

			if v260 or p15.UserInputType == Enum.UserInputType.MouseButton1 or p15.UserInputType == Enum.UserInputType.Touch then
				__onMobilePCInput(p15, b7)
			end
		end)

		local t13 = {
			Enum.UserInputType.MouseMovement,
			Enum.UserInputType.Touch,
			Enum.UserInputType.Gamepad1
		}

		u110:Connect(UserInputService.InputChanged, function(p16, _: boolean) -- line: 686
			-- upvalues: u115 (ref), vector2 (ref), t13 (copy), zero2 (ref), n6 (ref), n7 (ref)
			if not u115 or not vector2 then
				return
			end

			if table.find(t13, p16.UserInputType) == nil then
				return
			end

			local zero3 = Vector2.zero
			local _ = Vector2.zero

			if p16.UserInputType == Enum.UserInputType.Gamepad1 then
				if p16.KeyCode ~= Enum.KeyCode.Thumbstick1 and p16.KeyCode ~= Enum.KeyCode.Thumbstick2 then
					return
				end

				if p16.KeyCode == Enum.KeyCode.Thumbstick1 then
					zero2 = Vector2.new(p16.Position.X, p16.Position.Y)

					return
				end
			else
				zero3 = Vector2.new(p16.Position.X, p16.Position.Y)
			end

			local v266 = zero3 - vector2

			vector2 = zero3

			local v267 = -v266.X * 0.6

			n6 += v267
			n7 = v267 * 60
		end)
		u110:Connect(UserInputService.InputChanged, function(p17, _: boolean) -- line: 721
			-- upvalues: zero (ref)
			if p17.KeyCode == Enum.KeyCode.Thumbstick2 then
				local vector2_2 = Vector2.new(p17.Position.X, p17.Position.Y)

				if vector2_2.Magnitude <= 0.1 then
					vector2_2 = Vector2.zero
				end

				zero = vector2_2

				return
			end
		end)
		u110:Connect(UserInputService.InputEnded, function(p18) -- line: 733
			-- upvalues: u115 (ref), vector2 (ref), zero2 (ref), zero (ref)
			if (p18.UserInputType ~= Enum.UserInputType.Gamepad1 or p18.KeyCode ~= Enum.KeyCode.ButtonR2 and p18.KeyCode ~= Enum.KeyCode.ButtonA) and (p18.UserInputType ~= Enum.UserInputType.MouseButton1 and p18.UserInputType ~= Enum.UserInputType.Touch) then
				return
			end

			u115 = false
			vector2 = nil
			zero2 = Vector2.zero
			zero = Vector2.zero
		end)
	end

	clone.AncestryChanged:Connect(function(_, parent) -- line: 750
		-- upvalues: u110 (ref), p13 (copy), t12 (copy), u107 (ref), TweenService (copy), Debris (copy)
		if parent then
			return
		end

		if u110 then
			u110:Clean()
			u110 = nil
		end

		if p13.DestroyedServer then
			local ok, result = pcall(p13.DestroyedServer, t12)

			if not ok then
				warn(`[Shop/{ script }]: Failed to run DestroyedServer for emote { p13.DisplayName }: { result }`)
			end
		end

		if p13.DestroyedClient then
			local ok, result = pcall(p13.DestroyedClient, t12)

			if not ok then
				warn(`[Shop/{ script }]: Failed to run DestroyedClient for emote { p13.DisplayName }: { result }`)
			end
		end

		if not u107 then
			return
		end

		TweenService:Create(u107, TweenInfo.new(0.1), {
			Volume = 0
		}):Play()
		Debris:AddItem(u107, 0.1)
	end)

	return clone
end
function t9.CreateSkinViewport(_: {[any]: any}, p20, b10: boolean) -- line: 792
	-- upvalues: RigBuilder (copy), Trove (copy), RunService (copy), UserInputService (copy), Players (copy)
	assert(typeof(p20) == "Instance", "ShopUtils:CreateSkinViewport() requires a skin folder.")

	local v127 = RigBuilder.ResolveSkin(p20)

	if not v127 or not v127.ActorFolder then
		warn(`[{ script }]: Could not resolve actor for { p20:GetFullName() }`)

		return
	end

	local v128 = RigBuilder.GetMergedConfig(v127)
	local v129 = RigBuilder.GetMergedBehavior(v127)
	local v130, v131 = RigBuilder.GetRig(v127, v128, v129)

	if not v130 then
		warn(`[{ script }]: No rig found for { p20:GetFullName() }`)

		return
	end

	RigBuilder.SanitizeRig(v130)
	RigBuilder.ApplyExpression(v130, v128)

	if v131 then
		RigBuilder.ApplyLifeAppearance(v130, v131)
	end

	if v127.ActorName == "Veeronica" then
		v130.Skateboard.Transparency = 1
		v130.Spray.Transparency = 1
	end

	local ViewportFrame = Instance.new("ViewportFrame")

	ViewportFrame.BackgroundTransparency = 1
	ViewportFrame.ImageTransparency = 0
	ViewportFrame.Ambient = Color3.fromRGB(200, 200, 200)
	ViewportFrame.LightColor = Color3.fromRGB(140, 140, 140)
	ViewportFrame.LightDirection = Vector3.new(-1, -1, -1)

	local WorldModel = Instance.new("WorldModel")

	WorldModel.WorldPivot = CFrame.new(0, 2.5, 0) * CFrame.Angles(0, 0.8726646259971648, 0)
	WorldModel.Parent = ViewportFrame
	v130:PivotTo(CFrame.new(-1.5, 3, 0) * CFrame.Angles(0, 1.1344640137963142, 0))
	v130.Parent = WorldModel

	local Camera = Instance.new("Camera")

	Camera.FieldOfView = 35
	Camera.Parent = ViewportFrame
	ViewportFrame.CurrentCamera = Camera

	local v135, v136 = RigBuilder.GetVisibleBoundingBox(v130)
	local v137 = math.max(math.max(v136.X, v136.Y, v136.Z) * 1.75, 6)
	local v138 = v135.Position + Vector3.new(0, v136.Y * 0.05, 0)
	local vector3 = Vector3.new(0, v136.Y * 0.12, v137)

	Camera.CFrame = CFrame.lookAt(v138 + vector3, v138)

	local v140 = Trove.new()

	if b10 then
		local Camera2 = Instance.new("Camera")

		Camera2.Parent = ViewportFrame
		ViewportFrame.CurrentCamera = Camera2

		local n11 = -90
		local n12 = 0
		local u144 = false
		local vector2 = nil

		local function updateCamera() -- line: 869
			-- upvalues: Camera2 (copy), v130 (copy), n11 (ref)
			if not Camera2 or (not v130 or not v130.PrimaryPart) then
				return
			end

			local Position = v130:GetPivot().Position
			local v279 = math.rad(n11)
			local v280 = Vector3.new(math.sin(v279) * 0.9659258262890683, 0.25881904510252074, math.cos(v279) * 0.9659258262890683) * 6

			Camera2.CFrame = CFrame.lookAt(Position + v280, Position)
		end

		updateCamera()

		local n13 = 0
		local zero = Vector2.zero
		local zero4 = Vector2.zero

		v140:Connect(RunService.RenderStepped, function(n14: number) -- line: 894
			-- upvalues: n13 (ref), u144 (ref), zero4 (ref), n11 (ref), n12 (ref), zero (ref), updateCamera (copy)
			n13 += n14
			n13 %= 6.283185307179586

			if u144 == true then
				local v282 = -(zero4.X * 0.3 * n14 * workspace.CurrentCamera.ViewportSize.X) * 0.6

				n11 += v282
				n12 = v282 * 60
			end

			local v283 = -(zero.X * 0.3 * n14 * workspace.CurrentCamera.ViewportSize.X) * 0.6

			n11 += v283
			n12 = v283 * 60
			updateCamera()
		end)

		local function __onMobilePCInput(p21, _: boolean) -- line: 917
			-- upvalues: ViewportFrame (copy), u144 (ref), vector2 (ref), n12 (ref), zero4 (ref), zero (ref)
			if p21.Position.Z ~= 0 then
				return
			end

			local p21Position = p21.Position
			local AbsolutePosition = ViewportFrame.AbsolutePosition
			local AbsoluteSize = ViewportFrame.AbsoluteSize
			local v289 = p21Position.X >= AbsolutePosition.X and p21Position.X <= AbsolutePosition.X + AbsoluteSize.X
			local v290 = p21Position.Y >= AbsolutePosition.Y and p21Position.Y <= AbsolutePosition.Y + AbsoluteSize.Y

			if not v289 or not v290 then
				return
			end

			u144 = true
			vector2 = Vector2.new(p21Position.X, p21Position.Y)
			n12 = 0
			zero4 = Vector2.zero
			zero = Vector2.zero
		end

		v140:Connect(UserInputService.InputBegan, function(p22, b12: boolean) -- line: 938
			-- upvalues: Players (copy), __onMobilePCInput (copy)
			local v293 = false

			if p22.UserInputType == Enum.UserInputType.Gamepad1 then
				if p22.KeyCode == Enum.KeyCode.ButtonR2 then
					v293 = true
				elseif p22.KeyCode == Enum.KeyCode.ButtonA then
					local Mouse = Players.LocalPlayer:GetMouse()

					__onMobilePCInput({
						Position = Vector3.new(Mouse.X, Mouse.Y, 0)
					}, true)

					return
				end
			end

			if v293 or p22.UserInputType == Enum.UserInputType.MouseButton1 or p22.UserInputType == Enum.UserInputType.Touch then
				__onMobilePCInput(p22, b12)
			end
		end)

		local t15 = {
			Enum.UserInputType.MouseMovement,
			Enum.UserInputType.Touch,
			Enum.UserInputType.Gamepad1
		}

		v140:Connect(UserInputService.InputChanged, function(p23, _: boolean) -- line: 961
			-- upvalues: u144 (ref), vector2 (ref), t15 (copy), zero4 (ref), n11 (ref), n12 (ref)
			if not u144 or not vector2 then
				return
			end

			if table.find(t15, p23.UserInputType) == nil then
				return
			end

			local zero5 = Vector2.zero
			local _ = Vector2.zero

			if p23.UserInputType == Enum.UserInputType.Gamepad1 then
				if p23.KeyCode ~= Enum.KeyCode.Thumbstick1 and p23.KeyCode ~= Enum.KeyCode.Thumbstick2 then
					return
				end

				if p23.KeyCode == Enum.KeyCode.Thumbstick1 then
					zero4 = Vector2.new(p23.Position.X, p23.Position.Y)

					return
				end
			else
				zero5 = Vector2.new(p23.Position.X, p23.Position.Y)
			end

			local v299 = zero5 - vector2

			vector2 = zero5

			local v300 = -v299.X * 0.6

			n11 += v300
			n12 = v300 * 60
		end)
		v140:Connect(UserInputService.InputChanged, function(p24, _: boolean) -- line: 996
			-- upvalues: zero (ref)
			if p24.KeyCode == Enum.KeyCode.Thumbstick2 then
				local vector2_3 = Vector2.new(p24.Position.X, p24.Position.Y)

				if vector2_3.Magnitude <= 0.1 then
					vector2_3 = Vector2.zero
				end

				zero = vector2_3

				return
			end
		end)
		v140:Connect(UserInputService.InputEnded, function(p25) -- line: 1008
			-- upvalues: u144 (ref), vector2 (ref), zero4 (ref), zero (ref)
			if (p25.UserInputType ~= Enum.UserInputType.Gamepad1 or p25.KeyCode ~= Enum.KeyCode.ButtonR2 and p25.KeyCode ~= Enum.KeyCode.ButtonA) and (p25.UserInputType ~= Enum.UserInputType.MouseButton1 and p25.UserInputType ~= Enum.UserInputType.Touch) then
				return
			end

			u144 = false
			vector2 = nil
			zero4 = Vector2.zero
			zero = Vector2.zero
		end)
	end

	local connection = nil

	connection = ViewportFrame.AncestryChanged:Connect(function(_, parent) -- line: 1026
		-- upvalues: ViewportFrame (copy), connection (ref), RigBuilder (copy), v130 (copy), v128 (copy)
		if parent and ViewportFrame:IsDescendantOf(game) then
			connection:Disconnect()
			RigBuilder.PlayIdleAnimation(v130, v128)
		end
	end)
	ViewportFrame.Destroying:Connect(function() -- line: 1033
		-- upvalues: v140 (copy), connection (ref)
		v140:Clean()

		if connection.Connected then
			connection:Disconnect()
		end
	end)

	return ViewportFrame
end
function t9.CloseOverlay(p27) -- line: 1043
	-- upvalues: t4 (copy), Device (copy), TweenService (copy), t9 (copy)
	assert(t4.ShopMenu, "ShopUtils:CloseOverlay() Shop menu does not exist, did you forget to setup the Shop module?")

	local Menu = t4.ShopMenu.Menu

	assert(Menu, "ShopUtils:OpenOverlay() Shop menu does not exist, did you forget to setup the Shop module?")

	local Overlay = Menu.Holder.Overlay
	local ViewportFrame = Overlay.Preview.BG:FindFirstChildOfClass("ViewportFrame")

	if ViewportFrame then
		ViewportFrame:Destroy()
	end

	p27.__overlaySelection = nil

	if Device:GetPlayerDevice() == "Mobile" then
		TweenService:Create(Menu.Holder, TweenInfo.new(0.5), {
			Position = UDim2.new(0.5, 0, 0.5, 0)
		}):Play()
	end

	t9:ClearConfirmationUI()
	Overlay.Visible = false
	p27.__isOverlayOpen = false
end
function t9.SetupOverlay(t16: {[any]: any}, p28, b15: boolean) -- line: 1066
	-- upvalues: t4 (copy), requireShopAsset (copy), Device (copy), TweenService (copy), t9 (copy)
	assert(typeof(p28) == "Instance" and (p28:IsA("ModuleScript") or p28:IsA("Folder")), "ShopUtils:OpenOverlay() requires assetLogic.")

	local u160 = p28:IsA("Folder") and p28:FindFirstChild("Config") or p28
	local Menu = t4.ShopMenu.Menu

	assert(Menu, "ShopUtils:OpenOverlay() Shop menu does not exist, did you forget to setup the Shop module?")

	local v162, v163 = requireShopAsset(u160)

	if not v162 then
		warn(`ShopUtils:OpenOverlay() Failed to require assetLogic: { u160 }. { v163 }`)

		return
	end

	if Device:GetPlayerDevice() == "Mobile" then
		TweenService:Create(Menu.Holder, TweenInfo.new(0.5), {
			Position = UDim2.new(0.45, 0, 0.5, 0)
		}):Play()
	end

	local Overlay = Menu.Holder.Overlay

	Overlay.Preview.Description.Text = v163.Description or "No description provided."
	Overlay.Preview.Credit.Text = v163.Credits or ""
	Overlay.Preview:FindFirstChild("Name").Text = v163.DisplayName or "No name provided."
	t16:ApplyPrice(Overlay.Preview, u160, v163)
	t9:ClearConfirmationUI()

	local ViewportFrame = Overlay.Preview.BG:FindFirstChildOfClass("ViewportFrame")

	if ViewportFrame then
		ViewportFrame:Destroy()
	end

	t16.__overlaySelection = nil

	if b15 then
		local v166 = t16:CreateViewport(v163, true, true)

		if not v166 then
			warn(`[{ script }]: Failed to create viewport for emote { v163.DisplayName }.`)

			return
		end

		Overlay.Preview.BG.Render.Visible = false
		v166.AnchorPoint = Vector2.new(0.5, 0.5)
		v166.Size = UDim2.fromScale(1, 0.965)
		v166.Position = UDim2.fromScale(0.485, 0.5)
		v166.Parent = Overlay.Preview.BG
	else
		Overlay.Preview.BG.Render.Visible = true
		Overlay.Preview.BG.Render.Image = v163.RenderImage or ""

		local t17 = {}

		t16.__overlaySelection = t17
		task.spawn(function() -- line: 1115
			-- upvalues: t16 (copy), u160 (ref), t17 (copy), Overlay (copy)
			local v307 = t16:CreateSkinViewport(u160, true)

			if not v307 then
				return
			end

			if t16.__overlaySelection ~= t17 then
				v307:Destroy()

				return
			end

			Overlay.Preview.BG.Render.Visible = false
			v307.AnchorPoint = Vector2.new(0.5, 0.5)
			v307.Size = UDim2.fromScale(1, 0.965)
			v307.Position = UDim2.fromScale(0.485, 0.5)
			v307.Parent = Overlay.Preview.BG
		end)
	end

	t16.__currentlySelected = u160
end

t9.__purchaseSignal = Signal.new()
t9.OnPurchased = t9.__purchaseSignal

function t9.OpenOverlay(t18: {[any]: any}, p29, b16: boolean) -- line: 1141
	-- upvalues: t4 (copy), TweenService (copy), Trove (copy), Sounds (copy), t9 (copy)
	if t18.__isOverlayOpen then
		t18:SetupOverlay(p29, b16)

		return
	end

	assert(typeof(p29) == "Instance" and (p29:IsA("ModuleScript") or p29:IsA("Folder")), "ShopUtils:OpenOverlay() requires assetLogic.")

	local Menu = t4.ShopMenu.Menu

	assert(Menu, "ShopUtils:OpenOverlay() Shop menu does not exist, did you forget to setup the Shop module?")
	t18.__isOverlayOpen = true

	local Overlay = Menu.Holder.Overlay

	Overlay.Position = UDim2.fromScale(1.2, 0.55)
	t18:SetupOverlay(p29, b16)
	Overlay.Visible = true
	TweenService:Create(Overlay, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Position = UDim2.fromScale(1.2, 0.5)
	}):Play()

	if t18.__buyTrove then
		t18.__buyTrove:Destroy()
	end

	t18.__buyTrove = Trove.new()
	t18.__buyTrove:Connect(Overlay.Preview.Buy.MouseEnter, function() -- line: 1173
		-- upvalues: TweenService (copy), Overlay (copy), Sounds (copy)
		TweenService:Create(Overlay.Preview.Buy, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.fromScale(0.625, 0.2)
		}):Play()
		Sounds:Play("hover")
	end)
	t18.__buyTrove:Connect(Overlay.Preview.Buy.MouseLeave, function() -- line: 1184
		-- upvalues: TweenService (copy), Overlay (copy), Sounds (copy)
		TweenService:Create(Overlay.Preview.Buy, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.fromScale(0.579, 0.083)
		}):Play()
		Sounds:Play("hoverEnd")
	end)
	t18.__buyTrove:Connect(Overlay.Preview.Buy.MouseButton1Down, function() -- line: 1195
		-- upvalues: Sounds (copy), t9 (copy), t18 (copy)
		Sounds:Play("click")
		t9:CreateConfirmationUI(t18.__currentlySelected)
	end)
end

local self = setmetatable({}, {
	__mode = "k"
})
local u37 = nil

local function scheduleSaleRefresh() -- line: 1205
	-- upvalues: u37 (ref), ShopSale (copy), self (copy), t9 (copy), scheduleSaleRefresh (copy)
	if u37 then
		return
	end

	local ServerTimeNow = workspace:GetServerTimeNow()
	local v174 = ShopSale.GetNextChangeTime(ServerTimeNow)

	if not v174 then
		return
	end

	u37 = task.delay(v174 - ServerTimeNow + 0.1, function() -- line: 1216
		-- upvalues: u37 (ref), self (copy), t9 (copy), scheduleSaleRefresh (copy)
		u37 = nil

		for v308, v309 in self do
			if v308.Parent then
				t9:ApplyPrice(v308, v309.asset, v309.config)
			else
				self[v308] = nil
			end
		end

		scheduleSaleRefresh()
	end)
end

function t9.ApplyPrice(t19: {[any]: any}, p30, p31, p32) -- line: 1231
	-- upvalues: ShopSale (copy), self (copy), scheduleSaleRefresh (copy)
	if p31:IsA("ModuleScript") and (p31.Name == "Config" and p31.Parent) then
		p31 = p31.Parent
	end

	local v179 = ShopSale.GetAssetPrice(p31, p32, workspace:GetServerTimeNow())
	local IsDiscounted = v179.IsDiscounted
	local Price = p30:FindFirstChild("Price")

	if Price then
		Price.Text = t19:FormatPrice(v179.FinalPrice)

		local DiscountGradient = Price:FindFirstChild("DiscountGradient")

		if DiscountGradient then
			DiscountGradient.Enabled = IsDiscounted
		end
	end

	local OldPrice = p30:FindFirstChild("OldPrice")

	if OldPrice then
		OldPrice.Visible = IsDiscounted
		OldPrice.Text = IsDiscounted and t19:FormatPrice(v179.OriginalPrice) or ""
	end

	local DiscountTag = p30:FindFirstChild("DiscountTag")

	if DiscountTag then
		DiscountTag.Visible = IsDiscounted
	end

	self[p30] = {
		asset = p31,
		config = p32
	}
	scheduleSaleRefresh()
end

local u39 = nil
local u40 = nil

function t4.OnTransitionState(b17: boolean) -- line: 1266
	-- upvalues: t4 (copy), u40 (ref), u39 (ref), Lighting (copy), Util (copy), LocalPlayer (copy), TweenService (copy), Debris (copy)
	local ShopMenu = t4.ShopMenu

	if b17 then
		if u40 then
			u40:Destroy()
			u40 = nil
		end

		if u39 then
			u39:Destroy()
			u39 = nil
		end

		ShopMenu.Menu.Position = UDim2.fromScale(0.5, 0.55)
		ShopMenu.Menu.Size = UDim2.fromScale(1, 1)
		ShopMenu.Menu.Visible = true

		local BlurEffect = Instance.new("BlurEffect")

		BlurEffect.Name = "ShopBlur"
		BlurEffect.Size = 0
		BlurEffect.Parent = Lighting
		u40 = BlurEffect
		u39 = Util:CreateFOVMultiplier(LocalPlayer, 1, "ShopZoom")
		TweenService:Create(BlurEffect, TweenInfo.new(0.225, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = 12
		}):Play()
		TweenService:Create(u39, TweenInfo.new(0.225, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Value = 0.85
		}):Play()
		TweenService:Create(ShopMenu.Menu, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Position = UDim2.fromScale(0.5, 0.5)
		}):Play()
	else
		ShopMenu.Menu.Visible = false

		local v188 = u39
		local v189 = u40

		if u39 then
			TweenService:Create(u39, TweenInfo.new(0.225, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Value = 1
			}):Play()
		end

		if v189 then
			TweenService:Create(v189, TweenInfo.new(0.225, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Size = 0
			}):Play()
		end

		if v189 then
			Debris:AddItem(v189, 0.225)
		end

		if v188 then
			Debris:AddItem(v188, 0.225)
		end
	end

	local v190 = `OnWindow{ not b17 and "Closed" or "Opened" }`
	local v191 = t4.TabLogic[t4.LastTab or ""]

	if v191 and v191[v190] then
		local ok, result = pcall(v191[v190], v191)

		if not ok then
			warn(`[{ script }]: Failed to run { v190 }() for tab: { t4.LastTab }, got: { result }`)
		end
	end
end
function t4.SwitchTab(_: {[any]: any}, s1: string) -- line: 1351
 if s1=="Robux"or s1=="Featured"then s1="Skins"end
	-- upvalues: t4 (copy), t1 (copy), transitionHighlightToState (copy), transitionToFrame (copy)
	if s1 == t4.LastTab then
		return
	end

	local Menu = t4.ShopMenu.Menu
	local TabButtons = Menu.Holder.TabButtons
	local v198 = t4.LastTab and TabButtons:FindFirstChild(t4.LastTab)
	local s1_2 = TabButtons:FindFirstChild(s1)

	if not s1_2 then
		warn(`[{ script }]: No tab found for: { s1 }`)

		return
	end

	if v198 then
		if t1[v198] then
			return
		end

		transitionHighlightToState(v198, false)
	end

	local s1_3 = Menu.Holder.Page:FindFirstChild(s1)
	local v201 = t4.LastTab and Menu.Holder.Page:FindFirstChild(t4.LastTab)
	local v202 = (v198 and v198.LayoutOrder or 0) > s1_2.LayoutOrder

	transitionToFrame(v201, s1_3, v202)
	transitionHighlightToState(s1_2, true)

	local v203 = t4.TabLogic[t4.LastTab]

	if v203 and v203.OnTabSwitched then
		local ok, result = pcall(v203.OnTabSwitched, v203)

		if not ok then
			warn(`[{ script }]: Failed to run OnTabSwitched() for tab: { t4.LastTab }, got: { result }`)
		end
	end

	local v206 = t4.TabLogic[s1]

	if v206 and v206.OnTabOpened then
		local ok, result = pcall(v206.OnTabOpened, v206)

		if not ok then
			warn(`[{ script }]: Failed to run OnTabOpened() for tab: { t4.LastTab }, got: { result }`)
		end
	end

	t4.LastTab = s1
end

local u41 = false

function t4.Start(_) -- line: 1401
	-- upvalues: u41 (ref), t4 (copy), CurrencyDisplay (copy), TweenService (copy), Sounds (copy), NotFound (copy), t9 (copy), setupViewportRig (copy)
	if u41 then
		return
	end

	u41 = true

	local EventHandlerClient = require(game.ReplicatedStorage.Modules.EventHandlerClient)

	if not EventHandlerClient:GetInfo() then
		EventHandlerClient.onEventInfoGiven:Wait()
		EventHandlerClient:GetInfo()
	end

	t4.ShopMenu = require(game.ReplicatedStorage.Initializer).PlayerSystems.SidebarHandler:CreateSidebarMenu("Shop", script.Shop)
	t4.Tabs = {}
	t4.TabLogic = {}

	local Menu = t4.ShopMenu.Menu

	os.clock()
	CurrencyDisplay.new("Money", "rbxassetid://132413181315189", false).Instance.Parent = Menu.Holder.Currency

	local Close = Menu.Holder.Close

	Close.MouseEnter:Connect(function() -- line: 1438
		-- upvalues: TweenService (copy), Close (copy), Sounds (copy)
		TweenService:Create(Close, TweenInfo.new(0.25), {
			Size = UDim2.fromScale(0.105, 0.105)
		}):Play()
		Sounds:Play("hover")
	end)
	Close.MouseLeave:Connect(function() -- line: 1450
		-- upvalues: TweenService (copy), Close (copy), Sounds (copy)
		TweenService:Create(Close, TweenInfo.new(0.25), {
			Size = UDim2.fromScale(0.071, 0.092)
		}):Play()
		Sounds:Play("hoverEnd")
	end)
	Close.MouseButton1Down:Connect(function() -- line: 1462
		-- upvalues: t4 (copy), Sounds (copy)
		t4.ShopMenu:ToggleMenu(false)
		Sounds:Play("click")
	end)
	Menu.Holder.Page:ClearAllChildren()

	local function isTabRejected(b18: boolean, s2: string, p34, s3: string?) -- line: 1470
		-- upvalues: NotFound (copy), Menu (copy), t4 (copy)
		if b18 then
			return nil
		end

		warn(`[{ script }]: Tab '{ s2 }' rejected during '{ s3 or "unknown" }' stage.`)

		if p34 then
			warn(`[{ script }]: Response: { p34 }`)
		end

		local clone = NotFound:Clone()

		clone.Name = s2
		clone.Parent = Menu.Holder.Page
		clone.Position = UDim2.fromScale(1, 0)
		t4.Tabs[s2] = clone

		return clone
	end

	for _, child in Menu.Holder.TabButtons:GetChildren() do
		if child:IsA("TextButton") then
            child.Size=UDim2.fromScale(0.475,0.732)
			child.MouseEnter:Connect(function() -- line: 1496
				-- upvalues: TweenService (copy), child (copy), Sounds (copy)
				TweenService:Create(child, TweenInfo.new(0.25), {
					Size = UDim2.fromScale(0.5, 0.75)
				}):Play()
				Sounds:Play("hover")
			end)
			child.MouseLeave:Connect(function() -- line: 1508
				-- upvalues: TweenService (copy), child (copy), Sounds (copy)
				TweenService:Create(child, TweenInfo.new(0.25), {
					Size = UDim2.fromScale(0.475, 0.732)
				}):Play()
				Sounds:Play("hoverEnd")
			end)
			child.MouseButton1Down:Connect(function() -- line: 1520
				-- upvalues: t4 (copy), child (copy), Sounds (copy)
				t4:SwitchTab(child.Name)
				Sounds:Play("click")
			end)

			local childName = child.Name
			local childName2 = script.Tabs:FindFirstChild(childName)

			if not isTabRejected(childName2 ~= nil, childName, "no ModuleScript found", "lookup") then
				local ok, result = xpcall(function() -- line: 1531
					-- upvalues: childName2 (copy)
					return require(childName2)
				end, debug.traceback)

				if not isTabRejected(ok, childName, result, "require") then
					local ok3, result3 = xpcall(function() -- line: 1536
						-- upvalues: result (copy), t9 (copy)
						return result.new(t9)
					end, debug.traceback)

					if not isTabRejected(ok3, childName, result3, "new()") then
						result3.Name = childName
						result3.Parent = Menu.Holder.Page
						result3.Position = UDim2.fromScale(1, 0)
						t4.TabLogic[childName] = result
						t4.Tabs[childName] = result3
					end
				end
			end
		end
	end

	setupViewportRig()
	t9.OnPurchased:Connect(function() -- line: 1551
		-- upvalues: t9 (copy)
		t9:ClearConfirmationUI()
	end)
	t4:SwitchTab("Skins")
end

return t4
]========]},
{path=[========[
ReplicatedStorage/Systems/Player/UI/Menus/UpdateLog]========],before=[========[
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local _ = LocalPlayer.PlayerGui
local DataHandler = require(ReplicatedStorage.Modules.DataHandler)
local Network = require(ReplicatedStorage.Modules.Network)
local Sounds = require(ReplicatedStorage.Modules.Sounds)
local Util = require(ReplicatedStorage.Modules.Util)
local DiscordMarkdown = require(script.DiscordMarkdown)
local UpdatelogPresets = ReplicatedStorage.Assets.UI.UpdatelogPresets
local Changelogs = ReplicatedStorage.Assets.Changelogs
local __createComponent = nil
local t4 = {
	TextTemplate = function(t1: {[any]: any}, p1) -- line: 26
		p1.Text = t1.Content
	end,
	ImageTemplate = function(t2: {[any]: any}, p2) -- line: 30
		p2.Image = t2.Content
		p2.Subtitle.Text = t2.Text
	end,
	ItemsTemplate = function(t3: {[any]: any}, p3) -- line: 35
		-- upvalues: __createComponent (ref)
		for i, v in ipairs(t3.Content) do
			local v35 = __createComponent(v, p3)

			if v35 then
				v35.LayoutOrder = i
				v35.Parent = p3
			end
		end
	end
}
local LatestLog = Changelogs:GetAttribute("LatestLog")
local TextTitle = nil
local t5 = {}

local function __toYYMMDD(p4) -- line: 53
	local v37, v38, v39 = p4:match("(%d+)-(%d+)-(%d+)")

	return string.format("%02d%02d%02d", tonumber(v39), tonumber(v37), (tonumber(v38)))
end
local function __generateLegacyLayout(t6: {[any]: any}, p5) -- line: 58
	-- upvalues: UpdatelogPresets (copy)
	local n1 = 0

	for i = 1, #t6.Notes do
		local v44 = t6.Notes[i]
		local clone = UpdatelogPresets.Components.Header:Clone()

		clone.Text = v44.Header
		clone.LayoutOrder = n1
		clone.Parent = p5

		local clone2 = UpdatelogPresets.Components.Seperator:Clone()

		clone2.LayoutOrder = n1 + 1
		clone2.Parent = p5

		local clone3 = UpdatelogPresets.Components.TextPreset:Clone()

		clone3.Main.Text = v44.Body
		clone3.Size = v44.NoteSize or UDim2.fromScale(0.9, 0.25)
		clone3.LayoutOrder = n1 + 2
		clone3.Parent = p5
		n1 += 3
	end
end

function __createComponent(t7: {[any]: any}, p6) -- line: 82
	-- upvalues: t4 (copy)
	local t7Type = script.Presets.Components:FindFirstChild(t7.Type)

	if not t7Type then
		warn(`[{ script }]: Invalid component type: { t7.Type }`)

		return nil
	end

	local clone = t7Type:Clone()
	local v52 = t4[t7.Type]

	if v52 then
		local ok, result = pcall(v52, t7, clone)

		if not ok then
			warn(`[{ script }]: Failed to run callback for component: { t7.Type }, { debug.traceback(result) }`)
		end
	end

	for k, v in next, t7.Style or {} do
		clone[k] = v
	end

	clone.Parent = p6

	return clone
end

local function __generateLayout(t8: {[any]: any}, p7) -- line: 107
	-- upvalues: __createComponent (ref)
	local clone = script.Presets.UpdateDisplayTemplate:Clone()
	local n2 = 0

	local function __increment() -- line: 111
		-- upvalues: n2 (ref)
		n2 += 1
	end

	for _, v in ipairs(t8) do
		local clone4 = script.Presets.Components.SubheaderTemplate:Clone()

		clone4.Header.Text = v.Header
		clone4.LayoutOrder = n2
		clone4.Parent = clone
		n2 += 1

		for _, v2 in ipairs(v.Content) do
			local v67 = __createComponent(v2, clone)

			if v67 then
				v67.LayoutOrder = n2
				n2 += 1
			end
		end
	end

	clone.Parent = p7
end
local function __switchPage(p8, t9: {[any]: any}) -- line: 139
	-- upvalues: DiscordMarkdown (copy), __generateLegacyLayout (copy), __generateLayout (copy)
	assert(typeof(t9) == "table", "meta is not a table!")
 if not t9.Markdown and t9.Notes and t9.Notes[1]and t9.Notes[1].Body then t9.IsLegacy=true end

	for _, v in next, p8.Holder.List:GetChildren() do
		if v:IsA("Frame") or v:IsA("TextLabel") then
			v:Destroy()
		end
	end

	local clone = script.Presets.Loading:Clone()

	clone.Parent = p8.Holder

	local clone5 = script.Presets.Components.HeaderTemplate:Clone()

	clone5.Background.Image = t9.TitleMeta.Image.Backdrop or t9.TitleMeta.Image.Large or t9.TitleMeta.Image.Title or ""
	clone5.Header.Text = t9.TitleMeta.Text.Title or "N/A"
	clone5.Description.Text = t9.TitleMeta.Text.Description or (t9.TitleMeta.Text.Date or "None Provided")
	clone5.LayoutOrder = -10
	clone5.Parent = p8.Holder.List

	if t9.Markdown then
		DiscordMarkdown.Render(t9.Markdown, p8.Holder.List)
	elseif t9.IsLegacy then
		__generateLegacyLayout(t9, p8.Holder.List)
	else
		__generateLayout(t9.Notes, p8.Holder.List)
	end

	clone:Destroy()
end

local t10 = {
	Menu = nil
}
local u25 = nil
local u26 = nil

function t10.OnTransitionState(b1: boolean) -- line: 175
	-- upvalues: t10 (copy), u26 (ref), u25 (ref), Lighting (copy), Util (copy), LocalPlayer (copy), TweenService (copy), Debris (copy)
	local Menu = t10.UpdateLogMenu.Menu

	if b1 then
		if u26 then
			u26:Destroy()
			u26 = nil
		end

		if u25 then
			u25:Destroy()
			u25 = nil
		end

		Menu.Position = UDim2.fromScale(0.5, 0.55)
		Menu.Size = UDim2.fromScale(1, 1.15)
		Menu.Visible = true

		local BlurEffect = Instance.new("BlurEffect")

		BlurEffect.Name = "ShopBlur"
		BlurEffect.Size = 0
		BlurEffect.Parent = Lighting
		u26 = BlurEffect
		u25 = Util:CreateFOVMultiplier(LocalPlayer, 1, "ShopZoom")
		TweenService:Create(BlurEffect, TweenInfo.new(0.225, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = 12
		}):Play()
		TweenService:Create(u25, TweenInfo.new(0.225, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Value = 0.85
		}):Play()
		TweenService:Create(Menu, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Position = UDim2.fromScale(0.5, 0.5)
		}):Play()

		return
	end

	Menu.Visible = false

	local v77 = u25
	local v78 = u26

	if u25 then
		TweenService:Create(u25, TweenInfo.new(0.225, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Value = 1
		}):Play()
	end

	if v78 then
		TweenService:Create(v78, TweenInfo.new(0.225, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = 0
		}):Play()
	end

	if v78 then
		Debris:AddItem(v78, 0.225)
	end

	if v77 then
		Debris:AddItem(v77, 0.225)
	end
end
function t10.Start(_) -- line: 251
	-- upvalues: ReplicatedStorage (copy), t10 (copy), DataHandler (copy), LatestLog (copy), TweenService (copy), Sounds (copy), Network (copy), Changelogs (copy), TextTitle (ref), __switchPage (copy), t5 (copy)
	task.spawn(function() -- line: 252
		-- upvalues: ReplicatedStorage (copy), t10 (copy), DataHandler (copy), LatestLog (copy), TweenService (copy), Sounds (copy), Network (copy), Changelogs (copy), TextTitle (ref), __switchPage (copy), t5 (copy)
		t10.UpdateLogMenu = require(ReplicatedStorage.Initializer).PlayerSystems.SidebarHandler:CreateSidebarMenu("UpdateLog", script.UpdateScreen)


		local Menu = t10.UpdateLogMenu.Menu
		local Close = Menu.Holder.Close

		Close.MouseEnter:Connect(function() -- line: 264
			-- upvalues: TweenService (copy), Close (copy), Sounds (copy)
			TweenService:Create(Close, TweenInfo.new(0.25), {
				Size = UDim2.fromScale(0.105, 0.105)
			}):Play()
			Sounds:Play("hover")
		end)
		Close.MouseLeave:Connect(function() -- line: 276
			-- upvalues: TweenService (copy), Close (copy), Sounds (copy)
			TweenService:Create(Close, TweenInfo.new(0.25), {
				Size = UDim2.fromScale(0.074, 0.095)
			}):Play()
			Sounds:Play("hoverEnd")
		end)
		Close.MouseButton1Down:Connect(function() -- line: 288
			-- upvalues: t10 (copy), Network (copy), Sounds (copy)
			t10.UpdateLogMenu:ToggleMenu(false)
			Network:FireServerConnection("UpdateLogToLatest", "REMOTE_EVENT")
			Sounds:Play("click")
		end)

		for _, v in next, Changelogs:GetChildren() do
			local ok, result = pcall(function() -- line: 295
				-- upvalues: v (copy)
				return require(v)
			end)

			if not ok then
				warn(`Failed to load changelog { v.Name }: { result }`)
			else
				local clone = script.Presets.UpdateTemplate:Clone()

				clone.Name = result.TitleMeta.Text.Title
				clone.UpdateName.Text = result.TitleMeta.Text.Title or "N/A"
				clone.Description.Text = result.TitleMeta.Text.Description or (result.TitleMeta.Text.Date or "None Provided")
				clone.Render.Image = result.TitleMeta.Image.Backdrop or result.TitleMeta.Image.Small or result.TitleMeta.Image.Title or ""

				local v87, v88, v89 = result.TitleMeta.Text.Date:match("(%d+)-(%d+)-(%d+)")

				clone.LayoutOrder = -string.format("%02d%02d%02d", tonumber(v89), tonumber(v87), (tonumber(v88)))
				clone.Parent = Menu.List.Updates
				clone.MouseEnter:Connect(function() -- line: 312
					-- upvalues: Sounds (copy)
					Sounds:Play("hover")
				end)
				clone.MouseLeave:Connect(function() -- line: 316
					-- upvalues: Sounds (copy)
					Sounds:Play("hoverEnd")
				end)
				clone.MouseButton1Down:Connect(function() -- line: 320
					-- upvalues: TextTitle (ref), result (copy), __switchPage (copy), Menu (copy), Sounds (copy)
					if TextTitle == result.TitleMeta.Text.Title then
						return
					end

					TextTitle = result.TitleMeta.Text.Title
					__switchPage(Menu, result)
					Sounds:Play("click")
				end)
				t5[v.Name] = result
			end
		end

		if t5[LatestLog]then __switchPage(Menu, t5[LatestLog])end
        if t5[LatestLog]and DataHandler:Get().Misc.LastSeenLog.Value ~= LatestLog then t10.UpdateLogMenu:ToggleMenu(true)end
	end)
end

return t10
]========],after=[========[
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local _ = LocalPlayer.PlayerGui
local DataHandler = require(ReplicatedStorage.Modules.DataHandler)
local Network = require(ReplicatedStorage.Modules.Network)
local Sounds = require(ReplicatedStorage.Modules.Sounds)
local Util = require(ReplicatedStorage.Modules.Util)
local DiscordMarkdown = require(script.DiscordMarkdown)
local UpdatelogPresets = ReplicatedStorage.Assets.UI.UpdatelogPresets
local Changelogs = ReplicatedStorage.Assets.Changelogs
local __createComponent = nil
local t4 = {
	TextTemplate = function(t1: {[any]: any}, p1) -- line: 26
		p1.Text = t1.Content
	end,
	ImageTemplate = function(t2: {[any]: any}, p2) -- line: 30
		p2.Image = t2.Content
		p2.Subtitle.Text = t2.Text
	end,
	ItemsTemplate = function(t3: {[any]: any}, p3) -- line: 35
		-- upvalues: __createComponent (ref)
		for i, v in ipairs(t3.Content) do
			local v35 = __createComponent(v, p3)

			if v35 then
				v35.LayoutOrder = i
				v35.Parent = p3
			end
		end
	end
}
local LatestLog = Changelogs:GetAttribute("LatestLog")
local TextTitle = nil
local t5 = {}
local latestOrder = math.huge
local latestKey = nil

local function __toYYMMDD(p4) -- line: 53
	local v37, v38, v39 = p4:match("(%d+)-(%d+)-(%d+)")

	return string.format("%02d%02d%02d", tonumber(v39), tonumber(v37), (tonumber(v38)))
end
local function __generateLegacyLayout(t6: {[any]: any}, p5) -- line: 58
	-- upvalues: UpdatelogPresets (copy)
	local n1 = 0

	for i = 1, #t6.Notes do
		local v44 = t6.Notes[i]
		local clone = UpdatelogPresets.Components.Header:Clone()

		clone.Text = v44.Header
		clone.LayoutOrder = n1
		clone.Parent = p5

		local clone2 = UpdatelogPresets.Components.Seperator:Clone()

		clone2.LayoutOrder = n1 + 1
		clone2.Parent = p5

		local clone3 = UpdatelogPresets.Components.TextPreset:Clone()

		clone3.Main.Text = v44.Body
		clone3.Size = v44.NoteSize or UDim2.fromScale(0.9, 0.25)
		clone3.LayoutOrder = n1 + 2
		clone3.Parent = p5
		n1 += 3
	end
end

function __createComponent(t7: {[any]: any}, p6) -- line: 82
	-- upvalues: t4 (copy)
	local t7Type = script.Presets.Components:FindFirstChild(t7.Type)

	if not t7Type then
		warn(`[{ script }]: Invalid component type: { t7.Type }`)

		return nil
	end

	local clone = t7Type:Clone()
	local v52 = t4[t7.Type]

	if v52 then
		local ok, result = pcall(v52, t7, clone)

		if not ok then
			warn(`[{ script }]: Failed to run callback for component: { t7.Type }, { debug.traceback(result) }`)
		end
	end

	for k, v in next, t7.Style or {} do
		clone[k] = v
	end

	clone.Parent = p6

	return clone
end

local function __generateLayout(t8: {[any]: any}, p7) -- line: 107
	-- upvalues: __createComponent (ref)
	local clone = script.Presets.UpdateDisplayTemplate:Clone()
	local n2 = 0

	local function __increment() -- line: 111
		-- upvalues: n2 (ref)
		n2 += 1
	end

	for _, v in ipairs(t8) do
		local clone4 = script.Presets.Components.SubheaderTemplate:Clone()

		clone4.Header.Text = v.Header
		clone4.LayoutOrder = n2
		clone4.Parent = clone
		n2 += 1

		for _, v2 in ipairs(v.Content) do
			local v67 = __createComponent(v2, clone)

			if v67 then
				v67.LayoutOrder = n2
				n2 += 1
			end
		end
	end

	clone.Parent = p7
end
local function __switchPage(p8, t9: {[any]: any}) -- line: 139
	-- upvalues: DiscordMarkdown (copy), __generateLegacyLayout (copy), __generateLayout (copy)
	assert(typeof(t9) == "table", "meta is not a table!")
 if not t9.Markdown and t9.Notes and t9.Notes[1]and t9.Notes[1].Body then t9.IsLegacy=true end

	for _, v in next, p8.Holder.List:GetChildren() do
		if v:IsA("Frame") or v:IsA("TextLabel") then
			v:Destroy()
		end
	end

	local clone = script.Presets.Loading:Clone()

	clone.Parent = p8.Holder

	local clone5 = script.Presets.Components.HeaderTemplate:Clone()

	clone5.Background.Image = t9.TitleMeta.Image.Backdrop or t9.TitleMeta.Image.Large or t9.TitleMeta.Image.Title or ""
	clone5.Header.Text = t9.TitleMeta.Text.Title or "N/A"
	clone5.Description.Text = t9.TitleMeta.Text.Description or (t9.TitleMeta.Text.Date or "None Provided")
	clone5.LayoutOrder = -10
	clone5.Parent = p8.Holder.List

	if t9.Markdown then
		DiscordMarkdown.Render(t9.Markdown, p8.Holder.List)
	elseif t9.IsLegacy then
		__generateLegacyLayout(t9, p8.Holder.List)
	else
		__generateLayout(t9.Notes, p8.Holder.List)
	end

	clone:Destroy()
end

local t10 = {
	Menu = nil
}
local u25 = nil
local u26 = nil

function t10.OnTransitionState(b1: boolean) -- line: 175
	-- upvalues: t10 (copy), u26 (ref), u25 (ref), Lighting (copy), Util (copy), LocalPlayer (copy), TweenService (copy), Debris (copy)
	local Menu = t10.UpdateLogMenu.Menu

	if b1 then
		if u26 then
			u26:Destroy()
			u26 = nil
		end

		if u25 then
			u25:Destroy()
			u25 = nil
		end

		Menu.Position = UDim2.fromScale(0.5, 0.55)
		Menu.Size = UDim2.fromScale(1, 1.15)
		Menu.Visible = true

		local BlurEffect = Instance.new("BlurEffect")

		BlurEffect.Name = "ShopBlur"
		BlurEffect.Size = 0
		BlurEffect.Parent = Lighting
		u26 = BlurEffect
		u25 = Util:CreateFOVMultiplier(LocalPlayer, 1, "ShopZoom")
		TweenService:Create(BlurEffect, TweenInfo.new(0.225, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = 12
		}):Play()
		TweenService:Create(u25, TweenInfo.new(0.225, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Value = 0.85
		}):Play()
		TweenService:Create(Menu, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Position = UDim2.fromScale(0.5, 0.5)
		}):Play()

		return
	end

	Menu.Visible = false

	local v77 = u25
	local v78 = u26

	if u25 then
		TweenService:Create(u25, TweenInfo.new(0.225, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Value = 1
		}):Play()
	end

	if v78 then
		TweenService:Create(v78, TweenInfo.new(0.225, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = 0
		}):Play()
	end

	if v78 then
		Debris:AddItem(v78, 0.225)
	end

	if v77 then
		Debris:AddItem(v77, 0.225)
	end
end
function t10.Start(_) -- line: 251
	-- upvalues: ReplicatedStorage (copy), t10 (copy), DataHandler (copy), LatestLog (copy), TweenService (copy), Sounds (copy), Network (copy), Changelogs (copy), TextTitle (ref), __switchPage (copy), t5 (copy)
	task.spawn(function() -- line: 252
		-- upvalues: ReplicatedStorage (copy), t10 (copy), DataHandler (copy), LatestLog (copy), TweenService (copy), Sounds (copy), Network (copy), Changelogs (copy), TextTitle (ref), __switchPage (copy), t5 (copy)
		t10.UpdateLogMenu = require(ReplicatedStorage.Initializer).PlayerSystems.SidebarHandler:CreateSidebarMenu("UpdateLog", script.UpdateScreen)


		local Menu = t10.UpdateLogMenu.Menu
		local Close = Menu.Holder.Close

		Close.MouseEnter:Connect(function() -- line: 264
			-- upvalues: TweenService (copy), Close (copy), Sounds (copy)
			TweenService:Create(Close, TweenInfo.new(0.25), {
				Size = UDim2.fromScale(0.105, 0.105)
			}):Play()
			Sounds:Play("hover")
		end)
		Close.MouseLeave:Connect(function() -- line: 276
			-- upvalues: TweenService (copy), Close (copy), Sounds (copy)
			TweenService:Create(Close, TweenInfo.new(0.25), {
				Size = UDim2.fromScale(0.074, 0.095)
			}):Play()
			Sounds:Play("hoverEnd")
		end)
		Close.MouseButton1Down:Connect(function() -- line: 288
			-- upvalues: t10 (copy), Network (copy), Sounds (copy)
			t10.UpdateLogMenu:ToggleMenu(false)
			Network:FireServerConnection("UpdateLogToLatest", "REMOTE_EVENT")
			Sounds:Play("click")
		end)

		for _, v in next, Changelogs:GetChildren() do
			local ok, result = pcall(function() -- line: 295
				-- upvalues: v (copy)
				return require(v)
			end)

			if not ok then
				warn(`Failed to load changelog { v.Name }: { result }`)
			else
				local clone = script.Presets.UpdateTemplate:Clone()

				clone.Name = result.TitleMeta.Text.Title
				clone.UpdateName.Text = result.TitleMeta.Text.Title or "N/A"
				clone.Description.Text = result.TitleMeta.Text.Description or (result.TitleMeta.Text.Date or "None Provided")
				clone.Render.Image = result.TitleMeta.Image.Backdrop or result.TitleMeta.Image.Small or result.TitleMeta.Image.Title or ""

				local v87, v88, v89 = result.TitleMeta.Text.Date:match("(%d+)-(%d+)-(%d+)")

				clone.LayoutOrder = -string.format("%02d%02d%02d", tonumber(v89), tonumber(v87), (tonumber(v88)))
				clone.Parent = Menu.List.Updates
                if clone.LayoutOrder < latestOrder or (clone.LayoutOrder == latestOrder and (not latestKey or v.Name > latestKey)) then
                    latestOrder = clone.LayoutOrder
                    latestKey = v.Name
                end
				clone.MouseEnter:Connect(function() -- line: 312
					-- upvalues: Sounds (copy)
					Sounds:Play("hover")
				end)
				clone.MouseLeave:Connect(function() -- line: 316
					-- upvalues: Sounds (copy)
					Sounds:Play("hoverEnd")
				end)
				clone.MouseButton1Down:Connect(function() -- line: 320
					-- upvalues: TextTitle (ref), result (copy), __switchPage (copy), Menu (copy), Sounds (copy)
					if TextTitle == result.TitleMeta.Text.Title then
						return
					end

					__switchPage(Menu, result)
                    TextTitle = result.TitleMeta.Text.Title
					Sounds:Play("click")
				end)
				t5[v.Name] = result
			end
		end

		LatestLog = Changelogs:GetAttribute("LatestLog")
        if not t5[LatestLog] then LatestLog = latestKey end
        if t5[LatestLog] then
            __switchPage(Menu, t5[LatestLog])
            TextTitle = t5[LatestLog].TitleMeta.Text.Title
        end
        if t5[LatestLog]and DataHandler:Get().Misc.LastSeenLog.Value ~= LatestLog then t10.UpdateLogMenu:ToggleMenu(true)end
	end)
end

return t10
]========]},
{path=[========[
ReplicatedStorage/Modules/PlayerList]========],before=[========[
local t1 = {
	_players = {},
	DisplayedStats = {
		"Money",
		"KillerChance"
	},
	ListEnabled = true
}
local SocialService = game:GetService("SocialService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

game:GetService("TextChatService")

local v6 = RunService:IsStudio()
local clamp = math.clamp
local LocalPlayer = Players.LocalPlayer

require(game.ReplicatedStorage.Modules.Actors)

local DataHandler = require(game.ReplicatedStorage.Modules.DataHandler)
local Util = require(game.ReplicatedStorage.Modules.Util)
local Sounds = require(game.ReplicatedStorage.Modules.Sounds)
local Network = require(game.ReplicatedStorage.Modules.Network)
local t2 = {
	KillerChance = "Malice",
	RbxSpent = "R$ Spent"
}
local t3 = {
	PC = "rbxassetid://135066638879377",
	Mobile = "rbxassetid://89227325753198",
	Console = "rbxassetid://118447973769044",
	Unknown = "rbxassetid://94182197303121",
	NoChat = "rbxassetid://8509669675"
}

local function getPath(p1, s1: string, n1: number?) -- line: 51
	assert(typeof(p1) == "Instance")
	assert(typeof(s1) == "string")

	if s1 == "" then
		return p1
	end

	for _, v23 in (string.split(s1, "/")) do
		if typeof(n1) ~= "number" then
			p1 = p1:FindFirstChild(v23)

			if p1 ~= nil then
				continue
			end

			return
		end

		p1 = p1:WaitForChild(v23, n1)

		if p1 == nil then
			return
		end
	end

	return p1
end

function t1.GetPlayerListUI(p2) -- line: 76
	if not p2.PlayerList then
		repeat
			task.wait()
		until p2.PlayerList
	end

	return p2.PlayerList
end

local thread = nil
local u17 = true

function t1.TogglePlayerList(_, p4, p5) -- line: 85
	-- upvalues: t1 (copy), Sounds (copy), thread (ref), u17 (ref)
	if p5 then
		t1.ListEnabled = p4
	elseif not t1.ListEnabled then
		return
	end

	if not p5 then
		Sounds:Play("switch")
	end

	local PlayerListUI = t1:GetPlayerListUI()

	if thread then
		task.cancel(thread)
	end

	if p4 then
		u17 = true
		PlayerListUI.Close.Text = ">"
		PlayerListUI.Close.Visible = true
		PlayerListUI.Contents.Visible = true
		PlayerListUI.Background.Visible = true
		PlayerListUI.FriendBoost.Visible = true
		game.TweenService:Create(PlayerListUI, TweenInfo.new(0.15), {
			AnchorPoint = script.PlayerListHolder.AnchorPoint,
			Position = script.PlayerListHolder.Position
		}):Play()

		return
	end

	u17 = false
	PlayerListUI.Close.Text = "<"
	game.TweenService:Create(PlayerListUI, TweenInfo.new(0.15), {
		AnchorPoint = Vector2.new(),
		Position = UDim2.new(1, 0, 0, script.PlayerListHolder.Position.Y.Offset)
	}):Play()
	thread = task.delay(0.15, function() -- line: 116
		-- upvalues: p5 (copy), PlayerListUI (copy)
		if p5 then
			PlayerListUI.Close.Visible = false
		end

		PlayerListUI.Contents.Visible = false
		PlayerListUI.Background.Visible = false
		PlayerListUI.FriendBoost.Visible = false
	end)
end

local t4 = {}

function t1.ShowPlayerStats(t5: {[any]: any}, p6) -- line: 127
	-- upvalues: t4 (copy), Sounds (copy), t1 (copy), t3 (copy), DataHandler (copy), Util (copy), LocalPlayer (copy)
	for _, v in pairs(t4) do
		v:Disconnect()
	end

	table.clear(t4)

	if t5.__currentlyDisplayedStats and t5.__currentlyDisplayedStats.Parent then
		if tostring(t5.__currentlyDisplayedStats) == tostring(p6) then
			game.TweenService:Create(t5.__currentlyDisplayedStats, TweenInfo.new(0.15), {
				Size = UDim2.fromScale()
			}):Play()
			game.Debris:AddItem(t5.__currentlyDisplayedStats, 0.15)
			t5.__currentlyDisplayedStats = nil

			return
		end

		t5.__currentlyDisplayedStats:Destroy()
	end

	local clone = script.PlayerStats:Clone()

	clone.Name = tostring(p6)
	clone.Close.MouseEnter:Connect(function() -- line: 150
		-- upvalues: Sounds (copy)
		Sounds:Play("hover")
	end)
	clone.Close.MouseLeave:Connect(function() -- line: 151
		-- upvalues: Sounds (copy)
		Sounds:Play("hoverEnd")
	end)
	clone.Close.MouseButton1Click:Connect(function() -- line: 152
		-- upvalues: Sounds (copy), t1 (copy), p6 (copy)
		Sounds:Play("select")
		t1:ShowPlayerStats(p6)
	end)

	local v34 = `@{ p6.Name }`
	local v35 = p6.DisplayName ~= p6.Name and (p6.DisplayName ~= "" and p6.DisplayName)

	clone.BasicInfo.PlayerName.Text = v35 or v34
	clone.BasicInfo.PlayerUsername.Text = v34
	clone.BasicInfo.PlayerUsername.Visible = v35
	task.spawn(function() -- line: 164
		-- upvalues: p6 (copy), clone (copy)
		local UserId = p6.UserId
		local UserThumbnailAsync = game.Players:GetUserThumbnailAsync(UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)

		clone.PlayerIconHolder.Player.Image = UserThumbnailAsync
	end)

	local function updatePlayerDevice() -- line: 171
		-- upvalues: t3 (copy), p6 (copy), clone (copy)
		local v93 = t3[p6:GetAttribute("Device")] or t3.Unknown

		clone.PlayerIconHolder.Device.Image = v93
	end

	local v37 = t3[p6:GetAttribute("Device")] or t3.Unknown

	clone.PlayerIconHolder.Device.Image = v37
	table.insert(t4, p6:GetAttributeChangedSignal("Device"):Connect(updatePlayerDevice))

	local v38 = DataHandler:Get(p6)
	local v39 = v38 and v38:FindFirstChild("Stats")
	local v40 = v38 and v38:FindFirstChild("Equipped")

	if v39 and v40 then
		local General = v39:FindFirstChild("General")
		local v42 = General and General:FindFirstChild("TimePlayed")

		if v42 then
			local function updateTimePlayed() -- line: 256
				-- upvalues: Util (copy), p6 (copy), clone (copy), v42 (copy)
				local SettingValue = Util:GetSettingValue("HidePlaytime", p6)

				clone.TimePlayed.Text = `Time Played: { (if not SettingValue then Util:FormatTime(v42.Value, "Clock") else "<font color=\"rgb(125,125,125)\"><i>(Hidden)</i></font>") }`
			end

			local SettingValue = Util:GetSettingValue("HidePlaytime", p6)

			clone.TimePlayed.Text = `Time Played: { (if not SettingValue then Util:FormatTime(v42.Value, "Clock") else "<font color=\"rgb(125,125,125)\"><i>(Hidden)</i></font>") }`
			table.insert(t4, v42:GetPropertyChangedSignal("Value"):Connect(updateTimePlayed))
		end

		for _, v in pairs({
			"Killer",
			"Survivor"
		}) do
			local v47 = v39 and v39:FindFirstChild(`{ v }Stats`)
			local v48 = v47 and v47:FindFirstChild(`{ v }Kills`)

			if v48 then
				local SettingValue = Util:GetSettingValue(`Hide{ v }Wins`, p6)
				local v50 = clone.WinInfo:FindFirstChild(`{ v }Wins`)

				v50.MouseEnter:Connect(function() -- line: 275
					-- upvalues: Util (copy), v (copy), SettingValue (copy)
					Util:CreateTooltip(`{ v } Kills{ not SettingValue and "" or " <font color=\"rgb(125,125,125)\"><i>(Hidden)</i></font>" }`)
				end)
				v50.MouseLeave:Connect(function() -- line: 276
					-- upvalues: Util (copy)
					Util:CreateTooltip()
				end)

				local function setScore() -- line: 279
					-- upvalues: v50 (copy), SettingValue (copy), v48 (copy)
					v50.Wins.Text = if not SettingValue then v48.Value else "<font color=\"rgb(125,125,125)\"><i>(Hidden)</i></font>"
				end

				v50.Wins.Text = if not SettingValue then v48.Value else "<font color=\"rgb(125,125,125)\"><i>(Hidden)</i></font>"
				table.insert(t4, v48:GetPropertyChangedSignal("Value"):Connect(setScore))
			end

			if v40 then
				local t6 = {}

				local function setEquippedIcon() -- line: 292
					-- upvalues: p6 (copy), v (copy), t6 (ref), clone (copy), Util (copy)
					local v95, v96 = require(game.ReplicatedStorage.Modules.Actors):GetEquippedActorInfo(p6, v)
					local v97 = game.ReplicatedStorage.Assets:FindFirstChild(`{ v }s`):FindFirstChild(v95)
					local v98 = v97 and (v97:FindFirstChild("Config") and require(v97.Config))
					local v99 = game.ReplicatedStorage.Assets.Skins:FindFirstChild(`{ v }s`):FindFirstChild(v95)
					local v100 = v99 and v99:FindFirstChild(v96)
					local v101 = v100 and (v100:FindFirstChild("Config") and require(v100.Config))

					if v98 then
						for _, v2 in pairs(t6) do
							v2:Disconnect()
						end

						table.clear(t6)

						local v3 = clone.BasicInfo.EquippedCharacters:FindFirstChild(v)
						local u105 = `Equipped { v }: <i>{ v98.DisplayName or tostring(v97) }</i>`

						if v101 then
							u105 = `{ u105 }\nEquipped Skin: <i>{ v101.DisplayName or tostring(v100) }</i>`
						end

						v3.Image = v101 and v101.RenderImage or (v98.RenderImage or "rbxassetid://13373279056")
						t6 = {
							v3.MouseEnter:Connect(function() -- line: 316
								-- upvalues: Util (copy), u105 (ref)
								Util:CreateTooltip(u105)
							end),
							v3.MouseLeave:Connect(function() -- line: 317
								-- upvalues: Util (copy)
								Util:CreateTooltip()
							end)
						}
					end
				end

				local v4 = v40:FindFirstChild(v)
				local v5 = v40.Skins:FindFirstChild(v)

				setEquippedIcon()

				if v4 then
					table.insert(t4, v4:GetPropertyChangedSignal("Value"):Connect(setEquippedIcon))
				end

				if v5 then
					table.insert(t4, v5:GetPropertyChangedSignal("Value"):Connect(setEquippedIcon))
				end
			end
		end
	end

	if not t5.__currentlyDisplayedStats then
		clone.Size = UDim2.new()
		game.TweenService:Create(clone, TweenInfo.new(0.15), {
			Size = script.PlayerStats.Size
		}):Play()
	end

	clone.Parent = LocalPlayer.PlayerGui.TemporaryUI
	t5.__currentlyDisplayedStats = clone
	clone.AncestryChanged:Connect(function(_, parent) -- line: 345
		-- upvalues: Util (copy), t4 (copy)
		if not parent then
			Util:CreateTooltip()

			for _, v in pairs(t4) do
				v:Disconnect()
			end

			table.clear(t4)
		end
	end)
end
function t1.CreatePlayerInList(_: {[any]: any}, p8) -- line: 356
	-- upvalues: t1 (copy), Util (copy), Network (copy), v6 (copy)
	if not p8 then
		return
	end

	local PlayerListUI = t1:GetPlayerListUI()
	local v59 = PlayerListUI.Contents.Players:FindFirstChild((tostring(p8)))

	if v59 then
		v59:Destroy()
	end

	local clone = script.PlayerInfoContainer:Clone()

	clone.Name = tostring(p8)

	local p8Name = p8.Name
	local v62 = p8.DisplayName ~= p8.Name and (p8.DisplayName ~= "" and p8.DisplayName)

	local baseName = v62 or p8Name
	clone.PlayerInfo.Username.Text = baseName
	clone.PlayerInfo.Username.RichText = true

	local function updateAFKStatus()
		local afkValue = Util:GetSettingValue("AFK", p8)
		local isAFK = afkValue == true or (typeof(afkValue) == "number" and afkValue > 0)
		clone.PlayerInfo.Username.Text = isAFK and `{baseName} <font color="#B82500">[AFK]</font>` or baseName
	end

	task.spawn(function()
		local playerData = DataHandler:Get(p8)
		if not playerData then return end
		local settings = playerData:FindFirstChild("Settings")
		if not settings then return end
		local afkSetting = settings:FindFirstChild("AFK", true)
		if afkSetting then
			afkSetting:GetPropertyChangedSignal("Value"):Connect(updateAFKStatus)
		end
		updateAFKStatus()
	end)

	clone.ShowStats.MouseButton1Click:Connect(function() -- line: 375
		-- upvalues: t1 (copy), p8 (copy)
		t1:ShowPlayerStats(p8)
	end)

	if t1.DisplayedStats and t1.DisplayedStats[1] then
		local leaderstats = p8:WaitForChild("leaderstats", 30)

		if not leaderstats or not p8.Parent then
			return
		end

		for _, child in pairs(leaderstats:GetChildren()) do
			local clone2 = clone.PlayerInfo.Username:Clone()

			clone2.Name = child and child.Name
			clone2.Size = UDim2.fromScale(0.3, 1)
			clone2.LayoutOrder = table.find(t1.DisplayedStats, child.Name)
			clone2.TextXAlignment = Enum.TextXAlignment.Center
			clone2.Parent = clone.PlayerInfo

			local function updateStat() -- line: 396
				-- upvalues: child (copy), clone2 (copy), Util (copy)
				local v110 = child and child.Value or "?"

				if tonumber(v110) then
					clone2.TextColor3 = v110 > 0 and Color3.new(1, 1, 1) or Color3.new(1, 0, 0)
					v110 = Util:ConvertToAbbreviation(v110)
				end

				if v110.Name == "Money" then
					v110 = `${ v110 }`
				end

				clone2.Text = tostring(v110)
			end

			updateStat()

			if child then
				child:GetPropertyChangedSignal("Value"):Connect(updateStat)
			end
		end
	end

	local v68 = Network:FireServerConnection("ReturnCanChat", "REMOTE_FUNCTION", p8)

	if v6 or not v68 then
		clone.NoChat.Visible = true
		clone.NoChat.MouseEnter:Connect(function() -- line: 422
			-- upvalues: Util (copy)
			Util:CreateTooltip("You cannot communicate with this player.")
		end)
		clone.NoChat.MouseLeave:Connect(function() -- line: 425
			-- upvalues: Util (copy)
			Util:CreateTooltip()
		end)
	end

	clone.Parent = PlayerListUI.Contents.Players
	t1:__UpdateListSize()
end
function t1.RemovePlayerFromList(_: {[any]: any}, p9) -- line: 437
	-- upvalues: t1 (copy)
	local v71 = t1:GetPlayerListUI().Contents.Players:FindFirstChild((tostring(p9)))

	if v71 then
		v71:Destroy()
	end

	t1:__UpdateListSize()
end
function t1.__UpdateListSize(_) -- line: 450
	-- upvalues: t1 (copy)
	local PlayerListUI = t1:GetPlayerListUI()
	local UIListLayout = PlayerListUI.Contents.Players.UIListLayout
	local v75 = UIListLayout.AbsoluteContentSize.Y + UIListLayout.Padding.Offset

	PlayerListUI.Background.Size = UDim2.fromScale(1, (math.clamp(0.05 + 30 / PlayerListUI.AbsoluteSize.Y + v75 / PlayerListUI.AbsoluteSize.Y, 0, 1)))
	PlayerListUI.FriendBoost.Position = UDim2.fromScale(0, (math.clamp(0.05 + 30 / PlayerListUI.AbsoluteSize.Y + v75 / PlayerListUI.AbsoluteSize.Y, 0, 1)))
end
function t1.Start(p11) -- line: 460
	-- upvalues: LocalPlayer (copy), t1 (copy), t2 (copy), SocialService (copy), clamp (copy), Util (copy), u17 (ref), Sounds (copy)
	if game["Run Service"]:IsServer() then
		return
	end

	local clone = script.PlayerListHolder:Clone()
	local Contents = clone.Contents

	clone.Parent = LocalPlayer.PlayerGui:WaitForChild("MainUI")
	Contents:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 521
		-- upvalues: t1 (copy)
		t1:__UpdateListSize()
	end)

	for k, v in pairs(t1.DisplayedStats) do
		local clone3 = Contents.InfoTypes.Players:Clone()

		clone3.Name = v
		clone3.Text = t2[v] or v:gsub("(%l)(%u)", "%1 %2")
		clone3.Size = UDim2.fromScale(0.3, 1)
		clone3.LayoutOrder = k + 1
		clone3.TextXAlignment = Enum.TextXAlignment.Center
		clone3.Parent = Contents.InfoTypes
	end

	local _ = {
		JOINING = true,
		LEAVING = false
	}
	local ExperienceInviteOptions = Instance.new("ExperienceInviteOptions")

	ExperienceInviteOptions.PromptMessage = `Invite Friends, get { 10 }% more EXP per friend! (caps at { 20 }%).`

	local function __canSendInvite(p12) -- line: 547
		-- upvalues: SocialService (copy)
		local ok, result = pcall(function() -- line: 548
			-- upvalues: SocialService (copy), p12 (copy)
			return SocialService:CanSendGameInviteAsync(p12)
		end)

		return ok and result
	end

	local Button = clone.FriendBoost.Button

	Button.MouseButton1Down:Connect(function() -- line: 556
		-- upvalues: LocalPlayer (copy), SocialService (copy), ExperienceInviteOptions (copy)
		local v114 = LocalPlayer
		local ok, result = pcall(function() -- line: 548
			-- upvalues: SocialService (copy), v114 (copy)
			return SocialService:CanSendGameInviteAsync(v114)
		end)

		if ok and result then
			SocialService:PromptGameInvite(LocalPlayer, ExperienceInviteOptions)
		end
	end)

	local n2 = 0

	local function __setBoostDisplay(p13, b1: boolean) -- line: 564
		-- upvalues: LocalPlayer (copy), n2 (ref), clamp (copy), Button (copy)
		local ok, result = pcall(function() -- line: 566
			-- upvalues: LocalPlayer (copy), p13 (copy)
			return LocalPlayer:IsFriendsWith(p13.UserId)
		end)

		if ok and result then
			n2 = clamp(n2 + 10 * (not b1 and -1 or 1), 0, 20)
		end

		local v121 = `Invite Friends (+{ n2 }% EXP)`

		if v121 ~= Button.Text then
			Button.Text = v121
		end
	end

	Util.OnPlayerAdded(function(p14) -- line: 587
		-- upvalues: LocalPlayer (copy), n2 (ref), clamp (copy), Button (copy), t1 (copy)
		if p14 ~= LocalPlayer then
			local ok, result = pcall(function() -- line: 566
				-- upvalues: LocalPlayer (copy), p14 (copy)
				return LocalPlayer:IsFriendsWith(p14.UserId)
			end)

			if ok and result then
				n2 = clamp(n2 + 10, 0, 20)
			end

			local v125 = `Invite Friends (+{ n2 }% EXP)`

			if v125 ~= Button.Text then
				Button.Text = v125
			end
		end

		t1:CreatePlayerInList(p14)
	end)
	game.Players.PlayerRemoving:Connect(function(player) -- line: 596
		-- upvalues: LocalPlayer (copy), n2 (ref), clamp (copy), Button (copy), t1 (copy)
		if player ~= LocalPlayer then
			local ok, result = pcall(function() -- line: 566
				-- upvalues: LocalPlayer (copy), player (copy)
				return LocalPlayer:IsFriendsWith(player.UserId)
			end)

			if ok and result then
				n2 = clamp(n2 + -10, 0, 20)
			end

			local v129 = `Invite Friends (+{ n2 }% EXP)`

			if v129 ~= Button.Text then
				Button.Text = v129
			end
		end

		t1:RemovePlayerFromList(player)
	end)
	clone.Close.MouseButton1Click:Connect(function() -- line: 604
		-- upvalues: t1 (copy), u17 (ref)
		t1:TogglePlayerList(not u17)
	end)
	game.UserInputService.InputBegan:Connect(function(input, gameProcessed) -- line: 608
		-- upvalues: t1 (copy), u17 (ref)
		if gameProcessed then
			return
		end

		if input.KeyCode == Enum.KeyCode.Tab then
			t1:TogglePlayerList(not u17)
		end
	end)

	local function addSFX(p15) -- line: 616
		-- upvalues: Sounds (copy)
		if p15:IsA("ImageButton") or p15:IsA("TextButton") then
			p15.MouseEnter:Connect(function() -- line: 618
				-- upvalues: Sounds (copy)
				Sounds:Play("hover")
			end)
			p15.MouseLeave:Connect(function() -- line: 619
				-- upvalues: Sounds (copy)
				Sounds:Play("hoverEnd")
			end)
			p15.MouseButton1Click:Connect(function() -- line: 620
				-- upvalues: Sounds (copy)
				Sounds:Play("select")
			end)
		end
	end

	for _, descendant in pairs(clone:GetDescendants()) do
		addSFX(descendant)
	end

	clone.DescendantAdded:Connect(addSFX)
	p11.PlayerList = clone
	game.StarterGui:SetCoreGuiEnabled("PlayerList", false)
end

return t1

]========],after=[========[
local t1 = {
	_players = {},
	DisplayedStats = {
		"Money",
		"Kills"
	},
	ListEnabled = true
}
local SocialService = game:GetService("SocialService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

game:GetService("TextChatService")

local v6 = RunService:IsStudio()
local clamp = math.clamp
local LocalPlayer = Players.LocalPlayer

require(game.ReplicatedStorage.Modules.Actors)

local DataHandler = require(game.ReplicatedStorage.Modules.DataHandler)
local Util = require(game.ReplicatedStorage.Modules.Util)
local Sounds = require(game.ReplicatedStorage.Modules.Sounds)
local Network = require(game.ReplicatedStorage.Modules.Network)
local t2 = {
	Kills = "Kills",
	RbxSpent = "R$ Spent"
}
local t3 = {
	PC = "rbxassetid://135066638879377",
	Mobile = "rbxassetid://89227325753198",
	Console = "rbxassetid://118447973769044",
	Unknown = "rbxassetid://94182197303121",
	NoChat = "rbxassetid://8509669675"
}

local function getPath(p1, s1: string, n1: number?) -- line: 51
	assert(typeof(p1) == "Instance")
	assert(typeof(s1) == "string")

	if s1 == "" then
		return p1
	end

	for _, v23 in (string.split(s1, "/")) do
		if typeof(n1) ~= "number" then
			p1 = p1:FindFirstChild(v23)

			if p1 ~= nil then
				continue
			end

			return
		end

		p1 = p1:WaitForChild(v23, n1)

		if p1 == nil then
			return
		end
	end

	return p1
end

function t1.GetPlayerListUI(p2) -- line: 76
	if not p2.PlayerList then
		repeat
			task.wait()
		until p2.PlayerList
	end

	return p2.PlayerList
end

local thread = nil
local u17 = true

function t1.TogglePlayerList(_, p4, p5) -- line: 85
	-- upvalues: t1 (copy), Sounds (copy), thread (ref), u17 (ref)
	if p5 then
		t1.ListEnabled = p4
	elseif not t1.ListEnabled then
		return
	end

	if not p5 then
		Sounds:Play("switch")
	end

	local PlayerListUI = t1:GetPlayerListUI()

	if thread then
		task.cancel(thread)
	end

	if p4 then
		u17 = true
		PlayerListUI.Close.Text = ">"
		PlayerListUI.Close.Visible = true
		PlayerListUI.Contents.Visible = true
		PlayerListUI.Background.Visible = true
		PlayerListUI.FriendBoost.Visible = true
		game.TweenService:Create(PlayerListUI, TweenInfo.new(0.15), {
			AnchorPoint = script.PlayerListHolder.AnchorPoint,
			Position = script.PlayerListHolder.Position
		}):Play()

		return
	end

	u17 = false
	PlayerListUI.Close.Text = "<"
	game.TweenService:Create(PlayerListUI, TweenInfo.new(0.15), {
		AnchorPoint = Vector2.new(),
		Position = UDim2.new(1, 0, 0, script.PlayerListHolder.Position.Y.Offset)
	}):Play()
	thread = task.delay(0.15, function() -- line: 116
		-- upvalues: p5 (copy), PlayerListUI (copy)
		if p5 then
			PlayerListUI.Close.Visible = false
		end

		PlayerListUI.Contents.Visible = false
		PlayerListUI.Background.Visible = false
		PlayerListUI.FriendBoost.Visible = false
	end)
end

local t4 = {}

function t1.ShowPlayerStats(t5: {[any]: any}, p6) -- line: 127
	-- upvalues: t4 (copy), Sounds (copy), t1 (copy), t3 (copy), DataHandler (copy), Util (copy), LocalPlayer (copy)
	for _, v in pairs(t4) do
		v:Disconnect()
	end

	table.clear(t4)

	if t5.__currentlyDisplayedStats and t5.__currentlyDisplayedStats.Parent then
		if tostring(t5.__currentlyDisplayedStats) == tostring(p6) then
			game.TweenService:Create(t5.__currentlyDisplayedStats, TweenInfo.new(0.15), {
				Size = UDim2.fromScale()
			}):Play()
			game.Debris:AddItem(t5.__currentlyDisplayedStats, 0.15)
			t5.__currentlyDisplayedStats = nil

			return
		end

		t5.__currentlyDisplayedStats:Destroy()
	end

	local clone = script.PlayerStats:Clone()

	clone.Name = tostring(p6)
	clone.Close.MouseEnter:Connect(function() -- line: 150
		-- upvalues: Sounds (copy)
		Sounds:Play("hover")
	end)
	clone.Close.MouseLeave:Connect(function() -- line: 151
		-- upvalues: Sounds (copy)
		Sounds:Play("hoverEnd")
	end)
	clone.Close.MouseButton1Click:Connect(function() -- line: 152
		-- upvalues: Sounds (copy), t1 (copy), p6 (copy)
		Sounds:Play("select")
		t1:ShowPlayerStats(p6)
	end)

	local v34 = `@{ p6.Name }`
	local v35 = p6.DisplayName ~= p6.Name and (p6.DisplayName ~= "" and p6.DisplayName)

	clone.BasicInfo.PlayerName.Text = v35 or v34
	clone.BasicInfo.PlayerUsername.Text = v34
	clone.BasicInfo.PlayerUsername.Visible = v35
	task.spawn(function() -- line: 164
		-- upvalues: p6 (copy), clone (copy)
		local UserId = p6.UserId
		local UserThumbnailAsync = game.Players:GetUserThumbnailAsync(UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)

		clone.PlayerIconHolder.Player.Image = UserThumbnailAsync
	end)

	local function updatePlayerDevice() -- line: 171
		-- upvalues: t3 (copy), p6 (copy), clone (copy)
		local v93 = t3[p6:GetAttribute("Device")] or t3.Unknown

		clone.PlayerIconHolder.Device.Image = v93
	end

	local v37 = t3[p6:GetAttribute("Device")] or t3.Unknown

	clone.PlayerIconHolder.Device.Image = v37
	table.insert(t4, p6:GetAttributeChangedSignal("Device"):Connect(updatePlayerDevice))

	local v38 = DataHandler:Get(p6)
	local v39 = v38 and v38:FindFirstChild("Stats")
	local v40 = v38 and v38:FindFirstChild("Equipped")

	if v39 and v40 then
		local General = v39:FindFirstChild("General")
		local v42 = General and General:FindFirstChild("TimePlayed")

		if v42 then
			local function updateTimePlayed() -- line: 256
				-- upvalues: Util (copy), p6 (copy), clone (copy), v42 (copy)
				local SettingValue = Util:GetSettingValue("HidePlaytime", p6)

				clone.TimePlayed.Text = `Time Played: { (if not SettingValue then Util:FormatTime(v42.Value, "Clock") else "<font color=\"rgb(125,125,125)\"><i>(Hidden)</i></font>") }`
			end

			local SettingValue = Util:GetSettingValue("HidePlaytime", p6)

			clone.TimePlayed.Text = `Time Played: { (if not SettingValue then Util:FormatTime(v42.Value, "Clock") else "<font color=\"rgb(125,125,125)\"><i>(Hidden)</i></font>") }`
			table.insert(t4, v42:GetPropertyChangedSignal("Value"):Connect(updateTimePlayed))
		end

		for _, v in pairs({
			"Killer",
			"Survivor"
		}) do
			local v47 = v39 and v39:FindFirstChild(`{ v }Stats`)
			local v48 = v47 and v47:FindFirstChild(`{ v }Kills`)

			if v48 then
				local SettingValue = Util:GetSettingValue(`Hide{ v }Wins`, p6)
				local v50 = clone.WinInfo:FindFirstChild(`{ v }Wins`)

				v50.MouseEnter:Connect(function() -- line: 275
					-- upvalues: Util (copy), v (copy), SettingValue (copy)
					Util:CreateTooltip(`{ v } Kills{ not SettingValue and "" or " <font color=\"rgb(125,125,125)\"><i>(Hidden)</i></font>" }`)
				end)
				v50.MouseLeave:Connect(function() -- line: 276
					-- upvalues: Util (copy)
					Util:CreateTooltip()
				end)

				local function setScore() -- line: 279
					-- upvalues: v50 (copy), SettingValue (copy), v48 (copy)
					v50.Wins.Text = if not SettingValue then v48.Value else "<font color=\"rgb(125,125,125)\"><i>(Hidden)</i></font>"
				end

				v50.Wins.Text = if not SettingValue then v48.Value else "<font color=\"rgb(125,125,125)\"><i>(Hidden)</i></font>"
				table.insert(t4, v48:GetPropertyChangedSignal("Value"):Connect(setScore))
			end

			if v40 then
				local t6 = {}

				local function setEquippedIcon() -- line: 292
					-- upvalues: p6 (copy), v (copy), t6 (ref), clone (copy), Util (copy)
					local v95, v96 = require(game.ReplicatedStorage.Modules.Actors):GetEquippedActorInfo(p6, v)
					local v97 = game.ReplicatedStorage.Assets:FindFirstChild(`{ v }s`):FindFirstChild(v95)
					local v98 = v97 and (v97:FindFirstChild("Config") and require(v97.Config))
					local v99 = game.ReplicatedStorage.Assets.Skins:FindFirstChild(`{ v }s`):FindFirstChild(v95)
					local v100 = v99 and v99:FindFirstChild(v96)
					local v101 = v100 and (v100:FindFirstChild("Config") and require(v100.Config))

					if v98 then
						for _, v2 in pairs(t6) do
							v2:Disconnect()
						end

						table.clear(t6)

						local v3 = clone.BasicInfo.EquippedCharacters:FindFirstChild(v)
						local u105 = `Equipped { v }: <i>{ v98.DisplayName or tostring(v97) }</i>`

						if v101 then
							u105 = `{ u105 }\nEquipped Skin: <i>{ v101.DisplayName or tostring(v100) }</i>`
						end

						v3.Image = v101 and v101.RenderImage or (v98.RenderImage or "rbxassetid://13373279056")
						t6 = {
							v3.MouseEnter:Connect(function() -- line: 316
								-- upvalues: Util (copy), u105 (ref)
								Util:CreateTooltip(u105)
							end),
							v3.MouseLeave:Connect(function() -- line: 317
								-- upvalues: Util (copy)
								Util:CreateTooltip()
							end)
						}
					end
				end

				local v4 = v40:FindFirstChild(v)
				local v5 = v40.Skins:FindFirstChild(v)

				setEquippedIcon()

				if v4 then
					table.insert(t4, v4:GetPropertyChangedSignal("Value"):Connect(setEquippedIcon))
				end

				if v5 then
					table.insert(t4, v5:GetPropertyChangedSignal("Value"):Connect(setEquippedIcon))
				end
			end
		end
	end

	if not t5.__currentlyDisplayedStats then
		clone.Size = UDim2.new()
		game.TweenService:Create(clone, TweenInfo.new(0.15), {
			Size = script.PlayerStats.Size
		}):Play()
	end

	clone.Parent = LocalPlayer.PlayerGui.TemporaryUI
	t5.__currentlyDisplayedStats = clone
	clone.AncestryChanged:Connect(function(_, parent) -- line: 345
		-- upvalues: Util (copy), t4 (copy)
		if not parent then
			Util:CreateTooltip()

			for _, v in pairs(t4) do
				v:Disconnect()
			end

			table.clear(t4)
		end
	end)
end
function t1.CreatePlayerInList(_: {[any]: any}, p8) -- line: 356
	-- upvalues: t1 (copy), Util (copy), Network (copy), v6 (copy)
	if not p8 then
		return
	end

	local PlayerListUI = t1:GetPlayerListUI()
	local v59 = PlayerListUI.Contents.Players:FindFirstChild((tostring(p8)))

	if v59 then
		v59:Destroy()
	end

	local clone = script.PlayerInfoContainer:Clone()

	clone.Name = tostring(p8)

	local p8Name = p8.Name
	local v62 = p8.DisplayName ~= p8.Name and (p8.DisplayName ~= "" and p8.DisplayName)

	local baseName = v62 or p8Name
	clone.PlayerInfo.Username.Text = baseName
	clone.PlayerInfo.Username.RichText = true

	local function updateAFKStatus()
		local afkValue = Util:GetSettingValue("AFK", p8)
		local isAFK = afkValue == true or (typeof(afkValue) == "number" and afkValue > 0)
		clone.PlayerInfo.Username.Text = isAFK and `{baseName} <font color="#B82500">[AFK]</font>` or baseName
	end

	task.spawn(function()
		local playerData = DataHandler:Get(p8)
		if not playerData then return end
		local settings = playerData:FindFirstChild("Settings")
		if not settings then return end
		local afkSetting = settings:FindFirstChild("AFK", true)
		if afkSetting then
			afkSetting:GetPropertyChangedSignal("Value"):Connect(updateAFKStatus)
		end
		updateAFKStatus()
	end)

	clone.ShowStats.MouseButton1Click:Connect(function() -- line: 375
		-- upvalues: t1 (copy), p8 (copy)
		t1:ShowPlayerStats(p8)
	end)

	if t1.DisplayedStats and t1.DisplayedStats[1] then
		local leaderstats = p8:WaitForChild("leaderstats", 30)

		if not leaderstats or not p8.Parent then
			return
		end

		for _, child in pairs(leaderstats:GetChildren()) do
			local clone2 = clone.PlayerInfo.Username:Clone()

			clone2.Name = child and child.Name
			clone2.Size = UDim2.fromScale(0.3, 1)
			clone2.LayoutOrder = table.find(t1.DisplayedStats, child.Name)
			clone2.TextXAlignment = Enum.TextXAlignment.Center
			clone2.Parent = clone.PlayerInfo

			local function updateStat() -- line: 396
				-- upvalues: child (copy), clone2 (copy), Util (copy)
				local v110 = child and child.Value or "?"

				if tonumber(v110) then
					clone2.TextColor3 = v110 > 0 and Color3.new(1, 1, 1) or Color3.new(1, 0, 0)
					v110 = Util:ConvertToAbbreviation(v110)
				end

				if child.Name == "Money" then
					v110 = `${ v110 }`
				end

				clone2.Text = tostring(v110)
			end

			updateStat()

			if child then
				child:GetPropertyChangedSignal("Value"):Connect(updateStat)
			end
		end
	end

	local v68 = Network:FireServerConnection("ReturnCanChat", "REMOTE_FUNCTION", p8)

	if v6 or not v68 then
		clone.NoChat.Visible = true
		clone.NoChat.MouseEnter:Connect(function() -- line: 422
			-- upvalues: Util (copy)
			Util:CreateTooltip("You cannot communicate with this player.")
		end)
		clone.NoChat.MouseLeave:Connect(function() -- line: 425
			-- upvalues: Util (copy)
			Util:CreateTooltip()
		end)
	end

	clone.Parent = PlayerListUI.Contents.Players
	t1:__UpdateListSize()
end
function t1.RemovePlayerFromList(_: {[any]: any}, p9) -- line: 437
	-- upvalues: t1 (copy)
	local v71 = t1:GetPlayerListUI().Contents.Players:FindFirstChild((tostring(p9)))

	if v71 then
		v71:Destroy()
	end

	t1:__UpdateListSize()
end
function t1.__UpdateListSize(_) -- line: 450
	-- upvalues: t1 (copy)
	local PlayerListUI = t1:GetPlayerListUI()
	local UIListLayout = PlayerListUI.Contents.Players.UIListLayout
	local v75 = UIListLayout.AbsoluteContentSize.Y + UIListLayout.Padding.Offset

	PlayerListUI.Background.Size = UDim2.fromScale(1, (math.clamp(0.05 + 30 / PlayerListUI.AbsoluteSize.Y + v75 / PlayerListUI.AbsoluteSize.Y, 0, 1)))
	PlayerListUI.FriendBoost.Position = UDim2.fromScale(0, (math.clamp(0.05 + 30 / PlayerListUI.AbsoluteSize.Y + v75 / PlayerListUI.AbsoluteSize.Y, 0, 1)))
end
function t1.Start(p11) -- line: 460
	-- upvalues: LocalPlayer (copy), t1 (copy), t2 (copy), SocialService (copy), clamp (copy), Util (copy), u17 (ref), Sounds (copy)
	if game["Run Service"]:IsServer() then
		return
	end

	local clone = script.PlayerListHolder:Clone()
	local Contents = clone.Contents

	clone.Parent = LocalPlayer.PlayerGui:WaitForChild("MainUI")
	Contents:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 521
		-- upvalues: t1 (copy)
		t1:__UpdateListSize()
	end)

	for k, v in pairs(t1.DisplayedStats) do
		local clone3 = Contents.InfoTypes.Players:Clone()

		clone3.Name = v
		clone3.Text = t2[v] or v:gsub("(%l)(%u)", "%1 %2")
		clone3.Size = UDim2.fromScale(0.3, 1)
		clone3.LayoutOrder = k + 1
		clone3.TextXAlignment = Enum.TextXAlignment.Center
		clone3.Parent = Contents.InfoTypes
	end

	local _ = {
		JOINING = true,
		LEAVING = false
	}
	local ExperienceInviteOptions = Instance.new("ExperienceInviteOptions")

	ExperienceInviteOptions.PromptMessage = `Invite Friends, get { 10 }% more EXP per friend! (caps at { 20 }%).`

	local function __canSendInvite(p12) -- line: 547
		-- upvalues: SocialService (copy)
		local ok, result = pcall(function() -- line: 548
			-- upvalues: SocialService (copy), p12 (copy)
			return SocialService:CanSendGameInviteAsync(p12)
		end)

		return ok and result
	end

	local Button = clone.FriendBoost.Button

	Button.MouseButton1Down:Connect(function() -- line: 556
		-- upvalues: LocalPlayer (copy), SocialService (copy), ExperienceInviteOptions (copy)
		local v114 = LocalPlayer
		local ok, result = pcall(function() -- line: 548
			-- upvalues: SocialService (copy), v114 (copy)
			return SocialService:CanSendGameInviteAsync(v114)
		end)

		if ok and result then
			SocialService:PromptGameInvite(LocalPlayer, ExperienceInviteOptions)
		end
	end)

	local n2 = 0

	local function __setBoostDisplay(p13, b1: boolean) -- line: 564
		-- upvalues: LocalPlayer (copy), n2 (ref), clamp (copy), Button (copy)
		local ok, result = pcall(function() -- line: 566
			-- upvalues: LocalPlayer (copy), p13 (copy)
			return LocalPlayer:IsFriendsWith(p13.UserId)
		end)

		if ok and result then
			n2 = clamp(n2 + 10 * (not b1 and -1 or 1), 0, 20)
		end

		local v121 = `Invite Friends (+{ n2 }% EXP)`

		if v121 ~= Button.Text then
			Button.Text = v121
		end
	end

	Util.OnPlayerAdded(function(p14) -- line: 587
		-- upvalues: LocalPlayer (copy), n2 (ref), clamp (copy), Button (copy), t1 (copy)
		if p14 ~= LocalPlayer then
			local ok, result = pcall(function() -- line: 566
				-- upvalues: LocalPlayer (copy), p14 (copy)
				return LocalPlayer:IsFriendsWith(p14.UserId)
			end)

			if ok and result then
				n2 = clamp(n2 + 10, 0, 20)
			end

			local v125 = `Invite Friends (+{ n2 }% EXP)`

			if v125 ~= Button.Text then
				Button.Text = v125
			end
		end

		t1:CreatePlayerInList(p14)
	end)
	game.Players.PlayerRemoving:Connect(function(player) -- line: 596
		-- upvalues: LocalPlayer (copy), n2 (ref), clamp (copy), Button (copy), t1 (copy)
		if player ~= LocalPlayer then
			local ok, result = pcall(function() -- line: 566
				-- upvalues: LocalPlayer (copy), player (copy)
				return LocalPlayer:IsFriendsWith(player.UserId)
			end)

			if ok and result then
				n2 = clamp(n2 + -10, 0, 20)
			end

			local v129 = `Invite Friends (+{ n2 }% EXP)`

			if v129 ~= Button.Text then
				Button.Text = v129
			end
		end

		t1:RemovePlayerFromList(player)
	end)
	clone.Close.MouseButton1Click:Connect(function() -- line: 604
		-- upvalues: t1 (copy), u17 (ref)
		t1:TogglePlayerList(not u17)
	end)
	game.UserInputService.InputBegan:Connect(function(input, gameProcessed) -- line: 608
		-- upvalues: t1 (copy), u17 (ref)
		if gameProcessed then
			return
		end

		if input.KeyCode == Enum.KeyCode.Tab then
			t1:TogglePlayerList(not u17)
		end
	end)

	local function addSFX(p15) -- line: 616
		-- upvalues: Sounds (copy)
		if p15:IsA("ImageButton") or p15:IsA("TextButton") then
			p15.MouseEnter:Connect(function() -- line: 618
				-- upvalues: Sounds (copy)
				Sounds:Play("hover")
			end)
			p15.MouseLeave:Connect(function() -- line: 619
				-- upvalues: Sounds (copy)
				Sounds:Play("hoverEnd")
			end)
			p15.MouseButton1Click:Connect(function() -- line: 620
				-- upvalues: Sounds (copy)
				Sounds:Play("select")
			end)
		end
	end

	for _, descendant in pairs(clone:GetDescendants()) do
		addSFX(descendant)
	end

	clone.DescendantAdded:Connect(addSFX)
	p11.PlayerList = clone
	game.StarterGui:SetCoreGuiEnabled("PlayerList", false)
end

return t1

]========]},
{path=[========[
ServerScriptService/Server/Systems/Data/LeaderStats]========],before=[========[
local module = {}

module.AddStats = function(_, Player : Player)
	task.spawn(function()
		local newStats = script.Template:Clone()
		newStats.Parent = Player
		newStats.Name = "leaderstats"
		
		Player:WaitForChild("PlayerData")
		local plrData : Folder = Player.PlayerData
		plrData:WaitForChild("Stats")
		local statsFolder : Folder = plrData.Stats
		local moneyVal = statsFolder:FindFirstChild("Money", true)
		local kChanceVal = statsFolder:FindFirstChild("KillerChance", true)
		
		newStats.Money.Value = moneyVal.Value
		newStats.KillerChance.Value = kChanceVal.Value
		
		moneyVal:GetPropertyChangedSignal("Value"):Connect(function()
			newStats.Money.Value = moneyVal.Value
		end)
		kChanceVal:GetPropertyChangedSignal("Value"):Connect(function()
			newStats.KillerChance.Value = kChanceVal.Value
		end)
	end)
end

return module]========],after=[========[
local module = {}
function module.AddStats(_, player)
 task.spawn(function()
  local data=player:WaitForChild("PlayerData")
  local stats=data:WaitForChild("Stats")
  local money=stats:FindFirstChild("Money",true)
  local total=stats:WaitForChild("General"):WaitForChild("TotalKills")
  if not player.Parent then return end
  local newStats=Instance.new("Folder")
  newStats.Name="leaderstats"
  local moneyDisplay=Instance.new("NumberValue");moneyDisplay.Name="Money";moneyDisplay.Value=money and money.Value or 0;moneyDisplay.Parent=newStats
  local killsDisplay=Instance.new("NumberValue");killsDisplay.Name="Kills";killsDisplay.Value=total.Value;killsDisplay.Parent=newStats
  local connections={}
  if money then table.insert(connections,money:GetPropertyChangedSignal("Value"):Connect(function()moneyDisplay.Value=money.Value end))end
  table.insert(connections,total:GetPropertyChangedSignal("Value"):Connect(function()killsDisplay.Value=total.Value end))
  newStats.Destroying:Connect(function()for _,connection in connections do connection:Disconnect()end end)
  newStats.Parent=player
 end)
end
return module
]========]}}
local function find(path)
 local object=game
 for name in path:gmatch("[^/]+")do object=object:FindFirstChild(name);assert(object,"Missing "..path)end
 return object
end
local changed={}
for _,change in changes do
 change.object=find(change.path)
 assert(change.object.Source==change.before or change.object.Source==change.after,"Source differs from the supplied build: "..change.path..". Nothing changed.")
 if change.object.Source~=change.after then table.insert(changed,change)end
end
if #changed==0 then print("Menu loading and Kills display repair already installed.");return end
local backup=Instance.new("Folder");backup.Name="MenuLoadingBackup_"..os.time()
for i,change in changed do
 local saved=Instance.new("StringValue");saved.Name=tostring(i);saved.Value=change.before;saved.Parent=backup
 local target=Instance.new("ObjectValue");target.Name="Target";target.Value=change.object;target.Parent=saved
end
backup.Parent=game:GetService("ServerStorage")
local ok,err=pcall(function()for _,change in changed do change.object.Source=change.after end end)
if not ok then
 for _,change in changed do pcall(function()change.object.Source=change.before end)end
 error("Repair failed; original Sources restored: "..tostring(err))
end
print("Menu loading and Kills display repaired. Save and start a fresh Play test. Backup: "..backup:GetFullName())

end
setup();install();install()
assert(game.ReplicatedStorage.Systems.Player.UI.Menus.Shop.Source==[========[
require(game.ReplicatedStorage.GlobalTypes)

local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Debris = game:GetService("Debris")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")
local MarketplaceService = game:GetService("MarketplaceService")
local UserInputService = game:GetService("UserInputService")
local Util = require(game.ReplicatedStorage.Modules.Util)
local CurrencyDisplay = require(script.Parent.Parent.SidebarHandler.Classes.CurrencyDisplay)
local Sounds = require(game.ReplicatedStorage.Modules.Sounds)
local Network = require(game.ReplicatedStorage.Modules.Network)
local DataHandler = require(game.ReplicatedStorage.Modules.DataHandler)
local Trove = require(game.ReplicatedStorage.Modules.Misc.Trove)
local Signal = require(game.ReplicatedStorage.Modules.Misc.Signal)
local Device = require(game.ReplicatedStorage.Modules.CombatMenuCompat.Device)
local RigBuilder = require(script.Classes.RigBuilder)
local ShopSale = require(game.ReplicatedStorage.Modules.CombatMenuCompat.ShopSale)
local LocalPlayer = Players.LocalPlayer
local t1 = {}
local NotFound = script.Assets.NotFound
local EmoteViewport = script.Assets.EmoteViewport
local ConfirmUI = script.Assets.ConfirmUI
local t2 = {
	success = "Bought!",
	poor = "Insufficient funds!",
	alreadyBought = "Already owned! (You were not charged)",
	ratelimited = "Ratelimited! (You were not charged)",
	failed = "Something went wrong... (You were not charged)",
	priceChanged = "Price changed! (You were not charged)"
}
local t3={}

local function setupViewportRig() -- line: 55
	-- upvalues: Players (copy), LocalPlayer (copy)
	local EmoteViewport2 = script.Assets.EmoteViewport

	EmoteViewport2.Parent = workspace.CurrentCamera

	local clone = EmoteViewport2.WorldModel.Rig:Clone()

	EmoteViewport2.WorldModel.Rig:Destroy()
	clone.Parent = EmoteViewport2.WorldModel

	local v44 = clone and clone:FindFirstChildOfClass("Humanoid")
	local ok, result = pcall(Players.GetHumanoidDescriptionFromUserIdAsync, Players, LocalPlayer.UserId)

	if ok and (result and v44) then
		local ok2, result2 = pcall(function() -- line: 67
			-- upvalues: v44 (copy), result (copy)
			v44:ApplyDescriptionAsync(result, Enum.AssetTypeVerification.ClientOnly)
		end)

		if not ok2 then
			warn(`[Shop/{ script }]: Failed to apply description to emote rig. Response: { result2 }`)

			return
		end
	else
		warn(`[Shop/{ script }]: No local player description. Response: { result }`)
	end
end
local function transitionHighlightToState(p1, b1: boolean) -- line: 79
	-- upvalues: t1 (copy), TweenService (copy)
	assert(p1 and p1:IsA("TextButton"), "transitionHighlightToState() There was no highlight to transition.")
	assert(b1 ~= nil, "transitionHighlightToState() There was no state to transition to.")

	local Highlight = p1:FindFirstChild("Highlight")
	local Text = p1:FindFirstChild("Text")

	if not Highlight or not Text then
		warn(`[{ script }]: Failed to transition highlight for: { p1.Name }, missing UI elements.`)

		return
	end

	if t1[p1] then
		return
	end

	t1[p1] = true
	Highlight.Visible = true
	TweenService:Create(Highlight, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
		ImageTransparency = not b1 and 1 or 0
	}):Play()
	TweenService:Create(Text, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
		TextColor3 = b1 and Color3.new(0, 0, 0) or Color3.new(1, 1, 1)
	}):Play()
	task.delay(0.5, function() -- line: 113
		-- upvalues: t1 (copy), p1 (copy), b1 (copy), Highlight (copy)
		t1[p1] = nil

		if not b1 then
			Highlight.Visible = false
		end
	end)
end
local function requireShopAsset(p2) -- line: 121
	if p2:IsA("ModuleScript") then
		return pcall(require, p2)
	end

	local Config = p2:FindFirstChild("Config")

	if Config and Config:IsA("ModuleScript") then
		return pcall(require, Config)
	end

	return false, `No Config ModuleScript found for { p2:GetFullName() }`
end
local function getSkinRigSource(p3) -- line: 134
	local v56 = p3:IsA("ModuleScript") and p3.Parent or p3

	if not v56 then
		return nil
	end

	local Rig = v56:FindFirstChild("Rig")

	if Rig and Rig:IsA("Model") then
		return Rig
	end

	return nil
end
local function transitionToFrame(p4, p5, b2: boolean) -- line: 149
	-- upvalues: TweenService (copy)
	assert(p5 and p5:IsA("Frame"), "transitionToFrame() There was no frame to transition to.")
	assert(b2 ~= nil, "transitionToFrame() There was no direction to transition to.")

	if p4 == nil then
        p5.Visible = true
		p5.Position = UDim2.fromScale(0, 0)

		return
	end

	p5.Position = b2 and UDim2.fromScale(-1, 0) or UDim2.fromScale(1, 0)
	p5.Visible = true
	TweenService:Create(p4, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
		Position = UDim2.fromScale(not b2 and -1 or 1, 0)
	}):Play()
	TweenService:Create(p5, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
		Position = UDim2.fromScale(0, 0)
	}):Play()
	task.delay(0.5, function() -- line: 178
		-- upvalues: p4 (copy)
		p4.Visible = false
	end)
end

local t4 = {}
local t9 = {
	FormatPrice = function(_: {[any]: any}, n1: number) -- line: 187
		-- upvalues: Util (copy)
		assert(typeof(n1) == "number", "ShopUtils:FormatPrice() requires a number.")

		if n1 <= 0 then
			return "FREE"
		end

		return `${ Util:ToCommas(n1) }`
	end,
	CreateSearchbar = function(_: {[any]: any}, p6, p7) -- line: 193
		assert(p6 and p6:IsA("TextBox"), "ShopUtils:CreateSearchbar() requires a TextBox.")
		assert(p7 and p7:IsA("GuiObject"), "ShopUtils:CreateSearchbar() requires a Frame.")
		p6:GetPropertyChangedSignal("Text"):Connect(function() -- line: 197
			-- upvalues: p7 (copy), p6 (copy)
			for _, child in (p7:GetChildren()) do
				if child:IsA("GuiObject") and not child:GetAttribute("ShopTemplate") and (not child:GetAttribute("Purchased") or not p7:GetAttribute("ToggledUnowned")) then
					child.Visible = p6.Text == "" or child.Name:lower():find(p6.Text:lower())
				end
			end
		end)
	end,
	SetPurchaseUIState = function(t7: {[any]: any}, b3: boolean) -- line: 212
		-- upvalues: Trove (copy), RunService (copy), TweenService (copy), LocalPlayer (copy)
		if b3 then
			if t7.__trove then
				t7.__trove:Destroy()
			end

			local v68 = Trove.new()

			t7.__trove = v68

			local clone = script.Assets.TransitionGui:Clone()

			clone.Purchase.BackgroundTransparency = 1
			clone.Purchase.Icon.ImageTransparency = 1
			v68:Add(clone)

			local Icon = clone.Purchase.Icon
			local n2 = -1
			local n3 = 0
			local n4 = 0
			local u74 = false

			v68:Connect(RunService.Heartbeat, function(n5: number) -- line: 236
				-- upvalues: n2 (ref), n3 (ref), n4 (ref), u74 (ref), TweenService (copy), Icon (copy)
				n2 += n5 * 1.5
				n3 += n2 * n5

				if n3 > 0.5 then
					n3 = 0.5
					n2 = -1
					n4 += 1

					if n4 % 2 == 0 then
						u74 = not u74
						TweenService:Create(Icon, TweenInfo.new(2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
							Rotation = Icon.Rotation + (not u74 and -360 or 360)
						}):Play()
					end
				end

				Icon.Position = UDim2.fromScale(0.5, n3)
			end)
			clone.Parent = LocalPlayer.PlayerGui
			TweenService:Create(clone.Purchase, TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
				BackgroundTransparency = 0.35
			}):Play()
			TweenService:Create(Icon, TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
				ImageTransparency = 0
			}):Play()

			return
		end

		if t7.__trove then
			t7.__trove:Destroy()
			t7.__trove = nil
		end
	end,
	CreateUnownedButton = function(_: {[any]: any}, p8, p9) -- line: 285
		-- upvalues: Sounds (copy)
		assert(p8 and p8:IsA("TextButton"), "ShopUtils:CreateUnownedButton() requires a TextButton.")
		assert(p9 and p9:IsA("GuiObject"), "ShopUtils:CreateUnownedButton() requires a Frame.")
		p8.MouseEnter:Connect(function() -- line: 289
			-- upvalues: Sounds (copy)
			Sounds:Play("hover")
		end)
		p8.MouseLeave:Connect(function() -- line: 293
			-- upvalues: Sounds (copy)
			Sounds:Play("hoverEnd")
		end)
		p9:SetAttribute("ToggledUnowned", false)
		p8.MouseButton1Down:Connect(function() -- line: 298
			-- upvalues: Sounds (copy), p9 (copy), p8 (copy)
			Sounds:Play("click")

			local v225 = not p9:GetAttribute("ToggledUnowned")

			p9:SetAttribute("ToggledUnowned", v225)

			for _, child in p9:GetChildren() do
				if child:IsA("GuiObject") and not child:GetAttribute("ShopTemplate") and child:GetAttribute("Purchased") then
					child.Visible = not v225
				end
			end

			p8.Icon.ImageTransparency = not v225 and 0 or 0.5
		end)
	end
}
local u34 = false
local u35 = nil

function t9.CreateConfirmationUI(t10: {[any]: any}, p10) -- line: 318
	-- upvalues: u34 (ref), t9 (copy), DataHandler (copy), ConfirmUI (copy), u35 (ref), t4 (copy), ShopSale (copy), TweenService (copy), Sounds (copy), Network (copy), t2 (copy), requireShopAsset (copy), t3 (copy), MarketplaceService (copy), LocalPlayer (copy)
	if u34 then
		return
	end

	t9:ClearConfirmationUI()

	local ok, result = pcall(require, p10)

	if not ok then
		warn(`[{ script }]: Failed to require asset logic: { p10 }.`)

		return
	end

	local v82 = DataHandler:Get()

	if not v82 then
		warn(`[{ script }]: PlayerData does not exist.`)

		return
	end

	u34 = true

	local v83 = t10.__currentlySelected:FindFirstAncestor("Skins") and t10.__currentlySelected.Parent or t10.__currentlySelected

	if not v83 then
		u34 = false

		return
	end

	local clone = ConfirmUI:Clone()

	u35 = clone
	clone.Size = UDim2.fromScale(0.6, 0.6)

	local Menu = t4.ShopMenu.Menu
	local FinalPrice = ShopSale.GetAssetPrice(v83, result, workspace:GetServerTimeNow()).FinalPrice

	local function updateConfirmText() -- line: 352
		-- upvalues: t9 (copy), FinalPrice (ref), clone (copy), result (copy)
		local v228 = t9:FormatPrice(FinalPrice)

		clone:FindFirstChild("Text").Text = `Are you sure you would like to purchase <b><font color="rgb(255,255,255)">{ tostring(result.DisplayName) }</font></b> for <b><font color="rgb(255,255,255)">{ v228 }</font></b>?`
	end

	local v88 = t9:FormatPrice(FinalPrice)

	clone:FindFirstChild("Text").Text = `Are you sure you would like to purchase <b><font color="rgb(255,255,255)">{ tostring(result.DisplayName) }</font></b> for <b><font color="rgb(255,255,255)">{ v88 }</font></b>?`
	clone.Parent = Menu.Holder
	clone.Visible = true
	clone.Position = UDim2.fromScale(0.5, 0.525)
	TweenService:Create(clone, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Position = UDim2.fromScale(0.5, 0.5)
	}):Play()
	clone.Purchase.MouseButton1Down:Connect(function() -- line: 369
		-- upvalues: Sounds (copy), clone (copy), u34 (ref), Network (copy), v83 (copy), FinalPrice (ref), t2 (copy), t9 (copy), t10 (copy), result (copy), requireShopAsset (copy), v82 (copy), t3 (copy), MarketplaceService (copy), LocalPlayer (copy)
		Sounds:Play("click")

		local Text = clone.Purchase:FindFirstChild("Text")

		if not Text then
			u34 = false

			return
		end

		Text.Text = "..."

		local v230 = Network:FireServerConnection("PurchaseContent", "REMOTE_FUNCTION", v83, FinalPrice)

		if t2[v230.Status] then
			if t2[v230.Status] == "Insufficient funds!" and math.random(1, 1000) == 1 then
				Text.Text = "Poor"
			else
				Text.Text = t2[v230.Status]
			end
		end

		if v230.Status == "success" then
			t9.OnPurchased:Fire(t10.__currentlySelected)
		elseif v230.Status == "priceChanged" then
			FinalPrice = v230.Price

			local v231 = t9:FormatPrice(FinalPrice)

			clone:FindFirstChild("Text").Text = `Are you sure you would like to purchase <b><font color="rgb(255,255,255)">{ tostring(result.DisplayName) }</font></b> for <b><font color="rgb(255,255,255)">{ v231 }</font></b>?`

		end

		task.wait(0.5)
		Text.Text = "BUY"
		u34 = false
	end)
	clone.Purchase.MouseEnter:Connect(function() -- line: 428
		-- upvalues: Sounds (copy)
		Sounds:Play("hover")
	end)
	clone.Purchase.MouseLeave:Connect(function() -- line: 432
		-- upvalues: Sounds (copy)
		Sounds:Play("hoverEnd")
	end)
	clone.Cancel.MouseButton1Down:Connect(function() -- line: 436
		-- upvalues: clone (copy), u34 (ref), Sounds (copy)
		clone:Destroy()
		u34 = false
		Sounds:Play("click")
	end)
	clone.Cancel.MouseEnter:Connect(function() -- line: 442
		-- upvalues: Sounds (copy)
		Sounds:Play("hover")
	end)
	clone.Purchase.MouseLeave:Connect(function() -- line: 446
		-- upvalues: Sounds (copy)
		Sounds:Play("hoverEnd")
	end)
	clone.AncestryChanged:Connect(function(_, parent) -- line: 450
		-- upvalues: u34 (ref), t9 (copy)
		if not parent then
			u34 = false
			t9:ClearConfirmationUI()
		end
	end)

	return clone
end
function t9.ClearConfirmationUI(_) -- line: 460
	-- upvalues: u35 (ref)
	if u35 ~= nil then
		u35:Destroy()
	end

	u35 = nil
end
function t9.CreateViewport(_: {[any]: any}, p13, b4: boolean, b5: boolean) -- line: 467
	-- upvalues: EmoteViewport (copy), Players (copy), ReplicatedStorage (copy), Util (copy), SoundService (copy), Sounds (copy), Trove (copy), RunService (copy), UserInputService (copy), TweenService (copy), Debris (copy)
	local clone = EmoteViewport:Clone()
	local Rig = clone.WorldModel.Rig
	local Humanoid = Rig:FindFirstChildOfClass("Humanoid")

	if not Humanoid or not Humanoid:FindFirstChildOfClass("Animator") then
		warn(`[Shop/{ script }]: No animator found for emote { p13.DisplayName }.`)

		return
	end

	local AssetID = p13.AssetID

	if typeof(AssetID) == "table" then
		if p13.isDuoAnim then
			AssetID = AssetID[1]
		elseif not AssetID.Start or not AssetID.Loop then
			local v98 = Players.LocalPlayer.Character and Players.LocalPlayer.Character.Name
			local v99 = v98 and ReplicatedStorage.Assets.Survivors:FindFirstChild(v98)
			local v100 = v99 and (v99:FindFirstChild("Config") and require(v99.Config).Class)

			AssetID = if not v100 or not p13.AssetID[v100] then if not p13.AssetID.Survivalist then AssetID[math.random(#AssetID)] else p13.AssetID.Survivalist else p13.AssetID[v100]
		else
			AssetID = AssetID.Loop
		end
	end

	local v101 = Util:LoadAnimationFromID(Rig, AssetID)

	if v101 then
		v101.Looped = true
		v101:Play(0)
		v101.Priority = Enum.AnimationPriority.Action
	end

	local t12 = {
		Player = Players.LocalPlayer,
		Character = clone.WorldModel.Rig,
		Emote = v101
	}

	if p13.CreatedServer then
		local ok, result = pcall(p13.CreatedServer, t12)

		if not ok then
			warn(`[Shop/{ script }]: Failed to run CreatedServer for emote { p13.DisplayName }: { result }`)
		end
	end

	if p13.CreatedClient then
		local ok, result = pcall(p13.CreatedClient, t12)

		if not ok then
			warn(`[Shop/{ script }]: Failed to run CreatedClient for emote { p13.DisplayName }: { result }`)
		end
	end

	local u107 = nil

	if b4 then
		local v108 = p13.SFXProperties or {}

		v108.SoundGroup = SoundService.Emotes

		local v109 = typeof(p13.SFX) == "table" and p13.SFX.Loop

		if v109 then
			v108.Looped = true
		end

		u107 = Sounds:Play(v109 or p13.SFX, v108)

		if u107 then
			u107.PlaybackRegionsEnabled = true
			u107:GetPropertyChangedSignal("TimeLength"):Connect(function() -- line: 536
				-- upvalues: u107 (ref)
				local v240 = u107.TimeLength or 0

				u107.LoopRegion = NumberRange.new(0, (math.clamp(v240 - 0.05, 0.1, 60000)))
			end)
			u107.LoopRegion = NumberRange.new(0, (math.clamp(u107.TimeLength - 0.05, 0.1, 60000)))
		end
	end

	local u110 = Trove.new()

	if b5 then
		local Camera = Instance.new("Camera")

		Camera.Parent = clone
		clone.CurrentCamera = Camera

		local Arrows = clone.WorldModel:FindFirstChild("Arrows")

		Arrows.Transparency = 0.5

		local n6 = -90
		local n7 = 0
		local u115 = false
		local vector2 = nil

		local function updateCamera() -- line: 569
			-- upvalues: Camera (copy), Rig (copy), n6 (ref)
			if not Camera or (not Rig or not Rig.PrimaryPart) then
				return
			end

			local Position = Rig:GetPivot().Position
			local v242 = math.rad(n6)
			local v243 = Vector3.new(math.sin(v242) * 0.9659258262890683, 0.25881904510252074, math.cos(v242) * 0.9659258262890683) * 6

			Camera.CFrame = CFrame.lookAt(Position + v243, Position)
		end

		updateCamera()

		local n8 = 0
		local n9 = 0
		local zero = Vector2.zero
		local zero2 = Vector2.zero

		u110:Connect(RunService.RenderStepped, function(n10: number) -- line: 594
			-- upvalues: n8 (ref), u115 (ref), n6 (ref), n7 (ref), Rig (copy), Camera (copy), n9 (ref), Arrows (copy), zero2 (ref), zero (ref), updateCamera (copy)
			n8 += n10
			n8 %= 6.283185307179586

			if not u115 then
				n6 += n7 * n10
				n7 *= math.exp(n10 * -3)

				if math.abs(n7) < 0.1 then
					n7 = 0
				end

				local v245 = Rig:GetPivot().Position + Vector3.new(0, -2.5, 0)
				local CFramePosition = Camera.CFrame.Position
				local vector3 = Vector3.new(CFramePosition.X, v245.Y, CFramePosition.Z)

				n9 += n10 * 0.5235987755982988
				n9 %= 360
				Arrows.CFrame = CFrame.lookAt(v245, vector3) * CFrame.Angles(0, n9, 0)
			end

			if u115 == true then
				local v248 = -(zero2.X * 0.3 * n10 * workspace.CurrentCamera.ViewportSize.X) * 0.6

				n6 += v248
				n7 = v248 * 60
			end

			local v249 = -(zero.X * 0.3 * n10 * workspace.CurrentCamera.ViewportSize.X) * 0.6

			n6 += v249
			n7 = v249 * 60

			local v250 = u115 or zero.Magnitude > 0.1

			if v250 and Arrows.Transparency ~= 1 then
				Arrows.Transparency = 1
			elseif not v250 and Arrows.Transparency ~= 0.5 then
				Arrows.Transparency = 0.5
			end

			updateCamera()
		end)

		local function __onMobilePCInput(p14, _: boolean) -- line: 642
			-- upvalues: clone (copy), u115 (ref), vector2 (ref), n7 (ref), zero2 (ref), zero (ref)
			if p14.Position.Z ~= 0 then
				return
			end

			local p14Position = p14.Position
			local AbsolutePosition = clone.AbsolutePosition
			local AbsoluteSize = clone.AbsoluteSize
			local v256 = p14Position.X >= AbsolutePosition.X and p14Position.X <= AbsolutePosition.X + AbsoluteSize.X
			local v257 = p14Position.Y >= AbsolutePosition.Y and p14Position.Y <= AbsolutePosition.Y + AbsoluteSize.Y

			if not v256 or not v257 then
				return
			end

			u115 = true
			vector2 = Vector2.new(p14Position.X, p14Position.Y)
			n7 = 0
			zero2 = Vector2.zero
			zero = Vector2.zero
		end

		u110:Connect(UserInputService.InputBegan, function(p15, b7: boolean) -- line: 663
			-- upvalues: Players (copy), __onMobilePCInput (copy)
			local v260 = false

			if p15.UserInputType == Enum.UserInputType.Gamepad1 then
				if p15.KeyCode == Enum.KeyCode.ButtonR2 then
					v260 = true
				elseif p15.KeyCode == Enum.KeyCode.ButtonA then
					local Mouse = Players.LocalPlayer:GetMouse()

					__onMobilePCInput({
						Position = Vector3.new(Mouse.X, Mouse.Y, 0)
					}, true)

					return
				end
			end

			if v260 or p15.UserInputType == Enum.UserInputType.MouseButton1 or p15.UserInputType == Enum.UserInputType.Touch then
				__onMobilePCInput(p15, b7)
			end
		end)

		local t13 = {
			Enum.UserInputType.MouseMovement,
			Enum.UserInputType.Touch,
			Enum.UserInputType.Gamepad1
		}

		u110:Connect(UserInputService.InputChanged, function(p16, _: boolean) -- line: 686
			-- upvalues: u115 (ref), vector2 (ref), t13 (copy), zero2 (ref), n6 (ref), n7 (ref)
			if not u115 or not vector2 then
				return
			end

			if table.find(t13, p16.UserInputType) == nil then
				return
			end

			local zero3 = Vector2.zero
			local _ = Vector2.zero

			if p16.UserInputType == Enum.UserInputType.Gamepad1 then
				if p16.KeyCode ~= Enum.KeyCode.Thumbstick1 and p16.KeyCode ~= Enum.KeyCode.Thumbstick2 then
					return
				end

				if p16.KeyCode == Enum.KeyCode.Thumbstick1 then
					zero2 = Vector2.new(p16.Position.X, p16.Position.Y)

					return
				end
			else
				zero3 = Vector2.new(p16.Position.X, p16.Position.Y)
			end

			local v266 = zero3 - vector2

			vector2 = zero3

			local v267 = -v266.X * 0.6

			n6 += v267
			n7 = v267 * 60
		end)
		u110:Connect(UserInputService.InputChanged, function(p17, _: boolean) -- line: 721
			-- upvalues: zero (ref)
			if p17.KeyCode == Enum.KeyCode.Thumbstick2 then
				local vector2_2 = Vector2.new(p17.Position.X, p17.Position.Y)

				if vector2_2.Magnitude <= 0.1 then
					vector2_2 = Vector2.zero
				end

				zero = vector2_2

				return
			end
		end)
		u110:Connect(UserInputService.InputEnded, function(p18) -- line: 733
			-- upvalues: u115 (ref), vector2 (ref), zero2 (ref), zero (ref)
			if (p18.UserInputType ~= Enum.UserInputType.Gamepad1 or p18.KeyCode ~= Enum.KeyCode.ButtonR2 and p18.KeyCode ~= Enum.KeyCode.ButtonA) and (p18.UserInputType ~= Enum.UserInputType.MouseButton1 and p18.UserInputType ~= Enum.UserInputType.Touch) then
				return
			end

			u115 = false
			vector2 = nil
			zero2 = Vector2.zero
			zero = Vector2.zero
		end)
	end

	clone.AncestryChanged:Connect(function(_, parent) -- line: 750
		-- upvalues: u110 (ref), p13 (copy), t12 (copy), u107 (ref), TweenService (copy), Debris (copy)
		if parent then
			return
		end

		if u110 then
			u110:Clean()
			u110 = nil
		end

		if p13.DestroyedServer then
			local ok, result = pcall(p13.DestroyedServer, t12)

			if not ok then
				warn(`[Shop/{ script }]: Failed to run DestroyedServer for emote { p13.DisplayName }: { result }`)
			end
		end

		if p13.DestroyedClient then
			local ok, result = pcall(p13.DestroyedClient, t12)

			if not ok then
				warn(`[Shop/{ script }]: Failed to run DestroyedClient for emote { p13.DisplayName }: { result }`)
			end
		end

		if not u107 then
			return
		end

		TweenService:Create(u107, TweenInfo.new(0.1), {
			Volume = 0
		}):Play()
		Debris:AddItem(u107, 0.1)
	end)

	return clone
end
function t9.CreateSkinViewport(_: {[any]: any}, p20, b10: boolean) -- line: 792
	-- upvalues: RigBuilder (copy), Trove (copy), RunService (copy), UserInputService (copy), Players (copy)
	assert(typeof(p20) == "Instance", "ShopUtils:CreateSkinViewport() requires a skin folder.")

	local v127 = RigBuilder.ResolveSkin(p20)

	if not v127 or not v127.ActorFolder then
		warn(`[{ script }]: Could not resolve actor for { p20:GetFullName() }`)

		return
	end

	local v128 = RigBuilder.GetMergedConfig(v127)
	local v129 = RigBuilder.GetMergedBehavior(v127)
	local v130, v131 = RigBuilder.GetRig(v127, v128, v129)

	if not v130 then
		warn(`[{ script }]: No rig found for { p20:GetFullName() }`)

		return
	end

	RigBuilder.SanitizeRig(v130)
	RigBuilder.ApplyExpression(v130, v128)

	if v131 then
		RigBuilder.ApplyLifeAppearance(v130, v131)
	end

	if v127.ActorName == "Veeronica" then
		v130.Skateboard.Transparency = 1
		v130.Spray.Transparency = 1
	end

	local ViewportFrame = Instance.new("ViewportFrame")

	ViewportFrame.BackgroundTransparency = 1
	ViewportFrame.ImageTransparency = 0
	ViewportFrame.Ambient = Color3.fromRGB(200, 200, 200)
	ViewportFrame.LightColor = Color3.fromRGB(140, 140, 140)
	ViewportFrame.LightDirection = Vector3.new(-1, -1, -1)

	local WorldModel = Instance.new("WorldModel")

	WorldModel.WorldPivot = CFrame.new(0, 2.5, 0) * CFrame.Angles(0, 0.8726646259971648, 0)
	WorldModel.Parent = ViewportFrame
	v130:PivotTo(CFrame.new(-1.5, 3, 0) * CFrame.Angles(0, 1.1344640137963142, 0))
	v130.Parent = WorldModel

	local Camera = Instance.new("Camera")

	Camera.FieldOfView = 35
	Camera.Parent = ViewportFrame
	ViewportFrame.CurrentCamera = Camera

	local v135, v136 = RigBuilder.GetVisibleBoundingBox(v130)
	local v137 = math.max(math.max(v136.X, v136.Y, v136.Z) * 1.75, 6)
	local v138 = v135.Position + Vector3.new(0, v136.Y * 0.05, 0)
	local vector3 = Vector3.new(0, v136.Y * 0.12, v137)

	Camera.CFrame = CFrame.lookAt(v138 + vector3, v138)

	local v140 = Trove.new()

	if b10 then
		local Camera2 = Instance.new("Camera")

		Camera2.Parent = ViewportFrame
		ViewportFrame.CurrentCamera = Camera2

		local n11 = -90
		local n12 = 0
		local u144 = false
		local vector2 = nil

		local function updateCamera() -- line: 869
			-- upvalues: Camera2 (copy), v130 (copy), n11 (ref)
			if not Camera2 or (not v130 or not v130.PrimaryPart) then
				return
			end

			local Position = v130:GetPivot().Position
			local v279 = math.rad(n11)
			local v280 = Vector3.new(math.sin(v279) * 0.9659258262890683, 0.25881904510252074, math.cos(v279) * 0.9659258262890683) * 6

			Camera2.CFrame = CFrame.lookAt(Position + v280, Position)
		end

		updateCamera()

		local n13 = 0
		local zero = Vector2.zero
		local zero4 = Vector2.zero

		v140:Connect(RunService.RenderStepped, function(n14: number) -- line: 894
			-- upvalues: n13 (ref), u144 (ref), zero4 (ref), n11 (ref), n12 (ref), zero (ref), updateCamera (copy)
			n13 += n14
			n13 %= 6.283185307179586

			if u144 == true then
				local v282 = -(zero4.X * 0.3 * n14 * workspace.CurrentCamera.ViewportSize.X) * 0.6

				n11 += v282
				n12 = v282 * 60
			end

			local v283 = -(zero.X * 0.3 * n14 * workspace.CurrentCamera.ViewportSize.X) * 0.6

			n11 += v283
			n12 = v283 * 60
			updateCamera()
		end)

		local function __onMobilePCInput(p21, _: boolean) -- line: 917
			-- upvalues: ViewportFrame (copy), u144 (ref), vector2 (ref), n12 (ref), zero4 (ref), zero (ref)
			if p21.Position.Z ~= 0 then
				return
			end

			local p21Position = p21.Position
			local AbsolutePosition = ViewportFrame.AbsolutePosition
			local AbsoluteSize = ViewportFrame.AbsoluteSize
			local v289 = p21Position.X >= AbsolutePosition.X and p21Position.X <= AbsolutePosition.X + AbsoluteSize.X
			local v290 = p21Position.Y >= AbsolutePosition.Y and p21Position.Y <= AbsolutePosition.Y + AbsoluteSize.Y

			if not v289 or not v290 then
				return
			end

			u144 = true
			vector2 = Vector2.new(p21Position.X, p21Position.Y)
			n12 = 0
			zero4 = Vector2.zero
			zero = Vector2.zero
		end

		v140:Connect(UserInputService.InputBegan, function(p22, b12: boolean) -- line: 938
			-- upvalues: Players (copy), __onMobilePCInput (copy)
			local v293 = false

			if p22.UserInputType == Enum.UserInputType.Gamepad1 then
				if p22.KeyCode == Enum.KeyCode.ButtonR2 then
					v293 = true
				elseif p22.KeyCode == Enum.KeyCode.ButtonA then
					local Mouse = Players.LocalPlayer:GetMouse()

					__onMobilePCInput({
						Position = Vector3.new(Mouse.X, Mouse.Y, 0)
					}, true)

					return
				end
			end

			if v293 or p22.UserInputType == Enum.UserInputType.MouseButton1 or p22.UserInputType == Enum.UserInputType.Touch then
				__onMobilePCInput(p22, b12)
			end
		end)

		local t15 = {
			Enum.UserInputType.MouseMovement,
			Enum.UserInputType.Touch,
			Enum.UserInputType.Gamepad1
		}

		v140:Connect(UserInputService.InputChanged, function(p23, _: boolean) -- line: 961
			-- upvalues: u144 (ref), vector2 (ref), t15 (copy), zero4 (ref), n11 (ref), n12 (ref)
			if not u144 or not vector2 then
				return
			end

			if table.find(t15, p23.UserInputType) == nil then
				return
			end

			local zero5 = Vector2.zero
			local _ = Vector2.zero

			if p23.UserInputType == Enum.UserInputType.Gamepad1 then
				if p23.KeyCode ~= Enum.KeyCode.Thumbstick1 and p23.KeyCode ~= Enum.KeyCode.Thumbstick2 then
					return
				end

				if p23.KeyCode == Enum.KeyCode.Thumbstick1 then
					zero4 = Vector2.new(p23.Position.X, p23.Position.Y)

					return
				end
			else
				zero5 = Vector2.new(p23.Position.X, p23.Position.Y)
			end

			local v299 = zero5 - vector2

			vector2 = zero5

			local v300 = -v299.X * 0.6

			n11 += v300
			n12 = v300 * 60
		end)
		v140:Connect(UserInputService.InputChanged, function(p24, _: boolean) -- line: 996
			-- upvalues: zero (ref)
			if p24.KeyCode == Enum.KeyCode.Thumbstick2 then
				local vector2_3 = Vector2.new(p24.Position.X, p24.Position.Y)

				if vector2_3.Magnitude <= 0.1 then
					vector2_3 = Vector2.zero
				end

				zero = vector2_3

				return
			end
		end)
		v140:Connect(UserInputService.InputEnded, function(p25) -- line: 1008
			-- upvalues: u144 (ref), vector2 (ref), zero4 (ref), zero (ref)
			if (p25.UserInputType ~= Enum.UserInputType.Gamepad1 or p25.KeyCode ~= Enum.KeyCode.ButtonR2 and p25.KeyCode ~= Enum.KeyCode.ButtonA) and (p25.UserInputType ~= Enum.UserInputType.MouseButton1 and p25.UserInputType ~= Enum.UserInputType.Touch) then
				return
			end

			u144 = false
			vector2 = nil
			zero4 = Vector2.zero
			zero = Vector2.zero
		end)
	end

	local connection = nil

	connection = ViewportFrame.AncestryChanged:Connect(function(_, parent) -- line: 1026
		-- upvalues: ViewportFrame (copy), connection (ref), RigBuilder (copy), v130 (copy), v128 (copy)
		if parent and ViewportFrame:IsDescendantOf(game) then
			connection:Disconnect()
			RigBuilder.PlayIdleAnimation(v130, v128)
		end
	end)
	ViewportFrame.Destroying:Connect(function() -- line: 1033
		-- upvalues: v140 (copy), connection (ref)
		v140:Clean()

		if connection.Connected then
			connection:Disconnect()
		end
	end)

	return ViewportFrame
end
function t9.CloseOverlay(p27) -- line: 1043
	-- upvalues: t4 (copy), Device (copy), TweenService (copy), t9 (copy)
	assert(t4.ShopMenu, "ShopUtils:CloseOverlay() Shop menu does not exist, did you forget to setup the Shop module?")

	local Menu = t4.ShopMenu.Menu

	assert(Menu, "ShopUtils:OpenOverlay() Shop menu does not exist, did you forget to setup the Shop module?")

	local Overlay = Menu.Holder.Overlay
	local ViewportFrame = Overlay.Preview.BG:FindFirstChildOfClass("ViewportFrame")

	if ViewportFrame then
		ViewportFrame:Destroy()
	end

	p27.__overlaySelection = nil

	if Device:GetPlayerDevice() == "Mobile" then
		TweenService:Create(Menu.Holder, TweenInfo.new(0.5), {
			Position = UDim2.new(0.5, 0, 0.5, 0)
		}):Play()
	end

	t9:ClearConfirmationUI()
	Overlay.Visible = false
	p27.__isOverlayOpen = false
end
function t9.SetupOverlay(t16: {[any]: any}, p28, b15: boolean) -- line: 1066
	-- upvalues: t4 (copy), requireShopAsset (copy), Device (copy), TweenService (copy), t9 (copy)
	assert(typeof(p28) == "Instance" and (p28:IsA("ModuleScript") or p28:IsA("Folder")), "ShopUtils:OpenOverlay() requires assetLogic.")

	local u160 = p28:IsA("Folder") and p28:FindFirstChild("Config") or p28
	local Menu = t4.ShopMenu.Menu

	assert(Menu, "ShopUtils:OpenOverlay() Shop menu does not exist, did you forget to setup the Shop module?")

	local v162, v163 = requireShopAsset(u160)

	if not v162 then
		warn(`ShopUtils:OpenOverlay() Failed to require assetLogic: { u160 }. { v163 }`)

		return
	end

	if Device:GetPlayerDevice() == "Mobile" then
		TweenService:Create(Menu.Holder, TweenInfo.new(0.5), {
			Position = UDim2.new(0.45, 0, 0.5, 0)
		}):Play()
	end

	local Overlay = Menu.Holder.Overlay

	Overlay.Preview.Description.Text = v163.Description or "No description provided."
	Overlay.Preview.Credit.Text = v163.Credits or ""
	Overlay.Preview:FindFirstChild("Name").Text = v163.DisplayName or "No name provided."
	t16:ApplyPrice(Overlay.Preview, u160, v163)
	t9:ClearConfirmationUI()

	local ViewportFrame = Overlay.Preview.BG:FindFirstChildOfClass("ViewportFrame")

	if ViewportFrame then
		ViewportFrame:Destroy()
	end

	t16.__overlaySelection = nil

	if b15 then
		local v166 = t16:CreateViewport(v163, true, true)

		if not v166 then
			warn(`[{ script }]: Failed to create viewport for emote { v163.DisplayName }.`)

			return
		end

		Overlay.Preview.BG.Render.Visible = false
		v166.AnchorPoint = Vector2.new(0.5, 0.5)
		v166.Size = UDim2.fromScale(1, 0.965)
		v166.Position = UDim2.fromScale(0.485, 0.5)
		v166.Parent = Overlay.Preview.BG
	else
		Overlay.Preview.BG.Render.Visible = true
		Overlay.Preview.BG.Render.Image = v163.RenderImage or ""

		local t17 = {}

		t16.__overlaySelection = t17
		task.spawn(function() -- line: 1115
			-- upvalues: t16 (copy), u160 (ref), t17 (copy), Overlay (copy)
			local v307 = t16:CreateSkinViewport(u160, true)

			if not v307 then
				return
			end

			if t16.__overlaySelection ~= t17 then
				v307:Destroy()

				return
			end

			Overlay.Preview.BG.Render.Visible = false
			v307.AnchorPoint = Vector2.new(0.5, 0.5)
			v307.Size = UDim2.fromScale(1, 0.965)
			v307.Position = UDim2.fromScale(0.485, 0.5)
			v307.Parent = Overlay.Preview.BG
		end)
	end

	t16.__currentlySelected = u160
end

t9.__purchaseSignal = Signal.new()
t9.OnPurchased = t9.__purchaseSignal

function t9.OpenOverlay(t18: {[any]: any}, p29, b16: boolean) -- line: 1141
	-- upvalues: t4 (copy), TweenService (copy), Trove (copy), Sounds (copy), t9 (copy)
	if t18.__isOverlayOpen then
		t18:SetupOverlay(p29, b16)

		return
	end

	assert(typeof(p29) == "Instance" and (p29:IsA("ModuleScript") or p29:IsA("Folder")), "ShopUtils:OpenOverlay() requires assetLogic.")

	local Menu = t4.ShopMenu.Menu

	assert(Menu, "ShopUtils:OpenOverlay() Shop menu does not exist, did you forget to setup the Shop module?")
	t18.__isOverlayOpen = true

	local Overlay = Menu.Holder.Overlay

	Overlay.Position = UDim2.fromScale(1.2, 0.55)
	t18:SetupOverlay(p29, b16)
	Overlay.Visible = true
	TweenService:Create(Overlay, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Position = UDim2.fromScale(1.2, 0.5)
	}):Play()

	if t18.__buyTrove then
		t18.__buyTrove:Destroy()
	end

	t18.__buyTrove = Trove.new()
	t18.__buyTrove:Connect(Overlay.Preview.Buy.MouseEnter, function() -- line: 1173
		-- upvalues: TweenService (copy), Overlay (copy), Sounds (copy)
		TweenService:Create(Overlay.Preview.Buy, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.fromScale(0.625, 0.2)
		}):Play()
		Sounds:Play("hover")
	end)
	t18.__buyTrove:Connect(Overlay.Preview.Buy.MouseLeave, function() -- line: 1184
		-- upvalues: TweenService (copy), Overlay (copy), Sounds (copy)
		TweenService:Create(Overlay.Preview.Buy, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.fromScale(0.579, 0.083)
		}):Play()
		Sounds:Play("hoverEnd")
	end)
	t18.__buyTrove:Connect(Overlay.Preview.Buy.MouseButton1Down, function() -- line: 1195
		-- upvalues: Sounds (copy), t9 (copy), t18 (copy)
		Sounds:Play("click")
		t9:CreateConfirmationUI(t18.__currentlySelected)
	end)
end

local self = setmetatable({}, {
	__mode = "k"
})
local u37 = nil

local function scheduleSaleRefresh() -- line: 1205
	-- upvalues: u37 (ref), ShopSale (copy), self (copy), t9 (copy), scheduleSaleRefresh (copy)
	if u37 then
		return
	end

	local ServerTimeNow = workspace:GetServerTimeNow()
	local v174 = ShopSale.GetNextChangeTime(ServerTimeNow)

	if not v174 then
		return
	end

	u37 = task.delay(v174 - ServerTimeNow + 0.1, function() -- line: 1216
		-- upvalues: u37 (ref), self (copy), t9 (copy), scheduleSaleRefresh (copy)
		u37 = nil

		for v308, v309 in self do
			if v308.Parent then
				t9:ApplyPrice(v308, v309.asset, v309.config)
			else
				self[v308] = nil
			end
		end

		scheduleSaleRefresh()
	end)
end

function t9.ApplyPrice(t19: {[any]: any}, p30, p31, p32) -- line: 1231
	-- upvalues: ShopSale (copy), self (copy), scheduleSaleRefresh (copy)
	if p31:IsA("ModuleScript") and (p31.Name == "Config" and p31.Parent) then
		p31 = p31.Parent
	end

	local v179 = ShopSale.GetAssetPrice(p31, p32, workspace:GetServerTimeNow())
	local IsDiscounted = v179.IsDiscounted
	local Price = p30:FindFirstChild("Price")

	if Price then
		Price.Text = t19:FormatPrice(v179.FinalPrice)

		local DiscountGradient = Price:FindFirstChild("DiscountGradient")

		if DiscountGradient then
			DiscountGradient.Enabled = IsDiscounted
		end
	end

	local OldPrice = p30:FindFirstChild("OldPrice")

	if OldPrice then
		OldPrice.Visible = IsDiscounted
		OldPrice.Text = IsDiscounted and t19:FormatPrice(v179.OriginalPrice) or ""
	end

	local DiscountTag = p30:FindFirstChild("DiscountTag")

	if DiscountTag then
		DiscountTag.Visible = IsDiscounted
	end

	self[p30] = {
		asset = p31,
		config = p32
	}
	scheduleSaleRefresh()
end

local u39 = nil
local u40 = nil

function t4.OnTransitionState(b17: boolean) -- line: 1266
	-- upvalues: t4 (copy), u40 (ref), u39 (ref), Lighting (copy), Util (copy), LocalPlayer (copy), TweenService (copy), Debris (copy)
	local ShopMenu = t4.ShopMenu

	if b17 then
		if u40 then
			u40:Destroy()
			u40 = nil
		end

		if u39 then
			u39:Destroy()
			u39 = nil
		end

		ShopMenu.Menu.Position = UDim2.fromScale(0.5, 0.55)
		ShopMenu.Menu.Size = UDim2.fromScale(1, 1)
		ShopMenu.Menu.Visible = true

		local BlurEffect = Instance.new("BlurEffect")

		BlurEffect.Name = "ShopBlur"
		BlurEffect.Size = 0
		BlurEffect.Parent = Lighting
		u40 = BlurEffect
		u39 = Util:CreateFOVMultiplier(LocalPlayer, 1, "ShopZoom")
		TweenService:Create(BlurEffect, TweenInfo.new(0.225, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = 12
		}):Play()
		TweenService:Create(u39, TweenInfo.new(0.225, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Value = 0.85
		}):Play()
		TweenService:Create(ShopMenu.Menu, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Position = UDim2.fromScale(0.5, 0.5)
		}):Play()
	else
		ShopMenu.Menu.Visible = false

		local v188 = u39
		local v189 = u40

		if u39 then
			TweenService:Create(u39, TweenInfo.new(0.225, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Value = 1
			}):Play()
		end

		if v189 then
			TweenService:Create(v189, TweenInfo.new(0.225, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Size = 0
			}):Play()
		end

		if v189 then
			Debris:AddItem(v189, 0.225)
		end

		if v188 then
			Debris:AddItem(v188, 0.225)
		end
	end

	local v190 = `OnWindow{ not b17 and "Closed" or "Opened" }`
	local v191 = t4.TabLogic[t4.LastTab or ""]

	if v191 and v191[v190] then
		local ok, result = pcall(v191[v190], v191)

		if not ok then
			warn(`[{ script }]: Failed to run { v190 }() for tab: { t4.LastTab }, got: { result }`)
		end
	end
end
function t4.SwitchTab(_: {[any]: any}, s1: string) -- line: 1351
 if s1=="Robux"or s1=="Featured"then s1="Skins"end
	-- upvalues: t4 (copy), t1 (copy), transitionHighlightToState (copy), transitionToFrame (copy)
	if s1 == t4.LastTab then
		return
	end

	local Menu = t4.ShopMenu.Menu
	local TabButtons = Menu.Holder.TabButtons
	local v198 = t4.LastTab and TabButtons:FindFirstChild(t4.LastTab)
	local s1_2 = TabButtons:FindFirstChild(s1)

	if not s1_2 then
		warn(`[{ script }]: No tab found for: { s1 }`)

		return
	end

	if v198 then
		if t1[v198] then
			return
		end

		transitionHighlightToState(v198, false)
	end

	local s1_3 = Menu.Holder.Page:FindFirstChild(s1)
	local v201 = t4.LastTab and Menu.Holder.Page:FindFirstChild(t4.LastTab)
	local v202 = (v198 and v198.LayoutOrder or 0) > s1_2.LayoutOrder

	transitionToFrame(v201, s1_3, v202)
	transitionHighlightToState(s1_2, true)

	local v203 = t4.TabLogic[t4.LastTab]

	if v203 and v203.OnTabSwitched then
		local ok, result = pcall(v203.OnTabSwitched, v203)

		if not ok then
			warn(`[{ script }]: Failed to run OnTabSwitched() for tab: { t4.LastTab }, got: { result }`)
		end
	end

	local v206 = t4.TabLogic[s1]

	if v206 and v206.OnTabOpened then
		local ok, result = pcall(v206.OnTabOpened, v206)

		if not ok then
			warn(`[{ script }]: Failed to run OnTabOpened() for tab: { t4.LastTab }, got: { result }`)
		end
	end

	t4.LastTab = s1
end

local u41 = false

function t4.Start(_) -- line: 1401
	-- upvalues: u41 (ref), t4 (copy), CurrencyDisplay (copy), TweenService (copy), Sounds (copy), NotFound (copy), t9 (copy), setupViewportRig (copy)
	if u41 then
		return
	end

	u41 = true

	local EventHandlerClient = require(game.ReplicatedStorage.Modules.EventHandlerClient)

	if not EventHandlerClient:GetInfo() then
		EventHandlerClient.onEventInfoGiven:Wait()
		EventHandlerClient:GetInfo()
	end

	t4.ShopMenu = require(game.ReplicatedStorage.Initializer).PlayerSystems.SidebarHandler:CreateSidebarMenu("Shop", script.Shop)
	t4.Tabs = {}
	t4.TabLogic = {}

	local Menu = t4.ShopMenu.Menu

	os.clock()
	CurrencyDisplay.new("Money", "rbxassetid://132413181315189", false).Instance.Parent = Menu.Holder.Currency

	local Close = Menu.Holder.Close

	Close.MouseEnter:Connect(function() -- line: 1438
		-- upvalues: TweenService (copy), Close (copy), Sounds (copy)
		TweenService:Create(Close, TweenInfo.new(0.25), {
			Size = UDim2.fromScale(0.105, 0.105)
		}):Play()
		Sounds:Play("hover")
	end)
	Close.MouseLeave:Connect(function() -- line: 1450
		-- upvalues: TweenService (copy), Close (copy), Sounds (copy)
		TweenService:Create(Close, TweenInfo.new(0.25), {
			Size = UDim2.fromScale(0.071, 0.092)
		}):Play()
		Sounds:Play("hoverEnd")
	end)
	Close.MouseButton1Down:Connect(function() -- line: 1462
		-- upvalues: t4 (copy), Sounds (copy)
		t4.ShopMenu:ToggleMenu(false)
		Sounds:Play("click")
	end)
	Menu.Holder.Page:ClearAllChildren()

	local function isTabRejected(b18: boolean, s2: string, p34, s3: string?) -- line: 1470
		-- upvalues: NotFound (copy), Menu (copy), t4 (copy)
		if b18 then
			return nil
		end

		warn(`[{ script }]: Tab '{ s2 }' rejected during '{ s3 or "unknown" }' stage.`)

		if p34 then
			warn(`[{ script }]: Response: { p34 }`)
		end

		local clone = NotFound:Clone()

		clone.Name = s2
		clone.Parent = Menu.Holder.Page
		clone.Position = UDim2.fromScale(1, 0)
		t4.Tabs[s2] = clone

		return clone
	end

	for _, child in Menu.Holder.TabButtons:GetChildren() do
		if child:IsA("TextButton") then
            child.Size=UDim2.fromScale(0.475,0.732)
			child.MouseEnter:Connect(function() -- line: 1496
				-- upvalues: TweenService (copy), child (copy), Sounds (copy)
				TweenService:Create(child, TweenInfo.new(0.25), {
					Size = UDim2.fromScale(0.5, 0.75)
				}):Play()
				Sounds:Play("hover")
			end)
			child.MouseLeave:Connect(function() -- line: 1508
				-- upvalues: TweenService (copy), child (copy), Sounds (copy)
				TweenService:Create(child, TweenInfo.new(0.25), {
					Size = UDim2.fromScale(0.475, 0.732)
				}):Play()
				Sounds:Play("hoverEnd")
			end)
			child.MouseButton1Down:Connect(function() -- line: 1520
				-- upvalues: t4 (copy), child (copy), Sounds (copy)
				t4:SwitchTab(child.Name)
				Sounds:Play("click")
			end)

			local childName = child.Name
			local childName2 = script.Tabs:FindFirstChild(childName)

			if not isTabRejected(childName2 ~= nil, childName, "no ModuleScript found", "lookup") then
				local ok, result = xpcall(function() -- line: 1531
					-- upvalues: childName2 (copy)
					return require(childName2)
				end, debug.traceback)

				if not isTabRejected(ok, childName, result, "require") then
					local ok3, result3 = xpcall(function() -- line: 1536
						-- upvalues: result (copy), t9 (copy)
						return result.new(t9)
					end, debug.traceback)

					if not isTabRejected(ok3, childName, result3, "new()") then
						result3.Name = childName
						result3.Parent = Menu.Holder.Page
						result3.Position = UDim2.fromScale(1, 0)
						t4.TabLogic[childName] = result
						t4.Tabs[childName] = result3
					end
				end
			end
		end
	end

	setupViewportRig()
	t9.OnPurchased:Connect(function() -- line: 1551
		-- upvalues: t9 (copy)
		t9:ClearConfirmationUI()
	end)
	t4:SwitchTab("Skins")
end

return t4
]========])
assert(game.ReplicatedStorage.Systems.Player.UI.Menus.UpdateLog.Source==[========[
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local _ = LocalPlayer.PlayerGui
local DataHandler = require(ReplicatedStorage.Modules.DataHandler)
local Network = require(ReplicatedStorage.Modules.Network)
local Sounds = require(ReplicatedStorage.Modules.Sounds)
local Util = require(ReplicatedStorage.Modules.Util)
local DiscordMarkdown = require(script.DiscordMarkdown)
local UpdatelogPresets = ReplicatedStorage.Assets.UI.UpdatelogPresets
local Changelogs = ReplicatedStorage.Assets.Changelogs
local __createComponent = nil
local t4 = {
	TextTemplate = function(t1: {[any]: any}, p1) -- line: 26
		p1.Text = t1.Content
	end,
	ImageTemplate = function(t2: {[any]: any}, p2) -- line: 30
		p2.Image = t2.Content
		p2.Subtitle.Text = t2.Text
	end,
	ItemsTemplate = function(t3: {[any]: any}, p3) -- line: 35
		-- upvalues: __createComponent (ref)
		for i, v in ipairs(t3.Content) do
			local v35 = __createComponent(v, p3)

			if v35 then
				v35.LayoutOrder = i
				v35.Parent = p3
			end
		end
	end
}
local LatestLog = Changelogs:GetAttribute("LatestLog")
local TextTitle = nil
local t5 = {}
local latestOrder = math.huge
local latestKey = nil

local function __toYYMMDD(p4) -- line: 53
	local v37, v38, v39 = p4:match("(%d+)-(%d+)-(%d+)")

	return string.format("%02d%02d%02d", tonumber(v39), tonumber(v37), (tonumber(v38)))
end
local function __generateLegacyLayout(t6: {[any]: any}, p5) -- line: 58
	-- upvalues: UpdatelogPresets (copy)
	local n1 = 0

	for i = 1, #t6.Notes do
		local v44 = t6.Notes[i]
		local clone = UpdatelogPresets.Components.Header:Clone()

		clone.Text = v44.Header
		clone.LayoutOrder = n1
		clone.Parent = p5

		local clone2 = UpdatelogPresets.Components.Seperator:Clone()

		clone2.LayoutOrder = n1 + 1
		clone2.Parent = p5

		local clone3 = UpdatelogPresets.Components.TextPreset:Clone()

		clone3.Main.Text = v44.Body
		clone3.Size = v44.NoteSize or UDim2.fromScale(0.9, 0.25)
		clone3.LayoutOrder = n1 + 2
		clone3.Parent = p5
		n1 += 3
	end
end

function __createComponent(t7: {[any]: any}, p6) -- line: 82
	-- upvalues: t4 (copy)
	local t7Type = script.Presets.Components:FindFirstChild(t7.Type)

	if not t7Type then
		warn(`[{ script }]: Invalid component type: { t7.Type }`)

		return nil
	end

	local clone = t7Type:Clone()
	local v52 = t4[t7.Type]

	if v52 then
		local ok, result = pcall(v52, t7, clone)

		if not ok then
			warn(`[{ script }]: Failed to run callback for component: { t7.Type }, { debug.traceback(result) }`)
		end
	end

	for k, v in next, t7.Style or {} do
		clone[k] = v
	end

	clone.Parent = p6

	return clone
end

local function __generateLayout(t8: {[any]: any}, p7) -- line: 107
	-- upvalues: __createComponent (ref)
	local clone = script.Presets.UpdateDisplayTemplate:Clone()
	local n2 = 0

	local function __increment() -- line: 111
		-- upvalues: n2 (ref)
		n2 += 1
	end

	for _, v in ipairs(t8) do
		local clone4 = script.Presets.Components.SubheaderTemplate:Clone()

		clone4.Header.Text = v.Header
		clone4.LayoutOrder = n2
		clone4.Parent = clone
		n2 += 1

		for _, v2 in ipairs(v.Content) do
			local v67 = __createComponent(v2, clone)

			if v67 then
				v67.LayoutOrder = n2
				n2 += 1
			end
		end
	end

	clone.Parent = p7
end
local function __switchPage(p8, t9: {[any]: any}) -- line: 139
	-- upvalues: DiscordMarkdown (copy), __generateLegacyLayout (copy), __generateLayout (copy)
	assert(typeof(t9) == "table", "meta is not a table!")
 if not t9.Markdown and t9.Notes and t9.Notes[1]and t9.Notes[1].Body then t9.IsLegacy=true end

	for _, v in next, p8.Holder.List:GetChildren() do
		if v:IsA("Frame") or v:IsA("TextLabel") then
			v:Destroy()
		end
	end

	local clone = script.Presets.Loading:Clone()

	clone.Parent = p8.Holder

	local clone5 = script.Presets.Components.HeaderTemplate:Clone()

	clone5.Background.Image = t9.TitleMeta.Image.Backdrop or t9.TitleMeta.Image.Large or t9.TitleMeta.Image.Title or ""
	clone5.Header.Text = t9.TitleMeta.Text.Title or "N/A"
	clone5.Description.Text = t9.TitleMeta.Text.Description or (t9.TitleMeta.Text.Date or "None Provided")
	clone5.LayoutOrder = -10
	clone5.Parent = p8.Holder.List

	if t9.Markdown then
		DiscordMarkdown.Render(t9.Markdown, p8.Holder.List)
	elseif t9.IsLegacy then
		__generateLegacyLayout(t9, p8.Holder.List)
	else
		__generateLayout(t9.Notes, p8.Holder.List)
	end

	clone:Destroy()
end

local t10 = {
	Menu = nil
}
local u25 = nil
local u26 = nil

function t10.OnTransitionState(b1: boolean) -- line: 175
	-- upvalues: t10 (copy), u26 (ref), u25 (ref), Lighting (copy), Util (copy), LocalPlayer (copy), TweenService (copy), Debris (copy)
	local Menu = t10.UpdateLogMenu.Menu

	if b1 then
		if u26 then
			u26:Destroy()
			u26 = nil
		end

		if u25 then
			u25:Destroy()
			u25 = nil
		end

		Menu.Position = UDim2.fromScale(0.5, 0.55)
		Menu.Size = UDim2.fromScale(1, 1.15)
		Menu.Visible = true

		local BlurEffect = Instance.new("BlurEffect")

		BlurEffect.Name = "ShopBlur"
		BlurEffect.Size = 0
		BlurEffect.Parent = Lighting
		u26 = BlurEffect
		u25 = Util:CreateFOVMultiplier(LocalPlayer, 1, "ShopZoom")
		TweenService:Create(BlurEffect, TweenInfo.new(0.225, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = 12
		}):Play()
		TweenService:Create(u25, TweenInfo.new(0.225, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Value = 0.85
		}):Play()
		TweenService:Create(Menu, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Position = UDim2.fromScale(0.5, 0.5)
		}):Play()

		return
	end

	Menu.Visible = false

	local v77 = u25
	local v78 = u26

	if u25 then
		TweenService:Create(u25, TweenInfo.new(0.225, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Value = 1
		}):Play()
	end

	if v78 then
		TweenService:Create(v78, TweenInfo.new(0.225, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = 0
		}):Play()
	end

	if v78 then
		Debris:AddItem(v78, 0.225)
	end

	if v77 then
		Debris:AddItem(v77, 0.225)
	end
end
function t10.Start(_) -- line: 251
	-- upvalues: ReplicatedStorage (copy), t10 (copy), DataHandler (copy), LatestLog (copy), TweenService (copy), Sounds (copy), Network (copy), Changelogs (copy), TextTitle (ref), __switchPage (copy), t5 (copy)
	task.spawn(function() -- line: 252
		-- upvalues: ReplicatedStorage (copy), t10 (copy), DataHandler (copy), LatestLog (copy), TweenService (copy), Sounds (copy), Network (copy), Changelogs (copy), TextTitle (ref), __switchPage (copy), t5 (copy)
		t10.UpdateLogMenu = require(ReplicatedStorage.Initializer).PlayerSystems.SidebarHandler:CreateSidebarMenu("UpdateLog", script.UpdateScreen)


		local Menu = t10.UpdateLogMenu.Menu
		local Close = Menu.Holder.Close

		Close.MouseEnter:Connect(function() -- line: 264
			-- upvalues: TweenService (copy), Close (copy), Sounds (copy)
			TweenService:Create(Close, TweenInfo.new(0.25), {
				Size = UDim2.fromScale(0.105, 0.105)
			}):Play()
			Sounds:Play("hover")
		end)
		Close.MouseLeave:Connect(function() -- line: 276
			-- upvalues: TweenService (copy), Close (copy), Sounds (copy)
			TweenService:Create(Close, TweenInfo.new(0.25), {
				Size = UDim2.fromScale(0.074, 0.095)
			}):Play()
			Sounds:Play("hoverEnd")
		end)
		Close.MouseButton1Down:Connect(function() -- line: 288
			-- upvalues: t10 (copy), Network (copy), Sounds (copy)
			t10.UpdateLogMenu:ToggleMenu(false)
			Network:FireServerConnection("UpdateLogToLatest", "REMOTE_EVENT")
			Sounds:Play("click")
		end)

		for _, v in next, Changelogs:GetChildren() do
			local ok, result = pcall(function() -- line: 295
				-- upvalues: v (copy)
				return require(v)
			end)

			if not ok then
				warn(`Failed to load changelog { v.Name }: { result }`)
			else
				local clone = script.Presets.UpdateTemplate:Clone()

				clone.Name = result.TitleMeta.Text.Title
				clone.UpdateName.Text = result.TitleMeta.Text.Title or "N/A"
				clone.Description.Text = result.TitleMeta.Text.Description or (result.TitleMeta.Text.Date or "None Provided")
				clone.Render.Image = result.TitleMeta.Image.Backdrop or result.TitleMeta.Image.Small or result.TitleMeta.Image.Title or ""

				local v87, v88, v89 = result.TitleMeta.Text.Date:match("(%d+)-(%d+)-(%d+)")

				clone.LayoutOrder = -string.format("%02d%02d%02d", tonumber(v89), tonumber(v87), (tonumber(v88)))
				clone.Parent = Menu.List.Updates
                if clone.LayoutOrder < latestOrder or (clone.LayoutOrder == latestOrder and (not latestKey or v.Name > latestKey)) then
                    latestOrder = clone.LayoutOrder
                    latestKey = v.Name
                end
				clone.MouseEnter:Connect(function() -- line: 312
					-- upvalues: Sounds (copy)
					Sounds:Play("hover")
				end)
				clone.MouseLeave:Connect(function() -- line: 316
					-- upvalues: Sounds (copy)
					Sounds:Play("hoverEnd")
				end)
				clone.MouseButton1Down:Connect(function() -- line: 320
					-- upvalues: TextTitle (ref), result (copy), __switchPage (copy), Menu (copy), Sounds (copy)
					if TextTitle == result.TitleMeta.Text.Title then
						return
					end

					__switchPage(Menu, result)
                    TextTitle = result.TitleMeta.Text.Title
					Sounds:Play("click")
				end)
				t5[v.Name] = result
			end
		end

		LatestLog = Changelogs:GetAttribute("LatestLog")
        if not t5[LatestLog] then LatestLog = latestKey end
        if t5[LatestLog] then
            __switchPage(Menu, t5[LatestLog])
            TextTitle = t5[LatestLog].TitleMeta.Text.Title
        end
        if t5[LatestLog]and DataHandler:Get().Misc.LastSeenLog.Value ~= LatestLog then t10.UpdateLogMenu:ToggleMenu(true)end
	end)
end

return t10
]========])
assert(game.ReplicatedStorage.Modules.PlayerList.Source==[========[
local t1 = {
	_players = {},
	DisplayedStats = {
		"Money",
		"Kills"
	},
	ListEnabled = true
}
local SocialService = game:GetService("SocialService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

game:GetService("TextChatService")

local v6 = RunService:IsStudio()
local clamp = math.clamp
local LocalPlayer = Players.LocalPlayer

require(game.ReplicatedStorage.Modules.Actors)

local DataHandler = require(game.ReplicatedStorage.Modules.DataHandler)
local Util = require(game.ReplicatedStorage.Modules.Util)
local Sounds = require(game.ReplicatedStorage.Modules.Sounds)
local Network = require(game.ReplicatedStorage.Modules.Network)
local t2 = {
	Kills = "Kills",
	RbxSpent = "R$ Spent"
}
local t3 = {
	PC = "rbxassetid://135066638879377",
	Mobile = "rbxassetid://89227325753198",
	Console = "rbxassetid://118447973769044",
	Unknown = "rbxassetid://94182197303121",
	NoChat = "rbxassetid://8509669675"
}

local function getPath(p1, s1: string, n1: number?) -- line: 51
	assert(typeof(p1) == "Instance")
	assert(typeof(s1) == "string")

	if s1 == "" then
		return p1
	end

	for _, v23 in (string.split(s1, "/")) do
		if typeof(n1) ~= "number" then
			p1 = p1:FindFirstChild(v23)

			if p1 ~= nil then
				continue
			end

			return
		end

		p1 = p1:WaitForChild(v23, n1)

		if p1 == nil then
			return
		end
	end

	return p1
end

function t1.GetPlayerListUI(p2) -- line: 76
	if not p2.PlayerList then
		repeat
			task.wait()
		until p2.PlayerList
	end

	return p2.PlayerList
end

local thread = nil
local u17 = true

function t1.TogglePlayerList(_, p4, p5) -- line: 85
	-- upvalues: t1 (copy), Sounds (copy), thread (ref), u17 (ref)
	if p5 then
		t1.ListEnabled = p4
	elseif not t1.ListEnabled then
		return
	end

	if not p5 then
		Sounds:Play("switch")
	end

	local PlayerListUI = t1:GetPlayerListUI()

	if thread then
		task.cancel(thread)
	end

	if p4 then
		u17 = true
		PlayerListUI.Close.Text = ">"
		PlayerListUI.Close.Visible = true
		PlayerListUI.Contents.Visible = true
		PlayerListUI.Background.Visible = true
		PlayerListUI.FriendBoost.Visible = true
		game.TweenService:Create(PlayerListUI, TweenInfo.new(0.15), {
			AnchorPoint = script.PlayerListHolder.AnchorPoint,
			Position = script.PlayerListHolder.Position
		}):Play()

		return
	end

	u17 = false
	PlayerListUI.Close.Text = "<"
	game.TweenService:Create(PlayerListUI, TweenInfo.new(0.15), {
		AnchorPoint = Vector2.new(),
		Position = UDim2.new(1, 0, 0, script.PlayerListHolder.Position.Y.Offset)
	}):Play()
	thread = task.delay(0.15, function() -- line: 116
		-- upvalues: p5 (copy), PlayerListUI (copy)
		if p5 then
			PlayerListUI.Close.Visible = false
		end

		PlayerListUI.Contents.Visible = false
		PlayerListUI.Background.Visible = false
		PlayerListUI.FriendBoost.Visible = false
	end)
end

local t4 = {}

function t1.ShowPlayerStats(t5: {[any]: any}, p6) -- line: 127
	-- upvalues: t4 (copy), Sounds (copy), t1 (copy), t3 (copy), DataHandler (copy), Util (copy), LocalPlayer (copy)
	for _, v in pairs(t4) do
		v:Disconnect()
	end

	table.clear(t4)

	if t5.__currentlyDisplayedStats and t5.__currentlyDisplayedStats.Parent then
		if tostring(t5.__currentlyDisplayedStats) == tostring(p6) then
			game.TweenService:Create(t5.__currentlyDisplayedStats, TweenInfo.new(0.15), {
				Size = UDim2.fromScale()
			}):Play()
			game.Debris:AddItem(t5.__currentlyDisplayedStats, 0.15)
			t5.__currentlyDisplayedStats = nil

			return
		end

		t5.__currentlyDisplayedStats:Destroy()
	end

	local clone = script.PlayerStats:Clone()

	clone.Name = tostring(p6)
	clone.Close.MouseEnter:Connect(function() -- line: 150
		-- upvalues: Sounds (copy)
		Sounds:Play("hover")
	end)
	clone.Close.MouseLeave:Connect(function() -- line: 151
		-- upvalues: Sounds (copy)
		Sounds:Play("hoverEnd")
	end)
	clone.Close.MouseButton1Click:Connect(function() -- line: 152
		-- upvalues: Sounds (copy), t1 (copy), p6 (copy)
		Sounds:Play("select")
		t1:ShowPlayerStats(p6)
	end)

	local v34 = `@{ p6.Name }`
	local v35 = p6.DisplayName ~= p6.Name and (p6.DisplayName ~= "" and p6.DisplayName)

	clone.BasicInfo.PlayerName.Text = v35 or v34
	clone.BasicInfo.PlayerUsername.Text = v34
	clone.BasicInfo.PlayerUsername.Visible = v35
	task.spawn(function() -- line: 164
		-- upvalues: p6 (copy), clone (copy)
		local UserId = p6.UserId
		local UserThumbnailAsync = game.Players:GetUserThumbnailAsync(UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)

		clone.PlayerIconHolder.Player.Image = UserThumbnailAsync
	end)

	local function updatePlayerDevice() -- line: 171
		-- upvalues: t3 (copy), p6 (copy), clone (copy)
		local v93 = t3[p6:GetAttribute("Device")] or t3.Unknown

		clone.PlayerIconHolder.Device.Image = v93
	end

	local v37 = t3[p6:GetAttribute("Device")] or t3.Unknown

	clone.PlayerIconHolder.Device.Image = v37
	table.insert(t4, p6:GetAttributeChangedSignal("Device"):Connect(updatePlayerDevice))

	local v38 = DataHandler:Get(p6)
	local v39 = v38 and v38:FindFirstChild("Stats")
	local v40 = v38 and v38:FindFirstChild("Equipped")

	if v39 and v40 then
		local General = v39:FindFirstChild("General")
		local v42 = General and General:FindFirstChild("TimePlayed")

		if v42 then
			local function updateTimePlayed() -- line: 256
				-- upvalues: Util (copy), p6 (copy), clone (copy), v42 (copy)
				local SettingValue = Util:GetSettingValue("HidePlaytime", p6)

				clone.TimePlayed.Text = `Time Played: { (if not SettingValue then Util:FormatTime(v42.Value, "Clock") else "<font color=\"rgb(125,125,125)\"><i>(Hidden)</i></font>") }`
			end

			local SettingValue = Util:GetSettingValue("HidePlaytime", p6)

			clone.TimePlayed.Text = `Time Played: { (if not SettingValue then Util:FormatTime(v42.Value, "Clock") else "<font color=\"rgb(125,125,125)\"><i>(Hidden)</i></font>") }`
			table.insert(t4, v42:GetPropertyChangedSignal("Value"):Connect(updateTimePlayed))
		end

		for _, v in pairs({
			"Killer",
			"Survivor"
		}) do
			local v47 = v39 and v39:FindFirstChild(`{ v }Stats`)
			local v48 = v47 and v47:FindFirstChild(`{ v }Kills`)

			if v48 then
				local SettingValue = Util:GetSettingValue(`Hide{ v }Wins`, p6)
				local v50 = clone.WinInfo:FindFirstChild(`{ v }Wins`)

				v50.MouseEnter:Connect(function() -- line: 275
					-- upvalues: Util (copy), v (copy), SettingValue (copy)
					Util:CreateTooltip(`{ v } Kills{ not SettingValue and "" or " <font color=\"rgb(125,125,125)\"><i>(Hidden)</i></font>" }`)
				end)
				v50.MouseLeave:Connect(function() -- line: 276
					-- upvalues: Util (copy)
					Util:CreateTooltip()
				end)

				local function setScore() -- line: 279
					-- upvalues: v50 (copy), SettingValue (copy), v48 (copy)
					v50.Wins.Text = if not SettingValue then v48.Value else "<font color=\"rgb(125,125,125)\"><i>(Hidden)</i></font>"
				end

				v50.Wins.Text = if not SettingValue then v48.Value else "<font color=\"rgb(125,125,125)\"><i>(Hidden)</i></font>"
				table.insert(t4, v48:GetPropertyChangedSignal("Value"):Connect(setScore))
			end

			if v40 then
				local t6 = {}

				local function setEquippedIcon() -- line: 292
					-- upvalues: p6 (copy), v (copy), t6 (ref), clone (copy), Util (copy)
					local v95, v96 = require(game.ReplicatedStorage.Modules.Actors):GetEquippedActorInfo(p6, v)
					local v97 = game.ReplicatedStorage.Assets:FindFirstChild(`{ v }s`):FindFirstChild(v95)
					local v98 = v97 and (v97:FindFirstChild("Config") and require(v97.Config))
					local v99 = game.ReplicatedStorage.Assets.Skins:FindFirstChild(`{ v }s`):FindFirstChild(v95)
					local v100 = v99 and v99:FindFirstChild(v96)
					local v101 = v100 and (v100:FindFirstChild("Config") and require(v100.Config))

					if v98 then
						for _, v2 in pairs(t6) do
							v2:Disconnect()
						end

						table.clear(t6)

						local v3 = clone.BasicInfo.EquippedCharacters:FindFirstChild(v)
						local u105 = `Equipped { v }: <i>{ v98.DisplayName or tostring(v97) }</i>`

						if v101 then
							u105 = `{ u105 }\nEquipped Skin: <i>{ v101.DisplayName or tostring(v100) }</i>`
						end

						v3.Image = v101 and v101.RenderImage or (v98.RenderImage or "rbxassetid://13373279056")
						t6 = {
							v3.MouseEnter:Connect(function() -- line: 316
								-- upvalues: Util (copy), u105 (ref)
								Util:CreateTooltip(u105)
							end),
							v3.MouseLeave:Connect(function() -- line: 317
								-- upvalues: Util (copy)
								Util:CreateTooltip()
							end)
						}
					end
				end

				local v4 = v40:FindFirstChild(v)
				local v5 = v40.Skins:FindFirstChild(v)

				setEquippedIcon()

				if v4 then
					table.insert(t4, v4:GetPropertyChangedSignal("Value"):Connect(setEquippedIcon))
				end

				if v5 then
					table.insert(t4, v5:GetPropertyChangedSignal("Value"):Connect(setEquippedIcon))
				end
			end
		end
	end

	if not t5.__currentlyDisplayedStats then
		clone.Size = UDim2.new()
		game.TweenService:Create(clone, TweenInfo.new(0.15), {
			Size = script.PlayerStats.Size
		}):Play()
	end

	clone.Parent = LocalPlayer.PlayerGui.TemporaryUI
	t5.__currentlyDisplayedStats = clone
	clone.AncestryChanged:Connect(function(_, parent) -- line: 345
		-- upvalues: Util (copy), t4 (copy)
		if not parent then
			Util:CreateTooltip()

			for _, v in pairs(t4) do
				v:Disconnect()
			end

			table.clear(t4)
		end
	end)
end
function t1.CreatePlayerInList(_: {[any]: any}, p8) -- line: 356
	-- upvalues: t1 (copy), Util (copy), Network (copy), v6 (copy)
	if not p8 then
		return
	end

	local PlayerListUI = t1:GetPlayerListUI()
	local v59 = PlayerListUI.Contents.Players:FindFirstChild((tostring(p8)))

	if v59 then
		v59:Destroy()
	end

	local clone = script.PlayerInfoContainer:Clone()

	clone.Name = tostring(p8)

	local p8Name = p8.Name
	local v62 = p8.DisplayName ~= p8.Name and (p8.DisplayName ~= "" and p8.DisplayName)

	local baseName = v62 or p8Name
	clone.PlayerInfo.Username.Text = baseName
	clone.PlayerInfo.Username.RichText = true

	local function updateAFKStatus()
		local afkValue = Util:GetSettingValue("AFK", p8)
		local isAFK = afkValue == true or (typeof(afkValue) == "number" and afkValue > 0)
		clone.PlayerInfo.Username.Text = isAFK and `{baseName} <font color="#B82500">[AFK]</font>` or baseName
	end

	task.spawn(function()
		local playerData = DataHandler:Get(p8)
		if not playerData then return end
		local settings = playerData:FindFirstChild("Settings")
		if not settings then return end
		local afkSetting = settings:FindFirstChild("AFK", true)
		if afkSetting then
			afkSetting:GetPropertyChangedSignal("Value"):Connect(updateAFKStatus)
		end
		updateAFKStatus()
	end)

	clone.ShowStats.MouseButton1Click:Connect(function() -- line: 375
		-- upvalues: t1 (copy), p8 (copy)
		t1:ShowPlayerStats(p8)
	end)

	if t1.DisplayedStats and t1.DisplayedStats[1] then
		local leaderstats = p8:WaitForChild("leaderstats", 30)

		if not leaderstats or not p8.Parent then
			return
		end

		for _, child in pairs(leaderstats:GetChildren()) do
			local clone2 = clone.PlayerInfo.Username:Clone()

			clone2.Name = child and child.Name
			clone2.Size = UDim2.fromScale(0.3, 1)
			clone2.LayoutOrder = table.find(t1.DisplayedStats, child.Name)
			clone2.TextXAlignment = Enum.TextXAlignment.Center
			clone2.Parent = clone.PlayerInfo

			local function updateStat() -- line: 396
				-- upvalues: child (copy), clone2 (copy), Util (copy)
				local v110 = child and child.Value or "?"

				if tonumber(v110) then
					clone2.TextColor3 = v110 > 0 and Color3.new(1, 1, 1) or Color3.new(1, 0, 0)
					v110 = Util:ConvertToAbbreviation(v110)
				end

				if child.Name == "Money" then
					v110 = `${ v110 }`
				end

				clone2.Text = tostring(v110)
			end

			updateStat()

			if child then
				child:GetPropertyChangedSignal("Value"):Connect(updateStat)
			end
		end
	end

	local v68 = Network:FireServerConnection("ReturnCanChat", "REMOTE_FUNCTION", p8)

	if v6 or not v68 then
		clone.NoChat.Visible = true
		clone.NoChat.MouseEnter:Connect(function() -- line: 422
			-- upvalues: Util (copy)
			Util:CreateTooltip("You cannot communicate with this player.")
		end)
		clone.NoChat.MouseLeave:Connect(function() -- line: 425
			-- upvalues: Util (copy)
			Util:CreateTooltip()
		end)
	end

	clone.Parent = PlayerListUI.Contents.Players
	t1:__UpdateListSize()
end
function t1.RemovePlayerFromList(_: {[any]: any}, p9) -- line: 437
	-- upvalues: t1 (copy)
	local v71 = t1:GetPlayerListUI().Contents.Players:FindFirstChild((tostring(p9)))

	if v71 then
		v71:Destroy()
	end

	t1:__UpdateListSize()
end
function t1.__UpdateListSize(_) -- line: 450
	-- upvalues: t1 (copy)
	local PlayerListUI = t1:GetPlayerListUI()
	local UIListLayout = PlayerListUI.Contents.Players.UIListLayout
	local v75 = UIListLayout.AbsoluteContentSize.Y + UIListLayout.Padding.Offset

	PlayerListUI.Background.Size = UDim2.fromScale(1, (math.clamp(0.05 + 30 / PlayerListUI.AbsoluteSize.Y + v75 / PlayerListUI.AbsoluteSize.Y, 0, 1)))
	PlayerListUI.FriendBoost.Position = UDim2.fromScale(0, (math.clamp(0.05 + 30 / PlayerListUI.AbsoluteSize.Y + v75 / PlayerListUI.AbsoluteSize.Y, 0, 1)))
end
function t1.Start(p11) -- line: 460
	-- upvalues: LocalPlayer (copy), t1 (copy), t2 (copy), SocialService (copy), clamp (copy), Util (copy), u17 (ref), Sounds (copy)
	if game["Run Service"]:IsServer() then
		return
	end

	local clone = script.PlayerListHolder:Clone()
	local Contents = clone.Contents

	clone.Parent = LocalPlayer.PlayerGui:WaitForChild("MainUI")
	Contents:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 521
		-- upvalues: t1 (copy)
		t1:__UpdateListSize()
	end)

	for k, v in pairs(t1.DisplayedStats) do
		local clone3 = Contents.InfoTypes.Players:Clone()

		clone3.Name = v
		clone3.Text = t2[v] or v:gsub("(%l)(%u)", "%1 %2")
		clone3.Size = UDim2.fromScale(0.3, 1)
		clone3.LayoutOrder = k + 1
		clone3.TextXAlignment = Enum.TextXAlignment.Center
		clone3.Parent = Contents.InfoTypes
	end

	local _ = {
		JOINING = true,
		LEAVING = false
	}
	local ExperienceInviteOptions = Instance.new("ExperienceInviteOptions")

	ExperienceInviteOptions.PromptMessage = `Invite Friends, get { 10 }% more EXP per friend! (caps at { 20 }%).`

	local function __canSendInvite(p12) -- line: 547
		-- upvalues: SocialService (copy)
		local ok, result = pcall(function() -- line: 548
			-- upvalues: SocialService (copy), p12 (copy)
			return SocialService:CanSendGameInviteAsync(p12)
		end)

		return ok and result
	end

	local Button = clone.FriendBoost.Button

	Button.MouseButton1Down:Connect(function() -- line: 556
		-- upvalues: LocalPlayer (copy), SocialService (copy), ExperienceInviteOptions (copy)
		local v114 = LocalPlayer
		local ok, result = pcall(function() -- line: 548
			-- upvalues: SocialService (copy), v114 (copy)
			return SocialService:CanSendGameInviteAsync(v114)
		end)

		if ok and result then
			SocialService:PromptGameInvite(LocalPlayer, ExperienceInviteOptions)
		end
	end)

	local n2 = 0

	local function __setBoostDisplay(p13, b1: boolean) -- line: 564
		-- upvalues: LocalPlayer (copy), n2 (ref), clamp (copy), Button (copy)
		local ok, result = pcall(function() -- line: 566
			-- upvalues: LocalPlayer (copy), p13 (copy)
			return LocalPlayer:IsFriendsWith(p13.UserId)
		end)

		if ok and result then
			n2 = clamp(n2 + 10 * (not b1 and -1 or 1), 0, 20)
		end

		local v121 = `Invite Friends (+{ n2 }% EXP)`

		if v121 ~= Button.Text then
			Button.Text = v121
		end
	end

	Util.OnPlayerAdded(function(p14) -- line: 587
		-- upvalues: LocalPlayer (copy), n2 (ref), clamp (copy), Button (copy), t1 (copy)
		if p14 ~= LocalPlayer then
			local ok, result = pcall(function() -- line: 566
				-- upvalues: LocalPlayer (copy), p14 (copy)
				return LocalPlayer:IsFriendsWith(p14.UserId)
			end)

			if ok and result then
				n2 = clamp(n2 + 10, 0, 20)
			end

			local v125 = `Invite Friends (+{ n2 }% EXP)`

			if v125 ~= Button.Text then
				Button.Text = v125
			end
		end

		t1:CreatePlayerInList(p14)
	end)
	game.Players.PlayerRemoving:Connect(function(player) -- line: 596
		-- upvalues: LocalPlayer (copy), n2 (ref), clamp (copy), Button (copy), t1 (copy)
		if player ~= LocalPlayer then
			local ok, result = pcall(function() -- line: 566
				-- upvalues: LocalPlayer (copy), player (copy)
				return LocalPlayer:IsFriendsWith(player.UserId)
			end)

			if ok and result then
				n2 = clamp(n2 + -10, 0, 20)
			end

			local v129 = `Invite Friends (+{ n2 }% EXP)`

			if v129 ~= Button.Text then
				Button.Text = v129
			end
		end

		t1:RemovePlayerFromList(player)
	end)
	clone.Close.MouseButton1Click:Connect(function() -- line: 604
		-- upvalues: t1 (copy), u17 (ref)
		t1:TogglePlayerList(not u17)
	end)
	game.UserInputService.InputBegan:Connect(function(input, gameProcessed) -- line: 608
		-- upvalues: t1 (copy), u17 (ref)
		if gameProcessed then
			return
		end

		if input.KeyCode == Enum.KeyCode.Tab then
			t1:TogglePlayerList(not u17)
		end
	end)

	local function addSFX(p15) -- line: 616
		-- upvalues: Sounds (copy)
		if p15:IsA("ImageButton") or p15:IsA("TextButton") then
			p15.MouseEnter:Connect(function() -- line: 618
				-- upvalues: Sounds (copy)
				Sounds:Play("hover")
			end)
			p15.MouseLeave:Connect(function() -- line: 619
				-- upvalues: Sounds (copy)
				Sounds:Play("hoverEnd")
			end)
			p15.MouseButton1Click:Connect(function() -- line: 620
				-- upvalues: Sounds (copy)
				Sounds:Play("select")
			end)
		end
	end

	for _, descendant in pairs(clone:GetDescendants()) do
		addSFX(descendant)
	end

	clone.DescendantAdded:Connect(addSFX)
	p11.PlayerList = clone
	game.StarterGui:SetCoreGuiEnabled("PlayerList", false)
end

return t1

]========])
assert(game.ServerScriptService.Server.Systems.Data.LeaderStats.Source==[========[
local module = {}
function module.AddStats(_, player)
 task.spawn(function()
  local data=player:WaitForChild("PlayerData")
  local stats=data:WaitForChild("Stats")
  local money=stats:FindFirstChild("Money",true)
  local total=stats:WaitForChild("General"):WaitForChild("TotalKills")
  if not player.Parent then return end
  local newStats=Instance.new("Folder")
  newStats.Name="leaderstats"
  local moneyDisplay=Instance.new("NumberValue");moneyDisplay.Name="Money";moneyDisplay.Value=money and money.Value or 0;moneyDisplay.Parent=newStats
  local killsDisplay=Instance.new("NumberValue");killsDisplay.Name="Kills";killsDisplay.Value=total.Value;killsDisplay.Parent=newStats
  local connections={}
  if money then table.insert(connections,money:GetPropertyChangedSignal("Value"):Connect(function()moneyDisplay.Value=money.Value end))end
  table.insert(connections,total:GetPropertyChangedSignal("Value"):Connect(function()killsDisplay.Value=total.Value end))
  newStats.Destroying:Connect(function()for _,connection in connections do connection:Disconnect()end end)
  newStats.Parent=player
 end)
end
return module
]========])
setup();game.ReplicatedStorage.Modules.PlayerList.Source="edited";assert(not pcall(install));assert(game.ReplicatedStorage.Modules.PlayerList.Source=="edited")
setup();failAt=writes+2;assert(not pcall(install))
assert(game.ReplicatedStorage.Systems.Player.UI.Menus.Shop.Source==[========[
require(game.ReplicatedStorage.GlobalTypes)

local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Debris = game:GetService("Debris")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")
local MarketplaceService = game:GetService("MarketplaceService")
local UserInputService = game:GetService("UserInputService")
local Util = require(game.ReplicatedStorage.Modules.Util)
local CurrencyDisplay = require(script.Parent.Parent.SidebarHandler.Classes.CurrencyDisplay)
local Sounds = require(game.ReplicatedStorage.Modules.Sounds)
local Network = require(game.ReplicatedStorage.Modules.Network)
local DataHandler = require(game.ReplicatedStorage.Modules.DataHandler)
local Trove = require(game.ReplicatedStorage.Modules.Misc.Trove)
local Signal = require(game.ReplicatedStorage.Modules.Misc.Signal)
local Device = require(game.ReplicatedStorage.Modules.CombatMenuCompat.Device)
local RigBuilder = require(script.Classes.RigBuilder)
local ShopSale = require(game.ReplicatedStorage.Modules.CombatMenuCompat.ShopSale)
local LocalPlayer = Players.LocalPlayer
local t1 = {}
local NotFound = script.Assets.NotFound
local EmoteViewport = script.Assets.EmoteViewport
local ConfirmUI = script.Assets.ConfirmUI
local t2 = {
	success = "Bought!",
	poor = "Insufficient funds!",
	alreadyBought = "Already owned! (You were not charged)",
	ratelimited = "Ratelimited! (You were not charged)",
	failed = "Something went wrong... (You were not charged)",
	priceChanged = "Price changed! (You were not charged)"
}
local t3={}

local function setupViewportRig() -- line: 55
	-- upvalues: Players (copy), LocalPlayer (copy)
	local EmoteViewport2 = script.Assets.EmoteViewport

	EmoteViewport2.Parent = workspace.CurrentCamera

	local clone = EmoteViewport2.WorldModel.Rig:Clone()

	EmoteViewport2.WorldModel.Rig:Destroy()
	clone.Parent = EmoteViewport2.WorldModel

	local v44 = clone and clone:FindFirstChildOfClass("Humanoid")
	local ok, result = pcall(Players.GetHumanoidDescriptionFromUserIdAsync, Players, LocalPlayer.UserId)

	if ok and (result and v44) then
		local ok2, result2 = pcall(function() -- line: 67
			-- upvalues: v44 (copy), result (copy)
			v44:ApplyDescriptionAsync(result, Enum.AssetTypeVerification.ClientOnly)
		end)

		if not ok2 then
			warn(`[Shop/{ script }]: Failed to apply description to emote rig. Response: { result2 }`)

			return
		end
	else
		warn(`[Shop/{ script }]: No local player description. Response: { result }`)
	end
end
local function transitionHighlightToState(p1, b1: boolean) -- line: 79
	-- upvalues: t1 (copy), TweenService (copy)
	assert(p1 and p1:IsA("TextButton"), "transitionHighlightToState() There was no highlight to transition.")
	assert(b1 ~= nil, "transitionHighlightToState() There was no state to transition to.")

	local Highlight = p1:FindFirstChild("Highlight")
	local Text = p1:FindFirstChild("Text")

	if not Highlight or not Text then
		warn(`[{ script }]: Failed to transition highlight for: { p1.Name }, missing UI elements.`)

		return
	end

	if t1[p1] then
		return
	end

	t1[p1] = true
	Highlight.Visible = true
	TweenService:Create(Highlight, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
		ImageTransparency = not b1 and 1 or 0
	}):Play()
	TweenService:Create(Text, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
		TextColor3 = b1 and Color3.new(0, 0, 0) or Color3.new(1, 1, 1)
	}):Play()
	task.delay(0.5, function() -- line: 113
		-- upvalues: t1 (copy), p1 (copy), b1 (copy), Highlight (copy)
		t1[p1] = nil

		if not b1 then
			Highlight.Visible = false
		end
	end)
end
local function requireShopAsset(p2) -- line: 121
	if p2:IsA("ModuleScript") then
		return pcall(require, p2)
	end

	local Config = p2:FindFirstChild("Config")

	if Config and Config:IsA("ModuleScript") then
		return pcall(require, Config)
	end

	return false, `No Config ModuleScript found for { p2:GetFullName() }`
end
local function getSkinRigSource(p3) -- line: 134
	local v56 = p3:IsA("ModuleScript") and p3.Parent or p3

	if not v56 then
		return nil
	end

	local Rig = v56:FindFirstChild("Rig")

	if Rig and Rig:IsA("Model") then
		return Rig
	end

	return nil
end
local function transitionToFrame(p4, p5, b2: boolean) -- line: 149
	-- upvalues: TweenService (copy)
	assert(p5 and p5:IsA("Frame"), "transitionToFrame() There was no frame to transition to.")
	assert(b2 ~= nil, "transitionToFrame() There was no direction to transition to.")

	if p4 == nil then
		p5.Position = UDim2.fromScale(0, 0)

		return
	end

	p5.Position = b2 and UDim2.fromScale(-1, 0) or UDim2.fromScale(1, 0)
	p5.Visible = true
	TweenService:Create(p4, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
		Position = UDim2.fromScale(not b2 and -1 or 1, 0)
	}):Play()
	TweenService:Create(p5, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
		Position = UDim2.fromScale(0, 0)
	}):Play()
	task.delay(0.5, function() -- line: 178
		-- upvalues: p4 (copy)
		p4.Visible = false
	end)
end

local t4 = {}
local t9 = {
	FormatPrice = function(_: {[any]: any}, n1: number) -- line: 187
		-- upvalues: Util (copy)
		assert(typeof(n1) == "number", "ShopUtils:FormatPrice() requires a number.")

		if n1 <= 0 then
			return "FREE"
		end

		return `${ Util:ToCommas(n1) }`
	end,
	CreateSearchbar = function(_: {[any]: any}, p6, p7) -- line: 193
		assert(p6 and p6:IsA("TextBox"), "ShopUtils:CreateSearchbar() requires a TextBox.")
		assert(p7 and p7:IsA("GuiObject"), "ShopUtils:CreateSearchbar() requires a Frame.")
		p6:GetPropertyChangedSignal("Text"):Connect(function() -- line: 197
			-- upvalues: p7 (copy), p6 (copy)
			for _, child in (p7:GetChildren()) do
				if child:IsA("GuiObject") and not child:GetAttribute("ShopTemplate") and (not child:GetAttribute("Purchased") or not p7:GetAttribute("ToggledUnowned")) then
					child.Visible = p6.Text == "" or child.Name:lower():find(p6.Text:lower())
				end
			end
		end)
	end,
	SetPurchaseUIState = function(t7: {[any]: any}, b3: boolean) -- line: 212
		-- upvalues: Trove (copy), RunService (copy), TweenService (copy), LocalPlayer (copy)
		if b3 then
			if t7.__trove then
				t7.__trove:Destroy()
			end

			local v68 = Trove.new()

			t7.__trove = v68

			local clone = script.Assets.TransitionGui:Clone()

			clone.Purchase.BackgroundTransparency = 1
			clone.Purchase.Icon.ImageTransparency = 1
			v68:Add(clone)

			local Icon = clone.Purchase.Icon
			local n2 = -1
			local n3 = 0
			local n4 = 0
			local u74 = false

			v68:Connect(RunService.Heartbeat, function(n5: number) -- line: 236
				-- upvalues: n2 (ref), n3 (ref), n4 (ref), u74 (ref), TweenService (copy), Icon (copy)
				n2 += n5 * 1.5
				n3 += n2 * n5

				if n3 > 0.5 then
					n3 = 0.5
					n2 = -1
					n4 += 1

					if n4 % 2 == 0 then
						u74 = not u74
						TweenService:Create(Icon, TweenInfo.new(2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
							Rotation = Icon.Rotation + (not u74 and -360 or 360)
						}):Play()
					end
				end

				Icon.Position = UDim2.fromScale(0.5, n3)
			end)
			clone.Parent = LocalPlayer.PlayerGui
			TweenService:Create(clone.Purchase, TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
				BackgroundTransparency = 0.35
			}):Play()
			TweenService:Create(Icon, TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
				ImageTransparency = 0
			}):Play()

			return
		end

		if t7.__trove then
			t7.__trove:Destroy()
			t7.__trove = nil
		end
	end,
	CreateUnownedButton = function(_: {[any]: any}, p8, p9) -- line: 285
		-- upvalues: Sounds (copy)
		assert(p8 and p8:IsA("TextButton"), "ShopUtils:CreateUnownedButton() requires a TextButton.")
		assert(p9 and p9:IsA("GuiObject"), "ShopUtils:CreateUnownedButton() requires a Frame.")
		p8.MouseEnter:Connect(function() -- line: 289
			-- upvalues: Sounds (copy)
			Sounds:Play("hover")
		end)
		p8.MouseLeave:Connect(function() -- line: 293
			-- upvalues: Sounds (copy)
			Sounds:Play("hoverEnd")
		end)
		p9:SetAttribute("ToggledUnowned", false)
		p8.MouseButton1Down:Connect(function() -- line: 298
			-- upvalues: Sounds (copy), p9 (copy), p8 (copy)
			Sounds:Play("click")

			local v225 = not p9:GetAttribute("ToggledUnowned")

			p9:SetAttribute("ToggledUnowned", v225)

			for _, child in p9:GetChildren() do
				if child:IsA("GuiObject") and not child:GetAttribute("ShopTemplate") and child:GetAttribute("Purchased") then
					child.Visible = not v225
				end
			end

			p8.Icon.ImageTransparency = not v225 and 0 or 0.5
		end)
	end
}
local u34 = false
local u35 = nil

function t9.CreateConfirmationUI(t10: {[any]: any}, p10) -- line: 318
	-- upvalues: u34 (ref), t9 (copy), DataHandler (copy), ConfirmUI (copy), u35 (ref), t4 (copy), ShopSale (copy), TweenService (copy), Sounds (copy), Network (copy), t2 (copy), requireShopAsset (copy), t3 (copy), MarketplaceService (copy), LocalPlayer (copy)
	if u34 then
		return
	end

	t9:ClearConfirmationUI()

	local ok, result = pcall(require, p10)

	if not ok then
		warn(`[{ script }]: Failed to require asset logic: { p10 }.`)

		return
	end

	local v82 = DataHandler:Get()

	if not v82 then
		warn(`[{ script }]: PlayerData does not exist.`)

		return
	end

	u34 = true

	local v83 = t10.__currentlySelected:FindFirstAncestor("Skins") and t10.__currentlySelected.Parent or t10.__currentlySelected

	if not v83 then
		u34 = false

		return
	end

	local clone = ConfirmUI:Clone()

	u35 = clone
	clone.Size = UDim2.fromScale(0.6, 0.6)

	local Menu = t4.ShopMenu.Menu
	local FinalPrice = ShopSale.GetAssetPrice(v83, result, workspace:GetServerTimeNow()).FinalPrice

	local function updateConfirmText() -- line: 352
		-- upvalues: t9 (copy), FinalPrice (ref), clone (copy), result (copy)
		local v228 = t9:FormatPrice(FinalPrice)

		clone:FindFirstChild("Text").Text = `Are you sure you would like to purchase <b><font color="rgb(255,255,255)">{ tostring(result.DisplayName) }</font></b> for <b><font color="rgb(255,255,255)">{ v228 }</font></b>?`
	end

	local v88 = t9:FormatPrice(FinalPrice)

	clone:FindFirstChild("Text").Text = `Are you sure you would like to purchase <b><font color="rgb(255,255,255)">{ tostring(result.DisplayName) }</font></b> for <b><font color="rgb(255,255,255)">{ v88 }</font></b>?`
	clone.Parent = Menu.Holder
	clone.Visible = true
	clone.Position = UDim2.fromScale(0.5, 0.525)
	TweenService:Create(clone, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Position = UDim2.fromScale(0.5, 0.5)
	}):Play()
	clone.Purchase.MouseButton1Down:Connect(function() -- line: 369
		-- upvalues: Sounds (copy), clone (copy), u34 (ref), Network (copy), v83 (copy), FinalPrice (ref), t2 (copy), t9 (copy), t10 (copy), result (copy), requireShopAsset (copy), v82 (copy), t3 (copy), MarketplaceService (copy), LocalPlayer (copy)
		Sounds:Play("click")

		local Text = clone.Purchase:FindFirstChild("Text")

		if not Text then
			u34 = false

			return
		end

		Text.Text = "..."

		local v230 = Network:FireServerConnection("PurchaseContent", "REMOTE_FUNCTION", v83, FinalPrice)

		if t2[v230.Status] then
			if t2[v230.Status] == "Insufficient funds!" and math.random(1, 1000) == 1 then
				Text.Text = "Poor"
			else
				Text.Text = t2[v230.Status]
			end
		end

		if v230.Status == "success" then
			t9.OnPurchased:Fire(t10.__currentlySelected)
		elseif v230.Status == "priceChanged" then
			FinalPrice = v230.Price

			local v231 = t9:FormatPrice(FinalPrice)

			clone:FindFirstChild("Text").Text = `Are you sure you would like to purchase <b><font color="rgb(255,255,255)">{ tostring(result.DisplayName) }</font></b> for <b><font color="rgb(255,255,255)">{ v231 }</font></b>?`

		end

		task.wait(0.5)
		Text.Text = "BUY"
		u34 = false
	end)
	clone.Purchase.MouseEnter:Connect(function() -- line: 428
		-- upvalues: Sounds (copy)
		Sounds:Play("hover")
	end)
	clone.Purchase.MouseLeave:Connect(function() -- line: 432
		-- upvalues: Sounds (copy)
		Sounds:Play("hoverEnd")
	end)
	clone.Cancel.MouseButton1Down:Connect(function() -- line: 436
		-- upvalues: clone (copy), u34 (ref), Sounds (copy)
		clone:Destroy()
		u34 = false
		Sounds:Play("click")
	end)
	clone.Cancel.MouseEnter:Connect(function() -- line: 442
		-- upvalues: Sounds (copy)
		Sounds:Play("hover")
	end)
	clone.Purchase.MouseLeave:Connect(function() -- line: 446
		-- upvalues: Sounds (copy)
		Sounds:Play("hoverEnd")
	end)
	clone.AncestryChanged:Connect(function(_, parent) -- line: 450
		-- upvalues: u34 (ref), t9 (copy)
		if not parent then
			u34 = false
			t9:ClearConfirmationUI()
		end
	end)

	return clone
end
function t9.ClearConfirmationUI(_) -- line: 460
	-- upvalues: u35 (ref)
	if u35 ~= nil then
		u35:Destroy()
	end

	u35 = nil
end
function t9.CreateViewport(_: {[any]: any}, p13, b4: boolean, b5: boolean) -- line: 467
	-- upvalues: EmoteViewport (copy), Players (copy), ReplicatedStorage (copy), Util (copy), SoundService (copy), Sounds (copy), Trove (copy), RunService (copy), UserInputService (copy), TweenService (copy), Debris (copy)
	local clone = EmoteViewport:Clone()
	local Rig = clone.WorldModel.Rig
	local Humanoid = Rig:FindFirstChildOfClass("Humanoid")

	if not Humanoid or not Humanoid:FindFirstChildOfClass("Animator") then
		warn(`[Shop/{ script }]: No animator found for emote { p13.DisplayName }.`)

		return
	end

	local AssetID = p13.AssetID

	if typeof(AssetID) == "table" then
		if p13.isDuoAnim then
			AssetID = AssetID[1]
		elseif not AssetID.Start or not AssetID.Loop then
			local v98 = Players.LocalPlayer.Character and Players.LocalPlayer.Character.Name
			local v99 = v98 and ReplicatedStorage.Assets.Survivors:FindFirstChild(v98)
			local v100 = v99 and (v99:FindFirstChild("Config") and require(v99.Config).Class)

			AssetID = if not v100 or not p13.AssetID[v100] then if not p13.AssetID.Survivalist then AssetID[math.random(#AssetID)] else p13.AssetID.Survivalist else p13.AssetID[v100]
		else
			AssetID = AssetID.Loop
		end
	end

	local v101 = Util:LoadAnimationFromID(Rig, AssetID)

	if v101 then
		v101.Looped = true
		v101:Play(0)
		v101.Priority = Enum.AnimationPriority.Action
	end

	local t12 = {
		Player = Players.LocalPlayer,
		Character = clone.WorldModel.Rig,
		Emote = v101
	}

	if p13.CreatedServer then
		local ok, result = pcall(p13.CreatedServer, t12)

		if not ok then
			warn(`[Shop/{ script }]: Failed to run CreatedServer for emote { p13.DisplayName }: { result }`)
		end
	end

	if p13.CreatedClient then
		local ok, result = pcall(p13.CreatedClient, t12)

		if not ok then
			warn(`[Shop/{ script }]: Failed to run CreatedClient for emote { p13.DisplayName }: { result }`)
		end
	end

	local u107 = nil

	if b4 then
		local v108 = p13.SFXProperties or {}

		v108.SoundGroup = SoundService.Emotes

		local v109 = typeof(p13.SFX) == "table" and p13.SFX.Loop

		if v109 then
			v108.Looped = true
		end

		u107 = Sounds:Play(v109 or p13.SFX, v108)

		if u107 then
			u107.PlaybackRegionsEnabled = true
			u107:GetPropertyChangedSignal("TimeLength"):Connect(function() -- line: 536
				-- upvalues: u107 (ref)
				local v240 = u107.TimeLength or 0

				u107.LoopRegion = NumberRange.new(0, (math.clamp(v240 - 0.05, 0.1, 60000)))
			end)
			u107.LoopRegion = NumberRange.new(0, (math.clamp(u107.TimeLength - 0.05, 0.1, 60000)))
		end
	end

	local u110 = Trove.new()

	if b5 then
		local Camera = Instance.new("Camera")

		Camera.Parent = clone
		clone.CurrentCamera = Camera

		local Arrows = clone.WorldModel:FindFirstChild("Arrows")

		Arrows.Transparency = 0.5

		local n6 = -90
		local n7 = 0
		local u115 = false
		local vector2 = nil

		local function updateCamera() -- line: 569
			-- upvalues: Camera (copy), Rig (copy), n6 (ref)
			if not Camera or (not Rig or not Rig.PrimaryPart) then
				return
			end

			local Position = Rig:GetPivot().Position
			local v242 = math.rad(n6)
			local v243 = Vector3.new(math.sin(v242) * 0.9659258262890683, 0.25881904510252074, math.cos(v242) * 0.9659258262890683) * 6

			Camera.CFrame = CFrame.lookAt(Position + v243, Position)
		end

		updateCamera()

		local n8 = 0
		local n9 = 0
		local zero = Vector2.zero
		local zero2 = Vector2.zero

		u110:Connect(RunService.RenderStepped, function(n10: number) -- line: 594
			-- upvalues: n8 (ref), u115 (ref), n6 (ref), n7 (ref), Rig (copy), Camera (copy), n9 (ref), Arrows (copy), zero2 (ref), zero (ref), updateCamera (copy)
			n8 += n10
			n8 %= 6.283185307179586

			if not u115 then
				n6 += n7 * n10
				n7 *= math.exp(n10 * -3)

				if math.abs(n7) < 0.1 then
					n7 = 0
				end

				local v245 = Rig:GetPivot().Position + Vector3.new(0, -2.5, 0)
				local CFramePosition = Camera.CFrame.Position
				local vector3 = Vector3.new(CFramePosition.X, v245.Y, CFramePosition.Z)

				n9 += n10 * 0.5235987755982988
				n9 %= 360
				Arrows.CFrame = CFrame.lookAt(v245, vector3) * CFrame.Angles(0, n9, 0)
			end

			if u115 == true then
				local v248 = -(zero2.X * 0.3 * n10 * workspace.CurrentCamera.ViewportSize.X) * 0.6

				n6 += v248
				n7 = v248 * 60
			end

			local v249 = -(zero.X * 0.3 * n10 * workspace.CurrentCamera.ViewportSize.X) * 0.6

			n6 += v249
			n7 = v249 * 60

			local v250 = u115 or zero.Magnitude > 0.1

			if v250 and Arrows.Transparency ~= 1 then
				Arrows.Transparency = 1
			elseif not v250 and Arrows.Transparency ~= 0.5 then
				Arrows.Transparency = 0.5
			end

			updateCamera()
		end)

		local function __onMobilePCInput(p14, _: boolean) -- line: 642
			-- upvalues: clone (copy), u115 (ref), vector2 (ref), n7 (ref), zero2 (ref), zero (ref)
			if p14.Position.Z ~= 0 then
				return
			end

			local p14Position = p14.Position
			local AbsolutePosition = clone.AbsolutePosition
			local AbsoluteSize = clone.AbsoluteSize
			local v256 = p14Position.X >= AbsolutePosition.X and p14Position.X <= AbsolutePosition.X + AbsoluteSize.X
			local v257 = p14Position.Y >= AbsolutePosition.Y and p14Position.Y <= AbsolutePosition.Y + AbsoluteSize.Y

			if not v256 or not v257 then
				return
			end

			u115 = true
			vector2 = Vector2.new(p14Position.X, p14Position.Y)
			n7 = 0
			zero2 = Vector2.zero
			zero = Vector2.zero
		end

		u110:Connect(UserInputService.InputBegan, function(p15, b7: boolean) -- line: 663
			-- upvalues: Players (copy), __onMobilePCInput (copy)
			local v260 = false

			if p15.UserInputType == Enum.UserInputType.Gamepad1 then
				if p15.KeyCode == Enum.KeyCode.ButtonR2 then
					v260 = true
				elseif p15.KeyCode == Enum.KeyCode.ButtonA then
					local Mouse = Players.LocalPlayer:GetMouse()

					__onMobilePCInput({
						Position = Vector3.new(Mouse.X, Mouse.Y, 0)
					}, true)

					return
				end
			end

			if v260 or p15.UserInputType == Enum.UserInputType.MouseButton1 or p15.UserInputType == Enum.UserInputType.Touch then
				__onMobilePCInput(p15, b7)
			end
		end)

		local t13 = {
			Enum.UserInputType.MouseMovement,
			Enum.UserInputType.Touch,
			Enum.UserInputType.Gamepad1
		}

		u110:Connect(UserInputService.InputChanged, function(p16, _: boolean) -- line: 686
			-- upvalues: u115 (ref), vector2 (ref), t13 (copy), zero2 (ref), n6 (ref), n7 (ref)
			if not u115 or not vector2 then
				return
			end

			if table.find(t13, p16.UserInputType) == nil then
				return
			end

			local zero3 = Vector2.zero
			local _ = Vector2.zero

			if p16.UserInputType == Enum.UserInputType.Gamepad1 then
				if p16.KeyCode ~= Enum.KeyCode.Thumbstick1 and p16.KeyCode ~= Enum.KeyCode.Thumbstick2 then
					return
				end

				if p16.KeyCode == Enum.KeyCode.Thumbstick1 then
					zero2 = Vector2.new(p16.Position.X, p16.Position.Y)

					return
				end
			else
				zero3 = Vector2.new(p16.Position.X, p16.Position.Y)
			end

			local v266 = zero3 - vector2

			vector2 = zero3

			local v267 = -v266.X * 0.6

			n6 += v267
			n7 = v267 * 60
		end)
		u110:Connect(UserInputService.InputChanged, function(p17, _: boolean) -- line: 721
			-- upvalues: zero (ref)
			if p17.KeyCode == Enum.KeyCode.Thumbstick2 then
				local vector2_2 = Vector2.new(p17.Position.X, p17.Position.Y)

				if vector2_2.Magnitude <= 0.1 then
					vector2_2 = Vector2.zero
				end

				zero = vector2_2

				return
			end
		end)
		u110:Connect(UserInputService.InputEnded, function(p18) -- line: 733
			-- upvalues: u115 (ref), vector2 (ref), zero2 (ref), zero (ref)
			if (p18.UserInputType ~= Enum.UserInputType.Gamepad1 or p18.KeyCode ~= Enum.KeyCode.ButtonR2 and p18.KeyCode ~= Enum.KeyCode.ButtonA) and (p18.UserInputType ~= Enum.UserInputType.MouseButton1 and p18.UserInputType ~= Enum.UserInputType.Touch) then
				return
			end

			u115 = false
			vector2 = nil
			zero2 = Vector2.zero
			zero = Vector2.zero
		end)
	end

	clone.AncestryChanged:Connect(function(_, parent) -- line: 750
		-- upvalues: u110 (ref), p13 (copy), t12 (copy), u107 (ref), TweenService (copy), Debris (copy)
		if parent then
			return
		end

		if u110 then
			u110:Clean()
			u110 = nil
		end

		if p13.DestroyedServer then
			local ok, result = pcall(p13.DestroyedServer, t12)

			if not ok then
				warn(`[Shop/{ script }]: Failed to run DestroyedServer for emote { p13.DisplayName }: { result }`)
			end
		end

		if p13.DestroyedClient then
			local ok, result = pcall(p13.DestroyedClient, t12)

			if not ok then
				warn(`[Shop/{ script }]: Failed to run DestroyedClient for emote { p13.DisplayName }: { result }`)
			end
		end

		if not u107 then
			return
		end

		TweenService:Create(u107, TweenInfo.new(0.1), {
			Volume = 0
		}):Play()
		Debris:AddItem(u107, 0.1)
	end)

	return clone
end
function t9.CreateSkinViewport(_: {[any]: any}, p20, b10: boolean) -- line: 792
	-- upvalues: RigBuilder (copy), Trove (copy), RunService (copy), UserInputService (copy), Players (copy)
	assert(typeof(p20) == "Instance", "ShopUtils:CreateSkinViewport() requires a skin folder.")

	local v127 = RigBuilder.ResolveSkin(p20)

	if not v127 or not v127.ActorFolder then
		warn(`[{ script }]: Could not resolve actor for { p20:GetFullName() }`)

		return
	end

	local v128 = RigBuilder.GetMergedConfig(v127)
	local v129 = RigBuilder.GetMergedBehavior(v127)
	local v130, v131 = RigBuilder.GetRig(v127, v128, v129)

	if not v130 then
		warn(`[{ script }]: No rig found for { p20:GetFullName() }`)

		return
	end

	RigBuilder.SanitizeRig(v130)
	RigBuilder.ApplyExpression(v130, v128)

	if v131 then
		RigBuilder.ApplyLifeAppearance(v130, v131)
	end

	if v127.ActorName == "Veeronica" then
		v130.Skateboard.Transparency = 1
		v130.Spray.Transparency = 1
	end

	local ViewportFrame = Instance.new("ViewportFrame")

	ViewportFrame.BackgroundTransparency = 1
	ViewportFrame.ImageTransparency = 0
	ViewportFrame.Ambient = Color3.fromRGB(200, 200, 200)
	ViewportFrame.LightColor = Color3.fromRGB(140, 140, 140)
	ViewportFrame.LightDirection = Vector3.new(-1, -1, -1)

	local WorldModel = Instance.new("WorldModel")

	WorldModel.WorldPivot = CFrame.new(0, 2.5, 0) * CFrame.Angles(0, 0.8726646259971648, 0)
	WorldModel.Parent = ViewportFrame
	v130:PivotTo(CFrame.new(-1.5, 3, 0) * CFrame.Angles(0, 1.1344640137963142, 0))
	v130.Parent = WorldModel

	local Camera = Instance.new("Camera")

	Camera.FieldOfView = 35
	Camera.Parent = ViewportFrame
	ViewportFrame.CurrentCamera = Camera

	local v135, v136 = RigBuilder.GetVisibleBoundingBox(v130)
	local v137 = math.max(math.max(v136.X, v136.Y, v136.Z) * 1.75, 6)
	local v138 = v135.Position + Vector3.new(0, v136.Y * 0.05, 0)
	local vector3 = Vector3.new(0, v136.Y * 0.12, v137)

	Camera.CFrame = CFrame.lookAt(v138 + vector3, v138)

	local v140 = Trove.new()

	if b10 then
		local Camera2 = Instance.new("Camera")

		Camera2.Parent = ViewportFrame
		ViewportFrame.CurrentCamera = Camera2

		local n11 = -90
		local n12 = 0
		local u144 = false
		local vector2 = nil

		local function updateCamera() -- line: 869
			-- upvalues: Camera2 (copy), v130 (copy), n11 (ref)
			if not Camera2 or (not v130 or not v130.PrimaryPart) then
				return
			end

			local Position = v130:GetPivot().Position
			local v279 = math.rad(n11)
			local v280 = Vector3.new(math.sin(v279) * 0.9659258262890683, 0.25881904510252074, math.cos(v279) * 0.9659258262890683) * 6

			Camera2.CFrame = CFrame.lookAt(Position + v280, Position)
		end

		updateCamera()

		local n13 = 0
		local zero = Vector2.zero
		local zero4 = Vector2.zero

		v140:Connect(RunService.RenderStepped, function(n14: number) -- line: 894
			-- upvalues: n13 (ref), u144 (ref), zero4 (ref), n11 (ref), n12 (ref), zero (ref), updateCamera (copy)
			n13 += n14
			n13 %= 6.283185307179586

			if u144 == true then
				local v282 = -(zero4.X * 0.3 * n14 * workspace.CurrentCamera.ViewportSize.X) * 0.6

				n11 += v282
				n12 = v282 * 60
			end

			local v283 = -(zero.X * 0.3 * n14 * workspace.CurrentCamera.ViewportSize.X) * 0.6

			n11 += v283
			n12 = v283 * 60
			updateCamera()
		end)

		local function __onMobilePCInput(p21, _: boolean) -- line: 917
			-- upvalues: ViewportFrame (copy), u144 (ref), vector2 (ref), n12 (ref), zero4 (ref), zero (ref)
			if p21.Position.Z ~= 0 then
				return
			end

			local p21Position = p21.Position
			local AbsolutePosition = ViewportFrame.AbsolutePosition
			local AbsoluteSize = ViewportFrame.AbsoluteSize
			local v289 = p21Position.X >= AbsolutePosition.X and p21Position.X <= AbsolutePosition.X + AbsoluteSize.X
			local v290 = p21Position.Y >= AbsolutePosition.Y and p21Position.Y <= AbsolutePosition.Y + AbsoluteSize.Y

			if not v289 or not v290 then
				return
			end

			u144 = true
			vector2 = Vector2.new(p21Position.X, p21Position.Y)
			n12 = 0
			zero4 = Vector2.zero
			zero = Vector2.zero
		end

		v140:Connect(UserInputService.InputBegan, function(p22, b12: boolean) -- line: 938
			-- upvalues: Players (copy), __onMobilePCInput (copy)
			local v293 = false

			if p22.UserInputType == Enum.UserInputType.Gamepad1 then
				if p22.KeyCode == Enum.KeyCode.ButtonR2 then
					v293 = true
				elseif p22.KeyCode == Enum.KeyCode.ButtonA then
					local Mouse = Players.LocalPlayer:GetMouse()

					__onMobilePCInput({
						Position = Vector3.new(Mouse.X, Mouse.Y, 0)
					}, true)

					return
				end
			end

			if v293 or p22.UserInputType == Enum.UserInputType.MouseButton1 or p22.UserInputType == Enum.UserInputType.Touch then
				__onMobilePCInput(p22, b12)
			end
		end)

		local t15 = {
			Enum.UserInputType.MouseMovement,
			Enum.UserInputType.Touch,
			Enum.UserInputType.Gamepad1
		}

		v140:Connect(UserInputService.InputChanged, function(p23, _: boolean) -- line: 961
			-- upvalues: u144 (ref), vector2 (ref), t15 (copy), zero4 (ref), n11 (ref), n12 (ref)
			if not u144 or not vector2 then
				return
			end

			if table.find(t15, p23.UserInputType) == nil then
				return
			end

			local zero5 = Vector2.zero
			local _ = Vector2.zero

			if p23.UserInputType == Enum.UserInputType.Gamepad1 then
				if p23.KeyCode ~= Enum.KeyCode.Thumbstick1 and p23.KeyCode ~= Enum.KeyCode.Thumbstick2 then
					return
				end

				if p23.KeyCode == Enum.KeyCode.Thumbstick1 then
					zero4 = Vector2.new(p23.Position.X, p23.Position.Y)

					return
				end
			else
				zero5 = Vector2.new(p23.Position.X, p23.Position.Y)
			end

			local v299 = zero5 - vector2

			vector2 = zero5

			local v300 = -v299.X * 0.6

			n11 += v300
			n12 = v300 * 60
		end)
		v140:Connect(UserInputService.InputChanged, function(p24, _: boolean) -- line: 996
			-- upvalues: zero (ref)
			if p24.KeyCode == Enum.KeyCode.Thumbstick2 then
				local vector2_3 = Vector2.new(p24.Position.X, p24.Position.Y)

				if vector2_3.Magnitude <= 0.1 then
					vector2_3 = Vector2.zero
				end

				zero = vector2_3

				return
			end
		end)
		v140:Connect(UserInputService.InputEnded, function(p25) -- line: 1008
			-- upvalues: u144 (ref), vector2 (ref), zero4 (ref), zero (ref)
			if (p25.UserInputType ~= Enum.UserInputType.Gamepad1 or p25.KeyCode ~= Enum.KeyCode.ButtonR2 and p25.KeyCode ~= Enum.KeyCode.ButtonA) and (p25.UserInputType ~= Enum.UserInputType.MouseButton1 and p25.UserInputType ~= Enum.UserInputType.Touch) then
				return
			end

			u144 = false
			vector2 = nil
			zero4 = Vector2.zero
			zero = Vector2.zero
		end)
	end

	local connection = nil

	connection = ViewportFrame.AncestryChanged:Connect(function(_, parent) -- line: 1026
		-- upvalues: ViewportFrame (copy), connection (ref), RigBuilder (copy), v130 (copy), v128 (copy)
		if parent and ViewportFrame:IsDescendantOf(game) then
			connection:Disconnect()
			RigBuilder.PlayIdleAnimation(v130, v128)
		end
	end)
	ViewportFrame.Destroying:Connect(function() -- line: 1033
		-- upvalues: v140 (copy), connection (ref)
		v140:Clean()

		if connection.Connected then
			connection:Disconnect()
		end
	end)

	return ViewportFrame
end
function t9.CloseOverlay(p27) -- line: 1043
	-- upvalues: t4 (copy), Device (copy), TweenService (copy), t9 (copy)
	assert(t4.ShopMenu, "ShopUtils:CloseOverlay() Shop menu does not exist, did you forget to setup the Shop module?")

	local Menu = t4.ShopMenu.Menu

	assert(Menu, "ShopUtils:OpenOverlay() Shop menu does not exist, did you forget to setup the Shop module?")

	local Overlay = Menu.Holder.Overlay
	local ViewportFrame = Overlay.Preview.BG:FindFirstChildOfClass("ViewportFrame")

	if ViewportFrame then
		ViewportFrame:Destroy()
	end

	p27.__overlaySelection = nil

	if Device:GetPlayerDevice() == "Mobile" then
		TweenService:Create(Menu.Holder, TweenInfo.new(0.5), {
			Position = UDim2.new(0.5, 0, 0.5, 0)
		}):Play()
	end

	t9:ClearConfirmationUI()
	Overlay.Visible = false
	p27.__isOverlayOpen = false
end
function t9.SetupOverlay(t16: {[any]: any}, p28, b15: boolean) -- line: 1066
	-- upvalues: t4 (copy), requireShopAsset (copy), Device (copy), TweenService (copy), t9 (copy)
	assert(typeof(p28) == "Instance" and (p28:IsA("ModuleScript") or p28:IsA("Folder")), "ShopUtils:OpenOverlay() requires assetLogic.")

	local u160 = p28:IsA("Folder") and p28:FindFirstChild("Config") or p28
	local Menu = t4.ShopMenu.Menu

	assert(Menu, "ShopUtils:OpenOverlay() Shop menu does not exist, did you forget to setup the Shop module?")

	local v162, v163 = requireShopAsset(u160)

	if not v162 then
		warn(`ShopUtils:OpenOverlay() Failed to require assetLogic: { u160 }. { v163 }`)

		return
	end

	if Device:GetPlayerDevice() == "Mobile" then
		TweenService:Create(Menu.Holder, TweenInfo.new(0.5), {
			Position = UDim2.new(0.45, 0, 0.5, 0)
		}):Play()
	end

	local Overlay = Menu.Holder.Overlay

	Overlay.Preview.Description.Text = v163.Description or "No description provided."
	Overlay.Preview.Credit.Text = v163.Credits or ""
	Overlay.Preview:FindFirstChild("Name").Text = v163.DisplayName or "No name provided."
	t16:ApplyPrice(Overlay.Preview, u160, v163)
	t9:ClearConfirmationUI()

	local ViewportFrame = Overlay.Preview.BG:FindFirstChildOfClass("ViewportFrame")

	if ViewportFrame then
		ViewportFrame:Destroy()
	end

	t16.__overlaySelection = nil

	if b15 then
		local v166 = t16:CreateViewport(v163, true, true)

		if not v166 then
			warn(`[{ script }]: Failed to create viewport for emote { v163.DisplayName }.`)

			return
		end

		Overlay.Preview.BG.Render.Visible = false
		v166.AnchorPoint = Vector2.new(0.5, 0.5)
		v166.Size = UDim2.fromScale(1, 0.965)
		v166.Position = UDim2.fromScale(0.485, 0.5)
		v166.Parent = Overlay.Preview.BG
	else
		Overlay.Preview.BG.Render.Visible = true
		Overlay.Preview.BG.Render.Image = v163.RenderImage or ""

		local t17 = {}

		t16.__overlaySelection = t17
		task.spawn(function() -- line: 1115
			-- upvalues: t16 (copy), u160 (ref), t17 (copy), Overlay (copy)
			local v307 = t16:CreateSkinViewport(u160, true)

			if not v307 then
				return
			end

			if t16.__overlaySelection ~= t17 then
				v307:Destroy()

				return
			end

			Overlay.Preview.BG.Render.Visible = false
			v307.AnchorPoint = Vector2.new(0.5, 0.5)
			v307.Size = UDim2.fromScale(1, 0.965)
			v307.Position = UDim2.fromScale(0.485, 0.5)
			v307.Parent = Overlay.Preview.BG
		end)
	end

	t16.__currentlySelected = u160
end

t9.__purchaseSignal = Signal.new()
t9.OnPurchased = t9.__purchaseSignal

function t9.OpenOverlay(t18: {[any]: any}, p29, b16: boolean) -- line: 1141
	-- upvalues: t4 (copy), TweenService (copy), Trove (copy), Sounds (copy), t9 (copy)
	if t18.__isOverlayOpen then
		t18:SetupOverlay(p29, b16)

		return
	end

	assert(typeof(p29) == "Instance" and (p29:IsA("ModuleScript") or p29:IsA("Folder")), "ShopUtils:OpenOverlay() requires assetLogic.")

	local Menu = t4.ShopMenu.Menu

	assert(Menu, "ShopUtils:OpenOverlay() Shop menu does not exist, did you forget to setup the Shop module?")
	t18.__isOverlayOpen = true

	local Overlay = Menu.Holder.Overlay

	Overlay.Position = UDim2.fromScale(1.2, 0.55)
	t18:SetupOverlay(p29, b16)
	Overlay.Visible = true
	TweenService:Create(Overlay, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Position = UDim2.fromScale(1.2, 0.5)
	}):Play()

	if t18.__buyTrove then
		t18.__buyTrove:Destroy()
	end

	t18.__buyTrove = Trove.new()
	t18.__buyTrove:Connect(Overlay.Preview.Buy.MouseEnter, function() -- line: 1173
		-- upvalues: TweenService (copy), Overlay (copy), Sounds (copy)
		TweenService:Create(Overlay.Preview.Buy, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.fromScale(0.625, 0.2)
		}):Play()
		Sounds:Play("hover")
	end)
	t18.__buyTrove:Connect(Overlay.Preview.Buy.MouseLeave, function() -- line: 1184
		-- upvalues: TweenService (copy), Overlay (copy), Sounds (copy)
		TweenService:Create(Overlay.Preview.Buy, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.fromScale(0.579, 0.083)
		}):Play()
		Sounds:Play("hoverEnd")
	end)
	t18.__buyTrove:Connect(Overlay.Preview.Buy.MouseButton1Down, function() -- line: 1195
		-- upvalues: Sounds (copy), t9 (copy), t18 (copy)
		Sounds:Play("click")
		t9:CreateConfirmationUI(t18.__currentlySelected)
	end)
end

local self = setmetatable({}, {
	__mode = "k"
})
local u37 = nil

local function scheduleSaleRefresh() -- line: 1205
	-- upvalues: u37 (ref), ShopSale (copy), self (copy), t9 (copy), scheduleSaleRefresh (copy)
	if u37 then
		return
	end

	local ServerTimeNow = workspace:GetServerTimeNow()
	local v174 = ShopSale.GetNextChangeTime(ServerTimeNow)

	if not v174 then
		return
	end

	u37 = task.delay(v174 - ServerTimeNow + 0.1, function() -- line: 1216
		-- upvalues: u37 (ref), self (copy), t9 (copy), scheduleSaleRefresh (copy)
		u37 = nil

		for v308, v309 in self do
			if v308.Parent then
				t9:ApplyPrice(v308, v309.asset, v309.config)
			else
				self[v308] = nil
			end
		end

		scheduleSaleRefresh()
	end)
end

function t9.ApplyPrice(t19: {[any]: any}, p30, p31, p32) -- line: 1231
	-- upvalues: ShopSale (copy), self (copy), scheduleSaleRefresh (copy)
	if p31:IsA("ModuleScript") and (p31.Name == "Config" and p31.Parent) then
		p31 = p31.Parent
	end

	local v179 = ShopSale.GetAssetPrice(p31, p32, workspace:GetServerTimeNow())
	local IsDiscounted = v179.IsDiscounted
	local Price = p30:FindFirstChild("Price")

	if Price then
		Price.Text = t19:FormatPrice(v179.FinalPrice)

		local DiscountGradient = Price:FindFirstChild("DiscountGradient")

		if DiscountGradient then
			DiscountGradient.Enabled = IsDiscounted
		end
	end

	local OldPrice = p30:FindFirstChild("OldPrice")

	if OldPrice then
		OldPrice.Visible = IsDiscounted
		OldPrice.Text = IsDiscounted and t19:FormatPrice(v179.OriginalPrice) or ""
	end

	local DiscountTag = p30:FindFirstChild("DiscountTag")

	if DiscountTag then
		DiscountTag.Visible = IsDiscounted
	end

	self[p30] = {
		asset = p31,
		config = p32
	}
	scheduleSaleRefresh()
end

local u39 = nil
local u40 = nil

function t4.OnTransitionState(b17: boolean) -- line: 1266
	-- upvalues: t4 (copy), u40 (ref), u39 (ref), Lighting (copy), Util (copy), LocalPlayer (copy), TweenService (copy), Debris (copy)
	local ShopMenu = t4.ShopMenu

	if b17 then
		if u40 then
			u40:Destroy()
			u40 = nil
		end

		if u39 then
			u39:Destroy()
			u39 = nil
		end

		ShopMenu.Menu.Position = UDim2.fromScale(0.5, 0.55)
		ShopMenu.Menu.Size = UDim2.fromScale(1, 1)
		ShopMenu.Menu.Visible = true

		local BlurEffect = Instance.new("BlurEffect")

		BlurEffect.Name = "ShopBlur"
		BlurEffect.Size = 0
		BlurEffect.Parent = Lighting
		u40 = BlurEffect
		u39 = Util:CreateFOVMultiplier(LocalPlayer, 1, "ShopZoom")
		TweenService:Create(BlurEffect, TweenInfo.new(0.225, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = 12
		}):Play()
		TweenService:Create(u39, TweenInfo.new(0.225, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Value = 0.85
		}):Play()
		TweenService:Create(ShopMenu.Menu, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Position = UDim2.fromScale(0.5, 0.5)
		}):Play()
	else
		ShopMenu.Menu.Visible = false

		local v188 = u39
		local v189 = u40

		if u39 then
			TweenService:Create(u39, TweenInfo.new(0.225, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Value = 1
			}):Play()
		end

		if v189 then
			TweenService:Create(v189, TweenInfo.new(0.225, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Size = 0
			}):Play()
		end

		if v189 then
			Debris:AddItem(v189, 0.225)
		end

		if v188 then
			Debris:AddItem(v188, 0.225)
		end
	end

	local v190 = `OnWindow{ not b17 and "Closed" or "Opened" }`
	local v191 = t4.TabLogic[t4.LastTab or ""]

	if v191 and v191[v190] then
		local ok, result = pcall(v191[v190], v191)

		if not ok then
			warn(`[{ script }]: Failed to run { v190 }() for tab: { t4.LastTab }, got: { result }`)
		end
	end
end
function t4.SwitchTab(_: {[any]: any}, s1: string) -- line: 1351
 if s1=="Robux"or s1=="Featured"then s1="Skins"end
	-- upvalues: t4 (copy), t1 (copy), transitionHighlightToState (copy), transitionToFrame (copy)
	if s1 == t4.LastTab then
		return
	end

	local Menu = t4.ShopMenu.Menu
	local TabButtons = Menu.Holder.TabButtons
	local v198 = t4.LastTab and TabButtons:FindFirstChild(t4.LastTab)
	local s1_2 = TabButtons:FindFirstChild(s1)

	if not s1_2 then
		warn(`[{ script }]: No tab found for: { s1 }`)

		return
	end

	if v198 then
		if t1[v198] then
			return
		end

		transitionHighlightToState(v198, false)
	end

	local s1_3 = Menu.Holder.Page:FindFirstChild(s1)
	local v201 = t4.LastTab and Menu.Holder.Page:FindFirstChild(t4.LastTab)
	local v202 = (v198 and v198.LayoutOrder or 0) > s1_2.LayoutOrder

	transitionToFrame(v201, s1_3, v202)
	transitionHighlightToState(s1_2, true)

	local v203 = t4.TabLogic[t4.LastTab]

	if v203 and v203.OnTabSwitched then
		local ok, result = pcall(v203.OnTabSwitched, v203)

		if not ok then
			warn(`[{ script }]: Failed to run OnTabSwitched() for tab: { t4.LastTab }, got: { result }`)
		end
	end

	local v206 = t4.TabLogic[s1]

	if v206 and v206.OnTabOpened then
		local ok, result = pcall(v206.OnTabOpened, v206)

		if not ok then
			warn(`[{ script }]: Failed to run OnTabOpened() for tab: { t4.LastTab }, got: { result }`)
		end
	end

	t4.LastTab = s1
end

local u41 = false

function t4.Start(_) -- line: 1401
	-- upvalues: u41 (ref), t4 (copy), CurrencyDisplay (copy), TweenService (copy), Sounds (copy), NotFound (copy), t9 (copy), setupViewportRig (copy)
	if u41 then
		return
	end

	u41 = true

	local EventHandlerClient = require(game.ReplicatedStorage.Modules.EventHandlerClient)

	if not EventHandlerClient:GetInfo() then
		EventHandlerClient.onEventInfoGiven:Wait()
		EventHandlerClient:GetInfo()
	end

	t4.ShopMenu = require(game.ReplicatedStorage.Initializer).PlayerSystems.SidebarHandler:CreateSidebarMenu("Shop", script.Shop)
	t4.Tabs = {}
	t4.TabLogic = {}

	local Menu = t4.ShopMenu.Menu

	os.clock()
	CurrencyDisplay.new("Money", "rbxassetid://132413181315189", false).Instance.Parent = Menu.Holder.Currency

	local Close = Menu.Holder.Close

	Close.MouseEnter:Connect(function() -- line: 1438
		-- upvalues: TweenService (copy), Close (copy), Sounds (copy)
		TweenService:Create(Close, TweenInfo.new(0.25), {
			Size = UDim2.fromScale(0.105, 0.105)
		}):Play()
		Sounds:Play("hover")
	end)
	Close.MouseLeave:Connect(function() -- line: 1450
		-- upvalues: TweenService (copy), Close (copy), Sounds (copy)
		TweenService:Create(Close, TweenInfo.new(0.25), {
			Size = UDim2.fromScale(0.071, 0.092)
		}):Play()
		Sounds:Play("hoverEnd")
	end)
	Close.MouseButton1Down:Connect(function() -- line: 1462
		-- upvalues: t4 (copy), Sounds (copy)
		t4.ShopMenu:ToggleMenu(false)
		Sounds:Play("click")
	end)
	Menu.Holder.Page:ClearAllChildren()

	local function isTabRejected(b18: boolean, s2: string, p34, s3: string?) -- line: 1470
		-- upvalues: NotFound (copy), Menu (copy), t4 (copy)
		if b18 then
			return nil
		end

		warn(`[{ script }]: Tab '{ s2 }' rejected during '{ s3 or "unknown" }' stage.`)

		if p34 then
			warn(`[{ script }]: Response: { p34 }`)
		end

		local clone = NotFound:Clone()

		clone.Name = s2
		clone.Parent = Menu.Holder.Page
		clone.Position = UDim2.fromScale(1, 0)
		t4.Tabs[s2] = clone

		return clone
	end

	for _, child in Menu.Holder.TabButtons:GetChildren() do
		if child:IsA("TextButton") then
            child.Size=UDim2.fromScale(0.475,0.732)
			child.MouseEnter:Connect(function() -- line: 1496
				-- upvalues: TweenService (copy), child (copy), Sounds (copy)
				TweenService:Create(child, TweenInfo.new(0.25), {
					Size = UDim2.fromScale(0.5, 0.75)
				}):Play()
				Sounds:Play("hover")
			end)
			child.MouseLeave:Connect(function() -- line: 1508
				-- upvalues: TweenService (copy), child (copy), Sounds (copy)
				TweenService:Create(child, TweenInfo.new(0.25), {
					Size = UDim2.fromScale(0.475, 0.732)
				}):Play()
				Sounds:Play("hoverEnd")
			end)
			child.MouseButton1Down:Connect(function() -- line: 1520
				-- upvalues: t4 (copy), child (copy), Sounds (copy)
				t4:SwitchTab(child.Name)
				Sounds:Play("click")
			end)

			local childName = child.Name
			local childName2 = script.Tabs:FindFirstChild(childName)

			if not isTabRejected(childName2 ~= nil, childName, "no ModuleScript found", "lookup") then
				local ok, result = xpcall(function() -- line: 1531
					-- upvalues: childName2 (copy)
					return require(childName2)
				end, debug.traceback)

				if not isTabRejected(ok, childName, result, "require") then
					local ok3, result3 = xpcall(function() -- line: 1536
						-- upvalues: result (copy), t9 (copy)
						return result.new(t9)
					end, debug.traceback)

					if not isTabRejected(ok3, childName, result3, "new()") then
						result3.Name = childName
						result3.Parent = Menu.Holder.Page
						result3.Position = UDim2.fromScale(1, 0)
						t4.TabLogic[childName] = result
						t4.Tabs[childName] = result3
					end
				end
			end
		end
	end

	setupViewportRig()
	t9.OnPurchased:Connect(function() -- line: 1551
		-- upvalues: t9 (copy)
		t9:ClearConfirmationUI()
	end)
	t4:SwitchTab("Skins")
end

return t4
]========])
assert(game.ReplicatedStorage.Systems.Player.UI.Menus.UpdateLog.Source==[========[
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local _ = LocalPlayer.PlayerGui
local DataHandler = require(ReplicatedStorage.Modules.DataHandler)
local Network = require(ReplicatedStorage.Modules.Network)
local Sounds = require(ReplicatedStorage.Modules.Sounds)
local Util = require(ReplicatedStorage.Modules.Util)
local DiscordMarkdown = require(script.DiscordMarkdown)
local UpdatelogPresets = ReplicatedStorage.Assets.UI.UpdatelogPresets
local Changelogs = ReplicatedStorage.Assets.Changelogs
local __createComponent = nil
local t4 = {
	TextTemplate = function(t1: {[any]: any}, p1) -- line: 26
		p1.Text = t1.Content
	end,
	ImageTemplate = function(t2: {[any]: any}, p2) -- line: 30
		p2.Image = t2.Content
		p2.Subtitle.Text = t2.Text
	end,
	ItemsTemplate = function(t3: {[any]: any}, p3) -- line: 35
		-- upvalues: __createComponent (ref)
		for i, v in ipairs(t3.Content) do
			local v35 = __createComponent(v, p3)

			if v35 then
				v35.LayoutOrder = i
				v35.Parent = p3
			end
		end
	end
}
local LatestLog = Changelogs:GetAttribute("LatestLog")
local TextTitle = nil
local t5 = {}

local function __toYYMMDD(p4) -- line: 53
	local v37, v38, v39 = p4:match("(%d+)-(%d+)-(%d+)")

	return string.format("%02d%02d%02d", tonumber(v39), tonumber(v37), (tonumber(v38)))
end
local function __generateLegacyLayout(t6: {[any]: any}, p5) -- line: 58
	-- upvalues: UpdatelogPresets (copy)
	local n1 = 0

	for i = 1, #t6.Notes do
		local v44 = t6.Notes[i]
		local clone = UpdatelogPresets.Components.Header:Clone()

		clone.Text = v44.Header
		clone.LayoutOrder = n1
		clone.Parent = p5

		local clone2 = UpdatelogPresets.Components.Seperator:Clone()

		clone2.LayoutOrder = n1 + 1
		clone2.Parent = p5

		local clone3 = UpdatelogPresets.Components.TextPreset:Clone()

		clone3.Main.Text = v44.Body
		clone3.Size = v44.NoteSize or UDim2.fromScale(0.9, 0.25)
		clone3.LayoutOrder = n1 + 2
		clone3.Parent = p5
		n1 += 3
	end
end

function __createComponent(t7: {[any]: any}, p6) -- line: 82
	-- upvalues: t4 (copy)
	local t7Type = script.Presets.Components:FindFirstChild(t7.Type)

	if not t7Type then
		warn(`[{ script }]: Invalid component type: { t7.Type }`)

		return nil
	end

	local clone = t7Type:Clone()
	local v52 = t4[t7.Type]

	if v52 then
		local ok, result = pcall(v52, t7, clone)

		if not ok then
			warn(`[{ script }]: Failed to run callback for component: { t7.Type }, { debug.traceback(result) }`)
		end
	end

	for k, v in next, t7.Style or {} do
		clone[k] = v
	end

	clone.Parent = p6

	return clone
end

local function __generateLayout(t8: {[any]: any}, p7) -- line: 107
	-- upvalues: __createComponent (ref)
	local clone = script.Presets.UpdateDisplayTemplate:Clone()
	local n2 = 0

	local function __increment() -- line: 111
		-- upvalues: n2 (ref)
		n2 += 1
	end

	for _, v in ipairs(t8) do
		local clone4 = script.Presets.Components.SubheaderTemplate:Clone()

		clone4.Header.Text = v.Header
		clone4.LayoutOrder = n2
		clone4.Parent = clone
		n2 += 1

		for _, v2 in ipairs(v.Content) do
			local v67 = __createComponent(v2, clone)

			if v67 then
				v67.LayoutOrder = n2
				n2 += 1
			end
		end
	end

	clone.Parent = p7
end
local function __switchPage(p8, t9: {[any]: any}) -- line: 139
	-- upvalues: DiscordMarkdown (copy), __generateLegacyLayout (copy), __generateLayout (copy)
	assert(typeof(t9) == "table", "meta is not a table!")
 if not t9.Markdown and t9.Notes and t9.Notes[1]and t9.Notes[1].Body then t9.IsLegacy=true end

	for _, v in next, p8.Holder.List:GetChildren() do
		if v:IsA("Frame") or v:IsA("TextLabel") then
			v:Destroy()
		end
	end

	local clone = script.Presets.Loading:Clone()

	clone.Parent = p8.Holder

	local clone5 = script.Presets.Components.HeaderTemplate:Clone()

	clone5.Background.Image = t9.TitleMeta.Image.Backdrop or t9.TitleMeta.Image.Large or t9.TitleMeta.Image.Title or ""
	clone5.Header.Text = t9.TitleMeta.Text.Title or "N/A"
	clone5.Description.Text = t9.TitleMeta.Text.Description or (t9.TitleMeta.Text.Date or "None Provided")
	clone5.LayoutOrder = -10
	clone5.Parent = p8.Holder.List

	if t9.Markdown then
		DiscordMarkdown.Render(t9.Markdown, p8.Holder.List)
	elseif t9.IsLegacy then
		__generateLegacyLayout(t9, p8.Holder.List)
	else
		__generateLayout(t9.Notes, p8.Holder.List)
	end

	clone:Destroy()
end

local t10 = {
	Menu = nil
}
local u25 = nil
local u26 = nil

function t10.OnTransitionState(b1: boolean) -- line: 175
	-- upvalues: t10 (copy), u26 (ref), u25 (ref), Lighting (copy), Util (copy), LocalPlayer (copy), TweenService (copy), Debris (copy)
	local Menu = t10.UpdateLogMenu.Menu

	if b1 then
		if u26 then
			u26:Destroy()
			u26 = nil
		end

		if u25 then
			u25:Destroy()
			u25 = nil
		end

		Menu.Position = UDim2.fromScale(0.5, 0.55)
		Menu.Size = UDim2.fromScale(1, 1.15)
		Menu.Visible = true

		local BlurEffect = Instance.new("BlurEffect")

		BlurEffect.Name = "ShopBlur"
		BlurEffect.Size = 0
		BlurEffect.Parent = Lighting
		u26 = BlurEffect
		u25 = Util:CreateFOVMultiplier(LocalPlayer, 1, "ShopZoom")
		TweenService:Create(BlurEffect, TweenInfo.new(0.225, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = 12
		}):Play()
		TweenService:Create(u25, TweenInfo.new(0.225, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Value = 0.85
		}):Play()
		TweenService:Create(Menu, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Position = UDim2.fromScale(0.5, 0.5)
		}):Play()

		return
	end

	Menu.Visible = false

	local v77 = u25
	local v78 = u26

	if u25 then
		TweenService:Create(u25, TweenInfo.new(0.225, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Value = 1
		}):Play()
	end

	if v78 then
		TweenService:Create(v78, TweenInfo.new(0.225, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = 0
		}):Play()
	end

	if v78 then
		Debris:AddItem(v78, 0.225)
	end

	if v77 then
		Debris:AddItem(v77, 0.225)
	end
end
function t10.Start(_) -- line: 251
	-- upvalues: ReplicatedStorage (copy), t10 (copy), DataHandler (copy), LatestLog (copy), TweenService (copy), Sounds (copy), Network (copy), Changelogs (copy), TextTitle (ref), __switchPage (copy), t5 (copy)
	task.spawn(function() -- line: 252
		-- upvalues: ReplicatedStorage (copy), t10 (copy), DataHandler (copy), LatestLog (copy), TweenService (copy), Sounds (copy), Network (copy), Changelogs (copy), TextTitle (ref), __switchPage (copy), t5 (copy)
		t10.UpdateLogMenu = require(ReplicatedStorage.Initializer).PlayerSystems.SidebarHandler:CreateSidebarMenu("UpdateLog", script.UpdateScreen)


		local Menu = t10.UpdateLogMenu.Menu
		local Close = Menu.Holder.Close

		Close.MouseEnter:Connect(function() -- line: 264
			-- upvalues: TweenService (copy), Close (copy), Sounds (copy)
			TweenService:Create(Close, TweenInfo.new(0.25), {
				Size = UDim2.fromScale(0.105, 0.105)
			}):Play()
			Sounds:Play("hover")
		end)
		Close.MouseLeave:Connect(function() -- line: 276
			-- upvalues: TweenService (copy), Close (copy), Sounds (copy)
			TweenService:Create(Close, TweenInfo.new(0.25), {
				Size = UDim2.fromScale(0.074, 0.095)
			}):Play()
			Sounds:Play("hoverEnd")
		end)
		Close.MouseButton1Down:Connect(function() -- line: 288
			-- upvalues: t10 (copy), Network (copy), Sounds (copy)
			t10.UpdateLogMenu:ToggleMenu(false)
			Network:FireServerConnection("UpdateLogToLatest", "REMOTE_EVENT")
			Sounds:Play("click")
		end)

		for _, v in next, Changelogs:GetChildren() do
			local ok, result = pcall(function() -- line: 295
				-- upvalues: v (copy)
				return require(v)
			end)

			if not ok then
				warn(`Failed to load changelog { v.Name }: { result }`)
			else
				local clone = script.Presets.UpdateTemplate:Clone()

				clone.Name = result.TitleMeta.Text.Title
				clone.UpdateName.Text = result.TitleMeta.Text.Title or "N/A"
				clone.Description.Text = result.TitleMeta.Text.Description or (result.TitleMeta.Text.Date or "None Provided")
				clone.Render.Image = result.TitleMeta.Image.Backdrop or result.TitleMeta.Image.Small or result.TitleMeta.Image.Title or ""

				local v87, v88, v89 = result.TitleMeta.Text.Date:match("(%d+)-(%d+)-(%d+)")

				clone.LayoutOrder = -string.format("%02d%02d%02d", tonumber(v89), tonumber(v87), (tonumber(v88)))
				clone.Parent = Menu.List.Updates
				clone.MouseEnter:Connect(function() -- line: 312
					-- upvalues: Sounds (copy)
					Sounds:Play("hover")
				end)
				clone.MouseLeave:Connect(function() -- line: 316
					-- upvalues: Sounds (copy)
					Sounds:Play("hoverEnd")
				end)
				clone.MouseButton1Down:Connect(function() -- line: 320
					-- upvalues: TextTitle (ref), result (copy), __switchPage (copy), Menu (copy), Sounds (copy)
					if TextTitle == result.TitleMeta.Text.Title then
						return
					end

					TextTitle = result.TitleMeta.Text.Title
					__switchPage(Menu, result)
					Sounds:Play("click")
				end)
				t5[v.Name] = result
			end
		end

		if t5[LatestLog]then __switchPage(Menu, t5[LatestLog])end
        if t5[LatestLog]and DataHandler:Get().Misc.LastSeenLog.Value ~= LatestLog then t10.UpdateLogMenu:ToggleMenu(true)end
	end)
end

return t10
]========])
assert(game.ReplicatedStorage.Modules.PlayerList.Source==[========[
local t1 = {
	_players = {},
	DisplayedStats = {
		"Money",
		"KillerChance"
	},
	ListEnabled = true
}
local SocialService = game:GetService("SocialService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

game:GetService("TextChatService")

local v6 = RunService:IsStudio()
local clamp = math.clamp
local LocalPlayer = Players.LocalPlayer

require(game.ReplicatedStorage.Modules.Actors)

local DataHandler = require(game.ReplicatedStorage.Modules.DataHandler)
local Util = require(game.ReplicatedStorage.Modules.Util)
local Sounds = require(game.ReplicatedStorage.Modules.Sounds)
local Network = require(game.ReplicatedStorage.Modules.Network)
local t2 = {
	KillerChance = "Malice",
	RbxSpent = "R$ Spent"
}
local t3 = {
	PC = "rbxassetid://135066638879377",
	Mobile = "rbxassetid://89227325753198",
	Console = "rbxassetid://118447973769044",
	Unknown = "rbxassetid://94182197303121",
	NoChat = "rbxassetid://8509669675"
}

local function getPath(p1, s1: string, n1: number?) -- line: 51
	assert(typeof(p1) == "Instance")
	assert(typeof(s1) == "string")

	if s1 == "" then
		return p1
	end

	for _, v23 in (string.split(s1, "/")) do
		if typeof(n1) ~= "number" then
			p1 = p1:FindFirstChild(v23)

			if p1 ~= nil then
				continue
			end

			return
		end

		p1 = p1:WaitForChild(v23, n1)

		if p1 == nil then
			return
		end
	end

	return p1
end

function t1.GetPlayerListUI(p2) -- line: 76
	if not p2.PlayerList then
		repeat
			task.wait()
		until p2.PlayerList
	end

	return p2.PlayerList
end

local thread = nil
local u17 = true

function t1.TogglePlayerList(_, p4, p5) -- line: 85
	-- upvalues: t1 (copy), Sounds (copy), thread (ref), u17 (ref)
	if p5 then
		t1.ListEnabled = p4
	elseif not t1.ListEnabled then
		return
	end

	if not p5 then
		Sounds:Play("switch")
	end

	local PlayerListUI = t1:GetPlayerListUI()

	if thread then
		task.cancel(thread)
	end

	if p4 then
		u17 = true
		PlayerListUI.Close.Text = ">"
		PlayerListUI.Close.Visible = true
		PlayerListUI.Contents.Visible = true
		PlayerListUI.Background.Visible = true
		PlayerListUI.FriendBoost.Visible = true
		game.TweenService:Create(PlayerListUI, TweenInfo.new(0.15), {
			AnchorPoint = script.PlayerListHolder.AnchorPoint,
			Position = script.PlayerListHolder.Position
		}):Play()

		return
	end

	u17 = false
	PlayerListUI.Close.Text = "<"
	game.TweenService:Create(PlayerListUI, TweenInfo.new(0.15), {
		AnchorPoint = Vector2.new(),
		Position = UDim2.new(1, 0, 0, script.PlayerListHolder.Position.Y.Offset)
	}):Play()
	thread = task.delay(0.15, function() -- line: 116
		-- upvalues: p5 (copy), PlayerListUI (copy)
		if p5 then
			PlayerListUI.Close.Visible = false
		end

		PlayerListUI.Contents.Visible = false
		PlayerListUI.Background.Visible = false
		PlayerListUI.FriendBoost.Visible = false
	end)
end

local t4 = {}

function t1.ShowPlayerStats(t5: {[any]: any}, p6) -- line: 127
	-- upvalues: t4 (copy), Sounds (copy), t1 (copy), t3 (copy), DataHandler (copy), Util (copy), LocalPlayer (copy)
	for _, v in pairs(t4) do
		v:Disconnect()
	end

	table.clear(t4)

	if t5.__currentlyDisplayedStats and t5.__currentlyDisplayedStats.Parent then
		if tostring(t5.__currentlyDisplayedStats) == tostring(p6) then
			game.TweenService:Create(t5.__currentlyDisplayedStats, TweenInfo.new(0.15), {
				Size = UDim2.fromScale()
			}):Play()
			game.Debris:AddItem(t5.__currentlyDisplayedStats, 0.15)
			t5.__currentlyDisplayedStats = nil

			return
		end

		t5.__currentlyDisplayedStats:Destroy()
	end

	local clone = script.PlayerStats:Clone()

	clone.Name = tostring(p6)
	clone.Close.MouseEnter:Connect(function() -- line: 150
		-- upvalues: Sounds (copy)
		Sounds:Play("hover")
	end)
	clone.Close.MouseLeave:Connect(function() -- line: 151
		-- upvalues: Sounds (copy)
		Sounds:Play("hoverEnd")
	end)
	clone.Close.MouseButton1Click:Connect(function() -- line: 152
		-- upvalues: Sounds (copy), t1 (copy), p6 (copy)
		Sounds:Play("select")
		t1:ShowPlayerStats(p6)
	end)

	local v34 = `@{ p6.Name }`
	local v35 = p6.DisplayName ~= p6.Name and (p6.DisplayName ~= "" and p6.DisplayName)

	clone.BasicInfo.PlayerName.Text = v35 or v34
	clone.BasicInfo.PlayerUsername.Text = v34
	clone.BasicInfo.PlayerUsername.Visible = v35
	task.spawn(function() -- line: 164
		-- upvalues: p6 (copy), clone (copy)
		local UserId = p6.UserId
		local UserThumbnailAsync = game.Players:GetUserThumbnailAsync(UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)

		clone.PlayerIconHolder.Player.Image = UserThumbnailAsync
	end)

	local function updatePlayerDevice() -- line: 171
		-- upvalues: t3 (copy), p6 (copy), clone (copy)
		local v93 = t3[p6:GetAttribute("Device")] or t3.Unknown

		clone.PlayerIconHolder.Device.Image = v93
	end

	local v37 = t3[p6:GetAttribute("Device")] or t3.Unknown

	clone.PlayerIconHolder.Device.Image = v37
	table.insert(t4, p6:GetAttributeChangedSignal("Device"):Connect(updatePlayerDevice))

	local v38 = DataHandler:Get(p6)
	local v39 = v38 and v38:FindFirstChild("Stats")
	local v40 = v38 and v38:FindFirstChild("Equipped")

	if v39 and v40 then
		local General = v39:FindFirstChild("General")
		local v42 = General and General:FindFirstChild("TimePlayed")

		if v42 then
			local function updateTimePlayed() -- line: 256
				-- upvalues: Util (copy), p6 (copy), clone (copy), v42 (copy)
				local SettingValue = Util:GetSettingValue("HidePlaytime", p6)

				clone.TimePlayed.Text = `Time Played: { (if not SettingValue then Util:FormatTime(v42.Value, "Clock") else "<font color=\"rgb(125,125,125)\"><i>(Hidden)</i></font>") }`
			end

			local SettingValue = Util:GetSettingValue("HidePlaytime", p6)

			clone.TimePlayed.Text = `Time Played: { (if not SettingValue then Util:FormatTime(v42.Value, "Clock") else "<font color=\"rgb(125,125,125)\"><i>(Hidden)</i></font>") }`
			table.insert(t4, v42:GetPropertyChangedSignal("Value"):Connect(updateTimePlayed))
		end

		for _, v in pairs({
			"Killer",
			"Survivor"
		}) do
			local v47 = v39 and v39:FindFirstChild(`{ v }Stats`)
			local v48 = v47 and v47:FindFirstChild(`{ v }Kills`)

			if v48 then
				local SettingValue = Util:GetSettingValue(`Hide{ v }Wins`, p6)
				local v50 = clone.WinInfo:FindFirstChild(`{ v }Wins`)

				v50.MouseEnter:Connect(function() -- line: 275
					-- upvalues: Util (copy), v (copy), SettingValue (copy)
					Util:CreateTooltip(`{ v } Kills{ not SettingValue and "" or " <font color=\"rgb(125,125,125)\"><i>(Hidden)</i></font>" }`)
				end)
				v50.MouseLeave:Connect(function() -- line: 276
					-- upvalues: Util (copy)
					Util:CreateTooltip()
				end)

				local function setScore() -- line: 279
					-- upvalues: v50 (copy), SettingValue (copy), v48 (copy)
					v50.Wins.Text = if not SettingValue then v48.Value else "<font color=\"rgb(125,125,125)\"><i>(Hidden)</i></font>"
				end

				v50.Wins.Text = if not SettingValue then v48.Value else "<font color=\"rgb(125,125,125)\"><i>(Hidden)</i></font>"
				table.insert(t4, v48:GetPropertyChangedSignal("Value"):Connect(setScore))
			end

			if v40 then
				local t6 = {}

				local function setEquippedIcon() -- line: 292
					-- upvalues: p6 (copy), v (copy), t6 (ref), clone (copy), Util (copy)
					local v95, v96 = require(game.ReplicatedStorage.Modules.Actors):GetEquippedActorInfo(p6, v)
					local v97 = game.ReplicatedStorage.Assets:FindFirstChild(`{ v }s`):FindFirstChild(v95)
					local v98 = v97 and (v97:FindFirstChild("Config") and require(v97.Config))
					local v99 = game.ReplicatedStorage.Assets.Skins:FindFirstChild(`{ v }s`):FindFirstChild(v95)
					local v100 = v99 and v99:FindFirstChild(v96)
					local v101 = v100 and (v100:FindFirstChild("Config") and require(v100.Config))

					if v98 then
						for _, v2 in pairs(t6) do
							v2:Disconnect()
						end

						table.clear(t6)

						local v3 = clone.BasicInfo.EquippedCharacters:FindFirstChild(v)
						local u105 = `Equipped { v }: <i>{ v98.DisplayName or tostring(v97) }</i>`

						if v101 then
							u105 = `{ u105 }\nEquipped Skin: <i>{ v101.DisplayName or tostring(v100) }</i>`
						end

						v3.Image = v101 and v101.RenderImage or (v98.RenderImage or "rbxassetid://13373279056")
						t6 = {
							v3.MouseEnter:Connect(function() -- line: 316
								-- upvalues: Util (copy), u105 (ref)
								Util:CreateTooltip(u105)
							end),
							v3.MouseLeave:Connect(function() -- line: 317
								-- upvalues: Util (copy)
								Util:CreateTooltip()
							end)
						}
					end
				end

				local v4 = v40:FindFirstChild(v)
				local v5 = v40.Skins:FindFirstChild(v)

				setEquippedIcon()

				if v4 then
					table.insert(t4, v4:GetPropertyChangedSignal("Value"):Connect(setEquippedIcon))
				end

				if v5 then
					table.insert(t4, v5:GetPropertyChangedSignal("Value"):Connect(setEquippedIcon))
				end
			end
		end
	end

	if not t5.__currentlyDisplayedStats then
		clone.Size = UDim2.new()
		game.TweenService:Create(clone, TweenInfo.new(0.15), {
			Size = script.PlayerStats.Size
		}):Play()
	end

	clone.Parent = LocalPlayer.PlayerGui.TemporaryUI
	t5.__currentlyDisplayedStats = clone
	clone.AncestryChanged:Connect(function(_, parent) -- line: 345
		-- upvalues: Util (copy), t4 (copy)
		if not parent then
			Util:CreateTooltip()

			for _, v in pairs(t4) do
				v:Disconnect()
			end

			table.clear(t4)
		end
	end)
end
function t1.CreatePlayerInList(_: {[any]: any}, p8) -- line: 356
	-- upvalues: t1 (copy), Util (copy), Network (copy), v6 (copy)
	if not p8 then
		return
	end

	local PlayerListUI = t1:GetPlayerListUI()
	local v59 = PlayerListUI.Contents.Players:FindFirstChild((tostring(p8)))

	if v59 then
		v59:Destroy()
	end

	local clone = script.PlayerInfoContainer:Clone()

	clone.Name = tostring(p8)

	local p8Name = p8.Name
	local v62 = p8.DisplayName ~= p8.Name and (p8.DisplayName ~= "" and p8.DisplayName)

	local baseName = v62 or p8Name
	clone.PlayerInfo.Username.Text = baseName
	clone.PlayerInfo.Username.RichText = true

	local function updateAFKStatus()
		local afkValue = Util:GetSettingValue("AFK", p8)
		local isAFK = afkValue == true or (typeof(afkValue) == "number" and afkValue > 0)
		clone.PlayerInfo.Username.Text = isAFK and `{baseName} <font color="#B82500">[AFK]</font>` or baseName
	end

	task.spawn(function()
		local playerData = DataHandler:Get(p8)
		if not playerData then return end
		local settings = playerData:FindFirstChild("Settings")
		if not settings then return end
		local afkSetting = settings:FindFirstChild("AFK", true)
		if afkSetting then
			afkSetting:GetPropertyChangedSignal("Value"):Connect(updateAFKStatus)
		end
		updateAFKStatus()
	end)

	clone.ShowStats.MouseButton1Click:Connect(function() -- line: 375
		-- upvalues: t1 (copy), p8 (copy)
		t1:ShowPlayerStats(p8)
	end)

	if t1.DisplayedStats and t1.DisplayedStats[1] then
		local leaderstats = p8:WaitForChild("leaderstats", 30)

		if not leaderstats or not p8.Parent then
			return
		end

		for _, child in pairs(leaderstats:GetChildren()) do
			local clone2 = clone.PlayerInfo.Username:Clone()

			clone2.Name = child and child.Name
			clone2.Size = UDim2.fromScale(0.3, 1)
			clone2.LayoutOrder = table.find(t1.DisplayedStats, child.Name)
			clone2.TextXAlignment = Enum.TextXAlignment.Center
			clone2.Parent = clone.PlayerInfo

			local function updateStat() -- line: 396
				-- upvalues: child (copy), clone2 (copy), Util (copy)
				local v110 = child and child.Value or "?"

				if tonumber(v110) then
					clone2.TextColor3 = v110 > 0 and Color3.new(1, 1, 1) or Color3.new(1, 0, 0)
					v110 = Util:ConvertToAbbreviation(v110)
				end

				if v110.Name == "Money" then
					v110 = `${ v110 }`
				end

				clone2.Text = tostring(v110)
			end

			updateStat()

			if child then
				child:GetPropertyChangedSignal("Value"):Connect(updateStat)
			end
		end
	end

	local v68 = Network:FireServerConnection("ReturnCanChat", "REMOTE_FUNCTION", p8)

	if v6 or not v68 then
		clone.NoChat.Visible = true
		clone.NoChat.MouseEnter:Connect(function() -- line: 422
			-- upvalues: Util (copy)
			Util:CreateTooltip("You cannot communicate with this player.")
		end)
		clone.NoChat.MouseLeave:Connect(function() -- line: 425
			-- upvalues: Util (copy)
			Util:CreateTooltip()
		end)
	end

	clone.Parent = PlayerListUI.Contents.Players
	t1:__UpdateListSize()
end
function t1.RemovePlayerFromList(_: {[any]: any}, p9) -- line: 437
	-- upvalues: t1 (copy)
	local v71 = t1:GetPlayerListUI().Contents.Players:FindFirstChild((tostring(p9)))

	if v71 then
		v71:Destroy()
	end

	t1:__UpdateListSize()
end
function t1.__UpdateListSize(_) -- line: 450
	-- upvalues: t1 (copy)
	local PlayerListUI = t1:GetPlayerListUI()
	local UIListLayout = PlayerListUI.Contents.Players.UIListLayout
	local v75 = UIListLayout.AbsoluteContentSize.Y + UIListLayout.Padding.Offset

	PlayerListUI.Background.Size = UDim2.fromScale(1, (math.clamp(0.05 + 30 / PlayerListUI.AbsoluteSize.Y + v75 / PlayerListUI.AbsoluteSize.Y, 0, 1)))
	PlayerListUI.FriendBoost.Position = UDim2.fromScale(0, (math.clamp(0.05 + 30 / PlayerListUI.AbsoluteSize.Y + v75 / PlayerListUI.AbsoluteSize.Y, 0, 1)))
end
function t1.Start(p11) -- line: 460
	-- upvalues: LocalPlayer (copy), t1 (copy), t2 (copy), SocialService (copy), clamp (copy), Util (copy), u17 (ref), Sounds (copy)
	if game["Run Service"]:IsServer() then
		return
	end

	local clone = script.PlayerListHolder:Clone()
	local Contents = clone.Contents

	clone.Parent = LocalPlayer.PlayerGui:WaitForChild("MainUI")
	Contents:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 521
		-- upvalues: t1 (copy)
		t1:__UpdateListSize()
	end)

	for k, v in pairs(t1.DisplayedStats) do
		local clone3 = Contents.InfoTypes.Players:Clone()

		clone3.Name = v
		clone3.Text = t2[v] or v:gsub("(%l)(%u)", "%1 %2")
		clone3.Size = UDim2.fromScale(0.3, 1)
		clone3.LayoutOrder = k + 1
		clone3.TextXAlignment = Enum.TextXAlignment.Center
		clone3.Parent = Contents.InfoTypes
	end

	local _ = {
		JOINING = true,
		LEAVING = false
	}
	local ExperienceInviteOptions = Instance.new("ExperienceInviteOptions")

	ExperienceInviteOptions.PromptMessage = `Invite Friends, get { 10 }% more EXP per friend! (caps at { 20 }%).`

	local function __canSendInvite(p12) -- line: 547
		-- upvalues: SocialService (copy)
		local ok, result = pcall(function() -- line: 548
			-- upvalues: SocialService (copy), p12 (copy)
			return SocialService:CanSendGameInviteAsync(p12)
		end)

		return ok and result
	end

	local Button = clone.FriendBoost.Button

	Button.MouseButton1Down:Connect(function() -- line: 556
		-- upvalues: LocalPlayer (copy), SocialService (copy), ExperienceInviteOptions (copy)
		local v114 = LocalPlayer
		local ok, result = pcall(function() -- line: 548
			-- upvalues: SocialService (copy), v114 (copy)
			return SocialService:CanSendGameInviteAsync(v114)
		end)

		if ok and result then
			SocialService:PromptGameInvite(LocalPlayer, ExperienceInviteOptions)
		end
	end)

	local n2 = 0

	local function __setBoostDisplay(p13, b1: boolean) -- line: 564
		-- upvalues: LocalPlayer (copy), n2 (ref), clamp (copy), Button (copy)
		local ok, result = pcall(function() -- line: 566
			-- upvalues: LocalPlayer (copy), p13 (copy)
			return LocalPlayer:IsFriendsWith(p13.UserId)
		end)

		if ok and result then
			n2 = clamp(n2 + 10 * (not b1 and -1 or 1), 0, 20)
		end

		local v121 = `Invite Friends (+{ n2 }% EXP)`

		if v121 ~= Button.Text then
			Button.Text = v121
		end
	end

	Util.OnPlayerAdded(function(p14) -- line: 587
		-- upvalues: LocalPlayer (copy), n2 (ref), clamp (copy), Button (copy), t1 (copy)
		if p14 ~= LocalPlayer then
			local ok, result = pcall(function() -- line: 566
				-- upvalues: LocalPlayer (copy), p14 (copy)
				return LocalPlayer:IsFriendsWith(p14.UserId)
			end)

			if ok and result then
				n2 = clamp(n2 + 10, 0, 20)
			end

			local v125 = `Invite Friends (+{ n2 }% EXP)`

			if v125 ~= Button.Text then
				Button.Text = v125
			end
		end

		t1:CreatePlayerInList(p14)
	end)
	game.Players.PlayerRemoving:Connect(function(player) -- line: 596
		-- upvalues: LocalPlayer (copy), n2 (ref), clamp (copy), Button (copy), t1 (copy)
		if player ~= LocalPlayer then
			local ok, result = pcall(function() -- line: 566
				-- upvalues: LocalPlayer (copy), player (copy)
				return LocalPlayer:IsFriendsWith(player.UserId)
			end)

			if ok and result then
				n2 = clamp(n2 + -10, 0, 20)
			end

			local v129 = `Invite Friends (+{ n2 }% EXP)`

			if v129 ~= Button.Text then
				Button.Text = v129
			end
		end

		t1:RemovePlayerFromList(player)
	end)
	clone.Close.MouseButton1Click:Connect(function() -- line: 604
		-- upvalues: t1 (copy), u17 (ref)
		t1:TogglePlayerList(not u17)
	end)
	game.UserInputService.InputBegan:Connect(function(input, gameProcessed) -- line: 608
		-- upvalues: t1 (copy), u17 (ref)
		if gameProcessed then
			return
		end

		if input.KeyCode == Enum.KeyCode.Tab then
			t1:TogglePlayerList(not u17)
		end
	end)

	local function addSFX(p15) -- line: 616
		-- upvalues: Sounds (copy)
		if p15:IsA("ImageButton") or p15:IsA("TextButton") then
			p15.MouseEnter:Connect(function() -- line: 618
				-- upvalues: Sounds (copy)
				Sounds:Play("hover")
			end)
			p15.MouseLeave:Connect(function() -- line: 619
				-- upvalues: Sounds (copy)
				Sounds:Play("hoverEnd")
			end)
			p15.MouseButton1Click:Connect(function() -- line: 620
				-- upvalues: Sounds (copy)
				Sounds:Play("select")
			end)
		end
	end

	for _, descendant in pairs(clone:GetDescendants()) do
		addSFX(descendant)
	end

	clone.DescendantAdded:Connect(addSFX)
	p11.PlayerList = clone
	game.StarterGui:SetCoreGuiEnabled("PlayerList", false)
end

return t1

]========])
assert(game.ServerScriptService.Server.Systems.Data.LeaderStats.Source==[========[
local module = {}

module.AddStats = function(_, Player : Player)
	task.spawn(function()
		local newStats = script.Template:Clone()
		newStats.Parent = Player
		newStats.Name = "leaderstats"
		
		Player:WaitForChild("PlayerData")
		local plrData : Folder = Player.PlayerData
		plrData:WaitForChild("Stats")
		local statsFolder : Folder = plrData.Stats
		local moneyVal = statsFolder:FindFirstChild("Money", true)
		local kChanceVal = statsFolder:FindFirstChild("KillerChance", true)
		
		newStats.Money.Value = moneyVal.Value
		newStats.KillerChance.Value = kChanceVal.Value
		
		moneyVal:GetPropertyChangedSignal("Value"):Connect(function()
			newStats.Money.Value = moneyVal.Value
		end)
		kChanceVal:GetPropertyChangedSignal("Value"):Connect(function()
			newStats.KillerChance.Value = kChanceVal.Value
		end)
	end)
end

return module]========])
print("PASS installer: matching build, idempotence, mismatched source rejection and rollback")
