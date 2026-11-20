local attrs={}
local rig={IsA=function()return false end,GetAttribute=function(_,name)return attrs[name]end,SetAttribute=function(_,name,value)attrs[name]=value end}
local DamageRules=(function()
-- Both damage routes call this once, before victim resistance is applied.
local DamageRules={}
function DamageRules.ScaleDamage(source,damage)
 if not source then return damage end
 if source:IsA("Player") then source=source.Character end
 if not source then return damage end
 local reduction=tonumber(source:GetAttribute("WeaknessNerf")) or 0
 return damage*math.clamp(1-reduction/100,0,1)
end
return DamageRules

end)()
local server=true
local util={}
local resistance={}
function util:CreateResistanceMultiplier(_,value,name,duration)resistance[name]={Value=value,Duration=duration}end
local game={ReplicatedStorage={Modules={Util='Util',DamageRules='DamageRules',Actors='Actors',AchievementUtil='AchievementUtil'}}}
game['Run Service']={IsServer=function()return server end}
local require=function(name)if name=='Util' then return util elseif name=='DamageRules' then return DamageRules else return {}end end
local Weakness=(function()

return {
	Data = {
		Duration = 10,
		MaxLevel = 10,
		Stackable = false,
		IsNegative = true,
		Description = "Makes you deal less damage.\nEvery level of this status makes you deal 10% less damage."
	},
	Applied = function(p1) -- line: 12
		if game["Run Service"]:IsServer() and p1.Character then
			local num = tonumber(p1.Level * 10)

			if num then
				p1.Character:SetAttribute("WeaknessNerf", num)
			end
		end
	end,
	Removed = function(p2) -- line: 21
		if game["Run Service"]:IsServer() and p2.Character then
			p2.Character:SetAttribute("WeaknessNerf", nil)
		end
	end
}

end)()
local Vulnerable=(function()

return {
	Data = {
		Duration = 10,
		MaxLevel = 10,
		Stackable = false,
		IsNegative = true,
		Description = "Makes you more susceptible to damage.\nEvery level of this status makes you receive 20% more damage."
	},
	Applied = function(p1) -- line: 12
		if game["Run Service"]:IsServer() and p1.Character then
			local num = tonumber(p1.Level * 20)

			if num then
				require(game.ReplicatedStorage.Modules.Util):CreateResistanceMultiplier(p1.Character, -num, "VulnerableStatus", p1.Data.Duration)
			end
		end
	end,
	Removed = function(p2) -- line: 22
		if game["Run Service"]:IsServer() and p2.Character then
			require(game.ReplicatedStorage.Modules.Util):CreateResistanceMultiplier(p2.Character, 1, "VulnerableStatus", 0)
		end
	end
}

end)()
local function directDamage(_: {[any]: any}, p26, n4: number, n5: number?, damageSource: Instance?) -- line: 391
	-- upvalues: t1 (copy)
	local AchievementUtil = require(game.ReplicatedStorage.Modules.AchievementUtil)
	local Actors = require(game.ReplicatedStorage.Modules.Actors)
	local Humanoid = p26:FindFirstChild("Humanoid")
	local num = tonumber(n4)
	if num and damageSource then num = require(game.ReplicatedStorage.Modules.DamageRules).ScaleDamage(damageSource, num) end

	if not num or (not Humanoid or not (Humanoid.Health > 0)) then
		return
	end

	if p26:GetAttribute("Invincible") then
		return
	end

	local ResistanceMultipliers = p26:FindFirstChild("ResistanceMultipliers")
	local n6 = 0

	for _, v in pairs(ResistanceMultipliers and ResistanceMultipliers:GetChildren() or {}) do
		n6 += v.Value
	end

	local v161 = num * (1 - math.min(n6, 100) / 100)
return v161
end
local function hitboxDamage(creatorChar,rawDamage,resistanceSum)
local weakenedDamage = require(game.ReplicatedStorage.Modules.DamageRules).ScaleDamage(creatorChar, rawDamage)
						local finalDamage = weakenedDamage * (1 - math.min(resistanceSum - (creatorChar:GetAttribute("StrengthBuff") or 0), 100) / 100)
return finalDamage
end

local function near(a,b)assert(math.abs(a-b)<.00001,tostring(a)..' != '..tostring(b))end
local ctx={Level=2,Character=rig,Data={Duration=12}}
Weakness.Applied(ctx);near(attrs.WeaknessNerf,20)
assert(next(resistance)==nil,'Weakness must not affect incoming resistance')
near(DamageRules.ScaleDamage(rig,20),16)
Vulnerable.Applied({Level=5,Character=rig,Data={Duration=12}})
near(resistance.VulnerableStatus.Value,-100)
local victim={}
function victim:GetAttribute()return nil end
function victim:FindFirstChild(name)
 if name=='Humanoid' then return {Health=100}end
 if name=='ResistanceMultipliers' then return {GetChildren=function()return {resistance.VulnerableStatus}end}end
end
-- Real Util prefix and real Hitboxes arithmetic both apply Weakness exactly once.
near(directDamage(nil,victim,20,nil,rig),32)
near(hitboxDamage(rig,20,-100),32)
-- No source means damage-over-time, environmental damage and health costs keep their prior behavior.
near(directDamage(nil,victim,20,1),40)
near(hitboxDamage(rig,20,50),8)
Weakness.Removed(ctx);assert(attrs.WeaknessNerf==nil)
near(hitboxDamage(rig,20,0),20)
attrs.WeaknessNerf=100;near(hitboxDamage(rig,20,0),0)
attrs.WeaknessNerf=500;near(hitboxDamage(rig,20,0),0)
attrs.WeaknessNerf=-10;near(hitboxDamage(rig,20,0),20)
attrs.WeaknessNerf=nil
server=false;Weakness.Applied(ctx);assert(attrs.WeaknessNerf==nil,'client must not set authoritative Weakness')
Vulnerable.Removed(ctx);near(resistance.VulnerableStatus.Value,-100)
server=true;Vulnerable.Removed(ctx);near(resistance.VulnerableStatus.Duration,0)
print('Weakness/Vulnerable lifecycle and actual direct/hitbox damage arithmetic passed')
