-- Phase-one geometry only. No attack reach, cooldown, damage or status balance changes.
local Alignment={}
function Alignment.IsUpdated(rig) return rig:GetAttribute("JohnDoeRigPhase")=="1.0.0" end
function Alignment.GroundHeight(rig)
 local hum=rig:FindFirstChildOfClass("Humanoid")
 local root=rig.PrimaryPart
 local leg=rig:FindFirstChild("Left Leg") or rig:FindFirstChild("Right Leg")
 return (hum and hum.HipHeight or 0)+(root and root.Size.Y/2 or 1)+(leg and leg.Size.Y or 2)
end
function Alignment.GroundPoint(rig)
 local root=rig.PrimaryPart
 local params=RaycastParams.new()
 params.FilterType=Enum.RaycastFilterType.Exclude
 params.FilterDescendantsInstances={workspace:FindFirstChild("Players") or rig,rig}
 params.RespectCanCollide=true
 local hit=workspace:Raycast(root.Position,Vector3.new(0,-Alignment.GroundHeight(rig)-8,0),params)
 return hit and hit.Position+Vector3.new(0,.03,0) or root.Position-Vector3.new(0,Alignment.GroundHeight(rig),0)
end
function Alignment.TrailPoint(actor,initial)
 if Alignment.IsUpdated(actor.Rig) then return Alignment.GroundPoint(actor.Rig) end
 return actor.Rig.PrimaryPart.Position-Vector3.new(0,initial and 4.5 or 3,0)
end
function Alignment.SlashOffset(actor)
 local y=Alignment.IsUpdated(actor.Rig) and 3-Alignment.GroundHeight(actor.Rig) or 0
 return CFrame.new(0,y,-1.75)
end
function Alignment.GetRig(actor)
 if not actor.SkinFolder then
  actor.Config.CollisionHitbox=actor.Config.JohnDoeRigCollision
  actor.Config.QueryHitbox=actor.Config.JohnDoeRigQuery
 end
 return actor.Rig:Clone()
end
return Alignment
