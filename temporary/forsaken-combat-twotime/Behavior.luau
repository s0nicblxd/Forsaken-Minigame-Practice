-- Newest UPD Two Time mechanics for FCT. Ability media deliberately omitted.
local RunService=game:GetService("RunService")
local Util=require(game.ReplicatedStorage.Modules.Util)
local Impl=require(RunService:IsServer() and script.Server or script.Client)
local Behavior={}
local function ability(name,order,icon,key,extra)
 local result={LayoutOrder=order,Icon="rbxassetid://"..icon,KeybindType=key}
 for k,v in pairs(extra or {}) do result[k]=v end
 result.Callback=function(actor,data)
  if RunService:IsServer() then return Impl[name](actor) end
  if Impl[name] then return Impl[name](actor,data) end
 end
 return result
end
Behavior.Abilities={
 Dagger=ability("Dagger",1,"129077533212750","AltAbility1"),
 Crouch=ability("Crouch",2,"77707049887484","AltAbility2"),
 Pray=ability("Pray",3,"83582849559932","AltAbility3",{Cooldown=0,Sensitive=true}),
 Ritual=ability("Ritual",4,"95580729656404","AltAbility4",{Cooldown=5,Charges=1})
}
Behavior.AddRig = function(_, v121, v122) --[[ Line: 612 ]] --[[ Name: AddRig ]]
    -- upvalues: v4 (copy)
    local v123 = v121.Config.LifeAppearances[v122];
    if v123 then
        if v123:IsA("Folder") then
            v123 = v123:GetChildren()[math.random(#v123:GetChildren())];
        end;
        for _, v125 in pairs(v121.Rig:GetDescendants()) do
            if (v125:IsA("BasePart") or v125:IsA("Decal")) and v125.Name ~= "Expression" and v125.Name ~= "CollisionHitbox" and v125.Name ~= "QueryHitbox" then
                v125.Transparency = 1;
            end;
        end;
        if v121.LastRig then
            v121.LastRig:Destroy();
            v121.LastRig = nil;
        end;
        local v126 = v123:Clone();
        for _,item in v126:GetDescendants() do if item:IsA("Sound") then item:Destroy() end end
        for _, v128 in pairs(v126:GetDescendants()) do
            if v128:IsA("BasePart") then
                v128.CollisionGroup = "Survivors";
                v128.CanCollide = false;
                v128.CanTouch = false;
                v128.CanQuery = false;
                v128.Massless = true;
            end;
        end;
        for _, v130 in (v121.Rig:GetChildren()) do
            if v130:IsA("BasePart") then
                v130.RootPriority = 1;
            end;
        end;
        for _, v132 in pairs(v126:GetChildren()) do
            local l_FirstChild_1 = v121.Rig:FindFirstChild(v132.Name);
            if l_FirstChild_1 then
                if v132:IsA("Humanoid") then
                    v132.EvaluateStateMachine = false;
                end;
                if l_FirstChild_1:IsA("BasePart") then
                    v132.Anchored = false;
                    v132.CanCollide = false;
                    v132.CFrame = l_FirstChild_1.CFrame;
                    local l_WeldConstraint_0 = Instance.new("WeldConstraint");
                    l_WeldConstraint_0.Part1 = v132;
                    l_WeldConstraint_0.Part0 = l_FirstChild_1;
                    l_WeldConstraint_0.Parent = v132;
                end;
            end;
        end;
        v126.Parent = v121.Rig;
        v121.LastRig = v126;
        v121.Config.Expressions = v121.Config.ExpressionsTable[v122] or v121.Config.Expressions;
        v121:ChangeExpression("Hurt", 1);
        Util:FixCharacter(v121.Rig);
    end;
end;

function Behavior.Created(_,actor) Impl.Created(actor) end
function Behavior.Destroyed(_,actor) Impl.Destroyed(actor) end
function Behavior.OnHit(_,actor,hitbox,damage,lms)
 if RunService:IsServer() then return Impl.OnHit(actor,hitbox,damage,lms) end
end
function Behavior.LastManStanding(_,actor)
 if RunService:IsServer() and actor.Config.TwoTimeRoundHooks then return Impl.OnHit(actor,nil,0,true) end
end
function Behavior.OnHelpless(_,actor)
 if RunService:IsServer() then Impl.Interrupt(actor) end
end
Behavior.OnStunned=Behavior.OnHelpless
return Behavior
