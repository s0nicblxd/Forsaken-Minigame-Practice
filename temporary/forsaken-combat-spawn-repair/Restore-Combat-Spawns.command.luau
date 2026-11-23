assert(game:GetService("RunService"):IsStudio()and not game:GetService("RunService"):IsRunning(),"Stop Play first.")
local backup=game:GetService("Selection"):Get()[1]
assert(backup and backup.Name:match("^CombatSpawns_Backup_"),"Select the CombatSpawns_Backup folder in ServerStorage.")
local moves,properties,created={},{},{}
for _,saved in backup:GetChildren()do
 local target=saved:FindFirstChild("Target")and saved.Target.Value
 assert(target and target.Parent,"A repaired object was removed. Nothing restored.")
 if saved.Name:match("^Move_")then
  assert(target.Parent==saved.After.Value and saved.Before.Value,"Moved object has changed parent. Nothing restored.")
  table.insert(moves,{target=target,before=saved.Before.Value,after=saved.After.Value})
 elseif saved.Name:match("^Property_")then
  local key=saved:GetAttribute("Property")
  assert(target[key]==saved:GetAttribute("After"),"Repaired property was edited: "..key..". Nothing restored.")
  table.insert(properties,{target=target,key=key,before=saved:GetAttribute("Before"),after=saved:GetAttribute("After")})
 elseif saved.Name:match("^Created_")then
  assert(target.ClassName==saved:GetAttribute("ClassName")and target.Name==saved:GetAttribute("ObjectName"),"Created object changed. Nothing restored.")
  if target:IsA("Script")then assert(target.Source==saved:GetAttribute("DriverSource")and target:FindFirstChild("Controller")and target.Controller.Source==saved:GetAttribute("ControllerSource"),"Spawn scripts were edited. Nothing restored.")end
  table.insert(created,target)
 end
end
local ok,err=pcall(function()
 for _,item in properties do item.target[item.key]=item.before end
 for _,item in moves do item.target.Parent=item.before end
end)
if not ok then
 for _,item in properties do item.target[item.key]=item.after end
 for _,item in moves do item.target.Parent=item.after end
 error("Restore rolled back: "..tostring(err))
end
for _,object in created do object:Destroy()end
backup:Destroy()
print("[Combat spawn repair] Original layout and settings restored. Save and restart Play.")
