
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

local nativeTypeof=typeof
local function typeof(value)if type(value)=="table"and value._cf then return "CFrame"end;if type(value)=="table"and value._props then return "Instance"end;return nativeTypeof(value)end
local function signal()
 local entries={}
 return {Connect=function(_,callback)
  local object={Active=true};function object:Disconnect()self.Active=false end
  table.insert(entries,{object,callback});return object
 end,Fire=function(_,...)
  for _,entry in table.clone(entries)do if entry[1].Active then entry[2](...)end end
 end,Count=function()local n=0;for _,entry in entries do if entry[1].Active then n+=1 end end;return n end}
end

fresh()
local now=100
local os={clock=function()return now end}
function workspace:GetServerTimeNow()return now end
local vmt={}
local function v(x,y,z)return setmetatable({X=x,Y=y,Z=z},vmt)end
function vmt.__index(a,key)if key=="Magnitude"then return math.sqrt(a.X*a.X+a.Y*a.Y+a.Z*a.Z)end end
function vmt.__add(a,b)return v(a.X+b.X,a.Y+b.Y,a.Z+b.Z)end
function vmt.__sub(a,b)return v(a.X-b.X,a.Y-b.Y,a.Z-b.Z)end
function vmt.__mul(a,b)return v(a.X*b,a.Y*b,a.Z*b)end
local cfm={}
local function cf(pos)return setmetatable({_cf=true,Position=pos,RightVector=v(1,0,0),UpVector=v(0,1,0),LookVector=v(0,0,-1)},cfm)end
function cfm.__index(a,key)
 if key=="GetComponents"then return function(self)return self.Position.X,self.Position.Y,self.Position.Z,1,0,0,0,1,0,0,0,1 end end
 if key=="Rotation"then local result=cf(v(0,0,0));result.LookVector=a.LookVector;return result end
 if key=="ToObjectSpace"then return function(self,other)return cf(other.Position-self.Position)end end
end
function cfm.__mul(a,b)
 local look=a.LookVector
 local pos=v(-look.Z*b.Position.X-look.X*b.Position.Z,b.Position.Y,look.X*b.Position.X-look.Z*b.Position.Z)
 local result=cf(a.Position+pos);result.LookVector=b.LookVector;return result
end
local Vector3={new=v}
local CFrame={new=function(x,y,z)return cf(type(x)=="table"and x or v(x or 0,y or 0,z or 0))end,lookAt=function(position,target)local result=cf(position);result.LookVector=target-position;return result end}
local RaycastParams={new=function()return {}end};local OverlapParams={new=function()return {}end}
local Enum={RaycastFilterType={Exclude=1},BulkMoveMode={FireCFrameChanged=1}}
function workspace:BulkMoveTo(parts,frames)for i,part in parts do part.CFrame=frames[i];part.Position=frames[i].Position end end
local Color3={new=function()return {}end}
function Methods:AddTag(name)self:SetAttribute("Tag_"..name,true)end
function Methods:IsDescendantOf(parent)local object=self.Parent;while object do if object==parent then return true end;object=object.Parent end;return false end
local cloneBase=Methods.Clone
function Methods:Clone()
 local result=cloneBase(self)
 if self.PrimaryPart then result.PrimaryPart=result:FindFirstChild(self.PrimaryPart.Name,true)end
 return result
end
function Methods:PivotTo(frame)
 self.PivotCalls=(self.PivotCalls or 0)+1
 local delta=frame.Position-self.PrimaryPart.CFrame.Position
 for _,part in self:GetDescendants()do if part:IsA("BasePart")then part.CFrame=CFrame.new(part.CFrame.Position+delta);part.Position=part.CFrame.Position end end
end
local players=child(workspace,"Players");local survivors=child(players,"Survivors");local killers=child(players,"Killers")
local map=child(workspace,"Map");child(map,"Ingame")
local floor=child(map,"Floor","Part");floor.Transparency=0
local blocked=false;local wall=false;local grounded=true
function workspace:Raycast(origin,direction)
 if direction.Y<0 then return grounded and {Position=v(origin.X,0,origin.Z),Normal=v(0,1,0),Instance=floor}or nil end
 return wall and {Instance=floor}or nil
end
function workspace:GetPartBoundsInBox()
 if blocked then local block=child(map,"Block","Part");block.Transparency=0;return {floor,block}end
 return {}
