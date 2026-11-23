assert(game:GetService("RunService"):IsStudio()and not game:GetService("RunService"):IsRunning(),"Stop Play first.")
local backup=game:GetService("Selection"):Get()[1]
assert(backup and backup.Name:match("^CombatPrompts_Backup_"),"Select the CombatPrompts_Backup folder in ServerStorage.")
local controller=backup:FindFirstChild("Controller")and backup.Controller.Value
assert(controller and controller.Source==backup:GetAttribute("AfterControllerSource"),"Controller was edited; nothing restored.")
local entries={}
for _,role in {"Killer","Survivor"}do
 local saved=assert(backup:FindFirstChild(role),"Prompt backup missing")
 local native=saved.Native.Value;local pad=saved.Pad.Value
 assert(native and pad and native.Parent==pad,"Native prompt was moved/removed. Nothing restored.")
 local extra=saved:FindFirstChild("Extra")and saved.Extra.Value
 assert(not extra or extra.Parent==saved,"Archived extra prompt was moved. Nothing restored.")
 table.insert(entries,{saved=saved,native=native,pad=pad,extra=extra})
end
local keys={"Style","KeyboardKeyCode","ActionText","ObjectText","HoldDuration","MaxActivationDistance","RequiresLineOfSight","Enabled"}
local currentSource=controller.Source
local snapshots={}
for _,entry in entries do table.insert(snapshots,entry.native:Clone())end
local ok,err=pcall(function()
 controller.Source=backup.BeforeController.Source
 for _,entry in entries do
  for _,key in keys do entry.native[key]=entry.saved.BeforePrompt[key]end
  entry.native:SetAttribute("Theme",entry.saved.BeforePrompt:GetAttribute("Theme"))
  if entry.extra then entry.extra.Parent=entry.pad end
 end
end)
if not ok then
 controller.Source=currentSource
 for i,entry in entries do
  for _,key in keys do entry.native[key]=snapshots[i][key]end
  entry.native:SetAttribute("Theme",snapshots[i]:GetAttribute("Theme"))
  if entry.extra then entry.extra.Parent=entry.saved end
 end
 for _,snapshot in snapshots do snapshot:Destroy()end
 error("Prompt restore rolled back: "..tostring(err))
end
for _,snapshot in snapshots do snapshot:Destroy()end
backup:Destroy()
print("[Combat prompts] Previous prompt/controller settings restored. Save and restart Play.")
