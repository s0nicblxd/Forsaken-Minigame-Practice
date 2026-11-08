-- AZURE CONTROLS AND TIMING FOLLOW-UP — 2026-11-08
-- Stop Play. Open the newest FCF place, then paste this ENTIRE file into
-- Studio's Command Bar and press Enter. No HTTP requests or downloads are used.
-- Requires the earlier Enstrangle update installed. Targets Azure.Behavior, Azure.Config and SmoothShiftLock only.
-- Checks your source before editing. If it differs, NOTHING is changed.
-- Keeps all 16 uploaded animation IDs. Adds new regular Idle/Walk/Run IDs, including shared injured Walk/Run references.
-- Backup: ServerStorage.AzureControlsBackup_<timestamp> (chunked full source).
-- To restore: set RESTORE_BACKUP below to that folder's exact name and run this file again.
-- Restore overwrites only the three backed-up modules with their pre-patch source.
-- Website/main branch are unaffected.
--
-- Includes: resume held sprint, defer grab-success animation until pull-in ends,
-- upright aiming with full 3D projectile direction, shift-lock ownership,
-- looping hold animations and stationary aiming pose yielding to movement.
-- Validation: Luau compilation + mocked lifecycle tests; not a live Roblox playtest.
local RESTORE_BACKUP = nil
local RunService = game:GetService("RunService")
assert(not RunService:IsRunning(), "Stop Play before applying/restoring the Azure update.")
local editor = game:GetService("ScriptEditorService")
local storage = game:GetService("ServerStorage")
local moduleRoot = game:GetService("ReplicatedStorage")
local function normalize(s) return (s:gsub("\r\n", "\n")) end
local function read(module) return editor:GetEditorSource(module) end
local function write(module, expected, updated)
    editor:UpdateSourceAsync(module, function(current)
        assert(current == expected, "Source changed while applying: " .. module:GetFullName())
        return updated
    end)
