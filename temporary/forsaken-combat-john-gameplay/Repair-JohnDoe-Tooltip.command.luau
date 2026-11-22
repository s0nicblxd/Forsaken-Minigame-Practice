-- Fix the literal percent in John's formatted Digital Footprint tooltip.
assert(game:GetService("RunService"):IsStudio() and not game:GetService("RunService"):IsRunning(),"Stop Play before repairing John Doe.")
local old="Digital Footprint is 30% larger."
local fixed="Digital Footprint is 30%% larger."
local pending={}
for _,service in {"ReplicatedStorage","ServerStorage"} do
 local root=game:GetService(service)
 local assets=root:FindFirstChild("Assets")
 local killers=assets and assets:FindFirstChild("Killers")
 local john=killers and killers:FindFirstChild("JohnDoe")
 local config=john and john:FindFirstChild("Config")
 assert(config and config:IsA("ModuleScript"),"Missing "..service.."/Assets/Killers/JohnDoe/Config. Nothing changed.")
 local source=config.Source
 local start,finish=source:find(old,1,true)
 if start then
  assert(not source:find(old,finish+1,true),"Multiple matching tooltips; nothing changed.")
  table.insert(pending,{target=config,before=source,after=source:sub(1,start-1)..fixed..source:sub(finish+1),service=service})
 else
  assert(source:find(fixed,1,true),"Unexpected John tooltip in "..service..". Nothing changed.")
 end
end
if #pending==0 then print("[John tooltip] Already fixed.");return end
local backup=Instance.new("Folder")
backup.Name="JohnTooltip_Backup_"..os.date("!%Y%m%d_%H%M%S")
for _,item in pending do
 local saved=item.target:Clone();saved.Name=item.service.."_Config";saved.Parent=backup
end
backup.Parent=game:GetService("ServerStorage")
local ok,err=pcall(function()for _,item in pending do item.target.Source=item.after end end)
if not ok then
 for _,item in pending do item.target.Source=item.before end
 backup:Destroy();error("[John tooltip] Rolled back: "..tostring(err))
end
print("[John tooltip] Fixed both Config tooltips. Save and start a NEW playtest. Backup: "..backup:GetFullName())
