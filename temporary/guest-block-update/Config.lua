-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local v0 = {
    DisplayName = "Guest 1337 (Rework)", 
    Quote = "\"Be strong. Always be strong.\"", 
    Credits = "", 
    Class = "Sentinel", 
	RenderImage = "rbxassetid://128543664752032", 
    Price = 0, 
    Health = 110, 
    Speed = 12, 
	BlockCooldown = 27,
    FailedBlockAbilityLockout = 2,
    BlockDuration = 1, 
    BlockSpeedLevel = 1, 
    BlockSpeedDuration = 2, 
	BlockOverhealGain = 10,
	BlockOverhealCap = 30,
    ResistanceLevel = 5, 
	SlownessDuration = 1.75,
	KillerSlownessPercent = 70, 
    KillerSlownessDuration = 1, 
	PunchCooldown = 55,
	PunchWindupTime = 0.6,
	PunchDashForce = 40,
	PunchKnockback = 7,
	PunchDamage = 25,
	PunchDebuffDuration = 2,
    PunchStunTime = 2, 
	ParryWindupTime = 0.4,
	ParryDashForce = 80,
	ParryKnockback = 13,
	ParryDamage = 35,
	ParryStunTime = 2,
    ParryUIStroke = script.ParryStroke, 
	ChargeCooldown = 40,
	ChargeDamage = 5,
	ChargingSpeed = 34,
	ChargingTurnSpeed = 2,
	ChargingDuration = 1.5,
	ChargeAbilityLockout = 1,
	ChargeKnockback = 6,
	ChargeKnockbackTotal = 11,
	ChargePunishmentDistanceInterval = 13,
	ChargePunishmentSlownessDurationMultiplier = 3,
	ChargePunishmentSlownessMaxDuration = 15,
	ChargePunishmentSlownessLevel = 2,
	ChargeKnockbackRampTime = 0.5,

	KillerChargeResistanceDuration = 20,
	KillerChargeResistanceDamage = 0, 
    Expressions = {
        Happy = "rbxassetid://90913260818643", 
        Default = "rbxassetid://102311710227265", 
        Hurt = "rbxassetid://78639914564808", 
        Injured = "rbxassetid://114619619541443", 
        Dead = "rbxassetid://79058110360960", 
        Drinking = "rbxassetid://109176035733881"
    }, 
    Animations = {
		Block = "rbxassetid://118368170242905",
		BlockBroken = "rbxassetid://96236383697532",
		Punch = "rbxassetid://116882371332622",
		ParryPunch = "rbxassetid://116882371332622",
		Charge = "rbxassetid://134975511388128",
    }, 
    Sounds = {
		BlockStart = "rbxassetid://8028421882", 
        BlockSuccess = "rbxassetid://75271649206104", 
		PunchWindup = "rbxassetid://609342351", 
		CriticalPunch = "rbxassetid://13471740561", 
		Punch = "rbxassetid://92048968269199", 
		Parry = "rbxassetid://98742971638242", 
		ChargingStart = "rbxassetid://105287227590031", 
		ChargingHit = "rbxassetid://114192939624246", 
		ChargingHitWeak = "rbxassetid://114192939624246", 
        ChargingCollide = "rbxassetid://9113225979", 
		ChargingTimeout = "rbxassetid://127014476912195", 
        ChargeCooldownActivated = "rbxassetid://6242625019"
    }, 
    TextInteractions = {
        Requests = {
            ElliotPizza = {
                "Your pizza is a necessity around here. I\226\128\153d like to ask for one.", 
                "A pizza slice would be nice right about now.", 
                "I can keep pushing through if I get a pizza.", 
                "Can I have a slice? I would be grateful for one.", 
                "A soldier knows when to appreciate the smaller moments. A pizza is one of them, if you\226\128\153d let me have one."
            }, 
            BuildermanSentry = {
                "Builder, this spot is good for a sentry. ", 
                "Over here\226\128\153s a good place for a sentry.", 
                "A sentry over here would be good.", 
                "Builder, putting a sentry over here would do some good.", 
                "One of your sentries over here would be good."
            }, 
            BuildermanDispenser = {
                "Builder, a dispenser over here would be beneficial.", 
                "One of your dispensers in this spot would do good.", 
                "Your dispenser here would be good.", 
                "Builder, your dispenser built here would be great for the others.", 
                "A spot like this is good for a dispenser.", 
                "Requesting a dispenser over on my position."
            }, 
            DusekkarProtection = {
                "One of your force fields could be good, I can fight them off better that way.", 
                "A force field from you is needed. It\226\128\153s for a good cause.", 
                "Your forcefield is good, I\226\128\153d like to have it casted on me for a bit.", 
                "I need some assistance in fighting them off. One of your force fields should do the trick.", 
                "A little help from you in defending me from the killer from afar would be appreciated."
            }, 
            HemmorhageAsk = {
                "I'm bleeding, but I know I can push on. I just need your help.", 
                "I may be hurt, but I can hold on for a bit longer. Just lend me a hand for a bit.", 
                "Stay here, please. I know I can keep going if I can just get some help with this wound.", 
                "Do you know how to patch a wound? Just need some help for my injuries.", 
                "Gonna have to ask for your help with this bleeding I'm having."
            }
        }, 
        Thanks = {
            Regular = {
                "I won\226\128\153t forget what you\226\128\153ve done for me, thanks.", 
                "Trust that I\226\128\153ll have your back for this.", 
                "Thank you for your service. You\226\128\153d have made a fine recruit.", 
                "I appreciate the gesture. I\226\128\153ll do my best out there.", 
                "Your help is greatly appreciated.", 
                "I promise to keep everyone safe after this. Thank you for your work."
            }
        }
    }
};
v0.Information = {
    {
        Separator = "GENERAL INFO"
    }, 
    {
        Header = "GUEST 1337", 
        Text = "A hardened veteran with battle scars from wars long ago. He has a tendency to sacrifice himself in order to keep those around him safe. With Guest's sturdiness, he can block, bash, and punch the killer to keep it away from harming his allies.\n"
    }, 
    {
        Header = "STATS", 
        Text = "Difficulty: \226\152\133\226\152\133\226\152\133\226\152\133\226\152\134\n" .. ("Health: %*\n"):format(v0.Health or 100) .. ("Regular Speed: %*\n"):format(v0.Speed or 12) .. ("Sprinting Speed: %*\n"):format(v0.SprintSpeed or 26) .. ("Max Stamina: %*\n"):format(v0.MaxStamina or 100) .. ("Stamina Loss per sec: %*\n"):format(v0.StaminaLoss or 10) .. ("Stamina Gain per sec: %*\n"):format(v0.StaminaGain or 20)
    }, 
    {
        Separator = "ABILITIES"
    }, 
    {
        Image = "rbxassetid://137576632569674", 
        Header = "BLOCK", 
        Quote = "\"Stay strong, friend. I got your back.\" - Guest 1337", 
        Text = ("Cooldown: %*s\n"):format(v0.BlockCooldown) .. ("Guest 1337 braces for impact, applying <b>Resistance V</b> (aka Invincibility) for %*s and has their movement reduced by 80%% for %*s.\n"):format(v0.BlockDuration, v0.SlownessDuration) .. ("Upon successfully blocking an attack, Guest 1337 has their movement speed restored, their <b>Resistance</b> status removed, and the attacking Killer has their movement speed reduced by 30%% for %*s.\n"):format(v0.KillerSlownessDuration) .. ("Successful blocks restore a charge for Guest 1337's <b>Punch</b> ability and grant <b>Speed I</b> for %*s.\n"):format(v0.BlockSpeedDuration) .. "<b>Projectiles CANNOT be blocked.\n</b>"
    }, 
    {
        Image = "rbxassetid://73254549946762", 
        Header = "CHARGE", 
        Quote = "\"Incoming! Look out!\" - Guest 1337", 
        Text = ("Cooldown: %*s\n"):format(v0.ChargeCooldown) .. ("Guest 1337 dashes forward in a shoulder-bash pose for %*s.\n"):format(v0.ChargingDuration) .. "If Guest 1337 collides with a killer during his charge, then the killer is knocked back and has their abilities locked for 1.25s. Guest 1337 also becomes invincible for 1.25s.\n" .. ("Not landing a charge on an enemy inflicts Guest 1337 with <b>Slowness II</b> that lasts for %* times Guest 1337's distance from the nearest killer divided by %*.\n"):format(v0.ChargePunishmentSlownessDurationMultiplier, v0.ChargePunishmentDistanceInterval) .. "Charge ends automatically if you crash into a wall.\n" .. "Guest 1337 cannot gain stamina while charging.\n"
    }, 
    {
        Image = "rbxassetid://86535502112498", 
        Header = "PUNCH", 
        Quote = "\"FALCAWN PAAWNCH\" - random guy", 
        Text = ("Guest 1337 winds up his fist for %*s and punches forward, stunning any killer within range of his punch for %*s.\n"):format(v0.PunchWindupTime, v0.PunchStunTime) .. ("If this ability is used within %*s of a successful block, then it becomes a Parry.\n"):format(v0.BlockDuration) .. ("Parried punches have a windup time of %*s and stun the killer for %*s.\n"):format(v0.ParryWindupTime, v0.ParryStunTime)
    }
};
return v0;