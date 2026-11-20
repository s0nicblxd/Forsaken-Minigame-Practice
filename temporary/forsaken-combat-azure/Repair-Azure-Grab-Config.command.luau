-- Stop playtesting. Run in Studio's Command Bar, then start a fresh playtest.
local run = game:GetService("RunService")
assert(run:IsStudio() and not run:IsRunning(), "Stop the playtest before running this repair.")
local behavior = game.ReplicatedStorage.Assets.Killers.Azure.Behavior
local helperSource = [====[
local defaults = {
 Windup = 1, Linger = 0.2, Endlag = 0.5,
 HookRange = 60, HookSpeed = 270, PullTime = 0.8, HookHitboxSize = 4,
 ProjectileHitboxSize = Vector3.new(5, 5.5, 6),
 MissSlowness = 0.3, MissSlownessDuration = 1,
 CooldownCancel = 5, CooldownMiss = 20, CooldownSuccess = 20,
 KnockbackPower = 100, RagdollDuration = 1.2, BlastRadius = 20,
 Damage = 5, ThrowVelocity = 70, GravityCoefficient = 0.425,
 HitDamage = 10, CloseThrowDistance = 20,
 ThrowHelpless = 2, CloseThrowHelpless = 4, PlantTriggerDuration = 1.5,
 SuccessAnimationTimeout = 8, ThrowAnimationTimeout = 8, HoldMaxDuration = 1.5,
}
local positive = {
 HookRange = true, HookSpeed = true, PullTime = true, HookHitboxSize = true,
 SuccessAnimationTimeout = true, ThrowAnimationTimeout = true,
}
local function finite(value)
 return type(value) == "number" and value == value and value > -math.huge and value < math.huge
end
return function(actor)
 assert(type(actor) == "table" and type(actor.Config) == "table", "Azure actor Config is missing")
 local existing = actor.Config.Grab
 local grab = {}
 if type(existing) == "table" then
  for key, value in pairs(existing) do grab[key] = value end
 end
 for key, fallback in pairs(defaults) do
  local value = grab[key]
  if type(fallback) == "number" then
   if not finite(value) or value < 0 or positive[key] and value <= 0 then grab[key] = fallback end
  elseif typeof(value) ~= "Vector3" or not finite(value.X) or not finite(value.Y) or not finite(value.Z)
   or value.X <= 0 or value.Y <= 0 or value.Z <= 0 then
   grab[key] = fallback
  end
 end
 actor.Config.Grab = grab
 return grab
end
]====]
local before = behavior.Source
local after = before
local marker = "local resolveAzureGrabConfig = require(script.GrabConfigDefaults);"
if not after:find(marker, 1, true) then
 local n
 after, n = after:gsub("local Grab = ([%w_]+)%.Config%.Grab;", "local Grab = resolveAzureGrabConfig(%1);")
 assert(n == 3, "Unexpected Azure Behavior: expected three grab config readers. Nothing changed.")
 after, n = after:gsub("local rig, grab = actor%.Rig, actor%.Config%.Grab", "local rig, grab = actor.Rig, resolveAzureGrabConfig(actor)")
 assert(n == 1, "Unexpected Azure grab movement helper. Nothing changed.")
 after, n = after:gsub("function u77%.Created%(p684, u685%)[ \t]*", "function u77.Created(p684, u685)\n resolveAzureGrabConfig(u685);")
 assert(n == 1, "Unexpected Azure Created callback. Nothing changed.")
 after, n = after:gsub("local spawn = task%.spawn;", function() return marker .. "\nlocal spawn = task.spawn;" end)
 assert(n == 1, "Unexpected Azure module header. Nothing changed.")
end
assert(#after < 200000 and #helperSource < 200000, "Studio Source limit exceeded. Nothing changed.")
local helper = behavior:FindFirstChild("GrabConfigDefaults")
assert(not helper or helper:IsA("ModuleScript"), "GrabConfigDefaults exists but is not a ModuleScript. Nothing changed.")
if after == before and helper and helper.Source == helperSource then
 print("[Azure grab config] Already repaired. Start a fresh playtest.")
 return
end
local backup = Instance.new("Folder")
backup.Name = "AzureGrabConfig_Backup_" .. os.date("!%Y%m%d_%H%M%S")
backup.Parent = game.ServerStorage
local saved = behavior:Clone()
saved.Name = "Behavior"
saved.Parent = backup
local oldHelperSource = helper and helper.Source
local created = not helper
local ok, err = pcall(function()
 if not helper then
  helper = Instance.new("ModuleScript")
  helper.Name = "GrabConfigDefaults"
  helper.Parent = behavior
 end
 helper.Source = helperSource
 behavior.Source = after
end)
if not ok then
 behavior.Source = before
 if created and helper then helper:Destroy() elseif helper then helper.Source = oldHelperSource end
 error("[Azure grab config] Rolled back: " .. tostring(err))
end
pcall(function() game:GetService("ChangeHistoryService"):SetWaypoint("Azure grab config repair") end)
print("[Azure grab config] Repaired missing grab parameters on server and client. Backup: " .. backup:GetFullName() .. ". Start a NEW playtest.")
