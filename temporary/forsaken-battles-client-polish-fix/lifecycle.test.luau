local function signal()
 local listeners={}
 local result={}
 function result:Connect(callback)
  local connection={active=true}
  function connection:Disconnect()self.active=false end
  table.insert(listeners,{connection,callback});return connection
 end
 function result:Count()local count=0;for _,entry in listeners do if entry[1].active then count+=1 end end;return count end
 return result
end
local isClient=false
local accesses={}
local services={RunService={IsClient=function()return isClient end}}
local game={GetService=function(_,name)table.insert(accesses,name);return assert(services[name],"Unexpected service access: "..name)end}
local workspace={}
local Client=(function()
local RunService=game:GetService("RunService")
local Client={}
local activeCleanup=nil
local starting=false
local function noop()end
function Client.Start()
 if not RunService:IsClient()then return noop end
 if activeCleanup then return activeCleanup end
 if starting then return noop end
 local Players=game:GetService("Players")
 local UIS=game:GetService("UserInputService")
 local GuiService=game:GetService("GuiService")
 local player=Players.LocalPlayer
 if not player then return noop end
 starting=true
 local playerGui=player:WaitForChild("PlayerGui")
 local connections={}
 local guarded=setmetatable({},{__mode="k"})
 local restoreCamera=nil
 local function release()
  if restoreCamera then restoreCamera();restoreCamera=nil end
 end
 local function guard(object)
  if object:IsA("ScrollingFrame")then object.Active=true;object.ScrollingEnabled=true end
  if not object:IsA("ViewportFrame")or guarded[object]then return end
  guarded[object]=true
  object.Active=true
  local connection=object.InputBegan:Connect(function(input)
   if input.UserInputType~=Enum.UserInputType.Touch and input.UserInputType~=Enum.UserInputType.MouseButton1 then return end
   release()
   local camera=workspace.CurrentCamera
   if not camera then return end
   local original=camera.CameraType
   camera.CameraType=Enum.CameraType.Scriptable
   local ending,destroying
   local done=false
   restoreCamera=function()
    if done then return end;done=true
    if ending then ending:Disconnect()end;if destroying then destroying:Disconnect()end
    if workspace.CurrentCamera==camera and camera.CameraType==Enum.CameraType.Scriptable then camera.CameraType=original end
   end
   ending=UIS.InputEnded:Connect(function(ended)
    if ended==input or ended.UserInputType==Enum.UserInputType.MouseButton1 then release()end
   end)
   destroying=object.Destroying:Connect(release)
  end)
  table.insert(connections,connection)
 end
 for _,object in playerGui:GetDescendants()do guard(object)end
 table.insert(connections,playerGui.DescendantAdded:Connect(guard))
 table.insert(connections,GuiService:GetPropertyChangedSignal("SelectedObject"):Connect(function()
  local selected=GuiService.SelectedObject
  if not selected or not selected:IsA("GuiObject")then return end
  local scrolling=selected:FindFirstAncestorWhichIsA("ScrollingFrame")
  if not scrolling then return end
  local offset=selected.AbsolutePosition.Y-scrolling.AbsolutePosition.Y
  local bottom=offset+selected.AbsoluteSize.Y
  local height=scrolling.AbsoluteWindowSize.Y
  local change=offset<0 and offset or(bottom>height and bottom-height or 0)
  if change~=0 then scrolling.CanvasPosition=Vector2.new(scrolling.CanvasPosition.X,math.clamp(scrolling.CanvasPosition.Y+change,0,math.max(0,scrolling.AbsoluteCanvasSize.Y-height)))end
 end))
 local menus={Shop=true,Inventory=true,Settings=true,Stats=true,UpdateLog=true,Rules=true,Achievements=true}
 local function inMenu(object)
  local menu=false
  while object and object~=playerGui do
   if object:IsA("GuiObject")and not object.Visible then return false end
   if object:IsA("ScreenGui")and not object.Enabled then return false end
   if menus[object.Name]then menu=true end
   object=object.Parent
  end
  return menu
 end
 pcall(function()GuiService.AutoSelectGuiEnabled=true;GuiService.GuiNavigationEnabled=true end)
 table.insert(connections,UIS.InputBegan:Connect(function(input,processed)
  if processed or UIS:GetFocusedTextBox()then return end
  local key=input.KeyCode
  if key~=Enum.KeyCode.DPadUp and key~=Enum.KeyCode.DPadDown and key~=Enum.KeyCode.DPadLeft and key~=Enum.KeyCode.DPadRight then return end
  if GuiService.SelectedObject and inMenu(GuiService.SelectedObject)then return end
  for _,object in playerGui:GetDescendants()do
   if object:IsA("GuiButton")and object.Active and object.Visible and inMenu(object)then
    object.Selectable=true;GuiService.SelectedObject=object;break
   end
  end
 end))
 table.insert(connections,UIS.WindowFocusReleased:Connect(release))
 table.insert(connections,player.CharacterRemoving:Connect(release))
 local alive=true
 activeCleanup=function()
  if not alive then return end
  alive=false
  activeCleanup=nil
  release()
  for _,connection in connections do connection:Disconnect()end
 end
 starting=false
 return activeCleanup
end
function Client.Destroy()
 if activeCleanup then activeCleanup()end
end
return Client

end)()
local cleanup=Client.Start(Client)
assert(type(cleanup)=="function"and #accesses==1,"server accessed player/client services")
cleanup();Client.Destroy()
local playerGui={DescendantAdded=signal(),GetDescendants=function()return {}end}
local selected=signal()
services.Players={LocalPlayer=nil}
services.UserInputService={InputBegan=signal(),WindowFocusReleased=signal()}
services.GuiService={GetPropertyChangedSignal=function()return selected end}
isClient=true
Client.Start();Client.Destroy()
local waits=0
local player={CharacterRemoving=signal()}
function player:WaitForChild(name)
 waits+=1;assert(name=="PlayerGui")
 local pending=Client.Start();assert(type(pending)=="function","concurrent startup did not short-circuit")
 return playerGui
end
services.Players.LocalPlayer=player
local function count()
 return playerGui.DescendantAdded:Count()+selected:Count()+services.UserInputService.InputBegan:Count()+services.UserInputService.WindowFocusReleased:Count()+player.CharacterRemoving:Count()
end
local first=Client.Start(Client)
assert(waits==1 and count()==5)
assert(Client.Start()==first and waits==1 and count()==5,"repeated lifecycle/notification startup duplicated listeners")
Client.Destroy();assert(count()==0)
Client.Destroy();first();assert(count()==0)
local second=Client.Start();assert(second~=first and count()==5 and waits==2)
first();assert(count()==5,"stale cleanup removed newer listeners")
second();assert(count()==0)
print("PASS actual ClientPolish: server/no LocalPlayer, absent client player, concurrent start, repeated start, cleanup, restart and stale cleanup")
