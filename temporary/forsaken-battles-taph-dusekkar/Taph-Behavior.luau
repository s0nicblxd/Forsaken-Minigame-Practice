-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local TaphSupport=require(game.ReplicatedStorage.Modules.TaphSupport)
local v0 = {};
local v1 = require(game.ReplicatedStorage.Modules.Sounds);
local v2 = require(game.ReplicatedStorage.Modules.Util);
local _ = require(game.ReplicatedStorage.Modules.Hitboxes);
local v4 = require(game.ReplicatedStorage.Modules.Statuses);
local v5 = require(game.ReplicatedStorage.Modules.Actors);
local v6 = require(game.ReplicatedStorage.Modules.AchievementUtil);
local v7 = require(game.ReplicatedStorage.Modules.Network);
local function _(v8) --[[ Line: 12 ]] --[[ Name: __displayWarn ]]
    warn((("[Taph]: %*"):format(v8)));
end;
local function v15(v10, v11, ...) --[[ Line: 18 ]] --[[ Name: __pcallMethod ]]
    assert(v10, "bad moduleInfo, must be a table");
    local l_status_0, l_result_0 = pcall(function(...) --[[ Line: 21 ]]
        -- upvalues: v10 (copy), v11 (copy)
        if v10[v11] then
            return v10[v11](...);
        else
            return;
        end;
    end, ...);
    if not l_status_0 then
        local v14 = ("Failed to call :%*() due to: %*"):format(v11, l_result_0);
        warn((("[Taph]: %*"):format(v14)));
    end;
    return l_status_0, l_result_0;
end;
local function v29(v16, v17, v18) --[[ Line: 32 ]] --[[ Name: checkPlacement ]]
    local v19 = OverlapParams.new();
    v19.FilterDescendantsInstances = {
        workspace.Players
    };
    v19.FilterType = Enum.RaycastFilterType.Exclude;
    v19.CollisionGroup = "Survivors";
    local l_workspace_PartBoundsInRadius_0 = workspace:GetPartBoundsInRadius(v17.Position, 0.25, v19);
    for _, v22 in pairs(l_workspace_PartBoundsInRadius_0) do
        if v22.CanCollide or v22.Name == "UnplacableArea" then
            return "collision";
        end;
    end;
    for _, v24 in pairs(workspace.Map.Ingame:GetChildren()) do
        if v24.Name:find("TaphTripwire") then
            for _, v26 in pairs(v24:GetChildren()) do
                if v26.Name:find("Hook") and (v16.Rig.PrimaryPart.Position - v26.Position).Magnitude < v16.Config.TripwireDistanceBetweenTripwires then
                    return "tooClose";
                end;
            end;
        end;
    end;
    local v27 = RaycastParams.new();
    v27.FilterType = Enum.RaycastFilterType.Exclude;
    v27.FilterDescendantsInstances = {
        workspace.Players
    };
    if not workspace:Raycast(v17.Position, Vector3.new(0, -2, 0, 0), v27) then
        return "midair";
    elseif workspace:Raycast(v16.Rig.PrimaryPart.Position, v16.Rig.PrimaryPart.CFrame.LookVector * 2, v27) then
        return "facingWall";
    else
        if v18 then
            local l_Magnitude_0 = (v17.Position - v18.Position).Magnitude;
            if workspace:Raycast(v18.Position, CFrame.lookAt(v18.Position, v17.Position).LookVector * l_Magnitude_0, v27) then
                return "intersecting";
            end;
        end;
        return "placed";
    end;
