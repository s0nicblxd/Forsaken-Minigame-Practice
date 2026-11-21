local now=0;local timers={}
local function signal()
 local listeners={};local signal={}
 function signal:Connect(callback)local c={Connected=true,Disconnect=function(self)self.Connected=false end};listeners[c]=callback;return c end
 function signal:Fire(...)local copy=table.clone(listeners);for c,fn in copy do if c.Connected then fn(...)end end end
 return signal
end
local task={delay=function(delay,fn)table.insert(timers,{at=now+delay,fn=fn})end}
local function advance(dt)
 local finish=now+dt
 while true do table.sort(timers,function(a,b)return a.at<b.at end);if not timers[1] or timers[1].at>finish then break end;local item=table.remove(timers,1);now=item.at;item.fn()end
 now=finish
end
local time=function()return now end
local mt={};local Vector3={}
function Vector3.new(x,y,z)return setmetatable({X=x,Y=y,Z=z},mt)end
mt.__add=function(a,b)return Vector3.new(a.X+b.X,a.Y+b.Y,a.Z+b.Z)end
mt.__sub=function(a,b)return Vector3.new(a.X-b.X,a.Y-b.Y,a.Z-b.Z)end
mt.__mul=function(a,n)return Vector3.new(a.X*n,a.Y*n,a.Z*n)end
mt.__index=function(a,key)local m=math.sqrt(a.X*a.X+a.Y*a.Y+a.Z*a.Z);if key=='Magnitude' then return m elseif key=='Unit' then return Vector3.new(a.X/m,a.Y/m,a.Z/m)end end
local cf={__mul=function(a)return a end}
local CFrame={lookAt=function(pos,look)return setmetatable({Position=pos,Look=look},cf)end,Angles=function()return {}end}
local TweenInfo={new=function(...)return {...}end}
local Enum={EasingStyle={Quad='Quad',Quint='Quint'},EasingDirection={Out='Out'}}
local methods={};local instanceMT={}
instanceMT.__index=function(self,key)if key=='Parent' then return self._parent end;return methods[key] or self._childrenByName[key]end
instanceMT.__newindex=function(self,key,value)
 if key=='Parent' then
  local old=self._parent
  if old then old._children[self]=nil;old._childrenByName[self.Name]=nil;old.ChildRemoved:Fire(self)end
  self._parent=value
  if value then value._children[self]=true;value._childrenByName[self.Name]=self;value.ChildAdded:Fire(self)end
  self.AncestryChanged:Fire(self,value)
 else rawset(self,key,value)end
end
local Instance={}
function Instance.new(class)
 return setmetatable({_class=class,_children={},_childrenByName={},_attrs={},_signals={},_parent=false,Name=class,ChildAdded=signal(),ChildRemoved=signal(),AncestryChanged=signal(),Died=signal(),Size=Vector3.new(3.204,3.204,.605),Position=Vector3.new(0,0,0)},instanceMT)
end
function methods:IsA(class)return self._class==class end
function methods:FindFirstChild(name)return self._childrenByName[name]end
function methods:WaitForChild(name)return assert(self:FindFirstChild(name),name)end
function methods:FindFirstChildOfClass(class)for node in self._children do if node:IsA(class)then return node end end end
function methods:GetChildren()local result={};for node in self._children do table.insert(result,node)end;return result end
function methods:IsDescendantOf(root)local node=self;while node do if node==root then return true end;node=node.Parent end;return false end
function methods:GetAttribute(key)return self._attrs[key]end
function methods:GetAttributeChangedSignal(key)self._signals[key]=self._signals[key] or signal();return self._signals[key]end
function methods:SetAttribute(key,value)local old=self._attrs[key];self._attrs[key]=value;if old~=value then self:GetAttributeChangedSignal(key):Fire()end end
function methods:Clone()
 local copy=Instance.new(self._class);copy.Name=self.Name;copy.Size=self.Size;copy.Transparency=self.Transparency
 for _,child in self:GetChildren()do local clone=child:Clone();clone.Parent=copy end
 return copy
