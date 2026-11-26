-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local v0 = {};
local v1 = require(game.ReplicatedStorage.Modules.Sounds);
local v2 = require(game.ReplicatedStorage.Modules.Util);
local v3 = require(game.ReplicatedStorage.Modules.AchievementUtil);
local v4 = require(game.ReplicatedStorage.Modules.Hitboxes);
local v5 = require(game.ReplicatedStorage.Modules.Statuses);
local v6 = require(game.ReplicatedStorage.Modules.Network);
local function _(v7, v8, v9) --[[ Line: 11 ]] --[[ Name: pcallMethod ]]
    local l_status_0, l_result_0 = pcall(function() --[[ Line: 12 ]]
        -- upvalues: v9 (copy), v7 (copy)
        if v9.Behavior[v7] then
            v9.Behavior[v7](v9);
        end;
    end);
    if not l_status_0 then
        warn((("[%*]: Failed to call .%*() due to: %*"):format(v8, v7, l_result_0)));
    end;
end;
local function v20(v13, v14) --[[ Line: 23 ]] --[[ Name: createWarning ]]
    local l_PlayerGui_0 = v13.Player:FindFirstChild("PlayerGui");
    local v16 = l_PlayerGui_0 and l_PlayerGui_0:FindFirstChild("TemporaryUI");
    if not v16 then
        return;
    else
        local l_ChickenWarning_0 = v16:FindFirstChild("ChickenWarning");
        if l_ChickenWarning_0 then
            l_ChickenWarning_0:Destroy();
        end;
        local v18 = game.ReplicatedStorage.Assets.UI.Warning:Clone();
        v18.Name = "ChickenWarning";
        v18.Title.Text = tostring(v14);
        v18.Parent = v16;
        local _ = v18.Size;
        v18.Size = v18.Size + UDim2.fromScale(0.025, 0.01);
        game.TweenService:Create(v18, TweenInfo.new(0.35), {
            Size = v18.Size
        }):Play();
        task.delay(3, function() --[[ Line: 44 ]]
            -- upvalues: v18 (copy)
            if v18.Parent then
                game.Debris:AddItem(v18, 1);
                game.TweenService:Create(v18, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                    BackgroundTransparency = 1
                }):Play();
                game.TweenService:Create(v18.Title, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                    TextTransparency = 1, 
                    TextStrokeTransparency = 1, 
                    BackgroundTransparency = 1
                }):Play();
            end;
        end);
        return;
    end;
