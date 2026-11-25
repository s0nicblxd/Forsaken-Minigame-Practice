assert(not game:GetService("RunService"):IsRunning(),"Stop Play first.")
local backup
for _,item in game.ServerStorage:GetChildren()do
 if item.Name:match("^BuildermanPlacementBackup_")and(not backup or item.Name>backup.Name)then backup=item end
end
assert(backup,"No Builderman placement backup found.")
for _,saved in backup:GetChildren()do
 if saved:IsA("StringValue")and saved:FindFirstChild("Target")and saved.Target.Value then saved.Target.Value.Source=saved.Value end
end
local helper=backup:FindFirstChild("AddedHelper")
if helper and helper.Value then helper.Value:Destroy()end
backup:Destroy()
print("Previous Builderman Sources restored. Save and restart Play.")
