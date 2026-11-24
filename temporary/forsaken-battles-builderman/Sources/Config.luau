local t1 = {
	LMSEffect = {
		ProcessingModule = "BasicLMS",
		SoundId = "heartbeat",
		ImageId = function(_: string) -- line: 6
			return "rbxassetid://127305232864509"
		end,
		PrimaryColor = Color3.fromRGB(255, 0, 0),
		SecondaryColor = Color3.fromRGB(0, 0, 0)
	},
	DisplayName = "Builderman",
	Quote = "\"Welcome to ROBLOX!\"",
	Class = "Support",
	RenderImage = "rbxassetid://84427509230526",
	Price = 500,
	Requests = {
		BuildermanSentry = {
			AbilityName = "Sentry",
			RequestTitle = "Request Sentry",
			NotificationTitle = "PLAYERNAME wants a sentry built!",
			Order = 1
		},
		BuildermanDispenser = {
			AbilityName = "Dispenser",
			RequestTitle = "Request Dispenser",
			NotificationTitle = "PLAYERNAME wants a dispenser built!",
			Order = 2
		}
	},
	Health = 90,
	Speed = 12,
	SentryCooldown = 0,
	SentryDestroyedCooldown = 35,
	SentryConstructionDuration = 6,
	SentryPositionOffset = 4,
	SentryPlacementRadius = 125,
	SentryDamageRadius = 65,
	SentryLimit = 1,
	SentryPingDistance = 999,
	SentryPingDuration = 999,
	SentryHealth = 30,
	SentrySlownessLevel = 2,
	SentryStackedSlownessLevel = 1,
	SentrySlownessDuration = 1,
	SentryDamagePerSec = 3,
	SentryRangeReductionPercentage = 16,
	SentryMinimumRange = 8,
	SentryPickupDebounce = 0.75,
	SentryPickupOffset = CFrame.new(0, 2, -2),
	SentryAnimations = {
		Construction = "rbxassetid://124152696571014",
		Idle = "rbxassetid://124173695158238",
		Shoot = "rbxassetid://114572748729498",
		PickUp = "rbxassetid://108513188967002",
		CarryIdle = "rbxassetid://132789596370235",
		CarryWalk = "rbxassetid://116909049940354",
		PutDown = "rbxassetid://91737263563320"
	},
	DispenserCooldown = 0,
	DispenserDestroyedCooldown = 30,
	DispenserConstructionDuration = 6,
	DispenserPositionOffset = 4,
	DispenserPlacementRadius = 60,
	DispenserHealingRadius = 16,
	DispenserLimit = 1,
	DispenserPingDistance = 999,
	DispenserPingDuration = 999,
	DispenserPickupDebounce = 0.5,
	DispenserPickupOffset = CFrame.new(0, 2, -2),
	DispenserHealth = 15,
	DispenserHealingPerSec = 1,
	DispenserAnimations = {
		Construction = "rbxassetid://74257961315420",
		Idle = "rbxassetid://72409953607244",
		PickUp = "rbxassetid://114452443413930",
		CarryIdle = "rbxassetid://94568983394344",
		CarryWalk = "rbxassetid://103441914715625",
		PutDown = "rbxassetid://90904147606168"
	},
	CarryRange = 7,
 CarryPlacementDuration = 1,
 ConstructionWindup = 1.25,
 MoveCooldown = 0,
	CarryWalkspeed = 0.9,
	CarryFOVMultiplier = 1.2,
	CarryFOVTweenTime = 3,
	CarryDamageThreshold = 10,
	Instances = {
		SentryTemplate = script.Sentry,
		DispenserTemplate = script.Dispenser,
		WarningTemplate = script.Warning
	},
	HatFixCooldown = 40,
	HatFixBuffDelay = 1.5,
	HatFixRange = 45,
	Expressions = {
		Happy = "rbxassetid://75425376108592",
		Default = "rbxassetid://78927941165959",
		Hurt = "rbxassetid://105173827090865",
		Injured = "rbxassetid://77334993821053",
		Dead = "rbxassetid://88659722034277",
		Drinking = "rbxassetid://83064700049700",
		Concentrating = "rbxassetid://102570873215742"
	},
	Animations = {
		ConstructStart = "rbxassetid://135478644516351",
		ConstructLoop = "rbxassetid://90772467802274",
		ConstructEnd = "rbxassetid://112583398395682",
		HatFix = "rbxassetid://133461474706559",
		PickIdle = "rbxassetid://80928531368570",
		PickUp = "rbxassetid://127053426877374",
		PutDown = "rbxassetid://114628603927215",
		PickWalk = "rbxassetid://84595244279245",
		PickRun = "rbxassetid://84595244279245"
	},
	Emotes = {
		Animations = {
			SpaceOut = {
				DisplayName = "Mini-Sentry",
				RenderImage = "rbxassetid://137941649909292",
				Description = "Mini-Sentry",
				AssetID = "rbxassetid://134055785601306",
				SFX = "rbxassetid://120430993489834",
				CreatedServer = function(p1) -- line: 150
					local _ = p1.Character
					local clone = script.MiniTurret:Clone()

					clone.Parent = p1.Character
					clone.TURRETWELD.Part0 = p1.Character.PrimaryPart
					task.delay(4.166666666666667, function() -- line: 158
						-- upvalues: p1 (copy)
						p1.Character.Hammer.Transparency = 0
					end)
					task.delay(4.5, function() -- line: 163
						-- upvalues: clone (copy)
						for _, child in pairs(clone.Root:GetChildren()) do
							if child:IsA("ParticleEmitter") then
								child:Emit(5)
							end
						end

						for _, child in pairs(clone:GetChildren()) do
							if child:IsA("MeshPart") then
								child.Transparency = 1
							end
						end
					end)
					task.delay(4.833333333333333, function() -- line: 177
						-- upvalues: p1 (copy)
						p1.Character.Hammer.Transparency = 1
						p1.Character.Hammer.CanCollide = false
					end)
				end,
				DestroyedServer = function(p2) -- line: 184
					local Character = p2.Character

					if Character then
						for _, child in pairs(Character:GetChildren()) do
							if child.Name == "EMOTESENTRY" then
								child:Destroy()
							end
						end
					end
				end
			}
		}
	},
	Sounds = {
		SentryBuilding = "rbxassetid://136339052883583",
		SentryIdle = "rbxassetid://92187169647230",
		SentryDestroyed = "rbxassetid://140349478902004",
		SentryTargeted = "rbxassetid://136472646189313",
		SentryCarryTargeted = "rbxassetid://78508818825114",
		SentryShoot = "rbxassetid://85080845610107",
		SentryPutdown = "rbxassetid://2423389966",
		SentryPickup = "rbxassetid://2848703459",
		SentryDropBuild = "rbxassetid://70621498126117",
		BuildingCarryIdle = "rbxassetid://119574803918892",
		DispenserBuilding = "rbxassetid://131280892518899",
		DispenserIdle = "rbxassetid://112621500209552",
		DispenserDestroyed = "rbxassetid://94935842945161",
		DispenserPickup = "rbxassetid://2848703459",
		DispenserPutdown = "rbxassetid://116086162740635",
		DispenserDropBuild = "rbxassetid://72061269121720",
		CarryFootsteps = {
			"rbxassetid://137530774742124",
			"rbxassetid://110776862318861",
			"rbxassetid://93418055666843",
			"rbxassetid://108947057915540"
		}
	},
	TextInteractions = {
		Requests = {
			ElliotPizza = {
				"Looking for a slice of pizza over here.",
				"Could I ask for a slice of pizza?",
				"Hey, pass a slice.",
				"You don't happen to have pizza on you, do you?",
				"A pizza would work great on me right now.. mind if I get one?"
			},
			BuildermanSentry = {
				"Place your sentry here.",
				"Put down a sentry over here.",
				"Over here's a good spot for a sentry.",
				"Build your sentry here. It's good ground.",
				"Put your sentry over here."
			},
			BuildermanBuildermanSentry = {
				"I know imitation is the best form of flattery, but uh-… whatever, put down a sentry here.",
				"Impersonatin' an admin is a bannable offense. If you build a sentry I might change my mind.",
				"It's like lookin' into an uncanny mirror-… ahem, uh.. Put a sentry here, will you?",
				"Build the sentry here. If you're truly me then you'd know it's a good spot.",
				"This spot over here could be good for a sentry. You know that, yeah?"
			},
			BuildermanDispenser = {
				"Here's a good spot for a dispenser.",
				"Good spot for a dispenser here.",
				"Put your dispenser down over here.",
				"The spot over here could be good for a dispenser.",
				"Dispenser could be great if it were put down here."
			},
			BuildermanBuildermanDispenser = {
				"Let's hope your dispenser building skills are as good as your imitation.",
				"If you're really me, then you ought to know that this spot's good for a dispenser.",
				"This spot's pretty good for a dispenser. Don't you think, me?",
				"Put down a dispenser if you're really who you say you are.",
				"You ought to know how to build a dispenser here if you're really the person you're imitating."
			},
			DusekkarProtection = {
				"Need a bit of your magic, Dusekkar!",
				"Need a bit of magic from you, pumpkin.",
				"A force field would do good on me, if that's alright.",
				"Cast some of your magic, pumpkin!",
				"Your magic I could really use right about now, Dusekkar."
			},
			HemmorhageAsk = {
				"Not feeling too good.. can feel myself draining.. I'm gonna need some help.",
				"Lend me a hand for a bit, I'm hurting real' bad...",
				"I'm.. not in a good state here, and I'm gonna need some of your help.",
				"Trying real hard to keep going, but I might need your help for it.",
				"Gonna need some of your help, I don't think I'll last long in this state..."
			},
			HelperPulse = {
				"Quick, HelperBot! Activate your pulse, NOW!",
				"Going to need that energy wave right about now, HelperBot!",
				"Keep it up, HelperBot! Activate the pulse immediately!",
				"Go on then, HelperBot! These people need your power!",
				"Got that energy wave ready yet, HelperBot? 'Cause we'll be needing it soon."
			},
			HelperInspire = {
				"You've got heart, HelperBot. And with that heart, you can INSPIRE.",
				"Give us your support, HelperBot. We'll be needing it right about now.",
				"Give us that help, HelperBot.",
				"We'll be needing that bubble, HelperBot. The sooner the better.",
				"Come on now, don't keep our team waiting. Help us out, HelperBot."
			}
		},
		Thanks = {
			Regular = {
				"Thanks.",
				"Thank you.",
				"Your work is appreciated.",
				"Thank you.",
				"Now that's some good work."
			}
		}
	}
}

