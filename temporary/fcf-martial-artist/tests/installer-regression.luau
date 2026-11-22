
local writes=0
local failAt=nil
local function copy(t)local out={};for k,v in pairs(t)do out[k]=v end;return out end
local Methods={}
local mt={}
function mt.__index(self,k)
 if Methods[k]then return Methods[k] end
 if k=="Parent"then return self._parent end
 local value=self._props[k]
 if value~=nil then return value end
 return self:FindFirstChild(k)
end
function mt.__newindex(self,k,v)
 if k=="Parent"then
  if self._parent then local old=self._parent._children;local i=table.find(old,self);if i then table.remove(old,i)end end
  rawset(self,"_parent",v);if v then table.insert(v._children,self)end
 else
  if k=="Source"then writes+=1;if failAt==writes then error("Injected Source write failure")end end
  self._props[k]=v
 end
end
local Instance={}
function Instance.new(class,parent)
 local self=setmetatable({_props={ClassName=class,Name=class},_children={},_attrs={}},mt)
 if parent then self.Parent=parent end
 return self
end
function Methods:IsA(class)
 return self.ClassName==class or class=="LuaSourceContainer"and(self.ClassName=="Script"or self.ClassName=="ModuleScript"or self.ClassName=="LocalScript")or class=="BasePart"and(self.ClassName=="Part"or self.ClassName=="MeshPart")
end
function Methods:FindFirstChild(name,recursive)
 for _,child in ipairs(self._children)do if child.Name==name then return child end end
 if recursive then for _,child in ipairs(self._children)do local found=child:FindFirstChild(name,true);if found then return found end end end
end
function Methods:FindFirstChildOfClass(class)for _,child in ipairs(self._children)do if child:IsA(class)then return child end end end
function Methods:GetChildren()return table.clone(self._children)end
function Methods:GetDescendants()local out={};for _,child in ipairs(self._children)do table.insert(out,child);for _,desc in ipairs(child:GetDescendants())do table.insert(out,desc)end end;return out end
function Methods:SetAttribute(k,v)self._attrs[k]=v end
function Methods:GetAttribute(k)return self._attrs[k]end
function Methods:Clone()
 local object=Instance.new(self.ClassName);object._props=copy(self._props);object._attrs=copy(self._attrs)
 for _,child in ipairs(self._children)do child:Clone().Parent=object end
 return object
end
function Methods:Destroy()self.Parent=nil;self.Destroyed=true;for _,child in ipairs(self:GetChildren())do child:Destroy()end end
function Methods:GetFullName()return (self.Parent and self.Parent:GetFullName().."."or "")..self.Name end
local game,workspace
local function child(parent,name,class)local o=Instance.new(class or "Folder");o.Name=name;o.Parent=parent;return o end
local function fresh()
 writes=0;failAt=nil
 game=Instance.new("DataModel");workspace=child(game,"Workspace","Workspace")
 local rep=child(game,"ReplicatedStorage");local assets=child(rep,"Assets");local survivors=child(assets,"Survivors")
 local modules=child(rep,"Modules");local statuses=child(modules,"StatusEffects");local misc=child(modules,"Misc")
 for _,name in {"Actors","Util","Statuses","Network","Sounds"}do child(modules,name,"ModuleScript")end
 for _,name in {"Maid","Trove"}do child(misc,name,"ModuleScript")end
 child(game,"ServerStorage")
 function game:GetService(name)
  if name=="RunService"then return {IsStudio=function()return true end,IsRunning=function()return false end}end
  if name=="ChangeHistoryService"then return {SetWaypoint=function()end}end
  return self:FindFirstChild(name)
 end
 return survivors,statuses
end
local function inputs()
 local donor=child(workspace,"HelperbotDonor");local rig=child(donor,"Rig","Model")
 child(rig,"Humanoid","Humanoid");child(rig,"HumanoidRootPart","Part")
 local upd=child(workspace,"HelperbotUPD");local config=child(upd,"Config","ModuleScript");local fx=child(config,"VFX")
 for _,name in {"Pulse","PulseHit","InspireActive"}do child(fx,name,"Attachment")end
 child(config,"Radar","MeshPart");child(config,"ChargeMeter","BillboardGui");child(config,"cl_HelperbotChargeBillboard","ModuleScript")
