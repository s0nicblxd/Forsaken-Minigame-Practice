-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local l_ReplicatedStorage_0 = game:GetService("ReplicatedStorage");
local l_RunService_0 = game:GetService("RunService");
local v2 = {};
local v3 = require(l_ReplicatedStorage_0.Modules.Util);
local v4 = require(l_ReplicatedStorage_0.Modules.Statuses);
local v5 = require(l_ReplicatedStorage_0.Modules.Hitboxes);
local v6 = require(l_ReplicatedStorage_0.Modules.Network);
local v7 = require(l_ReplicatedStorage_0.Modules.Sounds);
local v8 = require(l_ReplicatedStorage_0.Modules.Misc.Trove);
local v9 = require(l_ReplicatedStorage_0.Modules.AchievementUtil);
local v10 = Color3.new(1, 1, 1);
local v11 = Color3.new(0.392157, 0.392157, 0.392157);
local v12 = Color3.new(1, 0.933333, 0.027451);
local v13 = Color3.new(1, 1, 1);
local function _(v14, v15, v16) --[[ Line: 23 ]] --[[ Name: pcallMethod ]]
    local l_status_0, l_result_0 = pcall(function() --[[ Line: 24 ]]
        -- upvalues: v16 (copy), v14 (copy)
        if v16.Behavior[v14] then
            v16.Behavior[v14](v16);
        end;
    end);
    if not l_status_0 then
        warn((("[%*]: Failed to call .%*() due to: %*"):format(v15, v14, l_result_0)));
    end;
end;
-- Block owns a separate ability lock, so its timers cannot clear another ability's lock.
local function cancelGuestBlockTask(actor, name)
    local thread = actor[name]
    actor[name] = nil
    if thread then pcall(task.cancel, thread) end
end

local function clearGuestBlockSlow(actor)
    if actor.BlockingSlowness then
        actor.BlockingSlowness:Destroy()
        actor.BlockingSlowness = nil
    end
end

local function restoreGuestBlockHitbox(actor)
    local rig = actor.Rig
    if not rig then return end
    local query = rig:FindFirstChild("QueryHitbox")
    if query and actor.__blockDefaultHitboxSize then
        query.Size = actor.__blockDefaultHitboxSize
    end
    rig:SetAttribute("HitboxPriority", 2)
end

local function callGuestBlockHook(actor, name)
    local hook = actor.Behavior and actor.Behavior[name]
    if hook then
        local ok, err = pcall(hook, actor)
        if not ok then warn("[Guest Rework] " .. name .. ": " .. tostring(err)) end
    end
end

local function resolveGuestBlock(actor)
    actor.Blocking = nil
    actor.BlockSucceeded = true
    cancelGuestBlockTask(actor, "BlockThread")
    cancelGuestBlockTask(actor, "__blockSlowThread")
    cancelGuestBlockTask(actor, "__blockUnlockThread")
    clearGuestBlockSlow(actor)
    restoreGuestBlockHitbox(actor)
    actor:DisableAbilities("GuestReworkBlock", false)
end

local function setGuestParryWindow(actor, active)
    actor.Blocked = active and true or nil
    if actor.Rig then
        actor.Rig:SetAttribute("GuestReworkParryUntil",
            active and (workspace:GetServerTimeNow() + actor.Config.BlockDuration) or 0)
    end
end

local function stopGuestParryMotion(rig)
    local root = rig and rig.PrimaryPart
    if not root or not root.Parent then return end
    local velocity = root.AssemblyLinearVelocity
    root.AssemblyLinearVelocity = Vector3.new(0, velocity.Y, 0)
end

