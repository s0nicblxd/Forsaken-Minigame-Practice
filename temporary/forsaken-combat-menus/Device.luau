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
