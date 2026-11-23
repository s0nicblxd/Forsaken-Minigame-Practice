
local writes=0
local failAt=nil
local function copy(t)local out={};for k,v in pairs(t)do out[k]=v end;return out end
local Methods={}
local mt={}
function mt.__index(self,k)
 if Methods[k]then return Methods[k] end
 if k=="Parent"then return self._parent end
 local value=self._props[k]
 if value~=nil then return value end
 return self:FindFirstChild(k)
end
function mt.__newindex(self,k,v)
 if k=="Parent"then
  if self._parent then local old=self._parent._children;local i=table.find(old,self);if i then table.remove(old,i)end end
  rawset(self,"_parent",v);if v then table.insert(v._children,self)end
 else
  if k=="Source"then writes+=1;if failAt==writes then error("Injected Source write failure")end end
  self._props[k]=v
 end
end
local Instance={}
function Instance.new(class,parent)
 local self=setmetatable({_props={ClassName=class,Name=class},_children={},_attrs={}},mt)
 if parent then self.Parent=parent end
 return self
end
function Methods:IsA(class)
 return self.ClassName==class or class=="LuaSourceContainer"and(self.ClassName=="Script"or self.ClassName=="ModuleScript"or self.ClassName=="LocalScript")or class=="BasePart"and(self.ClassName=="Part"or self.ClassName=="MeshPart")
end
function Methods:FindFirstChild(name,recursive)
 for _,child in ipairs(self._children)do if child.Name==name then return child end end
 if recursive then for _,child in ipairs(self._children)do local found=child:FindFirstChild(name,true);if found then return found end end end
end
function Methods:FindFirstChildOfClass(class)for _,child in ipairs(self._children)do if child:IsA(class)then return child end end end
function Methods:GetChildren()return table.clone(self._children)end
function Methods:GetDescendants()local out={};for _,child in ipairs(self._children)do table.insert(out,child);for _,desc in ipairs(child:GetDescendants())do table.insert(out,desc)end end;return out end
function Methods:SetAttribute(k,v)self._attrs[k]=v end
function Methods:GetAttribute(k)return self._attrs[k]end
function Methods:Clone()
 local object=Instance.new(self.ClassName);object._props=copy(self._props);object._attrs=copy(self._attrs)
 for _,child in ipairs(self._children)do child:Clone().Parent=object end
 return object
end
function Methods:Destroy()self.Parent=nil;self.Destroyed=true;for _,child in ipairs(self:GetChildren())do child:Destroy()end end
function Methods:GetFullName()return (self.Parent and self.Parent:GetFullName().."."or "")..self.Name end
local game,workspace
local function child(parent,name,class)local o=Instance.new(class or "Folder");o.Name=name;o.Parent=parent;return o end
local function fresh()
 writes=0;failAt=nil
 game=Instance.new("DataModel");workspace=child(game,"Workspace","Workspace")
 local rep=child(game,"ReplicatedStorage");local assets=child(rep,"Assets");local survivors=child(assets,"Survivors")
 local modules=child(rep,"Modules");local statuses=child(modules,"StatusEffects");local misc=child(modules,"Misc")
 for _,name in {"Actors","Util","Statuses","Network","Sounds"}do child(modules,name,"ModuleScript")end
 for _,name in {"Maid","Trove"}do child(misc,name,"ModuleScript")end
 child(game,"ServerStorage")
 function game:GetService(name)
  if name=="RunService"then return {IsStudio=function()return true end,IsRunning=function()return false end}end
  if name=="ChangeHistoryService"then return {SetWaypoint=function()end}end
  return self:FindFirstChild(name)
 end
 return survivors,statuses
end
local function inputs()
 local donor=child(workspace,"HelperbotDonor");local rig=child(donor,"Rig","Model")
 child(rig,"Humanoid","Humanoid");child(rig,"HumanoidRootPart","Part")
 local upd=child(workspace,"HelperbotUPD");local config=child(upd,"Config","ModuleScript");local fx=child(config,"VFX")
 for _,name in {"Pulse","PulseHit","InspireActive"}do child(fx,name,"Attachment")end
 child(config,"Radar","MeshPart");child(config,"ChargeMeter","BillboardGui");child(config,"cl_HelperbotChargeBillboard","ModuleScript")
end

