-- AZURE ENSTRANGLE UPDATE — 2026-11-08
-- Stop Play. Open the newest FCF place, then paste this ENTIRE file into
-- Studio's Command Bar and press Enter. No HTTP requests or downloads are used.
-- Targets ONLY Azure.Behavior, Azure.Config, and Behavior.sv_AzureConstruct.
-- Checks your source before editing. If it differs, NOTHING is changed.
-- All 16 supplied animation IDs are included; animation access still needs a Studio playtest.
-- Backup: ServerStorage.AzureEnstrangleBackup_<timestamp> (chunked full source).
-- To restore: set RESTORE_BACKUP below to that folder's exact name and run this file again.
-- Restore overwrites only the three backed-up modules with their pre-patch source.
-- Website/main branch are unaffected.
--
-- Includes: sprint/regen phases, animation-length-aware grab freeze + invincibility,
-- hold/manual/auto throw, NPC/reset/disconnect cleanup, 10 grab + 5 impact damage,
-- 20-stud knockdown, release-time Helpless, close-throw penalties, plant landing detection.
-- Plants keep their existing bloom, cooldown, ammunition, and QTE rules.
-- Validation: Luau compilation + mocked lifecycle tests; not a live Roblox playtest.
local RESTORE_BACKUP = nil
local RunService = game:GetService("RunService")
assert(not RunService:IsRunning(), "Stop Play before applying/restoring the Azure update.")
local editor = game:GetService("ScriptEditorService")
local storage = game:GetService("ServerStorage")
local azure = game:GetService("ReplicatedStorage").Assets.Killers.Azure
local function normalize(s) return (s:gsub("\r\n", "\n")) end
local function read(module) return editor:GetEditorSource(module) end
local function write(module, expected, updated)
    editor:UpdateSourceAsync(module, function(current)
        assert(current == expected, "Source changed while applying: " .. module:GetFullName())
        return updated
    end)
end
local function resolve(path)
    local node = azure
    for _, name in path do
        node = assert(node:FindFirstChild(name), "Missing Azure module: " .. name)
    end
    assert(node:IsA("ModuleScript"), "Expected ModuleScript: " .. node:GetFullName())
    return node
end
if RESTORE_BACKUP then
    local backup = assert(storage:FindFirstChild(RESTORE_BACKUP), "Backup folder not found")
    for _, entry in backup:GetChildren() do
        local path = string.split(entry:GetAttribute("ModulePath"), "/")
        local module = resolve(path)
        local parts = entry:GetChildren()
        table.sort(parts, function(a,b) return a.Name < b.Name end)
        local source = {}
        for _, part in parts do table.insert(source, part.Value) end
        write(module, read(module), table.concat(source))
    end
    print("Azure Enstrangle backup restored: " .. RESTORE_BACKUP)
    return
end
local function checksum(s)
    local a,b = 1,0
    for i=1,#s do a=(a+string.byte(s,i))%65521; b=(b+a)%65521 end
    return b*65536+a
