local module = {}
function module.AddStats(_, player)
 task.spawn(function()
  local data=player:WaitForChild("PlayerData")
  local stats=data:WaitForChild("Stats")
  local money=stats:FindFirstChild("Money",true)
  local total=stats:WaitForChild("General"):WaitForChild("TotalKills")
  if not player.Parent then return end
  local newStats=Instance.new("Folder")
  newStats.Name="leaderstats"
  local moneyDisplay=Instance.new("NumberValue");moneyDisplay.Name="Money";moneyDisplay.Value=money and money.Value or 0;moneyDisplay.Parent=newStats
  local killsDisplay=Instance.new("NumberValue");killsDisplay.Name="Kills";killsDisplay.Value=total.Value;killsDisplay.Parent=newStats
  local connections={}
  if money then table.insert(connections,money:GetPropertyChangedSignal("Value"):Connect(function()moneyDisplay.Value=money.Value end))end
  table.insert(connections,total:GetPropertyChangedSignal("Value"):Connect(function()killsDisplay.Value=total.Value end))
  newStats.Destroying:Connect(function()for _,connection in connections do connection:Disconnect()end end)
  newStats.Parent=player
 end)
end
return module