local assetData={
{path=[========[
CombatMenusPort]========],class=[========[
Folder]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/UpdatelogPresets]========],class=[========[
Folder]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Misc]========],class=[========[
Folder]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus]========],class=[========[
Folder]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler]========],class=[========[
ModuleScript]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/UpdatelogPresets/Components]========],class=[========[
Folder]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Classes]========],class=[========[
Folder]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Misc/AFKButton]========],class=[========[
ModuleScript]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory]========],class=[========[
ModuleScript]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Rules]========],class=[========[
ModuleScript]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Achievements]========],class=[========[
ModuleScript]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Settings]========],class=[========[
ModuleScript]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Stats]========],class=[========[
ModuleScript]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop]========],class=[========[
ModuleScript]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog]========],class=[========[
ModuleScript]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/UpdatelogPresets/UpdatePreset]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/CashDisplay]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/UpdatelogPresets/UpdatePreset/Backdrop]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/CashDisplay/UIListLayout]========],class=[========[
UIListLayout]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/UIListLayout]========],class=[========[
UIListLayout]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/CashDisplay/UIPadding]========],class=[========[
UIPadding]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/UIPadding]========],class=[========[
UIPadding]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates]========],class=[========[
Folder]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Tabs]========],class=[========[
Folder]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/OldTabs]========],class=[========[
Folder]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/RandomizerTabs]========],class=[========[
Folder]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Achievements/Templates]========],class=[========[
Folder]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Settings/Templates]========],class=[========[
Folder]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Stats/Templates]========],class=[========[
Folder]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs]========],class=[========[
Folder]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Assets]========],class=[========[
Folder]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Classes]========],class=[========[
Folder]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/Presets]========],class=[========[
Folder]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Classes/Button]========],class=[========[
ModuleScript]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Classes/CurrencyDisplay]========],class=[========[
ModuleScript]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Types]========],class=[========[
ModuleScript]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/DiscordMarkdown]========],class=[========[
ModuleScript]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/CashDisplay/UISizeConstraint]========],class=[========[
UISizeConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/UISizeConstraint]========],class=[========[
UISizeConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/UpdatelogPresets/Components/Header]========],class=[========[
TextLabel]========],text=[========[
LOREM IPSUM]========]},
{path=[========[
CombatMenusPort/UpdatelogPresets/UpdatePreset/MainInfo]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/UpdatelogPresets/Components/TextPreset]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/UpdatelogPresets/Components/Seperator]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Top]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Bottom]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/InventoryScreen]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Rules/RulesScreen]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Achievements/AchievementsScreen]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Settings/SettingsScreen]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Stats/StatsScreen]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/UpdateScreen]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/UpdatelogPresets/UpdatePreset/Notes]========],class=[========[
ScrollingFrame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Achievements/Templates/TabButton]========],class=[========[
ImageButton]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Settings/Templates/Reset]========],class=[========[
ImageButton]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/UpdatelogPresets/UpdatePreset/MainInfo/IntroImage]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/Seperator]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteEquipMenu]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/ConfirmPurchase]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Rules/RulesScreen/RulesContainer]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Achievements/AchievementsScreen/AchievementsContainer]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Achievements/Templates/Achievement]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Achievements/Templates/Seperator]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Settings/Templates/Seperator]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Settings/SettingsScreen/SettingsContainer]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Stats/StatsScreen/StatsContainer]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Stats/Templates/Seperator]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/UpdatelogPresets/UpdatePreset/Notes/UIListLayout]========],class=[========[
UIListLayout]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/UIListLayout]========],class=[========[
UIListLayout]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Bottom/UIListLayout]========],class=[========[
UIListLayout]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/UIPadding]========],class=[========[
UIPadding]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Bottom/UIPadding]========],class=[========[
UIPadding]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/Presets/UpdateTemplate]========],class=[========[
TextButton]========],text=[========[
 ]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Assets/EmoteViewport]========],class=[========[
ViewportFrame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Assets/TransitionGui]========],class=[========[
ScreenGui]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/UpdatelogPresets/UpdatePreset/MainInfo/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/UpdateScreen/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/Presets/Components]========],class=[========[
Folder]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Tabs/Emotes]========],class=[========[
ModuleScript]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Tabs/Killers]========],class=[========[
ModuleScript]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Tabs/Survivors]========],class=[========[
ModuleScript]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/OldTabs/Killers [OLD]]========],class=[========[
ModuleScript]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/OldTabs/Survivors [OLD]]========],class=[========[
ModuleScript]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/RandomizerTabs/Survivors]========],class=[========[
ModuleScript]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/RandomizerTabs/Killers]========],class=[========[
ModuleScript]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/RandomizerTabs/Emotes]========],class=[========[
ModuleScript]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Settings/Templates/Textbox]========],class=[========[
ModuleScript]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Settings/Templates/String]========],class=[========[
ModuleScript]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Settings/Templates/Number]========],class=[========[
ModuleScript]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Settings/Templates/Bool]========],class=[========[
ModuleScript]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Settings/Templates/Keybind]========],class=[========[
ModuleScript]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Emotes]========],class=[========[
ModuleScript]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins]========],class=[========[
ModuleScript]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Classes/RigBuilder]========],class=[========[
ModuleScript]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/UISizeConstraint]========],class=[========[
UISizeConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/UpdateScreen/UISizeConstraint]========],class=[========[
UISizeConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/UpdatelogPresets/Components/TextPreset/Main]========],class=[========[
TextLabel]========],text=[========[
Lorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/Header]========],class=[========[
TextLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/Quote]========],class=[========[
TextLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Stats/Templates/Title]========],class=[========[
TextLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/UpdatelogPresets/UpdatePreset/MainInfo/TitleMeta]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/UpdatelogPresets/Components/Seperator/Main]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Classes/CurrencyDisplay/Preset]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/Inventory]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/Achievements]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/Spectate]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/Stats]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/Shop]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Bottom/Rules]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Bottom/Settings]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Bottom/UpdateLog]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Bottom/AFK]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/TextContainer]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/CardTemplate]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteHolder]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/CardTemplateShop]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/InventoryScreen/InventoryRoot]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Assets/NotFound]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Assets/ConfirmUI]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/Presets/Loading]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/Presets/UpdateDisplayTemplate]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/UpdateScreen/Holder]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/UpdateScreen/List]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Assets/EmoteViewport/WorldModel]========],class=[========[
WorldModel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/ExtraSwitch]========],class=[========[
ImageButton]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteEquipMenu/Unequip]========],class=[========[
ImageButton]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteEquipMenu/Cancel]========],class=[========[
ImageButton]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteHolder/Button]========],class=[========[
ImageButton]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Rules/RulesScreen/RulesContainer/Exit]========],class=[========[
ImageButton]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Settings/Templates/String/DropdownOption]========],class=[========[
ImageButton]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Classes/CurrencyDisplay/Preset/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Classes/CurrencyDisplay/Preset/Outline]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Classes/CurrencyDisplay/Preset/Icon]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Classes/CurrencyDisplay/Preset/BG]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Classes/CurrencyDisplay/Preset/Vignette]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/TextContainer/Image]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteEquipMenu/Searchbar]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/InventoryScreen/InventoryRoot/InventoryContainer]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/InventoryScreen/InventoryRoot/InfoContainer]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/InventoryScreen/InventoryRoot/SkinsContainer]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Achievements/AchievementsScreen/AchievementsContainer/MainTitle]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Achievements/Templates/Achievement/IconBackground]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Achievements/Templates/Achievement/ProgressBar]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Achievements/Templates/Achievement/IncompleteOverlay]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Achievements/Templates/Achievement/Icon]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Achievements/Templates/Achievement/RewardOverlay]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Achievements/Templates/TabButton/Inverted]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Assets/NotFound/Logo]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Assets/ConfirmUI/BG]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Assets/ConfirmUI/Line]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Assets/ConfirmUI/Line]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Assets/ConfirmUI/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Assets/ConfirmUI/Texture]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder/Texture]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder/Line]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder/BG]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/Presets/Loading/Logo]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/Presets/UpdateTemplate/Outline]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/Presets/UpdateTemplate/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/Presets/UpdateTemplate/BG]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/Presets/UpdateTemplate/Render]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/Presets/UpdateTemplate/Shadow]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/Presets/UpdateTemplate/Vignette]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/Presets/UpdateTemplate/Vignette]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/Presets/UpdateTemplate/Shine]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/Presets/Components/ImageTemplate]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/UpdateScreen/Holder/BG]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/UpdateScreen/Holder/Texture]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/UpdateScreen/Holder/Line]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/UpdateScreen/List/BG]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/UpdateScreen/List/Line]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/TextContainer/UIListLayout]========],class=[========[
UIListLayout]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/InventoryScreen/InventoryRoot/UIListLayout]========],class=[========[
UIListLayout]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/Presets/UpdateDisplayTemplate/UIListLayout]========],class=[========[
UIListLayout]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/Presets/UpdateDisplayTemplate/UIPadding]========],class=[========[
UIPadding]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Classes/CurrencyDisplay/Preset/Plus]========],class=[========[
TextButton]========],text=[========[
 ]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/Inventory/Button]========],class=[========[
TextButton]========],text=[========[
 ]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/Achievements/Button]========],class=[========[
TextButton]========],text=[========[
 ]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/Spectate/Button]========],class=[========[
TextButton]========],text=[========[
 ]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/Stats/Button]========],class=[========[
TextButton]========],text=[========[
 ]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/Shop/Button]========],class=[========[
TextButton]========],text=[========[
 ]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Bottom/Rules/Button]========],class=[========[
TextButton]========],text=[========[
 ]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Bottom/Settings/Button]========],class=[========[
TextButton]========],text=[========[
 ]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Bottom/UpdateLog/Button]========],class=[========[
TextButton]========],text=[========[
 ]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Bottom/AFK/Button]========],class=[========[
TextButton]========],text=[========[
 ]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Assets/ConfirmUI/Purchase]========],class=[========[
TextButton]========],text=[========[
 ]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Assets/ConfirmUI/Cancel]========],class=[========[
TextButton]========],text=[========[
 ]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder/Close]========],class=[========[
TextButton]========],text=[========[
 ]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/UpdateScreen/Holder/Close]========],class=[========[
TextButton]========],text=[========[
 ]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Classes/CurrencyDisplay/Preset/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/Inventory/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/Achievements/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/Spectate/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/Stats/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/Shop/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Bottom/Rules/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Bottom/Settings/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Bottom/UpdateLog/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Bottom/AFK/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/AspectRatio]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/CardTemplate/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/CardTemplateShop/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/InventoryScreen/InventoryRoot/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Rules/RulesScreen/RulesContainer/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Achievements/AchievementsScreen/AchievementsContainer/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Achievements/Templates/TabButton/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Settings/Templates/Reset/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Settings/SettingsScreen/SettingsContainer/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Stats/StatsScreen/StatsContainer/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Assets/ConfirmUI/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/Presets/UpdateTemplate/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/UpdateScreen/Holder/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/UpdateScreen/List/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Emotes/Assets]========],class=[========[
Folder]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets]========],class=[========[
Folder]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/Inventory/UISizeConstraint]========],class=[========[
UISizeConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/Achievements/UISizeConstraint]========],class=[========[
UISizeConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/Spectate/UISizeConstraint]========],class=[========[
UISizeConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/Stats/UISizeConstraint]========],class=[========[
UISizeConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/Shop/UISizeConstraint]========],class=[========[
UISizeConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Bottom/Rules/UISizeConstraint]========],class=[========[
UISizeConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Bottom/Settings/UISizeConstraint]========],class=[========[
UISizeConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Bottom/UpdateLog/UISizeConstraint]========],class=[========[
UISizeConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Bottom/AFK/UISizeConstraint]========],class=[========[
UISizeConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Assets/ConfirmUI/UISizeConstraint]========],class=[========[
UISizeConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/UpdatelogPresets/UpdatePreset/MainInfo/TitleMeta/Title]========],class=[========[
TextLabel]========],text=[========[
???]========]},
{path=[========[
CombatMenusPort/UpdatelogPresets/UpdatePreset/MainInfo/TitleMeta/Date]========],class=[========[
TextLabel]========],text=[========[
?/??/??]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Classes/CurrencyDisplay/Preset/Amount]========],class=[========[
TextLabel]========],text=[========[
50,000]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/EmoteType]========],class=[========[
TextLabel]========],text=[========[
Emotes]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/Seperator/Title]========],class=[========[
TextLabel]========],text=[========[
Hello]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/TextContainer/Title]========],class=[========[
TextLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteHolder/Title]========],class=[========[
TextLabel]========],text=[========[
Emotes]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/ConfirmPurchase/Title]========],class=[========[
TextLabel]========],text=[========[
Are you sure you would like to purchase Jason for 8000$?]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/ConfirmPurchase/Disclaimer]========],class=[========[
TextLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Achievements/Templates/Achievement/Title]========],class=[========[
TextLabel]========],text=[========[
Achievement Name]========]},
{path=[========[
CombatMenusPort/Menus/Achievements/Templates/Achievement/Description]========],class=[========[
TextLabel]========],text=[========[
Achievement Description]========]},
{path=[========[
CombatMenusPort/Menus/Achievements/Templates/Achievement/Progress]========],class=[========[
TextLabel]========],text=[========[
100/100]========]},
{path=[========[
CombatMenusPort/Menus/Achievements/Templates/TabButton/Title]========],class=[========[
TextLabel]========],text=[========[
Shop]========]},
{path=[========[
CombatMenusPort/Menus/Achievements/Templates/Seperator/Title]========],class=[========[
TextLabel]========],text=[========[
Hello]========]},
{path=[========[
CombatMenusPort/Menus/Settings/Templates/Seperator/Title]========],class=[========[
TextLabel]========],text=[========[
Hello]========]},
{path=[========[
CombatMenusPort/Menus/Stats/Templates/Seperator/Title]========],class=[========[
TextLabel]========],text=[========[
Hello]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Assets/NotFound/NotFound]========],class=[========[
TextLabel]========],text=[========[
No page was found :(]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Assets/ConfirmUI/Text]========],class=[========[
TextLabel]========],text=[========[
Are you sure you would like to purchase: SKIN ?]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/Presets/Loading/Loading]========],class=[========[
TextLabel]========],text=[========[
Loading page contents]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/Presets/UpdateTemplate/UpdateName]========],class=[========[
TextLabel]========],text=[========[
Update #1]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/Presets/UpdateTemplate/Description]========],class=[========[
TextLabel]========],text=[========[
the we added skins finally for him update]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/Presets/Components/SmallTextTemplate]========],class=[========[
TextLabel]========],text=[========[
Small Text Template]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/Presets/Components/TextTemplate]========],class=[========[
TextLabel]========],text=[========[
Added 2 New Skins:<br/> <br/> • Bloxy <font transparency="0.6">( Shedletsky )</font> <br/> • Brighteyes <font transparency="0.6">( Shedletsky )</font>]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Emotes]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/ExtraEmotes]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/CardTemplate/Container]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/CardTemplateShop/Container]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/ConfirmPurchase/Buttons]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/InventoryScreen/InventoryRoot/SideContainer]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Achievements/AchievementsScreen/AchievementsContainer/Tabs]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Settings/Templates/Textbox/Textbox]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Settings/Templates/String/Dropdown]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Settings/Templates/Number/Slider]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Settings/Templates/Bool/Checkbox]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Settings/Templates/Keybind/KeybindFrame]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Emotes/Page]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Assets/TransitionGui/Purchase]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder/Page]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder/TabButtons]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder/Currency]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder/Overlay]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/Presets/Components/SkinTemplate]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/Presets/Components/HeaderTemplate]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/Presets/Components/SubheaderTemplate]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/Presets/Components/ItemsTemplate]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteEquipMenu/EmoteList]========],class=[========[
ScrollingFrame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Rules/RulesScreen/RulesContainer/Contents]========],class=[========[
ScrollingFrame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Achievements/AchievementsScreen/AchievementsContainer/Contents]========],class=[========[
ScrollingFrame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Settings/SettingsScreen/SettingsContainer/Contents]========],class=[========[
ScrollingFrame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Stats/StatsScreen/StatsContainer/Contents]========],class=[========[
ScrollingFrame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/UpdateScreen/Holder/List]========],class=[========[
ScrollingFrame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/UpdateScreen/List/Updates]========],class=[========[
ScrollingFrame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Assets/EmoteViewport/WorldModel/Arrows]========],class=[========[
MeshPart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Emotes/2]========],class=[========[
ImageButton]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Emotes/3]========],class=[========[
ImageButton]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Emotes/4]========],class=[========[
ImageButton]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Emotes/5]========],class=[========[
ImageButton]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Emotes/6]========],class=[========[
ImageButton]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Emotes/7]========],class=[========[
ImageButton]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Emotes/8]========],class=[========[
ImageButton]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Emotes/1]========],class=[========[
ImageButton]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/ExtraEmotes/2]========],class=[========[
ImageButton]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/ExtraEmotes/3]========],class=[========[
ImageButton]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/ExtraEmotes/4]========],class=[========[
ImageButton]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/ExtraEmotes/5]========],class=[========[
ImageButton]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/ExtraEmotes/6]========],class=[========[
ImageButton]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/ExtraEmotes/7]========],class=[========[
ImageButton]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/ExtraEmotes/8]========],class=[========[
ImageButton]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/ExtraEmotes/1]========],class=[========[
ImageButton]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/CardTemplate/Container/Interact]========],class=[========[
ImageButton]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/CardTemplate/Container/Favorite]========],class=[========[
ImageButton]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/CardTemplateShop/Container/Interact]========],class=[========[
ImageButton]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/ConfirmPurchase/Buttons/No]========],class=[========[
ImageButton]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/ConfirmPurchase/Buttons/Yes]========],class=[========[
ImageButton]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Settings/Templates/String/Dropdown/DropdownFrame]========],class=[========[
ImageButton]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Settings/Templates/Bool/Checkbox/CheckboxButton]========],class=[========[
ImageButton]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Settings/Templates/Keybind/KeybindFrame/KeybindButton]========],class=[========[
ImageButton]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Classes/CurrencyDisplay/Preset/Plus/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Classes/CurrencyDisplay/Preset/Plus/Icon]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/Inventory/Button/Line]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/Inventory/Button/Shadow]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/Inventory/Button/GrungeMain]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/Inventory/Button/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/Inventory/Button/Icon]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/Inventory/Button/BG]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/Inventory/Button/Texture]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/Inventory/Button/Highlight]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/Achievements/Button/Line]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/Achievements/Button/Shadow]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/Achievements/Button/GrungeMain]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/Achievements/Button/Icon]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/Achievements/Button/BG]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/Achievements/Button/Highlight]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/Achievements/Button/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/Achievements/Button/Texture]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/Spectate/Button/Icon]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/Spectate/Button/Texture]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/Spectate/Button/Shadow]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/Spectate/Button/Line]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/Spectate/Button/Highlight]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/Spectate/Button/GrungeMain]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/Spectate/Button/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/Spectate/Button/BG]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/Stats/Button/Line]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/Stats/Button/Shadow]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/Stats/Button/GrungeMain]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/Stats/Button/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/Stats/Button/Icon]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/Stats/Button/BG]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/Stats/Button/Texture]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/Stats/Button/Highlight]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/Shop/Button/Shadow]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/Shop/Button/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/Shop/Button/Icon]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/Shop/Button/BG]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/Shop/Button/Texture]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/Shop/Button/Highlight]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/Shop/Button/GrungeMain]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/Shop/Button/Line]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Bottom/Rules/Button/Icon]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Bottom/Rules/Button/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Bottom/Rules/Button/Shadow]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Bottom/Settings/Button/Icon]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Bottom/Settings/Button/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Bottom/Settings/Button/Shadow]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Bottom/UpdateLog/Button/Icon]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Bottom/UpdateLog/Button/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Bottom/UpdateLog/Button/Shadow]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Bottom/AFK/Button/Icon]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Bottom/AFK/Button/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Bottom/AFK/Button/Shadow]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/CardTemplate/Container/Outline]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/CardTemplate/Container/CharacterRender]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/CardTemplate/Container/Equipped]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/CardTemplate/Container/LockImage]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteHolder/Button/Icon]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/CardTemplateShop/Container/CharacterRender]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/CardTemplateShop/Container/Outline]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/CardTemplateShop/Container/LockImage]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/CardTemplateShop/Container/Equipped]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/InventoryScreen/InventoryRoot/InventoryContainer/Money]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/InventoryScreen/InventoryRoot/SkinsContainer/TitleDisplay]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/InventoryScreen/InventoryRoot/SideContainer/EquipContainer]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Settings/Templates/Textbox/Textbox/TextboxBackground]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Settings/Templates/Number/Slider/DragBarBackground]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Settings/SettingsScreen/SettingsContainer/Contents/SearchBoxBackground]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Emotes/Page/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Emotes/Page/Line]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Assets/TransitionGui/Purchase/Icon]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Assets/ConfirmUI/Purchase/Line]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Assets/ConfirmUI/Purchase/Shadow]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Assets/ConfirmUI/Purchase/Highlight]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Assets/ConfirmUI/Purchase/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Assets/ConfirmUI/Purchase/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Assets/ConfirmUI/Cancel/Line]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Assets/ConfirmUI/Cancel/Shadow]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Assets/ConfirmUI/Cancel/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Assets/ConfirmUI/Cancel/Highlight]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Assets/ConfirmUI/Cancel/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder/Close/Outline]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder/Close/Texture]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder/Close/Vignette]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder/Close/Shadow]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder/Close/Icon]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder/Close/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder/Close/BG]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder/Overlay/Line]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder/Overlay/BG]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/Presets/Components/SkinTemplate/Shadow]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/Presets/Components/HeaderTemplate/Background]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/Presets/Components/HeaderTemplate/Shine]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/Presets/Components/SubheaderTemplate/Shine]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/UpdateScreen/Holder/Close/Outline]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/UpdateScreen/Holder/Close/Texture]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/UpdateScreen/Holder/Close/Vignette]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/UpdateScreen/Holder/Close/Shadow]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/UpdateScreen/Holder/Close/Icon]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/UpdateScreen/Holder/Close/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/UpdateScreen/Holder/Close/BG]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/ConfirmPurchase/Buttons/UIListLayout]========],class=[========[
UIListLayout]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Rules/RulesScreen/RulesContainer/Contents/UIListLayout]========],class=[========[
UIListLayout]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Achievements/AchievementsScreen/AchievementsContainer/Contents/UIListLayout]========],class=[========[
UIListLayout]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Achievements/AchievementsScreen/AchievementsContainer/Tabs/UIListLayout]========],class=[========[
UIListLayout]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Settings/SettingsScreen/SettingsContainer/Contents/UIListLayout]========],class=[========[
UIListLayout]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Stats/StatsScreen/StatsContainer/Contents/UIListLayout]========],class=[========[
UIListLayout]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder/TabButtons/UIListLayout]========],class=[========[
UIListLayout]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder/Currency/UIListLayout]========],class=[========[
UIListLayout]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/Presets/Components/ItemsTemplate/UIListLayout]========],class=[========[
UIListLayout]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/UpdateScreen/Holder/List/UIListLayout]========],class=[========[
UIListLayout]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/UpdateScreen/List/Updates/UIListLayout]========],class=[========[
UIListLayout]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Assets/EmoteViewport/WorldModel/Rig]========],class=[========[
Model]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Classes/CurrencyDisplay/Preset/Amount/UIPadding]========],class=[========[
UIPadding]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Achievements/AchievementsScreen/AchievementsContainer/Contents/UIPadding]========],class=[========[
UIPadding]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Settings/SettingsScreen/SettingsContainer/Contents/UIPadding]========],class=[========[
UIPadding]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Stats/StatsScreen/StatsContainer/Contents/UIPadding]========],class=[========[
UIPadding]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder/TabButtons/UIPadding]========],class=[========[
UIPadding]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder/Currency/UIPadding]========],class=[========[
UIPadding]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/Presets/UpdateTemplate/UpdateName/UIPadding]========],class=[========[
UIPadding]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/Presets/UpdateTemplate/Description/UIPadding]========],class=[========[
UIPadding]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/Presets/Components/SmallTextTemplate/UIPadding]========],class=[========[
UIPadding]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/Presets/Components/TextTemplate/UIPadding]========],class=[========[
UIPadding]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/UpdateScreen/List/Updates/UIPadding]========],class=[========[
UIPadding]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Emotes/Page/SortUnowned]========],class=[========[
TextButton]========],text=[========[
 ]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Emotes/Assets/Template]========],class=[========[
TextButton]========],text=[========[
 ]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterButton_PRESET]========],class=[========[
TextButton]========],text=[========[
 ]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder/TabButtons/Skins]========],class=[========[
TextButton]========],text=[========[
 ]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder/TabButtons/Emotes]========],class=[========[
TextButton]========],text=[========[
 ]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/ConfirmPurchase/Disclaimer/UIStroke]========],class=[========[
UIStroke]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/1]========],class=[========[
ViewportFrame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/2]========],class=[========[
ViewportFrame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/3]========],class=[========[
ViewportFrame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/4]========],class=[========[
ViewportFrame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/5]========],class=[========[
ViewportFrame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/6]========],class=[========[
ViewportFrame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/7]========],class=[========[
ViewportFrame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/8]========],class=[========[
ViewportFrame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Assets/ConfirmUI/Text/UITextSizeConstraint]========],class=[========[
UITextSizeConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/Presets/UpdateTemplate/Description/UITextSizeConstraint]========],class=[========[
UITextSizeConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/Presets/Components/SmallTextTemplate/UITextSizeConstraint]========],class=[========[
UITextSizeConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/Presets/Components/TextTemplate/UITextSizeConstraint]========],class=[========[
UITextSizeConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/EmoteType/AspectRatio]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/ExtraSwitch/AspectRatio]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/TextContainer/Image/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteHolder/Button/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Rules/RulesScreen/RulesContainer/Exit/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Achievements/Templates/Achievement/IconBackground/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Achievements/Templates/Achievement/Icon/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Assets/ConfirmUI/Purchase/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Assets/ConfirmUI/Cancel/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder/Close/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder/Overlay/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/Presets/Components/SkinTemplate/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/Presets/Components/HeaderTemplate/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/Presets/Components/SubheaderTemplate/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/UpdateScreen/Holder/Close/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteEquipMenu/Searchbar/TextBox]========],class=[========[
TextBox]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder/Close/UISizeConstraint]========],class=[========[
UISizeConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/UpdateScreen/Holder/Close/UISizeConstraint]========],class=[========[
UISizeConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Classes/CurrencyDisplay/Preset/Icon/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/CardTemplate/Container/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteEquipMenu/EmoteList/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/CardTemplateShop/Container/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Assets/ConfirmUI/BG/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Assets/ConfirmUI/Grunge/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Assets/ConfirmUI/Text/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder/Texture/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/Presets/UpdateTemplate/BG/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/Presets/UpdateTemplate/Render/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/UpdateScreen/Holder/Texture/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteEquipMenu/EmoteList/UIGridLayout]========],class=[========[
UIGridLayout]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/CardTemplate/Container/Title]========],class=[========[
TextLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/CardTemplate/Container/Price]========],class=[========[
TextLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteEquipMenu/Unequip/Title]========],class=[========[
TextLabel]========],text=[========[
Unequip]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteEquipMenu/Cancel/Title]========],class=[========[
TextLabel]========],text=[========[
Cancel]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/CardTemplateShop/Container/Price]========],class=[========[
TextLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/CardTemplateShop/Container/Title]========],class=[========[
TextLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/CardTemplateShop/Container/LimitedTime]========],class=[========[
TextLabel]========],text=[========[
00:12:00:00]========]},
{path=[========[
CombatMenusPort/Menus/Rules/RulesScreen/RulesContainer/Exit/Text]========],class=[========[
TextLabel]========],text=[========[
X]========]},
{path=[========[
CombatMenusPort/Menus/Rules/RulesScreen/RulesContainer/Contents/Header]========],class=[========[
TextLabel]========],text=[========[
Rules]========]},
{path=[========[
CombatMenusPort/Menus/Achievements/AchievementsScreen/AchievementsContainer/MainTitle/Title]========],class=[========[
TextLabel]========],text=[========[
Unlocked -- 0/0]========]},
{path=[========[
CombatMenusPort/Menus/Achievements/Templates/Achievement/RewardOverlay/Title]========],class=[========[
TextLabel]========],text=[========[
Reward:]========]},
{path=[========[
CombatMenusPort/Menus/Achievements/Templates/Achievement/RewardOverlay/RewardTitle]========],class=[========[
TextLabel]========],text=[========[
IDK]========]},
{path=[========[
CombatMenusPort/Menus/Settings/Templates/Textbox/Textbox/SettingName]========],class=[========[
TextLabel]========],text=[========[
some setting option here]========]},
{path=[========[
CombatMenusPort/Menus/Settings/Templates/Textbox/Textbox/SettingDesc]========],class=[========[
TextLabel]========],text=[========[
some setting description here]========]},
{path=[========[
CombatMenusPort/Menus/Settings/Templates/String/Dropdown/SettingName]========],class=[========[
TextLabel]========],text=[========[
some setting option here]========]},
{path=[========[
CombatMenusPort/Menus/Settings/Templates/String/Dropdown/SettingDesc]========],class=[========[
TextLabel]========],text=[========[
some setting description here]========]},
{path=[========[
CombatMenusPort/Menus/Settings/Templates/String/DropdownOption/Title]========],class=[========[
TextLabel]========],text=[========[
Option 1]========]},
{path=[========[
CombatMenusPort/Menus/Settings/Templates/Number/Slider/SettingDesc]========],class=[========[
TextLabel]========],text=[========[
some setting description here]========]},
{path=[========[
CombatMenusPort/Menus/Settings/Templates/Number/Slider/SettingName]========],class=[========[
TextLabel]========],text=[========[
some setting option here]========]},
{path=[========[
CombatMenusPort/Menus/Settings/Templates/Bool/Checkbox/SettingName]========],class=[========[
TextLabel]========],text=[========[
some setting option here]========]},
{path=[========[
CombatMenusPort/Menus/Settings/Templates/Bool/Checkbox/SettingDesc]========],class=[========[
TextLabel]========],text=[========[
some setting description here]========]},
{path=[========[
CombatMenusPort/Menus/Settings/Templates/Keybind/KeybindFrame/SettingName]========],class=[========[
TextLabel]========],text=[========[
some setting option here]========]},
{path=[========[
CombatMenusPort/Menus/Settings/Templates/Keybind/KeybindFrame/SettingDesc]========],class=[========[
TextLabel]========],text=[========[
some setting description here]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Assets/ConfirmUI/Purchase/Text]========],class=[========[
TextLabel]========],text=[========[
PURCHASE]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Assets/ConfirmUI/Cancel/Text]========],class=[========[
TextLabel]========],text=[========[
Cancel]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/Presets/Components/HeaderTemplate/Header]========],class=[========[
TextLabel]========],text=[========[
Update #1]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/Presets/Components/HeaderTemplate/Description]========],class=[========[
TextLabel]========],text=[========[
Update description goes here]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/Presets/Components/SubheaderTemplate/Header]========],class=[========[
TextLabel]========],text=[========[
New Content]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/Presets/Components/ImageTemplate/Subtitle]========],class=[========[
TextLabel]========],text=[========[
Horror Hotel Overhaul]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/Inventory/Button/Text]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/Achievements/Button/Text]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/Spectate/Button/Text]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/Stats/Button/Text]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/Shop/Button/Text]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Bottom/Rules/Button/Text]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Bottom/Settings/Button/Text]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Bottom/UpdateLog/Button/Text]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Bottom/AFK/Button/Text]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/CardTemplate/Container/CardIcons]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/CardTemplateShop/Container/EventPrice]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/InventoryScreen/InventoryRoot/InventoryContainer/Topbar]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/InventoryScreen/InventoryRoot/SkinsContainer/Topbar]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/InventoryScreen/InventoryRoot/SideContainer/PreviewContainer]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Achievements/Templates/Achievement/ProgressBar/Clipping]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Settings/Templates/Number/Slider/DragBar]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Emotes/Page/Gradient]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Emotes/Page/Gradient]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Emotes/Page/Search]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/TabButtons]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder/Overlay/Preview]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/Presets/Components/SkinTemplate/Holder]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/Presets/Components/SkinTemplate/Owned]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/CardTemplate/Container/UICorner]========],class=[========[
UICorner]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/CardTemplateShop/Container/UICorner]========],class=[========[
UICorner]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Achievements/Templates/Achievement/Icon/UICorner]========],class=[========[
UICorner]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/Presets/Components/ImageTemplate/UICorner]========],class=[========[
UICorner]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/CardTemplateShop/Container/CardIcons]========],class=[========[
ScrollingFrame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/InventoryScreen/InventoryRoot/InventoryContainer/Contents]========],class=[========[
ScrollingFrame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/InventoryScreen/InventoryRoot/InfoContainer/Contents]========],class=[========[
ScrollingFrame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/InventoryScreen/InventoryRoot/SkinsContainer/Contents]========],class=[========[
ScrollingFrame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Emotes/Page/List]========],class=[========[
ScrollingFrame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/InventoryScreen/InventoryRoot/InventoryContainer/Topbar/Survivors]========],class=[========[
ImageButton]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/InventoryScreen/InventoryRoot/InventoryContainer/Topbar/Killers]========],class=[========[
ImageButton]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/InventoryScreen/InventoryRoot/InventoryContainer/Topbar/Emotes]========],class=[========[
ImageButton]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/InventoryScreen/InventoryRoot/SideContainer/EquipContainer/Equip]========],class=[========[
ImageButton]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/InventoryScreen/InventoryRoot/SideContainer/EquipContainer/Purchase]========],class=[========[
ImageButton]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Settings/Templates/Number/Slider/DragBar/Dragger]========],class=[========[
ImageButton]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/Inventory/Button/Text/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/Inventory/Button/Text/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/Achievements/Button/Text/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/Achievements/Button/Text/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/Spectate/Button/Text/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/Spectate/Button/Text/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/Stats/Button/Text/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/Stats/Button/Text/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/Shop/Button/Text/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/Shop/Button/Text/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Bottom/Rules/Button/Text/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Bottom/Rules/Button/Text/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Bottom/Settings/Button/Text/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Bottom/Settings/Button/Text/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Bottom/UpdateLog/Button/Text/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Bottom/UpdateLog/Button/Text/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Bottom/AFK/Button/Text/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Bottom/AFK/Button/Text/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Emotes/2/Asset]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Emotes/3/Asset]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Emotes/4/Asset]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Emotes/5/Asset]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Emotes/6/Asset]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Emotes/7/Asset]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Emotes/8/Asset]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Emotes/1/Asset]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/ExtraEmotes/2/Asset]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/ExtraEmotes/3/Asset]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/ExtraEmotes/4/Asset]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/ExtraEmotes/5/Asset]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/ExtraEmotes/6/Asset]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/ExtraEmotes/7/Asset]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/ExtraEmotes/8/Asset]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/ExtraEmotes/1/Asset]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/CardTemplateShop/Container/EventPrice/Icon]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/InventoryScreen/InventoryRoot/InventoryContainer/Topbar/Searchbar]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/InventoryScreen/InventoryRoot/SkinsContainer/Topbar/Searchbar]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/InventoryScreen/InventoryRoot/SideContainer/EquipContainer/ButtonDescription]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/InventoryScreen/InventoryRoot/SideContainer/PreviewContainer/Render]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/InventoryScreen/InventoryRoot/SideContainer/PreviewContainer/UIArt]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/InventoryScreen/InventoryRoot/SideContainer/PreviewContainer/EXPBar]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Achievements/Templates/Achievement/ProgressBar/Clipping/Top]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Settings/Templates/String/Dropdown/DropdownFrame/DropdownArrow]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Settings/Templates/String/Dropdown/DropdownFrame/ChosenValue]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Settings/Templates/Bool/Checkbox/CheckboxButton/Checked]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Settings/Templates/Keybind/KeybindFrame/KeybindButton/CurrentBind]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Settings/SettingsScreen/SettingsContainer/Contents/SearchBoxBackground/ImageLabel]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Emotes/Page/Search/Line]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Emotes/Page/Search/Icon]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Emotes/Page/Search/Texture]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Emotes/Page/Search/BG]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Emotes/Page/SortUnowned/Outline]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Emotes/Page/SortUnowned/Texture]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Emotes/Page/SortUnowned/Vignette]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Emotes/Page/SortUnowned/Shadow]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Emotes/Page/SortUnowned/Icon]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Emotes/Page/SortUnowned/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Emotes/Page/SortUnowned/BG]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Emotes/Assets/Template/Shadow]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder/TabButtons/Skins/Texture]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder/TabButtons/Skins/Outline]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder/TabButtons/Skins/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder/TabButtons/Skins/BG]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder/TabButtons/Skins/Vignette]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder/TabButtons/Skins/Shadow]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder/TabButtons/Skins/Vignette]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder/TabButtons/Skins/Highlight]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder/TabButtons/Emotes/BG]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder/TabButtons/Emotes/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder/TabButtons/Emotes/Outline]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder/TabButtons/Emotes/Texture]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder/TabButtons/Emotes/Vignette]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder/TabButtons/Emotes/Shadow]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder/TabButtons/Emotes/Vignette]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder/TabButtons/Emotes/Highlight]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder/Overlay/Preview/Shadow]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder/Overlay/Preview/Texture]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder/Overlay/Preview/Line]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder/Overlay/Preview/DiscountTag]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/Presets/Components/SkinTemplate/Holder/Render]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/Presets/Components/SkinTemplate/Holder/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/Presets/Components/SkinTemplate/Holder/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/Presets/Components/SkinTemplate/Holder/Line]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/Presets/Components/SkinTemplate/Holder/Texture]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/Presets/Components/SkinTemplate/Owned/BG]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/CardTemplate/Container/CardIcons/UIListLayout]========],class=[========[
UIListLayout]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/CardTemplateShop/Container/CardIcons/UIListLayout]========],class=[========[
UIListLayout]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/InventoryScreen/InventoryRoot/InventoryContainer/Topbar/UIListLayout]========],class=[========[
UIListLayout]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/InventoryScreen/InventoryRoot/InfoContainer/Contents/UIListLayout]========],class=[========[
UIListLayout]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/InventoryScreen/InventoryRoot/SkinsContainer/Topbar/UIListLayout]========],class=[========[
UIListLayout]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Emotes/Page/List/UIListLayout]========],class=[========[
UIListLayout]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/TabButtons/UIListLayout]========],class=[========[
UIListLayout]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/1/Model]========],class=[========[
Model]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/2/Model]========],class=[========[
Model]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/3/Model]========],class=[========[
Model]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/4/Model]========],class=[========[
Model]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/5/Model]========],class=[========[
Model]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/6/Model]========],class=[========[
Model]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/7/Model]========],class=[========[
Model]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/8/Model]========],class=[========[
Model]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Assets/EmoteViewport/WorldModel/Rig/Head]========],class=[========[
Part]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Assets/EmoteViewport/WorldModel/Rig/HumanoidRootPart]========],class=[========[
Part]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Assets/EmoteViewport/WorldModel/Rig/Left Arm]========],class=[========[
Part]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Assets/EmoteViewport/WorldModel/Rig/Left Leg]========],class=[========[
Part]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Assets/EmoteViewport/WorldModel/Rig/Right Arm]========],class=[========[
Part]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Assets/EmoteViewport/WorldModel/Rig/Right Leg]========],class=[========[
Part]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Assets/EmoteViewport/WorldModel/Rig/Torso]========],class=[========[
Part]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/InventoryScreen/InventoryRoot/InventoryContainer/Contents/UIPadding]========],class=[========[
UIPadding]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/InventoryScreen/InventoryRoot/InfoContainer/Contents/UIPadding]========],class=[========[
UIPadding]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/InventoryScreen/InventoryRoot/SkinsContainer/Contents/UIPadding]========],class=[========[
UIPadding]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Assets/ConfirmUI/Purchase/Text/UIPadding]========],class=[========[
UIPadding]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Assets/ConfirmUI/Cancel/Text/UIPadding]========],class=[========[
UIPadding]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/Presets/Components/HeaderTemplate/Header/UIPadding]========],class=[========[
UIPadding]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/Presets/Components/HeaderTemplate/Description/UIPadding]========],class=[========[
UIPadding]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/Presets/Components/SubheaderTemplate/Header/UIPadding]========],class=[========[
UIPadding]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/InventoryScreen/InventoryRoot/InventoryContainer/Money/BuyMore]========],class=[========[
TextButton]========],text=[========[
+]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/TabButtons/Survivors]========],class=[========[
TextButton]========],text=[========[
 ]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/TabButtons/Killers]========],class=[========[
TextButton]========],text=[========[
 ]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/SortUnowned]========],class=[========[
TextButton]========],text=[========[
 ]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder/Overlay/Preview/Buy]========],class=[========[
TextButton]========],text=[========[
 ]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/UIPageLayout]========],class=[========[
UIPageLayout]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/CardTemplate/Container/Favorite/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Settings/Templates/String/Dropdown/DropdownFrame/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Settings/Templates/Bool/Checkbox/CheckboxButton/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Settings/Templates/Keybind/KeybindFrame/KeybindButton/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Emotes/Page/Search/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Emotes/Page/SortUnowned/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Emotes/Assets/Template/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Settings/Templates/Textbox/Textbox/TextboxBackground/Textbox]========],class=[========[
TextBox]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Settings/SettingsScreen/SettingsContainer/Contents/SearchBoxBackground/SearchBox]========],class=[========[
TextBox]========],text=[========[
SEARCH...]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Emotes/Page/Search/TextBox]========],class=[========[
TextBox]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Assets/EmoteViewport/WorldModel/Rig/Body Colors]========],class=[========[
BodyColors]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Emotes/Page/SortUnowned/UISizeConstraint]========],class=[========[
UISizeConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Classes/CurrencyDisplay/Preset/Plus/Icon/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/Achievements/Button/Icon/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/Spectate/Button/Icon/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/Stats/Button/Icon/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Bottom/Rules/Button/Icon/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Bottom/Settings/Button/Icon/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Bottom/UpdateLog/Button/Icon/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Bottom/AFK/Button/Icon/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Emotes/Page/Gradient/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Emotes/Page/Gradient/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Emotes/Page/Grunge/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Emotes/Page/Line/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Assets/TransitionGui/Purchase/Icon/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder/Close/Outline/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder/Close/BG/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/Presets/Components/SkinTemplate/Holder/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/Presets/Components/HeaderTemplate/Background/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/Presets/Components/SubheaderTemplate/Shine/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/UpdateScreen/Holder/Close/Outline/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/UpdateScreen/Holder/Close/BG/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Assets/EmoteViewport/WorldModel/Rig/Humanoid]========],class=[========[
Humanoid]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/InventoryScreen/InventoryRoot/InventoryContainer/Contents/UIGridLayout]========],class=[========[
UIGridLayout]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/InventoryScreen/InventoryRoot/SkinsContainer/Contents/UIGridLayout]========],class=[========[
UIGridLayout]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/Inventory/Button/Text/Name]========],class=[========[
TextLabel]========],text=[========[
Inventory]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/Achievements/Button/Text/Name]========],class=[========[
TextLabel]========],text=[========[
Achievements]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/Spectate/Button/Text/Name]========],class=[========[
TextLabel]========],text=[========[
Spectate]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/Stats/Button/Text/Name]========],class=[========[
TextLabel]========],text=[========[
Stats]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Middle/Shop/Button/Text/Name]========],class=[========[
TextLabel]========],text=[========[
Shop]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Bottom/Rules/Button/Text/Name]========],class=[========[
TextLabel]========],text=[========[
Rules]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Bottom/Settings/Button/Text/Name]========],class=[========[
TextLabel]========],text=[========[
Settings]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Bottom/UpdateLog/Button/Text/Name]========],class=[========[
TextLabel]========],text=[========[
Update Log]========]},
{path=[========[
CombatMenusPort/SidebarHandler/Sidebar/Bottom/AFK/Button/Text/Name]========],class=[========[
TextLabel]========],text=[========[
AFK Mode]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Emotes/2/Title]========],class=[========[
TextLabel]========],text=[========[
Emotes]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Emotes/3/Title]========],class=[========[
TextLabel]========],text=[========[
Emotes]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Emotes/4/Title]========],class=[========[
TextLabel]========],text=[========[
Emotes]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Emotes/5/Title]========],class=[========[
TextLabel]========],text=[========[
Emotes]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Emotes/6/Title]========],class=[========[
TextLabel]========],text=[========[
Emotes]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Emotes/7/Title]========],class=[========[
TextLabel]========],text=[========[
Emotes]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Emotes/8/Title]========],class=[========[
TextLabel]========],text=[========[
Emotes]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Emotes/1/Title]========],class=[========[
TextLabel]========],text=[========[
Emotes]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/ExtraEmotes/2/Title]========],class=[========[
TextLabel]========],text=[========[
Emotes]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/ExtraEmotes/3/Title]========],class=[========[
TextLabel]========],text=[========[
Emotes]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/ExtraEmotes/4/Title]========],class=[========[
TextLabel]========],text=[========[
Emotes]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/ExtraEmotes/5/Title]========],class=[========[
TextLabel]========],text=[========[
Emotes]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/ExtraEmotes/6/Title]========],class=[========[
TextLabel]========],text=[========[
Emotes]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/ExtraEmotes/7/Title]========],class=[========[
TextLabel]========],text=[========[
Emotes]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/ExtraEmotes/8/Title]========],class=[========[
TextLabel]========],text=[========[
Emotes]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/ExtraEmotes/1/Title]========],class=[========[
TextLabel]========],text=[========[
Emotes]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/CardTemplateShop/Container/EventPrice/Price]========],class=[========[
TextLabel]========],text=[========[
1,000]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/ConfirmPurchase/Buttons/No/Title]========],class=[========[
TextLabel]========],text=[========[
No]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/ConfirmPurchase/Buttons/Yes/Title]========],class=[========[
TextLabel]========],text=[========[
Yes]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/InventoryScreen/InventoryRoot/InventoryContainer/Money/CurrentBalance]========],class=[========[
TextLabel]========],text=[========[
0$]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/InventoryScreen/InventoryRoot/SkinsContainer/TitleDisplay/Title]========],class=[========[
TextLabel]========],text=[========[
X Skins]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/InventoryScreen/InventoryRoot/SideContainer/EquipContainer/Price]========],class=[========[
TextLabel]========],text=[========[
1,000$]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/InventoryScreen/InventoryRoot/SideContainer/PreviewContainer/Title]========],class=[========[
TextLabel]========],text=[========[
Survivor/Killer Name]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/InventoryScreen/InventoryRoot/SideContainer/PreviewContainer/Level]========],class=[========[
TextLabel]========],text=[========[
Level 100]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/InventoryScreen/InventoryRoot/SideContainer/PreviewContainer/EXP]========],class=[========[
TextLabel]========],text=[========[
100/4324 EXP]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/InventoryScreen/InventoryRoot/SideContainer/PreviewContainer/Quote]========],class=[========[
TextLabel]========],text=[========[
Survivor/Killer Quote goes here]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/InventoryScreen/InventoryRoot/SideContainer/PreviewContainer/Credits]========],class=[========[
TextLabel]========],text=[========[
Model By: someone]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder/TabButtons/Skins/Text]========],class=[========[
TextLabel]========],text=[========[
Skins]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder/TabButtons/Emotes/Text]========],class=[========[
TextLabel]========],text=[========[
Emotes]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder/Overlay/Preview/Name]========],class=[========[
TextLabel]========],text=[========[
Wonderland]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder/Overlay/Preview/Description]========],class=[========[
TextLabel]========],text=[========[
"Life is full of wonders!"]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder/Overlay/Preview/Credit]========],class=[========[
TextLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder/Overlay/Preview/Price]========],class=[========[
TextLabel]========],text=[========[
$800]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder/Overlay/Preview/OldPrice]========],class=[========[
TextLabel]========],text=[========[
$500]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/Presets/Components/SkinTemplate/Holder/Name]========],class=[========[
TextLabel]========],text=[========[
Brighteyes]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/Presets/Components/SkinTemplate/Owned/Text]========],class=[========[
TextLabel]========],text=[========[
Purchased]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/InventoryScreen/InventoryRoot/SideContainer/EquipContainer/Buttons]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/InventoryScreen/InventoryRoot/SideContainer/PreviewContainer/RenderBackground]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Rules/RulesScreen/RulesContainer/Contents/Header/Seperator]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Settings/Templates/String/Dropdown/DropdownFrame/Options]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Emotes/Assets/Template/Holder]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Search]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterButton_PRESET/Holder]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterButton_PRESET/New]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterButton_PRESET/Updated]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder/Overlay/Preview/BG]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/CardTemplate/Container/CharacterRender/UICorner]========],class=[========[
UICorner]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/CardTemplateShop/Container/CharacterRender/UICorner]========],class=[========[
UICorner]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/List]========],class=[========[
ScrollingFrame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters]========],class=[========[
ScrollingFrame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Assets/EmoteViewport/WorldModel/Rig/Head/FaceCenterAttachment]========],class=[========[
Attachment]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Assets/EmoteViewport/WorldModel/Rig/Head/FaceFrontAttachment]========],class=[========[
Attachment]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Assets/EmoteViewport/WorldModel/Rig/Head/HairAttachment]========],class=[========[
Attachment]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Assets/EmoteViewport/WorldModel/Rig/Head/HatAttachment]========],class=[========[
Attachment]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Assets/EmoteViewport/WorldModel/Rig/Left Arm/LeftShoulderAttachment]========],class=[========[
Attachment]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Assets/EmoteViewport/WorldModel/Rig/Right Arm/RightShoulderAttachment]========],class=[========[
Attachment]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Assets/EmoteViewport/WorldModel/Rig/Torso/BodyBackAttachment]========],class=[========[
Attachment]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Assets/EmoteViewport/WorldModel/Rig/Torso/BodyFrontAttachment]========],class=[========[
Attachment]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Assets/EmoteViewport/WorldModel/Rig/Torso/LeftCollarAttachment]========],class=[========[
Attachment]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Assets/EmoteViewport/WorldModel/Rig/Torso/NeckAttachment]========],class=[========[
Attachment]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Assets/EmoteViewport/WorldModel/Rig/Torso/RightCollarAttachment]========],class=[========[
Attachment]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Assets/EmoteViewport/WorldModel/Rig/Torso/WaistBackAttachment]========],class=[========[
Attachment]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Assets/EmoteViewport/WorldModel/Rig/Torso/WaistCenterAttachment]========],class=[========[
Attachment]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Assets/EmoteViewport/WorldModel/Rig/Torso/WaistFrontAttachment]========],class=[========[
Attachment]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/InventoryScreen/InventoryRoot/SideContainer/EquipContainer/Buttons/ViewSkins]========],class=[========[
ImageButton]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/InventoryScreen/InventoryRoot/SideContainer/EquipContainer/Buttons/ViewInfo]========],class=[========[
ImageButton]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Emotes/Assets/Template/Holder/Render]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Emotes/Assets/Template/Holder/Texture]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Emotes/Assets/Template/Holder/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Emotes/Assets/Template/Holder/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Emotes/Assets/Template/Holder/Line]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Emotes/Assets/Template/Holder/DiscountTag]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/TabButtons/Survivors/BG]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/TabButtons/Survivors/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/TabButtons/Survivors/Outline]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/TabButtons/Survivors/Texture]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/TabButtons/Survivors/Vignette]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/TabButtons/Survivors/Shadow]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/TabButtons/Survivors/Highlight]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/TabButtons/Killers/BG]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/TabButtons/Killers/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/TabButtons/Killers/Outline]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/TabButtons/Killers/Texture]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/TabButtons/Killers/Shadow]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/TabButtons/Killers/Vignette]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/TabButtons/Killers/Highlight]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Search/Line]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Search/Icon]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Search/Texture]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Search/BG]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/SortUnowned/Outline]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/SortUnowned/Texture]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/SortUnowned/Vignette]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/SortUnowned/Shadow]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/SortUnowned/Icon]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/SortUnowned/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/SortUnowned/BG]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterButton_PRESET/Holder/Render]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterButton_PRESET/Holder/Texture]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterButton_PRESET/Holder/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterButton_PRESET/New/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterButton_PRESET/Updated/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder/Overlay/Preview/Buy/Line]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder/Overlay/Preview/Buy/Shadow]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder/Overlay/Preview/Buy/Highlight]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder/Overlay/Preview/Buy/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder/Overlay/Preview/BG/Texture]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder/Overlay/Preview/BG/Render]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/InventoryScreen/InventoryRoot/SideContainer/EquipContainer/Buttons/UIListLayout]========],class=[========[
UIListLayout]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Settings/Templates/String/Dropdown/DropdownFrame/Options/UIListLayout]========],class=[========[
UIListLayout]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/List/UIListLayout]========],class=[========[
UIListLayout]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/UIListLayout]========],class=[========[
UIListLayout]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Assets/EmoteViewport/WorldModel/Rig/HumanoidRootPart/RootJoint]========],class=[========[
Motor6D]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Assets/EmoteViewport/WorldModel/Rig/Torso/Left Hip]========],class=[========[
Motor6D]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Assets/EmoteViewport/WorldModel/Rig/Torso/Left Shoulder]========],class=[========[
Motor6D]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Assets/EmoteViewport/WorldModel/Rig/Torso/Neck]========],class=[========[
Motor6D]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Assets/EmoteViewport/WorldModel/Rig/Torso/Right Hip]========],class=[========[
Motor6D]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Assets/EmoteViewport/WorldModel/Rig/Torso/Right Shoulder]========],class=[========[
Motor6D]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/InventoryScreen/InventoryRoot/InventoryContainer/Money/BuyMore/UIPadding]========],class=[========[
UIPadding]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/InventoryScreen/InventoryRoot/InventoryContainer/Money/CurrentBalance/UIPadding]========],class=[========[
UIPadding]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Emotes/Page/Search/TextBox/UIPadding]========],class=[========[
UIPadding]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/List/UIPadding]========],class=[========[
UIPadding]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder/TabButtons/Skins/Text/UIPadding]========],class=[========[
UIPadding]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder/TabButtons/Emotes/Text/UIPadding]========],class=[========[
UIPadding]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/SortUnowned]========],class=[========[
TextButton]========],text=[========[
 ]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/SortUnowned]========],class=[========[
TextButton]========],text=[========[
 ]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/List/Template]========],class=[========[
TextButton]========],text=[========[
 ]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/Slasher]========],class=[========[
TextButton]========],text=[========[
 ]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/c00lKidd]========],class=[========[
TextButton]========],text=[========[
 ]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/JohnDoe]========],class=[========[
TextButton]========],text=[========[
 ]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/Noli]========],class=[========[
TextButton]========],text=[========[
 ]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/1x1x1x1]========],class=[========[
TextButton]========],text=[========[
 ]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/Guest 666]========],class=[========[
TextButton]========],text=[========[
 ]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/Nosferatu]========],class=[========[
TextButton]========],text=[========[
 ]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder/Overlay/Preview/OldPrice/Outer]========],class=[========[
UIStroke]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/Presets/Components/SkinTemplate/Holder/Name/Outer]========],class=[========[
UIStroke]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder/Overlay/Preview/Description/UITextSizeConstraint]========],class=[========[
UITextSizeConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/InventoryScreen/InventoryRoot/InventoryContainer/Money/BuyMore/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Settings/Templates/Number/Slider/DragBar/Dragger/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Search/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/SortUnowned/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterButton_PRESET/Holder/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder/Overlay/Preview/Buy/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder/Overlay/Preview/DiscountTag/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Assets/EmoteViewport/WorldModel/Rig/Humanoid/Animator]========],class=[========[
Animator]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/InventoryScreen/InventoryRoot/InventoryContainer/Topbar/Searchbar/TextBox]========],class=[========[
TextBox]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/InventoryScreen/InventoryRoot/SkinsContainer/Topbar/Searchbar/TextBox]========],class=[========[
TextBox]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Search/TextBox]========],class=[========[
TextBox]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Assets/EmoteViewport/WorldModel/Rig/Head/Decal]========],class=[========[
Decal]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Assets/EmoteViewport/WorldModel/Rig/Torso/roblox]========],class=[========[
Decal]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/SortUnowned/UISizeConstraint]========],class=[========[
UISizeConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/InventoryScreen/InventoryRoot/SideContainer/PreviewContainer/EXPBar/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/InventoryScreen/InventoryRoot/SideContainer/PreviewContainer/RenderBackground/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Emotes/Page/Search/Texture/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Emotes/Page/Search/BG/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Emotes/Page/SortUnowned/Outline/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Emotes/Page/SortUnowned/BG/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Emotes/Assets/Template/Holder/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterButton_PRESET/Holder/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder/TabButtons/Skins/BG/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder/TabButtons/Skins/Highlight/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder/TabButtons/Emotes/BG/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder/TabButtons/Emotes/Highlight/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder/Overlay/Preview/Shadow/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder/Overlay/Preview/Texture/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder/Overlay/Preview/Price/DiscountGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/Presets/Components/SkinTemplate/Holder/Render/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/Presets/Components/SkinTemplate/Holder/Grunge/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/UpdateLog/Presets/Components/SkinTemplate/Owned/Text/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Assets/EmoteViewport/WorldModel/Rig/Head/Mesh]========],class=[========[
SpecialMesh]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/1/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/1/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/1/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/1/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/1/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/1/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/1/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/1/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/1/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/1/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/1/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/1/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/1/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/1/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/1/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/1/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/1/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/1/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/1/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/1/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/2/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/2/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/2/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/2/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/2/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/2/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/2/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/2/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/2/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/2/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/2/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/2/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/2/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/2/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/2/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/2/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/2/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/2/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/2/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/2/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/3/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/3/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/3/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/3/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/3/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/3/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/3/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/3/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/3/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/3/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/3/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/3/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/3/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/3/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/3/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/3/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/3/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/3/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/3/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/3/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/4/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/4/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/4/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/4/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/4/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/4/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/4/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/4/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/4/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/4/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/4/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/4/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/4/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/4/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/4/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/4/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/4/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/4/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/4/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/4/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/5/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/5/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/5/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/5/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/5/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/5/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/5/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/5/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/5/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/5/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/5/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/5/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/5/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/5/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/5/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/5/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/5/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/5/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/5/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/5/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/6/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/6/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/6/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/6/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/6/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/6/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/6/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/6/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/6/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/6/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/6/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/6/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/6/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/6/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/6/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/6/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/6/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/6/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/6/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/6/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/7/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/7/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/7/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/7/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/7/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/7/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/7/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/7/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/7/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/7/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/7/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/7/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/7/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/7/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/7/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/7/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/7/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/7/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/7/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/7/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/8/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/8/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/8/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/8/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/8/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/8/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/8/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/8/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/8/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/8/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/8/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/8/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/8/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/8/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/8/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/8/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/8/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/8/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/8/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/Templates/EmoteMenuHolder/Radial/8/Model/Wedge]========],class=[========[
WedgePart]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/InventoryScreen/InventoryRoot/InventoryContainer/Topbar/Survivors/Title]========],class=[========[
TextLabel]========],text=[========[
Survivors]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/InventoryScreen/InventoryRoot/InventoryContainer/Topbar/Killers/Title]========],class=[========[
TextLabel]========],text=[========[
Killers]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/InventoryScreen/InventoryRoot/InventoryContainer/Topbar/Emotes/Title]========],class=[========[
TextLabel]========],text=[========[
Emotes]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/InventoryScreen/InventoryRoot/SideContainer/EquipContainer/Equip/Title]========],class=[========[
TextLabel]========],text=[========[
Equip]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/InventoryScreen/InventoryRoot/SideContainer/EquipContainer/ButtonDescription/Title]========],class=[========[
TextLabel]========],text=[========[
1,000$]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/InventoryScreen/InventoryRoot/SideContainer/EquipContainer/Purchase/Title]========],class=[========[
TextLabel]========],text=[========[
Purchase]========]},
{path=[========[
CombatMenusPort/Menus/Settings/Templates/String/Dropdown/DropdownFrame/ChosenValue/Title]========],class=[========[
TextLabel]========],text=[========[
Option 1]========]},
{path=[========[
CombatMenusPort/Menus/Settings/Templates/Number/Slider/DragBar/Dragger/Title]========],class=[========[
TextLabel]========],text=[========[
70]========]},
{path=[========[
CombatMenusPort/Menus/Settings/Templates/Keybind/KeybindFrame/KeybindButton/CurrentBind/Title]========],class=[========[
TextLabel]========],text=[========[
E]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Emotes/Assets/Template/Holder/Name]========],class=[========[
TextLabel]========],text=[========[
Emote name]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Emotes/Assets/Template/Holder/Price]========],class=[========[
TextLabel]========],text=[========[
$450]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Emotes/Assets/Template/Holder/OldPrice]========],class=[========[
TextLabel]========],text=[========[
$500]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/TabButtons/Survivors/Text]========],class=[========[
TextLabel]========],text=[========[
Survivors]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/TabButtons/Killers/Text]========],class=[========[
TextLabel]========],text=[========[
Killers]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterButton_PRESET/Holder/Name]========],class=[========[
TextLabel]========],text=[========[
John doe]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterButton_PRESET/New/New]========],class=[========[
TextLabel]========],text=[========[
NEW]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterButton_PRESET/Updated/Updated]========],class=[========[
TextLabel]========],text=[========[
UPDATED]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder/Overlay/Preview/Buy/Text]========],class=[========[
TextLabel]========],text=[========[
BUY]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/InventoryScreen/InventoryRoot/SideContainer/PreviewContainer/EXPBar/Clipping]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Rules/RulesScreen/RulesContainer/Contents/Header/Seperator/Main]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Emotes/Assets/Template/Holder/New]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Emotes/Assets/Template/Holder/Timer]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Emotes/Assets/Template/Holder/Owned]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Emotes/Assets/Template/Holder/Loading]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Emotes/Assets/Template/Holder/Updated]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Search]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Search]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder/Overlay/Preview/OldPrice/Strikethrough]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Emotes/Assets/Template/Holder/CardIcons]========],class=[========[
ScrollingFrame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/List]========],class=[========[
ScrollingFrame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters]========],class=[========[
ScrollingFrame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/List]========],class=[========[
ScrollingFrame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters]========],class=[========[
ScrollingFrame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/InventoryScreen/InventoryRoot/SideContainer/EquipContainer/Buttons/ViewSkins/Inverted]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/InventoryScreen/InventoryRoot/SideContainer/EquipContainer/Buttons/ViewInfo/Inverted]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/InventoryScreen/InventoryRoot/SideContainer/PreviewContainer/EXPBar/Clipping/Top]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Emotes/Assets/Template/Holder/New/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Emotes/Assets/Template/Holder/Timer/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Emotes/Assets/Template/Holder/Owned/BG]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Emotes/Assets/Template/Holder/Loading/BG]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Emotes/Assets/Template/Holder/Loading/Icon]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Emotes/Assets/Template/Holder/Updated/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/SortUnowned/Outline]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/SortUnowned/Texture]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/SortUnowned/Vignette]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/SortUnowned/Shadow]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/SortUnowned/Icon]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/SortUnowned/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/SortUnowned/BG]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Search/Line]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Search/Icon]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Search/Texture]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Search/BG]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/SortUnowned/Outline]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/SortUnowned/Texture]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/SortUnowned/Vignette]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/SortUnowned/Shadow]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/SortUnowned/Icon]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/SortUnowned/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/SortUnowned/BG]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Search/Line]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Search/Icon]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Search/Texture]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Search/BG]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/List/Template/Shadow]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Emotes/Assets/Template/Holder/CardIcons/UIListLayout]========],class=[========[
UIListLayout]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/List/UIListLayout]========],class=[========[
UIListLayout]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/UIListLayout]========],class=[========[
UIListLayout]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/List/UIListLayout]========],class=[========[
UIListLayout]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/UIListLayout]========],class=[========[
UIListLayout]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/List/UIPadding]========],class=[========[
UIPadding]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/List/UIPadding]========],class=[========[
UIPadding]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/TabButtons/Survivors/Text/UIPadding]========],class=[========[
UIPadding]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/TabButtons/Killers/Text/UIPadding]========],class=[========[
UIPadding]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Search/TextBox/UIPadding]========],class=[========[
UIPadding]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder/Overlay/Preview/Buy/Text/UIPadding]========],class=[========[
UIPadding]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/List/Template]========],class=[========[
TextButton]========],text=[========[
 ]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/Slasher]========],class=[========[
TextButton]========],text=[========[
 ]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/c00lKidd]========],class=[========[
TextButton]========],text=[========[
 ]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/JohnDoe]========],class=[========[
TextButton]========],text=[========[
 ]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/Noli]========],class=[========[
TextButton]========],text=[========[
 ]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/1x1x1x1]========],class=[========[
TextButton]========],text=[========[
 ]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/Guest 666]========],class=[========[
TextButton]========],text=[========[
 ]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/Nosferatu]========],class=[========[
TextButton]========],text=[========[
 ]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/Azure]========],class=[========[
TextButton]========],text=[========[
 ]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/List/Template]========],class=[========[
TextButton]========],text=[========[
 ]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Shedletsky]========],class=[========[
TextButton]========],text=[========[
 ]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Elliot]========],class=[========[
TextButton]========],text=[========[
 ]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Noob]========],class=[========[
TextButton]========],text=[========[
 ]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Builderman]========],class=[========[
TextButton]========],text=[========[
 ]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/007n7]========],class=[========[
TextButton]========],text=[========[
 ]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/TwoTime]========],class=[========[
TextButton]========],text=[========[
 ]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/TwoTime]========],class=[========[
TextButton]========],text=[========[
 ]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Taph]========],class=[========[
TextButton]========],text=[========[
 ]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Dusekkar]========],class=[========[
TextButton]========],text=[========[
 ]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Chance]========],class=[========[
TextButton]========],text=[========[
 ]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Veeronica]========],class=[========[
TextButton]========],text=[========[
 ]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Padding]========],class=[========[
TextButton]========],text=[========[
 ]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Emotes/Assets/Template/Holder/OldPrice/Outer]========],class=[========[
UIStroke]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterButton_PRESET/Holder/Name/Outer]========],class=[========[
UIStroke]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/InventoryScreen/InventoryRoot/SideContainer/EquipContainer/Buttons/ViewSkins/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/InventoryScreen/InventoryRoot/SideContainer/EquipContainer/Buttons/ViewInfo/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Emotes/Assets/Template/Holder/DiscountTag/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/SortUnowned/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Search/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/SortUnowned/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Search/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/List/Template/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Search/TextBox]========],class=[========[
TextBox]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Search/TextBox]========],class=[========[
TextBox]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/SortUnowned/UISizeConstraint]========],class=[========[
UISizeConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/SortUnowned/UISizeConstraint]========],class=[========[
UISizeConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Emotes/Assets/Template/Holder/Grunge/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Emotes/Assets/Template/Holder/Price/DiscountGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/TabButtons/Survivors/BG/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/TabButtons/Survivors/Highlight/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/TabButtons/Killers/BG/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/TabButtons/Killers/Outline/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/TabButtons/Killers/Highlight/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Search/Texture/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Search/BG/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/SortUnowned/Outline/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/SortUnowned/BG/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterButton_PRESET/Holder/Render/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Shop/Holder/Overlay/Preview/BG/Render/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/InventoryScreen/InventoryRoot/SideContainer/EquipContainer/Buttons/ViewSkins/Title]========],class=[========[
TextLabel]========],text=[========[
Skins]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/InventoryScreen/InventoryRoot/SideContainer/EquipContainer/Buttons/ViewInfo/Title]========],class=[========[
TextLabel]========],text=[========[
Info]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Emotes/Assets/Template/Holder/New/New]========],class=[========[
TextLabel]========],text=[========[
NEW]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Emotes/Assets/Template/Holder/Owned/Text]========],class=[========[
TextLabel]========],text=[========[
Purchased]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Emotes/Assets/Template/Holder/Loading/Text]========],class=[========[
TextLabel]========],text=[========[
Loading...]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Emotes/Assets/Template/Holder/Updated/Updated]========],class=[========[
TextLabel]========],text=[========[
UPDATED]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Emotes/Assets/Template/Holder/Timer/Time]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Emotes/Assets/Template/Holder/OldPrice/Strikethrough]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/List/Template/Holder]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/Slasher/Holder]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/Slasher/New]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/Slasher/Updated]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/c00lKidd/Holder]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/c00lKidd/New]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/c00lKidd/Updated]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/JohnDoe/Holder]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/JohnDoe/New]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/JohnDoe/Updated]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/Noli/Holder]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/Noli/New]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/Noli/Updated]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/1x1x1x1/Holder]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/1x1x1x1/New]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/1x1x1x1/Updated]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/Guest 666/Holder]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/Guest 666/New]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/Guest 666/Updated]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/Nosferatu/Holder]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/Nosferatu/New]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/Nosferatu/Updated]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Emotes/Assets/Template/Holder/Timer/Time/Icon]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/List/Template/Shadow]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/List/Template/Shadow]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/List/Template/Holder/Render]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/List/Template/Holder/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/List/Template/Holder/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/List/Template/Holder/Line]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/List/Template/Holder/Texture]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/Slasher/Holder/Render]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/Slasher/Holder/Texture]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/Slasher/Holder/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/Slasher/New/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/Slasher/Updated/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/c00lKidd/Holder/Render]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/c00lKidd/Holder/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/c00lKidd/Holder/Texture]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/c00lKidd/New/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/c00lKidd/Updated/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/JohnDoe/Holder/Render]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/JohnDoe/Holder/Texture]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/JohnDoe/Holder/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/JohnDoe/New/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/JohnDoe/Updated/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/Noli/Holder/Render]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/Noli/Holder/Texture]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/Noli/Holder/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/Noli/New/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/Noli/Updated/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/1x1x1x1/Holder/Render]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/1x1x1x1/Holder/Texture]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/1x1x1x1/Holder/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/1x1x1x1/New/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/1x1x1x1/Updated/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/Guest 666/Holder/Render]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/Guest 666/Holder/Texture]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/Guest 666/Holder/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/Guest 666/New/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/Guest 666/Updated/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/Nosferatu/Holder/Render]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/Nosferatu/Holder/Texture]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/Nosferatu/Holder/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/Nosferatu/New/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/Nosferatu/Updated/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Emotes/Assets/Template/Holder/Timer/Time/UIListLayout]========],class=[========[
UIListLayout]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Search/TextBox/UIPadding]========],class=[========[
UIPadding]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Search/TextBox/UIPadding]========],class=[========[
UIPadding]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/List/Template/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/List/Template/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/Slasher/Holder/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/c00lKidd/Holder/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/JohnDoe/Holder/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/Noli/Holder/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/1x1x1x1/Holder/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/Guest 666/Holder/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/Nosferatu/Holder/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Inventory/InventoryScreen/InventoryRoot/SideContainer/PreviewContainer/EXPBar/Clipping/Top/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Emotes/Assets/Template/Holder/Loading/Text/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Emotes/Assets/Template/Holder/Loading/Icon/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/SortUnowned/Outline/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/SortUnowned/BG/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Search/Texture/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Search/BG/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/SortUnowned/Outline/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/SortUnowned/BG/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Search/Texture/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Search/BG/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/List/Template/Holder/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/Slasher/Holder/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/c00lKidd/Holder/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/JohnDoe/Holder/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/Noli/Holder/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/1x1x1x1/Holder/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/Guest 666/Holder/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/Nosferatu/Holder/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Emotes/Assets/Template/Holder/Timer/Time/Name]========],class=[========[
TextLabel]========],text=[========[
23:59:59]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/List/Template/Holder/Name]========],class=[========[
TextLabel]========],text=[========[
Skin]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/List/Template/Holder/Price]========],class=[========[
TextLabel]========],text=[========[
$500]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/Slasher/Holder/Name]========],class=[========[
TextLabel]========],text=[========[
Slasher]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/Slasher/New/New]========],class=[========[
TextLabel]========],text=[========[
NEW]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/Slasher/Updated/Updated]========],class=[========[
TextLabel]========],text=[========[
UPDATED]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/c00lKidd/Holder/Name]========],class=[========[
TextLabel]========],text=[========[
c00lkidd]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/c00lKidd/New/New]========],class=[========[
TextLabel]========],text=[========[
NEW]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/c00lKidd/Updated/Updated]========],class=[========[
TextLabel]========],text=[========[
UPDATED]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/JohnDoe/Holder/Name]========],class=[========[
TextLabel]========],text=[========[
John doe]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/JohnDoe/New/New]========],class=[========[
TextLabel]========],text=[========[
NEW]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/JohnDoe/Updated/Updated]========],class=[========[
TextLabel]========],text=[========[
UPDATED]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/Noli/Holder/Name]========],class=[========[
TextLabel]========],text=[========[
Noli]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/Noli/New/New]========],class=[========[
TextLabel]========],text=[========[
NEW]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/Noli/Updated/Updated]========],class=[========[
TextLabel]========],text=[========[
UPDATED]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/1x1x1x1/Holder/Name]========],class=[========[
TextLabel]========],text=[========[
1x1x1x1]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/1x1x1x1/New/New]========],class=[========[
TextLabel]========],text=[========[
NEW]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/1x1x1x1/Updated/Updated]========],class=[========[
TextLabel]========],text=[========[
UPDATED]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/Guest 666/Holder/Name]========],class=[========[
TextLabel]========],text=[========[
Guest 666]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/Guest 666/New/New]========],class=[========[
TextLabel]========],text=[========[
NEW]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/Guest 666/Updated/Updated]========],class=[========[
TextLabel]========],text=[========[
UPDATED]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/Nosferatu/Holder/Name]========],class=[========[
TextLabel]========],text=[========[
Nosferatu]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/Nosferatu/New/New]========],class=[========[
TextLabel]========],text=[========[
NEW]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/Nosferatu/Updated/Updated]========],class=[========[
TextLabel]========],text=[========[
UPDATED]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/List/Template/Holder]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/Slasher/Holder]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/Slasher/New]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/Slasher/Updated]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/c00lKidd/Holder]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/c00lKidd/New]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/c00lKidd/Updated]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/JohnDoe/Holder]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/JohnDoe/New]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/JohnDoe/Updated]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/Noli/Holder]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/Noli/New]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/Noli/Updated]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/1x1x1x1/Holder]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/1x1x1x1/New]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/1x1x1x1/Updated]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/Guest 666/Holder]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/Guest 666/New]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/Guest 666/Updated]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/Nosferatu/Holder]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/Nosferatu/New]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/Nosferatu/Updated]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/Azure/Holder]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/Azure/New]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/Azure/Updated]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/List/Template/Holder]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Shedletsky/Holder]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Shedletsky/New]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Shedletsky/Updated]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Elliot/Holder]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Elliot/New]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Elliot/Updated]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Noob/Holder]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Noob/New]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Noob/Updated]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Builderman/Holder]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Builderman/New]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Builderman/Updated]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/007n7/Holder]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/007n7/New]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/007n7/Updated]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/TwoTime/Holder]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/TwoTime/New]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/TwoTime/Updated]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/TwoTime/Holder]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/TwoTime/New]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/TwoTime/Updated]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Taph/Holder]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Taph/New]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Taph/Updated]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Dusekkar/Holder]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Dusekkar/New]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Dusekkar/Updated]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Chance/Holder]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Chance/New]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Chance/Updated]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Veeronica/Holder]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Veeronica/New]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Veeronica/Updated]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/List/Template/Holder/New]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/List/Template/Holder/Timer]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/List/Template/Holder/Owned]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/List/Template/Holder/Updated]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/List/Template/Holder/CardIcons]========],class=[========[
ScrollingFrame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/List/Template/Holder/Render]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/List/Template/Holder/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/List/Template/Holder/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/List/Template/Holder/Line]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/List/Template/Holder/Texture]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/List/Template/Holder/DiscountTag]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/Slasher/Holder/Render]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/Slasher/Holder/Texture]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/Slasher/Holder/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/Slasher/New/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/Slasher/Updated/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/c00lKidd/Holder/Render]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/c00lKidd/Holder/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/c00lKidd/Holder/Texture]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/c00lKidd/New/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/c00lKidd/Updated/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/JohnDoe/Holder/Render]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/JohnDoe/Holder/Texture]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/JohnDoe/Holder/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/JohnDoe/New/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/JohnDoe/Updated/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/Noli/Holder/Render]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/Noli/Holder/Texture]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/Noli/Holder/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/Noli/New/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/Noli/Updated/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/1x1x1x1/Holder/Render]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/1x1x1x1/Holder/Texture]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/1x1x1x1/Holder/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/1x1x1x1/New/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/1x1x1x1/Updated/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/Guest 666/Holder/Render]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/Guest 666/Holder/Texture]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/Guest 666/Holder/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/Guest 666/New/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/Guest 666/Updated/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/Nosferatu/Holder/Render]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/Nosferatu/Holder/Texture]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/Nosferatu/Holder/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/Nosferatu/New/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/Nosferatu/Updated/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/Azure/Holder/Render]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/Azure/Holder/Texture]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/Azure/Holder/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/Azure/New/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/Azure/Updated/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/List/Template/Holder/Render]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/List/Template/Holder/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/List/Template/Holder/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/List/Template/Holder/Line]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/List/Template/Holder/Texture]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/List/Template/Holder/DiscountTag]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Shedletsky/Holder/Render]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Shedletsky/Holder/Texture]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Shedletsky/Holder/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Shedletsky/New/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Shedletsky/Updated/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Elliot/Holder/Render]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Elliot/Holder/Texture]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Elliot/Holder/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Elliot/New/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Elliot/Updated/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Noob/Holder/Render]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Noob/Holder/Texture]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Noob/Holder/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Noob/New/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Noob/Updated/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Builderman/Holder/Render]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Builderman/Holder/Texture]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Builderman/Holder/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Builderman/New/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Builderman/Updated/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/007n7/Holder/Render]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/007n7/Holder/Texture]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/007n7/Holder/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/007n7/New/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/007n7/Updated/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/TwoTime/Holder/Render]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/TwoTime/Holder/Texture]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/TwoTime/Holder/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/TwoTime/New/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/TwoTime/Updated/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/TwoTime/Holder/Render]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/TwoTime/Holder/Texture]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/TwoTime/Holder/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/TwoTime/New/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/TwoTime/Updated/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Taph/Holder/Render]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Taph/Holder/Texture]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Taph/Holder/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Taph/New/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Taph/Updated/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Dusekkar/Holder/Render]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Dusekkar/Holder/Texture]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Dusekkar/Holder/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Dusekkar/New/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Dusekkar/Updated/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Chance/Holder/Render]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Chance/Holder/Texture]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Chance/Holder/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Chance/New/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Chance/Updated/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Veeronica/Holder/Render]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Veeronica/Holder/Texture]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Veeronica/Holder/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Veeronica/New/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Veeronica/Updated/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/List/Template/Holder/New/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/List/Template/Holder/Timer/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/List/Template/Holder/Owned/BG]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/List/Template/Holder/Updated/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/List/Template/Holder/CardIcons/UIListLayout]========],class=[========[
UIListLayout]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/List/Template/Holder/Name/Outer]========],class=[========[
UIStroke]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/List/Template/Holder/Price/Outer]========],class=[========[
UIStroke]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/Slasher/Holder/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/c00lKidd/Holder/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/JohnDoe/Holder/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/Noli/Holder/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/1x1x1x1/Holder/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/Guest 666/Holder/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/Nosferatu/Holder/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/Azure/Holder/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Shedletsky/Holder/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Elliot/Holder/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Noob/Holder/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Builderman/Holder/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/007n7/Holder/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/TwoTime/Holder/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/TwoTime/Holder/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Taph/Holder/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Dusekkar/Holder/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Chance/Holder/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Veeronica/Holder/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/List/Template/Holder/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/Slasher/Holder/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/c00lKidd/Holder/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/JohnDoe/Holder/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/Noli/Holder/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/1x1x1x1/Holder/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/Guest 666/Holder/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/Nosferatu/Holder/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/Azure/Holder/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/List/Template/Holder/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Shedletsky/Holder/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Elliot/Holder/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Noob/Holder/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Builderman/Holder/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/007n7/Holder/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/TwoTime/Holder/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/TwoTime/Holder/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Taph/Holder/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Dusekkar/Holder/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Chance/Holder/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Veeronica/Holder/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/List/Template/Holder/Render/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/List/Template/Holder/Grunge/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/Slasher/Holder/Render/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/c00lKidd/Holder/Render/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/JohnDoe/Holder/Render/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/Noli/Holder/Render/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/1x1x1x1/Holder/Render/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/Guest 666/Holder/Render/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/Characters/Nosferatu/Holder/Render/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/List/Template/Holder/Name]========],class=[========[
TextLabel]========],text=[========[
Skin]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/List/Template/Holder/OldPrice]========],class=[========[
TextLabel]========],text=[========[
$500]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/List/Template/Holder/Price]========],class=[========[
TextLabel]========],text=[========[
$500]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/Slasher/Holder/Name]========],class=[========[
TextLabel]========],text=[========[
Slasher]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/Slasher/New/New]========],class=[========[
TextLabel]========],text=[========[
NEW]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/Slasher/Updated/Updated]========],class=[========[
TextLabel]========],text=[========[
UPDATED]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/c00lKidd/Holder/Name]========],class=[========[
TextLabel]========],text=[========[
c00lkidd]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/c00lKidd/New/New]========],class=[========[
TextLabel]========],text=[========[
NEW]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/c00lKidd/Updated/Updated]========],class=[========[
TextLabel]========],text=[========[
UPDATED]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/JohnDoe/Holder/Name]========],class=[========[
TextLabel]========],text=[========[
John doe]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/JohnDoe/New/New]========],class=[========[
TextLabel]========],text=[========[
NEW]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/JohnDoe/Updated/Updated]========],class=[========[
TextLabel]========],text=[========[
UPDATED]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/Noli/Holder/Name]========],class=[========[
TextLabel]========],text=[========[
Noli]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/Noli/New/New]========],class=[========[
TextLabel]========],text=[========[
NEW]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/Noli/Updated/Updated]========],class=[========[
TextLabel]========],text=[========[
UPDATED]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/1x1x1x1/Holder/Name]========],class=[========[
TextLabel]========],text=[========[
1x1x1x1]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/1x1x1x1/New/New]========],class=[========[
TextLabel]========],text=[========[
NEW]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/1x1x1x1/Updated/Updated]========],class=[========[
TextLabel]========],text=[========[
UPDATED]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/Guest 666/Holder/Name]========],class=[========[
TextLabel]========],text=[========[
Guest 666]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/Guest 666/New/New]========],class=[========[
TextLabel]========],text=[========[
NEW]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/Guest 666/Updated/Updated]========],class=[========[
TextLabel]========],text=[========[
UPDATED]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/Nosferatu/Holder/Name]========],class=[========[
TextLabel]========],text=[========[
Nosferatu]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/Nosferatu/New/New]========],class=[========[
TextLabel]========],text=[========[
NEW]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/Nosferatu/Updated/Updated]========],class=[========[
TextLabel]========],text=[========[
UPDATED]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/Azure/Holder/Name]========],class=[========[
TextLabel]========],text=[========[
Azure]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/Azure/New/New]========],class=[========[
TextLabel]========],text=[========[
NEW]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/Azure/Updated/Updated]========],class=[========[
TextLabel]========],text=[========[
UPDATED]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/List/Template/Holder/Name]========],class=[========[
TextLabel]========],text=[========[
Skin]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/List/Template/Holder/OldPrice]========],class=[========[
TextLabel]========],text=[========[
$500]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/List/Template/Holder/Price]========],class=[========[
TextLabel]========],text=[========[
$500]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Shedletsky/Holder/Name]========],class=[========[
TextLabel]========],text=[========[
Shedletsky]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Shedletsky/New/New]========],class=[========[
TextLabel]========],text=[========[
NEW]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Shedletsky/Updated/Updated]========],class=[========[
TextLabel]========],text=[========[
UPDATED]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Elliot/Holder/Name]========],class=[========[
TextLabel]========],text=[========[
Elliot]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Elliot/New/New]========],class=[========[
TextLabel]========],text=[========[
NEW]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Elliot/Updated/Updated]========],class=[========[
TextLabel]========],text=[========[
UPDATED]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Noob/Holder/Name]========],class=[========[
TextLabel]========],text=[========[
Noob]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Noob/New/New]========],class=[========[
TextLabel]========],text=[========[
NEW]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Noob/Updated/Updated]========],class=[========[
TextLabel]========],text=[========[
UPDATED]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Builderman/Holder/Name]========],class=[========[
TextLabel]========],text=[========[
Builderman]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Builderman/New/New]========],class=[========[
TextLabel]========],text=[========[
NEW]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Builderman/Updated/Updated]========],class=[========[
TextLabel]========],text=[========[
UPDATED]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/007n7/Holder/Name]========],class=[========[
TextLabel]========],text=[========[
007n7]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/007n7/New/New]========],class=[========[
TextLabel]========],text=[========[
NEW]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/007n7/Updated/Updated]========],class=[========[
TextLabel]========],text=[========[
UPDATED]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/TwoTime/Holder/Name]========],class=[========[
TextLabel]========],text=[========[
Two Time]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/TwoTime/New/New]========],class=[========[
TextLabel]========],text=[========[
NEW]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/TwoTime/Updated/Updated]========],class=[========[
TextLabel]========],text=[========[
UPDATED]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/TwoTime/Holder/Name]========],class=[========[
TextLabel]========],text=[========[
Guest 1337]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/TwoTime/New/New]========],class=[========[
TextLabel]========],text=[========[
NEW]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/TwoTime/Updated/Updated]========],class=[========[
TextLabel]========],text=[========[
UPDATED]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Taph/Holder/Name]========],class=[========[
TextLabel]========],text=[========[
Taph]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Taph/New/New]========],class=[========[
TextLabel]========],text=[========[
NEW]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Taph/Updated/Updated]========],class=[========[
TextLabel]========],text=[========[
UPDATED]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Dusekkar/Holder/Name]========],class=[========[
TextLabel]========],text=[========[
Dusekkar]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Dusekkar/New/New]========],class=[========[
TextLabel]========],text=[========[
NEW]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Dusekkar/Updated/Updated]========],class=[========[
TextLabel]========],text=[========[
UPDATED]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Chance/Holder/Name]========],class=[========[
TextLabel]========],text=[========[
Chance]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Chance/New/New]========],class=[========[
TextLabel]========],text=[========[
NEW]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Chance/Updated/Updated]========],class=[========[
TextLabel]========],text=[========[
UPDATED]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Veeronica/Holder/Name]========],class=[========[
TextLabel]========],text=[========[
Veeronica]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Veeronica/New/New]========],class=[========[
TextLabel]========],text=[========[
NEW]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Veeronica/Updated/Updated]========],class=[========[
TextLabel]========],text=[========[
UPDATED]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/List/Template/Holder/New/New]========],class=[========[
TextLabel]========],text=[========[
NEW]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/List/Template/Holder/Owned/Text]========],class=[========[
TextLabel]========],text=[========[
Purchased]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/List/Template/Holder/Updated/Updated]========],class=[========[
TextLabel]========],text=[========[
UPDATED]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/List/Template/Holder/New]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/List/Template/Holder/Timer]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/List/Template/Holder/Owned]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/List/Template/Holder/Updated]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/List/Template/Holder/New]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/List/Template/Holder/Timer]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/List/Template/Holder/Owned]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/List/Template/Holder/Updated]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/List/Template/Holder/Timer/Time]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/List/Template/Holder/CardIcons]========],class=[========[
ScrollingFrame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/List/Template/Holder/CardIcons]========],class=[========[
ScrollingFrame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/List/Template/Holder/New/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/List/Template/Holder/Timer/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/List/Template/Holder/Owned/BG]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/List/Template/Holder/Updated/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/List/Template/Holder/New/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/List/Template/Holder/Timer/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/List/Template/Holder/Owned/BG]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/List/Template/Holder/Updated/Grunge]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/List/Template/Holder/Timer/Time/Icon]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/List/Template/Holder/CardIcons/UIListLayout]========],class=[========[
UIListLayout]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/List/Template/Holder/CardIcons/UIListLayout]========],class=[========[
UIListLayout]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/List/Template/Holder/Timer/Time/UIListLayout]========],class=[========[
UIListLayout]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/List/Template/Holder/Name/Outer]========],class=[========[
UIStroke]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/List/Template/Holder/OldPrice/Outer]========],class=[========[
UIStroke]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/List/Template/Holder/Price/Outer]========],class=[========[
UIStroke]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/List/Template/Holder/Name/Outer]========],class=[========[
UIStroke]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/List/Template/Holder/OldPrice/Outer]========],class=[========[
UIStroke]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/List/Template/Holder/Price/Outer]========],class=[========[
UIStroke]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/List/Template/Holder/DiscountTag/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/List/Template/Holder/DiscountTag/UIAspectRatioConstraint]========],class=[========[
UIAspectRatioConstraint]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/List/Template/Holder/Render/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/List/Template/Holder/Grunge/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/List/Template/Holder/Price/DiscountGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/Slasher/Holder/Render/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/c00lKidd/Holder/Render/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/JohnDoe/Holder/Render/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/Noli/Holder/Render/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/1x1x1x1/Holder/Render/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/Guest 666/Holder/Render/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/Nosferatu/Holder/Render/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/Characters/Azure/Holder/Render/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/List/Template/Holder/Render/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/List/Template/Holder/Grunge/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/List/Template/Holder/Price/DiscountGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Shedletsky/Holder/Render/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Elliot/Holder/Render/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Noob/Holder/Render/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Builderman/Holder/Render/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/007n7/Holder/Render/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/TwoTime/Holder/Render/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/TwoTime/Holder/Render/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Taph/Holder/Render/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Dusekkar/Holder/Render/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Chance/Holder/Render/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/Characters/Veeronica/Holder/Render/UIGradient]========],class=[========[
UIGradient]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/List/Template/Holder/New/New]========],class=[========[
TextLabel]========],text=[========[
NEW]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/List/Template/Holder/Owned/Text]========],class=[========[
TextLabel]========],text=[========[
Purchased]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/List/Template/Holder/Updated/Updated]========],class=[========[
TextLabel]========],text=[========[
UPDATED]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/List/Template/Holder/New/New]========],class=[========[
TextLabel]========],text=[========[
NEW]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/List/Template/Holder/Owned/Text]========],class=[========[
TextLabel]========],text=[========[
Purchased]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/List/Template/Holder/Updated/Updated]========],class=[========[
TextLabel]========],text=[========[
UPDATED]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Assets/CharacterPage_PRESET/List/Template/Holder/Timer/Time/Name]========],class=[========[
TextLabel]========],text=[========[
23:59:59]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/List/Template/Holder/Timer/Time]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/List/Template/Holder/OldPrice/Strikethrough]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/List/Template/Holder/Timer/Time]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/List/Template/Holder/OldPrice/Strikethrough]========],class=[========[
Frame]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/List/Template/Holder/Timer/Time/Icon]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/List/Template/Holder/Timer/Time/Icon]========],class=[========[
ImageLabel]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/List/Template/Holder/Timer/Time/UIListLayout]========],class=[========[
UIListLayout]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/List/Template/Holder/Timer/Time/UIListLayout]========],class=[========[
UIListLayout]========],text=[========[
]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Killers/List/Template/Holder/Timer/Time/Name]========],class=[========[
TextLabel]========],text=[========[
23:59:59]========]},
{path=[========[
CombatMenusPort/Menus/Shop/Tabs/Skins/Page/Page/Survivors/List/Template/Holder/Timer/Time/Name]========],class=[========[
TextLabel]========],text=[========[
23:59:59]========]},
}

