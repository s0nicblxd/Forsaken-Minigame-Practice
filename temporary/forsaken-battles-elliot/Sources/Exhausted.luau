local function apply(effect)
 local rig=effect.Character
 if rig and rig.Parent then rig:SetAttribute("ExhaustedLevel",math.clamp(effect.Level or 1,1,3))end
end
return {
 Data={Duration=4,MaxLevel=3,Stackable=false,Description="Decreases stamina regeneration and increases stamina drain by 5% per level."},
 Applied=apply,
 Removed=function(effect)
  if effect.Character then effect.Character:SetAttribute("ExhaustedLevel",nil)end
 end
}
