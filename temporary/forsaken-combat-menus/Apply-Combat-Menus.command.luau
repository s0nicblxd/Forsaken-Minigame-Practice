assert(game:GetService("RunService"):IsStudio()and not game:GetService("RunService"):IsRunning(),"Stop Play before porting menus.")
local function find(path)
 local object=game
 for part in path:gmatch("[^/]+")do object=object and object:FindFirstChild(part)end
 return object
end
local function fingerprint(source)
 local a,b=5381,0
 for i=1,#source do local value=source:byte(i);a=(a*33+value)%4294967296;b=(b*65599+value)%4294967296 end
 return string.format("%d:%08x:%08x",#source,a,b)
end
local storage=game:GetService("ServerStorage")
local stamp=find("ReplicatedStorage/Modules/CombatMenuCompat")
if stamp then assert(stamp:GetAttribute("Version")=="1.0.0","Existing CombatMenuCompat is unknown. Nothing changed.");assert(find("ReplicatedStorage/Systems/Character/Game/PlayerInfoDisplay")and fingerprint(find("ReplicatedStorage/Systems/Character/Game/PlayerInfoDisplay").Source)=="21045:dbf57087:e344403c","Run Repair-PlayerInfoDisplay.command.luau for the earlier menu installation.");print("[Combat menus] Already installed.");return end
local selection=game:GetService("Selection"):Get()
local bundle=storage:FindFirstChild("CombatMenusPort")
if not bundle and #selection==1 and selection[1].Name=="CombatMenusPort"then bundle=selection[1]end
assert(bundle and bundle:IsA("Folder"),"Import CombatMenusPort.rbxm into ServerStorage first, then run this installer.")
local function donor(path)
 local object=bundle
 for name in path:gmatch("[^/]+")do object=object and object:FindFirstChild(name)end
 return object
end
local expectedSources={
[ [========[
SidebarHandler]========] ]="6878:32b70458:2c79025f",
[ [========[
SidebarHandler/Classes/Button]========] ]="3751:def28c9e:81535743",
[ [========[
SidebarHandler/Classes/CurrencyDisplay]========] ]="3656:a2782b25:c4461324",
[ [========[
Misc/AFKButton]========] ]="2978:ee556958:8bbba979",
[ [========[
Menus/Inventory]========] ]="36183:f020c552:0823004b",
[ [========[
Menus/Inventory/Tabs/Emotes]========] ]="6135:a01dadae:ccc5098b",
[ [========[
Menus/Inventory/Tabs/Killers]========] ]="9422:0230cf4a:1542cba5",
[ [========[
Menus/Inventory/Tabs/Survivors]========] ]="9464:bd5798db:c2cb7c80",
[ [========[
Menus/Inventory/OldTabs/Killers [OLD]]========] ]="3557:84673be0:344b6e91",
[ [========[
Menus/Inventory/OldTabs/Survivors [OLD]]========] ]="3578:ac50a22e:071350dd",
[ [========[
Menus/Inventory/RandomizerTabs/Survivors]========] ]="7819:0b9882fd:b64d84ea",
[ [========[
Menus/Inventory/RandomizerTabs/Killers]========] ]="7793:735a1c14:e256e19d",
[ [========[
Menus/Inventory/RandomizerTabs/Emotes]========] ]="6135:a01dadae:ccc5098b",
[ [========[
Menus/Rules]========] ]="2359:92b4b1cb:91022ca6",
[ [========[
Menus/Achievements]========] ]="7368:ca522573:02df56ea",
[ [========[
Menus/Settings]========] ]="8698:31880f7f:7710cc04",
[ [========[
Menus/Settings/Templates/Textbox]========] ]="1154:ae62cc46:99db39b1",
[ [========[
Menus/Settings/Templates/String]========] ]="2113:0967d407:4c7f7bd8",
[ [========[
Menus/Settings/Templates/Number]========] ]="3563:115d77ff:a0a9d772",
[ [========[
Menus/Settings/Templates/Bool]========] ]="938:fbc76c07:c08daf34",
[ [========[
Menus/Settings/Templates/Keybind]========] ]="3581:a4f4f331:b3cf1262",
[ [========[
Menus/Stats]========] ]="2056:3bca5dbc:2b14a495",
[ [========[
Menus/Shop]========] ]="42791:98fd39f2:15e4f8c3",
[ [========[
Menus/Shop/Types]========] ]="10:45739627:24aacc18",
[ [========[
Menus/Shop/Tabs/Emotes]========] ]="7106:dd9b18c7:eedd9082",
[ [========[
Menus/Shop/Tabs/Skins]========] ]="16098:ef8cf01d:bb4c1a4c",
[ [========[
Menus/Shop/Classes/RigBuilder]========] ]="8455:5b6718af:e9b193de",
[ [========[
Menus/UpdateLog]========] ]="9293:7022bf0f:f3469a9c",
[ [========[
Menus/UpdateLog/DiscordMarkdown]========] ]="44707:95248ba7:57a9407e",
}
for path,hash in expectedSources do
 local module=donor(path)
 assert(module and module:IsA("ModuleScript")and fingerprint(module.Source)==hash,"Missing/edited donor Source: "..path..". Nothing changed.")
end
local plans={
{donor=[========[
SidebarHandler]========],path=[========[
ReplicatedStorage/Systems/Player/UI/SidebarHandler]========],expected="6689:25556c40:5a8e6ea7"},
{donor=[========[
Menus/Shop]========],path=[========[
ReplicatedStorage/Systems/Player/UI/Menus/Shop]========],expected="41585:c8208d72:11de29e1"},
{donor=[========[
Menus/Inventory]========],path=[========[
ReplicatedStorage/Systems/Player/UI/Menus/Inventory]========],expected="32357:57c57849:9dec580e"},
{donor=[========[
Menus/Settings]========],path=[========[
ReplicatedStorage/Systems/Player/UI/Menus/Settings]========],expected="5509:e8c10111:6bfe0d68"},
{donor=[========[
Menus/Stats]========],path=[========[
ReplicatedStorage/Systems/Player/UI/Menus/Stats]========],expected="2057:b5161546:3ea980b5"},
{donor=[========[
Menus/Achievements]========],path=[========[
ReplicatedStorage/Systems/Player/UI/Menus/Achievements]========],expected="7369:1496d3dd:0be063a0"},
{donor=[========[
Menus/Rules]========],path=[========[
ReplicatedStorage/Systems/Player/UI/Menus/Rules]========],expected="2407:4ede1938:df2b2bcb"},
{donor=[========[
Menus/UpdateLog]========],path=[========[
ReplicatedStorage/Systems/Player/UI/Menus/UpdateLog]========],expected=false},
{donor=[========[
Misc/AFKButton]========],path=[========[
ReplicatedStorage/Systems/Player/UI/Misc/AFKButton]========],expected=false},
{donor=[========[
UpdatelogPresets]========],path=[========[
ReplicatedStorage/Assets/UI/UpdatelogPresets]========],expected=false},
}
local archived={}
for _,plan in plans do
 local source=assert(donor(plan.donor),"Donor tree missing: "..plan.donor)
 local parent=assert(find(plan.path:match("^(.*)/[^/]+$")),"Destination parent missing: "..plan.path)
 local name=plan.path:match("[^/]+$")
 local old=parent:FindFirstChild(name)
 if plan.expected then assert(old and old:IsA("ModuleScript")and fingerprint(old.Source)==plan.expected,"Edited/missing current menu: "..plan.path..". Nothing changed.")
 elseif old and old:IsA("ModuleScript")then error("Unexpected current module: "..plan.path..". Nothing changed.")end
 local candidate=source:Clone();candidate.Name=name
 if name=="Settings"then
  local oldConnections=assert(old:FindFirstChild("SettingConnections"),"Existing Settings connections missing")
  local importedConnections=candidate:FindFirstChild("SettingConnections");if importedConnections then importedConnections:Destroy()end
  oldConnections:Clone().Parent=candidate
 end
 for _,object in candidate:GetDescendants()do
  if object:GetAttribute("__ButtonInitialized")~=nil then object:SetAttribute("__ButtonInitialized",nil)end
  if object.Name=="Favorite"and object:IsA("GuiObject")then object.Visible=false;object.Active=false end
 end
 table.insert(archived,{old=old,parent=parent,name=name,candidate=candidate,path=plan.path})
end
local legacyPlans={
{path=[========[
ReplicatedStorage/Systems/Player/UI/Misc/UpdateLog]========],expected="3451:2df3e134:063581f3"},
{path=[========[
ReplicatedStorage/Systems/Player/UI/Menus/ServerList]========],expected="7394:eef92a9e:b7bdbe2f"},
{path=[========[
ReplicatedStorage/Systems/Player/UI/Menus/Boombox]========],expected=false},
{path=[========[
ReplicatedStorage/Systems/Player/UI/Menus/Forsakenween]========],expected=false},
}
for _,plan in legacyPlans do
 local object=find(plan.path)
 if object then
  assert(plan.expected and object:IsA("ModuleScript")and fingerprint(object.Source)==plan.expected,"Legacy menu has edits: "..plan.path..". Nothing changed.")
  table.insert(archived,{old=object,parent=object.Parent,name=object.Name,path=plan.path})
 end
end
local spectating=assert(find("ReplicatedStorage/Modules/Spectating"),"Spectating module missing")
assert(fingerprint(spectating.Source)=="10068:7adc2337:07271fb8","Spectating differs from the supplied build. Nothing changed.")
local spectatingAfter=[========[
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Sounds = require(ReplicatedStorage.Modules.Sounds)

require(ReplicatedStorage.Initializer)

local Network = require(ReplicatedStorage.Modules.Network)
local SidebarHandler = require(ReplicatedStorage.Systems.Player.UI.SidebarHandler)
local Device = require(ReplicatedStorage.Modules.Device)
local tweenInfo = TweenInfo.new(0.25)
local _ = ReplicatedStorage.Assets.Sounds.SFX.Menu
local t1 = {
	CurrentIndx = 1,
	CurrentHumanoid = nil,
	Spectating = false,
	Connections = {
		HealthConnection = nil,
		DeathConnection = nil
	}
}

local function changeProp(p1, p2, p3) -- line: 38
	if p3 ~= p1[p2] then
		p1[p2] = p3
	end
end

function t1.Toggle(_, p5) -- line: 44
	-- upvalues: SidebarHandler (copy), t1 (copy), RunService (copy)
	workspace:FindFirstChild("Ragdolls")

	local LocalPlayer = game.Players.LocalPlayer
	local Character = LocalPlayer.Character
	local v20 = Character and Character:FindFirstChild("Humanoid")
	local _ = SidebarHandler.Sidebar.Middle.Spectate

	if not v20 then
		return
	end

	if LocalPlayer.Character.Parent ~= workspace.Players.Spectating then
		p5 = false
	end

	if not p5 then
		for v22, v23 in t1.Connections do
			pcall(function() -- line: 61
				-- upvalues: v23 (copy), RunService (copy), v22 (copy)
				v23:Disconnect()

				if RunService:IsStudio() then
					warn(`[{ script:GetFullName() }]: Removed event: { v22 } from Spectating.`)
				end
			end)
			t1.Connections[v22] = nil
		end
	end

	t1.UI.Visible = p5
	workspace.CurrentCamera.CameraSubject = v20

	local Spectate = SidebarHandler.SidebarButtons.Spectate

	if Spectate then
		Spectate:SetAppearanceState(p5)
	end

	t1.Spectating = p5
end
function t1.Start(_) -- line: 83
	-- upvalues: RunService (copy), t1 (copy), Network (copy), Device (copy), Sounds (copy), TweenService (copy), tweenInfo (copy), UserInputService (copy), SidebarHandler (copy)
	if RunService:IsClient() then
		local LocalPlayer = game.Players.LocalPlayer

		t1.UI = script.Spectate:Clone()
		t1.UI.Visible = false
		t1.UI.Parent = LocalPlayer.PlayerGui:WaitForChild("MainUI")

		local function fuckOff() -- line: 92
			-- upvalues: Network (copy)
			Network:FireServerConnection("UpdateHeartbeatAsync", "REMOTE_EVENT", 53643)
		end
		local function playerAdded(p7) -- line: 96
			-- upvalues: Network (copy)
			local t2 = {
				"Name",
				"DisplayName",
				"UserId"
			}

			p7.Changed:Connect(function(property) -- line: 99
				-- upvalues: t2 (copy), Network (copy)
				if table.find(t2, property) then
					Network:FireServerConnection("UpdateHeartbeatAsync", "REMOTE_EVENT", 53643)
				end
			end)
		end
		local function adjustSpectatorIndex(n1: number) -- line: 107
			-- upvalues: LocalPlayer (copy), t1 (copy), adjustSpectatorIndex (copy)
			if LocalPlayer.Character.Parent ~= workspace.Players.Spectating then
				return
			end

			local v41 = t1

			v41.CurrentIndx = v41.CurrentIndx + n1

			local t3 = {}

			local function addToSpectatorTable(p8) -- line: 116
				-- upvalues: t3 (copy)
				local Humanoid = p8:FindFirstChild("Humanoid")

				if Humanoid and (Humanoid.Parent and Humanoid.Health > 0) then
					table.insert(t3, p8)
				end
			end
			local function updateHealth(p9) -- line: 123
				-- upvalues: t1 (copy)
				if not p9 then
					return
				end

				local v79 = p9.Health / p9.MaxHealth

				t1.UI.Health.Text = `{ math.round(v79 * 100) }%`
				t1.UI.Health.TextColor3 = Color3.fromHSV(v79 / 3, 1, 1)
			end
			local function setHealthConnection(p10) -- line: 131
				-- upvalues: t1 (copy), adjustSpectatorIndex (copy)
				pcall(function() -- line: 133
					-- upvalues: t1 (copy)
					t1.Connections.HealthConnection:Disconnect()
				end)
				pcall(function() -- line: 134
					-- upvalues: t1 (copy)
					t1.Connections.DeathConnection:Disconnect()
				end)
				pcall(function() -- line: 135
					-- upvalues: t1 (copy)
					t1.Connections.GoneConnection:Disconnect()
				end)

				local _ = p10.Parent

				if p10.Health > 0 then
					t1.Connections.DeathConnection = p10.Died:Once(function() -- line: 140
						-- upvalues: t1 (copy), p10 (copy), adjustSpectatorIndex (copy)
						task.delay(3, function() -- line: 141
							-- upvalues: t1 (copy), p10 (copy), adjustSpectatorIndex (copy)
							if t1.CurrentHumanoid == p10 and t1.UI.Visible then
								adjustSpectatorIndex(1)
							end
						end)
					end)
					t1.Connections.GoneConnection = p10.AncestryChanged:Once(function(_, _) -- line: 147
						-- upvalues: adjustSpectatorIndex (copy)
						adjustSpectatorIndex(1)
					end)
				end

				t1.Connections.HealthConnection = p10:GetPropertyChangedSignal("Health"):Connect(function() -- line: 152
					-- upvalues: p10 (copy), t1 (copy)
					local v84 = p10

					if not v84 then
						return
					end

					local v85 = v84.Health / v84.MaxHealth

					t1.UI.Health.Text = `{ math.round(v85 * 100) }%`
					t1.UI.Health.TextColor3 = Color3.fromHSV(v85 / 3, 1, 1)
				end)
			end

			for _, child in pairs(workspace.Players.Killers:GetChildren()) do
				local Humanoid = child:FindFirstChild("Humanoid")

				if Humanoid and Humanoid.Parent and Humanoid.Health > 0 then
					table.insert(t3, child)
				end
			end

			for _, child in pairs(workspace.Players.Survivors:GetChildren()) do
				local Humanoid = child:FindFirstChild("Humanoid")

				if Humanoid and Humanoid.Parent and Humanoid.Health > 0 then
					table.insert(t3, child)
				end
			end

			local v52 = t3[t1.CurrentIndx % #t3 + 1]
			local v53 = v52 and v52:FindFirstChild("Humanoid")

			if v53 then
				t1.CurrentHumanoid = v53

				local v54 = v52:GetAttribute("Username") or v52.Name
				local v55 = v52:GetAttribute("ActorDisplayName") or v52.Name
				local SkinNameDisplay = v52:GetAttribute("SkinNameDisplay")
				local v57 = `{ v55 } { SkinNameDisplay ~= nil and (SkinNameDisplay ~= "" and `({ SkinNameDisplay })`) or "" }`

				t1.UI.Username.Text = v54
				t1.UI.ActorName.Text = v57

				if t1.UI.Visible then
					workspace.CurrentCamera.CameraSubject = v53
				end

				if v53 then
					local v58 = v53.Health / v53.MaxHealth

					t1.UI.Health.Text = `{ math.round(v58 * 100) }%`
					t1.UI.Health.TextColor3 = Color3.fromHSV(v58 / 3, 1, 1)
				end

				setHealthConnection(v53)
			end
		end

		local PlayerDevice = Device:GetPlayerDevice()
		local t4 = {}
		local t5 = {
			Console = {
				[Enum.KeyCode.DPadLeft] = -1,
				[Enum.KeyCode.DPadRight] = 1
			},
			PC = {
				[Enum.KeyCode.Q] = -1,
				[Enum.KeyCode.E] = 1
			}
		}

		local function __checkBind(p13) -- line: 208
			-- upvalues: t4 (copy), PlayerDevice (ref)
			local v60 = t4[p13.Name]

			if v60 then
				v60.Visible = false
				t4[p13.Name] = nil
			end

			local v61 = p13:FindFirstChild(`{ PlayerDevice }Keybind`)

			if v61 then
				t4[p13.Name] = v61
				v61.Visible = true
			end
		end

		for v34, v35 in {
			t1.UI.Next,
			t1.UI.Back
		} do
			local v36 = t4[v35.Name]

			if v36 then
				v36.Visible = false
				t4[v35.Name] = nil
			end

			local v37 = v35:FindFirstChild(`{ PlayerDevice }Keybind`)

			if v37 then
				t4[v35.Name] = v37
				v37.Visible = true
			end

			Device.Changed:Connect(function(property: string) -- line: 224
				-- upvalues: PlayerDevice (ref), v35 (copy), t4 (copy)
				PlayerDevice = property

				local v63 = v35
				local v64 = t4[v63.Name]

				if v64 then
					v64.Visible = false
					t4[v63.Name] = nil
				end

				local v65 = v63:FindFirstChild(`{ PlayerDevice }Keybind`)

				if v65 then
					t4[v63.Name] = v65
					v65.Visible = true
				end
			end)
			v35.MouseButton1Click:Connect(function() -- line: 229
				-- upvalues: Sounds (copy), adjustSpectatorIndex (copy), v34 (copy)
				Sounds:Play("rbxassetid://112519459573278")
				adjustSpectatorIndex(v34 ~= 1 and -1 or 1)
			end)
			v35.MouseEnter:Connect(function() -- line: 234
				-- upvalues: Sounds (copy), TweenService (copy), v35 (copy), tweenInfo (copy)
				Sounds:Play("tick")
				TweenService:Create(v35, tweenInfo, {
					Size = UDim2.fromScale(0.25, 1.05)
				}):Play()
			end)
			v35.MouseLeave:Connect(function() -- line: 239
				-- upvalues: Sounds (copy), TweenService (copy), v35 (copy), tweenInfo (copy)
				Sounds:Play("tick")
				TweenService:Create(v35, tweenInfo, {
					Size = UDim2.fromScale(0.2, 1)
				}):Play()
			end)
		end

		UserInputService.InputBegan:Connect(function(input, gameProcessed: boolean) -- line: 245
			-- upvalues: t1 (copy), t5 (copy), PlayerDevice (ref), Sounds (copy), adjustSpectatorIndex (copy)
			if gameProcessed then
				return
			end

			if not t1.Spectating then
				return
			end

			local v68 = t5[PlayerDevice]
			local v69 = v68 and v68[input.KeyCode]

			if v69 then
				Sounds:Play("rbxassetid://112519459573278")
				adjustSpectatorIndex(v69)
			end
		end)
		SidebarHandler.Sidebar.Middle.Spectate.Button.MouseButton1Click:Connect(function() -- line: 267
			-- upvalues: SidebarHandler (copy), Sounds (copy), t1 (copy), adjustSpectatorIndex (copy)
			if SidebarHandler.MenusHidden then
				return
			end

			Sounds:Play("select")
			t1:Toggle(not t1.Spectating)

			if not t1.Spectating == false then
				adjustSpectatorIndex(0)
			end
		end)
		t1.UI.Username.Changed:Connect(function(property) -- line: 280
			-- upvalues: t1 (copy), Network (copy)
			if property ~= "Text" then
				return
			end

			local UsernameText = t1.UI.Username.Text
			local v72 = t1.CurrentHumanoid and t1.CurrentHumanoid.Parent
			local v73 = v72 and v72:GetAttribute("Username")
			local v74 = v72 and game.Players:GetPlayerFromCharacter(v72)

			if not v72 then
				return
			end

			if v74 and v73 then
				if v73 ~= UsernameText then
					Network:FireServerConnection("UpdateHeartbeatAsync", "REMOTE_EVENT", 53643)

					return
				end
			elseif v74 and not v73 then
				Network:FireServerConnection("UpdateHeartbeatAsync", "REMOTE_EVENT", 53643)
			end
		end)
		game.Players.PlayerAdded:Connect(playerAdded)
	end
end

return t1

]========]
local hud=assert(find("ReplicatedStorage/Systems/Character/Game/PlayerInfoDisplay"),"PlayerInfoDisplay missing")
assert(fingerprint(hud.Source)=="20938:9e4563a6:898e7783"or fingerprint(hud.Source)=="21045:dbf57087:e344403c","HUD has local edits. Nothing changed.")
local hudAfter=[========[
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

]========]
local helpers=Instance.new("Folder");helpers.Name="CombatMenuCompat";helpers:SetAttribute("Version","1.0.0");helpers:SetAttribute("NoInitializing",true)
do local module=Instance.new("ModuleScript");module.Name="Device";module.Source=[========[
local Original=require(game.ReplicatedStorage.Modules.Device)
local t1=setmetatable({},{__index=Original})
local t4 = {
	MouseButton1 = true,
	MouseButton2 = true,
	MouseButton3 = true
}
local t5 = {
	"^Button",
	"^DPad",
	"^Thumbstick"
}

function t1.GetKeybindDevice(_: {[any]: any}, s1: string) -- line: 56
	-- upvalues: t4 (copy), t5 (copy)
	if typeof(s1) ~= "string" then
		return nil
	end

	if t4[s1] then
		return "PC"
	end

	local ok, result = pcall(function() -- line: 61
		-- upvalues: s1 (copy)
		return Enum.KeyCode[s1]
	end)

	if not ok or typeof(result) ~= "EnumItem" or s1 ~= result.Name or result == Enum.KeyCode.Unknown or s1 == "None" then
		return nil
	end

	for _, v16 in t5 do
		if s1:find(v16) then
			return "Console"
		end
	end

	return "PC"
end
function t1.IsKeybindAllowed(_: {[any]: any}, s2: string, s3: string) -- line: 79
	-- upvalues: t1 (copy)
	local v20 = s2:find("Console$") ~= nil

	return t1:GetKeybindDevice(s3) == (not v20 and "PC" or "Console")
end

return t1
]========];module.Parent=helpers end
do local module=Instance.new("ModuleScript");module.Name="ShopSale";module.Source=[========[
local Sale={}
function Sale.GetAssetPrice(_,config)
 local price=config.Price or 0
 return {IsDiscounted=false,OriginalPrice=price,FinalPrice=price}
end
function Sale.GetPrice(_,_,config)return Sale.GetAssetPrice(nil,config)end
function Sale.GetNextChangeTime()return nil end
function Sale.IsActive()return false end
return Sale
]========];module.Parent=helpers end
local backup=Instance.new("Folder")
local prefix="CombatMenus_Backup_"..os.date("!%Y%m%d_%H%M%S");local index=0
while storage:FindFirstChild(prefix.."_"..index)do index+=1 end
backup.Name=prefix.."_"..index
local function reference(parent,name,value)local object=Instance.new("ObjectValue");object.Name=name;object.Value=value;object.Parent=parent end
for i,item in archived do
 local record=Instance.new("Folder");record.Name="Tree_"..i
 record:SetAttribute("ObjectName",item.name);record:SetAttribute("Path",item.path)
 reference(record,"OriginalParent",item.parent)
 if item.old then reference(record,"Original",item.old)end
 if item.candidate then reference(record,"Installed",item.candidate)end
 record.Parent=backup;item.record=record
end
local oldSpectating=Instance.new("StringValue");oldSpectating.Name="BeforeSpectating";oldSpectating.Value=spectating.Source;oldSpectating.Parent=backup
backup:SetAttribute("InstalledSpectating",fingerprint(spectatingAfter))
reference(backup,"Spectating",spectating);reference(backup,"Helpers",helpers)
reference(backup,"HUD",hud)
local oldHUD=Instance.new("StringValue");oldHUD.Name="BeforeHUD";oldHUD.Value=hud.Source;oldHUD.Parent=backup
backup:SetAttribute("InstalledHUD",fingerprint(hudAfter))
backup.Parent=storage
local ok,err=pcall(function()
 helpers.Parent=game.ReplicatedStorage.Modules
 for _,item in archived do
  if item.old then item.old.Parent=item.record end
  if item.candidate then item.candidate.Parent=item.parent end
 end
 spectating.Source=spectatingAfter
 hud.Source=hudAfter
end)
if not ok then
 spectating.Source=oldSpectating.Value
 hud.Source=oldHUD.Value
 for i=#archived,1,-1 do
  local item=archived[i]
  if item.candidate then item.candidate:Destroy()end
  if item.old then item.old.Parent=item.parent end
 end
 helpers:Destroy();backup:Destroy();error("[Combat menus] Rolled back: "..tostring(err))
end
print("[Combat menus] New sidebar/menu presentation installed. Existing settings/options and backend retained. Save and start a NEW playtest. Backup: "..backup:GetFullName())
