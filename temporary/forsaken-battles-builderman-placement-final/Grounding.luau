local RunService=game:GetService("RunService")
local Grounding={}
Grounding.__index=Grounding
local function snap(building,frame)
 local root=building.PrimaryPart
 if not root then return end
 local hum=building:FindFirstChildOfClass("Humanoid")
 local animator=hum and hum:FindFirstChildOfClass("Animator")
 if animator then for _,track in animator:GetPlayingAnimationTracks()do track:Stop(0)end end
 for _,joint in building:GetDescendants()do if joint:IsA("Motor6D")then joint.Transform=CFrame.new()end end
 local parts,frames={root},{frame}
 for _,part in building:GetDescendants()do
  if part:IsA("BasePart")and part~=root then
   local relative=part:GetAttribute("BuilderRestLocalCF")
   if typeof(relative)=="CFrame"then table.insert(parts,part);table.insert(frames,frame*relative)end
  end
 end
 workspace:BulkMoveTo(parts,frames,Enum.BulkMoveMode.FireCFrameChanged)
end
function Grounding.new()
 return setmetatable({connections={}},Grounding)
end
function Grounding:Place(building,frame,untilTime)
 if typeof(building)~="Instance"or not building:IsA("Model")or typeof(frame)~="CFrame"or type(untilTime)~="number"then return end
 if self.connections[building]then self.connections[building]:Disconnect()end
 snap(building,frame)
 self.connections[building]=RunService.RenderStepped:Connect(function()
  if not building.Parent or building:GetAttribute("Destroyed")or workspace:GetServerTimeNow()>=untilTime then
   local connection=self.connections[building];self.connections[building]=nil
   if connection then connection:Disconnect()end
   return
  end
  snap(building,frame)
 end)
end
function Grounding:Destroy()
 for _,connection in self.connections do connection:Disconnect()end
 self.connections={}
end
return Grounding
