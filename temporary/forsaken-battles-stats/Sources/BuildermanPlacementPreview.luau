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
