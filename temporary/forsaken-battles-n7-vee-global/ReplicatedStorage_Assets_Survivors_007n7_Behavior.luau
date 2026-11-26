-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local GameplayPolish=require(game.ReplicatedStorage.Modules.GameplayPolish)
local v0 = {};
local v1 = require(game.ReplicatedStorage.Modules.Sounds);
local v2 = require(game.ReplicatedStorage.Modules.Util);
local _ = require(game.ReplicatedStorage.Modules.Hitboxes);
local v4 = require(game.ReplicatedStorage.Modules.AchievementUtil);
local v5 = require(game.ReplicatedStorage.Modules.Statuses);
local function v17(v6) --[[ Line: 10 ]] --[[ Name: getFurthestSpawn ]]
    local _ = nil;
    local l_FirstChild_0 = workspace.Map.Ingame:FindFirstChild("SpawnPoints", true);
    if not l_FirstChild_0 then
        return;
    else
        local v9 = nil;
        local v10 = nil;
        for _, v12 in pairs({
            "Survivors", 
            "Killers"
        }) do
            local l_l_FirstChild_0_FirstChild_0 = l_FirstChild_0:FindFirstChild(v12);
            if l_l_FirstChild_0_FirstChild_0 then
                for _, v15 in ipairs(l_l_FirstChild_0_FirstChild_0:GetChildren()) do
                    if v15:IsA("BasePart") then
                        local l_Magnitude_0 = (v6.Rig.PrimaryPart.Position - v15.Position).Magnitude;
                        if not v9 or v10 and v10 <= l_Magnitude_0 then
                            v9 = v15;
                            v10 = l_Magnitude_0;
                        end;
                    end;
                end;
            end;
        end;
        return v9;
    end;
end;
local function v24(v18, v19) --[[ Line: 41 ]] --[[ Name: updHitPriority ]]
    local l_Player_0 = v18.Player;
    local v21 = l_Player_0 and l_Player_0.Character;
    local v22 = v21 and v21:FindFirstChild("Humanoid");
    if not v22 then
        warn((("[updHitPriority]: No Humanoid found for %*"):format(v18.Player.Name)));
        return;
    else
        local l_Humanoid_0 = v19:FindFirstChildOfClass("Humanoid");
        if not l_Humanoid_0 then
            warn("[updHitPriority]: No Humanoid found for clone");
            return;
        else
            v19:SetAttribute("HitboxPriority", l_Humanoid_0.Health >= v22.Health and 2 or 0);
            return;
        end;
    end;
