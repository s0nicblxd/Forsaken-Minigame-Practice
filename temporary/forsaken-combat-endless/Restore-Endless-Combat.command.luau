assert(game:GetService("RunService"):IsStudio()and not game:GetService("RunService"):IsRunning(),"Stop Play first.")
local function locate(path)
 local node=game
 for part in path:gmatch("[^/]+")do node=node and node:FindFirstChild(part)end
 return node
end
local function fingerprint(source)
 local a,b=5381,0
 for i=1,#source do local byte=source:byte(i);a=(a*33+byte)%4294967296;b=(b*65599+byte)%4294967296 end
 return string.format("%d:%08x:%08x",#source,a,b)
end

local backup=game:GetService("Selection"):Get()[1]
assert(backup and backup.Name:match("^EndlessCombat_Backup_"),"Select the EndlessCombat_Backup folder in ServerStorage.")
local pending={}
for _,saved in backup:GetChildren()do
 local path=saved:GetAttribute("OriginalPath");local target=locate(path)
 assert(target and target:IsA("ModuleScript")and fingerprint(target.Source)==saved:GetAttribute("InstalledFingerprint"),"Installed source was changed or removed: "..tostring(path)..". Nothing restored.")
 table.insert(pending,{saved=saved,target=target,before=target.Source,path=path})
end
table.sort(pending,function(a,b)return a.path>b.path end)
local ok,err=pcall(function()
 for _,item in pending do if not item.saved:GetAttribute("WasCreated")then item.target.Source=item.saved.Source end end
end)
if not ok then for _,item in pending do item.target.Source=item.before end;error("Restore rolled back: "..tostring(err))end
for _,item in pending do if item.saved:GetAttribute("WasCreated")then item.target:Destroy()end end
backup:Destroy()
print("[Endless combat] Original round manager/HUD restored. Save and restart Play.")
