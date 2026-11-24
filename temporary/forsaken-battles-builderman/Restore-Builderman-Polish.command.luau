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
local selection=game:GetService("Selection"):Get();local backup
if #selection==1 and selection[1].Name:match("^BuildermanPolish_Backup_")then backup=selection[1]end
assert(backup,"Select the BuildermanPolish_Backup folder first.")
local root=assert(backup.Root.Value);local helper=assert(backup.Helper.Value)
assert(fingerprint(helper.Source)==backup:GetAttribute("HelperSource"),"CarryVisuals edited since repair. Nothing changed.")
local changes={}
for _,record in backup:GetChildren()do
 if record.Name:match("^Source_")then
  local target=assert(record.Target.Value)
  assert(fingerprint(target.Source)==record:GetAttribute("Installed"),"Module edited since repair: "..target:GetFullName()..". Nothing changed.")
  table.insert(changes,{target=target,before=record.Before.Value,installed=target.Source})
 end
end
local ok,err=pcall(function()for _,change in changes do change.target.Source=change.before end end)
if not ok then
 for _,change in changes do if change.target.Source~=change.installed then change.target.Source=change.installed end end
 error("Restore rolled back: "..tostring(err))
end
helper:Destroy();root:SetAttribute("BuildermanPortVersion",backup:GetAttribute("OldVersion"));backup:Destroy()
print("[Builderman polish] Restored prior Builderman port. Save and restart Play.")