end;
v0.Abilities = {
    Slash = {
        LayoutOrder = 1, 
        KeybindType = "AltAbility1", 
        Icon = "rbxassetid://85282571177550", 
        Callback = function(v21, _) --[[ Line: 58 ]] --[[ Name: Callback ]]
            -- upvalues: v1 (copy), v5 (copy), v4 (copy), v6 (copy), v2 (copy)
            if game["Run Service"]:IsServer() then
                v21.AbilitiesDisabled = true;
                task.delay(v21.Config.SlashWindupTime * 3, function() --[[ Line: 64 ]]
                    -- upvalues: v21 (copy)
                    v21.AbilitiesDisabled = false;
                end);
                v21.Behavior:PreSlash(v21);
                v21:ChangeExpression("Concentrating", v21.Config.SlashWindupTime + 0.5);
                v1:Play(v21.Config.Sounds.Unsheath, {
                    Parent = v21.Rig.Sword
                });
                v5:ApplyStatus(v21.Rig, "Resistance", {
                    Level = 2, 
                    Duration = v21.Config.SlashWindupTime
                });
                if not v21.TotalTimesStunned then
                    v21.TotalTimesStunned = 0;
                end;
                task.delay(v21.Config.SlashWindupTime, function() --[[ Line: 79 ]]
                    -- upvalues: v1 (ref), v21 (copy), v4 (ref), v5 (ref)
                    v1:Play(v21.Config.Sounds.Slash, {
                        Parent = v21.Rig.Sword
                    });
                    local _ = v4:CreateHitbox(v21.Player, {
                        Size = Vector3.new(4, 6, 5, 0), 
                        CFrameOffset = CFrame.new(0, 0, -2.75), 
                        Damage = v21.Config.SlashDamage, 
                        Time = 0.25, 
                        Knockback = 5, 
                        HitMultiple = false, 
                        Connections = {
                            Hit = function(v23) --[[ Line: 91 ]] --[[ Name: Hit ]]
                                -- upvalues: v5 (ref), v21 (ref), v1 (ref)
                                v5:ApplyStatus(v23, "Stunned", {
                                    Duration = v21.Config.SlashStunTime
                                });
                                v1:Play(v21.Config.Sounds.Hit, {
                                    Parent = v21.Rig.Sword
                                });
                                v1:PlayVoiceline(v21, "SlashHit", {
                                    Priority = 1
                                });
                                v21:ChangeExpression("StunnedKiller", 4);
                                local v24 = ("%*/Hit"):format(script.Parent);
                                local l_v21_0 = v21;
                                local l_pcall_0 = pcall;
                                local v27 = "SlashHit";
                                local v28;
                                l_pcall_0, v28 = l_pcall_0(function() --[[ Line: 12 ]]
                                    -- upvalues: l_v21_0 (copy), v27 (copy)
                                    if l_v21_0.Behavior[v27] then
                                        l_v21_0.Behavior[v27](l_v21_0);
                                    end;
                                end);
                                if not l_pcall_0 then
                                    warn((("[%*]: Failed to call .SlashHit() due to: %*"):format(v24, v28)));
                                end;
                                v24 = v21;
                                v24.TotalTimesStunned = v24.TotalTimesStunned + 1;
                                if v21.TotalTimesStunned == 3 then
                                    require(game.ReplicatedStorage.Modules.AchievementUtil):IncrementAchievementProgress(v21.Player, "ShedletskyStunner");
                                end;
                                if tostring(v23.Parent) == "Killers" then
                                    require(game.ReplicatedStorage.Modules.Actors):IncrementActorStats(v21.Player, {
                                        Action = "Stunned Killer as Shedletsky", 
                                        RewardType = "Offensive"
                                    });
                                end;
                            end
                        }
                    });
                end);
                return;
            else
                if game["Run Service"]:IsClient() then
                    v21.Animations.Slash:Play(0.1);
                    v6:FireConnection("DisableSprinting", "ShedletskySlash", true);
                    local l_v2_SpeedMultiplier_0 = v2:CreateSpeedMultiplier(v21.Rig, 0.25, "StunningKiller");
                    task.delay(v21.Config.SlashSlowDuration or 1.4, function() --[[ Line: 127 ]]
                        -- upvalues: v6 (ref), l_v2_SpeedMultiplier_0 (copy)
                        v6:FireConnection("DisableSprinting", "ShedletskySlash", false);
                        l_v2_SpeedMultiplier_0:Destroy();
                    end);
                end;
                return;
            end;
        end
    }, 
    FriedChicken = {
        LayoutOrder = 2, 
        KeybindType = "AltAbility2", 
        Icon = "rbxassetid://87451970500470", 
        Charges = 2, 
        Callback = function(v31, _) --[[ Line: 142 ]] --[[ Name: Callback ]]
            -- upvalues: v20 (copy), v1 (copy), v3 (copy), v2 (copy), v6 (copy)
            if v31.Rig.Humanoid.Health >= v31.Rig.Humanoid.MaxHealth then
                if game["Run Service"]:IsServer() then
                    v31:IncrementCharges("FriedChicken", 1, v31.Behavior.Abilities.FriedChicken.Charges);
                    v31:SetCooldownOf("FriedChicken", 0.5);
                else
                    v20(v31, "You are already full HP, if you're really hungry take some damage first...");
                end;
                print("early return");
                return;
            elseif game["Run Service"]:IsServer() then
                v31.AbilitiesDisabled = true;
                local function v37(v33, v34) --[[ Line: 161 ]] --[[ Name: showChickenRecursive ]]
                    for _, v36 in pairs(v33:GetDescendants()) do
                        if v36.Name:find("Chicken") and (v36:IsA("BasePart") or v36:IsA("Decal")) and not v36:GetAttribute("Ignored") then
                            v36.Transparency = v34;
                        end;
                    end;
                end;
                v37(v31.Rig, 0);
                if v31.Cache.EatChicken then
                    v31.Cache.EatChicken:Play();
                end;
                v1:Play(v31.Config.Sounds.EatFriedChicken, {
                    Parent = v31.Rig.PrimaryPart
                });
                task.delay(2.4, function() --[[ Line: 177 ]]
                    -- upvalues: v31 (copy), v1 (ref)
                    v31:ChangeExpression("Happy");
                    v1:PlayVoiceline(v31, "FriedChickenYum", {
                        Priority = 1
                    });
                    task.wait(1.5);
                    v31:ChangeExpression("Default");
                end);
                local l_Humanoid_0 = v31.Rig:FindFirstChild("Humanoid");
                if not l_Humanoid_0 then
                    return;
                else
                    local l_Health_0 = l_Humanoid_0.Health;
                    local v40 = nil;
                    v40 = l_Humanoid_0.HealthChanged:Connect(function(v41) --[[ Line: 187 ]]
                        -- upvalues: l_Health_0 (copy), v31 (copy), v3 (ref)
                        if (v41 <= 0 or v41 <= l_Health_0 - 10) and v31.Rig:GetAttribute("RecentAttacker") then
                            v3:IncrementAchievementProgress(v31.Player, "ShedletskyYesPapa");
                        end;
                    end);
                    task.delay(v31.Config.FriedChickenHealDelay, function() --[[ Line: 194 ]]
                        -- upvalues: v40 (ref), v31 (copy), v2 (ref)
                        if v40 then
                            v40:Disconnect();
                        end;
                        local l_Humanoid_1 = v31.Rig:FindFirstChild("Humanoid");
                        if not l_Humanoid_1 then
                            return;
                        else
                            if l_Humanoid_1.Health > 0 then
                                v2:Heal(l_Humanoid_1, v31.Config.FriedChickenHealInitialAmount);
                                local v43 = true;
                                local l_Health_1 = l_Humanoid_1.Health;
                                local v45 = nil;
                                v45 = l_Humanoid_1.HealthChanged:Connect(function(v46) --[[ Line: 204 ]]
                                    -- upvalues: l_Health_1 (ref), v43 (ref), v45 (ref)
                                    if v46 <= 0 or v46 <= l_Health_1 - 5 then
                                        v43 = false;
                                        v45:Disconnect();
                                        v45 = nil;
                                    end;
                                    l_Health_1 = v46;
                                end);
                                local v47 = 0;
                                local duration = v31.Config.FriedChickenHealOvertimeDuration;
                                while v43 and v31.Rig.Parent and l_Humanoid_1.Health > 0 and v47 < duration do
                                    local dt = task.wait();
                                    if not v43 or not v31.Rig.Parent or l_Humanoid_1.Health <= 0 then break end;
                                    local elapsed = math.min(dt, duration - v47);
                                    v47 += elapsed;
                                    v2:Heal(l_Humanoid_1, elapsed * v31.Config.FriedChickenHealOvertimeAmount / duration);
                                end;
                                if v45 then v45:Disconnect();v45 = nil end;
                            end;
                            return;
                        end;
                    end);
                    task.delay(2.75, function() --[[ Line: 229 ]]
                        -- upvalues: v37 (copy), v31 (copy)
                        v37(v31.Rig, 1);
                    end);
                    task.delay(4, function() --[[ Line: 234 ]]
                        -- upvalues: v31 (copy)
                        v31.AbilitiesDisabled = false;
                    end);
                    return;
                end;
            else
                if game["Run Service"]:IsClient() then
                    v31.Animations.EatChicken:Play(0.1);
                    v6:FireConnection("DisableSprinting", "EatFriedChicken", true);
                    local l_v2_SpeedMultiplier_1 = v2:CreateSpeedMultiplier(v31.Rig, 0.25, "EatFriedChicken");
                    task.delay(v31.Config.FriedChickenHealDelay + 1.25, function() --[[ Line: 247 ]]
                        -- upvalues: v6 (ref), l_v2_SpeedMultiplier_1 (copy)
                        v6:FireConnection("DisableSprinting", "EatFriedChicken", false);
                        l_v2_SpeedMultiplier_1:Destroy();
                    end);
                end;
                return;
            end;
        end
    }
};
v0.PreSlash = function(_, v51) --[[ Line: 257 ]] --[[ Name: PreSlash ]]
    for _, v53 in pairs(v51.Rig:GetChildren()) do
        if v53.Name:find("Sword") and not v53:GetAttribute("Ignored") then
            v53.Transparency = 0;
        end;
    end;
    for _, v55 in pairs(v51.Rig.Sword:GetChildren()) do
        if v55:IsA("ParticleEmitter") or v55:IsA("Light") or v55:IsA("Highlight") then
            v55.Enabled = true;
        end;
    end;
    task.delay(v51.Config.SlashWindupTime + 0.3, function() --[[ Line: 269 ]]
        -- upvalues: v51 (copy)
        for _, v57 in pairs(v51.Rig:GetChildren()) do
            if v57.Name:find("Sword") then
                game.TweenService:Create(v57, TweenInfo.new(0.5), {
                    Transparency = 1
                }):Play();
            end;
        end;
        task.wait(0.3);
        local l_Sword_0 = v51.Rig:FindFirstChild("Sword");
        local l_pairs_0 = pairs;
        local v60 = l_Sword_0 and l_Sword_0:GetChildren() or {};
        for _, v62 in l_pairs_0(v60) do
            if v62:IsA("ParticleEmitter") or v62:IsA("Light") or v62:IsA("Highlight") then
                v62.Enabled = false;
            end;
        end;
    end);
end;
return v0;