-- Restore the latest John Doe rig phase-one installation. Stop Play first.
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
for _,folder in game.ServerStorage:GetChildren() do if folder.Name:match("^JohnDoeRig_Backup_") then table.insert(backups,folder) end end
table.sort(backups,function(a,b)return a.Name>b.Name end)
local backup=assert(backups[1],"No John Doe rig backup found.")
local modules,assets,metadata={},{},{}
for _,saved in backup:GetChildren() do
 local path=saved:GetAttribute("JohnRigOriginalPath")
 local metaPath=saved:GetAttribute("JohnRigMetaPath")
 if path then
  local parent=assert(find(path:match("^(.*)/[^/]+$")),"Missing original parent: "..path..". Nothing restored.")
  local item={saved=saved,path=path,parent=parent,target=find(path),prepared=not saved:GetAttribute("JohnRigWasCreated") and saved:Clone() or nil}
  if item.prepared then item.prepared.Name=path:match("[^/]+$");item.prepared:SetAttribute("JohnRigOriginalPath",nil);item.prepared:SetAttribute("JohnRigWasCreated",nil) end
  if saved:IsA("ModuleScript") or path:match("/RigAlignment$") then table.insert(modules,item) else table.insert(assets,item) end
 elseif metaPath then table.insert(metadata,{root=assert(find(metaPath),"Missing John Doe folder"),saved=saved}) end
end
-- Restore module Sources in place, preserving children before restoring asset templates beneath Config.
for _,item in ipairs(modules) do
 if item.saved:GetAttribute("JohnRigWasCreated") then if item.target then item.target:Destroy() end
 else assert(item.target and item.target:IsA("ModuleScript"),"Missing original module");item.target.Source=item.saved.Source end
end
for _,item in ipairs(assets) do if item.target then item.target:Destroy() end;if item.prepared then item.prepared.Parent=item.parent end end
for _,item in ipairs(metadata) do item.root:SetAttribute("JohnDoeRigPhase",item.saved:GetAttribute("OldVersion"));item.root.Config:SetAttribute("JohnDoeRigScale",item.saved:GetAttribute("OldScale")) end
backup:Destroy()
print("[John Doe rig] Restored. Save and restart Play.")
