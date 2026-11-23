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
if stamp then assert(stamp:GetAttribute("Version")=="1.0.0","Existing CombatMenuCompat is unknown. Nothing changed.");print("[Combat menus] Already installed.");return end
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
backup.Parent=storage
local ok,err=pcall(function()
 helpers.Parent=game.ReplicatedStorage.Modules
 for _,item in archived do
  if item.old then item.old.Parent=item.record end
  if item.candidate then item.candidate.Parent=item.parent end
 end
 spectating.Source=spectatingAfter
end)
if not ok then
 spectating.Source=oldSpectating.Value
 for i=#archived,1,-1 do
  local item=archived[i]
  if item.candidate then item.candidate:Destroy()end
  if item.old then item.old.Parent=item.parent end
 end
 helpers:Destroy();backup:Destroy();error("[Combat menus] Rolled back: "..tostring(err))
end
print("[Combat menus] New sidebar/menu presentation installed. Existing settings/options and backend retained. Save and start a NEW playtest. Backup: "..backup:GetFullName())
