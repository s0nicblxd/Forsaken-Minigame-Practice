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
        Text = ("Cooldown: %*s\n"):format(v1.DigitalFootprintCooldown) .. "<font color=\"rgb(248,217,109)\">John Doe</font> stomps on the ground three times, commanding a shadow to emerge underneath his footsteps as a trap for survivors to walk over.\n" .. "If a survivor steps over the false shadow, then <font color=\"rgb(248,217,109)\">John Doe</font> gets a <b>Speed I</b> buff for 10 seconds and the survivor gets a <b>Corrupted I</b> & <b>Slowness II</b> debuff for 10 seconds.\n" .. "Upon the trap being triggered, <font color=\"rgb(248,217,109)\">John Doe</font> and the survivor who activated it have their auras revealed to each other for 10 seconds.\n" .. "The shadow despawns after contact is made with it or <font color=\"rgb(248,217,109)\">John Doe</font> attempts to place down a fourth shadow.\n" .. ("Digital Footprint is 30% larger. There can only be <b>%*</b> shadows present at once, and attempting to create more will cause the oldest shadow to dissipate.\n"):format(v1.DigitalFootprintLimit)
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
return v1;