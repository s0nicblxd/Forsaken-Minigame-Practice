-- UPD emitter offsets belong to the robot's hat, not the HumanoidRootPart.
local Presentation={}
function Presentation.Attach(template,rig)
 local effect=template:Clone()
 local origin=rig:FindFirstChild("HelperbotVFXOrigin",true)
 if origin and origin:IsA("Attachment") and origin.Parent:IsA("BasePart") then
  effect.CFrame=origin.CFrame;effect.Parent=origin.Parent
 else
  local hat=rig:FindFirstChild("Hat",true)
  local head=rig:FindFirstChild("Head")
  -- Preserve the original attachment CFrame (including the 1.25-stud antenna offset).
  effect.Parent=hat and hat:IsA("BasePart") and hat or head or rig.PrimaryPart
 end
 return effect
end
function Presentation.UpdateLevel(actor)
 local gui=actor.Player and actor.Player:FindFirstChildOfClass("PlayerGui")
 local main=gui and gui:FindFirstChild("MainUI")
 local container=main and main:FindFirstChild("AbilityContainer")
 local ability=actor.Behavior and actor.Behavior.Abilities and actor.Behavior.Abilities.Pulse
 local icon=container and container:FindFirstChild("Pulse") or ability and ability.UIElement
 if not icon or not icon.Parent then return end
 if ability then ability.UIElement=icon end
 local label=icon:FindFirstChild("HelperbotPulseLevel")
 if not label then
  local native=icon:FindFirstChild("Charges")
  if native and native:IsA("TextLabel") then
   label=native:Clone()
   for _,child in ipairs(label:GetChildren()) do if child:IsA("GuiObject") then child:Destroy() end end
   -- This label replaces the native charge count; Pulse levels are not expendable ability uses.
   native.Visible=false
  else
   label=Instance.new("TextLabel")
   label.BackgroundTransparency=1;label.AnchorPoint=Vector2.new(.5,1)
   label.Position=UDim2.fromScale(.5,0);label.Size=UDim2.new(1,0,.3,0)
   label.Font=Enum.Font.SourceSansBold;label.TextScaled=true;label.TextStrokeTransparency=0
  end
  label.Name="HelperbotPulseLevel";label.Parent=icon
 end
 local level=math.clamp(actor.Rig:GetAttribute("PulseCharges") or actor.State and actor.State.ChargeLevel or 1,0,3)
 label.Text="Lv. "..level;label.TextColor3=Color3.new(1,1,1)
 label.TextTransparency=0;label.Visible=true;label.ZIndex=icon.ZIndex+2
 return label
end
return Presentation
