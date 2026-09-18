local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")
local DataStoreService = game:GetService("DataStoreService")
local RunService = game:GetService("RunService")

local Config = require(ReplicatedStorage.Shared.GameConfig)
local profileStore
local dataStoreReady = false
if not RunService:IsStudio() then
	profileStore = DataStoreService:GetDataStore("NeonCourierProfilesV1")
	dataStoreReady = true
end

local remotes = Instance.new("Folder")
remotes.Name = "Remotes"
remotes.Parent = ReplicatedStorage

local stateEvent = Instance.new("RemoteEvent")
stateEvent.Name = "StateChanged"
stateEvent.Parent = remotes

local toastEvent = Instance.new("RemoteEvent")
toastEvent.Name = "Toast"
toastEvent.Parent = remotes

local profiles = {}
local roundEndsAt = 0
local roundScores = {}
local coreParts = {}

local function reportStartup(message)
	warn("Neon Courier: " .. message)
	local marker = Instance.new("StringValue")
	marker.Name = "NeonCourierStartupError"
	marker.Value = message
	marker.Parent = ReplicatedStorage
end

local function createPart(name, size, position, color, material)
	local part = Instance.new("Part")
	part.Name = name
	part.Size = size
	part.Position = position
	part.Anchored = true
	part.Color = color
	part.Material = material or Enum.Material.SmoothPlastic
	part.TopSurface = Enum.SurfaceType.Smooth
	part.BottomSurface = Enum.SurfaceType.Smooth
	part.Parent = workspace
	return part
end

local function buildMap()
	local map = workspace:FindFirstChild("NeonCourierMap")
	if not map then
		map = Instance.new("Folder")
		map.Name = "NeonCourierMap"
		map.Parent = workspace
	end

	createPart("Arena", Vector3.new(180, 2, 120), Vector3.new(0, -1, 0), Color3.fromRGB(11, 17, 34), Enum.Material.Slate).Parent = map
	createPart("NorthWall", Vector3.new(180, 24, 2), Vector3.new(0, 11, -60), Color3.fromRGB(23, 37, 66), Enum.Material.Neon).Parent = map
	createPart("SouthWall", Vector3.new(180, 24, 2), Vector3.new(0, 11, 60), Color3.fromRGB(23, 37, 66), Enum.Material.Neon).Parent = map
	createPart("WestWall", Vector3.new(2, 24, 120), Vector3.new(-90, 11, 0), Color3.fromRGB(23, 37, 66), Enum.Material.Neon).Parent = map
	createPart("EastWall", Vector3.new(2, 24, 120), Vector3.new(90, 11, 0), Color3.fromRGB(23, 37, 66), Enum.Material.Neon).Parent = map

	local reactor = createPart("Reactor", Vector3.new(20, 8, 20), Vector3.new(0, 4, 0), Color3.fromRGB(255, 65, 180), Enum.Material.Neon)
	reactor.Parent = map
	local prompt = Instance.new("ProximityPrompt")
	prompt.ActionText = "Deliver cores"
	prompt.ObjectText = "Central reactor"
	prompt.HoldDuration = 0.35
	prompt.MaxActivationDistance = 14
	prompt.Parent = reactor
	prompt.Triggered:Connect(function(player)
		local profile = profiles[player]
		if not profile or profile.carried <= 0 then
			toastEvent:FireClient(player, "Collect energy cores first.", Color3.fromRGB(255, 180, 120))
			return
		end
		local delivered = profile.carried
		profile.carried = 0
		profile.delivered += delivered
		profile.credits += delivered * Config.CoreValue * (profile.boostUntil > os.time() and Config.BoostMultiplier or 1)
		roundScores[player] = (roundScores[player] or 0) + delivered
		toastEvent:FireClient(player, string.format("+%d cores delivered!", delivered), Color3.fromRGB(100, 255, 190))
		stateEvent:FireClient(player, profile)
	end)

	local spawn = Instance.new("SpawnLocation")
	spawn.Name = "CourierSpawn"
	spawn.Size = Vector3.new(8, 1, 8)
	spawn.Position = Vector3.new(0, 1, 35)
	spawn.Anchored = true
	spawn.Neutral = true
	spawn.Color = Color3.fromRGB(75, 230, 255)
	spawn.Parent = map

	for index = 1, Config.CoreGoal do
		local angle = (index / Config.CoreGoal) * math.pi * 2
		local core = createPart("EnergyCore" .. index, Vector3.new(2, 2, 2), Vector3.new(math.cos(angle) * 62, 3, math.sin(angle) * 38), Color3.fromRGB(255, 218, 72), Enum.Material.Neon)
		core.Shape = Enum.PartType.Ball
		core.CanCollide = false
		core.Parent = map
		local corePrompt = Instance.new("ProximityPrompt")
		corePrompt.ActionText = "Pick up"
		corePrompt.ObjectText = "Energy core"
		corePrompt.HoldDuration = 0.15
		corePrompt.MaxActivationDistance = 10
		corePrompt.Parent = core
		corePrompt.Triggered:Connect(function(player)
			local profile = profiles[player]
			if not profile or profile.carried >= Config.CoreGoal then
				return
			end
			corePrompt.Enabled = false
			core.Transparency = 1
			profile.carried += 1
			stateEvent:FireClient(player, profile)
			task.delay(Config.CoreRespawnSeconds, function()
				if core.Parent then
					core.Transparency = 0
					corePrompt.Enabled = true
				end
			end)
		end)
		table.insert(coreParts, core)
	end
