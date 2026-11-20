-- Studio-only Guest block tester. Apply the Guest FCT patch before using this.
local RunService = game:GetService("RunService")
assert(RunService:IsStudio(), "The Slasher training bot is for Studio playtests.")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Actors = require(ReplicatedStorage.Modules.Actors)
local Hitboxes = require(ReplicatedStorage.Modules.Hitboxes)
local Statuses = require(ReplicatedStorage.Modules.Statuses)
local Util = require(ReplicatedStorage.Modules.Util)
local Sounds = require(ReplicatedStorage.Modules.Sounds)
local config = require(ReplicatedStorage.Assets.Killers.Slasher.Config)
local random = Random.new()
local alive, rig, actor, currentHitbox = true, nil, nil, nil
local targetPlayer
local tracks = {}
local attackGeneration = 0
local abilityTimers = {}
local function cleanup()
    if not alive then return end
    alive = false
    if currentHitbox then currentHitbox:Cancel(); currentHitbox = nil end
    if rig and Actors.CurrentActors[rig] == actor then Actors.CurrentActors[rig] = nil end
    if rig then Statuses:RemoveStatuses(rig); rig:Destroy() end
end
script.Destroying:Connect(cleanup)
local function choosePlayer()
    local name = script:GetAttribute("TargetPlayer")
    if name and name ~= "" then return Players:FindFirstChild(name) end
    if targetPlayer and targetPlayer.Parent == Players then return targetPlayer end
    return Players:GetPlayers()[1]
end
local function targetRig()
    targetPlayer = choosePlayer()
    local character = targetPlayer and targetPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    return humanoid and humanoid.Health > 0 and character.PrimaryPart and character or nil
end
local target
repeat target = targetRig(); if not target then task.wait(.25) end until target or not alive
if not alive then return end
local template = ServerStorage.Assets.Rigs.Killers.Slasher:FindFirstChild("Default")
assert(template and template:IsA("Model"), "Missing ServerStorage.Assets.Rigs.Killers.Slasher.Default")
rig = template:Clone()
rig.Name = "Slasher_BlockTest"
rig:SetAttribute("GuestBlockTestBot", true)
rig:SetAttribute("Team", "Killers")
rig:SetAttribute("HitboxPriority", 1)
rig:RemoveTag("Replicating")
local humanoid = assert(rig:FindFirstChildOfClass("Humanoid"), "Slasher rig has no Humanoid")
local root = assert(rig:FindFirstChild("HumanoidRootPart") or rig.PrimaryPart, "Slasher rig has no root")
rig.PrimaryPart = root
humanoid.MaxHealth = 1000
humanoid.Health = 1000
humanoid.WalkSpeed = 12
humanoid.DisplayName = "Slasher — Block Test"
for _, part in ipairs(rig:GetDescendants()) do
    if part:IsA("BasePart") then part.Anchored = false end
    if part:IsA("Script") or part:IsA("LocalScript") then part:Destroy() end
end
for _, name in ipairs({"SpeedMultipliers", "ResistanceMultipliers"}) do
    if not rig:FindFirstChild(name) then local folder = Instance.new("Folder"); folder.Name = name; folder.Parent = rig end
end
local playerFolder = workspace:FindFirstChild("Players")
if not playerFolder then playerFolder = Instance.new("Folder"); playerFolder.Name = "Players"; playerFolder.Parent = workspace end
local killers = playerFolder:FindFirstChild("Killers")
if not killers then killers = Instance.new("Folder"); killers.Name = "Killers"; killers.Parent = playerFolder end
rig.Parent = killers
rig:PivotTo(target.PrimaryPart.CFrame * CFrame.new(0, 0, -9))
root:SetNetworkOwner(nil)
actor = {Rig = rig, Player = rig, Config = config, ActorName = "Slasher", ActorType = "Killer", ActorSkin = "Default", Behavior = {}, Cache = {}, AbilityDisablers = {}}
function actor:GetPivot() return rig:GetPivot() end
function actor:DisableAbilities(source, active, duration)
    local token = {}
    abilityTimers[source] = token
    self.AbilityDisablers[source] = active and true or nil
    if active then
        attackGeneration += 1
        if currentHitbox then currentHitbox:Cancel(); currentHitbox = nil end
        for _, name in ipairs({"Slash", "Behead"}) do
            local track = tracks[name]
            if track then track:Stop(.05) end
        end
        if source == "Stunned" and rig.Parent then
            humanoid.WalkSpeed = 0
            humanoid:MoveTo(root.Position)
            humanoid.AutoRotate = true
        end
    end
    if duration then
        task.delay(duration, function()
            if alive and abilityTimers[source] == token then self:DisableAbilities(source, not active) end
        end)
    end
end
local function abilitiesBlocked()
    if actor.AbilitiesDisabled or rig:GetAttribute("AbilitiesDisabled") then return true end
    for _, disabled in pairs(actor.AbilityDisablers) do if disabled then return true end end
    return false
