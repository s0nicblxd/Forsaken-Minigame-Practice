local RunService=game:GetService("RunService")
local Players=game:GetService("Players")
local Modules=game.ReplicatedStorage.Modules
local Util=require(Modules.Util)
local Sounds=require(Modules.Sounds)
local Hitboxes=require(Modules.Hitboxes)
local Statuses=require(Modules.Statuses)
local Actors=require(Modules.Actors)
local Behavior={}
local function root(rig)return rig and rig.Parent and rig.PrimaryPart end
local function living(rig)
 local hum=rig and rig:FindFirstChildOfClass("Humanoid")
 return root(rig) and hum and hum.Health>0
end
local function try(fn,...)
 local ok,result=pcall(fn,...)
 if not ok then warn("[Martial Artist] "..tostring(result))end
 return ok,result
end
local function playSound(actor,name)
 local id=actor.Config.Sounds and actor.Config.Sounds[name]
 if id and root(actor.Rig) then try(function()Sounds:Play(id,{Parent=actor.Rig.PrimaryPart,Volume=.5})end)end
end
local function track(rig,id)
 if not id or id=="" or not rig or not rig.Parent then return end
 local ok,result=try(function()return Util:LoadAnimationFromID(rig,id,true)end)
 return ok and result or nil
end
local function play(state,rig,id)
 local animation=track(rig,id)
 if animation then
  local ok=try(function()animation:Play(.05)end)
  if ok then table.insert(state.tracks,animation);return animation end
 end
end
local function lock(actor,key,value)
 
 if actor.DisableAbilities then actor:DisableAbilities(key,value)
 else actor.AbilityDisablers=actor.AbilityDisablers or {};actor.AbilityDisablers[key]=value or nil end
end
local function findActor(rig)
 local player=Players:GetPlayerFromCharacter(rig)
 return (player and Actors.CurrentActors[player]) or Actors.CurrentActors[rig]
end
local cleanup
local function later(state,delay,callback)
 task.delay(delay,function()
  if state.done then return end
  if not living(state.actor.Rig) then cleanup(state);return end
  local ok,err=xpcall(callback,debug.traceback)
  if not ok then warn("[Martial Artist] "..tostring(err));cleanup(state)end
 end)
end
cleanup=function(state)
 if state.done then return end
 state.done=true
 for _,connection in state.connections do connection:Disconnect()end
 for _,box in state.boxes do if box and box.Cancel then box:Cancel()end end
 for _,animation in state.tracks do pcall(function()animation:Stop(.05)end)end
 for part,wasAnchored in state.anchors do if part.Parent then part.Anchored=wasAnchored end end
 for part,enabled in state.emitters do if part.Parent then part.Enabled=enabled end end
 for _,object in state.objects do if object.Parent then object:Destroy()end end
 if state.multiplier and state.multiplier.Parent then state.multiplier:Destroy()end
 if state.targetActor then lock(state.targetActor,state.key,false)end
 lock(state.actor,state.key,false)
 if state.actor.MArtistCast==state then state.actor.MArtistCast=nil end
end
local function begin(actor,name)
 if actor.MArtistCast or not living(actor.Rig) then return end
 local state={actor=actor,key="MArtist_"..name,boxes={},tracks={},anchors={},connections={},objects={},emitters={}}
 actor.MArtistCast=state;lock(actor,state.key,true)
 local hum=actor.Rig:FindFirstChildOfClass("Humanoid")
 table.insert(state.connections,hum.Died:Connect(function()cleanup(state)end))
 table.insert(state.connections,actor.Rig.AncestryChanged:Connect(function(_,parent)if not parent then cleanup(state)end end))
 table.insert(state.connections,actor.Rig:GetAttributeChangedSignal("Stunned"):Connect(function()
  if actor.Rig:GetAttribute("Stunned") then cleanup(state)end
 end))
 local ok,mult=try(function()return Util:CreateSpeedMultiplier(actor.Rig,.001,state.key)end)
 if ok then state.multiplier=mult end
 return state
