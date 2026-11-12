-- AZURE BALANCE UPDATE
-- Stop Play. Paste this entire file into Studio's Command Bar.
-- Requires the consolidated Behavior update. Edits Config and sv_Vine only
-- at verified unique source anchors, preserving animation IDs and other edits.
-- Behavior is checked against the known consolidated source.
-- Bulbs: damage 2.5, firing rate -15% (interval / 0.85).
-- Plants: no placement within 20 studs of live spawns (Config tunable).
-- Vine: noise detection in both states, 6-stud height, UPD Bloom timings,
-- damage 10, released survivor Speed II for 1.5s.
-- Enstrangle: miss/success cooldown 20s; existing cancel cooldown unchanged.
-- Golem Blooming max damage 30; Unearthing damage 10, fissure speed mult 0.5;
-- Burrowing invincibility 1.5s. Existing transformation protection preserved.
-- Backup: ServerStorage.AzureBalanceBackup_<timestamp>.
-- Set RESTORE_BACKUP below to the folder name to restore pre-update sources.
-- All modules are validated before writing; repeated runs are no-ops.
-- Compiled and mock-tested; live Roblox validation still required.
local RESTORE_BACKUP = nil
local RunService = game:GetService("RunService")
assert(not RunService:IsRunning(), "Stop Play before applying/restoring the Azure update.")
local editor = game:GetService("ScriptEditorService")
local storage = game:GetService("ServerStorage")
local moduleRoot = game:GetService("ReplicatedStorage")
local function normalize(s) return (s:gsub("\r\n", "\n")) end
local function read(module) return editor:GetEditorSource(module) end
local function write(module, expected, updated)
    editor:UpdateSourceAsync(module, function(current)
        assert(current == expected, "Source changed while applying: " .. module:GetFullName())
        return updated
    end)
end
local function resolve(path)
    local node = moduleRoot
    for _, name in path do
        node = assert(node:FindFirstChild(name), "Missing Azure module: " .. name)
    end
    assert(node:IsA("ModuleScript"), "Expected ModuleScript: " .. node:GetFullName())
    return node
end
if RESTORE_BACKUP then
    local backup = assert(storage:FindFirstChild(RESTORE_BACKUP), "Backup folder not found")
    for _, entry in backup:GetChildren() do
        local path = string.split(entry:GetAttribute("ModulePath"), "/")
        local module = resolve(path)
        local parts = entry:GetChildren()
        table.sort(parts, function(a,b) return a.Name < b.Name end)
        local source = {}
        for _, part in parts do table.insert(source, part.Value) end
        write(module, read(module), table.concat(source))
    end
    print("Azure Enstrangle backup restored: " .. RESTORE_BACKUP)
    return
end
local function checksum(s)
    local a,b = 1,0
    for i=1,#s do a=(a+string.byte(s,i))%65521; b=(b+a)%65521 end
    return b*65536+a
