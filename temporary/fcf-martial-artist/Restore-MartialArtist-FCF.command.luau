assert(game:GetService("RunService"):IsStudio() and not game:GetService("RunService"):IsRunning(),"Stop Play first.")
local backup=game:GetService("Selection"):Get()[1]
assert(backup and backup.Name:match("^MArtistFCF_Backup_"),"Select the MArtistFCF_Backup folder in ServerStorage first.")
local pending={}
for _,saved in backup:GetChildren()do
 local reference=saved:FindFirstChild("Original")
 assert(reference and reference.Value and reference.Value.Parent,"Original module missing; nothing restored.")
 table.insert(pending,{target=reference.Value,before=reference.Value.Source,after=saved.Source})
end
local ok,err=pcall(function()for _,item in pending do item.target.Source=item.after end end)
if not ok then for _,item in pending do item.target.Source=item.before end;error(err)end
print("[Martial Artist FCF] Restored original sources. Save and restart Play.")
