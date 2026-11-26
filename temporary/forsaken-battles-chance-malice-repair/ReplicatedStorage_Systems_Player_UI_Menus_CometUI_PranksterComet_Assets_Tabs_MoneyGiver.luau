local Utility = require(script.Parent.Parent.Utility)
local MoneyGiver = script.Parent.Parent.Parent.Main.Frames.MoneyGiver
local TextButton = MoneyGiver.TextButton

TextButton.Text = "Money"
TextButton.BackgroundColor3 = Utility.OnColor
TextButton.MouseButton1Down:Connect(function() -- line: 10
	-- upvalues: TextButton (copy), Utility (copy)
	TextButton.Text = "Money"

	TextButton.Text = "Money"
	TextButton.BackgroundColor3 = Utility.OnColor
end)

local t1 = {
	Data = {}
}

t1.Data.Segments = {
	"SelectPlayer",
	"FireButton"
}
t1.Data.Description = "Give money or malice to a player."

function t1.Fire() -- line: 26
	-- upvalues: Utility (copy), MoneyGiver (copy), TextButton (copy)
	local PlayersFromSelection = Utility:GetPlayersFromSelection()
	local TextBoxText = MoneyGiver.TextBox.Text

	Utility:Fire({
		Players = PlayersFromSelection,
		Amount = tonumber(TextBoxText),
		Type = "Money"
	})
end

return t1

