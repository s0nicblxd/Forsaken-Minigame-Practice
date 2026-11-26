assert(not game:GetService("RunService"):IsRunning(),"Stop Play first.")
local backup
for _,item in game.ServerStorage:GetChildren()do if item.Name:match("^ThemesRepairBackup_")and(not backup or item.Name>backup.Name)then backup=item end end
assert(backup,"No Themes repair backup found.")
game.ServerScriptService.Server.Systems.Core.RoundManager.Source=backup.RoundManagerSource.Value
for _,entry in backup:GetChildren()do
 if entry:IsA("ObjectValue")and entry.Name:match("^DisabledTest")and entry.Value then entry.Value.Disabled=false end
end
local created=backup:FindFirstChild("CreatedThemes")
if created and created.Value and #created.Value:GetChildren()==0 then created.Value:Destroy()end
backup:Destroy()
print("Previous RoundManager and test-script state restored. Save and restart Play.")
