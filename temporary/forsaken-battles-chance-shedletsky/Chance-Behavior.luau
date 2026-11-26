-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local v0 = {};
local v1 = {
    InvalidShotArg = "\n\nForsakenCheatKiller 777:\nYou Lose!\n"
};
local l_ReplicatedStorage_0 = game:GetService("ReplicatedStorage");
local l_RunService_0 = game:GetService("RunService");
local v4 = require(l_ReplicatedStorage_0.Modules.Actors);
local v5 = require(l_ReplicatedStorage_0.Modules.Sounds);
local v6 = require(l_ReplicatedStorage_0.Modules.Util);
local v7 = require(l_ReplicatedStorage_0.Modules.Hitboxes);
local v8 = require(l_ReplicatedStorage_0.Modules.Statuses);
local v9 = require(l_ReplicatedStorage_0.Modules.AchievementUtil);
local v10 = require(l_ReplicatedStorage_0.Modules.Network);
local function _(v11) --[[ Line: 17 ]] --[[ Name: coinflip ]]
    local v12 = Random.new():NextNumber(0, 1) <= 0.5 + v11.CoinPity / 100;
    if v12 then
        v11.CoinPity = 0;
        return v12;
    else
        v11.CoinPity = v11.CoinPity + v11.Config.CoinFlipPity;
        return v12;
    end;
end;
local function _(v14) --[[ Line: 31 ]] --[[ Name: validateVectorUnit ]]
    if v14 ~= v14 then
        return false;
    else
        return v14;
    end;
end;
local function v20(v16, v17) --[[ Line: 37 ]] --[[ Name: updatePityDisplay ]]
    local l_AbilityContainer_0 = v16.Player.PlayerGui.MainUI:FindFirstChild("AbilityContainer");
    local v19 = l_AbilityContainer_0 and l_AbilityContainer_0:FindFirstChild("CoinFlip");
    if not v19 then
        return;
    elseif v16.CoinPity > 0 then
        v19.Charges.Text = string.format("+%.1f%%", v16.CoinPity);
        if v17 then
            v19.Charges.TextColor3 = Color3.new(1, 0, 0);
            game.TweenService:Create(v19.Charges, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                TextColor3 = Color3.new(1, 1, 1)
            }):Play();
            return;
        else
            v19.Charges.TextColor3 = Color3.new(1, 1, 1);
            return;
        end;
    else
        v19.Charges.Text = "";
        return;
    end;
end;
local function v25(v21, v22, ...) --[[ Line: 70 ]] --[[ Name: __pcallMethod ]]
    assert(v21, "bad moduleInfo, must be a table");
    local l_status_0, l_result_0 = pcall(function(...) --[[ Line: 73 ]]
        -- upvalues: v21 (copy), v22 (copy)
        if v21[v22] then
            return v21[v22](...);
        else
            return;
        end;
    end, ...);
    if not l_status_0 then
        warn((("Failed to call :%*() due to: %*"):format(v22, l_result_0)));
    end;
    return l_status_0, l_result_0;
end;
v0.Created = function(_, v27) --[[ Line: 84 ]] --[[ Name: Created ]]
    -- upvalues: v10 (copy), v1 (copy), v4 (copy), v20 (copy)
    if game["Run Service"]:IsServer() then
        v27.Rig.Humanoid.MaxHealth = math.random(70, 90);
        v27.Rig.Humanoid.Health = v27.Rig.Humanoid.MaxHealth;
        v27.ShotBuffer = 0;
        v27.CoinPity = 0;
        v10:SetConnection(v27.Player.Name .. "ChanceFireShot", "REMOTE_EVENT", function(v28, ...) --[[ Line: 92 ]]
            -- upvalues: v27 (copy), v1 (ref), v4 (ref)
            if v28 ~= v27.Player then
                v28:Kick(v1.InvalidShotArg);
                return;
            else
                local v29 = v4.CurrentActors[v28];
                if v29 and v29.Behavior and v29.Behavior.FireShot then
                    v29.Behavior.FireShot(v29, ...);
                end;
                return;
            end;
        end);
        return;
    else
        if game["Run Service"]:IsClient() then
            v10:SetConnection(("%*ChancePityUpdate"):format(v27.Player.Name), "REMOTE_EVENT", function(v30, v31) --[[ Line: 104 ]]
                -- upvalues: v27 (copy), v20 (ref)
                v27.CoinPity = v30;
                v20(v27, v31);
            end);
        end;
        return;
    end;
