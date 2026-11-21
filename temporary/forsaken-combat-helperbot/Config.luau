
local t1 = {
	DisplayName = "Helperbot",
	Quote = "I WILL HELP YOU\"",
	Credits = "OutIaw_Nova, Enoderen, Maus4lia",
	Class = "Support",
	RenderImage = "rbxassetid://117351795339867",
	Price = 650,
	Exclusive = false,
	Health = 80,
	Speed = 12,
	PulseCooldown = 44,
	InspirationCooldown = 46,
	LMSEffect = {
		ProcessingModule = "BasicLMS",
		SoundId = "heartbeat",
		ImageId = function(_: string) -- line: 6
			return "rbxassetid://80896333518640"
		end,
		PrimaryColor = Color3.fromRGB(255, 0, 0),
		SecondaryColor = Color3.fromRGB(0, 0, 0)
	},
	Instances = {
		RadarEffectPart = script.Radar,
		ChargeMeter = script.ChargeMeter,
		VFXPulseHit = script.VFX.PulseHit,
		VFXPulse = script.VFX.Pulse,
		VFXInspireActive = script.VFX.InspireActive,
		Class_InspirationBillboard = if not game:GetService("RunService"):IsClient() then nil else script.cl_HelperbotChargeBillboard
	},
	ClassConfigs = {
		InspirationBillboard = {
			ChargeColors = {
				Default = Color3.new(0.9, 0.9, 0.9),
				Success = Color3.new(0.9, 0.9, 0)
			}
		}
	},
	Requests = {
		HelperInspire = {
			Order = 1,
			AbilityName = "Inspiration",
			RequestTitle = "Request Inspiration",
			NotificationTitle = "PLAYERNAME needs inspiration!"
		},
		HelperPulse = {
			Order = 2,
			AbilityName = "Pulse",
			RequestTitle = "Request Pulse",
			NotificationTitle = "PLAYERNAME needs a boost!"
		}
	},
	Detection = {
		CheckRate = 12,
		Radius = 100,
		Duration = 3,
		Debounce = 5,
		GeneratorHighlightColor = Color3.new(0.870588, 1, 0.439216),
		ItemHighlightColor = Color3.new(1, 0.756863, 0.341176)
	},
	SonicPulse = {
		InterruptDamage = 0,
		Windup = 2,
		HighlightWindupFillTransparency = 0.75,
		HighlightWindupOutlineTransparency = 0.1,
		HighlightReleaseFadeTime = 0.8,
		SpeedMult = 0.9,
		CancelledCooldown = 44,
		Endlag = 0.75,
		HelperbotDurationMultiplier = 0.5,
		SurvivorStackingPenalty = 1.5,
		MinimumStatusDuration = 3,
		DontHealVee = true,
		HighlightColor = Color3.fromRGB(182, 113, 59),
		Radius = {
			30,
			33,
			36,
			39
		},
		ExpansionRate = {
			30,
			33,
			36,
			39
		},
		KillerStatuses = {},
		SurvivorStatuses = {
			{
				Regeneration = {
					Level = 1,
					Duration = 4
				},
				Resistance = {
					Level = 1,
					Duration = 4
				}
			},
			{
				Regeneration = {
					Level = 1,
					Duration = 5
				},
				Resistance = {
					Level = 1,
					Duration = 5
				}
			},
			{
				Regeneration = {
					Level = 1,
					Duration = 6
				},
				Resistance = {
					Level = 1,
					Duration = 6
				}
			},
			{
				Regeneration = {
					Level = 1,
					Duration = 7
				},
				Resistance = {
					Level = 1,
					Duration = 7
				}
			}
		}
	},
	Inspiration = {
 Endlag=.75, Windup=.75, SpeedMult=.01, CancelledCooldown=10,
 Radius=16, SecondsForCharge=5, ChargeDecayRate=.7, TickRate=.5,
 Duration=10, HasteStatus={Level=5,Duration=2,DisabledAbilityNames={"Inspiration"}}
 },
	Animations = {
		Idle = "rbxassetid://85122802634658",
		Inspire = "rbxassetid://100477375627208",
		Pulse = "rbxassetid://75392643019115",
		Detect = "rbxassetid://110970927449534"
	},
	Sounds = {
		Radar = "rbxassetid://71244010455195",
		PulseWindup = "rbxassetid://135197235575211",
		PulseInterrupted = "rbxassetid://80461055461025",
		Pulse = "rbxassetid://100185762426837",
		PulseHitNegative = "rbxassetid://94133051716387",
		PulseHitPositive = "rbxassetid://124629910282687",
		InspireWindup = "rbxassetid://72294388744720",
		Inspire = "rbxassetid://130600656919984",
		InspireEnd = "rbxassetid://90194781870314",
		InspireLoop = "rbxassetid://82283824877220",
		InspirePlayerEntered = "rbxassetid://71461562566628",
		InspirePlayerLeft = "rbxassetid://99813360396403",
		InspireBarAppear = "rbxassetid://104791973603736",
		InspireBarCharging = "rbxassetid://110006505301582",
		InspireBarDone = "rbxassetid://111055614415234",
		ChargeUISoundVolume = 0.4,
		ChargeUISoundFadeTime = 0.35
	},
	TextInteractions = {
		Requests = {
			ElliotPizza = {
				"HEY. H3Y. HHYAY!! HE-HE-HE-HELL0! I NEED SUSTENANC3.",
				"SOME R0BO7S NEED F0O D 2. U KN0W. >:b",
				"I NE3D TO L1VE !!!! (ToT)(ToT)",
				"PL3ASE PLEASE PLEASE PLEASE PLEASE PLE4SE PLZ PLES PL3453 PLEZ PLEASZ ",
				"I7 WOULD B3. SO C00L. IF U. COULD GIVE ME. SUSTEN4NCE. (*^▽^*)"
			},
			BuildermanSentry = {
				"Hello, Mr. Builderman! This spot over here would be most suitable for a Sentry.",
				"Mr. Builderman! Build your Sentry here, it is most suitable.",
				"Greetings, Mr. Builderman! This placement here would be perfect for a Sentry.",
				"Mr. Builderman! Your Sentry would go greatly over here.",
				"Mr. Builderman, hello! Your Sentry would be strategically perfect placed over here."
			},
			BuildermanDispenser = {
				"Hello, Mr. Builderman! I ask that you place your dispenser here.",
				"A Dispenser here could surely increase our chances of survival.",
				"Greetings, the team needs our aid, may you place a Dispenser down?",
				"Mr. Builderman! A Dispenser would be most efficient here.",
				"Mr. Builderman, your Dispenser would go greatly over here."
			},
			DusekkarProtection = {
				"Hello there! I need your Shield, please.",
				"Hi! Your shield would greatly aid me.",
				"You have a unique power that’ll greatly benefit our team, please protect me with it.",
				"Your forcefield will provide us a greater chance of survival.",
				"Greetings, I will need your protection, if you will."
			},
			HemmorhageAsk = {
				"My damages need assistance from another…",
				"Motor Function unstable… Your assistance would be much appreciated.",
				"I’m losing power… please mend my damages."
			},
			HelperInspire = {
				"Won’t you lend some words of encouragement, fellow Helper?",
				"Hello! Our team needs a Morale Boost, fellow Helper!",
				"Hi! My Radio Waves are taking quite some time to reload, help a Helper out?"
			},
			HelperPulse = {
				"Hi! May you activate your Pulse while mine reloads?",
				"Hello fellow Helper! Your Pulse is much needed.",
				"Your Pulse will help our team power through!"
			}
		},
		Thanks = {
			Regular = {
				"Your work is much appreciated. :)",
				"Thank you. Another job well done. :)",
				"Don’t give up either, we must push on :)"
			},
			HelperInspire = {{
				"Veeronica: I 4M S0 H4PPY Y0U 4R3 B4CK UP!!! ＼(^o^)／",
				"Helperbot: M3 T00!!! ＼(^o^)／",
				"Veeronica: ＼(^o^)／",
				"Helperbot: ＼(^o^)／",
				"Veeronica: ＼(^o^)／",
				"Helperbot: ＼(^o^)／"
			}}
		}
	}
}
local SonicPulse = t1.SonicPulse
local Inspiration = t1.Inspiration
local t2 = {
	"I",
	"II",
	"III",
	"IV",
	"V",
	"VI",
	"VII",
	"VIII"
}
local t3 = {}

