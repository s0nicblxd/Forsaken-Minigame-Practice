local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Util = require(game.ReplicatedStorage.Modules.Util)

return {
	ResolveSkin = function(p1) -- line: 9
		-- upvalues: ReplicatedStorage (copy)
		local v4 = p1:IsA("ModuleScript") and p1.Parent or p1

		if not v4 then
			return nil
		end

		local Parent = v4.Parent
		local v6 = Parent and Parent.Parent

		if not Parent or not v6 then
			return nil
		end

		local v7 = v6.Name:gsub("s$", "")
		local v8 = ReplicatedStorage.Assets:FindFirstChild(v7 .. "s")

		return {
			ActorFolder = v8 and v8:FindFirstChild(Parent.Name),
			SkinFolder = v4,
			ActorName = Parent.Name,
			SkinName = v4.Name
		}
	end,
	GetMergedBehavior = function(p2) -- line: 33
		-- upvalues: Util (copy)
		local v10 = p2.ActorFolder and p2.ActorFolder:FindFirstChild("Behavior")
		local v11 = v10 and Util:CopyTable(require(v10)) or {}
		local Behavior = p2.SkinFolder:FindFirstChild("Behavior")
		local v13 = Behavior and require(Behavior)

		if v13 then
			v11 = Util:MergeTables(v11, v13)
		end

		return v11
	end,
	ApplyLifeAppearance = function(p3, p4) -- line: 47
		for _, descendant in p3:GetDescendants() do
			if (descendant:IsA("BasePart") or descendant:IsA("Decal")) and descendant.Name ~= "Expression" and descendant.Name ~= "CollisionHitbox" and descendant.Name ~= "QueryHitbox" then
				descendant.Transparency = 1
			end
		end

		local clone = p4:Clone()

		for _, descendant in clone:GetDescendants() do
			if descendant:IsA("BasePart") then
				descendant.CollisionGroup = "Survivors"
				descendant.CanCollide = false
				descendant.CanTouch = false
				descendant.CanQuery = false
				descendant.Massless = true
			end
		end

		for _, child in clone:GetChildren() do
			local childName = p3:FindFirstChild(child.Name)

			if childName then
				if child:IsA("Humanoid") then
					child.EvaluateStateMachine = false
				elseif childName:IsA("BasePart") and child:IsA("BasePart") then
					child.Anchored = false
					child.CanCollide = false
					child.CFrame = childName.CFrame

					local WeldConstraint = Instance.new("WeldConstraint")

					WeldConstraint.Part0 = childName
					WeldConstraint.Part1 = child
					WeldConstraint.Parent = child
				end
			end
		end

		clone.Parent = p3

		return clone
	end,
	GetRig = function(p5, p6, p7) -- line: 97
		if p7 and p7.GetRig then
			local t1 = {
				Folder = p5.ActorFolder,
				SkinFolder = p5.SkinFolder,
				ActorName = p5.ActorName,
				ActorSkin = p5.SkinName,
				Config = p6,
				Behavior = p7
			}
			local ok, result = pcall(p7.GetRig, p7, t1)

			if ok and result and typeof(result) == "Instance" and result:IsA("Model") then
				if result.Parent then
					result = result:Clone()
				end

				return result, nil
			end
		end

		local clone = nil
		local Rig = p5.SkinFolder:FindFirstChild("Rig")

		if Rig and Rig:IsA("Model") then
			clone = Rig:Clone()
		elseif p5.ActorFolder then
			local Rig2 = p5.ActorFolder:FindFirstChild("Rig")

			if Rig2 and Rig2:IsA("Model") then
				clone = Rig2:Clone()
			end
		end

		if clone and p6.LifeAppearances and p6.LifeAppearances[1] then
			local v34 = p6.LifeAppearances[1]

			if v34:IsA("Folder") then
				v34 = v34:GetChildren()[1]
			end

			if v34 and v34:IsA("Model") then
				return clone, v34
			end
		end

		return clone, nil
	end,
	GetMergedConfig = function(p8) -- line: 142
		-- upvalues: Util (copy)
		local v36 = p8.ActorFolder and p8.ActorFolder:FindFirstChild("Config")
		local v37 = v36 and Util:CopyTable(require(v36)) or {}
		local Config = p8.SkinFolder:FindFirstChild("Config")
		local v39 = Config and require(Config)

		if v39 then
			v37 = Util:MergeTables(v37, v39, {
				"DisplayName",
				"TextInteractions"
			})
		end

		return v37
	end,
	SanitizeRig = function(p9) -- line: 156
		for _, descendant in p9:GetDescendants() do
			if descendant:IsA("BaseScript") then
				descendant:Destroy()
			end
		end

		local Pants = p9:FindFirstChildOfClass("Pants")

		if Pants and Pants.PantsTemplate == "" then
			Pants.PantsTemplate = Pants:GetAttribute("ID") or ""
		end

		local Shirt = p9:FindFirstChildOfClass("Shirt")

		if Shirt and Shirt.ShirtTemplate == "" then
			Shirt.ShirtTemplate = Shirt:GetAttribute("ID") or ""
		end

		local ShirtGraphic = p9:FindFirstChildOfClass("ShirtGraphic")

		if ShirtGraphic then
			ShirtGraphic.Graphic = ShirtGraphic:GetAttribute("ID") or ShirtGraphic.Graphic
		end
	end,
	ApplyExpression = function(p10, p11) -- line: 179
		-- upvalues: ReplicatedStorage (copy)
		local v48 = p11[`Expressions{ p10.Name }`] or p11.Expressions

		if not v48 then
			return
		end

		local Head = p10:FindFirstChild("Head")

		if not Head or Head:FindFirstChild("face") then
			return
		end

		local ExpressionHolder = p10:FindFirstChild("ExpressionHolder", true)

		if not ExpressionHolder then
			ExpressionHolder = ReplicatedStorage.Assets.Instances.ExpressionHolder:Clone()
			ExpressionHolder.Parent = p10
			ExpressionHolder.CFrame = Head.CFrame * CFrame.new(0, 0, -0.005)

			local WeldConstraint = Instance.new("WeldConstraint")

			WeldConstraint.Part0 = Head
			WeldConstraint.Part1 = ExpressionHolder
			WeldConstraint.Parent = ExpressionHolder
		end

		local v52 = ExpressionHolder:FindFirstChildOfClass("Decal") or Instance.new("Decal")

		v52.Name = "Expression"
		v52.Parent = ExpressionHolder
		v52.Texture = v48.Default or ""
	end,
	PlayIdleAnimation = function(p12, p13) -- line: 209
		-- upvalues: Util (copy)
		local Humanoid = p12:FindFirstChildOfClass("Humanoid")

		if not Humanoid then
			Humanoid = Instance.new("Humanoid")
			Humanoid.Parent = p12
		end;

		(Humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator")).Parent = Humanoid

		local v56 = p13.Animations and p13.Animations.Idle or "rbxassetid://130854198026585"

		if not v56 then
			return nil
		end

		local v57 = Util:LoadAnimationFromID(p12, v56)

		if v57 then
			v57.Looped = true
			v57.Priority = Enum.AnimationPriority.Idle
			v57:Play(0)
		end

		return v57
	end,
	GetVisibleBoundingBox = function(p14) -- line: 234
		local v59 = p14:FindFirstChild("HumanoidRootPart") or p14.PrimaryPart
		local Position

		if v59 then
			Position = v59.Position
		else
			local vector3 = Vector3.new(0, 0, 0)
			local n1 = 0

			for _, descendant in p14:GetDescendants() do
				if descendant:IsA("BasePart") and descendant.Transparency < 1 and not descendant:GetAttribute("Hitbox") then
					vector3 += descendant.Position
					n1 += 1
				end
			end

			Position = n1 > 0 and vector3 / n1 or Vector3.new(0, 0, 0)
		end

		local t2 = {}

		for _, descendant in p14:GetDescendants() do
			if descendant:IsA("BasePart") and not (descendant.Transparency >= 1) and not descendant:GetAttribute("Hitbox") then
				local Magnitude = (descendant.Position - Position).Magnitude

				table.insert(t2, {
					part = descendant,
					distance = Magnitude
				})
			end
		end

		if #t2 == 0 then
			return p14:GetBoundingBox()
		end

		table.sort(t2, function(p15, p16) -- line: 265
			return p15.distance < p16.distance
		end)

		local n2 = 1e999

		for i = 2, #t2 do
			local distance = t2[i - 1].distance
			local v72 = t2[i].distance - distance

			if distance >= 8 and v72 > distance * 1.5 then
				n2 = distance

				break
			end
		end

		if n2 == 1e999 then
			n2 = math.max(t2[math.ceil(#t2 / 2)].distance * 3, 8)
		end

		local v73 = math.min(n2, 20)
		local n3 = 1e999
		local n4 = 1e999
		local n5 = 1e999
		local n6 = -1e999
		local n7 = -1e999
		local n8 = -1e999
		local v80 = false

		for _, v82 in t2 do
			if not (v73 < v82.distance) then
				local part = v82.part
				local partCFrame = part.CFrame
				local partSize = part.Size

				for i = -1, 1, 2 do
					for j = -1, 1, 2 do
						for k = -1, 1, 2 do
							local v89 = partCFrame * Vector3.new(i * partSize.X / 2, j * partSize.Y / 2, k * partSize.Z / 2)

							if n3 > v89.X then
								n3 = v89.X
							end

							if n4 > v89.Y then
								n4 = v89.Y
							end

							if n5 > v89.Z then
								n5 = v89.Z
							end

							if n6 < v89.X then
								n6 = v89.X
							end

							if n7 < v89.Y then
								n7 = v89.Y
							end

							if n8 < v89.Z then
								n8 = v89.Z
							end
						end
					end
				end

				v80 = true
			end
		end

		if not v80 then
			return p14:GetBoundingBox()
		end

		local vector3 = Vector3.new((n3 + n6) / 2, (n4 + n7) / 2, (n5 + n8) / 2)
		local vector3_2 = Vector3.new(n6 - n3, n7 - n4, n8 - n5)

		return CFrame.new(vector3), vector3_2
	end
}

