local map = script.Parent
local CollectionService = game:GetService("CollectionService")

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

local function folder(name)
	local value = map:FindFirstChild(name)
	if not value then
		value = Instance.new("Folder")
		value.Name = name
		value.Parent = map
	end
	return value
end

local bubbleRegions = folder("BubbleSpawnRegions")
local portals = folder("ZonePortals")
local vats = folder("VatLocations")
local spawns = folder("PlayerSpawns")
local props = folder("LowPolyProps")

local function taggedPart(parent, name, size, position, color, material, tag)
	local value = part(name, size, position, color, material)
	value.Parent = parent
	CollectionService:AddTag(value, tag)
	return value
end

local function zone(name, center, color, subtitle)
	local pad = taggedPart(props, name .. "Platform", Vector3.new(34, 1, 28), center, color, Enum.Material.Slate, "ZonePlatform")
	pad.Transparency = 0.08
	local portal = taggedPart(portals, name .. "Portal", Vector3.new(5, 10, 2), center + Vector3.new(0, 5, 12), color, Enum.Material.Neon, "ZonePortal")
	local light = Instance.new("PointLight")
	light.Color = color
	light.Range = 28
	light.Brightness = 2
	light.Parent = portal
	local sign = taggedPart(props, name .. "Sign", Vector3.new(26, 5, 0.5), center + Vector3.new(0, 8, 10), Color3.fromRGB(12, 16, 34), Enum.Material.Metal, "ZoneSign")
	local surface = Instance.new("SurfaceGui")
	surface.Face = Enum.NormalId.Front
	surface.AlwaysOnTop = true
	surface.Parent = sign
	local label = Instance.new("TextLabel")
	label.Size = UDim2.fromScale(1, 1)
	label.BackgroundTransparency = 1
	label.Text = name:upper() .. "\n" .. subtitle
	label.TextColor3 = color
	label.TextScaled = true
	label.Font = Enum.Font.GothamBlack
	label.Parent = surface
	local region = taggedPart(bubbleRegions, name .. "BubbleField", Vector3.new(28, 0.3, 20), center + Vector3.new(0, 1, -4), color, Enum.Material.Neon, "BubbleSpawnRegion")
	region.Transparency = 0.82
	region.CanCollide = false
end

-- Static landmarks stay separate from gameplay scripts so Studio designers can move them safely.
local hub = taggedPart(props, "RaisedGoblinHub", Vector3.new(52, 3, 42), Vector3.new(0, 2, 0), purple, Enum.Material.Slate, "Hub")
hub.Transparency = 0.1
for _, path in ipairs({
	{"GaragePath", Vector3.new(-42, 0.2, 0), Vector3.new(70, 0.25, 5), Color3.fromRGB(255, 150, 60)},
	{"SwampPath", Vector3.new(0, 0.2, -42), Vector3.new(5, 0.25, 70), Color3.fromRGB(70, 220, 130)},
	{"ForestPath", Vector3.new(42, 0.2, 0), Vector3.new(70, 0.25, 5), Color3.fromRGB(100, 180, 255)},
	{"LagoonPath", Vector3.new(0, 0.2, 42), Vector3.new(5, 0.25, 70), Color3.fromRGB(60, 220, 255)},
}) do
	taggedPart(props, path[1], path[3], path[2], path[4], Enum.Material.Neon, "ZonePath")
end
zone("Goblin Garage", Vector3.new(-64, 2, 0), Color3.fromRGB(255, 150, 60), "FIX IT WITH JUICE")
zone("Static Swamp", Vector3.new(0, 2, -55), Color3.fromRGB(70, 220, 130), "DO NOT LICK THE FOG")
zone("Error Forest", Vector3.new(64, 2, 0), Color3.fromRGB(100, 180, 255), "TREES HAVE COMMIT RIGHTS")
zone("Lag Lagoon", Vector3.new(0, 2, 55), Color3.fromRGB(60, 220, 255), "BUFFERING SINCE 1999")
zone("Forbidden Server Room", Vector3.new(58, 2, -42), Color3.fromRGB(255, 80, 160), "AUTHORIZED GOBLINS ONLY")
taggedPart(vats, "CentralJuiceVatLocation", Vector3.new(8, 0.25, 8), Vector3.new(0, 3.65, 0), pink, Enum.Material.Neon, "VatLocation")
taggedPart(spawns, "MainPlayerSpawn", Vector3.new(12, 0.25, 12), Vector3.new(0, 4, 42), cyan, Enum.Material.Neon, "PlayerSpawn")

for index, item in ipairs({
	{"GarageCrate", Vector3.new(-70, 5, -8), Color3.fromRGB(255, 150, 60), Enum.PartType.Block},
	{"SwampCrystal", Vector3.new(-8, 5, -55), Color3.fromRGB(70, 220, 130), Enum.PartType.Wedge},
	{"ForestPine", Vector3.new(70, 6, 8), Color3.fromRGB(100, 180, 255), Enum.PartType.Cylinder},
	{"LagBuoy", Vector3.new(8, 5, 58), Color3.fromRGB(60, 220, 255), Enum.PartType.Ball},
	{"ServerRack", Vector3.new(58, 7, -52), Color3.fromRGB(255, 80, 160), Enum.PartType.Block},
}) do
	local prop = taggedPart(props, item[1], Vector3.new(6, 6, 6), item[2], item[3], Enum.Material.SmoothPlastic, "LowPolyProp")
	prop.Shape = item[4]
end

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
label.Text = "GLITCH GOBLIN SIMULATOR\nABSORB  •  JUICE  •  UPGRADE"
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
local atmosphere = lighting:FindFirstChildOfClass("Atmosphere") or Instance.new("Atmosphere")
atmosphere.Name = "GoblinNeonAtmosphere"
atmosphere.Density = 0.28
atmosphere.Offset = 0.15
atmosphere.Color = Color3.fromRGB(120, 150, 255)
atmosphere.Decay = Color3.fromRGB(30, 20, 70)
atmosphere.Glare = 0.12
atmosphere.Haze = 1.1
atmosphere.Parent = lighting
