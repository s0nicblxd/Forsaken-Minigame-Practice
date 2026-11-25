local folder={Name="Players"}
local owner={Name="Builderman"}
local survivor={Name="Survivor outside Players"}
local killer={Name="Killer outside Players"}
local character={Name="New character not yet in Actors"}
local building={Name="Carried building"}
local Actors={CurrentActors={{Rig=owner},{Rig=survivor},{Rig=killer},{Rig=survivor}}}
local game={GetService=function()return {GetPlayers=function()return {{Character=character},{Character=owner}}end}end}
local vector={}
local vm={__index=vector}
local function v(x,y,z)return setmetatable({X=x,Y=y,Z=z},vm)end
function vm.__add(a,b)return v(a.X+b.X,a.Y+b.Y,a.Z+b.Z)end
function vm.__sub(a,b)return v(a.X-b.X,a.Y-b.Y,a.Z-b.Z)end
local frame={};local fm={__index=frame}
local function cf(pos)return setmetatable({Position=pos},fm)end
function fm.__index(a,key)if key=="Rotation"then return cf(v(0,0,0))end;return frame[key]end
function fm.__mul(a,b)return cf(a.Position+b.Position)end
local CFrame={new=function(x,y,z)return cf(v(x or 0,y or 0,z or 0))end}
local Vector3={new=v}
owner.PrimaryPart={CFrame=cf(v(0,3,0)),Position=v(0,3,0)}
local a={Rig=owner,Config={SentryPositionOffset=4}}
local Enum={RaycastFilterType={Exclude=1}}
local RaycastParams={new=function()return {}end}
local OverlapParams={new=function()return {}end}
local floor={Name="Ground"}
local wall={Name="Wall",Transparency=0}
local obstructed=false
local buildings={}
local casts=0
local workspace={FindFirstChild=function(_,name)assert(name=="Players");return folder end}
local expected
function workspace:Raycast(origin,direction,params)
 assert(params.FilterDescendantsInstances==expected,"rays do not use captured exclusion list")
 casts+=1
 if direction.Y<0 then return {Position=v(0,0,-4),Normal=v(0,1,0),Instance=floor}end
 return nil
end
function workspace:GetPartBoundsInBox(frame,size,params)
 assert(params.FilterDescendantsInstances==expected,"obstacle overlap uses a different filter")
 return obstructed and {wall}or {}
end
local function placementExclusions(a,ignore)
 local excluded,seen={},{}
 local function add(object)
  if object and not seen[object]then seen[object]=true;table.insert(excluded,object)end
 end
 add(workspace:FindFirstChild("Players"));add(a.Rig);add(ignore)
 for _,actor in Actors.CurrentActors do add(actor.Rig)end
 for _,player in game:GetService("Players"):GetPlayers()do add(player.Character)end
 return excluded
end
local function placement(a,kind,ignore,frame)
 local root=a.Rig.PrimaryPart
 local facing=frame or root.CFrame
 local target=facing*CFrame.new(0,0,-a.Config[kind.."PositionOffset"])
 local params=RaycastParams.new();params.FilterType=Enum.RaycastFilterType.Exclude;params.RespectCanCollide=true
 local excluded=placementExclusions(a,ignore)
 params.FilterDescendantsInstances=excluded
 local floor=workspace:Raycast(target.Position+Vector3.new(0,1,0),Vector3.new(0,-6,0),params)
 if not floor or floor.Normal.Y<.65 then return nil,"midair"end
 if floor.Instance.Name=="Conveyor"then return nil,"collision"end
 if workspace:Raycast(facing.Position,target.Position-facing.Position,params)then return nil,"facingWall"end
 for _,state in buildings do
  if state.model~=ignore and state.phase~="destroyed"and state.phase~="carry"and state.model.Parent then
   local radius=a.Config[state.kind.."PlacementRadius"]/2
   if(target.Position-state.model.PrimaryPart.Position).Magnitude<=radius then return nil,"tooClose"end
  end
 end
 local overlap=OverlapParams.new();overlap.FilterType=Enum.RaycastFilterType.Exclude;overlap.RespectCanCollide=true
 overlap.FilterDescendantsInstances=excluded
 for _,part in workspace:GetPartBoundsInBox(CFrame.new(target.Position.X,floor.Position.Y+1.75,target.Position.Z),Vector3.new(2.5,2.5,2.5),overlap)do
  if part~=floor.Instance and(part.Transparency<.9 or part.Name=="UnplacableArea")then return nil,"collision"end
 end
 return CFrame.new(target.Position.X,floor.Position.Y,target.Position.Z)*target.Rotation
