local Client={}
function Client.Start()
 local Players=game:GetService("Players")
 local UIS=game:GetService("UserInputService")
 local GuiService=game:GetService("GuiService")
 local player=Players.LocalPlayer
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
 return function()
  release()
  for _,connection in connections do connection:Disconnect()end
 end
end
return Client
