assert(game:GetService("RunService"):IsStudio()and not game:GetService("RunService"):IsRunning(),"Stop Play first.")
local function find(path)
 local current=game
 for part in path:gmatch("[^/]+")do current=current and current:FindFirstChild(part)end
 return current
end
local function fingerprint(source)
 local a,b=5381,0
 for i=1,#source do local byte=source:byte(i);a=(a*33+byte)%4294967296;b=(b*65599+byte)%4294967296 end
 return string.format("%d:%08x:%08x",#source,a,b)
end

local backup=game:GetService("Selection"):Get()[1]
assert(backup and backup.Name:match("^NoCutscenes_Backup_"),"Select the NoCutscenes_Backup folder in ServerStorage.")
local pending={}
for _,saved in backup:GetChildren()do
 local target=find(saved:GetAttribute("OriginalPath"))
 assert(target and fingerprint(target.Source)==saved:GetAttribute("AfterFingerprint"),"Installed Source was edited. Nothing restored.")
 table.insert(pending,{target=target,before=target.Source,after=saved.Source})
end
local ok,err=pcall(function()for _,item in pending do item.target.Source=item.after end end)
if not ok then for _,item in pending do item.target.Source=item.before end;error("Restore rolled back: "..tostring(err))end
backup:Destroy();print("[No cutscenes] Original presentation restored. Save and restart Play.")
