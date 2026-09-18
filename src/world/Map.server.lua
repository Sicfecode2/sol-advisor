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
local purple = Color3.fromRGB(119, 76, 255)
local gold = Color3.fromRGB(255, 190, 65)
local black = Color3.fromRGB(5, 8, 20)

local arena = part("Arena", Vector3.new(180, 2, 120), Vector3.new(0, -1, 0), dark, Enum.Material.SmoothPlastic)
arena.Reflectance = 0.1
part("NorthWall", Vector3.new(180, 24, 2), Vector3.new(0, 11, -60), blue, Enum.Material.SmoothPlastic)
part("SouthWall", Vector3.new(180, 24, 2), Vector3.new(0, 11, 60), blue, Enum.Material.SmoothPlastic)
part("WestWall", Vector3.new(2, 24, 120), Vector3.new(-90, 11, 0), blue, Enum.Material.SmoothPlastic)
part("EastWall", Vector3.new(2, 24, 120), Vector3.new(90, 11, 0), blue, Enum.Material.SmoothPlastic)

for x = -80, 80, 20 do
	part("FloorGlowX" .. x, Vector3.new(1, 0.15, 112), Vector3.new(x, 0.12, 0), purple, Enum.Material.Neon)
end
for z = -50, 50, 20 do
	part("FloorGlowZ" .. z, Vector3.new(164, 0.15, 1), Vector3.new(0, 0.14, z), cyan, Enum.Material.Neon)
end

for index, position in ipairs({
	Vector3.new(-72, 8, -45), Vector3.new(72, 8, -45),
	Vector3.new(-72, 8, 45), Vector3.new(72, 8, 45),
}) do
	local tower = part("Beacon" .. index, Vector3.new(5, 16, 5), position, purple, Enum.Material.Neon)
	local light = Instance.new("PointLight")
	light.Color = index % 2 == 0 and cyan or pink
	light.Range = 28
	light.Brightness = 3
	light.Parent = tower
end

local reactorPad = part("ReactorPad", Vector3.new(30, 1, 30), Vector3.new(0, 0.5, 0), black, Enum.Material.Metal)
local reactor = part("Reactor", Vector3.new(16, 6, 16), Vector3.new(0, 5, 0), pink, Enum.Material.Neon)
local reactorLight = Instance.new("PointLight")
reactorLight.Color = pink
reactorLight.Range = 35
reactorLight.Brightness = 5
reactorLight.Parent = reactor
for radius = 12, 20, 4 do
	local ring = part("ReactorRing" .. radius, Vector3.new(radius, 0.35, 1), Vector3.new(0, 1.2, 0), gold, Enum.Material.Neon)
	ring.Shape = Enum.PartType.Cylinder
	ring.Orientation = Vector3.new(0, 0, 90)
end

local spawnPad = part("SpawnPlatform", Vector3.new(18, 1, 18), Vector3.new(0, 1, 42), cyan, Enum.Material.Neon)
local spawnLight = Instance.new("PointLight")
spawnLight.Color = cyan
spawnLight.Range = 24
spawnLight.Brightness = 3
spawnLight.Parent = spawnPad

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

local lighting = game:GetService("Lighting")
lighting.ClockTime = 0
lighting.Brightness = 2
lighting.Ambient = Color3.fromRGB(35, 42, 86)
lighting.OutdoorAmbient = Color3.fromRGB(10, 14, 35)
lighting.FogColor = Color3.fromRGB(9, 14, 35)
lighting.FogEnd = 260