end;
v0.Abilities = {
    Tripwire = {
        LayoutOrder = 1, 
        KeybindType = "AltAbility1", 
        Icon = "rbxassetid://135707604176757", 
        Callback = function(v30, v31) --[[ Line: 94 ]] --[[ Name: Callback ]]
            -- upvalues: v29 (copy), v1 (copy), v2 (copy), v7 (copy), v4 (copy), v5 (copy)
            if game["Run Service"]:IsServer() then
                v30.DisabledAbilities = {
                    SubspaceTripmine = true
                };
                local v32 = v30.Rig.PrimaryPart.CFrame * CFrame.new(0, -2, -2);
                local l_Attribute_0 = v30.Rig:GetAttribute("TripwireOrigin");
                if l_Attribute_0 then
                    local v34 = v29(v30, v32, l_Attribute_0);
                    if v34 ~= "placed" then
                        v30.DisabledAbilities = nil;
                        return {
                            Cancelled = true, 
                            Reason = v34
                        };
                    else
                        v30.Rig:SetAttribute("TripwireEnding", v32);
                        v30.Placing = nil;
                    end;
                else
                    local v35 = v29(v30, v32);
                    if v35 ~= "placed" then
                        v30.DisabledAbilities = nil;
                        return {
                            Cancelled = true, 
                            Reason = v35
                        };
                    else
                        v30.Placing = true;
                        v30:SetCooldownOf("Tripwire", v30.Config.TripwireCooldownWhilePlacing);
                        v30.Rig:SetAttribute("PlacingTripwire", true);
                        v30.Rig:SetAttribute("TripwireOrigin", v30.Rig.PrimaryPart.CFrame * CFrame.new(0, -2, -2));
                        v1:Play(v30.Config.Sounds.TripwireStart, {
                            Parent = v30.Rig.PrimaryPart
                        });
                        local l_Health_0 = v30.Rig.Humanoid.Health;
                        local v37 = nil;
                        v37 = v30.Rig.Humanoid.HealthChanged:Connect(function(v38) --[[ Line: 138 ]]
                            -- upvalues: l_Health_0 (copy), v30 (copy)
                            if v38 + 4.75 < l_Health_0 then
                                v30.Placing = nil;
                            end;
                        end);
                        do
                            local l_v37_0 = v37;
                            task.spawn(function() --[[ Line: 145 ]]
                                -- upvalues: v30 (copy), l_v37_0 (ref), v1 (ref), v2 (ref), v7 (ref), v4 (ref), v5 (ref)
                                repeat
                                    task.wait();
                                until not v30.Rig.Parent or not v30.Placing;
                                if not v30.Rig.Parent then
                                    return;
                                else
                                    l_v37_0:Disconnect();
                                    v30.AbilitiesDisabled = true;
                                    v30.DisabledAbilities = nil;
                                    task.delay(2, function() --[[ Line: 155 ]]
                                        -- upvalues: v30 (ref)
                                        v30.AbilitiesDisabled = false;
                                    end);
                                    local l_Attribute_1 = v30.Rig:GetAttribute("TripwireOrigin");
                                    local l_Attribute_2 = v30.Rig:GetAttribute("TripwireEnding");
                                    if l_Attribute_1 and l_Attribute_2 then
                                        v1:Play(v30.Config.Sounds.TripwirePlace, {
                                            Parent = v30.Rig.PrimaryPart
                                        });
                                        local l_Model_0 = Instance.new("Model");
                                        l_Model_0.Name = ("%*TaphTripwire"):format((tostring(v30.Player)));
                                        l_Model_0.Parent = workspace.Map.Ingame;
                                        l_Model_0:SetAttribute("HitboxPriority", 0);
                                        local _, _ = v30.Behavior:CreateTripwireHooks(v30, l_Model_0);
                                        local l_Magnitude_1 = (l_Attribute_1.Position - l_Attribute_2.Position).Magnitude;
                                        local v46 = l_Attribute_1.Position:Lerp(l_Attribute_2.Position, 0.5);
                                        local v47 = CFrame.lookAt(v46, l_Attribute_2.Position);
                                        local l_Part_0 = Instance.new("Part");
                                        l_Part_0.Name = "Wire";
                                        l_Part_0.Transparency = 1;
                                        l_Part_0.Anchored = true;
                                        l_Part_0.CanCollide = false;
                                        l_Part_0.CanQuery = true;
                                        l_Part_0.Size = Vector3.new(0.1, 0.1, l_Magnitude_1);
                                        l_Part_0.Position = v46 + Vector3.new(0, 0.20000000298023224, 0, 0);
                                        l_Part_0.CFrame = v47;
                                        l_Part_0.Parent = l_Model_0;
                                        game.TweenService:Create(l_Part_0, TweenInfo.new(1), {
                                            Transparency = 0.75
                                        }):Play();
                                        task.delay(1, function() --[[ Line: 192 ]]
                                            -- upvalues: l_Part_0 (copy)
                                            game.TweenService:Create(l_Part_0, TweenInfo.new(20, Enum.EasingStyle.Linear), {
                                                Transparency = 0.8
                                            }):Play();
                                        end);
                                        local l_Humanoid_0 = Instance.new("Humanoid");
                                        l_Humanoid_0.Parent = l_Model_0;
                                        l_Humanoid_0.MaxHealth = v30.Config.TripwireHealth;
                                        l_Humanoid_0.Health = v30.Config.TripwireHealth;
                                        l_Model_0:SetAttribute("ExecutionsDisabled", true);
                                        l_Model_0:SetAttribute("Team", "Survivors");
                                        l_Model_0.PrimaryPart = l_Part_0;
                                        local l_v2_ClosestPlayerFromPosition_0 = v2:GetClosestPlayerFromPosition(v30.Rig.PrimaryPart.Position, {
                                            MaxDistance = v30.Config.TripwirePingDistance, 
                                            ReturnTable = true, 
                                            OverrideUndetectable = true
                                        });
                                        for _, v52 in pairs(l_v2_ClosestPlayerFromPosition_0) do
                                            local l_Player_0 = v52.Player;
                                            local l_PlayerFromCharacter_0 = game.Players:GetPlayerFromCharacter(l_Player_0);
                                            if l_PlayerFromCharacter_0 then
                                                v2:RevealPlayerAuraTo(l_PlayerFromCharacter_0, l_Model_0, "inf", Color3.new(0.75, 1, 0.75));
                                            end;
                                        end;
                                        l_Model_0:SetAttribute("Invincible", true);
                                        task.delay(1, function() --[[ Line: 218 ]]
                                            -- upvalues: l_Model_0 (copy)
                                            l_Model_0:SetAttribute("Invincible", nil);
                                        end);
                                        local v55 = false;
                                        local v56 = nil;
                                        do
                                            local l_v55_0, l_v56_0 = v55, v56;
                                            local function v63() --[[ Line: 225 ]] --[[ Name: removeTripwire ]]
                                                -- upvalues: l_v55_0 (ref), l_Part_0 (copy), l_Model_0 (copy), l_v56_0 (ref), v30 (ref), v7 (ref)
                                                if not l_v55_0 then
                                                    l_v55_0 = true;
                                                    l_Part_0.Anchored = false;
                                                    l_Part_0:ApplyImpulse((Vector3.new(0, 0.05000000074505806, 0, 0)));
                                                    game.Debris:AddItem(l_Model_0, 1.5);
                                                    for _, v60 in pairs(l_Model_0:GetChildren()) do
                                                        if v60:IsA("BasePart") then
                                                            game.TweenService:Create(v60, TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                                                                Transparency = 1
                                                            }):Play();
                                                        end;
                                                    end;
                                                    if l_v56_0 then
                                                        for v61, v62 in ipairs(v30.CurrentTripwires) do
                                                            if v62 == l_v56_0 then
                                                                table.remove(v30.CurrentTripwires, v61);
                                                                break;
                                                            end;
                                                        end;
                                                    end;
                                                    v7:FireClientConnection(v30.Player, "TaphTripwireRemoved", "REMOTE_EVENT");
                                                end;
                                            end;
                                            if #v30.CurrentTripwires >= v30.Config.TripwireMaxAmount then
                                                local v64 = table.remove(v30.CurrentTripwires, 1);
                                                if v64 and v64.Remove then
                                                    v64.Remove();
                                                end;
                                            end;
                                            l_v56_0 = {
                                                Model = l_Model_0, 
                                                Remove = v63
                                            };
                                            table.insert(v30.CurrentTripwires, l_v56_0);
                                            v7:FireClientConnection(v30.Player, "TaphTripwireAdded", "REMOTE_EVENT");
                                            TaphSupport.Wire(v30,l_Model_0,v63);
                                            local armedAt=os.clock()+1.5;
                                            local v65 = nil;
                                            v65 = l_Part_0.Touched:Connect(function(v66) --[[ Line: 272 ]]
                                                -- upvalues: l_v55_0 (ref), v65 (ref), v63 (copy), v30 (ref), v4 (ref), v2 (ref), v5 (ref)
                                                if os.clock()<armedAt then return end;
                                                local l_v66_FirstAncestorOfClass_0 = v66:FindFirstAncestorOfClass("Model");
                                                if l_v66_FirstAncestorOfClass_0 and tostring(l_v66_FirstAncestorOfClass_0.Parent) == "Killers" and not l_v55_0 then
                                                    v65:Disconnect();
                                                    v63();
                                                    local v68 = (TaphSupport.Count(v30) - 1) * v30.Config.TripwireStackPenalty;
                                                    if not l_v66_FirstAncestorOfClass_0:GetAttribute("Invincible") then
                                                        local v69 = {
                                                            Duration = math.max(0, v30.Config.TripwireTriggerSlownessData.Duration - v68), 
                                                            Level = v30.Config.TripwireTriggerSlownessData.Level
                                                        };
                                                        v4:ApplyStatus(l_v66_FirstAncestorOfClass_0, "Slowness", v69);
                                                    end;
                                                    local v70 = l_v66_FirstAncestorOfClass_0:GetAttribute("Invincible") and v30.Config.TripwireTriggerAuraRevealInvincibleDuration or v30.Config.TripwireTriggerAuraRevealDuration;
                                                    local l_v2_ClosestPlayerFromPosition_1 = v2:GetClosestPlayerFromPosition(v30.Rig.PrimaryPart.Position, {
                                                        ReturnTable = true, 
                                                        MaxDistance = v30.Config.TripwireTriggerAuraRevealDistance, 
                                                        PlayerSelection = "Survivors", 
                                                        OverrideUndetectable = true
                                                    });
                                                    for _, v73 in pairs(l_v2_ClosestPlayerFromPosition_1) do
                                                        v2:RevealPlayerAuraTo(v73.Player, l_v66_FirstAncestorOfClass_0, (math.max(0, v70 - v68)));
                                                    end;
                                                    if not l_v66_FirstAncestorOfClass_0:GetAttribute((("TripwireTriggerTime%*"):format((tostring(v30.Player))))) or l_v66_FirstAncestorOfClass_0:GetAttribute((("TripwireTriggerTime%*"):format((tostring(v30.Player))))) <= os.clock() - v30.Config.TripwireDurationBetweenRewards then
                                                        l_v66_FirstAncestorOfClass_0:SetAttribute(("TripwireTriggerTime%*"):format((tostring(v30.Player))), os.clock());
                                                        v5:IncrementActorStats(v30.Player, {
                                                            Action = "Killer Triggered Tripwire", 
                                                            RewardType = "Survivalist"
                                                        });
                                                    end;
                                                end;
                                            end);
                                            l_Humanoid_0.HealthChanged:Connect(function(v74) --[[ Line: 308 ]]
                                                -- upvalues: l_v55_0 (ref), v63 (copy), l_Part_0 (copy), v2 (ref), v30 (ref)
                                                if v74 > 0 or l_v55_0 then
                                                    return;
                                                else
                                                    v63();
                                                    local v75 = OverlapParams.new();
                                                    v75.FilterType = Enum.RaycastFilterType.Include;
                                                    v75.FilterDescendantsInstances = {
                                                        workspace.Players.Killers
                                                    };
                                                    local v76 = {};
                                                    local l_workspace_PartBoundsInBox_0 = workspace:GetPartBoundsInBox(l_Part_0.CFrame, l_Part_0.Size + Vector3.new(7, 7, 7, 0), v75);
                                                    for _, v79 in pairs(l_workspace_PartBoundsInBox_0) do
                                                        local l_v79_FirstAncestor_0 = v79:FindFirstAncestor("Model");
                                                        if l_v79_FirstAncestor_0 and not v76[l_v79_FirstAncestor_0] then
                                                            v76[l_v79_FirstAncestor_0] = true;
                                                            for _, v82 in pairs(workspace.Players.Survivors:GetChildren()) do
                                                                v2:RevealPlayerAuraTo(v82, l_v79_FirstAncestor_0, v30.Config.TripwireDestroyedAuraDuration);
                                                            end;
                                                        end;
                                                    end;
                                                    return;
                                                end;
                                            end);
                                            task.delay(v30.Config.TripwireLifetime - (#v30 - 1) * v30.Config.TripwireLifetimeDecreasePerTaph, v63);
                                        end;
                                    end;
                                    v30:SetCooldownOf("Tripwire", v30.Config.TripwireCooldown);
                                    v30.Rig:SetAttribute("PlacingTripwire", nil);
                                    v30.Rig:SetAttribute("TripwireOrigin", nil);
                                    v30.Rig:SetAttribute("TripwireEnding", nil);
                                    return;
                                end;
                            end);
                        end;
                    end;
                end;
                task.delay(v30.Config.TripwireCooldownWhilePlacing, function() --[[ Line: 342 ]]
                    -- upvalues: v30 (copy)
                    v30.AbilitiesDisabled = false;
                end);
                return v30.Placing;
            else
                if game["Run Service"]:IsClient() then
                    if typeof(v31) == "table" and v31.Cancelled then
                        local v83 = {
                            collision = "Tripwire placement point is obstructed by something. Move back a bit.", 
                            noBuild = math.random(1, 2500) == 3 and "CAMO!!!!" or "You can't build here.", 
                            tooClose = "Tripwire placement point is too close to another tripwire.", 
                            midair = "Tripwire placement point is too high above ground. Turn around and try again.", 
                            facingWall = "You're too close to a wall. Turn around and try again.", 
                            intersecting = "Your tripwire's intersecting with a wall. Make sure that there's nothing blocking its origin & end points.", 
                            unknown = "Something went wrong. Try placing the tripwire somewhere else."
                        };
                        local v84 = v83[v31.Reason] or v83.unknown;
                        v2:CreateWarning("BuildermanWarning", v84, v30.Config.WarningTemplate);
                        return;
                    elseif v31 == true then
                        v30.AnimationType = "Tripwire";
                        v30.Animations.TripwireIdle:Play();
                        v30.Animations.TripwirePlaceStart:Play(0.025);
                        v30.MovementAnimSpeed = 1;
                        local l_v2_SpeedMultiplier_0 = v2:CreateSpeedMultiplier(v30.Rig, 1, "TaphTripwire");
                        game.TweenService:Create(l_v2_SpeedMultiplier_0, TweenInfo.new(0.25), {
                            Value = 0
                        }):Play();
                        local v86 = false;
                        local l_Health_1 = v30.Rig.Humanoid.Health;
                        local v88 = nil;
                        do
                            local l_v86_0, l_v88_0 = v86, v88;
                            l_v88_0 = v30.Rig.Humanoid.HealthChanged:Connect(function(v91) --[[ Line: 383 ]]
                                -- upvalues: l_Health_1 (copy), l_v86_0 (ref)
                                if v91 + 4.75 < l_Health_1 then
                                    l_v86_0 = true;
                                end;
                            end);
                            task.delay(1, function() --[[ Line: 390 ]]
                                -- upvalues: l_v2_SpeedMultiplier_0 (copy), v30 (copy), l_v86_0 (ref), l_v88_0 (ref)
                                game.TweenService:Create(l_v2_SpeedMultiplier_0, TweenInfo.new(1), {
                                    Value = v30.Config.TripwireSpeedWhilePlacing / v30.Config.Speed
                                }):Play();
                                repeat
                                    task.wait();
                                until not v30.Rig:GetAttribute("PlacingTripwire") or not v30.Rig.Parent or l_v86_0;
                                if not v30.Rig.Parent then
                                    return;
                                else
                                    l_v88_0:Disconnect();
                                    v30.AnimationType = nil;
                                    v30.Animations.TripwireIdle:Stop();
                                    v30.Animations.TripwirePlaceEnd:Play(0);
                                    v30.MovementAnimSpeed = nil;
                                    if l_v86_0 then
                                        l_v2_SpeedMultiplier_0:Destroy();
                                        v30.Animations.TripwirePlaceEnd:Stop(0.2);
                                        return;
                                    else
                                        l_v2_SpeedMultiplier_0.Value = 0;
                                        task.delay(0.5, function() --[[ Line: 414 ]]
                                            -- upvalues: l_v2_SpeedMultiplier_0 (ref)
                                            game.TweenService:Create(l_v2_SpeedMultiplier_0, TweenInfo.new(0.75, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
                                                Value = 1
                                            }):Play();
                                            game.Debris:AddItem(l_v2_SpeedMultiplier_0, 0.75);
                                        end);
                                        return;
                                    end;
                                end;
                            end);
                        end;
                    end;
                end;
                return;
            end;
        end
    }, 
    SubspaceTripmine = {
        LayoutOrder = 2, 
        KeybindType = "AltAbility2", 
        Icon = "rbxassetid://89334370123950", 
        CurrentRecharge = 0, 
        ChargeDuration = 0, 
        Callback = function(v92, _) --[[ Line: 435 ]] --[[ Name: Callback ]]
            -- upvalues: v1 (copy), v15 (copy), v2 (copy), v7 (copy), v4 (copy), v5 (copy)
            if game["Run Service"]:IsServer() then
                v92.AbilitiesDisabled = true;
                local l_SubspaceTripmine_0 = v92.Rig.SubspaceTripmine;
                for _, v96 in pairs(l_SubspaceTripmine_0:GetDescendants()) do
                    if v96:IsA("BasePart") then
                        v96.Transparency = 0;
                    elseif v96:IsA("ParticleEmitter") then
                        v96.Enabled = true;
                    end;
                end;
                v1:Play(v92.Config.Sounds.SubspaceUse, {
                    Parent = v92.Rig.PrimaryPart
                });
                v15(v92.Behavior, "SubspaceBegin", v92);
                task.delay(1.98, function() --[[ Line: 451 ]]
                    -- upvalues: v92 (copy), l_SubspaceTripmine_0 (copy), v2 (ref), v7 (ref), v1 (ref), v4 (ref), v5 (ref)
                    if not v92.Rig.Parent or not v92.Rig.PrimaryPart or v92.Rig.PrimaryPart.Anchored or v92.Rig.Humanoid.Health <= 0 then
                        for _, v98 in pairs(l_SubspaceTripmine_0:GetDescendants()) do
                            if v98:IsA("BasePart") then
                                v98.Transparency = 1;
                            elseif v98:IsA("ParticleEmitter") then
                                v98.Enabled = false;
                            end;
                        end;
                        return;
                    else
                        local v99 = l_SubspaceTripmine_0:Clone();
                        v99:SetAttribute("Team", "Survivors");
                        v99:SetAttribute("ExecutionsDisabled", true);
                        v99.Parent = workspace.Map.Ingame;
                        local v100 = game:GetService("HttpService"):GenerateGUID(false);
                        v99:SetAttribute("TripmineId", v100);
                        for _, v102 in pairs(v99:GetDescendants()) do
                            if v102:IsA("BasePart") then
                                v102.Transparency = 0;
                                v102:SetNetworkOwner(nil);
                                v102.CanCollide = true;
                                v102.CanQuery = true;
                                v102.CollisionGroup = "Ragdolls";
                            elseif v102:IsA("ParticleEmitter") then
                                v102.Enabled = true;
                            end;
                        end;
                        local l_v2_ClosestPlayerFromPosition_2 = v2:GetClosestPlayerFromPosition(v92.Rig.PrimaryPart.Position, {
                            MaxDistance = v92.Config.SubspacePingDistance, 
                            ReturnTable = true, 
                            OverrideUndetectable = true
                        });
                        for _, v105 in pairs(l_v2_ClosestPlayerFromPosition_2) do
                            local l_Player_1 = v105.Player;
                            local l_PlayerFromCharacter_1 = game.Players:GetPlayerFromCharacter(l_Player_1);
                            if l_PlayerFromCharacter_1 then
                                v2:RevealPlayerAuraTo(l_PlayerFromCharacter_1, v99, "inf", Color3.new(0.75, 1, 0.75));
                            end;
                        end;
                        v99:SetAttribute("Invincible", true);
                        task.delay(1, function() --[[ Line: 498 ]]
                            -- upvalues: v99 (copy), v7 (ref), v92 (ref), v100 (copy)
                            if not v99.Parent then
                                return;
                            else
                                v99:SetAttribute("Invincible", nil);
                                v7:FireClientConnection(v92.Player, "TaphTripmineTimerStart", "REMOTE_EVENT", v100, v92.Config.SubspaceLifetime);
                                return;
                            end;
                        end);
                        for _, v109 in pairs(l_SubspaceTripmine_0:GetDescendants()) do
                            if v109:IsA("BasePart") then
                                v109.Transparency = 1;
                            elseif v109:IsA("ParticleEmitter") then
                                v109.Enabled = false;
                            end;
                        end;
                        v1:Play(v92.Config.Sounds.SubspaceToss, {
                            Parent = v99.PrimaryPart
                        });
                        for _, v111 in pairs(v99:GetDescendants()) do
                            if v111:IsA("BasePart") then
                                v111.CanCollide = true;
                                if v111 ~= v99.PrimaryPart then
                                    local l_WeldConstraint_0 = Instance.new("WeldConstraint");
                                    l_WeldConstraint_0.Parent = v111;
                                    l_WeldConstraint_0.Part1 = v111;
                                    l_WeldConstraint_0.Part0 = v99.PrimaryPart;
                                end;
                                game.TweenService:Create(v111, TweenInfo.new(4, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
                                    Transparency = v92.Config.SubspaceHiddenTransparency
                                }):Play();
                            elseif v111:IsA("Light") then
                                v111.Brightness = 1;
                                v111.Range = v92.Config.SubspaceRange;
                                game.TweenService:Create(v111, TweenInfo.new(4, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
                                    Brightness = 0
                                }):Play();
                            elseif v111:IsA("ParticleEmitter") then
                                task.delay(4, function() --[[ Line: 532 ]]
                                    -- upvalues: v111 (copy)
                                    v111.Enabled = false;
                                end);
                            end;
                        end;
                        v99.PrimaryPart.Velocity = CFrame.lookAt(v92.Rig.PrimaryPart.Position, (v92.Rig.PrimaryPart.CFrame * CFrame.new(-1, 5, -10)).Position).LookVector * v92.Config.SubspaceThrowForce;
                        local l_Humanoid_1 = Instance.new("Humanoid");
                        l_Humanoid_1.EvaluateStateMachine = false;
                        l_Humanoid_1.BreakJointsOnDeath = false;
                        l_Humanoid_1.RequiresNeck = false;
                        l_Humanoid_1.Health = 1;
                        l_Humanoid_1.Parent = v99;
                        local v114 = false;
                        local v115 = false;
                        l_Humanoid_1.HealthChanged:Connect(function(v116) --[[ Line: 556 ]]
                            -- upvalues: v115 (ref), v7 (ref), v92 (ref), v100 (copy), v114 (ref), v99 (copy), v2 (ref), v4 (ref), v5 (ref)
                            if v116 > 0.1275 then
                                return;
                            else
                                if not v115 then
                                    v115 = true;
                                    v7:FireClientConnection(v92.Player, "TaphTripmineTimerEnd", "REMOTE_EVENT", v100, v114);
                                end;
                                for _, v118 in pairs(v99:GetDescendants()) do
                                    if v118:IsA("BasePart") then
                                        game.TweenService:Create(v118, TweenInfo.new(v92.Config.SubspaceExplosionDelay, Enum.EasingStyle.Linear), {
                                            Transparency = 0, 
                                            Size = v118.Size * 1.3
                                        }):Play();
                                    elseif v118:IsA("Light") then
                                        game.TweenService:Create(v118, TweenInfo.new(v92.Config.SubspaceExplosionDelay * 1.275), {
                                            Brightness = 12
                                        }):Play();
                                    elseif v118:IsA("ParticleEmitter") then
                                        v118.Enabled = true;
                                    end;
                                end;
                                TaphSupport.Schedule(v92,v99,v92.Config.SubspaceExplosionDelay, function() --[[ Line: 579 ]]
                                    -- upvalues: v92 (ref), v99 (ref), v2 (ref), v4 (ref), v5 (ref), v7 (ref)
                                    local v119 = (TaphSupport.Count(v92) - 1) * v92.Config.SubspaceStackPenalty;
                                    local l_v99_BoundingBox_0, _ = v99:GetBoundingBox();
                                    local l_v2_ClosestPlayerFromPosition_3 = v2:GetClosestPlayerFromPosition(l_v99_BoundingBox_0.Position, {
                                        ReturnTable = true, 
                                        OverrideUndetectable = true, 
                                        IncludedSelection = {
                                            v92.Rig
                                        }, 
                                        PlayerSelection = "Killers", 
                                        MaxDistance = v92.Config.SubspaceRange
                                    });
                                    local v123 = nil;
                                    local v124 = nil;
                                    for _, v126 in pairs(l_v2_ClosestPlayerFromPosition_3) do
                                        if not v126.Player:GetAttribute("TaphSubspaced") or os.clock() > v126.Player:GetAttribute("TaphSubspaced") + v92.Config.SubspaceEffectDuration then
                                            if v126.Player == v92.Character then
                                                v123 = true;
                                            end;
                                            if tostring(v126.Player.Parent) == "Killers" then
                                                v124 = true;
                                            end;
                                            local v127 = v126.Player~=v92.Rig and v99:GetAttribute("RecentAttacker") == tostring(game.Players:GetPlayerFromCharacter(v126.Player));
                                            if v92.Config.SubspaceEffectDuration-v119>0 then v4:ApplyStatus(v126.Player, "Subspaced", {
                                                Level = v127 and v92.Config.SubspaceEffectHitLevel or v92.Config.SubspaceEffectLevel, 
                                                Duration = math.max(0,v92.Config.SubspaceEffectDuration - v119)
                                            });end;
                                            if not v126.Player:GetAttribute("Invincible") and not v127 and v92.Config.SubspaceHelplessDuration-v119>0 then
                                                v4:ApplyStatus(v126.Player, "Helpless", {
                                                    Level = 1, 
                                                    Duration = math.max(0,v92.Config.SubspaceHelplessDuration - v119), 
                                                    TimeStackable = false
                                                });
                                            end;
                                            if not v126.Player:GetAttribute("Invincible") and (not v127 or v126.Player==v92.Rig)then
                                                local duration=math.max(0,v92.Config.SubspaceWeaknessDuration-v119);
                                                if duration>0 then v4:ApplyStatus(v126.Player,"Weakness",{Level=v92.Config.SubspaceWeaknessLevel,Duration=duration,TimeStackable=false})end;
                                            end;
                                            v126.Player:SetAttribute("TaphSubspaced", os.clock());
                                        end;
                                    end;
                                    if v124 then
                                        v92:SetCooldownOf("SubspaceTripmine", -v92.Config.SubspaceCooldownReductionOnSuccess);
                                    end;
                                    if v124 and not v123 then
                                        v5:IncrementActorStats(v92.Player, {
                                            Action = "Killer Triggered Subspace Tripmine", 
                                            RewardType = "Offensive"
                                        });
                                    end;
                                    v7:FireAllClientConnection("TaphAudioReplication", "REMOTE_EVENT", l_v99_BoundingBox_0);
                                    local v128 = v92.Config.SubspaceExplosionVFX:Clone();
                                    v128:SetPrimaryPartCFrame(CFrame.new(l_v99_BoundingBox_0.Position));
                                    v128.Name = "TaphTripmineVFX";
                                    v128.Parent = workspace.Map.Ingame;
                                    game.Debris:AddItem(v128, 2);
                                    for _, v130 in pairs(v128:GetDescendants()) do
                                        if v130:IsA("ParticleEmitter") then
                                            v130:Emit(v130:GetAttribute("EmitCount") or 5);
                                        elseif v130:IsA("Light") then
                                            game.TweenService:Create(v130, TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                                                Brightness = 0
                                            }):Play();
                                        end;
                                    end;
                                    v99:Destroy();
                                end);
                                return;
                            end;
                        end);
                        TaphSupport.Mine(v92,v99,l_Humanoid_1);
                        task.delay(3, function() --[[ Line: 637 ]]
                            -- upvalues: l_Humanoid_1 (copy), v99 (copy), v2 (ref), v92 (ref), v115 (ref), v7 (ref), v100 (copy), v114 (ref), v1 (ref)
                            local v131 = 0;
                            local v132 = os.clock();
                            while v99.Parent and l_Humanoid_1.Health > 0.125 and v99.PrimaryPart do
                                local l_v2_ClosestPlayerFromPosition_4 = TaphSupport.VisibleKiller(v92,v99,v2);
                                if l_v2_ClosestPlayerFromPosition_4 or v92.Config.SubspaceLifetime <= v131 then
                                    if v92.Config.SubspaceLifetime <= v131 and not v115 then
                                        v115 = true;
                                        v7:FireClientConnection(v92.Player, "TaphTripmineTimerEnd", "REMOTE_EVENT", v100, false);
                                    end;
                                    v114 = l_v2_ClosestPlayerFromPosition_4 ~= nil;
                                    l_Humanoid_1.Health = 0.125;
                                elseif v92.Config.SubspaceHintCount >= 1 and os.clock() >= v132 + v92.Config.SubspaceLifetime / (math.round(v92.Config.SubspaceHintCount) + 1) then
                                    v132 = os.clock();
                                    v1:Play(v92.Config.Sounds.SubspaceHint, {
                                        Parent = v99.PrimaryPart
                                    });
                                    for _, v135 in pairs(v99:GetDescendants()) do
                                        if v135:IsA("BasePart") then
                                            game.TweenService:Create(v135, TweenInfo.new(2, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut, 0, true), {
                                                Transparency = v92.Config.SubspaceHintTransparency
                                            }):Play();
                                        elseif v135:IsA("Light") then
                                            game.TweenService:Create(v135, TweenInfo.new(2, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut, 0, true), {
                                                Brightness = 0.5
                                            }):Play();
                                        end;
                                    end;
                                end;
                                v131 = v131 + task.wait();
                            end;
                        end);
                        return;
                    end;
                end);
                task.delay(4, function() --[[ Line: 678 ]]
                    -- upvalues: v92 (copy)
                    v92.AbilitiesDisabled = false;
                end);
                return;
            else
                if game["Run Service"]:IsClient() then
                    v92.Animations.ThrowSubspace:Play(0.05);
                    local l_v2_SpeedMultiplier_1 = v2:CreateSpeedMultiplier(v92.Rig, 0.6, "SubspaceTripmine");
                    task.delay(2, function() --[[ Line: 686 ]]
                        -- upvalues: l_v2_SpeedMultiplier_1 (copy)
                        l_v2_SpeedMultiplier_1:Destroy();
                    end);
                end;
                return;
            end;
        end
    }
};
local function v142(v137) --[[ Line: 696 ]] --[[ Name: updateTripmineTimerBars ]]
    local l_SubspaceTripmine_1 = v137.Behavior.Abilities.SubspaceTripmine;
    if not l_SubspaceTripmine_1 then
        return;
    elseif #v137.ActiveTripmineBars > 0 then
        table.sort(v137.ActiveTripmineBars, function(v139, v140) --[[ Line: 703 ]]
            return v139.StartTime < v140.StartTime;
        end);
        local v141 = v137.ActiveTripmineBars[1];
        l_SubspaceTripmine_1.CurrentRecharge = os.clock() - v141.StartTime;
        l_SubspaceTripmine_1.ChargeDuration = v141.Duration;
        return;
    else
        l_SubspaceTripmine_1.CurrentRecharge = 0;
        l_SubspaceTripmine_1.ChargeDuration = 0;
        return;
    end;
