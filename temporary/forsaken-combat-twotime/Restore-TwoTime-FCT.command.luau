-- Restore the newest Two Time port backup, leaving Guest/Azure untouched. Stop Play first.
assert(game:GetService("RunService"):IsStudio() and not game:GetService("RunService"):IsRunning(),"Stop the playtest first.")
local function fingerprint(source)
 local a,b=5381,0
 for i=1,#source do local byte=string.byte(source,i);a=(a*33+byte)%4294967296;b=(b*65599+byte)%4294967296 end
 return string.format("%d:%08x:%08x",#source,a,b)
end
local function find(path)
 local current=game
 for name in path:gmatch("[^/]+") do current=current and current:FindFirstChild(name) end
 return current
end

local backups={}
for _,folder in game.ServerStorage:GetChildren() do
 if folder:IsA("Folder") and folder.Name:match("^TwoTimeFCTPort_Backup_") then table.insert(backups,folder) end
end
table.sort(backups,function(a,b)return a.Name>b.Name end)
local backup=assert(backups[1],"No Two Time port backup found.")
local pending={}
for _,saved in backup:GetChildren() do
 local path=saved:GetAttribute("OriginalPath")
 local target=assert(find(path),"Missing installed target: "..path..". Nothing restored.")
 assert(fingerprint(target.Source)==saved:GetAttribute("InstalledFingerprint"),"Installed module was edited: "..path..". Nothing restored; preserve those edits first.")
 table.insert(pending,{saved=saved,target=target,before=target.Source})
end
-- Restore Source in place so Config's visual children and Behavior's identity are retained.
local ok,err=pcall(function()
 for _,item in pending do if not item.saved:GetAttribute("WasCreated") then item.target.Source=item.saved.Source end end
end)
if not ok then
 for _,item in pending do item.target.Source=item.before end
 error("Restore failed; rolled back: "..tostring(err))
end
for _,item in pending do if item.saved:GetAttribute("WasCreated") then item.target:Destroy() end end
backup:Destroy()
pcall(function()game:GetService("ChangeHistoryService"):SetWaypoint("Restore Two Time")end)
print("[Two Time FCT Port] Restored. Save and start a fresh playtest.")
