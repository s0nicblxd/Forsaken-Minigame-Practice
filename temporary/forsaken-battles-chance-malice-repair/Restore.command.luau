assert(not game:GetService("RunService"):IsRunning(),"Stop Play first.")
local backup
for _,item in game.ServerStorage:GetChildren()do if item.Name:match("^ChanceMaliceBackup_")and(not backup or item.Name>backup.Name)then backup=item end end
assert(backup,"No Chance/Malice backup found.")
for _,entry in backup:GetChildren()do if entry:IsA("StringValue")and entry:FindFirstChild("Target")and entry.Target.Value then entry.Target.Value.Source=entry.Value end end
local weld=backup.Weld.Value
if weld and backup.Holder.Value then weld.Enabled=false;weld.Part0=backup.OldPart0.Value;weld.Part1=backup.OldPart1.Value;backup.Holder.Value.CFrame=backup.OldCFrame.Value;weld.Enabled=backup.OldEnabled.Value end
local command=backup:FindFirstChild("SetPlayerMalice")
if command and backup:FindFirstChild("CommandOriginalParent")and backup.CommandOriginalParent.Value then command.Parent=backup.CommandOriginalParent.Value end
backup:Destroy()
print("Previous Sources, weld, holder position and command restored. Save and restart Play.")
