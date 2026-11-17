-- Stop the playtest. Restores the newest Azure-port backup, preserving the Guest patch.
assert(game:GetService("RunService"):IsStudio() and not game:GetService("RunService"):IsRunning(),"Stop the playtest first.")
local backups={}
for _,f in ipairs(game.ServerStorage:GetChildren())do
 if f:IsA("Folder") and f.Name:match("^AzureFCTPort_Backup_")then table.insert(backups,f)end
end
table.sort(backups,function(a,b)return a.Name>b.Name end)
local folder=assert(backups[1],"No AzureFCTPort backup found.")
local pending={}
for _,saved in ipairs(folder:GetChildren())do
 local path=saved:GetAttribute("OriginalPath")
 if path then
  local target=game
  for name in path:gmatch("[^/]+")do target=target and target:FindFirstChild(name)end
  if not saved:GetAttribute("WasCreated")then assert(target and target:IsA("ModuleScript"),"Missing target: "..path..". Nothing restored.")end
  table.insert(pending,{target=target,saved=saved})
 end
end
for _,item in ipairs(pending)do
 if item.saved:GetAttribute("WasCreated")then if item.target then item.target:Destroy()end
 else item.target.Source=item.saved.Source end
end
print("[Azure FCT Port] Restored "..#pending.." scripts from "..folder.Name..". Start a fresh playtest.")
