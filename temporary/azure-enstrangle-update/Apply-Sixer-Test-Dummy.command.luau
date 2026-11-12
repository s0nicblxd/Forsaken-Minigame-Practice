-- SIXER PASSIVE TEST DUMMY FOR THE EXISTING SPAWN BOT KILLER PANEL
-- Stop Play and run this entire file in Studio's Command Bar.
-- Edits ServerScriptService.Server.Modules.BotKillers from FCFyetagain....rbxl.
-- Start a normal single-player Play test; Spawn Bot Killer -> Killer: Sixer
-- (Guest666 / Guest 666 also accepted). Any normal rating 0-6 works.
-- Uses the real Sixer rig/config collider, with no attacks, pursuit, AI or pathfinding.
-- Not added to the random roster. Animation failures do not replace the dummy.
-- Requires Friendly Fire enabled for Azure to grab a fellow killer.
-- Backup: ServerStorage.SixerDummyBackup_<timestamp>; RESTORE_BACKUP can undo.
-- Compiled and mock-tested; live Studio validation still needed.
local RESTORE_BACKUP = nil
local RunService = game:GetService("RunService")
assert(not RunService:IsRunning(), "Stop Play before applying/restoring the Azure update.")
local editor = game:GetService("ScriptEditorService")
local storage = game:GetService("ServerStorage")
local moduleRoot = game:GetService("ServerScriptService")
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
{path={"Server","Modules","BotKillers"}, checksum=3398777076, afterChecksum=2610316379, edits={
{old=[=[
	task.spawn(function()
		local last = os.clock()
		while bot.Alive and model.Parent and humanoid.Health > 0 do
			task.wait(0.1)
			local now = os.clock()
]=], new=[=[
	task.spawn(function()
		local last = os.clock()
		while not data.Passive and bot.Alive and model.Parent and humanoid.Health > 0 do
			task.wait(0.1)
			local now = os.clock()
]=]},
{old=[=[
	end
	addLabel(bot)
	addHitboxes(bot)
	Util:GiveInvincible(model, "Spawn", CONFIG.SpawnShield)
	table.insert(BotKillers.Bots, bot)
]=], new=[=[
	end
	addLabel(bot)
    if data.Passive then
        -- Use the same custom collider template and offset as the real character.
        Util:FixCharacter(model, "Killers")
        Util:AddHitboxes({Rig = model, Config = data.Config}, "Killers")
        if bot.Tracks.Idle then bot.Tracks.Idle:Play(0.1) end
    else
        addHitboxes(bot)
    end
	Util:GiveInvincible(model, "Spawn", CONFIG.SpawnShield)
	table.insert(BotKillers.Bots, bot)
]=]},
{old=[=[
		end,
	})
	bot.Path = SimplePath.new(model, { AgentRadius = 2.5, AgentHeight = 5, AgentCanJump = false, WaypointSpacing = 5 })
	setupAnimations(bot)
	checkAnimations(bot)
]=], new=[=[
		end,
	})
	bot.Path = not data.Passive and SimplePath.new(model, { AgentRadius = 2.5, AgentHeight = 5, AgentCanJump = false, WaypointSpacing = 5 }) or nil
	setupAnimations(bot)
	checkAnimations(bot)
]=]},
{old=[=[
		WanderUntil = 0,
		-- abilities / positioning (ratings 2+)
		Tactics = TACTICS[rating],
		Abilities = isBoss and ABILITIES.c00lkiddBoss or (TACTICS[rating] and ABILITIES[killerName] or {}),
		AbilityReady = {},
		Busy = false,
]=], new=[=[
		WanderUntil = 0,
		-- abilities / positioning (ratings 2+)
		Tactics = not data.Passive and TACTICS[rating] or nil,
		Abilities = data.Passive and {} or (isBoss and ABILITIES.c00lkiddBoss or (TACTICS[rating] and ABILITIES[killerName] or {})),
		AbilityReady = {},
		Busy = false,
]=]},
{old=[=[
	humanoid.Health = isBoss and BOSS.Health or data.Health
	humanoid.WalkSpeed = data.WalkSpeed

	model:SetAttribute("IsBot", true)
]=], new=[=[
	humanoid.Health = isBoss and BOSS.Health or data.Health
	humanoid.WalkSpeed = data.WalkSpeed
    if data.Passive then
        model:SetAttribute("CustomRig", true)
        model:SetAttribute("PassiveTestDummy", true)
        humanoid.AutoRotate = false
        if not model:FindFirstChild("SpeedMultipliers") then
            local folder = Instance.new("Folder")
            folder.Name = "SpeedMultipliers"
            folder.Parent = model
        end
    end

	model:SetAttribute("IsBot", true)
]=]},
{old=[=[
		return nil
	end
	local roster = availableRoster()
	local killerName = options.Killer and getKillerData(options.Killer) and options.Killer or roster[math.random(1, math.max(#roster, 1))]
]=], new=[=[
		return nil
	end
    if options.Killer == "Sixer" and not getKillerData("Sixer") then
        warn("[BotKillers]: cannot spawn the Sixer dummy; no random replacement was spawned")
        return nil
    end
	local roster = availableRoster()
	local killerName = options.Killer and getKillerData(options.Killer) and options.Killer or roster[math.random(1, math.max(#roster, 1))]
]=]},
{old=[=[
function BotKillers.SpawnBot(options)
	options = options or {}
	local isBoss = options.Boss == true and options.Admin == true
	if isBoss then
]=], new=[=[
function BotKillers.SpawnBot(options)
	options = options or {}
    if type(options.Killer) == "string" then
        local alias = options.Killer:lower():gsub("%s+", "")
        if alias == "sixer" or alias == "guest666" then options.Killer = "Sixer" end
    end
	local isBoss = options.Boss == true and options.Admin == true
	if isBoss then
]=]},
{old=[=[

local function step(bot, dt)
	-- the bot can be removed while the loop waits between ticks
	if not (bot.Alive and bot.Path and bot.Model.Parent) then
]=], new=[=[

local function step(bot, dt)
    if bot.Data.Passive then return end -- never fight Enstrangle with AI movement/attacks
	-- the bot can be removed while the loop waits between ticks
	if not (bot.Alive and bot.Path and bot.Model.Parent) then
]=]},
{old=[=[
-- leave a fresh server with no bots at all)
local function checkAnimations(bot)
	task.spawn(function()
		local started = os.clock()
]=], new=[=[
-- leave a fresh server with no bots at all)
local function checkAnimations(bot)
    if bot.Data.Passive then return end -- keep the test rig even if animations are private
	task.spawn(function()
		local started = os.clock()
]=]},
{old=[=[
	local folder = ReplicatedStorage.Assets.Killers:FindFirstChild(killerName)
	local okConfig, config = pcall(require, folder and folder:FindFirstChild("Config"))
	local okBehavior, behavior = pcall(require, folder and folder:FindFirstChild("Behavior"))
	if okConfig and typeof(config) == "table" and typeof(config.Rig) == "Instance" and typeof(config.Animations) == "table" then
]=], new=[=[
	local folder = ReplicatedStorage.Assets.Killers:FindFirstChild(killerName)
	local okConfig, config = pcall(require, folder and folder:FindFirstChild("Config"))
    -- Sixer's nested attacks/custom rig are intentionally a passive test target.
    -- Do not load player-only abilities or require an attack animation for this bot.
    if killerName == "Sixer" and okConfig and typeof(config) == "table" then
        local rig = config.Rig or (folder and folder:FindFirstChild("Rig"))
        if typeof(rig) == "Instance" and rig:IsA("Model") then
            local animations = config.Animations or {}
            local data = {
                Name = "Sixer", DisplayName = "Sixer (Test Dummy)",
                Config = config, Rig = rig, Passive = true,
                Health = tonumber(config.Health) or 1000,
                WalkSpeed = 0, SprintSpeed = 0,
                MaxStamina = 110, StaminaLoss = 0, StaminaGain = 0,
                Damage = 0, Windup = 0, Cooldown = 1, Range = 0,
                Animations = {
                    Idle = firstString(animations.Idle),
                    Walk = firstString(animations.Walk),
                    Run = firstString(animations.Run),
                },
            }
            killerCache[killerName] = data
            return data
        end
        warn("[BotKillers]: Sixer test dummy is missing its rig")
        return nil
    end
	local okBehavior, behavior = pcall(require, folder and folder:FindFirstChild("Behavior"))
	if okConfig and typeof(config) == "table" and typeof(config.Rig) == "Instance" and typeof(config.Animations) == "table" then
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
            "BotKillers differs from FCFyetagain....rbxl: " .. module:GetFullName() .. ". Nothing changed.")
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
    print("Sixer test dummy update already installed. No changes needed.")
    return
end
local backup = Instance.new("Folder")
backup.Name = "SixerDummyBackup_" .. os.time()
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
print("Sixer test dummy update installed successfully. Backup: ServerStorage." .. backup.Name)
print("Spawn Bot Killer: enter Sixer (rating 0-6). Enable Friendly Fire; wait for spawn shield, then test Azure grab/drop/throw.")
