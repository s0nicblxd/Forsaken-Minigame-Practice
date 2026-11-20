-- Public image-based presentation only; gameplay never waits on an AnimationTrack.
local RunService=game:GetService("RunService")
local Players=game:GetService("Players")
local UserInputService=game:GetService("UserInputService")
local TweenService=game:GetService("TweenService")
local Debris=game:GetService("Debris")
local Modules=game.ReplicatedStorage.Modules
local Network=require(Modules.Network)
local Util=require(Modules.Util)
local Client={}
local function connect(a,signal,callback)
 table.insert(a.TTClientConnections,signal:Connect(callback))
end
local function owner(a) return a.Player==Players.LocalPlayer end
local function blood(a,value)
 local display=a.HealthbarDisplay
 if not display then return end
 local fraction=math.clamp(value/a.Config.BloodRequiredForRespawn,0,1)
 display.Bar.Inner.Size=UDim2.fromScale(1,fraction)
 display.Display.Visible=fraction<1
 display.Full.Visible=fraction>=1
 display.Position=UDim2.fromScale(1,.5)
 display.Size=UDim2.fromScale(1,.532)
end
local function sprite(a,image,module)
 if not image or not module then return end
 local frames=require(module)
 task.spawn(function()
  while not a.TTClientDestroyed and image.Parent do
   if image.Visible then
    for _,frame in frames do
     if a.TTClientDestroyed or not image.Parent then return end
     image.ImageRectOffset=Vector2.new(frame[1],frame[2]);image.ImageRectSize=Vector2.new(frame[3],frame[4])
     task.wait(.03125)
    end
   else task.wait(.1) end
  end
 end)
end
local function stopPray(a,notify)
 a.TTClientPraying=nil
 if a.TTClientJump~=nil then
  a.Rig.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping,a.TTClientJump);a.TTClientJump=nil
 end
 if a.HeldAbilities then a.HeldAbilities.Pray=nil end
 Network:FireConnection("DisableSprinting","TwoTimePray",false)
 if notify then Network:FireServerConnection("TwoTimePortHold_"..a.Player.UserId,"REMOTE_EVENT",false) end
end
local function locate(a,position)
 if a.TTMarker then a.TTMarker:Destroy() end
 local marker=Instance.new("Part");marker.Name="TwoTimeRitualMarker";marker.Anchored=true;marker.CanCollide=false;marker.CanTouch=false;marker.CanQuery=false;marker.Transparency=1;marker.Position=position+Vector3.new(0,3,0);marker.Parent=workspace
 local gui=Instance.new("BillboardGui");gui.Size=UDim2.fromOffset(64,64);gui.AlwaysOnTop=true;gui.Parent=marker
 local image=Instance.new("ImageLabel");image.BackgroundTransparency=1;image.Size=UDim2.fromScale(1,1);image.Image=a.Config.PrayHighlightImage;image.Parent=gui
 a.TTMarker=marker;Debris:AddItem(marker,a.Config.PrayHighlightDuration)
end
function Client.Pray(a,result)
 if type(result)~="table" then return end
 if result.Locate then locate(a,result.Locate);return end
 if not result.Started then return end
 a.TTClientPraying=true
 a.TTClientJump=a.Rig.Humanoid:GetStateEnabled(Enum.HumanoidStateType.Jumping)
 a.Rig.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping,false)
 Network:FireConnection("DisableSprinting","TwoTimePray",true)
 if not (a.HeldAbilities and a.HeldAbilities.Pray) then stopPray(a,true) end
end
function Client.Dagger(a,result)
 if type(result)~="table" or result.Cancelled then return end
 a.TTClientAttackUntil=os.clock()+1
 Network:FireConnection("DisableSprinting","TwoTimeStab",true)
end
function Client.Ritual(a,result)
 if type(result)~="table" or not result.Started then return end
 a.TTClientRitualUntil=os.clock()+result.Duration
 Network:FireConnection("DisableSprinting","TwoTimeRitual",true)
