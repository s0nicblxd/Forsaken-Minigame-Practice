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
