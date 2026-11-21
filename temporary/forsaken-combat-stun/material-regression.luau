local mode='normal'
local writes=0
local instances={}
local methods={}
local mt={}
mt.__index=function(self,key)
 if key=='Name' then return self._name end
 if key=='Parent' then return self._parent end
 if key=='Source' then return self._source end
 return methods[key] or self._children[key]
end
mt.__newindex=function(self,key,value)
 if key=='Name' then
  if self._parent then self._parent._children[self._name]=nil;self._parent._children[value]=self end
  self._name=value
 elseif key=='Parent' then
  if self._parent then self._parent._children[self._name]=nil end
  self._parent=value
  if value then value._children[self._name]=self end
 elseif key=='Source' then
  writes+=1
  if mode=='fail' and writes==2 then mode='normal';error('simulated Source write failure')end
  self._source=value
 else rawset(self,key,value)end
end
local Instance={new=function(class)
 local item=setmetatable({_class=class,_name=class,_children={},_attrs={},_source='',_parent=false},mt)
 table.insert(instances,item);return item
end}
function methods:FindFirstChild(name)return self._children[name]end
function methods:GetChildren()local result={};for _,v in self._children do table.insert(result,v)end;return result end
function methods:IsA(class)return self._class==class end
function methods:SetAttribute(k,v)self._attrs[k]=v end
function methods:GetAttribute(k)return self._attrs[k]end
function methods:GetFullName()return self._parent and self._parent:GetFullName()..'.'..self.Name or self.Name end
function methods:Destroy()self.Parent=nil end
function methods:FindFirstChildOfClass(class)for _,node in self._children do if node:IsA(class)then return node end end end
function methods:Clone()
 local clone=Instance.new(self._class);clone.Name=self.Name;clone.Source=self.Source
 for _,key in {'MeshId','ColorMap','TexturePack','EmissiveMaskContent','EmissiveTint','EmissiveStrength','Color','AlphaMode'} do clone[key]=self[key]end
 for k,v in self._attrs do clone._attrs[k]=v end
 for _,child in self._children do local copy=child:Clone();copy.Parent=clone end
 return clone
end
local game=Instance.new('DataModel');game.Name='game'
function methods:GetService(name)
 if name=='RunService' then return {IsStudio=function()return true end,IsRunning=function()return false end}end
 if name=='ChangeHistoryService' then return {SetWaypoint=function()end}end
 return self:FindFirstChild(name)
end
local function path(path,class)
 local current=game
 for part in path:gmatch('[^/]+')do
  local child=current:FindFirstChild(part)
  if not child then child=Instance.new('Folder');child.Name=part;child.Parent=current end
  current=child
 end
 if class then current._class=class end
 return current
end
path('ReplicatedStorage/Modules/StatusEffects')
path('ServerStorage')
path('ReplicatedStorage/Modules/Hitboxes','ModuleScript').Source='DamageOverride hitResponse == "Ignored"'

local previousNewIndex=mt.__newindex
local previousIndex=mt.__index
local mapKeys={ColorMap=true,ColorMapContent=true,EmissiveMaskContent=true,TexturePack=true}
mt.__index=function(self,key)
 if rawget(self,"_compiled") and mapKeys[key] then return self._mapValues[key]end
 return previousIndex(self,key)
end
mt.__newindex=function(self,key,value)
 if rawget(self,"_compiled") and mapKeys[key] then error('compiled maps cannot be reassigned')end
 return previousNewIndex(self,key,value)
end
local factoryCalls={}
local oldGetService=methods.GetService
methods.GetService=function(self,name)
 if name=='ContentProvider' then return {PreloadAsync=function(_,ids,callback)
 if mode=='loadFail' then mode='normal';callback(ids[1],'Failure');return end
 for _,id in ids do callback(id,'Success')end end}end
 if name=='AssetService' then return {CreateSurfaceAppearanceAsync=function(_,maps)
  if mode=='maskFail' then mode='normal';error('simulated material creation failure')end
  table.insert(factoryCalls,maps)
  local appearance=Instance.new('SurfaceAppearance')
  appearance._compiled=true
  appearance._mapValues={ColorMap=maps.ColorMap.Uri,ColorMapContent=maps.ColorMap,EmissiveMaskContent=maps.EmissiveMask,TexturePack='compiled://fresh-material'}
  return appearance
 end}end
 return oldGetService(self,name)