end
local changes = {
{path={"Assets","Killers","Azure","Behavior"}, checksum=2153524339, afterChecksum=2321999150, edits={
{old=[=[

                        local v657 = CFrame.new(v656) * u650:GetPivot().Rotation;
                        local v658 = __pcallMethod("sv_GetBlockingConstruct", u650, v657.Position);

]=], new=[=[

                        local v657 = CFrame.new(v656) * u650:GetPivot().Rotation;
                        if __pcallMethod("sv_IsNearPlantSpawn", u650, v657.Position) then
                            u650:PCallLocal("DenyBuild", nil, "Move further away from spawn points.");
                            u650:SetCooldownOf("Blossom", 0);
                            u650.AbilitiesDisabled = false;
                            return;
                        end;

                        local v658 = __pcallMethod("sv_GetBlockingConstruct", u650, v657.Position);

]=]},
{old=[=[
                        end;

                        local v626 = __pcallMethod("sv_CreateConstruct", u613, "GroundBulb", {
                            CFrame = v622
]=], new=[=[
                        end;

                        __cullConstruct(u613, "GroundBulb", (getConstructLimit(u613, "GroundBulb")));
                        local v626 = __pcallMethod("sv_CreateConstruct", u613, "GroundBulb", {
                            CFrame = v622
]=]},
{old=[=[
                        end;

                        local v625 = __pcallMethod("sv_GetBlockingConstruct", u613, v622.Position);

]=], new=[=[
                        end;

                        if __pcallMethod("sv_IsNearPlantSpawn", u613, v622.Position) then
                            u613:PCallLocal("DenyBuild", nil, "Move further away from spawn points.");
                            u613:SetCooldownOf("Sow", 0);
                            u613.AbilitiesDisabled = false;
                            return;
                        end;

                        local v625 = __pcallMethod("sv_GetBlockingConstruct", u613, v622.Position);

]=]},
{old=[=[
                        end;

                        __cullConstruct(u613, "GroundBulb", (getConstructLimit(u613, "GroundBulb")));
                        __pcallMethod("sv_DecreaseOblation", u613, 0);
                        local v619 = u613;
]=], new=[=[
                        end;

                        __pcallMethod("sv_DecreaseOblation", u613, 0);
                        local v619 = u613;
]=]},
{old=[=[
    end;

    function u77.lcl_DenyBuild(p293, p294, p295) -- Line: 1926
        -- upvalues: Util (copy), __playSound (copy)
        Util:CreateWarning("AzureBuildNo", "Move further away from your other plants.");
        __playSound(p294, "BuildDenied", {
            Parent = workspace
]=], new=[=[
    end;

    function u77.lcl_DenyBuild(p293, p294, p295, message) -- Line: 1926
        -- upvalues: Util (copy), __playSound (copy)
        Util:CreateWarning("AzureBuildNo", message or "Move further away from your other plants.");
        __playSound(p294, "BuildDenied", {
            Parent = workspace
]=]},
{old=[=[
        p171.Config.StatusData = nil;
        Util:RemoveStackableAttribute(p171.Rig, "StunnedDisabled", "Golem");
        Util:GiveInvincible(p171.Rig, "GolemSwitch", p171.Config.Golem.InvulnOnSwitch);
        local GolemReturnDummy = p171.State.GolemReturnDummy;

]=], new=[=[
        p171.Config.StatusData = nil;
        Util:RemoveStackableAttribute(p171.Rig, "StunnedDisabled", "Golem");
        Util:GiveInvincible(p171.Rig, "GolemSwitch_" .. tostring(os.clock()), p171.Config.Golem.InvulnOnSwitch);
        local GolemReturnDummy = p171.State.GolemReturnDummy;

]=]},
{old=[=[

if u2 then
    function u77.sv_GetBlockingConstruct(p78, p79, p80) -- Line: 289
        local PlacementRadius = p79.Config.PlacementRadius;
]=], new=[=[

if u2 then
    function u77.sv_IsNearPlantSpawn(_, actor, position)
        local radius = actor.Config.PlantSpawnExclusionRadius or 20
        -- Only live Workspace spawns count, never maps stored in ServerStorage.
        for _, part in workspace:GetDescendants() do
            if not part:IsA("BasePart") then continue end
            local isSpawn = part:IsA("SpawnLocation")
            local ancestor = part.Parent
            while not isSpawn and ancestor and ancestor ~= workspace do
                isSpawn = ancestor.Name == "SpawnPoints" or ancestor.Name == "BotSpawns"
                ancestor = ancestor.Parent
            end
            if isSpawn and (part.Position - position).Magnitude <= radius then
                return true
            end
        end
        return false
    end;

    function u77.sv_GetBlockingConstruct(p78, p79, p80) -- Line: 289
        local PlacementRadius = p79.Config.PlacementRadius;
]=]}
}},
{path={"Assets","Killers","Azure","Config"}, checksum=0, afterChecksum=2795994809, edits={
{old=[=[
		Header = "UNEARTHING",
		Quote = "\"Those guided by the Spawn cannot be tempted by the anger of the beasts that lurk outside of our Family.\" -Elder Amarah",
		Text = `Cooldown: { t1.GolemFissure.Cooldown }s \n` .. `After a { t1.GolemFissure.Windup }s windup, <b><font color="rgb(128, 24, 255)">the Golem</font></b> will stomp the ground and send a shockwave forwards that will knock back hit survivors and deal { t1.GolemFissure.Damage } damage.\n` .. `As the shockwave travels, it will leave behind a fissure in its wake. This fissure slows survivors by <b>70%</b> while they are inside of it. The fissure lasts for { t1.GolemFissure.CrackLifetime }s.\n` .. "Survivors are able to be carried by the shockwave as it travels, but will not take more than one instance of damage.\n"
	},
	{
]=], new=[=[
		Header = "UNEARTHING",
		Quote = "\"Those guided by the Spawn cannot be tempted by the anger of the beasts that lurk outside of our Family.\" -Elder Amarah",
		Text = `Cooldown: { t1.GolemFissure.Cooldown }s \n` .. `After a { t1.GolemFissure.Windup }s windup, <b><font color="rgb(128, 24, 255)">the Golem</font></b> will stomp the ground and send a shockwave forwards that will knock back hit survivors and deal { t1.GolemFissure.Damage } damage.\n` .. `As the shockwave travels, it will leave behind a fissure in its wake. This fissure slows survivors by <b>50%</b> while they are inside of it. The fissure lasts for { t1.GolemFissure.CrackLifetime }s.\n` .. "Survivors are able to be carried by the shockwave as it travels, but will not take more than one instance of damage.\n"
	},
	{
]=]},
{old=[=[
		Header = "SEEKER BULB",
		Quote = "\"Certain types of nightshade can be fatal, so be careful...\" -Aspen",
		Text = "Cooldown: 12s \n" .. `<b><font color="rgb(238, 23, 255)">Azure</font></b> will slow down and then after a { t1.Sow.Windup }s windup will jab a tentacle forward, spawning a Seeker Bulb on the hit surface.\n` .. "Upon being triggered, they will begin to fire projectiles at the survivor who activated it, dealing 4 damage and applying a stack of <b>Atropa</b> on hit.\n" .. "Seeker Bulbs will stop firing after 1.5s if they lose line of sight of survivors or survivors stop making noise near it.\n" .. "<b><font color=\"rgb(238, 23, 255)\">Azure</font></b> can have up to 3 Seeker Bulbs at once. Using the ability again with 3 Seeker Bulbs placed will replace the oldest one.\n"
	},
	{
]=], new=[=[
		Header = "SEEKER BULB",
		Quote = "\"Certain types of nightshade can be fatal, so be careful...\" -Aspen",
		Text = "Cooldown: 12s \n" .. `<b><font color="rgb(238, 23, 255)">Azure</font></b> will slow down and then after a { t1.Sow.Windup }s windup will jab a tentacle forward, spawning a Seeker Bulb on the hit surface.\n` .. "Upon being triggered, they will begin to fire projectiles at the survivor who activated it, dealing 2.5 damage and applying a stack of <b>Atropa</b> on hit.\n" .. "Seeker Bulbs will stop firing after 1.5s if they lose line of sight of survivors or survivors stop making noise near it.\n" .. "<b><font color=\"rgb(238, 23, 255)\">Azure</font></b> can have up to 3 Seeker Bulbs at once. Using the ability again with 3 Seeker Bulbs placed will replace the oldest one.\n"
	},
	{
]=]},
{old=[=[
	}
}
t1.Information = {
	{
]=], new=[=[
	}
}
-- AzureBalance_v1: explicit tuning, preserving uploaded animation IDs.
t1.PlantSpawnExclusionRadius = 20
t1.ConstructConfigs.GroundBulb.Damage = {[2] = 2.5, [3] = 2.5}
-- Rate = 1 / interval: 15% fewer shots, not merely 15% longer intervals.
t1.ConstructConfigs.GroundBulb.ShotDebounce = {[2] = 0.5 / 0.85, [3] = 0.4 / 0.85}
t1.ConstructConfigs.Vine.Damage = 10
t1.ConstructConfigs.Vine.HitboxHeight = 6
t1.ConstructConfigs.Vine.Windup = {[2] = 0.6, [3] = 0.4}
t1.ConstructConfigs.Vine.MissAttackCooldown = {[2] = 6.5, [3] = 4}
t1.ConstructConfigs.Vine.EscapeCooldown = {[2] = 6.5, [3] = 4}
t1.ConstructConfigs.Vine.StatusesOnRelease.Speed.Duration = 1.5
t1.Grab.CooldownMiss = 20
t1.Grab.CooldownSuccess = 20
t1.GolemShockwave.Damage = 30
t1.GolemFissure.Damage = 10
t1.GolemFissure.VictimSpeedMult = 0.5
t1.Golem.InvulnOnSwitch = 1.5

t1.Information = {
	{
]=]}
}},
{path={"Assets","Killers","Azure","Behavior","sv_AzureConstruct","sv_Vine"}, checksum=0, afterChecksum=2268695302, edits={
{old=[=[
                    HitMultiple = false,
                    BypassChecks = true,
                    Size = Vector3.new(u6.HitboxWidth, 2, HitboxLength),
                    Damage = u6.Damage,
                    CFrame = u21,
]=], new=[=[
                    HitMultiple = false,
                    BypassChecks = true,
                    Size = Vector3.new(u6.HitboxWidth, u6.HitboxHeight, HitboxLength),
                    Damage = u6.Damage,
                    CFrame = u21,
]=]},
{old=[=[
            local u22 = ReplicatedStorage.Assets.Instances.Nothingburger:Clone();
            u22.Transparency = 0.9;
            u22.Size = Vector3.new(u6.HitboxWidth, 2, HitboxLength);
            u22.CFrame = u21;
            u22.Color = Color3.new(0.384314, 0.027451, 1);
]=], new=[=[
            local u22 = ReplicatedStorage.Assets.Instances.Nothingburger:Clone();
            u22.Transparency = 0.9;
            u22.Size = Vector3.new(u6.HitboxWidth, u6.HitboxHeight, HitboxLength);
            u22.CFrame = u21;
            u22.Color = Color3.new(0.384314, 0.027451, 1);
]=]},
{old=[=[
                end;

                local v20 = Vector3.new(Position.X, u5.Root.Position.Y, Position.Z) + Vector3.new(0, 1, 0);

                return CFrame.lookAt(u5.Root.Position + Vector3.new(0, 1, 0), v20) * CFrame.new(0, 0, -HitboxLength / 2);
            end;

]=], new=[=[
                end;

                local v20 = Vector3.new(Position.X, u5.Root.Position.Y, Position.Z) + Vector3.new(0, u6.HitboxHeight / 2, 0);

                return CFrame.lookAt(u5.Root.Position + Vector3.new(0, u6.HitboxHeight / 2, 0), v20) * CFrame.new(0, 0, -HitboxLength / 2);
            end;

]=]},
{old=[=[
            local u17;

            if u5.PowerLevel == 3 then
                u17 = {};

                for _, child in ipairs(workspace.Players.Survivors:GetChildren()) do
                    if Util:IsAlive(child) and ((child:GetPivot().Position - u5.Root.Position).Magnitude <= u6.Radius and u5:HasLOS(child)) then
                        table.insert(u17, child);
                    end;
				end;
				if workspace:GetAttribute("FriendlyFire") then
					for _, child in ipairs(workspace.Players.Killers:GetChildren()) do
						if u5.Owner and child == u5.Owner.Character then continue end
						if Util:IsAlive(child) and ((child:GetPivot().Position - u5.Root.Position).Magnitude <= u6.Radius and u5:HasLOS(child)) then
							table.insert(u17, child);
						end;
					end;
				end
            else
				u17 = u5:GetLoudSurvivorsInRange(u5.Owner and u5.Owner.Character, u6.Radius, true);
            end;

            if u17 then
]=], new=[=[
            local u17;

            -- Blooming keeps its faster timings, but walking alone is quiet.
            -- The shared detector retains ability noise, QTE failures and throw landings.
            u17 = u5:GetLoudSurvivorsInRange(u5.Owner and u5.Owner.Character, u6.Radius, true);

            if u17 then
]=]}
}}
}
local prepared = {}
for _, change in changes do
    local module = resolve(change.path)
    local original = read(module)
    local source = normalize(original)
    if checksum(source) ~= change.afterChecksum then
        assert(change.checksum == 0 or checksum(source) == change.checksum,
            "Behavior differs from the consolidated update: " .. module:GetFullName() .. ". Nothing changed.")
        for _, edit in change.edits do
            -- Check the replacement first: insertion edits can contain the old anchor.
            local already = string.find(source, edit.new, 1, true)
            if not already then
                local first,last = string.find(source, edit.old, 1, true)
                assert(first and not string.find(source, edit.old, last+1, true),
                    "Missing or ambiguous balance edit in " .. module:GetFullName() .. ". Nothing changed.")
                source = string.sub(source,1,first-1) .. edit.new .. string.sub(source,last+1)
            end
        end
        if source ~= normalize(original) then
            table.insert(prepared, {module=module, original=original, updated=source, path=change.path})
        end
    end
end
if #prepared == 0 then
    print("Azure balance update already installed. No changes needed.")
    return
end
local backup = Instance.new("Folder")
backup.Name = "AzureBalanceBackup_" .. os.time()
backup.Parent = storage
for i, item in prepared do
    local entry = Instance.new("Folder")
    entry.Name = tostring(i)
    entry:SetAttribute("ModulePath", table.concat(item.path,"/"))
    entry.Parent = backup
    for offset=1,#item.original,50000 do
        local part = Instance.new("StringValue")
        part.Name = string.format("SourcePart%04d", math.floor((offset-1)/50000)+1)
        part.Value = string.sub(item.original,offset,offset+49999)
        part.Parent = entry
    end
end
local applied = {}
local ok, err = pcall(function()
    for _, item in prepared do
        write(item.module, item.original, item.updated)
        table.insert(applied,item)
    end
end)
if not ok then
    for i=#applied,1,-1 do
        local item=applied[i]
        local restored, restoreError = pcall(write,item.module,item.updated,item.original)
        if not restored then warn("Restore from " .. backup.Name .. ": " .. tostring(restoreError)) end
    end
    error("Azure update failed; rollback attempted. Backup: " .. backup.Name .. "\n" .. tostring(err))
end
print("Azure balance update installed successfully. Backup: ServerStorage." .. backup.Name)
print("Playtest: walk/sprint near both Vine states; both Bulb fire rates; spawn placement; Enstrangle cooldown; Golem damage, fissure slow and Burrowing protection.")