v2.Abilities = {
    Block = {
        LayoutOrder = 1,
        KeybindType = "AltAbility1",
        Icon = "rbxassetid://137576632569674",
        Callback = function(actor)
            if l_RunService_0:IsClient() then
                if actor.Animations.Block then
                    actor.Animations.Block:Play(0.175)
                end
                return
            end

            local rig = actor.Rig
            local humanoid = rig and rig:FindFirstChildOfClass("Humanoid")
            if not humanoid or humanoid.Health <= 0 then return end

            cancelGuestBlockTask(actor, "BlockThread")
            cancelGuestBlockTask(actor, "__blockSlowThread")
            cancelGuestBlockTask(actor, "__blockUnlockThread")
            cancelGuestBlockTask(actor, "BlockedThread")
            setGuestParryWindow(actor, false)
            actor.Blocking = true
            actor.BlockSucceeded = false
            actor:DisableAbilities("GuestReworkBlock", true)
            callGuestBlockHook(actor, "BlockStart")
            v4:ApplyStatus(actor.Player, "Resistance", {
                Level = actor.Config.ResistanceLevel,
                Duration = actor.Config.BlockDuration
            })
            rig:SetAttribute("HitboxPriority", 3)
            local query = rig:FindFirstChild("QueryHitbox")
            if query then
                actor.__blockDefaultHitboxSize = actor.__blockDefaultHitboxSize or query.Size
                query.Size = actor.__blockDefaultHitboxSize * Vector3.new(2.1, 1.2, 2.1)
            end
            clearGuestBlockSlow(actor)
            actor.BlockingSlowness = v3:CreateSpeedMultiplier(rig, 0.5, "GuestBlocking")
            actor.__blockSlowThread = task.delay(actor.Config.SlownessDuration, function()
                actor.__blockSlowThread = nil
                clearGuestBlockSlow(actor)
            end)

            local previousBlockCount = actor.BlockCount
            task.delay(2, function()
                if actor.BlockCount == previousBlockCount then actor.BlockCount = 0 end
            end)

            actor.BlockThread = task.delay(actor.Config.BlockDuration, function()
                actor.BlockThread = nil
                if not actor.Blocking then return end
                actor.Blocking = nil
                restoreGuestBlockHitbox(actor)
                callGuestBlockHook(actor, "BlockExpire")
                callGuestBlockHook(actor, "BlockEnd")
                -- Failure means the full guard window elapsed without a hit.
                -- Keep this named lock for TWO SECONDS AFTER that failure.
                actor.__blockUnlockThread = task.delay(actor.Config.FailedBlockAbilityLockout, function()
                    actor.__blockUnlockThread = nil
                    actor:DisableAbilities("GuestReworkBlock", false)
                end)
            end)
            v7:Play(actor.Config.Sounds.BlockStart, { Parent = rig.PrimaryPart })
        end
    },
    Charge = {
        LayoutOrder = 2, 
        KeybindType = "AltAbility2", 
        Icon = "rbxassetid://73254549946762", 
        Callback = function(v33, v34) --[[ Line: 121 ]] --[[ Name: Callback ]]
            -- upvalues: l_RunService_0 (copy), v3 (copy), v5 (copy), v7 (copy), v6 (copy), v9 (copy), l_ReplicatedStorage_0 (copy), v4 (copy)
            if l_RunService_0:IsServer() then
				v33.DisabledAbilities = {
					Block = true,
					Charge = true,
					Punch = true
				};
				local chargeStartedAt = workspace:GetServerTimeNow()
                local v35 = v33 and v33.Rig;
                if v35 then
                    v35:SetAttribute("AnimationsDisabled", true);
                    v35:SetAttribute("AnimationsExtraDisabled", true);
                    v35:SetAttribute("UsingItemsDisabled", true);
                end;
                v3:SetSpeedCap(v33.Player, "GuestCharging", v33.Config.ChargingSpeed / v33.Config.Speed);
                local v36 = ("%*/ChargeStart"):format(script.Parent);
                local l_pcall_2 = pcall;
                local v38 = "ChargeStart";
                local v39;
                l_pcall_2, v39 = l_pcall_2(function() --[[ Line: 24 ]]
                    -- upvalues: v33 (copy), v38 (copy)
                    if v33.Behavior[v38] then
                        v33.Behavior[v38](v33);
                    end;
                end);
                if not l_pcall_2 then
                    warn((("[%*]: Failed to call .ChargeStart() due to: %*"):format(v36, v39)));
                end;
                v33.Rig:SetAttribute("GuestCharging", true);
                v36 = ("Result%*"):format((tostring(math.random(-10000, 10000))));
                task.delay(0.125, function() --[[ Line: 141 ]]
                    -- upvalues: v33 (copy), v5 (ref), v7 (ref), v6 (ref), v3 (ref), v9 (ref), l_ReplicatedStorage_0 (ref), v36 (copy), v4 (ref)
                    local l_PrimaryPart_0 = v33.Rig.PrimaryPart;
                    local v41 = nil;
                    local v42 = nil;
                    local l_v5_Hitbox_0 = v5:CreateHitbox(v33.Player, {
						FriendlyFire = true,
						AbilityType = "AltAbility2",
                        Size = Vector3.new(4, 5, 6, 0), 
                        CFrameOffset = CFrame.new(0, 0, -1), 
						Damage = function(target)
							if target:GetAttribute("PreviouslyChargedInto") then
								return 0
							end

							return v33.Config.ChargeDamage
						end,
						Knockback = function(target)
							if target:GetAttribute("PreviouslyChargedInto") then
								return 0
							end

							local elapsed = workspace:GetServerTimeNow() - chargeStartedAt
							local progress = math.clamp(
								elapsed / v33.Config.ChargeKnockbackRampTime,
								0,
								1
							)

							local knockback = v33.Config.ChargeKnockback
								+ (
									v33.Config.ChargeKnockbackTotal
									- v33.Config.ChargeKnockback
								) * progress

							local Actors = require(game.ReplicatedStorage.Modules.Actors)
							local extraGuests = 0

							for _, actor in pairs(Actors.CurrentActors) do
								local humanoid = actor.Rig
									and actor.Rig:FindFirstChildOfClass("Humanoid")

								if actor ~= v33
									and actor.ActorName == "Guest1337Rework"
									and humanoid
									and humanoid.Health > 0 then

									extraGuests += 1
								end
							end

							return knockback * math.max(0, 1 - 0.10 * extraGuests)
						end,
                        Time = v33.Config.ChargingDuration, 
                        HitMultiple = true, 
                        Connections = {
                            Hit = function(v44) --[[ Line: 161 ]] --[[ Name: Hit ]]
                                -- upvalues: v41 (ref), v33 (ref), v7 (ref), l_PrimaryPart_0 (copy), v6 (ref), v3 (ref), v9 (ref), l_ReplicatedStorage_0 (ref)
                                v41 = v44;
                                if v41 then
                                    if not v41:GetAttribute("PreviouslyChargedInto") then
                                        v41:SetAttribute("PreviouslyChargedInto", true);
                                        task.delay(v33.Config.KillerChargeResistanceDuration, function() --[[ Line: 169 ]]
                                            -- upvalues: v41 (ref)
                                            v41:SetAttribute("PreviouslyChargedInto", nil);
                                        end);
                                        v7:Play(v33.Config.Sounds.ChargingHit, {
                                            Parent = l_PrimaryPart_0
                                        });
                                        if v41.Parent == workspace.Players.Killers then
                                            v6:FireAllClientConnection(("%*On1337ChargeHit"):format(v33.Player.Name), "REMOTE_EVENT");
                                        end;
                                        if v41:GetAttribute("VoidRushState") == "Dashing" then
                                            v9:IncrementAchievementProgress(v33.Player, "NoliCar");
                                            v9:IncrementAchievementProgress(game.Players:GetPlayerFromCharacter(v41), "NoliCar");
                                        end;
                                    else
                                        v3:ApplyDamage(v33.Rig, v33.Config.KillerChargeResistanceDamage);
                                        v7:Play(v33.Config.Sounds.ChargingHitWeak, {
                                            Parent = l_PrimaryPart_0
                                        });
                                        return;
                                    end;
                                end;                                
                            end, 
                            Ended = function() --[[ Line: 204 ]] --[[ Name: Ended ]]
                                -- upvalues: v42 (ref)
                                v42 = true;
                            end
                        }
                    });
                    local v47 = v7:Play(v33.Config.Sounds.ChargingStart, {
                        Parent = l_PrimaryPart_0
                    });
                    local v48 = false;
                    local v49 = ("%*Guest1337Collision"):format(v33.Player.Name);
                    v6:SetConnection(v49, "REMOTE_EVENT", function(v50) --[[ Line: 214 ]]
                        -- upvalues: v33 (ref), v48 (ref)
                        if v50 == v33.Player then
                            v48 = true;
                        end;
                    end);
                    repeat
                        task.wait();
                    until v41 or v42 or v48;
                    local v51 = ("%*/ChargeEnd"):format(script.Parent);
                    local l_v33_0 = v33;
                    local l_pcall_3 = pcall;
                    local v54 = "ChargeEnd";
                    local l_l_v33_0_0 = l_v33_0 --[[ copy: 8 -> 12 ]];
                    local l_v54_0 = v54 --[[ copy: 11 -> 13 ]];
                    local v57;
                    l_pcall_3, v57 = l_pcall_3(function() --[[ Line: 24 ]]
                        -- upvalues: l_l_v33_0_0 (copy), l_v54_0 (copy)
                        if l_l_v33_0_0.Behavior[l_v54_0] then
                            l_l_v33_0_0.Behavior[l_v54_0](l_l_v33_0_0);
                        end;
                    end);
                    if not l_pcall_3 then
                        warn((("[%*]: Failed to call .ChargeEnd() due to: %*"):format(v51, v57)));
                    end;
                    v33.Rig:SetAttribute("GuestCharging", nil);
                    v51 = "IDK";
                    if v41 then
                        v51 = "Hit";
                    elseif v48 then
                        v51 = "Collide";
                    elseif v42 then
                        v51 = "Timeout";
                    end;
                    v7:PlayVoiceline(v33, ("Charge%*"):format(v51), {
                        Priority = 1
                    });
                    l_v33_0 = Instance.new("StringValue");
                    l_v33_0.Name = v36;
                    l_v33_0.Value = v51;
                    l_v33_0.Parent = v33.Rig;
                    game.Debris:AddItem(l_v33_0, 1);
					if v51 == "Hit"
						and v41
						and (
							v41.Parent == workspace.Players.Killers
								or v41.Parent == workspace.Players.Survivors
						) then

						v4:ApplyStatus(v33.Player, "Resistance", {
							Level = 3,
							Duration = 0.5
						});
                    else
                        l_pcall_3, v57 = v3:GetClosestPlayerFromPosition(l_PrimaryPart_0.Position, {
                            PlayerSelection = "Killers"
                        });
                        if not v57 then
                            v57 = 999;
                        end;
                        v54 = math.clamp(math.floor(v57 / v33.Config.ChargePunishmentDistanceInterval) * v33.Config.ChargePunishmentSlownessDurationMultiplier, 0, v33.Config.ChargePunishmentSlownessMaxDuration);
                        if v54 > 0 then
                            v4:ApplyStatus(v33.Player, "Slowness", {
                                Duration = v54, 
                                Level = v33.Config.ChargePunishmentSlownessLevel
                            });
                        end;
                    end;
					task.delay(v33.Config.ChargeAbilityLockout, function()
						v33.DisabledAbilities = nil;
					end);
                    l_pcall_3 = v33 and v33.Rig;
                    if l_pcall_3 then
                        l_pcall_3:SetAttribute("AnimationsDisabled", nil);
                        l_pcall_3:SetAttribute("AnimationsExtraDisabled", nil);
                        l_pcall_3:SetAttribute("UsingItemsDisabled", nil);
                    end;
                    if v47 then
                        game.TweenService:Create(v47, TweenInfo.new(0.2), {
                            Volume = 0
                        }):Play();
                    end;
                    if v51 ~= "Hit" then
                        v7:Play(v33.Config.Sounds[("Charging%*"):format(v51)], {
                            Parent = l_PrimaryPart_0
                        });
                    end;
                    v6:RemoveConnection(v49, "REMOTE_EVENT");
                    l_v5_Hitbox_0:Cancel();
                    v3:SetSpeedCap(v33.Player, "GuestCharging", nil);
                end);
                return v36;
            else
                if l_RunService_0:IsClient() then
                    v33.Animations.Charge:Play();
                    v33.MovementAnimSpeed = 2.25;
					local v58 = require(
						l_ReplicatedStorage_0.Systems.Character.Game.Sprinting
					);

					local previousChargeStaminaGain = v58.StaminaGain;
					local previousChargeStaminaLoss = v58.StaminaLoss;
					local previousChargeSpeedLock = v58.isSpeedLocked;

					-- Keep sprint input active without adding sprint speed to Charge.
					v58.isSpeedLocked = true;
					v58.StaminaGain = 0;
					v58.StaminaLoss = 0;

					if v58.__currentSpeedTween then
						v58.__currentSpeedTween:Cancel();
						v58.__currentSpeedTween = nil;
					end;

					v58.__speedMultiplier.Value = 1;
                    local l_v3_FOVMultiplier_0 = v3:CreateFOVMultiplier(v33.Player, 1, "Guest1337Charge");
                    game.TweenService:Create(l_v3_FOVMultiplier_0, TweenInfo.new(0.8), {
                        Value = 0.75
                    }):Play();
                    local l_v3_SpeedMultiplier_0 = v3:CreateSpeedMultiplier(v33.Rig, v33.Config.ChargingSpeed / v33.Config.Speed, "Guest1337Charge");
                    local l_LookVector_0 = workspace.CurrentCamera.CFrame.LookVector;
                    local l_Unit_0 = Vector3.new(l_LookVector_0.X, 0, l_LookVector_0.Z).Unit;
                    local v63 = Vector3.new(0, 0, 0, 0);
                    local v64 = 0;
                    local v65 = false;
                    pcall(function() --[[ Line: 308 ]]
                        -- upvalues: l_RunService_0 (ref)
                        l_RunService_0:UnbindFromRenderStep("GuestCharging");
                    end);
                    do
                        local l_l_Unit_0_0, l_v63_0, l_v64_0, l_v65_0 = l_Unit_0, v63, v64, v65;
                        l_RunService_0:BindToRenderStep("GuestCharging", Enum.RenderPriority.Character.Value + 1, function(v70) --[[ Line: 309 ]]
                            -- upvalues: v33 (copy), l_RunService_0 (ref), l_v64_0 (ref), l_v65_0 (ref), v6 (ref), l_v63_0 (ref), l_l_Unit_0_0 (ref)
                            if not v33.Rig.Parent or not v33.Rig.PrimaryPart then
                                l_RunService_0:UnbindFromRenderStep("GuestCharging");
                                return;
                            else
                                l_v64_0 = l_v64_0 + v70;
                                if l_v64_0 >= 0.3 and v33.Rig.PrimaryPart.Velocity.Magnitude <= v33.Config.ChargingSpeed / 2 then
                                    if not l_v65_0 then
                                        l_v65_0 = true;
                                        v6:FireServerConnection(("%*Guest1337Collision"):format(v33.Player.Name), "REMOTE_EVENT");
                                    end;
                                    return;
                                else
                                    local l_LookVector_1 = workspace.CurrentCamera.CFrame.LookVector;
                                    l_v63_0 = Vector3.new(l_LookVector_1.X, 0, l_LookVector_1.Z).Unit;
                                    local v72 = l_v63_0 - l_l_Unit_0_0;
                                    local l_Magnitude_0 = v72.Magnitude;
                                    if l_Magnitude_0 > 0 then
                                        local v74 = v33.Config.ChargingTurnSpeed * v70;
                                        if l_Magnitude_0 <= v74 then
                                            l_l_Unit_0_0 = l_v63_0;
                                        else
                                            l_l_Unit_0_0 = l_l_Unit_0_0 + v72.Unit * v74;
                                        end;
                                        l_l_Unit_0_0 = l_l_Unit_0_0.Unit;
                                    end;
                                    v33.Rig.Humanoid:Move(l_l_Unit_0_0);
                                    return;
                                end;
                            end;
                        end);
                        local v75 = v33.Rig:WaitForChild(v34, v33.Config.ChargingDuration + 0.5);
                        local v76 = v75 and v75.Value;
                        if v75 then
                            v75:Destroy();
                        end;
						if v76 == "Collide" then
                            local l_v3_SpeedMultiplier_1 = v3:CreateSpeedMultiplier(v33.Rig, 0.2, "GuestChargeEnded");
                            game.TweenService:Create(l_v3_SpeedMultiplier_1, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                                Value = 1
                            }):Play();
                            game.Debris:AddItem(l_v3_SpeedMultiplier_1, 1);
                        end;
                        l_RunService_0:UnbindFromRenderStep("GuestCharging");
                        v33.Animations.Charge:Stop();
                        v33.MovementAnimSpeed = nil;
                        game.TweenService:Create(l_v3_FOVMultiplier_0, TweenInfo.new(0.4), {
                            Value = 1
                        }):Play();
                        game.Debris:AddItem(l_v3_FOVMultiplier_0, 0.4);
                        l_v3_SpeedMultiplier_0:Destroy();
						v58.isSpeedLocked = previousChargeSpeedLock;
						v58.StaminaGain = previousChargeStaminaGain;
						v58.StaminaLoss = previousChargeStaminaLoss;
						v58:Resync();
                    end;
                end;
                return;
            end;
        end
    }, 
    Punch = {
        LayoutOrder = 3, 
        KeybindType = "AltAbility3", 
        Icon = "rbxassetid://86535502112498", 
        Callback = function(v78, v79) --[[ Line: 379 ]] --[[ Name: Callback ]]
            -- upvalues: l_RunService_0 (copy), v4 (copy), v7 (copy), v3 (copy), v5 (copy), v9 (copy), l_ReplicatedStorage_0 (copy), v6 (copy)
            local v80
            if l_RunService_0:IsServer() then
                v80 = v78.Blocked == true
            else
                v80 = v79 == true
            end
            local v81 = v80 and "Parry" or "Punch";
            local function _(v82) --[[ Line: 383 ]] --[[ Name: getConfig ]]
                -- upvalues: v78 (copy), v81 (copy)
                return v78.Config[("%*%*"):format(v81, v82)];
            end;
            if l_RunService_0:IsServer() then
                cancelGuestBlockTask(v78, "BlockedThread")
                setGuestParryWindow(v78, false)
                v78.AbilitiesDisabled = true;
                task.delay(2, function() --[[ Line: 390 ]]
                    -- upvalues: v78 (copy)
                    v78.AbilitiesDisabled = false;
                end);
                if v81 == "Parry" then
                    v4:ApplyStatus(v78.Rig, "Resistance", {
                        Level = 3, 
                        Duration = v78.Config.ParryWindupTime
                    });
                    local v84 = ("%*/Start"):format(script.Parent);
                    local l_pcall_4 = pcall;
                    local v86 = "ParryStart";
                    local v87;
                    l_pcall_4, v87 = l_pcall_4(function() --[[ Line: 24 ]]
                        -- upvalues: v78 (copy), v86 (copy)
                        if v78.Behavior[v86] then
                            v78.Behavior[v86](v78);
                        end;
                    end);
                    if not l_pcall_4 then
                        warn((("[%*]: Failed to call .ParryStart() due to: %*"):format(v84, v87)));
                    end;
                end;
                v7:Play(v78.Config.Sounds.PunchWindup, {
                    Parent = v78.Rig.PrimaryPart
                });
                v7:PlayVoiceline(v78, ("%*Windup"):format(v81), {
                    Priority = 1
                });
                task.delay(v78.Config[("%*WindupTime"):format(v81)], function() --[[ Line: 406 ]]
                    -- upvalues: v3 (ref), v78 (copy), v81 (copy), v5 (ref), v7 (ref), v4 (ref), v80 (copy), v9 (ref), l_ReplicatedStorage_0 (ref)
                    local v88 = v3:ApplyVelocity(v78.Rig.PrimaryPart, v78.Config[("%*DashForce"):format(v81)]);
					local Actors = require(game.ReplicatedStorage.Modules.Actors)
					local extraGuests = 0

					for _, actor in pairs(Actors.CurrentActors) do
						local humanoid = actor.Rig
							and actor.Rig:FindFirstChildOfClass("Humanoid")

						if actor ~= v78
							and actor.ActorName == "Guest1337Rework"
							and humanoid
							and humanoid.Health > 0 then

							extraGuests += 1
						end
					end

					local punchDebuffDuration = math.max(
						0,
						v78.Config.PunchDebuffDuration - 0.35 * extraGuests
					)

					local punchKnockbackMultiplier = math.max(
						0,
						1 - 0.10 * extraGuests
					)
                    game.Debris:AddItem(v88, 0.1);
                    local parryConnected = false
                    local _ = v5:CreateHitbox(v78.Player, {
						FriendlyFire = true,
						AbilityType = "AltAbility3",
                        Size = Vector3.new(4.5, 6, 7.5, 0), 
                        CFrameOffset = CFrame.new(0, 0, -1), 
                        Damage = v78.Config[("%*Damage"):format(v81)], 
                        Time = 0.25, 
						Knockback = v78.Config[("%*Knockback"):format(v81)]
							* punchKnockbackMultiplier,
						HitMultiple = not not v80,
                        Connections = {
                            Hit = function(v89) --[[ Line: 423 ]] --[[ Name: Hit ]]
                                -- upvalues: v7 (ref), v78 (ref), v81 (ref), v4 (ref), v80 (ref), v9 (ref), l_ReplicatedStorage_0 (ref)
                                if v80 and not parryConnected then
                                    parryConnected = true
                                    if v88 and v88.Parent then v88:Destroy() end
                                    stopGuestParryMotion(v78.Rig)
                                    v6:FireClientConnection(v78.Player,
                                        v78.Player.Name .. "1337ReworkParryStop", "REMOTE_EVENT", v78.Rig)
                                end
                                v7:Play(v78.Config.Sounds[v81], {
                                    Parent = v89.PrimaryPart or v78.Rig.PrimaryPart
                                });
                                v7:PlayVoiceline(v78, ("%*Hit"):format(v81), {
                                    Priority = 1
                                });
								if v80 then
									v4:ApplyStatus(v89, "Stunned", {
										Level = 1,
										Duration = v78.Config.ParryStunTime
									});
								elseif punchDebuffDuration > 0 then
									v4:ApplyStatus(v89, "Helpless", {
										Level = 1,
										Duration = punchDebuffDuration
									});

									v4:ApplyStatus(v89, "Slowness", {
										Level = 2,
										Duration = punchDebuffDuration
									});
								end;
                                if v80 then
                                    v9:IncrementAchievementProgress(v78.Player, "GuestParry");
                                    local v90 = ("%*/Hit"):format(script.Parent);
                                    local l_v78_0 = v78;
                                    local l_pcall_5 = pcall;
                                    local v93 = "ParryHit";
                                    local l_l_v78_0_0 = l_v78_0 --[[ copy: 2 -> 7 ]];
                                    local l_v93_0 = v93 --[[ copy: 5 -> 8 ]];
                                    local v96;
                                    l_pcall_5, v96 = l_pcall_5(function() --[[ Line: 24 ]]
                                        -- upvalues: l_l_v78_0_0 (copy), l_v93_0 (copy)
                                        if l_l_v78_0_0.Behavior[l_v93_0] then
                                            l_l_v78_0_0.Behavior[l_v93_0](l_l_v78_0_0);
                                        end;
                                    end);
                                    if not l_pcall_5 then
                                        warn((("[%*]: Failed to call .ParryHit() due to: %*"):format(v90, v96)));
                                    end;
                                end;
                                if v78.Rig.PrimaryPart.AssemblyLinearVelocity.Y < -8 then
									v7:Play(v78.Config.Sounds.CriticalPunch, {
										Parent = v89.PrimaryPart or v78.Rig.PrimaryPart,
										Volume = 0.1
									});
                                    v9:IncrementAchievementProgress(v78.Player, "GuestAlpha");
                                end;
                                local v97 = v80 and "Parried" or "Punched";
                                v78.Rig:SetAttribute(v97, true);
                                task.delay(0.25, function() --[[ Line: 441 ]]
                                    -- upvalues: v78 (ref), v97 (copy)
                                    v78.Rig:SetAttribute(v97, nil);
                                end);
                                local v98 = require(l_ReplicatedStorage_0.Modules.Actors);
                                if v80 then
                                    local l_v78_1 = v78;
                                    local l_pcall_6 = pcall;
                                    local v101 = "OnParry";
                                    local v102;
                                    l_pcall_6, v102 = l_pcall_6(function() --[[ Line: 24 ]]
                                        -- upvalues: l_v78_1 (copy), v101 (copy)
                                        if l_v78_1.Behavior[v101] then
                                            l_v78_1.Behavior[v101](l_v78_1);
                                        end;
                                    end);
                                    if not l_pcall_6 then
                                        warn((("[Guest1337]: Failed to call .OnParry() due to: %*"):format(v102)));
                                    end;
                                    v98:IncrementActorStats(v78.Player, {
                                        Action = "Parried Killer as Guest 1337", 
                                        RewardType = "Offensive"
                                    });
                                    return;
                                else
                                    v98:IncrementActorStats(v78.Player, {
                                        Action = "Punched Killer as Guest 1337", 
                                        RewardType = "Offensive"
                                    });
                                    return;
                                end;
                            end
                        }
                    });
                end);
                return v80;
            else
                if l_RunService_0:IsClient() then
                    local v104 = v78.Animations[v80 and "ParryPunch" or "Punch"];
                    if v104 then
                        v104:Play();
                        if not v78.Config.RawAnims then
                            v104:AdjustSpeed((v104.Length - 0.55) / v78.Config[("%*WindupTime"):format(v81)]);
                        end;
                    end;
                    v6:FireConnection("DisableSprinting", "GuestPunch", true);
                    local l_v3_SpeedMultiplier_2 = v3:CreateSpeedMultiplier(v78.Rig, 1, "PunchAbility");
                    game.TweenService:Create(l_v3_SpeedMultiplier_2, TweenInfo.new(0.25), {
                        Value = 0.25
                    }):Play();
                    task.wait(v80 and v78.Config.ParryWindupTime or v78.Config.PunchWindupTime);
                    task.wait(0.8);
                    v6:FireConnection("DisableSprinting", "GuestPunch", false);
                    game.TweenService:Create(l_v3_SpeedMultiplier_2, TweenInfo.new(0.15), {
                        Value = 1
                    }):Play();
                    game.Debris:AddItem(l_v3_SpeedMultiplier_2, 0.15);
                end;
                return;
            end;
        end
    }
};
v2.cl_OnChargeProcGlobal = function(_, v107, v108) --[[ Line: 498 ]] --[[ Name: cl_OnChargeProcGlobal ]]
    -- upvalues: v7 (copy)
    v7:Play(v107.Config.Sounds.ChargeCooldownActivated);
    local l_Charge_0 = v107.Behavior.Abilities.Charge;
    if l_Charge_0 then
        l_Charge_0.CurrentRecharge = 0;
        l_Charge_0.ChargeDuration = v108.Config.KillerChargeResistanceDuration;
    end;
