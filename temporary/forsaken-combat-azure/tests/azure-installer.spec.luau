
local writes=0
local failAt=nil
local function copy(t)local out={};for k,v in pairs(t)do out[k]=v end;return out end
local Methods={}
local mt={}
function mt.__index(self,k)
 if Methods[k]then return Methods[k] end
 if k=="Parent"then return self._parent end
 local value=self._props[k]
 if value~=nil then return value end
 return self:FindFirstChild(k)
end
function mt.__newindex(self,k,v)
 if k=="Parent"then
  if self._parent then local old=self._parent._children;local i=table.find(old,self);if i then table.remove(old,i)end end
  rawset(self,"_parent",v);if v then table.insert(v._children,self)end
 else
  if k=="Source"then writes+=1;if failAt==writes then error("Injected Source write failure")end end
  self._props[k]=v
 end
end
local Instance={}
function Instance.new(class,parent)
 local self=setmetatable({_props={ClassName=class,Name=class},_children={},_attrs={}},mt)
 if parent then self.Parent=parent end
 return self
end
function Methods:IsA(class)
 return self.ClassName==class or class=="LuaSourceContainer"and(self.ClassName=="Script"or self.ClassName=="ModuleScript"or self.ClassName=="LocalScript")or class=="BasePart"and(self.ClassName=="Part"or self.ClassName=="MeshPart")
end
function Methods:FindFirstChild(name,recursive)
 for _,child in ipairs(self._children)do if child.Name==name then return child end end
 if recursive then for _,child in ipairs(self._children)do local found=child:FindFirstChild(name,true);if found then return found end end end
end
function Methods:FindFirstChildOfClass(class)for _,child in ipairs(self._children)do if child:IsA(class)then return child end end end
function Methods:GetChildren()return table.clone(self._children)end
function Methods:GetDescendants()local out={};for _,child in ipairs(self._children)do table.insert(out,child);for _,desc in ipairs(child:GetDescendants())do table.insert(out,desc)end end;return out end
function Methods:SetAttribute(k,v)self._attrs[k]=v end
function Methods:GetAttribute(k)return self._attrs[k]end
function Methods:Clone()
 local object=Instance.new(self.ClassName);object._props=copy(self._props);object._attrs=copy(self._attrs)
 for _,child in ipairs(self._children)do child:Clone().Parent=object end
 return object
end
function Methods:Destroy()self.Parent=nil;self.Destroyed=true;for _,child in ipairs(self:GetChildren())do child:Destroy()end end
function Methods:GetFullName()return (self.Parent and self.Parent:GetFullName().."."or "")..self.Name end
local game,workspace
local function child(parent,name,class)local o=Instance.new(class or "Folder");o.Name=name;o.Parent=parent;return o end
local function fresh()
 writes=0;failAt=nil
 game=Instance.new("DataModel");workspace=child(game,"Workspace","Workspace")
 local rep=child(game,"ReplicatedStorage");local assets=child(rep,"Assets");local survivors=child(assets,"Survivors")
 local modules=child(rep,"Modules");local statuses=child(modules,"StatusEffects");local misc=child(modules,"Misc")
 for _,name in {"Actors","Util","Statuses","Network","Sounds"}do child(modules,name,"ModuleScript")end
 for _,name in {"Maid","Trove"}do child(misc,name,"ModuleScript")end
 child(game,"ServerStorage")
 function game:GetService(name)
  if name=="RunService"then return {IsStudio=function()return true end,IsRunning=function()return false end}end
  if name=="ChangeHistoryService"then return {SetWaypoint=function()end}end
  return self:FindFirstChild(name)
 end
 return survivors,statuses
end
local function inputs()
 local donor=child(workspace,"HelperbotDonor");local rig=child(donor,"Rig","Model")
 child(rig,"Humanoid","Humanoid");child(rig,"HumanoidRootPart","Part")
 local upd=child(workspace,"HelperbotUPD");local config=child(upd,"Config","ModuleScript");local fx=child(config,"VFX")
 for _,name in {"Pulse","PulseHit","InspireActive"}do child(fx,name,"Attachment")end
 child(config,"Radar","MeshPart");child(config,"ChargeMeter","BillboardGui");child(config,"cl_HelperbotChargeBillboard","ModuleScript")
end

