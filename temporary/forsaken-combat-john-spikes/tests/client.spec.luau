
local function signal()
 local s={callbacks={}}
 function s:Connect(fn)local c={active=true};function c:Disconnect()self.active=false end;table.insert(s.callbacks,{fn=fn,c=c});return c end
 function s:Fire()for _,x in ipairs(s.callbacks)do if x.c.active then x.fn()end end end
 return s
end
local render=signal()
local changed={}
local rig={attrs={JDCanRetract=false}}
function rig:GetAttribute(k)return self.attrs[k]end
function rig:GetAttributeChangedSignal(k)changed[k]=changed[k]or signal();return changed[k]end
local button={Clipping={Top={}},AbilityName={},CooldownTime={Text="18"}}
function button:FindFirstChild(name)return self[name]end
local hotbar={FindFirstChild=function(_,name)if name=="CorruptEnergy"then return button end end}
local main={FindFirstChild=function()return hotbar end}
local gui={FindFirstChild=function()return main end}
local player={FindFirstChildOfClass=function()return gui end}
local game={ReplicatedStorage={Modules={Util={}}}}
function game:GetService(name)if name=="RunService"then return {RenderStepped=render} elseif name=="Players"then return {LocalPlayer=player}end end
local UDim2={fromScale=function(x,y)return {x=x,y=y}end}
local require=function(m)return m end
local Client=(function()
local RunService=game:GetService("RunService")
local Players=game:GetService("Players")
local Util=require(game.ReplicatedStorage.Modules.Util)
local Client={}
function Client.CanRetract(a) return a.Rig and a.Rig:GetAttribute("JDCanRetract")==true end
local function update(a)
 local ability=a.Behavior.Abilities.CorruptEnergy
 local retract=Client.CanRetract(a)
 ability.Name=retract and "Retract" or "Corrupt Energy"
 ability.Icon=retract and "rbxassetid://105853980040304" or "rbxassetid://83849304758564"
 -- FCT keeps counting the original cooldown; only its rendering is suppressed while Retract is available.
 ability.Disabled=retract or a.JDCEOriginalDisabled
 local main=a.Player:FindFirstChildOfClass("PlayerGui")
 main=main and main:FindFirstChild("MainUI")
 local hotbar=main and main:FindFirstChild("AbilityContainer")
 local button=hotbar and hotbar:FindFirstChild("CorruptEnergy")
 if retract and button then
  button.Image=ability.Icon
  if button:FindFirstChild("AbilityName") then button.AbilityName.Text=ability.Name end
  if button:FindFirstChild("CooldownTime") then button.CooldownTime.Text="" end
  if button:FindFirstChild("Clipping") then
   button.Clipping.Size=UDim2.fromScale(1,1)
   button.Clipping.Top.Size=UDim2.fromScale(1,1);button.Clipping.Top.Image=ability.Icon
  end
 end
end
local function windup(a)
 local state=a.JDCEClientWindup
 if not state then return end
 local times={1.067,1.917}
 while state.next<=#times and os.clock()-state.started>=times[state.next] do
  local stage=state.next;state.next+=1
  pcall(Util.ApplyCameraShake,Util,stage*.2,stage*.35)
 end
 if state.next>#times then a.JDCEClientWindup=nil end
end
function Client.Play(a,data)
 if data and data.Retract then return end
 a.JDCEClientWindup={started=os.clock(),next=1}
 local animation=a.Animations and a.Animations.CorruptEnergy
 if animation then pcall(function()animation:Play(.025)end) end
end
function Client.Created(a)
 if a.Player~=Players.LocalPlayer then return end
 a.JDCEClientConnections={};a.JDCEOriginalDisabled=a.Behavior.Abilities.CorruptEnergy.Disabled
  a.JDCEClientConnections[1]=a.Rig:GetAttributeChangedSignal("JDCanRetract"):Connect(function()update(a)end)
 a.JDCEClientConnections[2]=RunService.RenderStepped:Connect(function()update(a);windup(a)end)
 a.JDCEClientConnections[3]=a.Rig:GetAttributeChangedSignal("Stunned"):Connect(function()
  if a.Rig:GetAttribute("Stunned") then
   a.JDCEClientWindup=nil
   local track=a.Animations and a.Animations.CorruptEnergy
   if track then pcall(function()track:Stop(.05)end) end
  end
 end)
 update(a)
end
function Client.Destroyed(a)
 a.JDCEClientWindup=nil
 for _,model in pairs(a.ActiveSpikeModels or {}) do model:Destroy() end
 a.ActiveSpikeModels={}
 for _,connection in ipairs(a.JDCEClientConnections or {}) do connection:Disconnect() end
 a.JDCEClientConnections={}
 if a.Behavior and a.Behavior.Abilities and a.Behavior.Abilities.CorruptEnergy then
  local ability=a.Behavior.Abilities.CorruptEnergy;ability.Disabled=a.JDCEOriginalDisabled;ability.Name="Corrupt Energy";ability.Icon="rbxassetid://83849304758564"
 end
end
return Client

end)()
local cooldown={Duration=18,TimePast=3.5}
local a={Player=player,Rig=rig,Cooldowns={CorruptEnergy=cooldown},Behavior={Abilities={CorruptEnergy={}}}}
Client.Created(a)
assert(a.Behavior.Abilities.CorruptEnergy.Name=="Corrupt Energy")
rig.attrs.JDCanRetract=true;changed.JDCanRetract:Fire()
assert(a.Behavior.Abilities.CorruptEnergy.Name=="Retract" and a.Behavior.Abilities.CorruptEnergy.Icon=="rbxassetid://105853980040304")
assert(button.CooldownTime.Text=="" and a.Cooldowns.CorruptEnergy==cooldown and cooldown.TimePast==3.5)
assert(a.Behavior.Abilities.CorruptEnergy.Disabled)
-- Existing cooldown accounting is untouched while the availability icon is rendered.
cooldown.TimePast=7;render:Fire();assert(cooldown.TimePast==7)
rig.attrs.JDCanRetract=false;changed.JDCanRetract:Fire()
assert(not a.Behavior.Abilities.CorruptEnergy.Disabled and a.Behavior.Abilities.CorruptEnergy.Name=="Corrupt Energy")
Client.Play(a,{Retract=false});Client.Play(a,{Retract=true}) -- absent animations must be safe
local destroyed=0
a.ActiveSpikeModels={one={Destroy=function()destroyed+=1 end}}
Client.Destroyed(a);assert(destroyed==1 and next(a.ActiveSpikeModels)==nil)
local n=button.CooldownTime.Text;rig.attrs.JDCanRetract=true;render:Fire();assert(button.CooldownTime.Text==n)
print("PASS Retract client: native FCT button/name/icon, original cooldown preserved, normal mode restored, missing animation safety, observer/visual cleanup")