end
local function resolve(path)
    local node = moduleRoot
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
{path={"Assets","Killers","Azure","Behavior"}, checksum=2788858678, edits={
{old=[=[
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

    for i, v in p735.NetworkConnections do
        Network:RemoveConnection(v[1], v[2]);
        p735.NetworkConnections[i] = nil;
]=], new=[=[
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
        __pcallMethod("lcl_SetGrabSprintDisabled", p735, false);
        p735.LookFlag = nil;
        if p735.State then p735.State.GrabAimingSequence = nil end;
        if p735.Rig then p735.Rig:SetAttribute("AzureGrabFacing", nil) end;
        __pcallMethod("lcl_SetGrabAbilityLocks", p735, false);
        __pcallMethod("lcl_SetGrabStaminaRegenReduction", p735, false);
        __pcallMethod("lcl_ClearRemoveAllFlowers", p735);
    end;

    p735.Maid:Destroy();

    for i, v in p735.ConnectionDictionary do
        v:Disconnect();
        p735.NetworkConnections[i] = nil;
    end;

    for i, v in p735.NetworkConnections do
        Network:RemoveConnection(v[1], v[2]);
        p735.NetworkConnections[i] = nil;
]=]},
{old=[=[
            });
        end;

        v723:GiveCharacterAtropa(p719.Character, u685.Config.AtropaOnDefuse);
        v723:EndQTE(p721);
    end);
    u685.NetworkConnections.UpdateMouse = { `{u685.Player.Name}AzureUpdateMouse`, "REMOTE_EVENT" };
    Network:SetConnection(`{u685.Player.Name}AzureUpdateMouse`, "REMOTE_EVENT", function(p724, p725) -- Line: 4771
        -- upvalues: u685 (copy)
        if p724 ~= u685.Player then
            p724:Kick();

            return;
        end;

        if p725.X ~= p725.X or (p725.Y ~= p725.Y or p725.Z ~= p725.Z) then
            p724:Kick();
        end;

        local v726 = (p725.Magnitude <= 0.001 or math.isinf(p725.Magnitude)) and Vector3.new(0, 0, 1) or p725;
        u685.State.MousePosition = v726;
        u685.State.LastMouseUpdate = os.clock();
    end);
    u685.NetworkConnections.Grab = { `{u685.Player.Name}AzureRequestGrab`, "REMOTE_FUNCTION" };
    Network:SetConnection(`{u685.Player.Name}AzureRequestGrab`, "REMOTE_FUNCTION", function(p727, u728) -- Line: 4794
        -- upvalues: u685 (copy), Hitboxes (ref), spawn (ref), __pcallMethod (ref)
        if p727 ~= u685.Player then
            return false;
        end;

        if not u685.State.HomingActive then
            return false;
]=], new=[=[
            });
        end;

        v723:GiveCharacterAtropa(p719.Character, u685.Config.AtropaOnDefuse);
        v723:EndQTE(p721);
    end);
    u685.NetworkConnections.UpdateMouse = { `{u685.Player.Name}AzureUpdateMouse`, "REMOTE_EVENT" };
    Network:SetConnection(`{u685.Player.Name}AzureUpdateMouse`, "REMOTE_EVENT", function(p724, p725) -- Line: 4771
        -- upvalues: u685 (copy)
        if p724 ~= u685.Player then
            p724:Kick();

            return;
        end;

        if typeof(p725) ~= "Vector3" or p725.X ~= p725.X or p725.Y ~= p725.Y
            or p725.Z ~= p725.Z or p725.Magnitude == math.huge then
            return;
        end;

        local v726 = (p725.Magnitude <= 0.001 or math.isinf(p725.Magnitude)) and Vector3.new(0, 0, 1) or p725;
        u685.State.MousePosition = v726;
        u685.State.LastMouseUpdate = os.clock();
    end);
    u685.NetworkConnections.Grab = { `{u685.Player.Name}AzureRequestGrab`, "REMOTE_FUNCTION" };
    Network:SetConnection(`{u685.Player.Name}AzureRequestGrab`, "REMOTE_FUNCTION", function(p727, u728) -- Line: 4794
        -- upvalues: u685 (copy), Hitboxes (ref), spawn (ref), __pcallMethod (ref)
        if p727 ~= u685.Player then
            return false;
        end;

        if not u685.State.HomingActive then
            return false;
]=]},
{old=[=[
                        Value = 1
                    }):Play();
                    u685.State.MousePosition = p712;
                    RunService:UnbindFromRenderStep("MouseTracking");

                    return;
                end;

                spawn(function() -- Line: 5095
                    -- upvalues: __pcallMethod (ref), u685 (ref)
                    __pcallMethod("lcl_StartMouseTracking", u685);
                end);
                RunService:BindToRenderStep("MouseTracking", 1, function() -- Line: 5099
                    -- upvalues: u685 (ref), Network (ref)
                    local CFrame2 = workspace.CurrentCamera.CFrame;
                    local Unit = (CFrame2.LookVector - CFrame2.RightVector * 0.1 + CFrame2.UpVector * 0.2).Unit;
                    u685.State.MousePosition = Unit;
                    Network:FireServerConnection(`{u685.Player.Name}AzureUpdateMouse`, "REMOTE_EVENT", Unit);
                end);
                TweenService:Create(Util:CreateFOVMultiplier(u4, 1, "AzureAiming"), TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Value = 1.2
                }):Play();
            end);
        end;

        return;
    end;

    task.spawn(function() -- Line: 4687
        -- upvalues: Util (ref), u685 (copy)
        Util:LoadAnimationFromID(u685.Rig, u685.Config.Animations.GrabWindup, true);
]=], new=[=[
                        Value = 1
                    }):Play();
                    u685.State.MousePosition = p712;
                    RunService:UnbindFromRenderStep("MouseTracking");

                    return;
                end;

                spawn(function() -- Line: 5095
                    -- upvalues: __pcallMethod (ref), u685 (ref)
                    __pcallMethod("lcl_StartMouseTracking", u685);
                end);
                RunService:BindToRenderStep("MouseTracking", 1, function() -- Line: 5099
                    -- upvalues: u685 (ref), Network (ref)
                    local CFrame2 = workspace.CurrentCamera.CFrame;
                    local Unit = CFrame2.LookVector;
                    u685.State.MousePosition = Unit;
                    Network:FireServerConnection(`{u685.Player.Name}AzureUpdateMouse`, "REMOTE_EVENT", Unit);
                end);
                TweenService:Create(Util:CreateFOVMultiplier(u4, 1, "AzureAiming"), TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Value = 1.2
                }):Play();
            end);
        end;

        return;
    end;

    task.spawn(function() -- Line: 4687
        -- upvalues: Util (ref), u685 (copy)
        Util:LoadAnimationFromID(u685.Rig, u685.Config.Animations.GrabWindup, true);
]=]},
{old=[=[

            for _, v in ipairs({ v604, table.unpack(v604:GetDescendants()) }) do
                if v:IsA("BasePart") then
                    v.Transparency = 1;
                    v.CanCollide = false;
                    v.CanQuery = false;
                    v.CanTouch = false;
                end;
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
]=], new=[=[

            for _, v in ipairs({ v604, table.unpack(v604:GetDescendants()) }) do
                if v:IsA("BasePart") then
                    v.Transparency = 1;
                    v.CanCollide = false;
                    v.CanQuery = false;
                    v.CanTouch = false;
                end;
            end;

            local v607 = RaycastParams.new();
            v607.RespectCanCollide = true;
            v607.CollisionGroup = "Killers";
            v607.FilterType = Enum.RaycastFilterType.Exclude;
            v607.FilterDescendantsInstances = { workspace.Players, v604 };
            local aimDirection = u587.State.MousePosition;
            if typeof(aimDirection) ~= "Vector3" or aimDirection.Magnitude < 0.001
                or aimDirection.Magnitude ~= aimDirection.Magnitude or aimDirection.Magnitude == math.huge then
                aimDirection = u587:GetPivot().LookVector;
            end;
            aimDirection = aimDirection.Unit;
            local launchPosition = u587:GetPivot().Position + aimDirection * v601;
            u606 = Projectiles.new({
                Owner = u587.Player,
                Lifetime = v599,
                InitialCFrame = CFrame.lookAt(launchPosition, launchPosition + aimDirection),
                InitialVelocity = aimDirection * v603,
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
]=]},
{old=[=[
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
]=], new=[=[
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

                u587:PCallLocal("SetGrabSprintDisabled", false);
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
            v597.Looped = true;
            v597:Play();

            while not u587.State.GrabFireRequested and (not u587.State.GrabCancelRequested and (Util:IsAlive(u587.Rig) and not u587.Rig:GetAttribute("Stunned"))) do
                local root = u587.Rig.PrimaryPart;
                if not root then break end;
                local velocity = root.AssemblyLinearVelocity;
                local moving = Vector3.new(velocity.X, 0, velocity.Z).Magnitude > 0.5;
                v597:AdjustWeight(moving and 0 or 1, 0.1);
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

                u587:PCallLocal("SetGrabSprintDisabled", false);
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
            u587.State.MousePosition = nil;
            u587.State.LastMouseUpdate = nil;
            u587:PCallLocal("SetGrabSprintDisabled", true);
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
]=]},
{old=[=[

            TweenService:Create(u443, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
                Value = Vector3.new(0, 0, 0)
            }):Play();
            TweenService:Create(u442, TweenInfo.new(0.3), {
                Value = 1
            }):Play();
            task.delay(0.5, function() -- Line: 2833
                -- upvalues: u443 (copy), u442 (ref)
                u443:Destroy();
                u442:Destroy();
            end);
            RunService:UnbindFromRenderStep("AzureCameraUpdate");
            Attachment:Destroy();
            u441:Destroy();
            u440.Rig.Humanoid.AutoRotate = true;
        end);
    end;

    function u77.lcl_EndGrabAiming(p445, u446) -- Line: 2843
        u446.State.GrabAimingSequence = nil;
        task.delay(0.2, function() -- Line: 2845
            -- upvalues: u446 (copy)
            u446.State.GrabAimingSequence = nil;
        end);
    end;

    function u77.lcl_StartGrabAimingBeamEffect(p447, u448) -- Line: 2849
        u448.State.GrabAimingBeam = true;
        local Attachment = Instance.new("Attachment");
        local Attachment2 = Instance.new("Attachment");
]=], new=[=[

            TweenService:Create(u443, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
                Value = Vector3.new(0, 0, 0)
            }):Play();
            TweenService:Create(u442, TweenInfo.new(0.3), {
                Value = 1
            }):Play();
            task.delay(0.5, function() -- Line: 2833
                -- upvalues: u443 (copy), u442 (ref)
                u443:Destroy();
                u442:Destroy();
            end);
            RunService:UnbindFromRenderStep("AzureCameraUpdate");
            Attachment:Destroy();
            u441:Destroy();
            u440.Rig:SetAttribute("AzureGrabFacing", nil);
            local humanoid = u440.Rig:FindFirstChildOfClass("Humanoid");
            if humanoid then humanoid.AutoRotate = true end;
        end);
    end;

    function u77.lcl_EndGrabAiming(p445, u446) -- Line: 2843
        u446.State.GrabAimingSequence = nil;
        task.delay(0.2, function() -- Line: 2845
            -- upvalues: u446 (copy)
            u446.State.GrabAimingSequence = nil;
        end);
    end;

    function u77.lcl_StartGrabAimingBeamEffect(p447, u448) -- Line: 2849
        u448.State.GrabAimingBeam = true;
        local Attachment = Instance.new("Attachment");
        local Attachment2 = Instance.new("Attachment");
]=]},
{old=[=[
					if (u440.Rig.PrimaryPart.Position - child:GetPivot().Position).Magnitude >= u440.Config.Grab.HookRange or child:GetAttribute("Undetectable") then
						__pcallMethod("lcl_RemoveHighlightCharacterInReachForGrab", u440, child, true);
					else
						__pcallMethod("lcl_HighlightCharacterInReachForGrab", u440, child, true);
					end;
				end;
			end

            RunService:BindToRenderStep("AzureCameraUpdate", Enum.RenderPriority.Camera.Value + 5, function() -- Line: 2793
                -- upvalues: u440 (ref), u441 (ref), __pcallMethod (ref)
                if not (u440.Rig and u440.Rig.PrimaryPart) then
                    return;
                end;

                local LookVector = workspace.CurrentCamera.CFrame.LookVector;
                local v444 = LookVector;

                if v444 ~= v444 then
                    return;
                end;

                -- lookAt (unlike CFrame.new(pos, lookAt)) handles near-vertical aim
                -- without producing a NaN orientation.
                u441.CFrame = CFrame.lookAt(u440.Rig.PrimaryPart.Position, u440.Rig.PrimaryPart.Position + v444);

                for _, child in pairs(workspace.Players.Survivors:GetChildren()) do
                    if (u440.Rig.PrimaryPart.Position - child:GetPivot().Position).Magnitude >= u440.Config.Grab.HookRange or child:GetAttribute("Undetectable") then
                        __pcallMethod("lcl_RemoveHighlightCharacterInReachForGrab", u440, child);
                    else
                        __pcallMethod("lcl_HighlightCharacterInReachForGrab", u440, child);
                    end;
				end;
				if workspace:GetAttribute("FriendlyFire") then
]=], new=[=[
					if (u440.Rig.PrimaryPart.Position - child:GetPivot().Position).Magnitude >= u440.Config.Grab.HookRange or child:GetAttribute("Undetectable") then
						__pcallMethod("lcl_RemoveHighlightCharacterInReachForGrab", u440, child, true);
					else
						__pcallMethod("lcl_HighlightCharacterInReachForGrab", u440, child, true);
					end;
				end;
			end

            RunService:BindToRenderStep("AzureCameraUpdate", Enum.RenderPriority.Camera.Value + 5, function() -- Line: 2793
                -- upvalues: u440 (ref), u441 (ref), __pcallMethod (ref)
                if not (u440.Rig and u440.Rig.PrimaryPart) then
                    return;
                end;

                local LookVector = workspace.CurrentCamera.CFrame.LookVector;
                if os.clock() - lastAimSent >= 0.05 then
                    lastAimSent = os.clock();
                    Network:FireServerConnection(`{u440.Player.Name}AzureUpdateMouse`, "REMOTE_EVENT", LookVector);
                end;
                local v444 = Vector3.new(LookVector.X, 0, LookVector.Z);

                if v444.Magnitude < 0.001 or v444 ~= v444 then
                    return;
                end;

                -- lookAt (unlike CFrame.new(pos, lookAt)) handles near-vertical aim
                -- without producing a NaN orientation.
                u441.CFrame = CFrame.lookAt(u440.Rig.PrimaryPart.Position, u440.Rig.PrimaryPart.Position + v444);

                for _, child in pairs(workspace.Players.Survivors:GetChildren()) do
                    if (u440.Rig.PrimaryPart.Position - child:GetPivot().Position).Magnitude >= u440.Config.Grab.HookRange or child:GetAttribute("Undetectable") then
                        __pcallMethod("lcl_RemoveHighlightCharacterInReachForGrab", u440, child);
                    else
                        __pcallMethod("lcl_HighlightCharacterInReachForGrab", u440, child);
                    end;
				end;
				if workspace:GetAttribute("FriendlyFire") then
]=]},
{old=[=[
            u438:Destroy();
        end);
        p435.State.HighlightedCharacters[p436] = nil;
    end;

    function u77.lcl_StartGrabAiming(p439, u440) -- Line: 2757
        -- upvalues: Util (copy), TweenService (copy), __pcallMethod (copy), RunService (copy)
        local Attachment = Instance.new("Attachment", u440.Rig.PrimaryPart);
        local u441 = u440.Config.Instances.HomingLooker:Clone();
        u441.PrimaryAxisOnly = false;
        u441.Responsiveness = 200;
        u441.Attachment0 = Attachment;
        u441.CFrame = u440.Rig.PrimaryPart.CFrame;
        u441.Parent = u440.Rig.PrimaryPart;
        u440.State.GrabAimingSequence = true;
        u440.State.HighlightedCharacters = u440.State.HighlightedCharacters or {};
        local u442 = Util:CreateFOVMultiplier(u440.Player, 1, "AzureScopeGrab");
        TweenService:Create(u442, TweenInfo.new(1, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
            Value = 0.75
        }):Play();
        u440.LookFlag = true;
        u440.Rig.Humanoid.AutoRotate = false;
        task.spawn(function() -- Line: 2774
            -- upvalues: Util (ref), u440 (copy), TweenService (ref), __pcallMethod (ref), RunService (ref), u441 (copy), u442 (copy), Attachment (copy)
            local u443 = Util:CreateCameraOffset(u440.Rig, Vector3.new(0, 0, 0), "AzureGrabAiming");
            TweenService:Create(u443, TweenInfo.new(0.55, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
                Value = Vector3.new(2.5, 1, 0)
            }):Play();

            for _, child in pairs(workspace.Players.Survivors:GetChildren()) do
]=], new=[=[
            u438:Destroy();
        end);
        p435.State.HighlightedCharacters[p436] = nil;
    end;

    function u77.lcl_StartGrabAiming(p439, u440) -- Line: 2757
        -- upvalues: Util (copy), TweenService (copy), __pcallMethod (copy), RunService (copy)
        local Attachment = Instance.new("Attachment", u440.Rig.PrimaryPart);
        local u441 = u440.Config.Instances.HomingLooker:Clone();
        u441.PrimaryAxisOnly = false;
        u441.Responsiveness = 200;
        u441.Attachment0 = Attachment;
        u441.CFrame = u440.Rig.PrimaryPart.CFrame;
        u441.Parent = u440.Rig.PrimaryPart;
        u440.State.GrabAimingSequence = true;
        u440.Rig:SetAttribute("AzureGrabFacing", true);
        local lastAimSent = -math.huge;
        u440.State.HighlightedCharacters = u440.State.HighlightedCharacters or {};
        local u442 = Util:CreateFOVMultiplier(u440.Player, 1, "AzureScopeGrab");
        TweenService:Create(u442, TweenInfo.new(1, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
            Value = 0.75
        }):Play();
        u440.LookFlag = true;
        u440.Rig.Humanoid.AutoRotate = false;
        task.spawn(function() -- Line: 2774
            -- upvalues: Util (ref), u440 (copy), TweenService (ref), __pcallMethod (ref), RunService (ref), u441 (copy), u442 (copy), Attachment (copy)
            local u443 = Util:CreateCameraOffset(u440.Rig, Vector3.new(0, 0, 0), "AzureGrabAiming");
            TweenService:Create(u443, TweenInfo.new(0.55, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
                Value = Vector3.new(2.5, 1, 0)
            }):Play();

            for _, child in pairs(workspace.Players.Survivors:GetChildren()) do
]=]},
{old=[=[
        p373.Cache.HomingInstances = nil;
    end;

    function u77.lcl_OnHomingStart(p374, u375) -- Line: 2376
        -- upvalues: Util (copy), TweenService (copy), RunService (copy)
        local Attachment = Instance.new("Attachment", u375.Rig.PrimaryPart);
        local u376 = u375.Config.Instances.HomingLooker:Clone();
        u376.Attachment0 = Attachment;
        u376.CFrame = u375.Rig.PrimaryPart.CFrame;
        u376.Parent = u375.Rig.PrimaryPart;
        local u377 = Util:CreateFOVMultiplier(u375.Player, 1, "ScopeAzure");
        TweenService:Create(u377, TweenInfo.new(1.2, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
            Value = 0.75
        }):Play();
        u375.LookFlag = true;
        u375.Rig.Humanoid.AutoRotate = false;
        u375.Rig:SetAttribute("DirectionalMovementDisabled", true);
        task.spawn(function() -- Line: 2393
            -- upvalues: Util (ref), u375 (copy), TweenService (ref), RunService (ref), u376 (copy), u377 (copy), Attachment (copy)
            local u378 = Util:CreateCameraOffset(u375.Rig, Vector3.new(0, 0, 0), "AzureGrabAiming");
            TweenService:Create(u378, TweenInfo.new(0.3), {
                Value = Vector3.new(-2.5, 1, 0)
            }):Play();
            RunService:BindToRenderStep("AzureCameraUpdateHoming", Enum.RenderPriority.Camera.Value + 2, function() -- Line: 2400
                -- upvalues: u376 (ref), u375 (ref)
                local LookVector = workspace.CurrentCamera.CFrame.LookVector;
                local v379 = Vector3.new(LookVector.X, 0, LookVector.Z);

                if v379 ~= v379 then
                    return;
                end;

                u376.CFrame = CFrame.new(u375.Rig.PrimaryPart.Position, u375.Rig.PrimaryPart.Position + v379);
            end);

            while u375.LookFlag do
                RunService.Heartbeat:Wait();
            end;

            TweenService:Create(u378, TweenInfo.new(0.3), {
                Value = Vector3.new(0, 0, 0)
            }):Play();
            TweenService:Create(u377, TweenInfo.new(0.3), {
                Value = 1
            }):Play();
            task.delay(0.3, function() -- Line: 2422
                -- upvalues: u378 (copy), u377 (ref)
                u378:Destroy();
                u377:Destroy();
            end);
            RunService:UnbindFromRenderStep("AzureCameraUpdateHoming");
            Attachment:Destroy();
            u376:Destroy();
            u375.Rig.Humanoid.AutoRotate = true;
            u375.Rig:SetAttribute("DirectionalMovementDisabled", nil);
        end);
    end;

    function u77.lcl_InitHomingUI(p380, p381, p382) -- Line: 2434
        -- upvalues: TweenService (copy)
        local v383 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);

        for _, descendant in pairs(p382:GetDescendants()) do
            if descendant:IsA("ImageLabel") then
                local v384 = {
                    ImageTransparency = descendant.ImageTransparency
                };
                descendant.ImageTransparency = 1;
                TweenService:Create(descendant, v383, v384):Play();
]=], new=[=[
        p373.Cache.HomingInstances = nil;
    end;

    function u77.lcl_OnHomingStart(p374, u375) -- Line: 2376
        -- upvalues: Util (copy), TweenService (copy), RunService (copy)
        local Attachment = Instance.new("Attachment", u375.Rig.PrimaryPart);
        local u376 = u375.Config.Instances.HomingLooker:Clone();
        u376.Attachment0 = Attachment;
        u376.CFrame = u375.Rig.PrimaryPart.CFrame;
        u376.Parent = u375.Rig.PrimaryPart;
        local u377 = Util:CreateFOVMultiplier(u375.Player, 1, "ScopeAzure");
        TweenService:Create(u377, TweenInfo.new(1.2, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
            Value = 0.75
        }):Play();
        u375.LookFlag = true;
        u375.Rig:SetAttribute("AzureGrabFacing", true);
        u375.Rig.Humanoid.AutoRotate = false;
        u375.Rig:SetAttribute("DirectionalMovementDisabled", true);
        task.spawn(function() -- Line: 2393
            -- upvalues: Util (ref), u375 (copy), TweenService (ref), RunService (ref), u376 (copy), u377 (copy), Attachment (copy)
            local u378 = Util:CreateCameraOffset(u375.Rig, Vector3.new(0, 0, 0), "AzureGrabAiming");
            TweenService:Create(u378, TweenInfo.new(0.3), {
                Value = Vector3.new(-2.5, 1, 0)
            }):Play();
            RunService:BindToRenderStep("AzureCameraUpdateHoming", Enum.RenderPriority.Camera.Value + 2, function() -- Line: 2400
                -- upvalues: u376 (ref), u375 (ref)
                local LookVector = workspace.CurrentCamera.CFrame.LookVector;
                local v379 = Vector3.new(LookVector.X, 0, LookVector.Z);

                if v379.Magnitude < 0.001 or v379 ~= v379 then
                    return;
                end;

                u376.CFrame = CFrame.new(u375.Rig.PrimaryPart.Position, u375.Rig.PrimaryPart.Position + v379);
            end);

            while u375.LookFlag do
                RunService.Heartbeat:Wait();
            end;

            TweenService:Create(u378, TweenInfo.new(0.3), {
                Value = Vector3.new(0, 0, 0)
            }):Play();
            TweenService:Create(u377, TweenInfo.new(0.3), {
                Value = 1
            }):Play();
            task.delay(0.3, function() -- Line: 2422
                -- upvalues: u378 (copy), u377 (ref)
                u378:Destroy();
                u377:Destroy();
            end);
            RunService:UnbindFromRenderStep("AzureCameraUpdateHoming");
            Attachment:Destroy();
            u376:Destroy();
            u375.Rig:SetAttribute("AzureGrabFacing", nil);
            local humanoid = u375.Rig:FindFirstChildOfClass("Humanoid");
            if humanoid then humanoid.AutoRotate = true end;
            u375.Rig:SetAttribute("DirectionalMovementDisabled", nil);
        end);
    end;

    function u77.lcl_InitHomingUI(p380, p381, p382) -- Line: 2434
        -- upvalues: TweenService (copy)
        local v383 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);

        for _, descendant in pairs(p382:GetDescendants()) do
            if descendant:IsA("ImageLabel") then
                local v384 = {
                    ImageTransparency = descendant.ImageTransparency
                };
                descendant.ImageTransparency = 1;
                TweenService:Create(descendant, v383, v384):Play();
]=]},
{old=[=[
        -- upvalues: Util (copy), __playSound (copy)
        Util:CreateWarning("AzureBuildNo", "Move further away from your other plants.");
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
]=], new=[=[
        -- upvalues: Util (copy), __playSound (copy)
        Util:CreateWarning("AzureBuildNo", "Move further away from your other plants.");
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

    function u77.lcl_SetGrabSprintDisabled(_, actor, disabled)
        actor.Cache = actor.Cache or {}
        if disabled then
            actor.Cache.AzureGrabResumeSprint = actor.Cache.AzureGrabResumeSprint or Sprinting.IsSprinting
        end
        Network:FireConnection("DisableSprinting", "AzureGrab", disabled)
        if not disabled then
            local resumeMobile = actor.Cache.AzureGrabResumeSprint
            actor.Cache.AzureGrabResumeSprint = nil
            if Sprinting.CanSprint and Sprinting.BindsEnabled then
                if Device:GetPlayerDevice() == "Mobile" then
                    if resumeMobile and not Sprinting.IsSprinting and Sprinting.__sprintHandler then
                        Sprinting.__sprintHandler("Sprinting", Enum.UserInputState.Begin)
                    end
                else
                    Sprinting:SyncHeldKey()
                end
            end
        end
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
]=]},
{old=[=[
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
]=], new=[=[
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
        if phase == "pull" or phase == "success" or phase == "hold" or phase == "release" then
            safe(function() actor:SetCooldownOf("Grab", grab.CooldownMiss) end)
        end
        -- detach() can run at release, so destroy flight-only effects separately.
        for _, object in objects do safe(function() object:Destroy() end) end
        cleanup()
        if not ok then warn("[Azure Enstrangle] " .. tostring(err)) end
    end;

    function u77.sv_MissGrab(p255, p256) -- Line: 1782
        -- upvalues: Util (copy)
        p256:PCallLocal("SetGrabSprintDisabled", false);
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
]=]},
{old=[=[
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
]=], new=[=[
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
            load("GrabVictimHooked", victim):Play(0.025)
            load("GrabPullingLoop", rig):Play(0.025)
            local pullStart = os.clock()
            while valid() and os.clock() - pullStart < grab.PullTime do
                pull(os.clock() - pullStart)
                task.wait()
            end
            if not valid() then return end
            attachment.CFrame = offset
            tracks.GrabVictimHooked:Stop(0.05)
            tracks.GrabPullingLoop:Stop(0.05)
            phase = "success"
            actor:PCallLocal("SetGrabSprintDisabled", true)
            frozen = true
            freeze = Util:CreateSpeedMultiplier(rig, 0, "AzureGrabSuccess")
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
            root.Anchored = true
            humanoid.AutoRotate = false
            Util:GiveInvincible(rig, invincibleKey)
            local success = load("GrabShootSuccess", rig)
            load("GrabVictimSuccess", victim):Play(0.025)
            if not waitTrack(success, grab.SuccessAnimationTimeout or 8) then return end
            tracks.GrabShootSuccess:Stop(0.05)
            tracks.GrabVictimSuccess:Stop(0.05)
            unfreeze()
            invincibleUntil = os.clock() + 0.5
            task.delay(0.5, function() safe(function() Util:RemoveInvincible(rig, invincibleKey) end) end)
            phase = "hold"
            actor.DisabledAbilities = {Sow = true, Blossom = true, Unravel = true}
            actor:PCallLocal("SetGrabAbilityLocks", true, false)
            actor:PCallLocal("SetGrabSprintDisabled", false)
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
]=]},
{old=[=[
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
]=], new=[=[
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
            actor:PCallLocal("SetGrabSprintDisabled", false)
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
]=]},
{old=[=[
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
]=], new=[=[
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
            safe(function() actor:PCallLocal("SetGrabSprintDisabled", false) end)
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
            track.Looped = name:match("Idle$") ~= nil or name:match("Walk$") ~= nil
                or name:match("Run$") ~= nil or name == "GrabPullingLoop" or name == "GrabVictimHooked"
            track.Priority = Enum.AnimationPriority.Action
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
]=]}
}},
{path={"Assets","Killers","Azure","Config"}, checksum=2507959074, edits={
{old=[=[
	PlacementYFactor = 0.2,
	CrackVisualiserOptions = {
		DivotSize = 3,
		DivotSizeDeviance = 0.25,
		DivotDepth = 0,
		WidthDeviance = 0.12,
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
]=], new=[=[
	PlacementYFactor = 0.2,
	CrackVisualiserOptions = {
		DivotSize = 3,
		DivotSizeDeviance = 0.25,
		DivotDepth = 0,
		WidthDeviance = 0.12,
		WidthMultiplier = 0.5,
		Tweens = true,
		AwayRotation = -45,
		AwayRotationDeviance = 1,
		RandomRotation = 25,
		TimeInterval = 0.013,
		TweenConfig = TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
	},
	Animations = {
		Idle = "rbxassetid://92919132424278",
		Walk = "rbxassetid://120805025753869",
		Run = "rbxassetid://105801510327298",
		InjuredIdle = "rbxassetid://130212214475523",
		InjuredWalk = "rbxassetid://120805025753869",
		InjuredRun = "rbxassetid://105801510327298",
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
]=]}
}},
{path={"Systems","Player","Game","SmoothShiftLock"}, checksum=2251790398, edits={
{old=[=[
    return v37.Enabled;
end;
v0.ToggleShiftLock = function(v38, v39) --[[ Line: 211 ]] --[[ Name: ToggleShiftLock ]]
    -- upvalues: l_RunService_0 (copy), v10 (copy), l_CurrentCamera_0 (copy)
    if v39 ~= nil then
        v38.Enabled = v39;
    else
        v38.Enabled = not v38.Enabled;
    end;
    v38:_updateMouseState();
    v38:_updateMouseIcon();
    v38:_transitionLockOffset();
    if v38.Enabled then
        v38._shiftlockMaid:GiveTask(l_RunService_0.RenderStepped:Connect(function(v40) --[[ Line: 222 ]]
            -- upvalues: v38 (copy), v10 (ref), l_CurrentCamera_0 (ref)
            if v38.Humanoid and v38.RootPart then
                v38.Humanoid.AutoRotate = not v38.Enabled;
            end;
            if v38.Humanoid.Sit then
                return;
            elseif v38.RootPart.Anchored then
                return;
            elseif v38.Character:GetAttribute("Ragdolling") then
                return;
            elseif v10.SMOOTH_CHARACTER_ROTATION then
                local _, v42, _ = l_CurrentCamera_0.CFrame:ToOrientation();
                v38.RootPart.CFrame = v38.RootPart.CFrame:Lerp(CFrame.new(v38.RootPart.Position) * CFrame.Angles(0, v42, 0), v40 * 5 * v10.CHARACTER_ROTATION_SPEED);
                return;
            else
                local _, v45, _ = l_CurrentCamera_0.CFrame:ToOrientation();
                v38.RootPart.CFrame = CFrame.new(v38.RootPart.Position) * CFrame.Angles(0, v45, 0);
                return;
            end;
        end));
        return;
    else
        v38.Humanoid.AutoRotate = true;
        v38._shiftlockMaid:DoCleaning();
        return;
    end;
end;
return v0;]=], new=[=[
    return v37.Enabled;
end;
v0.ToggleShiftLock = function(v38, v39) --[[ Line: 211 ]] --[[ Name: ToggleShiftLock ]]
    -- upvalues: l_RunService_0 (copy), v10 (copy), l_CurrentCamera_0 (copy)
    if v39 ~= nil then
        v38.Enabled = v39;
    else
        v38.Enabled = not v38.Enabled;
    end;
    v38:_updateMouseState();
    v38:_updateMouseIcon();
    v38:_transitionLockOffset();
    if v38.Enabled then
        v38._shiftlockMaid:GiveTask(l_RunService_0.RenderStepped:Connect(function(v40) --[[ Line: 222 ]]
            -- upvalues: v38 (copy), v10 (ref), l_CurrentCamera_0 (ref)
            if not (v38.Humanoid and v38.RootPart and v38.Character) then return end;
            -- Enstrangle owns facing during aim/hold and anchors during its grab cutscene.
            if v38.Character:GetAttribute("AzureGrabFacing") or v38.RootPart.Anchored then return end;
            v38.Humanoid.AutoRotate = not v38.Enabled;
            if v38.Humanoid.Sit then
                return;
            elseif v38.RootPart.Anchored then
                return;
            elseif v38.Character:GetAttribute("Ragdolling") then
                return;
            elseif v10.SMOOTH_CHARACTER_ROTATION then
                local _, v42, _ = l_CurrentCamera_0.CFrame:ToOrientation();
                v38.RootPart.CFrame = v38.RootPart.CFrame:Lerp(CFrame.new(v38.RootPart.Position) * CFrame.Angles(0, v42, 0), v40 * 5 * v10.CHARACTER_ROTATION_SPEED);
                return;
            else
                local _, v45, _ = l_CurrentCamera_0.CFrame:ToOrientation();
                v38.RootPart.CFrame = CFrame.new(v38.RootPart.Position) * CFrame.Angles(0, v45, 0);
                return;
            end;
        end));
        return;
    else
        if v38.Humanoid and not (v38.Character and v38.Character:GetAttribute("AzureGrabFacing"))
            and not (v38.RootPart and v38.RootPart.Anchored) then
            v38.Humanoid.AutoRotate = true;
        end;
        v38._shiftlockMaid:DoCleaning();
        return;
    end;
end;
return v0;]=]},
{old=[=[
    v27:_refreshCharacterVariables();
    v27._runtimeMaid:GiveTask(l_LocalPlayer_0.CharacterAdded:Connect(function() --[[ Line: 131 ]]
        -- upvalues: v27 (copy)
        v27:_refreshCharacterVariables();
    end));
    v0:BindKeybinds();
    v27._runtimeMaid:GiveTask(l_RunService_0.RenderStepped:Connect(function() --[[ Line: 139 ]]
        -- upvalues: v27 (copy), l_CurrentCamera_0 (ref), l_UserInputService_0 (ref)
		if not v27.Character:GetAttribute("CustomRig") and v27.Head and v27.Head.LocalTransparencyModifier > 0.6 then
            return;
        elseif l_CurrentCamera_0.CameraType ~= Enum.CameraType.Custom then
            return;
        else
            local l_CoordinateFrame_0 = l_CurrentCamera_0.CoordinateFrame;
            if (v27.Head.Position - l_CoordinateFrame_0.p).magnitude > 1 then
                l_CurrentCamera_0.CFrame = l_CurrentCamera_0.CFrame * CFrame.new(v27._cameraOffsetSpring.Position);
                if v27.Enabled and l_UserInputService_0.MouseBehavior ~= Enum.MouseBehavior.LockCenter then
                    v27:_updateMouseState();
                end;
            end;
            return;
        end;
    end));
end;
v0.Disable = function(v29) --[[ Line: 158 ]] --[[ Name: Disable ]]
    -- upvalues: l_ContextActionService_0 (copy)
    v29._runtimeMaid:DoCleaning();
    v29._shiftlockMaid:DoCleaning();
    l_ContextActionService_0:UnbindAction("ShiftLockSwitchAction");
end;
v0._refreshCharacterVariables = function(v30) --[[ Line: 167 ]] --[[ Name: _refreshCharacterVariables ]]
]=], new=[=[
    v27:_refreshCharacterVariables();
    v27._runtimeMaid:GiveTask(l_LocalPlayer_0.CharacterAdded:Connect(function() --[[ Line: 131 ]]
        -- upvalues: v27 (copy)
        v27:_refreshCharacterVariables();
    end));
    v0:BindKeybinds();
    v27._runtimeMaid:GiveTask(l_RunService_0.RenderStepped:Connect(function() --[[ Line: 139 ]]
        -- upvalues: v27 (copy), l_CurrentCamera_0 (ref), l_UserInputService_0 (ref)
		if not v27.Character:GetAttribute("CustomRig") and v27.Head and v27.Head.LocalTransparencyModifier > 0.6 then
            return;
        elseif l_CurrentCamera_0.CameraType ~= Enum.CameraType.Custom then
            return;
        else
            local l_CoordinateFrame_0 = l_CurrentCamera_0.CoordinateFrame;
            if (v27.Head.Position - l_CoordinateFrame_0.p).magnitude > 1 then
                if not v27.Character:GetAttribute("AzureGrabFacing") then
                    l_CurrentCamera_0.CFrame = l_CurrentCamera_0.CFrame * CFrame.new(v27._cameraOffsetSpring.Position);
                end;
                if v27.Enabled and l_UserInputService_0.MouseBehavior ~= Enum.MouseBehavior.LockCenter then
                    v27:_updateMouseState();
                end;
            end;
            return;
        end;
    end));
end;
v0.Disable = function(v29) --[[ Line: 158 ]] --[[ Name: Disable ]]
    -- upvalues: l_ContextActionService_0 (copy)
    v29._runtimeMaid:DoCleaning();
    v29._shiftlockMaid:DoCleaning();
    l_ContextActionService_0:UnbindAction("ShiftLockSwitchAction");
end;
v0._refreshCharacterVariables = function(v30) --[[ Line: 167 ]] --[[ Name: _refreshCharacterVariables ]]
]=]}
}}
}
local prepared = {}
for _, change in changes do
    local module = resolve(change.path)
    local original = read(module)
    local source = normalize(original)
    assert(checksum(source) == change.checksum,
        "Source differs from the expected installed Enstrangle update (or follow-up already applied): " .. module:GetFullName() .. ". No changes applied.")
    for _, edit in change.edits do
        local first,last = string.find(source, edit.old, 1, true)
        assert(first and not string.find(source, edit.old, last+1, true), "Patch anchor missing/ambiguous. No changes applied.")
        source = string.sub(source,1,first-1) .. edit.new .. string.sub(source,last+1)
    end
    table.insert(prepared, {module=module, original=original, updated=source, path=change.path})
end
local backup = Instance.new("Folder")
backup.Name = "AzureControlsBackup_" .. os.time()
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
print("Azure controls/timing follow-up installed (3 modules). Backup: ServerStorage." .. backup.Name)
print("Playtest: hold Shift through catch, toggle shift-lock while aiming up/down, walk while aiming, pull -> success -> hold, manual/auto throw, reset/despawn.")
