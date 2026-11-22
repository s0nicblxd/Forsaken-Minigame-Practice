
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
return v1;]==========],
[ [==========[
ReplicatedStorage/Assets/Killers/JohnDoe/Behavior]==========] ]=[==========[
-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local _ = require(game.ReplicatedStorage.GlobalTypes);
local v1 = {};
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
                        CFrameOffset = CFrame.new(0, 0, -1.75), 
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
            v107.Position = v104.Rig.PrimaryPart.Position - Vector3.new(0, 4.5, 0, 0);
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
                            local v134 = v104:GetPivot().Position - Vector3.new(0, 3, 0, 0);
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
return v1;]==========],
[ [==========[
ServerStorage/Assets/Killers/JohnDoe/Behavior]==========] ]=[==========[
-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local _ = require(game.ReplicatedStorage.GlobalTypes);
local v1 = {};
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
                        CFrameOffset = CFrame.new(0, 0, -1.75), 
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
            v107.Position = v104.Rig.PrimaryPart.Position - Vector3.new(0, 4.5, 0, 0);
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
                            local v134 = v104:GetPivot().Position - Vector3.new(0, 3, 0, 0);
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
return v1;]==========]
}
local V={};V.__index=V
function V.__mul(a,b)return setmetatable({X=a.X*b,Y=a.Y*b,Z=a.Z*b},V)end
local Vector3={new=function(x,y,z)return setmetatable({X=x,Y=y,Z=z},V)end}
local CF={};CF.__index=CF
function CF.__mul(a,b)return setmetatable({Position=Vector3.new(a.Position.X+b.Position.X,a.Position.Y+b.Position.Y,a.Position.Z+b.Position.Z),Rotation=b.Rotation},CF)end
local CFrame={new=function(x,y,z)
 local position=type(x)=="table"and x or Vector3.new(x,y,z)
 return setmetatable({Position=position,Rotation=setmetatable({Position=Vector3.new(0,0,0)},CF)},CF)
end}
function Methods:ScaleTo(scale)
 local previous=self._props.ModelScale or 1
 for _,part in self:GetDescendants() do if part:IsA("BasePart") then part.Size=part.Size*(scale/previous)end end
 self.ModelScale=scale
end
function Methods:GetScale()return self.ModelScale or 1 end
local function path(path)
 local current=game
 for name in path:gmatch("[^/]+") do current=current:FindFirstChild(name)or child(current,name) end
 return current
end
local function fixture()
 fresh()
 for _,service in {"ReplicatedStorage","ServerStorage"} do
  local root=path(service.."/Assets/Killers/JohnDoe")
  for _,name in {"Config","Behavior"} do local m=child(root,name,"ModuleScript");m.Source=originals[service.."/Assets/Killers/JohnDoe/"..name] end
  local rig=child(root,"Rig","Model");rig.ModelScale=1;rig:SetAttribute("Original",true)
  local body=child(rig,"HumanoidRootPart","Part");body.Size=Vector3.new(2,2,1)
 end
 local query=child(path("ReplicatedStorage/Assets/Instances"),"QueryHitbox","Part");query.Size=Vector3.new(4,6,3)
 local payload=child(workspace,"JohnDoeUPD");local rig=child(payload,"MainRig","Model")
 local root=child(rig,"HumanoidRootPart","Part");root.Size=Vector3.new(2,2,1)
 local leg=child(rig,"Left Leg","Part");leg.Size=Vector3.new(1,2,1)
 child(rig,"Humanoid","Humanoid")
 local collision=child(child(payload,"Config","ModuleScript"),"CollisionHitbox","MeshPart");collision.Size=Vector3.new(2.152,4.663,2.152)
 return game.ReplicatedStorage.Assets.Killers.JohnDoe,game.ServerStorage.Assets.Killers.JohnDoe
