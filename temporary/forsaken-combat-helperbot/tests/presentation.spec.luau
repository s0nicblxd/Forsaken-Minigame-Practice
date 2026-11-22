local Color3={new=function(...)return {...}end}
local Presentation=(function()
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

end)()
local hat={IsA=function(_,class)return class=="BasePart"end}
local head={}
local rig={charges=1,FindFirstChild=function(_,name)if name=="Hat"then return hat elseif name=="Head"then return head end end,GetAttribute=function(self)return self.charges end}
local template={Clone=function()return {CFrame="original antenna offset"}end}
local effect=Presentation.Attach(template,rig)
assert(effect.Parent==hat and effect.CFrame=="original antenna offset")
local origin={CFrame="custom skin antenna",Parent=hat,IsA=function(_,class)return class=="Attachment"end}
rig.FindFirstChild=function(_,name)if name=="HelperbotVFXOrigin"then return origin end end
effect=Presentation.Attach(template,rig);assert(effect.Parent==hat and effect.CFrame==origin.CFrame)
rig.FindFirstChild=function(_,name)if name=="Head"then return head end end
assert(Presentation.Attach(template,rig).Parent==head)
local icon
local label
local native={Visible=true,IsA=function(_,class)return class=="TextLabel"end}
function native:Clone()return {GetChildren=function()return {}end}end
local function newIcon()
 label=nil
 icon={Parent=true,ZIndex=2,FindFirstChild=function(_,name)if name=="Charges"then return native elseif name=="HelperbotPulseLevel"then return label end end}
end
newIcon()
local container={FindFirstChild=function(_,name)if name=="Pulse"then return icon end end}
local main={FindFirstChild=function()return container end}
local gui={FindFirstChild=function()return main end}
local actor={Player={FindFirstChildOfClass=function()return gui end},Rig=rig,State={},Behavior={Abilities={Pulse={}}}}
-- No UIElement is provided: resolve FCT's real hotbar, including late creation/replacement.
container.FindFirstChild=function()end
assert(Presentation.UpdateLevel(actor)==nil)
container.FindFirstChild=function()return icon end
label=Presentation.UpdateLevel(actor)
assert(label.Text=="Lv. 1" and label.Visible and actor.Behavior.Abilities.Pulse.UIElement==icon and not native.Visible)
rig.charges=0;Presentation.UpdateLevel(actor);assert(label.Text=="Lv. 0")
rig.charges=3;Presentation.UpdateLevel(actor);assert(label.Text=="Lv. 3")
local old=icon;newIcon();label=Presentation.UpdateLevel(actor)
assert(actor.Behavior.Abilities.Pulse.UIElement==icon and icon~=old and label.Text=="Lv. 3")
print("PASS presentation: hat antenna offset, custom origin, head fallback, delayed FCT hotbar without UIElement, levels 0/1/3, hotbar replacement")