end;
local function v149(v143, v144, v145) --[[ Line: 721 ]] --[[ Name: updateAbilityCounter ]]
    local l_AbilityContainer_0 = v143.Player.PlayerGui.MainUI:FindFirstChild("AbilityContainer");
    local v147 = l_AbilityContainer_0 and l_AbilityContainer_0:FindFirstChild(v144);
    if not v147 then
        return;
    else
        if not v143[("Current%*Count"):format(v144)] then
            v143[("Current%*Count"):format(v144)] = 0;
        end;
        v143[("Current%*Count"):format(v144)] = math.max(0, v143[("Current%*Count"):format(v144)] + v145);
        v147.Charges.Text = v143[("Current%*Count"):format(v144)] == 0 and "" or tostring(v143[("Current%*Count"):format(v144)]);
        if v144 == "Tripwire" then
            local v148 = v143[("Current%*Count"):format(v144)] >= v143.Config.TripwireMaxAmount;
            v147.Charges.TextColor3 = v148 and Color3.new(1, 0, 0) or Color3.new(1, 1, 1);
            return;
        else
            v147.Charges.TextColor3 = Color3.new(1, 1, 1);
            return;
        end;
    end;
end;
v0.Created = function(_, v151) --[[ Line: 747 ]] --[[ Name: Created ]]
    if game["Run Service"]:IsServer() then TaphSupport.Bind(v151)end;
    -- upvalues: v2 (copy), v29 (copy), v7 (copy), v1 (copy), v142 (copy), v149 (copy)
    if game["Run Service"]:IsClient() then
        v151.ActiveTripmineBars = {};
        local v152 = nil;
        v152 = workspace.Map.Ingame.ChildAdded:Connect(function(v153) --[[ Line: 753 ]]
            -- upvalues: v151 (copy), v152 (ref), v2 (ref)
            if not v151.Rig.Parent then
                v152:Disconnect();
                v152 = nil;
                return;
            else
                if v153.Name == "TaphTripmineVFX" and v2:GetSettingValue("EpilepsyMode") then
                    v153:Destroy();
                end;
                return;
            end;
        end);
        local v154 = false;
        v151.Rig:GetAttributeChangedSignal("TripwireOrigin"):Connect(function() --[[ Line: 763 ]]
            -- upvalues: v151 (copy), v154 (ref), v29 (ref)
            local l_Attribute_3 = v151.Rig:GetAttribute("TripwireOrigin");
            if l_Attribute_3 then
                v154 = true;
                local v156 = v151.Config.TripwireTemplate:Clone();
                v156.Name = "FakeHook";
                v156.Transparency = 1;
                v156.CanCollide = false;
                v156.CanQuery = false;
                v156.Material = Enum.Material.Neon;
                v156.Parent = workspace.Map.Ingame;
                v156.CFrame = l_Attribute_3 * v151.Config.TripwireCFrameOffset;
                game.TweenService:Create(v156, TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                    Transparency = 0.65
                }):Play();
                if v156:IsA("UnionOperation") then
                    v156.UsePartColor = true;
                end;
                local l_Part_1 = Instance.new("Part");
                l_Part_1.Name = "FakeWire";
                l_Part_1.Transparency = 1;
                l_Part_1.Anchored = true;
                l_Part_1.CanCollide = false;
                l_Part_1.CanQuery = false;
                l_Part_1.Material = Enum.Material.Neon;
                l_Part_1.Parent = workspace.Map.Ingame;
                game.TweenService:Create(l_Part_1, TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                    Transparency = 0.65
                }):Play();
                local function v163() --[[ Line: 796 ]] --[[ Name: updatePos ]]
                    -- upvalues: v151 (ref), l_Attribute_3 (copy), v29 (ref), l_Part_1 (copy), v156 (copy)
                    local v158 = v151.Rig.PrimaryPart.CFrame * CFrame.new(0, -2, -2) + Vector3.new(0, 0.30000001192092896, 0, 0);
                    local l_Magnitude_2 = (l_Attribute_3.Position - v158.Position).Magnitude;
                    local v160 = l_Attribute_3.Position:Lerp(v158.Position, 0.5);
                    local v161 = CFrame.lookAt(v160, v158.Position);
                    local v162 = v29(v151, v158 - Vector3.new(0, 0.30000001192092896, 0, 0), l_Attribute_3);
                    l_Part_1.Position = v160 + Vector3.new(0, 0.20000000298023224, 0, 0);
                    l_Part_1.CFrame = v161;
                    l_Part_1.Size = Vector3.new(0.1, 0.1, l_Magnitude_2);
                    l_Part_1.Color = v162 == "placed" and Color3.new(0.4, 1, 0.4) or Color3.new(1, 0.25, 0.25);
                    v156.Color = v162 == "placed" and Color3.new(0.4, 1, 0.4) or Color3.new(1, 0.25, 0.25);
                    if v151.Config.TripwireLookAt then
                        v156.CFrame = CFrame.new(v156.Position, v158.Position) * v151.Config.TripwireCFrameOffset;
                    end;
                end;
                v163();
                while task.wait() and v154 and v151.Rig.Parent do
                    v163();
                end;
                for _, v165 in pairs({
                    v156, 
                    l_Part_1
                }) do
                    game.TweenService:Create(v165, TweenInfo.new(1), {
                        Transparency = 1
                    }):Play();
                    game.Debris:AddItem(v165, 1);
                end;
                return;
            else
                v154 = false;
                return;
            end;
        end);
        v7:SetConnection("TaphAudioReplication", "REMOTE_EVENT", function(v166) --[[ Line: 831 ]]
            -- upvalues: v1 (ref), v2 (ref), v151 (copy)
            v1:Play(v2:GetSettingValue("SensitiveSFXMode") and v151.Config.Sounds.SubspaceDetonateSensitive or v151.Config.Sounds.SubspaceDetonate, {
                Position = v166.Position
            });
        end);
        v7:SetConnection("TaphTripmineTimerStart", "REMOTE_EVENT", function(v167, v168) --[[ Line: 836 ]]
            -- upvalues: v151 (copy), v142 (ref)
            local v169 = {
                Id = v167, 
                StartTime = os.clock(), 
                Duration = v168, 
                Progress = 1
            };
            table.insert(v151.ActiveTripmineBars, v169);
            v142(v151);
            local l_v151_0 = v151;
            local l_AbilityContainer_1 = l_v151_0.Player.PlayerGui.MainUI:FindFirstChild("AbilityContainer");
            local v172 = l_AbilityContainer_1 and l_AbilityContainer_1:FindFirstChild("SubspaceTripmine");
            if not v172 then
                return;
            else
                if not l_v151_0.CurrentSubspaceTripmineCount then
                    l_v151_0.CurrentSubspaceTripmineCount = 0;
                end;
                l_v151_0.CurrentSubspaceTripmineCount = math.max(0, l_v151_0.CurrentSubspaceTripmineCount + 1);
                v172.Charges.Text = l_v151_0.CurrentSubspaceTripmineCount == 0 and "" or tostring(l_v151_0.CurrentSubspaceTripmineCount);
                v172.Charges.TextColor3 = Color3.new(1, 1, 1);
                return;
            end;
        end);
        v7:SetConnection("TaphTripmineTimerEnd", "REMOTE_EVENT", function(v173, _) --[[ Line: 852 ]]
            -- upvalues: v151 (copy), v142 (ref)
            for v175, v176 in ipairs(v151.ActiveTripmineBars) do
                if v176.Id == v173 then
                    table.remove(v151.ActiveTripmineBars, v175);
                    break;
                end;
            end;
            v142(v151);
            local l_v151_1 = v151;
            local l_AbilityContainer_2 = l_v151_1.Player.PlayerGui.MainUI:FindFirstChild("AbilityContainer");
            local v179 = l_AbilityContainer_2 and l_AbilityContainer_2:FindFirstChild("SubspaceTripmine");
            if not v179 then
                return;
            else
                if not l_v151_1.CurrentSubspaceTripmineCount then
                    l_v151_1.CurrentSubspaceTripmineCount = 0;
                end;
                l_v151_1.CurrentSubspaceTripmineCount = math.max(0, l_v151_1.CurrentSubspaceTripmineCount + -1);
                v179.Charges.Text = l_v151_1.CurrentSubspaceTripmineCount == 0 and "" or tostring(l_v151_1.CurrentSubspaceTripmineCount);
                v179.Charges.TextColor3 = Color3.new(1, 1, 1);
                return;
            end;
        end);
        v7:SetConnection("TaphTripwireAdded", "REMOTE_EVENT", function() --[[ Line: 867 ]]
            -- upvalues: v149 (ref), v151 (copy)
            v149(v151, "Tripwire", 1);
        end);
        v7:SetConnection("TaphTripwireRemoved", "REMOTE_EVENT", function() --[[ Line: 871 ]]
            -- upvalues: v149 (ref), v151 (copy)
            v149(v151, "Tripwire", -1);
        end);
        local v180 = nil;
        v180 = game:GetService("RunService").RenderStepped:Connect(function() --[[ Line: 877 ]]
            -- upvalues: v151 (copy), v180 (ref), v142 (ref)
            if not v151.Rig or not v151.Rig.Parent then
                v180:Disconnect();
                return;
            else
                local v181 = false;
                for v182 = #v151.ActiveTripmineBars, 1, -1 do
                    local v183 = v151.ActiveTripmineBars[v182];
                    local v184 = math.max(0, 1 - (os.clock() - v183.StartTime) / v183.Duration);
                    if v184 ~= v183.Progress then
                        v183.Progress = v184;
                        v181 = true;
                    end;
                    if v184 <= 0 then
                        table.remove(v151.ActiveTripmineBars, v182);
                        v181 = true;
                    end;
                end;
                if v181 then
                    v142(v151);
                end;
                return;
            end;
        end);
        return;
    else
        v151.CurrentTripwires = {};
        return;
    end;
