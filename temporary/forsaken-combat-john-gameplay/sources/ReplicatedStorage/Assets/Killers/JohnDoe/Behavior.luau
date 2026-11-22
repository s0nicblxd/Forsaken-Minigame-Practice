-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local _ = require(game.ReplicatedStorage.GlobalTypes);
local v1 = {};
local JohnUnstoppable=require(script.Unstoppable);
local CorruptEnergyController=require(script.CorruptEnergyController);
local RigAlignment=require(script.RigAlignment);
v1.GetRig=function(_,actor) return RigAlignment.GetRig(actor) end;
local l_TweenService_0 = game:GetService("TweenService");
local _ = game:GetService("HttpService");
local l_Players_0 = game:GetService("Players");
local v5 = require(game.ReplicatedStorage.Modules.Sounds);
local v6 = require(game.ReplicatedStorage.Modules.Util);
local v7 = require(game.ReplicatedStorage.Modules.Hitboxes);
local v8 = require(game.ReplicatedStorage.Modules.Statuses);
local v9 = require(game.ReplicatedStorage.Modules.Network);
local v10 = require(game.ReplicatedStorage.Modules.AchievementUtil);
local function v16(v11, v12, v13, ...) --[[ Line: 23 ]] --[[ Name: pcallMethod ]]
    local l_status_0, l_result_0 = pcall(function(...) --[[ Line: 24 ]]
        -- upvalues: v13 (copy), v11 (copy)
        if v13.Behavior[v11] then
            return v13.Behavior[v11](v13.Behavior, v13, ...);
        else
            return;
        end;
    end, ...);
    if not l_status_0 then
        warn((("[%*]: Failed to call .%*() due to: %*"):format(v12, v11, l_result_0)));
    end;
    return l_result_0;
