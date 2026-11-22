
local writes=0
local failAt=nil
local function copy(t)local out={};for k,v in pairs(t)do out[k]=v end;return out end
local Methods={}
local mt={}
function mt.__index(self,k)
 if Methods[k]then return Methods[k] end
 if k=="Parent"then return self._parent end
 local value=self._props[k]
 if value~=nil then return value end
 return self:FindFirstChild(k)
end
function mt.__newindex(self,k,v)
 if k=="Parent"then
  if self._parent then local old=self._parent._children;local i=table.find(old,self);if i then table.remove(old,i)end end
  rawset(self,"_parent",v);if v then table.insert(v._children,self)end
 else
  if k=="Source"then writes+=1;if failAt==writes then error("Injected Source write failure")end end
  self._props[k]=v
 end
end
local Instance={}
function Instance.new(class,parent)
 local self=setmetatable({_props={ClassName=class,Name=class},_children={},_attrs={}},mt)
 if parent then self.Parent=parent end
 return self
end
function Methods:IsA(class)
 return self.ClassName==class or class=="LuaSourceContainer"and(self.ClassName=="Script"or self.ClassName=="ModuleScript"or self.ClassName=="LocalScript")or class=="BasePart"and(self.ClassName=="Part"or self.ClassName=="MeshPart")
end
function Methods:FindFirstChild(name,recursive)
 for _,child in ipairs(self._children)do if child.Name==name then return child end end
 if recursive then for _,child in ipairs(self._children)do local found=child:FindFirstChild(name,true);if found then return found end end end
end
function Methods:FindFirstChildOfClass(class)for _,child in ipairs(self._children)do if child:IsA(class)then return child end end end
function Methods:GetChildren()return table.clone(self._children)end
function Methods:GetDescendants()local out={};for _,child in ipairs(self._children)do table.insert(out,child);for _,desc in ipairs(child:GetDescendants())do table.insert(out,desc)end end;return out end
function Methods:SetAttribute(k,v)self._attrs[k]=v end
function Methods:GetAttribute(k)return self._attrs[k]end
function Methods:Clone()
 local object=Instance.new(self.ClassName);object._props=copy(self._props);object._attrs=copy(self._attrs)
 for _,child in ipairs(self._children)do child:Clone().Parent=object end
 return object
end
function Methods:Destroy()self.Parent=nil;self.Destroyed=true;for _,child in ipairs(self:GetChildren())do child:Destroy()end end
function Methods:GetFullName()return (self.Parent and self.Parent:GetFullName().."."or "")..self.Name end
local game,workspace
local function child(parent,name,class)local o=Instance.new(class or "Folder");o.Name=name;o.Parent=parent;return o end
local function fresh()
 writes=0;failAt=nil
 game=Instance.new("DataModel");workspace=child(game,"Workspace","Workspace")
 local rep=child(game,"ReplicatedStorage");local assets=child(rep,"Assets");local survivors=child(assets,"Survivors")
 local modules=child(rep,"Modules");local statuses=child(modules,"StatusEffects");local misc=child(modules,"Misc")
 for _,name in {"Actors","Util","Statuses","Network","Sounds"}do child(modules,name,"ModuleScript")end
 for _,name in {"Maid","Trove"}do child(misc,name,"ModuleScript")end
 child(game,"ServerStorage")
 function game:GetService(name)
  if name=="RunService"then return {IsStudio=function()return true end,IsRunning=function()return false end}end
  if name=="ChangeHistoryService"then return {SetWaypoint=function()end}end
  return self:FindFirstChild(name)
 end
 return survivors,statuses
end
local function inputs()
 local donor=child(workspace,"HelperbotDonor");local rig=child(donor,"Rig","Model")
 child(rig,"Humanoid","Humanoid");child(rig,"HumanoidRootPart","Part")
 local upd=child(workspace,"HelperbotUPD");local config=child(upd,"Config","ModuleScript");local fx=child(config,"VFX")
 for _,name in {"Pulse","PulseHit","InspireActive"}do child(fx,name,"Attachment")end
 child(config,"Radar","MeshPart");child(config,"ChargeMeter","BillboardGui");child(config,"cl_HelperbotChargeBillboard","ModuleScript")
end

