local t1 = {
	CurrentStatuses = {},
	StatusCounts = {}
}
local ReplicatedStorage = game:GetService("ReplicatedStorage")

game:GetService("CollectionService")

local RunService = game:GetService("RunService")
local Network = require(game.ReplicatedStorage.Modules.Network)
local Sounds = require(game.ReplicatedStorage.Modules.Sounds)
local Util = require(game.ReplicatedStorage.Modules.Util)
local Signal = require(game.ReplicatedStorage.Modules.Misc.Signal)
local StatusEffects = game.ReplicatedStorage.Modules.StatusEffects

local function statusClient(target, ...)
	if typeof(target) == "Instance" and target:IsA("Player") then
		Network:FireClientConnection(target, ...)
	end
end

function t1.ApplyStatus(_: {[any]: any}, p1, s1: string, t3: {[any]: any}) -- line: 18
	-- upvalues: RunService (copy), t1 (copy), StatusEffects (copy), Util (copy), ReplicatedStorage (copy), Sounds (copy), Network (copy)
	assert(RunService:IsServer(), "Can only apply statuses on server.")

	if typeof(p1) ~= "Instance" then return end
	t3 = t3 or {}
	local v13 = p1:IsA("Model") and (game.Players:GetPlayerFromCharacter(p1) or p1) or p1
	local v14 = v13:IsA("Model") and v13 or v13:IsA("Player") and v13.Character
	if not v14 or not v14.Parent then return end

	t1.CurrentStatuses[v13] = t1.CurrentStatuses[v13] or {}

	local v15 = StatusEffects:FindFirstChild(tostring(s1), true)
	local v16 = v15 and require(v15)
	local v17 = t1.CurrentStatuses[v13][s1] ~= nil
	local v18 = t1.CurrentStatuses[v13][s1] or v16 and Util:CopyTable(v16)

	if v18 and v14 then
		local v19 = require(ReplicatedStorage.Modules.Actors).CurrentActors[v13]
        local incomingDurationScale=1
        if v19 and v19.Behavior and v19.Behavior.GetIncomingStatusDurationMultiplier then
            incomingDurationScale=v19.Behavior:GetIncomingStatusDurationMultiplier(v19,s1,v16 and v16.Data) or 1
            if incomingDurationScale~=1 or v18.JDIncomingScaled then
                t3=Util:CopyTable(t3 or {})
                t3.Duration=(tonumber(t3.Duration) or tonumber(v16 and v16.Data and v16.Data.Duration) or 10)*incomingDurationScale
            end
        end
		local v20 = v19 and v19.Config.StatusData

		if v20 and v20.ExcludeApplying and table.find(v20.ExcludeApplying, s1) then
			return
		end

		if v19 and v19.Behavior and v19.Behavior[`On{ s1 }Absolute`] then
			v19.Behavior[`On{ s1 }Absolute`](v19.Behavior, v19)
		end

		if v18.Level and t3 and t3.Level and t3.Level < v18.Level and not t3.Stackable then
			return
		end

		if v14:GetAttribute(`{ s1 }Disabled`) then
			return
		end

		for k, v in pairs(t3 or {}) do
			v18.Data[k] = v
		end

		if v19 then
			Sounds:PlayVoiceline(v19, `{ s1 }Status`, {
				Priority = 5
			})
		end


		if v17 then
			if v18.Data.TimeStackable == false then
				return
			end

			if t3.TimeStackable == false then
				return
			end

			v18.TimePast = 0
            if incomingDurationScale~=1 or v18.JDIncomingScaled then v18.TimeRequired=tonumber(v18.Data.Duration) or v18.TimeRequired end
            v18.JDIncomingScaled=incomingDurationScale~=1 or nil

			if v18.Data.Stackable then
				v18.Level = math.clamp(v18.Level + (t3 and t3.Level or 1), 1, v18.Data.MaxLevel or 99)
			elseif v18.Data.Level and v18.Data.Level > v18.Level then
				v18.Level = v18.Data.Level
			end

			if v18.Applied then
				v18:Applied()
			end

			statusClient(v13, "StatusUpdated", "REMOTE_EVENT", s1, {
				TimePast = 0,
				Level = v18.Level,
				Duration = v18.Data.Duration or v18.TimeRequired
			})

			if v19 and v19.Behavior and v19.Behavior[`On{ s1 }`] then
				v19.Behavior[`On{ s1 }`](v19.Behavior, v19)
			end

			return v18
		end

		v18.Player = v13
		v18.Character = v14
		v18.Level = v18.Data.Level or 1
		v18.AppliedFrom = t3.AppliedFrom or "None"
		v18.TimeRequired = tonumber(v18.Data.Duration) or 10
        v18.JDIncomingScaled=incomingDurationScale~=1 or nil
		v18.TimePast = 0

		local function __updateStatusData(t4: {[any]: any}) -- line: 128
			-- upvalues: v18 (copy), v19 (copy)
			if not t4 then
				return
			end

			if (t4.ExcludeIfAppliedFrom or "") == v18.AppliedFrom then
				return
			end

			local v62 = t4.TotalTimeMult or 0

			if v62 > 0 and v19 and v19.Hunting then
				v62 = if not v19.Hunting then v62 else 0.5
			end

			if v62 > 0 then
				local v63 = v18

				v63.TimeRequired = v63.TimeRequired * v62

				local Data = v18.Data

				Data.Duration = Data.Duration * v62
			end
		end

		if v20 and (v20.ExcludeIfAppliedFrom or "") ~= v18.AppliedFrom then
			local v27 = v20.TotalTimeMult or 0

			if v27 > 0 and v19 and v19.Hunting then
				v27 = if not v19.Hunting then v27 else 0.5
			end

			if v27 > 0 then
				v18.TimeRequired = v18.TimeRequired * v27

				local Data = v18.Data

				Data.Duration = Data.Duration * v27
			end
		end

		local PrimaryPart = v14.PrimaryPart

		if PrimaryPart and PrimaryPart.Parent then
			local v30 = Sounds:Play(v18.Data.SFX, {
				Looped = true,
				RollOffMinDistance = 16,
				RollOffMaxDistance = 48,
				Parent = PrimaryPart
			})

			if v30 then
				v30.Name = `{ s1 }StatusSFX`
				game.Debris:AddItem(v30, 30)
			end
		end

		t1.CurrentStatuses[v13][s1] = v18
		t1.StatusCounts[v13] = (t1.StatusCounts[v13] or 0) + 1
		if v18.Applied then v18:Applied() end
		if not t1.CurrentStatuses[v13] or t1.CurrentStatuses[v13][s1] ~= v18 then return end
		statusClient(v13, "StatusApplied", "REMOTE_EVENT", s1, v18, v18.Data)

		if v19 and v19.Behavior and v19.Behavior[`On{ s1 }`] then
			v19.Behavior[`On{ s1 }`](v19.Behavior, v19)
		end

		if t1:GetStatusCount(v13) >= 4 then
			require(ReplicatedStorage.Modules.AchievementUtil):IncrementAchievementProgress(v13, "LotsaStatuses")
		end

		t1.StatusApplied:Fire(v13, s1, v18, v17)

		return v18
	end