end
local function install()
-- John Doe phase 1: UPD base rig, adjustable height, collision and ground alignment.
-- Import JohnDoeUPD.rbxm into Workspace first. Stop Play.
local SCALE=1.25 -- INITIAL CALIBRATION, not a confirmed official starting scale; edit and rerun to adjust.
assert(game:GetService("RunService"):IsStudio() and not game:GetService("RunService"):IsRunning(),"Stop Play before installing John Doe's rig.")
assert(type(SCALE)=="number" and SCALE>=1 and SCALE<=1.6,"Choose a calibration scale between 1.0 and 1.6.")
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
{path=[=======[
ReplicatedStorage/Assets/Killers/JohnDoe/Behavior]=======],source=[=======[
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
return v1;]=======],before="56839:9e8d81b5:98a3ecdc",after="57265:20e75274:1ab5aa69"},
{path=[=======[
ReplicatedStorage/Assets/Killers/JohnDoe/Behavior/RigAlignment]=======],source=[=======[
-- Phase-one geometry only. No attack reach, cooldown, damage or status balance changes.
local Alignment={}
function Alignment.IsUpdated(rig) return rig:GetAttribute("JohnDoeRigPhase")=="1.0.0" end
function Alignment.GroundHeight(rig)
 local hum=rig:FindFirstChildOfClass("Humanoid")
 local root=rig.PrimaryPart
 local leg=rig:FindFirstChild("Left Leg") or rig:FindFirstChild("Right Leg")
 return (hum and hum.HipHeight or 0)+(root and root.Size.Y/2 or 1)+(leg and leg.Size.Y or 2)
end
function Alignment.GroundPoint(rig)
 local root=rig.PrimaryPart
 local params=RaycastParams.new()
 params.FilterType=Enum.RaycastFilterType.Exclude
 params.FilterDescendantsInstances={workspace:FindFirstChild("Players") or rig,rig}
 params.RespectCanCollide=true
 local hit=workspace:Raycast(root.Position,Vector3.new(0,-Alignment.GroundHeight(rig)-8,0),params)
 return hit and hit.Position+Vector3.new(0,.03,0) or root.Position-Vector3.new(0,Alignment.GroundHeight(rig),0)
end
function Alignment.TrailPoint(actor,initial)
 if Alignment.IsUpdated(actor.Rig) then return Alignment.GroundPoint(actor.Rig) end
 return actor.Rig.PrimaryPart.Position-Vector3.new(0,initial and 4.5 or 3,0)
end
function Alignment.SlashOffset(actor)
 local y=Alignment.IsUpdated(actor.Rig) and 3-Alignment.GroundHeight(actor.Rig) or 0
 return CFrame.new(0,y,-1.75)
end
function Alignment.GetRig(actor)
 if not actor.SkinFolder then
  actor.Config.CollisionHitbox=actor.Config.JohnDoeRigCollision
  actor.Config.QueryHitbox=actor.Config.JohnDoeRigQuery
 end
 return actor.Rig:Clone()
end
return Alignment
]=======],before=false,after="1566:d24c3da8:4e8231d7"},
{path=[=======[
ReplicatedStorage/Assets/Killers/JohnDoe/Config]=======],source=[=======[
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
return v1;]=======],before="10914:0d07634d:b1b2b0d0",after="11201:a3ec107c:0a16eea7"},
{path=[=======[
ServerStorage/Assets/Killers/JohnDoe/Behavior]=======],source=[=======[
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
return v1;]=======],before="56787:82344124:b750daab",after="57213:cadc9c23:8794a5b8"},
{path=[=======[
ServerStorage/Assets/Killers/JohnDoe/Behavior/RigAlignment]=======],source=[=======[
-- Phase-one geometry only. No attack reach, cooldown, damage or status balance changes.
local Alignment={}
function Alignment.IsUpdated(rig) return rig:GetAttribute("JohnDoeRigPhase")=="1.0.0" end
function Alignment.GroundHeight(rig)
 local hum=rig:FindFirstChildOfClass("Humanoid")
 local root=rig.PrimaryPart
 local leg=rig:FindFirstChild("Left Leg") or rig:FindFirstChild("Right Leg")
 return (hum and hum.HipHeight or 0)+(root and root.Size.Y/2 or 1)+(leg and leg.Size.Y or 2)
end
function Alignment.GroundPoint(rig)
 local root=rig.PrimaryPart
 local params=RaycastParams.new()
 params.FilterType=Enum.RaycastFilterType.Exclude
 params.FilterDescendantsInstances={workspace:FindFirstChild("Players") or rig,rig}
 params.RespectCanCollide=true
 local hit=workspace:Raycast(root.Position,Vector3.new(0,-Alignment.GroundHeight(rig)-8,0),params)
 return hit and hit.Position+Vector3.new(0,.03,0) or root.Position-Vector3.new(0,Alignment.GroundHeight(rig),0)
end
function Alignment.TrailPoint(actor,initial)
 if Alignment.IsUpdated(actor.Rig) then return Alignment.GroundPoint(actor.Rig) end
 return actor.Rig.PrimaryPart.Position-Vector3.new(0,initial and 4.5 or 3,0)
end
function Alignment.SlashOffset(actor)
 local y=Alignment.IsUpdated(actor.Rig) and 3-Alignment.GroundHeight(actor.Rig) or 0
 return CFrame.new(0,y,-1.75)
end
function Alignment.GetRig(actor)
 if not actor.SkinFolder then
  actor.Config.CollisionHitbox=actor.Config.JohnDoeRigCollision
  actor.Config.QueryHitbox=actor.Config.JohnDoeRigQuery
 end
 return actor.Rig:Clone()
end
return Alignment
]=======],before=false,after="1566:d24c3da8:4e8231d7"},
{path=[=======[
ServerStorage/Assets/Killers/JohnDoe/Config]=======],source=[=======[
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
return v1;]=======],before="10984:48c85ff0:c453e3a7",after="11271:31c930bf:dd020e10"},
}
local pending={}
for _,plan in ipairs(plans) do
 assert(#plan.source<200000 and fingerprint(plan.source)==plan.after,"Incomplete or oversized source: "..plan.path..". Nothing changed.")
 local target=find(plan.path)
 if target then
  assert(target:IsA("ModuleScript"),"Expected module: "..plan.path..". Nothing changed.")
  local hash=fingerprint(target.Source)
  assert(hash==plan.after or plan.before and hash==plan.before,"John Doe source differs from fct4: "..plan.path..". Nothing changed; send the current module to preserve edits.")
 elseif plan.before then error("Missing John Doe module: "..plan.path..". Nothing changed.") end
 table.insert(pending,{plan=plan,target=target,before=target and target.Source})
end
local ready=true
for _,service in {"ReplicatedStorage","ServerStorage"} do
 local root=assert(find(service.."/Assets/Killers/JohnDoe"),"Missing John Doe asset folder.")
 if root:GetAttribute("JohnDoeRigPhase")~="1.0.0" or root.Config:GetAttribute("JohnDoeRigScale")~=SCALE then ready=false end
end
if ready then print("[John Doe rig] Already installed at scale "..SCALE);return end
local payload=assert(workspace:FindFirstChild("JohnDoeUPD"),"Import JohnDoeUPD.rbxm directly under Workspace first. Nothing changed.")
assert(payload:FindFirstChild("MainRig") and payload.MainRig:IsA("Model"),"Missing imported UPD MainRig. Nothing changed.")
assert(payload:FindFirstChild("Config") and payload.Config:FindFirstChild("CollisionHitbox"),"Missing imported collision template. Nothing changed.")
local defaultQuery=assert(find("ReplicatedStorage/Assets/Instances/QueryHitbox"),"Missing FCT query hitbox. Nothing changed.")
local profiles={}
local function scaledOffset(template,fallback)
 local offset=template:GetAttribute("CFrameOffset") or fallback
 return CFrame.new(offset.Position*SCALE)*offset.Rotation
end
local ok,err=pcall(function()
 for _,service in {"ReplicatedStorage","ServerStorage"} do
  local path=service.."/Assets/Killers/JohnDoe"
  local root=find(path);local config=root.Config
  local profile={root=root,config=config,path=path,oldScale=config:GetAttribute("JohnDoeRigScale"),oldVersion=root:GetAttribute("JohnDoeRigPhase"),oldRig=root:FindFirstChild("Rig"),oldCollision=config:FindFirstChild("JohnDoeRigCollision"),oldQuery=config:FindFirstChild("JohnDoeRigQuery")}
  table.insert(profiles,profile)
  local rig=payload.MainRig:Clone();profile.rig=rig;rig.Name="Rig"
  rig.PrimaryPart=assert(rig:FindFirstChild("HumanoidRootPart"),"UPD rig has no HumanoidRootPart")
  local hum=assert(rig:FindFirstChildOfClass("Humanoid"),"UPD rig has no Humanoid")
  if not hum:FindFirstChildOfClass("Animator") then Instance.new("Animator",hum) end
  for _,item in rig:GetDescendants() do
   assert(not item:IsA("LuaSourceContainer"),"Unexpected script in the imported rig")
   if item:IsA("BasePart") then item.Anchored=false;item.CanCollide=false;item.CanTouch=false;item.CanQuery=false end
  end
  rig:ScaleTo(SCALE);hum.HipHeight=0;rig.PrimaryPart.Anchored=true
  rig:SetAttribute("JohnDoeRigPhase","1.0.0")
  local collision=payload.Config.CollisionHitbox:Clone();profile.collision=collision
  collision.Name="JohnDoeRigCollision";collision.Size=collision.Size*SCALE
  collision:SetAttribute("CFrameOffset",scaledOffset(collision,CFrame.new(0,.5,0)))
  local query=defaultQuery:Clone();profile.query=query;query.Name="JohnDoeRigQuery";query.Size=query.Size*SCALE
  query:SetAttribute("CFrameOffset",scaledOffset(query,CFrame.new(0,-.25,0)))
 end
end)
if not ok then
 for _,p in ipairs(profiles) do for _,key in {"rig","collision","query"} do if p[key] then p[key]:Destroy() end end end
 error("[John Doe rig] Preparation failed. Nothing changed: "..tostring(err))
end
local backup=Instance.new("Folder");local backupBase="JohnDoeRig_Backup_"..os.date("!%Y%m%d_%H%M%S");local sequence=0
while game.ServerStorage:FindFirstChild(backupBase.."_"..string.format("%03d",sequence)) do sequence+=1 end
backup.Name=backupBase.."_"..string.format("%03d",sequence);backup.Parent=game.ServerStorage
local index=0
local function save(target,path)
 index+=1
 local saved=target and target:Clone() or Instance.new("Folder")
 saved.Name=string.format("%02d_%s",index,path:match("[^/]+$"));saved:SetAttribute("JohnRigOriginalPath",path);saved:SetAttribute("JohnRigWasCreated",not target);saved.Parent=backup
end
for _,item in ipairs(pending) do save(item.target,item.plan.path) end
for _,p in ipairs(profiles) do
 save(p.oldRig,p.path.."/Rig");save(p.oldCollision,p.path.."/Config/JohnDoeRigCollision");save(p.oldQuery,p.path.."/Config/JohnDoeRigQuery")
 local meta=Instance.new("Folder");meta.Name="Meta_"..p.root.Parent.Parent.Parent.Name;meta:SetAttribute("JohnRigMetaPath",p.path);meta:SetAttribute("OldScale",p.oldScale);meta:SetAttribute("OldVersion",p.oldVersion);meta.Parent=backup
end
ok,err=pcall(function()
 for _,p in ipairs(profiles) do
  if p.oldRig then p.oldRig.Parent=nil end
  if p.oldCollision then p.oldCollision.Parent=nil end
  if p.oldQuery then p.oldQuery.Parent=nil end
  p.rig.Parent=p.root;p.collision.Parent=p.config;p.query.Parent=p.config
  p.config:SetAttribute("JohnDoeRigScale",SCALE);p.root:SetAttribute("JohnDoeRigPhase","1.0.0")
 end
 for _,item in ipairs(pending) do
  if not item.target then item.target=Instance.new("ModuleScript");item.target.Name=item.plan.path:match("[^/]+$");item.target.Parent=find(item.plan.path:match("^(.*)/[^/]+$")) end
  item.target.Source=item.plan.source
 end
end)
if not ok then
 for i=#pending,1,-1 do local item=pending[i];if item.before then item.target.Source=item.before elseif item.target then item.target:Destroy() end end
 for _,p in ipairs(profiles) do
  p.rig:Destroy();p.collision:Destroy();p.query:Destroy()
  if p.oldRig then p.oldRig.Parent=p.root end
  if p.oldCollision then p.oldCollision.Parent=p.config end
  if p.oldQuery then p.oldQuery.Parent=p.config end
  p.config:SetAttribute("JohnDoeRigScale",p.oldScale);p.root:SetAttribute("JohnDoeRigPhase",p.oldVersion)
 end
 backup:Destroy();error("[John Doe rig] Rolled back: "..tostring(err))
end
for _,p in ipairs(profiles) do for _,key in {"oldRig","oldCollision","oldQuery"} do if p[key] then p[key]:Destroy() end end end
pcall(function()game:GetService("ChangeHistoryService"):SetWaypoint("John Doe UPD rig phase 1")end)
print("[John Doe rig] Default John uses the UPD model at calibration scale "..SCALE..". Ground/camera/collision/Slash alignment patched; original kit balance and animation IDs retained. Existing skins retain their own rigs.")
print("[John Doe rig] Backup: "..backup:GetFullName()..". Save and start a fresh playtest.")

end
local function calibrate()
-- John Doe phase 1: UPD base rig, adjustable height, collision and ground alignment.
-- Import JohnDoeUPD.rbxm into Workspace first. Stop Play.
local SCALE=1.4 -- INITIAL CALIBRATION, not a confirmed official starting scale; edit and rerun to adjust.
assert(game:GetService("RunService"):IsStudio() and not game:GetService("RunService"):IsRunning(),"Stop Play before installing John Doe's rig.")
assert(type(SCALE)=="number" and SCALE>=1 and SCALE<=1.6,"Choose a calibration scale between 1.0 and 1.6.")
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
{path=[=======[
ReplicatedStorage/Assets/Killers/JohnDoe/Behavior]=======],source=[=======[
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
return v1;]=======],before="56839:9e8d81b5:98a3ecdc",after="57265:20e75274:1ab5aa69"},
{path=[=======[
ReplicatedStorage/Assets/Killers/JohnDoe/Behavior/RigAlignment]=======],source=[=======[
-- Phase-one geometry only. No attack reach, cooldown, damage or status balance changes.
local Alignment={}
function Alignment.IsUpdated(rig) return rig:GetAttribute("JohnDoeRigPhase")=="1.0.0" end
function Alignment.GroundHeight(rig)
 local hum=rig:FindFirstChildOfClass("Humanoid")
 local root=rig.PrimaryPart
 local leg=rig:FindFirstChild("Left Leg") or rig:FindFirstChild("Right Leg")
 return (hum and hum.HipHeight or 0)+(root and root.Size.Y/2 or 1)+(leg and leg.Size.Y or 2)
end
function Alignment.GroundPoint(rig)
 local root=rig.PrimaryPart
 local params=RaycastParams.new()
 params.FilterType=Enum.RaycastFilterType.Exclude
 params.FilterDescendantsInstances={workspace:FindFirstChild("Players") or rig,rig}
 params.RespectCanCollide=true
 local hit=workspace:Raycast(root.Position,Vector3.new(0,-Alignment.GroundHeight(rig)-8,0),params)
 return hit and hit.Position+Vector3.new(0,.03,0) or root.Position-Vector3.new(0,Alignment.GroundHeight(rig),0)
end
function Alignment.TrailPoint(actor,initial)
 if Alignment.IsUpdated(actor.Rig) then return Alignment.GroundPoint(actor.Rig) end
 return actor.Rig.PrimaryPart.Position-Vector3.new(0,initial and 4.5 or 3,0)
end
function Alignment.SlashOffset(actor)
 local y=Alignment.IsUpdated(actor.Rig) and 3-Alignment.GroundHeight(actor.Rig) or 0
 return CFrame.new(0,y,-1.75)
end
function Alignment.GetRig(actor)
 if not actor.SkinFolder then
  actor.Config.CollisionHitbox=actor.Config.JohnDoeRigCollision
  actor.Config.QueryHitbox=actor.Config.JohnDoeRigQuery
 end
 return actor.Rig:Clone()
end
return Alignment
]=======],before=false,after="1566:d24c3da8:4e8231d7"},
{path=[=======[
ReplicatedStorage/Assets/Killers/JohnDoe/Config]=======],source=[=======[
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
return v1;]=======],before="10914:0d07634d:b1b2b0d0",after="11201:a3ec107c:0a16eea7"},
{path=[=======[
ServerStorage/Assets/Killers/JohnDoe/Behavior]=======],source=[=======[
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
return v1;]=======],before="56787:82344124:b750daab",after="57213:cadc9c23:8794a5b8"},
{path=[=======[
ServerStorage/Assets/Killers/JohnDoe/Behavior/RigAlignment]=======],source=[=======[
-- Phase-one geometry only. No attack reach, cooldown, damage or status balance changes.
local Alignment={}
function Alignment.IsUpdated(rig) return rig:GetAttribute("JohnDoeRigPhase")=="1.0.0" end
function Alignment.GroundHeight(rig)
 local hum=rig:FindFirstChildOfClass("Humanoid")
 local root=rig.PrimaryPart
 local leg=rig:FindFirstChild("Left Leg") or rig:FindFirstChild("Right Leg")
 return (hum and hum.HipHeight or 0)+(root and root.Size.Y/2 or 1)+(leg and leg.Size.Y or 2)
end
function Alignment.GroundPoint(rig)
 local root=rig.PrimaryPart
 local params=RaycastParams.new()
 params.FilterType=Enum.RaycastFilterType.Exclude
 params.FilterDescendantsInstances={workspace:FindFirstChild("Players") or rig,rig}
 params.RespectCanCollide=true
 local hit=workspace:Raycast(root.Position,Vector3.new(0,-Alignment.GroundHeight(rig)-8,0),params)
 return hit and hit.Position+Vector3.new(0,.03,0) or root.Position-Vector3.new(0,Alignment.GroundHeight(rig),0)
end
function Alignment.TrailPoint(actor,initial)
 if Alignment.IsUpdated(actor.Rig) then return Alignment.GroundPoint(actor.Rig) end
 return actor.Rig.PrimaryPart.Position-Vector3.new(0,initial and 4.5 or 3,0)
end
function Alignment.SlashOffset(actor)
 local y=Alignment.IsUpdated(actor.Rig) and 3-Alignment.GroundHeight(actor.Rig) or 0
 return CFrame.new(0,y,-1.75)
end
function Alignment.GetRig(actor)
 if not actor.SkinFolder then
  actor.Config.CollisionHitbox=actor.Config.JohnDoeRigCollision
  actor.Config.QueryHitbox=actor.Config.JohnDoeRigQuery
 end
 return actor.Rig:Clone()
end
return Alignment
]=======],before=false,after="1566:d24c3da8:4e8231d7"},
{path=[=======[
ServerStorage/Assets/Killers/JohnDoe/Config]=======],source=[=======[
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
return v1;]=======],before="10984:48c85ff0:c453e3a7",after="11271:31c930bf:dd020e10"},
}
local pending={}
for _,plan in ipairs(plans) do
 assert(#plan.source<200000 and fingerprint(plan.source)==plan.after,"Incomplete or oversized source: "..plan.path..". Nothing changed.")
 local target=find(plan.path)
 if target then
  assert(target:IsA("ModuleScript"),"Expected module: "..plan.path..". Nothing changed.")
  local hash=fingerprint(target.Source)
  assert(hash==plan.after or plan.before and hash==plan.before,"John Doe source differs from fct4: "..plan.path..". Nothing changed; send the current module to preserve edits.")
 elseif plan.before then error("Missing John Doe module: "..plan.path..". Nothing changed.") end
 table.insert(pending,{plan=plan,target=target,before=target and target.Source})
end
local ready=true
for _,service in {"ReplicatedStorage","ServerStorage"} do
 local root=assert(find(service.."/Assets/Killers/JohnDoe"),"Missing John Doe asset folder.")
 if root:GetAttribute("JohnDoeRigPhase")~="1.0.0" or root.Config:GetAttribute("JohnDoeRigScale")~=SCALE then ready=false end
end
if ready then print("[John Doe rig] Already installed at scale "..SCALE);return end
local payload=assert(workspace:FindFirstChild("JohnDoeUPD"),"Import JohnDoeUPD.rbxm directly under Workspace first. Nothing changed.")
assert(payload:FindFirstChild("MainRig") and payload.MainRig:IsA("Model"),"Missing imported UPD MainRig. Nothing changed.")
assert(payload:FindFirstChild("Config") and payload.Config:FindFirstChild("CollisionHitbox"),"Missing imported collision template. Nothing changed.")
local defaultQuery=assert(find("ReplicatedStorage/Assets/Instances/QueryHitbox"),"Missing FCT query hitbox. Nothing changed.")
local profiles={}
local function scaledOffset(template,fallback)
 local offset=template:GetAttribute("CFrameOffset") or fallback
 return CFrame.new(offset.Position*SCALE)*offset.Rotation
end
local ok,err=pcall(function()
 for _,service in {"ReplicatedStorage","ServerStorage"} do
  local path=service.."/Assets/Killers/JohnDoe"
  local root=find(path);local config=root.Config
  local profile={root=root,config=config,path=path,oldScale=config:GetAttribute("JohnDoeRigScale"),oldVersion=root:GetAttribute("JohnDoeRigPhase"),oldRig=root:FindFirstChild("Rig"),oldCollision=config:FindFirstChild("JohnDoeRigCollision"),oldQuery=config:FindFirstChild("JohnDoeRigQuery")}
  table.insert(profiles,profile)
  local rig=payload.MainRig:Clone();profile.rig=rig;rig.Name="Rig"
  rig.PrimaryPart=assert(rig:FindFirstChild("HumanoidRootPart"),"UPD rig has no HumanoidRootPart")
  local hum=assert(rig:FindFirstChildOfClass("Humanoid"),"UPD rig has no Humanoid")
  if not hum:FindFirstChildOfClass("Animator") then Instance.new("Animator",hum) end
  for _,item in rig:GetDescendants() do
   assert(not item:IsA("LuaSourceContainer"),"Unexpected script in the imported rig")
   if item:IsA("BasePart") then item.Anchored=false;item.CanCollide=false;item.CanTouch=false;item.CanQuery=false end
  end
  rig:ScaleTo(SCALE);hum.HipHeight=0;rig.PrimaryPart.Anchored=true
  rig:SetAttribute("JohnDoeRigPhase","1.0.0")
  local collision=payload.Config.CollisionHitbox:Clone();profile.collision=collision
  collision.Name="JohnDoeRigCollision";collision.Size=collision.Size*SCALE
  collision:SetAttribute("CFrameOffset",scaledOffset(collision,CFrame.new(0,.5,0)))
  local query=defaultQuery:Clone();profile.query=query;query.Name="JohnDoeRigQuery";query.Size=query.Size*SCALE
  query:SetAttribute("CFrameOffset",scaledOffset(query,CFrame.new(0,-.25,0)))
 end
end)
if not ok then
 for _,p in ipairs(profiles) do for _,key in {"rig","collision","query"} do if p[key] then p[key]:Destroy() end end end
 error("[John Doe rig] Preparation failed. Nothing changed: "..tostring(err))
end
local backup=Instance.new("Folder");local backupBase="JohnDoeRig_Backup_"..os.date("!%Y%m%d_%H%M%S");local sequence=0
while game.ServerStorage:FindFirstChild(backupBase.."_"..string.format("%03d",sequence)) do sequence+=1 end
backup.Name=backupBase.."_"..string.format("%03d",sequence);backup.Parent=game.ServerStorage
local index=0
local function save(target,path)
 index+=1
 local saved=target and target:Clone() or Instance.new("Folder")
 saved.Name=string.format("%02d_%s",index,path:match("[^/]+$"));saved:SetAttribute("JohnRigOriginalPath",path);saved:SetAttribute("JohnRigWasCreated",not target);saved.Parent=backup
end
for _,item in ipairs(pending) do save(item.target,item.plan.path) end
for _,p in ipairs(profiles) do
 save(p.oldRig,p.path.."/Rig");save(p.oldCollision,p.path.."/Config/JohnDoeRigCollision");save(p.oldQuery,p.path.."/Config/JohnDoeRigQuery")
 local meta=Instance.new("Folder");meta.Name="Meta_"..p.root.Parent.Parent.Parent.Name;meta:SetAttribute("JohnRigMetaPath",p.path);meta:SetAttribute("OldScale",p.oldScale);meta:SetAttribute("OldVersion",p.oldVersion);meta.Parent=backup
end
ok,err=pcall(function()
 for _,p in ipairs(profiles) do
  if p.oldRig then p.oldRig.Parent=nil end
  if p.oldCollision then p.oldCollision.Parent=nil end
  if p.oldQuery then p.oldQuery.Parent=nil end
  p.rig.Parent=p.root;p.collision.Parent=p.config;p.query.Parent=p.config
  p.config:SetAttribute("JohnDoeRigScale",SCALE);p.root:SetAttribute("JohnDoeRigPhase","1.0.0")
 end
 for _,item in ipairs(pending) do
  if not item.target then item.target=Instance.new("ModuleScript");item.target.Name=item.plan.path:match("[^/]+$");item.target.Parent=find(item.plan.path:match("^(.*)/[^/]+$")) end
  item.target.Source=item.plan.source
 end
end)
if not ok then
 for i=#pending,1,-1 do local item=pending[i];if item.before then item.target.Source=item.before elseif item.target then item.target:Destroy() end end
 for _,p in ipairs(profiles) do
  p.rig:Destroy();p.collision:Destroy();p.query:Destroy()
  if p.oldRig then p.oldRig.Parent=p.root end
  if p.oldCollision then p.oldCollision.Parent=p.config end
  if p.oldQuery then p.oldQuery.Parent=p.config end
  p.config:SetAttribute("JohnDoeRigScale",p.oldScale);p.root:SetAttribute("JohnDoeRigPhase",p.oldVersion)
 end
 backup:Destroy();error("[John Doe rig] Rolled back: "..tostring(err))
end
for _,p in ipairs(profiles) do for _,key in {"oldRig","oldCollision","oldQuery"} do if p[key] then p[key]:Destroy() end end end
pcall(function()game:GetService("ChangeHistoryService"):SetWaypoint("John Doe UPD rig phase 1")end)
print("[John Doe rig] Default John uses the UPD model at calibration scale "..SCALE..". Ground/camera/collision/Slash alignment patched; original kit balance and animation IDs retained. Existing skins retain their own rigs.")
print("[John Doe rig] Backup: "..backup:GetFullName()..". Save and start a fresh playtest.")

end
local function restore()
-- Restore the latest John Doe rig phase-one installation. Stop Play first.
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
for _,folder in game.ServerStorage:GetChildren() do if folder.Name:match("^JohnDoeRig_Backup_") then table.insert(backups,folder) end end
table.sort(backups,function(a,b)return a.Name>b.Name end)
local backup=assert(backups[1],"No John Doe rig backup found.")
local modules,assets,metadata={},{},{}
for _,saved in backup:GetChildren() do
 local path=saved:GetAttribute("JohnRigOriginalPath")
 local metaPath=saved:GetAttribute("JohnRigMetaPath")
 if path then
  local parent=assert(find(path:match("^(.*)/[^/]+$")),"Missing original parent: "..path..". Nothing restored.")
  local item={saved=saved,path=path,parent=parent,target=find(path),prepared=not saved:GetAttribute("JohnRigWasCreated") and saved:Clone() or nil}
  if item.prepared then item.prepared.Name=path:match("[^/]+$");item.prepared:SetAttribute("JohnRigOriginalPath",nil);item.prepared:SetAttribute("JohnRigWasCreated",nil) end
  if saved:IsA("ModuleScript") or path:match("/RigAlignment$") then table.insert(modules,item) else table.insert(assets,item) end
 elseif metaPath then table.insert(metadata,{root=assert(find(metaPath),"Missing John Doe folder"),saved=saved}) end
end
-- Restore module Sources in place, preserving children before restoring asset templates beneath Config.
for _,item in ipairs(modules) do
 if item.saved:GetAttribute("JohnRigWasCreated") then if item.target then item.target:Destroy() end
 else assert(item.target and item.target:IsA("ModuleScript"),"Missing original module");item.target.Source=item.saved.Source end
end
for _,item in ipairs(assets) do if item.target then item.target:Destroy() end;if item.prepared then item.prepared.Parent=item.parent end end
for _,item in ipairs(metadata) do item.root:SetAttribute("JohnDoeRigPhase",item.saved:GetAttribute("OldVersion"));item.root.Config:SetAttribute("JohnDoeRigScale",item.saved:GetAttribute("OldScale")) end
backup:Destroy()
print("[John Doe rig] Restored. Save and restart Play.")

end
local rep,stored=fixture()
install()
assert(rep.Rig:GetScale()==1.25 and stored.Rig:GetScale()==1.25)
assert(rep.Rig.HumanoidRootPart.Size.Y==2.5 and rep.Rig.Humanoid.HipHeight==0)
assert(rep.Config.JohnDoeRigQuery.Size.Y==7.5 and rep.Behavior.RigAlignment)
assert(rep.Config:GetAttribute("JohnDoeRigScale")==1.25)
local count=#game.ServerStorage:GetChildren();install();assert(#game.ServerStorage:GetChildren()==count)
calibrate();assert(rep.Rig:GetScale()==1.4 and rep.Rig.HumanoidRootPart.Size.Y==2.8,"recalibration compounded prior scale")
restore();assert(rep.Rig:GetScale()==1.25 and rep.Config:GetAttribute("JohnDoeRigScale")==1.25)
restore();assert(rep.Rig:GetAttribute("Original") and not rep.Behavior.RigAlignment and not rep.Config.JohnDoeRigQuery)
assert(rep.Behavior.Source==originals["ReplicatedStorage/Assets/Killers/JohnDoe/Behavior"])
assert(not rep.Config:GetAttribute("JohnDoeRigScale") and not rep:GetAttribute("JohnDoeRigPhase"))
-- Mid-write failure restores modules, root attributes and all original rig/template parents.
rep,stored=fixture();local oldRig=rep.Rig;failAt=writes+3
local ok=pcall(install)
assert(not ok and rep.Rig==oldRig and not rep.Behavior.RigAlignment and not rep.Config.JohnDoeRigCollision)
assert(rep.Behavior.Source==originals["ReplicatedStorage/Assets/Killers/JohnDoe/Behavior"] and not rep.Config:GetAttribute("JohnDoeRigScale"))
-- Unknown code is never overwritten.
rep,stored=fixture();rep.Behavior.Source..="\n-- custom edit";oldRig=rep.Rig
ok=pcall(install);assert(not ok and rep.Rig==oldRig)
print("PASS rig installer: paired models/templates, absolute recalibration, idempotence, sequential restore, Source rollback, unknown-edit refusal")