end;
v0.Destroyed = function(_, v33) --[[ Line: 111 ]] --[[ Name: Destroyed ]]
    -- upvalues: v10 (copy)
    if game["Run Service"]:IsServer() then
        v10:RemoveConnection(v33.Player.Name .. "ChanceFireShot", "REMOTE_EVENT");
        return;
    else
        if game["Run Service"]:IsClient() then
            v10:RemoveConnection(("%*ChancePityUpdate"):format(v33.Player.Name), "REMOTE_EVENT");
        end;
        return;
    end;
end;
v0.FireShot = function(v34, v35) --[[ Line: 120 ]] --[[ Name: FireShot ]]
    -- upvalues: l_RunService_0 (copy), v1 (copy), v7 (copy), v8 (copy), v5 (copy), v4 (copy), v9 (copy)
    assert(l_RunService_0:IsServer() and v34 and v34.Player, "what are you doing");
    local _ = v35 * Vector3.new(1, 0, 1, 0);
    local l_Player_0 = v34.Player;
    if v34 and v34.ShotBuffer and v34.ShotBuffer > 0 and v35 then
        local l_Unit_0 = v35.Unit;
        if l_Unit_0 == l_Unit_0 and l_Unit_0 then
            v34.ShotBuffer = v34.ShotBuffer - 1;
            local l_PrimaryPart_0 = v34.Rig.PrimaryPart;
            l_Unit_0 = 0;
            local _ = v7:CreateHitbox(v34.Player, {
                Size = Vector3.new(v34.Config.ShootHitboxSize, v34.Config.ShootHitboxSize, v34.Config.ShootHitboxRange),
                CFrameOffset = CFrame.new(0, 0, -v34.Config.ShootHitboxRange / 2),
                Damage = v34.Config.ShootDamage,
                Time = 0.005,
                HitMultiple = true,
                Knockback = v34.Config.ShootKnockback,
                Connections = {
                    Hit = function(v40) --[[ Line: 150 ]] --[[ Name: Hit ]]
                        -- upvalues: l_PrimaryPart_0 (copy), v34 (copy), v8 (ref), v5 (ref), v4 (ref), v9 (ref), l_Unit_0 (ref)
                        local l_PrimaryPart_1 = v40.PrimaryPart;
                        if l_PrimaryPart_1 then
                            local v42 = (l_PrimaryPart_0.Position - l_PrimaryPart_1.Position).Magnitude / v34.Config.ShootHitboxRange;
                            local function _(v43, v44, v45) --[[ Line: 156 ]] --[[ Name: getValue ]]
                                return v43 + (v44 - v43) * (1 - math.clamp(v45, 0, 1));
                            end;
                            local l_ShootMinKnockback_0 = v34.Config.ShootMinKnockback;
                            local _ = l_ShootMinKnockback_0 + (v34.Config.ShootMaxKnockback - l_ShootMinKnockback_0) * (1 - math.clamp(v42, 0, 1));
                            local l_ShootMinStunDuration_0 = v34.Config.ShootMinStunDuration;
                            l_ShootMinKnockback_0 = l_ShootMinStunDuration_0 + (v34.Config.ShootMaxStunDuration - l_ShootMinStunDuration_0) * (1 - math.clamp(v42, 0, 1));
                            if l_ShootMinKnockback_0 > 1 then
                                v8:ApplyStatus(v40, "Stunned", {
                                    Duration = l_ShootMinKnockback_0
                                });
                            end;
                            v5:Play(v34.Config.Sounds.GunHitSFX, {
                                Parent = l_PrimaryPart_1,
                                Volume = 0.3
                            });
                            if tostring(v40.Parent) == "Killers" then
                                v4:IncrementActorStats(v34.Player, {
                                    Action = "Shot the Killer",
                                    RewardType = "Offensive"
                                });
                            end;
                            if v34.TimeSinceLastHeads and os.clock() <= v34.TimeSinceLastHeads + 10 then
                                v9:IncrementAchievementProgress(v34.Player, "ChanceReference");
                            end;
                            l_Unit_0 = l_Unit_0 + 1;
                            if l_Unit_0 >= 3 then
                                v9:IncrementAchievementProgress(v34.Player, "ChanceMomGetTheCamera");
                            end;
                        end;
                    end
                }
            });
            return;
        end;
    end;
    l_Player_0:Kick(v1.InvalidShotArg);
