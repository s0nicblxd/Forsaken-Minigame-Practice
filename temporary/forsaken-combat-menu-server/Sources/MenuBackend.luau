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
