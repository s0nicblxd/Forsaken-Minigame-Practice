
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

local nativeTypeof=typeof
local function typeof(value)if type(value)=="table"and value._props then return "Instance"end;return nativeTypeof(value)end
local function signal()
 local entries={}
 return {Connect=function(_,callback)
  local object={Active=true};function object:Disconnect()self.Active=false end
  table.insert(entries,{object,callback});return object
 end,Fire=function(_,...)
  for _,entry in table.clone(entries)do if entry[1].Active then entry[2](...)end end
 end,Count=function()local n=0;for _,entry in entries do if entry[1].Active then n+=1 end end;return n end}
end

local configSource=[========[
-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local v0 = {
    DisplayName = "Builderman", 
    Quote = "\"Welcome to ROBLOX!\"", 
    Credits = "", 
    Class = "Support", 
	RenderImage = "rbxassetid://84427509230526", 
    Price = 500, 
    Requests = {
        BuildermanSentry = {
            AbilityName = "Sentry", 
            RequestTitle = "Request Sentry", 
            NotificationTitle = "PLAYERNAME wants a sentry built!", 
            Order = 1
        }, 
        BuildermanDispenser = {
            AbilityName = "Dispenser", 
            RequestTitle = "Request Dispenser", 
            NotificationTitle = "PLAYERNAME wants a dispenser built!", 
            Order = 2
        }
    }, 
    Health = 90, 
    Speed = 12, 
    SentryCooldown = 45, 
    SentryConstructionDuration = 6, 
    SentryPositionOffset = 4, 
    SentryPlacementRadius = 60, 
    SentryDamageRadius = 33, 
    SentryLimit = 1, 
    SentryPingDistance = 999, 
    SentryPingDuration = 999, 
    SentryHealth = 30, 
    SentrySlownessLevel = 2, 
    SentrySlownessDuration = 1, 
    SentryDamagePerSec = 3, 
    SentryRangeReductionPercentage = 16, 
    SentryMinimumRange = 8, 
    SentryPickupDebounce = 0.75, 
    SentryTemplate = script.Sentry, 
    SentryAnimations = {
        Construction = "rbxassetid://106692939896483", 
        Idle = "rbxassetid://130389796258882", 
        Shoot = "rbxassetid://138018912492418"
    }, 
    DispenserCooldown = 45, 
    DispenserConstructionDuration = 6, 
    DispenserPositionOffset = 4, 
    DispenserPlacementRadius = 30, 
    DispenserHealingRadius = 8, 
    DispenserLimit = 1, 
    DispenserPingDistance = 999, 
    DispenserPingDuration = 999, 
    DispenserPickupDebounce = 0.5, 
    DispenserHealth = 15, 
    DispenserHealingPerSec = 1, 
    DispenserHealingReductionPercentage = 8, 
    DispenserMinimumHealing = 0.3, 
    DispenserTemplate = script.Dispenser, 
    DispenserAnimations = {
        Construction = "rbxassetid://135275318911400", 
        Idle = "rbxassetid://115085028575971"
    }, 
    WarningTemplate = script.Warning, 
    HatFixCooldown = 40, 
    HatFixBuffDelay = 1.5, 
    HatFixRange = 45, 
    Expressions = {
        Happy = "rbxassetid://75425376108592", 
        Default = "rbxassetid://78927941165959", 
        Hurt = "rbxassetid://105173827090865", 
        Injured = "rbxassetid://77334993821053", 
        Dead = "rbxassetid://88659722034277", 
        Drinking = "rbxassetid://83064700049700", 
        Concentrating = "rbxassetid://102570873215742"
    }, 
    Animations = {
        ConstructStart = "rbxassetid://103224883560515", 
        ConstructLoop = "rbxassetid://91819909895073", 
        ConstructEnd = "rbxassetid://109538467160081", 
        HatFix = "rbxassetid://117170871416506"
    }, 
    Sounds = {
        SentryBuilding = "rbxassetid://136339052883583", 
        SentryIdle = "rbxassetid://76614615962252", 
        SentryDestroyed = "rbxassetid://93968271191175", 
        SentryTargeted = "rbxassetid://70547773233061", 
        SentryShoot = "rbxassetid://88349332699712", 
        SentryPutdown = "rbxassetid://2423389966", 
        SentryPickup = "rbxassetid://2848703459", 
        DispenserBuilding = "rbxassetid://124147765575221", 
        DispenserIdle = "rbxassetid://119973546430491", 
        DispenserDestroyed = "rbxassetid://123133999959036", 
        DispenserPickup = "rbxassetid://2848703459", 
        DispenserPutdown = "rbxassetid://116086162740635"
    }, 
    TextInteractions = {
        Requests = {
            ElliotPizza = {
                "Looking for a slice of pizza over here.", 
                "Could I ask for a slice of pizza?", 
                "Hey, pass a slice.", 
                "You don\226\128\153t happen to have pizza on you, do you?", 
                "A pizza would work great on me right now.. mind if I get one?"
            }, 
            BuildermanSentry = {
                "Place your sentry here.", 
                "Put down a sentry over here.", 
                "Over here\226\128\153s a good spot for a sentry.", 
                "Build your sentry here. It\226\128\153s good ground.", 
                "Put your sentry over here."
            }, 
            BuildermanBuildermanSentry = {
                "I know imitation is the best form of flattery, but uh-\226\128\166 whatever, put down a sentry here.", 
                "Impersonatin\226\128\153 an admin is a bannable offense. If you build a sentry I might change my mind.", 
                "It\226\128\153s like lookin\226\128\153 into an uncanny mirror-\226\128\166 ahem, uh.. Put a sentry here, will you?", 
                "Build the sentry here. If you're truly me then you'd know it's a good spot.", 
                "This spot over here could be good for a sentry. You know that, yeah?"
            }, 
            BuildermanDispenser = {
                "Here\226\128\153s a good spot for a dispenser.", 
                "Good spot for a dispenser here.", 
                "Put your dispenser down over here.", 
                "The spot over here could be good for a dispenser.", 
                "Dispenser could be great if it were put down here."
            }, 
            BuildermanBuildermanDispenser = {
                "Let\226\128\153s hope your dispenser building skills are as good as your imitation.", 
                "If you\226\128\153re really me, then you ought to know that this spot\226\128\153s good for a dispenser.", 
                "This spot\226\128\153s pretty good for a dispenser. Don\226\128\153t you think, me?", 
                "Put down a dispenser if you\226\128\153re really who you say you are.", 
                "You ought to know how to build a dispenser here if you\226\128\153re really the person you\226\128\153re imitating."
            }, 
            DusekkarProtection = {
                "Need a bit of your magic, Dusekkar!", 
                "Need a bit of magic from you, pumpkin.", 
                "A force field would do good on me, if that\226\128\153s alright.", 
                "Cast some of your magic, pumpkin!", 
                "Your magic I could really use right about now, Dusekkar."
            }, 
            HemmorhageAsk = {
                "Not feeling too good.. can feel myself draining.. I'm gonna need some help.", 
                "Lend me a hand for a bit, I'm hurting real' bad...", 
                "I'm.. not in a good state here, and I'm gonna need some of your help.", 
                "Trying real hard to keep going, but I might need your help for it.", 
                "Gonna need some of your help, I don't think I'll last long in this state..."
            }
        }, 
        Thanks = {
            Regular = {
                "Thanks.", 
                "Thank you.", 
                "Your work is appreciated.", 
                "Thank you.", 
                "Now that's some good work."
            }
        }
    }
};
v0.Information = {
    {
        Separator = "GENERAL INFO"
    }, 
    {
        Header = "BUILDERMAN", 
        Text = "The big boss of Roblox HQ himself. With a hammer in his inventory and a lot of spare parts and materials to spare, he's able to build contraptions that can either slow the killer's path, or heal those around him. As a promise with Shedletsky, he'll do all he can to help everyone.\n"
    }, 
    {
        Header = "STATS", 
        Text = "Difficulty: \226\152\133\226\152\133\226\152\133\226\152\134\226\152\134\n" .. ("Health: %*\n"):format(v0.Health or 100) .. ("Regular Speed: %*\n"):format(v0.Speed or 12) .. ("Sprinting Speed: %*\n"):format(v0.SprintSpeed or 26) .. ("Max Stamina: %*\n"):format(v0.MaxStamina or 100) .. ("Stamina Loss per sec: %*\n"):format(v0.StaminaLoss or 10) .. ("Stamina Gain per sec: %*\n"):format(v0.StaminaGain or 20)
    }, 
    {
        Separator = "ABILITIES"
    }, 
    {
        Image = "rbxassetid://104441527277654", 
        Header = "SENTRY CONSTRUCTION", 
        Quote = "\"These sentries see your enemies so you don't have to!\" - Roblox", 
        Text = ("Cooldown: %*s\n"):format(v0.SentryCooldown) .. ("Sentry Health: %*\n"):format(v0.SentryHealth) .. ("Builderman takes %*s to build a <b>Sentry</b> infront of him, which targets nearby killers and inflicts <b>Slowness II</b> for %*s onto them.\n"):format(v0.SentryConstructionDuration, v0.SentrySlownessDuration) .. "If Builderman is attacked while performing this ability, any <b>Sentry</b> that's currently in production by them will be destroyed and the ability will be cancelled.\n" .. ("Builderman is only able to build %* <b>Sentry</b> at a time.\n"):format(v0.SentryLimit) .. ("<b>Sentries</b> have a target range of %* studs which decreases by %*%% for every additional <b>Sentry</b> that's placed in the world.\n"):format(v0.SentryDamageRadius, v0.SentryRangeReductionPercentage) .. ("<b>Sentries</b> will always have a target range of at least %* studs no matter what the current target range reduction is.\n"):format(v0.SentryMinimumRange) .. ("Other kinds of buildings cannot be built within %* studs of any <b>Sentry</b> in the world.\n"):format(v0.SentryPlacementRadius) .. "Using this ability while having built the max amount of <b>Sentries</b> automatically destroys the first active <b>Sentry</b> you placed.\n"
    }, 
    {
        Image = "rbxassetid://102952736333903", 
        Header = "DISPENSER CONSTRUCTION", 
        Quote = "\"This is pretty much the best healing potion in any video game ever.\" - Roblox", 
        Text = ("Cooldown: %*s\n"):format(v0.DispenserCooldown) .. ("Dispenser Health: %*\n"):format(v0.DispenserHealth) .. ("Builderman takes %*s to build a <b>Dispenser</b> infront of him, which heals all teammates within %* studs by %* HP/s.\n"):format(v0.DispenserConstructionDuration, v0.DispenserHealingRadius, v0.DispenserHealingPerSec) .. "If Builderman is attacked while performing this ability, any <b>Dispenser</b> that's currently in production by them will be destroyed and the ability will be cancelled.\n" .. ("Builderman is only able to build %* <b>Dispenser</b> at a time.\n"):format(v0.DispenserLimit) .. ("<b>Dispensers</b> have their healing reduced by %*%% for every additional <b>Dispenser</b> that's built.\n"):format(v0.DispenserHealingReductionPercentage) .. ("<b>Dispensers</b> will always be able to heal at least %* HP/s no matter what the current healing reduction is.\n"):format(v0.DispenserMinimumHealing) .. ("Other kinds of buildings cannot be built within %* studs of any <b>Dispenser</b> in the world.\n"):format(v0.DispenserPlacementRadius) .. "Using this ability while having built the max amount of <b>Dispensers</b> automatically destroys the first active <b>Dispenser</b> you built.\n"
    }, 
    {
        Image = "rbxassetid://102952736333903", 
        Header = "CARRY / PLACE", 
        Quote = "\"What moron designed this?\" - Dude", 
        Text = "Cooldown: 2s\nBuilderman can stand near any of his buildings to pick them up.\nWhile Builderman is carrying a building, he is slowed by 25%, and the building does not function (sentries won't shoot, and dispensers won't heal).\nBuilderman can use this ability while carrying a building to place it down, provided there is space, and he is far enough away from other buildings (indicated by a blue zone).\n Once a building is placed down, it takes 0.8s to re-activate.\nIf Builderman is attacked while carrying a building, it will be destroyed.\n"
    }
};
return v0;]========]
local behaviorSource=[========[
-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local _ = require(game.ReplicatedStorage.GlobalTypes);
local l_RunService_0 = game:GetService("RunService");
local v2 = {};
local v3 = require(game.ReplicatedStorage.Modules.Sounds);
local v4 = require(game.ReplicatedStorage.Modules.Util);
local _ = require(game.ReplicatedStorage.Modules.Hitboxes);
local v6 = require(game.ReplicatedStorage.Modules.Statuses);
local v7 = require(game.ReplicatedStorage.Modules.Network);
local v8 = require(game.ReplicatedStorage.Packages.trove);
local v9 = require(game.ReplicatedStorage.Modules.Misc.Spring);
local function v27(v10, v11) --[[ Line: 17 ]] --[[ Name: destroyBuilding ]]
    -- upvalues: v3 (copy), v7 (copy)
    if v11:GetAttribute("Destroyed") then
        return;
    else
        v11:SetAttribute("Destroyed", true);
        for _, v13 in pairs(v11:GetDescendants()) do
            if v13:IsA("WeldConstraint") or v13:IsA("JointInstance") then
                v13:Destroy();
            elseif v13:IsA("ParticleEmitter") or v13:IsA("Light") then
                v13.Enabled = false;
            end;
        end;
        for _, v15 in pairs(v11:GetDescendants()) do
            if v15:IsA("Sound") then
                game.TweenService:Create(v15, TweenInfo.new(0.25), {
                    Volume = 0
                }):Play();
            end;
        end;
        local v16 = string.gsub(v11.Name, "Builderman", "");
        if v10 then
            local _ = v3:Play(v10.Config.Sounds[("%*Destroyed"):format(v16)], {
                Parent = v11.PrimaryPart
            });
            local _ = v3:PlayVoiceline(v10, ("%*Destroyed"):format(v16), {
                Priority = 4
            });
        end;
        for _, v20 in pairs(v11:GetChildren()) do
            if v20:IsA("BasePart") and v20.Transparency <= 0.5 then
                local l_Fire_0 = Instance.new("Fire");
                l_Fire_0.Parent = v20;
                l_Fire_0.Heat = v20.Size.Magnitude / 5;
                l_Fire_0.Size = v20.Size.Magnitude;
                v20.CanCollide = true;
                task.delay(math.random(400, 600) / 100, function() --[[ Line: 58 ]]
                    -- upvalues: v20 (copy), l_Fire_0 (copy)
                    game.TweenService:Create(v20, TweenInfo.new(3), {
                        Transparency = 1
                    }):Play();
                    game.TweenService:Create(l_Fire_0, TweenInfo.new(2), {
                        Heat = 0, 
                        Size = 0
                    }):Play();
                    task.wait(1);
                    l_Fire_0.Enabled = false;
                end);
            end;
        end;
        local v22 = {};
        for _, v24 in pairs(workspace.Map.Ingame:GetChildren()) do
            if v24.Name == v11.Name and not v24:GetAttribute("Destroyed") then
                table.insert(v22, v24);
            end;
        end;
        for _, v26 in pairs(v22) do
            v26:SetAttribute("BuildingCount", #v22);
        end;
        v7:FireAllClientConnection(("%*ReplicateDestroyedBuildingAsync"):format(v10.Player.Name), "REMOTE_EVENT", v16);
        game.Debris:AddItem(v11, 10);
        return;
    end;
end;
local function _(v28, v29) --[[ Line: 86 ]] --[[ Name: getBuildingPointFormula ]]
    if v28 == "Sentry" then
        return (math.ceil((math.clamp(v29 ^ 0.5 * 1.2, 0, 20))));
    elseif v28 == "Dispenser" then
        return (math.ceil((math.clamp(v29 ^ 0.95 * 0.35, 0, 20))));
    else
        return;
    end;
end;
local function v89(v31, v32, v33) --[[ Line: 94 ]] --[[ Name: constructBuilding ]]
    -- upvalues: v27 (copy), v4 (copy), v3 (copy), v7 (copy)
    v31.AbilitiesDisabled = true;
    local function v48(v34) --[[ Line: 99 ]] --[[ Name: checkPlacement ]]
        -- upvalues: v31 (copy), v32 (copy)
        local l_workspace_PartBoundsInRadius_0 = workspace:GetPartBoundsInRadius(v34.Position, 1);
        for _, v37 in pairs(l_workspace_PartBoundsInRadius_0) do
            if v37.Transparency < 0.9 or v37.Name == "UnplacableArea" then
                return "collision";
            end;
        end;
        for _, v39 in pairs(workspace.Map.Ingame:GetChildren()) do
            if v39.Name:find("Builderman") and not v39:GetAttribute("Destroyed") then
                local v40 = string.gsub(v39.Name, "Builderman", "");
                local v41 = v31.Config[("%*PlacementRadius"):format(v40)] or v31.Config[("%*PlacementRadius"):format(v32)];
                if (v34.Position - v39.PrimaryPart.Position).Magnitude <= v41 / 2 then
                    return "tooClose";
                end;
            end;
        end;
        for _, v43 in pairs(workspace.Players.Survivors:GetChildren()) do
            local l_v43_Attribute_0 = v43:GetAttribute("PlacementRadius");
            local l_PrimaryPart_0 = v43.PrimaryPart;
            if v43 ~= v31.Rig and l_v43_Attribute_0 and l_PrimaryPart_0 and (v34.Position - l_PrimaryPart_0.Position).Magnitude <= l_v43_Attribute_0 / 2 then
                return "tooClose";
            end;
        end;
        local v46 = RaycastParams.new();
        v46.FilterType = Enum.RaycastFilterType.Exclude;
        v46.RespectCanCollide = true;
        v46.CollisionGroup = "Survivors";
        v46.FilterDescendantsInstances = {
            workspace.Players
        };
        local v47 = workspace:Raycast(v34.Position, Vector3.new(0, -4, 0, 0), v46);
        if not v47 then
            return "midair";
        elseif v47 and v47.Instance.Name == "Conveyor" then
            return "collision";
        elseif workspace:Raycast(v31.Rig.PrimaryPart.Position, v31.Rig.PrimaryPart.CFrame.LookVector * v31.Config[("%*PositionOffset"):format(v32)], v46) then
            return "facingWall";
        else
            v31.Rig:SetAttribute("PlacementRadius", v31.Config[("%*PlacementRadius"):format(v32)] or 70);
            return "placed";
        end;
    end;
    local v49 = v31.Rig.PrimaryPart.CFrame * CFrame.new(0, 0, -v31.Config[("%*PositionOffset"):format(v32)]);
    local v50 = v48(v49);
    if v50 ~= "placed" then
        v31.AbilitiesDisabled = false;
        return {
            Cancelled = true, 
            Reason = v50
        };
    else
        for _, v52 in pairs(v31.Rig:GetChildren()) do
            if v52.Name:find("Wrench") or v52.Name:find("Hammer") then
                v52.Transparency = 0;
            end;
        end;
        local v53 = v31.Config[("%*Template"):format(v32)]:Clone();
        v53:SetAttribute("OwnerName", (tostring(v31.Player)));
        v53:SetAttribute("Team", "Survivors");
        v53:AddTag("SurvivorConstruct");
        v53.Humanoid.Health = v31.Config[("%*Health"):format(v32)];
        v53.Name = ("Builderman%*"):format(v32);
        v53.Parent = workspace.Map.Ingame;
        local v54 = v31.Config[("%*Limit"):format(v32)];
        if not v31[("Constructed%*"):format(v32)] then
            v31[("Constructed%*"):format(v32)] = {};
        end;
        if v54 <= #v31[("Constructed%*"):format(v32)] then
            v27(v31, v31[("Constructed%*"):format(v32)][1]);
            table.remove(v31[("Constructed%*"):format(v32)], 1);
        end;
        table.insert(v31[("Constructed%*"):format(v32)], v53);
        local v55 = {};
        for _, v57 in pairs(workspace.Map.Ingame:GetChildren()) do
            if v57.Name == ("Builderman%*"):format(v32) and not v57:GetAttribute("Destroyed") then
                table.insert(v55, v57);
            end;
        end;
        for _, v59 in pairs(v55) do
            v59:SetAttribute("BuildingCount", #v55);
        end;
        for _, v61 in pairs(v53:GetDescendants()) do
            if v61:IsA("BasePart") and v61.Transparency ~= 1 then
                v61:SetAttribute("Hidden", true);
                v61.Transparency = 1;
            end;
        end;
        local v62 = {};
        for v63, v64 in pairs(v31.Config[("%*Animations"):format(v32)]) do
            v62[v63] = v4:LoadAnimationFromID(v53, v64);
        end;
        v31:ChangeExpression("Concentrating");
        local v65 = nil;
        local l_Health_0 = v31.Rig.Humanoid.Health;
        local v67 = nil;
        v67 = v31.Rig.Humanoid.HealthChanged:Connect(function(v68) --[[ Line: 219 ]]
            -- upvalues: l_Health_0 (ref), v65 (ref)
            if v68 < l_Health_0 then
                v65 = "failed";
            end;
            l_Health_0 = v68;
        end);
        local v69 = nil;
        v69 = v53.Humanoid.HealthChanged:Connect(function(_) --[[ Line: 227 ]]
            -- upvalues: v65 (ref)
            v65 = "failed";
        end);
        v3:Play(v31.Config.Sounds[("%*Building"):format(v32)], {
            Parent = v53.PrimaryPart
        });
        v3:PlayVoiceline(v31, ("%*Constructing"):format(v32), {
            Priority = 2
        });
        task.delay(1.25, function() --[[ Line: 236 ]]
            -- upvalues: v65 (ref), v31 (copy), v53 (copy), v62 (copy), v32 (copy), v48 (copy), v49 (copy)
            if v65 then
                return;
            elseif not v31.Rig.PrimaryPart then
                return;
            else
                for _, v72 in pairs(v53:GetDescendants()) do
                    if v72:GetAttribute("Hidden") then
                        game.TweenService:Create(v72, TweenInfo.new(1), {
                            Transparency = 0
                        }):Play();
                    end;
                end;
                v62.Construction:Play(0);
                v62.Construction.Stopped:Connect(function() --[[ Line: 248 ]]
                    -- upvalues: v62 (ref)
                    v62.Idle:Play(0);
                end);
                local v73 = v31.Rig.PrimaryPart.CFrame * CFrame.new(0, 0, -v31.Config[("%*PositionOffset"):format(v32)]);
                if not (v48(v73) == "placed") then
                    v73 = v49;
                end;
                local v74 = RaycastParams.new();
                v74.FilterType = Enum.RaycastFilterType.Exclude;
                v74.RespectCanCollide = true;
                v74.CollisionGroup = "Survivors";
                v74.FilterDescendantsInstances = {
                    workspace.Players
                };
                local v75 = workspace:Raycast(v73.Position, Vector3.new(0, -100, 0, 0), v74);
                local v76 = v75 and v75.Position + Vector3.new(0, v53.PrimaryPart.Size.Y / 2, 0) or (v73 - Vector3.new(0, 1.5, 0, 0)).Position;
                v53:SetPrimaryPartCFrame(CFrame.new(v76) * v73.Rotation);
                v31.Rig:SetAttribute("PlacementRadius", nil);
                return;
            end;
        end);
        task.delay(v31.Config[("%*ConstructionDuration"):format(v32)], function() --[[ Line: 275 ]]
            -- upvalues: v65 (ref)
            if not v65 then
                v65 = "constructed";
            end;
        end);
        task.spawn(function() --[[ Line: 282 ]]
            -- upvalues: v65 (ref), v31 (copy), v33 (copy), v53 (copy), v62 (copy), v3 (ref), v32 (copy), v27 (ref), v7 (ref), v67 (ref), v69 (ref)
            repeat
                task.wait();
            until v65;
            for _, v78 in pairs(v31.Rig:GetChildren()) do
                if v78.Name:find("Wrench") or v78.Name:find("Hammer") then
                    v78.Transparency = 1;
                end;
            end;
            v31:ChangeExpression("Default");
            v31.Rig:SetAttribute("PlacementRadius", nil);
            if v65 == "constructed" then
                v33(v53, v62);
                v53:SetAttribute("HitboxPriority", 0);
                v3:PlayVoiceline(v31, ("%*Constructed"):format(v32), {
                    Priority = 3
                });
                local v79 = v31.Config.Sounds[("%*BuildingCompleted"):format(v32)];
                if v79 then
                    local v80 = v3:Play(v79, {
                        Parent = v53.PrimaryPart, 
                        Volume = 0.5
                    });
                    if v80 and tostring(v80.Parent) == "Sounds" then
                        v80:Destroy();
                    end;
                end;
                if v53.PrimaryPart then
                    local v81 = v3:Play(v31.Config.Sounds[("%*Idle"):format(v32)], {
                        Parent = v53.PrimaryPart, 
                        Volume = 0, 
                        Looped = true
                    });
                    if v81 then
                        game.TweenService:Create(v81, TweenInfo.new(0.5), {
                            Volume = 0.5
                        }):Play();
                    end;
                    if v81 and tostring(v81.Parent) == "Sounds" then
                        v81:Destroy();
                    end;
                end;
                for _, v83 in pairs(v53:GetDescendants()) do
                    if (v83:IsA("ParticleEmitter") or v83:IsA("Light")) and v83.Name ~= "Shoot" then
                        v83.Enabled = true;
                    end;
                end;
                v53.Humanoid.Died:Once(function() --[[ Line: 325 ]]
                    -- upvalues: v53 (ref), v31 (ref), v32 (ref), v27 (ref)
                    local v84 = v53:GetAttribute("DamageDealt") or v53:GetAttribute("TotalHealed") or 0;
                    local v85 = require(game.ReplicatedStorage.Modules.Actors);
                    v85:IncrementActorStats(v31.Player, {
                        Action = ("%* was destroyed"):format(v32), 
                        RewardType = "Survivalist"
                    });
                    local l_v32_0 = v32;
                    local v87 = if l_v32_0 == "Sentry" then math.ceil((math.clamp(v84 ^ 0.5 * 1.2, 0, 20))) else if l_v32_0 == "Dispenser" then math.ceil((math.clamp(v84 ^ 0.95 * 0.35, 0, 20))) else nil;
                    if v87 > 0 then
                        v85:IncrementActorStats(v31.Player, {
                            Action = ("%* %* %* with %*"):format(v32 == "Sentry" and "Dealt" or "Healed", tostring((math.ceil(v84))), v32 == "Sentry" and "damage" or "health", v32), 
                            Money = v87, 
                            EXP = math.ceil(v87 * 0.5)
                        });
                    end;
                    v27(v31, v53);
                end);
                v7:FireAllClientConnection(("%*ReplicateBuildingAsync"):format(v31.Player.Name), "REMOTE_EVENT", v53, v32);
            else
                v27(v31, v53);
            end;
            v67:Disconnect();
            v67 = nil;
            v69:Disconnect();
            v69 = nil;
            local l_StringValue_0 = Instance.new("StringValue");
            l_StringValue_0.Value = tostring(v65);
            l_StringValue_0.Name = "Result";
            l_StringValue_0.Parent = v31.Rig;
            game.Debris:AddItem(l_StringValue_0, 1);
            task.delay(2, function() --[[ Line: 368 ]]
                -- upvalues: v31 (ref)
                v31.AbilitiesDisabled = false;
            end);
        end);
        return;
    end;
end;
local function v99(v90, v91, v92) --[[ Line: 374 ]] --[[ Name: constructBuildingOnClient ]]
    -- upvalues: v4 (copy)
    if typeof(v92) == "table" and v92.Cancelled then
        local v93 = {
            collision = "Building area is obstructed by something. Build somewhere else.", 
            tooClose = "Building area is too close to a pre-existing building. Move further away and try again.", 
            midair = "Building area is too high above ground. Turn around and try again.", 
            facingWall = "You're too close to a wall. Turn around and try again.", 
            unknown = "Something went wrong. Try building somewhere else."
        };
        local v94 = v93[v92.Reason] or v93.unknown;
        v4:CreateWarning("BuildermanWarning", v94, v90.Config.WarningTemplate);
        return;
    else
        local v95 = true;
        v90.Animations.ConstructStart:Play();
        task.delay(0.75, function() --[[ Line: 399 ]]
            -- upvalues: v95 (ref), v90 (copy)
            if v95 then
                v90.Animations.ConstructStart:Stop();
                v90.Animations.ConstructLoop:Play();
            end;
        end);
        local l_v4_ProgressBar_0 = v4:CreateProgressBar(("Building %*"):format(v91), v90.Config[("%*ConstructionDuration"):format(v91)]);
        local l_v4_SpeedMultiplier_0 = v4:CreateSpeedMultiplier(v90.Rig, 0, (("%*Construction"):format(v91)));
        local v98 = v90.Rig:WaitForChild("Result", v90.Config[("%*ConstructionDuration"):format(v91)] + 3);
        v98 = v98 and v98.Value or "IDK";
        v95 = false;
        v90.Animations.ConstructStart:Stop();
        v90.Animations.ConstructLoop:Stop();
        l_v4_ProgressBar_0:Destroy();
        v90.Animations.ConstructEnd:Play();
        game.TweenService:Create(l_v4_SpeedMultiplier_0, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.In), {
            Value = 1
        }):Play();
        game.Debris:AddItem(l_v4_SpeedMultiplier_0, 1);
        return;
    end;
end;
v2.Abilities = {
    Sentry = {
        LayoutOrder = 1, 
        KeybindType = "AltAbility1", 
        Icon = "rbxassetid://104441527277654", 
        Callback = function(v100, v101) --[[ Line: 432 ]] --[[ Name: Callback ]]
            -- upvalues: v89 (copy), v4 (copy), v3 (copy), v6 (copy), v99 (copy)
            if game["Run Service"]:IsServer() then
                return v89(v100, "Sentry", function(v102, v103) --[[ Line: 438 ]]
                    -- upvalues: v100 (copy), v4 (ref), v3 (ref), v6 (ref)
                    task.spawn(function() --[[ Line: 440 ]]
                        -- upvalues: v102 (copy), v100 (ref), v4 (ref), v3 (ref), v103 (copy), v6 (ref)
                        local v104 = 0;
                        local v105 = false;
                        local v106 = false;
                        local l_C0_0 = v102.Torso.Neck.C0;
                        local v108 = RaycastParams.new();
                        v108.FilterType = Enum.RaycastFilterType.Exclude;
                        v108.FilterDescendantsInstances = {
                            v102, 
                            game.CollectionService:GetTagged("SurvivorConstructs")
                        };
                        while true do
                            if v102.Parent then
                                local v109 = task.wait(0.2);
                                local _ = v102.PrimaryPart;
                                if not v102.Parent then
                                    return;
                                elseif not v102.PrimaryPart then
                                    return;
                                elseif v102:GetAttribute("Destroyed") then
                                    return;
                                else
                                    local v111 = (v102:GetAttribute("BuildingCount") or 1) - 1;
                                    local v112 = v100.Config.SentryDamageRadius / 2;
                                    local v113 = math.clamp(v112 * (1 - v111 * v100.Config.SentryRangeReductionPercentage / 100), v100.Config.SentryMinimumRange, v112);
                                    if v102:GetAttribute("EffectRadiusSize") ~= v113 then
                                        v102:SetAttribute("EffectRadiusSize", v113);
                                    end;
                                    if not v106 then
                                        v106 = true;
                                        local l_v4_ClosestPlayerFromPosition_0 = v4:GetClosestPlayerFromPosition(v100.Rig.PrimaryPart.Position, {
                                            MaxDistance = v100.Config.SentryPingDistance, 
                                            ReturnTable = true, 
                                            OverrideUndetectable = true
                                        });
                                        for _, v116 in pairs(l_v4_ClosestPlayerFromPosition_0) do
                                            local l_Player_0 = v116.Player;
                                            local l_PlayerFromCharacter_0 = game.Players:GetPlayerFromCharacter(l_Player_0);
                                            if l_PlayerFromCharacter_0 then
                                                v4:RevealPlayerAuraTo(l_PlayerFromCharacter_0, v102, v100.Config.SentryPingDuration, Color3.new(0.75, 1, 0.75));
                                            end;
                                        end;
                                    end;
                                    local l_v4_ClosestPlayerFromPosition_1 = v4:GetClosestPlayerFromPosition(v102.PrimaryPart.Position, {
                                        PlayerSelection = "Killers", 
                                        MaxDistance = v113
                                    });
                                    if l_v4_ClosestPlayerFromPosition_1 and l_v4_ClosestPlayerFromPosition_1.PrimaryPart and l_v4_ClosestPlayerFromPosition_1.Humanoid.Health > 0 then
                                        local l_Position_0 = v102.PrimaryPart.Position;
                                        local l_LookVector_0 = CFrame.lookAt(l_Position_0, l_v4_ClosestPlayerFromPosition_1.PrimaryPart.Position).LookVector;
                                        local v122 = workspace:Raycast(l_Position_0, l_LookVector_0 * v113, v108);
                                        if v122 then
                                            if not v122.Instance:IsDescendantOf(l_v4_ClosestPlayerFromPosition_1) then
                                                v105 = false;
                                            else
                                                if not v105 then
                                                    v105 = true;
                                                    v3:Play(v100.Config.Sounds.SentryTargeted, {
                                                        Parent = v102.PrimaryPart
                                                    });
                                                end;
                                                if v103.Shoot then
                                                    v103.Shoot:Play(0);
                                                end;
                                                v3:Play(v100.Config.Sounds.SentryShoot, {
                                                    Parent = v102.PrimaryPart
                                                });
                                                for _, v124 in pairs(v102:GetDescendants()) do
                                                    if (v124:IsA("ParticleEmitter") or v124:IsA("Light")) and v124.Name == "Shoot" then
                                                        task.spawn(function() --[[ Line: 507 ]]
                                                            -- upvalues: v124 (copy)
                                                            v124.Enabled = true;
                                                            task.wait(0.05);
                                                            v124.Enabled = false;
                                                        end);
                                                    end;
                                                end;
                                                local l_Humanoid_0 = l_v4_ClosestPlayerFromPosition_1:FindFirstChild("Humanoid");
                                                if l_Humanoid_0 then
                                                    local v126 = v100.Config.SentryDamagePerSec * v109;
                                                    l_Humanoid_0.Health = l_Humanoid_0.Health - v126;
                                                    v104 = v104 + v126;
                                                end;
                                                v102:SetAttribute("DamageDealt", v104);
                                                v6:ApplyStatus(l_v4_ClosestPlayerFromPosition_1, "Slowness", {
                                                    Duration = v100.Config.SentrySlownessDuration, 
                                                    Level = v100.Config.SentrySlownessLevel
                                                });
                                            end;
                                        end;
                                    else
                                        v105 = false;
                                        game.TweenService:Create(v102.Torso.Neck, TweenInfo.new(0.5), {
                                            C0 = l_C0_0
                                        }):Play();
                                    end;
                                end;
                            else
                                return;
                            end;
                        end;
                    end);
                end);
            else
                if game["Run Service"]:IsClient() then
                    v99(v100, "Sentry", v101);
                end;
                return;
            end;
        end
    }, 
    Dispenser = {
        LayoutOrder = 2, 
        KeybindType = "AltAbility2", 
        Icon = "rbxassetid://102952736333903", 
        Callback = function(v127, v128) --[[ Line: 546 ]] --[[ Name: Callback ]]
            -- upvalues: v89 (copy), v4 (copy), v99 (copy)
            if game["Run Service"]:IsServer() then
                return v89(v127, "Dispenser", function(v129) --[[ Line: 552 ]]
                    -- upvalues: v127 (copy), v4 (ref)
                    task.spawn(function() --[[ Line: 554 ]]
                        -- upvalues: v129 (copy), v127 (ref), v4 (ref)
                        task.delay(120, function() --[[ Line: 556 ]]
                            -- upvalues: v129 (ref), v127 (ref)
                            if v129.Parent and not v129:GetAttribute("Destroyed") then
                                require(game.ReplicatedStorage.Modules.AchievementUtil):IncrementAchievementProgress(v127.Player, "BuildermanDispenser");
                            end;
                        end);
                        local v130 = 0;
                        local v131 = false;
                        while true do
                            if v129.Parent then
                                local v132 = game["Run Service"].Heartbeat:Wait();
                                if not v129.Parent then
                                    return;
                                elseif not v129.PrimaryPart then
                                    return;
                                elseif v129:GetAttribute("Destroyed") then
                                    return;
                                else
                                    if not v131 then
                                        v131 = true;
                                        local l_v4_ClosestPlayerFromPosition_2 = v4:GetClosestPlayerFromPosition(v127.Rig.PrimaryPart.Position, {
                                            MaxDistance = v127.Config.DispenserPingDistance, 
                                            OverrideUndetectable = true, 
                                            ReturnTable = true
                                        });
                                        for _, v135 in pairs(l_v4_ClosestPlayerFromPosition_2) do
                                            local l_Player_1 = v135.Player;
                                            local l_PlayerFromCharacter_1 = game.Players:GetPlayerFromCharacter(l_Player_1);
                                            if l_PlayerFromCharacter_1 then
                                                v4:RevealPlayerAuraTo(l_PlayerFromCharacter_1, v129, v127.Config.DispenserPingDuration, Color3.new(0.75, 1, 0.75));
                                            end;
                                        end;
                                    end;
                                    local v138 = (v129:GetAttribute("BuildingCount") or 1) - 1;
                                    local l_DispenserHealingPerSec_0 = v127.Config.DispenserHealingPerSec;
                                    local _ = math.clamp(l_DispenserHealingPerSec_0 * (1 - v138 * v127.Config.DispenserHealingReductionPercentage / 100), v127.Config.DispenserMinimumHealing, l_DispenserHealingPerSec_0);
                                    local l_v4_ClosestPlayerFromPosition_3 = v4:GetClosestPlayerFromPosition(v129.PrimaryPart.Position, {
                                        PlayerSelection = "Survivors", 
                                        MaxDistance = v127.Config.DispenserHealingRadius / 2, 
                                        ReturnTable = true, 
                                        OverrideUndetectable = true
                                    });
                                    local l_pairs_0 = pairs;
                                    local v143 = l_v4_ClosestPlayerFromPosition_3 or {};
                                    for _, v145 in l_pairs_0(v143) do
                                        local l_Player_2 = v145.Player;
                                        local v147 = l_Player_2 and l_Player_2:FindFirstChild("Humanoid");
                                        if v147 and not v147:GetAttribute("Clanker") then
                                            local v148 = v147.MaxHealth - v147.Health;
                                            v4:Heal(v147, l_DispenserHealingPerSec_0 * v132);
                                            v130 = v130 + math.min(v148, l_DispenserHealingPerSec_0 * v132);
                                        end;
                                    end;
                                    v129:SetAttribute("TotalHealed", v130);
                                end;
                            else
                                return;
                            end;
                        end;
                    end);
                end);
            else
                if game["Run Service"]:IsClient() then
                    v99(v127, "Dispenser", v128);
                end;
                return;
            end;
        end
    }
};
v2.Created = function(_, v150) --[[ Line: 723 ]] --[[ Name: Created ]]
    -- upvalues: v27 (copy), v8 (copy), v9 (copy), v4 (copy), l_RunService_0 (copy), v7 (copy)
    if game["Run Service"]:IsServer() then
        v150.Rig.AncestryChanged:Connect(function(_, v152) --[[ Line: 726 ]]
            -- upvalues: v150 (copy), v27 (ref)
            if v152 then
                return;
            else
                for _, v154 in pairs(workspace.Map.Ingame:GetChildren()) do
                    if v154.Name:find("Builderman") and v154:GetAttribute("OwnerName") == tostring(v150.Player) then
                        v27(v150, v154);
                    end;
                end;
                return;
            end;
        end);
    elseif game["Run Service"]:IsClient() and v150.Rig == game.Players.LocalPlayer.Character then
        v150.RadiusStorages = {};
        local function _(v155, v156) --[[ Line: 744 ]] --[[ Name: createRadiusStorage ]]
            -- upvalues: v150 (copy)
            local l_Model_0 = Instance.new("Model");
            l_Model_0.Parent = workspace.Map.Ingame;
            l_Model_0.Name = v155;
            v150.RadiusStorages[v155] = l_Model_0;
            local l_Highlight_0 = Instance.new("Highlight");
            l_Highlight_0.DepthMode = Enum.HighlightDepthMode.Occluded;
            l_Highlight_0.FillTransparency = 0.875;
            l_Highlight_0.OutlineTransparency = 0.6;
            l_Highlight_0.FillColor = v156;
            l_Highlight_0.Parent = l_Model_0;
        end;
        local v160 = Color3.fromRGB(70, 155, 255);
        local l_Model_1 = Instance.new("Model");
        l_Model_1.Parent = workspace.Map.Ingame;
        l_Model_1.Name = "PlacementRange";
        v150.RadiusStorages.PlacementRange = l_Model_1;
        local l_Highlight_1 = Instance.new("Highlight");
        l_Highlight_1.DepthMode = Enum.HighlightDepthMode.Occluded;
        l_Highlight_1.FillTransparency = 0.875;
        l_Highlight_1.OutlineTransparency = 0.6;
        l_Highlight_1.FillColor = v160;
        l_Highlight_1.Parent = l_Model_1;
        v160 = Color3.fromRGB(255, 80, 80);
        l_Model_1 = Instance.new("Model");
        l_Model_1.Parent = workspace.Map.Ingame;
        l_Model_1.Name = "BuildermanSentryEffectRange";
        v150.RadiusStorages.BuildermanSentryEffectRange = l_Model_1;
        l_Highlight_1 = Instance.new("Highlight");
        l_Highlight_1.DepthMode = Enum.HighlightDepthMode.Occluded;
        l_Highlight_1.FillTransparency = 0.875;
        l_Highlight_1.OutlineTransparency = 0.6;
        l_Highlight_1.FillColor = v160;
        l_Highlight_1.Parent = l_Model_1;
        v160 = Color3.fromRGB(80, 255, 80);
        l_Model_1 = Instance.new("Model");
        l_Model_1.Parent = workspace.Map.Ingame;
        l_Model_1.Name = "BuildermanDispenserEffectRange";
        v150.RadiusStorages.BuildermanDispenserEffectRange = l_Model_1;
        l_Highlight_1 = Instance.new("Highlight");
        l_Highlight_1.DepthMode = Enum.HighlightDepthMode.Occluded;
        l_Highlight_1.FillTransparency = 0.875;
        l_Highlight_1.OutlineTransparency = 0.6;
        l_Highlight_1.FillColor = v160;
        l_Highlight_1.Parent = l_Model_1;
        v160 = function(v163, v164) --[[ Line: 766 ]] --[[ Name: createRadius ]]
            -- upvalues: v150 (copy)
            local v165 = v150.RadiusStorages[v163];
            if not v165 then
                return;
            elseif not v164 then
                return;
            else
                local l_Part_0 = Instance.new("Part");
                l_Part_0.CanCollide = false;
                l_Part_0.Anchored = true;
                l_Part_0.Transparency = 1;
                l_Part_0.Position = Vector3.new(0, -100, 0, 0);
                l_Part_0.Orientation = Vector3.new(0, 0, 90, 0);
                l_Part_0.Size = Vector3.new(0.25, v164, v164);
                l_Part_0.Material = Enum.Material.Glass;
                l_Part_0.Shape = Enum.PartType.Cylinder;
                l_Part_0.Parent = v165;
                return l_Part_0;
            end;
        end;
        local l_v160_0 = v160 --[[ copy: 3 -> 9 ]];
        v150.Connection = workspace.Map.Ingame.ChildAdded:Connect(function(v168) --[[ Line: 784 ]]
            -- upvalues: v150 (copy), l_v160_0 (copy)
            if v168.Name:find("Builderman") then
                local v169 = v168:WaitForChild("Humanoid", 10);
                if not v169 then
                    return;
                else
                    local v170 = v168:WaitForChild("Root", 10);
                    if not v170 then
                        return;
                    else
                        local v171 = {
                            BuildermanSentryPlacementRange = v150.Config.SentryPlacementRadius, 
                            BuildermanSentryEffectRange = v150.Config.SentryDamageRadius, 
                            BuildermanDispenserPlacementRange = v150.Config.DispenserPlacementRadius, 
                            BuildermanDispenserEffectRange = v150.Config.DispenserHealingRadius
                        };
                        local v172 = ("%*PlacementRange"):format(v168.Name);
                        local v173 = ("%*EffectRange"):format(v168.Name);
                        local v174 = l_v160_0("PlacementRange", v171[v172]);
                        local v175 = l_v160_0(v173, v171[v173]);
                        v170:GetPropertyChangedSignal("Position"):Connect(function() --[[ Line: 809 ]]
                            -- upvalues: v174 (copy), v170 (copy), v175 (copy)
                            if v174 then
                                v174.Position = v170.Position - Vector3.new(0, v170.Size.Y / 2 + 0.075, 0);
                            end;
                            if v175 then
                                v175.Position = v170.Position - Vector3.new(0, v170.Size.Y / 2 + 0, 0);
                            end;
                        end);
                        v168:GetAttributeChangedSignal("EffectRadiusSize"):Connect(function() --[[ Line: 815 ]]
                            -- upvalues: v168 (copy), v175 (copy)
                            local l_v168_Attribute_0 = v168:GetAttribute("EffectRadiusSize");
                            if v175 then
                                game.TweenService:Create(v175, TweenInfo.new(1), {
                                    Size = Vector3.new(0.25, l_v168_Attribute_0 * 2, l_v168_Attribute_0 * 2)
                                }):Play();
                            end;
                        end);
                        v169.HealthChanged:Connect(function(v177) --[[ Line: 821 ]]
                            -- upvalues: v174 (copy), v175 (copy)
                            if v177 <= 0 then
                                if v174 then
                                    v174:Destroy();
                                end;
                                if v175 then
                                    v175:Destroy();
                                end;
                            end;
                        end);
                        v168.AncestryChanged:Connect(function(_, v179) --[[ Line: 828 ]]
                            -- upvalues: v174 (copy), v175 (copy)
                            if not v179 then
                                if v174 then
                                    v174:Destroy();
                                end;
                                if v175 then
                                    v175:Destroy();
                                end;
                            end;
                        end);
                    end;
                end;
            end;
        end);
    end;
    if game["Run Service"]:IsClient() then
        local v180 = v8.new();
        v150.InternalTrove = v180;
        v150.Buildings = {};
        local v181 = nil;
        local v182 = nil;
        local v183 = nil;
        do
            local l_v181_0, l_v182_0, l_v183_0 = v181, v182, v183;
            local function v210() --[[ Line: 847 ]] --[[ Name: __onRenderUpdateSentryNeck ]]
                -- upvalues: v150 (copy), l_v182_0 (ref), l_v183_0 (ref), l_v181_0 (ref), v9 (ref), v4 (ref)
                if not v150.Buildings.Sentry then
                    return;
                else
                    local l_Sentry_0 = v150.Buildings.Sentry;
                    if l_v182_0 == nil then
                        l_v182_0 = RaycastParams.new();
                        l_v182_0.FilterType = Enum.RaycastFilterType.Exclude;
                        l_v182_0.FilterDescendantsInstances = {
                            l_Sentry_0, 
                            game.CollectionService:GetTagged("SurvivorConstructs")
                        };
                    end;
                    if l_v183_0 == nil then
                        l_v183_0 = l_Sentry_0.Torso.Neck.C0;
                    end;
                    if l_v181_0 == nil then
                        l_v181_0 = v9.new(l_v183_0, 0.25);
                    end;
                    local v188 = (l_Sentry_0:GetAttribute("BuildingCount") or 1) - 1;
                    local v189 = v150.Config.SentryDamageRadius / 2;
                    local v190 = math.clamp(v189 * (1 - v188 * v150.Config.SentryRangeReductionPercentage / 100), v150.Config.SentryMinimumRange, v189);
                    local l_v4_ClosestPlayerFromPosition_4 = v4:GetClosestPlayerFromPosition(l_Sentry_0.PrimaryPart.Position, {
                        PlayerSelection = "Killers", 
                        MaxDistance = v190
                    });
                    if l_v4_ClosestPlayerFromPosition_4 and l_v4_ClosestPlayerFromPosition_4.PrimaryPart and l_v4_ClosestPlayerFromPosition_4.Humanoid.Health > 0 then
                        local l_Position_1 = l_Sentry_0.PrimaryPart.Position;
                        local l_LookVector_1 = CFrame.lookAt(l_Position_1, l_v4_ClosestPlayerFromPosition_4.PrimaryPart.Position).LookVector;
                        local v194 = workspace:Raycast(l_Position_1, l_LookVector_1 * v190, l_v182_0);
                        if not v194 or not v194.Instance:IsDescendantOf(l_v4_ClosestPlayerFromPosition_4) then
                            return;
                        else
                            local function _(v195, v196) --[[ Line: 883 ]] --[[ Name: worldCFrameToC0ObjectSpace ]]
                                local l_CFrame_0 = v195.Part1.CFrame;
                                local l_C1_0 = v195.C1;
                                local l_C0_1 = v195.C0;
                                local v200 = l_C0_1 * l_C1_0:Inverse() * l_CFrame_0:Inverse() * v196 * l_C1_0;
                                return v200 - v200.Position + l_C0_1.Position;
                            end;
                            local v202 = CFrame.lookAt(l_Sentry_0.Head.Position, l_v4_ClosestPlayerFromPosition_4.PrimaryPart.Position, l_Sentry_0.Torso.CFrame.UpVector);
                            local l_Neck_0 = l_Sentry_0.Torso.Neck;
                            local l_CFrame_1 = l_Neck_0.Part1.CFrame;
                            local l_C1_1 = l_Neck_0.C1;
                            local l_C0_2 = l_Neck_0.C0;
                            local v207 = l_C0_2 * l_C1_1:Inverse() * l_CFrame_1:Inverse() * v202 * l_C1_1;
                            l_v181_0.Target = (v207 - v207.Position + l_C0_2.Position) * CFrame.Angles(-1.5707963267948966, 0, 0);
                            for _, v209 in pairs(l_Sentry_0:GetDescendants()) do
                                if (v209:IsA("ParticleEmitter") or v209:IsA("Light")) and v209.Name == "Shoot" then
                                    task.spawn(function() --[[ Line: 902 ]]
                                        -- upvalues: v209 (copy)
                                        v209.Enabled = true;
                                        task.wait(0.05);
                                        v209.Enabled = false;
                                    end);
                                end;
                            end;
                            return;
                        end;
                    else
                        l_v181_0.Target = l_v183_0;
                        return;
                    end;
                end;
            end;
            local v211 = task.spawn(function() --[[ Line: 914 ]]
                -- upvalues: v210 (copy)
                while true do
                    v210();
                    task.wait(0.2);
                end;
            end);
            local v212 = os.clock();
            v180:Connect(l_RunService_0.RenderStepped, function() --[[ Line: 922 ]]
                -- upvalues: v150 (copy), l_v181_0 (ref), v212 (ref)
                if not v150.Buildings.Sentry or not l_v181_0 then
                    return;
                else
                    local v213 = os.clock();
                    local v214 = v213 - v212;
                    v212 = v213;
                    local l_Neck_1 = v150.Buildings.Sentry.Torso:FindFirstChild("Neck");
                    if l_Neck_1 then
                        l_Neck_1.C0 = l_v181_0:Update(v214);
                    end;
                    return;
                end;
            end);
            v7:SetConnection(("%*ReplicateBuildingAsync"):format(v150.Player.Name), "REMOTE_EVENT", function(v216, v217) --[[ Line: 937 ]]
                -- upvalues: v150 (copy)
                if v150.Player ~= game.Players.LocalPlayer then
                    return;
                else
                    v150.Buildings[v217] = v216;
                    local l_AbilityContainer_0 = v150.Player.PlayerGui.MainUI:FindFirstChild("AbilityContainer");
                    local v219 = l_AbilityContainer_0 and l_AbilityContainer_0:FindFirstChild(v217);
                    if not v219 then
                        return;
                    else
                        v219.Charges.Text = "PLACED";
                        return;
                    end;
                end;
            end);
            v7:SetConnection(("%*ReplicateDestroyedBuildingAsync"):format(v150.Player.Name), "REMOTE_EVENT", function(v220) --[[ Line: 953 ]]
                -- upvalues: v150 (copy)
                if v150.Player ~= game.Players.LocalPlayer then
                    return;
                else
                    v150.Buildings[v220] = nil;
                    local l_AbilityContainer_1 = v150.Player.PlayerGui.MainUI:FindFirstChild("AbilityContainer");
                    local v222 = l_AbilityContainer_1 and l_AbilityContainer_1:FindFirstChild(v220);
                    if not v222 then
                        return;
                    else
                        v222.Charges.Text = "";
                        return;
                    end;
                end;
            end);
            v150.Rig.AncestryChanged:Connect(function(_, v224) --[[ Line: 969 ]]
                -- upvalues: v150 (copy), v7 (ref), v211 (copy), v180 (copy)
                if not v224 and v150.Player == game.Players.LocalPlayer then
                    if v150.Connection then
                        v150.Connection:Disconnect();
                    end;
                    for _, v226 in pairs(v150.RadiusStorages) do
                        v226:Destroy();
                    end;
                end;
                v150.Buildings = {};
                v7:RemoveConnection(("%*ReplicateBuildingAsync"):format(v150.Player.Name), "REMOTE_EVENT");
                task.cancel(v211);
                v180:Destroy();
            end);
        end;
    end;
end;
return v2;]========]
local selection={}
local function locate(path)
 local object=game;for name in path:gmatch("[^/]+")do object=object and object:FindFirstChild(name)end;return object
end
local original
local function fixture()
 fresh();selection={}
 local get=game.GetService
 function game:GetService(name)if name=="Selection"then return {Get=function()return selection end}end;return get(self,name)end
 original=child(game.ReplicatedStorage.Assets.Survivors,"Builderman")
 local config=child(original,"Config","ModuleScript");config.Source=configSource
 local sentry=child(config,"Sentry","Model");child(sentry,"Humanoid","Humanoid");child(sentry,"Root","Part")
 child(sentry,"OldTurretMesh","SpecialMesh")
 child(original,"Behavior","ModuleScript").Source=behaviorSource
 child(original,"Rig","Model")
 local donor=child(game.ServerStorage,"BuildermanUPD")
 local upd=child(donor,"Config","ModuleScript")
 child(upd,"Sentry","Model")
 local dispenser=child(upd,"Dispenser","Model");child(dispenser,"Humanoid","Humanoid");child(dispenser,"Root","Part")
 child(upd,"Warning","Frame");child(upd,"Highlight","Highlight");child(upd,"MiniTurret","Model")
end
local function install()
assert(game:GetService("RunService"):IsStudio()and not game:GetService("RunService"):IsRunning(),"Stop Play first.")
local function find(path)
 local object=game
 for name in path:gmatch("[^/]+")do object=object and object:FindFirstChild(name)end
 return object
end
local function fingerprint(s)
 local a,b=5381,0
 for i=1,#s do local v=s:byte(i);a=(a*33+v)%4294967296;b=(b*65599+v)%4294967296 end
 return string.format("%d:%08x:%08x",#s,a,b)
end
local function ref(parent,name,value)local object=Instance.new("ObjectValue");object.Name=name;object.Value=value;object.Parent=parent end
local parent=assert(find("ReplicatedStorage/Assets/Survivors"))
local original=assert(parent:FindFirstChild("Builderman"),"Current Builderman missing")
if original:GetAttribute("BuildermanPortVersion")=="1.0.0"then print("[Builderman] Already installed.");return end
local storage=game:GetService("ServerStorage")
local donor=storage:FindFirstChild("BuildermanUPD")or workspace:FindFirstChild("BuildermanUPD")
assert(donor and donor:FindFirstChild("Config"),"Import BuildermanUPD.rbxm into ServerStorage first.")
assert(donor.Config:FindFirstChild("Dispenser")and donor.Config.Dispenser:FindFirstChildOfClass("Humanoid")and donor.Config.Dispenser:FindFirstChild("Root"),"Donor Dispenser is incomplete. Nothing changed.")
assert(donor.Config:FindFirstChild("Warning")and donor.Config:FindFirstChild("Highlight"),"Donor warning/highlight missing")
assert(original:FindFirstChild("Config")and original.Config:FindFirstChild("Sentry")and original.Config.Sentry:FindFirstChildOfClass("Humanoid")and original.Config.Sentry:FindFirstChild("Root"),"The donor Sentry is empty; a complete existing Sentry is required. Nothing changed.")
assert(original:FindFirstChild("Config")and fingerprint(original.Config.Source)==[========[
11517:9d6b9f12:f11399e7]========],"Current Builderman Config differs. Nothing changed; send its Source for a matching port.")
assert(original:FindFirstChild("Behavior")and fingerprint(original.Behavior.Source)==[========[
45971:731a5c33:e5819f90]========],"Current Builderman Behavior differs. Nothing changed; send its Source for a matching port.")
local prepared=original:Clone();prepared.Name="Builderman";prepared:SetAttribute("BuildermanPortVersion","1.0.0")
local config=donor.Config:Clone()
local empty=config:FindFirstChild("Sentry");if empty then empty:Destroy()end
local sentry=original.Config.Sentry:Clone();sentry.Parent=config
prepared.Config:Destroy();config.Parent=prepared
prepared.Behavior:Destroy()
local behavior=Instance.new("ModuleScript");behavior.Name="Behavior";behavior.Parent=prepared
local ok,err=pcall(function()
config.Source=[========[
local t1 = {
	LMSEffect = {
		ProcessingModule = "BasicLMS",
		SoundId = "heartbeat",
		ImageId = function(_: string) -- line: 6
			return "rbxassetid://127305232864509"
		end,
		PrimaryColor = Color3.fromRGB(255, 0, 0),
		SecondaryColor = Color3.fromRGB(0, 0, 0)
	},
	DisplayName = "Builderman",
	Quote = "\"Welcome to ROBLOX!\"",
	Class = "Support",
	RenderImage = "rbxassetid://84427509230526",
	Price = 500,
	Requests = {
		BuildermanSentry = {
			AbilityName = "Sentry",
			RequestTitle = "Request Sentry",
			NotificationTitle = "PLAYERNAME wants a sentry built!",
			Order = 1
		},
		BuildermanDispenser = {
			AbilityName = "Dispenser",
			RequestTitle = "Request Dispenser",
			NotificationTitle = "PLAYERNAME wants a dispenser built!",
			Order = 2
		}
	},
	Health = 90,
	Speed = 12,
	SentryCooldown = 0,
	SentryDestroyedCooldown = 35,
	SentryConstructionDuration = 6,
	SentryPositionOffset = 4,
	SentryPlacementRadius = 125,
	SentryDamageRadius = 65,
	SentryLimit = 1,
	SentryPingDistance = 999,
	SentryPingDuration = 999,
	SentryHealth = 30,
	SentrySlownessLevel = 2,
	SentryStackedSlownessLevel = 1,
	SentrySlownessDuration = 1,
	SentryDamagePerSec = 3,
	SentryRangeReductionPercentage = 16,
	SentryMinimumRange = 8,
	SentryPickupDebounce = 0.75,
	SentryPickupOffset = CFrame.new(0, 2, -2),
	SentryAnimations = {
		Construction = "rbxassetid://124152696571014",
		Idle = "rbxassetid://124173695158238",
		Shoot = "rbxassetid://114572748729498",
		PickUp = "rbxassetid://108513188967002",
		CarryIdle = "rbxassetid://132789596370235",
		CarryWalk = "rbxassetid://116909049940354",
		PutDown = "rbxassetid://91737263563320"
	},
	DispenserCooldown = 0,
	DispenserDestroyedCooldown = 30,
	DispenserConstructionDuration = 6,
	DispenserPositionOffset = 4,
	DispenserPlacementRadius = 60,
	DispenserHealingRadius = 16,
	DispenserLimit = 1,
	DispenserPingDistance = 999,
	DispenserPingDuration = 999,
	DispenserPickupDebounce = 0.5,
	DispenserPickupOffset = CFrame.new(0, 2, -2),
	DispenserHealth = 15,
	DispenserHealingPerSec = 1,
	DispenserAnimations = {
		Construction = "rbxassetid://74257961315420",
		Idle = "rbxassetid://72409953607244",
		PickUp = "rbxassetid://114452443413930",
		CarryIdle = "rbxassetid://94568983394344",
		CarryWalk = "rbxassetid://103441914715625",
		PutDown = "rbxassetid://90904147606168"
	},
	CarryRange = 7,
 CarryPlacementDuration = 1.15,
 MoveCooldown = 0,
	CarryWalkspeed = 0.9,
	CarryFOVMultiplier = 1.2,
	CarryFOVTweenTime = 3,
	CarryDamageThreshold = 10,
	Instances = {
		SentryTemplate = script.Sentry,
		DispenserTemplate = script.Dispenser,
		WarningTemplate = script.Warning
	},
	HatFixCooldown = 40,
	HatFixBuffDelay = 1.5,
	HatFixRange = 45,
	Expressions = {
		Happy = "rbxassetid://75425376108592",
		Default = "rbxassetid://78927941165959",
		Hurt = "rbxassetid://105173827090865",
		Injured = "rbxassetid://77334993821053",
		Dead = "rbxassetid://88659722034277",
		Drinking = "rbxassetid://83064700049700",
		Concentrating = "rbxassetid://102570873215742"
	},
	Animations = {
		ConstructStart = "rbxassetid://135478644516351",
		ConstructLoop = "rbxassetid://90772467802274",
		ConstructEnd = "rbxassetid://112583398395682",
		HatFix = "rbxassetid://133461474706559",
		PickIdle = "rbxassetid://80928531368570",
		PickUp = "rbxassetid://127053426877374",
		PutDown = "rbxassetid://114628603927215",
		PickWalk = "rbxassetid://84595244279245",
		PickRun = "rbxassetid://84595244279245"
	},
	Emotes = {
		Animations = {
			SpaceOut = {
				DisplayName = "Mini-Sentry",
				RenderImage = "rbxassetid://137941649909292",
				Description = "Mini-Sentry",
				AssetID = "rbxassetid://134055785601306",
				SFX = "rbxassetid://120430993489834",
				CreatedServer = function(p1) -- line: 150
					local _ = p1.Character
					local clone = script.MiniTurret:Clone()

					clone.Parent = p1.Character
					clone.TURRETWELD.Part0 = p1.Character.PrimaryPart
					task.delay(4.166666666666667, function() -- line: 158
						-- upvalues: p1 (copy)
						p1.Character.Hammer.Transparency = 0
					end)
					task.delay(4.5, function() -- line: 163
						-- upvalues: clone (copy)
						for _, child in pairs(clone.Root:GetChildren()) do
							if child:IsA("ParticleEmitter") then
								child:Emit(5)
							end
						end

						for _, child in pairs(clone:GetChildren()) do
							if child:IsA("MeshPart") then
								child.Transparency = 1
							end
						end
					end)
					task.delay(4.833333333333333, function() -- line: 177
						-- upvalues: p1 (copy)
						p1.Character.Hammer.Transparency = 1
						p1.Character.Hammer.CanCollide = false
					end)
				end,
				DestroyedServer = function(p2) -- line: 184
					local Character = p2.Character

					if Character then
						for _, child in pairs(Character:GetChildren()) do
							if child.Name == "EMOTESENTRY" then
								child:Destroy()
							end
						end
					end
				end
			}
		}
	},
	Sounds = {
		SentryBuilding = "rbxassetid://136339052883583",
		SentryIdle = "rbxassetid://92187169647230",
		SentryDestroyed = "rbxassetid://140349478902004",
		SentryTargeted = "rbxassetid://136472646189313",
		SentryCarryTargeted = "rbxassetid://78508818825114",
		SentryShoot = "rbxassetid://85080845610107",
		SentryPutdown = "rbxassetid://2423389966",
		SentryPickup = "rbxassetid://2848703459",
		SentryDropBuild = "rbxassetid://70621498126117",
		BuildingCarryIdle = "rbxassetid://119574803918892",
		DispenserBuilding = "rbxassetid://131280892518899",
		DispenserIdle = "rbxassetid://112621500209552",
		DispenserDestroyed = "rbxassetid://94935842945161",
		DispenserPickup = "rbxassetid://2848703459",
		DispenserPutdown = "rbxassetid://116086162740635",
		DispenserDropBuild = "rbxassetid://72061269121720",
		CarryFootsteps = {
			"rbxassetid://137530774742124",
			"rbxassetid://110776862318861",
			"rbxassetid://93418055666843",
			"rbxassetid://108947057915540"
		}
	},
	TextInteractions = {
		Requests = {
			ElliotPizza = {
				"Looking for a slice of pizza over here.",
				"Could I ask for a slice of pizza?",
				"Hey, pass a slice.",
				"You don't happen to have pizza on you, do you?",
				"A pizza would work great on me right now.. mind if I get one?"
			},
			BuildermanSentry = {
				"Place your sentry here.",
				"Put down a sentry over here.",
				"Over here's a good spot for a sentry.",
				"Build your sentry here. It's good ground.",
				"Put your sentry over here."
			},
			BuildermanBuildermanSentry = {
				"I know imitation is the best form of flattery, but uh-… whatever, put down a sentry here.",
				"Impersonatin' an admin is a bannable offense. If you build a sentry I might change my mind.",
				"It's like lookin' into an uncanny mirror-… ahem, uh.. Put a sentry here, will you?",
				"Build the sentry here. If you're truly me then you'd know it's a good spot.",
				"This spot over here could be good for a sentry. You know that, yeah?"
			},
			BuildermanDispenser = {
				"Here's a good spot for a dispenser.",
				"Good spot for a dispenser here.",
				"Put your dispenser down over here.",
				"The spot over here could be good for a dispenser.",
				"Dispenser could be great if it were put down here."
			},
			BuildermanBuildermanDispenser = {
				"Let's hope your dispenser building skills are as good as your imitation.",
				"If you're really me, then you ought to know that this spot's good for a dispenser.",
				"This spot's pretty good for a dispenser. Don't you think, me?",
				"Put down a dispenser if you're really who you say you are.",
				"You ought to know how to build a dispenser here if you're really the person you're imitating."
			},
			DusekkarProtection = {
				"Need a bit of your magic, Dusekkar!",
				"Need a bit of magic from you, pumpkin.",
				"A force field would do good on me, if that's alright.",
				"Cast some of your magic, pumpkin!",
				"Your magic I could really use right about now, Dusekkar."
			},
			HemmorhageAsk = {
				"Not feeling too good.. can feel myself draining.. I'm gonna need some help.",
				"Lend me a hand for a bit, I'm hurting real' bad...",
				"I'm.. not in a good state here, and I'm gonna need some of your help.",
				"Trying real hard to keep going, but I might need your help for it.",
				"Gonna need some of your help, I don't think I'll last long in this state..."
			},
			HelperPulse = {
				"Quick, HelperBot! Activate your pulse, NOW!",
				"Going to need that energy wave right about now, HelperBot!",
				"Keep it up, HelperBot! Activate the pulse immediately!",
				"Go on then, HelperBot! These people need your power!",
				"Got that energy wave ready yet, HelperBot? 'Cause we'll be needing it soon."
			},
			HelperInspire = {
				"You've got heart, HelperBot. And with that heart, you can INSPIRE.",
				"Give us your support, HelperBot. We'll be needing it right about now.",
				"Give us that help, HelperBot.",
				"We'll be needing that bubble, HelperBot. The sooner the better.",
				"Come on now, don't keep our team waiting. Help us out, HelperBot."
			}
		},
		Thanks = {
			Regular = {
				"Thanks.",
				"Thank you.",
				"Your work is appreciated.",
				"Thank you.",
				"Now that's some good work."
			}
		}
	}
}

t1.Information = {
	{
		Separator = "GENERAL INFO"
	},
	{
		Header = "BUILDERMAN",
		Text = "The big boss of Roblox HQ himself. With a hammer in his inventory and a lot of spare parts and materials to spare, he's able to build contraptions that can either slow the killer's path, or heal those around him. As a promise with Shedletsky, he'll do all he can to help everyone.\n"
	},
	{
		Header = "STATS",
		Text = "Difficulty: ★★★☆☆\n" .. `Health: { t1.Health or 100 }\n` .. `Regular Speed: { t1.Speed or 12 }\n` .. `Sprinting Speed: { t1.SprintSpeed or 26 }\n` .. `Max Stamina: { t1.MaxStamina or 100 }\n` .. `Stamina Loss per sec: { t1.StaminaLoss or 10 }\n` .. `Stamina Gain per sec: { t1.StaminaGain or 20 }\n`
	},
	{
		Separator = "ABILITIES"
	},
	{
		Image = "rbxassetid://104441527277654",
		Header = "SENTRY CONSTRUCTION",
		Quote = "\"These sentries see your enemies so you don't have to!\" - Roblox",
		Text = `Cooldown: { t1.SentryDestroyedCooldown }s after being destroyed by the Killer\n` .. `Sentry Health: { t1.SentryHealth }\n\n` .. `<font color="#ee6700">Builderman</font> takes { t1.SentryConstructionDuration }s to build a <b>Sentry</b> in front of him, which targets nearby Killers and inflicts <b>Slowness II</b> for { t1.SentrySlownessDuration }s onto them.\n\n` .. "<font color=\"#ee6700\">Builderman</font> will be unable to construct a <b>Sentry</b> if it has targeted a Killer within the last 10s.\n\n" .. "The <b>Slowness</b> level is reduced to <b>Slowness I</b> if there is more than one <font color=\"#ee6700\">Builderman</font> alive.\n\n" .. "If <font color=\"#ee6700\">Builderman</font> is attacked while performing this ability, any <b>Sentry</b> that's currently in production by them will be destroyed and the ability will be cancelled.\n\n" .. `<font color="#ee6700">Builderman</font> is only able to build { t1.SentryLimit } <b>Sentry</b> at a time.\n\n` .. `<b>Sentries</b> have a target range of { t1.SentryDamageRadius } studs, which decreases by { t1.SentryRangeReductionPercentage }% for every additional <b>Sentry</b> that's placed in the world.\n` .. `<b>Sentries</b> will always have a target range of at least { t1.SentryMinimumRange } studs no matter what the current target range reduction is.\n\n` .. `Other kinds of buildings cannot be built within { t1.SentryPlacementRadius } studs of any <b>Sentry</b> in the world.\n\n` .. "Using this ability while having built the max amount of <b>Sentries</b> automatically destroys the first active <b>Sentry</b> you placed.\n"
	},
	{
		Image = "rbxassetid://102952736333903",
		Header = "DISPENSER CONSTRUCTION",
		Quote = "\"This is pretty much the best healing potion in any video game ever.\" - Roblox",
		Text = `Cooldown: { t1.DispenserDestroyedCooldown }s after being destroyed by the Killer\n` .. `Dispenser Health: { t1.DispenserHealth }\n\n` .. `<font color="#ee6700">Builderman</font> takes { t1.DispenserConstructionDuration }s to build a <b>Dispenser</b> in front of him, which heals all teammates within { t1.DispenserHealingRadius } studs by { t1.DispenserHealingPerSec } HP/s.\n\n` .. "<font color=\"#ee6700\">Builderman</font> will be unable to construct a <b>Dispenser</b> if it has healed a survivor within the last 10s.\n\n" .. "If <font color=\"#ee6700\">Builderman</font> is attacked while performing this ability, any <b>Dispenser</b> that's currently in production by them will be destroyed and the ability will be cancelled.\n\n" .. `<font color="#ee6700">Builderman</font> is only able to build { t1.DispenserLimit } <b>Dispenser</b> at a time.\n\n` .. `Other kinds of buildings cannot be built within { t1.DispenserPlacementRadius } studs of any <b>Dispenser</b> in the world.\n\n` .. "Using this ability while having built the max amount of <b>Dispensers</b> automatically destroys the first active <b>Dispenser</b> you built.\n"
	},
	{
		Image = "rbxassetid://97983142047580",
		Header = "CARRY",
		Quote = "\"Gotta move that gear up!\" - Roblox Software Engineer",
		Text = "While standing near a constructed <b>Sentry</b> or <b>Dispenser</b>, <font color=\"#ee6700\">Builderman</font> is able to pick up that building and carry it around.\n\n" .. "Pressing the ability button again will place the building back down, and the building will become active again after a short delay.\n\n" .. "While buildings are being carried, they become completely inactive.\n\n" .. "While carrying buildings, <font color=\"#ee6700\">Builderman</font> is slowed down by 10% and is unable to sprint.\n\n" .. `If <font color="#ee6700">Builderman</font> takes { t1.CarryDamageThreshold } or more damage while carrying a building, the building will be destroyed.\n`
	},
	{
		Separator = "CREDITS",
		Text = "Writer: gubblegum, sayso_1230Animator: sayso_1230Renderer: ap_plzFace Artist: ramdom"
	}
}

return t1
]========]
behavior.Source=[========[
local RunService=game:GetService("RunService")
local Impl=require(RunService:IsServer()and script.Server or script.Client)
local Behavior={}
for name,method in Impl do Behavior[name]=method end
local icons={Sentry="104441527277654",Dispenser="102952736333903",Move="97983142047580"}
Behavior.Abilities={}
for order,kind in {"Sentry","Dispenser","Move"}do
 local ability={LayoutOrder=order,KeybindType="AltAbility"..order,Icon="rbxassetid://"..icons[kind],Callback=function(actor,result)return Impl.Use(actor,kind,result)end}
 if kind=="Move"then ability.Name="Carry";ability.SpecialName="Place";ability.SpecialIcon="rbxassetid://109402731902696"
 else ability.CurrentRecharge=0;ability.ChargeDuration=0;ability.RechargeInverted=true end
 Behavior.Abilities[kind]=ability
end
return Behavior
]========]
do local module=Instance.new("ModuleScript");module.Name="Server";module.Parent=behavior;module.Source=[========[
local RunService=game:GetService("RunService")
local Debris=game:GetService("Debris")
local Modules=game.ReplicatedStorage.Modules
local Actors=require(Modules.Actors)
local Util=require(Modules.Util)
local Statuses=require(Modules.Statuses)
local Sounds=require(Modules.Sounds)
local Network=require(Modules.Network)
local Rules=require(script.Parent.Rules)
local Server={}
local buildings={}
local function clock()return workspace:GetServerTimeNow()end
local function alive(rig)
 local hum=rig and rig:FindFirstChildOfClass("Humanoid")
 return rig and rig.Parent and rig.PrimaryPart and hum and hum.Health>0
end
local function active(a)return not a.BuilderDestroyed and alive(a.Rig)end
local function emit(a,name,...)
 if a.Player and a.Player:IsA("Player")then Network:FireClientConnection(a.Player,a.Player.Name..name,"REMOTE_EVENT",...)end
end
local function broadcast(a,name,...)
 if a.Player then Network:FireAllClientConnection(a.Player.Name..name,"REMOTE_EVENT",...)end
end
local function sound(a,key,part,loop)
 local id=a.Config.Sounds and a.Config.Sounds[key]
 if not id or id==""then return end
 local ok,result=pcall(Sounds.Play,Sounds,id,{Parent=part,Looped=loop or false})
 if ok then return result end
end
local function track(a,state,name)
 local id=a.Config[state.kind.."Animations"]and a.Config[state.kind.."Animations"][name]
 if not id then return end
 local ok,result=pcall(Util.LoadAnimationFromID,Util,state.model,id)
 if ok and result then pcall(function()result.Looped=name=="Idle"or name=="CarryIdle"or name=="CarryWalk";result:Play(.1)end);return result end
end
local function stopTrack(value)if value then pcall(function()value:Stop(.1)end)end end
local function killerDamage(rig)
 local stamp=rig:GetAttribute("RecentAttackerTime")
 if type(stamp)~="number"or math.abs(os.clock()-stamp)>.25 then return false end
 local name=rig:GetAttribute("RecentAttacker")
 for _,actor in Actors.CurrentActors do
  if actor.Rig and actor.Rig.Parent==workspace.Players.Killers and (tostring(actor.Player)==name or actor.Rig.Name==name)then return true end
 end
 return false
end
local function count(kind)
 local n=0
 for _,state in buildings do if state.kind==kind and state.phase=="active"and state.model.Parent then n+=1 end end
 return n
end
local function builders()
 local n=0
 for _,a in Actors.CurrentActors do if a.ActorName=="Builderman"and a.Rig.Parent==workspace.Players.Survivors and alive(a.Rig)then n+=1 end end
 return n
end
local function setState(state,phase)
 state.phase=phase
 local m=state.model
 m:SetAttribute("Carrying",phase=="carry")
 m:SetAttribute("Constructed",phase=="active"or phase=="carry")
 m:SetAttribute("Disabled",phase~="active")
 for _,object in m:GetDescendants()do
  if object:IsA("BasePart")then object.Anchored=object==m.PrimaryPart;object.CanCollide=phase=="active"and object:GetAttribute("BuilderOriginalCollide")==true
  elseif object:IsA("ParticleEmitter")or object:IsA("Light")then object.Enabled=phase=="active"and object.Name~="Shoot"end
 end
end
local function tools(a,show)
 for _,object in a.Rig:GetChildren()do if object:IsA("BasePart")and(object.Name:find("Hammer")or object.Name:find("Wrench"))then object.Transparency=show and 0 or 1 end end
end
local function result(a,value)
 local old=a.Rig:FindFirstChild("Result");if old then old:Destroy()end
 local object=Instance.new("StringValue");object.Name="Result";object.Value=value;object.Parent=a.Rig;Debris:AddItem(object,2)
end
local function unlockCast(a)
 if a.BuilderCastSpeed then a.BuilderCastSpeed:Destroy();a.BuilderCastSpeed=nil end
 a:DisableAbilities("BuildermanConstruct",false)
 a.Rig:SetAttribute("PlacementRadius",nil)
 tools(a,false)
 if active(a)and a.ChangeExpression then a:ChangeExpression("Default")end
end
local function clearCarry(a)
 a.CarryingBuilding=nil
 if a.BuilderCarrySpeed then a.BuilderCarrySpeed:Destroy();a.BuilderCarrySpeed=nil end
 if a.Rig then a.Rig:SetAttribute("BuildermanCarrying",nil)end
 emit(a,"ForceDropBuilding")
 if a.Player and a.Player:IsA("Player")then Network:FireClientConnection(a.Player,"DisableSprintingSV","REMOTE_EVENT","CarryingBuilding",false)end
end
local function destroy(a,state,killer)
 if not state or state.phase=="destroyed"then return end
 if a.BuilderCast==state then a.BuilderCast=nil;unlockCast(a);result(a,"failed")end
 if a.CarryingBuilding==state then clearCarry(a)end
 setState(state,"destroyed")
 state.model:SetAttribute("Destroyed",true)
 if state.health then state.health:Disconnect()end
 stopTrack(state.animation)
 if state.loop then state.loop:Destroy();state.loop=nil end
 buildings[state.model]=nil
 if a.Buildings[state.kind]==state then a.Buildings[state.kind]=nil end
 a.DisabledAbilities[state.kind]=nil
 emit(a,"UpdateBuildingAbilityLock",state.kind,"recentactivity",false)
 broadcast(a,"ReplicateDestroyedBuildingAsync",state.kind)
 if killer and active(a)then
  a:SetCooldownOf(state.kind,a.Config[state.kind.."DestroyedCooldown"])
  if a.Player and a.Player:IsA("Player")then
   Actors:IncrementActorStats(a.Player,{Action=state.kind.." was destroyed",RewardType="Survivalist"})
   local value=state.model:GetAttribute(state.kind=="Sentry"and "DamageDealt"or "TotalHealed")or 0
   local points=Rules.Points(state.kind,value)
   if points>0 then Actors:IncrementActorStats(a.Player,{Action=state.kind.." contribution",Money=points,EXP=math.ceil(points*.5)})end
  end
 end
 sound(a,state.kind.."Destroyed",state.model.PrimaryPart)
 for _,part in state.model:GetDescendants()do if part:IsA("BasePart")then part.CanCollide=false;part.CanQuery=false;part.Transparency=1 end end
 Debris:AddItem(state.model,2)
end
local function placement(a,kind,ignore)
 local root=a.Rig.PrimaryPart
 local target=root.CFrame*CFrame.new(0,0,-a.Config[kind.."PositionOffset"])
 local params=RaycastParams.new();params.FilterType=Enum.RaycastFilterType.Exclude;params.RespectCanCollide=true
 params.FilterDescendantsInstances={workspace.Players,ignore or a.Rig}
 local floor=workspace:Raycast(target.Position+Vector3.new(0,1,0),Vector3.new(0,-6,0),params)
 if not floor or floor.Normal.Y<.65 then return nil,"midair"end
 if floor.Instance.Name=="Conveyor"then return nil,"collision"end
 if workspace:Raycast(root.Position,target.Position-root.Position,params)then return nil,"facingWall"end
 for _,state in buildings do
  if state.model~=ignore and state.phase~="destroyed"and state.phase~="carry"and state.model.Parent then
   local radius=a.Config[state.kind.."PlacementRadius"]/2
   if(target.Position-state.model.PrimaryPart.Position).Magnitude<=radius then return nil,"tooClose"end
  end
 end
 local overlap=OverlapParams.new();overlap.FilterType=Enum.RaycastFilterType.Exclude;overlap.RespectCanCollide=true
 overlap.FilterDescendantsInstances={workspace.Players,ignore or a.Rig}
 for _,part in workspace:GetPartBoundsInBox(CFrame.new(target.Position.X,floor.Position.Y+1.75,target.Position.Z),Vector3.new(2.5,2.5,2.5),overlap)do
  if part~=floor.Instance and(part.Transparency<.9 or part.Name=="UnplacableArea")then return nil,"collision"end
 end
 return CFrame.new(target.Position.X,floor.Position.Y,target.Position.Z)*target.Rotation
end
local function groundPivot(model,cf)
 local root=model.PrimaryPart
 local lowest=math.huge
 for _,part in model:GetDescendants()do
  if part:IsA("BasePart")and part.Transparency<1 then
   local rel=root.CFrame:ToObjectSpace(part.CFrame)
   local half=part.Size*.5
   local extent=math.abs(rel.RightVector.Y)*half.X+math.abs(rel.UpVector.Y)*half.Y+math.abs(rel.LookVector.Y)*half.Z
   lowest=math.min(lowest,rel.Position.Y-extent)
  end
 end
 if lowest==math.huge then lowest=-root.Size.Y*.5 end
 model:PivotTo(cf*CFrame.new(0,-lowest+.03,0))
end
local function ready(a,state)
 if state.phase=="destroyed"or not active(a)then return end
 if a.BuilderCast==state then a.BuilderCast=nil;unlockCast(a);result(a,"success")end
 if state.loop then state.loop:Destroy();state.loop=nil end
 stopTrack(state.animation)
 setState(state,"active");state.activeAt=clock()
 state.animation=track(a,state,"Idle")
 state.loop=sound(a,state.kind.."Idle",state.model.PrimaryPart,true)
end
local function construct(a,kind)
 if not active(a)or a.BuilderCast or a.CarryingBuilding then return {Cancelled=true,Reason="carrying"}end
 local old=a.Buildings[kind]
 if old and Rules.ActivityRemaining(old.model:GetAttribute("LastActiveTime"),clock())>0 then return {Cancelled=true,Reason="recentActivity"}end
 if a:IsOnCooldown(kind)then return {Cancelled=true,Reason="cooldown"}end
 local cf,reason=placement(a,kind,old and old.model)
 if not cf then return {Cancelled=true,Reason=reason}end
 if old then destroy(a,old,false)end
 local model=(a.Config[kind.."Template"]or a.Config.Instances[kind.."Template"]):Clone()
 local hum=model:FindFirstChildOfClass("Humanoid")
 model.PrimaryPart=model:FindFirstChild("Root")or model.PrimaryPart
 if not hum or not model.PrimaryPart then model:Destroy();return {Cancelled=true,Reason="unknown"}end
 if not hum:FindFirstChildOfClass("Animator")then Instance.new("Animator",hum)end
 hum.MaxHealth=a.Config[kind.."Health"];hum.Health=hum.MaxHealth;hum.BreakJointsOnDeath=false
 model.Name="Builderman"..kind
 model:SetAttribute("OwnerName",tostring(a.Player));model:SetAttribute("Team","Survivors");model:SetAttribute("HitboxPriority",0)
 model:AddTag("SurvivorConstruct")
 for _,part in model:GetDescendants()do
  if part:IsA("BasePart")then part:SetAttribute("BuilderOriginalCollide",part.CanCollide);part.CanQuery=true end
 end
 groundPivot(model,cf)
 local state={model=model,kind=kind,phase="building",completeAt=clock()+a.Config[kind.."ConstructionDuration"]}
 a.Buildings[kind]=state;buildings[model]=state;a.BuilderCast=state
 setState(state,"building")
 model.Parent=workspace.Map.Ingame
 local previousHealth=hum.Health
 state.health=hum.HealthChanged:Connect(function(value)
  local hurt=value<previousHealth;previousHealth=value
  if value<=0 or hurt and state.phase=="building"then destroy(a,state,killerDamage(model))end
 end)
 local oldResult=a.Rig:FindFirstChild("Result");if oldResult then oldResult:Destroy()end
 a:DisableAbilities("BuildermanConstruct",true)
 a.BuilderCastSpeed=Util:CreateSpeedMultiplier(a.Rig,0,"BuildermanConstruction")
 a.Rig:SetAttribute("PlacementRadius",a.Config[kind.."PlacementRadius"])
 tools(a,true)
 if a.ChangeExpression then a:ChangeExpression("Concentrating")end
 state.animation=track(a,state,"Construction")
 state.loop=sound(a,kind.."Building",model.PrimaryPart,true)
 broadcast(a,"ReplicateBuildingAsync",model,kind)
 for _,other in Actors.CurrentActors do
  if other.Player and other.Player:IsA("Player")and alive(other.Rig)and other.Rig.Parent==workspace.Players.Survivors then
   pcall(Util.RevealPlayerAuraTo,Util,other.Player,model,a.Config[kind.."PingDuration"],Color3.new(.75,1,.75))
  end
 end
 return {Duration=a.Config[kind.."ConstructionDuration"]}
end
local function closest(a)
 local best,range=nil,a.Config.CarryRange
 for _,state in a.Buildings do
  if state.phase=="active"and state.model.Parent then
   local distance=(state.model.PrimaryPart.Position-a.Rig.PrimaryPart.Position).Magnitude
   if distance<=range then best=state;range=distance end
  end
 end
 return best
end
local function move(a)
 if not active(a)or a.BuilderCast then return "noBuilding"end
 if a.MoveReadyAt and clock()<a.MoveReadyAt then return "cooldown"end
 local state=a.CarryingBuilding
 if state then
  local cf,reason=placement(a,state.kind,state.model)
  if not cf then return reason end
  clearCarry(a)
  groundPivot(state.model,cf)
  setState(state,"placing");state.completeAt=clock()+a.Config.CarryPlacementDuration
  stopTrack(state.animation);state.animation=track(a,state,"PutDown")
  sound(a,state.kind.."Putdown",state.model.PrimaryPart)
  a.MoveReadyAt=clock()+a.Config.CarryPlacementDuration
  a:SetCooldownOf("Move",a.Config.CarryPlacementDuration)
  return false
 end
 state=closest(a)
 if not state then return "noBuilding"end
 a.CarryingBuilding=state
 setState(state,"carry")
 if state.loop then state.loop:Destroy();state.loop=nil end
 stopTrack(state.animation);state.animation=track(a,state,"PickUp");state.carryAnimReady=clock()+a.Config[state.kind.."PickupDebounce"];state.walking=nil
 a.BuilderCarrySpeed=Util:CreateSpeedMultiplier(a.Rig,a.Config.CarryWalkspeed,"CarryingBuilding")
 a.Rig:SetAttribute("BuildermanCarrying",true)
 if a.Player and a.Player:IsA("Player")then Network:FireClientConnection(a.Player,"DisableSprintingSV","REMOTE_EVENT","CarryingBuilding",true)end
 state.model:PivotTo(a.Rig.PrimaryPart.CFrame*a.Config[state.kind.."PickupOffset"])
 a.MoveReadyAt=clock()+a.Config[state.kind.."PickupDebounce"]
 a:SetCooldownOf("Move",a.Config[state.kind.."PickupDebounce"])
 sound(a,state.kind.."Pickup",state.model.PrimaryPart)
 return state.model
end
local function lineOfSight(state,target)
 local params=RaycastParams.new();params.FilterType=Enum.RaycastFilterType.Exclude
 local excluded={workspace.Players.Survivors}
 for _,entry in buildings do table.insert(excluded,entry.model)end
 params.FilterDescendantsInstances=excluded
 local origin=state.model.PrimaryPart.Position
 local hit=workspace:Raycast(origin,target.PrimaryPart.Position-origin,params)
 return not hit or hit.Instance:IsDescendantOf(target)
end
local function tickBuilding(a,state,dt)
 if state.phase=="destroyed"then return end
 if not state.model.Parent then destroy(a,state,false);return end
 if state.phase=="building"or state.phase=="placing"then
  if clock()>=state.completeAt then ready(a,state)end
  return
 end
 if state.phase=="carry"then
  state.model:PivotTo(a.Rig.PrimaryPart.CFrame*a.Config[state.kind.."PickupOffset"])
  if clock()>=(state.carryAnimReady or 0)then
   local walking=a.Rig.PrimaryPart.AssemblyLinearVelocity.Magnitude>1
   if state.walking~=walking then
    state.walking=walking;stopTrack(state.animation);state.animation=track(a,state,walking and "CarryWalk"or "CarryIdle")
   end
  end
  return
 end
 dt=math.min(dt,math.max(0,clock()-(state.activeAt or clock())))
 if dt<=0 then return end
 local n=count(state.kind)
 state.model:SetAttribute("BuildingCount",n)
 local radius=Rules.EffectRadius(a.Config,state.kind,n)
 state.model:SetAttribute("EffectRadiusSize",radius)
 if state.kind=="Sentry"then
  local nearest,distance=nil,radius
  for _,other in Actors.CurrentActors do
   if alive(other.Rig)and other.Rig.Parent==workspace.Players.Killers then
    local d=(other.Rig.PrimaryPart.Position-state.model.PrimaryPart.Position).Magnitude
    if d<=distance and lineOfSight(state,other.Rig)then nearest=other;distance=d end
   end
  end
  if nearest then
   local hum=nearest.Rig:FindFirstChildOfClass("Humanoid")
   local damage=math.min(hum.Health,a.Config.SentryDamagePerSec*dt)
   hum.Health-=damage
   if damage>0 then
    state.model:SetAttribute("DamageDealt",(state.model:GetAttribute("DamageDealt")or 0)+damage)
    state.model:SetAttribute("LastActiveTime",clock())
    Statuses:ApplyStatus(nearest.Rig,"Slowness",{Level=Rules.SlowLevel(a.Config,builders()),Duration=a.Config.SentrySlownessDuration})
    if not state.nextShotSound or clock()>=state.nextShotSound then sound(a,"SentryShoot",state.model.PrimaryPart);state.nextShotSound=clock()+.2 end
   end
  end
 else
  for _,other in Actors.CurrentActors do
   if alive(other.Rig)and other.Rig.Parent==workspace.Players.Survivors and(other.Rig.PrimaryPart.Position-state.model.PrimaryPart.Position).Magnitude<=radius then
    local hum=other.Rig:FindFirstChildOfClass("Humanoid")
    if hum.Health<hum.MaxHealth and not hum:GetAttribute("Clanker")then
     local before=hum.Health;Util:Heal(hum,a.Config.DispenserHealingPerSec*dt)
     local healed=math.max(0,hum.Health-before)
     if healed>0 then state.model:SetAttribute("TotalHealed",(state.model:GetAttribute("TotalHealed")or 0)+healed);state.model:SetAttribute("LastActiveTime",clock())end
    end
   end
  end
 end
end
function Server.Created(_,a)
 a.BuilderDestroyed=false;a.Buildings={};a.DisabledAbilities=a.DisabledAbilities or {};a.BuilderConnections={}
 a.Rig:SetAttribute("IsBuilderman",true)
 local hum=a.Rig:FindFirstChildOfClass("Humanoid");local health=hum.Health
 table.insert(a.BuilderConnections,hum.HealthChanged:Connect(function(value)
  local damage=health-value;health=value
  if a.BuilderCast and damage>0 then destroy(a,a.BuilderCast,false)end
  if a.CarryingBuilding and damage>=a.Config.CarryDamageThreshold then destroy(a,a.CarryingBuilding,killerDamage(a.Rig))end
  if value<=0 then Server.Destroyed(nil,a)end
 end))
 local accumulator=0
 table.insert(a.BuilderConnections,RunService.Heartbeat:Connect(function(dt)
  if not active(a)then Server.Destroyed(nil,a);return end
  for _,state in table.clone(a.Buildings)do
   if (state.phase=="building"or state.phase=="placing")and clock()>=state.completeAt then ready(a,state)end
  end
  accumulator+=dt;if accumulator<.1 then return end
  local elapsed=accumulator;accumulator=0
  for _,state in table.clone(a.Buildings)do tickBuilding(a,state,elapsed)end
  for _,kind in {"Sentry","Dispenser"}do
   local state=a.Buildings[kind]
   local locked=state and Rules.ActivityRemaining(state.model:GetAttribute("LastActiveTime"),clock())>0 or false
   if a.DisabledAbilities[kind]~=locked then a.DisabledAbilities[kind]=locked;emit(a,"UpdateBuildingAbilityLock",kind,"recentactivity",locked)end
  end
  local selected=a.CarryingBuilding or closest(a)
  if a.BuilderClosest~=selected then a.BuilderClosest=selected;emit(a,"UpdateClosestBuilding",selected and selected.model or nil)end
  if a.CarryingBuilding then local canPlace=placement(a,a.CarryingBuilding.kind,a.CarryingBuilding.model)~=nil;emit(a,"UpdateCanPlace",canPlace)end
 end))
end
function Server.Use(a,kind)
 if kind=="Move"then return move(a)end
 local response=construct(a,kind)
 if response and response.Cancelled then emit(a,"ConstructionRejected",response.Reason)end
 return response
end
function Server.Destroyed(_,a)
 if a.BuilderDestroyed then return end
 a.BuilderDestroyed=true
 for _,connection in a.BuilderConnections or {}do connection:Disconnect()end
 for _,state in table.clone(a.Buildings or {})do destroy(a,state,false)end
 clearCarry(a);unlockCast(a)
 a.DisabledAbilities.Sentry=nil;a.DisabledAbilities.Dispenser=nil
end
return Server
]========] end
do local module=Instance.new("ModuleScript");module.Name="Client";module.Parent=behavior;module.Source=[========[


local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")

game:GetService("Players")

local t1 = {}

require(game.ReplicatedStorage.Modules.AchievementUtil)
require(game.ReplicatedStorage.Modules.Sounds)

local Util = require(game.ReplicatedStorage.Modules.Util)

require(game.ReplicatedStorage.Modules.Hitboxes)
require(game.ReplicatedStorage.Modules.Statuses)

local Network = require(game.ReplicatedStorage.Modules.Network)
local trove = require(game.ReplicatedStorage.Modules.Misc.Trove)
local Spring = require(game.ReplicatedStorage.Modules.Misc.Spring)
local u8 = false
local t2 = {
 carrying="Place your carried building before constructing another.",
	collision = "Building area is obstructed by something. Build somewhere else.",
	tooClose = "Building area is too close to a pre-existing building. Move further away and try again.",
	midair = "Building area is too high above ground. Turn around and try again.",
	facingWall = "You're too close to a wall. Turn around and try again.",
	recentActivity = "That building is active. Wait a moment before replacing it.",
	cooldown = "That building is recharging. Try again in a moment.",
	unknown = "Something went wrong. Try building somewhere else.",
	noBuilding = "Stand near one of your buildings to pick it up!"
}

local function getServerTime() -- line: 37
	return workspace:GetServerTimeNow()
end
local function getBuildingRecentActivityRemaining(p1) -- line: 60
	if not p1 or p1:GetAttribute("Destroyed") then
		return 0
	end

	local LastActiveTime = p1:GetAttribute("LastActiveTime")

	if typeof(LastActiveTime) ~= "number" then
		return 0
	end

	return (math.max(0, 10 - (workspace:GetServerTimeNow() - LastActiveTime)))
end
local function setBuildingAbilityLock(p2, s1: string, s2: string, b1: boolean, _: number?) -- line: 119
	-- upvalues: Util (copy)
	if p2.Player == game.Players.LocalPlayer then
		Util:ToggleLockForAbilityIcon(s1, s2, b1)
	end
end
local function initClientSentryAiming(p3) -- line: 153
	-- upvalues: u8 (ref), trove (copy), Spring (copy), CollectionService (copy), Util (copy), RunService (copy)
	if u8 then
		return
	end

	u8 = true

	local function setupSentry(p4) -- line: 164
		-- upvalues: trove (copy), Spring (copy), CollectionService (copy), p3 (copy), Util (copy), RunService (copy)
		if not p4.Name:find("Sentry") then
			return
		end

		local v106 = trove.new()
		local raycastParams = RaycastParams.new()

		raycastParams.FilterType = Enum.RaycastFilterType.Exclude

		local Torso = p4:WaitForChild("Torso", 10)
		local Head = p4:WaitForChild("Head", 10)

		if not Torso or not Head then
			return
		end

		local Neck = Torso:WaitForChild("Neck", 10)

		if not Neck then
			return
		end

		local NeckC0 = Neck.C0
		local u112 = Spring.new(NeckC0, 0.25)

		v106:Add(task.spawn(function() -- line: 189
			-- upvalues: p4 (copy), CollectionService (copy), raycastParams (copy), p3 (copy), Util (copy), Head (copy), Torso (copy), u112 (ref), NeckC0 (ref)
			while p4.Parent do
				if p4:GetAttribute("Destroyed") or not p4.PrimaryPart then
					task.wait(0.2)

					continue
				end

				if not p4:GetAttribute("Constructed") then
					task.wait(0.2)

					continue
				end

				if p4:GetAttribute("Disabled") and not p4:GetAttribute("Carrying") then
					task.wait(0.2)

					continue
				end

				local t3 = {
					p4,
					workspace.Players.Survivors
				}

				for _, v179 in CollectionService:GetTagged("SurvivorConstruct") do
					table.insert(t3, v179)
				end

				raycastParams.FilterDescendantsInstances = t3

				local v180 = (p4:GetAttribute("BuildingCount") or 1) - 1
				local v181 = p3.Config.SentryDamageRadius / 2
				local v182 = math.clamp(v181 * (1 - v180 * p3.Config.SentryRangeReductionPercentage / 100), p3.Config.SentryMinimumRange, v181)
				local ClosestPlayerFromPosition = Util:GetClosestPlayerFromPosition(p4.PrimaryPart.Position, {
					PlayerSelection = "Killers",
					MaxDistance = v182
				})

				if ClosestPlayerFromPosition and ClosestPlayerFromPosition.PrimaryPart and ClosestPlayerFromPosition.Humanoid.Health > 0 then
					local PrimaryPartPosition = p4.PrimaryPart.Position
					local LookVector = CFrame.lookAt(PrimaryPartPosition, ClosestPlayerFromPosition.PrimaryPart.Position).LookVector
					local raycastResult = workspace:Raycast(PrimaryPartPosition, LookVector * v182, raycastParams)

					if not raycastResult or not raycastResult.Instance:IsDescendantOf(ClosestPlayerFromPosition) then
						task.wait(0.2)

						continue
					end

					local function worldCFrameToC0ObjectSpace(p5, p6) -- line: 231
						local Part1CFrame = p5.Part1.CFrame
						local p5C1 = p5.C1
						local p5C0 = p5.C0
						local v213 = p5C0 * p5C1:Inverse() * Part1CFrame:Inverse() * p6 * p5C1

						return v213 - v213.Position + p5C0.Position
					end

					local cFrame = CFrame.lookAt(Head.Position, ClosestPlayerFromPosition.PrimaryPart.Position, Torso.CFrame.UpVector)
					local Neck2 = Torso.Neck
					local Part1CFrame = Neck2.Part1.CFrame
					local Neck2C1 = Neck2.C1
					local Neck2C0 = Neck2.C0
					local v193 = Neck2C0 * Neck2C1:Inverse() * Part1CFrame:Inverse() * cFrame * Neck2C1

					u112.Target = (v193 - v193.Position + Neck2C0.Position) * CFrame.Angles(-1.5707963267948966, 0, 0)

					if not p4:GetAttribute("Carrying") then
						for _, descendant in pairs(p4:GetDescendants()) do
							if (descendant:IsA("ParticleEmitter") or descendant:IsA("Light")) and descendant.Name == "Shoot" then
								task.spawn(function() -- line: 253
									-- upvalues: descendant (copy)
									descendant.Enabled = true
									task.wait(0.05)
									descendant.Enabled = false
								end)
							end
						end
					end
				else
					u112.Target = NeckC0
				end

				task.wait(0.2)
			end
		end))
		v106:Connect(RunService.RenderStepped, function(n2: number) -- line: 269
			-- upvalues: Neck (copy), u112 (ref)
			if Neck.Parent then
				Neck.C0 = u112:Update(n2)
			end
		end)
		p4.AncestryChanged:Connect(function(_, parent) -- line: 275
			-- upvalues: v106 (copy)
			if not parent then
				v106:Destroy()
			end
		end)
	end

	for _, v31 in CollectionService:GetTagged("SurvivorConstruct") do
		task.spawn(setupSentry, v31)
	end

	CollectionService:GetInstanceAddedSignal("SurvivorConstruct"):Connect(setupSentry)
end
local function cl_tweenCarryFOV(p8, b2: boolean) -- line: 678
	-- upvalues: Util (copy)
	if not p8.Rig then
		return
	end

	if p8.CarryFOVTween then
		p8.CarryFOVTween:Cancel()
		p8.CarryFOVTween = nil
	end

	if not p8.CarryFOVMultiplier or not p8.CarryFOVMultiplier.Parent then
		p8.CarryFOVMultiplier = Util:CreateFOVMultiplier(p8.Rig, 1, "BuildermanCarryFOV")
	end

	local v34 = game.TweenService:Create(p8.CarryFOVMultiplier, TweenInfo.new(p8.Config.CarryFOVTweenTime or 2.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
		Value = not b2 and 1 or (p8.Config.CarryFOVMultiplier or 1.1)
	})

	p8.CarryFOVTween = v34
	v34.Completed:Connect(function() -- line: 699
		-- upvalues: p8 (copy), v34 (copy), b2 (copy)
		if p8.CarryFOVTween == v34 then
			p8.CarryFOVTween = nil

			if not b2 then
				if p8.CarryFOVMultiplier and p8.CarryFOVMultiplier.Parent then
					p8.CarryFOVMultiplier:Destroy()
				end

				p8.CarryFOVMultiplier = nil
			end
		end
	end)
	v34:Play()
end
local function cl_dropBuilding(p9) -- line: 714
	-- upvalues: t1 (copy), cl_tweenCarryFOV (copy), Util (copy)
	local Move = t1.Abilities.Move
	local v37 = p9.Behavior and (p9.Behavior.Abilities and p9.Behavior.Abilities.Move)

	if v37 and Move then
		v37.Icon = Move.Icon
		v37.Name = Move.Name
	end

	p9.CarryingBuilding = nil
	cl_tweenCarryFOV(p9, false)
	
	Util:ToggleLockForAbilityIcon("Move", "invalidplacement", false)
end
local function safeAnimation(actor,name,playing)
 local track=actor.Animations and actor.Animations[name]
 if track then pcall(function()if playing then track:Play(.1)else track:Stop(.1)end end)end
end
local function constructBuildingOnClient(actor,kind,response)
 if type(response)=="table"and response.Cancelled then
  Util:CreateWarning("BuildermanWarning",t2[response.Reason]or t2.unknown,actor.Config.Instances.WarningTemplate)
  return
 end
 local duration=type(response)=="table"and response.Duration or actor.Config[kind.."ConstructionDuration"]
 local progress=Util:CreateProgressBar("Building "..kind,duration)
 local token={}
 actor.BuilderConstructionVisual=token
 safeAnimation(actor,"ConstructStart",true)
 task.delay(.75,function()
  if actor.BuilderConstructionVisual==token then safeAnimation(actor,"ConstructStart",false);safeAnimation(actor,"ConstructLoop",true)end
 end)
 local deadline=os.clock()+duration+1
 task.spawn(function()
  while actor.Rig.Parent and os.clock()<deadline and actor.BuilderConstructionVisual==token do
   if actor.Rig:FindFirstChild("Result")then break end
   task.wait(.05)
  end
  progress:Destroy()
  if actor.BuilderConstructionVisual==token then
   actor.BuilderConstructionVisual=nil
   safeAnimation(actor,"ConstructStart",false);safeAnimation(actor,"ConstructLoop",false)
   if actor.Rig.Parent then safeAnimation(actor,"ConstructEnd",true)end
  end
 end)
end
local function cl_setBuildingPlacedText(p13, s3: string, b3: boolean) -- line: 1020
	if p13.Player ~= game.Players.LocalPlayer then
		return
	end

	local AbilityContainer = p13.Player.PlayerGui.MainUI:FindFirstChild("AbilityContainer")
	local v50 = AbilityContainer and AbilityContainer:FindFirstChild(s3)

	if not v50 then
		return
	end

	v50.Charges.Text = not b3 and "" or "PLACED"
end
local function cl_watchBuildingActivityLock(p14, p15, s4: string) -- line: 1029
	-- upvalues: Util (copy)
	p14.BuildingActivityLockTokens = p14.BuildingActivityLockTokens or {}

	local t4 = {}

	p14.BuildingActivityLockTokens[s4] = t4

	local t5 = {}

	local function cleanup() -- line: 1036
		-- upvalues: t5 (copy)
		for _, v in pairs(t5) do
			v:Disconnect()
		end

		table.clear(t5)
	end
	local function refresh() -- line: 1043
		-- upvalues: p14 (copy), s4 (copy), t4 (copy), t5 (copy), p15 (copy), Util (copy), refresh (copy)
		if p14.BuildingActivityLockTokens[s4] ~= t4 then
			for _, v in pairs(t5) do
				v:Disconnect()
			end

			table.clear(t5)

			return
		end

		local v117 = p15
		local n3

		if not v117 or v117:GetAttribute("Destroyed") then
			n3 = 0
		else
			local LastActiveTime = v117:GetAttribute("LastActiveTime")

			n3 = if typeof(LastActiveTime) == "number" then math.max(0, 10 - (workspace:GetServerTimeNow() - LastActiveTime)) else 0
		end

		local v120 = n3 > 0
		local v121 = p14
		local v122 = s4

		if v121.Player == game.Players.LocalPlayer then
			Util:ToggleLockForAbilityIcon(v122, "recentactivity", v120)
		end

		if v120 then
			task.delay(n3 + 0.05, refresh)
		end
	end

	table.insert(t5, p15:GetAttributeChangedSignal("LastActiveTime"):Connect(refresh))
	table.insert(t5, p15:GetAttributeChangedSignal("Destroyed"):Connect(refresh))
	table.insert(t5, p15.AncestryChanged:Connect(function(_, parent) -- line: 1060
		-- upvalues: p14 (copy), s4 (copy), t4 (copy), Util (copy), t5 (copy)
		if parent then
			return
		end

		if p14.BuildingActivityLockTokens[s4] == t4 then
			p14.BuildingActivityLockTokens[s4] = nil

			local v125 = p14
			local v126 = s4

			if v125.Player == game.Players.LocalPlayer then
				Util:ToggleLockForAbilityIcon(v126, "recentactivity", false)
			end

			local v127 = p14
			local v128 = s4

			if v127.Player == game.Players.LocalPlayer then
				local AbilityContainer = v127.Player.PlayerGui.MainUI:FindFirstChild("AbilityContainer")
				local v130 = AbilityContainer and AbilityContainer:FindFirstChild(v128)

				if v130 then
					v130.Charges.Text = ""
				end
			end
		end

		for _, v in pairs(t5) do
			v:Disconnect()
		end

		table.clear(t5)
	end))

	if t4 ~= p14.BuildingActivityLockTokens[s4] then
		for _, v in pairs(t5) do
			v:Disconnect()
		end

		table.clear(t5)

		return
	end

	local n4

	if not p15 or p15:GetAttribute("Destroyed") then
		n4 = 0
	else
		local LastActiveTime = p15:GetAttribute("LastActiveTime")

		n4 = if typeof(LastActiveTime) == "number" then math.max(0, 10 - (workspace:GetServerTimeNow() - LastActiveTime)) else 0
	end

	local v62 = n4 > 0

	if p14.Player == game.Players.LocalPlayer then
		Util:ToggleLockForAbilityIcon(s4, "recentactivity", v62)
	end

	if v62 then
		task.delay(n4 + 0.05, refresh)
	end
end
local function cl_updateBuildingActivityBars(p17) -- line: 1077
	local v64 = p17.Behavior and p17.Behavior.Abilities

	if not v64 then
		return
	end

	for _, v in ipairs({
		"Sentry",
		"Dispenser"
	}) do
		local v67 = v64[v]

		if v67 then
			local v68 = p17.Buildings and p17.Buildings[v]
			local n5

			if not v68 or v68:GetAttribute("Destroyed") then
				n5 = 0
			else
				local LastActiveTime = v68:GetAttribute("LastActiveTime")

				n5 = if typeof(LastActiveTime) == "number" then math.max(0, 10 - (workspace:GetServerTimeNow() - LastActiveTime)) else 0
			end

			if n5 > 0 then
				v67.CurrentRecharge = 10 - n5
				v67.ChargeDuration = 10
			else
				v67.CurrentRecharge = 0
				v67.ChargeDuration = 0
			end
		end
	end
end
local function updateBuildingCarryVisual(p18) -- line: 1101
	local PlayerAura = p18:FindFirstChild("PlayerAura")

	if not PlayerAura then
		return
	end

	if p18:GetAttribute("Carrying") then
		PlayerAura.FillColor = Color3.fromRGB(153, 134, 48)
		PlayerAura.OutlineColor = Color3.fromRGB(255, 220, 50)

		if p18:GetAttribute("OwnerName") == tostring(game.Players.LocalPlayer) then
			PlayerAura.Enabled = false

			return
		end
	else
		PlayerAura.Enabled = true
		PlayerAura.FillColor = Color3.fromRGB(102, 134, 102)
		PlayerAura.OutlineColor = Color3.fromRGB(191, 255, 191)
	end
end

t1.Abilities = {
	Sentry = {
		LayoutOrder = 1,
		KeybindType = "AltAbility1",
		Icon = "rbxassetid://104441527277654",
		CurrentRecharge = 0,
		ChargeDuration = 0,
		RechargeInverted = true,
		Callback = function(p19, p20) -- line: 1129
			-- upvalues: constructBuildingOnClient (copy)
			constructBuildingOnClient(p19, "Sentry", p20)
		end
	},
	Dispenser = {
		LayoutOrder = 2,
		KeybindType = "AltAbility2",
		Icon = "rbxassetid://102952736333903",
		CurrentRecharge = 0,
		ChargeDuration = 0,
		RechargeInverted = true,
		Callback = function(p21, p22) -- line: 1260
			-- upvalues: constructBuildingOnClient (copy)
			constructBuildingOnClient(p21, "Dispenser", p22)
		end
	},
	Move = {
		LayoutOrder = 3,
		KeybindType = "AltAbility3",
		Icon = "rbxassetid://97983142047580",
		Name = "Carry",
		SpecialName = "Place",
		SpecialIcon = "rbxassetid://109402731902696",
		Callback = function(p23, p24) -- line: 1353
			-- upvalues: t2 (copy), Util (copy), t1 (copy), cl_tweenCarryFOV (copy), Network (copy), cl_dropBuilding (copy)
			if typeof(p24) == "string" then
				local v79 = t2[p24] or "Something went wrong. Try building somewhere else."

				Util:CreateWarning("BuildermanWarning", v79, p23.Config.Instances.WarningTemplate)

				return
			end

			if typeof(p24) == "Instance" then
				if p23.CarryableBuildingHighlight then
					p23.CarryableBuildingHighlight.Adornee = nil
				end

				p23.CarryingBuilding = p24

				local Move = t1.Abilities.Move
				local v81 = p23.Behavior and (p23.Behavior.Abilities and p23.Behavior.Abilities.Move)

				if v81 and Move then
					v81.Icon = Move.SpecialIcon
					v81.Name = Move.SpecialName
				end

				cl_tweenCarryFOV(p23, true)
				
				p23.AnimationType = "Pick"
				Network:FireConnection("DisableSprinting", "CarryingBuilding", true)

                safeAnimation(p23,"PickUp",true)

			else
				p23.AnimationType = nil
				Network:FireConnection("DisableSprinting", "CarryingBuilding", false)

                safeAnimation(p23,"PutDown",true)

				cl_dropBuilding(p23)
			end
		end
	}
}

function t1.Created(_, p26) -- line: 1527
	-- upvalues: trove (copy), updateBuildingCarryVisual (copy), Network (copy), Util (copy), cl_dropBuilding (copy), initClientSentryAiming (copy), cl_watchBuildingActivityLock (copy), RunService (copy), cl_updateBuildingActivityBars (copy), cl_tweenCarryFOV (copy)
	p26.CarryingBuilding = nil
	p26.CarryableBuilding = nil

	if p26.Rig then
		p26.Rig:SetAttribute("IsBuilderman", true)
	end

	if p26.Rig == game.Players.LocalPlayer.Character then
		p26.RadiusStorages = {}
		p26.CarryableBuildingHighlight = Instance.new("SelectionBox")
		p26.CarryableBuildingHighlight.Color3 = Color3.fromRGB(255, 220, 50)
		p26.CarryableBuildingHighlight.LineThickness = 0.05
		p26.CarryableBuildingHighlight.SurfaceTransparency = 0.8
		p26.CarryableBuildingHighlight.Parent = script

		local function createRadiusStorage(p27, p28) -- line: 1590
			-- upvalues: p26 (copy)
			local Model = Instance.new("Model")

			Model.Parent = workspace.Map.Ingame
			Model.Name = p27
			p26.RadiusStorages[p27] = Model

			local Highlight = Instance.new("Highlight")

			Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
			Highlight.FillTransparency = 0.875
			Highlight.OutlineTransparency = 0.6
			Highlight.FillColor = p28
			Highlight.Parent = Model
		end

		local color3 = Color3.fromRGB(70, 155, 255)
		local Model = Instance.new("Model")

		Model.Parent = workspace.Map.Ingame
		Model.Name = "PlacementRange"
		p26.RadiusStorages.PlacementRange = Model

		local Highlight = Instance.new("Highlight")

		Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
		Highlight.FillTransparency = 0.875
		Highlight.OutlineTransparency = 0.6
		Highlight.FillColor = color3
		Highlight.Parent = Model

		local color3_2 = Color3.fromRGB(255, 80, 80)
		local Model2 = Instance.new("Model")

		Model2.Parent = workspace.Map.Ingame
		Model2.Name = "BuildermanSentryEffectRange"
		p26.RadiusStorages.BuildermanSentryEffectRange = Model2

		local Highlight2 = Instance.new("Highlight")

		Highlight2.DepthMode = Enum.HighlightDepthMode.Occluded
		Highlight2.FillTransparency = 0.875
		Highlight2.OutlineTransparency = 0.6
		Highlight2.FillColor = color3_2
		Highlight2.Parent = Model2

		local color3_3 = Color3.fromRGB(80, 255, 80)
		local Model3 = Instance.new("Model")

		Model3.Parent = workspace.Map.Ingame
		Model3.Name = "BuildermanDispenserEffectRange"
		p26.RadiusStorages.BuildermanDispenserEffectRange = Model3

		local Highlight3 = Instance.new("Highlight")

		Highlight3.DepthMode = Enum.HighlightDepthMode.Occluded
		Highlight3.FillTransparency = 0.875
		Highlight3.OutlineTransparency = 0.6
		Highlight3.FillColor = color3_3
		Highlight3.Parent = Model3

		local function createRadius(p29, p30) -- line: 1608
			-- upvalues: p26 (copy)
			local v139 = p26.RadiusStorages[p29]

			if not v139 then
				return
			end

			if not p30 then
				return
			end

			local Part = Instance.new("Part")

			Part.CanCollide = false
			Part.Anchored = true
			Part.Transparency = 1
			Part.Position = Vector3.new(0, -100, 0)
			Part.Orientation = Vector3.new(0, 0, 90)
			Part.Size = Vector3.new(0.25, p30, p30)
			Part.Material = Enum.Material.Glass
			Part.Shape = Enum.PartType.Cylinder
			Part.Parent = v139

			return Part
		end

		p26.BuildingVisualTroves = p26.BuildingVisualTroves or {}
		p26.Connection = workspace.Map.Ingame.ChildAdded:Connect(function(child) -- line: 1626
			-- upvalues: p26 (copy), trove (copy), updateBuildingCarryVisual (copy), createRadius (copy)
			if child.Name:find("Builderman") then
				local Humanoid = child:WaitForChild("Humanoid", 10)

				if not Humanoid then
					return
				end

				local Root = child:WaitForChild("Root", 10)

				if not Root then
					return
				end

				child:SetAttribute("ClientCarryWatcherSet", true)

				if p26.BuildingVisualTroves[child] then
					p26.BuildingVisualTroves[child]:Destroy()
				end

				local v144 = trove.new()

				p26.BuildingVisualTroves[child] = v144
				task.spawn(function() -- line: 1641
					-- upvalues: child (copy), updateBuildingCarryVisual (copy)
					if child:WaitForChild("PlayerAura", 10) then
						updateBuildingCarryVisual(child)
					end
				end)

				local t6 = {
					BuildermanSentryPlacementRange = p26.Config.SentryPlacementRadius,
					BuildermanSentryEffectRange = p26.Config.SentryDamageRadius,
					BuildermanDispenserPlacementRange = p26.Config.DispenserPlacementRadius,
					BuildermanDispenserEffectRange = p26.Config.DispenserHealingRadius
				}
				local v146 = `{ child.Name }PlacementRange`
				local v147 = `{ child.Name }EffectRange`
				local v148 = createRadius("PlacementRange", t6[v146])
				local v149 = createRadius(v147, t6[v147])

				if v148 then
					v144:Add(v148)
				end

				if v149 then
					v144:Add(v149)
				end

				local function syncRadiusPositions() -- line: 1662
					-- upvalues: v148 (copy), Root (copy), v149 (copy)
					if v148 then
						v148.Position = Root.Position - Vector3.new(0, Root.Size.Y / 2 + 0.075, 0)
					end

					if v149 then
						v149.Position = Root.Position - Vector3.new(0, Root.Size.Y / 2, 0)
					end
				end

				v144:Connect(Root:GetPropertyChangedSignal("Position"), syncRadiusPositions)
				v144:Connect(child:GetAttributeChangedSignal("EffectRadiusSize"), function() -- line: 1668
					-- upvalues: child (copy), v149 (copy)
					if child:GetAttribute("Destroyed") or child:GetAttribute("Carrying") then
						return
					end

					local EffectRadiusSize = child:GetAttribute("EffectRadiusSize")

					if v149 then
						game.TweenService:Create(v149, TweenInfo.new(1), {
							Size = Vector3.new(0.25, EffectRadiusSize * 2, EffectRadiusSize * 2)
						}):Play()
					end
				end)
				v144:Connect(child:GetAttributeChangedSignal("Carrying"), function() -- line: 1677
					-- upvalues: child (copy), updateBuildingCarryVisual (copy), v148 (copy), v149 (copy), Root (copy), t6 (copy), v147 (copy), v146 (copy)
					if child:GetAttribute("Destroyed") then
						return
					end

					updateBuildingCarryVisual(child)

					if child:GetAttribute("Carrying") then
						if v148 then
							game.TweenService:Create(v148, TweenInfo.new(0.5), {
								Size = Vector3.new(0, 0, 0)
							}):Play()
						end

						if v149 then
							game.TweenService:Create(v149, TweenInfo.new(0.5), {
								Size = Vector3.new(0, 0, 0)
							}):Play()

							return
						end
					else
						if v148 then
							v148.Position = Root.Position - Vector3.new(0, Root.Size.Y / 2 + 0.075, 0)
						end

						if v149 then
							v149.Position = Root.Position - Vector3.new(0, Root.Size.Y / 2, 0)
						end

						local v200 = child:GetAttribute("EffectRadiusSize") or t6[v147]
						local v201 = t6[v146]
						local tweenInfo = TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

						if v149 then
							game.TweenService:Create(v149, tweenInfo, {
								Size = Vector3.new(0.25, v200 * 2, v200 * 2)
							}):Play()
						end

						if v148 then
							game.TweenService:Create(v148, tweenInfo, {
								Size = Vector3.new(0.25, v201, v201)
							}):Play()
						end
					end
				end)
				v144:Connect(Humanoid.HealthChanged, function(p31) -- line: 1694
					-- upvalues: v144 (copy), p26 (copy), child (copy)
					if p31 <= 0 then
						v144:Destroy()

						if p26.BuildingVisualTroves then
							p26.BuildingVisualTroves[child] = nil
						end
					end
				end)
				v144:Connect(child.AncestryChanged, function(_, p33) -- line: 1703
					-- upvalues: v144 (copy), p26 (copy), child (copy)
					if not p33 then
						v144:Destroy()

						if p26.BuildingVisualTroves then
							p26.BuildingVisualTroves[child] = nil
						end
					end
				end)
			end
		end)
		Network:SetConnection(`{ p26.Player.Name }UpdateClosestBuilding`, "REMOTE_EVENT", function(p34) -- line: 1714
			-- upvalues: p26 (copy), Util (copy)
			if p26.CarryableBuildingHighlight then
				p26.CarryableBuildingHighlight.Adornee = p34
			end

			Util:ToggleLockForAbilityIcon("Move", "nobuildinglmao", not p34)
		end)
		Network:SetConnection(`{ p26.Player.Name }ForceDropBuilding`, "REMOTE_EVENT", function() -- line: 1721
			-- upvalues: p26 (copy), Network (copy), cl_dropBuilding (copy), Util (copy)
			p26.AnimationType = nil
			Network:FireConnection("DisableSprinting", "CarryingBuilding", false)
			cl_dropBuilding(p26)
			Util:ToggleLockForAbilityIcon("Move", "nobuildinglmao", false)
			task.defer(function() -- line: 1726
				-- upvalues: Util (copy)
				Util:ToggleLockForAbilityIcon("Move", "nobuildinglmao", true)
			end)
		end)
	end

	initClientSentryAiming(p26)
	p26.Buildings = {}
	p26.CarryVisualTroves = p26.CarryVisualTroves or {}
	p26.CarryVisualConnection = workspace.Map.Ingame.ChildAdded:Connect(function(child) -- line: 1737
		-- upvalues: p26 (copy), trove (copy), updateBuildingCarryVisual (copy)
		if child.Name:find("Builderman") then
			if child:GetAttribute("ClientCarryWatcherSet") then
				return
			end

			child:SetAttribute("ClientCarryWatcherSet", true)

			if p26.CarryVisualTroves[child] then
				p26.CarryVisualTroves[child]:Destroy()
			end

			local v153 = trove.new()

			p26.CarryVisualTroves[child] = v153
			task.spawn(function() -- line: 1748
				-- upvalues: child (copy), updateBuildingCarryVisual (copy)
				if child:WaitForChild("PlayerAura", 10) then
					updateBuildingCarryVisual(child)
				end
			end)
			v153:Connect(child:GetAttributeChangedSignal("Carrying"), function() -- line: 1755
				-- upvalues: child (copy), updateBuildingCarryVisual (copy)
				if child:GetAttribute("Destroyed") then
					return
				end

				updateBuildingCarryVisual(child)
			end)
			v153:Connect(child.AncestryChanged, function(_, p36) -- line: 1760
				-- upvalues: v153 (copy), p26 (copy), child (copy)
				if not p36 then
					v153:Destroy()

					if p26.CarryVisualTroves then
						p26.CarryVisualTroves[child] = nil
					end
				end
			end)
		end
	end)
	Network:SetConnection(`{ p26.Player.Name }ReplicateBuildingAsync`, "REMOTE_EVENT", function(p37, s5: string) -- line: 1774
		-- upvalues: p26 (copy), cl_watchBuildingActivityLock (copy)
		if p26.Player ~= game.Players.LocalPlayer then
			return
		end

		p26.Buildings[s5] = p37
		cl_watchBuildingActivityLock(p26, p37, s5)

		local v156 = p26
		local v157 = p37.Parent ~= nil and not p37:GetAttribute("Destroyed")

		if v156.Player ~= game.Players.LocalPlayer then
			return
		end

		local AbilityContainer = v156.Player.PlayerGui.MainUI:FindFirstChild("AbilityContainer")
		local v159 = AbilityContainer and AbilityContainer:FindFirstChild(s5)

		if not v159 then
			return
		end

		v159.Charges.Text = not v157 and "" or "PLACED"
	end)
    Network:SetConnection(p26.Player.Name.."ConstructionRejected","REMOTE_EVENT",function(reason)
        if p26.Player==game.Players.LocalPlayer then Util:CreateWarning("BuildermanWarning",t2[reason]or t2.unknown,p26.Config.Instances.WarningTemplate)end
    end)
	Network:SetConnection(`{ p26.Player.Name }UpdateCanPlace`, "REMOTE_EVENT", function(b4: boolean) -- line: 1783
		-- upvalues: Util (copy)
		Util:ToggleLockForAbilityIcon("Move", "invalidplacement", not b4)
	end)
	Network:SetConnection(`{ p26.Player.Name }UpdateBuildingAbilityLock`, "REMOTE_EVENT", function(s6: string, s7: string, b5: boolean) -- line: 1790
		-- upvalues: Util (copy)
		Util:ToggleLockForAbilityIcon(s6, s7, b5)
	end)
	Network:SetConnection(`{ p26.Player.Name }ReplicateDestroyedBuildingAsync`, "REMOTE_EVENT", function(s8: string) -- line: 1798
		-- upvalues: p26 (copy), Util (copy)
		if p26.Player ~= game.Players.LocalPlayer then
			return
		end

		p26.Buildings[s8] = nil

		if p26.BuildingActivityLockTokens then
			p26.BuildingActivityLockTokens[s8] = nil
		end

		Util:ToggleLockForAbilityIcon(s8, "recentactivity", false)

		local v165 = p26.Behavior and (p26.Behavior.Abilities and p26.Behavior.Abilities[s8])

		if v165 then
			v165.CurrentRecharge = 0
			v165.ChargeDuration = 0
		end

		local v166 = p26

		if v166.Player ~= game.Players.LocalPlayer then
			return
		end

		local AbilityContainer = v166.Player.PlayerGui.MainUI:FindFirstChild("AbilityContainer")
		local v168 = AbilityContainer and AbilityContainer:FindFirstChild(s8)

		if not v168 then
			return
		end

		v168.Charges.Text = ""
	end)
	p26.BuildingActivityBarConnection = RunService.RenderStepped:Connect(function() -- line: 1817
		-- upvalues: p26 (copy), cl_updateBuildingActivityBars (copy)
		if not p26.Rig or not p26.Rig.Parent then
			if p26.BuildingActivityBarConnection then
				p26.BuildingActivityBarConnection:Disconnect()
				p26.BuildingActivityBarConnection = nil
			end

			return
		end

		cl_updateBuildingActivityBars(p26)
	end)
	p26.Rig.AncestryChanged:Connect(function(_, parent) -- line: 1829
		-- upvalues: p26 (copy), cl_tweenCarryFOV (copy), Network (copy)
		if parent then
			return
		end

		if p26.CarryVisualConnection then
			p26.CarryVisualConnection:Disconnect()
			p26.CarryVisualConnection = nil
		end

		for _, v in pairs(p26.CarryVisualTroves or {}) do
			v:Destroy()
		end

		p26.CarryVisualTroves = nil

		if p26.Player == game.Players.LocalPlayer then
			cl_tweenCarryFOV(p26, false)

			if p26.Connection then
				p26.Connection:Disconnect()
			end

			if p26.BuildingActivityBarConnection then
				p26.BuildingActivityBarConnection:Disconnect()
				p26.BuildingActivityBarConnection = nil
			end

			for _, v in pairs(p26.BuildingVisualTroves or {}) do
				v:Destroy()
			end

			p26.BuildingVisualTroves = nil

			for _, v in pairs(p26.RadiusStorages or {}) do
				v:Destroy()
			end

			if p26.CarryableBuildingHighlight then
				p26.CarryableBuildingHighlight:Destroy()
				p26.CarryableBuildingHighlight = nil
			end

			Network:RemoveConnection(`{ p26.Player.Name }UpdateClosestBuilding`, "REMOTE_EVENT")
			Network:RemoveConnection(`{ p26.Player.Name }ForceDropBuilding`, "REMOTE_EVENT")
			Network:RemoveConnection(`{ p26.Player.Name }UpdateCanPlace`, "REMOTE_EVENT")
			Network:RemoveConnection(`{ p26.Player.Name }UpdateBuildingAbilityLock`, "REMOTE_EVENT")
		end

		p26.Buildings = {}
		Network:RemoveConnection(`{ p26.Player.Name }ReplicateBuildingAsync`, "REMOTE_EVENT")
	end)
end
function t1.Destroyed(_, p40) -- line: 1873
	-- upvalues: cl_tweenCarryFOV (copy), Network (copy)
	p40.BuilderConstructionVisual=nil
	if p40.CarryVisualConnection then
		p40.CarryVisualConnection:Disconnect()
		p40.CarryVisualConnection = nil
	end

	for _, v in pairs(p40.CarryVisualTroves or {}) do
		v:Destroy()
	end

	p40.CarryVisualTroves = nil

	if p40.Player == game.Players.LocalPlayer then
		cl_tweenCarryFOV(p40, false)

		if p40.Connection then
			p40.Connection:Disconnect()
			p40.Connection = nil
		end

		if p40.BuildingActivityBarConnection then
			p40.BuildingActivityBarConnection:Disconnect()
			p40.BuildingActivityBarConnection = nil
		end

		for _, v in pairs(p40.BuildingVisualTroves or {}) do
			v:Destroy()
		end

		p40.BuildingVisualTroves = nil

		for _, v in pairs(p40.RadiusStorages or {}) do
			v:Destroy()
		end

		if p40.CarryableBuildingHighlight then
			p40.CarryableBuildingHighlight:Destroy()
			p40.CarryableBuildingHighlight = nil
		end

		Network:RemoveConnection(p40.Player.Name.."ConstructionRejected","REMOTE_EVENT")
		Network:FireConnection("DisableSprinting","CarryingBuilding",false)
		Network:RemoveConnection(`{ p40.Player.Name }UpdateClosestBuilding`, "REMOTE_EVENT")
		Network:RemoveConnection(`{ p40.Player.Name }ForceDropBuilding`, "REMOTE_EVENT")
		Network:RemoveConnection(`{ p40.Player.Name }UpdateCanPlace`, "REMOTE_EVENT")
		Network:RemoveConnection(`{ p40.Player.Name }UpdateBuildingAbilityLock`, "REMOTE_EVENT")
		Network:RemoveConnection(`{ p40.Player.Name }ReplicateBuildingAsync`, "REMOTE_EVENT")
		Network:RemoveConnection(`{ p40.Player.Name }ReplicateDestroyedBuildingAsync`, "REMOTE_EVENT")
	end
end

function t1.Use(actor,kind,response)
 local ability=t1.Abilities[kind]
 if ability then return ability.Callback(actor,response)end
end
return t1
]========] end
do local module=Instance.new("ModuleScript");module.Name="Rules";module.Parent=behavior;module.Source=[========[
local Rules={}
function Rules.ActivityRemaining(last,now)return type(last)=="number"and math.max(0,10-(now-last))or 0 end
function Rules.EffectRadius(config,kind,count)
 local radius=config[kind=="Sentry"and "SentryDamageRadius"or "DispenserHealingRadius"]/2
 if kind=="Sentry"then radius=math.clamp(radius*(1-math.max(0,count-1)*config.SentryRangeReductionPercentage/100),config.SentryMinimumRange,radius)end
 return radius
end
function Rules.SlowLevel(config,builders)return builders>1 and config.SentryStackedSlownessLevel or config.SentrySlownessLevel end
function Rules.Points(kind,value)
 return math.ceil(math.clamp(kind=="Sentry"and value^.5*1.2 or value^.95*.35,0,20))
end
return Rules
]========] end
end)
if not ok then prepared:Destroy();error("[Builderman] Preparation failed; nothing changed: "..tostring(err))end
local backup=Instance.new("Folder");local base="BuildermanPort_Backup_"..os.date("!%Y%m%d_%H%M%S");backup.Name=base
local index=0;while storage:FindFirstChild(backup.Name)do index+=1;backup.Name=base.."_"..index end
ref(backup,"Original",original);ref(backup,"Installed",prepared)
local function sourceSignature(object)
 local rows={}
 for _,module in object:GetDescendants()do if module:IsA("LuaSourceContainer")then table.insert(rows,module:GetFullName():sub(#object:GetFullName()+2).."="..fingerprint(module.Source))end end
 table.sort(rows);return table.concat(rows,"|")
end
backup:SetAttribute("InstalledSources",sourceSignature(prepared));backup.Parent=storage
ok,err=pcall(function()original.Parent=backup;prepared.Parent=parent end)
if not ok then prepared:Destroy();original.Parent=parent;backup:Destroy();error("[Builderman] Rolled back: "..tostring(err))end
print("[Builderman] Installed construction rework and Carry with 1.15s placement. Original Sentry model preserved. Save and restart Play. Backup: "..backup.Name)

end
local function restore()
assert(game:GetService("RunService"):IsStudio()and not game:GetService("RunService"):IsRunning(),"Stop Play first.")
local function find(path)
 local object=game
 for name in path:gmatch("[^/]+")do object=object and object:FindFirstChild(name)end
 return object
end
local function fingerprint(s)
 local a,b=5381,0
 for i=1,#s do local v=s:byte(i);a=(a*33+v)%4294967296;b=(b*65599+v)%4294967296 end
 return string.format("%d:%08x:%08x",#s,a,b)
end
local function ref(parent,name,value)local object=Instance.new("ObjectValue");object.Name=name;object.Value=value;object.Parent=parent end
local selected=game:GetService("Selection"):Get();local backup
if #selected==1 and selected[1].Name:match("^BuildermanPort_Backup_")then backup=selected[1]end
assert(backup,"Select the BuildermanPort_Backup folder in ServerStorage first.")
local installed=assert(backup.Installed.Value,"Installed Builderman missing")
local original=assert(backup.Original.Value,"Original Builderman missing")
local rows={}
for _,module in installed:GetDescendants()do if module:IsA("LuaSourceContainer")then table.insert(rows,module:GetFullName():sub(#installed:GetFullName()+2).."="..fingerprint(module.Source))end end
table.sort(rows)
assert(table.concat(rows,"|")==backup:GetAttribute("InstalledSources"),"Builderman Sources edited since installation. Nothing changed.")
assert(installed.Parent==find("ReplicatedStorage/Assets/Survivors"),"Installed Builderman moved. Nothing changed.")
local parent=installed.Parent
original.Parent=parent;installed:Destroy();backup:Destroy()
print("[Builderman] Restored original character. Save and restart Play.")

end
fixture();install()
local current=locate("ReplicatedStorage/Assets/Survivors/Builderman")
assert(current~=original and current.Config.Sentry:FindFirstChild("OldTurretMesh"),"original complete sentry was lost")
assert(current.Config.Dispenser.Humanoid and current.Behavior.Server and current.Behavior.Client and current.Behavior.Rules and current.Rig)
local count=#game.ServerStorage:GetChildren();install();assert(#game.ServerStorage:GetChildren()==count)
local backup
for _,object in game.ServerStorage:GetChildren()do if object.Name:match("^BuildermanPort_Backup_")then backup=object end end
selection={backup};restore()
assert(locate("ReplicatedStorage/Assets/Survivors/Builderman")==original)
for fail=1,5 do
 fixture();failAt=writes+fail;assert(not pcall(install));failAt=nil
 assert(locate("ReplicatedStorage/Assets/Survivors/Builderman")==original and original.Config.Source==configSource and original.Behavior.Source==behaviorSource)
end
fixture();original.Behavior.Source..=" local edit";assert(not pcall(install))
fixture();install()
for _,object in game.ServerStorage:GetChildren()do if object.Name:match("^BuildermanPort_Backup_")then backup=object end end
selection={backup};locate("ReplicatedStorage/Assets/Survivors/Builderman/Behavior/Server").Source..=" local edit"
assert(not pcall(restore),"restore overwrote local server edits")
print("PASS full installer: retained original Sentry and rig, donor Dispenser and Carry modules, idempotence/exact restore, Source preparation rollback and local-edit guards")
