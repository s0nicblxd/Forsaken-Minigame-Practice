assert(not game:GetService("RunService"):IsRunning(),"Stop Play mode before applying this update.")
local changes={{path=[========[
ReplicatedStorage/Assets/Survivors/Taph/Config]========],edits={{[========[
TripwireStackPenalty = 0.85]========],[========[
TripwireStackPenalty = 1.5]========]},{[========[
SubspaceRange = 16]========],[========[
SubspaceRange = 19]========]},{[========[
SubspaceEffectDuration = 5]========],[========[
SubspaceEffectDuration = 6]========]},{[========[
SubspaceHelplessDuration = 5]========],[========[
SubspaceHelplessDuration = 3,
    SubspaceWeaknessLevel = 5,
    SubspaceWeaknessDuration = 6]========]},{[========[
SubspaceExplosionDelay = 0.4]========],[========[
SubspaceExplosionDelay = 0.5]========]},{[========[
SubspaceStackPenalty = 0.85]========],[========[
SubspaceStackPenalty = 2]========]},{[========[
        Text = ("Cooldown: %*s\n"):format(v0.TripwireCooldown) .. "Taph places a tripwire on the ground in order to impede the Killer and alert other Survivors of their presence.\n" .. ("If the Killer walks over a tripwire, all survivors have the Killer\226\128\153s aura revealed to them for %* seconds and the Killer suffers <b>Slowness II</b> for %* seconds.\n"):format(v0.TripwireTriggerAuraRevealDuration, v0.TripwireTriggerSlownessData.Duration) .. ("The duration of the <b>Slowness</b> is reduced by %*s for every Taph currently alive.\n"):format(v0.TripwireStackPenalty) .. ("Tripwires have a total of %* health and are able to be destroyed by the Killer if they hit it.\n"):format(v0.TripwireHealth) .. ("Tripwires cannot be placed within %* studs of each other.\n"):format(v0.TripwireDistanceBetweenTripwires) .. ("Taph can only have %* tripwires placed at once.\n"):format(v0.TripwireMaxAmount)]========],[========[
        Text = ("Cooldown: %*s\n"):format(v0.TripwireCooldown) .. "Taph places a tripwire on the ground in order to impede the Killer and alert other Survivors of their presence.\n" .. ("If the Killer walks over a tripwire, all survivors have the Killer\226\128\153s aura revealed to them for %* seconds and the Killer suffers <b>Slowness II</b> for %* seconds.\n"):format(v0.TripwireTriggerAuraRevealDuration, v0.TripwireTriggerSlownessData.Duration) .. ("The duration of the <b>Slowness</b> is reduced by %*s for every Taph currently alive.\n"):format(v0.TripwireStackPenalty) .. ("Tripwires have a total of %* health and are able to be destroyed by the Killer if they hit it.\n"):format(v0.TripwireHealth) .. ("Tripwires cannot be placed within %* studs of each other.\n"):format(v0.TripwireDistanceBetweenTripwires) .. ("Taph can only have %* tripwires placed at once.\n"):format(v0.TripwireMaxAmount) .. "\nTripwires arm 1.5 seconds after placement and disappear when Taph dies. Their Slowness and aura reveal durations decrease by 1.5 seconds per additional living Taph.\n"]========]},{[========[
        Text = ("Cooldown: %*s\n"):format(v0.SubspaceTripmineCooldown) .. "Taph throws a Subspace Tripmine infront of her that takes 3 seconds to arm.\n" .. ("Thrown Subspace Tripmines reveal themselves with an audible jingle and a dim light every %* seconds.\n"):format((math.floor(v0.SubspaceLifetime / v0.SubspaceHintCount))) .. ("Subspace Tripmines have a maximum lifetime of %* seconds and will detonate automatically when they expire.\n"):format(v0.SubspaceLifetime) .. ("If the Killer enters within %* studs of the Subspace Tripmine, it will light up and explode after %*s.\n"):format(v0.SubspaceRange, v0.SubspaceExplosionDelay) .. ("If the Killer is hit by the explosion, they will be inflicted with <b>Subspaced III</b> and <b>Helpless I</b> for %* seconds, and the cooldown of Subspace Tripmine will be reduced by %* seconds.\n"):format(v0.SubspaceEffectDuration, v0.SubspaceCooldownReductionOnSuccess) .. "If the killer hits the Tripmine prior to it detonating, the Tripmine instead only inflicts <b>Subspaced I</b> and does not inflict <b>Helpless</b>.\n" .. ("These effects have their duration reduced by %*s for every Taph currently alive.\n"):format(v0.SubspaceStackPenalty) .. "Taph is also affected by his own Subspace Tripmine, and will always receive the full effects regardless of if the Killer has hit the Tripmine or not if they are within range when it detonates.\n"]========],[========[
        Text = ("Cooldown: %*s\n"):format(v0.SubspaceTripmineCooldown) .. "Mines take 3 seconds to arm and detonate after 0.5 seconds when a killer is within 19 studs with line of sight. Explosions still hit through walls. Full effects: Subspaced III for 6s, Helpless I for 3s, Weakness V for 6s. Each additional living Taph reduces durations by 2s, to a minimum of 0s. A killer who strikes the mine receives only Subspaced I; Taph still receives full self-effects. Mines explode immediately when Taph dies.\n"]========]}}},
{path=[========[
ReplicatedStorage/Assets/Survivors/Taph/Behavior]========],edits={{[========[
local v0 = {};]========],[========[
local TaphSupport=require(game.ReplicatedStorage.Modules.TaphSupport)
local v0 = {};]========]},{[========[
v0.Created = function(_, v151) --[[ Line: 747 ]] --[[ Name: Created ]]]========],[========[
v0.Created = function(_, v151) --[[ Line: 747 ]] --[[ Name: Created ]]
    if game["Run Service"]:IsServer() then TaphSupport.Bind(v151)end;]========]},{[========[
v0.Destroyed = function(_, v186) --[[ Line: 910 ]] --[[ Name: Destroyed ]]]========],[========[
v0.Destroyed = function(_, v186) --[[ Line: 910 ]] --[[ Name: Destroyed ]]
    if game["Run Service"]:IsServer() then TaphSupport.Stop(v186)end;]========]},{[========[
local v65 = nil;]========],[========[
TaphSupport.Wire(v30,l_Model_0,v63);
                                            local armedAt=os.clock()+1.5;
                                            local v65 = nil;]========]},{[========[
local l_v66_FirstAncestorOfClass_0 = v66:FindFirstAncestorOfClass("Model");]========],[========[
if os.clock()<armedAt then return end;
                                                local l_v66_FirstAncestorOfClass_0 = v66:FindFirstAncestorOfClass("Model");]========]},{[========[
(#v30 - 1) * v30.Config.TripwireStackPenalty]========],[========[
(TaphSupport.Count(v30) - 1) * v30.Config.TripwireStackPenalty]========]},{[========[
(#v92 - 1) * v92.Config.SubspaceStackPenalty]========],[========[
(TaphSupport.Count(v92) - 1) * v92.Config.SubspaceStackPenalty]========]},{[========[
task.delay(v92.Config.SubspaceExplosionDelay, function()]========],[========[
TaphSupport.Schedule(v92,v99,v92.Config.SubspaceExplosionDelay, function()]========]},{[========[
task.delay(3, function() --[[ Line: 637 ]]]========],[========[
TaphSupport.Mine(v92,v99,l_Humanoid_1);
                        task.delay(3, function() --[[ Line: 637 ]]]========]},{[========[
local l_v2_ClosestPlayerFromPosition_4 = v2:GetClosestPlayerFromPosition(v99.PrimaryPart.Position, {
                                    PlayerSelection = "Killers", 
                                    MaxDistance = v92.Config.SubspaceRange
                                });]========],[========[
local l_v2_ClosestPlayerFromPosition_4 = TaphSupport.VisibleKiller(v92,v99,v2);]========]},{[========[
while l_Humanoid_1.Health > 0.125 and v99.PrimaryPart do]========],[========[
while v99.Parent and l_Humanoid_1.Health > 0.125 and v99.PrimaryPart do]========]},{[========[
if not v99 then]========],[========[
if not v99.Parent then]========]},{[========[
Duration = v92.Config.SubspaceEffectDuration - v119]========],[========[
Duration = math.max(0,v92.Config.SubspaceEffectDuration - v119)]========]},{[========[
Duration = v92.Config.SubspaceHelplessDuration - v119]========],[========[
Duration = math.max(0,v92.Config.SubspaceHelplessDuration - v119)]========]},{[========[
                                            v126.Player:SetAttribute("TaphSubspaced", os.clock());]========],[========[
                                            if not v126.Player:GetAttribute("Invincible") and (not v127 or v126.Player==v92.Rig)then
                                                local duration=math.max(0,v92.Config.SubspaceWeaknessDuration-v119);
                                                if duration>0 then v4:ApplyStatus(v126.Player,"Weakness",{Level=v92.Config.SubspaceWeaknessLevel,Duration=duration,TimeStackable=false})end;
                                            end;
                                            v126.Player:SetAttribute("TaphSubspaced", os.clock());]========]},{[========[
local v127 = v99:GetAttribute("RecentAttacker") == tostring(game.Players:GetPlayerFromCharacter(v126.Player));]========],[========[
local v127 = v126.Player~=v92.Rig and v99:GetAttribute("RecentAttacker") == tostring(game.Players:GetPlayerFromCharacter(v126.Player));]========]},{[========[
                                            v4:ApplyStatus(v126.Player, "Subspaced", {]========],[========[
                                            if v92.Config.SubspaceEffectDuration-v119>0 then v4:ApplyStatus(v126.Player, "Subspaced", {]========]},{[========[
Duration = math.max(0,v92.Config.SubspaceEffectDuration - v119)
                                            });]========],[========[
Duration = math.max(0,v92.Config.SubspaceEffectDuration - v119)
                                            });end;]========]},{[========[
if not v126.Player:GetAttribute("Invincible") and not v127 then]========],[========[
if not v126.Player:GetAttribute("Invincible") and not v127 and v92.Config.SubspaceHelplessDuration-v119>0 then]========]}}},
{path=[========[
ReplicatedStorage/Assets/Survivors/Dusekkar/Config]========],edits={{[========[
SpawnProtectionCooldown = 30]========],[========[
SpawnProtectionCooldown = 35]========]},{[========[
SpawnProtectionTimeUntilProtectableAgain = 25]========],[========[
SpawnProtectionTimeUntilProtectableAgain = 30]========]},{[========[
PlasmaBeamCooldown = 30]========],[========[
PlasmaBeamCooldown = 28]========]},{[========[
PlasmaBeamOverheal = 30]========],[========[
PlasmaBeamOverheal = 25]========]},{[========[
PlasmaBeamSpeedData = {
        Level = 1, 
        Duration = 4]========],[========[
PlasmaBeamSpeedData = {
        Level = 1, 
        Duration = 3]========]},{[========[
PlasmaBeamSlownessData = {
        Level = 2, 
        Duration = 3]========],[========[
PlasmaBeamSlownessData = {
        Level = 1, 
        Duration = 4]========]},{[========[
inflicts them with <b>Slowness II</b>]========],[========[
inflicts them with <b>Slowness I</b>]========]}}},
{path=[========[
ReplicatedStorage/Assets/Survivors/Dusekkar/Behavior]========],edits={{[========[
(#v88 - 1) * 0.5]========],[========[
math.max(0,v90) * 0.5]========]},{[========[
v47.PrimaryPart.Anchored and "TargetAnchored"]========],[========[
(v47.PrimaryPart.Anchored and not v47:GetAttribute("AzureGrabbed")) and "TargetAnchored"]========]},{[========[
Action = "Zapped a Survivor", 
                                                Money = 4, 
                                                EXP = 8]========],[========[
Action = "Zapped a Survivor", 
                                                Money = 4, 
                                                EXP = 8,
                                                KillerChance = 0.5]========]}}},
{path=[========[
ReplicatedStorage/Assets/Killers/c00lkidd/Behavior]========],edits={{[========[
CorruptNature = {
        LayoutOrder = 2,
        Icon = "rbxassetid://81200466982776",
        KeybindType = "AltAbility1",
        Cooldown = 16]========],[========[
CorruptNature = {
        LayoutOrder = 2,
        Icon = "rbxassetid://81200466982776",
        KeybindType = "AltAbility1",
        Cooldown = 13]========]}}},
{path=[========[
ReplicatedStorage/Modules/Util]========],edits={{[========[
Action = "Prevented the death of a Survivor",
			Money = 10,
			EXP = 30,
			KillerChance = 0.5]========],[========[
Action = "Prevented the death of a Survivor",
			Money = 10,
			EXP = 30,
			KillerChance = 1]========]}}},
{path=[========[
ServerStorage/Assets/Survivors/Taph/Config]========],edits={{[========[
TripwireStackPenalty = 0.85]========],[========[
TripwireStackPenalty = 1.5]========]},{[========[
SubspaceRange = 16]========],[========[
SubspaceRange = 19]========]},{[========[
SubspaceEffectDuration = 5]========],[========[
SubspaceEffectDuration = 6]========]},{[========[
SubspaceHelplessDuration = 5]========],[========[
SubspaceHelplessDuration = 3,
    SubspaceWeaknessLevel = 5,
    SubspaceWeaknessDuration = 6]========]},{[========[
SubspaceExplosionDelay = 0.4]========],[========[
SubspaceExplosionDelay = 0.5]========]},{[========[
SubspaceStackPenalty = 0.85]========],[========[
SubspaceStackPenalty = 2]========]},{[========[
        Text = ("Cooldown: %*s\n"):format(v0.TripwireCooldown) .. "Taph places a tripwire on the ground in order to impede the Killer and alert other Survivors of their presence.\n" .. ("If the Killer walks over a tripwire, all survivors have the Killer\226\128\153s aura revealed to them for %* seconds and the Killer suffers <b>Slowness II</b> for %* seconds.\n"):format(v0.TripwireTriggerAuraRevealDuration, v0.TripwireTriggerSlownessData.Duration) .. ("The duration of the <b>Slowness</b> is reduced by %*s for every Taph currently alive.\n"):format(v0.TripwireStackPenalty) .. ("Tripwires have a total of %* health and are able to be destroyed by the Killer if they hit it.\n"):format(v0.TripwireHealth) .. ("Tripwires cannot be placed within %* studs of each other.\n"):format(v0.TripwireDistanceBetweenTripwires) .. ("Taph can only have %* tripwires placed at once.\n"):format(v0.TripwireMaxAmount)]========],[========[
        Text = ("Cooldown: %*s\n"):format(v0.TripwireCooldown) .. "Taph places a tripwire on the ground in order to impede the Killer and alert other Survivors of their presence.\n" .. ("If the Killer walks over a tripwire, all survivors have the Killer\226\128\153s aura revealed to them for %* seconds and the Killer suffers <b>Slowness II</b> for %* seconds.\n"):format(v0.TripwireTriggerAuraRevealDuration, v0.TripwireTriggerSlownessData.Duration) .. ("The duration of the <b>Slowness</b> is reduced by %*s for every Taph currently alive.\n"):format(v0.TripwireStackPenalty) .. ("Tripwires have a total of %* health and are able to be destroyed by the Killer if they hit it.\n"):format(v0.TripwireHealth) .. ("Tripwires cannot be placed within %* studs of each other.\n"):format(v0.TripwireDistanceBetweenTripwires) .. ("Taph can only have %* tripwires placed at once.\n"):format(v0.TripwireMaxAmount) .. "\nTripwires arm 1.5 seconds after placement and disappear when Taph dies. Their Slowness and aura reveal durations decrease by 1.5 seconds per additional living Taph.\n"]========]},{[========[
        Text = ("Cooldown: %*s\n"):format(v0.SubspaceTripmineCooldown) .. "Taph throws a Subspace Tripmine infront of her that takes 3 seconds to arm.\n" .. ("Thrown Subspace Tripmines reveal themselves with an audible jingle and a dim light every %* seconds.\n"):format((math.floor(v0.SubspaceLifetime / v0.SubspaceHintCount))) .. ("Subspace Tripmines have a maximum lifetime of %* seconds and will detonate automatically when they expire.\n"):format(v0.SubspaceLifetime) .. ("If the Killer enters within %* studs of the Subspace Tripmine, it will light up and explode after %*s.\n"):format(v0.SubspaceRange, v0.SubspaceExplosionDelay) .. ("If the Killer is hit by the explosion, they will be inflicted with <b>Subspaced III</b> and <b>Helpless I</b> for %* seconds, and the cooldown of Subspace Tripmine will be reduced by %* seconds.\n"):format(v0.SubspaceEffectDuration, v0.SubspaceCooldownReductionOnSuccess) .. "If the killer hits the Tripmine prior to it detonating, the Tripmine instead only inflicts <b>Subspaced I</b> and does not inflict <b>Helpless</b>.\n" .. ("These effects have their duration reduced by %*s for every Taph currently alive.\n"):format(v0.SubspaceStackPenalty) .. "Taph is also affected by his own Subspace Tripmine, and will always receive the full effects regardless of if the Killer has hit the Tripmine or not if they are within range when it detonates.\n"]========],[========[
        Text = ("Cooldown: %*s\n"):format(v0.SubspaceTripmineCooldown) .. "Mines take 3 seconds to arm and detonate after 0.5 seconds when a killer is within 19 studs with line of sight. Explosions still hit through walls. Full effects: Subspaced III for 6s, Helpless I for 3s, Weakness V for 6s. Each additional living Taph reduces durations by 2s, to a minimum of 0s. A killer who strikes the mine receives only Subspaced I; Taph still receives full self-effects. Mines explode immediately when Taph dies.\n"]========]}}},
{path=[========[
ServerStorage/Assets/Survivors/Taph/Behavior]========],edits={{[========[
local v0 = {};]========],[========[
local TaphSupport=require(game.ReplicatedStorage.Modules.TaphSupport)
local v0 = {};]========]},{[========[
v0.Created = function(_, v151) --[[ Line: 747 ]] --[[ Name: Created ]]]========],[========[
v0.Created = function(_, v151) --[[ Line: 747 ]] --[[ Name: Created ]]
    if game["Run Service"]:IsServer() then TaphSupport.Bind(v151)end;]========]},{[========[
v0.Destroyed = function(_, v186) --[[ Line: 910 ]] --[[ Name: Destroyed ]]]========],[========[
v0.Destroyed = function(_, v186) --[[ Line: 910 ]] --[[ Name: Destroyed ]]
    if game["Run Service"]:IsServer() then TaphSupport.Stop(v186)end;]========]},{[========[
local v65 = nil;]========],[========[
TaphSupport.Wire(v30,l_Model_0,v63);
                                            local armedAt=os.clock()+1.5;
                                            local v65 = nil;]========]},{[========[
local l_v66_FirstAncestorOfClass_0 = v66:FindFirstAncestorOfClass("Model");]========],[========[
if os.clock()<armedAt then return end;
                                                local l_v66_FirstAncestorOfClass_0 = v66:FindFirstAncestorOfClass("Model");]========]},{[========[
(#v30 - 1) * v30.Config.TripwireStackPenalty]========],[========[
(TaphSupport.Count(v30) - 1) * v30.Config.TripwireStackPenalty]========]},{[========[
(#v92 - 1) * v92.Config.SubspaceStackPenalty]========],[========[
(TaphSupport.Count(v92) - 1) * v92.Config.SubspaceStackPenalty]========]},{[========[
task.delay(v92.Config.SubspaceExplosionDelay, function()]========],[========[
TaphSupport.Schedule(v92,v99,v92.Config.SubspaceExplosionDelay, function()]========]},{[========[
task.delay(3, function() --[[ Line: 637 ]]]========],[========[
TaphSupport.Mine(v92,v99,l_Humanoid_1);
                        task.delay(3, function() --[[ Line: 637 ]]]========]},{[========[
local l_v2_ClosestPlayerFromPosition_4 = v2:GetClosestPlayerFromPosition(v99.PrimaryPart.Position, {
                                    PlayerSelection = "Killers", 
                                    MaxDistance = v92.Config.SubspaceRange
                                });]========],[========[
local l_v2_ClosestPlayerFromPosition_4 = TaphSupport.VisibleKiller(v92,v99,v2);]========]},{[========[
while l_Humanoid_1.Health > 0.125 and v99.PrimaryPart do]========],[========[
while v99.Parent and l_Humanoid_1.Health > 0.125 and v99.PrimaryPart do]========]},{[========[
if not v99 then]========],[========[
if not v99.Parent then]========]},{[========[
Duration = v92.Config.SubspaceEffectDuration - v119]========],[========[
Duration = math.max(0,v92.Config.SubspaceEffectDuration - v119)]========]},{[========[
Duration = v92.Config.SubspaceHelplessDuration - v119]========],[========[
Duration = math.max(0,v92.Config.SubspaceHelplessDuration - v119)]========]},{[========[
                                            v126.Player:SetAttribute("TaphSubspaced", os.clock());]========],[========[
                                            if not v126.Player:GetAttribute("Invincible") and (not v127 or v126.Player==v92.Rig)then
                                                local duration=math.max(0,v92.Config.SubspaceWeaknessDuration-v119);
                                                if duration>0 then v4:ApplyStatus(v126.Player,"Weakness",{Level=v92.Config.SubspaceWeaknessLevel,Duration=duration,TimeStackable=false})end;
                                            end;
                                            v126.Player:SetAttribute("TaphSubspaced", os.clock());]========]},{[========[
local v127 = v99:GetAttribute("RecentAttacker") == tostring(game.Players:GetPlayerFromCharacter(v126.Player));]========],[========[
local v127 = v126.Player~=v92.Rig and v99:GetAttribute("RecentAttacker") == tostring(game.Players:GetPlayerFromCharacter(v126.Player));]========]},{[========[
                                            v4:ApplyStatus(v126.Player, "Subspaced", {]========],[========[
                                            if v92.Config.SubspaceEffectDuration-v119>0 then v4:ApplyStatus(v126.Player, "Subspaced", {]========]},{[========[
Duration = math.max(0,v92.Config.SubspaceEffectDuration - v119)
                                            });]========],[========[
Duration = math.max(0,v92.Config.SubspaceEffectDuration - v119)
                                            });end;]========]},{[========[
if not v126.Player:GetAttribute("Invincible") and not v127 then]========],[========[
if not v126.Player:GetAttribute("Invincible") and not v127 and v92.Config.SubspaceHelplessDuration-v119>0 then]========]}}},
{path=[========[
ServerStorage/Assets/Survivors/Dusekkar/Config]========],edits={{[========[
SpawnProtectionCooldown = 30]========],[========[
SpawnProtectionCooldown = 35]========]},{[========[
SpawnProtectionTimeUntilProtectableAgain = 25]========],[========[
SpawnProtectionTimeUntilProtectableAgain = 30]========]},{[========[
PlasmaBeamCooldown = 30]========],[========[
PlasmaBeamCooldown = 28]========]},{[========[
PlasmaBeamOverheal = 30]========],[========[
PlasmaBeamOverheal = 25]========]},{[========[
PlasmaBeamSpeedData = {
        Level = 1, 
        Duration = 4]========],[========[
PlasmaBeamSpeedData = {
        Level = 1, 
        Duration = 3]========]},{[========[
PlasmaBeamSlownessData = {
        Level = 2, 
        Duration = 3]========],[========[
PlasmaBeamSlownessData = {
        Level = 1, 
        Duration = 4]========]},{[========[
inflicts them with <b>Slowness II</b>]========],[========[
inflicts them with <b>Slowness I</b>]========]}}},
{path=[========[
ServerStorage/Assets/Survivors/Dusekkar/Behavior]========],edits={{[========[
(#v88 - 1) * 0.5]========],[========[
math.max(0,v90) * 0.5]========]},{[========[
v47.PrimaryPart.Anchored and "TargetAnchored"]========],[========[
(v47.PrimaryPart.Anchored and not v47:GetAttribute("AzureGrabbed")) and "TargetAnchored"]========]},{[========[
Action = "Zapped a Survivor", 
                                                Money = 4, 
                                                EXP = 8]========],[========[
Action = "Zapped a Survivor", 
                                                Money = 4, 
                                                EXP = 8,
                                                KillerChance = 0.5]========]}}},
{path=[========[
ServerStorage/Assets/Killers/c00lkidd/Behavior]========],edits={{[========[
CorruptNature = {
        LayoutOrder = 2,
        Icon = "rbxassetid://81200466982776",
        KeybindType = "AltAbility1",
        Cooldown = 16]========],[========[
CorruptNature = {
        LayoutOrder = 2,
        Icon = "rbxassetid://81200466982776",
        KeybindType = "AltAbility1",
        Cooldown = 13]========]}}}}
local helperSource=[========[
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
]========]
local function find(path)
 local object=game
 for name in path:gmatch("[^/]+")do object=object:FindFirstChild(name);assert(object,"Missing "..path)end
 return object
end
local modules=game.ReplicatedStorage.Modules
local existing=modules:FindFirstChild("TaphSupport")
assert(not existing or(existing:IsA("ModuleScript")and existing.Source==helperSource),"Different TaphSupport helper exists. Nothing changed.")
local planned={}
for _,change in changes do
 change.object=find(change.path)
 change.before=change.object.Source
 local source=change.before
 for _,edit in change.edits do
  if not source:find(edit[2],1,true)then
   local first,last=source:find(edit[1],1,true)
   assert(first and not source:find(edit[1],last+1,true),"Unsupported or ambiguous code in "..change.path..". Nothing changed; send that module's current Source.")
   source=source:sub(1,first-1)..edit[2]..source:sub(last+1)
  end
 end
 change.after=source
 if source~=change.before then table.insert(planned,change)end
end
if #planned==0 and existing then print("Taph, Dusekkar and Corrupt Nature update already installed.");return end
local backup=Instance.new("Folder");backup.Name="TaphDusekkarBackup_"..os.time()
for i,change in planned do
 local saved=Instance.new("StringValue");saved.Name=tostring(i);saved.Value=change.before;saved.Parent=backup
 local target=Instance.new("ObjectValue");target.Name="Target";target.Value=change.object;target.Parent=saved
end
backup.Parent=game.ServerStorage
local helper=existing or Instance.new("ModuleScript")
local ok,err=pcall(function()
 if not existing then helper.Name="TaphSupport";helper.Source=helperSource;helper.Parent=modules end
 for _,change in planned do change.object.Source=change.after end
end)
if not ok then
 for _,change in planned do pcall(function()change.object.Source=change.before end)end
 if not existing then helper:Destroy()end
 error("Update failed; original Sources restored: "..tostring(err))
end
if not existing then local marker=Instance.new("ObjectValue");marker.Name="AddedHelper";marker.Value=helper;marker.Parent=backup end
print("Taph and Dusekkar updated; c00lkidd Corrupt Nature is 13s. Fifth Taph update excluded. Save and restart Play. Backup: "..backup:GetFullName())
