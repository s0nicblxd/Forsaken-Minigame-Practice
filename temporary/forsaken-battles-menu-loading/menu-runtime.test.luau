local UDim2={fromScale=function(x,y)return {X=x,Y=y}end}
local function transitionToFrame(p4, p5, b2: boolean) -- line: 149
	-- upvalues: TweenService (copy)
	assert(p5 and p5:IsA("Frame"), "transitionToFrame() There was no frame to transition to.")
	assert(b2 ~= nil, "transitionToFrame() There was no direction to transition to.")

	if p4 == nil then
        p5.Visible = true
		p5.Position = UDim2.fromScale(0, 0)

		return
	end

	p5.Position = b2 and UDim2.fromScale(-1, 0) or UDim2.fromScale(1, 0)
	p5.Visible = true
	TweenService:Create(p4, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
		Position = UDim2.fromScale(not b2 and -1 or 1, 0)
	}):Play()
	TweenService:Create(p5, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
		Position = UDim2.fromScale(0, 0)
	}):Play()
	task.delay(0.5, function() -- line: 178
		-- upvalues: p4 (copy)
		p4.Visible = false
	end)
end

local page={Visible=false,IsA=function(_,class)return class=="Frame"end}
transitionToFrame(nil,page,false)
assert(page.Visible and page.Position.X==0,"first Skins page stays hidden")
print("PASS first Shop page becomes visible without switching tabs")
local t5={old={TitleMeta={Text={Title="Old"}}},new={TitleMeta={Text={Title="New"}}}}
local latestKey="new"
local Changelogs={GetAttribute=function()return "missing"end}
local Menu={}
local LatestLog,TextTitle,selected
local function __switchPage(_,entry)selected=entry end
LatestLog = Changelogs:GetAttribute("LatestLog")
        if not t5[LatestLog] then LatestLog = latestKey end
        if t5[LatestLog] then
            __switchPage(Menu, t5[LatestLog])
            TextTitle = t5[LatestLog].TitleMeta.Text.Title
        end

assert(selected==t5.new and TextTitle=="New"and LatestLog=="new","latest log fallback failed")
Changelogs.GetAttribute=function()return "old"end
LatestLog = Changelogs:GetAttribute("LatestLog")
        if not t5[LatestLog] then LatestLog = latestKey end
        if t5[LatestLog] then
            __switchPage(Menu, t5[LatestLog])
            TextTitle = t5[LatestLog].TitleMeta.Text.Title
        end

assert(selected==t5.old,"configured latest log was ignored")
print("PASS latest changelog fallback and configured latest entry")
