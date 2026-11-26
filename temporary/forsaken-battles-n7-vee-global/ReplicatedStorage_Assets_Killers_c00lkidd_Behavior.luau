-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local _ = require(game.ReplicatedStorage.GlobalTypes);
local v1 = {};
local v2 = require(game.ReplicatedStorage.Modules.Sounds);
local v3 = require(game.ReplicatedStorage.Modules.Util);
local v4 = require(game.ReplicatedStorage.Modules.Hitboxes);
local v5 = require(game.ReplicatedStorage.Modules.Statuses);
local l_RunService_0 = game:GetService("RunService");
local v7 = require(game.ReplicatedStorage.Modules.Schematics.Lighting);
local v8 = require(game.ReplicatedStorage.Modules.Projectiles);
local v9 = require(game.ReplicatedStorage.Modules.AchievementUtil);
local function _(v10, v11, v12) --[[ Line: 15 ]] --[[ Name: pcallMethod ]]
    local l_status_0, l_result_0 = pcall(function() --[[ Line: 16 ]]
        -- upvalues: v12 (copy), v10 (copy)
        if v12.Behavior[v10] then
            v12.Behavior[v10](v12);
        end;
    end);
    if not l_status_0 then
        warn((("[%*]: Failed to call .%*() due to: %*"):format(v11, v10, l_result_0)));
    end;
