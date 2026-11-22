-- Restore the latest Corrupt Energy patch. Stop Play first.
assert(game:GetService("RunService"):IsStudio() and not game:GetService("RunService"):IsRunning(),"Stop Play first.")
local function find(path)
 local current=game
 for name in path:gmatch("[^/]+") do current=current and current:FindFirstChild(name) end
 return current
end
local function fingerprint(source)
 local a,b=5381,0
 for i=1,#source do local byte=string.byte(source,i);a=(a*33+byte)%4294967296;b=(b*65599+byte)%4294967296 end
 return string.format("%d:%08x:%08x",#source,a,b)
end

local backups={}
for _,folder in game.ServerStorage:GetChildren() do if folder.Name:match("^JohnCorruptEnergy_Backup_") then table.insert(backups,folder) end end
table.sort(backups,function(a,b)return a.Name>b.Name end)
local backup=assert(backups[1],"No Corrupt Energy backup found.")
local pending={}
for _,saved in backup:GetChildren() do
 local path=saved:GetAttribute("OriginalPath");local target=assert(find(path),"Missing installed target: "..path..". Nothing restored.")
 assert(target:IsA("ModuleScript") and fingerprint(target.Source)==saved:GetAttribute("InstalledFingerprint"),"Edited installed module: "..path..". Nothing restored.")
 table.insert(pending,{saved=saved,target=target,before=target.Source,path=path})
end
table.sort(pending,function(a,b)return a.path>b.path end)
local ok,err=pcall(function()
 for _,item in ipairs(pending) do if not item.saved:GetAttribute("WasCreated") then item.target.Source=item.saved.Source end end
end)
if not ok then for _,item in ipairs(pending) do if not item.saved:GetAttribute("WasCreated") then item.target.Source=item.before end end;error("Restore rolled back: "..tostring(err)) end
for _,item in ipairs(pending) do if item.saved:GetAttribute("WasCreated") then item.target:Destroy() end end
backup:Destroy()
print("[John Corrupt Energy] Restored the previous kit. Save and restart Play.")
