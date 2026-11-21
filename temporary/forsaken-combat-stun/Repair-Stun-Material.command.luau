-- Material-only correction: adds the emissive mask omitted from the first export.
assert(game:GetService("RunService"):IsStudio() and not game:GetService("RunService"):IsRunning(),"Stop Play before repairing the material.")
local parent=game.ReplicatedStorage.Assets.Instances
local target=assert(parent:FindFirstChild("StunProtectionVFX"),"Install the stun-protection port first.")
assert(target:IsA("MeshPart") and target.MeshId:match("%d+")=="76640378318129","Unexpected stun-protection mesh. Nothing changed.")
if target:GetAttribute("StunMaterialRepairVersion")=="1.0.1" then print("[Stun Material Repair] Already applied.");return end
local replacement=target:Clone()
local ok,err=pcall(function()
 local appearance=assert(replacement:FindFirstChildOfClass("SurfaceAppearance"),"Missing SurfaceAppearance; import the updated StunProtectionVFX.rbxmx template first.")
 if appearance.ColorMap~="rbxassetid://128651191436151" then appearance.ColorMap="rbxassetid://128651191436151" end
 appearance.EmissiveMaskContent=Content.fromUri("rbxassetid://88194642418565")
 appearance.EmissiveTint=Color3.fromRGB(0,79,255)
 appearance.EmissiveStrength=6.28
 appearance.Color=Color3.new(1,1,1)
 appearance.AlphaMode=Enum.AlphaMode.Transparency
 replacement:SetAttribute("StunPortVersion","1.0.1")
 replacement:SetAttribute("StunMaterialRepairVersion","1.0.1")
 replacement:SetAttribute("EmissiveMaskAsset","rbxassetid://88194642418565")
end)
if not ok then replacement:Destroy();error("Material could not be prepared. Nothing changed: "..tostring(err))end
local backup=Instance.new("Folder")
backup.Name="StunProtectionMaterial_Backup_"..os.date("!%Y%m%d_%H%M%S")
backup.Parent=game.ServerStorage
local saved=target:Clone();saved.Name="StunProtectionVFX";saved.Parent=backup
ok,err=pcall(function()target.Parent=nil;replacement.Parent=parent end)
if not ok then replacement:Destroy();target.Parent=parent;backup:Destroy();error("Material repair rolled back: "..tostring(err))end
target:Destroy()
pcall(function()game:GetService("ChangeHistoryService"):SetWaypoint("Stun Protection Material")end)
print("[Stun Material Repair] Added UPD's emissive mask 88194642418565. Backup: "..backup:GetFullName()..". Save and start a fresh playtest. Stun gameplay is unchanged.")
