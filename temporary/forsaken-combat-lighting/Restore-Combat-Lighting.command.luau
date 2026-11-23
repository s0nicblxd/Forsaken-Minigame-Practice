assert(game:GetService("RunService"):IsStudio()and not game:GetService("RunService"):IsRunning(),"Stop Play first.")
local backup=game:GetService("Selection"):Get()[1]
assert(backup and backup.Name:match("^CombatLighting_Backup_"),"Select the CombatLighting_Backup folder in ServerStorage.")
local schema=backup.Controller.Value
assert(schema and schema.Source==backup:GetAttribute("AfterSource"),"Lighting controller was edited. Nothing restored.")
local props,archived,created={},{},{}
for _,saved in backup:GetChildren()do
 if saved:IsA("Folder")then
  local target=saved.Target.Value
  assert(target and target.Parent,"Lighting object was removed. Nothing restored.")
  if saved.Name:match("^Property_")then
   local key=saved:GetAttribute("Property")
   assert(target[key]==saved:GetAttribute("After"),"Lighting property edited: "..key..". Nothing restored.")
   table.insert(props,{target=target,key=key,before=saved:GetAttribute("Before"),after=saved:GetAttribute("After")})
  elseif saved.Name:match("^Archived_")then
   assert(target.Parent==saved and saved.OriginalContainer.Value,"Archived lighting object moved. Nothing restored.")
   table.insert(archived,{target=target,parent=saved.OriginalContainer.Value,saved=saved})
  elseif saved.Name:match("^Created_")then
   assert(target.Parent==saved.OriginalContainer.Value and target:IsA("Sky")and target.Name=="Skybox_Sunset","Installed sky moved. Nothing restored.")
   table.insert(created,target)
  end
 end
end
local current=schema.Source
local ok,err=pcall(function()
 schema.Source=backup.BeforeSource.Value
 for _,item in props do item.target[item.key]=item.before end
 for _,item in archived do item.target.Parent=item.parent end
end)
if not ok then
 schema.Source=current
 for _,item in props do item.target[item.key]=item.after end
 for _,item in archived do item.target.Parent=item.saved end
 error("Lighting restore rolled back: "..tostring(err))
end
for _,object in created do object:Destroy()end
backup:Destroy()
print("[Combat lighting] Previous Lighting/default preset restored. Save and restart Play.")
