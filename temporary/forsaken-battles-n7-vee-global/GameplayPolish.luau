local RunService=game:GetService("RunService")
local Support={}
function Support.CloneLifetime(config,mode)
 return mode=="cursor"and(config.CursorCloneLifetime or config.CloneLifetime*.5)or config.CloneLifetime
end
function Support.PulseReward(hits)
 local tier=math.clamp(math.floor(hits or 0),0,3)
 return tier*2,tier*13
end
function Support.SurvivorXP(amount,isSurvivor)return amount*(isSurvivor and 2 or 1)end
function Support.Remaining(endsAt,now)return type(endsAt)=="number"and math.max(0,endsAt-now)or 0 end
function Support.RecoveryFraction(remaining)return math.clamp(remaining/3,0,1)end
function Support.TeleportReward(actor,oldPosition)
 local close=false
 local players=workspace:FindFirstChild("Players")
 local killers=players and players:FindFirstChild("Killers")
 if killers then
  for _,rig in killers:GetChildren()do
   local hum=rig:FindFirstChildOfClass("Humanoid")
   if hum and hum.Health>0 and rig.PrimaryPart and(rig.PrimaryPart.Position-oldPosition).Magnitude<=30 then close=true;break end
  end
 end
 require(game.ReplicatedStorage.Modules.Actors):IncrementActorStats(actor.Player,{Action=close and "Escaped from a Killer with c00lgui"or "Teleported with c00lgui",Money=3,EXP=30})
end
function Support.CloneTracker(actor,clone,duration)
 local rig=actor.Rig
 local deadline=workspace:GetServerTimeNow()+duration
 rig:SetAttribute("N7CloneEndsAt",deadline)
 local done=false
 local connections={}
 local function clear()
  if done then return end
  done=true
  for _,connection in connections do connection:Disconnect()end
  if rig.Parent and rig:GetAttribute("N7CloneEndsAt")==deadline then rig:SetAttribute("N7CloneEndsAt",nil)end
 end
 local hum=clone:FindFirstChildOfClass("Humanoid")
 if hum then table.insert(connections,hum.Died:Connect(clear))end
 table.insert(connections,clone.Destroying:Connect(clear))
 table.insert(connections,rig.Destroying:Connect(clear))
 task.delay(duration,clear)
end
function Support.AttachHUD(character,ui,center,scriptRoot,sprinting)
 local connections={}
 local owned={center}
 local stamina=ui.Bars.Stamina
 local drain=stamina:FindFirstChild("Drain")
 local centralTemplate=scriptRoot:FindFirstChild("Drain")
 local central=centralTemplate and centralTemplate:Clone()
 if central then central.Name="StaminaRecoveryDrain";central.ZIndex=10000;central.Parent=center.Parent;table.insert(owned,central)end
 local label=Instance.new("TextLabel")
 label.Name="StaminaRecoveryTime";label.BackgroundTransparency=1;label.TextColor3=Color3.fromRGB(255,210,120);label.TextStrokeTransparency=.3
 label.Font=Enum.Font.GothamMedium;label.TextSize=12;label.Size=UDim2.new(1,0,0,16);label.Position=UDim2.new(0,0,1,3);label.Parent=center;table.insert(owned,label)
 local cloneLabel=nil
 local alive=true
 local elapsed=0
 local function cleanup()
  if not alive then return end
  alive=false
  for _,connection in connections do connection:Disconnect()end
  for _,object in owned do object:Destroy()end
  if cloneLabel then cloneLabel:Destroy();cloneLabel=nil end
 end
 table.insert(connections,RunService.RenderStepped:Connect(function(dt)
  if not character.Parent or not ui.Parent then cleanup();return end
  elapsed+=dt;if elapsed<.05 then return end;elapsed=0
  local remaining=math.max(0,sprinting.timeUntilStaminaRecovers or 0)
  local visible=remaining>0 and ui.Visible and sprinting.Stamina<(sprinting.StaminaCap or sprinting.MaxStamina)
  if drain then
   drain.Visible=visible
   local fill=drain:FindFirstChild("Fill")
   if fill then fill.Size=UDim2.fromScale(Support.RecoveryFraction(remaining),1)end
  end
  label.Visible=visible and center.Visible
  label.Text=string.format("Regen %.1fs",remaining)
  if central then
   central.Visible=label.Visible
   central.AnchorPoint=center.AnchorPoint
   central.Position=center.Position+UDim2.fromOffset(0,center.AbsoluteSize.Y*.6)
   central.Size=UDim2.fromOffset(math.max(30,center.AbsoluteSize.X)*Support.RecoveryFraction(remaining),3)
  end
  local deadline=character:GetAttribute("N7CloneEndsAt")
  local left=Support.Remaining(deadline,workspace:GetServerTimeNow())
  local player=game.Players.LocalPlayer
  local temporary=player.PlayerGui:FindFirstChild("TemporaryUI")
  local abilities=temporary and temporary:FindFirstChild("AbilityContainer")
  local button=abilities and abilities:FindFirstChild("Clone")
  if left>0 and button then
   if not cloneLabel or cloneLabel.Parent~=button then
    if cloneLabel then cloneLabel:Destroy()end
    cloneLabel=Instance.new("TextLabel");cloneLabel.Name="CloneDurationTracker";cloneLabel.BackgroundColor3=Color3.new(0,0,0);cloneLabel.BackgroundTransparency=.25
    cloneLabel.TextColor3=Color3.new(1,1,1);cloneLabel.Font=Enum.Font.GothamBold;cloneLabel.TextSize=13
    cloneLabel.AnchorPoint=Vector2.new(.5,1);cloneLabel.Position=UDim2.fromScale(.5,-.05);cloneLabel.Size=UDim2.new(1,0,0,18);cloneLabel.Parent=button
   end
   cloneLabel.Visible=true;cloneLabel.Text=string.format("%.1fs",left)
  elseif cloneLabel then cloneLabel.Visible=false end
 end))
 table.insert(connections,character.Destroying:Connect(cleanup))
 table.insert(connections,ui.Destroying:Connect(cleanup))
 return cleanup
end
return Support
