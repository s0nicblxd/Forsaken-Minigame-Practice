

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