end
function t1.RemoveStatus(_, p3, p4) -- line: 186
	-- upvalues: t1 (copy), Network (copy), ReplicatedStorage (copy)
	if p3 and p3:IsA("Model") then
		p3 = game.Players:GetPlayerFromCharacter(p3) or p3
	end

	local v34 = t1.CurrentStatuses[p3] and t1.CurrentStatuses[p3][p4]

	if v34 then
		t1.CurrentStatuses[p3][p4] = nil
		t1.StatusCounts[p3] = math.max((t1.StatusCounts[p3] or 1) - 1, 0)
		if v34.Removed then
			v34:Removed()
		end

		statusClient(p3, "StatusRemoved", "REMOTE_EVENT", p4)

		local v35 = p3:IsA("Player") and p3.Character or p3
		local v36 = v35 and v35:FindFirstChild(`{ p4 }StatusSFX`, true)

		if v36 then
			game.Debris:AddItem(v36, 0.25)
			game.TweenService:Create(v36, TweenInfo.new(0.25), {
				Volume = 0
			}):Play()
		end

		local v37 = require(ReplicatedStorage.Modules.Actors).CurrentActors[p3]

		if v37 and v37.Behavior and v37.Behavior[`{ p4 }Ended`] then
			v37.Behavior[`{ p4 }Ended`](v37.Behavior, v37)
		end

	end

	if t1.CurrentStatuses[p3] and next(t1.CurrentStatuses[p3]) == nil then
		table.clear(t1.CurrentStatuses[p3])
		t1.CurrentStatuses[p3] = nil
		t1.StatusCounts[p3] = nil
	end
