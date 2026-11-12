-- AZURE CONSOLIDATED UPDATE FOR YOUR UPLOADED STUDIO BEHAVIOR
-- Stop Play. Copy this ENTIRE file into Studio's Command Bar and run.
-- No earlier installer needs to be run first: targets your uploaded source.
-- Azure.Behavior only. Does not overwrite Config, animation IDs or sv_Vine.
-- Adds held-victim cancel (Helpless 2s), restores landing hitbox display,
-- close impact Helpless 4s / Slowness II 2s with refreshed expiry timers,
-- immediate normal stamina regeneration on release, and 1.5x Golem exit.
-- Preserves the Golem return failsafe and 5s transformation invincibility.
-- Backup: ServerStorage.AzureConsolidatedBackup_<timestamp>.
-- Set RESTORE_BACKUP to the folder name below to restore the exact old source.
-- Re-running the installed update is a no-op with an 'already installed' message.
-- Compiled and mock-tested; live Studio verification still required.
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
{path={"Assets","Killers","Azure","Behavior"}, checksum=2801253741, edits={
{old=[=[
        Icon = "rbxassetid://115907381502841",
        KeybindType = "AltAbility3",
        Cooldown = 1,
        Name = "Enstrangle",

        Callback = function(u587, p588) -- Line: 3759, Name: Callback
            -- upvalues: u2 (copy), Util (copy), Sounds (copy), __pcallMethod (copy), ReplicatedStorage (copy), Projectiles (copy), u77 (copy)
            local Grab = u587.Config.Grab;

            if not u2 then
                return;
            end;

            if u587.State.GrabbingFlag == true then
                if u587.State.ThrowRequest == false then
                    u587.State.ThrowRequest = true;
                end;

                return;
            end;

            if u587.State.GrabWindingUp then
                u587.State.GrabCancelRequested = true;

                return;
            end;

            if u587.State.ControllingGolem then
                return nil;
            end;

]=], new=[=[
        Icon = "rbxassetid://115907381502841",
        KeybindType = "AltAbility3",
        Cooldown = 1,
        Name = "Enstrangle",

        Callback = function(u587, p588) -- Line: 3759, Name: Callback
            -- upvalues: u2 (copy), Util (copy), Sounds (copy), __pcallMethod (copy), ReplicatedStorage (copy), Projectiles (copy), u77 (copy)
            local Grab = u587.Config.Grab;

            if not u2 then
                return;
            end;

            if u587.State.GrabbingFlag == true then
                if u587.State.ThrowRequest == false then
                    u587.State.ThrowRequest = "Cancel";
                end;

                return;
            end;

            if u587.State.GrabWindingUp then
                u587.State.GrabCancelRequested = true;

                return;
            end;

            if u587.State.ControllingGolem then
                return nil;
            end;

]=]},
{old=[=[
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
]=], new=[=[
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
            while valid() and actor.State.ThrowRequest == false and os.clock() - holdStart < grab.HoldMaxDuration do
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
            local cancelled = actor.State.ThrowRequest == "Cancel"
            actor.State.ThrowRequest = nil
            actor:PCallAllClients("OnHomingStopped")
            actor:PCallLocal("OnHomingStopped")
            if not valid() then return end
            if cancelled then
                -- Drop from the held position; no throw animation, launch or impact.
                phase = "cancelled"
                detach()
                victimRoot.AssemblyLinearVelocity = Vector3.zero
                victimRoot.AssemblyAngularVelocity = Vector3.zero
                actor:SetCooldownOf("Grab", grab.CooldownCancel or grab.CooldownMiss)
                cleanup() -- restore movement/stamina before applying the exit penalty
                local helpless = Statuses:ApplyStatus(rig, "Helpless", {Level = 1, Duration = 2})
                if helpless then helpless.TimeRequired = 2 end
                return
            end
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
            actor:PCallLocal("SetGrabStaminaRegenReduction", false)
            rig:SetAttribute("MoveAnimationOverwrite", nil)
            actor:PCallLocal("SetGrabAbilityLocks", false)
            actor.AbilitiesDisabled = false
            actor.DisabledAbilities = {}
            actor:SetCooldownOf("Grab", grab.CooldownSuccess)
            local releasedAt = os.clock()
            local helpless = Statuses:ApplyStatus(rig, "Helpless", {Level = 1, Duration = grab.ThrowHelpless or 2})
            if helpless then helpless.TimeRequired = grab.ThrowHelpless or 2 end
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
]=]},
{old=[=[
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
]=], new=[=[
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
            -- Match the normal Show Hitboxes folder/visibility convention.
            -- This is display only; the radius check below remains authoritative.
            local hitboxFolder = workspace:FindFirstChild("Hitboxes")
            if hitboxFolder then
                local display = Instance.new("Part")
                display.Name = tostring(actor.Player) .. "Hitbox"
                display.Shape = Enum.PartType.Ball
                display.Size = Vector3.new(1, 1, 1) * grab.BlastRadius * 2
                display.CFrame = CFrame.new(position)
                display.Color = Color3.new(0.5, 1, 0.5)
                display.Transparency = 1
                display.Anchored = true
                display.CanCollide = false
                display.CanTouch = false
                display.CanQuery = false
                display.CastShadow = false
                display.Parent = hitboxFolder
                Debris:AddItem(display, 0.36)
            end
            phase = "impact"
            local close = (position - root.Position).Magnitude <= (grab.CloseThrowDistance or 20)
            if close then
                local helpless = Statuses:ApplyStatus(rig, "Helpless", {
                    Level = 1, Duration = grab.CloseThrowHelpless or 4
                })
                -- This build does not refresh TimeRequired on an existing status.
                if helpless then helpless.TimeRequired = grab.CloseThrowHelpless or 4 end
                local slowness = Statuses:ApplyStatus(rig, "Slowness", {Level = 2, Duration = 2})
                if slowness then slowness.TimeRequired = 2 end
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
]=]},
{old=[=[
                if not ok then warn("[Azure return] Physics handoff: " .. tostring(err)) end
            end
        end
        Util:GiveStackableProperty(root, "Anchored", key)
        -- Install the failsafe BEFORE loading/playing anything.
        task.delay(5, release)
        died = humanoid.Died:Connect(release)
        local animator = humanoid:FindFirstChildOfClass("Animator")
        if not animator then release(); return end
        local animation = Instance.new("Animation")
        animation.AnimationId = u128.Config.Animations.GolemStateExit
        local ok, err = pcall(function()
            track = animator:LoadAnimation(animation)
            track.Looped = false
            stopped = track.Stopped:Connect(release)
            track:Play(0)
        end)
        animation:Destroy()
        if not ok then
            release()
            warn("[Azure return] Exit animation failed: " .. tostring(err))
        end
    end;

    function u77.sv_DestroyGolemStatue(p131, p132, p133) -- Line: 569
        p133:Destroy();
    end;

    local function sv_getGolemTransferCooldown(p134) -- Line: 573
        return p134.Config.Golem.TransferCooldown or (p134.Config.GolemTransferCooldown or 3);
    end;
]=], new=[=[
                if not ok then warn("[Azure return] Physics handoff: " .. tostring(err)) end
            end
        end
        Util:GiveStackableProperty(root, "Anchored", key)
        -- Install the failsafe BEFORE loading/playing anything.
        task.delay(5, release)
        died = humanoid.Died:Connect(release)
        local animator = humanoid:FindFirstChildOfClass("Animator")
        if not animator then release(); return end
        local animation = Instance.new("Animation")
        animation.AnimationId = u128.Config.Animations.GolemStateExit
        local ok, err = pcall(function()
            track = animator:LoadAnimation(animation)
            track.Looped = false
            stopped = track.Stopped:Connect(release)
            track:Play(0, 1, 1.5)
        end)
        animation:Destroy()
        if not ok then
            release()
            warn("[Azure return] Exit animation failed: " .. tostring(err))
        end
    end;

    function u77.sv_DestroyGolemStatue(p131, p132, p133) -- Line: 569
        p133:Destroy();
    end;

    local function sv_getGolemTransferCooldown(p134) -- Line: 573
        return p134.Config.Golem.TransferCooldown or (p134.Config.GolemTransferCooldown or 3);
    end;
]=]}
}}
}
local installed = resolve(changes[1].path)
if checksum(normalize(read(installed))) == 2153524339 then
    print("Azure consolidated update is already installed. No changes needed.")
    return
end
local prepared = {}
for _, change in changes do
    local module = resolve(change.path)
    local original = read(module)
    local source = normalize(original)
    assert(checksum(source) == change.checksum,
        "Source differs from your latest uploaded Behavior: " .. module:GetFullName() .. ". No changes applied.")
    for _, edit in change.edits do
        local first,last = string.find(source, edit.old, 1, true)
        assert(first and not string.find(source, edit.old, last+1, true), "Patch anchor missing/ambiguous. No changes applied.")
        source = string.sub(source,1,first-1) .. edit.new .. string.sub(source,last+1)
    end
    table.insert(prepared, {module=module, original=original, updated=source, path=change.path})
end
local backup = Instance.new("Folder")
backup.Name = "AzureConsolidatedBackup_" .. os.time()
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
print("Azure consolidated update installed successfully (Azure.Behavior). Backup: ServerStorage." .. backup.Name)
print("Playtest: cancel gives 2s Helpless; stamina regeneration returns at release; close throw gives 4s Helpless and 2s Slowness; Golem exit plays at 1.5x.")
