local now=0
local os={clock=function() return now end}
local pending={}
local task={delay=function(delay,fn)table.insert(pending,{at=now+delay,fn=fn})end}
local function advance(dt)
 local target=now+dt
 while true do
  table.sort(pending,function(a,b)return a.at<b.at end)
  if not pending[1] or pending[1].at>target then break end
  local item=table.remove(pending,1);now=item.at;item.fn()
 end
 now=target
end
local function signal()
 local callbacks={}
 return {Connect=function(_,fn)
  local connection={Connected=true,Disconnect=function(self)self.Connected=false end}
  table.insert(callbacks,{fn=fn,connection=connection});return connection
 end,Fire=function(_,...)for _,item in callbacks do if item.connection.Connected then item.fn(...) end end end}
end
local Vector3={}
local mt={}
function Vector3.new(x,y,z)return setmetatable({X=x,Y=y,Z=z},mt)end
mt.__add=function(a,b)return Vector3.new(a.X+b.X,a.Y+b.Y,a.Z+b.Z)end
mt.__sub=function(a,b)return Vector3.new(a.X-b.X,a.Y-b.Y,a.Z-b.Z)end
mt.__mul=function(a,b)if type(b)=='number' then return Vector3.new(a.X*b,a.Y*b,a.Z*b)end return Vector3.new(a.X*b.X,a.Y*b.Y,a.Z*b.Z)end
mt.__index=function(a,key)
 local mag=math.sqrt(a.X*a.X+a.Y*a.Y+a.Z*a.Z)
 if key=='Magnitude' then return mag end
 if key=='Unit' then return mag>0 and Vector3.new(a.X/mag,a.Y/mag,a.Z/mag) or Vector3.new(0,0,0) end
 if key=='Dot' then return function(_,b)return a.X*b.X+a.Y*b.Y+a.Z*b.Z end end
end
local CFrame={new=function(...)return {...}end}
local Vector2={new=function(...)return {...}end}
local UDim2={fromScale=function(...)return {...}end}
local Enum={NormalId={Top='Top'},EasingStyle={Linear='Linear'},EasingDirection={InOut='InOut'},HumanoidStateType={Jumping='Jumping'}}
local TweenInfo={new=function()return {}end}
local Debris={AddItem=function()end}
local TweenService={Create=function(_,object,_,values)return {Play=function()for k,v in values do object[k]=v end end,Cancel=function()end}end}
local heartbeat=signal()
local RunService={Heartbeat=heartbeat}
local Players={GetPlayerFromCharacter=function(_,rig)return rig.player end}
local Network={events={},callbacks={},FireClientConnection=function(self,player,name,_,kind,data)table.insert(self.events,{kind=kind,data=data})end,
 SetConnection=function(self,name,_,callback)self.callbacks[name]=callback end,RemoveConnection=function(self,name)self.callbacks[name]=nil end}
local actors={CurrentActors={}}
local Modules={Actors='Actors'}
local require=function(name)assert(name=='Actors');return actors end
local workspace={FindFirstChild=function()return nil end}
local game={ReplicatedStorage={Modules=Modules}}
local function object()
 return {Parent=true,Destroy=function(self)self.Parent=nil end}
end
local Instance={new=function()return object()end}
local function rig(position,look)
 local attrs={};local speeds={}
 local h={Health=80,MaxHealth=80,HipHeight=2,HealthChanged=signal(),GetStateEnabled=function()return true end,SetStateEnabled=function()end}
 local root={Size=Vector3.new(2,2,2),Position=position or Vector3.new(0,0,0),CFrame={LookVector=look or Vector3.new(0,0,-1)},Anchored=false,AssemblyLinearVelocity=Vector3.new(0,0,0)}
 setmetatable(root.CFrame,{__mul=function()return {}end})
 local model={Parent={Name='Killers'},PrimaryPart=root,Humanoid=h,attrs=attrs,speeds=speeds}
 model.Parent=setmetatable(model.Parent,{__tostring=function()return 'Killers'end})
 function model:GetAttribute(key)return attrs[key]end
 function model:SetAttribute(key,value)attrs[key]=value end
 function model:FindFirstChildOfClass(key)if key=='Humanoid' then return h end end
 function model:FindFirstChild(key)
  if key=='Humanoid' then return h end
  if key=='SpeedMultipliers' then return {FindFirstChild=function(_,name)return speeds[name] and speeds[name].Parent and speeds[name] or nil end}end
 end
 function model:HasTag(key)return attrs[key]end
 return model