end;
local v41 = {
    {
        Type = "aimless", 
        Callback = function(_, v26, _) --[[ Line: 66 ]] --[[ Name: Callback ]]
            local l_Humanoid_1 = v26:FindFirstChild("Humanoid");
            if not l_Humanoid_1 then
                return;
            else
                task.spawn(function() --[[ Line: 71 ]]
                    -- upvalues: v26 (copy), l_Humanoid_1 (copy)
                    while task.wait(math.random(2, 4)) and v26.Parent and v26.PrimaryPart do
                        l_Humanoid_1:MoveTo(v26.PrimaryPart.Position + Vector3.new(math.random(-100, 100) * 100, 0, math.random(-100, 100) * 100));
                    end;
                end);
                return;
            end;
        end
    }, 
    {
        Type = "pathfind", 
        SpawnRequired = true, 
        Callback = function(v29, v30, v31) --[[ Line: 82 ]] --[[ Name: Callback ]]
            local l_Humanoid_2 = v30:FindFirstChild("Humanoid");
            if not l_Humanoid_2 then
                return;
            else
                task.spawn(function() --[[ Line: 87 ]]
                    -- upvalues: v30 (copy), l_Humanoid_2 (copy), v31 (copy)
                    local v33 = require(game.ReplicatedStorage.Modules.SimplePath).new(v30, {
                        AgentRadius = 5
                    });
                    while v30.Parent and v30.PrimaryPart and l_Humanoid_2.Health > 0 do
                        v33:Run(v31.Position);
                        task.wait(0.12);
                    end;
                    v33:Destroy();
                end);
                task.spawn(function() --[[ Line: 97 ]]
                    -- upvalues: v29 (copy), v30 (copy), l_Humanoid_2 (copy)
                    local v34 = 0;
                    while v34 <= v29.Config.CloneControlWindup and v30.Parent and v30.PrimaryPart and l_Humanoid_2.Health > 0 do
                        l_Humanoid_2:MoveTo((v30.PrimaryPart.CFrame * CFrame.new(0, 0, -100)).Position);
                        v34 = v34 + task.wait();
                    end;
                end);
                return;
            end;
        end
    }, 
    {
        Type = "cursor", 
        Callback = function(v35, v36, _) --[[ Line: 109 ]] --[[ Name: Callback ]]
            -- upvalues: v2 (copy)
            local l_Humanoid_3 = v36:FindFirstChild("Humanoid");
            if not l_Humanoid_3 then
                return;
            else
                task.delay(v35.Config.CloneControlWindup, function() --[[ Line: 114 ]]
                    -- upvalues: v36 (copy), v35 (copy), v2 (ref), l_Humanoid_3 (copy)
                    local v39 = os.clock();
                    while task.wait() and v36.Parent and v36.PrimaryPart and v35.Player.Parent do
                        local l_v2_PlayerMousePosition_0 = v2:GetPlayerMousePosition(v35.Player);
                        if l_v2_PlayerMousePosition_0 then
                            l_Humanoid_3:MoveTo(l_v2_PlayerMousePosition_0);
                            v39 = os.clock();
                        end;
                    end;
                end);
                return;
            end;
        end
    }
};
v0.Abilities = {
    Clone = {
        LayoutOrder = 1, 
        KeybindType = "AltAbility1", 
        Icon = "rbxassetid://83534637834767", 
        Callback = function(v42, _) --[[ Line: 134 ]] --[[ Name: Callback ]]
            -- upvalues: v2 (copy), v24 (copy), v41 (copy), v17 (copy), v1 (copy), v4 (copy), v5 (copy)
            if game["Run Service"]:IsServer() then
                v42.AbilitiesDisabled = true;
                local lifetime=GameplayPolish.CloneLifetime(v42.Config,(v41[v42.PathfindType]or v41[1]).Type);
                for v44 = 1, v42.Config.CloneAmount do
                    local v45 = true;
                    local v46 = v42.Rig:Clone();
                    v2:AddHitboxes(v46, "Survivors");
                    game.Debris:AddItem(v46, lifetime + 1);
                    local l_Humanoid_4 = v46.Humanoid;
                    local _ = v46.PrimaryPart;
                    v46:SetAttribute("Team", "Survivors");
                    v46:AddTag("SimulateSurvivor");
                    v46.Parent = workspace.Map.Ingame;
                    GameplayPolish.CloneTracker(v42,v46,lifetime);
                    l_Humanoid_4.WalkSpeed = v42.Config.CloneSpeed;
                    l_Humanoid_4:MoveTo((v46.PrimaryPart.CFrame * CFrame.new(0, 0, -100)).Position);
                    l_Humanoid_4:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false);
                    l_Humanoid_4:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false);
                    l_Humanoid_4:SetStateEnabled(Enum.HumanoidStateType.Physics, false);
                    local v49 = v42.Player.Character.Humanoid.HealthChanged:Connect(function() --[[ Line: 162 ]]
                        -- upvalues: v24 (ref), v42 (copy), v46 (copy)
                        v24(v42, v46);
                    end);
                    v24(v42, v46);
                    local v50 = false;
                    do
                        local l_v45_0, l_v50_0 = v45, v50;
                        task.spawn(function() --[[ Line: 173 ]]
                            -- upvalues: l_Humanoid_4 (copy), v42 (copy), v2 (ref), v46 (copy), l_v50_0 (ref)
                            local v53 = l_Humanoid_4.Health <= l_Humanoid_4.MaxHealth / 2 and "Injured" or "";
                            local v54 = {
                                Run = true, 
                                Idle = true
                            };
                            for v55, _ in pairs(v54) do
                                local v57 = v42.Config.Animations[("%*%*"):format(v53, v55)] or v42.Config.Animations[v55];
                                v54[v55] = v2:LoadAnimationFromID(v46, v57);
                                v54[v55].Looped = true;
                            end;
                            l_Humanoid_4.Running:Connect(function(v58) --[[ Line: 182 ]]
                                -- upvalues: l_v50_0 (ref), v54 (copy)
                                if v58 <= 0.05 and l_v50_0 then
                                    l_v50_0 = false;
                                    v54.Run:Stop(0.01);
                                    v54.Idle:Play(0.01);
                                    return;
                                else
                                    if v58 > 0.05 and not l_v50_0 then
                                        l_v50_0 = true;
                                        v54.Run:Play(0.01);
                                        v54.Idle:Stop(0.01);
                                    end;
                                    return;
                                end;
                            end);
                        end);
                        task.spawn(function() --[[ Line: 196 ]]
                            -- upvalues: v41 (ref), v42 (copy), v2 (ref), v46 (copy), v17 (ref), l_Humanoid_4 (copy), l_v50_0 (ref), v1 (ref)
                            local v59 = v41[v42.PathfindType] or v41[1];
                            local l_v2_ClosestPlayerFromPosition_0 = v2:GetClosestPlayerFromPosition(v42:GetPivot().Position, {
                                MaxDistance = 100, 
                                PlayerSelection = "Killers", 
                                OverrideUndetectable = true
                            });
                            local v61 = l_v2_ClosestPlayerFromPosition_0 and game.Players:GetPlayerFromCharacter(l_v2_ClosestPlayerFromPosition_0);
                            for _, v63 in ipairs(v46:GetDescendants()) do
                                if v63:IsA("BasePart") and v63:CanSetNetworkOwnership() then
                                    v63:SetNetworkOwner(v61);
                                end;
                            end;
                            local v64 = v17(v42);
                            if v59.SpawnRequired and not v64 then
                                v59 = v41[1];
                            end;
                            if v59 then
                                v59.Callback(v42, v46, v64);
                            end;
                            task.spawn(function() --[[ Line: 218 ]]
                                -- upvalues: v46 (ref), l_Humanoid_4 (ref), l_v50_0 (ref), v1 (ref)
                                local v65 = 0;
                                local v66 = 0;
                                while v46.Parent and v46.PrimaryPart and l_Humanoid_4.Health > 0 do
                                    if v65 >= 0.35 and l_v50_0 then
                                        local v67 = ("footstep%*"):format(require(game.ServerScriptService.Server.Miscellaneous.Replication.FootstepReplication).FootstepRenaming[l_Humanoid_4.FloorMaterial] or "Cement");
                                        if v46.PrimaryPart and v46.PrimaryPart.Parent then
                                            v1:Play(v67, {
                                                Parent = v46.PrimaryPart, 
                                                PlaybackSpeed = Random.new():NextNumber(0.9, 1.1), 
                                                Volume = 0.25
                                            });
                                        end;
                                        v66 = v66 + 1;
                                        v65 = 0;
                                    end;
                                    v65 = v65 + task.wait();
                                end;
                            end);
                        end);
                        v2:FixCharacter(v46, "Survivors");
                        v2:RevealPlayerAuraTo(v42.Player, v46, lifetime - 0.2, Color3.new(1, 1, 1));
                        task.delay(lifetime, function() --[[ Line: 260 ]]
                            -- upvalues: l_v45_0 (ref), l_Humanoid_4 (copy)
                            l_v45_0 = false;
                            l_Humanoid_4.Health = 0;
                        end);
                        local l_Health_0 = l_Humanoid_4.Health;
                        l_Humanoid_4.HealthChanged:Connect(function(v69) --[[ Line: 267 ]]
                            -- upvalues: v24 (ref), v42 (copy), v46 (copy), l_Health_0 (ref), l_v45_0 (ref)
                            v24(v42, v46);
                            if v69 < l_Health_0 - 10 and l_v45_0 then
                                require(game.ReplicatedStorage.Modules.Actors):IncrementActorStats(v42.Player, {
                                    Action = "Tricked the Killer", 
                                    RewardType = "Survivalist"
                                });
                            end;
                            l_Health_0 = v69;
                        end);
                        l_Humanoid_4.Died:Once(function() --[[ Line: 282 ]]
                            -- upvalues: l_v45_0 (ref), v4 (ref), v42 (copy), v49 (copy)
                            if l_v45_0 then
                                v4:IncrementAchievementProgress(v42.Player, "007n7Clone");
                            end;
                            v49:Disconnect();
                        end);
                        if v44 ~= v42.Config.CloneAmount then
                            task.wait();
                        end;
                    end;
                end;
                v5:ApplyStatus(v42.Rig, "Invisibility", {
                    Level = v42.Config.InvisibilityLevel or 4, 
                    Duration = v42.Config.InvisibilityTime
                });
                v5:ApplyStatus(v42.Rig, "Undetectable", {
                    Level = 1, 
                    Duration = v42.Config.InvisibilityTime
                });
                task.delay(v42.Config.CloneAbilitiesDisabledTime, function() --[[ Line: 300 ]]
                    -- upvalues: v42 (copy)
                    v42.AbilitiesDisabled = false;
                end);
                return;
            else
                if game["Run Service"]:IsClient() then

                end;
                return;
            end;
        end
    }, 
    c00lgui = {
        LayoutOrder = 2, 
        KeybindType = "AltAbility2", 
        Icon = "rbxassetid://89910721511648", 
        Callback = function(v70, _) --[[ Line: 314 ]] --[[ Name: Callback ]]
            -- upvalues: v1 (copy), v17 (copy), v2 (copy), v4 (copy)
            if game["Run Service"]:IsServer() then
                v70.AbilitiesDisabled = true;
                v70:ChangeExpression("Concentrating");
                local v72 = v70.Config.c00lguiTemplate:Clone();
                local v73 = v72:FindFirstChild("Label", true) or {
                    Text = "idk"
                };
                v72.CFrame = CFrame.lookAt((v70.Rig.PrimaryPart.CFrame * CFrame.new(0, 0, -2.125)).Position, v70.Rig.PrimaryPart.Position + Vector3.new(0, 1.125, 0, 0));
                v73.Text = "click 2 h4x!!1!";
                local l_WeldConstraint_0 = Instance.new("WeldConstraint");
                l_WeldConstraint_0.Parent = v72;
                l_WeldConstraint_0.Part1 = v72;
                l_WeldConstraint_0.Part0 = v70.Rig.PrimaryPart;
                local l_Size_0 = v72.Size;
                v72.Anchored = false;
                v72.CanCollide = false;
                v72.Massless = true;
                v72.Size = Vector3.new();
                v72.Parent = v70.Rig;
                if v70.Behavior.ToggleGUI then
                    v70.Behavior:ToggleGUI(v72, true);
                else
                    game.TweenService:Create(v72, TweenInfo.new(1.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
                        Size = l_Size_0
                    }):Play();
                end;
                local v76 = v1:Play(v70.Config.Sounds.c00lguiActivated, {
                    Parent = v70.Rig.PrimaryPart
                });
                local v77 = nil;
                local l_Health_1 = v70.Rig.Humanoid.Health;
                local v79 = nil;
                v79 = v70.Rig.Humanoid.HealthChanged:Connect(function(v80) --[[ Line: 354 ]]
                    -- upvalues: l_Health_1 (ref), v77 (ref)
                    if v80 < l_Health_1 then
                        v77 = "failed";
                    end;
                    l_Health_1 = v80;
                end);
                local v81 = nil;
                v81 = v70.Rig.PrimaryPart:GetPropertyChangedSignal("Anchored"):Connect(function() --[[ Line: 362 ]]
                    -- upvalues: v77 (ref)
                    v77 = "failed";
                end);
                local v82 = nil;
                local l_SpeedMultipliers_0 = v70.Rig:FindFirstChild("SpeedMultipliers");
                if l_SpeedMultipliers_0 then
                    v82 = l_SpeedMultipliers_0.ChildAdded:Connect(function(v84) --[[ Line: 370 ]]
                        -- upvalues: v77 (ref)
                        if v84.Value <= 0 and v84.Name ~= "Emoting" then
                            v77 = "failed";
                        end;
                    end);
                end;
                local v85 = v70 and v70.Rig;
                if v85 then
                    v85:SetAttribute("AnimationsDisabled", true);
                    v85:SetAttribute("AnimationsExtraDisabled", true);
                    v85:SetAttribute("UsingItemsDisabled", true);
                end;
                task.delay(2.3, function() --[[ Line: 384 ]]
                    -- upvalues: v77 (ref), v73 (copy)
                    if not v77 then
                        v73.Text = "h4xxing in pr0gr3ss...!!1!";
                    end;
                end);
                task.delay(v70.Config.c00lguiWindupTime, function() --[[ Line: 391 ]]
                    -- upvalues: v77 (ref)
                    if not v77 then
                        v77 = "teleported";
                    end;
                end);
                task.spawn(function() --[[ Line: 398 ]]
                    -- upvalues: v77 (ref), v70 (copy), v73 (copy), v76 (copy), v72 (copy), v17 (ref), v2 (ref), v4 (ref), v79 (ref), v81 (ref), v82 (ref)
                    repeat
                        task.wait();
                    until v77;
                    v70:ChangeExpression("Default");
                    local v86 = v70 and v70.Rig;
                    if v86 then
                        v86:SetAttribute("AnimationsDisabled", nil);
                        v86:SetAttribute("AnimationsExtraDisabled", nil);
                        v86:SetAttribute("UsingItemsDisabled", nil);
                    end;
                    task.spawn(function() --[[ Line: 411 ]]
                        -- upvalues: v77 (ref), v73 (ref), v76 (ref), v70 (ref), v72 (ref)
                        if v77 == "teleported" then
                            v73.Text = "H4XX3D!!1!1";
                        else
                            v73.Text = "o noes D:";
                            if v76 then
                                game.Debris:AddItem(v76, 1);
                                game.TweenService:Create(v76, TweenInfo.new(1), {
                                    PlaybackSpeed = 0
                                }):Play();
                            end;
                        end;
                        task.wait(1);
                        if v70.Behavior.ToggleGUI then
                            v70.Behavior:ToggleGUI(v72, false);
                            return;
                        else
                            game.Debris:AddItem(v72, 0.2);
                            game.TweenService:Create(v72, TweenInfo.new(0.2), {
                                Size = Vector3.new()
                            }):Play();
                            return;
                        end;
                    end);
                    if v77 == "teleported" and v70 and v70.Rig and v70.Rig.Parent then
                        local v87 = v17(v70);
                        if v87 then
                            local v88 = CFrame.new(v87.Position + Vector3.new(0, 2, 0, 0)) * v70.Rig.PrimaryPart.CFrame.Rotation;
                            for _, v90 in ipairs(workspace.Players.Killers:GetChildren()) do
                                if v2:IsAlive(v90) then
                                    local l_Magnitude_1 = (v90.PrimaryPart.Position - v88.Position).Magnitude;
                                    if (v90.PrimaryPart.Position - v70.Rig.PrimaryPart.Position).Magnitude < 12 then
                                        v4:IncrementAchievementProgress(v70.Player, "007n7Close");
                                    end;
                                    if l_Magnitude_1 < 8 then
                                        v4:IncrementAchievementProgress(v70.Player, "007n7Oops");
                                    end;
                                end;
                            end;
                            local completedFrom=v70.Rig.PrimaryPart.Position;
                            v70:PivotTo(v88);
                            GameplayPolish.TeleportReward(v70,completedFrom);
                        end;
                    end;
                    v79:Disconnect();
                    v79 = nil;
                    v81:Disconnect();
                    v81 = nil;
                    v82:Disconnect();
                    v82 = nil;
                    local l_StringValue_0 = Instance.new("StringValue");
                    l_StringValue_0.Value = tostring(v77);
                    l_StringValue_0.Name = "Result";
                    l_StringValue_0.Parent = v70.Rig;
                    game.Debris:AddItem(l_StringValue_0, 2);
                    task.delay(2, function() --[[ Line: 472 ]]
                        -- upvalues: v70 (ref)
                        v70.AbilitiesDisabled = false;
                    end);
                end);
                return;
            else
                if game["Run Service"]:IsClient() then
                    if v70.Animations.c00lguiStart then
                        v70.Animations.c00lguiStart:Play();
                    end;
                    if v70.Animations.c00lguiLoop then
                        v70.Animations.c00lguiLoop:Play();
                    end;
                    local v93 = require(game.ReplicatedStorage.Modules.Network);
                    v93:FireConnection("DisableSprinting", "c00lgui", true);
                    local l_v2_SpeedMultiplier_0 = v2:CreateSpeedMultiplier(v70.Rig, 0.1, "c00lgui");
                    local l_v2_ProgressBar_0 = v2:CreateProgressBar("Using c00lgui", v70.Config.c00lguiWindupTime);
                    local v96 = os.clock();
                    repeat
                        task.wait();
                    until v70.Rig:FindFirstChild("Result") or os.clock() >= v96 + v70.Config.c00lguiWindupTime + 1;
                    if v70.Animations.c00lguiStart then
                        v70.Animations.c00lguiStart:Stop();
                    end;
                    if v70.Animations.c00lguiLoop then
                        v70.Animations.c00lguiLoop:Stop();
                    end;
                    if v70.Animations.c00lguiEnd then
                        v70.Animations.c00lguiEnd:Play(0);
                    end;
                    v93:FireConnection("DisableSprinting", "c00lgui", false);
                    l_v2_SpeedMultiplier_0:Destroy();
                    l_v2_ProgressBar_0:Destroy();
                end;
                return;
            end;
        end
    }, 
    Inject = {
        LayoutOrder = 3, 
        KeybindType = "AltAbility3", 
        Icon = "rbxassetid://79352712393168", 
        pathfindIcon = "rbxassetid://106052937163461", 
        cursorIcon = "rbxassetid://124419040716623", 
        aimlessIcon = "rbxassetid://79352712393168", 
        FlavorText = "[Aimless]", 
        Callback = function(v97, v98) --[[ Line: 518 ]] --[[ Name: Callback ]]
            -- upvalues: v41 (copy)
            if game["Run Service"]:IsServer() then
                v97.PathfindType = v97.PathfindType % #v41 + 1;
                return v97.PathfindType;
            else
                if game["Run Service"]:IsClient() then
                    local v99 = v41[v98];
                    if v99 then
                        local l_InjectUI_0 = v97.Player.PlayerGui.TemporaryUI:FindFirstChild("InjectUI");
                        if l_InjectUI_0 then
                            l_InjectUI_0:Destroy();
                        end;
                        local v101 = v97.Config.InjectTemplate:Clone();
                        v101.Label.Text = ("clone movement type: %*"):format((tostring(v99.Type)));
                        v101.Name = "InjectUI";
                        v101.Parent = v97.Player.PlayerGui.TemporaryUI;
                        game.Debris:AddItem(v101, 2);
                        game.TweenService:Create(v101, TweenInfo.new(2, Enum.EasingStyle.Exponential, Enum.EasingDirection.In), {
                            BackgroundTransparency = 1
                        }):Play();
                        game.TweenService:Create(v101.Label, TweenInfo.new(2, Enum.EasingStyle.Exponential, Enum.EasingDirection.In), {
                            TextTransparency = 1
                        }):Play();
                        game.TweenService:Create(v101.UIStroke, TweenInfo.new(2, Enum.EasingStyle.Exponential, Enum.EasingDirection.In), {
                            Transparency = 1
                        }):Play();
                        local l_Inject_0 = v97.Behavior.Abilities.Inject;
                        l_Inject_0.Icon = l_Inject_0[("%*Icon"):format(v99.Type)] or l_Inject_0.Icon;
                        v97.Behavior.Abilities.Inject.FlavorText = ("[%*]"):format((v99.Type:gsub("^%l", string.upper)));
                    end;
                end;
                return;
            end;
        end
    }
};
v0.Created = function(_, v104) --[[ Line: 549 ]] --[[ Name: Created ]]
    -- upvalues: v17 (copy)
    if game["Run Service"]:IsServer() then
        v104.PathfindType = 1;
        return;
    else
        if game["Run Service"]:IsClient() and v104.Player == game.Players.LocalPlayer then
            task.spawn(function() --[[ Line: 554 ]]
                -- upvalues: v104 (copy), v17 (ref)
                local v105 = v104.Config.DexTemplate:Clone();
                v105.Parent = v104.Player.PlayerGui:FindFirstChild("TemporaryUI");
                v104.Rig.Humanoid.HealthChanged:Connect(function(v106) --[[ Line: 560 ]]
                    -- upvalues: v105 (copy)
                    if v106 <= 0 then
                        v105:Destroy();
                    end;
                end);
                v104.Rig.AncestryChanged:Connect(function(_, v108) --[[ Line: 561 ]]
                    -- upvalues: v105 (copy)
                    if not v108 then
                        v105:Destroy();
                    end;
                end);
                while task.wait(0.1) and v104.Rig.Parent do
                    local v109 = v17(v104);
                    if v109 and v105.Adornee ~= v109 then
                        v105.Adornee = v109;
                    end;
                end;
            end);
        end;
        return;
    end;
end;
return v0;