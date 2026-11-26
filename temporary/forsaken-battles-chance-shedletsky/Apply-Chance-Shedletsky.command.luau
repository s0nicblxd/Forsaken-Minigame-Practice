assert(not game:GetService("RunService"):IsRunning(),"Stop Play mode first.")
local changes={{path=[========[
ReplicatedStorage/Assets/Survivors/Chance/Config]========],before=[========[
-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local v0 = {
    DisplayName = "Chance",
    Quote = "\"99% of gamblers quit before they win big\"",
    Credits = "",
    Class = "Sentinel",
    RenderImage = "rbxassetid://126924178701380",
    Price = 777,
    Speed = 12,
    HealthMin = 65,
    HealthMax = 130,
    CoinFlipCooldown = 1.75,
    CoinFlipWeaknessDuration = 15,
    CoinFlipPity = 2.5,
    GunAlwaysVisible = false,
    ShootSuccessChancePerCharge = 20,
    ShootLessFailureChancePerCharge = 10,
    ShootStunDurationDebuffPerChanceAlive = 15,
    ShootCooldown = 45,
    ShootHitboxSize = 2.5,
    ShootHitboxRange = 90,
    ShootMaxStunDuration = 4,
    ShootMinStunDuration = 1,
    ShootMaxKnockback = 14,
    ShootMinKnockback = 5,
    ShootDamage = 50,
    ShootKnockback = 3,
    ShootExplosionKnockback = 25,
    ShootExplosionStunDuration = 5,
    ShootSelfDamage = 25,
    CameraShakeMagnitude = 1.5,
    CameraShakeDuration = 0.4,
    RerollBasePenalty = 10,
    RerollCooldown = 20,
    RandomnessDifferencePerCharge = 3,
    HatFixCooldown = 60,
	Expressions = {
		Happy = "rbxassetid://92225688434461",
		Default = "rbxassetid://76254460000954",
		Hurt = "rbxassetid://102172172675803",
		Injured = "rbxassetid://83906964540493",
		Dead = "rbxassetid://123735458751609",
		Drinking = "rbxassetid://89448343694123",
		Gambling = "rbxassetid://113790771759092",
		Sad = "rbxassetid://132238504335731",
		Uhoh = "rbxassetid://90106827583875"
    },
    Animations = {
        FlipCoinHeads = "rbxassetid://113049523133974",
        FlipCoinTails = "rbxassetid://113238245087870",
        AimGun = "rbxassetid://130898730062374",
        GunFire = "rbxassetid://98303778862384",
        GunFail = "rbxassetid://80859169196524",
        GunExplode = "rbxassetid://108665611403553",
        HatFix = "rbxassetid://117170871416506"
    },
    Sounds = {
        FlipCoinHeadsSFX = "rbxassetid://104239877200025",
        FlipCoinTailsSFX = "rbxassetid://101120969540575",
        FlipCoinSFX = "rbxassetid://76040750930413",
        StatRerollSFX = "rbxassetid://83163547903343",
        GunWindUpSFX = "rbxassetid://139526116364056",
        GunFireSuccessSFX = "rbxassetid://114083139823568",
        GunExplodeSFX = "rbxassetid://2814355346",
        GunHitSFX = "rbxassetid://124324777507465"
    },
    TextInteractions = {
        Requests = {
            ElliotPizza = {
                "Heyy! Can\226\128\153t a guy like me get some pizza \226\128\152round here?",
                "Hey kid! Mind if I get a good slice of pizza?",
                "Lady Luck\226\128\153s not on my side right now, mind if I get a slice as a good luck charm?",
                "Some pizza should set me right back on my feet. Spare some, won\226\128\153tcha?",
                "Your pizza\226\128\153s got something to it, kid! Hurry and throw one my way!"
            },
            BuildermanSentry = {
                "Heya\226\128\153, a sentry over here could do some quick work on those nutjobs.",
                "One sentry over here, Builder bro!",
                "Soo.. a sentry here should be fine, don\226\128\153tcha think?",
                "Right here\226\128\153s a good spot for a sentry!",
                "Buildin\226\128\153 a sentry over here should be good!"
            },
            BuildermanDispenser = {
                "Hey Doc\226\128\153, a dispenser over here should work wonders!",
                "Work your dispenser over in this spot!",
                "Dispenser over here! Quick!",
                "I gotta use some of your dispensers here! Put \226\128\152er down!",
                "Put your dispenser over here, Doc!"
            },
            DusekkarProtection = {
                "Pumpkin fella\226\128\153, I could use some of your magic!",
                "A little help over here with your magic?",
                "That magical force field of yours would be nice to have, you know?",
                "Your force field might keep me safe in case my flintlock explodes!",
                "A force field would be useful right about now!"
            },
            HemmorhageAsk = {
                "Wow, ahaha... I'm... bleeding. Could ya' help with that? Please? Pretty please?",
                "Ah. I'm bleeding.. caaannn I ask for some help?",
                "Bleeding! Hurts! A lot..! It sucks! Help me out here, bud...",
                "Spare some help for a dying fella' over here? I'll repay the favor! Someday!",
                "I really, really hate bleeding, don't you? Help out a dying person here bud..."
            }
        },
        Thanks = {
            Regular = {
                "Heh, thanks pal!",
                "You won\226\128\153t regret this one bit!",
                "Glad to have received the help, pal!",
                "Thanks! This should be useful.",
                "Thanks! Now to get back to shootin\226\128\153.",
                "Alright, thanks pal!"
            }
        }
    }
};
v0.Information = {
    {
        Separator = "GENERAL INFO"
    },
    {
        Header = "CHANCE",
        Text = "The sounds of machines promising great rewards spiral within his ears. Gambling with his life, his potential lies inside of the result of his coin. He also wields a shoddy flintlock that feels like it could break at any moment, but it's one that he'll take to his death.\n"
    },
    {
        Header = "STATS",
        Text = "Difficulty: \240\159\142\176 \240\159\142\176 \240\159\142\176 never stop gambling\n" .. ("Health: %*-%*\n"):format(v0.HealthMin, v0.HealthMax) .. ("Regular Speed: %*\n"):format(v0.Speed or 12) .. ("Sprinting Speed: %*\n"):format(v0.SprintSpeed or 26) .. ("Max Stamina: %*\n"):format(v0.MaxStamina or 100) .. ("Stamina Loss per sec: %*\n"):format(v0.StaminaLoss or 10) .. ("Stamina Gain per sec: %*\n"):format(v0.StaminaGain or 20)
    },
    {
        Separator = "PASSIVES"
    },
    {
        Header = "UNPREDICTABLE FATE",
        Quote = "\"TAKE A CHANCE WITH CHAAAANCE BABY\" - Chance",
        Text = "Chance's Max HP stat is set to be a random value of 70-90.\n"
    },
    {
        Separator = "ABILITIES"
    },
    {
        Image = "rbxassetid://91225744028483",
        Header = "COIN FLIP",
        Quote = "\"I gambled with my LIFE\" - ???     \"did you win though\" - Chance",
        Text = ("Cooldown: %*s\n"):format(v0.CoinFlipCooldown) .. "Chance flips a coin.\n" .. "If the coin lands on heads, gain a charge for all other abilities.\n" .. ("If the coin lands on tails, gain <b>Vulnerable</b> for %*s.\n"):format(v0.CoinFlipWeaknessDuration) .. "For every time the coin lands on tails, the level of <b>Vulnerable</b> that gets inflicted on you goes up by 1.\n" .. "<b>The Vulnerable that gets inflicted has no cap.</b>\n" .. ("Coin Flip gains +%*%% increased chance to land on heads for every consecutive tails, resetting when a heads is rolled.\n"):format(v0.CoinFlipPity)
    },
    {
        Image = "rbxassetid://78498256535383",
        Header = "ONE SHOT",
        Quote = "\"You only have one shot.\" - Talking Cat",
        Text = ("Cooldown: %*s\n"):format(v0.ShootCooldown) .. "Chance pulls out an unreliable flintlock, and after a windup of 1s, pulls the trigger.\n" .. "Upon the flintlock being triggered, all of the possible outcomes can occur:\n" .. "  * (25% chance) Nothing happens.\n" .. ("  * (25%% chance) The flintlock explodes, dealing %* damage to the user and generating a 6\195\1516\195\1516 hitbox around Chance that stuns the Killer for %* seconds, then disables the ability indefinitely.\n"):format(v0.ShootSelfDamage, v0.ShootExplosionStunDuration) .. ("  * (50%% chance) The flintlock fires, stunning any killer that gets shot at within %* studs for %*-%*s. The shot becomes less effective depending on how far away Chance is from the killer.\n"):format(v0.ShootHitboxRange, v0.ShootMinStunDuration, v0.ShootMaxStunDuration) .. ("For every additional charge that this ability has, the chance of a successful shot will go up by %*%% while every other outcome's chance will decrease by %*%%.\n"):format(v0.ShootSuccessChancePerCharge, v0.ShootLessFailureChancePerCharge) .. ("For every additional Chance that's ingame, the duration of the flintlock's stun is decreased by %*%%.\n"):format(v0.ShootStunDurationDebuffPerChanceAlive) .. "This ability starts off with 0 charges and has a cap of 3 charges.\n" .. "Using this ability removes all charges on every ability.\n"
    },
    {
        Image = "rbxassetid://80029151869083",
        Header = "REROLL",
        Quote = "\"Just one more go at it and I'll be a millionaire!\" - A College Student in Debt",
        Text = ("Cooldown: %*s\n"):format(v0.RerollCooldown) .. "Chance rerolls the value of his Max HP stat.\n" .. "Upon activation, a random number between 55 to 120 is chosen.\n" .. "For every charge this ability has, the rolled value is modified as follows:\n" .. "  * 1 charge: No bonus.\n" .. "  * 2 charges: Rolled HP is increased by 5%.\n" .. "  * 3 charges: Rolled HP is increased by 10%.\n" .. "This ability starts off with 0 charges and has a cap of 3 charges.\n" .. "Chance's Maximum HP is unable to go beyond 130 HP.\n" .. "Using this ability removes all charges on every ability.\n"
    },
    {
        Image = "rbxassetid://93434599531478",
        Header = "HAT FIX",
        Quote = "\"This hat demonstrates good taste and exudes class.\" - Roblox",
        Text = ("Cooldown: %*s\n"):format(v0.HatFixCooldown) .. "Upon activating this ability, all <b>Vulnerable</b> stacks that were inflicted onto you through using <b>Coin Flip</b> are removed.\n" .. "This ability can only be used after reaching 3 charges for all other abilities.\n" .. "Using this ability removes all charges on every ability & re-enables the <b>One Shot</b> ability if it's disabled.\n"
    }
};
return v0;
]========],after=[========[
-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local v0 = {
    DisplayName = "Chance",
    Quote = "\"99% of gamblers quit before they win big\"",
    Credits = "",
    Class = "Sentinel",
    RenderImage = "rbxassetid://126924178701380",
    Price = 777,
    Speed = 12,
    HealthMin = 70,
    HealthMax = 110,
    HealthClamp = 120,
    CoinFlipCooldown = 1.75,
    CoinFlipWeaknessDuration = 15,
    CoinFlipPity = 2.5,
    GunAlwaysVisible = false,
    ShootSuccessChancePerCharge = 20,
    ShootLessFailureChancePerCharge = 10,
    ShootStunDurationDebuffPerChanceAlive = 15,
    ShootCooldown = 45,
    ShootHitboxSize = 2.5,
    ShootHitboxRange = 90,
    ShootMaxStunDuration = 4,
    ShootMinStunDuration = 1,
    ShootMaxKnockback = 14,
    ShootMinKnockback = 5,
    ShootDamage = 50,
    ShootKnockback = 3,
    ShootExplosionKnockback = 25,
    ShootExplosionStunDuration = 5,
    ShootSelfDamage = 25,
    CameraShakeMagnitude = 1.5,
    CameraShakeDuration = 0.4,
    RerollBasePenalty = 0,
    RerollCooldown = 20,
    RandomnessDifferencePerCharge = 3,
    HatFixCooldown = 60,
	Expressions = {
		Happy = "rbxassetid://92225688434461",
		Default = "rbxassetid://76254460000954",
		Hurt = "rbxassetid://102172172675803",
		Injured = "rbxassetid://83906964540493",
		Dead = "rbxassetid://123735458751609",
		Drinking = "rbxassetid://89448343694123",
		Gambling = "rbxassetid://113790771759092",
		Sad = "rbxassetid://132238504335731",
		Uhoh = "rbxassetid://90106827583875"
    },
    Animations = {
        FlipCoinHeads = "rbxassetid://113049523133974",
        FlipCoinTails = "rbxassetid://113238245087870",
        AimGun = "rbxassetid://130898730062374",
        GunFire = "rbxassetid://98303778862384",
        GunFail = "rbxassetid://80859169196524",
        GunExplode = "rbxassetid://108665611403553",
        HatFix = "rbxassetid://117170871416506"
    },
    Sounds = {
        FlipCoinHeadsSFX = "rbxassetid://104239877200025",
        FlipCoinTailsSFX = "rbxassetid://101120969540575",
        FlipCoinSFX = "rbxassetid://76040750930413",
        StatRerollSFX = "rbxassetid://83163547903343",
        GunWindUpSFX = "rbxassetid://139526116364056",
        GunFireSuccessSFX = "rbxassetid://114083139823568",
        GunExplodeSFX = "rbxassetid://2814355346",
        GunHitSFX = "rbxassetid://124324777507465"
    },
    TextInteractions = {
        Requests = {
            ElliotPizza = {
                "Heyy! Can\226\128\153t a guy like me get some pizza \226\128\152round here?",
                "Hey kid! Mind if I get a good slice of pizza?",
                "Lady Luck\226\128\153s not on my side right now, mind if I get a slice as a good luck charm?",
                "Some pizza should set me right back on my feet. Spare some, won\226\128\153tcha?",
                "Your pizza\226\128\153s got something to it, kid! Hurry and throw one my way!"
            },
            BuildermanSentry = {
                "Heya\226\128\153, a sentry over here could do some quick work on those nutjobs.",
                "One sentry over here, Builder bro!",
                "Soo.. a sentry here should be fine, don\226\128\153tcha think?",
                "Right here\226\128\153s a good spot for a sentry!",
                "Buildin\226\128\153 a sentry over here should be good!"
            },
            BuildermanDispenser = {
                "Hey Doc\226\128\153, a dispenser over here should work wonders!",
                "Work your dispenser over in this spot!",
                "Dispenser over here! Quick!",
                "I gotta use some of your dispensers here! Put \226\128\152er down!",
                "Put your dispenser over here, Doc!"
            },
            DusekkarProtection = {
                "Pumpkin fella\226\128\153, I could use some of your magic!",
                "A little help over here with your magic?",
                "That magical force field of yours would be nice to have, you know?",
                "Your force field might keep me safe in case my flintlock explodes!",
                "A force field would be useful right about now!"
            },
            HemmorhageAsk = {
                "Wow, ahaha... I'm... bleeding. Could ya' help with that? Please? Pretty please?",
                "Ah. I'm bleeding.. caaannn I ask for some help?",
                "Bleeding! Hurts! A lot..! It sucks! Help me out here, bud...",
                "Spare some help for a dying fella' over here? I'll repay the favor! Someday!",
                "I really, really hate bleeding, don't you? Help out a dying person here bud..."
            }
        },
        Thanks = {
            Regular = {
                "Heh, thanks pal!",
                "You won\226\128\153t regret this one bit!",
                "Glad to have received the help, pal!",
                "Thanks! This should be useful.",
                "Thanks! Now to get back to shootin\226\128\153.",
                "Alright, thanks pal!"
            }
        }
    }
};
v0.Information = {
    {
        Separator = "GENERAL INFO"
    },
    {
        Header = "CHANCE",
        Text = "The sounds of machines promising great rewards spiral within his ears. Gambling with his life, his potential lies inside of the result of his coin. He also wields a shoddy flintlock that feels like it could break at any moment, but it's one that he'll take to his death.\n"
    },
    {
        Header = "STATS",
        Text = "Difficulty: \240\159\142\176 \240\159\142\176 \240\159\142\176 never stop gambling\n" .. ("Health: %*-%*\n"):format(v0.HealthMin, v0.HealthMax) .. ("Regular Speed: %*\n"):format(v0.Speed or 12) .. ("Sprinting Speed: %*\n"):format(v0.SprintSpeed or 26) .. ("Max Stamina: %*\n"):format(v0.MaxStamina or 100) .. ("Stamina Loss per sec: %*\n"):format(v0.StaminaLoss or 10) .. ("Stamina Gain per sec: %*\n"):format(v0.StaminaGain or 20)
    },
    {
        Separator = "PASSIVES"
    },
    {
        Header = "UNPREDICTABLE FATE",
        Quote = "\"TAKE A CHANCE WITH CHAAAANCE BABY\" - Chance",
        Text = "Chance's Max HP stat is set to be a random value of 70-90.\n"
    },
    {
        Separator = "ABILITIES"
    },
    {
        Image = "rbxassetid://91225744028483",
        Header = "COIN FLIP",
        Quote = "\"I gambled with my LIFE\" - ???     \"did you win though\" - Chance",
        Text = ("Cooldown: %*s\n"):format(v0.CoinFlipCooldown) .. "Chance flips a coin.\n" .. "If the coin lands on heads, gain a charge for all other abilities.\n" .. ("If the coin lands on tails, gain <b>Vulnerable</b> for %*s.\n"):format(v0.CoinFlipWeaknessDuration) .. "For every time the coin lands on tails, the level of <b>Vulnerable</b> that gets inflicted on you goes up by 1.\n" .. "<b>The Vulnerable that gets inflicted has no cap.</b>\n" .. ("Coin Flip gains +%*%% increased chance to land on heads for every consecutive tails, resetting when a heads is rolled.\n"):format(v0.CoinFlipPity)
    },
    {
        Image = "rbxassetid://78498256535383",
        Header = "ONE SHOT",
        Quote = "\"You only have one shot.\" - Talking Cat",
        Text = ("Cooldown: %*s\n"):format(v0.ShootCooldown) .. "Chance pulls out an unreliable flintlock, and after a windup of 1s, pulls the trigger.\n" .. "Upon the flintlock being triggered, all of the possible outcomes can occur:\n" .. "  * (25% chance) Nothing happens.\n" .. ("  * (25%% chance) The flintlock explodes, dealing %* damage to the user and generating a 6\195\1516\195\1516 hitbox around Chance that stuns the Killer for %* seconds, then disables the ability indefinitely.\n"):format(v0.ShootSelfDamage, v0.ShootExplosionStunDuration) .. ("  * (50%% chance) The flintlock fires, stunning any killer that gets shot at within %* studs for %*-%*s. The shot becomes less effective depending on how far away Chance is from the killer.\n"):format(v0.ShootHitboxRange, v0.ShootMinStunDuration, v0.ShootMaxStunDuration) .. ("For every additional charge that this ability has, the chance of a successful shot will go up by %*%% while every other outcome's chance will decrease by %*%%.\n"):format(v0.ShootSuccessChancePerCharge, v0.ShootLessFailureChancePerCharge) .. ("For every additional Chance that's ingame, the duration of the flintlock's stun is decreased by %*%%.\n"):format(v0.ShootStunDurationDebuffPerChanceAlive) .. "This ability starts off with 0 charges and has a cap of 3 charges.\n" .. "Using this ability removes all charges on every ability.\n"
    },
    {
        Image = "rbxassetid://80029151869083",
        Header = "REROLL",
        Quote = "\"Just one more go at it and I'll be a millionaire!\" - A College Student in Debt",
        Text = ("Cooldown: %*s\n"):format(v0.RerollCooldown) .. "Chance rerolls the value of his Max HP stat.\n" .. "Upon activation, a random number between 70 to 110 is chosen.\n" .. "For every charge this ability has, the rolled value is modified as follows:\n" .. "  * 1 charge: No bonus.\n" .. "  * 2 charges: Rolled HP is increased by 5%.\n" .. "  * 3 charges: Rolled HP is increased by 10%.\n" .. "This ability starts off with 0 charges and has a cap of 3 charges.\n" .. "Chance's Maximum HP is unable to go beyond 120 HP.\n" .. "Using this ability removes all charges on every ability.\n"
    },
    {
        Image = "rbxassetid://93434599531478",
        Header = "HAT FIX",
        Quote = "\"This hat demonstrates good taste and exudes class.\" - Roblox",
        Text = ("Cooldown: %*s\n"):format(v0.HatFixCooldown) .. "Upon activating this ability, all <b>Vulnerable</b> stacks that were inflicted onto you through using <b>Coin Flip</b> are removed.\n" .. "This ability can only be used after reaching 3 charges for all other abilities.\n" .. "Using this ability removes all charges on every ability & re-enables the <b>One Shot</b> ability if it's disabled.\n"
    }
};
return v0;
]========]},
{path=[========[
ReplicatedStorage/Assets/Survivors/Chance/Behavior]========],before=[========[
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
                local v92 = math.min(math.round(math.random(v90.Config.HealthMin, v90.Config.HealthMax) - v90.Config.RerollBasePenalty) * (math.max(0, v90.Charges - 1) * 0.05 + 1), v90.Config.HealthMax);
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
]========],after=[========[
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
]========]},
{path=[========[
ReplicatedStorage/Assets/Survivors/Shedletsky/Config]========],before=[========[
-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local v0 = {
    DisplayName = "Shedletsky", 
    Quote = "\"BLAME JOHN!\"", 
    Credits = "", 
    Class = "Sentinel", 
    RenderImage = "rbxassetid://111665037685764", 
    Price = 0, 
    Speed = 12, 
    SlashDamage = 30, 
    SlashWindupTime = 0.575, 
    SlashStunTime = 3, 
    SlashCooldown = 40, 
    FriedChickenCooldown = 70, 
    FriedChickenHealDelay = 1.75, 
    FriedChickenHealInitialAmount = 5, 
    FriedChickenHealOvertimeAmount = 35, 
    FriedChickenHealOvertimeDuration = 10, 
    Expressions = {
        Happy = "rbxassetid://137551068213426", 
        Default = "rbxassetid://137697221376499", 
        Hurt = "rbxassetid://134306030860385", 
        Injured = "rbxassetid://118575590793740", 
        Dead = "rbxassetid://108810519694719", 
        Drinking = "rbxassetid://100494069665891", 
        StunnedKiller = "rbxassetid://111420395559656"
    }, 
    Animations = {
        Slash = "rbxassetid://70379019064941", 
        EatChicken = "rbxassetid://119947334563864"
    }, 
    Sounds = {
        Unsheath = "rbxassetid://12222225", 
        Slash = "rbxassetid://12222208", 
        Hit = "rbxassetid://17837549788", 
        EatFriedChicken = "rbxassetid://112706821141906"
    }, 
    TextInteractions = {
        Requests = {
            ElliotPizza = {
                "It\226\128\153s no chicken, but pizza could do the job just fine!", 
                "Can a guy like me get some pizza?", 
                "A slice of pizza should get me going for a little while longer.", 
                "Pizza\226\128\153s something I could really use right now.", 
                "Gimme\226\128\153 a good slice if you\226\128\153ve got any!"
            }, 
            BuildermanSentry = {
                "Builderman, this spot\226\128\153s good for a sentry, don\226\128\153t you think?", 
                "A sentry over here would be nice, eh, Builderman?", 
                "Place a sentry here, Builderman.", 
                "Builderman, put down a sentry over here.", 
                "You gotta put a sentry here Builder, this spot\226\128\153s pretty good."
            }, 
            BuildermanDispenser = {
                "Hey Builderman! This spot\226\128\153s good for a dispenser, don\226\128\153t you think?", 
                "You can tuck away a dispenser over here, Builder.", 
                "The spot over here\226\128\153s a great place for a dispenser.", 
                "Put your dispenser over here!", 
                "A dispenser could be good over here. What do you think, Builderman?"
            }, 
            DusekkarProtection = {
                "Dusek! I could use a little bit of your magic!", 
                "Mind if I get a quick force field casting, Dusek?", 
                "Your spell-casting is pretty nice, can I get some of that?", 
                "Requesting a force field from you, pumpkin guy!", 
                "Hey, mind if I get a force field?"
            }, 
            HemmorhageAsk = {
                "Ah... bleeding a bit.. mind if I ask for some help?", 
                "I probably shouldn't have retired, heh.. I'm.. going to need your help for this.", 
                "Got me good, that one.. bleeding a bit... I need your help, buddy.", 
                "Hey man, uh.. I'm bleeding a little bit here... Could you help with that?", 
                "Tch... got me good, that one. Can you help with this?"
            }
        }, 
        Thanks = {
            Regular = {
                "Thanks, buddy!", 
                "Thanks, now let me keep trying to help you guys.", 
                "Nice work, I knew you wouldn\226\128\153t let me down.", 
                "I\226\128\153m glad you\226\128\153re around to help.", 
                "Thanks, man. Appreciate it.", 
                "Thank you."
            }, 
            DusekkarProtection = {
                {
                    "Shedletsky: Brings back memories, huh Dusek?", 
                    "Dusekkar: You will live aslong as I stand, a magic controlled by my hand."
                }
            }, 
            BuildermanDispenser = {
                {
                    "Builderman: I'm on it!", 
                    "Shedletsky: Good to see you standing Builder!", 
                    "Builderman: We have to stand strong for the others.", 
                    "Shedletsky: Always!"
                }
            }, 
            BuildermanSentry = {
                {
                    "Shedletsky: Thanks Builder!", 
                    "Builderman: Ha... It's gettin' stressful every round...", 
                    "Builderman: Especially 1x1x1x1, its sword skills are formidable.", 
                    "Shedletsky: ...", 
                    "Builderman: You doin alright?", 
                    "Shedletsky: Ah... Sorry Builder, lost focus for a second...", 
                    "Builderman: Stay alert John. We need to help our team."
                }
            }
        }
    }
};
v0.Information = {
    {
        Separator = "GENERAL INFO"
    }, 
    {
        Header = "SHEDLETSKY", 
        Text = "Blame John.\nAn important figure in Roblox history, he wields a historical Linked Sword to cut the killer in it's tracks.\n"
    }, 
    {
        Header = "STATS", 
        Text = "Difficulty: \226\152\133\226\152\133\226\152\134\226\152\134\226\152\134\n" .. ("Health: %*\n"):format(v0.Health or 100) .. ("Regular Speed: %*\n"):format(v0.Speed or 12) .. ("Sprinting Speed: %*\n"):format(v0.SprintSpeed or 26) .. ("Max Stamina: %*\n"):format(v0.MaxStamina or 100) .. ("Stamina Loss per sec: %*\n"):format(v0.StaminaLoss or 10) .. ("Stamina Gain per sec: %*\n"):format(v0.StaminaGain or 20)
    }, 
    {
        Separator = "ABILITIES"
    }, 
    {
        Image = "rbxassetid://85282571177550", 
        Header = "SLASH", 
        Quote = "\"Death before dishonor.\" - Shedletsky", 
        Text = ("Cooldown: %*s\n"):format(v0.SlashCooldown) .. ("Stun Time: %*\n"):format(v0.SlashStunTime) .. ("Damage: %*\n"):format(v0.SlashDamage) .. "Shedletsky equips one of his many SFOTH swords and slashes forward, stunning the killer if the attack hits.\n" .. ("<b>Resistance II</b> is applied for %*s on activation.\n"):format(v0.SlashWindupTime) .. ("Slows down the player by 75%% for %*s while in use.\n"):format(v0.SlashWindupTime + 1)
    }, 
    {
        Image = "rbxassetid://87451970500470", 
        Header = "FRIED CHICKEN", 
        Quote = "\"You won the annual chicken eat off hosted by Shedletsky!\" - Builderman", 
        Text = ("Cooldown: %*s\n"):format(v0.FriedChickenCooldown) .. ("Shedletsky pulls out a piece of fried chicken and takes a bite out of it, restoring %* HP upon consumption and %* HP over the span of %*s. If Shedletsky is hit by a Killer during the period of regaining HP, then the healing effect is cancelled.\n"):format(v0.FriedChickenHealInitialAmount, v0.FriedChickenHealOvertimeAmount, v0.FriedChickenHealOvertimeDuration) .. "<b>This ability can only be used twice.</b>\n"
    }
};
return v0;]========],after=[========[
-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local v0 = {
    DisplayName = "Shedletsky", 
    Quote = "\"BLAME JOHN!\"", 
    Credits = "", 
    Class = "Sentinel", 
    RenderImage = "rbxassetid://111665037685764", 
    Price = 0, 
    Speed = 12, 
    SlashDamage = 30, 
    SlashWindupTime = 0.55,
    SlashSlowDuration = 1.4, 
    SlashStunTime = 3, 
    SlashCooldown = 40, 
    FriedChickenCooldown = 70, 
    FriedChickenHealDelay = 1.75, 
    FriedChickenHealInitialAmount = 5, 
    FriedChickenHealOvertimeAmount = 25, 
    FriedChickenHealOvertimeDuration = 10, 
    Expressions = {
        Happy = "rbxassetid://137551068213426", 
        Default = "rbxassetid://137697221376499", 
        Hurt = "rbxassetid://134306030860385", 
        Injured = "rbxassetid://118575590793740", 
        Dead = "rbxassetid://108810519694719", 
        Drinking = "rbxassetid://100494069665891", 
        StunnedKiller = "rbxassetid://111420395559656"
    }, 
    Animations = {
        Slash = "rbxassetid://70379019064941", 
        EatChicken = "rbxassetid://119947334563864"
    }, 
    Sounds = {
        Unsheath = "rbxassetid://12222225", 
        Slash = "rbxassetid://12222208", 
        Hit = "rbxassetid://17837549788", 
        EatFriedChicken = "rbxassetid://112706821141906"
    }, 
    TextInteractions = {
        Requests = {
            ElliotPizza = {
                "It\226\128\153s no chicken, but pizza could do the job just fine!", 
                "Can a guy like me get some pizza?", 
                "A slice of pizza should get me going for a little while longer.", 
                "Pizza\226\128\153s something I could really use right now.", 
                "Gimme\226\128\153 a good slice if you\226\128\153ve got any!"
            }, 
            BuildermanSentry = {
                "Builderman, this spot\226\128\153s good for a sentry, don\226\128\153t you think?", 
                "A sentry over here would be nice, eh, Builderman?", 
                "Place a sentry here, Builderman.", 
                "Builderman, put down a sentry over here.", 
                "You gotta put a sentry here Builder, this spot\226\128\153s pretty good."
            }, 
            BuildermanDispenser = {
                "Hey Builderman! This spot\226\128\153s good for a dispenser, don\226\128\153t you think?", 
                "You can tuck away a dispenser over here, Builder.", 
                "The spot over here\226\128\153s a great place for a dispenser.", 
                "Put your dispenser over here!", 
                "A dispenser could be good over here. What do you think, Builderman?"
            }, 
            DusekkarProtection = {
                "Dusek! I could use a little bit of your magic!", 
                "Mind if I get a quick force field casting, Dusek?", 
                "Your spell-casting is pretty nice, can I get some of that?", 
                "Requesting a force field from you, pumpkin guy!", 
                "Hey, mind if I get a force field?"
            }, 
            HemmorhageAsk = {
                "Ah... bleeding a bit.. mind if I ask for some help?", 
                "I probably shouldn't have retired, heh.. I'm.. going to need your help for this.", 
                "Got me good, that one.. bleeding a bit... I need your help, buddy.", 
                "Hey man, uh.. I'm bleeding a little bit here... Could you help with that?", 
                "Tch... got me good, that one. Can you help with this?"
            }
        }, 
        Thanks = {
            Regular = {
                "Thanks, buddy!", 
                "Thanks, now let me keep trying to help you guys.", 
                "Nice work, I knew you wouldn\226\128\153t let me down.", 
                "I\226\128\153m glad you\226\128\153re around to help.", 
                "Thanks, man. Appreciate it.", 
                "Thank you."
            }, 
            DusekkarProtection = {
                {
                    "Shedletsky: Brings back memories, huh Dusek?", 
                    "Dusekkar: You will live aslong as I stand, a magic controlled by my hand."
                }
            }, 
            BuildermanDispenser = {
                {
                    "Builderman: I'm on it!", 
                    "Shedletsky: Good to see you standing Builder!", 
                    "Builderman: We have to stand strong for the others.", 
                    "Shedletsky: Always!"
                }
            }, 
            BuildermanSentry = {
                {
                    "Shedletsky: Thanks Builder!", 
                    "Builderman: Ha... It's gettin' stressful every round...", 
                    "Builderman: Especially 1x1x1x1, its sword skills are formidable.", 
                    "Shedletsky: ...", 
                    "Builderman: You doin alright?", 
                    "Shedletsky: Ah... Sorry Builder, lost focus for a second...", 
                    "Builderman: Stay alert John. We need to help our team."
                }
            }
        }
    }
};
v0.Information = {
    {
        Separator = "GENERAL INFO"
    }, 
    {
        Header = "SHEDLETSKY", 
        Text = "Blame John.\nAn important figure in Roblox history, he wields a historical Linked Sword to cut the killer in it's tracks.\n"
    }, 
    {
        Header = "STATS", 
        Text = "Difficulty: \226\152\133\226\152\133\226\152\134\226\152\134\226\152\134\n" .. ("Health: %*\n"):format(v0.Health or 100) .. ("Regular Speed: %*\n"):format(v0.Speed or 12) .. ("Sprinting Speed: %*\n"):format(v0.SprintSpeed or 26) .. ("Max Stamina: %*\n"):format(v0.MaxStamina or 100) .. ("Stamina Loss per sec: %*\n"):format(v0.StaminaLoss or 10) .. ("Stamina Gain per sec: %*\n"):format(v0.StaminaGain or 20)
    }, 
    {
        Separator = "ABILITIES"
    }, 
    {
        Image = "rbxassetid://85282571177550", 
        Header = "SLASH", 
        Quote = "\"Death before dishonor.\" - Shedletsky", 
        Text = ("Cooldown: %*s\n"):format(v0.SlashCooldown) .. ("Stun Time: %*\n"):format(v0.SlashStunTime) .. ("Damage: %*\n"):format(v0.SlashDamage) .. "Shedletsky equips one of his many SFOTH swords and slashes forward, stunning the killer if the attack hits.\n" .. ("<b>Resistance II</b> is applied for %*s on activation.\n"):format(v0.SlashWindupTime) .. ("Slows down the player by 75%% for %*s while in use.\n"):format(v0.SlashSlowDuration)
    }, 
    {
        Image = "rbxassetid://87451970500470", 
        Header = "FRIED CHICKEN", 
        Quote = "\"You won the annual chicken eat off hosted by Shedletsky!\" - Builderman", 
        Text = ("Cooldown: %*s\n"):format(v0.FriedChickenCooldown) .. ("Shedletsky pulls out a piece of fried chicken and takes a bite out of it, restoring %* HP upon consumption and %* HP over the span of %*s. If Shedletsky is hit by a Killer during the period of regaining HP, then the healing effect is cancelled.\n"):format(v0.FriedChickenHealInitialAmount, v0.FriedChickenHealOvertimeAmount, v0.FriedChickenHealOvertimeDuration) .. "<b>This ability can only be used twice.</b>\n"
    }
};
return v0;]========]},
{path=[========[
ReplicatedStorage/Assets/Survivors/Shedletsky/Behavior]========],before=[========[
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
                    task.delay(v21.Config.SlashWindupTime + 1, function() --[[ Line: 127 ]]
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
                                    if v46 <= 0 or v46 <= l_Health_1 - 10 then
                                        v43 = false;
                                        v45:Disconnect();
                                        v45 = nil;
                                    end;
                                    l_Health_1 = v46;
                                end);
                                local v47 = 0;
                                while true do
                                    if v31.Rig.Parent then
                                        local v48 = task.wait();
                                        v47 = v47 + v48;
                                        if not v43 then
                                            return;
                                        elseif not v31.Rig.Parent then
                                            return;
                                        elseif v31.Config.FriedChickenHealOvertimeDuration <= v47 then
                                            return;
                                        else
                                            v2:Heal(l_Humanoid_1, v48 * v31.Config.FriedChickenHealOvertimeAmount / v31.Config.FriedChickenHealOvertimeDuration);
                                        end;
                                    else
                                        --[[ close >= 1 ]]
                                        break;
                                    end;
                                end;
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
return v0;]========],after=[========[
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
return v0;]========]},
{path=[========[
ServerStorage/Assets/Survivors/Shedletsky/Behavior]========],before=[========[
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
                    task.delay(v21.Config.SlashWindupTime + 1, function() --[[ Line: 127 ]]
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
                                    if v46 <= 0 or v46 <= l_Health_1 - 10 then
                                        v43 = false;
                                        v45:Disconnect();
                                        v45 = nil;
                                    end;
                                    l_Health_1 = v46;
                                end);
                                local v47 = 0;
                                while true do
                                    if v31.Rig.Parent then
                                        local v48 = task.wait();
                                        v47 = v47 + v48;
                                        if not v43 then
                                            return;
                                        elseif not v31.Rig.Parent then
                                            return;
                                        elseif v31.Config.FriedChickenHealOvertimeDuration <= v47 then
                                            return;
                                        else
                                            v2:Heal(l_Humanoid_1, v48 * v31.Config.FriedChickenHealOvertimeAmount / v31.Config.FriedChickenHealOvertimeDuration);
                                        end;
                                    else
                                        --[[ close >= 1 ]]
                                        break;
                                    end;
                                end;
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
return v0;]========],after=[========[
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
return v0;]========]},
{path=[========[
ServerStorage/Assets/Survivors/Shedletsky/Config]========],before=[========[
-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local v0 = {
    DisplayName = "Shedletsky", 
    Quote = "\"BLAME JOHN!\"", 
    Credits = "", 
    Class = "Sentinel", 
    RenderImage = "rbxassetid://111665037685764", 
    Price = 0, 
    Speed = 12, 
    SlashDamage = 30, 
    SlashWindupTime = 0.575, 
    SlashStunTime = 3, 
    SlashCooldown = 40, 
    FriedChickenCooldown = 70, 
    FriedChickenHealDelay = 1.75, 
    FriedChickenHealInitialAmount = 5, 
    FriedChickenHealOvertimeAmount = 35, 
    FriedChickenHealOvertimeDuration = 10, 
    Expressions = {
        Happy = "rbxassetid://137551068213426", 
        Default = "rbxassetid://137697221376499", 
        Hurt = "rbxassetid://134306030860385", 
        Injured = "rbxassetid://118575590793740", 
        Dead = "rbxassetid://108810519694719", 
        Drinking = "rbxassetid://100494069665891", 
        StunnedKiller = "rbxassetid://111420395559656"
    }, 
    Animations = {
        Slash = "rbxassetid://70379019064941", 
        EatChicken = "rbxassetid://119947334563864"
    }, 
    Sounds = {
        Unsheath = "rbxassetid://12222225", 
        Slash = "rbxassetid://12222208", 
        Hit = "rbxassetid://17837549788", 
        EatFriedChicken = "rbxassetid://112706821141906"
    }, 
    TextInteractions = {
        Requests = {
            ElliotPizza = {
                "It\226\128\153s no chicken, but pizza could do the job just fine!", 
                "Can a guy like me get some pizza?", 
                "A slice of pizza should get me going for a little while longer.", 
                "Pizza\226\128\153s something I could really use right now.", 
                "Gimme\226\128\153 a good slice if you\226\128\153ve got any!"
            }, 
            BuildermanSentry = {
                "Builderman, this spot\226\128\153s good for a sentry, don\226\128\153t you think?", 
                "A sentry over here would be nice, eh, Builderman?", 
                "Place a sentry here, Builderman.", 
                "Builderman, put down a sentry over here.", 
                "You gotta put a sentry here Builder, this spot\226\128\153s pretty good."
            }, 
            BuildermanDispenser = {
                "Hey Builderman! This spot\226\128\153s good for a dispenser, don\226\128\153t you think?", 
                "You can tuck away a dispenser over here, Builder.", 
                "The spot over here\226\128\153s a great place for a dispenser.", 
                "Put your dispenser over here!", 
                "A dispenser could be good over here. What do you think, Builderman?"
            }, 
            DusekkarProtection = {
                "Dusek! I could use a little bit of your magic!", 
                "Mind if I get a quick force field casting, Dusek?", 
                "Your spell-casting is pretty nice, can I get some of that?", 
                "Requesting a force field from you, pumpkin guy!", 
                "Hey, mind if I get a force field?"
            }, 
            HemmorhageAsk = {
                "Ah... bleeding a bit.. mind if I ask for some help?", 
                "I probably shouldn't have retired, heh.. I'm.. going to need your help for this.", 
                "Got me good, that one.. bleeding a bit... I need your help, buddy.", 
                "Hey man, uh.. I'm bleeding a little bit here... Could you help with that?", 
                "Tch... got me good, that one. Can you help with this?"
            }
        }, 
        Thanks = {
            Regular = {
                "Thanks, buddy!", 
                "Thanks, now let me keep trying to help you guys.", 
                "Nice work, I knew you wouldn\226\128\153t let me down.", 
                "I\226\128\153m glad you\226\128\153re around to help.", 
                "Thanks, man. Appreciate it.", 
                "Thank you."
            }, 
            DusekkarProtection = {
                {
                    "Shedletsky: Brings back memories, huh Dusek?", 
                    "Dusekkar: You will live aslong as I stand, a magic controlled by my hand."
                }
            }, 
            BuildermanDispenser = {
                {
                    "Builderman: I'm on it!", 
                    "Shedletsky: Good to see you standing Builder!", 
                    "Builderman: We have to stand strong for the others.", 
                    "Shedletsky: Always!"
                }
            }, 
            BuildermanSentry = {
                {
                    "Shedletsky: Thanks Builder!", 
                    "Builderman: Ha... It's gettin' stressful every round...", 
                    "Builderman: Especially 1x1x1x1, its sword skills are formidable.", 
                    "Shedletsky: ...", 
                    "Builderman: You doin alright?", 
                    "Shedletsky: Ah... Sorry Builder, lost focus for a second...", 
                    "Builderman: Stay alert John. We need to help our team."
                }
            }
        }
    }
};
v0.Information = {
    {
        Separator = "GENERAL INFO"
    }, 
    {
        Header = "SHEDLETSKY", 
        Text = "Blame John.\nAn important figure in Roblox history, he wields a historical Linked Sword to cut the killer in it's tracks.\n"
    }, 
    {
        Header = "STATS", 
        Text = "Difficulty: \226\152\133\226\152\133\226\152\134\226\152\134\226\152\134\n" .. ("Health: %*\n"):format(v0.Health or 100) .. ("Regular Speed: %*\n"):format(v0.Speed or 12) .. ("Sprinting Speed: %*\n"):format(v0.SprintSpeed or 26) .. ("Max Stamina: %*\n"):format(v0.MaxStamina or 100) .. ("Stamina Loss per sec: %*\n"):format(v0.StaminaLoss or 10) .. ("Stamina Gain per sec: %*\n"):format(v0.StaminaGain or 20)
    }, 
    {
        Separator = "ABILITIES"
    }, 
    {
        Image = "rbxassetid://85282571177550", 
        Header = "SLASH", 
        Quote = "\"Death before dishonor.\" - Shedletsky", 
        Text = ("Cooldown: %*s\n"):format(v0.SlashCooldown) .. ("Stun Time: %*\n"):format(v0.SlashStunTime) .. ("Damage: %*\n"):format(v0.SlashDamage) .. "Shedletsky equips one of his many SFOTH swords and slashes forward, stunning the killer if the attack hits.\n" .. ("<b>Resistance II</b> is applied for %*s on activation.\n"):format(v0.SlashWindupTime) .. ("Slows down the player by 75%% for %*s while in use.\n"):format(v0.SlashWindupTime + 1)
    }, 
    {
        Image = "rbxassetid://87451970500470", 
        Header = "FRIED CHICKEN", 
        Quote = "\"You won the annual chicken eat off hosted by Shedletsky!\" - Builderman", 
        Text = ("Cooldown: %*s\n"):format(v0.FriedChickenCooldown) .. ("Shedletsky pulls out a piece of fried chicken and takes a bite out of it, restoring %* HP upon consumption and %* HP over the span of %*s. If Shedletsky is hit by a Killer during the period of regaining HP, then the healing effect is cancelled.\n"):format(v0.FriedChickenHealInitialAmount, v0.FriedChickenHealOvertimeAmount, v0.FriedChickenHealOvertimeDuration) .. "<b>This ability can only be used twice.</b>\n"
    }
};
return v0;]========],after=[========[
-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local v0 = {
    DisplayName = "Shedletsky", 
    Quote = "\"BLAME JOHN!\"", 
    Credits = "", 
    Class = "Sentinel", 
    RenderImage = "rbxassetid://111665037685764", 
    Price = 0, 
    Speed = 12, 
    SlashDamage = 30, 
    SlashWindupTime = 0.55,
    SlashSlowDuration = 1.4, 
    SlashStunTime = 3, 
    SlashCooldown = 40, 
    FriedChickenCooldown = 70, 
    FriedChickenHealDelay = 1.75, 
    FriedChickenHealInitialAmount = 5, 
    FriedChickenHealOvertimeAmount = 25, 
    FriedChickenHealOvertimeDuration = 10, 
    Expressions = {
        Happy = "rbxassetid://137551068213426", 
        Default = "rbxassetid://137697221376499", 
        Hurt = "rbxassetid://134306030860385", 
        Injured = "rbxassetid://118575590793740", 
        Dead = "rbxassetid://108810519694719", 
        Drinking = "rbxassetid://100494069665891", 
        StunnedKiller = "rbxassetid://111420395559656"
    }, 
    Animations = {
        Slash = "rbxassetid://70379019064941", 
        EatChicken = "rbxassetid://119947334563864"
    }, 
    Sounds = {
        Unsheath = "rbxassetid://12222225", 
        Slash = "rbxassetid://12222208", 
        Hit = "rbxassetid://17837549788", 
        EatFriedChicken = "rbxassetid://112706821141906"
    }, 
    TextInteractions = {
        Requests = {
            ElliotPizza = {
                "It\226\128\153s no chicken, but pizza could do the job just fine!", 
                "Can a guy like me get some pizza?", 
                "A slice of pizza should get me going for a little while longer.", 
                "Pizza\226\128\153s something I could really use right now.", 
                "Gimme\226\128\153 a good slice if you\226\128\153ve got any!"
            }, 
            BuildermanSentry = {
                "Builderman, this spot\226\128\153s good for a sentry, don\226\128\153t you think?", 
                "A sentry over here would be nice, eh, Builderman?", 
                "Place a sentry here, Builderman.", 
                "Builderman, put down a sentry over here.", 
                "You gotta put a sentry here Builder, this spot\226\128\153s pretty good."
            }, 
            BuildermanDispenser = {
                "Hey Builderman! This spot\226\128\153s good for a dispenser, don\226\128\153t you think?", 
                "You can tuck away a dispenser over here, Builder.", 
                "The spot over here\226\128\153s a great place for a dispenser.", 
                "Put your dispenser over here!", 
                "A dispenser could be good over here. What do you think, Builderman?"
            }, 
            DusekkarProtection = {
                "Dusek! I could use a little bit of your magic!", 
                "Mind if I get a quick force field casting, Dusek?", 
                "Your spell-casting is pretty nice, can I get some of that?", 
                "Requesting a force field from you, pumpkin guy!", 
                "Hey, mind if I get a force field?"
            }, 
            HemmorhageAsk = {
                "Ah... bleeding a bit.. mind if I ask for some help?", 
                "I probably shouldn't have retired, heh.. I'm.. going to need your help for this.", 
                "Got me good, that one.. bleeding a bit... I need your help, buddy.", 
                "Hey man, uh.. I'm bleeding a little bit here... Could you help with that?", 
                "Tch... got me good, that one. Can you help with this?"
            }
        }, 
        Thanks = {
            Regular = {
                "Thanks, buddy!", 
                "Thanks, now let me keep trying to help you guys.", 
                "Nice work, I knew you wouldn\226\128\153t let me down.", 
                "I\226\128\153m glad you\226\128\153re around to help.", 
                "Thanks, man. Appreciate it.", 
                "Thank you."
            }, 
            DusekkarProtection = {
                {
                    "Shedletsky: Brings back memories, huh Dusek?", 
                    "Dusekkar: You will live aslong as I stand, a magic controlled by my hand."
                }
            }, 
            BuildermanDispenser = {
                {
                    "Builderman: I'm on it!", 
                    "Shedletsky: Good to see you standing Builder!", 
                    "Builderman: We have to stand strong for the others.", 
                    "Shedletsky: Always!"
                }
            }, 
            BuildermanSentry = {
                {
                    "Shedletsky: Thanks Builder!", 
                    "Builderman: Ha... It's gettin' stressful every round...", 
                    "Builderman: Especially 1x1x1x1, its sword skills are formidable.", 
                    "Shedletsky: ...", 
                    "Builderman: You doin alright?", 
                    "Shedletsky: Ah... Sorry Builder, lost focus for a second...", 
                    "Builderman: Stay alert John. We need to help our team."
                }
            }
        }
    }
};
v0.Information = {
    {
        Separator = "GENERAL INFO"
    }, 
    {
        Header = "SHEDLETSKY", 
        Text = "Blame John.\nAn important figure in Roblox history, he wields a historical Linked Sword to cut the killer in it's tracks.\n"
    }, 
    {
        Header = "STATS", 
        Text = "Difficulty: \226\152\133\226\152\133\226\152\134\226\152\134\226\152\134\n" .. ("Health: %*\n"):format(v0.Health or 100) .. ("Regular Speed: %*\n"):format(v0.Speed or 12) .. ("Sprinting Speed: %*\n"):format(v0.SprintSpeed or 26) .. ("Max Stamina: %*\n"):format(v0.MaxStamina or 100) .. ("Stamina Loss per sec: %*\n"):format(v0.StaminaLoss or 10) .. ("Stamina Gain per sec: %*\n"):format(v0.StaminaGain or 20)
    }, 
    {
        Separator = "ABILITIES"
    }, 
    {
        Image = "rbxassetid://85282571177550", 
        Header = "SLASH", 
        Quote = "\"Death before dishonor.\" - Shedletsky", 
        Text = ("Cooldown: %*s\n"):format(v0.SlashCooldown) .. ("Stun Time: %*\n"):format(v0.SlashStunTime) .. ("Damage: %*\n"):format(v0.SlashDamage) .. "Shedletsky equips one of his many SFOTH swords and slashes forward, stunning the killer if the attack hits.\n" .. ("<b>Resistance II</b> is applied for %*s on activation.\n"):format(v0.SlashWindupTime) .. ("Slows down the player by 75%% for %*s while in use.\n"):format(v0.SlashSlowDuration)
    }, 
    {
        Image = "rbxassetid://87451970500470", 
        Header = "FRIED CHICKEN", 
        Quote = "\"You won the annual chicken eat off hosted by Shedletsky!\" - Builderman", 
        Text = ("Cooldown: %*s\n"):format(v0.FriedChickenCooldown) .. ("Shedletsky pulls out a piece of fried chicken and takes a bite out of it, restoring %* HP upon consumption and %* HP over the span of %*s. If Shedletsky is hit by a Killer during the period of regaining HP, then the healing effect is cancelled.\n"):format(v0.FriedChickenHealInitialAmount, v0.FriedChickenHealOvertimeAmount, v0.FriedChickenHealOvertimeDuration) .. "<b>This ability can only be used twice.</b>\n"
    }
};
return v0;]========]},
{path=[========[
ServerStorage/Assets/Survivors/Chance/Config]========],before=[========[
-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local v0 = {
    DisplayName = "Chance",
    Quote = "\"99% of gamblers quit before they win big\"",
    Credits = "",
    Class = "Sentinel",
    RenderImage = "rbxassetid://126924178701380",
    Price = 777,
    Speed = 12,
    HealthMin = 65,
    HealthMax = 130,
    CoinFlipCooldown = 1.75,
    CoinFlipWeaknessDuration = 15,
    CoinFlipPity = 2.5,
    GunAlwaysVisible = false,
    ShootSuccessChancePerCharge = 20,
    ShootLessFailureChancePerCharge = 10,
    ShootStunDurationDebuffPerChanceAlive = 15,
    ShootCooldown = 45,
    ShootHitboxSize = 2.5,
    ShootHitboxRange = 90,
    ShootMaxStunDuration = 4,
    ShootMinStunDuration = 1,
    ShootMaxKnockback = 14,
    ShootMinKnockback = 5,
    ShootDamage = 50,
    ShootKnockback = 3,
    ShootExplosionKnockback = 25,
    ShootExplosionStunDuration = 5,
    ShootSelfDamage = 25,
    CameraShakeMagnitude = 1.5,
    CameraShakeDuration = 0.4,
    RerollBasePenalty = 10,
    RerollCooldown = 20,
    RandomnessDifferencePerCharge = 3,
    HatFixCooldown = 60,
	Expressions = {
		Happy = "rbxassetid://92225688434461",
		Default = "rbxassetid://76254460000954",
		Hurt = "rbxassetid://102172172675803",
		Injured = "rbxassetid://83906964540493",
		Dead = "rbxassetid://123735458751609",
		Drinking = "rbxassetid://89448343694123",
		Gambling = "rbxassetid://113790771759092",
		Sad = "rbxassetid://132238504335731",
		Uhoh = "rbxassetid://90106827583875"
    },
    Animations = {
        FlipCoinHeads = "rbxassetid://113049523133974",
        FlipCoinTails = "rbxassetid://113238245087870",
        AimGun = "rbxassetid://130898730062374",
        GunFire = "rbxassetid://98303778862384",
        GunFail = "rbxassetid://80859169196524",
        GunExplode = "rbxassetid://108665611403553",
        HatFix = "rbxassetid://117170871416506"
    },
    Sounds = {
        FlipCoinHeadsSFX = "rbxassetid://104239877200025",
        FlipCoinTailsSFX = "rbxassetid://101120969540575",
        FlipCoinSFX = "rbxassetid://76040750930413",
        StatRerollSFX = "rbxassetid://83163547903343",
        GunWindUpSFX = "rbxassetid://139526116364056",
        GunFireSuccessSFX = "rbxassetid://114083139823568",
        GunExplodeSFX = "rbxassetid://2814355346",
        GunHitSFX = "rbxassetid://124324777507465"
    },
    TextInteractions = {
        Requests = {
            ElliotPizza = {
                "Heyy! Can\226\128\153t a guy like me get some pizza \226\128\152round here?",
                "Hey kid! Mind if I get a good slice of pizza?",
                "Lady Luck\226\128\153s not on my side right now, mind if I get a slice as a good luck charm?",
                "Some pizza should set me right back on my feet. Spare some, won\226\128\153tcha?",
                "Your pizza\226\128\153s got something to it, kid! Hurry and throw one my way!"
            },
            BuildermanSentry = {
                "Heya\226\128\153, a sentry over here could do some quick work on those nutjobs.",
                "One sentry over here, Builder bro!",
                "Soo.. a sentry here should be fine, don\226\128\153tcha think?",
                "Right here\226\128\153s a good spot for a sentry!",
                "Buildin\226\128\153 a sentry over here should be good!"
            },
            BuildermanDispenser = {
                "Hey Doc\226\128\153, a dispenser over here should work wonders!",
                "Work your dispenser over in this spot!",
                "Dispenser over here! Quick!",
                "I gotta use some of your dispensers here! Put \226\128\152er down!",
                "Put your dispenser over here, Doc!"
            },
            DusekkarProtection = {
                "Pumpkin fella\226\128\153, I could use some of your magic!",
                "A little help over here with your magic?",
                "That magical force field of yours would be nice to have, you know?",
                "Your force field might keep me safe in case my flintlock explodes!",
                "A force field would be useful right about now!"
            },
            HemmorhageAsk = {
                "Wow, ahaha... I'm... bleeding. Could ya' help with that? Please? Pretty please?",
                "Ah. I'm bleeding.. caaannn I ask for some help?",
                "Bleeding! Hurts! A lot..! It sucks! Help me out here, bud...",
                "Spare some help for a dying fella' over here? I'll repay the favor! Someday!",
                "I really, really hate bleeding, don't you? Help out a dying person here bud..."
            }
        },
        Thanks = {
            Regular = {
                "Heh, thanks pal!",
                "You won\226\128\153t regret this one bit!",
                "Glad to have received the help, pal!",
                "Thanks! This should be useful.",
                "Thanks! Now to get back to shootin\226\128\153.",
                "Alright, thanks pal!"
            }
        }
    }
};
v0.Information = {
    {
        Separator = "GENERAL INFO"
    },
    {
        Header = "CHANCE",
        Text = "The sounds of machines promising great rewards spiral within his ears. Gambling with his life, his potential lies inside of the result of his coin. He also wields a shoddy flintlock that feels like it could break at any moment, but it's one that he'll take to his death.\n"
    },
    {
        Header = "STATS",
        Text = "Difficulty: \240\159\142\176 \240\159\142\176 \240\159\142\176 never stop gambling\n" .. ("Health: %*-%*\n"):format(v0.HealthMin, v0.HealthMax) .. ("Regular Speed: %*\n"):format(v0.Speed or 12) .. ("Sprinting Speed: %*\n"):format(v0.SprintSpeed or 26) .. ("Max Stamina: %*\n"):format(v0.MaxStamina or 100) .. ("Stamina Loss per sec: %*\n"):format(v0.StaminaLoss or 10) .. ("Stamina Gain per sec: %*\n"):format(v0.StaminaGain or 20)
    },
    {
        Separator = "PASSIVES"
    },
    {
        Header = "UNPREDICTABLE FATE",
        Quote = "\"TAKE A CHANCE WITH CHAAAANCE BABY\" - Chance",
        Text = "Chance's Max HP stat is set to be a random value of 70-90.\n"
    },
    {
        Separator = "ABILITIES"
    },
    {
        Image = "rbxassetid://91225744028483",
        Header = "COIN FLIP",
        Quote = "\"I gambled with my LIFE\" - ???     \"did you win though\" - Chance",
        Text = ("Cooldown: %*s\n"):format(v0.CoinFlipCooldown) .. "Chance flips a coin.\n" .. "If the coin lands on heads, gain a charge for all other abilities.\n" .. ("If the coin lands on tails, gain <b>Vulnerable</b> for %*s.\n"):format(v0.CoinFlipWeaknessDuration) .. "For every time the coin lands on tails, the level of <b>Vulnerable</b> that gets inflicted on you goes up by 1.\n" .. "<b>The Vulnerable that gets inflicted has no cap.</b>\n" .. ("Coin Flip gains +%*%% increased chance to land on heads for every consecutive tails, resetting when a heads is rolled.\n"):format(v0.CoinFlipPity)
    },
    {
        Image = "rbxassetid://78498256535383",
        Header = "ONE SHOT",
        Quote = "\"You only have one shot.\" - Talking Cat",
        Text = ("Cooldown: %*s\n"):format(v0.ShootCooldown) .. "Chance pulls out an unreliable flintlock, and after a windup of 1s, pulls the trigger.\n" .. "Upon the flintlock being triggered, all of the possible outcomes can occur:\n" .. "  * (25% chance) Nothing happens.\n" .. ("  * (25%% chance) The flintlock explodes, dealing %* damage to the user and generating a 6\195\1516\195\1516 hitbox around Chance that stuns the Killer for %* seconds, then disables the ability indefinitely.\n"):format(v0.ShootSelfDamage, v0.ShootExplosionStunDuration) .. ("  * (50%% chance) The flintlock fires, stunning any killer that gets shot at within %* studs for %*-%*s. The shot becomes less effective depending on how far away Chance is from the killer.\n"):format(v0.ShootHitboxRange, v0.ShootMinStunDuration, v0.ShootMaxStunDuration) .. ("For every additional charge that this ability has, the chance of a successful shot will go up by %*%% while every other outcome's chance will decrease by %*%%.\n"):format(v0.ShootSuccessChancePerCharge, v0.ShootLessFailureChancePerCharge) .. ("For every additional Chance that's ingame, the duration of the flintlock's stun is decreased by %*%%.\n"):format(v0.ShootStunDurationDebuffPerChanceAlive) .. "This ability starts off with 0 charges and has a cap of 3 charges.\n" .. "Using this ability removes all charges on every ability.\n"
    },
    {
        Image = "rbxassetid://80029151869083",
        Header = "REROLL",
        Quote = "\"Just one more go at it and I'll be a millionaire!\" - A College Student in Debt",
        Text = ("Cooldown: %*s\n"):format(v0.RerollCooldown) .. "Chance rerolls the value of his Max HP stat.\n" .. "Upon activation, a random number between 55 to 120 is chosen.\n" .. "For every charge this ability has, the rolled value is modified as follows:\n" .. "  * 1 charge: No bonus.\n" .. "  * 2 charges: Rolled HP is increased by 5%.\n" .. "  * 3 charges: Rolled HP is increased by 10%.\n" .. "This ability starts off with 0 charges and has a cap of 3 charges.\n" .. "Chance's Maximum HP is unable to go beyond 130 HP.\n" .. "Using this ability removes all charges on every ability.\n"
    },
    {
        Image = "rbxassetid://93434599531478",
        Header = "HAT FIX",
        Quote = "\"This hat demonstrates good taste and exudes class.\" - Roblox",
        Text = ("Cooldown: %*s\n"):format(v0.HatFixCooldown) .. "Upon activating this ability, all <b>Vulnerable</b> stacks that were inflicted onto you through using <b>Coin Flip</b> are removed.\n" .. "This ability can only be used after reaching 3 charges for all other abilities.\n" .. "Using this ability removes all charges on every ability & re-enables the <b>One Shot</b> ability if it's disabled.\n"
    }
};
return v0;
]========],after=[========[
-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local v0 = {
    DisplayName = "Chance",
    Quote = "\"99% of gamblers quit before they win big\"",
    Credits = "",
    Class = "Sentinel",
    RenderImage = "rbxassetid://126924178701380",
    Price = 777,
    Speed = 12,
    HealthMin = 70,
    HealthMax = 110,
    HealthClamp = 120,
    CoinFlipCooldown = 1.75,
    CoinFlipWeaknessDuration = 15,
    CoinFlipPity = 2.5,
    GunAlwaysVisible = false,
    ShootSuccessChancePerCharge = 20,
    ShootLessFailureChancePerCharge = 10,
    ShootStunDurationDebuffPerChanceAlive = 15,
    ShootCooldown = 45,
    ShootHitboxSize = 2.5,
    ShootHitboxRange = 90,
    ShootMaxStunDuration = 4,
    ShootMinStunDuration = 1,
    ShootMaxKnockback = 14,
    ShootMinKnockback = 5,
    ShootDamage = 50,
    ShootKnockback = 3,
    ShootExplosionKnockback = 25,
    ShootExplosionStunDuration = 5,
    ShootSelfDamage = 25,
    CameraShakeMagnitude = 1.5,
    CameraShakeDuration = 0.4,
    RerollBasePenalty = 0,
    RerollCooldown = 20,
    RandomnessDifferencePerCharge = 3,
    HatFixCooldown = 60,
	Expressions = {
		Happy = "rbxassetid://92225688434461",
		Default = "rbxassetid://76254460000954",
		Hurt = "rbxassetid://102172172675803",
		Injured = "rbxassetid://83906964540493",
		Dead = "rbxassetid://123735458751609",
		Drinking = "rbxassetid://89448343694123",
		Gambling = "rbxassetid://113790771759092",
		Sad = "rbxassetid://132238504335731",
		Uhoh = "rbxassetid://90106827583875"
    },
    Animations = {
        FlipCoinHeads = "rbxassetid://113049523133974",
        FlipCoinTails = "rbxassetid://113238245087870",
        AimGun = "rbxassetid://130898730062374",
        GunFire = "rbxassetid://98303778862384",
        GunFail = "rbxassetid://80859169196524",
        GunExplode = "rbxassetid://108665611403553",
        HatFix = "rbxassetid://117170871416506"
    },
    Sounds = {
        FlipCoinHeadsSFX = "rbxassetid://104239877200025",
        FlipCoinTailsSFX = "rbxassetid://101120969540575",
        FlipCoinSFX = "rbxassetid://76040750930413",
        StatRerollSFX = "rbxassetid://83163547903343",
        GunWindUpSFX = "rbxassetid://139526116364056",
        GunFireSuccessSFX = "rbxassetid://114083139823568",
        GunExplodeSFX = "rbxassetid://2814355346",
        GunHitSFX = "rbxassetid://124324777507465"
    },
    TextInteractions = {
        Requests = {
            ElliotPizza = {
                "Heyy! Can\226\128\153t a guy like me get some pizza \226\128\152round here?",
                "Hey kid! Mind if I get a good slice of pizza?",
                "Lady Luck\226\128\153s not on my side right now, mind if I get a slice as a good luck charm?",
                "Some pizza should set me right back on my feet. Spare some, won\226\128\153tcha?",
                "Your pizza\226\128\153s got something to it, kid! Hurry and throw one my way!"
            },
            BuildermanSentry = {
                "Heya\226\128\153, a sentry over here could do some quick work on those nutjobs.",
                "One sentry over here, Builder bro!",
                "Soo.. a sentry here should be fine, don\226\128\153tcha think?",
                "Right here\226\128\153s a good spot for a sentry!",
                "Buildin\226\128\153 a sentry over here should be good!"
            },
            BuildermanDispenser = {
                "Hey Doc\226\128\153, a dispenser over here should work wonders!",
                "Work your dispenser over in this spot!",
                "Dispenser over here! Quick!",
                "I gotta use some of your dispensers here! Put \226\128\152er down!",
                "Put your dispenser over here, Doc!"
            },
            DusekkarProtection = {
                "Pumpkin fella\226\128\153, I could use some of your magic!",
                "A little help over here with your magic?",
                "That magical force field of yours would be nice to have, you know?",
                "Your force field might keep me safe in case my flintlock explodes!",
                "A force field would be useful right about now!"
            },
            HemmorhageAsk = {
                "Wow, ahaha... I'm... bleeding. Could ya' help with that? Please? Pretty please?",
                "Ah. I'm bleeding.. caaannn I ask for some help?",
                "Bleeding! Hurts! A lot..! It sucks! Help me out here, bud...",
                "Spare some help for a dying fella' over here? I'll repay the favor! Someday!",
                "I really, really hate bleeding, don't you? Help out a dying person here bud..."
            }
        },
        Thanks = {
            Regular = {
                "Heh, thanks pal!",
                "You won\226\128\153t regret this one bit!",
                "Glad to have received the help, pal!",
                "Thanks! This should be useful.",
                "Thanks! Now to get back to shootin\226\128\153.",
                "Alright, thanks pal!"
            }
        }
    }
};
v0.Information = {
    {
        Separator = "GENERAL INFO"
    },
    {
        Header = "CHANCE",
        Text = "The sounds of machines promising great rewards spiral within his ears. Gambling with his life, his potential lies inside of the result of his coin. He also wields a shoddy flintlock that feels like it could break at any moment, but it's one that he'll take to his death.\n"
    },
    {
        Header = "STATS",
        Text = "Difficulty: \240\159\142\176 \240\159\142\176 \240\159\142\176 never stop gambling\n" .. ("Health: %*-%*\n"):format(v0.HealthMin, v0.HealthMax) .. ("Regular Speed: %*\n"):format(v0.Speed or 12) .. ("Sprinting Speed: %*\n"):format(v0.SprintSpeed or 26) .. ("Max Stamina: %*\n"):format(v0.MaxStamina or 100) .. ("Stamina Loss per sec: %*\n"):format(v0.StaminaLoss or 10) .. ("Stamina Gain per sec: %*\n"):format(v0.StaminaGain or 20)
    },
    {
        Separator = "PASSIVES"
    },
    {
        Header = "UNPREDICTABLE FATE",
        Quote = "\"TAKE A CHANCE WITH CHAAAANCE BABY\" - Chance",
        Text = "Chance's Max HP stat is set to be a random value of 70-90.\n"
    },
    {
        Separator = "ABILITIES"
    },
    {
        Image = "rbxassetid://91225744028483",
        Header = "COIN FLIP",
        Quote = "\"I gambled with my LIFE\" - ???     \"did you win though\" - Chance",
        Text = ("Cooldown: %*s\n"):format(v0.CoinFlipCooldown) .. "Chance flips a coin.\n" .. "If the coin lands on heads, gain a charge for all other abilities.\n" .. ("If the coin lands on tails, gain <b>Vulnerable</b> for %*s.\n"):format(v0.CoinFlipWeaknessDuration) .. "For every time the coin lands on tails, the level of <b>Vulnerable</b> that gets inflicted on you goes up by 1.\n" .. "<b>The Vulnerable that gets inflicted has no cap.</b>\n" .. ("Coin Flip gains +%*%% increased chance to land on heads for every consecutive tails, resetting when a heads is rolled.\n"):format(v0.CoinFlipPity)
    },
    {
        Image = "rbxassetid://78498256535383",
        Header = "ONE SHOT",
        Quote = "\"You only have one shot.\" - Talking Cat",
        Text = ("Cooldown: %*s\n"):format(v0.ShootCooldown) .. "Chance pulls out an unreliable flintlock, and after a windup of 1s, pulls the trigger.\n" .. "Upon the flintlock being triggered, all of the possible outcomes can occur:\n" .. "  * (25% chance) Nothing happens.\n" .. ("  * (25%% chance) The flintlock explodes, dealing %* damage to the user and generating a 6\195\1516\195\1516 hitbox around Chance that stuns the Killer for %* seconds, then disables the ability indefinitely.\n"):format(v0.ShootSelfDamage, v0.ShootExplosionStunDuration) .. ("  * (50%% chance) The flintlock fires, stunning any killer that gets shot at within %* studs for %*-%*s. The shot becomes less effective depending on how far away Chance is from the killer.\n"):format(v0.ShootHitboxRange, v0.ShootMinStunDuration, v0.ShootMaxStunDuration) .. ("For every additional charge that this ability has, the chance of a successful shot will go up by %*%% while every other outcome's chance will decrease by %*%%.\n"):format(v0.ShootSuccessChancePerCharge, v0.ShootLessFailureChancePerCharge) .. ("For every additional Chance that's ingame, the duration of the flintlock's stun is decreased by %*%%.\n"):format(v0.ShootStunDurationDebuffPerChanceAlive) .. "This ability starts off with 0 charges and has a cap of 3 charges.\n" .. "Using this ability removes all charges on every ability.\n"
    },
    {
        Image = "rbxassetid://80029151869083",
        Header = "REROLL",
        Quote = "\"Just one more go at it and I'll be a millionaire!\" - A College Student in Debt",
        Text = ("Cooldown: %*s\n"):format(v0.RerollCooldown) .. "Chance rerolls the value of his Max HP stat.\n" .. "Upon activation, a random number between 70 to 110 is chosen.\n" .. "For every charge this ability has, the rolled value is modified as follows:\n" .. "  * 1 charge: No bonus.\n" .. "  * 2 charges: Rolled HP is increased by 5%.\n" .. "  * 3 charges: Rolled HP is increased by 10%.\n" .. "This ability starts off with 0 charges and has a cap of 3 charges.\n" .. "Chance's Maximum HP is unable to go beyond 120 HP.\n" .. "Using this ability removes all charges on every ability.\n"
    },
    {
        Image = "rbxassetid://93434599531478",
        Header = "HAT FIX",
        Quote = "\"This hat demonstrates good taste and exudes class.\" - Roblox",
        Text = ("Cooldown: %*s\n"):format(v0.HatFixCooldown) .. "Upon activating this ability, all <b>Vulnerable</b> stacks that were inflicted onto you through using <b>Coin Flip</b> are removed.\n" .. "This ability can only be used after reaching 3 charges for all other abilities.\n" .. "Using this ability removes all charges on every ability & re-enables the <b>One Shot</b> ability if it's disabled.\n"
    }
};
return v0;
]========]},
{path=[========[
ServerStorage/Assets/Survivors/Chance/Behavior]========],before=[========[
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
                local v92 = math.min(math.round(math.random(v90.Config.HealthMin, v90.Config.HealthMax) - v90.Config.RerollBasePenalty) * (math.max(0, v90.Charges - 1) * 0.05 + 1), v90.Config.HealthMax);
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
]========],after=[========[
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
]========]}}
local function find(path)
 local object=game
 for name in path:gmatch("[^/]+")do object=object:FindFirstChild(name);assert(object,"Missing "..path)end
 return object
