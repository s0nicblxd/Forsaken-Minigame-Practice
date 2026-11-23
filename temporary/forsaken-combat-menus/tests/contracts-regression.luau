
local device={Value='PC',Changed={},GetPlayerDevice=function(self)return self.Value end}
local require=function()return device end
local game={ReplicatedStorage={Modules={Device={}}}}
local Enum={KeyCode={F={Name='F',enum=true},ButtonX={Name='ButtonX',enum=true},Unknown={Name='Unknown',enum=true}}}
local typeof=function(x)return type(x)=='table'and x.enum and 'EnumItem'or type(x)end
local Adapter=(function()
local Original=require(game.ReplicatedStorage.Modules.Device)
local t1=setmetatable({},{__index=Original})
local t4 = {
	MouseButton1 = true,
	MouseButton2 = true,
	MouseButton3 = true
}
local t5 = {
	"^Button",
	"^DPad",
	"^Thumbstick"
}

function t1.GetKeybindDevice(_: {[any]: any}, s1: string) -- line: 56
	-- upvalues: t4 (copy), t5 (copy)
	if typeof(s1) ~= "string" then
		return nil
	end

	if t4[s1] then
		return "PC"
	end

	local ok, result = pcall(function() -- line: 61
		-- upvalues: s1 (copy)
		return Enum.KeyCode[s1]
	end)

	if not ok or typeof(result) ~= "EnumItem" or s1 ~= result.Name or result == Enum.KeyCode.Unknown or s1 == "None" then
		return nil
	end

	for _, v16 in t5 do
		if s1:find(v16) then
			return "Console"
		end
	end

	return "PC"
end
function t1.IsKeybindAllowed(_: {[any]: any}, s2: string, s3: string) -- line: 79
	-- upvalues: t1 (copy)
	local v20 = s2:find("Console$") ~= nil

	return t1:GetKeybindDevice(s3) == (not v20 and "PC" or "Console")
end

return t1

end)()
assert(Adapter:GetPlayerDevice()=='PC'and Adapter.Changed==device.Changed)
assert(Adapter:GetKeybindDevice('MouseButton1')=='PC'and Adapter:GetKeybindDevice('F')=='PC'and Adapter:GetKeybindDevice('ButtonX')=='Console')
assert(Adapter:IsKeybindAllowed('Sprint','F')and Adapter:IsKeybindAllowed('Sprint~Console','ButtonX'))
assert(not Adapter:IsKeybindAllowed('Sprint','ButtonX')and not Adapter:GetKeybindDevice('Unknown')and not Adapter:GetKeybindDevice('notAKey'))
device.Value='Console';assert(Adapter:GetPlayerDevice()=='Console')
local Sale=(function()
local Sale={}
function Sale.GetAssetPrice(_,config)
 local price=config.Price or 0
 return {IsDiscounted=false,OriginalPrice=price,FinalPrice=price}
end
function Sale.GetPrice(_,_,config)return Sale.GetAssetPrice(nil,config)end
function Sale.GetNextChangeTime()return nil end
function Sale.IsActive()return false end
return Sale

end)()
for _,price in {0,100,2500,'Free'}do local value=Sale.GetAssetPrice(nil,{Price=price},0);assert(value.FinalPrice==price and value.OriginalPrice==price and not value.IsDiscounted)end
assert(not Sale.IsActive()and not Sale.GetNextChangeTime(0))
print('PASS UI-only adapters: native device detection/changed signal, key validation, base-price passthrough, no client-only discount')
