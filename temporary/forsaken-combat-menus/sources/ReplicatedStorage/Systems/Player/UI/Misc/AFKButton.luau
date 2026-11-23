local t1 = {}
local TweenService = game:GetService("TweenService")
local DataHandler = require(game.ReplicatedStorage.Modules.DataHandler)
local Network = require(game.ReplicatedStorage.Modules.Network)
local Sounds = require(game.ReplicatedStorage.Modules.Sounds)
local tweenInfo = TweenInfo.new(0.25)
local color3 = Color3.fromRGB(255, 40, 40)
local color3_2 = Color3.fromRGB(255, 255, 255)

function t1.Start(_) -- line: 25
	-- upvalues: DataHandler (copy), TweenService (copy), tweenInfo (copy), color3 (copy), color3_2 (copy), Sounds (copy), Network (copy)
	task.spawn(function() -- line: 26
		-- upvalues: DataHandler (copy), TweenService (copy), tweenInfo (copy), color3 (copy), color3_2 (copy), Sounds (copy), Network (copy)
		local v10 = DataHandler:Get()
		local v11 = v10 and v10:WaitForChild("Settings"):FindFirstChild("AFK", true)

		if not v11 then
			warn(`[{ script }]: AFK setting not found, button disabled.`)

			return
		end

		local Initializer = require(game.ReplicatedStorage.Initializer)
		local n1 = 0
		local v16

		repeat
			local v14 = Initializer.PlayerSystems and Initializer.PlayerSystems.SidebarHandler
			local v15 = v14 and (v14.SidebarButtons and v14.SidebarButtons.AFK)

			v16 = v15 and v15.Instance

			if not v16 then
				local Sidebar = game.Players.LocalPlayer.PlayerGui:FindFirstChild("Sidebar", true)
				local v18 = Sidebar and Sidebar:FindFirstChild("Bottom", true)

				v16 = v18 and v18:FindFirstChild("AFK")
			end

			if v16 then
				break
			end

			n1 += task.wait(0.1)
		until n1 >= 15

		if not v16 then
			warn(`[{ script }]: No sidebar button named 'AFK' found after { 15 }s.`)

			return
		end

		local Icon = v16:FindFirstChild("Icon", true)

		if not Icon then
			warn(`[{ script }]: No ImageLabel named 'Icon' inside 'AFK', colour won't change.`)
		end

		local function refresh() -- line: 61
			-- upvalues: Icon (copy), TweenService (copy), tweenInfo (copy), v11 (copy), color3 (copy), color3_2 (copy)
			if not Icon then
				return
			end

			TweenService:Create(Icon, tweenInfo, {
				ImageColor3 = v11.Value and color3 or color3_2
			}):Play()
		end

		if Icon then
			TweenService:Create(Icon, tweenInfo, {
				ImageColor3 = v11.Value and color3 or color3_2
			}):Play()
		end

		v11:GetPropertyChangedSignal("Value"):Connect(refresh)

		local u21 = false

		local function toggle() -- line: 69
			-- upvalues: u21 (ref), Sounds (copy), Network (copy), v11 (copy)
			if u21 then
				return
			end

			u21 = true
			task.delay(0.25, function() -- line: 72
				-- upvalues: u21 (ref)
				u21 = false
			end)
			Sounds:Play("switch")
			Network:FireServerConnection("UpdateSettings", "REMOTE_EVENT", v11, not v11.Value)
		end

		local n2 = 0

		for _, descendant in ipairs(v16:GetDescendants()) do
			if descendant:IsA("GuiButton") then
				descendant.Activated:Connect(toggle)
				n2 += 1
			end
		end

		if v16:IsA("GuiButton") then
			v16.Activated:Connect(toggle)

			local _ = n2 + 1
		end
	end)
end

return t1
