-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local l_ReplicatedStorage_0 = game:GetService("ReplicatedStorage");
local l_TweenService_0 = game:GetService("TweenService");
local v2 = require(l_ReplicatedStorage_0.Modules.Network);
local l_delay_0 = task.delay;
local v4 = TweenInfo.new(0.5);
local v5 = Color3.fromRGB(141, 0, 0);
local v6 = Color3.fromRGB(255, 255, 255);
return {
    Start = function(_) --[[ Line: 17 ]] --[[ Name: Start ]]
        -- upvalues: v2 (copy), l_TweenService_0 (copy), v4 (copy), v5 (copy), l_delay_0 (copy), v6 (copy)
        local l_LocalPlayer_0 = game.Players.LocalPlayer;
        local v9 = script.RoundTimer:Clone();
        local l_Main_0 = v9.Main;
        v9.Parent = l_LocalPlayer_0.PlayerGui;
        local l_RoundTimer_0 = game.ReplicatedStorage:WaitForChild("RoundTimer");
        local function v17() --[[ Line: 29 ]] --[[ Name: updateTime ]]
            -- upvalues: l_Main_0 (copy), l_RoundTimer_0 (copy)
            local l_Time_0 = l_Main_0.Time;
            local l_Title_0 = l_Main_0.Title;
            local l_Value_0 = l_RoundTimer_0.Value;
            if l_RoundTimer_0:GetAttribute("EndlessCombat")then
                l_Title_0.TextColor3=Color3.fromRGB(255,255,255)
                l_Time_0.TextColor3=Color3.fromRGB(255,255,255)
                l_Title_0.Text="Battle Till' Death!"
                l_Time_0.Text="Fight"
                return
            end
            if workspace:GetAttribute("BloodHuntActive") then
                l_Title_0.TextColor3 = Color3.fromRGB(255, 0, 0);
                l_Time_0.TextColor3 = Color3.fromRGB(255, 0, 0);
                l_Title_0.Text = "RUN";
                l_Time_0.Text = "HI:DE";
                return;
            else
                l_Title_0.TextColor3 = Color3.fromRGB(255, 255, 255);
                l_Time_0.TextColor3 = Color3.fromRGB(255, 255, 255);
                local v15 = l_RoundTimer_0:GetAttribute("TimeLeft") or 0;
                local v16 = string.format("%i:%02i", v15 / 60, v15 % 60);
                l_Title_0.Text = l_Value_0 and l_Value_0 or "";
                l_Time_0.Text = v16;
                return;
            end;
        end;
        v17();
        l_RoundTimer_0:GetPropertyChangedSignal("Value"):Connect(v17);
        l_RoundTimer_0:GetAttributeChangedSignal("TimeLeft"):Connect(v17);
        l_RoundTimer_0:GetAttributeChangedSignal("EndlessCombat"):Connect(v17);
        workspace:GetAttributeChangedSignal("BloodHuntActive"):Connect(v17);
        local v18 = nil;
		local v19 = nil;
		v2:SetConnection("EnlargeRoundTimerAsync", "REMOTE_EVENT", function(v20)
            if l_RoundTimer_0:GetAttribute("EndlessCombat")then return end --[[ Line: 61 ]]
            -- upvalues: v18 (ref), v19 (ref), l_TweenService_0 (ref), l_Main_0 (copy), v4 (ref), v5 (ref), l_delay_0 (ref), v6 (ref)
            if v18 then
                v18:Cancel();
                pcall(coroutine.close, v19);
                v18 = nil;
            end;
            v18 = l_TweenService_0:Create(l_Main_0.Time, v4, {
                TextColor3 = v5
            });
            v18:Play();
            v19 = l_delay_0(v20, function() --[[ Line: 70 ]]
                -- upvalues: v18 (ref), l_TweenService_0 (ref), l_Main_0 (ref), v4 (ref), v6 (ref)
                v18 = l_TweenService_0:Create(l_Main_0.Time, v4, {
                    TextColor3 = v6
                });
                v18:Play();
            end);
        end);
        local l_MainUI_0 = l_LocalPlayer_0.PlayerGui:WaitForChild("MainUI");
        l_MainUI_0:GetPropertyChangedSignal("Enabled"):Connect(function() --[[ Line: 77 ]]
            -- upvalues: v9 (copy), l_MainUI_0 (copy)
            v9.Enabled = l_MainUI_0.Enabled;
        end);
    end
};