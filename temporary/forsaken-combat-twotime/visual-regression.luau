local function vec(...)return {...}end
local Vector2={new=vec};local Vector3={new=vec};local Color3={new=vec};local CFrame={new=vec};local NumberRange={new=vec}
local function sequence(points)
 assert(points[1].Time==0 and points[#points].Time==1)
 local previous=-1
 for _,point in points do assert(point.Time>previous and point.Time<=1);previous=point.Time end
 return points
end
local NumberSequence={new=sequence};local ColorSequence={new=sequence}
local NumberSequenceKeypoint={new=function(time,value,envelope)return {Time=time,Value=value,Envelope=envelope}end}
local ColorSequenceKeypoint=NumberSequenceKeypoint
local Enum={}
Enum.NormalId={GetEnumItems=function()return {{Name="Right",Value=0},{Name="Top",Value=1},{Name="Back",Value=2},{Name="Left",Value=3},{Name="Bottom",Value=4},{Name="Front",Value=5}}end}
Enum.ParticleEmitterShape={GetEnumItems=function()return {{Name="Box",Value=0},{Name="Sphere",Value=1},{Name="Cylinder",Value=2},{Name="Disc",Value=3}}end}
Enum.ParticleEmitterShapeInOut={GetEnumItems=function()return {{Name="Outward",Value=0},{Name="Inward",Value=1},{Name="InAndOut",Value=2}}end}
Enum.ParticleEmitterShapeStyle={GetEnumItems=function()return {{Name="Volume",Value=0},{Name="Surface",Value=1}}end}
Enum.ParticleFlipbookLayout={GetEnumItems=function()return {{Name="None",Value=0},{Name="Grid2x2",Value=1},{Name="Grid4x4",Value=2},{Name="Grid8x8",Value=3},{Name="Custom",Value=4}}end}
Enum.ParticleFlipbookMode={GetEnumItems=function()return {{Name="Loop",Value=0},{Name="OneShot",Value=1},{Name="PingPong",Value=2},{Name="Random",Value=3}}end}
Enum.ParticleOrientation={GetEnumItems=function()return {{Name="FacingCamera",Value=0},{Name="FacingCameraWorldUp",Value=1},{Name="VelocityParallel",Value=2},{Name="VelocityPerpendicular",Value=3}}end}
Enum.TextureMode={GetEnumItems=function()return {{Name="Stretch",Value=0},{Name="Wrap",Value=1},{Name="Static",Value=2}}end}
local methods={};local mt={}
mt.__index=function(self,key)if key=='Parent' then return self._parent end return methods[key]end
mt.__newindex=function(self,key,value)
 if key=='Parent' then
  if self._parent then self._parent._children[self]=nil end
  self._parent=value
  if value then value._children[self]=true end
 else rawset(self,key,value)end
end
local Instance={new=function(class)return setmetatable({_class=class,_parent=false,_children={},_attributes={}},mt)end}
function methods:SetAttribute(key,value)self._attributes[key]=value end
function methods:GetAttribute(key)return self._attributes[key]end
function methods:GetChildren()local result={};for child in self._children do table.insert(result,child)end;return result end
function methods:GetDescendants()
 local result={};for child in self._children do table.insert(result,child);for _,desc in child:GetDescendants() do table.insert(result,desc)end end;return result
end
function methods:IsA(class)return self._class==class or class=='Light' and self._class=='SpotLight' end
function methods:Destroy()for _,child in self:GetChildren()do child:Destroy()end;self.Parent=nil;self.destroyed=true end
function methods:Emit(count)self.emitted=(self.emitted or 0)+count end
local function find(root,name)for _,item in root:GetDescendants()do if item.Name==name then return item end end end
local Visuals=(function()
-- Reconstructed from newest UPD instance properties. Public textures only.
local Visuals={}
local function enum(enumType,value) for _,item in enumType:GetEnumItems() do if item.Value==value then return item end end end
function Visuals.Build(kind)
 local objects={}
 objects[59005]=Instance.new("Folder")
 objects[59005].Name="LungeIndicator"
 objects[59006]=Instance.new("Beam")
 objects[59006].Name="Beam"
 objects[59006].Brightness=4
 objects[59006].Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.new(0.203921571,0.250980407,0.384313732)),ColorSequenceKeypoint.new(1,Color3.new(0.203921571,0.250980407,0.384313732))})
 objects[59006].CurveSize0=0
 objects[59006].CurveSize1=0
 objects[59006].Enabled=true
 objects[59006].FaceCamera=true
 objects[59006].LightEmission=1
 objects[59006].LightInfluence=0
 objects[59006].Segments=10
 objects[59006].Texture="rbxassetid://4955566540"
 objects[59006].TextureLength=1
 objects[59006].TextureMode=enum(Enum.TextureMode,0)
 objects[59006].TextureSpeed=1
 objects[59006].Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0.200000003,0),NumberSequenceKeypoint.new(1,1,0)})
 objects[59006].Width0=1
 objects[59006].Width1=1
 objects[59006].ZOffset=0
 objects[59007]=Instance.new("Attachment")
 objects[59007].Name="EndSymbol"
 objects[59007].Visible=false
 objects[59007].CFrame=CFrame.new(0,0,0,1,0,0,0,1,0,0,0,1)
 objects[59008]=Instance.new("ParticleEmitter")
 objects[59008].Name="Transparent"
 objects[59008].Acceleration=Vector3.new(0,0,0)
 objects[59008].Brightness=1.97000003
 objects[59008].Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.new(1,1,1)),ColorSequenceKeypoint.new(1,Color3.new(1,1,1))})
 objects[59008].Drag=0
 objects[59008].EmissionDirection=enum(Enum.NormalId,1)
 objects[59008].Enabled=false
 objects[59008].FlipbookBlendFrames=true
 objects[59008].FlipbookLayout=enum(Enum.ParticleFlipbookLayout,0)
 objects[59008].FlipbookMode=enum(Enum.ParticleFlipbookMode,1)
 objects[59008].FlipbookStartRandom=false
 objects[59008].LightEmission=1
 objects[59008].LightInfluence=0
 objects[59008].LockedToPart=true
 objects[59008].Orientation=enum(Enum.ParticleOrientation,3)
 objects[59008].Rate=1.29999995
 objects[59008].Shape=enum(Enum.ParticleEmitterShape,0)
 objects[59008].ShapeInOut=enum(Enum.ParticleEmitterShapeInOut,0)
 objects[59008].ShapePartial=1
 objects[59008].ShapeStyle=enum(Enum.ParticleEmitterShapeStyle,0)
 objects[59008].Size=NumberSequence.new({NumberSequenceKeypoint.new(0,2,0),NumberSequenceKeypoint.new(0.0833333358,2,0),NumberSequenceKeypoint.new(0.166666672,2,0),NumberSequenceKeypoint.new(0.25,2,0),NumberSequenceKeypoint.new(0.333333343,2,0),NumberSequenceKeypoint.new(0.416666657,2,0),NumberSequenceKeypoint.new(0.5,2,0),NumberSequenceKeypoint.new(0.583333313,2,0),NumberSequenceKeypoint.new(0.666666687,2,0),NumberSequenceKeypoint.new(0.75,2,0),NumberSequenceKeypoint.new(0.833333313,2,0),NumberSequenceKeypoint.new(0.916666687,2,0),NumberSequenceKeypoint.new(1,2,0)})
 objects[59008].SpreadAngle=Vector2.new(0,0)
 objects[59008].Squash=NumberSequence.new({NumberSequenceKeypoint.new(0,0,0),NumberSequenceKeypoint.new(1,0,0)})
 objects[59008].Texture="rbxassetid://75363982258016"
 objects[59008].TimeScale=1
 objects[59008].Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,1,0),NumberSequenceKeypoint.new(0.5,0.899999976,0),NumberSequenceKeypoint.new(1,1,0)})
 objects[59008].VelocityInheritance=0
 objects[59008].WindAffectsDrag=false
 objects[59008].ZOffset=0
 objects[59008].FlipbookFramerate=NumberRange.new(1,1)
 objects[59008].Lifetime=NumberRange.new(1,1)
 objects[59008].RotSpeed=NumberRange.new(0,0)
 objects[59008].Rotation=NumberRange.new(0,0)
 objects[59008].Speed=NumberRange.new(0.00100000005,0.00100000005)
 objects[59008]:SetAttribute("EmitCount",0)
 objects[59008]:SetAttribute("EmitDelay",0)
 objects[59009]=Instance.new("ParticleEmitter")
 objects[59009].Name="Shader"
 objects[59009].Acceleration=Vector3.new(0,0,0)
 objects[59009].Brightness=3
 objects[59009].Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.new(0.917647064,0.945098042,1)),ColorSequenceKeypoint.new(1,Color3.new(0.776470602,0.827450991,1))})
 objects[59009].Drag=0
 objects[59009].EmissionDirection=enum(Enum.NormalId,1)
 objects[59009].Enabled=false
 objects[59009].FlipbookBlendFrames=true
 objects[59009].FlipbookLayout=enum(Enum.ParticleFlipbookLayout,3)
 objects[59009].FlipbookMode=enum(Enum.ParticleFlipbookMode,1)
 objects[59009].FlipbookStartRandom=false
 objects[59009].LightEmission=1
 objects[59009].LightInfluence=0
 objects[59009].LockedToPart=true
 objects[59009].Orientation=enum(Enum.ParticleOrientation,3)
 objects[59009].Rate=1.29999995
 objects[59009].Shape=enum(Enum.ParticleEmitterShape,0)
 objects[59009].ShapeInOut=enum(Enum.ParticleEmitterShapeInOut,0)
 objects[59009].ShapePartial=1
 objects[59009].ShapeStyle=enum(Enum.ParticleEmitterShapeStyle,0)
 objects[59009].Size=NumberSequence.new({NumberSequenceKeypoint.new(0,2,0),NumberSequenceKeypoint.new(0.0833333358,2,0),NumberSequenceKeypoint.new(0.166666672,2,0),NumberSequenceKeypoint.new(0.25,2,0),NumberSequenceKeypoint.new(0.333333343,2,0),NumberSequenceKeypoint.new(0.416666657,2,0),NumberSequenceKeypoint.new(0.5,2,0),NumberSequenceKeypoint.new(0.583333313,2,0),NumberSequenceKeypoint.new(0.666666687,2,0),NumberSequenceKeypoint.new(0.75,2,0),NumberSequenceKeypoint.new(0.833333313,2,0),NumberSequenceKeypoint.new(0.916666687,2,0),NumberSequenceKeypoint.new(1,2,0)})
 objects[59009].SpreadAngle=Vector2.new(0,0)
 objects[59009].Squash=NumberSequence.new({NumberSequenceKeypoint.new(0,0,0),NumberSequenceKeypoint.new(1,0,0)})
 objects[59009].Texture="rbxassetid://123334911850406"
 objects[59009].TimeScale=0.5
 objects[59009].Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,1,0),NumberSequenceKeypoint.new(0.498414367,0.03125,0),NumberSequenceKeypoint.new(1,1,0)})
 objects[59009].VelocityInheritance=0
 objects[59009].WindAffectsDrag=false
 objects[59009].ZOffset=0
 objects[59009].FlipbookFramerate=NumberRange.new(13.8000002,13.8000002)
 objects[59009].Lifetime=NumberRange.new(1,1)
 objects[59009].RotSpeed=NumberRange.new(0,0)
 objects[59009].Rotation=NumberRange.new(0,0)
 objects[59009].Speed=NumberRange.new(0.00100000005,0.00100000005)
 objects[59009]:SetAttribute("EmitCount",0)
 objects[59009]:SetAttribute("EmitDelay",0)
 objects[59036]=Instance.new("Folder")
 objects[59036].Name="Pray"
 objects[59037]=Instance.new("Attachment")
 objects[59037].Name="BeamFlare"
 objects[59037].Visible=false
 objects[59037].CFrame=CFrame.new(0,7.12184334,1.5965271,1,0,0,0,0.984296679,-0.176521987,0,0.176521987,0.984296679)
 objects[59038]=Instance.new("ParticleEmitter")
 objects[59038].Name="SparkleAngle"
 objects[59038].Acceleration=Vector3.new(0,0,0)
 objects[59038].Brightness=1
 objects[59038].Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.new(1,1,1)),ColorSequenceKeypoint.new(1,Color3.new(1,1,1))})
 objects[59038].Drag=0
 objects[59038].EmissionDirection=enum(Enum.NormalId,1)
 objects[59038].Enabled=true
 objects[59038].FlipbookBlendFrames=true
 objects[59038].FlipbookLayout=enum(Enum.ParticleFlipbookLayout,0)
 objects[59038].FlipbookMode=enum(Enum.ParticleFlipbookMode,0)
 objects[59038].FlipbookStartRandom=false
 objects[59038].LightEmission=0
 objects[59038].LightInfluence=1
 objects[59038].LockedToPart=true
 objects[59038].Orientation=enum(Enum.ParticleOrientation,0)
 objects[59038].Rate=5
 objects[59038].Shape=enum(Enum.ParticleEmitterShape,0)
 objects[59038].ShapeInOut=enum(Enum.ParticleEmitterShapeInOut,0)
 objects[59038].ShapePartial=1
 objects[59038].ShapeStyle=enum(Enum.ParticleEmitterShapeStyle,0)
 objects[59038].Size=NumberSequence.new({NumberSequenceKeypoint.new(0,1,0),NumberSequenceKeypoint.new(1,3.49999952,0)})
 objects[59038].SpreadAngle=Vector2.new(0,0)
 objects[59038].Squash=NumberSequence.new({NumberSequenceKeypoint.new(0,0,0),NumberSequenceKeypoint.new(1,-3,0)})
 objects[59038].Texture="rbxassetid://113600244234335"
 objects[59038].TimeScale=1
 objects[59038].Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,1,0),NumberSequenceKeypoint.new(0.490024954,0,0),NumberSequenceKeypoint.new(1,1,0)})
 objects[59038].VelocityInheritance=0
 objects[59038].WindAffectsDrag=false
 objects[59038].ZOffset=0
 objects[59038].FlipbookFramerate=NumberRange.new(1,1)
 objects[59038].Lifetime=NumberRange.new(0.5,0.5)
 objects[59038].RotSpeed=NumberRange.new(0,0)
 objects[59038].Rotation=NumberRange.new(-55,-55)
 objects[59038].Speed=NumberRange.new(0,0)
 objects[59038]:SetAttribute("EmitDelay",0)
 objects[59039]=Instance.new("ParticleEmitter")
 objects[59039].Name="Sparkle"
 objects[59039].Acceleration=Vector3.new(0,0,0)
 objects[59039].Brightness=1
 objects[59039].Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.new(1,1,1)),ColorSequenceKeypoint.new(1,Color3.new(1,1,1))})
 objects[59039].Drag=0
 objects[59039].EmissionDirection=enum(Enum.NormalId,1)
 objects[59039].Enabled=true
 objects[59039].FlipbookBlendFrames=true
 objects[59039].FlipbookLayout=enum(Enum.ParticleFlipbookLayout,0)
 objects[59039].FlipbookMode=enum(Enum.ParticleFlipbookMode,0)
 objects[59039].FlipbookStartRandom=false
 objects[59039].LightEmission=0
 objects[59039].LightInfluence=1
 objects[59039].LockedToPart=true
 objects[59039].Orientation=enum(Enum.ParticleOrientation,0)
 objects[59039].Rate=5
 objects[59039].Shape=enum(Enum.ParticleEmitterShape,0)
 objects[59039].ShapeInOut=enum(Enum.ParticleEmitterShapeInOut,0)
 objects[59039].ShapePartial=1
 objects[59039].ShapeStyle=enum(Enum.ParticleEmitterShapeStyle,0)
 objects[59039].Size=NumberSequence.new({NumberSequenceKeypoint.new(0,1,0),NumberSequenceKeypoint.new(1,3.49999952,0)})
 objects[59039].SpreadAngle=Vector2.new(0,0)
 objects[59039].Squash=NumberSequence.new({NumberSequenceKeypoint.new(0,0,0),NumberSequenceKeypoint.new(1,-3,0)})
 objects[59039].Texture="rbxassetid://113600244234335"
 objects[59039].TimeScale=1
 objects[59039].Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,1,0),NumberSequenceKeypoint.new(0.490024954,0,0),NumberSequenceKeypoint.new(1,1,0)})
 objects[59039].VelocityInheritance=0
 objects[59039].WindAffectsDrag=false
 objects[59039].ZOffset=0
 objects[59039].FlipbookFramerate=NumberRange.new(1,1)
 objects[59039].Lifetime=NumberRange.new(0.5,0.5)
 objects[59039].RotSpeed=NumberRange.new(0,0)
 objects[59039].Rotation=NumberRange.new(0,0)
 objects[59039].Speed=NumberRange.new(0,0)
 objects[59039]:SetAttribute("EmitDelay",0)
 objects[59040]=Instance.new("ParticleEmitter")
 objects[59040].Name="Dust"
 objects[59040].Acceleration=Vector3.new(0,0,0)
 objects[59040].Brightness=10
 objects[59040].Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.new(1,1,1)),ColorSequenceKeypoint.new(1,Color3.new(1,1,1))})
 objects[59040].Drag=0.25
 objects[59040].EmissionDirection=enum(Enum.NormalId,4)
 objects[59040].Enabled=true
 objects[59040].FlipbookBlendFrames=false
 objects[59040].FlipbookLayout=enum(Enum.ParticleFlipbookLayout,1)
 objects[59040].FlipbookMode=enum(Enum.ParticleFlipbookMode,0)
 objects[59040].FlipbookStartRandom=true
 objects[59040].LightEmission=1
 objects[59040].LightInfluence=0
 objects[59040].LockedToPart=false
 objects[59040].Orientation=enum(Enum.ParticleOrientation,0)
 objects[59040].Rate=4
 objects[59040].Shape=enum(Enum.ParticleEmitterShape,0)
 objects[59040].ShapeInOut=enum(Enum.ParticleEmitterShapeInOut,0)
 objects[59040].ShapePartial=1
 objects[59040].ShapeStyle=enum(Enum.ParticleEmitterShapeStyle,0)
 objects[59040].Size=NumberSequence.new({NumberSequenceKeypoint.new(0,0,0),NumberSequenceKeypoint.new(0.5,0.0500000007,0.0500000007),NumberSequenceKeypoint.new(1,0,0)})
 objects[59040].SpreadAngle=Vector2.new(30,30)
 objects[59040].Squash=NumberSequence.new({NumberSequenceKeypoint.new(0,0,0),NumberSequenceKeypoint.new(1,0,0)})
 objects[59040].Texture="rbxassetid://96361210760220"
 objects[59040].TimeScale=1
 objects[59040].Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0,0),NumberSequenceKeypoint.new(1,0,0)})
 objects[59040].VelocityInheritance=0
 objects[59040].WindAffectsDrag=false
 objects[59040].ZOffset=0
 objects[59040].FlipbookFramerate=NumberRange.new(0,0)
 objects[59040].Lifetime=NumberRange.new(2,4)
 objects[59040].RotSpeed=NumberRange.new(0,0)
 objects[59040].Rotation=NumberRange.new(0,0)
 objects[59040].Speed=NumberRange.new(4,5)
 objects[59041]=Instance.new("Attachment")
 objects[59041].Name="StartCenter"
 objects[59041].Visible=false
 objects[59041].CFrame=CFrame.new(0,0.0587131977,-0.166778564,1,0,0,0,0.970643938,-0.240521073,0,0.240521073,0.970643938)
 objects[59042]=Instance.new("ParticleEmitter")
 objects[59042].Name="Glow"
 objects[59042].Acceleration=Vector3.new(0,0,0)
 objects[59042].Brightness=1
 objects[59042].Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.new(1,1,1)),ColorSequenceKeypoint.new(1,Color3.new(1,1,1))})
 objects[59042].Drag=0
 objects[59042].EmissionDirection=enum(Enum.NormalId,1)
 objects[59042].Enabled=false
 objects[59042].FlipbookBlendFrames=true
 objects[59042].FlipbookLayout=enum(Enum.ParticleFlipbookLayout,0)
 objects[59042].FlipbookMode=enum(Enum.ParticleFlipbookMode,0)
 objects[59042].FlipbookStartRandom=false
 objects[59042].LightEmission=0
 objects[59042].LightInfluence=1
 objects[59042].LockedToPart=false
 objects[59042].Orientation=enum(Enum.ParticleOrientation,2)
 objects[59042].Rate=20
 objects[59042].Shape=enum(Enum.ParticleEmitterShape,0)
 objects[59042].ShapeInOut=enum(Enum.ParticleEmitterShapeInOut,0)
 objects[59042].ShapePartial=1
 objects[59042].ShapeStyle=enum(Enum.ParticleEmitterShapeStyle,0)
 objects[59042].Size=NumberSequence.new({NumberSequenceKeypoint.new(0,8,0),NumberSequenceKeypoint.new(1,8,0)})
 objects[59042].SpreadAngle=Vector2.new(0,0)
 objects[59042].Squash=NumberSequence.new({NumberSequenceKeypoint.new(0,-0.5,0),NumberSequenceKeypoint.new(1,-0.5,0)})
 objects[59042].Texture="rbxassetid://11739864623"
 objects[59042].TimeScale=1
 objects[59042].Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,1,0),NumberSequenceKeypoint.new(0.0997506231,0.193749964,0),NumberSequenceKeypoint.new(1,1,0)})
 objects[59042].VelocityInheritance=0
 objects[59042].WindAffectsDrag=false
 objects[59042].ZOffset=1
 objects[59042].FlipbookFramerate=NumberRange.new(1,1)
 objects[59042].Lifetime=NumberRange.new(1,1)
 objects[59042].RotSpeed=NumberRange.new(0,0)
 objects[59042].Rotation=NumberRange.new(0,0)
 objects[59042].Speed=NumberRange.new(0.00499999989,0.00499999989)
 objects[59042]:SetAttribute("EmitCount",1)
 objects[59043]=Instance.new("Attachment")
 objects[59043].Name="StartFloor"
 objects[59043].Visible=false
 objects[59043].CFrame=CFrame.new(0,-3,0,1,0,0,0,1,0,0,0,1)
 objects[59044]=Instance.new("ParticleEmitter")
 objects[59044].Name="Dust"
 objects[59044].Acceleration=Vector3.new(0,20,0)
 objects[59044].Brightness=10
 objects[59044].Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.new(1,1,1)),ColorSequenceKeypoint.new(1,Color3.new(1,1,1))})
 objects[59044].Drag=4
 objects[59044].EmissionDirection=enum(Enum.NormalId,1)
 objects[59044].Enabled=false
 objects[59044].FlipbookBlendFrames=false
 objects[59044].FlipbookLayout=enum(Enum.ParticleFlipbookLayout,1)
 objects[59044].FlipbookMode=enum(Enum.ParticleFlipbookMode,0)
 objects[59044].FlipbookStartRandom=true
 objects[59044].LightEmission=1
 objects[59044].LightInfluence=0
 objects[59044].LockedToPart=false
 objects[59044].Orientation=enum(Enum.ParticleOrientation,2)
 objects[59044].Rate=4
 objects[59044].Shape=enum(Enum.ParticleEmitterShape,0)
 objects[59044].ShapeInOut=enum(Enum.ParticleEmitterShapeInOut,0)
 objects[59044].ShapePartial=1
 objects[59044].ShapeStyle=enum(Enum.ParticleEmitterShapeStyle,0)
 objects[59044].Size=NumberSequence.new({NumberSequenceKeypoint.new(0,0,0),NumberSequenceKeypoint.new(0.5,0.0500000007,0.0500000007),NumberSequenceKeypoint.new(1,0,0)})
 objects[59044].SpreadAngle=Vector2.new(70,70)
 objects[59044].Squash=NumberSequence.new({NumberSequenceKeypoint.new(0,1,0),NumberSequenceKeypoint.new(1,1,0)})
 objects[59044].Texture="rbxassetid://96361210760220"
 objects[59044].TimeScale=1
 objects[59044].Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0,0),NumberSequenceKeypoint.new(1,0,0)})
 objects[59044].VelocityInheritance=0
 objects[59044].WindAffectsDrag=false
 objects[59044].ZOffset=0
 objects[59044].FlipbookFramerate=NumberRange.new(0,0)
 objects[59044].Lifetime=NumberRange.new(0.25,1)
 objects[59044].RotSpeed=NumberRange.new(0,0)
 objects[59044].Rotation=NumberRange.new(-90,-90)
 objects[59044].Speed=NumberRange.new(9,40)
 objects[59044]:SetAttribute("EmitCount",15)
 objects[59045]=Instance.new("ParticleEmitter")
 objects[59045].Name="Spawn"
 objects[59045].Acceleration=Vector3.new(0,0,0)
 objects[59045].Brightness=5
 objects[59045].Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.new(1,1,1)),ColorSequenceKeypoint.new(1,Color3.new(1,1,1))})
 objects[59045].Drag=0
 objects[59045].EmissionDirection=enum(Enum.NormalId,1)
 objects[59045].Enabled=false
 objects[59045].FlipbookBlendFrames=true
 objects[59045].FlipbookLayout=enum(Enum.ParticleFlipbookLayout,0)
 objects[59045].FlipbookMode=enum(Enum.ParticleFlipbookMode,0)
 objects[59045].FlipbookStartRandom=false
 objects[59045].LightEmission=1
 objects[59045].LightInfluence=0
 objects[59045].LockedToPart=false
 objects[59045].Orientation=enum(Enum.ParticleOrientation,3)
 objects[59045].Rate=2
 objects[59045].Shape=enum(Enum.ParticleEmitterShape,0)
 objects[59045].ShapeInOut=enum(Enum.ParticleEmitterShapeInOut,0)
 objects[59045].ShapePartial=1
 objects[59045].ShapeStyle=enum(Enum.ParticleEmitterShapeStyle,0)
 objects[59045].Size=NumberSequence.new({NumberSequenceKeypoint.new(0,10,0),NumberSequenceKeypoint.new(0.0523690805,2.0625,0),NumberSequenceKeypoint.new(0.273067355,6.25,0),NumberSequenceKeypoint.new(1,5,0)})
 objects[59045].SpreadAngle=Vector2.new(0,0)
 objects[59045].Squash=NumberSequence.new({NumberSequenceKeypoint.new(0,0,0),NumberSequenceKeypoint.new(1,0,0)})
 objects[59045].Texture="rbxassetid://134399639839028"
 objects[59045].TimeScale=1
 objects[59045].Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,1,0),NumberSequenceKeypoint.new(0.0236907732,0,0),NumberSequenceKeypoint.new(1,1,0)})
 objects[59045].VelocityInheritance=0
 objects[59045].WindAffectsDrag=false
 objects[59045].ZOffset=0
 objects[59045].FlipbookFramerate=NumberRange.new(1,1)
 objects[59045].Lifetime=NumberRange.new(1,1)
 objects[59045].RotSpeed=NumberRange.new(-90,-90)
 objects[59045].Rotation=NumberRange.new(0,0)
 objects[59045].Speed=NumberRange.new(0.0500000007,0.0500000007)
 objects[59045]:SetAttribute("EmitCount",1)
 objects[59046]=Instance.new("Attachment")
 objects[59046].Name="Center"
 objects[59046].Visible=false
 objects[59046].CFrame=CFrame.new(0,-1.00000012,0,1,0,0,0,1,0,0,0,1)
 objects[59047]=Instance.new("ParticleEmitter")
 objects[59047].Name="Aura"
 objects[59047].Acceleration=Vector3.new(0,0,0)
 objects[59047].Brightness=1
 objects[59047].Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.new(1,1,1)),ColorSequenceKeypoint.new(1,Color3.new(1,1,1))})
 objects[59047].Drag=1
 objects[59047].EmissionDirection=enum(Enum.NormalId,1)
 objects[59047].Enabled=true
 objects[59047].FlipbookBlendFrames=true
 objects[59047].FlipbookLayout=enum(Enum.ParticleFlipbookLayout,2)
 objects[59047].FlipbookMode=enum(Enum.ParticleFlipbookMode,1)
 objects[59047].FlipbookStartRandom=false
 objects[59047].LightEmission=0
 objects[59047].LightInfluence=1
 objects[59047].LockedToPart=false
 objects[59047].Orientation=enum(Enum.ParticleOrientation,2)
 objects[59047].Rate=20
 objects[59047].Shape=enum(Enum.ParticleEmitterShape,0)
 objects[59047].ShapeInOut=enum(Enum.ParticleEmitterShapeInOut,0)
 objects[59047].ShapePartial=1
 objects[59047].ShapeStyle=enum(Enum.ParticleEmitterShapeStyle,0)
 objects[59047].Size=NumberSequence.new({NumberSequenceKeypoint.new(0,0,0),NumberSequenceKeypoint.new(1,4.5625,0)})
 objects[59047].SpreadAngle=Vector2.new(360,360)
 objects[59047].Squash=NumberSequence.new({NumberSequenceKeypoint.new(0,0.5,0),NumberSequenceKeypoint.new(1,0.5,0)})
 objects[59047].Texture="rbxassetid://134494112357790"
 objects[59047].TimeScale=1
 objects[59047].Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0.9375,0),NumberSequenceKeypoint.new(1,1,0)})
 objects[59047].VelocityInheritance=0
 objects[59047].WindAffectsDrag=false
 objects[59047].ZOffset=0
 objects[59047].FlipbookFramerate=NumberRange.new(17.7000008,17.7000008)
 objects[59047].Lifetime=NumberRange.new(2,2)
 objects[59047].RotSpeed=NumberRange.new(0,0)
 objects[59047].Rotation=NumberRange.new(-90,-90)
 objects[59047].Speed=NumberRange.new(2,2)
 objects[59048]=Instance.new("Attachment")
 objects[59048].Name="Floor"
 objects[59048].Visible=false
 objects[59048].CFrame=CFrame.new(0,-3,0,1,0,0,0,1,0,0,0,1)
 objects[59049]=Instance.new("ParticleEmitter")
 objects[59049].Name="Spawn"
 objects[59049].Acceleration=Vector3.new(0,0,0)
 objects[59049].Brightness=1
 objects[59049].Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.new(1,1,1)),ColorSequenceKeypoint.new(1,Color3.new(1,1,1))})
 objects[59049].Drag=0
 objects[59049].EmissionDirection=enum(Enum.NormalId,1)
 objects[59049].Enabled=true
 objects[59049].FlipbookBlendFrames=true
 objects[59049].FlipbookLayout=enum(Enum.ParticleFlipbookLayout,0)
 objects[59049].FlipbookMode=enum(Enum.ParticleFlipbookMode,0)
 objects[59049].FlipbookStartRandom=false
 objects[59049].LightEmission=0
 objects[59049].LightInfluence=0
 objects[59049].LockedToPart=false
 objects[59049].Orientation=enum(Enum.ParticleOrientation,3)
 objects[59049].Rate=2
 objects[59049].Shape=enum(Enum.ParticleEmitterShape,0)
 objects[59049].ShapeInOut=enum(Enum.ParticleEmitterShapeInOut,0)
 objects[59049].ShapePartial=1
 objects[59049].ShapeStyle=enum(Enum.ParticleEmitterShapeStyle,0)
 objects[59049].Size=NumberSequence.new({NumberSequenceKeypoint.new(0,5,0),NumberSequenceKeypoint.new(1,5,0)})
 objects[59049].SpreadAngle=Vector2.new(0,0)
 objects[59049].Squash=NumberSequence.new({NumberSequenceKeypoint.new(0,0,0),NumberSequenceKeypoint.new(1,0,0)})
 objects[59049].Texture="rbxassetid://134399639839028"
 objects[59049].TimeScale=1
 objects[59049].Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,1,0),NumberSequenceKeypoint.new(0.497506261,0,0),NumberSequenceKeypoint.new(1,1,0)})
 objects[59049].VelocityInheritance=0
 objects[59049].WindAffectsDrag=false
 objects[59049].ZOffset=0
 objects[59049].FlipbookFramerate=NumberRange.new(1,1)
 objects[59049].Lifetime=NumberRange.new(1,1)
 objects[59049].RotSpeed=NumberRange.new(-90,-90)
 objects[59049].Rotation=NumberRange.new(0,0)
 objects[59049].Speed=NumberRange.new(0.0500000007,0.0500000007)
 objects[59050]=Instance.new("Attachment")
 objects[59050].Name="BeamTop"
 objects[59050].Visible=false
 objects[59050].CFrame=CFrame.new(0,9.09042358,1.949646,1,0,0,0,0.984296679,-0.176521987,0,0.176521987,0.984296679)
 objects[59051]=Instance.new("SpotLight")
 objects[59051].Name="SpotLight"
 objects[59051].Angle=54
 objects[59051].Face=enum(Enum.NormalId,4)
 objects[59051].Range=16
 objects[59051].Brightness=1
 objects[59051].Color=Color3.new(1,1,1)
 objects[59051].Enabled=true
 objects[59051].Shadows=false
 objects[59052]=Instance.new("Attachment")
 objects[59052].Name="StartFlare"
 objects[59052].Visible=false
 objects[59052].CFrame=CFrame.new(0,7.12184334,1.5965271,1,0,0,0,0.984296679,-0.176521987,0,0.176521987,0.984296679)
 objects[59053]=Instance.new("ParticleEmitter")
 objects[59053].Name="Spark"
 objects[59053].Acceleration=Vector3.new(0,0,0)
 objects[59053].Brightness=1
 objects[59053].Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.new(1,1,1)),ColorSequenceKeypoint.new(1,Color3.new(1,1,1))})
 objects[59053].Drag=0
 objects[59053].EmissionDirection=enum(Enum.NormalId,1)
 objects[59053].Enabled=false
 objects[59053].FlipbookBlendFrames=true
 objects[59053].FlipbookLayout=enum(Enum.ParticleFlipbookLayout,2)
 objects[59053].FlipbookMode=enum(Enum.ParticleFlipbookMode,1)
 objects[59053].FlipbookStartRandom=false
 objects[59053].LightEmission=0
 objects[59053].LightInfluence=1
 objects[59053].LockedToPart=false
 objects[59053].Orientation=enum(Enum.ParticleOrientation,0)
 objects[59053].Rate=1
 objects[59053].Shape=enum(Enum.ParticleEmitterShape,0)
 objects[59053].ShapeInOut=enum(Enum.ParticleEmitterShapeInOut,0)
 objects[59053].ShapePartial=1
 objects[59053].ShapeStyle=enum(Enum.ParticleEmitterShapeStyle,0)
 objects[59053].Size=NumberSequence.new({NumberSequenceKeypoint.new(0,1,0),NumberSequenceKeypoint.new(1,5.3125,0)})
 objects[59053].SpreadAngle=Vector2.new(0,0)
 objects[59053].Squash=NumberSequence.new({NumberSequenceKeypoint.new(0,0,0),NumberSequenceKeypoint.new(1,0,0)})
 objects[59053].Texture="rbxassetid://76672742852348"
 objects[59053].TimeScale=1
 objects[59053].Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0,0),NumberSequenceKeypoint.new(1,0,0)})
 objects[59053].VelocityInheritance=0
 objects[59053].WindAffectsDrag=false
 objects[59053].ZOffset=0
 objects[59053].FlipbookFramerate=NumberRange.new(1,1)
 objects[59053].Lifetime=NumberRange.new(0.5,0.5)
 objects[59053].RotSpeed=NumberRange.new(0,0)
 objects[59053].Rotation=NumberRange.new(0,0)
 objects[59053].Speed=NumberRange.new(0,0)
 objects[59053]:SetAttribute("EmitCount",1)
 objects[59054]=Instance.new("ParticleEmitter")
 objects[59054].Name="Flash"
 objects[59054].Acceleration=Vector3.new(0,0,0)
 objects[59054].Brightness=1
 objects[59054].Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.new(1,1,1)),ColorSequenceKeypoint.new(1,Color3.new(1,1,1))})
 objects[59054].Drag=0
 objects[59054].EmissionDirection=enum(Enum.NormalId,1)
 objects[59054].Enabled=false
 objects[59054].FlipbookBlendFrames=true
 objects[59054].FlipbookLayout=enum(Enum.ParticleFlipbookLayout,0)
 objects[59054].FlipbookMode=enum(Enum.ParticleFlipbookMode,0)
 objects[59054].FlipbookStartRandom=false
 objects[59054].LightEmission=0
 objects[59054].LightInfluence=1
 objects[59054].LockedToPart=false
 objects[59054].Orientation=enum(Enum.ParticleOrientation,0)
 objects[59054].Rate=20
 objects[59054].Shape=enum(Enum.ParticleEmitterShape,0)
 objects[59054].ShapeInOut=enum(Enum.ParticleEmitterShapeInOut,0)
 objects[59054].ShapePartial=1
 objects[59054].ShapeStyle=enum(Enum.ParticleEmitterShapeStyle,0)
 objects[59054].Size=NumberSequence.new({NumberSequenceKeypoint.new(0,4,0),NumberSequenceKeypoint.new(1,0,0)})
 objects[59054].SpreadAngle=Vector2.new(0,0)
 objects[59054].Squash=NumberSequence.new({NumberSequenceKeypoint.new(0,0,0),NumberSequenceKeypoint.new(1,0,0)})
 objects[59054].Texture="rbxassetid://12805835620"
 objects[59054].TimeScale=1
 objects[59054].Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0,0),NumberSequenceKeypoint.new(1,0,0)})
 objects[59054].VelocityInheritance=0
 objects[59054].WindAffectsDrag=false
 objects[59054].ZOffset=0
 objects[59054].FlipbookFramerate=NumberRange.new(1,1)
 objects[59054].Lifetime=NumberRange.new(0.0500000007,0.0500000007)
 objects[59054].RotSpeed=NumberRange.new(0,0)
 objects[59054].Rotation=NumberRange.new(-360,360)
 objects[59054].Speed=NumberRange.new(0,0)
 objects[59054]:SetAttribute("EmitCount",1)
 objects[59055]=Instance.new("Attachment")
 objects[59055].Name="BeamBottom"
 objects[59055].Visible=false
 objects[59055].CFrame=CFrame.new(0,-4.0482502,-0.731002808,1,0,0,0,1,0,0,0,1)
 objects[59056]=Instance.new("Beam")
 objects[59056].Name="Beam"
 objects[59056].Brightness=0.875
 objects[59056].Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.new(1,1,1)),ColorSequenceKeypoint.new(1,Color3.new(1,1,1))})
 objects[59056].CurveSize0=0
 objects[59056].CurveSize1=0
 objects[59056].Enabled=true
 objects[59056].FaceCamera=true
 objects[59056].LightEmission=1
 objects[59056].LightInfluence=0
 objects[59056].Segments=10
 objects[59056].Texture="rbxassetid://89750267961919"
 objects[59056].TextureLength=140
 objects[59056].TextureMode=enum(Enum.TextureMode,1)
 objects[59056].TextureSpeed=0.100000001
 objects[59056].Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,1,0),NumberSequenceKeypoint.new(0.507481337,0.899999976,0),NumberSequenceKeypoint.new(0.652119696,0.731249988,0),NumberSequenceKeypoint.new(0.770573616,0.46875,0),NumberSequenceKeypoint.new(0.913965106,1,0),NumberSequenceKeypoint.new(1,1,0)})
 objects[59056].Width0=0
 objects[59056].Width1=15
 objects[59056].ZOffset=0
 objects[59006].Parent=objects[59005]
 objects[59007].Parent=objects[59005]
 objects[59008].Parent=objects[59007]
 objects[59009].Parent=objects[59007]
 objects[59037].Parent=objects[59036]
 objects[59038].Parent=objects[59037]
 objects[59039].Parent=objects[59037]
 objects[59040].Parent=objects[59037]
 objects[59041].Parent=objects[59036]
 objects[59042].Parent=objects[59041]
 objects[59043].Parent=objects[59036]
 objects[59044].Parent=objects[59043]
 objects[59045].Parent=objects[59043]
 objects[59046].Parent=objects[59036]
 objects[59047].Parent=objects[59046]
 objects[59048].Parent=objects[59036]
 objects[59049].Parent=objects[59048]
 objects[59050].Parent=objects[59036]
 objects[59051].Parent=objects[59050]
 objects[59052].Parent=objects[59036]
 objects[59053].Parent=objects[59052]
 objects[59054].Parent=objects[59052]
 objects[59055].Parent=objects[59036]
 objects[59056].Parent=objects[59036]
 objects[59056].Attachment0=objects[59050]
 objects[59056].Attachment1=objects[59055]
 local selected=kind=="Pray" and objects[59036] or objects[59005]
 local unused=kind=="Pray" and objects[59005] or objects[59036]
 unused:Destroy()
 return selected