end
local function reward(state,victim)
 if state.rewarded or not victim.Parent or victim.Parent.Name~="Killers" then return end
 state.rewarded=true
 if state.actor.Player then try(function()Actors:IncrementActorStats(state.actor.Player,{Action="Hit Killer with "..state.key.." as Martial Artist",RewardType="Offensive"})end)end
end
local function shield(actor)
 if Util.GiveInvincible then try(function()Util:GiveInvincible(actor.Rig,"MArtistHit",2)end)end
end
local function anchor(state,part)
 if state.anchors[part]==nil then state.anchors[part]=part.Anchored end
 part.Anchored=true
end
local function createBox(state,options)
 options.AbilityType="AltAbility"
 local box=Hitboxes:CreateHitbox(state.actor.Player,options)
 if box then table.insert(state.boxes,box)end
 return box
end
local function ignoreOthers(victim)
 
 local ignore={}
 for _,object in workspace:GetDescendants()do
  if object:IsA("Humanoid") and object.Parent~=victim then table.insert(ignore,object.Parent)end
 end
 return ignore
end
local function markGrab(state,victim)
 if state.target or not living(victim) or victim==state.actor.Rig then return end
 local aroot,vroot=root(state.actor.Rig),root(victim)
 if vroot.Anchored then return end
 state.target=victim;state.targetActor=findActor(victim)
 if state.targetActor then lock(state.targetActor,state.key,true)end
 table.insert(state.connections,victim:FindFirstChildOfClass("Humanoid").Died:Connect(function()cleanup(state)end))
 table.insert(state.connections,victim.AncestryChanged:Connect(function(_,parent)if not parent then cleanup(state)end end))
 anchor(state,aroot);anchor(state,vroot)
 victim:PivotTo(state.actor.Rig:GetPivot())
end
local function flourish(state)
 
 local config=state.actor.Config
 for _,template in {config.KaioKen,config.EX}do
  if typeof(template)=="Instance" and root(state.actor.Rig)then
   local effect=template:Clone();effect.Parent=state.actor.Rig.PrimaryPart;table.insert(state.objects,effect)
   for _,object in effect:GetDescendants()do
    if object:IsA("ParticleEmitter")then object:Emit(object:GetAttribute("EmitCount")or 15)end
   end
  end
 end
end
local function combo(actor,extra)
 local state=begin(actor,extra and "SuperDeathKillCombo" or "Combo");if not state then return end
 local animations=actor.Config.Animations or {}
 local pair=(extra and animations.Comboing)or animations.GashingWound or {}
 local start=(extra and animations.ComboStart)or animations.GashingWoundStart
 local opening=play(state,actor.Rig,start)
 if extra then flourish(state)end
 later(state,.2,function()playSound(actor,"GashingWoundSwing")end)
 
 for index,hit in {{.383,10},{1.083,15},{1.717,10}}do
  later(state,hit[1],function()
   if index>1 and not living(state.target)then return end
   createBox(state,{
    Size=Vector3.new(8,4,8),CFrameOffset=CFrame.new(0,0,-2.25),
    Damage=function(victim)return (index==1 or victim==state.target)and hit[2]or 0 end,
    Time=.15,Knockback=0,HitMultiple=false,
    Ignore=index>1 and ignoreOthers(state.target)or nil,
    Connections={Hit=function(victim)
     if state.done or (index>1 and victim~=state.target)then return end
     local ok,err=xpcall(function()
      reward(state,victim);shield(actor)
      if index==1 then
       markGrab(state,victim)
       if state.target then
        if opening then opening:Stop(.05)end
        play(state,actor.Rig,pair.KillerRig)
        play(state,victim,pair.PlayerRig)
       end
      end
      playSound(actor,"GashingWoundHit"..index)
     end,debug.traceback)
     if not ok then warn(err);cleanup(state)end
    end}
   })
  end)
 end
 later(state,.6,function()if not state.target then playSound(actor,"GashingWoundMiss");cleanup(state)end end)
 later(state,1.82,function()
  local victim=state.target
  if living(victim)then
   local ar,vr=root(actor.Rig),root(victim)
   victim:PivotTo(actor.Rig:GetPivot()*CFrame.new(0,0,-3))
   
   if state.anchors[vr]~=nil then vr.Anchored=state.anchors[vr];state.anchors[vr]=nil end
   if not vr.Anchored then vr.AssemblyLinearVelocity=ar.CFrame.LookVector*200 end
   local ragdollModule=Modules:FindFirstChild("Ragdolls")
   if ragdollModule then
    local ok,ragdolls=try(require,ragdollModule)
    if ok and ragdolls.Enable and ragdolls.Disable then
     try(function()ragdolls:Enable(victim)end)
     task.delay(1.25,function()if victim.Parent then try(function()ragdolls:Disable(victim)end)end end)
    end
   end
  end
  playSound(actor,"GashingWoundHit4");cleanup(state)
 end)
