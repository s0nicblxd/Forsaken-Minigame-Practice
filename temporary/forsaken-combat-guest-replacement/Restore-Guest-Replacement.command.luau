-- Restore the pre-replacement Guest assets. Stop Play first.
assert(game:GetService("RunService"):IsStudio() and not game:GetService("RunService"):IsRunning(),"Stop Play first.")
local function find(path)local current=game;for name in path:gmatch("[^/]+") do current=current and current:FindFirstChild(name) end;return current end
local backups={}
for _,folder in game.ServerStorage:GetChildren() do if folder.Name:match("^GuestReplacement_Backup_") then table.insert(backups,folder) end end
table.sort(backups,function(a,b)return a.Name>b.Name end)
local backup=assert(backups[1],"No Guest replacement backup found.")
local destinations={
 {path="ReplicatedStorage/Assets/Survivors",saved=assert(backup:FindFirstChild("ReplicatedGuest"),"Missing original replicated Guest.")},
 {path="ServerStorage/Assets/Survivors",saved=assert(backup:FindFirstChild("StoredGuest"),"Missing original stored Guest.")}
}
for _,item in ipairs(destinations) do
 item.parent=assert(find(item.path),"Missing asset parent. Nothing restored.")
 item.current=assert(item.parent:FindFirstChild("Guest1337"),"Missing replaced Guest. Nothing restored.")
 assert(item.current:GetAttribute("GuestReplacementVersion")=="1.0.0","Guest has been replaced again. Nothing restored.")
 item.prepared=item.saved:Clone();item.prepared.Name="Guest1337"
end
local aliases={}
for _,saved in backup:GetChildren() do
 local path=saved:GetAttribute("GuestReplacementOriginalPath")
 if path then
  local parent=assert(find(path:match("^(.*)/[^/]+$")),"Missing skin parent. Nothing restored.")
  assert(not parent:FindFirstChild("Guest1337Rework"),"Rework skin category was recreated. Nothing restored.")
  table.insert(aliases,{saved=saved,parent=parent})
 end
end
for _,item in ipairs(destinations) do item.current:Destroy();item.prepared.Parent=item.parent end
for _,item in ipairs(aliases) do
 local canonical=item.parent:FindFirstChild("Guest1337")
 if canonical then for _,skin in canonical:GetChildren() do if skin:GetAttribute("GuestReplacementAdded")==backup.Name then skin:Destroy() end end end
 item.saved.Name="Guest1337Rework";item.saved:SetAttribute("GuestReplacementOriginalPath",nil);item.saved.Parent=item.parent
end
backup:Destroy()
print("[Guest replacement] Restored the pre-replacement assets. Save and restart Play.")