for i, v in ipairs(SonicPulse.SurvivorStatuses) do
	local v8 = if i ~= 1 then `Radius: <b>+{ math.round((SonicPulse.Radius[i] / SonicPulse.Radius[1] - 1) * 100) }%</b> compared to the base radius\n` else `Base Radius: { SonicPulse.Radius[1] } studs\n`
	local t4 = {}

	for _, v11 in {
		"Regeneration",
		"Resistance"
	} do
		local v12 = v[v11]

		if v12 then
			table.insert(t4, `<b>{ v11 } { t2[v12.Level] or v12.Level }</b> for { v12.Duration }s.`)
		end
	end

	table.insert(t3, `<b>Level { i - 1 }</b>\n` .. v8 .. table.concat(t4, "\n"))
end

t1.Information = {
	{
		Separator = "GENERAL INFO"
	},
	{
		Header = "HELPERBOT",
		Text = "An excitable little machine with one very important directive: help! Equipped with a built-in radar and bursts of restorative energy, <font color=\"#b6713b\">Helperbot</font> keeps their teammates informed, protected, and ready for action. A little encouragement goes a long way, especially when it comes with a faster cooldown.\n"
	},
	{
		Header = "STATS",
		Text = "Difficulty: ★★☆☆☆\n" .. `Health: { t1.Health or 100 }\n` .. `Regular Speed: { t1.Speed or 12 }\n` .. `Sprinting Speed: { t1.SprintSpeed or 26 }\n` .. `Max Stamina: { t1.MaxStamina or 100 }\n` .. `Stamina Loss per sec: { t1.StaminaLoss or 10 }\n` .. `Stamina Gain per sec: { t1.StaminaGain or 20 }\n`
	},
	{
		Separator = "PASSIVES"
	},
	{
		Header = "RADAR",
		Quote = "\"The right tools are never far away. Sometimes you just need a little help finding them.\" - Builderman",
		Text = `<font color="#b6713b">Helperbot</font> periodically reveals nearby unfinished generators and items to all Survivors. Objects within <b>{ t1.Detection.Radius } studs</b> are highlighted for <b>{ t1.Detection.Duration }s</b>, with a scan occurring every <b>{ t1.Detection.CheckRate }s</b>.\n\n` .. `When another Survivor uses an ability, their aura is revealed to <font color="#b6713b">Helperbot</font> for <b>{ t1.Detection.Duration }s</b>, colored according to their remaining health.\n`
	},
	{
		Separator = "ABILITIES"
	},
	{
		Header = "PULSE",
		Image = "rbxassetid://127410699461731",
		Quote = "\"A good repair gets you moving. A great one gets the whole team moving.\" - Builderman",
		Text = `Cooldown: { t1.PulseCooldown }s\n` .. `Windup: { SonicPulse.Windup }s\n\n` .. "<font color=\"#b6713b\">Helperbot</font>'s aura is revealed to all Survivors during the windup.\n\n" .. `Taking damage during windup interrupts Pulse. It goes on its full cooldown, but <font color="#b6713b">Helperbot</font> keeps all stored charges.\n\n` .. "<font color=\"#b6713b\">Helperbot</font> releases an expanding pulse that grants <b>Regeneration</b> and <b>Resistance</b> to Survivors it reaches, including themselves.\n\n" .. "<font color=\"#b6713b\">Helperbot</font> starts with <b>one charge</b> and can store up to <b>three</b>. Charges earned through <b>Inspire</b> improve Pulse's radius and buffs. <b>All stored charges are consumed when the pulse is released.</b>\n\n" .. table.concat(t3, "\n\n") .. "\n\n" .. `Each additional <font color="#b6713b">Helperbot</font> reduces the buffs' durations by <b>{ SonicPulse.SurvivorStackingPenalty }s</b>.\n\n` .. `Other <font color="#b6713b">Helperbot</font> characters receiving the pulse receive <b>{ math.round(SonicPulse.HelperbotDurationMultiplier * 100) }%</b> of those durations. This reduction does not apply to the caster. Buff duration has a <b>{ SonicPulse.MinimumStatusDuration }s</b> minimum before the other Helperbot 50% modifier.\n\n` .. "<font color=\"#b6713b\">Helperbot</font> is slowed down by 10% during the windup of this ability. \n"
	},
	{
		Header = "INSPIRE",
		Image = "rbxassetid://126611529586683",
		Quote = "\"Keep encouraging each other. Nobody builds something great all on their own.\" - Builderman",
		Text = `Cooldown: { t1.InspirationCooldown }s\n` .. `Windup: { Inspiration.Windup }s\n\n` .. `<font color="#b6713b">Helperbot</font> creates an inspiring aura that follows them for <b>{ Inspiration.Duration }s</b>. Other Survivors within <b>{ Inspiration.Radius } studs</b> receive <b>Haste { t2[Inspiration.HasteStatus.Level] or Inspiration.HasteStatus.Level }</b>, accelerating their ability cooldowns.\n\n` .. `Each Survivor who stays inside Inspire's area for <b>{ Inspiration.SecondsForCharge } seconds</b> grants <font color="#b6713b">Helperbot</font> <b>one Pulse charge</b>, up to <b>three stored charges</b>. Each Survivor can contribute <b>once per cast</b>.\n\n` .. "Survivors can see their own Inspire meter progress. Leaving the area gradually drains that Survivor's unfinished charge progress. Returning resumes it from whatever remains. Completed charges are not lost by leaving the area.\n\n" .. "Each additional <font color=\"#b6713b\">Helperbot</font> reduces the applied <b>Haste</b> by <b>one level</b>, down to a minimum of <b>Haste I</b>.\n"
	}
}

t1.SprintSpeed=26
t1.MaxStamina=100
t1.StaminaLoss=10
t1.StaminaGain=20
t1.HelperbotPortVersion="1.0.0"
t1.SonicPulse.CancelledCooldown=44
t1.SonicPulse.InterruptDamage=0 -- any actual hit interrupts, per the supplied moveset
t1.SonicPulse.KillerStatuses={} -- no lasting killer debuff specified; export has Fatigue Duration=0
t1.Inspiration.Duration=10
t1.Inspiration.HasteStatus={Level=5,Duration=2,DisabledAbilityNames={"Inspiration"}}
for _,section in ipairs(t1.Information) do
 if section.Header=="INSPIRE" then section.Text..="\nHelperbot also receives Haste for Pulse, but Inspiration is excluded. Support survivors receive half Haste effectiveness." end
 if section.Header=="PULSE" then section.Text..="\nEach Pulse level gained awards $2, 13 EXP and 0.25 Malice." end
end
return t1