
local t1 = {
	DisplayName = "Two Time",
	Quote = "\"Shadows die twice.\"",
	Class = "Sentinel",
	RenderImage = "rbxassetid://107234615040462",
	Price = 500,
	Exclusive = false,
	LMSEffect = {
		ProcessingModule = "BasicLMS",
		SoundId = "heartbeat",
		ImageId = function(s1: string) -- line: 14
			if s1 == "Azure" then
				return "rbxassetid://114627570317346"
			end

			return "rbxassetid://103025892289003"
		end,
		PrimaryColor = function(s2: string) -- line: 20
			if s2 == "Azure" then
				return Color3.fromRGB(115, 0, 255)
			end

			return Color3.fromRGB(255, 0, 0)
		end,
		SecondaryColor = Color3.fromRGB(0, 0, 0)
	},
	Health = 80,
	Speed = 12,
	DaggerCooldown = 30,
	DaggerWindup = 0.3,
	DaggerDamage = 10,
	DaggerBackstabDamage = 20,
	DaggerLungeForce = 110,
	DaggerUncrouchedLungeForce = 50,
	DaggerBackstabThreshold = 70,
	DaggerLookDirectionAngle = 70,
	DaggerStatusTime = 1,
	DaggerBackstabStatusTime = 3.5,
	DaggerCrouchMinStunTime = 2,
	DaggerCrouchStunChargeTime = 1,
	DaggerLifestealFromFront = 0,
	DaggerLifestealFromBack = 0,
	DaggerCrouchEndlag = 0.225,
	DaggerCrouchEndlagTweenTime = 0.15,
	DaggerCrouchMoverEndlag = 0.4,
	DaggerCrouchSprintLockTime = 1,
	DaggerUncrouchedSprintLockTime = 1,
	DaggerMissSlownessDistanceInterval = 10,
	DaggerMissSlownessDurationMultiplier = 1,
	DaggerMissSlownessMaxDuration = 8,
	DaggerMissSlownessLevel = 2,
	PrayRange = 10,
	PrayHoldTime = NumberRange.new(0.15, 30),
	PrayHighlightDuration = 4,
	PrayHighlightImage = "rbxassetid://100508591140926",
	PrayHealthPerFullOblation = 66.66666666666667,
	PrayFullConversionTime = 10,
	PrayInterruptDamage = 5,
	PrayInterruptCooldown = 6,
	DaggerResLevel = 1,
	DaggerResDuration = 0.7,
	BloodReqIncreasePerTwoTime = 1,
	CrouchCooldown = 30,
	CrouchMinCooldown = 15,
	CrouchDuration = 15,
	CrouchSpeed = 10,
	CrouchRunSpeed = 23,
	CrouchInvisibilityLevel = 3,
	CrouchUndetectableLevel = 1,
	CrouchSpeedCloseTime = 1,
	CrouchStabAmplifyTime = 4,
	CrouchRevealTime = 2,
	CrouchSpeedBoostMax = 1.5,
	CrouchSpeedBoostTime = 4,
	CrouchSpeedBoostDot = 0.2,
	CrouchSpeedBoostDistance = 105,
	CrouchTeammateRevealDistance = 100,
	CrouchTeammateRevealFadeTime = 1.25,
	CrouchOblationMultiplier = 1.25,
	CrouchDistances = {
		CLOSE = {
			0,
			30
		},
		DEBUFF_SLOWNESS = {
			75,
			-1
		},
		DEBUFF_HIGHLIGHT = {
			125,
			-1
		}
	},
	CrouchSlownessDebuffMax = 150,
	Lives = 2,
	BloodRequiredForRespawn = 8,
	BloodFromFront = 1.6,
	BloodFromBack = 3.2,
	RespawnLocationDistance = 10,
	NextLifeHealthDivisor = 1.6,
	InvincibilityDuration = 2,
	LastSurvivorMaxHealth = 110,
	LastSurvivorHealthBonus = 50,
	RespawnLocation = script.Spawn,
 HealthBar = script.Sidebar,
 AudioReplication = script.AudioReplication,
 VFX = script.TwoTimeVFX,
 LifeAppearances = {[1]=script.Life1,[2]=script.Life2},
 DaggerTemplate = script.GhostFire,
	Animations = {},
 Sounds = {},
	ExpressionsTable = {
		[1] = {
			Happy = "rbxassetid://82471736046966",
			Default = "rbxassetid://111259025475261",
			Hurt = "rbxassetid://124079311211417",
			Injured = "rbxassetid://82982231751339",
			Dead = "rbxassetid://74288576584860",
			Drinking = "rbxassetid://135845534213100"
		},
		[2] = {
			Happy = "rbxassetid://105016806376431",
			Default = "rbxassetid://80110682472998",
			Hurt = "rbxassetid://91658006415418",
			Injured = "rbxassetid://135831503096288",
			Dead = "rbxassetid://86722867217862",
			Drinking = "rbxassetid://116753879639619"
		}
	}
}

