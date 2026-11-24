local Players=game:GetService("Players")
local CarryVisuals={}
function CarryVisuals.Update(building,viewer)
 viewer=viewer or Players.LocalPlayer
 local character=viewer and viewer.Character
 local survivor=character and character.Parent==workspace.Players.Survivors
 local carrying=building:GetAttribute("Carrying")and not building:GetAttribute("Destroyed")
 local outline=building:FindFirstChild("BuildermanCarryOutline")
 local aura=building:FindFirstChild("PlayerAura")
 if not survivor or not carrying then
  if outline then outline:Destroy()end
  if aura then
   local before=aura:GetAttribute("BuilderCarryWasEnabled")
   if before~=nil then aura.Enabled=before;aura:SetAttribute("BuilderCarryWasEnabled",nil)end
  end
  return
 end
 if aura then
  if aura:GetAttribute("BuilderCarryWasEnabled")==nil then aura:SetAttribute("BuilderCarryWasEnabled",aura.Enabled)end
  aura.Enabled=false
 end
 if not outline then
  outline=Instance.new("Highlight");outline.Name="BuildermanCarryOutline";outline.Adornee=building
  outline.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop;outline.FillTransparency=1;outline.OutlineTransparency=0
  outline.OutlineColor=Color3.fromRGB(255,220,50);outline.Parent=building
 end
 outline.Enabled=true
end
return CarryVisuals