end;
v1.Abilities = {
    Slash = {
        LayoutOrder = 1, 
        Icon = "rbxassetid://92362553672440", 
        KeybindType = "MainAbility", 
        Callback = function(v17) --[[ Line: 42 ]] --[[ Name: Callback ]]
            -- upvalues: v5 (copy), v7 (copy), v6 (copy)
            if game["Run Service"]:IsServer() then
                v17.AbilitiesDisabled = true;
                v5:Play(v17.Config.Sounds.Swing, {
                    Parent = v17.Rig.PrimaryPart, 
                    PlaybackSpeed = Random.new():NextNumber(0.975, 1.025), 
                    Volume = 0.35
                });
                task.delay(v17.Config.SlashWindup, function() --[[ Line: 49 ]]
                    -- upvalues: v7 (ref), v17 (copy), v6 (ref), v5 (ref)
                    local _ = v7:CreateHitbox(v17.Player, { AbilityType = "MainAbility", IsProjectile = false, 
                        Size = Vector3.new(4.5, 6, 7.5, 0), 
                        CFrameOffset = RigAlignment.SlashOffset(v17), 
                        Damage = v17.Config.SlashDamage, 
                        Time = v17.Config.SlashLinger, 
                        Knockback = 2, 
                        HitMultiple = false, 
                        ExecuteOnKill = true, 
                        Connections = {
                            Hit = function(v18, v19) --[[ Line: 61 ]] --[[ Name: Hit ]]
                                -- upvalues: v6 (ref), v5 (ref), v17 (ref)
                                v6:CreateSpeedMultiplier(v18, 1.5, "HitSpeedBonus", 1.25);
                                if v19 then
                                    v5:Play(v17.Config.Sounds.Hit, {
                                        Parent = v17.Rig.PrimaryPart, 
                                        PlaybackSpeed = Random.new():NextNumber(0.975, 1.025), 
                                        Volume = 0.5
                                    });
                                end;
                            end
                        }
                    });
                end);
                task.delay(0.75, function() --[[ Line: 72 ]]
                    -- upvalues: v17 (copy)
                    v17.AbilitiesDisabled = false;
                end);
                return;
            else
                if game["Run Service"]:IsClient() then
                    if v17.Animations.Slash1 then
                        v17.Animations[("Slash%*"):format((tostring(math.random(1, 2))))]:Play(0.025);
                        return;
                    else
                        v17.Animations.Slash:Play(0.025);
                    end;
                end;
                return;
            end;
        end
    }, 
    CorruptEnergy = {
        LayoutOrder=2,Name="Corrupt Energy",Icon="rbxassetid://83849304758564",KeybindType="AltAbility1",
        Cooldown=function(actor)
            return CorruptEnergyController.CanRetract(actor) and 0 or actor.Config.CorruptEnergyCooldown
        end,
        Callback=function(actor,data)
            if game:GetService("RunService"):IsServer() then
                local result=CorruptEnergyController.Cast(actor)
                if not result.Cancelled and not result.Retract then v16("CorruptEnergyStart","JohnDoe/CorruptEnergyStart",actor) end
                return result
            end
            if not (data and data.Retract) then v16("CorruptEnergyStart","JohnDoe/CorruptEnergyStart",actor) end
            return CorruptEnergyController.Play(actor,data)
        end
    },
    DigitalFootprint = {
        LayoutOrder = 3, 
        Icon = "rbxassetid://83206360003394", 
        KeybindType = "AltAbility2", 
        Callback = function(v51, v52) --[[ Line: 311 ]] --[[ Name: Callback ]]
            -- upvalues: v5 (copy), v16 (copy), v6 (copy), v8 (copy), v9 (copy), l_Players_0 (copy)
            local v53 = {
                0.317, 
                1.05, 
                2.067
            };
            local v54 = 0;
            local v55 = 0;
            if game["Run Service"]:IsServer() then
                v51.AbilitiesDisabled = true;
                v5:Play(v51.Config.Sounds.DigitalFootprint, {
                    Parent = v51.Rig.PrimaryPart, 
                    Volume = 0.4, 
                    TimePosition = 0.09, 
                    PlaybackSpeed = 1.2
                });
                v16("DFStart", ("%*/DFS"):format(script.Parent), v51);
                local function v60(v56) --[[ Line: 323 ]] --[[ Name: removeShadow ]]
                    -- upvalues: v6 (ref), v51 (copy)
                    if v56 and v56.Parent then
                        v56.Name = "okByeBye";
                        v56.Parent = workspace.Map.Ingame;
                        game.Debris:AddItem(v56, 5);
                        local l_ShadowAmbience_0 = v56:FindFirstChild("ShadowAmbience");
                        if l_ShadowAmbience_0 then
                            game.TweenService:Create(l_ShadowAmbience_0, TweenInfo.new(2), {
                                Volume = 0
                            }):Play();
                        end;
                        for _, v59 in pairs(v56:GetDescendants()) do
                            if v59:IsA("ParticleEmitter") then
                                v59.Enabled = false;
                            end;
                        end;
                        v6:RemovePlayerAuraFrom(v56, v51.Player);
                    end;
                end;
                local l_FirstChild_0 = workspace.Map.Ingame:FindFirstChild((("%*Shadows"):format((tostring(v51.Player)))));
                if not l_FirstChild_0 then
                    l_FirstChild_0 = Instance.new("Folder");
                    l_FirstChild_0.Name = ("%*Shadows"):format((tostring(v51.Player)));
                    l_FirstChild_0.Parent = workspace.Map.Ingame;
                end;
                local l_l_FirstChild_0_Children_0 = l_FirstChild_0:GetChildren();
                if #l_l_FirstChild_0_Children_0 >= v51.Config.DigitalFootprintLimit then
                    v60(l_l_FirstChild_0_Children_0[1]);
                end;
                local v63 = v51.Config.Shadow:Clone();
                v63.Size = Vector3.new(1, 0, 0, 0);
                v63.Parent = l_FirstChild_0;
                v5:Play(v51.Config.Sounds.DigitalFootprintAmbience, {
                    Parent = v63, 
                    Name = "ShadowAmbience", 
                    RollOffMaxDistance = 30, 
                    Looped = true
                });
                local v64 = RaycastParams.new();
                v64.FilterDescendantsInstances = {
                    workspace.Players, 
                    v63
                };
                v64.FilterType = Enum.RaycastFilterType.Exclude;
                task.delay(tonumber(v53[#v53]) or 2.55, function() --[[ Line: 380 ]]
                    -- upvalues: v6 (ref), v63 (copy), v51 (copy), v60 (copy), v8 (ref), v9 (ref), l_Players_0 (ref)
                    v6:ApplyUnsafeTouched(v63, false, function(_, v66) --[[ Line: 381 ]]
                        -- upvalues: v6 (ref), v51 (ref), v63 (ref), v60 (ref), v8 (ref), v9 (ref), l_Players_0 (ref)
                        local l_Parent_0 = v66.Parent;
                        local v68 = l_Parent_0 and l_Parent_0:FindFirstChild("Humanoid");
                        if v68 and v6:GetEntityType(l_Parent_0) and l_Parent_0 ~= v51.Rig and v68 and v68.Health > 0 and v63.Name == "Shadow" and not l_Parent_0:GetAttribute("ExecutionsDisabled") then
                            v60(v63);
                            v6:RevealPlayerAuraTo(v51.Rig, l_Parent_0, 10);
                            v6:RevealPlayerAuraTo(l_Parent_0, v51.Rig, 10);
                            v8:ApplyStatus(v51.Rig, "Speed", {
                                Level = 1, 
                                Duration = 10
                            });
                            v8:ApplyStatus(l_Parent_0, "Slowness", {
                                Level = 2, 
                                Duration = 10
                            });
                            v8:ApplyStatus(l_Parent_0, "Corrupted", {
                                Level = 1, 
                                Duration = 10, 
                                Killer = v51
                            });
                            if not v51.FootprintRewardDebounce[l_Parent_0] then
                                v51.FootprintRewardDebounce[l_Parent_0] = true;
                                require(game.ReplicatedStorage.Modules.Actors):IncrementActorStats(v51.Player, {
                                    Action = "Survivor stepped into a Digital Footprint trap", 
                                    RewardType = "RegularKillerAction"
                                });
                                task.delay(15, function() --[[ Line: 408 ]]
                                    -- upvalues: v51 (ref), l_Parent_0 (copy)
                                    v51.FootprintRewardDebounce[l_Parent_0] = nil;
                                end);
                            end;
                            v9:FireClientConnection(l_Players_0:GetPlayerFromCharacter(l_Parent_0), ("%*JDPuddleEffect"):format(v51.Player.Name), "REMOTE_EVENT");
                        end;
                    end, 14);
                end);
                task.spawn(function() --[[ Line: 419 ]]
                    -- upvalues: v54 (ref), v63 (copy), v55 (ref), v53 (copy), v51 (copy), v64 (copy), v16 (ref), v9 (ref)
                    while v54 ~= 3 and v63.Parent and v63.Name == "Shadow" do
                        v55 = v55 + game["Run Service"].Heartbeat:Wait();
                        for v69 = #v53, 1, -1 do
                            if v53[v69] and v55 >= v53[v69] then
                                table.remove(v53, v69);
                                v54 = v54 + 1;
                                local l_Position_2 = (v51.Rig.PrimaryPart.CFrame * CFrame.new(-1.1, 0, -2)).Position;
                                local v71 = workspace:Raycast(l_Position_2, Vector3.new(0, -100, 0, 0), v64);
                                v63.Position = (v71 and v71.Position or v51.Rig.PrimaryPart.Position - Vector3.new(0, 2.5, 0, 0)) + Vector3.new(0, 0.5, 0, 0);
                                game.TweenService:Create(v63, TweenInfo.new(1), {
                                    Size = Vector3.new(1, v54 * 6 * v51.Config.DigitalFootprintSizeMultiplier, v54 * 6 * v51.Config.DigitalFootprintSizeMultiplier)
                                }):Play();
                                v16("OnStomp", ("%*/OnStomp"):format(script.Parent), v51, v63, v54);
                                if v54 == 3 then
                                    v9:FireAllClientConnection(("%*OnPuddleRevealed"):format(v51.Player.Name), "REMOTE_EVENT", v63);
                                end;
                            end;
                        end;
                    end;
                end);
                task.delay(3, function() --[[ Line: 446 ]]
                    -- upvalues: v51 (copy)
                    v51.AbilitiesDisabled = false;
                end);
                return v63;
            else
                if game["Run Service"]:IsClient() then
                    v51.Animations.DigitalFootprint:Play(0.025);
                    local l_Connections_0 = v51.Behavior.Connections;
                    if not l_Connections_0.onShadowFolderAdded or not l_Connections_0.onShadowFolderRemoved then
                        local l_FirstChild_1 = workspace.Map.Ingame:FindFirstChild((("%*Shadows"):format((tostring(v51.Player)))));
                        if not l_FirstChild_1 then
                            return;
                        else
                            local l_AbilityContainer_0 = v51.Player.PlayerGui.MainUI:FindFirstChild("AbilityContainer");
                            local v75 = l_AbilityContainer_0 and l_AbilityContainer_0:FindFirstChild("DigitalFootprint");
                            local v76 = 1;
                            do
                                local l_v76_0 = v76;
                                local function v80(v78) --[[ Line: 465 ]] --[[ Name: onShadowChange ]]
                                    -- upvalues: v75 (copy), l_v76_0 (ref), v51 (copy)
                                    if not v75 then
                                        return;
                                    else
                                        l_v76_0 = math.max(0, l_v76_0 + v78);
                                        v75.Charges.Text = l_v76_0 == 0 and "" or l_v76_0;
                                        local v79 = l_v76_0 >= v51.Config.DigitalFootprintLimit;
                                        v75.Charges.TextColor3 = v79 and Color3.new(1, 0, 0) or Color3.new(1, 1, 1);
                                        return;
                                    end;
                                end;
                                v51.Behavior.Connections.onShadowFolderAdded = l_FirstChild_1.ChildAdded:Connect(function(v81) --[[ Line: 477 ]]
                                    -- upvalues: v80 (copy)
                                    if not v81:IsA("BasePart") then
                                        return;
                                    else
                                        v80(1);
                                        return;
                                    end;
                                end);
                                v51.Behavior.Connections.onShadowFolderRemoved = l_FirstChild_1.ChildRemoved:Connect(function(v82) --[[ Line: 485 ]]
                                    -- upvalues: v80 (copy)
                                    if not v82:IsA("BasePart") then
                                        return;
                                    else
                                        v80(-1);
                                        return;
                                    end;
                                end);
                                v80(0);
                            end;
                        end;
                    end;
                    local l_v6_SpeedMultiplier_1 = v6:CreateSpeedMultiplier(v51.Player, 0, "DigitalFootprint");
                    game.Debris:AddItem(l_v6_SpeedMultiplier_1, 3);
                    task.spawn(function() --[[ Line: 501 ]]
                        -- upvalues: v51 (copy), v53 (copy), v55 (ref), v54 (ref), v6 (ref)
                        while v51 and v51.Rig.Parent and v53[1] do
                            v55 = v55 + game["Run Service"].Heartbeat:Wait();
                            for v84 = #v53, 1, -1 do
                                if v53[v84] and v55 >= v53[v84] then
                                    table.remove(v53, v84);
                                    v54 = v54 + 1;
                                    v6:ApplyCameraShake(v54 * 0.2, v54 * 0.375);
                                end;
                            end;
                        end;
                    end);
                    task.delay(3, function() --[[ Line: 517 ]]
                        -- upvalues: v52 (copy), v6 (ref)
                        if not v52 or not v52.Parent then
                            return;
                        else
                            v52.Transparency = 0;
                            v6:RevealPlayerAura(v52, "inf", Color3.new(1, 0.321569, 0.333333), nil, {
                                OutlineTransparency = 0.35, 
                                FillTransparency = 1
                            });
                            return;
                        end;
                    end);
                end;
                return;
            end;
        end
    }, 
    ["404Error"] = {
        Name = "404 Error", 
        LayoutOrder = 4, 
        Icon = "rbxassetid://131116145215571", 
        KeybindType = "AltAbility3", 
        Callback = function(v85) --[[ Line: 537 ]] --[[ Name: Callback ]]
            -- upvalues: v16 (copy), v5 (copy), v6 (copy), v9 (copy)
            v16("ErrorStart", ("%*/404S"):format(script.Parent), v85);
            if game["Run Service"]:IsServer() then
                v85.CurrentAbility = "404Error";
                v85.Config.StunDuration = v85.Config.UnstoppableDuration;
                v85.AbilitiesDisabled = true;
                v5:Play(v85.Config.Sounds["404Error"], {
                    Parent = v85.Rig.PrimaryPart, 
                    Volume = 0.4, 
                    TimePosition = 0.09, 
                    RollOffMaxDistance = 200, 
                    PlaybackSpeed = 1.15
                });
                task.delay(1.625, function() --[[ Line: 550 ]]
                    -- upvalues: v85 (copy)
                    v85.Config.StunDuration = nil;
                    v85.CurrentAbility = nil;
                    v85.AbilitiesDisabled = false;
                end);
                return;
            else
                if game["Run Service"]:IsClient() then
                    local l_v6_SpeedMultiplier_2 = v6:CreateSpeedMultiplier(v85.Player, 1, "404Error");
                    local l_v6_FOVMultiplier_0 = v6:CreateFOVMultiplier(v85.Player, 1, "404Error");
                    game.TweenService:Create(l_v6_SpeedMultiplier_2, TweenInfo.new(0.5), {
                        Value = 0.25
                    }):Play();
                    game.TweenService:Create(l_v6_FOVMultiplier_0, TweenInfo.new(1.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, true), {
                        Value = 0.75
                    }):Play();
                    v9:FireConnection("DisableSprinting", "404Error", true);
                    task.delay(1.2, function() --[[ Line: 567 ]]
                        -- upvalues: v5 (ref), v85 (copy), v9 (ref), l_v6_SpeedMultiplier_2 (copy), l_v6_FOVMultiplier_0 (copy), v6 (ref)
                        v5:Play(v85.Config.Sounds["404ErrorError"], {
                            Parent = v85.Rig.PrimaryPart, 
                            Volume = 0.4, 
                            TimePosition = 0.09, 
                            PlaybackSpeed = Random.new():NextNumber(0.9, 1.1)
                        });
                        v9:FireConnection("DisableSprinting", "404Error", false);
                        game.TweenService:Create(l_v6_SpeedMultiplier_2, TweenInfo.new(0.6), {
                            Value = 1
                        }):Play();
                        game.TweenService:Create(l_v6_FOVMultiplier_0, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                            Value = 1
                        }):Play();
                        game.Debris:AddItem(l_v6_SpeedMultiplier_2, 0.4);
                        game.Debris:AddItem(l_v6_FOVMultiplier_0, 1);
                        for _, v89 in pairs(workspace.Players.Survivors:GetChildren()) do
                            v6:RevealPlayerAura(v89, v85.Config["404ErrorAuraRevealTime"]);
                        end;
                    end);
                end;
                return;
            end;
        end
    }
};
v1.ErrorStart = function(_, _) --[[ Line: 591 ]] --[[ Name: ErrorStart ]]

end;
v1.CorruptEnergyStart = function(_, _) --[[ Line: 595 ]] --[[ Name: CorruptEnergyStart ]]

end;
v1.OnPuddleEpilepsy = function(_, _, _) --[[ Line: 599 ]] --[[ Name: OnPuddleEpilepsy ]]

end;
v1.OnStomp = function(_, _, v99, v100) --[[ Line: 603 ]] --[[ Name: OnStomp ]]
    for _, v102 in pairs(v99:GetDescendants()) do
        if v102:IsA("ParticleEmitter") and v102.Name:find("ShadowPuddle") then
            v102.Enabled = v102.Name == ("ShadowPuddle%*"):format(v100);
        end;
    end;
end;
v1.Created = function(v103, v104) --[[ Line: 611 ]] --[[ Name: Created ]]
    -- upvalues: v10 (copy), v6 (copy), v8 (copy), l_Players_0 (copy), v9 (copy), v5 (copy), l_TweenService_0 (copy), v16 (copy)
    v103.Connections = {};
    if game["Run Service"]:IsServer() then
        if workspace:GetAttribute("JohnDoeSpecialDay") then
            v10:IncrementAchievementProgress(v104.Player, "JohnDoeSpecialDay");
        end;
        local l_Folder_0 = Instance.new("Folder");
        l_Folder_0.Name = "JohnDoeTrail";
        l_Folder_0.Parent = v104.Rig;
        for _ = 1, math.clamp(math.round(v104.Config.TrailLength / 4), 2, 1e999) do
            local v107 = v104.Config.Trail:Clone();
            v107.Position = RigAlignment.TrailPoint(v104,true);
            v107.Parent = l_Folder_0;
            v107:SetAttribute("FinishedUpdating", true);
            v6:ApplyOnTouched(v107, false, function(_, v109) --[[ Line: 635 ]]
                -- upvalues: v8 (ref), v104 (copy)
                local l_Parent_1 = v109.Parent;
                local l_Humanoid_0 = l_Parent_1:FindFirstChild("Humanoid");
                if l_Humanoid_0 and l_Humanoid_0.Health > 0 and l_Parent_1:IsDescendantOf(workspace.Players) and tostring(l_Parent_1.Parent) ~= "Killers" then
                    v8:ApplyStatus(l_Parent_1, "Corrupted", {
                        Duration = 3, 
                        Level = 2, 
                        Killer = v104
                    });
                end;
            end);
        end;
        v104.CurrentSpikes = {};
        v104.FootprintRewardDebounce = {};
        local l_l_Folder_0_Children_0 = l_Folder_0:GetChildren();
        local v116 = 0;
        local v117 = 0;
        local v118 = 0;
        local v119 = nil;
        v119 = game["Run Service"].Heartbeat:Connect(function(v120) --[[ Line: 670 ]]
            -- upvalues: v104 (copy), l_Folder_0 (copy), v119 (ref), v118 (ref), l_Players_0 (ref), v8 (ref), v117 (ref), l_l_Folder_0_Children_0 (copy), v116 (ref)
            if not v104 or not v104.Rig.Parent or not v104.Rig.PrimaryPart then
                l_Folder_0:Destroy();
                v119:Disconnect();
                v119 = nil;
                return;
            else
                if v118 > 1 and #v104.CurrentSpikes > 0 then
                    v118 = 0;
                    local v121 = RaycastParams.new();
                    v121.FilterDescendantsInstances = v104.CurrentSpikes;
                    v121.FilterType = Enum.RaycastFilterType.Include;
                    for _, v123 in (l_Players_0:GetPlayers()) do
                        local l_Character_0 = v123.Character;
                        if l_Character_0 and l_Character_0.Parent then
                            if not l_Character_0 or not l_Character_0.Parent or l_Character_0.Parent.Name == "Killers" then

                            end;
                            local l_Humanoid_1 = l_Character_0:FindFirstChildOfClass("Humanoid");
                            if l_Humanoid_1 or l_Humanoid_1.Health <= 0 then
                                local l_PrimaryPart_0 = l_Character_0.PrimaryPart;
                                local v127 = workspace:Raycast(l_PrimaryPart_0.Position, Vector3.new(0, -5, 0, 0), v121);
                                local v128 = v127 and v127.Instance;
                                if v127 and v128 then
                                    local v129 = v128.Position.Y + v128.Size.Y / 2;
                                    local v130 = RaycastParams.new();
                                    v130.FilterDescendantsInstances = {
                                        l_Character_0, 
                                        v104.CurrentSpikes
                                    };
                                    v130.FilterType = Enum.RaycastFilterType.Exclude;
                                    local v131 = workspace:Raycast(l_PrimaryPart_0.Position, Vector3.new(0, -10, 0, 0), v130);
                                    if v131 then
                                        if v129 - v131.Position.Y >= 1.5 then
                                            v8:ApplyStatus(v123, "Corrupted", {
                                                Level = 2, 
                                                Duration = 5, 
                                                Killer = v104
                                            });
                                        end;
                                    else
                                        v8:ApplyStatus(v123, "Corrupted", {
                                            Level = 2, 
                                            Duration = 5, 
                                            Killer = v104
                                        });
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;
                v118 = v118 + v120;
                if v117 <= 0.05 then
                    v117 = v117 + v120;
                    return;
                else
                    v117 = 0;
                    local v132 = l_l_Folder_0_Children_0[v116 % #l_l_Folder_0_Children_0 + 1];
                    local v133 = l_l_Folder_0_Children_0[(v116 - 1) % #l_l_Folder_0_Children_0 + 1];
                    if v132 and v133 then
                        if v132.Size.Z <= 4 or v132:GetAttribute("FinishedUpdating") then
                            if v132:GetAttribute("FinishedUpdating") then
                                v132:SetAttribute("FinishedUpdating", nil);
                            end;
                            local v134 = RigAlignment.TrailPoint(v104,false);
                            local l_Position_3 = v133:GetPivot().Position;
                            local l_Rotation_0 = CFrame.lookAt(l_Position_3, v134).Rotation;
                            if l_Rotation_0 ~= l_Rotation_0 then
                                warn("currentTrailRotation is NaN, setting rotation to root rotation as fallback");
                                l_Rotation_0 = v104.Rig.PrimaryPart.CFrame.Rotation;
                            end;
                            v132.CFrame = CFrame.new(v133:GetPivot().Position) * l_Rotation_0 * CFrame.Angles(0, 0, 0);
                            v132.Size = Vector3.new(v132.Size.X, v132.Size.Y, (v132.Position - v134).Magnitude);
                            v132.PivotOffset = CFrame.new(0, 0, -v132.Size.Z / 2);
                            v132.CFrame = v132.CFrame * v132.PivotOffset;
                            return;
                        else
                            v132:SetAttribute("FinishedUpdating", true);
                            v116 = v116 + 1;
                            return;
                        end;
                    else
                        v116 = v116 + 1;
                        return;
                    end;
                end;
            end;
        end);
        return;
    else
        if game["Run Service"]:IsClient() then
            v104.ActiveSpikeModels = {};
            if game.Players.LocalPlayer==v104.Player and RigAlignment.IsUpdated(v104.Rig) then
                v104.JohnDoeRigCameraOffset=v6:CreateCameraOffset(v104.Rig,Vector3.new(0,.25,0),"JohnDoeDefault");
            end;
            v9:SetConnection(("%*JDPuddleEffect"):format(v104.Player.Name), "REMOTE_EVENT", function() --[[ Line: 776 ]]
                -- upvalues: v5 (ref), v104 (copy)
                v5:Play(v104.Config.Sounds.PuddleStepped);
            end);
            v9:SetConnection(("%*SpawnSpike"):format(v104.Player.Name), "REMOTE_EVENT", function(v137) --[[ Line: 780 ]]
                -- upvalues: v104 (copy), l_TweenService_0 (ref), v5 (ref)
                local v138 = v104.Config.Spike:Clone();
                local l_Y_0 = v104.Config.SpikeHitboxSize.Y;
                local v140 = Vector3.new(v137.Position.X, v137.Position.Y, v137.Position.Z);
                v138:PivotTo(CFrame.new(v140) * CFrame.Angles(3.141592653589793, math.rad(v137.Rotation), 0) - Vector3.new(0, l_Y_0, 0));
                v138.Parent = workspace.Map.Ingame;
                for _, v142 in (v138:GetDescendants()) do
                    if v142:IsA("BasePart") then
                        v142.CanCollide = false;
                        v142.CanQuery = false;
                        v142.CanTouch = false;
                    end;
                end;
                for _, v144 in (v138:GetDescendants()) do
                    if v144:IsA("ParticleEmitter") and v144.Name == "Number" then
                        v144.Color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0, v104.Config.SpikeNumbersColor), 
                            ColorSequenceKeypoint.new(1, v104.Config.SpikeNumbersColor)
                        });
                    end;
                end;
                l_TweenService_0:Create(v138.PrimaryPart, TweenInfo.new(0.1), {
                    CFrame = v138.PrimaryPart.CFrame + Vector3.new(0, l_Y_0, 0)
                }):Play();
                task.delay(v104.Config.SpikeLifetime, function() --[[ Line: 815 ]]
                    -- upvalues: v138 (copy)
                    if v138.Parent and v138.PrimaryPart then
                        game.Debris:AddItem(v138, 1.5);
                    end;
                end);
                v5:Play(v104.Config.Sounds.CorruptEnergySummon, {
                    Parent = v138.PrimaryPart, 
                    PlaybackSpeed = Random.new():NextNumber(0.8, 1.2), 
                    Volume = 0.25, 
                    TimePosition = 0.02
                });
                v104.ActiveSpikeModels[v137.SpikeUUID] = v138;
            end);
            v9:SetConnection(("%*DesummonSpike"):format(v104.Player.Name), "REMOTE_EVENT", function(v145) --[[ Line: 825 ]]
                -- upvalues: v104 (copy), l_TweenService_0 (ref), v5 (ref)
                local v146 = v104.ActiveSpikeModels[v145];
                if not v146 then
                    return;
                else
                    local l_Y_1 = v104.Config.SpikeHitboxSize.Y;
                    l_TweenService_0:Create(v146.PrimaryPart, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                        CFrame = v146.PrimaryPart.CFrame - Vector3.new(0, l_Y_1 * 2, 0)
                    }):Play();
                    v5:Play(v104.Config.Sounds.CorruptEnergyDesummon, {
                        Parent = v146.PrimaryPart, 
                        PlaybackSpeed = Random.new():NextNumber(0.9, 1.1), 
                        Volume = 0.1, 
                        TimePosition = 0.02
                    });
                    game.Debris:AddItem(v146, 1);
                    v104.ActiveSpikeModels[v145] = nil;
                    return;
                end;
            end);
            v9:SetConnection(("%*OnPuddleRevealed"):format(v104.Player.Name), "REMOTE_EVENT", function(v148) --[[ Line: 848 ]]
                -- upvalues: v16 (ref), v104 (copy)
                local l_PlayerSettings_0 = require(game.ReplicatedStorage.Initializer).PlayerSettings;
                if l_PlayerSettings_0.EpilepsyMode and l_PlayerSettings_0.EpilepsyMode.Value then
                    for _, v151 in (v148:GetDescendants()) do
                        if v151:IsA("ParticleEmitter") and v151:GetAttribute("IsEpilepsy") then
                            v151.Enabled = false;
                        end;
                    end;
                    v16("OnPuddleEpilepsy", ("%*/OnPuddleEpilepsy"):format(script.Parent), v104, v148);
                end;
            end);
            if game.Players.LocalPlayer == v104.Player then
                local v152 = v104.Config.SilencedTag or "JaneDoeSilenced";
                v104.Silencers = {};
                local function v156(v153) --[[ Line: 874 ]] --[[ Name: myWife ]]
                    -- upvalues: v104 (copy)
                    local v154 = v153:WaitForChild("Head", 4);
                    if not v154 or not v104 or not v104.SilencedConnection then
                        return;
                    else
                        local v155 = v104.Config.SilencedTemplate:Clone();
                        v155.Parent = v153;
                        v155.Weld.Part0 = v154;
                        table.insert(v104.Silencers, v155);
                        return;
                    end;
                end;
                v104.SilencedConnection = game.CollectionService:GetInstanceAddedSignal(v152):Connect(v156);
                for _, v158 in ipairs(workspace.Players.Survivors:GetChildren()) do
                    if v158:HasTag(v152) then
                        task.spawn(v156, v158);
                    end;
                end;
            end;
        end;
        return;
    end;