end
local Color3={new=function(...)return {...}end,fromRGB=function(...)return {...}end}
local Content={fromUri=function(uri)return {Uri=uri}end}
local Enum={AssetFetchStatus={Success='Success'},AlphaMode={Transparency=1}}
local parent=path('ReplicatedStorage/Assets/Instances')
local template=Instance.new('MeshPart');template.Name='StunProtectionVFX';template.MeshId='rbxassetid://76640378318129';template:SetAttribute('StunPortVersion','1.0.0');template.Parent=parent
local material=Instance.new('SurfaceAppearance');material.Name='SurfaceAppearance';material.ColorMap='rbxassetid://128651191436151';material.TexturePack='rbxassetid://74597329653279';material.EmissiveStrength=6.28;material.Parent=template
local gameplay=path('ReplicatedStorage/Modules/Statuses','ModuleScript');gameplay.Source='GAMEPLAY MUST NOT CHANGE'
local function repair()
-- Material-only correction: compile colour + emission maps through Roblox's supported API.
assert(game:GetService("RunService"):IsStudio() and not game:GetService("RunService"):IsRunning(),"Stop Play before repairing the material.")
local parent=game.ReplicatedStorage.Assets.Instances
local target=assert(parent:FindFirstChild("StunProtectionVFX"),"Install the stun-protection port first.")
assert(target:IsA("MeshPart") and target.MeshId:match("%d+")=="76640378318129","Unexpected stun-protection mesh. Nothing changed.")
if target:GetAttribute("StunMaterialRepairVersion")=="1.0.2" then print("[Stun Material Repair] Already applied.");return end
local replacement=target:Clone()
local ok,err=pcall(function()
 local failed={}
 game:GetService("ContentProvider"):PreloadAsync({"rbxassetid://128651191436151","rbxassetid://88194642418565"},function(id,status)
  if status~=Enum.AssetFetchStatus.Success then table.insert(failed,tostring(id).." ("..tostring(status)..")") end
 end)
 assert(#failed==0,"Required material image could not load: "..table.concat(failed,", "))
 local appearance=game:GetService("AssetService"):CreateSurfaceAppearanceAsync({
  ColorMap=Content.fromUri("rbxassetid://128651191436151"),
  EmissiveMask=Content.fromUri("rbxassetid://88194642418565")
 })
 assert(appearance and appearance:IsA("SurfaceAppearance"),"Roblox did not return a compiled SurfaceAppearance.")
 appearance.Name="SurfaceAppearance"
 appearance.EmissiveTint=Color3.fromRGB(0,79,255)
 appearance.EmissiveStrength=6.28
 appearance.Color=Color3.new(1,1,1)
 appearance.AlphaMode=Enum.AlphaMode.Transparency
 for _,old in replacement:GetChildren() do if old:IsA("SurfaceAppearance") then old:Destroy() end end
 appearance.Parent=replacement
 replacement:SetAttribute("PackedMaterialImported",false)
 replacement:SetAttribute("MaterialCompiledFromMaps",true)
 replacement:SetAttribute("StunPortVersion","1.0.2")
 replacement:SetAttribute("StunMaterialRepairVersion","1.0.2")
 replacement:SetAttribute("EmissiveMaskAsset","rbxassetid://88194642418565")
end)
if not ok then replacement:Destroy();error("Material could not be prepared. Nothing changed. Roblox material creation error: "..tostring(err))end
local backup=Instance.new("Folder")
backup.Name="StunProtectionMaterial_Backup_"..os.date("!%Y%m%d_%H%M%S")
backup.Parent=game.ServerStorage
local saved=target:Clone();saved.Name="StunProtectionVFX";saved.Parent=backup
ok,err=pcall(function()target.Parent=nil;replacement.Parent=parent end)
if not ok then replacement:Destroy();target.Parent=parent;backup:Destroy();error("Material repair rolled back: "..tostring(err))end
target:Destroy()
pcall(function()game:GetService("ChangeHistoryService"):SetWaypoint("Stun Protection Material")end)
print("[Stun Material Repair] Rebuilt the rendered material with UPD's emissive mask 88194642418565. Backup: "..backup:GetFullName()..". Save and start a fresh playtest. Stun gameplay is unchanged.")

end
local function restore()
-- Restores the most recent material-only repair, keeping the stun protection gameplay installed.
assert(game:GetService("RunService"):IsStudio() and not game:GetService("RunService"):IsRunning(),"Stop Play first.")
local backups={}
for _,folder in game.ServerStorage:GetChildren() do
 if folder:IsA("Folder") and folder.Name:match("^StunProtectionMaterial_Backup_") then table.insert(backups,folder) end
end
table.sort(backups,function(a,b)return a.Name>b.Name end)
local backup=assert(backups[1],"No stun material repair backup found.")
local saved=assert(backup:FindFirstChild("StunProtectionVFX"),"Missing saved material template.")
local parent=game.ReplicatedStorage.Assets.Instances
local target=assert(parent:FindFirstChild("StunProtectionVFX"),"Missing current template.")
assert(target:GetAttribute("StunMaterialRepairVersion")=="1.0.1" or target:GetAttribute("StunMaterialRepairVersion")=="1.0.2","The current template is not the material repair. Nothing restored.")
local restored=saved:Clone()
local ok,err=pcall(function()target.Parent=nil;restored.Parent=parent end)
if not ok then restored:Destroy();target.Parent=parent;error("Material restore rolled back: "..tostring(err))end
target:Destroy();backup:Destroy()
print("[Stun Material Repair] Restored the previous material. Save and start a fresh playtest.")

end
mode='loadFail';local ok=pcall(repair);assert(not ok and #factoryCalls==0 and parent:FindFirstChild('StunProtectionVFX')==template)
mode='maskFail';ok=pcall(repair);assert(not ok)
assert(parent:FindFirstChild('StunProtectionVFX')==template and material.EmissiveMaskContent==nil)
assert(#game.ServerStorage:GetChildren()==0,'failed preparation must not leave a partial backup')
repair()
local installed=parent:FindFirstChild('StunProtectionVFX');local appearance=installed:FindFirstChildOfClass('SurfaceAppearance')
assert(appearance.EmissiveMaskContent.Uri=='rbxassetid://88194642418565')
assert(#factoryCalls==1 and factoryCalls[1].ColorMap.Uri=='rbxassetid://128651191436151' and factoryCalls[1].EmissiveMask.Uri=='rbxassetid://88194642418565')
assert(appearance.EmissiveTint[1]==0 and appearance.EmissiveTint[2]==79 and appearance.EmissiveTint[3]==255)
assert(appearance.EmissiveStrength==6.28 and appearance.TexturePack=='compiled://fresh-material')
assert(appearance.ColorMap=='rbxassetid://128651191436151' and appearance.AlphaMode==1)
assert(gameplay.Source=='GAMEPLAY MUST NOT CHANGE')
local count=#game.ServerStorage:GetChildren();repair();assert(#game.ServerStorage:GetChildren()==count and parent:FindFirstChild('StunProtectionVFX')==installed and #factoryCalls==1)
restore();local restored=parent:FindFirstChild('StunProtectionVFX')
assert(restored:FindFirstChildOfClass('SurfaceAppearance').EmissiveMaskContent==nil)
assert(restored.MeshId=='rbxassetid://76640378318129' and restored:GetAttribute('StunMaterialRepairVersion')==nil)
assert(gameplay.Source=='GAMEPLAY MUST NOT CHANGE')
print('Material rebuild: immutable compiled maps, exact input URIs, failed creation, repeat apply and restoration passed')
