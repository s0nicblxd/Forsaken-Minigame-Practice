-- Public image-based presentation only; gameplay never waits on an AnimationTrack.
local RunService=game:GetService("RunService")
local Players=game:GetService("Players")
local UserInputService=game:GetService("UserInputService")
local TweenService=game:GetService("TweenService")
local Debris=game:GetService("Debris")
local Modules=game.ReplicatedStorage.Modules
local Network=require(Modules.Network)
local Util=require(Modules.Util)
local Visuals=require(script.Parent.Visuals)
local Client={}
local function connect(a,signal,callback)
 table.insert(a.TTClientConnections,signal:Connect(callback))
end
local function owner(a) return a.Player==Players.LocalPlayer end
local function meterVisibility(a)
 local display=a.HealthbarDisplay
 if not display then return end
 local shown=a.TTClientPraying or os.clock()<(a.TTMeterUntil or 0)
 local mode=shown and (a.TTMeterFull and "full" or "partial") or "hidden"
 if a.TTMeterMode==mode then return end
 a.TTMeterMode=mode;a.TTMeterToken=(a.TTMeterToken or 0)+1
 local token=a.TTMeterToken
 if a.TTMeterTween then a.TTMeterTween:Cancel() end
 if shown then display.Visible=true end
 local info=TweenInfo.new(a.TTClientPraying and .05 or .65,Enum.EasingStyle.Quint,Enum.EasingDirection.Out)
 a.TTMeterTween=TweenService:Create(display,info,{
  Position=UDim2.fromScale(mode=="full" and 1 or shown and 1.025 or 1.175,.5),
  Size=UDim2.fromScale(1,shown and .532 or .4)
 })
 a.TTMeterTween:Play()
 if not shown then task.delay(.65,function()
  if a.TTMeterToken==token and a.HealthbarDisplay==display and not a.TTClientDestroyed then display.Visible=false end
 end) end
end
local function blood(a,value)
 local display=a.HealthbarDisplay
 if not display then return end
 local fraction=math.clamp(value/a.Config.BloodRequiredForRespawn,0,1)
 if value>0 or a.TTLastBlood and value~=a.TTLastBlood then a.TTMeterUntil=os.clock()+5 end
 a.TTLastBlood=value;a.TTMeterFull=fraction>=1
 display.Display.Visible=fraction<1
 display.Full.Visible=fraction>=1
 if a.TTBloodTween then a.TTBloodTween:Cancel() end
 a.TTBloodTween=TweenService:Create(display.Bar.Inner,TweenInfo.new(a.TTClientPraying and .05 or .25),{Size=UDim2.fromScale(1,fraction)})
 a.TTBloodTween:Play();meterVisibility(a)
