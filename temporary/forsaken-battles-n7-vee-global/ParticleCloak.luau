local Cloak={}
function Cloak.Start(effect)
 if effect.ParticleCloak then return end
 local rig=effect.Character
 if not rig then return end
 local records={}
 local connections={}
 local active=true
 local function hide(object)
  if not object:IsA("ParticleEmitter")or records[object]then return end
  local record={Enabled=object.Enabled,Transparency=object.Transparency}
  records[object]=record
  local writing=false
  local function enforce()
   if not active or writing or not object.Parent then return end
   writing=true;object.Enabled=false;object.Transparency=NumberSequence.new(1);writing=false
  end
  table.insert(connections,object:GetPropertyChangedSignal("Enabled"):Connect(function()
   if not writing then record.Enabled=object.Enabled;enforce()end
  end))
  table.insert(connections,object:GetPropertyChangedSignal("Transparency"):Connect(function()
   if not writing then record.Transparency=object.Transparency;enforce()end
  end))
  enforce()
  object:Clear()
 end
 for _,object in rig:GetDescendants()do hide(object)end
 table.insert(connections,rig.DescendantAdded:Connect(hide))
 local function stop()
  if not active then return end
  active=false
  for _,connection in connections do connection:Disconnect()end
  for object,record in records do
   if object.Parent then object.Enabled=record.Enabled;object.Transparency=record.Transparency end
  end
  effect.ParticleCloak=nil
 end
 table.insert(connections,rig.Destroying:Connect(stop))
 effect.ParticleCloak=stop
end
function Cloak.Stop(effect)if effect.ParticleCloak then effect.ParticleCloak()end end
return Cloak
