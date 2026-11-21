-- Restore the latest stun-protection backup. Stop Play first.
assert(game:GetService("RunService"):IsStudio() and not game:GetService("RunService"):IsRunning(),"Stop Play first.")
local function find(path)
 local current=game
 for part in path:gmatch("[^/]+") do current=current and current:FindFirstChild(part) end
 return current
end
local function fingerprint(source)
 local a,b=5381,0
 for i=1,#source do local byte=string.byte(source,i);a=(a*33+byte)%4294967296;b=(b*65599+byte)%4294967296 end
 return string.format("%d:%08x:%08x",#source,a,b)
end

local backups={}
for _,folder in game.ServerStorage:GetChildren() do if folder:IsA("Folder") and folder.Name:match("^StunProtectionPort_Backup_")then table.insert(backups,folder)end end
table.sort(backups,function(a,b)return a.Name>b.Name end)
local backup=assert(backups[1],"No stun-protection backup found.")
local pending={}
for _,saved in backup:GetChildren() do
 local path=saved:GetAttribute("OriginalPath");local target=assert(find(path),"Missing installed target: "..path..". Nothing restored.")
 if not saved:GetAttribute("IsVisualTemplate") then assert(fingerprint(target.Source)==saved:GetAttribute("InstalledFingerprint"),"Edited installed source: "..path..". Nothing restored.")end
 table.insert(pending,{saved=saved,target=target,before=not saved:GetAttribute("IsVisualTemplate") and target.Source or nil})
end
local ok,err=pcall(function()
 for _,item in pending do if not item.saved:GetAttribute("WasCreated") and not item.saved:GetAttribute("IsVisualTemplate") then item.target.Source=item.saved.Source end end
end)
if not ok then for _,item in pending do if item.before then item.target.Source=item.before end end;error("Restore rolled back: "..tostring(err))end
for _,item in pending do
 if item.saved:GetAttribute("IsVisualTemplate") then
  local parent=item.target.Parent;item.target:Destroy()
  if not item.saved:GetAttribute("WasCreated") then local copy=item.saved:Clone();copy.Name="StunProtectionVFX";for _,key in {"OriginalPath","WasCreated","IsVisualTemplate"}do copy:SetAttribute(key,nil)end;copy.Parent=parent end
 elseif item.saved:GetAttribute("WasCreated") then item.target:Destroy()end
end
backup:Destroy()
print("[Stun Protection Port] Restored. Save and start a fresh playtest.")
