local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Network = require(ReplicatedStorage.Modules.Network)
local Signal = require(ReplicatedStorage.Modules.Misc.Signal)
local delay = task.delay
local tweenInfo = TweenInfo.new(0.5)
local color3 = Color3.fromRGB(141, 0, 0)
local color3_2 = Color3.fromRGB(255, 255, 255)
local t1 = {
	["Ingame timer disabled"] = "TIMER_DISABLED",
	["Round ends in:"] = "ROUND_ENDS_IN",
	["Round begins in:"] = "ROUND_BEGINS_IN",
	["Waiting for more players."] = "WAITING_FOR_PLAYERS"
}

return {
	onRoundTimerUpdated = Signal.new(),
	Start = function(p1) -- line: 31
		-- upvalues: t1 (copy), Network (copy), TweenService (copy), tweenInfo (copy), color3 (copy), delay (copy), color3_2 (copy)
		local LocalPlayer = game.Players.LocalPlayer
		local clone = script.RoundTimer:Clone()
		local Main = clone.Main

		clone.Parent = LocalPlayer.PlayerGui

		local RoundTimer = game.ReplicatedStorage:WaitForChild("RoundTimer")

		local function updateTime() -- line: 43
			-- upvalues: Main (copy), RoundTimer (copy), p1 (copy), t1 (copy)
			local Time = Main.Time
			local MainTitle = Main.Title
			local RoundTimerValue = RoundTimer.Value

			if RoundTimer:GetAttribute("EndlessCombat")then
                MainTitle.TextColor3=Color3.fromRGB(255,255,255)
                Time.TextColor3=Color3.fromRGB(255,255,255)
                MainTitle.Text="Battle Till' Death!"
                Time.Text="Fight"
                p1.onRoundTimerUpdated:Fire("ENDLESS_COMBAT",5999)
                return
            end
			if workspace:GetAttribute("BloodHuntActive") then
				MainTitle.TextColor3 = Color3.fromRGB(255, 0, 0)
				Time.TextColor3 = Color3.fromRGB(255, 0, 0)
				MainTitle.Text = "RUN"
				Time.Text = "HI:DE"

				return
			end

			MainTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
			Time.TextColor3 = Color3.fromRGB(255, 255, 255)

			local v22 = RoundTimer:GetAttribute("TimeLeft") or 0
			local v23 = string.format("%i:%02i", v22 / 60, v22 % 60)

			MainTitle.Text = RoundTimerValue and RoundTimerValue or ""
			Time.Text = v23
			p1.onRoundTimerUpdated:Fire(t1[RoundTimerValue] or RoundTimerValue, v22)
		end

		updateTime()
		RoundTimer:GetPropertyChangedSignal("Value"):Connect(updateTime)
		RoundTimer:GetAttributeChangedSignal("TimeLeft"):Connect(updateTime)
		RoundTimer:GetAttributeChangedSignal("EndlessCombat"):Connect(updateTime)
		workspace:GetAttributeChangedSignal("BloodHuntActive"):Connect(updateTime)

		local u16 = nil
		local u17 = nil

		Network:SetConnection("EnlargeRoundTimerAsync", "REMOTE_EVENT", function(n1: number)
            if RoundTimer:GetAttribute("EndlessCombat")then return end -- line: 77
			-- upvalues: u16 (ref), u17 (ref), TweenService (copy), Main (copy), tweenInfo (copy), color3 (copy), delay (copy), color3_2 (copy)
			if u16 then
				u16:Cancel()
				pcall(coroutine.close, u17)
				u16 = nil
			end

			u16 = TweenService:Create(Main.Time, tweenInfo, {
				TextColor3 = color3
			})
			u16:Play()
			u17 = delay(n1, function() -- line: 86
				-- upvalues: u16 (ref), TweenService (copy), Main (copy), tweenInfo (copy), color3_2 (copy)
				u16 = TweenService:Create(Main.Time, tweenInfo, {
					TextColor3 = color3_2
				})
				u16:Play()
			end)
		end)

		local MainUI = LocalPlayer.PlayerGui:WaitForChild("MainUI")

		MainUI:GetPropertyChangedSignal("Enabled"):Connect(function() -- line: 93
			-- upvalues: clone (copy), MainUI (copy)
			clone.Enabled = MainUI.Enabled
		end)
	end
}

