-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local v0 = {
    DisplayName = "Taph", 
    Quote = "\"BOOM BOOM BOOM!\"", 
    Credits = "", 
    Class = "Support", 
    RenderImage = "rbxassetid://92247293916990", 
    Price = 600, 
    Exclusive = false, 
    Health = 100, 
    Speed = 12, 
    TripwireCooldown = 25, 
    TripwireLifetime = 9000000000, 
    TripwireMaxAmount = 3, 
    TripwireHealth = 10, 
    TripwireLifetimeDecreasePerTaph = 20, 
    TripwireDistanceBetweenTripwires = 8, 
    TripwireTriggerSlownessData = {
        Level = 2, 
        Duration = 4
    }, 
    TripwireTriggerAuraRevealInvincibleDuration = 4, 
    TripwireTriggerAuraRevealDuration = 8, 
    TripwireTriggerAuraRevealDistance = 999, 
    TripwireStackPenalty = 1.5, 
    TripwirePingDuration = 999, 
    TripwirePingDistance = 999, 
    TripwireDestroyedAuraDuration = 2, 
    TripwireDurationBetweenRewards = 4, 
    TripwireCooldownWhilePlacing = 2.5, 
    TripwireSpeedWhilePlacing = 8.5, 
    TripwireTemplate = script.TripwireHook, 
    TripwireCFrameOffset = CFrame.Angles(0, 0, 1.5707963267948966), 
    SubspaceTripmineCooldown = 40, 
    SubspaceCooldownReductionOnSuccess = 10, 
    SubspaceDamage = 55, 
    SubspaceLifetime = 50, 
    SubspaceThrowForce = 50, 
    SubspaceRange = 19, 
    SubspaceEffectHitLevel = 1, 
    SubspaceEffectLevel = 3, 
    SubspaceEffectDuration = 6, 
    SubspaceHelplessDuration = 3,
    SubspaceWeaknessLevel = 5,
    SubspaceWeaknessDuration = 6, 
    SubspaceExplosionDelay = 0.5, 
    SubspaceStackPenalty = 2, 
    SubspacePingDuration = 999, 
    SubspacePingDistance = 999, 
    SubspaceHiddenTransparency = 0.85, 
    SubspaceHintCount = 3, 
    SubspaceHintTransparency = 0.6, 
    SubspaceExplosionVFX = script.ExplosionVFX, 
    Animations = {
        TripwireIdle = "rbxassetid://75625991717863", 
        TripwireWalk = "rbxassetid://123731621741837", 
        TripwireRun = "rbxassetid://123731621741837", 
        TripwirePlaceStart = "rbxassetid://78069053061919", 
        TripwirePlaceEnd = "rbxassetid://99579737338864", 
        ThrowSubspace = "rbxassetid://114426480803065"
    }, 
    Sounds = {
        BeartrapToss = "rbxassetid://2769387310", 
        BeartrapLatch = "rbxassetid://2769387865", 
        TripwireStart = "rbxassetid://108754052230881", 
        TripwirePlace = "rbxassetid://98335565360313", 
        SubspaceUse = "rbxassetid://93397698791738", 
        SubspaceToss = "rbxassetid://11956590", 
        SubspaceHint = "rbxassetid://11984254", 
        SubspaceDetonate = "rbxassetid://11984351", 
        SubspaceDetonateSensitive = "rbxassetid://96989396921162"
    }, 
    TextInteractions = {
        Requests = {
            ElliotPizza = {
                "\240\159\141\149\226\157\147 (Have pizza?)", 
                "\240\159\141\149\226\157\151 (Need pizza!)", 
                "\240\159\141\149\226\157\151\226\157\151 (Need pizza, now!!)", 
                "\240\159\141\149\240\159\152\139 (Pizza is yummy. Need some.)", 
                "\240\159\141\149\240\159\141\189\239\184\143\226\157\147 (Have pizza to eat?)"
            }, 
            BuildermanSentry = {
                "\240\159\148\171\226\157\147 (Sentry here?)", 
                "\240\159\148\171\226\157\151 (Sentry here!)", 
                "\240\159\148\171\240\159\146\165\226\157\147 (Sentry goes off here?)", 
                "\240\159\148\171\226\128\188\239\184\143\226\172\135\239\184\143 (Sentry over here!!)", 
                "\240\159\148\171\226\158\161\239\184\143\240\159\148\170\240\159\146\171 (Sentry handles the killer here.)"
            }, 
            BuildermanDispenser = {
                "\226\157\164\239\184\143\226\128\141\240\159\169\185\226\157\147 (Dispenser please?)", 
                "\226\157\164\239\184\143\226\128\141\240\159\169\185\226\157\151 (Dispenser, hurry!)", 
                "\226\157\164\239\184\143\226\128\141\240\159\169\185\240\159\141\142\226\157\147 (Dispenser heal, please?)", 
                "\240\159\141\142\226\172\135\239\184\143\226\157\151 (Dispenser here, now!)", 
                "\226\157\164\239\184\143\226\128\141\240\159\169\185\226\128\188\239\184\143 (Dispenser over here, now!!)"
            }, 
            DusekkarProtection = {
                "\240\159\142\131\226\156\168\240\159\145\135 (Pumpkin magic here, please!)", 
                "\240\159\142\131\226\156\168\226\157\147 (Pumpkin, can you use magic here?)", 
                "\240\159\142\131\226\156\168 \226\157\151 (Pumpkin, use magic here!)", 
                "\240\159\142\131\226\156\168\240\159\153\143 (Pumpkin, use your magic here, please.)", 
                "\240\159\142\131\226\156\168\240\159\164\178\226\157\147 (Pumpkin, may you cast magic on me?)"
            }, 
            HemmorhageAsk = {
                "\240\159\148\170\240\159\146\148\240\159\145\142\240\159\153\143\226\157\147\239\184\143 (Chest's hurting bad, help me, please?)", 
                "\240\159\169\184\240\159\152\162\240\159\145\137\240\159\164\149\226\157\147\239\184\143 (Bleeding hurts, can you aid?)", 
                "\240\159\169\184\240\159\169\184\240\159\152\133 \240\159\153\143\226\157\147\239\184\143 (Bleeding a lot, ahah... Help, please?)", 
                "\226\152\185\239\184\143\240\159\169\184\240\159\152\147\240\159\153\143\226\157\147\239\184\143 (Got hurt, I'm bleeding real bad, please help?)", 
                "\240\159\169\184\226\157\151\239\184\143\240\159\164\149\240\159\152\140\226\157\151\239\184\143 (Bleeding! Help, and I'll be thankful!)"
            }
        }, 
        Thanks = {
            Regular = {
                "\240\159\145\141\226\156\168 (Thank you, you\226\128\153re the best.)", 
                "\240\159\146\170\226\157\151 (Thank you, you\226\128\153ve empowered me!)", 
                "\240\159\153\143\240\159\145\143 (Much appreciated.)", 
                "\240\159\153\135\226\157\163\239\184\143 (Thank you so very much!)", 
                "\240\159\152\132\240\159\145\141 (Thank you, I appreciate it!)", 
                "\240\159\152\129\240\159\145\141 (Many thanks, I appreciate the gesture!)"
            }
        }
    }
};
v0.Information = {
    {
        Separator = "GENERAL INFO"
    }, 
    {
        Header = "TAPH", 
        Text = "A mute demolitionist who used to blow up unmoderated experiences for the greater good. This would lead to some unintended consequences.\nUses Tripwires and Subspace Tripmines to slow down, reveal the position of, and disorientate the Killer.\n"
    }, 
    {
        Header = "STATS", 
        Text = "Difficulty: \226\152\133\226\152\133\226\152\134\226\152\134\226\152\134\n" .. ("Health: %*\n"):format(v0.Health or 100) .. ("Regular Speed: %*\n"):format(v0.Speed or 12) .. ("Sprinting Speed: %*\n"):format(v0.SprintSpeed or 26) .. ("Max Stamina: %*\n"):format(v0.MaxStamina or 100) .. ("Stamina Loss per sec: %*\n"):format(v0.StaminaLoss or 10) .. ("Stamina Gain per sec: %*\n"):format(v0.StaminaGain or 20)
    }, 
    {
        Separator = "ABILITIES"
    }, 
    {
        Image = "rbxassetid://135707604176757", 
        Header = "TRIPWIRE", 
        Quote = "\"\240\159\148\151\240\159\154\182\226\128\141\226\153\130\239\184\143\240\159\144\140\226\154\160\239\184\143\240\159\145\165\"", 
        Text = ("Cooldown: %*s\n"):format(v0.TripwireCooldown) .. "Taph places a tripwire on the ground in order to impede the Killer and alert other Survivors of their presence.\n" .. ("If the Killer walks over a tripwire, all survivors have the Killer\226\128\153s aura revealed to them for %* seconds and the Killer suffers <b>Slowness II</b> for %* seconds.\n"):format(v0.TripwireTriggerAuraRevealDuration, v0.TripwireTriggerSlownessData.Duration) .. ("The duration of the <b>Slowness</b> is reduced by %*s for every Taph currently alive.\n"):format(v0.TripwireStackPenalty) .. ("Tripwires have a total of %* health and are able to be destroyed by the Killer if they hit it.\n"):format(v0.TripwireHealth) .. ("Tripwires cannot be placed within %* studs of each other.\n"):format(v0.TripwireDistanceBetweenTripwires) .. ("Taph can only have %* tripwires placed at once.\n"):format(v0.TripwireMaxAmount) .. "\nTripwires arm 1.5 seconds after placement and disappear when Taph dies. Their Slowness and aura reveal durations decrease by 1.5 seconds per additional living Taph.\n"
    }, 
    {
        Image = "rbxassetid://89334370123950", 
        Header = "SUBSPACE TRIPMINE", 
        Quote = "\"\240\159\145\129\226\128\141\240\159\151\168  \240\159\146\163\240\159\146\165\226\157\147\240\159\146\171\"", 
        Text = ("Cooldown: %*s\n"):format(v0.SubspaceTripmineCooldown) .. "Mines take 3 seconds to arm and detonate after 0.5 seconds when a killer is within 19 studs with line of sight. Explosions still hit through walls. Full effects: Subspaced III for 6s, Helpless I for 3s, Weakness V for 6s. Each additional living Taph reduces durations by 2s, to a minimum of 0s. A killer who strikes the mine receives only Subspaced I; Taph still receives full self-effects. Mines explode immediately when Taph dies.\n"
    }
};
return v0;