end
local function warning(a,message)
 if message then Util:CreateWarning("TwoTimeWarning",message,a.Config.WarningTemplate) end
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
 if a.TTClientPraying then a.TTMeterUntil=os.clock()+5 end
 a.TTClientPraying=nil
 meterVisibility(a)
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
 local gui=Instance.new("BillboardGui");gui.Size=UDim2.fromOffset(120,120);gui.AlwaysOnTop=true;gui.Adornee=marker;gui.LightInfluence=0;gui.Parent=marker
 local image=Instance.new("ImageLabel");image.BackgroundTransparency=1;image.Size=UDim2.fromScale(1,1);image.Image=a.Config.PrayHighlightImage;image.ImageColor3=Color3.fromRGB(201,201,201);image.ImageTransparency=1;image.Parent=gui
 local rotation=Instance.new("NumberValue");rotation.Value=900;rotation.Parent=marker
 local render=RunService.RenderStepped:Connect(function(dt)
  if image.Parent then image.Rotation=((image.Rotation or 0)+rotation.Value*dt)%360 end
 end)
 marker.Destroying:Once(function()render:Disconnect()end)
 TweenService:Create(image,TweenInfo.new(.2),{ImageTransparency=0}):Play()
 TweenService:Create(rotation,TweenInfo.new(2,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{Value=45}):Play()
 task.delay(a.Config.PrayHighlightDuration-.35,function()
  if marker.Parent then TweenService:Create(image,TweenInfo.new(.35),{ImageTransparency=1}):Play();Debris:AddItem(marker,.35) end
 end)
 a.TTMarker=marker
end
function Client.Pray(a,result)
 if type(result)~="table" then return end
 warning(a,result.Warning)
 if result.Locate then locate(a,result.Locate);return end
 if not result.Started then return end
 a.TTClientPraying=true
 meterVisibility(a)
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
 local asset=Visuals.Build("LungeIndicator")
 local start=Instance.new("Attachment");start.Parent=workspace.Terrain
 local finish=Instance.new("Attachment");finish.Parent=workspace.Terrain
 local beam=asset.Beam;beam.Attachment0=start;beam.Attachment1=finish;beam.Enabled=false;beam.Parent=start
 a.TTIndicatorEmitters={}
 for _,emitter in asset.EndSymbol:GetChildren() do
  emitter.Enabled=false;emitter.Parent=finish;table.insert(a.TTIndicatorEmitters,emitter)
 end
 asset:Destroy()
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
 display.Visible=false;display.Position=UDim2.fromScale(1.175,.5);display.Size=UDim2.fromScale(1,.4)
 a.HealthbarDisplay=display;blood(a,rig:GetAttribute("TwoTimeOblation") or 0)
 sprite(a,display.Display,display.Display:FindFirstChild("Idle"))
 sprite(a,display.Full,display.Full:FindFirstChild("Full"))
 for _,name in {"Vines","Wings"} do
  local image=display.Full:FindFirstChild(name)
  if image then sprite(a,image,image:FindFirstChild("Sprite")) end
 end
 createIndicator(a)
 Network:SetConnection("TwoTimePortState","REMOTE_EVENT",function(kind,data)
  if kind=="Warning" then warning(a,data)
  elseif kind=="Blood" then blood(a,data)
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
  meterVisibility(a)
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
 end)
 connect(a,RunService.RenderStepped,function()
  if not rig.Parent or not rig.PrimaryPart then return end
  local crouched=rig:GetAttribute("Crouching")==true
  local indicator=a.TTIndicator
  if indicator then
   local usable=true
   if a.CanUseAbility then local ok,result=pcall(a.CanUseAbility,a,"Dagger");usable=ok and result==true end
   local visible=crouched and rig.Humanoid.Health>0 and usable
   indicator[3].Enabled=visible
   for _,emitter in a.TTIndicatorEmitters do
    if emitter.Enabled~=visible then emitter.Enabled=visible;if visible then emitter:Emit(1) else emitter:Clear() end end
   end
   if visible then
    local root=rig.PrimaryPart
    local forward=root.CFrame.LookVector*Vector3.new(1,0,1)
    if forward.Magnitude>.01 then
     forward=forward.Unit
     local height=rig.Humanoid.HipHeight+root.Size.Y/2
     local distance=(a.Config.DaggerLungeForce+a.Config.DaggerLungeForce/3)/2*a.Config.DaggerCrouchMoverEndlag
     local params=RaycastParams.new();params.FilterType=Enum.RaycastFilterType.Exclude;params.FilterDescendantsInstances={workspace:FindFirstChild("Players") or rig}
     local wall=workspace:Raycast(root.Position,forward*distance,params)
     if wall then distance=math.max((wall.Position-root.Position).Magnitude-1,0) end
     local endpoint=root.Position+forward*distance
     local ground=workspace:Raycast(endpoint,Vector3.new(0,-(height+6),0),params)
     indicator[1].WorldPosition=root.Position-Vector3.new(0,height-.1,0)
     indicator[2].WorldPosition=ground and ground.Position+Vector3.new(0,.1,0) or endpoint-Vector3.new(0,height-.1,0)
     indicator[3].Transparency=NumberSequence.new((math.sin(os.clock()*2)+1)*.15+.2,1)
    end
   end
  end
 end)
end
function Client.Destroyed(a)
 a.TTClientDestroyed=true
 a.TTMeterToken=(a.TTMeterToken or 0)+1
 if a.TTMeterTween then a.TTMeterTween:Cancel() end
 if a.TTBloodTween then a.TTBloodTween:Cancel() end
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