end
local Statuses={applied={},removed={}}
function Statuses:ApplyStatus(target,name,data)table.insert(self.applied,{target=target,name=name,data=data})end
function Statuses:RemoveStatus(target,name)table.insert(self.removed,name)end
function Statuses:PlayerHasStatus()return nil end
function Statuses:RemoveStatuses()end
local Util={}
function Util:CreateSpeedMultiplier(rig,value,key)
 local item=object();item.Value=value;rig.speeds[key]=item;return item
end
function Util:ApplyVelocity(root,value)local v=object();v.LineVelocity=value;return v end
function Util:ApplyDamage(victim,damage)victim.Humanoid.Health-=damage end
function Util:GiveInvincible(rig,_,duration)rig.invincibility=duration end
function Util:GetDistanceFromGround()return 3 end
local Visuals={Build=function()return {GetChildren=function()return {}end,Destroy=function()end}end}
local Hitboxes={}
function Hitboxes:CreateHitbox(_,settings)
 self.last=settings;self.count=(self.count or 0)+1
 local hitbox={Cancel=function(self)self.cancelled=true end};self.state=hitbox;return hitbox
end
-- Pure kit math, shared by server, indicator, and regression tests.

local UDim2={fromScale=function(x,y)return {X=x,Y=y}end,fromOffset=function(x,y)return {X=x,Y=y}end}
local Vector2={new=function(x,y)return {X=x,Y=y}end}
local Color3={fromRGB=function(...)return {...}end}
local ColorSequence={new=function(x)return x end}
local NumberSequence={new=function(x)return x end}
Enum.RaycastFilterType={Exclude='Exclude'}
local RaycastParams={new=function()return {}end}
Enum.EasingStyle={Quint='Quint'};Enum.EasingDirection={Out='Out'}
Enum.UserInputType={MouseButton1='MouseButton1'}
Enum.HighlightDepthMode={AlwaysOnTop='AlwaysOnTop'}
local function node()
 local n=object();n.Visible=true;n.Destroying={Once=function()end}
 function n:FindFirstChild(name)return self[name]end
 return n
end
local Instance={new=function()return node()end}
RunService.RenderStepped=signal()
local UserInputService={WindowFocusReleased=signal(),InputEnded=signal()}
local sprint={SprintSpeed=26,Stamina=20,MaxStamina=100,Toggle=function(self)self.toggled=true end}
local require=function(module)if module=='Sprint' then return sprint else return {}end end
local Visuals={Build=function()
 local folder=node();folder.Beam=node();folder.Beam.Width0=1;folder.Beam.Width1=1
 folder.EndSymbol={GetChildren=function()return {}end}
 return folder
end}
function Util:CreateWarning(_,text)self.lastWarning=text end
local function ui()
 local n=node();n.Bar={Inner={}};n.Display=node();n.Display.Idle={}
 n.Full=node();n.Full.Full={};n.Full.Vines=node();n.Full.Vines.Sprite={};n.Full.Wings=node();n.Full.Wings.Sprite={}
 return n
end
local localPlayer={UserId=12,Name='Tester',PlayerGui={WaitForChild=function()return {}end}}
Players.LocalPlayer=localPlayer
local rig=rig()
function rig.Humanoid:GetAttribute(key)if key=="BaseSpeed" then return 12 end end
rig.PrimaryPart.Size=Vector3.new(2,2,1)
localPlayer.Character=rig
workspace.Terrain={}
function workspace:Raycast(origin,direction)
 if direction.Y<0 then return {Position=Vector3.new(origin.X,0,origin.Z)} end
