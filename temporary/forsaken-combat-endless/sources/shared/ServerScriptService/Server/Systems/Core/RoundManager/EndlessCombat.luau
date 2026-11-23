local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Endless={}
function Endless.Enabled()
 return script:GetAttribute("Enabled")~=false
end
function Endless.Step(manager,delta)
 local timer=ReplicatedStorage:FindFirstChild("RoundTimer")
 if not Endless.Enabled()then
  if timer and timer:GetAttribute("EndlessCombat")then timer:SetAttribute("EndlessCombat",nil)end
  return false
 end
 manager.EndlessCombatElapsed=(manager.EndlessCombatElapsed or 0)+math.max(0,delta)
 local session=manager.CurrentSession
 if session and not manager.RoundInitiating and not manager.RoundEnding then
  session.ActualTimePast=(session.ActualTimePast or 0)+math.max(0,delta)
 end
 if timer then
  timer:SetAttribute("EndlessCombat",true)
  local mapRotation=script.Parent.Parent:FindFirstChild("MapRotation")
  if not mapRotation then
   timer.Value="Battle Till' Death!"
   timer:SetAttribute("TimeLeft",5999)
  end
 end
 return true
end
return Endless