end
local changes = {
{path={"Behavior"}, checksum=1100974274, edits={
{old=[=[

        for _, v in pairs(v730) do
            local v733 = v[1] - v[2];
            u685:PCallAllClients("GREP", CFrame.new(v[2], v[2] + (v733.Magnitude <= 0.001 and Vector3.new(0, 0, 1) or v733.Unit)) * CFrame.new((math.random() - 0.5) / 0.5 * 5 / 4, 0, -5), Vector3.new(5, 0, 10), false);
        end;
    end));
end;

function u77.Destroyed(p734, p735) -- Line: 5127
    -- upvalues: u1 (copy), __pcallMethod (copy), Network (copy)
    if p735.Destroyed then
        return;
    end;

    p735.Destroyed = true;

    if u1 then
        __pcallMethod("lcl_SetGolemSpawnAbilityLocks", p735, false);
        __pcallMethod("lcl_SetGrabAbilityLocks", p735, false);
        __pcallMethod("lcl_SetGrabStaminaRegenReduction", p735, false);
        __pcallMethod("lcl_ClearRemoveAllFlowers", p735);
    end;

    p735.Maid:Destroy();

    for i, v in p735.ConnectionDictionary do
        v:Disconnect();
        p735.NetworkConnections[i] = nil;
    end;

]=], new=[=[

        for _, v in pairs(v730) do
            local v733 = v[1] - v[2];
            u685:PCallAllClients("GREP", CFrame.new(v[2], v[2] + (v733.Magnitude <= 0.001 and Vector3.new(0, 0, 1) or v733.Unit)) * CFrame.new((math.random() - 0.5) / 0.5 * 5 / 4, 0, -5), Vector3.new(5, 0, 10), false);
        end;
    end));
end;

function u77.Destroyed(p734, p735) -- Line: 5127
    -- upvalues: u1 (copy), __pcallMethod (copy), Network (copy)
    if p735.Destroyed then
        return;
    end;

    p735.Destroyed = true;
    if u2 and p735.State and p735.State.AzureGrabCleanup then
        p735.State.AzureGrabCleanup();
    end;

    if u1 then
        __pcallMethod("lcl_SetGolemSpawnAbilityLocks", p735, false);
        __pcallMethod("lcl_SetGrabAbilityLocks", p735, false);
        __pcallMethod("lcl_SetGrabStaminaRegenReduction", p735, false);
        __pcallMethod("lcl_ClearRemoveAllFlowers", p735);
    end;

    p735.Maid:Destroy();

    for i, v in p735.ConnectionDictionary do
        v:Disconnect();
        p735.NetworkConnections[i] = nil;
    end;

]=]},
{old=[=[
            end;

            local v607 = RaycastParams.new();
            v607.RespectCanCollide = true;
            v607.CollisionGroup = "Killers";
            v607.FilterType = Enum.RaycastFilterType.Exclude;
            v607.FilterDescendantsInstances = { workspace.Players, v604 };
            u606 = Projectiles.new({
                Owner = u587.Player,
                Lifetime = v599,
                InitialCFrame = u587:GetPivot() * CFrame.new(0, 0, -v601),
                InitialVelocity = u587:GetPivot().LookVector * v603,
                Model = v604,
                CastParams = v607,
                HitboxConfig = {
                    Damage = 0,
                    Knockback = 0,
                    HitMultiple = false,
                    PredictVelocity = false,
                    ExecuteOnKill = false,
                    Size = v600,
                    Time = v599,
                    AbilityType = u77.Abilities.Grab.KeybindType,
                    Connections = {
                        Hit = function(p608, p609) -- Line: 3978, Name: Hit
                            -- upvalues: u605 (ref), u587 (copy), Util (ref), Sounds (ref), u594 (copy), u595 (copy), u606 (ref), __pcallMethod (ref)
                            if u605 or p608 == u587.Rig then
                                return;
                            end;

                            u605 = true;
]=], new=[=[
            end;

            local v607 = RaycastParams.new();
            v607.RespectCanCollide = true;
            v607.CollisionGroup = "Killers";
            v607.FilterType = Enum.RaycastFilterType.Exclude;
            v607.FilterDescendantsInstances = { workspace.Players, v604 };
            u606 = Projectiles.new({
                Owner = u587.Player,
                Lifetime = v599,
                InitialCFrame = u587:GetPivot() * CFrame.new(0, 0, -v601),
                InitialVelocity = u587:GetPivot().LookVector * v603,
                Model = v604,
                CastParams = v607,
                HitboxConfig = {
                    Damage = Grab.HitDamage,
                    Knockback = 0,
                    HitMultiple = false,
                    PredictVelocity = false,
                    ExecuteOnKill = false,
                    Size = v600,
                    Time = v599,
                    AbilityType = u77.Abilities.Grab.KeybindType,
                    Connections = {
                        Hit = function(p608, p609) -- Line: 3978, Name: Hit
                            -- upvalues: u605 (ref), u587 (copy), Util (ref), Sounds (ref), u594 (copy), u595 (copy), u606 (ref), __pcallMethod (ref)
                            if u605 or p608 == u587.Rig then
                                return;
                            end;

                            u605 = true;
]=]},
{old=[=[
            });
            v592.Parent = u587.Rig.PrimaryPart;
            Sounds:Play(u587.Config.Sounds.SlashWindup, v592);
            local v593 = Util:LoadAnimationFromID(u587.Rig, u587.Config.Animations.GrabWindup, false);
            local u594 = Util:LoadAnimationFromID(u587.Rig, u587.Config.Animations.GrabShootFailed, false);
            local u595 = Util:LoadAnimationFromID(u587.Rig, u587.Config.Animations.GrabShoot, false);
            v593:Play();

            local function grabInterrupted() -- Line: 3833
                -- upvalues: u587 (copy), Util (ref)
                return u587.State.GrabCancelRequested and true or ((not Util:IsAlive(u587.Rig) or u587.Rig:GetAttribute("Stunned")) and true or false);
            end;

            local v596 = os.clock();

            while os.clock() - v596 < 1 and (not u587.State.GrabCancelRequested and (Util:IsAlive(u587.Rig) and not u587.Rig:GetAttribute("Stunned"))) do
                task.wait();
            end;

            if u587.State.GrabCancelRequested and true or ((not Util:IsAlive(u587.Rig) or u587.Rig:GetAttribute("Stunned")) and true or false) then
                local GrabCancelRequested = u587.State.GrabCancelRequested;
                u587.AbilitiesDisabled = false;
                u587.DisabledAbilities = {};
                u587.State.GrabWindingUp = false;
                setAzureWindupTransparency(0);
                u587:PCallLocal("EndGrabAiming");
                u587:PCallLocal("EndGrabAimingBeamEffect");
                v593:Stop();
                u595:Stop();
                u594:Stop();

                if GrabCancelRequested then
                    u587:SetCooldownOf("Grab", Grab.CooldownCancel or Grab.CooldownMiss);

                    return;
                end;

                __pcallMethod("sv_MissGrab", u587);

                return;
            end;

            u587.State.GrabReadyToFire = true;
            u587.DisabledAbilities = {
                Sow = true,
                Blossom = true,
                Unravel = true
            };
            local v597 = Util:LoadAnimationFromID(u587.Rig, u587.Config.Animations.GrabWindupIdle, false);
            v593:Stop();
            v597:Play();

            while not u587.State.GrabFireRequested and (not u587.State.GrabCancelRequested and (Util:IsAlive(u587.Rig) and not u587.Rig:GetAttribute("Stunned"))) do
                task.wait();
            end;

            v597:Stop();
            u587.State.GrabReadyToFire = false;

            if u587.State.GrabCancelRequested and true or ((not Util:IsAlive(u587.Rig) or u587.Rig:GetAttribute("Stunned")) and true or false) then
                local GrabCancelRequested = u587.State.GrabCancelRequested;
                u587.AbilitiesDisabled = false;
                u587.DisabledAbilities = {};
                u587.State.GrabWindingUp = false;
                setAzureWindupTransparency(0);
                u587:PCallLocal("EndGrabAiming");
                u587:PCallLocal("EndGrabAimingBeamEffect");
                v593:Stop();
                v597:Stop();
                u595:Stop();
                u594:Stop();

                if GrabCancelRequested then
                    u587:SetCooldownOf("Grab", Grab.CooldownCancel or Grab.CooldownMiss);

                    return;
                end;

                __pcallMethod("sv_MissGrab", u587);

                return;
            end;

            u587.State.GrabWindingUp = false;
            u587.AbilitiesDisabled = true;
            setAzureWindupTransparency(0);
            u587:PCallLocal("EndGrabAiming");
]=], new=[=[
            });
            v592.Parent = u587.Rig.PrimaryPart;
            Sounds:Play(u587.Config.Sounds.SlashWindup, v592);
            local v593 = Util:LoadAnimationFromID(u587.Rig, u587.Config.Animations.GrabWindup, false);
            local u594 = Util:LoadAnimationFromID(u587.Rig, u587.Config.Animations.GrabShootFailed, false);
            local u595 = Util:LoadAnimationFromID(u587.Rig, u587.Config.Animations.GrabShoot, false);
            v593:Play();

            local function grabInterrupted() -- Line: 3833
                -- upvalues: u587 (copy), Util (ref)
                return u587.State.GrabCancelRequested and true or ((not Util:IsAlive(u587.Rig) or u587.Rig:GetAttribute("Stunned")) and true or false);
            end;

            local v596 = os.clock();

            while os.clock() - v596 < Grab.Windup and (not u587.State.GrabCancelRequested and (Util:IsAlive(u587.Rig) and not u587.Rig:GetAttribute("Stunned"))) do
                task.wait();
            end;

            if u587.State.GrabCancelRequested and true or ((not Util:IsAlive(u587.Rig) or u587.Rig:GetAttribute("Stunned")) and true or false) then
                local GrabCancelRequested = u587.State.GrabCancelRequested;
                u587.AbilitiesDisabled = false;
                u587.DisabledAbilities = {};
                u587.State.GrabWindingUp = false;
                setAzureWindupTransparency(0);
                u587:PCallLocal("EndGrabAiming");
                u587:PCallLocal("EndGrabAimingBeamEffect");
                v593:Stop();
                u595:Stop();
                u594:Stop();

                Network:FireClientConnection(u587.Player, "DisableSprintingSV", "REMOTE_EVENT", "AzureGrab", false);
                u587:PCallLocal("SetGrabStaminaRegenReduction", false);
                u587:PCallLocal("SetGrabAbilityLocks", false);
                if GrabCancelRequested then
                    u587:SetCooldownOf("Grab", Grab.CooldownCancel or Grab.CooldownMiss);

                    return;
                end;

                __pcallMethod("sv_MissGrab", u587);

                return;
            end;

            u587.State.GrabReadyToFire = true;
            u587:PCallLocal("SetGrabAbilityLocks", true, false);
            u587.DisabledAbilities = {
                Sow = true,
                Blossom = true,
                Unravel = true
            };
            local v597 = Util:LoadAnimationFromID(u587.Rig, u587.Config.Animations.GrabWindupIdle, false);
            v593:Stop();
            v597:Play();

            while not u587.State.GrabFireRequested and (not u587.State.GrabCancelRequested and (Util:IsAlive(u587.Rig) and not u587.Rig:GetAttribute("Stunned"))) do
                task.wait();
            end;

            v597:Stop();
            u587.State.GrabReadyToFire = false;

            if u587.State.GrabCancelRequested and true or ((not Util:IsAlive(u587.Rig) or u587.Rig:GetAttribute("Stunned")) and true or false) then
                local GrabCancelRequested = u587.State.GrabCancelRequested;
                u587.AbilitiesDisabled = false;
                u587.DisabledAbilities = {};
                u587.State.GrabWindingUp = false;
                setAzureWindupTransparency(0);
                u587:PCallLocal("EndGrabAiming");
                u587:PCallLocal("EndGrabAimingBeamEffect");
                v593:Stop();
                v597:Stop();
                u595:Stop();
                u594:Stop();

                Network:FireClientConnection(u587.Player, "DisableSprintingSV", "REMOTE_EVENT", "AzureGrab", false);
                u587:PCallLocal("SetGrabStaminaRegenReduction", false);
                u587:PCallLocal("SetGrabAbilityLocks", false);
                if GrabCancelRequested then
                    u587:SetCooldownOf("Grab", Grab.CooldownCancel or Grab.CooldownMiss);

                    return;
                end;

                __pcallMethod("sv_MissGrab", u587);

                return;
            end;

            u587.State.GrabWindingUp = false;
            u587.AbilitiesDisabled = true;
            setAzureWindupTransparency(0);
            u587:PCallLocal("EndGrabAiming");
]=]},
{old=[=[
            if u587.State.ControllingGolem then
                return nil;
            end;

            u587.AbilitiesDisabled = false;
            u587.DisabledAbilities = {
                Slash = true,
                Sow = true,
                Blossom = true,
                Unravel = true
            };
            u587.State.GrabWindingUp = true;
            u587.State.GrabCancelRequested = false;
            u587.State.GrabFireRequested = false;
            u587.State.GrabReadyToFire = false;

            local function setAzureWindupTransparency(p589) -- Line: 3794
                -- upvalues: u587 (copy)
                for _, descendant in ipairs(u587.Rig:GetDescendants()) do
                    if descendant:IsA("BasePart") or descendant:IsA("Decal") then
                        if p589 ~= 0 and descendant:GetAttribute("OGWindupTransparency") == nil then
                            descendant:SetAttribute("OGWindupTransparency", descendant.Transparency);
                        end;

                        if p589 == 0 then
                            local v590 = descendant:GetAttribute("OGWindupTransparency");

                            if v590 ~= nil then
                                descendant.Transparency = v590;
                                descendant:SetAttribute("OGWindupTransparency", nil);
]=], new=[=[
            if u587.State.ControllingGolem then
                return nil;
            end;

            u587.AbilitiesDisabled = false;
            u587.DisabledAbilities = {
                Slash = true,
                Sow = true,
                Blossom = true,
                Unravel = true
            };
            u587.State.GrabWindingUp = true;
            u587.State.GrabCancelRequested = false;
            u587.State.GrabFireRequested = false;
            u587.State.GrabReadyToFire = false;
            Network:FireClientConnection(u587.Player, "DisableSprintingSV", "REMOTE_EVENT", "AzureGrab", true);
            u587:PCallLocal("SetGrabStaminaRegenReduction", true);
            u587:PCallLocal("SetGrabAbilityLocks", true, true);

            local function setAzureWindupTransparency(p589) -- Line: 3794
                -- upvalues: u587 (copy)
                for _, descendant in ipairs(u587.Rig:GetDescendants()) do
                    if descendant:IsA("BasePart") or descendant:IsA("Decal") then
                        if p589 ~= 0 and descendant:GetAttribute("OGWindupTransparency") == nil then
                            descendant:SetAttribute("OGWindupTransparency", descendant.Transparency);
                        end;

                        if p589 == 0 then
                            local v590 = descendant:GetAttribute("OGWindupTransparency");

                            if v590 ~= nil then
                                descendant.Transparency = v590;
                                descendant:SetAttribute("OGWindupTransparency", nil);
]=]},
{old=[=[
        __playSound(p294, "BuildDenied", {
            Parent = workspace
        });
    end;

    function u77.lcl_SetGolemSpawnAbilityLocks(p296, p297, u298) -- Line: 1933
        -- upvalues: Util (copy)
        task.defer(function() -- Line: 1935
            -- upvalues: Util (ref), u298 (copy)
            for _, v in ipairs({ "Slash", "Sow", "Blossom", "Unravel" }) do
                Util:ToggleLockForAbilityIcon(v, "GolemSpawn", u298);
            end;
        end);
    end;

    function u77.lcl_SetGrabAbilityLocks(p299, p300, u301) -- Line: 1947
        -- upvalues: Util (copy)
        task.defer(function() -- Line: 1949
            -- upvalues: Util (ref), u301 (copy)
            for _, v in ipairs({ "Sow", "Blossom", "Unravel" }) do
                Util:ToggleLockForAbilityIcon(v, "AzureGrab", u301);
            end;
        end);
    end;

    function u77.lcl_SetGrabStaminaRegenReduction(p302, p303, p304) -- Line: 1961
        -- upvalues: Sprinting (copy)
        if p304 then
            if p303.Cache.AzureGrabStaminaGain == nil then
                p303.Cache.AzureGrabStaminaGain = Sprinting.StaminaGain or 20;
            end;

            Sprinting.StaminaGain = p303.Cache.AzureGrabStaminaGain * 0.25;
        elseif p303.Cache.AzureGrabStaminaGain ~= nil then
            Sprinting.StaminaGain = p303.Cache.AzureGrabStaminaGain;
            p303.Cache.AzureGrabStaminaGain = nil;
        end;
]=], new=[=[
        __playSound(p294, "BuildDenied", {
            Parent = workspace
        });
    end;

    function u77.lcl_SetGolemSpawnAbilityLocks(p296, p297, u298) -- Line: 1933
        -- upvalues: Util (copy)
        task.defer(function() -- Line: 1935
            -- upvalues: Util (ref), u298 (copy)
            for _, v in ipairs({ "Slash", "Sow", "Blossom", "Unravel" }) do
                Util:ToggleLockForAbilityIcon(v, "GolemSpawn", u298);
            end;
        end);
    end;

    function u77.lcl_SetGrabAbilityLocks(p299, p300, u301, lockSlash) -- Line: 1947
        -- upvalues: Util (copy)
        task.defer(function() -- Line: 1949
            -- upvalues: Util (ref), u301 (copy)
            for _, v in ipairs({ "Sow", "Blossom", "Unravel" }) do
                Util:ToggleLockForAbilityIcon(v, "AzureGrab", u301);
            end;
            Util:ToggleLockForAbilityIcon("Slash", "AzureGrab", u301 and lockSlash == true);
        end);
    end;

    function u77.lcl_SetGrabStaminaRegenReduction(p302, p303, p304) -- Line: 1961
        -- upvalues: Sprinting (copy)
        if p304 then
            if p303.Cache.AzureGrabStaminaGain == nil then
                p303.Cache.AzureGrabStaminaGain = Sprinting.StaminaGain or 20;
            end;

            Sprinting.StaminaGain = p303.Cache.AzureGrabStaminaGain * 0.25;
        elseif p303.Cache.AzureGrabStaminaGain ~= nil then
            Sprinting.StaminaGain = p303.Cache.AzureGrabStaminaGain;
            p303.Cache.AzureGrabStaminaGain = nil;
        end;
]=]},
{old=[=[

        p171:SetCooldownOf("Unravel", p171.Config.Golem.TransferCooldown or (p171.Config.GolemTransferCooldown or 3));
        __pcallMethod("sv_ToggleAzureVisible", p171, true);
        local v176 = Util:CopyTable({
            Volume = 0.35,
            PlaybackSpeed = 0.975 + Random.new():NextNumber() * 0.04999999999999993
        });
        v176.Parent = p171.Rig.PrimaryPart;
        Sounds:Play(p171.Config.Sounds.GolemAzureReturn, v176);

        for _, v in pairs(p171.State.RootDistances) do
            v.Origin = p171:GetPivot().Position;
        end;
    end;

    function u77.sv_GrabSurvivor(p177, u178, u179) -- Line: 932
        -- upvalues: Util (copy), __pcallMethod (copy), __playSound (copy), Sounds (copy), RunService (copy), TweenService (copy), Network (copy), Ragdolls (copy), Statuses (copy), Hitboxes (copy), Actors (copy), spawn (copy)
        if u178.State.GrabbingFlag then
            u178.AbilitiesDisabled = false;
            u178.DisabledAbilities = {};

            return;
        end;

        u178.State.GrabbingFlag = true;
        u178.State.ThrowRequest = nil;
        local Grab = u178.Config.Grab;
        local u180 = Util:GetActor(u179);

        if u180 and u180.GetPivot then
            u180:GetPivot();
        else
            u179:GetPivot();
        end;

        __pcallMethod("sv_OnMeleeHit", u178, u179);
        Util:CreateSpeedMultiplier(u179, 0, "AzureGrab");
        Util:GiveStackableAttribute(u179, "Airborne", "AzureGrab");
        u179:SetAttribute("AzureGrabbed", true);

        if u180 then
            u180:DisableAbilities("AzureGrabbing", true);
        end;

        local v181 = 0;

        for _, child in u179:GetChildren() do
            if child:IsA("BasePart") then
                v181 = v181 + child:GetMass();
            end;
        end;

        __playSound(u178, "Grabbed", {
            Parent = u179.PrimaryPart
        });
        local v182 = Util:CopyTable({
            Volume = 0.35,
            PlaybackSpeed = 0.975 + Random.new():NextNumber() * 0.04999999999999993
        });
        v182.Parent = u178.Rig.PrimaryPart;
        Sounds:Play(u178.Config.Sounds.Grab, v182);
        u178:PlayVoiceline("GrabHit", {
            Priority = 2
        });
        local u183 = Util:LoadAnimationFromID(u178.Rig, u178.Config.Animations.GrabThrow, false);
        local u184 = Util:LoadAnimationFromID(u179, u178.Config.Animations.GrabVictimThrow, false);
        local v185 = Util:LoadAnimationFromID(u178.Rig, u178.Config.Animations.GrabShootSuccess, false);
        local v186 = Util:LoadAnimationFromID(u179, u178.Config.Animations.GrabVictimSuccess, false);
        local u187 = Util:LoadAnimationFromID(u179, u178.Config.Animations.GrabVictimIdle, false);
        local u188 = Util:LoadAnimationFromID(u179, u178.Config.Animations.GrabVictimWalk, false);
        v185:Play(0.025);
        v186:Play(0.025);
        u179.Humanoid.PlatformStand = true;
        local u189 = {};

        for _, descendant in pairs(u179:GetDescendants()) do
            if descendant:IsA("BasePart") then
                u189[descendant] = descendant.Massless;
                descendant.Massless = true;
            end;
        end;

        local u190 = {};

        for _, descendant in ipairs(u179:GetDescendants()) do
            if descendant:IsA("BasePart") then
                u190[descendant] = descendant.CanCollide;
                descendant.CanCollide = false;
            end;
        end;

        local Attachment = Instance.new("Attachment", u178.Rig.PrimaryPart);
        local Attachment2 = Instance.new("Attachment", u179.PrimaryPart);
        local AlignPosition = Instance.new("AlignPosition");
        AlignPosition.Attachment0 = Attachment2;
        AlignPosition.Attachment1 = Attachment;
        AlignPosition.Responsiveness = 200;
        AlignPosition.RigidityEnabled = true;
        AlignPosition.Parent = u179.PrimaryPart;
        local AlignOrientation = Instance.new("AlignOrientation");
        AlignOrientation.Attachment0 = Attachment2;
        AlignOrientation.Attachment1 = Attachment;
        AlignOrientation.Responsiveness = 200;
        AlignOrientation.RigidityEnabled = true;
        AlignOrientation.Parent = u179.PrimaryPart;
        local u191 = {
            Attachment,
            Attachment2,
            AlignPosition,
            AlignOrientation
        };

        local function destroyGrabConstraints() -- Line: 1034
            -- upvalues: u191 (copy)
            for _, v in ipairs(u191) do
                if v and v.Parent then
                    v:Destroy();
                end;
            end;
        end;

        local u192 = CFrame.new(0, 0, -3);
        local Position = u179.PrimaryPart.Position;
        Attachment.CFrame = u178.Rig.PrimaryPart.CFrame:ToObjectSpace(CFrame.new(Position));
        pcall(function() -- Line: 1048
            -- upvalues: u179 (copy), u178 (copy)
            u179.PrimaryPart:SetNetworkOwner(u178.Player);
        end);
        u179:SetAttribute("IgnoreNoclip", true);
        local u193 = Util:LoadAnimationFromID(u178.Rig, u178.Config.Animations.GrabPullingLoop, false);
        local u194 = Util:LoadAnimationFromID(u178.Rig, u178.Config.Animations.GrabIdle, false);
        local u195 = Util:LoadAnimationFromID(u178.Rig, u178.Config.Animations.GrabWalk, false);
        local u196 = Util:LoadAnimationFromID(u178.Rig, u178.Config.Animations.GrabRun, false);
        local u197 = nil;
        local u198 = Util:LoadAnimationFromID(u179, u178.Config.Animations.GrabVictimHooked, false);
        local u199 = Util:LoadAnimationFromID(u179, u178.Config.Animations.GrabVictimIdle, false);
        local u200 = Util:LoadAnimationFromID(u179, u178.Config.Animations.GrabVictimWalk, false);
        local u201 = Util:LoadAnimationFromID(u179, u178.Config.Animations.GrabVictimRun, false);
        local u202 = nil;
        u198:Play();
        u193:Play();
        local u203 = false;
        local u204 = os.clock();
        local u212 = RunService.Heartbeat:Connect(function() -- Line: 1071
            -- upvalues: u178 (copy), u204 (copy), u192 (copy), TweenService (ref), Position (copy), Attachment (copy), u203 (ref), u193 (copy), u194 (copy), u199 (copy), u196 (copy), u195 (copy), u197 (ref), u201 (copy), u200 (copy), u202 (ref)
            if not (u178.Rig and u178.Rig.PrimaryPart) then
                return;
            end;

            local v205 = os.clock() - u204;
            local v206 = u178.Rig.PrimaryPart.CFrame * u192;

            if v205 < 0.7 then
                local v207 = TweenService:GetValue(math.clamp(v205 / 0.7, 0, 1), Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut);
                local v208 = Position:Lerp(v206.Position, v207);
                local v209 = CFrame.new(v208, v208 + v206.LookVector);
                Attachment.CFrame = u178.Rig.PrimaryPart.CFrame:ToObjectSpace(v209);

                return;
            end;

            Attachment.CFrame = u192;

            if not u203 then
                u203 = true;
                u193:Stop();
                u194:Play();
                u199:Play();
            end;

            local Magnitude = u178.Rig.PrimaryPart.AssemblyLinearVelocity.Magnitude;
            local v210 = nil;

            if Magnitude > 12 then
                v210 = u196;
            elseif Magnitude > 1 then
                v210 = u195;
            end;

            if v210 ~= u197 then
                if u197 then
                    u197:Stop();
                else
                    u194:Stop();
                end;

                if v210 then
                    v210:Play();
                else
                    u194:Play();
                end;

                u197 = v210;
            end;

            local v211 = nil;

            if Magnitude > 12 then
                v211 = u201;
            elseif Magnitude > 1 then
                v211 = u200;
            end;

            if v211 ~= u202 then
                if u202 then
                    u202:Stop();
                else
                    u199:Stop();
                end;

                if v211 then
                    v211:Play();
                else
                    u199:Play();
                end;

                u202 = v211;
            end;
        end);
        local u213 = false;
        v185.Stopped:Once(function() -- Line: 1149
            -- upvalues: u213 (ref)
            u213 = true;
        end);

        local vGrabSuccessDeadline = os.clock() + math.clamp(v185.Length + 0.75, 0.75, 3);

		while u213 == false
			and os.clock() < vGrabSuccessDeadline
			and Util:IsAlive(u178.Rig)
			and Util:IsAlive(u179)
			and u179:IsDescendantOf(workspace)
			and not u178.Rig:GetAttribute("Stunned")
		do
            task.wait();
        end;

        if (not Util:IsAlive(u178.Rig) or u178.Rig:GetAttribute("Stunned")) and true or false or (Util:IsAlive(u178.Rig) == false or Util:IsAlive(u179) == false) then
            u178:SetCooldownOf("Grab", u178.Config.Grab.CooldownMiss);
            u178.State.GrabbingFlag = false;
            Util:CreateSpeedMultiplier(u179, 1, "AzureGrab", 0);
            Util:RemoveStackableAttribute(u179, "Airborne", "AzureGrab");                pcall(function()
                    if u179.PrimaryPart then
                        u179.PrimaryPart:SetNetworkOwnershipAuto();
                    end;
                end);

            if u180 then
                u180:DisableAbilities("AzureGrabbing", false);
            end;

            v185:Stop();
            v186:Stop();
            u212:Disconnect();
            destroyGrabConstraints();
            u193:Stop();
            u194:Stop();
            u195:Stop();
            u196:Stop();
            u198:Stop();
            u199:Stop();
            u200:Stop();
            u201:Stop();

            if u179 and u179.PrimaryPart then
                u179.PrimaryPart.Anchored = false;
            end;

            for i, v in pairs(u190) do
                if i and i.Parent then
                    i.CanCollide = v;
                end;
            end;

            Network:FireClientConnection(u178.Player, "DisableSprintingSV", "REMOTE_EVENT", "AzureGrab", false);
            u178.AbilitiesDisabled = false;
            u178.DisabledAbilities = {};
            pcall(function() -- Line: 1208
                -- upvalues: u179 (copy), u189 (copy)
                u179:SetAttribute("AzureGrabbed", nil);
                u179:SetAttribute("IgnoreNoclip", nil);

                for i, v in pairs(u189) do
                    if i and i.Parent then
                        i.Massless = v;
                    end;
                end;

                u179.Humanoid.PlatformStand = false;
            end);

            return;
        end;

        u178.AbilitiesDisabled = false;
        u178.DisabledAbilities = {
            Sow = true,
            Blossom = true,
            Unravel = true
        };
        u178:SetCooldownOf("Slash", 0);
        u178:SetCooldownOf("Grab", 0);
        u178:PCallLocal("SetGrabAbilityLocks", true);
        u178.Rig:SetAttribute("MoveAnimationOverwrite", "Grab");
        u187:Play();

        local grabDetached = false;
        local function u214() -- Line: 1234
        end;

        local u216 = RunService.Heartbeat:Connect(function() -- Line: 1237
            -- upvalues: u178 (copy), u187 (copy), u188 (copy)
            local u215 = 0;
            pcall(function() -- Line: 1241
                -- upvalues: u215 (ref), u178 (ref)
                u215 = u178.Rig.PrimaryPart.AssemblyLinearVelocity.Magnitude;
            end);

            if u215 > 0.03 then
                if u187.IsPlaying == true then
                    u187:Stop();
                end;

                if u188.IsPlaying == false then
                    u188:Play();
                end;
            else
                if u187.IsPlaying == false then
                    u187:Play();
                end;

                if u188.IsPlaying == true then
                    u188:Stop();
                end;
            end;
        end);
        local u217 = RunService.Heartbeat:Connect(function() -- Line: 1264
            -- upvalues: Util (ref), u179 (copy), u214 (ref), u178 (copy)
            if Util:IsAlive(u179) ~= true then
                u214();
            end;

            if Util:IsAlive(u178.Rig) ~= true then
                u214();
            end;
        end);

        u214 = function() -- Line: 1275, Name: u292
            if grabDetached then return end;
            grabDetached = true;
            -- upvalues: u216 (copy), u217 (copy), u212 (copy), destroyGrabConstraints (copy), u193 (copy), u194 (copy), u195 (copy), u196 (copy), u198 (copy), u199 (copy), u200 (copy), u201 (copy), u179 (copy), u190 (copy), u187 (copy), u188 (copy), u189 (copy), u178 (copy)
            u216:Disconnect();
            u217:Disconnect();
            u212:Disconnect();
            destroyGrabConstraints();
            u193:Stop();
            u194:Stop();
            u195:Stop();
            u196:Stop();
            u198:Stop();
            u199:Stop();
            u200:Stop();
            u201:Stop();

            if u179 and u179.PrimaryPart then
                u179.PrimaryPart.Anchored = false;
            end;

            for i, v in pairs(u190) do
                if i and i.Parent then
                    i.CanCollide = v;
                end;
            end;

            u187:Stop();
            u188:Stop();

            if u179 then
                if u179:FindFirstChild("Humanoid") then
                    u179.Humanoid.PlatformStand = false;
                end;

                u179:SetAttribute("IgnoreNoclip", nil);

                for i, v in pairs(u189) do
                    if i and i.Parent then
                        i.Massless = v;
                    end;
                end;
            end;

            if u178 and u178.Rig then
                u178.Rig:SetAttribute("MoveAnimationOverwrite", nil);
            end;

            if u178 and u178.DisabledAbilities then
                u178.DisabledAbilities.Sow = nil;
                u178.DisabledAbilities.Blossom = nil;
                u178.DisabledAbilities.Unravel = nil;
            end;
        end;

        local v218 = Util:CopyTable({
            Volume = 0.35,
            PlaybackSpeed = 0.975 + Random.new():NextNumber() * 0.04999999999999993
        });
        v218.Parent = u178.Rig.PrimaryPart;
        Sounds:Play(u178.Config.Sounds.GrabThrow, v218);
        Network:FireClientConnection(u178.Player, "SetTrackingMousePosition", "REMOTE_EVENT");
        u178:PCallAllClients("OnHomingStart");
		u178:PCallLocal("OnHomingStart");
		u178.State.ThrowRequest = false;
		local v219 = os.clock();

			while os.clock() - v219 <= u178.Config.Grab.HoldMaxDuration and (u178.State.ThrowRequest ~= true and (Util:IsAlive(u178.Rig) ~= false and (Util:IsAlive(u179) ~= false and u179:IsDescendantOf(workspace)))) and ((not Util:IsAlive(u178.Rig) or u178.Rig:GetAttribute("Stunned")) and true or false) ~= true do
            task.wait();
        end;

        u178.State.ThrowRequest = nil;
        u178:PCallAllClients("OnHomingStopped");
        u178:PCallLocal("OnHomingStopped");

        if Util:IsAlive(u178.Rig) and not u178.Rig:GetAttribute("Stunned") and (Util:IsAlive(u178.Rig) ~= false and Util:IsAlive(u179) ~= false) then
            local function throw(p220) -- Line: 1427
                -- upvalues: destroyGrabConstraints (copy), Util (ref), u179 (copy), Ragdolls (ref), Grab (copy), u178 (copy), Sounds (ref), __playSound (ref), u189 (copy), Statuses (ref), u180 (copy), Hitboxes (ref), Actors (ref), TweenService (ref), RunService (ref)
                destroyGrabConstraints();

                if Util:IsAlive(u179) then
                    Ragdolls.EnableRagdoll(u179);
                end;

                local PrimaryPart = u179.PrimaryPart;
                pcall(function() PrimaryPart:SetNetworkOwner(nil) end);
                local u221 = p220 * Grab.ThrowVelocity;
                PrimaryPart.AssemblyLinearVelocity = u221;
                local u222 = os.clock();
                local u223 = RaycastParams.new();
                u223.FilterDescendantsInstances = { workspace.Players };
                u223.CollisionGroup = workspace:GetAttribute("FriendlyFire") and "Default" or "Survivors";
                u223.RespectCanCollide = true;
                local v224 = u178;
                local v225 = Util:CopyTable({
                    Volume = 0.35,
                    PlaybackSpeed = 0.975 + Random.new():NextNumber() * 0.04999999999999993
                });
                v225.Parent = v224.Rig.PrimaryPart;
                Sounds:Play(v224.Config.Sounds.GrabThrow, v225);
                __playSound(u178, "GrabThrown", {
                    Parent = u179.PrimaryPart
                });
                u178:PlayVoiceline("GrabThrow", {
                    Priority = 2
                });
                local v226 = u178.Config.Instances.ThrowTrailVFX:Clone();
                local u227 = {};
                local u228 = nil;

                for _, child in ipairs(v226:GetChildren()) do
                    child.Parent = u179:FindFirstChild("Torso") or u179.PrimaryPart;
                    table.insert(u227, child);
                end;

                u178:PCallAllClients("OnThrown", u179);

                local throwEnded = false;
                local function endThrow(p229, p230) -- Line: 1475
                    -- upvalues: u227 (copy), u178 (ref), u179 (ref), u189 (ref), Grab (ref), Statuses (ref), u228 (ref), Util (ref), u180 (ref), __playSound (ref), Ragdolls (ref), Hitboxes (ref), Actors (ref), TweenService (ref)
                    if throwEnded then return end;
                    throwEnded = true;
                    if u228 then u228:Disconnect(); u228 = nil end;
                    for _, v in ipairs(u227 or {}) do
                        v:Destroy();
                    end;

                    u178.State.GrabbingFlag = nil;

                    if u179 then
                        u179:SetAttribute("AzureGrabbed", nil);
                        u179:SetAttribute("IgnoreNoclip", nil);

                        for i, v in pairs(u189) do
                            if i and i.Parent then
                                i.Massless = v;
                            end;
                        end;
                    end;

                    local v231 = Grab.CloseThrowDistance or 20;
                    local v232;

                    if p230 and (u178.Rig and u178.Rig.PrimaryPart) then
                        v232 = (p230.Position - u178.Rig.PrimaryPart.Position).Magnitude <= v231;
                    else
                        v232 = false;
                    end;

                    local v233 = v232 and 4 or 2;

                    if v232 then
                        Statuses:ApplyStatus(u178.Rig, "Slowness", {
                            Level = 2,
                            Duration = 2
                        });
                    end;

                    Statuses:ApplyStatus(u178.Rig, "Helpless", {
                        Level = 1,
                        Duration = v233
                    });
                    task.delay(0.65, function() -- Line: 1513
                        -- upvalues: u178 (ref)
                        u178.AbilitiesDisabled = false;
                        u178.DisabledAbilities = {};
                    end);
                    task.delay(v233, function() -- Line: 1518
                        -- upvalues: u178 (ref)
                        u178:PCallLocal("SetGrabAbilityLocks", false);
                    end);
                    u178:PCallLocal("SetGrabStaminaRegenReduction", false);

                    if u228 then
                        u228:Disconnect();
                    end;

                    if Util:IsAlive(u179) then
                        Util:CreateSpeedMultiplier(u179, 1, "AzureGrab", 0);
                        Util:RemoveStackableAttribute(u179, "Airborne", "AzureGrab");                pcall(function()
                    if u179.PrimaryPart then
                        u179.PrimaryPart:SetNetworkOwnershipAuto();
                    end;
                end);

                        if u180 then
                            u180:DisableAbilities("AzureGrabbing", false);
                        end;

                        if p230 then
                            local Position2 = p230.Position;
                            local Normal = p230.Normal;
                            local Instance2 = p230.Instance;
                            local Unit = p229.Unit;
                            local Unit2 = Normal.Unit;
                            local v234 = (Unit - 2 * Unit:Dot(Unit2) * Unit2) / 4;
                            __playSound(u178, "GrabImpact", {
                                RollOffMaxDistance = 300,
                                Position = Position2
                            });
                            local v235 = u178.Config.Instances.SlamVFX:Clone();
                            v235.Parent = workspace.Terrain;
                            v235.CFrame = CFrame.new(Position2, Position2 + Normal) * CFrame.Angles(1.5707963267948966, 0, 0);
                            game.Debris:AddItem(v235, 4);
                            Util:EmitParticles(v235);
                            local v236 = CFrame.new(Position2 + Normal * 2);

                            if u180 then
                                u180:PivotTo(v236);
                            else
                                u179:PivotTo(v236);
                            end;

                            Ragdolls.AddProfile(u179, {
                                Velocity = v234
                            });
                            Ragdolls.EnableRagdoll(u179, u178.Config.Grab.RagdollDuration);
                            u179.PrimaryPart.AssemblyLinearVelocity = v234;
                            u178:PCallAllClients("OnGroundExplode", Position2, Instance2);
                            Hitboxes:CreateHitbox(u178.Player, {
                                Time = 0.05,
                                Knockback = false,
                                HitMultiple = true,
                                ExecuteOnKill = false,
                                Size = Vector3.new(1, 1, 1) * Grab.BlastRadius * 2,
                                Shape = Enum.PartType.Ball,

                                Damage = function(p237) -- Line: 1577, Name: Damage
                                    -- upvalues: u179 (ref), u178 (ref), Actors (ref), Grab (ref), Util (ref), TweenService (ref)
                                    if p237 == u179 then
                                        Actors:IncrementActorStats(u178.Player, {
                                            Action = "Threw Survivor",
                                            RewardType = "EasyKillerAction"
                                        });

                                        return Grab.Damage;
                                    end;

                                    if tostring(p237.Parent) == "Survivors" then
                                        Actors:IncrementActorStats(u178.Player, {
                                            Action = "Threw Survivor into Survivor",
                                            RewardType = "EasyKillerAction"
										});
									else
										Actors:IncrementActorStats(u178.Player, {
											Action = "Threw Survivor into Killer",
											RewardType = "EasyKillerAction"
										});
                                    end;

                                    local v238 = Util:GetActor(p237);
                                    local v239;

                                    if v238 and v238.GetPivot then
                                        v239 = v238:GetPivot();
                                    else
                                        v239 = p237:GetPivot();
                                    end;

                                    local v240 = 1 - (u178:GetPivot().Position - v239.Position).Magnitude / Grab.BlastRadius;
                                    local v241 = TweenService:GetValue(math.clamp(v240, 0, 1), Enum.EasingStyle.Quint, Enum.EasingDirection.Out);

                                    return Grab.Damage * v241;
                                end,

                                CFrame = CFrame.new(Position2),
                                Connections = {
                                    Hit = function(p242) -- Line: 1608, Name: Hit
                                        -- upvalues: u179 (ref), Util (ref), u178 (ref), Grab (ref), Ragdolls (ref)
                                        if p242 == u179 then
                                            return;
                                        end;

                                        local v243 = Util:GetActor(p242);
                                        local v244;

                                        if v243 and v243.GetPivot then
                                            v244 = v243:GetPivot();
                                        else
                                            v244 = p242:GetPivot();
                                        end;

                                        local Unit3 = (v244.Position - u178:GetPivot().Position).Unit;
                                        local v245 = (Vector3.new(Unit3.X, 0, Unit3.Z) + Vector3.new(0, 0.6, 0)) * Grab.KnockbackPower;
                                        p242.PrimaryPart.AssemblyLinearVelocity = v245;
                                        Ragdolls.AddProfile(p242, {
                                            Velocity = v245
                                        });
                                        Ragdolls.EnableRagdoll(p242, u178.Config.Grab.RagdollDuration);
                                    end
                                }
                            });
                        else
                            Ragdolls.EnableRagdoll(u179, u178.Config.Grab.RagdollDuration);
                        end;
                    end;

                    u178:PCallAllClients("OnThrowEnded", u179);
                end;

                local u246 = os.clock();
                u228 = RunService.Heartbeat:Connect(function(p247) -- Line: 1636
                    -- upvalues: Util (ref), u179 (ref), u178 (ref), u222 (copy), endThrow (copy), u221 (ref), Grab (ref), u246 (copy), PrimaryPart (copy), u223 (copy)
                    if not Util:IsAlive(u179) or (not Util:IsAlive(u178.Rig) or os.clock() - u222 >= 3) then
                        endThrow(u221);

                        return;
                    end;

                    u221 = u221 - Vector3.new(0, 1, 0) * workspace.Gravity * Grab.GravityCoefficient * p247;
                    local v248 = u221 * p247 * 2;

                    if v248.Magnitude < 2 then
                        v248 = u221.Unit * 5;

                        if v248 ~= v248 then
                            endThrow(u221);

                            return;
                        end;
                    end;

                    local v249 = os.clock() - u246;
                    local v250 = workspace:Raycast(PrimaryPart.Position, v248, u223);

                    if v249 > 0.2 then
                        v250 = v250 or workspace:Raycast(PrimaryPart.Position, Vector3.new(-0, -3.4, -0), u223);
                    end;

                    if v250 then
                        endThrow(u221, v250);

                        return;
                    end;

                    PrimaryPart.AssemblyLinearVelocity = u221;
                end);
            end;

            spawn(function() -- Line: 1675
                -- upvalues: u183 (copy), u184 (copy), Util (ref), u178 (copy), u179 (copy), u180 (copy), u216 (copy), u217 (copy), u212 (copy), destroyGrabConstraints (copy), u193 (copy), u194 (copy), u195 (copy), u196 (copy), u198 (copy), u199 (copy), u200 (copy), u201 (copy), u187 (copy), u188 (copy), Network (ref), u189 (copy), throw (copy)
                local u251 = false;
                local throwMarker = u184:GetMarkerReachedSignal("Throw"):Once(function()
                    u251 = true;
                end);
                u183:Play();
                u184:Play();

                local vThrowMarkerDeadline = os.clock() + math.clamp(u184.Length + 0.75, 0.75, 2.5);

					while u251 == false and os.clock() < vThrowMarkerDeadline and (Util:IsAlive(u178.Rig) ~= false and (Util:IsAlive(u179) ~= false and u179:IsDescendantOf(workspace))) do
                    local v252 = u178;

                    if ((not Util:IsAlive(v252.Rig) or v252.Rig:GetAttribute("Stunned")) and true or false) == true then
                        break;
                    end;

                    task.wait();
                end;

                throwMarker:Disconnect();
                local v253 = u178;

                if Util:IsAlive(v253.Rig) and not v253.Rig:GetAttribute("Stunned") and (Util:IsAlive(u178.Rig) ~= false and Util:IsAlive(u179) ~= false) then
                    local u254 = u178.State.MousePosition or u178:GetPivot().LookVector;
                    u214();
                    Network:FireClientConnection(u178.Player, "SetTrackingMousePosition", "REMOTE_EVENT", u254);
                    Network:FireClientConnection(u178.Player, "DisableSprintingSV", "REMOTE_EVENT", "AzureGrab", false);
                    u178.AbilitiesDisabled = false;
                    u178.DisabledAbilities = {};
                    u178:PCallLocal("SetGrabAbilityLocks", false);
                    u178:PCallLocal("SetGrabStaminaRegenReduction", false);
                    u178.State.GrabbingFlag = nil;
                    task.defer(function() -- Line: 1775
                        -- upvalues: u178 (ref), throw (ref), u254 (copy)
                        u178:SetCooldownOf("Grab", u178.Config.Grab.CooldownSuccess);
                        throw(u254);
                    end);

                    return;
                end;

                u178:SetCooldownOf("Grab", u178.Config.Grab.CooldownMiss);
                u178.State.GrabbingFlag = false;
                u178.AbilitiesDisabled = false;
                u178.DisabledAbilities = {};
                pcall(function() -- Line: 1718
                    -- upvalues: Util (ref), u179 (ref)
                    Util:CreateSpeedMultiplier(u179, 1, "AzureGrab", 0);
                    Util:RemoveStackableAttribute(u179, "Airborne", "AzureGrab");                pcall(function()
                    if u179.PrimaryPart then
                        u179.PrimaryPart:SetNetworkOwnershipAuto();
                    end;
                end);
                end);

                if u180 then
                    u180:DisableAbilities("AzureGrabbing", false);
                end;

                u216:Disconnect();
                u217:Disconnect();
                u212:Disconnect();
                destroyGrabConstraints();
                u193:Stop();
                u194:Stop();
                u195:Stop();
                u196:Stop();
                u198:Stop();
                u199:Stop();
                u200:Stop();
                u201:Stop();
                u187:Stop();
                u188:Stop();
                u183:Stop();
                u184:Stop();
                Network:FireClientConnection(u178.Player, "DisableSprintingSV", "REMOTE_EVENT", "AzureGrab", false);
                u178.AbilitiesDisabled = false;
                u178.DisabledAbilities = {};
                pcall(function() -- Line: 1746
                    -- upvalues: u179 (ref), u189 (ref)
                    u179:SetAttribute("AzureGrabbed", nil);
                    u179:SetAttribute("IgnoreNoclip", nil);
                    u179.PrimaryPart.Anchored = false;

                    for i, v in pairs(u189) do
                        if i and i.Parent then
                            i.Massless = v;
                        end;
                    end;

                    u179.Humanoid.PlatformStand = false;
                end);
                pcall(function() -- Line: 1758
                    -- upvalues: u178 (ref)
                    u178.Rig:SetAttribute("MoveAnimationOverwrite", nil);
                end);
            end);

            return;
        end;

        u178:SetCooldownOf("Grab", u178.Config.Grab.CooldownMiss);
        u178.State.GrabbingFlag = false;
        Util:CreateSpeedMultiplier(u179, 1, "AzureGrab", 0);
        Util:RemoveStackableAttribute(u179, "Airborne", "AzureGrab");                pcall(function()
                    if u179.PrimaryPart then
                        u179.PrimaryPart:SetNetworkOwnershipAuto();
                    end;
                end);

        if u180 then
            u180:DisableAbilities("AzureGrabbing", false);
        end;

        u216:Disconnect();
        u217:Disconnect();
        u212:Disconnect();
        destroyGrabConstraints();
        u193:Stop();
        u194:Stop();
        u195:Stop();
        u196:Stop();
        u198:Stop();
        u199:Stop();
        u200:Stop();
        u201:Stop();

        if u179 and u179.PrimaryPart then
            u179.PrimaryPart.Anchored = false;
        end;

        for i, v in pairs(u190) do
            if i and i.Parent then
                i.CanCollide = v;
            end;
        end;

        u187:Stop();
        u188:Stop();
        Network:FireClientConnection(u178.Player, "DisableSprintingSV", "REMOTE_EVENT", "AzureGrab", false);
        u178.AbilitiesDisabled = false;
        u178.DisabledAbilities = {};
        pcall(function() -- Line: 1408
            -- upvalues: u179 (copy), u189 (copy)
            u179:SetAttribute("AzureGrabbed", nil);
            u179:SetAttribute("IgnoreNoclip", nil);

            for i, v in pairs(u189) do
                if i and i.Parent then
                    i.Massless = v;
                end;
            end;

            u179.Humanoid.PlatformStand = false;
        end);
        pcall(function() -- Line: 1419
            -- upvalues: u178 (copy)
            u178.Rig:SetAttribute("MoveAnimationOverwrite", nil);
        end);
    end;

    function u77.sv_MissGrab(p255, p256) -- Line: 1782
        -- upvalues: Util (copy)
        p256:SetCooldownOf("Grab", p256.Config.Grab.CooldownMiss);
        Util:CreateSpeedMultiplier(p256.Rig, p256.Config.Grab.MissSlowness, "AzureGrabMissed", p256.Config.Grab.MissSlownessDuration);
        p256.AbilitiesDisabled = false;
        p256.DisabledAbilities = {};
    end;

    function u77.sv_UpdateFlowers(p257, p258, p259, p260) -- Line: 1789
        p258:PCallAllClients("UpdateFlowers", p259, p260);
    end;
else
    local function getRandomRotationCF(p261) -- Line: 1793
        local Angles = CFrame.Angles;
        local v262 = Random.new():NextNumber(-p261, p261);
        local v263 = math.rad(v262);
        local v264 = Random.new():NextNumber(-p261, p261);
]=], new=[=[

        p171:SetCooldownOf("Unravel", p171.Config.Golem.TransferCooldown or (p171.Config.GolemTransferCooldown or 3));
        __pcallMethod("sv_ToggleAzureVisible", p171, true);
        local v176 = Util:CopyTable({
            Volume = 0.35,
            PlaybackSpeed = 0.975 + Random.new():NextNumber() * 0.04999999999999993
        });
        v176.Parent = p171.Rig.PrimaryPart;
        Sounds:Play(p171.Config.Sounds.GolemAzureReturn, v176);

        for _, v in pairs(p171.State.RootDistances) do
            v.Origin = p171:GetPivot().Position;
        end;
    end;

    -- AzureEnstrangleUpdate_v2: one cancellable lifecycle, including bots.
    function u77.sv_GrabSurvivor(_, actor, victim)
        if actor.State.GrabbingFlag then return end
        local rig, grab = actor.Rig, actor.Config.Grab
        local function alive(model)
            return model and model:IsDescendantOf(workspace) and model.PrimaryPart
                and model:FindFirstChildOfClass("Humanoid") and Util:IsAlive(model)
        end
        if not alive(rig) or not alive(victim) then
            u77:sv_MissGrab(actor)
            return
        end
        local root, humanoid = rig.PrimaryPart, rig:FindFirstChildOfClass("Humanoid")
        local victimRoot, victimHumanoid = victim.PrimaryPart, victim:FindFirstChildOfClass("Humanoid")
        local victimActor = Util:GetActor(victim)
        local tracks, connections, objects, physics = {}, {}, {}, {}
        local phase, cleaned, detached = "pull", false, false
        local ragdolled = false
        local oldAnchored, oldAutoRotate = root.Anchored, humanoid.AutoRotate
        local oldPlatformStand = victimHumanoid.PlatformStand
        local invincibleKey = "AzureGrab_" .. tostring(os.clock())
        local freeze, victimSpeed, attachment
        local frozen = false
        local invincibleUntil
        local function safe(fn)
            local ok, err = pcall(fn)
            if not ok then warn("[Azure Enstrangle] cleanup: " .. tostring(err)) end
        end
        local function valid()
            return not cleaned and not actor.Destroyed and alive(rig) and alive(victim)
                and rig.PrimaryPart == root and victim.PrimaryPart == victimRoot
                and (phase == "flight" or not rig:GetAttribute("Stunned"))
        end
        local function own(object)
            table.insert(objects, object)
            return object
        end
        local function unfreeze()
            if not frozen then return end
            frozen = false
            if freeze then freeze:Destroy(); freeze = nil end
            if root.Parent then
                root.Anchored = oldAnchored
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
            end
            if humanoid.Parent then humanoid.AutoRotate = oldAutoRotate end
        end
        local function detach()
            if detached then return end
            detached = true
            for _, object in objects do safe(function() object:Destroy() end) end
            for part, props in physics do
                if part.Parent then
                    part.Massless = props.Massless
                    part.CanCollide = props.CanCollide
                end
            end
            for name, track in tracks do
                if name ~= "GrabThrow" and name ~= "GrabVictimThrow" then
                    safe(function() track:Stop(0.05) end)
                end
            end
        end
        local function cleanup()
            if cleaned then return end
            cleaned = true
            for _, connection in connections do connection:Disconnect() end
            safe(detach)
            safe(unfreeze)
            for _, track in tracks do safe(function() track:Stop(0.05) end) end
            if phase ~= "impact" or not invincibleUntil or os.clock() >= invincibleUntil then
                safe(function() Util:RemoveInvincible(rig, invincibleKey) end)
            end
            if victimSpeed then safe(function() victimSpeed:Destroy() end) end
            safe(function() Util:RemoveStackableAttribute(victim, "Airborne", "AzureGrab") end)
            safe(function()
                victim:SetAttribute("AzureGrabbed", nil)
                victim:SetAttribute("IgnoreNoclip", nil)
                if victimHumanoid.Parent and not ragdolled then victimHumanoid.PlatformStand = oldPlatformStand end
                if victimRoot.Parent and not victimRoot.Anchored then victimRoot:SetNetworkOwnershipAuto() end
            end)
            if victimActor then safe(function() victimActor:DisableAbilities("AzureGrabbing", false) end) end
            safe(function() rig:SetAttribute("MoveAnimationOverwrite", nil) end)
            actor.State.GrabbingFlag = nil
            actor.State.ThrowRequest = nil
            actor.State.AzureGrabCleanup = nil
            actor.AbilitiesDisabled = false
            actor.DisabledAbilities = {}
            safe(function() actor:PCallLocal("SetGrabAbilityLocks", false) end)
            safe(function() actor:PCallLocal("SetGrabStaminaRegenReduction", false) end)
            safe(function() Network:FireClientConnection(actor.Player, "DisableSprintingSV", "REMOTE_EVENT", "AzureGrab", false) end)
            safe(function() Network:FireClientConnection(actor.Player, "SetTrackingMousePosition", "REMOTE_EVENT", Vector3.new(0, 0, -1)) end)
            safe(function() actor:PCallAllClients("OnHomingStopped") end)
            safe(function() actor:PCallLocal("OnHomingStopped") end)
            safe(function() actor:PCallAllClients("OnThrowEnded", victim) end)
            if ragdolled and phase ~= "impact" and alive(victim) then
                safe(function() Ragdolls.DisableRagdoll(victim) end)
            end
        end
        actor.State.GrabbingFlag = true
        actor.State.ThrowRequest = nil -- firing clicks must never queue an early throw
        actor.State.AzureGrabCleanup = cleanup

        local function load(name, model)
            local track = Util:LoadAnimationFromID(model, actor.Config.Animations[name], false)
            tracks[name] = track
            return track
        end
        local function waitTrack(track, maxTime, update, marker)
            local began, stopped, reached = os.clock(), false, false
            local stoppedConnection = track.Stopped:Connect(function() stopped = true end)
            table.insert(connections, stoppedConnection)
            local markerConnection
            if marker then
                markerConnection = track:GetMarkerReachedSignal(marker):Connect(function() reached = true end)
                table.insert(connections, markerConnection)
            end
            track:Play(0.025)
            while valid() do
                local elapsed = os.clock() - began
                if update then update(elapsed) end
                -- Length can initially be zero while the published animation loads.
                local deadline = track.Length > 0 and math.min(track.Length + 0.25, maxTime) or maxTime
                if reached or stopped or elapsed >= deadline then break end
                task.wait()
            end
            stoppedConnection:Disconnect()
            if markerConnection then markerConnection:Disconnect() end
            return valid()
        end
        local function applyImpact(result, velocity, releasedAt)
            if not valid() then return end
            local position, normal = result.Position, result.Normal
            phase = "impact"
            local close = (position - root.Position).Magnitude <= (grab.CloseThrowDistance or 20)
            if close then
                Statuses:ApplyStatus(rig, "Helpless", {
                    Level = 1, Duration = math.max(0.1, (grab.CloseThrowHelpless or 4) - (os.clock() - releasedAt))
                })
                Statuses:ApplyStatus(rig, "Slowness", {Level = 2, Duration = 2})
            end
            victim:SetAttribute("AzureGrabbed", nil)
            -- A landing remains detectable even if the victim is stationary/Undetectable.
            victim:SetAttribute("AzureThrowLandedUntil", os.clock() + (grab.PlantTriggerDuration or 1.5))
            local bounce = (velocity - 2 * velocity:Dot(normal) * normal) / 4
            victim:PivotTo(CFrame.new(position + normal * 2))
            Ragdolls.AddProfile(victim, {Velocity = bounce})
            Ragdolls.EnableRagdoll(victim, grab.RagdollDuration)
            victimRoot.AssemblyLinearVelocity = bounce
            __playSound(actor, "GrabImpact", {RollOffMaxDistance = 300, Position = position})
            actor:PCallAllClients("OnGroundExplode", position, result.Instance)
            local effect = actor.Config.Instances.SlamVFX:Clone()
            effect.Parent = workspace.Terrain
            effect.CFrame = CFrame.new(position, position + normal) * CFrame.Angles(math.pi / 2, 0, 0)
            Debris:AddItem(effect, 4)
            Util:EmitParticles(effect)
            -- The thrown victim is damaged once, independently of blast overlap sampling.
            Util:ApplyDamage(victim, grab.Damage)
            Actors:IncrementActorStats(actor.Player, {Action = "Threw Survivor", RewardType = "EasyKillerAction"})
            local nearby = workspace.Players.Survivors:GetChildren()
            if workspace:GetAttribute("FriendlyFire") then
                for _, other in workspace.Players.Killers:GetChildren() do table.insert(nearby, other) end
            end
            for _, other in nearby do
                if other == victim or other == rig or not alive(other) then continue end
                local delta = other.PrimaryPart.Position - position
                if delta.Magnitude > grab.BlastRadius then continue end
                local horizontal = Vector3.new(delta.X, 0, delta.Z)
                local direction = horizontal.Magnitude > 0.001 and horizontal.Unit or Vector3.zero
                local knockback = (direction + Vector3.new(0, 0.6, 0)) * grab.KnockbackPower
                other.PrimaryPart.AssemblyLinearVelocity = knockback
                Ragdolls.AddProfile(other, {Velocity = knockback})
                Ragdolls.EnableRagdoll(other, grab.RagdollDuration)
                Actors:IncrementActorStats(actor.Player, {
                    Action = tostring(other.Parent) == "Killers" and "Threw Survivor into Killer" or "Threw Survivor into Survivor",
                    RewardType = "EasyKillerAction"
                })
            end
        end
        local ok, err = xpcall(function()
            __pcallMethod("sv_OnMeleeHit", actor, victim)
            actor.AbilitiesDisabled = false
            actor.DisabledAbilities = {Slash = true, Sow = true, Blossom = true, Unravel = true}
            actor:PCallLocal("SetGrabAbilityLocks", true, true)
            actor:PCallLocal("SetGrabStaminaRegenReduction", true)
            Network:FireClientConnection(actor.Player, "DisableSprintingSV", "REMOTE_EVENT", "AzureGrab", true)
            frozen = true
            freeze = Util:CreateSpeedMultiplier(rig, 0, "AzureGrabSuccess")
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
            root.Anchored = true
            humanoid.AutoRotate = false
            Util:GiveInvincible(rig, invincibleKey)
            victimSpeed = Util:CreateSpeedMultiplier(victim, 0, "AzureGrab")
            Util:GiveStackableAttribute(victim, "Airborne", "AzureGrab")
            victim:SetAttribute("AzureGrabbed", true)
            victim:SetAttribute("IgnoreNoclip", true)
            victimHumanoid.PlatformStand = true
            if victimActor then victimActor:DisableAbilities("AzureGrabbing", true) end
            for _, part in victim:GetDescendants() do
                if part:IsA("BasePart") then
                    physics[part] = {Massless = part.Massless, CanCollide = part.CanCollide}
                    part.Massless = true
                    part.CanCollide = false
                end
            end
            if not victimRoot.Anchored then victimRoot:SetNetworkOwner(nil) end
            attachment = own(Instance.new("Attachment", root))
            local victimAttachment = own(Instance.new("Attachment", victimRoot))
            local align = own(Instance.new("AlignPosition", victimRoot))
            align.Attachment0, align.Attachment1 = victimAttachment, attachment
            align.Responsiveness, align.RigidityEnabled = 200, true
            local orientation = own(Instance.new("AlignOrientation", victimRoot))
            orientation.Attachment0, orientation.Attachment1 = victimAttachment, attachment
            orientation.Responsiveness, orientation.RigidityEnabled = 200, true
            local initial = victimRoot.Position
            local offset = CFrame.new(0, 0, -3)
            attachment.CFrame = root.CFrame:ToObjectSpace(CFrame.new(initial))
            local function pull(elapsed)
                local target = root.CFrame * offset
                local alpha = TweenService:GetValue(math.clamp(elapsed / grab.PullTime, 0, 1), Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut)
                local position = initial:Lerp(target.Position, alpha)
                attachment.CFrame = root.CFrame:ToObjectSpace(CFrame.lookAt(position, position + target.LookVector))
            end
            __playSound(actor, "Grabbed", {Parent = victimRoot})
            Sounds:Play(actor.Config.Sounds.Grab, {Parent = root, Volume = 0.35})
            actor:PlayVoiceline("GrabHit", {Priority = 2})
            local success = load("GrabShootSuccess", rig)
            load("GrabVictimSuccess", victim):Play(0.025)
            load("GrabVictimHooked", victim):Play(0.025)
            load("GrabPullingLoop", rig):Play(0.025)
            local pullStart = os.clock()
            if not waitTrack(success, grab.SuccessAnimationTimeout or 8, pull) then return end
            while valid() and os.clock() - pullStart < grab.PullTime do
                pull(os.clock() - pullStart)
                task.wait()
            end
            if not valid() then return end
            attachment.CFrame = offset
            for _, name in {"GrabShootSuccess", "GrabVictimSuccess", "GrabVictimHooked", "GrabPullingLoop"} do
                tracks[name]:Stop(0.05)
            end
            unfreeze()
            invincibleUntil = os.clock() + 0.5
            task.delay(0.5, function() safe(function() Util:RemoveInvincible(rig, invincibleKey) end) end)
            phase = "hold"
            actor.DisabledAbilities = {Sow = true, Blossom = true, Unravel = true}
            actor:PCallLocal("SetGrabAbilityLocks", true, false)
            Network:FireClientConnection(actor.Player, "DisableSprintingSV", "REMOTE_EVENT", "AzureGrab", false)
            actor:SetCooldownOf("Slash", 0)
            actor:SetCooldownOf("Grab", 0)
            rig:SetAttribute("MoveAnimationOverwrite", "Grab")
            for _, name in {"GrabIdle", "GrabWalk", "GrabRun"} do load(name, rig) end
            for _, name in {"GrabVictimIdle", "GrabVictimWalk", "GrabVictimRun"} do load(name, victim) end
            Network:FireClientConnection(actor.Player, "SetTrackingMousePosition", "REMOTE_EVENT")
            actor:PCallAllClients("OnHomingStart")
            actor:PCallLocal("OnHomingStart")
            actor.State.ThrowRequest = false
            local holdStart, movement = os.clock(), nil
            while valid() and actor.State.ThrowRequest ~= true and os.clock() - holdStart < grab.HoldMaxDuration do
                local speed = root.AssemblyLinearVelocity.Magnitude
                local nextMovement = speed > 12 and "Run" or speed > 1 and "Walk" or "Idle"
                if nextMovement ~= movement then
                    if movement then
                        tracks["Grab" .. movement]:Stop(0.1)
                        tracks["GrabVictim" .. movement]:Stop(0.1)
                    end
                    tracks["Grab" .. nextMovement]:Play(0.1)
                    tracks["GrabVictim" .. nextMovement]:Play(0.1)
                    movement = nextMovement
                end
                task.wait()
            end
            actor.State.ThrowRequest = nil
            actor:PCallAllClients("OnHomingStopped")
            actor:PCallLocal("OnHomingStopped")
            if not valid() then return end
            phase = "release"
            actor.AbilitiesDisabled = true
            local throwTrack = load("GrabThrow", rig)
            local victimThrow = load("GrabVictimThrow", victim)
            for _, name in {"GrabIdle", "GrabWalk", "GrabRun", "GrabVictimIdle", "GrabVictimWalk", "GrabVictimRun"} do
                tracks[name]:Stop(0.05)
            end
            throwTrack:Play(0.025)
            if not waitTrack(victimThrow, grab.ThrowAnimationTimeout or 8, nil, "Throw") then return end
            -- Recheck after every yielding animation wait; removed NPCs can still have health.
            if not valid() then return end
            local direction = actor.State.MousePosition
            if typeof(direction) ~= "Vector3" or direction.Magnitude < 0.001
                or direction.Magnitude ~= direction.Magnitude or direction.Magnitude == math.huge then
                direction = root.CFrame.LookVector
            end
            direction = direction.Unit
            Network:FireClientConnection(actor.Player, "SetTrackingMousePosition", "REMOTE_EVENT", direction)
            detach()
            phase = "flight"
            rig:SetAttribute("MoveAnimationOverwrite", nil)
            actor:PCallLocal("SetGrabAbilityLocks", false)
            actor.AbilitiesDisabled = false
            actor.DisabledAbilities = {}
            actor:SetCooldownOf("Grab", grab.CooldownSuccess)
            local releasedAt = os.clock()
            Statuses:ApplyStatus(rig, "Helpless", {Level = 1, Duration = grab.ThrowHelpless or 2})
            Ragdolls.EnableRagdoll(victim)
            ragdolled = true
            victimRoot:SetNetworkOwner(nil)
            local velocity = direction * grab.ThrowVelocity
            victimRoot.AssemblyLinearVelocity = velocity
            Sounds:Play(actor.Config.Sounds.GrabThrow, {Parent = root, Volume = 0.35})
            __playSound(actor, "GrabThrown", {Parent = victimRoot})
            actor:PlayVoiceline("GrabThrow", {Priority = 2})
            local trail = actor.Config.Instances.ThrowTrailVFX:Clone()
            for _, child in trail:GetChildren() do
                child.Parent = victim:FindFirstChild("Torso") or victimRoot
                own(child)
            end
            trail:Destroy()
            actor:PCallAllClients("OnThrown", victim)
            local params = RaycastParams.new()
            params.FilterDescendantsInstances = {workspace.Players}
            params.CollisionGroup = workspace:GetAttribute("FriendlyFire") and "Default" or "Survivors"
            params.RespectCanCollide = true
            local previousPosition = victimRoot.Position
            while valid() and os.clock() - releasedAt < 3 do
                local dt = task.wait()
                if not valid() then return end
                velocity -= Vector3.new(0, workspace.Gravity * grab.GravityCoefficient * dt, 0)
                local displacement = victimRoot.Position - previousPosition
                local result = displacement.Magnitude > 0.001 and workspace:Raycast(previousPosition, displacement, params)
                result = result or workspace:Raycast(victimRoot.Position, velocity * dt * 2, params)
                if not result and os.clock() - releasedAt > 0.2 then
                    result = workspace:Raycast(victimRoot.Position, Vector3.new(0, -3.4, 0), params)
                end
                if result then applyImpact(result, velocity, releasedAt); return end
                previousPosition = victimRoot.Position
                victimRoot.AssemblyLinearVelocity = velocity
            end
            if valid() then
                phase = "impact"
                Ragdolls.EnableRagdoll(victim, grab.RagdollDuration)
            end
        end, debug.traceback)
        if phase == "pull" or phase == "hold" or phase == "release" then
            safe(function() actor:SetCooldownOf("Grab", grab.CooldownMiss) end)
        end
        -- detach() can run at release, so destroy flight-only effects separately.
        for _, object in objects do safe(function() object:Destroy() end) end
        cleanup()
        if not ok then warn("[Azure Enstrangle] " .. tostring(err)) end
    end;

    function u77.sv_MissGrab(p255, p256) -- Line: 1782
        -- upvalues: Util (copy)
        Network:FireClientConnection(p256.Player, "DisableSprintingSV", "REMOTE_EVENT", "AzureGrab", false);
        p256:PCallLocal("SetGrabStaminaRegenReduction", false);
        p256:PCallLocal("SetGrabAbilityLocks", false);
        p256.State.GrabWindingUp = false;
        p256.State.GrabReadyToFire = false;
        p256:SetCooldownOf("Grab", p256.Config.Grab.CooldownMiss);
        Util:CreateSpeedMultiplier(p256.Rig, p256.Config.Grab.MissSlowness, "AzureGrabMissed", p256.Config.Grab.MissSlownessDuration);
        p256.AbilitiesDisabled = false;
        p256.DisabledAbilities = {};
    end;

    function u77.sv_UpdateFlowers(p257, p258, p259, p260) -- Line: 1789
        p258:PCallAllClients("UpdateFlowers", p259, p260);
    end;
else
    local function getRandomRotationCF(p261) -- Line: 1793
        local Angles = CFrame.Angles;
        local v262 = Random.new():NextNumber(-p261, p261);
        local v263 = math.rad(v262);
        local v264 = Random.new():NextNumber(-p261, p261);
]=]}
}},
{path={"Config"}, checksum=3562222269, edits={
{old=[=[
		WidthMultiplier = 0.5,
		Tweens = true,
		AwayRotation = -45,
		AwayRotationDeviance = 1,
		RandomRotation = 25,
		TimeInterval = 0.013,
		TweenConfig = TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
	},
	Animations = {
		Idle = "rbxassetid://116360021725736",
		Walk = "rbxassetid://137270559094124",
		Run = "rbxassetid://81976535452072",
		InjuredIdle = "rbxassetid://130212214475523",
		InjuredWalk = "rbxassetid://137270559094124",
		InjuredRun = "rbxassetid://81976535452072",
		GrabWindup = "rbxassetid://126943460287303",
		GrabWindupIdle = "rbxassetid://119718480813358",
		GrabShoot = "rbxassetid://120193719647987",
		GrabPullingLoop = "rbxassetid://129309658586853",
		GrabVictimHooked = "rbxassetid://138431935948623",
		GrabShootFailed = "rbxassetid://125879640334571",
		GrabShootSuccess = "rbxassetid://119060253017136",
		GrabIdle = "rbxassetid://76941646624072",
		GrabWalk = "rbxassetid://91111939230242",
		GrabRun = "rbxassetid://102254632037826",
		GrabThrow = "rbxassetid://91685270490591",
		GrabVictimSuccess = "rbxassetid://81855874166679",
		GrabVictimIdle = "rbxassetid://87214069428630",
		GrabVictimWalk = "rbxassetid://138824416091302",
		GrabVictimRun = "rbxassetid://134341932149348",
		GrabVictimThrow = "rbxassetid://105405757449820",
		GolemStateEnter = "rbxassetid://102926399930976",
		GolemStateIdle = "rbxassetid://74563914886530",
		GolemStateExit = "rbxassetid://135253207895249",
		GolemIdle = "rbxassetid://86695374427132",
		GolemWalk = "rbxassetid://131254280180461",
		GolemRun = "rbxassetid://84708586729159",
		GolemFissure = "rbxassetid://123139589519631",
		GolemShockwave = "rbxassetid://76372125496160",
		GolemSlash = "rbxassetid://127127827342972",
		GolemSpawn = "rbxassetid://106016750602687",
		Execution = {
			KillerRig = "rbxassetid://79845039586897",
			PlayerRig = "rbxassetid://112882309418350",
			PlayerCFrameOffset = CFrame.Angles(0, 3.141592653589793, 0) * CFrame.new(0, 0, 4)
		},
]=], new=[=[
		WidthMultiplier = 0.5,
		Tweens = true,
		AwayRotation = -45,
		AwayRotationDeviance = 1,
		RandomRotation = 25,
		TimeInterval = 0.013,
		TweenConfig = TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
	},
	Animations = {
		Idle = "rbxassetid://116360021725736",
		Walk = "rbxassetid://137270559094124",
		Run = "rbxassetid://81976535452072",
		InjuredIdle = "rbxassetid://130212214475523",
		InjuredWalk = "rbxassetid://137270559094124",
		InjuredRun = "rbxassetid://81976535452072",
		GrabWindup = "rbxassetid://102499260904211",
		GrabWindupIdle = "rbxassetid://140069588383388",
		GrabShoot = "rbxassetid://83254528614461",
		GrabPullingLoop = "rbxassetid://80281580027249",
		GrabVictimHooked = "rbxassetid://123574158064862",
		GrabShootFailed = "rbxassetid://84993062039295",
		GrabShootSuccess = "rbxassetid://89545146730216",
		GrabIdle = "rbxassetid://119731980366784",
		GrabWalk = "rbxassetid://73786982077847",
		GrabRun = "rbxassetid://81241266142076",
		GrabThrow = "rbxassetid://113341114154649",
		GrabVictimSuccess = "rbxassetid://103728564252279",
		GrabVictimIdle = "rbxassetid://133322104651075",
		GrabVictimWalk = "rbxassetid://109484361308811",
		GrabVictimRun = "rbxassetid://83915816771671",
		GrabVictimThrow = "rbxassetid://127270614280548",
		GolemStateEnter = "rbxassetid://102926399930976",
		GolemStateIdle = "rbxassetid://74563914886530",
		GolemStateExit = "rbxassetid://135253207895249",
		GolemIdle = "rbxassetid://86695374427132",
		GolemWalk = "rbxassetid://131254280180461",
		GolemRun = "rbxassetid://84708586729159",
		GolemFissure = "rbxassetid://123139589519631",
		GolemShockwave = "rbxassetid://76372125496160",
		GolemSlash = "rbxassetid://127127827342972",
		GolemSpawn = "rbxassetid://106016750602687",
		Execution = {
			KillerRig = "rbxassetid://79845039586897",
			PlayerRig = "rbxassetid://112882309418350",
			PlayerCFrameOffset = CFrame.Angles(0, 3.141592653589793, 0) * CFrame.new(0, 0, 4)
		},
]=]},
{old=[=[
		HookHitboxSize = 4,
		-- the vine's hitbox (width, height, length). Wasn't set, so it fell back to a 1.5 x 1.5 x 4 box that
		-- needed a near-perfect aim (a survivor is 3 studs wide)
		ProjectileHitboxSize = Vector3.new(5, 5.5, 6),
		MissSlowness = 0.3,
		MissSlownessDuration = 1,
		CooldownCancel = 5,
		CooldownMiss = 25,
		CooldownSuccess = 25,
		KnockbackPower = 100,
		RagdollDuration = 1.2,
		BlastRadius = 20,
		Damage = 5,
		ThrowVelocity = 70,
		GravityCoefficient = 0.425,
		HoldMaxDuration = 1.5
	},
	Sow = {
		Windup = 0.86,
		Range = 12,
		Endlag = 0.5
	},
	Blossom = {
		Windup = 0.8,
		Endlag = 0.5
	},
	Unravel = {
		Windup = 0.8,
		Endlag = 0.5
	},
]=], new=[=[
		HookHitboxSize = 4,
		-- the vine's hitbox (width, height, length). Wasn't set, so it fell back to a 1.5 x 1.5 x 4 box that
		-- needed a near-perfect aim (a survivor is 3 studs wide)
		ProjectileHitboxSize = Vector3.new(5, 5.5, 6),
		MissSlowness = 0.3,
		MissSlownessDuration = 1,
		CooldownCancel = 5,
		CooldownMiss = 25,
		CooldownSuccess = 25,
		KnockbackPower = 100,
		RagdollDuration = 1.2,
		BlastRadius = 20,
		Damage = 5,
		ThrowVelocity = 70,
		GravityCoefficient = 0.425,
		HitDamage = 10,
		CloseThrowDistance = 20,
		ThrowHelpless = 2,
		CloseThrowHelpless = 4,
		PlantTriggerDuration = 1.5,
		SuccessAnimationTimeout = 8,
		ThrowAnimationTimeout = 8,
		HoldMaxDuration = 1.5
	},
	Sow = {
		Windup = 0.86,
		Range = 12,
		Endlag = 0.5
	},
	Blossom = {
		Windup = 0.8,
		Endlag = 0.5
	},
	Unravel = {
		Windup = 0.8,
		Endlag = 0.5
	},
]=]}
}},
{path={"Behavior","sv_AzureConstruct"}, checksum=173055994, edits={
{old=[=[
function u4.ActivationHighlight(p59, p60) -- Line: 374
    -- upvalues: Util (copy)
    Util:RevealPlayerAuraTo(p59.Owner, p60, 4.5, Color3.new(0.501961, 0, 1));
end;

function u4.HasLOS(p61, p62) -- Line: 379
    -- upvalues: Hitboxes (copy)
    return Hitboxes:LineOfSight(p61.Root.CFrame.Position, p62) and true or false;
end;

function u4.GetLoudSurvivorsInRange(u63, actorRig, p64, p65, p66) -- Line: 384
    -- upvalues: Util (copy)
    local v67 = {};

    for _, child in ipairs(workspace.Players.Survivors:GetChildren()) do
        if Util:IsAlive(child) and not (child:GetAttribute("Undetectable") or p66 and table.find(p66, child)) and (not p65 or u63:HasLOS(child)) then
            local Magnitude = (child:GetPivot().Position - u63.Root.CFrame.Position).Magnitude;
            local v68 = (child.PrimaryPart.AssemblyLinearVelocity * Vector3.new(1, 0, 1)).Magnitude - 1;
            local v69 = child:GetAttribute("AbilityLastUsed") or 0;
            local v70 = child:GetAttribute("AzureQTEFailFlag") or 0;

            if ((child:GetAttribute("BaseSpeed") or 16) <= v68 or (os.clock() - v69 < 1.5 or os.clock() - v70 < 1.5)) and Magnitude <= p64 then
                table.insert(v67, child);
            end;
        end;
    end;
	if workspace:GetAttribute("FriendlyFire") then
		for _, child in ipairs(workspace.Players.Killers:GetChildren()) do
			if child == actorRig then continue end
			if Util:IsAlive(child) and not (child:GetAttribute("Undetectable") or p66 and table.find(p66, child)) and (not p65 or u63:HasLOS(child)) then
				local Magnitude = (child:GetPivot().Position - u63.Root.CFrame.Position).Magnitude;
				local v68 = (child.PrimaryPart.AssemblyLinearVelocity * Vector3.new(1, 0, 1)).Magnitude - 1;
				local v69 = child:GetAttribute("AbilityLastUsed") or 0;
				local v70 = child:GetAttribute("AzureQTEFailFlag") or 0;

				if ((child:GetAttribute("BaseSpeed") or 16) <= v68 or (os.clock() - v69 < 1.5 or os.clock() - v70 < 1.5)) and Magnitude <= p64 then
					table.insert(v67, child);
				end;
			end;
		end;
	end

    table.sort(v67, function(p71, p72) -- Line: 401
        -- upvalues: u63 (copy)
        return (p71:GetPivot().Position - u63.Root.CFrame.Position).Magnitude < (p72:GetPivot().Position - u63.Root.CFrame.Position).Magnitude;
    end);

    return v67;
end;

function u4.FireConnection(p73, p74, ...) -- Line: 409
]=], new=[=[
function u4.ActivationHighlight(p59, p60) -- Line: 374
    -- upvalues: Util (copy)
    Util:RevealPlayerAuraTo(p59.Owner, p60, 4.5, Color3.new(0.501961, 0, 1));
end;

function u4.HasLOS(p61, p62) -- Line: 379
    -- upvalues: Hitboxes (copy)
    return Hitboxes:LineOfSight(p61.Root.CFrame.Position, p62) and true or false;
end;

function u4.GetLoudSurvivorsInRange(u63, actorRig, p64, p65, p66) -- Line: 384
    -- upvalues: Util (copy)
    local v67 = {};

    for _, child in ipairs(workspace.Players.Survivors:GetChildren()) do
        if Util:IsAlive(child) and not (p66 and table.find(p66, child)) and (((child:GetAttribute("AzureThrowLandedUntil") or 0) > os.clock()) or (not child:GetAttribute("Undetectable") and (not p65 or u63:HasLOS(child)))) then
            local Magnitude = (child:GetPivot().Position - u63.Root.CFrame.Position).Magnitude;
            local v68 = (child.PrimaryPart.AssemblyLinearVelocity * Vector3.new(1, 0, 1)).Magnitude - 1;
            local v69 = child:GetAttribute("AbilityLastUsed") or 0;
            local v70 = child:GetAttribute("AzureQTEFailFlag") or 0;

            if ((child:GetAttribute("AzureThrowLandedUntil") or 0) > os.clock() or (child:GetAttribute("BaseSpeed") or 16) <= v68 or (os.clock() - v69 < 1.5 or os.clock() - v70 < 1.5)) and Magnitude <= p64 then
                table.insert(v67, child);
            end;
        end;
    end;
	if workspace:GetAttribute("FriendlyFire") then
		for _, child in ipairs(workspace.Players.Killers:GetChildren()) do
			if child == actorRig then continue end
			if Util:IsAlive(child) and not (p66 and table.find(p66, child)) and (((child:GetAttribute("AzureThrowLandedUntil") or 0) > os.clock()) or (not child:GetAttribute("Undetectable") and (not p65 or u63:HasLOS(child)))) then
				local Magnitude = (child:GetPivot().Position - u63.Root.CFrame.Position).Magnitude;
				local v68 = (child.PrimaryPart.AssemblyLinearVelocity * Vector3.new(1, 0, 1)).Magnitude - 1;
				local v69 = child:GetAttribute("AbilityLastUsed") or 0;
				local v70 = child:GetAttribute("AzureQTEFailFlag") or 0;

				if ((child:GetAttribute("AzureThrowLandedUntil") or 0) > os.clock() or (child:GetAttribute("BaseSpeed") or 16) <= v68 or (os.clock() - v69 < 1.5 or os.clock() - v70 < 1.5)) and Magnitude <= p64 then
					table.insert(v67, child);
				end;
			end;
		end;
	end

    table.sort(v67, function(p71, p72) -- Line: 401
        -- upvalues: u63 (copy)
        return (p71:GetPivot().Position - u63.Root.CFrame.Position).Magnitude < (p72:GetPivot().Position - u63.Root.CFrame.Position).Magnitude;
    end);

    return v67;
end;

function u4.FireConnection(p73, p74, ...) -- Line: 409
]=]}
}}
}
local prepared = {}
for _, change in changes do
    local module = resolve(change.path)
    local original = read(module)
    local source = normalize(original)
    assert(checksum(source) == change.checksum,
        "Azure source differs from the uploaded build (or patch is already installed): " .. module:GetFullName() .. ". No changes applied.")
    for _, edit in change.edits do
        local first,last = string.find(source, edit.old, 1, true)
        assert(first and not string.find(source, edit.old, last+1, true), "Patch anchor missing/ambiguous. No changes applied.")
        source = string.sub(source,1,first-1) .. edit.new .. string.sub(source,last+1)
    end
    table.insert(prepared, {module=module, original=original, updated=source, path=change.path})
