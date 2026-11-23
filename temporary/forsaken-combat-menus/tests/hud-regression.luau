
local workspace={Players={Spectating={},Killers={},Survivors={}}}
local Character={Parent=workspace.Players.Spectating}
local initialized,cleaned,unbound=0,0,0
local __initializeCenterStaminaCounter=function()initialized+=1 end
local u24=true;local v22={Clean=function()cleaned+=1 end};local RunService={UnbindFromRenderStep=function()unbound+=1 end}
local clone={Visible=false,CurrentSurvivors={}}
local Util={CreateTooltip=function()end}
local v15={Customization={SurvivorInfoEnabled={Value=true}}}
local EventBar={Visible=true}
local LocalPlayer={PlayerGui={MainUI={FindFirstChild=function(_,name)assert(name=='EventBar');return EventBar end}}}
local sidebar={ToggleSidebarButtons=function(self,value)self.visible=value end}
local playerList={TogglePlayerList=function(self,value,forced)self.visible=value;assert(forced)end}
local quests={SetHideState=function(self,value)self.hidden=value end}
local initializer={PlayerSystems={SidebarHandler=sidebar,Quests=quests},Modules={PlayerList=playerList}}
local game={ReplicatedStorage={Initializer=initializer}}
local require=function(module)return module end
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

toggleInfo();assert(not clone.Visible and EventBar.Visible and sidebar.visible and playerList.visible and not quests.hidden)
assert(cleaned==1 and unbound==1)
Character.Parent=workspace.Players.Killers;toggleInfo()
assert(clone.Visible and not EventBar.Visible and not sidebar.visible and not playerList.visible and quests.hidden)
Character.Parent=workspace.Players.Survivors;toggleInfo();assert(clone.Visible and initialized==2)
Character.Parent=workspace.Players.Spectating;toggleInfo();assert(not clone.Visible and sidebar.visible and clone.CurrentSurvivors.Visible)
-- With a ServerList present, both optional lifecycle methods still run.
local reset,reinstate=0,0
initializer.PlayerSystems.ServerList={__resetAllState=function()reset+=1 end,__reinstateState=function()reinstate+=1 end}
Character.Parent=workspace.Players.Survivors;toggleInfo();Character.Parent=workspace.Players.Spectating;toggleInfo()
assert(reset==1 and reinstate==1)
initializer.PlayerSystems.ServerList={};toggleInfo();Character.Parent=workspace.Players.Killers;toggleInfo()
print('PASS real HUD toggleInfo: absent ServerList, missing optional methods, lobby/killer/survivor transitions, existing methods retained and remaining UI still updated')
