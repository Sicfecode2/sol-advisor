local map = script.Parent

local function part(name, size, position, color, material)
	local value = Instance.new("Part")
	value.Name = name
	value.Size = size
	value.Position = position
	value.Anchored = true
	value.Color = color
	value.Material = material
	value.TopSurface = Enum.SurfaceType.Smooth
	value.BottomSurface = Enum.SurfaceType.Smooth
	value.Parent = map
	return value
end

local dark = Color3.fromRGB(11, 17, 34)
local blue = Color3.fromRGB(23, 37, 66)
local cyan = Color3.fromRGB(75, 230, 255)
local pink = Color3.fromRGB(255, 65, 180)

part("Arena", Vector3.new(180, 2, 120), Vector3.new(0, -1, 0), dark, Enum.Material.Slate)
part("NorthWall", Vector3.new(180, 24, 2), Vector3.new(0, 11, -60), blue, Enum.Material.Neon)
part("SouthWall", Vector3.new(180, 24, 2), Vector3.new(0, 11, 60), blue, Enum.Material.Neon)
part("WestWall", Vector3.new(2, 24, 120), Vector3.new(-90, 11, 0), blue, Enum.Material.Neon)
part("EastWall", Vector3.new(2, 24, 120), Vector3.new(90, 11, 0), blue, Enum.Material.Neon)
part("Reactor", Vector3.new(20, 8, 20), Vector3.new(0, 4, 0), pink, Enum.Material.Neon)
part("SpawnPlatform", Vector3.new(12, 1, 12), Vector3.new(0, 1, 35), cyan, Enum.Material.Neon)

for index = 1, 10 do
	local angle = (index / 10) * math.pi * 2
	local x = math.cos(angle) * 62
	local z = math.sin(angle) * 38
	local core = part("EnergyCore" .. index, Vector3.new(3, 3, 3), Vector3.new(x, 3, z), Color3.fromRGB(255, 218, 72), Enum.Material.Neon)
	core.Shape = Enum.PartType.Ball
	core.CanCollide = false
end

local sign = part("WelcomeSign", Vector3.new(42, 10, 1), Vector3.new(0, 13, 48), Color3.fromRGB(20, 28, 55), Enum.Material.Neon)
local surface = Instance.new("SurfaceGui")
surface.Face = Enum.NormalId.Front
surface.Parent = sign
local label = Instance.new("TextLabel")
label.Size = UDim2.fromScale(1, 1)
label.BackgroundTransparency = 1
label.Font = Enum.Font.GothamBlack
label.Text = "NEON COURIER\nCOLLECT  •  DELIVER  •  EARN"
label.TextColor3 = Color3.fromRGB(91, 232, 255)
label.TextScaled = true
label.Parent = surface
