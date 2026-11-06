-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: NewBehavior, time of decompilation: Fri Nov 28 21:07:34 2025 ]]
local _ = require(game.ReplicatedStorage.GlobalTypes);
local l_ReplicatedStorage_0 = game:GetService("ReplicatedStorage");
local l_RunService_0 = game:GetService("RunService");
local l_TweenService_0 = game:GetService("TweenService");
local l_Players_0 = game:GetService("Players");
local l_Debris_0 = game:GetService("Debris");
local _ = game:GetService("Lighting");
local v7 = require(l_ReplicatedStorage_0.Modules.Sounds);
local v8 = require(l_ReplicatedStorage_0.Modules.Actors);
local v9 = require(l_ReplicatedStorage_0.Modules.Ragdolls);
local v10 = require(l_ReplicatedStorage_0.Modules.Schematics.Lighting);
local v11 = require(l_ReplicatedStorage_0.Modules.Util);
local v12 = require(l_ReplicatedStorage_0.Systems.Character.Game.Sprinting);
local v13 = require(l_ReplicatedStorage_0.Modules.Hitboxes);
local v14 = require(l_ReplicatedStorage_0.Modules.Misc.Maid);
local v15 = require(l_ReplicatedStorage_0.Modules.Statuses);
local v16 = require(l_ReplicatedStorage_0.Modules.Network);
local v17 = require(l_ReplicatedStorage_0.Modules.AchievementUtil);
local l_random_0 = math.random;
local l_insert_0 = table.insert;
local l_sort_0 = table.sort;
local l_wait_0 = task.wait;
local l_spawn_0 = task.spawn;
local l_delay_0 = task.delay;
local l_close_0 = coroutine.close;
local v25 = l_RunService_0:IsClient();
local v26 = l_RunService_0:IsServer();
local _ = l_RunService_0:IsStudio();
local v28 = TweenInfo.new(1);
local v29 = Random.new();
local v30 = TweenInfo.new(0.2);
local v31 = v25 and l_Players_0.LocalPlayer;
local v32 = v25 and workspace.CurrentCamera;
local function _(v33) --[[ Line: 42 ]] --[[ Name: __displayWarn ]]
	warn((("[Slasher]: %*"):format(v33)));
end;
local function v40(v35, v36, ...) --[[ Line: 56 ]] --[[ Name: __pcallMethod ]]
	assert(v35, "bad moduleInfo, must be a table");
	local l_status_0, l_result_0 = pcall(function(...) --[[ Line: 59 ]]
		-- upvalues: v35 (copy), v36 (copy)
		if v35[v36] then
			return v35[v36](...);
		else
			return;
		end;
	end, ...);
	if not l_status_0 then
		local v39 = ("Failed to call :%*() due to: %*"):format(v36, l_result_0);
		warn((("[Slasher]: %*"):format(v39)));
	end;
	return l_status_0, l_result_0;
end;
local function _(v41, v42, v43) --[[ Line: 72 ]] --[[ Name: __getEnragedStat ]]
	return v41.State.isEnraged and v41.Config[("Enraged%*%*"):format(v42, v43)] or v41.Config[("%*%*"):format(v42, v43)];
end;
local _ = function(v45) --[[ Line: 79 ]] --[[ Name: __getDictionaryIndexes ]]
	-- upvalues: l_insert_0 (copy)
	local v46 = {};
	for v47, _ in pairs(v45) do
		l_insert_0(v46, v47);
	end;
	return v46;
end;
local function v53(v50, v51, v52) --[[ Line: 90 ]] --[[ Name: __playSound ]]
	-- upvalues: v7 (copy), v29 (copy)
	assert(v50.Config.Sounds[v51], "bad soundName, does not exist");
	return v7:Play(v50.Config.Sounds[v51], {
		Parent = v50.Rig.PrimaryPart, 
		PlaybackSpeed = v29:NextNumber(0.975, 1.025), 
		Looped = v52 or false, 
		Volume = 0.25
	});
end;
local function v60(v54) --[[ Line: 104 ]] --[[ Name: __resetEnragedState ]]
	-- upvalues: v26 (copy), v11 (copy), v7 (copy), v40 (copy), v16 (copy), v25 (copy), l_TweenService_0 (copy), v28 (copy), l_Debris_0 (copy), v12 (copy)
	local l_Rig_0 = v54.Rig;
	if v54.State.isEnraged and l_Rig_0 and l_Rig_0.Parent then
		v54.State.isEnraged = false;
		if v26 then
			v11:RemoveInvincible(l_Rig_0, "Raging");
			v54:ChangeExpression("Default");
			local l_EnragedSFX_0 = v54.Instances.EnragedSFX;
			if l_EnragedSFX_0 then
				l_EnragedSFX_0:Destroy();
				v54.Instances.EnragedSFX = nil;
			end;
			v7:Play(v54.Config.Sounds.EnragedEnd, {
				Parent = v54.Rig.PrimaryPart
			});
			for _, v58 in v54.Instances.EnragedVisuals do
				v58.Enabled = false;
			end;
			v40(v54.Behavior, "EnragedEnd", v54.Behavior, v54);
			v16:FireClientConnection(v54.Player, ("%*EnrageStateAsync"):format(v54.Player.Name), "REMOTE_EVENT");
			return;
		elseif v25 then
			v54.AnimationType = nil;
			v54.MovementAnimSpeed = nil;
			v16:FireConnection("DisableSprinting", "ENRAGED", false);
			if v54.Meta.TargetedPlayer then
				v11:RevealPlayerAura(v54.Meta.TargetedPlayer, v54.Config.EnragedAuraLingerTime);
				v54.Meta.TargetedPlayer = nil;
			end;
			if v54.Instances.SpeedModifier then
				l_TweenService_0:Create(v54.Instances.SpeedModifier, v28, {
					Value = 1
				}):Play();
				l_Debris_0:AddItem(v54.Instances.SpeedModifier, 1);
			end;
			local l_v11_SpeedMultiplier_0 = v11:CreateSpeedMultiplier(v54.Rig, 0.001, "Pacified");
			l_TweenService_0:Create(l_v11_SpeedMultiplier_0, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
				Value = 1
			}):Play();
			l_Debris_0:AddItem(l_v11_SpeedMultiplier_0, 1);
			v12.StaminaCap = nil;
		end;
	end;
