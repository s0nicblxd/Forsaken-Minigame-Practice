
local time=0;local timers={};local server=true
local task={delay=function(delay,fn)table.insert(timers,{at=time+delay,fn=fn})end}
local function advance(dt)
 local finish=time+dt
 while true do table.sort(timers,function(a,b)return a.at<b.at end)
  if not timers[1]or timers[1].at>finish then break end
  local t=table.remove(timers,1);time=t.at;t.fn()
 end
 time=finish
end
local function signal()
 local s={listeners={}}
 function s:Connect(fn)local c={Connected=true};function c:Disconnect()self.Connected=false end;table.insert(self.listeners,{fn=fn,c=c});return c end
 function s:Fire(...)for _,e in table.clone(self.listeners)do if e.c.Connected then e.fn(...)end end end
 return s
end
local vecmt={__mul=function(a,b)return {force=b}end}
local Vector3={new=function(...)return setmetatable({...},vecmt)end}
local cf=setmetatable({LookVector=Vector3.new(0,0,-1)},{__mul=function(a,b)return a end})
local CFrame={new=function()return cf end}
local function rig(name)
 local r={Name=name,Parent={Name='Killers'},signals={},AncestryChanged=signal()}
 r.PrimaryPart={Parent=r,Anchored=false,CFrame=cf}
 r.Humanoid={Parent=r,Health=100,Died=signal(),IsA=function(_,name)return name=='Humanoid'end}
 function r:FindFirstChildOfClass(name)return self[name]end
 function r:FindFirstChild()return nil end
 function r:GetAttribute(name)return self[name]end
 function r:GetAttributeChangedSignal(name)self.signals[name]=self.signals[name]or signal();return self.signals[name]end
 function r:GetPivot()return cf end
 function r:PivotTo()self.pivoted=true end
 return r
end
local boxes={};local rewards=0;local animationLoads=0;local emitted=0
local run={IsServer=function()return server end}
local actors={CurrentActors={},IncrementActorStats=function()rewards+=1 end}
local statuses={items={},ApplyStatus=function(self,target,name,data)table.insert(self.items,{target=target,name=name,data=data})end}
local util={}
function util:LoadAnimationFromID()animationLoads+=1;error('Mock inaccessible animation')end
function util:CreateSpeedMultiplier()local m={Parent=true};function m:Destroy()self.Parent=nil end;return m end
function util:GiveInvincible(rig,key,duration)rig.shield=duration end
function util:ApplyVelocity()local v={Parent=true};function v:Destroy()self.Parent=nil end;return v end
local modules={Util=util,Sounds={Play=function()end},Hitboxes={CreateHitbox=function(_,player,options)
 local box={options=options};function box:Cancel()self.cancelled=true end;table.insert(boxes,box);return box
end},Statuses=statuses,Actors=actors}
function modules:FindFirstChild()return nil end
local players={GetPlayerFromCharacter=function(_,r)return r.player end}
local game={ReplicatedStorage={Modules=modules},GetService=function(_,name)if name=='RunService'then return run elseif name=='Players'then return players end end}
local humanoids={};local workspace={GetDescendants=function()return humanoids end}
local require=function(m)return m end
local typeof=function(x)return type(x)=='table'and x.IsA and 'Instance'or type(x)end
local warn=function()end
local Behavior=(function()
-- FCF compatibility port. Third move uses the supplied Combo hit timings, not recovered server code.
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
 -- FCF has named disablers; do not overwrite unrelated ability locks.
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
 -- FCF drops Target from hitbox options. Explicitly exclude other humanoid models instead.
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
 -- Play the provided extra move attachments; no guessed persistent status or damage effects.
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
 -- Confirmed older Combo timings/damage; intentionally reused for reconstructed extra move.
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
   -- Release before applying the finisher impulse; cleanup also releases both on any failure.
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
 -- Keep the hitbox alive for its full .25s rather than releasing at .75s.
 later(state,.95,function()cleanup(state)end)
end
local function execute(actor,fn,...)
 if not RunService:IsServer()then return end -- Server owns combat and replicated animations.
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

end)()
local function actor(name)
 local a={Rig=rig(name),Config={Animations={GashingWoundStart='start',ComboStart='extra',QuickAttack='quick',GashingWound={KillerRig='caster',PlayerRig='target'},Comboing={KillerRig='extraCaster',PlayerRig='extraTarget'}},Sounds={}},locks={},Player={}}
 a.Rig.player=a.Player
 function a:DisableAbilities(key,value)self.locks[key]=value or nil end
 a.locks.Unrelated=true;actors.CurrentActors[a.Player]=a
 table.insert(humanoids,a.Rig.Humanoid)
 return a
