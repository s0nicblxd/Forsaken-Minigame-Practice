-- AZURE THROW DISPLAY, CLOSE PENALTIES AND HOLD CANCEL
-- Requires the Golem/Vine/5s Inflorescence patch. Stop Play and paste this
-- entire file into Studio's Command Bar. Updates Azure.Behavior only.
-- Enstrangle while carrying drops the victim; Perforating/auto-timeout throw.
-- Drop: Helpless 2s, cancel cooldown. Close impact: Helpless 4s, Slowness II 2s.
-- Restores landing sphere through the existing Show Hitboxes setting.
-- Backup: ServerStorage.AzureDropBackup_<timestamp>. To restore, set
-- RESTORE_BACKUP below to that backup folder's name and run again.
-- Compiled and mock-tested; live Studio playtest still required.
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
                Statuses:ApplyStatus(rig, "Helpless", {Level = 1, Duration = 2})
                return -- shared cleanup restores victim movement and both actors' locks
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
                Statuses:ApplyStatus(rig, "Helpless", {
                    Level = 1, Duration = grab.CloseThrowHelpless or 4
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
]=]}
}}
}
local prepared = {}
for _, change in changes do
    local module = resolve(change.path)
    local original = read(module)
    local source = normalize(original)
    assert(checksum(source) == change.checksum,
        "Source differs from the uploaded Behavior (or follow-up already applied): " .. module:GetFullName() .. ". No changes applied.")
    for _, edit in change.edits do
        local first,last = string.find(source, edit.old, 1, true)
        assert(first and not string.find(source, edit.old, last+1, true), "Patch anchor missing/ambiguous. No changes applied.")
        source = string.sub(source,1,first-1) .. edit.new .. string.sub(source,last+1)
    end
    table.insert(prepared, {module=module, original=original, updated=source, path=change.path})
end
local backup = Instance.new("Folder")
backup.Name = "AzureDropBackup_" .. os.time()
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
print("Azure hold cancel, close penalties and impact display installed. Backup: ServerStorage." .. backup.Name)
print("Playtest: cancel with Enstrangle while holding; throw with Perforating; auto-throw; close/far landings; Show Hitboxes on/off; victim reset during hold.")
