-- Helperbot FCT port v1.0.0. Import HelperbotDonor.rbxm and HelperbotUPD.rbxm into Workspace first.
assert(game:GetService("RunService"):IsStudio() and not game:GetService("RunService"):IsRunning(),"Stop Play before applying Helperbot.")
local function find(path)
 local current=game
 for part in path:gmatch("[^/]+") do current=current and current:FindFirstChild(part) end
 return current
end
local survivors=assert(find("ReplicatedStorage/Assets/Survivors"),"Missing FCT Survivors folder. Nothing changed.")
local statuses=assert(find("ReplicatedStorage/Modules/StatusEffects"),"Missing FCT statuses. Nothing changed.")
local old=survivors:FindFirstChild("Helperbot")
if old and old:GetAttribute("HelperbotPortVersion")=="1.0.0" then print("[Helperbot Port] Already installed. Nothing changed.");return end
for _,path in {"ReplicatedStorage/Modules/Actors","ReplicatedStorage/Modules/Util","ReplicatedStorage/Modules/Statuses","ReplicatedStorage/Modules/Network","ReplicatedStorage/Modules/Sounds","ReplicatedStorage/Modules/Misc/Maid","ReplicatedStorage/Modules/Misc/Trove"} do assert(find(path),"Missing dependency: "..path..". Nothing changed.") end
for _,name in {"Haste","Fatigue"} do assert(not statuses:FindFirstChild(name,true),"Existing "..name.." status found; preserve it and review compatibility before installing. Nothing changed.") end
local donor=assert(workspace:FindFirstChild("HelperbotDonor"),"Import HelperbotDonor.rbxm into Workspace first. Nothing changed.")
local upd=assert(workspace:FindFirstChild("HelperbotUPD"),"Import HelperbotUPD.rbxm into Workspace first. Nothing changed.")
assert(donor:FindFirstChild("Rig") and donor.Rig:FindFirstChildOfClass("Humanoid"),"Imported donor has no Helperbot rig. Nothing changed.")
assert(upd:FindFirstChild("Config") and upd.Config:FindFirstChild("VFX") and upd.Config:FindFirstChild("Radar") and upd.Config:FindFirstChild("ChargeMeter"),"Imported UPD model is incomplete. Nothing changed.")
local plans={
{path=[====[
Config]====],source=[====[

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
return t1]====],bytes=12259},
{path=[====[
Config/cl_HelperbotChargeBillboard]====],source=[====[

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local Trove = require(ReplicatedStorage.Modules.Misc.Trove)
local t1 = {}

t1.__index = t1

function t1.new(p1, p2, t2: {[any]: any}, p3: ((...any) -> ...any)) -- line: 12
	-- upvalues: t1 (copy), Trove (copy)
	local self = setmetatable({}, t1)
	local clone = p1:Clone()

	clone.Adornee = p2.PrimaryPart or p2
	clone.Name = "ChargeBillboard"
	clone.Parent = p2
	self.__instance = clone
	self.__character = p2
	self.__config = t2
	self.__internalTrove = Trove.new()
	self.DestroyedCallback = p3
	self.__destroyed = false
	self.__completed = false
	self.__internalTrove:Connect(p2.AncestryChanged, function() -- line: 27
		-- upvalues: p2 (copy), self (copy)
		if not p2:IsDescendantOf(workspace) then
			self:Destroy()
		end
	end)
	self.__internalTrove:Connect(clone.AncestryChanged, function() -- line: 32
		-- upvalues: clone (copy), p2 (copy), self (copy)
		if clone.Parent ~= p2 then
			self:Destroy()
		end
	end)
	self.__internalTrove:Connect(clone.Destroying, function() -- line: 37
		-- upvalues: self (copy)
		self:Destroy(true)
	end)

	local Humanoid = p2:FindFirstChildOfClass("Humanoid")

	if Humanoid then
		self.__internalTrove:Connect(Humanoid.Died, function() -- line: 42
			-- upvalues: self (copy)
			self:Destroy()
		end)
	end

	self:Init()

	return self
end
function t1.Init(p4) -- line: 51
	p4.__instance.Background.Bar.BackgroundColor3 = p4.__config.ChargeColors.Default
	p4.__instance.Background.Bar.Size = UDim2.fromScale(0, 1)
end
function t1.CancelFill(p5) -- line: 56
	if p5.__currentTween then
		p5.__currentTween:Cancel()
		p5.__currentTween:Destroy()
		p5.__currentTween = nil
	end
end
function t1.DisplaySuccess(p6) -- line: 64
	if p6.__destroyed or p6.__completed then
		return
	end

	p6.__completed = true
	p6:CancelFill()

	local Bar = p6.__instance.Background.Bar

	Bar.BackgroundColor3 = p6.__config.ChargeColors.Success
	Bar.Size = UDim2.fromScale(1, 1)
	task.delay(0.25, function() -- line: 71
		-- upvalues: p6 (copy)
		p6:Destroy()
	end)
end
function t1.TweenFill(t3: {[any]: any}, n1: number, n2: number, n3: number?) -- line: 76
	-- upvalues: TweenService (copy)
	if t3.__destroyed or t3.__completed then
		return
	end

	t3:CancelFill()

	local Bar = t3.__instance.Background.Bar

	if n3 ~= nil then
		Bar.Size = UDim2.fromScale(math.clamp(n3, 0, 1), 1)
	end

	local uDim2 = UDim2.fromScale(math.clamp(n2, 0, 1), 1)

	if n1 <= 0 then
		Bar.Size = uDim2

		return
	end

	t3.__currentTween = TweenService:Create(Bar, TweenInfo.new(n1, Enum.EasingStyle.Linear), {
		Size = uDim2
	})
	t3.__currentTween:Play()
end
function t1.Destroy(t4: {[any]: any}, b1: boolean?) -- line: 92
	-- upvalues: TweenService (copy), Debris (copy)
	if t4.__destroyed then
		return
	end

	t4.__destroyed = true
	t4:CancelFill()
	t4.__internalTrove:Destroy()

	local __instance = t4.__instance

	if not b1 and __instance.Parent then
		local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

		TweenService:Create(__instance.Background.Bar, tweenInfo, {
			Size = UDim2.fromScale(0, 1)
		}):Play()

		for _, descendant in ipairs(__instance:GetDescendants()) do
			if descendant:IsA("TextLabel") then
				TweenService:Create(descendant, tweenInfo, {
					TextTransparency = 1,
					TextStrokeTransparency = 1
				}):Play()
			elseif descendant:IsA("ImageLabel") then
				TweenService:Create(descendant, tweenInfo, {
					ImageTransparency = 1
				}):Play()
			elseif descendant:IsA("Frame") then
				TweenService:Create(descendant, tweenInfo, {
					BackgroundTransparency = 1
				}):Play()
			elseif descendant:IsA("UIStroke") then
				TweenService:Create(descendant, tweenInfo, {
					Transparency = 1
				}):Play()
			end
		end

		Debris:AddItem(__instance, 0.5)
	elseif not b1 then
		__instance:Destroy()
	end

	local DestroyedCallback = t4.DestroyedCallback

	t4.DestroyedCallback = nil

	if DestroyedCallback then
		DestroyedCallback()
	end
end

return t1]====],bytes=4061},
{path=[====[
Behavior]====],source=[====[
-- FCF rig + current UPD presentation; authoritative mechanics reconstructed for FCT.
local RunService=game:GetService("RunService")
local Impl=require(RunService:IsServer() and script.Server or script.Client)
local Behavior={}
for name,method in pairs(Impl) do Behavior[name]=method end
Behavior.Abilities={}
for name,info in pairs({Pulse={1,"127410699461731",44},Inspiration={2,"126611529586683",46}}) do
 Behavior.Abilities[name]={LayoutOrder=info[1],Icon="rbxassetid://"..info[2],KeybindType="AltAbility"..info[1],Cooldown=info[3],Callback=function(actor)
  return Impl[name](actor)
 end}
end
return Behavior
]====],bytes=613},
{path=[====[
Behavior/Server]====],source=[====[
local RunService=game:GetService("RunService")
local Players=game:GetService("Players")
local Modules=game.ReplicatedStorage.Modules
local Actors=require(Modules.Actors)
local Statuses=require(Modules.Statuses)
local Util=require(Modules.Util)
local Sounds=require(Modules.Sounds)
local Network=require(Modules.Network)
local Rules=require(script.Parent.Rules)
local Server={}
local function alive(rig)
 local hum=rig and rig:FindFirstChildOfClass("Humanoid")
 return rig and rig.Parent and rig.PrimaryPart and hum and hum.Health>0
end
local function active(a) return not a.HelperDestroyed and alive(a.Rig) end
local function survivors()
 local folder=workspace:FindFirstChild("Players")
 return folder and folder:FindFirstChild("Survivors")
end
local function actorFor(rig)
 local player=Players:GetPlayerFromCharacter(rig)
 if player and Actors.CurrentActors[player] then return Actors.CurrentActors[player] end
 for _,a in pairs(Actors.CurrentActors) do if a.Rig==rig then return a end end
end
local function helpers(a)
 local n,seen=0,{}
 for _,other in pairs(Actors.CurrentActors) do
  if other~=a and other.ActorName=="Helperbot" and alive(other.Rig) and other.Rig.Parent==survivors() and not seen[other.Rig] then seen[other.Rig]=true;n+=1 end
 end
 return n
end
local function emit(a,method,...)
 if a.Player then Network:FireAllClientConnection(a.Player.Name.."PCallAllClients","REMOTE_EVENT",method,...) end
end
local function localEmit(a,method,...)
 if a.Player and a.Player:IsA("Player") then Network:FireClientConnection(a.Player,a.Player.Name.."PCallLocal","REMOTE_EVENT",method,...) end
end
local function sound(a,key,options)
 if not active(a) then return end
 local id=a.Config.Sounds and a.Config.Sounds[key]
 if not id or id=="" then return end
 options=options or {};options.Parent=options.Parent or a.Rig.PrimaryPart;options.Volume=options.Volume or .25
 local ok,result=pcall(Sounds.Play,Sounds,id,options)
 if ok then return result end
end
local function lock(a,name,on)
 a.AbilityDisablers=a.AbilityDisablers or {};a.AbilityDisablers["Helperbot"..name]=on or nil
end
local function clearCast(a)
 local cast=a.HelperCast
 if not cast then return end
 a.HelperCast=nil
 if cast.health then cast.health:Disconnect() end
 if cast.speed then cast.speed:Destroy() end
 lock(a,cast.name,false)
end
local function interrupted(a)
 local rig=a.Rig
 return rig:GetAttribute("Stunned") or rig:GetAttribute("Helpless") or rig:GetAttribute("Ragdolling") or rig:GetAttribute("AbilitiesDisabled") or rig.PrimaryPart.Anchored
end
local function charges(a,n,reward)
 local before=a.HelperCharges or 1
 a.HelperCharges=Rules.Level(n);a.Rig:SetAttribute("PulseCharges",a.HelperCharges)
 localEmit(a,"OnChargeLevelChanged",a.HelperCharges,"Pulse")
 if reward and a.HelperCharges>before and a.Player and a.Player:IsA("Player") then
  Actors:IncrementActorStats(a.Player,{Action="Leveled up Pulse",Money=2,EXP=13,KillerChance=.25})
 end
end
local function stopZone(a)
 local zone=a.HelperZone
 if not zone then return end
 a.HelperZone=nil
 if zone.loop then zone.loop:Destroy() end
 emit(a,"DestroyZoneVisual",zone.id)
 sound(a,"InspireEnd")
end
function Server.Interrupt(a)
 local cast=a.HelperCast
 if cast then
  if cast.name=="Pulse" then
   emit(a,"OnPulseInterrupted");sound(a,"PulseInterrupted")
   if a.SetCooldownOf then a:SetCooldownOf("Pulse",44) end
  end
  clearCast(a)
 end
end
function Server.Pulse(a)
 if not active(a) or a.HelperCast or interrupted(a) then return {Cancelled=true} end
 local cast={name="Pulse",ends=os.clock()+2}
 a.HelperCast=cast;lock(a,"Pulse",true)
 cast.speed=Util:CreateSpeedMultiplier(a.Player or a.Rig,.9,"HelperbotPulseWindup")
 local hum=a.Rig:FindFirstChildOfClass("Humanoid");local previous=hum.Health
 cast.health=hum.HealthChanged:Connect(function(health)
  local damaged=health<previous;previous=health
  if damaged and a.HelperCast==cast then Server.Interrupt(a) end
 end)
 emit(a,"OnPulseWindup");sound(a,"PulseWindup")
end
function Server.Inspiration(a)
 if not active(a) or a.HelperCast or a.HelperZone or interrupted(a) then return {Cancelled=true} end
 a.HelperCast={name="Inspiration",ends=os.clock()+.75}
 lock(a,"Inspiration",true)
 a.HelperCast.speed=Util:CreateSpeedMultiplier(a.Player or a.Rig,.01,"HelperbotInspireWindup")
 sound(a,"InspireWindup")
end
local function applyPulse(a,rig,level,count)
 local other=actorFor(rig)
 local duration=Rules.BuffDuration(level,count,rig~=a.Rig and other and other.ActorName=="Helperbot")
 -- Veeronica does not receive healing, but can receive Resistance.
 if not (other and (other.ActorName=="Veeronica" or other.ActorName=="Vee")) then
  Statuses:ApplyStatus(rig,"Regeneration",{Level=1,Duration=duration,AppliedFrom="HelperbotPulse"})
 end
 Statuses:ApplyStatus(rig,"Resistance",{Level=1,Duration=duration,AppliedFrom="HelperbotPulse"})
 emit(a,"OnPulseHit",rig,true)
 sound(a,"PulseHitPositive",{Parent=rig.PrimaryPart})
end
local function releasePulse(a)
 local level=a.HelperCharges or 1
 local radius=Rules.Radius(level)
 charges(a,0,false)
 emit(a,"OnPulseEmitted",radius,radius);sound(a,"Pulse")
 a.HelperWaves=a.HelperWaves or {}
 table.insert(a.HelperWaves,{origin=a.Rig.PrimaryPart.Position,radius=radius,level=level,elapsed=0,started=os.clock(),hit={},helpers=helpers(a)})
 -- Retain the 0.75s recovery and windup slowdown without a stale timer unlocking another cast.
 local cast=a.HelperCast
 if cast.speed then cast.speed:Destroy();cast.speed=nil end
 if cast.health then cast.health:Disconnect();cast.health=nil end
 cast.recovery=true;cast.ends=os.clock()+.75
end
local function startZone(a)
 a.HelperZoneSerial=(a.HelperZoneSerial or 0)+1
 local id=tostring(a.HelperZoneSerial)
 a.HelperZone={id=id,remaining=10,last=os.clock(),elapsed=0,progress={},granted={},inside={}}
 emit(a,"CreateZoneVisual",id,16);sound(a,"Inspire")
 a.HelperZone.loop=sound(a,"InspireLoop",{Looped=true})
 if a.HelperCast.speed then a.HelperCast.speed:Destroy();a.HelperCast.speed=nil end
 a.HelperCast.recovery=true;a.HelperCast.ends=os.clock()+.75
end
local function updateZone(a,dt)
 local z=a.HelperZone
 if not z then return end
 -- Integrate only the portion of the frame within the aura's fixed lifetime.
 local now=os.clock();dt=math.min(math.max(0,now-z.last),z.remaining);z.last=now
 z.remaining-=dt;z.elapsed+=dt
 local folder=survivors();local nowInside={};local haste=Rules.Haste(helpers(a))
 if folder then for _,rig in ipairs(folder:GetChildren()) do
  if alive(rig) and (rig.PrimaryPart.Position-a.Rig.PrimaryPart.Position).Magnitude<=16 then
   nowInside[rig]=true
   -- Refresh every half-second. Self receives Haste too, excluding Inspiration.
   if z.elapsed>=.5 then Statuses:ApplyStatus(rig,"Haste",{Level=haste,Duration=2,DisabledAbilityNames={"Inspiration"},AppliedFrom="HelperbotInspiration"}) end
   if rig~=a.Rig and not z.granted[rig] then
    local progress=Rules.Progress(z.progress[rig] or 0,true,dt);z.progress[rig]=progress
    if not z.inside[rig] then
     emit(a,"InspireMeterUpdate","CharacterEnteredInspire",rig,math.max(0,progress-dt)/5,5-math.max(0,progress-dt),z.id)
     sound(a,"InspirePlayerEntered",{Parent=rig.PrimaryPart})
    end
    if progress>=5 then
     z.granted[rig]=true
     charges(a,(a.HelperCharges or 0)+1,true)
     emit(a,"InspireMeterUpdate","CharacterGaveCharge",rig,z.id)
    end
   end
  end
 end end
 for rig,progress in pairs(z.progress) do
  if not nowInside[rig] and not z.granted[rig] then
   if z.inside[rig] then
    emit(a,"InspireMeterUpdate","CharacterLeftInspire",rig,progress/5,progress/.7,z.id)
    if alive(rig) then sound(a,"InspirePlayerLeft",{Parent=rig.PrimaryPart}) end
   end
   z.progress[rig]=Rules.Progress(progress,false,dt)
   if z.progress[rig]<=0 or not alive(rig) then
    emit(a,"InspireMeterUpdate","CharacterChargeRemoved",rig,z.id)
    z.progress[rig]=nil
   end
  end
 end
 z.inside=nowInside
 if z.elapsed>=.5 then z.elapsed=0 end
 if z.remaining<=0 then stopZone(a) end
end
local function step(a,dt)
 if not active(a) then Server.Destroyed(nil,a);return end
 local cast=a.HelperCast
 if cast then
  if not cast.recovery and interrupted(a) then Server.Interrupt(a)
  elseif os.clock()>=cast.ends then
   if cast.recovery then clearCast(a)
   elseif cast.name=="Pulse" then releasePulse(a)
   else startZone(a) end
  end
 end
 for i=#a.HelperWaves,1,-1 do
  local wave=a.HelperWaves[i];wave.elapsed=os.clock()-wave.started
  local reach=math.min(wave.radius,wave.elapsed*wave.radius)
  local folder=survivors()
  if folder then for _,rig in ipairs(folder:GetChildren()) do
   if alive(rig) and not wave.hit[rig] and (rig.PrimaryPart.Position-wave.origin).Magnitude<=reach then
    wave.hit[rig]=true;applyPulse(a,rig,wave.level,wave.helpers)
   end
  end end
  if wave.elapsed>=1 then table.remove(a.HelperWaves,i) end
 end
 updateZone(a,dt)
 a.HelperRadarElapsed+=dt
 if a.HelperRadarElapsed>=12 then a.HelperRadarElapsed%=12;emit(a,"RadarScan") end
end
function Server.Created(_,a)
 a.HelperDestroyed=false;a.HelperConnections={};a.HelperWaves={};a.HelperRadarElapsed=0
 charges(a,1,false)
 -- FCT increments this server-owned counter for non-primary ability use. Watch actual changes rather than guessing from cooldown changes/Haste.
 local watched={}
 local function watch(rig)
  if watched[rig] or rig==a.Rig then return end
  watched[rig]=true
  table.insert(a.HelperConnections,rig:GetAttributeChangedSignal("AbilitiesUsed"):Connect(function()
   if active(a) and alive(rig) and rig.Parent==survivors() then localEmit(a,"ShowSurvivorAura",rig) end
  end))
 end
 local folder=survivors()
 if folder then for _,rig in ipairs(folder:GetChildren()) do watch(rig) end;table.insert(a.HelperConnections,folder.ChildAdded:Connect(watch)) end
 table.insert(a.HelperConnections,RunService.Heartbeat:Connect(function(dt) step(a,dt) end))
 table.insert(a.HelperConnections,a.Rig:FindFirstChildOfClass("Humanoid").Died:Connect(function() Server.Destroyed(nil,a) end))
end
function Server.Destroyed(_,a)
 if a.HelperDestroyed then return end
 a.HelperDestroyed=true
 clearCast(a);stopZone(a)
 for _,connection in ipairs(a.HelperConnections or {}) do connection:Disconnect() end
 a.HelperConnections={};a.HelperWaves={}
 emit(a,"PortCleanup")
end
function Server.OnHelpless(_,a) Server.Interrupt(a) end
Server.OnStunned=Server.OnHelpless
return Server
]====],bytes=10342},
{path=[====[
Behavior/Client]====],source=[====[
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local TweenService=game:GetService("TweenService")
local SoundService=game:GetService("SoundService")
local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local Sounds=require(ReplicatedStorage.Modules.Sounds)
local Util=require(ReplicatedStorage.Modules.Util)
local Maid=require(ReplicatedStorage.Modules.Misc.Maid)
local Network=require(ReplicatedStorage.Modules.Network)
local _ = math.random
local _ = table.insert
local _ = table.sort
local _ = task.wait
local spawn = task.spawn
local _ = task.delay
local _ = coroutine.close

TweenInfo.new(1)
Random.new()
TweenInfo.new(0.2)

local LocalPlayer = Players.LocalPlayer
local _ = workspace.CurrentCamera

local function flRandom(p1, p2) -- line: 89
	return p1 + Random.new():NextNumber() * (p2 - p1)
end
local function __displayWarn(_: string) -- line: 96
end
local function __pcallMethod(s2: string, p3, ...) -- line: 119
	local ok, result = pcall(function(...) -- line: 121
		-- upvalues: p3 (copy), s2 (copy)
		if p3.Behavior[s2] then
			return p3.Behavior[s2](p3.Behavior, p3, ...)
		end
	end, ...)

	if not ok then
		warn(`[Unknown]: Failed to call .{ s2 }() due to: { result }, { debug.traceback() }`)

		return
	end

	return result
end
local function __playSound(t1: {[any]: any}, s3: string, t2: {[any]: any}?) -- line: 139
	-- upvalues: Util (copy), Sounds (copy)
	local v36 = Util:CopyTable(t2 or {
		Volume = 0.25,
		PlaybackSpeed = 0.975 + Random.new():NextNumber() * 0.04999999999999993
	})

	v36.Parent = t2 and t2.Parent or t1.Rig.PrimaryPart

	if v36.Volume == nil then
		v36.Volume = 0.25
	end

	return Sounds:Play(t1.Config.Sounds[s3], v36)
end

local t3 = {}
local Presentation=require(script.Parent.Presentation)

local function playChargeUISound(p4, p5) -- line: 429
	-- upvalues: Sounds (copy), SoundService (copy)
	local v39 = p4.Config.Sounds[p5]

	if not v39 then
		return
	end

	return Sounds:Play(v39, {
		Looped = false,
		Parent = SoundService,
		Volume = p4.Config.Sounds.ChargeUISoundVolume or 0.25
	})
end
local function updateChargeUISound(p6) -- line: 440
	-- upvalues: Sounds (copy), SoundService (copy), TweenService (copy)
	local v41 = next(p6.InspireChargingBars or {}) ~= nil

	if v41 == (p6.InspireChargeSoundActive == true) then
		return
	end

	p6.InspireChargeSoundActive = v41

	local InspireChargeSoundTween = p6.InspireChargeSoundTween

	if InspireChargeSoundTween then
		p6.InspireChargeSoundTween = nil
		InspireChargeSoundTween:Cancel()
		InspireChargeSoundTween:Destroy()
	end

	local InspireChargeSound = p6.InspireChargeSound

	if v41 then
		if InspireChargeSound then
			InspireChargeSound:Destroy()
		end

		local InspireBarCharging = p6.Config.Sounds.InspireBarCharging

		p6.InspireChargeSound = if InspireBarCharging then Sounds:Play(InspireBarCharging, {
			Looped = false,
			Parent = SoundService,
			Volume = p6.Config.Sounds.ChargeUISoundVolume or 0.25
		}) else nil

		return
	end

	if InspireChargeSound and InspireChargeSound.Parent then
		local v45 = p6.Config.Sounds.ChargeUISoundFadeTime or 0.35
		local tween = TweenService:Create(InspireChargeSound, TweenInfo.new(v45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Volume = 0
		})

		p6.InspireChargeSoundTween = tween
		tween.Completed:Once(function(p7) -- line: 461
			-- upvalues: p6 (copy), InspireChargeSound (copy), tween (copy)
			if p7 ~= Enum.PlaybackState.Completed then
				return
			end

			if p6.InspireChargeSound ~= InspireChargeSound or p6.InspireChargeSoundActive then
				return
			end

			p6.InspireChargeSound = nil
			p6.InspireChargeSoundTween = nil
			InspireChargeSound:Destroy()
			tween:Destroy()
		end)
		tween:Play()

		return
	end

	p6.InspireChargeSound = nil
end
local function setChargeUICharging(p8, p9, p10) -- line: 475
	-- upvalues: updateChargeUISound (copy)
	p8.InspireChargingBars = p8.InspireChargingBars or {}
	p8.InspireChargingBars[p9] = not not p10 or nil
	updateChargeUISound(p8)
end

function t3.lcl_OnRadarUsed(_, p12) -- line: 481
	-- upvalues: __playSound (copy)
	local Detection = p12.Config.Detection

	__playSound(p12, "Radar", {
		Volume = 0.25,
		RollOffMaxDistance = Detection.Radius,
		RollOffMinDistance = Detection.Radius / 3
	})

	local DetectionRadius = p12.Config.Detection.Radius
	local clone = p12.Config.Instances.RadarEffectPart:Clone()
 clone.CanCollide=false;clone.CanTouch=false;clone.CanQuery=false

	clone.Parent = workspace.Map.Ingame
	clone.Size = Vector3.new(0, 0, 0)
	clone.Position = p12.Rig.PrimaryPart.Position
	clone.Massless = true
	clone.RootPriority = -66
	clone.Parent = workspace.Map.Ingame
	clone.Anchored = true
	clone.CFrame = CFrame.new(p12.Rig.PrimaryPart.Position)
	game.TweenService:Create(clone, TweenInfo.new(0.7, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
		Transparency = 1,
		Size = Vector3.new(1, 1, 1) * DetectionRadius
	}):Play()
	game.Debris:AddItem(clone, 1)

	local v55 = p12.Animations and p12.Animations.Detect

	if v55 then
		pcall(function() v55:Play(0.05) end)
	end
end
function t3.cl_ClearPulseHighlight(_, p14) -- line: 506
	local PulseHighlightEffect = p14.PulseHighlightEffect

	if not PulseHighlightEffect then
		return
	end

	p14.PulseHighlightEffect = nil

	if PulseHighlightEffect.Died then
		PulseHighlightEffect.Died:Disconnect()
	end

	if PulseHighlightEffect.AncestryChanged then
		PulseHighlightEffect.AncestryChanged:Disconnect()
	end

	if PulseHighlightEffect.Tween then
		PulseHighlightEffect.Tween:Cancel()
		PulseHighlightEffect.Tween:Destroy()
	end

	PulseHighlightEffect.Highlight:Destroy()
end
function t3.cl_OnPulseWindup(p15, p16) -- line: 519
	-- upvalues: LocalPlayer (copy), Util (copy)
	p15:cl_ClearPulseHighlight(p16)

	if p16.Player == LocalPlayer then
		return
	end

	local Character = LocalPlayer.Character
	local Rig = p16.Rig

	if not Util:IsAlive(Character) or Character.Parent ~= workspace.Players.Survivors then
		return
	end

	if not Util:IsAlive(Rig) then
		return
	end

	local SonicPulse = p16.Config.SonicPulse
	local Highlight = Instance.new("Highlight")

	Highlight.Name = "HelperbotPulseHighlight"
	Highlight.Adornee = Rig
	Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	Highlight.FillColor = SonicPulse.HighlightColor
	Highlight.OutlineColor = SonicPulse.HighlightColor
	Highlight.FillTransparency = SonicPulse.HighlightWindupFillTransparency
	Highlight.OutlineTransparency = SonicPulse.HighlightWindupOutlineTransparency
	Highlight.Parent = Rig

	local t4 = {
		Highlight = Highlight
	}

	p16.PulseHighlightEffect = t4
	t4.Died = Rig:FindFirstChildOfClass("Humanoid").Died:Connect(function() -- line: 540
		-- upvalues: p15 (copy), p16 (copy)
		p15:cl_ClearPulseHighlight(p16)
	end)
	t4.AncestryChanged = Rig.AncestryChanged:Connect(function() -- line: 543
		-- upvalues: Rig (copy), p15 (copy), p16 (copy)
		if not Rig:IsDescendantOf(workspace) then
			p15:cl_ClearPulseHighlight(p16)
		end
	end)
end
function t3.cl_FlashPulseHighlight(t5: {[any]: any}, p17, color3: Color3?) -- line: 550
	-- upvalues: TweenService (copy)
	if not p17.PulseHighlightEffect then
		t5:cl_OnPulseWindup(p17)
	end

	local PulseHighlightEffect = p17.PulseHighlightEffect

	if not PulseHighlightEffect then
		return
	end

	if PulseHighlightEffect.Tween then
		PulseHighlightEffect.Tween:Cancel()
		PulseHighlightEffect.Tween:Destroy()
	end

	local Highlight = PulseHighlightEffect.Highlight

	if color3 then
		Highlight.FillColor = color3
		Highlight.OutlineColor = color3
	end

	Highlight.FillTransparency = 0
	Highlight.OutlineTransparency = 0

	local tween = TweenService:Create(Highlight, TweenInfo.new(p17.Config.SonicPulse.HighlightReleaseFadeTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		FillTransparency = 1,
		OutlineTransparency = 1
	})

	PulseHighlightEffect.Tween = tween
	tween.Completed:Once(function(p18) -- line: 572
		-- upvalues: p17 (copy), PulseHighlightEffect (copy), t5 (copy)
		if p18 == Enum.PlaybackState.Completed and p17.PulseHighlightEffect == PulseHighlightEffect then
			t5:cl_ClearPulseHighlight(p17)
		end
	end)
	tween:Play()
end
function t3.cl_OnPulseInterrupted(p19, p20) -- line: 580
	-- upvalues: LocalPlayer (copy)
	if p20.Player == LocalPlayer then
		if p20.Animations and p20.Animations.Pulse then pcall(function() p20.Animations.Pulse:Stop(0.05) end) end

		return
	end

	p19:cl_FlashPulseHighlight(p20, Color3.fromRGB(255, 0, 0))
end
function t3.cl_OnPulseEmitted(t6: {[any]: any}, p21, n1: number, n2: number) -- line: 588
	-- upvalues: spawn (copy), Util (copy)
	t6:cl_FlashPulseHighlight(p21)

	local clone = p21.Config.Instances.RadarEffectPart:Clone()

	clone.Size = Vector3.new(0, 0, 0)
	clone.Position = p21.Rig.PrimaryPart.Position
 clone.Anchored=true;clone.CanCollide=false;clone.CanTouch=false;clone.CanQuery=false
	clone.Transparency = 0.6
	clone.Color = Color3.new(0.5, 0.5, 1)
	clone.Material = Enum.Material.Neon
	clone.Parent = workspace.Map.Ingame

	game.TweenService:Create(clone, TweenInfo.new(n1 / n2, Enum.EasingStyle.Linear), {
		Transparency = 1,
		Size = Vector3.new(1, 1, 1) * n1 * 2
	}):Play()
	game.Debris:AddItem(clone, 2)
end
function t3.cl_OnPulseHit(_: {[any]: any}, _, _: boolean) -- line: 612
end
function t3.cl_CreateZoneVisual(_: {[any]: any}, p23, s4: string, p24) -- line: 616
	-- upvalues: TweenService (copy)
	local clone = p23.Config.Instances.RadarEffectPart:Clone()
 clone.CanCollide=false;clone.CanTouch=false;clone.CanQuery=false

	clone.CFrame = p23.Rig.PrimaryPart.CFrame
	clone.Transparency = 0.75
	clone.Anchored = false
	clone.Color = Color3.new(0.5, 0.5, 1)
	clone.Massless = true
	clone.RootPriority = -66
	clone.Name = "HelperbotInspireZoneVis" .. s4

	local Weld = Instance.new("Weld")

	Weld.Part0 = p23.Rig.PrimaryPart
	Weld.Part1 = clone
	Weld.Parent = clone
	clone.Parent = workspace.Map
	TweenService:Create(clone, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Transparency = 0.75,
		Size = Vector3.new(1, 1, 1) * p24 * 2
	}):Play()

	local t9 = {}

	function t9.Destroy(_) -- line: 637
		-- upvalues: t9 (copy), Weld (copy), clone (copy), TweenService (copy), p23 (copy), s4 (copy)
		if t9.Destroyed then
			return
		end

		t9.Destroyed = true

		if Weld and Weld.Parent then
			Weld:Destroy()
		end

		if clone and clone.Parent then
			clone.Anchored = true
			TweenService:Create(clone, TweenInfo.new(0.65, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
				Size = Vector3.new(0, 0, 0),
				Transparency = 0.75
			}):Play()
			game.Debris:AddItem(clone, .7)
		end

		p23.State.ActiveZones[s4] = nil
	end

	p23.State.ActiveZones[s4] = t9
	p23.Maid:Add(t9)
end
function t3.cl_DestroyZoneVisual(_, p27, p28) -- line: 655
	-- upvalues: __pcallMethod (copy)
	__pcallMethod("lcl_InspireChargeUIEnded", p27, p28)

	local v93 = p27.State.ActiveZones[p28]

	if not v93 or not v93.Destroy then
		return
	end

	v93:Destroy()
end
function t3.cl_OnZoneEntered(_, _) -- line: 662
end
function t3.cl_OnZoneLeft(_, _) -- line: 666
end
function t3.lcl_OnChargeLevelChanged(_,a,level)
 a.State.ChargeLevel=level
 if a.Player==Players.LocalPlayer then Presentation.UpdateLevel(a) end
end
function t3.cl_InspireMeterUpdate(_, p35, p36, p37, ...) -- line: 690
	-- upvalues: LocalPlayer (copy), __pcallMethod (copy)
	if p37 ~= LocalPlayer.Character then
		return
	end

	if p36 ~= "CharacterEnteredInspire" and p36 ~= "CharacterLeftInspire" and p36 ~= "CharacterGaveCharge" and p36 ~= "CharacterChargeRemoved" then
		return
	end

	__pcallMethod("lcl_" .. p36, p35, p37, ...)
end
function t3.lcl_CharacterEnteredInspire(_, p39, p40, p41, p42, p43) -- line: 697
	-- upvalues: Util (copy), updateChargeUISound (copy), Sounds (copy), SoundService (copy)
	if not p40 or not Util:IsAlive(p40) then
		return
	end

	p39.ActiveChargeUI = p39.ActiveChargeUI or {}

	local u115 = p39.ActiveChargeUI[p43]

	if not u115 then
		u115 = {}
		p39.ActiveChargeUI[p43] = u115
	end

	local Class_InspirationBillboard = p39.Config.Instances.Class_InspirationBillboard

	if not Class_InspirationBillboard then
		return
	end

	local lib = require(Class_InspirationBillboard)
	local u118 = u115[p40]

	if not u118 then
		u118 = lib.new(p39.Config.Instances.ChargeMeter, p40, p39.Config.ClassConfigs.InspirationBillboard, function() -- line: 715
			-- upvalues: u115 (ref), p40 (copy), u118 (ref), p39 (copy), updateChargeUISound (copy)
			if u115[p40] == u118 then
				u115[p40] = nil
			end

			local v175 = p39
			local v176 = u118

			v175.InspireChargingBars = v175.InspireChargingBars or {}
			v175.InspireChargingBars[v176] = nil
			updateChargeUISound(v175)
		end)
		u115[p40] = u118

		local InspireBarAppear = p39.Config.Sounds.InspireBarAppear

		if InspireBarAppear then
			Sounds:Play(InspireBarAppear, {
				Looped = false,
				Parent = SoundService,
				Volume = p39.Config.Sounds.ChargeUISoundVolume or 0.25
			})
		end
	end

	u118:TweenFill(p42, 1, p41)

	local v120 = u118

	p39.InspireChargingBars = p39.InspireChargingBars or {}
	p39.InspireChargingBars[v120] = true
	updateChargeUISound(p39)
end
function t3.lcl_CharacterLeftInspire(_, p45, p46, p47, p48, p49) -- line: 729
	-- upvalues: updateChargeUISound (copy)
	local v127 = p45.ActiveChargeUI and p45.ActiveChargeUI[p49]
	local v128 = v127 and v127[p46]

	if not v128 then
		return
	end

	p45.InspireChargingBars = p45.InspireChargingBars or {}
	p45.InspireChargingBars[v128] = nil
	updateChargeUISound(p45)
	v128:TweenFill(p48, 0, p47)
end
function t3.lcl_CharacterGaveCharge(_, p51, p52, p53) -- line: 740
	-- upvalues: updateChargeUISound (copy), Sounds (copy), SoundService (copy)
	local v133 = p51.ActiveChargeUI and p51.ActiveChargeUI[p53]
	local v134 = v133 and v133[p52]

	if not v134 then
		return
	end

	local v135 = p51.InspireChargingBars and p51.InspireChargingBars[v134]

	p51.InspireChargingBars = p51.InspireChargingBars or {}
	p51.InspireChargingBars[v134] = nil
	updateChargeUISound(p51)

	if v135 then
		local InspireBarDone = p51.Config.Sounds.InspireBarDone

		if InspireBarDone then
			Sounds:Play(InspireBarDone, {
				Looped = false,
				Parent = SoundService,
				Volume = p51.Config.Sounds.ChargeUISoundVolume or 0.25
			})
		end
	end

	v134:DisplaySuccess()
end
function t3.lcl_CharacterChargeRemoved(_, p55, p56, p57) -- line: 755
	-- upvalues: updateChargeUISound (copy)
	local v141 = p55.ActiveChargeUI and p55.ActiveChargeUI[p57]
	local v142 = v141 and v141[p56]

	if v142 then
		p55.InspireChargingBars = p55.InspireChargingBars or {}
		p55.InspireChargingBars[v142] = nil
		updateChargeUISound(p55)
		v142:Destroy()
	end
end
function t3.lcl_InspireChargeUIEnded(_, p59, p60) -- line: 764
	-- upvalues: updateChargeUISound (copy)
	local v146 = p59.ActiveChargeUI and p59.ActiveChargeUI[p60]

	if not v146 then
		return
	end

	p59.ActiveChargeUI[p60] = nil

	for _, v in pairs(v146) do
		p59.InspireChargingBars = p59.InspireChargingBars or {}
		p59.InspireChargingBars[v] = nil
		updateChargeUISound(p59)
		v:Destroy()
	end
end
function t3.lcl_StopChargeUISound(_, p62) -- line: 774
	-- upvalues: updateChargeUISound (copy)
	if p62.InspireChargingBars then
		table.clear(p62.InspireChargingBars)
	end

	updateChargeUISound(p62)
end

function t3.Created(_, p66) -- line: 1061
	-- upvalues: Maid (copy), LocalPlayer (copy), Network (copy), __pcallMethod (copy)
	local _ = p66.Config

	p66.Maid = Maid.new()
	p66.Meta = {}
	p66.Instances = {}
	p66.State = {}
	p66.State.ActiveZones = {}
	p66.State.ChargeLevels = {
		Pulse = 0
	}
	p66.NetworkConnections = {}
	p66.ConnectionDictionary = {}

	local v158 = p66.Player == LocalPlayer

	p66.NetworkConnections.PCallAllClients = {
		`{ p66.Player.Name }PCallAllClients`,
		"REMOTE_EVENT"
	}
	Network:SetConnection(`{ p66.Player.Name }PCallAllClients`, "REMOTE_EVENT", function(p67, ...) -- line: 1187
		-- upvalues: __pcallMethod (copy), p66 (copy)
		if not p66.HelperClientDestroyed then __pcallMethod("cl_" .. p67, p66, ...) end
	end)

	if v158 then
		p66.NetworkConnections.PCallLocal = {
			`{ p66.Player.Name }PCallLocal`,
			"REMOTE_EVENT"
		}
		Network:SetConnection(`{ p66.Player.Name }PCallLocal`, "REMOTE_EVENT", function(p68, ...) -- line: 1193
			-- upvalues: __pcallMethod (copy), p66 (copy)
			if not p66.HelperClientDestroyed then __pcallMethod("lcl_" .. p68, p66, ...) end
		end)
		task.spawn(function() -- line: 1198
			-- upvalues: p66 (copy), __pcallMethod (copy)
			local v179 = p66.Behavior.Abilities and p66.Behavior.Abilities.Pulse
			local elapsed = os.clock()

			while (not v179 or not v179.UIElement or not v179.UIElement.Parent) and os.clock() - elapsed < 10 do
				task.wait(0.1)
			end

			__pcallMethod("lcl_OnChargeLevelChanged", p66, p66.Rig:GetAttribute("PulseCharges") or 1, "Pulse")
		end)
	end
end
function t3.Destroyed(_, p70) -- line: 1210
	-- upvalues: t3 (copy), Network (copy)
	t3:cl_ClearPulseHighlight(p70)

	if p70.ActiveChargeUI then
		for k in pairs(p70.ActiveChargeUI) do
			t3:lcl_InspireChargeUIEnded(p70, k)
		end
	end

	t3:lcl_StopChargeUISound(p70)

	for v162, v163 in p70.ConnectionDictionary do
		("CLIENT | Disconnected connection: %*"):format(v163)
		v163:Disconnect()
		p70.ConnectionDictionary[v162] = nil
	end

	local ok, result = pcall(p70.Maid.Destroy, p70.Maid)

	if not ok then
		("CLIENT | Maid cleanup errored: %*"):format(result)
	end

	for v166, v167 in p70.NetworkConnections do
		("CLIENT | Disconnected network connection: %*/%*"):format(v167[2], v167[1])
		Network:RemoveConnection(v167[1], v167[2])
		p70.NetworkConnections[v166] = nil
	end

	for _, v169 in p70.Instances do
		if typeof(v169) == "table" then
			for _, v171 in v169 do
				if v171 and v171.Parent then
					("CLIENT | Removed instance reference: %*"):format(v171)
					v171:Destroy()
				end
			end
		else
			v169:Destroy()
		end
	end
end


local originalCreated=t3.Created
local originalDestroyed=t3.Destroyed
function t3.Created(self,a)
 a.HelperClientDestroyed=false
 originalCreated(self,a)
 if a.Player==Players.LocalPlayer then
  local elapsed=0
  a.Maid:Add(RunService.Heartbeat:Connect(function(dt)
   elapsed+=dt
   if elapsed>=.2 then elapsed=0;Presentation.UpdateLevel(a) end
  end))
  Presentation.UpdateLevel(a)
 end
 a.Maid:Add(a.Rig:GetAttributeChangedSignal("PulseCharges"):Connect(function()
  if a.Player==Players.LocalPlayer then t3:lcl_OnChargeLevelChanged(a,a.Rig:GetAttribute("PulseCharges") or 0,"Pulse") end
 end))
end
function t3.Destroyed(self,a)
 if a.HelperClientDestroyed then return end
 a.HelperClientDestroyed=true
 for _,zone in pairs(a.State and a.State.ActiveZones or {}) do zone:Destroy() end
 originalDestroyed(self,a)
end
function t3.cl_PortCleanup(self,a) t3.Destroyed(self,a) end
local function animate(a,name)
 local track=a.Animations and a.Animations[name]
 if track then pcall(function() track:Play(.05) end) end
end
function t3.Pulse(a) animate(a,"Pulse") end
function t3.Inspiration(a) animate(a,"Inspire") end
local function survivorClient()
 local rig=Players.LocalPlayer.Character
 return rig and rig.Parent and rig.Parent.Name=="Survivors"
end
local function highlight(a,object,color,duration)
 if not object or not object.Parent then return end
 local h=Instance.new("Highlight");h.Name="HelperbotRadarHighlight";h.Adornee=object
 h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop;h.FillColor=color;h.OutlineColor=color
 h.FillTransparency=.6;h.OutlineTransparency=.1;h.Parent=object
 a.Maid:Add(h);game:GetService("Debris"):AddItem(h,duration or 3)
end
local function position(object)
 if object:IsA("Model") then return object:GetPivot().Position end
 if object:IsA("BasePart") then return object.Position end
 if object:IsA("Tool") then local handle=object:FindFirstChild("Handle");return handle and handle.Position end
end
function t3.cl_RadarScan(self,a)
 if not survivorClient() or not a.Rig.PrimaryPart then return end
 self:lcl_OnRadarUsed(a)
 local ingame=workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Ingame")
 if not ingame then return end
 local cfg=a.Config.Detection
 for _,object in ipairs(ingame:GetDescendants()) do
  local generator=object:IsA("Model") and object.Name=="Generator"
  local item=object:IsA("Tool") or object.Parent.Name=="Items" and (object:IsA("Model") or object:IsA("BasePart"))
  if generator or item then
   local progress=object:FindFirstChild("Progress")
   if not (generator and progress and progress:IsA("NumberValue") and progress.Value>=100) then
    local point=position(object)
    if point and (point-a.Rig.PrimaryPart.Position).Magnitude<=cfg.Radius then highlight(a,object,generator and cfg.GeneratorHighlightColor or cfg.ItemHighlightColor,3) end
   end
  end
 end
end
function t3.lcl_ShowSurvivorAura(_,a,rig)
 if a.Player~=Players.LocalPlayer or not survivorClient() then return end
 local hum=rig and rig:FindFirstChildOfClass("Humanoid")
 if hum and hum.Health>0 then highlight(a,rig,Color3.new(1,0,0):Lerp(Color3.new(0,1,0),math.clamp(hum.Health/hum.MaxHealth,0,1)),3) end
end
function t3.cl_OnPulseHit(_,a,rig)
 if not rig or not rig.PrimaryPart then return end
 local attachment=a.Config.Instances.VFXPulseHit:Clone();attachment.Parent=rig.PrimaryPart
 for _,effect in ipairs(attachment:GetChildren()) do if effect:IsA("ParticleEmitter") then effect:Emit(effect:GetAttribute("EmitCount") or 8) end end
 game:GetService("Debris"):AddItem(attachment,3)
end
local originalPulse=t3.cl_OnPulseEmitted
function t3.cl_OnPulseEmitted(self,a,radius,speed)
 originalPulse(self,a,radius,speed)
 local attachment=Presentation.Attach(a.Config.Instances.VFXPulse,a.Rig)
 for _,effect in ipairs(attachment:GetChildren()) do if effect:IsA("ParticleEmitter") then effect:Emit(effect:GetAttribute("EmitCount") or 8) end end
 game:GetService("Debris"):AddItem(attachment,3)
end
local originalZone=t3.cl_CreateZoneVisual
function t3.cl_CreateZoneVisual(self,a,id,radius)
 originalZone(self,a,id,radius)
 local zone=a.State.ActiveZones[id]
 if not zone then return end
 local attachment=Presentation.Attach(a.Config.Instances.VFXInspireActive,a.Rig)
 for _,effect in ipairs(attachment:GetChildren()) do if effect:IsA("ParticleEmitter") then effect.Enabled=true end end
 local destroy=zone.Destroy
 function zone.Destroy(object)
  if attachment.Parent then
   for _,effect in ipairs(attachment:GetChildren()) do if effect:IsA("ParticleEmitter") then effect.Enabled=false end end
   game:GetService("Debris"):AddItem(attachment,3)
  end
  destroy(object)
 end
end
return t3
]====],bytes=22393},
{path=[====[
Behavior/Rules]====],source=[====[
-- Corrected Helperbot moveset. Pure rules shared by the server and regression tests.
local Rules={}
function Rules.Level(charges) return math.clamp(math.floor(tonumber(charges) or 0),0,3) end
function Rules.Radius(charges) return ({30,33,36,39})[Rules.Level(charges)+1] end
function Rules.BuffDuration(charges,additionalHelpers,otherHelper)
 local duration=math.max(3,4+Rules.Level(charges)-1.5*math.max(0,additionalHelpers))
 return duration*(otherHelper and .5 or 1)
end
function Rules.Haste(additionalHelpers) return math.max(1,5-math.max(0,additionalHelpers)) end
function Rules.CooldownDelta(dt,level,support) return dt*.1*level*(support and .5 or 1) end
function Rules.Progress(progress,inside,dt) return math.clamp(progress+(inside and dt or -dt*.7),0,5) end
return Rules
]====],bytes=780},
{path=[====[
Behavior/Presentation]====],source=[====[
-- UPD emitter offsets belong to the robot's hat, not the HumanoidRootPart.
local Presentation={}
function Presentation.Attach(template,rig)
 local effect=template:Clone()
 local origin=rig:FindFirstChild("HelperbotVFXOrigin",true)
 if origin and origin:IsA("Attachment") and origin.Parent:IsA("BasePart") then
  effect.CFrame=origin.CFrame;effect.Parent=origin.Parent
 else
  local hat=rig:FindFirstChild("Hat",true)
  local head=rig:FindFirstChild("Head")
  -- Preserve the original attachment CFrame (including the 1.25-stud antenna offset).
  effect.Parent=hat and hat:IsA("BasePart") and hat or head or rig.PrimaryPart
 end
 return effect
end
function Presentation.UpdateLevel(actor)
 local gui=actor.Player and actor.Player:FindFirstChildOfClass("PlayerGui")
 local main=gui and gui:FindFirstChild("MainUI")
 local container=main and main:FindFirstChild("AbilityContainer")
 local ability=actor.Behavior and actor.Behavior.Abilities and actor.Behavior.Abilities.Pulse
 local icon=container and container:FindFirstChild("Pulse") or ability and ability.UIElement
 if not icon or not icon.Parent then return end
 if ability then ability.UIElement=icon end
 local label=icon:FindFirstChild("HelperbotPulseLevel")
 if not label then
  local native=icon:FindFirstChild("Charges")
  if native and native:IsA("TextLabel") then
   label=native:Clone()
   for _,child in ipairs(label:GetChildren()) do if child:IsA("GuiObject") then child:Destroy() end end
   -- This label replaces the native charge count; Pulse levels are not expendable ability uses.
   native.Visible=false
  else
   label=Instance.new("TextLabel")
   label.BackgroundTransparency=1;label.AnchorPoint=Vector2.new(.5,1)
   label.Position=UDim2.fromScale(.5,0);label.Size=UDim2.new(1,0,.3,0)
   label.Font=Enum.Font.SourceSansBold;label.TextScaled=true;label.TextStrokeTransparency=0
  end
  label.Name="HelperbotPulseLevel";label.Parent=icon
 end
 local level=math.clamp(actor.Rig:GetAttribute("PulseCharges") or actor.State and actor.State.ChargeLevel or 1,0,3)
 label.Text="Lv. "..level;label.TextColor3=Color3.new(1,1,1)
 label.TextTransparency=0;label.Visible=true;label.ZIndex=icon.ZIndex+2
 return label
end
return Presentation
]====],bytes=2200},
{path=[====[
Haste]====],source=[====[
local Cooldowns=require(script.CooldownStatus)
return {Data={Duration=15,MaxLevel=99,Stackable=false,Description="Ability cooldowns recover 10% faster per level. Effectiveness is halved for Support survivors."},Heartbeat=function(effect,dt) Cooldowns.Tick(effect,dt,-1) end}
]====],bytes=275},
{path=[====[
Haste/CooldownStatus]====],source=[====[
-- Server-only cooldown recovery adjustment; clients receive FCT's ordinary cooldown updates.
local RunService=game:GetService("RunService")
local Actors=require(game.ReplicatedStorage.Modules.Actors)
local Rules=require(game.ReplicatedStorage.Assets.Survivors.Helperbot.Behavior.Rules)
local Status={}
function Status.Tick(effect,dt,direction)
 if not RunService:IsServer() then return end
 local actor=Actors.CurrentActors[effect.Player]
 if not actor then for _,candidate in pairs(Actors.CurrentActors) do if candidate.Rig==effect.Character then actor=candidate;break end end end
 if not actor or not actor.Cooldowns or not actor.SetCooldownOf then return end
 local hum=actor.Rig and actor.Rig:FindFirstChildOfClass("Humanoid")
 if not hum or hum.Health<=0 then return end
 effect.HelperAccumulator=(effect.HelperAccumulator or 0)+dt
 if effect.HelperAccumulator<.1 then return end
 local elapsed=effect.HelperAccumulator;effect.HelperAccumulator=0
 local delta=Rules.CooldownDelta(elapsed,math.max(1,effect.Level or 1),direction<0 and actor.Config and actor.Config.Class=="Support")*direction
 for name,ability in pairs(actor.Behavior and actor.Behavior.Abilities or {}) do
  if (direction<0 or ability.KeybindType~="MainAbility") and not table.find(effect.Data.DisabledAbilityNames or {},name) then
   local remaining=actor:IsOnCooldown(name)
   if type(remaining)=="number" and remaining>0 then actor:SetCooldownOf(name,math.max(0,remaining+delta)) end
  end
 end
end
return Status
]====],bytes=1489},
{path=[====[
Fatigue]====],source=[====[
local Cooldowns=require(script.Parent.Haste.CooldownStatus)
return {Data={Duration=15,MaxLevel=99,Stackable=false,Description="Slows ability cooldown recovery by 10% per level."},Heartbeat=function(effect,dt) Cooldowns.Tick(effect,dt,1) end}
]====],bytes=242},
}
for _,plan in plans do assert(#plan.source==plan.bytes and #plan.source<200000,"Truncated source: "..plan.path..". Nothing changed.") end
local prepared=Instance.new("Folder");prepared.Name="Helperbot";prepared:SetAttribute("HelperbotPortVersion","1.0.0")
local haste=Instance.new("ModuleScript");haste.Name="Haste"
local fatigue=Instance.new("ModuleScript");fatigue.Name="Fatigue"
local ok,err=pcall(function()
 local rig=donor.Rig:Clone();rig.Name="Rig";rig.Parent=prepared
 rig.PrimaryPart=rig:FindFirstChild("HumanoidRootPart") or rig.PrimaryPart
 assert(rig.PrimaryPart,"Helperbot rig has no HumanoidRootPart")
 if rig:FindFirstChild("AnimSaves") then rig.AnimSaves:Destroy() end
 if not rig:FindFirstChildOfClass("Humanoid"):FindFirstChildOfClass("Animator") then Instance.new("Animator",rig:FindFirstChildOfClass("Humanoid")) end
 -- This is a character template: cloned active rigs are positioned/unanchored by FCT's actor system.
 local config=upd.Config:Clone();config.Name="Config";config.Parent=prepared
 for _,desc in rig:GetDescendants() do assert(not desc:IsA("LuaSourceContainer"),"Unexpected script in donor rig") end
 for _,plan in plans do
  local parts=string.split(plan.path,"/")
  local current=parts[1]=="Haste" and haste or parts[1]=="Fatigue" and fatigue or prepared
  local first=current==prepared and 1 or 2
  for i=first,#parts do
   local child=current:FindFirstChild(parts[i])
   if not child then child=Instance.new("ModuleScript");child.Name=parts[i];child.Parent=current end
   current=child
  end
  assert(current:IsA("ModuleScript"),"Invalid module target "..plan.path)
  current.Source=plan.source
 end
 -- Verify all references without requiring gameplay modules in Edit mode.
 for _,name in {"Pulse","PulseHit","InspireActive"} do assert(config.VFX:FindFirstChild(name),"Missing UPD effect "..name) end
 for _,item in config:GetDescendants() do if item:IsA("BasePart") then item.CanCollide=false;item.CanTouch=false;item.CanQuery=false end end
end)
if not ok then prepared:Destroy();haste:Destroy();fatigue:Destroy();error("[Helperbot Port] Preparation failed. Nothing changed: "..tostring(err)) end
local backup=Instance.new("Folder");backup.Name="HelperbotPort_Backup_"..os.date("!%Y%m%d_%H%M%S");backup:SetAttribute("HadHelperbot",old~=nil);backup.Parent=game:GetService("ServerStorage")
ok,err=pcall(function()
 if old then old.Parent=backup end
 prepared.Parent=survivors
 haste.Parent=statuses;fatigue.Parent=statuses
end)
if not ok then
 prepared:Destroy();haste:Destroy();fatigue:Destroy()
 if old then old.Parent=survivors end
 backup:Destroy();error("[Helperbot Port] Rolled back: "..tostring(err))
end
pcall(function()game:GetService("ChangeHistoryService"):SetWaypoint("Helperbot FCT Port")end)
print("[Helperbot Port] Installed Helperbot, Haste, and Fatigue. Backup: "..backup:GetFullName()..". Save, then start a fresh playtest.")
print("[Helperbot Port] You may delete the two imported Workspace folders after installation. Media permissions may need your own uploads; mechanics do not require animation playback.")
