-- Azure execution safety repair for the existing Azure/Two Time combat ports. Run in Edit mode.
assert(game:GetService("RunService"):IsStudio() and not game:GetService("RunService"):IsRunning(),"Stop Play before applying the Azure execution repair.")
local oldCallback=[========[
function u77.OnExecution(p762, p763, u764)              

	if not p763.Rig then
		return;
	end;

	if u764.Name ~= "TwoTime" then
		local u765 = p763.Rig.PrimaryPart.CFrame.LookVector * 33;
		delay(2.783333333333333, function()              

			Ragdolls.AddProfile(u764, {
				Velocity = u765,
				KillEffects = {
					Explode = true
				}
			});
			local v766 = u764:FindFirstChildOfClass("Humanoid");

			if v766 then
				v766.BreakJointsOnDeath = false;
				v766.Health = 0;
			end;
		end);

		return;
	end;

	local MassInfectionShockwaveVignette = p763.Config.Instances.MassInfectionShockwaveVignette;
	local u767;

	if MassInfectionShockwaveVignette then
		u767 = MassInfectionShockwaveVignette:Clone();
	else
		u767 = MassInfectionShockwaveVignette;
	end;

	u767.Name = "AZUREQUICKSHINE1";
	u767.Parent = p763.Player.PlayerGui;
	local u768 = u767:FindFirstChildOfClass("ImageLabel");
	u768.ImageTransparency = 1;
	u764:FindFirstChild("GhostFire"):FindFirstChild("GhostfireBlade").Transparency = 0;
	delay(1.3333333333333333, function()              

		if MassInfectionShockwaveVignette then
			TweenService:Create(u768, TweenInfo.new(0.1, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut), {
				ImageTransparency = 0.9
			}):Play();
			task.delay(0.2, function()              

				TweenService:Create(u768, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
					ImageTransparency = 1
				}):Play();
			end);
		end;
	end);
	delay(2.65, function()              

		if MassInfectionShockwaveVignette then
			u768.ImageTransparency = 1;
			TweenService:Create(u768, TweenInfo.new(0.1, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut), {
				ImageTransparency = 0.9
			}):Play();
			task.delay(0.2, function()              

				TweenService:Create(u768, TweenInfo.new(0.75, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
					ImageTransparency = 1
				}):Play();
			end);
			task.delay(1, function()              

				u767:Destroy();
			end);
		end;

		local v769 = u764:FindFirstChildOfClass("Humanoid");

		if v769 then
			v769.Health = 0.01;
		end;
	end);
	delay(3.216666666666667, function()              

		Ragdolls.AddProfile(u764, {
			Velocity = Vector3.new(0, 0, 0)
		});
		local v770 = u764:FindFirstChildOfClass("Humanoid");

		if v770 then
			v770.BreakJointsOnDeath = false;
			v770.Health = 0;
		end;
	end);
end;
]========]
local newCallback=[========[
function u77.OnExecution(_,actor,victim)
 return require(script.ExecutionCompatibility).Run(actor,victim)
end;
]========]
local helperSource=[========[
-- Preserve Azure's execution timings; cosmetics must not be required for a kill.
local TweenService=game:GetService("TweenService")
local Debris=game:GetService("Debris")
local Ragdolls=require(game.ReplicatedStorage.Modules.Ragdolls)
local Execution={}
local function exists(victim)
 return victim and victim.Parent~=nil
end
local function finish(victim,profile)
 if not exists(victim) then return end
 -- A despawned/missing root cannot receive a ragdoll impulse, but should not prevent death.
 if victim.PrimaryPart then
  local ok,err=pcall(Ragdolls.AddProfile,victim,profile)
  if not ok then warn("[Azure execution] Optional ragdoll profile failed: "..tostring(err)) end
 end
 local hum=victim:FindFirstChildOfClass("Humanoid")
 if hum then hum.BreakJointsOnDeath=false;hum.Health=0 end
end
local function vignette(actor)
 local template=actor.Config and actor.Config.Instances and actor.Config.Instances.MassInfectionShockwaveVignette
 local gui=actor.Player and actor.Player:FindFirstChildOfClass("PlayerGui")
 if not template or not gui then return end
 local clone=template:Clone()
 local image=clone:FindFirstChildWhichIsA("ImageLabel",true)
 if not image then clone:Destroy();return end
 clone.Name="AZUREQUICKSHINE1";image.ImageTransparency=1;clone.Parent=gui
 Debris:AddItem(clone,4)
 return clone,image
end
local function flash(image,duration)
 if not image or not image.Parent then return end
 image.ImageTransparency=1
 TweenService:Create(image,TweenInfo.new(.1,Enum.EasingStyle.Quart,Enum.EasingDirection.InOut),{ImageTransparency=.9}):Play()
 task.delay(.2,function()
  if image.Parent then TweenService:Create(image,TweenInfo.new(duration,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{ImageTransparency=1}):Play() end
 end)
end
function Execution.Run(actor,victim)
 if not exists(victim) then return end
 if victim.Name~="TwoTime" then
  local root=actor.Rig and actor.Rig.PrimaryPart
  local velocity=root and root.CFrame.LookVector*33 or Vector3.new(0,0,0)
  task.delay(2.783333333333333,function()finish(victim,{Velocity=velocity,KillEffects={Explode=true}})end)
  return
 end
 local gui,image=vignette(actor)
 -- Two Time's new rig may omit or move the legacy dagger. It is only a cosmetic.
 local blade=victim:FindFirstChild("GhostfireBlade",true)
 if blade and blade:IsA("BasePart") then blade.Transparency=0 end
 task.delay(1.3333333333333333,function()
  if exists(victim) then flash(image,.5) elseif gui and gui.Parent then gui:Destroy() end
 end)
 task.delay(2.65,function()
  if not exists(victim) then if gui and gui.Parent then gui:Destroy() end;return end
  flash(image,.75)
  local hum=victim:FindFirstChildOfClass("Humanoid")
  -- Do not revive an already-dead humanoid if another combat event killed it first.
  if hum and hum.Health>0 then hum.Health=.01 end
 end)
 task.delay(3.216666666666667,function()
  finish(victim,{Velocity=Vector3.new(0,0,0)})
 end)
end
return Execution
]========]
local function find(path)
 local current=game
 for name in path:gmatch("[^/]+") do current=current and current:FindFirstChild(name) end
 return current
end
-- Compare callback tokens, not formatting. Strings and all executable tokens remain exact.
local function tokens(source,start,limit)
 local result={};local i=start or 1
 local function longEnd(at)
  local first,last,equals=source:find("%[(=*)%[",at)
  if first~=at then return end
  local _,finish=source:find("]"..equals.."]",last+1,true)
  assert(finish,"Unterminated long string/comment in Azure callback. Nothing changed.")
  return finish
 end
 while i<=#source and (not limit or #result<limit) do
  local c=source:sub(i,i)
  if c:match("%s") then i+=1
  elseif source:sub(i,i+1)=="--" then
   local finish=longEnd(i+2)
   if finish then i=finish+1 else local newline=source:find("\n",i+2,true);i=newline and newline+1 or #source+1 end
  else
   local first=i;local finish
   if c=='"' or c=="'" or c=="`" then
    local quote=c;i+=1
    while i<=#source do
     local nextChar=source:sub(i,i)
     if nextChar=="\\" then i+=2 elseif nextChar==quote then finish=i;i+=1;break else i+=1 end
    end
    assert(finish,"Unterminated quoted text in Azure callback. Nothing changed.")
   elseif c=="[" and longEnd(i) then finish=longEnd(i);i=finish+1
   else
    local a,b=source:find("[%a_][%w_]*",i)
    if a~=i then a,b=source:find("%d[%w_%.]*",i) end
    finish=a==i and b or i;i=finish+1
   end
   table.insert(result,{text=source:sub(first,finish),first=first,last=finish})
  end
 end
 return result
end
local function callbackRange(source,expected)
 local start=source:find("function%s+u77%.OnExecution%s*%(")
 if not start then return end
 assert(not source:find("function%s+u77%.OnExecution%s*%(",start+1),"Multiple Azure execution callbacks found. Nothing changed.")
 local wanted=tokens(expected)
 local actual=tokens(source,start,#wanted)
 if #actual~=#wanted then return end
 for i,token in ipairs(wanted) do if actual[i].text~=token.text then return end end
 return actual[1].first,actual[#actual].last
end

local pending={}
for _,path in {"ReplicatedStorage/Assets/Killers/Azure/Behavior","ServerStorage/Assets/Killers/Azure/Behavior"} do
 local target=find(path)
 if target and target:IsA("ModuleScript") then
  local before=target.Source
  local first,last=callbackRange(before,oldCallback)
  local already=callbackRange(before,newCallback)
  if first or already then
   local existing=target:FindFirstChild("ExecutionCompatibility")
   assert(not existing or existing:IsA("ModuleScript"),"Unexpected execution helper at "..path..". Nothing changed.")
   local after=first and before:sub(1,first-1)..newCallback..before:sub(last+1) or before
   assert(#after<200000 and #helperSource<200000,"A module exceeds Studio's Source limit. Nothing changed.")
   if first or not existing or existing.Source~=helperSource then table.insert(pending,{target=target,path=path,before=before,after=after,existing=existing,oldHelper=existing and existing.Source}) end
  else
   error("Azure execution callback has different executable code from the supported port: "..path..". Nothing changed; send the current Behavior source for a matching repair.")
  end
 end
end
assert(find("ReplicatedStorage/Assets/Killers/Azure/Behavior"),"Azure Behavior is missing. Nothing changed.")
if #pending==0 then print("[Azure execution repair] Already installed.");return end
local backup=Instance.new("Folder");backup.Name="AzureExecution_Backup_"..os.date("!%Y%m%d_%H%M%S");backup.Parent=game.ServerStorage
for i,item in pending do
 local saved=item.target:Clone();saved.Name=tostring(i);saved:SetAttribute("OriginalPath",item.path);saved.Parent=backup
end
local ok,err=pcall(function()
 for _,item in pending do
  item.helper=item.existing or Instance.new("ModuleScript");item.helper.Name="ExecutionCompatibility";item.helper.Source=helperSource;item.helper.Parent=item.target
  item.target.Source=item.after
 end
end)
if not ok then
 for i=#pending,1,-1 do
  local item=pending[i];item.target.Source=item.before
  if item.existing then item.existing.Source=item.oldHelper elseif item.helper then item.helper:Destroy() end
 end
 backup:Destroy();error("[Azure execution repair] Rolled back: "..tostring(err))
end
pcall(function()game:GetService("ChangeHistoryService"):SetWaypoint("Azure execution repair")end)
print("[Azure execution repair] Applied. Backup: "..backup:GetFullName()..". Save, then start a fresh playtest.")
