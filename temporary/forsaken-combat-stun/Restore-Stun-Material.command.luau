-- Restores the most recent material-only repair, keeping the stun protection gameplay installed.
assert(game:GetService("RunService"):IsStudio() and not game:GetService("RunService"):IsRunning(),"Stop Play first.")
local backups={}
for _,folder in game.ServerStorage:GetChildren() do
 if folder:IsA("Folder") and folder.Name:match("^StunProtectionMaterial_Backup_") then table.insert(backups,folder) end
end
table.sort(backups,function(a,b)return a.Name>b.Name end)
local backup=assert(backups[1],"No stun material repair backup found.")
local saved=assert(backup:FindFirstChild("StunProtectionVFX"),"Missing saved material template.")
local parent=game.ReplicatedStorage.Assets.Instances
local target=assert(parent:FindFirstChild("StunProtectionVFX"),"Missing current template.")
assert(target:GetAttribute("StunMaterialRepairVersion")=="1.0.1" or target:GetAttribute("StunMaterialRepairVersion")=="1.0.2" or target:GetAttribute("StunMaterialRepairVersion")=="1.0.3" or target:GetAttribute("StunMaterialRepairVersion")=="1.0.4","The current template is not the material repair. Nothing restored.")
local restored=saved:Clone()
local ok,err=pcall(function()target.Parent=nil;restored.Parent=parent end)
if not ok then restored:Destroy();target.Parent=parent;error("Material restore rolled back: "..tostring(err))end
target:Destroy();backup:Destroy()
print("[Stun Material Repair] Restored the previous material. Save and start a fresh playtest.")
