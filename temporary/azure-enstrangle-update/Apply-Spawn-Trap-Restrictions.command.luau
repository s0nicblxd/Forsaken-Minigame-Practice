-- SPAWN TRAP RESTRICTIONS: AZURE AND JOHN DOE
-- Stop Play, then run this entire file in Studio's Command Bar.
-- Targets the Azure and John Doe Behaviors from FCFyetagain....rbxl.
-- Azure's Bulb and Stigmatize restrictions retain the configured 20-stud radius.
-- Both use: Move away from spawn to put your traps.
-- Digital Footprint is rejected before animation/lock/trap creation near spawns;
-- cooldown refunded. Placement is rechecked during windup to prevent displacement
-- into spawn zones. Corrupt Energy is unchanged. No Chance edits.
-- Backup: ServerStorage.SpawnTrapBackup_<timestamp>. Set RESTORE_BACKUP to undo.
-- Validates both sources before editing. Repeated runs are harmless.
-- Compiled and mock-tested; live Studio verification still required.
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
{path={"Assets","Killers","Azure","Behavior"}, checksum=2321999150, afterChecksum=2211702494, edits={
{old=[=[
                        local v657 = CFrame.new(v656) * u650:GetPivot().Rotation;
                        if __pcallMethod("sv_IsNearPlantSpawn", u650, v657.Position) then
                            u650:PCallLocal("DenyBuild", nil, "Move further away from spawn points.");
                            u650:SetCooldownOf("Blossom", 0);
                            u650.AbilitiesDisabled = false;
]=], new=[=[
                        local v657 = CFrame.new(v656) * u650:GetPivot().Rotation;
                        if __pcallMethod("sv_IsNearPlantSpawn", u650, v657.Position) then
                            u650:PCallLocal("DenyBuild", nil, "Move away from spawn to put your traps.");
                            u650:SetCooldownOf("Blossom", 0);
                            u650.AbilitiesDisabled = false;
]=]},
{old=[=[

                        if __pcallMethod("sv_IsNearPlantSpawn", u613, v622.Position) then
                            u613:PCallLocal("DenyBuild", nil, "Move further away from spawn points.");
                            u613:SetCooldownOf("Sow", 0);
                            u613.AbilitiesDisabled = false;
]=], new=[=[

                        if __pcallMethod("sv_IsNearPlantSpawn", u613, v622.Position) then
                            u613:PCallLocal("DenyBuild", nil, "Move away from spawn to put your traps.");
                            u613:SetCooldownOf("Sow", 0);
                            u613.AbilitiesDisabled = false;
]=]}
}},
{path={"Assets","Killers","JohnDoe","Behavior"}, checksum=3771338924, afterChecksum=603423879, edits={
{old=[=[
								local v89 = (p_u_67.Rig.PrimaryPart.CFrame * CFrame.new(-1.1, 0, -2)).Position
								local v90 = workspace:Raycast(v89, Vector3.new(0, -100, 0), v_u_81)
								v_u_80.Position = (v90 and v90.Position or p_u_67.Rig.PrimaryPart.Position - Vector3.new(0, 2.5, 0)) + Vector3.new(0, 0.5, 0)
								local v91 = game.TweenService
								local v92 = v_u_80
]=], new=[=[
								local v89 = (p_u_67.Rig.PrimaryPart.CFrame * CFrame.new(-1.1, 0, -2)).Position
								local v90 = workspace:Raycast(v89, Vector3.new(0, -100, 0), v_u_81)
                                local placement = (v90 and v90.Position or p_u_67.Rig.PrimaryPart.Position - Vector3.new(0, 2.5, 0)) + Vector3.new(0, 0.5, 0)
                                if isTrapNearSpawn(p_u_67, placement) then
                                    v_u_80:Destroy()
                                    p_u_67:SetCooldownOf("DigitalFootprint", 0)
                                    return
                                end
                                v_u_80.Position = placement
								local v91 = game.TweenService
								local v92 = v_u_80
]=]},
{old=[=[
				v82(tonumber(v83) or 2.55, function()
					-- upvalues: (ref) v_u_5, (copy) v_u_80, (copy) p_u_67, (copy) v_u_74, (ref) v_u_7
					v_u_5:ApplyUnsafeTouched(v_u_80, false, function(_, p84)
						-- upvalues: (ref) v_u_5, (ref) p_u_67, (ref) v_u_80, (ref) v_u_74, (ref) v_u_7
]=], new=[=[
				v82(tonumber(v83) or 2.55, function()
					-- upvalues: (ref) v_u_5, (copy) v_u_80, (copy) p_u_67, (copy) v_u_74, (ref) v_u_7
                    if not v_u_80.Parent then return end
					v_u_5:ApplyUnsafeTouched(v_u_80, false, function(_, p84)
						-- upvalues: (ref) v_u_5, (ref) p_u_67, (ref) v_u_80, (ref) v_u_74, (ref) v_u_7
]=]},
{old=[=[
		["Icon"] = "rbxassetid://83206360003394",
		["KeybindType"] = "AltAbility2",
		["Callback"] = function(p_u_67)
			-- upvalues: (copy) v_u_4, (copy) v_u_5, (copy) v_u_7
			local v_u_68 = { 0.317, 1.05, 2.067 }
]=], new=[=[
		["Icon"] = "rbxassetid://83206360003394",
		["KeybindType"] = "AltAbility2",
		["Callback"] = function(p_u_67, result)
            if game["Run Service"]:IsClient() and type(result) == "table" and result.SpawnBlocked then
                v_u_5:CreateWarning("SpawnTrapDenied", "Move away from spawn to put your traps.")
                return
            end
            if game["Run Service"]:IsServer() then
                local root = p_u_67.Rig.PrimaryPart
                local params = RaycastParams.new()
                params.FilterDescendantsInstances = {workspace.Players}
                params.FilterType = Enum.RaycastFilterType.Exclude
                local origin = (root.CFrame * CFrame.new(-1.1, 0, -2)).Position
                local ground = workspace:Raycast(origin, Vector3.new(0, -100, 0), params)
                local position = (ground and ground.Position or root.Position - Vector3.new(0, 2.5, 0)) + Vector3.new(0, 0.5, 0)
                if isTrapNearSpawn(p_u_67, position) then
                    p_u_67:SetCooldownOf("DigitalFootprint", 0)
                    return {Cancelled = true, SpawnBlocked = true}
                end
            end
			-- upvalues: (copy) v_u_4, (copy) v_u_5, (copy) v_u_7
			local v_u_68 = { 0.317, 1.05, 2.067 }
]=]},
{old=[=[
local v_u_8 = require(game.ReplicatedStorage.Modules.Network)
local v_u_9 = require(game.ReplicatedStorage.Modules.AchievementUtil)
local v104 = {
	["Slash"] = {
]=], new=[=[
local v_u_8 = require(game.ReplicatedStorage.Modules.Network)
local v_u_9 = require(game.ReplicatedStorage.Modules.AchievementUtil)
-- Stationary traps share Azure's live-spawn exclusion convention.
local function isTrapNearSpawn(actor, position)
    local radius = actor.Config.PlantSpawnExclusionRadius or 20
    for _, part in workspace:GetDescendants() do
        if not part:IsA("BasePart") then continue end
        local isSpawn = part:IsA("SpawnLocation")
        local ancestor = part.Parent
        while not isSpawn and ancestor and ancestor ~= workspace do
            isSpawn = ancestor.Name == "SpawnPoints" or ancestor.Name == "BotSpawns"
            ancestor = ancestor.Parent
        end
        if isSpawn and (part.Position - position).Magnitude <= radius then return true end
    end
    return false
end

local v104 = {
	["Slash"] = {
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
            "Behavior differs from FCFyetagain....rbxl: " .. module:GetFullName() .. ". Nothing changed.")
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
    print("Spawn trap update already installed. No changes needed.")
    return
end
local backup = Instance.new("Folder")
backup.Name = "SpawnTrapBackup_" .. os.time()
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
print("Spawn trap update installed successfully. Backup: ServerStorage." .. backup.Name)
print("Playtest: both Azure plants and Digital Footprint near/outside spawns; exact warning, refunded cooldown; Corrupt Energy remains usable.")