end;
v2.OnHit = function(_, v111, v112) --[[ Line: 507 ]] --[[ Name: OnHit ]]
	-- special attacks and projectiles breaks block.
	if v111.Blocking
		and v112.Creator
		and (
			v112.IsProjectile
				or v112.AbilityType ~= "MainAbility"
		) then

		local rawDamage = typeof(v112.Damage) == "function"
			and v112.Damage(v111.Rig)
			or v112.Damage
			or 0

		-- guarding/parry state before registerin' the hit.
		resolveGuestBlock(v111)
		setGuestParryWindow(v111, false)

		if v111.BlockedThread then
			task.cancel(v111.BlockedThread)
			v111.BlockedThread = nil
		end

		if v111.BlockThread then
			task.cancel(v111.BlockThread)
			v111.BlockThread = nil
		end

		-- Restore movement and the normal query hitbox.
		if v111.BlockingSlowness then
			v111.BlockingSlowness:Destroy()
			v111.BlockingSlowness = nil
		end

		local queryHitbox = v111.Rig:FindFirstChild("QueryHitbox")
		if queryHitbox and v111.__blockDefaultHitboxSize then
			queryHitbox.Size = v111.__blockDefaultHitboxSize
		end

		v111.Rig:SetAttribute("HitboxPriority", 2)

		if v111.Behavior.BlockEnd then
			v111.Behavior.BlockEnd(v111)
		end

		-- Replace the blocking Resistance with post-break Resistance.
		v4:RemoveStatus(v111.Player, "Resistance")
		v4:ApplyStatus(v111.Player, "Resistance", {
			Level = 2,
			Duration = 3
		})

		-- Hitboxes applies this once, then continues normal hit effects.
		v6:FireClientConnection(
			v111.Player,
			v111.Player.Name .. "1337ReworkBlockBroken",
			"REMOTE_EVENT"
		)
		return {
			DamageOverride = rawDamage * 0.6
		}
	end
	if not v112.IsProjectile
		and v112.AbilityType == "MainAbility"
		and v112.Creator
		and v111.Blocking then
        resolveGuestBlock(v111);
		v111:SetCooldownOf("Punch", 0);
        v7:Play(v111.Config.Sounds.BlockSuccess, {
            Parent = v111.Rig.PrimaryPart
        });
        local v113 = typeof(v112.Damage) == "function" and v112.Damage(v111.Rig) or v112.Damage or 0;
        local l_Health_0 = v111.Rig.Humanoid.Health;
		-- Reworked Guest Shit, please work ;-;
		local humanoid = v111.Rig:FindFirstChildOfClass("Humanoid")

		if humanoid then
			local currentOverheal = humanoid:GetAttribute("Overheal") or 0
			local protectedFloor = humanoid:GetAttribute("OverhealDecayMin") or 0

			local gain = math.clamp(
				v111.Config.BlockOverhealCap - currentOverheal,
				0,
				v111.Config.BlockOverhealGain
			)

			if gain > 0 then
				v3:ApplyOverheal(v111.Rig, currentOverheal + gain)
				humanoid:SetAttribute("OverhealDecayMin", protectedFloor + gain)
			end
		end
        local l_v3_SpeedMultiplier_3 = v3:CreateSpeedMultiplier(v112.Creator, 1 * v111.Config.KillerSlownessPercent / 100);
        if l_v3_SpeedMultiplier_3 then
            game.Debris:AddItem(l_v3_SpeedMultiplier_3, v111.Config.KillerSlownessDuration);
        end;
        v4:ApplyStatus(v111.Player, "Speed", {
            Level = v111.Config.BlockSpeedLevel, 
            Duration = v111.Config.BlockSpeedDuration
        });
        v4:RemoveStatus(v111.Player, "Resistance");

        if v111.BlockedThread then
            task.cancel(v111.BlockedThread);
        end;
        setGuestParryWindow(v111, true);
        v111.BlockedThread = task.delay(v111.Config.BlockDuration, function() --[[ Line: 542 ]]
            -- upvalues: v111 (copy)
            setGuestParryWindow(v111, false);
        end);
        local v116 = ("%*/BlockEnd"):format(script.Parent);
        local l_pcall_7 = pcall;
        local v118 = "BlockEnd";
        local l_v118_0 = v118 --[[ copy: 9 -> 10 ]];
        local v120;
        l_pcall_7, v120 = l_pcall_7(function() --[[ Line: 24 ]]
            -- upvalues: v111 (copy), l_v118_0 (copy)
            if v111.Behavior[l_v118_0] then
                v111.Behavior[l_v118_0](v111);
            end;
        end);
        if not l_pcall_7 then
            warn((("[%*]: Failed to call .BlockEnd() due to: %*"):format(v116, v120)));
        end;
        v116 = v111.Rig:FindFirstChild("QueryHitbox");
        if v116 and v111.__blockDefaultHitboxSize then
            v116.Size = v111.__blockDefaultHitboxSize;
        end;
        require(l_ReplicatedStorage_0.Modules.Actors):IncrementActorStats(v111.Player, {
            Action = "Successfully blocked an attack", 
            RewardType = "Survivalist"
        });
        if not v111.BlockCount then
            v111.BlockCount = 0;
        end;
        v111.BlockCount = v111.BlockCount + 1;
        if v111.BlockCount >= 3 then
            v9:IncrementAchievementProgress(v111.Player, "GuestBlock");
        end;
        v120 = l_Health_0 < v113;
        v118 = require(game.ServerScriptService.Server.Systems.Core.RoundManager);
        if v120 and v118.CurrentSession and v118.CurrentSession.LastSurvivorAlive then
            v111.Daigo = true;
        end;
        return "Ignored";
    else
        return;
    end;
