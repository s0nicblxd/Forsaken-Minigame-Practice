-- UPD post-stun protection; count living rigs once even when registered under multiple keys.
local Rules={}
function Rules.CountSentinels(actors)
 local count,seen=0,{}
 for _,actor in pairs(actors) do
  local rig=actor.Rig
  local humanoid=rig and rig:FindFirstChildOfClass("Humanoid")
  if actor.Config and actor.Config.Class=="Sentinel" and rig and rig.Parent and rig.Parent.Name~="Spectating" and humanoid and humanoid.Health>0 and not seen[rig] then
   seen[rig]=true;count+=1
  end
 end
 return count
end
function Rules.Duration(count,resonance)
 return 6+3*math.max(0,count)+math.max(0,tonumber(resonance) or 0)/2
end
return Rules
