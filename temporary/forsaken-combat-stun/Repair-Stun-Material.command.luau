-- Material-only correction: compile colour + emission maps through Roblox's supported API.
assert(game:GetService("RunService"):IsStudio() and not game:GetService("RunService"):IsRunning(),"Stop Play before repairing the material.")
local parent=game.ReplicatedStorage.Assets.Instances
local target=assert(parent:FindFirstChild("StunProtectionVFX"),"Install the stun-protection port first.")
assert(target:IsA("MeshPart") and target.MeshId:match("%d+")=="76640378318129","Unexpected stun-protection mesh. Nothing changed.")
if target:GetAttribute("StunMaterialRepairVersion")=="1.0.4" then print("[Stun Material Repair] Already applied.");return end
local replacement=target:Clone()
local ok,err=pcall(function()
 local failed,probes={},{}
 for _,id in {"rbxassetid://83958058671232","rbxassetid://106819888283523"} do
  local image=Instance.new("ImageLabel");image.Image=id;table.insert(probes,image)
 end
 local loaded,loadError=pcall(function()
  game:GetService("ContentProvider"):PreloadAsync(probes,function(id,status)
   if status~=Enum.AssetFetchStatus.Success then table.insert(failed,tostring(id).." ("..tostring(status)..")") end
  end)
 end)
 for _,image in probes do image:Destroy() end
 assert(loaded,"Image-instance preload failed: "..tostring(loadError))
 assert(#failed==0,"Image instances could not load the required textures: "..table.concat(failed,", ")..". Check the image IDs and experience asset permissions.")
 local appearance=game:GetService("AssetService"):CreateSurfaceAppearanceAsync({
  ColorMap=Content.fromUri("rbxassetid://83958058671232"),
  EmissiveMask=Content.fromUri("rbxassetid://106819888283523")
 })
 assert(appearance and appearance:IsA("SurfaceAppearance"),"Roblox did not return a compiled SurfaceAppearance.")
 appearance.Name="SurfaceAppearance"
 appearance.EmissiveTint=Color3.fromRGB(0,79,255)
 appearance.EmissiveStrength=6.28
 appearance.Color=Color3.new(1,1,1)
 appearance.AlphaMode=Enum.AlphaMode.Transparency
 for _,old in replacement:GetChildren() do if old:IsA("SurfaceAppearance") then old:Destroy() end end
 appearance.Parent=replacement
 replacement:SetAttribute("PackedMaterialImported",false)
 replacement:SetAttribute("MaterialCompiledFromMaps",true)
 replacement:SetAttribute("StunPortVersion","1.0.4")
 replacement:SetAttribute("StunMaterialRepairVersion","1.0.4")
 replacement:SetAttribute("EmissiveMaskAsset","rbxassetid://106819888283523")
end)
if not ok then replacement:Destroy();error("Material could not be prepared. Nothing changed. Roblox material creation error: "..tostring(err))end
local backup=Instance.new("Folder")
backup.Name="StunProtectionMaterial_Backup_"..os.date("!%Y%m%d_%H%M%S")
backup.Parent=game.ServerStorage
local saved=target:Clone();saved.Name="StunProtectionVFX";saved.Parent=backup
ok,err=pcall(function()target.Parent=nil;replacement.Parent=parent end)
if not ok then replacement:Destroy();target.Parent=parent;backup:Destroy();error("Material repair rolled back: "..tostring(err))end
target:Destroy()
pcall(function()game:GetService("ChangeHistoryService"):SetWaypoint("Stun Protection Material")end)
print("[Stun Material Repair] Rebuilt the rendered material with UPD's emissive mask 106819888283523. Backup: "..backup:GetFullName()..". Save and start a fresh playtest. Stun gameplay is unchanged.")
