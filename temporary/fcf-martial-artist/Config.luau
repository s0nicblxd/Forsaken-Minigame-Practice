local Config = {
	DisplayName = "Martial Artist",
	Quote = "\"aura farmmm\"",
	Credits = "",
	Class = "Sentinel",
	RenderImage = "rbxassetid://132877189294749",
	Price = 500,
	Exclusive = true,
	Health = 900,
	Speed = 12,
	EnragedSlashLungeForce = 400,
	KaioKen = script.KEN,
	EX = script.Explosion,
	Animations = {
		Idle = "rbxassetid://131082534135875",
		Walk = "rbxassetid://108018357044094",
		Run = "rbxassetid://136252471123500",
		InjuredIdle = "rbxassetid://131082534135875",
		InjuredWalk = "rbxassetid://108018357044094",
		InjuredRun = "rbxassetid://136252471123500",
		QuickAttack = "rbxassetid://123569615350667",
		GashingWoundStart = "rbxassetid://119850211147676",
		ComboStart = "rbxassetid://71609732352448",
		GashingWound = {
			KillerRig = "rbxassetid://74858281441140",
			PlayerRig = "rbxassetid://80582403450485"
		},
		Comboing = {
			KillerRig = "rbxassetid://93113732401329",
			PlayerRig = "rbxassetid://122434469589143"
		}
	},
	Sounds = {
		GashingWoundSwing = "rbxassetid://129697992204296",
		GashingWoundMiss = "rbxassetid://84353899757208",
		GashingWoundHit1 = "rbxassetid://8595980577",
		GashingWoundHit2 = "rbxassetid://8595983255",
		GashingWoundHit3 = "rbxassetid://8595977193",
		GashingWoundHit4 = "rbxassetid://441202925"
	}
}

Config.SlashStunTime=2
Config.Sounds.Slash=Config.Sounds.GashingWoundHit1
Config.ScarfAnimation=script:FindFirstChild("ScarfAnimation")
Config.WaistAnimation=script:FindFirstChild("WaistAnimation")
Config.HeadbandAnimation=script:FindFirstChild("HeadbandAnimation")
Config.MArtistFCFPort="1.0.0"
return Config
