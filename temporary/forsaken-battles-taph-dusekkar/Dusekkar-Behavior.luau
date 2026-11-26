-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local v0 = game:GetService("RunService"):IsStudio();
local v1 = {};
local v2 = require(game.ReplicatedStorage.Modules.Util);
local v3 = require(game.ReplicatedStorage.Modules.Sounds);
local v4 = require(game.ReplicatedStorage.Modules.Network);
local v5 = require(game.ReplicatedStorage.Modules.Hitboxes);
local v6 = require(game.ReplicatedStorage.Modules.Statuses);
local _ = require(game.ReplicatedStorage.Modules.AchievementUtil);
local v8 = require(game.ReplicatedStorage.Modules.Device);
local v9 = require(game.ReplicatedStorage.Modules.Actors);
local v10 = require(game.ReplicatedStorage.Modules.Misc.Maid);
local function v15(v11, v12) --[[ Line: 18 ]] --[[ Name: getMousePosRelativeTo ]]
    -- upvalues: v8 (copy)
    if v8:GetPlayerDevice() == "PC" then
        return (game:GetService("UserInputService"):GetMouseLocation());
    elseif v12 then
        local v13 = v11.PrimaryPart and workspace.CurrentCamera:WorldToViewportPoint(v11.PrimaryPart.Position) or Vector3.new();
        return Vector2.new(v13.X, v13.Y);
    else
        local v14 = workspace.CurrentCamera:WorldToViewportPoint((workspace.CurrentCamera.CFrame * CFrame.new(0, 0, -500)).Position);
        return Vector2.new(v14.X, v14.Y);
    end;
end;
local function v26(v16, v17, v18) --[[ Line: 37 ]] --[[ Name: isCharWithinRadius ]]
    -- upvalues: v15 (copy)
    local l_Character_0 = game.Players.LocalPlayer.Character;
    if not v16 or not v16.PrimaryPart then
        return;
    elseif not l_Character_0 or not l_Character_0.PrimaryPart then
        return;
    else
        local v20 = v15(v16, v18) + Vector2.new(0, v17 / 100);
        local v21, v22 = workspace.CurrentCamera:WorldToViewportPoint(v16.PrimaryPart.Position);
        if v22 then
            local l_Magnitude_0 = (Vector2.new(v21.X, v21.Y) - v20).Magnitude;
            local l_Magnitude_1 = (l_Character_0.PrimaryPart.Position - v16.PrimaryPart.Position).Magnitude;
            local v25 = false;
            if l_Magnitude_0 <= v17 / 2 then
                v25 = l_Magnitude_1 <= require(script.Parent.Config).SpawnProtectionEffectMaxDistance;
            end;
            return v25, l_Magnitude_0;
        else
            return;
        end;
    end;
end;
local function v34(v27, v28, v29, v30) --[[ Line: 53 ]] --[[ Name: playVFX ]]
    local v31 = v27.Config.VFXTemplate[v29]:Clone();
    v31.Parent = v28;
    if v30 then
        game.Debris:AddItem(v31, v30);
    end;
    for _, v33 in pairs(v31:GetChildren()) do
        if v33:IsA("ParticleEmitter") then
            v33:Emit(v33:GetAttribute("EmitCount") or 1);
        end;
    end;
    return v31;
end;
local function _(v35) --[[ Line: 71 ]] --[[ Name: scaleToOffset ]]
    return workspace.Camera.ViewportSize.Y * v35;
end;
local function _(v37) --[[ Line: 81 ]] --[[ Name: __displayWarn ]]
    -- upvalues: v0 (copy)
    if v0 then
        warn((("[Elliot]: %*"):format(v37)));
    end;