end
local heartbeat=signal()
local RunService={Heartbeat=heartbeat}
local Debris={AddItem=function()end}
local Actors={CurrentActors={},rewards={}}
function Actors:IncrementActorStats(player,data)table.insert(self.rewards,data)end
local Network={events={}}
function Network:FireClientConnection(player,name,kind,...)table.insert(self.events,{name=name,args={...}})end
function Network:FireAllClientConnection(name,kind,...)table.insert(self.events,{name=name,args={...}})end
local Util={}
function Util:CreateSpeedMultiplier(rig,value,name)local number=child(rig,name,"NumberValue");number.Value=value;return number end
function Util:LoadAnimationFromID()return nil end
function Util:RevealPlayerAuraTo()end
function Util:Heal(hum,value)hum.Health=math.min(hum.MaxHealth,hum.Health+value)end
local Statuses={calls={}}
function Statuses:ApplyStatus(rig,name,data)table.insert(self.calls,{rig=rig,name=name,data=data})end
local Sounds={Play=function()end}
local Rules=(function()
local Rules={}
function Rules.ActivityRemaining(last,now)return type(last)=="number"and math.max(0,10-(now-last))or 0 end
function Rules.EffectRadius(config,kind,count)
 local radius=config[kind=="Sentry"and "SentryDamageRadius"or "DispenserHealingRadius"]/2
 if kind=="Sentry"then radius=math.clamp(radius*(1-math.max(0,count-1)*config.SentryRangeReductionPercentage/100),config.SentryMinimumRange,radius)end
 return radius
end
function Rules.SlowLevel(config,builders)return builders>1 and config.SentryStackedSlownessLevel or config.SentrySlownessLevel end
function Rules.Points(kind,value)
 return math.ceil(math.clamp(kind=="Sentry"and value^.5*1.2 or value^.95*.35,0,20))
end
return Rules

end)()
local modules=game.ReplicatedStorage.Modules
modules.Actors=Actors;modules.Network=Network;modules.Util=Util;modules.Statuses=Statuses;modules.Sounds=Sounds
local getter=game.GetService
function game:GetService(name)if name=="RunService"then return RunService elseif name=="Debris"then return Debris end;return getter(self,name)end
local script={Parent={Rules=Rules}}
local function require(value)return value end
local TweenInfo={new=function()return {}end}
Enum.ExplosionType={NoCraters=1}
local TweenService={Create=function(_,object,info,props)return {Play=function()for key,value in props do object[key]=value end end}end}
local serviceGetter=game.GetService
function game:GetService(name)if name=="TweenService"then return TweenService elseif name=="Players"then return {GetPlayers=function()return {}end}end;return serviceGetter(self,name)end
local ss=child(game,"ServerScriptService");local server=child(ss,"Server");local systems=child(server,"Systems");local data=child(systems,"Data")
local tracker=child(data,"CombatStatistics","ModuleScript");function tracker:RecordDamage()end
function Methods:GetPlayingAnimationTracks()return {}end


