assert(game:GetService("RunService"):IsStudio()and not game:GetService("RunService"):IsRunning(),"Stop Play first.")
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

local backup=game:GetService("Selection"):Get()[1]
assert(backup and backup.Name:match("^CombatMenus_Backup_"),"Select the CombatMenus_Backup folder in ServerStorage.")
local spectating=backup.Spectating.Value
assert(spectating and fingerprint(spectating.Source)==backup:GetAttribute("InstalledSpectating"),"Spectating was edited. Nothing restored.")
local hud=backup:FindFirstChild("HUD")and backup.HUD.Value
if hud then assert(fingerprint(hud.Source)==backup:GetAttribute("InstalledHUD"),"HUD was edited. Nothing restored.")end
local helpers=backup.Helpers.Value
assert(helpers and helpers.Parent==game.ReplicatedStorage.Modules,"Menu compatibility helpers moved/missing. Nothing restored.")
local records={}
for _,record in backup:GetChildren()do
 if record:IsA("Folder")and record.Name:match("^Tree_")then
  local parent=record.OriginalParent.Value;local old=record:FindFirstChild("Original")and record.Original.Value
  local installed=record:FindFirstChild("Installed")and record.Installed.Value
  assert(parent and(not old or old.Parent==record),"Archived tree was moved. Nothing restored.")
  assert(not installed or installed.Parent==parent,"Installed menu was moved. Nothing restored.")
  assert(not parent:FindFirstChild(record:GetAttribute("ObjectName"))or parent:FindFirstChild(record:GetAttribute("ObjectName"))==installed,"Menu name conflict. Nothing restored.")
  table.insert(records,{record=record,parent=parent,old=old,installed=installed})
 end
end
local currentSource=spectating.Source
local currentHUD=hud and hud.Source
local ok,err=pcall(function()
 spectating.Source=backup.BeforeSpectating.Value
 if hud then hud.Source=backup.BeforeHUD.Value end
 for _,item in records do
  if item.installed then item.installed.Parent=nil end
  if item.old then item.old.Parent=item.parent end
 end
end)
if not ok then
 spectating.Source=currentSource
 if hud then hud.Source=currentHUD end
 for _,item in records do if item.old then item.old.Parent=item.record end;if item.installed then item.installed.Parent=item.parent end end
 error("Menu restore rolled back: "..tostring(err))
end
for _,item in records do if item.installed then item.installed:Destroy()end end
helpers:Destroy();backup:Destroy()
print("[Combat menus] Previous menus restored. Save and start a fresh playtest.")