local now=0;local delayed={}
local function signal()
 local s={listeners={}}
 function s:Connect(fn)local c={Connected=true};function c:Disconnect()self.Connected=false end;table.insert(self.listeners,{fn=fn,c=c});return c end
 function s:Fire(...)for _,item in table.clone(self.listeners)do if item.c.Connected then item.fn(...)end end end
 return s
end
local function advance(dt)
 local finish=now+dt
 while true do table.sort(delayed,function(a,b)return a.at<b.at end);if not delayed[1]or delayed[1].at>finish then break end;local item=table.remove(delayed,1);now=item.at;item.fn()end
 now=finish
end
local task={spawn=function(fn,...)return fn(...)end,delay=function(dt,fn)table.insert(delayed,{at=now+dt,fn=fn})end,wait=function(dt)advance(dt or 0);return dt or 0 end}
local eventNames={MouseEnter=true,MouseLeave=true,MouseButton1Click=true,MouseButton1Down=true,Activated=true,Changed=true,Event=true}
local oldIndex=mt.__index
function mt.__index(self,key)
 if eventNames[key]then
  local events=rawget(self,'_events');if not events then events={};rawset(self,'_events',events)end
  events[key]=events[key]or signal();return events[key]
 end
 return oldIndex(self,key)
end
function Methods:GetPropertyChangedSignal(name)
 local signals=rawget(self,'_propertySignals');if not signals then signals={};rawset(self,'_propertySignals',signals)end
 signals[name]=signals[name]or signal();return signals[name]
