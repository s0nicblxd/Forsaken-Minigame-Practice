assert(not game:GetService("RunService"):IsRunning(),"Stop Play first.")
local backup
for _,item in game.ServerStorage:GetChildren()do if item.Name:match("^N7VeeGlobalBackup_")and(not backup or item.Name>backup.Name)then backup=item end end
assert(backup,"No n7/Vee/global backup found.")
for _,entry in backup:GetChildren()do if entry:IsA("StringValue")and entry:FindFirstChild("Target")and entry.Target.Value then entry.Target.Value.Source=entry.Value end end
for _,entry in backup.Additions:GetChildren()do if entry.Value then entry.Value:Destroy()end end
local display=game.ReplicatedStorage.Systems.Character.Game.PlayerInfoDisplay
for _,object in backup.Assets:GetChildren()do object.Parent=display end
display:SetAttribute("FBGameplayHUD2026",backup.HadHUD.Value and true or nil)
backup:Destroy()
print("Previous Sources, HUD and settings restored. Save and restart Play.")
