local t1 = {}

function t1.Start(_) -- line: 4
	-- upvalues: t1 (copy)
	local Util = require(game.ReplicatedStorage.Modules.Util)
	local Lighting = require(game.ReplicatedStorage.Modules.Schematics.Lighting)
	local Network = require(game.ReplicatedStorage.Modules.Network)
	local Gamemodes = game.ReplicatedStorage.Modules.Gamemodes
	local LocalPlayer = game.Players.LocalPlayer
	local CurrentCamera = workspace.CurrentCamera

	Network:SetConnection("PreHandleGamemode", "REMOTE_EVENT", function()end)
	Network:SetConnection("HandleGamemode", "REMOTE_EVENT", function(p2, ...) -- line: 21
		-- upvalues: Gamemodes (copy), t1 (copy)
		if p2 == "Init" then
			local v11, v12 = unpack({ ... })

			t1.CurrentSession = require(Gamemodes[v11]).Init(v12)

			return
		end

		if t1.CurrentSession then
			if p2 == "Destroy" then
				t1.CurrentSession:Destroy(...)
				t1.CurrentSession = nil

				return
			end
		else
			warn(`[{ script }]: Couldn't do anything with the information ({ tostring(p2) }) passed to client!`)
		end
	end)
	Network:SetConnection("ReplicateMapCreation", "REMOTE_EVENT", function(p3) -- line: 40
		if not p3 or not p3.Parent then return end
		local lib = require(p3)
		local t2 = {
			Map = p3.Parent,
			Config = lib
		}

		if lib.ClientCreated then
			local ok, result = pcall(function() -- line: 50
				-- upvalues: lib (copy), t2 (copy)
				return lib.ClientCreated(t2)
			end)

			if not ok then
				warn(`[{ script }/ReplicateMapCreation]: There was an issue with calling .ClientCreated() on { p3.Parent.Name } due to: { result }`)
			end
		end
	end)
	Network:SetConnection("LastSurvivor", "REMOTE_EVENT", function(_) -- line: 61
		-- upvalues: Util (copy), LocalPlayer (copy)
		Util:ToggleResetButton(false)

		local v19 = require(game.ReplicatedStorage.Modules.Actors).CurrentActors[LocalPlayer]

		if not v19 then
			return
		end

		if v19.Behavior and v19.Behavior.LastManStanding and v19.Rig and v19.Rig.Parent then
			task.spawn(v19.Behavior.LastManStanding, v19.Behavior, v19, v19.EmotionalLMS)
		end
	end)
	Network:SetConnection("PlayWinnerCutscene", "REMOTE_EVENT", function()end)
end

return t1