end;
v1.Destroyed = function(v159, v160) --[[ Line: 897 ]] --[[ Name: Destroyed ]]
    if v160.JohnDoeRigCameraOffset then v160.JohnDoeRigCameraOffset:Destroy();v160.JohnDoeRigCameraOffset=nil end;
    -- upvalues: v9 (copy)
    for _, v162 in v159.Connections do
        v162:Disconnect();
        v162 = nil;
    end;
    if game["Run Service"]:IsServer() then
        for _, v164 in v160.CurrentSpikes do
            v164:Destroy();
        end;
        return;
    else
        if game["Run Service"]:IsClient() then
            v9:RemoveConnection(("%*JDPuddleEffect"):format(v160.Player.Name), "REMOTE_EVENT");
            v9:RemoveConnection(("%*SpawnSpike"):format(v160.Player.Name), "REMOTE_EVENT");
            v9:RemoveConnection(("%*DesummonSpike"):format(v160.Player.Name), "REMOTE_EVENT");
            if v160.SilencedConnection then
                v160.SilencedConnection:Disconnect();
                local l_ipairs_0 = ipairs;
                local v166 = v160.Silencers or {};
                for _, v168 in l_ipairs_0(v166) do
                    v168:Destroy();
                end;
            end;
        end;
        return;
    end;
