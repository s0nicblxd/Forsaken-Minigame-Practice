-- John Doe gameplay update. Requires corrected rig + Corrupt Energy + Retract cooldown repair.
assert(game:GetService("RunService"):IsStudio() and not game:GetService("RunService"):IsRunning(),"Stop Play before updating John Doe.")
local function find(path)
 local current=game
 for name in path:gmatch("[^/]+") do current=current and current:FindFirstChild(name) end
 return current
end
local function fingerprint(source)
 local a,b=5381,0
 for i=1,#source do local byte=string.byte(source,i);a=(a*33+byte)%4294967296;b=(b*65599+byte)%4294967296 end
 return string.format("%d:%08x:%08x",#source,a,b)
end
local plans={
{path=[========[
ReplicatedStorage/Assets/Killers/JohnDoe/Behavior]========],source=[========[
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
return v1;]========],before="44616:b00279cd:a86d6fe0",after="44749:390a4cd0:d5218943"},
{path=[========[
ReplicatedStorage/Assets/Killers/JohnDoe/Behavior/CorruptEnergyController/Server]========],source=[========[
local RunService=game:GetService("RunService")
local TweenService=game:GetService("TweenService")
local Debris=game:GetService("Debris")
local Modules=game.ReplicatedStorage.Modules
local Hitboxes=require(Modules.Hitboxes)
local Network=require(Modules.Network)
local Util=require(Modules.Util)
local Sounds=require(Modules.Sounds)
local Statuses=require(Modules.Statuses)
local Actors=require(Modules.Actors)
local Rules=require(script.Parent.Rules)
local Unstoppable=require(script.Parent.Parent.Unstoppable)
local Server={}
local function alive(a)
 local hum=a.Rig and a.Rig:FindFirstChildOfClass("Humanoid")
 return not a.JDCEDestroyed and a.Rig and a.Rig.Parent and a.Rig.PrimaryPart and hum and hum.Health>0
end
local function blocked(a)
 local r=a.Rig
 return r:GetAttribute("Stunned") or r:GetAttribute("Helpless") or r:GetAttribute("Ragdolling") or r:GetAttribute("AbilitiesDisabled") or r.PrimaryPart.Anchored
end
local function broadcast(a,kind,data)
 Network:FireAllClientConnection(a.Player.Name..kind,"REMOTE_EVENT",data)
end
local function sound(a,name,parent)
 local id=a.Config.Sounds and a.Config.Sounds[name]
 if id and parent then pcall(Sounds.Play,Sounds,id,{Parent=parent,Volume=.4}) end
end
function Server.CanRetract(a)
 local c=a.JDCECast
 return c and c.active and not c.casting and c.live>0 or false
end
local function refresh(a)
 if a.Rig and a.Rig.Parent then a.Rig:SetAttribute("JDCanRetract",Server.CanRetract(a)) end
end
local function release(a,c)
 if not c.casting then return end
 c.casting=false
 Unstoppable.EndCorrupt(a,c.interrupted or not c.active)
 if c.slow then c.slow:Destroy();c.slow=nil end
 a.AbilityDisablers.JohnCorruptEnergy=nil
 if a.CurrentAbility=="CorruptEnergy" then a.CurrentAbility=nil;a.Config.StunDuration=c.previousStunDuration end
 refresh(a)
end
local function removeSpike(a,c,s,immediate)
 if not s.live then return end
 s.live=false;c.live-=1
 if s.hitbox and s.hitbox.Cancel then s.hitbox:Cancel() end
 if s.rise then s.rise:Cancel() end
 local index=table.find(a.CurrentSpikes,s.part)
 if index then table.remove(a.CurrentSpikes,index) end
 broadcast(a,"DesummonSpike",s.id)
 if s.part.Parent then
  s.part.CanCollide=false;s.part.CanTouch=false
  if immediate then s.part:Destroy()
  else
   TweenService:Create(s.part,TweenInfo.new(1,Enum.EasingStyle.Quad,Enum.EasingDirection.In),{CFrame=s.part.CFrame-Vector3.new(0,a.Config.SpikeHitboxSize.Y*2,0)}):Play()
   Debris:AddItem(s.part,1.05)
  end
 end
 refresh(a)
end
local function clear(a,immediate)
 local c=a.JDCECast
 if not c then return end
 c.active=false;release(a,c)
 for _,s in ipairs(c.spikes) do removeSpike(a,c,s,immediate) end
 a.JDCECast=nil;refresh(a)
end
local function reward(a,target)
 local hum=target:FindFirstChildOfClass("Humanoid")
 if not hum then return end
 if hum.Health>0 then
  Util:CreateSpeedMultiplier(target,1.5,"HitSpeedBonus",1.25)
  Statuses:ApplyStatus(a.Rig,"Speed",{Level=1,Duration=7})
  Util:RevealPlayerAuraTo(a.Player,target,2.5)
 end
 if target.Parent and target.Parent.Name=="Survivors" then
  Actors:IncrementActorStats(a.Player,{Action=hum.Health<=0 and "Killed a Survivor with Corrupt Energy" or "Damaged a Survivor with Corrupt Energy",RewardType=hum.Health<=0 and "DifficultKillerAction" or "EasyKillerAction"})
 end
 if hum.Health<=0 then
  local achievement=require(Modules.AchievementUtil)
  achievement:IncrementAchievementProgress(a.Player,"JohnDoeSpikes")
 end
end
local function spawnSpike(a,c,index,now)
 if not c.active or c.interrupted or not alive(a) then return end
 local params=RaycastParams.new();params.FilterType=Enum.RaycastFilterType.Exclude;params.FilterDescendantsInstances={workspace.Players}
 local point=(a:GetPivot()*CFrame.new(0,0,-a.Config.DistanceBetweenSpikes*index)).Position
 local hit=workspace:Raycast(point,Vector3.new(0,-100,0),params) or workspace:Raycast(point,Vector3.new(0,100,0),params)
 if not hit then return end
 local size=a.Config.SpikeHitboxSize
 local rotation=math.random(0,360)
 local data={Position=hit.Position,Rotation=rotation,SpikeUUID=tostring(c.serial)..":"..index}
 local part=Instance.new("Part");part.Name="SpikeCollision";part.Size=size;part.Transparency=1
 part.Anchored=true;part.CanTouch=false;part.CanCollide=true;part.CustomPhysicalProperties=a.Config.SpikeProperties
 local from=CFrame.new(hit.Position)*CFrame.Angles(0,math.rad(rotation),math.pi/2)-Vector3.new(0,size.Y,0)
 part.CFrame=from;part.Parent=workspace.Map.Ingame
 local s={part=part,id=data.SpikeUUID,live=true,expires=now+a.Config.SpikeLifetime}
 table.insert(c.spikes,s);table.insert(a.CurrentSpikes,part);c.live+=1
 s.rise=TweenService:Create(part,TweenInfo.new(.1,Enum.EasingStyle.Linear),{CFrame=from+Vector3.new(0,size.Y*2,0)})
 s.rise:Play();broadcast(a,"SpawnSpike",data)
 s.hitbox=Hitboxes:CreateHitbox(a.Player,{
  AbilityType="CorruptEnergy",IsProjectile=false,Size=size,CFrame=function()return part.CFrame end,
  Damage=a.Config.CorruptEnergyDamage,Time=.15,Knockback=5,HitMultiple=true,PredictVelocity=false,CastPoint=false,
  -- Reject before damage, block reactions, knockback, or hit callbacks. Reservation is atomic across spikes.
  HitFilter=function(target)
   return s.live and alive(a) and Rules.ReserveHit(c,target,a.Config.SpikeHitCap)
  end,
  Connections={Hit=function(target,first)
   reward(a,target)
   if first then sound(a,"Hit",a.Rig.PrimaryPart) end
  end}
 })
 refresh(a)
end
local function step(a)
 if not alive(a) then Server.Destroyed(a);return end
 local c=a.JDCECast
 if not c then return end
 local now=os.clock()
 if c.casting then
  if blocked(a) then c.interrupted=true;release(a,c)
  else
   while c.next<=a.Config.SpikeAmount and now-c.started>=Rules.SpawnAt(c.next,a.Config.DelayBetweenSpikeSummons) do
    local index=c.next;c.next+=1;spawnSpike(a,c,index,now)
   end
   if now-c.started>=math.max(3.5,Rules.SpawnAt(a.Config.SpikeAmount,a.Config.DelayBetweenSpikeSummons)+.1) then release(a,c) end
  end
 end
 for _,s in ipairs(c.spikes) do if s.live and (not s.part.Parent or now>=s.expires) then removeSpike(a,c,s,not s.part.Parent) end end
 if not c.casting and c.live==0 then c.active=false;a.JDCECast=nil;refresh(a) end
end
function Server.Cast(a)
 if not alive(a) or blocked(a) then return {Cancelled=true} end
 if Server.CanRetract(a) then clear(a,false);return {Retract=true,Cooldown=0} end
 if a.JDCECast and a.JDCECast.casting then return {Cancelled=true} end
 clear(a,true)
 a.JDCESerial=(a.JDCESerial or 0)+1
 local c={serial=a.JDCESerial,active=true,casting=true,started=os.clock(),next=1,live=0,spikes={},hits={},previousStunDuration=a.Config.StunDuration}
 a.JDCECast=c;Unstoppable.BeginCorrupt(a);a.AbilityDisablers=a.AbilityDisablers or {};a.AbilityDisablers.JohnCorruptEnergy=true
 a.CurrentAbility="CorruptEnergy";a.Config.StunDuration=a.Config.UnstoppableDuration
 c.slow=Util:CreateSpeedMultiplier(a.Player,.001,"JohnCorruptEnergyCast")
 sound(a,"CorruptEnergy",a.Rig.PrimaryPart);refresh(a)
 return {Retract=false}
end
function Server.Created(a)
 a.JDCEDestroyed=false;a.JDCEConnections={};a.CurrentSpikes=a.CurrentSpikes or {}
 local original=a.CanUseAbility;a.JDCEOriginalCanUse=original
 local function canUse(self,name)
  if name~="CorruptEnergy" or not Server.CanRetract(a) then return original(self,name) end
  -- Keep every ordinary lock/check; bypass only this actor's existing CE cooldown for Retract.
  local cooldown=a.Cooldowns.CorruptEnergy;a.Cooldowns.CorruptEnergy=nil
  local ok,result=pcall(original,self,name)
  a.Cooldowns.CorruptEnergy=cooldown
  if not ok then error(result) end
  return result
 end
 a.CanUseAbility=canUse;a.JDCECanUseWrapper=canUse
 table.insert(a.JDCEConnections,RunService.Heartbeat:Connect(function()step(a)end))
 table.insert(a.JDCEConnections,a.Rig:GetAttributeChangedSignal("Stunned"):Connect(function()
  if a.Rig:GetAttribute("Stunned") and a.JDCECast and a.JDCECast.casting then a.JDCECast.interrupted=true;release(a,a.JDCECast) end
 end))
 table.insert(a.JDCEConnections,a.Rig:FindFirstChildOfClass("Humanoid").Died:Connect(function()Server.Destroyed(a)end))
 refresh(a)
end
function Server.Destroyed(a)
 if a.JDCEDestroyed then return end
 a.JDCEDestroyed=true;clear(a,true)
 for _,connection in ipairs(a.JDCEConnections or {}) do connection:Disconnect() end
 a.JDCEConnections={}
 if a.CanUseAbility==a.JDCECanUseWrapper then a.CanUseAbility=a.JDCEOriginalCanUse end
end
return Server
]========],before="8256:bef18f60:1b128a83",after="8401:3a023998:9a3699a1"},
{path=[========[
ReplicatedStorage/Assets/Killers/JohnDoe/Behavior/RigAlignment]========],source=[========[
-- Phase-one geometry only. No attack reach, cooldown, damage or status balance changes.
local Alignment={}
function Alignment.IsUpdated(rig) return rig:GetAttribute("JohnDoeRigPhase")=="1.0.0" end
function Alignment.GroundHeight(rig)
 local hum=rig:FindFirstChildOfClass("Humanoid")
 local root=rig.PrimaryPart
 local leg=rig:FindFirstChild("Left Leg") or rig:FindFirstChild("Right Leg")
 return (hum and hum.HipHeight or 0)+(root and root.Size.Y/2 or 1)+(leg and leg.Size.Y or 2)
end
function Alignment.GroundPoint(rig)
 local root=rig.PrimaryPart
 local params=RaycastParams.new()
 params.FilterType=Enum.RaycastFilterType.Exclude
 params.FilterDescendantsInstances={workspace:FindFirstChild("Players") or rig,rig}
 params.RespectCanCollide=true
 local hit=workspace:Raycast(root.Position,Vector3.new(0,-Alignment.GroundHeight(rig)-8,0),params)
 return hit and hit.Position+Vector3.new(0,.03,0) or root.Position-Vector3.new(0,Alignment.GroundHeight(rig),0)
end
function Alignment.TrailPoint(actor,initial)
 if Alignment.IsUpdated(actor.Rig) then return Alignment.GroundPoint(actor.Rig) end
 return actor.Rig.PrimaryPart.Position-Vector3.new(0,initial and 4.5 or 3,0)
end
function Alignment.SlashOffset(actor)
 local y=Alignment.IsUpdated(actor.Rig) and 3-Alignment.GroundHeight(actor.Rig) or 0
 return CFrame.new(0,y,-2.25)
end
function Alignment.GetRig(actor)
 if not actor.SkinFolder then
  actor.Config.CollisionHitbox=actor.Config.JohnDoeRigCollision
  actor.Config.QueryHitbox=actor.Config.JohnDoeRigQuery
 end
 return actor.Rig:Clone()
end
return Alignment
]========],before="1566:d24c3da8:4e8231d7",after="1566:3186c8e4:e95d3353"},
{path=[========[
ReplicatedStorage/Assets/Killers/JohnDoe/Behavior/Unstoppable]========],source=[========[
-- John-specific Unstoppable windows. Never changes other actors' status durations.
local RunService=game:GetService("RunService")
local Actors=require(game.ReplicatedStorage.Modules.Actors)
local Statuses=require(game.ReplicatedStorage.Modules.Statuses)
local Network=require(game.ReplicatedStorage.Modules.Network)
local Controller={}
local legacyNegative={Glitched=true,Glitch=true,GlitchedOld=true,Slowness=true,Bleeding=true,Burning=true,Nausea=true,Blindness=true,Oblivious=true,Poisoned=true,PoisonedThatKillsYou=true,Helpless=true,Weakness=true,Vulnerable=true,Confusion=true,Hemmorhage=true,Hacked=true,Corrupted=true,Hallucination=true,Marked=true,Resonance=true,Atropa=true,Subspaced=true,Fatigue=true,Exhausted=true,Stunned=true,Creatures=true}
local function alive(a)
 local hum=a.Rig and a.Rig:FindFirstChildOfClass("Humanoid")
 return not a.JDUnstoppableDestroyed and a.Rig and a.Rig.Parent and hum and hum.Health>0
end
local function speed(a) return Statuses:PlayerHasStatus(a.Player,"Speed") end
local function sentinelCount()
 local n,seen=0,{}
 for _,actor in pairs(Actors.CurrentActors) do
  local rig=actor.Rig;local hum=rig and rig:FindFirstChildOfClass("Humanoid")
  if actor.Config and actor.Config.Class=="Sentinel" and rig and rig.Parent and rig.Parent.Name~="Spectating" and hum and hum.Health>0 and not seen[rig] then n+=1;seen[rig]=true end
 end
 return n
end
function Controller.BeginCorrupt(a)
 if a.JDUnstoppableDestroyed then return end
 a.JDCorruptCasting=true;a.JDCorruptWindowUntil=nil
end
function Controller.EndCorrupt(a,cancelled)
 a.JDCorruptCasting=nil
 if a.JDUnstoppableDestroyed then a.JDCorruptWindowUntil=nil;return end
 a.JDCorruptWindowUntil=not cancelled and os.clock()+(a.Config.CorruptEnergyUnstoppableLinger or 1.5) or nil
end
function Controller.GetOverride(a)
 if not alive(a) then return end
 local ability
 if a.CurrentAbility=="404Error" and a.Config.StunDuration then ability="404Error"
 elseif a.JDCorruptCasting or os.clock()<(a.JDCorruptWindowUntil or 0) then ability="CorruptEnergy" end
 a.JDUnstoppableTriggerAbility=ability
 if ability then return a.Config.UnstoppableDuration or 2 end
end
function Controller.OnStunned(a,override)
 local ability=a.JDUnstoppableTriggerAbility;a.JDUnstoppableTriggerAbility=nil
 if not override or not ability or not alive(a) then return end
 a.JDUnstoppablePending=true
 local remaining=a:IsOnCooldown(ability)
 local base=a.Config[ability.."Cooldown"]
 if type(remaining)=="number" and type(base)=="number" then a:SetCooldownOf(ability,math.min(remaining,base*.5)) end
end
local function ensureSpeed(a,remaining)
 local current=speed(a)
 if not current then
  Statuses:ApplyStatus(a.Player,"Speed",{Level=1,Duration=remaining,AppliedFrom="JohnDoeUnstoppable"})
 elseif (current.Level or 1)==1 then
  -- Preserve a longer existing Speed I; extend a shorter one without shortening its remainder.
  local oldRemaining=math.max(0,(current.TimeRequired or current.Data.Duration or 0)-(current.TimePast or 0))
  if oldRemaining<remaining then
   current.TimeRequired=(current.TimePast or 0)+remaining;current.Data.Duration=current.TimeRequired
   Network:FireClientConnection(a.Player,"StatusUpdated","REMOTE_EVENT","Speed",{TimePast=current.TimePast or 0,Level=current.Level,Duration=current.TimeRequired})
  end
 end
end
function Controller.Boost(a)
 if not a.JDUnstoppablePending then return false end
 a.JDUnstoppablePending=nil
 if not alive(a) then return true end
 local duration=(a.Config.UnstoppableSpeedBoostDuration or 3)+sentinelCount()
 a.JDUnstoppableProtectionUntil=os.clock()+duration
 ensureSpeed(a,duration)
 return true
end
function Controller.DurationMultiplier(a,name,data)
 if not alive(a) or os.clock()>=(a.JDUnstoppableProtectionUntil or 0) or not speed(a) then return 1 end
 local negative=data and data.IsNegative
 if negative==nil then negative=legacyNegative[name] end
 return negative and (a.Config.UnstoppableNegativeStatusDurationMultiplier or .5) or 1
end
function Controller.Created(a)
 if not RunService:IsServer() then return end
 a.JDUnstoppableDestroyed=false
 a.JDUnstoppableHeartbeat=RunService.Heartbeat:Connect(function()
  local remaining=(a.JDUnstoppableProtectionUntil or 0)-os.clock()
  if remaining>0 and alive(a) then ensureSpeed(a,remaining)
  elseif remaining<=0 then a.JDUnstoppableProtectionUntil=nil end
 end)
end
function Controller.Destroyed(a)
 a.JDUnstoppableDestroyed=true
 if a.JDUnstoppableHeartbeat then a.JDUnstoppableHeartbeat:Disconnect();a.JDUnstoppableHeartbeat=nil end
 a.JDCorruptCasting=nil;a.JDCorruptWindowUntil=nil;a.JDUnstoppableProtectionUntil=nil;a.JDUnstoppablePending=nil;a.JDUnstoppableTriggerAbility=nil
end
return Controller
]========],before=false,after="4697:821a22d8:8c2fcadb"},
{path=[========[
ReplicatedStorage/Assets/Killers/JohnDoe/Config]========],source=[========[
-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local l_workspace_Attribute_0 = workspace:GetAttribute("JohnDoeSpecialDay");
local v1 = {
    DisplayName = "John Doe", 
    Quote = l_workspace_Attribute_0 and "dude i told you not to play on march 18th" or "DON'T PLAY ROBLOX ON MARCH 18TH?!?!", 
	RenderImage = l_workspace_Attribute_0 and "rbxassetid://125927083463034" or "rbxassetid://115998690833101", 
    Price = l_workspace_Attribute_0 and 318 or 1000, 
    Health = l_workspace_Attribute_0 and 3182026 or 2300, 
    Speed = l_workspace_Attribute_0 and 11.3182026 or 9, 
    IntroText = "They're all yours, Mr. Doe", 
    SprintSpeed = l_workspace_Attribute_0 and 27.53182026 or 27.25, 
    StaminaLoss = 9.5, 
    StaminaGain = 21, 
    MaxStamina = l_workspace_Attribute_0 and 115.3182026 or 110, 
    SlashDamage = l_workspace_Attribute_0 and 45.3182026 or 28, 
    SlashCooldown = l_workspace_Attribute_0 and 2.3182026 or 1.75, 
    SlashWindup = 0.35, 
    SlashLinger = 0.25, 
    CorruptEnergyDamage = l_workspace_Attribute_0 and 16.3182026 or 11, 
    CorruptEnergyCooldown = l_workspace_Attribute_0 and 40.3182026 or 18, 
    SpikeAmount = l_workspace_Attribute_0 and 256 or 31, 
    SpikeHitboxSize = Vector3.new(11, 5, 5, 0), 
    SpikeLifetime = l_workspace_Attribute_0 and 18.3182026 or 14, 
    SpikeHitCap = l_workspace_Attribute_0 and 3182026 or 2, 
    SpikeProperties = PhysicalProperties.new(0.2, 2, 0, 100, 100), 
    DelayBetweenSpikeSummons = l_workspace_Attribute_0 and 0.02 or 0.045, 
    DistanceBetweenSpikes = 4, 
    DigitalFootprintCooldown = 3, 
    DigitalFootprintLimit = l_workspace_Attribute_0 and 4 or 3, 
    ["404ErrorAuraRevealTime"] = l_workspace_Attribute_0 and 10.3182026 or 6, 
    ["404ErrorCooldown"] = 20, 
    Spike = script.Spike, 
    Shadow = script.Shadow, 
    Trail = script.Trail, 
    SpikeNumbersColor = Color3.fromRGB(255, 0, 0), 
    TrailLength = l_workspace_Attribute_0 and 356 or 52, 
    UnstoppableDuration = 2, 
    SilencedTemplate = script.NAN, 
    Silenced = true, 
    OutroDummy = script.OutroVictim, 
    useClouds = true, 
    Relations = {
        "JaneDoe"
    }, 
    LastManStandingEmotionalData = {
        ThemeID = "rbxassetid://90004798416076", 
        RoundTime = 99
    }, 
    LastManStandingData = {
        ThemeID = "rbxassetid://128206924329556", 
        ThemeProperties = {
            Volume = 1.8
        }, 
        RoundTime = 75
    }, 
    Animations = {
        Idle = "rbxassetid://78316360457839", 
        Walk = "rbxassetid://76406790148345", 
        Run = "rbxassetid://75860288793447", 
        InjuredIdle = "rbxassetid://78316360457839", 
        InjuredWalk = "rbxassetid://76406790148345", 
        InjuredRun = "rbxassetid://75860288793447", 
        Stunned = {
            Start = "rbxassetid://138679230786776", 
            Loop = "rbxassetid://70827891324537", 
            End = "rbxassetid://74361242843808", 
            Cancel = "rbxassetid://132248641730444"
        }, 
        Execution = {
            KillerRig = "rbxassetid://83976183793168", 
            PlayerRig = "rbxassetid://128883910284038", 
            PlayerCFrameOffset = CFrame.Angles(0, 3.141592653589793, 0) * CFrame.new(0, 0, 3)
        }, 
        ExecutionJaneDoe = {
            KillerRig = "rbxassetid://113867319138589", 
            PlayerRig = "rbxassetid://110119432571584"
        }, 
        Slash = "rbxassetid://115517017692371", 
        CorruptEnergy = "rbxassetid://98447162219573", 
        DigitalFootprint = "rbxassetid://105781326773024", 
        Introduction = {
            KillerRig = "rbxassetid://119476049603730", 
            CameraRig = "rbxassetid://140634358360682"
        }, 
        Victory = {
            KillerRig = "rbxassetid://103715079223416", 
            CameraRig = "rbxassetid://98794271647444"
        }
    }, 
	Sounds = {
		Ambience = "rbxassetid://94207556272752",
		Footsteps = {
			"rbxassetid://86542629849582",
			"rbxassetid://122149641699340"
		},
		TerrorRadiusThemes = {
			[60] = {
				ID = "rbxassetid://87108568049500",
				BPM = 100
			},
			[40] = {
				ID = "rbxassetid://112183456126257",
				BPM = 100
			},
			[20] = {
				ID = "rbxassetid://110315081858949",
				BPM = 100
			},
			[6] = {
				ID = "rbxassetid://90755511989120",
				BPM = 100,
				Chase = true
			}
		},
		Execution = "rbxassetid://91088178573563",
		ExecutionJaneDoe = "rbxassetid://80688333799111",
		StunEnded = "rbxassetid://127453218558340",
		Swing = "rbxassetid://140242176732868",
		Hit = "rbxassetid://90819435118493",
		CorruptEnergy = "rbxassetid://109525294317144",
		CorruptEnergySummon = "rbxassetid://111388466508150",
		CorruptEnergyDesummon = "rbxassetid://112806895489970",
		PuddleStepped = "rbxassetid://100270933047659",
		DigitalFootprint = "rbxassetid://114243439622992",
		DigitalFootprintAmbience = "rbxassetid://140163779889034",
		["404Error"] = "rbxassetid://125897321587591",
		["404ErrorError"] = "rbxassetid://90307135163105",
		Introduction = "rbxassetid://79031693606570",
		VictoryTheme = "rbxassetid://122795850954647"
	}
};
v1.Information = {
    {
        Separator = "GENERAL INFO"
    }, 
    {
        Header = "JOHN DOE", 
        Text = "The defunct code of the early days of Roblox courses through their body, consuming his mind as he now only focuses on one thing: to kill everyone in his path. An unstoppable force entering the round with a strategical mindset, he's able to set traps, summon walls to back survivors into a corner, and leave behind a faint trail that damages those who step on it.\n"
    }, 
    {
        Header = "STATS", 
        Text = "Difficulty: \226\152\133\226\152\133\226\152\133\226\152\133\226\152\133\n" .. ("Health: %*\n"):format(v1.Health) .. ("Regular Speed: %*\n"):format(v1.Speed) .. ("Sprinting Speed: %*\n"):format(v1.SprintSpeed) .. ("Max Stamina: %*\n"):format(v1.MaxStamina) .. ("Stamina Loss per sec: %*\n"):format(v1.StaminaLoss) .. ("Stamina Gain per sec: %*\n"):format(v1.StaminaGain) .. "Terror Radius: 60 studs\n"
    }, 
    {
        Separator = "PASSIVES"
    }, 
    {
        Header = "NATURAL MALEVOLENCE", 
        Quote = "\"We\226\128\153re dedicated to building a fun, safe environment where kids of all ages can power their imagination on Roblox.\" - Roblox", 
        Text = "For every step that <font color=\"rgb(248,217,109)\">John Doe</font> takes, a trail of corruption follows behind him.\nAny survivor that's unfortunate enough to step within the corruption is given <b>Corrupted II</b> for 3 seconds.\n"
    }, 
    {
        Header = "UNSTOPPABLE", 
        Quote = "\"Consider this myth busted.\" - Roblox", 
        Text = ("<font color=\"rgb(248,217,109)\">John Doe</font> can only be stunned for %*s while casting Corrupt Energy and 404 Error.\n"):format(v1.UnstoppableDuration) .. "Additionally, <font color=\"rgb(248,217,109)\">John Doe</font> will roar and gain <b>Speed I</b> for 3s upon the stun ending. The duration of the speed boost is increased by 1s for every Sentinel Survivor currently alive.\n" .. "Corrupt Energy grants its Unstoppable trigger window for an additional 1.5s after casting. While the resulting Speed boost is active, incoming negative status durations are reduced by 50%. The triggering ability cooldown is reduced by 50%.\n"
    }, 
    {
        Separator = "ABILITIES"
    }, 
    {
        Header = "SLASH", 
        Image = "rbxassetid://92362553672440", 
        Quote = "\"For many years, there has been lore circulating around John Doe and \226\150\136\226\150\136\226\150\136\226\150\136 Doe within the community.\" - Roblox", 
        Text = ("Cooldown: %*s\n"):format(v1.SlashCooldown) .. ("Damage: %*\n"):format(v1.SlashDamage) .. ("Windup: %*s\n"):format(v1.SlashWindup) .. ("Linger: %*s\n"):format(v1.SlashLinger) .. "Length: 7.5 studs\n" .. "<font color=\"rgb(248,217,109)\">John Doe</font> slashes infront of him using his claws.\n"
    }, 
    {
        Header = "CORRUPT ENERGY", 
        Image = "rbxassetid://83849304758564", 
        Quote = "\"This year, we\226\128\153ve decided that it\226\128\153s time to shed some light about these accounts.\" - Roblox", 
        Text = ("Cooldown: %*s\n"):format(v1.CorruptEnergyCooldown) .. ("Damage: %*\n"):format(v1.CorruptEnergyDamage) .. ("<font color=\"rgb(248,217,109)\">John Doe</font> punches his corrupted arm into the ground and, when he pulls it out, %* giant spikes (that last for %*s) emerge infront of him, piercing through any survivor unfortunate enough to be caught within them.\n"):format(v1.SpikeAmount, v1.SpikeLifetime) .. "Hitting a player with a spike gives <font color=\"rgb(248,217,109)\">John Doe</font> Speed I for 7 seconds.\n" .. ("Summoned spikes cannot damage the same target more than %* times.\n"):format(v1.SpikeHitCap) .. "Press Corrupt Energy again after the cast to Retract active spikes early. Retracting does not restart the original cooldown. These spikes can be used as blockades to prevent survivors from accessing certain areas.\n"
    }, 
    {
        Header = "DIGITAL FOOTPRINT", 
        Image = "rbxassetid://83206360003394", 
        Quote = "\"John Doe and \226\150\136\226\150\136\226\150\136\226\150\136 Doe are two of Roblox\226\128\153s earliest accounts, as seen by their low user IDs here.\" - Roblox", 
        Text = ("Cooldown: %*s\n"):format(v1.DigitalFootprintCooldown) .. "<font color=\"rgb(248,217,109)\">John Doe</font> stomps on the ground three times, commanding a shadow to emerge underneath his footsteps as a trap for survivors to walk over.\n" .. "If a survivor steps over the false shadow, then <font color=\"rgb(248,217,109)\">John Doe</font> gets a <b>Speed I</b> buff for 10 seconds and the survivor gets a <b>Corrupted I</b> & <b>Slowness II</b> debuff for 10 seconds.\n" .. "Upon the trap being triggered, <font color=\"rgb(248,217,109)\">John Doe</font> and the survivor who activated it have their auras revealed to each other for 10 seconds.\n" .. "The shadow despawns after contact is made with it or <font color=\"rgb(248,217,109)\">John Doe</font> attempts to place down a fourth shadow.\n" .. ("Digital Footprint is 30%% larger. There can only be <b>%*</b> shadows present at once, and attempting to create more will cause the oldest shadow to dissipate.\n"):format(v1.DigitalFootprintLimit)
    }, 
    {
        Header = "404 ERROR", 
        Image = "rbxassetid://131116145215571", 
        Quote = "\"Authentic John Doe and \226\150\136\226\150\136\226\150\136\226\150\136 Doe accounts pose no danger to your Roblox account.\" - Roblox", 
        Text = ("Cooldown: %*s\n"):format(v1["404ErrorCooldown"]) .. ("<font color=\"rgb(248,217,109)\">John Doe</font>'s corrupted arm pulsates twice, revealing the auras of all living survivors to him for %* seconds.\n"):format(v1["404ErrorAuraRevealTime"])
    }
};
-- Phase-one rig profiles. Current FCT animations and all balance values are retained.
v1.JohnDoeRigCollision=script.JohnDoeRigCollision
v1.JohnDoeRigQuery=script.JohnDoeRigQuery
v1.JohnDoeRigScale=script:GetAttribute("JohnDoeRigScale") or 1.25
v1.JohnDoeRigPhase="1.0.0"
v1.HipHeight=0
v1.CorruptEnergyPhase="1.0.0"
v1.JohnGameplayPhase="1.0.0"
v1.DigitalFootprintSizeMultiplier=1.3
v1.CorruptEnergyUnstoppableLinger=1.5
v1.UnstoppableSpeedBoostDuration=3
v1.UnstoppableNegativeStatusDurationMultiplier=.5
return v1;]========],before="11356:6ef0ee7a:cc954821",after="11390:0b9ed3dc:9693639b"},
{path=[========[
ReplicatedStorage/Modules/StatusEffects/Stunned]========],source=[========[
-- FCT lifecycle + UPD immunity timing. Existing combat damage behavior is preserved.
local RunService=game:GetService("RunService")
local Modules=game.ReplicatedStorage.Modules
local Actors=require(Modules.Actors)
local Util=require(Modules.Util)
local Rules=require(script.Rules)
local Stunned={Data={Duration=6,MaxLevel=1,IsNegative=true,Stackable=false,TimeStackable=false,Hidden=false}}
local function actorFor(status)
 return Actors.CurrentActors[status.Player] or Actors.CurrentActors[status.Character]
end
local function sound(actor,name)
 local id=actor and actor.Config and actor.Config.Sounds and actor.Config.Sounds[name]
 if id and actor.Rig and actor.Rig.PrimaryPart then require(Modules.Sounds):Play(id,{Parent=actor.Rig.PrimaryPart}) end
end
local function cancelOverride(status)
 local thread=status.UnstunThread;status.UnstunThread=nil
 if thread and thread~=coroutine.running() then pcall(task.cancel,thread) end
end
function Stunned.Applied(status)
 if RunService:IsClient() then
  local actor=actorFor(status)
  local animation=actor and actor.Animations and actor.Animations.Stunned
  local behavior=actor and actor.Behavior
  if behavior then
   local callback=status.Data.StunDuration and type(animation)=="table" and animation.Cancel and behavior.OnStunnedEnd or behavior.OnStunned
   if callback then callback(behavior,actor,status.Data.StunDuration) end
  end
  if animation then
   if typeof(animation)=="table" then
    if status.Data.StunDuration and animation.Cancel then animation.Cancel:Play(0)
    else
     if animation.Start then animation.Start:Play(0) end
     if animation.Loop then animation.Loop:Play(0) end
     status.StunnedAnims=animation
    end
   else animation:Play(0) end
  end
  if not status.SpeedMultiplier then status.SpeedMultiplier=Util:CreateSpeedMultiplier(status.Player,0,"Stunned") end
  return
 end
 local character=status.Character
 local actor=actorFor(status)
 -- Capture before Stunned attribute observers cancel the casting ability and clear its override.
 local override=actor and actor.Config and tonumber(actor.Config.StunDuration)
 if actor and actor.Behavior.GetStunOverride then override=actor.Behavior:GetStunOverride(actor) end
 if override and override>0 then status.Data.StunDuration=override end
 Util:GiveStackableAttribute(character,"StunnedDisabled","StunPort")
 character:SetAttribute("Stunned",true)
 if not actor then return end
 actor:DisableAbilities("Stunned",true)
 if actor.Behavior.OnStunned then actor.Behavior:OnStunned(actor,status.Data.StunDuration) end
 require(Modules.Sounds):PlayVoiceline(actor,"Stunned")
 sound(actor,"Stunned")
 override=override or (not actor.Behavior.GetStunOverride and tonumber(actor.Config.StunDuration) or nil)
 if override and override>0 then
  cancelOverride(status)
  status.UnstunThread=task.delay(override,function()
   status.UnstunThread=nil
   if not character.Parent or not character:GetAttribute("Stunned") then return end
   local statuses=require(Modules.Statuses)
   statuses:RemoveStatus(status.Player,"Stunned")
   local handled=actor.Behavior.OnUnstoppableBoost and actor.Behavior:OnUnstoppableBoost(actor)
   if not handled and not statuses:PlayerHasStatus(status.Player,"Speed") then statuses:ApplyStatus(status.Player,"Speed",{Level=1,Duration=3+Rules.CountSentinels(Actors.CurrentActors)}) end
   sound(actor,"StunEnded")
   if actor.Behavior.OnStunnedEnd then actor.Behavior:OnStunnedEnd(actor) end
  end)
  status.Data.StunDuration=override
 end
end
function Stunned.Removed(status)
 cancelOverride(status)
 if status.SpeedMultiplier then
  local multiplier=status.SpeedMultiplier;status.SpeedMultiplier=nil
  task.delay(status.StunnedAnims and status.StunnedAnims.End and .6 or .25,function()
   if multiplier.Parent then
    game.TweenService:Create(multiplier,TweenInfo.new(.75),{Value=1}):Play()
    game.Debris:AddItem(multiplier,.75)
   end
  end)
 end
 if status.StunnedAnims then
  for _,name in {"Start","Loop"} do if status.StunnedAnims[name] then status.StunnedAnims[name]:Stop() end end
  if status.StunnedAnims.End then status.StunnedAnims.End:Play() end
  status.StunnedAnims=nil
 end
 if RunService:IsServer() then
  local character=status.Character
  character:SetAttribute("Stunned",nil)
  local duration=Rules.Duration(Rules.CountSentinels(Actors.CurrentActors),status.Data.ResonanceDuration)
  -- Replacing this named source cancels the old timer; unrelated immunity sources survive expiry.
  local humanoid=character:FindFirstChildOfClass("Humanoid")
  if character.Parent and humanoid and humanoid.Health>0 then Util:GiveStackableAttribute(character,"StunnedDisabled","StunPort",duration)
  else Util:RemoveStackableAttribute(character,"StunnedDisabled","StunPort") end
  local actor=actorFor(status)
  if actor then actor:DisableAbilities("Stunned",false) end
 end
end
function Stunned.Heartbeat() end
return Stunned
]========],before="4368:96e7e0ab:a9c0801c",after="4883:64a0e3ce:8d9b1a17"},
{path=[========[
ReplicatedStorage/Modules/Statuses]========],source=[========[
local t1 = {
	CurrentStatuses = {},
	StatusCounts = {}
}
local ReplicatedStorage = game:GetService("ReplicatedStorage")

game:GetService("CollectionService")

local RunService = game:GetService("RunService")
local Network = require(game.ReplicatedStorage.Modules.Network)
local Sounds = require(game.ReplicatedStorage.Modules.Sounds)
local Util = require(game.ReplicatedStorage.Modules.Util)
local Signal = require(game.ReplicatedStorage.Modules.Misc.Signal)
local StatusEffects = game.ReplicatedStorage.Modules.StatusEffects

local function statusClient(target, ...)
	if typeof(target) == "Instance" and target:IsA("Player") then
		Network:FireClientConnection(target, ...)
	end
end

function t1.ApplyStatus(_: {[any]: any}, p1, s1: string, t3: {[any]: any}) -- line: 18
	-- upvalues: RunService (copy), t1 (copy), StatusEffects (copy), Util (copy), ReplicatedStorage (copy), Sounds (copy), Network (copy)
	assert(RunService:IsServer(), "Can only apply statuses on server.")

	if typeof(p1) ~= "Instance" then return end
	t3 = t3 or {}
	local v13 = p1:IsA("Model") and (game.Players:GetPlayerFromCharacter(p1) or p1) or p1
	local v14 = v13:IsA("Model") and v13 or v13:IsA("Player") and v13.Character
	if not v14 or not v14.Parent then return end

	t1.CurrentStatuses[v13] = t1.CurrentStatuses[v13] or {}

	local v15 = StatusEffects:FindFirstChild(tostring(s1), true)
	local v16 = v15 and require(v15)
	local v17 = t1.CurrentStatuses[v13][s1] ~= nil
	local v18 = t1.CurrentStatuses[v13][s1] or v16 and Util:CopyTable(v16)

	if v18 and v14 then
		local v19 = require(ReplicatedStorage.Modules.Actors).CurrentActors[v13]
        local incomingDurationScale=1
        if v19 and v19.Behavior and v19.Behavior.GetIncomingStatusDurationMultiplier then
            incomingDurationScale=v19.Behavior:GetIncomingStatusDurationMultiplier(v19,s1,v16 and v16.Data) or 1
            if incomingDurationScale~=1 or v18.JDIncomingScaled then
                t3=Util:CopyTable(t3 or {})
                t3.Duration=(tonumber(t3.Duration) or tonumber(v16 and v16.Data and v16.Data.Duration) or 10)*incomingDurationScale
            end
        end
		local v20 = v19 and v19.Config.StatusData

		if v20 and v20.ExcludeApplying and table.find(v20.ExcludeApplying, s1) then
			return
		end

		if v19 and v19.Behavior and v19.Behavior[`On{ s1 }Absolute`] then
			v19.Behavior[`On{ s1 }Absolute`](v19.Behavior, v19)
		end

		if v18.Level and t3 and t3.Level and t3.Level < v18.Level and not t3.Stackable then
			return
		end

		if v14:GetAttribute(`{ s1 }Disabled`) then
			return
		end

		for k, v in pairs(t3 or {}) do
			v18.Data[k] = v
		end

		if v19 then
			Sounds:PlayVoiceline(v19, `{ s1 }Status`, {
				Priority = 5
			})
		end


		if v17 then
			if v18.Data.TimeStackable == false then
				return
			end

			if t3.TimeStackable == false then
				return
			end

			v18.TimePast = 0
            if incomingDurationScale~=1 or v18.JDIncomingScaled then v18.TimeRequired=tonumber(v18.Data.Duration) or v18.TimeRequired end
            v18.JDIncomingScaled=incomingDurationScale~=1 or nil

			if v18.Data.Stackable then
				v18.Level = math.clamp(v18.Level + (t3 and t3.Level or 1), 1, v18.Data.MaxLevel or 99)
			elseif v18.Data.Level and v18.Data.Level > v18.Level then
				v18.Level = v18.Data.Level
			end

			if v18.Applied then
				v18:Applied()
			end

			statusClient(v13, "StatusUpdated", "REMOTE_EVENT", s1, {
				TimePast = 0,
				Level = v18.Level,
				Duration = v18.Data.Duration or v18.TimeRequired
			})

			if v19 and v19.Behavior and v19.Behavior[`On{ s1 }`] then
				v19.Behavior[`On{ s1 }`](v19.Behavior, v19)
			end

			return v18
		end

		v18.Player = v13
		v18.Character = v14
		v18.Level = v18.Data.Level or 1
		v18.AppliedFrom = t3.AppliedFrom or "None"
		v18.TimeRequired = tonumber(v18.Data.Duration) or 10
        v18.JDIncomingScaled=incomingDurationScale~=1 or nil
		v18.TimePast = 0

		local function __updateStatusData(t4: {[any]: any}) -- line: 128
			-- upvalues: v18 (copy), v19 (copy)
			if not t4 then
				return
			end

			if (t4.ExcludeIfAppliedFrom or "") == v18.AppliedFrom then
				return
			end

			local v62 = t4.TotalTimeMult or 0

			if v62 > 0 and v19 and v19.Hunting then
				v62 = if not v19.Hunting then v62 else 0.5
			end

			if v62 > 0 then
				local v63 = v18

				v63.TimeRequired = v63.TimeRequired * v62

				local Data = v18.Data

				Data.Duration = Data.Duration * v62
			end
		end

		if v20 and (v20.ExcludeIfAppliedFrom or "") ~= v18.AppliedFrom then
			local v27 = v20.TotalTimeMult or 0

			if v27 > 0 and v19 and v19.Hunting then
				v27 = if not v19.Hunting then v27 else 0.5
			end

			if v27 > 0 then
				v18.TimeRequired = v18.TimeRequired * v27

				local Data = v18.Data

				Data.Duration = Data.Duration * v27
			end
		end

		local PrimaryPart = v14.PrimaryPart

		if PrimaryPart and PrimaryPart.Parent then
			local v30 = Sounds:Play(v18.Data.SFX, {
				Looped = true,
				RollOffMinDistance = 16,
				RollOffMaxDistance = 48,
				Parent = PrimaryPart
			})

			if v30 then
				v30.Name = `{ s1 }StatusSFX`
				game.Debris:AddItem(v30, 30)
			end
		end

		t1.CurrentStatuses[v13][s1] = v18
		t1.StatusCounts[v13] = (t1.StatusCounts[v13] or 0) + 1
		if v18.Applied then v18:Applied() end
		if not t1.CurrentStatuses[v13] or t1.CurrentStatuses[v13][s1] ~= v18 then return end
		statusClient(v13, "StatusApplied", "REMOTE_EVENT", s1, v18, v18.Data)

		if v19 and v19.Behavior and v19.Behavior[`On{ s1 }`] then
			v19.Behavior[`On{ s1 }`](v19.Behavior, v19)
		end

		if t1:GetStatusCount(v13) >= 4 then
			require(ReplicatedStorage.Modules.AchievementUtil):IncrementAchievementProgress(v13, "LotsaStatuses")
		end

		t1.StatusApplied:Fire(v13, s1, v18, v17)

		return v18
	end
end
function t1.RemoveStatus(_, p3, p4) -- line: 186
	-- upvalues: t1 (copy), Network (copy), ReplicatedStorage (copy)
	if p3 and p3:IsA("Model") then
		p3 = game.Players:GetPlayerFromCharacter(p3) or p3
	end

	local v34 = t1.CurrentStatuses[p3] and t1.CurrentStatuses[p3][p4]

	if v34 then
		t1.CurrentStatuses[p3][p4] = nil
		t1.StatusCounts[p3] = math.max((t1.StatusCounts[p3] or 1) - 1, 0)
		if v34.Removed then
			v34:Removed()
		end

		statusClient(p3, "StatusRemoved", "REMOTE_EVENT", p4)

		local v35 = p3:IsA("Player") and p3.Character or p3
		local v36 = v35 and v35:FindFirstChild(`{ p4 }StatusSFX`, true)

		if v36 then
			game.Debris:AddItem(v36, 0.25)
			game.TweenService:Create(v36, TweenInfo.new(0.25), {
				Volume = 0
			}):Play()
		end

		local v37 = require(ReplicatedStorage.Modules.Actors).CurrentActors[p3]

		if v37 and v37.Behavior and v37.Behavior[`{ p4 }Ended`] then
			v37.Behavior[`{ p4 }Ended`](v37.Behavior, v37)
		end

	end

	if t1.CurrentStatuses[p3] and next(t1.CurrentStatuses[p3]) == nil then
		table.clear(t1.CurrentStatuses[p3])
		t1.CurrentStatuses[p3] = nil
		t1.StatusCounts[p3] = nil
	end
end
function t1.RemoveStatuses(_, p6, _) -- line: 230
	-- upvalues: t1 (copy)
	if p6 and p6:IsA("Model") then
		p6 = game.Players:GetPlayerFromCharacter(p6) or p6
	end

	for k, _ in pairs(t1.CurrentStatuses[p6] or {}) do
		t1:RemoveStatus(p6, k)
	end

	t1.CurrentStatuses[p6] = nil
	t1.StatusCounts[p6] = nil
end
function t1.GetStatusCount(_, p9) -- line: 246
	-- upvalues: t1 (copy)
	return t1.StatusCounts[p9] or -1
end
function t1.PlayerHasStatus(_, p11, p12) -- line: 250
	-- upvalues: t1 (copy)
	if typeof(p11) ~= "Instance" then return nil end
	local v48 = p11:IsA("Model") and (game.Players:GetPlayerFromCharacter(p11) or p11) or p11

	return t1.CurrentStatuses[v48] and t1.CurrentStatuses[v48][p12]
end
function t1.Start(_) -- line: 255
	-- upvalues: RunService (copy), Util (copy), t1 (copy), StatusEffects (copy), Network (copy)
	if RunService:IsServer() then
		Util.OnCharacterAdded(function(_, p15) -- line: 259
			-- upvalues: t1 (copy)
			t1:RemoveStatuses(p15)
		end)
		game.Players.PlayerRemoving:Connect(function(player) -- line: 264
			-- upvalues: t1 (copy)
			t1:RemoveStatuses(player)
		end)
		RunService.Heartbeat:Connect(function(dt: number) -- line: 268
			-- upvalues: t1 (copy)
			for v69, v70 in t1.CurrentStatuses do
				for v71, v72 in v70 do
					v72.TimePast = v72.TimePast + dt

					if not v69.Parent or not v72.Character.Parent or v72.TimePast >= v72.TimeRequired then
						t1:RemoveStatus(v69, v71)
					elseif v72.Heartbeat then
						v72:Heartbeat(dt)
					end
				end
			end
		end)
	elseif RunService:IsClient() then
		local LocalPlayer = game.Players.LocalPlayer
		local clone = script.StatusContainer:Clone()

		clone.Parent = LocalPlayer.PlayerGui.MainUI
		t1.CurrentStatuses[LocalPlayer] = {}

		local v52 = t1.CurrentStatuses[LocalPlayer]

		local function onStatusApplied(s2: string, t5: {[any]: any}, t6: {[any]: any}) -- line: 298
			-- upvalues: v52 (copy), LocalPlayer (copy), StatusEffects (copy), Util (copy), clone (copy), t1 (copy)
			local Level = t5.Level
			local Duration = t6.Duration
			local Icon = t6.Icon
			local Hidden = t6.Hidden

			if v52[s2] then
				local v80 = v52[s2]

				v80.TimePast = 0
				v80.TimeRequired = Duration
				v80.Level = Level
				v80.CurrentTimeDisplay = 123456789

				if v80.Info.Applied then
					v80.Info:Applied()
				end
			else
				local t7 = {
					TimePast = 0,
					TimeRequired = Duration,
					Level = Level,
					Player = LocalPlayer,
					Character = LocalPlayer.Character,
					Data = t6
				}
				local s2_2 = StatusEffects:FindFirstChild(s2, true)
				local v83 = Util:CopyTable(require(s2_2))

				v83.__index = v83
				t7.Info = setmetatable(t7, v83)

				if t7.Info.Applied then
					t7.Info:Applied()
				end

				t7.UI = script.StatusDisplay:Clone()
				t7.UI.Name = s2
				t7.UI.Timer.Text = Util:FormatTime(math.round(t7.TimeRequired - t7.TimePast), "Clock")
				t7.UI.Title.Text = `{ s2 } { Util:IntToRoman(t7.Level) }`
				t7.UI.IconHolder.Icon.Image = Icon or ""
				t7.UI.Visible = not Hidden
				t7.UI.Parent = clone
				v52[s2] = t7
			end

			t1.StatusApplied:FireDeferred(LocalPlayer, s2, t6, false)
		end
		local function onStatusUpdated(s3: string, t8: {[any]: any}) -- line: 345
			-- upvalues: v52 (copy), Util (copy), t1 (copy), LocalPlayer (copy)
			local v86 = v52[s3]

			if not v86 or not v86.UI then
				return
			end

			v86.TimePast = t8.TimePast or 0
			v86.TimeRequired = t8.Duration or v86.TimeRequired
			v86.Level = t8.Level or v86.Level
			v86.CurrentTimeDisplay = 123456789
			v86.UI.Timer.Text = Util:FormatTime(v86.CurrentTimeDisplay, "Clock")
			v86.UI.Title.Text = `{ s3 } { Util:IntToRoman(v86.Level) }`

			if v86.Info.Applied then
				v86.Info:Applied()
			end

			t1.StatusApplied:FireDeferred(LocalPlayer, s3, t8, true)
		end
		local function onStatusRemoved(s4: string) -- line: 368
			-- upvalues: v52 (copy)
			local v88 = v52[s4]

			if v88 then
				if v88.Info.Removed then
					v88.Info:Removed()
				end

				v88.UI:Destroy()
				v52[s4] = nil
			end
		end
		local function update(n1: number) -- line: 378
			-- upvalues: v52 (copy), Util (copy)
			for k, v in pairs(v52) do
				v.TimePast = v.TimePast + n1

				if v.Info.Heartbeat then
					v.Info:Heartbeat(n1)
				end

				local v92 = math.ceil(v.TimeRequired - v.TimePast)

				if v92 ~= v.CurrentTimeDisplay then
					v.CurrentTimeDisplay = v92
					task.defer(function() -- line: 388
						-- upvalues: v (copy), Util (copy), k (copy)
						if not v.UI or not v.UI.Parent then
							return
						end

						v.UI.Timer.Text = Util:FormatTime(v.CurrentTimeDisplay, "Clock")
						v.UI.Title.Text = `{ k } { Util:IntToRoman(v.Level) }`
					end)
				end

				if v.TimePast >= v.TimeRequired then
					if v.Info.Removed then
						v.Info:Removed()
					end

					if v.UI and v.UI.Parent then
						v.UI:Destroy()
					end

					v52[k] = nil
				end
			end
		end
		local function reset() -- line: 410
			-- upvalues: v52 (copy)
			for k, _ in pairs(v52) do
				local v95 = v52[k]

				if v95 then
					if v95.Info.Removed then
						v95.Info:Removed()
					end

					v95.UI:Destroy()
					v52[k] = nil
				end
			end
		end

		Network:SetConnection("StatusApplied", "REMOTE_EVENT", onStatusApplied)
		Network:SetConnection("StatusUpdated", "REMOTE_EVENT", onStatusUpdated)
		Network:SetConnection("StatusRemoved", "REMOTE_EVENT", onStatusRemoved)
		RunService.Heartbeat:Connect(update)
		LocalPlayer.CharacterAdded:Connect(reset)
	end

	for _, descendant in ipairs(StatusEffects:GetDescendants()) do
		if descendant:IsA("ModuleScript") and not descendant:HasTag("CannotInit") then
			local lib = require(descendant)

			if lib.Init then
				lib:Init()
			end
		end
	end
end

t1.StatusApplied = Signal.new()

return t1

]========],before="11813:edbe6e36:fe6f5039",after="12591:169b80f9:fc296a20"},
{path=[========[
ServerStorage/Assets/Killers/JohnDoe/Behavior]========],source=[========[
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
                    local _ = v7:CreateHitbox(v17.Player, {
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
return v1;]========],before="44564:ac97cd7c:af3f452f",after="44697:d614f8bf:b51a8412"},
{path=[========[
ServerStorage/Assets/Killers/JohnDoe/Behavior/CorruptEnergyController/Server]========],source=[========[
local RunService=game:GetService("RunService")
local TweenService=game:GetService("TweenService")
local Debris=game:GetService("Debris")
local Modules=game.ReplicatedStorage.Modules
local Hitboxes=require(Modules.Hitboxes)
local Network=require(Modules.Network)
local Util=require(Modules.Util)
local Sounds=require(Modules.Sounds)
local Statuses=require(Modules.Statuses)
local Actors=require(Modules.Actors)
local Rules=require(script.Parent.Rules)
local Unstoppable=require(script.Parent.Parent.Unstoppable)
local Server={}
local function alive(a)
 local hum=a.Rig and a.Rig:FindFirstChildOfClass("Humanoid")
 return not a.JDCEDestroyed and a.Rig and a.Rig.Parent and a.Rig.PrimaryPart and hum and hum.Health>0
end
local function blocked(a)
 local r=a.Rig
 return r:GetAttribute("Stunned") or r:GetAttribute("Helpless") or r:GetAttribute("Ragdolling") or r:GetAttribute("AbilitiesDisabled") or r.PrimaryPart.Anchored
end
local function broadcast(a,kind,data)
 Network:FireAllClientConnection(a.Player.Name..kind,"REMOTE_EVENT",data)
end
local function sound(a,name,parent)
 local id=a.Config.Sounds and a.Config.Sounds[name]
 if id and parent then pcall(Sounds.Play,Sounds,id,{Parent=parent,Volume=.4}) end
end
function Server.CanRetract(a)
 local c=a.JDCECast
 return c and c.active and not c.casting and c.live>0 or false
end
local function refresh(a)
 if a.Rig and a.Rig.Parent then a.Rig:SetAttribute("JDCanRetract",Server.CanRetract(a)) end
end
local function release(a,c)
 if not c.casting then return end
 c.casting=false
 Unstoppable.EndCorrupt(a,c.interrupted or not c.active)
 if c.slow then c.slow:Destroy();c.slow=nil end
 a.AbilityDisablers.JohnCorruptEnergy=nil
 if a.CurrentAbility=="CorruptEnergy" then a.CurrentAbility=nil;a.Config.StunDuration=c.previousStunDuration end
 refresh(a)
end
local function removeSpike(a,c,s,immediate)
 if not s.live then return end
 s.live=false;c.live-=1
 if s.hitbox and s.hitbox.Cancel then s.hitbox:Cancel() end
 if s.rise then s.rise:Cancel() end
 local index=table.find(a.CurrentSpikes,s.part)
 if index then table.remove(a.CurrentSpikes,index) end
 broadcast(a,"DesummonSpike",s.id)
 if s.part.Parent then
  s.part.CanCollide=false;s.part.CanTouch=false
  if immediate then s.part:Destroy()
  else
   TweenService:Create(s.part,TweenInfo.new(1,Enum.EasingStyle.Quad,Enum.EasingDirection.In),{CFrame=s.part.CFrame-Vector3.new(0,a.Config.SpikeHitboxSize.Y*2,0)}):Play()
   Debris:AddItem(s.part,1.05)
  end
 end
 refresh(a)
end
local function clear(a,immediate)
 local c=a.JDCECast
 if not c then return end
 c.active=false;release(a,c)
 for _,s in ipairs(c.spikes) do removeSpike(a,c,s,immediate) end
 a.JDCECast=nil;refresh(a)
end
local function reward(a,target)
 local hum=target:FindFirstChildOfClass("Humanoid")
 if not hum then return end
 if hum.Health>0 then
  Util:CreateSpeedMultiplier(target,1.5,"HitSpeedBonus",1.25)
  Statuses:ApplyStatus(a.Rig,"Speed",{Level=1,Duration=7})
  Util:RevealPlayerAuraTo(a.Player,target,2.5)
 end
 if target.Parent and target.Parent.Name=="Survivors" then
  Actors:IncrementActorStats(a.Player,{Action=hum.Health<=0 and "Killed a Survivor with Corrupt Energy" or "Damaged a Survivor with Corrupt Energy",RewardType=hum.Health<=0 and "DifficultKillerAction" or "EasyKillerAction"})
 end
 if hum.Health<=0 then
  local achievement=require(Modules.AchievementUtil)
  achievement:IncrementAchievementProgress(a.Player,"JohnDoeSpikes")
 end
end
local function spawnSpike(a,c,index,now)
 if not c.active or c.interrupted or not alive(a) then return end
 local params=RaycastParams.new();params.FilterType=Enum.RaycastFilterType.Exclude;params.FilterDescendantsInstances={workspace.Players}
 local point=(a:GetPivot()*CFrame.new(0,0,-a.Config.DistanceBetweenSpikes*index)).Position
 local hit=workspace:Raycast(point,Vector3.new(0,-100,0),params) or workspace:Raycast(point,Vector3.new(0,100,0),params)
 if not hit then return end
 local size=a.Config.SpikeHitboxSize
 local rotation=math.random(0,360)
 local data={Position=hit.Position,Rotation=rotation,SpikeUUID=tostring(c.serial)..":"..index}
 local part=Instance.new("Part");part.Name="SpikeCollision";part.Size=size;part.Transparency=1
 part.Anchored=true;part.CanTouch=false;part.CanCollide=true;part.CustomPhysicalProperties=a.Config.SpikeProperties
 local from=CFrame.new(hit.Position)*CFrame.Angles(0,math.rad(rotation),math.pi/2)-Vector3.new(0,size.Y,0)
 part.CFrame=from;part.Parent=workspace.Map.Ingame
 local s={part=part,id=data.SpikeUUID,live=true,expires=now+a.Config.SpikeLifetime}
 table.insert(c.spikes,s);table.insert(a.CurrentSpikes,part);c.live+=1
 s.rise=TweenService:Create(part,TweenInfo.new(.1,Enum.EasingStyle.Linear),{CFrame=from+Vector3.new(0,size.Y*2,0)})
 s.rise:Play();broadcast(a,"SpawnSpike",data)
 s.hitbox=Hitboxes:CreateHitbox(a.Player,{
  AbilityType="CorruptEnergy",IsProjectile=false,Size=size,CFrame=function()return part.CFrame end,
  Damage=a.Config.CorruptEnergyDamage,Time=.15,Knockback=5,HitMultiple=true,PredictVelocity=false,CastPoint=false,
  -- Reject before damage, block reactions, knockback, or hit callbacks. Reservation is atomic across spikes.
  HitFilter=function(target)
   return s.live and alive(a) and Rules.ReserveHit(c,target,a.Config.SpikeHitCap)
  end,
  Connections={Hit=function(target,first)
   reward(a,target)
   if first then sound(a,"Hit",a.Rig.PrimaryPart) end
  end}
 })
 refresh(a)
end
local function step(a)
 if not alive(a) then Server.Destroyed(a);return end
 local c=a.JDCECast
 if not c then return end
 local now=os.clock()
 if c.casting then
  if blocked(a) then c.interrupted=true;release(a,c)
  else
   while c.next<=a.Config.SpikeAmount and now-c.started>=Rules.SpawnAt(c.next,a.Config.DelayBetweenSpikeSummons) do
    local index=c.next;c.next+=1;spawnSpike(a,c,index,now)
   end
   if now-c.started>=math.max(3.5,Rules.SpawnAt(a.Config.SpikeAmount,a.Config.DelayBetweenSpikeSummons)+.1) then release(a,c) end
  end
 end
 for _,s in ipairs(c.spikes) do if s.live and (not s.part.Parent or now>=s.expires) then removeSpike(a,c,s,not s.part.Parent) end end
 if not c.casting and c.live==0 then c.active=false;a.JDCECast=nil;refresh(a) end
end
function Server.Cast(a)
 if not alive(a) or blocked(a) then return {Cancelled=true} end
 if Server.CanRetract(a) then clear(a,false);return {Retract=true,Cooldown=0} end
 if a.JDCECast and a.JDCECast.casting then return {Cancelled=true} end
 clear(a,true)
 a.JDCESerial=(a.JDCESerial or 0)+1
 local c={serial=a.JDCESerial,active=true,casting=true,started=os.clock(),next=1,live=0,spikes={},hits={},previousStunDuration=a.Config.StunDuration}
 a.JDCECast=c;Unstoppable.BeginCorrupt(a);a.AbilityDisablers=a.AbilityDisablers or {};a.AbilityDisablers.JohnCorruptEnergy=true
 a.CurrentAbility="CorruptEnergy";a.Config.StunDuration=a.Config.UnstoppableDuration
 c.slow=Util:CreateSpeedMultiplier(a.Player,.001,"JohnCorruptEnergyCast")
 sound(a,"CorruptEnergy",a.Rig.PrimaryPart);refresh(a)
 return {Retract=false}
end
function Server.Created(a)
 a.JDCEDestroyed=false;a.JDCEConnections={};a.CurrentSpikes=a.CurrentSpikes or {}
 local original=a.CanUseAbility;a.JDCEOriginalCanUse=original
 local function canUse(self,name)
  if name~="CorruptEnergy" or not Server.CanRetract(a) then return original(self,name) end
  -- Keep every ordinary lock/check; bypass only this actor's existing CE cooldown for Retract.
  local cooldown=a.Cooldowns.CorruptEnergy;a.Cooldowns.CorruptEnergy=nil
  local ok,result=pcall(original,self,name)
  a.Cooldowns.CorruptEnergy=cooldown
  if not ok then error(result) end
  return result
 end
 a.CanUseAbility=canUse;a.JDCECanUseWrapper=canUse
 table.insert(a.JDCEConnections,RunService.Heartbeat:Connect(function()step(a)end))
 table.insert(a.JDCEConnections,a.Rig:GetAttributeChangedSignal("Stunned"):Connect(function()
  if a.Rig:GetAttribute("Stunned") and a.JDCECast and a.JDCECast.casting then a.JDCECast.interrupted=true;release(a,a.JDCECast) end
 end))
 table.insert(a.JDCEConnections,a.Rig:FindFirstChildOfClass("Humanoid").Died:Connect(function()Server.Destroyed(a)end))
 refresh(a)
end
function Server.Destroyed(a)
 if a.JDCEDestroyed then return end
 a.JDCEDestroyed=true;clear(a,true)
 for _,connection in ipairs(a.JDCEConnections or {}) do connection:Disconnect() end
 a.JDCEConnections={}
 if a.CanUseAbility==a.JDCECanUseWrapper then a.CanUseAbility=a.JDCEOriginalCanUse end
end
return Server
]========],before="8256:bef18f60:1b128a83",after="8401:3a023998:9a3699a1"},
{path=[========[
ServerStorage/Assets/Killers/JohnDoe/Behavior/RigAlignment]========],source=[========[
-- Phase-one geometry only. No attack reach, cooldown, damage or status balance changes.
local Alignment={}
function Alignment.IsUpdated(rig) return rig:GetAttribute("JohnDoeRigPhase")=="1.0.0" end
function Alignment.GroundHeight(rig)
 local hum=rig:FindFirstChildOfClass("Humanoid")
 local root=rig.PrimaryPart
 local leg=rig:FindFirstChild("Left Leg") or rig:FindFirstChild("Right Leg")
 return (hum and hum.HipHeight or 0)+(root and root.Size.Y/2 or 1)+(leg and leg.Size.Y or 2)
end
function Alignment.GroundPoint(rig)
 local root=rig.PrimaryPart
 local params=RaycastParams.new()
 params.FilterType=Enum.RaycastFilterType.Exclude
 params.FilterDescendantsInstances={workspace:FindFirstChild("Players") or rig,rig}
 params.RespectCanCollide=true
 local hit=workspace:Raycast(root.Position,Vector3.new(0,-Alignment.GroundHeight(rig)-8,0),params)
 return hit and hit.Position+Vector3.new(0,.03,0) or root.Position-Vector3.new(0,Alignment.GroundHeight(rig),0)
end
function Alignment.TrailPoint(actor,initial)
 if Alignment.IsUpdated(actor.Rig) then return Alignment.GroundPoint(actor.Rig) end
 return actor.Rig.PrimaryPart.Position-Vector3.new(0,initial and 4.5 or 3,0)
end
function Alignment.SlashOffset(actor)
 local y=Alignment.IsUpdated(actor.Rig) and 3-Alignment.GroundHeight(actor.Rig) or 0
 return CFrame.new(0,y,-2.25)
end
function Alignment.GetRig(actor)
 if not actor.SkinFolder then
  actor.Config.CollisionHitbox=actor.Config.JohnDoeRigCollision
  actor.Config.QueryHitbox=actor.Config.JohnDoeRigQuery
 end
 return actor.Rig:Clone()
end
return Alignment
]========],before="1566:d24c3da8:4e8231d7",after="1566:3186c8e4:e95d3353"},
{path=[========[
ServerStorage/Assets/Killers/JohnDoe/Behavior/Unstoppable]========],source=[========[
-- John-specific Unstoppable windows. Never changes other actors' status durations.
local RunService=game:GetService("RunService")
local Actors=require(game.ReplicatedStorage.Modules.Actors)
local Statuses=require(game.ReplicatedStorage.Modules.Statuses)
local Network=require(game.ReplicatedStorage.Modules.Network)
local Controller={}
local legacyNegative={Glitched=true,Glitch=true,GlitchedOld=true,Slowness=true,Bleeding=true,Burning=true,Nausea=true,Blindness=true,Oblivious=true,Poisoned=true,PoisonedThatKillsYou=true,Helpless=true,Weakness=true,Vulnerable=true,Confusion=true,Hemmorhage=true,Hacked=true,Corrupted=true,Hallucination=true,Marked=true,Resonance=true,Atropa=true,Subspaced=true,Fatigue=true,Exhausted=true,Stunned=true,Creatures=true}
local function alive(a)
 local hum=a.Rig and a.Rig:FindFirstChildOfClass("Humanoid")
 return not a.JDUnstoppableDestroyed and a.Rig and a.Rig.Parent and hum and hum.Health>0
end
local function speed(a) return Statuses:PlayerHasStatus(a.Player,"Speed") end
local function sentinelCount()
 local n,seen=0,{}
 for _,actor in pairs(Actors.CurrentActors) do
  local rig=actor.Rig;local hum=rig and rig:FindFirstChildOfClass("Humanoid")
  if actor.Config and actor.Config.Class=="Sentinel" and rig and rig.Parent and rig.Parent.Name~="Spectating" and hum and hum.Health>0 and not seen[rig] then n+=1;seen[rig]=true end
 end
 return n
end
function Controller.BeginCorrupt(a)
 if a.JDUnstoppableDestroyed then return end
 a.JDCorruptCasting=true;a.JDCorruptWindowUntil=nil
end
function Controller.EndCorrupt(a,cancelled)
 a.JDCorruptCasting=nil
 if a.JDUnstoppableDestroyed then a.JDCorruptWindowUntil=nil;return end
 a.JDCorruptWindowUntil=not cancelled and os.clock()+(a.Config.CorruptEnergyUnstoppableLinger or 1.5) or nil
end
function Controller.GetOverride(a)
 if not alive(a) then return end
 local ability
 if a.CurrentAbility=="404Error" and a.Config.StunDuration then ability="404Error"
 elseif a.JDCorruptCasting or os.clock()<(a.JDCorruptWindowUntil or 0) then ability="CorruptEnergy" end
 a.JDUnstoppableTriggerAbility=ability
 if ability then return a.Config.UnstoppableDuration or 2 end
end
function Controller.OnStunned(a,override)
 local ability=a.JDUnstoppableTriggerAbility;a.JDUnstoppableTriggerAbility=nil
 if not override or not ability or not alive(a) then return end
 a.JDUnstoppablePending=true
 local remaining=a:IsOnCooldown(ability)
 local base=a.Config[ability.."Cooldown"]
 if type(remaining)=="number" and type(base)=="number" then a:SetCooldownOf(ability,math.min(remaining,base*.5)) end
end
local function ensureSpeed(a,remaining)
 local current=speed(a)
 if not current then
  Statuses:ApplyStatus(a.Player,"Speed",{Level=1,Duration=remaining,AppliedFrom="JohnDoeUnstoppable"})
 elseif (current.Level or 1)==1 then
  -- Preserve a longer existing Speed I; extend a shorter one without shortening its remainder.
  local oldRemaining=math.max(0,(current.TimeRequired or current.Data.Duration or 0)-(current.TimePast or 0))
  if oldRemaining<remaining then
   current.TimeRequired=(current.TimePast or 0)+remaining;current.Data.Duration=current.TimeRequired
   Network:FireClientConnection(a.Player,"StatusUpdated","REMOTE_EVENT","Speed",{TimePast=current.TimePast or 0,Level=current.Level,Duration=current.TimeRequired})
  end
 end
end
function Controller.Boost(a)
 if not a.JDUnstoppablePending then return false end
 a.JDUnstoppablePending=nil
 if not alive(a) then return true end
 local duration=(a.Config.UnstoppableSpeedBoostDuration or 3)+sentinelCount()
 a.JDUnstoppableProtectionUntil=os.clock()+duration
 ensureSpeed(a,duration)
 return true
end
function Controller.DurationMultiplier(a,name,data)
 if not alive(a) or os.clock()>=(a.JDUnstoppableProtectionUntil or 0) or not speed(a) then return 1 end
 local negative=data and data.IsNegative
 if negative==nil then negative=legacyNegative[name] end
 return negative and (a.Config.UnstoppableNegativeStatusDurationMultiplier or .5) or 1
end
function Controller.Created(a)
 if not RunService:IsServer() then return end
 a.JDUnstoppableDestroyed=false
 a.JDUnstoppableHeartbeat=RunService.Heartbeat:Connect(function()
  local remaining=(a.JDUnstoppableProtectionUntil or 0)-os.clock()
  if remaining>0 and alive(a) then ensureSpeed(a,remaining)
  elseif remaining<=0 then a.JDUnstoppableProtectionUntil=nil end
 end)
end
function Controller.Destroyed(a)
 a.JDUnstoppableDestroyed=true
 if a.JDUnstoppableHeartbeat then a.JDUnstoppableHeartbeat:Disconnect();a.JDUnstoppableHeartbeat=nil end
 a.JDCorruptCasting=nil;a.JDCorruptWindowUntil=nil;a.JDUnstoppableProtectionUntil=nil;a.JDUnstoppablePending=nil;a.JDUnstoppableTriggerAbility=nil
end
return Controller
]========],before=false,after="4697:821a22d8:8c2fcadb"},
{path=[========[
ServerStorage/Assets/Killers/JohnDoe/Config]========],source=[========[
-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local l_workspace_Attribute_0 = workspace:GetAttribute("JohnDoeSpecialDay");
local v1 = {
    DisplayName = "John Doe", 
    Quote = l_workspace_Attribute_0 and "dude i told you not to play on march 18th" or "DON'T PLAY ROBLOX ON MARCH 18TH?!?!", 
    Credits = "c2o, BakedMesh, koekonaut, 89M and BirdieCandles", 
    RenderImage = l_workspace_Attribute_0 and "rbxassetid://125927083463034" or "rbxassetid://106220250803658", 
    Price = l_workspace_Attribute_0 and 318 or 1000, 
    Health = l_workspace_Attribute_0 and 3182026 or 2300, 
    Speed = l_workspace_Attribute_0 and 11.3182026 or 9, 
    IntroText = "They're all yours, Mr. Doe", 
    SprintSpeed = l_workspace_Attribute_0 and 27.53182026 or 27.25, 
    StaminaLoss = 9.5, 
    StaminaGain = 21, 
    MaxStamina = l_workspace_Attribute_0 and 115.3182026 or 110, 
    SlashDamage = l_workspace_Attribute_0 and 45.3182026 or 28, 
    SlashCooldown = l_workspace_Attribute_0 and 2.3182026 or 1.75, 
    SlashWindup = 0.35, 
    SlashLinger = 0.25, 
    CorruptEnergyDamage = l_workspace_Attribute_0 and 16.3182026 or 11, 
    CorruptEnergyCooldown = l_workspace_Attribute_0 and 40.3182026 or 18, 
    SpikeAmount = l_workspace_Attribute_0 and 256 or 31, 
    SpikeHitboxSize = Vector3.new(11, 5, 5, 0), 
    SpikeLifetime = l_workspace_Attribute_0 and 18.3182026 or 14, 
    SpikeHitCap = l_workspace_Attribute_0 and 3182026 or 2, 
    SpikeProperties = PhysicalProperties.new(0.2, 2, 0, 100, 100), 
    DelayBetweenSpikeSummons = l_workspace_Attribute_0 and 0.02 or 0.045, 
    DistanceBetweenSpikes = 4, 
    DigitalFootprintCooldown = 3, 
    DigitalFootprintLimit = l_workspace_Attribute_0 and 4 or 3, 
    ["404ErrorAuraRevealTime"] = l_workspace_Attribute_0 and 10.3182026 or 6, 
    ["404ErrorCooldown"] = 20, 
    Spike = script.Spike, 
    Shadow = script.Shadow, 
    Trail = script.Trail, 
    SpikeNumbersColor = Color3.fromRGB(255, 0, 0), 
    TrailLength = l_workspace_Attribute_0 and 356 or 52, 
    UnstoppableDuration = 2, 
    SilencedTemplate = script.NAN, 
    Silenced = true, 
    OutroDummy = script.OutroVictim, 
    useClouds = true, 
    Relations = {
        "JaneDoe"
    }, 
    LastManStandingEmotionalData = {
        ThemeID = "rbxassetid://90004798416076", 
        RoundTime = 99
    }, 
    LastManStandingData = {
        ThemeID = "rbxassetid://128206924329556", 
        ThemeProperties = {
            Volume = 1.8
        }, 
        RoundTime = 75
    }, 
    Animations = {
        Idle = "rbxassetid://78316360457839", 
        Walk = "rbxassetid://76406790148345", 
        Run = "rbxassetid://75860288793447", 
        InjuredIdle = "rbxassetid://78316360457839", 
        InjuredWalk = "rbxassetid://76406790148345", 
        InjuredRun = "rbxassetid://75860288793447", 
        Stunned = {
            Start = "rbxassetid://138679230786776", 
            Loop = "rbxassetid://70827891324537", 
            End = "rbxassetid://74361242843808", 
            Cancel = "rbxassetid://132248641730444"
        }, 
        Execution = {
            KillerRig = "rbxassetid://83976183793168", 
            PlayerRig = "rbxassetid://128883910284038", 
            PlayerCFrameOffset = CFrame.Angles(0, 3.141592653589793, 0) * CFrame.new(0, 0, 3)
        }, 
        ExecutionJaneDoe = {
            KillerRig = "rbxassetid://113867319138589", 
            PlayerRig = "rbxassetid://110119432571584"
        }, 
        Slash = "rbxassetid://115517017692371", 
        CorruptEnergy = "rbxassetid://98447162219573", 
        DigitalFootprint = "rbxassetid://105781326773024", 
        Introduction = {
            KillerRig = "rbxassetid://119476049603730", 
            CameraRig = "rbxassetid://140634358360682"
        }, 
        Victory = {
            KillerRig = "rbxassetid://103715079223416", 
            CameraRig = "rbxassetid://98794271647444"
        }
    }, 
	Sounds = {
		Ambience = "rbxassetid://94207556272752",
		Footsteps = {
			"rbxassetid://86542629849582",
			"rbxassetid://122149641699340"
		},
		TerrorRadiusThemes = {
			[60] = {
				ID = "rbxassetid://87108568049500",
				BPM = 100
			},
			[40] = {
				ID = "rbxassetid://112183456126257",
				BPM = 100
			},
			[20] = {
				ID = "rbxassetid://110315081858949",
				BPM = 100
			},
			[6] = {
				ID = "rbxassetid://90755511989120",
				BPM = 100,
				Chase = true
			}
		},
		Execution = "rbxassetid://91088178573563",
		ExecutionJaneDoe = "rbxassetid://80688333799111",
		StunEnded = "rbxassetid://127453218558340",
		Swing = "rbxassetid://140242176732868",
		Hit = "rbxassetid://90819435118493",
		CorruptEnergy = "rbxassetid://109525294317144",
		CorruptEnergySummon = "rbxassetid://111388466508150",
		CorruptEnergyDesummon = "rbxassetid://112806895489970",
		PuddleStepped = "rbxassetid://100270933047659",
		DigitalFootprint = "rbxassetid://114243439622992",
		DigitalFootprintAmbience = "rbxassetid://140163779889034",
		["404Error"] = "rbxassetid://125897321587591",
		["404ErrorError"] = "rbxassetid://90307135163105",
		Introduction = "rbxassetid://79031693606570",
		VictoryTheme = "rbxassetid://122795850954647"
	}
};
v1.Information = {
    {
        Separator = "GENERAL INFO"
    }, 
    {
        Header = "JOHN DOE", 
        Text = "The defunct code of the early days of Roblox courses through their body, consuming his mind as he now only focuses on one thing: to kill everyone in his path. An unstoppable force entering the round with a strategical mindset, he's able to set traps, summon walls to back survivors into a corner, and leave behind a faint trail that damages those who step on it.\n"
    }, 
    {
        Header = "STATS", 
        Text = "Difficulty: \226\152\133\226\152\133\226\152\133\226\152\133\226\152\133\n" .. ("Health: %*\n"):format(v1.Health) .. ("Regular Speed: %*\n"):format(v1.Speed) .. ("Sprinting Speed: %*\n"):format(v1.SprintSpeed) .. ("Max Stamina: %*\n"):format(v1.MaxStamina) .. ("Stamina Loss per sec: %*\n"):format(v1.StaminaLoss) .. ("Stamina Gain per sec: %*\n"):format(v1.StaminaGain) .. "Terror Radius: 60 studs\n"
    }, 
    {
        Separator = "PASSIVES"
    }, 
    {
        Header = "NATURAL MALEVOLENCE", 
        Quote = "\"We\226\128\153re dedicated to building a fun, safe environment where kids of all ages can power their imagination on Roblox.\" - Roblox", 
        Text = "For every step that <font color=\"rgb(248,217,109)\">John Doe</font> takes, a trail of corruption follows behind him.\nAny survivor that's unfortunate enough to step within the corruption is given <b>Corrupted II</b> for 3 seconds.\n"
    }, 
    {
        Header = "UNSTOPPABLE", 
        Quote = "\"Consider this myth busted.\" - Roblox", 
        Text = ("<font color=\"rgb(248,217,109)\">John Doe</font> can only be stunned for %*s while casting Corrupt Energy and 404 Error.\n"):format(v1.UnstoppableDuration) .. "Additionally, <font color=\"rgb(248,217,109)\">John Doe</font> will roar and gain <b>Speed I</b> for 3s upon the stun ending. The duration of the speed boost is increased by 1s for every Sentinel Survivor currently alive.\n" .. "Corrupt Energy grants its Unstoppable trigger window for an additional 1.5s after casting. While the resulting Speed boost is active, incoming negative status durations are reduced by 50%. The triggering ability cooldown is reduced by 50%.\n"
    }, 
    {
        Separator = "ABILITIES"
    }, 
    {
        Header = "SLASH", 
        Image = "rbxassetid://92362553672440", 
        Quote = "\"For many years, there has been lore circulating around John Doe and \226\150\136\226\150\136\226\150\136\226\150\136 Doe within the community.\" - Roblox", 
        Text = ("Cooldown: %*s\n"):format(v1.SlashCooldown) .. ("Damage: %*\n"):format(v1.SlashDamage) .. ("Windup: %*s\n"):format(v1.SlashWindup) .. ("Linger: %*s\n"):format(v1.SlashLinger) .. "Length: 7.5 studs\n" .. "<font color=\"rgb(248,217,109)\">John Doe</font> slashes infront of him using his claws.\n"
    }, 
    {
        Header = "CORRUPT ENERGY", 
        Image = "rbxassetid://83849304758564", 
        Quote = "\"This year, we\226\128\153ve decided that it\226\128\153s time to shed some light about these accounts.\" - Roblox", 
        Text = ("Cooldown: %*s\n"):format(v1.CorruptEnergyCooldown) .. ("Damage: %*\n"):format(v1.CorruptEnergyDamage) .. ("<font color=\"rgb(248,217,109)\">John Doe</font> punches his corrupted arm into the ground and, when he pulls it out, %* giant spikes (that last for %*s) emerge infront of him, piercing through any survivor unfortunate enough to be caught within them.\n"):format(v1.SpikeAmount, v1.SpikeLifetime) .. "Hitting a player with a spike gives <font color=\"rgb(248,217,109)\">John Doe</font> Speed I for 7 seconds.\n" .. ("Summoned spikes cannot damage the same target more than %* times.\n"):format(v1.SpikeHitCap) .. "Press Corrupt Energy again after the cast to Retract active spikes early. Retracting does not restart the original cooldown. These spikes can be used as blockades to prevent survivors from accessing certain areas.\n"
    }, 
    {
        Header = "DIGITAL FOOTPRINT", 
        Image = "rbxassetid://83206360003394", 
        Quote = "\"John Doe and \226\150\136\226\150\136\226\150\136\226\150\136 Doe are two of Roblox\226\128\153s earliest accounts, as seen by their low user IDs here.\" - Roblox", 
        Text = ("Cooldown: %*s\n"):format(v1.DigitalFootprintCooldown) .. "<font color=\"rgb(248,217,109)\">John Doe</font> stomps on the ground three times, commanding a shadow to emerge underneath his footsteps as a trap for survivors to walk over.\n" .. "If a survivor steps over the false shadow, then <font color=\"rgb(248,217,109)\">John Doe</font> gets a <b>Speed I</b> buff for 10 seconds and the survivor gets a <b>Corrupted I</b> & <b>Slowness II</b> debuff for 10 seconds.\n" .. "Upon the trap being triggered, <font color=\"rgb(248,217,109)\">John Doe</font> and the survivor who activated it have their auras revealed to each other for 10 seconds.\n" .. "The shadow despawns after contact is made with it or <font color=\"rgb(248,217,109)\">John Doe</font> attempts to place down a fourth shadow.\n" .. ("Digital Footprint is 30%% larger. There can only be <b>%*</b> shadows present at once, and attempting to create more will cause the oldest shadow to dissipate.\n"):format(v1.DigitalFootprintLimit)
    }, 
    {
        Header = "404 ERROR", 
        Image = "rbxassetid://131116145215571", 
        Quote = "\"Authentic John Doe and \226\150\136\226\150\136\226\150\136\226\150\136 Doe accounts pose no danger to your Roblox account.\" - Roblox", 
        Text = ("Cooldown: %*s\n"):format(v1["404ErrorCooldown"]) .. ("<font color=\"rgb(248,217,109)\">John Doe</font>'s corrupted arm pulsates twice, revealing the auras of all living survivors to him for %* seconds.\n"):format(v1["404ErrorAuraRevealTime"])
    }
};
-- Phase-one rig profiles. Current FCT animations and all balance values are retained.
v1.JohnDoeRigCollision=script.JohnDoeRigCollision
v1.JohnDoeRigQuery=script.JohnDoeRigQuery
v1.JohnDoeRigScale=script:GetAttribute("JohnDoeRigScale") or 1.25
v1.JohnDoeRigPhase="1.0.0"
v1.HipHeight=0
v1.CorruptEnergyPhase="1.0.0"
v1.JohnGameplayPhase="1.0.0"
v1.DigitalFootprintSizeMultiplier=1.3
v1.CorruptEnergyUnstoppableLinger=1.5
v1.UnstoppableSpeedBoostDuration=3
v1.UnstoppableNegativeStatusDurationMultiplier=.5
return v1;]========],before="11426:1e3114dd:e18edd78",after="11460:088deaff:b5c40572"},
}
local pending={}
for _,plan in ipairs(plans) do
 assert(#plan.source<200000 and fingerprint(plan.source)==plan.after,"Incomplete/oversized source: "..plan.path..". Nothing changed.")
 local target=find(plan.path)
 if target then
  assert(target:IsA("ModuleScript"),"Expected ModuleScript: "..plan.path..". Nothing changed.")
  local hash=fingerprint(target.Source)
  if hash~=plan.after then
   assert(plan.before and hash==plan.before,"Source differs from John rig + Corrupt Energy + cooldown repair: "..plan.path..". Nothing changed; send the current source to retain edits.")
   table.insert(pending,{target=target,source=target.Source,plan=plan})
  end
 else
  assert(not plan.before,"Missing expected module: "..plan.path..". Nothing changed.")
  table.insert(pending,{plan=plan})
 end
end
if #pending==0 then print("[John gameplay] Already installed.");return end
local backup=Instance.new("Folder")
local name="JohnGameplay_Backup_"..os.date("!%Y%m%d_%H%M%S");local index=0
while game.ServerStorage:FindFirstChild(name.."_"..string.format("%03d",index)) do index+=1 end
backup.Name=name.."_"..string.format("%03d",index);backup.Parent=game.ServerStorage
for i,item in ipairs(pending) do
 local saved=item.target and item.target:Clone() or Instance.new("Folder")
 saved.Name=string.format("%02d_%s",i,item.plan.path:match("[^/]+$"));saved:SetAttribute("OriginalPath",item.plan.path);saved:SetAttribute("WasCreated",not item.target);saved:SetAttribute("InstalledFingerprint",item.plan.after);saved.Parent=backup
end
local ok,err=pcall(function()
 for _,item in ipairs(pending) do
  if not item.target then
   local parent=assert(find(item.plan.path:match("^(.*)/[^/]+$")),"Missing new module parent")
   item.target=Instance.new("ModuleScript");item.target.Name=item.plan.path:match("[^/]+$");item.target.Parent=parent
  end
  item.target.Source=item.plan.source
 end
end)
if not ok then
 for i=#pending,1,-1 do local item=pending[i];if item.source then item.target.Source=item.source elseif item.target then item.target:Destroy() end end
 backup:Destroy();error("[John gameplay] Rolled back: "..tostring(err))
end
pcall(function()game:GetService("ChangeHistoryService"):SetWaypoint("John Doe gameplay update")end)
print("[John gameplay] Installed health, Slash, footprint, trail, sounds and Unstoppable changes; Retract preserved. Backup: "..backup:GetFullName()..". Save and start a fresh playtest.")