t1.Expressions = t1.ExpressionsTable[1]
t1.TextInteractions = {
	Requests = {
		ElliotPizza = {
			"Hey, hey. Pizza, pizza please.",
			"Pizza’s something I haven’t tried much, mind if I get a slice?",
			"I must ask for a pizza.",
			"Do you have pizza? I could use one!",
			"May I have a pizza slice?",
			"I really want a pizza! May I have one?"
		},
		BuildermanSentry = {
			"Your turrets may be of use over here.",
			"A sentry here should be put to use. Place it here.",
			"Place your sentry over here. It will help against the foes.",
			"Put down a sentry here.",
			"Your sentry will be of use over here."
		},
		BuildermanDispenser = {
			"I’m in need of a dispenser in my position.",
			"I require a dispenser to be placed here.",
			"Dispenser here, please.",
			"Put down one of your dispensers here.",
			"Your dispenser is needed here."
		},
		DusekkarProtection = {
			"Divine pumpkin, I humbly request your divine ability.",
			"Divine pumpkin, I implore you to cast your ability onto me.",
			"Divine pumpkin, I ask of thee to be blessed.",
			"Divine pumpkin, blessed be thy heart should you cast a spell unto me.",
			"Divine pumpkin, I ask for thy divine intervention."
		},
		HemmorhageAsk = {
			"By the Spawn's grace... I ... I must ask for your aid...",
			"My wounds.. are severe, I fear. Please, aid me, and the Spawn will smile at thy.",
			"I beg, I plead.. I ask for your aid as my body drains with every second...",
			"May you be blessed by the Spawn should you lend me your aid..",
			"Lend me your aid, and the Spawn shall guide you forward..."
		},
		HelperPulse = {
			"Your mechanisms are of most utmost importance right now, no time to waste..",
			"Keep a steady pace, machine... You mustn't waste a minute in tending to the group.",
			"Let your energy shine in those who need it most...",
			"Perhaps you may use your energy on the ones who may need it?",
			"We are in need of your energy, mechanism, and we must get it, fast.."
		},
		HelperInspire = {
			"Make haste, for our group seem to have grown exhausted..",
			"Let your mechanisms beam on the group, and may their beings feel ever so blessed by the Spawn while you do so.",
			"Shall we huddle closer together so your energy is conserved when you activate it?",
			"You've a keen eye for the others, do you not? You must see that they have grown tired.. You simply must help.",
			"We need your assistance on the matter, do you still have the energy to do so?"
		}
	},
	Thanks = {
		Regular = {
			"Much appreciated.",
			"Very thankful for your service.",
			"May good fortune come your way for your generosity.",
			"The Spawn would be pleased with your acts of kindness.",
			"I thank you for your service.",
			"Oh give thanks to the Spawn, for he is good; for their steadfast love endures forever."
		},
		DusekkarProtection = {
			{
				"TwoTime: The Spawn would be pleased with your acts of kindness!",
				"Dusekkar: ...",
				"Dusekkar: Eugh..."
			},
			{
				"TwoTime: Oh give thanks to the Spawn, for he is good; for their steadfast love endures forever.",
				"Dusekkar: ...",
				"Dusekkar: Ugh..."
			}
		}
	}
}

local v2 = math.floor(t1.BloodFromFront / t1.BloodRequiredForRespawn * 100)
local v3 = math.floor(t1.BloodFromBack / t1.BloodRequiredForRespawn * 100)

