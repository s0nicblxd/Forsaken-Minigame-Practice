-- AZURE GRAB PHYSICS/CAMERA HANDOFF FIX
-- Stop Play. Paste this entire file into the Studio Command Bar.
-- Targets the exact Behavior uploaded on Nov 10; refuses mismatched source.
-- Restores Azure physics ownership after the success freeze and removes stale
-- aim/hold render callbacks without unbinding a newer session.
-- Keeps grab freeze, sprint rules, animations, damage and Oblation unchanged.
-- Backup: ServerStorage.AzureHandoffBackup_<timestamp>.
-- Set RESTORE_BACKUP below to the backup folder name to restore.
-- Validated with Luau compilation and mocked tests, not Roblox Studio.
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
{path={"Assets","Killers","Azure","Behavior"}, checksum=1690498964, edits={
{old=[=[
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

            while u440.State.GrabAimingSequence == true and u440.Cache.AzureFacingToken == facingToken and u440.Rig:IsDescendantOf(workspace) do
                RunService.Heartbeat:Wait();
            end;

            if u440.Cache.AzureFacingToken ~= facingToken then
                Attachment:Destroy(); u441:Destroy(); u443:Destroy(); u442:Destroy();
                return;
            end;
            u440.Cache.AzureFacingToken = nil;
            for i, _ in pairs(u440.State.HighlightedCharacters) do
                __pcallMethod("lcl_RemoveHighlightCharacterInReachForGrab", u440, i);
            end;

            TweenService:Create(u443, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
                Value = Vector3.new(0, 0, 0)
            }):Play();
            TweenService:Create(u442, TweenInfo.new(0.3), {
                Value = 1
            }):Play();
]=], new=[=[
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

            while u440.State.GrabAimingSequence == true and u440.Cache.AzureFacingToken == facingToken and u440.Rig:IsDescendantOf(workspace) do
                RunService.Heartbeat:Wait();
            end;

            if u440.Cache.AzureAimRenderToken == facingToken then
                RunService:UnbindFromRenderStep("AzureCameraUpdate");
                u440.Cache.AzureAimRenderToken = nil;
            end;
            if u440.Cache.AzureFacingToken ~= facingToken then
                Attachment:Destroy(); u441:Destroy(); u443:Destroy(); u442:Destroy();
                return;
            end;
            u440.Cache.AzureFacingToken = nil;
            for i, _ in pairs(u440.State.HighlightedCharacters) do
                __pcallMethod("lcl_RemoveHighlightCharacterInReachForGrab", u440, i);
            end;

            TweenService:Create(u443, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
                Value = Vector3.new(0, 0, 0)
            }):Play();
            TweenService:Create(u442, TweenInfo.new(0.3), {
                Value = 1
            }):Play();
]=]},
{old=[=[
                else
                    __pcallMethod("lcl_HighlightCharacterInReachForGrab", u440, child, true);
                end;
			end;
			if workspace:GetAttribute("FriendlyFire") then
				for _, child in pairs(workspace.Players.Killers:GetChildren()) do
					if child == u440.Rig then continue end
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
]=], new=[=[
                else
                    __pcallMethod("lcl_HighlightCharacterInReachForGrab", u440, child, true);
                end;
			end;
			if workspace:GetAttribute("FriendlyFire") then
				for _, child in pairs(workspace.Players.Killers:GetChildren()) do
					if child == u440.Rig then continue end
					if (u440.Rig.PrimaryPart.Position - child:GetPivot().Position).Magnitude >= u440.Config.Grab.HookRange or child:GetAttribute("Undetectable") then
						__pcallMethod("lcl_RemoveHighlightCharacterInReachForGrab", u440, child, true);
					else
						__pcallMethod("lcl_HighlightCharacterInReachForGrab", u440, child, true);
					end;
				end;
			end

            u440.Cache.AzureAimRenderToken = facingToken;
            RunService:BindToRenderStep("AzureCameraUpdate", Enum.RenderPriority.Camera.Value + 5, function() -- Line: 2793
                if u440.Cache.AzureFacingToken ~= facingToken then return end;
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
]=]},
{old=[=[
        TweenService:Create(u377, TweenInfo.new(1.2, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
            Value = 0.75
        }):Play();
        u375.LookFlag = true;
        local facingToken = {};
        u375.Cache.AzureFacingToken = facingToken;
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

            while u375.LookFlag and u375.Cache.AzureFacingToken == facingToken and u375.Rig:IsDescendantOf(workspace) do
                RunService.Heartbeat:Wait();
            end;

            if u375.Cache.AzureFacingToken ~= facingToken then
                Attachment:Destroy(); u376:Destroy(); u378:Destroy(); u377:Destroy();
                return;
            end;
            u375.Cache.AzureFacingToken = nil;
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
]=], new=[=[
        TweenService:Create(u377, TweenInfo.new(1.2, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
            Value = 0.75
        }):Play();
        u375.LookFlag = true;
        local facingToken = {};
        u375.Cache.AzureFacingToken = facingToken;
        u375.Rig:SetAttribute("AzureGrabFacing", true);
        u375.Rig.Humanoid.AutoRotate = false;
        u375.Rig:SetAttribute("DirectionalMovementDisabled", true);
        task.spawn(function() -- Line: 2393
            -- upvalues: Util (ref), u375 (copy), TweenService (ref), RunService (ref), u376 (copy), u377 (copy), Attachment (copy)
            local u378 = Util:CreateCameraOffset(u375.Rig, Vector3.new(0, 0, 0), "AzureGrabAiming");
            TweenService:Create(u378, TweenInfo.new(0.3), {
                Value = Vector3.new(-2.5, 1, 0)
            }):Play();
            u375.Cache.AzureHoldRenderToken = facingToken;
            RunService:BindToRenderStep("AzureCameraUpdateHoming", Enum.RenderPriority.Camera.Value + 2, function() -- Line: 2400
                if u375.Cache.AzureFacingToken ~= facingToken then return end;
                -- upvalues: u376 (ref), u375 (ref)
                local LookVector = workspace.CurrentCamera.CFrame.LookVector;
                local v379 = Vector3.new(LookVector.X, 0, LookVector.Z);

                if v379.Magnitude < 0.001 or v379 ~= v379 then
                    return;
                end;

                u376.CFrame = CFrame.new(u375.Rig.PrimaryPart.Position, u375.Rig.PrimaryPart.Position + v379);
            end);

            while u375.LookFlag and u375.Cache.AzureFacingToken == facingToken and u375.Rig:IsDescendantOf(workspace) do
                RunService.Heartbeat:Wait();
            end;

            if u375.Cache.AzureHoldRenderToken == facingToken then
                RunService:UnbindFromRenderStep("AzureCameraUpdateHoming");
                u375.Cache.AzureHoldRenderToken = nil;
            end;
            if u375.Cache.AzureFacingToken ~= facingToken then
                Attachment:Destroy(); u376:Destroy(); u378:Destroy(); u377:Destroy();
                return;
            end;
            u375.Cache.AzureFacingToken = nil;
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
]=]},
{old=[=[
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
        if actor.Cache then actor.Cache.AzureFacingToken = nil end
        RunService:UnbindFromRenderStep("AzureCameraUpdate")
        RunService:UnbindFromRenderStep("AzureCameraUpdateHoming")
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
]=], new=[=[
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
        if actor.Cache then
            actor.Cache.AzureFacingToken = nil
            actor.Cache.AzureAimRenderToken = nil
            actor.Cache.AzureHoldRenderToken = nil
        end
        RunService:UnbindFromRenderStep("AzureCameraUpdate")
        RunService:UnbindFromRenderStep("AzureCameraUpdateHoming")
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
]=]},
{old=[=[
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
]=], new=[=[
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
                -- Anchoring discards physics ownership. Return control immediately;
                -- otherwise local movement and shift-lock can fight server physics.
                if not oldAnchored then
                    safe(function()
                        if actor.Player and actor.Player.Parent == game:GetService("Players") then
                            root:SetNetworkOwner(actor.Player)
                        else
                            root:SetNetworkOwnershipAuto()
                        end
                    end)
                end
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
backup.Name = "AzureHandoffBackup_" .. os.time()
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
print("Azure physics/camera handoff fix installed (Azure.Behavior only). Backup: ServerStorage." .. backup.Name)
print("Playtest: hold movement through grab success, sprint while carrying, repeat with shift-lock on/off, and despawn the victim during success.")
