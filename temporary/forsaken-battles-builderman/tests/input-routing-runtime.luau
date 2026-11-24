local requests={}
local Network={FireServerConnection=function(_,name,kind,key,frame)table.insert(requests,{name,key,frame})end}
local snapshot={Name="click pose"}
local p6={ActorName="Builderman",Behavior={BeforeAbilityRequest=function()return snapshot end}}
local k="Sentry"
local function useAbility()
                    local frame
                    if p6.ActorName=="Builderman"and (k=="Sentry"or k=="Dispenser")then
                        local prepare=p6.Behavior and p6.Behavior.BeforeAbilityRequest
                        if prepare then
                            frame=prepare(p6,k)
                            if frame==false then return end
                        end
                    end
                    Network:FireServerConnection("UseActorAbility","REMOTE_EVENT",k,frame)
                end
useAbility();assert(#requests==1 and requests[1][2]=="Sentry"and requests[1][3]==snapshot)
p6.Behavior.BeforeAbilityRequest=function()return false end
useAbility();assert(#requests==1)
k="Move";useAbility();assert(#requests==2 and requests[2][2]=="Move"and requests[2][3]==nil)
p6.ActorName="Elliot";k="ThrowPizza";useAbility();assert(#requests==3 and requests[3][2]=="ThrowPizza"and requests[3][3]==nil)
print("PASS actual UI request routing: click frame for Builderman construction, rejected prediction abort and unrelated abilities unchanged")
