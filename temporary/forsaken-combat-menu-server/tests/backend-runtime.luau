
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

local nativeTypeof=typeof
local function typeof(value)if type(value)=="table"and value._props then return "Instance"end;return nativeTypeof(value)end
local oldIsA=Methods.IsA
function Methods:IsA(class)
 if class=="ValueBase"then return table.find({"StringValue","IntValue","NumberValue","BoolValue"},self.ClassName)~=nil end
 return oldIsA(self,class)
end
local function locate(path)
 local object=game;for name in path:gmatch("[^/]+")do object=object and object:FindFirstChild(name)end;return object
end
local function ensure(path,class)
 local object=game;local parts=string.split(path,"/")
 for i,name in parts do object=object:FindFirstChild(name)or child(object,name,i==#parts and class or "Folder")end
 return object
end

fresh()
local callbacks={}
local network={SetConnection=function(_,name,kind,callback)callbacks[name]=callback end}
local function require(_)return network end
local removals={}
local players=child(game,"Players")
players.PlayerRemoving={Connect=function(_,callback)table.insert(removals,callback)end}
local debris=child(game,"Debris");local scheduled={}
function debris:AddItem(object,seconds)table.insert(scheduled,{object,seconds})end
local Backend=(function()
local Backend = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Debris = game:GetService("Debris")
local Network = require(ReplicatedStorage.Modules.Network)
local buckets = {}
local previews = {}

local function allowed(player, key, capacity, period)
 local now = os.clock()
 local state = buckets[player]
 if not state then state = {}; buckets[player] = state end
 local bucket = state[key]
 if not bucket then bucket = {tokens=capacity, time=now}; state[key] = bucket end
 bucket.tokens = math.min(capacity, bucket.tokens + (now-bucket.time)*capacity/period)
 bucket.time = now
 if bucket.tokens < 1 then return false end
 bucket.tokens -= 1
 return true
end
local function validName(name)
 return type(name)=="string" and #name>0 and #name<=200 and not name:find("/",1,true)
end
local function owned(data, category, name)
 local purchased = data and data:FindFirstChild("Purchased")
 local folder = purchased and purchased:FindFirstChild(category)
 local item = folder and folder:FindFirstChild(name)
 return item and not item:GetAttribute("Temp")
end
local function marker(folder, name, enabled)
 local old = folder:FindFirstChild(name)
 if enabled then
  if not old then local value=Instance.new("BoolValue");value.Name=name;value.Value=true;value.Parent=folder end
 elseif old then old:Destroy() end
end
local function favoriteCharacter(player, role, name, enabled)
 if (role~="Killers" and role~="Survivors") or not validName(name) or type(enabled)~="boolean" then return end
 if not allowed(player,"Favorites",30,5) then return end
 local data=player:FindFirstChild("PlayerData")
 local catalog=ReplicatedStorage.Assets:FindFirstChild(role)
 if not catalog or not catalog:FindFirstChild(name) or not owned(data,role,name) then return end
 local favorites=data:FindFirstChild("Favorites")
 local folder=favorites and favorites:FindFirstChild(role)
 if folder then marker(folder,name,enabled) end
end
local function favoriteSkin(player, actor, name, enabled)
 if not validName(actor) or not validName(name) or type(enabled)~="boolean" then return end
 if not allowed(player,"Favorites",30,5) then return end
 local data=player:FindFirstChild("PlayerData")
 if not owned(data,"Skins",name) then return end
 local valid=false
 for _,role in {"Killers","Survivors"} do
  local group=ReplicatedStorage.Assets.Skins:FindFirstChild(role)
  local folder=group and group:FindFirstChild(actor)
  if folder and folder:FindFirstChild(name) then valid=true;break end
 end
 if not valid then return end
 local favorites=data:FindFirstChild("Favorites")
 local skins=favorites and favorites:FindFirstChild("Skins")
 local folder=skins and skins:FindFirstChild(actor)
 if folder then marker(folder,name,enabled) end
end
local function requestPreview(player, skin, actor)
 if typeof(skin)~="Instance" or typeof(actor)~="Instance" then return nil end
 local role=actor.Parent
 if not role or (role.Name~="Killers" and role.Name~="Survivors") or role.Parent~=ReplicatedStorage.Assets then return nil end
 local skinRole=ReplicatedStorage.Assets.Skins:FindFirstChild(role.Name)
 local actorSkins=skinRole and skinRole:FindFirstChild(actor.Name)
 if not actorSkins or skin.Parent~=actorSkins or not skin:FindFirstChild("Config") then return nil end
 if not player:FindFirstChild("PlayerData") or not allowed(player,"Preview",8,10) then return nil end
 local model=skin:FindFirstChild("Rig")
 if not model or not model:IsA("Model") then
  local assets=game.ServerStorage:FindFirstChild("Assets")
  local rigs=assets and assets:FindFirstChild("Rigs")
  local category=rigs and rigs:FindFirstChild(role.Name)
  local character=category and category:FindFirstChild(actor.Name)
  model=character and (character:FindFirstChild(skin.Name) or character:FindFirstChild((skin.Name:gsub(actor.Name,""))))
 end
 if not model or not model:IsA("Model") then model=actor:FindFirstChild("Rig") end
 if not model or not model:IsA("Model") then return nil end
 local gui=player:FindFirstChildOfClass("PlayerGui")
 if not gui then return nil end
 local clone=model:Clone()
 for _,object in clone:GetDescendants() do
  if object:IsA("LuaSourceContainer") or object:IsA("ProximityPrompt") or object:IsA("ClickDetector") or object:IsA("Sound") then
   object:Destroy()
  elseif object:IsA("BasePart") then
   object.CanCollide=false;object.CanTouch=false;object.CanQuery=false
  end
 end
 clone:SetAttribute("PreviewDescendants",#clone:GetDescendants())
 local previous=previews[player]
 if previous then previous:Destroy() end
 previews[player]=clone
 clone.Name="CombatMenuPreview"
 clone.Parent=gui
 Debris:AddItem(clone,30)
 return clone
end
function Backend.Start()
 Network:SetConnection("FavoriteCharacter","REMOTE_EVENT",favoriteCharacter)
 Network:SetConnection("FavoriteSkin","REMOTE_EVENT",favoriteSkin)
 Network:SetConnection("RequestPreviewRig","REMOTE_FUNCTION",requestPreview)
 Players.PlayerRemoving:Connect(function(player)
  buckets[player]=nil
  if previews[player] then previews[player]:Destroy();previews[player]=nil end
 end)
end
return Backend

end)()
Backend.Start()
local function player(name)
 local p=child(players,name,"Player");child(p,"PlayerGui","PlayerGui")
 local data=child(p,"PlayerData");local purchased=child(data,"Purchased")
 for _,role in {"Killers","Survivors","Skins"}do child(purchased,role)end
 local favorites=child(data,"Favorites")
 child(favorites,"Killers");child(favorites,"Survivors");child(child(favorites,"Skins"),"JohnDoe")
 return p,data
end
local p,data=player("A");local p2,data2=player("B")
local killers=ensure("ReplicatedStorage/Assets/Killers");local actor=child(killers,"JohnDoe")
local skinFolder=ensure("ReplicatedStorage/Assets/Skins/Killers/JohnDoe");local skin=child(skinFolder,"CoolJohn")
child(skin,"Config","ModuleScript")
child(data.Purchased.Killers,"JohnDoe","IntValue");child(data.Purchased.Skins,"CoolJohn","IntValue")
callbacks.FavoriteCharacter(p,"Killers","JohnDoe",true)
assert(data.Favorites.Killers:FindFirstChild("JohnDoe"))
callbacks.FavoriteCharacter(p,"Killers","JohnDoe",true)
assert(#data.Favorites.Killers:GetChildren()==1)
callbacks.FavoriteCharacter(p,"Killers","JohnDoe",false)
assert(not data.Favorites.Killers:FindFirstChild("JohnDoe"))
callbacks.FavoriteCharacter(p,"Killers","JohnDoe",true)
callbacks.FavoriteCharacter(p2,"Killers","JohnDoe",true)
assert(not data2.Favorites.Killers:FindFirstChild("JohnDoe"))
callbacks.FavoriteCharacter(p,"Killers","NotOwned",true)
callbacks.FavoriteCharacter(p,"Invalid","JohnDoe",true)
callbacks.FavoriteCharacter(p,"Killers",{},true)
callbacks.FavoriteCharacter(p,"Killers","JohnDoe","yes")
assert(#data.Favorites.Killers:GetChildren()==1)
callbacks.FavoriteSkin(p,"JohnDoe","CoolJohn",true)
assert(data.Favorites.Skins.JohnDoe.CoolJohn)
callbacks.FavoriteSkin(p,"Noob","CoolJohn",true)
assert(not data.Favorites.Skins:FindFirstChild("Noob"))
callbacks.FavoriteSkin(p,"JohnDoe","CoolJohn",false)
assert(not data.Favorites.Skins.JohnDoe:FindFirstChild("CoolJohn"))
data.Purchased.Skins.CoolJohn:SetAttribute("Temp",true)
callbacks.FavoriteSkin(p,"JohnDoe","CoolJohn",true)
assert(not data.Favorites.Skins.JohnDoe:FindFirstChild("CoolJohn"))
local rigs=ensure("ServerStorage/Assets/Rigs/Killers/JohnDoe")
local rig=child(rigs,"CoolJohn","Model");local part=child(rig,"Head","Part")
child(part,"Script","Script");child(rig,"PrivateModule","ModuleScript");child(rig,"Sound","Sound")
local result=callbacks.RequestPreviewRig(p,skin,actor)
assert(result and result.Parent==p.PlayerGui)
assert(not result:FindFirstChild("PrivateModule")and not result:FindFirstChild("Sound")and not result.Head:FindFirstChild("Script"))
assert(result.Head.CanCollide==false and result.Head.CanTouch==false)
assert(result:GetAttribute("PreviewDescendants")==#result:GetDescendants())
assert(rig.PrivateModule and rig.Head.Script and rig.Parent==rigs,"original rig was changed")
local second=callbacks.RequestPreviewRig(p,skin,actor);assert(second and result.Destroyed)
local other=callbacks.RequestPreviewRig(p2,skin,actor);assert(other and not second.Destroyed)
assert(callbacks.RequestPreviewRig(p,rig,actor)==nil)
assert(callbacks.RequestPreviewRig(p,skin,rig)==nil)
assert(callbacks.RequestPreviewRig(p,"bad",actor)==nil)
for i=1,15 do callbacks.RequestPreviewRig(p,skin,actor)end
assert(callbacks.RequestPreviewRig(p,skin,actor)==nil,"preview rate limit absent")
for _,callback in removals do callback(p)end
assert(other.Parent==p2.PlayerGui,"cleanup crossed player boundary")
assert(scheduled[1][2]==30)
for i=1,40 do callbacks.FavoriteCharacter(p2,"Killers","JohnDoe",true)end
child(data2.Purchased.Killers,"JohnDoe","IntValue")
callbacks.FavoriteCharacter(p2,"Killers","JohnDoe",true)
assert(not data2.Favorites.Killers:FindFirstChild("JohnDoe"),"favorites rate limit absent")
print("PASS favorite ownership/type/role checks, idempotence/removal, temporary purchases, preview validation/sanitation/isolation/cleanup and rate limits")
