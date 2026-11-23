local t1 = {}
local DataHandler = require(game.ReplicatedStorage.Modules.DataHandler)

function t1.Start(_) -- line: 5
	-- upvalues: DataHandler (copy), t1 (copy)
	task.spawn(function() -- line: 7
		-- upvalues: DataHandler (copy), t1 (copy)
		local LocalPlayer = game.Players.LocalPlayer
		local Achievements = DataHandler:Get():WaitForChild("Achievements")
		local Sounds = require(game.ReplicatedStorage.Modules.Sounds)
		local Util = require(game.ReplicatedStorage.Modules.Util)

		t1.AchievementsMenu = require(game.ReplicatedStorage.Initializer).PlayerSystems.SidebarHandler:CreateSidebarMenu("Achievements", script.AchievementsScreen)

		local AchievementsContainer = t1.AchievementsMenu.Menu.AchievementsContainer
		local Contents = AchievementsContainer.Contents
		local Templates = script.Templates
		local n1 = 0
		local n2 = 0
		local n3 = 0

		local function updateAchievementHeader() -- line: 28
			-- upvalues: AchievementsContainer (copy), n1 (ref), n3 (ref), n2 (ref)
			AchievementsContainer.MainTitle.Title.Text = `Achievements -- { n1 }/{ n3 }{ n2 > 0 and ` (+{ n1 })` or "" } Unlocked`
		end

		local u15 = nil

		local function createTab(p2, p3) -- line: 34
			-- upvalues: AchievementsContainer (copy), u15 (ref), Contents (copy)
			local clone = script.Templates.TabButton:Clone()

			clone.Name = p2
			clone.LayoutOrder = p3
			clone.Inverted.ImageTransparency = p2 ~= "All" and 1 or 0
			clone.Title.TextColor3 = p2 == "All" and Color3.new() or Color3.new(1, 1, 1)
			clone.Title.Text = p2
			clone.Parent = AchievementsContainer.Tabs
			clone.MouseButton1Click:Connect(function() -- line: 45
				-- upvalues: u15 (ref), clone (copy), Contents (copy), p2 (copy)
				if u15 then
					game.TweenService:Create(u15.Inverted, TweenInfo.new(0.3), {
						ImageTransparency = 1
					}):Play()
					game.TweenService:Create(u15.Title, TweenInfo.new(0.3), {
						TextColor3 = Color3.new(1, 1, 1)
					}):Play()
				end

				u15 = clone
				game.TweenService:Create(clone.Inverted, TweenInfo.new(0.3), {
					ImageTransparency = 0
				}):Play()
				game.TweenService:Create(clone.Title, TweenInfo.new(0.3), {
					TextColor3 = Color3.new()
				}):Play()

				for _, child in pairs(Contents:GetChildren()) do
					if child:IsA("GuiObject") then
						child.Visible = p2 == "All" or child:GetAttribute("BranchName") == p2
					end
				end
			end)

			return clone
		end

		u15 = createTab("All", 0)

		local Achievements2 = require(game.ReplicatedStorage.Modules.Schematics.Achievements)

		for k, v in pairs(Achievements2) do
			local k2 = Achievements:WaitForChild(k, 5)

			if k2 then
				local v21 = (tonumber(v.LayoutOrder) or 1) * 1000
				local clone = Templates.Seperator:Clone()

				clone.Name = k
				clone.LayoutOrder = v21
				clone.Title.Text = v.Title or k
				clone.Parent = Contents
				clone:SetAttribute("BranchName", k)
				createTab(k, v21).Title.Text = clone.Title.Text

				for k3, v2 in pairs(v.Achievements or {}) do
					local k3_2 = k2:WaitForChild(k3, 5)

					if k3_2 then
						local clone2 = Templates.Achievement:Clone()

						clone2.Name = k3
						clone2.LayoutOrder = v21 + (tonumber(v2.LayoutOrder) or 1)
						clone2.Title.Text = v2.Title or k3
						clone2.Description.Text = tostring(v2.Description)
						clone2.Icon.Image = tostring(v2.Icon)
						clone2.Visible = v2.Hidden
						clone2.Parent = Contents
						clone2:SetAttribute("BranchName", k)
						n3 += 1

						if v2.RewardType then
							if v2.RewardType == "Currency" then
								clone2.RewardOverlay.RewardTitle.Text = `+ { v2.Amount and tostring(Util:ToCommas(v2.Amount)) or "???" }$`
							elseif v2.RewardType == "Emote" or v2.RewardType == "Skin" then
								local t2 = {}

								for _, v3 in pairs(v2.Emotes or {}) do
									table.insert(t2, `{ v3:gsub("(%l)(%u)", "%1 %2") } (Emote)`)
								end

								for _, v4 in pairs(v2.Skins or {}) do
									table.insert(t2, `{ v4:gsub("(%l)(%u)", "%1 %2") } (Skin)`)
								end

								if v2.Skin then
									table.insert(t2, `{ v2.Skin:gsub("(%l)(%u)", "%1 %2") } (Skin)`)
								end

								if v2.Emote then
									table.insert(t2, `{ v2.Emote:gsub("(%l)(%u)", "%1 %2") } (Emote)`)
								end

								clone2.RewardOverlay.RewardTitle.Text = table.concat(t2, " + ")
							end

							clone2.MouseEnter:Connect(function() -- line: 120
								-- upvalues: Sounds (copy), clone2 (copy)
								Sounds:Play("hover")
								clone2.RewardOverlay.Visible = true
							end)
							clone2.MouseLeave:Connect(function() -- line: 121
								-- upvalues: Sounds (copy), clone2 (copy)
								Sounds:Play("hoverEnd")
								clone2.RewardOverlay.Visible = false
							end)
						else
							clone2.RewardOverlay:Destroy()
						end

						local function markAsCompleted() -- line: 127
							-- upvalues: clone2 (copy), v2 (copy), n2 (ref), n1 (ref), AchievementsContainer (copy), n3 (ref)
							local IncompleteOverlay = clone2:FindFirstChild("IncompleteOverlay")

							if IncompleteOverlay then
								IncompleteOverlay:Destroy()

								if v2.Hidden then
									clone2.Visible = true
									n2 += 1
								else
									n1 += 1
								end

								AchievementsContainer.MainTitle.Title.Text = `Achievements -- { n1 }/{ n3 }{ n2 > 0 and ` (+{ n1 })` or "" } Unlocked`
							end
						end
						local function updateProgress() -- line: 137
							-- upvalues: k3_2 (copy), clone2 (copy), v2 (copy), n2 (ref), n1 (ref), AchievementsContainer (copy), n3 (ref), LocalPlayer (copy)
							if k3_2:IsA("BoolValue") then
								clone2.Progress.Visible = false
								clone2.ProgressBar.Visible = false

								if k3_2.Value then
									local IncompleteOverlay = clone2:FindFirstChild("IncompleteOverlay")

									if IncompleteOverlay then
										IncompleteOverlay:Destroy()

										if v2.Hidden then
											clone2.Visible = true
											n2 += 1
										else
											n1 += 1
										end

										AchievementsContainer.MainTitle.Title.Text = `Achievements -- { n1 }/{ n3 }{ n2 > 0 and ` (+{ n1 })` or "" } Unlocked`

										return
									end
								end
							elseif k3_2:IsA("IntValue") and v2.Requirement then
								local v39 = typeof(v2.Requirement) == "function" and v2.Requirement(LocalPlayer) or v2.Requirement
								local v40 = math.clamp(k3_2.Value / v39, 0, 1)
								local v41 = if v40 ~= 0 then 1 / v40 else 0

								clone2.ProgressBar.Clipping.Size = UDim2.fromScale(v40, 1)
								clone2.ProgressBar.Clipping.Top.Size = UDim2.fromScale(v41, 1)
								clone2.Progress.Text = `{ math.round((math.clamp(k3_2.Value, 0, v39))) }/{ math.round(v39) }`

								if v39 <= k3_2.Value then
									local IncompleteOverlay = clone2:FindFirstChild("IncompleteOverlay")

									if IncompleteOverlay then
										IncompleteOverlay:Destroy()

										if v2.Hidden then
											clone2.Visible = true
											n2 += 1
										else
											n1 += 1
										end

										AchievementsContainer.MainTitle.Title.Text = `Achievements -- { n1 }/{ n3 }{ n2 > 0 and ` (+{ n1 })` or "" } Unlocked`
									end
								end
							end
						end

						k3_2:GetPropertyChangedSignal("Value"):Connect(updateProgress)
						updateProgress()
						task.wait()
					end
				end
			end
		end

		AchievementsContainer.MainTitle.Title.Text = `Achievements -- { n1 }/{ n3 }{ n2 > 0 and ` (+{ n1 })` or "" } Unlocked`
	end)
end

return t1