local sources={
[ [==========[
ReplicatedStorage]==========] ]={Config=[==========[
-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local v0 = {
	DisplayName = "Guest 1337", 
	Quote = "\"Be strong. Always be strong.\"", 
	Credits = "", 
	Class = "Sentinel", 
	RenderImage = "rbxassetid://128543664752032", 
	Price = 1000, 
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
		Text = "Cooldown: 27s. Guard for 1s; movement is reduced by 50% for up to 1.75s. A successful basic-attack block restores movement, grants 10 permanent overheal (maximum 30), resets Punch's cooldown and opens a 1s Parry window. It also grants Speed I for 2s and slows the attacker by 30% for 1s. Non-basic attacks and projectiles break the guard: that hit deals 60% damage and grants Resistance II for 3s. A guard that expires without blocking locks abilities for another 2s."
	}, 
	{
		Image = "rbxassetid://73254549946762", 
		Header = "CHARGE", 
		Quote = "\"Incoming! Look out!\" - Guest 1337", 
		Text = "Cooldown: 40s. Charge forward for up to 1.5s, dealing 5 damage. Knockback increases from 6 to 11 over the first 0.5s of active charging. A successful hit grants Resistance III for 0.5s, without an extra hit slowdown or target ability lock. Charge still ends on contact or a wall. Your abilities remain locked during Charge and for 1s afterward. Missing retains the distance-based Slowness II penalty (up to 15s). A target recently charged into is protected from Charge damage and knockback for 20s. Knockback is reduced by 10% per additional living Reworked Guest."
	}, 
	{
		Image = "rbxassetid://86535502112498", 
		Header = "PUNCH", 
		Quote = "\"FALCAWN PAAWNCH\" - random guy", 
		Text = "Cooldown: 55s. Normal Punch has a 0.6s windup, deals 25 damage and applies 7 knockback, Helpless I and Slowness II for 2s. It does not stun, pierce or grant cast Resistance. Debuff duration decreases by 0.35s per additional living Reworked Guest, to a minimum of 0s. After a successful Block, Punch becomes Parry for 1s: 0.4s windup, 35 damage, 13 knockback and a 2s stun, with piercing and Resistance III during windup. Landing Parry immediately stops your horizontal momentum; missing does not. Knockback is reduced by 10% per additional living Reworked Guest. Punch cannot interrupt other active abilities. This practice version allows hits on survivors as well as killers."
	}
};
return v0;]==========],Behavior=[==========[
-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local l_ReplicatedStorage_0 = game:GetService("ReplicatedStorage");
local l_RunService_0 = game:GetService("RunService");
local v2 = {};
local v3 = require(l_ReplicatedStorage_0.Modules.Util);
local v4 = require(l_ReplicatedStorage_0.Modules.Statuses);
local v5 = require(l_ReplicatedStorage_0.Modules.Hitboxes);
local v6 = require(l_ReplicatedStorage_0.Modules.Network);
local v7 = require(l_ReplicatedStorage_0.Modules.Sounds);
local v8 = require(l_ReplicatedStorage_0.Modules.Misc.Trove);
local v9 = require(l_ReplicatedStorage_0.Modules.AchievementUtil);
local v10 = Color3.new(1, 1, 1);
local v11 = Color3.new(0.392157, 0.392157, 0.392157);
local v12 = Color3.new(1, 0.933333, 0.027451);
local v13 = Color3.new(1, 1, 1);
local function _(v14, v15, v16) --[[ Line: 23 ]] --[[ Name: pcallMethod ]]
	local l_status_0, l_result_0 = pcall(function() --[[ Line: 24 ]]
		-- upvalues: v16 (copy), v14 (copy)
		if v16.Behavior[v14] then
			v16.Behavior[v14](v16);
		end;
	end);
	if not l_status_0 then
		warn((("[%*]: Failed to call .%*() due to: %*"):format(v15, v14, l_result_0)));
	end;
end;
-- Block owns a separate ability lock, so its timers cannot clear another ability's lock.
local function cancelGuestBlockTask(actor, name)
	local thread = actor[name]
	actor[name] = nil
	if thread then pcall(task.cancel, thread) end
end

local function clearGuestBlockSlow(actor)
	if actor.BlockingSlowness then
		actor.BlockingSlowness:Destroy()
		actor.BlockingSlowness = nil
	end
end

local function restoreGuestBlockHitbox(actor)
	local rig = actor.Rig
	if not rig then return end
	local query = rig:FindFirstChild("QueryHitbox")
	if query and actor.__blockDefaultHitboxSize then
		query.Size = actor.__blockDefaultHitboxSize
	end
	rig:SetAttribute("HitboxPriority", 2)
end

local function callGuestBlockHook(actor, name)
	local hook = actor.Behavior and actor.Behavior[name]
	if hook then
		local ok, err = pcall(hook, actor)
		if not ok then warn("[Guest Rework] " .. name .. ": " .. tostring(err)) end
	end
end

local function resolveGuestBlock(actor)
	actor.Blocking = nil
	actor.BlockSucceeded = true
	cancelGuestBlockTask(actor, "BlockThread")
	cancelGuestBlockTask(actor, "__blockSlowThread")
	cancelGuestBlockTask(actor, "__blockUnlockThread")
	clearGuestBlockSlow(actor)
	restoreGuestBlockHitbox(actor)
	actor:DisableAbilities("GuestReworkBlock", false)
end

local function setGuestParryWindow(actor, active)
	actor.Blocked = active and true or nil
	if actor.Rig then
		actor.Rig:SetAttribute("GuestReworkParryUntil",
			active and (workspace:GetServerTimeNow() + actor.Config.BlockDuration) or 0)
	end
end

local function stopGuestParryMotion(rig)
	local root = rig and rig.PrimaryPart
	if not root or not root.Parent then return end
	local velocity = root.AssemblyLinearVelocity
	root.AssemblyLinearVelocity = Vector3.new(0, velocity.Y, 0)
end

v2.Abilities = {
	Block = {
		LayoutOrder = 1,
		KeybindType = "AltAbility1",
		Icon = "rbxassetid://137576632569674",
		Callback = function(actor)
			if l_RunService_0:IsClient() then
				if actor.Animations.Block then
					actor.Animations.Block:Play(0.175)
				end
				return
			end

			local rig = actor.Rig
			local humanoid = rig and rig:FindFirstChildOfClass("Humanoid")
			if not humanoid or humanoid.Health <= 0 then return end

			cancelGuestBlockTask(actor, "BlockThread")
			cancelGuestBlockTask(actor, "__blockSlowThread")
			cancelGuestBlockTask(actor, "__blockUnlockThread")
			cancelGuestBlockTask(actor, "BlockedThread")
			setGuestParryWindow(actor, false)
			actor.Blocking = true
			actor.BlockSucceeded = false
			actor:DisableAbilities("GuestReworkBlock", true)
			callGuestBlockHook(actor, "BlockStart")
			v4:ApplyStatus(actor.Player, "Resistance", {
				Level = actor.Config.ResistanceLevel,
				Duration = actor.Config.BlockDuration
			})
			rig:SetAttribute("HitboxPriority", 3)
			local query = rig:FindFirstChild("QueryHitbox")
			if query then
				actor.__blockDefaultHitboxSize = actor.__blockDefaultHitboxSize or query.Size
				query.Size = actor.__blockDefaultHitboxSize * Vector3.new(2.1, 1.2, 2.1)
			end
			clearGuestBlockSlow(actor)
			actor.BlockingSlowness = v3:CreateSpeedMultiplier(rig, 0.5, "GuestBlocking")
			actor.__blockSlowThread = task.delay(actor.Config.SlownessDuration, function()
				actor.__blockSlowThread = nil
				clearGuestBlockSlow(actor)
			end)

			local previousBlockCount = actor.BlockCount
			task.delay(2, function()
				if actor.BlockCount == previousBlockCount then actor.BlockCount = 0 end
			end)

			actor.BlockThread = task.delay(actor.Config.BlockDuration, function()
				actor.BlockThread = nil
				if not actor.Blocking then return end
				actor.Blocking = nil
				restoreGuestBlockHitbox(actor)
				callGuestBlockHook(actor, "BlockExpire")
				callGuestBlockHook(actor, "BlockEnd")
				-- Failure means the full guard window elapsed without a hit.
				-- Keep this named lock for TWO SECONDS AFTER that failure.
				actor.__blockUnlockThread = task.delay(actor.Config.FailedBlockAbilityLockout, function()
					actor.__blockUnlockThread = nil
					actor:DisableAbilities("GuestReworkBlock", false)
				end)
			end)
			v7:Play(actor.Config.Sounds.BlockStart, { Parent = rig.PrimaryPart })
		end
	},
	Charge = {
		LayoutOrder = 2, 
		KeybindType = "AltAbility2", 
		Icon = "rbxassetid://73254549946762", 
		Callback = function(v33, v34) --[[ Line: 121 ]] --[[ Name: Callback ]]
			-- upvalues: l_RunService_0 (copy), v3 (copy), v5 (copy), v7 (copy), v6 (copy), v9 (copy), l_ReplicatedStorage_0 (copy), v4 (copy)
			if l_RunService_0:IsServer() then
				v33.DisabledAbilities = {
					Block = true,
					Charge = true,
					Punch = true
				};
				local chargeStartedAt = workspace:GetServerTimeNow()
				local v35 = v33 and v33.Rig;
				if v35 then
					v35:SetAttribute("AnimationsDisabled", true);
					v35:SetAttribute("AnimationsExtraDisabled", true);
					v35:SetAttribute("UsingItemsDisabled", true);
				end;
				v3:SetSpeedCap(v33.Player, "GuestCharging", v33.Config.ChargingSpeed / v33.Config.Speed);
				local v36 = ("%*/ChargeStart"):format(script.Parent);
				local l_pcall_2 = pcall;
				local v38 = "ChargeStart";
				local v39;
				l_pcall_2, v39 = l_pcall_2(function() --[[ Line: 24 ]]
					-- upvalues: v33 (copy), v38 (copy)
					if v33.Behavior[v38] then
						v33.Behavior[v38](v33);
					end;
				end);
				if not l_pcall_2 then
					warn((("[%*]: Failed to call .ChargeStart() due to: %*"):format(v36, v39)));
				end;
				v33.Rig:SetAttribute("GuestCharging", true);
				v36 = ("Result%*"):format((tostring(math.random(-10000, 10000))));
				task.delay(0.125, function() --[[ Line: 141 ]]
					-- upvalues: v33 (copy), v5 (ref), v7 (ref), v6 (ref), v3 (ref), v9 (ref), l_ReplicatedStorage_0 (ref), v36 (copy), v4 (ref)
					local l_PrimaryPart_0 = v33.Rig.PrimaryPart;
					local v41 = nil;
					local v42 = nil;
					local l_v5_Hitbox_0 = v5:CreateHitbox(v33.Player, {
						FriendlyFire = true,
						AbilityType = "AltAbility2",
						Size = Vector3.new(4, 5, 6, 0), 
						CFrameOffset = CFrame.new(0, 0, -1), 
						Damage = function(target)
							if target:GetAttribute("PreviouslyChargedInto") then
								return 0
							end

							return v33.Config.ChargeDamage
						end,
						Knockback = function(target)
							if target:GetAttribute("PreviouslyChargedInto") then
								return 0
							end

							local elapsed = workspace:GetServerTimeNow() - chargeStartedAt
							local progress = math.clamp(
								elapsed / v33.Config.ChargeKnockbackRampTime,
								0,
								1
							)

							local knockback = v33.Config.ChargeKnockback
								+ (
									v33.Config.ChargeKnockbackTotal
									- v33.Config.ChargeKnockback
								) * progress

							local Actors = require(game.ReplicatedStorage.Modules.Actors)
							local extraGuests = 0

							for _, actor in pairs(Actors.CurrentActors) do
								local humanoid = actor.Rig
									and actor.Rig:FindFirstChildOfClass("Humanoid")

								if actor ~= v33
									and actor.ActorName == "Guest1337Rework"
									and humanoid
									and humanoid.Health > 0 then

									extraGuests += 1
								end
							end

							return knockback * math.max(0, 1 - 0.10 * extraGuests)
						end,
						Time = v33.Config.ChargingDuration, 
						HitMultiple = true, 
						Connections = {
							Hit = function(v44) --[[ Line: 161 ]] --[[ Name: Hit ]]
								-- upvalues: v41 (ref), v33 (ref), v7 (ref), l_PrimaryPart_0 (copy), v6 (ref), v3 (ref), v9 (ref), l_ReplicatedStorage_0 (ref)
								v41 = v44;
								if v41 then
									if not v41:GetAttribute("PreviouslyChargedInto") then
										v41:SetAttribute("PreviouslyChargedInto", true);
										task.delay(v33.Config.KillerChargeResistanceDuration, function() --[[ Line: 169 ]]
											-- upvalues: v41 (ref)
											v41:SetAttribute("PreviouslyChargedInto", nil);
										end);
										v7:Play(v33.Config.Sounds.ChargingHit, {
											Parent = l_PrimaryPart_0
										});
										if v41.Parent == workspace.Players.Killers then
											v6:FireAllClientConnection(("%*On1337ChargeHit"):format(v33.Player.Name), "REMOTE_EVENT");
										end;
										if v41:GetAttribute("VoidRushState") == "Dashing" then
											v9:IncrementAchievementProgress(v33.Player, "NoliCar");
											v9:IncrementAchievementProgress(game.Players:GetPlayerFromCharacter(v41), "NoliCar");
										end;
									else
										v3:ApplyDamage(v33.Rig, v33.Config.KillerChargeResistanceDamage);
										v7:Play(v33.Config.Sounds.ChargingHitWeak, {
											Parent = l_PrimaryPart_0
										});
										return;
									end;
								end;                                
							end, 
							Ended = function() --[[ Line: 204 ]] --[[ Name: Ended ]]
								-- upvalues: v42 (ref)
								v42 = true;
							end
						}
					});
					local v47 = v7:Play(v33.Config.Sounds.ChargingStart, {
						Parent = l_PrimaryPart_0
					});
					local v48 = false;
					local v49 = ("%*Guest1337Collision"):format(v33.Player.Name);
					v6:SetConnection(v49, "REMOTE_EVENT", function(v50) --[[ Line: 214 ]]
						-- upvalues: v33 (ref), v48 (ref)
						if v50 == v33.Player then
							v48 = true;
						end;
					end);
					repeat
						task.wait();
					until v41 or v42 or v48;
					local v51 = ("%*/ChargeEnd"):format(script.Parent);
					local l_v33_0 = v33;
					local l_pcall_3 = pcall;
					local v54 = "ChargeEnd";
					local l_l_v33_0_0 = l_v33_0 --[[ copy: 8 -> 12 ]];
					local l_v54_0 = v54 --[[ copy: 11 -> 13 ]];
					local v57;
					l_pcall_3, v57 = l_pcall_3(function() --[[ Line: 24 ]]
						-- upvalues: l_l_v33_0_0 (copy), l_v54_0 (copy)
						if l_l_v33_0_0.Behavior[l_v54_0] then
							l_l_v33_0_0.Behavior[l_v54_0](l_l_v33_0_0);
						end;
					end);
					if not l_pcall_3 then
						warn((("[%*]: Failed to call .ChargeEnd() due to: %*"):format(v51, v57)));
					end;
					v33.Rig:SetAttribute("GuestCharging", nil);
					v51 = "IDK";
					if v41 then
						v51 = "Hit";
					elseif v48 then
						v51 = "Collide";
					elseif v42 then
						v51 = "Timeout";
					end;
					v7:PlayVoiceline(v33, ("Charge%*"):format(v51), {
						Priority = 1
					});
					l_v33_0 = Instance.new("StringValue");
					l_v33_0.Name = v36;
					l_v33_0.Value = v51;
					l_v33_0.Parent = v33.Rig;
					game.Debris:AddItem(l_v33_0, 1);
					if v51 == "Hit"
						and v41
						and (
							v41.Parent == workspace.Players.Killers
								or v41.Parent == workspace.Players.Survivors
						) then

						v4:ApplyStatus(v33.Player, "Resistance", {
							Level = 3,
							Duration = 0.5
						});
					else
						l_pcall_3, v57 = v3:GetClosestPlayerFromPosition(l_PrimaryPart_0.Position, {
							PlayerSelection = "Killers"
						});
						if not v57 then
							v57 = 999;
						end;
						v54 = math.clamp(math.floor(v57 / v33.Config.ChargePunishmentDistanceInterval) * v33.Config.ChargePunishmentSlownessDurationMultiplier, 0, v33.Config.ChargePunishmentSlownessMaxDuration);
						if v54 > 0 then
							v4:ApplyStatus(v33.Player, "Slowness", {
								Duration = v54, 
								Level = v33.Config.ChargePunishmentSlownessLevel
							});
						end;
					end;
					task.delay(v33.Config.ChargeAbilityLockout, function()
						v33.DisabledAbilities = nil;
					end);
					l_pcall_3 = v33 and v33.Rig;
					if l_pcall_3 then
						l_pcall_3:SetAttribute("AnimationsDisabled", nil);
						l_pcall_3:SetAttribute("AnimationsExtraDisabled", nil);
						l_pcall_3:SetAttribute("UsingItemsDisabled", nil);
					end;
					if v47 then
						game.TweenService:Create(v47, TweenInfo.new(0.2), {
							Volume = 0
						}):Play();
					end;
					if v51 ~= "Hit" then
						v7:Play(v33.Config.Sounds[("Charging%*"):format(v51)], {
							Parent = l_PrimaryPart_0
						});
					end;
					v6:RemoveConnection(v49, "REMOTE_EVENT");
					l_v5_Hitbox_0:Cancel();
					v3:SetSpeedCap(v33.Player, "GuestCharging", nil);
				end);
				return v36;
			else
				if l_RunService_0:IsClient() then
					v33.Animations.Charge:Play();
					v33.MovementAnimSpeed = 2.25;
					local v58 = require(
						l_ReplicatedStorage_0.Systems.Character.Game.Sprinting
					);

					local previousChargeStaminaGain = v58.StaminaGain;
					local previousChargeStaminaLoss = v58.StaminaLoss;
					local previousChargeSpeedLock = v58.isSpeedLocked;

					-- Keep sprint input active without adding sprint speed to Charge.
					v58.isSpeedLocked = true;
					v58.StaminaGain = 0;
					v58.StaminaLoss = 0;

					if v58.__currentSpeedTween then
						v58.__currentSpeedTween:Cancel();
						v58.__currentSpeedTween = nil;
					end;

					v58.__speedMultiplier.Value = 1;
					local l_v3_FOVMultiplier_0 = v3:CreateFOVMultiplier(v33.Player, 1, "Guest1337Charge");
					game.TweenService:Create(l_v3_FOVMultiplier_0, TweenInfo.new(0.8), {
						Value = 0.75
					}):Play();
					local l_v3_SpeedMultiplier_0 = v3:CreateSpeedMultiplier(v33.Rig, v33.Config.ChargingSpeed / v33.Config.Speed, "Guest1337Charge");
					local l_LookVector_0 = workspace.CurrentCamera.CFrame.LookVector;
					local l_Unit_0 = Vector3.new(l_LookVector_0.X, 0, l_LookVector_0.Z).Unit;
					local v63 = Vector3.new(0, 0, 0, 0);
					local v64 = 0;
					local v65 = false;
					pcall(function() --[[ Line: 308 ]]
						-- upvalues: l_RunService_0 (ref)
						l_RunService_0:UnbindFromRenderStep("GuestCharging");
					end);
					do
						local l_l_Unit_0_0, l_v63_0, l_v64_0, l_v65_0 = l_Unit_0, v63, v64, v65;
						l_RunService_0:BindToRenderStep("GuestCharging", Enum.RenderPriority.Character.Value + 1, function(v70) --[[ Line: 309 ]]
							-- upvalues: v33 (copy), l_RunService_0 (ref), l_v64_0 (ref), l_v65_0 (ref), v6 (ref), l_v63_0 (ref), l_l_Unit_0_0 (ref)
							if not v33.Rig.Parent or not v33.Rig.PrimaryPart then
								l_RunService_0:UnbindFromRenderStep("GuestCharging");
								return;
							else
								l_v64_0 = l_v64_0 + v70;
								if l_v64_0 >= 0.3 and v33.Rig.PrimaryPart.Velocity.Magnitude <= v33.Config.ChargingSpeed / 2 then
									if not l_v65_0 then
										l_v65_0 = true;
										v6:FireServerConnection(("%*Guest1337Collision"):format(v33.Player.Name), "REMOTE_EVENT");
									end;
									return;
								else
									local l_LookVector_1 = workspace.CurrentCamera.CFrame.LookVector;
									l_v63_0 = Vector3.new(l_LookVector_1.X, 0, l_LookVector_1.Z).Unit;
									local v72 = l_v63_0 - l_l_Unit_0_0;
									local l_Magnitude_0 = v72.Magnitude;
									if l_Magnitude_0 > 0 then
										local v74 = v33.Config.ChargingTurnSpeed * v70;
										if l_Magnitude_0 <= v74 then
											l_l_Unit_0_0 = l_v63_0;
										else
											l_l_Unit_0_0 = l_l_Unit_0_0 + v72.Unit * v74;
										end;
										l_l_Unit_0_0 = l_l_Unit_0_0.Unit;
									end;
									v33.Rig.Humanoid:Move(l_l_Unit_0_0);
									return;
								end;
							end;
						end);
						local v75 = v33.Rig:WaitForChild(v34, v33.Config.ChargingDuration + 0.5);
						local v76 = v75 and v75.Value;
						if v75 then
							v75:Destroy();
						end;
						if v76 == "Collide" then
							local l_v3_SpeedMultiplier_1 = v3:CreateSpeedMultiplier(v33.Rig, 0.2, "GuestChargeEnded");
							game.TweenService:Create(l_v3_SpeedMultiplier_1, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
								Value = 1
							}):Play();
							game.Debris:AddItem(l_v3_SpeedMultiplier_1, 1);
						end;
						l_RunService_0:UnbindFromRenderStep("GuestCharging");
						v33.Animations.Charge:Stop();
						v33.MovementAnimSpeed = nil;
						game.TweenService:Create(l_v3_FOVMultiplier_0, TweenInfo.new(0.4), {
							Value = 1
						}):Play();
						game.Debris:AddItem(l_v3_FOVMultiplier_0, 0.4);
						l_v3_SpeedMultiplier_0:Destroy();
						v58.isSpeedLocked = previousChargeSpeedLock;
						v58.StaminaGain = previousChargeStaminaGain;
						v58.StaminaLoss = previousChargeStaminaLoss;
						v58:Resync();
					end;
				end;
				return;
			end;
		end
	}, 
	Punch = {
		LayoutOrder = 3, 
		KeybindType = "AltAbility3", 
		Icon = "rbxassetid://86535502112498", 
		Callback = function(v78, v79) --[[ Line: 379 ]] --[[ Name: Callback ]]
			-- upvalues: l_RunService_0 (copy), v4 (copy), v7 (copy), v3 (copy), v5 (copy), v9 (copy), l_ReplicatedStorage_0 (copy), v6 (copy)
			local v80
			if l_RunService_0:IsServer() then
				v80 = v78.Blocked == true
			else
				v80 = v79 == true
			end
			local v81 = v80 and "Parry" or "Punch";
			local function _(v82) --[[ Line: 383 ]] --[[ Name: getConfig ]]
				-- upvalues: v78 (copy), v81 (copy)
				return v78.Config[("%*%*"):format(v81, v82)];
			end;
			if l_RunService_0:IsServer() then
				cancelGuestBlockTask(v78, "BlockedThread")
				setGuestParryWindow(v78, false)
				v78.AbilitiesDisabled = true;
				task.delay(2, function() --[[ Line: 390 ]]
					-- upvalues: v78 (copy)
					v78.AbilitiesDisabled = false;
				end);
				if v81 == "Parry" then
					v4:ApplyStatus(v78.Rig, "Resistance", {
						Level = 3, 
						Duration = v78.Config.ParryWindupTime
					});
					local v84 = ("%*/Start"):format(script.Parent);
					local l_pcall_4 = pcall;
					local v86 = "ParryStart";
					local v87;
					l_pcall_4, v87 = l_pcall_4(function() --[[ Line: 24 ]]
						-- upvalues: v78 (copy), v86 (copy)
						if v78.Behavior[v86] then
							v78.Behavior[v86](v78);
						end;
					end);
					if not l_pcall_4 then
						warn((("[%*]: Failed to call .ParryStart() due to: %*"):format(v84, v87)));
					end;
				end;
				v7:Play(v78.Config.Sounds.PunchWindup, {
					Parent = v78.Rig.PrimaryPart
				});
				v7:PlayVoiceline(v78, ("%*Windup"):format(v81), {
					Priority = 1
				});
				task.delay(v78.Config[("%*WindupTime"):format(v81)], function() --[[ Line: 406 ]]
					-- upvalues: v3 (ref), v78 (copy), v81 (copy), v5 (ref), v7 (ref), v4 (ref), v80 (copy), v9 (ref), l_ReplicatedStorage_0 (ref)
					local v88 = v3:ApplyVelocity(v78.Rig.PrimaryPart, v78.Config[("%*DashForce"):format(v81)]);
					local Actors = require(game.ReplicatedStorage.Modules.Actors)
					local extraGuests = 0

					for _, actor in pairs(Actors.CurrentActors) do
						local humanoid = actor.Rig
							and actor.Rig:FindFirstChildOfClass("Humanoid")

						if actor ~= v78
							and actor.ActorName == "Guest1337Rework"
							and humanoid
							and humanoid.Health > 0 then

							extraGuests += 1
						end
					end

					local punchDebuffDuration = math.max(
						0,
						v78.Config.PunchDebuffDuration - 0.35 * extraGuests
					)

					local punchKnockbackMultiplier = math.max(
						0,
						1 - 0.10 * extraGuests
					)
					game.Debris:AddItem(v88, 0.1);
					local parryConnected = false
					local _ = v5:CreateHitbox(v78.Player, {
						FriendlyFire = true,
						AbilityType = "AltAbility3",
						Size = Vector3.new(4.5, 6, 7.5, 0), 
						CFrameOffset = CFrame.new(0, 0, -1), 
						Damage = v78.Config[("%*Damage"):format(v81)], 
						Time = 0.25, 
						Knockback = v78.Config[("%*Knockback"):format(v81)]
							* punchKnockbackMultiplier,
						HitMultiple = not not v80,
						Connections = {
							Hit = function(v89) --[[ Line: 423 ]] --[[ Name: Hit ]]
								-- upvalues: v7 (ref), v78 (ref), v81 (ref), v4 (ref), v80 (ref), v9 (ref), l_ReplicatedStorage_0 (ref)
								if v80 and not parryConnected then
									parryConnected = true
									if v88 and v88.Parent then v88:Destroy() end
									stopGuestParryMotion(v78.Rig)
									v6:FireClientConnection(v78.Player,
										v78.Player.Name .. "1337ReworkParryStop", "REMOTE_EVENT", v78.Rig)
								end
								v7:Play(v78.Config.Sounds[v81], {
									Parent = v89.PrimaryPart or v78.Rig.PrimaryPart
								});
								v7:PlayVoiceline(v78, ("%*Hit"):format(v81), {
									Priority = 1
								});
								if v80 then
									v4:ApplyStatus(v89, "Stunned", {
										Level = 1,
										Duration = v78.Config.ParryStunTime
									});
								elseif punchDebuffDuration > 0 then
									v4:ApplyStatus(v89, "Helpless", {
										Level = 1,
										Duration = punchDebuffDuration
									});

									v4:ApplyStatus(v89, "Slowness", {
										Level = 2,
										Duration = punchDebuffDuration
									});
								end;
								if v80 then
									v9:IncrementAchievementProgress(v78.Player, "GuestParry");
									local v90 = ("%*/Hit"):format(script.Parent);
									local l_v78_0 = v78;
									local l_pcall_5 = pcall;
									local v93 = "ParryHit";
									local l_l_v78_0_0 = l_v78_0 --[[ copy: 2 -> 7 ]];
									local l_v93_0 = v93 --[[ copy: 5 -> 8 ]];
									local v96;
									l_pcall_5, v96 = l_pcall_5(function() --[[ Line: 24 ]]
										-- upvalues: l_l_v78_0_0 (copy), l_v93_0 (copy)
										if l_l_v78_0_0.Behavior[l_v93_0] then
											l_l_v78_0_0.Behavior[l_v93_0](l_l_v78_0_0);
										end;
									end);
									if not l_pcall_5 then
										warn((("[%*]: Failed to call .ParryHit() due to: %*"):format(v90, v96)));
									end;
								end;
								if v78.Rig.PrimaryPart.AssemblyLinearVelocity.Y < -8 then
									v7:Play(v78.Config.Sounds.CriticalPunch, {
										Parent = v89.PrimaryPart or v78.Rig.PrimaryPart,
										Volume = 0.1
									});
									v9:IncrementAchievementProgress(v78.Player, "GuestAlpha");
								end;
								local v97 = v80 and "Parried" or "Punched";
								v78.Rig:SetAttribute(v97, true);
								task.delay(0.25, function() --[[ Line: 441 ]]
									-- upvalues: v78 (ref), v97 (copy)
									v78.Rig:SetAttribute(v97, nil);
								end);
								local v98 = require(l_ReplicatedStorage_0.Modules.Actors);
								if v80 then
									local l_v78_1 = v78;
									local l_pcall_6 = pcall;
									local v101 = "OnParry";
									local v102;
									l_pcall_6, v102 = l_pcall_6(function() --[[ Line: 24 ]]
										-- upvalues: l_v78_1 (copy), v101 (copy)
										if l_v78_1.Behavior[v101] then
											l_v78_1.Behavior[v101](l_v78_1);
										end;
									end);
									if not l_pcall_6 then
										warn((("[Guest1337]: Failed to call .OnParry() due to: %*"):format(v102)));
									end;
									v98:IncrementActorStats(v78.Player, {
										Action = "Parried Killer as Guest 1337", 
										RewardType = "Offensive"
									});
									return;
								else
									v98:IncrementActorStats(v78.Player, {
										Action = "Punched Killer as Guest 1337", 
										RewardType = "Offensive"
									});
									return;
								end;
							end
						}
					});
				end);
				return v80;
			else
				if l_RunService_0:IsClient() then
					local v104 = v78.Animations[v80 and "ParryPunch" or "Punch"];
					if v104 then
						v104:Play();
						if not v78.Config.RawAnims then
							v104:AdjustSpeed((v104.Length - 0.55) / v78.Config[("%*WindupTime"):format(v81)]);
						end;
					end;
					v6:FireConnection("DisableSprinting", "GuestPunch", true);
					local l_v3_SpeedMultiplier_2 = v3:CreateSpeedMultiplier(v78.Rig, 1, "PunchAbility");
					game.TweenService:Create(l_v3_SpeedMultiplier_2, TweenInfo.new(0.25), {
						Value = 0.25
					}):Play();
					task.wait(v80 and v78.Config.ParryWindupTime or v78.Config.PunchWindupTime);
					task.wait(0.8);
					v6:FireConnection("DisableSprinting", "GuestPunch", false);
					game.TweenService:Create(l_v3_SpeedMultiplier_2, TweenInfo.new(0.15), {
						Value = 1
					}):Play();
					game.Debris:AddItem(l_v3_SpeedMultiplier_2, 0.15);
				end;
				return;
			end;
		end
	}
};
v2.cl_OnChargeProcGlobal = function(_, v107, v108) --[[ Line: 498 ]] --[[ Name: cl_OnChargeProcGlobal ]]
	-- upvalues: v7 (copy)
	v7:Play(v107.Config.Sounds.ChargeCooldownActivated);
	local l_Charge_0 = v107.Behavior.Abilities.Charge;
	if l_Charge_0 then
		l_Charge_0.CurrentRecharge = 0;
		l_Charge_0.ChargeDuration = v108.Config.KillerChargeResistanceDuration;
	end;
end;
v2.OnHit = function(_, v111, v112) --[[ Line: 507 ]] --[[ Name: OnHit ]]
	-- special attacks and projectiles breaks block.
	if v111.Blocking
		and v112.Creator
		and (
			v112.IsProjectile
				or v112.AbilityType ~= "MainAbility"
		) then

		local rawDamage = typeof(v112.Damage) == "function"
			and v112.Damage(v111.Rig)
			or v112.Damage
			or 0

		-- guarding/parry state before registerin' the hit.
		resolveGuestBlock(v111)
		setGuestParryWindow(v111, false)

		if v111.BlockedThread then
			task.cancel(v111.BlockedThread)
			v111.BlockedThread = nil
		end

		if v111.BlockThread then
			task.cancel(v111.BlockThread)
			v111.BlockThread = nil
		end

		-- Restore movement and the normal query hitbox.
		if v111.BlockingSlowness then
			v111.BlockingSlowness:Destroy()
			v111.BlockingSlowness = nil
		end

		local queryHitbox = v111.Rig:FindFirstChild("QueryHitbox")
		if queryHitbox and v111.__blockDefaultHitboxSize then
			queryHitbox.Size = v111.__blockDefaultHitboxSize
		end

		v111.Rig:SetAttribute("HitboxPriority", 2)

		if v111.Behavior.BlockEnd then
			v111.Behavior.BlockEnd(v111)
		end

		-- Replace the blocking Resistance with post-break Resistance.
		v4:RemoveStatus(v111.Player, "Resistance")
		v4:ApplyStatus(v111.Player, "Resistance", {
			Level = 2,
			Duration = 3
		})

		-- Hitboxes applies this once, then continues normal hit effects.
		v6:FireClientConnection(
			v111.Player,
			v111.Player.Name .. "1337ReworkBlockBroken",
			"REMOTE_EVENT"
		)
		return {
			DamageOverride = rawDamage * 0.6
		}
	end
	if not v112.IsProjectile
		and v112.AbilityType == "MainAbility"
		and v112.Creator
		and v111.Blocking then
		resolveGuestBlock(v111);
		cancelGuestBlockTask(v111, "BlockedThread")
		setGuestParryWindow(v111, true)
		v111.BlockedThread = task.delay(v111.Config.BlockDuration, function()
			v111.BlockedThread = nil
			setGuestParryWindow(v111, false)
		end)
		v111:SetCooldownOf("Punch", 0);
		v7:Play(v111.Config.Sounds.BlockSuccess, {
			Parent = v111.Rig.PrimaryPart
		});
		local v113 = typeof(v112.Damage) == "function" and v112.Damage(v111.Rig) or v112.Damage or 0;
		local l_Health_0 = v111.Rig.Humanoid.Health;
		-- Reworked Guest Shit, please work ;-;
		local humanoid = v111.Rig:FindFirstChildOfClass("Humanoid")

		if humanoid then
			local currentOverheal = humanoid:GetAttribute("Overheal") or 0
			local protectedFloor = humanoid:GetAttribute("OverhealDecayMin") or 0

			local gain = math.clamp(
				v111.Config.BlockOverhealCap - currentOverheal,
				0,
				v111.Config.BlockOverhealGain
			)

			if gain > 0 then
				v3:ApplyOverheal(v111.Rig, currentOverheal + gain)
				humanoid:SetAttribute("OverhealDecayMin", protectedFloor + gain)
			end
		end
		v4:ApplyStatus(v111.Rig, "Strength", {
			Level = 1,
			Duration = 5
		})
		local attacker = v112.Creator
		local slow = v111.Config.KillerSlownessPercent / 100
		local duration = v111.Config.KillerSlownessDuration
		task.defer(function()
			local rig = typeof(attacker) == "Instance" and (attacker:IsA("Model") and attacker or attacker:IsA("Player") and attacker.Character)
				or typeof(attacker) == "table" and (attacker.Rig or attacker.Character)
			if not rig or not rig.Parent then return end
			local multiplier = v3:CreateSpeedMultiplier(rig, slow, "GuestBlockedAttacker", duration)
			if multiplier then game.Debris:AddItem(multiplier, duration) end
		end)
		v4:ApplyStatus(v111.Player, "Speed", {
			Level = v111.Config.BlockSpeedLevel, 
			Duration = v111.Config.BlockSpeedDuration
		});
		v4:RemoveStatus(v111.Player, "Resistance");


		local v116 = ("%*/BlockEnd"):format(script.Parent);
		local l_pcall_7 = pcall;
		local v118 = "BlockEnd";
		local l_v118_0 = v118 --[[ copy: 9 -> 10 ]];
		local v120;
		l_pcall_7, v120 = l_pcall_7(function() --[[ Line: 24 ]]
			-- upvalues: v111 (copy), l_v118_0 (copy)
			if v111.Behavior[l_v118_0] then
				v111.Behavior[l_v118_0](v111);
			end;
		end);
		if not l_pcall_7 then
			warn((("[%*]: Failed to call .BlockEnd() due to: %*"):format(v116, v120)));
		end;
		v116 = v111.Rig:FindFirstChild("QueryHitbox");
		if v116 and v111.__blockDefaultHitboxSize then
			v116.Size = v111.__blockDefaultHitboxSize;
		end;
		require(l_ReplicatedStorage_0.Modules.Actors):IncrementActorStats(v111.Player, {
			Action = "Successfully blocked an attack", 
			RewardType = "Survivalist"
		});
		if not v111.BlockCount then
			v111.BlockCount = 0;
		end;
		v111.BlockCount = v111.BlockCount + 1;
		if v111.BlockCount >= 3 then
			v9:IncrementAchievementProgress(v111.Player, "GuestBlock");
		end;
		v120 = l_Health_0 < v113;
		v118 = require(game.ServerScriptService.Server.Systems.Core.RoundManager);
		if v120 and v118.CurrentSession and v118.CurrentSession.LastSurvivorAlive then
			v111.Daigo = true;
		end;
		return "Ignored";
	else
		return;
	end;
end;
v2.Created = function(_, v122) --[[ Line: 578 ]] --[[ Name: Created ]]
	-- upvalues: l_RunService_0 (copy), v6 (copy), v3 (copy)
	if l_RunService_0:IsServer() then
		v122.Rig:SetAttribute("HitboxPriority", 2);
		return;
	else
		if v122.Player == game.Players.LocalPlayer then
			v6:SetConnection(v122.Player.Name .. "1337ReworkParryStop", "REMOTE_EVENT", function(rig)
				if rig == v122.Rig and rig == game.Players.LocalPlayer.Character then
					stopGuestParryMotion(rig)
				end
			end)

			v6:SetConnection(
				v122.Player.Name .. "1337ReworkBlockBroken",
				"REMOTE_EVENT",
				function()
					if not v122.Rig or not v122.Rig.Parent then
						return
					end

					local animations = v122.Animations
					if not animations then
						return
					end

					-- Stop the guarding pose before playing the break agyluugyuaydgakdjhkhjdakhjg WHY IS THIS PAIN 2 MAKE!!!
					if animations.Block then
						animations.Block:Stop(0)
					end

					local broken = animations.BlockBroken
					if broken then
						broken.Looped = false
						broken:Play(0)
					else
						warn("[Guest Rework] BlockBroken animation is missing")
					end
				end
			)
		end
		v6:SetConnection(("%*On1337ChargeHit"):format(v122.Player.Name), "REMOTE_EVENT", function() --[[ Line: 583 ]]
			-- upvalues: v3 (ref), v122 (copy)
			local l_v3_Actor_0 = v3:GetActor(game.Players.LocalPlayer);
			if v122 and l_v3_Actor_0 and l_v3_Actor_0.Behavior.cl_OnChargeProcGlobal then
				l_v3_Actor_0.Behavior:cl_OnChargeProcGlobal(l_v3_Actor_0, v122);
			end;
		end);
		return;
	end;
end;
v2.CreatedPost = function(_, actor)
	if l_RunService_0:IsServer()
		or actor.Player ~= game.Players.LocalPlayer then
		return
	end

	if actor.__parryTrove then
		actor.__parryTrove:Destroy()
	end

	local trove = v8.new()
	actor.__parryTrove = trove

	local currentButton
	local stroke

	local function clearStroke()
		if stroke then
			stroke:Destroy()
			stroke = nil
		end
	end

	local function refresh()
		-- An old character must not change the new character's UI.
		if require(l_ReplicatedStorage_0.Modules.Actors).CurrentActors[game.Players.LocalPlayer] ~= actor then
			clearStroke()
			currentButton = nil
			return
		end

		local rig = actor.Rig
		if not rig or not rig.Parent then
			clearStroke()
			return
		end

		local deadline = rig:GetAttribute("GuestReworkParryUntil") or 0
		local active = deadline > workspace:GetServerTimeNow()

		local icon = active
			and "rbxassetid://76339130778616"
			or "rbxassetid://86535502112498"

		local name = active and "Parry" or "Punch"
		local textColor = active and v12 or v13

		-- Update the source used by the hotbar's own refresh loop.
		local punch = actor.Behavior.Abilities.Punch
		punch.Icon = icon
		punch.Name = name

		-- Find the current UI, including after respawning or morphing.
		local playerGui = actor.Player:FindFirstChild("PlayerGui")
		local mainUI = playerGui and playerGui:FindFirstChild("MainUI")
		local container = mainUI
			and mainUI:FindFirstChild("AbilityContainer")
		local button = container and container:FindFirstChild("Punch")

		if button ~= currentButton then
			clearStroke()
			currentButton = button
		end

		if not button then return end

		if button.Image ~= icon then
			button.Image = icon
		end
		button.ImageColor3 = active and v10 or v11

		local clipping = button:FindFirstChild("Clipping")
		local top = clipping and clipping:FindFirstChild("Top")
		if top and top.Image ~= icon then
			top.Image = icon
		end

		local label = button:FindFirstChild("AbilityName")
		if label then
			label.Text = name
			label.TextColor3 = textColor
		end

		local keybind = button:FindFirstChild("KeybindName")
		if keybind then
			keybind.TextColor3 = textColor
		end

		local charges = button:FindFirstChild("Charges")
		if charges then
			charges.Visible = false
		end

		if stroke and (not active or stroke.Parent ~= label) then
			clearStroke()
		end

		if active and label and not stroke
			and actor.Config.ParryUIStroke then
			stroke = actor.Config.ParryUIStroke:Clone()
			stroke.Parent = label
		end
	end

	trove:Add(clearStroke)
	trove:Add(l_RunService_0.Heartbeat:Connect(refresh))
	refresh()
end
v2.Destroyed = function(_, v134)
	if l_RunService_0:IsServer() then
		cancelGuestBlockTask(v134, "BlockThread")
		cancelGuestBlockTask(v134, "__blockSlowThread")
		cancelGuestBlockTask(v134, "__blockUnlockThread")
		cancelGuestBlockTask(v134, "BlockedThread")
		clearGuestBlockSlow(v134)
		restoreGuestBlockHitbox(v134)
		v134.Blocking = nil
		setGuestParryWindow(v134, false)
		v134:DisableAbilities("GuestReworkBlock", false)
	end

	if l_RunService_0:IsServer() then
		return
	end

	if v134.Player == game.Players.LocalPlayer then
		v6:RemoveConnection(v134.Player.Name .. "1337ReworkParryStop", "REMOTE_EVENT")
		v6:RemoveConnection(
			v134.Player.Name .. "1337ReworkBlockBroken",
			"REMOTE_EVENT"
		)
	end

	if v134.__parryTrove then
		v134.__parryTrove:Destroy()
		v134.__parryTrove = nil
	end

	v6:RemoveConnection(
		("%*On1337ChargeHit"):format(v134.Player.Name),
		"REMOTE_EVENT"
	)
end

return v2]==========]},
[ [==========[
ServerStorage]==========] ]={Config=[==========[
-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local v0 = {
    DisplayName = "Guest 1337", 
    Quote = "\"Be strong. Always be strong.\"", 
    Credits = "", 
    Class = "Sentinel", 
	RenderImage = "rbxassetid://132994561831811", 
    Price = 500, 
    Health = 115, 
    Speed = 12, 
    BlockCooldown = 30, 
    BlockDuration = 1, 
    BlockSpeedLevel = 1, 
    BlockSpeedDuration = 2, 
    ResistanceLevel = 5, 
    SlownessDuration = 2, 
    KillerSlownessPercent = 70, 
    KillerSlownessDuration = 1, 
    PunchCooldown = 5, 
    PunchWindupTime = 0.7, 
    PunchDashForce = 40, 
    PunchKnockback = 5, 
    PunchDamage = 25, 
    PunchStunTime = 2, 
    ParryWindupTime = 0.4, 
    ParryDashForce = 80, 
    ParryKnockback = 10, 
    ParryDamage = 35, 
    ParryStunTime = 3.5, 
    ParryUIStroke = script.ParryStroke, 
    ChargeCooldown = 40, 
    ChargeDamage = 20, 
    ChargingSpeed = 34, 
    ChargingTurnSpeed = 2, 
    ChargingDuration = 1.5, 
    ChargeKnockback = 9, 
    ChargePunishmentDistanceInterval = 13, 
    ChargePunishmentSlownessDurationMultiplier = 3, 
    ChargePunishmentSlownessMaxDuration = 15, 
    ChargePunishmentSlownessLevel = 2, 
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
        Block = "rbxassetid://98345062984163", 
        Punch = "rbxassetid://84008844361182", 
        ParryPunch = "rbxassetid://84008844361182", 
        Charge = "rbxassetid://96039010711318"
    }, 
    Sounds = {
        BlockStart = "rbxassetid://8028421882", 
        BlockSuccess = "rbxassetid://75271649206104", 
        PunchWindup = "rbxassetid://609342351", 
        CriticalPunch = "rbxassetid://13471740561", 
        Punch = "rbxassetid://78646570394745", 
        Parry = "rbxassetid://116900970230089", 
        ChargingStart = "rbxassetid://83367817381534", 
        ChargingHit = "rbxassetid://99002580763000", 
        ChargingHitWeak = "rbxassetid://99002580763000", 
        ChargingCollide = "rbxassetid://9113225979", 
        ChargingTimeout = "rbxassetid://127506392754179", 
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
return v0;]==========],Behavior=[==========[
-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local l_ReplicatedStorage_0 = game:GetService("ReplicatedStorage");
local l_RunService_0 = game:GetService("RunService");
local v2 = {};
local v3 = require(l_ReplicatedStorage_0.Modules.Util);
local v4 = require(l_ReplicatedStorage_0.Modules.Statuses);
local v5 = require(l_ReplicatedStorage_0.Modules.Hitboxes);
local v6 = require(l_ReplicatedStorage_0.Modules.Network);
local v7 = require(l_ReplicatedStorage_0.Modules.Sounds);
local v8 = require(l_ReplicatedStorage_0.Modules.Misc.Trove);
local v9 = require(l_ReplicatedStorage_0.Modules.AchievementUtil);
local v10 = Color3.new(1, 1, 1);
local v11 = Color3.new(0.392157, 0.392157, 0.392157);
local v12 = Color3.new(1, 0.933333, 0.027451);
local v13 = Color3.new(1, 1, 1);
local function _(v14, v15, v16) --[[ Line: 23 ]] --[[ Name: pcallMethod ]]
    local l_status_0, l_result_0 = pcall(function() --[[ Line: 24 ]]
        -- upvalues: v16 (copy), v14 (copy)
        if v16.Behavior[v14] then
            v16.Behavior[v14](v16);
        end;
    end);
    if not l_status_0 then
        warn((("[%*]: Failed to call .%*() due to: %*"):format(v15, v14, l_result_0)));
    end;
end;
v2.Abilities = {
    Block = {
        LayoutOrder = 1, 
        KeybindType = "AltAbility1", 
        Icon = "rbxassetid://137576632569674", 
        Callback = function(v20, _) --[[ Line: 40 ]] --[[ Name: Callback ]]
            -- upvalues: l_RunService_0 (copy), v4 (copy), v2 (copy), v3 (copy), v7 (copy)
            if l_RunService_0:IsServer() then
                v20.DisabledAbilities = {
                    Block = true, 
                    Charge = true
                };
                local v22 = ("%*/BlockStart"):format(script.Parent);
                local l_pcall_0 = pcall;
                local v24 = "BlockStart";
                local v25;
                l_pcall_0, v25 = l_pcall_0(function() --[[ Line: 24 ]]
                    -- upvalues: v20 (copy), v24 (copy)
                    if v20.Behavior[v24] then
                        v20.Behavior[v24](v20);
                    end;
                end);
                if not l_pcall_0 then
                    warn((("[%*]: Failed to call .BlockStart() due to: %*"):format(v22, v25)));
                end;
                v4:ApplyStatus(v20.Player, "Resistance", {
                    Level = v20.Config.ResistanceLevel, 
                    Duration = v20.Config.BlockDuration
                });
                v20.Player.Character:SetAttribute("HitboxPriority", 3);
                v22 = v20.Rig.QueryHitbox;
                if not v2.DefaultHitboxSize then
                    v2.DefaultHitboxSize = v20.Rig.QueryHitbox.Size;
                end;
                v22.Size = v2.DefaultHitboxSize * Vector3.new(2.0999999046325684, 1.2000000476837158, 2.0999999046325684, 0);
                l_pcall_0 = v3:CreateSpeedMultiplier(v20.Rig, 0.4, "GuestBlocking");
                if v20.BlockingSlowness then
                    v20.BlockingSlowness:Destroy();
                end;
                v20.BlockingSlowness = l_pcall_0;
                task.delay(v20.Config.SlownessDuration, function() --[[ Line: 68 ]]
                    -- upvalues: l_pcall_0 (copy)
                    if l_pcall_0 then
                        game.TweenService:Create(l_pcall_0, TweenInfo.new(1), {
                            Value = 1
                        }):Play();
                        game.Debris:AddItem(l_pcall_0, 1);
                    end;
                end);
                v25 = v20.BlockCount;
                task.delay(2, function() --[[ Line: 77 ]]
                    -- upvalues: v25 (copy), v20 (copy)
                    if v25 == v20.BlockCount then
                        v20.BlockCount = 0;
                    end;
                end);
                if v20.BlockThread then
                    task.cancel(v20.BlockThread);
                end;
                v20.Blocking = true;
                v20.BlockThread = task.delay(v20.Config.BlockDuration, function() --[[ Line: 89 ]]
                    -- upvalues: v20 (copy), v22 (copy), v2 (ref)
                    v20.Blocking = nil;
                    local v26 = ("%*/BlockExpire"):format(script.Parent);
                    local l_v20_0 = v20;
                    local l_pcall_1 = pcall;
                    local v29 = "BlockExpire";
                    local l_l_v20_0_0 = l_v20_0 --[[ copy: 1 -> 5 ]];
                    local l_v29_0 = v29 --[[ copy: 4 -> 6 ]];
                    local v32;
                    l_pcall_1, v32 = l_pcall_1(function() --[[ Line: 24 ]]
                        -- upvalues: l_l_v20_0_0 (copy), l_v29_0 (copy)
                        if l_l_v20_0_0.Behavior[l_v29_0] then
                            l_l_v20_0_0.Behavior[l_v29_0](l_l_v20_0_0);
                        end;
                    end);
                    if not l_pcall_1 then
                        warn((("[%*]: Failed to call .BlockExpire() due to: %*"):format(v26, v32)));
                    end;
                    if not v20.Blocked then
                        v26 = ("%*/BlockEnd"):format(script.Parent);
                        l_v20_0 = v20;
                        l_pcall_1 = pcall;
                        v29 = "BlockEnd";
                        l_pcall_1, v32 = l_pcall_1(function() --[[ Line: 24 ]]
                            -- upvalues: l_v20_0 (copy), v29 (copy)
                            if l_v20_0.Behavior[v29] then
                                l_v20_0.Behavior[v29](l_v20_0);
                            end;
                        end);
                        if not l_pcall_1 then
                            warn((("[%*]: Failed to call .BlockEnd() due to: %*"):format(v26, v32)));
                        end;
                        v22.Size = v2.DefaultHitboxSize;
                    end;
                    v20.Player.Character:SetAttribute("HitboxPriority", 2);
                end);
                v7:Play(v20.Config.Sounds.BlockStart, {
                    Parent = v20.Rig.PrimaryPart
                });
                task.delay(v20.Config.SlownessDuration, function() --[[ Line: 105 ]]
                    -- upvalues: v20 (copy)
                    v20.DisabledAbilities = nil;
                end);
                return;
            else
                if l_RunService_0:IsClient() then
                    v20.Animations.Block:Play(0.175);
                end;
                return;
            end;
        end
    }, 
    Charge = {
        LayoutOrder = 2, 
        KeybindType = "AltAbility2", 
        Icon = "rbxassetid://73254549946762", 
        Callback = function(v33, v34) --[[ Line: 121 ]] --[[ Name: Callback ]]
            -- upvalues: l_RunService_0 (copy), v3 (copy), v5 (copy), v7 (copy), v6 (copy), v9 (copy), l_ReplicatedStorage_0 (copy), v4 (copy)
            if l_RunService_0:IsServer() then
                v33.DisabledAbilities = {
                    Block = true, 
                    Charge = true
                };
                local v35 = v33 and v33.Rig;
                if v35 then
                    v35:SetAttribute("AnimationsDisabled", true);
                    v35:SetAttribute("AnimationsExtraDisabled", true);
                    v35:SetAttribute("UsingItemsDisabled", true);
                end;
                v3:SetSpeedCap(v33.Player, "GuestCharging", v33.Config.ChargingSpeed / v33.Config.Speed);
                local v36 = ("%*/ChargeStart"):format(script.Parent);
                local l_pcall_2 = pcall;
                local v38 = "ChargeStart";
                local v39;
                l_pcall_2, v39 = l_pcall_2(function() --[[ Line: 24 ]]
                    -- upvalues: v33 (copy), v38 (copy)
                    if v33.Behavior[v38] then
                        v33.Behavior[v38](v33);
                    end;
                end);
                if not l_pcall_2 then
                    warn((("[%*]: Failed to call .ChargeStart() due to: %*"):format(v36, v39)));
                end;
                v33.Rig:SetAttribute("GuestCharging", true);
                v36 = ("Result%*"):format((tostring(math.random(-10000, 10000))));
                task.delay(0.125, function() --[[ Line: 141 ]]
                    -- upvalues: v33 (copy), v5 (ref), v7 (ref), v6 (ref), v3 (ref), v9 (ref), l_ReplicatedStorage_0 (ref), v36 (copy), v4 (ref)
                    local l_PrimaryPart_0 = v33.Rig.PrimaryPart;
                    local v41 = nil;
                    local v42 = nil;
                    local l_v5_Hitbox_0 = v5:CreateHitbox(v33.Player, {
                        Size = Vector3.new(4, 5, 6, 0), 
                        CFrameOffset = CFrame.new(0, 0, -1), 
                        Damage = v33.Config.ChargeDamage, 
                        Knockback = function(v43) --[[ Line: 150 ]] --[[ Name: Knockback ]]
                            -- upvalues: v33 (ref)
                            if not v43:GetAttribute("PreviouslyChargedInto") then
                                return v33.Config.ChargeKnockback;
                            else
                                return 0.1;
                            end;
                        end, 
                        Time = v33.Config.ChargingDuration, 
                        HitMultiple = true, 
                        Connections = {
                            Hit = function(v44) --[[ Line: 161 ]] --[[ Name: Hit ]]
                                -- upvalues: v41 (ref), v33 (ref), v7 (ref), l_PrimaryPart_0 (copy), v6 (ref), v3 (ref), v9 (ref), l_ReplicatedStorage_0 (ref)
                                v41 = v44;
                                if v41 then
                                    if not v41:GetAttribute("PreviouslyChargedInto") then
                                        v41:SetAttribute("PreviouslyChargedInto", true);
                                        task.delay(v33.Config.KillerChargeResistanceDuration, function() --[[ Line: 169 ]]
                                            -- upvalues: v41 (ref)
                                            v41:SetAttribute("PreviouslyChargedInto", nil);
                                        end);
                                        v7:Play(v33.Config.Sounds.ChargingHit, {
                                            Parent = l_PrimaryPart_0
                                        });
                                        if v41.Parent == workspace.Players.Killers then
                                            v6:FireAllClientConnection(("%*On1337ChargeHit"):format(v33.Player.Name), "REMOTE_EVENT");
                                        end;
                                        if v41:GetAttribute("VoidRushState") == "Dashing" then
                                            v9:IncrementAchievementProgress(v33.Player, "NoliCar");
                                            v9:IncrementAchievementProgress(game.Players:GetPlayerFromCharacter(v41), "NoliCar");
                                        end;
                                    else
                                        v3:ApplyDamage(v33.Rig, v33.Config.KillerChargeResistanceDamage);
                                        v7:Play(v33.Config.Sounds.ChargingHitWeak, {
                                            Parent = l_PrimaryPart_0
                                        });
                                        return;
                                    end;
                                end;
                                task.spawn(function() --[[ Line: 189 ]]
                                    -- upvalues: l_ReplicatedStorage_0 (ref), v44 (copy)
                                    local v45 = require(l_ReplicatedStorage_0.Modules.Actors).CurrentActors[game.Players:GetPlayerFromCharacter(v44)];
                                    if v45 then
                                        if v45.Behavior and v45.Behavior.Endlag then
                                            return;
                                        else
                                            v45:DisableAbilities("Guest1337Charge", true, 1.25);
                                        end;
                                    end;
                                end);
                                v3:CreateSpeedMultiplier(v44, 0.3, "Guest1337ChargedInto", 0.35);
                            end, 
                            Ended = function() --[[ Line: 204 ]] --[[ Name: Ended ]]
                                -- upvalues: v42 (ref)
                                v42 = true;
                            end
                        }
                    });
                    local v47 = v7:Play(v33.Config.Sounds.ChargingStart, {
                        Parent = l_PrimaryPart_0
                    });
                    local v48 = false;
                    local v49 = ("%*Guest1337Collision"):format(v33.Player.Name);
                    v6:SetConnection(v49, "REMOTE_EVENT", function(v50) --[[ Line: 214 ]]
                        -- upvalues: v33 (ref), v48 (ref)
                        if v50 == v33.Player then
                            v48 = true;
                        end;
                    end);
                    repeat
                        task.wait();
                    until v41 or v42 or v48;
                    local v51 = ("%*/ChargeEnd"):format(script.Parent);
                    local l_v33_0 = v33;
                    local l_pcall_3 = pcall;
                    local v54 = "ChargeEnd";
                    local l_l_v33_0_0 = l_v33_0 --[[ copy: 8 -> 12 ]];
                    local l_v54_0 = v54 --[[ copy: 11 -> 13 ]];
                    local v57;
                    l_pcall_3, v57 = l_pcall_3(function() --[[ Line: 24 ]]
                        -- upvalues: l_l_v33_0_0 (copy), l_v54_0 (copy)
                        if l_l_v33_0_0.Behavior[l_v54_0] then
                            l_l_v33_0_0.Behavior[l_v54_0](l_l_v33_0_0);
                        end;
                    end);
                    if not l_pcall_3 then
                        warn((("[%*]: Failed to call .ChargeEnd() due to: %*"):format(v51, v57)));
                    end;
                    v33.Rig:SetAttribute("GuestCharging", nil);
                    v51 = "IDK";
                    if v41 then
                        v51 = "Hit";
                    elseif v48 then
                        v51 = "Collide";
                    elseif v42 then
                        v51 = "Timeout";
                    end;
                    v7:PlayVoiceline(v33, ("Charge%*"):format(v51), {
                        Priority = 1
                    });
                    l_v33_0 = Instance.new("StringValue");
                    l_v33_0.Name = v36;
                    l_v33_0.Value = v51;
                    l_v33_0.Parent = v33.Rig;
                    game.Debris:AddItem(l_v33_0, 1);
                    if v51 == "Hit" then
                        v4:ApplyStatus(v33.Player, "Resistance", {
                            Level = 5, 
                            Duration = 1.25
                        });
                    else
                        l_pcall_3, v57 = v3:GetClosestPlayerFromPosition(l_PrimaryPart_0.Position, {
                            PlayerSelection = "Killers"
                        });
                        if not v57 then
                            v57 = 999;
                        end;
                        v54 = math.clamp(math.floor(v57 / v33.Config.ChargePunishmentDistanceInterval) * v33.Config.ChargePunishmentSlownessDurationMultiplier, 0, v33.Config.ChargePunishmentSlownessMaxDuration);
                        if v54 > 0 then
                            v4:ApplyStatus(v33.Player, "Slowness", {
                                Duration = v54, 
                                Level = v33.Config.ChargePunishmentSlownessLevel
                            });
                        end;
                    end;
                    task.delay(0.25, function() --[[ Line: 261 ]]
                        -- upvalues: v33 (ref)
                        v33.DisabledAbilities = nil;
                    end);
                    l_pcall_3 = v33 and v33.Rig;
                    if l_pcall_3 then
                        l_pcall_3:SetAttribute("AnimationsDisabled", nil);
                        l_pcall_3:SetAttribute("AnimationsExtraDisabled", nil);
                        l_pcall_3:SetAttribute("UsingItemsDisabled", nil);
                    end;
                    if v47 then
                        game.TweenService:Create(v47, TweenInfo.new(0.2), {
                            Volume = 0
                        }):Play();
                    end;
                    if v51 ~= "Hit" then
                        v7:Play(v33.Config.Sounds[("Charging%*"):format(v51)], {
                            Parent = l_PrimaryPart_0
                        });
                    end;
                    v6:RemoveConnection(v49, "REMOTE_EVENT");
                    l_v5_Hitbox_0:Cancel();
                    v3:SetSpeedCap(v33.Player, "GuestCharging", nil);
                end);
                return v36;
            else
                if l_RunService_0:IsClient() then
                    v33.Animations.Charge:Play();
                    v33.MovementAnimSpeed = 2.25;
                    v6:FireConnection("DisableSprinting", "GuestCharge", true);
                    local v58 = require(l_ReplicatedStorage_0.Systems.Character.Game.Sprinting);
                    v58.StaminaCap = tonumber(v58.Stamina) or 100;
                    local l_v3_FOVMultiplier_0 = v3:CreateFOVMultiplier(v33.Player, 1, "Guest1337Charge");
                    game.TweenService:Create(l_v3_FOVMultiplier_0, TweenInfo.new(0.8), {
                        Value = 0.75
                    }):Play();
                    local l_v3_SpeedMultiplier_0 = v3:CreateSpeedMultiplier(v33.Rig, v33.Config.ChargingSpeed / v33.Config.Speed, "Guest1337Charge");
                    local l_LookVector_0 = workspace.CurrentCamera.CFrame.LookVector;
                    local l_Unit_0 = Vector3.new(l_LookVector_0.X, 0, l_LookVector_0.Z).Unit;
                    local v63 = Vector3.new(0, 0, 0, 0);
                    local v64 = 0;
                    local v65 = false;
                    pcall(function() --[[ Line: 308 ]]
                        -- upvalues: l_RunService_0 (ref)
                        l_RunService_0:UnbindFromRenderStep("GuestCharging");
                    end);
                    do
                        local l_l_Unit_0_0, l_v63_0, l_v64_0, l_v65_0 = l_Unit_0, v63, v64, v65;
                        l_RunService_0:BindToRenderStep("GuestCharging", Enum.RenderPriority.Character.Value + 1, function(v70) --[[ Line: 309 ]]
                            -- upvalues: v33 (copy), l_RunService_0 (ref), l_v64_0 (ref), l_v65_0 (ref), v6 (ref), l_v63_0 (ref), l_l_Unit_0_0 (ref)
                            if not v33.Rig.Parent or not v33.Rig.PrimaryPart then
                                l_RunService_0:UnbindFromRenderStep("GuestCharging");
                                return;
                            else
                                l_v64_0 = l_v64_0 + v70;
                                if l_v64_0 >= 0.3 and v33.Rig.PrimaryPart.Velocity.Magnitude <= v33.Config.ChargingSpeed / 2 then
                                    if not l_v65_0 then
                                        l_v65_0 = true;
                                        v6:FireServerConnection(("%*Guest1337Collision"):format(v33.Player.Name), "REMOTE_EVENT");
                                    end;
                                    return;
                                else
                                    local l_LookVector_1 = workspace.CurrentCamera.CFrame.LookVector;
                                    l_v63_0 = Vector3.new(l_LookVector_1.X, 0, l_LookVector_1.Z).Unit;
                                    local v72 = l_v63_0 - l_l_Unit_0_0;
                                    local l_Magnitude_0 = v72.Magnitude;
                                    if l_Magnitude_0 > 0 then
                                        local v74 = v33.Config.ChargingTurnSpeed * v70;
                                        if l_Magnitude_0 <= v74 then
                                            l_l_Unit_0_0 = l_v63_0;
                                        else
                                            l_l_Unit_0_0 = l_l_Unit_0_0 + v72.Unit * v74;
                                        end;
                                        l_l_Unit_0_0 = l_l_Unit_0_0.Unit;
                                    end;
                                    v33.Rig.Humanoid:Move(l_l_Unit_0_0);
                                    return;
                                end;
                            end;
                        end);
                        local v75 = v33.Rig:WaitForChild(v34, v33.Config.ChargingDuration + 0.5);
                        local v76 = v75 and v75.Value;
                        if v75 then
                            v75:Destroy();
                        end;
                        if v76 == "Hit" or v76 == "Collide" then
                            local l_v3_SpeedMultiplier_1 = v3:CreateSpeedMultiplier(v33.Rig, 0.2, "GuestChargeEnded");
                            game.TweenService:Create(l_v3_SpeedMultiplier_1, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                                Value = 1
                            }):Play();
                            game.Debris:AddItem(l_v3_SpeedMultiplier_1, 1);
                        end;
                        l_RunService_0:UnbindFromRenderStep("GuestCharging");
                        v6:FireConnection("DisableSprinting", "GuestCharge", false);
                        v33.Animations.Charge:Stop();
                        v33.MovementAnimSpeed = nil;
                        v58.StaminaCap = nil;
                        game.TweenService:Create(l_v3_FOVMultiplier_0, TweenInfo.new(0.4), {
                            Value = 1
                        }):Play();
                        game.Debris:AddItem(l_v3_FOVMultiplier_0, 0.4);
                        l_v3_SpeedMultiplier_0:Destroy();
                    end;
                end;
                return;
            end;
        end
    }, 
    Punch = {
        LayoutOrder = 3, 
        KeybindType = "AltAbility3", 
        Charges = 0, 
        Icon = "rbxassetid://86535502112498", 
        Callback = function(v78, v79) --[[ Line: 379 ]] --[[ Name: Callback ]]
            -- upvalues: l_RunService_0 (copy), v4 (copy), v7 (copy), v3 (copy), v5 (copy), v9 (copy), l_ReplicatedStorage_0 (copy), v6 (copy)
            local v80 = v78.Blocked or v79;
            local v81 = v80 and "Parry" or "Punch";
            local function _(v82) --[[ Line: 383 ]] --[[ Name: getConfig ]]
                -- upvalues: v78 (copy), v81 (copy)
                return v78.Config[("%*%*"):format(v81, v82)];
            end;
            if l_RunService_0:IsServer() then
                v78.AbilitiesDisabled = true;
                task.delay(2, function() --[[ Line: 390 ]]
                    -- upvalues: v78 (copy)
                    v78.AbilitiesDisabled = false;
                end);
                if v81 == "Parry" then
                    v4:ApplyStatus(v78.Rig, "Resistance", {
                        Level = 3, 
                        Duration = v78.Config.ParryWindupTime
                    });
                    local v84 = ("%*/Start"):format(script.Parent);
                    local l_pcall_4 = pcall;
                    local v86 = "ParryStart";
                    local v87;
                    l_pcall_4, v87 = l_pcall_4(function() --[[ Line: 24 ]]
                        -- upvalues: v78 (copy), v86 (copy)
                        if v78.Behavior[v86] then
                            v78.Behavior[v86](v78);
                        end;
                    end);
                    if not l_pcall_4 then
                        warn((("[%*]: Failed to call .ParryStart() due to: %*"):format(v84, v87)));
                    end;
                elseif v81 == "Punch" then
                    v4:ApplyStatus(v78.Rig, "Resistance", {
                        Level = 2, 
                        Duration = v78.Config.PunchWindupTime
                    });
                end;
                v7:Play(v78.Config.Sounds.PunchWindup, {
                    Parent = v78.Rig.PrimaryPart
                });
                v7:PlayVoiceline(v78, ("%*Windup"):format(v81), {
                    Priority = 1
                });
                task.delay(v78.Config[("%*WindupTime"):format(v81)], function() --[[ Line: 406 ]]
                    -- upvalues: v3 (ref), v78 (copy), v81 (copy), v5 (ref), v7 (ref), v4 (ref), v80 (copy), v9 (ref), l_ReplicatedStorage_0 (ref)
                    local v88 = v3:ApplyVelocity(v78.Rig.PrimaryPart, v78.Config[("%*DashForce"):format(v81)]);
                    game.Debris:AddItem(v88, 0.1);
                    local _ = v5:CreateHitbox(v78.Player, {
                        Size = Vector3.new(4.5, 6, 7.5, 0), 
                        CFrameOffset = CFrame.new(0, 0, -1), 
                        Damage = v78.Config[("%*Damage"):format(v81)], 
                        Time = 0.25, 
                        Knockback = v78.Config[("%*Knockback"):format(v81)], 
                        HitMultiple = true, 
                        Connections = {
                            Hit = function(v89) --[[ Line: 423 ]] --[[ Name: Hit ]]
                                -- upvalues: v7 (ref), v78 (ref), v81 (ref), v4 (ref), v80 (ref), v9 (ref), l_ReplicatedStorage_0 (ref)
                                v7:Play(v78.Config.Sounds[v81], {
                                    Parent = v89.PrimaryPart or v78.Rig.PrimaryPart
                                });
                                v7:PlayVoiceline(v78, ("%*Hit"):format(v81), {
                                    Priority = 1
                                });
                                v4:ApplyStatus(v89, "Stunned", {
                                    Level = 1, 
                                    Duration = v78.Config[("%*StunTime"):format(v81)]
                                });
                                if v80 then
                                    v9:IncrementAchievementProgress(v78.Player, "GuestParry");
                                    local v90 = ("%*/Hit"):format(script.Parent);
                                    local l_v78_0 = v78;
                                    local l_pcall_5 = pcall;
                                    local v93 = "ParryHit";
                                    local l_l_v78_0_0 = l_v78_0 --[[ copy: 2 -> 7 ]];
                                    local l_v93_0 = v93 --[[ copy: 5 -> 8 ]];
                                    local v96;
                                    l_pcall_5, v96 = l_pcall_5(function() --[[ Line: 24 ]]
                                        -- upvalues: l_l_v78_0_0 (copy), l_v93_0 (copy)
                                        if l_l_v78_0_0.Behavior[l_v93_0] then
                                            l_l_v78_0_0.Behavior[l_v93_0](l_l_v78_0_0);
                                        end;
                                    end);
                                    if not l_pcall_5 then
                                        warn((("[%*]: Failed to call .ParryHit() due to: %*"):format(v90, v96)));
                                    end;
                                end;
                                if v78.Rig.PrimaryPart.AssemblyLinearVelocity.Y < -8 then
                                    v7:Play(v78.Config.Sounds.CriticalPunch, {
                                        Parent = v89.PrimaryPart or v78.Rig.PrimaryPart
                                    });
                                    v9:IncrementAchievementProgress(v78.Player, "GuestAlpha");
                                end;
                                local v97 = v80 and "Parried" or "Punched";
                                v78.Rig:SetAttribute(v97, true);
                                task.delay(0.25, function() --[[ Line: 441 ]]
                                    -- upvalues: v78 (ref), v97 (copy)
                                    v78.Rig:SetAttribute(v97, nil);
                                end);
                                local v98 = require(l_ReplicatedStorage_0.Modules.Actors);
                                if v80 then
                                    local l_v78_1 = v78;
                                    local l_pcall_6 = pcall;
                                    local v101 = "OnParry";
                                    local v102;
                                    l_pcall_6, v102 = l_pcall_6(function() --[[ Line: 24 ]]
                                        -- upvalues: l_v78_1 (copy), v101 (copy)
                                        if l_v78_1.Behavior[v101] then
                                            l_v78_1.Behavior[v101](l_v78_1);
                                        end;
                                    end);
                                    if not l_pcall_6 then
                                        warn((("[Guest1337]: Failed to call .OnParry() due to: %*"):format(v102)));
                                    end;
                                    v98:IncrementActorStats(v78.Player, {
                                        Action = "Parried Killer as Guest 1337", 
                                        RewardType = "Offensive"
                                    });
                                    return;
                                else
                                    v98:IncrementActorStats(v78.Player, {
                                        Action = "Punched Killer as Guest 1337", 
                                        RewardType = "Offensive"
                                    });
                                    return;
                                end;
                            end
                        }
                    });
                end);
                return v80;
            else
                if l_RunService_0:IsClient() then
                    local v104 = v78.Animations[v80 and "ParryPunch" or "Punch"];
                    if v104 then
                        v104:Play();
                        if not v78.Config.RawAnims then
                            v104:AdjustSpeed((v104.Length - 0.55) / v78.Config[("%*WindupTime"):format(v81)]);
                        end;
                    end;
                    v6:FireConnection("DisableSprinting", "GuestPunch", true);
                    local l_v3_SpeedMultiplier_2 = v3:CreateSpeedMultiplier(v78.Rig, 1, "PunchAbility");
                    game.TweenService:Create(l_v3_SpeedMultiplier_2, TweenInfo.new(0.25), {
                        Value = 0.25
                    }):Play();
                    task.wait(v80 and v78.Config.ParryWindupTime or v78.Config.PunchWindupTime);
                    task.wait(0.8);
                    v6:FireConnection("DisableSprinting", "GuestPunch", false);
                    game.TweenService:Create(l_v3_SpeedMultiplier_2, TweenInfo.new(0.15), {
                        Value = 1
                    }):Play();
                    game.Debris:AddItem(l_v3_SpeedMultiplier_2, 0.15);
                end;
                return;
            end;
        end
    }
};
v2.cl_OnChargeProcGlobal = function(_, v107, v108) --[[ Line: 498 ]] --[[ Name: cl_OnChargeProcGlobal ]]
    -- upvalues: v7 (copy)
    v7:Play(v107.Config.Sounds.ChargeCooldownActivated);
    local l_Charge_0 = v107.Behavior.Abilities.Charge;
    if l_Charge_0 then
        l_Charge_0.CurrentRecharge = 0;
        l_Charge_0.ChargeDuration = v108.Config.KillerChargeResistanceDuration;
    end;
end;
v2.OnHit = function(_, v111, v112) --[[ Line: 507 ]] --[[ Name: OnHit ]]
    -- upvalues: v7 (copy), v3 (copy), v4 (copy), v2 (copy), l_ReplicatedStorage_0 (copy), v9 (copy)
    if not v112.IsProjectile and v112.Creator and v111.Blocking then
        v111.Blocking = nil;
        v111:IncrementCharges("Punch", 1, 1);
        v7:Play(v111.Config.Sounds.BlockSuccess, {
            Parent = v111.Rig.PrimaryPart
        });
        local v113 = typeof(v112.Damage) == "function" and v112.Damage(v111.Rig) or v112.Damage or 0;
        local l_Health_0 = v111.Rig.Humanoid.Health;
        v3:ApplyDamage(v111.Rig, v113);
        local l_v3_SpeedMultiplier_3 = v3:CreateSpeedMultiplier(v112.Creator, 1 * v111.Config.KillerSlownessPercent / 100);
        if l_v3_SpeedMultiplier_3 then
            game.Debris:AddItem(l_v3_SpeedMultiplier_3, v111.Config.KillerSlownessDuration);
        end;
        v4:ApplyStatus(v111.Player, "Speed", {
            Level = v111.Config.BlockSpeedLevel, 
            Duration = v111.Config.BlockSpeedDuration
        });
        v4:RemoveStatus(v111.Player, "Resistance");
        if v111.BlockingSlowness then
            game.TweenService:Create(v111.BlockingSlowness, TweenInfo.new(1), {
                Value = 1
            }):Play();
            game.Debris:AddItem(v111.BlockingSlowness, 1);
            v111.BlockingSlowness = nil;
        end;
        if v111.BlockedThread then
            task.cancel(v111.BlockedThread);
        end;
        v111.Blocked = true;
        v111.BlockedThread = task.delay(v111.Config.BlockDuration, function() --[[ Line: 542 ]]
            -- upvalues: v111 (copy)
            v111.Blocked = nil;
        end);
        local v116 = ("%*/BlockEnd"):format(script.Parent);
        local l_pcall_7 = pcall;
        local v118 = "BlockEnd";
        local l_v118_0 = v118 --[[ copy: 9 -> 10 ]];
        local v120;
        l_pcall_7, v120 = l_pcall_7(function() --[[ Line: 24 ]]
            -- upvalues: v111 (copy), l_v118_0 (copy)
            if v111.Behavior[l_v118_0] then
                v111.Behavior[l_v118_0](v111);
            end;
        end);
        if not l_pcall_7 then
            warn((("[%*]: Failed to call .BlockEnd() due to: %*"):format(v116, v120)));
        end;
        v116 = v111.Rig:FindFirstChild("QueryHitbox");
        if v116 and v2.DefaultHitboxSize then
            v116.Size = v2.DefaultHitboxSize;
        end;
        require(l_ReplicatedStorage_0.Modules.Actors):IncrementActorStats(v111.Player, {
            Action = "Successfully blocked an attack", 
            RewardType = "Survivalist"
        });
        if not v111.BlockCount then
            v111.BlockCount = 0;
        end;
        v111.BlockCount = v111.BlockCount + 1;
        if v111.BlockCount >= 3 then
            v9:IncrementAchievementProgress(v111.Player, "GuestBlock");
        end;
        v120 = l_Health_0 < v113;
        v118 = require(game.ServerScriptService.Server.Systems.Core.RoundManager);
        if v120 and v118.CurrentSession and v118.CurrentSession.LastSurvivorAlive then
            v111.Daigo = true;
        end;
        return "Ignored";
    else
        return;
    end;
end;
v2.Created = function(_, v122) --[[ Line: 578 ]] --[[ Name: Created ]]
    -- upvalues: l_RunService_0 (copy), v6 (copy), v3 (copy)
    if l_RunService_0:IsServer() then
        v122.Rig:SetAttribute("HitboxPriority", 2);
        return;
    else
        v6:SetConnection(("%*On1337ChargeHit"):format(v122.Player.Name), "REMOTE_EVENT", function() --[[ Line: 583 ]]
            -- upvalues: v3 (ref), v122 (copy)
            local l_v3_Actor_0 = v3:GetActor(game.Players.LocalPlayer);
            if v122 and l_v3_Actor_0 and l_v3_Actor_0.Behavior.cl_OnChargeProcGlobal then
                l_v3_Actor_0.Behavior:cl_OnChargeProcGlobal(l_v3_Actor_0, v122);
            end;
        end);
        return;
    end;
end;
v2.CreatedPost = function(_, v125) --[[ Line: 592 ]] --[[ Name: CreatedPost ]]
    -- upvalues: l_RunService_0 (copy), v8 (copy), v10 (copy), v11 (copy), v12 (copy), v13 (copy)
    if l_RunService_0:IsServer() or v125.Player ~= game.Players.LocalPlayer then
        return;
    else
        local v126 = v125.Player.PlayerGui.MainUI:WaitForChild("AbilityContainer", 5);
        local v127 = v126 and v126:WaitForChild("Punch", 5);
        local v128 = v8.new();
        v125.__parryTrove = v128;
        if v127 then
            v127.Charges:GetPropertyChangedSignal("Text"):Connect(function() --[[ Line: 604 ]]
                -- upvalues: v127 (copy), v10 (ref), v11 (ref), v12 (ref), v13 (ref), v125 (copy), v128 (copy)
                local v129 = tonumber(v127.Charges.Text);
                if not v129 then
                    return;
                else
                    local v130 = v129 and v129 >= 1 and v10 or v11;
                    local v131 = v129 and v129 >= 1 and v12 or v13;
                    v127.ImageColor3 = v130;
                    v125.Behavior.Abilities.Punch.Icon = v129 and v129 >= 1 and "rbxassetid://76339130778616" or "rbxassetid://86535502112498";
                    v127.KeybindName.TextColor3 = v131;
                    v127.AbilityName.TextColor3 = v131;
                    v127.Charges.TextColor3 = v131;
                    if v129 >= 1 then
                        local v132 = v125.Config.ParryUIStroke:Clone();
                        v132.Parent = v127.AbilityName;
                        v128:Add(v132);
                        return;
                    else
                        v128:Destroy();
                        return;
                    end;
                end;
            end);
        end;
        return;
    end;
end;
v2.Destroyed = function(_, v134) --[[ Line: 631 ]] --[[ Name: Destroyed ]]
    -- upvalues: l_RunService_0 (copy), v6 (copy)
    if l_RunService_0:IsServer() then
        return;
    elseif not v134.__parryTrove then
        return;
    else
        v134.__parryTrove:Destroy();
        v134.__parryTrove = nil;
        v6:RemoveConnection(("%*On1337ChargeHit"):format(v134.Player.Name), "REMOTE_EVENT");
        return;
    end;
end;
return v2;]==========]}
}
local function install()
-- Complete the Guest Rework replacement already started in fct4.rbxl. Run in Edit mode.
assert(game:GetService("RunService"):IsStudio() and not game:GetService("RunService"):IsRunning(),"Stop Play before replacing Guest.")
local function find(path)
 local current=game
 for name in path:gmatch("[^/]+") do current=current and current:FindFirstChild(name) end
 return current