end
local a,v=actor('MArtist'),actor('Victim')
Behavior.Created(Behavior,a)
assert(Behavior.Abilities.Combo.Cooldown==5 and Behavior.Abilities.QuickAttack.Cooldown==5 and Behavior.Abilities.SuperDeathKillCombo.Cooldown==15)
-- No server effects when dispatcher invokes client callback.
server=false;Behavior.Abilities.Combo.Callback(a);assert(not a.MArtistCast and #boxes==0);server=true
Behavior.Abilities.Combo.Callback(a);local state=a.MArtistCast
advance(.383);local first=boxes[#boxes];assert(first.options.Damage(v.Rig)==10)
first.options.Connections.Hit(v.Rig)
assert(state.target==v.Rig and a.Rig.PrimaryPart.Anchored and v.Rig.PrimaryPart.Anchored)
assert(v.locks.MArtist_Combo and v.Rig.pivoted and a.Rig.shield==2)
advance(.7001);local second=boxes[#boxes];assert(second.options.Damage(v.Rig)==15 and second.options.Damage(a.Rig)==0)
assert(table.find(second.options.Ignore,a.Rig))
second.options.Connections.Hit(v.Rig)
advance(.6341);local third=boxes[#boxes];assert(third.options.Damage(v.Rig)==10);third.options.Connections.Hit(v.Rig)
advance(.1031)
assert(not a.MArtistCast and not a.Rig.PrimaryPart.Anchored and not v.Rig.PrimaryPart.Anchored)
assert(not v.locks.MArtist_Combo and a.locks.Unrelated and not a.locks.MArtist_Combo)
assert(rewards==1 and first.cancelled and second.cancelled and third.cancelled)
assert(animationLoads>=3,'animation failures did not prevent damage and release')
-- Miss cleans up early and cannot spawn follow-up hitboxes.
local count=#boxes;Behavior.Abilities.Combo.Callback(a);advance(2);assert(#boxes==count+1 and not a.MArtistCast)
-- New third move uses confirmed old timing and distinct animation family.
Behavior.Abilities.SuperDeathKillCombo.Callback(a);advance(.383);local super=boxes[#boxes];super.options.Connections.Hit(v.Rig)
assert(a.MArtistCast.target==v.Rig and super.options.Damage(v.Rig)==10)
-- Interruption restores both rigs immediately and prevents delayed attacks.
count=#boxes;a.Rig.Stunned=true;a.Rig:GetAttributeChangedSignal('Stunned'):Fire()
assert(not a.MArtistCast and not v.Rig.PrimaryPart.Anchored and not a.Rig.PrimaryPart.Anchored)
advance(2);assert(#boxes==count and a.locks.Unrelated);a.Rig.Stunned=nil
-- Quick Attack preserves its hitbox lifetime and default stun, once-per-cast reward.
Behavior.Abilities.QuickAttack.Callback(a);advance(.667);local quick=boxes[#boxes]
assert(quick.options.Damage==25 and quick.options.Time==.25)
quick.options.Connections.Hit(v.Rig);quick.options.Connections.Hit(v.Rig)
assert(statuses.items[#statuses.items].data.Duration==2 and a.MArtistCast)
advance(.083);assert(a.MArtistCast and not quick.cancelled)
advance(.201);assert(not a.MArtistCast and quick.cancelled)
assert(rewards==3,'one reward per cast, including reconstructed combo')
-- Disappearing victim and caster death release locks/anchors and cancel all pending hits.
Behavior.Abilities.Combo.Callback(a);advance(.383);boxes[#boxes].options.Connections.Hit(v.Rig)
v.Rig.Parent=nil;v.Rig.AncestryChanged:Fire(v.Rig,nil)
assert(not a.MArtistCast and not a.Rig.PrimaryPart.Anchored and not v.Rig.PrimaryPart.Anchored)
v.Rig.Parent={Name='Killers'}
Behavior.Abilities.Combo.Callback(a);a.Rig.Humanoid.Health=0;a.Rig.Humanoid.Died:Fire();assert(not a.MArtistCast)
Behavior.Destroyed(Behavior,a);assert(not a.MArtistDecorationTracks)
print('PASS Martial Artist: FCF paths, server-only attacks, three hit timings, target filtering, rewards, misses, Quick Attack lifetime, missing animation tolerance and interruption/death/removal cleanup')
