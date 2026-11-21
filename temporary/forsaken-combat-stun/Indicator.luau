-- UPD orbit/appearance timings; works for player actors and registered training bots.
local RunService=game:GetService("RunService")
local TweenService=game:GetService("TweenService")
local Debris=game:GetService("Debris")
local Indicator={}
local sounds={Start="rbxassetid://107766213132983",Loop="rbxassetid://112344506440657",End="rbxassetid://117830806605625"}
local function play(root,id,volume,looped)
 local sound=Instance.new("Sound");sound.SoundId=id;sound.Volume=volume;sound.RollOffMinDistance=10;sound.RollOffMaxDistance=80;sound.Looped=looped or false;sound.Parent=root;sound:Play()
 if not looped then Debris:AddItem(sound,15) end
 return sound
end
function Indicator.Attach(rig)
 if not rig or not rig.PrimaryPart then return function()end end
 local root=rig.PrimaryPart
 local humanoid=rig:FindFirstChildOfClass("Humanoid")
 local template=game.ReplicatedStorage.Assets.Instances:FindFirstChild("StunProtectionVFX")
 if not template then return function()end end
 local connections={};local holder,loop,render
 local generation=0;local destroyed=false
 local function cleanup(withSound)
  generation+=1
  if loop then loop:Destroy();loop=nil end
  if render then render:Disconnect();render=nil end
  local old=holder;holder=nil
  if old then
   if withSound and root.Parent then play(root,sounds.End,.4) end
   for _,part in old:GetChildren() do TweenService:Create(part,TweenInfo.new(.25,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Transparency=1}):Play() end
   Debris:AddItem(old,.25)
  end
 end
 local function destroy()
  if destroyed then return end
  destroyed=true
  for _,connection in connections do connection:Disconnect() end
  cleanup(false)
 end
 local function update()
  local enabled=not destroyed and rig.Parent and root.Parent and humanoid and humanoid.Health>0 and rig:GetAttribute("StunnedDisabled") and rig:GetAttribute("StunnedImmunityHidden")==nil
  if not enabled then cleanup(true);return end
  if holder then return end
  generation+=1;local token=generation
  holder=Instance.new("Folder");holder.Name=rig.Name.."StunProtectionVFX"
  holder.Parent=workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Ingame") or workspace
  local folder=holder;local parts,echoes={},{}
  loop=play(root,sounds.Loop,.3,true)
  local function position(index)
   local center=root.Position+Vector3.new(0,1.15,0)
   local angle=time()*.25*math.pi*2+(index-1)*math.pi*2/3
   local point=center+Vector3.new(math.cos(angle)*4,0,math.sin(angle)*4)
   return CFrame.lookAt(point,point+(point-center).Unit)*CFrame.Angles(0,0,time()*.1*math.pi*2)
  end
  for i=1,3 do task.delay((i-1)*.35,function()
   if destroyed or token~=generation or holder~=folder or not folder.Parent or not root.Parent then return end
   play(root,sounds.Start,.45)
   local part=template:Clone();part.Anchored=true;part.CanCollide=false;part.CanQuery=false;part.CanTouch=false;part.CFrame=position(i);part.Parent=folder;parts[i]=part
   local echo=part:Clone();echo.Name="Visuals";echo.Parent=folder;echoes[i]=echo
   TweenService:Create(echo,TweenInfo.new(.75,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{Transparency=1,Size=echo.Size*1.5}):Play();Debris:AddItem(echo,.75)
  end)end
  render=RunService.RenderStepped:Connect(function()
   if destroyed or not rig.Parent or not root.Parent or humanoid.Health<=0 then cleanup(false);return end
   for i,part in parts do if part.Parent then part.CFrame=position(i) end end
   for i,part in echoes do if part.Parent then part.CFrame=position(i) end end
  end)
 end
 table.insert(connections,rig:GetAttributeChangedSignal("StunnedDisabled"):Connect(update))
 table.insert(connections,rig:GetAttributeChangedSignal("StunnedImmunityHidden"):Connect(update))
 table.insert(connections,rig.AncestryChanged:Connect(function()if not rig:IsDescendantOf(workspace)then destroy()end end))
 if humanoid then table.insert(connections,humanoid.Died:Connect(destroy)) end
 update()
 return destroy
end
local started=false
function Indicator.Start()
 if started then return end
 started=true
 local teams=workspace:WaitForChild("Players")
 local active,pending,watched={},{},{}
 local function remove(rig)
  pending[rig]=nil
  if active[rig] then active[rig]();active[rig]=nil end
 end
 local function add(rig)
  if not rig:IsA("Model") or active[rig] or pending[rig] then return end
  local token={};pending[rig]=token
  local attempts=0
  local function ready()
   if pending[rig]~=token then return end
   if not rig.Parent or rig.Parent.Parent~=teams then remove(rig);return end
   if rig.PrimaryPart and rig:FindFirstChildOfClass("Humanoid") then
    pending[rig]=nil;active[rig]=Indicator.Attach(rig);return
   end
   attempts+=1
   if attempts<100 then task.delay(.1,ready) else pending[rig]=nil end
  end
  ready()
 end
 local function team(folder)
  if watched[folder] or (folder.Name~="Killers" and folder.Name~="Survivors") then return end
  watched[folder]=true
  folder.ChildAdded:Connect(add);folder.ChildRemoved:Connect(remove)
  for _,rig in folder:GetChildren() do add(rig) end
 end
 teams.ChildAdded:Connect(team)
 for _,folder in teams:GetChildren() do team(folder) end
end
return Indicator
