-- AZURE ENSTRANGLE / SIXER CUSTOM-RIG COMPATIBILITY
-- Stop Play and paste the entire file into Studio's Command Bar.
-- Requires the spawn-trap patch for Azure. Sixer baseline is FCFyetagain....rbxl.
-- Custom rigs retain intact joints and get bounded landing movement recovery
-- instead of unsupported R6 ragdolling. Collider clearance and restoration are
-- handled explicitly. Demonic Pursuit cancels when Azure grabs Sixer.
-- Updates Azure.Behavior and Sixer.Behavior only; backs up both sources.
-- Backup: ServerStorage.AzureSixerBackup_<timestamp>; RESTORE_BACKUP can undo.
-- Compiled and mock-tested. Actual Roblox physics still needs a Studio test.
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
{path={"Assets","Killers","Azure","Behavior"}, checksum=2211702494, afterChecksum=347749667, edits={
{old=[=[
            if valid() then
                phase = "impact"
                Ragdolls.EnableRagdoll(victim, grab.RagdollDuration)
            end
        end, debug.traceback)
]=], new=[=[
            if valid() then
                phase = "impact"
                ragdolled = knockDown(victim, grab.RagdollDuration)
            end
        end, debug.traceback)
]=]},
{old=[=[
            local helpless = Statuses:ApplyStatus(rig, "Helpless", {Level = 1, Duration = grab.ThrowHelpless or 2})
            if helpless then helpless.TimeRequired = grab.ThrowHelpless or 2 end
            Ragdolls.EnableRagdoll(victim)
            ragdolled = true
            victimRoot:SetNetworkOwner(nil)
            local velocity = direction * grab.ThrowVelocity
]=], new=[=[
            local helpless = Statuses:ApplyStatus(rig, "Helpless", {Level = 1, Duration = grab.ThrowHelpless or 2})
            if helpless then helpless.TimeRequired = grab.ThrowHelpless or 2 end
            ragdolled = knockDown(victim)
            victimRoot:SetNetworkOwner(nil)
            local velocity = direction * grab.ThrowVelocity
]=]},
{old=[=[
            direction = direction.Unit
            Network:FireClientConnection(actor.Player, "SetTrackingMousePosition", "REMOTE_EVENT", direction)
            detach()
            phase = "flight"
            actor:PCallLocal("SetGrabStaminaRegenReduction", false)
]=], new=[=[
            direction = direction.Unit
            Network:FireClientConnection(actor.Player, "SetTrackingMousePosition", "REMOTE_EVENT", direction)
            detach(customVictim) -- custom colliders stay disabled until landing/cleanup
            phase = "flight"
            actor:PCallLocal("SetGrabStaminaRegenReduction", false)
]=]},
{old=[=[
                local knockback = (direction + Vector3.new(0, 0.6, 0)) * grab.KnockbackPower
                other.PrimaryPart.AssemblyLinearVelocity = knockback
                Ragdolls.AddProfile(other, {Velocity = knockback})
                Ragdolls.EnableRagdoll(other, grab.RagdollDuration)
                Actors:IncrementActorStats(actor.Player, {
                    Action = tostring(other.Parent) == "Killers" and "Threw Survivor into Killer" or "Threw Survivor into Survivor",
]=], new=[=[
                local knockback = (direction + Vector3.new(0, 0.6, 0)) * grab.KnockbackPower
                other.PrimaryPart.AssemblyLinearVelocity = knockback
                knockDown(other, grab.RagdollDuration, {Velocity = knockback})
                Actors:IncrementActorStats(actor.Player, {
                    Action = tostring(other.Parent) == "Killers" and "Threw Survivor into Killer" or "Threw Survivor into Survivor",
]=]},
{old=[=[
            victim:SetAttribute("AzureThrowLandedUntil", os.clock() + (grab.PlantTriggerDuration or 1.5))
            local bounce = (velocity - 2 * velocity:Dot(normal) * normal) / 4
            victim:PivotTo(CFrame.new(position + normal * 2))
            Ragdolls.AddProfile(victim, {Velocity = bounce})
            Ragdolls.EnableRagdoll(victim, grab.RagdollDuration)
            victimRoot.AssemblyLinearVelocity = bounce
            __playSound(actor, "GrabImpact", {RollOffMaxDistance = 300, Position = position})
]=], new=[=[
            victim:SetAttribute("AzureThrowLandedUntil", os.clock() + (grab.PlantTriggerDuration or 1.5))
            local bounce = (velocity - 2 * velocity:Dot(normal) * normal) / 4
            if customVictim then
                local collider = victim:FindFirstChild("CollisionHitbox") or victimRoot
                local cf, size = collider.CFrame, collider.Size
                local extent = (math.abs(normal:Dot(cf.RightVector)) * size.X
                    + math.abs(normal:Dot(cf.UpVector)) * size.Y
                    + math.abs(normal:Dot(cf.LookVector)) * size.Z) / 2
                local clearance = math.max(2, extent + (victimRoot.Position - collider.Position):Dot(normal) + 0.5)
                local targetRoot = CFrame.new(position + normal * clearance) * victimRoot.CFrame.Rotation
                victim:PivotTo(targetRoot * victimRoot.CFrame:ToObjectSpace(victim:GetPivot()))
            else
                victim:PivotTo(CFrame.new(position + normal * 2))
            end
            ragdolled = knockDown(victim, grab.RagdollDuration, {Velocity = bounce})
            victimRoot.AssemblyLinearVelocity = bounce
            __playSound(actor, "GrabImpact", {RollOffMaxDistance = 300, Position = position})
]=]},
{old=[=[
            return valid()
        end
        local function applyImpact(result, velocity, releasedAt)
            if not valid() then return end
]=], new=[=[
            return valid()
        end
        local function knockDown(model, duration, profile)
            if supportsRagdoll(model) then
                if profile then Ragdolls.AddProfile(model, profile) end
                Ragdolls.EnableRagdoll(model, duration)
                return model:GetAttribute("Ragdolling") == true
            end
            -- Custom rigs cannot use the R6 ragdoll module. Keep their joints intact
            -- and provide bounded landing recovery without leaving PlatformStand on.
            if duration then
                local lock = speedLock(model, "AzureThrowLanding")
                Debris:AddItem(lock, duration)
            end
            return false
        end
        local function applyImpact(result, velocity, releasedAt)
            if not valid() then return end
]=]},
{old=[=[
                victim:SetAttribute("IgnoreNoclip", nil)
                if victimHumanoid.Parent and not ragdolled then victimHumanoid.PlatformStand = oldPlatformStand end
                if victimRoot.Parent and not victimRoot.Anchored then victimRoot:SetNetworkOwnershipAuto() end
            end)
]=], new=[=[
                victim:SetAttribute("IgnoreNoclip", nil)
                if victimHumanoid.Parent and not ragdolled then victimHumanoid.PlatformStand = oldPlatformStand end
                if customVictim and victimRoot.Parent then victimRoot.AssemblyAngularVelocity = Vector3.zero end
                if victimRoot.Parent and not victimRoot.Anchored then victimRoot:SetNetworkOwnershipAuto() end
            end)
]=]},
{old=[=[
            for _, connection in connections do connection:Disconnect() end
            safe(detach)
            safe(unfreeze)
            for _, track in tracks do
]=], new=[=[
            for _, connection in connections do connection:Disconnect() end
            safe(detach)
            safe(restorePhysics)
            safe(unfreeze)
            for _, track in tracks do
]=]},
{old=[=[
                end
            end
            for name, track in tracks do
                if name ~= "GrabThrow" and name ~= "GrabVictimThrow" then
]=], new=[=[
                end
            end
        end
        local function detach(keepPhysics)
            if detached then return end
            detached = true
            for _, object in objects do safe(function() object:Destroy() end) end
            if not keepPhysics then restorePhysics() end
            for name, track in tracks do
                if name ~= "GrabThrow" and name ~= "GrabVictimThrow" then
]=]},
{old=[=[
            if humanoid.Parent then humanoid.AutoRotate = oldAutoRotate end
        end
        local function detach()
            if detached then return end
            detached = true
            for _, object in objects do safe(function() object:Destroy() end) end
            for part, props in physics do
                if part.Parent then
]=], new=[=[
            if humanoid.Parent then humanoid.AutoRotate = oldAutoRotate end
        end
        local function restorePhysics()
            for part, props in physics do
                if part.Parent then
]=]},
{old=[=[
        local victimRoot, victimHumanoid = victim.PrimaryPart, victim:FindFirstChildOfClass("Humanoid")
        local victimActor = Util:GetActor(victim)
        local tracks, connections, objects, physics = {}, {}, {}, {}
        local phase, cleaned, detached = "pull", false, false
]=], new=[=[
        local victimRoot, victimHumanoid = victim.PrimaryPart, victim:FindFirstChildOfClass("Humanoid")
        local victimActor = Util:GetActor(victim)
        local function supportsRagdoll(model)
            return not model:GetAttribute("CustomRig") and not model:GetAttribute("ExecutionsDisabled")
                and model:FindFirstChild("Torso") ~= nil and model:FindFirstChild("Head") ~= nil
        end
        local customVictim = not supportsRagdoll(victim)
        local tracks, connections, objects, physics = {}, {}, {}, {}
        local phase, cleaned, detached = "pull", false, false
]=]}
}},
{path={"Assets","Killers","Sixer","Behavior"}, checksum=80468262, afterChecksum=3403819681, edits={
{old=[=[
                            l_RunService_0:BindToRenderStep("666PursuitCharge", Enum.RenderPriority.Character.Value + 1, function() --[[ Line: 1669 ]]
                                -- upvalues: l_Humanoid_5 (copy), l_PrimaryPart_3 (copy), v389 (ref), v12 (ref), v298 (ref), l_RunService_0 (ref), v7 (ref), v392 (ref), v393 (ref), l_Unit_3 (ref), v366 (ref), v365 (ref), v345 (copy), v391 (copy), v395 (ref), v302 (ref), v303 (ref), l_v393_0 (ref)
                                if not l_Humanoid_5 or not l_PrimaryPart_3 or l_PrimaryPart_3.Anchored then
                                    if v389 then
                                        return;
]=], new=[=[
                            l_RunService_0:BindToRenderStep("666PursuitCharge", Enum.RenderPriority.Character.Value + 1, function() --[[ Line: 1669 ]]
                                -- upvalues: l_Humanoid_5 (copy), l_PrimaryPart_3 (copy), v389 (ref), v12 (ref), v298 (ref), l_RunService_0 (ref), v7 (ref), v392 (ref), v393 (ref), l_Unit_3 (ref), v366 (ref), v365 (ref), v345 (copy), v391 (copy), v395 (ref), v302 (ref), v303 (ref), l_v393_0 (ref)
                                if not l_Humanoid_5 or not l_PrimaryPart_3 or l_PrimaryPart_3.Anchored or v298.Rig:GetAttribute("AzureGrabbed") then
                                    if v389 then
                                        return;
]=]},
{old=[=[
                        });
                        while v9:IsAlive(v298.Rig) and not v309 do
                            l_RunService_0.Heartbeat:Wait();
                        end;
]=], new=[=[
                        });
                        while v9:IsAlive(v298.Rig) and not v309 do
                            if v298.Rig:GetAttribute("AzureGrabbed") then
                                v309 = "Cancelled";
                                break;
                            end;
                            l_RunService_0.Heartbeat:Wait();
                        end;
]=]},
{old=[=[
                                Hit = function(v321, _) --[[ Line: 1314 ]] --[[ Name: Hit ]]
                                    -- upvalues: v320 (ref), v9 (ref), v310 (ref), v309 (ref), v8 (ref), v298 (ref), l_PrimaryPart_2 (copy), v13 (ref), v1 (ref), v305 (copy), v318 (ref), v303 (ref), v82 (ref), l_ReplicatedStorage_0 (ref), l_RunService_0 (ref), v10 (ref)
                                    if v320 then
                                        return;
                                    elseif not v9:GetEntityType(v321) then
]=], new=[=[
                                Hit = function(v321, _) --[[ Line: 1314 ]] --[[ Name: Hit ]]
                                    -- upvalues: v320 (ref), v9 (ref), v310 (ref), v309 (ref), v8 (ref), v298 (ref), l_PrimaryPart_2 (copy), v13 (ref), v1 (ref), v305 (copy), v318 (ref), v303 (ref), v82 (ref), l_ReplicatedStorage_0 (ref), l_RunService_0 (ref), v10 (ref)
                                    if v320 or v298.Rig:GetAttribute("AzureGrabbed") then
                                        return;
                                    elseif not v9:GetEntityType(v321) then
]=]},
{old=[=[
                    repeat
                        l_RunService_0.Heartbeat:Wait();
                        v307 = v298.Rig:GetAttribute("Stunned");
                    until v306 and tick() - v305 >= l_PursuitHold_0.Min or tick() - v305 >= l_PursuitHold_0.Max or v307;
                    v12:RemoveConnection(v301, "REMOTE_EVENT");
]=], new=[=[
                    repeat
                        l_RunService_0.Heartbeat:Wait();
                        v307 = v298.Rig:GetAttribute("Stunned") or v298.Rig:GetAttribute("AzureGrabbed");
                    until v306 and tick() - v305 >= l_PursuitHold_0.Min or tick() - v305 >= l_PursuitHold_0.Max or v307;
                    v12:RemoveConnection(v301, "REMOTE_EVENT");
]=]}
}}
}
local prepared = {}
for _, change in changes do
    local module = resolve(change.path)
    local original = read(module)
    local source = normalize(original)
    if checksum(source) ~= change.afterChecksum then
        assert(change.checksum == 0 or checksum(source) == change.checksum,
            "Behavior differs from expected spawn-trap Azure / uploaded Sixer: " .. module:GetFullName() .. ". Nothing changed.")
        for _, edit in change.edits do
            -- Check the replacement first: insertion edits can contain the old anchor.
            local already = string.find(source, edit.new, 1, true)
            if not already then
                local first,last = string.find(source, edit.old, 1, true)
                assert(first and not string.find(source, edit.old, last+1, true),
                    "Missing or ambiguous balance edit in " .. module:GetFullName() .. ". Nothing changed.")
                source = string.sub(source,1,first-1) .. edit.new .. string.sub(source,last+1)
            end
        end
        if source ~= normalize(original) then
            table.insert(prepared, {module=module, original=original, updated=source, path=change.path})
        end
    end
end
if #prepared == 0 then
    print("Azure/Sixer compatibility update already installed. No changes needed.")
    return
end
local backup = Instance.new("Folder")
backup.Name = "AzureSixerBackup_" .. os.time()
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
print("Azure/Sixer compatibility update installed successfully. Backup: ServerStorage." .. backup.Name)
print("Playtest: catch Sixer while idle, charging and dashing; throw/drop/reset; verify movement, collision and sprint return; repeat on a normal survivor.")