end
local function createIndicator(a)
 local start=Instance.new("Attachment");start.Parent=workspace.Terrain
 local finish=Instance.new("Attachment");finish.Parent=workspace.Terrain
 local beam=Instance.new("Beam");beam.Attachment0=start;beam.Attachment1=finish;beam.Width0=.12;beam.Width1=.04;beam.FaceCamera=true;beam.Color=ColorSequence.new(Color3.fromRGB(160,160,170));beam.Transparency=NumberSequence.new(.35);beam.Enabled=false;beam.Parent=start
 a.TTIndicator={start,finish,beam}
end
function Client.Created(a)
 a.TTClientConnections={}
 local rig=a.Rig
 if not rig or not rig.PrimaryPart then return end
 if not owner(a) then
  local highlight=Instance.new("Highlight");highlight.Name="TwoTimeCrouchTeammateReveal";highlight.FillColor=Color3.fromRGB(130,131,137);highlight.OutlineColor=highlight.FillColor;highlight.FillTransparency=1;highlight.OutlineTransparency=1;highlight.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop;highlight.Parent=rig
  a.TTHighlight=highlight
  local previous=false
  connect(a,RunService.Heartbeat,function()
   local character=Players.LocalPlayer.Character
   local isSurvivor=character and character.Parent and character.Parent.Name=="Survivors"
   local visible=isSurvivor and character.PrimaryPart and rig.Parent and rig.PrimaryPart and rig:GetAttribute("Crouching")==true and (character.PrimaryPart.Position-rig.PrimaryPart.Position).Magnitude<=a.Config.CrouchTeammateRevealDistance
   visible=not not visible
   if visible~=previous then
    previous=visible
    if a.TTHighlightTween then a.TTHighlightTween:Cancel() end
    a.TTHighlightTween=TweenService:Create(highlight,TweenInfo.new(a.Config.CrouchTeammateRevealFadeTime),{FillTransparency=visible and .75 or 1,OutlineTransparency=visible and .4 or 1});a.TTHighlightTween:Play()
   end
  end)
  return
 end
 local Sprinting=require(game.ReplicatedStorage.Systems.Character.Game.Sprinting)
 a.TTOriginalSprintSpeed=Sprinting.SprintSpeed or a.Config.SprintSpeed
 local template=a.Config.HealthBar
 local display=template:Clone();display.Parent=a.Player.PlayerGui:WaitForChild("MainUI")
 a.HealthbarDisplay=display;blood(a,rig:GetAttribute("TwoTimeOblation") or 0)
 sprite(a,display.Display,display.Display:FindFirstChild("Idle"))
 sprite(a,display.Full,display.Full:FindFirstChild("Full"))
 for _,name in {"Vines","Wings"} do
  local image=display.Full:FindFirstChild(name)
  if image then sprite(a,image,image:FindFirstChild("Sprite")) end
 end
 createIndicator(a)
 Network:SetConnection("TwoTimePortState","REMOTE_EVENT",function(kind,data)
  if kind=="Blood" then blood(a,data)
  elseif kind=="Pray" and not data then stopPray(a,false)
  elseif kind=="Revive" then
   stopPray(a,true)
   if a.HealthbarDisplay then a.HealthbarDisplay:Destroy();a.HealthbarDisplay=nil end
   Sprinting.Stamina=math.clamp(Sprinting.Stamina+40,0,Sprinting.MaxStamina or 100)
  end
 end)
 connect(a,UserInputService.WindowFocusReleased,function() stopPray(a,true) end)
 connect(a,UserInputService.InputEnded,function(input)
  if a.TTClientPraying and input.UserInputType==Enum.UserInputType.MouseButton1 then stopPray(a,true) end
 end)
 local pulse=0;local lastCrouch=false
 connect(a,RunService.Heartbeat,function(dt)
  if not rig.Parent or not rig.PrimaryPart then return end
  local crouched=rig:GetAttribute("Crouching")==true
  if crouched~=lastCrouch then
   lastCrouch=crouched
   Sprinting.SprintSpeed=crouched and a.Config.CrouchRunSpeed or a.TTOriginalSprintSpeed
   if Sprinting.IsSprinting then Sprinting:Toggle(true) end
  end
  local folder=rig:FindFirstChild("SpeedMultipliers")
  if folder then
   local multiplier=folder:FindFirstChild("TwoTimeCrouching")
   if crouched then
    if not multiplier then multiplier=Util:CreateSpeedMultiplier(rig,1,"TwoTimeCrouching") end
    -- Sprinting uses SprintSpeed/BaseSpeed. Walking and running need different base ratios.
    multiplier.Value=Sprinting.IsSprinting and 1 or a.Config.CrouchSpeed/a.Config.Speed
    local bonus=folder:FindFirstChild("CrouchBonusTT") or Util:CreateSpeedMultiplier(rig,1,"CrouchBonusTT")
    bonus.Value=rig:GetAttribute("TwoTimeCrouchBonus") or 1
   else
    if multiplier then multiplier:Destroy() end
    local bonus=folder:FindFirstChild("CrouchBonusTT");if bonus then bonus:Destroy() end
   end
  end
  if a.TTClientAttackUntil and os.clock()>=a.TTClientAttackUntil then a.TTClientAttackUntil=nil;Network:FireConnection("DisableSprinting","TwoTimeStab",false) end
  if a.TTClientRitualUntil and os.clock()>=a.TTClientRitualUntil then a.TTClientRitualUntil=nil;Network:FireConnection("DisableSprinting","TwoTimeRitual",false) end
  if a.TTClientPraying then
   pulse+=dt
   if not (a.HeldAbilities and a.HeldAbilities.Pray) then stopPray(a,true)
   elseif pulse>=.2 then pulse=0;Network:FireServerConnection("TwoTimePortHold_"..a.Player.UserId,"REMOTE_EVENT",true) end
  end
  local indicator=a.TTIndicator
  if indicator then
   indicator[3].Enabled=crouched
   if crouched then
    local root=rig.PrimaryPart
    local origin=root.Position-Vector3.new(0,rig.Humanoid.HipHeight+root.Size.Y/2-.1,0)
    local distance=(a.Config.DaggerLungeForce+a.Config.DaggerLungeForce/3)/2*a.Config.DaggerCrouchMoverEndlag
    local params=RaycastParams.new();params.FilterType=Enum.RaycastFilterType.Exclude;params.FilterDescendantsInstances={rig}
    local hit=workspace:Raycast(origin,root.CFrame.LookVector*distance,params)
    indicator[1].WorldPosition=origin;indicator[2].WorldPosition=hit and hit.Position or origin+root.CFrame.LookVector*distance
   end
  end
 end)