end;
v2.Created = function(_, v122) --[[ Line: 578 ]] --[[ Name: Created ]]
    -- upvalues: l_RunService_0 (copy), v6 (copy), v3 (copy)
    if l_RunService_0:IsServer() then
        v122.Rig:SetAttribute("HitboxPriority", 2);
        return;
    else
		if v122.Player == game.Players.LocalPlayer then
            v6:SetConnection(v122.Player.Name .. "1337ReworkParryStop", "REMOTE_EVENT", function(rig)
                if rig == v122.Rig and rig == game.Players.LocalPlayer.Character then
                    stopGuestParryMotion(rig)
                end
            end)

			v6:SetConnection(
				v122.Player.Name .. "1337ReworkBlockBroken",
				"REMOTE_EVENT",
				function()
					if not v122.Rig or not v122.Rig.Parent then
						return
					end

					local animations = v122.Animations
					if not animations then
						return
					end

					-- Stop the guarding pose before playing the break agyluugyuaydgakdjhkhjdakhjg WHY IS THIS PAIN 2 MAKE!!!
					if animations.Block then
						animations.Block:Stop(0)
					end

					local broken = animations.BlockBroken
					if broken then
						broken.Looped = false
						broken:Play(0)
					else
						warn("[Guest Rework] BlockBroken animation is missing")
					end
				end
			)
		end
        v6:SetConnection(("%*On1337ChargeHit"):format(v122.Player.Name), "REMOTE_EVENT", function() --[[ Line: 583 ]]
            -- upvalues: v3 (ref), v122 (copy)
            local l_v3_Actor_0 = v3:GetActor(game.Players.LocalPlayer);
            if v122 and l_v3_Actor_0 and l_v3_Actor_0.Behavior.cl_OnChargeProcGlobal then
                l_v3_Actor_0.Behavior:cl_OnChargeProcGlobal(l_v3_Actor_0, v122);
            end;
        end);
        return;
    end;
