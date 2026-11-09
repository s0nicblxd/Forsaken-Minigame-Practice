-- AZURE SPRINT, REEL, SHIFT-LOCK AND OBLATION — 2026-11-09
-- Stop Play. Open the newest FCF place, then paste this ENTIRE file into
-- Studio's Command Bar and press Enter. No HTTP requests or downloads are used.
-- Requires the grab delay/reset fix installed. Updates Azure.Behavior, SmoothShiftLock and Atropa.
-- Checks your source before editing. If it differs, NOTHING is changed.
-- Animation IDs unchanged. Keeps pull duration fixed regardless of range. Sprint unlocks after grab success.
-- Backup: ServerStorage.AzureRulesBackup_<timestamp> (chunked full source).
-- To restore: set RESTORE_BACKUP below to that folder's exact name and run this file again.
-- Restore overwrites only the three backed-up modules with their pre-patch source.
-- Website/main branch are unaffected.
--
-- Includes: immediate casting sprint restriction, fixed reel orientation,
-- bounded/idempotent shift-lock rotation and session cleanup, removal of the
-- no-cooldowns instant-Oblation cheat, damage-only progress, natural Atropa expiry
-- rewards (floor(stacks/2), minimum 1), and no duplicate consume/death rewards.
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
{path={"Assets","Killers","Azure","Behavior"}, checksum=1184610886, edits={
{old=[=[
        Util:LoadAnimationFromID(u685.Rig, u685.Config.Animations.GolemStateEnter, true);
        Util:LoadAnimationFromID(u685.Rig, u685.Config.Animations.GolemStateIdle, true);
        Util:LoadAnimationFromID(u685.Rig, u685.Config.Animations.GolemStateExit, true);
    end);

    function u685.PCallAllClients(p713, p714, ...) -- Line: 4706
        -- upvalues: Network (ref), u685 (copy)
        Network:FireAllClientConnection(`{u685.Player.Name}PCallAllClients`, "REMOTE_EVENT", p714, ...);
    end;

    function u685.PCallLocal(p715, p716, ...) -- Line: 4710
        -- upvalues: Network (ref), u685 (copy)
        Network:FireClientConnection(u685.Player, `{u685.Player.Name}PCallLocal`, "REMOTE_EVENT", p716, ...);
    end;

    local u717 = {};
    u685.Maid:Add(RunService.Heartbeat:Connect(function(p718) -- Line: 4717
        -- upvalues: u717 (copy), Util (ref), __pcallMethod (ref), u685 (copy), Config (copy)
        for _, child in ipairs(workspace.Players.Survivors:GetChildren()) do
            if not u717[child] and (Util:IsAlive(child) and child.Humanoid.Health <= child.Humanoid.MaxHealth / 2) then
                -- (was "sv_AddOblationCharge", which doesn't exist: injuring survivors never gave OBLATION)
                __pcallMethod("sv_AddOblationProgress", u685, Config.Oblation.BuildPerInjured);
                u717[child] = true;
                child.AncestryChanged:Once(function() -- Line: 4723
                    -- upvalues: u717 (ref), child (copy)
                    u717[child] = nil;
                end);
            end;
		end;
		if workspace:GetAttribute("FriendlyFire") then
			for _, child in ipairs(workspace.Players.Killers:GetChildren()) do
				if child == u685.Rig then continue end
				if not u717[child] and (Util:IsAlive(child) and child.Humanoid.Health <= child.Humanoid.MaxHealth / 2) then
					__pcallMethod("sv_AddOblationProgress", u685, Config.Oblation.BuildPerInjured);
					u717[child] = true;
					child.AncestryChanged:Once(function() -- Line: 4723
						-- upvalues: u717 (ref), child (copy)
						u717[child] = nil;
					end);
				end;
			end;
		end
    end));
    u685.NetworkConnections.EndAzureQTE = { `{u685.Player.Name}EndAzureQTE`, "REMOTE_EVENT" };
    Network:SetConnection(`{u685.Player.Name}EndAzureQTE`, "REMOTE_EVENT", function(p719, p720, p721) -- Line: 4734
        -- upvalues: Util (ref), u685 (copy), Actors (ref)
        local v722;

        if p719 then
            v722 = p719.Character;
        else
            v722 = p719;
        end;

        if not v722 or (not Util:IsAlive(v722) or (tostring(v722.Parent) ~= "Survivors")) then
            return;
        end;

]=], new=[=[
        Util:LoadAnimationFromID(u685.Rig, u685.Config.Animations.GolemStateEnter, true);
        Util:LoadAnimationFromID(u685.Rig, u685.Config.Animations.GolemStateIdle, true);
        Util:LoadAnimationFromID(u685.Rig, u685.Config.Animations.GolemStateExit, true);
    end);

    function u685.PCallAllClients(p713, p714, ...) -- Line: 4706
        -- upvalues: Network (ref), u685 (copy)
        Network:FireAllClientConnection(`{u685.Player.Name}PCallAllClients`, "REMOTE_EVENT", p714, ...);
    end;

    function u685.PCallLocal(p715, p716, ...) -- Line: 4710
        -- upvalues: Network (ref), u685 (copy)
        Network:FireClientConnection(u685.Player, `{u685.Player.Name}PCallLocal`, "REMOTE_EVENT", p716, ...);
    end;

    u685.NetworkConnections.EndAzureQTE = { `{u685.Player.Name}EndAzureQTE`, "REMOTE_EVENT" };
    Network:SetConnection(`{u685.Player.Name}EndAzureQTE`, "REMOTE_EVENT", function(p719, p720, p721) -- Line: 4734
        -- upvalues: Util (ref), u685 (copy), Actors (ref)
        local v722;

        if p719 then
            v722 = p719.Character;
        else
            v722 = p719;
        end;

        if not v722 or (not Util:IsAlive(v722) or (tostring(v722.Parent) ~= "Survivors")) then
            return;
        end;

]=]},
{old=[=[
                        Size = Vector3.new(8, 4, 10),
                        Knockback = 2,
                        HitMultiple = true,
                        ExecuteOnKill = false,
                        CFrameOffset = CFrame.new(0, 0, -3.5),

                        Damage = function(p569) -- Line: 3582, Name: Damage
                            -- upvalues: Statuses (ref), u565 (ref), __pcallMethod (ref), u562 (ref)
                            local v570 = Statuses:PlayerHasStatus(p569, "Atropa");
                            local v571;

                            if v570 then
                                v571 = (v570.Level or 1) * u565.DamagePerAtropa;
                                v570.Data = v570.Data or {};
                                v570.Data.IsHit = true;
                                __pcallMethod("sv_IncreaseOblation", u562, (math.ceil(v570.Level or 1)));
                                Statuses:RemoveStatus(p569, "Atropa");
                            else
                                v571 = 0;
                            end;

                            return u565.Damage + v571;
                        end,

                        Time = u565.Linger,
                        DeathProfile = {
                            KillEffects = {
                                Split = true
                            }
                        },
                        AbilityType = u77.Abilities.Slash.KeybindType,
]=], new=[=[
                        Size = Vector3.new(8, 4, 10),
                        Knockback = 2,
                        HitMultiple = true,
                        ExecuteOnKill = false,
                        CFrameOffset = CFrame.new(0, 0, -3.5),

                        Damage = function(p569) -- Line: 3582, Name: Damage
                            -- upvalues: Statuses (ref), u565 (ref), __pcallMethod (ref), u562 (ref)
                            local v570 = Statuses:PlayerHasStatus(p569, "Atropa");
                            local v571;

                            if v570 then
                                v571 = (v570.Level or 1) * u565.DamagePerAtropa;
                                v570.Data = v570.Data or {};
                                v570.Data.IsHit = true;
                                Statuses:RemoveStatus(p569, "Atropa");
                            else
                                v571 = 0;
                            end;

                            return u565.Damage + v571;
                        end,

                        Time = u565.Linger,
                        DeathProfile = {
                            KillEffects = {
                                Split = true
                            }
                        },
                        AbilityType = u77.Abilities.Slash.KeybindType,
]=]},
{old=[=[
                Attachment.Parent = v454;
                Attachment.CFrame = CFrame.new(0, 0, 0);
                Attachment2.CFrame = CFrame.new(v457) * Rotation;
                u451:PivotTo(CFrame.new(v457) * Rotation);
                task.wait();
            end;

            Attachment:Destroy();
            Attachment2:Destroy();
            u449:Destroy();
            u451:Destroy();
        end);
    end;

    function u77.lcl_EndGrabAimingBeamEffect(p458, u459) -- Line: 2914
        task.delay(0.2, function() -- Line: 2915
            -- upvalues: u459 (copy)
            u459.State.GrabAimingBeam = nil;
        end);
    end;

    function u77.lcl_ClearRemoveAllFlowers(p460, p461) -- Line: 2919
        -- upvalues: u77 (copy)
        local FlowersGenerated = p461.State.FlowersGenerated;

        if FlowersGenerated == nil then
            return;
        end;

        for i, _ in pairs(FlowersGenerated) do
            u77:cl_UpdateFlowers(p461, i, 0);
        end;
    end;

]=], new=[=[
                Attachment.Parent = v454;
                Attachment.CFrame = CFrame.new(0, 0, 0);
                Attachment2.CFrame = CFrame.new(v457) * Rotation;
                u451:PivotTo(CFrame.new(v457) * Rotation);
                task.wait();
            end;

            Attachment:Destroy();
            Attachment2:Destroy();
            u449:Destroy();
            u451:Destroy();
        end);
    end;

    function u77.lcl_EndGrabAimingBeamEffect(p458, u459) -- Line: 2914
        u459.State.GrabAimingBeam = nil;
    end;

    function u77.lcl_ClearRemoveAllFlowers(p460, p461) -- Line: 2919
        -- upvalues: u77 (copy)
        local FlowersGenerated = p461.State.FlowersGenerated;

        if FlowersGenerated == nil then
            return;
        end;

        for i, _ in pairs(FlowersGenerated) do
            u77:cl_UpdateFlowers(p461, i, 0);
        end;
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
        local u449 = u448.Config.Instances.TrajectoryBeam:Clone();
        local v450 = u448.Config.Instances.TargetParticle and u448.Config.Instances.TargetParticle:Clone();
        local u451 = u448.Config.Instances.TrajectoryTarget:Clone();
        local Grab = u448.Config.Grab;
        local u452 = RaycastParams.new();
        u452.RespectCanCollide = true;
        u452.CollisionGroup = "Killers";
        u452.FilterType = Enum.RaycastFilterType.Exclude;
        u452.FilterDescendantsInstances = workspace.Players:GetDescendants();
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

    end;

    function u77.lcl_StartGrabAimingBeamEffect(p447, u448) -- Line: 2849
        u448.State.GrabAimingBeam = true;
        local Attachment = Instance.new("Attachment");
        local Attachment2 = Instance.new("Attachment");
        local u449 = u448.Config.Instances.TrajectoryBeam:Clone();
        local v450 = u448.Config.Instances.TargetParticle and u448.Config.Instances.TargetParticle:Clone();
        local u451 = u448.Config.Instances.TrajectoryTarget:Clone();
        local Grab = u448.Config.Grab;
        local u452 = RaycastParams.new();
        u452.RespectCanCollide = true;
        u452.CollisionGroup = "Killers";
        u452.FilterType = Enum.RaycastFilterType.Exclude;
        u452.FilterDescendantsInstances = workspace.Players:GetDescendants();
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
        local facingToken = {};
        u440.Cache.AzureFacingToken = facingToken;
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
            Attachment:Destroy();
            u376:Destroy();
            u375.Rig:SetAttribute("AzureGrabFacing", nil);
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
            end);
            RunService:UnbindFromRenderStep("AzureCameraUpdateHoming");
            Attachment:Destroy();
            u376:Destroy();
            u375.Rig:SetAttribute("AzureGrabFacing", nil);
]=]},
{old=[=[
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
                    end
                else
                    Sprinting:SyncHeldKey()
                end
            end
        end
    end;

]=], new=[=[
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
        if disabled then
            -- Stop the standard 0.75s sprint fade immediately while casting.
            if Sprinting.__speedMultiplier then
                TweenService:Create(Sprinting.__speedMultiplier, TweenInfo.new(0), {Value = 1}):Play()
            end
            if Sprinting.__FOVMultiplier then
                TweenService:Create(Sprinting.__FOVMultiplier, TweenInfo.new(0.1), {Value = 1}):Play()
            end
        end
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
            for _, track in animator:GetPlayingAnimationTracks() do
                if track.Animation and ids[track.Animation.AnimationId] then track:Stop(0) end
]=]},
{old=[=[
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
]=], new=[=[
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
            local healthBefore = victimHumanoid.Health + (victimHumanoid:GetAttribute("Overheal") or 0)
            Util:ApplyDamage(victim, grab.Damage)
            local healthAfter = victimHumanoid.Health + (victimHumanoid:GetAttribute("Overheal") or 0)
            if healthBefore > healthAfter then
                __pcallMethod("sv_AddOblationProgress", actor, (healthBefore - healthAfter) * actor.Config.Oblation.BuildPerDamage)
            end
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
            actor:PCallLocal("SetGrabSprintDisabled", true)
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
            local align = own(Instance.new("AlignPosition", victimRoot))
            align.Attachment0, align.Attachment1 = victimAttachment, attachment
            align.Responsiveness, align.RigidityEnabled = 200, true
            local orientation = own(Instance.new("AlignOrientation", victimRoot))
            orientation.Attachment0, orientation.Attachment1 = victimAttachment, attachment
            orientation.Responsiveness, orientation.RigidityEnabled = 200, true
            local initial = victimRoot.Position
            local reelDirection = root.CFrame.LookVector
            local victimRotation = victimRoot.CFrame.Rotation
            local offset = CFrame.new(0, 0, -3)
            attachment.CFrame = root.CFrame:ToObjectSpace(CFrame.new(initial))
            local function pull(elapsed)
                local targetPosition = root.Position + reelDirection * 3
                local alpha = TweenService:GetValue(math.clamp(elapsed / grab.PullTime, 0, 1), Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut)
                local position = initial:Lerp(targetPosition, alpha)
                attachment.CFrame = root.CFrame:ToObjectSpace(CFrame.new(position) * victimRotation)
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
]=]},
{old=[=[

            if v81 and ((v81 - p80) * Vector3.new(1, PlacementYFactor, 1)).Magnitude <= PlacementRadius then
                return v;
            end;
        end;

        return nil;
    end;

    function u77.sv_AddOblationProgress(p82, p83, p84) -- Line: 308
        -- upvalues: __pcallMethod (copy)
        if p83.State and (p83.State.Golems and next(p83.State.Golems) ~= nil) then
            return;
        end;

        local v85 = workspace:GetAttribute("CooldownsDisabled") and 22222 or p84;
        local v86 = p83.State.OblationProgress + v85;
        local v87 = math.floor(v86 / 100);

        if p83.State.Oblation > p83.Config.Oblation.Max and v87 > 0 then
            p83.State.OblationProgress = 99;

            return;
        end;

        if v87 > 0 then
            __pcallMethod("sv_IncreaseOblation", p83, v87);
        end;

        p83.State.OblationProgress = v86 % 100;
    end;

    function u77.sv_IncreaseOblation(p88, p89, p90) -- Line: 334
        if p89.State and (p89.State.Golems and next(p89.State.Golems) ~= nil) then
            return;
]=], new=[=[

            if v81 and ((v81 - p80) * Vector3.new(1, PlacementYFactor, 1)).Magnitude <= PlacementRadius then
                return v;
            end;
        end;

        return nil;
    end;

    function u77.sv_AddOblationProgress(p82, p83, p84) -- Line: 308
        -- upvalues: __pcallMethod (copy)
        if p83.State and (p83.State.Golems and next(p83.State.Golems) ~= nil) then
            return;
        end;

        local v85 = math.max(0, tonumber(p84) or 0);
        local v86 = p83.State.OblationProgress + v85;
        local v87 = math.floor(v86 / 100);

        if p83.State.Oblation >= p83.Config.Oblation.Max and v87 > 0 then
            p83.State.OblationProgress = 99;

            return;
        end;

        if v87 > 0 then
            __pcallMethod("sv_IncreaseOblation", p83, v87);
        end;

        p83.State.OblationProgress = v86 % 100;
    end;

    function u77.sv_IncreaseOblation(p88, p89, p90) -- Line: 334
        if p89.State and (p89.State.Golems and next(p89.State.Golems) ~= nil) then
            return;
]=]}
}},
{path={"Systems","Player","Game","SmoothShiftLock"}, checksum=267333914, edits={
{old=[=[
    end;
end;
v0.IsEnabled = function(v37) --[[ Line: 206 ]] --[[ Name: IsEnabled ]]
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
]=], new=[=[
    end;
end;
v0.IsEnabled = function(v37) --[[ Line: 206 ]] --[[ Name: IsEnabled ]]
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
    -- Repeated enable calls must not accumulate rotation callbacks.
    v38._shiftlockMaid:DoCleaning();
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
                v38.RootPart.CFrame = v38.RootPart.CFrame:Lerp(CFrame.new(v38.RootPart.Position) * CFrame.Angles(0, v42, 0), 1 - math.exp(-math.max(0, v40) * 5 * v10.CHARACTER_ROTATION_SPEED));
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
]=]}
}},
{path={"Modules","StatusEffects","KillerExclusive","Atropa"}, checksum=1118623865, edits={
{old=[=[

function v1.Removed(a1) -- Line: 74 -- upvalues: RunService (val), Actors (val), Util (val), Sounds (val)
    if not RunService:IsServer() then
        return
    end
    local Character = a1.Character
    local IsHit = a1.Data.IsHit
    local Data = a1.Data and a1.Data.ApplierPlayer
    local v1 = Actors.CurrentActors[Data]
    if v1 then
        local Behavior = v1.Behavior
        if Behavior and Behavior.sv_UpdateFlowers then
            Behavior:sv_UpdateFlowers(v1, Character, 0)
        end
    end
    if not IsHit or not Util:IsAlive(Character) then
        v1 = Actors.CurrentActors[Data]
        if v1 then
            local Behavior_2 = v1.Behavior
            if Behavior_2 and Behavior_2.sv_AddOblationProgress then
                Behavior_2:sv_AddOblationProgress(v1, (a1.Level or 1) * 100 / 2)
            end
        end
    else
        Sounds:Play("rbxassetid://100512718640581", {Parent = Character.PrimaryPart})
    end
    if Data and Character then
        Util:RemovePlayerAuraFrom(Character, Data)
        return
    end
end

return v1]=], new=[=[

function v1.Removed(a1) -- Line: 74 -- upvalues: RunService (val), Actors (val), Util (val), Sounds (val)
    if not RunService:IsServer() then
        return
    end
    local Character = a1.Character
    local IsHit = a1.Data.IsHit
    local Data = a1.Data and a1.Data.ApplierPlayer
    local v1 = Actors.CurrentActors[Data]
    if v1 then
        local Behavior = v1.Behavior
        if Behavior and Behavior.sv_UpdateFlowers then
            Behavior:sv_UpdateFlowers(v1, Character, 0)
        end
    end
    local expiredNaturally = not IsHit and Util:IsAlive(Character)
        and Character:IsDescendantOf(workspace)
        and (a1.TimePast or 0) >= (a1.TimeRequired or a1.Data.Duration or 30)
    if expiredNaturally then
        v1 = Actors.CurrentActors[Data]
        if v1 then
            local Behavior_2 = v1.Behavior
            if Behavior_2 and Behavior_2.sv_AddOblationProgress then
                Behavior_2:sv_AddOblationProgress(v1, math.max(1, math.floor(math.clamp(a1.Level or 1, 1, 6) / 2)) * 100)
            end
        end
    elseif IsHit and Character and Character.PrimaryPart then
        Sounds:Play("rbxassetid://100512718640581", {Parent = Character.PrimaryPart})
    end
    if Data and Character then
        Util:RemovePlayerAuraFrom(Character, Data)
        return
    end
end

return v1]=]}
}}
}
local prepared = {}
for _, change in changes do
    local module = resolve(change.path)
    local original = read(module)
    local source = normalize(original)
    assert(checksum(source) == change.checksum,
        "Source differs from the expected installed delay/reset fix (or follow-up already applied): " .. module:GetFullName() .. ". No changes applied.")
    for _, edit in change.edits do
        local first,last = string.find(source, edit.old, 1, true)
        assert(first and not string.find(source, edit.old, last+1, true), "Patch anchor missing/ambiguous. No changes applied.")
        source = string.sub(source,1,first-1) .. edit.new .. string.sub(source,last+1)
    end
    table.insert(prepared, {module=module, original=original, updated=source, path=change.path})
end
local backup = Instance.new("Folder")
backup.Name = "AzureRulesBackup_" .. os.time()
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
print("Azure sprint/reel/Oblation fixes installed (3 modules). Backup: ServerStorage." .. backup.Name)
print("Playtest: no sprint while casting/reeling; sprint after success; turn during long/short reel; repeat shift-lock; damage and Atropa gains with no cooldowns ON/OFF.")
