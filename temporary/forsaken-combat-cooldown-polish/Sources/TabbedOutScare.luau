game:GetService("LocalizationService")

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Util = require(game.ReplicatedStorage.Modules.Util)
local Network = require(game.ReplicatedStorage.Modules.Network)
local t1 = {}
local t2 = {
	"you aren't alone here.",
	"do you call this your home?",
	"i decide when you can leave.",
	"don’t test my patience.",
	"i want to see your face.",
	"come back and play.",
	"you wouldn't dare defy me.",
	"don't turn around.",
	"the air is heavier out there, isn't it?",
	"i've been waiting for you.",
	"is this where it ends?",
	"do you hear that?",
	"i never left.",
	"if you leave, you won’t make it far.",
	"can you feel me watching?",
	"why did you lock the door?",
	"you brought this upon yourself.",
	"there's nowhere to hide.",
	"don't make me find you.",
	"leaving is not an option.",
	"you belong to me now.",
	"who else knows you're here?",
	"it's colder now, isn't it?",
	"you can't escape me."
}
local t3 = {
	Survivors = {
		"move.",
		"they're suffering because of you.",
		"your cowardice will cost lives.",
		"scared stiff as usual.",
		"don't be meek.",
		"vile submission.",
		"you're not that scared.",
		"given up already?",
		"they cry your name, yet nobody comes.",
		"i can feel you falling apart.",
		"it will come for you.",
		"fight. back.",
		"you won't be missed.",
		"nobody will mourn you."
	},
	Killers = {
		"you disgust me.",
		"i brought you here for a purpose.",
		"kill.",
		"play your role.",
		"i don't appreciate your morality.",
		"they won't remember you.",
		"don't have the guts?",
		"you're worthless.",
		"waste of purpose.",
		"they'll die either way.",
		"entertain me.",
		"i can see you."
	}
}

function t1.Start(_) -- line: 71
	-- upvalues: Util (copy), RunService (copy), UserInputService (copy), t3 (copy), t2 (copy), Network (copy)
	local u9 = false
	local n1 = 0
	local n2 = 0
	local n3 = 0
	local n4 = 0
	local n5 = 0
	local LocalPlayer = game.Players.LocalPlayer

	Util:GetLocalTranslator()

	local MainUI = LocalPlayer.PlayerGui:WaitForChild("MainUI")
	local clone = script.InsaneVignette:Clone()
	local clone2 = script.Warning:Clone()
	clone2.TextColor3 = Color3.fromRGB(255, 0, 0)

	clone.Parent = MainUI
	clone2.Parent = MainUI

	local function applyExponentialCurve(p2, p3) -- line: 99
		return p2 ^ (1 / (1 - p3 + 1E-05))
	end

	local n6 = 0

	local function randomCase(p4) -- line: 115
		local t4 = {}

		for i = 1, #p4 do
			local v30 = p4:sub(i, i)

			if math.random(0, 1) == 1 then
				table.insert(t4, v30:upper())
			else
				table.insert(t4, v30:lower())
			end
		end

		return table.concat(t4)
	end

	local t5 = {}

	RunService.RenderStepped:Connect(function(dt) -- line: 130
		-- upvalues: Util (copy), LocalPlayer (copy), UserInputService (copy), n5 (ref), n4 (ref), n1 (ref), u9 (ref), n2 (ref), clone (copy), t5 (copy), n6 (ref), t3 (copy), t2 (copy), clone2 (copy), Network (copy), n3 (ref), randomCase (copy)
		local SettingValue = Util:GetSettingValue("EpilepsyMode", game.Players.LocalPlayer)
		local Character = LocalPlayer.Character
		local v34 = Character and (not not Character.Parent and Character.Parent.Name) or ""

		if #UserInputService:GetKeysPressed() == 0 and (os.clock() - n5 > 1 and Util:IsAlive(Character)) and (v34 == "Killers" or v34 == "Survivors") then
			n4 += dt / 90
		else
			n4 -= dt / 0.125
		end

		n4 = math.clamp(n4, -0.05555555555555555, 1)

		local v35 = n1

		if not u9 and v35 <= 0 and n4 <= 0 then
			return
		end

		local v36 = u9 and dt / 120 or -dt / 0.125

		n1 = math.clamp(n1 + v36, 0, 1)

		if u9 then
			n2 += dt
		end

		local v37 = math.max(n4, n1) ^ 6.6662222518498755
		local v38 = v37 * 2

		clone.Position = UDim2.fromScale(0.5, 0.5) + UDim2.fromScale(math.random(-v38, v38) / 1000, math.random(-v38 * 2.5, v38 * 2.5) / 1000)
		clone.ImageTransparency = 1 - v37

		if not t5.TimeSinceMessageChange then
			t5.TimeSinceMessageChange = os.clock()
		end

		local s1

		if os.clock() >= t5.TimeSinceMessageChange + 2 then
			t5.TimeSinceMessageChange = os.clock()

			if n2 >= 300 and not t5.ScreamingForHelp then
				t5.TimeSinceMessageChange = os.clock() + 2
				t5.ScreamingForHelp = true
				s1 = "APieceForThePuzzle Awaits You"
			else
				n6 += 1

				local v40 = if not (n1 <= 0.01) or not t3[v34] then t2 else t3[v34]

				s1 = v40[n6 % #v40 + 1]
			end
		else
			s1 = clone2.Text
		end

		if n4 >= 0.999 and os.clock() - 0 > 7 then
			Network:FireServerConnection("AFKInsanity", "REMOTE_EVENT")
		end

		if s1 == "APieceForThePuzzle Awaits You" or SettingValue and os.clock() - n3 < 0.9 then
		else
			n3 = os.clock()
			s1 = randomCase((tostring(s1)))
		end

		clone2.Position = UDim2.fromScale(0.5, 0.5) + UDim2.fromScale(math.random(-v38, v38) / 1000, math.random(-v38 * 2.5, v38 * 2.5) / 1000)
		clone2.Text = s1
		clone2.TextTransparency = 1 - v37
		clone2.TextStrokeTransparency = 1 - v37 / 2
	end)
	UserInputService.WindowFocused:Connect(function() -- line: 199
		-- upvalues: u9 (ref), n2 (ref), t5 (copy)
		u9 = false
		n2 = 0
		t5.ScreamingForHelp = false
	end)
	UserInputService.WindowFocusReleased:Connect(function() -- line: 206
		-- upvalues: u9 (ref)
		u9 = true
	end)

	for _, v in ipairs({
		"TouchPan",
		"InputChanged",
		"InputBegan",
		"InputEnded",
		"TouchMoved",
		"TouchStarted",
		"TouchEnded"
	}) do
		UserInputService[v]:Connect(function() -- line: 213
			-- upvalues: n5 (ref)
			n5 = os.clock()
		end)
	end
end

return t1