end;
v2.CreatedPost = function(_, actor)
    if l_RunService_0:IsServer() or actor.Player ~= game.Players.LocalPlayer then return end
    local trove = v8.new()
    actor.__parryTrove = trove
    local mainUI = actor.Player.PlayerGui:WaitForChild("MainUI", 5)
    local container = mainUI and mainUI:WaitForChild("AbilityContainer", 5)
    local button = container and container:WaitForChild("Punch", 5)
    if not button or actor.__parryTrove ~= trove then return end
    local previous, stroke
    local function refresh()
        local deadline = actor.Rig:GetAttribute("GuestReworkParryUntil") or 0
        local active = deadline > workspace:GetServerTimeNow()
        if active == previous then return end
        previous = active
        button.ImageColor3 = active and v10 or v11
        local icon = active and "rbxassetid://76339130778616" or "rbxassetid://86535502112498"
        button.Image = icon
        local label = button:FindFirstChild("AbilityName")
        if label then
            label.Text = active and "Parry" or "Punch"
            label.TextColor3 = active and v12 or v13
        end
        local keybind = button:FindFirstChild("KeybindName")
        if keybind then keybind.TextColor3 = active and v12 or v13 end
        local charges = button:FindFirstChild("Charges")
        if charges then charges.Visible = false end
        if stroke then stroke:Destroy(); stroke = nil end
        if active and label and actor.Config.ParryUIStroke then
            stroke = actor.Config.ParryUIStroke:Clone()
            stroke.Parent = label
        end
    end
    trove:Add(function() if stroke then stroke:Destroy(); stroke = nil end end)
    trove:Add(actor.Rig:GetAttributeChangedSignal("GuestReworkParryUntil"):Connect(refresh))
    -- Expire the indicator on time even if the server's clear arrives late.
    trove:Add(l_RunService_0.Heartbeat:Connect(refresh))
    refresh()
end
v2.Destroyed = function(_, v134)
    if l_RunService_0:IsServer() then
        cancelGuestBlockTask(v134, "BlockThread")
        cancelGuestBlockTask(v134, "__blockSlowThread")
        cancelGuestBlockTask(v134, "__blockUnlockThread")
        cancelGuestBlockTask(v134, "BlockedThread")
        clearGuestBlockSlow(v134)
        v134.Blocking = nil
        setGuestParryWindow(v134, false)
        v134:DisableAbilities("GuestReworkBlock", false)
    end

	if l_RunService_0:IsServer() then
		return
	end

	if v134.Player == game.Players.LocalPlayer then
        v6:RemoveConnection(v134.Player.Name .. "1337ReworkParryStop", "REMOTE_EVENT")
		v6:RemoveConnection(
			v134.Player.Name .. "1337ReworkBlockBroken",
			"REMOTE_EVENT"
		)
	end

	if v134.__parryTrove then
		v134.__parryTrove:Destroy()
		v134.__parryTrove = nil
	end

	v6:RemoveConnection(
		("%*On1337ChargeHit"):format(v134.Player.Name),
		"REMOTE_EVENT"
	)
end

return v2