end;
v0.Abilities = {
    CoinFlip = {
        LayoutOrder = 1,
        KeybindType = "AltAbility1",
        Icon = "rbxassetid://91225744028483",
        Callback = function(v51, v52) --[[ Line: 201 ]] --[[ Name: Callback ]]
            -- upvalues: v5 (copy), v9 (copy), v8 (copy), v10 (copy)
            if game["Run Service"]:IsServer() then
                v51.AbilitiesDisabled = true;
                v51:ChangeExpression("Gambling");
                v51:PlayVoiceline("FlipCoin", {
                    Priority = 4
                });
                task.delay(1.75, function() --[[ Line: 209 ]]
                    -- upvalues: v51 (copy)
                    v51.AbilitiesDisabled = false;
                end);
                task.delay(0.1, function() --[[ Line: 214 ]]
                    -- upvalues: v51 (copy)
                    if not v51.Rig.Parent then
                        return;
                    else
                        v51.Rig.Coin.Transparency = 0;
                        for _, v54 in (v51.Rig.Coin:GetChildren()) do
                            if v54:IsA("Decal") then
                                v54.Transparency = 0;
                            end;
                        end;
                        return;
                    end;
                end);
                task.delay(1.375, function() --[[ Line: 230 ]]
                    -- upvalues: v51 (copy)
                    if not v51.Rig.Parent then
                        return;
                    else
                        v51.Rig.Coin.Transparency = 1;
                        for _, v56 in (v51.Rig.Coin:GetChildren()) do
                            if v56:IsA("Decal") then
                                v56.Transparency = 1;
                            end;
                        end;
                        return;
                    end;
                end);
                local v57 = Random.new():NextNumber(0, 1) <= 0.5 + v51.CoinPity / 100;
                if v57 then
                    v51.CoinPity = 0;
                else
                    v51.CoinPity = v51.CoinPity + v51.Config.CoinFlipPity;
                end;
                local l_v57_0 = v57;
                if not v51.Charges then
                    v51.Charges = 0;
                end;
                if not v51.WeaknessLevel then
                    v51.WeaknessLevel = 0;
                end;
                if not v51.HeadsInARow then
                    v51.HeadsInARow = 0;
                end;
                local l_PrimaryPart_2 = v51.Rig.PrimaryPart;
                v5:Play(v51.Config.Sounds.FlipCoinSFX, {
                    Parent = l_PrimaryPart_2
                });
                task.delay(1.15, function() --[[ Line: 257 ]]
                    -- upvalues: l_v57_0 (copy), v51 (copy), v5 (ref), l_PrimaryPart_2 (copy), v9 (ref), v8 (ref), v10 (ref)
                    if l_v57_0 then
                        v51.TimeSinceLastHeads = os.clock();
                        local l_v51_0 = v51;
                        l_v51_0.HeadsInARow = l_v51_0.HeadsInARow + 1;
                        v51.Charges = math.clamp(v51.Charges + 1, 0, 3);
                        v51:ChangeExpression("Happy", 1.5);
                        v51:IncrementCharges("Reroll", 1, 3);
                        v51:PlayVoiceline("Heads", {
                            Priority = 4
                        });
                        v5:Play(v51.Config.Sounds.FlipCoinHeadsSFX, {
                            Parent = l_PrimaryPart_2
                        });
                        if v51.Charges >= 3 then
                            v51:IncrementCharges("HatFix", 1, 1);
                        end;
                        if not v51.GunDisabled then
                            v51:IncrementCharges("Shoot", 1, 3);
                        end;
                        if v51.HeadsInARow >= 5 then
                            v9:IncrementAchievementProgress(v51.Player, "ChanceTime");
                        end;
                    else
                        v51.HeadsInARow = 0;
                        local l_v51_1 = v51;
                        l_v51_1.WeaknessLevel = l_v51_1.WeaknessLevel + 1;
                        v51:ChangeExpression("Sad", 1.5);
                        v8:ApplyStatus(v51.Player, "Vulnerable", {
                            Level = v51.WeaknessLevel,
                            Duration = v51.Config.CoinFlipWeaknessDuration
                        });
                        v51:PlayVoiceline("Tails", {
                            Priority = 4
                        });
                        v5:Play(v51.Config.Sounds.FlipCoinTailsSFX, {
                            Parent = l_PrimaryPart_2
                        });
                        if v51.WeaknessLevel >= 50 then
                            v9:IncrementAchievementProgress(v51.Player, "ChanceWeakness");
                        end;
                    end;
                    v10:FireClientConnection(v51.Player, ("%*ChancePityUpdate"):format(v51.Player.Name), "REMOTE_EVENT", v51.CoinPity, not l_v57_0);
                end);
                return l_v57_0;
            else
                if game["Run Service"]:IsClient() then
                    if v52 == "SUPERLUCKY" then
                        v51.Animations.FlipCoinHeads:Play(0.05);
                        return;
                    elseif v52 then
                        v51.Animations.FlipCoinHeads:Play(0.05);
                        return;
                    else
                        v51.Animations.FlipCoinTails:Play(0.05);
                    end;
                end;
                return;
            end;
        end
    },
    Shoot = {
        Name = "One Shot",
        LayoutOrder = 2,
        KeybindType = "AltAbility2",
        Icon = "rbxassetid://78498256535383",
        Charges = 0,
        Callback = function(v62, v63) --[[ Line: 310 ]] --[[ Name: Callback ]]
            -- upvalues: v25 (copy), v5 (copy), v7 (copy), v8 (copy), v9 (copy), v4 (copy), v6 (copy), v10 (copy)
            if game["Run Service"]:IsServer() then
                v62.AbilitiesDisabled = true;
                v62:ChangeExpression("Gambling");
                v25(v62.Behavior, "OnRolledOutcome", v62.Behavior, v62);
                task.delay(2.25, function() --[[ Line: 319 ]]
                    -- upvalues: v62 (copy)
                    v62.AbilitiesDisabled = false;
                end);
                task.delay(0.1, function() --[[ Line: 324 ]]
                    -- upvalues: v62 (copy)
                    for _, v65 in pairs(v62.Rig:GetDescendants()) do
                        if v65:IsA("BasePart") and v65.Name:find("Flintlock") and not v62.Config.GunAlwaysVisible then
                            v65.Transparency = 0;
                        end;
                    end;
                end);
                task.delay(v62.Config.FlintlockHideTime or 1.7, function() --[[ Line: 333 ]]
                    -- upvalues: v62 (copy)
                    for _, v67 in pairs(v62.Rig:GetDescendants()) do
                        if v67:IsA("BasePart") and v67.Name:find("Flintlock") and not v62.Config.GunAlwaysVisible then
                            v67.Transparency = 1;
                        end;
                    end;
                end);
                local v68 = {
                    explode = 25,
                    nothing = 25,
                    shoot = 50
                };
                for _ = 2, tonumber(v62.Charges) or 0 do
                    v68.explode = math.clamp(v68.explode - v62.Config.ShootLessFailureChancePerCharge, 0, 100);
                    v68.nothing = math.clamp(v68.nothing - v62.Config.ShootLessFailureChancePerCharge, 0, 100);
                    v68.shoot = math.clamp(v68.shoot + v62.Config.ShootSuccessChancePerCharge, 0, 100);
                end;
                local v70 = 0;
                for _, v72 in pairs(v68) do
                    v70 = v70 + v72;
                end;
                local v73 = "explode";
                local v74 = 0;
                local v75 = Random.new():NextNumber(0, v70);
                for v76, v77 in pairs(v68) do
                    v74 = v74 + v77;
                    if v75 <= v74 then
                        v73 = v76;
                        break;
                    end;
                end;
                v62.Charges = 0;
                v62:IncrementCharges("Reroll", 0, 0);
                v62:IncrementCharges("Shoot", 0, 0);
                v62:IncrementCharges("HatFix", 0, 0);
                local l_PrimaryPart_3 = v62.Rig.PrimaryPart;
                v5:Play(v62.Config.Sounds.GunWindUpSFX, {
                    Parent = l_PrimaryPart_3,
                    Volume = 0.1
                });
                v62:PlayVoiceline("Aim", {
                    Priority = 4
                });
                if v73 == "shoot" then
                    v62.ShotBuffer = v62.ShotBuffer + 1;
                end;
                task.delay(0.9, function() --[[ Line: 406 ]]
                    -- upvalues: l_PrimaryPart_3 (copy), v73 (ref), v62 (copy), v7 (ref), v8 (ref), v9 (ref), v4 (ref), v5 (ref), v6 (ref)
                    if l_PrimaryPart_3.Anchored then
                        return;
                    else
                        if v73 == "explode" then
                            v62:ChangeExpression("Uhoh", 0.4);
                            task.wait(0.4);
                            v62:PlayVoiceline("ExplodeGun", {
                                Priority = 4
                            });
                            if l_PrimaryPart_3.Anchored then
                                return;
                            else
                                local _ = v7:CreateHitbox(v62.Player, {
                                    Size = Vector3.new(10, 10, 10, 0),
                                    CFrame = function() --[[ Line: 419 ]] --[[ Name: CFrame ]]
                                        -- upvalues: l_PrimaryPart_3 (ref)
                                        return l_PrimaryPart_3.CFrame;
                                    end,
                                    CFrameOffset = CFrame.new(0, 0, 0),
                                    Damage = v62.Config.ShootDamage,
                                    Shape = Enum.PartType.Ball,
                                    Time = 0.005,
                                    HitMultiple = true,
                                    Knockback = function(v79) --[[ Line: 426 ]] --[[ Name: Knockback ]]
                                        -- upvalues: l_PrimaryPart_3 (ref), v62 (ref)
                                        local l_PrimaryPart_4 = v79.PrimaryPart;
                                        if l_PrimaryPart_4 then
                                            return (l_PrimaryPart_4.Position - l_PrimaryPart_3.Position).Unit * v62.Config.ShootExplosionKnockback;
                                        else
                                            return 0;
                                        end;
                                    end,
                                    Connections = {
                                        Hit = function(v81) --[[ Line: 437 ]] --[[ Name: Hit ]]
                                            -- upvalues: v8 (ref), v62 (ref), v9 (ref), v4 (ref)
                                            if v81.PrimaryPart then
                                                v8:ApplyStatus(v81, "Stunned", {
                                                    Duration = v62.Config.ShootExplosionStunDuration
                                                });
                                                v9:IncrementAchievementProgress(v62.Player, "ChanceKablam");
                                                v4:IncrementActorStats(v62.Player, {
                                                    Action = "Blew up the Killer",
                                                    RewardType = "Offensive"
                                                });
                                            end;
                                        end
                                    }
                                });
                                v5:Play(v62.Config.Sounds.GunExplodeSFX, {
                                    Parent = l_PrimaryPart_3,
                                    Volume = 0.3
                                });
                                v6:ApplyDamage(v62.Rig, v62.Config.ShootSelfDamage);
                                v62.GunDisabled = true;
                                for _, v84 in pairs(v62.Rig:GetDescendants()) do
                                    if v84:IsA("BasePart") and v84.Name:find("Flintlock") and not v62.Config.GunAlwaysVisible then
                                        v84.Transparency = 1;
                                    end;
                                end;
                                if v62.Rig.Humanoid.Health <= 0 then
                                    v9:IncrementAchievementProgress(v62.Player, "ChanceDead");
                                end;
                            end;
                        elseif v73 == "nothing" then
                            v62:ChangeExpression("Sad", 1.5);
                            v62:PlayVoiceline("GunFail", {
                                Priority = 4
                            });
                            v4:IncrementActorStats(v62.Player, {
                                Action = "You Tried",
                                RewardType = "Survivalist"
                            });
                        elseif v73 == "shoot" then
                            v62:ChangeExpression("Happy", 1.5);
                            v5:Play(v62.Config.Sounds.GunFireSuccessSFX, {
                                Parent = l_PrimaryPart_3,
                                Volume = 0.3
                            });
                            v62:PlayVoiceline("ShootSuccess", {
                                Priority = 4
                            });
                        end;
                        if v73 ~= "nothing" then
                            for _, v86 in pairs(v62.Rig:GetDescendants()) do
                                if (v86:IsA("Light") or v86:IsA("ParticleEmitter")) and v86.Parent.Name == "Muzzle" then
                                    task.spawn(function() --[[ Line: 490 ]]
                                        -- upvalues: v86 (copy)
                                        v86.Enabled = true;
                                        task.wait(0.1);
                                        v86.Enabled = false;
                                    end);
                                end;
                            end;
                        end;
                        return;
                    end;
                end);
                return {
                    Outcome = v73
                };
            else
                if game["Run Service"]:IsClient() then
                    local l_Outcome_0 = v63.Outcome;
                    local _ = v63.Sent;
                    v62.Animations.AimGun:Play();
                    v62.Animations.AimGun:AdjustSpeed(1);
                    v10:FireConnection("DisableSprinting", "ShootingGun", true);
                    local l_v6_SpeedMultiplier_0 = v6:CreateSpeedMultiplier(v62.Player, 0.3, "ShootingGun");
                    task.delay(0.9, function() --[[ Line: 518 ]]
                        -- upvalues: v10 (ref), l_v6_SpeedMultiplier_0 (copy), l_Outcome_0 (copy), v62 (copy), v6 (ref)
                        task.delay(1.2, function() --[[ Line: 520 ]]
                            -- upvalues: v10 (ref), l_v6_SpeedMultiplier_0 (ref)
                            v10:FireConnection("DisableSprinting", "ShootingGun", nil);
                            game.TweenService:Create(l_v6_SpeedMultiplier_0, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                                Value = 1
                            }):Play();
                            game.Debris:AddItem(l_v6_SpeedMultiplier_0, 1);
                        end);
                        if l_Outcome_0 == "explode" then
                            v62.Animations.AimGun:AdjustSpeed(0);
                            task.wait(0.4);
                            v62.Animations.GunExplode:Play(0);
                            v62.Animations.AimGun:Stop(0);
                            v6:ApplyCameraShake(v62.Config.CameraShakeMagnitude, v62.Config.CameraShakeDuration);
                            return;
                        elseif l_Outcome_0 == "nothing" then
                            v62.Animations.GunFail:Play(0);
                            return;
                        else
                            if l_Outcome_0 == "shoot" then
                                v62.Animations.GunFire:Play(0);
                                v62.Animations.AimGun:Stop(0);
                                v6:ApplyCameraShake(v62.Config.CameraShakeMagnitude, v62.Config.CameraShakeDuration);
                                v10:FireServerConnection(v62.Player.Name .. "ChanceFireShot", "REMOTE_EVENT", v62.Rig.PrimaryPart.CFrame.LookVector);
                            end;
                            return;
                        end;
                    end);
                end;
                return;
            end;
        end
    },
    Reroll = {
        LayoutOrder = 3,
        KeybindType = "AltAbility3",
        Icon = "rbxassetid://80029151869083",
        Charges = 0,
        Callback = function(v90, v91) --[[ Line: 555 ]] --[[ Name: Callback ]]
            -- upvalues: v5 (copy)
            if game["Run Service"]:IsServer() then
                v90.AbilitiesDisabled = true;
                task.delay(2, function() --[[ Line: 561 ]]
                    -- upvalues: v90 (copy)
                    v90.AbilitiesDisabled = false;
                end);
                local v92 = math.min(math.round(math.random(v90.Config.HealthMin, v90.Config.HealthMax) - v90.Config.RerollBasePenalty) * (math.max(0, v90.Charges - 1) * 0.05 + 1), v90.Config.HealthClamp);
                local l_PrimaryPart_5 = v90.Rig.PrimaryPart;
                v5:Play(v90.Config.Sounds.StatRerollSFX, {
                    Parent = l_PrimaryPart_5,
                    Volume = 0.25
                });
                v90.Charges = 0;
                v90:IncrementCharges("Reroll", 0, 0);
                v90:IncrementCharges("Shoot", 0, 0);
                v90:IncrementCharges("HatFix", 0, 0);
                v90:ChangeExpression("Gambling", 1.5);
                local l_Humanoid_0 = v90.Rig.Humanoid;
                local v95 = l_Humanoid_0.Health / l_Humanoid_0.MaxHealth;
                l_Humanoid_0.MaxHealth = v92;
                l_Humanoid_0.Health = v92 * v95;
                return v91;
            else
                if game["Run Service"]:IsClient() then

                end;
                return;
            end;
        end
    },
    HatFix = {
        LayoutOrder = 4,
        KeybindType = "AltAbility4",
        Icon = "rbxassetid://93434599531478",
        Charges = 0,
        Callback = function(v96, _) --[[ Line: 609 ]] --[[ Name: Callback ]]
            -- upvalues: v8 (copy), v10 (copy)
            if game["Run Service"]:IsServer() then
                v96.AbilitiesDisabled = true;
                v96:PlayVoiceline("HatFix", {
                    Priority = 4
                });
                task.delay(2, function() --[[ Line: 616 ]]
                    -- upvalues: v96 (copy)
                    v96.AbilitiesDisabled = false;
                end);
                task.delay(1, function() --[[ Line: 621 ]]
                    -- upvalues: v96 (copy), v8 (ref), v10 (ref)
                    v96.Charges = 0;
                    v96.WeaknessLevel = 0;
                    v96.GunDisabled = nil;
                    v96:IncrementCharges("Reroll", 0, 0);
                    v96:IncrementCharges("Shoot", 0, 0);
                    v96:IncrementCharges("HatFix", 0, 0);
                    v96:ChangeExpression("Gambling", 1.5);
                    v8:RemoveStatus(v96.Player, "Vulnerable");
                    v96.CoinPity = 0;
                    v10:FireClientConnection(v96.Player, ("%*ChancePityUpdate"):format(v96.Player.Name), "REMOTE_EVENT", 0, false);
                end);
                return;
            else
                if game["Run Service"]:IsClient() then
                    v96.Animations.HatFix:Play();
                end;
                return;
            end;
        end
    }
};
return v0;