end
function Client.Destroyed(a)
 a.TTClientDestroyed=true
 for _,connection in a.TTClientConnections or {} do connection:Disconnect() end
 if a.TTHighlight then a.TTHighlight:Destroy() end
 if a.TTHighlightTween then a.TTHighlightTween:Cancel() end
 if not owner(a) then return end
 stopPray(a,true)
 Network:RemoveConnection("TwoTimePortState","REMOTE_EVENT")
 for _,name in {"TwoTimeStab","TwoTimeRitual"} do Network:FireConnection("DisableSprinting",name,false) end
 if a.HealthbarDisplay then a.HealthbarDisplay:Destroy();a.HealthbarDisplay=nil end
 if a.TTMarker then a.TTMarker:Destroy() end
 if a.TTIndicator then for _,object in a.TTIndicator do object:Destroy() end end
 local Sprinting=require(game.ReplicatedStorage.Systems.Character.Game.Sprinting)
 if a.TTOriginalSprintSpeed then Sprinting.SprintSpeed=a.TTOriginalSprintSpeed end
 local folder=a.Rig and a.Rig:FindFirstChild("SpeedMultipliers")
 if folder then for _,name in {"TwoTimeCrouching","CrouchBonusTT"} do local v=folder:FindFirstChild(name);if v then v:Destroy() end end end
end
return Client
