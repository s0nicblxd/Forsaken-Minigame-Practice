assert(game:GetService("RunService"):IsStudio()and not game:GetService("RunService"):IsRunning(),"Stop Play first.")
local function find(path)
 local object=game
 for name in path:gmatch("[^/]+")do object=object and object:FindFirstChild(name)end
 return object
end
local function fingerprint(s)
 local a,b=5381,0
 for i=1,#s do local v=s:byte(i);a=(a*33+v)%4294967296;b=(b*65599+v)%4294967296 end
 return string.format("%d:%08x:%08x",#s,a,b)
end
local function ref(parent,name,value)local object=Instance.new("ObjectValue");object.Name=name;object.Value=value;object.Parent=parent end
local selected=game:GetService("Selection"):Get();local backup
if #selected==1 and selected[1].Name:match("^BuildermanPort_Backup_")then backup=selected[1]end
assert(backup,"Select the BuildermanPort_Backup folder in ServerStorage first.")
local installed=assert(backup.Installed.Value,"Installed Builderman missing")
local original=assert(backup.Original.Value,"Original Builderman missing")
local rows={}
for _,module in installed:GetDescendants()do if module:IsA("LuaSourceContainer")then table.insert(rows,module:GetFullName():sub(#installed:GetFullName()+2).."="..fingerprint(module.Source))end end
table.sort(rows)
assert(table.concat(rows,"|")==backup:GetAttribute("InstalledSources"),"Builderman Sources edited since installation. Nothing changed.")
assert(installed.Parent==find("ReplicatedStorage/Assets/Survivors"),"Installed Builderman moved. Nothing changed.")
local parent=installed.Parent
local changes={}
for _,record in backup:GetChildren()do
 if record.Name:match("^Shared_")then
  local target=assert(record.Target.Value)
  assert(fingerprint(target.Source)==record:GetAttribute("Installed"),"Shared module edited since installation: "..target:GetFullName()..". Nothing changed.")
  table.insert(changes,{target=target,before=record.Before.Value,current=target.Source})
 end
end
local ok,err=pcall(function()for _,change in changes do change.target.Source=change.before end end)
if not ok then for _,change in changes do if change.target.Source~=change.current then change.target.Source=change.current end end;error("Restore rolled back: "..tostring(err))end
original.Parent=parent;installed:Destroy();backup:Destroy()
print("[Builderman] Restored original character. Save and restart Play.")
