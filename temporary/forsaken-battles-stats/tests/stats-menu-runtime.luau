
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

local nativeTypeof=typeof
local function typeof(value)if type(value)=="table"and value._props then return "Instance"end;return nativeTypeof(value)end
local function signal()
 local entries={}
 return {Connect=function(_,callback)
  local object={Active=true};function object:Disconnect()self.Active=false end
  table.insert(entries,{object,callback});return object
 end,Fire=function(_,...)
  for _,entry in table.clone(entries)do if entry[1].Active then entry[2](...)end end
 end}
end
function Methods:WaitForChild(name)return self:FindFirstChild(name)end

fresh()
local make=Instance.new
function Instance.new(class,parent)
 local object=make(class,parent)
 if class=="TextButton"then object.Activated=signal()end
 return object
end
function Methods:GetPropertyChangedSignal(name)
 self.Signals=self.Signals or {};self.Signals[name]=self.Signals[name]or signal();return self.Signals[name]
end
local schema=(function()
return {
 {"General","GENERAL",{{"TimePlayed","Time Played",true},{"InGameTime","In-Game Time",true},{"TotalKills","Total Kills"},{"TotalDeaths","Total Deaths"}}},
 {"SurvivorStats","SURVIVOR STATS",{{"SurvivorKills","Survivor Kills"},{"SurvivorDeaths","Survivor Deaths"},{"BestSurvivorTime","Best Survivor Time",true},{"BestSurvivorKillstreak","Best Survivor Killstreak"}}},
 {"KillerStats","KILLER STATS",{{"KillerKills","Killer Kills"},{"KillerDeaths","Killer Deaths"},{"BestKillerTime","Best Killer Time",true},{"BestKillerKillstreak","Best Killer Killstreak"}}},
 {"Currency","CURRENCY",{{"Money","Money"},{"NetWorth","Net Worth"}}}
}

end)()
local stats=Instance.new("Folder")
for index,section in schema do
 local group=child(stats,section[1]);group:SetAttribute("DisplayTitle",section[2]);group:SetAttribute("LayoutOrder",index)
 for order,field in section[3]do
  local value=child(group,field[1],"NumberValue");value.Value=0
  value:SetAttribute("CombatStat",true);value:SetAttribute("DisplayTitle",field[2]);value:SetAttribute("LayoutOrder",order)
  if field[3]then value:SetAttribute("PostDisplayTitle","Time")end
 end
end
child(stats.SurvivorStats,"SurvivorWins","NumberValue").Value=999
child(stats.Currency,"RbxSpent","NumberValue").Value=300
local ui=Instance.new("Frame");local container=child(ui,"StatsContainer","Frame");local contents=child(container,"Contents","Frame")
local templates=Instance.new("Folder");local separator=child(templates,"Seperator","Frame");child(separator,"Title","TextLabel")
child(templates,"Title","TextLabel")
local script={StatsScreen={},Templates=templates}
game.ReplicatedStorage.Modules.DataHandler={Get=function()return stats.Parent end}
local profile=Instance.new("Folder");stats.Name="Stats";stats.Parent=profile
game.ReplicatedStorage.Modules.Util={FormatTime=function(_,value)return "time:"..value end}
game.ReplicatedStorage.Initializer={PlayerSystems={SidebarHandler={CreateSidebarMenu=function()return {Menu=ui}end}}}
local UDim2={fromScale=function()return {}end}
local function require(module)return module end
local Menu=(function()
local Menu={}
local DataHandler=require(game.ReplicatedStorage.Modules.DataHandler)
local Util=require(game.ReplicatedStorage.Modules.Util)
function Menu.Start()
 local stats=DataHandler:Get():WaitForChild("Stats")
 Menu.StatsMenu=require(game.ReplicatedStorage.Initializer).PlayerSystems.SidebarHandler:CreateSidebarMenu("Stats",script.StatsScreen)
 local contents=Menu.StatsMenu.Menu.StatsContainer.Contents
 for _,group in stats:GetChildren()do
  if group:IsA("Folder")then
   local rows={}
   local header=script.Templates.Seperator:Clone();header.Name=group.Name
   header.LayoutOrder=(group:GetAttribute("LayoutOrder")or 99)*100
   local title=group:GetAttribute("DisplayTitle")or group.Name
   header.Title.Text=title.." [-]";header.Parent=contents
   local button=Instance.new("TextButton");button.Name="Collapse";button.Size=UDim2.fromScale(1,1);button.BackgroundTransparency=1;button.Text="";button.Parent=header
   local collapsed=false
   button.Activated:Connect(function()
    collapsed=not collapsed;header.Title.Text=title..(collapsed and " [+]"or " [-]")
    for _,row in rows do row.Visible=not collapsed end
   end)
   for _,value in group:GetChildren()do
    if value:IsA("NumberValue")and value:GetAttribute("CombatStat")then
     local row=script.Templates.Title:Clone();row.Name=value.Name
     row.LayoutOrder=header.LayoutOrder+(value:GetAttribute("LayoutOrder")or 99);row.Parent=contents
     table.insert(rows,row)
     local function update()
      local label=value:GetAttribute("DisplayTitle")or value.Name
      local number=value.Value
      local text=value:GetAttribute("PostDisplayTitle")=="Time"and Util:FormatTime(math.floor(number),"String")or tostring(number)
      row.Text=label..": "..text
     end
     value:GetPropertyChangedSignal("Value"):Connect(update);update()
    end
   end
  end
 end
end
return Menu

end)()
Menu.Start()
assert(#contents:GetChildren()==18,"wrong number of groups/selected stats")
assert(not contents:FindFirstChild("SurvivorWins")and not contents:FindFirstChild("RbxSpent"))
assert(contents.TotalKills.Text=="Total Kills: 0")
stats.General.TotalKills.Value=5;stats.General.TotalKills:GetPropertyChangedSignal("Value"):Fire()
assert(contents.TotalKills.Text=="Total Kills: 5")
contents.General.Collapse.Activated:Fire();assert(contents.TotalKills.Visible==false)
contents.General.Collapse.Activated:Fire();assert(contents.TotalKills.Visible==true)
print("PASS actual Stats menu: four concept sections/14 counters, live updates, collapse/expand and legacy/Robux fields excluded")
