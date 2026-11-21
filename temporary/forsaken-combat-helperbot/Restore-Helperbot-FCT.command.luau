-- Restore the latest Helperbot installation backup in Edit mode.
assert(game:GetService("RunService"):IsStudio() and not game:GetService("RunService"):IsRunning(),"Stop Play first.")
local backups={}
for _,folder in game.ServerStorage:GetChildren() do if folder.Name:match("^HelperbotPort_Backup_") then table.insert(backups,folder) end end
table.sort(backups,function(a,b)return a.Name>b.Name end)
local backup=assert(backups[1],"No Helperbot port backup found.")
local survivors=game.ReplicatedStorage.Assets.Survivors
local helper=survivors:FindFirstChild("Helperbot")
assert(helper and helper:GetAttribute("HelperbotPortVersion")=="1.0.0","Installed Helperbot was removed or replaced. Nothing restored.")
if backup:GetAttribute("HadHelperbot") then assert(backup:FindFirstChild("Helperbot"),"Original Helperbot backup is missing. Nothing restored.") end
local statuses=game.ReplicatedStorage.Modules.StatusEffects
helper:Destroy()
if backup:GetAttribute("HadHelperbot") then backup.Helperbot.Parent=survivors end
for _,name in {"Haste","Fatigue"} do local status=statuses:FindFirstChild(name);if status then status:Destroy() end end
backup:Destroy()
pcall(function()game:GetService("ChangeHistoryService"):SetWaypoint("Restore Helperbot")end)
print("[Helperbot Port] Restored. Save and restart Play.")
