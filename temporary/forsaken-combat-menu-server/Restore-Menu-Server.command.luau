local function find(path)
 local object=game
 for part in path:gmatch("[^/]+")do object=object and object:FindFirstChild(part)end
 return object
end
local function fingerprint(source)
 local a,b=5381,0
 for i=1,#source do local v=source:byte(i);a=(a*33+v)%4294967296;b=(b*65599+v)%4294967296 end
 return string.format("%d:%08x:%08x",#source,a,b)
end
assert(game:GetService("RunService"):IsStudio()and not game:GetService("RunService"):IsRunning(),"Stop Play first.")
local backup
local selected=game:GetService("Selection"):Get()
if #selected==1 and selected[1].Name:match("^CombatMenuServer_Backup_")then backup=selected[1]end
if not backup then
 for _,item in game.ServerStorage:GetChildren()do
  if item.Name:match("^CombatMenuServer_Backup_")and(not backup or item.Name>backup.Name)then backup=item end
 end
end
assert(backup,"Select the CombatMenuServer_Backup folder first.")
local changes={}
for _,record in backup:GetChildren()do
 if record.Name:match("^Source_")then
  local target=assert(record.Target.Value,"Original module is missing")
  assert(fingerprint(target.Source)==record:GetAttribute("Installed"),"Module edited since installation: "..target:GetFullName()..". Nothing changed.")
  table.insert(changes,{target=target,before=record.Before.Value,installed=target.Source})
 end
end
local ok,err=pcall(function()for _,change in changes do change.target.Source=change.before end end)
if not ok then
 for _,change in changes do if change.target.Source~=change.installed then change.target.Source=change.installed end end
 error("Restore rolled back: "..tostring(err))
end
backup.Backend.Value:Destroy()
backup.Favorites.Value:Destroy()
if backup:FindFirstChild("OldFavorites")then backup.OldFavorites.Value.Parent=backup.Template.Value end
backup:Destroy()
print("[Menu backend] Restored previous modules and template. Save and restart Play.")
