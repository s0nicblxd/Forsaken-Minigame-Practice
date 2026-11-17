-- FCTtest2: Reworked Guest block/parry compatibility fix.
-- Paste into Roblox Studio's Command Bar while NOT playtesting.
assert(game:GetService("RunService"):IsStudio() and not game:GetService("RunService"):IsRunning(), "Stop the playtest before applying this patch.")
local function fingerprint(source)
 local a,b=5381,0
 for i=1,#source do
  local byte=string.byte(source,i)
  a=(a*33+byte)%4294967296
  b=(b*65599+byte)%4294967296
 end
 return string.format("%d:%08x:%08x",#source,a,b)
end
local plans={
{path=[====[
ReplicatedStorage/Assets/Killers/1x1x1x1/Behavior]====],before="81232:1f5fa36c:f9bd3099",after="81284:cf395bbd:5b9ddd4a",edits={{[====[
                    PlaybackSpeed = Random.new():NextNumber(0.975, 1.025), 
                    Volume = 0.25
                });
                task.delay(v58.Config.SlashWindup, function() --[[ Line: 161 ]]
                    -- upvalues: v9 (ref), v58 (copy), v57 (ref), v8 (ref), v11 (ref), v7 (ref)
                    local _ = v9:CreateHitbox(v58.Player, {
                        Size = Vector3.new(4.5, 6, 7.5, 0), 
                        CFrameOffset = CFrame.new(0, 0, -1.75), 
                        Damage = function(v59) --[[ Line: 165 ]] --[[ Name: Damage ]]
                            -- upvalues: v58 (ref)
                            if v59.Name == "1x1x1x1Zombie" then
]====],[====[
                    PlaybackSpeed = Random.new():NextNumber(0.975, 1.025), 
                    Volume = 0.25
                });
                task.delay(v58.Config.SlashWindup, function() --[[ Line: 161 ]]
                    -- upvalues: v9 (ref), v58 (copy), v57 (ref), v8 (ref), v11 (ref), v7 (ref)
                    local _ = v9:CreateHitbox(v58.Player, { AbilityType = "MainAbility", IsProjectile = false, 
                        Size = Vector3.new(4.5, 6, 7.5, 0), 
                        CFrameOffset = CFrame.new(0, 0, -1.75), 
                        Damage = function(v59) --[[ Line: 165 ]] --[[ Name: Damage ]]
                            -- upvalues: v58 (ref)
                            if v59.Name == "1x1x1x1Zombie" then
]====]}}},
{path=[====[
ReplicatedStorage/Assets/Killers/Azure/Behavior]====],before="152870:a6aa4b80:6969fe37",after="152916:b00462c2:508367e5",edits={{[====[
							PlaybackSpeed = 0.975 + Random.new():NextNumber() * 0.04999999999999993
						})

						v825.Parent = v823.Rig.PrimaryPart
						Sounds:Play(v823.Config.Sounds[v824], v825)
						Hitboxes:CreateHitbox(p156.Player, {
							Size = Vector3.new(8, 4, 10),
							Knockback = 2,
							HitMultiple = true,
							ExecuteOnKill = false,
							CFrameOffset = CFrame.new(0, 0, -3.5),
]====],[====[
							PlaybackSpeed = 0.975 + Random.new():NextNumber() * 0.04999999999999993
						})

						v825.Parent = v823.Rig.PrimaryPart
						Sounds:Play(v823.Config.Sounds[v824], v825)
						Hitboxes:CreateHitbox(p156.Player, { IsProjectile = false, 
							Size = Vector3.new(8, 4, 10),
							Knockback = 2,
							HitMultiple = true,
							ExecuteOnKill = false,
							CFrameOffset = CFrame.new(0, 0, -3.5),
]====]},{[====[
					})

					v830.Parent = v829.Rig.PrimaryPart
					Sounds:Play(v829.Config.Sounds.Slash, v830)
					os.clock()
					Hitboxes:CreateHitbox(p156.Player, {
						Size = Vector3.new(4.5, 6, 8.5),
						Knockback = 2,
						HitMultiple = false,
						ExecuteOnKill = true,
						CFrameOffset = function() -- line: 2879
]====],[====[
					})

					v830.Parent = v829.Rig.PrimaryPart
					Sounds:Play(v829.Config.Sounds.Slash, v830)
					os.clock()
					Hitboxes:CreateHitbox(p156.Player, { IsProjectile = false, 
						Size = Vector3.new(4.5, 6, 8.5),
						Knockback = 2,
						HitMultiple = false,
						ExecuteOnKill = true,
						CFrameOffset = function() -- line: 2879
]====]}}},
{path=[====[
ReplicatedStorage/Assets/Killers/Jason/Behavior]====],before="42716:0b129cfb:d491980c",after="42767:4c5afb2c:0614236b",edits={{[====[
                end);
                task.delay(v38.Config.SlashWindup, function() --[[ Line: 126 ]]
                    -- upvalues: v5 (ref), v38 (copy), v4 (ref), v6 (ref), v3 (ref), v35 (ref)
                    local l_v5_0 = v5;
                    local l_Player_0 = v38.Player;
                    local v42 = {
                        Size = Vector3.new(4.5, 6, 7.5, 0), 
                        CFrameOffset = CFrame.new(0, 0, -1.75)
                    };
                    local l_v38_0 = v38;
                    v42.Damage = l_v38_0.Enraged and l_v38_0.Config.EnragedSlashDamage or l_v38_0.Config.SlashDamage;
]====],[====[
                end);
                task.delay(v38.Config.SlashWindup, function() --[[ Line: 126 ]]
                    -- upvalues: v5 (ref), v38 (copy), v4 (ref), v6 (ref), v3 (ref), v35 (ref)
                    local l_v5_0 = v5;
                    local l_Player_0 = v38.Player;
                    local v42 = { AbilityType = "MainAbility", IsProjectile = false,
                        Size = Vector3.new(4.5, 6, 7.5, 0), 
                        CFrameOffset = CFrame.new(0, 0, -1.75)
                    };
                    local l_v38_0 = v38;
                    v42.Damage = l_v38_0.Enraged and l_v38_0.Config.EnragedSlashDamage or l_v38_0.Config.SlashDamage;
]====]}}},
{path=[====[
ReplicatedStorage/Assets/Killers/JohnDoe/Behavior]====],before="56787:82344124:b750daab",after="56839:9e8d81b5:98a3ecdc",edits={{[====[
                    PlaybackSpeed = Random.new():NextNumber(0.975, 1.025), 
                    Volume = 0.35
                });
                task.delay(v17.Config.SlashWindup, function() --[[ Line: 49 ]]
                    -- upvalues: v7 (ref), v17 (copy), v6 (ref), v5 (ref)
                    local _ = v7:CreateHitbox(v17.Player, {
                        Size = Vector3.new(4.5, 6, 7.5, 0), 
                        CFrameOffset = CFrame.new(0, 0, -1.75), 
                        Damage = v17.Config.SlashDamage, 
                        Time = v17.Config.SlashLinger, 
                        Knockback = 2, 
]====],[====[
                    PlaybackSpeed = Random.new():NextNumber(0.975, 1.025), 
                    Volume = 0.35
                });
                task.delay(v17.Config.SlashWindup, function() --[[ Line: 49 ]]
                    -- upvalues: v7 (ref), v17 (copy), v6 (ref), v5 (ref)
                    local _ = v7:CreateHitbox(v17.Player, { AbilityType = "MainAbility", IsProjectile = false, 
                        Size = Vector3.new(4.5, 6, 7.5, 0), 
                        CFrameOffset = CFrame.new(0, 0, -1.75), 
                        Damage = v17.Config.SlashDamage, 
                        Time = v17.Config.SlashLinger, 
                        Knockback = 2, 
]====]}}},
{path=[====[
ReplicatedStorage/Assets/Killers/Noli/Behavior]====],before="107912:8481ded0:0a75661b",after="107964:8d62c0a1:06f1fdcc",edits={{[====[
                        v153.Behavior.ToggleTendril(v153, false);
                    end);
                end;
                task.delay(v153.Config.StabWindup, function() --[[ Line: 654 ]]
                    -- upvalues: v13 (ref), v153 (copy), v19 (ref), v15 (ref), v14 (ref)
                    local _ = v13:CreateHitbox(v153.Player, {
                        Size = Vector3.new(4.5, 6, 7.5, 0), 
                        CFrameOffset = CFrame.new(0, 0, -2.25), 
                        Damage = v153.Config.StabDamage, 
                        Time = v153.Config.StabLinger, 
                        Knockback = 2, 
]====],[====[
                        v153.Behavior.ToggleTendril(v153, false);
                    end);
                end;
                task.delay(v153.Config.StabWindup, function() --[[ Line: 654 ]]
                    -- upvalues: v13 (ref), v153 (copy), v19 (ref), v15 (ref), v14 (ref)
                    local _ = v13:CreateHitbox(v153.Player, { AbilityType = "MainAbility", IsProjectile = false, 
                        Size = Vector3.new(4.5, 6, 7.5, 0), 
                        CFrameOffset = CFrame.new(0, 0, -2.25), 
                        Damage = v153.Config.StabDamage, 
                        Time = v153.Config.StabLinger, 
                        Knockback = 2, 
]====]}}},
{path=[====[
ReplicatedStorage/Assets/Killers/Nosferatu/Behavior]====],before="133903:ca906cd6:8e308169",after="133955:a530b987:c268b178",edits={{[====[
                v455.AbilitiesDisabled = true;
                v18:RemoveStatus(v455.Rig, "Invisibility");
                local l_Slash_4 = l_Config_0.Slash;
                l_delay_0(l_Slash_4.Windup, function() --[[ Line: 1701 ]]
                    -- upvalues: v16 (ref), v455 (copy), l_Slash_4 (copy), v81 (ref), v18 (ref), v14 (ref)
                    local _ = v16:CreateHitbox(v455.Player, {
                        Size = Vector3.new(4.5, 6, 7.5, 0), 
                        CFrameOffset = CFrame.new(0, 0, -(v455.State.Blood > 0 and 2.25 or 1.75)), 
                        Damage = l_Slash_4.Damage, 
                        Time = l_Slash_4.Linger, 
                        Knockback = 2, 
]====],[====[
                v455.AbilitiesDisabled = true;
                v18:RemoveStatus(v455.Rig, "Invisibility");
                local l_Slash_4 = l_Config_0.Slash;
                l_delay_0(l_Slash_4.Windup, function() --[[ Line: 1701 ]]
                    -- upvalues: v16 (ref), v455 (copy), l_Slash_4 (copy), v81 (ref), v18 (ref), v14 (ref)
                    local _ = v16:CreateHitbox(v455.Player, { AbilityType = "MainAbility", IsProjectile = false, 
                        Size = Vector3.new(4.5, 6, 7.5, 0), 
                        CFrameOffset = CFrame.new(0, 0, -(v455.State.Blood > 0 and 2.25 or 1.75)), 
                        Damage = l_Slash_4.Damage, 
                        Time = l_Slash_4.Linger, 
                        Knockback = 2, 
]====]}}},
{path=[====[
ReplicatedStorage/Assets/Killers/Sixer/Behavior]====],before="141497:687012f2:31512ad1",after="141601:ed7637b4:6ec68711",edits={{[====[
                        Volume = 0.25
                    });
                end);
                task.delay(v282.Config.SlashWindup, function() --[[ Line: 1066 ]]
                    -- upvalues: v11 (ref), v282 (copy), v10 (ref), v9 (ref), v12 (ref), v286 (ref)
                    local _ = v11:CreateHitbox(v282.Player, {
                        Size = Vector3.new(5, 7, 9.25, 0), 
                        CFrameOffset = CFrame.new(0, -1, -3.75), 
                        Damage = v282.Config.SlashDamage, 
                        Time = v282.Config.SlashLinger, 
                        Knockback = 2, 
]====],[====[
                        Volume = 0.25
                    });
                end);
                task.delay(v282.Config.SlashWindup, function() --[[ Line: 1066 ]]
                    -- upvalues: v11 (ref), v282 (copy), v10 (ref), v9 (ref), v12 (ref), v286 (ref)
                    local _ = v11:CreateHitbox(v282.Player, { AbilityType = "MainAbility", IsProjectile = false, 
                        Size = Vector3.new(5, 7, 9.25, 0), 
                        CFrameOffset = CFrame.new(0, -1, -3.75), 
                        Damage = v282.Config.SlashDamage, 
                        Time = v282.Config.SlashLinger, 
                        Knockback = 2, 
]====]},{[====[
                            }):Play();
                            task.delay(v282.Config.EviscerateWindup, function() --[[ Line: 1169 ]]
                                -- upvalues: v11 (ref), v282 (ref), v10 (ref), v9 (ref), v12 (ref), v14 (ref), v85 (ref), l_TweenService_0 (ref)
                                local v299 = true;
                                local v300 = 0;
                                local _ = v11:CreateHitbox(v282.Player, {
                                    Size = Vector3.new(7, 6.75, 7, 0), 
                                    CFrameOffset = CFrame.new(0, -1, -4.25), 
                                    Damage = v282.Config.EviscerateDamage, 
                                    Time = v282.Config.EviscerateLinger, 
                                    Knockback = 2, 
]====],[====[
                            }):Play();
                            task.delay(v282.Config.EviscerateWindup, function() --[[ Line: 1169 ]]
                                -- upvalues: v11 (ref), v282 (ref), v10 (ref), v9 (ref), v12 (ref), v14 (ref), v85 (ref), l_TweenService_0 (ref)
                                local v299 = true;
                                local v300 = 0;
                                local _ = v11:CreateHitbox(v282.Player, { AbilityType = "MainAbility", IsProjectile = false, 
                                    Size = Vector3.new(7, 6.75, 7, 0), 
                                    CFrameOffset = CFrame.new(0, -1, -4.25), 
                                    Damage = v282.Config.EviscerateDamage, 
                                    Time = v282.Config.EviscerateLinger, 
                                    Knockback = 2, 
]====]}}},
{path=[====[
ReplicatedStorage/Assets/Killers/c00lkidd/Behavior]====],before="53166:60b55580:43871c51",after="53218:ec530791:a7ecfd82",edits={{[====[
                    PlaybackSpeed = Random.new():NextNumber(0.975, 1.025), 
                    Volume = 0.25
                });
                task.delay(v16.Config.PunchWindup, function() --[[ Line: 49 ]]
                    -- upvalues: v4 (ref), v16 (copy), v3 (ref), v2 (ref)
                    local _ = v4:CreateHitbox(v16.Player, {
                        Size = Vector3.new(4.5, 6, 5, 0), 
                        CFrameOffset = CFrame.new(0, 0, -2), 
                        Damage = v16.Config.AttackDamage, 
                        Time = v16.Config.PunchLinger, 
                        Knockback = 2, 
]====],[====[
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
]====]}}},
{path=[====[
ReplicatedStorage/Assets/Survivors/Guest1337Rework/Behavior]====],before="34263:bb153fce:ac07e58d",after="34647:ea8cc625:acd033a8",edits={{[====[
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
]====],[====[
	if not v112.IsProjectile
		and v112.AbilityType == "MainAbility"
		and v112.Creator
		and v111.Blocking then
		resolveGuestBlock(v111);
		cancelGuestBlockTask(v111, "BlockedThread")
		setGuestParryWindow(v111, true)
		v111.BlockedThread = task.delay(v111.Config.BlockDuration, function()
			v111.BlockedThread = nil
			setGuestParryWindow(v111, false)
		end)
		v111:SetCooldownOf("Punch", 0);
		v7:Play(v111.Config.Sounds.BlockSuccess, {
			Parent = v111.Rig.PrimaryPart
		});
		local v113 = typeof(v112.Damage) == "function" and v112.Damage(v111.Rig) or v112.Damage or 0;
]====]},{[====[
		end
		v4:ApplyStatus(v111.Rig, "Strength", {
			Level = 1,
			Duration = 5
		})
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
]====],[====[
		end
		v4:ApplyStatus(v111.Rig, "Strength", {
			Level = 1,
			Duration = 5
		})
		local attacker = v112.Creator
		local slow = v111.Config.KillerSlownessPercent / 100
		local duration = v111.Config.KillerSlownessDuration
		task.defer(function()
			local rig = typeof(attacker) == "Instance" and (attacker:IsA("Model") and attacker or attacker:IsA("Player") and attacker.Character)
				or typeof(attacker) == "table" and (attacker.Rig or attacker.Character)
			if not rig or not rig.Parent then return end
			local multiplier = v3:CreateSpeedMultiplier(rig, slow, "GuestBlockedAttacker", duration)
			if multiplier then game.Debris:AddItem(multiplier, duration) end
		end)
		v4:ApplyStatus(v111.Player, "Speed", {
			Level = v111.Config.BlockSpeedLevel, 
			Duration = v111.Config.BlockSpeedDuration
		});
		v4:RemoveStatus(v111.Player, "Resistance");


		local v116 = ("%*/BlockEnd"):format(script.Parent);
		local l_pcall_7 = pcall;
		local v118 = "BlockEnd";
		local l_v118_0 = v118 --[[ copy: 9 -> 10 ]];
		local v120;
]====]},{[====[
		end
	end

	local function refresh()
		-- An old character must not change the new character's UI.
		if v3:GetActor(game.Players.LocalPlayer) ~= actor then
			clearStroke()
			currentButton = nil
			return
		end

]====],[====[
		end
	end

	local function refresh()
		-- An old character must not change the new character's UI.
		if require(l_ReplicatedStorage_0.Modules.Actors).CurrentActors[game.Players.LocalPlayer] ~= actor then
			clearStroke()
			currentButton = nil
			return
		end

]====]},{[====[
		cancelGuestBlockTask(v134, "BlockThread")
		cancelGuestBlockTask(v134, "__blockSlowThread")
		cancelGuestBlockTask(v134, "__blockUnlockThread")
		cancelGuestBlockTask(v134, "BlockedThread")
		clearGuestBlockSlow(v134)
		v134.Blocking = nil
		setGuestParryWindow(v134, false)
		v134:DisableAbilities("GuestReworkBlock", false)
	end

]====],[====[
		cancelGuestBlockTask(v134, "BlockThread")
		cancelGuestBlockTask(v134, "__blockSlowThread")
		cancelGuestBlockTask(v134, "__blockUnlockThread")
		cancelGuestBlockTask(v134, "BlockedThread")
		clearGuestBlockSlow(v134)
		restoreGuestBlockHitbox(v134)
		v134.Blocking = nil
		setGuestParryWindow(v134, false)
		v134:DisableAbilities("GuestReworkBlock", false)
	end

]====]}}},
{path=[====[
ReplicatedStorage/Modules/Hitboxes]====],before="25355:07fc5586:7cdd5af7",after="26387:62b198d2:75340e91",edits={{[====[

	return false
end


function Hitboxes.CreateHitbox(_, creator, hitboxParams)
	local creatorChar = creator and creator.Character

	if not creatorChar or not creatorChar.PrimaryPart then
		return
	end

]====],[====[

	return false
end


local function guestHitClient(target, ...)
	if typeof(target) == "Instance" and target:IsA("Player") then
		Network:FireClientConnection(target, ...)
	end
end
local function guestIsPlayer(target)
	return typeof(target) == "Instance" and target:IsA("Player")
end
local function guestCharacter(subject)
	if typeof(subject) == "Instance" then
		if subject:IsA("Player") then return subject.Character end
		if subject:IsA("Model") then return subject end
	elseif typeof(subject) == "table" then
		return subject.Rig or subject.Character
	end
end
local function guestActor(subject, rig)
	local player = rig and Players:GetPlayerFromCharacter(rig)
	local actor = subject and Actors.CurrentActors[subject] or player and Actors.CurrentActors[player] or rig and Actors.CurrentActors[rig]
	if actor and actor.Rig == rig then return actor end
	for _, candidate in pairs(Actors.CurrentActors) do
		if candidate.Rig == rig then return candidate end
	end
end

function Hitboxes.CreateHitbox(_, creator, hitboxParams)
	local creatorChar = guestCharacter(creator)

	if not creatorChar or not creatorChar.PrimaryPart then
		return
	end

]====]},{[====[
		HumanoidsDamaged = {},
		InvincibleProcs = {},
		Creator = creator,
		AbilityType = config.AbilityType,
		Damage = config.Damage,
		IsProjectile = config.CFrame ~= nil,

		OnHit = Signal.new(),
		OnEnded = Signal.new()
	}

]====],[====[
		HumanoidsDamaged = {},
		InvincibleProcs = {},
		Creator = creator,
		AbilityType = config.AbilityType,
		Damage = config.Damage,
		IsProjectile = if params.IsProjectile ~= nil then params.IsProjectile else config.CFrame ~= nil,

		OnHit = Signal.new(),
		OnEnded = Signal.new()
	}

]====]},{[====[
		hitboxState.Cancelled = true
		hitboxJanitor:Cleanup()
	end

	task.spawn(function()
		local creatorActor = creator and (creator:IsA("Player") and Actors.CurrentActors[creator])

		while creatorChar.Parent and creatorChar.PrimaryPart and hitboxState.TimePast < config.Time and not hitboxState.Cancelled do
			local humanoidsDamaged = hitboxState.HumanoidsDamaged
			local hitCount = 0

]====],[====[
		hitboxState.Cancelled = true
		hitboxJanitor:Cleanup()
	end

	task.spawn(function()
		local creatorActor = guestActor(creator, creatorChar)

		while creatorChar.Parent and creatorChar.PrimaryPart and hitboxState.TimePast < config.Time and not hitboxState.Cancelled do
			local humanoidsDamaged = hitboxState.HumanoidsDamaged
			local hitCount = 0

]====]},{[====[
			if config.Hide then
				hitboxPart:SetAttribute("Hidden", true)
			end

			if config.PredictVelocity then
				if not creator:IsA("Player") then
				end
			end

			local partsFound = workspace:GetPartsInPart(hitboxPart, overlapParams)

]====],[====[
			if config.Hide then
				hitboxPart:SetAttribute("Hidden", true)
			end

			if config.PredictVelocity then
				if typeof(creator) ~= "Instance" or not creator:IsA("Player") then
				end
			end

			local partsFound = workspace:GetPartsInPart(hitboxPart, overlapParams)

]====]},{[====[

						victimChar:SetAttribute("TimesHit", (victimChar:GetAttribute("TimesHit") or 0) + 1)
						runCallback("HitAbsolute", victimChar, i == 1)

						local victimPlayer = Players:GetPlayerFromCharacter(victimChar)
						local victimActor = Actors.CurrentActors[victimPlayer]

						if victimActor and victimActor.Behavior and victimActor.Behavior.OnHit then
							local hitResponse = victimActor.Behavior:OnHit(
								victimActor,
								hitboxState,
]====],[====[

						victimChar:SetAttribute("TimesHit", (victimChar:GetAttribute("TimesHit") or 0) + 1)
						runCallback("HitAbsolute", victimChar, i == 1)

						local victimPlayer = Players:GetPlayerFromCharacter(victimChar)
						local victimActor = guestActor(victimPlayer, victimChar)

						if victimActor and victimActor.Behavior and victimActor.Behavior.OnHit then
							local hitResponse = victimActor.Behavior:OnHit(
								victimActor,
								hitboxState,
]====]},{[====[

						if isKbVector or knockbackVal > 0 then
							local kbForce = (typeof(knockbackVal) == "Vector3" and knockbackVal or kbDir * knockbackVal) * 10

							if victimPlayer then
								Network:FireClientConnection(victimPlayer, "KB", "REMOTE_EVENT", Util:SerializeVector(kbForce))
							else
								victimPrimaryPart.AssemblyLinearVelocity = kbForce + victimPrimaryPart.AssemblyLinearVelocity / 2
							end
						end

]====],[====[

						if isKbVector or knockbackVal > 0 then
							local kbForce = (typeof(knockbackVal) == "Vector3" and knockbackVal or kbDir * knockbackVal) * 10

							if victimPlayer then
								guestHitClient(victimPlayer, "KB", "REMOTE_EVENT", Util:SerializeVector(kbForce))
							else
								victimPrimaryPart.AssemblyLinearVelocity = kbForce + victimPrimaryPart.AssemblyLinearVelocity / 2
							end
						end

]====]},{[====[

						if damageToApply > 0 and shatterpointHP > 0 then
							local shatterDamage = damageToApply * (victimChar:GetAttribute("ShatterpointResistance") or 1)

							if shatterDamage > 0 then
								local victimBehaviorActor = Actors.CurrentActors[victimPlayer]

								if victimBehaviorActor and victimBehaviorActor.Behavior and victimBehaviorActor.Behavior.sv_DamageCrystalHP then
									victimBehaviorActor.Behavior:sv_DamageCrystalHP(victimBehaviorActor, shatterDamage)
								else
									victimChar:SetAttribute("ShatterpointHP", (math.max(0, shatterpointHP - shatterDamage)))
]====],[====[

						if damageToApply > 0 and shatterpointHP > 0 then
							local shatterDamage = damageToApply * (victimChar:GetAttribute("ShatterpointResistance") or 1)

							if shatterDamage > 0 then
								local victimBehaviorActor = guestActor(victimPlayer, victimChar)

								if victimBehaviorActor and victimBehaviorActor.Behavior and victimBehaviorActor.Behavior.sv_DamageCrystalHP then
									victimBehaviorActor.Behavior:sv_DamageCrystalHP(victimBehaviorActor, shatterDamage)
								else
									victimChar:SetAttribute("ShatterpointHP", (math.max(0, shatterpointHP - shatterDamage)))
]====]},{[====[
						end

						local finalDeductibleDamage = math.max(0, damageToApply)
						local victimPosInt16 = Vector3int16.new(victimPrimaryPart.Position.X, victimPrimaryPart.Position.Y, victimPrimaryPart.Position.Z)
						local isKilled = victimHumanoid.Health - finalDeductibleDamage <= 0
						local creatorBehaviorActor = creator and Actors.CurrentActors[creator]

						if creatorBehaviorActor then
							local _, _ = pcall(function()
								return creatorBehaviorActor.Behavior.OnInflictedDamage(creatorBehaviorActor, victimChar, (math.min(victimHumanoid.Health, damageDealt)))
							end)
]====],[====[
						end

						local finalDeductibleDamage = math.max(0, damageToApply)
						local victimPosInt16 = Vector3int16.new(victimPrimaryPart.Position.X, victimPrimaryPart.Position.Y, victimPrimaryPart.Position.Z)
						local isKilled = victimHumanoid.Health - finalDeductibleDamage <= 0
						local creatorBehaviorActor = guestActor(creator, creatorChar)

						if creatorBehaviorActor then
							local _, _ = pcall(function()
								return creatorBehaviorActor.Behavior.OnInflictedDamage(creatorBehaviorActor, victimChar, (math.min(victimHumanoid.Health, damageDealt)))
							end)
]====]},{[====[

								return
							end

							if tostring(victimChar.Parent) == "Survivors" then
								if creator then
									Stats:UpdatePlayerStat(creator, "Kills", "Add", 1)
								end

								if creatorBehaviorActor then
									creatorBehaviorActor.TotalKills =
]====],[====[

								return
							end

							if tostring(victimChar.Parent) == "Survivors" then
								if guestIsPlayer(creator) then
									Stats:UpdatePlayerStat(creator, "Kills", "Add", 1)
								end

								if creatorBehaviorActor then
									creatorBehaviorActor.TotalKills =
]====]},{[====[
										warn(`[{ script }/CreateHitbox]: Failed to call .OnKill() due to: { result }`)
									end
								end

								require(game.ServerScriptService.Server.Systems.Core.EventHandlerServer):CallMethod("OnPlayerKilled", creator, victimPlayer)
								Actors:IncrementActorStats(creator, {
									Action = "Killed a Survivor",
									Money = 15,
									EXP = 45
								})
							end

							if config.ExecuteOnKill and not victimChar:GetAttribute("ExecutionsDisabled") and not creatorBehaviorActor.AbilityDisablers.Execution then
								local skinName = victimChar:GetAttribute("SkinName")
								local executionAnimName = nil

								if not creatorBehaviorActor then
									warn("Hitboxes: Non-Actor attempted to Execute!")
]====],[====[
										warn(`[{ script }/CreateHitbox]: Failed to call .OnKill() due to: { result }`)
									end
								end

								require(game.ServerScriptService.Server.Systems.Core.EventHandlerServer):CallMethod("OnPlayerKilled", creator, victimPlayer)
								if guestIsPlayer(creator) then
									Actors:IncrementActorStats(creator, {
										Action = "Killed a Survivor", Money = 15, EXP = 45
									})
								end
							end

							if config.ExecuteOnKill and guestIsPlayer(creator) and creatorBehaviorActor and not victimChar:GetAttribute("ExecutionsDisabled") and not (creatorBehaviorActor.AbilityDisablers or {}).Execution then
								local skinName = victimChar:GetAttribute("SkinName")
								local executionAnimName = nil

								if not creatorBehaviorActor then
									warn("Hitboxes: Non-Actor attempted to Execute!")
]====]},{[====[
												if stateConn then
													stateConn:Disconnect()
													hitboxJanitor:Remove("Execution_" .. victimHumanoid.Name)
												end

												Network:FireClientConnection(creator, "Hit", "UREMOTE_EVENT", damageDealt, victimPosInt16, nil, true)
											end
										end)

										hitboxJanitor:Add(stateConn, "Disconnect", "Execution_" .. victimHumanoid.Name)

]====],[====[
												if stateConn then
													stateConn:Disconnect()
													hitboxJanitor:Remove("Execution_" .. victimHumanoid.Name)
												end

												guestHitClient(creator, "Hit", "UREMOTE_EVENT", damageDealt, victimPosInt16, nil, true)
											end
										end)

										hitboxJanitor:Add(stateConn, "Disconnect", "Execution_" .. victimHumanoid.Name)

]====]},{[====[
												hitboxJanitor:Remove("Execution_" .. victimHumanoid.Name)
											end

											if not isExecutionFinished then
												isExecutionFinished = true
												Network:FireClientConnection(creator, "Hit", "UREMOTE_EVENT", damageDealt, victimPosInt16, nil, true)
											end

											creatorBehaviorActor:DisableAbilities("Execution", false)
											Util:ToggleAnchored(creatorBehaviorActor.Rig, "Execution", false)
											Util:ToggleAnchored(victimChar, "Execution", false)
]====],[====[
												hitboxJanitor:Remove("Execution_" .. victimHumanoid.Name)
											end

											if not isExecutionFinished then
												isExecutionFinished = true
												guestHitClient(creator, "Hit", "UREMOTE_EVENT", damageDealt, victimPosInt16, nil, true)
											end

											creatorBehaviorActor:DisableAbilities("Execution", false)
											Util:ToggleAnchored(creatorBehaviorActor.Rig, "Execution", false)
											Util:ToggleAnchored(victimChar, "Execution", false)
]====]},{[====[
												}
											})
										end

										if creatorBehaviorActor.Behavior.OnExecutionClient then
											Network:FireClientConnection(creatorBehaviorActor.Player, "OnExecutionClientAsync", "REMOTE_EVENT", victimChar)
										end
									end)

									return
								end
]====],[====[
												}
											})
										end

										if creatorBehaviorActor.Behavior.OnExecutionClient then
											guestHitClient(creatorBehaviorActor.Player, "OnExecutionClientAsync", "REMOTE_EVENT", victimChar)
										end
									end)

									return
								end
]====]},{[====[
						end

						runCallback("Hit", victimChar, i == 1)
						hitboxState.OnHit:Fire(victimChar, i == 1)

						Network:FireClientConnection(creator, "Hit", "UREMOTE_EVENT", damageDealt, victimPosInt16, nil, victimHumanoid.Health <= 0)
					end

					local stateRef = hitboxState

					stateRef.TimePast = stateRef.TimePast + RunService.Heartbeat:Wait()
]====],[====[
						end

						runCallback("Hit", victimChar, i == 1)
						hitboxState.OnHit:Fire(victimChar, i == 1)

						guestHitClient(creator, "Hit", "UREMOTE_EVENT", damageDealt, victimPosInt16, nil, victimHumanoid.Health <= 0)
					end

					local stateRef = hitboxState

					stateRef.TimePast = stateRef.TimePast + RunService.Heartbeat:Wait()
]====]}}},
{path=[====[
ReplicatedStorage/Modules/Statuses]====],before="11916:ec7bf8ab:f6bb8082",after="12260:6d556870:78f3c8e3",edits={{[====[
local Sounds = require(game.ReplicatedStorage.Modules.Sounds)
local Util = require(game.ReplicatedStorage.Modules.Util)
local Signal = require(game.ReplicatedStorage.Modules.Misc.Signal)
local StatusEffects = game.ReplicatedStorage.Modules.StatusEffects

function t1.ApplyStatus(_: {[any]: any}, p1, s1: string, t3: {[any]: any}) -- line: 18
	-- upvalues: RunService (copy), t1 (copy), StatusEffects (copy), Util (copy), ReplicatedStorage (copy), Sounds (copy), Network (copy)
	assert(RunService:IsServer(), "Can only apply statuses on server.")

	local v13 = p1:IsA("Model") and game.Players:GetPlayerFromCharacter(p1) or p1
	local v14 = v13:IsA("Model") and v13 or v13.Character

	t1.CurrentStatuses[v13] = t1.CurrentStatuses[v13] or {}

	local v15 = StatusEffects:FindFirstChild(tostring(s1), true)
	local v16 = v15 and require(v15)
]====],[====[
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
]====]},{[====[

			if v18.Applied then
				v18:Applied()
			end

			Network:FireClientConnection(v13, "StatusUpdated", "REMOTE_EVENT", s1, {
				TimePast = 0,
				Level = v18.Level,
				Duration = v18.Data.Duration or v18.TimeRequired
			})

]====],[====[

			if v18.Applied then
				v18:Applied()
			end

			statusClient(v13, "StatusUpdated", "REMOTE_EVENT", s1, {
				TimePast = 0,
				Level = v18.Level,
				Duration = v18.Data.Duration or v18.TimeRequired
			})

]====]},{[====[
				v30.Name = `{ s1 }StatusSFX`
				game.Debris:AddItem(v30, 30)
			end
		end

		if v18.Applied then
			v18:Applied()
		end

		Network:FireClientConnection(v13, "StatusApplied", "REMOTE_EVENT", s1, v18, v18.Data)

		if not t1.CurrentStatuses[v13] then
			t1.CurrentStatuses[v13] = {}
		end

		t1.CurrentStatuses[v13][s1] = v18

		if v19 and v19.Behavior and v19.Behavior[`On{ s1 }`] then
			v19.Behavior[`On{ s1 }`](v19.Behavior, v19)
		end

		if t1:GetStatusCount(v13) >= 4 then
			require(ReplicatedStorage.Modules.AchievementUtil):IncrementAchievementProgress(v13, "LotsaStatuses")
		end

		t1.StatusCounts[v13] = (t1.StatusCounts[v13] or 0) + 1
		t1.StatusApplied:Fire(v13, s1, v18, v17)

		return v18
	end
end
]====],[====[
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
]====]},{[====[
	end

	local v34 = t1.CurrentStatuses[p3] and t1.CurrentStatuses[p3][p4]

	if v34 then
		if v34.Removed then
			v34:Removed()
		end

		Network:FireClientConnection(p3, "StatusRemoved", "REMOTE_EVENT", p4)

		local v35 = p3:IsA("Player") and p3.Character or p3
		local v36 = v35 and v35:FindFirstChild(`{ p4 }StatusSFX`, true)

		if v36 then
]====],[====[
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
]====]},{[====[

		if v37 and v37.Behavior and v37.Behavior[`{ p4 }Ended`] then
			v37.Behavior[`{ p4 }Ended`](v37.Behavior, v37)
		end

		t1.CurrentStatuses[p3][p4] = nil
		t1.StatusCounts[p3] = math.max((t1.StatusCounts[p3] or 1) - 1, 0)
	end

	if t1:GetStatusCount(p3) == 0 then
		table.clear(t1.CurrentStatuses[p3])
		t1.CurrentStatuses[p3] = nil
		t1.StatusCounts[p3] = nil
	end
end
]====],[====[

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
]====]},{[====[
	-- upvalues: t1 (copy)
	return t1.StatusCounts[p9] or -1
end
function t1.PlayerHasStatus(_, p11, p12) -- line: 250
	-- upvalues: t1 (copy)
	local v48 = p11:IsA("Model") and game.Players:GetPlayerFromCharacter(p11) or p11

	return t1.CurrentStatuses[v48] and t1.CurrentStatuses[v48][p12]
end
function t1.Start(_) -- line: 255
	-- upvalues: RunService (copy), Util (copy), t1 (copy), StatusEffects (copy), Network (copy)
]====],[====[
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
]====]}}},
{path=[====[
ReplicatedStorage/Modules/Util]====],before="71474:79b675f9:c09c6b70",after="71800:3ad0b7c6:7c0d141b",edits={{[====[
	if v11 then
		return require(game.ReplicatedStorage.Systems.Player.Miscellaneous.GetPlayerMousePosition):GetCameraCFrame(...)
	end
end
function t1.GetActor(_: {[any]: any}, p47) -- line: 963
	if p47:IsA("Model") then
		p47 = game.Players:GetPlayerFromCharacter(p47)
	end

	return require(game.ReplicatedStorage.Modules.Actors).CurrentActors[p47]
end
function t1.SetUpCutscene(_: {[any]: any}, p48, p49, cFrame: CFrame?, s22: string) -- line: 973
	-- upvalues: t1 (copy)
	local v297 = t1:GetActor(p48) or p48
	local v298 = t1:GetActor(p49) or p49
]====],[====[
	if v11 then
		return require(game.ReplicatedStorage.Systems.Player.Miscellaneous.GetPlayerMousePosition):GetCameraCFrame(...)
	end
end
function t1.GetActor(_: {[any]: any}, p47) -- line: 963
	if typeof(p47) ~= "Instance" then return nil end
	local actors = require(game.ReplicatedStorage.Modules.Actors).CurrentActors
	local rig = p47:IsA("Model") and p47 or p47:IsA("Player") and p47.Character
	if not rig then return nil end
	local key = p47:IsA("Model") and (game.Players:GetPlayerFromCharacter(p47) or p47) or p47
	local actor = actors[key]
	if actor then return actor end
	for _, candidate in pairs(actors) do
		if candidate.Rig == rig then return candidate end
	end
end
function t1.SetUpCutscene(_: {[any]: any}, p48, p49, cFrame: CFrame?, s22: string) -- line: 973
	-- upvalues: t1 (copy)
	local v297 = t1:GetActor(p48) or p48
	local v298 = t1:GetActor(p49) or p49
]====]}}}
}
local function findPath(path)
 local current=game
 for name in path:gmatch("[^/]+")do current=current and current:FindFirstChild(name)end
 return current
end
local pending={}
for _,plan in ipairs(plans)do
 local target=findPath(plan.path)
 assert(target and target:IsA("ModuleScript"),"Missing ModuleScript: "..plan.path..". Nothing changed.")
 local before=target.Source
 if fingerprint(before)~=plan.after then
  assert(fingerprint(before)==plan.before,"Source does not match uploaded FCTtest2: "..plan.path..". Nothing changed; send the current script if this build was edited.")
  local updated=before
  for _,edit in ipairs(plan.edits)do
   local first,last=updated:find(edit[1],1,true)
   assert(first and not updated:find(edit[1],last+1,true),"Ambiguous patch in "..plan.path..". Nothing changed.")
   updated=updated:sub(1,first-1)..edit[2]..updated:sub(last+1)
  end
  assert(fingerprint(updated)==plan.after,"Patch verification failed: "..plan.path..". Nothing changed.")
  table.insert(pending,{target=target,path=plan.path,before=before,after=updated})
 end
end
if #pending==0 then print("[Guest Combat Fix] Already applied; nothing changed.");return end
local backup=Instance.new("Folder")
backup.Name="GuestCombatFix_Backup_"..os.date("!%Y%m%d_%H%M%S")
backup.Parent=game:GetService("ServerStorage")
for i,item in ipairs(pending)do
 local saved=item.target:Clone()
 saved.Name=string.format("%02d_%s",i,item.target.Name)
 saved:SetAttribute("OriginalPath",item.path)
 saved.Parent=backup
end
local ok,err=pcall(function()for _,item in ipairs(pending)do item.target.Source=item.after end end)
if not ok then
 for _,item in ipairs(pending)do item.target.Source=item.before end
 error("[Guest Combat Fix] Rolled back after write failure: "..tostring(err))
end
pcall(function()game:GetService("ChangeHistoryService"):SetWaypoint("Guest Combat Fix")end)
print(string.format("[Guest Combat Fix] Applied %d scripts. Backups: %s. Save the place, then start a fresh playtest.",#pending,backup:GetFullName()))