end;
v1.OnIntroduction = function(_, v170, v171, v172) --[[ Line: 923 ]] --[[ Name: OnIntroduction ]]
    -- upvalues: v6 (copy)
    local v173 = nil;
    if v170.Config.useClouds == true then
        v173 = Instance.new("Clouds");
        v173.Cover = 0.774;
        v173.Density = 1;
        v173.Color = Color3.fromRGB(25, 25, 25);
        v173.Parent = workspace:FindFirstChild("Terrain");
        game.Debris:AddItem(v173, v172);
    end;
    local v174 = script.IntroScreen:Clone();
    v174.Main.Title.Text = v170.Config.IntroText:gsub("PLAYERNAME", v170.Player.DisplayName);
    v174.Parent = game.Players.LocalPlayer.PlayerGui;
    game.Debris:AddItem(v174, 1.93333);
    game.TweenService:Create(v174.Main.Title, TweenInfo.new(0.83), {
        TextTransparency = 0
    }):Play();
    task.delay(0.83, function() --[[ Line: 948 ]]
        -- upvalues: v174 (copy), v170 (copy)
        game.TweenService:Create(v174.Main.Title, TweenInfo.new(0.583), {
            TextColor3 = v170.Config.IntroTextColor or Color3.new(1, 0, 0)
        }):Play();
    end);
    task.delay(1, function() --[[ Line: 953 ]]
        -- upvalues: v171 (copy)
        local l_JohnDoeTrail_0 = v171:FindFirstChild("JohnDoeTrail");
        if l_JohnDoeTrail_0 then
            l_JohnDoeTrail_0:Destroy();
        end;
    end);
    local v176 = require(game.ReplicatedStorage.Modules.Schematics.Lighting);
    v176:SetCustomLighting(v170.Config.IntroLighting);
    task.delay(2.717, function() --[[ Line: 963 ]]
        -- upvalues: v173 (ref), v170 (copy)
        if v173 then
            v173.Color = Color3.fromRGB(25, 0, 0);
        end;
        local l_AtmosphereDoe_0 = game.Lighting:FindFirstChild("AtmosphereDoe");
        if l_AtmosphereDoe_0 then
            game.TweenService:Create(l_AtmosphereDoe_0, TweenInfo.new(0.2829, Enum.EasingStyle.Linear), {
                Color = v170.Config.AtmosphereColor or Color3.fromRGB(144, 0, 0), 
                Decay = v170.Config.AtmosphereDecay or Color3.fromRGB(255, 0, 0), 
                Density = 1
            }):Play();
        end;
    end);
    local l_v6_FOVMultiplier_1 = v6:CreateFOVMultiplier(game.Players.LocalPlayer, 0.35, "JohnDoeIntroScene");
    task.delay(2.75, function() --[[ Line: 979 ]]
        -- upvalues: l_v6_FOVMultiplier_1 (copy)
        game.TweenService:Create(l_v6_FOVMultiplier_1, TweenInfo.new(0.25), {
            Value = 0.95
        }):Play();
    end);
    task.delay(v172, function() --[[ Line: 984 ]]
        -- upvalues: v176 (copy), l_v6_FOVMultiplier_1 (copy), v174 (copy), v173 (ref)
        v176:SetAsCurrentLighting();
        l_v6_FOVMultiplier_1:Destroy();
        v174:Destroy();
        if v173 then
            v173:Destroy();
        end;
    end);