end
return Visuals

end)()
local Debris={AddItem=function(_,object,delay)object.debrisDelay=delay end}
local TweenInfo={new=vec}
local TweenService={Create=function(_,object,info,props)return {Play=function()for k,v in props do object[k]=v end end}end}
local function stopPrayVFX(a)
 local visuals=a.TTPrayVFX;a.TTPrayVFX=nil
 for _,object in visuals or {} do
  for _,item in object:GetDescendants() do
   if item:IsA("ParticleEmitter") then item.Enabled=false
   elseif item:IsA("Light") then TweenService:Create(item,TweenInfo.new(.2),{Brightness=0}):Play() end
  end
  if object:IsA("Beam") then TweenService:Create(object,TweenInfo.new(.2),{Width1=0}):Play() end
  Debris:AddItem(object,4)
 end
end
local function startPrayVFX(a)
 stopPrayVFX(a)
 local folder=Visuals.Build("Pray")
 a.TTPrayVFX=folder:GetChildren()
 for _,object in a.TTPrayVFX do object.Parent=a.Rig.PrimaryPart end
 folder:Destroy()
 for _,object in a.TTPrayVFX do
  for _,item in object:GetDescendants() do
   if item:IsA("ParticleEmitter") and item:GetAttribute("EmitCount") then item:Emit(item:GetAttribute("EmitCount")) end
  end
 end