end

local selection={}
local getService=Methods.GetService
local function fixture()
 fresh()
 local getter=game.GetService
 function game:GetService(name)if name=='Selection'then return {Get=function()return selection end}end;return getter(self,name)end
 local a=game.ReplicatedStorage.Assets.Survivors
 local c=child(a,'#MArtist2','Folder');local cfg=child(c,'Config','ModuleScript');cfg.Source='oldConfig'
 local b=child(c,'Behavior','ModuleScript');b.Source='oldBehavior'
 local assets=child(game.ServerStorage,'Assets');local survivors=child(assets,'Survivors')
 local other=child(survivors,'#MArtist2');local cfg2=child(other,'Config','ModuleScript');cfg2.Source='oldConfig2'
 local b2=child(other,'Behavior','ModuleScript');b2.Source='oldBehavior2'
 selection={c};return cfg,b,cfg2,b2
end
local function install()
-- Select the imported Martial Artist root model/folder in Explorer, then run while stopped.
assert(game:GetService("RunService"):IsStudio() and not game:GetService("RunService"):IsRunning(),"Stop Play first.")
local selected=game:GetService("Selection"):Get()
assert(#selected==1,"Select ONE Martial Artist character root in Explorer.")
local target=selected[1]
while target and not (target:FindFirstChild("Config")and target:FindFirstChild("Behavior"))do target=target.Parent end
assert(target and target~=game,"Select the Martial Artist character containing Config and Behavior.")
assert(target.Name:lower():find("mart",1,true),"Selected character is not Martial Artist. Nothing changed.")
local configSource=[========[
local Config = {
	DisplayName = "Martial Artist",
	Quote = "\"aura farmmm\"",
	Credits = "",
	Class = "Sentinel",
	RenderImage = "rbxassetid://132877189294749",
	Price = 500,
	Exclusive = true,
	Health = 900,
	Speed = 12,
	EnragedSlashLungeForce = 400,
	KaioKen = script.KEN,
	EX = script.Explosion,
	Animations = {
		Idle = "rbxassetid://131082534135875",
		Walk = "rbxassetid://108018357044094",
		Run = "rbxassetid://136252471123500",
		InjuredIdle = "rbxassetid://131082534135875",
		InjuredWalk = "rbxassetid://108018357044094",
		InjuredRun = "rbxassetid://136252471123500",
		QuickAttack = "rbxassetid://123569615350667",
		GashingWoundStart = "rbxassetid://119850211147676",
		ComboStart = "rbxassetid://71609732352448",
		GashingWound = {
			KillerRig = "rbxassetid://74858281441140",
			PlayerRig = "rbxassetid://80582403450485"
		},
		Comboing = {
			KillerRig = "rbxassetid://93113732401329",
			PlayerRig = "rbxassetid://122434469589143"
		}
	},
	Sounds = {
		GashingWoundSwing = "rbxassetid://129697992204296",
		GashingWoundMiss = "rbxassetid://84353899757208",
		GashingWoundHit1 = "rbxassetid://8595980577",
		GashingWoundHit2 = "rbxassetid://8595983255",
		GashingWoundHit3 = "rbxassetid://8595977193",
		GashingWoundHit4 = "rbxassetid://441202925"
	}
}

-- Explicit port fallbacks: source model omits these values. Stun duration is reconstructed.
Config.SlashStunTime=2
Config.Sounds.Slash=Config.Sounds.GashingWoundHit1
Config.ScarfAnimation=script:FindFirstChild("ScarfAnimation")
Config.WaistAnimation=script:FindFirstChild("WaistAnimation")
Config.HeadbandAnimation=script:FindFirstChild("HeadbandAnimation")
Config.MArtistFCFPort="1.0.0"
return Config
]========]
local behaviorSource=[========[
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
]========]
local characters={target}
for _,service in {"ReplicatedStorage","ServerStorage"}do
 local assets=game:GetService(service):FindFirstChild("Assets")
 local survivors=assets and assets:FindFirstChild("Survivors")
 local other=survivors and survivors:FindFirstChild(target.Name)
 if other and not table.find(characters,other)then table.insert(characters,other)end
end
local pending={}
for _,character in characters do
 for _,name in {"Config","Behavior"}do
  local module=character:FindFirstChild(name)
  assert(module and module:IsA("ModuleScript"),"Expected ModuleScript: "..character:GetFullName().."/"..name..". Nothing changed.")
  local source=name=="Config" and configSource or behaviorSource
  if module.Source~=source then table.insert(pending,{module=module,before=module.Source,after=source})end
 end
end
if #pending==0 then print("[Martial Artist FCF] Already installed.");return end
local backup=Instance.new("Folder");backup.Name="MArtistFCF_Backup_"..os.date("!%Y%m%d_%H%M%S")
for i,item in pending do
 local saved=item.module:Clone();saved.Name=tostring(i).."_"..item.module.Name
 saved:SetAttribute("OriginalPath",item.module:GetFullName());saved.Parent=backup
 local original=Instance.new("ObjectValue");original.Name="Original";original.Value=item.module;original.Parent=saved
end
backup.Parent=game:GetService("ServerStorage")
local ok,err=pcall(function()for _,item in pending do item.module.Source=item.after end end)
if not ok then
 for _,item in pending do item.module.Source=item.before end
 backup:Destroy();error("[Martial Artist FCF] Rolled back: "..tostring(err))
end
print("[Martial Artist FCF] Installed. Save and start a fresh playtest. Third combo is reconstructed. Backup: "..backup:GetFullName())

end
local function restore()
assert(game:GetService("RunService"):IsStudio() and not game:GetService("RunService"):IsRunning(),"Stop Play first.")
local backup=game:GetService("Selection"):Get()[1]
assert(backup and backup.Name:match("^MArtistFCF_Backup_"),"Select the MArtistFCF_Backup folder in ServerStorage first.")
local pending={}
for _,saved in backup:GetChildren()do
 local reference=saved:FindFirstChild("Original")
 assert(reference and reference.Value and reference.Value.Parent,"Original module missing; nothing restored.")
 table.insert(pending,{target=reference.Value,before=reference.Value.Source,after=saved.Source})
end
local ok,err=pcall(function()for _,item in pending do item.target.Source=item.after end end)
if not ok then for _,item in pending do item.target.Source=item.before end;error(err)end
print("[Martial Artist FCF] Restored original sources. Save and restart Play.")

end
local c,b,c2,b2=fixture()
install();assert(c.Source~= 'oldConfig' and b.Source~='oldBehavior' and c2.Source==c.Source and b2.Source==b.Source)
local backup
for _,object in game.ServerStorage:GetChildren()do if object.Name:match('^MArtistFCF_Backup_')then backup=object end end
assert(backup)
local count=#game.ServerStorage:GetChildren();install();assert(#game.ServerStorage:GetChildren()==count)
selection={backup};restore()
assert(c.Source=='oldConfig'and b.Source=='oldBehavior'and c2.Source=='oldConfig2'and b2.Source=='oldBehavior2')
c,b,c2,b2=fixture();failAt=writes+3 -- four backup clone Source copies precede mutations in this mock
-- The mock's Clone copies props directly: failure occurs during actual source commit.
local ok=pcall(install);assert(not ok)
assert(c.Source=='oldConfig'and b.Source=='oldBehavior'and c2.Source=='oldConfig2'and b2.Source=='oldBehavior2')
c,b,c2,b2=fixture();b2.ClassName='Folder';ok=pcall(install);assert(not ok and c.Source=='oldConfig')
print('PASS installer: selected character and paired stores, idempotence, exact restore, preflight and write-failure rollback')