end
local function fingerprint(source)
 local a,b=5381,0
 for i=1,#source do local byte=string.byte(source,i);a=(a*33+byte)%4294967296;b=(b*65599+byte)%4294967296 end
 return string.format("%d:%08x:%08x",#source,a,b)
end
local replacement=[========[
-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local l_ReplicatedStorage_0 = game:GetService("ReplicatedStorage");
local l_RunService_0 = game:GetService("RunService");
local v2 = {};
local v3 = require(l_ReplicatedStorage_0.Modules.Util);
local v4 = require(l_ReplicatedStorage_0.Modules.Statuses);
local v5 = require(l_ReplicatedStorage_0.Modules.Hitboxes);
local v6 = require(l_ReplicatedStorage_0.Modules.Network);
local v7 = require(l_ReplicatedStorage_0.Modules.Sounds);
local v8 = require(l_ReplicatedStorage_0.Modules.Misc.Trove);
local v9 = require(l_ReplicatedStorage_0.Modules.AchievementUtil);
local v10 = Color3.new(1, 1, 1);
local v11 = Color3.new(0.392157, 0.392157, 0.392157);
local v12 = Color3.new(1, 0.933333, 0.027451);
local v13 = Color3.new(1, 1, 1);
local function _(v14, v15, v16) --[[ Line: 23 ]] --[[ Name: pcallMethod ]]
	local l_status_0, l_result_0 = pcall(function() --[[ Line: 24 ]]
		-- upvalues: v16 (copy), v14 (copy)
		if v16.Behavior[v14] then
			v16.Behavior[v14](v16);
		end;
	end);
	if not l_status_0 then
		warn((("[%*]: Failed to call .%*() due to: %*"):format(v15, v14, l_result_0)));
	end;
end;
-- Block owns a separate ability lock, so its timers cannot clear another ability's lock.
local function cancelGuestBlockTask(actor, name)
	local thread = actor[name]
	actor[name] = nil
	if thread then pcall(task.cancel, thread) end
end

local function clearGuestBlockSlow(actor)
	if actor.BlockingSlowness then
		actor.BlockingSlowness:Destroy()
		actor.BlockingSlowness = nil
	end
end

local function restoreGuestBlockHitbox(actor)
	local rig = actor.Rig
	if not rig then return end
	local query = rig:FindFirstChild("QueryHitbox")
	if query and actor.__blockDefaultHitboxSize then
		query.Size = actor.__blockDefaultHitboxSize
	end
	rig:SetAttribute("HitboxPriority", 2)
end

local function callGuestBlockHook(actor, name)
	local hook = actor.Behavior and actor.Behavior[name]
	if hook then
		local ok, err = pcall(hook, actor)
		if not ok then warn("[Guest Rework] " .. name .. ": " .. tostring(err)) end
	end
end

local function resolveGuestBlock(actor)
	actor.Blocking = nil
	actor.BlockSucceeded = true
	cancelGuestBlockTask(actor, "BlockThread")
	cancelGuestBlockTask(actor, "__blockSlowThread")
	cancelGuestBlockTask(actor, "__blockUnlockThread")
	clearGuestBlockSlow(actor)
	restoreGuestBlockHitbox(actor)
	actor:DisableAbilities("GuestReworkBlock", false)
end

local function setGuestParryWindow(actor, active)
	actor.Blocked = active and true or nil
	if actor.Rig then
		actor.Rig:SetAttribute("GuestReworkParryUntil",
			active and (workspace:GetServerTimeNow() + actor.Config.BlockDuration) or 0)
	end
end

local function stopGuestParryMotion(rig)
	local root = rig and rig.PrimaryPart
	if not root or not root.Parent then return end
	local velocity = root.AssemblyLinearVelocity
	root.AssemblyLinearVelocity = Vector3.new(0, velocity.Y, 0)
end

v2.Abilities = {
	Block = {
		LayoutOrder = 1,
		KeybindType = "AltAbility1",
		Icon = "rbxassetid://137576632569674",
		Callback = function(actor)
			if l_RunService_0:IsClient() then
				if actor.Animations.Block then
					actor.Animations.Block:Play(0.175)
				end
				return
			end

			local rig = actor.Rig
			local humanoid = rig and rig:FindFirstChildOfClass("Humanoid")
			if not humanoid or humanoid.Health <= 0 then return end

			cancelGuestBlockTask(actor, "BlockThread")
			cancelGuestBlockTask(actor, "__blockSlowThread")
			cancelGuestBlockTask(actor, "__blockUnlockThread")
			cancelGuestBlockTask(actor, "BlockedThread")
			setGuestParryWindow(actor, false)
			actor.Blocking = true
			actor.BlockSucceeded = false
			actor:DisableAbilities("GuestReworkBlock", true)
			callGuestBlockHook(actor, "BlockStart")
			v4:ApplyStatus(actor.Player, "Resistance", {
				Level = actor.Config.ResistanceLevel,
				Duration = actor.Config.BlockDuration
			})
			rig:SetAttribute("HitboxPriority", 3)
			local query = rig:FindFirstChild("QueryHitbox")
			if query then
				actor.__blockDefaultHitboxSize = actor.__blockDefaultHitboxSize or query.Size
				query.Size = actor.__blockDefaultHitboxSize * Vector3.new(2.1, 1.2, 2.1)
			end
			clearGuestBlockSlow(actor)
			actor.BlockingSlowness = v3:CreateSpeedMultiplier(rig, 0.5, "GuestBlocking")
			actor.__blockSlowThread = task.delay(actor.Config.SlownessDuration, function()
				actor.__blockSlowThread = nil
				clearGuestBlockSlow(actor)
			end)

			local previousBlockCount = actor.BlockCount
			task.delay(2, function()
				if actor.BlockCount == previousBlockCount then actor.BlockCount = 0 end
			end)

			actor.BlockThread = task.delay(actor.Config.BlockDuration, function()
				actor.BlockThread = nil
				if not actor.Blocking then return end
				actor.Blocking = nil
				restoreGuestBlockHitbox(actor)
				callGuestBlockHook(actor, "BlockExpire")
				callGuestBlockHook(actor, "BlockEnd")
				-- Failure means the full guard window elapsed without a hit.
				-- Keep this named lock for TWO SECONDS AFTER that failure.
				actor.__blockUnlockThread = task.delay(actor.Config.FailedBlockAbilityLockout, function()
					actor.__blockUnlockThread = nil
					actor:DisableAbilities("GuestReworkBlock", false)
				end)
			end)
			v7:Play(actor.Config.Sounds.BlockStart, { Parent = rig.PrimaryPart })
		end
	},
	Charge = {
		LayoutOrder = 2, 
		KeybindType = "AltAbility2", 
		Icon = "rbxassetid://73254549946762", 
		Callback = function(v33, v34) --[[ Line: 121 ]] --[[ Name: Callback ]]
			-- upvalues: l_RunService_0 (copy), v3 (copy), v5 (copy), v7 (copy), v6 (copy), v9 (copy), l_ReplicatedStorage_0 (copy), v4 (copy)
			if l_RunService_0:IsServer() then
				v33.DisabledAbilities = {
					Block = true,
					Charge = true,
					Punch = true
				};
				local chargeStartedAt = workspace:GetServerTimeNow()
				local v35 = v33 and v33.Rig;
				if v35 then
					v35:SetAttribute("AnimationsDisabled", true);
					v35:SetAttribute("AnimationsExtraDisabled", true);
					v35:SetAttribute("UsingItemsDisabled", true);
				end;
				v3:SetSpeedCap(v33.Player, "GuestCharging", v33.Config.ChargingSpeed / v33.Config.Speed);
				local v36 = ("%*/ChargeStart"):format(script.Parent);
				local l_pcall_2 = pcall;
				local v38 = "ChargeStart";
				local v39;
				l_pcall_2, v39 = l_pcall_2(function() --[[ Line: 24 ]]
					-- upvalues: v33 (copy), v38 (copy)
					if v33.Behavior[v38] then
						v33.Behavior[v38](v33);
					end;
				end);
				if not l_pcall_2 then
					warn((("[%*]: Failed to call .ChargeStart() due to: %*"):format(v36, v39)));
				end;
				v33.Rig:SetAttribute("GuestCharging", true);
				v36 = ("Result%*"):format((tostring(math.random(-10000, 10000))));
				task.delay(0.125, function() --[[ Line: 141 ]]
					-- upvalues: v33 (copy), v5 (ref), v7 (ref), v6 (ref), v3 (ref), v9 (ref), l_ReplicatedStorage_0 (ref), v36 (copy), v4 (ref)
					local l_PrimaryPart_0 = v33.Rig.PrimaryPart;
					local v41 = nil;
					local v42 = nil;
					local l_v5_Hitbox_0 = v5:CreateHitbox(v33.Player, {
						FriendlyFire = true,
						AbilityType = "AltAbility2",
						Size = Vector3.new(4, 5, 6, 0), 
						CFrameOffset = CFrame.new(0, 0, -1), 
						Damage = function(target)
							if target:GetAttribute("PreviouslyChargedInto") then
								return 0
							end

							return v33.Config.ChargeDamage
						end,
						Knockback = function(target)
							if target:GetAttribute("PreviouslyChargedInto") then
								return 0
							end

							local elapsed = workspace:GetServerTimeNow() - chargeStartedAt
							local progress = math.clamp(
								elapsed / v33.Config.ChargeKnockbackRampTime,
								0,
								1
							)

							local knockback = v33.Config.ChargeKnockback
								+ (
									v33.Config.ChargeKnockbackTotal
									- v33.Config.ChargeKnockback
								) * progress

							local Actors = require(game.ReplicatedStorage.Modules.Actors)
							local extraGuests = 0

							for _, actor in pairs(Actors.CurrentActors) do
								local humanoid = actor.Rig
									and actor.Rig:FindFirstChildOfClass("Humanoid")

								if actor ~= v33
									and actor.ActorName == "Guest1337"
									and humanoid
									and humanoid.Health > 0 then

									extraGuests += 1
								end
							end

							return knockback * math.max(0, 1 - 0.10 * extraGuests)
						end,
						Time = v33.Config.ChargingDuration, 
						HitMultiple = true, 
						Connections = {
							Hit = function(v44) --[[ Line: 161 ]] --[[ Name: Hit ]]
								-- upvalues: v41 (ref), v33 (ref), v7 (ref), l_PrimaryPart_0 (copy), v6 (ref), v3 (ref), v9 (ref), l_ReplicatedStorage_0 (ref)
								v41 = v44;
								if v41 then
									if not v41:GetAttribute("PreviouslyChargedInto") then
										v41:SetAttribute("PreviouslyChargedInto", true);
										task.delay(v33.Config.KillerChargeResistanceDuration, function() --[[ Line: 169 ]]
											-- upvalues: v41 (ref)
											v41:SetAttribute("PreviouslyChargedInto", nil);
										end);
										v7:Play(v33.Config.Sounds.ChargingHit, {
											Parent = l_PrimaryPart_0
										});
										if v41.Parent == workspace.Players.Killers then
											v6:FireAllClientConnection(("%*On1337ChargeHit"):format(v33.Player.Name), "REMOTE_EVENT");
										end;
										if v41:GetAttribute("VoidRushState") == "Dashing" then
											v9:IncrementAchievementProgress(v33.Player, "NoliCar");
											v9:IncrementAchievementProgress(game.Players:GetPlayerFromCharacter(v41), "NoliCar");
										end;
									else
										v3:ApplyDamage(v33.Rig, v33.Config.KillerChargeResistanceDamage);
										v7:Play(v33.Config.Sounds.ChargingHitWeak, {
											Parent = l_PrimaryPart_0
										});
										return;
									end;
								end;                                
							end, 
							Ended = function() --[[ Line: 204 ]] --[[ Name: Ended ]]
								-- upvalues: v42 (ref)
								v42 = true;
							end
						}
					});
					local v47 = v7:Play(v33.Config.Sounds.ChargingStart, {
						Parent = l_PrimaryPart_0
					});
					local v48 = false;
					local v49 = ("%*Guest1337Collision"):format(v33.Player.Name);
					v6:SetConnection(v49, "REMOTE_EVENT", function(v50) --[[ Line: 214 ]]
						-- upvalues: v33 (ref), v48 (ref)
						if v50 == v33.Player then
							v48 = true;
						end;
					end);
					repeat
						task.wait();
					until v41 or v42 or v48;
					local v51 = ("%*/ChargeEnd"):format(script.Parent);
					local l_v33_0 = v33;
					local l_pcall_3 = pcall;
					local v54 = "ChargeEnd";
					local l_l_v33_0_0 = l_v33_0 --[[ copy: 8 -> 12 ]];
					local l_v54_0 = v54 --[[ copy: 11 -> 13 ]];
					local v57;
					l_pcall_3, v57 = l_pcall_3(function() --[[ Line: 24 ]]
						-- upvalues: l_l_v33_0_0 (copy), l_v54_0 (copy)
						if l_l_v33_0_0.Behavior[l_v54_0] then
							l_l_v33_0_0.Behavior[l_v54_0](l_l_v33_0_0);
						end;
					end);
					if not l_pcall_3 then
						warn((("[%*]: Failed to call .ChargeEnd() due to: %*"):format(v51, v57)));
					end;
					v33.Rig:SetAttribute("GuestCharging", nil);
					v51 = "IDK";
					if v41 then
						v51 = "Hit";
					elseif v48 then
						v51 = "Collide";
					elseif v42 then
						v51 = "Timeout";
					end;
					v7:PlayVoiceline(v33, ("Charge%*"):format(v51), {
						Priority = 1
					});
					l_v33_0 = Instance.new("StringValue");
					l_v33_0.Name = v36;
					l_v33_0.Value = v51;
					l_v33_0.Parent = v33.Rig;
					game.Debris:AddItem(l_v33_0, 1);
					if v51 == "Hit"
						and v41
						and (
							v41.Parent == workspace.Players.Killers
								or v41.Parent == workspace.Players.Survivors
						) then

						v4:ApplyStatus(v33.Player, "Resistance", {
							Level = 3,
							Duration = 0.5
						});
					else
						l_pcall_3, v57 = v3:GetClosestPlayerFromPosition(l_PrimaryPart_0.Position, {
							PlayerSelection = "Killers"
						});
						if not v57 then
							v57 = 999;
						end;
						v54 = math.clamp(math.floor(v57 / v33.Config.ChargePunishmentDistanceInterval) * v33.Config.ChargePunishmentSlownessDurationMultiplier, 0, v33.Config.ChargePunishmentSlownessMaxDuration);
						if v54 > 0 then
							v4:ApplyStatus(v33.Player, "Slowness", {
								Duration = v54, 
								Level = v33.Config.ChargePunishmentSlownessLevel
							});
						end;
					end;
					task.delay(v33.Config.ChargeAbilityLockout, function()
						v33.DisabledAbilities = nil;
					end);
					l_pcall_3 = v33 and v33.Rig;
					if l_pcall_3 then
						l_pcall_3:SetAttribute("AnimationsDisabled", nil);
						l_pcall_3:SetAttribute("AnimationsExtraDisabled", nil);
						l_pcall_3:SetAttribute("UsingItemsDisabled", nil);
					end;
					if v47 then
						game.TweenService:Create(v47, TweenInfo.new(0.2), {
							Volume = 0
						}):Play();
					end;
					if v51 ~= "Hit" then
						v7:Play(v33.Config.Sounds[("Charging%*"):format(v51)], {
							Parent = l_PrimaryPart_0
						});
					end;
					v6:RemoveConnection(v49, "REMOTE_EVENT");
					l_v5_Hitbox_0:Cancel();
					v3:SetSpeedCap(v33.Player, "GuestCharging", nil);
				end);
				return v36;
			else
				if l_RunService_0:IsClient() then
					v33.Animations.Charge:Play();
					v33.MovementAnimSpeed = 2.25;
					local v58 = require(
						l_ReplicatedStorage_0.Systems.Character.Game.Sprinting
					);

					local previousChargeStaminaGain = v58.StaminaGain;
					local previousChargeStaminaLoss = v58.StaminaLoss;
					local previousChargeSpeedLock = v58.isSpeedLocked;

					-- Keep sprint input active without adding sprint speed to Charge.
					v58.isSpeedLocked = true;
					v58.StaminaGain = 0;
					v58.StaminaLoss = 0;

					if v58.__currentSpeedTween then
						v58.__currentSpeedTween:Cancel();
						v58.__currentSpeedTween = nil;
					end;

					v58.__speedMultiplier.Value = 1;
					local l_v3_FOVMultiplier_0 = v3:CreateFOVMultiplier(v33.Player, 1, "Guest1337Charge");
					game.TweenService:Create(l_v3_FOVMultiplier_0, TweenInfo.new(0.8), {
						Value = 0.75
					}):Play();
					local l_v3_SpeedMultiplier_0 = v3:CreateSpeedMultiplier(v33.Rig, v33.Config.ChargingSpeed / v33.Config.Speed, "Guest1337Charge");
					local l_LookVector_0 = workspace.CurrentCamera.CFrame.LookVector;
					local l_Unit_0 = Vector3.new(l_LookVector_0.X, 0, l_LookVector_0.Z).Unit;
					local v63 = Vector3.new(0, 0, 0, 0);
					local v64 = 0;
					local v65 = false;
					pcall(function() --[[ Line: 308 ]]
						-- upvalues: l_RunService_0 (ref)
						l_RunService_0:UnbindFromRenderStep("GuestCharging");
					end);
					do
						local l_l_Unit_0_0, l_v63_0, l_v64_0, l_v65_0 = l_Unit_0, v63, v64, v65;
						l_RunService_0:BindToRenderStep("GuestCharging", Enum.RenderPriority.Character.Value + 1, function(v70) --[[ Line: 309 ]]
							-- upvalues: v33 (copy), l_RunService_0 (ref), l_v64_0 (ref), l_v65_0 (ref), v6 (ref), l_v63_0 (ref), l_l_Unit_0_0 (ref)
							if not v33.Rig.Parent or not v33.Rig.PrimaryPart then
								l_RunService_0:UnbindFromRenderStep("GuestCharging");
								return;
							else
								l_v64_0 = l_v64_0 + v70;
								if l_v64_0 >= 0.3 and v33.Rig.PrimaryPart.Velocity.Magnitude <= v33.Config.ChargingSpeed / 2 then
									if not l_v65_0 then
										l_v65_0 = true;
										v6:FireServerConnection(("%*Guest1337Collision"):format(v33.Player.Name), "REMOTE_EVENT");
									end;
									return;
								else
									local l_LookVector_1 = workspace.CurrentCamera.CFrame.LookVector;
									l_v63_0 = Vector3.new(l_LookVector_1.X, 0, l_LookVector_1.Z).Unit;
									local v72 = l_v63_0 - l_l_Unit_0_0;
									local l_Magnitude_0 = v72.Magnitude;
									if l_Magnitude_0 > 0 then
										local v74 = v33.Config.ChargingTurnSpeed * v70;
										if l_Magnitude_0 <= v74 then
											l_l_Unit_0_0 = l_v63_0;
										else
											l_l_Unit_0_0 = l_l_Unit_0_0 + v72.Unit * v74;
										end;
										l_l_Unit_0_0 = l_l_Unit_0_0.Unit;
									end;
									v33.Rig.Humanoid:Move(l_l_Unit_0_0);
									return;
								end;
							end;
						end);
						local v75 = v33.Rig:WaitForChild(v34, v33.Config.ChargingDuration + 0.5);
						local v76 = v75 and v75.Value;
						if v75 then
							v75:Destroy();
						end;
						if v76 == "Collide" then
							local l_v3_SpeedMultiplier_1 = v3:CreateSpeedMultiplier(v33.Rig, 0.2, "GuestChargeEnded");
							game.TweenService:Create(l_v3_SpeedMultiplier_1, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
								Value = 1
							}):Play();
							game.Debris:AddItem(l_v3_SpeedMultiplier_1, 1);
						end;
						l_RunService_0:UnbindFromRenderStep("GuestCharging");
						v33.Animations.Charge:Stop();
						v33.MovementAnimSpeed = nil;
						game.TweenService:Create(l_v3_FOVMultiplier_0, TweenInfo.new(0.4), {
							Value = 1
						}):Play();
						game.Debris:AddItem(l_v3_FOVMultiplier_0, 0.4);
						l_v3_SpeedMultiplier_0:Destroy();
						v58.isSpeedLocked = previousChargeSpeedLock;
						v58.StaminaGain = previousChargeStaminaGain;
						v58.StaminaLoss = previousChargeStaminaLoss;
						v58:Resync();
					end;
				end;
				return;
			end;
		end
	}, 
	Punch = {
		LayoutOrder = 3, 
		KeybindType = "AltAbility3", 
		Icon = "rbxassetid://86535502112498", 
		Callback = function(v78, v79) --[[ Line: 379 ]] --[[ Name: Callback ]]
			-- upvalues: l_RunService_0 (copy), v4 (copy), v7 (copy), v3 (copy), v5 (copy), v9 (copy), l_ReplicatedStorage_0 (copy), v6 (copy)
			local v80
			if l_RunService_0:IsServer() then
				v80 = v78.Blocked == true
			else
				v80 = v79 == true
			end
			local v81 = v80 and "Parry" or "Punch";
			local function _(v82) --[[ Line: 383 ]] --[[ Name: getConfig ]]
				-- upvalues: v78 (copy), v81 (copy)
				return v78.Config[("%*%*"):format(v81, v82)];
			end;
			if l_RunService_0:IsServer() then
				cancelGuestBlockTask(v78, "BlockedThread")
				setGuestParryWindow(v78, false)
				v78.AbilitiesDisabled = true;
				task.delay(2, function() --[[ Line: 390 ]]
					-- upvalues: v78 (copy)
					v78.AbilitiesDisabled = false;
				end);
				if v81 == "Parry" then
					v4:ApplyStatus(v78.Rig, "Resistance", {
						Level = 3, 
						Duration = v78.Config.ParryWindupTime
					});
					local v84 = ("%*/Start"):format(script.Parent);
					local l_pcall_4 = pcall;
					local v86 = "ParryStart";
					local v87;
					l_pcall_4, v87 = l_pcall_4(function() --[[ Line: 24 ]]
						-- upvalues: v78 (copy), v86 (copy)
						if v78.Behavior[v86] then
							v78.Behavior[v86](v78);
						end;
					end);
					if not l_pcall_4 then
						warn((("[%*]: Failed to call .ParryStart() due to: %*"):format(v84, v87)));
					end;
				end;
				v7:Play(v78.Config.Sounds.PunchWindup, {
					Parent = v78.Rig.PrimaryPart
				});
				v7:PlayVoiceline(v78, ("%*Windup"):format(v81), {
					Priority = 1
				});
				task.delay(v78.Config[("%*WindupTime"):format(v81)], function() --[[ Line: 406 ]]
					-- upvalues: v3 (ref), v78 (copy), v81 (copy), v5 (ref), v7 (ref), v4 (ref), v80 (copy), v9 (ref), l_ReplicatedStorage_0 (ref)
					local v88 = v3:ApplyVelocity(v78.Rig.PrimaryPart, v78.Config[("%*DashForce"):format(v81)]);
					local Actors = require(game.ReplicatedStorage.Modules.Actors)
					local extraGuests = 0

					for _, actor in pairs(Actors.CurrentActors) do
						local humanoid = actor.Rig
							and actor.Rig:FindFirstChildOfClass("Humanoid")

						if actor ~= v78
							and actor.ActorName == "Guest1337"
							and humanoid
							and humanoid.Health > 0 then

							extraGuests += 1
						end
					end

					local punchDebuffDuration = math.max(
						0,
						v78.Config.PunchDebuffDuration - 0.35 * extraGuests
					)

					local punchKnockbackMultiplier = math.max(
						0,
						1 - 0.10 * extraGuests
					)
					game.Debris:AddItem(v88, 0.1);
					local parryConnected = false
					local _ = v5:CreateHitbox(v78.Player, {
						FriendlyFire = true,
						AbilityType = "AltAbility3",
						Size = Vector3.new(4.5, 6, 7.5, 0), 
						CFrameOffset = CFrame.new(0, 0, -1), 
						Damage = v78.Config[("%*Damage"):format(v81)], 
						Time = 0.25, 
						Knockback = v78.Config[("%*Knockback"):format(v81)]
							* punchKnockbackMultiplier,
						HitMultiple = not not v80,
						Connections = {
							Hit = function(v89) --[[ Line: 423 ]] --[[ Name: Hit ]]
								-- upvalues: v7 (ref), v78 (ref), v81 (ref), v4 (ref), v80 (ref), v9 (ref), l_ReplicatedStorage_0 (ref)
								if v80 and not parryConnected then
									parryConnected = true
									if v88 and v88.Parent then v88:Destroy() end
									stopGuestParryMotion(v78.Rig)
									v6:FireClientConnection(v78.Player,
										v78.Player.Name .. "1337ReworkParryStop", "REMOTE_EVENT", v78.Rig)
								end
								v7:Play(v78.Config.Sounds[v81], {
									Parent = v89.PrimaryPart or v78.Rig.PrimaryPart
								});
								v7:PlayVoiceline(v78, ("%*Hit"):format(v81), {
									Priority = 1
								});
								if v80 then
									v4:ApplyStatus(v89, "Stunned", {
										Level = 1,
										Duration = v78.Config.ParryStunTime
									});
								elseif punchDebuffDuration > 0 then
									v4:ApplyStatus(v89, "Helpless", {
										Level = 1,
										Duration = punchDebuffDuration
									});

									v4:ApplyStatus(v89, "Slowness", {
										Level = 2,
										Duration = punchDebuffDuration
									});
								end;
								if v80 then
									v9:IncrementAchievementProgress(v78.Player, "GuestParry");
									local v90 = ("%*/Hit"):format(script.Parent);
									local l_v78_0 = v78;
									local l_pcall_5 = pcall;
									local v93 = "ParryHit";
									local l_l_v78_0_0 = l_v78_0 --[[ copy: 2 -> 7 ]];
									local l_v93_0 = v93 --[[ copy: 5 -> 8 ]];
									local v96;
									l_pcall_5, v96 = l_pcall_5(function() --[[ Line: 24 ]]
										-- upvalues: l_l_v78_0_0 (copy), l_v93_0 (copy)
										if l_l_v78_0_0.Behavior[l_v93_0] then
											l_l_v78_0_0.Behavior[l_v93_0](l_l_v78_0_0);
										end;
									end);
									if not l_pcall_5 then
										warn((("[%*]: Failed to call .ParryHit() due to: %*"):format(v90, v96)));
									end;
								end;
								if v78.Rig.PrimaryPart.AssemblyLinearVelocity.Y < -8 then
									v7:Play(v78.Config.Sounds.CriticalPunch, {
										Parent = v89.PrimaryPart or v78.Rig.PrimaryPart,
										Volume = 0.1
									});
									v9:IncrementAchievementProgress(v78.Player, "GuestAlpha");
								end;
								local v97 = v80 and "Parried" or "Punched";
								v78.Rig:SetAttribute(v97, true);
								task.delay(0.25, function() --[[ Line: 441 ]]
									-- upvalues: v78 (ref), v97 (copy)
									v78.Rig:SetAttribute(v97, nil);
								end);
								local v98 = require(l_ReplicatedStorage_0.Modules.Actors);
								if v80 then
									local l_v78_1 = v78;
									local l_pcall_6 = pcall;
									local v101 = "OnParry";
									local v102;
									l_pcall_6, v102 = l_pcall_6(function() --[[ Line: 24 ]]
										-- upvalues: l_v78_1 (copy), v101 (copy)
										if l_v78_1.Behavior[v101] then
											l_v78_1.Behavior[v101](l_v78_1);
										end;
									end);
									if not l_pcall_6 then
										warn((("[Guest1337]: Failed to call .OnParry() due to: %*"):format(v102)));
									end;
									v98:IncrementActorStats(v78.Player, {
										Action = "Parried Killer as Guest 1337", 
										RewardType = "Offensive"
									});
									return;
								else
									v98:IncrementActorStats(v78.Player, {
										Action = "Punched Killer as Guest 1337", 
										RewardType = "Offensive"
									});
									return;
								end;
							end
						}
					});
				end);
				return v80;
			else
				if l_RunService_0:IsClient() then
					local v104 = v78.Animations[v80 and "ParryPunch" or "Punch"];
					if v104 then
						v104:Play();
						if not v78.Config.RawAnims then
							v104:AdjustSpeed((v104.Length - 0.55) / v78.Config[("%*WindupTime"):format(v81)]);
						end;
					end;
					v6:FireConnection("DisableSprinting", "GuestPunch", true);
					local l_v3_SpeedMultiplier_2 = v3:CreateSpeedMultiplier(v78.Rig, 1, "PunchAbility");
					game.TweenService:Create(l_v3_SpeedMultiplier_2, TweenInfo.new(0.25), {
						Value = 0.25
					}):Play();
					task.wait(v80 and v78.Config.ParryWindupTime or v78.Config.PunchWindupTime);
					task.wait(0.8);
					v6:FireConnection("DisableSprinting", "GuestPunch", false);
					game.TweenService:Create(l_v3_SpeedMultiplier_2, TweenInfo.new(0.15), {
						Value = 1
					}):Play();
					game.Debris:AddItem(l_v3_SpeedMultiplier_2, 0.15);
				end;
				return;
			end;
		end
	}
};
v2.cl_OnChargeProcGlobal = function(_, v107, v108) --[[ Line: 498 ]] --[[ Name: cl_OnChargeProcGlobal ]]
	-- upvalues: v7 (copy)
	v7:Play(v107.Config.Sounds.ChargeCooldownActivated);
	local l_Charge_0 = v107.Behavior.Abilities.Charge;
	if l_Charge_0 then
		l_Charge_0.CurrentRecharge = 0;
		l_Charge_0.ChargeDuration = v108.Config.KillerChargeResistanceDuration;
	end;
end;
v2.OnHit = function(_, v111, v112) --[[ Line: 507 ]] --[[ Name: OnHit ]]
	-- special attacks and projectiles breaks block.
	if v111.Blocking
		and v112.Creator
		and (
			v112.IsProjectile
				or v112.AbilityType ~= "MainAbility"
		) then

		local rawDamage = typeof(v112.Damage) == "function"
			and v112.Damage(v111.Rig)
			or v112.Damage
			or 0

		-- guarding/parry state before registerin' the hit.
		resolveGuestBlock(v111)
		setGuestParryWindow(v111, false)

		if v111.BlockedThread then
			task.cancel(v111.BlockedThread)
			v111.BlockedThread = nil
		end

		if v111.BlockThread then
			task.cancel(v111.BlockThread)
			v111.BlockThread = nil
		end

		-- Restore movement and the normal query hitbox.
		if v111.BlockingSlowness then
			v111.BlockingSlowness:Destroy()
			v111.BlockingSlowness = nil
		end

		local queryHitbox = v111.Rig:FindFirstChild("QueryHitbox")
		if queryHitbox and v111.__blockDefaultHitboxSize then
			queryHitbox.Size = v111.__blockDefaultHitboxSize
		end

		v111.Rig:SetAttribute("HitboxPriority", 2)

		if v111.Behavior.BlockEnd then
			v111.Behavior.BlockEnd(v111)
		end

		-- Replace the blocking Resistance with post-break Resistance.
		v4:RemoveStatus(v111.Player, "Resistance")
		v4:ApplyStatus(v111.Player, "Resistance", {
			Level = 2,
			Duration = 3
		})

		-- Hitboxes applies this once, then continues normal hit effects.
		v6:FireClientConnection(
			v111.Player,
			v111.Player.Name .. "1337ReworkBlockBroken",
			"REMOTE_EVENT"
		)
		return {
			DamageOverride = rawDamage * 0.6
		}
	end
	if not v112.IsProjectile
		and v112.AbilityType == "MainAbility"
		and v112.Creator
		and v111.Blocking then
		resolveGuestBlock(v111);
		cancelGuestBlockTask(v111, "BlockedThread")
		setGuestParryWindow(v111, true)
		v111.BlockedThread = task.delay(v111.Config.BlockDuration, function()
			v111.BlockedThread = nil
			setGuestParryWindow(v111, false)
		end)
		v111:SetCooldownOf("Punch", 0);
		v7:Play(v111.Config.Sounds.BlockSuccess, {
			Parent = v111.Rig.PrimaryPart
		});
		local v113 = typeof(v112.Damage) == "function" and v112.Damage(v111.Rig) or v112.Damage or 0;
		local l_Health_0 = v111.Rig.Humanoid.Health;
		-- Reworked Guest Shit, please work ;-;
		local humanoid = v111.Rig:FindFirstChildOfClass("Humanoid")

		if humanoid then
			local currentOverheal = humanoid:GetAttribute("Overheal") or 0
			local protectedFloor = humanoid:GetAttribute("OverhealDecayMin") or 0

			local gain = math.clamp(
				v111.Config.BlockOverhealCap - currentOverheal,
				0,
				v111.Config.BlockOverhealGain
			)

			if gain > 0 then
				v3:ApplyOverheal(v111.Rig, currentOverheal + gain)
				humanoid:SetAttribute("OverhealDecayMin", protectedFloor + gain)
			end
		end
		v4:ApplyStatus(v111.Rig, "Strength", {
			Level = 1,
			Duration = 5
		})
		local attacker = v112.Creator
		local slow = v111.Config.KillerSlownessPercent / 100
		local duration = v111.Config.KillerSlownessDuration
		task.defer(function()
			local rig = typeof(attacker) == "Instance" and (attacker:IsA("Model") and attacker or attacker:IsA("Player") and attacker.Character)
				or typeof(attacker) == "table" and (attacker.Rig or attacker.Character)
			if not rig or not rig.Parent then return end
			local multiplier = v3:CreateSpeedMultiplier(rig, slow, "GuestBlockedAttacker", duration)
			if multiplier then game.Debris:AddItem(multiplier, duration) end
		end)
		v4:ApplyStatus(v111.Player, "Speed", {
			Level = v111.Config.BlockSpeedLevel, 
			Duration = v111.Config.BlockSpeedDuration
		});
		v4:RemoveStatus(v111.Player, "Resistance");


		local v116 = ("%*/BlockEnd"):format(script.Parent);
		local l_pcall_7 = pcall;
		local v118 = "BlockEnd";
		local l_v118_0 = v118 --[[ copy: 9 -> 10 ]];
		local v120;
		l_pcall_7, v120 = l_pcall_7(function() --[[ Line: 24 ]]
			-- upvalues: v111 (copy), l_v118_0 (copy)
			if v111.Behavior[l_v118_0] then
				v111.Behavior[l_v118_0](v111);
			end;
		end);
		if not l_pcall_7 then
			warn((("[%*]: Failed to call .BlockEnd() due to: %*"):format(v116, v120)));
		end;
		v116 = v111.Rig:FindFirstChild("QueryHitbox");
		if v116 and v111.__blockDefaultHitboxSize then
			v116.Size = v111.__blockDefaultHitboxSize;
		end;
		require(l_ReplicatedStorage_0.Modules.Actors):IncrementActorStats(v111.Player, {
			Action = "Successfully blocked an attack", 
			RewardType = "Survivalist"
		});
		if not v111.BlockCount then
			v111.BlockCount = 0;
		end;
		v111.BlockCount = v111.BlockCount + 1;
		if v111.BlockCount >= 3 then
			v9:IncrementAchievementProgress(v111.Player, "GuestBlock");
		end;
		v120 = l_Health_0 < v113;
		v118 = require(game.ServerScriptService.Server.Systems.Core.RoundManager);
		if v120 and v118.CurrentSession and v118.CurrentSession.LastSurvivorAlive then
			v111.Daigo = true;
		end;
		return "Ignored";
	else
		return;
	end;
end;
v2.Created = function(_, v122) --[[ Line: 578 ]] --[[ Name: Created ]]
	-- upvalues: l_RunService_0 (copy), v6 (copy), v3 (copy)
	if l_RunService_0:IsServer() then
		v122.Rig:SetAttribute("HitboxPriority", 2);
		return;
	else
		if v122.Player == game.Players.LocalPlayer then
			v6:SetConnection(v122.Player.Name .. "1337ReworkParryStop", "REMOTE_EVENT", function(rig)
				if rig == v122.Rig and rig == game.Players.LocalPlayer.Character then
					stopGuestParryMotion(rig)
				end
			end)

			v6:SetConnection(
				v122.Player.Name .. "1337ReworkBlockBroken",
				"REMOTE_EVENT",
				function()
					if not v122.Rig or not v122.Rig.Parent then
						return
					end

					local animations = v122.Animations
					if not animations then
						return
					end

					-- Stop the guarding pose before playing the break agyluugyuaydgakdjhkhjdakhjg WHY IS THIS PAIN 2 MAKE!!!
					if animations.Block then
						animations.Block:Stop(0)
					end

					local broken = animations.BlockBroken
					if broken then
						broken.Looped = false
						broken:Play(0)
					else
						warn("[Guest Rework] BlockBroken animation is missing")
					end
				end
			)
		end
		v6:SetConnection(("%*On1337ChargeHit"):format(v122.Player.Name), "REMOTE_EVENT", function() --[[ Line: 583 ]]
			-- upvalues: v3 (ref), v122 (copy)
			local l_v3_Actor_0 = v3:GetActor(game.Players.LocalPlayer);
			if v122 and l_v3_Actor_0 and l_v3_Actor_0.Behavior.cl_OnChargeProcGlobal then
				l_v3_Actor_0.Behavior:cl_OnChargeProcGlobal(l_v3_Actor_0, v122);
			end;
		end);
		return;
	end;
end;
v2.CreatedPost = function(_, actor)
	if l_RunService_0:IsServer()
		or actor.Player ~= game.Players.LocalPlayer then
		return
	end

	if actor.__parryTrove then
		actor.__parryTrove:Destroy()
	end

	local trove = v8.new()
	actor.__parryTrove = trove

	local currentButton
	local stroke

	local function clearStroke()
		if stroke then
			stroke:Destroy()
			stroke = nil
		end
	end

	local function refresh()
		-- An old character must not change the new character's UI.
		if require(l_ReplicatedStorage_0.Modules.Actors).CurrentActors[game.Players.LocalPlayer] ~= actor then
			clearStroke()
			currentButton = nil
			return
		end

		local rig = actor.Rig
		if not rig or not rig.Parent then
			clearStroke()
			return
		end

		local deadline = rig:GetAttribute("GuestReworkParryUntil") or 0
		local active = deadline > workspace:GetServerTimeNow()

		local icon = active
			and "rbxassetid://76339130778616"
			or "rbxassetid://86535502112498"

		local name = active and "Parry" or "Punch"
		local textColor = active and v12 or v13

		-- Update the source used by the hotbar's own refresh loop.
		local punch = actor.Behavior.Abilities.Punch
		punch.Icon = icon
		punch.Name = name

		-- Find the current UI, including after respawning or morphing.
		local playerGui = actor.Player:FindFirstChild("PlayerGui")
		local mainUI = playerGui and playerGui:FindFirstChild("MainUI")
		local container = mainUI
			and mainUI:FindFirstChild("AbilityContainer")
		local button = container and container:FindFirstChild("Punch")

		if button ~= currentButton then
			clearStroke()
			currentButton = button
		end

		if not button then return end

		if button.Image ~= icon then
			button.Image = icon
		end
		button.ImageColor3 = active and v10 or v11

		local clipping = button:FindFirstChild("Clipping")
		local top = clipping and clipping:FindFirstChild("Top")
		if top and top.Image ~= icon then
			top.Image = icon
		end

		local label = button:FindFirstChild("AbilityName")
		if label then
			label.Text = name
			label.TextColor3 = textColor
		end

		local keybind = button:FindFirstChild("KeybindName")
		if keybind then
			keybind.TextColor3 = textColor
		end

		local charges = button:FindFirstChild("Charges")
		if charges then
			charges.Visible = false
		end

		if stroke and (not active or stroke.Parent ~= label) then
			clearStroke()
		end

		if active and label and not stroke
			and actor.Config.ParryUIStroke then
			stroke = actor.Config.ParryUIStroke:Clone()
			stroke.Parent = label
		end
	end

	trove:Add(clearStroke)
	trove:Add(l_RunService_0.Heartbeat:Connect(refresh))
	refresh()
end
v2.Destroyed = function(_, v134)
	if l_RunService_0:IsServer() then
		cancelGuestBlockTask(v134, "BlockThread")
		cancelGuestBlockTask(v134, "__blockSlowThread")
		cancelGuestBlockTask(v134, "__blockUnlockThread")
		cancelGuestBlockTask(v134, "BlockedThread")
		clearGuestBlockSlow(v134)
		restoreGuestBlockHitbox(v134)
		v134.Blocking = nil
		setGuestParryWindow(v134, false)
		v134:DisableAbilities("GuestReworkBlock", false)
	end

	if l_RunService_0:IsServer() then
		return
	end

	if v134.Player == game.Players.LocalPlayer then
		v6:RemoveConnection(v134.Player.Name .. "1337ReworkParryStop", "REMOTE_EVENT")
		v6:RemoveConnection(
			v134.Player.Name .. "1337ReworkBlockBroken",
			"REMOTE_EVENT"
		)
	end

	if v134.__parryTrove then
		v134.__parryTrove:Destroy()
		v134.__parryTrove = nil
	end

	v6:RemoveConnection(
		("%*On1337ChargeHit"):format(v134.Player.Name),
		"REMOTE_EVENT"
	)
end

return v2]========]
local afterFingerprint="34635:e38d33f1:348adb30"
local expected={
[ [========[
ReplicatedStorage/Assets/Survivors/Guest1337/Behavior]========] ]="34647:ea8cc625:acd033a8",
[ [========[
ReplicatedStorage/Assets/Survivors/Guest1337/Config]========] ]="7890:cb51b5e2:5e3e5489",
[ [========[
ServerStorage/Assets/Survivors/Guest1337/Behavior]========] ]="38175:27142544:d7eae20f",
[ [========[
ServerStorage/Assets/Survivors/Guest1337/Config]========] ]="8662:d6dd9a3f:30f34b90"
}
local replicated=assert(find("ReplicatedStorage/Assets/Survivors/Guest1337"),"Missing the renamed Reworked Guest in fct4. Nothing changed.")
local stored=assert(find("ServerStorage/Assets/Survivors/Guest1337"),"Missing stored Guest. Nothing changed.")
if replicated:GetAttribute("GuestReplacementVersion")=="1.0.0" and stored:GetAttribute("GuestReplacementVersion")=="1.0.0" then print("[Guest replacement] Already applied.");return end
for path,before in pairs(expected) do
 local target=assert(find(path),"Missing expected module: "..path..". Nothing changed.")
 assert(target:IsA("ModuleScript") and fingerprint(target.Source)==before,"Source differs from uploaded fct4: "..path..". Nothing changed; send the edited module to retain your changes.")
