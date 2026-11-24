assert(game:GetService("RunService"):IsStudio()and not game:GetService("RunService"):IsRunning(),"Stop Play first.")
local function find(path)
 local object=game
 for name in path:gmatch("[^/]+")do object=object and object:FindFirstChild(name)end
 return object
end
local function fingerprint(s)
 local a,b=5381,0
 for i=1,#s do local v=s:byte(i);a=(a*33+v)%4294967296;b=(b*65599+v)%4294967296 end
 return string.format("%d:%08x:%08x",#s,a,b)
end
local function ref(parent,name,value)local object=Instance.new("ObjectValue");object.Name=name;object.Value=value;object.Parent=parent end
local parent=assert(find("ReplicatedStorage/Assets/Survivors"))
local original=assert(parent:FindFirstChild("Builderman"),"Current Builderman missing")
if original:GetAttribute("BuildermanPortVersion")=="1.0.0"then print("[Builderman] Already installed.");return end
local storage=game:GetService("ServerStorage")
local donor=storage:FindFirstChild("BuildermanUPD")or workspace:FindFirstChild("BuildermanUPD")
assert(donor and donor:FindFirstChild("Config"),"Import BuildermanUPD.rbxm into ServerStorage first.")
assert(donor.Config:FindFirstChild("Dispenser")and donor.Config.Dispenser:FindFirstChildOfClass("Humanoid")and donor.Config.Dispenser:FindFirstChild("Root"),"Donor Dispenser is incomplete. Nothing changed.")
assert(donor.Config:FindFirstChild("Warning")and donor.Config:FindFirstChild("Highlight"),"Donor warning/highlight missing")
assert(original:FindFirstChild("Config")and original.Config:FindFirstChild("Sentry")and original.Config.Sentry:FindFirstChildOfClass("Humanoid")and original.Config.Sentry:FindFirstChild("Root"),"The donor Sentry is empty; a complete existing Sentry is required. Nothing changed.")
assert(original:FindFirstChild("Config")and fingerprint(original.Config.Source)==[========[
11517:9d6b9f12:f11399e7]========],"Current Builderman Config differs. Nothing changed; send its Source for a matching port.")
assert(original:FindFirstChild("Behavior")and fingerprint(original.Behavior.Source)==[========[
45971:731a5c33:e5819f90]========],"Current Builderman Behavior differs. Nothing changed; send its Source for a matching port.")
local prepared=original:Clone();prepared.Name="Builderman";prepared:SetAttribute("BuildermanPortVersion","1.0.0")
local config=donor.Config:Clone()
local empty=config:FindFirstChild("Sentry");if empty then empty:Destroy()end
local sentry=original.Config.Sentry:Clone();sentry.Parent=config
prepared.Config:Destroy();config.Parent=prepared
prepared.Behavior:Destroy()
local behavior=Instance.new("ModuleScript");behavior.Name="Behavior";behavior.Parent=prepared
local ok,err=pcall(function()
config.Source=[========[
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
 CarryPlacementDuration = 1.15,
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
]========]
behavior.Source=[========[
local RunService=game:GetService("RunService")
local Impl=require(RunService:IsServer()and script.Server or script.Client)
local Behavior={}
for name,method in Impl do Behavior[name]=method end
local icons={Sentry="104441527277654",Dispenser="102952736333903",Move="97983142047580"}
Behavior.Abilities={}
for order,kind in {"Sentry","Dispenser","Move"}do
 local ability={LayoutOrder=order,KeybindType="AltAbility"..order,Icon="rbxassetid://"..icons[kind],Callback=function(actor,result)return Impl.Use(actor,kind,result)end}
 if kind=="Move"then ability.Name="Carry";ability.SpecialName="Place";ability.SpecialIcon="rbxassetid://109402731902696"
 else ability.CurrentRecharge=0;ability.ChargeDuration=0;ability.RechargeInverted=true end
 Behavior.Abilities[kind]=ability
end
return Behavior
]========]
do local module=Instance.new("ModuleScript");module.Name="Server";module.Parent=behavior;module.Source=[========[
local RunService=game:GetService("RunService")
local Debris=game:GetService("Debris")
local Modules=game.ReplicatedStorage.Modules
local Actors=require(Modules.Actors)
local Util=require(Modules.Util)
local Statuses=require(Modules.Statuses)
local Sounds=require(Modules.Sounds)
local Network=require(Modules.Network)
local Rules=require(script.Parent.Rules)
local Server={}
local buildings={}
local function clock()return workspace:GetServerTimeNow()end
local function alive(rig)
 local hum=rig and rig:FindFirstChildOfClass("Humanoid")
 return rig and rig.Parent and rig.PrimaryPart and hum and hum.Health>0
end
local function active(a)return not a.BuilderDestroyed and alive(a.Rig)end
local function emit(a,name,...)
 if a.Player and a.Player:IsA("Player")then Network:FireClientConnection(a.Player,a.Player.Name..name,"REMOTE_EVENT",...)end
end
local function broadcast(a,name,...)
 if a.Player then Network:FireAllClientConnection(a.Player.Name..name,"REMOTE_EVENT",...)end
end
local function sound(a,key,part,loop)
 local id=a.Config.Sounds and a.Config.Sounds[key]
 if not id or id==""then return end
 local ok,result=pcall(Sounds.Play,Sounds,id,{Parent=part,Looped=loop or false})
 if ok then return result end
end
local function track(a,state,name)
 local id=a.Config[state.kind.."Animations"]and a.Config[state.kind.."Animations"][name]
 if not id then return end
 local ok,result=pcall(Util.LoadAnimationFromID,Util,state.model,id)
 if ok and result then pcall(function()result.Looped=name=="Idle"or name=="CarryIdle"or name=="CarryWalk";result:Play(.1)end);return result end
end
local function stopTrack(value)if value then pcall(function()value:Stop(.1)end)end end
local function killerDamage(rig)
 local stamp=rig:GetAttribute("RecentAttackerTime")
 if type(stamp)~="number"or math.abs(os.clock()-stamp)>.25 then return false end
 local name=rig:GetAttribute("RecentAttacker")
 for _,actor in Actors.CurrentActors do
  if actor.Rig and actor.Rig.Parent==workspace.Players.Killers and (tostring(actor.Player)==name or actor.Rig.Name==name)then return true end
 end
 return false
end
local function count(kind)
 local n=0
 for _,state in buildings do if state.kind==kind and state.phase=="active"and state.model.Parent then n+=1 end end
 return n
end
local function builders()
 local n=0
 for _,a in Actors.CurrentActors do if a.ActorName=="Builderman"and a.Rig.Parent==workspace.Players.Survivors and alive(a.Rig)then n+=1 end end
 return n
end
local function setState(state,phase)
 state.phase=phase
 local m=state.model
 m:SetAttribute("Carrying",phase=="carry")
 m:SetAttribute("Constructed",phase=="active"or phase=="carry")
 m:SetAttribute("Disabled",phase~="active")
 for _,object in m:GetDescendants()do
  if object:IsA("BasePart")then object.Anchored=object==m.PrimaryPart;object.CanCollide=phase=="active"and object:GetAttribute("BuilderOriginalCollide")==true
  elseif object:IsA("ParticleEmitter")or object:IsA("Light")then object.Enabled=phase=="active"and object.Name~="Shoot"end
 end
end
local function tools(a,show)
 for _,object in a.Rig:GetChildren()do if object:IsA("BasePart")and(object.Name:find("Hammer")or object.Name:find("Wrench"))then object.Transparency=show and 0 or 1 end end
end
local function result(a,value)
 local old=a.Rig:FindFirstChild("Result");if old then old:Destroy()end
 local object=Instance.new("StringValue");object.Name="Result";object.Value=value;object.Parent=a.Rig;Debris:AddItem(object,2)
end
local function unlockCast(a)
 if a.BuilderCastSpeed then a.BuilderCastSpeed:Destroy();a.BuilderCastSpeed=nil end
 a:DisableAbilities("BuildermanConstruct",false)
 a.Rig:SetAttribute("PlacementRadius",nil)
 tools(a,false)
 if active(a)and a.ChangeExpression then a:ChangeExpression("Default")end
end
local function clearCarry(a)
 a.CarryingBuilding=nil
 if a.BuilderCarrySpeed then a.BuilderCarrySpeed:Destroy();a.BuilderCarrySpeed=nil end
 if a.Rig then a.Rig:SetAttribute("BuildermanCarrying",nil)end
 emit(a,"ForceDropBuilding")
 if a.Player and a.Player:IsA("Player")then Network:FireClientConnection(a.Player,"DisableSprintingSV","REMOTE_EVENT","CarryingBuilding",false)end
end
local function destroy(a,state,killer)
 if not state or state.phase=="destroyed"then return end
 if a.BuilderCast==state then a.BuilderCast=nil;unlockCast(a);result(a,"failed")end
 if a.CarryingBuilding==state then clearCarry(a)end
 setState(state,"destroyed")
 state.model:SetAttribute("Destroyed",true)
 if state.health then state.health:Disconnect()end
 stopTrack(state.animation)
 if state.loop then state.loop:Destroy();state.loop=nil end
 buildings[state.model]=nil
 if a.Buildings[state.kind]==state then a.Buildings[state.kind]=nil end
 a.DisabledAbilities[state.kind]=nil
 emit(a,"UpdateBuildingAbilityLock",state.kind,"recentactivity",false)
 broadcast(a,"ReplicateDestroyedBuildingAsync",state.kind)
 if killer and active(a)then
  a:SetCooldownOf(state.kind,a.Config[state.kind.."DestroyedCooldown"])
  if a.Player and a.Player:IsA("Player")then
   Actors:IncrementActorStats(a.Player,{Action=state.kind.." was destroyed",RewardType="Survivalist"})
   local value=state.model:GetAttribute(state.kind=="Sentry"and "DamageDealt"or "TotalHealed")or 0
   local points=Rules.Points(state.kind,value)
   if points>0 then Actors:IncrementActorStats(a.Player,{Action=state.kind.." contribution",Money=points,EXP=math.ceil(points*.5)})end
  end
 end
 sound(a,state.kind.."Destroyed",state.model.PrimaryPart)
 for _,part in state.model:GetDescendants()do if part:IsA("BasePart")then part.CanCollide=false;part.CanQuery=false;part.Transparency=1 end end
 Debris:AddItem(state.model,2)
end
local function placement(a,kind,ignore)
 local root=a.Rig.PrimaryPart
 local target=root.CFrame*CFrame.new(0,0,-a.Config[kind.."PositionOffset"])
 local params=RaycastParams.new();params.FilterType=Enum.RaycastFilterType.Exclude;params.RespectCanCollide=true
 params.FilterDescendantsInstances={workspace.Players,ignore or a.Rig}
 local floor=workspace:Raycast(target.Position+Vector3.new(0,1,0),Vector3.new(0,-6,0),params)
 if not floor or floor.Normal.Y<.65 then return nil,"midair"end
 if floor.Instance.Name=="Conveyor"then return nil,"collision"end
 if workspace:Raycast(root.Position,target.Position-root.Position,params)then return nil,"facingWall"end
 for _,state in buildings do
  if state.model~=ignore and state.phase~="destroyed"and state.phase~="carry"and state.model.Parent then
   local radius=a.Config[state.kind.."PlacementRadius"]/2
   if(target.Position-state.model.PrimaryPart.Position).Magnitude<=radius then return nil,"tooClose"end
  end
 end
 local overlap=OverlapParams.new();overlap.FilterType=Enum.RaycastFilterType.Exclude;overlap.RespectCanCollide=true
 overlap.FilterDescendantsInstances={workspace.Players,ignore or a.Rig}
 for _,part in workspace:GetPartBoundsInBox(CFrame.new(target.Position.X,floor.Position.Y+1.75,target.Position.Z),Vector3.new(2.5,2.5,2.5),overlap)do
  if part~=floor.Instance and(part.Transparency<.9 or part.Name=="UnplacableArea")then return nil,"collision"end
 end
 return CFrame.new(target.Position.X,floor.Position.Y,target.Position.Z)*target.Rotation
end
local function groundPivot(model,cf)
 local root=model.PrimaryPart
 local lowest=math.huge
 for _,part in model:GetDescendants()do
  if part:IsA("BasePart")and part.Transparency<1 then
   local rel=root.CFrame:ToObjectSpace(part.CFrame)
   local half=part.Size*.5
   local extent=math.abs(rel.RightVector.Y)*half.X+math.abs(rel.UpVector.Y)*half.Y+math.abs(rel.LookVector.Y)*half.Z
   lowest=math.min(lowest,rel.Position.Y-extent)
  end
 end
 if lowest==math.huge then lowest=-root.Size.Y*.5 end
 model:PivotTo(cf*CFrame.new(0,-lowest+.03,0))
end
local function ready(a,state)
 if state.phase=="destroyed"or not active(a)then return end
 if a.BuilderCast==state then a.BuilderCast=nil;unlockCast(a);result(a,"success")end
 if state.loop then state.loop:Destroy();state.loop=nil end
 stopTrack(state.animation)
 setState(state,"active");state.activeAt=clock()
 state.animation=track(a,state,"Idle")
 state.loop=sound(a,state.kind.."Idle",state.model.PrimaryPart,true)
end
local function construct(a,kind)
 if not active(a)or a.BuilderCast or a.CarryingBuilding then return {Cancelled=true,Reason="carrying"}end
 local old=a.Buildings[kind]
 if old and Rules.ActivityRemaining(old.model:GetAttribute("LastActiveTime"),clock())>0 then return {Cancelled=true,Reason="recentActivity"}end
 if a:IsOnCooldown(kind)then return {Cancelled=true,Reason="cooldown"}end
 local cf,reason=placement(a,kind,old and old.model)
 if not cf then return {Cancelled=true,Reason=reason}end
 if old then destroy(a,old,false)end
 local model=(a.Config[kind.."Template"]or a.Config.Instances[kind.."Template"]):Clone()
 local hum=model:FindFirstChildOfClass("Humanoid")
 model.PrimaryPart=model:FindFirstChild("Root")or model.PrimaryPart
 if not hum or not model.PrimaryPart then model:Destroy();return {Cancelled=true,Reason="unknown"}end
 if not hum:FindFirstChildOfClass("Animator")then Instance.new("Animator",hum)end
 hum.MaxHealth=a.Config[kind.."Health"];hum.Health=hum.MaxHealth;hum.BreakJointsOnDeath=false
 model.Name="Builderman"..kind
 model:SetAttribute("OwnerName",tostring(a.Player));model:SetAttribute("Team","Survivors");model:SetAttribute("HitboxPriority",0)
 model:AddTag("SurvivorConstruct")
 for _,part in model:GetDescendants()do
  if part:IsA("BasePart")then part:SetAttribute("BuilderOriginalCollide",part.CanCollide);part.CanQuery=true end
 end
 groundPivot(model,cf)
 local state={model=model,kind=kind,phase="building",completeAt=clock()+a.Config[kind.."ConstructionDuration"]}
 a.Buildings[kind]=state;buildings[model]=state;a.BuilderCast=state
 setState(state,"building")
 model.Parent=workspace.Map.Ingame
 local previousHealth=hum.Health
 state.health=hum.HealthChanged:Connect(function(value)
  local hurt=value<previousHealth;previousHealth=value
  if value<=0 or hurt and state.phase=="building"then destroy(a,state,killerDamage(model))end
 end)
 local oldResult=a.Rig:FindFirstChild("Result");if oldResult then oldResult:Destroy()end
 a:DisableAbilities("BuildermanConstruct",true)
 a.BuilderCastSpeed=Util:CreateSpeedMultiplier(a.Rig,0,"BuildermanConstruction")
 a.Rig:SetAttribute("PlacementRadius",a.Config[kind.."PlacementRadius"])
 tools(a,true)
 if a.ChangeExpression then a:ChangeExpression("Concentrating")end
 state.animation=track(a,state,"Construction")
 state.loop=sound(a,kind.."Building",model.PrimaryPart,true)
 broadcast(a,"ReplicateBuildingAsync",model,kind)
 for _,other in Actors.CurrentActors do
  if other.Player and other.Player:IsA("Player")and alive(other.Rig)and other.Rig.Parent==workspace.Players.Survivors then
   pcall(Util.RevealPlayerAuraTo,Util,other.Player,model,a.Config[kind.."PingDuration"],Color3.new(.75,1,.75))
  end
 end
 return {Duration=a.Config[kind.."ConstructionDuration"]}
end
local function closest(a)
 local best,range=nil,a.Config.CarryRange
 for _,state in a.Buildings do
  if state.phase=="active"and state.model.Parent then
   local distance=(state.model.PrimaryPart.Position-a.Rig.PrimaryPart.Position).Magnitude
   if distance<=range then best=state;range=distance end
  end
 end
 return best
end
local function move(a)
 if not active(a)or a.BuilderCast then return "noBuilding"end
 if a.MoveReadyAt and clock()<a.MoveReadyAt then return "cooldown"end
 local state=a.CarryingBuilding
 if state then
  local cf,reason=placement(a,state.kind,state.model)
  if not cf then return reason end
  clearCarry(a)
  groundPivot(state.model,cf)
  setState(state,"placing");state.completeAt=clock()+a.Config.CarryPlacementDuration
  stopTrack(state.animation);state.animation=track(a,state,"PutDown")
  sound(a,state.kind.."Putdown",state.model.PrimaryPart)
  a.MoveReadyAt=clock()+a.Config.CarryPlacementDuration
  a:SetCooldownOf("Move",a.Config.CarryPlacementDuration)
  return false
 end
 state=closest(a)
 if not state then return "noBuilding"end
 a.CarryingBuilding=state
 setState(state,"carry")
 if state.loop then state.loop:Destroy();state.loop=nil end
 stopTrack(state.animation);state.animation=track(a,state,"PickUp");state.carryAnimReady=clock()+a.Config[state.kind.."PickupDebounce"];state.walking=nil
 a.BuilderCarrySpeed=Util:CreateSpeedMultiplier(a.Rig,a.Config.CarryWalkspeed,"CarryingBuilding")
 a.Rig:SetAttribute("BuildermanCarrying",true)
 if a.Player and a.Player:IsA("Player")then Network:FireClientConnection(a.Player,"DisableSprintingSV","REMOTE_EVENT","CarryingBuilding",true)end
 state.model:PivotTo(a.Rig.PrimaryPart.CFrame*a.Config[state.kind.."PickupOffset"])
 a.MoveReadyAt=clock()+a.Config[state.kind.."PickupDebounce"]
 a:SetCooldownOf("Move",a.Config[state.kind.."PickupDebounce"])
 sound(a,state.kind.."Pickup",state.model.PrimaryPart)
 return state.model
end
local function lineOfSight(state,target)
 local params=RaycastParams.new();params.FilterType=Enum.RaycastFilterType.Exclude
 local excluded={workspace.Players.Survivors}
 for _,entry in buildings do table.insert(excluded,entry.model)end
 params.FilterDescendantsInstances=excluded
 local origin=state.model.PrimaryPart.Position
 local hit=workspace:Raycast(origin,target.PrimaryPart.Position-origin,params)
 return not hit or hit.Instance:IsDescendantOf(target)
end
local function tickBuilding(a,state,dt)
 if state.phase=="destroyed"then return end
 if not state.model.Parent then destroy(a,state,false);return end
 if state.phase=="building"or state.phase=="placing"then
  if clock()>=state.completeAt then ready(a,state)end
  return
 end
 if state.phase=="carry"then
  state.model:PivotTo(a.Rig.PrimaryPart.CFrame*a.Config[state.kind.."PickupOffset"])
  if clock()>=(state.carryAnimReady or 0)then
   local walking=a.Rig.PrimaryPart.AssemblyLinearVelocity.Magnitude>1
   if state.walking~=walking then
    state.walking=walking;stopTrack(state.animation);state.animation=track(a,state,walking and "CarryWalk"or "CarryIdle")
   end
  end
  return
 end
 dt=math.min(dt,math.max(0,clock()-(state.activeAt or clock())))
 if dt<=0 then return end
 local n=count(state.kind)
 state.model:SetAttribute("BuildingCount",n)
 local radius=Rules.EffectRadius(a.Config,state.kind,n)
 state.model:SetAttribute("EffectRadiusSize",radius)
 if state.kind=="Sentry"then
  local nearest,distance=nil,radius
  for _,other in Actors.CurrentActors do
   if alive(other.Rig)and other.Rig.Parent==workspace.Players.Killers then
    local d=(other.Rig.PrimaryPart.Position-state.model.PrimaryPart.Position).Magnitude
    if d<=distance and lineOfSight(state,other.Rig)then nearest=other;distance=d end
   end
  end
  if nearest then
   local hum=nearest.Rig:FindFirstChildOfClass("Humanoid")
   local damage=math.min(hum.Health,a.Config.SentryDamagePerSec*dt)
   hum.Health-=damage
   if damage>0 then
    state.model:SetAttribute("DamageDealt",(state.model:GetAttribute("DamageDealt")or 0)+damage)
    state.model:SetAttribute("LastActiveTime",clock())
    Statuses:ApplyStatus(nearest.Rig,"Slowness",{Level=Rules.SlowLevel(a.Config,builders()),Duration=a.Config.SentrySlownessDuration})
    if not state.nextShotSound or clock()>=state.nextShotSound then sound(a,"SentryShoot",state.model.PrimaryPart);state.nextShotSound=clock()+.2 end
   end
  end
 else
  for _,other in Actors.CurrentActors do
   if alive(other.Rig)and other.Rig.Parent==workspace.Players.Survivors and(other.Rig.PrimaryPart.Position-state.model.PrimaryPart.Position).Magnitude<=radius then
    local hum=other.Rig:FindFirstChildOfClass("Humanoid")
    if hum.Health<hum.MaxHealth and not hum:GetAttribute("Clanker")then
     local before=hum.Health;Util:Heal(hum,a.Config.DispenserHealingPerSec*dt)
     local healed=math.max(0,hum.Health-before)
     if healed>0 then state.model:SetAttribute("TotalHealed",(state.model:GetAttribute("TotalHealed")or 0)+healed);state.model:SetAttribute("LastActiveTime",clock())end
    end
   end
  end
 end
end
function Server.Created(_,a)
 a.BuilderDestroyed=false;a.Buildings={};a.DisabledAbilities=a.DisabledAbilities or {};a.BuilderConnections={}
 a.Rig:SetAttribute("IsBuilderman",true)
 local hum=a.Rig:FindFirstChildOfClass("Humanoid");local health=hum.Health
 table.insert(a.BuilderConnections,hum.HealthChanged:Connect(function(value)
  local damage=health-value;health=value
  if a.BuilderCast and damage>0 then destroy(a,a.BuilderCast,false)end
  if a.CarryingBuilding and damage>=a.Config.CarryDamageThreshold then destroy(a,a.CarryingBuilding,killerDamage(a.Rig))end
  if value<=0 then Server.Destroyed(nil,a)end
 end))
 local accumulator=0
 table.insert(a.BuilderConnections,RunService.Heartbeat:Connect(function(dt)
  if not active(a)then Server.Destroyed(nil,a);return end
  for _,state in table.clone(a.Buildings)do
   if (state.phase=="building"or state.phase=="placing")and clock()>=state.completeAt then ready(a,state)end
  end
  accumulator+=dt;if accumulator<.1 then return end
  local elapsed=accumulator;accumulator=0
  for _,state in table.clone(a.Buildings)do tickBuilding(a,state,elapsed)end
  for _,kind in {"Sentry","Dispenser"}do
   local state=a.Buildings[kind]
   local locked=state and Rules.ActivityRemaining(state.model:GetAttribute("LastActiveTime"),clock())>0 or false
   if a.DisabledAbilities[kind]~=locked then a.DisabledAbilities[kind]=locked;emit(a,"UpdateBuildingAbilityLock",kind,"recentactivity",locked)end
  end
  local selected=a.CarryingBuilding or closest(a)
  if a.BuilderClosest~=selected then a.BuilderClosest=selected;emit(a,"UpdateClosestBuilding",selected and selected.model or nil)end
  if a.CarryingBuilding then local canPlace=placement(a,a.CarryingBuilding.kind,a.CarryingBuilding.model)~=nil;emit(a,"UpdateCanPlace",canPlace)end
 end))
end
function Server.Use(a,kind)
 if kind=="Move"then return move(a)end
 local response=construct(a,kind)
 if response and response.Cancelled then emit(a,"ConstructionRejected",response.Reason)end
 return response
end
function Server.Destroyed(_,a)
 if a.BuilderDestroyed then return end
 a.BuilderDestroyed=true
 for _,connection in a.BuilderConnections or {}do connection:Disconnect()end
 for _,state in table.clone(a.Buildings or {})do destroy(a,state,false)end
 clearCarry(a);unlockCast(a)
 a.DisabledAbilities.Sentry=nil;a.DisabledAbilities.Dispenser=nil
end
return Server
]========] end
do local module=Instance.new("ModuleScript");module.Name="Client";module.Parent=behavior;module.Source=[========[


local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")

game:GetService("Players")

local t1 = {}

require(game.ReplicatedStorage.Modules.AchievementUtil)
require(game.ReplicatedStorage.Modules.Sounds)

local Util = require(game.ReplicatedStorage.Modules.Util)

require(game.ReplicatedStorage.Modules.Hitboxes)
require(game.ReplicatedStorage.Modules.Statuses)

local Network = require(game.ReplicatedStorage.Modules.Network)
local trove = require(game.ReplicatedStorage.Modules.Misc.Trove)
local Spring = require(game.ReplicatedStorage.Modules.Misc.Spring)
local u8 = false
local t2 = {
 carrying="Place your carried building before constructing another.",
	collision = "Building area is obstructed by something. Build somewhere else.",
	tooClose = "Building area is too close to a pre-existing building. Move further away and try again.",
	midair = "Building area is too high above ground. Turn around and try again.",
	facingWall = "You're too close to a wall. Turn around and try again.",
	recentActivity = "That building is active. Wait a moment before replacing it.",
	cooldown = "That building is recharging. Try again in a moment.",
	unknown = "Something went wrong. Try building somewhere else.",
	noBuilding = "Stand near one of your buildings to pick it up!"
}

local function getServerTime() -- line: 37
	return workspace:GetServerTimeNow()
end
local function getBuildingRecentActivityRemaining(p1) -- line: 60
	if not p1 or p1:GetAttribute("Destroyed") then
		return 0
	end

	local LastActiveTime = p1:GetAttribute("LastActiveTime")

	if typeof(LastActiveTime) ~= "number" then
		return 0
	end

	return (math.max(0, 10 - (workspace:GetServerTimeNow() - LastActiveTime)))
end
local function setBuildingAbilityLock(p2, s1: string, s2: string, b1: boolean, _: number?) -- line: 119
	-- upvalues: Util (copy)
	if p2.Player == game.Players.LocalPlayer then
		Util:ToggleLockForAbilityIcon(s1, s2, b1)
	end
end
local function initClientSentryAiming(p3) -- line: 153
	-- upvalues: u8 (ref), trove (copy), Spring (copy), CollectionService (copy), Util (copy), RunService (copy)
	if u8 then
		return
	end

	u8 = true

	local function setupSentry(p4) -- line: 164
		-- upvalues: trove (copy), Spring (copy), CollectionService (copy), p3 (copy), Util (copy), RunService (copy)
		if not p4.Name:find("Sentry") then
			return
		end

		local v106 = trove.new()
		local raycastParams = RaycastParams.new()

		raycastParams.FilterType = Enum.RaycastFilterType.Exclude

		local Torso = p4:WaitForChild("Torso", 10)
		local Head = p4:WaitForChild("Head", 10)

		if not Torso or not Head then
			return
		end

		local Neck = Torso:WaitForChild("Neck", 10)

		if not Neck then
			return
		end

		local NeckC0 = Neck.C0
		local u112 = Spring.new(NeckC0, 0.25)

		v106:Add(task.spawn(function() -- line: 189
			-- upvalues: p4 (copy), CollectionService (copy), raycastParams (copy), p3 (copy), Util (copy), Head (copy), Torso (copy), u112 (ref), NeckC0 (ref)
			while p4.Parent do
				if p4:GetAttribute("Destroyed") or not p4.PrimaryPart then
					task.wait(0.2)

					continue
				end

				if not p4:GetAttribute("Constructed") then
					task.wait(0.2)

					continue
				end

				if p4:GetAttribute("Disabled") and not p4:GetAttribute("Carrying") then
					task.wait(0.2)

					continue
				end

				local t3 = {
					p4,
					workspace.Players.Survivors
				}

				for _, v179 in CollectionService:GetTagged("SurvivorConstruct") do
					table.insert(t3, v179)
				end

				raycastParams.FilterDescendantsInstances = t3

				local v180 = (p4:GetAttribute("BuildingCount") or 1) - 1
				local v181 = p3.Config.SentryDamageRadius / 2
				local v182 = math.clamp(v181 * (1 - v180 * p3.Config.SentryRangeReductionPercentage / 100), p3.Config.SentryMinimumRange, v181)
				local ClosestPlayerFromPosition = Util:GetClosestPlayerFromPosition(p4.PrimaryPart.Position, {
					PlayerSelection = "Killers",
					MaxDistance = v182
				})

				if ClosestPlayerFromPosition and ClosestPlayerFromPosition.PrimaryPart and ClosestPlayerFromPosition.Humanoid.Health > 0 then
					local PrimaryPartPosition = p4.PrimaryPart.Position
					local LookVector = CFrame.lookAt(PrimaryPartPosition, ClosestPlayerFromPosition.PrimaryPart.Position).LookVector
					local raycastResult = workspace:Raycast(PrimaryPartPosition, LookVector * v182, raycastParams)

					if not raycastResult or not raycastResult.Instance:IsDescendantOf(ClosestPlayerFromPosition) then
						task.wait(0.2)

						continue
					end

					local function worldCFrameToC0ObjectSpace(p5, p6) -- line: 231
						local Part1CFrame = p5.Part1.CFrame
						local p5C1 = p5.C1
						local p5C0 = p5.C0
						local v213 = p5C0 * p5C1:Inverse() * Part1CFrame:Inverse() * p6 * p5C1

						return v213 - v213.Position + p5C0.Position
					end

					local cFrame = CFrame.lookAt(Head.Position, ClosestPlayerFromPosition.PrimaryPart.Position, Torso.CFrame.UpVector)
					local Neck2 = Torso.Neck
					local Part1CFrame = Neck2.Part1.CFrame
					local Neck2C1 = Neck2.C1
					local Neck2C0 = Neck2.C0
					local v193 = Neck2C0 * Neck2C1:Inverse() * Part1CFrame:Inverse() * cFrame * Neck2C1

					u112.Target = (v193 - v193.Position + Neck2C0.Position) * CFrame.Angles(-1.5707963267948966, 0, 0)

					if not p4:GetAttribute("Carrying") then
						for _, descendant in pairs(p4:GetDescendants()) do
							if (descendant:IsA("ParticleEmitter") or descendant:IsA("Light")) and descendant.Name == "Shoot" then
								task.spawn(function() -- line: 253
									-- upvalues: descendant (copy)
									descendant.Enabled = true
									task.wait(0.05)
									descendant.Enabled = false
								end)
							end
						end
					end
				else
					u112.Target = NeckC0
				end

				task.wait(0.2)
			end
		end))
		v106:Connect(RunService.RenderStepped, function(n2: number) -- line: 269
			-- upvalues: Neck (copy), u112 (ref)
			if Neck.Parent then
				Neck.C0 = u112:Update(n2)
			end
		end)
		p4.AncestryChanged:Connect(function(_, parent) -- line: 275
			-- upvalues: v106 (copy)
			if not parent then
				v106:Destroy()
			end
		end)
	end

	for _, v31 in CollectionService:GetTagged("SurvivorConstruct") do
		task.spawn(setupSentry, v31)
	end

	CollectionService:GetInstanceAddedSignal("SurvivorConstruct"):Connect(setupSentry)
end
local function cl_tweenCarryFOV(p8, b2: boolean) -- line: 678
	-- upvalues: Util (copy)
	if not p8.Rig then
		return
	end

	if p8.CarryFOVTween then
		p8.CarryFOVTween:Cancel()
		p8.CarryFOVTween = nil
	end

	if not p8.CarryFOVMultiplier or not p8.CarryFOVMultiplier.Parent then
		p8.CarryFOVMultiplier = Util:CreateFOVMultiplier(p8.Rig, 1, "BuildermanCarryFOV")
	end

	local v34 = game.TweenService:Create(p8.CarryFOVMultiplier, TweenInfo.new(p8.Config.CarryFOVTweenTime or 2.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
		Value = not b2 and 1 or (p8.Config.CarryFOVMultiplier or 1.1)
	})

	p8.CarryFOVTween = v34
	v34.Completed:Connect(function() -- line: 699
		-- upvalues: p8 (copy), v34 (copy), b2 (copy)
		if p8.CarryFOVTween == v34 then
			p8.CarryFOVTween = nil

			if not b2 then
				if p8.CarryFOVMultiplier and p8.CarryFOVMultiplier.Parent then
					p8.CarryFOVMultiplier:Destroy()
				end

				p8.CarryFOVMultiplier = nil
			end
		end
	end)
	v34:Play()
end
local function cl_dropBuilding(p9) -- line: 714
	-- upvalues: t1 (copy), cl_tweenCarryFOV (copy), Util (copy)
	local Move = t1.Abilities.Move
	local v37 = p9.Behavior and (p9.Behavior.Abilities and p9.Behavior.Abilities.Move)

	if v37 and Move then
		v37.Icon = Move.Icon
		v37.Name = Move.Name
	end

	p9.CarryingBuilding = nil
	cl_tweenCarryFOV(p9, false)
	
	Util:ToggleLockForAbilityIcon("Move", "invalidplacement", false)
end
local function safeAnimation(actor,name,playing)
 local track=actor.Animations and actor.Animations[name]
 if track then pcall(function()if playing then track:Play(.1)else track:Stop(.1)end end)end
end
local function constructBuildingOnClient(actor,kind,response)
 if type(response)=="table"and response.Cancelled then
  Util:CreateWarning("BuildermanWarning",t2[response.Reason]or t2.unknown,actor.Config.Instances.WarningTemplate)
  return
 end
 local duration=type(response)=="table"and response.Duration or actor.Config[kind.."ConstructionDuration"]
 local progress=Util:CreateProgressBar("Building "..kind,duration)
 local token={}
 actor.BuilderConstructionVisual=token
 safeAnimation(actor,"ConstructStart",true)
 task.delay(.75,function()
  if actor.BuilderConstructionVisual==token then safeAnimation(actor,"ConstructStart",false);safeAnimation(actor,"ConstructLoop",true)end
 end)
 local deadline=os.clock()+duration+1
 task.spawn(function()
  while actor.Rig.Parent and os.clock()<deadline and actor.BuilderConstructionVisual==token do
   if actor.Rig:FindFirstChild("Result")then break end
   task.wait(.05)
  end
  progress:Destroy()
  if actor.BuilderConstructionVisual==token then
   actor.BuilderConstructionVisual=nil
   safeAnimation(actor,"ConstructStart",false);safeAnimation(actor,"ConstructLoop",false)
   if actor.Rig.Parent then safeAnimation(actor,"ConstructEnd",true)end
  end
 end)
end
local function cl_setBuildingPlacedText(p13, s3: string, b3: boolean) -- line: 1020
	if p13.Player ~= game.Players.LocalPlayer then
		return
	end

	local AbilityContainer = p13.Player.PlayerGui.MainUI:FindFirstChild("AbilityContainer")
	local v50 = AbilityContainer and AbilityContainer:FindFirstChild(s3)

	if not v50 then
		return
	end

	v50.Charges.Text = not b3 and "" or "PLACED"
end
local function cl_watchBuildingActivityLock(p14, p15, s4: string) -- line: 1029
	-- upvalues: Util (copy)
	p14.BuildingActivityLockTokens = p14.BuildingActivityLockTokens or {}

	local t4 = {}

	p14.BuildingActivityLockTokens[s4] = t4

	local t5 = {}

	local function cleanup() -- line: 1036
		-- upvalues: t5 (copy)
		for _, v in pairs(t5) do
			v:Disconnect()
		end

		table.clear(t5)
	end
	local function refresh() -- line: 1043
		-- upvalues: p14 (copy), s4 (copy), t4 (copy), t5 (copy), p15 (copy), Util (copy), refresh (copy)
		if p14.BuildingActivityLockTokens[s4] ~= t4 then
			for _, v in pairs(t5) do
				v:Disconnect()
			end

			table.clear(t5)

			return
		end

		local v117 = p15
		local n3

		if not v117 or v117:GetAttribute("Destroyed") then
			n3 = 0
		else
			local LastActiveTime = v117:GetAttribute("LastActiveTime")

			n3 = if typeof(LastActiveTime) == "number" then math.max(0, 10 - (workspace:GetServerTimeNow() - LastActiveTime)) else 0
		end

		local v120 = n3 > 0
		local v121 = p14
		local v122 = s4

		if v121.Player == game.Players.LocalPlayer then
			Util:ToggleLockForAbilityIcon(v122, "recentactivity", v120)
		end

		if v120 then
			task.delay(n3 + 0.05, refresh)
		end
	end

	table.insert(t5, p15:GetAttributeChangedSignal("LastActiveTime"):Connect(refresh))
	table.insert(t5, p15:GetAttributeChangedSignal("Destroyed"):Connect(refresh))
	table.insert(t5, p15.AncestryChanged:Connect(function(_, parent) -- line: 1060
		-- upvalues: p14 (copy), s4 (copy), t4 (copy), Util (copy), t5 (copy)
		if parent then
			return
		end

		if p14.BuildingActivityLockTokens[s4] == t4 then
			p14.BuildingActivityLockTokens[s4] = nil

			local v125 = p14
			local v126 = s4

			if v125.Player == game.Players.LocalPlayer then
				Util:ToggleLockForAbilityIcon(v126, "recentactivity", false)
			end

			local v127 = p14
			local v128 = s4

			if v127.Player == game.Players.LocalPlayer then
				local AbilityContainer = v127.Player.PlayerGui.MainUI:FindFirstChild("AbilityContainer")
				local v130 = AbilityContainer and AbilityContainer:FindFirstChild(v128)

				if v130 then
					v130.Charges.Text = ""
				end
			end
		end

		for _, v in pairs(t5) do
			v:Disconnect()
		end

		table.clear(t5)
	end))

	if t4 ~= p14.BuildingActivityLockTokens[s4] then
		for _, v in pairs(t5) do
			v:Disconnect()
		end

		table.clear(t5)

		return
	end

	local n4

	if not p15 or p15:GetAttribute("Destroyed") then
		n4 = 0
	else
		local LastActiveTime = p15:GetAttribute("LastActiveTime")

		n4 = if typeof(LastActiveTime) == "number" then math.max(0, 10 - (workspace:GetServerTimeNow() - LastActiveTime)) else 0
	end

	local v62 = n4 > 0

	if p14.Player == game.Players.LocalPlayer then
		Util:ToggleLockForAbilityIcon(s4, "recentactivity", v62)
	end

	if v62 then
		task.delay(n4 + 0.05, refresh)
	end
end
local function cl_updateBuildingActivityBars(p17) -- line: 1077
	local v64 = p17.Behavior and p17.Behavior.Abilities

	if not v64 then
		return
	end

	for _, v in ipairs({
		"Sentry",
		"Dispenser"
	}) do
		local v67 = v64[v]

		if v67 then
			local v68 = p17.Buildings and p17.Buildings[v]
			local n5

			if not v68 or v68:GetAttribute("Destroyed") then
				n5 = 0
			else
				local LastActiveTime = v68:GetAttribute("LastActiveTime")

				n5 = if typeof(LastActiveTime) == "number" then math.max(0, 10 - (workspace:GetServerTimeNow() - LastActiveTime)) else 0
			end

			if n5 > 0 then
				v67.CurrentRecharge = 10 - n5
				v67.ChargeDuration = 10
			else
				v67.CurrentRecharge = 0
				v67.ChargeDuration = 0
			end
		end
	end
end
local function updateBuildingCarryVisual(p18) -- line: 1101
	local PlayerAura = p18:FindFirstChild("PlayerAura")

	if not PlayerAura then
		return
	end

	if p18:GetAttribute("Carrying") then
		PlayerAura.FillColor = Color3.fromRGB(153, 134, 48)
		PlayerAura.OutlineColor = Color3.fromRGB(255, 220, 50)

		if p18:GetAttribute("OwnerName") == tostring(game.Players.LocalPlayer) then
			PlayerAura.Enabled = false

			return
		end
	else
		PlayerAura.Enabled = true
		PlayerAura.FillColor = Color3.fromRGB(102, 134, 102)
		PlayerAura.OutlineColor = Color3.fromRGB(191, 255, 191)
	end
end

t1.Abilities = {
	Sentry = {
		LayoutOrder = 1,
		KeybindType = "AltAbility1",
		Icon = "rbxassetid://104441527277654",
		CurrentRecharge = 0,
		ChargeDuration = 0,
		RechargeInverted = true,
		Callback = function(p19, p20) -- line: 1129
			-- upvalues: constructBuildingOnClient (copy)
			constructBuildingOnClient(p19, "Sentry", p20)
		end
	},
	Dispenser = {
		LayoutOrder = 2,
		KeybindType = "AltAbility2",
		Icon = "rbxassetid://102952736333903",
		CurrentRecharge = 0,
		ChargeDuration = 0,
		RechargeInverted = true,
		Callback = function(p21, p22) -- line: 1260
			-- upvalues: constructBuildingOnClient (copy)
			constructBuildingOnClient(p21, "Dispenser", p22)
		end
	},
	Move = {
		LayoutOrder = 3,
		KeybindType = "AltAbility3",
		Icon = "rbxassetid://97983142047580",
		Name = "Carry",
		SpecialName = "Place",
		SpecialIcon = "rbxassetid://109402731902696",
		Callback = function(p23, p24) -- line: 1353
			-- upvalues: t2 (copy), Util (copy), t1 (copy), cl_tweenCarryFOV (copy), Network (copy), cl_dropBuilding (copy)
			if typeof(p24) == "string" then
				local v79 = t2[p24] or "Something went wrong. Try building somewhere else."

				Util:CreateWarning("BuildermanWarning", v79, p23.Config.Instances.WarningTemplate)

				return
			end

			if typeof(p24) == "Instance" then
				if p23.CarryableBuildingHighlight then
					p23.CarryableBuildingHighlight.Adornee = nil
				end

				p23.CarryingBuilding = p24

				local Move = t1.Abilities.Move
				local v81 = p23.Behavior and (p23.Behavior.Abilities and p23.Behavior.Abilities.Move)

				if v81 and Move then
					v81.Icon = Move.SpecialIcon
					v81.Name = Move.SpecialName
				end

				cl_tweenCarryFOV(p23, true)
				
				p23.AnimationType = "Pick"
				Network:FireConnection("DisableSprinting", "CarryingBuilding", true)

                safeAnimation(p23,"PickUp",true)

			else
				p23.AnimationType = nil
				Network:FireConnection("DisableSprinting", "CarryingBuilding", false)

                safeAnimation(p23,"PutDown",true)

				cl_dropBuilding(p23)
			end
		end
	}
}

function t1.Created(_, p26) -- line: 1527
	-- upvalues: trove (copy), updateBuildingCarryVisual (copy), Network (copy), Util (copy), cl_dropBuilding (copy), initClientSentryAiming (copy), cl_watchBuildingActivityLock (copy), RunService (copy), cl_updateBuildingActivityBars (copy), cl_tweenCarryFOV (copy)
	p26.CarryingBuilding = nil
	p26.CarryableBuilding = nil

	if p26.Rig then
		p26.Rig:SetAttribute("IsBuilderman", true)
	end

	if p26.Rig == game.Players.LocalPlayer.Character then
		p26.RadiusStorages = {}
		p26.CarryableBuildingHighlight = Instance.new("SelectionBox")
		p26.CarryableBuildingHighlight.Color3 = Color3.fromRGB(255, 220, 50)
		p26.CarryableBuildingHighlight.LineThickness = 0.05
		p26.CarryableBuildingHighlight.SurfaceTransparency = 0.8
		p26.CarryableBuildingHighlight.Parent = script

		local function createRadiusStorage(p27, p28) -- line: 1590
			-- upvalues: p26 (copy)
			local Model = Instance.new("Model")

			Model.Parent = workspace.Map.Ingame
			Model.Name = p27
			p26.RadiusStorages[p27] = Model

			local Highlight = Instance.new("Highlight")

			Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
			Highlight.FillTransparency = 0.875
			Highlight.OutlineTransparency = 0.6
			Highlight.FillColor = p28
			Highlight.Parent = Model
		end

		local color3 = Color3.fromRGB(70, 155, 255)
		local Model = Instance.new("Model")

		Model.Parent = workspace.Map.Ingame
		Model.Name = "PlacementRange"
		p26.RadiusStorages.PlacementRange = Model

		local Highlight = Instance.new("Highlight")

		Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
		Highlight.FillTransparency = 0.875
		Highlight.OutlineTransparency = 0.6
		Highlight.FillColor = color3
		Highlight.Parent = Model

		local color3_2 = Color3.fromRGB(255, 80, 80)
		local Model2 = Instance.new("Model")

		Model2.Parent = workspace.Map.Ingame
		Model2.Name = "BuildermanSentryEffectRange"
		p26.RadiusStorages.BuildermanSentryEffectRange = Model2

		local Highlight2 = Instance.new("Highlight")

		Highlight2.DepthMode = Enum.HighlightDepthMode.Occluded
		Highlight2.FillTransparency = 0.875
		Highlight2.OutlineTransparency = 0.6
		Highlight2.FillColor = color3_2
		Highlight2.Parent = Model2

		local color3_3 = Color3.fromRGB(80, 255, 80)
		local Model3 = Instance.new("Model")

		Model3.Parent = workspace.Map.Ingame
		Model3.Name = "BuildermanDispenserEffectRange"
		p26.RadiusStorages.BuildermanDispenserEffectRange = Model3

		local Highlight3 = Instance.new("Highlight")

		Highlight3.DepthMode = Enum.HighlightDepthMode.Occluded
		Highlight3.FillTransparency = 0.875
		Highlight3.OutlineTransparency = 0.6
		Highlight3.FillColor = color3_3
		Highlight3.Parent = Model3

		local function createRadius(p29, p30) -- line: 1608
			-- upvalues: p26 (copy)
			local v139 = p26.RadiusStorages[p29]

			if not v139 then
				return
			end

			if not p30 then
				return
			end

			local Part = Instance.new("Part")

			Part.CanCollide = false
			Part.Anchored = true
			Part.Transparency = 1
			Part.Position = Vector3.new(0, -100, 0)
			Part.Orientation = Vector3.new(0, 0, 90)
			Part.Size = Vector3.new(0.25, p30, p30)
			Part.Material = Enum.Material.Glass
			Part.Shape = Enum.PartType.Cylinder
			Part.Parent = v139

			return Part
		end

		p26.BuildingVisualTroves = p26.BuildingVisualTroves or {}
		p26.Connection = workspace.Map.Ingame.ChildAdded:Connect(function(child) -- line: 1626
			-- upvalues: p26 (copy), trove (copy), updateBuildingCarryVisual (copy), createRadius (copy)
			if child.Name:find("Builderman") then
				local Humanoid = child:WaitForChild("Humanoid", 10)

				if not Humanoid then
					return
				end

				local Root = child:WaitForChild("Root", 10)

				if not Root then
					return
				end

				child:SetAttribute("ClientCarryWatcherSet", true)

				if p26.BuildingVisualTroves[child] then
					p26.BuildingVisualTroves[child]:Destroy()
				end

				local v144 = trove.new()

				p26.BuildingVisualTroves[child] = v144
				task.spawn(function() -- line: 1641
					-- upvalues: child (copy), updateBuildingCarryVisual (copy)
					if child:WaitForChild("PlayerAura", 10) then
						updateBuildingCarryVisual(child)
					end
				end)

				local t6 = {
					BuildermanSentryPlacementRange = p26.Config.SentryPlacementRadius,
					BuildermanSentryEffectRange = p26.Config.SentryDamageRadius,
					BuildermanDispenserPlacementRange = p26.Config.DispenserPlacementRadius,
					BuildermanDispenserEffectRange = p26.Config.DispenserHealingRadius
				}
				local v146 = `{ child.Name }PlacementRange`
				local v147 = `{ child.Name }EffectRange`
				local v148 = createRadius("PlacementRange", t6[v146])
				local v149 = createRadius(v147, t6[v147])

				if v148 then
					v144:Add(v148)
				end

				if v149 then
					v144:Add(v149)
				end

				local function syncRadiusPositions() -- line: 1662
					-- upvalues: v148 (copy), Root (copy), v149 (copy)
					if v148 then
						v148.Position = Root.Position - Vector3.new(0, Root.Size.Y / 2 + 0.075, 0)
					end

					if v149 then
						v149.Position = Root.Position - Vector3.new(0, Root.Size.Y / 2, 0)
					end
				end

				v144:Connect(Root:GetPropertyChangedSignal("Position"), syncRadiusPositions)
				v144:Connect(child:GetAttributeChangedSignal("EffectRadiusSize"), function() -- line: 1668
					-- upvalues: child (copy), v149 (copy)
					if child:GetAttribute("Destroyed") or child:GetAttribute("Carrying") then
						return
					end

					local EffectRadiusSize = child:GetAttribute("EffectRadiusSize")

					if v149 then
						game.TweenService:Create(v149, TweenInfo.new(1), {
							Size = Vector3.new(0.25, EffectRadiusSize * 2, EffectRadiusSize * 2)
						}):Play()
					end
				end)
				v144:Connect(child:GetAttributeChangedSignal("Carrying"), function() -- line: 1677
					-- upvalues: child (copy), updateBuildingCarryVisual (copy), v148 (copy), v149 (copy), Root (copy), t6 (copy), v147 (copy), v146 (copy)
					if child:GetAttribute("Destroyed") then
						return
					end

					updateBuildingCarryVisual(child)

					if child:GetAttribute("Carrying") then
						if v148 then
							game.TweenService:Create(v148, TweenInfo.new(0.5), {
								Size = Vector3.new(0, 0, 0)
							}):Play()
						end

						if v149 then
							game.TweenService:Create(v149, TweenInfo.new(0.5), {
								Size = Vector3.new(0, 0, 0)
							}):Play()

							return
						end
					else
						if v148 then
							v148.Position = Root.Position - Vector3.new(0, Root.Size.Y / 2 + 0.075, 0)
						end

						if v149 then
							v149.Position = Root.Position - Vector3.new(0, Root.Size.Y / 2, 0)
						end

						local v200 = child:GetAttribute("EffectRadiusSize") or t6[v147]
						local v201 = t6[v146]
						local tweenInfo = TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

						if v149 then
							game.TweenService:Create(v149, tweenInfo, {
								Size = Vector3.new(0.25, v200 * 2, v200 * 2)
							}):Play()
						end

						if v148 then
							game.TweenService:Create(v148, tweenInfo, {
								Size = Vector3.new(0.25, v201, v201)
							}):Play()
						end
					end
				end)
				v144:Connect(Humanoid.HealthChanged, function(p31) -- line: 1694
					-- upvalues: v144 (copy), p26 (copy), child (copy)
					if p31 <= 0 then
						v144:Destroy()

						if p26.BuildingVisualTroves then
							p26.BuildingVisualTroves[child] = nil
						end
					end
				end)
				v144:Connect(child.AncestryChanged, function(_, p33) -- line: 1703
					-- upvalues: v144 (copy), p26 (copy), child (copy)
					if not p33 then
						v144:Destroy()

						if p26.BuildingVisualTroves then
							p26.BuildingVisualTroves[child] = nil
						end
					end
				end)
			end
		end)
		Network:SetConnection(`{ p26.Player.Name }UpdateClosestBuilding`, "REMOTE_EVENT", function(p34) -- line: 1714
			-- upvalues: p26 (copy), Util (copy)
			if p26.CarryableBuildingHighlight then
				p26.CarryableBuildingHighlight.Adornee = p34
			end

			Util:ToggleLockForAbilityIcon("Move", "nobuildinglmao", not p34)
		end)
		Network:SetConnection(`{ p26.Player.Name }ForceDropBuilding`, "REMOTE_EVENT", function() -- line: 1721
			-- upvalues: p26 (copy), Network (copy), cl_dropBuilding (copy), Util (copy)
			p26.AnimationType = nil
			Network:FireConnection("DisableSprinting", "CarryingBuilding", false)
			cl_dropBuilding(p26)
			Util:ToggleLockForAbilityIcon("Move", "nobuildinglmao", false)
			task.defer(function() -- line: 1726
				-- upvalues: Util (copy)
				Util:ToggleLockForAbilityIcon("Move", "nobuildinglmao", true)
			end)
		end)
	end

	initClientSentryAiming(p26)
	p26.Buildings = {}
	p26.CarryVisualTroves = p26.CarryVisualTroves or {}
	p26.CarryVisualConnection = workspace.Map.Ingame.ChildAdded:Connect(function(child) -- line: 1737
		-- upvalues: p26 (copy), trove (copy), updateBuildingCarryVisual (copy)
		if child.Name:find("Builderman") then
			if child:GetAttribute("ClientCarryWatcherSet") then
				return
			end

			child:SetAttribute("ClientCarryWatcherSet", true)

			if p26.CarryVisualTroves[child] then
				p26.CarryVisualTroves[child]:Destroy()
			end

			local v153 = trove.new()

			p26.CarryVisualTroves[child] = v153
			task.spawn(function() -- line: 1748
				-- upvalues: child (copy), updateBuildingCarryVisual (copy)
				if child:WaitForChild("PlayerAura", 10) then
					updateBuildingCarryVisual(child)
				end
			end)
			v153:Connect(child:GetAttributeChangedSignal("Carrying"), function() -- line: 1755
				-- upvalues: child (copy), updateBuildingCarryVisual (copy)
				if child:GetAttribute("Destroyed") then
					return
				end

				updateBuildingCarryVisual(child)
			end)
			v153:Connect(child.AncestryChanged, function(_, p36) -- line: 1760
				-- upvalues: v153 (copy), p26 (copy), child (copy)
				if not p36 then
					v153:Destroy()

					if p26.CarryVisualTroves then
						p26.CarryVisualTroves[child] = nil
					end
				end
			end)
		end
	end)
	Network:SetConnection(`{ p26.Player.Name }ReplicateBuildingAsync`, "REMOTE_EVENT", function(p37, s5: string) -- line: 1774
		-- upvalues: p26 (copy), cl_watchBuildingActivityLock (copy)
		if p26.Player ~= game.Players.LocalPlayer then
			return
		end

		p26.Buildings[s5] = p37
		cl_watchBuildingActivityLock(p26, p37, s5)

		local v156 = p26
		local v157 = p37.Parent ~= nil and not p37:GetAttribute("Destroyed")

		if v156.Player ~= game.Players.LocalPlayer then
			return
		end

		local AbilityContainer = v156.Player.PlayerGui.MainUI:FindFirstChild("AbilityContainer")
		local v159 = AbilityContainer and AbilityContainer:FindFirstChild(s5)

		if not v159 then
			return
		end

		v159.Charges.Text = not v157 and "" or "PLACED"
	end)
    Network:SetConnection(p26.Player.Name.."ConstructionRejected","REMOTE_EVENT",function(reason)
        if p26.Player==game.Players.LocalPlayer then Util:CreateWarning("BuildermanWarning",t2[reason]or t2.unknown,p26.Config.Instances.WarningTemplate)end
    end)
	Network:SetConnection(`{ p26.Player.Name }UpdateCanPlace`, "REMOTE_EVENT", function(b4: boolean) -- line: 1783
		-- upvalues: Util (copy)
		Util:ToggleLockForAbilityIcon("Move", "invalidplacement", not b4)
	end)
	Network:SetConnection(`{ p26.Player.Name }UpdateBuildingAbilityLock`, "REMOTE_EVENT", function(s6: string, s7: string, b5: boolean) -- line: 1790
		-- upvalues: Util (copy)
		Util:ToggleLockForAbilityIcon(s6, s7, b5)
	end)
	Network:SetConnection(`{ p26.Player.Name }ReplicateDestroyedBuildingAsync`, "REMOTE_EVENT", function(s8: string) -- line: 1798
		-- upvalues: p26 (copy), Util (copy)
		if p26.Player ~= game.Players.LocalPlayer then
			return
		end

		p26.Buildings[s8] = nil

		if p26.BuildingActivityLockTokens then
			p26.BuildingActivityLockTokens[s8] = nil
		end

		Util:ToggleLockForAbilityIcon(s8, "recentactivity", false)

		local v165 = p26.Behavior and (p26.Behavior.Abilities and p26.Behavior.Abilities[s8])

		if v165 then
			v165.CurrentRecharge = 0
			v165.ChargeDuration = 0
		end

		local v166 = p26

		if v166.Player ~= game.Players.LocalPlayer then
			return
		end

		local AbilityContainer = v166.Player.PlayerGui.MainUI:FindFirstChild("AbilityContainer")
		local v168 = AbilityContainer and AbilityContainer:FindFirstChild(s8)

		if not v168 then
			return
		end

		v168.Charges.Text = ""
	end)
	p26.BuildingActivityBarConnection = RunService.RenderStepped:Connect(function() -- line: 1817
		-- upvalues: p26 (copy), cl_updateBuildingActivityBars (copy)
		if not p26.Rig or not p26.Rig.Parent then
			if p26.BuildingActivityBarConnection then
				p26.BuildingActivityBarConnection:Disconnect()
				p26.BuildingActivityBarConnection = nil
			end

			return
		end

		cl_updateBuildingActivityBars(p26)
	end)
	p26.Rig.AncestryChanged:Connect(function(_, parent) -- line: 1829
		-- upvalues: p26 (copy), cl_tweenCarryFOV (copy), Network (copy)
		if parent then
			return
		end

		if p26.CarryVisualConnection then
			p26.CarryVisualConnection:Disconnect()
			p26.CarryVisualConnection = nil
		end

		for _, v in pairs(p26.CarryVisualTroves or {}) do
			v:Destroy()
		end

		p26.CarryVisualTroves = nil

		if p26.Player == game.Players.LocalPlayer then
			cl_tweenCarryFOV(p26, false)

			if p26.Connection then
				p26.Connection:Disconnect()
			end

			if p26.BuildingActivityBarConnection then
				p26.BuildingActivityBarConnection:Disconnect()
				p26.BuildingActivityBarConnection = nil
			end

			for _, v in pairs(p26.BuildingVisualTroves or {}) do
				v:Destroy()
			end

			p26.BuildingVisualTroves = nil

			for _, v in pairs(p26.RadiusStorages or {}) do
				v:Destroy()
			end

			if p26.CarryableBuildingHighlight then
				p26.CarryableBuildingHighlight:Destroy()
				p26.CarryableBuildingHighlight = nil
			end

			Network:RemoveConnection(`{ p26.Player.Name }UpdateClosestBuilding`, "REMOTE_EVENT")
			Network:RemoveConnection(`{ p26.Player.Name }ForceDropBuilding`, "REMOTE_EVENT")
			Network:RemoveConnection(`{ p26.Player.Name }UpdateCanPlace`, "REMOTE_EVENT")
			Network:RemoveConnection(`{ p26.Player.Name }UpdateBuildingAbilityLock`, "REMOTE_EVENT")
		end

		p26.Buildings = {}
		Network:RemoveConnection(`{ p26.Player.Name }ReplicateBuildingAsync`, "REMOTE_EVENT")
	end)
end
function t1.Destroyed(_, p40) -- line: 1873
	-- upvalues: cl_tweenCarryFOV (copy), Network (copy)
	p40.BuilderConstructionVisual=nil
	if p40.CarryVisualConnection then
		p40.CarryVisualConnection:Disconnect()
		p40.CarryVisualConnection = nil
	end

	for _, v in pairs(p40.CarryVisualTroves or {}) do
		v:Destroy()
	end

	p40.CarryVisualTroves = nil

	if p40.Player == game.Players.LocalPlayer then
		cl_tweenCarryFOV(p40, false)

		if p40.Connection then
			p40.Connection:Disconnect()
			p40.Connection = nil
		end

		if p40.BuildingActivityBarConnection then
			p40.BuildingActivityBarConnection:Disconnect()
			p40.BuildingActivityBarConnection = nil
		end

		for _, v in pairs(p40.BuildingVisualTroves or {}) do
			v:Destroy()
		end

		p40.BuildingVisualTroves = nil

		for _, v in pairs(p40.RadiusStorages or {}) do
			v:Destroy()
		end

		if p40.CarryableBuildingHighlight then
			p40.CarryableBuildingHighlight:Destroy()
			p40.CarryableBuildingHighlight = nil
		end

		Network:RemoveConnection(p40.Player.Name.."ConstructionRejected","REMOTE_EVENT")
		Network:FireConnection("DisableSprinting","CarryingBuilding",false)
		Network:RemoveConnection(`{ p40.Player.Name }UpdateClosestBuilding`, "REMOTE_EVENT")
		Network:RemoveConnection(`{ p40.Player.Name }ForceDropBuilding`, "REMOTE_EVENT")
		Network:RemoveConnection(`{ p40.Player.Name }UpdateCanPlace`, "REMOTE_EVENT")
		Network:RemoveConnection(`{ p40.Player.Name }UpdateBuildingAbilityLock`, "REMOTE_EVENT")
		Network:RemoveConnection(`{ p40.Player.Name }ReplicateBuildingAsync`, "REMOTE_EVENT")
		Network:RemoveConnection(`{ p40.Player.Name }ReplicateDestroyedBuildingAsync`, "REMOTE_EVENT")
	end
end

function t1.Use(actor,kind,response)
 local ability=t1.Abilities[kind]
 if ability then return ability.Callback(actor,response)end
end
return t1
]========] end
do local module=Instance.new("ModuleScript");module.Name="Rules";module.Parent=behavior;module.Source=[========[
local Rules={}
function Rules.ActivityRemaining(last,now)return type(last)=="number"and math.max(0,10-(now-last))or 0 end
function Rules.EffectRadius(config,kind,count)
 local radius=config[kind=="Sentry"and "SentryDamageRadius"or "DispenserHealingRadius"]/2
 if kind=="Sentry"then radius=math.clamp(radius*(1-math.max(0,count-1)*config.SentryRangeReductionPercentage/100),config.SentryMinimumRange,radius)end
 return radius
end
function Rules.SlowLevel(config,builders)return builders>1 and config.SentryStackedSlownessLevel or config.SentrySlownessLevel end
function Rules.Points(kind,value)
 return math.ceil(math.clamp(kind=="Sentry"and value^.5*1.2 or value^.95*.35,0,20))
end
return Rules
]========] end
end)
if not ok then prepared:Destroy();error("[Builderman] Preparation failed; nothing changed: "..tostring(err))end
local backup=Instance.new("Folder");local base="BuildermanPort_Backup_"..os.date("!%Y%m%d_%H%M%S");backup.Name=base
local index=0;while storage:FindFirstChild(backup.Name)do index+=1;backup.Name=base.."_"..index end
ref(backup,"Original",original);ref(backup,"Installed",prepared)
local function sourceSignature(object)
 local rows={}
 for _,module in object:GetDescendants()do if module:IsA("LuaSourceContainer")then table.insert(rows,module:GetFullName():sub(#object:GetFullName()+2).."="..fingerprint(module.Source))end end
 table.sort(rows);return table.concat(rows,"|")
end
backup:SetAttribute("InstalledSources",sourceSignature(prepared));backup.Parent=storage
ok,err=pcall(function()original.Parent=backup;prepared.Parent=parent end)
if not ok then prepared:Destroy();original.Parent=parent;backup:Destroy();error("[Builderman] Rolled back: "..tostring(err))end
print("[Builderman] Installed construction rework and Carry with 1.15s placement. Original Sentry model preserved. Save and restart Play. Backup: "..backup.Name)