local legacy=[==========[
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
]==========]
local function install()
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

end
local function restore()
-- Stop Play before restoring the latest Azure execution repair.
assert(game:GetService("RunService"):IsStudio() and not game:GetService("RunService"):IsRunning(),"Stop Play first.")
local backups={}
for _,item in game.ServerStorage:GetChildren() do if item.Name:match("^AzureExecution_Backup_") then table.insert(backups,item) end end
table.sort(backups,function(a,b)return a.Name>b.Name end)
local backup=assert(backups[1],"No Azure execution backup found.")
local pending={}
for _,saved in backup:GetChildren() do
 local target=game
 for part in saved:GetAttribute("OriginalPath"):gmatch("[^/]+") do target=target and target:FindFirstChild(part) end
 assert(target and target:IsA("ModuleScript"),"Missing Azure target. Nothing restored.")
 table.insert(pending,{target=target,saved=saved})
end
for _,item in pending do
 item.target.Source=item.saved.Source
 local helper=item.target:FindFirstChild("ExecutionCompatibility");if helper then helper:Destroy() end
 local original=item.saved:FindFirstChild("ExecutionCompatibility");if original then original:Clone().Parent=item.target end
end
backup:Destroy()
print("[Azure execution repair] Restored. Save and restart Play.")

end
local function azureFixture(server)
 fresh()
 local killers=child(game.ReplicatedStorage.Assets,"Killers")
 local azure=child(killers,"Azure");local behavior=child(azure,"Behavior","ModuleScript")
 local before="local u77={}\n-- keep the rest of Azure intact\n"..legacy.."\nreturn u77;"
 behavior.Source=before
 local second
 if server then
  local assets=child(game.ServerStorage,"Assets");local killers=child(assets,"Killers");local azure=child(killers,"Azure")
  second=child(azure,"Behavior","ModuleScript");second.Source=before
 end
 return behavior,before,second
end
local behavior,before,second=azureFixture(true)
install();assert(behavior.ExecutionCompatibility and second.ExecutionCompatibility)
assert(behavior.Source:find("-- keep the rest of Azure intact",1,true) and not behavior.Source:find("GhostfireBlade",1,true))
local after=behavior.Source;local backups=#game.ServerStorage:GetChildren();install()
assert(behavior.Source==after and #game.ServerStorage:GetChildren()==backups)
restore();assert(behavior.Source==before and second.Source==before and not behavior.ExecutionCompatibility and not second.ExecutionCompatibility)
-- A live edit outside the callback is preserved by the surgical replacement.
behavior,before=azureFixture(false)
behavior.Source="-- custom harmless change\n"..before;install();assert(behavior.Source:find("-- custom harmless change",1,true))
-- An unsupported callback in either copy stops preflight before any source changes.
behavior,before,second=azureFixture(true);second.Source="return {}"
local ok=pcall(install);assert(not ok and behavior.Source==before and not behavior.ExecutionCompatibility)
-- Studio and prior installers may change indentation, blank lines, comments, or CRLF.
for _,format in ipairs({
 function(s)return s:gsub("\t","    ")end,
 function(s)return s:gsub(" +\n","\n")end,
 function(s)return s:gsub("\n","\r\n")end,
 function(s)return s:gsub("if not p763.Rig then","-- benign editor comment\n if not p763.Rig then",1)end
}) do
 behavior,before=azureFixture(false)
 behavior.Source=format(before)
 local formatted=behavior.Source
 install();assert(behavior.ExecutionCompatibility)
 install();restore();assert(behavior.Source==formatted,"restore changed original formatting")
end
-- Matching ignores comments/whitespace, but never changes to quoted data or executable code.
behavior,before=azureFixture(false)
behavior.Source=before:gsub('"TwoTime"','"Two Time"',1)
local edited=behavior.Source
ok=pcall(install);assert(not ok and behavior.Source==edited and not behavior.ExecutionCompatibility)
-- If a Source write fails, existing Azure behavior and helpers roll back together.
behavior,before=azureFixture(false);failAt=writes+2
ok=pcall(install);assert(not ok and behavior.Source==before and not behavior.ExecutionCompatibility and #game.ServerStorage:GetChildren()==0)
print("PASS Azure repair installer: paired targets, surgical edits, idempotence, restore, unsupported callback refusal, Source failure rollback")
