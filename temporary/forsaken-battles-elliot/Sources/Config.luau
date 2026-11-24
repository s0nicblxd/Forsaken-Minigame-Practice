local t1 = {
	LMSEffect = {
		ProcessingModule = "BasicLMS",
		SoundId = "heartbeat",
		ImageId = function(_: string) -- line: 6
			return "rbxassetid://95347165286150"
		end,
		PrimaryColor = Color3.fromRGB(255, 0, 0),
		SecondaryColor = Color3.fromRGB(0, 0, 0)
	},
	DisplayName = "Elliot",
	Quote = "\"Pizza pizza!\"",
	Credits = "sayso_1230",
	Class = "Support",
	RenderImage = "rbxassetid://107512662597581",
	Price = 0,
	Requests = {
		ElliotPizza = {
			Order = 1,
			AbilityName = "ThrowPizza",
			RequestTitle = "Request Pizza",
			NotificationTitle = "PLAYERNAME wants a pizza!"
		}
	},
	Instances = {
		CustomPizza = nil,
		CustomScooter = script.ElliotScooter
	},
	UsesScooter = true,
 RushHourRewards = {Used={Money=2,EXP=10,KillerChance=0},Escaped={Money=5,EXP=18,KillerChance=0}},
	Health = 80,
	Speed = 12,
	InjuredSurvivorAuraDuration = 12,
	InjuredSurvivorDamageMinimum = 1,
	ThrowPizzaCooldown = 34,
	PizzaThrowForce = 60,
	PizzaThrowTimeToThrow = 0.5,
	PizzaHealingAmount = 5,
	PizzaHealingProgressively = 15,
	PizzaHealingProgressivelyTime = 4,
	PizzaAbilityDisabledFor = 2,
	PizzaLifetime = 15,
	PizzaPingDistance = 200,
	PizzaPingDuration = 25,
	PizzaHitboxSize = 2,
	PizzaTimeGui = script.TimeGui,
	PizzaParticles = script.PizzaParticles,
	OrderUpBonus = 2,
	OrderUpBonusMax = 10,
	RushHourCooldown = 30,
	RushHourKillerRange = 85,
	RushHourSpeedLevel = 3,
	RushHourSpeedDuration = 4,
	RushHourExhaustedDuration = 4,
	RushHourAbilityDisabledFor = 0.1,
	HealingPercentDebuffFirstElliot = 40,
	HealingPercentDebuffPerElliot = 18,
	HealingPercentAddedOnObjectiveCompletion = 5,
	HealingPercentDebuffCap = 90,
	HealingPercentCap = 25,
	Expressions = {
		Happy = "rbxassetid://110750905641307",
		SlightlyHappy = "rbxassetid://106222322344914",
		Default = "rbxassetid://83334557662577",
		Hurt = "rbxassetid://99622068343113",
		Injured = "rbxassetid://75883342439965",
		Dead = "rbxassetid://81338352043362",
		Drinking = "rbxassetid://86541841918172"
	},
	Animations = {
		ThrowPizza = "rbxassetid://114155003741146",
		RushStartup = "rbxassetid://81632225069352",
		RushLoop = "rbxassetid://139608879618432",
		RushEnd = "rbxassetid://138489792229657"
	},
	Sounds = {
		PizzaEaten = "rbxassetid://18196908747",
		PizzaThrown = "rbxassetid://114810361288106",
		RushHourStart = "rbxassetid://84766394210518"
	},
	TextInteractions = {
		Requests = {
			ElliotPizza = {
				"I’m fresh out and I really need a pizza..!",
				"Can’t hand pizzas yet, need one right now, though..!",
				"Mind if I ask for a pizza..? Can’t hand some out yet, eheh..",
				"Can I have some of your pizza? I’m out..",
				"Really could go for a pizza.. Mind if I have one?",
				"I could eat my own pizza, but I really wanna save it for the others.. Can I have some?",
				"Mind if I have a slice..?"
			},
			BuildermanSentry = {
				"Mister Builder! Put one of those turrets here!",
				"Quick! Place a sentry here!",
				"Hurry, put down a sentry over here!",
				"Put a sentry over here!",
				"This spot is good for a sentry!"
			},
			BuildermanDispenser = {
				"Mister Builder! Put one of those dispensers here!",
				"This spot’s good for a dispenser!",
				"Build a dispenser over here!",
				"A dispenser would be good here, I think..",
				"Putting a dispenser here should work!"
			},
			DusekkarProtection = {
				"Pumpkin guy! Need a little force field..!!",
				"Force field needed!!",
				"Cast your force field!!",
				"Please cast a force field..!!",
				"Force field urgently required!!"
			},
			HemmorhageAsk = {
				"I'm.. I'm bleeding, help a pizza guy out, won't you..?",
				"Gh... I'm hurt real bad.. do you have anything that can help..?",
				"It hurts, a lot.. please help...",
				"I.. I can help out more if you can help me with this wound! Please...",
				"Help me! I can't help if I'm bleeding so much..!"
			},
			HelperPulse = {
				"Heya, could you that sonic wave again? Please?",
				"Does it hurt when you release that sonic wave? I hope it doesn't, cause we need one right now...",
				"C'mon, we'll be needing one of your sonic waves again, Helperbot!!",
				"Looks like we need another sonic wave again.. mind lending us a hand, Helper?",
				"Help us out really quick! We need one of those sonic waves..!"
			},
			HelperInspire = {
				"Can you do that sphere thing again? Could really use one right about now...",
				"Hurry! Activate your bubble!!",
				"Lend us your bubble again, Helperbot!",
				"We need a bubble, and you're the only Bot for the job!",
				"Come help us out with a bubble, Helper!!"
			}
		},
		Thanks = {
			Regular = {
				"Whew.. thanks, man.",
				"Another job well done, all thanks to you!",
				"Thanks, buddy!",
				"I’m glad for the help!",
				"Thanks for the help!",
				"Thank you so much!"
			}
		}
	}
}