end
local function quick(actor)
 local state=begin(actor,"QuickAttack");if not state then return end
 play(state,actor.Rig,(actor.Config.Animations or {}).QuickAttack)
 Statuses:ApplyStatus(actor.Rig,"Resistance",{Level=1,Duration=2})
 later(state,.667,function()
  playSound(actor,"Slash")
  local velocity=Util:ApplyVelocity(actor.Rig.PrimaryPart,120)
  if velocity then table.insert(state.objects,velocity)end
  createBox(state,{
   Size=Vector3.new(4,6,20),CFrameOffset=CFrame.new(0,0,-15.25),Damage=25,
   Time=.25,Knockback=20,HitMultiple=false,
   Connections={Hit=function(victim)
    if state.done then return end
    local ok,err=xpcall(function()
     shield(actor);reward(state,victim)
     Statuses:ApplyStatus(victim,"Stunned",{Duration=actor.Config.SlashStunTime or 2})
     playSound(actor,"GashingWoundHit3")
    end,debug.traceback)
    if not ok then warn(err);cleanup(state)end
   end}
  })
 end)
 
 later(state,.95,function()cleanup(state)end)
end
local function execute(actor,fn,...)
 if not RunService:IsServer()then return end 
 local args=table.pack(...)
 local ok,err=xpcall(function()fn(actor,table.unpack(args,1,args.n))end,debug.traceback)
 if not ok then warn("[Martial Artist] "..tostring(err));if actor.MArtistCast then cleanup(actor.MArtistCast)end end
end
Behavior.Abilities={
 Combo={LayoutOrder=1,Icon="rbxassetid://132724488499212",KeybindType="AltAbility1",Cooldown=5,Callback=function(a)execute(a,combo,false)end},
 QuickAttack={LayoutOrder=2,Icon="rbxassetid://85282571177550",KeybindType="AltAbility2",Cooldown=5,Callback=function(a)execute(a,quick)end},
 SuperDeathKillCombo={LayoutOrder=3,Icon="rbxassetid://132724488499212",KeybindType="AltAbility3",Cooldown=15,Callback=function(a)execute(a,combo,true)end},
}
function Behavior.Created(_,actor)
 if not RunService:IsServer()then return end
 actor.MArtistDecorationTracks={}
 local config=actor.Config
 for _,entry in {{"mScarf","ScarfAnimation"},{"mWaist","WaistAnimation"},{"mHeadband","HeadbandAnimation"}}do
  local object=actor.Rig:FindFirstChild(entry[1]);local animation=config[entry[2]]
  local controller=object and object:FindFirstChildOfClass("AnimationController")
  if controller and typeof(animation)=="Instance" and animation:IsA("Animation")then
   local animator=controller:FindFirstChildOfClass("Animator")or Instance.new("Animator",controller)
   local ok,result=try(function()local t=animator:LoadAnimation(animation);t.Looped=true;t:Play();return t end)
   if ok then table.insert(actor.MArtistDecorationTracks,result)end
  end
 end
end
function Behavior.Destroyed(_,actor)
 if actor.MArtistCast then cleanup(actor.MArtistCast)end
 for _,animation in actor.MArtistDecorationTracks or {}do pcall(function()animation:Stop()end)end
 actor.MArtistDecorationTracks=nil
end
return Behavior
