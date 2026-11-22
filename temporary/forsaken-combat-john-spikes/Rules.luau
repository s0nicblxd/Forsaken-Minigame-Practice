local Rules={}
function Rules.ReserveHit(cast,target,cap)
 if not cast.active then return false end
 local hits=cast.hits[target] or 0
 if hits>=cap then return false end
 cast.hits[target]=hits+1
 return true
end
function Rules.SpawnAt(index,interval) return 2+index*interval end
return Rules
