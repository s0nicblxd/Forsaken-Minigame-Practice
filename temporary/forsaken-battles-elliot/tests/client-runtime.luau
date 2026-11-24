local t1={}
local queue={}
local task={delay=function(delay,callback)table.insert(queue,{delay,callback})end}
local Enum={AnimationPriority={Action=1}}
local function play(a,name,looped)
 local track=a.Animations and a.Animations[name]
 if not track then return end
 local ok=pcall(function()track.Looped=looped or false;track.Priority=Enum.AnimationPriority.Action;track:Play(.1)end)
 if ok then return track end
end
function t1.ThrowPizza(a)
 play(a,"ThrowPizza")
end
function t1.RushHour(a,result)
 if not result or result.Cancelled then return end
 local token={}
 a.ElliotRushAnimation=token
 local startup=play(a,"RushStartup")
 local duration=result.Duration or a.Config.RushHourSpeedDuration
 local lead=startup and math.clamp(startup.Length,.05,.5)or 0
 task.delay(lead,function()
  if a.ElliotRushAnimation~=token or not a.Rig.Parent then return end
  token.loop=play(a,"RushLoop",true)
 end)
 task.delay(duration,function()
  if a.ElliotRushAnimation~=token then return end
  a.ElliotRushAnimation=nil
  if token.loop then token.loop:Stop(.1)end
  if a.Rig.Parent then play(a,"RushEnd")end
 end)
end

local a={Config={RushHourSpeedDuration=4},Rig={Parent=true},Animations={}}
t1.ThrowPizza(a);t1.RushHour(a,{Duration=4})
for _,item in queue do item[2]()end
assert(not a.ElliotRushAnimation,"missing tracks prevented completion")
local calls={}
local function track(name)
 return {Length=.25,Play=function()table.insert(calls,name)end,Stop=function()table.insert(calls,"stop "..name)end}
end
a.Animations={ThrowPizza=track("throw"),RushStartup=track("start"),RushLoop=track("loop"),RushEnd=track("end")}
queue={};t1.ThrowPizza(a);t1.RushHour(a,{Duration=4})
for _,item in queue do item[2]()end
assert(table.concat(calls,",")=="throw,start,loop,stop loop,end")
queue={};t1.RushHour(a,{Duration=4});a.ElliotRushAnimation=nil
for _,item in queue do item[2]()end
assert(not a.ElliotRushAnimation)
print("PASS actual client animations: throw/start/loop/end, missing animations and interrupted callbacks")