end


local children={}
workspace.Map={Ingame={GetChildren=function()return children end}}
local ground=true;local wallHit=false;local queryList
function workspace:Raycast(origin,direction,params)
 queryList=params.FilterDescendantsInstances
 for _,object in {folder,owner,survivor,killer,character,building}do assert(table.find(queryList,object))end
 if direction.Y<0 then return ground and {Position=v(0,0,-4),Normal=v(0,1,0),Instance=floor}or nil end
 return wallHit and {Instance=wall}or nil
end
function workspace:GetPartBoundsInBox(frame,size,params)
 assert(params.FilterDescendantsInstances==queryList)
 return obstructed and {wall}or {}
end
local Players={GetPlayers=function()return {{Character=character}}end}
local game={GetService=function()return Players end,ReplicatedStorage={Modules={Actors=Actors}}}
local function require(value)return value end
local Preview=(function()
local Players=game:GetService("Players")
local Actors=require(game.ReplicatedStorage.Modules.Actors)
local Preview={}
function Preview.Check(actor,kind,frame)
 local ignore=actor.Buildings and actor.Buildings[kind]
 local excluded,seen={},{}
 local function add(object)if object and not seen[object]then seen[object]=true;table.insert(excluded,object)end end
 add(workspace:FindFirstChild("Players"));add(actor.Rig);add(ignore)
 for _,other in Actors.CurrentActors do add(other.Rig)end
 for _,player in Players:GetPlayers()do add(player.Character)end
 local target=frame*CFrame.new(0,0,-actor.Config[kind.."PositionOffset"])
 local params=RaycastParams.new();params.FilterType=Enum.RaycastFilterType.Exclude;params.RespectCanCollide=true;params.FilterDescendantsInstances=excluded
 local floor=workspace:Raycast(target.Position+Vector3.new(0,1,0),Vector3.new(0,-6,0),params)
 if not floor or floor.Normal.Y<.65 then return "midair"end
 if floor.Instance.Name=="Conveyor"then return "collision"end
 if workspace:Raycast(frame.Position,target.Position-frame.Position,params)then return "facingWall"end
 for _,building in workspace.Map.Ingame:GetChildren()do
  if building~=ignore and not building:GetAttribute("Destroyed")and not building:GetAttribute("Carrying")and building.PrimaryPart then
   local otherKind=building.Name=="BuildermanSentry"and "Sentry"or building.Name=="BuildermanDispenser"and "Dispenser"
   if otherKind and(target.Position-building.PrimaryPart.Position).Magnitude<=actor.Config[otherKind.."PlacementRadius"]/2 then return "tooClose"end
  end
 end
 local overlap=OverlapParams.new();overlap.FilterType=Enum.RaycastFilterType.Exclude;overlap.RespectCanCollide=true;overlap.FilterDescendantsInstances=excluded
 for _,part in workspace:GetPartBoundsInBox(CFrame.new(target.Position.X,floor.Position.Y+1.75,target.Position.Z),Vector3.new(2.5,2.5,2.5),overlap)do
  if part~=floor.Instance and(part.Transparency<.9 or part.Name=="UnplacableArea")then return "collision"end
 end
 return nil
end
return Preview

end)()
a.Buildings={Sentry=building};a.Config.SentryPlacementRadius=125
assert(Preview.Check(a,"Sentry",owner.PrimaryPart.CFrame)==nil)
obstructed=true;assert(Preview.Check(a,"Sentry",owner.PrimaryPart.CFrame)=="collision")
obstructed=false;ground=false;assert(Preview.Check(a,"Sentry",owner.PrimaryPart.CFrame)=="midair")
ground=true;wallHit=true;assert(Preview.Check(a,"Sentry",owner.PrimaryPart.CFrame)=="facingWall")
print("PASS actual local placement prediction: shared character exclusions, valid ground, obstruction, midair and wall warnings")
