local t1 = {}
local DataHandler = require(game.ReplicatedStorage.Modules.DataHandler)
local Device = require(game.ReplicatedStorage.Modules.CombatMenuCompat.Device)

function t1.Start(_) -- line: 6
	-- upvalues: DataHandler (copy), t1 (copy), Device (copy)
	local LocalPlayer = game.Players.LocalPlayer
	local Settings = DataHandler:Get():WaitForChild("Settings")
	local Initializer = require(game.ReplicatedStorage.Initializer)

	Initializer.PlayerSettings = {}
	t1.SettingsMenu = Initializer.PlayerSystems.SidebarHandler:CreateSidebarMenu("Settings", script.SettingsScreen)

	local Contents = t1.SettingsMenu.Menu.SettingsContainer.Contents
	local Templates = script.Templates
	local SearchBox = Contents.SearchBoxBackground.SearchBox
	local s1 = ""
	local t2 = {}

	local function matchesSearch(...) -- line: 30
		-- upvalues: s1 (ref)
		if s1 == "" then
			return true
		end

		for _, v16 in { ... } do
			if v16 and string.lower(v16):find(s1, 1, true) then
				return true
			end
		end

		return false
	end
	local function createSettingsUI(p2, p3) -- line: 41
        if p2.Name=="MaliceDisabled"or p2.Name=="KillerChance"then return end
		-- upvalues: Device (copy), Templates (copy), s1 (ref), t2 (copy), Contents (copy), createSettingsUI (copy), matchesSearch (copy), Settings (copy), LocalPlayer (copy), Initializer (copy)
		if not p3 then
			p3 = 0
		end

		local LayoutOrder = p2:GetAttribute("LayoutOrder")
		local DisplayTitle = p2:GetAttribute("DisplayTitle")
		local DisplayDescription = p2:GetAttribute("DisplayDescription")

		p2:GetAttribute("PostDisplayTitle")

		if not LayoutOrder or not DisplayTitle then
			return
		end

		local v22 = p2:GetAttribute("DeviceRestriction") or p2.Parent:GetAttribute("DeviceRestriction")

		local function isDeviceAllowed() -- line: 52
			-- upvalues: v22 (copy), Device (copy)
			if not v22 or v22 == "" then
				return true
			end

			local PlayerDevice = Device:GetPlayerDevice()

			if not PlayerDevice then
				return true
			end

			for _, v in ipairs(v22:split(",")) do
				if PlayerDevice == v:match("^%s*(.-)%s*$") then
					return true
				end
			end

			return false
		end

		if p2:IsA("Folder") then
			local clone = Templates.Seperator:Clone()

			clone.Name = p2.Name
			clone.LayoutOrder = LayoutOrder * 100 + p3
			clone.Title.Text = DisplayTitle

			local function refreshVisibility() -- line: 79
				-- upvalues: clone (copy), isDeviceAllowed (copy), s1 (ref)
				clone.Visible = isDeviceAllowed() and s1 == ""
			end

			clone.Visible = isDeviceAllowed() and s1 == ""
			table.insert(t2, refreshVisibility)
			Device.Changed:Connect(refreshVisibility)
			clone.Parent = Contents

			for _, child in pairs(p2:GetChildren()) do
				createSettingsUI(child, LayoutOrder * 100)
			end

			return
		end

		if p2:IsA("ValueBase") then
			local v28 = Templates:FindFirstChild(p2:GetAttribute("TemplateType") or string.gsub(p2.ClassName, "Value", ""))
			local v29 = nil

			for _, child in pairs(Templates:GetChildren()) do
				if child:IsA("ModuleScript") and p2.Parent.Name:find(child.Name, 1, true) and (not v29 or #child.Name > #v29.Name) then
					v29 = child
				end
			end

			if v29 then
				v28 = v29
			end

			local v32 = v28 and require(v28)

			if v32 and v32.CreateSettingUI then
				local v33 = v32:CreateSettingUI(p2)

				v33.Instance.Name = p2.Name
				v33.Instance.LayoutOrder = LayoutOrder + p3

				local u34 = true

				local function refreshVisibility() -- line: 115
					-- upvalues: v33 (copy), isDeviceAllowed (copy), u34 (ref), matchesSearch (copy), DisplayTitle (copy), DisplayDescription (copy)
					v33.Instance.Visible = isDeviceAllowed() and (u34 and matchesSearch(DisplayTitle, DisplayDescription))
				end

				local Requirement = p2:GetAttribute("Requirement")

				if Requirement then
					local Requirement2 = Settings:FindFirstChild(Requirement, true)

					if Requirement2 then
						local function updateSettingVisibility() -- line: 124
							-- upvalues: u34 (ref), Requirement2 (copy), v33 (copy), isDeviceAllowed (copy), matchesSearch (copy), DisplayTitle (copy), DisplayDescription (copy)
							u34 = Requirement2.Value
							v33.Instance.Visible = isDeviceAllowed() and (u34 and matchesSearch(DisplayTitle, DisplayDescription))
						end

						u34 = Requirement2.Value
						v33.Instance.Visible = isDeviceAllowed() and (u34 and matchesSearch(DisplayTitle, DisplayDescription))
						Requirement2:GetPropertyChangedSignal("Value"):Connect(updateSettingVisibility)
					elseif Requirement == "VIP" then
						local function updateSettingVisibility() -- line: 129
							-- upvalues: u34 (ref), LocalPlayer (copy), v33 (copy), isDeviceAllowed (copy), matchesSearch (copy), DisplayTitle (copy), DisplayDescription (copy)
							u34 = LocalPlayer:GetAttribute("VIP") == true
							v33.Instance.Visible = isDeviceAllowed() and (u34 and matchesSearch(DisplayTitle, DisplayDescription))
						end

						u34 = LocalPlayer:GetAttribute("VIP") == true
						v33.Instance.Visible = isDeviceAllowed() and (u34 and matchesSearch(DisplayTitle, DisplayDescription))
						LocalPlayer:GetAttributeChangedSignal("VIP"):Connect(updateSettingVisibility)
					elseif Requirement:find("Device=") then
						local function updateSettingVisibility() -- line: 134
							-- upvalues: u34 (ref), Device (copy), Requirement (copy), v33 (copy), isDeviceAllowed (copy), matchesSearch (copy), DisplayTitle (copy), DisplayDescription (copy)
							u34 = `Device={ Device:GetPlayerDevice() }` == Requirement
							v33.Instance.Visible = isDeviceAllowed() and (u34 and matchesSearch(DisplayTitle, DisplayDescription))
						end

						u34 = Requirement == `Device={ Device:GetPlayerDevice() }`
						v33.Instance.Visible = isDeviceAllowed() and (u34 and matchesSearch(DisplayTitle, DisplayDescription))
						Device.Changed:Connect(updateSettingVisibility)
					elseif Requirement:find("UserId=") then
						local num = tonumber(string.split(Requirement, "=")[2])

						u34 = num ~= nil and num == LocalPlayer.UserId
					elseif Requirement:find("Rank=") then
						local n1 = 0

						pcall(function() -- line: 143
							-- upvalues: n1 (ref), LocalPlayer (copy)
							n1 = LocalPlayer:GetRankInGroup(33548380)
						end)
						u34 = (tonumber(string.split(Requirement, "=")[2]) or 255) <= n1
					end
				end

				v33.Instance.Visible = isDeviceAllowed() and (u34 and matchesSearch(DisplayTitle, DisplayDescription))
				table.insert(t2, refreshVisibility)
				Device.Changed:Connect(refreshVisibility)
				v33.Instance.Parent = Contents

				local Sounds = require(game.ReplicatedStorage.Modules.Sounds)
				local clone = Templates.Reset:Clone()

				clone.Parent = v33.Instance
				clone.MouseButton1Click:Connect(function() -- line: 159
					-- upvalues: p2 (copy), Sounds (copy)
					require(game.ReplicatedStorage.Modules.Network):FireServerConnection("UpdateSettings", "REMOTE_EVENT", p2)
					Sounds:Play("switch")
				end)
				clone.MouseEnter:Connect(function() -- line: 164
					-- upvalues: Sounds (copy)
					Sounds:Play("hover")
				end)
				clone.MouseLeave:Connect(function() -- line: 167
					-- upvalues: Sounds (copy)
					Sounds:Play("hoverEnd")
				end)

				local SettingName = v33.Instance:FindFirstChild("SettingName", true)
				local SettingDesc = v33.Instance:FindFirstChild("SettingDesc", true)

				SettingName.Text = DisplayTitle
				SettingDesc.Text = DisplayDescription
				v33.__updatedEvent = Instance.new("BindableEvent")
				v33.__updatedEvent.Parent = v33.Instance
				v33.Updated = v33.__updatedEvent.Event

				local v47 = script.SettingConnections:FindFirstChild(p2.Name) or script.SettingConnections:FindFirstChild(p2.Name:gsub("~Console$", "Console"))
				local v48 = v47 and require(v47)

				if v48 then
					v33.Updated:Connect(function() -- line: 187
						-- upvalues: v48 (copy), v33 (copy)
						v48:Updated(v33.Value)
					end)
				end

				local function updateSettingsUI() -- line: 193
					-- upvalues: v33 (copy), p2 (copy)
					v33.Value = p2.Value

					if v33.OnUpdate then
						v33:OnUpdate()
					end

					v33.__updatedEvent:Fire()
				end

				v33.Value = p2.Value

				if v33.OnUpdate then
					v33:OnUpdate()
				end

				v33.__updatedEvent:Fire()
				p2:GetPropertyChangedSignal("Value"):Connect(updateSettingsUI)
				Initializer.PlayerSettings[p2.Name] = v33
				task.wait()
			end
		end
	end

	SearchBox:GetPropertyChangedSignal("Text"):Connect(function() -- line: 216
		-- upvalues: s1 (ref), SearchBox (copy), t2 (copy)
		s1 = string.lower(SearchBox.Text):match("^%s*(.-)%s*$")

		for _, v51 in t2 do
			v51()
		end
	end)
	task.spawn(function() -- line: 224
		-- upvalues: Settings (copy), createSettingsUI (copy)
		for _, child in pairs(Settings:GetChildren()) do
			createSettingsUI(child)
		end
	end)
end

return t1
