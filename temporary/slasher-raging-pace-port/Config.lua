-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: Config, time of decompilation: Fri Nov 28 21:07:32 2025 ]]
local l_workspace_Attribute_0 = workspace:GetAttribute("JasonSpecialDay");

local v1 = {
	DisplayName = "Slasher", 
	Quote = l_workspace_Attribute_0 and "\"... :)\"" or "\"...\"", 
	Credits = "HowsLifeJosh, BakedMesh, koekonaut, BirdieCandles and vladosikos17", 
	RenderImage = l_workspace_Attribute_0 and "rbxassetid://86157931388382" or "rbxassetid://86157931388382", 
	Price = 0, 
	Health = l_workspace_Attribute_0 and 100 or 100, 
	Speed = l_workspace_Attribute_0 and 10 or 9,
	SprintSpeed = l_workspace_Attribute_0 and 30 or 28,
	StaminaLoss = 9.5,
	StaminaGain = 21,
	MaxStamina = l_workspace_Attribute_0 and 40 or 110,
	SlashDamage = l_workspace_Attribute_0 and 40 or 20,
	SlashCooldown = l_workspace_Attribute_0 and 3.5 or 1.9,
	SlashStatusTime = 5,
	SlashWindup = 0.2,
	SlashLinger = 0.25,
	EnragedSlashDamage = l_workspace_Attribute_0 and 50 or 30,
	EnragedSlashCooldown = l_workspace_Attribute_0 and 1.5 or 0.8,
	EnragedSlashLungeForce = l_workspace_Attribute_0 and 85 or 65,
	BeheadDamage = l_workspace_Attribute_0 and 50 or 20,
	BeheadCooldown = l_workspace_Attribute_0 and 24 or 18.5,
	BeheadLunge = l_workspace_Attribute_0 and 1.7 or 1.3,
	BeheadStatusTime = 8,
	BeheadWindup = 0.45,
	BeheadLinger = 0.15,
	EnragedBeheadDamage = l_workspace_Attribute_0 and 75 or 22.5,
	EnragedBeheadLunge = l_workspace_Attribute_0 and 2.2 or 2,
	EnragedBeheadCooldown = l_workspace_Attribute_0 and 18 or 12,
	GashingWoundDamage = l_workspace_Attribute_0 and 150 or 40,
	GashingWoundCooldown = l_workspace_Attribute_0 and 60 or 32,
	GashingWoundStatusTime = 8,
	EnragedGashingWoundDamage = l_workspace_Attribute_0 and 250 or 70,
	EnragedGashingWoundCooldown = l_workspace_Attribute_0 and 50 or 24,
	RagingPaceCooldown = l_workspace_Attribute_0 and 55 or 30,
	EnragedSpeed = l_workspace_Attribute_0 and 26 or 19,
	EnragedTime = l_workspace_Attribute_0 and 8 or 14,
	EnragedStartup = 0.223,
	EnragedAuraLingerTime = l_workspace_Attribute_0 and 10 or 2,
	EnragedStaminaCap = l_workspace_Attribute_0 and 15 or 70,
	EnragedStaminaCapLerpTime = 6.5,
	Relations = { "Guest1337" },
	ELMSLighting = script.ELMSLighting,
	GashingWoundHitData = function() -- [[ GashingWoundHitData | Line: 37 ]]
		return {
			[0.333] = {
				DamageDivisor = 5,
				Time = 0.15,
				DoLunge = true
			},
			[0.75] = {
				DamageDivisor = 5,
				Time = 0.15,
				DoLunge = true
			},
			[1.533] = {
				DamageDivisor = 5,
				Time = 0.15,
				DoLunge = true
			},
			[1.966] = {
				DamageDivisor = 10,
				Time = 0.15,
				DoLunge = true
			},
			[2.333] = {
				DamageDivisor = 10,
				Time = 0.15
			},
			[2.983] = {
				DamageDivisor = 5,
				Time = 0.15,
				DoLunge = true
			}
		}
	end,
	Animations = {
		Idle = "rbxassetid://86391392847025", 
		Walk = "rbxassetid://94731771228103", 
		Run = "rbxassetid://119778443532396", 
		InjuredIdle = "rbxassetid://86391392847025", 
		InjuredWalk = "rbxassetid://94731771228103", 
		InjuredRun = "rbxassetid://119778443532396", 
		EnragedStart = "rbxassetid://137635534247670", 
		EnragedIdle = "rbxassetid://85731505357291", 
		EnragedWalk = "rbxassetid://82097882547093", 
		EnragedRun = "rbxassetid://120269000031109",  
		Victory = {
			KillerRig = "rbxassetid://83724861689960", 
			CameraRig = "rbxassetid://81332201611030"
		}, 
		Execution = {
			KillerRig = "rbxassetid://137527618745885", 
			PlayerRig = "rbxassetid://127698435882693"
		}, 
		ExecutionGuest1337 = {
			KillerRig = "rbxassetid://80306633744739", 
			PlayerRig = "rbxassetid://119485720608368", 
			PlayerCFrameOffset = CFrame.Angles(0, 3.141592653589793, 0) * CFrame.new(0, 0, 5)
		}, 
		Stunned = {
			Start = "rbxassetid://102769974613679", 
			Loop = "rbxassetid://91492491459037", 
			End = "rbxassetid://94018928208783"
		}, 
		Slash = "rbxassetid://93084029131432", 
		Behead = "rbxassetid://89838841221682", 
		GashingWoundStart = "rbxassetid://90939448875897", 
		GashingWound = {
			KillerRig = "rbxassetid://128422175202298", 
			PlayerRig = "rbxassetid://130506572387708"
		}
	}, 
	Sounds = {
		Footsteps = {
			"rbxassetid://87165349629614", 
			"rbxassetid://74048392042830"
		}, 
		TerrorRadiusThemes = {
			[90] = {
				ID = "rbxassetid://121682457539895", 
				BPM = 72
			}, 
			[60] = {
				ID = "rbxassetid://137623477061576", 
				BPM = 72
			}, 
			[30] = {
				ID = "rbxassetid://109775144370769", 
				BPM = 72
			}, 
			[9] = {
				ID = "rbxassetid://88037450394668", 
				BPM = 72, 
				Chase = true
			}
		}, 
		Execution = "rbxassetid://132254476381313", 
		ExecutionGuest1337 = "rbxassetid://92647403294596", 
		Stunned = "rbxassetid://122288454454450", 
		Introduction = "rbxassetid://103846409442627", 
		VictoryTheme = {
			ID = "rbxassetid://101245054805454", 
			Properties = {
				Volume = 1.45, 
				Looped = false
			}
		}, 
		Swing = "rbxassetid://115150600913692", 
		Hit = "rbxassetid://136918668747110", 
		EnragedStart = "rbxassetid://112390922764994", 
		GashingWoundSwing = "rbxassetid://112195737771031", 
		GashingWoundMiss = "rbxassetid://100958077104707", 
		GashingWoundHit = "rbxassetid://79705535085708"
	}
};