end;
return {
	Abilities = {
		Slash = {
			LayoutOrder = 1, 
			Icon = "rbxassetid://97183429269286", 
			KeybindType = "MainAbility", 
			Cooldown = function(v61, v62) --[[ Line: 165 ]] --[[ Name: Cooldown ]]
				return v61.State.isEnraged and v61.Config[("Enraged%*Cooldown"):format(v62)] or v61.Config[("%*Cooldown"):format(v62)];
			end, 
			Callback = function(v63) --[[ Line: 166 ]] --[[ Name: Callback ]]
				-- upvalues: v26 (copy), v53 (copy), l_delay_0 (copy), v11 (copy), l_TweenService_0 (copy), v28 (copy), l_Debris_0 (copy), l_wait_0 (copy), v60 (copy), v13 (copy), v15 (copy), v40 (copy), v25 (copy)
				if v26 then
					local l_Rig_1 = v63.Rig;
					v63.AbilitiesDisabled = true;
					v53(v63, "Swing");
					local l_isEnraged_0 = v63.State.isEnraged;
					if not v63.State.isEnraged or not v63.Config.EnragedSlashDamage then
						local _ = v63.Config.SlashDamage;
					end;
					l_delay_0(0.075, function() --[[ Line: 178 ]]
						-- upvalues: l_isEnraged_0 (copy), v11 (ref), l_Rig_1 (copy), v63 (copy), l_TweenService_0 (ref), v28 (ref), l_Debris_0 (ref), l_wait_0 (ref), v60 (ref)
						if l_isEnraged_0 then
							local v67 = v11:ApplyVelocity(l_Rig_1.PrimaryPart, v63.Config.EnragedSlashLungeForce);
							l_TweenService_0:Create(v67, v28, {
								LineVelocity = v67.LineVelocity / 100
							}):Play();
							l_Debris_0:AddItem(v67, 0.6);
						end;
						l_wait_0(0.5);
						v60(v63);
						l_wait_0(0.275);
						v63.AbilitiesDisabled = false;
					end);
					l_delay_0(v63.Config.SlashWindup, function() --[[ Line: 196 ]]
						-- upvalues: v13 (ref), v63 (copy), v15 (ref), v11 (ref), v40 (ref), v53 (ref), l_isEnraged_0 (copy)
						local l_v13_0 = v13;
						local l_Player_0 = v63.Player;
						local v70 = {
							Size = Vector3.new(4.5, 6, 7.5, 0), 
							CFrameOffset = CFrame.new(0, 0, -1.25)
						};
						local l_v63_0 = v63;
						v70.Damage = l_v63_0.State.isEnraged and l_v63_0.Config.EnragedSlashDamage or l_v63_0.Config.SlashDamage;
						v70.Time = v63.Config.SlashLinger;
						v70.Knockback = 2;
						v70.HitMultiple = true;
						v70.ExecuteOnKill = true;
						v70.Connections = {
							Hit = function(v72, v73) --[[ Line: 208 ]] --[[ Name: Hit ]]
								-- upvalues: v15 (ref), v11 (ref), v63 (ref), v40 (ref), v53 (ref), l_isEnraged_0 (ref)
								local v74 = v15:PlayerHasStatus(v72, "Gouged");
								v11:CreateSpeedMultiplier(v72, 1.5, "HitSpeedBonus", 1.25);
								v15:ApplyStatus(v72, "Bleeding", {
									Level = 1, 
									Duration = v63.Config.SlashStatusTime + (v74 and 2 or 0)
								});
								if v73 then
									v40(v63.Behavior, "OnSlashHit", v63.Behavior, v72);
									v53(v63, "Hit");
								end;
								if v74 and not l_isEnraged_0 then
									v15:RemoveStatus(v72, "Gouged");
									return;
								else
									if l_isEnraged_0 then
										v15:ApplyStatus(v72, "Gouged", {
											Killer = v63, 
											Level = 1, 
											Duration = 8
										});
									end;
									return;
								end;
							end
						};
						l_v13_0 = l_v13_0:CreateHitbox(l_Player_0, v70);
					end);
					return;
				else
					if v25 then
						v63.Animations.Slash:Play(0.025);
					end;
					return;
				end;
			end
		}, 
		Behead = {
			LayoutOrder = 2, 
			Icon = "rbxassetid://115283980500353", 
			KeybindType = "AltAbility1", 
			Cooldown = function(v75, v76) --[[ Line: 247 ]] --[[ Name: Cooldown ]]
				return v75.State.isEnraged and v75.Config[("Enraged%*Cooldown"):format(v76)] or v75.Config[("%*Cooldown"):format(v76)];
			end, 
			Callback = function(v77) --[[ Line: 248 ]] --[[ Name: Callback ]]
				-- upvalues: v26 (copy), v53 (copy), l_delay_0 (copy), v13 (copy), l_random_0 (copy), v17 (copy), v8 (copy), v11 (copy), v15 (copy), v60 (copy), l_wait_0 (copy), v25 (copy), l_TweenService_0 (copy), l_Debris_0 (copy)
				if v26 then
					local l_isEnraged_1 = v77.State.isEnraged;
					local l_Rig_2 = v77.Rig;
					v77.AbilitiesDisabled = true;
					v53(v77, "Swing");
					l_delay_0(v77.Config.BeheadWindup, function() --[[ Line: 258 ]]
						-- upvalues: v13 (ref), v77 (copy), l_isEnraged_1 (copy), l_random_0 (ref), v17 (ref), v8 (ref), v11 (ref), v15 (ref), v53 (ref), v60 (ref), l_wait_0 (ref), l_Rig_2 (copy)
						local l_v13_1 = v13;
						local l_Player_1 = v77.Player;
						local v82 = {
							Size = Vector3.new(8, 2, 7, 0), 
							CFrameOffset = CFrame.new(0, 0, -2)
						};
						local l_v77_0 = v77;
						v82.Damage = l_v77_0.State.isEnraged and l_v77_0.Config.EnragedBeheadDamage or l_v77_0.Config.BeheadDamage;
						v82.Time = v77.Config.BeheadLinger;
						v82.Knockback = 2;
						v82.HitMultiple = true;
						v82.Connections = {
							Hit = function(v84, v85) --[[ Line: 269 ]] --[[ Name: Hit ]]
								-- upvalues: l_isEnraged_1 (ref), v77 (ref), l_random_0 (ref), v17 (ref), v8 (ref), v11 (ref), v15 (ref), v53 (ref), v60 (ref)
								local l_Humanoid_0 = v84:FindFirstChildOfClass("Humanoid");
								if l_isEnraged_1 then
									v77:SetCooldownOf("Behead", 0);
								end;
								if l_Humanoid_0 and l_Humanoid_0.Health <= 0 then
									local v87 = v84:FindFirstChild("Torso") and v84:FindFirstChild("Head") and v84.Torso:FindFirstChild("Neck");
									if v87 then
										v87.Enabled = false;
										v84.Head.CanCollide = true;
										v84.Head.Velocity = Vector3.new(l_random_0(-9, 9), 35, l_random_0(-9, 9));
									end;
									v17:IncrementAchievementProgress(v77.Player, "JasonBrutality");
									if v84.Parent.Name == "Survivors" then
										v8:IncrementActorStats(v77.Player, {
											Action = "Killed a Survivor with Behead", 
											RewardType = "DifficultKillerAction"
										});
									end;
								else
									v11:CreateSpeedMultiplier(v84, 1.5, "HitSpeedBonus", 0.9);
									v15:ApplyStatus(v84, "Helpless", {
										Level = 1, 
										Duration = v77.Config.BeheadStatusTime
									});
									v15:ApplyStatus(v84, "Gouged", {
										Killer = v77, 
										Level = 1, 
										Duration = v77.Config.BeheadStatusTime
									});
									v84.PrimaryPart.Anchored = true;
									task.delay(0.01, function() --[[ Line: 308 ]]
										-- upvalues: v84 (copy)
										v84.PrimaryPart.Anchored = false;
									end);
									if v84.Parent.Name == "Survivors" then
										v8:IncrementActorStats(v77.Player, {
											Action = "Landed Behead hit", 
											RewardType = "EasyKillerAction"
										});
									end;
								end;
								if v85 then
									v53(v77, "Hit");
									v60(v77);
								end;
							end
						};
						l_v13_1:CreateHitbox(l_Player_1, v82);
						l_wait_0(0.2);
						v60(v77);
						v15:ApplyStatus(l_Rig_2, "Slowness", {
							Level = 1, 
							Duration = 2
						});
						l_wait_0(1.1);
						v77.AbilitiesDisabled = false;
					end);
					return;
				else
					if v25 then
						v77.Animations.Behead:Play(0.025);
						local l_v11_SpeedMultiplier_1 = v11:CreateSpeedMultiplier(v77.Rig, 1, "BeheadAbility");
						l_TweenService_0:Create(l_v11_SpeedMultiplier_1, TweenInfo.new(0.125), {
							Value = v77.State.isEnraged and v77.Config.EnragedBeheadLunge or v77.Config.BeheadLunge
						}):Play();
						l_delay_0(0.4, function() --[[ Line: 349 ]]
							-- upvalues: l_TweenService_0 (ref), l_v11_SpeedMultiplier_1 (copy), l_wait_0 (ref), l_Debris_0 (ref)
							l_TweenService_0:Create(l_v11_SpeedMultiplier_1, TweenInfo.new(0.3), {
								Value = 0.2
							}):Play();
							l_wait_0(0.6);
							l_TweenService_0:Create(l_v11_SpeedMultiplier_1, TweenInfo.new(0.3), {
								Value = 1
							}):Play();
							l_Debris_0:AddItem(l_v11_SpeedMultiplier_1, 0.3);
						end);
					end;
					return;
				end;
			end
		}, 
		GashingWound = {
			LayoutOrder = 3, 
			Icon = "rbxassetid://96900331272883", 
			KeybindType = "AltAbility2", 
			Cooldown = function(v89, v90) --[[ Line: 365 ]] --[[ Name: Cooldown ]]
				return v89.State.isEnraged and v89.Config[("Enraged%*Cooldown"):format(v90)] or v89.Config[("%*Cooldown"):format(v90)];
			end, 
			Callback = function(v91) --[[ Line: 366 ]] --[[ Name: Callback ]]
				-- upvalues: v26 (copy), v53 (copy), l_insert_0 (copy), l_sort_0 (copy), l_delay_0 (copy), v13 (copy), v15 (copy), v11 (copy), v9 (copy), v40 (copy), v7 (copy), v17 (copy), v8 (copy), v16 (copy), l_wait_0 (copy), v60 (copy), l_TweenService_0 (copy), v30 (copy)
				if v26 then
					v91.AbilitiesDisabled = true;
					v91.Cache.GashingWoundStart:Play(0.05);
					v53(v91, "GashingWoundSwing");
					local v92 = v91.State.isEnraged and v91.Config.EnragedGashingWoundDamage or v91.Config.GashingWoundDamage;
					local v93 = v91.Config.GashingWoundHitData();
					local v94 = {};
					for v95, _ in pairs(v93) do
						l_insert_0(v94, v95);
					end;
					local l_v94_0 = v94;
					l_sort_0(l_v94_0);
					v94 = l_v94_0[1] + 0.166;
					local _ = os.clock();
					local l_isEnraged_2 = v91.State.isEnraged;
					local v100 = nil;
					local v101 = nil;
					local v102 = 0;
					-- invincibility bug fix: everything Gashing Wound gives Slasher (invincible, anchored, AbilitiesDisabled)
					-- is now always taken back, even if the cleanup errors or a grab lands after the hit/miss was decided
					local gashResolved = false; -- true once the cleanup has decided hit/miss; no grab may start after that
					local gashReleased = false;
					local gashClientNotified = false;
					local function gashUnanchor(model)
						local pp = model and model.Parent and model.PrimaryPart;
						if pp and v11:HasStackableProperty(pp, "Anchored", "Gashing") then
							pcall(v11.ToggleAnchored, v11, model, "Gashing", false);
						end;
					end;
					local function gashCanGrab()
						local rig = v91.Rig;
						if gashResolved or not (rig and rig.Parent and rig.PrimaryPart) or not v11:IsAlive(rig) then
							return false;
						end;
						-- getting stunned or ragdolled in the same moment the grab lands used to leave Slasher stuck
						return not (rig:GetAttribute("Stunned") or rig:GetAttribute("Ragdolling"));
					end;
					local function gashRelease()
						if gashReleased then
							return;
						end;
						gashReleased = true;
						pcall(function()
							if v101 then
								v101:Stop(0);
							end;
						end);
						gashUnanchor(v100);
						gashUnanchor(v91.Rig);
						if not gashClientNotified then
							gashClientNotified = true;
							pcall(v16.FireClientConnection, v16, v91.Player, ("%*GashingWoundStateAsync"):format(v91.Player.Name), "REMOTE_EVENT", "NONE");
						end;
						v91.AbilitiesDisabled = false;
						if v91.Rig then
							pcall(v11.RemoveInvincible, v11, v91.Rig, "Gashing");
						end;
					end;
					-- the normal hit path finishes in ~4.75s; this never lets Gashing Wound hold Slasher longer than 8s
					l_delay_0(8, function()
						if not gashReleased then
							warn("[Slasher]: Gashing Wound failsafe released the killer");
							gashRelease();
						end;
					end);
					for v103, v104 in v93 do
						l_delay_0(v103, function() --[[ Line: 385 ]]
							-- upvalues: v103 (copy), v94 (copy), v100 (ref), v102 (ref), v13 (ref), v91 (copy), v92 (copy), v104 (copy), v53 (ref), v15 (ref), l_isEnraged_2 (copy), v11 (ref), v9 (ref), v40 (ref), v101 (ref), v7 (ref), v17 (ref), v8 (ref)
							if v94 <= v103 and not v100 then
								return;
							else
								v102 = v102 + 1;
								v13:CreateHitbox(v91.Player, {
									Size = Vector3.new(8, 4, 8, 0), 
									CFrameOffset = CFrame.new(0, 0, -2.25), 
									Damage = v92 / v104.DamageDivisor, 
									Time = v104.Time, 
									Knockback = 0, 
									HitMultiple = true, 
									Connections = {
										Hit = function(v105, v106) --[[ Line: 399 ]] --[[ Name: Hit ]]
											-- upvalues: v53 (ref), v91 (ref), v15 (ref), l_isEnraged_2 (ref), v102 (ref), v103 (ref), v100 (ref), v11 (ref), v9 (ref), v40 (ref), v101 (ref), v7 (ref), v17 (ref), v8 (ref)
											if v106 then
												v53(v91, "Hit");
												if not v15:PlayerHasStatus(v105, "Gouged") then
													v15:ApplyStatus(v105, "Gouged", {
														Killer = v91, 
														Level = 1, 
														Duration = v91.Config.GashingWoundStatusTime
													});
												end;
												if l_isEnraged_2 then
													v15:ApplyStatus(v105, "Bleeding", {
														Level = 1, 
														Duration = v102
													});
												end;
											end;
											if v103 <= 0.5 and not v100 and not gashResolved then
												local l_v11_EntityType_0, _ = v11:GetEntityType(v105);
												if not l_v11_EntityType_0 or not gashCanGrab() then
													return;
												else
													v9.AddProfile(v105, {
														AnchorDelay = true, 
														Applied = os.clock() + 10
													});
													v100 = v105;
													v40(v91.Behavior, "GashingWoundStart", v91.Behavior, v91);
													v11:SetUpCutscene(v91.Rig, v105, nil, "Gashing");
													v11:GiveInvincible(v91.Rig, "Gashing");
													local l_GashingWound_0 = v91.Cache.GashingWound;
													l_GashingWound_0:Play(0);
													l_GashingWound_0.TimePosition = v91.Cache.GashingWoundStart.TimePosition;
													v101 = v11:LoadAnimationFromID(v105, v91.Config.Animations.GashingWound.PlayerRig, true);
													v101:Play(0.05);
													v101.TimePosition = v91.Cache.GashingWoundStart.TimePosition;
													v91.Cache.GashingWoundStart:Stop(0);
													v7:PlayVoiceline(v91, "GashingWoundHit", {
														Priority = 2
													});
													if v105.Humanoid.Health <= 0 then
														for _, v111 in (workspace.Map.Ingame:GetChildren()) do
															if v111:IsA("Model") and (v111.Name == "SubspaceTripmine" or string.match(v111.Name, "TaphTripmine$")) then
																local v112 = v111.PrimaryPart or v111:FindFirstChildWhichIsA("BasePart");
																if v112 and (v112.Position - v105.HumanoidRootPart.Position).Magnitude <= 20 then
																	v17:IncrementAchievementProgress(v91.Player, "JasonFool");
																	break;
																end;
															end;
														end;
													end;
													if v105.Parent.Name == "Survivors" then
														v8:IncrementActorStats(v91.Player, {
															Action = "Landed Gashing Wound hit", 
															RewardType = "RegularKillerAction"
														});
													end;
												end;
											end;
										end
									}
								});
								return;
							end;
						end);
					end;
					l_delay_0(v94, function() --[[ Line: 477 ]]
						-- upvalues: v100 (ref), v53 (ref), v91 (copy), v11 (ref), v16 (ref), l_wait_0 (ref), v101 (ref), v9 (ref), v60 (ref), v40 (ref)
						gashResolved = true;
						local gashOk, gashErr = pcall(function()
						local v113 = v100 and 4.25 or 0.5;
						if v100 then
							v53(v91, "GashingWoundHit");
						else
							v11:RemoveInvincible(v91.Rig, "Gashing");
							v53(v91, "GashingWoundMiss");
						end;
						v16:FireClientConnection(v91.Player, ("%*GashingWoundStateAsync"):format(v91.Player.Name), "REMOTE_EVENT", v100 and "HIT" or "NONE");
						gashClientNotified = true;
						l_wait_0(v113 - 1.75);
						if v101 then
							v101:Stop(0);
						end;
						if v100 and v100.PrimaryPart then
							local v114 = RaycastParams.new();
							v114.FilterDescendantsInstances = workspace.Players:GetDescendants();
							v114.FilterType = Enum.RaycastFilterType.Exclude;
							local v115 = workspace:Raycast(v91.Rig.PrimaryPart.Position, v91.Rig.PrimaryPart.CFrame.LookVector * 100, v114);
							local v116 = v115 and math.clamp(v115.Distance, -1e999, 3) or 3;
							if v116 < 3 then
								v116 = -(v100.PrimaryPart.Size.Z / 2) - (3 - v116) * 2;
							end;
							local v117 = v91.Rig.PrimaryPart.CFrame.LookVector * (v116 / 3 * 75);
							v100:PivotTo(v91.Rig.PrimaryPart.CFrame * CFrame.new(0, 0, -v116));
							v11:ToggleAnchored(v100, "Gashing", false);
							v100.PrimaryPart.Velocity = v117;
							v9.AddProfile(v100, {
								AnchorDelay = true, 
								Velocity = v117
							});
							v9.EnableRagdoll(v100, 1.25);
						end;
						l_wait_0(1);
						v60(v91);
						v40(v91.Behavior, "GashingWoundEnd", v91.Behavior, v91);
						if v91.Rig and v91.Rig.PrimaryPart then
							v11:ToggleAnchored(v91.Rig, "Gashing", false);
						end;
						end);
						if not gashOk then
							warn(("[Slasher]: Gashing Wound cleanup failed, releasing the killer: %*"):format(tostring(gashErr)));
							gashRelease();
							return;
						end;
						l_wait_0(0.5);
						v91.AbilitiesDisabled = false;
						l_wait_0(0.25);
						gashRelease();
					end);
					return;
				else
					local l_v11_SpeedMultiplier_2 = v11:CreateSpeedMultiplier(v91.Rig, 1, "BeheadAbility");
					l_TweenService_0:Create(l_v11_SpeedMultiplier_2, v30, {
						Value = 0.001
					}):Play();
					v91.Instances.GashingWoundSlowness = l_v11_SpeedMultiplier_2;
					return;
				end;
			end
		}, 
        RagingPace = {
            LayoutOrder = 3, 
            Icon = "rbxassetid://86530225037587", 
            KeybindType = "AltAbility3", 
            Callback = function(v116) --[[ Line: 515 ]] --[[ Name: Callback ]]
                -- upvalues: v26 (copy), l_delay_0 (copy), v11 (copy), v40 (copy), v53 (copy), l_Debris_0 (copy), l_wait_0 (copy), v60 (copy), v16 (copy), l_TweenService_0 (copy), l_RunService_0 (copy), v12 (copy)
                if v26 then
                    v116.AbilitiesDisabled = true;
                    l_delay_0(v116.Config.EnragedStartup, function() --[[ Line: 522 ]]
                        -- upvalues: v116 (copy), v11 (ref), v40 (ref), v53 (ref), l_Debris_0 (ref), l_wait_0 (ref), v60 (ref)
                        v116:ChangeExpression("Enraged");
                        v116.State.isEnraged = true;
                        v11:GiveInvincible(v116.Rig, "Raging");
                        v40(v116.Behavior, "EnragedReveal", v116.Behavior, v116);
                        v116.Instances.EnragedSFX = v53(v116, "EnragedStart", false);
                        l_Debris_0:AddItem(v116.Instances.EnragedSFX, v116.Config.EnragedTime);
                        for _, v118 in v116.Instances.EnragedVisuals do
                            v118.Enabled = true;
                        end;
                        l_wait_0(v116.Config.EnragedTime - v116.Config.EnragedStartup);
                        v60(v116);
                    end);
                    l_delay_0(1, function() --[[ Line: 542 ]]
                        -- upvalues: v116 (copy)
                        v116.AbilitiesDisabled = false;
                    end);
                    return;
                else
                    v116.Animations.EnragedStart:Play(0.025);
                    v116.AnimationType = "Enraged";
                    v116.MovementAnimSpeed = 1.425;
                    v116.State.isEnraged = true;
                    v16:FireConnection("DisableSprinting", "ENRAGED", true);
                    local l_v11_FOVMultiplier_0 = v11:CreateFOVMultiplier(v116.Player, 1, "RagingZoom");
                    l_TweenService_0:Create(l_v11_FOVMultiplier_0, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In, 0), {
                        Value = 0.925
                    }):Play();
                    v116.Instances.SpeedModifier = v11:CreateSpeedMultiplier(v116.Rig, 1, "ENRAGED");
                    l_TweenService_0:Create(v116.Instances.SpeedModifier, TweenInfo.new(0.75, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                        Value = 0.1
                    }):Play();
                    l_delay_0(0.5, function() --[[ Line: 560 ]]
                        -- upvalues: l_TweenService_0 (ref), v116 (copy)
                        l_TweenService_0:Create(v116.Instances.SpeedModifier, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                            Value = v116.Config.EnragedSpeed / v116.Config.Speed
                        }):Play();
                    end);
                    local l_v11_ClosestPlayerFromPosition_0 = v11:GetClosestPlayerFromPosition(v116.Rig.PrimaryPart.Position);
                    if l_v11_ClosestPlayerFromPosition_0 then
                        v116.Meta.TargetedPlayer = l_v11_ClosestPlayerFromPosition_0;
                        v11:RevealPlayerAura(l_v11_ClosestPlayerFromPosition_0, v116.Config.EnragedTime + 2);
                    end;
                    for _, survivor in workspace.Players.Survivors:GetChildren() do
                        if v15:PlayerHasStatus(survivor, "Gouged") then
                            v11:RevealPlayerAura(survivor, 5)
                        end
                    end
                    if not v11:GetSettingValue("EpilepsyMode") then
                        local l_ColorCorrectionEffect_0 = Instance.new("ColorCorrectionEffect");
                        l_ColorCorrectionEffect_0.Parent = game.Lighting;
                        l_ColorCorrectionEffect_0.Name = "SlasherEvil";
                        l_ColorCorrectionEffect_0.Brightness = 0;
                        l_ColorCorrectionEffect_0.Contrast = 0;
                        l_ColorCorrectionEffect_0.Saturation = 0;
                        l_ColorCorrectionEffect_0.TintColor = Color3.fromRGB(255, 255, 255);
                        l_ColorCorrectionEffect_0.Enabled = true;
                        l_Debris_0:AddItem(l_ColorCorrectionEffect_0, 4);
                        l_TweenService_0:Create(l_ColorCorrectionEffect_0, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                            TintColor = Color3.new(1, 0.894118, 0.894118)
                        }):Play();
                        l_TweenService_0:Create(l_ColorCorrectionEffect_0, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                            Contrast = 0.05
                        }):Play();
                        l_TweenService_0:Create(l_ColorCorrectionEffect_0, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                            Saturation = 0.1
                        }):Play();
                        task.delay(0.45, function() --[[ Line: 594 ]]
                            -- upvalues: l_TweenService_0 (ref), l_ColorCorrectionEffect_0 (copy)
                            l_TweenService_0:Create(l_ColorCorrectionEffect_0, TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                                TintColor = Color3.new(1, 0.6, 0.6)
                            }):Play();
                            l_TweenService_0:Create(l_ColorCorrectionEffect_0, TweenInfo.new(0.1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                                Contrast = 0.25
                            }):Play();
                            l_TweenService_0:Create(l_ColorCorrectionEffect_0, TweenInfo.new(0.1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                                Saturation = 0.5
                            }):Play();
                        end);
                        task.delay(0.55, function() --[[ Line: 601 ]]
                            -- upvalues: l_TweenService_0 (ref), l_ColorCorrectionEffect_0 (copy)
                            l_TweenService_0:Create(l_ColorCorrectionEffect_0, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                                Contrast = 0
                            }):Play();
                            l_TweenService_0:Create(l_ColorCorrectionEffect_0, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                                Saturation = 0
                            }):Play();
                            l_TweenService_0:Create(l_ColorCorrectionEffect_0, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                                TintColor = Color3.new(1, 1, 1)
                            }):Play();
                        end);
                    end;
                    l_delay_0(0.5, function() --[[ Line: 609 ]]
                        -- upvalues: l_TweenService_0 (ref), l_v11_FOVMultiplier_0 (copy)
                        l_TweenService_0:Create(l_v11_FOVMultiplier_0, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, 0), {
                            Value = 1
                        }):Play();
                    end);
                    l_delay_0(1, function() --[[ Line: 612 ]]
                        -- upvalues: l_Debris_0 (ref), l_v11_FOVMultiplier_0 (copy), l_RunService_0 (ref), v116 (copy), v12 (ref)
                        l_Debris_0:AddItem(l_v11_FOVMultiplier_0, 1);
                        local v122 = os.clock();
                        local v123 = nil;
                        v123 = l_RunService_0.Heartbeat:Connect(function(_) --[[ Line: 616 ]]
                            -- upvalues: v122 (copy), v116 (ref), v12 (ref), v123 (ref)
                            local v125 = math.clamp((os.clock() - v122) / v116.Config.EnragedStaminaCapLerpTime, 0, 1);
                            v12.StaminaCap = v116.Config.MaxStamina + (v116.Config.EnragedStaminaCap - v116.Config.MaxStamina) * v125;
                            if not v116.State.isEnraged then
                                v123:Disconnect();
                                v123 = nil;
                                v12.StaminaCap = v116.Config.MaxStamina;
                            end;
                        end);
                        v116.Maid:Add(v123);
                    end);
                    return;
                end;
            end
        }
    }, 
	Created = function(_, v130) --[[ Line: 622 ]] --[[ Name: Created ]]
		-- upvalues: v14 (copy), l_insert_0 (copy), v26 (copy), v17 (copy), l_spawn_0 (copy), v11 (copy), v16 (copy), v60 (copy), l_delay_0 (copy), l_TweenService_0 (copy), v30 (copy), l_Debris_0 (copy)
		v130.Maid = v14.new();
		v130.Meta = {};
		v130.Instances = {};
		v130.State = {};
		v130.NetworkConnections = {};
		v130.ConnectionDictionary = {};
		v130.State.isEnraged = false;
		local v131 = {};
		for _, v133 in (v130.Rig:GetDescendants()) do
			if v133.Name == "RagingPace" then
				l_insert_0(v131, v133);
			end;
		end;
		v130.Instances.EnragedVisuals = v131;
		if v26 then
			if workspace:GetAttribute("JasonSpecialDay") then
				v17:IncrementAchievementProgress(v130.Player, "JasonSpecialDay");
			end;
			l_spawn_0(function() --[[ Line: 652 ]]
				-- upvalues: v130 (copy), v11 (ref)
				v130.Cache.GashingWoundStart = v11:LoadAnimationFromID(v130.Rig, v130.Config.Animations.GashingWoundStart);
				v130.Cache.GashingWound = v11:LoadAnimationFromID(v130.Rig, v130.Config.Animations.GashingWound.KillerRig);
			end);
			return;
		else
			l_insert_0(v130.NetworkConnections, {
				("%*EnrageStateAsync"):format(v130.Player.Name), 
				"REMOTE_EVENT"
			});
			v16:SetConnection(("%*EnrageStateAsync"):format(v130.Player.Name), "REMOTE_EVENT", function() --[[ Line: 660 ]]
				-- upvalues: v60 (ref), v130 (copy)
				warn("[Slasher]: EnrageStateAsync was called, resetting enraged state!");
				v60(v130);
			end);
			l_insert_0(v130.NetworkConnections, {
				("%*GashingWoundStateAsync"):format(v130.Player.Name), 
				"REMOTE_EVENT"
			});
			v16:SetConnection(("%*GashingWoundStateAsync"):format(v130.Player.Name), "REMOTE_EVENT", function(v134) --[[ Line: 666 ]]
				-- upvalues: v130 (copy), l_delay_0 (ref), l_TweenService_0 (ref), v30 (ref), l_Debris_0 (ref)
				local v135 = ("GashingWoundStateAsync was called, new state: %*"):format(v134);
				warn((("[Slasher]: %*"):format(v135)));
				v135 = v130.Instances.GashingWoundSlowness;
				l_delay_0(v134 == "HIT" and 4.75 or 1, function() --[[ Line: 670 ]]
					-- upvalues: l_TweenService_0 (ref), v135 (copy), v30 (ref), l_Debris_0 (ref)
					l_TweenService_0:Create(v135, v30, {
						Value = 1
					}):Play();
					l_Debris_0:AddItem(v135, 0.2);
				end);
			end);
			return;
		end;
	end, 
	Destroyed = function(_, v137) --[[ Line: 678 ]] --[[ Name: Destroyed ]]
		-- upvalues: v26 (copy), v16 (copy)
		v137.Maid:Destroy();
		local v138 = ("%* | Destroyed Maid!"):format(v26 and "SERVER" or "CLIENT");
		warn((("[Slasher]: %*"):format(v138)));
		for v139, v140 in v137.ConnectionDictionary do
			local v141 = ("%* | Disconnected connection: %*"):format(v26 and "SERVER" or "CLIENT", v140);
			warn((("[Slasher]: %*"):format(v141)));
			v140:Disconnect();
			v137.ConnectionDictionary[v139] = nil;
		end;
		for v142, v143 in v137.NetworkConnections do
			local v144 = ("%* | Disconnected network connection: %*/%*"):format(v26 and "SERVER" or "CLIENT", v143[2], v143[1]);
			warn((("[Slasher]: %*"):format(v144)));
			v16:RemoveConnection(v143[1], v143[2]);
			v137.NetworkConnections[v142] = nil;
		end;
		for _, v146 in v137.Instances do
			if typeof(v146) == "table" then
				for _, v148 in v146 do
					if v148 and v148.Parent then
						local v149 = ("%* | Removed instance reference: %*"):format(v26 and "SERVER" or "CLIENT", v148);
						warn((("[Slasher]: %*"):format(v149)));
						v148:Destroy();
					end;
				end;
			else
				v146:Destroy();
			end;
		end;
	end, 
	OnIntroduction = function(_, _, v152, v153) --[[ Line: 708 ]] --[[ Name: OnIntroduction ]]
		-- upvalues: v11 (copy), v31 (copy), l_delay_0 (copy), l_TweenService_0 (copy)
		local v154 = script.IntroWideDoor:Clone();
		v154:PivotTo(v152.PrimaryPart.CFrame);
		v154.Parent = v152;
		for _, v156 in (v154.Joints:GetChildren()) do
			v156.Part1 = v154.Parts:FindFirstChild(v156.Name, true);
			v156.Part0 = v152.PrimaryPart;
		end;
		local l_v11_FOVMultiplier_0 = v11:CreateFOVMultiplier(v31, 0.4, "JasonIntroScene", v153);
		l_delay_0(0.78, function() --[[ Line: 719 ]]
			-- upvalues: l_v11_FOVMultiplier_0 (copy), l_TweenService_0 (ref)
			l_v11_FOVMultiplier_0.Value = 0.35;
			l_TweenService_0:Create(l_v11_FOVMultiplier_0, TweenInfo.new(2.5, Enum.EasingStyle.Back), {
				Value = 0.45
			}):Play();
		end);
	end, 
	OnVictory = function(_, v159, v160, _, _) --[[ Line: 725 ]] --[[ Name: OnVictory ]]
		-- upvalues: v31 (copy), l_spawn_0 (copy), v32 (copy), l_wait_0 (copy), l_TweenService_0 (copy), l_close_0 (copy), v10 (copy)
		if v159 == "Start" then
			local l_PlayerGui_0 = v31.PlayerGui;
			local l_ScreenGui_0 = Instance.new("ScreenGui");
			l_ScreenGui_0.Name = "JasonOutroOverlay";
			l_ScreenGui_0.ResetOnSpawn = false;
			l_ScreenGui_0.IgnoreGuiInset = true;
			l_ScreenGui_0.Parent = l_PlayerGui_0;
			v160.Meta.StartThread = l_spawn_0(function() --[[ Line: 735 ]]
				-- upvalues: v32 (ref), v31 (ref), l_wait_0 (ref), l_TweenService_0 (ref)
				v32.FieldOfView = 35;
				v31:SetAttribute("FOVMultipliersDisabled", true);
				l_wait_0(1.53);
				local l_ColorCorrectionEffect_0 = Instance.new("ColorCorrectionEffect");
				l_ColorCorrectionEffect_0.Name = "JasonOutroCCEffect";
				l_ColorCorrectionEffect_0.Parent = game.Lighting;
				local l_BlurEffect_0 = Instance.new("BlurEffect");
				l_BlurEffect_0.Name = "JasonOutroBlurEffect";
				l_BlurEffect_0.Parent = game.Lighting;
				l_TweenService_0:Create(l_BlurEffect_0, TweenInfo.new(0.125), {
					Size = 2
				}):Play();
				l_TweenService_0:Create(v32, TweenInfo.new(0.42), {
					FieldOfView = 46
				}):Play();
				l_wait_0(0.42);
				l_TweenService_0:Create(l_ColorCorrectionEffect_0, TweenInfo.new(0.125, Enum.EasingStyle.Exponential, Enum.EasingDirection.In), {
					TintColor = Color3.fromRGB(190, 0, 3), 
					Brightness = 0.4, 
					Contrast = 0.2, 
					Saturation = 0.5
				}):Play();
				l_TweenService_0:Create(l_BlurEffect_0, TweenInfo.new(0.125, Enum.EasingStyle.Exponential, Enum.EasingDirection.In), {
					Size = 30
				}):Play();
				l_TweenService_0:Create(v32, TweenInfo.new(0.15), {
					FieldOfView = 32
				}):Play();
				l_wait_0(0.17);
				l_TweenService_0:Create(l_BlurEffect_0, TweenInfo.new(0.125), {
					Size = 2
				}):Play();
				l_TweenService_0:Create(v32, TweenInfo.new(0.15), {
					FieldOfView = 35
				}):Play();
				l_wait_0(0.35);
				l_TweenService_0:Create(l_ColorCorrectionEffect_0, TweenInfo.new(0.125), {
					TintColor = Color3.fromRGB(255, 105, 105), 
					Brightness = 0, 
					Contrast = 0, 
					Saturation = 0
				}):Play();
				l_wait_0(0.61);
				l_TweenService_0:Create(l_ColorCorrectionEffect_0, TweenInfo.new(0.125), {
					TintColor = Color3.fromRGB(255, 226, 226)
				}):Play();
				l_TweenService_0:Create(v32, TweenInfo.new(0.15), {
					FieldOfView = 32
				}):Play();
				l_wait_0(0.29);
				l_TweenService_0:Create(l_BlurEffect_0, TweenInfo.new(0.125), {
					Size = 1
				}):Play();
				l_TweenService_0:Create(l_ColorCorrectionEffect_0, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
					TintColor = Color3.fromRGB(255, 255, 255)
				}):Play();
				l_TweenService_0:Create(v32, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					FieldOfView = 55
				}):Play();
			end);
			return;
		else
			if v159 == "End" then
				local l_JasonOutroOverlay_0 = v31.PlayerGui:FindFirstChild("JasonOutroOverlay");
				if l_JasonOutroOverlay_0 then
					l_JasonOutroOverlay_0:Destroy();
				end;
				v31:SetAttribute("FOVMultipliersDisabled", nil);
				if v160 and v160.Meta.StartThread then
					l_close_0(v160.Meta.StartThread);
				end;
				v10:SetAsCurrentLighting();
			end;
			return;
		end;
	end, 
	OnExecution = function(_, v169, v170) --[[ Line: 789 ]] --[[ Name: OnExecution ]]
		-- upvalues: l_delay_0 (copy), v9 (copy)
		if not v169.Rig then
			return;
		else
			local v171 = v170.Name == "Guest1337";
			local v172 = (v171 and -v169.Rig.PrimaryPart.CFrame.RightVector or v169.Rig.PrimaryPart.CFrame.LookVector) * 100;
			local v173 = v171 and 4.6 or 1.125;
			l_delay_0(v173, function() --[[ Line: 799 ]]
				-- upvalues: v9 (ref), v170 (copy), v172 (copy), v171 (copy)
				v9.AddProfile(v170, {
					Velocity = v172, 
					KillEffects = if v171 then {
						Decapitate = true
					} else nil
				});
				local l_Humanoid_1 = v170:FindFirstChildOfClass("Humanoid");
				if l_Humanoid_1 then
					l_Humanoid_1.BreakJointsOnDeath = false;
					l_Humanoid_1.Health = 0;
				end;
			end);
			return;
		end;
	end
};