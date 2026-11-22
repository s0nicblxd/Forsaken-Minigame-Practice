
local V={};V.__index=V
function V.__add(a,b)return setmetatable({X=a.X+b.X,Y=a.Y+b.Y,Z=a.Z+b.Z},V)end
function V.__sub(a,b)return setmetatable({X=a.X-b.X,Y=a.Y-b.Y,Z=a.Z-b.Z},V)end
local Vector3={new=function(x,y,z)return setmetatable({X=x,Y=y,Z=z},V)end}
local CFrame={new=function(x,y,z)return {X=x,Y=y,Z=z}end}
local RaycastParams={new=function()return {}end}
local Enum={RaycastFilterType={Exclude=true}}
local hit
local workspace={FindFirstChild=function()return {}end,Raycast=function()return hit end}
local Alignment=(function()
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

end)()
local function rig(scale,updated)
 local leg={Size=Vector3.new(scale,2*scale,scale)}
 local root={Size=Vector3.new(2*scale,2*scale,scale),Position=Vector3.new(0,3*scale,0)}
 return {PrimaryPart=root,GetAttribute=function()return updated and "1.0.0"or nil end,FindFirstChildOfClass=function()return {HipHeight=0}end,FindFirstChild=function(_,name)if name=="Left Leg"then return leg end end,Clone=function()return "cloned rig"end}
end
for _,scale in ipairs({1,1.25,1.6})do
 local a={Rig=rig(scale,true)}
 assert(math.abs(Alignment.GroundHeight(a.Rig)-3*scale)<.00001)
 local offset=Alignment.SlashOffset(a)
 assert(math.abs(a.Rig.PrimaryPart.Position.Y+offset.Y-3)<.00001 and offset.Z==-1.75)
 assert(math.abs(Alignment.GroundPoint(a.Rig).Y)<.00001,"R6 ground fallback should land at foot level")
 hit={Position=Vector3.new(0,2,0)}
 assert(math.abs(Alignment.TrailPoint(a,false).Y-2.03)<.00001)
 hit=nil
end
local skin={Rig=rig(1.4,false)}
assert(Alignment.SlashOffset(skin).Y==0)
assert(math.abs(Alignment.TrailPoint(skin,true).Y-(4.2-4.5))<.00001)
local actor={Rig=rig(1.25,true),Config={JohnDoeRigCollision="new collider",JohnDoeRigQuery="new query"}}
assert(Alignment.GetRig(actor)=="cloned rig" and actor.Config.CollisionHitbox=="new collider")
actor={Rig=rig(1,false),SkinFolder=true,Config={CollisionHitbox="skin collider"}}
Alignment.GetRig(actor);assert(actor.Config.CollisionHitbox=="skin collider"and actor.Config.QueryHitbox==nil)
print("PASS alignment: scale-aware R6 clearance, grounded Slash center, unchanged reach, raycast/fallback trail, default collider selection, existing skin preservation")