end
function Methods:GetAttributeChangedSignal(name)return self:GetPropertyChangedSignal('attr_'..name)end
function Methods:WaitForChild(name)return assert(self:FindFirstChild(name),name)end
function Methods:Fire(...)self.Event:Fire(...)end
local oldIsA=Methods.IsA
function Methods:IsA(class)
 if class=='GuiObject'and table.find({'Frame','ScrollingFrame','ImageLabel','ImageButton','TextLabel','TextButton','TextBox'},self.ClassName)then return true end
 if class=='GuiButton'and table.find({'TextButton','ImageButton'},self.ClassName)then return true end
 if class=='ValueBase'and self.ClassName:match('Value$')then return true end
 return oldIsA(self,class)
end
local function locate(base,path)
 local current=base;for name in path:gmatch('[^/]+')do current=current and current:FindFirstChild(name)end;return current
end
fresh()
local uiRoot=child(game,'Imported')
for _,item in assetData do
 local parts=string.split(item.path,'/');local current=uiRoot
 for i=1,#parts-1 do current=current:FindFirstChild(parts[i])or child(current,parts[i])end
 local object=current:FindFirstChild(parts[#parts])or child(current,parts[#parts],item.class);object.ClassName=item.class
 object.Text=item.text;object.Visible=true;object.AbsoluteSize={X=1000,Y=700};object.AbsoluteCanvasSize={X=100,Y=100};object.AbsoluteWindowSize={X=100,Y=100}
 object:SetAttribute('__ButtonInitialized',nil)
end
local bundle=uiRoot.CombatMenusPort
local modules=game.ReplicatedStorage.Modules
local ui=child(child(child(game.ReplicatedStorage,'Systems'),'Player'),'UI')
local menus=bundle.Menus;menus.Parent=ui;bundle.SidebarHandler.Parent=ui;bundle.Misc.Parent=ui
local assets=game.ReplicatedStorage.Assets;child(child(child(assets,'Sounds'),'SFX'),'Menu');local assetUI=child(assets,'UI');bundle.UpdatelogPresets.Parent=assetUI
local players=child(game,'Players');local localPlayer=child(players,'Local','Player');players.LocalPlayer=localPlayer
local gui=child(localPlayer,'PlayerGui');child(gui,'MainUI','ScreenGui')
local lighting=child(game,'Lighting','Lighting')
local heartbeat=signal()
local tween={Create=function(_,object,info,properties)return {Play=function()for k,v in properties do object[k]=v end end,Cancel=function()end}end,GetValue=function(_,a)return a end}
local originalGetService=game.GetService
function game:GetService(name)
 if name=='Players'then return players elseif name=='TweenService'then return tween elseif name=='RunService'then return {Heartbeat=heartbeat,IsClient=function()return true end,IsServer=function()return false end} elseif name=='Lighting'then return lighting elseif name=='Debris'then return {AddItem=function()end}end
 return originalGetService(self,name)
end
local UDim2={new=function(xs,xo,ys,yo)return {X={Scale=xs or 0,Offset=xo or 0},Y={Scale=ys or 0,Offset=yo or 0}}end,fromScale=function(x,y)return {X={Scale=x or 0,Offset=0},Y={Scale=y or 0,Offset=0}}end}
local Color3={fromRGB=function(...)return {...}end,new=function(...)return {...}end}
local TweenInfo={new=function()return {}end}
local Enum={EasingStyle={Quad={},Quint={},Back={}},EasingDirection={Out={},InOut={}}}
local data=child(game,'Data');local settings=child(data,'Settings');local general=child(settings,'General');local audio=child(settings,'Audio')
for i,group in {general,audio}do group:SetAttribute('LayoutOrder',i);group:SetAttribute('DisplayTitle',group.Name)end
local afk=child(general,'AFK','BoolValue');afk.Value=false;afk:SetAttribute('LayoutOrder',1);afk:SetAttribute('DisplayTitle','AFK Mode');afk:SetAttribute('DisplayDescription','Pause participation')
local sfx=child(audio,'SFXDisabled','BoolValue');sfx.Value=false;sfx:SetAttribute('LayoutOrder',1);sfx:SetAttribute('DisplayTitle','Sound Effects Disabled');sfx:SetAttribute('DisplayDescription','Mute sound effects')
local misc=child(data,'Misc');child(misc,'LastSeenLog','StringValue').Value='11-21-26'
local stats=child(data,'Stats');local currency=child(stats,'Currency');local money=child(currency,'Money','NumberValue');money.Value=1234
local dataAPI={Get=function()return data end,ReadPath=function(_,path)return locate(data,path)end}
local requests={}
local network={FireServerConnection=function(_,name,...)table.insert(requests,{name,...})end}
local device={Value='PC',Changed=signal(),GetPlayerDevice=function(self)return self.Value end}
local initializer={PlayerSystems={}}
local util={ToCommas=function(_,n)return tostring(n)end,CreateFOVMultiplier=function()local v=Instance.new('NumberValue');v.Value=1;return v end}
local exports={}
local function dependency(name,value)
 local node=modules:FindFirstChild(name)or child(modules,name,'ModuleScript');exports[node]=value;return node
end
dependency('DataHandler',dataAPI);dependency('Sounds',{Play=function()end});dependency('Device',device);dependency('Util',util);dependency('Network',network)
dependency('EventHandlerClient',{GetInfo=function()return nil end,onEventInfoGiven=signal()})
local miscModules=modules:FindFirstChild('Misc')or child(modules,'Misc');exports[child(miscModules,'Signal','ModuleScript')]={new=signal}
exports[child(game.ReplicatedStorage,'GlobalTypes','ModuleScript')]={}
exports[child(game.ReplicatedStorage,'Initializer','ModuleScript')]=initializer
local helpers=child(modules,'CombatMenuCompat');exports[child(helpers,'Device','ModuleScript')]=device
local loaders={};local require
require=function(module)
 if exports[module]then return exports[module]end
 local factory=loaders[module];assert(factory,'No loader for '..tostring(module and module.Name))
 local value=factory(module);exports[module]=value;return value
end

loaders[locate(ui,[========[
SidebarHandler]========])]=function(script)
return(function()
require(game.ReplicatedStorage.GlobalTypes)

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataHandler = require(game.ReplicatedStorage.Modules.DataHandler)
local Sounds = require(game.ReplicatedStorage.Modules.Sounds)
local Signal = require(game.ReplicatedStorage.Modules.Misc.Signal)
local EventHandlerClient = require(game.ReplicatedStorage.Modules.EventHandlerClient)

require(game.ReplicatedStorage.Modules.CombatMenuCompat.Device)

local CurrencyDisplay = require(script.Classes.CurrencyDisplay)
local Button = require(script.Classes.Button)
local LocalPlayer = Players.LocalPlayer
local tweenInfo = TweenInfo.new(0.25)
local _ = ReplicatedStorage.Assets.Sounds.SFX.Menu
local t1 = {}

t1.__index = t1

function t1.new(s1: string, p1) -- line: 26
	-- upvalues: t1 (copy), Signal (copy), LocalPlayer (copy)
	local self = setmetatable({}, t1)

	self.Menu = p1:Clone()
	self.Toggled = Signal.new()
	self.Button = nil
	self.MenuName = s1
	self.Menu.Visible = false
	self.Menu.Size = UDim2.fromScale(0,0)
	self.Menu.Parent = LocalPlayer.PlayerGui.MainUI

	for _, descendant in self.Menu:GetDescendants() do
		if descendant:IsA("ScrollingFrame") then
			descendant:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 40
				-- upvalues: descendant (copy)
				descendant.ScrollBarThickness = descendant.AbsoluteSize.X / 44
			end)
		end
	end

	return self
end
function t1.ToggleMenu(t2: {[any]: any}, b1: boolean) -- line: 48
	-- upvalues: Sounds (copy), TweenService (copy), tweenInfo (copy)
	local _sidebar = t2._sidebar

	if _sidebar.TogglingMenus then
		return
	end

	if _sidebar.MenusHidden and t2.SidebarButton then
		return
	end

	if b1 and t2.Menu.Visible then
		return
	end

	_sidebar.TogglingMenus = true

	local MenuVisible = t2.Menu.Visible
	local v26 = nil

	Sounds:Play("select")

	for _, v28 in _sidebar.SidebarMenus do
		if v28.Menu ~= t2.Menu or MenuVisible then
			if v28.Menu ~= t2.Menu and v28.Menu.Visible then
				v26 = v28
			end

			if v28.Menu.Visible then
				v28.Toggled:Fire(false)

				local MenuName = script.Parent.Menus:FindFirstChild(v28.MenuName)
				local ok, result = pcall(require, MenuName)

				if ok and result and result.OnTransitionState then
					result.OnTransitionState(false)
				else
					TweenService:Create(v28.Menu, tweenInfo, {
						Size = UDim2.new(1, -20, 0, 0)
					}):Play()
					task.delay(0.25, function() -- line: 87
						-- upvalues: v28 (copy)
						v28.Menu.Visible = false
					end)
				end

				if v28.Button then
					v28.Button:SetAppearanceState(false)
				end
			end
		end
	end

	task.delay(0.3 + (not v26 and 0 or 0.125), function() -- line: 97
		-- upvalues: _sidebar (copy)
		_sidebar.TogglingMenus = nil
	end)

	if v26 then
		task.wait(0.125)

		if _sidebar.MenusHidden then
			_sidebar.TogglingMenus = nil

			return
		end
	end

	if not MenuVisible then
		t2.Toggled:Fire(true)

		local t2MenuName = script.Parent.Menus:FindFirstChild(t2.MenuName)
		local ok, result = pcall(require, t2MenuName)

		if ok and result and result.OnTransitionState then
			result.OnTransitionState(true)
		else
			t2.Menu.Visible = true
			TweenService:Create(t2.Menu, tweenInfo, {
				Size = UDim2.new(1, -20, 1, -20)
			}):Play()
		end

		if t2.Button then
			t2.Button:SetAppearanceState(true)
		end
	end
end

local t3 = {
	SidebarMenus = {},
	SidebarButtons = {},
	PendingSidebarMenus = {},
	onTransitionState = Signal.new(),
	onMenuSwitched = Signal.new(),
	CashDisplay = script.CashDisplay,
	Sidebar = script.Sidebar
}

t3.__index = t3

local function constructEventUI()end
local function registerSidebarMenuButton(s2: string, p2) -- line: 157
	-- upvalues: t3 (copy)
	local v40 = t3.SidebarButtons[s2]

	if not v40 then
		t3.PendingSidebarMenus[s2] = p2

		return false
	end

	v40.onClick:Connect(function() -- line: 164
		-- upvalues: t3 (copy), s2 (copy)
		t3.onMenuSwitched:Fire(s2)
	end)

	local ok, result = pcall(function() -- line: 168
		-- upvalues: v40 (copy), p2 (copy)
		v40:RegisterMenu(p2)
	end)

	if not ok then
		warn(`[{ script }]: Failed to register sidebar menu '{ s2 }' to its button: { result }`)

		return false
	end

	p2.Button = v40
	t3.PendingSidebarMenus[s2] = nil

	return true
end

function t3.CreateSidebarMenu(t5: {[any]: any}, s3: string, p3) -- line: 181
	-- upvalues: t1 (copy), t3 (copy), registerSidebarMenuButton (copy)
	local v46 = t1.new(s3, p3)

	v46._sidebar = t5
	v46.SidebarButton = t3.Sidebar:FindFirstChild(s3, true)
	t3.SidebarMenus[s3] = v46
	registerSidebarMenuButton(s3, v46)

	return v46
end
function t3.ToggleButtons(_: {[any]: any}, b2: boolean) -- line: 192
	-- upvalues: t3 (copy), TweenService (copy), tweenInfo (copy)
	t3.onTransitionState:Fire(b2)

	for _, v50 in t3.SidebarMenus do
		local MenuName = script.Parent.Menus:FindFirstChild(v50.MenuName)
		local _, result = pcall(require, MenuName)

		if result and result.OnTransitionState then
			result.OnTransitionState(false)
		else
			TweenService:Create(v50.Menu, tweenInfo, {
				Size = UDim2.new(1, -20, 0, 0)
			}):Play()
			task.delay(0.25, function() -- line: 206
				-- upvalues: v50 (copy)
				v50.Menu.Visible = false
			end)
		end

		if v50.Button then
			v50.Button:SetAppearanceState(false)
		end

		task.delay(0.25, function() -- line: 215
			-- upvalues: v50 (copy)
			v50.Menu.Visible = false
		end)
	end
end
function t3.ToggleSidebarButtons(_: {[any]: any}, b3: boolean) -- line: 221
	-- upvalues: t3 (copy)
	t3.MenusHidden = not b3
	t3.Sidebar.Visible = b3

	if b3 then
		return
	end

	t3:ToggleButtons(b3)
end
function t3.Start(_) -- line: 232
	-- upvalues: DataHandler (copy), LocalPlayer (copy), t3 (copy), EventHandlerClient (copy), constructEventUI (copy), Button (copy), registerSidebarMenuButton (copy)
	if not DataHandler:Get() then
		warn(`[{ script }]: No player data found, returning...`)

		return
	end

	local MainUI = LocalPlayer.PlayerGui:WaitForChild("MainUI")

	t3.Sidebar.Parent = MainUI
	t3.CashDisplay.Parent = MainUI

	local Sidebar = t3.Sidebar
	local _ = {
		Sidebar.Middle.Shop,
		Sidebar.Middle.Inventory,
		Sidebar.Middle.Achievements,
		Sidebar.Middle.Spectate,
		Sidebar.Middle.Stats,
		Sidebar.Bottom.Settings,
		Sidebar.Bottom.Rules
	}
	local Info = EventHandlerClient:GetInfo()

	if Info then
		constructEventUI(Info)
	else
		EventHandlerClient.onEventInfoGiven:Connect(constructEventUI)
	end

	for _, child in t3.Sidebar:GetChildren() do
		for _, child2 in child:GetChildren() do
			if child2:IsA("Frame") then
				t3.SidebarButtons[child2.Name] = Button.new(child2, child.Name)

				local v65 = t3.PendingSidebarMenus[child2.Name]

				if v65 then
					registerSidebarMenuButton(child2.Name, v65)
				end
			end
		end
	end

	for v66, _ in t3.PendingSidebarMenus do
		if t3.SidebarButtons[v66] then
		end
	end
end

return t3

end)()
end

loaders[locate(ui,[========[
SidebarHandler/Classes/Button]========])]=function(script)
return(function()
local TweenService = game:GetService("TweenService")

game:GetService("ReplicatedStorage")

local Sounds = require(game.ReplicatedStorage.Modules.Sounds)
local Signal = require(game.ReplicatedStorage.Modules.Misc.Signal)
local tweenInfo = TweenInfo.new(0.25)
local t1 = {
	Middle = {
		Enter = UDim2.fromScale(0.985, 0.25),
		Exit = UDim2.fromScale(0.95, 0.22)
	},
	Bottom = {
		Enter = UDim2.fromScale(0.645, 0.18),
		Exit = UDim2.fromScale(0.606, 0.149)
	}
}
local t2 = {
	BG = {
		Active = {
			ImageColor3 = Color3.fromRGB(198, 198, 198)
		},
		Inactive = {
			ImageColor3 = Color3.fromRGB(8, 8, 8)
		}
	},
	GrungeMain = {
		Active = {
			ImageColor3 = Color3.fromRGB(0, 0, 0)
		},
		Inactive = {
			ImageColor3 = Color3.fromRGB(80, 80, 80)
		}
	},
	Grunge = {
		Active = {
			ImageColor3 = Color3.fromRGB(255, 255, 255)
		},
		Inactive = {
			ImageColor3 = Color3.fromRGB(0, 0, 0)
		}
	},
	Highlight = {
		Active = {
			ImageColor3 = Color3.fromRGB(0, 0, 0)
		},
		Inactive = {
			ImageColor3 = Color3.fromRGB(255, 255, 255)
		}
	},
	Icon = {
		Active = {
			ImageColor3 = Color3.fromRGB(0, 0, 0)
		},
		Inactive = {
			ImageColor3 = Color3.fromRGB(255, 255, 255)
		}
	},
	Line = {
		Active = {
			ImageColor3 = Color3.fromRGB(0, 0, 0)
		},
		Inactive = {
			ImageColor3 = Color3.fromRGB(255, 255, 255)
		}
	}
}
local t3 = {}

t3.__index = t3

function t3.new(p1, s1: string) -- line: 51
	-- upvalues: t3 (copy), Signal (copy), TweenService (copy), tweenInfo (copy), t1 (copy), Sounds (copy)
	assert(p1 and p1:IsA("Frame"), "Button.new() requires a button frame.")
	assert(not p1:GetAttribute("__ButtonInitialized"), `Button.new() was already called on '{ p1.Name }'`)
	p1:SetAttribute("__ButtonInitialized", true)

	local self = setmetatable({}, t3)

	self.Instance = p1
	self.onClick = Signal.new()
	self.Instance.MouseEnter:Connect(function() -- line: 60
		-- upvalues: TweenService (copy), self (copy), tweenInfo (copy), t1 (copy), s1 (copy), Sounds (copy)
		TweenService:Create(self.Instance, tweenInfo, {
			Size = t1[s1].Enter
		}):Play()
		Sounds:Play("hover")
	end)
	self.Instance.MouseLeave:Connect(function() -- line: 72
		-- upvalues: TweenService (copy), self (copy), tweenInfo (copy), t1 (copy), s1 (copy), Sounds (copy)
		TweenService:Create(self.Instance, tweenInfo, {
			Size = t1[s1].Exit
		}):Play()
		Sounds:Play("hoverEnd")
	end)

	return self
end
function t3.RegisterMenu(t4: {[any]: any}, t5: {[any]: any}) -- line: 87
	assert(t5 and (typeof(t5) == "table" and t5.ToggleMenu), "Button:RegisterMenu() requires a menu table with a ToggleMenu function.")
	assert(t4.Menu == nil, `Button '{ t4.Instance.Name }' already has a menu registered.`)
	t4.Menu = t5
	t4.Instance.Button.MouseButton1Click:Connect(function() -- line: 92
		-- upvalues: t4 (copy)
		t4.onClick:Fire()
		t4.Menu:ToggleMenu()
	end)
end
function t3.SetAppearanceState(t6: {[any]: any}, b1: boolean) -- line: 98
	-- upvalues: TweenService (copy), tweenInfo (copy), t2 (copy)
	assert(b1 ~= nil and typeof(b1) == "boolean", "Button:SetAppearanceState() requires a boolean state.")

	local Text = t6.Instance.Button:FindFirstChild("Text")

	for _, v17 in Text and Text:GetChildren() or {} do
		if v17:IsA("TextLabel") then
			TweenService:Create(v17, tweenInfo, {
				TextColor3 = b1 and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
			}):Play()
		elseif v17:IsA("ImageLabel") then
			TweenService:Create(v17, tweenInfo, {
				ImageColor3 = b1 and Color3.fromRGB(224, 224, 224) or Color3.fromRGB(0, 0, 0)
			}):Play()
		end
	end

	local v18 = not b1 and "Inactive" or "Active"

	for v19, v20 in t2 do
		local v21 = t6.Instance.Button:FindFirstChild(v19)

		if v21 then
			TweenService:Create(v21, tweenInfo, v20[v18]):Play()
		end
	end
end

return t3

end)()
end

loaders[locate(ui,[========[
SidebarHandler/Classes/CurrencyDisplay]========])]=function(script)
return(function()
require(game.ReplicatedStorage.GlobalTypes)
game:GetService("ReplicatedStorage")

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

game:GetService("Players")

local Initializer = require(game.ReplicatedStorage.Initializer)
local DataHandler = require(game.ReplicatedStorage.Modules.DataHandler)
local Util = require(game.ReplicatedStorage.Modules.Util)
local Sounds = require(game.ReplicatedStorage.Modules.Sounds)
local Preset = script.Preset
local tweenInfo = TweenInfo.new(0.25)
local clamp = math.clamp
local floor = math.floor
local t1 = {}

t1.__index = t1

local function defaultClickedCallback() -- line: 27
	-- upvalues: Initializer (copy), Sounds (copy)
	local Shop = Initializer.PlayerSystems.Shop

	Initializer.PlayerSystems.SidebarHandler.SidebarMenus.Shop:ToggleMenu(true)
	Sounds:Play("click")
	Shop:SwitchTab("Skins")
end

function t1.new(s1: string, s2: string, b1: boolean, p1: ((...any) -> ...any)?) -- line: 35
	-- upvalues: DataHandler (copy), t1 (copy), defaultClickedCallback (copy), Preset (copy), TweenService (copy), tweenInfo (copy), Sounds (copy), Util (copy), RunService (copy), clamp (copy), floor (copy)
	assert(typeof(s1) == "string", "CurrencyDisplay.new() requires a currencyName.")
	assert(typeof(s2) == "string", "CurrencyDisplay.new() requires a currencyIcon.")

	local v18 = DataHandler:ReadPath(b1 and `EventCurrency/{ s1 }` or `Stats/Currency/{ s1 }`)

	if not v18 then
		error(`[{ script }]: Could not find currency value for { s1 }.`)
	end

	local self = setmetatable({}, t1)

	self.CurrencyName = s1
	self.CurrencyIcon = s2
	self.IsEventCurrency = b1
	self.onClickedCallback = p1 or defaultClickedCallback

	local clone = Preset:Clone()
 clone.Plus.Visible=false
 clone.Plus.Active=false

	clone.Name = s1
	clone.Icon.Image = s2
	self.Instance = clone
	clone.Plus.MouseEnter:Connect(function() -- line: 60
		-- upvalues: TweenService (copy), clone (copy), tweenInfo (copy), Sounds (copy)
		TweenService:Create(clone.Plus, tweenInfo, {
			Size = UDim2.fromScale(0.292, 1.064)
		}):Play()
		Sounds:Play("hover")
	end)
	clone.Plus.MouseLeave:Connect(function() -- line: 72
		-- upvalues: TweenService (copy), clone (copy), tweenInfo (copy), Sounds (copy)
		TweenService:Create(clone.Plus, tweenInfo, {
			Size = UDim2.fromScale(0.219, 0.798)
		}):Play()
		Sounds:Play("hoverEnd")
	end)
	clone.Plus.MouseButton1Down:Connect(self.onClickedCallback)

	local u21 = nil

	local function __onValueChanged(n1: number, b2: boolean) -- line: 87
		-- upvalues: u21 (ref), clone (copy), Util (copy), RunService (copy), clamp (copy), TweenService (copy), floor (copy)
		if u21 then
			u21:Disconnect()
			u21 = nil
		end

		if b2 then
			clone.Amount.Text = Util:ToCommas(n1)

			return
		end

		local v26 = clone.Amount.Text:gsub(",", "")
		local n2 = 0
		local v28 = tonumber(v26) or 0

		u21 = RunService.Heartbeat:Connect(function(dt: number) -- line: 101
			-- upvalues: clone (copy), u21 (ref), n2 (ref), clamp (copy), TweenService (copy), v28 (copy), n1 (copy), Util (copy), floor (copy)
			if not clone or not clone.Parent then
				u21:Disconnect()

				return
			end

			n2 += dt

			local v30 = clamp(n2 / 1.5, 0, 1)
			local Value = TweenService:GetValue(v30, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
			local v32 = v28 + (n1 - v28) * Value

			clone.Amount.Text = Util:ToCommas((floor(v32)))

			if v30 >= 1 then
				u21:Disconnect()
				u21 = nil
			end
		end)
	end

	local Value = v18.Value

	if u21 then
		u21:Disconnect()
		u21 = nil
	end

	clone.Amount.Text = Util:ToCommas(Value)
	v18.Changed:Connect(__onValueChanged)

	return self
end

return t1

end)()
end

loaders[locate(ui,[========[
Menus/Settings]========])]=function(script)
return(function()
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

end)()
end

loaders[locate(ui,[========[
Menus/Settings/Templates/Bool]========])]=function(script)
return(function()
local t1 = {}

t1.__index = t1

function t1.CreateSettingUI(_, p2, p3) -- line: 4
	-- upvalues: t1 (copy)
	if not p2 then
		p2 = Instance.new("BoolValue")
		p2.Name = "SettingValue"
	end

	local v6 = setmetatable({
		SettingValue = p2
	}, t1)

	v6.isDebounce = false
	v6.Instance = p3 or script.Checkbox:Clone()
	v6.Instance.CheckboxButton.MouseButton1Click:Connect(function() -- line: 14
		-- upvalues: v6 (copy), p2 (ref)
		if v6.isDebounce then
			return
		end

		v6.isDebounce = true
		task.delay(0.25, function() -- line: 17
			-- upvalues: v6 (copy)
			v6.isDebounce = false
		end)
		require(game.ReplicatedStorage.Modules.Sounds):Play("switch")
		require(game.ReplicatedStorage.Modules.Network):FireServerConnection("UpdateSettings", "REMOTE_EVENT", p2, not p2.Value)
	end)

	return v6
end
function t1.OnUpdate(p4) -- line: 29
	p4.Value = p4.SettingValue.Value
	p4.Instance.CheckboxButton.Checked.Visible = p4.Value
end

return t1

end)()
end

loaders[locate(ui,[========[
Menus/UpdateLog]========])]=function(script)
return(function()
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local _ = LocalPlayer.PlayerGui
local DataHandler = require(ReplicatedStorage.Modules.DataHandler)
local Network = require(ReplicatedStorage.Modules.Network)
local Sounds = require(ReplicatedStorage.Modules.Sounds)
local Util = require(ReplicatedStorage.Modules.Util)
local DiscordMarkdown = require(script.DiscordMarkdown)
local UpdatelogPresets = ReplicatedStorage.Assets.UI.UpdatelogPresets
local Changelogs = ReplicatedStorage.Assets.Changelogs
local __createComponent = nil
local t4 = {
	TextTemplate = function(t1: {[any]: any}, p1) -- line: 26
		p1.Text = t1.Content
	end,
	ImageTemplate = function(t2: {[any]: any}, p2) -- line: 30
		p2.Image = t2.Content
		p2.Subtitle.Text = t2.Text
	end,
	ItemsTemplate = function(t3: {[any]: any}, p3) -- line: 35
		-- upvalues: __createComponent (ref)
		for i, v in ipairs(t3.Content) do
			local v35 = __createComponent(v, p3)

			if v35 then
				v35.LayoutOrder = i
				v35.Parent = p3
			end
		end
	end
}
local LatestLog = Changelogs:GetAttribute("LatestLog")
local TextTitle = nil
local t5 = {}

local function __toYYMMDD(p4) -- line: 53
	local v37, v38, v39 = p4:match("(%d+)-(%d+)-(%d+)")

	return string.format("%02d%02d%02d", tonumber(v39), tonumber(v37), (tonumber(v38)))
end
local function __generateLegacyLayout(t6: {[any]: any}, p5) -- line: 58
	-- upvalues: UpdatelogPresets (copy)
	local n1 = 0

	for i = 1, #t6.Notes do
		local v44 = t6.Notes[i]
		local clone = UpdatelogPresets.Components.Header:Clone()

		clone.Text = v44.Header
		clone.LayoutOrder = n1
		clone.Parent = p5

		local clone2 = UpdatelogPresets.Components.Seperator:Clone()

		clone2.LayoutOrder = n1 + 1
		clone2.Parent = p5

		local clone3 = UpdatelogPresets.Components.TextPreset:Clone()

		clone3.Main.Text = v44.Body
		clone3.Size = v44.NoteSize or UDim2.fromScale(0.9, 0.25)
		clone3.LayoutOrder = n1 + 2
		clone3.Parent = p5
		n1 += 3
	end
end

function __createComponent(t7: {[any]: any}, p6) -- line: 82
	-- upvalues: t4 (copy)
	local t7Type = script.Presets.Components:FindFirstChild(t7.Type)

	if not t7Type then
		warn(`[{ script }]: Invalid component type: { t7.Type }`)

		return nil
	end

	local clone = t7Type:Clone()
	local v52 = t4[t7.Type]

	if v52 then
		local ok, result = pcall(v52, t7, clone)

		if not ok then
			warn(`[{ script }]: Failed to run callback for component: { t7.Type }, { debug.traceback(result) }`)
		end
	end

	for k, v in next, t7.Style or {} do
		clone[k] = v
	end

	clone.Parent = p6

	return clone
end

local function __generateLayout(t8: {[any]: any}, p7) -- line: 107
	-- upvalues: __createComponent (ref)
	local clone = script.Presets.UpdateDisplayTemplate:Clone()
	local n2 = 0

	local function __increment() -- line: 111
		-- upvalues: n2 (ref)
		n2 += 1
	end

	for _, v in ipairs(t8) do
		local clone4 = script.Presets.Components.SubheaderTemplate:Clone()

		clone4.Header.Text = v.Header
		clone4.LayoutOrder = n2
		clone4.Parent = clone
		n2 += 1

		for _, v2 in ipairs(v.Content) do
			local v67 = __createComponent(v2, clone)

			if v67 then
				v67.LayoutOrder = n2
				n2 += 1
			end
		end
	end

	clone.Parent = p7
end
local function __switchPage(p8, t9: {[any]: any}) -- line: 139
	-- upvalues: DiscordMarkdown (copy), __generateLegacyLayout (copy), __generateLayout (copy)
	assert(typeof(t9) == "table", "meta is not a table!")
 if not t9.Markdown and t9.Notes and t9.Notes[1]and t9.Notes[1].Body then t9.IsLegacy=true end

	for _, v in next, p8.Holder.List:GetChildren() do
		if v:IsA("Frame") or v:IsA("TextLabel") then
			v:Destroy()
		end
	end

	local clone = script.Presets.Loading:Clone()

	clone.Parent = p8.Holder

	local clone5 = script.Presets.Components.HeaderTemplate:Clone()

	clone5.Background.Image = t9.TitleMeta.Image.Backdrop or t9.TitleMeta.Image.Large or t9.TitleMeta.Image.Title or ""
	clone5.Header.Text = t9.TitleMeta.Text.Title or "N/A"
	clone5.Description.Text = t9.TitleMeta.Text.Description or (t9.TitleMeta.Text.Date or "None Provided")
	clone5.LayoutOrder = -10
	clone5.Parent = p8.Holder.List

	if t9.Markdown then
		DiscordMarkdown.Render(t9.Markdown, p8.Holder.List)
	elseif t9.IsLegacy then
		__generateLegacyLayout(t9, p8.Holder.List)
	else
		__generateLayout(t9.Notes, p8.Holder.List)
	end

	clone:Destroy()
end

local t10 = {
	Menu = nil
}
local u25 = nil
local u26 = nil

function t10.OnTransitionState(b1: boolean) -- line: 175
	-- upvalues: t10 (copy), u26 (ref), u25 (ref), Lighting (copy), Util (copy), LocalPlayer (copy), TweenService (copy), Debris (copy)
	local Menu = t10.UpdateLogMenu.Menu

	if b1 then
		if u26 then
			u26:Destroy()
			u26 = nil
		end

		if u25 then
			u25:Destroy()
			u25 = nil
		end

		Menu.Position = UDim2.fromScale(0.5, 0.55)
		Menu.Size = UDim2.fromScale(1, 1.15)
		Menu.Visible = true

		local BlurEffect = Instance.new("BlurEffect")

		BlurEffect.Name = "ShopBlur"
		BlurEffect.Size = 0
		BlurEffect.Parent = Lighting
		u26 = BlurEffect
		u25 = Util:CreateFOVMultiplier(LocalPlayer, 1, "ShopZoom")
		TweenService:Create(BlurEffect, TweenInfo.new(0.225, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = 12
		}):Play()
		TweenService:Create(u25, TweenInfo.new(0.225, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Value = 0.85
		}):Play()
		TweenService:Create(Menu, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Position = UDim2.fromScale(0.5, 0.5)
		}):Play()

		return
	end

	Menu.Visible = false

	local v77 = u25
	local v78 = u26

	if u25 then
		TweenService:Create(u25, TweenInfo.new(0.225, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Value = 1
		}):Play()
	end

	if v78 then
		TweenService:Create(v78, TweenInfo.new(0.225, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = 0
		}):Play()
	end

	if v78 then
		Debris:AddItem(v78, 0.225)
	end

	if v77 then
		Debris:AddItem(v77, 0.225)
	end
end
function t10.Start(_) -- line: 251
	-- upvalues: ReplicatedStorage (copy), t10 (copy), DataHandler (copy), LatestLog (copy), TweenService (copy), Sounds (copy), Network (copy), Changelogs (copy), TextTitle (ref), __switchPage (copy), t5 (copy)
	task.spawn(function() -- line: 252
		-- upvalues: ReplicatedStorage (copy), t10 (copy), DataHandler (copy), LatestLog (copy), TweenService (copy), Sounds (copy), Network (copy), Changelogs (copy), TextTitle (ref), __switchPage (copy), t5 (copy)
		t10.UpdateLogMenu = require(ReplicatedStorage.Initializer).PlayerSystems.SidebarHandler:CreateSidebarMenu("UpdateLog", script.UpdateScreen)


		local Menu = t10.UpdateLogMenu.Menu
		local Close = Menu.Holder.Close

		Close.MouseEnter:Connect(function() -- line: 264
			-- upvalues: TweenService (copy), Close (copy), Sounds (copy)
			TweenService:Create(Close, TweenInfo.new(0.25), {
				Size = UDim2.fromScale(0.105, 0.105)
			}):Play()
			Sounds:Play("hover")
		end)
		Close.MouseLeave:Connect(function() -- line: 276
			-- upvalues: TweenService (copy), Close (copy), Sounds (copy)
			TweenService:Create(Close, TweenInfo.new(0.25), {
				Size = UDim2.fromScale(0.074, 0.095)
			}):Play()
			Sounds:Play("hoverEnd")
		end)
		Close.MouseButton1Down:Connect(function() -- line: 288
			-- upvalues: t10 (copy), Network (copy), Sounds (copy)
			t10.UpdateLogMenu:ToggleMenu(false)
			Network:FireServerConnection("UpdateLogToLatest", "REMOTE_EVENT")
			Sounds:Play("click")
		end)

		for _, v in next, Changelogs:GetChildren() do
			local ok, result = pcall(function() -- line: 295
				-- upvalues: v (copy)
				return require(v)
			end)

			if not ok then
				warn(`Failed to load changelog { v.Name }: { result }`)
			else
				local clone = script.Presets.UpdateTemplate:Clone()

				clone.Name = result.TitleMeta.Text.Title
				clone.UpdateName.Text = result.TitleMeta.Text.Title or "N/A"
				clone.Description.Text = result.TitleMeta.Text.Description or (result.TitleMeta.Text.Date or "None Provided")
				clone.Render.Image = result.TitleMeta.Image.Backdrop or result.TitleMeta.Image.Small or result.TitleMeta.Image.Title or ""

				local v87, v88, v89 = result.TitleMeta.Text.Date:match("(%d+)-(%d+)-(%d+)")

				clone.LayoutOrder = -string.format("%02d%02d%02d", tonumber(v89), tonumber(v87), (tonumber(v88)))
				clone.Parent = Menu.List.Updates
				clone.MouseEnter:Connect(function() -- line: 312
					-- upvalues: Sounds (copy)
					Sounds:Play("hover")
				end)
				clone.MouseLeave:Connect(function() -- line: 316
					-- upvalues: Sounds (copy)
					Sounds:Play("hoverEnd")
				end)
				clone.MouseButton1Down:Connect(function() -- line: 320
					-- upvalues: TextTitle (ref), result (copy), __switchPage (copy), Menu (copy), Sounds (copy)
					if TextTitle == result.TitleMeta.Text.Title then
						return
					end

					TextTitle = result.TitleMeta.Text.Title
					__switchPage(Menu, result)
					Sounds:Play("click")
				end)
				t5[v.Name] = result
			end
		end

		if t5[LatestLog]then __switchPage(Menu, t5[LatestLog])end
        if t5[LatestLog]and DataHandler:Get().Misc.LastSeenLog.Value ~= LatestLog then t10.UpdateLogMenu:ToggleMenu(true)end
	end)
end

return t10

end)()
end

loaders[locate(ui,[========[
Misc/AFKButton]========])]=function(script)
return(function()
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

end)()
end

local sidebar=require(ui.SidebarHandler);initializer.PlayerSystems.SidebarHandler=sidebar
local settingsAPI=require(menus.Settings)
-- Existing connections are cloned by the installer; no new setting handler is needed for the UI test.
child(menus.Settings,'SettingConnections')
settingsAPI:Start()
assert(sidebar.PendingSidebarMenus.Settings,'settings can initialize before sidebar buttons')
sidebar:Start();assert(sidebar.SidebarButtons.Settings and not sidebar.PendingSidebarMenus.Settings)
assert(sidebar.Sidebar.Parent==gui.MainUI and sidebar.Sidebar.Bottom.UpdateLog and sidebar.Sidebar.Bottom.AFK)
local contents=settingsAPI.SettingsMenu.Menu.SettingsContainer.Contents
assert(contents:FindFirstChild('AFK')and contents:FindFirstChild('SFXDisabled'))
local search=contents.SearchBoxBackground.SearchBox
search.Text='  sound  ';search:GetPropertyChangedSignal('Text'):Fire()
assert(not contents.AFK.Visible and contents.SFXDisabled.Visible,'search matches title/description and trims spaces')
search.Text='';search:GetPropertyChangedSignal('Text'):Fire();assert(contents.AFK.Visible and contents.SFXDisabled.Visible)
contents.SFXDisabled.CheckboxButton.MouseButton1Click:Fire()
assert(requests[#requests][1]=='UpdateSettings'and requests[#requests][3]==sfx and requests[#requests][4]==true, tostring(requests[#requests][2]and requests[#requests][2].Name)..' / '..tostring(requests[#requests][3]))
contents.AFK.Reset.MouseButton1Click:Fire();assert(requests[#requests][1]=='UpdateSettings'and requests[#requests][3]==afk and requests[#requests][4]==nil)
sidebar.SidebarButtons.Settings.Instance.Button.MouseButton1Click:Fire();advance(.5)
assert(settingsAPI.SettingsMenu.Menu.Visible)
local statsMenu=sidebar:CreateSidebarMenu('Stats',menus.Stats.StatsScreen)
exports[menus.Stats]={}
sidebar.SidebarButtons.Stats.Instance.Button.MouseButton1Click:Fire();advance(.5)
assert(statsMenu.Menu.Visible and not settingsAPI.SettingsMenu.Menu.Visible,'only the selected menu remains open')
sidebar:ToggleSidebarButtons(false);advance(.5);assert(not sidebar.Sidebar.Visible and not statsMenu.Menu.Visible)
sidebar:ToggleSidebarButtons(true);assert(sidebar.Sidebar.Visible)
local logs=child(assets,'Changelogs');logs:SetAttribute('LatestLog','11-21-26')
for i,date in {'06-16-26','11-21-26'}do
 local node=child(logs,date,'ModuleScript');exports[node]={TitleMeta={Text={Title='Update '..date,Date=date},Image={Title='image',Backdrop='backdrop'}},Notes={{Header='Content',Body='Legacy notes '..i}}}
end
exports[menus.UpdateLog.DiscordMarkdown]={Render=function()error('legacy logs should not use Markdown renderer')end}
local logAPI=require(menus.UpdateLog);logAPI:Start()
local logMenu=logAPI.UpdateLogMenu.Menu
assert(logMenu.List.Updates:FindFirstChild('Update 11-21-26'))
local rendered=false
for _,object in logMenu.Holder.List:GetDescendants()do if object:IsA('TextLabel')and object.Text=='Legacy notes 2'then rendered=true end end
assert(rendered,'old Header/Body changelogs render in the new selectable menu')
logMenu.List.Updates['Update 06-16-26'].MouseButton1Down:Fire()
rendered=false
for _,object in logMenu.Holder.List:GetDescendants()do if object:IsA('TextLabel')and object.Text=='Legacy notes 1'then rendered=true end end
assert(rendered,'selecting another changelog changes page')
initializer.PlayerSystems.Shop={SwitchTab=function(_,tab)assert(tab=='Skins')end}
sidebar.SidebarMenus.Shop={ToggleMenu=function()end}
local currencyAPI=require(ui.SidebarHandler.Classes.CurrencyDisplay)
local cash=currencyAPI.new('Money','icon',false)
assert(cash.Instance.Amount.Text=='1234'and not cash.Instance.Plus.Visible and not cash.Instance.Plus.Active)
local afkAPI=require(ui.Misc.AFKButton);afkAPI:Start()
sidebar.Sidebar.Bottom.AFK.Button.Activated:Fire()
assert(requests[#requests][1]=='UpdateSettings'and requests[#requests][3]==afk and requests[#requests][4]==true,'AFK reuses the current setting endpoint')
for _,request in requests do assert(request[1]~='FavoriteSkin'and request[1]~='FavoriteCharacter'and request[1]~='RequestPreviewRig')end
print('PASS native UI integration: actual Sidebar/Button/Currency, pre-start registration, mutual navigation, settings search/reset/toggle on existing values, old log list/page rendering and hidden paid links')