end;
v0.Destroyed = function(_, v186) --[[ Line: 910 ]] --[[ Name: Destroyed ]]
    if game["Run Service"]:IsServer() then TaphSupport.Stop(v186)end;
    -- upvalues: v7 (copy)
    v7:RemoveConnection("TaphTripmineTimerStart", "REMOTE_EVENT");
    v7:RemoveConnection("TaphTripmineTimerEnd", "REMOTE_EVENT");
    v7:RemoveConnection("TaphAudioReplication", "REMOTE_EVENT");
    v7:RemoveConnection("TaphTripwireAdded", "REMOTE_EVENT");
    v7:RemoveConnection("TaphTripwireRemoved", "REMOTE_EVENT");
    if game["Run Service"]:IsClient() and v186.ActiveTripmineBars then
        v186.ActiveTripmineBars = {};
    end;
end;
v0.LastManStanding = function(_, v188, _) --[[ Line: 924 ]] --[[ Name: LastManStanding ]]
    -- upvalues: v6 (copy)
    if not game["Run Service"]:IsServer() then
        return;
    else
        if v188.Player then
            local l_status_1, l_result_1 = pcall(function() --[[ Line: 928 ]]
                -- upvalues: v6 (ref), v188 (copy)
                v6:IncrementAchievementProgress(v188.Player, "TaphGetLastManStanding");
            end);
            if not l_status_1 then
                warn((("[%*/LastManStanding]: Failed to award %* the achievement: TaphGetLastManStanding due to: %*"):format(script.Parent, v188.Player, l_result_1)));
            end;
        end;
        return;
    end;
end;
v0.CreateTripwireHooks = function(_, v193, v194) --[[ Line: 938 ]] --[[ Name: CreateTripwireHooks ]]
    local l_Attribute_4 = v193.Rig:GetAttribute("TripwireOrigin");
    local l_Attribute_5 = v193.Rig:GetAttribute("TripwireEnding");
    local v197 = v193.Config.TripwireTemplate:Clone();
    v197.Name = "Hook1";
    v197.Parent = v194;
    v197.CFrame = l_Attribute_4 * v193.Config.TripwireCFrameOffset;
    local v198 = v193.Config.TripwireTemplate:Clone();
    v198.Name = "Hook2";
    v198.Parent = v194;
    v198.CFrame = l_Attribute_5 * v193.Config.TripwireCFrameOffset;
    return v197, v198;
end;
return v0;