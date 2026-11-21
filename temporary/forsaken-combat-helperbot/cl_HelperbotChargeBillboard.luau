
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local Trove = require(ReplicatedStorage.Modules.Misc.Trove)
local t1 = {}

t1.__index = t1

function t1.new(p1, p2, t2: {[any]: any}, p3: ((...any) -> ...any)) -- line: 12
	-- upvalues: t1 (copy), Trove (copy)
	local self = setmetatable({}, t1)
	local clone = p1:Clone()

	clone.Adornee = p2.PrimaryPart or p2
	clone.Name = "ChargeBillboard"
	clone.Parent = p2
	self.__instance = clone
	self.__character = p2
	self.__config = t2
	self.__internalTrove = Trove.new()
	self.DestroyedCallback = p3
	self.__destroyed = false
	self.__completed = false
	self.__internalTrove:Connect(p2.AncestryChanged, function() -- line: 27
		-- upvalues: p2 (copy), self (copy)
		if not p2:IsDescendantOf(workspace) then
			self:Destroy()
		end
	end)
	self.__internalTrove:Connect(clone.AncestryChanged, function() -- line: 32
		-- upvalues: clone (copy), p2 (copy), self (copy)
		if clone.Parent ~= p2 then
			self:Destroy()
		end
	end)
	self.__internalTrove:Connect(clone.Destroying, function() -- line: 37
		-- upvalues: self (copy)
		self:Destroy(true)
	end)

	local Humanoid = p2:FindFirstChildOfClass("Humanoid")

	if Humanoid then
		self.__internalTrove:Connect(Humanoid.Died, function() -- line: 42
			-- upvalues: self (copy)
			self:Destroy()
		end)
	end

	self:Init()

	return self
end
function t1.Init(p4) -- line: 51
	p4.__instance.Background.Bar.BackgroundColor3 = p4.__config.ChargeColors.Default
	p4.__instance.Background.Bar.Size = UDim2.fromScale(0, 1)
end
function t1.CancelFill(p5) -- line: 56
	if p5.__currentTween then
		p5.__currentTween:Cancel()
		p5.__currentTween:Destroy()
		p5.__currentTween = nil
	end
end
function t1.DisplaySuccess(p6) -- line: 64
	if p6.__destroyed or p6.__completed then
		return
	end

	p6.__completed = true
	p6:CancelFill()

	local Bar = p6.__instance.Background.Bar

	Bar.BackgroundColor3 = p6.__config.ChargeColors.Success
	Bar.Size = UDim2.fromScale(1, 1)
	task.delay(0.25, function() -- line: 71
		-- upvalues: p6 (copy)
		p6:Destroy()
	end)
end
function t1.TweenFill(t3: {[any]: any}, n1: number, n2: number, n3: number?) -- line: 76
	-- upvalues: TweenService (copy)
	if t3.__destroyed or t3.__completed then
		return
	end

	t3:CancelFill()

	local Bar = t3.__instance.Background.Bar

	if n3 ~= nil then
		Bar.Size = UDim2.fromScale(math.clamp(n3, 0, 1), 1)
	end

	local uDim2 = UDim2.fromScale(math.clamp(n2, 0, 1), 1)

	if n1 <= 0 then
		Bar.Size = uDim2

		return
	end

	t3.__currentTween = TweenService:Create(Bar, TweenInfo.new(n1, Enum.EasingStyle.Linear), {
		Size = uDim2
	})
	t3.__currentTween:Play()
end
function t1.Destroy(t4: {[any]: any}, b1: boolean?) -- line: 92
	-- upvalues: TweenService (copy), Debris (copy)
	if t4.__destroyed then
		return
	end

	t4.__destroyed = true
	t4:CancelFill()
	t4.__internalTrove:Destroy()

	local __instance = t4.__instance

	if not b1 and __instance.Parent then
		local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

		TweenService:Create(__instance.Background.Bar, tweenInfo, {
			Size = UDim2.fromScale(0, 1)
		}):Play()

		for _, descendant in ipairs(__instance:GetDescendants()) do
			if descendant:IsA("TextLabel") then
				TweenService:Create(descendant, tweenInfo, {
					TextTransparency = 1,
					TextStrokeTransparency = 1
				}):Play()
			elseif descendant:IsA("ImageLabel") then
				TweenService:Create(descendant, tweenInfo, {
					ImageTransparency = 1
				}):Play()
			elseif descendant:IsA("Frame") then
				TweenService:Create(descendant, tweenInfo, {
					BackgroundTransparency = 1
				}):Play()
			elseif descendant:IsA("UIStroke") then
				TweenService:Create(descendant, tweenInfo, {
					Transparency = 1
				}):Play()
			end
		end

		Debris:AddItem(__instance, 0.5)
	elseif not b1 then
		__instance:Destroy()
	end

	local DestroyedCallback = t4.DestroyedCallback

	t4.DestroyedCallback = nil

	if DestroyedCallback then
		DestroyedCallback()
	end
end

return t1