t1.Information = {
	{
		Separator = "GENERAL INFO"
	},
	{
		Header = "BUILDERMAN",
		Text = "The big boss of Roblox HQ himself. With a hammer in his inventory and a lot of spare parts and materials to spare, he's able to build contraptions that can either slow the killer's path, or heal those around him. As a promise with Shedletsky, he'll do all he can to help everyone.\n"
	},
	{
		Header = "STATS",
		Text = "Difficulty: ★★★☆☆\n" .. `Health: { t1.Health or 100 }\n` .. `Regular Speed: { t1.Speed or 12 }\n` .. `Sprinting Speed: { t1.SprintSpeed or 26 }\n` .. `Max Stamina: { t1.MaxStamina or 100 }\n` .. `Stamina Loss per sec: { t1.StaminaLoss or 10 }\n` .. `Stamina Gain per sec: { t1.StaminaGain or 20 }\n`
	},
	{
		Separator = "ABILITIES"
	},
	{
		Image = "rbxassetid://104441527277654",
		Header = "SENTRY CONSTRUCTION",
		Quote = "\"These sentries see your enemies so you don't have to!\" - Roblox",
		Text = `Cooldown: { t1.SentryDestroyedCooldown }s after being destroyed by the Killer\n` .. `Sentry Health: { t1.SentryHealth }\n\n` .. `<font color="#ee6700">Builderman</font> takes { t1.SentryConstructionDuration }s to build a <b>Sentry</b> in front of him, which targets nearby Killers and inflicts <b>Slowness II</b> for { t1.SentrySlownessDuration }s onto them.\n\n` .. "<font color=\"#ee6700\">Builderman</font> will be unable to construct a <b>Sentry</b> if it has targeted a Killer within the last 10s.\n\n" .. "The <b>Slowness</b> level is reduced to <b>Slowness I</b> if there is more than one <font color=\"#ee6700\">Builderman</font> alive.\n\n" .. "If <font color=\"#ee6700\">Builderman</font> is attacked while performing this ability, any <b>Sentry</b> that's currently in production by them will be destroyed and the ability will be cancelled.\n\n" .. `<font color="#ee6700">Builderman</font> is only able to build { t1.SentryLimit } <b>Sentry</b> at a time.\n\n` .. `<b>Sentries</b> have a target range of { t1.SentryDamageRadius } studs, which decreases by { t1.SentryRangeReductionPercentage }% for every additional <b>Sentry</b> that's placed in the world.\n` .. `<b>Sentries</b> will always have a target range of at least { t1.SentryMinimumRange } studs no matter what the current target range reduction is.\n\n` .. `Other kinds of buildings cannot be built within { t1.SentryPlacementRadius } studs of any <b>Sentry</b> in the world.\n\n` .. "Using this ability while having built the max amount of <b>Sentries</b> automatically destroys the first active <b>Sentry</b> you placed.\n"
	},
	{
		Image = "rbxassetid://102952736333903",
		Header = "DISPENSER CONSTRUCTION",
		Quote = "\"This is pretty much the best healing potion in any video game ever.\" - Roblox",
		Text = `Cooldown: { t1.DispenserDestroyedCooldown }s after being destroyed by the Killer\n` .. `Dispenser Health: { t1.DispenserHealth }\n\n` .. `<font color="#ee6700">Builderman</font> takes { t1.DispenserConstructionDuration }s to build a <b>Dispenser</b> in front of him, which heals all teammates within { t1.DispenserHealingRadius } studs by { t1.DispenserHealingPerSec } HP/s.\n\n` .. "<font color=\"#ee6700\">Builderman</font> will be unable to construct a <b>Dispenser</b> if it has healed a survivor within the last 10s.\n\n" .. "If <font color=\"#ee6700\">Builderman</font> is attacked while performing this ability, any <b>Dispenser</b> that's currently in production by them will be destroyed and the ability will be cancelled.\n\n" .. `<font color="#ee6700">Builderman</font> is only able to build { t1.DispenserLimit } <b>Dispenser</b> at a time.\n\n` .. `Other kinds of buildings cannot be built within { t1.DispenserPlacementRadius } studs of any <b>Dispenser</b> in the world.\n\n` .. "Using this ability while having built the max amount of <b>Dispensers</b> automatically destroys the first active <b>Dispenser</b> you built.\n"
	},
	{
		Image = "rbxassetid://97983142047580",
		Header = "CARRY",
		Quote = "\"Gotta move that gear up!\" - Roblox Software Engineer",
		Text = "While standing near a constructed <b>Sentry</b> or <b>Dispenser</b>, <font color=\"#ee6700\">Builderman</font> is able to pick up that building and carry it around.\n\n" .. "Pressing the ability button again will place the building back down, and the building will become active again after a short delay.\n\n" .. "While buildings are being carried, they become completely inactive.\n\n" .. "While carrying buildings, <font color=\"#ee6700\">Builderman</font> is slowed down by 10% and is unable to sprint.\n\n" .. `If <font color="#ee6700">Builderman</font> takes { t1.CarryDamageThreshold } or more damage while carrying a building, the building will be destroyed.\n`
	},
	{
		Separator = "CREDITS",
		Text = "Writer: gubblegum, sayso_1230Animator: sayso_1230Renderer: ap_plzFace Artist: ramdom"
	}
}

return t1