end;
local function v44(v39, v40, ...) --[[ Line: 95 ]] --[[ Name: __pcallMethod ]]
    -- upvalues: v0 (copy)
    assert(v39, "bad moduleInfo, must be a table");
    local l_status_0, l_result_0 = pcall(function(...) --[[ Line: 98 ]]
        -- upvalues: v39 (copy), v40 (copy)
        if v39[v40] then
            return v39[v40](...);
        else
            return;
        end;
    end, ...);
    if not l_status_0 then
        local v43 = ("Failed to call :%*() due to: %*"):format(v40, l_result_0);
        if v0 then
            warn((("[Elliot]: %*"):format(v43)));
        end;
    end;
    return l_status_0, l_result_0;
end;
v1.Abilities = {
    SpawnProtection = {
        LayoutOrder = 1, 
        KeybindType = "AltAbility1", 
        Icon = "rbxassetid://136501603087283", 
        Callback = function(v45, v46) --[[ Line: 113 ]] --[[ Name: Callback ]]
            -- upvalues: v4 (copy), v3 (copy), v6 (copy), v2 (copy), v34 (copy), v9 (copy), v8 (copy), v26 (copy)
            if game["Run Service"]:IsServer() then
                local v47 = v4:FireClientConnection(v45.Player, ("%*DusekkarGet"):format((tostring(v45.Player))), "REMOTE_FUNCTION");
                local v48 = false;
                if typeof(v47) == "Instance" then
                    v48 = false;
                    if v47.Parent == workspace.Players.Survivors then
                        v48 = v47;
                    end;
                end;
                v47 = v48;
                v48 = not v47 and "NoTarget" or v45.Rig:GetAttribute("Protecting") and "Protecting" or v47:GetAttribute("DusekkarProtected") and "TargetProtected" or v47:GetAttribute("Protecting") and "TargetProtecting" or (v47.PrimaryPart.Anchored and not v47:GetAttribute("AzureGrabbed")) and "TargetAnchored" or os.clock() - (tonumber(v47:GetAttribute("LastProtection")) or 0) <= v45.Config.SpawnProtectionTimeUntilProtectableAgain and (tonumber(v47:GetAttribute("LastProtection")) or 0) + v45.Config.SpawnProtectionTimeUntilProtectableAgain - os.clock() or v47:GetAttribute("NosHookCaught") and "NosHookCaught";
                if not v48 then
                    v45.AbilitiesDisabled = true;
                    v45.Rig:SetAttribute("Protecting", true);
                    v47:SetAttribute("DusekkarProtected", v45.Player.Name);
                    v3:Play(v45.Config.Sounds.SpawnProtectionActivate, {
                        Parent = v45.Rig.PrimaryPart
                    });
                    local l_Humanoid_0 = v47.Humanoid;
                    local l_Humanoid_1 = v45.Rig.Humanoid;
                    local v54 = (function() --[[ Line: 142 ]] --[[ Name: getCurrentProtectors ]]
                        local v51 = {};
                        for _, v53 in pairs(workspace.Players.Survivors:GetChildren()) do
                            if v53:GetAttribute("Protecting") then
                                table.insert(v51, v53);
                            end;
                        end;
                        return v51;
                    end)();
                    if v45.Config.SpawnProtectionMaxPlayers - #v54 <= 0 then
                        for _, v56 in pairs(v54) do
                            v56:SetAttribute("Protecting", nil);
                            v6:ApplyStatus(v56, "Blindness", {
                                Level = 3, 
                                Duration = v45.Config.SpawnProtectionOverflowDebuffDuration
                            });
                            v6:ApplyStatus(v56, "Slowness", {
                                Level = 3, 
                                Duration = v45.Config.SpawnProtectionOverflowDebuffDuration
                            });
                        end;
                        v47:SetAttribute("DusekkarProtected", nil);
                        v45.AbilitiesDisabled = false;
                        return;
                    else
                        local l_v2_SpeedMultiplier_0 = v2:CreateSpeedMultiplier(v45.Player, 1 - v45.Config.SpawnProtectionSpeedReductionWhileInUse / 100, "SpawnProtection");
                        v6:ApplyStatus(v45.Player, "Slowness", v45.Config.SpawnProtectionSlownessData);
                        task.delay(0.3, function() --[[ Line: 173 ]]
                            -- upvalues: v3 (ref), v45 (copy), v34 (ref), v47 (ref), l_Humanoid_1 (copy), l_Humanoid_0 (copy), v6 (ref), v9 (ref), l_v2_SpeedMultiplier_0 (copy)
                            local v58 = os.clock();
                            local v59 = v3:Play(v45.Config.Sounds.SpawnProtectionLoop, {
                                Parent = v45.Rig.PrimaryPart
                            });
                            v34(v45, v47.PrimaryPart, "Start", 10);
                            local v60 = v34(v45, v45.Rig.StaffDetector, "StaffBeam");
                            for _, v62 in pairs(v60:GetChildren()) do
                                v62.Attachment1 = v47.PrimaryPart and v47.PrimaryPart:FindFirstChildOfClass("Attachment");
                            end;
                            local v63 = v34(v45, v45.Rig.StaffDetector, "StaffMagic");
                            for _, v65 in pairs(v63:GetChildren()) do
                                if v65:IsA("ParticleEmitter") then
                                    v65:Emit(v65:GetAttribute("EmitCount") or 1);
                                end;
                                v65.Enabled = true;
                            end;
                            local v66 = v45.Config.VFXTemplate.Hold:Clone();
                            v66.Parent = v47.PrimaryPart;
                            for _, v68 in pairs(v66:GetChildren()) do
                                if v68:IsA("ParticleEmitter") then
                                    v68:Emit(v68:GetAttribute("EmitCount") or 1);
                                end;
                                v68.Enabled = true;
                            end;
                            local v69 = false;
                            local _ = task.delay(v45.Config.SpawnProtectionMaxDuration, function() --[[ Line: 208 ]]
                                -- upvalues: v69 (ref), v45 (ref)
                                if not v69 then
                                    v45.Rig:SetAttribute("Protecting", nil);
                                end;
                            end);
                            while v45.Rig.Parent and v45.Rig:GetAttribute("Protecting") and l_Humanoid_1.Health > 0 and l_Humanoid_0.Health > 0 do
                                if not v47:GetAttribute("DusekkarProtected") then
                                    v6:RemoveStatus(v47, "Resistance");
                                    break;
                                else
                                    v6:ApplyStatus(v47, "Resistance", {
                                        Level = 4, 
                                        Duration = 1
                                    });
                                    task.wait();
                                end;
                            end;
                            if os.clock() - v58 >= 3 then
                                v9:IncrementActorStats(v45.Player, {
                                    Action = "Protected a Survivor", 
                                    Money = 7, 
                                    EXP = 14, 
                                    KillerChance = 0.5
                                });
                            end;
                            v47:SetAttribute("LastProtection", os.clock());
                            if v47.Parent and v47.PrimaryPart then
                                game.TweenService:Create(v59, TweenInfo.new(0.3), {
                                    PlaybackSpeed = 0
                                }):Play();
                                v3:Play(v45.Config.Sounds.SpawnProtectionShieldBreak, {
                                    Parent = v47.PrimaryPart
                                });
                                task.delay(0.1, function() --[[ Line: 249 ]]
                                    -- upvalues: v34 (ref), v45 (ref), v47 (ref)
                                    v34(v45, v47.PrimaryPart, "Shatter", 10);
                                end);
                            end;
                            v60:Destroy();
                            for v71, v72 in pairs({
                                v66, 
                                v63
                            }) do
                                game.Debris:AddItem(v72, v71 == 1 and 0.25 or 4);
                                for _, v74 in pairs(v72:GetChildren()) do
                                    if v74:IsA("ParticleEmitter") then
                                        v74.Enabled = false;
                                    elseif v74:IsA("Light") then
                                        game.TweenService:Create(v74, TweenInfo.new(0.25), {
                                            Brightness = 0
                                        }):Play();
                                    end;
                                end;
                            end;
                            v47:SetAttribute("DusekkarProtected", nil);
                            v69 = true;
                            game.TweenService:Create(l_v2_SpeedMultiplier_0, TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
                                Value = 1
                            }):Play();
                            game.Debris:AddItem(l_v2_SpeedMultiplier_0, 1);
                            task.delay(2, function() --[[ Line: 278 ]]
                                -- upvalues: v45 (ref)
                                v45.AbilitiesDisabled = false;
                            end);
                        end);
                        return {
                            Target = v47
                        };
                    end;
                else
                    return {
                        Target = v47, 
                        Cancelled = true, 
                        Reason = v48
                    };
                end;
            else
                if game["Run Service"]:IsClient() and typeof(v46) == "table" then
                    if v46.Cancelled then
                        local v75 = {
                            NoTarget = {
                                PC = "Cursor not close enough to a Survivor.", 
                                Console = "Survivor not detected on screen.", 
                                Mobile = "Survivor not detected on screen."
                            }, 
                            Protecting = "You're already protecting a Survivor. Dummy.", 
                            TargetProtecting = "That Dusekkar's already protecting another Survivor.", 
                            TargetProtected = "That Survivor's already being protected by another Dusekkar.", 
                            TargetAnchored = "That Survivor's occupied with something."
                        };
                        local l_PlayerDevice_0 = require(game.ReplicatedStorage.Modules.Device):GetPlayerDevice();
                        local v77 = v75[v46.Reason] or typeof(v46.Reason) == "number" and ("That Survivor can't be protected for another %* seconds."):format((math.round(v46.Reason))) or "Protectable Survivor not detected.";
                        if typeof(v77) == "table" then
                            v77 = v77[l_PlayerDevice_0] or "Survivor not detected on screen.";
                        end;
                        v2:CreateWarning("DusekkarWarning", v77, v45.Config.WarningTemplate);
                        return;
                    elseif v46.Target then
                        v45.Animations.StaffStartup:Play();
                        v45.Animations.StaffLoop:Play();
                        local l_Mouse_0 = v45.Player:GetMouse();
                        local l_SpawnProtectionScaleRadius_0 = v45.Config.SpawnProtectionScaleRadius;
                        local v80 = workspace.Camera.ViewportSize.Y * l_SpawnProtectionScaleRadius_0;
                        l_SpawnProtectionScaleRadius_0 = v45.Config.SpawnProtectionIndicatorTemplate:Clone();
                        l_SpawnProtectionScaleRadius_0.Parent = v45.Player.PlayerGui.TemporaryUI;
                        l_SpawnProtectionScaleRadius_0.ImageTransparency = 1;
                        game.TweenService:Create(l_SpawnProtectionScaleRadius_0, TweenInfo.new(0.3), {
                            ImageTransparency = 0
                        }):Play();
                        game.TweenService:Create(l_SpawnProtectionScaleRadius_0, TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, false), {
                            Rotation = 360
                        }):Play();
                        local v81 = v45.Config.SpawnProtectionRadiusTemplate:Clone();
                        v81.Parent = v45.Player.PlayerGui.TemporaryUI;
                        v81.ImageTransparency = 1;
                        v81.Size = UDim2.fromOffset(v80, v80);
                        v81.Rotation = v81.Rotation - 90;
                        game.TweenService:Create(v81, TweenInfo.new(0.3), {
                            ImageTransparency = 0, 
                            Rotation = v81.Rotation + 90
                        }):Play();
                        task.spawn(function() --[[ Line: 344 ]]
                            -- upvalues: v4 (ref), v45 (copy), l_SpawnProtectionScaleRadius_0 (copy), v81 (copy), v46 (copy), v8 (ref), l_Mouse_0 (copy), v26 (ref), v80 (copy), v2 (ref)
                            local v82 = 0;
                            local v83 = 0;
                            local v84 = nil;
                            local function v85() --[[ Line: 351 ]] --[[ Name: breakOut ]]
                                -- upvalues: v84 (ref), v4 (ref), v45 (ref), l_SpawnProtectionScaleRadius_0 (ref), v81 (ref)
                                if not v84 then
                                    v84 = true;
                                    v4:FireServerConnection(("%*DusekkarCancel"):format((tostring(v45.Player))), "REMOTE_EVENT");
                                    v45.Animations.StaffLoop:Stop();
                                    game.TweenService:Create(l_SpawnProtectionScaleRadius_0, TweenInfo.new(0.3), {
                                        ImageTransparency = 1
                                    }):Play();
                                    game.Debris:AddItem(l_SpawnProtectionScaleRadius_0, 0.3);
                                    game.TweenService:Create(v81, TweenInfo.new(0.3), {
                                        ImageTransparency = 1, 
                                        Rotation = v81.Rotation + 90
                                    }):Play();
                                    game.Debris:AddItem(v81, 0.3);
                                    game.TweenService:Create(l_SpawnProtectionScaleRadius_0.Warning, TweenInfo.new(0.3), {
                                        TextTransparency = 1, 
                                        TextStrokeTransparency = 1
                                    }):Play();
                                end;
                            end;
                            while v45.Rig.Parent and v81.Parent do
                                local v86 = workspace.CurrentCamera:WorldToViewportPoint(v46.Target.PrimaryPart.Position);
                                l_SpawnProtectionScaleRadius_0.Position = UDim2.fromOffset(v86.X, v86.Y);
                                l_SpawnProtectionScaleRadius_0.Warning.Rotation = -l_SpawnProtectionScaleRadius_0.Rotation;
                                v81.Position = v8:GetPlayerDevice() == "PC" and UDim2.fromOffset(l_Mouse_0.X, l_Mouse_0.Y + game.GuiService:GetGuiInset().Y) or l_SpawnProtectionScaleRadius_0.Position;
                                if not v45.Rig.Parent then
                                    v85();
                                end;
                                if not v45.Rig:GetAttribute("Protecting") then
                                    v85();
                                end;
                                if not v46.Target.Parent then
                                    v85();
                                end;
                                if v82 >= 0.05 then
                                    if not v26(v46.Target, v80, true) or v45.Config.SpawnProtectionTimeUntilBrokenByWallInterference <= v83 then
                                        v85();
                                        l_SpawnProtectionScaleRadius_0.Warning.Text = "CANCELLED\n\n\n\n:(";
                                    elseif not v2:IsOnScreen(v46.Target, true) then
                                        v83 = v83 + v82;
                                        local v87 = v45.Config.SpawnProtectionTimeUntilBrokenByWallInterference - v83;
                                        if v87 > 0 then
                                            l_SpawnProtectionScaleRadius_0.Warning.Text = ("TARGET IS BLOCKED\n\n\n\nCANCELLING IN %*S"):format(math.round(v87 * 10) / 10);
                                            l_SpawnProtectionScaleRadius_0.Warning.Visible = true;
                                        end;
                                    elseif l_SpawnProtectionScaleRadius_0.Warning.Visible then
                                        l_SpawnProtectionScaleRadius_0.Warning.Visible = false;
                                        v83 = 0;
                                    end;
                                    v82 = 0;
                                end;
                                v82 = v82 + task.wait();
                            end;
                        end);
                    end;
                end;
                return;
            end;
        end
    }, 
    PlasmaBeam = {
        LayoutOrder = 2, 
        KeybindType = "AltAbility2", 
        Icon = "rbxassetid://83030778673034", 
        Callback = function(v88, _) --[[ Line: 417 ]] --[[ Name: Callback ]]
            -- upvalues: v2 (copy), v3 (copy), v44 (copy), v4 (copy), v5 (copy), v6 (copy), v9 (copy), v34 (copy)
            if game["Run Service"]:IsServer() then
                v88.AbilitiesDisabled = true;
                task.delay(2, function() --[[ Line: 420 ]]
                    -- upvalues: v88 (copy)
                    v88.AbilitiesDisabled = false;
                end);
                local v90 = -1;
                for _, v92 in pairs(workspace.Players.Survivors:GetChildren()) do
                    if v92.Name == "Dusekkar" then
                        v90 = v90 + 1;
                    end;
                end;
                local l_v2_SpeedMultiplier_1 = v2:CreateSpeedMultiplier(v88.Player, 1 - v88.Config.PlasmaBeamSpeedReductionWhileInUse / 100, "PlasmaBeam");
                v3:Play(v88.Config.Sounds.PlasmaBeamShoot, {
                    Parent = v88.Rig.PrimaryPart
                });
                v44(v88.Behavior, "OnPlasmaBeamChannel", v88.Behavior, v88);
                task.delay(1.5, function() --[[ Line: 440 ]]
                    -- upvalues: v88 (copy), v4 (ref), v5 (ref), v6 (ref), v2 (ref), v90 (ref), v9 (ref), v34 (ref), l_v2_SpeedMultiplier_1 (copy)
                    if not v88.Player or not v88.Player.Parent then
                        return;
                    else
                        local v94 = nil;
                        local v95 = nil;
                        local v96 = v4:FireClientConnection(v88.Player, "GetMousePosition", "REMOTE_FUNCTION");
                        local l_Position_0 = (v88.Rig.PrimaryPart.CFrame * CFrame.new(1.25, 1.5, -3.5)).Position;
                        local _ = v5:CreateHitbox(v88.Player, {
                            Size = Vector3.new(v88.Config.PlasmaBeamHitboxSize, v88.Config.PlasmaBeamHitboxSize, v88.Config.PlasmaBeamHitboxRange), 
                            CFrame = CFrame.lookAt(l_Position_0, v96) * CFrame.new(0, 0, -v88.Config.PlasmaBeamHitboxRange / 2), 
                            Time = 0.05, 
                            Damage = 0, 
                            FriendlyFire = true, 
                            HitMultiple = true, 
                            PredictVelocity = false, 
                            Connections = {
                                Hit = function(v98) --[[ Line: 459 ]] --[[ Name: Hit ]]
                                    -- upvalues: v88 (ref), v94 (ref), v6 (ref), v2 (ref), v90 (ref), v9 (ref), v34 (ref), v95 (ref)
                                    local l_PrimaryPart_0 = v98.PrimaryPart;
                                    if l_PrimaryPart_0 then
                                        v88:ChangeExpression("HitTarget", 2);
                                        if tostring(v98.Parent) == "Survivors" and not v94 then
                                            v94 = true;
                                            v6:ApplyStatus(v98, "Speed", v88.Config.PlasmaBeamSpeedData);
                                            v2:ApplyOverheal(v98, v88.Config.PlasmaBeamOverheal - v90 / 0.4, true);
                                            v9:IncrementActorStats(v88.Player, {
                                                Action = "Zapped a Survivor", 
                                                Money = 4, 
                                                EXP = 8,
                                                KillerChance = 0.5
                                            });
                                            v34(v88, l_PrimaryPart_0, "Zap", 5);
                                            return;
                                        elseif tostring(v98.Parent) == "Killers" then
                                            local v100 = {};
                                            for v101, v102 in pairs(v88.Config.PlasmaBeamSlownessData) do
                                                v100[v101] = v102;
                                            end;
                                            v100.Duration = math.clamp(v100.Duration - math.max(0,v90) * 0.5, 0.5, v100.Duration);
                                            if v100.Duration > 0.5 and not v95 then
                                                v95 = true;
                                                v6:ApplyStatus(v98, "Slowness", v100);
                                                v9:IncrementActorStats(v88.Player, {
                                                    Action = "Zapped a Killer", 
                                                    Money = 6, 
                                                    EXP = 12, 
                                                    KillerChance = 0.25
                                                });
                                                v34(v88, l_PrimaryPart_0, "Zap", 5);
                                            end;
                                        end;
                                    end;
                                end
                            }
                        });
                        v4:FireAllClientConnection(("%*DusekkarReplZap"):format((tostring(v88.Player))), "REMOTE_EVENT", v96, v88.Rig.StaffDetector);
                        task.wait(0.25);
                        game.TweenService:Create(l_v2_SpeedMultiplier_1, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
                            Value = 1
                        }):Play();
                        game.Debris:AddItem(l_v2_SpeedMultiplier_1, 0.5);
                        return;
                    end;
                end);
                return;
            else
                if game["Run Service"]:IsClient() then
                    v88.Animations.StaffShot:Play();
                end;
                return;
            end;
        end
    }
};
v1.Created = function(_, v105) --[[ Line: 510 ]] --[[ Name: Created ]]
    -- upvalues: v4 (copy), v2 (copy), v26 (copy), v10 (copy)
    v105.Rig:SetAttribute("FootstepsMuted", true);
    if game["Run Service"]:IsServer() then
        v4:SetConnection(("%*DusekkarCancel"):format((tostring(v105.Player))), "REMOTE_EVENT", function(v106) --[[ Line: 514 ]]
            -- upvalues: v105 (copy)
            if v105.Player == v106 and v105.Rig:GetAttribute("Protecting") then
                v105.Rig:SetAttribute("Protecting", nil);
            end;
        end);
        return;
    else
        if game["Run Service"]:IsClient() then
            if v105.Player == game.Players.LocalPlayer then
                v4:SetConnection(("%*DusekkarGet"):format((tostring(v105.Player))), "REMOTE_FUNCTION", function() --[[ Line: 523 ]]
                    -- upvalues: v2 (ref), v105 (copy), v26 (ref)
                    local v107 = nil;
                    local v108 = nil;
                    local l_v2_ClosestPlayerFromPosition_0 = v2:GetClosestPlayerFromPosition(v105.Rig.PrimaryPart.Position, {
                        ReturnTable = true, 
                        MaxDistance = v105.Config.SpawnProtectionPlayerMinRadius, 
                        PlayerSelection = "Survivors", 
                        OverrideUndetectable = true
                    });
                    for _, v111 in pairs(l_v2_ClosestPlayerFromPosition_0) do
                        local l_Player_0 = v111.Player;
                        local l_SpawnProtectionScaleRadius_1 = v105.Config.SpawnProtectionScaleRadius;
                        local v114 = workspace.Camera.ViewportSize.Y * l_SpawnProtectionScaleRadius_1;
                        local v115;
                        l_SpawnProtectionScaleRadius_1, v115 = v26(l_Player_0, v114);
                        if v2:IsOnScreen(l_Player_0, true) and l_SpawnProtectionScaleRadius_1 and l_Player_0 ~= v105.Rig and (not v107 or v115 <= v108) then
                            v107 = l_Player_0;
                            v108 = v115;
                        end;
                    end;
                    return v107;
                end);
            end;
            v4:SetConnection(("%*DusekkarReplZap"):format((tostring(v105.Player))), "REMOTE_EVENT", function(v116, v117) --[[ Line: 542 ]]
                -- upvalues: v10 (ref), v105 (copy)
                local v118 = v10.new();
                v105.BoltMaid = v118;
                local v119 = Instance.new("Attachment", v117);
                v119.WorldPosition = v117.Position;
                v118:Add(v119);
                local l_Part_0 = Instance.new("Part");
                v118:Add(l_Part_0);
                l_Part_0.Size = Vector3.new(1, 1, 1, 0);
                l_Part_0.Position = v116;
                l_Part_0.Transparency = 1;
                l_Part_0.Anchored = true;
                l_Part_0.CanCollide = false;
                l_Part_0.Name = "HitPart";
                l_Part_0.Parent = game.Workspace.Misc;
                local v121 = Instance.new("Attachment", l_Part_0);
                v121.WorldPosition = v116;
                v118:Add(v121);
                local v122 = require(game.ReplicatedStorage.Modules.Misc.LightningBolt);
                local l_PlasmaBeamColor1_0 = v105.Config.PlasmaBeamColor1;
                local l_PlasmaBeamColor2_0 = v105.Config.PlasmaBeamColor2;
                local v125 = v122.new(v119, v121, 10);
                v118:Add(v125);
                v125.PulseSpeed = 15;
                v125.MinRadius = 2.5;
                v125.MaxRadius = 3;
                v125.Frequency = 4;
                v125.FadeLength = 0.05;
                v125.AnimationSpeed = 5;
                v125.Color = l_PlasmaBeamColor1_0:Lerp(l_PlasmaBeamColor2_0, math.random(0, 1000) / 1000);
                v118:Add((require(game.ReplicatedStorage.Modules.Misc.LightningBolt.LightningSparks).new(v125)));
                local v126 = require(game.ReplicatedStorage.Modules.Misc.Shake);
                local v127 = v126.new();
                v127.Amplitude = 5;
                v127.Frequency = 0.05;
                v127.FadeInTime = 0.05;
                v127.FadeOutTime = 1;
                v127.Sustain = false;
                v127.RotationInfluence = Vector3.new(1, 1, 1, 0);
                v127.PositionInfluence = Vector3.new(1, 1, 1, 0);
                v118:Add(v127);
                v127:Start();
                v127:BindToRenderStep("ExplosionShake", Enum.RenderPriority.Last.Value, function(v128, v129, _) --[[ Line: 592 ]]
                    -- upvalues: v117 (copy), v126 (copy)
                    local l_Magnitude_2 = (game.Workspace.CurrentCamera.CFrame.Position - v117.Position).Magnitude;
                    v128 = v126.InverseSquare(v128, l_Magnitude_2);
                    v129 = v126.InverseSquare(v129, l_Magnitude_2);
                    local l_CurrentCamera_0 = game.Workspace.CurrentCamera;
                    l_CurrentCamera_0.CFrame = l_CurrentCamera_0.CFrame * (CFrame.new(v128) * CFrame.Angles(v129.X, v129.Y, v129.Z));
                end);
                task.spawn(function() --[[ Line: 599 ]]
                    -- upvalues: v125 (copy), v118 (copy)
                    for _ = 1, 90 do
                        local l_v125_0 = v125;
                        l_v125_0.MinRadius = l_v125_0.MinRadius * 0.8;
                        l_v125_0 = v125;
                        l_v125_0.MaxRadius = l_v125_0.MaxRadius * 0.8;
                        l_v125_0 = v125;
                        l_v125_0.Frequency = l_v125_0.Frequency * 0.8;
                        l_v125_0 = v125;
                        l_v125_0.MinThicknessMultiplier = l_v125_0.MinThicknessMultiplier * 0.8;
                        l_v125_0 = v125;
                        l_v125_0.MaxThicknessMultiplier = l_v125_0.MaxThicknessMultiplier * 0.8;
                        if v125.MaxRadius >= 0.15 then
                            task.wait();
                        else
                            break;
                        end;
                    end;
                    v118:Destroy();
                end);
            end);
        end;
        return;
    end;
end;
v1.Destroyed = function(_, v136) --[[ Line: 617 ]] --[[ Name: Destroyed ]]
    -- upvalues: v4 (copy)
    if game["Run Service"]:IsServer() then
        v4:RemoveConnection(("%*DusekkarCancel"):format((tostring(v136.Player))), "REMOTE_EVENT");
        return;
    else
        for _, v138 in {
            "RunMaid", 
            "BoltMaid"
        } do
            if v136[v138] then
                v136[v138]:Destroy();
                v136[v138] = nil;
            end;
        end;
        v4:RemoveConnection(("%*DusekkarReplZap"):format((tostring(v136.Player))), "REMOTE_EVENT");
        v4:RemoveConnection(("%*DusekkarGet"):format((tostring(v136.Player))), "REMOTE_FUNCTION");
        return;
    end;
end;
return v1;