end

local indicator=Visuals.Build('LungeIndicator')
local beam=find(indicator,'Beam');assert(beam.Width0==1 and beam.Width1==1 and beam.Texture=='rbxassetid://4955566540')
assert(find(indicator,'Transparent').Size[1].Value==2)
assert(find(indicator,'Shader').Texture=='rbxassetid://123334911850406')
local pray=Visuals.Build('Pray');beam=find(pray,'Beam')
assert(beam.Attachment0.Name=='BeamTop' and beam.Attachment1.Name=='BeamBottom')
assert(beam.Attachment0.Parent==pray and beam.Attachment1.Parent==pray)
assert(find(pray,'Glow'):GetAttribute('EmitCount')==1)
for _,item in pray:GetDescendants()do assert(not item:IsA('Sound') and not item:IsA('Animation'))end
local actor={Rig={PrimaryPart=Instance.new('Part')}}
startPrayVFX(actor);assert(#actor.TTPrayVFX>0)
local startedGlow=find(actor.Rig.PrimaryPart,'Glow');assert(startedGlow.emitted==1)
local aura=find(actor.Rig.PrimaryPart,'Aura');assert(aura.Enabled)
local retained=actor.TTPrayVFX
stopPrayVFX(actor);assert(actor.TTPrayVFX==nil and not aura.Enabled)
for _,object in retained do assert(object.debrisDelay==4)end
print('Actual UPD visual factory, attachment references, startup emission and Pray cleanup passed')