end
local game={ReplicatedStorage={Systems={Character={Game={Sprinting='Sprint'}}}}}
function Network:FireConnection(name,key,value)self.locks=self.locks or {};self.locks[key]=value end
function Network:FireServerConnection(name,_,value)self.lastHold=value end
local scheduledTask=task
local task={spawn=function()end,delay=scheduledTask.delay}
local a={Player=localPlayer,Rig=rig,HeldAbilities={},Config={HealthBar={Clone=ui},BloodRequiredForRespawn=8,Speed=12,SprintSpeed=26,CrouchSpeed=10,CrouchRunSpeed=23,CrouchTeammateRevealDistance=100,CrouchTeammateRevealFadeTime=1.25,DaggerLungeForce=110,DaggerCrouchMoverEndlag=.4,PrayHighlightImage='rbxassetid://100508591140926',PrayHighlightDuration=4}}
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
   a.TTLocalCrouchStart=crouched and os.clock() or nil
  end
  local folder=rig:FindFirstChild("SpeedMultipliers")
  if folder then
   local multiplier=folder:FindFirstChild("TwoTimeCrouching")
   if crouched then
    if not multiplier then multiplier=Util:CreateSpeedMultiplier(rig,1,"TwoTimeCrouching") end
    -- Sprinting uses SprintSpeed/BaseSpeed. Walking and running need different base ratios.
    local running=Sprinting.IsSprinting and Sprinting.CanSprint~=false and (Sprinting.Stamina or 0)>0
    local sprintValue=folder:FindFirstChild("Sprinting")
    local base=rig.Humanoid:GetAttribute("BaseSpeed") or a.Config.Speed
    local target=running and a.Config.CrouchRunSpeed or a.Config.CrouchSpeed
    local elapsed=os.clock()-(a.TTLocalCrouchStart or os.clock())
    local startup=elapsed<.75 and .15+.85*(1-elapsed/.75)^5 or elapsed<1.75 and .15+.85*(elapsed-.75)^2 or 1
    multiplier.Value=target/math.max(.01,base*(sprintValue and sprintValue.Value or 1))*startup
    local bonus=folder:FindFirstChild("CrouchBonusTT") or Util:CreateSpeedMultiplier(rig,1,"CrouchBonusTT")
    bonus.Value=running and (rig:GetAttribute("TwoTimeCrouchBonus") or 1) or 1
    a.TTSprintPulse=(a.TTSprintPulse or .2)+dt
    if a.TTSprintPulse>=.2 then a.TTSprintPulse=0;Network:FireServerConnection("TwoTimePortHold_"..a.Player.UserId,"REMOTE_EVENT",running,"Sprint") end
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