end;
v1.OnVictory = function(_, v180, v181, _, _) --[[ Line: 994 ]] --[[ Name: OnVictory ]]
    -- upvalues: v6 (copy), l_TweenService_0 (copy)
    local v184 = require(game.ReplicatedStorage.Modules.Schematics.Lighting);
    if v180 == "Start" then
        v184:SetCustomLighting(v181.Config.IntroLighting);
        local l_v6_FOVMultiplier_2 = v6:CreateFOVMultiplier(game.Players.LocalPlayer, 1.1325, "JohnDoeOutroScene");
        game.Debris:AddItem(l_v6_FOVMultiplier_2, 30);
        task.spawn(function() --[[ Line: 1005 ]]
            -- upvalues: v181 (copy), v6 (ref)
            local v186 = os.clock();
            local v187 = workspace.Misc:WaitForChild("KillerCutsceneBackground", 5);
            if v187 and v187.PrimaryPart then
                local v188 = v181.Config.OutroDummy:Clone();
                v188.Name = "OutroVictim";
                v188.PrimaryPart.Anchored = true;
                v188:SetPrimaryPartCFrame(v187.PrimaryPart.CFrame);
                v188.Parent = v187;
                local v189 = v6:LoadAnimationFromID(v188, "rbxassetid://135006397147596", true);
                v189:Play(0);
                v189.TimePosition = os.clock() - v186;
                v189.Stopped:Once(function() --[[ Line: 1020 ]]
                    -- upvalues: v188 (copy)
                    for _, v191 in ipairs(v188:GetDescendants()) do
                        if v191:IsA("BasePart") then
                            v191.Anchored = true;
                        end;
                    end;
                end);
                local v192 = false;
                for _, v194 in ipairs({
                    "Shirt", 
                    "Pants", 
                    "Accessory", 
                    "Hat"
                }) do
                    if v188:FindFirstChildOfClass(v194) then
                        v192 = true;
                        break;
                    end;
                end;
                if not v192 then
                    pcall(function() --[[ Line: 1033 ]]
                        -- upvalues: v181 (ref), v188 (copy)
                        local l_HumanoidDescriptionFromUserId_0 = game.Players:GetHumanoidDescriptionFromUserId(v181.Player.UserId);
                        v188.Humanoid:ApplyDescription(l_HumanoidDescriptionFromUserId_0, Enum.AssetTypeVerification.Always);
                    end);
                end;
            end;
        end);
        task.delay(2.4, function() --[[ Line: 1042 ]]
            -- upvalues: l_TweenService_0 (ref), v181 (copy)
            local v196 = Instance.new("ColorCorrectionEffect", game.Lighting);
            v196.Name = "JohnDoeStabCC";
            local v197 = l_TweenService_0:Create(v196, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
                Contrast = 0.4, 
                Brightness = 0.1
            });
            v197:Play();
            task.wait(0.4);
            v197:Pause();
            v196.Brightness = 0.8;
            v196.Contrast = 0.3;
            v196.TintColor = v181.Config.OutroTintColor or Color3.new(0.631373, 0.0784314, 0.0901961);
            l_TweenService_0:Create(v196, TweenInfo.new(2.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
                TintColor = Color3.new(0.196078, 0.196078, 0.196078), 
                Brightness = -1, 
                Contrast = -0.5, 
                Saturation = -1
            }):Play();
        end);
        return;
    else
        if v180 == "End" then
            v184:SetAsCurrentLighting();
            local l_v6_FOVMultiplier_3 = v6:CreateFOVMultiplier(game.Players.LocalPlayer, 1, "JohnDoeOutroScene");
            game.Debris:AddItem(l_v6_FOVMultiplier_3, 1);
            local v199 = game.Lighting:WaitForChild("JohnDoeStabCC", 8);
            if v199 then
                v199:Destroy();
            end;
        end;
        return;
    end;