end
local function setNumber(source,name,value,optional)
 local count
 source,count=("\n"..source):gsub("([\r\n]%s*"..name.."%s*=%s*)[%d%.]+(%s*[,;])",function(prefix,suffix)
  return prefix..tostring(value)..suffix
 end)
 assert(count==1 or(optional and count==0),"Could not uniquely update Config field "..name..". Nothing changed.")
 return source:sub(2),count
end
local function patchConfig(source,path)
 if path:find("/Chance/Config",1,true)then
  source=setNumber(source,"HealthMin",70)
  source=setNumber(source,"HealthMax",110)
  source=setNumber(source,"RerollBasePenalty",0)
  local count
  source,count=setNumber(source,"HealthClamp",120,true)
  if count==0 then
   source=source:gsub("([\r\n]%s*HealthMax%s*=%s*110%s*[,;])","%1\n    HealthClamp = 120,",1)
  end
  source=source:gsub("between 55 to 120","between 70 to 110"):gsub("beyond 130 HP","beyond 120 HP")
 else
  source=setNumber(source,"SlashWindupTime",0.55)
  source=setNumber(source,"FriedChickenHealOvertimeAmount",25)
  local count
  source,count=setNumber(source,"SlashSlowDuration",1.4,true)
  if count==0 then
   source=source:gsub("([\r\n]%s*SlashWindupTime%s*=%s*0%.55%s*[,;])","%1\n    SlashSlowDuration = 1.4,",1)
  end
  source=source:gsub("v0%.SlashWindupTime %+ 1","v0.SlashSlowDuration")
 end
 return source
end
local changed={}
for _,change in changes do
 change.object=find(change.path)
 if change.path:match("/Config$")then
  local actual=change.object.Source
  change.after=patchConfig(actual,change.path)
  change.before=actual
 end
 assert(change.object.Source==change.before or change.object.Source==change.after,"Source differs from the supplied build: "..change.path..". Nothing changed.")
 if change.object.Source~=change.after then table.insert(changed,change)end
end
if #changed==0 then print("Chance and Shedletsky repair already installed.");return end
local backup=Instance.new("Folder");backup.Name="ChanceShedletskyBackup_"..os.time()
for i,change in changed do
 local saved=Instance.new("StringValue");saved.Name=tostring(i);saved.Value=change.before;saved.Parent=backup
 local target=Instance.new("ObjectValue");target.Name="Target";target.Value=change.object;target.Parent=saved
end
backup.Parent=game:GetService("ServerStorage")
local ok,err=pcall(function()for _,change in changed do change.object.Source=change.after end end)
if not ok then
 for _,change in changed do pcall(function()change.object.Source=change.before end)end
 error("Repair failed; original Sources restored: "..tostring(err))
end
print("Chance and Shedletsky repaired. Save and start a fresh Play test. Backup: "..backup:GetFullName())
