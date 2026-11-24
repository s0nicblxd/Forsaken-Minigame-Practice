local vm={}
local function v(x,y,z)return setmetatable({X=x,Y=y,Z=z},vm)end
function vm.__sub(a,b)return v(a.X-b.X,a.Y-b.Y,a.Z-b.Z)end
local Vector3={new=v}
local Root={Position=v(10,20,30),Size=v(2,2,2)}
local v148={Position=v(0,-100,0)}
local v149={Position=v(0,-100,0)}
local function syncRadiusPositions() -- line: 1662
					-- upvalues: v148 (copy), Root (copy), v149 (copy)
					if v148 then
						v148.Position = Root.Position - Vector3.new(0, Root.Size.Y / 2 + 0.075, 0)
					end

					if v149 then
						v149.Position = Root.Position - Vector3.new(0, Root.Size.Y / 2, 0)
					end
				end

				syncRadiusPositions()
				
assert(v148.Position.X==10 and v148.Position.Z==30 and math.abs(v148.Position.Y-18.925)<1e-6)
assert(v149.Position.Y==19 and v149.Position.X==10)
Root.Position=v(40,50,60);syncRadiusPositions()
assert(v148.Position.X==40 and v149.Position.Z==60)
print("PASS actual replacement-zone setup: initial coordinates assigned immediately without waiting for movement, later positions remain synchronized")