end
local backup = Instance.new("Folder")
backup.Name = "AzureEnstrangleBackup_" .. os.time()
backup.Parent = storage
for i, item in prepared do
    local entry = Instance.new("Folder")
    entry.Name = tostring(i)
    entry:SetAttribute("ModulePath", table.concat(item.path,"/"))
    entry.Parent = backup
    for offset=1,#item.original,50000 do
        local part = Instance.new("StringValue")
        part.Name = string.format("SourcePart%04d", math.floor((offset-1)/50000)+1)
        part.Value = string.sub(item.original,offset,offset+49999)
        part.Parent = entry
    end
end
local applied = {}
local ok, err = pcall(function()
    for _, item in prepared do
        write(item.module, item.original, item.updated)
        table.insert(applied,item)
    end
end)
if not ok then
    for i=#applied,1,-1 do
        local item=applied[i]
        local restored, restoreError = pcall(write,item.module,item.updated,item.original)
        if not restored then warn("Restore from " .. backup.Name .. ": " .. tostring(restoreError)) end
    end
    error("Azure update failed; rollback attempted. Backup: " .. backup.Name .. "\n" .. tostring(err))
end
print("Azure Enstrangle update installed (3 modules, 16 animation IDs). Backup: ServerStorage." .. backup.Name)
print("Playtest: cancel/miss, freeze -> hold -> manual/auto throw, vertical aim, close/far impact, nearby plants, victim reset/despawn and Azure death.")
