-- Run while NOT playtesting. Uses the newest GuestCombatFix backup folder.
assert(game:GetService("RunService"):IsStudio() and not game:GetService("RunService"):IsRunning(), "Stop the playtest first.")
local backups={}
for _,child in ipairs(game.ServerStorage:GetChildren())do
 if child:IsA("Folder") and child.Name:match("^GuestCombatFix_Backup_")then table.insert(backups,child)end
end
table.sort(backups,function(a,b)return a.Name>b.Name end)
local folder=assert(backups[1],"No GuestCombatFix backup found.")
local pending={}
for _,saved in ipairs(folder:GetChildren())do
 local path=saved:GetAttribute("OriginalPath")
 if saved:IsA("ModuleScript") and path then
  local target=game
  for name in path:gmatch("[^/]+")do target=target and target:FindFirstChild(name)end
  assert(target and target:IsA("ModuleScript"),"Missing target: "..path..". Nothing restored.")
  table.insert(pending,{target=target,source=saved.Source})
 end
end
for _,item in ipairs(pending)do item.target.Source=item.source end
print("[Guest Combat Fix] Restored "..#pending.." scripts from "..folder.Name..". Start a fresh playtest.")
