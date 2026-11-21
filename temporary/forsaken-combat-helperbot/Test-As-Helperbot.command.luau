-- Run in the SERVER Command Bar during a Studio playtest. Affects only the chosen test player's current character.
local TARGET_PLAYER="" -- empty uses the first Studio player
local RunService=game:GetService("RunService")
assert(RunService:IsStudio() and RunService:IsRunning() and RunService:IsServer(),"Start Play and switch Command Bar to Server first.")
local Players=game:GetService("Players")
local player=assert(TARGET_PLAYER~="" and Players:FindFirstChild(TARGET_PLAYER) or Players:GetPlayers()[1],"No test player found.")
local Actors=require(game.ReplicatedStorage.Modules.Actors)
local actor=Actors.CurrentActors[player]
if actor then Actors:CleanupActorFromPlayer(player) end
if not player.Character or not player.Character:FindFirstChildOfClass("Humanoid") or player.Character:FindFirstChildOfClass("Humanoid").Health<=0 then player:LoadCharacterAsync();task.wait(.5) end
Actors:CreateActor(player,"Survivor","Helperbot")
assert(Actors.CurrentActors[player] and Actors.CurrentActors[player].ActorName=="Helperbot","Helperbot did not spawn; check earlier Output errors.")
print("[Helperbot Port] Test character ready for "..player.Name)