end
Actors.CurrentActors[rig] = actor
local animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", humanoid)
for _, name in ipairs({"Idle", "Walk", "Slash", "Behead"}) do
    local id = config.Animations[name]
    if typeof(id) == "string" and id ~= "" then
        local animation = Instance.new("Animation"); animation.AnimationId = id
        local ok, track = pcall(function() return animator:LoadAnimation(animation) end)
        animation:Destroy()
        if ok then
            track.Looped = name == "Idle" or name == "Walk"
            track.Priority = track.Looped and Enum.AnimationPriority.Movement or Enum.AnimationPriority.Action
            tracks[name] = track
        end
    end
end
local function locomotion(moving)
    local wanted = moving and "Walk" or "Idle"
    for _, name in ipairs({"Idle", "Walk"}) do
        local track = tracks[name]
        if track then
            if name == wanted then if not track.IsPlaying then track:Play(.15) end
            elseif track.IsPlaying then track:Stop(.15) end
        end
    end
end
local function hasStatus(name) return Statuses:PlayerHasStatus(rig, name) ~= nil end
local function stunned() return rig:GetAttribute("Stunned") or hasStatus("Stunned") end
local function face(character)
    local pos = character.PrimaryPart.Position
    local flat = Vector3.new(pos.X, root.Position.Y, pos.Z)
    if (flat - root.Position).Magnitude > .01 then root.CFrame = CFrame.lookAt(root.Position, flat) end
end
local function trainAttack(character)
    if abilitiesBlocked() or stunned() or hasStatus("Helpless") then return end
    local generation = attackGeneration
    -- A fresh, independent 50/50 roll for every attack.
    local move = random:NextInteger(1, 2) == 1 and "Slash" or "Behead"
    rig:SetAttribute("LastAttack", move)
    humanoid:MoveTo(root.Position)
    humanoid.AutoRotate = false
    locomotion(false)
    face(character)
    if tracks[move] then tracks[move]:Play(.05) end
    Sounds:Play(config.Sounds.Swing, {Parent = root})
    task.wait(config[move .. "Windup"] or (move == "Slash" and .2 or .45))
    if not alive or not rig.Parent or humanoid.Health <= 0 then return end
    if generation ~= attackGeneration or abilitiesBlocked() or stunned() or hasStatus("Helpless") then humanoid.AutoRotate = true; return end
    local slash = move == "Slash"
    currentHitbox = Hitboxes:CreateHitbox(rig, {
        Size = slash and Vector3.new(4.5, 6, 7.5) or Vector3.new(8, 2, 7),
        CFrameOffset = CFrame.new(0, 0, slash and -1.75 or -2),
        AbilityType = slash and "MainAbility" or "AltAbility1",
        IsProjectile = false,
        Time = config[move .. "Linger"] or .25,
        Knockback = 2,
        HitMultiple = false,
        ExecuteOnKill = false,
        Damage = function(victim)
            local h = victim:FindFirstChildOfClass("Humanoid")
            if not h then return 0 end
            -- Leave at least one HP. No Bleeding DoT, rewards, or executions in this tester.
            return math.min(config[move .. "Damage"] or 20, math.max(0, h.Health - 1))
        end,
        Connections = {
            Hit = function(victim)
                if not alive then return end
                Sounds:Play(config.Sounds.Hit, {Parent = root})
                Util:CreateSpeedMultiplier(victim, 1.5, "SlasherTestHit", slash and 1.25 or .9)
                if not slash then Statuses:ApplyStatus(victim, "Helpless", {Level = 1, Duration = 8}) end
            end
        }
    })
    task.wait((config[move .. "Linger"] or .25) + .1)
    currentHitbox = nil
    humanoid.AutoRotate = true
end
print("[Slasher Test Bot] Spawned. Follows your character and rolls M1/Behead 50/50. Apply the Guest patch first. Stop the playtest to remove it.")
local nextAttack = os.clock() + 2
while alive and rig.Parent and humanoid.Health > 0 do
    target = targetRig()
    if target then
        local distance = (target.PrimaryPart.Position - root.Position).Magnitude
        local multiplier = 1
        for _, value in ipairs(rig.SpeedMultipliers:GetChildren()) do
            if value:IsA("NumberValue") then multiplier *= value.Value end
        end
        local slow = Statuses:PlayerHasStatus(rig, "Slowness")
        if slow then multiplier *= math.max(0, 1 - .1 * slow.Level) end
        humanoid.WalkSpeed = stunned() and 0 or 12 * multiplier
        if distance > 4.5 then
            humanoid:MoveTo(target.PrimaryPart.Position)
            locomotion(not stunned())
        else
            humanoid:MoveTo(root.Position)
            locomotion(false)
            if os.clock() >= nextAttack and not abilitiesBlocked() and not stunned() and not hasStatus("Helpless") then
                local ok, err = pcall(trainAttack, target)
                if not ok then warn("[Slasher Test Bot] Attack failed: " .. tostring(err)); break end
                nextAttack = os.clock() + 2.5
            end
        end
    else
        humanoid:MoveTo(root.Position)
        locomotion(false)
    end
    task.wait(.1)
end
cleanup()