v1.Information = {
	{
		Separator = "GENERAL INFO"
	}, 
	{
		Header = "SLASHER", 
		Text = "A man who's identity is covered by a crude hockey mask. Wielding several tools at his disposal, along with his thirst for the cat-and-mouse chase, his hands and/or tools are always seen bloody. He enters his damnation wielding his infamous machete & a chainsaw he found in a cabin.\n"
	}, 
	{
		Header = "STATS", 
		Text = "Difficulty: ★★☆☆☆\n" .. ("Health: %s\n"):format(v1.Health) .. ("Regular Speed: %s\n"):format(v1.Speed) .. ("Sprinting Speed: %s\n"):format(v1.SprintSpeed) .. ("Max Stamina: %s\n"):format(v1.MaxStamina) .. ("Stamina Loss per sec: %s\n"):format(v1.StaminaLoss) .. ("Stamina Gain per sec: %s\n"):format(v1.StaminaGain) .. "Terror Radius: 45 studs\n"
	}, 
	{
		Separator = "ABILITIES"
	}, 
	{
		Image = "rbxassetid://97183429269286", 
		Header = "SLASH", 
		Quote = "\"Make them remember!\" - Mother", 
		Text = ("Cooldown: %ss (%ss if used while <font color=\"rgb(255,50,50)\">ENRAGED</font>)\n"):format(v1.SlashCooldown, v1.EnragedSlashCooldown) .. ("Damage: %s (%s if used while <font color=\"rgb(255,50,50)\">ENRAGED</font>)\n"):format(v1.SlashDamage, v1.EnragedSlashDamage) .. ("Windup: %ss\n"):format(v1.SlashWindup) .. ("Linger: %ss\n"):format(v1.SlashLinger) .. "Length: 7 studs\n" .. "<font color=\"rgb(200,150,20)\">Slasher</font> does a basic slash with his machete; inflicts <b>Bleeding I</b> for 5 seconds.\n" .. "This slash can hit through multiple people at once.\n" .. "A lunge is added to this attack if it's used while <font color=\"rgb(200,150,20)\">Slasher's</font> <font color=\"rgb(255,50,50)\">ENRAGED</font>.\n"
	}, 
	{
		Image = "rbxassetid://115283980500353", 
		Header = "BEHEAD", 
		Quote = "\"No place to hide.\" - Mother", 
		Text = ("Cooldown: %ss (%ss if used while <font color=\"rgb(255,50,50)\">ENRAGED</font>)\n"):format(v1.BeheadCooldown, v1.EnragedBeheadCooldown) .. ("Damage: %s (%s if used while <font color=\"rgb(255,50,50)\">ENRAGED</font>)\n"):format(v1.BeheadDamage, v1.EnragedBeheadDamage) .. "<font color=\"rgb(200,150,20)\">Slasher</font> winds up a strong horizontal swing to the head of his target.\n" .. "BEHEAD inflicts <b>Helpless I</b> for 14 seconds.\n" .. "After this attack, <font color=\"rgb(200,150,20)\">Slasher</font>, regardless if it hit, gains <b>Slowness I</b> for 2 seconds.\n"
	}, 
	{
		Image = "rbxassetid://96900331272883", 
		Header = "GASHING WOUND", 
		Quote = "\"It'll be easier for you than it was for him.\" - Mother", 
		Text = ("Cooldown: %ss (%ss if used while <font color=\"rgb(255,50,50)\">ENRAGED</font>)\n"):format(v1.GashingWoundCooldown, v1.EnragedGashingWoundCooldown) .. ("Damage: %s (%s if used while <font color=\"rgb(255,50,50)\">ENRAGED</font>)\n"):format(v1.GashingWoundDamage, v1.EnragedGashingWoundDamage) .. "<font color=\"rgb(200,150,20)\">Slasher</font> does a combination of slashes, starting with 2 hits from his machete, then quickly jams his chainsaw into the victim.\n" .. ("Each slash deals around 1/5 of the attack's total damage, but they all add up to either %s or %s depending on if <font color=\"rgb(200,150,20)\">Slasher's</font> <font color=\"rgb(255,50,50)\">ENRAGED</font>.\n"):format(v1.GashingWoundDamage, v1.EnragedGashingWoundDamage)
	}, 
	{
		Image = "rbxassetid://86530225037587", 
		Header = "RAGING PACE", 
		Quote = "\"Kill them!\" - Mother", 
		Text = ("Cooldown: %ss\n"):format(v1.RagingPaceCooldown) .. "<font color=\"rgb(200,150,20)\">Slasher</font> becomes <font color=\"rgb(255,0,0)\">ENRAGED.</font>\n" .. ("On activation, <font color=\"rgb(200,150,20)\">Slasher</font>'s speed becomes %s for %s seconds, and the aura of the nearest survivor is revealed to him. The aura remains revealed until his <font color=\"rgb(255,0,0)\">ENRAGED.</font> state ends, in which it'll linger for an additional %ss.\n"):format(v1.EnragedSpeed, v1.EnragedTime, v1.EnragedAuraLingerTime) .. ("While in effect, <font color=\"rgb(200,150,20)\">Slasher</font> becomes immune to stuns, has his sprinting disabled, and has his stamina slowly become capped at %s over the span of %ss. The cap is removed once he leaves his <font color=\"rgb(255,0,0)\">ENRAGED.</font> state.\n"):format(v1.EnragedStaminaCap, v1.EnragedStaminaCapLerpTime)
	}
};

return v1;