end
local sounds={}
function methods:Play()table.insert(sounds,self)end
function methods:Destroy()if self.destroyed then return end;self.destroyed=true;for _,child in self:GetChildren()do child:Destroy()end;self.Parent=nil end
local workspace=Instance.new('Workspace')
local map=Instance.new('Folder');map.Name='Map';map.Parent=workspace
local ingame=Instance.new('Folder');ingame.Name='Ingame';ingame.Parent=map
local teams=Instance.new('Folder');teams.Name='Players';teams.Parent=workspace
local killers=Instance.new('Folder');killers.Name='Killers';killers.Parent=teams
local survivors=Instance.new('Folder');survivors.Name='Survivors';survivors.Parent=teams
local assets=Instance.new('Folder');local template=Instance.new('MeshPart');template.Name='StunProtectionVFX';template.Parent=assets
local run={RenderStepped=signal()}
local tween={Create=function(_,object,info,values)return {Play=function()for k,v in values do object[k]=v end end}end}
local debris={AddItem=function(_,object,delay)task.delay(delay,function()object:Destroy()end)end}
local game={ReplicatedStorage={Assets={Instances=assets}}}
function game:GetService(name)if name=='RunService' then return run elseif name=='TweenService' then return tween elseif name=='Debris' then return debris end end
local Indicator=(function()
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

end)()
local function rig(name,ready)
 local model=Instance.new('Model');model.Name=name
 if ready then local root=Instance.new('Part');root.Parent=model;model.PrimaryPart=root;local h=Instance.new('Humanoid');h.Health=100;h.Parent=model end
 return model
end
local function meshes(folder)local result={};for _,node in folder:GetChildren()do if node.Name~='Visuals' then table.insert(result,node)end end;return result end

local model=rig('Tester',true);model.Parent=killers
local stop=Indicator.Attach(model)
assert(#ingame:GetChildren()==0)
model:SetAttribute('StunnedDisabled',true);advance(0)
local holder=assert(ingame:FindFirstChild('TesterStunProtectionVFX'))
assert(#meshes(holder)==1)
advance(.35);assert(#meshes(holder)==2)
advance(.35);assert(#meshes(holder)==3)
run.RenderStepped:Fire()
for _,part in meshes(holder)do
 local point=part.CFrame.Position;assert(math.abs(math.sqrt(point.X^2+point.Z^2)-4)<.0001);assert(math.abs(point.Y-1.15)<.0001)
 assert(not part.CanCollide and not part.CanQuery and not part.CanTouch)
end
local starts,loops=0,0
for _,sound in sounds do if sound.SoundId=='rbxassetid://107766213132983' then starts+=1 elseif sound.SoundId=='rbxassetid://112344506440657' then loops+=1;assert(sound.Looped and sound.Volume==.3)end end
assert(starts==3 and loops==1)
model:SetAttribute('StunnedImmunityHidden',false);advance(.25);assert(not holder.Parent,'any set hide attribute suppresses the indicator')
model:SetAttribute('StunnedImmunityHidden',nil);advance(0);assert(ingame:FindFirstChild('TesterStunProtectionVFX'))
-- Clearing protection during staggered creation must prevent late symbols from spawning.
model:SetAttribute('StunnedDisabled',nil);advance(1);assert(#ingame:GetChildren()==0)
model:SetAttribute('StunnedDisabled',true);advance(0)
model.Humanoid.Health=0;model.Humanoid.Died:Fire();advance(1)
assert(#ingame:GetChildren()==0)
stop();model.Parent=nil
-- The manager sees late-spawned NPCs without an ActorCreated network message.
Indicator.Start();Indicator.Start()
local bot=rig('TrainingBot',false);bot.Parent=killers;bot:SetAttribute('StunnedDisabled',true)
local root=Instance.new('Part');root.Parent=bot;bot.PrimaryPart=root
local humanoid=Instance.new('Humanoid');humanoid.Health=100;humanoid.Parent=bot
advance(.11);assert(ingame:FindFirstChild('TrainingBotStunProtectionVFX'))
advance(.8);assert(#meshes(ingame:FindFirstChild('TrainingBotStunProtectionVFX'))==3,'manager must not duplicate visuals')
bot.Parent=nil;advance(1);assert(#ingame:GetChildren()==0)
print('Indicator orbit, stagger, uploaded audio, hide flag, stale spawns, death/removal and late NPCs passed')
