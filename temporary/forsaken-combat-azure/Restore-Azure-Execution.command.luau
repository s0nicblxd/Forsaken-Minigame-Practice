-- Stop Play before restoring the latest Azure execution repair.
assert(game:GetService("RunService"):IsStudio() and not game:GetService("RunService"):IsRunning(),"Stop Play first.")
local backups={}
for _,item in game.ServerStorage:GetChildren() do if item.Name:match("^AzureExecution_Backup_") then table.insert(backups,item) end end
table.sort(backups,function(a,b)return a.Name>b.Name end)
local backup=assert(backups[1],"No Azure execution backup found.")
local pending={}
for _,saved in backup:GetChildren() do
 local target=game
 for part in saved:GetAttribute("OriginalPath"):gmatch("[^/]+") do target=target and target:FindFirstChild(part) end
 assert(target and target:IsA("ModuleScript"),"Missing Azure target. Nothing restored.")
 table.insert(pending,{target=target,saved=saved})
end
for _,item in pending do
 item.target.Source=item.saved.Source
 local helper=item.target:FindFirstChild("ExecutionCompatibility");if helper then helper:Destroy() end
 local original=item.saved:FindFirstChild("ExecutionCompatibility");if original then original:Clone().Parent=item.target end
end
backup:Destroy()
print("[Azure execution repair] Restored. Save and restart Play.")