end;
v1.OnExecution = function(_, v201, v202) --[[ Line: 1106 ]] --[[ Name: OnExecution ]]
    local l_Humanoid_2 = v202:FindFirstChild("Humanoid");
    local v204 = require(game.ReplicatedStorage.Modules.Ragdolls);
    local v205 = (v201.Rig.PrimaryPart.CFrame.LookVector + Vector3.new(0, 0.5, 0, 0)) * 40;
    local l_Axe_0 = v202:FindFirstChild("Axe");
    local l_BackAxe_0 = v202:FindFirstChild("BackAxe");
    if v202.Name == "JaneDoe" then
        l_Axe_0.Transparency = 0;
        l_BackAxe_0.Transparency = 1;
        task.delay(2.85, function() --[[ Line: 1118 ]]
            -- upvalues: v204 (copy), v202 (copy), v205 (copy), l_Humanoid_2 (copy)
            v204.AddProfile(v202, {
                Velocity = v205, 
                KillEffects = {
                    Explode = true
                }
            });
            if l_Humanoid_2 then
                l_Humanoid_2.BreakJointsOnDeath = true;
                l_Humanoid_2.Health = 0;
            end;
        end);
        return;
    else
        task.delay(0.666, function() --[[ Line: 1128 ]]
            -- upvalues: v204 (copy), v202 (copy), v205 (copy)
            v204.AddProfile(v202, {
                AnchorDelay = true, 
                Applied = os.clock() + 5, 
                Velocity = v205
            });
            local l_Humanoid_3 = v202:FindFirstChild("Humanoid");
            if l_Humanoid_3 then
                l_Humanoid_3.BreakJointsOnDeath = false;
                l_Humanoid_3.Health = 0;
            end;
        end);
        task.delay(1.98, function() --[[ Line: 1137 ]]
            -- upvalues: v202 (copy)
            if v202 and v202.PrimaryPart then
                v202.PrimaryPart.Anchored = false;
            end;
        end);
        return;
    end;
