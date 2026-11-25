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
if #selected==1 and selected[1].Name:match("^FBStats_Backup_")then backup=selected[1]end
assert(backup,"Select the FBStats_Backup folder first.")
local backend=assert(backup.Backend.Value)
assert(fingerprint(backend.Source)==backup:GetAttribute("BackendSource")and fingerprint(backend.Schema.Source)==backup:GetAttribute("SchemaSource"),"Stats backend edited since install. Nothing changed.")
local changes={}
for _,record in backup:GetChildren()do
 if record.Name:match("^Source_")then
  local target=assert(record.Target.Value)
  assert(fingerprint(target.Source)==record:GetAttribute("Installed"),"Module edited since install: "..target:GetFullName()..". Nothing changed.")
  table.insert(changes,{target=target,before=record.Before.Value,installed=target.Source})
 end
end
local ok,err=pcall(function()for _,change in changes do change.target.Source=change.before end end)
if not ok then
 for _,change in changes do if change.target.Source~=change.installed then change.target.Source=change.installed end end
 error("Restore rolled back: "..tostring(err))
end
backend:Destroy();backup.InstalledStats.Value:Destroy();backup.OriginalStats.Value.Parent=backup.Template.Value
workspace:SetAttribute("FriendlyFire",backup:GetAttribute("OldFriendlyFire"));backup:Destroy()
print("[FB stats] Restored previous modules, template and Friendly Fire default. Save and restart Play.")