end

local function safeProfile(player)
	local profile = { credits = Config.StartingCredits, carried = 0, delivered = 0, boostUntil = 0 }
	local success, saved
	if dataStoreReady then
		success, saved = pcall(function()
			return profileStore:GetAsync("player_" .. player.UserId)
		end)
		if not success then
			warn(string.format("Neon Courier: failed to load profile for %s", player.UserId))
		end
	end
	if success and type(saved) == "table" then
		profile.credits = tonumber(saved.credits) or profile.credits
	end
	profiles[player] = profile
	roundScores[player] = 0
	return profile
end

local function saveProfile(player)
	local profile = profiles[player]
	if not profile or not dataStoreReady then return end
	local success = pcall(function()
		profileStore:UpdateAsync("player_" .. player.UserId, function(previous)
			previous = type(previous) == "table" and previous or {}
			previous.credits = profile.credits
			return previous
		end)
	end)
	if not success then
		warn(string.format("Neon Courier: failed to save profile for %s", player.UserId))
	end
end

local function beginRound()
	roundScores = {}
	roundEndsAt = os.time() + Config.RoundSeconds
	for player, profile in pairs(profiles) do
		profile.carried = 0
		profile.delivered = 0
		roundScores[player] = 0
		stateEvent:FireClient(player, profile, roundEndsAt)
		toastEvent:FireClient(player, "New delivery run! Bring cores to the reactor.", Color3.fromRGB(100, 220, 255))
	end
end

local buildSuccess, buildError = pcall(buildMap)
if not buildSuccess then
	reportStartup("Map build failed: " .. tostring(buildError))
else
	beginRound()
end

Players.PlayerAdded:Connect(function(player)
	local profile = safeProfile(player)
	stateEvent:FireClient(player, profile, roundEndsAt)
end)

Players.PlayerRemoving:Connect(function(player)
	saveProfile(player)
	profiles[player] = nil
	roundScores[player] = nil
end)

MarketplaceService.ProcessReceipt = function(receipt)
	if receipt.ProductId ~= Config.BoostProductId or Config.BoostProductId == 0 then
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end
	local player = Players:GetPlayerByUserId(receipt.PlayerId)
	if not player or not profiles[player] then
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end
	profiles[player].boostUntil = os.time() + Config.BoostDurationSeconds
	toastEvent:FireClient(player, "2x credit boost activated for 10 minutes!", Color3.fromRGB(255, 220, 90))
	stateEvent:FireClient(player, profiles[player], roundEndsAt)
	return Enum.ProductPurchaseDecision.PurchaseGranted
end

task.spawn(function()
	while true do
		task.wait(1)
		if os.time() >= roundEndsAt then
			for player, score in pairs(roundScores) do
				if player.Parent and score > 0 then
					toastEvent:FireClient(player, string.format("Run complete: %d cores delivered.", score), Color3.fromRGB(190, 160, 255))
				end
			end
			beginRound()
		end
	end
end)

game:BindToClose(function()
	for _, player in Players:GetPlayers() do
		saveProfile(player)
	end
end)
