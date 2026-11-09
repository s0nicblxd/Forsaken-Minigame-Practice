-- AZURE GRAB DELAY AND RESET CLEANUP — 2026-11-09
-- Stop Play. Open the newest FCF place, then paste this ENTIRE file into
-- Studio's Command Bar and press Enter. No HTTP requests or downloads are used.
-- Requires the controls/timing follow-up installed. Changes ONLY Azure.Behavior.
-- Checks your source before editing. If it differs, NOTHING is changed.
-- Keeps animation IDs, grab timings, sprint rules, shift-lock fix and Oblation unchanged.
-- Backup: ServerStorage.AzureGrabCleanupBackup_<timestamp> (chunked full source).
-- To restore: set RESTORE_BACKUP below to that folder's exact name and run this file again.
-- Restore overwrites only the backed-up module with their pre-patch source.
-- Website/main branch are unaffected.
--
-- Includes: remove ten-second missing-SpeedMultipliers wait on hit; non-yielding
-- animation loading; immediate death/despawn cleanup; destroy owned animation
-- tracks and resume normal client movement animations after cancellation.
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
{path={"Assets","Killers","Azure","Behavior"}, checksum=2378030271, edits={
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
        __pcallMethod("lcl_ResetGrabVisuals", p735);
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
]=]},
{old=[=[
                        __pcallMethod("lcl_HighlightCharacterInReachForGrab", u440, child);
                    end;
				end;
				if workspace:GetAttribute("FriendlyFire") then
					for _, child in pairs(workspace.Players.Killers:GetChildren()) do
						if child == u440.Rig then continue end
						if (u440.Rig:GetPivot().Position - child:GetPivot().Position).Magnitude >= u440.Config.Grab.HookRange or child:GetAttribute("Undetectable") then
							__pcallMethod("lcl_RemoveHighlightCharacterInReachForGrab", u440, child);
						else
							__pcallMethod("lcl_HighlightCharacterInReachForGrab", u440, child);
						end;
					end;
				end
            end);

            while u440.State.GrabAimingSequence == true do
                RunService.Heartbeat:Wait();
            end;

            for i, _ in pairs(u440.State.HighlightedCharacters) do
                __pcallMethod("lcl_RemoveHighlightCharacterInReachForGrab", u440, i);
            end;

            TweenService:Create(u443, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
                Value = Vector3.new(0, 0, 0)
            }):Play();
            TweenService:Create(u442, TweenInfo.new(0.3), {
                Value = 1
            }):Play();
            task.delay(0.5, function() -- Line: 2833
                -- upvalues: u443 (copy), u442 (ref)
]=], new=[=[
                        __pcallMethod("lcl_HighlightCharacterInReachForGrab", u440, child);
                    end;
				end;
				if workspace:GetAttribute("FriendlyFire") then
					for _, child in pairs(workspace.Players.Killers:GetChildren()) do
						if child == u440.Rig then continue end
						if (u440.Rig:GetPivot().Position - child:GetPivot().Position).Magnitude >= u440.Config.Grab.HookRange or child:GetAttribute("Undetectable") then
							__pcallMethod("lcl_RemoveHighlightCharacterInReachForGrab", u440, child);
						else
							__pcallMethod("lcl_HighlightCharacterInReachForGrab", u440, child);
						end;
					end;
				end
            end);

            while u440.State.GrabAimingSequence == true and u440.Rig:IsDescendantOf(workspace) do
                RunService.Heartbeat:Wait();
            end;

            for i, _ in pairs(u440.State.HighlightedCharacters) do
                __pcallMethod("lcl_RemoveHighlightCharacterInReachForGrab", u440, i);
            end;

            TweenService:Create(u443, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
                Value = Vector3.new(0, 0, 0)
            }):Play();
            TweenService:Create(u442, TweenInfo.new(0.3), {
                Value = 1
            }):Play();
            task.delay(0.5, function() -- Line: 2833
                -- upvalues: u443 (copy), u442 (ref)
]=]},
{old=[=[
        v398.Attachment1 = Attachment2;
        local v402 = {};
        local v403 = 0;

        for _, descendant in ipairs(p397.Rig:GetDescendants()) do
            if descendant:IsA("BasePart") then
                table.insert(v402, descendant);
            end;
        end;

        local v404 = 0;

        while p397.State and p397.State.TrackingMousePosition do
            if p397.State.MousePosition then
                local v405 = p397.State.GrabbedRoot or p397.Rig.PrimaryPart;
                local _, v406, v407, v408, v409 = getTrajectoryPoints(Vector3.new(0, 1, 0) * -v400, (p397.State.MousePosition or Vector3.new(0, 0, 1)).Unit * ThrowVelocity, v405.CFrame.Position, v401);
                local v410 = math.max(0, 0.75 - v404);
                v404 = v404 + math.clamp(v403 * 2, 0, v410);
                Attachment.Parent = v405;
                v398.CurveSize0 = v406;
                v398.CurveSize1 = v407;
                Attachment.CFrame = Attachment.Parent.CFrame:inverse() * v408;
                Attachment2.CFrame = Attachment2.Parent.CFrame:inverse() * v409;
                v399:PivotTo(v409);
                v403 = task.wait();
            else
                task.wait();
            end;
        end;

]=], new=[=[
        v398.Attachment1 = Attachment2;
        local v402 = {};
        local v403 = 0;

        for _, descendant in ipairs(p397.Rig:GetDescendants()) do
            if descendant:IsA("BasePart") then
                table.insert(v402, descendant);
            end;
        end;

        local v404 = 0;

        while p397.State and p397.State.TrackingMousePosition do
            if p397.State.MousePosition then
                local v405 = p397.State.GrabbedRoot or p397.Rig.PrimaryPart;
                if not v405 or not v405.Parent then break end;
                local _, v406, v407, v408, v409 = getTrajectoryPoints(Vector3.new(0, 1, 0) * -v400, (p397.State.MousePosition or Vector3.new(0, 0, 1)).Unit * ThrowVelocity, v405.CFrame.Position, v401);
                local v410 = math.max(0, 0.75 - v404);
                v404 = v404 + math.clamp(v403 * 2, 0, v410);
                Attachment.Parent = v405;
                v398.CurveSize0 = v406;
                v398.CurveSize1 = v407;
                Attachment.CFrame = Attachment.Parent.CFrame:inverse() * v408;
                Attachment2.CFrame = Attachment2.Parent.CFrame:inverse() * v409;
                v399:PivotTo(v409);
                v403 = task.wait();
            else
                task.wait();
            end;
        end;

]=]},
{old=[=[
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
]=], new=[=[
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

            while u375.LookFlag and u375.Rig:IsDescendantOf(workspace) do
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

    function u77.lcl_ResetGrabVisuals(_, actor)
        if actor.State then
            actor.State.GrabAimingSequence = nil
            actor.State.GrabAimingBeam = nil
            actor.State.TrackingMousePosition = nil
            actor.State.GrabbedRoot = nil
        end
        actor.LookFlag = nil
        RunService:UnbindFromRenderStep("MouseTracking")
        local rig = actor.Rig
        local hum = rig and rig:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        rig:SetAttribute("AzureGrabFacing", nil)
        rig:SetAttribute("DirectionalMovementDisabled", nil)
        rig:SetAttribute("MoveAnimationOverwrite", nil)
        local animator = hum:FindFirstChildOfClass("Animator")
        if animator then
            local ids = {}
            for name, id in actor.Config.Animations do
                if name:match("^Grab") and typeof(id) == "string" then ids[id] = true end
            end
            for _, track in animator:GetPlayingAnimationTracks() do
                if track.Animation and ids[track.Animation.AnimationId] then track:Stop(0) end
            end
        end
        if actor.Destroyed or hum.Health <= 0 or not rig:IsDescendantOf(workspace) then return end
        local shiftLock = require(ReplicatedStorage.Systems.Player.Game.SmoothShiftLock)
        hum.AutoRotate = not shiftLock:IsEnabled()
        actor.Moving = nil
        if actor.AnimationType == false or rig:GetAttribute("Ragdolling") then return end
        local prefix = actor.AnimationType or (hum.Health - (hum:GetAttribute("FakeDamage") or 0) <= hum.MaxHealth / 2 and "Injured" or "")
        local root = rig.PrimaryPart
        local moving = root and Vector3.new(root.AssemblyLinearVelocity.X, 0, root.AssemblyLinearVelocity.Z).Magnitude > 0.5
        local name = moving and (Sprinting.IsSprinting and "Run" or "Walk") or "Idle"
        local track = actor.Animations and actor.Animations[prefix .. name]
        if track and not track.IsPlaying then track:Play(0.1) end
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
]=]},
{old=[=[
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
]=], new=[=[
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
            freeze = speedLock(rig, "AzureGrabSuccess")
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
]=]},
{old=[=[
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
            local victimAttachment = own(Instance.new("Attachment", victimRoot))
]=], new=[=[
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
            victimSpeed = speedLock(victim, "AzureGrab")
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
]=]},
{old=[=[
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
]=], new=[=[
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
            for _, track in tracks do
                safe(function() track:Stop(0); track:Destroy() end)
            end
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
            safe(function() actor:PCallLocal("SetGrabSprintDisabled", false) end)
            safe(function() Network:FireClientConnection(actor.Player, "SetTrackingMousePosition", "REMOTE_EVENT", Vector3.new(0, 0, -1)) end)
            safe(function() actor:PCallAllClients("OnHomingStopped") end)
            safe(function() actor:PCallLocal("OnHomingStopped") end)
            safe(function() actor:PCallAllClients("OnThrowEnded", victim) end)
            safe(function() actor:PCallLocal("ResetGrabVisuals") end)
            if ragdolled and phase ~= "impact" and alive(victim) then
                safe(function() Ragdolls.DisableRagdoll(victim) end)
            end
        end
        actor.State.GrabbingFlag = true
        actor.State.ThrowRequest = nil -- firing clicks must never queue an early throw
        actor.State.AzureGrabCleanup = cleanup
        -- Reset/despawn must release the grab even if an unrelated callback stalls.
        for _, model in {rig, victim} do
            table.insert(connections, model.Destroying:Connect(cleanup))
            table.insert(connections, model.AncestryChanged:Connect(function()
                if not model:IsDescendantOf(workspace) then cleanup() end
            end))
            local hum = model:FindFirstChildOfClass("Humanoid")
            table.insert(connections, hum.Died:Connect(cleanup))
        end

        local function load(name, model)
            assert(valid(), "Grab cancelled before loading animation")
            local hum = model:FindFirstChildOfClass("Humanoid")
            assert(hum, "Grab rig has no Humanoid")
            local animator = hum:FindFirstChildOfClass("Animator")
            if not animator then
                animator = Instance.new("Animator")
                animator.Parent = hum
            end
            local animation = Instance.new("Animation")
            animation.AnimationId = actor.Config.Animations[name]
            local success, track = pcall(function() return animator:LoadAnimation(animation) end)
            animation:Destroy()
            assert(success and track, "Unable to load " .. name .. ": " .. tostring(track))
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
]=]},
{old=[=[
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
]=], new=[=[
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
        local function speedLock(model, name)
            assert(valid(), "Grab cancelled before applying movement lock")
            local folder = model:FindFirstChild("SpeedMultipliers")
            if not folder then
                folder = Instance.new("Folder")
                folder.Name = "SpeedMultipliers"
                folder.Parent = model
            end
            local previous = folder:FindFirstChild(name)
            if previous then previous:Destroy() end
            local value = Instance.new("NumberValue")
            value.Name = name
            value.Value = 0
            value.Parent = folder
            return value
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
]=]}
}}
}
local prepared = {}
for _, change in changes do
    local module = resolve(change.path)
    local original = read(module)
    local source = normalize(original)
    assert(checksum(source) == change.checksum,
        "Source differs from the expected controls/timing follow-up (or follow-up already applied): " .. module:GetFullName() .. ". No changes applied.")
    for _, edit in change.edits do
        local first,last = string.find(source, edit.old, 1, true)
        assert(first and not string.find(source, edit.old, last+1, true), "Patch anchor missing/ambiguous. No changes applied.")
        source = string.sub(source,1,first-1) .. edit.new .. string.sub(source,last+1)
    end
    table.insert(prepared, {module=module, original=original, updated=source, path=change.path})
end
local backup = Instance.new("Folder")
backup.Name = "AzureGrabCleanupBackup_" .. os.time()
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
print("Azure grab delay/reset fix installed (Behavior only). Backup: ServerStorage." .. backup.Name)
print("Playtest: hit a bot, confirm immediate pulling; despawn/reset victim during pull, success, hold and throw; then walk/run and grab again.")