end
assert(#replacement<200000 and fingerprint(replacement)==afterFingerprint,"Incomplete or oversized installer text. Nothing changed.")
assert(find("ServerStorage/Assets/Rigs/Survivors/Guest1337/Default"),"Missing Guest's default rig. Nothing changed.")
local categories={}
for _,service in {"ReplicatedStorage","ServerStorage"} do
 local root=assert(find(service.."/Assets/Skins/Survivors"),"Missing skin root. Nothing changed.")
 local canonical=assert(root:FindFirstChild("Guest1337"),"Missing canonical Guest skins. Nothing changed.")
 local alias=root:FindFirstChild("Guest1337Rework")
 if alias then
  local missing={}
  for _,skin in alias:GetChildren() do if not canonical:FindFirstChild(skin.Name) then table.insert(missing,skin) end end
  table.insert(categories,{root=root,canonical=canonical,alias=alias,missing=missing,path=service.."/Assets/Skins/Survivors/Guest1337Rework",added={}})
 end
 -- Never leave a second selectable rework character behind if the older alias was retained.
 assert(not find(service.."/Assets/Survivors/Guest1337Rework"),"A separate Reworked Guest character still exists; this patch expects the partially renamed fct4 build. Nothing changed.")
end
-- Build the stored replacement from the already-working rework, including its Config children.
local prepared=replicated:Clone();prepared.Behavior.Source=replacement
prepared:SetAttribute("GuestReplacementVersion","1.0.0")
local backup=Instance.new("Folder");backup.Name="GuestReplacement_Backup_"..os.date("!%Y%m%d_%H%M%S");backup.Parent=game.ServerStorage
local saved=replicated:Clone();saved.Name="ReplicatedGuest";saved.Parent=backup
local savedServer=stored:Clone();savedServer.Name="StoredGuest";savedServer.Parent=backup
local oldVersion=replicated:GetAttribute("GuestReplacementVersion")
local storedParent=stored.Parent
local ok,err=pcall(function()
 replicated.Behavior.Source=replacement
 replicated:SetAttribute("GuestReplacementVersion","1.0.0")
 stored.Parent=nil;prepared.Parent=storedParent
 for i,category in ipairs(categories) do
  for _,skin in ipairs(category.missing) do
   local copy=skin:Clone();copy.Parent=category.canonical;table.insert(category.added,copy)
   copy:SetAttribute("GuestReplacementAdded",backup.Name)
  end
  category.alias:SetAttribute("GuestReplacementOriginalPath",category.path)
  category.alias.Name="ArchivedReworkSkins_"..i;category.alias.Parent=backup
 end
end)
if not ok then
 replicated.Behavior.Source=saved.Behavior.Source;replicated:SetAttribute("GuestReplacementVersion",oldVersion)
 prepared:Destroy();stored.Parent=storedParent
 for _,category in ipairs(categories) do
  for _,copy in ipairs(category.added) do copy:Destroy() end
  category.alias.Name="Guest1337Rework";category.alias.Parent=category.root;category.alias:SetAttribute("GuestReplacementOriginalPath",nil)
 end
 backup:Destroy();error("[Guest replacement] Rolled back: "..tostring(err))
end
stored:Destroy()
pcall(function()game:GetService("ChangeHistoryService"):SetWaypoint("Replace Guest with Reworked Guest")end)
print("[Guest replacement] Reworked Guest is now Guest 1337 in both asset stores. Stacking IDs fixed; duplicate skin categories archived. Existing Guest rig, skin IDs, ownership and XP keys retained.")
print("[Guest replacement] Backup: "..backup:GetFullName()..". Save, then start a fresh playtest.")

end
local function restore()
-- Restore the pre-replacement Guest assets. Stop Play first.
assert(game:GetService("RunService"):IsStudio() and not game:GetService("RunService"):IsRunning(),"Stop Play first.")
local function find(path)local current=game;for name in path:gmatch("[^/]+") do current=current and current:FindFirstChild(name) end;return current end
local backups={}
for _,folder in game.ServerStorage:GetChildren() do if folder.Name:match("^GuestReplacement_Backup_") then table.insert(backups,folder) end end
table.sort(backups,function(a,b)return a.Name>b.Name end)
local backup=assert(backups[1],"No Guest replacement backup found.")
local destinations={
 {path="ReplicatedStorage/Assets/Survivors",saved=assert(backup:FindFirstChild("ReplicatedGuest"),"Missing original replicated Guest.")},
 {path="ServerStorage/Assets/Survivors",saved=assert(backup:FindFirstChild("StoredGuest"),"Missing original stored Guest.")}
}
for _,item in ipairs(destinations) do
 item.parent=assert(find(item.path),"Missing asset parent. Nothing restored.")
 item.current=assert(item.parent:FindFirstChild("Guest1337"),"Missing replaced Guest. Nothing restored.")
 assert(item.current:GetAttribute("GuestReplacementVersion")=="1.0.0","Guest has been replaced again. Nothing restored.")
 item.prepared=item.saved:Clone();item.prepared.Name="Guest1337"
end
local aliases={}
for _,saved in backup:GetChildren() do
 local path=saved:GetAttribute("GuestReplacementOriginalPath")
 if path then
  local parent=assert(find(path:match("^(.*)/[^/]+$")),"Missing skin parent. Nothing restored.")
  assert(not parent:FindFirstChild("Guest1337Rework"),"Rework skin category was recreated. Nothing restored.")
  table.insert(aliases,{saved=saved,parent=parent})
 end
end
for _,item in ipairs(destinations) do item.current:Destroy();item.prepared.Parent=item.parent end
for _,item in ipairs(aliases) do
 local canonical=item.parent:FindFirstChild("Guest1337")
 if canonical then for _,skin in canonical:GetChildren() do if skin:GetAttribute("GuestReplacementAdded")==backup.Name then skin:Destroy() end end end
 item.saved.Name="Guest1337Rework";item.saved:SetAttribute("GuestReplacementOriginalPath",nil);item.saved.Parent=item.parent
end
backup:Destroy()
print("[Guest replacement] Restored the pre-replacement assets. Save and restart Play.")

end
local function fixture()
 fresh()
 for _,service in {"ReplicatedStorage","ServerStorage"} do
  local root=game:FindFirstChild(service)
  local assets=root:FindFirstChild("Assets")or child(root,"Assets")
  local survivors=assets:FindFirstChild("Survivors")or child(assets,"Survivors")
  local guest=child(survivors,"Guest1337")
  for _,name in {"Config","Behavior"} do local module=child(guest,name,"ModuleScript");module.Source=sources[service][name] end
  child(guest.Config,"Smoke","Part");child(guest.Config,"ParryStroke","UIStroke")
  local skins=child(child(assets,"Skins"),"Survivors")
  local canonical=child(skins,"Guest1337");local alias=child(skins,"Guest1337Rework")
  for _,folder in {canonical,alias} do local skin=child(folder,"ClassicGuest");local config=child(skin,"Config","ModuleScript");config.Source="return {}"end
  child(alias,"AliasOnlySkin")
  child(canonical,"CanonicalOnlySkin")
  if service=="ServerStorage"then child(child(child(assets,"Rigs"),"Survivors"),"Guest1337");child(assets.Rigs.Survivors.Guest1337,"Default","Model")end
 end
 return game.ReplicatedStorage.Assets.Survivors.Guest1337,game.ServerStorage.Assets.Survivors.Guest1337
end
local rep,stored=fixture()
local rig=game.ServerStorage.Assets.Rigs.Survivors.Guest1337.Default
install()
local after=game.ServerStorage.Assets.Survivors.Guest1337
assert(after~=stored and stored.Destroyed)
assert(rep.Config.Source==sources.ReplicatedStorage.Config and after.Config.Source==rep.Config.Source)
assert(after.Behavior.Source==rep.Behavior.Source and not rep.Behavior.Source:find('actor.ActorName == "Guest1337Rework"',1,true))
assert(after.Config.Smoke and after.Config.ParryStroke)
assert(game.ServerStorage.Assets.Rigs.Survivors.Guest1337.Default==rig)
for _,service in {"ReplicatedStorage","ServerStorage"} do
 local skins=game:FindFirstChild(service).Assets.Skins.Survivors
 assert(not skins.Guest1337Rework and skins.Guest1337.ClassicGuest and skins.Guest1337.AliasOnlySkin and skins.Guest1337.CanonicalOnlySkin)
end
local backupCount=#game.ServerStorage:GetChildren();install();assert(#game.ServerStorage:GetChildren()==backupCount)
restore()
for _,service in {"ReplicatedStorage","ServerStorage"} do
 local assets=game:FindFirstChild(service).Assets
 assert(assets.Survivors.Guest1337.Config.Source==sources[service].Config and assets.Survivors.Guest1337.Behavior.Source==sources[service].Behavior)
 assert(assets.Skins.Survivors.Guest1337Rework and not assets.Skins.Survivors.Guest1337.AliasOnlySkin and assets.Skins.Survivors.Guest1337.CanonicalOnlySkin)
end
-- Source failure during commit restores the previous kit and leaves both aliases active.
rep,stored=fixture();local original=rep.Behavior.Source
failAt=writes+2
local ok=pcall(install)
assert(not ok and rep.Behavior.Source==original and game.ServerStorage.Assets.Survivors.Guest1337==stored)
assert(game.ReplicatedStorage.Assets.Skins.Survivors.Guest1337Rework and not rep:GetAttribute("GuestReplacementVersion"))
-- Unknown gameplay edits stop before live changes.
rep,stored=fixture();rep.Behavior.Source..="\n-- user edit"
local edited=rep.Behavior.Source;ok=pcall(install)
assert(not ok and rep.Behavior.Source==edited and game.ServerStorage.Assets.Survivors.Guest1337==stored)
print("PASS Guest replacement: canonical rework, stored synchronization, 2 stacking IDs, Config children, rig preservation, skin merge/archive, idempotence, full restore, Source rollback, unknown-edit refusal")