t1.Information = {
	{
		Separator = "GENERAL INFO"
	},
	{
		Header = "TWO TIME",
		Text = "A fragile cultist that holds a terrible secret. Bearing nothing other than a sleek dagger and manic smile, they're able to earn a second life through risk and sacrifice.\n"
	},
	{
		Header = "STATS",
		Text = "Difficulty: ★★★★☆\n" .. `Health: { t1.Health or 100 }\n` .. `Regular Speed: { t1.Speed or 12 }\n` .. `Sprinting Speed: { t1.SprintSpeed or 26 }\n` .. `Max Stamina: { t1.MaxStamina or 100 }\n` .. `Stamina Loss per sec: { t1.StaminaLoss or 10 }\n` .. `Stamina Gain per sec: { t1.StaminaGain or 20 }\n`
	},
	{
		Separator = "PASSIVES"
	},
	{
		Header = "OBLATION",
		Quote = "\"You both shall set out on the grand step to rebirth.\" - ██████",
		Text = "<font color=\"#6c6e78\">Two Time</font> has a bar on the right side of the screen that, when filled, grants them a second life.\n" .. "The only way to fill this bar is by dealing damage to the Killer.\n\n" .. `Landing a stab to the front will fill { v2 }% of the bar.\n` .. `Landing a stab to the back will fill { v3 }% of the bar.\n` .. "Crouched Lunge Stabs increases the <b>OBLATION</b> gain by 25%.\n\n" .. "<font color=\"#6c6e78\">Two Time</font> will enter their second life upon taking lethal damage or being the last alive Survivor.\n" .. "In their second life, they only have 50 maximum health.\n" .. "Upon activation:\n\n" .. " * Stamina is restored by 40%\n" .. " * All status effects are removed\n" .. ` * <font color="#6c6e78">Two Time</font> is made invincible for { t1.InvincibilityDuration } seconds \n` .. " * <b>Speed II</b> is applied for 6 seconds\n" .. " * <b>Vulnerable V</b> is applied for 12 seconds\n"
	},
	{
		Separator = "ABILITIES"
	},
	{
		Header = "SACRIFICIAL DAGGER",
		Image = "rbxassetid://129077533212750",
		Quote = "\"Lookie, █████—they gave us this cool knife!\" - Two Time",
		Text = `Cooldown: { t1.DaggerCooldown }s\n` .. `After a { t1.DaggerWindup }s windup, <font color="#6c6e78">Two Time</font> stabs forward and gains <b>Resistance { t1.DaggerResLevel }</b> for { t1.DaggerResDuration } seconds.\n\n` .. `Landing a stab to the front will do { t1.DaggerDamage } damage and inflict <b>Slowness II</b> and <b>Helpless I</b> for { t1.DaggerStatusTime }s.\n\n` .. `Landing a stab to the back will instead do { t1.DaggerBackstabDamage } damage and stun the Killer for 2s.\n\n` .. `Using this ability while <b>crouched</b> quickly lunges you forward with a stab that has increased endlag but grants 25% more <b>OBLATION</b> progress. A crouched backstab's stun scales linearly from { t1.DaggerCrouchMinStunTime }s to { t1.DaggerBackstabStatusTime }s after { t1.DaggerCrouchStunChargeTime }s of crouching. The charge is measured when the stab begins.\n\n` .. `Missing a <b>crouched stab</b> will inflict <font color="#6c6e78">Two Time</font> with Slowness II for up to { t1.DaggerMissSlownessMaxDuration }s depending on their distance from the Killer after it ends.\n\n` .. "Landing a stab on a summon or a stun immune Killer does not grant any <b>OBLATION</b> progress.\n"
	},
	{
		Header = "CROUCH",
		Image = "rbxassetid://77707049887484",
		Quote = "\"Quiet, Two Time! They're not supposed to see us in here, hehe!\" - █████",
		Text = `Cooldown: { t1.CrouchCooldown }s\n` .. "<font color=\"#6c6e78\">Two Time</font> crouches down to silence their footsteps and become stealthier.\n\n" .. `<font color="#6c6e78">Two Time</font> remains <b>crouched</b> for at most { t1.CrouchDuration } seconds, but can uncrouch whenever they need to.\n` .. `Crouching applies <b>Undetectable I</b> and <b>Invisibility III</b> for at most { t1.CrouchDuration } seconds.\n\n` .. `While <b>crouched</b>, <font color="#6c6e78">Two Time</font>'s aura is revealed to teammates within { t1.CrouchTeammateRevealDistance } studs.\n\n` .. `While <b>crouched</b>, <font color="#6c6e78">Two Time</font> will gradually gain speed while running towards the Killer, with this speed boost capping out at { math.round((t1.CrouchSpeedBoostMax - 1) * 100) }% after { t1.CrouchSpeedBoostTime }s of running. This speed boost is immediately lost if <font color="#6c6e78">Two Time</font> exits Crouch, takes damage, or stops running towards the Killer.\n\n` .. "Uncrouching manually will forcibly remove these statuses and if <font color=\"#6c6e78\">Two Time</font> is within 30 studs of the Killer, will additionally grant <font color=\"#6c6e78\">Two Time</font> <b>Speed II</b> for 1s.\n"
	},
	{
		Header = "PRAY",
		Image = "rbxassetid://83582849559932",
		Quote = "\"May Spawn bless us today!\" - ██████",
		Text = "<font color=\"#6c6e78\">Two Time</font> will kneel near their <b>RITUAL</b> and begin praying while this ability is held.\n" .. "Letting go of the ability will stop <b>PRAYING</b>.\n\n" .. "While <b>PRAYING</b>, <font color=\"#6c6e78\">Two Time</font> will rapidly exchange <b>OBLATION</b> progress for HP.\n" .. `<font color="#6c6e78">Two Time</font> will gain 1 HP for every { 100 / t1.PrayHealthPerFullOblation }% <b>OBLATION</b> progress spent, restoring up to approximately { string.format("%.2f", t1.PrayHealthPerFullOblation) } HP from a full bar, without exceeding their maximum health.\n\n` .. "If <font color=\"#6c6e78\">Two Time</font> is not near their <b>RITUAL</b> when attempting to use this ability, the location of their <b>RITUAL</b> will be revealed to them for 4s.\n\n" .. "<font color=\"#6c6e78\">Two Time</font> is unable to use this ability if they do not have a <b>RITUAL</b>.\n"
	},
	{
		Header = "RITUAL",
		Image = "rbxassetid://95580729656404",
		Quote = "\"Spawn will be eternally pleased at our devotion!\" - ██████",
		Text = "<font color=\"#6c6e78\">Two Time</font> inscribes a respawn location on the ground.\n" .. "Dying with a full <b>OBLATION</b> bar will instantly teleport <font color=\"#6c6e78\">Two Time</font> to this point.\n\n" .. "<b>This ability can only be used once per round.</b>\n\n" .. "If <font color=\"#6c6e78\">Two Time</font> becomes the last survivor alive and has not already entered their second life, <b>RITUAL</b> will automatically trigger regardless of whether <b>OBLATION</b> was full or not.\n" .. `If this happens, <font color="#6c6e78">Two Time</font> will have their maximum health increased up to { t1.LastSurvivorMaxHealth }, be healed for up to { t1.LastSurvivorHealthBonus } HP, and will not be afflicted with <b>Vulnerable V</b>.` .. "Additionally, they will not teleport to their Ritual, and any buffs they receive will be decreased depending on how much <b>OBLATION</b> they are missing.\n"
	},
	{
		Separator = "CREDITS",
		Text = "Writer: 4Montaigne, sayso_1230Programmer: voxov_tired, ffPranksterDesigner: astertudeAnimator: sayso_1230Renderer: doc"
	}
}

-- Port choices where the export lacks authoritative server code:
-- Preserve FCT hitbox size but remove the close-range dead zone; raw-root placement.
-- Miss penalty grows outside the 30-stud close range; no penalty without a killer.
t1.DaggerHitboxSize=Vector3.new(4,6,5.5)
t1.DaggerHitboxOffset=3.25
t1.DaggerMissSlownessSafeDistance=30
t1.WarningTemplate=script:FindFirstChild("Warning")
t1.DaggerHitTime=.25
t1.DaggerCrouchHitTime=.415
t1.PraySensitiveButton=true
-- Custom, server-validated hold lease; omit PrayHoldTime to avoid the old generic charge protocol.
t1.PrayHoldTime=nil
t1.TwoTimeRoundHooks=false
t1.SprintSpeed=26
t1.MaxStamina=100
t1.StaminaLoss=10
t1.StaminaGain=20
t1.TwoTimePortVersion="1.0.1"
return t1