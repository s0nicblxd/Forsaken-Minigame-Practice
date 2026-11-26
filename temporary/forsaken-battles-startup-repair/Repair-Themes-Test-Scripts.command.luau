assert(not game:GetService("RunService"):IsRunning(),"Stop Play mode before applying this repair.")
local round=game.ServerScriptService.Server.Systems.Core.RoundManager
local before=round.Source
local needle='local Themes = workspace:WaitForChild("Themes")'
local replacement=[[local Themes = workspace:FindFirstChild("Themes")
if not Themes then
 Themes = Instance.new("Folder")
 Themes.Name = "Themes"
 Themes.Parent = workspace
end]]
local after=before
if not before:find(replacement,1,true)then
 local first,last=before:find(needle,1,true)
 assert(first and not before:find(needle,last+1,true),"RoundManager's Themes code differs from the supplied build. Nothing changed.")
 after=before:sub(1,first-1)..replacement..before:sub(last+1)
end
local targets={}
for _,object in game:GetDescendants()do
 if object:IsA("Script")then
  local source=object.Source
  if source:find("rbxassetid://123762944589851",1,true)and source:find("while wait(4)",1,true)and source:find("hitboxes:CreateHitbox",1,true)and not object.Disabled then table.insert(targets,object)end
 end
end
local existing=workspace:FindFirstChild("Themes")
if before==after and #targets==0 and existing then print("Themes/test-script repair already installed.");return end
local backup=Instance.new("Folder");backup.Name="ThemesRepairBackup_"..os.time()
local saved=Instance.new("StringValue");saved.Name="RoundManagerSource";saved.Value=before;saved.Parent=backup
for i,object in targets do
 local target=Instance.new("ObjectValue");target.Name="DisabledTest"..i;target.Value=object;target.Parent=backup
end
backup.Parent=game.ServerStorage
local created=nil
local ok,err=pcall(function()
 round.Source=after
 if not existing then created=Instance.new("Folder");created.Name="Themes";created.Parent=workspace end
 for _,object in targets do object.Disabled=true;print("Disabled old rig test script:",object:GetFullName())end
end)
if not ok then
 pcall(function()round.Source=before end)
 for _,object in targets do pcall(function()object.Disabled=false end)end
 if created then created:Destroy()end
 error("Repair failed; originals restored: "..tostring(err))
end
if created then local target=Instance.new("ObjectValue");target.Name="CreatedThemes";target.Value=created;target.Parent=backup end
print("Themes startup repaired; disabled "..#targets.." old animation/hitbox test scripts. Save and start a fresh Play session. Backup: "..backup:GetFullName())
