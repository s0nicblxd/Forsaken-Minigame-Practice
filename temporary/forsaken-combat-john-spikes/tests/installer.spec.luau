
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

local originals={
[ [==========[
ReplicatedStorage/Assets/Killers/JohnDoe/Config]==========] ]=[==========[
-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local l_workspace_Attribute_0 = workspace:GetAttribute("JohnDoeSpecialDay");
local v1 = {
    DisplayName = "John Doe", 
    Quote = l_workspace_Attribute_0 and "dude i told you not to play on march 18th" or "DON'T PLAY ROBLOX ON MARCH 18TH?!?!", 
	RenderImage = l_workspace_Attribute_0 and "rbxassetid://125927083463034" or "rbxassetid://115998690833101", 
    Price = l_workspace_Attribute_0 and 318 or 1000, 
    Health = l_workspace_Attribute_0 and 3182026 or 1500, 
    Speed = l_workspace_Attribute_0 and 11.3182026 or 9, 
    IntroText = "They're all yours, Mr. Doe", 
    SprintSpeed = l_workspace_Attribute_0 and 27.53182026 or 27.25, 
    StaminaLoss = 9.5, 
    StaminaGain = 21, 
    MaxStamina = l_workspace_Attribute_0 and 115.3182026 or 110, 
    SlashDamage = l_workspace_Attribute_0 and 45.3182026 or 28, 
    SlashCooldown = l_workspace_Attribute_0 and 2.3182026 or 1.75, 
    SlashWindup = 0.4, 
    SlashLinger = 0.25, 
    CorruptEnergyDamage = l_workspace_Attribute_0 and 16.3182026 or 12, 
    CorruptEnergyCooldown = l_workspace_Attribute_0 and 40.3182026 or 18, 
    SpikeAmount = l_workspace_Attribute_0 and 256 or 27, 
    SpikeHitboxSize = Vector3.new(11, 5, 5, 0), 
    SpikeLifetime = l_workspace_Attribute_0 and 18.3182026 or 14, 
    SpikeHitCap = l_workspace_Attribute_0 and 3182026 or 4, 
    SpikeProperties = PhysicalProperties.new(0.2, 2, 0, 100, 100), 
    DelayBetweenSpikeSummons = l_workspace_Attribute_0 and 0.02 or 0.054, 
    DistanceBetweenSpikes = 4, 
    DigitalFootprintCooldown = 3, 
    DigitalFootprintLimit = l_workspace_Attribute_0 and 4 or 3, 
    ["404ErrorAuraRevealTime"] = l_workspace_Attribute_0 and 10.3182026 or 6, 
    ["404ErrorCooldown"] = 20, 
    Spike = script.Spike, 
    Shadow = script.Shadow, 
    Trail = script.Trail, 
    SpikeNumbersColor = Color3.fromRGB(255, 0, 0), 
    TrailLength = l_workspace_Attribute_0 and 356 or 48, 
    UnstoppableDuration = 2, 
    SilencedTemplate = script.NAN, 
    Silenced = true, 
    OutroDummy = script.OutroVictim, 
    useClouds = true, 
    Relations = {
        "JaneDoe"
    }, 
    LastManStandingEmotionalData = {
        ThemeID = "rbxassetid://90004798416076", 
        RoundTime = 99
    }, 
    LastManStandingData = {
        ThemeID = "rbxassetid://128206924329556", 
        ThemeProperties = {
            Volume = 1.8
        }, 
        RoundTime = 75
    }, 
    Animations = {
        Idle = "rbxassetid://78316360457839", 
        Walk = "rbxassetid://76406790148345", 
        Run = "rbxassetid://75860288793447", 
        InjuredIdle = "rbxassetid://78316360457839", 
        InjuredWalk = "rbxassetid://76406790148345", 
        InjuredRun = "rbxassetid://75860288793447", 
        Stunned = {
            Start = "rbxassetid://138679230786776", 
            Loop = "rbxassetid://70827891324537", 
            End = "rbxassetid://74361242843808", 
            Cancel = "rbxassetid://132248641730444"
        }, 
        Execution = {
            KillerRig = "rbxassetid://83976183793168", 
            PlayerRig = "rbxassetid://128883910284038", 
            PlayerCFrameOffset = CFrame.Angles(0, 3.141592653589793, 0) * CFrame.new(0, 0, 3)
        }, 
        ExecutionJaneDoe = {
            KillerRig = "rbxassetid://113867319138589", 
            PlayerRig = "rbxassetid://110119432571584"
        }, 
        Slash = "rbxassetid://115517017692371", 
        CorruptEnergy = "rbxassetid://98447162219573", 
        DigitalFootprint = "rbxassetid://105781326773024", 
        Introduction = {
            KillerRig = "rbxassetid://119476049603730", 
            CameraRig = "rbxassetid://140634358360682"
        }, 
        Victory = {
            KillerRig = "rbxassetid://103715079223416", 
            CameraRig = "rbxassetid://98794271647444"
        }
    }, 
    Sounds = {
        Ambience = "rbxassetid://94207556272752", 
        Footsteps = {
            "rbxassetid://126872882914955", 
            "rbxassetid://81544212102472"
        }, 
        TerrorRadiusThemes = {
            [60] = {
                ID = "rbxassetid://83774227185202", 
                BPM = 100
            }, 
            [40] = {
                ID = "rbxassetid://112183456126257", 
                BPM = 100
            }, 
            [20] = {
                ID = "rbxassetid://110494241693405", 
                BPM = 100
            }, 
            [6] = {
                ID = "rbxassetid://90755511989120", 
                BPM = 100, 
                Chase = true
            }
        }, 
        Execution = "rbxassetid://91088178573563", 
        ExecutionJaneDoe = "rbxassetid://91273852978167", 
        StunEnded = "rbxassetid://127453218558340", 
        Swing = "rbxassetid://140242176732868", 
        Hit = "rbxassetid://90819435118493", 
        CorruptEnergy = "rbxassetid://122388551068717", 
        CorruptEnergySummon = "rbxassetid://111388466508150", 
        CorruptEnergyDesummon = "rbxassetid://84267936481619", 
        PuddleStepped = "rbxassetid://128240826870706", 
        DigitalFootprint = "rbxassetid://114243439622992", 
        DigitalFootprintAmbience = "rbxassetid://140163779889034", 
        ["404Error"] = "rbxassetid://117888888155052", 
        ["404ErrorError"] = "rbxassetid://113305896012849", 
        Introduction = "rbxassetid://72636140548768", 
        VictoryTheme = "rbxassetid://122795850954647"
    }
};
v1.Information = {
    {
        Separator = "GENERAL INFO"
    }, 
    {
        Header = "JOHN DOE", 
        Text = "The defunct code of the early days of Roblox courses through their body, consuming his mind as he now only focuses on one thing: to kill everyone in his path. An unstoppable force entering the round with a strategical mindset, he's able to set traps, summon walls to back survivors into a corner, and leave behind a faint trail that damages those who step on it.\n"
    }, 
    {
        Header = "STATS", 
        Text = "Difficulty: \226\152\133\226\152\133\226\152\133\226\152\133\226\152\133\n" .. ("Health: %*\n"):format(v1.Health) .. ("Regular Speed: %*\n"):format(v1.Speed) .. ("Sprinting Speed: %*\n"):format(v1.SprintSpeed) .. ("Max Stamina: %*\n"):format(v1.MaxStamina) .. ("Stamina Loss per sec: %*\n"):format(v1.StaminaLoss) .. ("Stamina Gain per sec: %*\n"):format(v1.StaminaGain) .. "Terror Radius: 60 studs\n"
    }, 
    {
        Separator = "PASSIVES"
    }, 
    {
        Header = "NATURAL MALEVOLENCE", 
        Quote = "\"We\226\128\153re dedicated to building a fun, safe environment where kids of all ages can power their imagination on Roblox.\" - Roblox", 
        Text = "For every step that <font color=\"rgb(248,217,109)\">John Doe</font> takes, a trail of corruption follows behind him.\nAny survivor that's unfortunate enough to step within the corruption is given <b>Corrupted II</b> for 3 seconds.\n"
    }, 
    {
        Header = "UNSTOPPABLE", 
        Quote = "\"Consider this myth busted.\" - Roblox", 
        Text = ("<font color=\"rgb(248,217,109)\">John Doe</font> can only be stunned for %*s while casting Corrupt Energy and 404 Error.\n"):format(v1.UnstoppableDuration) .. "Additionally, <font color=\"rgb(248,217,109)\">John Doe</font> will roar and gain <b>Speed I</b> for 3s upon the stun ending. The duration of the speed boost is increased by 1s for every Sentinel Survivor currently alive.\n" .. "The cooldown of the ability that triggered <b>UNSTOPPABLE</b> is reduced by 50%.\n"
    }, 
    {
        Separator = "ABILITIES"
    }, 
    {
        Header = "SLASH", 
        Image = "rbxassetid://92362553672440", 
        Quote = "\"For many years, there has been lore circulating around John Doe and \226\150\136\226\150\136\226\150\136\226\150\136 Doe within the community.\" - Roblox", 
        Text = ("Cooldown: %*s\n"):format(v1.SlashCooldown) .. ("Damage: %*\n"):format(v1.SlashDamage) .. ("Windup: %*s\n"):format(v1.SlashWindup) .. ("Linger: %*s\n"):format(v1.SlashLinger) .. "Length: 7.5 studs\n" .. "<font color=\"rgb(248,217,109)\">John Doe</font> slashes infront of him using his claws.\n"
    }, 
    {
        Header = "CORRUPT ENERGY", 
        Image = "rbxassetid://83849304758564", 
        Quote = "\"This year, we\226\128\153ve decided that it\226\128\153s time to shed some light about these accounts.\" - Roblox", 
        Text = ("Cooldown: %*s\n"):format(v1.CorruptEnergyCooldown) .. ("Damage: %*\n"):format(v1.CorruptEnergyDamage) .. ("<font color=\"rgb(248,217,109)\">John Doe</font> punches his corrupted arm into the ground and, when he pulls it out, %* giant spikes (that last for %*s) emerge infront of him, piercing through any survivor unfortunate enough to be caught within them.\n"):format(v1.SpikeAmount, v1.SpikeLifetime) .. "Hitting a player with a spike gives <font color=\"rgb(248,217,109)\">John Doe</font> Speed I for 7 seconds.\n" .. ("Summoned spikes cannot damage the same target more than %* times.\n"):format(v1.SpikeHitCap) .. "These spikes can be used as blockades to prevent survivors from accessing certain areas.\n"
    }, 
    {
        Header = "DIGITAL FOOTPRINT", 
        Image = "rbxassetid://83206360003394", 
        Quote = "\"John Doe and \226\150\136\226\150\136\226\150\136\226\150\136 Doe are two of Roblox\226\128\153s earliest accounts, as seen by their low user IDs here.\" - Roblox", 
        Text = ("Cooldown: %*s\n"):format(v1.DigitalFootprintCooldown) .. "<font color=\"rgb(248,217,109)\">John Doe</font> stomps on the ground three times, commanding a shadow to emerge underneath his footsteps as a trap for survivors to walk over.\n" .. "If a survivor steps over the false shadow, then <font color=\"rgb(248,217,109)\">John Doe</font> gets a <b>Speed I</b> buff for 10 seconds and the survivor gets a <b>Corrupted I</b> & <b>Slowness II</b> debuff for 10 seconds.\n" .. "Upon the trap being triggered, <font color=\"rgb(248,217,109)\">John Doe</font> and the survivor who activated it have their auras revealed to each other for 10 seconds.\n" .. "The shadow despawns after contact is made with it or <font color=\"rgb(248,217,109)\">John Doe</font> attempts to place down a fourth shadow.\n" .. ("There can only be <b>%*</b> shadows present at once, and attempting to create more will cause the oldest shadow to dissipate.\n"):format(v1.DigitalFootprintLimit)
    }, 
    {
        Header = "404 ERROR", 
        Image = "rbxassetid://131116145215571", 
        Quote = "\"Authentic John Doe and \226\150\136\226\150\136\226\150\136\226\150\136 Doe accounts pose no danger to your Roblox account.\" - Roblox", 
        Text = ("Cooldown: %*s\n"):format(v1["404ErrorCooldown"]) .. ("<font color=\"rgb(248,217,109)\">John Doe</font>'s corrupted arm pulsates twice, revealing the auras of all living survivors to him for %* seconds.\n"):format(v1["404ErrorAuraRevealTime"])
    }
};
-- Phase-one rig profiles. Current FCT animations and all balance values are retained.
v1.JohnDoeRigCollision=script.JohnDoeRigCollision
v1.JohnDoeRigQuery=script.JohnDoeRigQuery
v1.JohnDoeRigScale=script:GetAttribute("JohnDoeRigScale") or 1.25
v1.JohnDoeRigPhase="1.0.0"
v1.HipHeight=0
return v1;]==========],
[ [==========[
ReplicatedStorage/Assets/Killers/JohnDoe/Behavior]==========] ]=[==========[
-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local _ = require(game.ReplicatedStorage.GlobalTypes);
local v1 = {};
local RigAlignment=require(script.RigAlignment);
v1.GetRig=function(_,actor) return RigAlignment.GetRig(actor) end;
local l_TweenService_0 = game:GetService("TweenService");
local _ = game:GetService("HttpService");
local l_Players_0 = game:GetService("Players");
local v5 = require(game.ReplicatedStorage.Modules.Sounds);
local v6 = require(game.ReplicatedStorage.Modules.Util);
local v7 = require(game.ReplicatedStorage.Modules.Hitboxes);
local v8 = require(game.ReplicatedStorage.Modules.Statuses);
local v9 = require(game.ReplicatedStorage.Modules.Network);
local v10 = require(game.ReplicatedStorage.Modules.AchievementUtil);
local function v16(v11, v12, v13, ...) --[[ Line: 23 ]] --[[ Name: pcallMethod ]]
    local l_status_0, l_result_0 = pcall(function(...) --[[ Line: 24 ]]
        -- upvalues: v13 (copy), v11 (copy)
        if v13.Behavior[v11] then
            return v13.Behavior[v11](v13.Behavior, v13, ...);
        else
            return;
        end;
    end, ...);
    if not l_status_0 then
        warn((("[%*]: Failed to call .%*() due to: %*"):format(v12, v11, l_result_0)));
    end;
    return l_result_0;
end;
v1.Abilities = {
    Slash = {
        LayoutOrder = 1, 
        Icon = "rbxassetid://92362553672440", 
        KeybindType = "MainAbility", 
        Callback = function(v17) --[[ Line: 42 ]] --[[ Name: Callback ]]
            -- upvalues: v5 (copy), v7 (copy), v6 (copy)
            if game["Run Service"]:IsServer() then
                v17.AbilitiesDisabled = true;
                v5:Play(v17.Config.Sounds.Swing, {
                    Parent = v17.Rig.PrimaryPart, 
                    PlaybackSpeed = Random.new():NextNumber(0.975, 1.025), 
                    Volume = 0.35
                });
                task.delay(v17.Config.SlashWindup, function() --[[ Line: 49 ]]
                    -- upvalues: v7 (ref), v17 (copy), v6 (ref), v5 (ref)
                    local _ = v7:CreateHitbox(v17.Player, { AbilityType = "MainAbility", IsProjectile = false, 
                        Size = Vector3.new(4.5, 6, 7.5, 0), 
                        CFrameOffset = RigAlignment.SlashOffset(v17), 
                        Damage = v17.Config.SlashDamage, 
                        Time = v17.Config.SlashLinger, 
                        Knockback = 2, 
                        HitMultiple = false, 
                        ExecuteOnKill = true, 
                        Connections = {
                            Hit = function(v18, v19) --[[ Line: 61 ]] --[[ Name: Hit ]]
                                -- upvalues: v6 (ref), v5 (ref), v17 (ref)
                                v6:CreateSpeedMultiplier(v18, 1.5, "HitSpeedBonus", 1.25);
                                if v19 then
                                    v5:Play(v17.Config.Sounds.Hit, {
                                        Parent = v17.Rig.PrimaryPart, 
                                        PlaybackSpeed = Random.new():NextNumber(0.975, 1.025), 
                                        Volume = 0.5
                                    });
                                end;
                            end
                        }
                    });
                end);
                task.delay(0.75, function() --[[ Line: 72 ]]
                    -- upvalues: v17 (copy)
                    v17.AbilitiesDisabled = false;
                end);
                return;
            else
                if game["Run Service"]:IsClient() then
                    if v17.Animations.Slash1 then
                        v17.Animations[("Slash%*"):format((tostring(math.random(1, 2))))]:Play(0.025);
                        return;
                    else
                        v17.Animations.Slash:Play(0.025);
                    end;
                end;
                return;
            end;
        end
    }, 
    CorruptEnergy = {
        LayoutOrder = 2, 
        Icon = "rbxassetid://83849304758564", 
        KeybindType = "AltAbility1", 
        Callback = function(v21) --[[ Line: 91 ]] --[[ Name: Callback ]]
            -- upvalues: v16 (copy), v5 (copy), v9 (copy), v7 (copy), v10 (copy), v6 (copy), v8 (copy)
            v16("CorruptEnergyStart", ("%*/CorruptEnergyStart"):format(script.Parent), v21);
            if game["Run Service"]:IsServer() then
                v21.CurrentAbility = "CorruptEnergy";
                v21.AbilitiesDisabled = true;
                v5:Play(v21.Config.Sounds.CorruptEnergy, {
                    Parent = v21.Rig.PrimaryPart, 
                    Volume = 0.4, 
                    TimePosition = 0.09, 
                    PlaybackSpeed = 1.2
                });
                v21.Config.StunDuration = v21.Config.UnstoppableDuration;
                local v22 = RaycastParams.new();
                v22.FilterDescendantsInstances = {
                    workspace.Players
                };
                v22.FilterType = Enum.RaycastFilterType.Exclude;
                local v23 = false;
                local v24 = nil;
                v24 = v21.Rig:GetAttributeChangedSignal("Stunned"):Once(function() --[[ Line: 111 ]]
                    -- upvalues: v23 (ref)
                    v23 = true;
                end);
                local v25 = {};
                task.delay(2, function() --[[ Line: 117 ]]
                    -- upvalues: v21 (copy), v23 (ref), v22 (copy), v9 (ref), v7 (ref), v10 (ref), v6 (ref), v8 (ref), v25 (copy), v5 (ref)
                    for v26 = 1, v21.Config.SpikeAmount do
                        task.delay(v26 * v21.Config.DelayBetweenSpikeSummons, function() --[[ Line: 120 ]]
                            -- upvalues: v23 (ref), v21 (ref), v26 (copy), v22 (ref), v9 (ref), v7 (ref), v10 (ref), v6 (ref), v8 (ref), v25 (ref), v5 (ref)
                            if v23 then
                                return;
                            elseif not v21.Rig.PrimaryPart then
                                return;
                            elseif v21.Rig:GetAttribute("Stunned") then
                                v23 = true;
                                return;
                            else
                                local l_Position_0 = (v21:GetPivot() * CFrame.new(0, 0, -v21.Config.DistanceBetweenSpikes * v26)).Position;
                                local v28 = workspace:Raycast(l_Position_0, Vector3.new(0, -100, 0, 0), v22) or workspace:Raycast(l_Position_0, Vector3.new(0, 100, 0, 0), v22);
                                if v28 and v28.Position then
                                    local l_SpikeHitboxSize_0 = v21.Config.SpikeHitboxSize;
                                    local v30 = {
                                        Position = Vector3int16.new(v28.Position.X, v28.Position.Y, v28.Position.Z), 
                                        Rotation = math.random(0, 360), 
                                        SpikeUUID = v26
                                    };
                                    local l_Part_0 = Instance.new("Part");
                                    l_Part_0.Anchored = true;
                                    l_Part_0.Size = l_SpikeHitboxSize_0;
                                    l_Part_0.CanTouch = false;
                                    l_Part_0.Transparency = 1;
                                    l_Part_0.Name = "SpikeCollision";
                                    local v32 = CFrame.new(v28.Position) * CFrame.Angles(0, math.rad(v30.Rotation), 1.5707963267948966) - Vector3.new(0, l_SpikeHitboxSize_0.Y, 0);
                                    local v33 = v32 + Vector3.new(0, l_SpikeHitboxSize_0.Y * 2, 0);
                                    l_Part_0.CFrame = v32;
                                    l_Part_0.Parent = workspace.Map.Ingame;
                                    task.spawn(function() --[[ Line: 147 ]]
                                        -- upvalues: l_Part_0 (copy), v32 (copy), v33 (copy)
                                        l_Part_0.CFrame = v32:Lerp(v33, 0.5);
                                        task.wait(0.05);
                                        l_Part_0.CFrame = v32:Lerp(v33, 1);
                                        task.wait(0.05);
                                    end);
                                    v9:FireAllClientConnection(("%*SpawnSpike"):format(v21.Player.Name), "REMOTE_EVENT", v30);
                                    task.delay(0.1, function() --[[ Line: 157 ]]
                                        -- upvalues: v21 (ref), l_Part_0 (copy)
                                        table.insert(v21.CurrentSpikes or {}, l_Part_0);
                                    end);
                                    task.delay(v21.Config.SpikeLifetime, function() --[[ Line: 162 ]]
                                        -- upvalues: v9 (ref), v21 (ref), v30 (copy), l_Part_0 (copy)
                                        v9:FireAllClientConnection(("%*DesummonSpike"):format(v21.Player.Name), "REMOTE_EVENT", v30.SpikeUUID);
                                        if l_Part_0.Parent then
                                            local l_Size_0 = l_Part_0.Size;
                                            task.spawn(function() --[[ Line: 168 ]]
                                                -- upvalues: l_Part_0 (ref), l_Size_0 (copy)
                                                local l_Position_1 = l_Part_0.Position;
                                                local v36 = l_Position_1 - Vector3.new(0, l_Size_0.Y * 2, 0);
                                                for v37 = 1, 4 do
                                                    l_Part_0.Position = l_Position_1:Lerp(v36, v37 * 0.25);
                                                    task.wait(0.25);
                                                end;
                                            end);
                                            task.delay(1, function() --[[ Line: 178 ]]
                                                -- upvalues: v21 (ref), l_Part_0 (ref)
                                                local v38 = table.find(v21.CurrentSpikes or {}, l_Part_0);
                                                if v38 then
                                                    table.remove(v21.CurrentSpikes or {}, v38);
                                                end;
                                                l_Part_0:Destroy();
                                            end);
                                        end;
                                    end);
                                    local _ = v7:CreateHitbox(v21.Player, {
                                        Size = l_SpikeHitboxSize_0, 
                                        CFrame = function() --[[ Line: 191 ]] --[[ Name: CFrame ]]
                                            -- upvalues: l_Part_0 (copy)
                                            return l_Part_0.CFrame;
                                        end, 
                                        Damage = v21.Config.CorruptEnergyDamage, 
                                        Time = 0.15, 
                                        Knockback = 5, 
                                        HitMultiple = true, 
                                        PredictVelocity = false, 
                                        Connections = {
                                            Hit = function(v39, v40) --[[ Line: 200 ]] --[[ Name: Hit ]]
                                                -- upvalues: v10 (ref), v21 (ref), v6 (ref), v8 (ref), v25 (ref), v5 (ref)
                                                if v39.Humanoid.Health <= 0 then
                                                    v10:IncrementAchievementProgress(v21.Player, "JohnDoeSpikes");
                                                    if tostring(v39.Parent) == "Survivors" then
                                                        require(game.ReplicatedStorage.Modules.Actors):IncrementActorStats(v21.Player, {
                                                            Action = "Killed a Survivor with Corrupt Energy", 
                                                            RewardType = "DifficultKillerAction"
                                                        });
                                                    end;
                                                else
                                                    v6:CreateSpeedMultiplier(v39, 1.5, "HitSpeedBonus", 1.25);
                                                    v8:ApplyStatus(v21.Rig, "Speed", {
                                                        Duration = 7, 
                                                        Level = 1
                                                    });
                                                    v6:RevealPlayerAuraTo(v21.Player, v39, 2.5);
                                                    if not v25[v39] then
                                                        v25[v39] = 1;
                                                    else
                                                        local l_v25_0 = v25;
                                                        l_v25_0[v39] = l_v25_0[v39] + 1;
                                                        if v25[v39] >= v21.Config.SpikeHitCap then
                                                            v6:GiveInvincible(v39, "SpikeLimit", 1);
                                                        end;
                                                    end;
                                                    if tostring(v39.Parent) == "Survivors" then
                                                        require(game.ReplicatedStorage.Modules.Actors):IncrementActorStats(v21.Player, {
                                                            Action = "Damaged a Survivor with Corrupt Energy", 
                                                            RewardType = "EasyKillerAction"
                                                        });
                                                    end;
                                                end;
                                                if v40 then
                                                    v5:Play(v21.Config.Sounds.Hit, {
                                                        Parent = v21.Rig.PrimaryPart, 
                                                        PlaybackSpeed = Random.new():NextNumber(0.975, 1.025), 
                                                        Volume = 0.25
                                                    });
                                                end;
                                            end
                                        }
                                    });
                                end;
                                return;
                            end;
                        end);
                    end;
                    task.wait(v21.Config.SpikeAmount * v21.Config.DelayBetweenSpikeSummons);
                    v21.Config.StunDuration = nil;
                end);
                task.delay(3.5, function() --[[ Line: 258 ]]
                    -- upvalues: v24 (ref), v21 (copy)
                    pcall(function() --[[ Line: 259 ]]
                        -- upvalues: v24 (ref)
                        v24:Disconnect();
                    end);
                    v21.CurrentAbility = nil;
                    v21.AbilitiesDisabled = false;
                end);
                return;
            else
                if game["Run Service"]:IsClient() then
                    v21.Animations.CorruptEnergy:Play(0.025);
                    local v43 = false;
                    local l_v6_SpeedMultiplier_0 = v6:CreateSpeedMultiplier(v21.Player, 0.001, "CorruptEnergy");
                    game.Debris:AddItem(l_v6_SpeedMultiplier_0, 3.5);
                    local v45 = nil;
                    do
                        local l_v43_0 = v43;
                        v45 = v21.Rig:GetAttributeChangedSignal("Stunned"):Once(function() --[[ Line: 274 ]]
                            -- upvalues: l_v6_SpeedMultiplier_0 (copy), v21 (copy), l_v43_0 (ref)
                            l_v6_SpeedMultiplier_0:Destroy();
                            v21.Animations.CorruptEnergy:Stop();
                            l_v43_0 = true;
                        end);
                        task.delay(3.6, v45.Disconnect, v45);
                        local v47 = {
                            1.067, 
                            1.917
                        };
                        local v48 = 0;
                        local v49 = 0;
                        task.spawn(function() --[[ Line: 287 ]]
                            -- upvalues: v21 (copy), v47 (copy), l_v43_0 (ref), v49 (ref), v48 (ref), v6 (ref)
                            while v21 and v21.Rig.Parent and v47[1] and not l_v43_0 do
                                v49 = v49 + game["Run Service"].Heartbeat:Wait();
                                for v50 = #v47, 1, -1 do
                                    if v47[v50] and v49 >= v47[v50] then
                                        table.remove(v47, v50);
                                        v48 = v48 + 1;
                                        v6:ApplyCameraShake(v48 * 0.2, v48 * 0.35);
                                    end;
                                end;
                            end;
                        end);
                    end;
                end;
                return;
            end;
        end
    }, 
    DigitalFootprint = {
        LayoutOrder = 3, 
        Icon = "rbxassetid://83206360003394", 
        KeybindType = "AltAbility2", 
        Callback = function(v51, v52) --[[ Line: 311 ]] --[[ Name: Callback ]]
            -- upvalues: v5 (copy), v16 (copy), v6 (copy), v8 (copy), v9 (copy), l_Players_0 (copy)
            local v53 = {
                0.317, 
                1.05, 
                2.067
            };
            local v54 = 0;
            local v55 = 0;
            if game["Run Service"]:IsServer() then
                v51.AbilitiesDisabled = true;
                v5:Play(v51.Config.Sounds.DigitalFootprint, {
                    Parent = v51.Rig.PrimaryPart, 
                    Volume = 0.4, 
                    TimePosition = 0.09, 
                    PlaybackSpeed = 1.2
                });
                v16("DFStart", ("%*/DFS"):format(script.Parent), v51);
                local function v60(v56) --[[ Line: 323 ]] --[[ Name: removeShadow ]]
                    -- upvalues: v6 (ref), v51 (copy)
                    if v56 and v56.Parent then
                        v56.Name = "okByeBye";
                        v56.Parent = workspace.Map.Ingame;
                        game.Debris:AddItem(v56, 5);
                        local l_ShadowAmbience_0 = v56:FindFirstChild("ShadowAmbience");
                        if l_ShadowAmbience_0 then
                            game.TweenService:Create(l_ShadowAmbience_0, TweenInfo.new(2), {
                                Volume = 0
                            }):Play();
                        end;
                        for _, v59 in pairs(v56:GetDescendants()) do
                            if v59:IsA("ParticleEmitter") then
                                v59.Enabled = false;
                            end;
                        end;
                        v6:RemovePlayerAuraFrom(v56, v51.Player);
                    end;
                end;
                local l_FirstChild_0 = workspace.Map.Ingame:FindFirstChild((("%*Shadows"):format((tostring(v51.Player)))));
                if not l_FirstChild_0 then
                    l_FirstChild_0 = Instance.new("Folder");
                    l_FirstChild_0.Name = ("%*Shadows"):format((tostring(v51.Player)));
                    l_FirstChild_0.Parent = workspace.Map.Ingame;
                end;
                local l_l_FirstChild_0_Children_0 = l_FirstChild_0:GetChildren();
                if #l_l_FirstChild_0_Children_0 >= v51.Config.DigitalFootprintLimit then
                    v60(l_l_FirstChild_0_Children_0[1]);
                end;
                local v63 = v51.Config.Shadow:Clone();
                v63.Size = Vector3.new(1, 0, 0, 0);
                v63.Parent = l_FirstChild_0;
                v5:Play(v51.Config.Sounds.DigitalFootprintAmbience, {
                    Parent = v63, 
                    Name = "ShadowAmbience", 
                    RollOffMaxDistance = 30, 
                    Looped = true
                });
                local v64 = RaycastParams.new();
                v64.FilterDescendantsInstances = {
                    workspace.Players, 
                    v63
                };
                v64.FilterType = Enum.RaycastFilterType.Exclude;
                task.delay(tonumber(v53[#v53]) or 2.55, function() --[[ Line: 380 ]]
                    -- upvalues: v6 (ref), v63 (copy), v51 (copy), v60 (copy), v8 (ref), v9 (ref), l_Players_0 (ref)
                    v6:ApplyUnsafeTouched(v63, false, function(_, v66) --[[ Line: 381 ]]
                        -- upvalues: v6 (ref), v51 (ref), v63 (ref), v60 (ref), v8 (ref), v9 (ref), l_Players_0 (ref)
                        local l_Parent_0 = v66.Parent;
                        local v68 = l_Parent_0 and l_Parent_0:FindFirstChild("Humanoid");
                        if v68 and v6:GetEntityType(l_Parent_0) and l_Parent_0 ~= v51.Rig and v68 and v68.Health > 0 and v63.Name == "Shadow" and not l_Parent_0:GetAttribute("ExecutionsDisabled") then
                            v60(v63);
                            v6:RevealPlayerAuraTo(v51.Rig, l_Parent_0, 10);
                            v6:RevealPlayerAuraTo(l_Parent_0, v51.Rig, 10);
                            v8:ApplyStatus(v51.Rig, "Speed", {
                                Level = 1, 
                                Duration = 10
                            });
                            v8:ApplyStatus(l_Parent_0, "Slowness", {
                                Level = 2, 
                                Duration = 10
                            });
                            v8:ApplyStatus(l_Parent_0, "Corrupted", {
                                Level = 1, 
                                Duration = 10, 
                                Killer = v51
                            });
                            if not v51.FootprintRewardDebounce[l_Parent_0] then
                                v51.FootprintRewardDebounce[l_Parent_0] = true;
                                require(game.ReplicatedStorage.Modules.Actors):IncrementActorStats(v51.Player, {
                                    Action = "Survivor stepped into a Digital Footprint trap", 
                                    RewardType = "RegularKillerAction"
                                });
                                task.delay(15, function() --[[ Line: 408 ]]
                                    -- upvalues: v51 (ref), l_Parent_0 (copy)
                                    v51.FootprintRewardDebounce[l_Parent_0] = nil;
                                end);
                            end;
                            v9:FireClientConnection(l_Players_0:GetPlayerFromCharacter(l_Parent_0), ("%*JDPuddleEffect"):format(v51.Player.Name), "REMOTE_EVENT");
                        end;
                    end, 14);
                end);
                task.spawn(function() --[[ Line: 419 ]]
                    -- upvalues: v54 (ref), v63 (copy), v55 (ref), v53 (copy), v51 (copy), v64 (copy), v16 (ref), v9 (ref)
                    while v54 ~= 3 and v63.Parent and v63.Name == "Shadow" do
                        v55 = v55 + game["Run Service"].Heartbeat:Wait();
                        for v69 = #v53, 1, -1 do
                            if v53[v69] and v55 >= v53[v69] then
                                table.remove(v53, v69);
                                v54 = v54 + 1;
                                local l_Position_2 = (v51.Rig.PrimaryPart.CFrame * CFrame.new(-1.1, 0, -2)).Position;
                                local v71 = workspace:Raycast(l_Position_2, Vector3.new(0, -100, 0, 0), v64);
                                v63.Position = (v71 and v71.Position or v51.Rig.PrimaryPart.Position - Vector3.new(0, 2.5, 0, 0)) + Vector3.new(0, 0.5, 0, 0);
                                game.TweenService:Create(v63, TweenInfo.new(1), {
                                    Size = Vector3.new(1, v54 * 6, v54 * 6)
                                }):Play();
                                v16("OnStomp", ("%*/OnStomp"):format(script.Parent), v51, v63, v54);
                                if v54 == 3 then
                                    v9:FireAllClientConnection(("%*OnPuddleRevealed"):format(v51.Player.Name), "REMOTE_EVENT", v63);
                                end;
                            end;
                        end;
                    end;
                end);
                task.delay(3, function() --[[ Line: 446 ]]
                    -- upvalues: v51 (copy)
                    v51.AbilitiesDisabled = false;
                end);
                return v63;
            else
                if game["Run Service"]:IsClient() then
                    v51.Animations.DigitalFootprint:Play(0.025);
                    local l_Connections_0 = v51.Behavior.Connections;
                    if not l_Connections_0.onShadowFolderAdded or not l_Connections_0.onShadowFolderRemoved then
                        local l_FirstChild_1 = workspace.Map.Ingame:FindFirstChild((("%*Shadows"):format((tostring(v51.Player)))));
                        if not l_FirstChild_1 then
                            return;
                        else
                            local l_AbilityContainer_0 = v51.Player.PlayerGui.MainUI:FindFirstChild("AbilityContainer");
                            local v75 = l_AbilityContainer_0 and l_AbilityContainer_0:FindFirstChild("DigitalFootprint");
                            local v76 = 1;
                            do
                                local l_v76_0 = v76;
                                local function v80(v78) --[[ Line: 465 ]] --[[ Name: onShadowChange ]]
                                    -- upvalues: v75 (copy), l_v76_0 (ref), v51 (copy)
                                    if not v75 then
                                        return;
                                    else
                                        l_v76_0 = math.max(0, l_v76_0 + v78);
                                        v75.Charges.Text = l_v76_0 == 0 and "" or l_v76_0;
                                        local v79 = l_v76_0 >= v51.Config.DigitalFootprintLimit;
                                        v75.Charges.TextColor3 = v79 and Color3.new(1, 0, 0) or Color3.new(1, 1, 1);
                                        return;
                                    end;
                                end;
                                v51.Behavior.Connections.onShadowFolderAdded = l_FirstChild_1.ChildAdded:Connect(function(v81) --[[ Line: 477 ]]
                                    -- upvalues: v80 (copy)
                                    if not v81:IsA("BasePart") then
                                        return;
                                    else
                                        v80(1);
                                        return;
                                    end;
                                end);
                                v51.Behavior.Connections.onShadowFolderRemoved = l_FirstChild_1.ChildRemoved:Connect(function(v82) --[[ Line: 485 ]]
                                    -- upvalues: v80 (copy)
                                    if not v82:IsA("BasePart") then
                                        return;
                                    else
                                        v80(-1);
                                        return;
                                    end;
                                end);
                                v80(0);
                            end;
                        end;
                    end;
                    local l_v6_SpeedMultiplier_1 = v6:CreateSpeedMultiplier(v51.Player, 0, "DigitalFootprint");
                    game.Debris:AddItem(l_v6_SpeedMultiplier_1, 3);
                    task.spawn(function() --[[ Line: 501 ]]
                        -- upvalues: v51 (copy), v53 (copy), v55 (ref), v54 (ref), v6 (ref)
                        while v51 and v51.Rig.Parent and v53[1] do
                            v55 = v55 + game["Run Service"].Heartbeat:Wait();
                            for v84 = #v53, 1, -1 do
                                if v53[v84] and v55 >= v53[v84] then
                                    table.remove(v53, v84);
                                    v54 = v54 + 1;
                                    v6:ApplyCameraShake(v54 * 0.2, v54 * 0.375);
                                end;
                            end;
                        end;
                    end);
                    task.delay(3, function() --[[ Line: 517 ]]
                        -- upvalues: v52 (copy), v6 (ref)
                        if not v52 or not v52.Parent then
                            return;
                        else
                            v52.Transparency = 0;
                            v6:RevealPlayerAura(v52, "inf", Color3.new(1, 0.321569, 0.333333), nil, {
                                OutlineTransparency = 0.35, 
                                FillTransparency = 1
                            });
                            return;
                        end;
                    end);
                end;
                return;
            end;
        end
    }, 
    ["404Error"] = {
        Name = "404 Error", 
        LayoutOrder = 4, 
        Icon = "rbxassetid://131116145215571", 
        KeybindType = "AltAbility3", 
        Callback = function(v85) --[[ Line: 537 ]] --[[ Name: Callback ]]
            -- upvalues: v16 (copy), v5 (copy), v6 (copy), v9 (copy)
            v16("ErrorStart", ("%*/404S"):format(script.Parent), v85);
            if game["Run Service"]:IsServer() then
                v85.CurrentAbility = "404Error";
                v85.Config.StunDuration = v85.Config.UnstoppableDuration;
                v85.AbilitiesDisabled = true;
                v5:Play(v85.Config.Sounds["404Error"], {
                    Parent = v85.Rig.PrimaryPart, 
                    Volume = 0.4, 
                    TimePosition = 0.09, 
                    RollOffMaxDistance = 200, 
                    PlaybackSpeed = 1.15
                });
                task.delay(1.625, function() --[[ Line: 550 ]]
                    -- upvalues: v85 (copy)
                    v85.Config.StunDuration = nil;
                    v85.CurrentAbility = nil;
                    v85.AbilitiesDisabled = false;
                end);
                return;
            else
                if game["Run Service"]:IsClient() then
                    local l_v6_SpeedMultiplier_2 = v6:CreateSpeedMultiplier(v85.Player, 1, "404Error");
                    local l_v6_FOVMultiplier_0 = v6:CreateFOVMultiplier(v85.Player, 1, "404Error");
                    game.TweenService:Create(l_v6_SpeedMultiplier_2, TweenInfo.new(0.5), {
                        Value = 0.25
                    }):Play();
                    game.TweenService:Create(l_v6_FOVMultiplier_0, TweenInfo.new(1.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, true), {
                        Value = 0.75
                    }):Play();
                    v9:FireConnection("DisableSprinting", "404Error", true);
                    task.delay(1.2, function() --[[ Line: 567 ]]
                        -- upvalues: v5 (ref), v85 (copy), v9 (ref), l_v6_SpeedMultiplier_2 (copy), l_v6_FOVMultiplier_0 (copy), v6 (ref)
                        v5:Play(v85.Config.Sounds["404ErrorError"], {
                            Parent = v85.Rig.PrimaryPart, 
                            Volume = 0.4, 
                            TimePosition = 0.09, 
                            PlaybackSpeed = Random.new():NextNumber(0.9, 1.1)
                        });
                        v9:FireConnection("DisableSprinting", "404Error", false);
                        game.TweenService:Create(l_v6_SpeedMultiplier_2, TweenInfo.new(0.6), {
                            Value = 1
                        }):Play();
                        game.TweenService:Create(l_v6_FOVMultiplier_0, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                            Value = 1
                        }):Play();
                        game.Debris:AddItem(l_v6_SpeedMultiplier_2, 0.4);
                        game.Debris:AddItem(l_v6_FOVMultiplier_0, 1);
                        for _, v89 in pairs(workspace.Players.Survivors:GetChildren()) do
                            v6:RevealPlayerAura(v89, v85.Config["404ErrorAuraRevealTime"]);
                        end;
                    end);
                end;
                return;
            end;
        end
    }
};
v1.ErrorStart = function(_, _) --[[ Line: 591 ]] --[[ Name: ErrorStart ]]

end;
v1.CorruptEnergyStart = function(_, _) --[[ Line: 595 ]] --[[ Name: CorruptEnergyStart ]]

end;
v1.OnPuddleEpilepsy = function(_, _, _) --[[ Line: 599 ]] --[[ Name: OnPuddleEpilepsy ]]

end;
v1.OnStomp = function(_, _, v99, v100) --[[ Line: 603 ]] --[[ Name: OnStomp ]]
    for _, v102 in pairs(v99:GetDescendants()) do
        if v102:IsA("ParticleEmitter") and v102.Name:find("ShadowPuddle") then
            v102.Enabled = v102.Name == ("ShadowPuddle%*"):format(v100);
        end;
    end;
end;
v1.Created = function(v103, v104) --[[ Line: 611 ]] --[[ Name: Created ]]
    -- upvalues: v10 (copy), v6 (copy), v8 (copy), l_Players_0 (copy), v9 (copy), v5 (copy), l_TweenService_0 (copy), v16 (copy)
    v103.Connections = {};
    if game["Run Service"]:IsServer() then
        if workspace:GetAttribute("JohnDoeSpecialDay") then
            v10:IncrementAchievementProgress(v104.Player, "JohnDoeSpecialDay");
        end;
        local l_Folder_0 = Instance.new("Folder");
        l_Folder_0.Name = "JohnDoeTrail";
        l_Folder_0.Parent = v104.Rig;
        for _ = 1, math.clamp(math.round(v104.Config.TrailLength / 4), 2, 1e999) do
            local v107 = v104.Config.Trail:Clone();
            v107.Position = RigAlignment.TrailPoint(v104,true);
            v107.Parent = l_Folder_0;
            v107:SetAttribute("FinishedUpdating", true);
            v6:ApplyOnTouched(v107, false, function(_, v109) --[[ Line: 635 ]]
                -- upvalues: v8 (ref), v104 (copy)
                local l_Parent_1 = v109.Parent;
                local l_Humanoid_0 = l_Parent_1:FindFirstChild("Humanoid");
                if l_Humanoid_0 and l_Humanoid_0.Health > 0 and l_Parent_1:IsDescendantOf(workspace.Players) and tostring(l_Parent_1.Parent) ~= "Killers" then
                    v8:ApplyStatus(l_Parent_1, "Corrupted", {
                        Duration = 3, 
                        Level = 2, 
                        Killer = v104
                    });
                end;
            end);
        end;
        v104.CurrentSpikes = {};
        v104.FootprintRewardDebounce = {};
        local v112 = false;
        v104.Rig:GetAttributeChangedSignal("Stunned"):Connect(function() --[[ Line: 648 ]]
            -- upvalues: v104 (copy), v112 (ref)
            if v104.Rig:GetAttribute("Stunned") and v104.Config.StunDuration and v104.CurrentAbility and not v112 then
                v112 = true;
                local l_CurrentAbility_0 = v104.CurrentAbility;
                local v114 = v104.Config[l_CurrentAbility_0 .. "Cooldown"];
                if v114 then
                    v104:SetCooldownOf(l_CurrentAbility_0, (math.max(v114 * 0.5, 0)));
                end;
                task.delay(1, function() --[[ Line: 657 ]]
                    -- upvalues: v112 (ref)
                    v112 = false;
                end);
            end;
        end);
        local l_l_Folder_0_Children_0 = l_Folder_0:GetChildren();
        local v116 = 0;
        local v117 = 0;
        local v118 = 0;
        local v119 = nil;
        v119 = game["Run Service"].Heartbeat:Connect(function(v120) --[[ Line: 670 ]]
            -- upvalues: v104 (copy), l_Folder_0 (copy), v119 (ref), v118 (ref), l_Players_0 (ref), v8 (ref), v117 (ref), l_l_Folder_0_Children_0 (copy), v116 (ref)
            if not v104 or not v104.Rig.Parent or not v104.Rig.PrimaryPart then
                l_Folder_0:Destroy();
                v119:Disconnect();
                v119 = nil;
                return;
            else
                if v118 > 1 and #v104.CurrentSpikes > 0 then
                    v118 = 0;
                    local v121 = RaycastParams.new();
                    v121.FilterDescendantsInstances = v104.CurrentSpikes;
                    v121.FilterType = Enum.RaycastFilterType.Include;
                    for _, v123 in (l_Players_0:GetPlayers()) do
                        local l_Character_0 = v123.Character;
                        if l_Character_0 and l_Character_0.Parent then
                            if not l_Character_0 or not l_Character_0.Parent or l_Character_0.Parent.Name == "Killers" then

                            end;
                            local l_Humanoid_1 = l_Character_0:FindFirstChildOfClass("Humanoid");
                            if l_Humanoid_1 or l_Humanoid_1.Health <= 0 then
                                local l_PrimaryPart_0 = l_Character_0.PrimaryPart;
                                local v127 = workspace:Raycast(l_PrimaryPart_0.Position, Vector3.new(0, -5, 0, 0), v121);
                                local v128 = v127 and v127.Instance;
                                if v127 and v128 then
                                    local v129 = v128.Position.Y + v128.Size.Y / 2;
                                    local v130 = RaycastParams.new();
                                    v130.FilterDescendantsInstances = {
                                        l_Character_0, 
                                        v104.CurrentSpikes
                                    };
                                    v130.FilterType = Enum.RaycastFilterType.Exclude;
                                    local v131 = workspace:Raycast(l_PrimaryPart_0.Position, Vector3.new(0, -10, 0, 0), v130);
                                    if v131 then
                                        if v129 - v131.Position.Y >= 1.5 then
                                            v8:ApplyStatus(v123, "Corrupted", {
                                                Level = 2, 
                                                Duration = 5, 
                                                Killer = v104
                                            });
                                        end;
                                    else
                                        v8:ApplyStatus(v123, "Corrupted", {
                                            Level = 2, 
                                            Duration = 5, 
                                            Killer = v104
                                        });
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;
                v118 = v118 + v120;
                if v117 <= 0.05 then
                    v117 = v117 + v120;
                    return;
                else
                    v117 = 0;
                    local v132 = l_l_Folder_0_Children_0[v116 % #l_l_Folder_0_Children_0 + 1];
                    local v133 = l_l_Folder_0_Children_0[(v116 - 1) % #l_l_Folder_0_Children_0 + 1];
                    if v132 and v133 then
                        if v132.Size.Z <= 4 or v132:GetAttribute("FinishedUpdating") then
                            if v132:GetAttribute("FinishedUpdating") then
                                v132:SetAttribute("FinishedUpdating", nil);
                            end;
                            local v134 = RigAlignment.TrailPoint(v104,false);
                            local l_Position_3 = v133:GetPivot().Position;
                            local l_Rotation_0 = CFrame.lookAt(l_Position_3, v134).Rotation;
                            if l_Rotation_0 ~= l_Rotation_0 then
                                warn("currentTrailRotation is NaN, setting rotation to root rotation as fallback");
                                l_Rotation_0 = v104.Rig.PrimaryPart.CFrame.Rotation;
                            end;
                            v132.CFrame = CFrame.new(v133:GetPivot().Position) * l_Rotation_0 * CFrame.Angles(0, 0, 0);
                            v132.Size = Vector3.new(v132.Size.X, v132.Size.Y, (v132.Position - v134).Magnitude);
                            v132.PivotOffset = CFrame.new(0, 0, -v132.Size.Z / 2);
                            v132.CFrame = v132.CFrame * v132.PivotOffset;
                            return;
                        else
                            v132:SetAttribute("FinishedUpdating", true);
                            v116 = v116 + 1;
                            return;
                        end;
                    else
                        v116 = v116 + 1;
                        return;
                    end;
                end;
            end;
        end);
        return;
    else
        if game["Run Service"]:IsClient() then
            v104.ActiveSpikeModels = {};
            if game.Players.LocalPlayer==v104.Player and RigAlignment.IsUpdated(v104.Rig) then
                v104.JohnDoeRigCameraOffset=v6:CreateCameraOffset(v104.Rig,Vector3.new(0,.25,0),"JohnDoeDefault");
            end;
            v9:SetConnection(("%*JDPuddleEffect"):format(v104.Player.Name), "REMOTE_EVENT", function() --[[ Line: 776 ]]
                -- upvalues: v5 (ref), v104 (copy)
                v5:Play(v104.Config.Sounds.PuddleStepped);
            end);
            v9:SetConnection(("%*SpawnSpike"):format(v104.Player.Name), "REMOTE_EVENT", function(v137) --[[ Line: 780 ]]
                -- upvalues: v104 (copy), l_TweenService_0 (ref), v5 (ref)
                local v138 = v104.Config.Spike:Clone();
                local l_Y_0 = v104.Config.SpikeHitboxSize.Y;
                local v140 = Vector3.new(v137.Position.X, v137.Position.Y, v137.Position.Z);
                v138:PivotTo(CFrame.new(v140) * CFrame.Angles(3.141592653589793, math.rad(v137.Rotation), 0) - Vector3.new(0, l_Y_0, 0));
                v138.Parent = workspace.Map.Ingame;
                for _, v142 in (v138:GetDescendants()) do
                    if v142:IsA("BasePart") then
                        v142.CanCollide = false;
                        v142.CanQuery = false;
                        v142.CanTouch = false;
                    end;
                end;
                for _, v144 in (v138:GetDescendants()) do
                    if v144:IsA("ParticleEmitter") and v144.Name == "Number" then
                        v144.Color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0, v104.Config.SpikeNumbersColor), 
                            ColorSequenceKeypoint.new(1, v104.Config.SpikeNumbersColor)
                        });
                    end;
                end;
                l_TweenService_0:Create(v138.PrimaryPart, TweenInfo.new(0.1), {
                    CFrame = v138.PrimaryPart.CFrame + Vector3.new(0, l_Y_0, 0)
                }):Play();
                task.delay(v104.Config.SpikeLifetime, function() --[[ Line: 815 ]]
                    -- upvalues: v138 (copy)
                    if v138.Parent and v138.PrimaryPart then
                        game.Debris:AddItem(v138, 1.5);
                    end;
                end);
                v5:Play(v104.Config.Sounds.CorruptEnergySummon, {
                    Parent = v138.PrimaryPart, 
                    PlaybackSpeed = Random.new():NextNumber(0.8, 1.2), 
                    Volume = 0.25, 
                    TimePosition = 0.02
                });
                v104.ActiveSpikeModels[v137.SpikeUUID] = v138;
            end);
            v9:SetConnection(("%*DesummonSpike"):format(v104.Player.Name), "REMOTE_EVENT", function(v145) --[[ Line: 825 ]]
                -- upvalues: v104 (copy), l_TweenService_0 (ref), v5 (ref)
                local v146 = v104.ActiveSpikeModels[v145];
                if not v146 then
                    return;
                else
                    local l_Y_1 = v104.Config.SpikeHitboxSize.Y;
                    l_TweenService_0:Create(v146.PrimaryPart, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                        CFrame = v146.PrimaryPart.CFrame - Vector3.new(0, l_Y_1 * 2, 0)
                    }):Play();
                    v5:Play(v104.Config.Sounds.CorruptEnergyDesummon, {
                        Parent = v146.PrimaryPart, 
                        PlaybackSpeed = Random.new():NextNumber(0.9, 1.1), 
                        Volume = 0.1, 
                        TimePosition = 0.02
                    });
                    game.Debris:AddItem(v146, 1);
                    v104.ActiveSpikeModels[v145] = nil;
                    return;
                end;
            end);
            v9:SetConnection(("%*OnPuddleRevealed"):format(v104.Player.Name), "REMOTE_EVENT", function(v148) --[[ Line: 848 ]]
                -- upvalues: v16 (ref), v104 (copy)
                local l_PlayerSettings_0 = require(game.ReplicatedStorage.Initializer).PlayerSettings;
                if l_PlayerSettings_0.EpilepsyMode and l_PlayerSettings_0.EpilepsyMode.Value then
                    for _, v151 in (v148:GetDescendants()) do
                        if v151:IsA("ParticleEmitter") and v151:GetAttribute("IsEpilepsy") then
                            v151.Enabled = false;
                        end;
                    end;
                    v16("OnPuddleEpilepsy", ("%*/OnPuddleEpilepsy"):format(script.Parent), v104, v148);
                end;
            end);
            if game.Players.LocalPlayer == v104.Player then
                local v152 = v104.Config.SilencedTag or "JaneDoeSilenced";
                v104.Silencers = {};
                local function v156(v153) --[[ Line: 874 ]] --[[ Name: myWife ]]
                    -- upvalues: v104 (copy)
                    local v154 = v153:WaitForChild("Head", 4);
                    if not v154 or not v104 or not v104.SilencedConnection then
                        return;
                    else
                        local v155 = v104.Config.SilencedTemplate:Clone();
                        v155.Parent = v153;
                        v155.Weld.Part0 = v154;
                        table.insert(v104.Silencers, v155);
                        return;
                    end;
                end;
                v104.SilencedConnection = game.CollectionService:GetInstanceAddedSignal(v152):Connect(v156);
                for _, v158 in ipairs(workspace.Players.Survivors:GetChildren()) do
                    if v158:HasTag(v152) then
                        task.spawn(v156, v158);
                    end;
                end;
            end;
        end;
        return;
    end;
end;
v1.Destroyed = function(v159, v160) --[[ Line: 897 ]] --[[ Name: Destroyed ]]
    if v160.JohnDoeRigCameraOffset then v160.JohnDoeRigCameraOffset:Destroy();v160.JohnDoeRigCameraOffset=nil end;
    -- upvalues: v9 (copy)
    for _, v162 in v159.Connections do
        v162:Disconnect();
        v162 = nil;
    end;
    if game["Run Service"]:IsServer() then
        for _, v164 in v160.CurrentSpikes do
            v164:Destroy();
        end;
        return;
    else
        if game["Run Service"]:IsClient() then
            v9:RemoveConnection(("%*JDPuddleEffect"):format(v160.Player.Name), "REMOTE_EVENT");
            v9:RemoveConnection(("%*SpawnSpike"):format(v160.Player.Name), "REMOTE_EVENT");
            v9:RemoveConnection(("%*DesummonSpike"):format(v160.Player.Name), "REMOTE_EVENT");
            if v160.SilencedConnection then
                v160.SilencedConnection:Disconnect();
                local l_ipairs_0 = ipairs;
                local v166 = v160.Silencers or {};
                for _, v168 in l_ipairs_0(v166) do
                    v168:Destroy();
                end;
            end;
        end;
        return;
    end;
end;
v1.OnIntroduction = function(_, v170, v171, v172) --[[ Line: 923 ]] --[[ Name: OnIntroduction ]]
    -- upvalues: v6 (copy)
    local v173 = nil;
    if v170.Config.useClouds == true then
        v173 = Instance.new("Clouds");
        v173.Cover = 0.774;
        v173.Density = 1;
        v173.Color = Color3.fromRGB(25, 25, 25);
        v173.Parent = workspace:FindFirstChild("Terrain");
        game.Debris:AddItem(v173, v172);
    end;
    local v174 = script.IntroScreen:Clone();
    v174.Main.Title.Text = v170.Config.IntroText:gsub("PLAYERNAME", v170.Player.DisplayName);
    v174.Parent = game.Players.LocalPlayer.PlayerGui;
    game.Debris:AddItem(v174, 1.93333);
    game.TweenService:Create(v174.Main.Title, TweenInfo.new(0.83), {
        TextTransparency = 0
    }):Play();
    task.delay(0.83, function() --[[ Line: 948 ]]
        -- upvalues: v174 (copy), v170 (copy)
        game.TweenService:Create(v174.Main.Title, TweenInfo.new(0.583), {
            TextColor3 = v170.Config.IntroTextColor or Color3.new(1, 0, 0)
        }):Play();
    end);
    task.delay(1, function() --[[ Line: 953 ]]
        -- upvalues: v171 (copy)
        local l_JohnDoeTrail_0 = v171:FindFirstChild("JohnDoeTrail");
        if l_JohnDoeTrail_0 then
            l_JohnDoeTrail_0:Destroy();
        end;
    end);
    local v176 = require(game.ReplicatedStorage.Modules.Schematics.Lighting);
    v176:SetCustomLighting(v170.Config.IntroLighting);
    task.delay(2.717, function() --[[ Line: 963 ]]
        -- upvalues: v173 (ref), v170 (copy)
        if v173 then
            v173.Color = Color3.fromRGB(25, 0, 0);
        end;
        local l_AtmosphereDoe_0 = game.Lighting:FindFirstChild("AtmosphereDoe");
        if l_AtmosphereDoe_0 then
            game.TweenService:Create(l_AtmosphereDoe_0, TweenInfo.new(0.2829, Enum.EasingStyle.Linear), {
                Color = v170.Config.AtmosphereColor or Color3.fromRGB(144, 0, 0), 
                Decay = v170.Config.AtmosphereDecay or Color3.fromRGB(255, 0, 0), 
                Density = 1
            }):Play();
        end;
    end);
    local l_v6_FOVMultiplier_1 = v6:CreateFOVMultiplier(game.Players.LocalPlayer, 0.35, "JohnDoeIntroScene");
    task.delay(2.75, function() --[[ Line: 979 ]]
        -- upvalues: l_v6_FOVMultiplier_1 (copy)
        game.TweenService:Create(l_v6_FOVMultiplier_1, TweenInfo.new(0.25), {
            Value = 0.95
        }):Play();
    end);
    task.delay(v172, function() --[[ Line: 984 ]]
        -- upvalues: v176 (copy), l_v6_FOVMultiplier_1 (copy), v174 (copy), v173 (ref)
        v176:SetAsCurrentLighting();
        l_v6_FOVMultiplier_1:Destroy();
        v174:Destroy();
        if v173 then
            v173:Destroy();
        end;
    end);
end;
v1.OnVictory = function(_, v180, v181, _, _) --[[ Line: 994 ]] --[[ Name: OnVictory ]]
    -- upvalues: v6 (copy), l_TweenService_0 (copy)
    local v184 = require(game.ReplicatedStorage.Modules.Schematics.Lighting);
    if v180 == "Start" then
        v184:SetCustomLighting(v181.Config.IntroLighting);
        local l_v6_FOVMultiplier_2 = v6:CreateFOVMultiplier(game.Players.LocalPlayer, 1.1325, "JohnDoeOutroScene");
        game.Debris:AddItem(l_v6_FOVMultiplier_2, 30);
        task.spawn(function() --[[ Line: 1005 ]]
            -- upvalues: v181 (copy), v6 (ref)
            local v186 = os.clock();
            local v187 = workspace.Misc:WaitForChild("KillerCutsceneBackground", 5);
            if v187 and v187.PrimaryPart then
                local v188 = v181.Config.OutroDummy:Clone();
                v188.Name = "OutroVictim";
                v188.PrimaryPart.Anchored = true;
                v188:SetPrimaryPartCFrame(v187.PrimaryPart.CFrame);
                v188.Parent = v187;
                local v189 = v6:LoadAnimationFromID(v188, "rbxassetid://135006397147596", true);
                v189:Play(0);
                v189.TimePosition = os.clock() - v186;
                v189.Stopped:Once(function() --[[ Line: 1020 ]]
                    -- upvalues: v188 (copy)
                    for _, v191 in ipairs(v188:GetDescendants()) do
                        if v191:IsA("BasePart") then
                            v191.Anchored = true;
                        end;
                    end;
                end);
                local v192 = false;
                for _, v194 in ipairs({
                    "Shirt", 
                    "Pants", 
                    "Accessory", 
                    "Hat"
                }) do
                    if v188:FindFirstChildOfClass(v194) then
                        v192 = true;
                        break;
                    end;
                end;
                if not v192 then
                    pcall(function() --[[ Line: 1033 ]]
                        -- upvalues: v181 (ref), v188 (copy)
                        local l_HumanoidDescriptionFromUserId_0 = game.Players:GetHumanoidDescriptionFromUserId(v181.Player.UserId);
                        v188.Humanoid:ApplyDescription(l_HumanoidDescriptionFromUserId_0, Enum.AssetTypeVerification.Always);
                    end);
                end;
            end;
        end);
        task.delay(2.4, function() --[[ Line: 1042 ]]
            -- upvalues: l_TweenService_0 (ref), v181 (copy)
            local v196 = Instance.new("ColorCorrectionEffect", game.Lighting);
            v196.Name = "JohnDoeStabCC";
            local v197 = l_TweenService_0:Create(v196, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
                Contrast = 0.4, 
                Brightness = 0.1
            });
            v197:Play();
            task.wait(0.4);
            v197:Pause();
            v196.Brightness = 0.8;
            v196.Contrast = 0.3;
            v196.TintColor = v181.Config.OutroTintColor or Color3.new(0.631373, 0.0784314, 0.0901961);
            l_TweenService_0:Create(v196, TweenInfo.new(2.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
                TintColor = Color3.new(0.196078, 0.196078, 0.196078), 
                Brightness = -1, 
                Contrast = -0.5, 
                Saturation = -1
            }):Play();
        end);
        return;
    else
        if v180 == "End" then
            v184:SetAsCurrentLighting();
            local l_v6_FOVMultiplier_3 = v6:CreateFOVMultiplier(game.Players.LocalPlayer, 1, "JohnDoeOutroScene");
            game.Debris:AddItem(l_v6_FOVMultiplier_3, 1);
            local v199 = game.Lighting:WaitForChild("JohnDoeStabCC", 8);
            if v199 then
                v199:Destroy();
            end;
        end;
        return;
    end;
end;
v1.OnExecution = function(_, v201, v202) --[[ Line: 1106 ]] --[[ Name: OnExecution ]]
    local l_Humanoid_2 = v202:FindFirstChild("Humanoid");
    local v204 = require(game.ReplicatedStorage.Modules.Ragdolls);
    local v205 = (v201.Rig.PrimaryPart.CFrame.LookVector + Vector3.new(0, 0.5, 0, 0)) * 40;
    local l_Axe_0 = v202:FindFirstChild("Axe");
    local l_BackAxe_0 = v202:FindFirstChild("BackAxe");
    if v202.Name == "JaneDoe" then
        l_Axe_0.Transparency = 0;
        l_BackAxe_0.Transparency = 1;
        task.delay(2.85, function() --[[ Line: 1118 ]]
            -- upvalues: v204 (copy), v202 (copy), v205 (copy), l_Humanoid_2 (copy)
            v204.AddProfile(v202, {
                Velocity = v205, 
                KillEffects = {
                    Explode = true
                }
            });
            if l_Humanoid_2 then
                l_Humanoid_2.BreakJointsOnDeath = true;
                l_Humanoid_2.Health = 0;
            end;
        end);
        return;
    else
        task.delay(0.666, function() --[[ Line: 1128 ]]
            -- upvalues: v204 (copy), v202 (copy), v205 (copy)
            v204.AddProfile(v202, {
                AnchorDelay = true, 
                Applied = os.clock() + 5, 
                Velocity = v205
            });
            local l_Humanoid_3 = v202:FindFirstChild("Humanoid");
            if l_Humanoid_3 then
                l_Humanoid_3.BreakJointsOnDeath = false;
                l_Humanoid_3.Health = 0;
            end;
        end);
        task.delay(1.98, function() --[[ Line: 1137 ]]
            -- upvalues: v202 (copy)
            if v202 and v202.PrimaryPart then
                v202.PrimaryPart.Anchored = false;
            end;
        end);
        return;
    end;
end;
return v1;]==========],
[ [==========[
ServerStorage/Assets/Killers/JohnDoe/Config]==========] ]=[==========[
-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local l_workspace_Attribute_0 = workspace:GetAttribute("JohnDoeSpecialDay");
local v1 = {
    DisplayName = "John Doe", 
    Quote = l_workspace_Attribute_0 and "dude i told you not to play on march 18th" or "DON'T PLAY ROBLOX ON MARCH 18TH?!?!", 
    Credits = "c2o, BakedMesh, koekonaut, 89M and BirdieCandles", 
    RenderImage = l_workspace_Attribute_0 and "rbxassetid://125927083463034" or "rbxassetid://106220250803658", 
    Price = l_workspace_Attribute_0 and 318 or 1000, 
    Health = l_workspace_Attribute_0 and 3182026 or 1500, 
    Speed = l_workspace_Attribute_0 and 11.3182026 or 9, 
    IntroText = "They're all yours, Mr. Doe", 
    SprintSpeed = l_workspace_Attribute_0 and 27.53182026 or 27.25, 
    StaminaLoss = 9.5, 
    StaminaGain = 21, 
    MaxStamina = l_workspace_Attribute_0 and 115.3182026 or 110, 
    SlashDamage = l_workspace_Attribute_0 and 45.3182026 or 28, 
    SlashCooldown = l_workspace_Attribute_0 and 2.3182026 or 1.75, 
    SlashWindup = 0.4, 
    SlashLinger = 0.25, 
    CorruptEnergyDamage = l_workspace_Attribute_0 and 16.3182026 or 12, 
    CorruptEnergyCooldown = l_workspace_Attribute_0 and 40.3182026 or 18, 
    SpikeAmount = l_workspace_Attribute_0 and 256 or 27, 
    SpikeHitboxSize = Vector3.new(11, 5, 5, 0), 
    SpikeLifetime = l_workspace_Attribute_0 and 18.3182026 or 14, 
    SpikeHitCap = l_workspace_Attribute_0 and 3182026 or 4, 
    SpikeProperties = PhysicalProperties.new(0.2, 2, 0, 100, 100), 
    DelayBetweenSpikeSummons = l_workspace_Attribute_0 and 0.02 or 0.054, 
    DistanceBetweenSpikes = 4, 
    DigitalFootprintCooldown = 3, 
    DigitalFootprintLimit = l_workspace_Attribute_0 and 4 or 3, 
    ["404ErrorAuraRevealTime"] = l_workspace_Attribute_0 and 10.3182026 or 6, 
    ["404ErrorCooldown"] = 20, 
    Spike = script.Spike, 
    Shadow = script.Shadow, 
    Trail = script.Trail, 
    SpikeNumbersColor = Color3.fromRGB(255, 0, 0), 
    TrailLength = l_workspace_Attribute_0 and 356 or 48, 
    UnstoppableDuration = 2, 
    SilencedTemplate = script.NAN, 
    Silenced = true, 
    OutroDummy = script.OutroVictim, 
    useClouds = true, 
    Relations = {
        "JaneDoe"
    }, 
    LastManStandingEmotionalData = {
        ThemeID = "rbxassetid://90004798416076", 
        RoundTime = 99
    }, 
    LastManStandingData = {
        ThemeID = "rbxassetid://128206924329556", 
        ThemeProperties = {
            Volume = 1.8
        }, 
        RoundTime = 75
    }, 
    Animations = {
        Idle = "rbxassetid://78316360457839", 
        Walk = "rbxassetid://76406790148345", 
        Run = "rbxassetid://75860288793447", 
        InjuredIdle = "rbxassetid://78316360457839", 
        InjuredWalk = "rbxassetid://76406790148345", 
        InjuredRun = "rbxassetid://75860288793447", 
        Stunned = {
            Start = "rbxassetid://138679230786776", 
            Loop = "rbxassetid://70827891324537", 
            End = "rbxassetid://74361242843808", 
            Cancel = "rbxassetid://132248641730444"
        }, 
        Execution = {
            KillerRig = "rbxassetid://83976183793168", 
            PlayerRig = "rbxassetid://128883910284038", 
            PlayerCFrameOffset = CFrame.Angles(0, 3.141592653589793, 0) * CFrame.new(0, 0, 3)
        }, 
        ExecutionJaneDoe = {
            KillerRig = "rbxassetid://113867319138589", 
            PlayerRig = "rbxassetid://110119432571584"
        }, 
        Slash = "rbxassetid://115517017692371", 
        CorruptEnergy = "rbxassetid://98447162219573", 
        DigitalFootprint = "rbxassetid://105781326773024", 
        Introduction = {
            KillerRig = "rbxassetid://119476049603730", 
            CameraRig = "rbxassetid://140634358360682"
        }, 
        Victory = {
            KillerRig = "rbxassetid://103715079223416", 
            CameraRig = "rbxassetid://98794271647444"
        }
    }, 
    Sounds = {
        Ambience = "rbxassetid://94207556272752", 
        Footsteps = {
            "rbxassetid://126872882914955", 
            "rbxassetid://81544212102472"
        }, 
        TerrorRadiusThemes = {
            [60] = {
                ID = "rbxassetid://83774227185202", 
                BPM = 100
            }, 
            [40] = {
                ID = "rbxassetid://112183456126257", 
                BPM = 100
            }, 
            [20] = {
                ID = "rbxassetid://110494241693405", 
                BPM = 100
            }, 
            [6] = {
                ID = "rbxassetid://90755511989120", 
                BPM = 100, 
                Chase = true
            }
        }, 
        Execution = "rbxassetid://91088178573563", 
        ExecutionJaneDoe = "rbxassetid://91273852978167", 
        StunEnded = "rbxassetid://127453218558340", 
        Swing = "rbxassetid://140242176732868", 
        Hit = "rbxassetid://90819435118493", 
        CorruptEnergy = "rbxassetid://122388551068717", 
        CorruptEnergySummon = "rbxassetid://111388466508150", 
        CorruptEnergyDesummon = "rbxassetid://84267936481619", 
        PuddleStepped = "rbxassetid://128240826870706", 
        DigitalFootprint = "rbxassetid://114243439622992", 
        DigitalFootprintAmbience = "rbxassetid://140163779889034", 
        ["404Error"] = "rbxassetid://117888888155052", 
        ["404ErrorError"] = "rbxassetid://113305896012849", 
        Introduction = "rbxassetid://72636140548768", 
        VictoryTheme = "rbxassetid://122795850954647"
    }
};
v1.Information = {
    {
        Separator = "GENERAL INFO"
    }, 
    {
        Header = "JOHN DOE", 
        Text = "The defunct code of the early days of Roblox courses through their body, consuming his mind as he now only focuses on one thing: to kill everyone in his path. An unstoppable force entering the round with a strategical mindset, he's able to set traps, summon walls to back survivors into a corner, and leave behind a faint trail that damages those who step on it.\n"
    }, 
    {
        Header = "STATS", 
        Text = "Difficulty: \226\152\133\226\152\133\226\152\133\226\152\133\226\152\133\n" .. ("Health: %*\n"):format(v1.Health) .. ("Regular Speed: %*\n"):format(v1.Speed) .. ("Sprinting Speed: %*\n"):format(v1.SprintSpeed) .. ("Max Stamina: %*\n"):format(v1.MaxStamina) .. ("Stamina Loss per sec: %*\n"):format(v1.StaminaLoss) .. ("Stamina Gain per sec: %*\n"):format(v1.StaminaGain) .. "Terror Radius: 60 studs\n"
    }, 
    {
        Separator = "PASSIVES"
    }, 
    {
        Header = "NATURAL MALEVOLENCE", 
        Quote = "\"We\226\128\153re dedicated to building a fun, safe environment where kids of all ages can power their imagination on Roblox.\" - Roblox", 
        Text = "For every step that <font color=\"rgb(248,217,109)\">John Doe</font> takes, a trail of corruption follows behind him.\nAny survivor that's unfortunate enough to step within the corruption is given <b>Corrupted II</b> for 3 seconds.\n"
    }, 
    {
        Header = "UNSTOPPABLE", 
        Quote = "\"Consider this myth busted.\" - Roblox", 
        Text = ("<font color=\"rgb(248,217,109)\">John Doe</font> can only be stunned for %*s while casting Corrupt Energy and 404 Error.\n"):format(v1.UnstoppableDuration) .. "Additionally, <font color=\"rgb(248,217,109)\">John Doe</font> will roar and gain <b>Speed I</b> for 3s upon the stun ending. The duration of the speed boost is increased by 1s for every Sentinel Survivor currently alive.\n" .. "The cooldown of the ability that triggered <b>UNSTOPPABLE</b> is reduced by 50%.\n"
    }, 
    {
        Separator = "ABILITIES"
    }, 
    {
        Header = "SLASH", 
        Image = "rbxassetid://92362553672440", 
        Quote = "\"For many years, there has been lore circulating around John Doe and \226\150\136\226\150\136\226\150\136\226\150\136 Doe within the community.\" - Roblox", 
        Text = ("Cooldown: %*s\n"):format(v1.SlashCooldown) .. ("Damage: %*\n"):format(v1.SlashDamage) .. ("Windup: %*s\n"):format(v1.SlashWindup) .. ("Linger: %*s\n"):format(v1.SlashLinger) .. "Length: 7.5 studs\n" .. "<font color=\"rgb(248,217,109)\">John Doe</font> slashes infront of him using his claws.\n"
    }, 
    {
        Header = "CORRUPT ENERGY", 
        Image = "rbxassetid://83849304758564", 
        Quote = "\"This year, we\226\128\153ve decided that it\226\128\153s time to shed some light about these accounts.\" - Roblox", 
        Text = ("Cooldown: %*s\n"):format(v1.CorruptEnergyCooldown) .. ("Damage: %*\n"):format(v1.CorruptEnergyDamage) .. ("<font color=\"rgb(248,217,109)\">John Doe</font> punches his corrupted arm into the ground and, when he pulls it out, %* giant spikes (that last for %*s) emerge infront of him, piercing through any survivor unfortunate enough to be caught within them.\n"):format(v1.SpikeAmount, v1.SpikeLifetime) .. "Hitting a player with a spike gives <font color=\"rgb(248,217,109)\">John Doe</font> Speed I for 7 seconds.\n" .. ("Summoned spikes cannot damage the same target more than %* times.\n"):format(v1.SpikeHitCap) .. "These spikes can be used as blockades to prevent survivors from accessing certain areas.\n"
    }, 
    {
        Header = "DIGITAL FOOTPRINT", 
        Image = "rbxassetid://83206360003394", 
        Quote = "\"John Doe and \226\150\136\226\150\136\226\150\136\226\150\136 Doe are two of Roblox\226\128\153s earliest accounts, as seen by their low user IDs here.\" - Roblox", 
        Text = ("Cooldown: %*s\n"):format(v1.DigitalFootprintCooldown) .. "<font color=\"rgb(248,217,109)\">John Doe</font> stomps on the ground three times, commanding a shadow to emerge underneath his footsteps as a trap for survivors to walk over.\n" .. "If a survivor steps over the false shadow, then <font color=\"rgb(248,217,109)\">John Doe</font> gets a <b>Speed I</b> buff for 10 seconds and the survivor gets a <b>Corrupted I</b> & <b>Slowness II</b> debuff for 10 seconds.\n" .. "Upon the trap being triggered, <font color=\"rgb(248,217,109)\">John Doe</font> and the survivor who activated it have their auras revealed to each other for 10 seconds.\n" .. "The shadow despawns after contact is made with it or <font color=\"rgb(248,217,109)\">John Doe</font> attempts to place down a fourth shadow.\n" .. ("There can only be <b>%*</b> shadows present at once, and attempting to create more will cause the oldest shadow to dissipate.\n"):format(v1.DigitalFootprintLimit)
    }, 
    {
        Header = "404 ERROR", 
        Image = "rbxassetid://131116145215571", 
        Quote = "\"Authentic John Doe and \226\150\136\226\150\136\226\150\136\226\150\136 Doe accounts pose no danger to your Roblox account.\" - Roblox", 
        Text = ("Cooldown: %*s\n"):format(v1["404ErrorCooldown"]) .. ("<font color=\"rgb(248,217,109)\">John Doe</font>'s corrupted arm pulsates twice, revealing the auras of all living survivors to him for %* seconds.\n"):format(v1["404ErrorAuraRevealTime"])
    }
};
-- Phase-one rig profiles. Current FCT animations and all balance values are retained.
v1.JohnDoeRigCollision=script.JohnDoeRigCollision
v1.JohnDoeRigQuery=script.JohnDoeRigQuery
v1.JohnDoeRigScale=script:GetAttribute("JohnDoeRigScale") or 1.25
v1.JohnDoeRigPhase="1.0.0"
v1.HipHeight=0
return v1;]==========],
[ [==========[
ServerStorage/Assets/Killers/JohnDoe/Behavior]==========] ]=[==========[
-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local _ = require(game.ReplicatedStorage.GlobalTypes);
local v1 = {};
local RigAlignment=require(script.RigAlignment);
v1.GetRig=function(_,actor) return RigAlignment.GetRig(actor) end;
local l_TweenService_0 = game:GetService("TweenService");
local _ = game:GetService("HttpService");
local l_Players_0 = game:GetService("Players");
local v5 = require(game.ReplicatedStorage.Modules.Sounds);
local v6 = require(game.ReplicatedStorage.Modules.Util);
local v7 = require(game.ReplicatedStorage.Modules.Hitboxes);
local v8 = require(game.ReplicatedStorage.Modules.Statuses);
local v9 = require(game.ReplicatedStorage.Modules.Network);
local v10 = require(game.ReplicatedStorage.Modules.AchievementUtil);
local function v16(v11, v12, v13, ...) --[[ Line: 23 ]] --[[ Name: pcallMethod ]]
    local l_status_0, l_result_0 = pcall(function(...) --[[ Line: 24 ]]
        -- upvalues: v13 (copy), v11 (copy)
        if v13.Behavior[v11] then
            return v13.Behavior[v11](v13.Behavior, v13, ...);
        else
            return;
        end;
    end, ...);
    if not l_status_0 then
        warn((("[%*]: Failed to call .%*() due to: %*"):format(v12, v11, l_result_0)));
    end;
    return l_result_0;
end;
v1.Abilities = {
    Slash = {
        LayoutOrder = 1, 
        Icon = "rbxassetid://92362553672440", 
        KeybindType = "MainAbility", 
        Callback = function(v17) --[[ Line: 42 ]] --[[ Name: Callback ]]
            -- upvalues: v5 (copy), v7 (copy), v6 (copy)
            if game["Run Service"]:IsServer() then
                v17.AbilitiesDisabled = true;
                v5:Play(v17.Config.Sounds.Swing, {
                    Parent = v17.Rig.PrimaryPart, 
                    PlaybackSpeed = Random.new():NextNumber(0.975, 1.025), 
                    Volume = 0.35
                });
                task.delay(v17.Config.SlashWindup, function() --[[ Line: 49 ]]
                    -- upvalues: v7 (ref), v17 (copy), v6 (ref), v5 (ref)
                    local _ = v7:CreateHitbox(v17.Player, {
                        Size = Vector3.new(4.5, 6, 7.5, 0), 
                        CFrameOffset = RigAlignment.SlashOffset(v17), 
                        Damage = v17.Config.SlashDamage, 
                        Time = v17.Config.SlashLinger, 
                        Knockback = 2, 
                        HitMultiple = false, 
                        ExecuteOnKill = true, 
                        Connections = {
                            Hit = function(v18, v19) --[[ Line: 61 ]] --[[ Name: Hit ]]
                                -- upvalues: v6 (ref), v5 (ref), v17 (ref)
                                v6:CreateSpeedMultiplier(v18, 1.5, "HitSpeedBonus", 1.25);
                                if v19 then
                                    v5:Play(v17.Config.Sounds.Hit, {
                                        Parent = v17.Rig.PrimaryPart, 
                                        PlaybackSpeed = Random.new():NextNumber(0.975, 1.025), 
                                        Volume = 0.5
                                    });
                                end;
                            end
                        }
                    });
                end);
                task.delay(0.75, function() --[[ Line: 72 ]]
                    -- upvalues: v17 (copy)
                    v17.AbilitiesDisabled = false;
                end);
                return;
            else
                if game["Run Service"]:IsClient() then
                    if v17.Animations.Slash1 then
                        v17.Animations[("Slash%*"):format((tostring(math.random(1, 2))))]:Play(0.025);
                        return;
                    else
                        v17.Animations.Slash:Play(0.025);
                    end;
                end;
                return;
            end;
        end
    }, 
    CorruptEnergy = {
        LayoutOrder = 2, 
        Icon = "rbxassetid://83849304758564", 
        KeybindType = "AltAbility1", 
        Callback = function(v21) --[[ Line: 91 ]] --[[ Name: Callback ]]
            -- upvalues: v16 (copy), v5 (copy), v9 (copy), v7 (copy), v10 (copy), v6 (copy), v8 (copy)
            v16("CorruptEnergyStart", ("%*/CorruptEnergyStart"):format(script.Parent), v21);
            if game["Run Service"]:IsServer() then
                v21.CurrentAbility = "CorruptEnergy";
                v21.AbilitiesDisabled = true;
                v5:Play(v21.Config.Sounds.CorruptEnergy, {
                    Parent = v21.Rig.PrimaryPart, 
                    Volume = 0.4, 
                    TimePosition = 0.09, 
                    PlaybackSpeed = 1.2
                });
                v21.Config.StunDuration = v21.Config.UnstoppableDuration;
                local v22 = RaycastParams.new();
                v22.FilterDescendantsInstances = {
                    workspace.Players
                };
                v22.FilterType = Enum.RaycastFilterType.Exclude;
                local v23 = false;
                local v24 = nil;
                v24 = v21.Rig:GetAttributeChangedSignal("Stunned"):Once(function() --[[ Line: 111 ]]
                    -- upvalues: v23 (ref)
                    v23 = true;
                end);
                local v25 = {};
                task.delay(2, function() --[[ Line: 117 ]]
                    -- upvalues: v21 (copy), v23 (ref), v22 (copy), v9 (ref), v7 (ref), v10 (ref), v6 (ref), v8 (ref), v25 (copy), v5 (ref)
                    for v26 = 1, v21.Config.SpikeAmount do
                        task.delay(v26 * v21.Config.DelayBetweenSpikeSummons, function() --[[ Line: 120 ]]
                            -- upvalues: v23 (ref), v21 (ref), v26 (copy), v22 (ref), v9 (ref), v7 (ref), v10 (ref), v6 (ref), v8 (ref), v25 (ref), v5 (ref)
                            if v23 then
                                return;
                            elseif not v21.Rig.PrimaryPart then
                                return;
                            elseif v21.Rig:GetAttribute("Stunned") then
                                v23 = true;
                                return;
                            else
                                local l_Position_0 = (v21:GetPivot() * CFrame.new(0, 0, -v21.Config.DistanceBetweenSpikes * v26)).Position;
                                local v28 = workspace:Raycast(l_Position_0, Vector3.new(0, -100, 0, 0), v22) or workspace:Raycast(l_Position_0, Vector3.new(0, 100, 0, 0), v22);
                                if v28 and v28.Position then
                                    local l_SpikeHitboxSize_0 = v21.Config.SpikeHitboxSize;
                                    local v30 = {
                                        Position = Vector3int16.new(v28.Position.X, v28.Position.Y, v28.Position.Z), 
                                        Rotation = math.random(0, 360), 
                                        SpikeUUID = v26
                                    };
                                    local l_Part_0 = Instance.new("Part");
                                    l_Part_0.Anchored = true;
                                    l_Part_0.Size = l_SpikeHitboxSize_0;
                                    l_Part_0.CanTouch = false;
                                    l_Part_0.Transparency = 1;
                                    l_Part_0.Name = "SpikeCollision";
                                    local v32 = CFrame.new(v28.Position) * CFrame.Angles(0, math.rad(v30.Rotation), 1.5707963267948966) - Vector3.new(0, l_SpikeHitboxSize_0.Y, 0);
                                    local v33 = v32 + Vector3.new(0, l_SpikeHitboxSize_0.Y * 2, 0);
                                    l_Part_0.CFrame = v32;
                                    l_Part_0.Parent = workspace.Map.Ingame;
                                    task.spawn(function() --[[ Line: 147 ]]
                                        -- upvalues: l_Part_0 (copy), v32 (copy), v33 (copy)
                                        l_Part_0.CFrame = v32:Lerp(v33, 0.5);
                                        task.wait(0.05);
                                        l_Part_0.CFrame = v32:Lerp(v33, 1);
                                        task.wait(0.05);
                                    end);
                                    v9:FireAllClientConnection(("%*SpawnSpike"):format(v21.Player.Name), "REMOTE_EVENT", v30);
                                    task.delay(0.1, function() --[[ Line: 157 ]]
                                        -- upvalues: v21 (ref), l_Part_0 (copy)
                                        table.insert(v21.CurrentSpikes or {}, l_Part_0);
                                    end);
                                    task.delay(v21.Config.SpikeLifetime, function() --[[ Line: 162 ]]
                                        -- upvalues: v9 (ref), v21 (ref), v30 (copy), l_Part_0 (copy)
                                        v9:FireAllClientConnection(("%*DesummonSpike"):format(v21.Player.Name), "REMOTE_EVENT", v30.SpikeUUID);
                                        if l_Part_0.Parent then
                                            local l_Size_0 = l_Part_0.Size;
                                            task.spawn(function() --[[ Line: 168 ]]
                                                -- upvalues: l_Part_0 (ref), l_Size_0 (copy)
                                                local l_Position_1 = l_Part_0.Position;
                                                local v36 = l_Position_1 - Vector3.new(0, l_Size_0.Y * 2, 0);
                                                for v37 = 1, 4 do
                                                    l_Part_0.Position = l_Position_1:Lerp(v36, v37 * 0.25);
                                                    task.wait(0.25);
                                                end;
                                            end);
                                            task.delay(1, function() --[[ Line: 178 ]]
                                                -- upvalues: v21 (ref), l_Part_0 (ref)
                                                local v38 = table.find(v21.CurrentSpikes or {}, l_Part_0);
                                                if v38 then
                                                    table.remove(v21.CurrentSpikes or {}, v38);
                                                end;
                                                l_Part_0:Destroy();
                                            end);
                                        end;
                                    end);
                                    local _ = v7:CreateHitbox(v21.Player, {
                                        Size = l_SpikeHitboxSize_0, 
                                        CFrame = function() --[[ Line: 191 ]] --[[ Name: CFrame ]]
                                            -- upvalues: l_Part_0 (copy)
                                            return l_Part_0.CFrame;
                                        end, 
                                        Damage = v21.Config.CorruptEnergyDamage, 
                                        Time = 0.15, 
                                        Knockback = 5, 
                                        HitMultiple = true, 
                                        PredictVelocity = false, 
                                        Connections = {
                                            Hit = function(v39, v40) --[[ Line: 200 ]] --[[ Name: Hit ]]
                                                -- upvalues: v10 (ref), v21 (ref), v6 (ref), v8 (ref), v25 (ref), v5 (ref)
                                                if v39.Humanoid.Health <= 0 then
                                                    v10:IncrementAchievementProgress(v21.Player, "JohnDoeSpikes");
                                                    if tostring(v39.Parent) == "Survivors" then
                                                        require(game.ReplicatedStorage.Modules.Actors):IncrementActorStats(v21.Player, {
                                                            Action = "Killed a Survivor with Corrupt Energy", 
                                                            RewardType = "DifficultKillerAction"
                                                        });
                                                    end;
                                                else
                                                    v6:CreateSpeedMultiplier(v39, 1.5, "HitSpeedBonus", 1.25);
                                                    v8:ApplyStatus(v21.Rig, "Speed", {
                                                        Duration = 7, 
                                                        Level = 1
                                                    });
                                                    v6:RevealPlayerAuraTo(v21.Player, v39, 2.5);
                                                    if not v25[v39] then
                                                        v25[v39] = 1;
                                                    else
                                                        local l_v25_0 = v25;
                                                        l_v25_0[v39] = l_v25_0[v39] + 1;
                                                        if v25[v39] >= v21.Config.SpikeHitCap then
                                                            v6:GiveInvincible(v39, "SpikeLimit", 1);
                                                        end;
                                                    end;
                                                    if tostring(v39.Parent) == "Survivors" then
                                                        require(game.ReplicatedStorage.Modules.Actors):IncrementActorStats(v21.Player, {
                                                            Action = "Damaged a Survivor with Corrupt Energy", 
                                                            RewardType = "EasyKillerAction"
                                                        });
                                                    end;
                                                end;
                                                if v40 then
                                                    v5:Play(v21.Config.Sounds.Hit, {
                                                        Parent = v21.Rig.PrimaryPart, 
                                                        PlaybackSpeed = Random.new():NextNumber(0.975, 1.025), 
                                                        Volume = 0.25
                                                    });
                                                end;
                                            end
                                        }
                                    });
                                end;
                                return;
                            end;
                        end);
                    end;
                    task.wait(v21.Config.SpikeAmount * v21.Config.DelayBetweenSpikeSummons);
                    v21.Config.StunDuration = nil;
                end);
                task.delay(3.5, function() --[[ Line: 258 ]]
                    -- upvalues: v24 (ref), v21 (copy)
                    pcall(function() --[[ Line: 259 ]]
                        -- upvalues: v24 (ref)
                        v24:Disconnect();
                    end);
                    v21.CurrentAbility = nil;
                    v21.AbilitiesDisabled = false;
                end);
                return;
            else
                if game["Run Service"]:IsClient() then
                    v21.Animations.CorruptEnergy:Play(0.025);
                    local v43 = false;
                    local l_v6_SpeedMultiplier_0 = v6:CreateSpeedMultiplier(v21.Player, 0.001, "CorruptEnergy");
                    game.Debris:AddItem(l_v6_SpeedMultiplier_0, 3.5);
                    local v45 = nil;
                    do
                        local l_v43_0 = v43;
                        v45 = v21.Rig:GetAttributeChangedSignal("Stunned"):Once(function() --[[ Line: 274 ]]
                            -- upvalues: l_v6_SpeedMultiplier_0 (copy), v21 (copy), l_v43_0 (ref)
                            l_v6_SpeedMultiplier_0:Destroy();
                            v21.Animations.CorruptEnergy:Stop();
                            l_v43_0 = true;
                        end);
                        task.delay(3.6, v45.Disconnect, v45);
                        local v47 = {
                            1.067, 
                            1.917
                        };
                        local v48 = 0;
                        local v49 = 0;
                        task.spawn(function() --[[ Line: 287 ]]
                            -- upvalues: v21 (copy), v47 (copy), l_v43_0 (ref), v49 (ref), v48 (ref), v6 (ref)
                            while v21 and v21.Rig.Parent and v47[1] and not l_v43_0 do
                                v49 = v49 + game["Run Service"].Heartbeat:Wait();
                                for v50 = #v47, 1, -1 do
                                    if v47[v50] and v49 >= v47[v50] then
                                        table.remove(v47, v50);
                                        v48 = v48 + 1;
                                        v6:ApplyCameraShake(v48 * 0.2, v48 * 0.35);
                                    end;
                                end;
                            end;
                        end);
                    end;
                end;
                return;
            end;
        end
    }, 
    DigitalFootprint = {
        LayoutOrder = 3, 
        Icon = "rbxassetid://83206360003394", 
        KeybindType = "AltAbility2", 
        Callback = function(v51, v52) --[[ Line: 311 ]] --[[ Name: Callback ]]
            -- upvalues: v5 (copy), v16 (copy), v6 (copy), v8 (copy), v9 (copy), l_Players_0 (copy)
            local v53 = {
                0.317, 
                1.05, 
                2.067
            };
            local v54 = 0;
            local v55 = 0;
            if game["Run Service"]:IsServer() then
                v51.AbilitiesDisabled = true;
                v5:Play(v51.Config.Sounds.DigitalFootprint, {
                    Parent = v51.Rig.PrimaryPart, 
                    Volume = 0.4, 
                    TimePosition = 0.09, 
                    PlaybackSpeed = 1.2
                });
                v16("DFStart", ("%*/DFS"):format(script.Parent), v51);
                local function v60(v56) --[[ Line: 323 ]] --[[ Name: removeShadow ]]
                    -- upvalues: v6 (ref), v51 (copy)
                    if v56 and v56.Parent then
                        v56.Name = "okByeBye";
                        v56.Parent = workspace.Map.Ingame;
                        game.Debris:AddItem(v56, 5);
                        local l_ShadowAmbience_0 = v56:FindFirstChild("ShadowAmbience");
                        if l_ShadowAmbience_0 then
                            game.TweenService:Create(l_ShadowAmbience_0, TweenInfo.new(2), {
                                Volume = 0
                            }):Play();
                        end;
                        for _, v59 in pairs(v56:GetDescendants()) do
                            if v59:IsA("ParticleEmitter") then
                                v59.Enabled = false;
                            end;
                        end;
                        v6:RemovePlayerAuraFrom(v56, v51.Player);
                    end;
                end;
                local l_FirstChild_0 = workspace.Map.Ingame:FindFirstChild((("%*Shadows"):format((tostring(v51.Player)))));
                if not l_FirstChild_0 then
                    l_FirstChild_0 = Instance.new("Folder");
                    l_FirstChild_0.Name = ("%*Shadows"):format((tostring(v51.Player)));
                    l_FirstChild_0.Parent = workspace.Map.Ingame;
                end;
                local l_l_FirstChild_0_Children_0 = l_FirstChild_0:GetChildren();
                if #l_l_FirstChild_0_Children_0 >= v51.Config.DigitalFootprintLimit then
                    v60(l_l_FirstChild_0_Children_0[1]);
                end;
                local v63 = v51.Config.Shadow:Clone();
                v63.Size = Vector3.new(1, 0, 0, 0);
                v63.Parent = l_FirstChild_0;
                v5:Play(v51.Config.Sounds.DigitalFootprintAmbience, {
                    Parent = v63, 
                    Name = "ShadowAmbience", 
                    RollOffMaxDistance = 30, 
                    Looped = true
                });
                local v64 = RaycastParams.new();
                v64.FilterDescendantsInstances = {
                    workspace.Players, 
                    v63
                };
                v64.FilterType = Enum.RaycastFilterType.Exclude;
                task.delay(tonumber(v53[#v53]) or 2.55, function() --[[ Line: 380 ]]
                    -- upvalues: v6 (ref), v63 (copy), v51 (copy), v60 (copy), v8 (ref), v9 (ref), l_Players_0 (ref)
                    v6:ApplyUnsafeTouched(v63, false, function(_, v66) --[[ Line: 381 ]]
                        -- upvalues: v6 (ref), v51 (ref), v63 (ref), v60 (ref), v8 (ref), v9 (ref), l_Players_0 (ref)
                        local l_Parent_0 = v66.Parent;
                        local v68 = l_Parent_0 and l_Parent_0:FindFirstChild("Humanoid");
                        if v68 and v6:GetEntityType(l_Parent_0) and l_Parent_0 ~= v51.Rig and v68 and v68.Health > 0 and v63.Name == "Shadow" and not l_Parent_0:GetAttribute("ExecutionsDisabled") then
                            v60(v63);
                            v6:RevealPlayerAuraTo(v51.Rig, l_Parent_0, 10);
                            v6:RevealPlayerAuraTo(l_Parent_0, v51.Rig, 10);
                            v8:ApplyStatus(v51.Rig, "Speed", {
                                Level = 1, 
                                Duration = 10
                            });
                            v8:ApplyStatus(l_Parent_0, "Slowness", {
                                Level = 2, 
                                Duration = 10
                            });
                            v8:ApplyStatus(l_Parent_0, "Corrupted", {
                                Level = 1, 
                                Duration = 10, 
                                Killer = v51
                            });
                            if not v51.FootprintRewardDebounce[l_Parent_0] then
                                v51.FootprintRewardDebounce[l_Parent_0] = true;
                                require(game.ReplicatedStorage.Modules.Actors):IncrementActorStats(v51.Player, {
                                    Action = "Survivor stepped into a Digital Footprint trap", 
                                    RewardType = "RegularKillerAction"
                                });
                                task.delay(15, function() --[[ Line: 408 ]]
                                    -- upvalues: v51 (ref), l_Parent_0 (copy)
                                    v51.FootprintRewardDebounce[l_Parent_0] = nil;
                                end);
                            end;
                            v9:FireClientConnection(l_Players_0:GetPlayerFromCharacter(l_Parent_0), ("%*JDPuddleEffect"):format(v51.Player.Name), "REMOTE_EVENT");
                        end;
                    end, 14);
                end);
                task.spawn(function() --[[ Line: 419 ]]
                    -- upvalues: v54 (ref), v63 (copy), v55 (ref), v53 (copy), v51 (copy), v64 (copy), v16 (ref), v9 (ref)
                    while v54 ~= 3 and v63.Parent and v63.Name == "Shadow" do
                        v55 = v55 + game["Run Service"].Heartbeat:Wait();
                        for v69 = #v53, 1, -1 do
                            if v53[v69] and v55 >= v53[v69] then
                                table.remove(v53, v69);
                                v54 = v54 + 1;
                                local l_Position_2 = (v51.Rig.PrimaryPart.CFrame * CFrame.new(-1.1, 0, -2)).Position;
                                local v71 = workspace:Raycast(l_Position_2, Vector3.new(0, -100, 0, 0), v64);
                                v63.Position = (v71 and v71.Position or v51.Rig.PrimaryPart.Position - Vector3.new(0, 2.5, 0, 0)) + Vector3.new(0, 0.5, 0, 0);
                                game.TweenService:Create(v63, TweenInfo.new(1), {
                                    Size = Vector3.new(1, v54 * 6, v54 * 6)
                                }):Play();
                                v16("OnStomp", ("%*/OnStomp"):format(script.Parent), v51, v63, v54);
                                if v54 == 3 then
                                    v9:FireAllClientConnection(("%*OnPuddleRevealed"):format(v51.Player.Name), "REMOTE_EVENT", v63);
                                end;
                            end;
                        end;
                    end;
                end);
                task.delay(3, function() --[[ Line: 446 ]]
                    -- upvalues: v51 (copy)
                    v51.AbilitiesDisabled = false;
                end);
                return v63;
            else
                if game["Run Service"]:IsClient() then
                    v51.Animations.DigitalFootprint:Play(0.025);
                    local l_Connections_0 = v51.Behavior.Connections;
                    if not l_Connections_0.onShadowFolderAdded or not l_Connections_0.onShadowFolderRemoved then
                        local l_FirstChild_1 = workspace.Map.Ingame:FindFirstChild((("%*Shadows"):format((tostring(v51.Player)))));
                        if not l_FirstChild_1 then
                            return;
                        else
                            local l_AbilityContainer_0 = v51.Player.PlayerGui.MainUI:FindFirstChild("AbilityContainer");
                            local v75 = l_AbilityContainer_0 and l_AbilityContainer_0:FindFirstChild("DigitalFootprint");
                            local v76 = 1;
                            do
                                local l_v76_0 = v76;
                                local function v80(v78) --[[ Line: 465 ]] --[[ Name: onShadowChange ]]
                                    -- upvalues: v75 (copy), l_v76_0 (ref), v51 (copy)
                                    if not v75 then
                                        return;
                                    else
                                        l_v76_0 = math.max(0, l_v76_0 + v78);
                                        v75.Charges.Text = l_v76_0 == 0 and "" or l_v76_0;
                                        local v79 = l_v76_0 >= v51.Config.DigitalFootprintLimit;
                                        v75.Charges.TextColor3 = v79 and Color3.new(1, 0, 0) or Color3.new(1, 1, 1);
                                        return;
                                    end;
                                end;
                                v51.Behavior.Connections.onShadowFolderAdded = l_FirstChild_1.ChildAdded:Connect(function(v81) --[[ Line: 477 ]]
                                    -- upvalues: v80 (copy)
                                    if not v81:IsA("BasePart") then
                                        return;
                                    else
                                        v80(1);
                                        return;
                                    end;
                                end);
                                v51.Behavior.Connections.onShadowFolderRemoved = l_FirstChild_1.ChildRemoved:Connect(function(v82) --[[ Line: 485 ]]
                                    -- upvalues: v80 (copy)
                                    if not v82:IsA("BasePart") then
                                        return;
                                    else
                                        v80(-1);
                                        return;
                                    end;
                                end);
                                v80(0);
                            end;
                        end;
                    end;
                    local l_v6_SpeedMultiplier_1 = v6:CreateSpeedMultiplier(v51.Player, 0, "DigitalFootprint");
                    game.Debris:AddItem(l_v6_SpeedMultiplier_1, 3);
                    task.spawn(function() --[[ Line: 501 ]]
                        -- upvalues: v51 (copy), v53 (copy), v55 (ref), v54 (ref), v6 (ref)
                        while v51 and v51.Rig.Parent and v53[1] do
                            v55 = v55 + game["Run Service"].Heartbeat:Wait();
                            for v84 = #v53, 1, -1 do
                                if v53[v84] and v55 >= v53[v84] then
                                    table.remove(v53, v84);
                                    v54 = v54 + 1;
                                    v6:ApplyCameraShake(v54 * 0.2, v54 * 0.375);
                                end;
                            end;
                        end;
                    end);
                    task.delay(3, function() --[[ Line: 517 ]]
                        -- upvalues: v52 (copy), v6 (ref)
                        if not v52 or not v52.Parent then
                            return;
                        else
                            v52.Transparency = 0;
                            v6:RevealPlayerAura(v52, "inf", Color3.new(1, 0.321569, 0.333333), nil, {
                                OutlineTransparency = 0.35, 
                                FillTransparency = 1
                            });
                            return;
                        end;
                    end);
                end;
                return;
            end;
        end
    }, 
    ["404Error"] = {
        Name = "404 Error", 
        LayoutOrder = 4, 
        Icon = "rbxassetid://131116145215571", 
        KeybindType = "AltAbility3", 
        Callback = function(v85) --[[ Line: 537 ]] --[[ Name: Callback ]]
            -- upvalues: v16 (copy), v5 (copy), v6 (copy), v9 (copy)
            v16("ErrorStart", ("%*/404S"):format(script.Parent), v85);
            if game["Run Service"]:IsServer() then
                v85.CurrentAbility = "404Error";
                v85.Config.StunDuration = v85.Config.UnstoppableDuration;
                v85.AbilitiesDisabled = true;
                v5:Play(v85.Config.Sounds["404Error"], {
                    Parent = v85.Rig.PrimaryPart, 
                    Volume = 0.4, 
                    TimePosition = 0.09, 
                    RollOffMaxDistance = 200, 
                    PlaybackSpeed = 1.15
                });
                task.delay(1.625, function() --[[ Line: 550 ]]
                    -- upvalues: v85 (copy)
                    v85.Config.StunDuration = nil;
                    v85.CurrentAbility = nil;
                    v85.AbilitiesDisabled = false;
                end);
                return;
            else
                if game["Run Service"]:IsClient() then
                    local l_v6_SpeedMultiplier_2 = v6:CreateSpeedMultiplier(v85.Player, 1, "404Error");
                    local l_v6_FOVMultiplier_0 = v6:CreateFOVMultiplier(v85.Player, 1, "404Error");
                    game.TweenService:Create(l_v6_SpeedMultiplier_2, TweenInfo.new(0.5), {
                        Value = 0.25
                    }):Play();
                    game.TweenService:Create(l_v6_FOVMultiplier_0, TweenInfo.new(1.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, true), {
                        Value = 0.75
                    }):Play();
                    v9:FireConnection("DisableSprinting", "404Error", true);
                    task.delay(1.2, function() --[[ Line: 567 ]]
                        -- upvalues: v5 (ref), v85 (copy), v9 (ref), l_v6_SpeedMultiplier_2 (copy), l_v6_FOVMultiplier_0 (copy), v6 (ref)
                        v5:Play(v85.Config.Sounds["404ErrorError"], {
                            Parent = v85.Rig.PrimaryPart, 
                            Volume = 0.4, 
                            TimePosition = 0.09, 
                            PlaybackSpeed = Random.new():NextNumber(0.9, 1.1)
                        });
                        v9:FireConnection("DisableSprinting", "404Error", false);
                        game.TweenService:Create(l_v6_SpeedMultiplier_2, TweenInfo.new(0.6), {
                            Value = 1
                        }):Play();
                        game.TweenService:Create(l_v6_FOVMultiplier_0, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                            Value = 1
                        }):Play();
                        game.Debris:AddItem(l_v6_SpeedMultiplier_2, 0.4);
                        game.Debris:AddItem(l_v6_FOVMultiplier_0, 1);
                        for _, v89 in pairs(workspace.Players.Survivors:GetChildren()) do
                            v6:RevealPlayerAura(v89, v85.Config["404ErrorAuraRevealTime"]);
                        end;
                    end);
                end;
                return;
            end;
        end
    }
};
v1.ErrorStart = function(_, _) --[[ Line: 591 ]] --[[ Name: ErrorStart ]]

end;
v1.CorruptEnergyStart = function(_, _) --[[ Line: 595 ]] --[[ Name: CorruptEnergyStart ]]

end;
v1.OnPuddleEpilepsy = function(_, _, _) --[[ Line: 599 ]] --[[ Name: OnPuddleEpilepsy ]]

end;
v1.OnStomp = function(_, _, v99, v100) --[[ Line: 603 ]] --[[ Name: OnStomp ]]
    for _, v102 in pairs(v99:GetDescendants()) do
        if v102:IsA("ParticleEmitter") and v102.Name:find("ShadowPuddle") then
            v102.Enabled = v102.Name == ("ShadowPuddle%*"):format(v100);
        end;
    end;
end;
v1.Created = function(v103, v104) --[[ Line: 611 ]] --[[ Name: Created ]]
    -- upvalues: v10 (copy), v6 (copy), v8 (copy), l_Players_0 (copy), v9 (copy), v5 (copy), l_TweenService_0 (copy), v16 (copy)
    v103.Connections = {};
    if game["Run Service"]:IsServer() then
        if workspace:GetAttribute("JohnDoeSpecialDay") then
            v10:IncrementAchievementProgress(v104.Player, "JohnDoeSpecialDay");
        end;
        local l_Folder_0 = Instance.new("Folder");
        l_Folder_0.Name = "JohnDoeTrail";
        l_Folder_0.Parent = v104.Rig;
        for _ = 1, math.clamp(math.round(v104.Config.TrailLength / 4), 2, 1e999) do
            local v107 = v104.Config.Trail:Clone();
            v107.Position = RigAlignment.TrailPoint(v104,true);
            v107.Parent = l_Folder_0;
            v107:SetAttribute("FinishedUpdating", true);
            v6:ApplyOnTouched(v107, false, function(_, v109) --[[ Line: 635 ]]
                -- upvalues: v8 (ref), v104 (copy)
                local l_Parent_1 = v109.Parent;
                local l_Humanoid_0 = l_Parent_1:FindFirstChild("Humanoid");
                if l_Humanoid_0 and l_Humanoid_0.Health > 0 and l_Parent_1:IsDescendantOf(workspace.Players) and tostring(l_Parent_1.Parent) ~= "Killers" then
                    v8:ApplyStatus(l_Parent_1, "Corrupted", {
                        Duration = 3, 
                        Level = 2, 
                        Killer = v104
                    });
                end;
            end);
        end;
        v104.CurrentSpikes = {};
        v104.FootprintRewardDebounce = {};
        local v112 = false;
        v104.Rig:GetAttributeChangedSignal("Stunned"):Connect(function() --[[ Line: 648 ]]
            -- upvalues: v104 (copy), v112 (ref)
            if v104.Rig:GetAttribute("Stunned") and v104.Config.StunDuration and v104.CurrentAbility and not v112 then
                v112 = true;
                local l_CurrentAbility_0 = v104.CurrentAbility;
                local v114 = v104.Config[l_CurrentAbility_0 .. "Cooldown"];
                if v114 then
                    v104:SetCooldownOf(l_CurrentAbility_0, (math.max(v114 * 0.5, 0)));
                end;
                task.delay(1, function() --[[ Line: 657 ]]
                    -- upvalues: v112 (ref)
                    v112 = false;
                end);
            end;
        end);
        local l_l_Folder_0_Children_0 = l_Folder_0:GetChildren();
        local v116 = 0;
        local v117 = 0;
        local v118 = 0;
        local v119 = nil;
        v119 = game["Run Service"].Heartbeat:Connect(function(v120) --[[ Line: 670 ]]
            -- upvalues: v104 (copy), l_Folder_0 (copy), v119 (ref), v118 (ref), l_Players_0 (ref), v8 (ref), v117 (ref), l_l_Folder_0_Children_0 (copy), v116 (ref)
            if not v104 or not v104.Rig.Parent or not v104.Rig.PrimaryPart then
                l_Folder_0:Destroy();
                v119:Disconnect();
                v119 = nil;
                return;
            else
                if v118 > 1 and #v104.CurrentSpikes > 0 then
                    v118 = 0;
                    local v121 = RaycastParams.new();
                    v121.FilterDescendantsInstances = v104.CurrentSpikes;
                    v121.FilterType = Enum.RaycastFilterType.Include;
                    for _, v123 in (l_Players_0:GetPlayers()) do
                        local l_Character_0 = v123.Character;
                        if l_Character_0 and l_Character_0.Parent then
                            if not l_Character_0 or not l_Character_0.Parent or l_Character_0.Parent.Name == "Killers" then

                            end;
                            local l_Humanoid_1 = l_Character_0:FindFirstChildOfClass("Humanoid");
                            if l_Humanoid_1 or l_Humanoid_1.Health <= 0 then
                                local l_PrimaryPart_0 = l_Character_0.PrimaryPart;
                                local v127 = workspace:Raycast(l_PrimaryPart_0.Position, Vector3.new(0, -5, 0, 0), v121);
                                local v128 = v127 and v127.Instance;
                                if v127 and v128 then
                                    local v129 = v128.Position.Y + v128.Size.Y / 2;
                                    local v130 = RaycastParams.new();
                                    v130.FilterDescendantsInstances = {
                                        l_Character_0, 
                                        v104.CurrentSpikes
                                    };
                                    v130.FilterType = Enum.RaycastFilterType.Exclude;
                                    local v131 = workspace:Raycast(l_PrimaryPart_0.Position, Vector3.new(0, -10, 0, 0), v130);
                                    if v131 then
                                        if v129 - v131.Position.Y >= 1.5 then
                                            v8:ApplyStatus(v123, "Corrupted", {
                                                Level = 2, 
                                                Duration = 5, 
                                                Killer = v104
                                            });
                                        end;
                                    else
                                        v8:ApplyStatus(v123, "Corrupted", {
                                            Level = 2, 
                                            Duration = 5, 
                                            Killer = v104
                                        });
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;
                v118 = v118 + v120;
                if v117 <= 0.05 then
                    v117 = v117 + v120;
                    return;
                else
                    v117 = 0;
                    local v132 = l_l_Folder_0_Children_0[v116 % #l_l_Folder_0_Children_0 + 1];
                    local v133 = l_l_Folder_0_Children_0[(v116 - 1) % #l_l_Folder_0_Children_0 + 1];
                    if v132 and v133 then
                        if v132.Size.Z <= 4 or v132:GetAttribute("FinishedUpdating") then
                            if v132:GetAttribute("FinishedUpdating") then
                                v132:SetAttribute("FinishedUpdating", nil);
                            end;
                            local v134 = RigAlignment.TrailPoint(v104,false);
                            local l_Position_3 = v133:GetPivot().Position;
                            local l_Rotation_0 = CFrame.lookAt(l_Position_3, v134).Rotation;
                            if l_Rotation_0 ~= l_Rotation_0 then
                                warn("currentTrailRotation is NaN, setting rotation to root rotation as fallback");
                                l_Rotation_0 = v104.Rig.PrimaryPart.CFrame.Rotation;
                            end;
                            v132.CFrame = CFrame.new(v133:GetPivot().Position) * l_Rotation_0 * CFrame.Angles(0, 0, 0);
                            v132.Size = Vector3.new(v132.Size.X, v132.Size.Y, (v132.Position - v134).Magnitude);
                            v132.PivotOffset = CFrame.new(0, 0, -v132.Size.Z / 2);
                            v132.CFrame = v132.CFrame * v132.PivotOffset;
                            return;
                        else
                            v132:SetAttribute("FinishedUpdating", true);
                            v116 = v116 + 1;
                            return;
                        end;
                    else
                        v116 = v116 + 1;
                        return;
                    end;
                end;
            end;
        end);
        return;
    else
        if game["Run Service"]:IsClient() then
            v104.ActiveSpikeModels = {};
            if game.Players.LocalPlayer==v104.Player and RigAlignment.IsUpdated(v104.Rig) then
                v104.JohnDoeRigCameraOffset=v6:CreateCameraOffset(v104.Rig,Vector3.new(0,.25,0),"JohnDoeDefault");
            end;
            v9:SetConnection(("%*JDPuddleEffect"):format(v104.Player.Name), "REMOTE_EVENT", function() --[[ Line: 776 ]]
                -- upvalues: v5 (ref), v104 (copy)
                v5:Play(v104.Config.Sounds.PuddleStepped);
            end);
            v9:SetConnection(("%*SpawnSpike"):format(v104.Player.Name), "REMOTE_EVENT", function(v137) --[[ Line: 780 ]]
                -- upvalues: v104 (copy), l_TweenService_0 (ref), v5 (ref)
                local v138 = v104.Config.Spike:Clone();
                local l_Y_0 = v104.Config.SpikeHitboxSize.Y;
                local v140 = Vector3.new(v137.Position.X, v137.Position.Y, v137.Position.Z);
                v138:PivotTo(CFrame.new(v140) * CFrame.Angles(3.141592653589793, math.rad(v137.Rotation), 0) - Vector3.new(0, l_Y_0, 0));
                v138.Parent = workspace.Map.Ingame;
                for _, v142 in (v138:GetDescendants()) do
                    if v142:IsA("BasePart") then
                        v142.CanCollide = false;
                        v142.CanQuery = false;
                        v142.CanTouch = false;
                    end;
                end;
                for _, v144 in (v138:GetDescendants()) do
                    if v144:IsA("ParticleEmitter") and v144.Name == "Number" then
                        v144.Color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0, v104.Config.SpikeNumbersColor), 
                            ColorSequenceKeypoint.new(1, v104.Config.SpikeNumbersColor)
                        });
                    end;
                end;
                l_TweenService_0:Create(v138.PrimaryPart, TweenInfo.new(0.1), {
                    CFrame = v138.PrimaryPart.CFrame + Vector3.new(0, l_Y_0, 0)
                }):Play();
                task.delay(v104.Config.SpikeLifetime, function() --[[ Line: 815 ]]
                    -- upvalues: v138 (copy)
                    if v138.Parent and v138.PrimaryPart then
                        game.Debris:AddItem(v138, 1.5);
                    end;
                end);
                v5:Play(v104.Config.Sounds.CorruptEnergySummon, {
                    Parent = v138.PrimaryPart, 
                    PlaybackSpeed = Random.new():NextNumber(0.8, 1.2), 
                    Volume = 0.25, 
                    TimePosition = 0.02
                });
                v104.ActiveSpikeModels[v137.SpikeUUID] = v138;
            end);
            v9:SetConnection(("%*DesummonSpike"):format(v104.Player.Name), "REMOTE_EVENT", function(v145) --[[ Line: 825 ]]
                -- upvalues: v104 (copy), l_TweenService_0 (ref), v5 (ref)
                local v146 = v104.ActiveSpikeModels[v145];
                if not v146 then
                    return;
                else
                    local l_Y_1 = v104.Config.SpikeHitboxSize.Y;
                    l_TweenService_0:Create(v146.PrimaryPart, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                        CFrame = v146.PrimaryPart.CFrame - Vector3.new(0, l_Y_1 * 2, 0)
                    }):Play();
                    v5:Play(v104.Config.Sounds.CorruptEnergyDesummon, {
                        Parent = v146.PrimaryPart, 
                        PlaybackSpeed = Random.new():NextNumber(0.9, 1.1), 
                        Volume = 0.1, 
                        TimePosition = 0.02
                    });
                    game.Debris:AddItem(v146, 1);
                    v104.ActiveSpikeModels[v145] = nil;
                    return;
                end;
            end);
            v9:SetConnection(("%*OnPuddleRevealed"):format(v104.Player.Name), "REMOTE_EVENT", function(v148) --[[ Line: 848 ]]
                -- upvalues: v16 (ref), v104 (copy)
                local l_PlayerSettings_0 = require(game.ReplicatedStorage.Initializer).PlayerSettings;
                if l_PlayerSettings_0.EpilepsyMode and l_PlayerSettings_0.EpilepsyMode.Value then
                    for _, v151 in (v148:GetDescendants()) do
                        if v151:IsA("ParticleEmitter") and v151:GetAttribute("IsEpilepsy") then
                            v151.Enabled = false;
                        end;
                    end;
                    v16("OnPuddleEpilepsy", ("%*/OnPuddleEpilepsy"):format(script.Parent), v104, v148);
                end;
            end);
            if game.Players.LocalPlayer == v104.Player then
                local v152 = v104.Config.SilencedTag or "JaneDoeSilenced";
                v104.Silencers = {};
                local function v156(v153) --[[ Line: 874 ]] --[[ Name: myWife ]]
                    -- upvalues: v104 (copy)
                    local v154 = v153:WaitForChild("Head", 4);
                    if not v154 or not v104 or not v104.SilencedConnection then
                        return;
                    else
                        local v155 = v104.Config.SilencedTemplate:Clone();
                        v155.Parent = v153;
                        v155.Weld.Part0 = v154;
                        table.insert(v104.Silencers, v155);
                        return;
                    end;
                end;
                v104.SilencedConnection = game.CollectionService:GetInstanceAddedSignal(v152):Connect(v156);
                for _, v158 in ipairs(workspace.Players.Survivors:GetChildren()) do
                    if v158:HasTag(v152) then
                        task.spawn(v156, v158);
                    end;
                end;
            end;
        end;
        return;
    end;
end;
v1.Destroyed = function(v159, v160) --[[ Line: 897 ]] --[[ Name: Destroyed ]]
    if v160.JohnDoeRigCameraOffset then v160.JohnDoeRigCameraOffset:Destroy();v160.JohnDoeRigCameraOffset=nil end;
    -- upvalues: v9 (copy)
    for _, v162 in v159.Connections do
        v162:Disconnect();
        v162 = nil;
    end;
    if game["Run Service"]:IsServer() then
        for _, v164 in v160.CurrentSpikes do
            v164:Destroy();
        end;
        return;
    else
        if game["Run Service"]:IsClient() then
            v9:RemoveConnection(("%*JDPuddleEffect"):format(v160.Player.Name), "REMOTE_EVENT");
            v9:RemoveConnection(("%*SpawnSpike"):format(v160.Player.Name), "REMOTE_EVENT");
            v9:RemoveConnection(("%*DesummonSpike"):format(v160.Player.Name), "REMOTE_EVENT");
            if v160.SilencedConnection then
                v160.SilencedConnection:Disconnect();
                local l_ipairs_0 = ipairs;
                local v166 = v160.Silencers or {};
                for _, v168 in l_ipairs_0(v166) do
                    v168:Destroy();
                end;
            end;
        end;
        return;
    end;
end;
v1.OnIntroduction = function(_, v170, v171, v172) --[[ Line: 923 ]] --[[ Name: OnIntroduction ]]
    -- upvalues: v6 (copy)
    local v173 = nil;
    if v170.Config.useClouds == true then
        v173 = Instance.new("Clouds");
        v173.Cover = 0.774;
        v173.Density = 1;
        v173.Color = Color3.fromRGB(25, 25, 25);
        v173.Parent = workspace:FindFirstChild("Terrain");
        game.Debris:AddItem(v173, v172);
    end;
    local v174 = script.IntroScreen:Clone();
    v174.Main.Title.Text = v170.Config.IntroText:gsub("PLAYERNAME", v170.Player.DisplayName);
    v174.Parent = game.Players.LocalPlayer.PlayerGui;
    game.Debris:AddItem(v174, 1.93333);
    game.TweenService:Create(v174.Main.Title, TweenInfo.new(0.83), {
        TextTransparency = 0
    }):Play();
    task.delay(0.83, function() --[[ Line: 948 ]]
        -- upvalues: v174 (copy), v170 (copy)
        game.TweenService:Create(v174.Main.Title, TweenInfo.new(0.583), {
            TextColor3 = v170.Config.IntroTextColor or Color3.new(1, 0, 0)
        }):Play();
    end);
    task.delay(1, function() --[[ Line: 953 ]]
        -- upvalues: v171 (copy)
        local l_JohnDoeTrail_0 = v171:FindFirstChild("JohnDoeTrail");
        if l_JohnDoeTrail_0 then
            l_JohnDoeTrail_0:Destroy();
        end;
    end);
    local v176 = require(game.ReplicatedStorage.Modules.Schematics.Lighting);
    v176:SetCustomLighting(v170.Config.IntroLighting);
    task.delay(2.717, function() --[[ Line: 963 ]]
        -- upvalues: v173 (ref), v170 (copy)
        if v173 then
            v173.Color = Color3.fromRGB(25, 0, 0);
        end;
        local l_AtmosphereDoe_0 = game.Lighting:FindFirstChild("AtmosphereDoe");
        if l_AtmosphereDoe_0 then
            game.TweenService:Create(l_AtmosphereDoe_0, TweenInfo.new(0.2829, Enum.EasingStyle.Linear), {
                Color = v170.Config.AtmosphereColor or Color3.fromRGB(144, 0, 0), 
                Decay = v170.Config.AtmosphereDecay or Color3.fromRGB(255, 0, 0), 
                Density = 1
            }):Play();
        end;
    end);
    local l_v6_FOVMultiplier_1 = v6:CreateFOVMultiplier(game.Players.LocalPlayer, 0.35, "JohnDoeIntroScene");
    task.delay(2.75, function() --[[ Line: 979 ]]
        -- upvalues: l_v6_FOVMultiplier_1 (copy)
        game.TweenService:Create(l_v6_FOVMultiplier_1, TweenInfo.new(0.25), {
            Value = 0.95
        }):Play();
    end);
    task.delay(v172, function() --[[ Line: 984 ]]
        -- upvalues: v176 (copy), l_v6_FOVMultiplier_1 (copy), v174 (copy), v173 (ref)
        v176:SetAsCurrentLighting();
        l_v6_FOVMultiplier_1:Destroy();
        v174:Destroy();
        if v173 then
            v173:Destroy();
        end;
    end);
end;
v1.OnVictory = function(_, v180, v181, _, _) --[[ Line: 994 ]] --[[ Name: OnVictory ]]
    -- upvalues: v6 (copy), l_TweenService_0 (copy)
    local v184 = require(game.ReplicatedStorage.Modules.Schematics.Lighting);
    if v180 == "Start" then
        v184:SetCustomLighting(v181.Config.IntroLighting);
        local l_v6_FOVMultiplier_2 = v6:CreateFOVMultiplier(game.Players.LocalPlayer, 1.1325, "JohnDoeOutroScene");
        game.Debris:AddItem(l_v6_FOVMultiplier_2, 30);
        task.spawn(function() --[[ Line: 1005 ]]
            -- upvalues: v181 (copy), v6 (ref)
            local v186 = os.clock();
            local v187 = workspace.Misc:WaitForChild("KillerCutsceneBackground", 5);
            if v187 and v187.PrimaryPart then
                local v188 = v181.Config.OutroDummy:Clone();
                v188.Name = "OutroVictim";
                v188.PrimaryPart.Anchored = true;
                v188:SetPrimaryPartCFrame(v187.PrimaryPart.CFrame);
                v188.Parent = v187;
                local v189 = v6:LoadAnimationFromID(v188, "rbxassetid://135006397147596", true);
                v189:Play(0);
                v189.TimePosition = os.clock() - v186;
                v189.Stopped:Once(function() --[[ Line: 1020 ]]
                    -- upvalues: v188 (copy)
                    for _, v191 in ipairs(v188:GetDescendants()) do
                        if v191:IsA("BasePart") then
                            v191.Anchored = true;
                        end;
                    end;
                end);
                local v192 = false;
                for _, v194 in ipairs({
                    "Shirt", 
                    "Pants", 
                    "Accessory", 
                    "Hat"
                }) do
                    if v188:FindFirstChildOfClass(v194) then
                        v192 = true;
                        break;
                    end;
                end;
                if not v192 then
                    pcall(function() --[[ Line: 1033 ]]
                        -- upvalues: v181 (ref), v188 (copy)
                        local l_HumanoidDescriptionFromUserId_0 = game.Players:GetHumanoidDescriptionFromUserId(v181.Player.UserId);
                        v188.Humanoid:ApplyDescription(l_HumanoidDescriptionFromUserId_0, Enum.AssetTypeVerification.Always);
                    end);
                end;
            end;
        end);
        task.delay(2.4, function() --[[ Line: 1042 ]]
            -- upvalues: l_TweenService_0 (ref), v181 (copy)
            local v196 = Instance.new("ColorCorrectionEffect", game.Lighting);
            v196.Name = "JohnDoeStabCC";
            local v197 = l_TweenService_0:Create(v196, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
                Contrast = 0.4, 
                Brightness = 0.1
            });
            v197:Play();
            task.wait(0.4);
            v197:Pause();
            v196.Brightness = 0.8;
            v196.Contrast = 0.3;
            v196.TintColor = v181.Config.OutroTintColor or Color3.new(0.631373, 0.0784314, 0.0901961);
            l_TweenService_0:Create(v196, TweenInfo.new(2.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
                TintColor = Color3.new(0.196078, 0.196078, 0.196078), 
                Brightness = -1, 
                Contrast = -0.5, 
                Saturation = -1
            }):Play();
        end);
        return;
    else
        if v180 == "End" then
            v184:SetAsCurrentLighting();
            local l_v6_FOVMultiplier_3 = v6:CreateFOVMultiplier(game.Players.LocalPlayer, 1, "JohnDoeOutroScene");
            game.Debris:AddItem(l_v6_FOVMultiplier_3, 1);
            local v199 = game.Lighting:WaitForChild("JohnDoeStabCC", 8);
            if v199 then
                v199:Destroy();
            end;
        end;
        return;
    end;
end;
v1.OnExecution = function(_, v201, v202) --[[ Line: 1106 ]] --[[ Name: OnExecution ]]
    local l_Humanoid_2 = v202:FindFirstChild("Humanoid");
    local v204 = require(game.ReplicatedStorage.Modules.Ragdolls);
    local v205 = (v201.Rig.PrimaryPart.CFrame.LookVector + Vector3.new(0, 0.5, 0, 0)) * 40;
    local l_Axe_0 = v202:FindFirstChild("Axe");
    local l_BackAxe_0 = v202:FindFirstChild("BackAxe");
    if v202.Name == "JaneDoe" then
        l_Axe_0.Transparency = 0;
        l_BackAxe_0.Transparency = 1;
        task.delay(2.85, function() --[[ Line: 1118 ]]
            -- upvalues: v204 (copy), v202 (copy), v205 (copy), l_Humanoid_2 (copy)
            v204.AddProfile(v202, {
                Velocity = v205, 
                KillEffects = {
                    Explode = true
                }
            });
            if l_Humanoid_2 then
                l_Humanoid_2.BreakJointsOnDeath = true;
                l_Humanoid_2.Health = 0;
            end;
        end);
        return;
    else
        task.delay(0.666, function() --[[ Line: 1128 ]]
            -- upvalues: v204 (copy), v202 (copy), v205 (copy)
            v204.AddProfile(v202, {
                AnchorDelay = true, 
                Applied = os.clock() + 5, 
                Velocity = v205
            });
            local l_Humanoid_3 = v202:FindFirstChild("Humanoid");
            if l_Humanoid_3 then
                l_Humanoid_3.BreakJointsOnDeath = false;
                l_Humanoid_3.Health = 0;
            end;
        end);
        task.delay(1.98, function() --[[ Line: 1137 ]]
            -- upvalues: v202 (copy)
            if v202 and v202.PrimaryPart then
                v202.PrimaryPart.Anchored = false;
            end;
        end);
        return;
    end;
end;
return v1;]==========],
[ [==========[
ReplicatedStorage/Modules/Hitboxes]==========] ]=[==========[
-- So, I've been trying to improve the engine recently and I just though: WHY NOT JUST RECODE EVERYTHING?????????????????
-- also improving my comments!
-- skiddy katamari will say this is trash because her engine needs to be better than anything

-- // services:
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local AnalyticsService = game:GetService("AnalyticsService")
local isStudio = RunService:IsStudio()
local isServer = RunService:IsServer()

-- // modules:
local Ragdolls = require(ReplicatedStorage.Modules.Ragdolls)
local Util = require(ReplicatedStorage.Modules.Util)
local AchievementUtil = require(ReplicatedStorage.Modules.AchievementUtil)
local Actors = require(ReplicatedStorage.Modules.Actors)
local Network = require(ReplicatedStorage.Modules.Network)
local Sounds = require(ReplicatedStorage.Modules.Sounds)
local Stats = require(ReplicatedStorage.Modules.Stats)
local Statuses = require(ReplicatedStorage.Modules.Statuses)

-- // new modules (these were originally not on forsaken neither on aeternus)
local Janitor = require(ReplicatedStorage.Modules.Misc.Janitor) -- expect to see this alot (maid will still be here to keep compatibility)
local CoreLoader = require(ReplicatedStorage.CoreLoader)
local Signal = require(ReplicatedStorage.Modules.Misc.Signal) -- why doesn't forsaken use this module

local Hitboxes = {}


-- new function to prevent wall clipping (aka. hitting someone if they are behind an wall)
local function PreventWallClip(pOrigin, pTargetPos, pExcludeChar)
	local diff = pTargetPos - pOrigin
	local dist = diff.Magnitude
	if dist > 10 then
		pTargetPos = pOrigin + diff.Unit * 10
		dist = 10
	end
	if dist < 0.1 then
		return pTargetPos
	end

	local rayParams = RaycastParams.new()
	rayParams.FilterType = Enum.RaycastFilterType.Exclude
	rayParams.FilterDescendantsInstances = { workspace.Players, pExcludeChar, workspace:FindFirstChild("Hitboxes") }

	local raycastResult = workspace:Raycast(pOrigin, diff, rayParams)
	if not raycastResult then
		return pTargetPos
	end

	local safeDist = math.max(raycastResult.Distance - 0.5, 0)
	return pOrigin + diff.Unit * safeDist
end


local function GetDictionaryLength(dict)
	local count = 0
	for _, _ in pairs(dict) do
		count += 1
	end
	return count
end


function Hitboxes.LineOfSight(_, origin, targetChar)
	local player = Players:GetPlayerFromCharacter(targetChar)

	if player then
		local _ = Actors.CurrentActors[player]
	end

	targetChar:FindFirstChild("Humanoid")

	local hasReplicating = targetChar:FindFirstChild("QueryHitbox") and (player and targetChar:HasTag("Replicating"))
	local raycastParams = RaycastParams.new()

	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.FilterDescendantsInstances = if not typeof(origin == "Vector3") then {
		workspace.Players,
		targetChar,
		origin
	} else {
			workspace.Players,
			targetChar
		}
	raycastParams.CollisionGroup = tostring(typeof(origin) ~= "Vector3" and (not not origin.PrimaryPart and origin.PrimaryPart.CollisionGroup) or "Killers")

	local function partCanBlock(hitPart)
		local isHitbox = hitPart:GetAttribute("Hitbox") or (hitPart.CanCollide or hitPart.Transparency < 1)
		local hitHumanoid = hitPart.Parent:FindFirstChild("Humanoid")

		if isHitbox and not hitHumanoid then
			return true
		end

		raycastParams:AddToFilter(hitPart)

		if hitHumanoid then
			raycastParams:AddToFilter(hitHumanoid.Parent)
		end

		return false
	end

	if typeof(origin) == "Vector3" then
	else
		local originPlayer = Players:GetPlayerFromCharacter(origin)
		local originActor = originPlayer and Actors.CurrentActors[originPlayer]

		origin = originActor and originActor:GetPivot(false).Position or origin.PrimaryPart.Position
	end

	for _, child in ipairs(targetChar:GetChildren()) do
		if not child:IsA("BasePart") or not child.CanQuery or child:GetAttribute("Hitbox") then
			continue
		end

		local objectSpace = targetChar.PrimaryPart.CFrame:ToObjectSpace(child.CFrame)
		local targetPos = hasReplicating and targetChar.QueryHitbox.CFrame:ToWorldSpace(objectSpace).Position or child.Position
		local attempts = 0
		local raycastResult

		repeat
			raycastResult = workspace:Raycast(origin, targetPos - origin, raycastParams)
			attempts += 1
		until not raycastResult or partCanBlock(raycastResult.Instance) or attempts > 15

		if not raycastResult and attempts <= 15 then
			return true
		end
	end

	return false
end


local function guestHitClient(target, ...)
	if typeof(target) == "Instance" and target:IsA("Player") then
		Network:FireClientConnection(target, ...)
	end
end
local function guestIsPlayer(target)
	return typeof(target) == "Instance" and target:IsA("Player")
end
local function guestCharacter(subject)
	if typeof(subject) == "Instance" then
		if subject:IsA("Player") then return subject.Character end
		if subject:IsA("Model") then return subject end
	elseif typeof(subject) == "table" then
		return subject.Rig or subject.Character
	end
end
local function guestActor(subject, rig)
	local player = rig and Players:GetPlayerFromCharacter(rig)
	local actor = subject and Actors.CurrentActors[subject] or player and Actors.CurrentActors[player] or rig and Actors.CurrentActors[rig]
	if actor and actor.Rig == rig then return actor end
	for _, candidate in pairs(Actors.CurrentActors) do
		if candidate.Rig == rig then return candidate end
	end
end

function Hitboxes.CreateHitbox(_, creator, hitboxParams)
	local creatorChar = guestCharacter(creator)

	if not creatorChar or not creatorChar.PrimaryPart then
		return
	end

	local params = hitboxParams or {}
	local config = {
		Size = params.Size or Vector3.new(4, 7, 4),
		CFrameOffset = params.CFrameOffset or CFrame.new(0, 0, 0),
		CFrame = params.CFrame or nil,
		CastPoint = if params.CastPoint ~= nil then params.CastPoint else nil,
		Damage = params.Damage or 15,
		AbilityType = params.AbilityType or nil,
		Time = params.Time or 0.125,
		Knockback = params.Knockback or 0,
		HitMultiple = params.HitMultiple or false,
		PredictVelocity = params.PredictVelocity == nil or params.PredictVelocity,
		ExecuteOnKill = params.ExecuteOnKill or false,
		FriendlyFire = params.FriendlyFire or false,
		Team = params.Team,
		Target = params.Target,
		OnlyHitPlayers = params.OnlyHitPlayers or false,
		RagdollOnHit = params.RagdollOnHit or false,
		Hide = params.Hide or false,
		DeathProfile = params.DeathProfile or {},
		Shape = params.Shape or Enum.PartType.Block,
		ExcludeChars = params.ExcludeChars or {},
		Connections = params.Connections or {}
	}
	local overlapParams = OverlapParams.new()

	overlapParams.FilterType = Enum.RaycastFilterType.Exclude
	overlapParams.FilterDescendantsInstances = { creatorChar }

	local hitboxState = {
		TimePast = 0,
		HumanoidsDamaged = {},
		InvincibleProcs = {},
		Creator = creator,
		AbilityType = config.AbilityType,
		Damage = config.Damage,
		IsProjectile = if params.IsProjectile ~= nil then params.IsProjectile else config.CFrame ~= nil,

		OnHit = Signal.new(),
		OnEnded = Signal.new()
	}

	local hitboxJanitor = Janitor.new()
	hitboxJanitor:Add(hitboxState.OnHit, "Destroy")
	hitboxJanitor:Add(hitboxState.OnEnded, "Destroy")

	local function runCallback(callbackName, ...)
		if config.Connections[callbackName] then
			config.Connections[callbackName](...)
		end
	end

	function hitboxState.Cancel(_)
		hitboxState.Cancelled = true
		hitboxJanitor:Cleanup()
	end

	task.spawn(function()
		local creatorActor = guestActor(creator, creatorChar)

		while creatorChar.Parent and creatorChar.PrimaryPart and hitboxState.TimePast < config.Time and not hitboxState.Cancelled do
			local humanoidsDamaged = hitboxState.HumanoidsDamaged
			local hitCount = 0

			for _, _ in pairs(humanoidsDamaged) do
				hitCount += 1
			end

			if hitCount > 0 and not config.HitMultiple or creatorChar:GetAttribute("Stunned") or not Util:IsAlive(creatorChar) and not hitboxState.IsProjectile then
				break
			end

			local pivotCF = creatorActor and creatorActor:GetPivot(not not config.PredictVelocity) or creatorChar.PrimaryPart.CFrame
			local hitboxPart = Instance.new("Part")

			hitboxPart.Name = tostring(creator) .. "Hitbox"
			hitboxPart.Transparency = 1
			hitboxPart.CanCollide = false
			hitboxPart.CanTouch = false
			hitboxPart.CanQuery = false
			hitboxPart.CastShadow = false
			hitboxPart.Anchored = true
			hitboxPart.Shape = config.Shape
			hitboxPart.Size = typeof(config.Size) == "function" and config.Size() or config.Size
			hitboxPart.CFrame = typeof(config.CFrame) == "function" and config.CFrame() or (config.CFrame or pivotCF * if typeof(config.CFrameOffset) ~= "function" then config.CFrameOffset else config.CFrameOffset())
			hitboxPart.Parent = workspace:FindFirstChild("Hitboxes")
			hitboxState.Instance = hitboxPart

			task.delay(0.36, function()
				if hitboxPart and hitboxPart.Parent then hitboxPart:Destroy() end
			end)

			if config.Hide then
				hitboxPart:SetAttribute("Hidden", true)
			end

			if config.PredictVelocity then
				if typeof(creator) ~= "Instance" or not creator:IsA("Player") then
				end
			end

			local partsFound = workspace:GetPartsInPart(hitboxPart, overlapParams)

			table.sort(partsFound, function(partA, partB)
				local parentA = partA.Parent
				local parentB = partB.Parent
				local priorityA = parentA:GetAttribute("HitboxPriority") or 1
				local priorityB = parentB:GetAttribute("HitboxPriority") or 1

				if priorityA == priorityB then
					priorityA = (creatorChar.PrimaryPart.Position - partB.Position).Magnitude
					priorityB = (creatorChar.PrimaryPart.Position - partA.Position).Magnitude
				end

				return priorityB < priorityA
			end)

			local targetsHit = {}

			for _, hitPart in ipairs(partsFound) do
				local victimHumanoid = hitPart.Parent:FindFirstChildOfClass("Humanoid")

				if victimHumanoid and not (victimHumanoid.Health <= 0) and (not victimHumanoid.Parent:HasTag("Replicating") or not Players:GetPlayerFromCharacter(victimHumanoid.Parent) or hitPart.Name == "QueryHitbox") and ((not victimHumanoid.Parent:HasTag("SurvivorConstruct") or not config.OnlyHitPlayers) and not hitboxState.HumanoidsDamaged[victimHumanoid]) and (not config.Team or tostring(hitPart.Parent.Parent) == config.Team or tostring(hitPart.Parent:GetAttribute("Team")) == config.Team) and ((workspace:GetAttribute("FriendlyFire") or config.FriendlyFire or config.Team and config.Team == tostring(creatorChar.Parent) or tostring(hitPart.Parent:GetAttribute("Team")) ~= tostring(creatorChar.Parent) and tostring(hitPart.Parent.Parent) ~= tostring(creatorChar.Parent)) and (not config.Target or config.Target == victimHumanoid.Parent)) then
					local castOrigin = if not config.CastPoint then if config.CFrame then hitboxPart.CFrame.Position else creatorChar else if typeof(config.CastPoint) ~= "function" then config.CastPoint else config.CastPoint()

							if (config.CastPoint == false or Hitboxes:LineOfSight(castOrigin, victimHumanoid.Parent)) and not table.find(config.ExcludeChars, victimHumanoid.Parent) and not table.find(config.ExcludeChars, victimHumanoid) then
								if victimHumanoid.Parent:GetAttribute("Invincible") then
									if not hitboxState.InvincibleProcs[victimHumanoid] then
										local victimPrimaryPart = victimHumanoid.Parent.PrimaryPart
										local invincibleFX = victimPrimaryPart and victimPrimaryPart:FindFirstChild("InvincibleFX")

										if invincibleFX and invincibleFX:FindFirstChild("Deflect") then
											Sounds:Play("invincibleDeflect", {
												Parent = victimPrimaryPart
											})
											invincibleFX.Deflect:Emit(1)
										end
									end

									hitboxState.InvincibleProcs[victimHumanoid] = true
								else
									local hitPriority = victimHumanoid.Parent:GetAttribute("HitboxPriority") or 1

									hitboxState.HumanoidsDamaged[victimHumanoid] = true
									table.insert(targetsHit, victimHumanoid)

									if not config.HitMultiple and hitPriority >= 0 then
										break
									end
								end
							end
						end
					end

					hitboxPart.Color = #targetsHit > 0 and Color3.new(0.5, 1, 0.5) or Color3.new(1, 0.25, 0.25)

					for i, victimHumanoid in ipairs(targetsHit) do
						local victimChar = victimHumanoid.Parent
						local victimPrimaryPart = victimChar and (victimChar:IsA("Model") and victimChar.PrimaryPart)
						local rawDamage = typeof(config.Damage) == "number" and config.Damage or config.Damage(victimChar)
						local resistanceSum = 0
						local resistanceFolder = victimChar and victimChar:FindFirstChild("ResistanceMultipliers")

						for _, resistanceValue in pairs(resistanceFolder and resistanceFolder:GetChildren() or {}) do
							resistanceSum += resistanceValue.Value
						end

						local weakenedDamage = require(game.ReplicatedStorage.Modules.DamageRules).ScaleDamage(creatorChar, rawDamage)
						local finalDamage = weakenedDamage * (1 - math.min(resistanceSum - (creatorChar:GetAttribute("StrengthBuff") or 0), 100) / 100)

						if not victimPrimaryPart then
							continue
						end

						victimChar:SetAttribute("TimesHit", (victimChar:GetAttribute("TimesHit") or 0) + 1)
						runCallback("HitAbsolute", victimChar, i == 1)

						local victimPlayer = Players:GetPlayerFromCharacter(victimChar)
						local victimActor = guestActor(victimPlayer, victimChar)

						if victimActor and victimActor.Behavior and victimActor.Behavior.OnHit then
							local hitResponse = victimActor.Behavior:OnHit(
								victimActor,
								hitboxState,
								finalDamage
							)

							if hitResponse == "Ignored" then
								continue
							end

							if typeof(hitResponse) == "table"
								and typeof(hitResponse.DamageOverride) == "number" then

								finalDamage = math.max(0, hitResponse.DamageOverride)
							end

							if hitboxState.TimePast > config.Time then
								break
							end
						end

						local knockbackVal = not (typeof(config.Knockback) ~= "number" and typeof(config.Knockback) ~= "Vector3") and config.Knockback or config.Knockback(victimChar)
						local isKbVector = typeof(knockbackVal) == "Vector3"
						local kbDir = isKbVector and knockbackVal or hitboxPart.CFrame.LookVector

						if isKbVector or knockbackVal > 0 then
							local kbForce = (typeof(knockbackVal) == "Vector3" and knockbackVal or kbDir * knockbackVal) * 10

							if victimPlayer then
								guestHitClient(victimPlayer, "KB", "REMOTE_EVENT", Util:SerializeVector(kbForce))
							else
								victimPrimaryPart.AssemblyLinearVelocity = kbForce + victimPrimaryPart.AssemblyLinearVelocity / 2
							end
						end

						local deathProfile = Util:CopyTable(config.DeathProfile)

						if not deathProfile.Velocity then
							if isKbVector then
								deathProfile = {
									Velocity = kbDir * 10
								}
							elseif knockbackVal > 0 then
								deathProfile = {
									Velocity = kbDir * knockbackVal * 10
								}
							end
						end

						Ragdolls.AddProfile(victimChar, deathProfile)

						local damageDealt = finalDamage
						local overhealVal = victimHumanoid:GetAttribute("Overheal") or 0
						local shatterpointHP = victimChar:GetAttribute("ShatterpointHP") or 0
						local _ = victimHumanoid.Health + overhealVal + shatterpointHP
						local isVictimAlive = victimHumanoid.Health > 0
						local remainingOverheal = math.max(0, overhealVal - finalDamage)

						if remainingOverheal < (victimHumanoid:GetAttribute("OverhealDecayMin") or 0) then
							victimHumanoid:SetAttribute("OverhealDecayMin", remainingOverheal > 0 and remainingOverheal or nil)
						end

						local damageToApply = finalDamage - overhealVal

						if damageToApply > 0 and shatterpointHP > 0 then
							local shatterDamage = damageToApply * (victimChar:GetAttribute("ShatterpointResistance") or 1)

							if shatterDamage > 0 then
								local victimBehaviorActor = guestActor(victimPlayer, victimChar)

								if victimBehaviorActor and victimBehaviorActor.Behavior and victimBehaviorActor.Behavior.sv_DamageCrystalHP then
									victimBehaviorActor.Behavior:sv_DamageCrystalHP(victimBehaviorActor, shatterDamage)
								else
									victimChar:SetAttribute("ShatterpointHP", (math.max(0, shatterpointHP - shatterDamage)))
								end

								local shatterRemainder = shatterDamage - shatterpointHP

								damageDealt = shatterDamage + overhealVal
								damageToApply = not (shatterRemainder > 0) and 0 or shatterRemainder
							end
						end

						local finalDeductibleDamage = math.max(0, damageToApply)
						local victimPosInt16 = Vector3int16.new(victimPrimaryPart.Position.X, victimPrimaryPart.Position.Y, victimPrimaryPart.Position.Z)
						local isKilled = victimHumanoid.Health - finalDeductibleDamage <= 0
						local creatorBehaviorActor = guestActor(creator, creatorChar)

						if creatorBehaviorActor then
							local _, _ = pcall(function()
								return creatorBehaviorActor.Behavior.OnInflictedDamage(creatorBehaviorActor, victimChar, (math.min(victimHumanoid.Health, damageDealt)))
							end)
						end

						if isVictimAlive and isKilled then
							local protectionPlayerName = victimChar:GetAttribute("DusekkarProtected")
							local protectionPlayer = protectionPlayerName and Players:FindFirstChild(protectionPlayerName)

							if protectionPlayer then
								local protectorChar = protectionPlayer.Character

								print(`dusekkar moment ({ victimChar } protected by { protectionPlayer })`)
								Actors:IncrementActorStats(protectionPlayer, {
									Action = "Prevented the death of a Survivor",
									Money = 10,
									EXP = 30
								})
								victimChar:SetAttribute("DusekkarProtected", nil)
								protectorChar:SetAttribute("Protecting", nil)
								AchievementUtil:IncrementAchievementProgress(protectionPlayer, "DusekkarUbercharge")

								return
							end

							if tostring(victimChar.Parent) == "Survivors" then
								if guestIsPlayer(creator) then
									Stats:UpdatePlayerStat(creator, "Kills", "Add", 1)
								end

								if creatorBehaviorActor then
									creatorBehaviorActor.TotalKills =
										(creatorBehaviorActor.TotalKills or 0) + 1

									local ok, result = pcall(function()
										AnalyticsService:LogCustomEvent(creator, "TotalKills", 1, {
											[Enum.AnalyticsCustomFieldKeys.CustomField01.Name] = `Character - { creatorBehaviorActor.ActorName }`
										})
									end)

									if not ok then
										warn(`[AnalyticsService]: Failed to log custom event: TotalKills due to: { result }`)
									end
								end
							end

							local creatorVoicelines = creatorBehaviorActor and creatorBehaviorActor.Config.Voicelines

							if creatorVoicelines and not victimChar:GetAttribute("ExecutionsDisabled") then
								local killType = "Kill"

								if isServer then
									local RoundManager = require(game.ServerScriptService.Server.Systems.Core.RoundManager)

									if RoundManager and RoundManager.CurrentSession and RoundManager.CurrentSession.LastSurvivorAlive then
										killType = "LastKill"
									end
								end

								for _, actionName in ipairs({
									killType,
									"Kill"
									}) do
									if creatorVoicelines[`{ actionName }{ tostring(victimChar:GetAttribute("SkinName")) }`] then
										Sounds:PlayVoiceline(creatorBehaviorActor, `Kill{ tostring(victimChar:GetAttribute("SkinName")) }`)

										break
									end

									if creatorVoicelines[`{ actionName }{ victimChar.Name }`] then
										Sounds:PlayVoiceline(creatorBehaviorActor, `Kill{ victimChar.Name }`)

										break
									end

									if creatorVoicelines[`{ actionName }`] then
										Sounds:PlayVoiceline(creatorBehaviorActor, "Kill")

										break
									end
								end
							end

							local RoundManager = game.ServerScriptService.Server.Systems.Core.RoundManager
							local lib = require(RoundManager)

							if tostring(victimChar.Parent) == "Survivors" and (lib.CurrentSession and lib.CurrentSession.TimePast or isStudio or workspace:GetAttribute("Testing")) then
								lib:AddTime(nil, victimActor and victimActor.TimeAddMultiplier or 1, true)

								if creatorBehaviorActor and creatorBehaviorActor.Behavior and creatorBehaviorActor.Behavior.OnKill then
									local ok, result = pcall(function()
										return creatorBehaviorActor.Behavior.OnKill(creatorBehaviorActor, victimChar)
									end)

									if not ok then
										warn(`[{ script }/CreateHitbox]: Failed to call .OnKill() due to: { result }`)
									end
								end

								require(game.ServerScriptService.Server.Systems.Core.EventHandlerServer):CallMethod("OnPlayerKilled", creator, victimPlayer)
								if guestIsPlayer(creator) then
									Actors:IncrementActorStats(creator, {
										Action = "Killed a Survivor", Money = 15, EXP = 45
									})
								end
							end

							if config.ExecuteOnKill and guestIsPlayer(creator) and creatorBehaviorActor and not victimChar:GetAttribute("ExecutionsDisabled") and not (creatorBehaviorActor.AbilityDisablers or {}).Execution then
								local skinName = victimChar:GetAttribute("SkinName")
								local executionAnimName = nil

								if not creatorBehaviorActor then
									warn("Hitboxes: Non-Actor attempted to Execute!")
								else
									executionAnimName = if not skinName or (skinName == "" or not creatorBehaviorActor.Config.Animations[`Execution{ skinName }`]) then not creatorBehaviorActor.Config.Animations[`Execution{ victimChar.Name }`] and "Execution" or `Execution{ victimChar.Name }` else `Execution{ skinName }`
								end

								local executionAnimConfig = creatorBehaviorActor and creatorBehaviorActor.Config.Animations[executionAnimName]

								if executionAnimConfig and executionAnimConfig.KillerRig and executionAnimConfig.PlayerRig then
									task.spawn(function()
										Statuses:RemoveStatuses(victimChar, true)
										Util:GiveStackableAttribute(victimChar, "BeingExecuted", `{ creatorBehaviorActor.Player.Name }Execution`, 10)

										local killerTrack = creatorBehaviorActor.Cache[`{ executionAnimName }Anim`]

										if not killerTrack then
											killerTrack = Util:LoadAnimationFromID(creatorBehaviorActor.Rig, executionAnimConfig.KillerRig, false)
											creatorBehaviorActor.Cache[`{ executionAnimName }Anim`] = killerTrack
										end

										local killerPrimaryPart = creatorBehaviorActor.Rig.PrimaryPart
										local victimTrack = Util:LoadAnimationFromID(victimChar, executionAnimConfig.PlayerRig, false)
										local isExecutionFinished = false
										local stateConn = nil

										stateConn = victimHumanoid.StateChanged:Connect(function(_, newState)
											if newState == Enum.HumanoidStateType.Dead then
												isExecutionFinished = true

												if stateConn then
													stateConn:Disconnect()
													hitboxJanitor:Remove("Execution_" .. victimHumanoid.Name)
												end

												guestHitClient(creator, "Hit", "UREMOTE_EVENT", damageDealt, victimPosInt16, nil, true)
											end
										end)

										hitboxJanitor:Add(stateConn, "Disconnect", "Execution_" .. victimHumanoid.Name)

										Util:GiveInvincible(creatorChar, "Executing")
										Util:SetUpCutscene(creatorBehaviorActor.Rig, victimChar, executionAnimConfig.PlayerCFrameOffset, "Execution")
										task.delay(killerTrack.Length + 1.5, function()
											Util:RemoveInvincible(creatorChar, "Executing")
										end)
										creatorBehaviorActor:DisableAbilities("Execution", true)
										task.delay(killerTrack.Length, function()
											if stateConn then
												stateConn:Disconnect()
												hitboxJanitor:Remove("Execution_" .. victimHumanoid.Name)
											end

											if not isExecutionFinished then
												isExecutionFinished = true
												guestHitClient(creator, "Hit", "UREMOTE_EVENT", damageDealt, victimPosInt16, nil, true)
											end

											creatorBehaviorActor:DisableAbilities("Execution", false)
											Util:ToggleAnchored(creatorBehaviorActor.Rig, "Execution", false)
											Util:ToggleAnchored(victimChar, "Execution", false)
											Util:RemoveStackableAttribute(victimChar, "NoItems", "Execution")
											victimHumanoid.Health = 0
											victimHumanoid:ChangeState(Enum.HumanoidStateType.Dead)
										end)
										killerTrack:Play(0)
										victimTrack:Play(0)

										local executionSound = creatorBehaviorActor.Config.Sounds[executionAnimName]

										Sounds:Play(executionSound, {
											Parent = killerPrimaryPart
										})

										if creatorBehaviorActor.Behavior.OnExecution then
											creatorBehaviorActor.Behavior:OnExecution(creatorBehaviorActor, victimChar, {
												victimInfo = victimActor,
												Tracks = {
													Killer = killerTrack,
													Victim = victimTrack
												}
											})
										end

										if creatorBehaviorActor.Behavior.OnExecutionClient then
											guestHitClient(creatorBehaviorActor.Player, "OnExecutionClientAsync", "REMOTE_EVENT", victimChar)
										end
									end)

									return
								end
							end
						end

						if config.RagdollOnHit then
							local ragdollTime = typeof(config.RagdollOnHit) == "number" and config.RagdollOnHit or 2

							Ragdolls.EnableRagdoll(victimChar, ragdollTime)
						end

						victimChar:SetAttribute("RecentAttacker", (tostring(creator)))
						victimChar:SetAttribute("RecentAttackerTime", os.clock())

						if victimHumanoid:GetAttribute("Overheal") then
							victimHumanoid:SetAttribute("Overheal", remainingOverheal > 0 and remainingOverheal or nil)
						end

						victimHumanoid.Health = victimHumanoid.Health - finalDeductibleDamage

						if victimHumanoid.Health <= 0 then
							victimHumanoid:SetAttribute("Overheal", nil)
							victimHumanoid:ChangeState(Enum.HumanoidStateType.Dead)
						end

						runCallback("Hit", victimChar, i == 1)
						hitboxState.OnHit:Fire(victimChar, i == 1)

						guestHitClient(creator, "Hit", "UREMOTE_EVENT", damageDealt, victimPosInt16, nil, victimHumanoid.Health <= 0)
					end

					local stateRef = hitboxState

					stateRef.TimePast = stateRef.TimePast + RunService.Heartbeat:Wait()
				end

				runCallback("Ended")
				hitboxState.OnEnded:Fire()
			end)

	task.delay(config.Time + 1, function()
		hitboxJanitor:Cleanup()
	end)

	return hitboxState
end


function Hitboxes.Start(_)
	if isServer then
		local Folder = Instance.new("Folder")

		Folder.Name = "Hitboxes"
		Folder.Parent = workspace
	end
end


function Hitboxes.CreateMainAbilityHitbox(self, creator, options)
	local params = table.clone(options or {})
	if params.AbilityType == nil then params.AbilityType = "MainAbility" end
	if params.IsProjectile == nil then params.IsProjectile = false end
	return self:CreateHitbox(creator, params)
end

return Hitboxes
]==========]
}
local expected={
[ [==========[
ReplicatedStorage/Assets/Killers/JohnDoe/Config]==========] ]=[==========[
-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local l_workspace_Attribute_0 = workspace:GetAttribute("JohnDoeSpecialDay");
local v1 = {
    DisplayName = "John Doe", 
    Quote = l_workspace_Attribute_0 and "dude i told you not to play on march 18th" or "DON'T PLAY ROBLOX ON MARCH 18TH?!?!", 
	RenderImage = l_workspace_Attribute_0 and "rbxassetid://125927083463034" or "rbxassetid://115998690833101", 
    Price = l_workspace_Attribute_0 and 318 or 1000, 
    Health = l_workspace_Attribute_0 and 3182026 or 1500, 
    Speed = l_workspace_Attribute_0 and 11.3182026 or 9, 
    IntroText = "They're all yours, Mr. Doe", 
    SprintSpeed = l_workspace_Attribute_0 and 27.53182026 or 27.25, 
    StaminaLoss = 9.5, 
    StaminaGain = 21, 
    MaxStamina = l_workspace_Attribute_0 and 115.3182026 or 110, 
    SlashDamage = l_workspace_Attribute_0 and 45.3182026 or 28, 
    SlashCooldown = l_workspace_Attribute_0 and 2.3182026 or 1.75, 
    SlashWindup = 0.4, 
    SlashLinger = 0.25, 
    CorruptEnergyDamage = l_workspace_Attribute_0 and 16.3182026 or 11, 
    CorruptEnergyCooldown = l_workspace_Attribute_0 and 40.3182026 or 18, 
    SpikeAmount = l_workspace_Attribute_0 and 256 or 31, 
    SpikeHitboxSize = Vector3.new(11, 5, 5, 0), 
    SpikeLifetime = l_workspace_Attribute_0 and 18.3182026 or 14, 
    SpikeHitCap = l_workspace_Attribute_0 and 3182026 or 2, 
    SpikeProperties = PhysicalProperties.new(0.2, 2, 0, 100, 100), 
    DelayBetweenSpikeSummons = l_workspace_Attribute_0 and 0.02 or 0.045, 
    DistanceBetweenSpikes = 4, 
    DigitalFootprintCooldown = 3, 
    DigitalFootprintLimit = l_workspace_Attribute_0 and 4 or 3, 
    ["404ErrorAuraRevealTime"] = l_workspace_Attribute_0 and 10.3182026 or 6, 
    ["404ErrorCooldown"] = 20, 
    Spike = script.Spike, 
    Shadow = script.Shadow, 
    Trail = script.Trail, 
    SpikeNumbersColor = Color3.fromRGB(255, 0, 0), 
    TrailLength = l_workspace_Attribute_0 and 356 or 48, 
    UnstoppableDuration = 2, 
    SilencedTemplate = script.NAN, 
    Silenced = true, 
    OutroDummy = script.OutroVictim, 
    useClouds = true, 
    Relations = {
        "JaneDoe"
    }, 
    LastManStandingEmotionalData = {
        ThemeID = "rbxassetid://90004798416076", 
        RoundTime = 99
    }, 
    LastManStandingData = {
        ThemeID = "rbxassetid://128206924329556", 
        ThemeProperties = {
            Volume = 1.8
        }, 
        RoundTime = 75
    }, 
    Animations = {
        Idle = "rbxassetid://78316360457839", 
        Walk = "rbxassetid://76406790148345", 
        Run = "rbxassetid://75860288793447", 
        InjuredIdle = "rbxassetid://78316360457839", 
        InjuredWalk = "rbxassetid://76406790148345", 
        InjuredRun = "rbxassetid://75860288793447", 
        Stunned = {
            Start = "rbxassetid://138679230786776", 
            Loop = "rbxassetid://70827891324537", 
            End = "rbxassetid://74361242843808", 
            Cancel = "rbxassetid://132248641730444"
        }, 
        Execution = {
            KillerRig = "rbxassetid://83976183793168", 
            PlayerRig = "rbxassetid://128883910284038", 
            PlayerCFrameOffset = CFrame.Angles(0, 3.141592653589793, 0) * CFrame.new(0, 0, 3)
        }, 
        ExecutionJaneDoe = {
            KillerRig = "rbxassetid://113867319138589", 
            PlayerRig = "rbxassetid://110119432571584"
        }, 
        Slash = "rbxassetid://115517017692371", 
        CorruptEnergy = "rbxassetid://98447162219573", 
        DigitalFootprint = "rbxassetid://105781326773024", 
        Introduction = {
            KillerRig = "rbxassetid://119476049603730", 
            CameraRig = "rbxassetid://140634358360682"
        }, 
        Victory = {
            KillerRig = "rbxassetid://103715079223416", 
            CameraRig = "rbxassetid://98794271647444"
        }
    }, 
    Sounds = {
        Ambience = "rbxassetid://94207556272752", 
        Footsteps = {
            "rbxassetid://126872882914955", 
            "rbxassetid://81544212102472"
        }, 
        TerrorRadiusThemes = {
            [60] = {
                ID = "rbxassetid://83774227185202", 
                BPM = 100
            }, 
            [40] = {
                ID = "rbxassetid://112183456126257", 
                BPM = 100
            }, 
            [20] = {
                ID = "rbxassetid://110494241693405", 
                BPM = 100
            }, 
            [6] = {
                ID = "rbxassetid://90755511989120", 
                BPM = 100, 
                Chase = true
            }
        }, 
        Execution = "rbxassetid://91088178573563", 
        ExecutionJaneDoe = "rbxassetid://91273852978167", 
        StunEnded = "rbxassetid://127453218558340", 
        Swing = "rbxassetid://140242176732868", 
        Hit = "rbxassetid://90819435118493", 
        CorruptEnergy = "rbxassetid://122388551068717", 
        CorruptEnergySummon = "rbxassetid://111388466508150", 
        CorruptEnergyDesummon = "rbxassetid://84267936481619", 
        PuddleStepped = "rbxassetid://128240826870706", 
        DigitalFootprint = "rbxassetid://114243439622992", 
        DigitalFootprintAmbience = "rbxassetid://140163779889034", 
        ["404Error"] = "rbxassetid://117888888155052", 
        ["404ErrorError"] = "rbxassetid://113305896012849", 
        Introduction = "rbxassetid://72636140548768", 
        VictoryTheme = "rbxassetid://122795850954647"
    }
};
v1.Information = {
    {
        Separator = "GENERAL INFO"
    }, 
    {
        Header = "JOHN DOE", 
        Text = "The defunct code of the early days of Roblox courses through their body, consuming his mind as he now only focuses on one thing: to kill everyone in his path. An unstoppable force entering the round with a strategical mindset, he's able to set traps, summon walls to back survivors into a corner, and leave behind a faint trail that damages those who step on it.\n"
    }, 
    {
        Header = "STATS", 
        Text = "Difficulty: \226\152\133\226\152\133\226\152\133\226\152\133\226\152\133\n" .. ("Health: %*\n"):format(v1.Health) .. ("Regular Speed: %*\n"):format(v1.Speed) .. ("Sprinting Speed: %*\n"):format(v1.SprintSpeed) .. ("Max Stamina: %*\n"):format(v1.MaxStamina) .. ("Stamina Loss per sec: %*\n"):format(v1.StaminaLoss) .. ("Stamina Gain per sec: %*\n"):format(v1.StaminaGain) .. "Terror Radius: 60 studs\n"
    }, 
    {
        Separator = "PASSIVES"
    }, 
    {
        Header = "NATURAL MALEVOLENCE", 
        Quote = "\"We\226\128\153re dedicated to building a fun, safe environment where kids of all ages can power their imagination on Roblox.\" - Roblox", 
        Text = "For every step that <font color=\"rgb(248,217,109)\">John Doe</font> takes, a trail of corruption follows behind him.\nAny survivor that's unfortunate enough to step within the corruption is given <b>Corrupted II</b> for 3 seconds.\n"
    }, 
    {
        Header = "UNSTOPPABLE", 
        Quote = "\"Consider this myth busted.\" - Roblox", 
        Text = ("<font color=\"rgb(248,217,109)\">John Doe</font> can only be stunned for %*s while casting Corrupt Energy and 404 Error.\n"):format(v1.UnstoppableDuration) .. "Additionally, <font color=\"rgb(248,217,109)\">John Doe</font> will roar and gain <b>Speed I</b> for 3s upon the stun ending. The duration of the speed boost is increased by 1s for every Sentinel Survivor currently alive.\n" .. "The cooldown of the ability that triggered <b>UNSTOPPABLE</b> is reduced by 50%.\n"
    }, 
    {
        Separator = "ABILITIES"
    }, 
    {
        Header = "SLASH", 
        Image = "rbxassetid://92362553672440", 
        Quote = "\"For many years, there has been lore circulating around John Doe and \226\150\136\226\150\136\226\150\136\226\150\136 Doe within the community.\" - Roblox", 
        Text = ("Cooldown: %*s\n"):format(v1.SlashCooldown) .. ("Damage: %*\n"):format(v1.SlashDamage) .. ("Windup: %*s\n"):format(v1.SlashWindup) .. ("Linger: %*s\n"):format(v1.SlashLinger) .. "Length: 7.5 studs\n" .. "<font color=\"rgb(248,217,109)\">John Doe</font> slashes infront of him using his claws.\n"
    }, 
    {
        Header = "CORRUPT ENERGY", 
        Image = "rbxassetid://83849304758564", 
        Quote = "\"This year, we\226\128\153ve decided that it\226\128\153s time to shed some light about these accounts.\" - Roblox", 
        Text = ("Cooldown: %*s\n"):format(v1.CorruptEnergyCooldown) .. ("Damage: %*\n"):format(v1.CorruptEnergyDamage) .. ("<font color=\"rgb(248,217,109)\">John Doe</font> punches his corrupted arm into the ground and, when he pulls it out, %* giant spikes (that last for %*s) emerge infront of him, piercing through any survivor unfortunate enough to be caught within them.\n"):format(v1.SpikeAmount, v1.SpikeLifetime) .. "Hitting a player with a spike gives <font color=\"rgb(248,217,109)\">John Doe</font> Speed I for 7 seconds.\n" .. ("Summoned spikes cannot damage the same target more than %* times.\n"):format(v1.SpikeHitCap) .. "Press Corrupt Energy again after the cast to Retract active spikes early. Retracting does not restart the original cooldown. These spikes can be used as blockades to prevent survivors from accessing certain areas.\n"
    }, 
    {
        Header = "DIGITAL FOOTPRINT", 
        Image = "rbxassetid://83206360003394", 
        Quote = "\"John Doe and \226\150\136\226\150\136\226\150\136\226\150\136 Doe are two of Roblox\226\128\153s earliest accounts, as seen by their low user IDs here.\" - Roblox", 
        Text = ("Cooldown: %*s\n"):format(v1.DigitalFootprintCooldown) .. "<font color=\"rgb(248,217,109)\">John Doe</font> stomps on the ground three times, commanding a shadow to emerge underneath his footsteps as a trap for survivors to walk over.\n" .. "If a survivor steps over the false shadow, then <font color=\"rgb(248,217,109)\">John Doe</font> gets a <b>Speed I</b> buff for 10 seconds and the survivor gets a <b>Corrupted I</b> & <b>Slowness II</b> debuff for 10 seconds.\n" .. "Upon the trap being triggered, <font color=\"rgb(248,217,109)\">John Doe</font> and the survivor who activated it have their auras revealed to each other for 10 seconds.\n" .. "The shadow despawns after contact is made with it or <font color=\"rgb(248,217,109)\">John Doe</font> attempts to place down a fourth shadow.\n" .. ("There can only be <b>%*</b> shadows present at once, and attempting to create more will cause the oldest shadow to dissipate.\n"):format(v1.DigitalFootprintLimit)
    }, 
    {
        Header = "404 ERROR", 
        Image = "rbxassetid://131116145215571", 
        Quote = "\"Authentic John Doe and \226\150\136\226\150\136\226\150\136\226\150\136 Doe accounts pose no danger to your Roblox account.\" - Roblox", 
        Text = ("Cooldown: %*s\n"):format(v1["404ErrorCooldown"]) .. ("<font color=\"rgb(248,217,109)\">John Doe</font>'s corrupted arm pulsates twice, revealing the auras of all living survivors to him for %* seconds.\n"):format(v1["404ErrorAuraRevealTime"])
    }
};
-- Phase-one rig profiles. Current FCT animations and all balance values are retained.
v1.JohnDoeRigCollision=script.JohnDoeRigCollision
v1.JohnDoeRigQuery=script.JohnDoeRigQuery
v1.JohnDoeRigScale=script:GetAttribute("JohnDoeRigScale") or 1.25
v1.JohnDoeRigPhase="1.0.0"
v1.HipHeight=0
v1.CorruptEnergyPhase="1.0.0"
return v1;]==========],
[ [==========[
ReplicatedStorage/Assets/Killers/JohnDoe/Behavior]==========] ]=[==========[
-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local _ = require(game.ReplicatedStorage.GlobalTypes);
local v1 = {};
local CorruptEnergyController=require(script.CorruptEnergyController);
local RigAlignment=require(script.RigAlignment);
v1.GetRig=function(_,actor) return RigAlignment.GetRig(actor) end;
local l_TweenService_0 = game:GetService("TweenService");
local _ = game:GetService("HttpService");
local l_Players_0 = game:GetService("Players");
local v5 = require(game.ReplicatedStorage.Modules.Sounds);
local v6 = require(game.ReplicatedStorage.Modules.Util);
local v7 = require(game.ReplicatedStorage.Modules.Hitboxes);
local v8 = require(game.ReplicatedStorage.Modules.Statuses);
local v9 = require(game.ReplicatedStorage.Modules.Network);
local v10 = require(game.ReplicatedStorage.Modules.AchievementUtil);
local function v16(v11, v12, v13, ...) --[[ Line: 23 ]] --[[ Name: pcallMethod ]]
    local l_status_0, l_result_0 = pcall(function(...) --[[ Line: 24 ]]
        -- upvalues: v13 (copy), v11 (copy)
        if v13.Behavior[v11] then
            return v13.Behavior[v11](v13.Behavior, v13, ...);
        else
            return;
        end;
    end, ...);
    if not l_status_0 then
        warn((("[%*]: Failed to call .%*() due to: %*"):format(v12, v11, l_result_0)));
    end;
    return l_result_0;
end;
v1.Abilities = {
    Slash = {
        LayoutOrder = 1, 
        Icon = "rbxassetid://92362553672440", 
        KeybindType = "MainAbility", 
        Callback = function(v17) --[[ Line: 42 ]] --[[ Name: Callback ]]
            -- upvalues: v5 (copy), v7 (copy), v6 (copy)
            if game["Run Service"]:IsServer() then
                v17.AbilitiesDisabled = true;
                v5:Play(v17.Config.Sounds.Swing, {
                    Parent = v17.Rig.PrimaryPart, 
                    PlaybackSpeed = Random.new():NextNumber(0.975, 1.025), 
                    Volume = 0.35
                });
                task.delay(v17.Config.SlashWindup, function() --[[ Line: 49 ]]
                    -- upvalues: v7 (ref), v17 (copy), v6 (ref), v5 (ref)
                    local _ = v7:CreateHitbox(v17.Player, { AbilityType = "MainAbility", IsProjectile = false, 
                        Size = Vector3.new(4.5, 6, 7.5, 0), 
                        CFrameOffset = RigAlignment.SlashOffset(v17), 
                        Damage = v17.Config.SlashDamage, 
                        Time = v17.Config.SlashLinger, 
                        Knockback = 2, 
                        HitMultiple = false, 
                        ExecuteOnKill = true, 
                        Connections = {
                            Hit = function(v18, v19) --[[ Line: 61 ]] --[[ Name: Hit ]]
                                -- upvalues: v6 (ref), v5 (ref), v17 (ref)
                                v6:CreateSpeedMultiplier(v18, 1.5, "HitSpeedBonus", 1.25);
                                if v19 then
                                    v5:Play(v17.Config.Sounds.Hit, {
                                        Parent = v17.Rig.PrimaryPart, 
                                        PlaybackSpeed = Random.new():NextNumber(0.975, 1.025), 
                                        Volume = 0.5
                                    });
                                end;
                            end
                        }
                    });
                end);
                task.delay(0.75, function() --[[ Line: 72 ]]
                    -- upvalues: v17 (copy)
                    v17.AbilitiesDisabled = false;
                end);
                return;
            else
                if game["Run Service"]:IsClient() then
                    if v17.Animations.Slash1 then
                        v17.Animations[("Slash%*"):format((tostring(math.random(1, 2))))]:Play(0.025);
                        return;
                    else
                        v17.Animations.Slash:Play(0.025);
                    end;
                end;
                return;
            end;
        end
    }, 
    CorruptEnergy = {
        LayoutOrder=2,Name="Corrupt Energy",Icon="rbxassetid://83849304758564",KeybindType="AltAbility1",
        Cooldown=function(actor)
            return CorruptEnergyController.CanRetract(actor) and 0 or actor.Config.CorruptEnergyCooldown
        end,
        Callback=function(actor,data)
            if game:GetService("RunService"):IsServer() then
                local result=CorruptEnergyController.Cast(actor)
                if not result.Cancelled and not result.Retract then v16("CorruptEnergyStart","JohnDoe/CorruptEnergyStart",actor) end
                return result
            end
            if not (data and data.Retract) then v16("CorruptEnergyStart","JohnDoe/CorruptEnergyStart",actor) end
            return CorruptEnergyController.Play(actor,data)
        end
    },
    DigitalFootprint = {
        LayoutOrder = 3, 
        Icon = "rbxassetid://83206360003394", 
        KeybindType = "AltAbility2", 
        Callback = function(v51, v52) --[[ Line: 311 ]] --[[ Name: Callback ]]
            -- upvalues: v5 (copy), v16 (copy), v6 (copy), v8 (copy), v9 (copy), l_Players_0 (copy)
            local v53 = {
                0.317, 
                1.05, 
                2.067
            };
            local v54 = 0;
            local v55 = 0;
            if game["Run Service"]:IsServer() then
                v51.AbilitiesDisabled = true;
                v5:Play(v51.Config.Sounds.DigitalFootprint, {
                    Parent = v51.Rig.PrimaryPart, 
                    Volume = 0.4, 
                    TimePosition = 0.09, 
                    PlaybackSpeed = 1.2
                });
                v16("DFStart", ("%*/DFS"):format(script.Parent), v51);
                local function v60(v56) --[[ Line: 323 ]] --[[ Name: removeShadow ]]
                    -- upvalues: v6 (ref), v51 (copy)
                    if v56 and v56.Parent then
                        v56.Name = "okByeBye";
                        v56.Parent = workspace.Map.Ingame;
                        game.Debris:AddItem(v56, 5);
                        local l_ShadowAmbience_0 = v56:FindFirstChild("ShadowAmbience");
                        if l_ShadowAmbience_0 then
                            game.TweenService:Create(l_ShadowAmbience_0, TweenInfo.new(2), {
                                Volume = 0
                            }):Play();
                        end;
                        for _, v59 in pairs(v56:GetDescendants()) do
                            if v59:IsA("ParticleEmitter") then
                                v59.Enabled = false;
                            end;
                        end;
                        v6:RemovePlayerAuraFrom(v56, v51.Player);
                    end;
                end;
                local l_FirstChild_0 = workspace.Map.Ingame:FindFirstChild((("%*Shadows"):format((tostring(v51.Player)))));
                if not l_FirstChild_0 then
                    l_FirstChild_0 = Instance.new("Folder");
                    l_FirstChild_0.Name = ("%*Shadows"):format((tostring(v51.Player)));
                    l_FirstChild_0.Parent = workspace.Map.Ingame;
                end;
                local l_l_FirstChild_0_Children_0 = l_FirstChild_0:GetChildren();
                if #l_l_FirstChild_0_Children_0 >= v51.Config.DigitalFootprintLimit then
                    v60(l_l_FirstChild_0_Children_0[1]);
                end;
                local v63 = v51.Config.Shadow:Clone();
                v63.Size = Vector3.new(1, 0, 0, 0);
                v63.Parent = l_FirstChild_0;
                v5:Play(v51.Config.Sounds.DigitalFootprintAmbience, {
                    Parent = v63, 
                    Name = "ShadowAmbience", 
                    RollOffMaxDistance = 30, 
                    Looped = true
                });
                local v64 = RaycastParams.new();
                v64.FilterDescendantsInstances = {
                    workspace.Players, 
                    v63
                };
                v64.FilterType = Enum.RaycastFilterType.Exclude;
                task.delay(tonumber(v53[#v53]) or 2.55, function() --[[ Line: 380 ]]
                    -- upvalues: v6 (ref), v63 (copy), v51 (copy), v60 (copy), v8 (ref), v9 (ref), l_Players_0 (ref)
                    v6:ApplyUnsafeTouched(v63, false, function(_, v66) --[[ Line: 381 ]]
                        -- upvalues: v6 (ref), v51 (ref), v63 (ref), v60 (ref), v8 (ref), v9 (ref), l_Players_0 (ref)
                        local l_Parent_0 = v66.Parent;
                        local v68 = l_Parent_0 and l_Parent_0:FindFirstChild("Humanoid");
                        if v68 and v6:GetEntityType(l_Parent_0) and l_Parent_0 ~= v51.Rig and v68 and v68.Health > 0 and v63.Name == "Shadow" and not l_Parent_0:GetAttribute("ExecutionsDisabled") then
                            v60(v63);
                            v6:RevealPlayerAuraTo(v51.Rig, l_Parent_0, 10);
                            v6:RevealPlayerAuraTo(l_Parent_0, v51.Rig, 10);
                            v8:ApplyStatus(v51.Rig, "Speed", {
                                Level = 1, 
                                Duration = 10
                            });
                            v8:ApplyStatus(l_Parent_0, "Slowness", {
                                Level = 2, 
                                Duration = 10
                            });
                            v8:ApplyStatus(l_Parent_0, "Corrupted", {
                                Level = 1, 
                                Duration = 10, 
                                Killer = v51
                            });
                            if not v51.FootprintRewardDebounce[l_Parent_0] then
                                v51.FootprintRewardDebounce[l_Parent_0] = true;
                                require(game.ReplicatedStorage.Modules.Actors):IncrementActorStats(v51.Player, {
                                    Action = "Survivor stepped into a Digital Footprint trap", 
                                    RewardType = "RegularKillerAction"
                                });
                                task.delay(15, function() --[[ Line: 408 ]]
                                    -- upvalues: v51 (ref), l_Parent_0 (copy)
                                    v51.FootprintRewardDebounce[l_Parent_0] = nil;
                                end);
                            end;
                            v9:FireClientConnection(l_Players_0:GetPlayerFromCharacter(l_Parent_0), ("%*JDPuddleEffect"):format(v51.Player.Name), "REMOTE_EVENT");
                        end;
                    end, 14);
                end);
                task.spawn(function() --[[ Line: 419 ]]
                    -- upvalues: v54 (ref), v63 (copy), v55 (ref), v53 (copy), v51 (copy), v64 (copy), v16 (ref), v9 (ref)
                    while v54 ~= 3 and v63.Parent and v63.Name == "Shadow" do
                        v55 = v55 + game["Run Service"].Heartbeat:Wait();
                        for v69 = #v53, 1, -1 do
                            if v53[v69] and v55 >= v53[v69] then
                                table.remove(v53, v69);
                                v54 = v54 + 1;
                                local l_Position_2 = (v51.Rig.PrimaryPart.CFrame * CFrame.new(-1.1, 0, -2)).Position;
                                local v71 = workspace:Raycast(l_Position_2, Vector3.new(0, -100, 0, 0), v64);
                                v63.Position = (v71 and v71.Position or v51.Rig.PrimaryPart.Position - Vector3.new(0, 2.5, 0, 0)) + Vector3.new(0, 0.5, 0, 0);
                                game.TweenService:Create(v63, TweenInfo.new(1), {
                                    Size = Vector3.new(1, v54 * 6, v54 * 6)
                                }):Play();
                                v16("OnStomp", ("%*/OnStomp"):format(script.Parent), v51, v63, v54);
                                if v54 == 3 then
                                    v9:FireAllClientConnection(("%*OnPuddleRevealed"):format(v51.Player.Name), "REMOTE_EVENT", v63);
                                end;
                            end;
                        end;
                    end;
                end);
                task.delay(3, function() --[[ Line: 446 ]]
                    -- upvalues: v51 (copy)
                    v51.AbilitiesDisabled = false;
                end);
                return v63;
            else
                if game["Run Service"]:IsClient() then
                    v51.Animations.DigitalFootprint:Play(0.025);
                    local l_Connections_0 = v51.Behavior.Connections;
                    if not l_Connections_0.onShadowFolderAdded or not l_Connections_0.onShadowFolderRemoved then
                        local l_FirstChild_1 = workspace.Map.Ingame:FindFirstChild((("%*Shadows"):format((tostring(v51.Player)))));
                        if not l_FirstChild_1 then
                            return;
                        else
                            local l_AbilityContainer_0 = v51.Player.PlayerGui.MainUI:FindFirstChild("AbilityContainer");
                            local v75 = l_AbilityContainer_0 and l_AbilityContainer_0:FindFirstChild("DigitalFootprint");
                            local v76 = 1;
                            do
                                local l_v76_0 = v76;
                                local function v80(v78) --[[ Line: 465 ]] --[[ Name: onShadowChange ]]
                                    -- upvalues: v75 (copy), l_v76_0 (ref), v51 (copy)
                                    if not v75 then
                                        return;
                                    else
                                        l_v76_0 = math.max(0, l_v76_0 + v78);
                                        v75.Charges.Text = l_v76_0 == 0 and "" or l_v76_0;
                                        local v79 = l_v76_0 >= v51.Config.DigitalFootprintLimit;
                                        v75.Charges.TextColor3 = v79 and Color3.new(1, 0, 0) or Color3.new(1, 1, 1);
                                        return;
                                    end;
                                end;
                                v51.Behavior.Connections.onShadowFolderAdded = l_FirstChild_1.ChildAdded:Connect(function(v81) --[[ Line: 477 ]]
                                    -- upvalues: v80 (copy)
                                    if not v81:IsA("BasePart") then
                                        return;
                                    else
                                        v80(1);
                                        return;
                                    end;
                                end);
                                v51.Behavior.Connections.onShadowFolderRemoved = l_FirstChild_1.ChildRemoved:Connect(function(v82) --[[ Line: 485 ]]
                                    -- upvalues: v80 (copy)
                                    if not v82:IsA("BasePart") then
                                        return;
                                    else
                                        v80(-1);
                                        return;
                                    end;
                                end);
                                v80(0);
                            end;
                        end;
                    end;
                    local l_v6_SpeedMultiplier_1 = v6:CreateSpeedMultiplier(v51.Player, 0, "DigitalFootprint");
                    game.Debris:AddItem(l_v6_SpeedMultiplier_1, 3);
                    task.spawn(function() --[[ Line: 501 ]]
                        -- upvalues: v51 (copy), v53 (copy), v55 (ref), v54 (ref), v6 (ref)
                        while v51 and v51.Rig.Parent and v53[1] do
                            v55 = v55 + game["Run Service"].Heartbeat:Wait();
                            for v84 = #v53, 1, -1 do
                                if v53[v84] and v55 >= v53[v84] then
                                    table.remove(v53, v84);
                                    v54 = v54 + 1;
                                    v6:ApplyCameraShake(v54 * 0.2, v54 * 0.375);
                                end;
                            end;
                        end;
                    end);
                    task.delay(3, function() --[[ Line: 517 ]]
                        -- upvalues: v52 (copy), v6 (ref)
                        if not v52 or not v52.Parent then
                            return;
                        else
                            v52.Transparency = 0;
                            v6:RevealPlayerAura(v52, "inf", Color3.new(1, 0.321569, 0.333333), nil, {
                                OutlineTransparency = 0.35, 
                                FillTransparency = 1
                            });
                            return;
                        end;
                    end);
                end;
                return;
            end;
        end
    }, 
    ["404Error"] = {
        Name = "404 Error", 
        LayoutOrder = 4, 
        Icon = "rbxassetid://131116145215571", 
        KeybindType = "AltAbility3", 
        Callback = function(v85) --[[ Line: 537 ]] --[[ Name: Callback ]]
            -- upvalues: v16 (copy), v5 (copy), v6 (copy), v9 (copy)
            v16("ErrorStart", ("%*/404S"):format(script.Parent), v85);
            if game["Run Service"]:IsServer() then
                v85.CurrentAbility = "404Error";
                v85.Config.StunDuration = v85.Config.UnstoppableDuration;
                v85.AbilitiesDisabled = true;
                v5:Play(v85.Config.Sounds["404Error"], {
                    Parent = v85.Rig.PrimaryPart, 
                    Volume = 0.4, 
                    TimePosition = 0.09, 
                    RollOffMaxDistance = 200, 
                    PlaybackSpeed = 1.15
                });
                task.delay(1.625, function() --[[ Line: 550 ]]
                    -- upvalues: v85 (copy)
                    v85.Config.StunDuration = nil;
                    v85.CurrentAbility = nil;
                    v85.AbilitiesDisabled = false;
                end);
                return;
            else
                if game["Run Service"]:IsClient() then
                    local l_v6_SpeedMultiplier_2 = v6:CreateSpeedMultiplier(v85.Player, 1, "404Error");
                    local l_v6_FOVMultiplier_0 = v6:CreateFOVMultiplier(v85.Player, 1, "404Error");
                    game.TweenService:Create(l_v6_SpeedMultiplier_2, TweenInfo.new(0.5), {
                        Value = 0.25
                    }):Play();
                    game.TweenService:Create(l_v6_FOVMultiplier_0, TweenInfo.new(1.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, true), {
                        Value = 0.75
                    }):Play();
                    v9:FireConnection("DisableSprinting", "404Error", true);
                    task.delay(1.2, function() --[[ Line: 567 ]]
                        -- upvalues: v5 (ref), v85 (copy), v9 (ref), l_v6_SpeedMultiplier_2 (copy), l_v6_FOVMultiplier_0 (copy), v6 (ref)
                        v5:Play(v85.Config.Sounds["404ErrorError"], {
                            Parent = v85.Rig.PrimaryPart, 
                            Volume = 0.4, 
                            TimePosition = 0.09, 
                            PlaybackSpeed = Random.new():NextNumber(0.9, 1.1)
                        });
                        v9:FireConnection("DisableSprinting", "404Error", false);
                        game.TweenService:Create(l_v6_SpeedMultiplier_2, TweenInfo.new(0.6), {
                            Value = 1
                        }):Play();
                        game.TweenService:Create(l_v6_FOVMultiplier_0, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                            Value = 1
                        }):Play();
                        game.Debris:AddItem(l_v6_SpeedMultiplier_2, 0.4);
                        game.Debris:AddItem(l_v6_FOVMultiplier_0, 1);
                        for _, v89 in pairs(workspace.Players.Survivors:GetChildren()) do
                            v6:RevealPlayerAura(v89, v85.Config["404ErrorAuraRevealTime"]);
                        end;
                    end);
                end;
                return;
            end;
        end
    }
};
v1.ErrorStart = function(_, _) --[[ Line: 591 ]] --[[ Name: ErrorStart ]]

end;
v1.CorruptEnergyStart = function(_, _) --[[ Line: 595 ]] --[[ Name: CorruptEnergyStart ]]

end;
v1.OnPuddleEpilepsy = function(_, _, _) --[[ Line: 599 ]] --[[ Name: OnPuddleEpilepsy ]]

end;
v1.OnStomp = function(_, _, v99, v100) --[[ Line: 603 ]] --[[ Name: OnStomp ]]
    for _, v102 in pairs(v99:GetDescendants()) do
        if v102:IsA("ParticleEmitter") and v102.Name:find("ShadowPuddle") then
            v102.Enabled = v102.Name == ("ShadowPuddle%*"):format(v100);
        end;
    end;
end;
v1.Created = function(v103, v104) --[[ Line: 611 ]] --[[ Name: Created ]]
    -- upvalues: v10 (copy), v6 (copy), v8 (copy), l_Players_0 (copy), v9 (copy), v5 (copy), l_TweenService_0 (copy), v16 (copy)
    v103.Connections = {};
    if game["Run Service"]:IsServer() then
        if workspace:GetAttribute("JohnDoeSpecialDay") then
            v10:IncrementAchievementProgress(v104.Player, "JohnDoeSpecialDay");
        end;
        local l_Folder_0 = Instance.new("Folder");
        l_Folder_0.Name = "JohnDoeTrail";
        l_Folder_0.Parent = v104.Rig;
        for _ = 1, math.clamp(math.round(v104.Config.TrailLength / 4), 2, 1e999) do
            local v107 = v104.Config.Trail:Clone();
            v107.Position = RigAlignment.TrailPoint(v104,true);
            v107.Parent = l_Folder_0;
            v107:SetAttribute("FinishedUpdating", true);
            v6:ApplyOnTouched(v107, false, function(_, v109) --[[ Line: 635 ]]
                -- upvalues: v8 (ref), v104 (copy)
                local l_Parent_1 = v109.Parent;
                local l_Humanoid_0 = l_Parent_1:FindFirstChild("Humanoid");
                if l_Humanoid_0 and l_Humanoid_0.Health > 0 and l_Parent_1:IsDescendantOf(workspace.Players) and tostring(l_Parent_1.Parent) ~= "Killers" then
                    v8:ApplyStatus(l_Parent_1, "Corrupted", {
                        Duration = 3, 
                        Level = 2, 
                        Killer = v104
                    });
                end;
            end);
        end;
        v104.CurrentSpikes = {};
        v104.FootprintRewardDebounce = {};
        local v112 = false;
        v104.Rig:GetAttributeChangedSignal("Stunned"):Connect(function() --[[ Line: 648 ]]
            -- upvalues: v104 (copy), v112 (ref)
            if v104.Rig:GetAttribute("Stunned") and v104.Config.StunDuration and v104.CurrentAbility and not v112 then
                v112 = true;
                local l_CurrentAbility_0 = v104.CurrentAbility;
                local v114 = v104.Config[l_CurrentAbility_0 .. "Cooldown"];
                if v114 then
                    v104:SetCooldownOf(l_CurrentAbility_0, (math.max(v114 * 0.5, 0)));
                end;
                task.delay(1, function() --[[ Line: 657 ]]
                    -- upvalues: v112 (ref)
                    v112 = false;
                end);
            end;
        end);
        local l_l_Folder_0_Children_0 = l_Folder_0:GetChildren();
        local v116 = 0;
        local v117 = 0;
        local v118 = 0;
        local v119 = nil;
        v119 = game["Run Service"].Heartbeat:Connect(function(v120) --[[ Line: 670 ]]
            -- upvalues: v104 (copy), l_Folder_0 (copy), v119 (ref), v118 (ref), l_Players_0 (ref), v8 (ref), v117 (ref), l_l_Folder_0_Children_0 (copy), v116 (ref)
            if not v104 or not v104.Rig.Parent or not v104.Rig.PrimaryPart then
                l_Folder_0:Destroy();
                v119:Disconnect();
                v119 = nil;
                return;
            else
                if v118 > 1 and #v104.CurrentSpikes > 0 then
                    v118 = 0;
                    local v121 = RaycastParams.new();
                    v121.FilterDescendantsInstances = v104.CurrentSpikes;
                    v121.FilterType = Enum.RaycastFilterType.Include;
                    for _, v123 in (l_Players_0:GetPlayers()) do
                        local l_Character_0 = v123.Character;
                        if l_Character_0 and l_Character_0.Parent then
                            if not l_Character_0 or not l_Character_0.Parent or l_Character_0.Parent.Name == "Killers" then

                            end;
                            local l_Humanoid_1 = l_Character_0:FindFirstChildOfClass("Humanoid");
                            if l_Humanoid_1 or l_Humanoid_1.Health <= 0 then
                                local l_PrimaryPart_0 = l_Character_0.PrimaryPart;
                                local v127 = workspace:Raycast(l_PrimaryPart_0.Position, Vector3.new(0, -5, 0, 0), v121);
                                local v128 = v127 and v127.Instance;
                                if v127 and v128 then
                                    local v129 = v128.Position.Y + v128.Size.Y / 2;
                                    local v130 = RaycastParams.new();
                                    v130.FilterDescendantsInstances = {
                                        l_Character_0, 
                                        v104.CurrentSpikes
                                    };
                                    v130.FilterType = Enum.RaycastFilterType.Exclude;
                                    local v131 = workspace:Raycast(l_PrimaryPart_0.Position, Vector3.new(0, -10, 0, 0), v130);
                                    if v131 then
                                        if v129 - v131.Position.Y >= 1.5 then
                                            v8:ApplyStatus(v123, "Corrupted", {
                                                Level = 2, 
                                                Duration = 5, 
                                                Killer = v104
                                            });
                                        end;
                                    else
                                        v8:ApplyStatus(v123, "Corrupted", {
                                            Level = 2, 
                                            Duration = 5, 
                                            Killer = v104
                                        });
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;
                v118 = v118 + v120;
                if v117 <= 0.05 then
                    v117 = v117 + v120;
                    return;
                else
                    v117 = 0;
                    local v132 = l_l_Folder_0_Children_0[v116 % #l_l_Folder_0_Children_0 + 1];
                    local v133 = l_l_Folder_0_Children_0[(v116 - 1) % #l_l_Folder_0_Children_0 + 1];
                    if v132 and v133 then
                        if v132.Size.Z <= 4 or v132:GetAttribute("FinishedUpdating") then
                            if v132:GetAttribute("FinishedUpdating") then
                                v132:SetAttribute("FinishedUpdating", nil);
                            end;
                            local v134 = RigAlignment.TrailPoint(v104,false);
                            local l_Position_3 = v133:GetPivot().Position;
                            local l_Rotation_0 = CFrame.lookAt(l_Position_3, v134).Rotation;
                            if l_Rotation_0 ~= l_Rotation_0 then
                                warn("currentTrailRotation is NaN, setting rotation to root rotation as fallback");
                                l_Rotation_0 = v104.Rig.PrimaryPart.CFrame.Rotation;
                            end;
                            v132.CFrame = CFrame.new(v133:GetPivot().Position) * l_Rotation_0 * CFrame.Angles(0, 0, 0);
                            v132.Size = Vector3.new(v132.Size.X, v132.Size.Y, (v132.Position - v134).Magnitude);
                            v132.PivotOffset = CFrame.new(0, 0, -v132.Size.Z / 2);
                            v132.CFrame = v132.CFrame * v132.PivotOffset;
                            return;
                        else
                            v132:SetAttribute("FinishedUpdating", true);
                            v116 = v116 + 1;
                            return;
                        end;
                    else
                        v116 = v116 + 1;
                        return;
                    end;
                end;
            end;
        end);
        return;
    else
        if game["Run Service"]:IsClient() then
            v104.ActiveSpikeModels = {};
            if game.Players.LocalPlayer==v104.Player and RigAlignment.IsUpdated(v104.Rig) then
                v104.JohnDoeRigCameraOffset=v6:CreateCameraOffset(v104.Rig,Vector3.new(0,.25,0),"JohnDoeDefault");
            end;
            v9:SetConnection(("%*JDPuddleEffect"):format(v104.Player.Name), "REMOTE_EVENT", function() --[[ Line: 776 ]]
                -- upvalues: v5 (ref), v104 (copy)
                v5:Play(v104.Config.Sounds.PuddleStepped);
            end);
            v9:SetConnection(("%*SpawnSpike"):format(v104.Player.Name), "REMOTE_EVENT", function(v137) --[[ Line: 780 ]]
                -- upvalues: v104 (copy), l_TweenService_0 (ref), v5 (ref)
                local v138 = v104.Config.Spike:Clone();
                local l_Y_0 = v104.Config.SpikeHitboxSize.Y;
                local v140 = Vector3.new(v137.Position.X, v137.Position.Y, v137.Position.Z);
                v138:PivotTo(CFrame.new(v140) * CFrame.Angles(3.141592653589793, math.rad(v137.Rotation), 0) - Vector3.new(0, l_Y_0, 0));
                v138.Parent = workspace.Map.Ingame;
                for _, v142 in (v138:GetDescendants()) do
                    if v142:IsA("BasePart") then
                        v142.CanCollide = false;
                        v142.CanQuery = false;
                        v142.CanTouch = false;
                    end;
                end;
                for _, v144 in (v138:GetDescendants()) do
                    if v144:IsA("ParticleEmitter") and v144.Name == "Number" then
                        v144.Color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0, v104.Config.SpikeNumbersColor), 
                            ColorSequenceKeypoint.new(1, v104.Config.SpikeNumbersColor)
                        });
                    end;
                end;
                l_TweenService_0:Create(v138.PrimaryPart, TweenInfo.new(0.1), {
                    CFrame = v138.PrimaryPart.CFrame + Vector3.new(0, l_Y_0, 0)
                }):Play();
                task.delay(v104.Config.SpikeLifetime, function() --[[ Line: 815 ]]
                    -- upvalues: v138 (copy)
                    if v138.Parent and v138.PrimaryPart then
                        game.Debris:AddItem(v138, 1.5);
                    end;
                end);
                v5:Play(v104.Config.Sounds.CorruptEnergySummon, {
                    Parent = v138.PrimaryPart, 
                    PlaybackSpeed = Random.new():NextNumber(0.8, 1.2), 
                    Volume = 0.25, 
                    TimePosition = 0.02
                });
                v104.ActiveSpikeModels[v137.SpikeUUID] = v138;
            end);
            v9:SetConnection(("%*DesummonSpike"):format(v104.Player.Name), "REMOTE_EVENT", function(v145) --[[ Line: 825 ]]
                -- upvalues: v104 (copy), l_TweenService_0 (ref), v5 (ref)
                local v146 = v104.ActiveSpikeModels[v145];
                if not v146 then
                    return;
                else
                    local l_Y_1 = v104.Config.SpikeHitboxSize.Y;
                    l_TweenService_0:Create(v146.PrimaryPart, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                        CFrame = v146.PrimaryPart.CFrame - Vector3.new(0, l_Y_1 * 2, 0)
                    }):Play();
                    v5:Play(v104.Config.Sounds.CorruptEnergyDesummon, {
                        Parent = v146.PrimaryPart, 
                        PlaybackSpeed = Random.new():NextNumber(0.9, 1.1), 
                        Volume = 0.1, 
                        TimePosition = 0.02
                    });
                    game.Debris:AddItem(v146, 1);
                    v104.ActiveSpikeModels[v145] = nil;
                    return;
                end;
            end);
            v9:SetConnection(("%*OnPuddleRevealed"):format(v104.Player.Name), "REMOTE_EVENT", function(v148) --[[ Line: 848 ]]
                -- upvalues: v16 (ref), v104 (copy)
                local l_PlayerSettings_0 = require(game.ReplicatedStorage.Initializer).PlayerSettings;
                if l_PlayerSettings_0.EpilepsyMode and l_PlayerSettings_0.EpilepsyMode.Value then
                    for _, v151 in (v148:GetDescendants()) do
                        if v151:IsA("ParticleEmitter") and v151:GetAttribute("IsEpilepsy") then
                            v151.Enabled = false;
                        end;
                    end;
                    v16("OnPuddleEpilepsy", ("%*/OnPuddleEpilepsy"):format(script.Parent), v104, v148);
                end;
            end);
            if game.Players.LocalPlayer == v104.Player then
                local v152 = v104.Config.SilencedTag or "JaneDoeSilenced";
                v104.Silencers = {};
                local function v156(v153) --[[ Line: 874 ]] --[[ Name: myWife ]]
                    -- upvalues: v104 (copy)
                    local v154 = v153:WaitForChild("Head", 4);
                    if not v154 or not v104 or not v104.SilencedConnection then
                        return;
                    else
                        local v155 = v104.Config.SilencedTemplate:Clone();
                        v155.Parent = v153;
                        v155.Weld.Part0 = v154;
                        table.insert(v104.Silencers, v155);
                        return;
                    end;
                end;
                v104.SilencedConnection = game.CollectionService:GetInstanceAddedSignal(v152):Connect(v156);
                for _, v158 in ipairs(workspace.Players.Survivors:GetChildren()) do
                    if v158:HasTag(v152) then
                        task.spawn(v156, v158);
                    end;
                end;
            end;
        end;
        return;
    end;
end;
v1.Destroyed = function(v159, v160) --[[ Line: 897 ]] --[[ Name: Destroyed ]]
    if v160.JohnDoeRigCameraOffset then v160.JohnDoeRigCameraOffset:Destroy();v160.JohnDoeRigCameraOffset=nil end;
    -- upvalues: v9 (copy)
    for _, v162 in v159.Connections do
        v162:Disconnect();
        v162 = nil;
    end;
    if game["Run Service"]:IsServer() then
        for _, v164 in v160.CurrentSpikes do
            v164:Destroy();
        end;
        return;
    else
        if game["Run Service"]:IsClient() then
            v9:RemoveConnection(("%*JDPuddleEffect"):format(v160.Player.Name), "REMOTE_EVENT");
            v9:RemoveConnection(("%*SpawnSpike"):format(v160.Player.Name), "REMOTE_EVENT");
            v9:RemoveConnection(("%*DesummonSpike"):format(v160.Player.Name), "REMOTE_EVENT");
            if v160.SilencedConnection then
                v160.SilencedConnection:Disconnect();
                local l_ipairs_0 = ipairs;
                local v166 = v160.Silencers or {};
                for _, v168 in l_ipairs_0(v166) do
                    v168:Destroy();
                end;
            end;
        end;
        return;
    end;
end;
v1.OnIntroduction = function(_, v170, v171, v172) --[[ Line: 923 ]] --[[ Name: OnIntroduction ]]
    -- upvalues: v6 (copy)
    local v173 = nil;
    if v170.Config.useClouds == true then
        v173 = Instance.new("Clouds");
        v173.Cover = 0.774;
        v173.Density = 1;
        v173.Color = Color3.fromRGB(25, 25, 25);
        v173.Parent = workspace:FindFirstChild("Terrain");
        game.Debris:AddItem(v173, v172);
    end;
    local v174 = script.IntroScreen:Clone();
    v174.Main.Title.Text = v170.Config.IntroText:gsub("PLAYERNAME", v170.Player.DisplayName);
    v174.Parent = game.Players.LocalPlayer.PlayerGui;
    game.Debris:AddItem(v174, 1.93333);
    game.TweenService:Create(v174.Main.Title, TweenInfo.new(0.83), {
        TextTransparency = 0
    }):Play();
    task.delay(0.83, function() --[[ Line: 948 ]]
        -- upvalues: v174 (copy), v170 (copy)
        game.TweenService:Create(v174.Main.Title, TweenInfo.new(0.583), {
            TextColor3 = v170.Config.IntroTextColor or Color3.new(1, 0, 0)
        }):Play();
    end);
    task.delay(1, function() --[[ Line: 953 ]]
        -- upvalues: v171 (copy)
        local l_JohnDoeTrail_0 = v171:FindFirstChild("JohnDoeTrail");
        if l_JohnDoeTrail_0 then
            l_JohnDoeTrail_0:Destroy();
        end;
    end);
    local v176 = require(game.ReplicatedStorage.Modules.Schematics.Lighting);
    v176:SetCustomLighting(v170.Config.IntroLighting);
    task.delay(2.717, function() --[[ Line: 963 ]]
        -- upvalues: v173 (ref), v170 (copy)
        if v173 then
            v173.Color = Color3.fromRGB(25, 0, 0);
        end;
        local l_AtmosphereDoe_0 = game.Lighting:FindFirstChild("AtmosphereDoe");
        if l_AtmosphereDoe_0 then
            game.TweenService:Create(l_AtmosphereDoe_0, TweenInfo.new(0.2829, Enum.EasingStyle.Linear), {
                Color = v170.Config.AtmosphereColor or Color3.fromRGB(144, 0, 0), 
                Decay = v170.Config.AtmosphereDecay or Color3.fromRGB(255, 0, 0), 
                Density = 1
            }):Play();
        end;
    end);
    local l_v6_FOVMultiplier_1 = v6:CreateFOVMultiplier(game.Players.LocalPlayer, 0.35, "JohnDoeIntroScene");
    task.delay(2.75, function() --[[ Line: 979 ]]
        -- upvalues: l_v6_FOVMultiplier_1 (copy)
        game.TweenService:Create(l_v6_FOVMultiplier_1, TweenInfo.new(0.25), {
            Value = 0.95
        }):Play();
    end);
    task.delay(v172, function() --[[ Line: 984 ]]
        -- upvalues: v176 (copy), l_v6_FOVMultiplier_1 (copy), v174 (copy), v173 (ref)
        v176:SetAsCurrentLighting();
        l_v6_FOVMultiplier_1:Destroy();
        v174:Destroy();
        if v173 then
            v173:Destroy();
        end;
    end);
end;
v1.OnVictory = function(_, v180, v181, _, _) --[[ Line: 994 ]] --[[ Name: OnVictory ]]
    -- upvalues: v6 (copy), l_TweenService_0 (copy)
    local v184 = require(game.ReplicatedStorage.Modules.Schematics.Lighting);
    if v180 == "Start" then
        v184:SetCustomLighting(v181.Config.IntroLighting);
        local l_v6_FOVMultiplier_2 = v6:CreateFOVMultiplier(game.Players.LocalPlayer, 1.1325, "JohnDoeOutroScene");
        game.Debris:AddItem(l_v6_FOVMultiplier_2, 30);
        task.spawn(function() --[[ Line: 1005 ]]
            -- upvalues: v181 (copy), v6 (ref)
            local v186 = os.clock();
            local v187 = workspace.Misc:WaitForChild("KillerCutsceneBackground", 5);
            if v187 and v187.PrimaryPart then
                local v188 = v181.Config.OutroDummy:Clone();
                v188.Name = "OutroVictim";
                v188.PrimaryPart.Anchored = true;
                v188:SetPrimaryPartCFrame(v187.PrimaryPart.CFrame);
                v188.Parent = v187;
                local v189 = v6:LoadAnimationFromID(v188, "rbxassetid://135006397147596", true);
                v189:Play(0);
                v189.TimePosition = os.clock() - v186;
                v189.Stopped:Once(function() --[[ Line: 1020 ]]
                    -- upvalues: v188 (copy)
                    for _, v191 in ipairs(v188:GetDescendants()) do
                        if v191:IsA("BasePart") then
                            v191.Anchored = true;
                        end;
                    end;
                end);
                local v192 = false;
                for _, v194 in ipairs({
                    "Shirt", 
                    "Pants", 
                    "Accessory", 
                    "Hat"
                }) do
                    if v188:FindFirstChildOfClass(v194) then
                        v192 = true;
                        break;
                    end;
                end;
                if not v192 then
                    pcall(function() --[[ Line: 1033 ]]
                        -- upvalues: v181 (ref), v188 (copy)
                        local l_HumanoidDescriptionFromUserId_0 = game.Players:GetHumanoidDescriptionFromUserId(v181.Player.UserId);
                        v188.Humanoid:ApplyDescription(l_HumanoidDescriptionFromUserId_0, Enum.AssetTypeVerification.Always);
                    end);
                end;
            end;
        end);
        task.delay(2.4, function() --[[ Line: 1042 ]]
            -- upvalues: l_TweenService_0 (ref), v181 (copy)
            local v196 = Instance.new("ColorCorrectionEffect", game.Lighting);
            v196.Name = "JohnDoeStabCC";
            local v197 = l_TweenService_0:Create(v196, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
                Contrast = 0.4, 
                Brightness = 0.1
            });
            v197:Play();
            task.wait(0.4);
            v197:Pause();
            v196.Brightness = 0.8;
            v196.Contrast = 0.3;
            v196.TintColor = v181.Config.OutroTintColor or Color3.new(0.631373, 0.0784314, 0.0901961);
            l_TweenService_0:Create(v196, TweenInfo.new(2.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
                TintColor = Color3.new(0.196078, 0.196078, 0.196078), 
                Brightness = -1, 
                Contrast = -0.5, 
                Saturation = -1
            }):Play();
        end);
        return;
    else
        if v180 == "End" then
            v184:SetAsCurrentLighting();
            local l_v6_FOVMultiplier_3 = v6:CreateFOVMultiplier(game.Players.LocalPlayer, 1, "JohnDoeOutroScene");
            game.Debris:AddItem(l_v6_FOVMultiplier_3, 1);
            local v199 = game.Lighting:WaitForChild("JohnDoeStabCC", 8);
            if v199 then
                v199:Destroy();
            end;
        end;
        return;
    end;
end;
v1.OnExecution = function(_, v201, v202) --[[ Line: 1106 ]] --[[ Name: OnExecution ]]
    local l_Humanoid_2 = v202:FindFirstChild("Humanoid");
    local v204 = require(game.ReplicatedStorage.Modules.Ragdolls);
    local v205 = (v201.Rig.PrimaryPart.CFrame.LookVector + Vector3.new(0, 0.5, 0, 0)) * 40;
    local l_Axe_0 = v202:FindFirstChild("Axe");
    local l_BackAxe_0 = v202:FindFirstChild("BackAxe");
    if v202.Name == "JaneDoe" then
        l_Axe_0.Transparency = 0;
        l_BackAxe_0.Transparency = 1;
        task.delay(2.85, function() --[[ Line: 1118 ]]
            -- upvalues: v204 (copy), v202 (copy), v205 (copy), l_Humanoid_2 (copy)
            v204.AddProfile(v202, {
                Velocity = v205, 
                KillEffects = {
                    Explode = true
                }
            });
            if l_Humanoid_2 then
                l_Humanoid_2.BreakJointsOnDeath = true;
                l_Humanoid_2.Health = 0;
            end;
        end);
        return;
    else
        task.delay(0.666, function() --[[ Line: 1128 ]]
            -- upvalues: v204 (copy), v202 (copy), v205 (copy)
            v204.AddProfile(v202, {
                AnchorDelay = true, 
                Applied = os.clock() + 5, 
                Velocity = v205
            });
            local l_Humanoid_3 = v202:FindFirstChild("Humanoid");
            if l_Humanoid_3 then
                l_Humanoid_3.BreakJointsOnDeath = false;
                l_Humanoid_3.Health = 0;
            end;
        end);
        task.delay(1.98, function() --[[ Line: 1137 ]]
            -- upvalues: v202 (copy)
            if v202 and v202.PrimaryPart then
                v202.PrimaryPart.Anchored = false;
            end;
        end);
        return;
    end;
end;
local previousCreated=v1.Created
local previousDestroyed=v1.Destroyed
v1.Created=function(self,actor)
 previousCreated(self,actor)
 CorruptEnergyController.Created(actor)
end
v1.Destroyed=function(self,actor)
 CorruptEnergyController.Destroyed(actor)
 previousDestroyed(self,actor)
end
return v1;]==========],
[ [==========[
ReplicatedStorage/Assets/Killers/JohnDoe/Behavior/CorruptEnergyController]==========] ]=[==========[
return require(game:GetService("RunService"):IsServer() and script.Server or script.Client)
]==========],
[ [==========[
ReplicatedStorage/Assets/Killers/JohnDoe/Behavior/CorruptEnergyController/Server]==========] ]=[==========[
local RunService=game:GetService("RunService")
local TweenService=game:GetService("TweenService")
local Debris=game:GetService("Debris")
local Modules=game.ReplicatedStorage.Modules
local Hitboxes=require(Modules.Hitboxes)
local Network=require(Modules.Network)
local Util=require(Modules.Util)
local Sounds=require(Modules.Sounds)
local Statuses=require(Modules.Statuses)
local Actors=require(Modules.Actors)
local Rules=require(script.Parent.Rules)
local Server={}
local function alive(a)
 local hum=a.Rig and a.Rig:FindFirstChildOfClass("Humanoid")
 return not a.JDCEDestroyed and a.Rig and a.Rig.Parent and a.Rig.PrimaryPart and hum and hum.Health>0
end
local function blocked(a)
 local r=a.Rig
 return r:GetAttribute("Stunned") or r:GetAttribute("Helpless") or r:GetAttribute("Ragdolling") or r:GetAttribute("AbilitiesDisabled") or r.PrimaryPart.Anchored
end
local function broadcast(a,kind,data)
 Network:FireAllClientConnection(a.Player.Name..kind,"REMOTE_EVENT",data)
end
local function sound(a,name,parent)
 local id=a.Config.Sounds and a.Config.Sounds[name]
 if id and parent then pcall(Sounds.Play,Sounds,id,{Parent=parent,Volume=.4}) end
end
function Server.CanRetract(a)
 local c=a.JDCECast
 return c and c.active and not c.casting and c.live>0 or false
end
local function refresh(a)
 if a.Rig and a.Rig.Parent then a.Rig:SetAttribute("JDCanRetract",Server.CanRetract(a)) end
end
local function release(a,c)
 if not c.casting then return end
 c.casting=false
 if c.slow then c.slow:Destroy();c.slow=nil end
 a.AbilityDisablers.JohnCorruptEnergy=nil
 if a.CurrentAbility=="CorruptEnergy" then a.CurrentAbility=nil;a.Config.StunDuration=c.previousStunDuration end
 refresh(a)
end
local function removeSpike(a,c,s,immediate)
 if not s.live then return end
 s.live=false;c.live-=1
 if s.hitbox and s.hitbox.Cancel then s.hitbox:Cancel() end
 if s.rise then s.rise:Cancel() end
 local index=table.find(a.CurrentSpikes,s.part)
 if index then table.remove(a.CurrentSpikes,index) end
 broadcast(a,"DesummonSpike",s.id)
 if s.part.Parent then
  s.part.CanCollide=false;s.part.CanTouch=false
  if immediate then s.part:Destroy()
  else
   TweenService:Create(s.part,TweenInfo.new(1,Enum.EasingStyle.Quad,Enum.EasingDirection.In),{CFrame=s.part.CFrame-Vector3.new(0,a.Config.SpikeHitboxSize.Y*2,0)}):Play()
   Debris:AddItem(s.part,1.05)
  end
 end
 refresh(a)
end
local function clear(a,immediate)
 local c=a.JDCECast
 if not c then return end
 c.active=false;release(a,c)
 for _,s in ipairs(c.spikes) do removeSpike(a,c,s,immediate) end
 a.JDCECast=nil;refresh(a)
end
local function reward(a,target)
 local hum=target:FindFirstChildOfClass("Humanoid")
 if not hum then return end
 if hum.Health>0 then
  Util:CreateSpeedMultiplier(target,1.5,"HitSpeedBonus",1.25)
  Statuses:ApplyStatus(a.Rig,"Speed",{Level=1,Duration=7})
  Util:RevealPlayerAuraTo(a.Player,target,2.5)
 end
 if target.Parent and target.Parent.Name=="Survivors" then
  Actors:IncrementActorStats(a.Player,{Action=hum.Health<=0 and "Killed a Survivor with Corrupt Energy" or "Damaged a Survivor with Corrupt Energy",RewardType=hum.Health<=0 and "DifficultKillerAction" or "EasyKillerAction"})
 end
 if hum.Health<=0 then
  local achievement=require(Modules.AchievementUtil)
  achievement:IncrementAchievementProgress(a.Player,"JohnDoeSpikes")
 end
end
local function spawnSpike(a,c,index,now)
 if not c.active or c.interrupted or not alive(a) then return end
 local params=RaycastParams.new();params.FilterType=Enum.RaycastFilterType.Exclude;params.FilterDescendantsInstances={workspace.Players}
 local point=(a:GetPivot()*CFrame.new(0,0,-a.Config.DistanceBetweenSpikes*index)).Position
 local hit=workspace:Raycast(point,Vector3.new(0,-100,0),params) or workspace:Raycast(point,Vector3.new(0,100,0),params)
 if not hit then return end
 local size=a.Config.SpikeHitboxSize
 local rotation=math.random(0,360)
 local data={Position=hit.Position,Rotation=rotation,SpikeUUID=tostring(c.serial)..":"..index}
 local part=Instance.new("Part");part.Name="SpikeCollision";part.Size=size;part.Transparency=1
 part.Anchored=true;part.CanTouch=false;part.CanCollide=true;part.CustomPhysicalProperties=a.Config.SpikeProperties
 local from=CFrame.new(hit.Position)*CFrame.Angles(0,math.rad(rotation),math.pi/2)-Vector3.new(0,size.Y,0)
 part.CFrame=from;part.Parent=workspace.Map.Ingame
 local s={part=part,id=data.SpikeUUID,live=true,expires=now+a.Config.SpikeLifetime}
 table.insert(c.spikes,s);table.insert(a.CurrentSpikes,part);c.live+=1
 s.rise=TweenService:Create(part,TweenInfo.new(.1,Enum.EasingStyle.Linear),{CFrame=from+Vector3.new(0,size.Y*2,0)})
 s.rise:Play();broadcast(a,"SpawnSpike",data)
 s.hitbox=Hitboxes:CreateHitbox(a.Player,{
  AbilityType="CorruptEnergy",IsProjectile=false,Size=size,CFrame=function()return part.CFrame end,
  Damage=a.Config.CorruptEnergyDamage,Time=.15,Knockback=5,HitMultiple=true,PredictVelocity=false,CastPoint=false,
  -- Reject before damage, block reactions, knockback, or hit callbacks. Reservation is atomic across spikes.
  HitFilter=function(target)
   return s.live and alive(a) and Rules.ReserveHit(c,target,a.Config.SpikeHitCap)
  end,
  Connections={Hit=function(target,first)
   reward(a,target)
   if first then sound(a,"Hit",a.Rig.PrimaryPart) end
  end}
 })
 refresh(a)
end
local function step(a)
 if not alive(a) then Server.Destroyed(a);return end
 local c=a.JDCECast
 if not c then return end
 local now=os.clock()
 if c.casting then
  if blocked(a) then c.interrupted=true;release(a,c)
  else
   while c.next<=a.Config.SpikeAmount and now-c.started>=Rules.SpawnAt(c.next,a.Config.DelayBetweenSpikeSummons) do
    local index=c.next;c.next+=1;spawnSpike(a,c,index,now)
   end
   if now-c.started>=math.max(3.5,Rules.SpawnAt(a.Config.SpikeAmount,a.Config.DelayBetweenSpikeSummons)+.1) then release(a,c) end
  end
 end
 for _,s in ipairs(c.spikes) do if s.live and (not s.part.Parent or now>=s.expires) then removeSpike(a,c,s,not s.part.Parent) end end
 if not c.casting and c.live==0 then c.active=false;a.JDCECast=nil;refresh(a) end
end
function Server.Cast(a)
 if not alive(a) or blocked(a) then return {Cancelled=true} end
 if Server.CanRetract(a) then clear(a,false);return {Retract=true} end
 if a.JDCECast and a.JDCECast.casting then return {Cancelled=true} end
 clear(a,true)
 a.JDCESerial=(a.JDCESerial or 0)+1
 local c={serial=a.JDCESerial,active=true,casting=true,started=os.clock(),next=1,live=0,spikes={},hits={},previousStunDuration=a.Config.StunDuration}
 a.JDCECast=c;a.AbilityDisablers=a.AbilityDisablers or {};a.AbilityDisablers.JohnCorruptEnergy=true
 a.CurrentAbility="CorruptEnergy";a.Config.StunDuration=a.Config.UnstoppableDuration
 c.slow=Util:CreateSpeedMultiplier(a.Player,.001,"JohnCorruptEnergyCast")
 sound(a,"CorruptEnergy",a.Rig.PrimaryPart);refresh(a)
 return {Retract=false}
end
function Server.Created(a)
 a.JDCEDestroyed=false;a.JDCEConnections={};a.CurrentSpikes=a.CurrentSpikes or {}
 local original=a.CanUseAbility;a.JDCEOriginalCanUse=original
 local function canUse(self,name)
  if name~="CorruptEnergy" or not Server.CanRetract(a) then return original(self,name) end
  -- Keep every ordinary lock/check; bypass only this actor's existing CE cooldown for Retract.
  local cooldown=a.Cooldowns.CorruptEnergy;a.Cooldowns.CorruptEnergy=nil
  local ok,result=pcall(original,self,name)
  a.Cooldowns.CorruptEnergy=cooldown
  if not ok then error(result) end
  return result
 end
 a.CanUseAbility=canUse;a.JDCECanUseWrapper=canUse
 table.insert(a.JDCEConnections,RunService.Heartbeat:Connect(function()step(a)end))
 table.insert(a.JDCEConnections,a.Rig:GetAttributeChangedSignal("Stunned"):Connect(function()
  if a.Rig:GetAttribute("Stunned") and a.JDCECast and a.JDCECast.casting then a.JDCECast.interrupted=true;release(a,a.JDCECast) end
 end))
 table.insert(a.JDCEConnections,a.Rig:FindFirstChildOfClass("Humanoid").Died:Connect(function()Server.Destroyed(a)end))
 refresh(a)
end
function Server.Destroyed(a)
 if a.JDCEDestroyed then return end
 a.JDCEDestroyed=true;clear(a,true)
 for _,connection in ipairs(a.JDCEConnections or {}) do connection:Disconnect() end
 a.JDCEConnections={}
 if a.CanUseAbility==a.JDCECanUseWrapper then a.CanUseAbility=a.JDCEOriginalCanUse end
end
return Server
]==========],
[ [==========[
ReplicatedStorage/Assets/Killers/JohnDoe/Behavior/CorruptEnergyController/Client]==========] ]=[==========[
local RunService=game:GetService("RunService")
local Players=game:GetService("Players")
local Util=require(game.ReplicatedStorage.Modules.Util)
local Client={}
function Client.CanRetract(a) return a.Rig and a.Rig:GetAttribute("JDCanRetract")==true end
local function update(a)
 local ability=a.Behavior.Abilities.CorruptEnergy
 local retract=Client.CanRetract(a)
 ability.Name=retract and "Retract" or "Corrupt Energy"
 ability.Icon=retract and "rbxassetid://105853980040304" or "rbxassetid://83849304758564"
 -- FCT keeps counting the original cooldown; only its rendering is suppressed while Retract is available.
 ability.Disabled=retract or a.JDCEOriginalDisabled
 local main=a.Player:FindFirstChildOfClass("PlayerGui")
 main=main and main:FindFirstChild("MainUI")
 local hotbar=main and main:FindFirstChild("AbilityContainer")
 local button=hotbar and hotbar:FindFirstChild("CorruptEnergy")
 if retract and button then
  button.Image=ability.Icon
  if button:FindFirstChild("AbilityName") then button.AbilityName.Text=ability.Name end
  if button:FindFirstChild("CooldownTime") then button.CooldownTime.Text="" end
  if button:FindFirstChild("Clipping") then
   button.Clipping.Size=UDim2.fromScale(1,1)
   button.Clipping.Top.Size=UDim2.fromScale(1,1);button.Clipping.Top.Image=ability.Icon
  end
 end
end
local function windup(a)
 local state=a.JDCEClientWindup
 if not state then return end
 local times={1.067,1.917}
 while state.next<=#times and os.clock()-state.started>=times[state.next] do
  local stage=state.next;state.next+=1
  pcall(Util.ApplyCameraShake,Util,stage*.2,stage*.35)
 end
 if state.next>#times then a.JDCEClientWindup=nil end
end
function Client.Play(a,data)
 if data and data.Retract then return end
 a.JDCEClientWindup={started=os.clock(),next=1}
 local animation=a.Animations and a.Animations.CorruptEnergy
 if animation then pcall(function()animation:Play(.025)end) end
end
function Client.Created(a)
 if a.Player~=Players.LocalPlayer then return end
 a.JDCEClientConnections={};a.JDCEOriginalDisabled=a.Behavior.Abilities.CorruptEnergy.Disabled
  a.JDCEClientConnections[1]=a.Rig:GetAttributeChangedSignal("JDCanRetract"):Connect(function()update(a)end)
 a.JDCEClientConnections[2]=RunService.RenderStepped:Connect(function()update(a);windup(a)end)
 a.JDCEClientConnections[3]=a.Rig:GetAttributeChangedSignal("Stunned"):Connect(function()
  if a.Rig:GetAttribute("Stunned") then
   a.JDCEClientWindup=nil
   local track=a.Animations and a.Animations.CorruptEnergy
   if track then pcall(function()track:Stop(.05)end) end
  end
 end)
 update(a)
end
function Client.Destroyed(a)
 a.JDCEClientWindup=nil
 for _,model in pairs(a.ActiveSpikeModels or {}) do model:Destroy() end
 a.ActiveSpikeModels={}
 for _,connection in ipairs(a.JDCEClientConnections or {}) do connection:Disconnect() end
 a.JDCEClientConnections={}
 if a.Behavior and a.Behavior.Abilities and a.Behavior.Abilities.CorruptEnergy then
  local ability=a.Behavior.Abilities.CorruptEnergy;ability.Disabled=a.JDCEOriginalDisabled;ability.Name="Corrupt Energy";ability.Icon="rbxassetid://83849304758564"
 end
end
return Client
]==========],
[ [==========[
ReplicatedStorage/Assets/Killers/JohnDoe/Behavior/CorruptEnergyController/Rules]==========] ]=[==========[
local Rules={}
function Rules.ReserveHit(cast,target,cap)
 if not cast.active then return false end
 local hits=cast.hits[target] or 0
 if hits>=cap then return false end
 cast.hits[target]=hits+1
 return true
end
function Rules.SpawnAt(index,interval) return 2+index*interval end
return Rules
]==========],
[ [==========[
ServerStorage/Assets/Killers/JohnDoe/Config]==========] ]=[==========[
-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local l_workspace_Attribute_0 = workspace:GetAttribute("JohnDoeSpecialDay");
local v1 = {
    DisplayName = "John Doe", 
    Quote = l_workspace_Attribute_0 and "dude i told you not to play on march 18th" or "DON'T PLAY ROBLOX ON MARCH 18TH?!?!", 
    Credits = "c2o, BakedMesh, koekonaut, 89M and BirdieCandles", 
    RenderImage = l_workspace_Attribute_0 and "rbxassetid://125927083463034" or "rbxassetid://106220250803658", 
    Price = l_workspace_Attribute_0 and 318 or 1000, 
    Health = l_workspace_Attribute_0 and 3182026 or 1500, 
    Speed = l_workspace_Attribute_0 and 11.3182026 or 9, 
    IntroText = "They're all yours, Mr. Doe", 
    SprintSpeed = l_workspace_Attribute_0 and 27.53182026 or 27.25, 
    StaminaLoss = 9.5, 
    StaminaGain = 21, 
    MaxStamina = l_workspace_Attribute_0 and 115.3182026 or 110, 
    SlashDamage = l_workspace_Attribute_0 and 45.3182026 or 28, 
    SlashCooldown = l_workspace_Attribute_0 and 2.3182026 or 1.75, 
    SlashWindup = 0.4, 
    SlashLinger = 0.25, 
    CorruptEnergyDamage = l_workspace_Attribute_0 and 16.3182026 or 11, 
    CorruptEnergyCooldown = l_workspace_Attribute_0 and 40.3182026 or 18, 
    SpikeAmount = l_workspace_Attribute_0 and 256 or 31, 
    SpikeHitboxSize = Vector3.new(11, 5, 5, 0), 
    SpikeLifetime = l_workspace_Attribute_0 and 18.3182026 or 14, 
    SpikeHitCap = l_workspace_Attribute_0 and 3182026 or 2, 
    SpikeProperties = PhysicalProperties.new(0.2, 2, 0, 100, 100), 
    DelayBetweenSpikeSummons = l_workspace_Attribute_0 and 0.02 or 0.045, 
    DistanceBetweenSpikes = 4, 
    DigitalFootprintCooldown = 3, 
    DigitalFootprintLimit = l_workspace_Attribute_0 and 4 or 3, 
    ["404ErrorAuraRevealTime"] = l_workspace_Attribute_0 and 10.3182026 or 6, 
    ["404ErrorCooldown"] = 20, 
    Spike = script.Spike, 
    Shadow = script.Shadow, 
    Trail = script.Trail, 
    SpikeNumbersColor = Color3.fromRGB(255, 0, 0), 
    TrailLength = l_workspace_Attribute_0 and 356 or 48, 
    UnstoppableDuration = 2, 
    SilencedTemplate = script.NAN, 
    Silenced = true, 
    OutroDummy = script.OutroVictim, 
    useClouds = true, 
    Relations = {
        "JaneDoe"
    }, 
    LastManStandingEmotionalData = {
        ThemeID = "rbxassetid://90004798416076", 
        RoundTime = 99
    }, 
    LastManStandingData = {
        ThemeID = "rbxassetid://128206924329556", 
        ThemeProperties = {
            Volume = 1.8
        }, 
        RoundTime = 75
    }, 
    Animations = {
        Idle = "rbxassetid://78316360457839", 
        Walk = "rbxassetid://76406790148345", 
        Run = "rbxassetid://75860288793447", 
        InjuredIdle = "rbxassetid://78316360457839", 
        InjuredWalk = "rbxassetid://76406790148345", 
        InjuredRun = "rbxassetid://75860288793447", 
        Stunned = {
            Start = "rbxassetid://138679230786776", 
            Loop = "rbxassetid://70827891324537", 
            End = "rbxassetid://74361242843808", 
            Cancel = "rbxassetid://132248641730444"
        }, 
        Execution = {
            KillerRig = "rbxassetid://83976183793168", 
            PlayerRig = "rbxassetid://128883910284038", 
            PlayerCFrameOffset = CFrame.Angles(0, 3.141592653589793, 0) * CFrame.new(0, 0, 3)
        }, 
        ExecutionJaneDoe = {
            KillerRig = "rbxassetid://113867319138589", 
            PlayerRig = "rbxassetid://110119432571584"
        }, 
        Slash = "rbxassetid://115517017692371", 
        CorruptEnergy = "rbxassetid://98447162219573", 
        DigitalFootprint = "rbxassetid://105781326773024", 
        Introduction = {
            KillerRig = "rbxassetid://119476049603730", 
            CameraRig = "rbxassetid://140634358360682"
        }, 
        Victory = {
            KillerRig = "rbxassetid://103715079223416", 
            CameraRig = "rbxassetid://98794271647444"
        }
    }, 
    Sounds = {
        Ambience = "rbxassetid://94207556272752", 
        Footsteps = {
            "rbxassetid://126872882914955", 
            "rbxassetid://81544212102472"
        }, 
        TerrorRadiusThemes = {
            [60] = {
                ID = "rbxassetid://83774227185202", 
                BPM = 100
            }, 
            [40] = {
                ID = "rbxassetid://112183456126257", 
                BPM = 100
            }, 
            [20] = {
                ID = "rbxassetid://110494241693405", 
                BPM = 100
            }, 
            [6] = {
                ID = "rbxassetid://90755511989120", 
                BPM = 100, 
                Chase = true
            }
        }, 
        Execution = "rbxassetid://91088178573563", 
        ExecutionJaneDoe = "rbxassetid://91273852978167", 
        StunEnded = "rbxassetid://127453218558340", 
        Swing = "rbxassetid://140242176732868", 
        Hit = "rbxassetid://90819435118493", 
        CorruptEnergy = "rbxassetid://122388551068717", 
        CorruptEnergySummon = "rbxassetid://111388466508150", 
        CorruptEnergyDesummon = "rbxassetid://84267936481619", 
        PuddleStepped = "rbxassetid://128240826870706", 
        DigitalFootprint = "rbxassetid://114243439622992", 
        DigitalFootprintAmbience = "rbxassetid://140163779889034", 
        ["404Error"] = "rbxassetid://117888888155052", 
        ["404ErrorError"] = "rbxassetid://113305896012849", 
        Introduction = "rbxassetid://72636140548768", 
        VictoryTheme = "rbxassetid://122795850954647"
    }
};
v1.Information = {
    {
        Separator = "GENERAL INFO"
    }, 
    {
        Header = "JOHN DOE", 
        Text = "The defunct code of the early days of Roblox courses through their body, consuming his mind as he now only focuses on one thing: to kill everyone in his path. An unstoppable force entering the round with a strategical mindset, he's able to set traps, summon walls to back survivors into a corner, and leave behind a faint trail that damages those who step on it.\n"
    }, 
    {
        Header = "STATS", 
        Text = "Difficulty: \226\152\133\226\152\133\226\152\133\226\152\133\226\152\133\n" .. ("Health: %*\n"):format(v1.Health) .. ("Regular Speed: %*\n"):format(v1.Speed) .. ("Sprinting Speed: %*\n"):format(v1.SprintSpeed) .. ("Max Stamina: %*\n"):format(v1.MaxStamina) .. ("Stamina Loss per sec: %*\n"):format(v1.StaminaLoss) .. ("Stamina Gain per sec: %*\n"):format(v1.StaminaGain) .. "Terror Radius: 60 studs\n"
    }, 
    {
        Separator = "PASSIVES"
    }, 
    {
        Header = "NATURAL MALEVOLENCE", 
        Quote = "\"We\226\128\153re dedicated to building a fun, safe environment where kids of all ages can power their imagination on Roblox.\" - Roblox", 
        Text = "For every step that <font color=\"rgb(248,217,109)\">John Doe</font> takes, a trail of corruption follows behind him.\nAny survivor that's unfortunate enough to step within the corruption is given <b>Corrupted II</b> for 3 seconds.\n"
    }, 
    {
        Header = "UNSTOPPABLE", 
        Quote = "\"Consider this myth busted.\" - Roblox", 
        Text = ("<font color=\"rgb(248,217,109)\">John Doe</font> can only be stunned for %*s while casting Corrupt Energy and 404 Error.\n"):format(v1.UnstoppableDuration) .. "Additionally, <font color=\"rgb(248,217,109)\">John Doe</font> will roar and gain <b>Speed I</b> for 3s upon the stun ending. The duration of the speed boost is increased by 1s for every Sentinel Survivor currently alive.\n" .. "The cooldown of the ability that triggered <b>UNSTOPPABLE</b> is reduced by 50%.\n"
    }, 
    {
        Separator = "ABILITIES"
    }, 
    {
        Header = "SLASH", 
        Image = "rbxassetid://92362553672440", 
        Quote = "\"For many years, there has been lore circulating around John Doe and \226\150\136\226\150\136\226\150\136\226\150\136 Doe within the community.\" - Roblox", 
        Text = ("Cooldown: %*s\n"):format(v1.SlashCooldown) .. ("Damage: %*\n"):format(v1.SlashDamage) .. ("Windup: %*s\n"):format(v1.SlashWindup) .. ("Linger: %*s\n"):format(v1.SlashLinger) .. "Length: 7.5 studs\n" .. "<font color=\"rgb(248,217,109)\">John Doe</font> slashes infront of him using his claws.\n"
    }, 
    {
        Header = "CORRUPT ENERGY", 
        Image = "rbxassetid://83849304758564", 
        Quote = "\"This year, we\226\128\153ve decided that it\226\128\153s time to shed some light about these accounts.\" - Roblox", 
        Text = ("Cooldown: %*s\n"):format(v1.CorruptEnergyCooldown) .. ("Damage: %*\n"):format(v1.CorruptEnergyDamage) .. ("<font color=\"rgb(248,217,109)\">John Doe</font> punches his corrupted arm into the ground and, when he pulls it out, %* giant spikes (that last for %*s) emerge infront of him, piercing through any survivor unfortunate enough to be caught within them.\n"):format(v1.SpikeAmount, v1.SpikeLifetime) .. "Hitting a player with a spike gives <font color=\"rgb(248,217,109)\">John Doe</font> Speed I for 7 seconds.\n" .. ("Summoned spikes cannot damage the same target more than %* times.\n"):format(v1.SpikeHitCap) .. "Press Corrupt Energy again after the cast to Retract active spikes early. Retracting does not restart the original cooldown. These spikes can be used as blockades to prevent survivors from accessing certain areas.\n"
    }, 
    {
        Header = "DIGITAL FOOTPRINT", 
        Image = "rbxassetid://83206360003394", 
        Quote = "\"John Doe and \226\150\136\226\150\136\226\150\136\226\150\136 Doe are two of Roblox\226\128\153s earliest accounts, as seen by their low user IDs here.\" - Roblox", 
        Text = ("Cooldown: %*s\n"):format(v1.DigitalFootprintCooldown) .. "<font color=\"rgb(248,217,109)\">John Doe</font> stomps on the ground three times, commanding a shadow to emerge underneath his footsteps as a trap for survivors to walk over.\n" .. "If a survivor steps over the false shadow, then <font color=\"rgb(248,217,109)\">John Doe</font> gets a <b>Speed I</b> buff for 10 seconds and the survivor gets a <b>Corrupted I</b> & <b>Slowness II</b> debuff for 10 seconds.\n" .. "Upon the trap being triggered, <font color=\"rgb(248,217,109)\">John Doe</font> and the survivor who activated it have their auras revealed to each other for 10 seconds.\n" .. "The shadow despawns after contact is made with it or <font color=\"rgb(248,217,109)\">John Doe</font> attempts to place down a fourth shadow.\n" .. ("There can only be <b>%*</b> shadows present at once, and attempting to create more will cause the oldest shadow to dissipate.\n"):format(v1.DigitalFootprintLimit)
    }, 
    {
        Header = "404 ERROR", 
        Image = "rbxassetid://131116145215571", 
        Quote = "\"Authentic John Doe and \226\150\136\226\150\136\226\150\136\226\150\136 Doe accounts pose no danger to your Roblox account.\" - Roblox", 
        Text = ("Cooldown: %*s\n"):format(v1["404ErrorCooldown"]) .. ("<font color=\"rgb(248,217,109)\">John Doe</font>'s corrupted arm pulsates twice, revealing the auras of all living survivors to him for %* seconds.\n"):format(v1["404ErrorAuraRevealTime"])
    }
};
-- Phase-one rig profiles. Current FCT animations and all balance values are retained.
v1.JohnDoeRigCollision=script.JohnDoeRigCollision
v1.JohnDoeRigQuery=script.JohnDoeRigQuery
v1.JohnDoeRigScale=script:GetAttribute("JohnDoeRigScale") or 1.25
v1.JohnDoeRigPhase="1.0.0"
v1.HipHeight=0
v1.CorruptEnergyPhase="1.0.0"
return v1;]==========],
[ [==========[
ServerStorage/Assets/Killers/JohnDoe/Behavior]==========] ]=[==========[
-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local _ = require(game.ReplicatedStorage.GlobalTypes);
local v1 = {};
local CorruptEnergyController=require(script.CorruptEnergyController);
local RigAlignment=require(script.RigAlignment);
v1.GetRig=function(_,actor) return RigAlignment.GetRig(actor) end;
local l_TweenService_0 = game:GetService("TweenService");
local _ = game:GetService("HttpService");
local l_Players_0 = game:GetService("Players");
local v5 = require(game.ReplicatedStorage.Modules.Sounds);
local v6 = require(game.ReplicatedStorage.Modules.Util);
local v7 = require(game.ReplicatedStorage.Modules.Hitboxes);
local v8 = require(game.ReplicatedStorage.Modules.Statuses);
local v9 = require(game.ReplicatedStorage.Modules.Network);
local v10 = require(game.ReplicatedStorage.Modules.AchievementUtil);
local function v16(v11, v12, v13, ...) --[[ Line: 23 ]] --[[ Name: pcallMethod ]]
    local l_status_0, l_result_0 = pcall(function(...) --[[ Line: 24 ]]
        -- upvalues: v13 (copy), v11 (copy)
        if v13.Behavior[v11] then
            return v13.Behavior[v11](v13.Behavior, v13, ...);
        else
            return;
        end;
    end, ...);
    if not l_status_0 then
        warn((("[%*]: Failed to call .%*() due to: %*"):format(v12, v11, l_result_0)));
    end;
    return l_result_0;
end;
v1.Abilities = {
    Slash = {
        LayoutOrder = 1, 
        Icon = "rbxassetid://92362553672440", 
        KeybindType = "MainAbility", 
        Callback = function(v17) --[[ Line: 42 ]] --[[ Name: Callback ]]
            -- upvalues: v5 (copy), v7 (copy), v6 (copy)
            if game["Run Service"]:IsServer() then
                v17.AbilitiesDisabled = true;
                v5:Play(v17.Config.Sounds.Swing, {
                    Parent = v17.Rig.PrimaryPart, 
                    PlaybackSpeed = Random.new():NextNumber(0.975, 1.025), 
                    Volume = 0.35
                });
                task.delay(v17.Config.SlashWindup, function() --[[ Line: 49 ]]
                    -- upvalues: v7 (ref), v17 (copy), v6 (ref), v5 (ref)
                    local _ = v7:CreateHitbox(v17.Player, {
                        Size = Vector3.new(4.5, 6, 7.5, 0), 
                        CFrameOffset = RigAlignment.SlashOffset(v17), 
                        Damage = v17.Config.SlashDamage, 
                        Time = v17.Config.SlashLinger, 
                        Knockback = 2, 
                        HitMultiple = false, 
                        ExecuteOnKill = true, 
                        Connections = {
                            Hit = function(v18, v19) --[[ Line: 61 ]] --[[ Name: Hit ]]
                                -- upvalues: v6 (ref), v5 (ref), v17 (ref)
                                v6:CreateSpeedMultiplier(v18, 1.5, "HitSpeedBonus", 1.25);
                                if v19 then
                                    v5:Play(v17.Config.Sounds.Hit, {
                                        Parent = v17.Rig.PrimaryPart, 
                                        PlaybackSpeed = Random.new():NextNumber(0.975, 1.025), 
                                        Volume = 0.5
                                    });
                                end;
                            end
                        }
                    });
                end);
                task.delay(0.75, function() --[[ Line: 72 ]]
                    -- upvalues: v17 (copy)
                    v17.AbilitiesDisabled = false;
                end);
                return;
            else
                if game["Run Service"]:IsClient() then
                    if v17.Animations.Slash1 then
                        v17.Animations[("Slash%*"):format((tostring(math.random(1, 2))))]:Play(0.025);
                        return;
                    else
                        v17.Animations.Slash:Play(0.025);
                    end;
                end;
                return;
            end;
        end
    }, 
    CorruptEnergy = {
        LayoutOrder=2,Name="Corrupt Energy",Icon="rbxassetid://83849304758564",KeybindType="AltAbility1",
        Cooldown=function(actor)
            return CorruptEnergyController.CanRetract(actor) and 0 or actor.Config.CorruptEnergyCooldown
        end,
        Callback=function(actor,data)
            if game:GetService("RunService"):IsServer() then
                local result=CorruptEnergyController.Cast(actor)
                if not result.Cancelled and not result.Retract then v16("CorruptEnergyStart","JohnDoe/CorruptEnergyStart",actor) end
                return result
            end
            if not (data and data.Retract) then v16("CorruptEnergyStart","JohnDoe/CorruptEnergyStart",actor) end
            return CorruptEnergyController.Play(actor,data)
        end
    },
    DigitalFootprint = {
        LayoutOrder = 3, 
        Icon = "rbxassetid://83206360003394", 
        KeybindType = "AltAbility2", 
        Callback = function(v51, v52) --[[ Line: 311 ]] --[[ Name: Callback ]]
            -- upvalues: v5 (copy), v16 (copy), v6 (copy), v8 (copy), v9 (copy), l_Players_0 (copy)
            local v53 = {
                0.317, 
                1.05, 
                2.067
            };
            local v54 = 0;
            local v55 = 0;
            if game["Run Service"]:IsServer() then
                v51.AbilitiesDisabled = true;
                v5:Play(v51.Config.Sounds.DigitalFootprint, {
                    Parent = v51.Rig.PrimaryPart, 
                    Volume = 0.4, 
                    TimePosition = 0.09, 
                    PlaybackSpeed = 1.2
                });
                v16("DFStart", ("%*/DFS"):format(script.Parent), v51);
                local function v60(v56) --[[ Line: 323 ]] --[[ Name: removeShadow ]]
                    -- upvalues: v6 (ref), v51 (copy)
                    if v56 and v56.Parent then
                        v56.Name = "okByeBye";
                        v56.Parent = workspace.Map.Ingame;
                        game.Debris:AddItem(v56, 5);
                        local l_ShadowAmbience_0 = v56:FindFirstChild("ShadowAmbience");
                        if l_ShadowAmbience_0 then
                            game.TweenService:Create(l_ShadowAmbience_0, TweenInfo.new(2), {
                                Volume = 0
                            }):Play();
                        end;
                        for _, v59 in pairs(v56:GetDescendants()) do
                            if v59:IsA("ParticleEmitter") then
                                v59.Enabled = false;
                            end;
                        end;
                        v6:RemovePlayerAuraFrom(v56, v51.Player);
                    end;
                end;
                local l_FirstChild_0 = workspace.Map.Ingame:FindFirstChild((("%*Shadows"):format((tostring(v51.Player)))));
                if not l_FirstChild_0 then
                    l_FirstChild_0 = Instance.new("Folder");
                    l_FirstChild_0.Name = ("%*Shadows"):format((tostring(v51.Player)));
                    l_FirstChild_0.Parent = workspace.Map.Ingame;
                end;
                local l_l_FirstChild_0_Children_0 = l_FirstChild_0:GetChildren();
                if #l_l_FirstChild_0_Children_0 >= v51.Config.DigitalFootprintLimit then
                    v60(l_l_FirstChild_0_Children_0[1]);
                end;
                local v63 = v51.Config.Shadow:Clone();
                v63.Size = Vector3.new(1, 0, 0, 0);
                v63.Parent = l_FirstChild_0;
                v5:Play(v51.Config.Sounds.DigitalFootprintAmbience, {
                    Parent = v63, 
                    Name = "ShadowAmbience", 
                    RollOffMaxDistance = 30, 
                    Looped = true
                });
                local v64 = RaycastParams.new();
                v64.FilterDescendantsInstances = {
                    workspace.Players, 
                    v63
                };
                v64.FilterType = Enum.RaycastFilterType.Exclude;
                task.delay(tonumber(v53[#v53]) or 2.55, function() --[[ Line: 380 ]]
                    -- upvalues: v6 (ref), v63 (copy), v51 (copy), v60 (copy), v8 (ref), v9 (ref), l_Players_0 (ref)
                    v6:ApplyUnsafeTouched(v63, false, function(_, v66) --[[ Line: 381 ]]
                        -- upvalues: v6 (ref), v51 (ref), v63 (ref), v60 (ref), v8 (ref), v9 (ref), l_Players_0 (ref)
                        local l_Parent_0 = v66.Parent;
                        local v68 = l_Parent_0 and l_Parent_0:FindFirstChild("Humanoid");
                        if v68 and v6:GetEntityType(l_Parent_0) and l_Parent_0 ~= v51.Rig and v68 and v68.Health > 0 and v63.Name == "Shadow" and not l_Parent_0:GetAttribute("ExecutionsDisabled") then
                            v60(v63);
                            v6:RevealPlayerAuraTo(v51.Rig, l_Parent_0, 10);
                            v6:RevealPlayerAuraTo(l_Parent_0, v51.Rig, 10);
                            v8:ApplyStatus(v51.Rig, "Speed", {
                                Level = 1, 
                                Duration = 10
                            });
                            v8:ApplyStatus(l_Parent_0, "Slowness", {
                                Level = 2, 
                                Duration = 10
                            });
                            v8:ApplyStatus(l_Parent_0, "Corrupted", {
                                Level = 1, 
                                Duration = 10, 
                                Killer = v51
                            });
                            if not v51.FootprintRewardDebounce[l_Parent_0] then
                                v51.FootprintRewardDebounce[l_Parent_0] = true;
                                require(game.ReplicatedStorage.Modules.Actors):IncrementActorStats(v51.Player, {
                                    Action = "Survivor stepped into a Digital Footprint trap", 
                                    RewardType = "RegularKillerAction"
                                });
                                task.delay(15, function() --[[ Line: 408 ]]
                                    -- upvalues: v51 (ref), l_Parent_0 (copy)
                                    v51.FootprintRewardDebounce[l_Parent_0] = nil;
                                end);
                            end;
                            v9:FireClientConnection(l_Players_0:GetPlayerFromCharacter(l_Parent_0), ("%*JDPuddleEffect"):format(v51.Player.Name), "REMOTE_EVENT");
                        end;
                    end, 14);
                end);
                task.spawn(function() --[[ Line: 419 ]]
                    -- upvalues: v54 (ref), v63 (copy), v55 (ref), v53 (copy), v51 (copy), v64 (copy), v16 (ref), v9 (ref)
                    while v54 ~= 3 and v63.Parent and v63.Name == "Shadow" do
                        v55 = v55 + game["Run Service"].Heartbeat:Wait();
                        for v69 = #v53, 1, -1 do
                            if v53[v69] and v55 >= v53[v69] then
                                table.remove(v53, v69);
                                v54 = v54 + 1;
                                local l_Position_2 = (v51.Rig.PrimaryPart.CFrame * CFrame.new(-1.1, 0, -2)).Position;
                                local v71 = workspace:Raycast(l_Position_2, Vector3.new(0, -100, 0, 0), v64);
                                v63.Position = (v71 and v71.Position or v51.Rig.PrimaryPart.Position - Vector3.new(0, 2.5, 0, 0)) + Vector3.new(0, 0.5, 0, 0);
                                game.TweenService:Create(v63, TweenInfo.new(1), {
                                    Size = Vector3.new(1, v54 * 6, v54 * 6)
                                }):Play();
                                v16("OnStomp", ("%*/OnStomp"):format(script.Parent), v51, v63, v54);
                                if v54 == 3 then
                                    v9:FireAllClientConnection(("%*OnPuddleRevealed"):format(v51.Player.Name), "REMOTE_EVENT", v63);
                                end;
                            end;
                        end;
                    end;
                end);
                task.delay(3, function() --[[ Line: 446 ]]
                    -- upvalues: v51 (copy)
                    v51.AbilitiesDisabled = false;
                end);
                return v63;
            else
                if game["Run Service"]:IsClient() then
                    v51.Animations.DigitalFootprint:Play(0.025);
                    local l_Connections_0 = v51.Behavior.Connections;
                    if not l_Connections_0.onShadowFolderAdded or not l_Connections_0.onShadowFolderRemoved then
                        local l_FirstChild_1 = workspace.Map.Ingame:FindFirstChild((("%*Shadows"):format((tostring(v51.Player)))));
                        if not l_FirstChild_1 then
                            return;
                        else
                            local l_AbilityContainer_0 = v51.Player.PlayerGui.MainUI:FindFirstChild("AbilityContainer");
                            local v75 = l_AbilityContainer_0 and l_AbilityContainer_0:FindFirstChild("DigitalFootprint");
                            local v76 = 1;
                            do
                                local l_v76_0 = v76;
                                local function v80(v78) --[[ Line: 465 ]] --[[ Name: onShadowChange ]]
                                    -- upvalues: v75 (copy), l_v76_0 (ref), v51 (copy)
                                    if not v75 then
                                        return;
                                    else
                                        l_v76_0 = math.max(0, l_v76_0 + v78);
                                        v75.Charges.Text = l_v76_0 == 0 and "" or l_v76_0;
                                        local v79 = l_v76_0 >= v51.Config.DigitalFootprintLimit;
                                        v75.Charges.TextColor3 = v79 and Color3.new(1, 0, 0) or Color3.new(1, 1, 1);
                                        return;
                                    end;
                                end;
                                v51.Behavior.Connections.onShadowFolderAdded = l_FirstChild_1.ChildAdded:Connect(function(v81) --[[ Line: 477 ]]
                                    -- upvalues: v80 (copy)
                                    if not v81:IsA("BasePart") then
                                        return;
                                    else
                                        v80(1);
                                        return;
                                    end;
                                end);
                                v51.Behavior.Connections.onShadowFolderRemoved = l_FirstChild_1.ChildRemoved:Connect(function(v82) --[[ Line: 485 ]]
                                    -- upvalues: v80 (copy)
                                    if not v82:IsA("BasePart") then
                                        return;
                                    else
                                        v80(-1);
                                        return;
                                    end;
                                end);
                                v80(0);
                            end;
                        end;
                    end;
                    local l_v6_SpeedMultiplier_1 = v6:CreateSpeedMultiplier(v51.Player, 0, "DigitalFootprint");
                    game.Debris:AddItem(l_v6_SpeedMultiplier_1, 3);
                    task.spawn(function() --[[ Line: 501 ]]
                        -- upvalues: v51 (copy), v53 (copy), v55 (ref), v54 (ref), v6 (ref)
                        while v51 and v51.Rig.Parent and v53[1] do
                            v55 = v55 + game["Run Service"].Heartbeat:Wait();
                            for v84 = #v53, 1, -1 do
                                if v53[v84] and v55 >= v53[v84] then
                                    table.remove(v53, v84);
                                    v54 = v54 + 1;
                                    v6:ApplyCameraShake(v54 * 0.2, v54 * 0.375);
                                end;
                            end;
                        end;
                    end);
                    task.delay(3, function() --[[ Line: 517 ]]
                        -- upvalues: v52 (copy), v6 (ref)
                        if not v52 or not v52.Parent then
                            return;
                        else
                            v52.Transparency = 0;
                            v6:RevealPlayerAura(v52, "inf", Color3.new(1, 0.321569, 0.333333), nil, {
                                OutlineTransparency = 0.35, 
                                FillTransparency = 1
                            });
                            return;
                        end;
                    end);
                end;
                return;
            end;
        end
    }, 
    ["404Error"] = {
        Name = "404 Error", 
        LayoutOrder = 4, 
        Icon = "rbxassetid://131116145215571", 
        KeybindType = "AltAbility3", 
        Callback = function(v85) --[[ Line: 537 ]] --[[ Name: Callback ]]
            -- upvalues: v16 (copy), v5 (copy), v6 (copy), v9 (copy)
            v16("ErrorStart", ("%*/404S"):format(script.Parent), v85);
            if game["Run Service"]:IsServer() then
                v85.CurrentAbility = "404Error";
                v85.Config.StunDuration = v85.Config.UnstoppableDuration;
                v85.AbilitiesDisabled = true;
                v5:Play(v85.Config.Sounds["404Error"], {
                    Parent = v85.Rig.PrimaryPart, 
                    Volume = 0.4, 
                    TimePosition = 0.09, 
                    RollOffMaxDistance = 200, 
                    PlaybackSpeed = 1.15
                });
                task.delay(1.625, function() --[[ Line: 550 ]]
                    -- upvalues: v85 (copy)
                    v85.Config.StunDuration = nil;
                    v85.CurrentAbility = nil;
                    v85.AbilitiesDisabled = false;
                end);
                return;
            else
                if game["Run Service"]:IsClient() then
                    local l_v6_SpeedMultiplier_2 = v6:CreateSpeedMultiplier(v85.Player, 1, "404Error");
                    local l_v6_FOVMultiplier_0 = v6:CreateFOVMultiplier(v85.Player, 1, "404Error");
                    game.TweenService:Create(l_v6_SpeedMultiplier_2, TweenInfo.new(0.5), {
                        Value = 0.25
                    }):Play();
                    game.TweenService:Create(l_v6_FOVMultiplier_0, TweenInfo.new(1.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, true), {
                        Value = 0.75
                    }):Play();
                    v9:FireConnection("DisableSprinting", "404Error", true);
                    task.delay(1.2, function() --[[ Line: 567 ]]
                        -- upvalues: v5 (ref), v85 (copy), v9 (ref), l_v6_SpeedMultiplier_2 (copy), l_v6_FOVMultiplier_0 (copy), v6 (ref)
                        v5:Play(v85.Config.Sounds["404ErrorError"], {
                            Parent = v85.Rig.PrimaryPart, 
                            Volume = 0.4, 
                            TimePosition = 0.09, 
                            PlaybackSpeed = Random.new():NextNumber(0.9, 1.1)
                        });
                        v9:FireConnection("DisableSprinting", "404Error", false);
                        game.TweenService:Create(l_v6_SpeedMultiplier_2, TweenInfo.new(0.6), {
                            Value = 1
                        }):Play();
                        game.TweenService:Create(l_v6_FOVMultiplier_0, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                            Value = 1
                        }):Play();
                        game.Debris:AddItem(l_v6_SpeedMultiplier_2, 0.4);
                        game.Debris:AddItem(l_v6_FOVMultiplier_0, 1);
                        for _, v89 in pairs(workspace.Players.Survivors:GetChildren()) do
                            v6:RevealPlayerAura(v89, v85.Config["404ErrorAuraRevealTime"]);
                        end;
                    end);
                end;
                return;
            end;
        end
    }
};
v1.ErrorStart = function(_, _) --[[ Line: 591 ]] --[[ Name: ErrorStart ]]

end;
v1.CorruptEnergyStart = function(_, _) --[[ Line: 595 ]] --[[ Name: CorruptEnergyStart ]]

end;
v1.OnPuddleEpilepsy = function(_, _, _) --[[ Line: 599 ]] --[[ Name: OnPuddleEpilepsy ]]

end;
v1.OnStomp = function(_, _, v99, v100) --[[ Line: 603 ]] --[[ Name: OnStomp ]]
    for _, v102 in pairs(v99:GetDescendants()) do
        if v102:IsA("ParticleEmitter") and v102.Name:find("ShadowPuddle") then
            v102.Enabled = v102.Name == ("ShadowPuddle%*"):format(v100);
        end;
    end;
end;
v1.Created = function(v103, v104) --[[ Line: 611 ]] --[[ Name: Created ]]
    -- upvalues: v10 (copy), v6 (copy), v8 (copy), l_Players_0 (copy), v9 (copy), v5 (copy), l_TweenService_0 (copy), v16 (copy)
    v103.Connections = {};
    if game["Run Service"]:IsServer() then
        if workspace:GetAttribute("JohnDoeSpecialDay") then
            v10:IncrementAchievementProgress(v104.Player, "JohnDoeSpecialDay");
        end;
        local l_Folder_0 = Instance.new("Folder");
        l_Folder_0.Name = "JohnDoeTrail";
        l_Folder_0.Parent = v104.Rig;
        for _ = 1, math.clamp(math.round(v104.Config.TrailLength / 4), 2, 1e999) do
            local v107 = v104.Config.Trail:Clone();
            v107.Position = RigAlignment.TrailPoint(v104,true);
            v107.Parent = l_Folder_0;
            v107:SetAttribute("FinishedUpdating", true);
            v6:ApplyOnTouched(v107, false, function(_, v109) --[[ Line: 635 ]]
                -- upvalues: v8 (ref), v104 (copy)
                local l_Parent_1 = v109.Parent;
                local l_Humanoid_0 = l_Parent_1:FindFirstChild("Humanoid");
                if l_Humanoid_0 and l_Humanoid_0.Health > 0 and l_Parent_1:IsDescendantOf(workspace.Players) and tostring(l_Parent_1.Parent) ~= "Killers" then
                    v8:ApplyStatus(l_Parent_1, "Corrupted", {
                        Duration = 3, 
                        Level = 2, 
                        Killer = v104
                    });
                end;
            end);
        end;
        v104.CurrentSpikes = {};
        v104.FootprintRewardDebounce = {};
        local v112 = false;
        v104.Rig:GetAttributeChangedSignal("Stunned"):Connect(function() --[[ Line: 648 ]]
            -- upvalues: v104 (copy), v112 (ref)
            if v104.Rig:GetAttribute("Stunned") and v104.Config.StunDuration and v104.CurrentAbility and not v112 then
                v112 = true;
                local l_CurrentAbility_0 = v104.CurrentAbility;
                local v114 = v104.Config[l_CurrentAbility_0 .. "Cooldown"];
                if v114 then
                    v104:SetCooldownOf(l_CurrentAbility_0, (math.max(v114 * 0.5, 0)));
                end;
                task.delay(1, function() --[[ Line: 657 ]]
                    -- upvalues: v112 (ref)
                    v112 = false;
                end);
            end;
        end);
        local l_l_Folder_0_Children_0 = l_Folder_0:GetChildren();
        local v116 = 0;
        local v117 = 0;
        local v118 = 0;
        local v119 = nil;
        v119 = game["Run Service"].Heartbeat:Connect(function(v120) --[[ Line: 670 ]]
            -- upvalues: v104 (copy), l_Folder_0 (copy), v119 (ref), v118 (ref), l_Players_0 (ref), v8 (ref), v117 (ref), l_l_Folder_0_Children_0 (copy), v116 (ref)
            if not v104 or not v104.Rig.Parent or not v104.Rig.PrimaryPart then
                l_Folder_0:Destroy();
                v119:Disconnect();
                v119 = nil;
                return;
            else
                if v118 > 1 and #v104.CurrentSpikes > 0 then
                    v118 = 0;
                    local v121 = RaycastParams.new();
                    v121.FilterDescendantsInstances = v104.CurrentSpikes;
                    v121.FilterType = Enum.RaycastFilterType.Include;
                    for _, v123 in (l_Players_0:GetPlayers()) do
                        local l_Character_0 = v123.Character;
                        if l_Character_0 and l_Character_0.Parent then
                            if not l_Character_0 or not l_Character_0.Parent or l_Character_0.Parent.Name == "Killers" then

                            end;
                            local l_Humanoid_1 = l_Character_0:FindFirstChildOfClass("Humanoid");
                            if l_Humanoid_1 or l_Humanoid_1.Health <= 0 then
                                local l_PrimaryPart_0 = l_Character_0.PrimaryPart;
                                local v127 = workspace:Raycast(l_PrimaryPart_0.Position, Vector3.new(0, -5, 0, 0), v121);
                                local v128 = v127 and v127.Instance;
                                if v127 and v128 then
                                    local v129 = v128.Position.Y + v128.Size.Y / 2;
                                    local v130 = RaycastParams.new();
                                    v130.FilterDescendantsInstances = {
                                        l_Character_0, 
                                        v104.CurrentSpikes
                                    };
                                    v130.FilterType = Enum.RaycastFilterType.Exclude;
                                    local v131 = workspace:Raycast(l_PrimaryPart_0.Position, Vector3.new(0, -10, 0, 0), v130);
                                    if v131 then
                                        if v129 - v131.Position.Y >= 1.5 then
                                            v8:ApplyStatus(v123, "Corrupted", {
                                                Level = 2, 
                                                Duration = 5, 
                                                Killer = v104
                                            });
                                        end;
                                    else
                                        v8:ApplyStatus(v123, "Corrupted", {
                                            Level = 2, 
                                            Duration = 5, 
                                            Killer = v104
                                        });
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;
                v118 = v118 + v120;
                if v117 <= 0.05 then
                    v117 = v117 + v120;
                    return;
                else
                    v117 = 0;
                    local v132 = l_l_Folder_0_Children_0[v116 % #l_l_Folder_0_Children_0 + 1];
                    local v133 = l_l_Folder_0_Children_0[(v116 - 1) % #l_l_Folder_0_Children_0 + 1];
                    if v132 and v133 then
                        if v132.Size.Z <= 4 or v132:GetAttribute("FinishedUpdating") then
                            if v132:GetAttribute("FinishedUpdating") then
                                v132:SetAttribute("FinishedUpdating", nil);
                            end;
                            local v134 = RigAlignment.TrailPoint(v104,false);
                            local l_Position_3 = v133:GetPivot().Position;
                            local l_Rotation_0 = CFrame.lookAt(l_Position_3, v134).Rotation;
                            if l_Rotation_0 ~= l_Rotation_0 then
                                warn("currentTrailRotation is NaN, setting rotation to root rotation as fallback");
                                l_Rotation_0 = v104.Rig.PrimaryPart.CFrame.Rotation;
                            end;
                            v132.CFrame = CFrame.new(v133:GetPivot().Position) * l_Rotation_0 * CFrame.Angles(0, 0, 0);
                            v132.Size = Vector3.new(v132.Size.X, v132.Size.Y, (v132.Position - v134).Magnitude);
                            v132.PivotOffset = CFrame.new(0, 0, -v132.Size.Z / 2);
                            v132.CFrame = v132.CFrame * v132.PivotOffset;
                            return;
                        else
                            v132:SetAttribute("FinishedUpdating", true);
                            v116 = v116 + 1;
                            return;
                        end;
                    else
                        v116 = v116 + 1;
                        return;
                    end;
                end;
            end;
        end);
        return;
    else
        if game["Run Service"]:IsClient() then
            v104.ActiveSpikeModels = {};
            if game.Players.LocalPlayer==v104.Player and RigAlignment.IsUpdated(v104.Rig) then
                v104.JohnDoeRigCameraOffset=v6:CreateCameraOffset(v104.Rig,Vector3.new(0,.25,0),"JohnDoeDefault");
            end;
            v9:SetConnection(("%*JDPuddleEffect"):format(v104.Player.Name), "REMOTE_EVENT", function() --[[ Line: 776 ]]
                -- upvalues: v5 (ref), v104 (copy)
                v5:Play(v104.Config.Sounds.PuddleStepped);
            end);
            v9:SetConnection(("%*SpawnSpike"):format(v104.Player.Name), "REMOTE_EVENT", function(v137) --[[ Line: 780 ]]
                -- upvalues: v104 (copy), l_TweenService_0 (ref), v5 (ref)
                local v138 = v104.Config.Spike:Clone();
                local l_Y_0 = v104.Config.SpikeHitboxSize.Y;
                local v140 = Vector3.new(v137.Position.X, v137.Position.Y, v137.Position.Z);
                v138:PivotTo(CFrame.new(v140) * CFrame.Angles(3.141592653589793, math.rad(v137.Rotation), 0) - Vector3.new(0, l_Y_0, 0));
                v138.Parent = workspace.Map.Ingame;
                for _, v142 in (v138:GetDescendants()) do
                    if v142:IsA("BasePart") then
                        v142.CanCollide = false;
                        v142.CanQuery = false;
                        v142.CanTouch = false;
                    end;
                end;
                for _, v144 in (v138:GetDescendants()) do
                    if v144:IsA("ParticleEmitter") and v144.Name == "Number" then
                        v144.Color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0, v104.Config.SpikeNumbersColor), 
                            ColorSequenceKeypoint.new(1, v104.Config.SpikeNumbersColor)
                        });
                    end;
                end;
                l_TweenService_0:Create(v138.PrimaryPart, TweenInfo.new(0.1), {
                    CFrame = v138.PrimaryPart.CFrame + Vector3.new(0, l_Y_0, 0)
                }):Play();
                task.delay(v104.Config.SpikeLifetime, function() --[[ Line: 815 ]]
                    -- upvalues: v138 (copy)
                    if v138.Parent and v138.PrimaryPart then
                        game.Debris:AddItem(v138, 1.5);
                    end;
                end);
                v5:Play(v104.Config.Sounds.CorruptEnergySummon, {
                    Parent = v138.PrimaryPart, 
                    PlaybackSpeed = Random.new():NextNumber(0.8, 1.2), 
                    Volume = 0.25, 
                    TimePosition = 0.02
                });
                v104.ActiveSpikeModels[v137.SpikeUUID] = v138;
            end);
            v9:SetConnection(("%*DesummonSpike"):format(v104.Player.Name), "REMOTE_EVENT", function(v145) --[[ Line: 825 ]]
                -- upvalues: v104 (copy), l_TweenService_0 (ref), v5 (ref)
                local v146 = v104.ActiveSpikeModels[v145];
                if not v146 then
                    return;
                else
                    local l_Y_1 = v104.Config.SpikeHitboxSize.Y;
                    l_TweenService_0:Create(v146.PrimaryPart, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                        CFrame = v146.PrimaryPart.CFrame - Vector3.new(0, l_Y_1 * 2, 0)
                    }):Play();
                    v5:Play(v104.Config.Sounds.CorruptEnergyDesummon, {
                        Parent = v146.PrimaryPart, 
                        PlaybackSpeed = Random.new():NextNumber(0.9, 1.1), 
                        Volume = 0.1, 
                        TimePosition = 0.02
                    });
                    game.Debris:AddItem(v146, 1);
                    v104.ActiveSpikeModels[v145] = nil;
                    return;
                end;
            end);
            v9:SetConnection(("%*OnPuddleRevealed"):format(v104.Player.Name), "REMOTE_EVENT", function(v148) --[[ Line: 848 ]]
                -- upvalues: v16 (ref), v104 (copy)
                local l_PlayerSettings_0 = require(game.ReplicatedStorage.Initializer).PlayerSettings;
                if l_PlayerSettings_0.EpilepsyMode and l_PlayerSettings_0.EpilepsyMode.Value then
                    for _, v151 in (v148:GetDescendants()) do
                        if v151:IsA("ParticleEmitter") and v151:GetAttribute("IsEpilepsy") then
                            v151.Enabled = false;
                        end;
                    end;
                    v16("OnPuddleEpilepsy", ("%*/OnPuddleEpilepsy"):format(script.Parent), v104, v148);
                end;
            end);
            if game.Players.LocalPlayer == v104.Player then
                local v152 = v104.Config.SilencedTag or "JaneDoeSilenced";
                v104.Silencers = {};
                local function v156(v153) --[[ Line: 874 ]] --[[ Name: myWife ]]
                    -- upvalues: v104 (copy)
                    local v154 = v153:WaitForChild("Head", 4);
                    if not v154 or not v104 or not v104.SilencedConnection then
                        return;
                    else
                        local v155 = v104.Config.SilencedTemplate:Clone();
                        v155.Parent = v153;
                        v155.Weld.Part0 = v154;
                        table.insert(v104.Silencers, v155);
                        return;
                    end;
                end;
                v104.SilencedConnection = game.CollectionService:GetInstanceAddedSignal(v152):Connect(v156);
                for _, v158 in ipairs(workspace.Players.Survivors:GetChildren()) do
                    if v158:HasTag(v152) then
                        task.spawn(v156, v158);
                    end;
                end;
            end;
        end;
        return;
    end;
end;
v1.Destroyed = function(v159, v160) --[[ Line: 897 ]] --[[ Name: Destroyed ]]
    if v160.JohnDoeRigCameraOffset then v160.JohnDoeRigCameraOffset:Destroy();v160.JohnDoeRigCameraOffset=nil end;
    -- upvalues: v9 (copy)
    for _, v162 in v159.Connections do
        v162:Disconnect();
        v162 = nil;
    end;
    if game["Run Service"]:IsServer() then
        for _, v164 in v160.CurrentSpikes do
            v164:Destroy();
        end;
        return;
    else
        if game["Run Service"]:IsClient() then
            v9:RemoveConnection(("%*JDPuddleEffect"):format(v160.Player.Name), "REMOTE_EVENT");
            v9:RemoveConnection(("%*SpawnSpike"):format(v160.Player.Name), "REMOTE_EVENT");
            v9:RemoveConnection(("%*DesummonSpike"):format(v160.Player.Name), "REMOTE_EVENT");
            if v160.SilencedConnection then
                v160.SilencedConnection:Disconnect();
                local l_ipairs_0 = ipairs;
                local v166 = v160.Silencers or {};
                for _, v168 in l_ipairs_0(v166) do
                    v168:Destroy();
                end;
            end;
        end;
        return;
    end;
end;
v1.OnIntroduction = function(_, v170, v171, v172) --[[ Line: 923 ]] --[[ Name: OnIntroduction ]]
    -- upvalues: v6 (copy)
    local v173 = nil;
    if v170.Config.useClouds == true then
        v173 = Instance.new("Clouds");
        v173.Cover = 0.774;
        v173.Density = 1;
        v173.Color = Color3.fromRGB(25, 25, 25);
        v173.Parent = workspace:FindFirstChild("Terrain");
        game.Debris:AddItem(v173, v172);
    end;
    local v174 = script.IntroScreen:Clone();
    v174.Main.Title.Text = v170.Config.IntroText:gsub("PLAYERNAME", v170.Player.DisplayName);
    v174.Parent = game.Players.LocalPlayer.PlayerGui;
    game.Debris:AddItem(v174, 1.93333);
    game.TweenService:Create(v174.Main.Title, TweenInfo.new(0.83), {
        TextTransparency = 0
    }):Play();
    task.delay(0.83, function() --[[ Line: 948 ]]
        -- upvalues: v174 (copy), v170 (copy)
        game.TweenService:Create(v174.Main.Title, TweenInfo.new(0.583), {
            TextColor3 = v170.Config.IntroTextColor or Color3.new(1, 0, 0)
        }):Play();
    end);
    task.delay(1, function() --[[ Line: 953 ]]
        -- upvalues: v171 (copy)
        local l_JohnDoeTrail_0 = v171:FindFirstChild("JohnDoeTrail");
        if l_JohnDoeTrail_0 then
            l_JohnDoeTrail_0:Destroy();
        end;
    end);
    local v176 = require(game.ReplicatedStorage.Modules.Schematics.Lighting);
    v176:SetCustomLighting(v170.Config.IntroLighting);
    task.delay(2.717, function() --[[ Line: 963 ]]
        -- upvalues: v173 (ref), v170 (copy)
        if v173 then
            v173.Color = Color3.fromRGB(25, 0, 0);
        end;
        local l_AtmosphereDoe_0 = game.Lighting:FindFirstChild("AtmosphereDoe");
        if l_AtmosphereDoe_0 then
            game.TweenService:Create(l_AtmosphereDoe_0, TweenInfo.new(0.2829, Enum.EasingStyle.Linear), {
                Color = v170.Config.AtmosphereColor or Color3.fromRGB(144, 0, 0), 
                Decay = v170.Config.AtmosphereDecay or Color3.fromRGB(255, 0, 0), 
                Density = 1
            }):Play();
        end;
    end);
    local l_v6_FOVMultiplier_1 = v6:CreateFOVMultiplier(game.Players.LocalPlayer, 0.35, "JohnDoeIntroScene");
    task.delay(2.75, function() --[[ Line: 979 ]]
        -- upvalues: l_v6_FOVMultiplier_1 (copy)
        game.TweenService:Create(l_v6_FOVMultiplier_1, TweenInfo.new(0.25), {
            Value = 0.95
        }):Play();
    end);
    task.delay(v172, function() --[[ Line: 984 ]]
        -- upvalues: v176 (copy), l_v6_FOVMultiplier_1 (copy), v174 (copy), v173 (ref)
        v176:SetAsCurrentLighting();
        l_v6_FOVMultiplier_1:Destroy();
        v174:Destroy();
        if v173 then
            v173:Destroy();
        end;
    end);
end;
v1.OnVictory = function(_, v180, v181, _, _) --[[ Line: 994 ]] --[[ Name: OnVictory ]]
    -- upvalues: v6 (copy), l_TweenService_0 (copy)
    local v184 = require(game.ReplicatedStorage.Modules.Schematics.Lighting);
    if v180 == "Start" then
        v184:SetCustomLighting(v181.Config.IntroLighting);
        local l_v6_FOVMultiplier_2 = v6:CreateFOVMultiplier(game.Players.LocalPlayer, 1.1325, "JohnDoeOutroScene");
        game.Debris:AddItem(l_v6_FOVMultiplier_2, 30);
        task.spawn(function() --[[ Line: 1005 ]]
            -- upvalues: v181 (copy), v6 (ref)
            local v186 = os.clock();
            local v187 = workspace.Misc:WaitForChild("KillerCutsceneBackground", 5);
            if v187 and v187.PrimaryPart then
                local v188 = v181.Config.OutroDummy:Clone();
                v188.Name = "OutroVictim";
                v188.PrimaryPart.Anchored = true;
                v188:SetPrimaryPartCFrame(v187.PrimaryPart.CFrame);
                v188.Parent = v187;
                local v189 = v6:LoadAnimationFromID(v188, "rbxassetid://135006397147596", true);
                v189:Play(0);
                v189.TimePosition = os.clock() - v186;
                v189.Stopped:Once(function() --[[ Line: 1020 ]]
                    -- upvalues: v188 (copy)
                    for _, v191 in ipairs(v188:GetDescendants()) do
                        if v191:IsA("BasePart") then
                            v191.Anchored = true;
                        end;
                    end;
                end);
                local v192 = false;
                for _, v194 in ipairs({
                    "Shirt", 
                    "Pants", 
                    "Accessory", 
                    "Hat"
                }) do
                    if v188:FindFirstChildOfClass(v194) then
                        v192 = true;
                        break;
                    end;
                end;
                if not v192 then
                    pcall(function() --[[ Line: 1033 ]]
                        -- upvalues: v181 (ref), v188 (copy)
                        local l_HumanoidDescriptionFromUserId_0 = game.Players:GetHumanoidDescriptionFromUserId(v181.Player.UserId);
                        v188.Humanoid:ApplyDescription(l_HumanoidDescriptionFromUserId_0, Enum.AssetTypeVerification.Always);
                    end);
                end;
            end;
        end);
        task.delay(2.4, function() --[[ Line: 1042 ]]
            -- upvalues: l_TweenService_0 (ref), v181 (copy)
            local v196 = Instance.new("ColorCorrectionEffect", game.Lighting);
            v196.Name = "JohnDoeStabCC";
            local v197 = l_TweenService_0:Create(v196, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
                Contrast = 0.4, 
                Brightness = 0.1
            });
            v197:Play();
            task.wait(0.4);
            v197:Pause();
            v196.Brightness = 0.8;
            v196.Contrast = 0.3;
            v196.TintColor = v181.Config.OutroTintColor or Color3.new(0.631373, 0.0784314, 0.0901961);
            l_TweenService_0:Create(v196, TweenInfo.new(2.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
                TintColor = Color3.new(0.196078, 0.196078, 0.196078), 
                Brightness = -1, 
                Contrast = -0.5, 
                Saturation = -1
            }):Play();
        end);
        return;
    else
        if v180 == "End" then
            v184:SetAsCurrentLighting();
            local l_v6_FOVMultiplier_3 = v6:CreateFOVMultiplier(game.Players.LocalPlayer, 1, "JohnDoeOutroScene");
            game.Debris:AddItem(l_v6_FOVMultiplier_3, 1);
            local v199 = game.Lighting:WaitForChild("JohnDoeStabCC", 8);
            if v199 then
                v199:Destroy();
            end;
        end;
        return;
    end;
end;
v1.OnExecution = function(_, v201, v202) --[[ Line: 1106 ]] --[[ Name: OnExecution ]]
    local l_Humanoid_2 = v202:FindFirstChild("Humanoid");
    local v204 = require(game.ReplicatedStorage.Modules.Ragdolls);
    local v205 = (v201.Rig.PrimaryPart.CFrame.LookVector + Vector3.new(0, 0.5, 0, 0)) * 40;
    local l_Axe_0 = v202:FindFirstChild("Axe");
    local l_BackAxe_0 = v202:FindFirstChild("BackAxe");
    if v202.Name == "JaneDoe" then
        l_Axe_0.Transparency = 0;
        l_BackAxe_0.Transparency = 1;
        task.delay(2.85, function() --[[ Line: 1118 ]]
            -- upvalues: v204 (copy), v202 (copy), v205 (copy), l_Humanoid_2 (copy)
            v204.AddProfile(v202, {
                Velocity = v205, 
                KillEffects = {
                    Explode = true
                }
            });
            if l_Humanoid_2 then
                l_Humanoid_2.BreakJointsOnDeath = true;
                l_Humanoid_2.Health = 0;
            end;
        end);
        return;
    else
        task.delay(0.666, function() --[[ Line: 1128 ]]
            -- upvalues: v204 (copy), v202 (copy), v205 (copy)
            v204.AddProfile(v202, {
                AnchorDelay = true, 
                Applied = os.clock() + 5, 
                Velocity = v205
            });
            local l_Humanoid_3 = v202:FindFirstChild("Humanoid");
            if l_Humanoid_3 then
                l_Humanoid_3.BreakJointsOnDeath = false;
                l_Humanoid_3.Health = 0;
            end;
        end);
        task.delay(1.98, function() --[[ Line: 1137 ]]
            -- upvalues: v202 (copy)
            if v202 and v202.PrimaryPart then
                v202.PrimaryPart.Anchored = false;
            end;
        end);
        return;
    end;
end;
local previousCreated=v1.Created
local previousDestroyed=v1.Destroyed
v1.Created=function(self,actor)
 previousCreated(self,actor)
 CorruptEnergyController.Created(actor)
end
v1.Destroyed=function(self,actor)
 CorruptEnergyController.Destroyed(actor)
 previousDestroyed(self,actor)
end
return v1;]==========],
[ [==========[
ServerStorage/Assets/Killers/JohnDoe/Behavior/CorruptEnergyController]==========] ]=[==========[
return require(game:GetService("RunService"):IsServer() and script.Server or script.Client)
]==========],
[ [==========[
ServerStorage/Assets/Killers/JohnDoe/Behavior/CorruptEnergyController/Server]==========] ]=[==========[
local RunService=game:GetService("RunService")
local TweenService=game:GetService("TweenService")
local Debris=game:GetService("Debris")
local Modules=game.ReplicatedStorage.Modules
local Hitboxes=require(Modules.Hitboxes)
local Network=require(Modules.Network)
local Util=require(Modules.Util)
local Sounds=require(Modules.Sounds)
local Statuses=require(Modules.Statuses)
local Actors=require(Modules.Actors)
local Rules=require(script.Parent.Rules)
local Server={}
local function alive(a)
 local hum=a.Rig and a.Rig:FindFirstChildOfClass("Humanoid")
 return not a.JDCEDestroyed and a.Rig and a.Rig.Parent and a.Rig.PrimaryPart and hum and hum.Health>0
end
local function blocked(a)
 local r=a.Rig
 return r:GetAttribute("Stunned") or r:GetAttribute("Helpless") or r:GetAttribute("Ragdolling") or r:GetAttribute("AbilitiesDisabled") or r.PrimaryPart.Anchored
end
local function broadcast(a,kind,data)
 Network:FireAllClientConnection(a.Player.Name..kind,"REMOTE_EVENT",data)
end
local function sound(a,name,parent)
 local id=a.Config.Sounds and a.Config.Sounds[name]
 if id and parent then pcall(Sounds.Play,Sounds,id,{Parent=parent,Volume=.4}) end
end
function Server.CanRetract(a)
 local c=a.JDCECast
 return c and c.active and not c.casting and c.live>0 or false
end
local function refresh(a)
 if a.Rig and a.Rig.Parent then a.Rig:SetAttribute("JDCanRetract",Server.CanRetract(a)) end
end
local function release(a,c)
 if not c.casting then return end
 c.casting=false
 if c.slow then c.slow:Destroy();c.slow=nil end
 a.AbilityDisablers.JohnCorruptEnergy=nil
 if a.CurrentAbility=="CorruptEnergy" then a.CurrentAbility=nil;a.Config.StunDuration=c.previousStunDuration end
 refresh(a)
end
local function removeSpike(a,c,s,immediate)
 if not s.live then return end
 s.live=false;c.live-=1
 if s.hitbox and s.hitbox.Cancel then s.hitbox:Cancel() end
 if s.rise then s.rise:Cancel() end
 local index=table.find(a.CurrentSpikes,s.part)
 if index then table.remove(a.CurrentSpikes,index) end
 broadcast(a,"DesummonSpike",s.id)
 if s.part.Parent then
  s.part.CanCollide=false;s.part.CanTouch=false
  if immediate then s.part:Destroy()
  else
   TweenService:Create(s.part,TweenInfo.new(1,Enum.EasingStyle.Quad,Enum.EasingDirection.In),{CFrame=s.part.CFrame-Vector3.new(0,a.Config.SpikeHitboxSize.Y*2,0)}):Play()
   Debris:AddItem(s.part,1.05)
  end
 end
 refresh(a)
end
local function clear(a,immediate)
 local c=a.JDCECast
 if not c then return end
 c.active=false;release(a,c)
 for _,s in ipairs(c.spikes) do removeSpike(a,c,s,immediate) end
 a.JDCECast=nil;refresh(a)
end
local function reward(a,target)
 local hum=target:FindFirstChildOfClass("Humanoid")
 if not hum then return end
 if hum.Health>0 then
  Util:CreateSpeedMultiplier(target,1.5,"HitSpeedBonus",1.25)
  Statuses:ApplyStatus(a.Rig,"Speed",{Level=1,Duration=7})
  Util:RevealPlayerAuraTo(a.Player,target,2.5)
 end
 if target.Parent and target.Parent.Name=="Survivors" then
  Actors:IncrementActorStats(a.Player,{Action=hum.Health<=0 and "Killed a Survivor with Corrupt Energy" or "Damaged a Survivor with Corrupt Energy",RewardType=hum.Health<=0 and "DifficultKillerAction" or "EasyKillerAction"})
 end
 if hum.Health<=0 then
  local achievement=require(Modules.AchievementUtil)
  achievement:IncrementAchievementProgress(a.Player,"JohnDoeSpikes")
 end
end
local function spawnSpike(a,c,index,now)
 if not c.active or c.interrupted or not alive(a) then return end
 local params=RaycastParams.new();params.FilterType=Enum.RaycastFilterType.Exclude;params.FilterDescendantsInstances={workspace.Players}
 local point=(a:GetPivot()*CFrame.new(0,0,-a.Config.DistanceBetweenSpikes*index)).Position
 local hit=workspace:Raycast(point,Vector3.new(0,-100,0),params) or workspace:Raycast(point,Vector3.new(0,100,0),params)
 if not hit then return end
 local size=a.Config.SpikeHitboxSize
 local rotation=math.random(0,360)
 local data={Position=hit.Position,Rotation=rotation,SpikeUUID=tostring(c.serial)..":"..index}
 local part=Instance.new("Part");part.Name="SpikeCollision";part.Size=size;part.Transparency=1
 part.Anchored=true;part.CanTouch=false;part.CanCollide=true;part.CustomPhysicalProperties=a.Config.SpikeProperties
 local from=CFrame.new(hit.Position)*CFrame.Angles(0,math.rad(rotation),math.pi/2)-Vector3.new(0,size.Y,0)
 part.CFrame=from;part.Parent=workspace.Map.Ingame
 local s={part=part,id=data.SpikeUUID,live=true,expires=now+a.Config.SpikeLifetime}
 table.insert(c.spikes,s);table.insert(a.CurrentSpikes,part);c.live+=1
 s.rise=TweenService:Create(part,TweenInfo.new(.1,Enum.EasingStyle.Linear),{CFrame=from+Vector3.new(0,size.Y*2,0)})
 s.rise:Play();broadcast(a,"SpawnSpike",data)
 s.hitbox=Hitboxes:CreateHitbox(a.Player,{
  AbilityType="CorruptEnergy",IsProjectile=false,Size=size,CFrame=function()return part.CFrame end,
  Damage=a.Config.CorruptEnergyDamage,Time=.15,Knockback=5,HitMultiple=true,PredictVelocity=false,CastPoint=false,
  -- Reject before damage, block reactions, knockback, or hit callbacks. Reservation is atomic across spikes.
  HitFilter=function(target)
   return s.live and alive(a) and Rules.ReserveHit(c,target,a.Config.SpikeHitCap)
  end,
  Connections={Hit=function(target,first)
   reward(a,target)
   if first then sound(a,"Hit",a.Rig.PrimaryPart) end
  end}
 })
 refresh(a)
end
local function step(a)
 if not alive(a) then Server.Destroyed(a);return end
 local c=a.JDCECast
 if not c then return end
 local now=os.clock()
 if c.casting then
  if blocked(a) then c.interrupted=true;release(a,c)
  else
   while c.next<=a.Config.SpikeAmount and now-c.started>=Rules.SpawnAt(c.next,a.Config.DelayBetweenSpikeSummons) do
    local index=c.next;c.next+=1;spawnSpike(a,c,index,now)
   end
   if now-c.started>=math.max(3.5,Rules.SpawnAt(a.Config.SpikeAmount,a.Config.DelayBetweenSpikeSummons)+.1) then release(a,c) end
  end
 end
 for _,s in ipairs(c.spikes) do if s.live and (not s.part.Parent or now>=s.expires) then removeSpike(a,c,s,not s.part.Parent) end end
 if not c.casting and c.live==0 then c.active=false;a.JDCECast=nil;refresh(a) end
end
function Server.Cast(a)
 if not alive(a) or blocked(a) then return {Cancelled=true} end
 if Server.CanRetract(a) then clear(a,false);return {Retract=true} end
 if a.JDCECast and a.JDCECast.casting then return {Cancelled=true} end
 clear(a,true)
 a.JDCESerial=(a.JDCESerial or 0)+1
 local c={serial=a.JDCESerial,active=true,casting=true,started=os.clock(),next=1,live=0,spikes={},hits={},previousStunDuration=a.Config.StunDuration}
 a.JDCECast=c;a.AbilityDisablers=a.AbilityDisablers or {};a.AbilityDisablers.JohnCorruptEnergy=true
 a.CurrentAbility="CorruptEnergy";a.Config.StunDuration=a.Config.UnstoppableDuration
 c.slow=Util:CreateSpeedMultiplier(a.Player,.001,"JohnCorruptEnergyCast")
 sound(a,"CorruptEnergy",a.Rig.PrimaryPart);refresh(a)
 return {Retract=false}
end
function Server.Created(a)
 a.JDCEDestroyed=false;a.JDCEConnections={};a.CurrentSpikes=a.CurrentSpikes or {}
 local original=a.CanUseAbility;a.JDCEOriginalCanUse=original
 local function canUse(self,name)
  if name~="CorruptEnergy" or not Server.CanRetract(a) then return original(self,name) end
  -- Keep every ordinary lock/check; bypass only this actor's existing CE cooldown for Retract.
  local cooldown=a.Cooldowns.CorruptEnergy;a.Cooldowns.CorruptEnergy=nil
  local ok,result=pcall(original,self,name)
  a.Cooldowns.CorruptEnergy=cooldown
  if not ok then error(result) end
  return result
 end
 a.CanUseAbility=canUse;a.JDCECanUseWrapper=canUse
 table.insert(a.JDCEConnections,RunService.Heartbeat:Connect(function()step(a)end))
 table.insert(a.JDCEConnections,a.Rig:GetAttributeChangedSignal("Stunned"):Connect(function()
  if a.Rig:GetAttribute("Stunned") and a.JDCECast and a.JDCECast.casting then a.JDCECast.interrupted=true;release(a,a.JDCECast) end
 end))
 table.insert(a.JDCEConnections,a.Rig:FindFirstChildOfClass("Humanoid").Died:Connect(function()Server.Destroyed(a)end))
 refresh(a)
end
function Server.Destroyed(a)
 if a.JDCEDestroyed then return end
 a.JDCEDestroyed=true;clear(a,true)
 for _,connection in ipairs(a.JDCEConnections or {}) do connection:Disconnect() end
 a.JDCEConnections={}
 if a.CanUseAbility==a.JDCECanUseWrapper then a.CanUseAbility=a.JDCEOriginalCanUse end
end
return Server
]==========],
[ [==========[
ServerStorage/Assets/Killers/JohnDoe/Behavior/CorruptEnergyController/Client]==========] ]=[==========[
local RunService=game:GetService("RunService")
local Players=game:GetService("Players")
local Util=require(game.ReplicatedStorage.Modules.Util)
local Client={}
function Client.CanRetract(a) return a.Rig and a.Rig:GetAttribute("JDCanRetract")==true end
local function update(a)
 local ability=a.Behavior.Abilities.CorruptEnergy
 local retract=Client.CanRetract(a)
 ability.Name=retract and "Retract" or "Corrupt Energy"
 ability.Icon=retract and "rbxassetid://105853980040304" or "rbxassetid://83849304758564"
 -- FCT keeps counting the original cooldown; only its rendering is suppressed while Retract is available.
 ability.Disabled=retract or a.JDCEOriginalDisabled
 local main=a.Player:FindFirstChildOfClass("PlayerGui")
 main=main and main:FindFirstChild("MainUI")
 local hotbar=main and main:FindFirstChild("AbilityContainer")
 local button=hotbar and hotbar:FindFirstChild("CorruptEnergy")
 if retract and button then
  button.Image=ability.Icon
  if button:FindFirstChild("AbilityName") then button.AbilityName.Text=ability.Name end
  if button:FindFirstChild("CooldownTime") then button.CooldownTime.Text="" end
  if button:FindFirstChild("Clipping") then
   button.Clipping.Size=UDim2.fromScale(1,1)
   button.Clipping.Top.Size=UDim2.fromScale(1,1);button.Clipping.Top.Image=ability.Icon
  end
 end
end
local function windup(a)
 local state=a.JDCEClientWindup
 if not state then return end
 local times={1.067,1.917}
 while state.next<=#times and os.clock()-state.started>=times[state.next] do
  local stage=state.next;state.next+=1
  pcall(Util.ApplyCameraShake,Util,stage*.2,stage*.35)
 end
 if state.next>#times then a.JDCEClientWindup=nil end
end
function Client.Play(a,data)
 if data and data.Retract then return end
 a.JDCEClientWindup={started=os.clock(),next=1}
 local animation=a.Animations and a.Animations.CorruptEnergy
 if animation then pcall(function()animation:Play(.025)end) end
end
function Client.Created(a)
 if a.Player~=Players.LocalPlayer then return end
 a.JDCEClientConnections={};a.JDCEOriginalDisabled=a.Behavior.Abilities.CorruptEnergy.Disabled
  a.JDCEClientConnections[1]=a.Rig:GetAttributeChangedSignal("JDCanRetract"):Connect(function()update(a)end)
 a.JDCEClientConnections[2]=RunService.RenderStepped:Connect(function()update(a);windup(a)end)
 a.JDCEClientConnections[3]=a.Rig:GetAttributeChangedSignal("Stunned"):Connect(function()
  if a.Rig:GetAttribute("Stunned") then
   a.JDCEClientWindup=nil
   local track=a.Animations and a.Animations.CorruptEnergy
   if track then pcall(function()track:Stop(.05)end) end
  end
 end)
 update(a)
end
function Client.Destroyed(a)
 a.JDCEClientWindup=nil
 for _,model in pairs(a.ActiveSpikeModels or {}) do model:Destroy() end
 a.ActiveSpikeModels={}
 for _,connection in ipairs(a.JDCEClientConnections or {}) do connection:Disconnect() end
 a.JDCEClientConnections={}
 if a.Behavior and a.Behavior.Abilities and a.Behavior.Abilities.CorruptEnergy then
  local ability=a.Behavior.Abilities.CorruptEnergy;ability.Disabled=a.JDCEOriginalDisabled;ability.Name="Corrupt Energy";ability.Icon="rbxassetid://83849304758564"
 end
end
return Client
]==========],
[ [==========[
ServerStorage/Assets/Killers/JohnDoe/Behavior/CorruptEnergyController/Rules]==========] ]=[==========[
local Rules={}
function Rules.ReserveHit(cast,target,cap)
 if not cast.active then return false end
 local hits=cast.hits[target] or 0
 if hits>=cap then return false end
 cast.hits[target]=hits+1
 return true
end
function Rules.SpawnAt(index,interval) return 2+index*interval end
return Rules
]==========],
[ [==========[
ReplicatedStorage/Modules/Hitboxes]==========] ]=[==========[
-- So, I've been trying to improve the engine recently and I just though: WHY NOT JUST RECODE EVERYTHING?????????????????
-- also improving my comments!
-- skiddy katamari will say this is trash because her engine needs to be better than anything

-- // services:
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local AnalyticsService = game:GetService("AnalyticsService")
local isStudio = RunService:IsStudio()
local isServer = RunService:IsServer()

-- // modules:
local Ragdolls = require(ReplicatedStorage.Modules.Ragdolls)
local Util = require(ReplicatedStorage.Modules.Util)
local AchievementUtil = require(ReplicatedStorage.Modules.AchievementUtil)
local Actors = require(ReplicatedStorage.Modules.Actors)
local Network = require(ReplicatedStorage.Modules.Network)
local Sounds = require(ReplicatedStorage.Modules.Sounds)
local Stats = require(ReplicatedStorage.Modules.Stats)
local Statuses = require(ReplicatedStorage.Modules.Statuses)

-- // new modules (these were originally not on forsaken neither on aeternus)
local Janitor = require(ReplicatedStorage.Modules.Misc.Janitor) -- expect to see this alot (maid will still be here to keep compatibility)
local CoreLoader = require(ReplicatedStorage.CoreLoader)
local Signal = require(ReplicatedStorage.Modules.Misc.Signal) -- why doesn't forsaken use this module

local Hitboxes = {}


-- new function to prevent wall clipping (aka. hitting someone if they are behind an wall)
local function PreventWallClip(pOrigin, pTargetPos, pExcludeChar)
	local diff = pTargetPos - pOrigin
	local dist = diff.Magnitude
	if dist > 10 then
		pTargetPos = pOrigin + diff.Unit * 10
		dist = 10
	end
	if dist < 0.1 then
		return pTargetPos
	end

	local rayParams = RaycastParams.new()
	rayParams.FilterType = Enum.RaycastFilterType.Exclude
	rayParams.FilterDescendantsInstances = { workspace.Players, pExcludeChar, workspace:FindFirstChild("Hitboxes") }

	local raycastResult = workspace:Raycast(pOrigin, diff, rayParams)
	if not raycastResult then
		return pTargetPos
	end

	local safeDist = math.max(raycastResult.Distance - 0.5, 0)
	return pOrigin + diff.Unit * safeDist
end


local function GetDictionaryLength(dict)
	local count = 0
	for _, _ in pairs(dict) do
		count += 1
	end
	return count
end


function Hitboxes.LineOfSight(_, origin, targetChar)
	local player = Players:GetPlayerFromCharacter(targetChar)

	if player then
		local _ = Actors.CurrentActors[player]
	end

	targetChar:FindFirstChild("Humanoid")

	local hasReplicating = targetChar:FindFirstChild("QueryHitbox") and (player and targetChar:HasTag("Replicating"))
	local raycastParams = RaycastParams.new()

	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.FilterDescendantsInstances = if not typeof(origin == "Vector3") then {
		workspace.Players,
		targetChar,
		origin
	} else {
			workspace.Players,
			targetChar
		}
	raycastParams.CollisionGroup = tostring(typeof(origin) ~= "Vector3" and (not not origin.PrimaryPart and origin.PrimaryPart.CollisionGroup) or "Killers")

	local function partCanBlock(hitPart)
		local isHitbox = hitPart:GetAttribute("Hitbox") or (hitPart.CanCollide or hitPart.Transparency < 1)
		local hitHumanoid = hitPart.Parent:FindFirstChild("Humanoid")

		if isHitbox and not hitHumanoid then
			return true
		end

		raycastParams:AddToFilter(hitPart)

		if hitHumanoid then
			raycastParams:AddToFilter(hitHumanoid.Parent)
		end

		return false
	end

	if typeof(origin) == "Vector3" then
	else
		local originPlayer = Players:GetPlayerFromCharacter(origin)
		local originActor = originPlayer and Actors.CurrentActors[originPlayer]

		origin = originActor and originActor:GetPivot(false).Position or origin.PrimaryPart.Position
	end

	for _, child in ipairs(targetChar:GetChildren()) do
		if not child:IsA("BasePart") or not child.CanQuery or child:GetAttribute("Hitbox") then
			continue
		end

		local objectSpace = targetChar.PrimaryPart.CFrame:ToObjectSpace(child.CFrame)
		local targetPos = hasReplicating and targetChar.QueryHitbox.CFrame:ToWorldSpace(objectSpace).Position or child.Position
		local attempts = 0
		local raycastResult

		repeat
			raycastResult = workspace:Raycast(origin, targetPos - origin, raycastParams)
			attempts += 1
		until not raycastResult or partCanBlock(raycastResult.Instance) or attempts > 15

		if not raycastResult and attempts <= 15 then
			return true
		end
	end

	return false
end


local function guestHitClient(target, ...)
	if typeof(target) == "Instance" and target:IsA("Player") then
		Network:FireClientConnection(target, ...)
	end
end
local function guestIsPlayer(target)
	return typeof(target) == "Instance" and target:IsA("Player")
end
local function guestCharacter(subject)
	if typeof(subject) == "Instance" then
		if subject:IsA("Player") then return subject.Character end
		if subject:IsA("Model") then return subject end
	elseif typeof(subject) == "table" then
		return subject.Rig or subject.Character
	end
end
local function guestActor(subject, rig)
	local player = rig and Players:GetPlayerFromCharacter(rig)
	local actor = subject and Actors.CurrentActors[subject] or player and Actors.CurrentActors[player] or rig and Actors.CurrentActors[rig]
	if actor and actor.Rig == rig then return actor end
	for _, candidate in pairs(Actors.CurrentActors) do
		if candidate.Rig == rig then return candidate end
	end
end

function Hitboxes.CreateHitbox(_, creator, hitboxParams)
	local creatorChar = guestCharacter(creator)

	if not creatorChar or not creatorChar.PrimaryPart then
		return
	end

	local params = hitboxParams or {}
	local config = {
		Size = params.Size or Vector3.new(4, 7, 4),
		CFrameOffset = params.CFrameOffset or CFrame.new(0, 0, 0),
		CFrame = params.CFrame or nil,
		CastPoint = if params.CastPoint ~= nil then params.CastPoint else nil,
		Damage = params.Damage or 15,
		AbilityType = params.AbilityType or nil,
		Time = params.Time or 0.125,
		Knockback = params.Knockback or 0,
		HitMultiple = params.HitMultiple or false,
		PredictVelocity = params.PredictVelocity == nil or params.PredictVelocity,
		ExecuteOnKill = params.ExecuteOnKill or false,
		FriendlyFire = params.FriendlyFire or false,
		Team = params.Team,
		Target = params.Target,
		OnlyHitPlayers = params.OnlyHitPlayers or false,
		RagdollOnHit = params.RagdollOnHit or false,
		Hide = params.Hide or false,
		DeathProfile = params.DeathProfile or {},
		Shape = params.Shape or Enum.PartType.Block,
		ExcludeChars = params.ExcludeChars or {},
        HitFilter = params.HitFilter,
		Connections = params.Connections or {}
	}
	local overlapParams = OverlapParams.new()

	overlapParams.FilterType = Enum.RaycastFilterType.Exclude
	overlapParams.FilterDescendantsInstances = { creatorChar }

	local hitboxState = {
		TimePast = 0,
		HumanoidsDamaged = {},
		InvincibleProcs = {},
		Creator = creator,
		AbilityType = config.AbilityType,
		Damage = config.Damage,
		IsProjectile = if params.IsProjectile ~= nil then params.IsProjectile else config.CFrame ~= nil,

		OnHit = Signal.new(),
		OnEnded = Signal.new()
	}

	local hitboxJanitor = Janitor.new()
	hitboxJanitor:Add(hitboxState.OnHit, "Destroy")
	hitboxJanitor:Add(hitboxState.OnEnded, "Destroy")

	local function runCallback(callbackName, ...)
		if config.Connections[callbackName] then
			config.Connections[callbackName](...)
		end
	end

	function hitboxState.Cancel(_)
		hitboxState.Cancelled = true
		hitboxJanitor:Cleanup()
	end

	task.spawn(function()
		local creatorActor = guestActor(creator, creatorChar)

		while creatorChar.Parent and creatorChar.PrimaryPart and hitboxState.TimePast < config.Time and not hitboxState.Cancelled do
			local humanoidsDamaged = hitboxState.HumanoidsDamaged
			local hitCount = 0

			for _, _ in pairs(humanoidsDamaged) do
				hitCount += 1
			end

			if hitCount > 0 and not config.HitMultiple or creatorChar:GetAttribute("Stunned") or not Util:IsAlive(creatorChar) and not hitboxState.IsProjectile then
				break
			end

			local pivotCF = creatorActor and creatorActor:GetPivot(not not config.PredictVelocity) or creatorChar.PrimaryPart.CFrame
			local hitboxPart = Instance.new("Part")

			hitboxPart.Name = tostring(creator) .. "Hitbox"
			hitboxPart.Transparency = 1
			hitboxPart.CanCollide = false
			hitboxPart.CanTouch = false
			hitboxPart.CanQuery = false
			hitboxPart.CastShadow = false
			hitboxPart.Anchored = true
			hitboxPart.Shape = config.Shape
			hitboxPart.Size = typeof(config.Size) == "function" and config.Size() or config.Size
			hitboxPart.CFrame = typeof(config.CFrame) == "function" and config.CFrame() or (config.CFrame or pivotCF * if typeof(config.CFrameOffset) ~= "function" then config.CFrameOffset else config.CFrameOffset())
			hitboxPart.Parent = workspace:FindFirstChild("Hitboxes")
			hitboxState.Instance = hitboxPart

			task.delay(0.36, function()
				if hitboxPart and hitboxPart.Parent then hitboxPart:Destroy() end
			end)

			if config.Hide then
				hitboxPart:SetAttribute("Hidden", true)
			end

			if config.PredictVelocity then
				if typeof(creator) ~= "Instance" or not creator:IsA("Player") then
				end
			end

			local partsFound = workspace:GetPartsInPart(hitboxPart, overlapParams)

			table.sort(partsFound, function(partA, partB)
				local parentA = partA.Parent
				local parentB = partB.Parent
				local priorityA = parentA:GetAttribute("HitboxPriority") or 1
				local priorityB = parentB:GetAttribute("HitboxPriority") or 1

				if priorityA == priorityB then
					priorityA = (creatorChar.PrimaryPart.Position - partB.Position).Magnitude
					priorityB = (creatorChar.PrimaryPart.Position - partA.Position).Magnitude
				end

				return priorityB < priorityA
			end)

			local targetsHit = {}

			for _, hitPart in ipairs(partsFound) do
				local victimHumanoid = hitPart.Parent:FindFirstChildOfClass("Humanoid")

				if victimHumanoid and not (victimHumanoid.Health <= 0) and (not victimHumanoid.Parent:HasTag("Replicating") or not Players:GetPlayerFromCharacter(victimHumanoid.Parent) or hitPart.Name == "QueryHitbox") and ((not victimHumanoid.Parent:HasTag("SurvivorConstruct") or not config.OnlyHitPlayers) and not hitboxState.HumanoidsDamaged[victimHumanoid]) and (not config.Team or tostring(hitPart.Parent.Parent) == config.Team or tostring(hitPart.Parent:GetAttribute("Team")) == config.Team) and ((workspace:GetAttribute("FriendlyFire") or config.FriendlyFire or config.Team and config.Team == tostring(creatorChar.Parent) or tostring(hitPart.Parent:GetAttribute("Team")) ~= tostring(creatorChar.Parent) and tostring(hitPart.Parent.Parent) ~= tostring(creatorChar.Parent)) and (not config.Target or config.Target == victimHumanoid.Parent)) then
					local castOrigin = if not config.CastPoint then if config.CFrame then hitboxPart.CFrame.Position else creatorChar else if typeof(config.CastPoint) ~= "function" then config.CastPoint else config.CastPoint()

							if (config.CastPoint == false or Hitboxes:LineOfSight(castOrigin, victimHumanoid.Parent)) and not table.find(config.ExcludeChars, victimHumanoid.Parent) and not table.find(config.ExcludeChars, victimHumanoid) then
								if victimHumanoid.Parent:GetAttribute("Invincible") then
									if not hitboxState.InvincibleProcs[victimHumanoid] then
										local victimPrimaryPart = victimHumanoid.Parent.PrimaryPart
										local invincibleFX = victimPrimaryPart and victimPrimaryPart:FindFirstChild("InvincibleFX")

										if invincibleFX and invincibleFX:FindFirstChild("Deflect") then
											Sounds:Play("invincibleDeflect", {
												Parent = victimPrimaryPart
											})
											invincibleFX.Deflect:Emit(1)
										end
									end

									hitboxState.InvincibleProcs[victimHumanoid] = true
								else
									local hitPriority = victimHumanoid.Parent:GetAttribute("HitboxPriority") or 1

									hitboxState.HumanoidsDamaged[victimHumanoid] = true
									table.insert(targetsHit, victimHumanoid)

									if not config.HitMultiple and hitPriority >= 0 then
										break
									end
								end
							end
						end
					end

					hitboxPart.Color = #targetsHit > 0 and Color3.new(0.5, 1, 0.5) or Color3.new(1, 0.25, 0.25)

					for i, victimHumanoid in ipairs(targetsHit) do
						local victimChar = victimHumanoid.Parent
                        -- Optional per-hitbox predicate, before damage and all victim hit reactions.
                        if config.HitFilter and not config.HitFilter(victimChar,hitboxState) then continue end
						local victimPrimaryPart = victimChar and (victimChar:IsA("Model") and victimChar.PrimaryPart)
						local rawDamage = typeof(config.Damage) == "number" and config.Damage or config.Damage(victimChar)
						local resistanceSum = 0
						local resistanceFolder = victimChar and victimChar:FindFirstChild("ResistanceMultipliers")

						for _, resistanceValue in pairs(resistanceFolder and resistanceFolder:GetChildren() or {}) do
							resistanceSum += resistanceValue.Value
						end

						local weakenedDamage = require(game.ReplicatedStorage.Modules.DamageRules).ScaleDamage(creatorChar, rawDamage)
						local finalDamage = weakenedDamage * (1 - math.min(resistanceSum - (creatorChar:GetAttribute("StrengthBuff") or 0), 100) / 100)

						if not victimPrimaryPart then
							continue
						end

						victimChar:SetAttribute("TimesHit", (victimChar:GetAttribute("TimesHit") or 0) + 1)
						runCallback("HitAbsolute", victimChar, i == 1)

						local victimPlayer = Players:GetPlayerFromCharacter(victimChar)
						local victimActor = guestActor(victimPlayer, victimChar)

						if victimActor and victimActor.Behavior and victimActor.Behavior.OnHit then
							local hitResponse = victimActor.Behavior:OnHit(
								victimActor,
								hitboxState,
								finalDamage
							)

							if hitResponse == "Ignored" then
								continue
							end

							if typeof(hitResponse) == "table"
								and typeof(hitResponse.DamageOverride) == "number" then

								finalDamage = math.max(0, hitResponse.DamageOverride)
							end

							if hitboxState.TimePast > config.Time then
								break
							end
						end

						local knockbackVal = not (typeof(config.Knockback) ~= "number" and typeof(config.Knockback) ~= "Vector3") and config.Knockback or config.Knockback(victimChar)
						local isKbVector = typeof(knockbackVal) == "Vector3"
						local kbDir = isKbVector and knockbackVal or hitboxPart.CFrame.LookVector

						if isKbVector or knockbackVal > 0 then
							local kbForce = (typeof(knockbackVal) == "Vector3" and knockbackVal or kbDir * knockbackVal) * 10

							if victimPlayer then
								guestHitClient(victimPlayer, "KB", "REMOTE_EVENT", Util:SerializeVector(kbForce))
							else
								victimPrimaryPart.AssemblyLinearVelocity = kbForce + victimPrimaryPart.AssemblyLinearVelocity / 2
							end
						end

						local deathProfile = Util:CopyTable(config.DeathProfile)

						if not deathProfile.Velocity then
							if isKbVector then
								deathProfile = {
									Velocity = kbDir * 10
								}
							elseif knockbackVal > 0 then
								deathProfile = {
									Velocity = kbDir * knockbackVal * 10
								}
							end
						end

						Ragdolls.AddProfile(victimChar, deathProfile)

						local damageDealt = finalDamage
						local overhealVal = victimHumanoid:GetAttribute("Overheal") or 0
						local shatterpointHP = victimChar:GetAttribute("ShatterpointHP") or 0
						local _ = victimHumanoid.Health + overhealVal + shatterpointHP
						local isVictimAlive = victimHumanoid.Health > 0
						local remainingOverheal = math.max(0, overhealVal - finalDamage)

						if remainingOverheal < (victimHumanoid:GetAttribute("OverhealDecayMin") or 0) then
							victimHumanoid:SetAttribute("OverhealDecayMin", remainingOverheal > 0 and remainingOverheal or nil)
						end

						local damageToApply = finalDamage - overhealVal

						if damageToApply > 0 and shatterpointHP > 0 then
							local shatterDamage = damageToApply * (victimChar:GetAttribute("ShatterpointResistance") or 1)

							if shatterDamage > 0 then
								local victimBehaviorActor = guestActor(victimPlayer, victimChar)

								if victimBehaviorActor and victimBehaviorActor.Behavior and victimBehaviorActor.Behavior.sv_DamageCrystalHP then
									victimBehaviorActor.Behavior:sv_DamageCrystalHP(victimBehaviorActor, shatterDamage)
								else
									victimChar:SetAttribute("ShatterpointHP", (math.max(0, shatterpointHP - shatterDamage)))
								end

								local shatterRemainder = shatterDamage - shatterpointHP

								damageDealt = shatterDamage + overhealVal
								damageToApply = not (shatterRemainder > 0) and 0 or shatterRemainder
							end
						end

						local finalDeductibleDamage = math.max(0, damageToApply)
						local victimPosInt16 = Vector3int16.new(victimPrimaryPart.Position.X, victimPrimaryPart.Position.Y, victimPrimaryPart.Position.Z)
						local isKilled = victimHumanoid.Health - finalDeductibleDamage <= 0
						local creatorBehaviorActor = guestActor(creator, creatorChar)

						if creatorBehaviorActor then
							local _, _ = pcall(function()
								return creatorBehaviorActor.Behavior.OnInflictedDamage(creatorBehaviorActor, victimChar, (math.min(victimHumanoid.Health, damageDealt)))
							end)
						end

						if isVictimAlive and isKilled then
							local protectionPlayerName = victimChar:GetAttribute("DusekkarProtected")
							local protectionPlayer = protectionPlayerName and Players:FindFirstChild(protectionPlayerName)

							if protectionPlayer then
								local protectorChar = protectionPlayer.Character

								print(`dusekkar moment ({ victimChar } protected by { protectionPlayer })`)
								Actors:IncrementActorStats(protectionPlayer, {
									Action = "Prevented the death of a Survivor",
									Money = 10,
									EXP = 30
								})
								victimChar:SetAttribute("DusekkarProtected", nil)
								protectorChar:SetAttribute("Protecting", nil)
								AchievementUtil:IncrementAchievementProgress(protectionPlayer, "DusekkarUbercharge")

								return
							end

							if tostring(victimChar.Parent) == "Survivors" then
								if guestIsPlayer(creator) then
									Stats:UpdatePlayerStat(creator, "Kills", "Add", 1)
								end

								if creatorBehaviorActor then
									creatorBehaviorActor.TotalKills =
										(creatorBehaviorActor.TotalKills or 0) + 1

									local ok, result = pcall(function()
										AnalyticsService:LogCustomEvent(creator, "TotalKills", 1, {
											[Enum.AnalyticsCustomFieldKeys.CustomField01.Name] = `Character - { creatorBehaviorActor.ActorName }`
										})
									end)

									if not ok then
										warn(`[AnalyticsService]: Failed to log custom event: TotalKills due to: { result }`)
									end
								end
							end

							local creatorVoicelines = creatorBehaviorActor and creatorBehaviorActor.Config.Voicelines

							if creatorVoicelines and not victimChar:GetAttribute("ExecutionsDisabled") then
								local killType = "Kill"

								if isServer then
									local RoundManager = require(game.ServerScriptService.Server.Systems.Core.RoundManager)

									if RoundManager and RoundManager.CurrentSession and RoundManager.CurrentSession.LastSurvivorAlive then
										killType = "LastKill"
									end
								end

								for _, actionName in ipairs({
									killType,
									"Kill"
									}) do
									if creatorVoicelines[`{ actionName }{ tostring(victimChar:GetAttribute("SkinName")) }`] then
										Sounds:PlayVoiceline(creatorBehaviorActor, `Kill{ tostring(victimChar:GetAttribute("SkinName")) }`)

										break
									end

									if creatorVoicelines[`{ actionName }{ victimChar.Name }`] then
										Sounds:PlayVoiceline(creatorBehaviorActor, `Kill{ victimChar.Name }`)

										break
									end

									if creatorVoicelines[`{ actionName }`] then
										Sounds:PlayVoiceline(creatorBehaviorActor, "Kill")

										break
									end
								end
							end

							local RoundManager = game.ServerScriptService.Server.Systems.Core.RoundManager
							local lib = require(RoundManager)

							if tostring(victimChar.Parent) == "Survivors" and (lib.CurrentSession and lib.CurrentSession.TimePast or isStudio or workspace:GetAttribute("Testing")) then
								lib:AddTime(nil, victimActor and victimActor.TimeAddMultiplier or 1, true)

								if creatorBehaviorActor and creatorBehaviorActor.Behavior and creatorBehaviorActor.Behavior.OnKill then
									local ok, result = pcall(function()
										return creatorBehaviorActor.Behavior.OnKill(creatorBehaviorActor, victimChar)
									end)

									if not ok then
										warn(`[{ script }/CreateHitbox]: Failed to call .OnKill() due to: { result }`)
									end
								end

								require(game.ServerScriptService.Server.Systems.Core.EventHandlerServer):CallMethod("OnPlayerKilled", creator, victimPlayer)
								if guestIsPlayer(creator) then
									Actors:IncrementActorStats(creator, {
										Action = "Killed a Survivor", Money = 15, EXP = 45
									})
								end
							end

							if config.ExecuteOnKill and guestIsPlayer(creator) and creatorBehaviorActor and not victimChar:GetAttribute("ExecutionsDisabled") and not (creatorBehaviorActor.AbilityDisablers or {}).Execution then
								local skinName = victimChar:GetAttribute("SkinName")
								local executionAnimName = nil

								if not creatorBehaviorActor then
									warn("Hitboxes: Non-Actor attempted to Execute!")
								else
									executionAnimName = if not skinName or (skinName == "" or not creatorBehaviorActor.Config.Animations[`Execution{ skinName }`]) then not creatorBehaviorActor.Config.Animations[`Execution{ victimChar.Name }`] and "Execution" or `Execution{ victimChar.Name }` else `Execution{ skinName }`
								end

								local executionAnimConfig = creatorBehaviorActor and creatorBehaviorActor.Config.Animations[executionAnimName]

								if executionAnimConfig and executionAnimConfig.KillerRig and executionAnimConfig.PlayerRig then
									task.spawn(function()
										Statuses:RemoveStatuses(victimChar, true)
										Util:GiveStackableAttribute(victimChar, "BeingExecuted", `{ creatorBehaviorActor.Player.Name }Execution`, 10)

										local killerTrack = creatorBehaviorActor.Cache[`{ executionAnimName }Anim`]

										if not killerTrack then
											killerTrack = Util:LoadAnimationFromID(creatorBehaviorActor.Rig, executionAnimConfig.KillerRig, false)
											creatorBehaviorActor.Cache[`{ executionAnimName }Anim`] = killerTrack
										end

										local killerPrimaryPart = creatorBehaviorActor.Rig.PrimaryPart
										local victimTrack = Util:LoadAnimationFromID(victimChar, executionAnimConfig.PlayerRig, false)
										local isExecutionFinished = false
										local stateConn = nil

										stateConn = victimHumanoid.StateChanged:Connect(function(_, newState)
											if newState == Enum.HumanoidStateType.Dead then
												isExecutionFinished = true

												if stateConn then
													stateConn:Disconnect()
													hitboxJanitor:Remove("Execution_" .. victimHumanoid.Name)
												end

												guestHitClient(creator, "Hit", "UREMOTE_EVENT", damageDealt, victimPosInt16, nil, true)
											end
										end)

										hitboxJanitor:Add(stateConn, "Disconnect", "Execution_" .. victimHumanoid.Name)

										Util:GiveInvincible(creatorChar, "Executing")
										Util:SetUpCutscene(creatorBehaviorActor.Rig, victimChar, executionAnimConfig.PlayerCFrameOffset, "Execution")
										task.delay(killerTrack.Length + 1.5, function()
											Util:RemoveInvincible(creatorChar, "Executing")
										end)
										creatorBehaviorActor:DisableAbilities("Execution", true)
										task.delay(killerTrack.Length, function()
											if stateConn then
												stateConn:Disconnect()
												hitboxJanitor:Remove("Execution_" .. victimHumanoid.Name)
											end

											if not isExecutionFinished then
												isExecutionFinished = true
												guestHitClient(creator, "Hit", "UREMOTE_EVENT", damageDealt, victimPosInt16, nil, true)
											end

											creatorBehaviorActor:DisableAbilities("Execution", false)
											Util:ToggleAnchored(creatorBehaviorActor.Rig, "Execution", false)
											Util:ToggleAnchored(victimChar, "Execution", false)
											Util:RemoveStackableAttribute(victimChar, "NoItems", "Execution")
											victimHumanoid.Health = 0
											victimHumanoid:ChangeState(Enum.HumanoidStateType.Dead)
										end)
										killerTrack:Play(0)
										victimTrack:Play(0)

										local executionSound = creatorBehaviorActor.Config.Sounds[executionAnimName]

										Sounds:Play(executionSound, {
											Parent = killerPrimaryPart
										})

										if creatorBehaviorActor.Behavior.OnExecution then
											creatorBehaviorActor.Behavior:OnExecution(creatorBehaviorActor, victimChar, {
												victimInfo = victimActor,
												Tracks = {
													Killer = killerTrack,
													Victim = victimTrack
												}
											})
										end

										if creatorBehaviorActor.Behavior.OnExecutionClient then
											guestHitClient(creatorBehaviorActor.Player, "OnExecutionClientAsync", "REMOTE_EVENT", victimChar)
										end
									end)

									return
								end
							end
						end

						if config.RagdollOnHit then
							local ragdollTime = typeof(config.RagdollOnHit) == "number" and config.RagdollOnHit or 2

							Ragdolls.EnableRagdoll(victimChar, ragdollTime)
						end

						victimChar:SetAttribute("RecentAttacker", (tostring(creator)))
						victimChar:SetAttribute("RecentAttackerTime", os.clock())

						if victimHumanoid:GetAttribute("Overheal") then
							victimHumanoid:SetAttribute("Overheal", remainingOverheal > 0 and remainingOverheal or nil)
						end

						victimHumanoid.Health = victimHumanoid.Health - finalDeductibleDamage

						if victimHumanoid.Health <= 0 then
							victimHumanoid:SetAttribute("Overheal", nil)
							victimHumanoid:ChangeState(Enum.HumanoidStateType.Dead)
						end

						runCallback("Hit", victimChar, i == 1)
						hitboxState.OnHit:Fire(victimChar, i == 1)

						guestHitClient(creator, "Hit", "UREMOTE_EVENT", damageDealt, victimPosInt16, nil, victimHumanoid.Health <= 0)
					end

					local stateRef = hitboxState

					stateRef.TimePast = stateRef.TimePast + RunService.Heartbeat:Wait()
				end

				runCallback("Ended")
				hitboxState.OnEnded:Fire()
			end)

	task.delay(config.Time + 1, function()
		hitboxJanitor:Cleanup()
	end)

	return hitboxState
end


function Hitboxes.Start(_)
	if isServer then
		local Folder = Instance.new("Folder")

		Folder.Name = "Hitboxes"
		Folder.Parent = workspace
	end
end


function Hitboxes.CreateMainAbilityHitbox(self, creator, options)
	local params = table.clone(options or {})
	if params.AbilityType == nil then params.AbilityType = "MainAbility" end
	if params.IsProjectile == nil then params.IsProjectile = false end
	return self:CreateHitbox(creator, params)
end

return Hitboxes
]==========]
}

local function locate(path)
 local current=game
 for name in path:gmatch("[^/]+")do current=current and current:FindFirstChild(name)end
 return current
end
local function fixture()
 fresh()
 for path,source in pairs(originals)do
  local current=game;local parts=string.split(path,"/")
  for i=1,#parts-1 do current=current:FindFirstChild(parts[i])or child(current,parts[i])end
  local module=child(current,parts[#parts],"ModuleScript");module.Source=source
 end
end
local function install()
-- John Doe phase 2: Corrupt Energy + Retract. Requires the phase-one rig/alignment patch.
assert(game:GetService("RunService"):IsStudio() and not game:GetService("RunService"):IsRunning(),"Stop Play before updating Corrupt Energy.")
local function find(path)
 local current=game
 for name in path:gmatch("[^/]+") do current=current and current:FindFirstChild(name) end
 return current
end
local function fingerprint(source)
 local a,b=5381,0
 for i=1,#source do local byte=string.byte(source,i);a=(a*33+byte)%4294967296;b=(b*65599+byte)%4294967296 end
 return string.format("%d:%08x:%08x",#source,a,b)
end
local plans={
{path=[========[
ReplicatedStorage/Assets/Killers/JohnDoe/Behavior]========],source=[========[
-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local _ = require(game.ReplicatedStorage.GlobalTypes);
local v1 = {};
local CorruptEnergyController=require(script.CorruptEnergyController);
local RigAlignment=require(script.RigAlignment);
v1.GetRig=function(_,actor) return RigAlignment.GetRig(actor) end;
local l_TweenService_0 = game:GetService("TweenService");
local _ = game:GetService("HttpService");
local l_Players_0 = game:GetService("Players");
local v5 = require(game.ReplicatedStorage.Modules.Sounds);
local v6 = require(game.ReplicatedStorage.Modules.Util);
local v7 = require(game.ReplicatedStorage.Modules.Hitboxes);
local v8 = require(game.ReplicatedStorage.Modules.Statuses);
local v9 = require(game.ReplicatedStorage.Modules.Network);
local v10 = require(game.ReplicatedStorage.Modules.AchievementUtil);
local function v16(v11, v12, v13, ...) --[[ Line: 23 ]] --[[ Name: pcallMethod ]]
    local l_status_0, l_result_0 = pcall(function(...) --[[ Line: 24 ]]
        -- upvalues: v13 (copy), v11 (copy)
        if v13.Behavior[v11] then
            return v13.Behavior[v11](v13.Behavior, v13, ...);
        else
            return;
        end;
    end, ...);
    if not l_status_0 then
        warn((("[%*]: Failed to call .%*() due to: %*"):format(v12, v11, l_result_0)));
    end;
    return l_result_0;
end;
v1.Abilities = {
    Slash = {
        LayoutOrder = 1, 
        Icon = "rbxassetid://92362553672440", 
        KeybindType = "MainAbility", 
        Callback = function(v17) --[[ Line: 42 ]] --[[ Name: Callback ]]
            -- upvalues: v5 (copy), v7 (copy), v6 (copy)
            if game["Run Service"]:IsServer() then
                v17.AbilitiesDisabled = true;
                v5:Play(v17.Config.Sounds.Swing, {
                    Parent = v17.Rig.PrimaryPart, 
                    PlaybackSpeed = Random.new():NextNumber(0.975, 1.025), 
                    Volume = 0.35
                });
                task.delay(v17.Config.SlashWindup, function() --[[ Line: 49 ]]
                    -- upvalues: v7 (ref), v17 (copy), v6 (ref), v5 (ref)
                    local _ = v7:CreateHitbox(v17.Player, { AbilityType = "MainAbility", IsProjectile = false, 
                        Size = Vector3.new(4.5, 6, 7.5, 0), 
                        CFrameOffset = RigAlignment.SlashOffset(v17), 
                        Damage = v17.Config.SlashDamage, 
                        Time = v17.Config.SlashLinger, 
                        Knockback = 2, 
                        HitMultiple = false, 
                        ExecuteOnKill = true, 
                        Connections = {
                            Hit = function(v18, v19) --[[ Line: 61 ]] --[[ Name: Hit ]]
                                -- upvalues: v6 (ref), v5 (ref), v17 (ref)
                                v6:CreateSpeedMultiplier(v18, 1.5, "HitSpeedBonus", 1.25);
                                if v19 then
                                    v5:Play(v17.Config.Sounds.Hit, {
                                        Parent = v17.Rig.PrimaryPart, 
                                        PlaybackSpeed = Random.new():NextNumber(0.975, 1.025), 
                                        Volume = 0.5
                                    });
                                end;
                            end
                        }
                    });
                end);
                task.delay(0.75, function() --[[ Line: 72 ]]
                    -- upvalues: v17 (copy)
                    v17.AbilitiesDisabled = false;
                end);
                return;
            else
                if game["Run Service"]:IsClient() then
                    if v17.Animations.Slash1 then
                        v17.Animations[("Slash%*"):format((tostring(math.random(1, 2))))]:Play(0.025);
                        return;
                    else
                        v17.Animations.Slash:Play(0.025);
                    end;
                end;
                return;
            end;
        end
    }, 
    CorruptEnergy = {
        LayoutOrder=2,Name="Corrupt Energy",Icon="rbxassetid://83849304758564",KeybindType="AltAbility1",
        Cooldown=function(actor)
            return CorruptEnergyController.CanRetract(actor) and 0 or actor.Config.CorruptEnergyCooldown
        end,
        Callback=function(actor,data)
            if game:GetService("RunService"):IsServer() then
                local result=CorruptEnergyController.Cast(actor)
                if not result.Cancelled and not result.Retract then v16("CorruptEnergyStart","JohnDoe/CorruptEnergyStart",actor) end
                return result
            end
            if not (data and data.Retract) then v16("CorruptEnergyStart","JohnDoe/CorruptEnergyStart",actor) end
            return CorruptEnergyController.Play(actor,data)
        end
    },
    DigitalFootprint = {
        LayoutOrder = 3, 
        Icon = "rbxassetid://83206360003394", 
        KeybindType = "AltAbility2", 
        Callback = function(v51, v52) --[[ Line: 311 ]] --[[ Name: Callback ]]
            -- upvalues: v5 (copy), v16 (copy), v6 (copy), v8 (copy), v9 (copy), l_Players_0 (copy)
            local v53 = {
                0.317, 
                1.05, 
                2.067
            };
            local v54 = 0;
            local v55 = 0;
            if game["Run Service"]:IsServer() then
                v51.AbilitiesDisabled = true;
                v5:Play(v51.Config.Sounds.DigitalFootprint, {
                    Parent = v51.Rig.PrimaryPart, 
                    Volume = 0.4, 
                    TimePosition = 0.09, 
                    PlaybackSpeed = 1.2
                });
                v16("DFStart", ("%*/DFS"):format(script.Parent), v51);
                local function v60(v56) --[[ Line: 323 ]] --[[ Name: removeShadow ]]
                    -- upvalues: v6 (ref), v51 (copy)
                    if v56 and v56.Parent then
                        v56.Name = "okByeBye";
                        v56.Parent = workspace.Map.Ingame;
                        game.Debris:AddItem(v56, 5);
                        local l_ShadowAmbience_0 = v56:FindFirstChild("ShadowAmbience");
                        if l_ShadowAmbience_0 then
                            game.TweenService:Create(l_ShadowAmbience_0, TweenInfo.new(2), {
                                Volume = 0
                            }):Play();
                        end;
                        for _, v59 in pairs(v56:GetDescendants()) do
                            if v59:IsA("ParticleEmitter") then
                                v59.Enabled = false;
                            end;
                        end;
                        v6:RemovePlayerAuraFrom(v56, v51.Player);
                    end;
                end;
                local l_FirstChild_0 = workspace.Map.Ingame:FindFirstChild((("%*Shadows"):format((tostring(v51.Player)))));
                if not l_FirstChild_0 then
                    l_FirstChild_0 = Instance.new("Folder");
                    l_FirstChild_0.Name = ("%*Shadows"):format((tostring(v51.Player)));
                    l_FirstChild_0.Parent = workspace.Map.Ingame;
                end;
                local l_l_FirstChild_0_Children_0 = l_FirstChild_0:GetChildren();
                if #l_l_FirstChild_0_Children_0 >= v51.Config.DigitalFootprintLimit then
                    v60(l_l_FirstChild_0_Children_0[1]);
                end;
                local v63 = v51.Config.Shadow:Clone();
                v63.Size = Vector3.new(1, 0, 0, 0);
                v63.Parent = l_FirstChild_0;
                v5:Play(v51.Config.Sounds.DigitalFootprintAmbience, {
                    Parent = v63, 
                    Name = "ShadowAmbience", 
                    RollOffMaxDistance = 30, 
                    Looped = true
                });
                local v64 = RaycastParams.new();
                v64.FilterDescendantsInstances = {
                    workspace.Players, 
                    v63
                };
                v64.FilterType = Enum.RaycastFilterType.Exclude;
                task.delay(tonumber(v53[#v53]) or 2.55, function() --[[ Line: 380 ]]
                    -- upvalues: v6 (ref), v63 (copy), v51 (copy), v60 (copy), v8 (ref), v9 (ref), l_Players_0 (ref)
                    v6:ApplyUnsafeTouched(v63, false, function(_, v66) --[[ Line: 381 ]]
                        -- upvalues: v6 (ref), v51 (ref), v63 (ref), v60 (ref), v8 (ref), v9 (ref), l_Players_0 (ref)
                        local l_Parent_0 = v66.Parent;
                        local v68 = l_Parent_0 and l_Parent_0:FindFirstChild("Humanoid");
                        if v68 and v6:GetEntityType(l_Parent_0) and l_Parent_0 ~= v51.Rig and v68 and v68.Health > 0 and v63.Name == "Shadow" and not l_Parent_0:GetAttribute("ExecutionsDisabled") then
                            v60(v63);
                            v6:RevealPlayerAuraTo(v51.Rig, l_Parent_0, 10);
                            v6:RevealPlayerAuraTo(l_Parent_0, v51.Rig, 10);
                            v8:ApplyStatus(v51.Rig, "Speed", {
                                Level = 1, 
                                Duration = 10
                            });
                            v8:ApplyStatus(l_Parent_0, "Slowness", {
                                Level = 2, 
                                Duration = 10
                            });
                            v8:ApplyStatus(l_Parent_0, "Corrupted", {
                                Level = 1, 
                                Duration = 10, 
                                Killer = v51
                            });
                            if not v51.FootprintRewardDebounce[l_Parent_0] then
                                v51.FootprintRewardDebounce[l_Parent_0] = true;
                                require(game.ReplicatedStorage.Modules.Actors):IncrementActorStats(v51.Player, {
                                    Action = "Survivor stepped into a Digital Footprint trap", 
                                    RewardType = "RegularKillerAction"
                                });
                                task.delay(15, function() --[[ Line: 408 ]]
                                    -- upvalues: v51 (ref), l_Parent_0 (copy)
                                    v51.FootprintRewardDebounce[l_Parent_0] = nil;
                                end);
                            end;
                            v9:FireClientConnection(l_Players_0:GetPlayerFromCharacter(l_Parent_0), ("%*JDPuddleEffect"):format(v51.Player.Name), "REMOTE_EVENT");
                        end;
                    end, 14);
                end);
                task.spawn(function() --[[ Line: 419 ]]
                    -- upvalues: v54 (ref), v63 (copy), v55 (ref), v53 (copy), v51 (copy), v64 (copy), v16 (ref), v9 (ref)
                    while v54 ~= 3 and v63.Parent and v63.Name == "Shadow" do
                        v55 = v55 + game["Run Service"].Heartbeat:Wait();
                        for v69 = #v53, 1, -1 do
                            if v53[v69] and v55 >= v53[v69] then
                                table.remove(v53, v69);
                                v54 = v54 + 1;
                                local l_Position_2 = (v51.Rig.PrimaryPart.CFrame * CFrame.new(-1.1, 0, -2)).Position;
                                local v71 = workspace:Raycast(l_Position_2, Vector3.new(0, -100, 0, 0), v64);
                                v63.Position = (v71 and v71.Position or v51.Rig.PrimaryPart.Position - Vector3.new(0, 2.5, 0, 0)) + Vector3.new(0, 0.5, 0, 0);
                                game.TweenService:Create(v63, TweenInfo.new(1), {
                                    Size = Vector3.new(1, v54 * 6, v54 * 6)
                                }):Play();
                                v16("OnStomp", ("%*/OnStomp"):format(script.Parent), v51, v63, v54);
                                if v54 == 3 then
                                    v9:FireAllClientConnection(("%*OnPuddleRevealed"):format(v51.Player.Name), "REMOTE_EVENT", v63);
                                end;
                            end;
                        end;
                    end;
                end);
                task.delay(3, function() --[[ Line: 446 ]]
                    -- upvalues: v51 (copy)
                    v51.AbilitiesDisabled = false;
                end);
                return v63;
            else
                if game["Run Service"]:IsClient() then
                    v51.Animations.DigitalFootprint:Play(0.025);
                    local l_Connections_0 = v51.Behavior.Connections;
                    if not l_Connections_0.onShadowFolderAdded or not l_Connections_0.onShadowFolderRemoved then
                        local l_FirstChild_1 = workspace.Map.Ingame:FindFirstChild((("%*Shadows"):format((tostring(v51.Player)))));
                        if not l_FirstChild_1 then
                            return;
                        else
                            local l_AbilityContainer_0 = v51.Player.PlayerGui.MainUI:FindFirstChild("AbilityContainer");
                            local v75 = l_AbilityContainer_0 and l_AbilityContainer_0:FindFirstChild("DigitalFootprint");
                            local v76 = 1;
                            do
                                local l_v76_0 = v76;
                                local function v80(v78) --[[ Line: 465 ]] --[[ Name: onShadowChange ]]
                                    -- upvalues: v75 (copy), l_v76_0 (ref), v51 (copy)
                                    if not v75 then
                                        return;
                                    else
                                        l_v76_0 = math.max(0, l_v76_0 + v78);
                                        v75.Charges.Text = l_v76_0 == 0 and "" or l_v76_0;
                                        local v79 = l_v76_0 >= v51.Config.DigitalFootprintLimit;
                                        v75.Charges.TextColor3 = v79 and Color3.new(1, 0, 0) or Color3.new(1, 1, 1);
                                        return;
                                    end;
                                end;
                                v51.Behavior.Connections.onShadowFolderAdded = l_FirstChild_1.ChildAdded:Connect(function(v81) --[[ Line: 477 ]]
                                    -- upvalues: v80 (copy)
                                    if not v81:IsA("BasePart") then
                                        return;
                                    else
                                        v80(1);
                                        return;
                                    end;
                                end);
                                v51.Behavior.Connections.onShadowFolderRemoved = l_FirstChild_1.ChildRemoved:Connect(function(v82) --[[ Line: 485 ]]
                                    -- upvalues: v80 (copy)
                                    if not v82:IsA("BasePart") then
                                        return;
                                    else
                                        v80(-1);
                                        return;
                                    end;
                                end);
                                v80(0);
                            end;
                        end;
                    end;
                    local l_v6_SpeedMultiplier_1 = v6:CreateSpeedMultiplier(v51.Player, 0, "DigitalFootprint");
                    game.Debris:AddItem(l_v6_SpeedMultiplier_1, 3);
                    task.spawn(function() --[[ Line: 501 ]]
                        -- upvalues: v51 (copy), v53 (copy), v55 (ref), v54 (ref), v6 (ref)
                        while v51 and v51.Rig.Parent and v53[1] do
                            v55 = v55 + game["Run Service"].Heartbeat:Wait();
                            for v84 = #v53, 1, -1 do
                                if v53[v84] and v55 >= v53[v84] then
                                    table.remove(v53, v84);
                                    v54 = v54 + 1;
                                    v6:ApplyCameraShake(v54 * 0.2, v54 * 0.375);
                                end;
                            end;
                        end;
                    end);
                    task.delay(3, function() --[[ Line: 517 ]]
                        -- upvalues: v52 (copy), v6 (ref)
                        if not v52 or not v52.Parent then
                            return;
                        else
                            v52.Transparency = 0;
                            v6:RevealPlayerAura(v52, "inf", Color3.new(1, 0.321569, 0.333333), nil, {
                                OutlineTransparency = 0.35, 
                                FillTransparency = 1
                            });
                            return;
                        end;
                    end);
                end;
                return;
            end;
        end
    }, 
    ["404Error"] = {
        Name = "404 Error", 
        LayoutOrder = 4, 
        Icon = "rbxassetid://131116145215571", 
        KeybindType = "AltAbility3", 
        Callback = function(v85) --[[ Line: 537 ]] --[[ Name: Callback ]]
            -- upvalues: v16 (copy), v5 (copy), v6 (copy), v9 (copy)
            v16("ErrorStart", ("%*/404S"):format(script.Parent), v85);
            if game["Run Service"]:IsServer() then
                v85.CurrentAbility = "404Error";
                v85.Config.StunDuration = v85.Config.UnstoppableDuration;
                v85.AbilitiesDisabled = true;
                v5:Play(v85.Config.Sounds["404Error"], {
                    Parent = v85.Rig.PrimaryPart, 
                    Volume = 0.4, 
                    TimePosition = 0.09, 
                    RollOffMaxDistance = 200, 
                    PlaybackSpeed = 1.15
                });
                task.delay(1.625, function() --[[ Line: 550 ]]
                    -- upvalues: v85 (copy)
                    v85.Config.StunDuration = nil;
                    v85.CurrentAbility = nil;
                    v85.AbilitiesDisabled = false;
                end);
                return;
            else
                if game["Run Service"]:IsClient() then
                    local l_v6_SpeedMultiplier_2 = v6:CreateSpeedMultiplier(v85.Player, 1, "404Error");
                    local l_v6_FOVMultiplier_0 = v6:CreateFOVMultiplier(v85.Player, 1, "404Error");
                    game.TweenService:Create(l_v6_SpeedMultiplier_2, TweenInfo.new(0.5), {
                        Value = 0.25
                    }):Play();
                    game.TweenService:Create(l_v6_FOVMultiplier_0, TweenInfo.new(1.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, true), {
                        Value = 0.75
                    }):Play();
                    v9:FireConnection("DisableSprinting", "404Error", true);
                    task.delay(1.2, function() --[[ Line: 567 ]]
                        -- upvalues: v5 (ref), v85 (copy), v9 (ref), l_v6_SpeedMultiplier_2 (copy), l_v6_FOVMultiplier_0 (copy), v6 (ref)
                        v5:Play(v85.Config.Sounds["404ErrorError"], {
                            Parent = v85.Rig.PrimaryPart, 
                            Volume = 0.4, 
                            TimePosition = 0.09, 
                            PlaybackSpeed = Random.new():NextNumber(0.9, 1.1)
                        });
                        v9:FireConnection("DisableSprinting", "404Error", false);
                        game.TweenService:Create(l_v6_SpeedMultiplier_2, TweenInfo.new(0.6), {
                            Value = 1
                        }):Play();
                        game.TweenService:Create(l_v6_FOVMultiplier_0, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                            Value = 1
                        }):Play();
                        game.Debris:AddItem(l_v6_SpeedMultiplier_2, 0.4);
                        game.Debris:AddItem(l_v6_FOVMultiplier_0, 1);
                        for _, v89 in pairs(workspace.Players.Survivors:GetChildren()) do
                            v6:RevealPlayerAura(v89, v85.Config["404ErrorAuraRevealTime"]);
                        end;
                    end);
                end;
                return;
            end;
        end
    }
};
v1.ErrorStart = function(_, _) --[[ Line: 591 ]] --[[ Name: ErrorStart ]]

end;
v1.CorruptEnergyStart = function(_, _) --[[ Line: 595 ]] --[[ Name: CorruptEnergyStart ]]

end;
v1.OnPuddleEpilepsy = function(_, _, _) --[[ Line: 599 ]] --[[ Name: OnPuddleEpilepsy ]]

end;
v1.OnStomp = function(_, _, v99, v100) --[[ Line: 603 ]] --[[ Name: OnStomp ]]
    for _, v102 in pairs(v99:GetDescendants()) do
        if v102:IsA("ParticleEmitter") and v102.Name:find("ShadowPuddle") then
            v102.Enabled = v102.Name == ("ShadowPuddle%*"):format(v100);
        end;
    end;
end;
v1.Created = function(v103, v104) --[[ Line: 611 ]] --[[ Name: Created ]]
    -- upvalues: v10 (copy), v6 (copy), v8 (copy), l_Players_0 (copy), v9 (copy), v5 (copy), l_TweenService_0 (copy), v16 (copy)
    v103.Connections = {};
    if game["Run Service"]:IsServer() then
        if workspace:GetAttribute("JohnDoeSpecialDay") then
            v10:IncrementAchievementProgress(v104.Player, "JohnDoeSpecialDay");
        end;
        local l_Folder_0 = Instance.new("Folder");
        l_Folder_0.Name = "JohnDoeTrail";
        l_Folder_0.Parent = v104.Rig;
        for _ = 1, math.clamp(math.round(v104.Config.TrailLength / 4), 2, 1e999) do
            local v107 = v104.Config.Trail:Clone();
            v107.Position = RigAlignment.TrailPoint(v104,true);
            v107.Parent = l_Folder_0;
            v107:SetAttribute("FinishedUpdating", true);
            v6:ApplyOnTouched(v107, false, function(_, v109) --[[ Line: 635 ]]
                -- upvalues: v8 (ref), v104 (copy)
                local l_Parent_1 = v109.Parent;
                local l_Humanoid_0 = l_Parent_1:FindFirstChild("Humanoid");
                if l_Humanoid_0 and l_Humanoid_0.Health > 0 and l_Parent_1:IsDescendantOf(workspace.Players) and tostring(l_Parent_1.Parent) ~= "Killers" then
                    v8:ApplyStatus(l_Parent_1, "Corrupted", {
                        Duration = 3, 
                        Level = 2, 
                        Killer = v104
                    });
                end;
            end);
        end;
        v104.CurrentSpikes = {};
        v104.FootprintRewardDebounce = {};
        local v112 = false;
        v104.Rig:GetAttributeChangedSignal("Stunned"):Connect(function() --[[ Line: 648 ]]
            -- upvalues: v104 (copy), v112 (ref)
            if v104.Rig:GetAttribute("Stunned") and v104.Config.StunDuration and v104.CurrentAbility and not v112 then
                v112 = true;
                local l_CurrentAbility_0 = v104.CurrentAbility;
                local v114 = v104.Config[l_CurrentAbility_0 .. "Cooldown"];
                if v114 then
                    v104:SetCooldownOf(l_CurrentAbility_0, (math.max(v114 * 0.5, 0)));
                end;
                task.delay(1, function() --[[ Line: 657 ]]
                    -- upvalues: v112 (ref)
                    v112 = false;
                end);
            end;
        end);
        local l_l_Folder_0_Children_0 = l_Folder_0:GetChildren();
        local v116 = 0;
        local v117 = 0;
        local v118 = 0;
        local v119 = nil;
        v119 = game["Run Service"].Heartbeat:Connect(function(v120) --[[ Line: 670 ]]
            -- upvalues: v104 (copy), l_Folder_0 (copy), v119 (ref), v118 (ref), l_Players_0 (ref), v8 (ref), v117 (ref), l_l_Folder_0_Children_0 (copy), v116 (ref)
            if not v104 or not v104.Rig.Parent or not v104.Rig.PrimaryPart then
                l_Folder_0:Destroy();
                v119:Disconnect();
                v119 = nil;
                return;
            else
                if v118 > 1 and #v104.CurrentSpikes > 0 then
                    v118 = 0;
                    local v121 = RaycastParams.new();
                    v121.FilterDescendantsInstances = v104.CurrentSpikes;
                    v121.FilterType = Enum.RaycastFilterType.Include;
                    for _, v123 in (l_Players_0:GetPlayers()) do
                        local l_Character_0 = v123.Character;
                        if l_Character_0 and l_Character_0.Parent then
                            if not l_Character_0 or not l_Character_0.Parent or l_Character_0.Parent.Name == "Killers" then

                            end;
                            local l_Humanoid_1 = l_Character_0:FindFirstChildOfClass("Humanoid");
                            if l_Humanoid_1 or l_Humanoid_1.Health <= 0 then
                                local l_PrimaryPart_0 = l_Character_0.PrimaryPart;
                                local v127 = workspace:Raycast(l_PrimaryPart_0.Position, Vector3.new(0, -5, 0, 0), v121);
                                local v128 = v127 and v127.Instance;
                                if v127 and v128 then
                                    local v129 = v128.Position.Y + v128.Size.Y / 2;
                                    local v130 = RaycastParams.new();
                                    v130.FilterDescendantsInstances = {
                                        l_Character_0, 
                                        v104.CurrentSpikes
                                    };
                                    v130.FilterType = Enum.RaycastFilterType.Exclude;
                                    local v131 = workspace:Raycast(l_PrimaryPart_0.Position, Vector3.new(0, -10, 0, 0), v130);
                                    if v131 then
                                        if v129 - v131.Position.Y >= 1.5 then
                                            v8:ApplyStatus(v123, "Corrupted", {
                                                Level = 2, 
                                                Duration = 5, 
                                                Killer = v104
                                            });
                                        end;
                                    else
                                        v8:ApplyStatus(v123, "Corrupted", {
                                            Level = 2, 
                                            Duration = 5, 
                                            Killer = v104
                                        });
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;
                v118 = v118 + v120;
                if v117 <= 0.05 then
                    v117 = v117 + v120;
                    return;
                else
                    v117 = 0;
                    local v132 = l_l_Folder_0_Children_0[v116 % #l_l_Folder_0_Children_0 + 1];
                    local v133 = l_l_Folder_0_Children_0[(v116 - 1) % #l_l_Folder_0_Children_0 + 1];
                    if v132 and v133 then
                        if v132.Size.Z <= 4 or v132:GetAttribute("FinishedUpdating") then
                            if v132:GetAttribute("FinishedUpdating") then
                                v132:SetAttribute("FinishedUpdating", nil);
                            end;
                            local v134 = RigAlignment.TrailPoint(v104,false);
                            local l_Position_3 = v133:GetPivot().Position;
                            local l_Rotation_0 = CFrame.lookAt(l_Position_3, v134).Rotation;
                            if l_Rotation_0 ~= l_Rotation_0 then
                                warn("currentTrailRotation is NaN, setting rotation to root rotation as fallback");
                                l_Rotation_0 = v104.Rig.PrimaryPart.CFrame.Rotation;
                            end;
                            v132.CFrame = CFrame.new(v133:GetPivot().Position) * l_Rotation_0 * CFrame.Angles(0, 0, 0);
                            v132.Size = Vector3.new(v132.Size.X, v132.Size.Y, (v132.Position - v134).Magnitude);
                            v132.PivotOffset = CFrame.new(0, 0, -v132.Size.Z / 2);
                            v132.CFrame = v132.CFrame * v132.PivotOffset;
                            return;
                        else
                            v132:SetAttribute("FinishedUpdating", true);
                            v116 = v116 + 1;
                            return;
                        end;
                    else
                        v116 = v116 + 1;
                        return;
                    end;
                end;
            end;
        end);
        return;
    else
        if game["Run Service"]:IsClient() then
            v104.ActiveSpikeModels = {};
            if game.Players.LocalPlayer==v104.Player and RigAlignment.IsUpdated(v104.Rig) then
                v104.JohnDoeRigCameraOffset=v6:CreateCameraOffset(v104.Rig,Vector3.new(0,.25,0),"JohnDoeDefault");
            end;
            v9:SetConnection(("%*JDPuddleEffect"):format(v104.Player.Name), "REMOTE_EVENT", function() --[[ Line: 776 ]]
                -- upvalues: v5 (ref), v104 (copy)
                v5:Play(v104.Config.Sounds.PuddleStepped);
            end);
            v9:SetConnection(("%*SpawnSpike"):format(v104.Player.Name), "REMOTE_EVENT", function(v137) --[[ Line: 780 ]]
                -- upvalues: v104 (copy), l_TweenService_0 (ref), v5 (ref)
                local v138 = v104.Config.Spike:Clone();
                local l_Y_0 = v104.Config.SpikeHitboxSize.Y;
                local v140 = Vector3.new(v137.Position.X, v137.Position.Y, v137.Position.Z);
                v138:PivotTo(CFrame.new(v140) * CFrame.Angles(3.141592653589793, math.rad(v137.Rotation), 0) - Vector3.new(0, l_Y_0, 0));
                v138.Parent = workspace.Map.Ingame;
                for _, v142 in (v138:GetDescendants()) do
                    if v142:IsA("BasePart") then
                        v142.CanCollide = false;
                        v142.CanQuery = false;
                        v142.CanTouch = false;
                    end;
                end;
                for _, v144 in (v138:GetDescendants()) do
                    if v144:IsA("ParticleEmitter") and v144.Name == "Number" then
                        v144.Color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0, v104.Config.SpikeNumbersColor), 
                            ColorSequenceKeypoint.new(1, v104.Config.SpikeNumbersColor)
                        });
                    end;
                end;
                l_TweenService_0:Create(v138.PrimaryPart, TweenInfo.new(0.1), {
                    CFrame = v138.PrimaryPart.CFrame + Vector3.new(0, l_Y_0, 0)
                }):Play();
                task.delay(v104.Config.SpikeLifetime, function() --[[ Line: 815 ]]
                    -- upvalues: v138 (copy)
                    if v138.Parent and v138.PrimaryPart then
                        game.Debris:AddItem(v138, 1.5);
                    end;
                end);
                v5:Play(v104.Config.Sounds.CorruptEnergySummon, {
                    Parent = v138.PrimaryPart, 
                    PlaybackSpeed = Random.new():NextNumber(0.8, 1.2), 
                    Volume = 0.25, 
                    TimePosition = 0.02
                });
                v104.ActiveSpikeModels[v137.SpikeUUID] = v138;
            end);
            v9:SetConnection(("%*DesummonSpike"):format(v104.Player.Name), "REMOTE_EVENT", function(v145) --[[ Line: 825 ]]
                -- upvalues: v104 (copy), l_TweenService_0 (ref), v5 (ref)
                local v146 = v104.ActiveSpikeModels[v145];
                if not v146 then
                    return;
                else
                    local l_Y_1 = v104.Config.SpikeHitboxSize.Y;
                    l_TweenService_0:Create(v146.PrimaryPart, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                        CFrame = v146.PrimaryPart.CFrame - Vector3.new(0, l_Y_1 * 2, 0)
                    }):Play();
                    v5:Play(v104.Config.Sounds.CorruptEnergyDesummon, {
                        Parent = v146.PrimaryPart, 
                        PlaybackSpeed = Random.new():NextNumber(0.9, 1.1), 
                        Volume = 0.1, 
                        TimePosition = 0.02
                    });
                    game.Debris:AddItem(v146, 1);
                    v104.ActiveSpikeModels[v145] = nil;
                    return;
                end;
            end);
            v9:SetConnection(("%*OnPuddleRevealed"):format(v104.Player.Name), "REMOTE_EVENT", function(v148) --[[ Line: 848 ]]
                -- upvalues: v16 (ref), v104 (copy)
                local l_PlayerSettings_0 = require(game.ReplicatedStorage.Initializer).PlayerSettings;
                if l_PlayerSettings_0.EpilepsyMode and l_PlayerSettings_0.EpilepsyMode.Value then
                    for _, v151 in (v148:GetDescendants()) do
                        if v151:IsA("ParticleEmitter") and v151:GetAttribute("IsEpilepsy") then
                            v151.Enabled = false;
                        end;
                    end;
                    v16("OnPuddleEpilepsy", ("%*/OnPuddleEpilepsy"):format(script.Parent), v104, v148);
                end;
            end);
            if game.Players.LocalPlayer == v104.Player then
                local v152 = v104.Config.SilencedTag or "JaneDoeSilenced";
                v104.Silencers = {};
                local function v156(v153) --[[ Line: 874 ]] --[[ Name: myWife ]]
                    -- upvalues: v104 (copy)
                    local v154 = v153:WaitForChild("Head", 4);
                    if not v154 or not v104 or not v104.SilencedConnection then
                        return;
                    else
                        local v155 = v104.Config.SilencedTemplate:Clone();
                        v155.Parent = v153;
                        v155.Weld.Part0 = v154;
                        table.insert(v104.Silencers, v155);
                        return;
                    end;
                end;
                v104.SilencedConnection = game.CollectionService:GetInstanceAddedSignal(v152):Connect(v156);
                for _, v158 in ipairs(workspace.Players.Survivors:GetChildren()) do
                    if v158:HasTag(v152) then
                        task.spawn(v156, v158);
                    end;
                end;
            end;
        end;
        return;
    end;
end;
v1.Destroyed = function(v159, v160) --[[ Line: 897 ]] --[[ Name: Destroyed ]]
    if v160.JohnDoeRigCameraOffset then v160.JohnDoeRigCameraOffset:Destroy();v160.JohnDoeRigCameraOffset=nil end;
    -- upvalues: v9 (copy)
    for _, v162 in v159.Connections do
        v162:Disconnect();
        v162 = nil;
    end;
    if game["Run Service"]:IsServer() then
        for _, v164 in v160.CurrentSpikes do
            v164:Destroy();
        end;
        return;
    else
        if game["Run Service"]:IsClient() then
            v9:RemoveConnection(("%*JDPuddleEffect"):format(v160.Player.Name), "REMOTE_EVENT");
            v9:RemoveConnection(("%*SpawnSpike"):format(v160.Player.Name), "REMOTE_EVENT");
            v9:RemoveConnection(("%*DesummonSpike"):format(v160.Player.Name), "REMOTE_EVENT");
            if v160.SilencedConnection then
                v160.SilencedConnection:Disconnect();
                local l_ipairs_0 = ipairs;
                local v166 = v160.Silencers or {};
                for _, v168 in l_ipairs_0(v166) do
                    v168:Destroy();
                end;
            end;
        end;
        return;
    end;
end;
v1.OnIntroduction = function(_, v170, v171, v172) --[[ Line: 923 ]] --[[ Name: OnIntroduction ]]
    -- upvalues: v6 (copy)
    local v173 = nil;
    if v170.Config.useClouds == true then
        v173 = Instance.new("Clouds");
        v173.Cover = 0.774;
        v173.Density = 1;
        v173.Color = Color3.fromRGB(25, 25, 25);
        v173.Parent = workspace:FindFirstChild("Terrain");
        game.Debris:AddItem(v173, v172);
    end;
    local v174 = script.IntroScreen:Clone();
    v174.Main.Title.Text = v170.Config.IntroText:gsub("PLAYERNAME", v170.Player.DisplayName);
    v174.Parent = game.Players.LocalPlayer.PlayerGui;
    game.Debris:AddItem(v174, 1.93333);
    game.TweenService:Create(v174.Main.Title, TweenInfo.new(0.83), {
        TextTransparency = 0
    }):Play();
    task.delay(0.83, function() --[[ Line: 948 ]]
        -- upvalues: v174 (copy), v170 (copy)
        game.TweenService:Create(v174.Main.Title, TweenInfo.new(0.583), {
            TextColor3 = v170.Config.IntroTextColor or Color3.new(1, 0, 0)
        }):Play();
    end);
    task.delay(1, function() --[[ Line: 953 ]]
        -- upvalues: v171 (copy)
        local l_JohnDoeTrail_0 = v171:FindFirstChild("JohnDoeTrail");
        if l_JohnDoeTrail_0 then
            l_JohnDoeTrail_0:Destroy();
        end;
    end);
    local v176 = require(game.ReplicatedStorage.Modules.Schematics.Lighting);
    v176:SetCustomLighting(v170.Config.IntroLighting);
    task.delay(2.717, function() --[[ Line: 963 ]]
        -- upvalues: v173 (ref), v170 (copy)
        if v173 then
            v173.Color = Color3.fromRGB(25, 0, 0);
        end;
        local l_AtmosphereDoe_0 = game.Lighting:FindFirstChild("AtmosphereDoe");
        if l_AtmosphereDoe_0 then
            game.TweenService:Create(l_AtmosphereDoe_0, TweenInfo.new(0.2829, Enum.EasingStyle.Linear), {
                Color = v170.Config.AtmosphereColor or Color3.fromRGB(144, 0, 0), 
                Decay = v170.Config.AtmosphereDecay or Color3.fromRGB(255, 0, 0), 
                Density = 1
            }):Play();
        end;
    end);
    local l_v6_FOVMultiplier_1 = v6:CreateFOVMultiplier(game.Players.LocalPlayer, 0.35, "JohnDoeIntroScene");
    task.delay(2.75, function() --[[ Line: 979 ]]
        -- upvalues: l_v6_FOVMultiplier_1 (copy)
        game.TweenService:Create(l_v6_FOVMultiplier_1, TweenInfo.new(0.25), {
            Value = 0.95
        }):Play();
    end);
    task.delay(v172, function() --[[ Line: 984 ]]
        -- upvalues: v176 (copy), l_v6_FOVMultiplier_1 (copy), v174 (copy), v173 (ref)
        v176:SetAsCurrentLighting();
        l_v6_FOVMultiplier_1:Destroy();
        v174:Destroy();
        if v173 then
            v173:Destroy();
        end;
    end);
end;
v1.OnVictory = function(_, v180, v181, _, _) --[[ Line: 994 ]] --[[ Name: OnVictory ]]
    -- upvalues: v6 (copy), l_TweenService_0 (copy)
    local v184 = require(game.ReplicatedStorage.Modules.Schematics.Lighting);
    if v180 == "Start" then
        v184:SetCustomLighting(v181.Config.IntroLighting);
        local l_v6_FOVMultiplier_2 = v6:CreateFOVMultiplier(game.Players.LocalPlayer, 1.1325, "JohnDoeOutroScene");
        game.Debris:AddItem(l_v6_FOVMultiplier_2, 30);
        task.spawn(function() --[[ Line: 1005 ]]
            -- upvalues: v181 (copy), v6 (ref)
            local v186 = os.clock();
            local v187 = workspace.Misc:WaitForChild("KillerCutsceneBackground", 5);
            if v187 and v187.PrimaryPart then
                local v188 = v181.Config.OutroDummy:Clone();
                v188.Name = "OutroVictim";
                v188.PrimaryPart.Anchored = true;
                v188:SetPrimaryPartCFrame(v187.PrimaryPart.CFrame);
                v188.Parent = v187;
                local v189 = v6:LoadAnimationFromID(v188, "rbxassetid://135006397147596", true);
                v189:Play(0);
                v189.TimePosition = os.clock() - v186;
                v189.Stopped:Once(function() --[[ Line: 1020 ]]
                    -- upvalues: v188 (copy)
                    for _, v191 in ipairs(v188:GetDescendants()) do
                        if v191:IsA("BasePart") then
                            v191.Anchored = true;
                        end;
                    end;
                end);
                local v192 = false;
                for _, v194 in ipairs({
                    "Shirt", 
                    "Pants", 
                    "Accessory", 
                    "Hat"
                }) do
                    if v188:FindFirstChildOfClass(v194) then
                        v192 = true;
                        break;
                    end;
                end;
                if not v192 then
                    pcall(function() --[[ Line: 1033 ]]
                        -- upvalues: v181 (ref), v188 (copy)
                        local l_HumanoidDescriptionFromUserId_0 = game.Players:GetHumanoidDescriptionFromUserId(v181.Player.UserId);
                        v188.Humanoid:ApplyDescription(l_HumanoidDescriptionFromUserId_0, Enum.AssetTypeVerification.Always);
                    end);
                end;
            end;
        end);
        task.delay(2.4, function() --[[ Line: 1042 ]]
            -- upvalues: l_TweenService_0 (ref), v181 (copy)
            local v196 = Instance.new("ColorCorrectionEffect", game.Lighting);
            v196.Name = "JohnDoeStabCC";
            local v197 = l_TweenService_0:Create(v196, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
                Contrast = 0.4, 
                Brightness = 0.1
            });
            v197:Play();
            task.wait(0.4);
            v197:Pause();
            v196.Brightness = 0.8;
            v196.Contrast = 0.3;
            v196.TintColor = v181.Config.OutroTintColor or Color3.new(0.631373, 0.0784314, 0.0901961);
            l_TweenService_0:Create(v196, TweenInfo.new(2.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
                TintColor = Color3.new(0.196078, 0.196078, 0.196078), 
                Brightness = -1, 
                Contrast = -0.5, 
                Saturation = -1
            }):Play();
        end);
        return;
    else
        if v180 == "End" then
            v184:SetAsCurrentLighting();
            local l_v6_FOVMultiplier_3 = v6:CreateFOVMultiplier(game.Players.LocalPlayer, 1, "JohnDoeOutroScene");
            game.Debris:AddItem(l_v6_FOVMultiplier_3, 1);
            local v199 = game.Lighting:WaitForChild("JohnDoeStabCC", 8);
            if v199 then
                v199:Destroy();
            end;
        end;
        return;
    end;
end;
v1.OnExecution = function(_, v201, v202) --[[ Line: 1106 ]] --[[ Name: OnExecution ]]
    local l_Humanoid_2 = v202:FindFirstChild("Humanoid");
    local v204 = require(game.ReplicatedStorage.Modules.Ragdolls);
    local v205 = (v201.Rig.PrimaryPart.CFrame.LookVector + Vector3.new(0, 0.5, 0, 0)) * 40;
    local l_Axe_0 = v202:FindFirstChild("Axe");
    local l_BackAxe_0 = v202:FindFirstChild("BackAxe");
    if v202.Name == "JaneDoe" then
        l_Axe_0.Transparency = 0;
        l_BackAxe_0.Transparency = 1;
        task.delay(2.85, function() --[[ Line: 1118 ]]
            -- upvalues: v204 (copy), v202 (copy), v205 (copy), l_Humanoid_2 (copy)
            v204.AddProfile(v202, {
                Velocity = v205, 
                KillEffects = {
                    Explode = true
                }
            });
            if l_Humanoid_2 then
                l_Humanoid_2.BreakJointsOnDeath = true;
                l_Humanoid_2.Health = 0;
            end;
        end);
        return;
    else
        task.delay(0.666, function() --[[ Line: 1128 ]]
            -- upvalues: v204 (copy), v202 (copy), v205 (copy)
            v204.AddProfile(v202, {
                AnchorDelay = true, 
                Applied = os.clock() + 5, 
                Velocity = v205
            });
            local l_Humanoid_3 = v202:FindFirstChild("Humanoid");
            if l_Humanoid_3 then
                l_Humanoid_3.BreakJointsOnDeath = false;
                l_Humanoid_3.Health = 0;
            end;
        end);
        task.delay(1.98, function() --[[ Line: 1137 ]]
            -- upvalues: v202 (copy)
            if v202 and v202.PrimaryPart then
                v202.PrimaryPart.Anchored = false;
            end;
        end);
        return;
    end;
end;
local previousCreated=v1.Created
local previousDestroyed=v1.Destroyed
v1.Created=function(self,actor)
 previousCreated(self,actor)
 CorruptEnergyController.Created(actor)
end
v1.Destroyed=function(self,actor)
 CorruptEnergyController.Destroyed(actor)
 previousDestroyed(self,actor)
end
return v1;]========],before="57265:20e75274:1ab5aa69",after="44616:b00279cd:a86d6fe0"},
{path=[========[
ReplicatedStorage/Assets/Killers/JohnDoe/Behavior/CorruptEnergyController]========],source=[========[
return require(game:GetService("RunService"):IsServer() and script.Server or script.Client)
]========],before=false,after="92:f405154b:700565ec"},
{path=[========[
ReplicatedStorage/Assets/Killers/JohnDoe/Behavior/CorruptEnergyController/Client]========],source=[========[
local RunService=game:GetService("RunService")
local Players=game:GetService("Players")
local Util=require(game.ReplicatedStorage.Modules.Util)
local Client={}
function Client.CanRetract(a) return a.Rig and a.Rig:GetAttribute("JDCanRetract")==true end
local function update(a)
 local ability=a.Behavior.Abilities.CorruptEnergy
 local retract=Client.CanRetract(a)
 ability.Name=retract and "Retract" or "Corrupt Energy"
 ability.Icon=retract and "rbxassetid://105853980040304" or "rbxassetid://83849304758564"
 -- FCT keeps counting the original cooldown; only its rendering is suppressed while Retract is available.
 ability.Disabled=retract or a.JDCEOriginalDisabled
 local main=a.Player:FindFirstChildOfClass("PlayerGui")
 main=main and main:FindFirstChild("MainUI")
 local hotbar=main and main:FindFirstChild("AbilityContainer")
 local button=hotbar and hotbar:FindFirstChild("CorruptEnergy")
 if retract and button then
  button.Image=ability.Icon
  if button:FindFirstChild("AbilityName") then button.AbilityName.Text=ability.Name end
  if button:FindFirstChild("CooldownTime") then button.CooldownTime.Text="" end
  if button:FindFirstChild("Clipping") then
   button.Clipping.Size=UDim2.fromScale(1,1)
   button.Clipping.Top.Size=UDim2.fromScale(1,1);button.Clipping.Top.Image=ability.Icon
  end
 end
end
local function windup(a)
 local state=a.JDCEClientWindup
 if not state then return end
 local times={1.067,1.917}
 while state.next<=#times and os.clock()-state.started>=times[state.next] do
  local stage=state.next;state.next+=1
  pcall(Util.ApplyCameraShake,Util,stage*.2,stage*.35)
 end
 if state.next>#times then a.JDCEClientWindup=nil end
end
function Client.Play(a,data)
 if data and data.Retract then return end
 a.JDCEClientWindup={started=os.clock(),next=1}
 local animation=a.Animations and a.Animations.CorruptEnergy
 if animation then pcall(function()animation:Play(.025)end) end
end
function Client.Created(a)
 if a.Player~=Players.LocalPlayer then return end
 a.JDCEClientConnections={};a.JDCEOriginalDisabled=a.Behavior.Abilities.CorruptEnergy.Disabled
  a.JDCEClientConnections[1]=a.Rig:GetAttributeChangedSignal("JDCanRetract"):Connect(function()update(a)end)
 a.JDCEClientConnections[2]=RunService.RenderStepped:Connect(function()update(a);windup(a)end)
 a.JDCEClientConnections[3]=a.Rig:GetAttributeChangedSignal("Stunned"):Connect(function()
  if a.Rig:GetAttribute("Stunned") then
   a.JDCEClientWindup=nil
   local track=a.Animations and a.Animations.CorruptEnergy
   if track then pcall(function()track:Stop(.05)end) end
  end
 end)
 update(a)
end
function Client.Destroyed(a)
 a.JDCEClientWindup=nil
 for _,model in pairs(a.ActiveSpikeModels or {}) do model:Destroy() end
 a.ActiveSpikeModels={}
 for _,connection in ipairs(a.JDCEClientConnections or {}) do connection:Disconnect() end
 a.JDCEClientConnections={}
 if a.Behavior and a.Behavior.Abilities and a.Behavior.Abilities.CorruptEnergy then
  local ability=a.Behavior.Abilities.CorruptEnergy;ability.Disabled=a.JDCEOriginalDisabled;ability.Name="Corrupt Energy";ability.Icon="rbxassetid://83849304758564"
 end
end
return Client
]========],before=false,after="3121:bbcdd708:c2fc4305"},
{path=[========[
ReplicatedStorage/Assets/Killers/JohnDoe/Behavior/CorruptEnergyController/Rules]========],source=[========[
local Rules={}
function Rules.ReserveHit(cast,target,cap)
 if not cast.active then return false end
 local hits=cast.hits[target] or 0
 if hits>=cap then return false end
 cast.hits[target]=hits+1
 return true
end
function Rules.SpawnAt(index,interval) return 2+index*interval end
return Rules
]========],before=false,after="294:470d2a86:a17a5ae1"},
{path=[========[
ReplicatedStorage/Assets/Killers/JohnDoe/Behavior/CorruptEnergyController/Server]========],source=[========[
local RunService=game:GetService("RunService")
local TweenService=game:GetService("TweenService")
local Debris=game:GetService("Debris")
local Modules=game.ReplicatedStorage.Modules
local Hitboxes=require(Modules.Hitboxes)
local Network=require(Modules.Network)
local Util=require(Modules.Util)
local Sounds=require(Modules.Sounds)
local Statuses=require(Modules.Statuses)
local Actors=require(Modules.Actors)
local Rules=require(script.Parent.Rules)
local Server={}
local function alive(a)
 local hum=a.Rig and a.Rig:FindFirstChildOfClass("Humanoid")
 return not a.JDCEDestroyed and a.Rig and a.Rig.Parent and a.Rig.PrimaryPart and hum and hum.Health>0
end
local function blocked(a)
 local r=a.Rig
 return r:GetAttribute("Stunned") or r:GetAttribute("Helpless") or r:GetAttribute("Ragdolling") or r:GetAttribute("AbilitiesDisabled") or r.PrimaryPart.Anchored
end
local function broadcast(a,kind,data)
 Network:FireAllClientConnection(a.Player.Name..kind,"REMOTE_EVENT",data)
end
local function sound(a,name,parent)
 local id=a.Config.Sounds and a.Config.Sounds[name]
 if id and parent then pcall(Sounds.Play,Sounds,id,{Parent=parent,Volume=.4}) end
end
function Server.CanRetract(a)
 local c=a.JDCECast
 return c and c.active and not c.casting and c.live>0 or false
end
local function refresh(a)
 if a.Rig and a.Rig.Parent then a.Rig:SetAttribute("JDCanRetract",Server.CanRetract(a)) end
end
local function release(a,c)
 if not c.casting then return end
 c.casting=false
 if c.slow then c.slow:Destroy();c.slow=nil end
 a.AbilityDisablers.JohnCorruptEnergy=nil
 if a.CurrentAbility=="CorruptEnergy" then a.CurrentAbility=nil;a.Config.StunDuration=c.previousStunDuration end
 refresh(a)
end
local function removeSpike(a,c,s,immediate)
 if not s.live then return end
 s.live=false;c.live-=1
 if s.hitbox and s.hitbox.Cancel then s.hitbox:Cancel() end
 if s.rise then s.rise:Cancel() end
 local index=table.find(a.CurrentSpikes,s.part)
 if index then table.remove(a.CurrentSpikes,index) end
 broadcast(a,"DesummonSpike",s.id)
 if s.part.Parent then
  s.part.CanCollide=false;s.part.CanTouch=false
  if immediate then s.part:Destroy()
  else
   TweenService:Create(s.part,TweenInfo.new(1,Enum.EasingStyle.Quad,Enum.EasingDirection.In),{CFrame=s.part.CFrame-Vector3.new(0,a.Config.SpikeHitboxSize.Y*2,0)}):Play()
   Debris:AddItem(s.part,1.05)
  end
 end
 refresh(a)
end
local function clear(a,immediate)
 local c=a.JDCECast
 if not c then return end
 c.active=false;release(a,c)
 for _,s in ipairs(c.spikes) do removeSpike(a,c,s,immediate) end
 a.JDCECast=nil;refresh(a)
end
local function reward(a,target)
 local hum=target:FindFirstChildOfClass("Humanoid")
 if not hum then return end
 if hum.Health>0 then
  Util:CreateSpeedMultiplier(target,1.5,"HitSpeedBonus",1.25)
  Statuses:ApplyStatus(a.Rig,"Speed",{Level=1,Duration=7})
  Util:RevealPlayerAuraTo(a.Player,target,2.5)
 end
 if target.Parent and target.Parent.Name=="Survivors" then
  Actors:IncrementActorStats(a.Player,{Action=hum.Health<=0 and "Killed a Survivor with Corrupt Energy" or "Damaged a Survivor with Corrupt Energy",RewardType=hum.Health<=0 and "DifficultKillerAction" or "EasyKillerAction"})
 end
 if hum.Health<=0 then
  local achievement=require(Modules.AchievementUtil)
  achievement:IncrementAchievementProgress(a.Player,"JohnDoeSpikes")
 end
end
local function spawnSpike(a,c,index,now)
 if not c.active or c.interrupted or not alive(a) then return end
 local params=RaycastParams.new();params.FilterType=Enum.RaycastFilterType.Exclude;params.FilterDescendantsInstances={workspace.Players}
 local point=(a:GetPivot()*CFrame.new(0,0,-a.Config.DistanceBetweenSpikes*index)).Position
 local hit=workspace:Raycast(point,Vector3.new(0,-100,0),params) or workspace:Raycast(point,Vector3.new(0,100,0),params)
 if not hit then return end
 local size=a.Config.SpikeHitboxSize
 local rotation=math.random(0,360)
 local data={Position=hit.Position,Rotation=rotation,SpikeUUID=tostring(c.serial)..":"..index}
 local part=Instance.new("Part");part.Name="SpikeCollision";part.Size=size;part.Transparency=1
 part.Anchored=true;part.CanTouch=false;part.CanCollide=true;part.CustomPhysicalProperties=a.Config.SpikeProperties
 local from=CFrame.new(hit.Position)*CFrame.Angles(0,math.rad(rotation),math.pi/2)-Vector3.new(0,size.Y,0)
 part.CFrame=from;part.Parent=workspace.Map.Ingame
 local s={part=part,id=data.SpikeUUID,live=true,expires=now+a.Config.SpikeLifetime}
 table.insert(c.spikes,s);table.insert(a.CurrentSpikes,part);c.live+=1
 s.rise=TweenService:Create(part,TweenInfo.new(.1,Enum.EasingStyle.Linear),{CFrame=from+Vector3.new(0,size.Y*2,0)})
 s.rise:Play();broadcast(a,"SpawnSpike",data)
 s.hitbox=Hitboxes:CreateHitbox(a.Player,{
  AbilityType="CorruptEnergy",IsProjectile=false,Size=size,CFrame=function()return part.CFrame end,
  Damage=a.Config.CorruptEnergyDamage,Time=.15,Knockback=5,HitMultiple=true,PredictVelocity=false,CastPoint=false,
  -- Reject before damage, block reactions, knockback, or hit callbacks. Reservation is atomic across spikes.
  HitFilter=function(target)
   return s.live and alive(a) and Rules.ReserveHit(c,target,a.Config.SpikeHitCap)
  end,
  Connections={Hit=function(target,first)
   reward(a,target)
   if first then sound(a,"Hit",a.Rig.PrimaryPart) end
  end}
 })
 refresh(a)
end
local function step(a)
 if not alive(a) then Server.Destroyed(a);return end
 local c=a.JDCECast
 if not c then return end
 local now=os.clock()
 if c.casting then
  if blocked(a) then c.interrupted=true;release(a,c)
  else
   while c.next<=a.Config.SpikeAmount and now-c.started>=Rules.SpawnAt(c.next,a.Config.DelayBetweenSpikeSummons) do
    local index=c.next;c.next+=1;spawnSpike(a,c,index,now)
   end
   if now-c.started>=math.max(3.5,Rules.SpawnAt(a.Config.SpikeAmount,a.Config.DelayBetweenSpikeSummons)+.1) then release(a,c) end
  end
 end
 for _,s in ipairs(c.spikes) do if s.live and (not s.part.Parent or now>=s.expires) then removeSpike(a,c,s,not s.part.Parent) end end
 if not c.casting and c.live==0 then c.active=false;a.JDCECast=nil;refresh(a) end
end
function Server.Cast(a)
 if not alive(a) or blocked(a) then return {Cancelled=true} end
 if Server.CanRetract(a) then clear(a,false);return {Retract=true} end
 if a.JDCECast and a.JDCECast.casting then return {Cancelled=true} end
 clear(a,true)
 a.JDCESerial=(a.JDCESerial or 0)+1
 local c={serial=a.JDCESerial,active=true,casting=true,started=os.clock(),next=1,live=0,spikes={},hits={},previousStunDuration=a.Config.StunDuration}
 a.JDCECast=c;a.AbilityDisablers=a.AbilityDisablers or {};a.AbilityDisablers.JohnCorruptEnergy=true
 a.CurrentAbility="CorruptEnergy";a.Config.StunDuration=a.Config.UnstoppableDuration
 c.slow=Util:CreateSpeedMultiplier(a.Player,.001,"JohnCorruptEnergyCast")
 sound(a,"CorruptEnergy",a.Rig.PrimaryPart);refresh(a)
 return {Retract=false}
end
function Server.Created(a)
 a.JDCEDestroyed=false;a.JDCEConnections={};a.CurrentSpikes=a.CurrentSpikes or {}
 local original=a.CanUseAbility;a.JDCEOriginalCanUse=original
 local function canUse(self,name)
  if name~="CorruptEnergy" or not Server.CanRetract(a) then return original(self,name) end
  -- Keep every ordinary lock/check; bypass only this actor's existing CE cooldown for Retract.
  local cooldown=a.Cooldowns.CorruptEnergy;a.Cooldowns.CorruptEnergy=nil
  local ok,result=pcall(original,self,name)
  a.Cooldowns.CorruptEnergy=cooldown
  if not ok then error(result) end
  return result
 end
 a.CanUseAbility=canUse;a.JDCECanUseWrapper=canUse
 table.insert(a.JDCEConnections,RunService.Heartbeat:Connect(function()step(a)end))
 table.insert(a.JDCEConnections,a.Rig:GetAttributeChangedSignal("Stunned"):Connect(function()
  if a.Rig:GetAttribute("Stunned") and a.JDCECast and a.JDCECast.casting then a.JDCECast.interrupted=true;release(a,a.JDCECast) end
 end))
 table.insert(a.JDCEConnections,a.Rig:FindFirstChildOfClass("Humanoid").Died:Connect(function()Server.Destroyed(a)end))
 refresh(a)
end
function Server.Destroyed(a)
 if a.JDCEDestroyed then return end
 a.JDCEDestroyed=true;clear(a,true)
 for _,connection in ipairs(a.JDCEConnections or {}) do connection:Disconnect() end
 a.JDCEConnections={}
 if a.CanUseAbility==a.JDCECanUseWrapper then a.CanUseAbility=a.JDCEOriginalCanUse end
end
return Server
]========],before=false,after="8245:ae90ee42:a8b0ecab"},
{path=[========[
ReplicatedStorage/Assets/Killers/JohnDoe/Config]========],source=[========[
-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local l_workspace_Attribute_0 = workspace:GetAttribute("JohnDoeSpecialDay");
local v1 = {
    DisplayName = "John Doe", 
    Quote = l_workspace_Attribute_0 and "dude i told you not to play on march 18th" or "DON'T PLAY ROBLOX ON MARCH 18TH?!?!", 
	RenderImage = l_workspace_Attribute_0 and "rbxassetid://125927083463034" or "rbxassetid://115998690833101", 
    Price = l_workspace_Attribute_0 and 318 or 1000, 
    Health = l_workspace_Attribute_0 and 3182026 or 1500, 
    Speed = l_workspace_Attribute_0 and 11.3182026 or 9, 
    IntroText = "They're all yours, Mr. Doe", 
    SprintSpeed = l_workspace_Attribute_0 and 27.53182026 or 27.25, 
    StaminaLoss = 9.5, 
    StaminaGain = 21, 
    MaxStamina = l_workspace_Attribute_0 and 115.3182026 or 110, 
    SlashDamage = l_workspace_Attribute_0 and 45.3182026 or 28, 
    SlashCooldown = l_workspace_Attribute_0 and 2.3182026 or 1.75, 
    SlashWindup = 0.4, 
    SlashLinger = 0.25, 
    CorruptEnergyDamage = l_workspace_Attribute_0 and 16.3182026 or 11, 
    CorruptEnergyCooldown = l_workspace_Attribute_0 and 40.3182026 or 18, 
    SpikeAmount = l_workspace_Attribute_0 and 256 or 31, 
    SpikeHitboxSize = Vector3.new(11, 5, 5, 0), 
    SpikeLifetime = l_workspace_Attribute_0 and 18.3182026 or 14, 
    SpikeHitCap = l_workspace_Attribute_0 and 3182026 or 2, 
    SpikeProperties = PhysicalProperties.new(0.2, 2, 0, 100, 100), 
    DelayBetweenSpikeSummons = l_workspace_Attribute_0 and 0.02 or 0.045, 
    DistanceBetweenSpikes = 4, 
    DigitalFootprintCooldown = 3, 
    DigitalFootprintLimit = l_workspace_Attribute_0 and 4 or 3, 
    ["404ErrorAuraRevealTime"] = l_workspace_Attribute_0 and 10.3182026 or 6, 
    ["404ErrorCooldown"] = 20, 
    Spike = script.Spike, 
    Shadow = script.Shadow, 
    Trail = script.Trail, 
    SpikeNumbersColor = Color3.fromRGB(255, 0, 0), 
    TrailLength = l_workspace_Attribute_0 and 356 or 48, 
    UnstoppableDuration = 2, 
    SilencedTemplate = script.NAN, 
    Silenced = true, 
    OutroDummy = script.OutroVictim, 
    useClouds = true, 
    Relations = {
        "JaneDoe"
    }, 
    LastManStandingEmotionalData = {
        ThemeID = "rbxassetid://90004798416076", 
        RoundTime = 99
    }, 
    LastManStandingData = {
        ThemeID = "rbxassetid://128206924329556", 
        ThemeProperties = {
            Volume = 1.8
        }, 
        RoundTime = 75
    }, 
    Animations = {
        Idle = "rbxassetid://78316360457839", 
        Walk = "rbxassetid://76406790148345", 
        Run = "rbxassetid://75860288793447", 
        InjuredIdle = "rbxassetid://78316360457839", 
        InjuredWalk = "rbxassetid://76406790148345", 
        InjuredRun = "rbxassetid://75860288793447", 
        Stunned = {
            Start = "rbxassetid://138679230786776", 
            Loop = "rbxassetid://70827891324537", 
            End = "rbxassetid://74361242843808", 
            Cancel = "rbxassetid://132248641730444"
        }, 
        Execution = {
            KillerRig = "rbxassetid://83976183793168", 
            PlayerRig = "rbxassetid://128883910284038", 
            PlayerCFrameOffset = CFrame.Angles(0, 3.141592653589793, 0) * CFrame.new(0, 0, 3)
        }, 
        ExecutionJaneDoe = {
            KillerRig = "rbxassetid://113867319138589", 
            PlayerRig = "rbxassetid://110119432571584"
        }, 
        Slash = "rbxassetid://115517017692371", 
        CorruptEnergy = "rbxassetid://98447162219573", 
        DigitalFootprint = "rbxassetid://105781326773024", 
        Introduction = {
            KillerRig = "rbxassetid://119476049603730", 
            CameraRig = "rbxassetid://140634358360682"
        }, 
        Victory = {
            KillerRig = "rbxassetid://103715079223416", 
            CameraRig = "rbxassetid://98794271647444"
        }
    }, 
    Sounds = {
        Ambience = "rbxassetid://94207556272752", 
        Footsteps = {
            "rbxassetid://126872882914955", 
            "rbxassetid://81544212102472"
        }, 
        TerrorRadiusThemes = {
            [60] = {
                ID = "rbxassetid://83774227185202", 
                BPM = 100
            }, 
            [40] = {
                ID = "rbxassetid://112183456126257", 
                BPM = 100
            }, 
            [20] = {
                ID = "rbxassetid://110494241693405", 
                BPM = 100
            }, 
            [6] = {
                ID = "rbxassetid://90755511989120", 
                BPM = 100, 
                Chase = true
            }
        }, 
        Execution = "rbxassetid://91088178573563", 
        ExecutionJaneDoe = "rbxassetid://91273852978167", 
        StunEnded = "rbxassetid://127453218558340", 
        Swing = "rbxassetid://140242176732868", 
        Hit = "rbxassetid://90819435118493", 
        CorruptEnergy = "rbxassetid://122388551068717", 
        CorruptEnergySummon = "rbxassetid://111388466508150", 
        CorruptEnergyDesummon = "rbxassetid://84267936481619", 
        PuddleStepped = "rbxassetid://128240826870706", 
        DigitalFootprint = "rbxassetid://114243439622992", 
        DigitalFootprintAmbience = "rbxassetid://140163779889034", 
        ["404Error"] = "rbxassetid://117888888155052", 
        ["404ErrorError"] = "rbxassetid://113305896012849", 
        Introduction = "rbxassetid://72636140548768", 
        VictoryTheme = "rbxassetid://122795850954647"
    }
};
v1.Information = {
    {
        Separator = "GENERAL INFO"
    }, 
    {
        Header = "JOHN DOE", 
        Text = "The defunct code of the early days of Roblox courses through their body, consuming his mind as he now only focuses on one thing: to kill everyone in his path. An unstoppable force entering the round with a strategical mindset, he's able to set traps, summon walls to back survivors into a corner, and leave behind a faint trail that damages those who step on it.\n"
    }, 
    {
        Header = "STATS", 
        Text = "Difficulty: \226\152\133\226\152\133\226\152\133\226\152\133\226\152\133\n" .. ("Health: %*\n"):format(v1.Health) .. ("Regular Speed: %*\n"):format(v1.Speed) .. ("Sprinting Speed: %*\n"):format(v1.SprintSpeed) .. ("Max Stamina: %*\n"):format(v1.MaxStamina) .. ("Stamina Loss per sec: %*\n"):format(v1.StaminaLoss) .. ("Stamina Gain per sec: %*\n"):format(v1.StaminaGain) .. "Terror Radius: 60 studs\n"
    }, 
    {
        Separator = "PASSIVES"
    }, 
    {
        Header = "NATURAL MALEVOLENCE", 
        Quote = "\"We\226\128\153re dedicated to building a fun, safe environment where kids of all ages can power their imagination on Roblox.\" - Roblox", 
        Text = "For every step that <font color=\"rgb(248,217,109)\">John Doe</font> takes, a trail of corruption follows behind him.\nAny survivor that's unfortunate enough to step within the corruption is given <b>Corrupted II</b> for 3 seconds.\n"
    }, 
    {
        Header = "UNSTOPPABLE", 
        Quote = "\"Consider this myth busted.\" - Roblox", 
        Text = ("<font color=\"rgb(248,217,109)\">John Doe</font> can only be stunned for %*s while casting Corrupt Energy and 404 Error.\n"):format(v1.UnstoppableDuration) .. "Additionally, <font color=\"rgb(248,217,109)\">John Doe</font> will roar and gain <b>Speed I</b> for 3s upon the stun ending. The duration of the speed boost is increased by 1s for every Sentinel Survivor currently alive.\n" .. "The cooldown of the ability that triggered <b>UNSTOPPABLE</b> is reduced by 50%.\n"
    }, 
    {
        Separator = "ABILITIES"
    }, 
    {
        Header = "SLASH", 
        Image = "rbxassetid://92362553672440", 
        Quote = "\"For many years, there has been lore circulating around John Doe and \226\150\136\226\150\136\226\150\136\226\150\136 Doe within the community.\" - Roblox", 
        Text = ("Cooldown: %*s\n"):format(v1.SlashCooldown) .. ("Damage: %*\n"):format(v1.SlashDamage) .. ("Windup: %*s\n"):format(v1.SlashWindup) .. ("Linger: %*s\n"):format(v1.SlashLinger) .. "Length: 7.5 studs\n" .. "<font color=\"rgb(248,217,109)\">John Doe</font> slashes infront of him using his claws.\n"
    }, 
    {
        Header = "CORRUPT ENERGY", 
        Image = "rbxassetid://83849304758564", 
        Quote = "\"This year, we\226\128\153ve decided that it\226\128\153s time to shed some light about these accounts.\" - Roblox", 
        Text = ("Cooldown: %*s\n"):format(v1.CorruptEnergyCooldown) .. ("Damage: %*\n"):format(v1.CorruptEnergyDamage) .. ("<font color=\"rgb(248,217,109)\">John Doe</font> punches his corrupted arm into the ground and, when he pulls it out, %* giant spikes (that last for %*s) emerge infront of him, piercing through any survivor unfortunate enough to be caught within them.\n"):format(v1.SpikeAmount, v1.SpikeLifetime) .. "Hitting a player with a spike gives <font color=\"rgb(248,217,109)\">John Doe</font> Speed I for 7 seconds.\n" .. ("Summoned spikes cannot damage the same target more than %* times.\n"):format(v1.SpikeHitCap) .. "Press Corrupt Energy again after the cast to Retract active spikes early. Retracting does not restart the original cooldown. These spikes can be used as blockades to prevent survivors from accessing certain areas.\n"
    }, 
    {
        Header = "DIGITAL FOOTPRINT", 
        Image = "rbxassetid://83206360003394", 
        Quote = "\"John Doe and \226\150\136\226\150\136\226\150\136\226\150\136 Doe are two of Roblox\226\128\153s earliest accounts, as seen by their low user IDs here.\" - Roblox", 
        Text = ("Cooldown: %*s\n"):format(v1.DigitalFootprintCooldown) .. "<font color=\"rgb(248,217,109)\">John Doe</font> stomps on the ground three times, commanding a shadow to emerge underneath his footsteps as a trap for survivors to walk over.\n" .. "If a survivor steps over the false shadow, then <font color=\"rgb(248,217,109)\">John Doe</font> gets a <b>Speed I</b> buff for 10 seconds and the survivor gets a <b>Corrupted I</b> & <b>Slowness II</b> debuff for 10 seconds.\n" .. "Upon the trap being triggered, <font color=\"rgb(248,217,109)\">John Doe</font> and the survivor who activated it have their auras revealed to each other for 10 seconds.\n" .. "The shadow despawns after contact is made with it or <font color=\"rgb(248,217,109)\">John Doe</font> attempts to place down a fourth shadow.\n" .. ("There can only be <b>%*</b> shadows present at once, and attempting to create more will cause the oldest shadow to dissipate.\n"):format(v1.DigitalFootprintLimit)
    }, 
    {
        Header = "404 ERROR", 
        Image = "rbxassetid://131116145215571", 
        Quote = "\"Authentic John Doe and \226\150\136\226\150\136\226\150\136\226\150\136 Doe accounts pose no danger to your Roblox account.\" - Roblox", 
        Text = ("Cooldown: %*s\n"):format(v1["404ErrorCooldown"]) .. ("<font color=\"rgb(248,217,109)\">John Doe</font>'s corrupted arm pulsates twice, revealing the auras of all living survivors to him for %* seconds.\n"):format(v1["404ErrorAuraRevealTime"])
    }
};
-- Phase-one rig profiles. Current FCT animations and all balance values are retained.
v1.JohnDoeRigCollision=script.JohnDoeRigCollision
v1.JohnDoeRigQuery=script.JohnDoeRigQuery
v1.JohnDoeRigScale=script:GetAttribute("JohnDoeRigScale") or 1.25
v1.JohnDoeRigPhase="1.0.0"
v1.HipHeight=0
v1.CorruptEnergyPhase="1.0.0"
return v1;]========],before="11201:a3ec107c:0a16eea7",after="11356:6ef0ee7a:cc954821"},
{path=[========[
ReplicatedStorage/Modules/Hitboxes]========],source=[========[
-- So, I've been trying to improve the engine recently and I just though: WHY NOT JUST RECODE EVERYTHING?????????????????
-- also improving my comments!
-- skiddy katamari will say this is trash because her engine needs to be better than anything

-- // services:
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local AnalyticsService = game:GetService("AnalyticsService")
local isStudio = RunService:IsStudio()
local isServer = RunService:IsServer()

-- // modules:
local Ragdolls = require(ReplicatedStorage.Modules.Ragdolls)
local Util = require(ReplicatedStorage.Modules.Util)
local AchievementUtil = require(ReplicatedStorage.Modules.AchievementUtil)
local Actors = require(ReplicatedStorage.Modules.Actors)
local Network = require(ReplicatedStorage.Modules.Network)
local Sounds = require(ReplicatedStorage.Modules.Sounds)
local Stats = require(ReplicatedStorage.Modules.Stats)
local Statuses = require(ReplicatedStorage.Modules.Statuses)

-- // new modules (these were originally not on forsaken neither on aeternus)
local Janitor = require(ReplicatedStorage.Modules.Misc.Janitor) -- expect to see this alot (maid will still be here to keep compatibility)
local CoreLoader = require(ReplicatedStorage.CoreLoader)
local Signal = require(ReplicatedStorage.Modules.Misc.Signal) -- why doesn't forsaken use this module

local Hitboxes = {}


-- new function to prevent wall clipping (aka. hitting someone if they are behind an wall)
local function PreventWallClip(pOrigin, pTargetPos, pExcludeChar)
	local diff = pTargetPos - pOrigin
	local dist = diff.Magnitude
	if dist > 10 then
		pTargetPos = pOrigin + diff.Unit * 10
		dist = 10
	end
	if dist < 0.1 then
		return pTargetPos
	end

	local rayParams = RaycastParams.new()
	rayParams.FilterType = Enum.RaycastFilterType.Exclude
	rayParams.FilterDescendantsInstances = { workspace.Players, pExcludeChar, workspace:FindFirstChild("Hitboxes") }

	local raycastResult = workspace:Raycast(pOrigin, diff, rayParams)
	if not raycastResult then
		return pTargetPos
	end

	local safeDist = math.max(raycastResult.Distance - 0.5, 0)
	return pOrigin + diff.Unit * safeDist
end


local function GetDictionaryLength(dict)
	local count = 0
	for _, _ in pairs(dict) do
		count += 1
	end
	return count
end


function Hitboxes.LineOfSight(_, origin, targetChar)
	local player = Players:GetPlayerFromCharacter(targetChar)

	if player then
		local _ = Actors.CurrentActors[player]
	end

	targetChar:FindFirstChild("Humanoid")

	local hasReplicating = targetChar:FindFirstChild("QueryHitbox") and (player and targetChar:HasTag("Replicating"))
	local raycastParams = RaycastParams.new()

	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.FilterDescendantsInstances = if not typeof(origin == "Vector3") then {
		workspace.Players,
		targetChar,
		origin
	} else {
			workspace.Players,
			targetChar
		}
	raycastParams.CollisionGroup = tostring(typeof(origin) ~= "Vector3" and (not not origin.PrimaryPart and origin.PrimaryPart.CollisionGroup) or "Killers")

	local function partCanBlock(hitPart)
		local isHitbox = hitPart:GetAttribute("Hitbox") or (hitPart.CanCollide or hitPart.Transparency < 1)
		local hitHumanoid = hitPart.Parent:FindFirstChild("Humanoid")

		if isHitbox and not hitHumanoid then
			return true
		end

		raycastParams:AddToFilter(hitPart)

		if hitHumanoid then
			raycastParams:AddToFilter(hitHumanoid.Parent)
		end

		return false
	end

	if typeof(origin) == "Vector3" then
	else
		local originPlayer = Players:GetPlayerFromCharacter(origin)
		local originActor = originPlayer and Actors.CurrentActors[originPlayer]

		origin = originActor and originActor:GetPivot(false).Position or origin.PrimaryPart.Position
	end

	for _, child in ipairs(targetChar:GetChildren()) do
		if not child:IsA("BasePart") or not child.CanQuery or child:GetAttribute("Hitbox") then
			continue
		end

		local objectSpace = targetChar.PrimaryPart.CFrame:ToObjectSpace(child.CFrame)
		local targetPos = hasReplicating and targetChar.QueryHitbox.CFrame:ToWorldSpace(objectSpace).Position or child.Position
		local attempts = 0
		local raycastResult

		repeat
			raycastResult = workspace:Raycast(origin, targetPos - origin, raycastParams)
			attempts += 1
		until not raycastResult or partCanBlock(raycastResult.Instance) or attempts > 15

		if not raycastResult and attempts <= 15 then
			return true
		end
	end

	return false
end


local function guestHitClient(target, ...)
	if typeof(target) == "Instance" and target:IsA("Player") then
		Network:FireClientConnection(target, ...)
	end
end
local function guestIsPlayer(target)
	return typeof(target) == "Instance" and target:IsA("Player")
end
local function guestCharacter(subject)
	if typeof(subject) == "Instance" then
		if subject:IsA("Player") then return subject.Character end
		if subject:IsA("Model") then return subject end
	elseif typeof(subject) == "table" then
		return subject.Rig or subject.Character
	end
end
local function guestActor(subject, rig)
	local player = rig and Players:GetPlayerFromCharacter(rig)
	local actor = subject and Actors.CurrentActors[subject] or player and Actors.CurrentActors[player] or rig and Actors.CurrentActors[rig]
	if actor and actor.Rig == rig then return actor end
	for _, candidate in pairs(Actors.CurrentActors) do
		if candidate.Rig == rig then return candidate end
	end
end

function Hitboxes.CreateHitbox(_, creator, hitboxParams)
	local creatorChar = guestCharacter(creator)

	if not creatorChar or not creatorChar.PrimaryPart then
		return
	end

	local params = hitboxParams or {}
	local config = {
		Size = params.Size or Vector3.new(4, 7, 4),
		CFrameOffset = params.CFrameOffset or CFrame.new(0, 0, 0),
		CFrame = params.CFrame or nil,
		CastPoint = if params.CastPoint ~= nil then params.CastPoint else nil,
		Damage = params.Damage or 15,
		AbilityType = params.AbilityType or nil,
		Time = params.Time or 0.125,
		Knockback = params.Knockback or 0,
		HitMultiple = params.HitMultiple or false,
		PredictVelocity = params.PredictVelocity == nil or params.PredictVelocity,
		ExecuteOnKill = params.ExecuteOnKill or false,
		FriendlyFire = params.FriendlyFire or false,
		Team = params.Team,
		Target = params.Target,
		OnlyHitPlayers = params.OnlyHitPlayers or false,
		RagdollOnHit = params.RagdollOnHit or false,
		Hide = params.Hide or false,
		DeathProfile = params.DeathProfile or {},
		Shape = params.Shape or Enum.PartType.Block,
		ExcludeChars = params.ExcludeChars or {},
        HitFilter = params.HitFilter,
		Connections = params.Connections or {}
	}
	local overlapParams = OverlapParams.new()

	overlapParams.FilterType = Enum.RaycastFilterType.Exclude
	overlapParams.FilterDescendantsInstances = { creatorChar }

	local hitboxState = {
		TimePast = 0,
		HumanoidsDamaged = {},
		InvincibleProcs = {},
		Creator = creator,
		AbilityType = config.AbilityType,
		Damage = config.Damage,
		IsProjectile = if params.IsProjectile ~= nil then params.IsProjectile else config.CFrame ~= nil,

		OnHit = Signal.new(),
		OnEnded = Signal.new()
	}

	local hitboxJanitor = Janitor.new()
	hitboxJanitor:Add(hitboxState.OnHit, "Destroy")
	hitboxJanitor:Add(hitboxState.OnEnded, "Destroy")

	local function runCallback(callbackName, ...)
		if config.Connections[callbackName] then
			config.Connections[callbackName](...)
		end
	end

	function hitboxState.Cancel(_)
		hitboxState.Cancelled = true
		hitboxJanitor:Cleanup()
	end

	task.spawn(function()
		local creatorActor = guestActor(creator, creatorChar)

		while creatorChar.Parent and creatorChar.PrimaryPart and hitboxState.TimePast < config.Time and not hitboxState.Cancelled do
			local humanoidsDamaged = hitboxState.HumanoidsDamaged
			local hitCount = 0

			for _, _ in pairs(humanoidsDamaged) do
				hitCount += 1
			end

			if hitCount > 0 and not config.HitMultiple or creatorChar:GetAttribute("Stunned") or not Util:IsAlive(creatorChar) and not hitboxState.IsProjectile then
				break
			end

			local pivotCF = creatorActor and creatorActor:GetPivot(not not config.PredictVelocity) or creatorChar.PrimaryPart.CFrame
			local hitboxPart = Instance.new("Part")

			hitboxPart.Name = tostring(creator) .. "Hitbox"
			hitboxPart.Transparency = 1
			hitboxPart.CanCollide = false
			hitboxPart.CanTouch = false
			hitboxPart.CanQuery = false
			hitboxPart.CastShadow = false
			hitboxPart.Anchored = true
			hitboxPart.Shape = config.Shape
			hitboxPart.Size = typeof(config.Size) == "function" and config.Size() or config.Size
			hitboxPart.CFrame = typeof(config.CFrame) == "function" and config.CFrame() or (config.CFrame or pivotCF * if typeof(config.CFrameOffset) ~= "function" then config.CFrameOffset else config.CFrameOffset())
			hitboxPart.Parent = workspace:FindFirstChild("Hitboxes")
			hitboxState.Instance = hitboxPart

			task.delay(0.36, function()
				if hitboxPart and hitboxPart.Parent then hitboxPart:Destroy() end
			end)

			if config.Hide then
				hitboxPart:SetAttribute("Hidden", true)
			end

			if config.PredictVelocity then
				if typeof(creator) ~= "Instance" or not creator:IsA("Player") then
				end
			end

			local partsFound = workspace:GetPartsInPart(hitboxPart, overlapParams)

			table.sort(partsFound, function(partA, partB)
				local parentA = partA.Parent
				local parentB = partB.Parent
				local priorityA = parentA:GetAttribute("HitboxPriority") or 1
				local priorityB = parentB:GetAttribute("HitboxPriority") or 1

				if priorityA == priorityB then
					priorityA = (creatorChar.PrimaryPart.Position - partB.Position).Magnitude
					priorityB = (creatorChar.PrimaryPart.Position - partA.Position).Magnitude
				end

				return priorityB < priorityA
			end)

			local targetsHit = {}

			for _, hitPart in ipairs(partsFound) do
				local victimHumanoid = hitPart.Parent:FindFirstChildOfClass("Humanoid")

				if victimHumanoid and not (victimHumanoid.Health <= 0) and (not victimHumanoid.Parent:HasTag("Replicating") or not Players:GetPlayerFromCharacter(victimHumanoid.Parent) or hitPart.Name == "QueryHitbox") and ((not victimHumanoid.Parent:HasTag("SurvivorConstruct") or not config.OnlyHitPlayers) and not hitboxState.HumanoidsDamaged[victimHumanoid]) and (not config.Team or tostring(hitPart.Parent.Parent) == config.Team or tostring(hitPart.Parent:GetAttribute("Team")) == config.Team) and ((workspace:GetAttribute("FriendlyFire") or config.FriendlyFire or config.Team and config.Team == tostring(creatorChar.Parent) or tostring(hitPart.Parent:GetAttribute("Team")) ~= tostring(creatorChar.Parent) and tostring(hitPart.Parent.Parent) ~= tostring(creatorChar.Parent)) and (not config.Target or config.Target == victimHumanoid.Parent)) then
					local castOrigin = if not config.CastPoint then if config.CFrame then hitboxPart.CFrame.Position else creatorChar else if typeof(config.CastPoint) ~= "function" then config.CastPoint else config.CastPoint()

							if (config.CastPoint == false or Hitboxes:LineOfSight(castOrigin, victimHumanoid.Parent)) and not table.find(config.ExcludeChars, victimHumanoid.Parent) and not table.find(config.ExcludeChars, victimHumanoid) then
								if victimHumanoid.Parent:GetAttribute("Invincible") then
									if not hitboxState.InvincibleProcs[victimHumanoid] then
										local victimPrimaryPart = victimHumanoid.Parent.PrimaryPart
										local invincibleFX = victimPrimaryPart and victimPrimaryPart:FindFirstChild("InvincibleFX")

										if invincibleFX and invincibleFX:FindFirstChild("Deflect") then
											Sounds:Play("invincibleDeflect", {
												Parent = victimPrimaryPart
											})
											invincibleFX.Deflect:Emit(1)
										end
									end

									hitboxState.InvincibleProcs[victimHumanoid] = true
								else
									local hitPriority = victimHumanoid.Parent:GetAttribute("HitboxPriority") or 1

									hitboxState.HumanoidsDamaged[victimHumanoid] = true
									table.insert(targetsHit, victimHumanoid)

									if not config.HitMultiple and hitPriority >= 0 then
										break
									end
								end
							end
						end
					end

					hitboxPart.Color = #targetsHit > 0 and Color3.new(0.5, 1, 0.5) or Color3.new(1, 0.25, 0.25)

					for i, victimHumanoid in ipairs(targetsHit) do
						local victimChar = victimHumanoid.Parent
                        -- Optional per-hitbox predicate, before damage and all victim hit reactions.
                        if config.HitFilter and not config.HitFilter(victimChar,hitboxState) then continue end
						local victimPrimaryPart = victimChar and (victimChar:IsA("Model") and victimChar.PrimaryPart)
						local rawDamage = typeof(config.Damage) == "number" and config.Damage or config.Damage(victimChar)
						local resistanceSum = 0
						local resistanceFolder = victimChar and victimChar:FindFirstChild("ResistanceMultipliers")

						for _, resistanceValue in pairs(resistanceFolder and resistanceFolder:GetChildren() or {}) do
							resistanceSum += resistanceValue.Value
						end

						local weakenedDamage = require(game.ReplicatedStorage.Modules.DamageRules).ScaleDamage(creatorChar, rawDamage)
						local finalDamage = weakenedDamage * (1 - math.min(resistanceSum - (creatorChar:GetAttribute("StrengthBuff") or 0), 100) / 100)

						if not victimPrimaryPart then
							continue
						end

						victimChar:SetAttribute("TimesHit", (victimChar:GetAttribute("TimesHit") or 0) + 1)
						runCallback("HitAbsolute", victimChar, i == 1)

						local victimPlayer = Players:GetPlayerFromCharacter(victimChar)
						local victimActor = guestActor(victimPlayer, victimChar)

						if victimActor and victimActor.Behavior and victimActor.Behavior.OnHit then
							local hitResponse = victimActor.Behavior:OnHit(
								victimActor,
								hitboxState,
								finalDamage
							)

							if hitResponse == "Ignored" then
								continue
							end

							if typeof(hitResponse) == "table"
								and typeof(hitResponse.DamageOverride) == "number" then

								finalDamage = math.max(0, hitResponse.DamageOverride)
							end

							if hitboxState.TimePast > config.Time then
								break
							end
						end

						local knockbackVal = not (typeof(config.Knockback) ~= "number" and typeof(config.Knockback) ~= "Vector3") and config.Knockback or config.Knockback(victimChar)
						local isKbVector = typeof(knockbackVal) == "Vector3"
						local kbDir = isKbVector and knockbackVal or hitboxPart.CFrame.LookVector

						if isKbVector or knockbackVal > 0 then
							local kbForce = (typeof(knockbackVal) == "Vector3" and knockbackVal or kbDir * knockbackVal) * 10

							if victimPlayer then
								guestHitClient(victimPlayer, "KB", "REMOTE_EVENT", Util:SerializeVector(kbForce))
							else
								victimPrimaryPart.AssemblyLinearVelocity = kbForce + victimPrimaryPart.AssemblyLinearVelocity / 2
							end
						end

						local deathProfile = Util:CopyTable(config.DeathProfile)

						if not deathProfile.Velocity then
							if isKbVector then
								deathProfile = {
									Velocity = kbDir * 10
								}
							elseif knockbackVal > 0 then
								deathProfile = {
									Velocity = kbDir * knockbackVal * 10
								}
							end
						end

						Ragdolls.AddProfile(victimChar, deathProfile)

						local damageDealt = finalDamage
						local overhealVal = victimHumanoid:GetAttribute("Overheal") or 0
						local shatterpointHP = victimChar:GetAttribute("ShatterpointHP") or 0
						local _ = victimHumanoid.Health + overhealVal + shatterpointHP
						local isVictimAlive = victimHumanoid.Health > 0
						local remainingOverheal = math.max(0, overhealVal - finalDamage)

						if remainingOverheal < (victimHumanoid:GetAttribute("OverhealDecayMin") or 0) then
							victimHumanoid:SetAttribute("OverhealDecayMin", remainingOverheal > 0 and remainingOverheal or nil)
						end

						local damageToApply = finalDamage - overhealVal

						if damageToApply > 0 and shatterpointHP > 0 then
							local shatterDamage = damageToApply * (victimChar:GetAttribute("ShatterpointResistance") or 1)

							if shatterDamage > 0 then
								local victimBehaviorActor = guestActor(victimPlayer, victimChar)

								if victimBehaviorActor and victimBehaviorActor.Behavior and victimBehaviorActor.Behavior.sv_DamageCrystalHP then
									victimBehaviorActor.Behavior:sv_DamageCrystalHP(victimBehaviorActor, shatterDamage)
								else
									victimChar:SetAttribute("ShatterpointHP", (math.max(0, shatterpointHP - shatterDamage)))
								end

								local shatterRemainder = shatterDamage - shatterpointHP

								damageDealt = shatterDamage + overhealVal
								damageToApply = not (shatterRemainder > 0) and 0 or shatterRemainder
							end
						end

						local finalDeductibleDamage = math.max(0, damageToApply)
						local victimPosInt16 = Vector3int16.new(victimPrimaryPart.Position.X, victimPrimaryPart.Position.Y, victimPrimaryPart.Position.Z)
						local isKilled = victimHumanoid.Health - finalDeductibleDamage <= 0
						local creatorBehaviorActor = guestActor(creator, creatorChar)

						if creatorBehaviorActor then
							local _, _ = pcall(function()
								return creatorBehaviorActor.Behavior.OnInflictedDamage(creatorBehaviorActor, victimChar, (math.min(victimHumanoid.Health, damageDealt)))
							end)
						end

						if isVictimAlive and isKilled then
							local protectionPlayerName = victimChar:GetAttribute("DusekkarProtected")
							local protectionPlayer = protectionPlayerName and Players:FindFirstChild(protectionPlayerName)

							if protectionPlayer then
								local protectorChar = protectionPlayer.Character

								print(`dusekkar moment ({ victimChar } protected by { protectionPlayer })`)
								Actors:IncrementActorStats(protectionPlayer, {
									Action = "Prevented the death of a Survivor",
									Money = 10,
									EXP = 30
								})
								victimChar:SetAttribute("DusekkarProtected", nil)
								protectorChar:SetAttribute("Protecting", nil)
								AchievementUtil:IncrementAchievementProgress(protectionPlayer, "DusekkarUbercharge")

								return
							end

							if tostring(victimChar.Parent) == "Survivors" then
								if guestIsPlayer(creator) then
									Stats:UpdatePlayerStat(creator, "Kills", "Add", 1)
								end

								if creatorBehaviorActor then
									creatorBehaviorActor.TotalKills =
										(creatorBehaviorActor.TotalKills or 0) + 1

									local ok, result = pcall(function()
										AnalyticsService:LogCustomEvent(creator, "TotalKills", 1, {
											[Enum.AnalyticsCustomFieldKeys.CustomField01.Name] = `Character - { creatorBehaviorActor.ActorName }`
										})
									end)

									if not ok then
										warn(`[AnalyticsService]: Failed to log custom event: TotalKills due to: { result }`)
									end
								end
							end

							local creatorVoicelines = creatorBehaviorActor and creatorBehaviorActor.Config.Voicelines

							if creatorVoicelines and not victimChar:GetAttribute("ExecutionsDisabled") then
								local killType = "Kill"

								if isServer then
									local RoundManager = require(game.ServerScriptService.Server.Systems.Core.RoundManager)

									if RoundManager and RoundManager.CurrentSession and RoundManager.CurrentSession.LastSurvivorAlive then
										killType = "LastKill"
									end
								end

								for _, actionName in ipairs({
									killType,
									"Kill"
									}) do
									if creatorVoicelines[`{ actionName }{ tostring(victimChar:GetAttribute("SkinName")) }`] then
										Sounds:PlayVoiceline(creatorBehaviorActor, `Kill{ tostring(victimChar:GetAttribute("SkinName")) }`)

										break
									end

									if creatorVoicelines[`{ actionName }{ victimChar.Name }`] then
										Sounds:PlayVoiceline(creatorBehaviorActor, `Kill{ victimChar.Name }`)

										break
									end

									if creatorVoicelines[`{ actionName }`] then
										Sounds:PlayVoiceline(creatorBehaviorActor, "Kill")

										break
									end
								end
							end

							local RoundManager = game.ServerScriptService.Server.Systems.Core.RoundManager
							local lib = require(RoundManager)

							if tostring(victimChar.Parent) == "Survivors" and (lib.CurrentSession and lib.CurrentSession.TimePast or isStudio or workspace:GetAttribute("Testing")) then
								lib:AddTime(nil, victimActor and victimActor.TimeAddMultiplier or 1, true)

								if creatorBehaviorActor and creatorBehaviorActor.Behavior and creatorBehaviorActor.Behavior.OnKill then
									local ok, result = pcall(function()
										return creatorBehaviorActor.Behavior.OnKill(creatorBehaviorActor, victimChar)
									end)

									if not ok then
										warn(`[{ script }/CreateHitbox]: Failed to call .OnKill() due to: { result }`)
									end
								end

								require(game.ServerScriptService.Server.Systems.Core.EventHandlerServer):CallMethod("OnPlayerKilled", creator, victimPlayer)
								if guestIsPlayer(creator) then
									Actors:IncrementActorStats(creator, {
										Action = "Killed a Survivor", Money = 15, EXP = 45
									})
								end
							end

							if config.ExecuteOnKill and guestIsPlayer(creator) and creatorBehaviorActor and not victimChar:GetAttribute("ExecutionsDisabled") and not (creatorBehaviorActor.AbilityDisablers or {}).Execution then
								local skinName = victimChar:GetAttribute("SkinName")
								local executionAnimName = nil

								if not creatorBehaviorActor then
									warn("Hitboxes: Non-Actor attempted to Execute!")
								else
									executionAnimName = if not skinName or (skinName == "" or not creatorBehaviorActor.Config.Animations[`Execution{ skinName }`]) then not creatorBehaviorActor.Config.Animations[`Execution{ victimChar.Name }`] and "Execution" or `Execution{ victimChar.Name }` else `Execution{ skinName }`
								end

								local executionAnimConfig = creatorBehaviorActor and creatorBehaviorActor.Config.Animations[executionAnimName]

								if executionAnimConfig and executionAnimConfig.KillerRig and executionAnimConfig.PlayerRig then
									task.spawn(function()
										Statuses:RemoveStatuses(victimChar, true)
										Util:GiveStackableAttribute(victimChar, "BeingExecuted", `{ creatorBehaviorActor.Player.Name }Execution`, 10)

										local killerTrack = creatorBehaviorActor.Cache[`{ executionAnimName }Anim`]

										if not killerTrack then
											killerTrack = Util:LoadAnimationFromID(creatorBehaviorActor.Rig, executionAnimConfig.KillerRig, false)
											creatorBehaviorActor.Cache[`{ executionAnimName }Anim`] = killerTrack
										end

										local killerPrimaryPart = creatorBehaviorActor.Rig.PrimaryPart
										local victimTrack = Util:LoadAnimationFromID(victimChar, executionAnimConfig.PlayerRig, false)
										local isExecutionFinished = false
										local stateConn = nil

										stateConn = victimHumanoid.StateChanged:Connect(function(_, newState)
											if newState == Enum.HumanoidStateType.Dead then
												isExecutionFinished = true

												if stateConn then
													stateConn:Disconnect()
													hitboxJanitor:Remove("Execution_" .. victimHumanoid.Name)
												end

												guestHitClient(creator, "Hit", "UREMOTE_EVENT", damageDealt, victimPosInt16, nil, true)
											end
										end)

										hitboxJanitor:Add(stateConn, "Disconnect", "Execution_" .. victimHumanoid.Name)

										Util:GiveInvincible(creatorChar, "Executing")
										Util:SetUpCutscene(creatorBehaviorActor.Rig, victimChar, executionAnimConfig.PlayerCFrameOffset, "Execution")
										task.delay(killerTrack.Length + 1.5, function()
											Util:RemoveInvincible(creatorChar, "Executing")
										end)
										creatorBehaviorActor:DisableAbilities("Execution", true)
										task.delay(killerTrack.Length, function()
											if stateConn then
												stateConn:Disconnect()
												hitboxJanitor:Remove("Execution_" .. victimHumanoid.Name)
											end

											if not isExecutionFinished then
												isExecutionFinished = true
												guestHitClient(creator, "Hit", "UREMOTE_EVENT", damageDealt, victimPosInt16, nil, true)
											end

											creatorBehaviorActor:DisableAbilities("Execution", false)
											Util:ToggleAnchored(creatorBehaviorActor.Rig, "Execution", false)
											Util:ToggleAnchored(victimChar, "Execution", false)
											Util:RemoveStackableAttribute(victimChar, "NoItems", "Execution")
											victimHumanoid.Health = 0
											victimHumanoid:ChangeState(Enum.HumanoidStateType.Dead)
										end)
										killerTrack:Play(0)
										victimTrack:Play(0)

										local executionSound = creatorBehaviorActor.Config.Sounds[executionAnimName]

										Sounds:Play(executionSound, {
											Parent = killerPrimaryPart
										})

										if creatorBehaviorActor.Behavior.OnExecution then
											creatorBehaviorActor.Behavior:OnExecution(creatorBehaviorActor, victimChar, {
												victimInfo = victimActor,
												Tracks = {
													Killer = killerTrack,
													Victim = victimTrack
												}
											})
										end

										if creatorBehaviorActor.Behavior.OnExecutionClient then
											guestHitClient(creatorBehaviorActor.Player, "OnExecutionClientAsync", "REMOTE_EVENT", victimChar)
										end
									end)

									return
								end
							end
						end

						if config.RagdollOnHit then
							local ragdollTime = typeof(config.RagdollOnHit) == "number" and config.RagdollOnHit or 2

							Ragdolls.EnableRagdoll(victimChar, ragdollTime)
						end

						victimChar:SetAttribute("RecentAttacker", (tostring(creator)))
						victimChar:SetAttribute("RecentAttackerTime", os.clock())

						if victimHumanoid:GetAttribute("Overheal") then
							victimHumanoid:SetAttribute("Overheal", remainingOverheal > 0 and remainingOverheal or nil)
						end

						victimHumanoid.Health = victimHumanoid.Health - finalDeductibleDamage

						if victimHumanoid.Health <= 0 then
							victimHumanoid:SetAttribute("Overheal", nil)
							victimHumanoid:ChangeState(Enum.HumanoidStateType.Dead)
						end

						runCallback("Hit", victimChar, i == 1)
						hitboxState.OnHit:Fire(victimChar, i == 1)

						guestHitClient(creator, "Hit", "UREMOTE_EVENT", damageDealt, victimPosInt16, nil, victimHumanoid.Health <= 0)
					end

					local stateRef = hitboxState

					stateRef.TimePast = stateRef.TimePast + RunService.Heartbeat:Wait()
				end

				runCallback("Ended")
				hitboxState.OnEnded:Fire()
			end)

	task.delay(config.Time + 1, function()
		hitboxJanitor:Cleanup()
	end)

	return hitboxState
end


function Hitboxes.Start(_)
	if isServer then
		local Folder = Instance.new("Folder")

		Folder.Name = "Hitboxes"
		Folder.Parent = workspace
	end
end


function Hitboxes.CreateMainAbilityHitbox(self, creator, options)
	local params = table.clone(options or {})
	if params.AbilityType == nil then params.AbilityType = "MainAbility" end
	if params.IsProjectile == nil then params.IsProjectile = false end
	return self:CreateHitbox(creator, params)
end

return Hitboxes
]========],before="26835:14305f77:9b51252e",after="27086:389d8f7c:44479c89"},
{path=[========[
ServerStorage/Assets/Killers/JohnDoe/Behavior]========],source=[========[
-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local _ = require(game.ReplicatedStorage.GlobalTypes);
local v1 = {};
local CorruptEnergyController=require(script.CorruptEnergyController);
local RigAlignment=require(script.RigAlignment);
v1.GetRig=function(_,actor) return RigAlignment.GetRig(actor) end;
local l_TweenService_0 = game:GetService("TweenService");
local _ = game:GetService("HttpService");
local l_Players_0 = game:GetService("Players");
local v5 = require(game.ReplicatedStorage.Modules.Sounds);
local v6 = require(game.ReplicatedStorage.Modules.Util);
local v7 = require(game.ReplicatedStorage.Modules.Hitboxes);
local v8 = require(game.ReplicatedStorage.Modules.Statuses);
local v9 = require(game.ReplicatedStorage.Modules.Network);
local v10 = require(game.ReplicatedStorage.Modules.AchievementUtil);
local function v16(v11, v12, v13, ...) --[[ Line: 23 ]] --[[ Name: pcallMethod ]]
    local l_status_0, l_result_0 = pcall(function(...) --[[ Line: 24 ]]
        -- upvalues: v13 (copy), v11 (copy)
        if v13.Behavior[v11] then
            return v13.Behavior[v11](v13.Behavior, v13, ...);
        else
            return;
        end;
    end, ...);
    if not l_status_0 then
        warn((("[%*]: Failed to call .%*() due to: %*"):format(v12, v11, l_result_0)));
    end;
    return l_result_0;
end;
v1.Abilities = {
    Slash = {
        LayoutOrder = 1, 
        Icon = "rbxassetid://92362553672440", 
        KeybindType = "MainAbility", 
        Callback = function(v17) --[[ Line: 42 ]] --[[ Name: Callback ]]
            -- upvalues: v5 (copy), v7 (copy), v6 (copy)
            if game["Run Service"]:IsServer() then
                v17.AbilitiesDisabled = true;
                v5:Play(v17.Config.Sounds.Swing, {
                    Parent = v17.Rig.PrimaryPart, 
                    PlaybackSpeed = Random.new():NextNumber(0.975, 1.025), 
                    Volume = 0.35
                });
                task.delay(v17.Config.SlashWindup, function() --[[ Line: 49 ]]
                    -- upvalues: v7 (ref), v17 (copy), v6 (ref), v5 (ref)
                    local _ = v7:CreateHitbox(v17.Player, {
                        Size = Vector3.new(4.5, 6, 7.5, 0), 
                        CFrameOffset = RigAlignment.SlashOffset(v17), 
                        Damage = v17.Config.SlashDamage, 
                        Time = v17.Config.SlashLinger, 
                        Knockback = 2, 
                        HitMultiple = false, 
                        ExecuteOnKill = true, 
                        Connections = {
                            Hit = function(v18, v19) --[[ Line: 61 ]] --[[ Name: Hit ]]
                                -- upvalues: v6 (ref), v5 (ref), v17 (ref)
                                v6:CreateSpeedMultiplier(v18, 1.5, "HitSpeedBonus", 1.25);
                                if v19 then
                                    v5:Play(v17.Config.Sounds.Hit, {
                                        Parent = v17.Rig.PrimaryPart, 
                                        PlaybackSpeed = Random.new():NextNumber(0.975, 1.025), 
                                        Volume = 0.5
                                    });
                                end;
                            end
                        }
                    });
                end);
                task.delay(0.75, function() --[[ Line: 72 ]]
                    -- upvalues: v17 (copy)
                    v17.AbilitiesDisabled = false;
                end);
                return;
            else
                if game["Run Service"]:IsClient() then
                    if v17.Animations.Slash1 then
                        v17.Animations[("Slash%*"):format((tostring(math.random(1, 2))))]:Play(0.025);
                        return;
                    else
                        v17.Animations.Slash:Play(0.025);
                    end;
                end;
                return;
            end;
        end
    }, 
    CorruptEnergy = {
        LayoutOrder=2,Name="Corrupt Energy",Icon="rbxassetid://83849304758564",KeybindType="AltAbility1",
        Cooldown=function(actor)
            return CorruptEnergyController.CanRetract(actor) and 0 or actor.Config.CorruptEnergyCooldown
        end,
        Callback=function(actor,data)
            if game:GetService("RunService"):IsServer() then
                local result=CorruptEnergyController.Cast(actor)
                if not result.Cancelled and not result.Retract then v16("CorruptEnergyStart","JohnDoe/CorruptEnergyStart",actor) end
                return result
            end
            if not (data and data.Retract) then v16("CorruptEnergyStart","JohnDoe/CorruptEnergyStart",actor) end
            return CorruptEnergyController.Play(actor,data)
        end
    },
    DigitalFootprint = {
        LayoutOrder = 3, 
        Icon = "rbxassetid://83206360003394", 
        KeybindType = "AltAbility2", 
        Callback = function(v51, v52) --[[ Line: 311 ]] --[[ Name: Callback ]]
            -- upvalues: v5 (copy), v16 (copy), v6 (copy), v8 (copy), v9 (copy), l_Players_0 (copy)
            local v53 = {
                0.317, 
                1.05, 
                2.067
            };
            local v54 = 0;
            local v55 = 0;
            if game["Run Service"]:IsServer() then
                v51.AbilitiesDisabled = true;
                v5:Play(v51.Config.Sounds.DigitalFootprint, {
                    Parent = v51.Rig.PrimaryPart, 
                    Volume = 0.4, 
                    TimePosition = 0.09, 
                    PlaybackSpeed = 1.2
                });
                v16("DFStart", ("%*/DFS"):format(script.Parent), v51);
                local function v60(v56) --[[ Line: 323 ]] --[[ Name: removeShadow ]]
                    -- upvalues: v6 (ref), v51 (copy)
                    if v56 and v56.Parent then
                        v56.Name = "okByeBye";
                        v56.Parent = workspace.Map.Ingame;
                        game.Debris:AddItem(v56, 5);
                        local l_ShadowAmbience_0 = v56:FindFirstChild("ShadowAmbience");
                        if l_ShadowAmbience_0 then
                            game.TweenService:Create(l_ShadowAmbience_0, TweenInfo.new(2), {
                                Volume = 0
                            }):Play();
                        end;
                        for _, v59 in pairs(v56:GetDescendants()) do
                            if v59:IsA("ParticleEmitter") then
                                v59.Enabled = false;
                            end;
                        end;
                        v6:RemovePlayerAuraFrom(v56, v51.Player);
                    end;
                end;
                local l_FirstChild_0 = workspace.Map.Ingame:FindFirstChild((("%*Shadows"):format((tostring(v51.Player)))));
                if not l_FirstChild_0 then
                    l_FirstChild_0 = Instance.new("Folder");
                    l_FirstChild_0.Name = ("%*Shadows"):format((tostring(v51.Player)));
                    l_FirstChild_0.Parent = workspace.Map.Ingame;
                end;
                local l_l_FirstChild_0_Children_0 = l_FirstChild_0:GetChildren();
                if #l_l_FirstChild_0_Children_0 >= v51.Config.DigitalFootprintLimit then
                    v60(l_l_FirstChild_0_Children_0[1]);
                end;
                local v63 = v51.Config.Shadow:Clone();
                v63.Size = Vector3.new(1, 0, 0, 0);
                v63.Parent = l_FirstChild_0;
                v5:Play(v51.Config.Sounds.DigitalFootprintAmbience, {
                    Parent = v63, 
                    Name = "ShadowAmbience", 
                    RollOffMaxDistance = 30, 
                    Looped = true
                });
                local v64 = RaycastParams.new();
                v64.FilterDescendantsInstances = {
                    workspace.Players, 
                    v63
                };
                v64.FilterType = Enum.RaycastFilterType.Exclude;
                task.delay(tonumber(v53[#v53]) or 2.55, function() --[[ Line: 380 ]]
                    -- upvalues: v6 (ref), v63 (copy), v51 (copy), v60 (copy), v8 (ref), v9 (ref), l_Players_0 (ref)
                    v6:ApplyUnsafeTouched(v63, false, function(_, v66) --[[ Line: 381 ]]
                        -- upvalues: v6 (ref), v51 (ref), v63 (ref), v60 (ref), v8 (ref), v9 (ref), l_Players_0 (ref)
                        local l_Parent_0 = v66.Parent;
                        local v68 = l_Parent_0 and l_Parent_0:FindFirstChild("Humanoid");
                        if v68 and v6:GetEntityType(l_Parent_0) and l_Parent_0 ~= v51.Rig and v68 and v68.Health > 0 and v63.Name == "Shadow" and not l_Parent_0:GetAttribute("ExecutionsDisabled") then
                            v60(v63);
                            v6:RevealPlayerAuraTo(v51.Rig, l_Parent_0, 10);
                            v6:RevealPlayerAuraTo(l_Parent_0, v51.Rig, 10);
                            v8:ApplyStatus(v51.Rig, "Speed", {
                                Level = 1, 
                                Duration = 10
                            });
                            v8:ApplyStatus(l_Parent_0, "Slowness", {
                                Level = 2, 
                                Duration = 10
                            });
                            v8:ApplyStatus(l_Parent_0, "Corrupted", {
                                Level = 1, 
                                Duration = 10, 
                                Killer = v51
                            });
                            if not v51.FootprintRewardDebounce[l_Parent_0] then
                                v51.FootprintRewardDebounce[l_Parent_0] = true;
                                require(game.ReplicatedStorage.Modules.Actors):IncrementActorStats(v51.Player, {
                                    Action = "Survivor stepped into a Digital Footprint trap", 
                                    RewardType = "RegularKillerAction"
                                });
                                task.delay(15, function() --[[ Line: 408 ]]
                                    -- upvalues: v51 (ref), l_Parent_0 (copy)
                                    v51.FootprintRewardDebounce[l_Parent_0] = nil;
                                end);
                            end;
                            v9:FireClientConnection(l_Players_0:GetPlayerFromCharacter(l_Parent_0), ("%*JDPuddleEffect"):format(v51.Player.Name), "REMOTE_EVENT");
                        end;
                    end, 14);
                end);
                task.spawn(function() --[[ Line: 419 ]]
                    -- upvalues: v54 (ref), v63 (copy), v55 (ref), v53 (copy), v51 (copy), v64 (copy), v16 (ref), v9 (ref)
                    while v54 ~= 3 and v63.Parent and v63.Name == "Shadow" do
                        v55 = v55 + game["Run Service"].Heartbeat:Wait();
                        for v69 = #v53, 1, -1 do
                            if v53[v69] and v55 >= v53[v69] then
                                table.remove(v53, v69);
                                v54 = v54 + 1;
                                local l_Position_2 = (v51.Rig.PrimaryPart.CFrame * CFrame.new(-1.1, 0, -2)).Position;
                                local v71 = workspace:Raycast(l_Position_2, Vector3.new(0, -100, 0, 0), v64);
                                v63.Position = (v71 and v71.Position or v51.Rig.PrimaryPart.Position - Vector3.new(0, 2.5, 0, 0)) + Vector3.new(0, 0.5, 0, 0);
                                game.TweenService:Create(v63, TweenInfo.new(1), {
                                    Size = Vector3.new(1, v54 * 6, v54 * 6)
                                }):Play();
                                v16("OnStomp", ("%*/OnStomp"):format(script.Parent), v51, v63, v54);
                                if v54 == 3 then
                                    v9:FireAllClientConnection(("%*OnPuddleRevealed"):format(v51.Player.Name), "REMOTE_EVENT", v63);
                                end;
                            end;
                        end;
                    end;
                end);
                task.delay(3, function() --[[ Line: 446 ]]
                    -- upvalues: v51 (copy)
                    v51.AbilitiesDisabled = false;
                end);
                return v63;
            else
                if game["Run Service"]:IsClient() then
                    v51.Animations.DigitalFootprint:Play(0.025);
                    local l_Connections_0 = v51.Behavior.Connections;
                    if not l_Connections_0.onShadowFolderAdded or not l_Connections_0.onShadowFolderRemoved then
                        local l_FirstChild_1 = workspace.Map.Ingame:FindFirstChild((("%*Shadows"):format((tostring(v51.Player)))));
                        if not l_FirstChild_1 then
                            return;
                        else
                            local l_AbilityContainer_0 = v51.Player.PlayerGui.MainUI:FindFirstChild("AbilityContainer");
                            local v75 = l_AbilityContainer_0 and l_AbilityContainer_0:FindFirstChild("DigitalFootprint");
                            local v76 = 1;
                            do
                                local l_v76_0 = v76;
                                local function v80(v78) --[[ Line: 465 ]] --[[ Name: onShadowChange ]]
                                    -- upvalues: v75 (copy), l_v76_0 (ref), v51 (copy)
                                    if not v75 then
                                        return;
                                    else
                                        l_v76_0 = math.max(0, l_v76_0 + v78);
                                        v75.Charges.Text = l_v76_0 == 0 and "" or l_v76_0;
                                        local v79 = l_v76_0 >= v51.Config.DigitalFootprintLimit;
                                        v75.Charges.TextColor3 = v79 and Color3.new(1, 0, 0) or Color3.new(1, 1, 1);
                                        return;
                                    end;
                                end;
                                v51.Behavior.Connections.onShadowFolderAdded = l_FirstChild_1.ChildAdded:Connect(function(v81) --[[ Line: 477 ]]
                                    -- upvalues: v80 (copy)
                                    if not v81:IsA("BasePart") then
                                        return;
                                    else
                                        v80(1);
                                        return;
                                    end;
                                end);
                                v51.Behavior.Connections.onShadowFolderRemoved = l_FirstChild_1.ChildRemoved:Connect(function(v82) --[[ Line: 485 ]]
                                    -- upvalues: v80 (copy)
                                    if not v82:IsA("BasePart") then
                                        return;
                                    else
                                        v80(-1);
                                        return;
                                    end;
                                end);
                                v80(0);
                            end;
                        end;
                    end;
                    local l_v6_SpeedMultiplier_1 = v6:CreateSpeedMultiplier(v51.Player, 0, "DigitalFootprint");
                    game.Debris:AddItem(l_v6_SpeedMultiplier_1, 3);
                    task.spawn(function() --[[ Line: 501 ]]
                        -- upvalues: v51 (copy), v53 (copy), v55 (ref), v54 (ref), v6 (ref)
                        while v51 and v51.Rig.Parent and v53[1] do
                            v55 = v55 + game["Run Service"].Heartbeat:Wait();
                            for v84 = #v53, 1, -1 do
                                if v53[v84] and v55 >= v53[v84] then
                                    table.remove(v53, v84);
                                    v54 = v54 + 1;
                                    v6:ApplyCameraShake(v54 * 0.2, v54 * 0.375);
                                end;
                            end;
                        end;
                    end);
                    task.delay(3, function() --[[ Line: 517 ]]
                        -- upvalues: v52 (copy), v6 (ref)
                        if not v52 or not v52.Parent then
                            return;
                        else
                            v52.Transparency = 0;
                            v6:RevealPlayerAura(v52, "inf", Color3.new(1, 0.321569, 0.333333), nil, {
                                OutlineTransparency = 0.35, 
                                FillTransparency = 1
                            });
                            return;
                        end;
                    end);
                end;
                return;
            end;
        end
    }, 
    ["404Error"] = {
        Name = "404 Error", 
        LayoutOrder = 4, 
        Icon = "rbxassetid://131116145215571", 
        KeybindType = "AltAbility3", 
        Callback = function(v85) --[[ Line: 537 ]] --[[ Name: Callback ]]
            -- upvalues: v16 (copy), v5 (copy), v6 (copy), v9 (copy)
            v16("ErrorStart", ("%*/404S"):format(script.Parent), v85);
            if game["Run Service"]:IsServer() then
                v85.CurrentAbility = "404Error";
                v85.Config.StunDuration = v85.Config.UnstoppableDuration;
                v85.AbilitiesDisabled = true;
                v5:Play(v85.Config.Sounds["404Error"], {
                    Parent = v85.Rig.PrimaryPart, 
                    Volume = 0.4, 
                    TimePosition = 0.09, 
                    RollOffMaxDistance = 200, 
                    PlaybackSpeed = 1.15
                });
                task.delay(1.625, function() --[[ Line: 550 ]]
                    -- upvalues: v85 (copy)
                    v85.Config.StunDuration = nil;
                    v85.CurrentAbility = nil;
                    v85.AbilitiesDisabled = false;
                end);
                return;
            else
                if game["Run Service"]:IsClient() then
                    local l_v6_SpeedMultiplier_2 = v6:CreateSpeedMultiplier(v85.Player, 1, "404Error");
                    local l_v6_FOVMultiplier_0 = v6:CreateFOVMultiplier(v85.Player, 1, "404Error");
                    game.TweenService:Create(l_v6_SpeedMultiplier_2, TweenInfo.new(0.5), {
                        Value = 0.25
                    }):Play();
                    game.TweenService:Create(l_v6_FOVMultiplier_0, TweenInfo.new(1.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, true), {
                        Value = 0.75
                    }):Play();
                    v9:FireConnection("DisableSprinting", "404Error", true);
                    task.delay(1.2, function() --[[ Line: 567 ]]
                        -- upvalues: v5 (ref), v85 (copy), v9 (ref), l_v6_SpeedMultiplier_2 (copy), l_v6_FOVMultiplier_0 (copy), v6 (ref)
                        v5:Play(v85.Config.Sounds["404ErrorError"], {
                            Parent = v85.Rig.PrimaryPart, 
                            Volume = 0.4, 
                            TimePosition = 0.09, 
                            PlaybackSpeed = Random.new():NextNumber(0.9, 1.1)
                        });
                        v9:FireConnection("DisableSprinting", "404Error", false);
                        game.TweenService:Create(l_v6_SpeedMultiplier_2, TweenInfo.new(0.6), {
                            Value = 1
                        }):Play();
                        game.TweenService:Create(l_v6_FOVMultiplier_0, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                            Value = 1
                        }):Play();
                        game.Debris:AddItem(l_v6_SpeedMultiplier_2, 0.4);
                        game.Debris:AddItem(l_v6_FOVMultiplier_0, 1);
                        for _, v89 in pairs(workspace.Players.Survivors:GetChildren()) do
                            v6:RevealPlayerAura(v89, v85.Config["404ErrorAuraRevealTime"]);
                        end;
                    end);
                end;
                return;
            end;
        end
    }
};
v1.ErrorStart = function(_, _) --[[ Line: 591 ]] --[[ Name: ErrorStart ]]

end;
v1.CorruptEnergyStart = function(_, _) --[[ Line: 595 ]] --[[ Name: CorruptEnergyStart ]]

end;
v1.OnPuddleEpilepsy = function(_, _, _) --[[ Line: 599 ]] --[[ Name: OnPuddleEpilepsy ]]

end;
v1.OnStomp = function(_, _, v99, v100) --[[ Line: 603 ]] --[[ Name: OnStomp ]]
    for _, v102 in pairs(v99:GetDescendants()) do
        if v102:IsA("ParticleEmitter") and v102.Name:find("ShadowPuddle") then
            v102.Enabled = v102.Name == ("ShadowPuddle%*"):format(v100);
        end;
    end;
end;
v1.Created = function(v103, v104) --[[ Line: 611 ]] --[[ Name: Created ]]
    -- upvalues: v10 (copy), v6 (copy), v8 (copy), l_Players_0 (copy), v9 (copy), v5 (copy), l_TweenService_0 (copy), v16 (copy)
    v103.Connections = {};
    if game["Run Service"]:IsServer() then
        if workspace:GetAttribute("JohnDoeSpecialDay") then
            v10:IncrementAchievementProgress(v104.Player, "JohnDoeSpecialDay");
        end;
        local l_Folder_0 = Instance.new("Folder");
        l_Folder_0.Name = "JohnDoeTrail";
        l_Folder_0.Parent = v104.Rig;
        for _ = 1, math.clamp(math.round(v104.Config.TrailLength / 4), 2, 1e999) do
            local v107 = v104.Config.Trail:Clone();
            v107.Position = RigAlignment.TrailPoint(v104,true);
            v107.Parent = l_Folder_0;
            v107:SetAttribute("FinishedUpdating", true);
            v6:ApplyOnTouched(v107, false, function(_, v109) --[[ Line: 635 ]]
                -- upvalues: v8 (ref), v104 (copy)
                local l_Parent_1 = v109.Parent;
                local l_Humanoid_0 = l_Parent_1:FindFirstChild("Humanoid");
                if l_Humanoid_0 and l_Humanoid_0.Health > 0 and l_Parent_1:IsDescendantOf(workspace.Players) and tostring(l_Parent_1.Parent) ~= "Killers" then
                    v8:ApplyStatus(l_Parent_1, "Corrupted", {
                        Duration = 3, 
                        Level = 2, 
                        Killer = v104
                    });
                end;
            end);
        end;
        v104.CurrentSpikes = {};
        v104.FootprintRewardDebounce = {};
        local v112 = false;
        v104.Rig:GetAttributeChangedSignal("Stunned"):Connect(function() --[[ Line: 648 ]]
            -- upvalues: v104 (copy), v112 (ref)
            if v104.Rig:GetAttribute("Stunned") and v104.Config.StunDuration and v104.CurrentAbility and not v112 then
                v112 = true;
                local l_CurrentAbility_0 = v104.CurrentAbility;
                local v114 = v104.Config[l_CurrentAbility_0 .. "Cooldown"];
                if v114 then
                    v104:SetCooldownOf(l_CurrentAbility_0, (math.max(v114 * 0.5, 0)));
                end;
                task.delay(1, function() --[[ Line: 657 ]]
                    -- upvalues: v112 (ref)
                    v112 = false;
                end);
            end;
        end);
        local l_l_Folder_0_Children_0 = l_Folder_0:GetChildren();
        local v116 = 0;
        local v117 = 0;
        local v118 = 0;
        local v119 = nil;
        v119 = game["Run Service"].Heartbeat:Connect(function(v120) --[[ Line: 670 ]]
            -- upvalues: v104 (copy), l_Folder_0 (copy), v119 (ref), v118 (ref), l_Players_0 (ref), v8 (ref), v117 (ref), l_l_Folder_0_Children_0 (copy), v116 (ref)
            if not v104 or not v104.Rig.Parent or not v104.Rig.PrimaryPart then
                l_Folder_0:Destroy();
                v119:Disconnect();
                v119 = nil;
                return;
            else
                if v118 > 1 and #v104.CurrentSpikes > 0 then
                    v118 = 0;
                    local v121 = RaycastParams.new();
                    v121.FilterDescendantsInstances = v104.CurrentSpikes;
                    v121.FilterType = Enum.RaycastFilterType.Include;
                    for _, v123 in (l_Players_0:GetPlayers()) do
                        local l_Character_0 = v123.Character;
                        if l_Character_0 and l_Character_0.Parent then
                            if not l_Character_0 or not l_Character_0.Parent or l_Character_0.Parent.Name == "Killers" then

                            end;
                            local l_Humanoid_1 = l_Character_0:FindFirstChildOfClass("Humanoid");
                            if l_Humanoid_1 or l_Humanoid_1.Health <= 0 then
                                local l_PrimaryPart_0 = l_Character_0.PrimaryPart;
                                local v127 = workspace:Raycast(l_PrimaryPart_0.Position, Vector3.new(0, -5, 0, 0), v121);
                                local v128 = v127 and v127.Instance;
                                if v127 and v128 then
                                    local v129 = v128.Position.Y + v128.Size.Y / 2;
                                    local v130 = RaycastParams.new();
                                    v130.FilterDescendantsInstances = {
                                        l_Character_0, 
                                        v104.CurrentSpikes
                                    };
                                    v130.FilterType = Enum.RaycastFilterType.Exclude;
                                    local v131 = workspace:Raycast(l_PrimaryPart_0.Position, Vector3.new(0, -10, 0, 0), v130);
                                    if v131 then
                                        if v129 - v131.Position.Y >= 1.5 then
                                            v8:ApplyStatus(v123, "Corrupted", {
                                                Level = 2, 
                                                Duration = 5, 
                                                Killer = v104
                                            });
                                        end;
                                    else
                                        v8:ApplyStatus(v123, "Corrupted", {
                                            Level = 2, 
                                            Duration = 5, 
                                            Killer = v104
                                        });
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;
                v118 = v118 + v120;
                if v117 <= 0.05 then
                    v117 = v117 + v120;
                    return;
                else
                    v117 = 0;
                    local v132 = l_l_Folder_0_Children_0[v116 % #l_l_Folder_0_Children_0 + 1];
                    local v133 = l_l_Folder_0_Children_0[(v116 - 1) % #l_l_Folder_0_Children_0 + 1];
                    if v132 and v133 then
                        if v132.Size.Z <= 4 or v132:GetAttribute("FinishedUpdating") then
                            if v132:GetAttribute("FinishedUpdating") then
                                v132:SetAttribute("FinishedUpdating", nil);
                            end;
                            local v134 = RigAlignment.TrailPoint(v104,false);
                            local l_Position_3 = v133:GetPivot().Position;
                            local l_Rotation_0 = CFrame.lookAt(l_Position_3, v134).Rotation;
                            if l_Rotation_0 ~= l_Rotation_0 then
                                warn("currentTrailRotation is NaN, setting rotation to root rotation as fallback");
                                l_Rotation_0 = v104.Rig.PrimaryPart.CFrame.Rotation;
                            end;
                            v132.CFrame = CFrame.new(v133:GetPivot().Position) * l_Rotation_0 * CFrame.Angles(0, 0, 0);
                            v132.Size = Vector3.new(v132.Size.X, v132.Size.Y, (v132.Position - v134).Magnitude);
                            v132.PivotOffset = CFrame.new(0, 0, -v132.Size.Z / 2);
                            v132.CFrame = v132.CFrame * v132.PivotOffset;
                            return;
                        else
                            v132:SetAttribute("FinishedUpdating", true);
                            v116 = v116 + 1;
                            return;
                        end;
                    else
                        v116 = v116 + 1;
                        return;
                    end;
                end;
            end;
        end);
        return;
    else
        if game["Run Service"]:IsClient() then
            v104.ActiveSpikeModels = {};
            if game.Players.LocalPlayer==v104.Player and RigAlignment.IsUpdated(v104.Rig) then
                v104.JohnDoeRigCameraOffset=v6:CreateCameraOffset(v104.Rig,Vector3.new(0,.25,0),"JohnDoeDefault");
            end;
            v9:SetConnection(("%*JDPuddleEffect"):format(v104.Player.Name), "REMOTE_EVENT", function() --[[ Line: 776 ]]
                -- upvalues: v5 (ref), v104 (copy)
                v5:Play(v104.Config.Sounds.PuddleStepped);
            end);
            v9:SetConnection(("%*SpawnSpike"):format(v104.Player.Name), "REMOTE_EVENT", function(v137) --[[ Line: 780 ]]
                -- upvalues: v104 (copy), l_TweenService_0 (ref), v5 (ref)
                local v138 = v104.Config.Spike:Clone();
                local l_Y_0 = v104.Config.SpikeHitboxSize.Y;
                local v140 = Vector3.new(v137.Position.X, v137.Position.Y, v137.Position.Z);
                v138:PivotTo(CFrame.new(v140) * CFrame.Angles(3.141592653589793, math.rad(v137.Rotation), 0) - Vector3.new(0, l_Y_0, 0));
                v138.Parent = workspace.Map.Ingame;
                for _, v142 in (v138:GetDescendants()) do
                    if v142:IsA("BasePart") then
                        v142.CanCollide = false;
                        v142.CanQuery = false;
                        v142.CanTouch = false;
                    end;
                end;
                for _, v144 in (v138:GetDescendants()) do
                    if v144:IsA("ParticleEmitter") and v144.Name == "Number" then
                        v144.Color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0, v104.Config.SpikeNumbersColor), 
                            ColorSequenceKeypoint.new(1, v104.Config.SpikeNumbersColor)
                        });
                    end;
                end;
                l_TweenService_0:Create(v138.PrimaryPart, TweenInfo.new(0.1), {
                    CFrame = v138.PrimaryPart.CFrame + Vector3.new(0, l_Y_0, 0)
                }):Play();
                task.delay(v104.Config.SpikeLifetime, function() --[[ Line: 815 ]]
                    -- upvalues: v138 (copy)
                    if v138.Parent and v138.PrimaryPart then
                        game.Debris:AddItem(v138, 1.5);
                    end;
                end);
                v5:Play(v104.Config.Sounds.CorruptEnergySummon, {
                    Parent = v138.PrimaryPart, 
                    PlaybackSpeed = Random.new():NextNumber(0.8, 1.2), 
                    Volume = 0.25, 
                    TimePosition = 0.02
                });
                v104.ActiveSpikeModels[v137.SpikeUUID] = v138;
            end);
            v9:SetConnection(("%*DesummonSpike"):format(v104.Player.Name), "REMOTE_EVENT", function(v145) --[[ Line: 825 ]]
                -- upvalues: v104 (copy), l_TweenService_0 (ref), v5 (ref)
                local v146 = v104.ActiveSpikeModels[v145];
                if not v146 then
                    return;
                else
                    local l_Y_1 = v104.Config.SpikeHitboxSize.Y;
                    l_TweenService_0:Create(v146.PrimaryPart, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                        CFrame = v146.PrimaryPart.CFrame - Vector3.new(0, l_Y_1 * 2, 0)
                    }):Play();
                    v5:Play(v104.Config.Sounds.CorruptEnergyDesummon, {
                        Parent = v146.PrimaryPart, 
                        PlaybackSpeed = Random.new():NextNumber(0.9, 1.1), 
                        Volume = 0.1, 
                        TimePosition = 0.02
                    });
                    game.Debris:AddItem(v146, 1);
                    v104.ActiveSpikeModels[v145] = nil;
                    return;
                end;
            end);
            v9:SetConnection(("%*OnPuddleRevealed"):format(v104.Player.Name), "REMOTE_EVENT", function(v148) --[[ Line: 848 ]]
                -- upvalues: v16 (ref), v104 (copy)
                local l_PlayerSettings_0 = require(game.ReplicatedStorage.Initializer).PlayerSettings;
                if l_PlayerSettings_0.EpilepsyMode and l_PlayerSettings_0.EpilepsyMode.Value then
                    for _, v151 in (v148:GetDescendants()) do
                        if v151:IsA("ParticleEmitter") and v151:GetAttribute("IsEpilepsy") then
                            v151.Enabled = false;
                        end;
                    end;
                    v16("OnPuddleEpilepsy", ("%*/OnPuddleEpilepsy"):format(script.Parent), v104, v148);
                end;
            end);
            if game.Players.LocalPlayer == v104.Player then
                local v152 = v104.Config.SilencedTag or "JaneDoeSilenced";
                v104.Silencers = {};
                local function v156(v153) --[[ Line: 874 ]] --[[ Name: myWife ]]
                    -- upvalues: v104 (copy)
                    local v154 = v153:WaitForChild("Head", 4);
                    if not v154 or not v104 or not v104.SilencedConnection then
                        return;
                    else
                        local v155 = v104.Config.SilencedTemplate:Clone();
                        v155.Parent = v153;
                        v155.Weld.Part0 = v154;
                        table.insert(v104.Silencers, v155);
                        return;
                    end;
                end;
                v104.SilencedConnection = game.CollectionService:GetInstanceAddedSignal(v152):Connect(v156);
                for _, v158 in ipairs(workspace.Players.Survivors:GetChildren()) do
                    if v158:HasTag(v152) then
                        task.spawn(v156, v158);
                    end;
                end;
            end;
        end;
        return;
    end;
end;
v1.Destroyed = function(v159, v160) --[[ Line: 897 ]] --[[ Name: Destroyed ]]
    if v160.JohnDoeRigCameraOffset then v160.JohnDoeRigCameraOffset:Destroy();v160.JohnDoeRigCameraOffset=nil end;
    -- upvalues: v9 (copy)
    for _, v162 in v159.Connections do
        v162:Disconnect();
        v162 = nil;
    end;
    if game["Run Service"]:IsServer() then
        for _, v164 in v160.CurrentSpikes do
            v164:Destroy();
        end;
        return;
    else
        if game["Run Service"]:IsClient() then
            v9:RemoveConnection(("%*JDPuddleEffect"):format(v160.Player.Name), "REMOTE_EVENT");
            v9:RemoveConnection(("%*SpawnSpike"):format(v160.Player.Name), "REMOTE_EVENT");
            v9:RemoveConnection(("%*DesummonSpike"):format(v160.Player.Name), "REMOTE_EVENT");
            if v160.SilencedConnection then
                v160.SilencedConnection:Disconnect();
                local l_ipairs_0 = ipairs;
                local v166 = v160.Silencers or {};
                for _, v168 in l_ipairs_0(v166) do
                    v168:Destroy();
                end;
            end;
        end;
        return;
    end;
end;
v1.OnIntroduction = function(_, v170, v171, v172) --[[ Line: 923 ]] --[[ Name: OnIntroduction ]]
    -- upvalues: v6 (copy)
    local v173 = nil;
    if v170.Config.useClouds == true then
        v173 = Instance.new("Clouds");
        v173.Cover = 0.774;
        v173.Density = 1;
        v173.Color = Color3.fromRGB(25, 25, 25);
        v173.Parent = workspace:FindFirstChild("Terrain");
        game.Debris:AddItem(v173, v172);
    end;
    local v174 = script.IntroScreen:Clone();
    v174.Main.Title.Text = v170.Config.IntroText:gsub("PLAYERNAME", v170.Player.DisplayName);
    v174.Parent = game.Players.LocalPlayer.PlayerGui;
    game.Debris:AddItem(v174, 1.93333);
    game.TweenService:Create(v174.Main.Title, TweenInfo.new(0.83), {
        TextTransparency = 0
    }):Play();
    task.delay(0.83, function() --[[ Line: 948 ]]
        -- upvalues: v174 (copy), v170 (copy)
        game.TweenService:Create(v174.Main.Title, TweenInfo.new(0.583), {
            TextColor3 = v170.Config.IntroTextColor or Color3.new(1, 0, 0)
        }):Play();
    end);
    task.delay(1, function() --[[ Line: 953 ]]
        -- upvalues: v171 (copy)
        local l_JohnDoeTrail_0 = v171:FindFirstChild("JohnDoeTrail");
        if l_JohnDoeTrail_0 then
            l_JohnDoeTrail_0:Destroy();
        end;
    end);
    local v176 = require(game.ReplicatedStorage.Modules.Schematics.Lighting);
    v176:SetCustomLighting(v170.Config.IntroLighting);
    task.delay(2.717, function() --[[ Line: 963 ]]
        -- upvalues: v173 (ref), v170 (copy)
        if v173 then
            v173.Color = Color3.fromRGB(25, 0, 0);
        end;
        local l_AtmosphereDoe_0 = game.Lighting:FindFirstChild("AtmosphereDoe");
        if l_AtmosphereDoe_0 then
            game.TweenService:Create(l_AtmosphereDoe_0, TweenInfo.new(0.2829, Enum.EasingStyle.Linear), {
                Color = v170.Config.AtmosphereColor or Color3.fromRGB(144, 0, 0), 
                Decay = v170.Config.AtmosphereDecay or Color3.fromRGB(255, 0, 0), 
                Density = 1
            }):Play();
        end;
    end);
    local l_v6_FOVMultiplier_1 = v6:CreateFOVMultiplier(game.Players.LocalPlayer, 0.35, "JohnDoeIntroScene");
    task.delay(2.75, function() --[[ Line: 979 ]]
        -- upvalues: l_v6_FOVMultiplier_1 (copy)
        game.TweenService:Create(l_v6_FOVMultiplier_1, TweenInfo.new(0.25), {
            Value = 0.95
        }):Play();
    end);
    task.delay(v172, function() --[[ Line: 984 ]]
        -- upvalues: v176 (copy), l_v6_FOVMultiplier_1 (copy), v174 (copy), v173 (ref)
        v176:SetAsCurrentLighting();
        l_v6_FOVMultiplier_1:Destroy();
        v174:Destroy();
        if v173 then
            v173:Destroy();
        end;
    end);
end;
v1.OnVictory = function(_, v180, v181, _, _) --[[ Line: 994 ]] --[[ Name: OnVictory ]]
    -- upvalues: v6 (copy), l_TweenService_0 (copy)
    local v184 = require(game.ReplicatedStorage.Modules.Schematics.Lighting);
    if v180 == "Start" then
        v184:SetCustomLighting(v181.Config.IntroLighting);
        local l_v6_FOVMultiplier_2 = v6:CreateFOVMultiplier(game.Players.LocalPlayer, 1.1325, "JohnDoeOutroScene");
        game.Debris:AddItem(l_v6_FOVMultiplier_2, 30);
        task.spawn(function() --[[ Line: 1005 ]]
            -- upvalues: v181 (copy), v6 (ref)
            local v186 = os.clock();
            local v187 = workspace.Misc:WaitForChild("KillerCutsceneBackground", 5);
            if v187 and v187.PrimaryPart then
                local v188 = v181.Config.OutroDummy:Clone();
                v188.Name = "OutroVictim";
                v188.PrimaryPart.Anchored = true;
                v188:SetPrimaryPartCFrame(v187.PrimaryPart.CFrame);
                v188.Parent = v187;
                local v189 = v6:LoadAnimationFromID(v188, "rbxassetid://135006397147596", true);
                v189:Play(0);
                v189.TimePosition = os.clock() - v186;
                v189.Stopped:Once(function() --[[ Line: 1020 ]]
                    -- upvalues: v188 (copy)
                    for _, v191 in ipairs(v188:GetDescendants()) do
                        if v191:IsA("BasePart") then
                            v191.Anchored = true;
                        end;
                    end;
                end);
                local v192 = false;
                for _, v194 in ipairs({
                    "Shirt", 
                    "Pants", 
                    "Accessory", 
                    "Hat"
                }) do
                    if v188:FindFirstChildOfClass(v194) then
                        v192 = true;
                        break;
                    end;
                end;
                if not v192 then
                    pcall(function() --[[ Line: 1033 ]]
                        -- upvalues: v181 (ref), v188 (copy)
                        local l_HumanoidDescriptionFromUserId_0 = game.Players:GetHumanoidDescriptionFromUserId(v181.Player.UserId);
                        v188.Humanoid:ApplyDescription(l_HumanoidDescriptionFromUserId_0, Enum.AssetTypeVerification.Always);
                    end);
                end;
            end;
        end);
        task.delay(2.4, function() --[[ Line: 1042 ]]
            -- upvalues: l_TweenService_0 (ref), v181 (copy)
            local v196 = Instance.new("ColorCorrectionEffect", game.Lighting);
            v196.Name = "JohnDoeStabCC";
            local v197 = l_TweenService_0:Create(v196, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
                Contrast = 0.4, 
                Brightness = 0.1
            });
            v197:Play();
            task.wait(0.4);
            v197:Pause();
            v196.Brightness = 0.8;
            v196.Contrast = 0.3;
            v196.TintColor = v181.Config.OutroTintColor or Color3.new(0.631373, 0.0784314, 0.0901961);
            l_TweenService_0:Create(v196, TweenInfo.new(2.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
                TintColor = Color3.new(0.196078, 0.196078, 0.196078), 
                Brightness = -1, 
                Contrast = -0.5, 
                Saturation = -1
            }):Play();
        end);
        return;
    else
        if v180 == "End" then
            v184:SetAsCurrentLighting();
            local l_v6_FOVMultiplier_3 = v6:CreateFOVMultiplier(game.Players.LocalPlayer, 1, "JohnDoeOutroScene");
            game.Debris:AddItem(l_v6_FOVMultiplier_3, 1);
            local v199 = game.Lighting:WaitForChild("JohnDoeStabCC", 8);
            if v199 then
                v199:Destroy();
            end;
        end;
        return;
    end;
end;
v1.OnExecution = function(_, v201, v202) --[[ Line: 1106 ]] --[[ Name: OnExecution ]]
    local l_Humanoid_2 = v202:FindFirstChild("Humanoid");
    local v204 = require(game.ReplicatedStorage.Modules.Ragdolls);
    local v205 = (v201.Rig.PrimaryPart.CFrame.LookVector + Vector3.new(0, 0.5, 0, 0)) * 40;
    local l_Axe_0 = v202:FindFirstChild("Axe");
    local l_BackAxe_0 = v202:FindFirstChild("BackAxe");
    if v202.Name == "JaneDoe" then
        l_Axe_0.Transparency = 0;
        l_BackAxe_0.Transparency = 1;
        task.delay(2.85, function() --[[ Line: 1118 ]]
            -- upvalues: v204 (copy), v202 (copy), v205 (copy), l_Humanoid_2 (copy)
            v204.AddProfile(v202, {
                Velocity = v205, 
                KillEffects = {
                    Explode = true
                }
            });
            if l_Humanoid_2 then
                l_Humanoid_2.BreakJointsOnDeath = true;
                l_Humanoid_2.Health = 0;
            end;
        end);
        return;
    else
        task.delay(0.666, function() --[[ Line: 1128 ]]
            -- upvalues: v204 (copy), v202 (copy), v205 (copy)
            v204.AddProfile(v202, {
                AnchorDelay = true, 
                Applied = os.clock() + 5, 
                Velocity = v205
            });
            local l_Humanoid_3 = v202:FindFirstChild("Humanoid");
            if l_Humanoid_3 then
                l_Humanoid_3.BreakJointsOnDeath = false;
                l_Humanoid_3.Health = 0;
            end;
        end);
        task.delay(1.98, function() --[[ Line: 1137 ]]
            -- upvalues: v202 (copy)
            if v202 and v202.PrimaryPart then
                v202.PrimaryPart.Anchored = false;
            end;
        end);
        return;
    end;
end;
local previousCreated=v1.Created
local previousDestroyed=v1.Destroyed
v1.Created=function(self,actor)
 previousCreated(self,actor)
 CorruptEnergyController.Created(actor)
end
v1.Destroyed=function(self,actor)
 CorruptEnergyController.Destroyed(actor)
 previousDestroyed(self,actor)
end
return v1;]========],before="57213:cadc9c23:8794a5b8",after="44564:ac97cd7c:af3f452f"},
{path=[========[
ServerStorage/Assets/Killers/JohnDoe/Behavior/CorruptEnergyController]========],source=[========[
return require(game:GetService("RunService"):IsServer() and script.Server or script.Client)
]========],before=false,after="92:f405154b:700565ec"},
{path=[========[
ServerStorage/Assets/Killers/JohnDoe/Behavior/CorruptEnergyController/Client]========],source=[========[
local RunService=game:GetService("RunService")
local Players=game:GetService("Players")
local Util=require(game.ReplicatedStorage.Modules.Util)
local Client={}
function Client.CanRetract(a) return a.Rig and a.Rig:GetAttribute("JDCanRetract")==true end
local function update(a)
 local ability=a.Behavior.Abilities.CorruptEnergy
 local retract=Client.CanRetract(a)
 ability.Name=retract and "Retract" or "Corrupt Energy"
 ability.Icon=retract and "rbxassetid://105853980040304" or "rbxassetid://83849304758564"
 -- FCT keeps counting the original cooldown; only its rendering is suppressed while Retract is available.
 ability.Disabled=retract or a.JDCEOriginalDisabled
 local main=a.Player:FindFirstChildOfClass("PlayerGui")
 main=main and main:FindFirstChild("MainUI")
 local hotbar=main and main:FindFirstChild("AbilityContainer")
 local button=hotbar and hotbar:FindFirstChild("CorruptEnergy")
 if retract and button then
  button.Image=ability.Icon
  if button:FindFirstChild("AbilityName") then button.AbilityName.Text=ability.Name end
  if button:FindFirstChild("CooldownTime") then button.CooldownTime.Text="" end
  if button:FindFirstChild("Clipping") then
   button.Clipping.Size=UDim2.fromScale(1,1)
   button.Clipping.Top.Size=UDim2.fromScale(1,1);button.Clipping.Top.Image=ability.Icon
  end
 end
end
local function windup(a)
 local state=a.JDCEClientWindup
 if not state then return end
 local times={1.067,1.917}
 while state.next<=#times and os.clock()-state.started>=times[state.next] do
  local stage=state.next;state.next+=1
  pcall(Util.ApplyCameraShake,Util,stage*.2,stage*.35)
 end
 if state.next>#times then a.JDCEClientWindup=nil end
end
function Client.Play(a,data)
 if data and data.Retract then return end
 a.JDCEClientWindup={started=os.clock(),next=1}
 local animation=a.Animations and a.Animations.CorruptEnergy
 if animation then pcall(function()animation:Play(.025)end) end
end
function Client.Created(a)
 if a.Player~=Players.LocalPlayer then return end
 a.JDCEClientConnections={};a.JDCEOriginalDisabled=a.Behavior.Abilities.CorruptEnergy.Disabled
  a.JDCEClientConnections[1]=a.Rig:GetAttributeChangedSignal("JDCanRetract"):Connect(function()update(a)end)
 a.JDCEClientConnections[2]=RunService.RenderStepped:Connect(function()update(a);windup(a)end)
 a.JDCEClientConnections[3]=a.Rig:GetAttributeChangedSignal("Stunned"):Connect(function()
  if a.Rig:GetAttribute("Stunned") then
   a.JDCEClientWindup=nil
   local track=a.Animations and a.Animations.CorruptEnergy
   if track then pcall(function()track:Stop(.05)end) end
  end
 end)
 update(a)
end
function Client.Destroyed(a)
 a.JDCEClientWindup=nil
 for _,model in pairs(a.ActiveSpikeModels or {}) do model:Destroy() end
 a.ActiveSpikeModels={}
 for _,connection in ipairs(a.JDCEClientConnections or {}) do connection:Disconnect() end
 a.JDCEClientConnections={}
 if a.Behavior and a.Behavior.Abilities and a.Behavior.Abilities.CorruptEnergy then
  local ability=a.Behavior.Abilities.CorruptEnergy;ability.Disabled=a.JDCEOriginalDisabled;ability.Name="Corrupt Energy";ability.Icon="rbxassetid://83849304758564"
 end
end
return Client
]========],before=false,after="3121:bbcdd708:c2fc4305"},
{path=[========[
ServerStorage/Assets/Killers/JohnDoe/Behavior/CorruptEnergyController/Rules]========],source=[========[
local Rules={}
function Rules.ReserveHit(cast,target,cap)
 if not cast.active then return false end
 local hits=cast.hits[target] or 0
 if hits>=cap then return false end
 cast.hits[target]=hits+1
 return true
end
function Rules.SpawnAt(index,interval) return 2+index*interval end
return Rules
]========],before=false,after="294:470d2a86:a17a5ae1"},
{path=[========[
ServerStorage/Assets/Killers/JohnDoe/Behavior/CorruptEnergyController/Server]========],source=[========[
local RunService=game:GetService("RunService")
local TweenService=game:GetService("TweenService")
local Debris=game:GetService("Debris")
local Modules=game.ReplicatedStorage.Modules
local Hitboxes=require(Modules.Hitboxes)
local Network=require(Modules.Network)
local Util=require(Modules.Util)
local Sounds=require(Modules.Sounds)
local Statuses=require(Modules.Statuses)
local Actors=require(Modules.Actors)
local Rules=require(script.Parent.Rules)
local Server={}
local function alive(a)
 local hum=a.Rig and a.Rig:FindFirstChildOfClass("Humanoid")
 return not a.JDCEDestroyed and a.Rig and a.Rig.Parent and a.Rig.PrimaryPart and hum and hum.Health>0
end
local function blocked(a)
 local r=a.Rig
 return r:GetAttribute("Stunned") or r:GetAttribute("Helpless") or r:GetAttribute("Ragdolling") or r:GetAttribute("AbilitiesDisabled") or r.PrimaryPart.Anchored
end
local function broadcast(a,kind,data)
 Network:FireAllClientConnection(a.Player.Name..kind,"REMOTE_EVENT",data)
end
local function sound(a,name,parent)
 local id=a.Config.Sounds and a.Config.Sounds[name]
 if id and parent then pcall(Sounds.Play,Sounds,id,{Parent=parent,Volume=.4}) end
end
function Server.CanRetract(a)
 local c=a.JDCECast
 return c and c.active and not c.casting and c.live>0 or false
end
local function refresh(a)
 if a.Rig and a.Rig.Parent then a.Rig:SetAttribute("JDCanRetract",Server.CanRetract(a)) end
end
local function release(a,c)
 if not c.casting then return end
 c.casting=false
 if c.slow then c.slow:Destroy();c.slow=nil end
 a.AbilityDisablers.JohnCorruptEnergy=nil
 if a.CurrentAbility=="CorruptEnergy" then a.CurrentAbility=nil;a.Config.StunDuration=c.previousStunDuration end
 refresh(a)
end
local function removeSpike(a,c,s,immediate)
 if not s.live then return end
 s.live=false;c.live-=1
 if s.hitbox and s.hitbox.Cancel then s.hitbox:Cancel() end
 if s.rise then s.rise:Cancel() end
 local index=table.find(a.CurrentSpikes,s.part)
 if index then table.remove(a.CurrentSpikes,index) end
 broadcast(a,"DesummonSpike",s.id)
 if s.part.Parent then
  s.part.CanCollide=false;s.part.CanTouch=false
  if immediate then s.part:Destroy()
  else
   TweenService:Create(s.part,TweenInfo.new(1,Enum.EasingStyle.Quad,Enum.EasingDirection.In),{CFrame=s.part.CFrame-Vector3.new(0,a.Config.SpikeHitboxSize.Y*2,0)}):Play()
   Debris:AddItem(s.part,1.05)
  end
 end
 refresh(a)
end
local function clear(a,immediate)
 local c=a.JDCECast
 if not c then return end
 c.active=false;release(a,c)
 for _,s in ipairs(c.spikes) do removeSpike(a,c,s,immediate) end
 a.JDCECast=nil;refresh(a)
end
local function reward(a,target)
 local hum=target:FindFirstChildOfClass("Humanoid")
 if not hum then return end
 if hum.Health>0 then
  Util:CreateSpeedMultiplier(target,1.5,"HitSpeedBonus",1.25)
  Statuses:ApplyStatus(a.Rig,"Speed",{Level=1,Duration=7})
  Util:RevealPlayerAuraTo(a.Player,target,2.5)
 end
 if target.Parent and target.Parent.Name=="Survivors" then
  Actors:IncrementActorStats(a.Player,{Action=hum.Health<=0 and "Killed a Survivor with Corrupt Energy" or "Damaged a Survivor with Corrupt Energy",RewardType=hum.Health<=0 and "DifficultKillerAction" or "EasyKillerAction"})
 end
 if hum.Health<=0 then
  local achievement=require(Modules.AchievementUtil)
  achievement:IncrementAchievementProgress(a.Player,"JohnDoeSpikes")
 end
end
local function spawnSpike(a,c,index,now)
 if not c.active or c.interrupted or not alive(a) then return end
 local params=RaycastParams.new();params.FilterType=Enum.RaycastFilterType.Exclude;params.FilterDescendantsInstances={workspace.Players}
 local point=(a:GetPivot()*CFrame.new(0,0,-a.Config.DistanceBetweenSpikes*index)).Position
 local hit=workspace:Raycast(point,Vector3.new(0,-100,0),params) or workspace:Raycast(point,Vector3.new(0,100,0),params)
 if not hit then return end
 local size=a.Config.SpikeHitboxSize
 local rotation=math.random(0,360)
 local data={Position=hit.Position,Rotation=rotation,SpikeUUID=tostring(c.serial)..":"..index}
 local part=Instance.new("Part");part.Name="SpikeCollision";part.Size=size;part.Transparency=1
 part.Anchored=true;part.CanTouch=false;part.CanCollide=true;part.CustomPhysicalProperties=a.Config.SpikeProperties
 local from=CFrame.new(hit.Position)*CFrame.Angles(0,math.rad(rotation),math.pi/2)-Vector3.new(0,size.Y,0)
 part.CFrame=from;part.Parent=workspace.Map.Ingame
 local s={part=part,id=data.SpikeUUID,live=true,expires=now+a.Config.SpikeLifetime}
 table.insert(c.spikes,s);table.insert(a.CurrentSpikes,part);c.live+=1
 s.rise=TweenService:Create(part,TweenInfo.new(.1,Enum.EasingStyle.Linear),{CFrame=from+Vector3.new(0,size.Y*2,0)})
 s.rise:Play();broadcast(a,"SpawnSpike",data)
 s.hitbox=Hitboxes:CreateHitbox(a.Player,{
  AbilityType="CorruptEnergy",IsProjectile=false,Size=size,CFrame=function()return part.CFrame end,
  Damage=a.Config.CorruptEnergyDamage,Time=.15,Knockback=5,HitMultiple=true,PredictVelocity=false,CastPoint=false,
  -- Reject before damage, block reactions, knockback, or hit callbacks. Reservation is atomic across spikes.
  HitFilter=function(target)
   return s.live and alive(a) and Rules.ReserveHit(c,target,a.Config.SpikeHitCap)
  end,
  Connections={Hit=function(target,first)
   reward(a,target)
   if first then sound(a,"Hit",a.Rig.PrimaryPart) end
  end}
 })
 refresh(a)
end
local function step(a)
 if not alive(a) then Server.Destroyed(a);return end
 local c=a.JDCECast
 if not c then return end
 local now=os.clock()
 if c.casting then
  if blocked(a) then c.interrupted=true;release(a,c)
  else
   while c.next<=a.Config.SpikeAmount and now-c.started>=Rules.SpawnAt(c.next,a.Config.DelayBetweenSpikeSummons) do
    local index=c.next;c.next+=1;spawnSpike(a,c,index,now)
   end
   if now-c.started>=math.max(3.5,Rules.SpawnAt(a.Config.SpikeAmount,a.Config.DelayBetweenSpikeSummons)+.1) then release(a,c) end
  end
 end
 for _,s in ipairs(c.spikes) do if s.live and (not s.part.Parent or now>=s.expires) then removeSpike(a,c,s,not s.part.Parent) end end
 if not c.casting and c.live==0 then c.active=false;a.JDCECast=nil;refresh(a) end
end
function Server.Cast(a)
 if not alive(a) or blocked(a) then return {Cancelled=true} end
 if Server.CanRetract(a) then clear(a,false);return {Retract=true} end
 if a.JDCECast and a.JDCECast.casting then return {Cancelled=true} end
 clear(a,true)
 a.JDCESerial=(a.JDCESerial or 0)+1
 local c={serial=a.JDCESerial,active=true,casting=true,started=os.clock(),next=1,live=0,spikes={},hits={},previousStunDuration=a.Config.StunDuration}
 a.JDCECast=c;a.AbilityDisablers=a.AbilityDisablers or {};a.AbilityDisablers.JohnCorruptEnergy=true
 a.CurrentAbility="CorruptEnergy";a.Config.StunDuration=a.Config.UnstoppableDuration
 c.slow=Util:CreateSpeedMultiplier(a.Player,.001,"JohnCorruptEnergyCast")
 sound(a,"CorruptEnergy",a.Rig.PrimaryPart);refresh(a)
 return {Retract=false}
end
function Server.Created(a)
 a.JDCEDestroyed=false;a.JDCEConnections={};a.CurrentSpikes=a.CurrentSpikes or {}
 local original=a.CanUseAbility;a.JDCEOriginalCanUse=original
 local function canUse(self,name)
  if name~="CorruptEnergy" or not Server.CanRetract(a) then return original(self,name) end
  -- Keep every ordinary lock/check; bypass only this actor's existing CE cooldown for Retract.
  local cooldown=a.Cooldowns.CorruptEnergy;a.Cooldowns.CorruptEnergy=nil
  local ok,result=pcall(original,self,name)
  a.Cooldowns.CorruptEnergy=cooldown
  if not ok then error(result) end
  return result
 end
 a.CanUseAbility=canUse;a.JDCECanUseWrapper=canUse
 table.insert(a.JDCEConnections,RunService.Heartbeat:Connect(function()step(a)end))
 table.insert(a.JDCEConnections,a.Rig:GetAttributeChangedSignal("Stunned"):Connect(function()
  if a.Rig:GetAttribute("Stunned") and a.JDCECast and a.JDCECast.casting then a.JDCECast.interrupted=true;release(a,a.JDCECast) end
 end))
 table.insert(a.JDCEConnections,a.Rig:FindFirstChildOfClass("Humanoid").Died:Connect(function()Server.Destroyed(a)end))
 refresh(a)
end
function Server.Destroyed(a)
 if a.JDCEDestroyed then return end
 a.JDCEDestroyed=true;clear(a,true)
 for _,connection in ipairs(a.JDCEConnections or {}) do connection:Disconnect() end
 a.JDCEConnections={}
 if a.CanUseAbility==a.JDCECanUseWrapper then a.CanUseAbility=a.JDCEOriginalCanUse end
end
return Server
]========],before=false,after="8245:ae90ee42:a8b0ecab"},
{path=[========[
ServerStorage/Assets/Killers/JohnDoe/Config]========],source=[========[
-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local l_workspace_Attribute_0 = workspace:GetAttribute("JohnDoeSpecialDay");
local v1 = {
    DisplayName = "John Doe", 
    Quote = l_workspace_Attribute_0 and "dude i told you not to play on march 18th" or "DON'T PLAY ROBLOX ON MARCH 18TH?!?!", 
    Credits = "c2o, BakedMesh, koekonaut, 89M and BirdieCandles", 
    RenderImage = l_workspace_Attribute_0 and "rbxassetid://125927083463034" or "rbxassetid://106220250803658", 
    Price = l_workspace_Attribute_0 and 318 or 1000, 
    Health = l_workspace_Attribute_0 and 3182026 or 1500, 
    Speed = l_workspace_Attribute_0 and 11.3182026 or 9, 
    IntroText = "They're all yours, Mr. Doe", 
    SprintSpeed = l_workspace_Attribute_0 and 27.53182026 or 27.25, 
    StaminaLoss = 9.5, 
    StaminaGain = 21, 
    MaxStamina = l_workspace_Attribute_0 and 115.3182026 or 110, 
    SlashDamage = l_workspace_Attribute_0 and 45.3182026 or 28, 
    SlashCooldown = l_workspace_Attribute_0 and 2.3182026 or 1.75, 
    SlashWindup = 0.4, 
    SlashLinger = 0.25, 
    CorruptEnergyDamage = l_workspace_Attribute_0 and 16.3182026 or 11, 
    CorruptEnergyCooldown = l_workspace_Attribute_0 and 40.3182026 or 18, 
    SpikeAmount = l_workspace_Attribute_0 and 256 or 31, 
    SpikeHitboxSize = Vector3.new(11, 5, 5, 0), 
    SpikeLifetime = l_workspace_Attribute_0 and 18.3182026 or 14, 
    SpikeHitCap = l_workspace_Attribute_0 and 3182026 or 2, 
    SpikeProperties = PhysicalProperties.new(0.2, 2, 0, 100, 100), 
    DelayBetweenSpikeSummons = l_workspace_Attribute_0 and 0.02 or 0.045, 
    DistanceBetweenSpikes = 4, 
    DigitalFootprintCooldown = 3, 
    DigitalFootprintLimit = l_workspace_Attribute_0 and 4 or 3, 
    ["404ErrorAuraRevealTime"] = l_workspace_Attribute_0 and 10.3182026 or 6, 
    ["404ErrorCooldown"] = 20, 
    Spike = script.Spike, 
    Shadow = script.Shadow, 
    Trail = script.Trail, 
    SpikeNumbersColor = Color3.fromRGB(255, 0, 0), 
    TrailLength = l_workspace_Attribute_0 and 356 or 48, 
    UnstoppableDuration = 2, 
    SilencedTemplate = script.NAN, 
    Silenced = true, 
    OutroDummy = script.OutroVictim, 
    useClouds = true, 
    Relations = {
        "JaneDoe"
    }, 
    LastManStandingEmotionalData = {
        ThemeID = "rbxassetid://90004798416076", 
        RoundTime = 99
    }, 
    LastManStandingData = {
        ThemeID = "rbxassetid://128206924329556", 
        ThemeProperties = {
            Volume = 1.8
        }, 
        RoundTime = 75
    }, 
    Animations = {
        Idle = "rbxassetid://78316360457839", 
        Walk = "rbxassetid://76406790148345", 
        Run = "rbxassetid://75860288793447", 
        InjuredIdle = "rbxassetid://78316360457839", 
        InjuredWalk = "rbxassetid://76406790148345", 
        InjuredRun = "rbxassetid://75860288793447", 
        Stunned = {
            Start = "rbxassetid://138679230786776", 
            Loop = "rbxassetid://70827891324537", 
            End = "rbxassetid://74361242843808", 
            Cancel = "rbxassetid://132248641730444"
        }, 
        Execution = {
            KillerRig = "rbxassetid://83976183793168", 
            PlayerRig = "rbxassetid://128883910284038", 
            PlayerCFrameOffset = CFrame.Angles(0, 3.141592653589793, 0) * CFrame.new(0, 0, 3)
        }, 
        ExecutionJaneDoe = {
            KillerRig = "rbxassetid://113867319138589", 
            PlayerRig = "rbxassetid://110119432571584"
        }, 
        Slash = "rbxassetid://115517017692371", 
        CorruptEnergy = "rbxassetid://98447162219573", 
        DigitalFootprint = "rbxassetid://105781326773024", 
        Introduction = {
            KillerRig = "rbxassetid://119476049603730", 
            CameraRig = "rbxassetid://140634358360682"
        }, 
        Victory = {
            KillerRig = "rbxassetid://103715079223416", 
            CameraRig = "rbxassetid://98794271647444"
        }
    }, 
    Sounds = {
        Ambience = "rbxassetid://94207556272752", 
        Footsteps = {
            "rbxassetid://126872882914955", 
            "rbxassetid://81544212102472"
        }, 
        TerrorRadiusThemes = {
            [60] = {
                ID = "rbxassetid://83774227185202", 
                BPM = 100
            }, 
            [40] = {
                ID = "rbxassetid://112183456126257", 
                BPM = 100
            }, 
            [20] = {
                ID = "rbxassetid://110494241693405", 
                BPM = 100
            }, 
            [6] = {
                ID = "rbxassetid://90755511989120", 
                BPM = 100, 
                Chase = true
            }
        }, 
        Execution = "rbxassetid://91088178573563", 
        ExecutionJaneDoe = "rbxassetid://91273852978167", 
        StunEnded = "rbxassetid://127453218558340", 
        Swing = "rbxassetid://140242176732868", 
        Hit = "rbxassetid://90819435118493", 
        CorruptEnergy = "rbxassetid://122388551068717", 
        CorruptEnergySummon = "rbxassetid://111388466508150", 
        CorruptEnergyDesummon = "rbxassetid://84267936481619", 
        PuddleStepped = "rbxassetid://128240826870706", 
        DigitalFootprint = "rbxassetid://114243439622992", 
        DigitalFootprintAmbience = "rbxassetid://140163779889034", 
        ["404Error"] = "rbxassetid://117888888155052", 
        ["404ErrorError"] = "rbxassetid://113305896012849", 
        Introduction = "rbxassetid://72636140548768", 
        VictoryTheme = "rbxassetid://122795850954647"
    }
};
v1.Information = {
    {
        Separator = "GENERAL INFO"
    }, 
    {
        Header = "JOHN DOE", 
        Text = "The defunct code of the early days of Roblox courses through their body, consuming his mind as he now only focuses on one thing: to kill everyone in his path. An unstoppable force entering the round with a strategical mindset, he's able to set traps, summon walls to back survivors into a corner, and leave behind a faint trail that damages those who step on it.\n"
    }, 
    {
        Header = "STATS", 
        Text = "Difficulty: \226\152\133\226\152\133\226\152\133\226\152\133\226\152\133\n" .. ("Health: %*\n"):format(v1.Health) .. ("Regular Speed: %*\n"):format(v1.Speed) .. ("Sprinting Speed: %*\n"):format(v1.SprintSpeed) .. ("Max Stamina: %*\n"):format(v1.MaxStamina) .. ("Stamina Loss per sec: %*\n"):format(v1.StaminaLoss) .. ("Stamina Gain per sec: %*\n"):format(v1.StaminaGain) .. "Terror Radius: 60 studs\n"
    }, 
    {
        Separator = "PASSIVES"
    }, 
    {
        Header = "NATURAL MALEVOLENCE", 
        Quote = "\"We\226\128\153re dedicated to building a fun, safe environment where kids of all ages can power their imagination on Roblox.\" - Roblox", 
        Text = "For every step that <font color=\"rgb(248,217,109)\">John Doe</font> takes, a trail of corruption follows behind him.\nAny survivor that's unfortunate enough to step within the corruption is given <b>Corrupted II</b> for 3 seconds.\n"
    }, 
    {
        Header = "UNSTOPPABLE", 
        Quote = "\"Consider this myth busted.\" - Roblox", 
        Text = ("<font color=\"rgb(248,217,109)\">John Doe</font> can only be stunned for %*s while casting Corrupt Energy and 404 Error.\n"):format(v1.UnstoppableDuration) .. "Additionally, <font color=\"rgb(248,217,109)\">John Doe</font> will roar and gain <b>Speed I</b> for 3s upon the stun ending. The duration of the speed boost is increased by 1s for every Sentinel Survivor currently alive.\n" .. "The cooldown of the ability that triggered <b>UNSTOPPABLE</b> is reduced by 50%.\n"
    }, 
    {
        Separator = "ABILITIES"
    }, 
    {
        Header = "SLASH", 
        Image = "rbxassetid://92362553672440", 
        Quote = "\"For many years, there has been lore circulating around John Doe and \226\150\136\226\150\136\226\150\136\226\150\136 Doe within the community.\" - Roblox", 
        Text = ("Cooldown: %*s\n"):format(v1.SlashCooldown) .. ("Damage: %*\n"):format(v1.SlashDamage) .. ("Windup: %*s\n"):format(v1.SlashWindup) .. ("Linger: %*s\n"):format(v1.SlashLinger) .. "Length: 7.5 studs\n" .. "<font color=\"rgb(248,217,109)\">John Doe</font> slashes infront of him using his claws.\n"
    }, 
    {
        Header = "CORRUPT ENERGY", 
        Image = "rbxassetid://83849304758564", 
        Quote = "\"This year, we\226\128\153ve decided that it\226\128\153s time to shed some light about these accounts.\" - Roblox", 
        Text = ("Cooldown: %*s\n"):format(v1.CorruptEnergyCooldown) .. ("Damage: %*\n"):format(v1.CorruptEnergyDamage) .. ("<font color=\"rgb(248,217,109)\">John Doe</font> punches his corrupted arm into the ground and, when he pulls it out, %* giant spikes (that last for %*s) emerge infront of him, piercing through any survivor unfortunate enough to be caught within them.\n"):format(v1.SpikeAmount, v1.SpikeLifetime) .. "Hitting a player with a spike gives <font color=\"rgb(248,217,109)\">John Doe</font> Speed I for 7 seconds.\n" .. ("Summoned spikes cannot damage the same target more than %* times.\n"):format(v1.SpikeHitCap) .. "Press Corrupt Energy again after the cast to Retract active spikes early. Retracting does not restart the original cooldown. These spikes can be used as blockades to prevent survivors from accessing certain areas.\n"
    }, 
    {
        Header = "DIGITAL FOOTPRINT", 
        Image = "rbxassetid://83206360003394", 
        Quote = "\"John Doe and \226\150\136\226\150\136\226\150\136\226\150\136 Doe are two of Roblox\226\128\153s earliest accounts, as seen by their low user IDs here.\" - Roblox", 
        Text = ("Cooldown: %*s\n"):format(v1.DigitalFootprintCooldown) .. "<font color=\"rgb(248,217,109)\">John Doe</font> stomps on the ground three times, commanding a shadow to emerge underneath his footsteps as a trap for survivors to walk over.\n" .. "If a survivor steps over the false shadow, then <font color=\"rgb(248,217,109)\">John Doe</font> gets a <b>Speed I</b> buff for 10 seconds and the survivor gets a <b>Corrupted I</b> & <b>Slowness II</b> debuff for 10 seconds.\n" .. "Upon the trap being triggered, <font color=\"rgb(248,217,109)\">John Doe</font> and the survivor who activated it have their auras revealed to each other for 10 seconds.\n" .. "The shadow despawns after contact is made with it or <font color=\"rgb(248,217,109)\">John Doe</font> attempts to place down a fourth shadow.\n" .. ("There can only be <b>%*</b> shadows present at once, and attempting to create more will cause the oldest shadow to dissipate.\n"):format(v1.DigitalFootprintLimit)
    }, 
    {
        Header = "404 ERROR", 
        Image = "rbxassetid://131116145215571", 
        Quote = "\"Authentic John Doe and \226\150\136\226\150\136\226\150\136\226\150\136 Doe accounts pose no danger to your Roblox account.\" - Roblox", 
        Text = ("Cooldown: %*s\n"):format(v1["404ErrorCooldown"]) .. ("<font color=\"rgb(248,217,109)\">John Doe</font>'s corrupted arm pulsates twice, revealing the auras of all living survivors to him for %* seconds.\n"):format(v1["404ErrorAuraRevealTime"])
    }
};
-- Phase-one rig profiles. Current FCT animations and all balance values are retained.
v1.JohnDoeRigCollision=script.JohnDoeRigCollision
v1.JohnDoeRigQuery=script.JohnDoeRigQuery
v1.JohnDoeRigScale=script:GetAttribute("JohnDoeRigScale") or 1.25
v1.JohnDoeRigPhase="1.0.0"
v1.HipHeight=0
v1.CorruptEnergyPhase="1.0.0"
return v1;]========],before="11271:31c930bf:dd020e10",after="11426:1e3114dd:e18edd78"},
}
local pending={}
for _,plan in ipairs(plans) do
 assert(#plan.source<200000 and fingerprint(plan.source)==plan.after,"Incomplete/oversized source: "..plan.path..". Nothing changed.")
 local target=find(plan.path)
 if target then
  assert(target:IsA("ModuleScript"),"Expected ModuleScript: "..plan.path..". Nothing changed.")
  local hash=fingerprint(target.Source)
  if hash~=plan.after then
   assert(plan.before and hash==plan.before,"Source differs from fct4 + John rig phase one: "..plan.path..". Nothing changed; send the current source to retain edits.")
   table.insert(pending,{target=target,source=target.Source,plan=plan})
  end
 else
  assert(not plan.before,"Missing expected module: "..plan.path..". Nothing changed.")
  table.insert(pending,{plan=plan})
 end
end
if #pending==0 then print("[John Corrupt Energy] Already installed.");return end
local backup=Instance.new("Folder")
local name="JohnCorruptEnergy_Backup_"..os.date("!%Y%m%d_%H%M%S");local index=0
while game.ServerStorage:FindFirstChild(name.."_"..string.format("%03d",index)) do index+=1 end
backup.Name=name.."_"..string.format("%03d",index);backup.Parent=game.ServerStorage
for i,item in ipairs(pending) do
 local saved=item.target and item.target:Clone() or Instance.new("Folder")
 saved.Name=string.format("%02d_%s",i,item.plan.path:match("[^/]+$"));saved:SetAttribute("OriginalPath",item.plan.path);saved:SetAttribute("WasCreated",not item.target);saved:SetAttribute("InstalledFingerprint",item.plan.after);saved.Parent=backup
end
local ok,err=pcall(function()
 for _,item in ipairs(pending) do
  if not item.target then
   local parent=assert(find(item.plan.path:match("^(.*)/[^/]+$")),"Missing new module parent")
   item.target=Instance.new("ModuleScript");item.target.Name=item.plan.path:match("[^/]+$");item.target.Parent=parent
  end
  item.target.Source=item.plan.source
 end
end)
if not ok then
 for i=#pending,1,-1 do local item=pending[i];if item.source then item.target.Source=item.source elseif item.target then item.target:Destroy() end end
 backup:Destroy();error("[John Corrupt Energy] Rolled back: "..tostring(err))
end
pcall(function()game:GetService("ChangeHistoryService"):SetWaypoint("John Corrupt Energy + Retract")end)
print("[John Corrupt Energy] Installed 31 spikes / 11 damage / 2 impacts per target per cast, with Retract. Backup: "..backup:GetFullName()..". Save and start a fresh playtest.")

end
local function restore()
-- Restore the latest Corrupt Energy patch. Stop Play first.
assert(game:GetService("RunService"):IsStudio() and not game:GetService("RunService"):IsRunning(),"Stop Play first.")
local function find(path)
 local current=game
 for name in path:gmatch("[^/]+") do current=current and current:FindFirstChild(name) end
 return current
end
local function fingerprint(source)
 local a,b=5381,0
 for i=1,#source do local byte=string.byte(source,i);a=(a*33+byte)%4294967296;b=(b*65599+byte)%4294967296 end
 return string.format("%d:%08x:%08x",#source,a,b)
end

local backups={}
for _,folder in game.ServerStorage:GetChildren() do if folder.Name:match("^JohnCorruptEnergy_Backup_") then table.insert(backups,folder) end end
table.sort(backups,function(a,b)return a.Name>b.Name end)
local backup=assert(backups[1],"No Corrupt Energy backup found.")
local pending={}
for _,saved in backup:GetChildren() do
 local path=saved:GetAttribute("OriginalPath");local target=assert(find(path),"Missing installed target: "..path..". Nothing restored.")
 assert(target:IsA("ModuleScript") and fingerprint(target.Source)==saved:GetAttribute("InstalledFingerprint"),"Edited installed module: "..path..". Nothing restored.")
 table.insert(pending,{saved=saved,target=target,before=target.Source,path=path})
end
table.sort(pending,function(a,b)return a.path>b.path end)
local ok,err=pcall(function()
 for _,item in ipairs(pending) do if not item.saved:GetAttribute("WasCreated") then item.target.Source=item.saved.Source end end
end)
if not ok then for _,item in ipairs(pending) do if not item.saved:GetAttribute("WasCreated") then item.target.Source=item.before end end;error("Restore rolled back: "..tostring(err)) end
for _,item in ipairs(pending) do if item.saved:GetAttribute("WasCreated") then item.target:Destroy() end end
backup:Destroy()
print("[John Corrupt Energy] Restored the previous kit. Save and restart Play.")

end
fixture();install()
for path,source in pairs(expected)do assert(locate(path).Source==source)end
local n=#game.ServerStorage:GetChildren();install();assert(#game.ServerStorage:GetChildren()==n)
restore()
for path,source in pairs(originals)do assert(locate(path).Source==source)end
for path in pairs(expected)do if not originals[path]then assert(not locate(path))end end
-- A shared-module edit rejects the whole installation before creating new child modules.
fixture();local shared=locate("ReplicatedStorage/Modules/Hitboxes");shared.Source..="\n-- local edit"
local ok=pcall(install)
assert(not ok and not locate("ReplicatedStorage/Assets/Killers/JohnDoe/Behavior/CorruptEnergyController"))
-- Mid-commit Source failure preserves every old module and removes all created modules.
fixture();failAt=writes+4;ok=pcall(install);assert(not ok)
for path,source in pairs(originals)do assert(locate(path).Source==source)end
for path in pairs(expected)do if not originals[path]then assert(not locate(path))end end
print("PASS CE installer: 13 modules, paired stores, idempotence, exact restore, shared-edit refusal, Source failure rollback")