local new=Instance.new
function Instance.new(class,parent)local result=new(class,parent);result.Destroying=signal();return result end
local destroy=Methods.Destroy
function Methods:Destroy()if self.Destroying then self.Destroying:Fire()end;destroy(self)end
local queue={}
local task={delay=function(delay,callback)table.insert(queue,{delay=delay,callback=callback})end}
CFrame.Angles=function()return CFrame.new()end
Color3.fromRGB=function()return {}end
local TaphConfig=(function()
-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local v0 = {
    DisplayName = "Taph", 
    Quote = "\"BOOM BOOM BOOM!\"", 
    Credits = "", 
    Class = "Support", 
    RenderImage = "rbxassetid://92247293916990", 
    Price = 600, 
    Exclusive = false, 
    Health = 100, 
    Speed = 12, 
    TripwireCooldown = 25, 
    TripwireLifetime = 9000000000, 
    TripwireMaxAmount = 3, 
    TripwireHealth = 10, 
    TripwireLifetimeDecreasePerTaph = 20, 
    TripwireDistanceBetweenTripwires = 8, 
    TripwireTriggerSlownessData = {
        Level = 2, 
        Duration = 4
    }, 
    TripwireTriggerAuraRevealInvincibleDuration = 4, 
    TripwireTriggerAuraRevealDuration = 8, 
    TripwireTriggerAuraRevealDistance = 999, 
    TripwireStackPenalty = 1.5, 
    TripwirePingDuration = 999, 
    TripwirePingDistance = 999, 
    TripwireDestroyedAuraDuration = 2, 
    TripwireDurationBetweenRewards = 4, 
    TripwireCooldownWhilePlacing = 2.5, 
    TripwireSpeedWhilePlacing = 8.5, 
    TripwireTemplate = script.TripwireHook, 
    TripwireCFrameOffset = CFrame.Angles(0, 0, 1.5707963267948966), 
    SubspaceTripmineCooldown = 40, 
    SubspaceCooldownReductionOnSuccess = 10, 
    SubspaceDamage = 55, 
    SubspaceLifetime = 50, 
    SubspaceThrowForce = 50, 
    SubspaceRange = 19, 
    SubspaceEffectHitLevel = 1, 
    SubspaceEffectLevel = 3, 
    SubspaceEffectDuration = 6, 
    SubspaceHelplessDuration = 3,
    SubspaceWeaknessLevel = 5,
    SubspaceWeaknessDuration = 6, 
    SubspaceExplosionDelay = 0.5, 
    SubspaceStackPenalty = 2, 
    SubspacePingDuration = 999, 
    SubspacePingDistance = 999, 
    SubspaceHiddenTransparency = 0.85, 
    SubspaceHintCount = 3, 
    SubspaceHintTransparency = 0.6, 
    SubspaceExplosionVFX = script.ExplosionVFX, 
    Animations = {
        TripwireIdle = "rbxassetid://75625991717863", 
        TripwireWalk = "rbxassetid://123731621741837", 
        TripwireRun = "rbxassetid://123731621741837", 
        TripwirePlaceStart = "rbxassetid://78069053061919", 
        TripwirePlaceEnd = "rbxassetid://99579737338864", 
        ThrowSubspace = "rbxassetid://114426480803065"
    }, 
    Sounds = {
        BeartrapToss = "rbxassetid://2769387310", 
        BeartrapLatch = "rbxassetid://2769387865", 
        TripwireStart = "rbxassetid://108754052230881", 
        TripwirePlace = "rbxassetid://98335565360313", 
        SubspaceUse = "rbxassetid://93397698791738", 
        SubspaceToss = "rbxassetid://11956590", 
        SubspaceHint = "rbxassetid://11984254", 
        SubspaceDetonate = "rbxassetid://11984351", 
        SubspaceDetonateSensitive = "rbxassetid://96989396921162"
    }, 
    TextInteractions = {
        Requests = {
            ElliotPizza = {
                "\240\159\141\149\226\157\147 (Have pizza?)", 
                "\240\159\141\149\226\157\151 (Need pizza!)", 
                "\240\159\141\149\226\157\151\226\157\151 (Need pizza, now!!)", 
                "\240\159\141\149\240\159\152\139 (Pizza is yummy. Need some.)", 
                "\240\159\141\149\240\159\141\189\239\184\143\226\157\147 (Have pizza to eat?)"
            }, 
            BuildermanSentry = {
                "\240\159\148\171\226\157\147 (Sentry here?)", 
                "\240\159\148\171\226\157\151 (Sentry here!)", 
                "\240\159\148\171\240\159\146\165\226\157\147 (Sentry goes off here?)", 
                "\240\159\148\171\226\128\188\239\184\143\226\172\135\239\184\143 (Sentry over here!!)", 
                "\240\159\148\171\226\158\161\239\184\143\240\159\148\170\240\159\146\171 (Sentry handles the killer here.)"
            }, 
            BuildermanDispenser = {
                "\226\157\164\239\184\143\226\128\141\240\159\169\185\226\157\147 (Dispenser please?)", 
                "\226\157\164\239\184\143\226\128\141\240\159\169\185\226\157\151 (Dispenser, hurry!)", 
                "\226\157\164\239\184\143\226\128\141\240\159\169\185\240\159\141\142\226\157\147 (Dispenser heal, please?)", 
                "\240\159\141\142\226\172\135\239\184\143\226\157\151 (Dispenser here, now!)", 
                "\226\157\164\239\184\143\226\128\141\240\159\169\185\226\128\188\239\184\143 (Dispenser over here, now!!)"
            }, 
            DusekkarProtection = {
                "\240\159\142\131\226\156\168\240\159\145\135 (Pumpkin magic here, please!)", 
                "\240\159\142\131\226\156\168\226\157\147 (Pumpkin, can you use magic here?)", 
                "\240\159\142\131\226\156\168 \226\157\151 (Pumpkin, use magic here!)", 
                "\240\159\142\131\226\156\168\240\159\153\143 (Pumpkin, use your magic here, please.)", 
                "\240\159\142\131\226\156\168\240\159\164\178\226\157\147 (Pumpkin, may you cast magic on me?)"
            }, 
            HemmorhageAsk = {
                "\240\159\148\170\240\159\146\148\240\159\145\142\240\159\153\143\226\157\147\239\184\143 (Chest's hurting bad, help me, please?)", 
                "\240\159\169\184\240\159\152\162\240\159\145\137\240\159\164\149\226\157\147\239\184\143 (Bleeding hurts, can you aid?)", 
                "\240\159\169\184\240\159\169\184\240\159\152\133 \240\159\153\143\226\157\147\239\184\143 (Bleeding a lot, ahah... Help, please?)", 
                "\226\152\185\239\184\143\240\159\169\184\240\159\152\147\240\159\153\143\226\157\147\239\184\143 (Got hurt, I'm bleeding real bad, please help?)", 
                "\240\159\169\184\226\157\151\239\184\143\240\159\164\149\240\159\152\140\226\157\151\239\184\143 (Bleeding! Help, and I'll be thankful!)"
            }
        }, 
        Thanks = {
            Regular = {
                "\240\159\145\141\226\156\168 (Thank you, you\226\128\153re the best.)", 
                "\240\159\146\170\226\157\151 (Thank you, you\226\128\153ve empowered me!)", 
                "\240\159\153\143\240\159\145\143 (Much appreciated.)", 
                "\240\159\153\135\226\157\163\239\184\143 (Thank you so very much!)", 
                "\240\159\152\132\240\159\145\141 (Thank you, I appreciate it!)", 
                "\240\159\152\129\240\159\145\141 (Many thanks, I appreciate the gesture!)"
            }
        }
    }
};
v0.Information = {
    {
        Separator = "GENERAL INFO"
    }, 
    {
        Header = "TAPH", 
        Text = "A mute demolitionist who used to blow up unmoderated experiences for the greater good. This would lead to some unintended consequences.\nUses Tripwires and Subspace Tripmines to slow down, reveal the position of, and disorientate the Killer.\n"
    }, 
    {
        Header = "STATS", 
        Text = "Difficulty: \226\152\133\226\152\133\226\152\134\226\152\134\226\152\134\n" .. ("Health: %*\n"):format(v0.Health or 100) .. ("Regular Speed: %*\n"):format(v0.Speed or 12) .. ("Sprinting Speed: %*\n"):format(v0.SprintSpeed or 26) .. ("Max Stamina: %*\n"):format(v0.MaxStamina or 100) .. ("Stamina Loss per sec: %*\n"):format(v0.StaminaLoss or 10) .. ("Stamina Gain per sec: %*\n"):format(v0.StaminaGain or 20)
    }, 
    {
        Separator = "ABILITIES"
    }, 
    {
        Image = "rbxassetid://135707604176757", 
        Header = "TRIPWIRE", 
        Quote = "\"\240\159\148\151\240\159\154\182\226\128\141\226\153\130\239\184\143\240\159\144\140\226\154\160\239\184\143\240\159\145\165\"", 
        Text = ("Cooldown: %*s\n"):format(v0.TripwireCooldown) .. "Taph places a tripwire on the ground in order to impede the Killer and alert other Survivors of their presence.\n" .. ("If the Killer walks over a tripwire, all survivors have the Killer\226\128\153s aura revealed to them for %* seconds and the Killer suffers <b>Slowness II</b> for %* seconds.\n"):format(v0.TripwireTriggerAuraRevealDuration, v0.TripwireTriggerSlownessData.Duration) .. ("The duration of the <b>Slowness</b> is reduced by %*s for every Taph currently alive.\n"):format(v0.TripwireStackPenalty) .. ("Tripwires have a total of %* health and are able to be destroyed by the Killer if they hit it.\n"):format(v0.TripwireHealth) .. ("Tripwires cannot be placed within %* studs of each other.\n"):format(v0.TripwireDistanceBetweenTripwires) .. ("Taph can only have %* tripwires placed at once.\n"):format(v0.TripwireMaxAmount) .. "\nTripwires arm 1.5 seconds after placement and disappear when Taph dies. Their Slowness and aura reveal durations decrease by 1.5 seconds per additional living Taph.\n"
    }, 
    {
        Image = "rbxassetid://89334370123950", 
        Header = "SUBSPACE TRIPMINE", 
        Quote = "\"\240\159\145\129\226\128\141\240\159\151\168  \240\159\146\163\240\159\146\165\226\157\147\240\159\146\171\"", 
        Text = ("Cooldown: %*s\n"):format(v0.SubspaceTripmineCooldown) .. "Mines take 3 seconds to arm and detonate after 0.5 seconds when a killer is within 19 studs with line of sight. Explosions still hit through walls. Full effects: Subspaced III for 6s, Helpless I for 3s, Weakness V for 6s. Each additional living Taph reduces durations by 2s, to a minimum of 0s. A killer who strikes the mine receives only Subspaced I; Taph still receives full self-effects. Mines explode immediately when Taph dies.\n"
    }
};
return v0;
end)()
local DuseConfig=(function()
-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local v0 = {
    DisplayName = "Dusekkar", 
    Quote = "\"Destiny's powerful hand has made the bed of my future, and it's up to me to lie in it.\"", 
    Credits = "", 
    Class = "Support", 
	RenderImage = "rbxassetid://108185471465150", 
    Price = 600, 
    Requests = {
        DusekkarProtection = {
            AbilityName = "SpawnProtection", 
            RequestTitle = "Request Forcefield", 
            NotificationTitle = "PLAYERNAME wants a force field!", 
            Order = 1
        }
    }, 
    Speed = 12, 
    Health = 90, 
    WarningTemplate = script.Warning, 
    VFXTemplate = script.VFX, 
    SpawnProtectionCooldown = 35, 
    SpawnProtectionSpeedReductionWhileInUse = 30, 
    SpawnProtectionSlownessData = {
        Level = 1, 
        Duration = 0
    }, 
    SpawnProtectionTimeUntilProtectableAgain = 30, 
    SpawnProtectionMaxPlayers = 3, 
    SpawnProtectionOverflowDebuffDuration = 5, 
    SpawnProtectionMaxDuration = 3.5, 
    SpawnProtectionTimeUntilBrokenByWallInterference = 2.5, 
    SpawnProtectionEffectMaxDistance = 95, 
    SpawnProtectionScaleRadius = 0.4, 
    SpawnProtectionRadiusTemplate = script.MouseRadius, 
    SpawnProtectionIndicatorTemplate = script.Indicator, 
    PlasmaBeamCooldown = 28, 
    PlasmaBeamSpeedData = {
        Level = 1, 
        Duration = 3
    }, 
    PlasmaBeamSlownessData = {
        Level = 1, 
        Duration = 4
    }, 
    PlasmaBeamSpeedReductionWhileInUse = 25, 
    PlasmaBeamHitboxSize = 2.5, 
    PlasmaBeamHitboxRange = 75, 
    PlasmaBeamOverheal = 25, 
    PlasmaBeamColor1 = Color3.fromRGB(0, 47, 255), 
    PlasmaBeamColor2 = Color3.fromRGB(0, 157, 255), 
    Animations = {
        Idle = "rbxassetid://97939891094323", 
        Walk = "rbxassetid://113341950296755", 
        Run = "rbxassetid://135718441093489", 
        InjuredIdle = "rbxassetid://117862111806447", 
        InjuredWalk = "rbxassetid://100382111802172", 
        InjuredRun = "rbxassetid://74234772538117", 
        StaffShot = "rbxassetid://107770005882507", 
        StaffStartup = "rbxassetid://100479560307146", 
        StaffLoop = "rbxassetid://110233346883411"
    }, 
    Sounds = {
        SpawnProtectionActivate = "rbxassetid://82959441339910", 
        SpawnProtectionLoop = "rbxassetid://91330471140281", 
        SpawnProtectionShieldBreak = "rbxassetid://72368725251506", 
        PlasmaBeamShoot = "rbxassetid://77126482422736"
    }, 
    TextInteractions = {
        Requests = {
            ElliotPizza = {
                "Hand me a slice, and make it fast, for I don\226\128\153t know how long I\226\128\153ll last.", 
                "I could help the others in a flick, but first I need pizza; make it quick.", 
                "My power\226\128\153s drained and my soul feels weak; pass me a slice so things won\226\128\153t seem bleak.", 
                "Thunder and lightning, northwinds blow! A slice of your pizza, go, go, go!", 
                "My body aches, my arms are in pain; hand me a slice, so I may work again."
            }, 
            BuildermanSentry = {
                "The path ahead will be tough. Place a sentry, here in the rough.", 
                "The killer\226\128\153s games are on display. A sentry here, then we get away.", 
                "A monster\226\128\153s presence is lurking near. Build a sentry, right over here.", 
                "All the materials are right in your hands. Build it quick, so we may escape these lands.", 
                "Your machines are strong, and built to last. Place one quick, and do it fast."
            }, 
            BuildermanDispenser = {
                "The others are wounded, that I can tell. Place a dispenser, and let's survive this hell.", 
                "My power is weakened, my health is drained. Build a dispenser & spare me from pain.", 
                "The killer is strong, we're all in pain; make a dispenser & fix us up again.", 
                "Our group's forces together are not enough. Build a dispenser, and make it tough.", 
                "A healing dispenser made of your average materials\226\128\166 that could surprise anyone, even ethereals."
            }, 
            DusekkarProtection = {
                "Your magic is needed upon this day. Cast your spell upon my say.", 
                "A magic touch should keep me at ease. Could you cast the spell for me, please?", 
                "Spells like force fields are just your fort\195\168. Cast it on me, and let's be on our way.", 
                "Magic is strong, so you must be wise; do it wrong or it may spell your demise.", 
                "You\226\128\153d be wise to protect another. But I still must ask, if it's not a bother."
            }, 
            HemmorhageAsk = {
                "I'm afraid that I must ask for your aid... Lest my life quickly fade..", 
                "My body aches as it continues to bleed, assist me in this and we will be freed.", 
                "The light in my eyes continues to die... But with your help, I may just be able to get by.", 
                "This body bleeds as the times pass.. Lend a hand, please do not be crass.", 
                "Aid my form as it bleeds, and then you may proceed."
            }
        }, 
        Thanks = {
            Regular = {
                "May the hope of others be your guide, for you have stayed true to my side.", 
                "You listened well, that much is true. I'd like to offer my thanks to you.", 
                "I'm ever grateful for the work you do. Someday, I may return the favor, too.", 
                "You\226\128\153ve heeded the demands that I've requested. Surely, now, we will not be bested.", 
                "With all the words that I could possibly use, it could not equate to the thanks I owe you."
            }, 
            BuildermanDispenser = {
                {
                    "Builderman: How you fairin Dusek?", 
                    "Dusekkar: The winds have worsened, my magic is weakened.", 
                    "Builderman: We have to keep our heads up, for them.", 
                    "Dusekkar: Of course my friend, we shall fight til the end."
                }
            }, 
            BuildermanSentry = {
                {
                    "Dusekkar: Builder, I have a question, one that has left quite an impression.", 
                    "Builderman: What's up Dusek? Somethin' on your mind?", 
                    "Dusekkar: Our dear friend Doombringer, my thoughts of him still linger.", 
                    "Builderman: I... haven't seen him since I asked he control the Banlands...", 
                    "Builderman: I hope hes doing well."
                }
            }
        }
    }
};
v0.Information = {
    {
        Separator = "GENERAL INFO"
    }, 
    {
        Header = "DUSEKKAR", 
        Text = "A wise and caring pumpkin, flowing with magic and entwined with power. Wielding the Staff of the Winds to protect and aid his team while hindering those who oppose him. His magic may be limited here, but that won't stop him from doing everything he can to see everyone return unharmed."
    }, 
    {
        Header = "STATS", 
        Text = "Difficulty: \226\152\133\226\152\133\226\152\133\226\152\133\226\152\133\n" .. ("Health: %*\n"):format(v0.Health or 100) .. ("Regular Speed: %*\n"):format(v0.Speed or 12) .. ("Sprinting Speed: %*\n"):format(v0.SprintSpeed or 26) .. ("Max Stamina: %*\n"):format(v0.MaxStamina or 100) .. ("Stamina Loss per sec: %*\n"):format(v0.StaminaLoss or 10) .. ("Stamina Gain per sec: %*\n"):format(v0.StaminaGain or 20)
    }, 
    {
        Separator = "PASSIVES"
    }, 
    {
        Header = "LEVITATION", 
        Quote = "\"The cursed spirit is doomed to walk the Earth until it has hunted it's hunter.\" - Ghosdeeri", 
        Text = "Dusekkar levitates naturally, meaning that they don't make footstep sounds.\n"
    }, 
    {
        Separator = "ABILITIES"
    }, 
    {
        Header = "SPAWN PROTECTION", 
        Image = "rbxassetid://136501603087283", 
        Quote = "\"Let be be finale of seem, seems to me.\" - Darkseed", 
        Text = ("Cooldown: %*s\n"):format(v0.SpawnProtectionCooldown) .. ("Dusekkar casts his magic to create a shield around a Survivor of his choice for up to %*s.\n"):format(v0.SpawnProtectionMaxDuration) .. ("Dusekkar's movement speed is reduced by %*%% while protecting a Survivor.\n"):format(v0.SpawnProtectionSpeedReductionWhileInUse) .. ("This ability has a range of %* studs.\n"):format(v0.SpawnProtectionEffectMaxDistance) .. "The protected Survivor receives <b>Resistance IV</b> for as long as they're protected.\n" .. "If a protected Survivor takes lethal damage (any hit that would trigger a kill animation or instant death), the hit is completely nullified and the shield instantly breaks.\n" .. "If three Dusekkars ever protect Survivors at the same time, all their shields break and they are inflicted with <b>Blindness III</b> and <b>Slowness III</b> for 5s.\n" .. ("Survivors who receive protection cannot be protected again until %*s have passed since they were last protected.\n"):format(v0.SpawnProtectionTimeUntilProtectableAgain)
    }, 
    {
        Header = "PLASMA BEAM", 
        Image = "rbxassetid://83030778673034", 
        Quote = "\"And you don't fight destiny.\" - the guy from the movie", 
        Text = ("Cooldown: %*s\n"):format(v0.PlasmaBeamCooldown) .. "Dusekkar channels his powers to shoot out a beam of plasma energy at either a Survivor or the Killer.\n" .. ("Dusekkar's movement speed is reduced by %*%% while casting this ability.\n"):format(v0.PlasmaBeamSpeedReductionWhileInUse) .. ("This ability has a range of %* studs and can only hit one player at a time.\n"):format(v0.PlasmaBeamHitboxRange) .. ("Hitting a Survivor with this ability inflicts them with <b>Speed I</b> for %*s and grants them %* Overhealth. Every other Dusekkar alive reduces the overhealth amount by 2.5.\n"):format(v0.PlasmaBeamSpeedData.Duration, v0.PlasmaBeamOverheal) .. ("Hitting a Killer with this ability inflicts them with <b>Slowness I</b> for %*s. The duration is lowered by 0.5s for every other Dusekkar that's alive. If the <b>Slowness</b> duration is less than or equal to 0.5s, then nothing happens.\n"):format(v0.PlasmaBeamSlownessData.Duration)
    }
};
return v0;
end)()
assert(TaphConfig.SubspaceRange==19 and TaphConfig.SubspaceExplosionDelay==.5 and TaphConfig.SubspaceEffectDuration==6)
assert(TaphConfig.SubspaceHelplessDuration==3 and TaphConfig.SubspaceWeaknessLevel==5 and TaphConfig.SubspaceWeaknessDuration==6)
assert(TaphConfig.TripwireStackPenalty==1.5 and TaphConfig.SubspaceStackPenalty==2)
assert(DuseConfig.PlasmaBeamSlownessData.Level==1 and DuseConfig.PlasmaBeamSlownessData.Duration==4)
assert(DuseConfig.PlasmaBeamSpeedData.Duration==3 and DuseConfig.PlasmaBeamOverheal==25 and DuseConfig.PlasmaBeamCooldown==28)
assert(DuseConfig.SpawnProtectionCooldown==35 and DuseConfig.SpawnProtectionTimeUntilProtectableAgain==30)
local Support=(function()
local RunService=game:GetService("RunService")
local Actors=require(game.ReplicatedStorage.Modules.Actors)
local Support={}
function Support.Count(actor)
 local count=0
 for _,other in Actors.CurrentActors do
  local hum=other.Rig and other.Rig:FindFirstChildOfClass("Humanoid")
  if other.ActorName==actor.ActorName and hum and hum.Health>0 then count+=1 end
 end
 return math.max(1,count)
end
function Support.Duration(base,penalty,count)return math.max(0,base-math.max(0,count-1)*penalty)end
local function params(actor,mine)
 local p=RaycastParams.new();p.FilterType=Enum.RaycastFilterType.Exclude;p.RespectCanCollide=true
 local excluded={actor.Rig,mine}
 local players=workspace:FindFirstChild("Players");if players then table.insert(excluded,players)end
 p.FilterDescendantsInstances=excluded
 return p
end
function Support.VisibleKiller(actor,mine,util)
 if not mine.Parent or not mine.PrimaryPart then return nil end
 local origin=mine.PrimaryPart.Position
 local candidates=util:GetClosestPlayerFromPosition(origin,{PlayerSelection="Killers",ReturnTable=true,MaxDistance=actor.Config.SubspaceRange})
 local p=params(actor,mine)
 for _,entry in candidates or {}do
  local rig=entry.Player
  local root=rig and rig.PrimaryPart
  if root and not workspace:Raycast(origin,root.Position-origin,p)then return entry end
 end
end
function Support.Stop(actor)
 local state=actor.TaphPortState
 if not state or state.stopped then return end
 state.stopped=true
 for _,connection in state.connections do connection:Disconnect()end
 state.connections={}
 for model,remove in state.wires do
  if model.Parent then remove();if model.Parent then model:Destroy()end end
 end
 state.wires={}
 for model,record in state.mines do
  if model.Parent then
   model:SetAttribute("TaphForceExplosion",true)
   if record.explode then record.explode()else record.hum.Health=.125 end
  end
 end
end
function Support.Bind(actor)
 if actor.TaphPortState then return actor.TaphPortState end
 local state={mines={},wires={},connections={},stopped=false};actor.TaphPortState=state
 local hum=actor.Rig:FindFirstChildOfClass("Humanoid")
 if hum then table.insert(state.connections,hum.HealthChanged:Connect(function(value)if value<=0 then Support.Stop(actor)end end))end
 table.insert(state.connections,actor.Rig.Destroying:Connect(function()Support.Stop(actor)end))
 return state
end
function Support.Wire(actor,model,remove)
 local state=Support.Bind(actor);state.wires[model]=remove
 model.Destroying:Connect(function()state.wires[model]=nil end)
 if state.stopped then remove();if model.Parent then model:Destroy()end end
end
function Support.Mine(actor,mine,hum)
 local state=Support.Bind(actor)
 state.mines[mine]={hum=hum}
 mine.Destroying:Connect(function()state.mines[mine]=nil end)
 local root=mine.PrimaryPart
 local p=params(actor,mine)
 local initial=actor.Rig.PrimaryPart.Position
 local _,size=mine:GetBoundingBox()
 local radius=math.clamp(math.min(size.X,size.Y,size.Z)*.5,.15,1)
 local function sweep(origin,direction)
  if direction.Magnitude<.001 then return nil end
  return workspace:Spherecast(origin,radius,direction,p)
 end
 local hit=sweep(initial,root.Position-initial)
 if hit then
  local delta=root.Position-initial
  local safe=initial+delta.Unit*math.max(0,hit.Distance-.05)
  mine:PivotTo(mine:GetPivot()+safe-root.Position)
  root.AssemblyLinearVelocity=Vector3.zero
 end
 local last=root.Position
 local flight
 flight=RunService.Heartbeat:Connect(function()
  if not mine.Parent or not mine.PrimaryPart then flight:Disconnect();return end
  local current=root.Position
  local result=sweep(last,current-last)
  if result then
   local direction=current-last
   local safe=last+direction.Unit*math.max(0,result.Distance-.05)
   mine:PivotTo(mine:GetPivot()+safe-current)
   root.AssemblyLinearVelocity=Vector3.zero
  end
  last=root.Position
 end)
 mine.Destroying:Connect(function()flight:Disconnect()end)
 if state.stopped then mine:SetAttribute("TaphForceExplosion",true);hum.Health=.125 end
end
function Support.Schedule(actor,mine,delaySeconds,callback)
 local state=Support.Bind(actor)
 local record=state.mines[mine]
 if not record then record={};state.mines[mine]=record end
 if record.explode then return end
 local fired=false
 local function run()
  if fired then return end
  fired=true
  if mine.Parent then callback()end
 end
 record.explode=run
 if state.stopped or mine:GetAttribute("TaphForceExplosion")then run()else task.delay(delaySeconds,run)end
end
return Support

end)()
local function actor(name)
 local rig=child(survivors,name,"Model")
 local root=child(rig,"Root","Part");root.Position=v(0,3,0);root.CFrame=CFrame.new(root.Position);rig.PrimaryPart=root
 local hum=child(rig,"Humanoid","Humanoid");hum.Health=100;hum.HealthChanged=signal()
 local result={ActorName=name,Rig=rig,Config=TaphConfig};Actors.CurrentActors[result]=result
 return result,hum