end;
v1.Abilities = {
    Punch = {
        LayoutOrder = 1,
        Icon = "rbxassetid://93874368032471",
        KeybindType = "MainAbility",
        Cooldown = 2,
        Callback = function(v16) --[[ Line: 42 ]] --[[ Name: Callback ]]
            -- upvalues: v2 (copy), v4 (copy), v3 (copy)
            if game["Run Service"]:IsServer() then
                v16.AbilitiesDisabled = true;
                v2:Play(v16.Config.Sounds.Swing, {
                    Parent = v16.Rig.PrimaryPart,
                    PlaybackSpeed = Random.new():NextNumber(0.975, 1.025),
                    Volume = 0.25
                });
                task.delay(v16.Config.PunchWindup, function() --[[ Line: 49 ]]
                    -- upvalues: v4 (ref), v16 (copy), v3 (ref), v2 (ref)
                    local _ = v4:CreateHitbox(v16.Player, { AbilityType = "MainAbility", IsProjectile = false,
                        Size = Vector3.new(4.5, 6, 5, 0),
                        CFrameOffset = CFrame.new(0, 0, -2),
                        Damage = v16.Config.AttackDamage,
                        Time = v16.Config.PunchLinger,
                        Knockback = 2,
                        HitMultiple = false,
                        ExecuteOnKill = true,
                        Connections = {
                            Hit = function(v17) --[[ Line: 61 ]] --[[ Name: Hit ]]
                                -- upvalues: v3 (ref), v2 (ref), v16 (ref)
                                v3:CreateSpeedMultiplier(v17, 1.5, "HitSpeedBonus", 1.25);
                                v2:Play(v16.Config.Sounds.Hit, {
                                    Parent = v16.Rig.PrimaryPart,
                                    PlaybackSpeed = Random.new():NextNumber(0.975, 1.025),
                                    Volume = 0.25
                                });
                            end
                        }
                    });
                end);
                task.delay(0.75, function() --[[ Line: 70 ]]
                    -- upvalues: v16 (copy)
                    v16.AbilitiesDisabled = false;
                end);
                return;
            else
                if game["Run Service"]:IsClient() then
                    v16.Animations.Attack:Play(0.025);
                end;
                return;
            end;
        end
    },
    CorruptNature = {
        LayoutOrder = 2,
        Icon = "rbxassetid://81200466982776",
        KeybindType = "AltAbility1",
        Cooldown = 13,
        Callback = function(v19) --[[ Line: 87 ]] --[[ Name: Callback ]]
            -- upvalues: v2 (copy), v3 (copy), v5 (copy), v8 (copy)
            if game["Run Service"]:IsServer() then
                v19.AbilitiesDisabled = true;
                v2:Play(v19.Config.Sounds.CorruptThrow, {
                    Parent = v19.Rig.PrimaryPart
                });
                local v20 = ("%*/CNStart"):format(script.Parent);
                local l_pcall_0 = pcall;
                local v22 = "CNStart";
                local v23;
                l_pcall_0, v23 = l_pcall_0(function() --[[ Line: 16 ]]
                    -- upvalues: v19 (copy), v22 (copy)
                    if v19.Behavior[v22] then
                        v19.Behavior[v22](v19);
                    end;
                end);
                if not l_pcall_0 then
                    warn((("[%*]: Failed to call .CNStart() due to: %*"):format(v20, v23)));
                end;
                v20 = v3:CreateSpeedMultiplier(v19.Player, 0.01, "HinderedMovement");
                task.delay(0.4, function() --[[ Line: 95 ]]
                    -- upvalues: v20 (copy)
                    game.TweenService:Create(v20, TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.In), {
                        Value = 1
                    }):Play();
                    game.Debris:AddItem(v20, 0.5);
                end);
                task.delay(0.1, function() --[[ Line: 101 ]]
                    -- upvalues: v19 (copy), v3 (ref), v2 (ref), v5 (ref), v8 (ref)
                    local l_Position_0 = (v19.Rig.PrimaryPart.CFrame * CFrame.new(0, 0, -20)).Position;
                    l_Position_0 = v3:GetPlayerMousePosition(v19.Player);
                    local v25 = CFrame.lookAt(v19.Rig.PrimaryPart.Position, l_Position_0) * CFrame.new(0, 0, -500);
                    local l_PrimaryPart_0 = v19.Rig.PrimaryPart;
                    local v27 = v19.Config.Projectile and v19.Config.Projectile:Clone() or Instance.new("Part");
                    v27.Name = "HumanoidRootProjectile";
                    v27.Anchored = true;
                    v27.CanCollide = false;
                    v27.CanQuery = false;
                    v27.CanTouch = false;
                    if not v19.Config.NoProjectileResize then
                        v27.Size = Vector3.new(1, 2, 2, 0);
                    end;
                    local v28 = l_PrimaryPart_0.CFrame + Vector3.new(0, (v19.Rig.Humanoid.HipHeight + l_PrimaryPart_0.Size.Y / 2) / 2, 0);
                    local v29 = (v25.Position - v28.Position) / 10;
                    v2:Play(v19.Config.Sounds.CorruptAmbience, {
                        Parent = v27,
                        Looped = true
                    });
                    local v30 = 0;
                    local v32 = {
                        Size = Vector3.new(3, 3, 3, 0),
                        Damage = v19.Config.RootPartDamage,
                        Time = 10,
                        Knockback = 0.5,
                        HitMultiple = true,
                        PredictVelocity = false,
                        Connections = {
                            Hit = function(v31) --[[ Line: 139 ]] --[[ Name: Hit ]]
                                -- upvalues: v30 (ref), v19 (ref), v3 (ref), v5 (ref), v2 (ref)
                                v30 = v30 + 1;
                                if v30 >= 2 then
                                    require(game.ReplicatedStorage.Modules.AchievementUtil):IncrementAchievementProgress(v19.Player, "c00lkiddProjectile");
                                end;
                                v3:RevealPlayerAuraTo(v19.Player, v31, 10);
                                v5:ApplyStatus(v31, "Slowness", {
                                    Level = 1,
                                    Duration = 4
                                });
                                v2:Play(v19.Config.Sounds.CorruptHit, {
                                    Parent = v31.PrimaryPart,
                                    PlaybackSpeed = Random.new():NextNumber(0.975, 1.025),
                                    Volume = 0.4
                                });
                                if tostring(v31.Parent) == "Survivors" then
                                    require(game.ReplicatedStorage.Modules.Actors):IncrementActorStats(v19.Player, {
                                        Action = "Landed Corrupt Nature hit",
                                        RewardType = "RegularKillerAction"
                                    });
                                end;
                            end
                        }
                    };
                    local v33 = vector.create(math.random(-360, 360), math.random(-360, 360), math.random(-360, 360));
                    local v34 = {
                        Owner = v19.Player,
                        HitboxConfig = v32,
                        Lifetime = 10,
                        InitialCFrame = v28,
                        InitialVelocity = v29,
                        Model = v27,
                        ClientCallbackData = v19.Config.NoProjectileJitter and {} or {
                            OnHeartbeat = {
                                Rotation = {
                                    rotation = v33
                                }
                            }
                        }
                    };
                    v8.new(v34):Launch();
                end);
                task.delay(1.2, function() --[[ Line: 186 ]]
                    -- upvalues: v19 (copy)
                    v19.AbilitiesDisabled = false;
                end);
                return;
            else
                if game["Run Service"]:IsClient() then
                    v19.Animations.CorruptNature:Play(0.025);
                end;
                return;
            end;
        end
    },
    WalkspeedOverride = {
        LayoutOrder = 3,
        Icon = "rbxassetid://101955457812737",
        KeybindType = "AltAbility2",
        Cooldown = 20,
        Callback = function(v35) --[[ Line: 203 ]] --[[ Name: Callback ]]
            -- upvalues: v3 (copy), v2 (copy), v4 (copy), v5 (copy)
            local l_WalkspeedOverrideDuration_0 = v35.Config.WalkspeedOverrideDuration;
            local l_WalkspeedOverrideEndlag_0 = v35.Config.WalkspeedOverrideEndlag;
            if game["Run Service"]:IsServer() then
                v35.AbilitiesDisabled = true;
                v3:SetSpeedCap(v35.Rig, "C00lkiddWalkspeedOverride", v35.Config.WalkspeedOverrideSpeed);
                local l_TweenService_0 = game:GetService("TweenService");
                local v39 = v35.Config.c00lguiTemplate:Clone();
                local l_JointInstance_0 = v39:FindFirstChildWhichIsA("JointInstance");
                if l_JointInstance_0 and v39:IsA("BasePart") then
                    local l_Size_0 = v39.Size;
                    local v42 = l_TweenService_0:Create(v39, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Size = l_Size_0
                    });
                    local v43 = l_TweenService_0:Create(v39, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                        Size = Vector3.new(0, 0, 0, 0)
                    });
                    v39.Parent = v35.Rig;
                    v39.Anchored = false;
                    v39.Size = Vector3.new(0, 0, 0, 0);
                    l_JointInstance_0.Part0 = v35.Rig.PrimaryPart;
                    v42:Play();
                    task.delay(0.25, v43.Play, v43);
                end;
                game.Debris:AddItem(v39, 1);
                local v44 = ("%*/WalkspeedStart"):format(script.Parent);
                local l_pcall_1 = pcall;
                local v46 = "WalkspeedStart";
                local v47;
                l_pcall_1, v47 = l_pcall_1(function() --[[ Line: 16 ]]
                    -- upvalues: v35 (copy), v46 (copy)
                    if v35.Behavior[v46] then
                        v35.Behavior[v46](v35);
                    end;
                end);
                if not l_pcall_1 then
                    warn((("[%*]: Failed to call .WalkspeedStart() due to: %*"):format(v44, v47)));
                end;
                task.delay(v35.Config.WalkspeedOverrideWindup, function() --[[ Line: 234 ]]
                    -- upvalues: v2 (ref), v35 (copy), v4 (ref), l_WalkspeedOverrideDuration_0 (copy), v3 (ref), v5 (ref), l_WalkspeedOverrideEndlag_0 (copy)
                    local v48 = v2:Play(v35.Config.Sounds.WalkspeedOverrideLoop, {
                        Parent = v35.Rig.PrimaryPart,
                        Looped = true
                    });
                    local v49 = nil;
                    local v50 = nil;
                    local l_v4_Hitbox_1 = v4:CreateHitbox(v35.Player, {
                        Size = Vector3.new(7, 5, 6, 0),
                        Damage = v35.Config.WalkspeedOverrideDamage,
                        CFrameOffset = CFrame.new(0, 0, -1.5),
                        Time = l_WalkspeedOverrideDuration_0,
                        Knockback = v35.Config.WalkspeedOverrideKnockback,
                        HitMultiple = true,
                        Connections = {
                            Hit = function(v51) --[[ Line: 247 ]] --[[ Name: Hit ]]
                                -- upvalues: v3 (ref), v49 (ref), v5 (ref), v35 (ref)
                                local _, v53 = v3:GetEntityType(v51);
                                if v53 == "Entity" then
                                    return;
                                else
                                    v49 = v51;
                                    v5:ApplyStatus(v51, "Burning", {
                                        Level = 1,
                                        Duration = 8
                                    });
                                    v5:ApplyStatus(v51, "Slowness", {
                                        Level = 10,
                                        Duration = 0.25,
                                        Hidden = true
                                    });
                                    v3:RevealPlayerAuraTo(v35.Player, v51, 9);
                                    local l_firebrand_0 = v35.Rig:FindFirstChild("firebrand");
                                    if l_firebrand_0 then
                                        l_firebrand_0.Transparency = 0;
                                        task.delay(1.5, function() --[[ Line: 263 ]]
                                            -- upvalues: l_firebrand_0 (copy)
                                            game.TweenService:Create(l_firebrand_0, TweenInfo.new(0.5), {
                                                Transparency = 1
                                            }):Play();
                                        end);
                                    end;
                                    local v55 = ("%*/Start"):format(script.Parent);
                                    local l_v35_0 = v35;
                                    local l_pcall_2 = pcall;
                                    local v58 = "WalkspeedHit";
                                    local v59;
                                    l_pcall_2, v59 = l_pcall_2(function() --[[ Line: 16 ]]
                                        -- upvalues: l_v35_0 (copy), v58 (copy)
                                        if l_v35_0.Behavior[v58] then
                                            l_v35_0.Behavior[v58](l_v35_0);
                                        end;
                                    end);
                                    if not l_pcall_2 then
                                        warn((("[%*]: Failed to call .WalkspeedHit() due to: %*"):format(v55, v59)));
                                    end;
                                    if tostring(v51.Parent) == "Survivors" then
                                        v55 = require(game.ReplicatedStorage.Modules.Actors);
                                        if v51.Humanoid.Health <= 0 then
                                            v55:IncrementActorStats(v35.Player, {
                                                Action = "Killed a Survivor with Walkspeed Override",
                                                RewardType = "DifficultKillerAction"
                                            });
                                            return;
                                        else
                                            v55:IncrementActorStats(v35.Player, {
                                                Action = "Landed Walkspeed Override hit",
                                                RewardType = "RegularKillerAction"
                                            });
                                        end;
                                    end;
                                    return;
                                end;
                            end,
                            Ended = function() --[[ Line: 283 ]] --[[ Name: Ended ]]
                                -- upvalues: v48 (copy), v50 (ref)
                                game.TweenService:Create(v48, TweenInfo.new(0.5), {
                                    PlaybackSpeed = 0
                                });
                                game.Debris:AddItem(v48, 1);
                                v50 = true;
                            end
                        }
                    });
                    local v61 = require(game.ReplicatedStorage.Modules.Network);
                    local l_LookVector_0 = v35:GetPivot().LookVector;
                    local v63 = v3:ApplyVelocity(v35.Rig.PrimaryPart, v35.Config.WalkspeedOverrideSpeed);
                    v63.LineDirection = (l_LookVector_0 * Vector3.new(1, 0, 1, 0)).Unit;
                    game.Debris:AddItem(v63, l_WalkspeedOverrideDuration_0 + 3);
                    game.TweenService:Create(v63, TweenInfo.new(l_WalkspeedOverrideDuration_0 * 1.5), {
                        LineVelocity = v35.Config.WalkspeedOverrideSpeed / 2
                    }):Play();
                    v2:Play(v35.Config.Sounds.WalkspeedOverrideLunge, {
                        Parent = v35.Rig.PrimaryPart
                    });
                    local v64 = false;
                    local v65 = ("%*C00lkiddCollision"):format(v35.Player.Name);
                    v61:SetConnection(v65, "REMOTE_EVENT", function(v66) --[[ Line: 307 ]]
                        -- upvalues: v35 (ref), v64 (ref)
                        if v66 ~= v35.Player then
                            v66:Kick("not slick at all");
                            return;
                        else
                            v64 = true;
                            return;
                        end;
                    end);
                    repeat
                        task.wait();
                    until v49 or v50 or v64;
                    local v67 = "IDK";
                    if v49 then
                        v67 = "Hit";
                        v3:GiveInvincible(v35.Rig, "Walkspeed");
                    elseif v64 then
                        v67 = "Collide";
                    elseif v50 then
                        v67 = "Timeout";
                    end;
                    local v68 = (v67 == "Hit" and 1 or v35.Config.WalkspeedOverrideEndlagMultiplier) * l_WalkspeedOverrideEndlag_0;
                    local l_StringValue_0 = Instance.new("StringValue");
                    l_StringValue_0.Name = "Result";
                    l_StringValue_0.Value = v67;
                    l_StringValue_0.Parent = v35.Rig;
                    game.Debris:AddItem(l_StringValue_0, v68);
                    task.delay(v68, function() --[[ Line: 340 ]]
                        -- upvalues: v35 (ref), v67 (ref), v3 (ref)
                        v35.AbilitiesDisabled = false;
                        if v67 == "Hit" then
                            task.delay(1.5, function() --[[ Line: 343 ]]
                                -- upvalues: v3 (ref), v35 (ref)
                                v3:RemoveInvincible(v35.Rig, "Walkspeed");
                            end);
                        end;
                    end);
                    game.TweenService:Create(v63, TweenInfo.new(v67 == "Collide" and 0.25 or 0.5), {
                        LineVelocity = 0
                    }):Play();
                    game.Debris:AddItem(v63, v68);
                    v2:PlayVoiceline(v35, ("WalkspeedOverride%*"):format(v67), {
                        Priority = 1.5
                    });
                    v2:Play(v35.Config.Sounds[("WalkspeedOverride%*"):format(v67)], {
                        Parent = v35.Rig.PrimaryPart
                    });
                    v3:SetSpeedCap(v35.Rig, "C00lkiddWalkspeedOverride", nil);
                    v61:RemoveConnection(v65, "REMOTE_EVENT");
                    l_v4_Hitbox_1:Cancel();
                end);
                return;
            else
                if game["Run Service"]:IsClient() then
                    local v70 = nil;
                    v35.Animations.WalkspeedOverrideStart:Play();
                    do
                        local l_v70_0 = v70;
                        task.delay(v35.Config.WalkspeedOverrideWindup, function() --[[ Line: 364 ]]
                            -- upvalues: l_v70_0 (ref), v35 (copy)
                            if l_v70_0 then
                                return;
                            else
                                v35.Animations.WalkspeedOverrideLoop.Looped = true;
                                v35.Animations.WalkspeedOverrideLoop:Play();
                                return;
                            end;
                        end);
                        v35.Rig:SetAttribute("FootstepsMuted", true);
                        local l_v3_SpeedMultiplier_0 = v3:CreateSpeedMultiplier(v35.Player, 0, "HinderedMovement");
                        task.spawn(function() --[[ Line: 379 ]]
                            -- upvalues: v35 (copy), l_v70_0 (ref)
                            v35.Rig.PrimaryPart:WaitForChild("LinearVelocity", 2);
                            local v73 = 0;
                            local v74 = false;
                            while true do
                                if not l_v70_0 and v35.Rig.PrimaryPart then
                                    if v73 >= 0.2 and v35.Rig.PrimaryPart.AssemblyLinearVelocity.Magnitude <= v35.Config.WalkspeedOverrideSpeed / 3 then
                                        if not v74 then
                                            require(game.ReplicatedStorage.Modules.Network):FireServerConnection(("%*C00lkiddCollision"):format(v35.Player.Name), "REMOTE_EVENT");
                                            v74 = true;
                                        end;
                                        return;
                                    else
                                        v73 = v73 + game["Run Service"].Heartbeat:Wait();
                                    end;
                                else
                                    return;
                                end;
                            end;
                        end);
                        local v75 = v35.Rig:WaitForChild("Result", 6);
                        l_v70_0 = v75 and v75.Value or "IDK BRUH";
                        v35.Rig:SetAttribute("FootstepsMuted", nil);
                        v35.Animations.WalkspeedOverrideStart:Stop();
                        v35.Animations.WalkspeedOverrideLoop:Stop();
                        if l_v70_0 == "Hit" then
                            v35.Animations.WalkspeedOverrideHit:Play(0);
                        elseif not v35.Animations.WalkspeedOverrideDuration and not v35.Animations.WalkspeedOverrideCollide then
                            v35.Animations.WalkspeedOverrideMiss:Play(0.05);
                        elseif l_v70_0 == "Timeout" and v35.Animations.WalkspeedOverrideDuration then
                            v35.Animations.WalkspeedOverrideDuration:Play(0.05);
                        elseif l_v70_0 == "Collide" and v35.Animations.WalkspeedOverrideCollide then
                            v35.Animations.WalkspeedOverrideCollide:Play(0.05);
                        end;
                        if v75 then
                            repeat
                                task.wait();
                            until not v75.Parent;
                        end;
                        game.TweenService:Create(l_v3_SpeedMultiplier_0, TweenInfo.new(0.5), {
                            Value = 1
                        }):Play();
                        game.Debris:AddItem(l_v3_SpeedMultiplier_0, 0.5);
                    end;
                end;
                return;
            end;
        end
    },
    PizzaDelivery = {
        LayoutOrder = 4,
        Icon = "rbxassetid://105652328381208",
        KeybindType = "AltAbility3",
        Cooldown = 50,
        Callback = function(v76) --[[ Line: 438 ]] --[[ Name: Callback ]]
            -- upvalues: v2 (copy), v3 (copy), v9 (copy), v5 (copy)
            if game["Run Service"]:IsServer() then
                v76.AbilitiesDisabled = true;
                v2:Play(v76.Config.Sounds.PizzaDeliveryPunchGround, {
                    Parent = v76.Rig.PrimaryPart
                });
                local v77 = ("%*/Summon"):format(script.Parent);
                local l_pcall_3 = pcall;
                local v79 = "MinionSummon";
                local v80;
                l_pcall_3, v80 = l_pcall_3(function() --[[ Line: 16 ]]
                    -- upvalues: v76 (copy), v79 (copy)
                    if v76.Behavior[v79] then
                        v76.Behavior[v79](v76);
                    end;
                end);
                if not l_pcall_3 then
                    warn((("[%*]: Failed to call .MinionSummon() due to: %*"):format(v77, v80)));
                end;
                task.delay(1, function() --[[ Line: 446 ]]
                    -- upvalues: v76 (copy), v3 (ref), v2 (ref), v9 (ref), v5 (ref)
                    local v81 = "";
                    local function v86(v82, v83) --[[ Line: 449 ]] --[[ Name: __getGroundPosition ]]
                        local v84 = RaycastParams.new();
                        v84.FilterType = Enum.RaycastFilterType.Exclude;
                        v84.FilterDescendantsInstances = v83 or {};
                        v84.RespectCanCollide = true;
                        local v85 = workspace:Raycast(v82.PrimaryPart.Position, Vector3.new(0, -100, 0, 0), v84);
                        return v85 and v85.Position or v82.PrimaryPart.Position;
                    end;
                    for v87 = 1, 2 do
                        local v88 = v76.Rig.PrimaryPart.CFrame * CFrame.new(v87 % 2 == 0 and 6 or -6, 0, 0);
                        local v89 = OverlapParams.new();
                        v89.FilterType = Enum.RaycastFilterType.Exclude;
                        v89.FilterDescendantsInstances = {
                            workspace.Players,
                            v76.Rig
                        };
                        v89.RespectCanCollide = true;
                        if not (#workspace:GetPartBoundsInBox(v88, Vector3.new(2, 5, 2, 0), v89) > 0) then
                            local l_PizzaDeliveryRig_0 = v76.Config.PizzaDeliveryRig;
                            local function _() --[[ Line: 479 ]] --[[ Name: __getRig ]]
                                -- upvalues: l_PizzaDeliveryRig_0 (copy)
                                return l_PizzaDeliveryRig_0:IsA("Folder") and l_PizzaDeliveryRig_0:GetChildren()[math.random(#l_PizzaDeliveryRig_0:GetChildren())] or l_PizzaDeliveryRig_0;
                            end;
                            local v92 = (l_PizzaDeliveryRig_0:IsA("Folder") and l_PizzaDeliveryRig_0:GetChildren()[math.random(#l_PizzaDeliveryRig_0:GetChildren())] or l_PizzaDeliveryRig_0):Clone();
                            if v76.Config.PizzaDeliveryGuyNoRepeats and l_PizzaDeliveryRig_0:IsA("Folder") then
                                local l_l_PizzaDeliveryRig_0_Children_0 = l_PizzaDeliveryRig_0:GetChildren();
                                while v92.Name == v81 do
                                    table.remove(l_l_PizzaDeliveryRig_0_Children_0, table.find(l_l_PizzaDeliveryRig_0_Children_0, v92));
                                    if l_l_PizzaDeliveryRig_0_Children_0[1] then
                                        v92 = (l_PizzaDeliveryRig_0:IsA("Folder") and l_PizzaDeliveryRig_0:GetChildren()[math.random(#l_PizzaDeliveryRig_0:GetChildren())] or l_PizzaDeliveryRig_0):Clone();
                                    else
                                        break;
                                    end;
                                end;
                                v81 = v92.Name;
                            end;
                            v92:SetAttribute("Team", "Killers");
                            v92.PrimaryPart.Anchored = true;
                            v3:FixCharacter(v92, "Killers");
                            v3:AddHitboxes(v92, "Killers");
                            local l_Humanoid_0 = v92.Humanoid;
                            l_Humanoid_0.WalkSpeed = v76.Config.PizzaDeliveryGuySpeed;
                            l_Humanoid_0.MaxHealth = v76.Config.PizzaDeliveryGuyHealth;
                            l_Humanoid_0.Health = v76.Config.PizzaDeliveryGuyHealth;
                            l_Humanoid_0.StateChanged:Connect(function(_, _) --[[ Line: 510 ]]
                                -- upvalues: l_Humanoid_0 (copy)
                                l_Humanoid_0.PlatformStand = false;
                                l_Humanoid_0:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false);
                                l_Humanoid_0:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false);
                                l_Humanoid_0:ChangeState(Enum.HumanoidStateType.GettingUp);
                            end);
                            local v97 = v2:Play(v76.Config.Sounds.PizzaDeliveryMinionIdle, {
                                Parent = v92.PrimaryPart,
                                Looped = true,
                                Volume = 0
                            });
                            game.TweenService:Create(v97, TweenInfo.new(1.75), {
                                RollOffMaxDistance = 115
                            }):Play();
                            local v98 = false;
                            do
                                local l_v92_0, l_v98_0 = v92, v98;
                                local _ = function(v101) --[[ Line: 523 ]] --[[ Name: removeRigAfter ]]
                                    -- upvalues: l_v98_0 (ref), v97 (copy), l_v92_0 (ref)
                                    task.delay(v101 - 1, function() --[[ Line: 524 ]]
                                        -- upvalues: l_v98_0 (ref), v97 (ref), l_v92_0 (ref)
                                        if not l_v98_0 then
                                            l_v98_0 = true;
                                            if v97 and v97.Parent then
                                                game.TweenService:Create(v97, TweenInfo.new(0.8), {
                                                    PlaybackSpeed = 0
                                                }):Play();
                                            end;
                                            game.Debris:AddItem(l_v92_0, 1);
                                            for _, v103 in pairs(l_v92_0:GetDescendants()) do
                                                if v103:IsA("BasePart") or v103:IsA("Decal") then
                                                    game.TweenService:Create(v103, TweenInfo.new(1), {
                                                        Transparency = 1
                                                    }):Play();
                                                end;
                                            end;
                                        end;
                                    end);
                                end;
                                local l_PizzaDeliveryGuyLifetime_0 = v76.Config.PizzaDeliveryGuyLifetime;
                                task.delay(l_PizzaDeliveryGuyLifetime_0 - 1, function() --[[ Line: 524 ]]
                                    -- upvalues: l_v98_0 (ref), v97 (copy), l_v92_0 (ref)
                                    if not l_v98_0 then
                                        l_v98_0 = true;
                                        if v97 and v97.Parent then
                                            game.TweenService:Create(v97, TweenInfo.new(0.8), {
                                                PlaybackSpeed = 0
                                            }):Play();
                                        end;
                                        game.Debris:AddItem(l_v92_0, 1);
                                        for _, v107 in pairs(l_v92_0:GetDescendants()) do
                                            if v107:IsA("BasePart") or v107:IsA("Decal") then
                                                game.TweenService:Create(v107, TweenInfo.new(1), {
                                                    Transparency = 1
                                                }):Play();
                                            end;
                                        end;
                                    end;
                                end);
                                game.Debris:AddItem(l_v92_0, v76.Config.PizzaDeliveryGuyLifetime);
                                l_PizzaDeliveryGuyLifetime_0 = workspace.Map.Ingame;
                                l_v92_0.Parent = l_PizzaDeliveryGuyLifetime_0;
                                l_PizzaDeliveryGuyLifetime_0 = {};
                                local l_pairs_0 = pairs;
                                local v109 = v76.Config.PizzaDeliverySpecificAnimations[l_v92_0.Name] or v76.Config.PizzaDeliveryAnimations;
                                for v110, v111 in l_pairs_0(v109) do
                                    l_PizzaDeliveryGuyLifetime_0[v110] = v3:LoadAnimationFromID(l_v92_0, v111, false);
                                end;
                                l_PizzaDeliveryGuyLifetime_0.Idle:Play();
                                l_PizzaDeliveryGuyLifetime_0.Summoned:Play(0);
                                local v112 = v76.Rig.PrimaryPart.CFrame * CFrame.new(v87 % 2 == 0 and 6 or -6, 0, 0);
                                l_v92_0:SetPrimaryPartCFrame(v112);
                                l_v92_0.Humanoid.Died:Once(function() --[[ Line: 558 ]]
                                    -- upvalues: v97 (copy), v2 (ref), v76 (ref), l_v92_0 (ref)
                                    v97:Destroy();
                                    v2:Play(v76.Config.Sounds.PizzaDeliveryMinionDeath, {
                                        Parent = l_v92_0.PrimaryPart,
                                        PlaybackSpeed = Random.new():NextNumber(0.9, 1.1)
                                    });
                                end);
                                v2:Play(v76.Config.Sounds.PizzaDeliveryGuySpawned, {
                                    Parent = v76.Rig.PrimaryPart
                                });
                                l_v92_0:AddTag("Ragdoll");
                                v3:RevealPlayerAuraTo(v76.Player, l_v92_0, 600, Color3.new(0.666667, 0, 0));
                                task.wait(0.75);
                                task.delay(1.75, function() --[[ Line: 571 ]]
                                    -- upvalues: l_v92_0 (ref), l_PizzaDeliveryGuyLifetime_0 (copy), l_Humanoid_0 (copy), v3 (ref), v86 (copy), v76 (ref), v2 (ref), l_v98_0 (ref), v97 (copy), v9 (ref), v5 (ref)
                                    if not l_v92_0.PrimaryPart then
                                        return;
                                    else
                                        l_v92_0.PrimaryPart.Anchored = false;
                                        l_PizzaDeliveryGuyLifetime_0.Walk:Play();
                                        local v113 = require(game.ReplicatedStorage.Modules.Actors);
                                        local v114 = require(game.ReplicatedStorage.Modules.SimplePath).new(l_v92_0);
                                        while task.wait() and l_v92_0.Parent and l_v92_0.PrimaryPart and l_Humanoid_0.Health > 0 do
                                            local v115 = nil;
                                            local v116 = 1e999;
                                            for _, v118 in ipairs(workspace.Players.Survivors:GetChildren()) do
                                                if v3:IsAlive(v118) and not v118:GetAttribute("BeingExecuted") and (#v3:GetAliveSurvivorCharacters() <= 1 or not v118:GetAttribute("Undetectable")) then
                                                    local l_Magnitude_0 = (v118.PrimaryPart.Position - l_v92_0.PrimaryPart.Position).Magnitude;
                                                    if l_Magnitude_0 < v116 then
                                                        v115 = v118;
                                                        v116 = l_Magnitude_0;
                                                    end;
                                                end;
                                            end;
                                            local v120 = v115 and v115.PrimaryPart and v86(v115, workspace.Players:GetChildren());
                                            local v121 = v115 and game.Players:GetPlayerFromCharacter(v115);
                                            local v122 = v121 and v113.CurrentActors[v121];
                                            if v76.Rig.Parent and v116 and v116 < v76.Config.PizzaDeliveryGuyAttackRadius then
                                                require(game.ReplicatedStorage.Modules.Ragdolls).AddProfile(v115, {
                                                    Velocity = (v115.PrimaryPart.Position - l_v92_0.PrimaryPart.Position).Unit * 30
                                                });
                                                v2:Play(v76.Config.Sounds.PizzaDeliveryMinionHit, {
                                                    Parent = l_v92_0.PrimaryPart
                                                });
                                                task.delay(1, function() --[[ Line: 524 ]]
                                                    -- upvalues: l_v98_0 (ref), v97 (ref), l_v92_0 (ref)
                                                    if not l_v98_0 then
                                                        l_v98_0 = true;
                                                        if v97 and v97.Parent then
                                                            game.TweenService:Create(v97, TweenInfo.new(0.8), {
                                                                PlaybackSpeed = 0
                                                            }):Play();
                                                        end;
                                                        game.Debris:AddItem(l_v92_0, 1);
                                                        for _, v124 in pairs(l_v92_0:GetDescendants()) do
                                                            if v124:IsA("BasePart") or v124:IsA("Decal") then
                                                                game.TweenService:Create(v124, TweenInfo.new(1), {
                                                                    Transparency = 1
                                                                }):Play();
                                                            end;
                                                        end;
                                                    end;
                                                end);
                                                l_PizzaDeliveryGuyLifetime_0.Walk:Stop(0);
                                                l_PizzaDeliveryGuyLifetime_0.Hit:Play(0);
                                                v3:ApplyDamage(v115, v76.Config.PizzaDeliveryGuyDamage, nil, v76.Rig);
                                                if v115.Name == "Elliot" and not v3:IsAlive(v115) then
                                                    v9:IncrementAchievementProgress(v76.Player, "c00lkiddPizzaMinion");
                                                end;
                                                v3:RevealPlayerAuraTo(v76.Player, v115, 7.5);
                                                local v125 = ("%*/MinionHit"):format(script.Parent);
                                                local l_v76_0 = v76;
                                                local l_pcall_4 = pcall;
                                                local v128 = "MinionHit";
                                                local v129;
                                                l_pcall_4, v129 = l_pcall_4(function() --[[ Line: 16 ]]
                                                    -- upvalues: l_v76_0 (copy), v128 (copy)
                                                    if l_v76_0.Behavior[v128] then
                                                        l_v76_0.Behavior[v128](l_v76_0);
                                                    end;
                                                end);
                                                if not l_pcall_4 then
                                                    warn((("[%*]: Failed to call .MinionHit() due to: %*"):format(v125, v129)));
                                                end;
                                                v5:ApplyStatus(v115, "Burning", {
                                                    Level = 1,
                                                    Duration = 3
                                                });
                                                v5:ApplyStatus(v115, "Slowness", {
                                                    Level = 2,
                                                    Duration = 3
                                                });
                                                v2:PlayVoiceline(v76, "PizzaDeliveryHit", {
                                                    Priority = 0,
                                                    Chance = 1
                                                });
                                                if tostring(v115.Parent) == "Survivors" then
                                                    require(game.ReplicatedStorage.Modules.Actors):IncrementActorStats(v76.Player, {
                                                        Action = "A pizza delivery minion attacked a Survivor",
                                                        RewardType = "EasyKillerAction"
                                                    });
                                                end;
                                                if v122 and v122.Behavior then
                                                    v122.Behavior.AILastSeen = nil;
                                                    break;
                                                else
                                                    break;
                                                end;
                                            elseif v76.Rig.Parent and v120 then
                                                local l_PrimaryPart_1 = l_v92_0.PrimaryPart;
                                                if l_PrimaryPart_1 then
                                                    if v114:Run(v120) then
                                                        if v122 and v122.Behavior then
                                                            v122.Behavior.AILastSeen = os.clock();
                                                        end;
                                                        if (l_PrimaryPart_1.Position - v120).Magnitude > v76.Config.PizzaDeliveryRange then
                                                            l_v92_0.Humanoid.WalkSpeed = v76.Config.PizzaDeliveryOutOfRangeSpeed;
                                                        else
                                                            l_v92_0.Humanoid.WalkSpeed = v76.Config.PizzaDeliveryGuySpeed;
                                                        end;
                                                    end;
                                                else
                                                    break;
                                                end;
                                            else
                                                task.delay(1, function() --[[ Line: 524 ]]
                                                    -- upvalues: l_v98_0 (ref), v97 (ref), l_v92_0 (ref)
                                                    if not l_v98_0 then
                                                        l_v98_0 = true;
                                                        if v97 and v97.Parent then
                                                            game.TweenService:Create(v97, TweenInfo.new(0.8), {
                                                                PlaybackSpeed = 0
                                                            }):Play();
                                                        end;
                                                        game.Debris:AddItem(l_v92_0, 1);
                                                        for _, v132 in pairs(l_v92_0:GetDescendants()) do
                                                            if v132:IsA("BasePart") or v132:IsA("Decal") then
                                                                game.TweenService:Create(v132, TweenInfo.new(1), {
                                                                    Transparency = 1
                                                                }):Play();
                                                            end;
                                                        end;
                                                    end;
                                                end);
                                                l_Humanoid_0.WalkSpeed = 0;
                                                l_PizzaDeliveryGuyLifetime_0.Walk:Stop(0);
                                                break;
                                            end;
                                        end;
                                        if v114 and v114.Destroy then
                                            v114:Destroy();
                                        end;
                                        return;
                                    end;
                                end);
                            end;
                        end;
                    end;
                end);
                task.delay(3, function() --[[ Line: 672 ]]
                    -- upvalues: v76 (copy)
                    v76.AbilitiesDisabled = false;
                end);
                return;
            else
                if game["Run Service"]:IsClient() then
                    v76.Animations.SummonPizzaDelivery:Play(0.025);
                    local l_v3_SpeedMultiplier_1 = v3:CreateSpeedMultiplier(v76.Player, 0, "HinderedMovement");
                    task.delay(2.5, function() --[[ Line: 683 ]]
                        -- upvalues: l_v3_SpeedMultiplier_1 (copy)
                        game.TweenService:Create(l_v3_SpeedMultiplier_1, TweenInfo.new(0.5), {
                            Value = 1
                        }):Play();
                        game.Debris:AddItem(l_v3_SpeedMultiplier_1, 0.5);
                    end);
                end;
                return;
            end;
        end
    }
};
v1.Created = function(_, v135) --[[ Line: 693 ]] --[[ Name: Created ]]
    -- upvalues: v3 (copy)
    local v136 = {};
    for _, v138 in v135.Config.PizzaDeliveryAnimations do
        table.insert(v136, v138);
    end;
    for _, v140 in v135.Config.PizzaDeliverySpecificAnimations do
        for _, v142 in v140 do
            table.insert(v136, v142);
        end;
    end;
    task.spawn(v3.PreloadAssets, v3, v136);
end;
v1.OnIntroduction = function(_, v144, v145, v146) --[[ Line: 709 ]] --[[ Name: OnIntroduction ]]
    task.spawn(function() --[[ Line: 710 ]]
        -- upvalues: v145 (copy)
        local v147 = v145:WaitForChild("firebrand", 20);
        if v147 then
            v147.Transparency = 0;
        end;
    end);
    local v148 = nil;
    task.delay(0.5, function() --[[ Line: 718 ]]
        -- upvalues: v148 (ref)
        v148 = game.Lighting.ClockTime;
        game.TweenService:Create(game.Lighting, TweenInfo.new(0.75), {
            ClockTime = 0
        }):Play();
    end);
    task.delay(1.5, function() --[[ Line: 723 ]]
        -- upvalues: v144 (copy), v148 (ref), v146 (copy)
        local v149 = v144.Config.IntroSky:Clone();
        v149.Parent = game.Lighting;
        game.TweenService:Create(game.Lighting, TweenInfo.new(1.5), {
            ClockTime = v148 or 12
        }):Play();
        game.Debris:AddItem(v149, v146 - 1.5);
    end);
end;
v1.OnVictory = function(_, v151, v152, _, v154) --[[ Line: 731 ]] --[[ Name: OnVictory ]]
    -- upvalues: v7 (copy), l_RunService_0 (copy)
    if v151 == "Start" then
        v7:SetCustomLighting(v152.Config.OutroLighting);
        local _ = os.clock();
        game.Players.LocalPlayer:SetAttribute("FOVMultipliersDisabled", true);
        local v156 = l_RunService_0.RenderStepped:Connect(function() --[[ Line: 740 ]]
            workspace.CurrentCamera.FieldOfView = 25;
        end);
        task.delay(v154, function() --[[ Line: 744 ]]
            -- upvalues: v156 (copy)
            v156:Disconnect();
        end);
        task.spawn(function() --[[ Line: 749 ]]
            -- upvalues: v152 (copy), v154 (copy), l_RunService_0 (ref)
            local v157 = v152.Config.IntroSky:Clone();
            v157.Parent = game.Lighting;
            game.Debris:AddItem(v157, v154 - 1.5);
            local v158 = workspace.Misc:WaitForChild("KillerCutsceneBackground", 3);
            if v158 then
                local v159 = nil;
                do
                    local l_v159_0 = v159;
                    l_v159_0 = l_RunService_0.RenderStepped:Connect(function(v161) --[[ Line: 757 ]]
                        -- upvalues: v158 (copy), l_v159_0 (ref)
                        if not v158 or not v158.Parent or not v158:FindFirstChild("People") then
                            l_v159_0:Disconnect();
                            return;
                        else
                            for v162, v163 in pairs(v158.People:GetChildren()) do
                                local l_PrimaryPart_2 = v163.PrimaryPart;
                                l_PrimaryPart_2.CFrame = l_PrimaryPart_2.CFrame * CFrame.Angles(0, v161 * (v162 % 2 == 0 and 2.25 or -2.25), 0);
                            end;
                            task.wait();
                            return;
                        end;
                    end);
                    task.delay(v154, l_v159_0.Disconnect, l_v159_0);
                end;
            end;
        end);
        return;
    else
        if v151 == "End" then
            game.Players.LocalPlayer:SetAttribute("FOVMultipliersDisabled", false);
            game.Players.LocalPlayer:SetAttribute("FOVMultipliersDisabled", nil);
            v7:SetAsCurrentLighting();
        end;
        return;
    end;
end;
v1.OnExecution = function(_, v166, v167) --[[ Line: 779 ]] --[[ Name: OnExecution ]]
    local v168 = false;
    if v167.Name == "007n7" then
        v168 = v166.Rig.PrimaryPart.CFrame * CFrame.new(3, -2.75, 2.25) * CFrame.Angles(1.5707963267948966, 0, -0.3490658503988659);
    end;
    local v169 = v167.Name == "007n7" and Vector3.new() or (v166.Rig.PrimaryPart.CFrame * CFrame.new(5, 0.5, 1)).LookVector.Unit * 200;
    local v170 = v167.Name == "007n7" and 3.6 or 3.5;
    local v171 = require(game.ReplicatedStorage.Modules.Ragdolls);
    task.delay(2.1, function() --[[ Line: 789 ]]
        -- upvalues: v171 (copy), v167 (copy), v169 (copy)
        v171.AddProfile(v167, {
            AnchorDelay = true,
            Applied = os.clock() + 5,
            Velocity = v169
        });
        local l_Humanoid_1 = v167:FindFirstChild("Humanoid");
        if l_Humanoid_1 then
            l_Humanoid_1.BreakJointsOnDeath = false;
            l_Humanoid_1.Health = 0;
        end;
    end);
    task.delay(v170, function() --[[ Line: 798 ]]
        -- upvalues: v167 (copy)
        if v167 and v167.PrimaryPart then
            v167.PrimaryPart.Anchored = false;
        end;
    end);
end;
return v1;
