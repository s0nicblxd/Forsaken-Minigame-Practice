local Repair={}
local function asset(id)
 if type(id)=="number"then return "rbxassetid://"..tostring(id)end
 if type(id)=="string"and id~=""then
  if id:match("^%d+$")then return "rbxassetid://"..id end
  return id
 end
end
function Repair.Attach(actor)
 if actor.ChanceExpressionCleanup then actor.ChanceExpressionCleanup()end
 local rig=actor.Rig
 local head=rig and rig:FindFirstChild("Head")
 local hum=rig and rig:FindFirstChildOfClass("Humanoid")
 local function expressions()
  local config=actor.Config or {}
  return(actor.RigName and config["Expressions"..actor.RigName])or config.Expressions
 end
 local values=expressions()
 if not head or not hum or type(values)~="table"or not asset(values.Default)then
  warn("[Chance expressions] Cannot attach: missing Head, Humanoid, or Config.Expressions.Default")
  return
 end
 local holder=rig:FindFirstChild("ExpressionHolder",true)
 if holder and not holder:IsA("BasePart")then warn("[Chance expressions] ExpressionHolder must be a BasePart");return end
 if not holder then
  local instances=game.ReplicatedStorage.Assets:FindFirstChild("Instances")
  local template=instances and instances:FindFirstChild("ExpressionHolder")
  if template and template:IsA("BasePart")then holder=template:Clone()
  else
   holder=Instance.new("Part");holder.Size=head.Size;holder.Transparency=1
  end
  holder.Name="ExpressionHolder"
  holder.Anchored=false;holder.CanCollide=false;holder.CanTouch=false;holder.CanQuery=false;holder.Massless=true
  holder.CFrame=head.CFrame*CFrame.new(0,0,-.005)
  local weld=Instance.new("WeldConstraint");weld.Part0=head;weld.Part1=holder;weld.Parent=holder
  holder.Parent=rig
 end
 for _,joint in rig:GetDescendants()do
  if joint:IsA("WeldConstraint")and(joint.Part0==holder or joint.Part1==holder)then joint:Destroy()end
 end
 holder.Anchored=false;holder.CanCollide=false;holder.CanTouch=false;holder.CanQuery=false;holder.Massless=true
 holder.CFrame=head.CFrame*CFrame.new(0,0,-.005)
 local binding=Instance.new("WeldConstraint");binding.Name="ChanceExpressionHeadWeld";binding.Part0=head;binding.Part1=holder;binding.Parent=holder
 local decal=holder:FindFirstChildOfClass("Decal")or Instance.new("Decal")
 decal.Name="Expression";decal.Transparency=0;decal.Face=Enum.NormalId.Front;decal.Color3=Color3.new(1,1,1);decal.Parent=holder
 local hidden={}
 for _,child in head:GetChildren()do
  if child:IsA("Decal")and child.Face==Enum.NormalId.Front then hidden[child]=child.Transparency;child.Transparency=1 end
 end
 local previous=actor.ChangeExpression
 local serial=0
 local active=true
 local timer=nil
 local function cancelTimer()
  if timer then pcall(task.cancel,timer);timer=nil end
 end
 local function draw(name,duration)
  if not active or not rig.Parent then return end
  local config=expressions()
  if type(config)~="table"then return end
  if hum.Health<=0 then name="Dead"end
  if name=="Default"then name=hum.Health<=hum.MaxHealth/2 and config.Injured and "Injured"or "Default"end
  local texture=asset(config[name])or(name=="Dead"and asset(config.Default))
  if not texture then return end
  serial+=1;cancelTimer()
  decal.Texture=texture
  if actor.Behavior and type(actor.Behavior.onExpressionChanged)=="function"then
   pcall(actor.Behavior.onExpressionChanged,actor.Behavior,actor,name,duration)
  end
  if type(duration)=="number"and duration>0 and hum.Health>0 then
   local current=serial
   timer=task.delay(duration,function()
    timer=nil
    if active and current==serial then actor:ChangeExpression("Default")end
   end)
  end
 end
 local function change(_,name,duration)draw(name,duration)end
 actor.ChangeExpression=change
 local health=hum.Health
 local connection=hum.HealthChanged:Connect(function(value)
  if value<=0 then draw("Dead")
  elseif value<health then draw("Hurt",.75)
  elseif value>health+20 then draw("Happy",.75)
  else draw("Default")end
  health=value
 end)
 local destroying
 local cleanup
 cleanup=function()
  if not active then return end
  active=false;serial+=1;cancelTimer();connection:Disconnect()
  if destroying then destroying:Disconnect()end
  if actor.ChangeExpression==change then actor.ChangeExpression=previous end
  for face,transparency in hidden do if face.Parent then face.Transparency=transparency end end
  actor.ChanceExpressionCleanup=nil
 end
 destroying=rig.Destroying:Connect(cleanup)
 actor.ChanceExpressionCleanup=cleanup
 draw("Default")
end
return Repair