end;
local previousCreated=v1.Created
local previousDestroyed=v1.Destroyed
v1.Created=function(self,actor)
 previousCreated(self,actor)
 CorruptEnergyController.Created(actor)
end
v1.Destroyed=function(self,actor)
 CorruptEnergyController.Destroyed(actor)
 previousDestroyed(self,actor)
end
local oldGameplayCreated=v1.Created
local oldGameplayDestroyed=v1.Destroyed
local oldGameplayOnStunned=v1.OnStunned
v1.Created=function(self,actor) oldGameplayCreated(self,actor);JohnUnstoppable.Created(actor) end
v1.Destroyed=function(self,actor) JohnUnstoppable.Destroyed(actor);oldGameplayDestroyed(self,actor) end
v1.GetStunOverride=function(_,actor) return JohnUnstoppable.GetOverride(actor) end
v1.OnStunned=function(self,actor,override)
 JohnUnstoppable.OnStunned(actor,override)
 if oldGameplayOnStunned then oldGameplayOnStunned(self,actor,override) end
end
v1.OnUnstoppableBoost=function(_,actor) return JohnUnstoppable.Boost(actor) end
v1.GetIncomingStatusDurationMultiplier=function(_,actor,name,data) return JohnUnstoppable.DurationMultiplier(actor,name,data) end
return v1;