Client.Created(a)
assert(a.HealthbarDisplay and #a.TTClientConnections>0)
assert(a.HealthbarDisplay.Visible==false,"meter must start hidden")
assert(a.TTIndicator[3].Width0==1 and a.TTIndicator[3].Width1==1)
Network.callbacks.TwoTimePortState('Blood',8);assert(a.HealthbarDisplay.Full.Visible)
Network.callbacks.TwoTimePortState('Blood',4);assert(not a.HealthbarDisplay.Full.Visible and a.HealthbarDisplay.Display.Visible)
assert(a.HealthbarDisplay.Bar.Inner.Size.Y==.5,'full meter must support decreasing during Pray')
advance(6);heartbeat:Fire(.1);advance(.7)
assert(not a.HealthbarDisplay.Visible,"meter must hide after inactivity, including a full meter")
-- Release happened before the server reply: no sticky hold.
a.HeldAbilities.Pray=nil
Client.Pray(a,{Started=true});assert(not a.TTClientPraying and Network.lastHold==false)
-- Focus loss releases server lease and local sprint lock.
a.HeldAbilities.Pray=true;Client.Pray(a,{Started=true})
assert(a.TTClientPraying and Network.locks.TwoTimePray)
assert(a.HealthbarDisplay.Visible,"Pray must reveal the meter")
UserInputService.WindowFocusReleased:Fire()
assert(not a.TTClientPraying and not Network.locks.TwoTimePray)
-- Mouse released outside hotbar is still handled by the global input listener.
a.HeldAbilities.Pray=true;Client.Pray(a,{Started=true})
UserInputService.InputEnded:Fire({UserInputType='MouseButton1'})
assert(not a.TTClientPraying and Network.lastHold==false)
-- Held flag disappearing restores controls on the next frame.
a.HeldAbilities.Pray=true;Client.Pray(a,{Started=true})
a.HeldAbilities.Pray=nil;heartbeat:Fire(.1)
assert(not a.TTClientPraying)
Network.callbacks.TwoTimePortState("Warning","You need Oblation to pray.");assert(Util.lastWarning=="You need Oblation to pray.")
Client.Pray(a,{Locate=Vector3.new(1,2,3),Warning="Return to your Ritual to pray."});assert(a.TTMarker)
Client.Dagger(a,{Duration=1});assert(Network.locks.TwoTimeStab)
Client.Ritual(a,{Started=true,Duration=3.5});assert(Network.locks.TwoTimeRitual)
now+=4;heartbeat:Fire(.1)
assert(not Network.locks.TwoTimeStab and not Network.locks.TwoTimeRitual)
Network.callbacks.TwoTimePortState('Revive',true)
assert(a.HealthbarDisplay==nil and sprint.Stamina==60)
-- Verify crouch math against the live sprint multiplier, including an in-flight sprint tween.
rig.attrs.Crouching=true;sprint.IsSprinting=false;heartbeat:Fire(.016)
advance(2);heartbeat:Fire(.016)
local function actualSpeed()
 local result=12
 for _,value in rig.speeds do if value.Parent then result*=value.Value end end
 return result
end
assert(math.abs(actualSpeed()-10)<.001)
rig.speeds.Sprinting={Parent=true,Value=26/12};sprint.IsSprinting=true;heartbeat:Fire(.016)
assert(math.abs(actualSpeed()-23)<.001)
rig.speeds.Sprinting.Value=1.5;heartbeat:Fire(.016)
assert(math.abs(actualSpeed()-23)<.001,'old sprint tween must not overwrite crouch speed')
rig.attrs.TwoTimeCrouchBonus=1.5;heartbeat:Fire(.016)
assert(math.abs(actualSpeed()-34.5)<.001)
sprint.IsSprinting=false;rig.speeds.Sprinting.Value=1;heartbeat:Fire(.016)
assert(math.abs(actualSpeed()-10)<.001,'walking must not inherit a stale sprint buildup')
rig.attrs.Crouching=nil;heartbeat:Fire(.016)
assert(math.abs(actualSpeed()-12)<.001)
-- Indicator only displays when crouched and Dagger is actually usable.
rig.attrs.Crouching=true;a.CanUseAbility=function()return false end
RunService.RenderStepped:Fire(.016);assert(not a.TTIndicator[3].Enabled)
a.CanUseAbility=function()return true end
RunService.RenderStepped:Fire(.016);assert(a.TTIndicator[3].Enabled)
assert(a.TTIndicator[2].WorldPosition.Y==.1,'endpoint should lie on the ground')
rig.attrs.Crouching=nil
RunService.RenderStepped:Fire(.016);assert(not a.TTIndicator[3].Enabled)
Client.Destroyed(a)
assert(Network.callbacks.TwoTimePortState==nil)
assert(sprint.SprintSpeed==26 and not Network.locks.TwoTimePray)
print('Two Time client meter spending, late release, focus loss, mouse release and recovery passed')