end
function t1.RemoveStatuses(_, p6, _) -- line: 230
	-- upvalues: t1 (copy)
	if p6 and p6:IsA("Model") then
		p6 = game.Players:GetPlayerFromCharacter(p6) or p6
	end

	for k, _ in pairs(t1.CurrentStatuses[p6] or {}) do
		t1:RemoveStatus(p6, k)
	end

	t1.CurrentStatuses[p6] = nil
	t1.StatusCounts[p6] = nil
end
function t1.GetStatusCount(_, p9) -- line: 246
	-- upvalues: t1 (copy)
	return t1.StatusCounts[p9] or -1
end
function t1.PlayerHasStatus(_, p11, p12) -- line: 250
	-- upvalues: t1 (copy)
	if typeof(p11) ~= "Instance" then return nil end
	local v48 = p11:IsA("Model") and (game.Players:GetPlayerFromCharacter(p11) or p11) or p11

	return t1.CurrentStatuses[v48] and t1.CurrentStatuses[v48][p12]
end
function t1.Start(_) -- line: 255
	-- upvalues: RunService (copy), Util (copy), t1 (copy), StatusEffects (copy), Network (copy)
	if RunService:IsServer() then
		Util.OnCharacterAdded(function(_, p15) -- line: 259
			-- upvalues: t1 (copy)
			t1:RemoveStatuses(p15)
		end)
		game.Players.PlayerRemoving:Connect(function(player) -- line: 264
			-- upvalues: t1 (copy)
			t1:RemoveStatuses(player)
		end)
		RunService.Heartbeat:Connect(function(dt: number) -- line: 268
			-- upvalues: t1 (copy)
			for v69, v70 in t1.CurrentStatuses do
				for v71, v72 in v70 do
					v72.TimePast = v72.TimePast + dt

					if not v69.Parent or not v72.Character.Parent or v72.TimePast >= v72.TimeRequired then
						t1:RemoveStatus(v69, v71)
					elseif v72.Heartbeat then
						v72:Heartbeat(dt)
					end
				end
			end
		end)
	elseif RunService:IsClient() then
		local LocalPlayer = game.Players.LocalPlayer
		local clone = script.StatusContainer:Clone()

		clone.Parent = LocalPlayer.PlayerGui.MainUI
		t1.CurrentStatuses[LocalPlayer] = {}

		local v52 = t1.CurrentStatuses[LocalPlayer]

		local function onStatusApplied(s2: string, t5: {[any]: any}, t6: {[any]: any}) -- line: 298
			-- upvalues: v52 (copy), LocalPlayer (copy), StatusEffects (copy), Util (copy), clone (copy), t1 (copy)
			local Level = t5.Level
			local Duration = t6.Duration
			local Icon = t6.Icon
			local Hidden = t6.Hidden

			if v52[s2] then
				local v80 = v52[s2]

				v80.TimePast = 0
				v80.TimeRequired = Duration
				v80.Level = Level
				v80.CurrentTimeDisplay = 123456789

				if v80.Info.Applied then
					v80.Info:Applied()
				end
			else
				local t7 = {
					TimePast = 0,
					TimeRequired = Duration,
					Level = Level,
					Player = LocalPlayer,
					Character = LocalPlayer.Character,
					Data = t6
				}
				local s2_2 = StatusEffects:FindFirstChild(s2, true)
				local v83 = Util:CopyTable(require(s2_2))

				v83.__index = v83
				t7.Info = setmetatable(t7, v83)

				if t7.Info.Applied then
					t7.Info:Applied()
				end

				t7.UI = script.StatusDisplay:Clone()
				t7.UI.Name = s2
				t7.UI.Timer.Text = Util:FormatTime(math.round(t7.TimeRequired - t7.TimePast), "Clock")
				t7.UI.Title.Text = `{ s2 } { Util:IntToRoman(t7.Level) }`
				t7.UI.IconHolder.Icon.Image = Icon or ""
				t7.UI.Visible = not Hidden
				t7.UI.Parent = clone
				v52[s2] = t7
			end

			t1.StatusApplied:FireDeferred(LocalPlayer, s2, t6, false)
		end
		local function onStatusUpdated(s3: string, t8: {[any]: any}) -- line: 345
			-- upvalues: v52 (copy), Util (copy), t1 (copy), LocalPlayer (copy)
			local v86 = v52[s3]

			if not v86 or not v86.UI then
				return
			end

			v86.TimePast = t8.TimePast or 0
			v86.TimeRequired = t8.Duration or v86.TimeRequired
			v86.Level = t8.Level or v86.Level
			v86.CurrentTimeDisplay = 123456789
			v86.UI.Timer.Text = Util:FormatTime(v86.CurrentTimeDisplay, "Clock")
			v86.UI.Title.Text = `{ s3 } { Util:IntToRoman(v86.Level) }`

			if v86.Info.Applied then
				v86.Info:Applied()
			end

			t1.StatusApplied:FireDeferred(LocalPlayer, s3, t8, true)
		end
		local function onStatusRemoved(s4: string) -- line: 368
			-- upvalues: v52 (copy)
			local v88 = v52[s4]

			if v88 then
				if v88.Info.Removed then
					v88.Info:Removed()
				end

				v88.UI:Destroy()
				v52[s4] = nil
			end
		end
		local function update(n1: number) -- line: 378
			-- upvalues: v52 (copy), Util (copy)
			for k, v in pairs(v52) do
				v.TimePast = v.TimePast + n1

				if v.Info.Heartbeat then
					v.Info:Heartbeat(n1)
				end

				local v92 = math.ceil(v.TimeRequired - v.TimePast)

				if v92 ~= v.CurrentTimeDisplay then
					v.CurrentTimeDisplay = v92
					task.defer(function() -- line: 388
						-- upvalues: v (copy), Util (copy), k (copy)
						if not v.UI or not v.UI.Parent then
							return
						end

						v.UI.Timer.Text = Util:FormatTime(v.CurrentTimeDisplay, "Clock")
						v.UI.Title.Text = `{ k } { Util:IntToRoman(v.Level) }`
					end)
				end

				if v.TimePast >= v.TimeRequired then
					if v.Info.Removed then
						v.Info:Removed()
					end

					if v.UI and v.UI.Parent then
						v.UI:Destroy()
					end

					v52[k] = nil
				end
			end
		end
		local function reset() -- line: 410
			-- upvalues: v52 (copy)
			for k, _ in pairs(v52) do
				local v95 = v52[k]

				if v95 then
					if v95.Info.Removed then
						v95.Info:Removed()
					end

					v95.UI:Destroy()
					v52[k] = nil
				end
			end
		end

		Network:SetConnection("StatusApplied", "REMOTE_EVENT", onStatusApplied)
		Network:SetConnection("StatusUpdated", "REMOTE_EVENT", onStatusUpdated)
		Network:SetConnection("StatusRemoved", "REMOTE_EVENT", onStatusRemoved)
		RunService.Heartbeat:Connect(update)
		LocalPlayer.CharacterAdded:Connect(reset)
	end

	for _, descendant in ipairs(StatusEffects:GetDescendants()) do
		if descendant:IsA("ModuleScript") and not descendant:HasTag("CannotInit") then
			local lib = require(descendant)

			if lib.Init then
				lib:Init()
			end
		end
	end
end

t1.StatusApplied = Signal.new()

return t1

