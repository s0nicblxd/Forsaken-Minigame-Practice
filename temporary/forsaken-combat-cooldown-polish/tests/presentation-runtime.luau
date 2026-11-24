local Color3={fromRGB=function(r,g,b)return `{r},{g},{b}`end}
local label={TextColor3="white",attrs={}}
function label:GetAttribute(name)return self.attrs[name]end
function label:SetAttribute(name,value)self.attrs[name]=value end
local haste
local Statuses={PlayerHasStatus=function()return haste end}
local LocalPlayer={}
local k3={FindFirstChild=function()return label end}
local v167={}
local k="Pulse"
local function update()
                    local haste=Statuses:PlayerHasStatus(LocalPlayer,"Haste")
                    local accelerated=v167~=nil and haste~=nil and haste~=false
                        and not table.find(haste.Data and haste.Data.DisabledAbilityNames or {},k)
                    local label=k3 and k3:FindFirstChild("CooldownTime")
                    if label then
                        local base=label:GetAttribute("BaseTextColor")
                        if not base then base=label.TextColor3;label:SetAttribute("BaseTextColor",base)end
                        label.TextColor3=accelerated and Color3.fromRGB(0,255,0)or base
                    end
end
update();assert(label.TextColor3=="white")
haste={Data={DisabledAbilityNames={"Inspiration"}}}
update();assert(label.TextColor3=="0,255,0")
k="Inspiration";update();assert(label.TextColor3=="white")
k="Pulse";update();assert(label.TextColor3=="0,255,0")
haste=nil;update();assert(label.TextColor3=="white")
haste={Data={}};v167=nil;update();assert(label.TextColor3=="white")
local script={Warning={Clone=function()return {TextColor3="white"}end}}
local clone2 = script.Warning:Clone()
	clone2.TextColor3 = Color3.fromRGB(255, 0, 0)
assert(clone2.TextColor3=="255,0,0")
print("PASS eligible Haste countdown green, excluded/finished cooldowns and effect removal restore original color; idle/tabbed warning is red")