t1.Information = {
	{
		Separator = "GENERAL INFO"
	},
	{
		Header = "ELLIOT",
		Text = "Builder Brother's Pizza's best employee, now just wanting to help in any way he can. With his experience in rushing deliveries and making pizzas, he works as a support to help his team with his pizza slices.\n"
	},
	{
		Header = "STATS",
		Text = "Difficulty: ★★☆☆☆\n" .. `Health: { t1.Health or 100 }\n` .. `Regular Speed: { t1.Speed or 12 }\n` .. `Sprinting Speed: { t1.SprintSpeed or 26 }\n` .. `Max Stamina: { t1.MaxStamina or 100 }\n` .. `Stamina Loss per sec: { t1.StaminaLoss or 10 }\n` .. `Stamina Gain per sec: { t1.StaminaGain or 20 }\n`
	},
	{
		Separator = "PASSIVES"
	},
	{
		Header = "ORDER UP!",
		Quote = "\"Pizza! Pizza! Pizza! Pizza! Pizza! Pizza!\" - Satisfied Customer",
		Text = "<font color=\"#ffc804\">Elliot</font> feels proud seeing a task get done.\n\n" .. `After the objective counter is incremented, <font color="#ffc804">Elliot</font> gains a flat { t1.OrderUpBonus } HP increase in how much he heals.\n\n` .. `This bonus stacks, but caps at { t1.OrderUpBonusMax } extra healing.\n`
	},
	{
		Header = "DELIVERER'S RESOLVE",
		Quote = "\"Woah! That's some fast delivery!\" - Satisfied Customer",
		Text = `Whenever any Survivor receives damage, their aura becomes revealed to <font color="#ffc804">Elliot</font> for { t1.InjuredSurvivorAuraDuration }s.\n`
	},
	{
		Separator = "ABILITIES"
	},
	{
		Image = "rbxassetid://93578432067529",
		Header = "PIZZA THROW",
		Quote = "\"Nice to see you! What can I get ya?\" - Elliot",
		Text = `Cooldown: { t1.ThrowPizzaCooldown }s\n` .. `<font color="#ffc804">Elliot</font> tosses a pizza in front of him that can instantly heal other survivors for { t1.PizzaHealingAmount } HP, and then progressively heals { t1.PizzaHealingProgressively } HP over { t1.PizzaHealingProgressivelyTime } seconds to whoever picks it up. The pizza despawns after { t1.PizzaLifetime }s.\n\n` .. "Survivors within 200 studs of <font color=\"#ffc804\">Elliot</font> while the pizza is being thrown have the pizza highlighted to them.\n\n" .. "Pizzas thrown by <font color=\"#ffc804\">Elliot</font> cannot heal himself, and pizzas thrown by other <font color=\"#ffc804\">Elliot</font>s will give 50% less healing.\n\n" .. `Pizza healing is reduced by { t1.HealingPercentDebuffFirstElliot }% for the first additional <font color="#ffc804">Elliot</font> alive. Each further <font color="#ffc804">Elliot</font> alive adds { t1.HealingPercentDebuffPerElliot } percentage points to the penalty, up to { t1.HealingPercentDebuffCap }%.\n`
	},
	{
		Image = "rbxassetid://128250550180598",
		Header = "RUSH HOUR",
		Quote = "\"Wow, you should get a raise.\" - Satisfied Customer",
		Text = `Cooldown: { t1.RushHourCooldown }s\n` .. "After <font color=\"#ffc804\">Elliot</font> heals any player, they gain a charge for this ability. <font color=\"#ffc804\">Elliot</font> starts the round off with 1 charge, and can store up to 3 charges at a time.\n\n" .. `When a Killer is within { t1.RushHourKillerRange } studs, <b>Rush Hour</b> turns reddish and becomes empowered.\n\n` .. `Using <b>Rush Hour</b> while empowered consumes all stored charges and grants <b>Speed</b> for { t1.RushHourSpeedDuration }s. The <b>Speed</b> level depends on how many charges were consumed, going up to <b>Speed III</b> at 3 charges.\n\n` .. `When the <b>Speed</b> ends, <font color="#ffc804">Elliot</font> receives <b>Exhausted</b> for { t1.RushHourExhaustedDuration }s. Its level matches the charges consumed: <b>Exhausted I</b> at 1 charge, <b>Exhausted II</b> at 2 charges, and <b>Exhausted III</b> at 3 charges.\n\n` .. `Using <b>Rush Hour</b> while no Killer is within { t1.RushHourKillerRange } studs will not consume charges or apply <b>Exhausted</b>.\n\n` .. "Healing another <font color=\"#ffc804\">Elliot</font> does not give a charge for this ability.\n"
	},
	{
		Separator = "CREDITS",
		Text = "Writer: idrawthingzAnimator: sayso_1230Renderer: SummerFace Artist: ramdom"
	}
}

return t1