end
local owner,hum=actor("Taph");local second,secondHum=actor("Taph");local other=actor("Dusekkar")
assert(Support.Count(owner)==2);secondHum.Health=0;assert(Support.Count(owner)==1)
assert(Support.Duration(3,2,3)==0 and Support.Duration(6,2,2)==4)
Support.Bind(owner)
local wire=child(map,"Wire","Model");local removed=0
Support.Wire(owner,wire,function()removed+=1 end)
local mine=child(map,"Mine","Model");mine.PrimaryPart=child(mine,"Root","Part");mine.PrimaryPart.Position=v(0,1,0)
local target=child(killers,"Killer","Model");target.PrimaryPart=child(target,"Root","Part");target.PrimaryPart.Position=v(0,1,-8)
local hiddenTarget=child(killers,"Hidden","Model");hiddenTarget.PrimaryPart=child(hiddenTarget,"Root","Part");hiddenTarget.PrimaryPart.Position=v(0,1,8)
local candidates={ {Player=hiddenTarget},{Player=target} }
local util={GetClosestPlayerFromPosition=function()return candidates end}
function workspace:Raycast(origin,direction)return direction.Z>0 and {Instance=floor}or nil end
assert(Support.VisibleKiller(owner,mine,util).Player==target,"hidden nearest killer blocked visible candidate")
candidates={{Player=hiddenTarget}};assert(not Support.VisibleKiller(owner,mine,util),"detected killer through wall")
local fired=0
Support.Schedule(owner,mine,.5,function()fired+=1;mine:Destroy()end)
assert(fired==0 and queue[#queue].delay==.5)
hum.Health=0;hum.HealthChanged:Fire(0)
assert(fired==1 and removed==1 and not wire.Parent,"death failed to detonate mine/remove wire immediately")
queue[#queue].callback();Support.Stop(owner);assert(fired==1 and removed==1,"death produced duplicate effects")
assert(hum.HealthChanged:Count()==0,"owner listener leaked")
local owner2,hum2=actor("Taph");Support.Bind(owner2)
local mine2=child(map,"Mine2","Model");local mineHum={Health=1}
owner2.TaphPortState.mines[mine2]={hum=mineHum}
Support.Stop(owner2);assert(mineHum.Health==.125 and mine2:GetAttribute("TaphForceExplosion"),"unarmed mine was not triggered on death")
local instant=0;Support.Schedule(owner2,mine2,.5,function()instant+=1 end);assert(instant==1)
local geometryOwner=actor("Taph")
local projectile=child(map,"Projectile","Model");projectile.PrimaryPart=child(projectile,"Root","Part")
projectile.PrimaryPart.Position=v(0,3,-4);projectile.PrimaryPart.CFrame=CFrame.new(0,3,-4)
function Methods:GetBoundingBox()return self.PrimaryPart.CFrame,v(1,1,1)end
function Methods:GetPivot()return self.PrimaryPart.CFrame end
function cfm.__add(frame,delta)return CFrame.new(frame.Position+delta)end
function cfm.__sub(frame,delta)return CFrame.new(frame.Position-delta)end
local index=vmt.__index
vmt.__index=function(a,key)if key=="Unit"then return v(a.X/a.Magnitude,a.Y/a.Magnitude,a.Z/a.Magnitude)end;return index(a,key)end
local sweeps=0
function workspace:Spherecast(origin,radius,direction,p)
 sweeps+=1;assert(p.RespectCanCollide and table.find(p.FilterDescendantsInstances,players))
 return sweeps==1 and {Distance=2}or nil
end
Support.Mine(geometryOwner,projectile,{Health=1})
assert(math.abs(projectile.PrimaryPart.Position.Z+1.95)<1e-6,"initial throw crossed wall")
local before=heartbeat:Count();projectile:Destroy();assert(heartbeat:Count()==before-1,"flight sweep connection leaked")
print("PASS Taph balance, living-player stacking, wall detection, multiple candidates, throw sweep, normal/death detonation, unarmed mine and wire cleanup")
local v45={Rig=other.Rig,Config=DuseConfig}
local v47=child(survivors,"Protected","Model");v47.PrimaryPart=child(v47,"Root","Part");v47.PrimaryPart.Anchored=true
local v48
                v48 = not v47 and "NoTarget" or v45.Rig:GetAttribute("Protecting") and "Protecting" or v47:GetAttribute("DusekkarProtected") and "TargetProtected" or v47:GetAttribute("Protecting") and "TargetProtecting" or (v47.PrimaryPart.Anchored and not v47:GetAttribute("AzureGrabbed")) and "TargetAnchored" or os.clock() - (tonumber(v47:GetAttribute("LastProtection")) or 0) <= v45.Config.SpawnProtectionTimeUntilProtectableAgain and (tonumber(v47:GetAttribute("LastProtection")) or 0) + v45.Config.SpawnProtectionTimeUntilProtectableAgain - os.clock() or v47:GetAttribute("NosHookCaught") and "NosHookCaught";
assert(v48=="TargetAnchored")
v47:SetAttribute("AzureGrabbed",true)
                v48 = not v47 and "NoTarget" or v45.Rig:GetAttribute("Protecting") and "Protecting" or v47:GetAttribute("DusekkarProtected") and "TargetProtected" or v47:GetAttribute("Protecting") and "TargetProtecting" or (v47.PrimaryPart.Anchored and not v47:GetAttribute("AzureGrabbed")) and "TargetAnchored" or os.clock() - (tonumber(v47:GetAttribute("LastProtection")) or 0) <= v45.Config.SpawnProtectionTimeUntilProtectableAgain and (tonumber(v47:GetAttribute("LastProtection")) or 0) + v45.Config.SpawnProtectionTimeUntilProtectableAgain - os.clock() or v47:GetAttribute("NosHookCaught") and "NosHookCaught";
assert(not v48,"vine-held survivor was rejected")
v47:SetAttribute("NosHookCaught",true)
                v48 = not v47 and "NoTarget" or v45.Rig:GetAttribute("Protecting") and "Protecting" or v47:GetAttribute("DusekkarProtected") and "TargetProtected" or v47:GetAttribute("Protecting") and "TargetProtecting" or (v47.PrimaryPart.Anchored and not v47:GetAttribute("AzureGrabbed")) and "TargetAnchored" or os.clock() - (tonumber(v47:GetAttribute("LastProtection")) or 0) <= v45.Config.SpawnProtectionTimeUntilProtectableAgain and (tonumber(v47:GetAttribute("LastProtection")) or 0) + v45.Config.SpawnProtectionTimeUntilProtectableAgain - os.clock() or v47:GetAttribute("NosHookCaught") and "NosHookCaught";
assert(v48=="NosHookCaught","vine exception bypassed another restriction")
print("PASS Dusekkar final balance, anchored-target rejection, vine exception and retained hook restriction")

game.Players=child(game,"Players")
function game.Players:GetPlayerFromCharacter(rig)return rig.PlayerName end
local effects={}
local v4={ApplyStatus=function(_,rig,name,data)assert(data.Duration>0);effects[name]=data end}
local function explosionEffects(weakened,selfHit,count)
 effects={}
 local ownerRig=child(survivors,"Owner","Model");ownerRig.PlayerName="Owner"
 local victim=selfHit and ownerRig or child(killers,"Victim","Model");victim.PlayerName=selfHit and "Owner"or "Killer"
 local v92={Rig=ownerRig,Config=TaphConfig}
 local v126={Player=victim}
 local v119=math.max(0,count-1)*TaphConfig.SubspaceStackPenalty
 local v99=Instance.new("Model");if weakened then v99:SetAttribute("RecentAttacker",victim.PlayerName)end
                                            local v127 = v126.Player~=v92.Rig and v99:GetAttribute("RecentAttacker") == tostring(game.Players:GetPlayerFromCharacter(v126.Player));
                                            if v92.Config.SubspaceEffectDuration-v119>0 then v4:ApplyStatus(v126.Player, "Subspaced", {
                                                Level = v127 and v92.Config.SubspaceEffectHitLevel or v92.Config.SubspaceEffectLevel, 
                                                Duration = math.max(0,v92.Config.SubspaceEffectDuration - v119)
                                            });end;
                                            if not v126.Player:GetAttribute("Invincible") and not v127 and v92.Config.SubspaceHelplessDuration-v119>0 then
                                                v4:ApplyStatus(v126.Player, "Helpless", {
                                                    Level = 1, 
                                                    Duration = math.max(0,v92.Config.SubspaceHelplessDuration - v119), 
                                                    TimeStackable = false
                                                });
                                            end;
                                            if not v126.Player:GetAttribute("Invincible") and (not v127 or v126.Player==v92.Rig)then
                                                local duration=math.max(0,v92.Config.SubspaceWeaknessDuration-v119);
                                                if duration>0 then v4:ApplyStatus(v126.Player,"Weakness",{Level=v92.Config.SubspaceWeaknessLevel,Duration=duration,TimeStackable=false})end;
                                            end;

 return effects
end
local effects=explosionEffects(false,false,1)
assert(effects.Subspaced.Level==3 and effects.Subspaced.Duration==6 and effects.Helpless.Duration==3 and effects.Weakness.Level==5 and effects.Weakness.Duration==6)
effects=explosionEffects(true,false,1)
assert(effects.Subspaced.Level==1 and not effects.Helpless and not effects.Weakness,"struck mine applied full debuffs")
effects=explosionEffects(true,true,1)
assert(effects.Subspaced.Level==3 and effects.Helpless and effects.Weakness,"self-hit was weakened")
effects=explosionEffects(false,false,3)
assert(effects.Subspaced.Duration==2 and not effects.Helpless and effects.Weakness.Duration==2)
assert(not next(explosionEffects(false,false,4)),"zero duration created a status")
print("PASS actual explosion status branch: normal, weakened killer, full self-hit, stacking and zero-duration suppression")
