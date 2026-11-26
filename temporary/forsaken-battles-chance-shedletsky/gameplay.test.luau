local chance=(function()
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

end)()
local shed=(function()
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
return v0;
end)()
assert(chance.HealthMin==70 and chance.HealthMax==110 and chance.HealthClamp==120 and chance.RerollBasePenalty==0)
assert(shed.SlashWindupTime==.55 and shed.SlashSlowDuration==1.4)
assert(shed.FriedChickenHealInitialAmount==5 and shed.FriedChickenHealOvertimeAmount==25)
local selected=70
local math=table.clone(math);math.random=function(lo,hi)assert(lo==70 and hi==110);return selected end
local function roll(charges)
 local v90={Config=chance,Charges=charges}
return math.min(math.round(math.random(v90.Config.HealthMin, v90.Config.HealthMax) - v90.Config.RerollBasePenalty) * (math.max(0, v90.Charges - 1) * 0.05 + 1), v90.Config.HealthClamp)
end
for value=70,110 do
 selected=value
 for charges=1,3 do assert(math.abs(roll(charges)-math.min(value*(1+.05*(charges-1)),120))<1e-8)end
end
selected=110;assert(roll(3)==120)
print("PASS Chance: all base rolls and charges, no old penalty, independent 120 HP cap")
local function healScenario(damageAmount,removeRig)
 local listeners={}
 local hum={Health=50}
 hum.HealthChanged={Connect=function(_,callback)
  local connection={active=true}
  function connection:Disconnect()self.active=false end
  table.insert(listeners,{connection,callback});return connection
 end}
 local function health(value)
  hum.Health=value
  for _,entry in listeners do if entry[1].active then entry[2](value)end end
 end
 local v31={Config=shed,Rig={Parent=true}}
 local l_Humanoid_1=hum
 local healed=0
 local v2={Heal=function(_,_,amount)healed+=amount;health(hum.Health+amount)end}
 local ticks=0
 local task={wait=function()
  ticks+=1
  if ticks==2 and damageAmount then health(hum.Health-damageAmount)end
  if ticks==2 and removeRig then v31.Rig.Parent=nil end
  return 2.7
 end}
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

 for _,entry in listeners do assert(not entry[1].active,"healing listener leaked")end
 return healed
end
assert(math.abs(healScenario()-25)<1e-8,"last healing tick was lost")
assert(math.abs(healScenario(4)-25)<1e-8,"4 damage incorrectly cancelled healing")
assert(healScenario(5)<25,"5 damage did not cancel healing")
assert(healScenario(6)<25 and healScenario(nil,true)<25)
print("PASS chicken: full 25 overtime, 5 damage threshold, smaller hits, removal and listener cleanup")
