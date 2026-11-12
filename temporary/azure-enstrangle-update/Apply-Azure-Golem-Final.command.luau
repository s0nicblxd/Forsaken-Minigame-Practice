-- AZURE GOLEM RETURN / VINE / INFLORESCENCE FIX
-- Stop Play, paste the entire file into Studio's Command Bar, and run.
-- Requires the physics handoff patch. Checks both modules before writing.
-- Fixes indefinitely anchored Golem return, Vine power-level cooldown math,
-- and gives 5 seconds of invincibility on successful Golem entry/transfer.
-- Backup: ServerStorage.AzureGolemFinalBackup_<timestamp>.
-- Set RESTORE_BACKUP to that folder name to restore the previous source.
-- Compiled and mock-tested; live Studio validation still required.
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
{path={"Assets","Killers","Azure","Behavior"}, checksum=3767237894, edits={
{old=[=[
            p155.LifetimeStartedAt = nil;
            p155.LifetimeToken = (p155.LifetimeToken or 0) + 1;

            if p155 and (p155.UUID and p155.RemainingLifetime) then
                p154:PCallLocal("UpdateGolemLifetime", p155.UUID, p155.RemainingLifetime);
            end;
        elseif not u135(p154, p155) then
            return;
        end;

        if p155.Statue then
            __pcallMethod("sv_DestroyGolemStatue", p154, p155.Statue);
            p155.Statue = nil;
        end;

        p155.BeingControlled = true;
        Util:GiveStackableAttribute(p154.Rig, "StunnedDisabled", "Golem");
        p154.Config.StatusData = {
            TotalTimeMult = 0.75,
            ExcludeIfAppliedFrom = "Azure"
        };
        local v161 = p154.Rig.PrimaryPart.CFrame * CFrame.new(0, -p154.Rig.PrimaryPart.Size.Y / 2 * 3, 0);
        local v162 = __pcallMethod("sv_CreateAzureStatue", p154, v161);
        p154.State.GolemReturnDummy = {
            Rig = v162,
            CFrame = p154.Rig.PrimaryPart.CFrame
        };

        if v162 then
            p154.Maid:Add(v162);
]=], new=[=[
            p155.LifetimeStartedAt = nil;
            p155.LifetimeToken = (p155.LifetimeToken or 0) + 1;

            if p155 and (p155.UUID and p155.RemainingLifetime) then
                p154:PCallLocal("UpdateGolemLifetime", p155.UUID, p155.RemainingLifetime);
            end;
        elseif not u135(p154, p155) then
            return;
        end;

        if p155.Statue then
            __pcallMethod("sv_DestroyGolemStatue", p154, p155.Statue);
            p155.Statue = nil;
        end;

        -- Only a successful entry/transfer grants protection, never cancel/exit.
        -- Unique key prevents an earlier timer from clearing a later use.
        Util:GiveInvincible(p154.Rig, "AzureInflorescence_" .. tostring(os.clock()), 5);
        p155.BeingControlled = true;
        Util:GiveStackableAttribute(p154.Rig, "StunnedDisabled", "Golem");
        p154.Config.StatusData = {
            TotalTimeMult = 0.75,
            ExcludeIfAppliedFrom = "Azure"
        };
        local v161 = p154.Rig.PrimaryPart.CFrame * CFrame.new(0, -p154.Rig.PrimaryPart.Size.Y / 2 * 3, 0);
        local v162 = __pcallMethod("sv_CreateAzureStatue", p154, v161);
        p154.State.GolemReturnDummy = {
            Rig = v162,
            CFrame = p154.Rig.PrimaryPart.CFrame
        };

        if v162 then
            p154.Maid:Add(v162);
]=]},
{old=[=[
        end;

        p124.Config.Instances.GolemStatue.SurfaceAppearance:Clone().Parent = v126["Cube.001"];
        v126.Parent = workspace.Map.Ingame;

        return v126;
    end;

    function u77.sv_DestroyAzureStatue(p127, u128, p129) -- Line: 552
        -- upvalues: Debris (copy), Util (copy)
        Debris:AddItem(p129, 1);
        u128:PCallAllClients("AnimateAzureStatue", p129, true);
        u128.Rig:PivotTo(u128.State.FakeAzureStatue:GetPivot());
        u128.State.FakeAzureStatue:Destroy();
        u128.State.FakeAzureStatue = nil;
        local v130 = Util:LoadAnimationFromID(u128.Rig, u128.Config.Animations.GolemStateExit);
        v130:Play(0);
        v130.Stopped:Once(function() -- Line: 563
            -- upvalues: Util (ref), u128 (copy)
            Util:ToggleAnchored(u128.Rig, "AzureReturn", false);
        end);
        Util:ToggleAnchored(u128.Rig, "AzureReturn", true);
    end;

    function u77.sv_DestroyGolemStatue(p131, p132, p133) -- Line: 569
        p133:Destroy();
    end;

    local function sv_getGolemTransferCooldown(p134) -- Line: 573
        return p134.Config.Golem.TransferCooldown or (p134.Config.GolemTransferCooldown or 3);
    end;

    local u135 = nil;

    local function sv_clearGolemSpawnLock(p136, p137) -- Line: 579
        if p137 and p137 ~= p136.Cache.GolemSpawnLockToken then
            return;
]=], new=[=[
        end;

        p124.Config.Instances.GolemStatue.SurfaceAppearance:Clone().Parent = v126["Cube.001"];
        v126.Parent = workspace.Map.Ingame;

        return v126;
    end;

    function u77.sv_DestroyAzureStatue(p127, u128, p129) -- Line: 552
        -- upvalues: Debris (copy), Util (copy)
        Debris:AddItem(p129, 1);
        u128:PCallAllClients("AnimateAzureStatue", p129, true);
        u128.Rig:PivotTo(u128.State.FakeAzureStatue:GetPivot());
        u128.State.FakeAzureStatue:Destroy();
        u128.State.FakeAzureStatue = nil;
        local rig = u128.Rig
        local root = rig.PrimaryPart
        local humanoid = rig:FindFirstChildOfClass("Humanoid")
        if not root or not humanoid then return end
        local key = "AzureReturn_" .. tostring(os.clock())
        local finished, track, stopped, died = false, nil, nil, nil
        local function release()
            if finished then return end
            finished = true
            if stopped then stopped:Disconnect() end
            if died then died:Disconnect() end
            if track then track:Stop(0.1); track:Destroy() end
            -- Remove only this return's lock; preserve other anchoring effects.
            Util:RemoveStackableProperty(root, "Anchored", key)
            if root.Parent and not root.Anchored then
                local ok, err = pcall(function()
                    if u128.Player and u128.Player.Parent == game:GetService("Players") then
                        root:SetNetworkOwner(u128.Player)
                    else
                        root:SetNetworkOwnershipAuto()
                    end
                end)
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

    local u135 = nil;

    local function sv_clearGolemSpawnLock(p136, p137) -- Line: 579
        if p137 and p137 ~= p136.Cache.GolemSpawnLockToken then
            return;
]=]}
}},
{path={"Assets","Killers","Azure","Behavior","sv_AzureConstruct","sv_Vine"}, checksum=3323793545, edits={
{old=[=[

                        Ended = function() -- Line: 303, Name: Ended
                            -- upvalues: u7 (ref), u24 (ref), u5 (ref), u13 (ref), u6 (ref)
                            u7 = false;

                            if u24 then
                                u5:FireConnection("OnMiss");
                                u5:FireAllClients("OnMiss");
                                u5:ToggleQTEEnabled("IsAttacking", true);

                                if u13 then
                                    pcall(task.cancel, u13);
                                    u13 = nil;
                                end;

								u13 = task.delay(u6.MissAttackCooldown - windup - 0.1, function() -- Line: 317
                                    -- upvalues: u13 (ref), u5 (ref)
                                    u13 = nil;

                                    if not (u5 and u5.Owner) then
                                        return;
                                    end;

                                    u5:PlaySound("Ready");
                                    u5:FireAllClients("OnReady");
                                end);
                            end;
                        end
                    }
                });
            end);
]=], new=[=[

                        Ended = function() -- Line: 303, Name: Ended
                            -- upvalues: u7 (ref), u24 (ref), u5 (ref), u13 (ref), u6 (ref)
                            u7 = false;

                            if u24 then
                                u5:FireConnection("OnMiss");
                                u5:FireAllClients("OnMiss");
                                u5:ToggleQTEEnabled("IsAttacking", true);

                                if u13 then
                                    pcall(task.cancel, u13);
                                    u13 = nil;
                                end;

								u13 = task.delay(math.max(0, u5:GetConfigValueForPowerLevel("MissAttackCooldown") - windup - 0.1), function() -- Line: 317
                                    -- upvalues: u13 (ref), u5 (ref)
                                    u13 = nil;

                                    if not (u5 and u5.Owner) then
                                        return;
                                    end;

                                    u5:PlaySound("Ready");
                                    u5:FireAllClients("OnReady");
                                end);
                            end;
                        end
                    }
                });
            end);
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
backup.Name = "AzureGolemFinalBackup_" .. os.time()
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
print("Azure Golem return, Vine cooldown and 5s Inflorescence protection installed. Backup: ServerStorage." .. backup.Name)
print("Playtest: leave Golem form, repeat with unavailable exit animation, miss with a Vine at both power levels, and test damage during/after the 5s entry protection.")
