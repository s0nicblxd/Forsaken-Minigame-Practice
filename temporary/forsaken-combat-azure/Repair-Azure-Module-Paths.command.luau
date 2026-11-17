-- Repairs the five flat FCF utility references in the already-applied Azure port.
-- Stop playtesting, run this in Studio's Command Bar, then start a NEW playtest.
local RunService = game:GetService("RunService")
assert(RunService:IsStudio() and not RunService:IsRunning(), "Stop the playtest first.")
local modules = game.ReplicatedStorage.Modules
assert(modules.Misc:FindFirstChild("Maid"), "FCT's Modules.Misc.Maid is missing.")
assert(modules.Misc:FindFirstChild("Signal"), "FCT's Modules.Misc.Signal is missing.")
local azure = game.ReplicatedStorage.Assets.Killers.Azure
local pending = {}
for _, target in ipairs(azure:GetDescendants()) do
    if target:IsA("ModuleScript") then
        local before = target.Source
        local after, maidCount = before:gsub("ReplicatedStorage%.Modules%.Maid", "ReplicatedStorage.Modules.Misc.Maid")
        local signalCount
        after, signalCount = after:gsub("ReplicatedStorage%.Modules%.Signal", "ReplicatedStorage.Modules.Misc.Signal")
        if maidCount + signalCount > 0 then
            assert(#after < 200000, "Source limit exceeded: " .. target:GetFullName() .. ". Nothing changed.")
            table.insert(pending, {target = target, before = before, after = after})
        end
    end
end
if #pending == 0 then print("[Azure paths] Already fixed; nothing changed."); return end
local backup = Instance.new("Folder")
backup.Name = "AzureModulePaths_Backup_" .. os.date("!%Y%m%d_%H%M%S")
backup.Parent = game.ServerStorage
for i, item in ipairs(pending) do
    local saved = item.target:Clone()
    saved.Name = tostring(i) .. "_" .. item.target.Name
    saved:SetAttribute("OriginalPath", item.target:GetFullName())
    saved.Parent = backup
end
local ok, err = pcall(function()
    for _, item in ipairs(pending) do item.target.Source = item.after end
end)
if not ok then
    for _, item in ipairs(pending) do item.target.Source = item.before end
    error("[Azure paths] Rolled back: " .. tostring(err))
end
print("[Azure paths] Fixed " .. #pending .. " modules. Start a fresh playtest to clear failed require caches.")
